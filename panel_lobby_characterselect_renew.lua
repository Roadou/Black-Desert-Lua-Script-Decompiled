local _panel = Panel_CharacterSelect_Renew
local UI_Class = CppEnums.ClassType
local ePcWorkingType = CppEnums.PcWorkType
local const_64 = Defines.s64_const
local CharacterSelect = {
  _ui = {
    txt_CharacterSelect = UI.getChildControl(_panel, "StaticText_CharacterSelect"),
    stc_RightBg = UI.getChildControl(_panel, "Static_RightBg")
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
  _keyguideTable = {},
  _selectedCharIdx = -1,
  _prevSelectedCharIdx = -1,
  _currentOveredCharIdx = 0,
  _isSpecialCharacter = false,
  _isCharacterSelected = false,
  _isChangeCharacterLocMode = false,
  _isSelectDeletingChar = false,
  _isBlockSelectCharacter = false
}
function CharacterSelect:init()
  self._ui.txt_FamilyName = UI.getChildControl(self._ui.stc_RightBg, "StaticText_FamilyName")
  self._ui.txt_FamilyNameStr = UI.getChildControl(self._ui.stc_RightBg, "StaticText_FamilyNameStr")
  self._ui.list2_Character = UI.getChildControl(self._ui.stc_RightBg, "List2_Character")
  self._ui.scroll_Vertical = UI.getChildControl(self._ui.list2_Character, "List2_1_VerticalScroll")
  self._ui.list2_Character:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_CharacterSelect_CharacterList_ControlCreate")
  self._ui.list2_Character:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.txt_CharacterSelect:SetText(PAGetString(Defines.StringSheet_RESOURCE, "CHARACTER_SELECT_TXT_TITLE"))
  self._ui.txt_Select_ConsoleUI = UI.getChildControl(self._ui.stc_RightBg, "StaticText_Select_ConsoleUI")
  self._ui.txt_Select_ConsoleUI:SetShow(false)
  self._ui.txt_Delete_ConsoleUI = UI.getChildControl(self._ui.stc_RightBg, "StaticText_Delete_ConsoleUI")
  self._ui.txt_Delete_ConsoleUI:SetShow(false)
  self._ui.txt_DeleteCancel_ConsoleUI = UI.getChildControl(self._ui.stc_RightBg, "StaticText_DeleteCancel_ConsoleUI")
  self._ui.txt_DeleteCancel_ConsoleUI:SetShow(false)
  self._ui.txt_Exit_ConsoleUI = UI.getChildControl(self._ui.stc_RightBg, "StaticText_Exit_ConsoleUI")
  self._ui.txt_ChangeMode_ConsoleUI = UI.getChildControl(self._ui.stc_RightBg, "StaticText_ChangeSlotLocation_ConsoleUI")
  self._ui.txt_ChangeMode_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERSELECT_CHANGELOCATION"))
  self._ui.txt_ChangeMode_ConsoleUI:SetShow(true)
  self._ui.txt_ChangeMode_LB_ConsoleUI = UI.getChildControl(self._ui.stc_RightBg, "StaticText_ChangeSlotLocation_LB_ConsoleUI")
  self._ui.txt_ChangeMode_LB_ConsoleUI:SetShow(false)
  self._ui.txt_ChangeMode_RB_ConsoleUI = UI.getChildControl(self._ui.stc_RightBg, "StaticText_ChangeSlotLocation_RB_ConsoleUI")
  self._ui.txt_ChangeMode_RB_ConsoleUI:SetShow(false)
  if true == ToClient_IsDevelopment() then
    self._ui.txt_Select_ConsoleUI:SetIgnore(false)
    self._ui.txt_Delete_ConsoleUI:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_DeleteCharacter()")
    self._ui.txt_Delete_ConsoleUI:SetIgnore(false)
  end
  self._isChangeCharacterLocMode = false
  self:registEventHandler()
  PaGlobal_CheckGamerTag()
  local txt_version = UI.getChildControl(_panel, "StaticText_VersionString")
  txt_version:SetText("ver." .. tostring(ToClient_getVersionString()))
  self:SetKeyGuidePos()
  PaGlobalFunc_ConsoleKeyGuide_SetAlign({
    self._ui.txt_Exit_ConsoleUI
  }, self._ui.stc_RightBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign({
    self._ui.txt_ChangeMode_ConsoleUI
  }, self._ui.stc_RightBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function CharacterSelect:close()
  _panel:SetShow(false)
end
function CharacterSelect:open()
  _panel:SetShow(true)
end
function CharacterSelect:updateData(isChangeSpecialTab)
  local isSpecialCharacter = false
  self._isSpecialCharacter = isSpecialCharacter
  self._playerData.maxSlot = self:getCharacterMaxSlotData(isSpecialCharacter)
  self._playerData.haveCount = getCharacterDataCount(isSpecialCharacter)
  self._playerData.useAbleCount = getCharacterSlotLimit(isSpecialCharacter)
  self._ui.txt_FamilyName:SetText(getFamilyName())
  self._ui.txt_FamilyNameStr:SetText(" (" .. self._playerData.haveCount .. "/" .. self._playerData.useAbleCount .. ")")
  self._ui.list2_Character:getElementManager():clearKey()
  for characterIdx = 0, self._playerData.useAbleCount - 1 do
    self._ui.list2_Character:getElementManager():pushKey(toInt64(0, characterIdx))
  end
end
function CharacterSelect:getCharacterMaxSlotData(isCharacterSpecial)
  local maxcount = 0
  if getCharacterDataCount(isCharacterSpecial) <= getCharacterSlotMaxCount(isCharacterSpecial) then
    maxcount = getCharacterSlotLimit(isCharacterSpecial) + 1
  else
    maxcount = getCharacterDataCount(isCharacterSpecial)
  end
  return maxcount
end
function CharacterSelect:SetKeyGuidePos()
  if true == self._isChangeCharacterLocMode then
    local keyguideChangeModeOnTable = {
      self._ui.txt_ChangeMode_RB_ConsoleUI,
      self._ui.txt_Select_ConsoleUI
    }
    self._ui.txt_ChangeMode_LB_ConsoleUI:SetPosY(self._ui.txt_Select_ConsoleUI:GetPosY())
    self._ui.txt_ChangeMode_RB_ConsoleUI:SetPosY(self._ui.txt_Select_ConsoleUI:GetPosY())
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyguideChangeModeOnTable, self._ui.stc_RightBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign({
      self._ui.txt_ChangeMode_ConsoleUI
    }, self._ui.stc_RightBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
    self._ui.txt_ChangeMode_LB_ConsoleUI:SetPosX(self._ui.txt_ChangeMode_RB_ConsoleUI:GetPosX() - self._ui.txt_ChangeMode_LB_ConsoleUI:GetSizeX())
  else
    local keyguideChangeModeOffTable = {
      self._ui.txt_Select_ConsoleUI,
      self._ui.txt_Delete_ConsoleUI,
      self._ui.txt_DeleteCancel_ConsoleUI
    }
    self._ui.txt_Select_ConsoleUI:SetPosY(self._ui.txt_Delete_ConsoleUI:GetPosY())
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyguideChangeModeOffTable, self._ui.stc_RightBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  end
end
function CharacterSelect:characterView(index, classType, isSpecialCharacter, isChangeSpecialTab)
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
    viewCharacter(index, -20, -58, -164, -0.1, isSpecialCharacter, isChangeSpecialTab)
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
    setWeatherTime(8, 2)
    viewCharacterFov(0.55)
  elseif classType == UI_Class.ClassType_Orange then
    viewCharacter(index, -20, -30, -94, -0.4, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(0, 0)
    viewCharacterFov(0.8)
    setWeatherTime(8, 1)
  else
    viewCharacter(index, 0, 0, 0, 0, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(3.14, 0)
  end
end
function CharacterSelect:changeTexture_Class(control, classType)
  if classType == UI_Class.ClassType_Warrior then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 172, 57, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_Ranger then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 58, 172, 114, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_Sorcerer then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 115, 172, 171, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_Giant then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 172, 172, 228, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_Tamer then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 229, 172, 285, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_BladeMaster then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 286, 172, 342, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_BladeMasterWomen then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 400, 172, 456, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_Valkyrie then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 343, 172, 399, 228)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_Wizard then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 229, 57, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_WizardWomen then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 58, 229, 114, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_NinjaWomen then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 115, 229, 171, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_NinjaMan then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 172, 229, 228, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_ShyWomen then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 58, 115, 114, 171)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_DarkElf then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 229, 229, 285, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_Combattant then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 286, 229, 342, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_CombattantWomen then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 343, 229, 399, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif classType == UI_Class.ClassType_Lahn then
    control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 400, 229, 456, 285)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  else
    if classType == UI_Class.ClassType_Orange then
      control:ChangeTextureInfoName("renewal/ui_icon/console_classsymbol.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 286, 57, 342)
      control:getBaseTexture():setUV(x1, y1, x2, y2)
      control:setRenderTexture(control:getBaseTexture())
    else
    end
  end
end
function PaGlobal_CharacterSelect_CharacterList_ControlCreate(content, key)
  local self = CharacterSelect
  local characterIdx = Int64toInt32(key)
  local isSpecialCharacter = self._isSpecialCharacter
  local Btn_CharSlot = UI.getChildControl(content, "Button_CharacterSlot")
  local stc_ClasIcon = UI.getChildControl(content, "Static_ClassIcon")
  local txt_Level = UI.getChildControl(content, "StaticText_Lv")
  local txt_Name = UI.getChildControl(content, "StaticText_Name")
  local txt_Region = UI.getChildControl(content, "StaticText_Region")
  local txt_Delete = UI.getChildControl(content, "StaticText_Delete")
  local stc_AddIcon = UI.getChildControl(content, "Static_AddIcon")
  local stc_LockIcon = UI.getChildControl(content, "Static_LockIcon")
  local stc_Selected = UI.getChildControl(content, "Static_SelectedSlot")
  Btn_CharSlot:SetShow(false)
  stc_ClasIcon:SetShow(false)
  txt_Level:SetShow(false)
  txt_Name:SetShow(false)
  txt_Region:SetShow(false)
  txt_Delete:SetShow(false)
  stc_AddIcon:SetShow(false)
  stc_LockIcon:SetShow(false)
  stc_Selected:SetShow(false)
  txt_Region:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
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
      if 0 ~= characterData._currentPosition.x and 0 ~= characterData._currentPosition.y and 0 ~= characterData._currentPosition.z then
        if 0 ~= pcDeliveryRegionKey:get() and serverUtc64 > characterData._arrivalTime then
          regionInfo = getRegionInfoByRegionKey(pcDeliveryRegionKey)
          local retionInfoArrival = getRegionInfoByRegionKey(pcDeliveryRegionKey)
          whereIs = retionInfoArrival:getAreaName()
        elseif serverUtc64 < characterData._arrivalTime then
          local remainTime = characterData._arrivalTime - serverUtc64
          local strTime = convertStringFromDatetime(remainTime)
          whereIs = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_DELIVERY") .. " : " .. strTime
        else
          regionInfo = getRegionInfoByPosition(characterData._currentPosition)
          whereIs = regionInfo:getAreaName()
        end
      end
      self:changeTexture_Class(stc_ClasIcon, classType)
      if characterIdx == self._selectedCharIdx then
        stc_Selected:SetShow(true)
      else
        stc_Selected:SetShow(false)
      end
      txt_Name:SetText(characterName)
      txt_Level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. ". " .. characterLevel)
      local removeTime = getCharacterDataRemoveTime(characterIdx, isSpecialCharacter)
      if nil ~= removeTime then
        txt_Delete:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_DeleteCancelCharacter(" .. characterIdx .. " )")
        txt_Delete:SetIgnore(false)
        txt_Delete:SetShow(true)
      else
        txt_Region:SetText(whereIs)
        txt_Region:SetShow(true)
      end
      _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "InputX_CharacterSelect_ChangeCharacterLocation()")
      Btn_CharSlot:registerPadEvent(__eConsoleUIPadEvent_LB, "InputMLUp_CharacterSelect_ChangeSlotPosition(" .. characterIdx .. ", true)")
      Btn_CharSlot:registerPadEvent(__eConsoleUIPadEvent_RB, "InputMLUp_CharacterSelect_ChangeSlotPosition(" .. characterIdx .. ", false)")
      Btn_CharSlot:addInputEvent("Mouse_On", "InputMO_CharacterSelect_SaveCurrentIdx(" .. characterIdx .. " )")
      Btn_CharSlot:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_SelectCharacterWithSavedIdx(" .. characterIdx .. ")")
      Btn_CharSlot:SetIgnore(false)
      PaGlobal_CharacterSelect_SetUpdateTicketNo(characterData)
      Btn_CharSlot:SetShow(true)
      stc_ClasIcon:SetShow(true)
      txt_Level:SetShow(true)
      txt_Name:SetShow(true)
    else
    end
  elseif characterIdx == self._playerData.haveCount then
    Btn_CharSlot:SetIgnore(false)
    stc_AddIcon:SetShow(true)
    Btn_CharSlot:SetShow(true)
    Btn_CharSlot:addInputEvent("Mouse_LUp", "InputMLUp_CharacterSelect_CreateCharacter()")
    Btn_CharSlot:addInputEvent("Mouse_On", "InputMO_CharacterSelect_CharacterCreate()")
  else
    stc_LockIcon:SetAlpha(0.4)
    Btn_CharSlot:SetIgnore(false)
    stc_LockIcon:SetShow(true)
    Btn_CharSlot:SetShow(true)
    Btn_CharSlot:addInputEvent("Mouse_On", "InputMO_CharacterSelect_LockedCharacterSlot()")
  end
  content:ComputePos()
end
function PaGlobal_CharacterSelect_BackToServerSelect()
  local self = CharacterSelect
  if true == self._isBlockSelectCharacter then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BUILDING_WORKMANAGER_BTN_FINISHEDWORK"))
    return
  end
  self:close()
  backServerSelect()
end
function PaGlobal_CharacterSelect_Close()
  local self = CharacterSelect
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  self:close()
end
function PaGlobal_CharacterSelect_Open(charIdx)
  local self = CharacterSelect
  self:close()
  if true == _ContentsGroup_RenewUI_Customization then
    PaGlobalFunc_Customization_Close()
    PaGlobalFunc_Customization_InputName_ForcedClose()
  end
  local isRefresh = false
  if -1 == charIdx or charIdx >= self._playerData.haveCount then
    self._selectedCharIdx = 0
  elseif -2 == charIdx then
    self._selectedCharIdx = self._selectedCharIdx
    isRefresh = true
  else
    self._selectedCharIdx = charIdx
  end
  self._isBlockSelectCharacter = false
  self:updateData(false)
  self:open()
  PaGlobal_CharacterSelect_SelectCharacter(self._selectedCharIdx, isRefresh)
  PaGlobal_CharacterSelect_Resize()
end
function PaGlobal_CharacterSelect_SelectCharacter(charIdx, isRefresh)
  local self = CharacterSelect
  local isSpecialCharacter = self._isSpecialCharacter
  local characterData = getCharacterDataByIndex(charIdx, isSpecialCharacter)
  if nil == isRefresh then
    isRefresh = false
  end
  self._ui.txt_Select_ConsoleUI:SetShow(false)
  self._ui.txt_Delete_ConsoleUI:SetShow(false)
  self._ui.txt_DeleteCancel_ConsoleUI:SetShow(false)
  if nil ~= characterData then
    local classType = getCharacterClassType(characterData)
    local removeTime = getCharacterDataRemoveTime(charIdx, isSpecialCharacter)
    if false == self._isChangeCharacterLocMode then
      if nil ~= removeTime then
        self._isSelectDeletingChar = true
        self._ui.txt_DeleteCancel_ConsoleUI:SetShow(true)
      else
        self._isSelectDeletingChar = false
        self._ui.txt_Select_ConsoleUI:SetShow(true)
        self._ui.txt_Delete_ConsoleUI:SetShow(true)
      end
    end
    self._prevSelectedCharIdx = self._selectedCharIdx
    self._selectedCharIdx = charIdx
    self._ui.list2_Character:requestUpdateByKey(toInt64(0, self._prevSelectedCharIdx))
    self._ui.list2_Character:requestUpdateByKey(toInt64(0, self._selectedCharIdx))
    if true ~= isRefresh or true ~= self._playerData.isWaitLine then
      self:characterView(self._selectedCharIdx, classType, isSpecialCharacter, false)
    end
  end
  self:SetKeyGuidePos()
end
function InputMLUp_CharacterSelect_CreateCharacter()
  if Panel_Win_System:GetShow() then
    return
  end
  local self = CharacterSelect
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
  local self = CharacterSelect
  local isSpecialCharacter = self._isSpecialCharacter
  if -1 ~= self._selectedCharIdx then
    local characterData = getCharacterDataByIndex(self._selectedCharIdx, isSpecialCharacter)
    if nil == characterData then
      return
    end
    local function do_Delete()
      self._isBlockSelectCharacter = true
      _AudioPostEvent_SystemUiForXBOX(50, 1)
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
    local remainTime = convertStringFromDatetime(toInt64(0, characterNameRestoreTime))
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
function InputMLUp_CharacterSelect_DeleteCancelCharacter()
  local self = CharacterSelect
  local isSpecialCharacter = self._isSpecialCharacter
  if -1 ~= self._selectedCharIdx then
    deleteCancelCharacter(self._selectedCharIdx, isSpecialCharacter)
  end
end
function InputMLUp_CharacterSelect_PlayGame()
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
  local self = CharacterSelect
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
  local characterData = getCharacterDataByIndex(self._selectedCharIdx, isSpecialCharacter)
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
        FGlobal_FirstLogin_Open(self._selectedCharIdx)
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
          local messageboxData = {
            title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
            content = contentString,
            functionYes = PaGlobal_CharacterSelect_SelectEnterToGame,
            functionCancel = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageboxData)
        elseif ToClient_IsCustomizeOnlyClass(classType) then
          local messageboxData = {
            title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
            content = PAGetString(Defines.StringSheet_GAME, "LUA_LOBBY_SELECTCHARACTER_CUSTOMIZEONLYCLASS_MEMO"),
            functionApply = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageboxData)
        else
          self._isBlockSelectCharacter = true
          if true == selectCharacter(self._selectedCharIdx, isSpecialCharacter) then
          end
        end
      end
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
function InputMO_CharacterSelect_SaveCurrentIdx(index)
  local self = CharacterSelect
  self._currentOveredCharIdx = index
  if true == self._isChangeCharacterLocMode then
    PaGlobal_CharacterSelect_ChangeCharacterLocModeOn()
  else
    self._ui.txt_Select_ConsoleUI:SetShow(false)
    if self._currentOveredCharIdx == self._selectedCharIdx then
      self._isCharacterSelected = true
      self._ui.txt_Select_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "CHARACTER_SELECT_BTN_CONNECT"))
      if true == self._isSelectDeletingChar then
        self._ui.txt_Select_ConsoleUI:SetShow(false)
        self._ui.txt_Delete_ConsoleUI:SetShow(false)
        self._ui.txt_DeleteCancel_ConsoleUI:SetShow(true)
        _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "InputMLUp_CharacterSelect_DeleteCancelCharacter()")
      else
        self._ui.txt_Select_ConsoleUI:SetShow(true)
        self._ui.txt_Delete_ConsoleUI:SetShow(true)
        self._ui.txt_DeleteCancel_ConsoleUI:SetShow(false)
        _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "InputMLUp_CharacterSelect_DeleteCharacter()")
      end
    else
      self._isCharacterSelected = false
      self._ui.txt_Select_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_EXCHANGE_SELECT"))
      self._ui.txt_Select_ConsoleUI:SetShow(true)
      self._ui.txt_DeleteCancel_ConsoleUI:SetShow(false)
      self._ui.txt_Delete_ConsoleUI:SetShow(false)
      _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
    end
  end
  self:SetKeyGuidePos()
