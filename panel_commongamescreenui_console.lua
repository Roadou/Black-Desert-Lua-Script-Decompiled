local isBossRange = false
local _bossCharacterWrapper
local prevOption = {_UsePlayerEffectDistOptimization = false, _PlayerEffectDistOptimization = 0}
function backUpOptimizeOption()
  prevOption._UsePlayerEffectDistOptimization = ToClient_getGameOptionControllerWrapper():getUsePlayerOptimizationEffectFrame()
  prevOption._PlayerEffectDistOptimization = ToClient_getGameOptionControllerWrapper():getPlayerEffectFrameEffectOptimization()
end
function applyOptimizeOption()
  setUsePlayerOptimizationEffectFrame(true)
  setPlayerEffectFrameEffectOptimization(1000)
end
function resetOptimizeOption()
  setUsePlayerOptimizationEffectFrame(prevOption._UsePlayerEffectDistOptimization)
  setPlayerEffectFrameEffectOptimization(prevOption._PlayerEffectDistOptimization)
end
function FromClient_EventCameraCharacter_RangeIn(characterWrapper)
  if nil == characterWrapper then
    _PA_LOG("\234\180\145\236\154\180", "[\235\179\180\236\138\164\236\185\180\235\169\148\235\157\188] \235\179\180\236\138\164 characterWrapper\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\152\235\138\148\235\141\176\236\154\169..")
    return
  end
  _bossCharacterWrapper = characterWrapper
  isBossRange = true
  backUpOptimizeOption()
  applyOptimizeOption()
end
function FromClient_EventCameraCharacter_RangeChange()
  isBossRange = true
end
function FromClient_EventCameraCharacter_RangeOut()
  isBossRange = false
  resetOptimizeOption()
end
function FromClient_EventCameraCharacter_Dead()
  isBossRange = false
  resetOptimizeOption()
end
local initialize = function()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_CommonGameScreenUI_Console")
function FromClient_luaLoadComplete_CommonGameScreenUI_Console()
  initialize()
  Panel_CommonGameScreenUI_Console:SetShow(true)
  registerEvent("FromClient_EventCameraCharacter_RangeIn", "FromClient_EventCameraCharacter_RangeIn")
  registerEvent("FromClient_EventCameraCharacter_RangeChange", "FromClient_EventCameraCharacter_RangeChange")
  registerEvent("FromClient_EventCameraCharacter_RangeOut", "FromClient_EventCameraCharacter_RangeOut")
  registerEvent("FromClient_EventCameraCharacter_Dead", "FromClient_EventCameraCharacter_Dead")
end
