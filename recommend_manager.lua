Recommend_TYPE = {
  TYPE_INVENTORY = 0,
  TYPE_PET = 1,
  TYPE_WEIGHT = 2,
  COUNTOFTYPE = 3
}
PaGlobal_RecommendManager = {
  _savedDelay = 0,
  _recommendDelay = 3600,
  _recommendedBefore = false,
  _FromRecommendManager = false,
  _expforCheckInCombat = 0,
  _type = 0,
  _nowRecommendedType = 0,
  MAXSLOT = 192,
  _limitedLevel = 20
}
if isGameTypeTaiwan() then
  PaGlobal_RecommendManager._limitedLevel = 50
end
local gameOptionSetting = ToClient_getGameOptionControllerWrapper()
function PaGlobal_RecommendManager:registEventHandler()
  registerEvent("FromClient_isRecommedCash", "IsRecommendCash")
end
function FGlobal_RecommendManager_UpdatePerFrame(deltaTime)
  if true == gameOptionSetting:getCashAlert() then
    return
  end
  PaGlobal_RecommendManager:updatePerFrame(deltaTime)
end
function FGlobal_CashShopAlert_UpdatePerFrame(deltaTime)
  if true == gameOptionSetting:getCashAlert() then
    return
  end
  PaGlobal_RecommendManager:ShowPanel(deltaTime)
end
function PaGlobal_RecommendManager:ShowPanel(deltaTime)
  if Panel_CashShopAlert:GetShow() then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if selfPlayer:get():getLevel() <= self._limitedLevel then
    return
  end
  self._savedDelay = self._savedDelay + deltaTime
  if self._recommendDelay < self._savedDelay then
    self._recommendedBefore = false
    self._savedDelay = 0
  end
  if true == self._recommendedBefore then
    return
  end
  if self._savedDelay % 5 > 1 then
    return
  end
  if not Panel_CashShopAlert:GetShow() then
    for key, value in pairs(Recommend_TYPE) do
      if true == self:ProcessRecommend(value) then
        self._type = value
        Panel_CashShopAlert_Show()
        return
      end
    end
  end
end
function PaGlobal_RecommendManager:updatePerFrame(deltaTime)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if selfPlayer:get():getLevel() <= self._limitedLevel then
    return
  end
  self._savedDelay = self._savedDelay + deltaTime
  if self._recommendDelay < self._savedDelay then
    self._recommendedBefore = false
    self._savedDelay = 0
  end
  if true == self._recommendedBefore then
    return
  end
  if self._savedDelay % 2 > 1 then
    return
  end
  self._type = (self._type + 1) % Recommend_TYPE.COUNTOFTYPE
  self:ProcessRecommend(self._type)
  return
end
function PaGlobal_RecommendManager:GetNowRecommendType()
  return self._nowRecommendedType
end
function PaGlobal_RecommendManager:isFromRecommend()
  return self._FromRecommendManager
end
function PaGlobal_RecommendManager:UsedFromRecommend()
  self._FromRecommendManager = false
end
function PaGlobal_RecommendManager:ClickedRecommendButton()
  self._recommendedBefore = true
  self._FromRecommendManager = true
  self._savedDelay = 0
  self._expforCheckInCombat = 0
end
function PaGlobal_RecommendManager:ProcessRecommend(type)
  if Recommend_TYPE.TYPE_INVENTORY == type then
    if true == self:getInventoryisFull() then
      self:ChangeRecommendIconTexture(type)
      return true
    end
  elseif Recommend_TYPE.TYPE_PET == type then
    if true == self:getHavePetNow() then
      self:ChangeRecommendIconTexture(type)
      return true
    end
  elseif Recommend_TYPE.TYPE_WEIGHT == type and true == self:getWeightisFull() then
    self:ChangeRecommendIconTexture(type)
    return true
  end
  return false
end
function PaGlobal_RecommendManager:ChangeRecommendIconTexture(type)
  self._nowRecommendedType = type
  self._recommendedBefore = true
  self._savedDelay = 0
  Panel_CashShopAlert:ChangeTexture(type)
end
function PaGlobal_RecommendManager:getInventoryisFull()
  local size = getSelfPlayer():get():getInventory():size()
  if size >= self.MAXSLOT then
    return false
  end
  local cnt = getSelfPlayer():get():getInventory():getFreeCount()
  return 0 == cnt
end
local weightItemList = {
  604,
  605,
  606,
  607
}
function PaGlobal_RecommendManager:getWeightisFull()
  local mylimit = false
  for key, value in pairs(weightItemList) do
    if getIngameCashMall():getRemainingLimitCount(value) ~= 0 then
      mylimit = true
    end
  end
  if false == mylimit then
    return false
  end
  local selfPlayer = getSelfPlayer():get()
  local s64_allWeight = selfPlayer:getCurrentWeight_s64()
  local s64_maxWeight = selfPlayer:getPossessableWeight_s64()
  local allWeight = Int64toInt32(s64_allWeight) / 10000
  local maxWeight = Int64toInt32(s64_maxWeight) / 10000
  local sumtotalWeight = allWeight / maxWeight * 100
  return sumtotalWeight >= 100
end
function PaGlobal_RecommendManager:getHavePetNow()
  local HavePet = 0 ~= ToClient_getPetUnsealedList() + ToClient_getPetSealedList()
  if HavePet then
    return false
  end
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local isSafeZone = regionInfo:get():isSafeZone()
  if isSafeZone then
    if 0 ~= self._expforCheckInCombat then
      self._expforCheckInCombat = 0
    end
    return false
  end
  local nowexp = getSelfPlayer():get():getExp_s64()
  if 0 == self._expforCheckInCombat then
    self._expforCheckInCombat = nowexp
  end
  if self._expforCheckInCombat ~= nowexp then
    self._expforCheckInCombat = nowexp
    return true
  end
  return false
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Recommend_Manager")
function FromClient_luaLoadComplete_Recommend_Manager()
  if true == gameOptionSetting:getCashAlert() then
    return
  end
  Panel_CashShopAlert:RegisterUpdateFunc("FGlobal_RecommendManager_UpdatePerFrame")
  Panel_UIMain:RegisterUpdateFunc("FGlobal_CashShopAlert_UpdatePerFrame")
end
