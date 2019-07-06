local workerNoUndefined = 0
local appliedStat = NpcWorkerSkillAppliedStat()
local checkData = PlantWorkerPassiveSkillCheckData(appliedStat)
local workerWrapper = {}
workerWrapper.__index = workerWrapper
function workerWrapper:init(workerNoRaw, callReflesh)
  self:initOnly(workerNoRaw, callReflesh)
  self:setClientValue()
end
function workerWrapper:initOnly(workerNoRaw, callReflesh)
  self._workerNoRaw = workerNoRaw
  if nil == callReflesh then
    self._callReflesh = true
  else
    self._callReflesh = callReflesh
  end
end
function workerWrapper:reflesh()
  if false == self._callReflesh then
    return
  end
  self:setClientValue()
end
function workerWrapper:isWorking()
  return nil ~= self._workingWrapper
end
function workerWrapper:isValid()
  return nil ~= self._workerWrapper and nil ~= self._workerWrapper:get()
end
function workerWrapper:setClientValue()
  self._workerWrapper = ToClient_getNpcWorkerByWorkerNo(self._workerNoRaw)
  self._workingWrapper = ToClient_getNpcWorkingByWorkerNo(self._workerNoRaw)
end
function workerWrapper:getWorkerWrapper()
  return self._workerWrapper
end
function workerWrapper:getWorkingCount()
  self:reflesh()
  return self:getWorkingCountXXX()
end
function workerWrapper:getWorkingCountXXX()
  return ToClient_getNpcWorkerWorkingCount(self._workerNoRaw)
end
function workerWrapper:getLeftWorkingTime()
  self:reflesh()
  return self:getLeftWorkingTimeXXX(getServerUtc64())
end
function workerWrapper:getLeftWorkingTimeXXX(serverUtc64)
  if false == self:isWorking() then
    return 0
  end
  return Int64toInt32(self._workingWrapper:getLeftWorkTime(serverUtc64))
end
function workerWrapper:isWorkTimeUnlimitXXX()
  if false == self:isWorking() then
    return true
  end
  return self._workingWrapper:isWorkTimeUnlimit()
end
function workerWrapper:getTotalWorkTime()
  self:reflesh()
  return self:getTotalWorkTimeXXX(getServerUtc64())
end
function workerWrapper:getTotalWorkTimeXXX(serverUtc64)
  if false == self:isWorking() then
    return 0
  end
  return Int64toInt32(self._workingWrapper:getTotalWorkTime(serverUtc64))
end
function workerWrapper:getWorkingState()
  self:reflesh()
  return self:getWorkingStateXXX()
end
function workerWrapper:getWorkingStateXXX()
  if false == self:isWorking() then
    return CppEnums.NpcWorkingState.eNpcWorkingState_Undefined
  end
  return self._workingWrapper:getWorkingState()
end
function workerWrapper:currentProgressPercents()
  self:reflesh()
  if false == self:isWorking() then
    return 0
  end
  if self:isWorkTimeUnlimitXXX() then
    return 0
  end
  local serverUtc64 = getServerUtc64()
  local working_LeftTime = self:getLeftWorkingTimeXXX(serverUtc64)
  local working_TotalTime = self:getTotalWorkTimeXXX(serverUtc64)
  if 0 == working_TotalTime then
    return 0
  end
  return 100 - working_LeftTime / working_TotalTime * 100
