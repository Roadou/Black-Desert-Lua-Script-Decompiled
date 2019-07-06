Panel_ConsoleLobbyKeyGuide:SetShow(ToClient_isConsole())
local _panel = Panel_ConsoleLobbyKeyGuide
local _actionType = CppEnums.ActionInputType
local ConsoleLobbyKeyGuide = {
  _ui = {
    _keyGuide = {}
  },
  _guideState = {screenshotGuide = 0, undefined = 999},
  _actionStringTable = {},
  _isChange = false,
  _beforeState = -1,
  _glowFontColor = 4278190080,
  _maxConsoleGuideType = 0,
  _gapY = 40,
  _gapX = 45,
  _gapIconX = 15,
  _screenShotGuideState = false
}
local _consoleUIIconName = {
  buttonA = 0,
  buttonX = 1,
  buttonY = 2,
  buttonB = 3,
  buttonRSC = 4,
  buttonLSC = 5,
  buttonRSM = 6,
  buttonLSM = 7,
  buttonLB = 8,
  buttonRB = 9,
  buttonLT = 10,
  buttonRT = 11,
  buttonStart = 12,
  IconPlus = 13,
  IconOr = 14,
  buttonDpad = 15,
  buttonDpadUp = 16,
  buttonDpadDown = 17,
  buttonDpadLeft = 18,
  buttonDpadRight = 19
}
local _consoleUIIconUV = {
  [0] = {
    x1 = 1,
    y1 = 1,
    x2 = 45,
    y2 = 45
  },
  {
    x1 = 136,
    y1 = 1,
    x2 = 180,
    y2 = 45
  },
  {
    x1 = 46,
    y1 = 1,
    x2 = 90,
    y2 = 45
  },
  {
    x1 = 91,
    y1 = 1,
    x2 = 135,
    y2 = 45
  },
  {
    x1 = 46,
    y1 = 91,
    x2 = 90,
    y2 = 135
  },
  {
    x1 = 1,
    y1 = 91,
    x2 = 45,
    y2 = 135
  },
  {
    x1 = 91,
    y1 = 46,
    x2 = 135,
    y2 = 90
  },
  {
    x1 = 136,
    y1 = 46,
    x2 = 180,
    y2 = 90
  },
  {
    x1 = 91,
    y1 = 136,
    x2 = 135,
    y2 = 180
  },
  {
    x1 = 136,
    y1 = 136,
    x2 = 180,
    y2 = 180
  },
  {
    x1 = 46,
    y1 = 181,
    x2 = 90,
    y2 = 225
  },
  {
    x1 = 1,
    y1 = 181,
    x2 = 45,
    y2 = 225
  },
  {
    x1 = 46,
    y1 = 46,
    x2 = 90,
    y2 = 90
  },
  {
    x1 = 91,
    y1 = 181,
    x2 = 103,
    y2 = 225
  },
  {
    x1 = 104,
    y1 = 181,
    x2 = 116,
    y2 = 225
  },
  {
    x1 = 181,
    y1 = 181,
    x2 = 225,
    y2 = 225
  },
  {
    x1 = 181,
    y1 = 136,
    x2 = 225,
    y2 = 180
  },
  {
    x1 = 181,
    y1 = 46,
    x2 = 225,
    y2 = 90
  },
  {
    x1 = 181,
    y1 = 91,
    x2 = 225,
    y2 = 135
  },
  {
    x1 = 181,
    y1 = 1,
    x2 = 225,
    y2 = 45
  }
}
function ConsoleLobbyKeyGuide:init()
  self._ui.guideBg = UI.getChildControl(_panel, "Static_KeyGuideBg")
  self._ui.consoleUITemplate = UI.getChildControl(self._ui.guideBg, "Static_ConsoleKey")
  self._ui.keyStringTemplate = UI.getChildControl(self._ui.guideBg, "StaticText_KeyDesc")
  self:updateGuide()
  self:hideAllGuide()
  self:registEvent()
end
function ConsoleLobbyKeyGuide:updateGuide()
  self._ui._keyGuide[self._guideState.screenshotGuide] = self:makeNewGuide(self._guideState.screenshotGuide)
  self._ui._keyGuide[self._guideState.undefined] = self:makeNewGuide(self._guideState.undefined)
