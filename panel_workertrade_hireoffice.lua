Panel_WorkerTrade_HireOffice:SetShow(false, false)
Panel_WorkerTrade_HireOffice:setGlassBackground(true)
Panel_WorkerTrade_HireOffice:SetDragAll(true)
Panel_WorkerTrade_HireOffice:RegisterShowEventFunc(true, "Panel_WorkerTrade_HireOffice_ShowAni()")
Panel_WorkerTrade_HireOffice:RegisterShowEventFunc(false, "Panel_WorkerTrade_HireOffice_HideAni()")
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
function Panel_WorkerTrade_HireOffice_ShowAni()
  UIAni.fadeInSCR_Down(Panel_WorkerTrade_HireOffice)
  local aniInfo1 = Panel_WorkerTrade_HireOffice:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_WorkerTrade_HireOffice:GetSizeX() / 2
  aniInfo1.AxisY = Panel_WorkerTrade_HireOffice:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_WorkerTrade_HireOffice:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_WorkerTrade_HireOffice:GetSizeX() / 2
  aniInfo2.AxisY = Panel_WorkerTrade_HireOffice:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_WorkerTrade_HireOffice_HideAni()
  Panel_WorkerTrade_HireOffice:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_WorkerTrade_HireOffice:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local hireOffice = {
  control = {
    _closeBtn = UI.getChildControl(Panel_WorkerTrade_HireOffice, "Button_Close"),
    _questionBtn = UI.getChildControl(Panel_WorkerTrade_HireOffice, "Button_Question"),
    _haveMoney = UI.getChildControl(Panel_WorkerTrade_HireOffice, "StaticText_CoinIcon"),
    _buySlotBg = {
      [1] = UI.getChildControl(Panel_WorkerTrade_HireOffice, "Static_BuySlotBg1"),
      [2] = UI.getChildControl(Panel_WorkerTrade_HireOffice, "Static_BuySlotBg3"),
      [3] = UI.getChildControl(Panel_WorkerTrade_HireOffice, "Static_BuySlotBg2"),
      [4] = UI.getChildControl(Panel_WorkerTrade_HireOffice, "Static_BuySlotBg4"),
      [5] = UI.getChildControl(Panel_WorkerTrade_HireOffice, "Static_BuySlotBg5"),
      [6] = UI.getChildControl(Panel_WorkerTrade_HireOffice, "Static_BuySlotBg6")
    },
    _price = {},
    _btnPlus = {},
    _btnMinus = {},
    _assetCount = {},
    _btnBuy = {},
    _carriageCount = UI.getChildControl(Panel_WorkerTrade_HireOffice, "StaticText_CarriageCount"),
    _workerCount = UI.getChildControl(Panel_WorkerTrade_HireOffice, "StaticText_WorkerCount"),
    _guardCount = UI.getChildControl(Panel_WorkerTrade_HireOffice, "StaticText_GuardCount"),
    _FACount = UI.getChildControl(Panel_WorkerTrade_HireOffice, "StaticText_FACount")
  },
  _buySlotCount = 6,
  _assetPrice = {},
  _assetSetCount = {},
  _assetName = {}
}
function hireOffice:ControlInit()
  local control = self.control
  for index = 1, self._buySlotCount do
    control._price[index] = UI.getChildControl(control._buySlotBg[index], "StaticText_Price")
    control._btnPlus[index] = UI.getChildControl(control._buySlotBg[index], "Static_Plus")
    control._btnMinus[index] = UI.getChildControl(control._buySlotBg[index], "Static_Minus")
    control._assetCount[index] = UI.getChildControl(control._buySlotBg[index], "Static_Count")
    control._btnBuy[index] = UI.getChildControl(control._buySlotBg[index], "Button_Buy")
  end
