<?php
error_reporting(E_ALL);	//打开所有的错误日志.
error_log("22222222_Hyq");		//string

//获得来自 URL 的 q 参数
$u=$_GET["user"];
$p=$_GET["pass"];


$con = mysql_connect("localhost","root","ta0mee");

if($con){
	$select = mysql_select_db("MyBlog",$con);	//选择数据库.
	if($select){
		$result = mysql_query("insert into user_info values($u, '$p',now(),0x0,0x0)",$con);			//执行Sql语句.
		if(mysql_affected_rows($con)==1)
		{
			error_log("insert into ok...");
			$arr = array('t_date'=>'1','status'=>'1','char_buf'=>'1');
			$json_string = json_encode($arr);		//序列化json对象.
			$response=$json_string;				//返回json对象.
		}
		else
		{
			$response="0";	//登陆失败.
			error_log("no rows..");
		}

	}

}
echo $response;
?>
