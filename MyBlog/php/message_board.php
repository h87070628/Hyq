
<?php
//获得来自 URL 的 q 参数
error_reporting(E_ALL);	//打开所有的错误日志.

$u=$_POST["userName"];
$p=$_POST["psw"];

error_log("xxx".$u."yyy".$p);

$arr_1 = array('t_date'=>'You are ...');
$json_string = json_encode($arr_1);		//序列化json对象.
$response=$json_string;				
echo $response;					//返回json对象.
?>
