Instance_Widget_Adrenallin:SetShow(false)
local ui = {
  _adCircleProgress = UI.getChildControl(Instance_Widget_Adrenallin, "CircularProgress_Adrenallin"),
  _txt_Adrenallin = UI.getChildControl(Instance_Widget_Adrenallin, "StaticText_AdPercent")
}
local _close_Adrenallin = UI.getChildControl(Instance_Widget_Adrenallin, "Button_Win_Close")
_close_Adrenallin:SetShow(false)
local prevAdrenallin = 0
_transLockButton = UI.getChildControl(Instance_Widget_Adrenallin, "Button_TransLock")
if _ContentsGroup_BlackSpiritLock then
  _transLockButton:addInputEvent("Mouse_LUp", "FGlobal_BlackSpiritSkillLock_Open(0)")
else
  _transLockButton:addInputEvent("Mouse_LUp", "requestBlackSpritSkill()")
end
_staticLockButton = UI.getChildControl(Instance_Widget_Adrenallin, "Static_Lock")
_staticLockButton:SetShow(false)
function UseableBlackSpritSkill()
  if true == ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eSwapRemasterUISetting) then
    return
  end
  local selfPlayer = getSelfPlayer()
  if false == selfPlayer:isEnableAdrenalin() then
    return
  end
  if true == selfPlayer:isUseableBlackSpritSkill() then
    _staticLockButton:SetShow(false)
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_USEABLE_BLACKSPRITSKILL"), 5)
  else
    _staticLockButton:SetShow(true)
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NOTUSEABLE_BLACKSPRITSKILL"), 5)
  end
end
function adrenallin_Update()
  local selfPlayer = getSelfPlayer()
  local adrenallin = selfPlayer:getAdrenalin()
  adrenallin = adrenallin / 10
  adrenallin = math.floor(adrenallin) / 10
  adrenallin = string.format("%.1f", adrenallin)
  ui._adCircleProgress:SetProgressRate(adrenallin)
  ui._txt_Adrenallin:SetText(adrenallin .. "%")
  if prevAdrenallin == adrenallin or false == _ContentsGroup_RenewUI_Main then
  end
  prevAdrenallin = adrenallin
  local isUseRage = getSelfPlayer():isUseableBlackSpritSkill()
  _staticLockButton:SetShow(not isUseRage)
end
function Panel_adrenallin_EnableSimpleUI()
  Panel_adrenallin_SetAlphaAllChild(Instance_Widget_MainStatus_User_Bar:GetAlpha())
end
function Panel_adrenallin_DisableSimpleUI()
  Panel_adrenallin_SetAlphaAllChild(1)
end
function Panel_adrenallin_UpdateSimpleUI(fDeltaTime)
  Panel_adrenallin_SetAlphaAllChild(Instance_Widget_MainStatus_User_Bar:GetAlpha())
end
function Panel_adrenallin_SetAlphaAllChild(alphaValue)
  Instance_Widget_Adrenallin:SetAlpha(alphaValue)
  ui._adCircleProgress:SetAlpha(alphaValue)
  ui._txt_Adrenallin:SetFontAlpha(alphaValue)
end
registerEvent("SimpleUI_UpdatePerFrame", "Panel_adrenallin_UpdateSimpleUI")
registerEvent("EventSimpleUIEnable", "Panel_adrenallin_EnableSimpleUI")
registerEvent("EventSimpleUIDisable", "Panel_adrenallin_DisableSimpleUI")
function FromClient_UpdateAdrenalin()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if true == _ContentsGroup_RenewUI_Main then
    Instance_Widget_Adrenallin:SetShow(false)
  else
    Instance_Widget_Adrenallin:SetShow(getSelfPlayer():isEnableAdrenalin() and not isRecordMode and not PaGlobalFunc_IsRemasterUIOption())
  end
  adrenallin_Update()
