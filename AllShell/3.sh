#!/bin/bash

cat <<HELP

	帮助文件!
HELP

#var= pwd -P;	#获得当前脚本路径.
#echo "${var}"
./1.sh	#执行Shell脚本.

var=$?	#获得上个程序的返回值.

if [ ${var} -eq 3 ]; then
	echo "error: exit is ${var} .";
elif [ ${var} -eq 0 ]; then
	echo "TUEE: exit is 0";
else
	echo "erros: error code is ${var}.";
fi

a=`ls -l`;
echo "${a}"

# 把 ls -l 的结果给 a
# 别忘了,这么引用的话,ls 的结果中的所有空白部分都没了(包括换行)
# 这么引用就正常了,保留了空白
# (具体参阅章节"引用")

b=`uname -v`;
echo "${b}";

echo -n "What is your name: ";
read name;
echo "${name}";
