local ServantRentPromoteMarket = {
  _init = false,
  _panel = Panel_Stable_PromoteMarket,
  _isFromNpcFlag = true,
  _slotTable = {},
  _config = {slotCount = 4, skillSlotCount = 5},
  _tabType = CppEnums.AuctionTabType.AuctionTab_Count,
  _useInventoryMoneyFlag = false,
  _page = 0,
  _ui = {}
}
local promoteDesc = {
  _btn_Close = UI.getChildControl(Panel_Stable_PromoteMarket_PopupDesc, "Button_Close"),
  _txt_Desc = UI.getChildControl(Panel_Stable_PromoteMarket_PopupDesc, "StaticText_HelpDesc")
}
local Slot = {}
Slot.__index = Slot
function Slot.new(index, control)
  local slot = {}
  setmetatable(slot, Slot)
  slot:init(index, control)
  return slot
end
function Slot:init(index, control)
  self._index = index
  self._control = control
  self._skillPage = 1
  self._servantNo = nil
  local icon = UI.getChildControl(control, "Static_Icon")
  local male = UI.getChildControl(control, "Static_Male")
  local female = UI.getChildControl(control, "Static_Female")
  local stallion = UI.getChildControl(control, "Static_iconStallion")
  local grade = UI.getChildControl(control, "StaticText_Grade")
  local level = UI.getChildControl(control, "StaticText_LvValue")
  local speed = UI.getChildControl(control, "StaticText_MoveSpeedValue")
  local hp = UI.getChildControl(control, "StaticText_HpValue")
  local acceleration = UI.getChildControl(control, "StaticText_AccelerationValue")
  local stamina = UI.getChildControl(control, "StaticText_StaminaValue")
  local cornering = UI.getChildControl(control, "StaticText_CorneringValue")
  local weight = UI.getChildControl(control, "StaticText_WeightValue")
  local breakStat = UI.getChildControl(control, "StaticText_BrakeValue")
  local price = UI.getChildControl(control, "StaticText_PriceValue")
  local skillBack = UI.getChildControl(control, "Static_SkillBack")
  skillBack:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_ServantRentPromoteMarketSkillPageDown(" .. index .. ")")
  skillBack:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_ServantRentPromoteMarketSkillPageUp(" .. index .. ")")
  local skillTemplate = UI.getChildControl(skillBack, "Static_SkillIconBg")
  skillTemplate:SetShow(false)
  local skillTable = {}
  for i = 1, ServantRentPromoteMarket._config.skillSlotCount do
    local skill = UI.cloneControl(skillTemplate, skillBack, "Static_SkillBack" .. i)
    skill:SetPosX(skillTemplate:GetPosX() + skillTemplate:GetSizeX() * (i - 1))
    table.insert(skillTable, skill)
  end
  local prevPage = UI.getChildControl(skillBack, "Button_PrevPage")
  local nextPage = UI.getChildControl(skillBack, "Button_NextPage")
  local currentPage = UI.getChildControl(skillBack, "StaticText_PageValue")
  prevPage:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketSkillPageDown(" .. index .. ")")
  nextPage:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketSkillPageUp(" .. index .. ")")
  local cancelRentButton = UI.getChildControl(control, "Button_Cancel")
  cancelRentButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketCancelRent(" .. index .. ")")
  local buyRentButton = UI.getChildControl(control, "Button_HorseRental")
  buyRentButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketBuyRent(" .. index .. ")")
  local buyReturnButton = UI.getChildControl(control, "Button_HorseReturn")
  buyReturnButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketBuyReturn(" .. index .. ")")
  local receiveRentButton = UI.getChildControl(control, "Button_Receiving")
  receiveRentButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketReceiveRent(" .. index .. ")")
  local receiveReturnButton = UI.getChildControl(control, "Button_ReceivingReturn")
  receiveReturnButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketReceiveReturn(" .. index .. ")")
  local forceReturnButton = UI.getChildControl(control, "Button_ForceReturn")
  forceReturnButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketForceReturn(" .. index .. ")")
  cancelRentButton:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  buyRentButton:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  buyReturnButton:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  receiveRentButton:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  receiveReturnButton:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  forceReturnButton:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  cancelRentButton:SetText(cancelRentButton:GetText())
  buyRentButton:SetText(buyRentButton:GetText())
  buyReturnButton:SetText(buyReturnButton:GetText())
  receiveRentButton:SetText(receiveReturnButton:GetText())
  receiveReturnButton:SetText(receiveReturnButton:GetText())
  forceReturnButton:SetText(forceReturnButton:GetText())
  self._ui = {
    icon = icon,
    male = male,
    female = female,
    stallion = stallion,
    grade = grade,
    level = level,
    speed = speed,
    hp = hp,
    acceleration = acceleration,
    stamina = stamina,
    cornering = cornering,
    weight = weight,
    breakStat = breakStat,
    price = price,
    skillTable = skillTable,
    prevPage = prevPage,
    nextPage = nextPage,
    currentPage = currentPage,
    cancelRentButton = cancelRentButton,
    buyRentButton = buyRentButton,
    buyReturnButton = buyReturnButton,
    receiveRentButton = receiveRentButton,
    receiveReturnButton = receiveReturnButton,
    forceReturnButton = forceReturnButton
  }
