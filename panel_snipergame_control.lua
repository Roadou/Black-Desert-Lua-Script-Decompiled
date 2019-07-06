local PaGlobal_SniperGame_Control = {_renderMode = nil, _firstShow = true}
local self = PaGlobal_SniperGame_Control
function PaGlobal_SniperGame_Control:Open()
  self._renderMode:set()
end
function PaGlobal_SniperGame_Control:Close()
  PaGlobal_SniperGame:Close()
  PaGlobal_SniperGame_Result:Close()
  self._renderMode:reset()
end
function FromClient_SniperGame_StateBegin_Process(state)
  if state == __eSniperGameState_None then
    self._firstShow = true
  elseif state == __eSniperGameState_Searching then
    PaGlobal_SniperGame:StartSearchMode(self._firstShow)
    PaGlobal_SniperGame_Result:Close()
    PaGlobalFunc_SniperReload_Close()
  elseif state == __eSniperGameState_RecoverBreath then
    self._firstShow = false
  elseif state == __eSniperGameState_AimMiniGame then
    PaGlobal_SniperGame:StartAimMiniGame()
    PaGlobal_SniperGame_Result:Close()
    self._firstShow = true
    PaGlobal_SniperGame_Result:ClearResult()
  elseif state == __eSniperGameState_Shoot then
    PaGlobal_SniperGame:StartShootingAnimation(0.12, 0.06)
    self._firstShow = true
  elseif state == __eSniperGameState_CheckResult then
    self._firstShow = true
    PaGlobal_SniperGame:Close()
    PaGlobal_SniperGame_Result:Open()
  elseif state == __eSniperGameState_Reloading then
    self._firstShow = true
    PaGlobal_SniperGame:Close()
  end
end
function FromClient_SniperGame_StateEnd_Process(state)
  if state == __eSniperGameState_AimMiniGame then
    PaGlobal_SniperGame:EndAimMiniGame()
  elseif state == __eSniperGameState_Reloading then
    if false == ToClient_SniperGame_IsPlaying() then
      return
    end
    PaGlobalFunc_SniperReload_Close()
    PaGlobal_SniperGame_Result:Close()
    PaGlobal_SniperGame:Open()
    PaGlobal_SniperGame_FadeIn()
  end
end
function FromClient_SniperGame_ImpactResult_Process(devitaionRadius, desiredScreenPos, hittedScreenPos, hitPartType)
  PaGlobal_SniperGame_Result:UpdateShootResult(devitaionRadius, desiredScreenPos, hittedScreenPos, hitPartType)
end
function onScreenResize_SniperGame_Process()
  PaGlobal_SniperGame:OnScreenResize(getScreenSizeX(), getScreenSizeY())
  PaGlobal_SniperGame_Result:OnScreenResize(getScreenSizeX(), getScreenSizeY())
end
function FromClient_SniperGame_Missed_Process(devitaionRadius, desiredScreenPos, hittedScreenPos)
  PaGlobal_SniperGame_Result:UpdateMissResult(devitaionRadius, desiredScreenPos, hittedScreenPos)
end
function PaGlobalFunc_SniperGame_StartSniperGame()
  if false == ToClient_SniperGame_StartPlay() then
    return
  end
  PaGlobal_SniperGame_PanelManager_SetShowPanelStatus(true, false)
  PaGlobal_SniperGame_Control:Open()
  PaGlobal_SniperGame:Open()
  PaGlobal_SniperGame_FadeIn()
  ToClient_SniperGame_ChangeState(__eSniperGameState_None)
end
function PaGlobalFunc_SniperGame_EndSniperGame()
  if false == ToClient_SniperGame_IsPlaying() then
    return
  end
  ToClient_SniperGame_StopPlay()
  PaGlobal_SniperGame_Control:Close()
  PaGlobal_SniperGame_Close()
  PaGlobalFunc_SniperReload_Close()
  PaGlobal_SniperGame_Result_Close()
  ToClient_SniperGame_ChangeState(__eSniperGameState_None)
  PaGlobal_SniperGame_PanelManager_SetShowPanelStatus(false, false)
