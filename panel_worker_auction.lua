Panel_Worker_Auction:SetShow(false)
Panel_Worker_Auction:setMaskingChild(true)
Panel_Worker_Auction:ActiveMouseEventEffect(true)
Panel_Worker_Auction:SetDragEnable(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local auctionInfo = RequestGetAuctionInfo()
local workerList = {}
local workerAuction = {
  _config = {
    slot = {
      startX = 20,
      startY = 5,
      gapY = 115
    },
    skill = {gapX = 4},
    slotCount = 4
  },
  _mainBG = UI.getChildControl(Panel_Worker_Auction, "Static_BG"),
  _listBG = UI.getChildControl(Panel_Worker_Auction, "Static_BG_1"),
  _btnWinQuestion = UI.getChildControl(Panel_Worker_Auction, "Button_Question"),
  _btnWinClose = UI.getChildControl(Panel_Worker_Auction, "Button_Win_Close"),
  _btnTabMarket = UI.getChildControl(Panel_Worker_Auction, "radioButton_MarketList"),
  _btnTabMine = UI.getChildControl(Panel_Worker_Auction, "radioButton_MyList"),
  _filterBG = UI.getChildControl(Panel_Worker_Auction, "Static_FilterBG"),
  _comboFilterZone = UI.getChildControl(Panel_Worker_Auction, "Combobox_Filter_Zone"),
  _comboFilterTribe = UI.getChildControl(Panel_Worker_Auction, "Combobox_Filter_Tribe"),
  _comboFilterSkill = UI.getChildControl(Panel_Worker_Auction, "Combobox_Filter_Skill"),
  _slots = Array.new(),
  _btnResist = UI.getChildControl(Panel_Worker_Auction, "Button_WorkerResist"),
  _btnBuy = UI.getChildControl(Panel_Worker_Auction, "Button_Buy"),
  _btnReceive = UI.getChildControl(Panel_Worker_Auction, "Button_Receive"),
  _btnCancel = UI.getChildControl(Panel_Worker_Auction, "Button_Cancel"),
  _btnEnd = UI.getChildControl(Panel_Worker_Auction, "Button_End"),
  _radioInvenMoney = UI.getChildControl(Panel_Worker_Auction, "RadioButton_Inventory"),
  _radioWareHouseMoney = UI.getChildControl(Panel_Worker_Auction, "RadioButton_Warehouse"),
  _staticInvenMoneyIcon = UI.getChildControl(Panel_Worker_Auction, "StaticText_MyMoney_Icon"),
  _staticInvenMoney = UI.getChildControl(Panel_Worker_Auction, "StaticText_InventoryMoney"),
  _staticWareHouseMoneyIcon = UI.getChildControl(Panel_Worker_Auction, "StaticText_MyWareHouseMoney_Icon"),
  _staticWareHouseMoney = UI.getChildControl(Panel_Worker_Auction, "StaticText_WareHouseMoney"),
  _btnPrev = UI.getChildControl(Panel_Worker_Auction, "Button_Prev"),
  _staticPageNo = UI.getChildControl(Panel_Worker_Auction, "Static_PageNo"),
  _btnNext = UI.getChildControl(Panel_Worker_Auction, "Button_Next"),
  _slotCount = 4,
  _skillCount = 7,
  _selectSlotNo = nil,
  _selectPage = 0,
  _selectMaxPage = 0,
  _isTabMine = false,
  _plantKey = nil,
  _isPaging = false
}
local createAndCopyBasePropertyControlSetPosition = function(fromParent, fromStrID, parent, strID, originalParent)
  local ui = UI.createAndCopyBasePropertyControl(fromParent, fromStrID, parent, strID)
  if nil ~= originalParent then
    local originalParentUI = UI.getChildControl(Panel_Worker_Auction, originalParent)
    local originalUI = UI.getChildControl(Panel_Worker_Auction, fromStrID)
    ui:SetPosX(originalUI:GetPosX() - originalParentUI:GetPosX())
    ui:SetPosY(originalUI:GetPosY() - originalParentUI:GetPosY())
  else
    ui:SetPosX(ui:GetPosX() - parent:GetPosX())
    ui:SetPosY(ui:GetPosY() - parent:GetPosY())
  end
  return ui
end
function workerAuction:Init()
  for ii = 0, self._slotCount - 1 do
    local slot = {}
    slot.slotNo = ii
    slot._panel = Panel_Worker_Auction
    slot._startSlotIndex = 0
    slot._learnSkillCount = 0
    slot._baseSlotBG = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_LineBG_1", self._listBG, "workerMarket_Slot_" .. ii)
    slot._workerIconBG = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_WorkerIconBG", slot._baseSlotBG, "workerMarket_Slot_workerIconBG" .. ii, "Static_LineBG_1")
    slot._workerIcon = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_workerIcon", slot._workerIconBG, "workerMarket_Slot_workerIcon" .. ii, "Static_WorkerIconBG")
    slot._workerLv = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_WorkerLevel", slot._workerIconBG, "workerMarket_Slot_workerLv" .. ii, "Static_WorkerIconBG")
    slot._workerName = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_Name", slot._baseSlotBG, "workerMarket_Slot_workerName" .. ii, "Static_LineBG_1")
    slot._upgradeChance = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_UpgradeChance", slot._baseSlotBG, "workerMarket_Slot_upgradeChance" .. ii, "Static_LineBG_1")
    slot._upgradeChanceValue = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_UpgradeChanceValue", slot._baseSlotBG, "workerMarket_Slot_upgradeChanceValue" .. ii, "Static_LineBG_1")
    slot._line_1 = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_Line_1", slot._baseSlotBG, "Static_Line_1_" .. ii, "Static_LineBG_1")
    slot._workerZone = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_Zone", slot._baseSlotBG, "workerMarket_Slot_workerZone" .. ii, "Static_LineBG_1")
    slot._workSpeed = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_WorkSpeed", slot._baseSlotBG, "workerMarket_Slot_workSpeed" .. ii, "Static_LineBG_1")
    slot._workSpeedValue = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_WorkSpeedValue", slot._baseSlotBG, "workerMarket_Slot_workSpeedValue" .. ii, "Static_LineBG_1")
    slot._moveSpeed = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_MoveSpeed", slot._baseSlotBG, "workerMarket_Slot_moveSpeed" .. ii, "Static_LineBG_1")
    slot._moveSpeedValue = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_MoveSpeedValue", slot._baseSlotBG, "workerMarket_Slot_moveSpeedValue" .. ii, "Static_LineBG_1")
    slot._luck = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_Luck", slot._baseSlotBG, "workerMarket_Slot_luck" .. ii, "Static_LineBG_1")
    slot._luckValue = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_LuckValue", slot._baseSlotBG, "workerMarket_Slot_luckValue" .. ii, "Static_LineBG_1")
    slot._actionPoint = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_ActionPoint", slot._baseSlotBG, "workerMarket_Slot_actionPoint" .. ii, "Static_LineBG_1")
    slot._actionPointValue = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_ActionPointValue", slot._baseSlotBG, "workerMarket_Slot_actionPointValue" .. ii, "Static_LineBG_1")
    slot._line_2 = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_Line_2", slot._baseSlotBG, "Static_Line_2_" .. ii, "Static_LineBG_1")
    slot._workerPrice = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_Price", slot._baseSlotBG, "workerMarket_Slot_workerPrice" .. ii, "Static_LineBG_1")
    slot._workerPriceValue = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_PriceValue", slot._baseSlotBG, "workerMarket_Slot_workerPriceValue" .. ii, "Static_LineBG_1")
    slot._SkillBG = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_WorkerSkillSlotBG", slot._baseSlotBG, "workerMarket_Slot_SkillBG" .. ii, "Static_LineBG_1")
    slot._skill = Array.new()
    for jj = 0, self._skillCount - 1 do
      local skill = {}
      skill._SkillIconBG = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_SkillIconBG_01", slot._SkillBG, "workerMarket_Slot_slotSkillIconBG" .. ii .. "_" .. jj, "Static_WorkerSkillSlotBG")
      skill._SkillIconBG:SetPosX(jj * (self._config.skill.gapX + skill._SkillIconBG:GetSizeX()))
      skill._SkillIcon = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Static_SkillSlot_01", slot._SkillBG, "workerMarket_Slot_slotSkillIcon" .. ii .. "_" .. jj, "Static_WorkerSkillSlotBG")
      skill._SkillIcon:SetPosX(jj * (self._config.skill.gapX + skill._SkillIconBG:GetSizeX()))
      slot._skill[jj] = skill
    end
    slot._btnBuy = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Button_Buy", slot._baseSlotBG, "workerMarket_Slot_buttonBuy" .. ii, "Static_LineBG_1")
    slot._btnReceive = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Button_Receive", slot._baseSlotBG, "workerMarket_Slot_buttonReceive" .. ii, "Static_LineBG_1")
    slot._btnCancel = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Button_Cancel", slot._baseSlotBG, "workerMarket_Slot_buttonCancel" .. ii, "Static_LineBG_1")
    slot._btnEnd = createAndCopyBasePropertyControlSetPosition(Panel_Worker_Auction, "Button_End", slot._baseSlotBG, "workerMarket_Slot_buttonEnd" .. ii, "Static_LineBG_1")
    self._btnPrev:SetAutoDisableTime(1)
    self._btnNext:SetAutoDisableTime(1)
    slot._btnBuy:SetAutoDisableTime(3)
    slot._btnReceive:SetAutoDisableTime(3)
    slot._btnCancel:SetAutoDisableTime(3)
    slot._btnEnd:SetAutoDisableTime(3)
    local slotConfig = self._config.slot
    slot._baseSlotBG:SetPosX(slotConfig.startX)
    slot._baseSlotBG:SetPosY(slotConfig.startY + slotConfig.gapY * ii)
    self._slots[ii] = slot
  end
  self._btnWinQuestion:SetShow(false)
  self._filterBG:SetShow(false)
  self._comboFilterZone:SetShow(false)
  self._comboFilterTribe:SetShow(false)
  self._comboFilterSkill:SetShow(false)
  self._btnResist:SetShow(true)
  self._radioInvenMoney:ComputePos()
  self._radioWareHouseMoney:ComputePos()
  self._staticInvenMoney:ComputePos()
  self._staticInvenMoneyIcon:SetPosX(self._staticInvenMoney:GetPosX() + self._staticInvenMoney:GetSizeX() - self._staticInvenMoney:GetTextSizeX() - self._staticInvenMoneyIcon:GetSizeX() - 5)
  self._staticWareHouseMoney:ComputePos()
  self._staticWareHouseMoneyIcon:SetPosX(self._staticWareHouseMoney:GetPosX() + self._staticWareHouseMoney:GetSizeX() - self._staticWareHouseMoney:GetTextSizeX() - self._staticWareHouseMoneyIcon:GetSizeX() - 15)
  self._btnPrev:ComputePos()
  self._staticPageNo:ComputePos()
  self._btnNext:ComputePos()
  self._btnPrev:SetEnable(false)
  self._btnNext:SetEnable(false)
  self._btnTabMarket:SetCheck(true)
  self._radioInvenMoney:SetCheck(false)
  self._radioWareHouseMoney:SetCheck(true)
  self._radioInvenMoney:SetEnableArea(0, 0, self._radioInvenMoney:GetSizeX() + self._radioInvenMoney:GetTextSizeX() + 10, self._radioInvenMoney:GetSizeY())
  self._radioWareHouseMoney:SetEnableArea(0, 0, self._radioWareHouseMoney:GetSizeX() + self._radioWareHouseMoney:GetTextSizeX() + 10, self._radioWareHouseMoney:GetSizeY())
end
function workerAuction:registEventHandler()
  self._btnWinClose:addInputEvent("Mouse_LUp", "WorkerAuction_Close()")
  self._btnTabMarket:addInputEvent("Mouse_LUp", "workerAuction_TabEvent( false )")
  self._btnTabMine:addInputEvent("Mouse_LUp", "workerAuction_TabEvent( true )")
  self._btnResist:addInputEvent("Mouse_LUp", "FGlobal_AuctionResist_WorkerList()")
  self._btnNext:addInputEvent("Mouse_LUp", "WorkerAuction_NextPage()")
  self._btnPrev:addInputEvent("Mouse_LUp", "WorkerAuction_PrevPage()")
end
function workerAuction:Update()
  WorkerAuction_UpdateMoney()
  local self = workerAuction
  for ii = 0, self._slotCount - 1 do
    local slot = self._slots[ii]
    slot._baseSlotBG:SetShow(false)
  end
  workerList = {}
  local startSlotNo = 0
  local endSlotNo = 0
  if workerAuction_IsTabMine() then
    startSlotNo = self._selectPage * self._slotCount
    endSlotNo = startSlotNo + self._slotCount - 1
    local maxCount = auctionInfo:getWorkerAuctionCount()
    self._selectMaxPage = math.floor(maxCount / self._slotCount) - 1
    if 0 < maxCount % self._slotCount then
      self._selectMaxPage = self._selectMaxPage + 1
    end
  else
    endSlotNo = auctionInfo:getWorkerAuctionCount()
  end
  local uiIdx = 0
  for index = startSlotNo, endSlotNo do
    do
      local workerNoRaw = auctionInfo:getWorkerAuction(index)
      local workerWrapper = getWorkerWrapperByAuction(workerNoRaw, true)
      workerList[index] = workerWrapper
      if nil ~= workerWrapper then
        do
          local slot = self._slots[uiIdx]
          local workerIcon = workerWrapper:getWorkerIcon()
          local workerLv = workerWrapper:getLevel()
          local workerName = workerWrapper:getName()
          local workerPrice = auctionInfo:getWorkerAuctionPrice(workerNoRaw)
          local workerZone = workerWrapper:getHomeWaypoint()
          local workerUpgradeCount = workerWrapper:getUpgradePoint()
          local moveSpeedValue = workerWrapper:getMoveSpeed()
          local luckValue = workerWrapper:getLuck()
          local actionPointValue = workerWrapper:getActionPoint()
          local workerZoneName = ToClient_GetNodeNameByWaypointKey(workerZone)
          local workSpeedValue = 0
          if workSpeedValue < workerWrapper:getWorkEfficiency(2) then
            workSpeedValue = workerWrapper:getWorkEfficiency(2)
          end
          if workSpeedValue < workerWrapper:getWorkEfficiency(5) then
            workSpeedValue = workerWrapper:getWorkEfficiency(5)
          end
          if workSpeedValue < workerWrapper:getWorkEfficiency(6) then
            workSpeedValue = workerWrapper:getWorkEfficiency(6)
          end
          if workSpeedValue < workerWrapper:getWorkEfficiency(8) then
            workSpeedValue = workerWrapper:getWorkEfficiency(8)
          end
          slot._workerIcon:ChangeTextureInfoName(workerIcon)
          slot._workerLv:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(workerLv))
          slot._workerName:SetText(workerWrapper:getGradeToColorString() .. workerName .. "<PAColor0xffc4bebe> (" .. workerZoneName .. ")<PAOldColor>")
          slot._upgradeChanceValue:SetText(tostring(workerUpgradeCount))
          slot._moveSpeedValue:SetText(string.format("%.2f", moveSpeedValue / 100))
          slot._workSpeedValue:SetText(string.format("%.2f", workSpeedValue / 1000000))
          slot._luckValue:SetText(string.format("%.2f", luckValue / 10000))
          slot._actionPointValue:SetText(tostring(actionPointValue))
          slot._workerPriceValue:SetText(makeDotMoney(workerPrice))
          slot._workerPrice:SetPosX(slot._workerPriceValue:GetPosX() + slot._workerPriceValue:GetSizeX() - slot._workerPriceValue:GetTextSizeX() - slot._workerPrice:GetSizeX() - 10)
          slot._baseSlotBG:SetShow(true)
          slot._workerIcon:SetShow(true)
          slot._workerLv:SetShow(true)
          slot._workerName:SetShow(true)
          slot._workerZone:SetShow(false)
          slot._upgradeChanceValue:SetShow(true)
          slot._moveSpeedValue:SetShow(true)
          slot._workSpeedValue:SetShow(true)
          slot._luckValue:SetShow(true)
          slot._actionPointValue:SetShow(true)
          if 4 <= workerWrapper:getGrade() then
            slot._upgradeChance:SetMonoTone(true)
            slot._upgradeChance:SetFontColor(UI_color.C_FF515151)
            slot._upgradeChance:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_CANNOTUPGRADE"))
            slot._upgradeChanceValue:SetShow(false)
          else
            slot._upgradeChance:SetMonoTone(false)
            slot._upgradeChance:SetFontColor(UI_color.C_FFFF7C67)
            slot._upgradeChance:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_UPGRADECHANCE"))
            slot._upgradeChanceValue:SetShow(true)
          end
          if true == workerWrapper:isMine() then
            slot._btnBuy:SetEnable(false)
            slot._btnBuy:SetMonoTone(true)
            slot._btnBuy:SetFontColor(UI_color.C_FF515151)
            slot._btnBuy:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_MYWORKER"))
          else
            slot._btnBuy:SetEnable(true)
            slot._btnBuy:SetMonoTone(false)
            slot._btnBuy:SetFontColor(UI_color.C_FFEFEFEF)
            slot._btnBuy:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYWORKER"))
          end
          slot._btnBuy:addInputEvent("Mouse_LUp", "WorkerAuction_Buy(" .. index .. ")")
          slot._btnReceive:addInputEvent("Mouse_LUp", "WorkerAuction_Receive(" .. index .. ")")
          slot._btnCancel:addInputEvent("Mouse_LUp", "WorkerAuction_Cancel(" .. index .. ")")
          for ii = 0, self._skillCount - 1 do
            slot._skill[ii]._SkillIconBG:SetShow(false)
            slot._skill[ii]._SkillIcon:SetShow(false)
          end
          workerWrapper:foreachSkillList(function(skillIdx, skillStaticStatusWrapper)
            if nil == slot._skill[skillIdx] then
              return true
            end
            slot._skill[skillIdx]._SkillIconBG:SetShow(true)
            slot._skill[skillIdx]._SkillIcon:SetShow(true)
            slot._skill[skillIdx]._SkillIcon:ChangeTextureInfoName(skillStaticStatusWrapper:getIconPath())
            slot._skill[skillIdx]._SkillIcon:addInputEvent("Mouse_On", "workerAuction_SkillTooltip( true, " .. index .. ", " .. uiIdx .. ", " .. skillIdx .. ")")
            slot._skill[skillIdx]._SkillIcon:addInputEvent("Mouse_Out", "workerAuction_SkillTooltip( false )")
            return false
          end)
          slot._learnSkillCount = 0
          local tempIndex = 0
          local slotIndex = 0
          slot._btnBuy:SetShow(false)
          slot._btnReceive:SetShow(false)
          slot._btnCancel:SetShow(false)
          slot._btnEnd:SetShow(false)
          if workerAuction_IsTabMine() then
            slot._btnBuy:SetShow(false)
            local isEndAuction = auctionInfo:getWorkerAuctionEnd(workerNoRaw)
            if true == isEndAuction then
              slot._btnReceive:SetShow(true)
            else
              slot._btnCancel:SetShow(true)
            end
          else
            slot._btnBuy:SetShow(true)
          end
          uiIdx = uiIdx + 1
        end
      end
    end
  end
  self._staticPageNo:SetText(self._selectPage + 1)
