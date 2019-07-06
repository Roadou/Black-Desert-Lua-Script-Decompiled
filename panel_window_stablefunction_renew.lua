local StableUIMode = Defines.UIMode.eUIMode_Stable
Panel_Window_StableFunction:ignorePadSnapMoveToOtherPanel()
local Panle_Window_StableFunction_Info = {
  _ui = {
    funcButtonPanel = Panel_Window_StableFunction,
    static_LB_ConsoleUI = nil,
    static_RB_ConsoleUI = nil,
    staticText_Exit_ConsoleUI = nil,
    radioButton_Tempelate = nil
  },
  _value = {
    lastIndex = 0,
    currentIndex = 0,
    currentFuncCount = 0
  },
  _config = {maxFuncButton = 5},
  _pos = {
    rangeX = 1000,
    startPosX = 0,
    spaceFunPosX = 0,
    sizeFunPosX = 50
  },
  _enum = {
    eFUNCTION_STABLE = 0,
    eFUNCTION_MIX = 1,
    eFUNCTION_CARRIAGE = 2,
    eFUNCTION_MATING = 3,
    eFUNCTION_MARKET = 4
  },
  _functionList = {
    [0] = PaGlobalFunc_StableFunction_List,
    [1] = PaGlobalFunc_StableFunction_ExChange,
    [2] = PaGlobalFunc_StableFunction_Carriage,
    [3] = PaGlobalFunc_StableFunction_Mating,
    [4] = PaGlobalFunc_StableFunction_Market
  },
  _functionTextList = {
    [0] = nil,
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil
  },
  _functionListText = {
    [0] = "PaGlobalFunc_StableFunction_List()",
    [1] = "PaGlobalFunc_StableFunction_ExChange()",
    [2] = "PaGlobalFunc_StableFunction_Carriage()",
    [3] = "PaGlobalFunc_StableFunction_Mating()",
    [4] = "PaGlobalFunc_StableFunction_Market()"
  },
  _funcButtonList = {}
}
function Panle_Window_StableFunction_Info:registEventHandler()
  Panel_Window_StableFunction:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_StableFunction_forPadEventFunc(-1)")
  Panel_Window_StableFunction:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_StableFunction_forPadEventFunc(1)")
end
function Panle_Window_StableFunction_Info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_StableFunction_Resize")
end
function Panle_Window_StableFunction_Info:closeStableSubPanel()
  if PaGlobalFunc_StableList_GetShow() then
    PaGlobalFunc_StableList_Close()
  end
  self:closeStableSubPanelWithoutList()
end
function Panle_Window_StableFunction_Info:closeStableSubPanelWithoutList()
  if PaGlobalFunc_StableRegister_Name_GetShow() then
    PaGlobalFunc_StableRegister_Name_Close()
  end
  if PaGlobalFunc_StableMarket_Filter_GetShow() then
    PaGlobalFunc_StableMarket_Filter_Close()
  end
  if PaGlobalFunc_StableRegister_MarketCheck_GetShow() then
    PaGlobalFunc_StableRegister_MarketCheck_Close()
  end
  if PaGlobalFunc_StableExchange_GetShow() then
    PaGlobalFunc_StableExchange_Close()
  end
  if PaGlobalFunc_StableChangeSkill_GetShow() then
    PaGlobalFunc_StableChangeSkill_Close()
  end
  if PaGlobalFunc_StableRegister_GetShow() then
    PaGlobalFunc_StableRegister_ExitAll()
  end
  if PaGlobalFunc_StableInfo_GetShow() then
    PaGlobalFunc_StableInfo_Close()
  end
  if PaGlobalFunc_StableInfo_Menu_GetShow() then
    PaGlobalFunc_StableInfo_Menu_Close()
  end
  if PaGlobalFunc_StableMating_GetShow() then
    PaGlobalFunc_StableMating_Close()
  end
  if PaGlobalFunc_StableMarket_GetShow() then
    PaGlobalFunc_StableMarket_Close()
  end
  if PaGlobalFunc_StableRegister_Market_GetShow() then
    PaGlobalFunc_StableRegister_Market_Close()
  end
