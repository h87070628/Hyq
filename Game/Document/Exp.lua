1.DialogMgr需要提供隐藏某个界面的接口,以提高绘制效率


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
