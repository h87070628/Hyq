#!/usr/bin/lua

--[[ 创建系统表--]]
db_index=0;
end_index=99;

for db_index=0,end_index,1 do

--print(string.format([[	CREATE TABLE IF NOT EXISTS test.t_sys_arg_%02d(
--				type   INT UNSIGNED NOT NULL DEFAULT '0',
--				value  INT NOT NULL DEFAULT '0',
--				PRIMARY KEY  (type )
--				) ENGINE=innodb, CHARSET=utf8;]],db_index));
--

end

--print(string.format([[
--USE test;
--DROP TABLE IF EXISTS `bean_product_id_map_table`;
--SET @saved_cs_client     = @@character_set_client;
--SET character_set_client = utf8;
--CREATE TABLE `bean_product_id_map_table` (
--  `id` int(10) unsigned NOT NULL,
--  `map_id` int(10) unsigned NOT NULL,
--  `count` int(11) default '1',
--  PRIMARY KEY  (`id`,`map_id`)
--) ENGINE=InnoDB DEFAULT CHARSET=utf8;
--SET character_set_client = @saved_cs_client;
--
-- Dumping data for table `bean_product_id_map_table`
--

--LOCK TABLES `bean_product_id_map_table` WRITE;
--/*!40000 ALTER TABLE `bean_product_id_map_table` DISABLE KEYS */;
--INSERT INTO `bean_product_id_map_table` VALUES (240000,300006,1);
--/*!40000 ALTER TABLE `bean_product_id_map_table` ENABLE KEYS */;
--UNLOCK TABLES;]]));

print(string.format([[
USE TASK_DAY_DB;

DROP TABLE player_status;

CREATE TABLE IF NOT EXISTS `player_status` (
	userid INT UNSIGNED NOT NULL,
	status BINARY(250) NOT NULL DEFAULT '\0',
	PRIMARY KEY (userid)
	)ENGINE=InnoDB DEFAULT CHARSET=utf8;
]]));
