


require "io"
require "lfs"



--[[
--配置文件
--]]
local CPDIR = "C:\\\"Program Files\"\\";

local config = {
	--指定svn地址
	svnbin = "D:\\TortoiseSVN\\bin\\TortoiseProc.exe ",
	--指定WinRAR地址
	rarbin = CPDIR .. "WinRAR\\WinRAR.exe ",
	--指定WinUnRAR地址
	unrarbin = CPDIR .. "WinRAR\\UnRAR.exe ",
};

--遍历指定目录下的所有文件.
function getpathes(rootpath, pathes)  
	pathes = pathes or {}  
	for entry in lfs.dir(rootpath) do  
		if entry ~= '.' and entry ~= '..' then  
			local path = rootpath .. '\\' .. entry  
			local attr = lfs.attributes(path)  
			if(type(attr) ~= "nil")then
				if attr.mode == 'directory' then  
					getpathes(path, pathes)  
				else  
					table.insert(pathes, path)  
				end  
			else
				--print(path);
				--print(type(attr))
				--assert(type(attr) == 'table')  
			end
		end  
	end  
	return pathes  
end

--将源文件复制到目标目录
function copyfiles(source, target_dir)
	local command = "copy " .. source .. " " .. target_dir; 
	return os.execute(command) == 0;	--返回0, 代表执行成功
end

--使用svn更新指定目录,没有发生错误时,自动关闭对话框
function updatefile(dir)
	local commnd = "/command:update /path:" .. dir .. " /closeonend:1"
	return os.execute(config.svnbin .. commnd) == 0;
end

--压缩指定文件夹
function zipfiles(source_dir, target)
	local commnd = "a -ag -k -r -s -ibck " ..  target .. " " .. source_dir;
	return os.execute(config.rarbin .. commnd) == 0;
end

local main = function()
	for k, v in pairs(lfs)do
		--print(k);
	end

	local rootpath = "E:\\huangyq\\AWork_dir";
	local files = getpathes(rootpath);

	--
	--print(copyfiles(files[1], "."));
	--print(updatefile("E:\\huangyq\\soft"));
	--print(zipfiles("E:\\huangyq\\soft\\OpenOffice_3.4.0_Win_x86_zh-CN", "bak.rar"));
	--
	
	for i, v in ipairs(arg)do	--解析传入的参数
		print(v);
	end
end

main();


os.exit(1);
