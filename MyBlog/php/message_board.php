
<?php
//载入数据库操作函数.
require './connect_mysql.php';

error_reporting(E_ALL);	//打开所有的错误日志.

//获得来自 URL 的 q 参数
$u=$_POST["userName"];
$p=$_POST["psw"];

error_log("xxx".$u."yyy".$p);

//入库操作.
$temp_t = connect_sql();
error_log($temp_t);

//$sql_data = query_sql("insert into comment values(NULL,$page_index,'$comment_str',NOW(),$userid);");
//error_log($sql_data);

close_sql();

$arr_1 = array('t_date'=>'You are ...');
$json_string = json_encode($arr_1);		//序列化json对象.
$response=$json_string;				
echo $response;					//返回json对象.
?>
