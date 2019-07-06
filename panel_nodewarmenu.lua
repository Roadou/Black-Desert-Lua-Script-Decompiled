local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
Panel_NodeWarMenu:SetShow(false)
Panel_NodeWarMenu:RegisterShowEventFunc(true, "Panel_NodeWarMenu_ShowAni()")
Panel_NodeWarMenu:RegisterShowEventFunc(false, "Panel_NodeWarMenu_HideAni()")
function Panel_NodeWarMenu_ShowAni()
  Panel_NodeWarMenu:SetAlpha(0)
  UIAni.fadeInSCR_Down(Panel_NodeWarMenu)
  Panel_NodeWarMenu:SetShow(true)
end
function Panel_NodeWarMenu_HideAni()
  local aniInfo = UIAni.AlphaAnimation(0, Panel_NodeWarMenu, 0, 0.2)
  aniInfo:SetHideAtEnd(true)
end
local nodeWarMenu = {
  _txt_Name = UI.getChildControl(Panel_NodeWarMenu, "StaticText_GuildName"),
  _txt_MasterName = UI.getChildControl(Panel_NodeWarMenu, "StaticText_NodeMasterName"),
  _txt_Period = UI.getChildControl(Panel_NodeWarMenu, "StaticText_Occupation"),
  _stc_GuildMarkBG = UI.getChildControl(Panel_NodeWarMenu, "Static_GuildIcon_BG"),
  _txt_GuildName = UI.getChildControl(Panel_NodeWarMenu, "StaticText_GuildNameValue"),
  _txt_NodeMasterName = UI.getChildControl(Panel_NodeWarMenu, "StaticText_NodeMasterNameValue"),
  _txt_NodeOccupation = UI.getChildControl(Panel_NodeWarMenu, "StaticText_OccupationValue"),
  _txt_GuildMark = UI.getChildControl(Panel_NodeWarMenu, "Static_GuildIcon"),
  _txt_NodeWarBenefitsName = UI.getChildControl(Panel_NodeWarMenu, "StaticText_NodeBenefits"),
  _txt_NodeWarBenefits = UI.getChildControl(Panel_NodeWarMenu, "StaticText_NodeBenefitsValue"),
  _txt_NoOccupation = UI.getChildControl(Panel_NodeWarMenu, "StaticText_NoOccupation"),
  _txt_NodeWarProcessing = UI.getChildControl(Panel_NodeWarMenu, "StaticText_NodeWarProcessing"),
  _btn_GetTax = UI.getChildControl(Panel_NodeWarMenu, "Button_GetTax"),
  _txt_tax = UI.getChildControl(Panel_NodeWarMenu, "StaticText_Tax"),
  _txt_taxValue = UI.getChildControl(Panel_NodeWarMenu, "StaticText_TaxValue"),
  _txt_BottomDesc = UI.getChildControl(Panel_NodeWarMenu, "StaticText_TerrInfo_Help")
}
local gradeString = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_SIEGENODE_LOW_LEVEL"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_SIEGENODE_MIDDLE_LEVEL"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_SIEGENODE_HIGH_LEVEL")
}
function NodeWarMenuInit()
  local self = nodeWarMenu
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  self._txt_BottomDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._txt_BottomDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NODEWARMENU_MAIN_BOTTOMDESC"))
  Panel_NodeWarMenu:SetPosX(scrX / 2 - Panel_NodeWarMenu:GetSizeX() / 2)
  Panel_NodeWarMenu:SetPosY(scrY / 2 - Panel_NodeWarMenu:GetSizeY() / 2 - 30)
  Panel_NodeWarMenu:ComputePos()
