#!/usr/bin/lua

--[[ 创建系统表--]]
db_index=0;
end_index=9;

--drop database MyBlog;
print(string.format([[
CREATE DATABASE MyBlog;
]]));

for db_index=0,end_index,1 do
end

print(string.format([[
USE MyBlog;
CREATE TABLE IF NOT EXISTS `user_info` (
	userid INT UNSIGNED NOT NULL,
	password varchar(32) NOT NULL,
	createtime DATETIME NOT NULL,

	status BINARY(250) NOT NULL DEFAULT '\0',
	char_buf BINARY(250) NOT NULL DEFAULT '\0',
	PRIMARY KEY (userid)
	)ENGINE=InnoDB DEFAULT CHARSET=utf8;
]]));
--status 字节字符串,能按位设置值.
--char_buf 字符字符串,只能按字符设置值,范围为(0-255).
