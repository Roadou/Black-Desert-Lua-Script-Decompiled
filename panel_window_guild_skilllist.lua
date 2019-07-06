local _parent = Panel_Window_Guild_Renew
local _panel = Panel_Window_Guild_SkillList
local GuildSkillList = {
  _ui = {
    stc_TopArea = UI.getChildControl(_panel, "Static_TopArea"),
    stc_SkillListBg = UI.getChildControl(_panel, "Static_SkillListBg")
  },
  _listUiType = {
    passiveTitle = 0,
    passive = 1,
    activeTitle = 2,
    active = 3
  },
  _skillSlot = {},
  _currentUiType = nil,
  _parentBg = nil,
  _skillPassiveCellContainer = nil,
  _skillActiveCellTable = nil,
  _skillPassiveTable = {},
  _skillPassiveTableIdx = nil,
  _firstSkillTable = {},
  _keyIdentifier = 100,
  _skillEffectOriginSpan = 35
}
function GuildSkillList:init()
  self._ui.progress_Point = UI.getChildControl(self._ui.stc_TopArea, "CircularProgress_GuildPoint")
  self._ui.txt_PointPercent = UI.getChildControl(self._ui.stc_TopArea, "StaticText_Percent")
  self._ui.txt_PointValue = UI.getChildControl(self._ui.stc_TopArea, "StaticText_Value")
  self._ui.list_Skill = UI.getChildControl(self._ui.stc_SkillListBg, "List2_SkillList")
  self:registEvent()
end
function GuildSkillList:registEvent()
  self._ui.list_Skill:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_GuildSkill_CreateControl")
  self._ui.list_Skill:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function GuildSkillList:open()
  self._currentUiType = self._listUiType.passiveTitle
  self:initData()
end
function GuildSkillList:initData()
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  self:updateSkillPointData()
  local guidSkillTree = getGuildSkillTree()
  local maxCols = guidSkillTree:capacityX()
  local maxRows = guidSkillTree:capacityY()
  local passiveCellIdx = 0
  local activeCellIdx = 0
  self._skillPassiveCellContainer = {}
  self._skillActiveCellTable = {}
  self._skillPassiveTable = {}
  self._skillPassiveTableIdx = 0
  for rowIdx = 0, maxRows - 1 do
    for colIdx = 0, maxCols - 1 do
      local skillCell = guidSkillTree:atPointer(colIdx, rowIdx)
      if true == skillCell:isSkillType() then
        local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillCell._skillNo)
        local skillTypeStatic = skillTypeStaticWrapper:get()
        if true == skillTypeStaticWrapper:isValidLocalizing() then
          if true == skillTypeStatic:isActiveSkill() then
            self._skillActiveCellTable[activeCellIdx] = skillCell
            activeCellIdx = activeCellIdx + 1
          else
            self._skillPassiveCellContainer[passiveCellIdx] = skillCell
            passiveCellIdx = passiveCellIdx + 1
          end
        end
      end
    end
  end
  self:reArrangeCellTable()
  self._ui.list_Skill:getElementManager():clearKey()
  for listIdx = 0, #self._firstSkillTable + 1 do
    if 0 == listIdx % 2 then
      self._ui.list_Skill:getElementManager():pushKey(toInt64(0, listIdx))
    end
  end
  for listIdx = 0, #self._skillActiveCellTable + 1 do
    self._ui.list_Skill:getElementManager():pushKey(toInt64(0, listIdx + self._keyIdentifier))
  end
end
function GuildSkillList:updateData()
  if false == self._parentBg:GetShow() then
    return
  end
  self:updateSkillPointData()
  self._ui.list_Skill:getElementManager():clearKey()
  for listIdx = 0, #self._firstSkillTable + 1 do
    if 0 == listIdx % 2 then
      self._ui.list_Skill:getElementManager():pushKey(toInt64(0, listIdx))
    end
  end
  for listIdx = 0, #self._skillActiveCellTable + 1 do
    self._ui.list_Skill:getElementManager():pushKey(toInt64(0, listIdx + self._keyIdentifier))
  end
end
function GuildSkillList:updateSkillPointData()
  local guildSkillPoint = ToClient_getSkillPointInfo(3)
  local pointPercent = string.format("%.0f", guildSkillPoint._currentExp / guildSkillPoint._nextLevelExp * 100)
  if 100 < tonumber(pointPercent) then
    pointPercent = 100
  end
  self._ui.txt_PointPercent:SetText(pointPercent .. "%")
  self._ui.progress_Point:SetProgressRate(guildSkillPoint._currentExp / guildSkillPoint._nextLevelExp * 100)
  self._ui.txt_PointValue:SetText(tostring(guildSkillPoint._remainPoint))