end
function InputMO_CharacterSelect_CharacterCreate()
  local self = CharacterSelect
  self._isCharacterSelected = false
  self._ui.txt_Select_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LOBBY_SELECTCLASS_CREATE"))
  self._ui.txt_Select_ConsoleUI:SetShow(true)
  self._ui.txt_Delete_ConsoleUI:SetShow(false)
  self._ui.txt_DeleteCancel_ConsoleUI:SetShow(false)
  self._ui.txt_ChangeMode_LB_ConsoleUI:SetShow(false)
  self._ui.txt_ChangeMode_RB_ConsoleUI:SetShow(false)
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
  self:SetKeyGuidePos()
end
function InputMO_CharacterSelect_LockedCharacterSlot()
  local self = CharacterSelect
  self._isCharacterSelected = false
  self._ui.txt_Select_ConsoleUI:SetShow(false)
  self._ui.txt_Delete_ConsoleUI:SetShow(false)
  self._ui.txt_DeleteCancel_ConsoleUI:SetShow(false)
  self._ui.txt_ChangeMode_LB_ConsoleUI:SetShow(false)
  self._ui.txt_ChangeMode_RB_ConsoleUI:SetShow(false)
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
  self:SetKeyGuidePos()
end
function InputMLUp_CharacterSelect_SelectCharacterWithSavedIdx()
  local self = CharacterSelect
  if true == self._isBlockSelectCharacter then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BUILDING_WORKMANAGER_BTN_FINISHEDWORK"))
    return
  end
  if true == self._isChangeCharacterLocMode then
    self._isCharacterSelected = false
  end
  if true == self._isCharacterSelected then
    if true == self._isSelectDeletingChar then
      return
    end
    _AudioPostEvent_SystemUiForXBOX(50, 8)
    InputMLUp_CharacterSelect_PlayGame()
  else
    PaGlobal_CharacterSelect_SelectCharacter(self._currentOveredCharIdx)
    self._isCharacterSelected = true
    self._ui.txt_Select_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "CHARACTER_SELECT_BTN_CONNECT"))
    _AudioPostEvent_SystemUiForXBOX(50, 1)
  end
  self:SetKeyGuidePos()
