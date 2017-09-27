


--[[
--
--获取外网IP地址
--需要借助curl动态库
--
--]]

local json = require ("dkjson")
require("curl")
print(curl.version())

math.randomseed(tostring(os.time()):reverse():sub(1, 7))

local function build_w_cb(t)
		return function(s,len)
				table.insert(t,s)
				return len,nil
		end
end

local function build_r_cb()
		return function(n)
				local s = string.rep("#",n)
				return string.len(s),s
		end
end

--********************************************************************************
--data,协议数据(字符串)			格式:--json.encode({cmd="10000", data="0.0.0.0"});
--handler,返回数据的处理函数(函数)
local function sendMsg(data, handler)
		local ret_b = {}
		local ret_h = {}
		local c = curl.easy_init()
		c:setopt(curl.OPT_URL, "http://192.168.8.180/phpinfo.php")
		c:setopt(curl.OPT_WRITEFUNCTION,build_w_cb(ret_b))
		c:setopt(curl.OPT_HEADERFUNCTION,build_w_cb(ret_h))
		c:setopt(curl.OPT_HTTPPOST,{
				{curl.FORM_COPYNAME,"data",
				curl.FORM_COPYCONTENTS,data,
				curl.FORM_CONTENTTYPE,"Content-type: text/plain",
				curl.FORM_END }
		})
		local ret = c:perform();
		if(ret == 0)then
				if(handler)then
						handler(ret_b)
				else
						print(table.concat(ret_b))
				end
		else
				print("10003_Error !!!")
		end
end
--********************************************************************************

local function get_net_ip()
		local net_IP = nil
		local iWay = math.random(10) % 2
		local www = (iWay == 0) and "http://www.ipinfo.io" or "http://ip.chinaz.com/getip.aspx"
		local gl_b = {}
		local gl_h = {}

		print("curl " .. www .. "[[[" .. iWay)

		local c = curl.easy_init() 
		c:setopt(curl.OPT_URL, www)
		c:setopt(curl.OPT_WRITEFUNCTION,build_w_cb(gl_b))
		c:setopt(curl.OPT_HEADERFUNCTION,build_w_cb(gl_h))
		---[[
		--c:setopt(curl.OPT_HTTPHEADER,{"Referer: my_home!","Dummy-field: hello"})
		--]]
		--print("\n\t$$ performing... returns code,error $$\n")
		local ret = c:perform();
		if(ret == 0)then
				--[[
						print("\n\t$$ here you see the header, line per line $$\n")
						table.foreach(gl_h,function(i,s) print(i.."= "..string.gsub(s,"\n","")) end)
						print("\n\t$$ and here you see the data, after concatenation of ".. table.getn(gl_b).." chunks $$\n")
						print(table.concat(gl_b))
				--]]
				if(iWay == 0)then
						--curl http://www.ipinfo.io
						local ipinfo = json.decode(table.concat(gl_b))
						if(type(ipinfo) == "table")then
								net_IP = ipinfo.ip
						else
								print("10003_Error !!!")
						end
				else
						--curl http://ip.chinaz.com/getip.aspx
						local src = gl_b[1]									--{ip:'27.154.73.54',address:'福建省厦门市 电信'}
						if(type(src) == "string")then
								local sBegin, sEnd = string.find(src, "'%d.+%d'")
								net_IP = string.sub(src, sBegin + 1, sEnd - 1)
						else
								print("10002_Error !!!")
						end
				end
		else
				print("10001_Error !!!")
		end

		return net_IP
end

--获取当前外网IP地址
local curip = get_net_ip();

--获取已记录的IP地址
local netip = nil
local function  get_php_ip(data)
		local ret = json.decode(table.concat(data))
		if(type(ret) == "table")then
				netip = ret.ip
		end
end
sendMsg(json.encode({cmd=10000}), get_php_ip);

--当IP不相同时,提交当前IP地址
if(curip ~= netip)then
	print("diff")
	sendMsg(json.encode({cmd=10001, data=curip}));
else
	print("same")
end



