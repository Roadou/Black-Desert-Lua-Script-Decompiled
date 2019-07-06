local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local ePcWorkingType = CppEnums.PcWorkType
local UI_Class = CppEnums.ClassType
local const_64 = Defines.s64_const
local UCT_BUTTON = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON
local UCT_RADIOBUTTON = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON
local UCT_STATICTEXT = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT
local UCT_STATIC = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC
local isSpecialCharacterOpen = ToClient_IsContentsGroupOpen("281")
local CharacterListIndex = 0
local SpecialCharacterListIndex = 1
local isChangeCharacterTab = false
local isGhostMode = false
Panel_CharacterSelectNew:SetShow(false)
local SelectCharacter = {
  btn_CharacterSlot = UI.getChildControl(Panel_CharacterSelectNew, "Button_Character0"),
  static_PenelBG = UI.getChildControl(Panel_CharacterSelectNew, "Static_BG"),
  static_FamilyName = UI.getChildControl(Panel_CharacterSelectNew, "FamilyName"),
  btn_ServerSelect = UI.getChildControl(Panel_CharacterSelectNew, "Button_BackServerSelect"),
  btn_EndGame = UI.getChildControl(Panel_CharacterSelectNew, "Button_EndGame"),
  btn_ChangeLocate = UI.getChildControl(Panel_CharacterSelectNew, "CheckButton_CharacterLocateChange"),
  btn_DeleteCancel = UI.getChildControl(Panel_CharacterSelectNew, "Button_CharacterDeleteCancel"),
  bottomDeco_Left = UI.getChildControl(Panel_CharacterSelectNew, "Static_BottomDeco_Left"),
  bottomDeco_Right = UI.getChildControl(Panel_CharacterSelectNew, "Static_BottomDeco_Right"),
  btn_ChaInfoDelete = UI.getChildControl(Panel_CharacterSelectNew, "Button_DeleteCharacter"),
  _scroll = UI.getChildControl(Panel_CharacterSelectNew, "Scroll_SlotList"),
  btn_Link1 = UI.getChildControl(Panel_CharacterSelectNew, "Button_Link1"),
  btn_Link2 = UI.getChildControl(Panel_CharacterSelectNew, "Button_Link2"),
  block_BG = UI.getChildControl(Panel_CharacterSelectNew, "Static_block_BG"),
  radioBtnBG = UI.getChildControl(Panel_CharacterSelectNew, "Static_RadioBtnBg"),
  radioBtn_CharacterList = UI.getChildControl(Panel_CharacterSelectNew, "RadioButton_Tab_CharacterList"),
  radioBtn_SpecialCharacterList = UI.getChildControl(Panel_CharacterSelectNew, "RadioButton_Tab_SpecialCharacterList"),
  keyGuide = UI.getChildControl(Panel_CharacterSelectNew, "Static_KeyGuideBg"),
  premiumPcRoomSizeY = 0
}
SelectCharacter._ScrollBtn = UI.getChildControl(SelectCharacter._scroll, "Scroll_CtrlButton")
local btn_SaveCustomization = UI.getChildControl(Panel_CharacterSelectNew, "Button_LoadCustomization")
btn_SaveCustomization:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERCREATION_MAIN_BUTTON_SAVECUSTOMIZATION"))
btn_SaveCustomization:addInputEvent("Mouse_LUp", "HandleClicked_SaveCustomizationFile()")
local configData = {
  maxSlot = 0,
  maxCountSlot = 0,
  maxScrollCount = 0,
  freeCount = 0,
  haveCount = 0,
  useAbleCount = 0,
  _startIndex = 0,
  _listCount = 9,
  _initList = 12,
  selectCaracterIdx = -1,
  isWaitLine = false,
  slotUiPool = {}
}
local getCharacterMaxSlotData = function(isCharacterSpecial)
  local maxcount = 0
  if getCharacterDataCount(isCharacterSpecial) <= getCharacterSlotMaxCount(isCharacterSpecial) then
    maxcount = getCharacterSlotLimit(isCharacterSpecial) + 1
  else
    maxcount = getCharacterDataCount(isCharacterSpecial)
  end
  return maxcount
end
local getMaxCharacsterCount = function(isCharacterSpecial)
  local characterMaxCount = 0
  local scrSizeY = getScreenSizeY()
  if getCharacterDataCount(isCharacterSpecial) < getCharacterSlotMaxCount(isCharacterSpecial) then
    characterMaxCount = getCharacterSlotMaxCount(isCharacterSpecial)
  else
    characterMaxCount = getCharacterDataCount(isCharacterSpecial)
  end
  return characterMaxCount
