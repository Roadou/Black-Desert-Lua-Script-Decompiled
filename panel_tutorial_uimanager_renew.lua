registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_TutorialUiManager")
registerEvent("onScreenResize", "FromClient_TutorialScreenReposition")
registerEvent("EventSelfPlayerLevelUp", "FromClient_EventSelfPlayerLevelUp_TutorialUiManager")
PaGlobal_TutorialUiManager = {
  _uiList = {
    _uiBlackSpirit = nil,
    _uiHeadlineMessage = nil,
    _uiMasking = nil
  }
}
function PaGlobal_TutorialUiManager:initialize()
  self._uiList._uiBlackSpirit = PaGlobal_TutorialUiBlackSpirit
  self._uiList._uiBlackSpirit:initialize()
  self._uiList._uiHeadlineMessage = PaGlobal_TutorialUiHeadlineMessage
  self._uiList._uiHeadlineMessage:initialize()
  self._uiList._uiMasking = PaGlobal_TutorialUiMasking
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialUiManager:initialize() UI \235\167\164\235\139\136\236\160\128 \236\180\136\234\184\176\237\153\148 \236\153\132\235\163\140!")
  Panel_Tutorial_Renew:RegisterShowEventFunc(true, "PaGlobalFunc_Tutorial_ShowAni()")
  Panel_Tutorial_Renew:RegisterShowEventFunc(false, "PaGlobalFunc_Tutorial_HideAni()")
  PaGlobal_TutorialManager:handleTutorialUiManagerInitialize()
end
function PaGlobalFunc_Tutorial_ShowAni()
  PaGlobal_TutorialUiManager:showAni()
end
function PaGlobalFunc_Tutorial_HideAni()
  PaGlobal_TutorialUiManager:hideAni()
end
function PaGlobal_TutorialUiManager:showAni()
  Panel_Tutorial_Renew:ResetVertexAni()
  Panel_Tutorial_Renew:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo = Panel_Tutorial_Renew:addColorAnimation(0, 0.75, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(Defines.Color.C_00FFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
end
function PaGlobal_TutorialUiManager:hideAni()
  Panel_Tutorial_Renew:ResetVertexAni()
  Panel_Tutorial_Renew:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo = Panel_Tutorial_Renew:addColorAnimation(0, 1.25, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(Defines.Color.C_FFFFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_00FFFFFF)
  aniInfo.IsChangeChild = true
  aniInfo:SetHideAtEnd(true)
  aniInfo:SetDisableWhileAni(true)
end
function PaGlobal_TutorialUiManager:loadAllUiSavedInfo()
  self:setShowAllDefaultUi(true)
end
function FromClient_TutorialScreenReposition()
  PaGlobal_TutorialUiManager:repositionScreen()
end
function PaGlobal_TutorialUiManager:repositionScreen()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_Tutorial_Renew:SetSize(scrX, scrY)
  Panel_Tutorial_Renew:SetPosX(0)
  Panel_Tutorial_Renew:SetPosY(0)
  for key, value in pairs(self._uiList) do
    for _, vv in pairs(value._ui) do
      vv:ComputePos()
    end
  end
end
function PaGlobal_TutorialUiManager:closeAllWindow()
  if check_ShowWindow() then
    close_WindowPanelList()
  else
    PaGlobalFunc_MainDialog_Hide()
  end
end
function PaGlobal_TutorialUiManager:restoreAllUiByUserSetting()
  local isTutorialSkip = 1 == ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eTutorialSkip)
  if CheckTutorialEnd() or isTutorialSkip then
    self:loadAllUiSavedInfo()
    if true == Panel_WorldMap:GetShow() and Panel_CheckedQuest:GetShow() then
      FGlobal_QuestWidget_Close()
    end
  end
  if isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_KOR) or isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_JAP) then
    FGlobal_PersonalIcon_ButtonPosUpdate()
  end
  self:setShowAllDefaultUi(true)
end
function PaGlobal_TutorialUiManager:setShowAllDefaultUi(isShow)
  if false == isShow then
  else
    PaGlobalFunc_ConsoleKeyGuide_On()
    PaGlobalFunc_ChattingViewer_On()
    PaGlobal_ConsoleQuickMenu:widgetOpen(true)
    PaGlobal_ConsoleQuickMenu:setWidget()
  end
end
function PaGlobal_TutorialUiManager:hideAllTutorialUi()
  for _, v in pairs(self._uiList) do
    for __, vv in pairs(v._ui) do
      vv:SetShow(false)
    end
  end
end
function FromClient_luaLoadComplete_TutorialUiManager()
  PaGlobal_TutorialUiManager:initialize()
end
function FromClient_EventSelfPlayerLevelUp_TutorialUiManager()
  if CheckTutorialEnd() then
    PaGlobal_TutorialUiManager:restoreAllUiByUserSetting()
  end
end
function PaGlobal_TutorialUiManager:getUiBlackSpirit()
  return self._uiList._uiBlackSpirit
end
function PaGlobal_TutorialUiManager:getUiHeadlineMessage()
  return self._uiList._uiHeadlineMessage
end
function PaGlobal_TutorialUiManager:getUiMasking()
  return self._uiList._uiMasking
end
