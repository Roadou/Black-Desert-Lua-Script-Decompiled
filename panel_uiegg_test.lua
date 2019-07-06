local _panel = Panel_Window_UIEggTest
local uiEggTest = {
  _ui = {
    titleBg = UI.getChildControl(_panel, "Static_TitleBg"),
    leftTopBg = UI.getChildControl(_panel, "Static_LeftTopBg"),
    rightTopBg = UI.getChildControl(_panel, "Static_RightTopBg"),
    bottomBg = UI.getChildControl(_panel, "Static_BottomBg"),
    closeBtn = nil
  },
  _baseAttribute = {
    panelSizeX = _panel:GetSizeX(),
    panelSizeY = _panel:GetSizeY(),
    panelPosX = _panel:GetPosX(),
    panelPosY = _panel:GetPosY(),
    panelSpanX = _panel:GetSpanSize().x,
    panelSpanY = _panel:GetSpanSize().y
  }
}
function uiEggTest:dataInit()
end
function uiEggTest:update()
end
function uiEggTest_showAni()
end
function uiEggTest_hideAni()
end
function uiEggTest:open()
  self:update()
  _panel:SetShow(true, true)
end
function PaGlobal_UIEggTest_Open()
  uiEggTest:open()
end
function uiEggTest:close()
  _panel:SetShow(false, false)
end
function PaGlobal_UIEggTest_Close()
  _panel:SetShow(false)
end
function uiEggTest_LevelChange()
end
function uiEggTest_reposition()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  _panel:SetPosX((screenSizeX - _panel:GetSizeX()) / 2)
  _panel:SetPosY((screenSizeY - _panel:GetSizeY()) / 2)
end
function uiEggTest:panelInitialize()
  _panel:ActiveMouseEventEffect(true)
  _panel:setGlassBackground(true)
  _panel:SetDragEnable(true)
  _panel:setMaskingChild(true)
  _panel:RegisterShowEventFunc(true, "uiEggTest_showAni()")
  _panel:RegisterShowEventFunc(false, "uiEggTest_hideAni()")
end
function uiEggTest:registerEvent()
  registerEvent("onScreenResize", "uiEggTest_reposition")
  registerEvent("EventSelfPlayerLevelUp", "uiEggTest_LevelChange")
end
function uiEggTest_initialize()
  local self = uiEggTest
  self:panelInitialize()
  self:registerEvent()
  self._ui.closeBtn = UI.getChildControl(self._ui.titleBg, "Button_Close")
  self._ui.closeBtn:addInputEvent("Mouse_LUp", "PaGlobal_UIEggTest_Close()")
end
registerEvent("FromClient_luaLoadComplete", "uiEggTest_initialize")
