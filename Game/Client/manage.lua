--
--[[管理类模版]]
--
Manage = {}
local mgr = Manage

function mgr:new()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	self.cfg = {
		x = 1,
		y = 2,
		z = 3,
	}
	return obj
end

function mgr:Shared()
	if self.m_pShared == nil then
		self.m_pShared = self:new()
		self:init()
	end
	return self.m_pShared
end

function mgr:destroyInstance()
	self:clean()
	if self.m_pShared then
		self.m_pShared = nil
	end
end

function mgr:showInfo()
	print("x :" .. self.cfg.x .. "y :" .. self.cfg.y .. "z :" .. self.cfg.z);
end

--初始化
function mgr:init()
end

--设置参数
function mgr:setParam(args)
		self.cfg.param = args
end

--清理
function mgr:clean()
end

--直接创建单例对象
Manage:Shared()
