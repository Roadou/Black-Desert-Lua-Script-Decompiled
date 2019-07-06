Panel_Dialog_WorkerTrade_Renew:SetShow(false)
local workerTrade = {
  _ui = {
    _static_BG = UI.getChildControl(Panel_Dialog_WorkerTrade_Renew, "Static_BG"),
    _static_Skill_List_BG = UI.getChildControl(Panel_Dialog_WorkerTrade_Renew, "Static_Skill_List_BG")
  },
  _config = {
    _pageSlotCount = 4,
    _skillInfoCount = 7,
    _slotPos = {
      _startX = 8,
      _startY = 5,
      _gapY = 8
    },
    _Tab = {
      _marketWorkerList = 0,
      _myRegistedWorkerList = 1,
      _myWorkerList = 2,
      _tabCount = 3
    },
    _workerAuctionChargePercent = 30,
    _keyGuideIconPath = "renewal/ui_icon/console_xboxkey_00.dds",
    _disabledColor = 4287862695,
    _activeColor = 4293848814,
    _workerIconRadius = 50,
    _workerIconX = 34,
    _workerIconY = 42,
    _workerBuyTextX = 0,
    _workerBuyTextY = 40
  },
  _selectedTab = 0,
  _selectedWorker = -1,
  _currentPage = 1,
  _maxPage = 1,
  _plantKey = 0,
  _workerAuction = nil,
  defaultTitleSizeX = 250,
  defaultSlotSizeX = 353,
  defaultDescSizeX = 250,
  defaultListBgSizeX = 353,
  addSlotSizeX = 0
}
function workerTrade:initialize()
  workerTrade:initControl()
  workerTrade:createControl()
end
function workerTrade:initControl()
  local workerTradeUI = self._ui
  workerTradeUI._static_Inner_BG = UI.getChildControl(workerTradeUI._static_BG, "Static_Inner_BG")
  workerTradeUI._static_Inner_BG2 = UI.getChildControl(workerTradeUI._static_BG, "Static_Inner_BG2")
  workerTradeUI._static_Tap_Group = UI.getChildControl(workerTradeUI._static_Inner_BG, "Static_Tap_Group")
  workerTradeUI._radioButton_Market = UI.getChildControl(workerTradeUI._static_Tap_Group, "RadioButton_Market")
  workerTradeUI._radioButton_My = UI.getChildControl(workerTradeUI._static_Tap_Group, "RadioButton_My")
  workerTradeUI._radioButton_Regi = UI.getChildControl(workerTradeUI._static_Tap_Group, "RadioButton_Regi")
  workerTradeUI._static_Key_Guide = UI.getChildControl(workerTradeUI._static_Inner_BG, "Static_Key_Guide")
  workerTradeUI._staticText_Page_Text = UI.getChildControl(workerTradeUI._static_Key_Guide, "StaticText_Page_Text")
  workerTradeUI._button_Silver_Inventory = UI.getChildControl(workerTradeUI._static_Inner_BG2, "Button_Silver_Inventory")
  workerTradeUI._button_Silver_Inventory:addInputEvent("Mouse_On", "WorkerTrade_CloseWorkerSkillToolTip()")
  workerTradeUI._button_Silver_Inventory:addInputEvent("Mouse_LUp", "WorkerTrade_ClickOnMoneyWhereType(true)")
  workerTradeUI._staticText_Silver_Inventory = UI.getChildControl(workerTradeUI._button_Silver_Inventory, "StaticText_Silver")
  workerTradeUI._chk_Silver_Inventory = UI.getChildControl(workerTradeUI._button_Silver_Inventory, "CheckButton_1")
  workerTradeUI._button_Silver_Storage = UI.getChildControl(workerTradeUI._static_Inner_BG2, "Button_Silver_Storage")
  workerTradeUI._button_Silver_Storage:addInputEvent("Mouse_On", "WorkerTrade_CloseWorkerSkillToolTip()")
  workerTradeUI._button_Silver_Storage:addInputEvent("Mouse_LUp", "WorkerTrade_ClickOnMoneyWhereType(false)")
  workerTradeUI._staticText_Silver_Storage = UI.getChildControl(workerTradeUI._button_Silver_Storage, "StaticText_Silver")
  workerTradeUI._chk_Silver_Storage = UI.getChildControl(workerTradeUI._button_Silver_Storage, "CheckButton_1")
  workerTradeUI._static_WorkerSlotBg = UI.getChildControl(workerTradeUI._static_Inner_BG, "Static_WorkerSlotBg")
  workerTradeUI._static_Key_GuideBtn_Group = UI.getChildControl(workerTradeUI._static_BG, "Static_Key_Guide")
  workerTradeUI._static_KeyGuide_B = UI.getChildControl(workerTradeUI._static_Key_GuideBtn_Group, "StaticText_Close_ConsoleUI")
  local tempBtnGroup = {
    workerTradeUI._static_KeyGuide_B
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, workerTradeUI._static_Key_GuideBtn_Group, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  workerTradeUI._radioButton_BG = UI.getChildControl(workerTradeUI._static_WorkerSlotBg, "RadioButton_BG")
  workerTradeUI._radioButton_BG:SetShow(false)
  workerTradeUI._static_SkillInfo = UI.getChildControl(workerTradeUI._static_Skill_List_BG, "Static_SkillInfo")
  workerTradeUI._static_Inner_BG:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "WorkerTrade_ChangePage(-1)")
  workerTradeUI._static_Inner_BG:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "WorkerTrade_ChangePage(1)")
  Panel_Dialog_WorkerTrade_Renew:registerPadEvent(__eConsoleUIPadEvent_LT, "WorkerTrade_ChangeTab(-1)")
  Panel_Dialog_WorkerTrade_Renew:registerPadEvent(__eConsoleUIPadEvent_RT, "WorkerTrade_ChangeTab(1)")
