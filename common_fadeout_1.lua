function PaGlobal_FadeOut:initialize()
  if true == PaGlobal_FadeOut._initialize then
    return
  end
  PaGlobal_FadeOut._ui._loadingText = UI.getChildControl(Common_FadeOut, "StaticText_LoadingEffect")
  PaGlobal_FadeOut._ui._loadingText:EraseAllEffect()
  PaGlobal_FadeOut._ui._loadingText:AddEffect("UI_Loading_01A", true, 0, 0)
  PaGlobal_FadeOut:registEventHandler()
  PaGlobal_FadeOut:validate()
  PaGlobal_FadeOut._initialize = true
end
function PaGlobal_FadeOut:registEventHandler()
  Common_FadeOut:RegisterShowEventFunc(true, "PaGlobal_FadeOutShowAni()")
  registerEvent("onScreenResize", "PaGlobal_FadeOutResize")
  registerEvent("FromClient_BattleRoyaleLoading", "PaGlobal_FadeOutOpen")
  registerEvent("FromClient_CloseBattleRoyaleEnterLoading", "PaGlobal_FadeOutClose")
end
function PaGlobal_Common_FadeOutUpdate(deltaTime)
  if PaGlobal_FadeOut._fadeDuration < PaGlobal_FadeOut._fadeDruationMaxTime then
    PaGlobal_FadeOut._fadeDuration = PaGlobal_FadeOut._fadeDuration + deltaTime
    return
  end
  PaGlobal_FadeOutEscapeClose()
end
function PaGlobal_FadeOut:showAni()
  if nil == Common_FadeOut then
    return
  end
  local showAni = Common_FadeOut:addColorAnimation(0, PaGlobal_FadeOut._ANIMATION_TIME, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  showAni:SetStartColor(Defines.Color.C_00000000)
  showAni:SetEndColor(Defines.Color.C_FF000000)
  showAni:SetStartIntensity(3)
  showAni:SetEndIntensity(1)
  showAni.IsChangeChild = true
end
function PaGlobal_FadeOut:hideAni()
  if nil == Common_FadeOut then
    return
  end
  local closeAni = Common_FadeOut:addColorAnimation(0, PaGlobal_FadeOut._ANIMATION_TIME, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(Defines.Color.C_00000000)
  closeAni:SetEndColor(Defines.Color.C_FF000000)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
end
function PaGlobal_FadeOut:resize()
  if nil == Common_FadeOut then
    return
  end
  if false == PaGlobal_FadeOut._initialize then
    return
  end
  Common_FadeOut:SetSize(getScreenSizeX(), getScreenSizeY())
  PaGlobal_FadeOut._ui._loadingText:ComputePos()
  PaGlobal_FadeOut._ui._loadingText:SetPosX(getScreenSizeX() / 2 - (PaGlobal_FadeOut._ui._loadingText:GetTextSpan().x + PaGlobal_FadeOut._ui._loadingText:GetTextSizeX()) / 2)
end
function PaGlobal_FadeOut:open()
  if nil == Common_FadeOut then
    return
  end
  PaGlobal_FadeOut:resize()
  Common_FadeOut:SetShow(true, true)
  Common_FadeOut:RegisterUpdateFunc("PaGlobal_Common_FadeOutUpdate")
end
function PaGlobal_FadeOut:close()
  if nil == Common_FadeOut then
    return
  end
  if true == Common_FadeOut:GetShow() then
    Common_FadeOut:SetShow(false, true)
    PaGlobal_FadeOut._fadeDuration = 0
    Common_FadeOut:ClearUpdateLuaFunc()
  end
end
function PaGlobal_FadeOut:validate()
  PaGlobal_FadeOut._ui._loadingText:isValidate()
end
