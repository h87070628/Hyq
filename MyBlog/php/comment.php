<?php
	error_reporting(E_ALL);	//打开所有的错误日志.
	require './connect_mysql.php';

	//var param = "page_index="+page_index+"&comment_str="+comment_str+"&userid="+userid;
	//($_POST["page_index"]."][".$_POST["comment_str"]."][".$_POST["userid"]);
	
	$page_index = $_POST["page_index"];
	$comment_str = $_POST["comment_str"];
	$userid = $_POST["userid"];
	
	error_log("insert into comment values(NULL,$page_index,'$comment_str',NOW(),$userid);");

	//写入数据库.
	$temp_t = connect_sql();
	error_log($temp_t);
	$sql_data = query_sql("insert into comment values(NULL,$page_index,'$comment_str',NOW(),$userid);");
	error_log($sql_data);
 	close_sql();

	//返回插入的评论.
	$arr_1 = array('t_date'=>'You are ...');
	$json_string = json_encode($arr_1);		//序列化json对象.
	$response=$json_string;				
	echo $response;					//返回json对象.

	//error_log($index.$user.$comment);
?>