end
function workerWrapper:getWorkStringOnlyTarget()
  self:reflesh()
  local workString = ""
  if self:isWorking() then
    local working_LeftTime = 0
    local isWorkTimeUnlimit = self:isWorkTimeUnlimitXXX()
    if false == isWorkTimeUnlimit then
      working_LeftTime = self:getLeftWorkingTimeXXX(getServerUtc64())
    end
    if self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone) or self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse) or self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouseLargeCraft) then
      local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(self._workerNoRaw)
      if nil ~= esSSW then
        workString = "(" .. self._workingWrapper:getWorkingNodeName() .. ")"
      end
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantBuliding) then
      local name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_BULDINGTYPE_FORTRESS")
      local characterSSW = self._workingWrapper:getBuildingCharacterInfo()
      if nil ~= characterSSW then
        name = characterSSW:getName()
      end
      workString = Util.Time.timeFormatting(math.ceil(working_LeftTime / 1000)) .. " <PAColor0xffd0ee68>[" .. name .. "]<PAOldColor>"
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_Upgrade) then
      workString = Util.Time.timeFormatting(math.ceil(working_LeftTime / 1000)) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_UPGRADE")
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_GuildHouseLargeCraft) then
      local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(self._workerNoRaw)
      if nil ~= esSSW then
        local _leftWorkCount = self:getWorkingCountXXX()
        if _leftWorkCount > 0 then
          workString = Util.Time.timeFormatting(math.ceil(working_LeftTime / 1000)) .. " [" .. esSSW:getDescription() .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_LEFTWORKCOUNT", "leftWorkCount", _leftWorkCount + 1) .. "]"
        else
          workString = Util.Time.timeFormatting(math.ceil(working_LeftTime / 1000)) .. " [" .. esSSW:getDescription() .. "]"
        end
      end
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking) then
      if false == isWorkTimeUnlimit then
        workString = Util.Time.timeFormatting(math.ceil(working_LeftTime / 1000))
      end
      local workingState = self:getWorkingStateXXX()
      if CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_MoveTo == workingState then
        workString = workString .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_GOHARVEST")
      elseif CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Working == workingState then
        workString = workString .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_HARVESTMANAGING")
      elseif CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Return == workingState then
        workString = workString .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_GOHOME")
      end
    end
  elseif self:getIsAuctionInsert() then
    workString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_MARKETREGIST")
  else
    workString = ""
  end
  return workString
end
function workerWrapper:getWorkString()
  self:reflesh()
  local workString = ""
  if self:isWorking() then
    local working_LeftTime = 0
    local isWorkTimeUnlimit = self:isWorkTimeUnlimitXXX()
    if false == isWorkTimeUnlimit then
      working_LeftTime = self:getLeftWorkingTimeXXX(getServerUtc64())
    end
    if self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone) or self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse) or self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouseLargeCraft) then
      local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(self._workerNoRaw)
      if nil ~= esSSW then
        local _leftWorkCount = self:getWorkingCountXXX()
        if _leftWorkCount > 0 then
          workString = Util.Time.timeFormatting(math.ceil(working_LeftTime / 1000)) .. " [" .. esSSW:getDescription() .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_LEFTWORKCOUNT", "leftWorkCount", _leftWorkCount) .. "]"
        else
          workString = Util.Time.timeFormatting(math.ceil(working_LeftTime / 1000)) .. " [" .. esSSW:getDescription() .. "]"
        end
      end
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantBuliding) then
      local name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_BULDINGTYPE_FORTRESS")
      local characterSSW = self._workingWrapper:getBuildingCharacterInfo()
      if nil ~= characterSSW then
        name = characterSSW:getName()
      end
      workString = Util.Time.timeFormatting(math.ceil(working_LeftTime / 1000)) .. " <PAColor0xffd0ee68>[" .. name .. "]<PAOldColor>"
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_Upgrade) then
      workString = Util.Time.timeFormatting(math.ceil(working_LeftTime / 1000)) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_UPGRADE")
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_GuildHouseLargeCraft) then
      local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(self._workerNoRaw)
      if nil ~= esSSW then
        local _leftWorkCount = self:getWorkingCountXXX()
        if _leftWorkCount > 0 then
          workString = Util.Time.timeFormatting(math.ceil(working_LeftTime / 1000)) .. " [" .. esSSW:getDescription() .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_LEFTWORKCOUNT", "leftWorkCount", _leftWorkCount) .. "]"
        else
          workString = Util.Time.timeFormatting(math.ceil(working_LeftTime / 1000)) .. " [" .. esSSW:getDescription() .. "]"
        end
      end
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking) then
      if false == isWorkTimeUnlimit then
        workString = Util.Time.timeFormatting(math.ceil(working_LeftTime / 1000))
      end
      local workingState = self:getWorkingStateXXX()
      if CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_MoveTo == workingState then
        workString = workString .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_GOHARVEST")
      elseif CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Working == workingState then
        workString = workString .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_HARVESTMANAGING")
      elseif CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Return == workingState then
        workString = workString .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_GOHOME")
      end
    end
  elseif self:getIsAuctionInsert() then
    workString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_MARKETREGIST")
  else
    local workerRegionWrapper = ToClient_getRegionInfoWrapper(self._workerWrapper:get())
    local isWorkInTrade = self._workerWrapper:isWorkerInWorkerTrade()
    if true == isWorkInTrade then
      workString = "\236\157\188\234\190\188 \235\172\180\236\151\173 \236\164\145"
    elseif false == _ContentsGroup_RenewUI_Worker then
      workString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_WAITING", "getAreaName", workerRegionWrapper:getAreaName())
    else
      workString = "<PAColor0xffaaaaaa>[" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADEMAIN_WAIT") .. ":" .. workerRegionWrapper:getAreaName() .. "]<PAOldColor>"
    end
  end
  return workString
