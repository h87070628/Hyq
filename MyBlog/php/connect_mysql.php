<?php

$con = NULL;

/*连接到mysql数据库.*/
function connect_sql()
	{
		global $con;

		$con = mysql_connect("localhost","root","ta0mee");
		if($con){
			$select = mysql_select_db("MyBlog",$con);	//选择数据库.

			if($select){
				return TRUE;
			}
			else{
				return FALSE;
			}
		}
		else{
			return FALSE;
		}
	}

/*执行查询语句.*/
function query_sql($sql_str)
{
	global $con;

	$result = mysql_query($sql_str,$con);			//执行Sql语句.
	if($result == FALSE){
		return FALSE;
	}
	else{
		return $result;
	}
}

/*关闭mysql连接.*/
function close_sql()
{
	global $con;

	if($con)
	{
		mysql_close($con);	//关闭数据库连接.
		error_log("close sql..");
	}
}

?>