end
local function SelectCharacter_Init()
  setShowBlockBG(false)
  Panel_CharacterSelectNew:SetShow(true)
  Panel_CharacterSelectNew:SetSize(getScreenSizeX(), getScreenSizeY())
  if isGameTypeEnglish() and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_Pre then
    btn_SaveCustomization:SetShow(true)
  else
    btn_SaveCustomization:SetShow(false)
  end
  SelectCharacter.radioBtn_CharacterList:addInputEvent("Mouse_LUp", "RadioButton_Click( 0 )")
  SelectCharacter.radioBtn_SpecialCharacterList:addInputEvent("Mouse_LUp", "RadioButton_Click( 1 )")
  SelectCharacter.static_PenelBG:AddChild(SelectCharacter.btn_ServerSelect)
  SelectCharacter.static_PenelBG:AddChild(SelectCharacter.btn_EndGame)
  SelectCharacter.static_PenelBG:AddChild(SelectCharacter.btn_ChangeLocate)
  SelectCharacter.static_PenelBG:AddChild(SelectCharacter.static_FamilyName)
  SelectCharacter.static_PenelBG:AddChild(SelectCharacter.btn_ChaInfoDelete)
  SelectCharacter.static_PenelBG:AddChild(SelectCharacter.bottomDeco_Left)
  SelectCharacter.static_PenelBG:AddChild(SelectCharacter.bottomDeco_Right)
  Panel_CharacterSelectNew:RemoveControl(SelectCharacter.btn_ServerSelect)
  Panel_CharacterSelectNew:RemoveControl(SelectCharacter.btn_EndGame)
  Panel_CharacterSelectNew:RemoveControl(SelectCharacter.btn_ChangeLocate)
  Panel_CharacterSelectNew:RemoveControl(SelectCharacter.static_FamilyName)
  Panel_CharacterSelectNew:RemoveControl(SelectCharacter.btn_ChaInfoDelete)
  Panel_CharacterSelectNew:RemoveControl(SelectCharacter.bottomDeco_Left)
  Panel_CharacterSelectNew:RemoveControl(SelectCharacter.bottomDeco_Right)
  SelectCharacter.static_PenelBG:SetSize(SelectCharacter.static_PenelBG:GetSizeX(), getScreenSizeY())
  SelectCharacter.static_PenelBG:ComputePos()
  SelectCharacter.static_FamilyName:ComputePos()
  SelectCharacter.btn_ServerSelect:ComputePos()
  SelectCharacter.btn_EndGame:ComputePos()
  SelectCharacter.btn_ChangeLocate:ComputePos()
  SelectCharacter.btn_ChaInfoDelete:ComputePos()
  SelectCharacter.bottomDeco_Left:ComputePos()
  SelectCharacter.bottomDeco_Right:ComputePos()
  SelectCharacter._scroll:ComputePos()
  SelectCharacter.btn_ServerSelect:addInputEvent("Mouse_LUp", "CharacterSelect_Back()")
  SelectCharacter.btn_EndGame:addInputEvent("Mouse_LUp", "CharacterSelect_ExitGame()")
  SelectCharacter.btn_ChangeLocate:addInputEvent("Mouse_LUp", "CharacterSelect_ChangeLocate()")
  SelectCharacter.btn_ChaInfoDelete:addInputEvent("Mouse_LUp", "CharacterSelect_DeleteCharacter()")
  local self = SelectCharacter
  if true == isSpecialCharacterOpen then
    SelectCharacter.radioBtn_CharacterList:SetShow(true)
    SelectCharacter.radioBtn_SpecialCharacterList:SetShow(true)
    SelectCharacter.radioBtnBG:SetShow(true)
  else
    SelectCharacter.radioBtn_CharacterList:SetShow(false)
    SelectCharacter.radioBtn_SpecialCharacterList:SetShow(false)
  end
  local scrSizeY = getScreenSizeY()
  local scrSizeSumY = scrSizeY - SelectCharacter.static_FamilyName:GetSizeY() - SelectCharacter.btn_EndGame:GetSizeY() - SelectCharacter.btn_ChangeLocate:GetSizeY() - 25 - self.premiumPcRoomSizeY - 35
  local btnSizeY = SelectCharacter.btn_CharacterSlot:GetSizeY()
  local _btnCount = math.floor(scrSizeSumY / btnSizeY)
  SelectCharacter._scroll:SetSize(SelectCharacter._scroll:GetSizeX(), btnSizeY * _btnCount - self.premiumPcRoomSizeY)
  configData._listCount = _btnCount
  for slotIdx = 0, configData._listCount - 1 do
    local slot = {}
    slot._btn_Slot = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "Button_CreateSlot", self.static_PenelBG, "SelectCharacter_EmptySlot_" .. slotIdx)
    slot._ClassIcon = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "StaticText_ClassIcon", slot._btn_Slot, "SelectCharacter_ClassIcon_" .. slotIdx)
    slot._ChaStat = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "StaticText_Character0", slot._btn_Slot, "SelectCharacter_ChaStat_" .. slotIdx)
    slot._ContStat = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "StaticText_UserCount", slot._btn_Slot, "SelectCharacter_ContStat_" .. slotIdx)
    slot._ChaLev = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "StaticText_CharLevel", slot._btn_Slot, "SelectCharacter_ChaLev_" .. slotIdx)
    slot._Status = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "StaticText_CharacterStatus", slot._btn_Slot, "SelectCharacter_Status_" .. slotIdx)
    slot._btnCreate = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "Button_CharacterCreate", slot._btn_Slot, "SelectCharacter_btnCreate_" .. slotIdx)
    slot._btnStart = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "Button_Start", slot._btn_Slot, "SelectCharacter_btnStart_" .. slotIdx)
    slot._btnDelCancel = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "Button_CharacterDeleteCancel", slot._btn_Slot, "SelectCharacter_btnDeleteCancel_" .. slotIdx)
    slot._btnUp = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "Button_Up", slot._btn_Slot, "SelectCharacter_btnUp_" .. slotIdx)
    slot._btnDown = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "Button_Down", slot._btn_Slot, "SelectCharacter_btnDown_" .. slotIdx)
    slot._possibleStat = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "StaticText_PossibleEnter", slot._btn_Slot, "SelectCharacter_PossibleEnter_" .. slotIdx)
    slot._btn_Slot:SetText("")
    slot._btn_Slot:SetPosX(12)
    slot._btn_Slot:SetPosY(SelectCharacter.static_FamilyName:GetSizeY() + 5 + (slot._btn_Slot:GetSizeY() + 5) * slotIdx + self.premiumPcRoomSizeY + 5)
    slot._ChaStat:SetPosX(300)
    slot._ChaStat:SetPosY(15)
    slot._ContStat:SetPosX(300)
    slot._ContStat:SetPosY(20)
    slot._Status:SetPosX(130)
    slot._Status:SetPosY(50)
    slot._ChaLev:SetPosX(12)
    slot._ChaLev:SetPosY(33)
    slot._btnCreate:SetPosX(280)
    slot._btnCreate:SetPosY(5)
    slot._btnStart:SetPosX(340)
    slot._btnStart:SetPosY(21)
    slot._btnDelCancel:SetPosX(340)
    slot._btnDelCancel:SetPosY(21)
    slot._possibleStat:SetPosX(180)
    slot._possibleStat:SetPosY(20)
    slot._ClassIcon:ComputePos()
    slot._btnUp:SetPosX(13)
    slot._btnUp:SetPosY(5)
    slot._btnDown:SetPosX(13)
    slot._btnDown:SetPosY(41)
    slot._btn_Slot:SetShow(false)
    slot._ClassIcon:SetShow(false)
    slot._ChaStat:SetShow(false)
    slot._ContStat:SetShow(false)
    slot._ChaLev:SetShow(false)
    slot._Status:SetShow(false)
    slot._btnCreate:SetShow(false)
    slot._btnStart:SetShow(false)
    slot._btnDelCancel:SetShow(false)
    slot._btnUp:SetShow(false)
    slot._btnDown:SetShow(false)
    slot._possibleStat:SetShow(false)
    slot._btn_Slot:addInputEvent("Mouse_UpScroll", "SelectCharacter_ScrollEvent( true )")
    slot._btn_Slot:addInputEvent("Mouse_DownScroll", "SelectCharacter_ScrollEvent( false )")
    slot._btnStart:addInputEvent("Mouse_UpScroll", "SelectCharacter_ScrollEvent( true )")
    slot._btnStart:addInputEvent("Mouse_DownScroll", "SelectCharacter_ScrollEvent( false )")
    slot._btnDelCancel:addInputEvent("Mouse_UpScroll", "SelectCharacter_ScrollEvent( true )")
    slot._btnDelCancel:addInputEvent("Mouse_DownScroll", "SelectCharacter_ScrollEvent( false )")
    configData.slotUiPool[slotIdx] = slot
  end
  Panel_CharacterSelectNew:SetChildIndex(self.radioBtnBG, 0)
  SelectCharacter.btn_Link1:ComputePos()
  SelectCharacter.btn_Link2:ComputePos()
  if isGameTypeEnglish() and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_Pre then
    SelectCharacter.btn_Link1:SetShow(true)
    SelectCharacter.btn_Link2:SetShow(true)
  else
    SelectCharacter.btn_Link1:SetShow(false)
    SelectCharacter.btn_Link2:SetShow(false)
  end
  btn_SaveCustomization:ComputePos()
  SelectCharacter.btn_Link1:addInputEvent("Mouse_LUp", "HandleClicked_PreOrderAndEvent( 0 )")
  SelectCharacter.btn_Link2:addInputEvent("Mouse_LUp", "HandleClicked_PreOrderAndEvent( 1 )")
  SelectCharacter.static_PenelBG:addInputEvent("Mouse_UpScroll", "SelectCharacter_ScrollEvent( true )")
  SelectCharacter.static_PenelBG:addInputEvent("Mouse_DownScroll", "SelectCharacter_ScrollEvent( false )")
  UIScroll.InputEvent(SelectCharacter._scroll, "SelectCharacter_ScrollEvent")
  UIScroll.InputEventByControl(SelectCharacter._scroll, "SelectCharacter_ScrollEvent")
  if ToClient_IsDevelopment() then
    isGhostMode = ToClient_getGhostMode()
    local CheckButton = UI.getChildControl(Panel_CharacterSelectNew, "check_GhostMode")
    CheckButton:SetShow(true)
    CheckButton:addInputEvent("Mouse_LUp", "HandleClicked_ToggleGhostMode()")
  end
  SelectCharacter.keyGuide:SetPosX(getScreenSizeX() - SelectCharacter.static_PenelBG:GetSizeX() - SelectCharacter.keyGuide:GetSizeX() - 15)
  SelectCharacter.keyGuide:SetPosY(getScreenSizeY() - SelectCharacter.keyGuide:GetSizeY() - 5)
  SelectCharacter.keyGuide:SetShow(false)
  PaGlobal_CheckGamerTag()