end
function workerTrade:createControl()
  self._ui._workerInfo = {}
  self._ui._skillInfo = {}
  for index = 0, self._config._pageSlotCount - 1 do
    local info = {}
    info._slot = UI.cloneControl(self._ui._radioButton_BG, self._ui._static_WorkerSlotBg, "WorkerSlot_" .. index)
    info._static_Image = UI.getChildControl(info._slot, "Static_Image")
    info._staticText_Name = UI.getChildControl(info._slot, "StaticText_Name")
    info._staticText_Upgrade = UI.getChildControl(info._slot, "StaticText_Upgrade")
    info._staticText_Work_Speed_Val = UI.getChildControl(info._slot, "StaticText_Work_Speed_Val")
    info._staticText_Luck_Val = UI.getChildControl(info._slot, "StaticText_Luck_Val")
    info._staticText_Move_Speed_Val = UI.getChildControl(info._slot, "StaticText_Move_Speed_Val")
    info._staticText_Amount_Val = UI.getChildControl(info._slot, "StaticText_Amount_Val")
    info._staticText_Price = UI.getChildControl(info._slot, "StaticText_Price")
    info._static_Silver_Icon = UI.getChildControl(info._slot, "Static_Silver_Icon")
    info._staticText_Buy_ConsoleUI = UI.getChildControl(info._slot, "StaticText_Buy_ConsoleUI")
    info._slot:SetPosX(self._config._slotPos._startX)
    info._slot:SetPosY(self._config._slotPos._startY + (info._slot:GetSizeY() + self._config._slotPos._gapY) * index)
    info._slot:SetShow(false)
    self._ui._workerInfo[index] = info
  end
  for index = 0, self._config._skillInfoCount - 1 do
    local skill = {}
    skill._slot = UI.cloneControl(self._ui._static_SkillInfo, self._ui._static_Skill_List_BG, "Skill_Slot_" .. index)
    skill._static_SkillIcon = UI.getChildControl(skill._slot, "Static_SkillIcon")
    skill._staticText_SkillName = UI.getChildControl(skill._slot, "StaticText_SkillName")
    skill._staticText_SkillDesc = UI.getChildControl(skill._slot, "StaticText_SkillDesc")
    skill._slot:SetPosX(0)
    skill._slot:SetPosY(skill._slot:GetSizeY() * index)
    skill._slot:SetShow(true)
    self._ui._skillInfo[index] = skill
  end
end
function workerTrade:resetPageData()
  self._selectedTab = self._config._Tab._marketWorkerList
  self._selectedWorker = -1
  self._currentPage = 1
end
function workerTrade:resetData()
  self._maxPage = 1
  self._currentPage = 1
  self._plantKey = nil
  self._workerAuction = nil
  self._ui._chk_Silver_Inventory:SetCheck(true)
  self._ui._chk_Silver_Storage:SetCheck(false)
  workerTrade:resetPageData()
end
function workerTrade:setPlayerData()
  self._plantKey = ToClient_convertWaypointKeyToPlantKey(getCurrentWaypointKey())
  self._workerAuction = RequestGetAuctionInfo()
end
function workerTrade:update()
  local tabIndex = self._selectedTab
  local workerTradeUI = self._ui
  workerTradeUI._radioButton_Regi:SetCheck(false)
  workerTradeUI._radioButton_Regi:SetFontColor(self._config._disabledColor)
  workerTradeUI._radioButton_My:SetCheck(false)
  workerTradeUI._radioButton_My:SetFontColor(self._config._disabledColor)
  workerTradeUI._radioButton_Market:SetCheck(false)
  workerTradeUI._radioButton_Market:SetFontColor(self._config._disabledColor)
  local contents = self._ui._workerInfo
  for index = 0, self._config._pageSlotCount - 1 do
    contents[index]._slot:SetShow(false)
    contents[index]._slot:addInputEvent("Mouse_LUp", "")
    contents[index]._slot:addInputEvent("Mouse_On", "")
    contents[index]._slot:SetCheck(false)
  end
  if self._config._Tab._marketWorkerList == tabIndex then
    workerTrade:updateMarketWorkerList()
    workerTradeUI._radioButton_Market:SetCheck(true)
    workerTradeUI._radioButton_Market:SetFontColor(self._config._activeColor)
  elseif self._config._Tab._myRegistedWorkerList == tabIndex then
    workerTrade:updateMyRegistedWorkerList()
    workerTradeUI._radioButton_My:SetCheck(true)
    workerTradeUI._radioButton_My:SetFontColor(self._config._activeColor)
  else
    workerTrade:updateMyWorkerList()
    workerTradeUI._radioButton_Regi:SetCheck(true)
    workerTradeUI._radioButton_Regi:SetFontColor(self._config._activeColor)
  end
  workerTrade:updateMoney()
  workerTradeUI._staticText_Page_Text:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLE_MARKET_PAGE", "page", self._currentPage))
