local expeditionCharacterSelectInfo = {
  _ui = {
    _button_close = UI.getChildControl(Panel_Subjugation_SelectCharacter, "Button_Win_Close"),
    _button_select = UI.getChildControl(Panel_Subjugation_SelectCharacter, "Button_Select"),
    _mainBG = UI.getChildControl(Panel_Subjugation_SelectCharacter, "Static_CharacterSelectBG"),
    _scroll = nil,
    _scrollCtrlBtn = nil
  },
  _config = {
    _maxCharacterCount = 0,
    _scrollSizeY = 450,
    _maxImageY = 0,
    _maxStartIndex = 0,
    _maxSlotRow = 3,
    _maxSlotCol = 3
  },
  _startIndex = 0,
  _charListSlot = Array.new(),
  _selectIndex = nil,
  _selectCharacterIndex = nil
}
function expeditionCharacterSelectInfo:initialize()
  _PA_LOG("\235\176\149\234\183\156\235\130\152_\237\134\160\235\178\140", "\236\186\144\235\166\173\237\132\176 \236\132\160\237\131\157 \235\161\156\235\147\156 \236\153\132\235\163\140!!")
  ToClient_loadMyCharacterInfo()
  self:createControl()
  Panel_Subjugation_SelectCharacter:SetShow(false)
end
function expeditionCharacterSelectInfo:createControl()
  local baseBorder = UI.getChildControl(self._ui._mainBG, "Static_CharacterImageBorder")
  local charList = ToClient_getMyCharacterInfo()
  self._config._maxCharacterCount = #charList + 1
  local maxStartIndex = self._config._maxCharacterCount - self._config._maxSlotRow * self._config._maxSlotCol + 1
  self._config._maxStartIndex = maxStartIndex
  if maxStartIndex % self._config._maxSlotRow > 0 then
    self._config._maxStartIndex = maxStartIndex - maxStartIndex % self._config._maxSlotCol + self._config._maxSlotRow
  end
  for ii = 0, self._config._maxCharacterCount - 1 do
    local slot = {
      _parent = nil,
      _image = nil,
      _topText = nil,
      _bottomText = nil
    }
    local cloneBG = UI.cloneControl(baseBorder, self._ui._mainBG, "CharacterBG_" .. ii)
    cloneBG:SetPosX(ii % self._config._maxSlotRow * 108 + 13)
    cloneBG:SetPosY(math.floor(ii / self._config._maxSlotCol) * 137 + 40)
    slot._parent = cloneBG
    local image = UI.getChildControl(cloneBG, "Static_Image")
    image:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionCharacterSelectInfo_Click(" .. ii .. ")")
    image:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_ExpeditionCharacterSelectInfo_ScrollUpdate(true)")
    image:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_ExpeditionCharacterSelectInfo_ScrollUpdate(false)")
    slot._image = image
    local bottomText = UI.getChildControl(cloneBG, "StaticText_BottomText")
    bottomText:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    slot._bottomText = bottomText
    local topText = UI.getChildControl(cloneBG, "StaticText_TopText")
    topText:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    slot._topText = topText
    self._charListSlot[ii] = slot
  end
  self._ui._button_close:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionCharacterSelectInfo_Close()")
  self._ui._button_select:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionCharacterSelectInfo_Select()")
  deleteControl(baseBorder)
  baseBorder = nil
  self._ui._scroll = UI.getChildControl(self._ui._mainBG, "VerticalScroll")
  self._ui._scrollCtrlBtn = UI.getChildControl(self._ui._scroll, "VerticalScroll_CtrlButton")
  self._ui._scrollCtrlBtn:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_ExpeditionCharacterSelectInfo_ScrollUpdate(true)")
  self._ui._scrollCtrlBtn:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_ExpeditionCharacterSelectInfo_ScrollUpdate(false)")
  self._ui._scrollCtrlBtn:addInputEvent("Mouse_LPress", "PaGlobalFunc_ExpeditionCharacterSelectInfo_ScrollUpdate_ByLPress()")
  self._ui._mainBG:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_ExpeditionCharacterSelectInfo_ScrollUpdate(true)")
  self._ui._mainBG:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_ExpeditionCharacterSelectInfo_ScrollUpdate(false)")
end
function expeditionCharacterSelectInfo:loadImage()
  self._config._maxImageY = 0
  local charList = ToClient_getMyCharacterInfo()
  for ii = 0, self._config._maxCharacterCount - 1 do
    local slot = self._charListSlot[ii]
    if ii + self._startIndex <= #charList then
      local myCharData = charList[ii + self._startIndex]
      local charType = myCharData:getClassType()
      local charName = myCharData:getCharacterName()
      local textureName = myCharData:getFaceTexture()
      local isCaptureExist = slot._image:ChangeTextureInfoNameNotDDS(textureName, charType, PaGlobal_getIsExitPhoto())
      if isCaptureExist == true then
        slot._image:getBaseTexture():setUV(0, 0, 1, 1)
      else
        _PA_LOG("\235\176\149\234\183\156\235\130\152_\237\134\160\235\178\140", "loadImage \234\176\128 \236\151\134\236\150\180!!!" .. ii)
      end
      slot._image:setRenderTexture(slot._image:getBaseTexture())
      slot._bottomText:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_EXPEDITION_LEVEL_CHARACTERNAME", "level", tostring(myCharData._level), "name", tostring(charName)))
      slot._topText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXPEDITION_COMBATPOINT", "value", tostring(math.floor(myCharData._totalStatValue))))
      slot._parent:SetShow(true)
      self._config._maxImageY = slot._parent:GetPosY() + slot._parent:GetSizeY()
      if self._config._scrollSizeY < self._config._maxImageY then
        slot._parent:SetShow(false)
      end
    else
      slot._parent:SetShow(false)
    end
  end