end
function FromClient_ChangeAdrenalinMode()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  adrenallin_Update()
  if not isLuaLoadingComplete then
    return
  elseif Defines.UIMode.eUIMode_Default ~= GetUIMode() then
    return
  end
  if Instance_Widget_Adrenallin:GetRelativePosX() == -1 and Instance_Widget_Adrenallin:GetRelativePosY() == -1 then
    local initPosX = getScreenSizeX() / 2 - Instance_Widget_Adrenallin:GetSizeX() / 2 + 195
    local initPosY = getScreenSizeY() - Instance_QuickSlot:GetSizeY() - 45
    Instance_Widget_Adrenallin:SetPosX(initPosX)
    Instance_Widget_Adrenallin:SetPosY(initPosY)
    changePositionBySever(Instance_Widget_Adrenallin, CppEnums.PAGameUIType.PAGameUIPanel_Adrenallin, false, true, false)
    FGlobal_InitPanelRelativePos(Instance_Widget_Adrenallin, initPosX, initPosY)
  elseif Instance_Widget_Adrenallin:GetRelativePosX() == 0 and Instance_Widget_Adrenallin:GetRelativePosY() == 0 then
    Instance_Widget_Adrenallin:SetPosX(getScreenSizeX() / 2 - Instance_Widget_Adrenallin:GetSizeX() / 2 + 195)
    Instance_Widget_Adrenallin:SetPosY(getScreenSizeY() - Instance_QuickSlot:GetSizeY() - 45)
  else
    Instance_Widget_Adrenallin:SetPosX(getScreenSizeX() * Instance_Widget_Adrenallin:GetRelativePosX() - Instance_Widget_Adrenallin:GetSizeX() / 2)
    Instance_Widget_Adrenallin:SetPosY(getScreenSizeY() * Instance_Widget_Adrenallin:GetRelativePosY() - Instance_Widget_Adrenallin:GetSizeY() / 2)
  end
  if true == _ContentsGroup_RenewUI_Main then
    Instance_Widget_Adrenallin:SetShow(false)
  else
    Instance_Widget_Adrenallin:SetShow(getSelfPlayer():isEnableAdrenalin() and not isRecordMode and not PaGlobalFunc_IsRemasterUIOption())
  end
end
function Adrenallin_ShowSimpleToolTip(isShow)
  local count = ToClient_GetApRegenAmount()
  local countString = string.format("%.2f", count / 100)
  name = PAGetString(Defines.StringSheet_GAME, "LUA_ADRENALLIN_TOOLTIP_TITLE")
  if _ContentsGroup_BlackSpiritLock then
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ADRENALLIN_TOOLTIP_DESC_2", "count", tostring(countString))
  else
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ADRENALLIN_TOOLTIP_DESC", "count", tostring(countString))
  end
  uiControl = Instance_Widget_Adrenallin
  registTooltipControl(uiControl, Instance_Tooltip_SimpleText)
  if isShow == true then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function Panel_Adrenallin_ChangeTexture_On()
  Instance_Widget_Adrenallin:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
  _close_Adrenallin:SetShow(true)
end
function Panel_Adrenallin_ChangeTexture_Off()
  _close_Adrenallin:SetShow(false)
  if Panel_UIControl:IsShow() then
    Instance_Widget_Adrenallin:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
  else
    Instance_Widget_Adrenallin:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
  end
end
function check_Adrenallin_PostEvent(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  FromClient_ChangeAdrenalinMode()
end
registerEvent("FromClient_RenderModeChangeState", "check_Adrenallin_PostEvent")
function Panel_Adrenallin_OnSreenResize()
  local initPosX = getScreenSizeX() / 2 - Instance_Widget_Adrenallin:GetSizeX() / 2 + 195
  local initPosY = Instance_Widget_MainStatus_User_Bar:GetPosY() - 5
  Instance_Widget_Adrenallin:SetPosX(initPosX)
  Instance_Widget_Adrenallin:SetPosY(initPosY)
  Instance_Widget_Adrenallin:SetShow(getSelfPlayer():isEnableAdrenalin())
end
FromClient_UpdateAdrenalin()
FromClient_ChangeAdrenalinMode()
Instance_Widget_Adrenallin:addInputEvent("Mouse_On", "Panel_Adrenallin_ChangeTexture_On()")
Instance_Widget_Adrenallin:addInputEvent("Mouse_Out", "Panel_Adrenallin_ChangeTexture_Off()")
_transLockButton:addInputEvent("Mouse_On", "Adrenallin_ShowSimpleToolTip( true )")
_transLockButton:addInputEvent("Mouse_Out", "Adrenallin_ShowSimpleToolTip( false ) ")
Instance_Widget_Adrenallin:setTooltipEventRegistFunc("Adrenallin_ShowSimpleToolTip( true )")
registerEvent("FromClient_UpdateAdrenalin", "FromClient_UpdateAdrenalin")
registerEvent("FromClient_ChangeAdrenalinMode", "FromClient_ChangeAdrenalinMode")
registerEvent("onScreenResize", "Panel_Adrenallin_OnSreenResize")
registerEvent("FromClient_RenderModeChangeState", "Panel_Adrenallin_OnSreenResize")
registerEvent("FromClient_UseableBlackSpritSkill", "UseableBlackSpritSkill")
function Panel_Adrenallin_InitShow()
  Instance_Widget_Adrenallin:SetShow(getSelfPlayer():isEnableAdrenalin())
end
function Panel_Adrenallin_SetShow(isShow, isAni)
  Instance_Widget_Adrenallin:SetShow(isShow and not PaGlobalFunc_IsRemasterUIOption())
  adrenallin_Update()
end
Panel_Adrenallin_InitShow()
