PaGlobal_FadeOut = {
  _ui = {_loadingText = nil},
  _ANIMATION_TIME = 0.5,
  _initialize = false,
  _fadeDuration = 0,
  _fadeDruationMaxTime = 15
}
runLua("UI_Data/Script/Widget/FadeScreen/Common_FadeOut_1.lua")
runLua("UI_Data/Script/Widget/FadeScreen/Common_FadeOut_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_FadeOutInit")
function FromClient_FadeOutInit()
  PaGlobal_FadeOut:initialize()
end