end
function GuildSkillList:reArrangeCellTable()
  for idx = 0, #self._skillPassiveCellContainer do
    self:makeCellLink(self._skillPassiveCellContainer[idx]._skillNo, nil)
  end
end
function GuildSkillList:makeCellLink(skillNo, afterCell)
  local linkedCell = {
    _prevLink,
    _afterLink,
    _skillNo
  }
  linkedCell._afterLink = afterCell
  linkedCell._skillNo = skillNo
  local skillSS = getSkillStaticStatus(skillNo, 1)
  local preRequiredSkillKeyList = skillSS:getAllPreRequiredSkillNoList()
  local preRequiredCount = 0
  local preSkillNo
  for _, key in pairs(preRequiredSkillKeyList) do
    preSkillNo = key:getSkillNo()
    if 0 ~= preSkillNo then
      preRequiredCount = preRequiredCount + 1
    end
  end
  if 1 == preRequiredCount then
    self._skillPassiveCellContainer[preSkillNo] = nil
    linkedCell._prevLink = self:makeCellLink(preSkillNo, linkedCell)
    return linkedCell
  else
    if nil == self._skillPassiveTable[skillNo] then
      self._firstSkillTable[self._skillPassiveTableIdx] = linkedCell._skillNo
      self._skillPassiveTableIdx = self._skillPassiveTableIdx + 1
    end
    self._skillPassiveTable[skillNo] = linkedCell
    return nil
  end
end
function GuildSkillList:checkLastSkill(skillNo)
  local pointingLink = self._skillPassiveTable[skillNo]
  local pointingNo = skillNo
  while true do
    if pointingLink == nil then
      break
    end
    local nextSkill = pointingLink._afterLink
    if nil == nextSkill then
      pointingNo = pointingLink._skillNo
      break
    end
    local nextSkillNo = nextSkill._skillNo
    local nextSkillLevelInfo = getSkillLevelInfo(nextSkillNo)
    if false == nextSkillLevelInfo._usable then
      pointingNo = pointingLink._skillNo
      break
    end
    pointingLink = nextSkill
  end
  return pointingLink, pointingNo
end
function GuildSkillList:makeSlotData(skillSlot, skillNo, isActiveSkill, pointingLink)
  local skillTypeSS = getSkillTypeStaticStatus(skillNo)
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  local skillSS = getSkillStaticStatus(skillNo, 1)
  if nil == skillLevelInfo then
    return
  end
  local pointStr = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDSKILL_NEEDSP")
  local currentName = skillTypeSS:getName()
  skillSlot.name:SetText(currentName)
  skillSlot.icon:ChangeTextureInfoNameAsync("icon/" .. skillTypeSS:getIconPath())
  skillSlot.icon:SetIgnore(true)
  skillSlot.effect:setLineCountByLimitAutoWrap(2)
  skillSlot.effect:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  skillSlot.effect:SetText(skillSS:getDescription())
  if true == skillSlot.effect:IsAutoWrapText() then
    skillSlot.effect:SetSpanSize(skillSlot.effect:GetSpanSize().x, GuildSkillList._skillEffectOriginSpan + 5)
  else
    skillSlot.effect:SetSpanSize(skillSlot.effect:GetSpanSize().x, GuildSkillList._skillEffectOriginSpan)
  end
  skillSlot.icon:SetMonoTone(false)
  skillSlot.button:addInputEvent("Mouse_LUp", "InputMLUp_GuildSkillList_LearnSkill(" .. skillNo .. ")")
  if nil ~= pointingLink then
    local nextLink = pointingLink._afterLink
    if nil == nextLink then
      if nil == pointingLink._prevLink and false == skillLevelInfo._usable then
        skillSlot.icon:SetMonoTone(true)
        skillSlot.needPoint:SetText(pointStr .. " : " .. tostring(skillSS:get()._needSkillPointForLearning))
      end
      if true == skillLevelInfo._usable then
        skillSlot.needPoint:SetText("Mastered")
      end
    elseif nil == pointingLink._prevLink then
      if false == skillLevelInfo._usable then
        skillSlot.icon:SetMonoTone(true)
        skillSlot.needPoint:SetText(pointStr .. " : " .. tostring(skillSS:get()._needSkillPointForLearning))
      else
        nextSkillSS = getSkillStaticStatus(nextLink._skillNo, 1)
        skillSlot.needPoint:SetText(pointStr .. " : " .. tostring(nextSkillSS:get()._needSkillPointForLearning))
        skillSlot.button:addInputEvent("Mouse_LUp", "InputMLUp_GuildSkillList_LearnSkill(" .. nextLink._skillNo .. ")")
      end
    else
      nextSkillSS = getSkillStaticStatus(nextLink._skillNo, 1)
      skillSlot.needPoint:SetText(pointStr .. " : " .. tostring(nextSkillSS:get()._needSkillPointForLearning))
      skillSlot.button:addInputEvent("Mouse_LUp", "InputMLUp_GuildSkillList_LearnSkill(" .. nextLink._skillNo .. ")")
    end
  elseif false == skillLevelInfo._usable then
    skillSlot.icon:SetMonoTone(true)
    skillSlot.needPoint:SetText(pointStr .. " : " .. tostring(skillSS:get()._needSkillPointForLearning))
  else
    skillSlot.icon:SetMonoTone(false)
    skillSlot.needPoint:SetShow(false)
  end
  skillSlot.button:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_GuildSkillInfo_Open(" .. skillNo .. ")")
  if true == isActiveSkill then
    skillSlot.button:registerPadEvent(__eConsoleUIPadEvent_Up_X, "InputMRUp_GuildSkillList_ActiveSkill(" .. skillNo .. ")")
    skillSlot.button:addInputEvent("Mouse_On", "InputMO_GuildSkillList_SetGuide( true )")
  else
    skillSlot.button:addInputEvent("Mouse_On", "InputMO_GuildSkillList_SetGuide( false )")
  end
  skillSlot.button:SetShow(true)