end
function workerWrapper:getWorkingType()
  self:reflesh()
  local workingType
  if self:isWorking() then
    if self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone) then
      workingType = CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_Upgrade) then
      workingType = CppEnums.NpcWorkingType.eNpcWorkingType_Upgrade
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse) then
      workingType = CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_ChangeTown) then
      workingType = CppEnums.NpcWorkingType.eNpcWorkingType_ChangeTown
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantBuliding) then
      workingType = CppEnums.NpcWorkingType.eNpcWorkingType_PlantBuliding
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_RegionManaging) then
      workingType = CppEnums.NpcWorkingType.eNpcWorkingType_RegionManaging
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouseLargeCraft) then
      workingType = CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouseLargeCraft
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_HouseParty) then
      workingType = CppEnums.NpcWorkingType.eNpcWorkingType_HouseParty
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_GuildHouseLargeCraft) then
      workingType = CppEnums.NpcWorkingType.eNpcWorkingType_GuildHouseLargeCraft
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking) then
      workingType = CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking
    end
  else
    workingType = CppEnums.NpcWorkingType.eNpcWorkingType_Count
  end
  return workingType
end
function workerWrapper:getName()
  self:reflesh()
  return self._workerWrapper:getName()
end
function workerWrapper:getLevel()
  self:reflesh()
  return self._workerWrapper:get():getLevel()
end
function workerWrapper:getExperience()
  self:reflesh()
  return self._workerWrapper:get():getExperience()
end
function workerWrapper:getMaxExperience()
  self:reflesh()
  return self._workerWrapper:get():getMaxExperience()
end
function workerWrapper:getHomeWaypoint()
  self:reflesh()
  return self._workerWrapper:get():getHomeWaypoint()
end
function workerWrapper:getActionPoint()
  self:reflesh()
  return self:getActionPointXXX()
end
function workerWrapper:getActionPointXXX()
  return self._workerWrapper:get():getActionPoint()
end
function workerWrapper:getMaxActionPoint()
  self:reflesh()
  return self:getMaxActionPointXXX()
end
function workerWrapper:getMaxActionPointXXX()
  return self._workerWrapper:get():getWorkerStaticStatus()._actionPoint
end
function workerWrapper:getActionPointPercents()
  self:reflesh()
  return self:getActionPointXXX() / self:getMaxActionPointXXX() * 100
end
function workerWrapper:getGrade()
  self:reflesh()
  return self:getGradeXXX()
end
function workerWrapper:getGradeXXX()
  return self._workerWrapper:get():getWorkerStaticStatus():getCharacterStaticStatus()._gradeType:get()
end
function workerWrapper:getUpgradePoint()
  self:reflesh()
  return self._workerWrapper:get():getUpgradePoint()