end
function Panel_Lobby_SelectCharacter_EnableSelectButton(enableValue)
  for slotIdx = 0, configData._listCount - 1 do
    local slot = configData.slotUiPool[slotIdx]
    slot._btn_Slot:SetEnable(enableValue)
    slot._btn_Slot:SetMonoTone(not enableValue)
    slot._ChaStat:SetEnable(enableValue)
    slot._ChaStat:SetMonoTone(not enableValue)
    slot._ContStat:SetEnable(enableValue)
    slot._ContStat:SetMonoTone(not enableValue)
    slot._ChaLev:SetEnable(enableValue)
    slot._ChaLev:SetMonoTone(not enableValue)
    slot._btnCreate:SetEnable(enableValue)
    slot._btnCreate:SetMonoTone(not enableValue)
    slot._btnStart:SetEnable(enableValue)
    slot._btnStart:SetMonoTone(not enableValue)
    slot._btnDelCancel:SetEnable(enableValue)
    slot._btnDelCancel:SetMonoTone(not enableValue)
    slot._btnUp:SetEnable(enableValue)
    slot._btnUp:SetMonoTone(not enableValue)
    slot._btnDown:SetEnable(enableValue)
    slot._btnDown:SetMonoTone(not enableValue)
  end
  local selChar = SelectCharacter
  selChar.btn_ChangeLocate:SetEnable(enableValue)
  selChar.btn_ChangeLocate:SetMonoTone(not enableValue)
  selChar.btn_EndGame:SetEnable(enableValue)
  selChar.btn_EndGame:SetMonoTone(not enableValue)
  selChar.btn_ServerSelect:SetEnable(enableValue)
  selChar.btn_ServerSelect:SetMonoTone(not enableValue)
end
local function CharacterView(index, classType, isSpecialCharacter, isChangeSpecialTab)
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
  else
    viewCharacter(index, 0, 0, 0, 0, isSpecialCharacter, isChangeSpecialTab)
    viewCharacterPitchRoll(3.14, 0)
  end
end
local function ChangeTexture_Class(control, classType)
  if classType == UI_Class.ClassType_Warrior then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 1, 57, 57)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 1, 57, 57)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 1, 57, 57)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Ranger then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 58, 1, 114, 57)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 58, 1, 114, 57)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 58, 1, 114, 57)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Sorcerer then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 115, 1, 171, 57)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 115, 1, 171, 57)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 115, 1, 171, 57)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Giant then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 172, 1, 228, 57)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 172, 1, 228, 57)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 172, 1, 228, 57)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Tamer then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 229, 1, 285, 57)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 229, 1, 285, 57)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 229, 1, 285, 57)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_BladeMaster then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 286, 1, 342, 57)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 286, 1, 342, 57)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 286, 1, 342, 57)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_BladeMasterWomen then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 400, 1, 456, 57)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 400, 1, 456, 57)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 400, 1, 456, 57)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Valkyrie then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 343, 1, 399, 57)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 343, 1, 399, 57)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 343, 1, 399, 57)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Wizard then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 58, 57, 114)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 58, 57, 114)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 58, 57, 114)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_WizardWomen then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 58, 58, 114, 114)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 58, 58, 114, 114)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 58, 58, 114, 114)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_NinjaWomen then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 115, 58, 171, 114)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 115, 58, 171, 114)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 115, 58, 171, 114)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_NinjaMan then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 172, 58, 228, 114)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 172, 58, 228, 114)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 172, 58, 228, 114)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_DarkElf then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 229, 58, 285, 114)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 229, 58, 285, 114)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 229, 58, 285, 114)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Combattant then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 286, 58, 342, 114)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 286, 58, 342, 114)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 286, 58, 342, 114)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_CombattantWomen then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 343, 58, 399, 114)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 343, 58, 399, 114)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 343, 58, 399, 114)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Orange then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 115, 57, 171)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 286, 57, 342)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 400, 286, 456, 342)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  else
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 400, 57, 456)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 400, 57, 456)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_ClassSymbol.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 400, 57, 456)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  end
end
local ChangeTexture_Slot = function(isFree, control)
  if true == isFree then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_Btn_CharacterSelect.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 1, 374, 82)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_Btn_CharacterSelect.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 83, 374, 164)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_Btn_CharacterSelect.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 165, 374, 246)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  else
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_Btn_CharacterSelect.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 247, 374, 328)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/Console_Btn_CharacterSelect.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 247, 374, 328)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Console_Btn_CharacterSelect.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 247, 374, 328)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  end
end
local function What_R_U_Doing_Now(isSpecialCharacter, index)
  local characterData = getCharacterDataByIndex(index, isSpecialCharacter)
  local workName = "-"
  local progressRate = 0
  local uiIndex = index - configData._startIndex
  if nil ~= characterData then
    local characterName = getCharacterName(characterData)
    local removeTime = getCharacterDataRemoveTime(index, isSpecialCharacter)
    local pcDeliveryRegionKey = characterData._arrivalRegionKey
    local serverUtc64 = getServerUtc64()
    local whereIs = "-"
    local regionInfo
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
    if 0 ~= pcDeliveryRegionKey:get() then
      if serverUtc64 < characterData._arrivalTime then
        local remainTime = characterData._arrivalTime - serverUtc64
        local strTime = convertStringFromDatetime(remainTime)
        whereIs = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERSELECTNEW_DELAYTIME", "time", strTime)
      end
      workName = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_DELIVERY")
    elseif ePcWorkingType.ePcWorkType_Empty == characterData._pcWorkingType or ePcWorkingType.ePcWorkType_Play == characterData._pcWorkingType then
      workName = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_NONE")
    elseif ePcWorkingType.ePcWorkType_RepairItem == characterData._pcWorkingType then
      workName = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_REPAIRITEM")
    elseif ePcWorkingType.ePcWorkType_Relax == characterData._pcWorkingType then
      workName = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_RELEX")
    elseif ePcWorkingType.ePcWorkType_ReadBook == characterData._pcWorkingType then
      local totalWorkingTime = characterData._workingStartCompletingDate - characterData._workingStartDate
      local workedTime = serverUtc64 - characterData._workingStartDate
      progressRate = string.format("%.1f", Int64toInt32(workedTime) / Int64toInt32(totalWorkingTime) * 100)
      workName = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_READBOOK")
    else
      _PA_ASSERT(false, "\236\186\144\235\166\173\237\132\176 \236\158\145\236\151\133 \237\131\128\236\158\133\236\157\180 \236\182\148\234\176\128 \235\144\152\236\151\136\236\138\181\235\139\136\235\139\164. Lobby_New.lua \236\151\144\235\143\132 \236\182\148\234\176\128\237\149\180 \236\163\188\236\150\180\236\149\188 \237\149\169\235\139\136\235\139\164.")
    end
    if PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_NONE") ~= workName then
      configData.slotUiPool[uiIndex]._btn_Slot:SetText(characterName .. "(" .. workName .. ")")
    end
    if nil ~= removeTime then
      workName = PAGetString(Defines.StringSheet_GAME, "CHARACTER_DELETING")
      configData.slotUiPool[uiIndex]._btn_Slot:SetText(characterName .. " [" .. workName .. "]")
      configData.slotUiPool[uiIndex]._Status:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTER_DELETE") .. " ( " .. removeTime .. " )")
    else
      configData.slotUiPool[uiIndex]._Status:SetText(whereIs)
      if getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_Pre then
      else
      end
    end
  else
  end
