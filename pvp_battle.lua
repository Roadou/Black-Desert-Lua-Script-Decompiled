local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local IM = CppEnums.EProcessorInputMode
Panel_Icon_Duel:SetShow(false)
Panel_Icon_Duel:ActiveMouseEventEffect(true)
PaGlobal_PvPBattle = {
  _uiButtonMatchIcon = UI.getChildControl(Panel_Icon_Duel, "Button_DuelIcon")
}
PaGlobal_PvPBattle._uiButtonMatchIcon:addInputEvent("Mouse_RUp", "PaGlobal_PvPBattle:cancelMatch()")
PaGlobal_PvPBattle._uiButtonMatchIcon:addInputEvent("Mouse_On", "PaGlobal_PvPBattle:DuelFunc_ShowTooltip( true )")
PaGlobal_PvPBattle._uiButtonMatchIcon:addInputEvent("Mouse_Out", "PaGlobal_PvPBattle:DuelFunc_ShowTooltip()")
PaGlobal_PvPBattle._uiButtonMatchIcon:ActiveMouseEventEffect(true)
local requestPlayerList = {}
local refuseName = ""
local isPlaying, isPartyMember, isPartyLeader
function PaGlobal_PvPBattle:initialize()
  registerEvent("FromClient_AskPvPBattle", "PvPBattle_AskPvPBattle")
  registerEvent("FromClient_ReceiveStartPvPBattle", "PvPBattle_ReceiveStart")
  registerEvent("FromClient_ReceiveEndPvPBattle", "PvPBattle_ReceiveEnd")
  registerEvent("FromClient_AskAcceptPvPBattle", "PvPBattle_AskAcceptPvPBattle")
  registerEvent("FromClient_AskPvPIntrusion", "PvPBattle_AskPvPIntrusion")
end
function PaGlobal_PvPBattle:setPosMatchIcon()
  if isFlushedUI() then
    return
  end
  local selfPlayer = getSelfPlayer()
  isPlaying = selfPlayer:isDefinedPvPMatch()
  if isPlaying then
    Panel_Icon_Duel:SetShow(true)
    local posX, posY
    if nil ~= Panel_Icon_Maid and true == Panel_Icon_Maid:GetShow() then
      posX = Panel_Icon_Maid:GetPosX() + Panel_Icon_Maid:GetSizeX() - 3
      posY = Panel_Icon_Maid:GetPosY()
    elseif Panel_Window_PetIcon:GetShow() then
      posX = Panel_Window_PetIcon:GetPosX() + Panel_Window_PetIcon:GetSizeX() - 3
      posY = Panel_Window_PetIcon:GetPosY()
    elseif 0 < FGlobal_HouseIconCount() and Panel_MyHouseNavi:GetShow() then
      posX = Panel_MyHouseNavi:GetPosX() + 60 * FGlobal_HouseIconCount() - 3
      posY = Panel_MyHouseNavi:GetPosY()
    elseif 0 < FGlobal_ServantIconCount() and Panel_Window_Servant:GetShow() then
      posX = Panel_Window_Servant:GetPosX() + 60 * FGlobal_ServantIconCount() - 3
      posY = Panel_Window_Servant:GetPosY()
    else
      posX = 0
      posY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15
    end
    Panel_Icon_Duel:SetPosX(posX)
    Panel_Icon_Duel:SetPosY(posY)
  else
    Panel_Icon_Duel:SetShow(false)
  end
  PaGlobal_Camp:setPos()
  if true == _ContentsGroup_RenewUI_Main then
    Panel_Icon_Duel:SetShow(false)
  end
end
function PaGlobal_PvPBattle:DuelFunc_ShowTooltip(isShow)
  if nil == isShow then
    TooltipSimple_Hide()
    return
  end
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_PVPBATTLE_ICON_DUEL_SHOWTOOLTIP_NAME")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_PVPBATTLE_ICON_DUEL_SHOWTOOLTIP_DESC")
  TooltipSimple_Show(PaGlobal_PvPBattle._uiButtonMatchIcon, name, desc)
