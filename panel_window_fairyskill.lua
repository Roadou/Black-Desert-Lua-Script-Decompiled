local fairySkill = {
  _ui = {
    _button_Win_Close = UI.getChildControl(Panel_Window_FaIryTierUpgrade, "Button_Win_Close"),
    _static_MainBG = UI.getChildControl(Panel_Window_FaIryTierUpgrade, "Static_MainBG"),
    _button_Close = UI.getChildControl(Panel_Window_FaIryTierUpgrade, "Button_Close"),
    stc_skillIcons = {}
  },
  exceptGroupkey = {}
}
function fairySkill:initialize()
  self:close()
  self:setPosition()
  self:initControl()
end
function fairySkill:initControl()
  self._ui._list2_SkillList = UI.getChildControl(self._ui._static_MainBG, "List2_SkillList")
  self._ui._list2_SkillList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_fairySkill_ListCreate")
  self._ui._list2_SkillList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._button_Win_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_fairySkill_Close()")
  self._ui._button_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_fairySkill_Close()")
end
function fairySkill:setPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_Window_FaIryTierUpgrade:GetSizeX()
  local panelSizeY = Panel_Window_FaIryTierUpgrade:GetSizeY()
  Panel_Window_FaIryTierUpgrade:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Panel_Window_FaIryTierUpgrade:SetPosY(scrSizeY / 2 - panelSizeY / 2)
end
function PaGlobalFunc_fairySkill_Open()
  fairySkill:open()
end
function fairySkill:open()
  if false == Panel_Window_FaIryTierUpgrade:GetShow() then
    if Panel_Window_FairyUpgrade:GetShow() then
      PaGlobal_FairyUpgrade_Close()
    end
    PaGlobal_FairyChoice:Close()
    Panel_Window_FaIryTierUpgrade:SetShow(true)
    self:update(true)
  else
    Panel_Window_FaIryTierUpgrade:SetShow(false)
  end
end
function PaGlobalFunc_fairySkill_Close()
  fairySkill:close()
end
function fairySkill:close()
  Panel_Window_FaIryTierUpgrade:SetShow(false)
end
function PaGlobalFunc_fairySkill_GetShow()
  return fairySkill:getShow()
end
function fairySkill:getShow()
  return Panel_Window_FaIryTierUpgrade:GetShow()
end
function fairySkill:update(isScroll)
  local unSealCount = ToClient_getFairyUnsealedList()
  local isUnseal = false
  if unSealCount > 0 then
    isUnseal = true
  end
  if true == isUnseal then
    pcFairyData = ToClient_getFairyUnsealedDataByIndex(0)
  else
    pcFairyData = ToClient_getFairySealedDataByIndex(0)
  end
  self.exceptGroupkey = {}
  local LearnableSkillList = {}
  local LearnableSkillSortList = {}
  local skillCount = PaGloblFunc_FairyInfo_GetFairySkillCount()
  local petStaticStatus = pcFairyData:getPetStaticStatus()
  for ii = 0, skillCount - 1 do
    if true == ToClient_Fairy_GetIsLearnableFairySkillByIndex(petStaticStatus, ii) then
      LearnableSkillList[ii] = true
    end
  end
  for key, value in pairs(LearnableSkillList) do
    if true == pcFairyData:isFairyEquipSkillLearned(key) then
      LearnableSkillList[key] = nil
      local equipGroupkey = ToClient_Fairy_GetGroupKeyByIndex(key)
      if -1 ~= equipGroupkey then
        self.exceptGroupkey[equipGroupkey] = true
      end
    else
      table.insert(LearnableSkillSortList, key)
    end
  end
  local sortFunc = function(a, b)
    return a < b
  end
  table.sort(LearnableSkillSortList, sortFunc)
  local toIndex = 0
  local scrollvalue = 0
  local vscroll = self._ui._list2_SkillList:GetVScroll()
  local hscroll = self._ui._list2_SkillList:GetHScroll()
  if not isScroll then
    toIndex = self._ui._list2_SkillList:getCurrenttoIndex()
    if false == self._ui._list2_SkillList:IsIgnoreVerticalScroll() then
      scrollvalue = vscroll:GetControlPos()
    end
  end
  self._ui.stc_skillIcons = {}
  self._ui._list2_SkillList:getElementManager():clearKey()
  for key, value in pairs(LearnableSkillSortList) do
    local equipGroupkey = ToClient_Fairy_GetGroupKeyByIndex(value)
    if not self.exceptGroupkey[equipGroupkey] then
      self._ui._list2_SkillList:getElementManager():pushKey(value)
    end
  end
  for key, value in pairs(LearnableSkillSortList) do
    local equipGroupkey = ToClient_Fairy_GetGroupKeyByIndex(value)
    if self.exceptGroupkey[equipGroupkey] then
      self._ui._list2_SkillList:getElementManager():pushKey(value)
    end
  end
  if not isScroll then
    self._ui._list2_SkillList:setCurrenttoIndex(toIndex)
    if false == self._ui._list2_SkillList:IsIgnoreVerticalScroll() then
      vscroll:SetControlPos(scrollvalue)
    end
  end
