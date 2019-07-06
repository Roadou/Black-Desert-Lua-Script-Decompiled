local UI_TM = CppEnums.TextMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
Panel_PvpMode:SetShow(false)
local pvpText = UI.getChildControl(Panel_PvpMode, "StaticText_pvpText")
local _bubbleNotice = UI.getChildControl(Panel_PvpMode, "StaticText_Notice")
_pvpButton = UI.getChildControl(Panel_PvpMode, "CheckButton_PvpButton")
_pvpButton:addInputEvent("Mouse_LUp", "requestTogglePvP()")
Panel_PvpMode:addInputEvent("Mouse_On", "Panel_PvpMode_ChangeTexture_On()")
Panel_PvpMode:addInputEvent("Mouse_Out", "Panel_PvpMode_ChangeTexture_Off()")
Panel_PvpMode:addInputEvent("Mouse_LUp", "ResetPos_WidgetButton()")
Panel_PvpMode:SetPosX(Panel_MainStatus_User_Bar:GetPosX() - 20)
Panel_PvpMode:SetPosY(Panel_MainStatus_User_Bar:GetPosY() + Panel_MainStatus_User_Bar:GetSizeY() - 47)
posX = Panel_PvpMode:GetPosX()
posY = Panel_PvpMode:GetPosY()
local isPvPOn = true
local PvPOnCount = 0
local prePvp = false
local calculateTime = 0
function Panel_PvpMode_ChangeTexture_On()
  audioPostEvent_SystemUi(0, 10)
  _AudioPostEvent_SystemUiForXBOX(0, 10)
  Panel_PvpMode:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
  pvpText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PVPMODE_UI_MOVE"))
end
function Panel_PvpMode_ChangeTexture_Off()
  if Panel_UIControl:IsShow() then
    Panel_PvpMode:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
    pvpText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PVPMODE_UI"))
  else
    Panel_PvpMode:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
  end
end
function Panel_PvpMode_EnableSimpleUI()
  pvpText:SetAlpha(Panel_MainStatus_User_Bar:GetAlpha())
  _pvpButton:SetAlpha(Panel_MainStatus_User_Bar:GetAlpha())
  _bubbleNotice:SetAlpha(Panel_MainStatus_User_Bar:GetAlpha())
end
function Panel_PvpMode_DisableSimpleUI()
  pvpText:SetAlpha(1)
  _pvpButton:SetAlpha(1)
  _bubbleNotice:SetAlpha(1)
end
function Panel_PvpMode_UpdateSimpleUI(fDeltaTime)
  pvpText:SetAlpha(Panel_MainStatus_User_Bar:GetAlpha())
  _pvpButton:SetAlpha(Panel_MainStatus_User_Bar:GetAlpha())
  _bubbleNotice:SetAlpha(Panel_MainStatus_User_Bar:GetAlpha())
end
function Panel_PvpMode_UpdateState()
  if isPvpEnable() then
    isPvPOn = getPvPMode()
    _pvpButton:EraseAllEffect()
    if true == isPvPOn then
      _pvpButton:AddEffect("fUI_SkillButton02", true, 0, 0)
      _pvpButton:AddEffect("fUI_PvPButtonLoop", true, 0, 0)
    end
  end
end
registerEvent("SimpleUI_UpdatePerFrame", "Panel_PvpMode_UpdateSimpleUI")
registerEvent("EventSimpleUIEnable", "Panel_PvpMode_EnableSimpleUI")
registerEvent("EventSimpleUIDisable", "Panel_PvpMode_DisableSimpleUI")
function PvpModeButton_RefreshPosition()
  pvpText.posX = Panel_PvpMode:GetPosX()
  pvpText.posY = Panel_PvpMode:GetPosY()
  _bubbleNotice.posX = Panel_PvpMode:GetPosX()
  _bubbleNotice.posY = Panel_PvpMode:GetPosY()
  _pvpButton.posX = Panel_PvpMode:GetPosX()
  _pvpButton.posY = Panel_PvpMode:GetPosY()
end
function pvpMode_changedMode(actorKeyRaw)
  FromClient_PvpMode_changeMode(nil, actorKeyRaw)
end
function pvpMode_changedMode1(actorKeyRaw)
  if nil ~= actorKeyRaw then
    FromClient_PvpMode_changeMode(nil, actorKeyRaw)
  end