end
function PaGlobalFunc_GetWorkEfficiency(workerWrapperLua)
  local _tempWorkEfficiency = 0
  if _tempWorkEfficiency < workerWrapperLua:getWorkEfficiency(2) then
    _tempWorkEfficiency = workerWrapperLua:getWorkEfficiency(2)
  end
  if _tempWorkEfficiency < workerWrapperLua:getWorkEfficiency(5) then
    _tempWorkEfficiency = workerWrapperLua:getWorkEfficiency(5)
  end
  if _tempWorkEfficiency < workerWrapperLua:getWorkEfficiency(6) then
    _tempWorkEfficiency = workerWrapperLua:getWorkEfficiency(6)
  end
  if _tempWorkEfficiency < workerWrapperLua:getWorkEfficiency(8) then
    _tempWorkEfficiency = workerWrapperLua:getWorkEfficiency(8)
  end
  return _tempWorkEfficiency
end
function workerTrade:updateMarketWorkerList()
  local auctionInfo = self._workerAuction
  local listCount = auctionInfo:getWorkerAuctionCount()
  if listCount <= 0 then
    self:closeWorkerSkillToolTip()
    return
  end
  local uiIndex = 0
  local contents = self._ui._workerInfo
  for index = 0, self._config._pageSlotCount - 1 do
    if index >= listCount then
      break
    end
    if uiIndex >= self._config._pageSlotCount then
      break
    end
    local workerNoRaw = auctionInfo:getWorkerAuction(index)
    local workerWrapperLua = getWorkerWrapperByAuction(workerNoRaw, true)
    if nil ~= workerWrapperLua then
      local workerIcon = workerWrapperLua:getWorkerIcon()
      local defaultSkill = workerWrapperLua:getWorkerDefaultSkillStaticStatus()
      local workerName = workerWrapperLua:getGradeToColorString() .. workerWrapperLua:getName() .. "<PAOldColor>"
      local workerTown = ToClient_GetNodeNameByWaypointKey(workerWrapperLua:getHomeWaypoint())
      local workerLv = workerWrapperLua:getLevel()
      local workerUpgradeCount = workerWrapperLua:getUpgradePoint()
      local workerMinPrice = workerWrapperLua:getWorkerMinPrice()
      local workerMaxPrice = workerWrapperLua:getWorkerMaxPrice()
      local actionPoint = workerWrapperLua:getMaxActionPoint()
      local _tempWorkEfficiency = PaGlobalFunc_GetWorkEfficiency(workerWrapperLua)
      local info = contents[uiIndex]
      local uiScale = ToClient_getGameOptionControllerWrapper():getUIScale()
      local radius = info._static_Image:GetSizeX() * 0.5 * uiScale
      local posX = info._static_Image:GetPosX() + radius * 0.81 / uiScale
      local posY = info._static_Image:GetPosY() + radius * 0.85 / uiScale
      info._static_Image:ChangeTextureInfoName(workerIcon)
      info._static_Image:SetCircularClip(radius, float2(posX, posY))
      info._staticText_Name:SetText(workerName .. "<PAColor0xff68666f> (" .. workerTown .. ")<PAOldColor>")
      if 4 <= workerWrapperLua:getGrade() then
        info._staticText_Upgrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_CANNOTUPGRADE"))
        info._staticText_Upgrade:SetFontColor(self._config._disabledColor)
      else
        info._staticText_Upgrade:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_UPGRADECOUNT", "upgradecount", workerUpgradeCount))
        info._staticText_Upgrade:SetFontColor(self._config._activeColor)
      end
      info._staticText_Work_Speed_Val:SetText(string.format("%.2f", tostring(_tempWorkEfficiency / 1000000)))
      info._staticText_Luck_Val:SetText(string.format("%.2f", workerWrapperLua:getLuck() / 10000))
      info._staticText_Move_Speed_Val:SetText(string.format("%.2f", workerWrapperLua:getMoveSpeed() / 100))
      info._staticText_Amount_Val:SetText(actionPoint)
      info._staticText_Price:SetText(makeDotMoney(workerMaxPrice))
      info._staticText_Buy_ConsoleUI:SetFontColor(self._config._activeColor)
      info._staticText_Buy_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERRANDOMSELECT_BTN_WORKERSELECT"))
      info._staticText_Buy_ConsoleUI:SetSpanSize(info._staticText_Buy_ConsoleUI:GetSizeX() + info._staticText_Buy_ConsoleUI:GetTextSizeX() - 16, 0)
      info._staticText_Buy_ConsoleUI:ChangeTextureInfoName(self._config._keyGuideIconPath)
      info._staticText_Buy_ConsoleUI:setRenderTexture(info._staticText_Buy_ConsoleUI:getBaseTexture())
      info._slot:SetShow(true)
      info._slot:addInputEvent("Mouse_LUp", "WorkerTrade_BuyWorker(" .. index .. ")")
      info._slot:addInputEvent("Mouse_On", "WorkerTrade_OpenWorkerSkillToolTip(" .. index .. ")")
      uiIndex = uiIndex + 1
    end
  end
