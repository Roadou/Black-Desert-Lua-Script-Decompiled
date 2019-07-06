local MGKT = CppEnums.MiniGameKeyType
local SniperReload = {
  _ui = {stc_BG = nil},
  _theta = 0,
  _markPosX = 50
}
local _leftEndX = 50
local _rightEndX = 380
local _span = (_rightEndX - _leftEndX) * 0.5
local _speed = 5
local _leftSuccessX = 187
local _rightSuccessX = 239
local self = SniperReload
function PaGlobalFunc_SniperReload_Initialize()
  if nil == MiniGame_SniperReload then
    return
  end
  self._ui.stc_BG = UI.getChildControl(MiniGame_SniperReload, "Static_BG")
  self._ui.stc_reloadMark = UI.getChildControl(self._ui.stc_BG, "Static_ReloadMark")
  self._ui.stc_spaceBar = UI.getChildControl(self._ui.stc_BG, "Static_SpaceBar")
  registerCloseLuaEvent(MiniGame_SniperReload, PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Attacked
  }), "PaGlobalFunc_SniperGame_EndSniperGame()")
end
function PaGlobalFunc_SniperReload_Open()
  if nil == MiniGame_SniperReload then
    return
  end
  MiniGame_SniperReload:SetSize(getScreenSizeX(), getScreenSizeY())
  MiniGame_SniperReload:SetPosXY(0, 0)
  MiniGame_SniperReload:SetShow(true)
  self._ui.stc_BG:ComputePos()
  _PA_LOG("\236\160\149\236\167\128\237\152\156", "\236\151\172\234\184\176\234\185\140\236\167\128 \235\147\177\235\161\157\236\157\180..")
  MiniGame_SniperReload:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
end
function PaGlobalFunc_SniperReload_Close()
  if nil == MiniGame_SniperReload then
    return
  end
  MiniGame_SniperReload:SetShow(false)
  self._theta = 0
  self._ui.stc_reloadMark:SetPosX(50)
  self._ui.stc_reloadMark:ResetVertexAni()
  self._ui.stc_reloadMark:SetColor(Defines.Color.C_FFFFFFFF)
end
local _piDouble = math.pi * 2
local _inputLocked = false
function PaGlobalFunc_SniperReload_UpdatePerFrame(deltaTime)
  if nil == MiniGame_SniperReload then
    return
  end
  self._theta = self._theta + deltaTime * _speed
  if self._theta > _piDouble then
    self._theta = 0
    _inputLocked = false
    self._ui.stc_reloadMark:ResetVertexAni()
    self._ui.stc_reloadMark:SetColor(Defines.Color.C_FFFFFFFF)
  end
  self._markPosX = math.cos(self._theta) * -_span + _span + _leftEndX
  self._ui.stc_reloadMark:SetPosX(self._markPosX)
end
function PaGlobalFunc_SniperReload_KeyFunc(keyType)
  if nil == MiniGame_SniperReload then
    return
  end
  if MGKT.MiniGameKeyType_Space == keyType then
    if _leftSuccessX < self._markPosX and _rightSuccessX > self._markPosX and false == _inputLocked then
      getSelfPlayer():get():SetMiniGameResult(0)
      self._ui.stc_reloadMark:ResetVertexAni()
      self._ui.stc_reloadMark:SetColor(Defines.Color.C_FFFFFFFF)
      PaGlobalFunc_SniperReload_Close()
      luaTimer_AddEvent(PaGlobal_SniperGame_FadeIn, 500, false, 0)
    else
      audioPostEvent_SystemUi(11, 40)
      _inputLocked = true
      self._ui.stc_reloadMark:ResetVertexAni()
      local aniData = self._ui.stc_reloadMark:addColorAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
      aniData:SetStartColor(Defines.Color.C_FFFF0000)
      aniData:SetEndColor(Defines.Color.C_FFFFAB6D)
    end
  end
end
