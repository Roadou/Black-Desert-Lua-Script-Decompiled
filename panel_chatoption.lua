local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_CT = CppEnums.ChatType
local UI_CNT = CppEnums.EChatNoticeType
local UI_Group = Defines.UIGroup
local UI_CST = CppEnums.ChatSystemType
Panel_ChatOption:SetShow(false)
Panel_ChatOption:SetIgnore(true)
Panel_ChatOption:ActiveMouseEventEffect(true)
Panel_ChatOption:setGlassBackground(true)
Panel_ChatOption:RegisterShowEventFunc(true, "ChatOption_ShowAni()")
Panel_ChatOption:RegisterShowEventFunc(false, "ChatOption_HideAni()")
local isLocalWarOpen = ToClient_IsContentsGroupOpen("43")
local isArshaOpen = ToClient_IsContentsGroupOpen("227")
local isSavageDefenceOpen = ToClient_IsContentsGroupOpen("249")
local roleplayTypeOpen = not isGameTypeEnglish() and isGameServiceTypeDev()
local channel_Notice = false
local channel_System = false
local channel_World = false
local channel_Public = false
local channel_Private = false
local channel_Party = false
local channel_Guild = false
local channel_WorldWithItem = false
local channel_Battle = false
local channel_RolePlay = false
local channel_Arsha = false
local channel_Team = false
local channel_Alliance = false
local color_Notice = UI_color.C_FFFFEF82
local color_World = UI_color.C_FFFF973A
local color_Public = UI_color.C_FFE7E7E7
local color_Private = UI_color.C_FFF601FF
local color_Party = UI_color.C_FF8EBD00
local color_Guild = UI_color.C_FF84FFF5
local color_WorldWithItem = UI_color.C_FF00F3A0
local color_RolePlay = UI_color.C_FF00B4FF
local color_Arsha = UI_color.C_FFFFD237
local color_Team = UI_color.C_FFB97FEF
local color_Alliance = 4285842942
local savedChatColorIndex = Array.new()
local channel_SystemUndefine = false
local channel_SystemPrivateItem = false
local channel_SystemPartyItem = false
local channel_SystemMarket = false
local channel_SystemWorker = false
local channel_SystemHarvest = false
local _prevTransparency = -1
local _openOptionPanelIndex = -1
local _prevMainTransparency = -1
local _alphaPosX = 0
local eChatButtonType = {
  eChatNotice = 0,
  eChatWorldWithItem = 1,
  eChatWorld = 2,
  eChatGuild = 3,
  eChatParty = 5,
  eChatBattle = 4,
  eChatPublic = 6,
  eChatPrivate = 7,
  eChatRolePlay = 8,
  eChatArsha = 9,
  eChatTeam = 10,
  eChatAlliance = 11
}
local eChatSystemButtonType = {
  eChatSystem = 0,
  eChatSystemUndefine = 1,
  eChatSystemPrivateItem = 2,
  eChatSystemPartyItem = 3,
  eChatSystemMarket = 4,
  eChatSystemWorker = 5,
  eChatSystemHarvest = 6
}
local chatOptionData = {
  makeChatPanelCount = 5,
  chatFilterCount = 12,
  chatSystemFilterCount = 7,
  _slotsCols = 2,
  slotStartX = 0,
  slotGapX = 140,
  slotStartY = 0,
  slotGapY = 30,
  slotSystemTypeStartX = 270,
  slotSystemTypeStartY = 0,
  slotSystemTypeChildButtonGapX = 20
}
local prevFontSizeType = CppEnums.ChatFontSizeType.eChatFontSizeType_Normal
local isChangeFont = false
local _ChatOption_Title = UI.getChildControl(Panel_ChatOption, "StaticText_ChatOptionTitle")
local _msgFilter_BG = UI.getChildControl(Panel_ChatOption, "Static_FilterBG")
local msgFilter_Chkbox = UI.getChildControl(Panel_ChatOption, "Template_CheckButton_Filter")
local selectColor_btn = UI.getChildControl(Panel_ChatOption, "Template_Radiobutton_SelectColor")
local onlySystemSelectColor = UI.getChildControl(Panel_ChatOption, "Template_Radiobutton_SystemSelectColor")
local _alpha_0 = UI.getChildControl(Panel_ChatOption, "StaticText_PanelTransparency_0")
local _alpha_50 = UI.getChildControl(Panel_ChatOption, "StaticText_PanelTransparency_50")
local _alpha_100 = UI.getChildControl(Panel_ChatOption, "StaticText_PanelTransparency_100")
local _alphaSlider_Control = UI.getChildControl(Panel_ChatOption, "Slider_PanelTransparencyControl")
local _alphaSlider_ControlBTN = UI.getChildControl(_alphaSlider_Control, "Slider_PanelTransparency_Button")
local _button_Confirm = UI.getChildControl(Panel_ChatOption, "Button_Confirm")
local _button_Cancle = UI.getChildControl(Panel_ChatOption, "Button_Cancle")
local _button_Close = UI.getChildControl(Panel_ChatOption, "Button_WinClose")
local _button_blockList = UI.getChildControl(Panel_ChatOption, "Button_BlockList")
local _button_resetColor = UI.getChildControl(Panel_ChatOption, "Button_ResetColor")
local fontSizeTitleBg = UI.getChildControl(Panel_ChatOption, "Static_FontSizeTitleBg")
local fontSizeBG = UI.getChildControl(Panel_ChatOption, "Static_FontSizeBG")
local rdo_FontSizeSmall = UI.getChildControl(Panel_ChatOption, "RadioButton_FontSizeSmall")
local rdo_FontSizeSmall2 = UI.getChildControl(Panel_ChatOption, "RadioButton_FontSizeSmall2")
local rdo_FontSizeNormal = UI.getChildControl(Panel_ChatOption, "RadioButton_FontSizeNormal")
local rdo_FontSizeNormal2 = UI.getChildControl(Panel_ChatOption, "RadioButton_FontSizeNormal2")
local rdo_FontSizeBig = UI.getChildControl(Panel_ChatOption, "RadioButton_FontSizeBig")
local stringHeadTitleBg = UI.getChildControl(Panel_ChatOption, "Static_StringHeadTitleBg")
local stringHeadBg = UI.getChildControl(Panel_ChatOption, "Static_StringHeadBG")
local rdo_CharacterName = UI.getChildControl(stringHeadBg, "RadioButton_CharacterName")
local rdo_FamilyName = UI.getChildControl(stringHeadBg, "RadioButton_FamilyName")
rdo_CharacterName:addInputEvent("Mouse_LUp", "ChattingOption_SelectNameType( 0 )")
rdo_FamilyName:addInputEvent("Mouse_LUp", "ChattingOption_SelectNameType( 1 )")
rdo_CharacterName:SetEnableArea(0, 0, rdo_CharacterName:GetSizeX() + rdo_CharacterName:GetTextSizeX() + 3, rdo_CharacterName:GetSizeY())
rdo_FamilyName:SetEnableArea(0, 0, rdo_FamilyName:GetSizeX() + rdo_FamilyName:GetTextSizeX() + 3, rdo_FamilyName:GetSizeY())
rdo_CharacterName:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 23)")
rdo_CharacterName:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
rdo_FamilyName:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 24)")
rdo_FamilyName:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
local preNameType
local msgFilterBg_SizeY = _msgFilter_BG:GetSizeY()
local panelSizeY = Panel_ChatOption:GetSizeY()
local buttonSizeY = _button_Confirm:GetPosY()
local _buttonQuestion = UI.getChildControl(Panel_ChatOption, "Button_Question")
_buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"Chatting\" )")
_buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"Chatting\", \"true\")")
_buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"Chatting\", \"false\")")
local _check_Division = UI.getChildControl(Panel_ChatOption, "Checkbox_DivisionOption")
_check_Division:SetEnableArea(0, 0, _check_Division:GetSizeX() + _check_Division:GetTextSizeX() + 3, _check_Division:GetSizeY())
_check_Division:addInputEvent("Mouse_LUp", "HandleClicked_ChattingDivision()")
_check_Division:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 29)")
_check_Division:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
local _prevIsCheckDivision
local _checkButton_ChatTime = UI.getChildControl(Panel_ChatOption, "CheckButton_ChatTime")
_checkButton_ChatTime:SetEnableArea(0, 0, _checkButton_ChatTime:GetSizeX() + _checkButton_ChatTime:GetTextSizeX() + 3, _checkButton_ChatTime:GetSizeY())
_checkButton_ChatTime:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 30)")
_checkButton_ChatTime:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
local _prevIsCheckChatTime = {}
local btnFilter = Array.new()
local btnSystemFilter = Array.new()
local chatPanel = Array.new()
for i = 0, chatOptionData.makeChatPanelCount - 1 do
  chatPanel[i] = false
