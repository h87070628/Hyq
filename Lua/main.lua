require "manage"
local newObFun = require "class"
--local nOb = newObFun();
--nOb:show();

--表的复制
function copyTab(st)
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = copyTab(v)
        end
    end
    return tab
end
--
function removebrand(bs, brand, nums)
	local count = 0
    if bs ~= nil then
        for i = #bs, 1, -1 do
            if bs[i] == brand then
                table.remove(bs, i)
				count = count + 1
				if(nums == 1)then
					--只删除一张
					return true;
				elseif(nums == 2)then
					--只删除二张
					if(count == 2)then
						return true
					end
				elseif(nums == 3)then
					--只删除三张
					if(count == 3)then
						return true
					end
				end
				--全部删除
            end
        end
    end
end
--
local function hasDui(bs, brand)
	local count = 0
	for i, v in ipairs(bs)do
		if(v == brand)then
			count = count + 1
		end
	end
	return count >= 2
end

--
local function hasPeng(bs, brand)
	local count = 0
	for i, v in ipairs(bs)do
		if(v == brand)then
			count = count + 1
		end
	end
	return count >= 3
end




--处理3张
local function process3card(bs)
	--table.foreachi(bs, function(i,v) print(v); end)


	local brand = bs[1];
	if(hasPeng(bs, brand))then
		return true
	else
		if(brand <= 7 and bs[2] == brand + 1 and bs[3] == brand + 2)then
			return true
		end
	end
	return false
end

--处理6张
local function process6card(bs)
	--table.foreachi(bs, function(i,v) print(v); end)
	local cbs = {}

	--2碰
	cbs = copyTab(bs)

	local front = 0
	for i, v in ipairs(cbs)do
		while(true)do
			if(v == front)then
				break;
			end

			front = v;
			if(hasPeng(cbs, v))then
				local ccbs = copyTab(cbs)
				removebrand(ccbs, v, 3);
				if(process3card(ccbs))then
					return true;
				end
			end
			break;
		end
	end

	--2连簇
	cbs = copyTab(bs)
	local brand = cbs[1]
	if(removebrand(cbs, brand + 1, 1) and removebrand(cbs, brand + 2, 1))then
		if(removebrand(cbs, brand, 1))then
			if(process3card(cbs))then
				return true;
			end
		end
	end

	return false;
end

--处理9张
local function process9card(bs)
	--table.foreachi(bs, function(i,v) print(v); end)

	local cbs = {}
	--处理碰牌
	cbs = copyTab(bs)
	local front = 0
	for i, v in ipairs(cbs)do
		while(true)do
			if(v == front)then
				break;
			end

			front = v;
			if(hasPeng(cbs, v))then
				local ccbs = copyTab(cbs)
				removebrand(ccbs, v, 3);
				if(process6card(ccbs))then
					return true;
				end
			end
			break;
		end
	end

	--处理3
	cbs = copyTab(bs)
	local brand = cbs[1]
	if(removebrand(cbs, brand + 1, 1) and removebrand(cbs, brand + 2, 1))then
		if(removebrand(cbs, brand, 1))then
			if(process6card(cbs))then
				return true;
			end
		end
	end
	return false
end

--处理12张
local function process12card(bs)
	--table.foreachi(bs, function(i,v) print(v); end)

	local cbs = {}
	--处理碰牌
	cbs = copyTab(bs)
	local front = 0
	for i, v in ipairs(cbs)do
		while(true)do
			if(v == front)then
				break;
			end

			front = v;
			if(hasPeng(cbs, v))then
				local ccbs = copyTab(cbs)
				removebrand(ccbs, v, 3);
				if(process9card(ccbs))then
					return true;
				end
			end
			break;
		end
	end
	--处理3
	cbs = copyTab(bs)
	local brand = cbs[1]
	if(removebrand(cbs, brand + 1, 1) and removebrand(cbs, brand + 2, 1))then
		if(removebrand(cbs, brand, 1))then
			if(process9card(cbs))then
				return true;
			end
		end
	end
	return false
end

--处理拥有对子的情况{2,5,8,11,14}|上面已经处理了[3,6,9,12]
local function processhasDuicard(bs)
	local cbs = {}
	cbs = copyTab(bs)
	local front = 0
	for i, v in ipairs(cbs)do
			while(true)do
			if(v == front)then
				break;
			end
			front = v;

			if(hasDui(cbs, v))then
				local ccbs = copyTab(cbs)
				removebrand(ccbs, v, 2);
				local count = #ccbs
				if(count == 0)then
					--钓鱼碰碰胡
					return true;
				elseif(count == 3)then
					if(process3card(ccbs))then
						return true;
					end
				elseif(count == 6)then
					if(process6card(ccbs))then
						return true;
					end
				elseif(count == 9)then
					if(process9card(ccbs))then
						return true;
					end
				elseif(count == 12)then
					if(process12card(ccbs))then
						return true;
					end
				end
			end
			break;
		end
	end
	return false
end

function main()
	local brands = {1,1,2,3,4};
	--table.foreachi(brands, function(i,v) print(v); end)
	print(processhasDuicard(brands))
end

main()