end
local CharacterCustomization_Close = function()
  Panel_Customization_Control:SetShow(false, false)
  Panel_CustomizationTest:SetShow(false, false)
  Panel_CharacterCreateSelectClass:SetShow(false, false)
  Panel_CustomizationTransform:SetShow(false, false)
  Panel_CustomizationMesh:SetShow(false, false)
  Panel_CustomizationMain:SetShow(false, false)
  Panel_CustomizationStatic:SetShow(false, false)
  Panel_CustomizationMessage:SetShow(false, false)
  Panel_CustomizationFrame:SetShow(false, false)
  Panel_CustomizationMotion:SetShow(false, false)
  Panel_CustomizationExpression:SetShow(false, false)
  Panel_CustomizationCloth:SetShow(false, false)
end
local function getMaxCharacsterScrollCount(isSpecialCharacter)
  local scrSizeY = getScreenSizeY()
  local scrSizeSumY = scrSizeY - SelectCharacter.static_FamilyName:GetSizeY() - SelectCharacter.btn_EndGame:GetSizeY() - SelectCharacter.btn_ChangeLocate:GetSizeY() - 25 - SelectCharacter.premiumPcRoomSizeY - 35
  local btnSizeY = SelectCharacter.btn_CharacterSlot:GetSizeY()
  local _btnCount = math.floor(scrSizeSumY / btnSizeY)
  local characterCount = getCharacterDataCount(isSpecialCharacter)
  local useableSlotCount = getCharacterSlotLimit(isSpecialCharacter)
  local maxSlotCount = getCharacterSlotMaxCount(isSpecialCharacter)
  local scrollCount = 0
  scrollCount = scrollCount + characterCount
  if characterCount < useableSlotCount then
    scrollCount = scrollCount + 1
  end
  if useableSlotCount > characterCount + 1 then
    scrollCount = scrollCount + (useableSlotCount - (characterCount + 1))
  end
  if characterCount < maxSlotCount and useableSlotCount < maxSlotCount then
    scrollCount = scrollCount + 1
  end
  scrollCount = scrollCount - configData._startIndex
  if _btnCount < scrollCount then
    scrollCount = _btnCount
  end
  return scrollCount
end
local function getMaxSPCharacsterScrollCount()
  local scrSizeY = getScreenSizeY()
  local scrSizeSumY = scrSizeY - SelectCharacter.static_FamilyName:GetSizeY() - SelectCharacter.btn_EndGame:GetSizeY() - SelectCharacter.btn_ChangeLocate:GetSizeY() - 25 - SelectCharacter.premiumPcRoomSizeY - 35
  local btnSizeY = SelectCharacter.btn_CharacterSlot:GetSizeY()
  local _btnCount = math.floor(scrSizeSumY / btnSizeY)
  local characterCount = getSpecialCharacterDataCount()
  local useableSlotCount = getSpecialCharacterSlotLimit()
  local maxSlotCount = getSpecialCharacterSlotMaxCount()
  local scrollCount = 0
  scrollCount = scrollCount + characterCount
  if characterCount < useableSlotCount then
    scrollCount = scrollCount + 1
  end
  if useableSlotCount > characterCount + 1 then
    scrollCount = scrollCount + (useableSlotCount - (characterCount + 1))
  end
  if characterCount < maxSlotCount and useableSlotCount < maxSlotCount then
    scrollCount = scrollCount + 1
  end
  scrollCount = scrollCount - configData._startIndex
  if _btnCount < scrollCount then
    scrollCount = _btnCount
  end
  return scrollCount
end
function scrollTotalCount()
  local isSpecialCharacter = false
  if true == SelectCharacter.radioBtn_SpecialCharacterList:IsCheck() then
    isSpecialCharacter = true
  end
  local characterCount = getCharacterDataCount(isSpecialCharacter)
  local useableSlotCount = getCharacterSlotLimit(isSpecialCharacter)
  local maxSlotCount = getCharacterSlotMaxCount(isSpecialCharacter)
  local maxCount = characterCount
  if characterCount < useableSlotCount then
    maxCount = maxCount + (useableSlotCount - characterCount)
  end
  if maxSlotCount > maxCount then
    maxCount = maxCount + 1
  end
  return maxCount
