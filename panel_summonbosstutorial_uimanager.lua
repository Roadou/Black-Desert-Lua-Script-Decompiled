registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_SummonBossTutorial_UiManager")
registerEvent("onScreenResize", "FromClient_SummonBossTutorial_ScreenReposition")
PaGlobal_SummonBossTutorial_UiManager = {
  _uiList = {
    _uiBlackSpirit = nil,
    _uiKeyButton = nil,
    _uiHeadlineMessage = nil,
    _uiMasking = nil
  }
}
PaGlobal_SummonBossTutorial_UiMasking = {
  _ui = {
    _maskBg_Quest = UI.getChildControl(Panel_Masking_Tutorial, "Static_MaskBg_Quest"),
    _maskBg_SelfExpGuage = UI.getChildControl(Panel_Masking_Tutorial, "Static_MaskBg_SelfExpGauge"),
    _maskBg_Spirit = UI.getChildControl(Panel_Masking_Tutorial, "Static_MaskBg_Spirit")
  }
}
function PaGlobal_SummonBossTutorial_UiManager:getUiBlackSpirit()
  return self._uiList._uiBlackSpirit
end
function PaGlobal_SummonBossTutorial_UiManager:getUiKeyButton()
  return self._uiList._uiKeyButton
end
function PaGlobal_SummonBossTutorial_UiManager:getUiHeadlineMessage()
  return self._uiList._uiHeadlineMessage
end
function PaGlobal_SummonBossTutorial_UiManager:getUiMasking()
  return self._uiList._uiMasking
end
function FromClient_luaLoadComplete_SummonBossTutorial_UiManager()
  PaGlobal_SummonBossTutorial_UiManager:initialize()
end
function PaGlobal_SummonBossTutorial_UiManager:initialize()
  self._uiList._uiBlackSpirit = PaGlobal_SummonBossTutorial_UiBlackSpirit
  self._uiList._uiKeyButton = PaGlobal_SummonBossTutorial_UiKeyButton
  self._uiList._uiHeadlineMessage = PaGlobal_SummonBossTutorial_UiHeadlineMessage
  self._uiList._uiMasking = PaGlobal_SummonBossTutorial_UiMasking
  Panel_SummonBossTutorial:RegisterShowEventFunc(true, "FGlobal_SummonBossTutorial_UiManager_ShowAni()")
  Panel_SummonBossTutorial:RegisterShowEventFunc(false, "FGlobal_SummonBossTutorial_UiManager_HideAni()")
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_SummonBossTutorial_UiManager:initialize() UI \235\167\164\235\139\136\236\160\128 \236\180\136\234\184\176\237\153\148 \236\153\132\235\163\140!")
end
function FGlobal_SummonBossTutorial_UiManager_ShowAni()
  PaGlobal_SummonBossTutorial_UiManager:showAni()
end
function FGlobal_SummonBossTutorial_UiManager_HideAni()
  PaGlobal_SummonBossTutorial_UiManager:hideAni()
end
function PaGlobal_SummonBossTutorial_UiManager:showAni()
  PaGlobal_ArousalTutorial_UiManager:getUiBlackSpirit():changeBubbleTextureForAni(false)
  Panel_SummonBossTutorial:ResetVertexAni()
  Panel_SummonBossTutorial:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo = Panel_SummonBossTutorial:addColorAnimation(0, 0.75, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(Defines.Color.C_00FFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
end
function PaGlobal_SummonBossTutorial_UiManager:hideAni()
  PaGlobal_ArousalTutorial_UiManager:getUiBlackSpirit():changeBubbleTextureForAni(false)
  Panel_SummonBossTutorial:ResetVertexAni()
  Panel_SummonBossTutorial:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo = Panel_SummonBossTutorial:addColorAnimation(0, 1.25, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(Defines.Color.C_FFFFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_00FFFFFF)
  aniInfo.IsChangeChild = true
  aniInfo:SetHideAtEnd(true)
  aniInfo:SetDisableWhileAni(true)
end
function PaGlobal_SummonBossTutorial_UiManager:hideAllTutorialUi()
  for _, v in pairs(self._uiList) do
    for __, vv in pairs(v._ui) do
      vv:SetShow(false)
    end
  end
end
function FromClient_SummonBossTutorial_ScreenReposition()
  PaGlobal_SummonBossTutorial_UiManager:repositionScreen()
end
function PaGlobal_SummonBossTutorial_UiManager:repositionScreen()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_SummonBossTutorial:SetSize(scrX, scrY)
  Panel_SummonBossTutorial:SetPosX(0)
  Panel_SummonBossTutorial:SetPosY(0)
  for key, value in pairs(self._uiList) do
    for _, vv in pairs(value._ui) do
      vv:ComputePos()
    end
  end
end