end
function PaGlobalFunc_fairySkill_ListCreate(control, key)
  fairySkill:listCreate(control, key)
end
function fairySkill:listCreate(control, key)
  local _static_SkillIcon1 = UI.getChildControl(control, "Static_SkillIcon1")
  local _staticText_SkillName1 = UI.getChildControl(control, "StaticText_SkillName1")
  local _staticText_SkillDesc1 = UI.getChildControl(control, "StaticText_SkillDesc1")
  local skillkey = tonumber(tostring(key))
  local isExistEqualGroupSkill = false
  local equipGroupkey = ToClient_Fairy_GetGroupKeyByIndex(skillkey)
  if -1 ~= equipGroupkey and self.exceptGroupkey[equipGroupkey] then
    isExistEqualGroupSkill = true
  end
  local skillSSW = ToClient_Fairy_EquipSkillWrraper(skillkey)
  if nil == skillSSW then
    return
  end
  local skillTypeSSW = skillSSW:getSkillTypeStaticStatusWrapper()
  _static_SkillIcon1:ChangeTextureInfoName("Icon/" .. skillTypeSSW:getIconPath())
  _static_SkillIcon1:addInputEvent("Mouse_On", "PaGlobalFunc_fairySkill_ShowTooltip(true, " .. skillkey .. ")")
  _static_SkillIcon1:addInputEvent("Mouse_Out", "PaGlobalFunc_fairySkill_ShowTooltip(false)")
  _staticText_SkillDesc1:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  _staticText_SkillName1:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  _staticText_SkillDesc1:SetText(skillTypeSSW:getDescription())
  _staticText_SkillName1:SetText(skillTypeSSW:getName())
  _static_SkillIcon1:SetMonoTone(isExistEqualGroupSkill)
  self._ui.stc_skillIcons[skillkey] = _static_SkillIcon1
  if true == isExistEqualGroupSkill then
    _staticText_SkillDesc1:SetFontColor(Defines.Color.C_FF525B6D)
    _staticText_SkillName1:SetFontColor(Defines.Color.C_FF525B6D)
  else
    _staticText_SkillDesc1:SetFontColor(Defines.Color.C_FF9397A7)
    _staticText_SkillName1:SetFontColor(Defines.Color.C_FFEDEDEE)
  end
end
function PaGlobalFunc_fairySkill_ShowTooltip(isShow, skillkey)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local skillSSW = ToClient_Fairy_EquipSkillWrraper(skillkey)
  if nil == skillSSW then
    return
  end
  local skillTypeSSW = skillSSW:getSkillTypeStaticStatusWrapper()
  TooltipSimple_Show(fairySkill._ui.stc_skillIcons[skillkey], skillTypeSSW:getName(), skillTypeSSW:getDescription())
end
function PaGlobalFunc_fairySkill_LuaLoadComplete()
  fairySkill:initialize()
end
function PaGlobalFunc_fairySkill_Update()
  if true == fairySkill:getShow() then
    fairySkill:update()
  end
end
function fairySkill:registEventHandler()
  registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_fairySkill_LuaLoadComplete")
  registerEvent("FromClient_Fairy_Update", "PaGlobalFunc_fairySkill_Update")
end
fairySkill:registEventHandler()
