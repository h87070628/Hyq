

Manage = {}

function Manage:new(o)
	obj = o or {}
	setmetatable(obj, self)
	self.__index = self
	self.cfg = {
		x = 1,
		y = 2,
		z = 3,
	}
	return obj
end

function Manage:Shared()
	if self.m_pShared == nil then
		self.m_pShared = self:new()
	end
	return self.m_pShared
end

function Manage:destroyInstance()
	if self.m_pShared then
		self.m_pShared = nil
	end
end

function Manage:showInfo()
	print("x :" .. self.cfg.x .. "y :" .. self.cfg.y .. "z :" .. self.cfg.z);
end