end
function FromClient_PvpMode_changeMode(where, actorKeyRaw)
  if nil ~= actorKeyRaw then
    local actorProxyWrapper = getActor(actorKeyRaw)
    if nil == actorProxyWrapper then
      return
    end
    if not actorProxyWrapper:get():isSelfPlayer() then
      return
    end
  end
  if true == ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eSwapRemasterUISetting) then
    return
  end
  if isPvpEnable() and false == isFlushedUI() then
    PvpMode_ShowButton(true)
    if getPvPMode() then
      audioPostEvent_SystemUi(0, 9)
      audioPostEvent_SystemUi(9, 0)
      _AudioPostEvent_SystemUiForXBOX(0, 9)
      _AudioPostEvent_SystemUiForXBOX(9, 0)
      _pvpButton:EraseAllEffect()
      _pvpButton:AddEffect("fUI_SkillButton02", true, 0, 0)
      _pvpButton:AddEffect("fUI_PvPButtonLoop", true, 0, 0)
      if nil == where then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PVP_BUTTON_ON"))
      end
      isPvPOn = true
    elseif isPvPOn then
      audioPostEvent_SystemUi(0, 11)
      _AudioPostEvent_SystemUiForXBOX(0, 11)
      _pvpButton:EraseAllEffect()
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PVP_BUTTON_OFF"))
      isPvPOn = false
    end
    PvpMode_ButtonTextureChange(isPvPOn)
    PaGlobal_SelfPlayerExpGage:SetFadeRate(5)
    PvpMode_Resize()
  else
    PvpMode_ShowButton(false)
  end
end
function PvpMode_PlayerPvPAbleChanged(actorKeyRaw)
  local selfWrapper = getSelfPlayer()
  if nil == selfWrapper then
    return
  end
  if selfWrapper:getActorKey() == actorKeyRaw then
    FromClient_PvpMode_changeMode(selfWrapper)
  end
end
function PvpMode_ButtonTextureChange(isPvp)
  if isPvp then
    _pvpButton:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_Toggle_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_pvpButton, 51, 1, 100, 50)
    _pvpButton:getBaseTexture():setUV(x1, y1, x2, y2)
    _pvpButton:setRenderTexture(_pvpButton:getBaseTexture())
  else
    _pvpButton:ChangeTextureInfoName("New_UI_Common_forLua/Default/Console_Toggle_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_pvpButton, 1, 1, 50, 50)
    _pvpButton:getBaseTexture():setUV(x1, y1, x2, y2)
    _pvpButton:setRenderTexture(_pvpButton:getBaseTexture())
  end
end
function PaGlobalFunc_PvpMode_ShowButton(isShow, isAni)
  Panel_PvpMode:SetShow(isShow)
  _pvpButton:SetShow(isShow)
  _pvpButton:ResetVertexAni()
  if isShow then
    _pvpButton:SetShow(true)
    local PvPModeOpen_Alpha = _pvpButton:addColorAnimation(0, 0.6, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    PvPModeOpen_Alpha:SetStartColor(UI_color.C_00FFFFFF)
    PvPModeOpen_Alpha:SetEndColor(UI_color.C_FFFFFFFF)
    PvPModeOpen_Alpha:SetHideAtEnd(false)
  else
    local PvPModeClose_Alpha = _pvpButton:addColorAnimation(0, 0.6, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    PvPModeClose_Alpha:SetStartColor(UI_color.C_FFFFFFFF)
    PvPModeClose_Alpha:SetEndColor(UI_color.C_00FFFFFF)
    PvPModeClose_Alpha:SetHideAtEnd(true)
    PvPModeClose_Alpha:SetDisableWhileAni(true)
  end
end
function PvpMode_Resize()
  if Panel_PvpMode:GetRelativePosX() == -1 and Panel_PvpMode:GetRelativePosY() == -1 then
    local initPosX = Panel_MainStatus_User_Bar:GetPosX() - 20
    local initPosY = Panel_MainStatus_User_Bar:GetPosY() + Panel_MainStatus_User_Bar:GetSizeY() - 47
    Panel_PvpMode:SetPosX(initPosX)
    Panel_PvpMode:SetPosY(initPosY)
    changePositionBySever(Panel_PvpMode, CppEnums.PAGameUIType.PAGameUIPanel_PvpMode, false, true, false)
    FGlobal_InitPanelRelativePos(Panel_PvpMode, initPosX, initPosY)
  elseif Panel_PvpMode:GetRelativePosX() == 0 and Panel_PvpMode:GetRelativePosY() == 0 then
    Panel_PvpMode:SetPosX(Panel_SelfPlayerExpGage:GetPosX() + Panel_SelfPlayerExpGage:GetSizeX() - 50)
    Panel_PvpMode:SetPosY(Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() - Panel_PvpMode:GetSizeY())
  else
    Panel_PvpMode:SetPosX(Panel_PvpMode:GetRelativePosX() * getScreenSizeX() - Panel_PvpMode:GetSizeX() / 2)
    Panel_PvpMode:SetPosY(Panel_PvpMode:GetRelativePosY() * getScreenSizeY() - Panel_PvpMode:GetSizeY() / 2)
  end
  FGlobal_PanelRepostionbyScreenOut(Panel_PvpMode)
end
registerEvent("EventPvPModeChanged", "pvpMode_changedMode1")
registerEvent("EventPlayerPvPAbleChanged", "PvpMode_PlayerPvPAbleChanged")
registerEvent("onScreenResize", "PvpMode_Resize")
registerEvent("FromClient_RenderModeChangeState", "PvpMode_Resize")
changePositionBySever(Panel_PvpMode, CppEnums.PAGameUIType.PAGameUIPanel_PvpMode, true, true, false)