end
function workerTrade:updateMyRegistedWorkerList()
  local auctionInfo = self._workerAuction
  local listCount = auctionInfo:getWorkerAuctionCount()
  if listCount <= 0 then
    self:closeWorkerSkillToolTip()
    return
  end
  self._maxPage = math.floor(listCount / self._config._pageSlotCount)
  if 0 ~= listCount % self._config._pageSlotCount then
    self._maxPage = self._maxPage + 1
  end
  local startWorkerDataIndex = (self._currentPage - 1) * self._config._pageSlotCount
  if listCount <= startWorkerDataIndex then
    self._currentPage = 1
    startWorkerDataIndex = 0
  end
  local uiIndex = 0
  local contents = self._ui._workerInfo
  for index = startWorkerDataIndex, startWorkerDataIndex + self._config._pageSlotCount - 1 do
    if index >= listCount then
      break
    end
    if uiIndex >= self._config._pageSlotCount then
      break
    end
    local workerNoRaw = auctionInfo:getWorkerAuction(index)
    local workerWrapperLua = getWorkerWrapperByAuction(workerNoRaw, true)
    if nil ~= workerWrapperLua then
      local workerIcon = workerWrapperLua:getWorkerIcon()
      local defaultSkill = workerWrapperLua:getWorkerDefaultSkillStaticStatus()
      local workerName = workerWrapperLua:getGradeToColorString() .. workerWrapperLua:getName() .. "<PAOldColor>"
      local workerTown = ToClient_GetNodeNameByWaypointKey(workerWrapperLua:getHomeWaypoint())
      local workerLv = workerWrapperLua:getLevel()
      local workerUpgradeCount = workerWrapperLua:getUpgradePoint()
      local workerMinPrice = workerWrapperLua:getWorkerMinPrice()
      local workerMaxPrice = workerWrapperLua:getWorkerMaxPrice()
      local actionPoint = workerWrapperLua:getMaxActionPoint()
      local _tempWorkEfficiency = PaGlobalFunc_GetWorkEfficiency(workerWrapperLua)
      local info = contents[uiIndex]
      local uiScale = ToClient_getGameOptionControllerWrapper():getUIScale()
      local radius = info._static_Image:GetSizeX() * 0.5 * uiScale
      local posX = info._static_Image:GetPosX() + radius * 0.81 / uiScale
      local posY = info._static_Image:GetPosY() + radius * 0.85 / uiScale
      info._static_Image:ChangeTextureInfoName(workerIcon)
      info._static_Image:SetCircularClip(radius, float2(posX, posY))
      info._staticText_Name:SetText(workerName .. "<PAColor0xff68666f> (" .. workerTown .. ")<PAOldColor>")
      info._staticText_Upgrade:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_UPGRADECOUNT", "upgradecount", workerUpgradeCount))
      info._staticText_Work_Speed_Val:SetText(string.format("%.2f", tostring(_tempWorkEfficiency / 1000000)))
      info._staticText_Luck_Val:SetText(string.format("%.2f", workerWrapperLua:getLuck() / 10000))
      info._staticText_Move_Speed_Val:SetText(string.format("%.2f", workerWrapperLua:getMoveSpeed() / 100))
      info._staticText_Amount_Val:SetText(actionPoint)
      info._staticText_Price:SetText(makeDotMoney(workerMaxPrice))
      info._staticText_Buy_ConsoleUI:SetFontColor(self._config._activeColor)
      info._staticText_Buy_ConsoleUI:ChangeTextureInfoName(self._config._keyGuideIconPath)
      info._staticText_Buy_ConsoleUI:setRenderTexture(info._staticText_Buy_ConsoleUI:getBaseTexture())
      local isEndAuction = auctionInfo:getWorkerAuctionEnd(workerNoRaw)
      if true == isEndAuction then
        info._staticText_Buy_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERAUCTION_WORKERGETPRICE"))
        info._slot:addInputEvent("Mouse_LUp", "WorkerTrade_GetPrice(" .. index .. ")")
      else
        info._staticText_Buy_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKETSET_REGISTCANCLE_BTN"))
        info._slot:addInputEvent("Mouse_LUp", "WorkerTrade_RegistCancle(" .. index .. ")")
      end
      info._staticText_Buy_ConsoleUI:SetSpanSize(info._staticText_Buy_ConsoleUI:GetSizeX() + info._staticText_Buy_ConsoleUI:GetTextSizeX() - 16, 0)
      info._slot:addInputEvent("Mouse_On", "WorkerTrade_OpenWorkerSkillToolTip(" .. index .. ")")
      info._slot:SetShow(true)
      uiIndex = uiIndex + 1
    end
  end