end
function workerAuction_SkillTooltip(isShow, dataIdx, uiIdx, skillIdx)
  if true == isShow then
    local workerNoRaw = auctionInfo:getWorkerAuction(dataIdx)
    local workerWrapperLua = getWorkerWrapperByAuction(workerNoRaw, true)
    local skillSSW = workerWrapperLua:getSkillSSW(skillIdx)
    local slot = workerAuction._slots[uiIdx]
    local uiControl = slot._skill[skillIdx]._SkillIcon
    local name = skillSSW:getName()
    local desc = skillSSW:getDescription()
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function workerAuction_TabEvent(isTabMine)
  local self = workerAuction
  workerAuction_TabToList(isTabMine)
end
function workerAuction_TabToList(isTabMine)
  local self = workerAuction
  self._selectPage = 0
  self._selectMaxPage = 0
  self._isTabMine = isTabMine
  if workerAuction_IsTabMine() then
    requestMyWorkerList()
  else
    RequestAuctionListPage(CppEnums.AuctionType.AuctionGoods_WorkerNpc)
  end
end
function workerAuction_IsTabMine()
  local self = workerAuction
  return self._isTabMine
end
function WorkerAuction_PrevPage()
  local self = workerAuction
  if workerAuction_IsTabMine() then
    if 0 < self._selectPage then
      self._selectPage = self._selectPage - 1
      self._isPaging = true
      workerAuction:Update()
    end
  elseif 0 < self._selectPage then
    self._selectPage = self._selectPage - 1
    self._isPaging = true
    self._btnPrev:SetEnable(false)
    self._btnNext:SetEnable(false)
    RequestAuctionPrevPage()
  else
    return
  end