end
function workerWrapper:getGradeToColor()
  local grade = self:getGradeXXX()
  if CppEnums.CharacterGradeType.CharacterGradeType_Normal == grade then
    return Defines.Color.C_FFC4BEBE
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Elite == grade then
    return Defines.Color.C_FF5DFF70
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Hero == grade then
    return Defines.Color.C_FF4B97FF
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Legend == grade then
    return Defines.Color.C_FFFFC832
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Boss == grade then
    return Defines.Color.C_FFFF6C00
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Assistant == grade then
    return Defines.Color.C_FFC4BEBE
  end
  return Defines.Color.C_FFC4BEBE
end
function workerWrapper:getGradeToColorString()
  local grade = self:getGradeXXX()
  if CppEnums.CharacterGradeType.CharacterGradeType_Normal == grade then
    return "<PAColor0xffc4bebe>"
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Elite == grade then
    return "<PAColor0xFF5DFF70>"
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Hero == grade then
    return "<PAColor0xFF4B97FF>"
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Legend == grade then
    return "<PAColor0xFFFFC832>"
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Boss == grade then
    return "<PAColor0xFFFF6C00>"
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Assistant == grade then
    return "<PAColor0xffc4bebe>"
  end
  return "<PAColor0xffc4bebe>"
end
function workerWrapper:requestUpgrade()
  return ToClient_requestStartUpgrade(self._workerNoRaw)
end
function workerWrapper:isUpgradable()
  self:reflesh()
  return self._workerWrapper:get():isUpgradable()
end
function workerWrapper:getIsAuctionInsert()
  self:reflesh()
  return self._workerWrapper:get():getIsAuctionInsert()
end
function workerWrapper:isSellable()
  self:reflesh()
  return self._workerWrapper:get():isSellable()
end
function workerWrapper:checkValidWorkerPrice(price)
  self:reflesh()
  return 0 == self._workerWrapper:get():checkValidWorkerPrice(toInt64(0, price))
end
function workerWrapper:getWorkerMinPrice()
  self:reflesh()
  return Int64toInt32(self._workerWrapper:getWorkerMinPrice())
end
function workerWrapper:getWorkerMaxPrice()
  self:reflesh()
  return Int64toInt32(self._workerWrapper:getWorkerMaxPrice())
end
function workerWrapper:getMoveSpeedWithSkill(workingType, houseUseType, waypointKey)
  self:reflesh()
  if nil == self._workerWrapper or nil == self._workerWrapper:get() then
    return 0
  end
  local checkData = self._workerWrapper:get():getStaticSkillCheckData()
  checkData:set(workingType, houseUseType, waypointKey)
  checkData._diceCheckForceSuccess = true
  return self._workerWrapper:getMoveSpeedWithSkill(checkData)
end
function workerWrapper:getMoveSpeed()
  self:reflesh()
  return self._workerWrapper:get():getMoveSpeed()
end
function workerWrapper:getWorkEfficienceWithSkill(workingType, houseUseType, waypointKey, productCategory)
  self:reflesh()
  if nil == self._workerWrapper or nil == self._workerWrapper:get() then
    return 0
  end
  local checkData = self._workerWrapper:get():getStaticSkillCheckData()
  checkData:set(workingType, houseUseType, waypointKey)
  checkData._diceCheckForceSuccess = true
  return self._workerWrapper:getWorkEfficienceWithSkill(checkData, productCategory)
end
function workerWrapper:getWorkEfficiency(productCategory)
  self:reflesh()
  return self._workerWrapper:get():getWorkEfficiency(productCategory)
end
function workerWrapper:getLuckWithSkill(workingType, houseUseType, waypointKey)
  self:reflesh()
  if nil == self._workerWrapper or nil == self._workerWrapper:get() then
    return 0
  end
  local checkData = self._workerWrapper:get():getStaticSkillCheckData()
  checkData:set(workingType, houseUseType, waypointKey)
  checkData._diceCheckForceSuccess = true
  return self._workerWrapper:getLuckWithSkill(checkData)