end
function workerTrade:updateMyWorkerList()
  if nil == self._plantKey then
    return
  end
  local listCount = ToClient_getPlantWaitWorkerListCount(self._plantKey, 0)
  if listCount <= 0 then
    self:closeWorkerSkillToolTip()
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_NOWORKER"))
    return
  end
  self._maxPage = math.floor(listCount / self._config._pageSlotCount)
  if 0 ~= listCount % self._config._pageSlotCount then
    self._maxPage = self._maxPage + 1
  end
  local startWorkerDataIndex = (self._currentPage - 1) * self._config._pageSlotCount
  if listCount <= startWorkerDataIndex then
    self._currentPage = 1
    startWorkerDataIndex = 0
  end
  local uiIndex = 0
  local contents = self._ui._workerInfo
  for index = startWorkerDataIndex, startWorkerDataIndex + self._config._pageSlotCount - 1 do
    if listCount <= index then
      break
    end
    if uiIndex >= self._config._pageSlotCount then
      break
    end
    local workerNoRaw = ToClient_getPlantWaitWorkerNoRawByIndex(self._plantKey, index)
    local workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
    if nil ~= workerWrapperLua then
      local workerIcon = workerWrapperLua:getWorkerIcon()
      local defaultSkill = workerWrapperLua:getWorkerDefaultSkillStaticStatus()
      local workerName = workerWrapperLua:getGradeToColorString() .. workerWrapperLua:getName() .. "<PAOldColor>"
      local workerTown = ToClient_GetNodeNameByWaypointKey(workerWrapperLua:getHomeWaypoint())
      local workerLv = workerWrapperLua:getLevel()
      local workerUpgradeCount = workerWrapperLua:getUpgradePoint()
      local actionPoint = workerWrapperLua:getActionPoint()
      local workerMaxPrice = workerWrapperLua:getWorkerMaxPrice()
      local _tempWorkEfficiency = PaGlobalFunc_GetWorkEfficiency(workerWrapperLua)
      local info = contents[uiIndex]
      info._static_Image:ChangeTextureInfoName(workerIcon)
      local uiScale = ToClient_getGameOptionControllerWrapper():getUIScale()
      local radius = info._static_Image:GetSizeX() * 0.5 * uiScale
      local posX = info._static_Image:GetPosX() + radius * 0.81 / uiScale
      local posY = info._static_Image:GetPosY() + radius * 0.85 / uiScale
      info._static_Image:SetCircularClip(radius, float2(posX, posY))
      info._staticText_Name:SetText(workerName .. "<PAColor0xff68666f> (" .. workerTown .. ")<PAOldColor>")
      info._staticText_Upgrade:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_UPGRADECOUNT", "upgradecount", workerUpgradeCount))
      info._staticText_Work_Speed_Val:SetText(string.format("%.2f", tostring(_tempWorkEfficiency / 1000000)))
      info._staticText_Luck_Val:SetText(string.format("%.2f", workerWrapperLua:getLuck() / 10000))
      info._staticText_Move_Speed_Val:SetText(string.format("%.2f", workerWrapperLua:getMoveSpeed() / 100))
      info._staticText_Amount_Val:SetText(actionPoint)
      info._staticText_Buy_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERAUCTION_WORKERRESIST_BTN"))
      info._staticText_Price:SetText(makeDotMoney(workerMaxPrice))
      info._staticText_Buy_ConsoleUI:ChangeTextureInfoName("")
      info._staticText_Buy_ConsoleUI:SetFontColor(self._config._disabledColor)
      if true == workerWrapperLua:getIsAuctionInsert() then
        info._staticText_Buy_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_REGISTINGNOW"))
      elseif true == workerWrapperLua:isWorking() then
        info._staticText_Buy_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_WORKINGNOW"))
      elseif workerWrapperLua:getActionPoint() ~= workerWrapperLua:getMaxActionPoint() then
        info._staticText_Buy_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_WORKERTRADE_RENEW_WORKER_LACK"))
      elseif workerWrapperLua:getGrade() < 2 then
        info._staticText_Buy_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_WORKERTRADE_RENEW_GRADE_LACK"))
      elseif workerWrapperLua:getWorkerDefaultSkillStaticStatus() then
        info._staticText_Buy_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_CANNOT_REGIST"))
      else
        info._staticText_Buy_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERAUCTION_WORKERRESIST_BTN"))
        info._staticText_Buy_ConsoleUI:ChangeTextureInfoName(self._config._keyGuideIconPath)
        info._staticText_Buy_ConsoleUI:setRenderTexture(info._staticText_Buy_ConsoleUI:getBaseTexture())
        info._slot:addInputEvent("Mouse_LUp", "WorkerTrade_RegistWorkerToMarket(" .. index .. ")")
        info._staticText_Buy_ConsoleUI:SetFontColor(self._config._activeColor)
      end
      info._staticText_Buy_ConsoleUI:SetSpanSize(info._staticText_Buy_ConsoleUI:GetSizeX() + info._staticText_Buy_ConsoleUI:GetTextSizeX() - 16, 0)
      info._slot:SetShow(true)
      info._slot:addInputEvent("Mouse_On", "WorkerTrade_OpenWorkerSkillToolTip(" .. index .. ")")
      uiIndex = uiIndex + 1
    end
  end