end
function PaGlobal_CharacterSelect_ChangeCharacterLocModeOn()
  local self = CharacterSelect
  if false == self._isChangeCharacterLocMode then
    return
  end
  if self._currentOveredCharIdx == self._selectedCharIdx then
    self._ui.txt_Select_ConsoleUI:SetShow(false)
  else
    self._ui.txt_Select_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_EXCHANGE_SELECT"))
    self._ui.txt_Select_ConsoleUI:SetShow(true)
  end
  self._ui.txt_Exit_ConsoleUI:SetShow(true)
  self._ui.txt_ChangeMode_LB_ConsoleUI:SetShow(true)
  self._ui.txt_ChangeMode_RB_ConsoleUI:SetShow(true)
  self._ui.txt_Delete_ConsoleUI:SetShow(false)
  self._ui.txt_DeleteCancel_ConsoleUI:SetShow(false)
  self._ui.txt_ChangeMode_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERSELECT_CHANGECOMPLETE"))
  self._ui.txt_CharacterSelect:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERSELECT_CHANGELOCATION"))
  self:SetKeyGuidePos()
  self:updateData(false)
end
function PaGlobal_CharacterSelect_ChangeCharacterLocModeOff()
  local self = CharacterSelect
  PaGlobal_CharacterSelect_Init()
  PaGlobal_CharacterSelect_Open(self._selectedCharIdx)
