--打印局部变量
local print_var = function()
		local d_a = 1
		while true do
				--getlocal的第一个参数代表当前的环境,1表示当前函数环境,2表示调用该函数的环境,以此类推
				--getlocal的第二个参数代表当前第几个变量
				--函数返回成功时,会返回变量的名字,否则返回nil
				local name, value = debug.getlocal(2, d_a)
				if not name then break end
				print("LGD:" .. name .. " = ")
				print(value)
				d_a = d_a + 1
		end
end

--print_var();