end
local ChattingAnimationTitleBg = UI.getChildControl(Panel_ChatOption, "Static_AnimationTitleBg")
local ChattingAnimationOptionBg = UI.getChildControl(Panel_ChatOption, "Static_AnimationOptionBg")
local rdo_ChattingAnimationOn = UI.getChildControl(ChattingAnimationOptionBg, "RadioButton_AnimationOn")
local rdo_ChattingAnimationOff = UI.getChildControl(ChattingAnimationOptionBg, "RadioButton_AnimationOff")
local preChattingAnimation = true
local preUseHarfBuzz
local ApplyHarfBuzzTitleBg = UI.getChildControl(Panel_ChatOption, "Static_TurkeyOnlyTitleBg")
local ApplyHarfBuzzOptionBg = UI.getChildControl(Panel_ChatOption, "Static_TurkeyOnlyOptionBg")
local rdo_HarfBuzzOptionOn = UI.getChildControl(ApplyHarfBuzzOptionBg, "RadioButton_ArabicOn")
local rdo_HarfBuzzOptionOff = UI.getChildControl(ApplyHarfBuzzOptionBg, "RadioButton_ArabicOff")
local UseEmoticonAutoPlayTitleBg = UI.getChildControl(Panel_ChatOption, "Static_EmoticonTitleBg")
local UseEmoticonAutoPlayOptionBg = UI.getChildControl(Panel_ChatOption, "Static_EmoticonOptionBg")
local btn_EmoticonAutoPlayOn = UI.getChildControl(UseEmoticonAutoPlayOptionBg, "RadioButton_EmoticonOn")
local btn_EmoticonAutoPlayOff = UI.getChildControl(UseEmoticonAutoPlayOptionBg, "RadioButton_EmoticonOff")
local _isUseEmoticonAutoPlay
function HandleClicked_ChattingTypeFilter_Notice(panelIdex)
  local self = chatOptionData
  local check = btnFilter[eChatButtonType.eChatNotice].chatFilter:IsCheck()
  channel_Notice = check
  TooltipSimple_Hide()
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingTypeFilter_WorldWithItem(panelIdex)
  local self = chatOptionData
  local check = btnFilter[eChatButtonType.eChatWorldWithItem].chatFilter:IsCheck()
  channel_WorldWithItem = check
  TooltipSimple_Hide()
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingTypeFilter_World(panelIdex)
  local self = chatOptionData
  local check = btnFilter[eChatButtonType.eChatWorld].chatFilter:IsCheck()
  channel_World = check
  TooltipSimple_Hide()
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingTypeFilter_Guild(panelIdex)
  local self = chatOptionData
  local check = btnFilter[eChatButtonType.eChatGuild].chatFilter:IsCheck()
  channel_Guild = check
  TooltipSimple_Hide()
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingTypeFilter_Battle(panelIndex)
  local self = chatOptionData
  local check = btnFilter[eChatButtonType.eChatBattle].chatFilter:IsCheck()
  channel_Battle = check
  TooltipSimple_Hide()
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingTypeFilter_Party(panelIdex)
  local self = chatOptionData
  local check = btnFilter[eChatButtonType.eChatParty].chatFilter:IsCheck()
  channel_Party = check
  TooltipSimple_Hide()
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingTypeFilter_Public(panelIdex)
  local self = chatOptionData
  local check = btnFilter[eChatButtonType.eChatPublic].chatFilter:IsCheck()
  channel_Public = check
  TooltipSimple_Hide()
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingTypeFilter_RolePlay(panelIndex)
  local self = chatOptionData
  local check = btnFilter[eChatButtonType.eChatRolePlay].chatFilter:IsCheck()
  channel_RolePlay = check
  TooltipSimple_Hide()
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingTypeFilter_Private(panelIdex)
  local self = chatOptionData
  local check = btnFilter[eChatButtonType.eChatPrivate].chatFilter:IsCheck()
  channel_Private = check
  TooltipSimple_Hide()
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingTypeFilter_Arsha(panelIdex)
  local self = chatOptionData
  local check = btnFilter[eChatButtonType.eChatArsha].chatFilter:IsCheck()
  channel_Arsha = check
  TooltipSimple_Hide()
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingTypeFilter_Team(panelIdex)
  local self = chatOptionData
  local check = btnFilter[eChatButtonType.eChatTeam].chatFilter:IsCheck()
  channel_Team = check
  TooltipSimple_Hide()
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingTypeFilter_Alliance(panelIdex)
  local self = chatOptionData
  local check = btnFilter[eChatButtonType.eChatAlliance].chatFilter:IsCheck()
  channel_Alliance = check
  TooltipSimple_Hide()
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingColor_Notice(panelIndex)
  local self = chatOptionData
  local checkColor = btnFilter[eChatButtonType.eChatNotice].chatColor:SetColor(UI_color.C_FFFFEF82)
  color_Notice = checkColor
  FGlobal_ChattingColor_GetColor(panelIndex, UI_CT.Notice, eChatButtonType.eChatNotice, false)
  TooltipSimple_Hide()
end
function HandleClicked_ChattingColor_WorldWithItem(panelIndex)
  local self = chatOptionData
  local checkColor = btnFilter[eChatButtonType.eChatWorldWithItem].chatColor:SetColor(UI_color.C_FF00F3A0)
  color_WorldWithItem = checkColor
  FGlobal_ChattingColor_GetColor(panelIndex, UI_CT.WorldWithItem, eChatButtonType.eChatWorldWithItem, false)
  TooltipSimple_Hide()
end
function HandleClicked_ChattingColor_World(panelIndex)
  local self = chatOptionData
  local checkColor = btnFilter[eChatButtonType.eChatWorld].chatColor:SetColor(UI_color.C_FFFF973A)
  color_World = checkColor
  FGlobal_ChattingColor_GetColor(panelIndex, UI_CT.World, eChatButtonType.eChatWorld, false)
  TooltipSimple_Hide()
end
function HandleClicked_ChattingColor_Guild(panelIndex)
  local self = chatOptionData
  local chat = ToClient_getChattingPanel(panelIndex)
  local checkColor = chat:getChatColorIndex(UI_CT.Guild)
  color_Guild = FGlobal_ColorList(checkColor)
  FGlobal_ChattingColor_GetColor(panelIndex, UI_CT.Guild, eChatButtonType.eChatGuild, false)
  TooltipSimple_Hide()
end
function HandleClicked_ChattingColor_Party(panelIndex)
  local self = chatOptionData
  local checkColor = btnFilter[eChatButtonType.eChatParty].chatColor:SetColor(UI_color.C_FF8EBD00)
  color_Party = checkColor
  FGlobal_ChattingColor_GetColor(panelIndex, UI_CT.Party, eChatButtonType.eChatParty, false)
  TooltipSimple_Hide()
end
function HandleClicked_ChattingColor_Public(panelIndex)
  local self = chatOptionData
  local checkColor = btnFilter[eChatButtonType.eChatPublic].chatColor:SetColor(UI_color.C_FFE7E7E7)
  color_Public = checkColor
  FGlobal_ChattingColor_GetColor(panelIndex, UI_CT.Public, eChatButtonType.eChatPublic, false)
  TooltipSimple_Hide()
end
function HandleClicked_ChattingColor_RolePlay(panelIndex)
  local self = chatOptionData
  local checkColor = btnFilter[eChatButtonType.eChatRolePlay].chatColor:SetColor(UI_color.C_FF00B4FF)
  color_RolePlay = checkColor
  FGlobal_ChattingColor_GetColor(panelIndex, UI_CT.RolePlay, eChatButtonType.eChatRolePlay, false)
  TooltipSimple_Hide()
end
function HandleClicked_ChattingColor_Private(panelIndex)
  local self = chatOptionData
  local checkColor = btnFilter[eChatButtonType.eChatPrivate].chatColor:SetColor(UI_color.C_FFF601FF)
  color_Private = checkColor
  FGlobal_ChattingColor_GetColor(panelIndex, UI_CT.Private, eChatButtonType.eChatPrivate, false)
  TooltipSimple_Hide()
end
function HandleClicked_ChattingColor_Arsha(panelIndex)
  local self = chatOptionData
  local checkColor = btnFilter[eChatButtonType.eChatArsha].chatColor:SetColor(UI_color.C_FFFFD237)
  color_Arsha = checkColor
  FGlobal_ChattingColor_GetColor(panelIndex, UI_CT.Arsha, eChatButtonType.eChatArsha, false)
  TooltipSimple_Hide()
end
function HandleClicked_ChattingColor_Team(panelIndex)
  local self = chatOptionData
  local checkColor = btnFilter[eChatButtonType.eChatTeam].chatColor:SetColor(UI_color.C_FFB97FEF)
  color_Team = checkColor
  FGlobal_ChattingColor_GetColor(panelIndex, UI_CT.Team, eChatButtonType.eChatTeam, false)
  TooltipSimple_Hide()
end
function HandleClicked_ChattingColor_Alliance(panelIndex)
  local self = chatOptionData
  local checkColor = btnFilter[eChatButtonType.eChatAlliance].chatColor:SetColor(color_Alliance)
  color_Team = checkColor
  FGlobal_ChattingColor_GetColor(panelIndex, UI_CT.Alliance, eChatButtonType.eChatAlliance, false)
  TooltipSimple_Hide()
end
function HandleClicked_ChattingColor_MainSystem(panelIndex)
  local self = chatOptionData
  FGlobal_ChattingColor_GetColor(panelIndex, UI_CT.System, 0, true)
  TooltipSimple_Hide()
end
function HandleClicked_ChattingDivision()
  local isCheck = _check_Division:IsCheck()
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eChatDivision, isCheck, CppEnums.VariableStorageType.eVariableStorageType_User)
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChatTime(panelIndex)
  local isCheck = _checkButton_ChatTime:IsCheck()
  FGlobal_ChatOption_SetIsShowTimeString(panelIndex, isCheck)
end
function FGlobal_ChatOption_HandleChattingOptionInitialize(panelIndex)
  local currentIsCheckChatTime = FGlobal_ChatOption_GetIsShowTimeString(panelIndex)
  _checkButton_ChatTime:SetCheck(currentIsCheckChatTime)
  _checkButton_ChatTime:addInputEvent("Mouse_LUp", "HandleClicked_ChatTime(" .. panelIndex .. ")")
  local chatCount = ToClient_getChattingPanelCount()
  for ii = 0, chatCount - 1 do
    _prevIsCheckChatTime[ii] = FGlobal_ChatOption_GetIsShowTimeString(ii)
  end
end
function FGlobal_ChatOption_EmoticonInitialize(panelIndex)
  if false == _ContentsGroup_Emoticon then
    UseEmoticonAutoPlayTitleBg:SetShow(false)
    UseEmoticonAutoPlayOptionBg:SetShow(false)
    return
  end
  local chatPanel = ToClient_getChattingPanel(panelIndex)
  if nil == chatPanel then
    return
  end
  local offsetY = 70
  Panel_ChatOption:SetSize(Panel_ChatOption:GetSizeX(), Panel_ChatOption:GetSizeY() + offsetY)
  _button_blockList:SetPosY(_button_blockList:GetPosY() + offsetY)
  _button_resetColor:SetPosY(_button_resetColor:GetPosY() + offsetY)
  _button_Confirm:SetPosY(_button_Confirm:GetPosY() + offsetY)
  _button_Cancle:SetPosY(_button_Cancle:GetPosY() + offsetY)
  UseEmoticonAutoPlayTitleBg:SetShow(true)
  UseEmoticonAutoPlayOptionBg:SetShow(true)
  _isUseEmoticonAutoPlay = chatPanel:getUseEmoticonAutoPlay()
  UseEmoticonAutoPlayTitleBg:ComputePos()
  UseEmoticonAutoPlayOptionBg:ComputePos()
  btn_EmoticonAutoPlayOn:SetEnableArea(0, 0, btn_EmoticonAutoPlayOn:GetSizeX() + btn_EmoticonAutoPlayOn:GetTextSizeX() + 3, btn_EmoticonAutoPlayOn:GetSizeY())
  btn_EmoticonAutoPlayOff:SetEnableArea(0, 0, btn_EmoticonAutoPlayOff:GetSizeX() + btn_EmoticonAutoPlayOff:GetTextSizeX() + 3, btn_EmoticonAutoPlayOff:GetSizeY())
  btn_EmoticonAutoPlayOn:ComputePos()
  btn_EmoticonAutoPlayOn:addInputEvent("Mouse_LUp", "PaGlobal_ChattingOption_setEmoticonAutoPlay(" .. panelIndex .. ", true )")
  btn_EmoticonAutoPlayOn:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 31)")
  btn_EmoticonAutoPlayOn:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
  btn_EmoticonAutoPlayOn:SetCheck(_isUseEmoticonAutoPlay)
  btn_EmoticonAutoPlayOff:ComputePos()
  btn_EmoticonAutoPlayOff:addInputEvent("Mouse_LUp", "PaGlobal_ChattingOption_setEmoticonAutoPlay(" .. panelIndex .. ", false )")
  btn_EmoticonAutoPlayOff:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 32)")
  btn_EmoticonAutoPlayOff:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
  btn_EmoticonAutoPlayOff:SetCheck(not _isUseEmoticonAutoPlay)
