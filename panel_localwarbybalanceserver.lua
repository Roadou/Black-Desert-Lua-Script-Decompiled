PaGlobal_LocalwarByBalanceServer = {
  _ui = {localwarWidget = nil, txt_LocalwarIcon = nil}
}
function PaGlobal_Panel_LocalwarByBalanceServer_Init()
  if nil == Panel_LocalwarByBalanceServer then
    return
  end
  Panel_LocalwarByBalanceServer:SetShow(false)
  PaGlobal_LocalwarByBalanceServer._ui.localwarWidget = UI.getChildControl(Panel_LocalwarByBalanceServer, "Static_LocalWar")
  PaGlobal_LocalwarByBalanceServer._ui.txt_LocalwarIcon = UI.getChildControl(PaGlobal_LocalwarByBalanceServer._ui.localwarWidget, "StaticText_1")
  PaGlobal_LocalwarByBalanceServer._ui.txt_LocalwarIcon:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_LOCALWAR_INFO"))
  PaGlobal_LocalwarByBalanceServer._ui.localwarWidget:addInputEvent("Mouse_LUp", "PaGlobal_Panel_LocalwarByBalanceServer_ClickMessage()")
  PaGlobal_LocalwarByBalanceServer._ui.localwarWidget:SetVertexAniRun("Ani_Color_Reset", true)
end
function PaGlobal_Panel_LocalwarByBalanceServer_ClickMessage()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CURRENTCHANNELJOIN")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = PaGlobal_Panel_LocalwarByBalanceServer_Click,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_Panel_LocalwarByBalanceServer_Click()
  audioPostEvent_SystemUi(1, 6)
  _AudioPostEvent_SystemUiForXBOX(1, 6)
  local playerWrapper = getSelfPlayer()
  local player = playerWrapper:get()
  local hp = player:getHp()
  local maxHp = player:getMaxHp()
  local isGameMaster = ToClient_SelfPlayerIsGM()
  if 0 == ToClient_GetMyTeamNoLocalWar() then
    if hp == maxHp or isGameMaster then
      ToClient_JoinLocalWar()
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_MAXHP_CHECK"))
    end
  elseif hp == maxHp or isGameMaster then
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_MAXHP_CHECK"))
  end
end
function PaGlobal_Panel_LocalwarByBalanceServer_Position()
  if nil == Panel_LocalwarByBalanceServer then
    return
  end
  if nil ~= Panel_Radar and true == Panel_Radar:GetShow() then
    Panel_LocalwarByBalanceServer:SetPosX(getScreenSizeX() - Panel_Radar:GetSizeX() - Panel_LocalwarByBalanceServer:GetSizeX() - 5)
    Panel_LocalwarByBalanceServer:SetPosY(FGlobal_Panel_Radar_GetPosY() + 205)
  elseif nil ~= Panel_WorldMiniMap and true == Panel_WorldMiniMap:GetShow() then
    Panel_LocalwarByBalanceServer:SetPosX(getScreenSizeX() - Panel_WorldMiniMap:GetSizeX() - Panel_LocalwarByBalanceServer:GetSizeX() - 30)
    Panel_LocalwarByBalanceServer:SetPosY(Panel_WorldMiniMap:GetPosY() + 200)
  else
    Panel_LocalwarByBalanceServer:SetPosX(getScreenSizeX() - Panel_LocalwarByBalanceServer:GetSizeX() - 30)
    Panel_LocalwarByBalanceServer:SetPosY(30)
  end
end
function PaGlobal_Panel_LocalwarByBalanceServer_Open()
  local curChannelData = getCurrentChannelServerData()
  local isBalanceServer = curChannelData._isBalanceChannel
  if true == isBalanceServer then
    if 0 == ToClient_GetMyTeamNoLocalWar() then
      PaGlobalFunc_LocalwarByBalanceServer_SetShowPanel(true, false)
    else
      PaGlobalFunc_LocalwarByBalanceServer_SetShowPanel(false, false)
    end
  else
    PaGlobalFunc_LocalwarByBalanceServer_SetShowPanel(false, false)
  end
  if nil ~= Panel_LocalwarByBalanceServer then
    if nil ~= Panel_Radar and true == Panel_Radar:GetShow() then
      Panel_LocalwarByBalanceServer:SetPosX(getScreenSizeX() - Panel_Radar:GetSizeX() - Panel_LocalwarByBalanceServer:GetSizeX() - 5)
      Panel_LocalwarByBalanceServer:SetPosY(FGlobal_Panel_Radar_GetPosY() + 205)
    elseif nil ~= Panel_WorldMiniMap and true == Panel_WorldMiniMap:GetShow() then
      Panel_LocalwarByBalanceServer:SetPosX(getScreenSizeX() - Panel_WorldMiniMap:GetSizeX() - Panel_LocalwarByBalanceServer:GetSizeX() - 30)
      Panel_LocalwarByBalanceServer:SetPosY(Panel_WorldMiniMap:GetPosY() + 200)
    else
      Panel_LocalwarByBalanceServer:SetPosX(getScreenSizeX() - Panel_LocalwarByBalanceServer:GetSizeX() - 30)
      Panel_LocalwarByBalanceServer:SetPosY(30)
    end
  end
end
function PaGlobalFunc_LocalwarByBalanceServer_CheckLoadUI()
  local rv = reqLoadUI("UI_Data/Widget/MainStatus/Panel_LocalwarByBalanceServer.XML", "Panel_LocalwarByBalanceServer", Defines.UIGroup.PAGameUIGroup_Widget, SETRENDERMODE_BITSET_DEFULAT())
  if nil ~= rv or 0 ~= rv then
    Panel_LocalwarByBalanceServer = rv
    rv = nil
    PaGlobal_Panel_LocalwarByBalanceServer_Init()
  end
end
function PaGlobalFunc_LocalwarByBalanceServer_CheckCloseUI(isAni)
  if nil == Panel_LocalwarByBalanceServer then
    return
  end
  reqCloseUI(Panel_LocalwarByBalanceServer, isAni)
end
function PaGlobalFunc_LocalwarByBalanceServer_SetShowPanel(isShow, isAni)
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobalFunc_LocalwarByBalanceServer_SetShowPanel isShow nil", "\236\160\149\236\167\128\237\152\156")
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_LocalwarByBalanceServer:SetShow(isShow, isAni)
    return
  end
  if true == isShow then
    PaGlobalFunc_LocalwarByBalanceServer_CheckLoadUI()
    if nil ~= Panel_LocalwarByBalanceServer then
      Panel_LocalwarByBalanceServer:SetShow(isShow, isAni)
    end
  else
    PaGlobalFunc_LocalwarByBalanceServer_CheckCloseUI(isAni)
  end
end
function FromClient_luaLoadComplete_LocalwarByBalanceServer()
  PaGlobal_Panel_LocalwarByBalanceServer_Open()
  registerEvent("onScreenResize", "PaGlobal_Panel_LocalwarByBalanceServer_Position")
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_LocalwarByBalanceServer")
