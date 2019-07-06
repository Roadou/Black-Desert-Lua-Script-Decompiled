local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local StyleUI = {
  _c_macroBG = UI.getChildControl(Instance_Chatting_Macro, "Static_C_MacroBG"),
  _c_macroKey = UI.getChildControl(Instance_Chatting_Macro, "StaticText_C_MacroKey"),
  _c_btn_Normal = UI.getChildControl(Instance_Chatting_Macro, "Button_C_Normal"),
  _c_btn_Party = UI.getChildControl(Instance_Chatting_Macro, "Button_C_Party"),
  _c_btn_Guild = UI.getChildControl(Instance_Chatting_Macro, "Button_C_Guild"),
  _c_btn_World = UI.getChildControl(Instance_Chatting_Macro, "Button_C_World"),
  _c_btn_WorldWithItem = UI.getChildControl(Instance_Chatting_Macro, "Button_C_WorldWithItem"),
  _c_edit_InputMacro = UI.getChildControl(Instance_Chatting_Macro, "Edit_C_InputMacro")
}
Instance_Chatting_Macro:RegisterShowEventFunc(true, "Panel_Chatting_Macro_ShowAni()")
Instance_Chatting_Macro:RegisterShowEventFunc(false, "Panel_Chatting_Macro_HideAni()")
local macroCount = 10
local macroChatTypeCount = 5
local maxEditInput = 100
if isGameTypeKorea() then
  macroChatTypeCount = 5
elseif isGameTypeJapan() then
  macroChatTypeCount = 5
else
  macroChatTypeCount = 4
end
local startPosY = 7
local ChatMacro = {
  _chatType = {},
  _buttonChatType = {},
  _editChatMessage = {}
}
local currentInputEditIndex = -1
function Panel_Chatting_Macro_ShowAni()
  Instance_Chatting_Macro:SetAlpha(0)
  UIAni.AlphaAnimation(1, Instance_Chatting_Macro, 0, 0.2)
end
function Panel_Chatting_Macro_HideAni()
  local aniInfo = UIAni.AlphaAnimation(0, Instance_Chatting_Macro, 0, 0.2)
  aniInfo:SetHideAtEnd(true)
end
function ChatMacro:initialize()
  local ui = {}
  for idx = 0, macroCount - 1 do
    ui._macroBG = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Instance_Chatting_Macro, "Static_MacroBG_" .. idx)
    CopyBaseProperty(StyleUI._c_macroBG, ui._macroBG)
    ui._macroBG:SetShow(true)
    ui._macroBG:SetPosY(startPosY + idx * 32)
    ui._macroKey = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, ui._macroBG, "StaticText_MacroKey_" .. idx)
    CopyBaseProperty(StyleUI._c_macroKey, ui._macroKey)
    ui._macroKey:SetShow(true)
    ui._macroKey:SetPosX(5)
    if idx < 9 then
      ui._macroKey:SetText(PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Alt") .. "+" .. PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Shift") .. "+" .. idx + 1)
    elseif idx == 9 then
      ui._macroKey:SetText(PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Alt") .. "+" .. PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Shift") .. "+0")
    end
    ChatMacro._buttonChatType[idx] = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, ui._macroBG, "Button_Normal_" .. idx)
    CopyBaseProperty(StyleUI._c_btn_Normal, ChatMacro._buttonChatType[idx])
    ChatMacro._buttonChatType[idx]:SetShow(true)
    ChatMacro._buttonChatType[idx]:addInputEvent("Mouse_LUp", "HandleClicked_ChatMacroType(" .. idx .. ")")
    ChatMacro._editChatMessage[idx] = UI.createControl(UI_PUCT.PA_UI_CONTROL_EDIT, ui._macroBG, "Edit_InputMacro_" .. idx)
    CopyBaseProperty(StyleUI._c_edit_InputMacro, ChatMacro._editChatMessage[idx])
    ChatMacro._editChatMessage[idx]:SetShow(true)
    ChatMacro._chatType[idx] = 0
    ChatMacro._editChatMessage[idx]:SetMaxInput(maxEditInput)
    ChatMacro._editChatMessage[idx]:addInputEvent("Mouse_LDown", "HandleClicked_ChatMacroInputEdit(" .. idx .. ")")
    if isGameTypeKorea() then
      Instance_Chatting_Macro:SetSize(370, 355)
      StyleUI._c_macroBG:SetSize(360, 30)
      ui._macroBG:SetSize(360, 30)
      StyleUI._c_macroBG:SetPosX(5)
      ui._macroBG:SetPosX(5)
      StyleUI._c_btn_Normal:SetPosX(85)
      StyleUI._c_btn_Party:SetPosX(85)
      StyleUI._c_btn_Guild:SetPosX(85)
      StyleUI._c_btn_World:SetPosX(85)
      StyleUI._c_btn_WorldWithItem:SetPosX(85)
      ChatMacro._editChatMessage[idx]:SetPosX(140)
    elseif isGameTypeTaiwan() then
      Instance_Chatting_Macro:SetSize(370, 355)
      StyleUI._c_macroBG:SetSize(360, 30)
      ui._macroBG:SetSize(360, 30)
      StyleUI._c_macroBG:SetPosX(5)
      ui._macroBG:SetPosX(5)
      StyleUI._c_btn_Normal:SetPosX(85)
      StyleUI._c_btn_Party:SetPosX(85)
      StyleUI._c_btn_Guild:SetPosX(85)
      StyleUI._c_btn_World:SetPosX(85)
      StyleUI._c_btn_WorldWithItem:SetPosX(85)
      ChatMacro._editChatMessage[idx]:SetPosX(140)
    else
      Instance_Chatting_Macro:SetSize(370, 355)
      StyleUI._c_macroBG:SetSize(360, 30)
      ui._macroBG:SetSize(360, 30)
      StyleUI._c_macroBG:SetPosX(5)
      ui._macroBG:SetPosX(5)
      StyleUI._c_btn_Normal:SetPosX(85)
      StyleUI._c_btn_Party:SetPosX(85)
      StyleUI._c_btn_Guild:SetPosX(85)
      StyleUI._c_btn_World:SetPosX(85)
      StyleUI._c_btn_WorldWithItem:SetPosX(85)
      ChatMacro._editChatMessage[idx]:SetPosX(140)
    end
  end
  Instance_Chatting_Macro:RemoveControl(StyleUI._c_macroBG)
  Instance_Chatting_Macro:RemoveControl(StyleUI._c_macroKey)
  Instance_Chatting_Macro:RemoveControl(StyleUI._c_edit_InputMacro)
  StyleUI._c_btn_Normal:SetShow(false)
  StyleUI._c_btn_Party:SetShow(false)
  StyleUI._c_btn_Guild:SetShow(false)
  StyleUI._c_btn_World:SetShow(false)
  StyleUI._c_btn_WorldWithItem:SetShow(false)