end
function setEnableSystemChildButton(enabled)
  local self = chatOptionData
  local check = btnSystemFilter[eChatSystemButtonType.eChatSystem].chatFilter:IsCheck()
  for idx = 1, self.chatSystemFilterCount - 1 do
    btnSystemFilter[idx].chatFilter:SetIgnore(not enabled)
    if not check then
      btnSystemFilter[idx].chatFilter:SetCheck(false)
    end
    if enabled then
      btnSystemFilter[idx].chatFilter:SetFontColor(UI_color.C_FFC4BEBE)
    end
  end
end
function HandleClicked_ChattingTypeFilter_System(panelIdex)
  local self = chatOptionData
  local check = btnSystemFilter[eChatSystemButtonType.eChatSystem].chatFilter:IsCheck()
  channel_System = check
  for idx = 1, self.chatSystemFilterCount - 1 do
    if check then
      btnSystemFilter[idx].chatFilter:SetCheck(true)
      channel_SystemUndefine = true
      channel_SystemPrivateItem = true
      channel_SystemPartyItem = true
      channel_SystemMarket = true
      channel_SystemWorker = true
      channel_SystemHarvest = true
    else
      btnSystemFilter[idx].chatFilter:SetCheck(false)
    end
  end
  setEnableSystemChildButton(check)
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingSystemTypeFilter_Undefine(panelIndex)
  local self = chatOptionData
  local check = btnSystemFilter[eChatSystemButtonType.eChatSystemUndefine].chatFilter:IsCheck()
  channel_SystemUndefine = check
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingSystemTypeFilter_PrivateItem(panelIndex)
  local self = chatOptionData
  local check = btnSystemFilter[eChatSystemButtonType.eChatSystemPrivateItem].chatFilter:IsCheck()
  channel_SystemPrivateItem = check
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingSystemTypeFilter_PartyItem(panelIndex)
  local self = chatOptionData
  local check = btnSystemFilter[eChatSystemButtonType.eChatSystemPartyItem].chatFilter:IsCheck()
  channel_SystemPartyItem = check
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingSystemTypeFilter_Market(panelIndex)
  local self = chatOptionData
  local check = btnSystemFilter[eChatSystemButtonType.eChatSystemMarket].chatFilter:IsCheck()
  channel_SystemMarket = check
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingSystemTypeFilter_Worker(panelIndex)
  local self = chatOptionData
  local check = btnSystemFilter[eChatSystemButtonType.eChatSystemWorker].chatFilter:IsCheck()
  channel_SystemWorker = check
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingSystemTypeFilter_Harvest(panelIndex)
  local self = chatOptionData
  local check = btnSystemFilter[eChatSystemButtonType.eChatSystemHarvest].chatFilter:IsCheck()
  channel_SystemHarvest = check
  RegisterUpdate_ChatOption()
end
function createCheckBoxButton(btnObject, buttonName, buttonText, isCheck, posX, posY, fontColor, index)
  btnObject.chatFilter = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, _msgFilter_BG, buttonName)
  CopyBaseProperty(msgFilter_Chkbox, btnObject.chatFilter)
  btnObject.chatFilter:SetText(buttonText)
  btnObject.chatFilter:SetCheck(isCheck)
  btnObject.chatFilter:SetPosX(posX)
  btnObject.chatFilter:SetPosY(posY)
  btnObject.chatFilter:SetFontColor(fontColor)
  btnObject.chatFilter:SetEnableArea(0, 0, btnObject.chatFilter:GetSizeX() + btnObject.chatFilter:GetTextSizeX() + 3, btnObject.chatFilter:GetSizeY())
  btnObject.chatFilter:SetShow(true)
end
function createRadioButton(btnObject, buttonName, posX, posY, setColor, index)
  btnObject.chatColor = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, _msgFilter_BG, buttonName)
  CopyBaseProperty(onlySystemSelectColor, btnObject.chatColor)
  btnObject.chatColor:SetPosX(posX)
  btnObject.chatColor:SetPosY(posY)
  btnObject.chatColor:SetShow(true)
