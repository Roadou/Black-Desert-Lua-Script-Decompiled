Panel_WorkerTrade:SetShow(false, false)
Panel_WorkerTrade:setGlassBackground(true)
Panel_WorkerTrade:SetDragAll(true)
Panel_WorkerTrade:RegisterShowEventFunc(true, "Panel_WorkerTrade_ShowAni()")
Panel_WorkerTrade:RegisterShowEventFunc(false, "Panel_WorkerTrade_HideAni()")
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
local isWorkerTradeContentOpen = ToClient_IsContentsGroupOpen("209")
function Panel_WorkerTrade_ShowAni()
  UIAni.fadeInSCR_Down(Panel_WorkerTrade)
  local aniInfo1 = Panel_WorkerTrade:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_WorkerTrade:GetSizeX() / 2
  aniInfo1.AxisY = Panel_WorkerTrade:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_WorkerTrade:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_WorkerTrade:GetSizeX() / 2
  aniInfo2.AxisY = Panel_WorkerTrade:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_WorkerTrade_HideAni()
  Panel_WorkerTrade:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_WorkerTrade:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local mainBg = UI.getChildControl(Panel_WorkerTrade, "Static_Bg")
local workerTrade = {
  control = {
    _btnClose = UI.getChildControl(Panel_WorkerTrade, "Button_Close"),
    _btnQuestion = UI.getChildControl(Panel_WorkerTrade, "Button_Question"),
    _caravan = {
      [1] = UI.getChildControl(mainBg, "Static_Caravan_1"),
      [2] = UI.getChildControl(mainBg, "Static_Caravan_2"),
      [3] = UI.getChildControl(mainBg, "Static_Caravan_3"),
      [4] = UI.getChildControl(mainBg, "Static_Caravan_4"),
      [5] = UI.getChildControl(mainBg, "Static_Caravan_5")
    },
    _caravanImage = {},
    _treasureBox = UI.getChildControl(mainBg, "Static_TreasureBox"),
    _tradeOffice = UI.getChildControl(mainBg, "Static_TradeOffice"),
    _hireAsset = UI.getChildControl(mainBg, "Static_HireOffice"),
    _tradeManager = UI.getChildControl(mainBg, "Static_TradeManagement"),
    _coin = UI.getChildControl(Panel_WorkerTrade, "StaticText_CoinIcon")
  },
  _caravanMaxCount = 5,
  _caravanImagePath = "New_UI_Common_forLua/Window/Trade/WorkerTrade_02.dds"
}
function workerTrade:ControlInit()
  local control = self.control
  for index = 1, self._caravanMaxCount do
    control._caravanImage[index] = UI.getChildControl(control._caravan[index], "StaticText_CarriageImage")
  end
end
workerTrade:ControlInit()
function workerTrade:update()
  local control = self.control
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local caravanCount = tradeCompanyWrapper:getGroupCount()
  local coinCount = tradeCompanyWrapper:getTradeCompanyMoney()
  control._coin:SetText(makeDotMoney(coinCount))
  for index = 1, self._caravanMaxCount do
    WorkerTrade_CaravanCheck(index)
  end
end
function FGlobal_WorkerTrade_Update()
  workerTrade:update()
end
function WorkerTrade_Close()
  Panel_WorkerTrade:SetShow(false, false)
  WorldMapPopupManager:pop()
end
function WorkerTrade_CaravanCheck(index)
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local caravanCount = tradeCompanyWrapper:getGroupCount()
  local tradeGroupWrapper = tradeCompanyWrapper:getGroup(index - 1)
  if nil ~= tradeGroupWrapper then
    local state = tradeGroupWrapper:getState()
    if 4 == state then
      WorkerTrade_CaravanImageChange(0, index)
    else
      WorkerTrade_CaravanImageChange(1, index)
    end
  elseif index < 4 then
    WorkerTrade_CaravanImageChange(2, index)
  else
    WorkerTrade_CaravanImageChange(3, index)
  end
end
function WorkerTrade_CaravanImageChange(index, uiIndex)
  local self = workerTrade
  local control = self.control
  local x1, y1, x2, y2
  control._caravanImage[uiIndex]:ChangeTextureInfoName(self._caravanImagePath)
  if 0 == index then
    x1, y1, x2, y2 = setTextureUV_Func(control._caravanImage[uiIndex], 86, 107, 170, 150)
    control._caravanImage[uiIndex]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADEMAIN_WAIT"))
    control._caravan[uiIndex]:addInputEvent("Mouse_LUp", "FGlobal_WorkerTradeCaraven_Open(" .. uiIndex .. ")")
  elseif 1 == index then
    x1, y1, x2, y2 = setTextureUV_Func(control._caravanImage[uiIndex], 1, 107, 85, 150)
    control._caravanImage[uiIndex]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADEMAIN_TRADE"))
    control._caravan[uiIndex]:addInputEvent("Mouse_LUp", "")
  elseif 2 == index then
    x1, y1, x2, y2 = setTextureUV_Func(control._caravanImage[uiIndex], 171, 107, 255, 150)
    control._caravanImage[uiIndex]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADEMAIN_NOCONTRACT"))
    control._caravan[uiIndex]:addInputEvent("Mouse_LUp", "WorkerTrade_CreateCaravan()")
  elseif 3 == index then
    x1, y1, x2, y2 = setTextureUV_Func(control._caravanImage[uiIndex], 86, 107, 170, 150)
    control._caravanImage[uiIndex]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADEMAIN_DISABLECONTRACT"))
    control._caravan[uiIndex]:addInputEvent("Mouse_LUp", "")
    control._caravanImage[uiIndex]:SetMonoTone(true)
  end
  control._caravanImage[uiIndex]:getBaseTexture():setUV(x1, y1, x2, y2)
  control._caravanImage[uiIndex]:setRenderTexture(control._caravanImage[uiIndex]:getBaseTexture())
end
function WorkerTrade_CreateCaravan()
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local caravanCount = tradeCompanyWrapper:getGroupCount()
  local createIndex = caravanCount
  local function requestCreateCaravan()
    ToClient_RequestCreateTradeGroup(createIndex)
  end
  local msgTitle = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADEMAIN_MSGTITLE")
  local needCoin = ToClient_GetTradeGroupCreatePrice()
  local msgContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADEMAIN_MSGCONTENT", "coin", tostring(needCoin))
  messageBoxData = {
    title = msgTitle,
    content = msgContent,
    functionYes = requestCreateCaravan,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function workerTrade:registerEvent()
  local control = self.control
  control._btnClose:addInputEvent("Mouse_LUp", "WorkerTrade_Close()")
  control._btnQuestion:addInputEvent("Mouse_LUp", "")
  control._btnQuestion:SetShow(false)
  control._treasureBox:addInputEvent("Mouse_LUp", "FGlobal_WorkerTradeTreasure_ShowToggle()")
  control._tradeOffice:addInputEvent("Mouse_LUp", "FGlobal_WorkerTradeOffice_ShowToggle()")
  control._hireAsset:addInputEvent("Mouse_LUp", "FGlobal_WorkerTradeHire_ShowToggle()")
  control._tradeManager:addInputEvent("Mouse_LUp", "")
  control._coin:addInputEvent("Mouse_LUp", "FGlobal_WorkerTradeCoinChange_ShowToggle()")
end
workerTrade:registerEvent()