end
local function CharacterList_Update(isChangeSpecialTab)
  local scrSizeY = getScreenSizeY()
  local scrSizeSumY = scrSizeY - SelectCharacter.static_FamilyName:GetSizeY() - SelectCharacter.btn_EndGame:GetSizeY() - SelectCharacter.btn_ChangeLocate:GetSizeY() - 25 - SelectCharacter.premiumPcRoomSizeY - 35
  local btnSizeY = SelectCharacter.btn_CharacterSlot:GetSizeY()
  local _btnCount = math.floor(scrSizeSumY / btnSizeY)
  local isSpecialCharacter = false
  if true == SelectCharacter.radioBtn_SpecialCharacterList:IsCheck() then
    isSpecialCharacter = true
  end
  configData.maxSlot = getCharacterMaxSlotData(isSpecialCharacter)
  configData.maxCountSlot = getMaxCharacsterCount(isSpecialCharacter)
  configData.maxScrollCount = getMaxCharacsterScrollCount(isSpecialCharacter)
  configData.freeCount = getCharacterSlotDefaultCount(isSpecialCharacter)
  configData.haveCount = getCharacterDataCount(isSpecialCharacter)
  configData.useAbleCount = getCharacterSlotLimit(isSpecialCharacter)
  for slotIdx = 0, configData._listCount - 1 do
    local slot = configData.slotUiPool[slotIdx]
    slot._btn_Slot:SetShow(false)
    slot._ClassIcon:SetShow(false)
    slot._ChaStat:SetShow(false)
    slot._ContStat:SetShow(false)
    slot._ChaLev:SetShow(false)
    slot._Status:SetShow(false)
    slot._btnCreate:SetShow(false)
    slot._btnStart:SetShow(false)
    slot._btnDelCancel:SetShow(false)
    slot._btnUp:SetShow(false)
    slot._btnDown:SetShow(false)
    slot._btn_Slot:SetMonoTone(false)
    slot._btn_Slot:SetIgnore(false)
    slot._btn_Slot:SetEnable(true)
  end
  SelectCharacter.static_FamilyName:SetText(getFamilyName())
  if -1 == configData.selectCaracterIdx then
    configData.selectCaracterIdx = 0
  end
  local scrollListIndex = 0
  local maxCharacter = getMaxCharacsterScrollCount(isSpecialCharacter)
  SelectCharacter.radioBtnBG:SetSize(SelectCharacter.radioBtnBG:GetSizeX(), SelectCharacter.static_FamilyName:GetSizeY() + 5 + (configData.slotUiPool[0]._btn_Slot:GetSizeY() + 5) * maxCharacter - 31)
  local iii = 0
  for slotIdx = configData._startIndex, maxCharacter + configData._startIndex - 1 do
    local slot = configData.slotUiPool[iii]
    iii = iii + 1
    slot._btn_Slot:SetTextHorizonLeft()
    slot._btn_Slot:SetTextVerticalTop()
    slot._btn_Slot:SetTextSpan(130, 20)
    if slotIdx < configData.freeCount then
      ChangeTexture_Slot(true, slot._btn_Slot)
    elseif slotIdx < configData.useAbleCount then
      ChangeTexture_Slot(true, slot._btn_Slot)
    else
      ChangeTexture_Slot(false, slot._btn_Slot)
    end
    if slotIdx < configData.haveCount then
      local characterData = getCharacterDataByIndex(slotIdx, isSpecialCharacter)
      local characterName = getCharacterName(characterData)
      local classType = getCharacterClassType(characterData)
      local characterLevel = string.format("%d", characterData._level)
      local regionInfo
      local removeTime = getCharacterDataRemoveTime(slotIdx, isSpecialCharacter)
      if nil ~= removeTime then
      end
      ChangeTexture_Class(slot._ClassIcon, classType)
      slot._btn_Slot:SetText(characterName)
      slot._ChaLev:SetText(characterLevel)
      if configData.selectCaracterIdx == slotIdx then
        CharacterView(configData.selectCaracterIdx, classType, isSpecialCharacter, isChangeSpecialTab)
        slot._btn_Slot:SetCheck(true)
      else
        slot._btn_Slot:SetCheck(false)
      end
      slot._btn_Slot:addInputEvent("Mouse_LUp", "CharacterSelect_selected( " .. slotIdx .. " )")
      slot._btnStart:addInputEvent("Mouse_LUp", "CharacterSelect_PlayGame( " .. slotIdx .. " )")
      slot._btnDelCancel:addInputEvent("Mouse_LUp", "CharacterSelect_DeleteCancelCharacter( " .. slotIdx .. " )")
      slot._btnUp:addInputEvent("Mouse_LUp", "CharacterSelect_ChangeCharacterPosition( " .. slotIdx .. ", true )")
      slot._btnDown:addInputEvent("Mouse_LUp", "CharacterSelect_ChangeCharacterPosition( " .. slotIdx .. ", false )")
      slot._btn_Slot:SetShow(true)
      slot._ClassIcon:SetShow(true)
      slot._ChaStat:SetShow(false)
      slot._ContStat:SetShow(false)
      slot._ChaLev:SetShow(true)
      slot._Status:SetShow(true)
      slot._btnCreate:SetShow(false)
      if nil ~= removeTime then
        slot._btnStart:SetShow(false)
        slot._btnDelCancel:SetShow(true)
      elseif getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_Pre then
        slot._btnStart:SetShow(false)
        slot._btnDelCancel:SetShow(false)
      else
        if SelectCharacter.btn_ChangeLocate:IsCheck() then
          slot._btnUp:SetShow(true)
          slot._btnDown:SetShow(true)
        else
          slot._btnUp:SetShow(false)
          slot._btnDown:SetShow(false)
        end
        slot._btnStart:SetShow(true)
        slot._btnDelCancel:SetShow(false)
      end
      slot._btn_Slot:SetIgnore(false)
      What_R_U_Doing_Now(isSpecialCharacter, slotIdx)
    else
      slot._btn_Slot:addInputEvent("Mouse_LUp", "CharacterSelect_CreateNewCharacter()")
      slot._btnStart:addInputEvent("Mouse_LUp", "")
      slot._btnDelCancel:addInputEvent("Mouse_LUp", "")
      slot._btnUp:addInputEvent("Mouse_LUp", "")
      slot._btnDown:addInputEvent("Mouse_LUp", "")
      slot._btn_Slot:SetShow(true)
      slot._ClassIcon:SetShow(false)
      slot._ChaStat:SetShow(false)
      slot._ContStat:SetShow(false)
      slot._ChaLev:SetShow(false)
      slot._Status:SetShow(false)
      slot._btnCreate:SetShow(false)
      slot._btnStart:SetShow(false)
      slot._btnDelCancel:SetShow(false)
      slot._btnUp:SetShow(false)
      slot._btnDown:SetShow(false)
      slot._btn_Slot:SetIgnore(false)
      if configData.haveCount == slotIdx then
        slot._btn_Slot:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERSELECT_CREATENEWCHARACTER_BTN"))
        slot._btn_Slot:SetTextHorizonCenter()
        slot._btn_Slot:SetTextVerticalCenter()
        slot._btn_Slot:SetTextSpan(130, 20)
        slot._btn_Slot:SetEnable(true)
        slot._btn_Slot:SetMonoTone(false)
        slot._btnCreate:SetShow(false)
        if slotIdx >= configData.freeCount and slotIdx >= configData.useAbleCount then
          slot._btn_Slot:SetIgnore(true)
          slot._btn_Slot:SetText("")
          slot._btnCreate:SetShow(false)
        end
      else
        if slotIdx >= configData.freeCount and slotIdx >= configData.useAbleCount then
          slot._btn_Slot:SetText("")
        end
        slot._btn_Slot:SetText("")
        slot._btn_Slot:SetIgnore(true)
        slot._btn_Slot:SetEnable(false)
        slot._btn_Slot:SetMonoTone(true)
        slot._btnCreate:SetShow(false)
      end
    end
    scrollListIndex = scrollListIndex + 1
  end
  UIScroll.SetButtonSize(SelectCharacter._scroll, configData.maxScrollCount, scrollTotalCount())
  local selectedCharacterData = getCharacterDataByIndex(configData.selectCaracterIdx, isSpecialCharacter)
  if nil ~= selectedCharacterData then
    CharacterSelect_setUpdateTicketNo(selectedCharacterData)
  end
  local GhostButton = UI.getChildControl(Panel_CharacterSelectNew, "check_GhostMode")
  isGhostMode = ToClient_getGhostMode()
  if isGhostMode then
    GhostButton:SetText("GhostMode ON")
  else
    GhostButton:SetText("GhostMode OFF")
  end