end
local optionCount = 0
function ChattingOption_Initialize(panelIdex, _transparency, isCombinedMainPanel)
  local self = chatOptionData
  _ChatOption_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHATTING_OPTION_TITLE", "panel_Index", panelIdex + 1))
  local chat = ToClient_getChattingPanel(panelIdex)
  selectColor_btn:SetShow(false)
  onlySystemSelectColor:SetShow(false)
  local index = 0
  if not chatPanel[panelIdex] then
    local optionCount = 0
    local idx = 0
    chatFilter_Initialize(panelIdex, self, chat)
    local posX = 0
    local posY = 0
    for idx = 0, self.chatSystemFilterCount - 1 do
      posX = self.slotSystemTypeStartX
      posY = self.slotSystemTypeStartY + idx * self.slotGapY
      btnSystemFilter[idx] = {}
      if eChatSystemButtonType.eChatSystem == idx then
        createCheckBoxButton(btnSystemFilter[idx], "ChatSystemOption_Btn_" .. idx .. "_" .. panelIdex, PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_SYSTEM"), chat:isShowChatType(UI_CT.System), posX, posY, UI_color.C_FFEFEFEF, idx)
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingTypeFilter_System( " .. panelIdex .. " )")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 11, " .. idx .. ")")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
        createRadioButton(btnSystemFilter[idx], "ChatSystemOption_Color_" .. idx .. "_" .. panelIdex, posX, posY, UI_color.C_FFEFEFEF, idx)
        local chatColorIndex = chat:getChatSystemColorIndex(UI_CT.System)
        if -1 == chatColorIndex then
          btnSystemFilter[idx].chatFilter:SetFontColor(UI_color.C_FFC4BEBE)
          btnSystemFilter[idx].chatColor:SetColor(UI_color.C_FFC4BEBE)
        else
          btnSystemFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
          btnSystemFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
        end
        btnSystemFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_MainSystem( " .. panelIdex .. " )")
        btnSystemFilter[idx].chatColor:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 98, " .. idx .. ")")
        btnSystemFilter[idx].chatColor:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
        btnSystemFilter[idx].chatColor:SetPosY(posY)
        btnSystemFilter[idx].chatColor:SetPosX(btnSystemFilter[idx].chatFilter:GetPosX() + btnSystemFilter[idx].chatFilter:GetSizeX() + btnSystemFilter[idx].chatFilter:GetTextSizeX() + 10)
      elseif eChatSystemButtonType.eChatSystemUndefine == idx then
        createCheckBoxButton(btnSystemFilter[idx], "ChatSystemOption_Btn_" .. idx .. "_" .. panelIdex, PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_TAB_SYSTEM_UNDEFINE"), chat:isShowChatSystemType(UI_CST.Undefine), posX + self.slotSystemTypeChildButtonGapX, posY, UI_color.C_FFC4BEBE)
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingSystemTypeFilter_Undefine( " .. panelIdex .. " )")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 12, " .. idx .. ")")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
      elseif eChatSystemButtonType.eChatSystemPrivateItem == idx then
        createCheckBoxButton(btnSystemFilter[idx], "ChatSystemOption_Btn_" .. idx .. "_" .. panelIdex, PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_TAB_SYSTEM_PRIVATEITEM"), chat:isShowChatSystemType(UI_CST.PrivateItem), posX + self.slotSystemTypeChildButtonGapX, posY, UI_color.C_FFC4BEBE)
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingSystemTypeFilter_PrivateItem( " .. panelIdex .. " )")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 13, " .. idx .. ")")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
      elseif eChatSystemButtonType.eChatSystemPartyItem == idx then
        createCheckBoxButton(btnSystemFilter[idx], "ChatSystemOption_Btn_" .. idx .. "_" .. panelIdex, PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_TAB_SYSTEM_PARTYITEM"), chat:isShowChatSystemType(UI_CST.PartyItem), posX + self.slotSystemTypeChildButtonGapX, posY, UI_color.C_FFC4BEBE)
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingSystemTypeFilter_PartyItem( " .. panelIdex .. " )")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 14, " .. idx .. ")")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
      elseif eChatSystemButtonType.eChatSystemMarket == idx then
        createCheckBoxButton(btnSystemFilter[idx], "ChatSystemOption_Btn_" .. idx .. "_" .. panelIdex, PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_TAB_SYSTEM_MARKET"), chat:isShowChatSystemType(UI_CST.Market), posX + self.slotSystemTypeChildButtonGapX, posY, UI_color.C_FFC4BEBE)
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingSystemTypeFilter_Market( " .. panelIdex .. " )")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 15, " .. idx .. ")")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
      elseif eChatSystemButtonType.eChatSystemWorker == idx then
        createCheckBoxButton(btnSystemFilter[idx], "ChatSystemOption_Btn_" .. idx .. "_" .. panelIdex, PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_TAB_SYSTEM_WORKER"), chat:isShowChatSystemType(UI_CST.Worker), posX + self.slotSystemTypeChildButtonGapX, posY, UI_color.C_FFC4BEBE)
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingSystemTypeFilter_Worker( " .. panelIdex .. " )")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 16, " .. idx .. ")")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
      elseif eChatSystemButtonType.eChatSystemHarvest == idx then
        createCheckBoxButton(btnSystemFilter[idx], "ChatSystemOption_Btn_" .. idx .. "_" .. panelIdex, PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_TAB_SYSTEM_HARVEST"), chat:isShowChatSystemType(UI_CST.Harvest), posX + self.slotSystemTypeChildButtonGapX, posY, UI_color.C_FFC4BEBE)
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingSystemTypeFilter_Harvest( " .. panelIdex .. " )")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 17, " .. idx .. ")")
        btnSystemFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
      else
        _PA_LOG("\234\185\128\237\152\149\236\154\177", "\236\178\152\235\166\172\235\144\152\236\167\128 \236\149\138\236\157\128 eChatSystemButtonType Index : " .. idx)
      end
    end
    chatPanel[panelIdex] = true
  end
  for idx = 0, self.chatFilterCount - 1 do
    if eChatButtonType.eChatNotice == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Notice)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFFFEF82)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FFFFEF82)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
      btnFilter[idx].chatColor:SetPosX(btnFilter[idx].chatFilter:GetPosX() + btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 10)
      btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_Notice(" .. panelIdex .. ")")
      btnFilter[idx].chatColor:SetShow(true)
    elseif eChatButtonType.eChatWorldWithItem == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.WorldWithItem)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FF00F3A0)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FF00F3A0)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
      btnFilter[idx].chatColor:SetPosX(btnFilter[idx].chatFilter:GetPosX() + btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 10)
      btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_WorldWithItem( " .. panelIdex .. ")")
      btnFilter[idx].chatColor:SetShow(true)
    elseif eChatButtonType.eChatWorld == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.World)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFFF973A)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FFFF973A)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
      btnFilter[idx].chatColor:SetPosX(btnFilter[idx].chatFilter:GetPosX() + btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 10)
      btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_World( " .. panelIdex .. ")")
      btnFilter[idx].chatColor:SetShow(true)
    elseif eChatButtonType.eChatGuild == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Guild)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FF84FFF5)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FF84FFF5)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
      btnFilter[idx].chatColor:SetPosX(btnFilter[idx].chatFilter:GetPosX() + btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 10)
      btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_Guild( " .. panelIdex .. ")")
      btnFilter[idx].chatColor:SetShow(true)
    elseif eChatButtonType.eChatParty == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Party)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FF8EBD00)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FF8EBD00)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
      btnFilter[idx].chatColor:SetPosX(btnFilter[idx].chatFilter:GetPosX() + btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 10)
      btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_Party( " .. panelIdex .. ")")
      btnFilter[idx].chatColor:SetShow(true)
    elseif eChatButtonType.eChatPublic == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Public)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFE7E7E7)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FFE7E7E7)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
      btnFilter[idx].chatColor:SetPosX(btnFilter[idx].chatFilter:GetPosX() + btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 10)
      btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_Public( " .. panelIdex .. " )")
      btnFilter[idx].chatColor:SetShow(true)
    elseif eChatButtonType.eChatRolePlay == idx then
      if roleplayTypeOpen then
        local chatColorIndex = chat:getChatColorIndex(UI_CT.RolePlay)
        if -1 == chatColorIndex then
          btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FF00B4FF)
          btnFilter[idx].chatColor:SetColor(UI_color.C_FF00B4FF)
        else
          btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
          btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
        end
        btnFilter[idx].chatColor:SetPosX(btnFilter[idx].chatFilter:GetPosX() + btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 10)
        btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_RolePlay( " .. panelIdex .. " )")
        btnFilter[idx].chatColor:SetShow(true)
      end
    elseif eChatButtonType.eChatPrivate == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Private)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFF601FF)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FFF601FF)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
      btnFilter[idx].chatColor:SetPosX(btnFilter[idx].chatFilter:GetPosX() + btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 10)
      btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_Private( " .. panelIdex .. " )")
      btnFilter[idx].chatColor:SetShow(true)
    elseif eChatButtonType.eChatArsha == idx then
      if isArshaOpen then
        local chatColorIndex = chat:getChatColorIndex(UI_CT.Arsha)
        if -1 == chatColorIndex then
          btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFFFD237)
          btnFilter[idx].chatColor:SetColor(UI_color.C_FFFFD237)
        else
          btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
          btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
        end
        btnFilter[idx].chatColor:SetPosX(btnFilter[idx].chatFilter:GetPosX() + btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 10)
        btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_Arsha( " .. panelIdex .. ")")
        btnFilter[idx].chatColor:SetShow(true)
      end
    elseif eChatButtonType.eChatTeam == idx then
      if isArshaOpen or isLocalWarOpen or isSavageDefenceOpen then
        local chatColorIndex = chat:getChatColorIndex(UI_CT.Team)
        if -1 == chatColorIndex then
          btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFB97FEF)
          btnFilter[idx].chatColor:SetColor(UI_color.C_FFB97FEF)
        else
          btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
          btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
        end
        btnFilter[idx].chatColor:SetPosX(btnFilter[idx].chatFilter:GetPosX() + btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 10)
        btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_Team( " .. panelIdex .. ")")
        btnFilter[idx].chatColor:SetShow(true)
      end
    elseif eChatButtonType.eChatAlliance == idx and _ContentsGroup_guildAlliance then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Alliance)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(color_Alliance)
        btnFilter[idx].chatColor:SetColor(color_Alliance)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
      btnFilter[idx].chatColor:SetPosX(btnFilter[idx].chatFilter:GetPosX() + btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 10)
      btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_Alliance( " .. panelIdex .. ")")
      btnFilter[idx].chatColor:SetShow(true)
    end
  end
  local optionLineCount = math.ceil(optionCount / self._slotsCols)
  local lineGapY = 40
  if optionLineCount < self.chatSystemFilterCount then
    optionLineCount = self.chatSystemFilterCount
  end
  if optionLineCount < 5 then
    optionLineCount = 5
  end
  Panel_ChatOption:SetSize(Panel_ChatOption:GetSizeX(), panelSizeY + (optionLineCount - 5) * lineGapY)
  _msgFilter_BG:SetSize(_msgFilter_BG:GetSizeX(), msgFilterBg_SizeY + (optionLineCount - 5) * lineGapY)
  _button_Confirm:SetPosY(buttonSizeY + (optionLineCount - 5) * lineGapY)
  _button_Cancle:SetPosY(buttonSizeY + (optionLineCount - 5) * lineGapY)
  _button_blockList:SetPosY(buttonSizeY + (optionLineCount - 5) * lineGapY)
  _button_resetColor:SetPosY(buttonSizeY + (optionLineCount - 5) * lineGapY)
  fontSizeTitleBg:ComputePos()
  fontSizeBG:SetSize(fontSizeBG:GetSizeX(), 35)
  fontSizeBG:ComputePos()
  rdo_FontSizeSmall:ComputePos()
  rdo_FontSizeSmall2:ComputePos()
  rdo_FontSizeNormal:ComputePos()
  rdo_FontSizeNormal2:ComputePos()
  rdo_FontSizeBig:ComputePos()
  stringHeadTitleBg:ComputePos()
  stringHeadBg:ComputePos()
  btnFilter[eChatButtonType.eChatNotice].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Notice))
  btnFilter[eChatButtonType.eChatWorldWithItem].chatFilter:SetCheck(chat:isShowChatType(UI_CT.WorldWithItem))
  btnFilter[eChatButtonType.eChatWorld].chatFilter:SetCheck(chat:isShowChatType(UI_CT.World))
  btnFilter[eChatButtonType.eChatParty].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Party))
  btnFilter[eChatButtonType.eChatPublic].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Public))
  btnFilter[eChatButtonType.eChatGuild].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Guild))
  btnFilter[eChatButtonType.eChatPrivate].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Private))
  btnFilter[eChatButtonType.eChatBattle].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Battle))
  if isArshaOpen then
    btnFilter[eChatButtonType.eChatArsha].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Arsha))
    btnFilter[eChatButtonType.eChatTeam].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Team))
  end
  if roleplayTypeOpen then
    btnFilter[eChatButtonType.eChatRolePlay].chatFilter:SetCheck(chat:isShowChatType(UI_CT.RolePlay))
  end
  if _ContentsGroup_guildAlliance then
    btnFilter[eChatButtonType.eChatAlliance].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Alliance))
  end
  btnSystemFilter[eChatSystemButtonType.eChatSystem].chatFilter:SetCheck(chat:isShowChatType(UI_CT.System))
  btnSystemFilter[eChatSystemButtonType.eChatSystemUndefine].chatFilter:SetCheck(chat:isShowChatSystemType(UI_CST.Undefine))
  btnSystemFilter[eChatSystemButtonType.eChatSystemPrivateItem].chatFilter:SetCheck(chat:isShowChatSystemType(UI_CST.PrivateItem))
  btnSystemFilter[eChatSystemButtonType.eChatSystemPartyItem].chatFilter:SetCheck(chat:isShowChatSystemType(UI_CST.PartyItem))
  btnSystemFilter[eChatSystemButtonType.eChatSystemMarket].chatFilter:SetCheck(chat:isShowChatSystemType(UI_CST.Market))
  btnSystemFilter[eChatSystemButtonType.eChatSystemWorker].chatFilter:SetCheck(chat:isShowChatSystemType(UI_CST.Worker))
  btnSystemFilter[eChatSystemButtonType.eChatSystemHarvest].chatFilter:SetCheck(chat:isShowChatSystemType(UI_CST.Harvest))
  channel_Notice = chat:isShowChatType(UI_CT.Notice)
  channel_World = chat:isShowChatType(UI_CT.World)
  channel_Public = chat:isShowChatType(UI_CT.Public)
  channel_Private = chat:isShowChatType(UI_CT.Private)
  channel_Party = chat:isShowChatType(UI_CT.Party)
  channel_Guild = chat:isShowChatType(UI_CT.Guild)
  channel_WorldWithItem = chat:isShowChatType(UI_CT.WorldWithItem)
  channel_Battle = chat:isShowChatType(UI_CT.Battle)
  channel_Arsha = chat:isShowChatType(UI_CT.Arsha)
  channel_Team = chat:isShowChatType(UI_CT.Team)
  channel_Alliance = chat:isShowChatType(UI_CT.Alliance)
  if roleplayTypeOpen then
    channel_RolePlay = chat:isShowChatType(UI_CT.RolePlay)
  end
  channel_System = chat:isShowChatType(UI_CT.System)
  setEnableSystemChildButton(channel_System)
  channel_SystemUndefine = chat:isShowChatSystemType(UI_CST.Undefine)
  channel_SystemPrivateItem = chat:isShowChatSystemType(UI_CST.PrivateItem)
  channel_SystemPartyItem = chat:isShowChatSystemType(UI_CST.PartyItem)
  channel_SystemMarket = chat:isShowChatSystemType(UI_CST.Market)
  channel_SystemWorker = chat:isShowChatSystemType(UI_CST.Worker)
  channel_SystemHarvest = chat:isShowChatSystemType(UI_CST.Harvest)
  _alphaSlider_Control:addInputEvent("Mouse_LPress", "HandleClicked_ChattingSetTransparency(" .. panelIdex .. ")")
  _alphaSlider_ControlBTN:addInputEvent("Mouse_LPress", "HandleClicked_ChattingSetTransparency(" .. panelIdex .. ")")
  _alphaSlider_ControlBTN:SetPosX((_alphaSlider_Control:GetSizeX() - _alphaSlider_ControlBTN:GetSizeX()) / 100 * _transparency * 100)
  if true == isCombinedMainPanel and 0 ~= panelIdex then
    _alphaSlider_Control:SetEnable(false)
    _alphaSlider_Control:SetMonoTone(true)
    _alphaSlider_ControlBTN:SetEnable(false)
    _alphaSlider_ControlBTN:SetMonoTone(true)
    _alpha_0:SetShow(false)
    _alpha_50:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_OPTION_SUBPANEL_TRANSPARENCY_NOTIFY"))
    _alpha_100:SetShow(false)
  else
    _alphaSlider_Control:SetEnable(true)
    _alphaSlider_Control:SetMonoTone(false)
    _alphaSlider_ControlBTN:SetEnable(true)
    _alphaSlider_ControlBTN:SetMonoTone(false)
    _alpha_0:SetShow(true)
    _alpha_50:SetText("50%")
    _alpha_100:SetShow(true)
  end
  if not ToClient_getGameUIManagerWrapper():hasLuaCacheDataList(__eChatDivision) then
    _check_Division:SetCheck(true)
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eChatDivision, true, CppEnums.VariableStorageType.eVariableStorageType_User)
  else
    _check_Division:SetCheck(ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eChatDivision))
  end
  ChattingOption_InitailizeChattingAnimationControl()
  FGlobal_ChatOption_HandleChattingOptionInitialize(panelIdex)
  FGlobal_ChatOption_EmoticonInitialize(panelIdex)
  registEvent_Initialize(panelIdex)