end
function PaGlobalFunc_GuildSkillList_Open()
  local self = GuildSkillList
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildSkillList")
    return
  end
  self:open()
end
function PaGlobalFunc_GuildSkillList_Init()
  local self = GuildSkillList
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildSkillList")
    return
  end
  self._parentBg = UI.getChildControl(_parent, "Static_GuildSkillBg")
  self._parentBg:SetShow(false)
  self._parentBg:MoveChilds(self._parentBg:GetID(), _panel)
  UI.deletePanel(_panel:GetID())
  self:init()
end
function PaGlobalFunc_GuildSkill_UpdateData()
  local self = GuildSkillList
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildSkillList")
    return
  end
  self:updateData()
end
function InputMO_GuildSkillList_SetGuide(isActive)
  Ycontrol = PaGlobalFunc_GuildMain_GetKeyGuide(2)
  Xcontrol = PaGlobalFunc_GuildMain_GetKeyGuide(3)
  Ycontrol:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PEARLSHOP_DETAILINFOVIEW"))
  Xcontrol:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ANSWERSKILL_MESSAGEBOX_TITLE"))
  Ycontrol:SetShow(true)
  Xcontrol:SetShow(isActive)
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  if true ~= isGuildMaster then
    Xcontrol:SetShow(false)
  end
  PaGlobalFunc_GuildMain_updateKeyGuide()
end
function PaGlobalFunc_GuildSkill_CreateControl(content, key)
  local self = GuildSkillList
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildSkillList")
    return
  end
  local skillIdx = Int64toInt32(key)
  local txt_Passive = UI.getChildControl(content, "StaticText_PassiveTitle")
  local btn_Left = UI.getChildControl(content, "Button_PassiveSkill_LeftTemplate")
  local btn_Right = UI.getChildControl(content, "Button_PassiveSkill_RightTemplate")
  local txt_Active = UI.getChildControl(content, "StaticText_ActiveTitle")
  local btn_Active = UI.getChildControl(content, "Button_ActiveSkill_Template")
  txt_Passive:SetShow(false)
  btn_Left:SetShow(false)
  btn_Right:SetShow(false)
  txt_Active:SetShow(false)
  btn_Active:SetShow(false)
  local pointStr = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDSKILL_NEEDSP")
  if skillIdx == 0 then
    txt_Passive:SetShow(true)
  elseif skillIdx > 0 and skillIdx < self._keyIdentifier then
    local leftSkill = self._firstSkillTable[skillIdx - 2]
    local skillNo = leftSkill
    local pointingLink, skillNo = self:checkLastSkill(skillNo)
    self._skillSlot[skillNo] = {}
    self._skillSlot[skillNo].button = btn_Left
    self._skillSlot[skillNo].name = UI.getChildControl(btn_Left, "StaticText_Name")
    self._skillSlot[skillNo].icon = UI.getChildControl(btn_Left, "Static_Icon")
    self._skillSlot[skillNo].effect = UI.getChildControl(btn_Left, "StaticText_Effect")
    self._skillSlot[skillNo].needPoint = UI.getChildControl(btn_Left, "StaticText_NeedPoint")
    self._skillSlot[skillNo].idx = skillIdx
    self:makeSlotData(self._skillSlot[skillNo], skillNo, false, pointingLink)
    local rightSkill = self._firstSkillTable[skillIdx - 1]
    local skillNo = rightSkill
    local pointingLink, skillNo = self:checkLastSkill(skillNo)
    self._skillSlot[skillNo] = {}
    self._skillSlot[skillNo].button = btn_Right
    self._skillSlot[skillNo].name = UI.getChildControl(btn_Right, "StaticText_Name")
    self._skillSlot[skillNo].icon = UI.getChildControl(btn_Right, "Static_Icon")
    self._skillSlot[skillNo].effect = UI.getChildControl(btn_Right, "StaticText_Effect")
    self._skillSlot[skillNo].needPoint = UI.getChildControl(btn_Right, "StaticText_NeedPoint")
    self._skillSlot[skillNo].idx = skillIdx
    self:makeSlotData(self._skillSlot[skillNo], skillNo, false, pointingLink)
  elseif skillIdx == self._keyIdentifier then
    txt_Active:SetShow(true)
  elseif skillIdx > self._keyIdentifier then
    local activeSkill = self._skillActiveCellTable[skillIdx - 1 - self._keyIdentifier]
    local skillNo = activeSkill._skillNo
    self._skillSlot[skillNo] = {}
    self._skillSlot[skillNo].button = btn_Active
    self._skillSlot[skillNo].name = UI.getChildControl(btn_Active, "StaticText_Name")
    self._skillSlot[skillNo].icon = UI.getChildControl(btn_Active, "Static_Icon")
    self._skillSlot[skillNo].effect = UI.getChildControl(btn_Active, "StaticText_Effect")
    self._skillSlot[skillNo].needPoint = UI.getChildControl(btn_Active, "StaticText_NeedPoint")
    self._skillSlot[skillNo].idx = skillIdx
    self:makeSlotData(self._skillSlot[skillNo], skillNo, true, nil)
  end