end
function expeditionCharacterSelectInfo:open()
  if nil ~= Panel_ArmyUnitSetting and Panel_ArmyUnitSetting:GetShow() then
    Panel_Subjugation_SelectCharacter:SetPosX(Panel_ArmyUnitSetting:GetPosX() + Panel_ArmyUnitSetting:GetSizeX() * 0.5 - Panel_Subjugation_SelectCharacter:GetSizeX() * 0.5)
    Panel_Subjugation_SelectCharacter:SetPosY(Panel_ArmyUnitSetting:GetPosY() + Panel_ArmyUnitSetting:GetSizeY() * 0.5 - Panel_Subjugation_SelectCharacter:GetSizeY() * 0.5)
  end
  Panel_Subjugation_SelectCharacter:SetShow(true)
  self._startIndex = 0
  self:loadImage()
  local contentSize = math.max(self._config._scrollSizeY, self._config._maxImageY)
  self._ui._scroll:SetShow(contentSize > self._config._scrollSizeY)
  self._ui._scroll:SetInterval(contentSize / 100)
  self._ui._scroll:GetControlButton():SetSize(self._ui._scroll:GetControlButton():GetSizeX(), math.min(self._config._scrollSizeY, self._config._scrollSizeY / contentSize * 450))
  self._ui._scroll:SetControlTop()
end
function expeditionCharacterSelectInfo:close()
  self._selectIndex = nil
  Panel_Subjugation_SelectCharacter:SetShow(false)
end
function PaGlobalFunc_ExpeditionCharacterSelectInfo_Open(index)
  local self = expeditionCharacterSelectInfo
  self._selectCharacterIndex = nil
  self:open()
  self._selectIndex = index
  for ii = 0, self._config._maxCharacterCount - 1 do
    self._charListSlot[ii]._topText:SetFontColor(Defines.Color.C_FFC4BEBE)
    self._charListSlot[ii]._bottomText:SetFontColor(Defines.Color.C_FFC4BEBE)
  end
end
function PaGlobalFunc_ExpeditionCharacterSelectInfo_Close()
  local self = expeditionCharacterSelectInfo
  self:close()
end
function PaGlobalFunc_ExpeditionCharacterSelectInfo_Select()
  if false == Panel_Subjugation_SelectCharacter:IsShow() then
    return
  end
  local self = expeditionCharacterSelectInfo
  if nil == self._selectCharacterIndex then
    return
  end
  local charList = ToClient_getMyCharacterInfo()
  _PA_LOG("\235\176\149\234\183\156\235\130\152_\237\134\160\235\178\140", "\236\186\144\235\166\173\237\132\176 \236\132\160\237\131\157" .. tostring(self._selectIndex) .. "/" .. tostring(charList) .. "/" .. tostring(charList[self._selectCharacterIndex]._characterNo))
  PaGlobalFunc_ExpeditionSettingInfo_SelectCharacterSet(self._selectIndex, charList[self._selectCharacterIndex]._characterNo)
  self:close()
end
function PaGlobalFunc_ExpeditionCharacterSelectInfo_Click(index)
  local self = expeditionCharacterSelectInfo
  for ii = 0, self._config._maxCharacterCount - 1 do
    self._charListSlot[ii]._topText:SetFontColor(Defines.Color.C_FFC4BEBE)
    self._charListSlot[ii]._bottomText:SetFontColor(Defines.Color.C_FFC4BEBE)
  end
  self._selectCharacterIndex = index + self._startIndex
  self._charListSlot[index]._topText:SetFontColor(Defines.Color.C_FFFFEEA0)
  self._charListSlot[index]._bottomText:SetFontColor(Defines.Color.C_FFFFEEA0)
end
function PaGlobalFunc_ExpeditionCharacterSelectInfo_ScrollUpdate(isUp)
  local self = expeditionCharacterSelectInfo
  if true == isUp then
    self._startIndex = self._startIndex - self._config._maxSlotRow
  else
    self._startIndex = self._startIndex + self._config._maxSlotRow
  end
  if self._startIndex < 0 then
    self._startIndex = 0
  elseif self._config._maxStartIndex < self._startIndex then
    self._startIndex = self._config._maxStartIndex
  end
  self:loadImage()
  self._ui._scroll:SetControlPos(self._startIndex / self._config._maxStartIndex)
  for ii = 0, self._config._maxCharacterCount - 1 do
    self._charListSlot[ii]._topText:SetFontColor(Defines.Color.C_FFC4BEBE)
    self._charListSlot[ii]._bottomText:SetFontColor(Defines.Color.C_FFC4BEBE)
  end
  if nil == self._selectCharacterIndex then
    return
  end
  local index = self._selectCharacterIndex - self._startIndex
  if index >= 0 and index < self._config._maxCharacterCount then
    self._charListSlot[index]._topText:SetFontColor(Defines.Color.C_FFFFEEA0)
    self._charListSlot[index]._bottomText:SetFontColor(Defines.Color.C_FFFFEEA0)
  end
end
function PaGlobalFunc_ExpeditionCharacterSelectInfo_ScrollUpdate_ByLPress()
  local self = expeditionCharacterSelectInfo
  local ratioValue = self._ui._scroll:GetControlPos()
  self._startIndex = math.floor(self._config._maxStartIndex / self._config._maxSlotRow * ratioValue)
  self._startIndex = self._startIndex * self._config._maxSlotRow
  self:loadImage()
end
function FromClient_ExpeditionCharacterSelectInfo_Initialize()
  local self = expeditionCharacterSelectInfo
  self:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_ExpeditionCharacterSelectInfo_Initialize")
