#!/usr/bin/lua

--[[ 创建系统表--]]
--db_index=0;
--end_index=9;

--for db_index=0,end_index,1 do
--end

print(string.format([[
USE MyBlog;
drop table comment;
CREATE TABLE IF NOT EXISTS `comment` (
	comment_id INT UNSIGNED NOT NULL auto_increment,
	page_index INT UNSIGNED NOT NULL,
	comment_str varchar(255) NOT NULL,
	createtime DATETIME NOT NULL,
	userid INT UNSIGNED NOT NULL,
	PRIMARY KEY (comment_id)
	)ENGINE=InnoDB DEFAULT CHARSET=utf8;
]]));

--comment_id评论的唯一id.
--page_index 评论所在的页面编号1.html = 1.
--comment_str 评论的内容.
--createtime 评论的时间是什么时候.
--userid 谁评论的,可以匿名.