end
local getValidSkillCount = function(info)
  local skillCount = 0
  for i = 1, vehicleSkillStaticStatus_skillCount() - 1 do
    local skill = info:getSkill(i)
    if skill then
      skillCount = skillCount + 1
    end
  end
  return skillCount
end
local getValidSkillKeyByIndex = function(info, index)
  local skillCount = 0
  for i = 1, vehicleSkillStaticStatus_skillCount() - 1 do
    local skill = info:getSkill(i)
    if skill then
      skillCount = skillCount + 1
      if skillCount == index then
        return i
      end
    end
  end
end
function Slot:updateData(info)
  local servano = info:getServantNo()
  if self._servantNo ~= servantNo then
    self._skillPage = 1
  end
  self._servantNo = servantNo
end
function Slot:update(info, tabType)
  local showFlag = nil ~= info
  self._control:SetShow(showFlag)
  if not showFlag then
    return
  end
  self:updateData(info)
  self._ui.icon:ChangeTextureInfoName(info:getIconPath1())
  self._ui.male:SetShow(info:isMale())
  self._ui.female:SetShow(not info:isMale())
  self._ui.stallion:SetShow(ToClient_IsContentsGroupOpen("243") and info:isStallion())
  self._ui.grade:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", info:getTier()))
  self._ui.level:SetText(info:getLevel())
  self._ui.speed:SetText(string.format("%.1f", info:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
  self._ui.hp:SetText(info:getMaxHp())
  self._ui.acceleration:SetText(string.format("%.1f", info:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
  self._ui.stamina:SetText(info:getMaxMp())
  self._ui.cornering:SetText(string.format("%.1f", info:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
  self._ui.weight:SetText(tostring(info:getMaxWeight_s64() / Defines.s64_const.s64_10000))
  self._ui.breakStat:SetText(string.format("%.1f", info:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
  self._ui.price:SetText(makeDotMoney(info:getAuctoinPrice_s64()))
  self:updateSkill(info)
  local showForceReturn = info:getAuctoinPrice_s64() == Defines.s64_const.s64_0
  local showBuyReturnFlag = CppEnums.AuctionTabType.AuctionTab_ServantReturn == tabType
  local isInStable = nil ~= stable_getServantByServantNo(info:getServantNo())
  local myUserNo = getSelfPlayer():get():getUserNo()
  local isAuctionEnd = info:isAuctionEnd()
  local showBuyRentFlag = CppEnums.AuctionTabType.AuctionTab_MyServantRent == tabType and not isAuctionEnd and not isInStable
  local showCancelRentFlag = CppEnums.AuctionTabType.AuctionTab_MyServantRent == tabType and not isAuctionEnd and isInStable
  local showReceiveRentFlag = CppEnums.AuctionTabType.AuctionTab_MyServantRent == tabType and isAuctionEnd
  local showReceiveReturnFlag = CppEnums.AuctionTabType.AuctionTab_MyServantReturn == tabType and not isInStable
  self._ui.buyRentButton:SetShow(not showForceReturn and showBuyRentFlag)
  self._ui.cancelRentButton:SetShow(not showForceReturn and showCancelRentFlag)
  self._ui.receiveRentButton:SetShow(not showForceReturn and showReceiveRentFlag)
  self._ui.forceReturnButton:SetShow(showForceReturn)
  self._ui.buyReturnButton:SetShow(not showForceReturn and showBuyReturnFlag)
  self._ui.receiveReturnButton:SetShow(not showForceReturn and showReceiveReturnFlag)
end
function Slot:updateSkill(info)
  local validSkillCount = getValidSkillCount(info)
  for i = 1, #self._ui.skillTable do
    local skillIndex = i + ServantRentPromoteMarket._config.skillSlotCount * (self._skillPage - 1)
    local showSkillFlag = validSkillCount >= skillIndex
    local skillSlot = self._ui.skillTable[i]
    skillSlot:SetShow(showSkillFlag)
    if showSkillFlag then
      local skillKey = getValidSkillKeyByIndex(info, skillIndex)
      local skill = info:getSkill(skillKey)
      if skill then
        local exp = info:getSkillExp(skillKey)
        local expPercent = exp / (skill:get()._maxExp / 100)
        expPercent = tonumber(string.format("%.0f", expPercent))
        if expPercent >= 100 then
          expPercent = 100
        end
        local icon = UI.getChildControl(skillSlot, "Static_SkillIcon")
        local text = UI.getChildControl(skillSlot, "StaticText_SkillText")
        local gauge = UI.getChildControl(skillSlot, "CircularProgress_SkillLearnGauge")
        local gaugeText = UI.getChildControl(skillSlot, "StaticText_SkillLearnPercent")
        icon:ChangeTextureInfoName("Icon/" .. skill:getIconPath())
        icon:SetShow(true)
        text:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
        text:SetText(skill:getName())
        gauge:SetProgressRate(expPercent)
        gaugeText:SetText(expPercent .. "%")
      end
    end
  end
  local maxSkillPage = math.ceil(validSkillCount / ServantRentPromoteMarket._config.skillSlotCount)
  local showPrevFlag = 1 < self._skillPage
  local showNextFlag = maxSkillPage > self._skillPage
  self._ui.prevPage:SetShow(showPrevFlag)
  self._ui.nextPage:SetShow(showNextFlag)
  self._ui.currentPage:SetShow(showPrevFlag or showNextFlag)
  self._ui.currentPage:SetText(self._skillPage)
end
function Slot:changeSkillPage(info, pageOffset)
  local nextPage = self._skillPage + pageOffset
  local maxPage = math.ceil(getValidSkillCount(info) / ServantRentPromoteMarket._config.skillSlotCount)
  if nextPage > 0 and nextPage <= maxPage then
    self._skillPage = nextPage
    return true
  end
end
function ServantRentPromoteMarket:initialize()
  if self._init then
    return
  end
  self._init = true
  local closeButton = UI.getChildControl(self._panel, "Button_Close")
  closeButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketClose()")
  local menuGroup = UI.getChildControl(self._panel, "Static_MenuBtnBG")
  local showAllRentListRadioButton = UI.getChildControl(menuGroup, "RadioButton_RentalList")
  local showMyRentListRadioButton = UI.getChildControl(menuGroup, "RadioButton_MyRentalList")
  local showAllReturnListRadioButton = UI.getChildControl(menuGroup, "RadioButton_ReturnList")
  local showMyReturnListRadioButton = UI.getChildControl(menuGroup, "RadioButton_MyReturnList")
  showAllRentListRadioButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketChangeTabType(CppEnums.AuctionTabType.AuctionTab_ServantRent)")
  showMyRentListRadioButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketChangeTabType(CppEnums.AuctionTabType.AuctionTab_MyServantRent)")
  showAllReturnListRadioButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketChangeTabType(CppEnums.AuctionTabType.AuctionTab_ServantReturn)")
  showMyReturnListRadioButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketChangeTabType(CppEnums.AuctionTabType.AuctionTab_MyServantReturn)")
  local refreshButton = UI.getChildControl(menuGroup, "RadioButton_Reload")
  refreshButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketRefresh()")
  local useInventoryMoneyRadioButton = UI.getChildControl(self._panel, "RadioButton_Icon_Money")
  local useWarehouseMoneyRadioButton = UI.getChildControl(self._panel, "RadioButton_Icon_Money2")
  useInventoryMoneyRadioButton:SetEnableArea(0, 0, useInventoryMoneyRadioButton:GetSizeX() + useInventoryMoneyRadioButton:GetTextSizeX() + 10, useInventoryMoneyRadioButton:GetSizeY())
  useWarehouseMoneyRadioButton:SetEnableArea(0, 0, useWarehouseMoneyRadioButton:GetSizeX() + useWarehouseMoneyRadioButton:GetTextSizeX() + 10, useWarehouseMoneyRadioButton:GetSizeY())
  useInventoryMoneyRadioButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketUseInventoryMoney(true)")
  useWarehouseMoneyRadioButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketUseInventoryMoney(false)")
  local inventoryMoney = UI.getChildControl(self._panel, "StaticText_Money")
  local warehouseMoney = UI.getChildControl(self._panel, "StaticText_Money2")
  local prevButton = UI.getChildControl(self._panel, "Button_Prev")
  local nextButton = UI.getChildControl(self._panel, "Button_Next")
  prevButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketPageDown()")
  nextButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteMarketPageUp()")
  local page = UI.getChildControl(self._panel, "StaticText_PageNo")
  local btnHelp = UI.getChildControl(self._panel, "Button_Help")
  btnHelp:addInputEvent("Mouse_LUp", "Panel_Stable_PromoteMarket_PopupDesc:open()")
  local slotTemplate = UI.getChildControl(self._panel, "Static_Slot")
  slotTemplate:SetShow(false)
  for i = 1, self._config.slotCount do
    local control = UI.cloneControl(slotTemplate, self._panel, "Static_Slot" .. i)
    control:SetPosY(slotTemplate:GetPosY() + (slotTemplate:GetSizeY() + 5) * (i - 1))
    local slot = Slot.new(i, control)
    table.insert(self._slotTable, slot)
  end
  self._ui.showAllRentListRadioButton = showAllRentListRadioButton
  self._ui.showMyRentListRadioButton = showMyRentListRadioButton
  self._ui.showAllReturnListRadioButton = showAllReturnListRadioButton
  self._ui.showMyReturnListRadioButton = showMyReturnListRadioButton
  self._ui.useInventoryMoneyRadioButton = useInventoryMoneyRadioButton
  self._ui.useWarehouseMoneyRadioButton = useWarehouseMoneyRadioButton
  self._ui.inventoryMoney = inventoryMoney
  self._ui.warehouseMoney = warehouseMoney
  self._ui.prevButton = prevButton
  self._ui.nextButton = nextButton
  self._ui.page = page
  registerEvent("FromClient_AuctionServantList", "PaGlobalFunc_ServantRentPromoteMarketUpdate")
  registerEvent("FromClient_InventoryUpdate", "PaGlobalFunc_ServantRentPromoteMarketUpdate")
  registerEvent("EventWarehouseUpdate", "PaGlobalFunc_ServantRentPromoteMarketUpdate")
end
function Panel_Stable_PromoteMarket_PopupDesc:init()
  local self = promoteDesc
  self._btn_Close:addInputEvent("Mouse_LUp", "Panel_Stable_PromoteMarket_PopupDesc:close()")
  self._txt_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_STABELLIST_HELPDESC"))
  Panel_Stable_PromoteMarket_PopupDesc:SetSize(Panel_Stable_PromoteMarket_PopupDesc:GetSizeX(), self._txt_Desc:GetTextSizeY() + 90)
end
function PaGlobalFunc_ServantRentPromoteMarketInit()
  return ServantRentPromoteMarket:initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_ServantRentPromoteMarketInit")
function ServantRentPromoteMarket:changeTabType(tabType)
  self._tabType = tabType
  local isFromNpcFlag = not ToClient_WorldMapIsShow()
  if CppEnums.AuctionTabType.AuctionTab_ServantRent == tabType then
    requestServantRentList(isFromNpcFlag)
  elseif CppEnums.AuctionTabType.AuctionTab_ServantReturn == tabType then
    requestServantReturnList(isFromNpcFlag)
  elseif CppEnums.AuctionTabType.AuctionTab_MyServantRent == tabType then
    requestMyServantRentList(isFromNpcFlag)
  elseif CppEnums.AuctionTabType.AuctionTab_MyServantReturn == tabType then
    requestMyServantReturnList(isFromNpcFlag)
  else
    return false
  end
  self._page = 1
  return true
end
function PaGlobalFunc_ServantRentPromoteMarketChangeTabType(tabType)
  if ServantRentPromoteMarket:changeTabType(tabType) then
    return ServantRentPromoteMarket:update()
  end
end
function ServantRentPromoteMarket:refresh()
  RequestActionReloadPage(0, self._isFromNpc)
  ServantRentPromoteMarket:update()
end
function PaGlobalFunc_ServantRentPromoteMarketRefresh()
  ServantRentPromoteMarket:refresh()
end
function ServantRentPromoteMarket:useInventoryMoney(flag)
  self._useInventoryMoneyFlag = flag
  return true
end
function PaGlobalFunc_ServantRentPromoteMarketUseInventoryMoney(flag)
  if ServantRentPromoteMarket:useInventoryMoney(flag) then
    return ServantRentPromoteMarket:update()
  end
end
function ServantRentPromoteMarket:checkShow()
  return self._panel:GetShow()
end
function PaGlobalFunc_ServantRentPromoteMarketCheckShow()
  return ServantRentPromoteMarket:checkShow()
end
function ServantRentPromoteMarket:open()
  if self:checkShow() then
    return false
  end
  StableMarket_Close()
  StableMating_Close()
  StableMix_Close()
  warehouse_requestInfoFromNpc()
  local isFromNpcFlag = not ToClient_WorldMapIsShow()
  self._isFromNpcFlag = isFromNpcFlag
  self._panel:SetPosX(getScreenSizeX() / 2 - self._panel:GetSizeX() / 2)
  self._panel:SetPosY(getScreenSizeY() / 2 - self._panel:GetSizeY() / 2 - 20)
  self._panel:SetShow(true)
  return self:changeTabType(CppEnums.AuctionTabType.AuctionTab_MyServantRent)
end
function PaGlobalFunc_ServantRentPromoteMarketOpen()
  if ServantRentPromoteMarket:open() then
    ServantRentPromoteMarket:update()
  end
end
function ServantRentPromoteMarket:pageDown()
  if CppEnums.AuctionTabType.AuctionTab_ServantRent == self._tabType or CppEnums.AuctionTabType.AuctionTab_ServantReturn == self._tabType then
    RequestAuctionPrevPage(0, self._isFromNpc)
    ServantRentPromoteMarket:update()
  elseif CppEnums.AuctionTabType.AuctionTab_MyServantRent == self._tabType or CppEnums.AuctionTabType.AuctionTab_MyServantReturn == self._tabType then
    self._page = math.max(0, self._page - 1)
    ServantRentPromoteMarket:update()
  else
    return false
  end
  return true
end
function PaGlobalFunc_ServantRentPromoteMarketPageDown()
  if ServantRentPromoteMarket:pageDown() then
    return ServantRentPromoteMarket:update()
  end
end
function ServantRentPromoteMarket:pageUp()
  if CppEnums.AuctionTabType.AuctionTab_ServantRent == self._tabType or CppEnums.AuctionTabType.AuctionTab_ServantReturn == self._tabType then
    RequestAuctionNextPage(0, self._isFromNpc)
    ServantRentPromoteMarket:update()
  elseif CppEnums.AuctionTabType.AuctionTab_MyServantRent == self._tabType or CppEnums.AuctionTabType.AuctionTab_MyServantReturn == self._tabType then
    local auctionInfo = RequestGetAuctionInfo()
    local maxPage = math.ceil(auctionInfo:getServantAuctionListCount() / self._config.slotCount) + 1
    self._page = math.min(maxPage, self._page + 1)
    ServantRentPromoteMarket:update()
  else
    return false
  end
  return true
end
function PaGlobalFunc_ServantRentPromoteMarketPageUp()
  return ServantRentPromoteMarket:pageUp()
end
function ServantRentPromoteMarket:changeSkillPage(slotIndex, pageOffset)
  local goodsIndex = self:getGoodsIndex(slotIndex)
  local info = RequestGetAuctionInfo():getServantAuctionListAt(goodsIndex)
  if not info then
    return false
  end
  local slot = self._slotTable[slotIndex]
  if not slot then
    return false
  end
  return slot:changeSkillPage(info, pageOffset)
end
function ServantRentPromoteMarket:skillPageDown(slotIndex)
  return self:changeSkillPage(slotIndex, -1)
end
function PaGlobalFunc_ServantRentPromoteMarketSkillPageDown(slotIndex)
  if ServantRentPromoteMarket:skillPageDown(slotIndex) then
    return ServantRentPromoteMarket:update()
  end
end
function ServantRentPromoteMarket:skillPageUp(slotIndex)
  return self:changeSkillPage(slotIndex, 1)
end
function PaGlobalFunc_ServantRentPromoteMarketSkillPageUp(slotIndex)
  if ServantRentPromoteMarket:skillPageUp(slotIndex) then
    return ServantRentPromoteMarket:update()
  end
end
function ServantRentPromoteMarket:getCurrentPage()
  if CppEnums.AuctionTabType.AuctionTab_ServantRent == self._tabType or CppEnums.AuctionTabType.AuctionTab_ServantReturn == self._tabType then
    return RequestGetAuctionInfo():getCurrentPage() + 1
  elseif CppEnums.AuctionTabType.AuctionTab_MyServantRent == self._tabType or CppEnums.AuctionTabType.AuctionTab_MyServantReturn == self._tabType then
    return self._page
  end
end
function ServantRentPromoteMarket:update()
  if not self._init or not self:checkShow() then
    return
  end
  self._ui.showAllRentListRadioButton:SetCheck(CppEnums.AuctionTabType.AuctionTab_ServantRent == self._tabType)
  self._ui.showMyRentListRadioButton:SetCheck(CppEnums.AuctionTabType.AuctionTab_MyServantRent == self._tabType)
  self._ui.showAllReturnListRadioButton:SetCheck(CppEnums.AuctionTabType.AuctionTab_ServantReturn == self._tabType)
  self._ui.showMyReturnListRadioButton:SetCheck(CppEnums.AuctionTabType.AuctionTab_MyServantReturn == self._tabType)
  self._ui.inventoryMoney:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  local warehouseMoney = warehouse_moneyFromNpcShop_s64()
  self._ui.warehouseMoney:SetText(makeDotMoney(warehouseMoney))
  local warehouseMoneyEnabledFlag = warehouseMoney > Defines.s64_const.s64_0
  if not warehouseMoneyEnabledFlag then
    self._useInventoryMoneyFlag = true
  end
  self._ui.useInventoryMoneyRadioButton:SetCheck(self._useInventoryMoneyFlag)
  self._ui.useWarehouseMoneyRadioButton:SetCheck(not self._useInventoryMoneyFlag)
  local auctionInfo = RequestGetAuctionInfo()
  self._ui.prevButton:SetEnable(1 < self:getCurrentPage())
  self._ui.nextButton:SetEnable(true)
  self._ui.page:SetText(self:getCurrentPage())
  for i = 1, table.getn(self._slotTable) do
    local slot = self._slotTable[i]
    if slot then
      local goodsIndex = self:getGoodsIndex(i)
      local info = auctionInfo:getServantAuctionListAt(goodsIndex)
      slot:update(info, self._tabType)
    end
  end
end
function PaGlobalFunc_ServantRentPromoteMarketUpdate()
  return ServantRentPromoteMarket:update()
end
function ServantRentPromoteMarket:close()
  if self:checkShow() then
    self._panel:SetShow(false)
    Panel_Stable_PromoteMarket_PopupDesc:close()
  end
end
function PaGlobalFunc_ServantRentPromoteMarketClose()
  return ServantRentPromoteMarket:close()
end
function ServantRentPromoteMarket:getGoodsIndex(slotIndex)
  return (self:getCurrentPage() - 1) * self._config.slotCount + (slotIndex - 1)
end
function ServantRentPromoteMarket:buyRent(slotIndex)
  local goodsIndex = self:getGoodsIndex(slotIndex)
  local info = RequestGetAuctionInfo():getServantAuctionListAt(goodsIndex)
  if not info then
    return
  end
  local fromWhereType = self._useInventoryMoneyFlag and CppEnums.ItemWhereType.eInventory or CppEnums.ItemWhereType.eWarehouse
  function handleYesClick()
    ToClient_requestBuyItNowServantForRent(goodsIndex, fromWhereType)
  end
  MessageBox.showMessageBox({
    title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_PROMOTEMARKET_YES"),
    functionYes = handleYesClick,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  })
end
function PaGlobalFunc_ServantRentPromoteMarketBuyRent(slotIndex)
  if ServantRentPromoteMarket:buyRent(slotIndex) then
    return ServantRentPromoteMarket:update()
  end
end
function ServantRentPromoteMarket:buyReturn(slotIndex)
  local goodsIndex = self:getGoodsIndex(slotIndex)
  local info = RequestGetAuctionInfo():getServantAuctionListAt(goodsIndex)
  if not info then
    return
  end
  local fromWhereType = self._useInventoryMoneyFlag and CppEnums.ItemWhereType.eInventory or CppEnums.ItemWhereType.eWarehouse
  function handleYesClick()
    ToClient_requestBuyItNowServantForReturn(goodsIndex, fromWhereType)
  end
  MessageBox.showMessageBox({
    title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_PRPOMOTEMARKET_RETURN_ALERT2"),
    functionYes = handleYesClick,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  })
end
function ServantRentPromoteMarket:forceReturn(slotIndex)
  local goodsIndex = self:getGoodsIndex(slotIndex)
  local info = RequestGetAuctionInfo():getServantAuctionListAt(goodsIndex)
  if not info then
    return
  end
  function handleYesClick()
    stable_returnServantToSomeWhereElse(info:getServantNo(), CppEnums.AuctionType.AuctionGoods_ServantReturn, CppEnums.TransferType.TransferType_Self)
  end
  MessageBox.showMessageBox({
    title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_PROMOTEMARKET_FORCERETURNDESC"),
    functionYes = handleYesClick,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  })
end
function PaGlobalFunc_ServantRentPromoteMarketForceReturn(slotIndex)
  if ServantRentPromoteMarket:forceReturn(slotIndex) then
    return ServantRentPromoteMarket:update()
  end
end
function PaGlobalFunc_ServantRentPromoteMarketBuyReturn(slotIndex)
  if ServantRentPromoteMarket:buyReturn(slotIndex) then
    return ServantRentPromoteMarket:update()
  end
end
function ServantRentPromoteMarket:cancelRent(slotIndex)
  local goodsIndex = self:getGoodsIndex(slotIndex)
  local info = RequestGetAuctionInfo():getServantAuctionListAt(goodsIndex)
  if not info then
    return
  end
  function handleYesClick()
    stable_cancelServantFromSomeWhereElse(goodsIndex, CppEnums.AuctionType.AuctionGoods_ServantRent)
  end
  MessageBox.showMessageBox({
    title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTCANCEL_DO"),
    functionYes = handleYesClick,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  })
end
function PaGlobalFunc_ServantRentPromoteMarketCancelRent(slotIndex)
  if ServantRentPromoteMarket:cancelRent(slotIndex) then
    return ServantRentPromoteMarket:update()
  end
end
function ServantRentPromoteMarket:receiveRent(slotIndex)
  local goodsIndex = self:getGoodsIndex(slotIndex)
  local info = RequestGetAuctionInfo():getServantAuctionListAt(goodsIndex)
  if not info then
    return
  end
  local fromWhereType = self._useInventoryMoneyFlag and CppEnums.ItemWhereType.eInventory or CppEnums.ItemWhereType.eWarehouse
  stable_popServantPrice(goodsIndex, CppEnums.AuctionType.AuctionGoods_ServantRent, fromWhereType)
end
function PaGlobalFunc_ServantRentPromoteMarketReceiveRent(slotIndex)
  if ServantRentPromoteMarket:receiveRent(slotIndex) then
    return ServantRentPromoteMarket:update()
  end
end
function ServantRentPromoteMarket:receiveReturn(slotIndex)
  local goodsIndex = self:getGoodsIndex(slotIndex)
  local info = RequestGetAuctionInfo():getServantAuctionListAt(goodsIndex)
  if not info then
    return
  end
  local fromWhereType = self._useInventoryMoneyFlag and CppEnums.ItemWhereType.eInventory or CppEnums.ItemWhereType.eWarehouse
  stable_popServantPrice(goodsIndex, CppEnums.AuctionType.AuctionGoods_ServantReturn, fromWhereType)
end
function PaGlobalFunc_ServantRentPromoteMarketReceiveReturn(slotIndex)
  if ServantRentPromoteMarket:receiveReturn(slotIndex) then
    return ServantRentPromoteMarket:update()
  end
end
function Panel_Stable_PromoteMarket_PopupDesc:open()
  if true == Panel_Stable_PromoteMarket_PopupDesc:GetShow() then
    Panel_Stable_PromoteMarket_PopupDesc:close()
  else
    Panel_Stable_PromoteMarket_PopupDesc:SetShow(true)
    Panel_Stable_PromoteMarket_PopupDesc:SetPosXY(Panel_Stable_PromoteMarket:GetPosX() + Panel_Stable_PromoteMarket:GetSizeX(), Panel_Stable_PromoteMarket:GetPosY())
  end
end
function Panel_Stable_PromoteMarket_PopupDesc:close()
  Panel_Stable_PromoteMarket_PopupDesc:SetShow(false)
end
Panel_Stable_PromoteMarket_PopupDesc:init()
registerEvent("FromClient_RentServant_ForceReturn_Success", "PaGlobalFunc_ServantRentPromoteMarketRefresh")