end
function workerTrade:buyWorker(workerIndex)
  self._selectedWorker = workerIndex
  local auctionInfo = self._workerAuction
  local workerNoRaw = auctionInfo:getWorkerAuction(self._selectedWorker)
  local workerWrapper = getWorkerWrapperByAuction(workerNoRaw, true)
  local workerLv = workerWrapper:getLevel()
  local workerName = workerWrapper:getGradeToColorString() .. workerWrapper:getName()
  local workerPrice = auctionInfo:getWorkerAuctionPrice(workerNoRaw)
  local function WorkerAuction_BuyXXX()
    PaGlobalFunc_WorkerTrade_TemporaryOpen()
    local fromWhereType = CppEnums.ItemWhereType.eInventory
    if self._ui._chk_Silver_Storage:IsCheck() then
      fromWhereType = CppEnums.ItemWhereType.eWarehouse
    end
    local workerNoRaw = self._workerAuction:getWorkerAuction(self._selectedWorker)
    self._workerAuction:requestBuyItNowWorker(workerNoRaw, fromWhereType)
  end
  PaGlobalFunc_WorkerTrade_TemporaryClose()
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYCONFIRM")
  local contentString = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYCONFIRM_TITLE", "level", tostring(workerLv), "name", workerName, "price", makeDotMoney(workerPrice)) .. "<PAOldColor>"
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = WorkerAuction_BuyXXX,
    functionCancel = PaGlobalFunc_WorkerTrade_TemporaryOpen,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function workerTrade:getPrice(workerIndex)
  local auctionInfo = self._workerAuction
  local workerNoRaw = auctionInfo:getWorkerAuction(workerIndex)
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  if self._ui._chk_Silver_Storage:IsCheck() then
    fromWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  auctionInfo:requestPopWorkerPrice(workerNoRaw, fromWhereType)
end
function workerTrade:registCancle(workerIndex)
  self._selectedWorker = workerIndex
  local auctionInfo = self._workerAuction
  local function WorkerAuction_CancelXXX()
    PaGlobalFunc_WorkerTrade_TemporaryOpen()
    local workerNoRaw = self._workerAuction:getWorkerAuction(self._selectedWorker)
    ToClient_requestCancelRegisterMyWorkerAuction(workerNoRaw)
  end
  local workerNoRaw = auctionInfo:getWorkerAuction(workerIndex)
  local workerWrapper = getWorkerWrapperByAuction(workerNoRaw, true)
  local workerLv = workerWrapper:getLevel()
  local workerName = workerWrapper:getGradeToColorString() .. workerWrapper:getName()
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_CANCELCONFIRM")
  local contentString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_CANCELCONFIRM_TITLE", "level", workerLv, "name", workerName) .. "<PAOldColor>"
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = WorkerAuction_CancelXXX,
    functionCancel = PaGlobalFunc_WorkerTrade_TemporaryOpen,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  PaGlobalFunc_WorkerTrade_TemporaryClose()
  MessageBox.showMessageBox(messageboxData)
end
function workerTrade:closeWorkerSkillToolTip()
  if false == self._ui._static_Skill_List_BG:GetShow() then
    return
  end
  self._ui._static_Skill_List_BG:SetShow(false)
end
function workerTrade:openWorkerSkillToolTip(workerIndex)
  local auctionInfo = self._workerAuction
  if false == self._ui._static_Skill_List_BG:GetShow() then
    self._ui._static_Skill_List_BG:SetShow(true)
  end
  local workerNoRaw, workerWrapper
  if self._selectedTab == self._config._Tab._myWorkerList then
    workerNoRaw = ToClient_getPlantWaitWorkerNoRawByIndex(self._plantKey, workerIndex)
    workerWrapper = getWorkerWrapper(workerNoRaw, false)
  else
    workerNoRaw = auctionInfo:getWorkerAuction(workerIndex)
    workerWrapper = getWorkerWrapperByAuction(workerNoRaw, true)
  end
  if nil == workerWrapper then
    return
  end
  for index = 0, self._config._skillInfoCount - 1 do
    self._ui._skillInfo[index]._slot:SetShow(false)
  end
  self.addSlotSizeX = 0
  workerWrapper:foreachSkillList(function(skillIdx, skillStaticStatusWrapper)
    if nil == self._ui._skillInfo[skillIdx] then
      return true
    end
    self:setSkillInfoToSlot(skillIdx, skillStaticStatusWrapper)
    return false
  end)
  workerWrapper:foreachSkillList(function(skillIdx, skillStaticStatusWrapper)
    if nil == self._ui._skillInfo[skillIdx] then
      return true
    end
    self:setSkillSizeToSlot(skillIdx)
    return false
  end)
  local count = workerWrapper:getSkillCount()
  self._ui._static_Skill_List_BG:SetSize(self.defaultListBgSizeX + self.addSlotSizeX, self._ui._skillInfo[count - 1]._slot:GetPosY() + self._ui._skillInfo[count - 1]._slot:GetSizeY() - self._ui._skillInfo[0]._slot:GetPosY())
  local tempPosY = self._ui._static_Skill_List_BG:GetSizeY() + (Panel_Dialog_WorkerTrade_Renew:GetPosY() + 150)
  local screenGapSizeY = (getOriginScreenSizeY() - getScreenSizeY()) / 2
  if tempPosY > getScreenSizeY() + screenGapSizeY then
    self._ui._static_Skill_List_BG:SetPosY(getScreenSizeY() - tempPosY + 130 + screenGapSizeY)
  else
    self._ui._static_Skill_List_BG:SetPosY(150)
  end
