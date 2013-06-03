<?php
// 用名字来填充数组
$a[]="Anna";

error_reporting(E_ALL);	//打开所有的错误日志.

//error_log("11111111111111111111111-andy");

//获得来自 URL 的 q 参数
$u=$_GET["user"];
$p=$_GET["pass"];

$con = mysql_connect("localhost","root","ta0mee");
if($con)
{
	$select = mysql_select_db("MyBlog",$con);	//选择数据库.
	if($select)
	{
		$result = mysql_query("select * from user_info where userid='$u' and password='$p'",$con);			//执行Sql语句.
		if(mysql_num_rows($result)==1)
		{
			$temp = mysql_fetch_array($result);
			//error_log($temp[0].$temp[1].$temp[2].$temp[3].$temp[4]);

			//error_log(gettype($temp[4]));		//string
			//error_log(strlen($temp[4]));		//string
			
			$arr = array('t_date'=>$temp[2],'status'=>$temp[3],'char_buf'=>$temp[4]);
			$json_string = json_encode($arr);		//序列化json对象.
			
			//$obj_json = json_decode($json_string);	//解压json对象.
			
			//error_log(gettype($arr['char_buf']));		//string
			//error_log(strlen($arr['char_buf']));		//string

			mysql_free_result($result);			//释放结果集.
			//$response="1";				//常规的登陆成功方式.

			$response=$json_string;				//返回json对象.
		}
		else
		{
			$response="0";	//登陆失败.
			error_log("no rows..");
		}
	}
}
else
{
	error_log("connect bad..");
}

//输出响应
echo $response;

if($con)
{
	mysql_close($con);	//关闭数据库连接.
}
?>
