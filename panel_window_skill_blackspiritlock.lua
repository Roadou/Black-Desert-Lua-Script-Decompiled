Panel_Window_Skill_BlackSpiritLock:SetShow(false)
local PaGlobal_BlackSpiritSkillLock = {
  _ui = {
    _closeBtn = UI.getChildControl(Panel_Window_Skill_BlackSpiritLock, "Button_Win_Close"),
    _checkBtn_AllLock = UI.getChildControl(Panel_Window_Skill_BlackSpiritLock, "CheckButton_LockAll"),
    _list2_SkillList = UI.getChildControl(Panel_Window_Skill_BlackSpiritLock, "List2_SkillList"),
    _desc = UI.getChildControl(Panel_Window_Skill_BlackSpiritLock, "StaticText_Desc")
  },
  _classType = nil,
  _sortByRage = {}
}
function PaGlobal_BlackSpiritSkillLock:init()
  self._ui._list2_SkillList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "BlackSpiritSkillList")
  self._ui._list2_SkillList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  self._classType = getSelfPlayer():getClassType()
  self:setSkill()
  self._ui._desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._desc:SetText(self._ui._desc:GetText())
  self._ui._checkBtn_AllLock:addInputEvent("Mouse_LUp", "PAGlobalFunc_BlackSkillAllLock()")
  self._ui._checkBtn_AllLock:SetEnableArea(0, 0, self._ui._checkBtn_AllLock:GetSizeX() + self._ui._checkBtn_AllLock:GetTextSizeX() + 10, self._ui._checkBtn_AllLock:GetSizeY())
  self._ui._closeBtn:addInputEvent("Mouse_LUp", "FGlobal_BlackSpiritSkillLock_Close()")
end
function BlackSpiritSkillList(content, key)
  local self = PaGlobal_BlackSpiritSkillLock
  local bg = UI.getChildControl(content, "Static_Bg")
  local skillIcon = UI.getChildControl(content, "Static_SkillIcon")
  local skillName = UI.getChildControl(content, "StaticText_SkillName")
  local rageText = UI.getChildControl(content, "StaticText_Percent")
  local checkBtn = UI.getChildControl(content, "CheckButton_Lock")
  local _key = Int64toInt32(key)
  local data = self._sortByRage[_key + 1]
  local skillWrapper = ToClient_GetBlackSkillWrapper(self._classType, data.index)
  if nil ~= skillWrapper then
    local skillNo = skillWrapper:getSkillNo()
    local skillLevelInfo = getSkillLevelInfo(skillNo)
    local skillKey = skillLevelInfo._skillKey
    local skillTypeSSW = skillWrapper:getSkillTypeStaticStatusWrapper()
    local isLock = ToClient_isBlockBlackSpiritSkill(skillKey)
    local paColor = "<PAColor0xFFefefef>"
    if isLock then
      paColor = "<PAColor0xFF9397a7>"
    end
    skillIcon:ChangeTextureInfoName("icon/" .. skillTypeSSW:getIconPath())
    skillName:SetText(paColor .. skillWrapper:getName() .. "<PAOldColor>")
    rageText:SetText(paColor .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BLACKSPIRITLOCK_RAGEDESC", "rageValue", data.rage) .. "<PAOldColor>")
    checkBtn:SetCheck(isLock)
    bg:addInputEvent("Mouse_LUp", "PAGlobalFunc_BlackSkillLock(" .. skillNo .. ", " .. _key .. ")")
    skillIcon:addInputEvent("Mouse_LUp", "PAGlobalFunc_BlackSkillLock(" .. skillNo .. ", " .. _key .. ")")
    skillIcon:addInputEvent("Mouse_On", "PAGlobalFunc_BlackSpiritLock_TooltipShow(" .. skillNo .. ")")
    skillIcon:addInputEvent("Mouse_Out", "PAGlobalFunc_BlackSpiritLock_TooltipHide()")
  end
  function PAGlobalFunc_BlackSpiritLock_TooltipShow(skillNo)
    Panel_SkillTooltip_SetPosition(skillNo, skillIcon, "blackSpiritLock")
    Panel_SkillTooltip_Show(skillNo, false, "blackSpiritLock")
  end
end
function PAGlobalFunc_BlackSpiritLock_TooltipHide()
  Panel_SkillTooltip_Hide()
end
function PAGlobalFunc_BlackSkillLock(skillNo, index)
  local self = PaGlobal_BlackSpiritSkillLock
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
  local skillName = skillTypeStaticWrapper:getName()
  if nil ~= skillLevelInfo then
    local isBlockSkill = ToClient_isBlockBlackSpiritSkill(skillLevelInfo._skillKey)
    if isBlockSkill then
      ToClient_enableblockBlackSpiritSkill(skillLevelInfo._skillKey)
      Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BLACKSPIRITLOCK_UNLOCKSKILL", "skillName", skillName), nil, nil, nil, true)
    else
      ToClient_blockBlackSpiritSkill(skillLevelInfo._skillKey)
      Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BLACKSPIRITLOCK_LOCKSKILL", "skillName", skillName), nil, nil, nil, true)
    end
  end
  self._ui._list2_SkillList:requestUpdateByKey(toInt64(0, index))
  audioPostEvent_SystemUi(1, 46)
end
function PAGlobalFunc_BlackSkillAllLock()
  local self = PaGlobal_BlackSpiritSkillLock
  local isCheck = self._ui._checkBtn_AllLock:IsCheck()
  local num = ToClient_BlackSkillCount(self._classType)
  local count = 0
  for index = 0, num - 1 do
    local skillWrapper = ToClient_GetBlackSkillWrapper(self._classType, index)
    if nil ~= skillWrapper then
      local skillNo = skillWrapper:getSkillNo()
      local skillLevelInfo = getSkillLevelInfo(skillNo)
      local skillKey = skillLevelInfo._skillKey
      if skillLevelInfo._usable and skillWrapper:isUseableActiveSkill() then
        if isCheck then
          ToClient_blockBlackSpiritSkill(skillKey)
        else
          ToClient_enableblockBlackSpiritSkill(skillKey)
        end
        count = count + 1
      end
    end
  end
  self._ui._list2_SkillList:getElementManager():clearKey()
  for index = 0, count - 1 do
    self._ui._list2_SkillList:getElementManager():pushKey(toInt64(0, index))
  end
  if isCheck then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRITLOCK_ALLLOCKSKILL"), nil, nil, nil, true)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRITLOCK_ALLUNLOCKSKILL"), nil, nil, nil, true)
  end
  audioPostEvent_SystemUi(1, 46)