end
function ConsoleLobbyKeyGuide:makeNewGuide(state_)
  local newGuide = {}
  newGuide.guideBg = UI.createAndCopyBasePropertyControl(_panel, "Static_KeyGuideBg", _panel, "GuideBg_" .. state_)
  newGuide.consoleUI = {}
  newGuide.keyString = {}
  newGuide.guideIdx = 0
  newGuide.state = state_
  if state_ == self._guideState.screenshotGuide then
    self:addGuide(newGuide, {
      _consoleUIIconName.buttonB
    }, PAGetString(Defines.StringSheet_RESOURCE, "PANEL_COMMON_CLOSE"))
    self:addGuide(newGuide, {
      _consoleUIIconName.buttonY
    }, PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CUSTOMSCREENSHOT_SCREENSHOT_RENEW"))
    self:addGuide(newGuide, {
      _consoleUIIconName.buttonRB
    }, PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CUSTOMSCREENSHOT_SCREENSHOT_RENEW_INCREASE"))
    self:addGuide(newGuide, {
      _consoleUIIconName.buttonRT
    }, PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CUSTOMSCREENSHOT_SCREENSHOT_RENEW_DECREASE"))
    self:addGuide(newGuide, {
      _consoleUIIconName.buttonLSM
    }, PAGetString(Defines.StringSheet_RESOURCE, "PANEL_DIALOG_NPCSHOP_KEY_MOVE"))
    self:addGuide(newGuide, {
      _consoleUIIconName.buttonRSM
    }, PAGetString(Defines.StringSheet_RESOURCE, "PANEL_COMMON_KEYGUIDE_CAMERA"))
    self:addGuide(newGuide, {
      _consoleUIIconName.buttonRSM,
      _consoleUIIconName.IconPlus,
      _consoleUIIconName.buttonLT
    }, PAGetString(Defines.StringSheet_RESOURCE, "PANEL_COMMON_KEYGUIDE_ZOOM"))
  else
  end
  self._maxConsoleGuideType = self._maxConsoleGuideType + 1
  return newGuide
end
function ConsoleLobbyKeyGuide:addGuide(newGuide, consoleUI_, keyString_)
  if nil == newGuide then
    return
  end
  local tableConsoleUI = {}
  local iconGapX = -self._gapX
  for index = 1, #consoleUI_ do
    local uiIcon = UI.createAndCopyBasePropertyControl(self._ui.guideBg, "Static_ConsoleKey", newGuide.guideBg, "ConsoleKey_" .. newGuide.state .. newGuide.guideIdx .. index)
    local uiIdx = consoleUI_[index]
    local x1, y1, x2, y2 = setTextureUV_Func(uiIcon, _consoleUIIconUV[uiIdx].x1, _consoleUIIconUV[uiIdx].y1, _consoleUIIconUV[uiIdx].x2, _consoleUIIconUV[uiIdx].y2)
    uiIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    uiIcon:setRenderTexture(uiIcon:getBaseTexture())
    if uiIdx == _consoleUIIconName.IconPlus or uiIdx == _consoleUIIconName.IconOr then
      uiIcon:SetSize(12, 44)
      iconGapX = iconGapX + self._gapIconX
    else
      iconGapX = iconGapX + self._gapX
    end
    uiIcon:SetPosX(uiIcon:GetPosX() - iconGapX)
    uiIcon:SetPosY(uiIcon:GetPosY() - newGuide.guideIdx * self._gapY)
    tableConsoleUI[index] = uiIcon
  end
  local tableString = UI.createAndCopyBasePropertyControl(self._ui.guideBg, "StaticText_KeyDesc", newGuide.guideBg, "String_" .. newGuide.state .. newGuide.guideIdx)
  tableString:SetText(keyString_)
  tableString:SetPosY(tableString:GetPosY() - newGuide.guideIdx * self._gapY)
  self:setGlowFont(tableString)
  newGuide.consoleUI[newGuide.guideIdx] = tableConsoleUI
  newGuide.keyString[newGuide.guideIdx] = tableString
  newGuide.guideIdx = newGuide.guideIdx + 1
end
function ConsoleLobbyKeyGuide:setGlowFont(control)
  control:useGlowFont(true, "SubTitleFont_14_Glow", self._glowFontColor)
end
function ConsoleLobbyKeyGuide:setGuide(currentState)
  if self._guideState.undefined == currentState then
    self:hideAllGuide()
    return
  end
  for index = 0, self._maxConsoleGuideType - 1 do
    if nil ~= self._ui._keyGuide[index] then
      self._ui._keyGuide[index].guideBg:SetShow(index == currentState)
    end
  end
end
function ConsoleLobbyKeyGuide:hideAllGuide()
  for index = 0, self._maxConsoleGuideType - 1 do
    if nil ~= self._ui._keyGuide[index] then
      self._ui._keyGuide[index].guideBg:SetShow(false)
    end
  end
end
function ConsoleLobbyKeyGuide:registEvent()
  registerEvent("onScreenResize", "PaGlobalFunc_ConsoleKeyGuide_SetPos")
end
function PaGlobalFunc_ConsoleKeyGuide_SetGuide(state)
  local self = ConsoleLobbyKeyGuide
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ConsoleLobbyKeyGuide")
    return
  end
  self:setGuide(state)
end
function PaGlobalFunc_ConsoleKeyGuide_HideAllGuide()
  local self = ConsoleLobbyKeyGuide
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ConsoleLobbyKeyGuide")
    return
  end
  self:hideAllGuide()
end
function PaGlobalFunc_ConsoleKeyGuide_SetScreenShotGuideState(state)
  local self = ConsoleLobbyKeyGuide
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ConsoleLobbyKeyGuide")
    return
  end
  if true == state then
    self:setGuide(self._guideState.screenshotGuide)
  else
    self:hideAllGuide()
  end
end
function PaGlobalFunc_ConsoleKeyGuide_SetPos()
  _panel:SetPosX(getScreenSizeX() - _panel:GetSizeX() - 50)
  _panel:SetPosY(getScreenSizeY() - _panel:GetSizeY() - 50)
end
function PaGlobalFunc_ConsoleKeyGuide_Init()
  if false == ToClient_isConsole() then
    return
  end
  local self = ConsoleLobbyKeyGuide
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ConsoleLobbyKeyGuide")
    return
  end
  self:init()
end
PaGlobalFunc_ConsoleKeyGuide_Init()