end
function CharacterSelect_ChangeLocate()
  if not SelectCharacter.btn_ChangeLocate:IsCheck() then
    ToClient_SaveClientCacheData()
  end
  CharacterList_Update(false)
end
function SelectCharacter_ScrollEvent(isUp)
  local self = SelectCharacter
  configData._startIndex = UIScroll.ScrollEvent(self._scroll, isUp, configData.maxScrollCount, scrollTotalCount(), configData._startIndex, 1)
  CharacterList_Update(false)
end
function CharacterSelect_selected(index)
  if configData.selectCaracterIdx == index then
    CharacterSelect_PlayGame(index)
    return
  end
  configData.selectCaracterIdx = index
  CharacterList_Update(false)
end
function CharacterSelect_PlayGame(index)
  if ToClient_isDataDownloadStart() then
    local isComplete = ToClient_isDataDownloadComplete()
    local percent = ToClient_getDataDownloadProgress()
    if false == isComplete then
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = "Fail to GameStart Because not Installation Xbox data, Please wait for second : Data installation percent : " .. tostring(percent),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
      return
    end
  end
  local isSpecialCharacter = false
  if true == SelectCharacter.radioBtn_SpecialCharacterList:IsCheck() then
    isSpecialCharacter = true
  end
  local removeTime = getCharacterDataRemoveTime(index, isSpecialCharacter)
  if nil ~= removeTime then
    return
  end
  configData.selectCaracterIdx = index
  local characterData = getCharacterDataByIndex(index, isSpecialCharacter)
  local classType = getCharacterClassType(characterData)
  local characterCount = getCharacterDataCount()
  local serverUtc64 = getServerUtc64()
  if ToClient_IsCustomizeOnlyClass(classType) then
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
      if 1 == characterData._level and 1 == characterCount then
        FGlobal_FirstLogin_Open(index)
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
            functionYes = CharacterSelect_SelectEnterToGame,
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
        elseif true == selectCharacter(configData.selectCaracterIdx, isSpecialCharacter) then
          Panel_Lobby_SelectCharacter_EnableSelectButton(false)
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
function CharacterSelect_ChangeCharacterPosition(index, isUp)
  if nil == index and nil == isUp then
    return
  end
  ToClient_ChangeCharacterListOrder(index, isUp)
  ToClient_SaveClientCacheData()
  CharacterList_Update(false)
end
function CharacterSelect_SelectEnterToGame()
  local isSpecialCharacter = false
  if true == SelectCharacter.radioBtn_SpecialCharacterList:IsCheck() then
    isSpecialCharacter = true
  end
  local characterData = getCharacterDataByIndex(configData.selectCaracterIdx, isSpecialCharacter)
  local classType = getCharacterClassType(characterData)
  if nil ~= characterData then
    if ToClient_IsCustomizeOnlyClass(classType) then
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = PAGetString(Defines.StringSheet_GAME, "LUA_LOBBY_SELECTCHARACTER_NOTYET_1") .. PAGetString(Defines.StringSheet_GAME, "LUA_LOBBY_SELECTCHARACTER_NOTYET_2"),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
    else
      selectCharacter(configData.selectCaracterIdx, isSpecialCharacter)
    end
  end
end
function CharacterSelect_Open(characterIndex)
  if -1 == characterIndex or characterIndex >= configData.haveCount then
    configData.selectCaracterIdx = 0
  elseif -2 == characterIndex then
    configData.selectCaracterIdx = configData.selectCaracterIdx
  else
    configData.selectCaracterIdx = characterIndex
  end
  CharacterCustomization_Close()
  configData._startIndex = 0
  SelectCharacter.btn_ChangeLocate:SetCheck(false)
  CharacterList_Update(false)
  SelectCharacter._scroll:SetControlPos(0)
  Panel_CharacterSelectNew:SetShow(true)
end
function CharacterSelect_ExitGame()
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
function CharacterSelect_Back()
  Panel_CharacterSelectNew:SetShow(false)
  backServerSelect()
end
function CharacterSelect_DeleteCharacter()
  local isSpecialCharacter = false
  if true == SelectCharacter.radioBtn_SpecialCharacterList:IsCheck() then
    isSpecialCharacter = true
  end
  if -1 ~= configData.selectCaracterIdx then
    local function do_Delete()
      deleteCharacter(configData.selectCaracterIdx, isSpecialCharacter)
    end
    local characterData = getCharacterDataByIndex(configData.selectCaracterIdx, isSpecialCharacter)
    if nil == characterData then
      return
    end
    local characterData = getCharacterDataByIndex(configData.selectCaracterIdx, isSpecialCharacter)
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
function CharacterSelect_DeleteCancelCharacter(index)
  local isSpecialCharacter = false
  if true == SelectCharacter.radioBtn_SpecialCharacterList:IsCheck() then
    isSpecialCharacter = true
  end
  if -1 ~= index then
    deleteCancelCharacter(index, isSpecialCharacter)
  end