end
function PaGlobalFunc_SniperGame_StartSearching()
  ToClient_SniperGame_ChangeState(__eSniperGameState_Searching)
end
function PaGlobalFunc_SniperGame_StartAimMini()
  if false == PaGlobal_SniperGame._startAniIsPlaying then
    ToClient_SniperGame_ChangeState(__eSniperGameState_AimMiniGame)
  end
end
function PaGlobalFunc_SniperGame_StartShoot()
  ToClient_SniperGame_ChangeState(__eSniperGameState_Shoot)
end
function PaGlobalFunc_SniperGame_StartCheckResult()
  ToClient_SniperGame_ChangeState(__eSniperGameState_CheckResult)
end
function PaGlobalFunc_SniperGame_StartReloading()
  ToClient_SniperGame_ChangeState(__eSniperGameState_Reloading)
end
function PaGlobalFunc_SniperGame_StartRecovery()
  ToClient_SniperGame_ChangeState(__eSniperGameState_RecoverBreath)
end
PaGlobal_SniperGame_PanelManager = {
  _eType = {
    _sniper = 1,
    _result = 2,
    _reload = 3
  }
}
function PaGlobal_SniperGame_PanelManager:setPanel(ePanelType, panel)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_SniperGame_PanelManager:setPanel ePanelType nil", "\236\160\149\236\167\128\237\152\156")
  UI.ASSERT_NAME(nil ~= panel, "PaGlobal_SniperGame_PanelManager:setPanel panel nil", "\236\160\149\236\167\128\237\152\156")
  if PaGlobal_SniperGame_PanelManager._eType._sniper == ePanelType then
    Panel_SniperGame = panel
  elseif PaGlobal_SniperGame_PanelManager._eType._result == ePanelType then
    Panel_SniperGame_Result = panel
  elseif PaGlobal_SniperGame_PanelManager._eType._reload == ePanelType then
    MiniGame_SniperReload = panel
  end
end
function PaGlobal_SniperGame_PanelManager:getPanel(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_SniperGame_PanelManager:getPanel ePanelType nil", "\236\160\149\236\167\128\237\152\156")
  if PaGlobal_SniperGame_PanelManager._eType._sniper == ePanelType then
    return Panel_SniperGame
  elseif PaGlobal_SniperGame_PanelManager._eType._result == ePanelType then
    return Panel_SniperGame_Result
  elseif PaGlobal_SniperGame_PanelManager._eType._reload == ePanelType then
    return MiniGame_SniperReload
  end
  return nil
end
function PaGlobal_SniperGame_PanelManager:checkLoadUI(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobalFunc_SniperGame_CheckLoadUI ePanelType nil", "\236\160\149\236\167\128\237\152\156")
  local rv
  if PaGlobal_SniperGame_PanelManager._eType._sniper == ePanelType then
    rv = reqLoadUI("UI_Data/Widget/SniperGame/Panel_SniperGame.xml", "Panel_SniperGame", Defines.UIGroup.PAGameUIGroup_Widget, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default,
      Defines.RenderMode.eRenderMode_SniperGame
    }))
  elseif PaGlobal_SniperGame_PanelManager._eType._result == ePanelType then
    rv = reqLoadUI("UI_Data/Widget/SniperGame/Panel_SniperGame_Result.xml", "Panel_SniperGame_Result", Defines.UIGroup.PAGameUIGroup_Widget, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_SniperGame
    }))
  elseif PaGlobal_SniperGame_PanelManager._eType._reload == ePanelType then
    rv = reqLoadUI("UI_Data/Widget/MiniGame/MiniGame_SniperReload.xml", "MiniGame_SniperReload", Defines.UIGroup.PAGameUIGroup_Widget, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_SniperGame
    }))
  end
  if nil ~= rv and 0 ~= rv then
    PaGlobal_SniperGame_PanelManager:setPanel(ePanelType, rv)
    rv = nil
    PaGlobal_SniperGame_PanelManager:Initialize(ePanelType)
  end
