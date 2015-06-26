#!/usr/local/bin/lua

_G.__G__TRACKBACK__=function(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
	--debug.debug();
	
	local errinfo = {};
	for i = 2,100 do
		errinfo = debug.getinfo(i);
		if(errinfo) then
			--if(errinfo.currentline)then
			--	print(errinfo.currentline);
			--end
			if(errinfo.what ~= "C")then
				print("***************************************************");
				for i,v in pairs(errinfo) do
					if(type(v) ~= "function") and (type(v) ~= "boolean") then
						print(i .. "=\t\t\t\t" .. v);
					end
				end
				print("***************************************************");
			end
		end
	end
    print("----------------------------------------")
end

--输出彩色字符.
local function print_f(color,string)
	local str = "请输入您要使用的工具编号(By-退出):";
	print("\x1b[0;".. color .."m" .. str .. "\x1b[0m");
end

local str = string.format([[
*****资源管理工具v0.1*****
	01. 实时资源更新.
	02. 渠道资源上传.
	03. 一键发布资源.
	04. 32位转换64位. - 打印os下面的成员.
	05. 32位转换64位. - 调用iTools下面的5.sh文件.
	99. ##帮助文档##.
	By. 退出工具.
*****资源管理工具v0.1*****]]);

local function ShowTools()
	print(str);
	for i = 30, 47 do
		print_f(i,"请输入您要使用的工具编号(By-退出):");
	end
	--print_f(35,"请输入您要使用的工具编号(By-退出):");
end

Tools = {
	[1] = function()	print("调用功能01中.");	end;
	[2] = function()	print("调用功能02中.");	end;
	[3] = function()	print("调用功能03中.");	end;
}

Tools[4] = function()	
	for i,v in pairs(os)do
		print(i);
	end
end;

Tools[5] = function()	
	local iStatus = os.execute("source ./iTools/5.sh");
	if(iStatus)then
		print("执行成功.");
		return true;
	else
		print("执行失败.");
	end
end

local function main()
	local inPuts = 0;
	ShowTools();
	repeat
		inPuts = io.read("*line");
		if(inPuts == "By")then
			print("GoodBye!");
			return nil;
		end
		--while(true)do
		local iNum = tonumber(inPuts);
			if(iNum and iNum < 99)then
				if(Tools[iNum])then
					if(Tools[iNum]())then
						print("提示:功能执行成功!!!");
					else
						--print("提示:功能执行过程中出现异常,请检查!!!");
					end
				else
					print("该功能暂未开发,请重新输入.");
				end
			else
				print("当前的输入无效,请检查!");
			end
		--end
		print_f(35,"请输入您要使用的工具编号(By-退出):");
	until(false)
end
xpcall(main,__G__TRACKBACK__);
