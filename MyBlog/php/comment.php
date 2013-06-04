<?php
	error_reporting(E_ALL);	//打开所有的错误日志.
	require './connect_mysql.php';

	error_log($_POST["index"]."][".$_POST["user"]."][".$_POST["comment"]);
	
	//写入数据库.
	connect_sql();
	$sql_data = query_sql("show databases;");
 	close_sql();

	//返回插入的评论.
	$arr_1 = array('t_date'=>'You are ...');
	$json_string = json_encode($arr_1);		//序列化json对象.
	$response=$json_string;				
	echo $response;					//返回json对象.

	//error_log($index.$user.$comment);
?>
