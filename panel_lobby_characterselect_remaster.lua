local _panel = Panel_Lobby_CharacterSelect_Remaster
local UI_Class = CppEnums.ClassType
local ePcWorkingType = CppEnums.PcWorkType
local const_64 = Defines.s64_const
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local TAB_TYPE = {NORMAL = 1, PREMIUM = 2}
local _eServantView = {
  vehicle = CppEnums.ServantType.Type_Vehicle,
  ship = CppEnums.ServantType.Type_Ship,
  max = 1
}
local _servantTextureUV = {
  [_eServantView.vehicle] = {
    x1 = 206,
    y1 = 154,
    x2 = 256,
    y2 = 204
  },
  [_eServantView.ship] = {
    x1 = 257,
    y1 = 154,
    x2 = 307,
    y2 = 204
  }
}
local CharacterSelectRemaster = {
  _ui = {
    txt_CharacterSelect = nil,
    stc_rightBg = UI.getChildControl(_panel, "Static_RightBg"),
    list2_Character = UI.getChildControl(_panel, "List2_Character"),
    btn_deleteCharacter = nil,
    chk_characterPosChange = nil,
    btn_ExitGame = nil,
    btn_ExitToServerSelect = nil,
    stc_offlineModeBG = nil,
    chk_offlineMode = nil,
    txt_familyName = UI.getChildControl(_panel, "StaticText_FamilyName"),
    txt_characterName = UI.getChildControl(_panel, "StaticText_CharacterName"),
    txt_generalInformation = UI.getChildControl(_panel, "StaticText_Ticket"),
    txt_mouseRightClick_Guide = UI.getChildControl(_panel, "StaticText_MouseRightClick"),
    txt_mouseWheel_Guide = UI.getChildControl(_panel, "StaticText_MouseWheel"),
    rdo_tabs = {},
    btn_enterGame = {},
    stc_fade = UI.getChildControl(_panel, "Static_Fade")
  },
  _playerData = {
    maxSlot = 0,
    haveCount = 0,
    useAbleCount = 0,
    startIndex = 0,
    listCount = 9,
    initList = 12,
    isWaitLine = false,
    slotUiPool = {}
  },
  _selectedCharIdx = -1,
  _prevSelectedCharIdx = -1,
  _currentOveredCharIdx = 0,
  _isSpecialCharacter = false,
  _isCharacterSelected = false,
  _isSelectDeletingChar = false,
  _currentTab = TAB_TYPE.NORMAL,
  _isGhostMode = false,
  _isBlockServerBack = false
}
local _listContents = {}
local _listContentsFlag = {}
local _listContentsAlphaTarget = {}
local _listContentsAlphaFlag = {}
local _listContentsShowAniFlag = false
local _listContentsLaunchedCount = 0
local _listContentsLaunchTimeTable = {}
local _listContentsLaunchElapsed = 0
local _allAnimationFinished = false
local _isSpecialCharacterOpen = ToClient_IsContentsGroupOpen("281")
local _isEnterButtonEnable = true
local _enteringGameFadeOutTime = 1
local _enteringGameFadeOutFlag = false
local self = CharacterSelectRemaster
function CharacterSelectRemaster:init()
  self._ui.stc_fade:SetShow(false)
  self._ui.txt_CharacterSelect = UI.getChildControl(self._ui.stc_rightBg, "StaticText_CharacterSelect")
  self._ui.txt_characterCount = UI.getChildControl(self._ui.stc_rightBg, "StaticText_CharacterCount")
  self._ui.scroll_Vertical = UI.getChildControl(self._ui.list2_Character, "List2_1_VerticalScroll")
  self._ui.btn_deleteCharacter = UI.getChildControl(self._ui.stc_rightBg, "Button_DeleteCharacter")
  self._ui.chk_characterPosChange = UI.getChildControl(self._ui.stc_rightBg, "Checkbox_CharacterPosChange")
  self._ui.stc_offlineModeBG = UI.getChildControl(self._ui.stc_rightBg, "Static_CheckBG")
  self._ui.chk_offlineMode = UI.getChildControl(self._ui.stc_offlineModeBG, "CheckButton_Offline")
  self._ui.chk_offlineMode:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENTERTOFIELDMODE_OFFLINE"))
  self._ui.btn_ghostMode = UI.getChildControl(self._ui.stc_rightBg, "Button_OnlineCheck")
  self._ui.btn_ExitGame = UI.getChildControl(self._ui.stc_rightBg, "Button_ExitGame")
  self._ui.btn_ExitToServerSelect = UI.getChildControl(self._ui.stc_rightBg, "Button_ExitToServerSelect")
  self._ui.btn_deleteCharacter:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.btn_deleteCharacter:SetTextSpan(0, self._ui.btn_deleteCharacter:GetSizeY() / 2 - self._ui.btn_deleteCharacter:GetTextSizeY() / 2)
  self._ui.btn_ghostMode:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.btn_ghostMode:SetTextSpan(0, self._ui.btn_ghostMode:GetSizeY() / 2 - self._ui.btn_ghostMode:GetTextSizeY() / 2)
  self._ui.chk_characterPosChange:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.chk_characterPosChange:SetTextSpan(0, self._ui.chk_characterPosChange:GetSizeY() / 2 - self._ui.chk_characterPosChange:GetTextSizeY() / 2)
  self._ui.btn_ExitGame:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.btn_ExitGame:SetTextSpan(0, self._ui.btn_ExitGame:GetSizeY() / 2 - self._ui.btn_ExitGame:GetTextSizeY() / 2)
  self._ui.btn_ExitToServerSelect:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.btn_ExitToServerSelect:SetTextSpan(0, self._ui.btn_ExitToServerSelect:GetSizeY() / 2 - self._ui.btn_ExitToServerSelect:GetTextSizeY() / 2)
  self._ui.rdo_tabs[TAB_TYPE.NORMAL] = UI.getChildControl(self._ui.stc_rightBg, "RadioButton_Normal")
  self._ui.rdo_tabs[TAB_TYPE.PREMIUM] = UI.getChildControl(self._ui.stc_rightBg, "RadioButton_Special")
  for ii = 1, #self._ui.rdo_tabs do
    if true == _isSpecialCharacterOpen then
      self._ui.rdo_tabs[ii]:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_SetTabTo(" .. ii .. ")")
      self._ui.rdo_tabs[ii]:SetShow(true)
    else
      self._ui.rdo_tabs[ii]:SetShow(false)
    end
  end
  PaGlobal_CharacterSelect_Resize()
  self._ui.list2_Character:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_CharacterSelect_CharacterList_ControlCreate")
  self._ui.list2_Character:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  local content = UI.getChildControl(self._ui.list2_Character, "List2_1_Content")
  _listContentsCount = math.ceil(self._ui.list2_Character:GetSizeY() / content:GetSizeY())
  for ii = 0, _listContentsCount + 1 do
    _listContentsLaunchTimeTable[ii] = (ii - 1) * 0.03
  end
  self:registEventHandler()
  self:registMessageHandler()
  if false == _ContentsGroup_GhostMode then
    self._ui.btn_ghostMode:SetShow(false)
  end
  self._ui.txt_mouseRightClick_Guide:SetPosX(20)
  self._ui.txt_mouseRightClick_Guide:SetPosY(getScreenSizeY() - self._ui.txt_mouseRightClick_Guide:GetSizeY() - 20)
  self._ui.txt_mouseRightClick_Guide:SetText(self._ui.txt_mouseRightClick_Guide:GetText())
  self._ui.txt_mouseWheel_Guide:SetPosX(self._ui.txt_mouseRightClick_Guide:GetPosX() + self._ui.txt_mouseRightClick_Guide:GetTextSizeX() + 60)
  self._ui.txt_mouseWheel_Guide:SetPosY(getScreenSizeY() - self._ui.txt_mouseRightClick_Guide:GetSizeY() - 20)