end
function workerTrade:setSkillSizeToSlot(skillIdx)
  local skill = self._ui._skillInfo[skillIdx]
  if nil == skill then
    return
  end
  local tempSizeX = self.addSlotSizeX
  skill._staticText_SkillName:SetSize(self.defaultTitleSizeX + tempSizeX, skill._staticText_SkillName:GetSizeY())
  skill._staticText_SkillDesc:SetSize(self.defaultDescSizeX + tempSizeX, skill._staticText_SkillDesc:GetSizeY())
  skill._staticText_SkillName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  skill._staticText_SkillName:SetText(skill._staticText_SkillName:GetText())
  skill._staticText_SkillDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  skill._staticText_SkillDesc:SetPosY(skill._staticText_SkillName:GetPosY() + skill._staticText_SkillName:GetTextSizeY())
  skill._staticText_SkillDesc:SetAutoResize(true)
  skill._staticText_SkillDesc:SetText(skill._staticText_SkillDesc:GetText())
  skill._slot:SetSize(self.defaultSlotSizeX + tempSizeX, skill._staticText_SkillDesc:GetTextSizeY() + skill._staticText_SkillName:GetTextSizeY() + 50)
  if skillIdx >= 1 and nil ~= self._ui._skillInfo[skillIdx - 1] then
    skill._slot:SetPosY(self._ui._skillInfo[skillIdx - 1]._slot:GetPosY() + self._ui._skillInfo[skillIdx - 1]._slot:GetSizeY())
  end
end
function workerTrade:setSkillInfoToSlot(skillIdx, skillStaticStatusWrapper)
  if nil == skillStaticStatusWrapper then
    return
  end
  local skill = self._ui._skillInfo[skillIdx]
  if nil == skill then
    return
  end
  skill._staticText_SkillDesc:SetTextMode(CppEnums.TextMode.eTextMode_None)
  skill._staticText_SkillDesc:SetText(skillStaticStatusWrapper:getDescription())
  local tempSizeX = 0
  if skill._staticText_SkillDesc:GetTextSizeX() > self.defaultDescSizeX * 2.8 - 18 then
    tempSizeX = (skill._staticText_SkillDesc:GetTextSizeX() - self.defaultDescSizeX) / 3
    if tempSizeX > 150 then
      tempSizeX = 150
    end
    if tempSizeX > self.addSlotSizeX then
      self.addSlotSizeX = tempSizeX
    end
  end
  skill._slot:SetShow(true)
  skill._static_SkillIcon:ChangeTextureInfoName(skillStaticStatusWrapper:getIconPath())
  skill._staticText_SkillName:SetText(skillStaticStatusWrapper:getName())
  skill._staticText_SkillDesc:SetText(skillStaticStatusWrapper:getDescription())
end
function workerTrade:registWorkerToMarket(workerIndex)
  local listCount = 0
  if nil ~= self._plantKey then
    listCount = ToClient_getPlantWaitWorkerListCount(self._plantKey, 0)
  end
  if listCount <= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_NOWORKER"))
    return
  end
  local workerNoRaw = ToClient_getPlantWaitWorkerNoRawByIndex(self._plantKey, workerIndex)
  local workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
  local transferType = 0
  local function requestRegist()
    PaGlobalFunc_WorkerTrade_TemporaryOpen()
    ToClient_requestRegisterNpcWorkerAuction(workerNoRaw, transferType, workerWrapperLua:getWorkerMaxPrice())
  end
  local titleString = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVANT_NAMING_INPUT_TITLE")
  local contentString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PANEL_WORKERRESIST_AUCTION_DESC", "per", self._config._workerAuctionChargePercent)
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = requestRegist,
    functionCancel = PaGlobalFunc_WorkerTrade_TemporaryOpen,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  PaGlobalFunc_WorkerTrade_TemporaryClose()
  MessageBox.showMessageBox(messageboxData)
end
function workerTrade:changeTab(changeValue)
  local tabIndex = self._selectedTab + changeValue
  if tabIndex < 0 then
    tabIndex = self._config._Tab._tabCount - 1
  elseif tabIndex >= self._config._Tab._tabCount then
    tabIndex = 0
  end
  workerTrade:resetPageData()
  self._selectedTab = tabIndex
  if self._config._Tab._marketWorkerList == tabIndex then
    RequestAuctionListPage(CppEnums.AuctionType.AuctionGoods_WorkerNpc)
  elseif self._config._Tab._myRegistedWorkerList == tabIndex then
    requestMyWorkerList()
  end
  _AudioPostEvent_SystemUiForXBOX(51, 7)
  workerTrade:update()
  ToClient_padSnapResetControl()
end
function workerTrade:changePage(changeValue)
  local pageIndex = self._currentPage + changeValue
  if pageIndex < 1 then
    pageIndex = 1
  end
  if self._config._Tab._marketWorkerList == self._selectedTab then
    if pageIndex < self._currentPage then
      RequestAuctionPrevPage()
    elseif pageIndex > self._currentPage then
      RequestAuctionNextPage()
    end
  elseif pageIndex >= self._maxPage then
    pageIndex = self._maxPage
  end
  if self._currentPage == pageIndex then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  self._currentPage = pageIndex
  workerTrade:update()
  ToClient_padSnapResetControl()