end
function Panle_Window_StableFunction_Info:closeStablSubPanelOnce()
  if PaGlobalFunc_StableRegister_Name_GetShow() then
    PaGlobalFunc_StableRegister_Name_Exit()
    return true
  end
  if PaGlobalFunc_StableMarket_Filter_GetShow() then
    PaGlobalFunc_StableMarket_Filter_Close()
    return true
  end
  if PaGlobalFunc_StableRegister_MarketCheck_GetShow() then
    PaGlobalFunc_StableRegister_MarketCheck_Close()
    return true
  end
  if PaGlobalFunc_StableRegister_Market_GetShow() then
    PaGlobalFunc_StableRegister_Market_Exit()
    return true
  end
  if PaGlobalFunc_StableChangeSkillSelect_GetShow() then
    PaGlobalFunc_StableChangeSkillSelect_Exit()
    return true
  end
  if PaGlobalFunc_StableChangeSkill_GetShow() then
    PaGlobalFunc_StableChangeSkill_Exit()
    return true
  end
  if PaGlobalFunc_StableRegister_GetShow() then
    PaGlobalFunc_StableRegister_ExitAndOpenList()
    return true
  end
  if PaGlobalFunc_StableInfo_GetShow() then
    PaGlobalFunc_StableInfo_Exit()
    return true
  end
  if PaGlobalFunc_StableExchange_GetShow() then
    return PaGlobalFunc_StableExchange_Exit()
  end
  if PaGlobalFunc_StableList_GetShow() then
    PaGlobalFunc_StableList_Close()
    return false
  end
  if PaGlobalFunc_StableMarket_GetShow() then
    PaGlobalFunc_StableMarket_Close()
    return false
  end
  if PaGlobalFunc_StableMating_GetShow() then
    PaGlobalFunc_StableMating_Close()
    return false
  end
  return false
end
function Panle_Window_StableFunction_Info:initialize()
  self:childControl()
  self:initValue()
  self:initTextAndFunc()
  self:resize()
  self:createFunButton()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panle_Window_StableFunction_Info:initValue()
  self._value.lastIndex = 0
  self._value.currentIndex = 0
