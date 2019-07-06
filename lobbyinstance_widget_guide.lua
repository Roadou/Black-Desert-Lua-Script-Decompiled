local _panel = LobbyInstance_Widget_Guide
local lobbyGuide = {
  _ui = {
    checkSpread = {},
    descBg = {},
    descGroup = {}
  },
  _maxDescCount = 5,
  _isAnimation = false,
  _preState = false,
  _currentIndex = 1,
  _preIndex = 1,
  _spreadSpeed = 20,
  _panelBaseSizeY = _panel:GetSizeY(),
  _defaultDescSizeY = 30,
  _expendSizeY = 0,
  _descMaskingSizeY = {}
}
local templateDesc = {
  desc = {}
}
local categoryInfo = {
  {
    "PANEL_BATTLEROYAL_GUIDE_STORY_",
    3
  },
  {
    "PANEL_BATTLEROYAL_GUIDE_RULE_",
    9
  },
  {
    "PANEL_BATTLEROYAL_GUIDE_TIP_",
    7
  },
  {
    "PANEL_BATTLEROYAL_GUIDE_KEY_",
    10
  },
  {
    "PANEL_BATTLEROYAL_GUIDE_REWARD_",
    4
  }
}
function lobbyGuide:initialize()
  if false == ToClient_isInstanceFieldMainServer() then
    self:close()
    return
  end
  self:open()
  for index = 1, self._maxDescCount do
    self._ui.checkSpread[index] = UI.getChildControl(_panel, "CheckButton_Spread_" .. index)
    self._ui.checkSpread[index]:SetCheck(false)
    self._ui.checkSpread[index]:SetEnableArea(-340, 0, 20, self._ui.checkSpread[index]:GetSizeY())
    self._ui.descBg[index] = UI.getChildControl(self._ui.checkSpread[index], "Static_DescBg_" .. index)
    self._ui.descBg[index]:SetRectClipOnArea(float2(0, 0), float2(self._ui.descBg[index]:GetSizeX(), self._defaultDescSizeY))
    self._descMaskingSizeY[index] = 30
    for subIdx = 1, categoryInfo[index][2] do
      self._ui.descGroup[index] = templateDesc
      self._ui.descGroup[index].desc[subIdx] = UI.getChildControl(self._ui.descBg[index], "StaticText_Desc" .. subIdx)
      self._ui.descGroup[index].desc[subIdx]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      self._ui.descGroup[index].desc[subIdx]:SetText(PAGetString(Defines.StringSheet_RESOURCE, categoryInfo[index][1] .. tostring(subIdx)))
      self._ui.descGroup[index].desc[subIdx]:SetSize(360, self._ui.descGroup[index].desc[subIdx]:GetTextSizeY())
      self._ui.descGroup[index].desc[subIdx]:SetSpanSize(10, self._descMaskingSizeY[index])
      self._descMaskingSizeY[index] = self._descMaskingSizeY[index] + self._ui.descGroup[index].desc[subIdx]:GetTextSizeY() + 10
    end
  end
  self._preIndex = 1
  self:registEventHandler()
  lobbyGuide_Spread(1)
end
function lobbyGuide:registEventHandler()
  for index = 1, self._maxDescCount do
    self._ui.checkSpread[index]:addInputEvent("Mouse_LUp", "lobbyGuide_Spread(" .. index .. ")")
  end
  registerEvent("onScreenResize", "FromClient_lobbyGuide_ScreenResize")
end
function lobbyGuide:open()
  if _panel:GetShow() == true then
    self:close()
    return
  end
  _panel:SetShow(true)
end
function lobbyGuide:close()
  _panel:SetShow(false)
end
function lobbyGuide:update()
end
function lobbyGuide:resize()
end
function FromClient_lobbyGuide_Init()
  local self = lobbyGuide
  self:initialize()
end
function FromClient_lobbyGuide_ScreenResize()
  local self = lobbyGuide
  self:resize()
