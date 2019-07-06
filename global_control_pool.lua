ControlPool = {}
ControlPool.__index = ControlPool
function ControlPool.createPool(parent)
  if nil == parent then
    return nil
  end
  local newPool = {}
  setmetatable(newPool, ControlPool)
  newPool._parent = parent
  newPool.poolMapByControlType = {}
  newPool.poolMap = {}
  return newPool
end
function ControlPool:addCategory(id, controlType, template, controlID)
  local pool = self.poolMap[id]
  if nil ~= pool then
    return false
  end
  local poolInfo = {
    _template = template,
    _type = controlType,
    _count = 0,
    _controlID = controlID,
    _pool = Array.new()
  }
  self.poolMap[id] = poolInfo
  local managePool = self.poolMapByControlType[controlType]
  if nil == managePool then
    managePool = {}
    self.poolMapByControlType[controlType] = managePool
  end
  managePool[id] = poolInfo._pool
end
function ControlPool:hasCategory(id)
  return nil ~= self.poolMap[id]
end
function ControlPool:getControlTypePool(controlType)
  local weakRefPool = self.poolMapByControlType[controlType]
  for _, pool in pairs(weakRefPool) do
    if 0 < pool:length() then
      return pool:pop_back()
    end
  end
  return nil
end
function ControlPool:getOrCreateControl(id)
  local poolInfo = self.poolMap[id]
  if nil == poolInfo then
    return nil
  end
  if 0 < poolInfo._pool:length() then
    return poolInfo._pool:pop_back()
  else
    local sameTypeControl = self:getControlTypePool(poolInfo._type)
    if nil ~= sameTypeControl then
      if nil ~= poolInfo._template then
        CopyBaseProperty(poolInfo._template, sameTypeControl)
      end
      return sameTypeControl
    else
      poolInfo._count = poolInfo._count + 1
      local newControl = UI.createControl(poolInfo._type, self._parent, poolInfo._controlID .. poolInfo._count)
      if nil ~= newControl then
        if nil ~= poolInfo._template then
          CopyBaseProperty(poolInfo._template, newControl)
        end
        newControl:SetShow(false)
        return newControl
      end
      return nil
    end
  end
end
function ControlPool:returnToPool(id, control)
  local poolInfo = self.poolMap[id]
  if nil == poolInfo then
    return false
  end
  control:SetShow(false)
  poolInfo._pool:push_back(control)
  return true
end