end
function Panle_Window_StableFunction_Info:initTextAndFunc()
  self._functionList[0] = PaGlobalFunc_StableFunction_List
  self._functionList[1] = PaGlobalFunc_StableFunction_ExChange
  self._functionList[2] = PaGlobalFunc_StableFunction_Carriage
  self._functionList[3] = PaGlobalFunc_StableFunction_Mating
  self._functionList[4] = PaGlobalFunc_StableFunction_Market
  self._functionTextList[0] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_FUNCTION_STABLE")
  self._functionTextList[1] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEFUNCTION_BTN_HORSEMIX")
  self._functionTextList[2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_STABLEFUNCTION_HORSELINK")
  self._functionTextList[3] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMATING_TITLE")
  self._functionTextList[4] = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_FUNCTION_BTN_MARKET")
end
function Panle_Window_StableFunction_Info:resize()
end
function Panle_Window_StableFunction_Info:childControl()
  self._ui.static_LB_ConsoleUI = UI.getChildControl(Panel_Window_StableFunction, "Static_LB_ConsoleUI")
  self._ui.static_RB_ConsoleUI = UI.getChildControl(Panel_Window_StableFunction, "Static_RB_ConsoleUI")
  self._ui.staticText_Exit_ConsoleUI = UI.getChildControl(Panel_Window_StableFunction, "StaticText_Exit_ConsoleUI")
  self._ui.radioButton_Tempelate = UI.getChildControl(Panel_Window_StableFunction, "RadioButton_Tempelate")
end
function Panle_Window_StableFunction_Info:createFunButton()
  self.keyGuideBtnGroup = {}
  for index = 0, self._config.maxFuncButton - 1 do
    local funSlot = {
      selected = false,
      buttonType = nil,
      buttonFunc = nil,
      radioButton = nil
    }
    function funSlot:setFunSlot(buttonType, buttonFunc)
      local info = Panle_Window_StableFunction_Info
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
    funSlot.radioButton = UI.createAndCopyBasePropertyControl(Panel_Window_StableFunction, "RadioButton_Tempelate", Panel_Window_StableFunction, "RadioButton_Tempelate_" .. index)
    funSlot:clear()
    self._funcButtonList[index] = funSlot
    self.keyGuideBtnGroup[#self.keyGuideBtnGroup + 1] = funSlot.radioButton
  end
end
function Panle_Window_StableFunction_Info:buttonClear()
  for index = 0, self._config.maxFuncButton - 1 do
    self._funcButtonList[index]:clear()
  end
end
function Panle_Window_StableFunction_Info:buttonReadToOpen()
  self._value.currentFuncCount = 0
  self._funcButtonList[self._value.currentFuncCount]:setShow(true)
  self._funcButtonList[self._value.currentFuncCount]:setFunSlot(self._enum.eFUNCTION_STABLE, self._functionList[self._enum.eFUNCTION_STABLE])
  self._value.currentFuncCount = self._value.currentFuncCount + 1
  if stable_isMix() then
    self._funcButtonList[self._value.currentFuncCount]:setShow(true)
    self._funcButtonList[self._value.currentFuncCount]:setFunSlot(self._enum.eFUNCTION_MIX, self._functionList[self._enum.eFUNCTION_MIX])
    self._value.currentFuncCount = self._value.currentFuncCount + 1
  end
  if stable_isCarriage() then
    self._funcButtonList[self._value.currentFuncCount]:setShow(true)
    self._funcButtonList[self._value.currentFuncCount]:setFunSlot(self._enum.eFUNCTION_CARRIAGE, self._functionList[self._enum.eFUNCTION_CARRIAGE])
    self._value.currentFuncCount = self._value.currentFuncCount + 1
  end
  if stable_isMating() then
    self._funcButtonList[self._value.currentFuncCount]:setShow(true)
    self._funcButtonList[self._value.currentFuncCount]:setFunSlot(self._enum.eFUNCTION_MATING, self._functionList[self._enum.eFUNCTION_MATING])
    self._value.currentFuncCount = self._value.currentFuncCount + 1
  end
  if stable_isMarket() then
    self._funcButtonList[self._value.currentFuncCount]:setShow(true)
    self._funcButtonList[self._value.currentFuncCount]:setFunSlot(self._enum.eFUNCTION_MARKET, self._functionList[self._enum.eFUNCTION_MARKET])
    self._value.currentFuncCount = self._value.currentFuncCount + 1
  end
  self:buttonPos()
end
function Panle_Window_StableFunction_Info:buttonPos()
  if nil ~= self.keyGuideBtnGroup then
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(self.keyGuideBtnGroup, Panel_Window_StableFunction, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_CENTER, 0, 30)
  end
end
function Panle_Window_StableFunction_Info:readyToOpen()
  self:resize()
  self:initValue()
  self:buttonClear()
  self:buttonReadToOpen()
end
function Panle_Window_StableFunction_Info:readyToClose()
end
function Panle_Window_StableFunction_Info:update()
end
function Panle_Window_StableFunction_Info:open()
  Panel_Window_StableFunction:SetShow(true)
end
function Panle_Window_StableFunction_Info:close()
  Panel_Window_StableFunction:SetShow(false)
end
function PaGlobalFunc_StableFunction_GetShow()
  return Panel_Window_StableFunction:GetShow()
end
function PaGlobalFunc_StableFunction_Open()
  local self = Panle_Window_StableFunction_Info
  self:readyToOpen()
  Servant_SceneOpen(Panel_Window_StableFunction)
  self:open()
  PaGlobalFunc_StableFunction_SelectButton(self._value.currentIndex)
end
function StableFunction_Close()
  local self = Panle_Window_StableFunction_Info
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  self:closeStableSubPanel()
  self:close()
  PaGlobalFunc_MainDialog_Bottom_FuncButtonUpdate()
  Servant_SceneClose(Panel_Window_StableFunction)
end
function PaGlobalFunc_StableFunction_SelectButton(index, optionalParam)
  local self = Panle_Window_StableFunction_Info
  self._value.lastIndex = self._value.currentIndex
  self._value.currentIndex = index
  local buttonFunc = self._funcButtonList[index].buttonFunc
  if nil ~= buttonFunc then
    buttonFunc(optionalParam)
  end
  if nil ~= self._funcButtonList[self._value.lastIndex].radioButton then
    self._funcButtonList[self._value.lastIndex].radioButton:SetFontColor(Defines.Color.C_FF525B6D)
  end
  if nil ~= self._funcButtonList[self._value.currentIndex].radioButton then
    self._funcButtonList[self._value.currentIndex].radioButton:SetFontColor(Defines.Color.C_FFEEEEEE)
  end
end
function PaGlobalFunc_StableFunction_List()
  local self = Panle_Window_StableFunction_Info
  self:closeStableSubPanelWithoutList()
  PaGlobalFunc_StableList_Show()
  self._ui.staticText_Exit_ConsoleUI:SetShow(false)
end
function PaGlobalFunc_StableFunction_ExChange()
  local self = Panle_Window_StableFunction_Info
  self:closeStableSubPanel()
  PaGlobalFunc_StableExchange_ShowByExchange()
  self._ui.staticText_Exit_ConsoleUI:SetShow(true)
end
function PaGlobalFunc_StableFunction_Carriage()
  local self = Panle_Window_StableFunction_Info
  self:closeStableSubPanel()
  PaGlobalFunc_StableExchange_ShowByLink()
end
function PaGlobalFunc_StableFunction_Mating(tab)
  local self = Panle_Window_StableFunction_Info
  self:closeStableSubPanel()
  PaGlobalFunc_StableMating_Show(tab)
end
function PaGlobalFunc_StableFunction_Market()
  local self = Panle_Window_StableFunction_Info
  self:closeStableSubPanel()
  PaGlobalFunc_StableMarket_Show()
  self._ui.staticText_Exit_ConsoleUI:SetShow(true)
end
function PaGlobalFunc_StableFunction_UpAni()
  Panel_Window_StableFunction:SetPosY(Panel_Window_StableFunction:GetPosY() - Panel_Window_StableList:GetSizeY())
end
function PaGlobalFunc_StableFunction_DownAni()
  local screenSizeY = getScreenSizeY()
  Panel_Window_StableFunction:SetPosY(screenSizeY - Panel_Window_StableFunction:GetSizeY())
end
function PaGlobalFunc_StableFunction_forPadEventFunc(value)
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  local self = Panle_Window_StableFunction_Info
  if self._value.currentFuncCount <= 1 then
    return
  end
  local newIndex = self._value.currentIndex + value
  if newIndex == self._value.currentFuncCount then
    newIndex = 0
  elseif newIndex < 0 then
    newIndex = self._value.currentFuncCount - 1
  end
  self:closeStableSubPanel()
  PaGlobalFunc_StableFunction_SelectButton(newIndex)
end
function PaGlobalFunc_StableFunction_closeStablSubPanelOnce()
  local self = Panle_Window_StableFunction_Info
  return self:closeStablSubPanelOnce()
end
function FromClient_StableFunction_Init()
  local self = Panle_Window_StableFunction_Info
  self:initialize()
end
function FromClient_StableFunction_Resize()
  local self = Panle_Window_StableFunction_Info
  self:resize()
end
function FromClient_StableFunction_ServantUpdate()
  if GetUIMode() == Defines.UIMode.eUIMode_Default then
    return
  end
  if false == Panel_Stable_List:GetShow() then
    return
  end
  Inventory_SetFunctor(nil)
  InventoryWindow_Close()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_StableFunction_Init")
