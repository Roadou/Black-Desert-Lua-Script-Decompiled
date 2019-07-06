local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_CT = CppEnums.ChatType
local UI_CNT = CppEnums.EChatNoticeType
local UI_Group = Defines.UIGroup
local IM = CppEnums.EProcessorInputMode
local UI_CST = CppEnums.ChatSystemType
Panel_Chatting_Color:SetShow(false)
local chatColor = {
  _btnConfirm = UI.getChildControl(Panel_Chatting_Color, "Button_Confirm"),
  _btnWinClose = UI.getChildControl(Panel_Chatting_Color, "Button_WinClose"),
  _btnClose = UI.getChildControl(Panel_Chatting_Color, "Button_Cancle"),
  _plateColor = UI.getChildControl(Panel_Chatting_Color, "Static_Color"),
  _tempBG = UI.getChildControl(Panel_Chatting_Color, "Static_ColorBoxBG"),
  colorBtnList = {},
  boxStartX = 5,
  boxStartY = 5,
  boxGapX = 37,
  boxGapY = 37,
  _boxsCols = 11,
  savedChatType = nil,
  savedPanelIndex = nil,
  savedColorIndex = nil,
  totalColorCount = 88
}
local eChatButtonType = {
  eChatNotice = 0,
  eChatWorldWithItem = 1,
  eChatWorld = 2,
  eChatGuild = 3,
  eChatLocalWar = 6,
  eChatParty = 5,
  eChatBattle = 4,
  eChatPublic = 7,
  eChatPrivate = 8,
  eChatRolePlay = 9,
  eChatArsha = 10
}
local color_Notice = UI_color.C_FFFFEF82
local color_World = UI_color.C_FFFF973A
local color_Public = UI_color.C_FFE7E7E7
local color_Private = UI_color.C_FFF601FF
local color_Party = UI_color.C_FF8EBD00
local color_Guild = UI_color.C_FF84FFF5
local color_WorldWithItem = UI_color.C_FF00F3A0
local color_LocalWar = UI_color.C_FFB97FEF
local color_RolePlay = UI_color.C_FF00B4FF
local color_Arsha = UI_color.C_FFFFD237
local colorList = colorSettingList
local colorSelected = Array.new()
function ChattingColor_Init()
  for btnIdx = 0, #colorList do
    local colorBox = {}
    local row = math.floor(btnIdx / chatColor._boxsCols)
    local col = btnIdx % chatColor._boxsCols
    colorBox.plate = UI.createAndCopyBasePropertyControl(Panel_Chatting_Color, "Static_Color", chatColor._tempBG, "ChattingColor_Box_" .. btnIdx)
    colorBox.plate:SetPosX(chatColor.boxStartX + chatColor.boxGapX * col)
    colorBox.plate:SetPosY(chatColor.boxStartY + chatColor.boxGapY * row)
    colorBox.plate:SetColor(colorList[btnIdx])
    colorBox.colorSelector = UI.createAndCopyBasePropertyControl(Panel_Chatting_Color, "RadioButton_ColorSelector", chatColor._tempBG, "ChattingColor_Selector_" .. btnIdx)
    colorBox.colorSelector:SetPosX(chatColor.boxStartX + chatColor.boxGapX * col)
    colorBox.colorSelector:SetPosY(chatColor.boxStartY + chatColor.boxGapY * row)
    colorBox.colorSelector:addInputEvent("Mouse_LUp", "ChattingColor_SelectColor( " .. btnIdx .. ")")
    colorSelected[btnIdx] = colorBox
  end
  local self = chatColor
  self.chatType = index
end
function ChattingColor_Update(panelIndex, chatType)
  for btnIdx = 0, #colorList do
    colorSelected[btnIdx].colorSelector:SetCheck(false)
  end
  local chat = ToClient_getChattingPanel(panelIndex)
  local chatColorIndex = chat:getChatColorIndex(chatType)
  local chatColorSystemIndex = chat:getChatSystemColorIndex(5)
  if -1 ~= chatColorIndex and 5 ~= chatType then
    colorSelected[chatColorIndex].colorSelector:SetCheck(true)
  end
  if -1 ~= chatColorSystemIndex and 5 == chatType then
    colorSelected[chatColorSystemIndex].colorSelector:SetCheck(true)
  end
end
function FGlobal_ChattingColor_Show(panelIndex, chatType)
  Panel_Chatting_Color:SetShow(true)
  ChattingColor_Update(panelIndex, chatType)
  Panel_ChatOption:SetSpanSize(-200, 0)
  Panel_Chatting_Color:SetPosX(Panel_ChatOption:GetPosX() + Panel_ChatOption:GetSizeX())
end
function ChattingColor_Hide()
  Panel_Chatting_Color:SetShow(false)
  Panel_ChatOption:SetSpanSize(0, 0)
end
function ChattingColor_SelectColor(index)
  local self = chatColor
  self.savedColorIndex = index
end
function FGlobal_ChattingColor_SetColor(panelIndex, chatType, chatButtonType, isSystem)
  local self = chatColor
  if nil == self.savedColorIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_COLOR_NOSELECTCOLOR"))
    return
  end
  local chat = ToClient_getChattingPanel(panelIndex)
  if isSystem then
    chat:setChatSystemColorIndex(chatType, self.savedColorIndex)
  else
    chat:setChatColor(chatType, self.savedColorIndex)
  end
  FGlobal_ChattingOption_SettingColor(self.savedColorIndex, chatButtonType, panelIndex, isSystem)
  ChattingColor_Hide()
end
function FGlobal_ChattingColor_GetColor(panelIndex, chatType, chatButtonType, isSystem)
  local self = chatColor
  FGlobal_ChattingColor_Show(panelIndex, chatType)
  ChattingColor_Update(panelIndex, chatType)
  chatColor._btnConfirm:addInputEvent("Mouse_LUp", "FGlobal_ChattingColor_SetColor( " .. panelIndex .. "," .. chatType .. "," .. chatButtonType .. "," .. tostring(isSystem) .. ")")
end
function ChattingColor_ClickedEvent()
  chatColor._btnWinClose:addInputEvent("Mouse_LUp", "ChattingColor_Hide()")
  chatColor._btnClose:addInputEvent("Mouse_LUp", "ChattingColor_Hide()")
end
function ChattingColor_RegisterEvent()
end
ChattingColor_Init()
ChattingColor_ClickedEvent()