end
function FGlobal_CharacterSelect_Close()
  Panel_CharacterSelectNew:SetShow(false)
end
function CharacterSelect_CreateNewCharacter()
  if Panel_Win_System:GetShow() then
    return
  end
  local function do_Create()
    local isSpecialCharacter = false
    if true == SelectCharacter.radioBtn_SpecialCharacterList:IsCheck() then
      isSpecialCharacter = true
    end
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
function CharacterSelect_setUpdateTicketNo(characterData)
  local firstTicketNo = getFirstTicketNoByAll()
  local currentTicketNo = getCurrentTicketNo()
  local ticketCountByRegion = characterData._lastTicketNoByRegion
  local myRegionWaitingPlayerCount = currentTicketNo - ticketCountByRegion
  local serverPlayingCount = currentTicketNo - firstTicketNo
  local classType = getCharacterClassType(characterData)
  local isPossibleClass = ToClient_IsCustomizeOnlyClass(classType)
end
function cancelEnterWaitingLine()
  setShowBlockBG(false)
  if true == configData.isWaitLine then
    MessageBox_HideAni()
    configData.isWaitLine = false
  end
end
function makeEnterWaitingUserMsg(receiveTicketNoMyRegion)
  local isSpecialCharacter = false
  if true == SelectCharacter.radioBtn_SpecialCharacterList:IsCheck() then
    isSpecialCharacter = true
  end
  local ticketCountByRegion = receiveTicketNoMyRegion
  local waitingLineCancelCount = getCancelCount()
  if -1 == ticketCountByRegion then
    local selectedCharacterData = getCharacterDataByIndex(configData.selectCaracterIdx, isSpecialCharacter)
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
function setShowBlockBG(isShow)
  SelectCharacter.block_BG:SetShow(isShow)
  SelectCharacter.block_BG:SetSize(getScreenSizeX() + 200, getScreenSizeY() + 200)
  SelectCharacter.block_BG:SetHorizonCenter()
  SelectCharacter.block_BG:SetVerticalMiddle()
end
function receiveEnterWaiting()
  local isSpecialCharacter = false
  if true == SelectCharacter.radioBtn_SpecialCharacterList:IsCheck() then
    isSpecialCharacter = true
  end
  configData.isWaitLine = true
  local characterData = getCharacterDataByIndex(configData.selectCaracterIdx, isSpecialCharacter)
  if nil == characterData then
    UI.ASSERT(false, "\236\186\144\235\166\173\237\132\176 \236\132\160\237\131\157\236\157\180 \235\144\152\236\167\128 \236\149\138\236\149\152\235\130\152...?")
    return
  end
  setShowBlockBG(true)
  local strWaitingMsg = makeEnterWaitingUserMsg(characterData._lastTicketNoByRegion)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "CHARACTER_ENTER_WAITING_TITLE"),
    content = strWaitingMsg,
    functionCancel = click_EnterWaitingCancel,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1m,
    enablePriority = true
  }
  MessageBox.showMessageBox(messageboxData)
end
function setEnterWaitingUserCount()
  if false == configData.isWaitLine then
    return
  end
  local strWaitingMsg = makeEnterWaitingUserMsg(-1)
  setShowBlockBG(true)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "CHARACTER_ENTER_WAITING_TITLE"),
    content = strWaitingMsg,
    functionCancel = click_EnterWaitingCancel,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1m,
    enablePriority = true
  }
  if true == MessageBox.doHaveMessageBoxData(messageboxData.title) then
    setCurrentMessageData(messageboxData)
  else
    MessageBox.showMessageBox(messageboxData)
  end
end
function click_EnterWaitingCancel()
  setShowBlockBG(false)
  allClearMessageData()
  if true == configData.isWaitLine then
    sendEnterWaitingCancel()
  end
  Panel_Lobby_SelectCharacter_EnableSelectButton(true)
end
function HandleClicked_PreOrderAndEvent(linkType)
  local linkURL = ""
  if 0 == linkType then
    linkURL = "https://www.blackdesertonline.com/preorder/?trcode=CCM001"
  elseif 1 == linkType then
    linkURL = "https://www.blackdesertonline.com/events/ccm/ShowEvent.html"
  end
  ToClient_OpenChargeWebPage(linkURL, false)
end
function HandleClicked_SaveCustomizationFile()
  OpenExplorerSaveCustomizing()
end
function RadioButton_Click(radioIndex)
  if radioIndex == CharacterListIndex then
    if true == SelectCharacter.btn_ChangeLocate:GetShow() then
      isChangeCharacterTab = false
    else
      isChangeCharacterTab = true
    end
    SelectCharacter.radioBtn_CharacterList:SetCheck(true)
    SelectCharacter.radioBtn_SpecialCharacterList:SetCheck(false)
    SelectCharacter.btn_ChangeLocate:SetShow(true)
  elseif radioIndex == SpecialCharacterListIndex then
    if false == SelectCharacter.btn_ChangeLocate:GetShow() then
      isChangeCharacterTab = false
    else
      isChangeCharacterTab = true
    end
    SelectCharacter.radioBtn_CharacterList:SetCheck(false)
    SelectCharacter.radioBtn_SpecialCharacterList:SetCheck(true)
    SelectCharacter.btn_ChangeLocate:SetShow(false)
    if SelectCharacter.btn_ChangeLocate:IsCheck() then
      SelectCharacter.btn_ChangeLocate:SetCheck(false)
    end
  end
  configData.selectCaracterIdx = 0
  configData._startIndex = 0
  SelectCharacter._scroll:SetControlPos(0)
  ToClient_viewCharacterDelete(isChangeCharacterTab)
  CharacterList_Update(isChangeCharacterTab)
end
function HandleClicked_ToggleGhostMode()
  ToClient_ToggleGhostMode()
  local GhostButton = UI.getChildControl(Panel_CharacterSelectNew, "check_GhostMode")
  isGhostMode = ToClient_getGhostMode()
  if isGhostMode then
    GhostButton:SetText("GhostMode ON")
  else
    GhostButton:SetText("GhostMode OFF")
  end
