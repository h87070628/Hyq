
<?php
//载入数据库操作函数.
require './connect_mysql.php';

error_reporting(E_ALL);	//打开所有的错误日志.

//获得来自 URL 的 q 参数
$u=$_POST["index_begin"];
error_log("index:".$u);

//入库操作.
$temp_t = connect_sql();
error_log($temp_t);

//$sql_data = query_sql("insert into message_board values(NULL,10000,'$str',NOW());");
//error_log($sql_data);

$result = query_sql("SELECT * FROM message_board ORDER BY createtime DESC;",$con);                      //执行Sql语句.
                if(mysql_num_rows($result)>=1)
		{
			$arr = array();
			$i = 0;

			while ($row = mysql_fetch_array($result)) {
				if( $i < 9)
				{
					$arr[$i] = array('a1'=>$row[0],'a2'=>$row[1],'a3'=>$row[2],'a4'=>$row[3]);
					$i++;
				}else{
					$i = 0;
					break;
				}
			}
			$json_string = json_encode($arr);               //序列化json对象.

			mysql_free_result($result);                     //释放结果集.
			$response=$json_string;                         //返回json对象.
		}

close_sql();
//error_log("return:".$response);
echo $response;					//返回json对象.
?>
