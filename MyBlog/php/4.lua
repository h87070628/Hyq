#!/usr/bin/lua

--[[ 创建系统表--]]
--db_index=0;
--end_index=9;

--for db_index=0,end_index,1 do
--end

print(string.format([[
USE MyBlog;
drop table message_board;
CREATE TABLE IF NOT EXISTS `message_board` (
	message_board_id INT UNSIGNED NOT NULL auto_increment,
	userid INT UNSIGNED NOT NULL,
	comment_str varchar(255) NOT NULL,
	createtime DATETIME NOT NULL,
	PRIMARY KEY (message_board_id)
	)ENGINE=InnoDB DEFAULT CHARSET=utf8;
]]));

--comment_id评论的唯一id.
--page_index 评论所在的页面编号1.html = 1.
--comment_str 评论的内容.
--createtime 评论的时间是什么时候.
--userid 谁评论的,可以匿名.
