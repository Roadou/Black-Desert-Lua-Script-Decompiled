local StableUIMode = Defines.UIMode.eUIMode_Stable
Panel_Window_WharfFunction:ignorePadSnapMoveToOtherPanel()
local Panle_Window_WharfFunction_Info = {
  _ui = {
    static_LB_ConsoleUI = nil,
    static_RB_ConsoleUI = nil,
    radioButton_Tempelate = nil
  },
  _value = {
    lastIndex = 0,
    currentIndex = 0,
    currentFuncCount = 0
  },
  _config = {maxFuncButton = 1},
  _enum = {eFUNCTION_WHARF = 0},
  _pos = {
    rangeX = 800,
    startPosX = 0,
    spaceFunPosX = 0,
    sizeFunPosX = 50
  },
  _functionList = {
    [0] = PaGlobalFunc_WharfFunction_List
  },
  _functionTextList = {
    [0] = nil
  },
  _functionListText = {
    [0] = "PaGlobalFunc_WharfFunction_List()"
  },
  _funcButtonList = {}
}
function Panle_Window_WharfFunction_Info:registEventHandler()
  Panel_Window_WharfFunction:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_WharfFunction_forPadEventFunc(-1)")
  Panel_Window_WharfFunction:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_WharfFunction_forPadEventFunc(1)")
end
function Panle_Window_WharfFunction_Info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_WharfFunction_Resize")
end
function Panle_Window_WharfFunction_Info:closeWharfSubPanel()
  if PaGlobalFunc_WharfList_GetShow() then
    PaGlobalFunc_WharfList_Close()
  end
  self:closeWharfSubPanelWithoutList()
end
function Panle_Window_WharfFunction_Info:closeWharfSubPanelWithoutList()
  if PaGlobalFunc_WharfRegister_GetShow() then
    PaGlobalFunc_WharfRegister_ExitAll()
  end
  if PaGlobalFunc_WharfInfo_GetShow() then
    PaGlobalFunc_WharfInfo_Close()
  end
  if PaGlobalFunc_WharfInfo_Menu_GetShow() then
    PaGlobalFunc_WharfInfo_Menu_Close()
  end
end
function Panle_Window_WharfFunction_Info:closeWharfSubPanelOnce()
  if PaGlobalFunc_WharfRegister_GetShow() then
    PaGlobalFunc_WharfRegister_ExitAndOpenList()
    return true
  end
  if PaGlobalFunc_WharfInfo_GetShow() then
    PaGlobalFunc_WharfInfo_Exit()
    return true
  end
  if PaGlobalFunc_WharfList_GetShow() then
    PaGlobalFunc_WharfList_Close()
    return false
  end
  return false
end
function Panle_Window_WharfFunction_Info:initValue()
  self._value.lastIndex = 0
  self._value.currentIndex = 0
end
function Panle_Window_WharfFunction_Info:initialize()
  self:childControl()
  self:initValue()
  self:initTextAndFunc()
  self:resize()
  self:createFunButton()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panle_Window_WharfFunction_Info:initTextAndFunc()
  self._functionList[self._enum.eFUNCTION_WHARF] = PaGlobalFunc_WharfFunction_List
  self._functionTextList[self._enum.eFUNCTION_WHARF] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_8")
end
function Panle_Window_WharfFunction_Info:resize()
end
function Panle_Window_WharfFunction_Info:createFunButton()
  for index = 0, self._config.maxFuncButton - 1 do
    local funSlot = {
      selected = false,
      buttonType = nil,
      buttonFunc = nil,
      radioButton = nil
    }
    function funSlot:setFunSlot(buttonType, buttonFunc)
      local info = Panle_Window_WharfFunction_Info
      self.buttonType = buttonType
      self.buttonFunc = buttonFunc
      self.radioButton:SetText(info._functionTextList[buttonType])
      self.radioButton:addInputEvent("Mouse_LUp", info._functionListText[buttonType])
    end
    function funSlot:selectSlot(bSelect)
      self.selected = bSelect
      self.radioButton:SetCheck(bSelect)
    end
    function funSlot:setShow(bShow)
      self.radioButton:SetShow(bShow)
    end
    function funSlot:clear()
      self:setShow(false)
      self:selectSlot(false)
      self.buttonType = nil
      self.buttonFunc = nil
      self.radioButton:addInputEvent("Mouse_LUp", "")
      self.radioButton:SetFontColor(Defines.Color.C_FF525B6D)
    end
    funSlot.radioButton = UI.createAndCopyBasePropertyControl(Panel_Window_WharfFunction, "RadioButton_Tempelate", Panel_Window_WharfFunction, "RadioButton_Tempelate_" .. index)
    funSlot:clear()
    self._funcButtonList[index] = funSlot
  end
end
function Panle_Window_WharfFunction_Info:childControl()
  self._ui.static_LB_ConsoleUI = UI.getChildControl(Panel_Window_WharfFunction, "Static_LB_ConsoleUI")
  self._ui.static_RB_ConsoleUI = UI.getChildControl(Panel_Window_WharfFunction, "Static_RB_ConsoleUI")
  self._ui.radioButton_Tempelate = UI.getChildControl(Panel_Window_WharfFunction, "RadioButton_Tempelate")
  self._ui.static_LB_ConsoleUI:SetShow(false)
  self._ui.static_RB_ConsoleUI:SetShow(false)
  self._ui.radioButton_Tempelate:SetShow(false)
