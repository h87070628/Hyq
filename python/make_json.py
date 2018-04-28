#!/usr/bin/python3
#-*-coding:utf-8-*-
import os
import json
import time
def get_json():
		Json = {}
		Path = os.getcwd()+"/"
		Files = os.listdir(Path)
		for File in Files:
			if(os.path.isdir(File)):
				pass
			else:
				Json[File] = os.path.getsize(Path + File)
				#print("{0} size:{size}".format(File, size=os.path.getsize(Path + File)))

		#写入json文件
		with open("data.json", "w") as f:
			json.dump(Json, f)

		#读取json文件
		with open("data.json", "r") as f:
			data = json.load(f)

		print(repr(data))
		#print(data["make_json.py"])

"""
json_str = json.dumps(Json)

data = json.loads(json_str)
print(repr(data))
for k,v in data.items():
	print("{0}, {1}".format(k, v))
"""

"""
total = ["andy", "sandy", "lucky"]
def sNum(Max = 100,st = "\n"):
	a,b = 0,1
	while b < Max:
		print(b, end=st)
		a,b = b, a+b
"""

print("time is : {0}".format(time.time()))

#定义一个类以及构造函数
class Studio:
	def __init__(self):
		self.name = "Lucky"
		self.age  = 1

baby = Studio()

print(baby.name)
#get_json()