end
function HandleClicked_ChatMacroType(index)
  ChatMacro._chatType[index] = ChatMacro._chatType[index] + 1
  if macroChatTypeCount <= ChatMacro._chatType[index] then
    ChatMacro._chatType[index] = 0
  end
  local copyUI = StyleUI._c_btn_Normal
  if 1 == ChatMacro._chatType[index] then
    copyUI = StyleUI._c_btn_Party
  elseif 2 == ChatMacro._chatType[index] then
    copyUI = StyleUI._c_btn_Guild
  elseif 3 == ChatMacro._chatType[index] then
    copyUI = StyleUI._c_btn_World
  elseif 4 == ChatMacro._chatType[index] then
    copyUI = StyleUI._c_btn_WorldWithItem
  end
  CopyBaseProperty(copyUI, ChatMacro._buttonChatType[index])
  ChatMacro._buttonChatType[index]:SetShow(true)
end
function HandleClicked_ChatMacroInputEdit(index)
  currentInputEditIndex = index
end
function ChatMacro:update()
  for index = 0, macroCount - 1 do
    local text = ToClient_getMacroChatMessage(index)
    self._editChatMessage[index]:SetEditText(text)
    self._chatType[index] = ToClient_getMacroChatType(index)
    local copyUI = StyleUI._c_btn_Normal
    if 1 == self._chatType[index] then
      copyUI = StyleUI._c_btn_Party
    elseif 2 == self._chatType[index] then
      copyUI = StyleUI._c_btn_Guild
    elseif 3 == self._chatType[index] then
      copyUI = StyleUI._c_btn_World
    elseif 4 == self._chatType[index] then
      copyUI = StyleUI._c_btn_WorldWithItem
    end
    CopyBaseProperty(copyUI, self._buttonChatType[index])
    self._buttonChatType[index]:SetShow(true)
  end
end
function ChatMacro:saveMacro()
  for index = 0, macroCount - 1 do
    ToClient_SetChatMacro(index, self._chatType[index], self._editChatMessage[index]:GetEditText())
  end
  ToClient_SaveChatMacro()
end
ChatMacro:initialize()
function FGlobal_Chatting_Macro_ShowToggle()
  if Instance_Chatting_Macro:IsShow() then
    ChatMacro:saveMacro()
    Instance_Chatting_Macro:SetShow(false, true)
    FGlobal_Chatting_Macro_SetCHK(false)
    ChatInput_Show()
  elseif Instance_Chat_SocialMenu:GetShow() then
    Instance_Chat_SocialMenu:SetShow(false)
    Instance_Chatting_Macro:SetShow(true, true)
    ChatMacro:update()
  elseif PaGlobalFunc_ChatEmoticon_GetShow() then
    PaGlobalFunc_ChatEmoticon_Close()
    Instance_Chatting_Macro:SetShow(true, true)
    ChatMacro:update()
    return true
  else
    Instance_Chatting_Macro:SetShow(true, true)
    ChatMacro:update()
  end
  Instance_Chatting_Macro:SetPosY(Instance_Chatting_Input:GetPosY() - Instance_Chatting_Macro:GetSizeY() - 5)
  Instance_Chatting_Macro:SetPosX(Instance_Chatting_Input:GetSizeX() + Instance_Chatting_Input:GetPosX())
end
function ChatMacro_CheckCurrentUiEdit(targetUI)
  if -1 == currentInputEditIndex then
    return false
  end
  return nil ~= targetUI and targetUI:GetKey() == ChatMacro._editChatMessage[currentInputEditIndex]:GetKey()
end