end
function CharacterSelectRemaster:registEventHandler()
  self._ui.btn_deleteCharacter:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_DeleteCharacter()")
  self._ui.chk_characterPosChange:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_ChangeOrder()")
  self._ui.chk_offlineMode:addInputEvent("Mouse_On", "InputMOn_CharacterSelect_ToggleOfflineModeTooltip()")
  self._ui.chk_offlineMode:addInputEvent("Mouse_Out", "InputMOut_CharacterSelect_ToggleOfflineModeTooltip()")
  self._ui.btn_ExitGame:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_ExitGame()")
  self._ui.btn_ExitToServerSelect:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_ExitToServerSelect()")
  _panel:addInputEvent("Mouse_On", "HandleEventMouse_LobbyCharacterCursor(true)")
  _panel:addInputEvent("Mouse_Out", "HandleEventMouse_LobbyCharacterCursor(false)")
end
function CharacterSelectRemaster:registMessageHandler()
  _panel:RegisterUpdateFunc("PaGlobalFunc_CharacterSelectRemaster_PerFrameUpdate")
  registerEvent("EventChangeLobbyStageToCharacterSelect", "PaGlobal_CharacterSelect_Open")
  registerEvent("EventCancelEnterWating", "PaGlobal_CharacterSelect_CancelWaitingLine")
  registerEvent("EventReceiveEnterWating", "PaGlobal_CharacterSelect_ReceiveWaiting")
  registerEvent("EventSetEnterWating", "PaGlobal_CharacterSelect_SetWaitingUserCount")
end
function CharacterSelectRemaster:close()
  _panel:SetShow(false)
