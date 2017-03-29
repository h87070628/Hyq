#include "skynet.h"
#include "skynet_server.h"
#include "skynet_imp.h"
#include "skynet_mq.h"
#include "skynet_handle.h"
#include "skynet_module.h"
#include "skynet_timer.h"
#include "skynet_monitor.h"
#include "skynet_socket.h"
#include "skynet_daemon.h"
#include "skynet_harbor.h"

#include <pthread.h>
#include <unistd.h>
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>

struct monitor {
	int count;
	struct skynet_monitor ** m;
	pthread_cond_t cond;
	pthread_mutex_t mutex;
	int sleep;
	int quit;
};

struct worker_parm {
	struct monitor *m;
	int id;
	int weight;
};

static int SIG = 0;

static void
handle_hup(int signal) {
	if (signal == SIGHUP) {
		SIG = 1;
	}
}

#define CHECK_ABORT if (skynet_context_total()==0) break;

static void
create_thread(pthread_t *thread, void *(*start_routine) (void *), void *arg) {
	if (pthread_create(thread,NULL, start_routine, arg)) {
		fprintf(stderr, "Create thread failed");
		exit(1);
	}
}

static void
wakeup(struct monitor *m, int busy) {
	if (m->sleep >= m->count - busy) {
		// signal sleep worker, "spurious wakeup" is harmless
		pthread_cond_signal(&m->cond);
	}
}

static void *
thread_socket(void *p) {
	struct monitor * m = p;
	//设置线程内的全局变量,同一线程内全局可见变量,key = 节点编号, value = uint(-2)
	skynet_initthread(THREAD_SOCKET);
	for (;;) {
		//不断的检查网络接口的状态,处理网络消息
		int r = skynet_socket_poll();
		if (r==0)
			//程序退出
			break;
		if (r<0) {
			//发生异常,检查当前服务数是否为0,为0时,跳出循环,退出网络线程
			CHECK_ABORT
			continue;
		}
		//当所有线程都处于休眠状态时, 触发条件变量,以唤醒一个线程
		wakeup(m,0);
	}
	return NULL;
}

static void
free_monitor(struct monitor *m) {
	int i;
	int n = m->count;
	for (i=0;i<n;i++) {
		skynet_monitor_delete(m->m[i]);
	}
	pthread_mutex_destroy(&m->mutex);
	pthread_cond_destroy(&m->cond);
	skynet_free(m->m);
	skynet_free(m);
}

//监控线程
static void *
thread_monitor(void *p) {
	struct monitor * m = p;
	int i;
	int n = m->count;
	//设置线程内的全局变量,同一线程内全局可见变量,key = 节点编号, value = uint(-4)
	skynet_initthread(THREAD_MONITOR);
	for (;;) {
		//检查当前服务数是否为0,为0时,跳出循环,退出监控线程
		CHECK_ABORT
		for (i=0;i<n;i++) {
			//检查是否陷入死循环
			skynet_monitor_check(m->m[i]);
		}
		for (i=0;i<5;i++) {
			CHECK_ABORT
			sleep(1);
		}
	}

	return NULL;
}

static void
signal_hup() {
	// make log file reopen

	struct skynet_message smsg;
	smsg.source = 0;
	smsg.session = 0;
	smsg.data = NULL;
	smsg.sz = (size_t)PTYPE_SYSTEM << MESSAGE_TYPE_SHIFT;
	uint32_t logger = skynet_handle_findname("logger");
	if (logger) {
		skynet_context_push(logger, &smsg);
	}
}

//定时器线程
static void *
thread_timer(void *p) {
	struct monitor * m = p;

	//设置线程内的全局变量,同一线程内全局可见变量,key = 节点编号, value = uint(-3)
	skynet_initthread(THREAD_TIMER);
	for (;;) {
		//更新框架定时器时间,当时间到达时候,将定时消息插入到指定服务的消息队列中
		skynet_updatetime();
		//检查服务数量是否为0,为0则跳出循环,开始线程退出
		CHECK_ABORT
		//当休眠线程大于等于1时,唤醒一个线程
		wakeup(m,m->count-1);
		//等待2500微妙,2500/1000000秒
		usleep(2500);
		//处理系统中断信号
		if (SIG) {
			signal_hup();
			SIG = 0;
		}
	}
	// wakeup socket thread
	// 唤醒socket线程以便退出
	skynet_socket_exit();

	// wakeup all worker thread
	// 设置退出标记,唤醒全部的等待线程
	pthread_mutex_lock(&m->mutex);
	m->quit = 1;
	pthread_cond_broadcast(&m->cond);
	pthread_mutex_unlock(&m->mutex);
	return NULL;
}

