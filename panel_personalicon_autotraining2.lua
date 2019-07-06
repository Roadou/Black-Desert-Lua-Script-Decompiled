local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
Panel_AutoTraining:SetShow(false)
local isAutoTrainingEnable = ToClient_IsContentsGroupOpen("57")
Panel_AutoTraining:RegisterShowEventFunc(true, "AutoPlayShowAni()")
Panel_AutoTraining:RegisterShowEventFunc(false, "AutoPlayHideAni()")
PaGlobal_AutoPlay = {
  _img_AutoPlay = UI.getChildControl(Panel_AutoTraining, "Static_AutoPlay"),
  _txt_AutoPlayEnd = UI.getChildControl(Panel_AutoTraining, "StaticText_AutoPlay")
}
local autoTrain = ToClient_IsAutoLevelUp()
function AutoPlayShowAni()
  local ImageMoveAni = Panel_AutoTraining:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni:SetStartPosition(getScreenSizeX() / 2 - Panel_AutoTraining:GetSizeX() / 2, 0 - Panel_AutoTraining:GetSizeY())
  ImageMoveAni:SetEndPosition(getScreenSizeX() / 2 - Panel_AutoTraining:GetSizeX() / 2, getScreenSizeY() - getScreenSizeY() / 1.5 - Panel_AutoTraining:GetSizeY())
  ImageMoveAni.IsChangeChild = true
  Panel_AutoTraining:CalcUIAniPos(ImageMoveAni)
  ImageMoveAni:SetDisableWhileAni(true)
  PAGlobal_AutoTraining_Alarm_OnAutoTrainingStart()
end
function AutoPlayHideAni()
  local ImageMoveAni = Panel_AutoTraining:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni:SetStartPosition(getScreenSizeX() / 2 - Panel_AutoTraining:GetSizeX() / 2, getScreenSizeY() - getScreenSizeY() / 1.5 - Panel_AutoTraining:GetSizeY())
  ImageMoveAni:SetEndPosition(getScreenSizeX() / 2 - Panel_AutoTraining:GetSizeX() / 2, 0 - Panel_AutoTraining:GetSizeY())
  ImageMoveAni.IsChangeChild = true
  Panel_AutoTraining:CalcUIAniPos(ImageMoveAni)
  ImageMoveAni:SetDisableWhileAni(true)
  ImageMoveAni:SetHideAtEnd(true)
  ImageMoveAni:SetDisableWhileAni(true)
  PAGlobal_AutoTraining_Alarm_OnAutoTrainingEnd()
end
function PaGlobal_AutoPlay:Init()
  if not ToClient_IsContentsGroupOpen("57") then
    return
  end
  if autoTrain then
    PaGlobal_AutoPlay:Open()
  end
  self._txt_AutoPlayEnd:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._txt_AutoPlayEnd:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_AUTOPLAY_PLAYEND"))
end
function PaGlobal_AutoPlay:Open()
  Panel_AutoTraining:SetShow(true, true)
  self._img_AutoPlay:SetVertexAniRun("Ani_Rotate_New", true)
end
function PaGlobal_AutoPlay:Close()
  Panel_AutoTraining:SetShow(false, true)
end
function FromClient_CantIncreaseExpWithAutoLevelUp()
end
function FromClient_SetAutoLevelUp(isAuto)
  if nil == isAuto then
    return
  end
  autoTrain = isAuto
  if isAuto then
    PaGlobal_AutoPlay:Open()
  else
    PaGlobal_AutoPlay:Close()
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_AutoTraining2_luaLoadComplete")
function FromClient_AutoTraining2_luaLoadComplete()
  PaGlobal_AutoPlay:Init()
  registerEvent("FromClient_CantIncreaseExpWithAutoLevelUp", "FromClient_CantIncreaseExpWithAutoLevelUp")
  registerEvent("FromClient_SetAutoLevelUp", "FromClient_SetAutoLevelUp")
end