end
function chatFilter_Initialize(panelIdex, self, chat)
  local idx = 0
  for idx = 0, self.chatFilterCount - 1 do
    local tempBtn = {}
    tempBtn.chatFilter = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, _msgFilter_BG, "ChatOption_Btn_" .. idx .. "_" .. panelIdex)
    CopyBaseProperty(msgFilter_Chkbox, tempBtn.chatFilter)
    tempBtn.chatFilter:SetShow(false)
    tempBtn.chatColor = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, _msgFilter_BG, "ChatOption_Color_Btn_" .. idx .. "_" .. panelIdex)
    CopyBaseProperty(selectColor_btn, tempBtn.chatColor)
    tempBtn.chatColor:SetShow(false)
    local isRoleplay = eChatButtonType.eChatRolePlay == idx and not roleplayTypeOpen
    if isGameTypeTaiwan() or isGameTypeJapan() then
      if idx >= 10 then
        if isArshaOpen then
          index = idx - 1
        else
          index = idx - 2
        end
      else
        index = idx
      end
    end
    if (isGameTypeKorea() or isGameTypeRussia()) and not isGameServiceTypeDev() then
      if idx >= 8 then
        index = idx - 1
      else
        index = idx
      end
    elseif isGameServiceTypeDev() or isGameTypeEnglish() then
      if idx >= 9 then
        if isLocalWarOpen or isArshaOpen then
          index = idx
        else
          index = idx - 1
        end
      else
        index = idx
      end
    elseif isGameTypeJapan() then
      if idx >= 8 then
        index = idx - 1
      else
        index = idx
      end
    elseif isGameTypeKR2() then
      index = idx
    elseif isGameTypeSA() then
      if idx >= 8 then
        index = idx - 1
      else
        index = idx
      end
    elseif isGameTypeTR() or isGameTypeTH() or isGameTypeID() then
      if idx >= 8 then
        index = idx - 1
      else
        index = idx
      end
    else
      index = idx
    end
    local row = math.floor(index / self._slotsCols)
    local col = index % self._slotsCols
    optionCount = index + 1
    tempBtn.chatFilter:SetPosX(self.slotStartX + self.slotGapX * col)
    tempBtn.chatFilter:SetPosY(self.slotStartY + self.slotGapY * row)
    btnFilter[idx] = tempBtn
    if eChatButtonType.eChatNotice == idx then
      btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFFFEF82)
      btnFilter[idx].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Notice))
      btnFilter[idx].chatFilter:SetText(PAGetString(Defines.StringSheet_GAME, "CHATTING_NOTICE"))
      btnFilter[idx].chatFilter:SetShow(true)
      btnFilter[idx].chatFilter:SetEnableArea(0, 0, btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 3, btnFilter[idx].chatFilter:GetSizeY())
      btnFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingTypeFilter_Notice( " .. panelIdex .. " )")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 0, " .. idx .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
    elseif eChatButtonType.eChatWorldWithItem == idx then
      btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FF00F3A0)
      btnFilter[idx].chatFilter:SetCheck(chat:isShowChatType(UI_CT.WorldWithItem))
      btnFilter[idx].chatFilter:SetText(PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_WORLD"))
      btnFilter[idx].chatFilter:SetShow(true)
      btnFilter[idx].chatFilter:SetEnableArea(0, 0, btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 3, btnFilter[idx].chatFilter:GetSizeY())
      btnFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingTypeFilter_WorldWithItem( " .. panelIdex .. " )")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 1, " .. idx .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
    elseif eChatButtonType.eChatWorld == idx then
      btnFilter[idx].chatFilter:SetCheck(chat:isShowChatType(UI_CT.World))
      btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFFF973A)
      btnFilter[idx].chatFilter:SetText(PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_SERVERGROUP"))
      btnFilter[idx].chatFilter:SetShow(true)
      btnFilter[idx].chatFilter:SetEnableArea(0, 0, btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 3, btnFilter[idx].chatFilter:GetSizeY())
      btnFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingTypeFilter_World( " .. panelIdex .. " )")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 2, " .. idx .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
    elseif eChatButtonType.eChatGuild == idx then
      btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FF84FFF5)
      btnFilter[idx].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Guild))
      btnFilter[idx].chatFilter:SetText(PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_GUILD"))
      btnFilter[idx].chatFilter:SetShow(true)
      btnFilter[idx].chatFilter:SetEnableArea(0, 0, btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 3, btnFilter[idx].chatFilter:GetSizeY())
      btnFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingTypeFilter_Guild( " .. panelIdex .. " )")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 3, " .. idx .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
    elseif eChatButtonType.eChatParty == idx then
      btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FF8EBD00)
      btnFilter[idx].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Party))
      btnFilter[idx].chatFilter:SetText(PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_PARTY"))
      btnFilter[idx].chatFilter:SetShow(true)
      btnFilter[idx].chatFilter:SetEnableArea(0, 0, btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 3, btnFilter[idx].chatFilter:GetSizeY())
      btnFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingTypeFilter_Party( " .. panelIdex .. " )")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 4, " .. idx .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
    elseif eChatButtonType.eChatBattle == idx then
      btnFilter[idx].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Battle))
      btnFilter[idx].chatFilter:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHATTING_OPTION_FILTER_BATTLE"))
      btnFilter[idx].chatFilter:SetShow(true)
      btnFilter[idx].chatFilter:SetEnableArea(0, 0, btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 3, btnFilter[idx].chatFilter:GetSizeY())
      btnFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingTypeFilter_Battle( " .. panelIdex .. " )")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 5, " .. idx .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
      btnFilter[idx].chatColor:SetShow(false)
      btnFilter[idx].chatColor:SetPosX(btnFilter[idx].chatFilter:GetPosX() + btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 10)
    elseif eChatButtonType.eChatPublic == idx then
      btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFE7E7E7)
      btnFilter[idx].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Public))
      btnFilter[idx].chatFilter:SetText(PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_GENERAL"))
      btnFilter[idx].chatFilter:SetShow(true)
      btnFilter[idx].chatFilter:SetEnableArea(0, 0, btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 3, btnFilter[idx].chatFilter:GetSizeY())
      btnFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingTypeFilter_Public( " .. panelIdex .. " )")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 6, " .. idx .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
    elseif eChatButtonType.eChatRolePlay == idx then
      btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FF00B4FF)
      btnFilter[idx].chatFilter:SetCheck(chat:isShowChatType(UI_CT.RolePlay))
      btnFilter[idx].chatFilter:SetText("RolePlay")
      btnFilter[idx].chatFilter:SetEnableArea(0, 0, btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 3, btnFilter[idx].chatFilter:GetSizeY())
      btnFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingTypeFilter_RolePlay( " .. panelIdex .. " )")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 7, " .. idx .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
      btnFilter[idx].chatFilter:SetShow(roleplayTypeOpen)
      btnFilter[idx].chatColor:SetShow(roleplayTypeOpen)
    elseif eChatButtonType.eChatPrivate == idx then
      btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFF601FF)
      btnFilter[idx].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Private))
      btnFilter[idx].chatFilter:SetText(PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_WHISPER"))
      btnFilter[idx].chatFilter:SetShow(true)
      btnFilter[idx].chatFilter:SetEnableArea(0, 0, btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 3, btnFilter[idx].chatFilter:GetSizeY())
      btnFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingTypeFilter_Private( " .. panelIdex .. " )")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 8, " .. idx .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
    elseif eChatButtonType.eChatArsha == idx then
      btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFFFD237)
      btnFilter[idx].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Arsha))
      btnFilter[idx].chatFilter:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHATTING_OPTION_FILTER_ARSHA"))
      btnFilter[idx].chatFilter:SetShow(isArshaOpen)
      btnFilter[idx].chatFilter:SetEnableArea(0, 0, btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 3, btnFilter[idx].chatFilter:GetSizeY())
      btnFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingTypeFilter_Arsha( " .. panelIdex .. " )")
      btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_Arsha( " .. panelIdex .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 9, " .. idx .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
    elseif eChatButtonType.eChatTeam == idx then
      btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFB97FEF)
      btnFilter[idx].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Team))
      btnFilter[idx].chatFilter:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHATTING_OPTION_FILTER_TEAM"))
      btnFilter[idx].chatFilter:SetShow(isArshaOpen or isLocalWarOpen or isSavageDefenceOpen)
      btnFilter[idx].chatFilter:SetEnableArea(0, 0, btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 3, btnFilter[idx].chatFilter:GetSizeY())
      btnFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingTypeFilter_Team( " .. panelIdex .. " )")
      btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_Team( " .. panelIdex .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 10, " .. idx .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
    elseif eChatButtonType.eChatAlliance == idx then
      btnFilter[idx].chatFilter:SetFontColor(color_Alliance)
      btnFilter[idx].chatFilter:SetCheck(chat:isShowChatType(UI_CT.Alliance))
      btnFilter[idx].chatFilter:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_TITLE"))
      btnFilter[idx].chatFilter:SetEnableArea(0, 0, btnFilter[idx].chatFilter:GetSizeX() + btnFilter[idx].chatFilter:GetTextSizeX() + 3, btnFilter[idx].chatFilter:GetSizeY())
      btnFilter[idx].chatFilter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingTypeFilter_Alliance( " .. panelIdex .. " )")
      btnFilter[idx].chatColor:addInputEvent("Mouse_LUp", "HandleClicked_ChattingColor_Alliance( " .. panelIdex .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 101, " .. idx .. ")")
      btnFilter[idx].chatFilter:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
      btnFilter[idx].chatFilter:SetShow(_ContentsGroup_guildAlliance)
      btnFilter[idx].chatColor:SetShow(_ContentsGroup_guildAlliance)
    end
    btnFilter[idx].chatColor:SetPosY(self.slotStartY + self.slotGapY * row)
    btnFilter[idx].chatColor:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 99, " .. idx .. ")")
    btnFilter[idx].chatColor:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
  end