end
function InputMLUp_GuildSkillList_LearnSkill(skillNo)
  local self = GuildSkillList
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildSkillList")
    return
  end
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  if false == isGuildMaster then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_ONLYMASTERCANLEARNSKILL"))
    return
  end
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    _PA_ASSERT(false, "\234\184\184\235\147\156 \236\160\149\235\179\180\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : InputMLUp_GuildSkillList_LearnSkill")
    return
  end
  local accumulateTax_s32 = Int64toInt32(myGuildInfo:getAccumulateTax())
  local accumulateCost_s32 = Int64toInt32(myGuildInfo:getAccumulateGuildHouseCost())
  if accumulateTax_s32 > 0 or accumulateCost_s32 > 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_TAXFIRST"))
    return
  end
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  if nil == skillLevelInfo then
    return
  end
  if false == skillLevelInfo._learnable then
    local skillSS = getSkillStaticStatus(skillNo, 1)
    if nil == skillSS then
      return
    end
    local skillTypeSS = getSkillTypeStaticStatus(skillNo)
    if 0 < getLearnedSkillLevel(skillTypeSS) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILL_CANNOTLEARNNOMORE"))
      return
    end
    local requiredList = skillSS:getAllPreRequiredSkillNoList()
    if #requiredList > 0 then
      local skillNameStr = ""
      for _, key in pairs(requiredList) do
        local requiredSkillNo = key:getSkillNo()
        local requiredSkillTypeSS = getSkillTypeStaticStatus(requiredSkillNo)
        if nil ~= requiredSkillTypeSS and nil ~= requiredSkillTypeSS:getName() then
          local level = getLearnedSkillLevel(requiredSkillTypeSS)
          if 0 == level then
            if "" == skillNameStr then
              skillNameStr = requiredSkillTypeSS:getName()
            else
              skillNameStr = skillNameStr .. ", " .. requiredSkillTypeSS:getName()
            end
          end
        end
      end
      if "" == skillNameStr then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "LUA_SKILL_SKILLPOINTLESS"))
        return
      end
      allClearMessageData()
      local messageData = {
        content = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_BLOCKED_NOTICE") .. [[


]] .. skillNameStr,
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageData)
      return
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "LUA_QUESTWIDGET_NEXTQUEST_NOTYET_BLACKSPIRIT"))
      return
    end
  end
  local function doLearnGuildSkill()
    local self = GuildSkillList
    local isSuccess = ToClient_RequestLearnGuildSkill(skillNo)
    audioPostEvent_SystemUi(0, 0)
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    if true == isSuccess then
      self:initData()
    end
    return
  end
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_SKILLSTUDY")
  local messageBoxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = doLearnGuildSkill,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData, "middle")
end
function InputMRUp_GuildSkillList_ActiveSkill(skillNo)
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  if true ~= isGuildMaster then
    return
  end
  ToClient_RequestUseGuildSkill(skillNo)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_GuildSkillList_Init")
