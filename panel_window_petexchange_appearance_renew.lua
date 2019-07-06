Panel_Window_PetExchange_Appearance_Renew:SetShow(false)
local PetExchangeAppearance = {
  _ui = {
    _txt_title = UI.getChildControl(Panel_Window_PetExchange_Appearance_Renew, "StaticText_Title"),
    _stc_centerBG = UI.getChildControl(Panel_Window_PetExchange_Appearance_Renew, "Static_CenterBG"),
    _stc_bottomKeyBG = UI.getChildControl(Panel_Window_PetExchange_Appearance_Renew, "Static_BottomKeyBG"),
    _chk_subPetList = {},
    _stc_subPetIconList = {},
    _txt_subPetTierList = {},
    _txt_subPetNameList = {},
    _txt_subPetLevelList = {}
  },
  _config = {
    _rowCount = 2,
    _columnCount = 3,
    _subPetSlotCount = 0
  },
  _colorTable = {
    [0] = Defines.Color.C_FF686868,
    [1] = Defines.Color.C_FF6F6D10,
    [2] = Defines.Color.C_FF3B6491,
    [3] = Defines.Color.C_FFB68827,
    [4] = Defines.Color.C_FFC95A40
  },
  _subPetTotalCount = 0,
  _subPetIndexList = {},
  _curSubPetRow = 0,
  _showStartRow = 0,
  _curShowStartIndex = 0,
  _keyGuideAlign = {},
  _panel = Panel_Window_PetExchange_Appearance_Renew
}
function PetExchangeAppearance:InitControl()
  self._ui._stc_buttonGroup = UI.getChildControl(self._ui._stc_centerBG, "Static_ButtonGroup")
  self._ui._chk_subPet = UI.getChildControl(self._ui._stc_buttonGroup, "CheckButton_PetAppearanceSlot")
  self._ui._scroll_vertical = UI.getChildControl(self._ui._stc_buttonGroup, "Scroll_VerticalScroll")
  self._ui._btn_confirm = UI.getChildControl(self._ui._stc_bottomKeyBG, "StaticText_Confirm_ConsoleUI")
  self._ui._btn_exit = UI.getChildControl(self._ui._stc_bottomKeyBG, "StaticText_Cancel_ConsoleUI")
  self._keyGuideAlign = {
    self._ui._btn_confirm,
    self._ui._btn_exit
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._stc_bottomKeyBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self:CreateSubPetButton()
end
function PetExchangeAppearance:RegistEventHandler()
  registerEvent("onScreenResize", "PaGlobalFunc_PetExchangeAppearance_OnScreenResize")
end
function PetExchangeAppearance:Initialize()
  self:InitControl()
  self:RegistEventHandler()
  self:onScreenResize()
  self._config._subPetSlotCount = self._config._rowCount * self._config._columnCount
  self._ui._chk_subPet:SetShow(false)
end
function PetExchangeAppearance:onScreenResize()
  self._panel:ComputePos()
end
function PetExchangeAppearance:InitSubPetIndexList(selectIndexTable)
  local subPetWrapper
  self._curSubPetRow = 0
  self._subPetIndexList = {}
  self._subPetTotalCount = 0
  for startIndex = 0, #selectIndexTable do
    subPetWrapper = ToClient_getPetSealedDataByIndex(selectIndexTable[startIndex])
    if 0 ~= startIndex then
      if nil ~= subPetWrapper then
        local petStaticStatus = subPetWrapper:getPetStaticStatus()
        local petRace = petStaticStatus:getPetRace()
        if 99 ~= petRace then
          self._subPetIndexList[self._subPetTotalCount] = selectIndexTable[startIndex]
          self._subPetTotalCount = self._subPetTotalCount + 1
        end
      end
    else
      self._subPetIndexList[startIndex] = selectIndexTable[startIndex]
      self._subPetTotalCount = self._subPetTotalCount + 1
    end
  end
  self._subPetTotalCount = self._subPetTotalCount + 1
  UIScroll.SetButtonSize(self._ui._scroll_vertical, self._config._subPetSlotCount, self._subPetTotalCount)
end
function PetExchangeAppearance:UpdateSubPetButton()
  local subPetWrapper
  local subPetTier = -1
  self._ui._stc_randomIcon:SetShow(false)
  for startIndex = 0, self._config._subPetSlotCount - 1 do
    local showIndex = self._curShowStartIndex + startIndex
    if 0 ~= showIndex and nil ~= self._subPetIndexList[showIndex] then
      subPetWrapper = ToClient_getPetSealedDataByIndex(self._subPetIndexList[showIndex])
      if nil ~= subPetWrapper then
        subPetTier = subPetWrapper:getPetStaticStatus():getPetTier() + 1
        self._ui._stc_subPetIconList[startIndex]:ChangeTextureInfoNameAsync(subPetWrapper:getIconPath())
        self._ui._txt_subPetTierList[startIndex]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETLIST_TIER_SHORT", "tier", subPetTier))
        self._ui._txt_subPetTierList[startIndex]:SetColor(self._colorTable[subPetTier - 1])
        self._ui._txt_subPetNameList[startIndex]:SetText(subPetWrapper:getName())
        self._ui._txt_subPetLevelList[startIndex]:SetText("Lv. " .. tostring(subPetWrapper._level))
        self._ui._stc_subPetIconList[startIndex]:SetShow(true)
        self._ui._txt_subPetLevelList[startIndex]:SetShow(true)
        self._ui._txt_subPetTierList[startIndex]:SetShow(true)
        self._ui._txt_subPetNameList[startIndex]:SetShow(true)
        self._ui._chk_subPetList[startIndex]:SetShow(true)
        self._ui._chk_subPetList[startIndex]:SetCheck(false)
      end
    elseif 0 == showIndex then
      self._ui._stc_subPetIconList[startIndex]:SetShow(false)
      self._ui._txt_subPetLevelList[startIndex]:SetShow(false)
      self._ui._txt_subPetTierList[startIndex]:SetShow(false)
      self._ui._txt_subPetNameList[startIndex]:SetShow(false)
      self._ui._stc_randomIcon:SetShow(true)
      self._ui._chk_subPetList[startIndex]:SetShow(true)
    else
      self._ui._chk_subPetList[startIndex]:SetShow(false)
    end
  end
end
function PetExchangeAppearance:Update()
  self._curShowStartIndex = self._curSubPetRow * self._config._columnCount
  self:UpdateSubPetButton()
end
function PetExchangeAppearance:CreateSubPetButton()
  self._ui._stc_buttonGroup = UI.getChildControl(self._ui._stc_centerBG, "Static_ButtonGroup")
  local index = 0
  local posX = 0
  local posY = 0
  for row = 0, self._config._rowCount - 1 do
    for col = 0, self._config._columnCount - 1 do
      index = row * self._config._columnCount + col
      self._ui._chk_subPetList[index] = UI.cloneControl(self._ui._chk_subPet, self._ui._stc_buttonGroup, "CheckButton_PetAppearanceSlot" .. index)
      self._ui._stc_subPetIconList[index] = UI.getChildControl(self._ui._chk_subPetList[index], "Static_SubPetIcon")
      self._ui._txt_subPetTierList[index] = UI.getChildControl(self._ui._chk_subPetList[index], "StaticText_SubPetTier")
      self._ui._txt_subPetNameList[index] = UI.getChildControl(self._ui._chk_subPetList[index], "StaticText_SubPetName")
      self._ui._txt_subPetLevelList[index] = UI.getChildControl(self._ui._chk_subPetList[index], "StaticText_SubPetLevel")
      posX = self._ui._chk_subPet:GetPosX() + (self._ui._chk_subPet:GetSizeX() + 5) * col
      posY = self._ui._chk_subPet:GetPosY() + (self._ui._chk_subPet:GetSizeY() + 5) * row
      self._ui._chk_subPetList[index]:SetPosX(posX)
      self._ui._chk_subPetList[index]:SetPosY(posY)
      self._ui._chk_subPetList[index]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_PetExchangeAppearance_SubPetButtonAUp(" .. index .. ")")
    end
  end
  self._ui._stc_randomIcon = UI.getChildControl(self._ui._chk_subPetList[0], "StaticText_RandomLook")
  for col = 0, self._config._columnCount - 1 do
    self._ui._chk_subPetList[col]:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_PetExchangeAppearance_SubPetButtonDUp()")
  end
  for col = 0, self._config._columnCount - 1 do
    index = (self._config._rowCount - 1) * self._config._columnCount + col
    self._ui._chk_subPetList[index]:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_PetExchangeAppearance_SubPetButtonDDown()")
  end
end
function PaGlobalFunc_PetExchangeAppearance_SubPetButtonDUp()
  local self = PetExchangeAppearance
  if self._curSubPetRow <= 0 then
    return
  else
    self._curSubPetRow = self._curSubPetRow - 1
  end
  UIScroll.ScrollEvent(self._ui._scroll_vertical, true, self._config._rowCount, self._subPetTotalCount, self._curSubPetRow, self._config._columnCount)
  self:Update()
end
function PaGlobalFunc_PetExchangeAppearance_SubPetButtonDDown()
  local self = PetExchangeAppearance
  local rowCount = math.ceil(self._subPetTotalCount / self._config._columnCount)
  if self._curSubPetRow < rowCount - 2 then
    self._curSubPetRow = self._curSubPetRow + 1
    self:Update()
    ToClient_padSnapIgnoreGroupMove()
  end
  UIScroll.ScrollEvent(self._ui._scroll_vertical, false, self._config._rowCount, self._subPetTotalCount, self._curSubPetRow, self._config._columnCount)
end
function PaGlobalFunc_PetExchangeAppearance_SubPetButtonAUp(index)
  local self = PetExchangeAppearance
  self._panel:SetShow(false)
  local selectIndex = self._curShowStartIndex + index
  PaGlobalFunc_PetExchange_SelectNewAppearance(selectIndex, self._subPetIndexList[selectIndex])
end
function PetExchangeAppearance:Open(selectIndexTable)
  if true == self._panel:GetShow() then
    return
  end
  self._panel:ignorePadSnapMoveToOtherPanel()
  self:InitSubPetIndexList(selectIndexTable)
  self:Update()
  self._panel:SetShow(true)
end
function PetExchangeAppearance:Close()
  self._panel:SetShow(false)
end
function PaGlobalFunc_PetExchangeAppearance_Open(selectIndexTable)
  local self = PetExchangeAppearance
  self:Open(selectIndexTable)
end
function PaGlobalFunc_PetExchangeAppearance_Close()
  local self = PetExchangeAppearance
  self:Close()
end
function FromClient_luaLoadComplete_PetExchangeAppearance()
  local self = PetExchangeAppearance
  self:Initialize()
end
function PaGlobalFunc_PetExchangeAppearance_OnScreenResize()
  PetExchangeAppearance:onScreenResize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_PetExchangeAppearance")