end
function registEvent_Initialize(panelIdex)
  _button_resetColor:addInputEvent("Mouse_LUp", "HandledClicked_ChattingColorReset(" .. panelIdex .. ")")
  _button_resetColor:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 28)")
  _button_resetColor:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
  _button_Confirm:addInputEvent("Mouse_LUp", "HandleClicked_ChattingOption_SetFilter( " .. panelIdex .. " )")
  _button_Cancle:addInputEvent("Mouse_LUp", "ChattingOption_Close()")
  _button_Close:addInputEvent("Mouse_LUp", "ChattingOption_Close()")
  _button_blockList:addInputEvent("Mouse_LUp", "ChattingOption_ShowBlockList()")
  _button_blockList:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 27)")
  _button_blockList:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
  rdo_FontSizeSmall:addInputEvent("Mouse_LUp", "ChattingOption_SelectFontSize( 10 )")
  rdo_FontSizeSmall2:addInputEvent("Mouse_LUp", "ChattingOption_SelectFontSize( 12 )")
  rdo_FontSizeNormal:addInputEvent("Mouse_LUp", "ChattingOption_SelectFontSize( 14 )")
  rdo_FontSizeNormal2:addInputEvent("Mouse_LUp", "ChattingOption_SelectFontSize( 18 )")
  rdo_FontSizeBig:addInputEvent("Mouse_LUp", "ChattingOption_SelectFontSize( 20 )")
  rdo_FontSizeSmall:SetEnableArea(0, 0, rdo_FontSizeSmall:GetSizeX() + rdo_FontSizeSmall:GetTextSizeX() + 3, rdo_FontSizeSmall:GetSizeY())
  rdo_FontSizeSmall2:SetEnableArea(0, 0, rdo_FontSizeSmall2:GetSizeX() + rdo_FontSizeSmall2:GetTextSizeX() + 3, rdo_FontSizeSmall2:GetSizeY())
  rdo_FontSizeNormal:SetEnableArea(0, 0, rdo_FontSizeNormal:GetSizeX() + rdo_FontSizeNormal:GetTextSizeX() + 3, rdo_FontSizeNormal:GetSizeY())
  rdo_FontSizeNormal2:SetEnableArea(0, 0, rdo_FontSizeNormal2:GetSizeX() + rdo_FontSizeNormal2:GetTextSizeX() + 3, rdo_FontSizeNormal2:GetSizeY())
  rdo_FontSizeBig:SetEnableArea(0, 0, rdo_FontSizeBig:GetSizeX() + rdo_FontSizeBig:GetTextSizeX() + 3, rdo_FontSizeBig:GetSizeY())
  rdo_FontSizeSmall:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 18)")
  rdo_FontSizeSmall:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
  rdo_FontSizeSmall2:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 19)")
  rdo_FontSizeSmall2:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
  rdo_FontSizeNormal:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 20)")
  rdo_FontSizeNormal:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
  rdo_FontSizeNormal2:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 21)")
  rdo_FontSizeNormal2:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
  rdo_FontSizeBig:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 22)")
  rdo_FontSizeBig:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
end
function HandledClicked_ChattingColorReset(panelIndex)
  local self = chatOptionData
  local chat = ToClient_getChattingPanel(panelIndex)
  chat:setChatColor(UI_CT.Notice, -1)
  chat:setChatColor(UI_CT.World, -1)
  chat:setChatColor(UI_CT.Public, -1)
  chat:setChatColor(UI_CT.Private, -1)
  chat:setChatColor(UI_CT.Party, -1)
  chat:setChatColor(UI_CT.Guild, -1)
  chat:setChatColor(UI_CT.WorldWithItem, -1)
  chat:setChatColor(UI_CT.RolePlay, -1)
  chat:setChatColor(UI_CT.Arsha, -1)
  chat:setChatColor(UI_CT.Team, -1)
  chat:setChatColor(UI_CT.Alliance, -1)
  chat:setChatSystemColorIndex(UI_CT.System, -1)
  if eChatSystemButtonType.eChatSystem == 0 then
    local chatColorIndex = chat:getChatSystemColorIndex(UI_CT.System)
    if -1 == chatColorIndex then
      btnSystemFilter[0].chatFilter:SetFontColor(UI_color.C_FFC4BEBE)
      btnSystemFilter[0].chatColor:SetColor(UI_color.C_FFC4BEBE)
    else
      btnSystemFilter[0].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
      btnSystemFilter[0].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
    end
  end
  for idx = 0, self.chatFilterCount - 1 do
    if eChatButtonType.eChatNotice == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Notice)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFFFEF82)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FFFFEF82)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
    elseif eChatButtonType.eChatWorldWithItem == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.WorldWithItem)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FF00F3A0)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FF00F3A0)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
    elseif eChatButtonType.eChatWorld == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.World)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFFF973A)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FFFF973A)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
    elseif eChatButtonType.eChatGuild == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Guild)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FF84FFF5)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FF84FFF5)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
    elseif eChatButtonType.eChatParty == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Party)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FF8EBD00)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FF8EBD00)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
    elseif eChatButtonType.eChatPublic == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Public)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFE7E7E7)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FFE7E7E7)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
    elseif eChatButtonType.eChatRolePlay == idx then
      if roleplayTypeOpen then
        local chatColorIndex = chat:getChatColorIndex(UI_CT.RolePlay)
        if -1 == chatColorIndex then
          btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FF00B4FF)
          btnFilter[idx].chatColor:SetColor(UI_color.C_FF00B4FF)
        else
          btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
          btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
        end
      end
    elseif eChatButtonType.eChatPrivate == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Private)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFF601FF)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FFF601FF)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
    elseif eChatButtonType.eChatArsha == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Arsha)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFFFD237)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FFFFD237)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
    elseif eChatButtonType.eChatTeam == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Team)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(UI_color.C_FFB97FEF)
        btnFilter[idx].chatColor:SetColor(UI_color.C_FFB97FEF)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
    elseif eChatButtonType.eChatAlliance == idx then
      local chatColorIndex = chat:getChatColorIndex(UI_CT.Alliance)
      if -1 == chatColorIndex then
        btnFilter[idx].chatFilter:SetFontColor(color_Alliance)
        btnFilter[idx].chatColor:SetColor(color_Alliance)
      else
        btnFilter[idx].chatFilter:SetFontColor(FGlobal_ColorList(chatColorIndex))
        btnFilter[idx].chatColor:SetColor(FGlobal_ColorList(chatColorIndex))
      end
    end
  end
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingSetTransparency(penelIdex)
  local _transparency = _alphaSlider_ControlBTN:GetPosX() / (_alphaSlider_Control:GetSizeX() - _alphaSlider_ControlBTN:GetSizeX())
  FGlobal_Chatting_PanelTransparency(penelIdex, _transparency, true)
  RegisterUpdate_ChatOption()
end
function HandleClicked_ChattingOption_SetFilter(panelIdex)
  local chat = ToClient_getChattingPanel(panelIdex)
  chat:setShowChatType(UI_CT.Notice, channel_Notice)
  chat:setShowChatType(UI_CT.System, channel_System)
  chat:setShowChatType(UI_CT.World, channel_World)
  chat:setShowChatType(UI_CT.Public, channel_Public)
  chat:setShowChatType(UI_CT.Private, channel_Private)
  chat:setShowChatType(UI_CT.Party, channel_Party)
  chat:setShowChatType(UI_CT.Guild, channel_Guild)
  chat:setShowChatType(UI_CT.WorldWithItem, channel_WorldWithItem)
  chat:setShowChatType(UI_CT.Battle, channel_Battle)
  chat:setShowChatType(UI_CT.RolePlay, channel_RolePlay)
  chat:setShowChatType(UI_CT.Arsha, channel_Arsha)
  chat:setShowChatType(UI_CT.Team, channel_Team)
  chat:setShowChatType(UI_CT.Alliance, channel_Alliance)
  chat:setShowChatSystemType(UI_CST.Undefine, channel_SystemUndefine)
  chat:setShowChatSystemType(UI_CST.PrivateItem, channel_SystemPrivateItem)
  chat:setShowChatSystemType(UI_CST.PartyItem, channel_SystemPartyItem)
  chat:setShowChatSystemType(UI_CST.Market, channel_SystemMarket)
  chat:setShowChatSystemType(UI_CST.Worker, channel_SystemWorker)
  chat:setShowChatSystemType(UI_CST.Harvest, channel_SystemHarvest)
  local count = ToClient_getChattingPanelCount()
  local currentFontSize = ToClient_getFontWrapper("BaseFont_10_Chat"):getFontSize()
  for panelIdx = 0, count - 1 do
    local chatPanel = ToClient_getChattingPanel(panelIdx)
    chatPanel:setChatFontSizeType(ChattingOption_convertFontSizeToChatFontType(currentFontSize))
  end
  prevFontSizeType = ChattingOption_convertFontSizeToChatFontType(currentFontSize)
  local _transparency = _alphaSlider_ControlBTN:GetPosX() / (_alphaSlider_Control:GetSizeX() - _alphaSlider_ControlBTN:GetSizeX())
  chat:setTransparency(_transparency)
  if panelIdex == 0 then
    for idx = 1, count - 1 do
      local chatPanel = ToClient_getChattingPanel(idx)
      if chatPanel:isCombinedToMainPanel() == true then
        FGlobal_Chatting_PanelTransparency(idx, _transparency, false)
      end
    end
  end
  FGlobal_ChatOption_SetIsShowTimeString(panelIdex, _checkButton_ChatTime:IsCheck())
  _prevIsCheckChatTime[panelIdex] = _checkButton_ChatTime:IsCheck()
  chat:setUseEmoticonAutoPlay(_isUseEmoticonAutoPlay)
  ToClient_SaveUiInfo(false)
  Panel_ChatOption:SetShow(false, false)
  Panel_ChatOption:SetIgnore(true)
  ChattingColor_Hide()
end
function FGlobal_ChattingOption_SettingColor(index, chatType, panelIndex, isSystem)
  if isSystem then
    btnSystemFilter[0].chatFilter:SetFontColor(FGlobal_ColorList(index))
    btnSystemFilter[0].chatColor:SetColor(FGlobal_ColorList(index))
  else
    btnFilter[chatType].chatFilter:SetFontColor(FGlobal_ColorList(index))
    btnFilter[chatType].chatColor:SetColor(FGlobal_ColorList(index))
  end
end
function ApplyHarfBuzzOption_Initialize()
  local currentUseHarfBuzz = ToClient_getUseHarfBuzz()
  preUseHarfBuzz = currentUseHarfBuzz
  local isShow = false
  if true == ToClient_IsDevelopment() then
    isShow = true
  else
    isShow = false
  end
  if true == isShow then
    local offsetY = 70
    Panel_ChatOption:SetSize(Panel_ChatOption:GetSizeX(), Panel_ChatOption:GetSizeY() + offsetY)
    ApplyHarfBuzzTitleBg:ComputePos()
    ApplyHarfBuzzOptionBg:ComputePos()
    rdo_HarfBuzzOptionOn:ComputePos()
    rdo_HarfBuzzOptionOff:ComputePos()
    rdo_HarfBuzzOptionOn:SetEnableArea(0, 0, rdo_HarfBuzzOptionOn:GetSizeX() + rdo_HarfBuzzOptionOn:GetTextSizeX() + 3, rdo_HarfBuzzOptionOn:GetSizeY())
    rdo_HarfBuzzOptionOff:SetEnableArea(0, 0, rdo_HarfBuzzOptionOff:GetSizeX() + rdo_HarfBuzzOptionOff:GetTextSizeX() + 3, rdo_HarfBuzzOptionOff:GetSizeY())
    _button_blockList:SetPosY(_button_blockList:GetPosY() + offsetY)
    _button_resetColor:SetPosY(_button_resetColor:GetPosY() + offsetY)
    _button_Confirm:SetPosY(_button_Confirm:GetPosY() + offsetY)
    _button_Cancle:SetPosY(_button_Cancle:GetPosY() + offsetY)
    if true == preUseHarfBuzz then
      rdo_HarfBuzzOptionOn:SetCheck(true)
      rdo_HarfBuzzOptionOff:SetCheck(false)
    else
      rdo_HarfBuzzOptionOn:SetCheck(false)
      rdo_HarfBuzzOptionOff:SetCheck(true)
    end
    rdo_HarfBuzzOptionOn:addInputEvent("Mouse_LUp", "FGlobal_SetUseHarfBuzz(true)")
    rdo_HarfBuzzOptionOff:addInputEvent("Mouse_LUp", "FGlobal_SetUseHarfBuzz(false)")
  end
  ApplyHarfBuzzTitleBg:SetShow(isShow)
  ApplyHarfBuzzOptionBg:SetShow(isShow)
  rdo_HarfBuzzOptionOn:SetShow(isShow)
  rdo_HarfBuzzOptionOff:SetShow(isShow)