end
hireOffice:ControlInit()
function hireOffice:DataInit()
  self._assetPrice = {
    [1] = ToClient_GetCarriagePrice(),
    [2] = ToClient_GetPorterPrice(),
    [3] = ToClient_GetGuardPrice(),
    [4] = ToClient_GetAmuletPrice(),
    [5] = nil,
    [6] = nil
  }
  self._assetName = {
    [1] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERTRADEHIRE_CARRIAGE"),
    [2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERTRADEHIRE_PORTER"),
    [3] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERTRADEHIRE_GUARD"),
    [4] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERTRADEHIRE_FA"),
    [5] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERTRADEHIRE_CAMEL"),
    [6] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERTRADEHIRE_SHIP")
  }
  local control = self.control
  for index = 1, self._buySlotCount do
    control._assetCount[index]:SetText("0")
    control._btnPlus[index]:addInputEvent("Mouse_LUp", "WorkerTrade_HireOffice_SetAssetCount(" .. index .. ", " .. 1 .. ")")
    control._btnMinus[index]:addInputEvent("Mouse_LUp", "WorkerTrade_HireOffice_SetAssetCount(" .. index .. ", " .. -1 .. ")")
    control._btnBuy[index]:addInputEvent("Mouse_LUp", "WorkerTrade_HireOffice_BuyAsset(" .. index .. ")")
    control._assetCount[index]:addInputEvent("Mouse_LUp", "WorkerTrade_HireOffice_SetAssetCount(" .. index .. ", " .. 0 .. ")")
    self._assetSetCount[index] = 0
  end
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  if nil == tradeCompanyWrapper then
    return
  end
  local carriageCount = tradeCompanyWrapper:getTradeCompanyCarriage()
  local porterCount = tradeCompanyWrapper:getTradeCompanyPorter()
  local guardCount = tradeCompanyWrapper:getTradeCompanyGuard()
  local amuletCount = tradeCompanyWrapper:getTradeCompanyAmulet()
  control._carriageCount:SetText(carriageCount)
  control._workerCount:SetText(porterCount)
  control._guardCount:SetText(guardCount)
  control._FACount:SetText(amuletCount)
  self:Update()
end
function hireOffice:Update()
  local control = self.control
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  if nil == tradeCompanyWrapper then
    return
  end
  local haveMoney = tradeCompanyWrapper:getTradeCompanyMoney()
  control._haveMoney:SetText(makeDotMoney(haveMoney))
  for index = 1, self._buySlotCount do
    if nil ~= self._assetPrice[index] then
      control._price[index]:SetText(makeDotMoney(self._assetPrice[index]))
    end
  end
end
function WorkerTrade_HireOffice_SetAssetCount(index, increaseCount)
  local self = hireOffice
  local control = self.control
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  if nil == tradeCompanyWrapper then
    return
  end
  local haveMoney = Int64toInt32(tradeCompanyWrapper:getTradeCompanyMoney())
  if 0 == increaseCount then
    local maxCount = tradeCompanyWrapper:getTradeCompanyMoney() / self._assetPrice[index]
    local function setAssetCount(inputNumber)
      for uiIndex = 1, self._buySlotCount do
        self._assetSetCount[uiIndex] = 0
        control._assetCount[uiIndex]:SetText(self._assetSetCount[uiIndex])
      end
      self._assetSetCount[index] = Int64toInt32(inputNumber)
      control._assetCount[index]:SetText(self._assetSetCount[index])
    end
    Panel_NumberPad_Show(true, maxCount, 0, setAssetCount)
    return
  end
  for uiIndex = 1, self._buySlotCount do
    if index == uiIndex then
      self._assetSetCount[uiIndex] = self._assetSetCount[uiIndex] + increaseCount
      self._assetSetCount[uiIndex] = math.max(0, self._assetSetCount[uiIndex])
      if haveMoney < self._assetSetCount[uiIndex] * Int64toInt32(self._assetPrice[uiIndex]) then
        self._assetSetCount[uiIndex] = self._assetSetCount[uiIndex] - 1
      end
    else
      self._assetSetCount[uiIndex] = 0
    end
    control._assetCount[uiIndex]:SetText(self._assetSetCount[uiIndex])
  end
end
function WorkerTrade_HireOffice_BuyAsset(index)
  local self = hireOffice
  local count = self._assetSetCount[index]
  if count <= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADEHIRE_ALERT"))
    return
  end
  local function sellConfirm()
    if 1 == index then
      ToClient_RequestEmployCarriage(count)
    elseif 2 == index then
      ToClient_RequestEmployPorter(count)
    elseif 3 == index then
      ToClient_RequestEmployGuard(count)
    elseif 4 == index then
      ToClient_RequestEmployAmulet(count)
    end
  end
  local assetName = self._assetName[index]
  local price = Int64toInt32(self._assetPrice[index])
  local msgTitle = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADEHIRE_MSGTITLE")
  local msgContent = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_WORKERTRADEHIRE_MSGCONTENT", "name", assetName, "count", count, "coinCount", makeDotMoney(toInt64(0, count * price)))
  local messageBoxData = {
    title = msgTitle,
    content = msgContent,
    functionYes = sellConfirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function hireOffice:Show()
  WorldMapPopupManager:increaseLayer(true)
  WorldMapPopupManager:push(Panel_WorkerTrade_HireOffice, true)
  Panel_WorkerTrade_HireOffice:SetShow(true, true)
  self:DataInit()
end
function hireOffice:Hide()
  WorldMapPopupManager:pop()
  Panel_WorkerTrade_HireOffice:SetShow(false, true)
end
function FGlobal_WorkerTradeHire_ShowToggle()
  if Panel_WorkerTrade_HireOffice:GetShow() then
    hireOffice:Hide()
  else
    hireOffice:Show()
  end
end
function FGlbal_WorkerTradeHire_Update()
  hireOffice:DataInit()
end
function hireOffice:registerEvent()
  local control = self.control
  control._closeBtn:addInputEvent("Mouse_LUp", "FGlobal_WorkerTradeHire_ShowToggle()")
  control._questionBtn:addInputEvent("Mouse_LUp", "")
  control._questionBtn:SetShow(false)
end
hireOffice:registerEvent()
