--{TODO List}

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
local function hasCard(bs, brand)
	for i, v in ipairs(bs)do
		if(v == brand)then
			return true
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

local function removeYCcard(bs)
	local brand = 0;

	--找到第一张非字牌
	for i = 1, #bs do
		if(math.floor(bs[1] / 10) > 0)then
			brand = bs[1]
			break
		end
	end

	if(brand ~= 0)then
		--存在任意顺万条,优先处理
		if(brand%10 <= 7 and (removebrand(bs, brand, 1)) and removebrand(bs, brand + 1, 1) and removebrand(bs, brand + 2, 1))then
			return true
		end
	else
		--处理存在中发白任意一张,要组成一簇牌,则必须拥有其他两张
		if(hasCard(bs, 5) or hasCard(bs, 6) or hasCard(bs, 7))then
			if((removebrand(bs, 5, 1)) and removebrand(bs, 6, 1) and removebrand(bs, 7, 1))then
				return true
			else
				return false
			end
		end

		--处理四风,在6张牌的情况下且没有碰牌的情况下,必然存在两个对子
		--组合簇牌时,优先拆对子
		brand = 0
		local brand_2 = 0
		local brand_3 = 0
		for i=1, #bs do
			if(hasDui(bs, bs[i]))then
				brand = bs[i]
				break
			end
		end
		for i=1, #bs do
			if(hasDui(bs, bs[i]) and bs[i] ~= brand)then
				brand_1 = bs[i]
				break
			end
		end
		for i=1, #bs do
			if(bs[i] ~= brand and bs[i] ~= brand_1)then
				brand_2 = bs[i]
				break
			end
		end

		if(brand ~= 0 and brand_1 ~= 0 and brand_2 ~= 0)then
			if((removebrand(bs, brand, 1)) and removebrand(bs, brand_2, 1) and removebrand(bs, brand_3, 1))then
				return true
			end
		end
	end
	return false
end


--处理3张
local function process3card(bs)
	--table.foreachi(bs, function(i,v) print(v); end)
	local brand = bs[1];
	if(hasPeng(bs, brand))then
		return true
	else
		brand = 0
		--找到第一张非字牌
		for i = 1, #bs do
			if(math.floor(bs[1] / 10) > 0)then
				brand = bs[1]
				break
			end
		end

		if(brand ~= 0)then
			if(brand%10 <= 7 and bs[2] == brand + 1 and bs[3] == brand + 2)then
				return true
			end
		else
			--字牌处理
			local feng = false
			if(brand > 4)then
				feng = false
			else
				feng = true
			end
			for i = 1, #bs do
				if(feng)then
					--如果第一张牌是风,却出现了中发白
					if(bs[i] > 4)then
						return false
					end
				else
					--如果第一张牌是中发白,却出现了风牌
					if(bs[i] <= 4)then
						return false
					end
				end
			end

			if(bs[1] ~= bs[2] and bs[1] ~= bs[3] and bs[2] ~= bs[3])then
				return true
			end
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
	if(removeYCcard(cbs))then
		if(process3card(cbs))then
			return true;
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
	if(removeYCcard(cbs))then
		if(process6card(cbs))then
			return true;
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
	if(removeYCcard(cbs))then
		if(process9card(cbs))then
			return true;
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
	local brands = {4,4,4,5,5,5,6,7,11,12,13};
	--table.foreachi(brands, function(i,v) print(v); end)
	print(processhasDuicard(brands))
end

main()