end
function InputMLUp_CharacterSelect_ChangeSlotPosition(index, isUp)
  local self = CharacterSelect
  if nil == index and nil == isUp then
    return
  end
  if false == self._isChangeCharacterLocMode then
    return
  end
  if true == isUp then
    if 0 == self._selectedCharIdx and index == self._selectedCharIdx or 0 == index then
      return
    end
    if self._selectedCharIdx == index then
      self._selectedCharIdx = self._selectedCharIdx - 1
    elseif self._selectedCharIdx == index - 1 then
      self._selectedCharIdx = index
    end
  else
    if self._playerData.haveCount - 1 == self._selectedCharIdx and index == self._selectedCharIdx or self._playerData.haveCount - 1 == index then
      return
    end
    if self._selectedCharIdx == index then
      self._selectedCharIdx = self._selectedCharIdx + 1
    elseif self._selectedCharIdx == index + 1 then
      self._selectedCharIdx = index
    end
  end
  ToClient_ChangeCharacterListOrder(index, isUp)
  ToClient_SaveClientCacheData()
  PaGlobal_CharacterSelect_SelectCharacter(self._selectedCharIdx)
  self:updateData(false)
end
function InputX_CharacterSelect_ChangeCharacterLocation()
  local self = CharacterSelect
  if true == self._isChangeCharacterLocMode then
    PaGlobal_CharacterSelect_ChangeCharacterLocModeOff()
    return
  end
  self._isChangeCharacterLocMode = true
  PaGlobal_CharacterSelect_ChangeCharacterLocModeOn()
  self:updateData(false)