end
function UpdateSpecialCharacterTab()
  local self = SelectCharacter
  local temporaryWrapper = getTemporaryInformationWrapper()
  temporaryWrapper:ToClient_completeInitialUI()
  if false == isSpecialCharacterOpen then
    return
  end
  local isPremiumPcRoom
  if true == isGameTypeRussia() then
    isPremiumPcRoom = temporaryWrapper:isRusPcRoom()
    if false == isPremiumPcRoom then
      return
    end
  else
    isPremiumPcRoom = temporaryWrapper:isPremiumPcRoom()
    if false == isPremiumPcRoom then
      return
    end
  end
  SelectCharacter.radioBtn_CharacterList:SetShow(true)
  SelectCharacter.radioBtn_CharacterList:SetPosX(SelectCharacter.static_PenelBG:GetPosX() + 5)
  SelectCharacter.radioBtn_SpecialCharacterList:SetShow(true)
  SelectCharacter.radioBtn_SpecialCharacterList:SetPosX(SelectCharacter.static_PenelBG:GetPosX() + SelectCharacter.radioBtn_CharacterList:GetSizeX() + 5)
  SelectCharacter.radioBtnBG:SetPosX(SelectCharacter.static_PenelBG:GetPosX() + 5)
  SelectCharacter.radioBtnBG:SetShow(true)
  SelectCharacter.premiumPcRoomSizeY = SelectCharacter.radioBtn_CharacterList:GetSizeY()
  SelectCharacter._scroll:SetPosY(SelectCharacter._scroll:GetPosY() + SelectCharacter.premiumPcRoomSizeY)
  local scrSizeY = getScreenSizeY()
  local scrSizeSumY = scrSizeY - SelectCharacter.static_FamilyName:GetSizeY() - SelectCharacter.btn_EndGame:GetSizeY() - SelectCharacter.btn_ChangeLocate:GetSizeY() - 25 - self.premiumPcRoomSizeY - 35
  local btnSizeY = SelectCharacter.btn_CharacterSlot:GetSizeY()
  local _btnCount = math.floor(scrSizeSumY / btnSizeY)
  SelectCharacter._scroll:SetSize(SelectCharacter._scroll:GetSizeX(), btnSizeY * _btnCount - self.premiumPcRoomSizeY)
  configData._listCount = _btnCount
  configData.slotUiPool = {}
  for slotIdx = 0, configData._listCount - 1 do
    local slot = {}
    slot._btn_Slot = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "Button_CreateSlot", self.static_PenelBG, "SelectCharacter_EmptySlot_" .. slotIdx)
    slot._ClassIcon = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "StaticText_ClassIcon", slot._btn_Slot, "SelectCharacter_ClassIcon_" .. slotIdx)
    slot._ChaStat = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "StaticText_Character0", slot._btn_Slot, "SelectCharacter_ChaStat_" .. slotIdx)
    slot._ContStat = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "StaticText_UserCount", slot._btn_Slot, "SelectCharacter_ContStat_" .. slotIdx)
    slot._ChaLev = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "StaticText_CharLevel", slot._btn_Slot, "SelectCharacter_ChaLev_" .. slotIdx)
    slot._Status = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "StaticText_CharacterStatus", slot._btn_Slot, "SelectCharacter_Status_" .. slotIdx)
    slot._btnCreate = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "Button_CharacterCreate", slot._btn_Slot, "SelectCharacter_btnCreate_" .. slotIdx)
    slot._btnStart = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "Button_Start", slot._btn_Slot, "SelectCharacter_btnStart_" .. slotIdx)
    slot._btnDelCancel = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "Button_CharacterDeleteCancel", slot._btn_Slot, "SelectCharacter_btnDeleteCancel_" .. slotIdx)
    slot._btnUp = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "Button_Up", slot._btn_Slot, "SelectCharacter_btnUp_" .. slotIdx)
    slot._btnDown = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "Button_Down", slot._btn_Slot, "SelectCharacter_btnDown_" .. slotIdx)
    slot._possibleStat = UI.createAndCopyBasePropertyControl(Panel_CharacterSelectNew, "StaticText_PossibleEnter", slot._btn_Slot, "SelectCharacter_PossibleEnter_" .. slotIdx)
    slot._btn_Slot:SetText("")
    slot._btn_Slot:SetPosX(12)
    slot._btn_Slot:SetPosY(SelectCharacter.static_FamilyName:GetSizeY() + 5 + (slot._btn_Slot:GetSizeY() + 5) * slotIdx + self.premiumPcRoomSizeY + 5)
    slot._ChaStat:SetPosX(300)
    slot._ChaStat:SetPosY(15)
    slot._ContStat:SetPosX(300)
    slot._ContStat:SetPosY(20)
    slot._ChaLev:SetPosX(12)
    slot._ChaLev:SetPosY(33)
    slot._Status:SetPosX(130)
    slot._Status:SetPosY(50)
    slot._btnCreate:SetPosX(280)
    slot._btnCreate:SetPosY(5)
    slot._btnStart:SetPosX(340)
    slot._btnStart:SetPosY(21)
    slot._btnDelCancel:SetPosX(340)
    slot._btnDelCancel:SetPosY(21)
    slot._possibleStat:SetPosX(180)
    slot._possibleStat:SetPosY(20)
    slot._ClassIcon:ComputePos()
    slot._btn_Slot:SetShow(false)
    slot._ClassIcon:SetShow(false)
    slot._ChaStat:SetShow(false)
    slot._ContStat:SetShow(false)
    slot._ChaLev:SetShow(false)
    slot._Status:SetShow(false)
    slot._btnCreate:SetShow(false)
    slot._btnStart:SetShow(false)
    slot._btnDelCancel:SetShow(false)
    slot._btnUp:SetShow(false)
    slot._btnDown:SetShow(false)
    slot._possibleStat:SetShow(false)
    slot._btn_Slot:addInputEvent("Mouse_UpScroll", "SelectCharacter_ScrollEvent( true )")
    slot._btn_Slot:addInputEvent("Mouse_DownScroll", "SelectCharacter_ScrollEvent( false )")
    slot._btnStart:addInputEvent("Mouse_UpScroll", "SelectCharacter_ScrollEvent( true )")
    slot._btnStart:addInputEvent("Mouse_DownScroll", "SelectCharacter_ScrollEvent( false )")
    slot._btnDelCancel:addInputEvent("Mouse_UpScroll", "SelectCharacter_ScrollEvent( true )")
    slot._btnDelCancel:addInputEvent("Mouse_DownScroll", "SelectCharacter_ScrollEvent( false )")
    configData.slotUiPool[slotIdx] = slot
  end
  RadioButton_Click(0)
end
function SelectCharacter_ScrollEvent_Up()
  SelectCharacter_ScrollEvent(true)
end
function SelectCharacter_ScrollEvent_Down()
  SelectCharacter_ScrollEvent(false)
end
SelectCharacter_Init()
registerEvent("EventChangeLobbyStageToCharacterSelect", "CharacterSelect_Open")
registerEvent("FromClient_UpdateSpecialCharacterTab", "UpdateSpecialCharacterTab")
registerEvent("EventCancelEnterWating", "cancelEnterWaitingLine")
registerEvent("EventReceiveEnterWating", "receiveEnterWaiting")
registerEvent("EventSetEnterWating", "setEnterWaitingUserCount")
function setFocusingPanelLobby()
  Panel_CharacterSelectNew:SetShow(false)
  Panel_CharacterSelectNew:SetShow(true)
end
registerEvent("EventChangeLobbyStageToCharacterSelect", "setFocusingPanelLobby")