end
function FGlobal_SetUseHarfBuzz(useHarfBuzz)
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  ToClient_setUseHarfBuzz(useHarfBuzz)
  FGlobal_ChattingcheckArabicType(useHarfBuzz)
  RegisterUpdate_ChatOption()
end
function ChattingOption_Open(penelIdex, drawPanelIndex, isCombinedMainPanel)
  if false == Panel_ChatOption:GetShow() then
    Panel_ChatOption:SetShow(true, true)
    Panel_ChatOption:SetSpanSize(0, 0)
    Panel_ChatOption:SetIgnore(false)
  end
  local thisFontSize = ToClient_getFontWrapper("BaseFont_10_Chat"):getFontSize()
  if 10 == thisFontSize then
    rdo_FontSizeSmall:SetCheck(true)
    rdo_FontSizeSmall2:SetCheck(false)
    rdo_FontSizeNormal:SetCheck(false)
    rdo_FontSizeNormal2:SetCheck(false)
    rdo_FontSizeBig:SetCheck(false)
  elseif 12 == thisFontSize then
    rdo_FontSizeSmall:SetCheck(false)
    rdo_FontSizeSmall2:SetCheck(true)
    rdo_FontSizeNormal:SetCheck(false)
    rdo_FontSizeNormal2:SetCheck(false)
    rdo_FontSizeBig:SetCheck(false)
  elseif 14 == thisFontSize then
    rdo_FontSizeSmall:SetCheck(false)
    rdo_FontSizeSmall2:SetCheck(false)
    rdo_FontSizeNormal:SetCheck(true)
    rdo_FontSizeNormal2:SetCheck(false)
    rdo_FontSizeBig:SetCheck(false)
  elseif 18 == thisFontSize then
    rdo_FontSizeSmall:SetCheck(false)
    rdo_FontSizeSmall2:SetCheck(false)
    rdo_FontSizeNormal:SetCheck(false)
    rdo_FontSizeNormal2:SetCheck(true)
    rdo_FontSizeBig:SetCheck(false)
  elseif 20 == thisFontSize then
    rdo_FontSizeSmall:SetCheck(false)
    rdo_FontSizeSmall2:SetCheck(false)
    rdo_FontSizeNormal:SetCheck(false)
    rdo_FontSizeNormal2:SetCheck(false)
    rdo_FontSizeBig:SetCheck(true)
  end
  local currentNameType = ToClient_getChatNameType()
  preNameType = currentNameType
  if currentNameType == 0 then
    rdo_CharacterName:SetCheck(true)
    rdo_FamilyName:SetCheck(false)
  elseif currentNameType == 1 then
    rdo_CharacterName:SetCheck(false)
    rdo_FamilyName:SetCheck(true)
  end
  prevFontSizeType = ChattingOption_convertFontSizeToChatFontType(thisFontSize)
  local _transparency = FGlobal_Chatting_PanelTransparency_Chk(drawPanelIndex)
  ChattingOption_Initialize(penelIdex, _transparency, isCombinedMainPanel)
  _prevMainTransparency = -1
  _prevTransparency = -1
  _openOptionPanelIndex = -1
  _openOptionPanelIndex = penelIdex
  _prevTransparency = _transparency
  _prevIsCheckDivision = _check_Division:IsCheck()
  if penelIdex == 0 then
    _prevMainTransparency = _transparency
  end
  ApplyHarfBuzzOption_Initialize()
  Panel_ChatOption:ComputePos()
end
function ChattingOption_Close()
  local chatCount = ToClient_getChattingPanelCount()
  for panelIdex = 0, chatCount - 1 do
    local chatPanel = ToClient_getChattingPanel(panelIdex)
    chatPanel:setChatFontSizeType(prevFontSizeType)
    if true == chatPanel:isOpen() then
      FGlobal_ChatOption_SetIsShowTimeString(panelIdex, _prevIsCheckChatTime[panelIdex])
      _checkButton_ChatTime:SetCheck(_prevIsCheckChatTime[panelIdex])
    end
  end
  setisChangeFontSize(true)
  RegisterUpdate_ChatOption()
  ToClient_setChatNameType(preNameType)
  ToClient_setUseHarfBuzz(preUseHarfBuzz)
  FGlobal_ChattingcheckArabicType(preUseHarfBuzz)
  ChattingOption_ChatiingAnimation(preChattingAnimation)
  if _openOptionPanelIndex ~= -1 then
    FGlobal_Chatting_PanelTransparency(_openOptionPanelIndex, _prevTransparency, true)
  end
  if _prevMainTransparency ~= -1 then
    for idx = 0, chatCount - 1 do
      local chatPanel = ToClient_getChattingPanel(idx)
      if chatPanel:isCombinedToMainPanel() == true then
        FGlobal_Chatting_PanelTransparency(idx, _prevMainTransparency, true)
      end
    end
  end
  _check_Division:SetCheck(_prevIsCheckDivision)
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eChatDivision, _prevIsCheckDivision, CppEnums.VariableStorageType.eVariableStorageType_User)
  Panel_ChatOption:SetShow(false, false)
  Panel_ChatOption:SetIgnore(true)
  ChattingColor_Hide()
end
function ChatOption_ShowAni()
  UIAni.fadeInSCR_Left(Panel_ChatOption)
end
function ChattingOption_ShowBlockList()
  clickRequestShowBlockList()
end
function ChattingOption_SelectFontSize(fontSize)
  if nil == fontSize then
    return
  end
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local count = ToClient_getChattingPanelCount()
  local fontType = ChattingOption_convertFontSizeToChatFontType(fontSize)
  for panelIdx = 0, count - 1 do
    local chatPanel = ToClient_getChattingPanel(panelIdx)
    chatPanel:setChatFontSizeType(fontType)
  end
  setisChangeFontSize(true)
  RegisterUpdate_ChatOption()
end
function setisChangeFontSize(set)
  isChangeFont = set
end
setisChangeFontSize(true)
function isChangeFontSize()
  return isChangeFont
end
function RegisterUpdate_ChatOption()
  if true == ToClient_isConsole() then
    return
  end
  FromClient_ChatUpdate()
end
function ChattingOption_convertFontSizeToChatFontType(chattingFontSize)
  local ChatFontType = CppEnums.ChatFontSizeType.eChatFontSizeType_Normal
  if chattingFontSize == 10 then
    ChatFontType = CppEnums.ChatFontSizeType.eChatFontSizeType_Small
  elseif chattingFontSize == 12 then
    ChatFontType = CppEnums.ChatFontSizeType.eChatFontSizeType_Medium
  elseif chattingFontSize == 14 then
    ChatFontType = CppEnums.ChatFontSizeType.eChatFontSizeType_Normal
  elseif chattingFontSize == 18 then
    ChatFontType = CppEnums.ChatFontSizeType.eChatFontSizeType_Biggish
  elseif chattingFontSize == 20 then
    ChatFontType = CppEnums.ChatFontSizeType.eChatFontSizeType_Big
  end
  return ChatFontType
end
function ChattingOption_convertChatFontTypeToFontSize(chattingFontType)
  local fontSize = 14
  if chattingFontType == CppEnums.ChatFontSizeType.eChatFontSizeType_Small then
    fontSize = 10
  elseif chattingFontType == CppEnums.ChatFontSizeType.eChatFontSizeType_Medium then
    fontSize = 12
  elseif chattingFontType == CppEnums.ChatFontSizeType.eChatFontSizeType_Normal then
    fontSize = 14
  elseif chattingFontType == CppEnums.ChatFontSizeType.eChatFontSizeType_Biggish then
    fontSize = 18
  elseif chattingFontType == CppEnums.ChatFontSizeType.eChatFontSizeType_Big then
    fontSize = 20
  end
  return fontSize
end
function ChattingOption_getChatFontSizebyPanelIndex(panelIdx)
  local chatPanel = ToClient_getChattingPanel(panelIdx)
  local fontType = chatPanel:getChatFontSizeType()
  return ChattingOption_convertChatFontTypeToFontSize(fontType)
end
function getPanelChatFontSizeType(panelIdx)
  local chatPanel = ToClient_getChattingPanel(panelIdx)
  return chatPanel:getChatFontSizeType()
end
function FGlobal_ChatOption_GetIsShowTimeString(panelIndex)
  local chatPanel = ToClient_getChattingPanel(panelIndex)
  if nil == chatPanel then
    _PA_ASSERT(false, "\236\151\134\235\138\148 \235\178\136\237\152\184\236\157\152 \236\177\132\237\140\133 \237\140\168\235\132\144\236\158\133\235\139\136\235\139\164.(" .. tostring(panelIndex) .. ")")
    return false
  end
  return chatPanel:getIsShowTimeString()
end
function FGlobal_ChatOption_SetIsShowTimeString(panelIndex, isShowTimeString)
  if nil == panelIndex then
    return
  end
  if nil == isShowTimeString then
    return
  end
  local chatPanel = ToClient_getChattingPanel(panelIndex)
  if nil == chatPanel then
    _PA_ASSERT(false, "\236\151\134\235\138\148 \235\178\136\237\152\184\236\157\152 \236\177\132\237\140\133 \237\140\168\235\132\144\236\158\133\235\139\136\235\139\164.(" .. tostring(panelIndex) .. ")")
    return
  end
  if false == chatPanel:isOpen() then
    return
  end
  chatPanel:setIsShowTimeString(isShowTimeString)
  RegisterUpdate_ChatOption()
end
function ChatOption_HideAni()
  Panel_ChatOption:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local mailHideAni = Panel_ChatOption:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  mailHideAni:SetStartColor(UI_color.C_FFFFFFFF)
  mailHideAni:SetEndColor(UI_color.C_00FFFFFF)
  mailHideAni:SetStartIntensity(3)
  mailHideAni:SetEndIntensity(1)
  mailHideAni.IsChangeChild = true
  mailHideAni:SetHideAtEnd(true)
  mailHideAni:SetDisableWhileAni(true)
