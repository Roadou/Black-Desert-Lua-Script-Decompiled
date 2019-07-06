local buffTooltipIndex = 0
local isTooltipDebuff = false
function ShowBuffTooltip(buffIndex, isDebuff)
  local appliedBuff = getSelfPlayer():getAppliedBuffByIndex(buffIndex - 1, isDebuff)
  if nil == appliedBuff then
    return
  end
  buffTooltipIndex = buffIndex
  isTooltipDebuff = isDebuff
  local icon
  if isDebuff then
    icon = PaGlobalAppliedBuffList._uiDeBuffList[buffIndex]
  else
    icon = PaGlobalAppliedBuffList._uiBuffList[buffIndex]
  end
  local tooltipIndex = buffIndex
  if isDebuff then
    tooltipIndex = tooltipIndex + PaGlobalAppliedBuffList._maxBuffCount
  end
  if appliedBuff ~= nil then
    TooltipCommon_Show(tooltipIndex, icon, appliedBuff:getIconName(), appliedBuff:getBuffDesc(), "")
  end
end
function HideBuffTooltip(buffIndex, isDebuff)
  local tooltipIndex = buffIndex
  if isDebuff then
    tooltipIndex = tooltipIndex + PaGlobalAppliedBuffList._maxBuffCount
  end
  TooltipCommon_Hide(tooltipIndex)
end
local sumCount = 0
local default_uiBackBuffPosX = PaGlobalAppliedBuffList._uiBackBuff:GetPosX() + 50
function PaGlobalAppliedBuffList:updateBuff(isDebuff)
  local uiBuffList = self._uiDeBuffList
  local uiBackBuff = self._uiBackDeBuff
  if false == isDebuff then
    uiBuffList = self._uiBuffList
    uiBackBuff = self._uiBackBuff
  end
  local buffIndex = 0
  local appliedBuff = getSelfPlayer():getAppliedBuffBegin(isDebuff)
  while appliedBuff ~= nil do
    buffIndex = buffIndex + 1
    if buffIndex > self._maxBuffCount then
      buffIndex = buffIndex - 1
      break
    end
    local u64_calc_time1 = appliedBuff:getRemainedTime_u64() / Defines.u64_const.u64_1000
    uiBuffList[buffIndex]:ChangeTextureInfoNameAsync("icon/" .. appliedBuff:getIconName())
    uiBuffList[buffIndex]:SetShow(true)
    uiBuffList[buffIndex]:SetText(Util.Time.inGameTimeFormattingTop(u64_calc_time1))
    appliedBuff = getSelfPlayer():getAppliedBuffNext(isDebuff)
  end
  if buffIndex > 0 then
    uiBackBuff:SetSize(buffIndex * 33 + 4, 52)
    uiBackBuff:SetShow(true)
  else
    uiBackBuff:SetShow(false)
  end
  sumCount = sumCount + buffIndex
  while buffIndex < self._maxBuffCount do
    buffIndex = buffIndex + 1
    uiBuffList[buffIndex]:SetShow(false)
  end
  if buffIndex > 17 then
    uiBackBuff:SetPosX(default_uiBackBuffPosX - (buffIndex - 17) / 2 * 33)
  else
    uiBackBuff:SetPosX(default_uiBackBuffPosX)
  end
  for index = 1, buffIndex do
    uiBuffList[index]:SetPosX(uiBackBuff:GetPosX() + 33 * (index - 1) + 2)
  end
end
function PaGlobalAppliedBuffList:updateBuffList()
  if false == self._initialized then
    return
  end
  sumCount = 0
  PaGlobalAppliedBuffList:updateBuff(true)
  PaGlobalAppliedBuffList:updateBuff(false)
  if 0 == sumCount then
    TooltipCommon_Hide(TooltipCommon_getCurrentIndex())
  end
end
function PaGlobalAppliedBuffList:getAlchemyStoneBuff_RemainTime()
  self:updateBuff(false)
  local BuffKey = getEquipedAlchemyStoneBuffkey()
  if -1 == BuffKey then
    return -1
  end
  local appliedBuff = getSelfPlayer():getAppliedBuffBegin(false)
  while appliedBuff ~= nil do
    if BuffKey == appliedBuff:getBuffKey() then
      local u64_calc_time1 = appliedBuff:getRemainedTime_u64() / Defines.u64_const.u64_1000
      return Int64toInt32(u64_calc_time1)
    end
    appliedBuff = getSelfPlayer():getAppliedBuffNext(false)
  end
  return -1
end
local _cumulateTime = 0
function AppliedBuffList_Update(fDeltaTime)
  if isFlushedUI() then
    return
  end
  _cumulateTime = _cumulateTime + fDeltaTime
  PaGlobalAppliedBuffList:updateBuffList()
  local cumulateTimeInSecond = math.floor(_cumulateTime)
  local u64_cumulateTime = toUint64(0, cumulateTimeInSecond)
  if _cumulateTime > 1 then
    _cumulateTime = 0
  end
end
function ResponseBuff_changeBuffList()
  if isFlushedUI() then
    return
  end
  PaGlobalAppliedBuffList:updateBuffList()
end
function buff_RunPostRestoreFunction(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  ResponseBuff_changeBuffList()
end
registerEvent("FromClient_RenderModeChangeState", "buff_RunPostRestoreFunction")
function FGlobal_BuffTooltipOff()
  HideBuffTooltip(buffTooltipIndex, isTooltipDebuff)
end
registerEvent("ResponseBuff_changeBuffList", "ResponseBuff_changeBuffList")
if false == _ContentsGroup_ReducedLua then
  Instance_AppliedBuffList:RegisterUpdateFunc("AppliedBuffList_Update")
end