end
function NodeWarMenuUpdate()
  local self = nodeWarMenu
  local minorSiegeWrapper = ToClient_GetCurrentMinorSiegeWrapper()
  if nil == minorSiegeWrapper then
    return
  end
  if false == minorSiegeWrapper:doOccupantExist() then
    self._txt_NoOccupation:SetShow(true)
    self._txt_Name:SetShow(false)
    self._txt_MasterName:SetShow(false)
    self._txt_Period:SetShow(false)
    self._stc_GuildMarkBG:SetShow(false)
    self._txt_GuildName:SetShow(false)
    self._txt_NodeMasterName:SetShow(false)
    self._txt_NodeOccupation:SetShow(false)
    self._txt_GuildMark:SetShow(false)
    self._txt_NodeWarBenefits:SetText("\236\151\134\236\157\140")
  end
  local regionInfo = ToClient_GetCurrentMinorSiegeRegion()
  local regionKey = regionInfo._regionKey
  local regionWrapper = getRegionInfoWrapper(regionKey:get())
  local isSiegeChannel = ToClient_doMinorSiegeInTerritory(regionWrapper:getTerritoryKeyRaw())
  local nodeGuildName = minorSiegeWrapper:getGuildName()
  local nodeGuildMasterName = minorSiegeWrapper:getGuildMasterName()
  local paDate = minorSiegeWrapper:getOccupyingDate()
  local isLord = minorSiegeWrapper:isLord()
  local nodeTax_s64 = minorSiegeWrapper:getTaxRemainedAmountForFortress()
  local dropType = regionInfo:getDropGroupRerollCountOfSieger()
  local nodeTaxType = regionInfo:getVillageTaxLevel()
  local year = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(paDate:GetYear()))
  local month = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(paDate:GetMonth()))
  local day = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(paDate:GetDay()))
  local hour = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(paDate:GetHour()))
  if true == minorSiegeWrapper:isSiegeBeing() then
    self._txt_NodeWarProcessing:SetShow(true)
    self._txt_Name:SetShow(false)
    self._txt_MasterName:SetShow(false)
    self._txt_Period:SetShow(false)
    self._stc_GuildMarkBG:SetShow(false)
    self._txt_GuildName:SetShow(false)
    self._txt_NodeMasterName:SetShow(false)
    self._txt_NodeOccupation:SetShow(false)
    self._txt_GuildMark:SetShow(false)
    self._txt_taxValue:SetShow(false)
    local nodeTaxLevel = 0
    if true == _ContentsGroup_SeigeSeason5 then
      nodeTaxLevel = nodeTaxType + 1
    else
      nodeTaxLevel = nodeTaxType
    end
    if 0 == dropType and nodeTaxLevel >= 1 then
      dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxLevel)
    elseif dropType >= 1 and 0 == nodeTaxType then
      dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType + 1)
    elseif dropType >= 1 and nodeTaxType >= 1 then
      dropTypeValue = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH_NPC", "nodeTaxType", tostring(nodeTaxLevel), "dropType", tostring(dropType + 1))
    else
      dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT")
    end
    if 1 == nodeTaxLevel and true == _ContentsGroup_SeigeSeason5 then
      local grade = regionWrapper:getSiegeOptionTypeByRegion()
      dropTypeValue = dropTypeValue .. " " .. gradeString[grade]
    end
    self._btn_GetTax:SetShow(false)
    self._txt_NodeWarBenefits:SetShow(true)
    self._txt_NodeWarBenefits:SetText(dropTypeValue)
  else
    self._txt_NodeWarProcessing:SetShow(false)
    local isSet = setGuildTextureByGuildNo(minorSiegeWrapper:getGuildNo(), self._txt_GuildMark)
    if not isSet then
      self._txt_GuildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(self._txt_GuildMark, 183, 1, 188, 6)
      self._txt_GuildMark:getBaseTexture():setUV(x1, y1, x2, y2)
      self._txt_GuildMark:setRenderTexture(self._txt_GuildMark:getBaseTexture())
    end
    local nodeTaxLevel = 0
    if true == _ContentsGroup_SeigeSeason5 then
      nodeTaxLevel = nodeTaxType + 1
    else
      nodeTaxLevel = nodeTaxType
    end
    if 0 == dropType and nodeTaxLevel >= 1 then
      dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxLevel)
    elseif dropType >= 1 and 0 == nodeTaxType then
      dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType + 1)
    elseif dropType >= 1 and nodeTaxType >= 1 then
      dropTypeValue = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH_NPC", "nodeTaxType", tostring(nodeTaxLevel), "dropType", tostring(dropType + 1))
    else
      dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT")
    end
    if 1 == nodeTaxLevel and true == _ContentsGroup_SeigeSeason5 then
      local grade = regionWrapper:getSiegeOptionTypeByRegion()
      dropTypeValue = dropTypeValue .. " " .. gradeString[grade]
    end
    if nodeTaxType >= 1 and isLord and isSiegeChannel then
      if toInt64(0, 0) == nodeTax_s64 then
        self._btn_GetTax:SetShow(false)
      else
        self._btn_GetTax:SetShow(false)
      end
      self._txt_tax:SetShow(true)
      self._txt_taxValue:SetShow(true)
      self._txt_taxValue:SetText(makeDotMoney(nodeTax_s64))
    else
      self._txt_tax:SetShow(false)
      self._btn_GetTax:SetShow(false)
      self._txt_taxValue:SetShow(false)
    end
    self._txt_GuildName:SetText(nodeGuildName)
    self._txt_NodeMasterName:SetText(nodeGuildMasterName)
    self._txt_NodeOccupation:SetText(year .. " " .. month .. " " .. day .. " " .. hour)
    self._txt_NodeWarBenefits:SetText(dropTypeValue)
  end