end
function PaGlobal_BlackSpiritSkillLock:setSkill()
  local num = ToClient_BlackSkillCount(self._classType)
  local count = 0
  for i = 0, num - 1 do
    local skillWrapper = ToClient_GetBlackSkillWrapper(self._classType, i)
    if nil ~= skillWrapper then
      local skillNo = skillWrapper:getSkillNo()
      local skillLevelInfo = getSkillLevelInfo(skillNo)
      if skillLevelInfo._usable and skillWrapper:isUseableActiveSkill() then
        self._sortByRage[count + 1] = {
          index = i,
          rage = skillWrapper:getNeedAdPoint() / 100
        }
        count = count + 1
      end
    end
  end
  self._ui._list2_SkillList:getElementManager():clearKey()
  for i = 0, count - 1 do
    self._ui._list2_SkillList:getElementManager():pushKey(toInt64(0, i))
  end
end
function PaGlobal_BlackSpiritSkillLock:open(whereType)
  local num = ToClient_BlackSkillCount(self._classType)
  local count = 0
  for i = 0, num - 1 do
    local skillWrapper = ToClient_GetBlackSkillWrapper(self._classType, i)
    if nil ~= skillWrapper then
      local skillNo = skillWrapper:getSkillNo()
      local skillLevelInfo = getSkillLevelInfo(skillNo)
      if skillLevelInfo._usable and skillWrapper:isUseableActiveSkill() then
        count = count + 1
      end
    end
  end
  if 0 == count then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRITLOCK_IMPOSSIBLE"), nil, nil, nil, true)
    return
  end
  if 0 == whereType then
    Panel_Window_Skill_BlackSpiritLock:SetPosX(math.min(Panel_Adrenallin:GetPosX() + Panel_Adrenallin:GetSizeX() + 20, getScreenSizeX() - Panel_Window_Skill_BlackSpiritLock:GetSizeX()))
    Panel_Window_Skill_BlackSpiritLock:SetPosY(math.max(0, Panel_Adrenallin:GetPosY() + Panel_Adrenallin:GetSizeY() - Panel_Window_Skill_BlackSpiritLock:GetSizeY()))
  elseif 1 == whereType then
    Panel_Window_Skill_BlackSpiritLock:SetPosX(80)
    Panel_Window_Skill_BlackSpiritLock:SetPosY(140)
  elseif 2 == whereType then
    if getScreenSizeX() < Panel_Window_Skill:GetPosX() + Panel_Window_Skill:GetSizeX() + Panel_Window_Skill_BlackSpiritLock:GetSizeX() then
      Panel_Window_Skill_BlackSpiritLock:SetPosX(Panel_Window_Skill:GetPosX() - Panel_Window_Skill_BlackSpiritLock:GetSizeX())
    else
      Panel_Window_Skill_BlackSpiritLock:SetPosX(Panel_Window_Skill:GetPosX() + Panel_Window_Skill:GetSizeX())
    end
    Panel_Window_Skill_BlackSpiritLock:SetPosY(Panel_Window_Skill:GetPosY())
    if Panel_EnableSkill:GetShow() then
      FGlobal_EnableSkillCloseFunc()
    elseif Panel_SkillCoolTimeSlot:GetShow() then
      PaGlobal_Window_Skill_CoolTimeSlot:closeFunc()
    end
  end
  Panel_Window_Skill_BlackSpiritLock:SetShow(true)
end
function PaGlobal_BlackSpiritSkillLock:close()
  Panel_Window_Skill_BlackSpiritLock:SetShow(false)
  PAGlobalFunc_BlackSpiritLock_TooltipHide()
  if Panel_Window_Skill:GetShow() then
    EnableSkillShowFunc()
  end
end
function FGlobal_BlackSpiritSkillLock_Open(whereType)
  PaGlobal_BlackSpiritSkillLock:open(whereType)
end
function FGlobal_BlackSpiritSkillLock_Close()
  PaGlobal_BlackSpiritSkillLock:close()
end
function PaGlobal_BlackSpiritSkillLock_Update()
  ToClient_updateBlackSpiritSkill()
  PaGlobal_BlackSpiritSkillLock:setSkill()
end
PaGlobal_BlackSpiritSkillLock:init()
registerEvent("EventSkillWindowUpdate", "PaGlobal_BlackSpiritSkillLock_Update")
registerEvent("EventSkillWindowClearSkill", "PaGlobal_BlackSpiritSkillLock_Update")
registerEvent("EventSkillWindowClearSkillAll", "PaGlobal_BlackSpiritSkillLock_Update")
registerEvent("EventSkillWindowClearSkillByPoint", "PaGlobal_BlackSpiritSkillLock_Update")
