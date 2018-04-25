1.DialogMgr需要提供隐藏某个界面的接口,以提高绘制效率
数学系
经济学
心理学
社会学
文学系

--创建剪裁节点
-- local circle = cc.Sprite:create("ui_v3/idol_live/xuanchuantu.png")
-- --circle:setScaleX(4);
-- circle:setScaleY(2);
-- local m_clip = cc.ClippingNode:create()
-- m_clip:setPosition(360, 800)
-- pageView:retain()
-- pageView:removeFromParent(false)
-- m_clip:addChild(pageView)
-- pageView:setPosition(0, 0)
-- pageView:release()
-- m_clip:setStencil(circle)
-- m_clip:setInverted(false)
-- m_clip:setAlphaThreshold(0.5)
-- panel_2:addChild(m_clip)

--
-- 1x1/0001
-- 2x2/0001
-- 3x3/0001
-- 4x4/0001
--
-- Title = {
-- 		texture = 1,	--表示纹理编号
-- 		origin = 0,		--原点位置,{0-表示自己}
-- }
--

--创建一个按钮组
--传递一组btn,以及统一的回调函数
--通过tag识别当前选择的是哪个按钮
--默认选中第一项
--callback,点击项
--change,之前的选中项
function dlg:button_group(btns, callback, change, didx)
		local function click(sender)
				if(sender:isEnabled() and (type(btns) == "table" and table.nums(btns) > 0))then
						for ii, vv in ipairs(btns)do
								if(vv:getTag() ~= sender:getTag())then
										if(not vv:isEnabled())then 		--前一步被按下的项
												vv:setEnabled(true)
												vv:setBright(true)
												if(change)then
														change(vv)
												end
										end
								end
						end

						sender:setEnabled(false)
						sender:setBright(false)
						if(callback)then
								callback(sender)
						end
				end
		end
		didx = didx or 1
		if(type(btns) == "table" and table.nums(btns) > 0)then
				for i, v in ipairs(btns)do
						--添加监听
						v:addClickEventListener(click)
						--默认选择第一项
						if(i == didx)then
								click(v)
						end
				end
		end
end

--初始化状态标签
self.cfg.buttons = {}
for i = 1, 4 do
		table.insert(self.cfg.buttons, self:getControl("Naviga_btn_" .. i, nil, Buttons))
end
self:button_group(self.cfg.buttons, function(sender)
		self:getControl("Button_Enabled", nil, sender):setVisible(false)
		self:getControl("Button_Disabled", nil, sender):setVisible(true)
		IdolLiveMgr:set_current_tabs(sender:getTag())
		print("click tag:" .. sender:getTag())

		self:update_timer()
end, function(sender)
	self:getControl("Button_Enabled", nil, sender):setVisible(true)
	self:getControl("Button_Disabled", nil, sender):setVisible(false)
	print("front tag:" .. sender:getTag())
end, IdolLiveMgr:get_current_tabs())