end
function FGlobal_NodeWarMenuOpen()
  local minorSiegeWrapper = ToClient_GetCurrentMinorSiegeWrapper()
  if nil == minorSiegeWrapper then
    return
  end
  local isLord = minorSiegeWrapper:isLord()
  local regionInfo = ToClient_GetCurrentMinorSiegeRegion()
  local regionKey = regionInfo._regionKey
  local regionWrapper = getRegionInfoWrapper(regionKey:get())
  local minorSiegeWrapper = regionWrapper:getMinorSiegeWrapper()
  local isSiegeChannel = ToClient_doMinorSiegeInTerritory(regionWrapper:getTerritoryKeyRaw())
  if isLord and isSiegeChannel then
    minorSiegeWrapper:updateTaxAmount(true)
  else
    NodeWarMenuUpdate()
  end
  Panel_NodeWarMenu:SetShow(true, true)
end
function FGlobal_NodeWarMenuClose()
  Panel_NodeWarMenu:SetShow(false, false)
end
function NodeWarMenuOnScreenReSize()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_NodeWarMenu:SetPosX(scrX / 2 - Panel_NodeWarMenu:GetSizeX() / 2)
  Panel_NodeWarMenu:SetPosY(scrY / 2 - Panel_NodeWarMenu:GetSizeY() / 2 - 30)
  Panel_NodeWarMenu:ComputePos()
end
function NodeWarMenu_Withdraw_Money()
  local regionInfo = ToClient_GetCurrentMinorSiegeRegion()
  if nil == regionInfo then
    return
  end
  local minorSiegeWrapper = ToClient_GetCurrentMinorSiegeWrapper()
  if nil == minorSiegeWrapper then
    return
  end
  local doOccupantExist = minorSiegeWrapper:doOccupantExist()
  if not doOccupantExist then
    return
  end
  local isLord = minorSiegeWrapper:isLord()
  if not isLord then
    return
  end
  local taxRemainedAmountForFortress = minorSiegeWrapper:getTaxRemainedAmountForFortress()
  Panel_NumberPad_Show(true, taxRemainedAmountForFortress, 0, NodeWarMenu_Withdraw_Money_Message)
end
local withdrawMoney = 0
function NodeWarMenu_Withdraw_Money_Message(inputNumber, param)
  withdrawMoney = inputNumber
  local messageBoxMemo = makeDotMoney(withdrawMoney) .. PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_WITHDRAW_CONTENT_NODEWAR")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_WITHDRAW_TITLE"),
    content = messageBoxMemo,
    functionYes = NodeWarMenu_Withdraw_Money_Confirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function NodeWarMenu_Withdraw_Money_Confirm()
  local regionInfo = ToClient_GetCurrentMinorSiegeRegion()
  if nil == regionInfo then
    return
  end
  local minorSiegeWrapper = ToClient_GetCurrentMinorSiegeWrapper()
  if nil == minorSiegeWrapper then
    return
  end
  if 0 == inputNumber then
    return
  end
  minorSiegeWrapper:moveTownTaxToWarehouse(withdrawMoney, true)
end
function Panel_NodeWarMenu:PanelResize_ByFontSize()
  local self = nodeWarMenu
  self._txt_GuildName:SetPosX(self._txt_Name:GetTextSizeX() + self._txt_Name:GetPosX() + 10)
  self._txt_NodeMasterName:SetPosX(self._txt_MasterName:GetTextSizeX() + self._txt_MasterName:GetPosX() + 10)
  self._txt_NodeOccupation:SetPosX(self._txt_Period:GetTextSizeX() + self._txt_Period:GetPosX() + 10)
  self._txt_NodeWarBenefits:SetPosX(self._txt_NodeWarBenefitsName:GetTextSizeX() + self._txt_NodeWarBenefitsName:GetPosX() + 10)
end
function NodeWarMenu_registEventHandler()
  nodeWarMenu._btn_GetTax:addInputEvent("Mouse_LUp", "NodeWarMenu_Withdraw_Money()")
end
function NodeWarMenu_registMessageHandler()
  registerEvent("EventLordMenuPayInfoUpdate", "NodeWarMenuUpdate()")
  registerEvent("onScreenResize", "NodeWarMenuOnScreenReSize()")
end
NodeWarMenuInit()
Panel_NodeWarMenu:PanelResize_ByFontSize()
NodeWarMenu_registEventHandler()
NodeWarMenu_registMessageHandler()
