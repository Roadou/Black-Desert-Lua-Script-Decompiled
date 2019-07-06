local isBossRange = false
local btn_bossCamera
local _bossKey = {
  kuAng = 23001,
  kaAng = 23060,
  NuAng = 23032,
  DumChit = 23073,
  Muraka = 23158,
  Quint = 23157,
  Opin = 23810,
  Gamos = 23120,
  Gamos_quest = 23552
}
local _bossCharacterWrapper
local function clear_BossCamButton()
  isBossRange = false
  btn_bossCamera:SetShow(false)
  btn_bossCamera:SetCheck(false)
  sttic_sequenceAni:SetShow(false)
  ToClient_onBossCamera(false)
end
function click_button()
  if false == isBossRange then
    clear_BossCamButton()
    return
  end
  if true == btn_bossCamera:IsCheck() then
  else
    chk = ToClient_onBossCamera(false)
  end
  sttic_sequenceAni:SetShow(btn_bossCamera:IsCheck())
  if nil == _bossCharacterWrapper then
    return
  end
  local characterKey = _bossCharacterWrapper:getCharacterKeyRaw()
  local activeViewDistance, viewDistance, minDistance, maxDistance, viewBoundaryDistacne, viewInterPlationTime, mouse_wheel_sensitivity
  if _bossKey.kuAng == characterKey or _bossKey.NuAng == characterKey or _bossKey.DumChit == characterKey or _bossKey.Opin == characterKey or _bossKey.Quint == characterKey or _bossKey.Muraka == characterKey then
    activeViewDistance = 700
    viewDistance = 450
    minDistance = 100
    maxDistance = 1000
    viewBoundaryDistacne = 100
    viewInterPlationTime = 3
    mouse_wheel_sensitivity = 0.08
  elseif _bossKey.kaAng == characterKey then
    activeViewDistance = 450
    viewDistance = 300
    minDistance = 100
    maxDistance = 700
    viewBoundaryDistacne = 100
    viewInterPlationTime = 3
    mouse_wheel_sensitivity = 0.08
  elseif _bossKey.Gamos == characterKey or _bossKey.Gamos_quest == characterKey then
    activeViewDistance = 1500
    viewDistance = 1000
    minDistance = 100
    maxDistance = 1500
    viewBoundaryDistacne = 500
    viewInterPlationTime = 5
    mouse_wheel_sensitivity = 0.08
  end
  local chk = ToClient_onBossCamera(btn_bossCamera:IsCheck(), activeViewDistance, viewDistance, minDistance, maxDistance, viewBoundaryDistacne, viewInterPlationTime, mouse_wheel_sensitivity)
  if false == chk then
    _PA_LOG("\234\180\145\236\154\180", "Camera \236\180\136\234\184\176\237\153\148\234\176\128 \235\144\152\236\167\128 \236\149\138\236\149\152\235\139\164...?")
    btn_bossCamera:SetCheck(false)
  end
end
function bossCamera_ShowTooltip()
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSCAMERA_TOOLTIPNAME")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSCAMERA_TOOLTIPDESC")
  TooltipSimple_Show(btn_bossCamera, name, desc)
end
function bossCamera_HideTooltip()
  TooltipSimple_Hide()
end
function FromClient_EventCameraCharacter_RangeIn(characterWrapper)
  if nil == characterWrapper then
    _PA_LOG("\234\180\145\236\154\180", "[\235\179\180\236\138\164\236\185\180\235\169\148\235\157\188] \235\179\180\236\138\164 characterWrapper\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\152\235\138\148\235\141\176\236\154\169..")
    return
  end
  _bossCharacterWrapper = characterWrapper
  btn_bossCamera:SetShow(true)
  isBossRange = true
end
function FromClient_EventCameraCharacter_RangeChange()
  btn_bossCamera:SetShow(true)
  PaGlobal_BossCamera_Repos()
  isBossRange = true
end
function FromClient_EventCameraCharacter_RangeOut()
  isBossRange = false
  clear_BossCamButton()
end
function FromClient_EventCameraCharacter_Dead()
  isBossRange = false
  clear_BossCamButton()
end
function PaGlobal_BossCamera_Repos()
  local radarSizeX = FGlobal_Panel_Radar_GetSizeX()
  if nil ~= btn_bossCamera then
    btn_bossCamera:SetPosX(getScreenSizeX() - radarSizeX - btn_bossCamera:GetSizeX() - 20)
    btn_bossCamera:SetPosY(Panel_Radar:GetSizeY() - btn_bossCamera:GetSizeY() + 10)
    sttic_sequenceAni:SetPosX(btn_bossCamera:GetPosX() - 5)
    sttic_sequenceAni:SetPosY(btn_bossCamera:GetPosY() - 5)
    if nil ~= PaGlobal_BetterEquipment_GetNextPosY and nil ~= Panel_Widget_BetterEquipment and true == Panel_Widget_BetterEquipment:GetShow() then
      local nextPosY = PaGlobal_BetterEquipment_GetNextPosY()
      if nextPosY > btn_bossCamera:GetPosY() then
        btn_bossCamera:SetPosY(nextPosY + 10)
        sttic_sequenceAni:SetPosY(btn_bossCamera:GetPosY() - 5)
      end
    end
  end
end
local function initialize()
  btn_bossCamera = UI.getChildControl(Panel_CommonGameScreenUI, "Button_BossCamera")
  btn_bossCamera:SetShow(false)
  btn_bossCamera:addInputEvent("Mouse_LUp", "click_button()")
  btn_bossCamera:addInputEvent("Mouse_On", "bossCamera_ShowTooltip()")
  btn_bossCamera:addInputEvent("Mouse_Out", "bossCamera_HideTooltip()")
  sttic_sequenceAni = UI.getChildControl(Panel_CommonGameScreenUI, "Static_SequenceAni")
  sttic_sequenceAni:SetShow(false)
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  PaGlobal_BossCamera_Repos()
  clear_BossCamButton()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_CommonGameScreenUI")
function FromClient_luaLoadComplete_CommonGameScreenUI()
  initialize()
  Panel_CommonGameScreenUI:SetShow(true)
  btn_bossCamera:SetShow(false)
  if false == ToClient_isConsole() then
    registerEvent("FromClient_EventCameraCharacter_RangeIn", "FromClient_EventCameraCharacter_RangeIn")
    registerEvent("FromClient_EventCameraCharacter_RangeChange", "FromClient_EventCameraCharacter_RangeChange")
    registerEvent("FromClient_EventCameraCharacter_RangeOut", "FromClient_EventCameraCharacter_RangeOut")
    registerEvent("FromClient_EventCameraCharacter_Dead", "FromClient_EventCameraCharacter_Dead")
  end
end