end
function workerTrade:temporaryOpen()
  Panel_Dialog_WorkerTrade_Renew:SetShow(true)
end
function workerTrade:temporaryClose()
  Panel_Dialog_WorkerTrade_Renew:SetShow(false)
end
function PaGlobalFunc_WorkerTrade_TemporaryOpen()
  workerTrade:temporaryOpen()
end
function PaGlobalFunc_WorkerTrade_TemporaryClose()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  workerTrade:temporaryClose()
end
function workerTrade:open()
  if true == Panel_Dialog_WorkerTrade_Renew:GetShow() then
    return
  end
  self._ui._static_SkillInfo:SetShow(false)
  Panel_Dialog_WorkerTrade_Renew:SetShow(true)
end
function workerTrade:close()
  if false == Panel_Dialog_WorkerTrade_Renew:GetShow() then
    return
  end
  self._ui._static_Skill_List_BG:SetShow(false)
  Panel_Dialog_WorkerTrade_Renew:SetShow(false)
  PaGlobalFunc_MainDialog_setIgnoreShowDialog(false)
  PaGlobalFunc_MainDialog_ReOpen()
end
function workerTrade:updateMoney()
  self._ui._staticText_Silver_Inventory:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  self._ui._staticText_Silver_Storage:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
end
function workerTrade:registEventHandler()
  registerEvent("EventWarehouseUpdate", "WorkerTrade_UpdateMoney")
  registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_WorkerTrade")
  registerEvent("FromClient_ResponseWorkerAuction", "FromClient_ResponseWorkerAuction")
  registerEvent("FromClient_ResponseMyWorkerAuction", "FromClient_ResponseMyWorkerAuction")
  registerEvent("FromClient_RegistAuction", "FromClient_RegistAuction")
  registerEvent("FromClient_BuyWorkerAuction", "FromClient_BuyWorkerAuction")
  registerEvent("FromClient_PopWorkerPriceAuction", "FromClient_PopWorkerPriceAuction")
  registerEvent("FromClient_CancelRegistAuction", "FromClient_CancelRegistAuction")
end
function WorkerTrade_UpdateMoney()
  workerTrade:updateMoney()
end
function FromClient_luaLoadComplete_WorkerTrade()
  workerTrade:initialize()
end
function FromClient_ResponseWorkerAuction()
  FGlobal_WorkerTrade_Open()
end
function FromClient_ResponseMyWorkerAuction()
  workerTrade:update()
end
function FGlobal_WorkerTrade_Open()
  if true == _ContentsGroup_NewUI_WorkerRandomSelect_All then
    if nil ~= Panel_Window_WorkerAuction_All and nil ~= Panel_Dialog_WorkerContract and (true == Panel_Window_WorkerAuction_All:GetShow() or true == Panel_Dialog_WorkerContract:GetShow()) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_COMPLETE_WORKERCONTRACT"))
      return
    end
  elseif nil ~= Panel_Dialog_RandomWorker and nil ~= Panel_Dialog_WorkerContract and (true == Panel_Dialog_RandomWorker:GetShow() or true == Panel_Dialog_WorkerContract:GetShow()) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_COMPLETE_WORKERCONTRACT"))
    return
  end
  if false == Panel_Dialog_WorkerTrade_Renew:GetShow() then
    workerTrade:resetData()
    workerTrade:setPlayerData()
    workerTrade:open()
  end
  workerTrade:update()
end
function FGlobal_WorkerTrade_Close()
  workerTrade:close()
end
function WorkerTrade_ChangePage(changeValue)
  workerTrade:changePage(changeValue)
end
function WorkerTrade_ChangeTab(changeValue)
  workerTrade:changeTab(changeValue)
end
function WorkerTrade_BuyWorker(workerIndex)
  workerTrade:buyWorker(workerIndex)
end
function WorkerTrade_GetPrice(workerIndex)
  workerTrade:getPrice(workerIndex)
end
function WorkerTrade_RegistCancle(workerIndex)
  workerTrade:registCancle(workerIndex)
end
function WorkerTrade_OpenWorkerSkillToolTip(workerIndex)
  workerTrade:openWorkerSkillToolTip(workerIndex)
end
function WorkerTrade_CloseWorkerSkillToolTip()
  workerTrade:closeWorkerSkillToolTip()
end
function WorkerTrade_ClickOnMoneyWhereType(isInven)
  local self = workerTrade
  self._ui._chk_Silver_Inventory:SetCheck(isInven)
  self._ui._chk_Silver_Storage:SetCheck(not isInven)
end
function WorkerTrade_RegistWorkerToMarket(workerIndex)
  workerTrade:registWorkerToMarket(workerIndex)
end
function FromClient_RegistAuction()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_REGISTCOMPLETE"))
  workerTrade:update()
end
function FromClient_BuyWorkerAuction()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYCOMPLETE"))
  workerTrade:update()
end
function FromClient_PopWorkerPriceAuction()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_RECEIVE_PRICE"))
  workerTrade:update()
end
function FromClient_CancelRegistAuction()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_COMPLETE_CANCELREGIST"))
  workerTrade:update()
end
workerTrade:registEventHandler()
