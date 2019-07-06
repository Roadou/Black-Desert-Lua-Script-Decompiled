Panel_WorldmapKeyGuide:SetShow(false)
local Panel_WorldmapKeyGuideInfo = {
  _staticText_B = UI.getChildControl(Panel_WorldmapKeyGuide, "StaticText_B"),
  _staticText_X_Hold = UI.getChildControl(Panel_WorldmapKeyGuide, "StaticText_X_Hold"),
  _staticText_X = UI.getChildControl(Panel_WorldmapKeyGuide, "StaticText_X"),
  _staticText_LTPlusStick = UI.getChildControl(Panel_WorldmapKeyGuide, "StaticText_LTPlusStick"),
  _staticText_LTPlusX = UI.getChildControl(Panel_WorldmapKeyGuide, "StaticText_LTPlusX"),
  _staticText_RS = UI.getChildControl(Panel_WorldmapKeyGuide, "StaticText_RS"),
  _staticText_LS = UI.getChildControl(Panel_WorldmapKeyGuide, "StaticText_LS"),
  _staticText_DpadDown = UI.getChildControl(Panel_WorldmapKeyGuide, "StaticText_DpadDown"),
  _staticText_DpadUp = UI.getChildControl(Panel_WorldmapKeyGuide, "StaticText_DpadUp"),
  _showableCheck = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true
  },
  _config = {
    _keyGuideCount = 9,
    _yGap = 40,
    _B = 0,
    _X_Hold = 1,
    _X = 2,
    _LTPlusX = 3,
    _LTPlusStick = 4,
    _RS = 5,
    _LS = 6,
    _DpadDown = 7,
    _DpadUp = 8
  },
  _bookmarkString = {
    _set = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_KEYGUIDE_REGISTBOOKMARK"),
    _unset = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_KEYGUIDE_UNREGISTBOOKMARK")
  }
}
Panel_WorldmapKeyGuideInfo._controlList = {
  [0] = Panel_WorldmapKeyGuideInfo._staticText_B,
  [1] = Panel_WorldmapKeyGuideInfo._staticText_X_Hold,
  [2] = Panel_WorldmapKeyGuideInfo._staticText_X,
  [3] = Panel_WorldmapKeyGuideInfo._staticText_LTPlusX,
  [4] = Panel_WorldmapKeyGuideInfo._staticText_LTPlusStick,
  [5] = Panel_WorldmapKeyGuideInfo._staticText_RS,
  [6] = Panel_WorldmapKeyGuideInfo._staticText_LS,
  [7] = Panel_WorldmapKeyGuideInfo._staticText_DpadDown,
  [8] = Panel_WorldmapKeyGuideInfo._staticText_DpadUp
}
function PaGlobal_ConsoleWorldMapKeyGuide_Update()
  local self = Panel_WorldmapKeyGuideInfo
  PaGlobal_ConsoleWorldMapKeyGuide_CheckShow()
  self:updateShow()
  self:updatePos()
end
function Panel_WorldmapKeyGuideInfo:updateShow()
  for index = 0, self._config._keyGuideCount - 1 do
    self._controlList[index]:SetShow(self._showableCheck[index])
  end
end
function Panel_WorldmapKeyGuideInfo:updatePos()
  local currentPosY = self._staticText_B:GetPosY()
  for index = 0, self._config._keyGuideCount - 1 do
    if true == self._controlList[index]:GetShow() then
      self._controlList[index]:SetPosY(currentPosY)
      currentPosY = currentPosY - self._config._yGap
    end
  end
end
function PaGlobal_ConsoleWorldMapKeyGuide_CheckShow()
  local self = Panel_WorldmapKeyGuideInfo
  local config = self._config
  if 0 == PaGlobalFunc_WorldMap_BottomMenu_GetMode() then
    self._showableCheck[config._X_Hold] = true
  else
    self._showableCheck[config._X_Hold] = false
  end
  if true == PaGlobalFunc_WorldMap_BottomMenu_GetShow() then
    self._showableCheck[config._DpadUp] = true
    self._showableCheck[config._DpadDown] = true
  else
    self._showableCheck[config._X_Hold] = false
    self._showableCheck[config._DpadUp] = false
    self._showableCheck[config._DpadDown] = false
  end
  if -1 == PaGlobalFunc_WorldMap_GetFocusedBookMarkIndex() then
    self._controlList[config._X_Hold]:SetText(self._bookmarkString._set)
  else
    self._controlList[config._X_Hold]:SetText(self._bookmarkString._unset)
  end
end
function PaGlobal_ConsoleWorldMapKeyGuide_SetPos(isBottomPanelShow)
  local self = Panel_WorldmapKeyGuideInfo
  local offsetY
  if true == isBottomPanelShow then
    offsetY = 120
  else
    offsetY = 50
  end
  local screenGapSizeX = (getOriginScreenSizeX() - getScreenSizeX()) / 2
  local screenGapSizeY = (getOriginScreenSizeY() - getScreenSizeY()) / 2
  Panel_WorldmapKeyGuide:SetPosX(getScreenSizeX() - Panel_WorldmapKeyGuide:GetSizeX() + screenGapSizeX)
  Panel_WorldmapKeyGuide:SetPosY(getScreenSizeY() - Panel_WorldmapKeyGuide:GetSizeY() - offsetY + screenGapSizeY)
  PaGlobal_ConsoleWorldMapKeyGuide_Update()
end
function PaGlobal_ConsoleWorldMapKeyGuide_SetShow(isShow)
  Panel_WorldmapKeyGuide:SetShow(isShow)
end
registerEvent("onScreenResize", "PaGlobal_ConsoleWorldMapKeyGuide_SetPos")
