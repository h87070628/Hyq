
<?php
//载入数据库操作函数.
require './connect_mysql.php';

error_reporting(E_ALL);	//打开所有的错误日志.

//获得来自 URL 的 q 参数
$u=$_POST["userName"];
$str=$_POST["message_str"];

error_log("xxx".$u."yyy".$str);

//入库操作.
$temp_t = connect_sql();
error_log($temp_t);

//$sql_data = query_sql("insert into message_board values(NULL,10000,'$str',NOW());");
//error_log($sql_data);

$result = query_sql("select * from message_board;",$con);                      //执行Sql语句.
                if(mysql_num_rows($result)>=1)
                {
                        $temp = mysql_fetch_array($result);

                        $arr = array('r1'=>$temp[0],'r2'=>$temp[1],'r3'=>$temp[2],'r4'=>$temp[3]);
                        $json_string = json_encode($arr);               //序列化json对象.

                        mysql_free_result($result);                     //释放结果集.
                        $response=$json_string;                         //返回json对象.
                }

close_sql();

$arr_1 = array('t_date'=>'You are ...');
$json_string = json_encode($arr_1);		//序列化json对象.
$response=$json_string;				
error_log($response);
echo $response;					//返回json对象.
?>