end
local BlockList = {
  _uiBlockList = UI.getChildControl(Panel_ChatOption, "Listbox_Block"),
  _uiBackGround = UI.getChildControl(Panel_ChatOption, "Static_OfferWindow"),
  _uiBlackListTItle = UI.getChildControl(Panel_ChatOption, "StaticText_ChatOptionOfferTitle"),
  _uiClose = UI.getChildControl(Panel_ChatOption, "Block_Close"),
  _uiDelete = UI.getChildControl(Panel_ChatOption, "Button_Delete"),
  _uiAllDelete = UI.getChildControl(Panel_ChatOption, "Button_AllDelete"),
  _uiScroll = nil,
  _uiScrollCtrlButton = nil,
  _selectDeleteIndex,
  _slotRows = 12
}
function BlockList:SetShow(isShow)
  BlockList._uiBlockList:SetShow(isShow)
  BlockList._uiBackGround:SetShow(isShow)
  BlockList._uiBlackListTItle:SetShow(isShow)
  BlockList._uiClose:SetShow(isShow)
  BlockList._uiDelete:SetShow(isShow)
  BlockList._uiAllDelete:SetShow(isShow)
end
function BlockList:initialize()
  self._uiScroll = UI.getChildControl(self._uiBlockList, "Block_Scroll")
  self._uiScroll:SetControlTop()
  self._uiBlockList:addInputEvent("Mouse_LUp", "clickBlockList()")
  self._uiClose:addInputEvent("Mouse_LUp", "clickCloseBlockList()")
  self._selectDeleteIndex = -1
  self._uiDelete:addInputEvent("Mouse_LUp", "clickDeleteBlock()")
  self._uiAllDelete:addInputEvent("Mouse_LUp", "clickAllDeleteBlock()")
  self:SetShow(false)
end
function clickCloseBlockList()
  BlockList_hide()
end
function clickDeleteBlock()
  if -1 ~= BlockList._selectDeleteIndex then
    local deleteName = BlockList._uiBlockList:GetItemText(BlockList._selectDeleteIndex)
    ToClient_RequestDeleteBlockName(deleteName)
  end
end
function clickAllDeleteBlock()
  BlockList._selectDeleteIndex = -1
  ToClient_RequestDeleteAllBlockList()
end
function clickBlockList()
  BlockList._selectDeleteIndex = BlockList._uiBlockList:GetSelectIndex()
end
function BlockList:updateList()
  local listControl = self._uiBlockList
  listControl:DeleteAll()
  local blockCount = ToClient_RequestBlockCount()
  for i = 0, blockCount - 1 do
    local blockName = ToClient_RequestGetBlockName(i)
    listControl:AddItemWithLineFeed(blockName, UI_color.C_FFFFF3AF)
  end
  UIScroll.SetButtonSize(self._uiScroll, self._slotRows, blockCount)
end
BlockList:initialize()
registerEvent("FromClient_UpdateBlockList", "FromClient_UpdateBlockList")
function BlockList_show()
  self._selectDeleteIndex = -1
  BlockList:SetShow(true)
  BlockList:updateList()
end
function BlockList_hide()
  BlockList:SetShow(false)
end
function FromClient_UpdateBlockList()
  BlockList:updateList()
end
function clickRequestShowBlockList()
  if BlockList._uiBackGround:GetShow() then
    BlockList_hide()
  else
    BlockList_show()
  end
end
function HandleOn_ChattingOption_Tooltip(isShow, tipType, idx)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_NOTICE_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_NOTICE_DESC")
    control = btnFilter[idx].chatFilter
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_WORLD_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_WORLD_DESC")
    control = btnFilter[idx].chatFilter
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SERVER_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SERVER_DESC")
    control = btnFilter[idx].chatFilter
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_GUILD_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_GUILD_DESC")
    control = btnFilter[idx].chatFilter
  elseif 4 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_PARTY_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_PARTY_DESC")
    control = btnFilter[idx].chatFilter
  elseif 5 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_COMBAT_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_COMBAT_DESC")
    control = btnFilter[idx].chatFilter
  elseif 6 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_NORMAL_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_NORMAL_DESC")
    control = btnFilter[idx].chatFilter
  elseif 7 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_ROLEPLAY_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_ROLEPLAY_DESC")
    control = btnFilter[idx].chatFilter
  elseif 8 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_WHISPER_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_WHISPER_DESC")
    control = btnFilter[idx].chatFilter
  elseif 9 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_ARSHA_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_ARSHA_DESC")
    control = btnFilter[idx].chatFilter
  elseif 10 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_TEAM_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_TEAM_DESC")
    control = btnFilter[idx].chatFilter
  elseif 11 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_DESC")
    control = btnSystemFilter[idx].chatFilter
  elseif 12 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_NORMAL_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_NORMAL_DESC")
    control = btnSystemFilter[idx].chatFilter
  elseif 13 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_PERSONITEM_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_PERSONITEM_DESC")
    control = btnSystemFilter[idx].chatFilter
  elseif 14 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_PARTYITEM_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_PARTYITEM_DESC")
    control = btnSystemFilter[idx].chatFilter
  elseif 15 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_ITEMMARKET_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_ITEMMARKET_DESC")
    control = btnSystemFilter[idx].chatFilter
  elseif 16 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_WORKER_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_WORKER_DESC")
    control = btnSystemFilter[idx].chatFilter
  elseif 17 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_HARVEST_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SYSTEM_HARVEST_DESC")
    control = btnSystemFilter[idx].chatFilter
  elseif 18 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_FONT_VERYSMALL_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_FONT_VERYSMALL_DESC")
    control = rdo_FontSizeSmall
  elseif 19 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_FONT_SMALL_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_FONT_SMALL_DESC")
    control = rdo_FontSizeSmall2
  elseif 20 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_FONT_NORMAL_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_FONT_NORMAL_DESC")
    control = rdo_FontSizeNormal
  elseif 21 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_FONT_BIG_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_FONT_BIG_DESC")
    control = rdo_FontSizeNormal2
  elseif 22 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_FONT_VERYBIG_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_FONT_VERYBIG_DESC")
    control = rdo_FontSizeBig
  elseif 23 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_CHARACTERNAME_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_CHARACTERNAME_DESC")
    control = rdo_CharacterName
  elseif 24 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_FAMILYNAME_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_FAMILYNAME_DESC")
    control = rdo_FamilyName
  elseif 25 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SCROLLANIMATION_USE_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SCROLLANIMATION_USE_DESC")
    control = rdo_ChattingAnimationOn
  elseif 26 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SCROLLANIMATION_NONEUSE_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_SCROLLANIMATION_NONEUSE_DESC")
    control = rdo_ChattingAnimationOff
  elseif 27 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_CHATBLOCKLIST_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_CHATBLOCKLIST_DESC")
    control = _button_blockList
  elseif 28 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_COLORRESET_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_COLORRESET_DESC")
    control = _button_resetColor
  elseif 29 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHATOPTION_CHATDIVISION_HEAD")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_CHATHEAD_DESC")
    control = _check_Division
  elseif 30 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHATTINGOPTION_CHATTIME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_CHATTIME_DESC")
    control = _checkButton_ChatTime
  elseif 31 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "LUA_CHATOPTION_TOOLTIP_SCROLLANIMATION_USE_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_EMOTICON_DESC_ON")
    control = btn_EmoticonAutoPlayOn
  elseif 32 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "LUA_CHATOPTION_TOOLTIP_SCROLLANIMATION_NONEUSE_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_EMOTICON_DESC_OFF")
    control = btn_EmoticonAutoPlayOff
  elseif 98 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_CHATCOLORSET_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_CHATCOLORSET_DESC")
    control = btnSystemFilter[idx].chatColor
  elseif 99 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_CHATCOLORSET_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTION_TOOLTIP_CHATCOLORSET_DESC")
    control = btnFilter[idx].chatColor
  elseif 101 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTIONTOOLTIP_ALLIANCE_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATOPTIONTOOLTIP_ALLIANCE_DESC")
    control = btnFilter[idx].chatFilter
  end
  TooltipSimple_Show(control, name, desc)
end
function ChattingOption_SelectNameType(nameType)
  if nil == nameType then
    return
  end
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  ToClient_setChatNameType(nameType)
  RegisterUpdate_ChatOption()
end
function ChattingOption_InitailizeChattingAnimationControl()
  ChattingAnimationTitleBg:ComputePos()
  ChattingAnimationOptionBg:ComputePos()
  rdo_ChattingAnimationOn:ComputePos()
  rdo_ChattingAnimationOff:ComputePos()
  rdo_ChattingAnimationOn:SetEnableArea(0, 0, rdo_ChattingAnimationOn:GetSizeX() + rdo_ChattingAnimationOn:GetTextSizeX() + 3, rdo_ChattingAnimationOn:GetSizeY())
  rdo_ChattingAnimationOff:SetEnableArea(0, 0, rdo_ChattingAnimationOff:GetSizeX() + rdo_ChattingAnimationOff:GetTextSizeX() + 3, rdo_ChattingAnimationOff:GetSizeY())
  rdo_ChattingAnimationOn:addInputEvent("Mouse_LUp", "ChattingOption_ChatiingAnimation( true )")
  rdo_ChattingAnimationOff:addInputEvent("Mouse_LUp", "ChattingOption_ChatiingAnimation( false )")
  rdo_ChattingAnimationOn:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 25)")
  rdo_ChattingAnimationOn:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
  rdo_ChattingAnimationOff:addInputEvent("Mouse_On", "HandleOn_ChattingOption_Tooltip(true, 26)")
  rdo_ChattingAnimationOff:addInputEvent("Mouse_Out", "HandleOn_ChattingOption_Tooltip(false)")
  local ChattingAnimationflag = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eChattingAnimation)
  if true == ChattingAnimationflag then
    rdo_ChattingAnimationOn:SetCheck(true)
    rdo_ChattingAnimationOff:SetCheck(false)
    ChattingOption_ChatiingAnimation(true)
    preChattingAnimation = true
  else
    rdo_ChattingAnimationOn:SetCheck(false)
    rdo_ChattingAnimationOff:SetCheck(true)
    ChattingOption_ChatiingAnimation(false)
    preChattingAnimation = false
  end
end
function ChattingOption_UpdateChattingAnimationControl(isUsedChattingAnimation)
  if true == isUsedChattingAnimation then
    rdo_ChattingAnimationOn:SetCheck(true)
    rdo_ChattingAnimationOff:SetCheck(false)
    ChattingOption_ChatiingAnimation(true)
    preChattingAnimation = true
  else
    rdo_ChattingAnimationOn:SetCheck(false)
    rdo_ChattingAnimationOff:SetCheck(true)
    ChattingOption_ChatiingAnimation(false)
    preChattingAnimation = false
  end
end
function ChattingOption_ChatiingAnimation(ChattingAniFlag)
  if nil == ChattingAniFlag then
    return
  end
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eChattingAnimation, ChattingAniFlag, CppEnums.VariableStorageType.eVariableStorageType_User)
  Chatting_setUsedSmoothChattingUp(ChattingAniFlag)
end
function PaGlobal_ChattingOption_setEmoticonAutoPlay(panelIdx, isSet)
  _isUseEmoticonAutoPlay = isSet
  RegisterUpdate_ChatOption()
end
