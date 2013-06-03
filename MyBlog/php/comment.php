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

	//error_log($index.$user.$comment);
?>
