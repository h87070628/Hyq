
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

MainScene.RESOURCE_FILENAME = "MainScene.csb"

function MainScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    --[[ you can create scene with following comment code instead of using csb file.
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)
    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)
    ]]

	--数据
	self.cfg = {
			data = {
					10000, 10001, 10002, 10003, 10004, 10005, 10006, 10007, 10008, 10009,
					10010, 10011, 10012, 10013, 10014, 10015, 10016, 10017, 10018, 10019,
				   }
	}

	--界面
	self.cfg.pageView = self:getResourceNode():getChildByName("PageView_1")
	local pageView = self.cfg.pageView
	local function fill_page_item(idx)
			local item_ = self:getResourceNode():getChildByName("pageview_item")
			local item = item_:clone()
			item:getChildByName("Text_1"):setString(self.cfg.data[idx])
			return item
	end
	self.cfg.create_item = fill_page_item
	local create_item = self.cfg.create_item

	pageView:addPage(create_item(1))
	pageView:addPage(create_item(2))
	--pageView:addPage(create_item(3))
	--pageView:setCurrentPageIndex(1)

	--控制
	self:btn_bind("Button_1", function()
			--添加
	end)
	self:btn_bind("Button_2", function()
			--随机定位到某个item
			local last = #pageView:getItems() - 1
			pageView:scrollToPage(math.random(0, last))
	end)
	self:btn_bind("Button_3", function()
			--打印全部序号
			local items = pageView:getItems()
			for i, v in ipairs(items)do
					print("index : " .. pageView:getIndex(v))
			end

			dump(self.cfg.data)
	end)

	self:btn_bind("Button_4", function()
			local last = #self.cfg.data
			if(last > 0)then
					local idx = math.random(1, last)
					local value = self.cfg.data[idx]
					table.remove(self.cfg.data, idx)

					self:remove_data(value)
			end
	end)
	self:btn_bind("Button_5", handler(self, self.left_move))
	self:btn_bind("Button_6", handler(self, self.right_move))
end

--定位
--removePageAtIndex
--
--addPage
--insertPage
--
--getCurrentPageIndex
--getItems
--getItem
--
--scrollToPage
--pageView:setCurrentPageIndex(2)
--
--table.indexof(self.cfg.data, value)

--从右向左滑动:尾部添加, 添加后判断items数量,大于3时, 删除头部,
function MainScene:left_move()
		local pageView = self.cfg.pageView
		local create_item = self.cfg.create_item

		local items = #pageView:getItems()
		local total = #self.cfg.data

		if(total > 1)then
				local last_item = pageView:getItem(items-1)
				local last = last_item:getChildByName("Text_1"):getString()
				local index = table.indexof(self.cfg.data, tonumber(last))
				if(index == total)then
						print("is last")
				else
						if(index and index < total)then
								pageView:addPage(create_item(index + 1))
								self:scheduleGlobalOnce(function()
										items = #pageView:getItems()
										if(items > 3)then
												pageView:removePageAtIndex(0)
										end

										self:scheduleGlobalOnce(function()
												pageView:scrollToPage(1)	----scrollToPage滑动持续时间默认为1秒钟
										end,0)
								end, 0)
						end
				end
		else
				print("no data")
		end
end

--从左向右滑动:头部添加, 尾部删除, 添加后判断items数量,大于3时.
function MainScene:right_move()
		local pageView = self.cfg.pageView
		local create_item = self.cfg.create_item
		local items = #pageView:getItems()
		local total = #self.cfg.data
		if(total > 1)then
				local front_item = pageView:getItem(0)
				local front = front_item:getChildByName("Text_1"):getString()
				local index = table.indexof(self.cfg.data, tonumber(front))

				if(index == 1)then
						print("is front")
				else
						if(index and index > 1)then
								pageView:insertPage(create_item(index - 1), 0)
								self:scheduleGlobalOnce(function()
										items = #pageView:getItems()
										if(items > 3)then
												pageView:removePageAtIndex(3)
												pageView:setCurrentPageIndex(2)

												self:scheduleGlobalOnce(function()
														pageView:scrollToPage(1)	--scrollToPage滑动持续时间默认为1秒钟
												end,0)
										end
								end, 0)
						end
				end
		else
				print("no data")
		end
end

--删除数据()
function MainScene:remove_data(value)
		--遍历items,确定正在显示的项目是否是删除的项
		local pageView = self.cfg.pageView
		local delete_idx = nil
		local item = nil
		local number = nil
		local items = nil
		items = #pageView:getItems()
		for i = 1, items do
				item = pageView:getItem(i-1)
				number = tonumber(item:getChildByName("Text_1"):getString())
				if(number == value)then
						delete_idx = i - 1
						break
				end
		end
		
		--删除的是当前正在显示的项
		if(delete_idx)then
				pageView:removePageAtIndex(delete_idx)
				self:scheduleGlobalOnce(function()
						local index = -1
						local total = #self.cfg.data
						if(total > 0)then
								local front_item = pageView:getItem(0)
								local front = front_item:getChildByName("Text_1"):getString()
								index = table.indexof(self.cfg.data, tonumber(front))
								if(index == 1)then
										self:left_move()
								else
										self:right_move()
								end
						end
				end, 0)
		end
end

--帧定时器,需要注意节点被销毁的情况,func函数里面访问的节点会为NULL
function MainScene:scheduleGlobalOnce(func, time)
		local scheduler = cc.Director:getInstance():getScheduler()
		local id = nil
		id = scheduler:scheduleScriptFunc(function()
				scheduler:unscheduleScriptEntry(id)
				id = nil
				func()
		end, time, false)
		return id
end

--绑定按钮
function MainScene:btn_bind(btn_name, callback)
		local btn = self:getResourceNode():getChildByName(btn_name);
		local function callback_(sender,eventType)
				if eventType == ccui.TouchEventType.ended then
						if(type(callback) == "function")then
								callback()
						end
				end
		end
		btn:addTouchEventListener(callback_)
end
return MainScene