end
function PaGlobal_PvPBattle:duelInfo_Open()
end
function PaGlobal_PvPBattle:notifyRequest(targetCharacterName)
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PVPBATTLE_ACK_MSG_REQUEST", "characterName", targetCharacterName))
end
function PvPBattle_AskPvPIntrusion(targetNmae)
  local secondYesButton = function()
    ToClient_PvPIntrusionSelectTeam(true)
  end
  local secondNoButton = function()
    ToClient_PvPIntrusionSelectTeam(false)
  end
  local function askYesButton()
    local secmessageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PVPBATTLE_TEAMSEL_MESSAGEBOX_MEMO", "characterName", targetNmae)
    local secmessageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_PVPBATTLE_REQUEST_MESSAGEBOX_TITLE"),
      content = secmessageBoxMemo,
      functionYes = secondYesButton,
      functionNo = secondNoButton,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(secmessageBoxData)
  end
  local askNoButton = function()
  end
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PVPBATTLE_INSTRUSION_MESSAGEBOX_MEMO", "characterName", targetNmae)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_PVPBATTLE_REQUEST_MESSAGEBOX_TITLE"),
    content = messageBoxMemo,
    functionYes = askYesButton,
    functionNo = askNoButton,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PvPBattle_AskPvPBattle(requesterName, fromInstrusion, wantTeam)
  for ii = 0, #requestPlayerList do
    if requesterName == requestPlayerList[ii] then
      return
    end
  end
  requestPlayerList[#requestPlayerList] = requesterName
  refuseName = requesterName
  local function askYesButton()
    ToClient_AcceptPvPBattle(true, wantTeam)
    requestPlayerList = {}
  end
  local function askNoButton()
    ToClient_AcceptPvPBattle(false)
    for ii = 0, #requestPlayerList do
      if refuseName == requestPlayerList[ii] then
        requestPlayerList[ii] = ""
      end
    end
  end
  if true == fromInstrusion then
    local teammessageBoxMemo
    if true == wantTeam then
      teammessageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PVPBATTLE_WANTTEAM_MESSAGEBOX_MEMO", "characterName", requesterName)
    else
      teammessageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PVPBATTLE_NOTWANTTEAM_MESSAGEBOX_MEMO", "characterName", requesterName)
    end
    local teammessageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_PVPBATTLE_REQUEST_MESSAGEBOX_TITLE"),
      content = teammessageBoxMemo,
      functionYes = askYesButton,
      functionNo = askNoButton,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(teammessageBoxData)
  else
    PaGlobal_Option:EventXXX("CheckButton_RefuseRequests", 1, 0)
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PVPBATTLE_REQUEST_MESSAGEBOX_MEMO", "characterName", requesterName)
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_PVPBATTLE_REQUEST_MESSAGEBOX_TITLE"),
      content = messageBoxMemo,
      functionYes = askYesButton,
      functionNo = askNoButton,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "top", false, true, 1)
  end
end
function PvPBattle_AskAcceptPvPBattle(isAutoCancle)
  local messageBoxMemo
  if isAutoCancle then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_NOTIFY_PVP_REFUSE")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_NOTIFY_PVP_CANCLE")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_PVPBATTLE_REQUEST_MESSAGEBOX_TITLE"),
    content = messageBoxMemo,
    functionApply = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_PvPBattle:cancelMatch()
  local selfPlayer = getSelfPlayer()
  local selfActorKeyRaw = selfPlayer:getActorKey()
  isPartyMember = selfPlayer:isPartyMemberActorKey(selfActorKeyRaw)
  isPartyLeader = selfPlayer:isPartyLeader(selfActorKeyRaw)
  if true == isPartyMember and false == isPartyLeader then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PVPBATTLE_ACK_MSG_CANCELLEADERONLY"))
    return
  end
  local cancelYesButton = function()
    ToClient_CancelPvpBattle()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_PVPBATTLE_CANCEL_MESSAGEBOX_MEMO")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_PVPBATTLE_CANCEL_MESSAGEBOX_TITLE"),
    content = messageBoxMemo,
    functionYes = cancelYesButton,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PvPBattle_ReceiveStart(matchType, roundId, isFight)
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PVPBATTLE_ACK_MSG_START"))
  isPlaying = true
  if true == _ContentsGroup_RemasterUI_Main then
    PaGlobalFunc_ServantIcon_UpdateOtherIcon(PaGlobalFunc_ServantIcon_GetBattleIndex())
  else
    PaGlobal_PvPBattle:setPosMatchIcon()
  end
end
function PvPBattle_ReceiveEnd(matchType, roundId, isFight)
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PVPBATTLE_ACK_MSG_END"))
  isPlaying = false
  if true == _ContentsGroup_RemasterUI_Main then
    PaGlobalFunc_ServantIcon_UpdateOtherIcon(PaGlobalFunc_ServantIcon_GetBattleIndex())
  else
    PaGlobal_PvPBattle:setPosMatchIcon()
  end
end
PaGlobal_PvPBattle:initialize()