static void *
thread_worker(void *p) {
	struct worker_parm *wp = p;

	//取出创建参数
	int id = wp->id;
	int weight = wp->weight;
	struct monitor *m = wp->m;
	struct skynet_monitor *sm = m->m[id];

	//设置线程内的全局变量,同一线程内全局可见变量,key = 节点编号, value = uint(-0)
	skynet_initthread(THREAD_WORKER);
	//消息队列指针
	struct message_queue * q = NULL;

	//线程启动以后,当退出标记不为0时,开始循环调度
	while (!m->quit) {
		//不断从全局消息队列获取消息,并将消息分发对应的服务中处理
		q = skynet_context_message_dispatch(sm, q, weight);
		if (q == NULL) {
			//没有消息时,尝试锁定互斥锁.
			if (pthread_mutex_lock(&m->mutex) == 0) {
				//睡眠数量+1
				++ m->sleep;
				// "spurious wakeup" is harmless,
				// because skynet_context_message_dispatch() can be call at any time.
				
				// 当退出标记不为0时,将线程挂起等待, 并将互斥锁解锁, 等待条件变量信号被触发
				if (!m->quit)
					pthread_cond_wait(&m->cond, &m->mutex);
				// 当条件变量信号被触发以后,会自动加锁互斥锁,然后继续执行下面的代码.
				// 睡眠数量-1
				-- m->sleep;
				// 解锁互斥锁,如果失败就退出
				if (pthread_mutex_unlock(&m->mutex)) {
					fprintf(stderr, "unlock mutex error");
					exit(1);
				}
			}
		}
	}
	return NULL;
}

static void
start(int thread) {
	//定义多个线程,线程数 + 3
	pthread_t pid[thread+3];

	//初始化监控结构体
	struct monitor *m = skynet_malloc(sizeof(*m));
	memset(m, 0, sizeof(*m));
	m->count = thread;
	m->sleep = 0;

	//申请线程数*指针大小的空间
	m->m = skynet_malloc(thread * sizeof(struct skynet_monitor *));
	int i;
	for (i=0;i<thread;i++) {
		//将指针指向申请的内存空间
		m->m[i] = skynet_monitor_new();
	}

	//初始化互斥锁,保证同一时刻只有一个线程能执行关键代码,其他线程都被锁定,直到互斥锁被属主释放
	if (pthread_mutex_init(&m->mutex, NULL)) {
		fprintf(stderr, "Init mutex error");
		exit(1);
	}
	
	/*
	pthread_mutex_t mutex;  ///< 互斥锁
	pthread_cond_t  cond;   ///< 条件变量
	bool test_cond = false;
	/// TODO 初始化mutex和cond
	/// thread 1:
	pthread_mutex_lock(&mutex);            	///< 1
	while (!test_cond)
	{
	    pthread_cond_wait(&cond, &mutex);  	///< 2(解锁mutex), 5(线程唤醒,立即加锁mutex)
	}
	pthread_mutex_unlock(&mutex);          	///< 6
	RunThread1Func();			//线程1必须先执行,使条件变量被阻塞,等待

	/// thread 2:
	pthread_mutex_lock(&mutex);            	///< 3
	test_cond = true;
	pthread_cond_signal(&cond);		//释放条件变量
	pthread_mutex_unlock(&mutex);          	///< 4
	/// TODO 销毁mutex和cond
	
	//执行序列为1,2,3,4,5,6
	*/

	//初始化条件变量,配合互斥锁使用,wait函数调用过程会解锁,加锁互斥锁
	if (pthread_cond_init(&m->cond, NULL)) {
		fprintf(stderr, "Init cond error");
		exit(1);
	}

	//以m为参数, 创建全局3个线程(监控,定时器,网络).
	//检查服务是否陷入死循环
	create_thread(&pid[0], thread_monitor, m);
	//创建定时器线程(维护框架定时器,定时的触发条件变量)
	create_thread(&pid[1], thread_timer, m);
	//创建网络线程
	create_thread(&pid[2], thread_socket, m);

	//创建工作线程
	static int weight[] = { 
		-1, -1, -1, -1, 0, 0, 0, 0,
		1, 1, 1, 1, 1, 1, 1, 1, 
		2, 2, 2, 2, 2, 2, 2, 2, 
		3, 3, 3, 3, 3, 3, 3, 3, };

	/*
	struct worker_parm {
		struct monitor *m;
		int id;
		int weight;
	};
	*/
	struct worker_parm wp[thread];
	//遍历所有线程,设置id以及weight
	for (i=0;i<thread;i++) {
		wp[i].m = m;
		wp[i].id = i;
		if (i < sizeof(weight)/sizeof(weight[0])) {
			wp[i].weight= weight[i];
		} else {
			wp[i].weight = 0;
		}

		//创建工作线程,参数包含id以及weight
		create_thread(&pid[i+3], thread_worker, &wp[i]);
	}

	//阻塞当前"主线程",等待所有"子线程"结束,在进行资源回收
	for (i=0;i<thread+3;i++) {
		pthread_join(pid[i], NULL); 
	}

	//开始资源回收
	free_monitor(m);
}

