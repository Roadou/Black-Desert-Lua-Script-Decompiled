local IM = CppEnums.EProcessorInputMode
local _panel = Panel_RecommandName_Renew
_panel:SetShow(false, false)
_panel:SetDragAll(true)
_panel:setGlassBackground(true)
_panel:ActiveMouseEventEffect(true)
_panel:setMaskingChild(true)
local HelpMailType = {
  eHelpMailType_Repay = 0,
  eHelpMailType_Thanks = 1,
  eHelpMailType_ValentineNot1 = 2,
  eHelpMailType_ValentineNot2 = 3,
  eHelpMailType_Valentine = 4
}
local _helpMailType = HelpMailType.eHelpMailType_Thanks
local uiEditName = UI.getChildControl(_panel, "Edit_Nickname")
local uiStaticTitle = UI.getChildControl(_panel, "StaticText_Title")
local uiStaticContentHelper = UI.getChildControl(_panel, "StaticText_ToRecommander")
local uiStaticWarnning = UI.getChildControl(_panel, "StaticText_Warnning")
function FromClient_luaLoadComplete_RecommandNameInit()
  recommandName:init()
end
function recommandName:init()
  uiStaticContentHelper:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  uiStaticWarnning:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleClicked_SendMailForHelp()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "handleClicked_ClickEdit()")
  local keyGuideBG = UI.getChildControl(_panel, "Static_BottomArea")
  txt_keyGuideConfirm = UI.getChildControl(keyGuideBG, "StaticText_Confirm_ConsoleUI")
  txt_keyGuideCancel = UI.getChildControl(keyGuideBG, "StaticText_Cancel_ConsoleUI")
  PaGlobalFunc_ConsoleKeyGuide_SetAlign({txt_keyGuideConfirm, txt_keyGuideCancel}, keyGuideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  registerEvent("FromClient_SendMailForHelp", "FromClient_SendMailForHelp")
  registerEvent("FromClient_SendMailForHelpComplete", "FromClient_SendMailForHelpComplete")
end
function SendMailForHelpInit()
  uiEditName:SetMaxInput(getGameServiceTypeCharacterNameLength())
end
function HandleClicked_SendMailForHelp()
  local content = uiStaticContentHelper:GetText()
  local title = PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_RECOMMANDGIFT")
  if _helpMailType == HelpMailType.eHelpMailType_Thanks then
    title = PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_RECOMMANDGIFT")
    content = PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_SENDMAIL2")
  elseif _helpMailType == HelpMailType.eHelpMailType_Repay then
    title = PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_RECOMMANDGIFT")
    content = PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_SENDMAIL1")
  elseif _helpMailType == HelpMailType.eHelpMailType_Valentine then
    title = PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_VALENTINE_TITLE")
    content = PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_VALENTINE_DESC")
  else
    title = PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_VALENTINE")
    content = PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_SENDMAIL_BALENTINE")
  end
  ToClient_SendMailForHelp(uiEditName:GetEditText(), title, content)
  _panel:SetShow(false, false)
  uiEditName:SetEditText("", true)
  ClearFocusEdit()
  CheckChattingInput()
end
function FromClient_SendMailForHelp(helpMailType)
  _panel:SetShow(true, false)
  _helpMailType = helpMailType
  uiStaticContentHelper:SetShow(true)
  uiStaticContentHelper:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  if _helpMailType == HelpMailType.eHelpMailType_Thanks then
    uiStaticContentHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_TONEWBIE"))
    uiStaticTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_THANKSGIFTMAIL"))
    uiStaticWarnning:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_EDITCHARACTERNAME"))
  elseif _helpMailType == HelpMailType.eHelpMailType_Repay then
    uiStaticContentHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_TORECOMMANDER"))
    uiStaticTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_PAYMAIL"))
    uiStaticWarnning:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_EDITCHARACTERNAME"))
  elseif _helpMailType == HelpMailType.eHelpMailType_Valentine then
    uiStaticContentHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_VALENTINE_SENDER_DESC"))
    uiStaticTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_VALENTINE_SENDER_TITLE"))
    uiStaticWarnning:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_EDITCHARACTERNAME"))
  else
    uiStaticContentHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_BALENTINEMAIL"))
    uiStaticTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_BALENTINEMAIL"))
    uiStaticWarnning:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_EDITCHARACTERNAME"))
  end
  SetFocusEdit(uiEditName)
end
function handleClicked_ClickEdit()
  if not _panel:IsShow() then
    return
  end
  uiEditName:SetMaxInput(getGameServiceTypeUserNickNameLength())
  SetFocusEdit(uiEditName)
end
function FromClient_SendMailForHelpComplete(isSender, helpMailType)
  if helpMailType == HelpMailType.eHelpMailType_Thanks then
    if isSender then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_COMPLETE"))
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_GETRECOMMAND"))
    end
  elseif helpMailType == HelpMailType.eHelpMailType_Repay then
  elseif helpMailType == HelpMailType.eHelpMailType_Valentine then
    if isSender then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_VALENTINE_COMPLETE"))
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_VALENTINE_GETCOMPLETE"))
    end
  elseif isSender then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_SENDCOMPLETE_BALENTINE"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_GETBALENTINE"))
  end
end
function FGlobal_SendMailForHelpClose()
  _panel:SetShow(false, false)
  uiEditName:SetEditText("", true)
  ClearFocusEdit()
  CheckChattingInput()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_ChangeNameInit")
SendMailForHelpInit()
