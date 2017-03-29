
local function cb(...)
	local cA = {}
	cA.cfg = {
		x = 1,
		y = 2,
		z = 3,
	}

	function cA:ctor(arg)
		for i = 1, #arg do
			print("²ÎÊý" .. i .. ":" ..arg[i])
		end
	end

	function cA:show()
		print("x = " .. self.cfg.x);
		print("y = " .. self.cfg.y);
		print("z = " .. self.cfg.z);
	end

	local args = {...}
	cA:ctor(args)
	return cA;
end

return cb;