end
function PaGlobal_CharacterSelect_SelectEnterToGame()
  local self = CharacterSelect
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
      self._isBlockSelectCharacter = true
      selectCharacter(self._selectedCharIdx, isSpecialCharacter)
    end
  end
end
function PaGlobal_CharacterSelect_SetUpdateTicketNo(characterData)
  local firstTicketNo = getFirstTicketNoByAll()
  local currentTicketNo = getCurrentTicketNo()
  local ticketCountByRegion = characterData._lastTicketNoByRegion
  local myRegionWaitingPlayerCount = currentTicketNo - ticketCountByRegion
  local serverPlayingCount = currentTicketNo - firstTicketNo
  local classType = getCharacterClassType(characterData)
  local isPossibleClass = ToClient_IsCustomizeOnlyClass(classType)
  local self = CharacterSelect
end
function PaGlobal_CharacterSelect_CancelWaitingLine()
  local self = CharacterSelect
  if true == self._playerData.isWaitLine then
    MessageBox_HideAni()
    self._playerData.isWaitLine = false
    self._isBlockSelectCharacter = false
  end
end
function PaGlobal_CharacterSelect_ReceiveWaiting()
  local self = CharacterSelect
  local isSpecialCharacter = self._isSpecialCharacter
  self._playerData.isWaitLine = true
  local characterData = getCharacterDataByIndex(self._selectedCharIdx, isSpecialCharacter)
  if nil == characterData then
    UI.ASSERT(false, "\236\186\144\235\166\173\237\132\176 \236\132\160\237\131\157 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164!")
    return
  end
  local strWaitingMsg = PaGlobal_CharacterSelect_MakeWaitingUserMsg(characterData._lastTicketNoByRegion)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "CHARACTER_ENTER_WAITING_TITLE"),
    content = strWaitingMsg,
    functionCancel = PaGlobal_CharacterSelect_CancelWait,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1m,
    enablePriority = true
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobal_CharacterSelect_CancelWait()
  local self = CharacterSelect
  allClearMessageData()
  if true == self._playerData.isWaitLine then
    sendEnterWaitingCancel()
  end