end
function PaGlobal_SniperGame_PanelManager:Initialize(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_SniperGame_PanelManager:initialize ePanelType nil", "\236\160\149\236\167\128\237\152\156")
  if PaGlobal_SniperGame_PanelManager._eType._sniper == ePanelType then
    PaGlobal_SniperGame:Initialize()
  elseif PaGlobal_SniperGame_PanelManager._eType._result == ePanelType then
    PaGlobal_SniperGame_Result:Initialize()
  elseif PaGlobal_SniperGame_PanelManager._eType._reload == ePanelType then
    PaGlobalFunc_SniperReload_Initialize()
  end
end
function PaGlobal_SniperGame_PanelManager:checkCloseUI(ePanelType, isAni)
  if nil == ePanelType then
    return
  end
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_SkillWindowManager:checkCloseUI ePanelType nil", "\236\160\149\236\167\128\237\152\156")
  local panel = PaGlobal_SniperGame_PanelManager:getPanel(ePanelType)
  if nil == panel or 0 == panel then
    return
  end
  reqCloseUI(panel, isAni)
end
function PaGlobal_SniperGame_PanelManager_CheckLoadUIAll()
  PaGlobal_SniperGame_PanelManager:checkLoadUI(PaGlobal_SniperGame_PanelManager._eType._sniper)
  PaGlobal_SniperGame_PanelManager:checkLoadUI(PaGlobal_SniperGame_PanelManager._eType._result)
  PaGlobal_SniperGame_PanelManager:checkLoadUI(PaGlobal_SniperGame_PanelManager._eType._reload)
end
function PaGlobal_SniperGame_PanelManager_CheckCloseUIAll(isAni)
  for k, v in pairs(PaGlobal_SniperGame_PanelManager._eType) do
    PaGlobal_SniperGame_PanelManager:checkCloseUI(v, isAni)
  end
end
function PaGlobal_SniperGame_PanelManager_SetShowPanelStatus(isShow, isAni)
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_SniperGame_PanelManager_SetShowPanelStatus isShow nil", "\236\160\149\236\167\128\237\152\156")
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_SniperGame:SetShow(isShow, isAni)
    return
  end
  if true == isShow then
    PaGlobal_SniperGame_PanelManager_CheckLoadUIAll()
    if nil ~= Panel_SniperGame then
      Panel_SniperGame:SetShow(isShow, isAni)
    end
  else
    PaGlobal_SniperGame_PanelManager_CheckCloseUIAll(isAni)
  end
end
function FromClient_luaLoadComplete_SniperGame()
  local self = PaGlobal_SniperGame_Control
  self._renderMode = RenderModeWrapper.new(100, {
    Defines.RenderMode.eRenderMode_SniperGame
  }, false)
  self._renderMode:setClosefunctor(PaGlobal_SniperGame_Control._renderMode, PaGlobalFunc_SniperGame_EndSniperGame)
  PaGlobalFunc_SniperGame_registEventHandler()
end
function PaGlobalFunc_SniperGame_registEventHandler()
  ActionChartEventBindFunction(360, PaGlobalFunc_SniperGame_StartSniperGame)
  ActionChartEventBindFunction(361, PaGlobalFunc_SniperGame_StartSearching)
  ActionChartEventBindFunction(362, PaGlobalFunc_SniperGame_StartAimMini)
  ActionChartEventBindFunction(363, PaGlobalFunc_SniperGame_StartRecovery)
  ActionChartEventBindFunction(364, PaGlobalFunc_SniperGame_StartShoot)
  ActionChartEventBindFunction(365, PaGlobalFunc_SniperGame_StartCheckResult)
  ActionChartEventBindFunction(366, PaGlobalFunc_SniperGame_StartReloading)
  ActionChartEventBindFunction(367, PaGlobalFunc_SniperGame_EndSniperGame)
  registerEvent("FromClient_SniperGame_StateBegin", "FromClient_SniperGame_StateBegin_Process")
  registerEvent("FromClient_SniperGame_StateEnd", "FromClient_SniperGame_StateEnd_Process")
  registerEvent("FromClient_SniperGame_ImpactResult", "FromClient_SniperGame_ImpactResult_Process")
  registerEvent("FromClient_SniperGame_Missed", "FromClient_SniperGame_Missed_Process")
  registerEvent("onScreenResize", "onScreenResize_SniperGame_Process")
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_SniperGame")