static void
bootstrap(struct skynet_context * logger, const char * cmdline) {
	int sz = strlen(cmdline);
	char name[sz+1];
	char args[sz+1];
	sscanf(cmdline, "%s %s", name, args);
	struct skynet_context *ctx = skynet_context_new(name, args);
	if (ctx == NULL) {
		skynet_error(NULL, "Bootstrap error : %s\n", cmdline);
		skynet_context_dispatchall(logger);
		exit(1);
	}
}

void 
skynet_start(struct skynet_config * config) {
	// register SIGHUP for log file reopen
	// 收到SIGHUP中断时,重新打开日志文件
	struct sigaction sa;
	sa.sa_handler = &handle_hup;
	sa.sa_flags = SA_RESTART;
	sigfillset(&sa.sa_mask);
	sigaction(SIGHUP, &sa, NULL);

	//如果配置了后台模式
	if (config->daemon) {
		if (daemon_init(config->daemon)) {
			exit(1);
		}
	}
	//设置当前skynet的节点编号,便于实现多节点通信
	skynet_harbor_init(config->harbor);
	//初始化一个handle_storage(服务仓库?)结构
	skynet_handle_init(config->harbor);
	//消息队列初始化,同时初始化其中包含的同步锁
	skynet_mq_init();
	//初始化so动态库
	skynet_module_init(config->module_path);
	//初始化时钟管理器,并设置系统启动时间
	skynet_timer_init();
	//初始化网络套接字管理器
	skynet_socket_init();
	//设置是否统计各服务使用cpu的时间
	skynet_profile_enable(config->profile);

	//启动一个日志服务
	struct skynet_context *ctx = skynet_context_new(config->logservice, config->logger);
	//如果创建失败则退出
	if (ctx == NULL) {
		fprintf(stderr, "Can't launch %s service\n", config->logservice);
		exit(1);
	}

	//解析config文件,根据配置文件设置skynet整个框架的属性,例如单节点或者多节点模式,最后读取config.start字段,启动第一个服务(main)
	bootstrap(ctx, config->bootstrap);

	//上面实例化了两个服务一个log,
	//另一个是bootstrap = "snlua main", bootstrap 其实就是用户自定义的lua脚本,使用snlua来启动, 在这个lua脚本中会通过会启动多个服务
	//目前snlua被创建,并创建了一个服务实例, 并向该实例投递一个消息, 消息就是脚本的名字
	
	//接下来,以线程数为参数调用start函数{TODO}
	start(config->thread);

	// harbor_exit may call socket send, so it should exit before socket_free
	skynet_harbor_exit();
	skynet_socket_free();
	if (config->daemon) {
		daemon_exit(config->daemon);
	}
}