end
function PaGlobal_CharacterSelect_SetWaitingUserCount()
  local self = CharacterSelect
  if false == self._playerData.isWaitLine then
    return
  end
  local strWaitingMsg = PaGlobal_CharacterSelect_MakeWaitingUserMsg(-1)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "CHARACTER_ENTER_WAITING_TITLE"),
    content = strWaitingMsg,
    functionCancel = PaGlobal_CharacterSelect_CancelWait,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1m,
    enablePriority = true
  }
  if true == MessageBox.doHaveMessageBoxData(messageboxData.title) then
    setCurrentMessageData(messageboxData)
  else
    MessageBox.showMessageBox(messageboxData)
  end
end
function PaGlobal_CharacterSelect_MakeWaitingUserMsg(receiveTicketNoMyRegion)
  local self = CharacterSelect
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
function PaGlobal_CharacterSelect_Resize()
  if false == Panel_CharacterSelect_Renew:IsShow() then
    return
  end
  local resizedRatioY = getScreenSizeY() / Panel_CharacterSelect_Renew:GetSizeY()
  local self = CharacterSelect
  Panel_CharacterSelect_Renew:SetSize(getScreenSizeX(), getScreenSizeY())
  self._ui.stc_RightBg:SetSize(self._ui.stc_RightBg:GetSizeX(), getScreenSizeY())
  self._ui.stc_RightBg:SetPosX(getScreenSizeX() - self._ui.stc_RightBg:GetSizeX())
  self._ui.list2_Character:SetSize(self._ui.list2_Character:GetSizeX(), self._ui.list2_Character:GetSizeY() * resizedRatioY)
  self._ui.txt_Select_ConsoleUI:SetPosY(self._ui.txt_Select_ConsoleUI:GetPosY() * resizedRatioY)
  self._ui.txt_Delete_ConsoleUI:SetPosY(self._ui.txt_Delete_ConsoleUI:GetPosY() * resizedRatioY)
  self._ui.txt_DeleteCancel_ConsoleUI:SetPosY(self._ui.txt_DeleteCancel_ConsoleUI:GetPosY() * resizedRatioY)
  self._ui.txt_Exit_ConsoleUI:SetPosY(self._ui.txt_Exit_ConsoleUI:GetPosY() * resizedRatioY)
  self._ui.txt_ChangeMode_ConsoleUI:SetPosY(self._ui.txt_ChangeMode_ConsoleUI:GetPosY() * resizedRatioY)
  self._ui.scroll_Vertical:SetControlPos(0)
  self:SetKeyGuidePos()
  Panel_CharacterSelect_Renew:ComputePos()
end
function PaGlobal_CharacterSelect_SetBlockSelectFalse()
  local self = CharacterSelect
  self._isBlockSelectCharacter = false
end
function PaGlobal_CharacterSelect_Init()
  local self = CharacterSelect
  self:init()
end
function CharacterSelect:registEventHandler()
  registerEvent("EventChangeLobbyStageToCharacterSelect", "PaGlobal_CharacterSelect_Open")
  registerEvent("EventCancelEnterWating", "PaGlobal_CharacterSelect_CancelWaitingLine")
  registerEvent("EventReceiveEnterWating", "PaGlobal_CharacterSelect_ReceiveWaiting")
  registerEvent("EventSetEnterWating", "PaGlobal_CharacterSelect_SetWaitingUserCount")
end
PaGlobal_CharacterSelect_Init()