end
function Panle_Window_WharfFunction_Info:buttonClear()
  for index = 0, self._config.maxFuncButton - 1 do
    self._funcButtonList[index]:clear()
  end
end
function Panle_Window_WharfFunction_Info:buttonReadToOpen()
  self._value.currentFuncCount = 0
  self._funcButtonList[self._value.currentFuncCount]:setShow(true)
  self._funcButtonList[self._value.currentFuncCount]:setFunSlot(self._enum.eFUNCTION_WHARF, self._functionList[self._enum.eFUNCTION_WHARF])
  self._value.currentFuncCount = self._value.currentFuncCount + 1
  self:buttonPos()
end
function Panle_Window_WharfFunction_Info:buttonPos()
  local sizeX = getScreenSizeX()
  if 0 == self._value.currentFuncCount or 1 == self._value.currentFuncCount then
    self._pos.startPosX = sizeX / 2
    self._pos.spaceFunPosX = 0
  else
    self._pos.startPosX = (sizeX - self._pos.rangeX) / 2
    self._pos.spaceFunPosX = self._pos.rangeX / self._value.currentFuncCount
  end
  for index = 0, self._value.currentFuncCount - 1 do
    self._funcButtonList[index].radioButton:SetPosX(self._pos.startPosX + self._pos.spaceFunPosX * (index + 1))
  end
end
function Panle_Window_WharfFunction_Info:readyToShow()
  self:resize()
  self:initValue()
  self:buttonClear()
  self:buttonReadToOpen()
end
function Panle_Window_WharfFunction_Info:open()
  Panel_Window_WharfFunction:SetShow(true)
end
function Panle_Window_WharfFunction_Info:close()
  Panel_Window_WharfFunction:SetShow(false)
end
function PaGlobalFunc_WharfFunction_GetShow()
  return Panel_Window_WharfFunction:GetShow()
end
function PaGlobalFunc_WharfFunction_Open()
  local self = Panle_Window_WharfFunction_Info
  self:open()
end
function PaGlobalFunc_WharfFunction_Close()
  local self = Panle_Window_WharfFunction_Info
  self:close()
end
function PaGlobalFunc_WharfFunction_Show()
  local self = Panle_Window_WharfFunction_Info
  self:readyToShow()
  Servant_SceneOpen(Panel_Window_WharfFunction)
  self:open()
  PaGlobalFunc_WharfFunction_SelectButton(0)
end
function WharfFunction_Close()
  local self = Panle_Window_WharfFunction_Info
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self:closeWharfSubPanel()
  self:close()
  PaGlobalFunc_MainDialog_Bottom_FuncButtonUpdate()
  Servant_SceneClose(Panel_Window_WharfFunction)
end
function PaGlobalFunc_WharfFunction_UpAni()
end
function PaGlobalFunc_WharfFunction_DownAni()
  local screenSizeY = getScreenSizeY()
end
function PaGlobalFunc_WharfFunction_closeWharfSubPanelOnce()
  local self = Panle_Window_WharfFunction_Info
  return self:closeWharfSubPanelOnce()
end
function PaGlobalFunc_WharfFunction_forPadEventFunc(value)
  local self = Panle_Window_WharfFunction_Info
  if self._value.currentFuncCount <= 1 then
    return
  end
  local newIndex = self._value.currentIndex + value
  if newIndex == self._value.currentFuncCount then
    newIndex = 0
  elseif newIndex < 0 then
    newIndex = self._value.currentFuncCount - 1
  end
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  self:closeWharfSubPanel()
  PaGlobalFunc_WharfFunction_SelectButton(newIndex)
end
function PaGlobalFunc_WharfFunction_SelectButton(index)
  local self = Panle_Window_WharfFunction_Info
  self._value.lastIndex = self._value.currentIndex
  self._value.currentIndex = index
  local buttonFunc = self._funcButtonList[index].buttonFunc
  if nil ~= buttonFunc then
    buttonFunc()
  end
  if nil ~= self._funcButtonList[self._value.lastIndex].radioButton then
    self._funcButtonList[self._value.lastIndex].radioButton:SetFontColor(Defines.Color.C_FF525B6D)
  end
  if nil ~= self._funcButtonList[self._value.currentIndex].radioButton then
    self._funcButtonList[self._value.currentIndex].radioButton:SetFontColor(Defines.Color.C_FFEEEEEE)
  end
end
function PaGlobalFunc_WharfFunction_List()
  local self = Panle_Window_WharfFunction_Info
  self:closeWharfSubPanelWithoutList()
  PaGlobalFunc_WharfList_Show()
end
function FromClient_WharfFunction_Init()
  local self = Panle_Window_WharfFunction_Info
  self:initialize()
end
function FromClient_WharfFunction_Resize()
  local self = Panle_Window_WharfFunction_Info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_WharfFunction_Init")
