<?php 
//写入json结构
function writejson($sData){
		$file = fopen("ipinfo.txt", "w") or die("Unable to open file!");
		fwrite($file, $sData);
		fclose($file);
		return 0;
}

//从文件中读取json结构
function readjson(){
		$file = fopen("ipinfo.txt", "r") or die("Unable to open file!");
		$jData = fread($file,filesize("ipinfo.txt"));
		fclose($file);
		return $jData;
}

$data = $_POST["data"];
if(strlen($data)>0){
		$ret_Data = array('ret'=>0, 'ip'=>'0.0.0.0');	//返回客户端的数据
		$pData = json_decode($data, true);				//从客户端传递的json解析成array
		//var_dump($pData); 
		
		$fData = readjson();							//读取本地配置
		$ajData = json_decode($fData, true);			//将配置解析成array
		if($pData['cmd'] == 10000){
			$ret_Data['ip'] = isset($ajData['ip'])?$ajData['ip']:"1.1.1.1";
		}elseif($pData['cmd'] == 10001){
			$ajData['ip'] = $pData['data'];
			writejson(json_encode($ajData));
		}

		//返回结果
		echo json_encode($ret_Data); 
}


?> 
