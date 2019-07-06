local ReconnectUI = {_currentAccTime = 0, _isExit = false}
function PaGlobal_ReconnectUI_Init()
  local self = ReconnectUI
  self._currentAccTime = 0
  self._isExit = false
  local panel = ToClient_getReconnectProccessingMessagePanel()
  local txt_LoadingEffect = UI.getChildControl(panel, "StaticText_LoadingEffect")
  txt_LoadingEffect:EraseAllEffect()
  txt_LoadingEffect:AddEffect("UI_Loading_01A", true, 0, 0)
  panel:RegisterShowEventFunc(true, "PaGlobal_ReconnectUI_ShowAni()")
  registerEvent("FromClient_UpdateReconnectUI", "PaGlobal_ReconnectUI_UpdateReconnectUI")
end
function PaGlobal_ReconnectUI_ShowAni()
  local panel = ToClient_getReconnectProccessingMessagePanel()
  if nil == panel then
    return
  end
  local showAni = panel:addColorAnimation(0, 0.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  showAni:SetStartColor(Defines.Color.C_00000000)
  showAni:SetEndColor(Defines.Color.C_FF000000)
  showAni:SetStartIntensity(3)
  showAni:SetEndIntensity(1)
  showAni.IsChangeChild = true
end
function PaGlobal_ReconnectUI_UpdateReconnectUI(deltaTime, panel)
  if nil == panel then
    return
  end
  local self = ReconnectUI
  if true == isKeyDown_Once(CppEnums.VirtualKeyCode.KeyCode_ESCAPE) then
    if false == self._isExit then
      ToClient_CancelReconnect()
    end
    self._isExit = true
  end
  panel:SetSize(getScreenSizeX(), getScreenSizeY())
  panel:ComputePos()
  self._currentAccTime = self._currentAccTime + deltaTime
  local stc_LoadingEffect = UI.getChildControl(panel, "StaticText_LoadingEffect")
  stc_LoadingEffect:ComputePos()
  stc_LoadingEffect:SetPosX(getScreenSizeX() / 2 - (stc_LoadingEffect:GetTextSpan().x + stc_LoadingEffect:GetTextSizeX()) / 2)
  local stc_EscDesc = UI.getChildControl(panel, "StaticText_Desc")
  stc_EscDesc:ComputePos()
  if false == self._isExit then
    stc_LoadingEffect:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAME_WINDOW_RECONNECT_MSG", "second", math.floor(self._currentAccTime)))
  else
    stc_LoadingEffect:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_RECONNECT_EXIT_MSG"))
  end
end
