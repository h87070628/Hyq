<?php
	//	../php/comment.php?index="+"1"+"&user="+"NULL"+"&comment="+"comment..comment..hello world.
	
	error_reporting(E_ALL);	//打开所有的错误日志.

	/*
	$index=$_GET["index"];
	$user=$_GET["user"];
	$comment=$_GET["comment"];
	*/

	//error_log($_POST["index"].$_POST["user"].$_POST["comment"]);
	error_log($_POST["index"]."][".$_POST["user"]."][".$_POST["comment"]);

	$arr_1 = array('t_date'=>'You are ...');
	$json_string = json_encode($arr_1);		//序列化json对象.
	$response=$json_string;				
	echo $response;					//返回json对象.

	//error_log($index.$user.$comment);
?>