end
function workerWrapper:getAdditionalRepeatCount(workingType, houseUseType, waypointKey, itemExchangeKeyRaw)
  self:reflesh()
  if nil == self._workerWrapper or nil == self._workerWrapper:get() then
    return 0
  end
  local checkData = self._workerWrapper:get():getStaticSkillCheckData()
  checkData:set(workingType, houseUseType, waypointKey)
  checkData:setItemExchangeStaticStatus(ItemExchangeKey(itemExchangeKeyRaw))
  checkData._diceCheckForceSuccess = true
  return self._workerWrapper:getAdditionalRepeatCount(checkData)
end
function workerWrapper:getLuck()
  self:reflesh()
  return self._workerWrapper:get():getLuck()
end
function workerWrapper:getWorkerIcon()
  self:reflesh()
  return getWorkerIcon(self._workerWrapper:get():getWorkerStaticStatus())
end
function workerWrapper:getWorkerDefaultSkillStaticStatus()
  self:reflesh()
  return self._workerWrapper:get():getWorkerDefaultSkillStaticStatus()
end
function workerWrapper:getSkillCount()
  self:reflesh()
  return self._workerWrapper:get():getSkillCount()
end
function workerWrapper:foreachSkillList(functor)
  if nil == functor then
    return
  end
  self:reflesh()
  local skillCount = self._workerWrapper:get():getSkillCount()
  for index = 0, skillCount - 1 do
    local skillSSW = self._workerWrapper:get():getWorkerSkillStaticStatusByIndex(index)
    local isStop = functor(index, skillSSW)
    if isStop then
      return
    end
  end
end
function workerWrapper:getSkillSSW(idx)
  self:reflesh()
  local skillSSW = self._workerWrapper:get():getWorkerSkillStaticStatusByIndex(idx)
  return skillSSW
end
function workerWrapper:isMine()
  return nil ~= ToClient_getNpcWorkerByWorkerNo(self._workerNoRaw)
end
function workerWrapper:getIsSellable()
  self:reflesh()
  return self._workerWrapper:getIsSellable()
end
function workerWrapper:isWorkerRepeatable()
  self:reflesh()
  return self._workerWrapper:isWorkerRepeatable()
end
function workerWrapper:getWorkerRepeatableWorkingWrapper()
  self:reflesh()
  return self._workerWrapper:getWorkerRepeatableWorkingWrapper()
end
function workerWrapper:isWorkingable(toWaypointKey)
  self:reflesh()
  if nil == self._workerWrapper then
    return false
  end
  return self._workerWrapper:isWorkingable(toWaypointKey)
end
function workerWrapper:checkPossibleChangesSkillKey()
  self:reflesh()
  if nil == self._workerWrapper then
    return false
  end
  return self._workerWrapper:checkPossibleChangesSkillKey()
end
function workerWrapper:getNeedExperienceByChangeSkill()
  self:reflesh()
  if nil == self._workerWrapper then
    return 0
  end
  return self._workerWrapper:getNeedExperienceByChangeSkill()
end
function workerWrapper:getWorkingNodeDescXXX()
  local workString = ""
  if self:isWorking() then
    local working_LeftTime = 0
    local isWorkTimeUnlimit = self:isWorkTimeUnlimitXXX()
    if false == isWorkTimeUnlimit then
      working_LeftTime = self:getLeftWorkingTimeXXX(getServerUtc64())
    end
    if self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone) then
      local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(self._workerNoRaw)
      if nil ~= esSSW then
        workString = self._workingWrapper:getWorkingNodeDesc()
      end
    elseif self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse) or self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouseLargeCraft) or self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_GuildHouseLargeCraft) then
      local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(self._workerNoRaw)
      if nil ~= esSSW then
        workString = self._workingWrapper:getWorkingNodeName()
      end
    end
  else
    workString = ""
  end
  return workString
end
function workerWrapper:getWorkingNodeDesc()
  self:reflesh()
  return self:getWorkingNodeDescXXX()
