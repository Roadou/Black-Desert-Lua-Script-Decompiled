local _panel = Panel_FullScreenFade
_panel:SetSize(getScreenSizeX(), getScreenSizeY())
_panel:SetPosX(0)
_panel:SetPosY(0)
_panel:SetShow(false)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local _fadeTime = 0.3
local _fadeOutDelay = 0.2
local _isFading = false
local function FullScreenFade_FadeIn()
  if ToClient_isConsole() then
    return
  end
  if not ToClient_IsDevelopment() or ToClient_IsDevelopment() then
    return
  end
  _isFading = true
  _panel:SetIgnore(false)
  _panel:SetPosX(0)
  _panel:SetPosY(0)
  _panel:SetColor(UI_color.C_00000000)
  _panel:SetShow(true)
  local aniInfo = _panel:addColorAnimation(0, _fadeTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo:SetStartColor(UI_color.C_00000000)
  aniInfo:SetEndColor(UI_color.C_FF000000)
end
local function FullScreenFade_FadeInCustomize()
  if ToClient_isConsole() then
    return
  end
  if not ToClient_IsDevelopment() or ToClient_IsDevelopment() then
    return
  end
  _isFading = true
  _panel:SetIgnore(false)
  _panel:SetPosX(0)
  _panel:SetPosY(0)
  _panel:SetColor(UI_color.C_00000000)
  _panel:SetShow(true)
  local aniInfo = _panel:addColorAnimation(0.5, 0.5 + _fadeTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo:SetStartColor(UI_color.C_00000000)
  aniInfo:SetEndColor(UI_color.C_FF000000)
end
function PaGlobalFunc_FullScreenFade_RunAfterFadeIn(func, isCustomize)
  if nil == func or "function" ~= type(func) then
    return
  end
  if ToClient_isConsole() then
    func()
    return
  end
  if nil ~= PaGlobalFunc_CancelByAttackIsCalled and true == PaGlobalFunc_CancelByAttackIsCalled() then
    func()
    return
  end
  if not ToClient_IsDevelopment() or ToClient_IsDevelopment() then
    func()
    return
  end
  luaTimer_AddEvent(func, _fadeTime * 1000, false, 0)
  if nil == isCustomize or false == isCustomize then
    FullScreenFade_FadeIn()
  else
    FullScreenFade_FadeInCustomize()
  end
end
function PaGlobalFunc_FullScreenFade_FadeOut(fadeTime, fadeDelay)
  _isFading = false
  _panel:SetIgnore(true)
  if ToClient_isConsole() then
    _panel:SetShow(false)
    return
  end
  if nil ~= PaGlobalFunc_CancelByAttackIsCalled and true == PaGlobalFunc_CancelByAttackIsCalled() then
    _panel:SetShow(false)
    return
  end
  if not ToClient_IsDevelopment() or ToClient_IsDevelopment() then
    _panel:SetShow(false)
    return
  end
  if false == _panel:GetShow() then
    return
  end
  local time, delay = 0, 0
  if nil ~= fadeTime then
    time = fadeTime
  else
    time = _fadeTime
  end
  if nil ~= fadeDelay then
    delay = fadeDelay
  else
    delay = _fadeOutDelay
  end
  _panel:ResetVertexAni()
  local aniInfo = _panel:addColorAnimation(delay, time + delay, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo:SetStartColor(UI_color.C_FF000000)
  aniInfo:SetEndColor(UI_color.C_00000000)
  aniInfo:SetHideAtEnd(true)
end
function PaGlobalFunc_FullScreenFade_CustomizeOnly(func)
  if nil == func or "function" ~= type(func) then
    return
  end
  if ToClient_isConsole() then
    func()
    return
  end
  if nil ~= PaGlobalFunc_CancelByAttackIsCalled and true == PaGlobalFunc_CancelByAttackIsCalled() then
    return
  end
  luaTimer_AddEvent(func, 200, false, 0)
  _panel:SetIgnore(false)
  _panel:SetPosX(0)
  _panel:SetPosY(0)
  _panel:SetColor(UI_color.C_00000000)
  _panel:SetShow(true)
  local aniInfo1 = _panel:addColorAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo1:SetStartColor(UI_color.C_00000000)
  aniInfo1:SetEndColor(UI_color.C_FF000000)
  local aniInfo2 = _panel:addColorAnimation(0.3, 1.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo2:SetStartColor(UI_color.C_FF000000)
  aniInfo2:SetEndColor(UI_color.C_00000000)
  aniInfo2:SetHideAtEnd(true)
end
function PaGlobalFunc_FullScreenFade_IsFading()
  return _isFading
end
function PaGlobalFunc_FullScreenFade_RemoveFade()
  _isFading = false
  _panel:SetShow(false)
end
function PaGlobalFunc_FullScreenFade_Resize()
  _panel:SetSize(getScreenSizeX(), getScreenSizeY())
  _panel:SetPosX(0)
  _panel:SetPosY(0)
  PaGlobalFunc_FullScreenFade_FadeOut()
end
PaGlobalFunc_FullScreenFade_FadeOut()
registerEvent("onScreenResize", "PaGlobalFunc_FullScreenFade_Resize")