end
function WorkerAuction_NextPage()
  local self = workerAuction
  if workerAuction_IsTabMine() then
    if self._selectMaxPage <= self._selectPage then
      return
    end
    self._selectPage = self._selectPage + 1
    self._isPaging = true
    workerAuction:Update()
  else
    self._selectPage = self._selectPage + 1
    self._isPaging = true
    self._btnPrev:SetEnable(false)
    self._btnNext:SetEnable(false)
    RequestAuctionNextPage()
  end
end
function WorkerAuction_Buy(slotNo)
  local self = workerAuction
  self._selectSlotNo = slotNo
  local workerNoRaw = auctionInfo:getWorkerAuction(self._selectSlotNo)
  local workerWrapper = getWorkerWrapperByAuction(workerNoRaw, true)
  local workerLv = workerWrapper:getLevel()
  local workerName = workerWrapper:getName()
  local workerPrice = auctionInfo:getWorkerAuctionPrice(workerNoRaw)
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYCONFIRM")
  local contentString = workerWrapper:getGradeToColorString() .. PAGetStringParam3(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYCONFIRM_TITLE", "level", tostring(workerLv), "name", workerName, "price", makeDotMoney(workerPrice)) .. "<PAOldColor>"
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = WorkerAuction_BuyXXX,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function WorkerAuction_BuyXXX()
  local self = workerAuction
  local workerNoRaw = auctionInfo:getWorkerAuction(self._selectSlotNo)
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  if self._radioWareHouseMoney:IsCheck() then
    fromWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  auctionInfo:requestBuyItNowWorker(workerNoRaw, fromWhereType)
  self._selectSlotNo = nil
end
function WorkerAuction_Cancel(slotNo)
  local self = workerAuction
  self._selectSlotNo = slotNo
  local workerNoRaw = auctionInfo:getWorkerAuction(self._selectSlotNo)
  local workerWrapper = getWorkerWrapperByAuction(workerNoRaw, true)
  local workerLv = workerWrapper:getLevel()
  local workerName = workerWrapper:getName()
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_CANCELCONFIRM")
  local contentString = workerWrapper:getGradeToColorString() .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_CANCELCONFIRM_TITLE", "level", tostring(workerLv), "name", workerName) .. "<PAOldColor>"
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = WorkerAuction_CancelXXX,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function WorkerAuction_CancelXXX()
  local self = workerAuction
  local workerNoRaw = auctionInfo:getWorkerAuction(self._selectSlotNo)
  ToClient_requestCancelRegisterMyWorkerAuction(workerNoRaw)
  self._selectSlotNo = nil
end
function WorkerAuction_Receive(slotNo)
  local self = workerAuction
  self._selectSlotNo = slotNo
  local workerNoRaw = auctionInfo:getWorkerAuction(self._selectSlotNo)
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  if self._radioWareHouseMoney:IsCheck() then
    fromWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  auctionInfo:requestPopWorkerPrice(workerNoRaw, fromWhereType)
  self._selectSlotNo = nil
end
function WorkerAuction_Open()
end
function WorkerAuction_Close()
  if not Panel_Worker_Auction:IsShow() then
    return
  end
  Panel_Worker_Auction:SetShow(false)
  Panel_WorkerList_Auction:SetShow(false)
  Panel_WorkerResist_Auction:SetShow(false)
end
function WorkerAuction_UpdateMoney()
  local self = workerAuction
  self._staticInvenMoney:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  self._staticWareHouseMoney:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
  self._staticWareHouseMoneyIcon:SetPosX(self._staticWareHouseMoney:GetPosX() + self._staticWareHouseMoney:GetSizeX() - self._staticWareHouseMoney:GetTextSizeX() - self._staticWareHouseMoneyIcon:GetSizeX() - 15)
  self._staticInvenMoneyIcon:SetPosX(self._staticInvenMoney:GetPosX() + self._staticInvenMoney:GetSizeX() - self._staticInvenMoney:GetTextSizeX() - self._staticInvenMoneyIcon:GetSizeX() - 5)
end
function FromClient_ResponseWorkerAuction()
  if true == _ContentsGroup_NewUI_WorkerRandomSelect_All then
    if nil ~= Panel_Window_WorkerRandomSelect_All and true == Panel_Window_WorkerRandomSelect_All:GetShow() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_COMPLETE_WORKERCONTRACT"))
      return
    end
  elseif Panel_Window_WorkerRandomSelect:IsShow() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_COMPLETE_WORKERCONTRACT"))
    return
  end
  if false == Panel_Worker_Auction:GetShow() then
    local totalSizeY, subSizeY
    if true == _ContentsGroup_RenewUI_Dailog then
      totalSizeY = PaGlobalFunc_MainDialog_Bottom_GetSizeY() * 2 + Panel_Worker_Auction:GetSizeY()
      subSizeY = PaGlobalFunc_MainDialog_Bottom_GetSizeY() + Panel_Worker_Auction:GetSizeY()
      Panel_Worker_Auction:SetPosX(getScreenSizeX() / 2 - Panel_Worker_Auction:GetSizeX() / 2)
      if totalSizeY < getScreenSizeY() then
        Panel_Worker_Auction:SetPosY(getScreenSizeY() - PaGlobalFunc_MainDialog_Bottom_GetSizeY() - Panel_Worker_Auction:GetSizeY())
      elseif subSizeY > getScreenSizeY() then
        Panel_Worker_Auction:SetPosY(5)
      else
        Panel_Worker_Auction:SetPosY(getScreenSizeY() / 2 - Panel_Worker_Auction:GetSizeY() / 2)
      end
    else
      local screenSizeX = getScreenSizeX()
      local screenSizeY = getScreenSizeY()
      local basePosY = screenSizeY / 2 - Panel_Worker_Auction:GetSizeY() / 2
      local dialogSizeY = 0
      if false == _ContentsGroup_NewUI_Dialog_All then
        dialogSizeY = Panel_Npc_Dialog:GetSizeY()
      else
        dialogSizeY = Panel_Npc_Dialog_All:GetSizeY()
      end
      local posY = math.min(screenSizeY - dialogSizeY, basePosY + Panel_Worker_Auction:GetSizeY()) - Panel_Worker_Auction:GetSizeY()
      posY = math.max(0, posY)
      Panel_Worker_Auction:SetSpanSize(0, posY)
    end
    Panel_Worker_Auction:SetShow(true)
  end
  local self = workerAuction
  self._btnTabMarket:SetCheck(true)
  self._btnTabMine:SetCheck(false)
  if true ~= self._isPaging then
    self._selectPage = 0
  end
  self._isTabMine = false
  workerAuction:Update()
  self._isPaging = false
  self._btnPrev:SetEnable(true)
  self._btnNext:SetEnable(true)
  warehouse_requestInfoFromNpc()
end
function FromClient_ResponseMyWorkerAuction()
  self = workerAuction
  if false == self._isPaging then
    self._selectPage = 0
  end
  self._isTabMine = true
  workerAuction:Update()
  self._isPaging = false
end
function FromClient_RegistAuction()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_REGISTCOMPLETE"))
  workerAuction:Update()
  FGlobal_MyworkerList_Update()
end
function FromClient_BuyWorkerAuction()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYCOMPLETE"))
  workerAuction:Update()
end
function FromClient_PopWorkerPriceAuction()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_RECEIVE_PRICE"))
  workerAuction:Update()
end
function FromClient_CancelRegistAuction()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_COMPLETE_CANCELREGIST"))
  workerAuction:Update()
end
registerEvent("EventWarehouseUpdate", "WorkerAuction_UpdateMoney")
registerEvent("FromClient_ResponseWorkerAuction", "FromClient_ResponseWorkerAuction")
registerEvent("FromClient_ResponseMyWorkerAuction", "FromClient_ResponseMyWorkerAuction")
registerEvent("FromClient_RegistAuction", "FromClient_RegistAuction")
registerEvent("FromClient_BuyWorkerAuction", "FromClient_BuyWorkerAuction")
registerEvent("FromClient_PopWorkerPriceAuction", "FromClient_PopWorkerPriceAuction")
registerEvent("FromClient_CancelRegistAuction", "FromClient_CancelRegistAuction")
workerAuction:Init()
workerAuction:registEventHandler()