end
function CharacterSelectRemaster:open()
  _panel:SetShow(true)
  if false == _allAnimationFinished then
    local ImageMoveAni = self._ui.stc_rightBg:addMoveAnimation(0, 0.7, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    ImageMoveAni:SetStartPosition(getScreenSizeX(), 0)
    ImageMoveAni:SetEndPosition(getScreenSizeX() - self._ui.stc_rightBg:GetSizeX(), 0)
    ImageMoveAni.IsChangeChild = true
    self._ui.stc_rightBg:CalcUIAniPos(ImageMoveAni)
  end
end
function CharacterSelectRemaster:updateData()
  self._isSpecialCharacter = TAB_TYPE.PREMIUM == self._currentTab
  self._playerData.maxSlot = self:getCharacterMaxSlotData(self._isSpecialCharacter)
  self._playerData.haveCount = getCharacterDataCount(self._isSpecialCharacter)
  self._playerData.useAbleCount = getCharacterSlotLimit(self._isSpecialCharacter)
  self._ui.txt_familyName:SetText(getFamilyName())
  self._ui.txt_characterCount:SetText(" (" .. self._playerData.haveCount .. "/" .. self._playerData.useAbleCount .. ")")
  self._ui.chk_characterPosChange:SetEnable(not self._isSpecialCharacter)
  self._ui.chk_characterPosChange:SetMonoTone(self._isSpecialCharacter)
  self._ui.list2_Character:getElementManager():clearKey()
  local content = UI.getChildControl(self._ui.list2_Character, "List2_1_Content")
  for characterIdx = 0, self._playerData.useAbleCount - 1 do
    self._ui.list2_Character:getElementManager():pushKey(toInt64(0, characterIdx))
  end
  _listContentsCount = self._ui.list2_Character:getChildContentListSize()
  if nil ~= self._selectedCharIdx and -1 ~= self._selectedCharIdx then
    local removeTime = getCharacterDataRemoveTime(self._selectedCharIdx, self._isSpecialCharacter)
    self._ui.btn_deleteCharacter:SetEnable(nil == removeTime)
    self._ui.btn_deleteCharacter:SetMonoTone(nil ~= removeTime)
  end
  if -1 ~= self._selectedCharIdx then
    local removeTime = getCharacterDataRemoveTime(self._selectedCharIdx, self._isSpecialCharacter)
    if nil ~= removeTime then
      PaGlobal_CharacterSelect_SetUpdateTicketNo(nil, removeTime)
    else
      local characterData = getCharacterDataByIndex(self._selectedCharIdx, self._isSpecialCharacter)
      if nil ~= characterData then
        PaGlobal_CharacterSelect_SetUpdateTicketNo(characterData)
      end
    end
  end
end
function CharacterSelectRemaster:getCharacterMaxSlotData(isCharacterSpecial)
  local maxcount = 0
  if getCharacterDataCount(isCharacterSpecial) <= getCharacterSlotMaxCount(isCharacterSpecial) then
    maxcount = getCharacterSlotLimit(isCharacterSpecial) + 1
  else
    maxcount = getCharacterDataCount(isCharacterSpecial)
  end
  return maxcount
end
function CharacterSelectRemaster:characterView(index, classType, isSpecialCharacter, isChangeSpecialTab)
  if classType == UI_Class.ClassType_Warrior then
    viewCharacter(index, -50, -40, -65, 0.15, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    viewCharacterFov(0.75)
    setWeatherTime(8, 1)
  elseif classType == UI_Class.ClassType_Ranger then
    viewCharacter(index, -40, -10, -40, 0.45, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(-0.05, 0)
    viewCharacterFov(0.55)
    setWeatherTime(8, 0)
  elseif classType == UI_Class.ClassType_Sorcerer then
    viewCharacter(index, -40, -30, -75, 0.55, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    setWeatherTime(8, 9)
    viewCharacterFov(0.55)
  elseif classType == UI_Class.ClassType_Giant then
    viewCharacter(index, -50, -25, -94, -0.6, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0.2, 0)
    setWeatherTime(8, 3)
    viewCharacterFov(0.85)
  elseif classType == UI_Class.ClassType_Tamer then
    viewCharacter(index, -30, -50, -94, -0.1, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    setWeatherTime(8, 17)
    viewCharacterFov(0.55)
  elseif classType == UI_Class.ClassType_BladeMaster then
    viewCharacter(index, -20, -45, -94, -0.1, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    setWeatherTime(8, 21)
    viewCharacterFov(0.75)
  elseif classType == UI_Class.ClassType_BladeMasterWomen then
    viewCharacter(index, -20, -25, -114, -0.1, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    setWeatherTime(8, 23)
    viewCharacterFov(0.75)
  elseif classType == UI_Class.ClassType_Valkyrie then
    viewCharacter(index, -20, -20, -94, 1.1, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    viewCharacterFov(0.65)
    setWeatherTime(8, 20)
  elseif classType == UI_Class.ClassType_Wizard then
    viewCharacter(index, -20, -20, -94, 1.1, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    setWeatherTime(8, 19)
    viewCharacterFov(0.55)
  elseif classType == UI_Class.ClassType_WizardWomen then
    viewCharacter(index, -20, -20, -94, 1.1, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    setWeatherTime(8, 21)
    viewCharacterFov(0.55)
  elseif classType == UI_Class.ClassType_NinjaWomen then
    viewCharacter(index, -25, -25, -94, 1.1, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    setWeatherTime(8, 18)
    viewCharacterFov(0.55)
  elseif classType == UI_Class.ClassType_NinjaMan then
    viewCharacter(index, -20, -20, -100, 1.1, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    setWeatherTime(8, 18)
    viewCharacterFov(0.55)
  elseif classType == UI_Class.ClassType_ShyWomen then
    viewCharacter(index, -18, -54, -178, -0.1, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    setWeatherTime(7, 7)
    viewCharacterFov(0.75)
  elseif classType == UI_Class.ClassType_Shy then
  elseif classType == UI_Class.ClassType_Temp then
    viewCharacter(index, -20, -45, -114, -0.1, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    setWeatherTime(8, 23)
    viewCharacterFov(0.75)
  elseif classType == UI_Class.ClassType_Kunoichi then
  elseif classType == UI_Class.ClassType_DarkElf then
    viewCharacter(index, -20, -45, -114, -0.1, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    setWeatherTime(7, 7)
    viewCharacterFov(0.75)
  elseif classType == UI_Class.ClassType_Combattant then
    viewCharacter(index, -50, -40, -65, 0.15, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    viewCharacterFov(0.75)
    setWeatherTime(7, 16)
  elseif classType == UI_Class.ClassType_CombattantWomen then
    viewCharacter(index, -20, -25, -114, -0.1, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    setWeatherTime(7, 17)
    viewCharacterFov(0.75)
  elseif classType == UI_Class.ClassType_Lahn then
    viewCharacter(index, -20, -20, -94, -0.4, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    setWeatherTime(8, 17)
    viewCharacterFov(0.55)
  elseif classType == UI_Class.ClassType_Orange then
    viewCharacter(index, -20, -30, -94, -0.4, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    viewCharacterFov(0.75)
    setWeatherTime(8, 8)
  elseif classType == __eClassType_Unknown1 then
    viewCharacter(index, -20, -30, -94, -0.4, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    viewCharacterFov(0.75)
    setWeatherTime(8, 8)
  else
    viewCharacter(index, 0, 0, 0, 0, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(3.14, 0)
  end
end
function CharacterSelectRemaster:changeTexture_Class(control, classType)
  if classType == __eClassType_Warrior then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 172, 57, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_ElfRanger then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 58, 172, 114, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_Sorcerer then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 115, 172, 171, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_Giant then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 172, 172, 228, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_Tamer then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 229, 172, 285, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_BladeMaster then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 286, 172, 342, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_BladeMasterWoman then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 400, 172, 456, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_Valkyrie then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 343, 172, 399, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_WizardMan then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 229, 57, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_WizardWoman then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 58, 229, 114, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_Kunoichi then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 115, 229, 171, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_NinjaMan then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 172, 229, 228, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_DarkElf then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 229, 229, 285, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_Combattant then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 286, 229, 342, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_Mystic then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 343, 229, 399, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_Lhan then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 400, 229, 456, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_RangerMan then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 286, 57, 342)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == __eClassType_ShyWaman then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 58, 115, 114, 171)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_SnowBucks then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 286, 57, 342)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  else
    if classType == __eClassType_Unknown1 then
      control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 286, 57, 342)
      control:getBaseTexture():setUV(x1, y1, x2, y2)
      control:setRenderTexture(control:getBaseTexture())
    else
    end
  end
end
function PaGlobal_CharacterSelect_CharacterList_ControlCreate(content, key)
  local characterIdx = Int64toInt32(key)
  local isSpecialCharacter = self._isSpecialCharacter
  _listContents[characterIdx] = content
  if false == _allAnimationFinished and false == _listContentsShowAniFlag then
    content:SetAlphaExtraChild(0)
  else
    _listContentsAlphaTarget[characterIdx] = 1
    _listContentsAlphaFlag[characterIdx] = true
  end
  local Btn_CharSlot = UI.getChildControl(content, "Button_CharacterSlot")
  local stc_ClasIcon = UI.getChildControl(content, "Static_ClassIcon")
  local txt_Level = UI.getChildControl(content, "StaticText_Lv")
  local txt_Name = UI.getChildControl(content, "StaticText_Name")
  local txt_Region = UI.getChildControl(content, "StaticText_Region")
  local txt_Delete = UI.getChildControl(content, "StaticText_Delete")
  local stc_AddIcon = UI.getChildControl(content, "Static_AddIcon")
  local stc_LockIcon = UI.getChildControl(content, "Static_LockIcon")
  local stc_Selected = UI.getChildControl(content, "Static_SelectGradation")
  local btn_joinGame = UI.getChildControl(stc_Selected, "Button_Enter")
  local btn_up = UI.getChildControl(content, "Button_Up")
  local btn_down = UI.getChildControl(content, "Button_Down")
  local stc_ServantView = {}
  for i = 0, _eServantView.max do
    stc_ServantView[i] = UI.getChildControl(content, "Static_ServantView_" .. i)
    stc_ServantView[i]:SetShow(false)
  end
  self._ui.btn_enterGame[characterIdx] = btn_joinGame
  Btn_CharSlot:SetShow(false)
  stc_ClasIcon:SetShow(false)
  txt_Level:SetShow(false)
  txt_Name:SetShow(false)
  txt_Region:SetShow(false)
  txt_Region:SetText("")
  txt_Delete:SetShow(false)
  stc_AddIcon:SetShow(false)
  stc_LockIcon:SetShow(false)
  stc_Selected:SetShow(false)
  btn_up:SetShow(false)
  btn_down:SetShow(false)
  if characterIdx < self._playerData.haveCount then
    local characterData = getCharacterDataByIndex(characterIdx, isSpecialCharacter)
    local regionInfo
    if nil ~= characterData then
      local characterName = getCharacterName(characterData)
      local classType = getCharacterClassType(characterData)
      local characterLevel = string.format("%d", characterData._level)
      local pcDeliveryRegionKey = characterData._arrivalRegionKey
      local serverUtc64 = getServerUtc64()
      local whereIs = "-"
      local servantIdx = 0
      for eServantIdx = 0, _eServantView.max do
        local briefServantInfo = ToClient_GetBriefServantInfoByCharacter(characterData, eServantIdx)
        if nil ~= briefServantInfo then
          local servantControl = stc_ServantView[servantIdx]
          local textureUV = _servantTextureUV[eServantIdx]
          servantControl:SetShow(true)
          local x1, y1, x2, y2 = setTextureUV_Func(servantControl, textureUV.x1, textureUV.y1, textureUV.x2, textureUV.y2)
          servantControl:getBaseTexture():setUV(x1, y1, x2, y2)
          servantControl:setRenderTexture(servantControl:getBaseTexture())
          servantControl:addInputEvent("Mouse_On", "HandleEventOnOut_CharacterSelect_ServantInfoTooltip(true, " .. characterIdx .. ", " .. eServantIdx .. ")")
          servantControl:addInputEvent("Mouse_Out", "HandleEventOnOut_CharacterSelect_ServantInfoTooltip(false)")
          servantIdx = servantIdx + 1
        end
      end
      if 0 ~= characterData._currentPosition.x and 0 ~= characterData._currentPosition.y and 0 ~= characterData._currentPosition.z then
        if 0 ~= pcDeliveryRegionKey:get() and serverUtc64 > characterData._arrivalTime then
          regionInfo = getRegionInfoByRegionKey(pcDeliveryRegionKey)
          local retionInfoArrival = getRegionInfoByRegionKey(pcDeliveryRegionKey)
          whereIs = retionInfoArrival:getAreaName()
        else
          regionInfo = getRegionInfoByPosition(characterData._currentPosition)
          whereIs = regionInfo:getAreaName()
        end
      end
      self:changeTexture_Class(stc_ClasIcon, classType)
      txt_Name:SetText(characterName)
      txt_Level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. ". " .. characterLevel)
      txt_Region:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
      txt_Region:SetText(whereIs)
      Btn_CharSlot:addInputEvent("Mouse_On", "")
      Btn_CharSlot:addInputEvent("Mouse_LUp", "")
      btn_up:SetShow(false)
      btn_down:SetShow(false)
      stc_Selected:SetShow(characterIdx == self._currentOveredCharIdx and false == self._ui.chk_characterPosChange:IsCheck())
      local removeTime = getCharacterDataRemoveTime(characterIdx, isSpecialCharacter)
      if nil ~= removeTime then
        txt_Delete:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_DeleteCancelCharacter(" .. characterIdx .. " )")
        txt_Delete:SetIgnore(false)
        txt_Delete:SetShow(true)
        Btn_CharSlot:addInputEvent("Mouse_On", "InputMOn_CharacterSelect_OverCharacterSlot(" .. characterIdx .. ")")
        Btn_CharSlot:addInputEvent("Mouse_LUp", "PaGlobal_CharacterSelect_SelectCharacter(" .. characterIdx .. ")")
        btn_joinGame:SetShow(false)
      elseif self._ui.chk_characterPosChange:IsCheck() then
        btn_up:SetShow(true)
        btn_up:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_ChangeSlotPosition( " .. characterIdx .. ", true )")
        btn_down:SetShow(true)
        btn_down:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_ChangeSlotPosition( " .. characterIdx .. ", false )")
        btn_joinGame:SetShow(false)
      else
        Btn_CharSlot:addInputEvent("Mouse_On", "InputMOn_CharacterSelect_OverCharacterSlot(" .. characterIdx .. ")")
        Btn_CharSlot:addInputEvent("Mouse_LUp", "PaGlobal_CharacterSelect_SelectCharacter(" .. characterIdx .. ")")
        btn_joinGame:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_SelectCharacterWithSavedIdx(" .. characterIdx .. ")")
        btn_joinGame:SetTextSpan(0, btn_joinGame:GetSizeY() / 2 - btn_joinGame:GetTextSizeY() / 2)
        btn_joinGame:SetShow(true)
        btn_joinGame:SetEnable(_isEnterButtonEnable)
        btn_joinGame:SetMonoTone(not _isEnterButtonEnable)
      end
      Btn_CharSlot:SetShow(true)
      stc_ClasIcon:SetShow(true)
      txt_Level:SetShow(true)
      txt_Name:SetShow(true)
      txt_Region:SetShow(true)
    else
    end
  elseif characterIdx == self._playerData.haveCount then
    Btn_CharSlot:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_CreateCharacter()")
    Btn_CharSlot:SetIgnore(false)
    Btn_CharSlot:addInputEvent("Mouse_On", "InputMO_CharacterSelect_CharacterCreate()")
    stc_AddIcon:SetShow(true)
    Btn_CharSlot:SetShow(true)
  else
    Btn_CharSlot:SetIgnore(false)
    Btn_CharSlot:addInputEvent("Mouse_On", "InputMO_CharacterSelect_LockedCharacterSlot()")
    Btn_CharSlot:addInputEvent("Mouse_LUp", "")
    stc_LockIcon:SetShow(true)
    Btn_CharSlot:SetShow(true)
  end
  content:ComputePos()
end
function PaGlobal_CharacterSelect_Close()
  self:close()
end
function PaGlobal_CharacterSelect_Open(charIdx)
  self:close()
  if true == _ContentsGroup_RenewUI_Customization then
    PaGlobalFunc_Customization_Close()
    PaGlobalFunc_Customization_InputName_Close()
  end
  showAllUI(false)
  if -1 == charIdx or charIdx >= self._playerData.haveCount then
    self._selectedCharIdx = 0
  elseif -2 == charIdx then
    self._selectedCharIdx = self._selectedCharIdx
  else
    self._selectedCharIdx = charIdx
  end
  for ii = 1, #self._ui.rdo_tabs do
    self._ui.rdo_tabs[ii]:SetFontColor(Defines.Color.C_FF525B6D)
  end
  self._ui.rdo_tabs[self._currentTab]:SetFontColor(Defines.Color.C_FFEEEEEE)
  self:updateData()
  self:open()
  PaGlobal_CharacterSelect_SelectCharacter(self._selectedCharIdx, true)
  self:setGhostModeButonText()
end
function PaGlobal_CharacterSelect_SelectCharacter(charIdx, initialSelect)
  local isSpecialCharacter = self._isSpecialCharacter
  local characterData = getCharacterDataByIndex(charIdx, isSpecialCharacter)
  local oldIndex = self._selectedCharIdx
  if nil ~= characterData then
    local classType = getCharacterClassType(characterData)
    local removeTime = getCharacterDataRemoveTime(charIdx, isSpecialCharacter)
    local isDeleting = nil ~= removeTime
    self._isSelectDeletingChar = isDeleting
    self._ui.btn_deleteCharacter:SetEnable(not isDeleting)
    self._ui.btn_deleteCharacter:SetMonoTone(isDeleting)
    if isDeleting then
      PaGlobal_CharacterSelect_SetUpdateTicketNo(nil, removeTime)
    else
      PaGlobal_CharacterSelect_SetUpdateTicketNo(characterData)
    end
    self._prevSelectedCharIdx = self._selectedCharIdx
    self._selectedCharIdx = charIdx
    self._ui.list2_Character:requestUpdateByKey(toInt64(0, self._prevSelectedCharIdx))
    self._ui.list2_Character:requestUpdateByKey(toInt64(0, self._selectedCharIdx))
    if initialSelect or oldIndex ~= self._selectedCharIdx then
      self:characterView(self._selectedCharIdx, classType, isSpecialCharacter, false)
      local characterName = getCharacterName(characterData)
      self._ui.txt_characterName:SetText(characterName)
    end
  else
    self._ui.txt_characterName:SetText("")
  end
end
function InputMLUp_CharacterSelect_CreateCharacter()
  if Panel_Win_System:GetShow() then
    return
  end
  local function do_Create()
    local isSpecialCharacter = self._isSpecialCharacter
    changeCreateCharacterMode_SelectClass(isSpecialCharacter)
    FGlobal_SetSpecialCharacter(isSpecialCharacter)
  end
  local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERSELECT_CREATENEWCHARACTER_NOTIFY")
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERSELECT_CREATENEWCHARACTER_BTN"),
    content = messageContent,
    functionYes = do_Create,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "middle")
end
function InputMLUp_CharacterSelect_DeleteCharacter()
  local isSpecialCharacter = self._isSpecialCharacter
  if -1 ~= self._selectedCharIdx then
    local characterData = getCharacterDataByIndex(self._selectedCharIdx, isSpecialCharacter)
    local removeTime = getCharacterDataRemoveTime(self._selectedCharIdx, isSpecialCharacter)
    if nil ~= removeTime then
      return
    end
    if nil == characterData then
      return
    end
    local function do_Delete()
      deleteCharacter(self._selectedCharIdx, isSpecialCharacter)
    end
    local removeTimeCheckLevel = getCharacterRemoveTimeCheckLevel()
    local removeTime
    if removeTimeCheckLevel > characterData._level then
      removeTime = Int64toInt32(getLowLevelCharacterRemoveDate())
    else
      removeTime = Int64toInt32(getCharacterRemoveDate())
    end
    local characterNameRestoreTime = Int64toInt32(getNameRemoveDate())
    local remainTime = convertStringFromDatetime(toInt64(0, characterNameRestoreTime - removeTime))
    local messageContent = PAGetStringParam3(Defines.StringSheet_GAME, "CHARACTER_LATER_DELETE_MESSAGEBOX_MEMO", "removeTime", convertStringFromDatetime(toInt64(0, removeTime)), "characterName", getCharacterName(characterData), "remainTime", remainTime)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "CHARACTER_DELETE_MESSAGEBOX_TITLE"),
      content = messageContent,
      functionYes = do_Delete,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function InputMLUp_CharacterSelect_DeleteCancelCharacter(chrIdx)
  local isSpecialCharacter = self._isSpecialCharacter
  if -1 ~= chrIdx then
    deleteCancelCharacter(chrIdx, isSpecialCharacter)
  end
end
function InputMLUp_CharacterSelect_ChangeOrder()
  self:updateData()
end
function InputMOn_CharacterSelect_ToggleOfflineModeTooltip()
  local self = CharacterSelectRemaster
  if nil == self then
    return
  end
  local Name = PAGetString(Defines.StringSheet_GAME, "LUA_ENTERTOFIELDMODE_OFFLINE")
  local Desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERSELECT_OFFLINE_TOOLTIP")
  TooltipSimple_Show(self._ui.chk_offlineMode, Name, Desc)
end
function InputMOut_CharacterSelect_ToggleOfflineModeTooltip()
  TooltipSimple_Hide()
end
function CharacterSelectRemaster:setGhostModeButonText()
  if true == self._isGhostMode then
    self._ui.btn_ghostMode:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENTERTOFIELDMODE_OFFLINE"))
  else
    self._ui.btn_ghostMode:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENTERTOFIELDMODE_ONLINE"))
  end
end
function InputMLUp_CharacterSelect_PlayGame(characterIdx)
  if ToClient_isDataDownloadStart() then
    local isComplete = ToClient_isDataDownloadComplete()
    local percent = ToClient_getDataDownloadProgress()
    if false == isComplete then
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MESSAGEBOX_XBOX_DATAINSTALLATION_DESC") .. tostring(percent),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
      return
    end
  end
  local isSpecialCharacter = self._isSpecialCharacter
  if true == isSpecialCharacter then
    local curChannelData = getCurrentChannelServerData()
    if nil ~= curChannelData and true == curChannelData._isSiegeChannel then
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERLIST_SPECIALCHARACTER_WARNING"),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
      return
    end
  end
  local characterData = getCharacterDataByIndex(characterIdx, isSpecialCharacter)
  local classType = getCharacterClassType(characterData)
  local characterCount = getCharacterDataCount()
  local serverUtc64 = getServerUtc64()
  if true == ToClient_IsCustomizeOnlyClass(classType) then
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_LOBBY_SELECTCHARACTER_NOTYET"),
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
    return
  end
  if nil ~= characterData then
    if getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT or getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_OBT or getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_Commercial then
      if 1 == characterData._level and 1 == characterCount and false == ToClient_isConsole() then
        self._selectedCharIdx = characterIdx
        FGlobal_FirstLogin_Open(characterIdx)
      else
        local pcDeliveryRegionKey = characterData._arrivalRegionKey
        if ePcWorkingType.ePcWorkType_Empty ~= characterData._pcWorkingType and ePcWorkingType.ePcWorkType_Play ~= characterData._pcWorkingType or 0 ~= pcDeliveryRegionKey:get() and serverUtc64 < characterData._arrivalTime then
          if 0 ~= pcDeliveryRegionKey:get() then
            contentString = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_WORKING_NOW_CHANGE_Q") .. PAGetString(Defines.StringSheet_GAME, "LUA_LOBBY_MAIN_MOVECHARACTER_MSG")
          elseif ePcWorkingType.ePcWorkType_ReadBook == characterData._pcWorkingType then
            contentString = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_WORKING_NOW_READ_BOOK")
          elseif ePcWorkingType.ePcWorkType_RepairItem == characterData._pcWorkingType then
            contentString = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_WORKING_NOW_REPAIR")
          end
          local function enterGame()
            self._selectedCharIdx = characterIdx
            PaGlobal_CharacterSelect_SelectEnterToGame()
          end
          local messageboxData = {
            title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
            content = contentString,
            functionYes = enterGame,
            functionCancel = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageboxData)
        else
          if false == isSpecialCharacter and true == ToClient_CheckDuelCharacterInPrison(characterIdx) then
            local messageboxData = {
              title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
              content = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERTAG_PRISON_CANT_LOGIN"),
              functionApply = MessageBox_Empty_function,
              priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
            }
            MessageBox.showMessageBox(messageboxData)
            return
          end
          if ToClient_IsCustomizeOnlyClass(classType) then
            local messageboxData = {
              title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
              content = PAGetString(Defines.StringSheet_GAME, "LUA_LOBBY_SELECTCHARACTER_CUSTOMIZEONLYCLASS_MEMO"),
              functionApply = MessageBox_Empty_function,
              priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
            }
            MessageBox.showMessageBox(messageboxData)
          else
            PaGlobalFunc_CharacterSelectRemaster_FadeOut()
            self:enableEnterButton(false)
            self._selectedCharIdx = characterIdx
            luaTimer_AddEvent(PaGlobalFunc_CharacterSelectRemaster_TryLogin, _enteringGameFadeOutTime * 1000, false, 0)
          end
        end
      end
      local temporaryWrapper = getTemporaryInformationWrapper()
      temporaryWrapper:setGhostMode(self._ui.chk_offlineMode:IsCheck())
    else
      local titleText = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
      local messageboxData = {
        title = titleText,
        content = PAGetString(Defines.StringSheet_GAME, "PANEL_LOBBY_PREDOWNLOAD"),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW,
        exitButton = false
      }
      MessageBox.showMessageBox(messageboxData)
    end
  end
end
function PaGlobalFunc_CharacterSelectRemaster_TryLogin()
  if false == selectCharacter(self._selectedCharIdx, self._isSpecialCharacter) then
    self:enableEnterButton(true)
    PaGlobalFunc_CharacterSelectRemaster_FadeIn()
  end
end
function PaGlobalFunc_CharacterSelectRemaster_FadeIn()
  local ImageAni = self._ui.stc_fade:addColorAnimation(0, _enteringGameFadeOutTime, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  ImageAni:SetStartColor(Defines.Color.C_FF000000)
  ImageAni:SetEndColor(Defines.Color.C_00000000)
  ImageAni:SetHideAtEnd(true)
  CharacterSelectRemaster._isBlockServerBack = false
end
function PaGlobalFunc_CharacterSelectRemaster_FadeOut()
  self._ui.stc_fade:SetShow(true)
  local ImageAni = self._ui.stc_fade:addColorAnimation(0, _enteringGameFadeOutTime, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  ImageAni:SetStartColor(Defines.Color.C_00000000)
  ImageAni:SetEndColor(Defines.Color.C_FF000000)
  ImageAni:SetHideAtEnd(false)
  CharacterSelectRemaster._isBlockServerBack = true
end
function CharacterSelectRemaster:enableEnterButton(isEnable)
  self._ui.btn_deleteCharacter:SetEnable(isEnable)
  self._ui.chk_characterPosChange:SetEnable(isEnable)
  self._ui.btn_ExitGame:SetEnable(isEnable)
  self._ui.btn_ExitToServerSelect:SetEnable(isEnable)
  for ii = 1, #self._ui.btn_enterGame do
    self._ui.btn_enterGame[ii]:SetEnable(isEnable)
  end
end
function InputMLUp_CharacterSelect_ExitGame()
  local do_Exit = function()
    disConnectToGame()
    GlobalExitGameClient()
  end
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "GAME_EXIT_MESSAGEBOX_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "GAME_EXIT_MESSAGEBOX_MEMO"),
    functionYes = do_Exit,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function InputMLUp_CharacterSelect_ExitToServerSelect()
  if true == CharacterSelectRemaster._isBlockServerBack then
    return
  end
  CharacterSelectRemaster:close()
  backServerSelect()
end
function InputMOn_CharacterSelect_OverCharacterSlot(index)
  if false == _allAnimationFinished then
    return
  end
  if nil ~= self._currentOveredCharIdx and nil ~= index and index ~= self._currentOveredCharIdx then
    local oldIndex = self._currentOveredCharIdx
    self._currentOveredCharIdx = index
    self._ui.list2_Character:requestUpdateByKey(toInt64(0, oldIndex))
    self._ui.list2_Character:requestUpdateByKey(toInt64(0, self._currentOveredCharIdx))
  end
end
function HandleEventOnOut_CharacterSelect_ServantInfoTooltip(isShow, charDataIdx, servantIdx)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local characterData = getCharacterDataByIndex(charDataIdx)
  if nil == characterData then
    return
  end
  local briefServantInfo = ToClient_GetBriefServantInfoByCharacter(characterData, servantIdx)
  if nil == briefServantInfo then
    return
  end
  local name = briefServantInfo:getName()
  local desc = PaGlobalFunc_CharacterSelect_ServantInfoText(briefServantInfo)
  local control = UI.getChildControl(_listContents[charDataIdx], "Static_ServantView_" .. servantIdx)
  TooltipSimple_Show(control, name, desc)
end
function PaGlobalFunc_CharacterSelect_ServantInfoText(briefServantInfo)
  UI.ASSERT_NAME(nil ~= briefServantInfo, "PaGlobalFunc_GameExit_ServantInfoText briefServantInfo nil", "\236\178\156\235\167\140\234\184\176")
  local servantKind = briefServantInfo:getServantKind()
  local strKind = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_SERVANTKIND_" .. servantKind)
  local strText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANTINFO_TOOLTIP_KIND", "kind", strKind)
  local level = briefServantInfo:getLevel()
  if level > 0 then
    strText = strText .. "\n" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANTINFO_TOOLTIP_LEVEL", "level", level)
  end
  if CppEnums.ServantKind.Type_Horse == servantKind then
    local tier = briefServantInfo:getTier()
    if tier > 0 then
      if 9 == tier then
        tier = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9")
      end
      strText = strText .. "\n" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANTINFO_TOOLTIP_TIER", "tier", tier)
    end
  end
  return strText
end
function InputMO_CharacterSelect_CharacterCreate()
  if false == _allAnimationFinished then
    return
  end
  self._isCharacterSelected = false
end
function InputMO_CharacterSelect_LockedCharacterSlot()
  if false == _allAnimationFinished then
    return
  end
  self._isCharacterSelected = false
end
function InputMLUp_CharacterSelect_SelectCharacterWithSavedIdx(characterIdx)
  if false == _allAnimationFinished then
    return
  end
  if true == self._isSelectDeletingChar then
    return
  end
  InputMLUp_CharacterSelect_PlayGame(characterIdx)
  self._isCharacterSelected = true
end
function InputMLUp_CharacterSelect_ChangeSlotPosition(index, isUp)
  if false == _allAnimationFinished then
    return
  end
  if nil == index or nil == isUp then
    return
  end
  ToClient_ChangeCharacterListOrder(index, isUp)
  ToClient_SaveClientCacheData()
  local characterData = getCharacterDataByIndex(self._selectedCharIdx, self._isSpecialCharacter)
  local classType = getCharacterClassType(characterData)
  self:characterView(self._selectedCharIdx, classType, self._isSpecialCharacter, false)
  self:updateData()
end
function InputMLUp_CharacterSelect_SetTabTo(tabIndex)
  if false == _allAnimationFinished then
    return
  end
  if self._ui.chk_characterPosChange:IsCheck() then
    self._ui.chk_characterPosChange:SetCheck(false)
    self:updateData()
  end
  if tabIndex ~= self._currentTab then
    self._isSpecialCharacter = TAB_TYPE.PREMIUM == tabIndex
    self._selectedCharIdx = 0
    self._prevSelectedCharIdx = -1
    FGlobal_SetSpecialCharacter(self._isSpecialCharacter)
    local characterData = getCharacterDataByIndex(self._selectedCharIdx, self._isSpecialCharacter)
    if nil ~= characterData then
      local classType = getCharacterClassType(characterData)
      self:characterView(self._selectedCharIdx, classType, self._isSpecialCharacter, false)
    else
      self._selectedCharIdx = -1
      self:characterView(0, nil, self._isSpecialCharacter, false)
    end
    self._ui.rdo_tabs[self._currentTab]:SetFontColor(Defines.Color.C_FF525B6D)
    self._currentTab = tabIndex
    self._ui.rdo_tabs[tabIndex]:SetFontColor(Defines.Color.C_FFEEEEEE)
    self:updateData()
  end
end
function HandleEventMouse_LobbyCharacterCursor(isOn)
  ToClient_SetLobbyCharacterCursor(isOn)
end
function PaGlobal_CharacterSelect_SelectEnterToGame()
  if false == _allAnimationFinished then
    return
  end
  local isSpecialCharacter = self._isSpecialCharacter
  local characterData = getCharacterDataByIndex(self._selectedCharIdx, isSpecialCharacter)
  local classType = getCharacterClassType(characterData)
  if nil ~= characterData then
    if true == ToClient_IsCustomizeOnlyClass(classType) then
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = PAGetString(Defines.StringSheet_GAME, "LUA_LOBBY_SELECTCHARACTER_NOTYET_1") .. PAGetString(Defines.StringSheet_GAME, "LUA_LOBBY_SELECTCHARACTER_NOTYET_2"),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
    else
      selectCharacter(self._selectedCharIdx, isSpecialCharacter)
    end
  end
end
function PaGlobal_CharacterSelect_SetUpdateTicketNo(characterData, removeTime)
  if nil == characterData and nil ~= removeTime then
    self._ui.txt_generalInformation:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTER_DELETE") .. " ( " .. removeTime .. " )")
    self._ui.txt_generalInformation:SetFontColor(Defines.Color.C_FFBA2737)
    return
  end
  local firstTicketNo = getFirstTicketNoByAll()
  local currentTicketNo = getCurrentTicketNo()
  local ticketCountByRegion = characterData._lastTicketNoByRegion
  local myRegionWaitingPlayerCount = currentTicketNo - ticketCountByRegion
  local serverPlayingCount = currentTicketNo - firstTicketNo
  local classType = getCharacterClassType(characterData)
  local isPossibleClass = ToClient_IsCustomizeOnlyClass(classType)
  local text = ""
  if const_64.s64_m1 ~= firstTicketNo or const_64.s64_m1 ~= ticketCountByRegion then
    self._ui.txt_generalInformation:SetFontColor(Defines.Color.C_FFD20000)
    text = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_NOT_ENTER_TO_FIELD")
  elseif true == isPossibleClass then
    self._ui.txt_generalInformation:SetFontColor(Defines.Color.C_FFD20000)
    text = ""
  else
    self._ui.txt_generalInformation:SetFontColor(Defines.Color.C_FF96D4FC)
    text = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_ENTER_TO_FIELD")
  end
  local pcDeliveryRegionKey = characterData._arrivalRegionKey
  local serverUtc64 = getServerUtc64()
  if 0 ~= pcDeliveryRegionKey:get() and serverUtc64 < characterData._arrivalTime then
    local remainTime = characterData._arrivalTime - serverUtc64
    local strTime = convertStringFromDatetime(remainTime)
    text = text .. "\n" .. PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_DELIVERY") .. " : " .. strTime
  end
  self._ui.txt_generalInformation:SetText(text)
end
function PaGlobal_CharacterSelect_CancelWaitingLine()
  if true == self._playerData.isWaitLine then
    MessageBox_HideAni()
    self._playerData.isWaitLine = false
  end
end
function PaGlobal_CharacterSelect_ReceiveWaiting()
  local isSpecialCharacter = self._isSpecialCharacter
  self._playerData.isWaitLine = true
  local characterData = getCharacterDataByIndex(self._selectedCharIdx, isSpecialCharacter)
  if nil == characterData then
    UI.ASSERT(false, "\236\186\144\235\166\173\237\132\176 \236\132\160\237\131\157 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164!")
    return
  end
  SelectCharacter._ui.txt_generalInformation:SetFontColor(Defines.Color.C_FFD20000)
  SelectCharacter._ui.txt_generalInformation:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_NOT_ENTER_TO_FIELD"))
  local strWaitingMsg = PaGlobal_CharacterSelect_MakeWaitingUserMsg(characterData._lastTicketNoByRegion)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "CHARACTER_ENTER_WAITING_TITLE"),
    content = strWaitingMsg,
    functionCancel = PaGlobalFunc_CharacterSelectRemaster_ClickCancel,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1m,
    enablePriority = true
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobal_CharacterSelect_SetWaitingUserCount()
  if false == self._playerData.isWaitLine then
    return
  end
  local strWaitingMsg = PaGlobal_CharacterSelect_MakeWaitingUserMsg(-1)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "CHARACTER_ENTER_WAITING_TITLE"),
    content = strWaitingMsg,
    functionCancel = PaGlobalFunc_CharacterSelectRemaster_ClickCancel,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1m,
    enablePriority = true
  }
  if true == MessageBox.doHaveMessageBoxData(messageboxData.title) then
    setCurrentMessageData(messageboxData)
  else
    MessageBox.showMessageBox(messageboxData)
  end
end
function PaGlobalFunc_CharacterSelectRemaster_ClickCancel()
  if true == configData.isWaitLine then
    sendEnterWaitingCancel()
  end
  self:enableEnterButton(true)
end
function PaGlobal_CharacterSelect_MakeWaitingUserMsg(receiveTicketNoMyRegion)
  local isSpecialCharacter = self._isSpecialCharacter
  local ticketCountByRegion = receiveTicketNoMyRegion
  local waitingLineCancelCount = getCancelCount()
  if -1 == ticketCountByRegion then
    local selectedCharacterData = getCharacterDataByIndex(self._selectedCharIdx, isSpecialCharacter)
    local regionInfo = getRegionInfoByPosition(selectedCharacterData._currentPosition)
    local regionGroupKey = 1
    if nil ~= regionInfo then
      regionGroupKey = regionInfo:getRegionGroupKey()
    end
    ticketCountByRegion = getTicketCountByRegion(regionGroupKey)
  end
  local currentTicketNo = getCurrentTicketNo()
  local firstTicketNoByAll = getFirstTicketNoByAll()
  local totalWaitingPlayerCount = getAllWaitingLine() - getAllCancelCount()
  local myRegionWaitingPlayerCount = getMyWaitingLine() - getCancelCount()
  if totalWaitingPlayerCount < 0 then
    totalWaitingPlayerCount = 0
  end
  if myRegionWaitingPlayerCount <= 0 then
    myRegionWaitingPlayerCount = 0
  end
  local waitMsg = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WAIT_MESSAGE")
  local serverWaitStr = PAGetStringParam1(Defines.StringSheet_GAME, "CHARACTER_SERVER_WAIT_COUNT", "iCount", tostring(totalWaitingPlayerCount))
  local regionWaitStr = PAGetStringParam1(Defines.StringSheet_GAME, "CHARACTER_REGION_WAIT_COUNT", "iCount", tostring(myRegionWaitingPlayerCount))
  local emptyStr = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WAITING_PLAYER_EMPTY")
  local taiwanMsg = ""
  if isGameTypeTaiwan() or isGameTypeGT() then
    taiwanMsg = "\n\n\233\187\145\232\137\178\230\178\153\230\188\160\231\130\186\229\150\174\228\184\128\228\184\150\231\149\140\229\133\168\228\188\186\230\156\141\229\153\168\229\133\177\233\128\154\239\188\140\229\156\168\233\129\138\230\136\178\230\153\130\229\143\175\229\156\168\229\144\132\233\160\187\233\129\147\233\150\147\232\135\170\231\148\177\231\167\187\229\139\149\239\188\140\232\171\139\233\129\184\230\147\135\233\128\178\232\161\140\232\188\131\233\160\134\229\136\169\231\154\132\233\160\187\233\129\147\231\153\187\229\133\165\233\129\138\230\136\178\229\141\179\229\143\175"
  end
  if const_64.s64_m1 == firstTicketNoByAll and const_64.s64_m1 ~= ticketCountByRegion then
    strWaitingMsg = waitMsg .. [[


]] .. regionWaitStr .. taiwanMsg
  elseif const_64.s64_m1 == ticketCountByRegion and const_64.s64_m1 ~= firstTicketNoByAll or const_64.s64_m1 ~= ticketCountByRegion and 0 == myRegionWaitingPlayerCount then
    strWaitingMsg = waitMsg .. [[


]] .. serverWaitStr .. [[


]] .. PAGetString(Defines.StringSheet_GAME, "CHARACTER_REGION_WAIT_TEXT") .. emptyStr .. taiwanMsg
  else
    strWaitingMsg = waitMsg .. [[


]] .. serverWaitStr .. [[


]] .. regionWaitStr .. taiwanMsg
  end
  return strWaitingMsg
end
local _animationPlayed = false
local _animationDelay = 0.7
local _timeElapsed = 0
local _updateDelay = 0
local _enteringGameDelay = 0
function PaGlobalFunc_CharacterSelectRemaster_PerFrameUpdate(deltaTime)
  luaTimer_UpdatePerFrame(deltaTime)
  _updateDelay = _updateDelay + deltaTime
  if _updateDelay > 1 and _allAnimationFinished then
    _updateDelay = 0
    for characterIdx = 0, self._playerData.useAbleCount - 1 do
      self._ui.list2_Character:requestUpdateByKey(toInt64(0, characterIdx))
    end
    if -1 ~= self._selectedCharIdx then
      local removeTime = getCharacterDataRemoveTime(self._selectedCharIdx, self._isSpecialCharacter)
      if nil ~= removeTime then
        PaGlobal_CharacterSelect_SetUpdateTicketNo(nil, removeTime)
      else
        local characterData = getCharacterDataByIndex(self._selectedCharIdx, self._isSpecialCharacter)
        if nil ~= characterData then
          PaGlobal_CharacterSelect_SetUpdateTicketNo(characterData)
        end
      end
    end
  end
  if false == _animationPlayed then
    _timeElapsed = _timeElapsed + deltaTime
    if _timeElapsed > _animationDelay and false == _listContentsShowAniFlag then
      self:playAnimation()
    end
    if _timeElapsed > 1 then
      _animationPlayed = true
      _allAnimationFinished = true
    end
  end
  if true == _listContentsShowAniFlag then
    self:playListComponentsAni(deltaTime)
  end
  for ii = 0, _listContentsCount do
    if true == _listContentsFlag[ii] then
      self:animateListComponents(deltaTime, ii)
    end
    if true == _listContentsAlphaFlag[ii] then
      self:animateListComponentsAlpha(deltaTime, ii)
    end
  end
end
function CharacterSelectRemaster:playAnimation()
  _listContentsShowAniFlag = true
end
function CharacterSelectRemaster:playListComponentsAni(deltaTime)
  _listContentsLaunchElapsed = _listContentsLaunchElapsed + deltaTime
  local content = _listContents[_listContentsLaunchedCount]
  if self._playerData.useAbleCount <= _listContentsLaunchedCount + 1 or nil == _listContentsLaunchTimeTable[_listContentsLaunchedCount] then
    _listContentsShowAniFlag = false
    for ii = 1, #_listContents do
      _listContents[ii]:SetShow(true)
      _listContentsAlphaFlag[ii] = true
      _listContentsAlphaTarget[ii] = 1
    end
    return
  else
    if nil ~= content and nil ~= content.SetShow and _listContentsLaunchElapsed >= _listContentsLaunchTimeTable[_listContentsLaunchedCount] then
      content:SetShow(true)
      _listContentsAlphaFlag[_listContentsLaunchedCount] = true
      _listContentsAlphaTarget[_listContentsLaunchedCount] = 1
    end
    _listContentsLaunchedCount = _listContentsLaunchedCount + 1
  end
end
function CharacterSelectRemaster:animateListComponents(deltaTime, index)
end
function CharacterSelectRemaster:animateListComponentsAlpha(deltaTime, index)
  local content = _listContents[index]
  if nil == content or nil == _listContentsAlphaTarget[index] then
    return
  end
  local currentAlpha = content:GetAlpha()
  local distance = _listContentsAlphaTarget[index] - currentAlpha
  local acc = distance * deltaTime * 5
  if 0.01 < math.abs(distance) then
    local nextAlpha = currentAlpha + acc
    content:SetAlphaExtraChild(nextAlpha)
    local btnBG = UI.getChildControl(content, "Button_CharacterSlot")
    btnBG:SetAlpha(nextAlpha * 0.7)
    local lockIcon = UI.getChildControl(content, "Static_LockIcon")
    lockIcon:SetAlpha(nextAlpha * 0.5)
    local addIcon = UI.getChildControl(content, "Static_AddIcon")
    addIcon:SetAlpha(nextAlpha * 0.7)
    local channelSelect = UI.getChildControl(content, "Static_SelectGradation")
    channelSelect:SetAlpha(nextAlpha * 0.9)
    local channelSelectYellow = UI.getChildControl(channelSelect, "Static_SelectYellow")
    channelSelectYellow:SetAlpha(nextAlpha * 0.6)
  else
    content:SetAlphaExtraChild(_listContentsAlphaTarget[index])
    _listContentsAlphaFlag[index] = false
    local btnBG = UI.getChildControl(content, "Button_CharacterSlot")
    btnBG:SetAlpha(_listContentsAlphaTarget[index] * 0.7)
    local lockIcon = UI.getChildControl(content, "Static_LockIcon")
    lockIcon:SetAlpha(_listContentsAlphaTarget[index] * 0.5)
    local addIcon = UI.getChildControl(content, "Static_AddIcon")
    addIcon:SetAlpha(_listContentsAlphaTarget[index] * 0.7)
    local channelSelect = UI.getChildControl(content, "Static_SelectGradation")
    channelSelect:SetAlpha(_listContentsAlphaTarget[index] * 0.9)
    local channelSelectYellow = UI.getChildControl(channelSelect, "Static_SelectYellow")
    channelSelectYellow:SetAlpha(_listContentsAlphaTarget[index] * 0.6)
  end
end
function PaGlobal_CharacterSelect_ClickWaitingCancel()
  allClearMessageData()
  if true == self._playerData.isWaitLine then
    sendEnterWaitingCancel()
  end
end
function PaGlobalFunc_CharacterSelectRemaster_Close()
  _panel:SetShow(false)
end
function PaGlobal_CharacterSelect_GetTabState()
  local self = CharacterSelectRemaster
  return self._currentTab
end
function PaGlobal_CharacterSelect_Resize()
  local resizedRatioY = getScreenSizeY() / _panel:GetSizeY()
  _panel:SetSize(getScreenSizeX(), getScreenSizeY())
  self._ui.stc_fade:SetSize(getScreenSizeX(), getScreenSizeY())
  self._ui.stc_rightBg:SetSize(self._ui.stc_rightBg:GetSizeX(), getScreenSizeY())
  self._ui.stc_rightBg:ComputePos()
  self._ui.stc_rightBg:SetPosX(getScreenSizeX() - self._ui.stc_rightBg:GetSizeX())
  self._ui.list2_Character:SetSize(self._ui.list2_Character:GetSizeX(), getScreenSizeY() - 265)
  self._ui.list2_Character:ComputePos()
  self._ui.txt_generalInformation:ComputePos()
  self._ui.btn_deleteCharacter:ComputePos()
  self._ui.chk_characterPosChange:ComputePos()
  self._ui.btn_ExitGame:ComputePos()
  self._ui.stc_offlineModeBG:ComputePos()
  self._ui.btn_ExitToServerSelect:ComputePos()
  self._ui.scroll_Vertical:SetControlPos(0)
end
function PaGlobal_CharacterSelect_Init()
  self:init()
end
PaGlobal_CharacterSelect_Init()