end
local function getWorkerWrapperOnlyInit(workerNoRaw, callReflesh)
  if nil == workerNoRaw or workerNoUndefined == workerNoRaw then
    return nil
  end
  local copyValue = {}
  setmetatable(copyValue, workerWrapper)
  copyValue:initOnly(workerNoRaw, callReflesh)
  return copyValue
end
function getWorkerWrapper(workerNoRaw, callReflesh)
  if nil == workerNoRaw or workerNoUndefined == workerNoRaw then
    return nil
  end
  local copyValue = {}
  setmetatable(copyValue, workerWrapper)
  copyValue:init(workerNoRaw, callReflesh)
  if false == copyValue:isValid() then
    return nil
  end
  return copyValue
end
function getWorkerWrapperByAuction(workerNoRaw, callReflesh)
  if nil == workerNoRaw or workerNoUndefined == workerNoRaw then
    return nil
  end
  local copyValue = {}
  setmetatable(copyValue, workerWrapper)
  function copyValue:setClientValue()
    self._workerWrapper = RequestGetAuctionInfo():getWorkerWrapper(self._workerNoRaw)
    self._workingWrapper = nil
  end
  copyValue:init(workerNoRaw, callReflesh)
  if false == copyValue:isValid() then
    return nil
  end
  return copyValue
end
function getGuildHouseWaitWorkerWrapperList(receipeKeyRaw)
  local wrapperList = Array.new()
  local count = ToClient_getGuildHouseLargeCraftWaitWorkerListCount(receipeKeyRaw) - 1
  for index = 0, count do
    local workerNoRaw = ToClient_getGuildHouseLargeCraftWorkerIndex(index)
    local workerLuaWrapper = getWorkerWrapperOnlyInit(workerNoRaw, true)
    if nil ~= workerLuaWrapper then
      wrapperList:push_back({wrapper = workerLuaWrapper, NoRaw = workerNoRaw})
    end
  end
  return wrapperList
end
function getGuildHouseWorkingWorkerWrapperList(receipeKeyRaw, exchangeKeyRaw)
  local wrapperList = Array.new()
  local count = ToClient_getGuildHouseLargeCraftWorkingWorkerListCount(receipeKeyRaw, exchangeKeyRaw) - 1
  for index = 0, count do
    local workerNoRaw = ToClient_getGuildHouseLargeCraftWorkerIndex(index)
    local workerLuaWrapper = getWorkerWrapperOnlyInit(workerNoRaw, true)
    if nil ~= workerLuaWrapper then
      wrapperList:push_back({wrapper = workerLuaWrapper, NoRaw = workerNoRaw})
    end
  end
  return wrapperList
end
function getWaitWorkerFullList(plantKey)
  local plantArray = Array.new()
  local workerArray = Array.new()
  if nil ~= plantKey then
    plantArray:push_back(plantKey)
  else
    local plantConut = ToCleint_getHomePlantKeyListCount()
    for plantIdx = 0, plantConut - 1 do
      local plantKeyRaw = ToCleint_getHomePlantKeyListByIndex(plantIdx)
      local plantKey = PlantKey()
      plantKey:setRaw(plantKeyRaw)
      plantArray:push_back(plantKey)
    end
  end
  local plantSort_do = function(a, b)
    return a:get() < b:get()
  end
  table.sort(plantArray, plantSort_do)
  for plantRawIdx = 1, #plantArray do
    local plantKey = plantArray[plantRawIdx]
    local plantWorkerCount = ToClient_getPlantWaitWorkerListCount(plantKey, 0)
    local workerHouseCount = ToClient_getTownWorkerMaxCapacity(plantKey)
    if plantWorkerCount > workerHouseCount then
      plantWorkerCount = workerHouseCount
    end
    for workerIdx = 0, plantWorkerCount - 1 do
      local workerNoRaw = ToClient_getPlantWaitWorkerNoRawByIndex(plantKey, workerIdx)
      workerArray:push_back(workerNoRaw)
    end
  end
  return workerArray
end