end
function PaGlobalFunc_lobbyGuide_Open()
  local self = lobbyGuide
  self:open()
end
function PaGlobalFunc_lobbyGuide_Close()
  local self = lobbyGuide
  self:close()
end
function lobbyGuide:panelSizeInit()
  _panel:SetSize(_panel:GetSizeX(), self._panelBaseSizeY)
  for index = 1, self._maxDescCount do
    self._ui.checkSpread[index]:ComputePos()
  end
end
function lobbyGuide_Spread(contentIndex)
  local self = lobbyGuide
  if self._isAnimation ~= self._preState and contentIndex ~= self._currentIndex then
    self._ui.checkSpread[contentIndex]:SetCheck(false)
    return
  end
  _panel:RegisterUpdateFunc("PaGlobal_InstanceLobby_Update")
  for index = 1, self._maxDescCount do
    if index ~= contentIndex then
      self._ui.checkSpread[index]:SetCheck(false)
    end
  end
  self._currentIndex = contentIndex
  if self._ui.checkSpread[contentIndex]:IsCheck() then
    self._expendSizeY = self._panelBaseSizeY + self._descMaskingSizeY[self._currentIndex] - 35
    self._ui.descBg[self._preIndex]:SetRectClipOnArea(float2(0, 0), float2(self._ui.descBg[self._preIndex]:GetSizeX(), self._defaultDescSizeY))
    self:panelSizeInit()
  elseif self._isAnimation == self._preState then
    self._expendSizeY = self._panelBaseSizeY
  end
  self._isAnimation = not self._isAnimation
end
function PaGlobal_InstanceLobby_Update(deltaTime)
  local self = lobbyGuide
  if self._isAnimation ~= self._preState then
    self._ui.checkSpread[self._currentIndex]:SetIgnore(true)
    if self._ui.checkSpread[self._currentIndex]:IsCheck() then
      if _panel:GetSizeY() < self._expendSizeY then
        _panel:SetSize(_panel:GetSizeX(), _panel:GetSizeY() + self._spreadSpeed)
        self._ui.descBg[self._currentIndex]:SetRectClipOnArea(float2(0, 0), float2(self._ui.descBg[self._currentIndex]:GetSizeX(), math.min(_panel:GetSizeY() - self._panelBaseSizeY + self._defaultDescSizeY - 5 + self._spreadSpeed, self._descMaskingSizeY[self._currentIndex])))
        for index = 1, self._maxDescCount do
          if index > self._currentIndex then
            self._ui.checkSpread[index]:SetPosY(self._ui.checkSpread[index]:GetPosY() + self._spreadSpeed)
          end
        end
      else
        self._preState = self._isAnimation
        self._preIndex = self._currentIndex
        self._ui.checkSpread[self._currentIndex]:SetIgnore(false)
        _panel:ClearUpdateLuaFunc()
      end
    elseif self._expendSizeY < _panel:GetSizeY() then
      _panel:SetSize(_panel:GetSizeX(), _panel:GetSizeY() - self._spreadSpeed)
      self._ui.descBg[self._currentIndex]:SetRectClipOnArea(float2(0, 0), float2(self._ui.descBg[self._currentIndex]:GetSizeX(), math.max(_panel:GetSizeY() - self._panelBaseSizeY + self._defaultDescSizeY - 5 - self._spreadSpeed, self._defaultDescSizeY)))
      for index = 1, self._maxDescCount do
        if index > self._currentIndex then
          self._ui.checkSpread[index]:SetPosY(self._ui.checkSpread[index]:GetPosY() - self._spreadSpeed)
        end
      end
    else
      self._preState = self._isAnimation
      self._preIndex = self._currentIndex
      self._ui.checkSpread[self._currentIndex]:SetIgnore(false)
      _panel:ClearUpdateLuaFunc()
    end
  else
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_lobbyGuide_Init")
