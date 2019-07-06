Panel_Window_StableMating:SetShow(false, false)
Panel_Window_StableMating:setMaskingChild(true)
Panel_Window_StableMating:ActiveMouseEventEffect(true)
Panel_Window_StableMating:SetDragEnable(true)
Panel_Window_StableMating:RegisterShowEventFunc(true, "StableMatingShowAni()")
Panel_Window_StableMating:RegisterShowEventFunc(false, "StableMatingHideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local isContentsStallionEnable = ToClient_IsContentsGroupOpen("243")
local isContentsNineTierEnable = ToClient_IsContentsGroupOpen("80")
function StableMatingShowAni()
  local isShow = Panel_Window_StableMating:IsShow()
  if isShow then
    Panel_Window_StableMating:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
    local aniInfo1 = Panel_Window_StableMating:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
    aniInfo1:SetStartIntensity(3)
    aniInfo1:SetEndIntensity(1)
    aniInfo1.IsChangeChild = true
    aniInfo1:SetHideAtEnd(true)
    aniInfo1:SetDisableWhileAni(true)
  else
    UIAni.fadeInSCR_Down(Panel_Window_StableMating)
    Panel_Window_StableMating:SetShow(true, false)
  end
end
function StableMatingHideAni()
  Inventory_SetFunctor(nil)
  Panel_Window_StableMating:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_StableMating:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local stableMating = {
  _config = {
    slot = {
      startX = 10,
      startY = 10,
      gapY = 127
    },
    icon = {
      startX = 10,
      startY = 10,
      startValueX = 0,
      startValueY = 0,
      startKindX = 0,
      startKindY = 0,
      startMatingX = 0,
      startMatingY = 90,
      gapMatingX = 100,
      size = 150
    },
    stat = {
      startX = 120,
      startY = 10,
      startValueX = 10,
      startValueY = 0,
      startMoneyX = 0,
      startMoneyY = 0,
      gapX = 50,
      gapY = 20
    },
    skill = {
      startX = 330,
      startY = 10,
      iconX = 10,
      iconY = 15,
      textX = 0,
      textY = 55,
      gapX = 69,
      count = 5
    },
    button = {startX = 710, startY = 10},
    tab = {
      eNormal = 0,
      eMy = 1,
      eGroup = 2
    },
    slotCount = 4
  },
  _mainBG = UI.getChildControl(Panel_Window_StableMating, "Static_MainBG"),
  _buttonQuestion = UI.getChildControl(Panel_Window_StableMating, "Button_Question"),
  _buttonClose = UI.getChildControl(Panel_Window_StableMating, "Button_Close"),
  _buttonDisCountRate = UI.getChildControl(Panel_Window_StableMating, "Button_DiscountRate"),
  _staticPageNo = UI.getChildControl(Panel_Window_StableMating, "Static_PageNo"),
  _buttonNext = UI.getChildControl(Panel_Window_StableMating, "Button_Next"),
  _buttonPrev = UI.getChildControl(Panel_Window_StableMating, "Button_Prev"),
  _buttonTabMarket = UI.getChildControl(Panel_Window_StableMating, "RadioButton_List"),
  _buttonTabMy = UI.getChildControl(Panel_Window_StableMating, "RadioButton_ListMy"),
  _buttonTabGroup = UI.getChildControl(Panel_Window_StableMating, "RadioButton_Group"),
  _buttonStart = UI.getChildControl(Panel_Window_StableMating, "Button_Start"),
  _buttonMating = UI.getChildControl(Panel_Window_StableMating, "Button_Mating"),
  _buttonCancel = UI.getChildControl(Panel_Window_StableMating, "Button_Cancel"),
  _buttonReceive = UI.getChildControl(Panel_Window_StableMating, "Button_Receive"),
  _buttonEnd = UI.getChildControl(Panel_Window_StableMating, "Button_End"),
  _radioInven = UI.getChildControl(Panel_Window_StableMating, "RadioButton_Icon_Money"),
  _radioWarehouse = UI.getChildControl(Panel_Window_StableMating, "RadioButton_Icon_Money2"),
  _staticInven = UI.getChildControl(Panel_Window_StableMating, "Static_Text_Money"),
  _staticWarehouse = UI.getChildControl(Panel_Window_StableMating, "Static_Text_Money2"),
  _slots = Array.new(),
  _selectSlotNo = 0,
  _selectPage = 0,
  _selectMaxPage = 0,
  _currentTab = 0
}
function stableMating:init()
  for ii = 0, self._config.slotCount - 1 do
    local slot = {}
    slot._slotNo = ii
    slot._panel = Panel_Window_StableMating
    slot._startSlotIndex = 0
    slot._learnSkillCount = 0
    slot._baseSlot = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_Slot", self._mainBG, "ServantMating_Slot_" .. ii)
    slot._iconBack = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_IconBack", slot._baseSlot, "ServantMating_Slot_IconBack_" .. ii)
    slot._icon = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_Icon", slot._iconBack, "ServantMating_Slot_Icon_" .. ii)
    slot._grade = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "StaticText_Grade", slot._iconBack, "ServantMating_Slot_Grade_" .. ii)
    slot._iconMale = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_Male", slot._iconBack, "ServantMating_Slot_Male_" .. ii)
    slot._iconFemale = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_Female", slot._iconBack, "ServantMating_Slot_Female_" .. ii)
    slot._iconStallion = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_iconStallion", slot._iconBack, "ServantMating_Slot_iconStallion" .. ii)
    slot._statusBack = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_StatusBack", slot._baseSlot, "ServantMating_Slot_StatusBack_" .. ii)
    slot._staticLv = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_Lv", slot._statusBack, "ServantMating_Slot_StatusLv_" .. ii)
    slot._staticLvValue = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_LvValue", slot._statusBack, "ServantMating_Slot_StatusLvValue_" .. ii)
    slot._staticHp = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_Hp", slot._statusBack, "ServantMating_Slot_StatusHp_" .. ii)
    slot._staticHpValue = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_HpValue", slot._statusBack, "ServantMating_Slot_StatusHpValue_" .. ii)
    slot._staticStamina = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_Stamina", slot._statusBack, "ServantMating_Slot_StatusStamina_" .. ii)
    slot._staticStaminaValue = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_StaminaValue", slot._statusBack, "ServantMating_Slot_StatusStaminaValue_" .. ii)
    slot._staticWeight = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_Weight", slot._statusBack, "ServantMating_Slot_StatusWeight_" .. ii)
    slot._staticWeightValue = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_WeightValue", slot._statusBack, "ServantMating_Slot_StatusWeightValue_" .. ii)
    slot._staticPrice = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_Price", slot._statusBack, "ServantMating_Slot_StatusPrice_" .. ii)
    slot._staticPriceValue = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_PriceValue", slot._statusBack, "ServantMating_Slot_StatusPriceValue_" .. ii)
    slot._staticMoveSpeed = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_MoveSpeed", slot._statusBack, "ServantMating_Slot_MoveSpeed" .. ii)
    slot._staticMoveSpeedValue = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_MoveSpeedValue", slot._statusBack, "ServantMating_Slot_MoveSpeedValue" .. ii)
    slot._staticAcceleration = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_Acceleration", slot._statusBack, "ServantMating_Slot_Acceleration" .. ii)
    slot._staticAccelerationValue = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_AccelerationValue", slot._statusBack, "ServantMating_Slot_AccelerationValue" .. ii)
    slot._staticCornering = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_Cornering", slot._statusBack, "ServantMating_Slot_Cornering" .. ii)
    slot._staticCorneringValue = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_CorneringValue", slot._statusBack, "ServantMating_Slot_CorneringValue" .. ii)
    slot._staticBrake = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_Brake", slot._statusBack, "ServantMating_Slot_Brake" .. ii)
    slot._staticBrakeValue = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_BrakeValue", slot._statusBack, "ServantMating_Slot_BrakeValue" .. ii)
    slot._skillBack = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_SkillBack", slot._baseSlot, "ServantMating_Slot_SkillBack_" .. ii)
    slot.skillNextPage = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Button_NextPage", slot._skillBack, "ServantMating_Slot_SkillNextPage_" .. ii)
    slot.skillPrevPage = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Button_PrevPage", slot._skillBack, "ServantMating_Slot_SkillPrevPage_" .. ii)
    slot.skillPageValue = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "StaticText_PageValue", slot._skillBack, "ServantMating_Slot_SkillPageValue_" .. ii)
    slot._staticDeadCount = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "StaticText_DeadCount", slot._statusBack, "ServantMarket_Slot_DeadCount_" .. ii)
    slot._staticDeadCountValue = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "StaticText_DeadCountValue", slot._statusBack, "ServantMarket_Slot_DeadCountValue_" .. ii)
    slot._skill = Array.new()
    for jj = 0, self._config.skill.count - 1 do
      local skill = {}
      skill._expBG = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_Texture_Learn_Background", slot._skillBack, "ServantMating_Slot_SkillExpBG_" .. ii .. "_" .. jj)
      skill._exp = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "SkillLearn_Gauge", slot._skillBack, "ServantMating_Slot_SkillExp_" .. ii .. "_" .. jj)
      skill._skillIcon = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_SkillIcon", slot._skillBack, "ServantMating_Slot_SkillIcon_" .. ii .. "_" .. jj)
      skill._skillText = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Static_SkillText", slot._skillBack, "ServantMating_Slot_SkillText_" .. ii .. "_" .. jj)
      skill._expText = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "SkillLearn_PercentString", slot._skillBack, "ServantMating_Slot_SkillExpStr_" .. ii .. "_" .. jj)
      slot._skill[jj] = skill
    end
    slot._buttonStart = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Button_Start", slot._baseSlot, "ServantMating_Start_" .. ii)
    slot._buttonStart:SetTextMode(UI_TM.eTextMode_AutoWrap)
    slot._buttonStart:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMATING_BTN_START"))
    slot._buttonMating = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Button_Mating", slot._baseSlot, "ServantMating_Mating_" .. ii)
    slot._buttonMating:SetTextMode(UI_TM.eTextMode_AutoWrap)
    slot._buttonMating:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMATING_BTN_MATING"))
    slot._buttonCancel = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Button_Cancel", slot._baseSlot, "ServantMating_Cancel_" .. ii)
    slot._buttonCancel:SetTextMode(UI_TM.eTextMode_AutoWrap)
    slot._buttonCancel:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMATING_BTN_CANCEL"))
    slot._buttonReceive = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Button_Receive", slot._baseSlot, "ServantMating_Receive_" .. ii)
    slot._buttonReceive:SetTextMode(UI_TM.eTextMode_AutoWrap)
    slot._buttonReceive:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMATING_BTN_RECEIVE"))
    slot._buttonEnd = UI.createAndCopyBasePropertyControl(Panel_Window_StableMating, "Button_End", slot._baseSlot, "ServantMating_End_" .. ii)
    slot._buttonEnd:SetTextMode(UI_TM.eTextMode_AutoWrap)
    slot._buttonEnd:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMATING_BTN_END"))
    local slotConfig = self._config.slot
    slot._baseSlot:SetPosX(slotConfig.startX)
    slot._baseSlot:SetPosY(slotConfig.startY + slotConfig.gapY * ii)
    local iconConfig = self._config.icon
    slot._iconBack:SetPosX(iconConfig.startX)
    slot._iconBack:SetPosY(iconConfig.startY)
    slot._icon:SetPosX(iconConfig.startValueX)
    slot._icon:SetPosY(iconConfig.startValueY)
    slot._grade:SetPosX(iconConfig.startKindX + 45)
    slot._grade:SetPosY(iconConfig.startKindY + 0)
    slot._iconMale:SetPosX(iconConfig.startKindX)
    slot._iconMale:SetPosY(iconConfig.startKindY)
    slot._iconFemale:SetPosX(iconConfig.startKindX)
    slot._iconFemale:SetPosY(iconConfig.startKindY)
    slot._iconStallion:SetPosX(iconConfig.startKindX + 20)
    slot._iconStallion:SetPosY(iconConfig.startKindY + 3)
    local statConfig = self._config.stat
    slot._statusBack:SetPosX(statConfig.startX)
    slot._statusBack:SetPosY(statConfig.startY)
    slot._staticLv:SetPosX(statConfig.startValueX + statConfig.gapX * 0)
    slot._staticLv:SetPosY(statConfig.startValueY + statConfig.gapY * 0)
    slot._staticHp:SetPosX(statConfig.startValueX + statConfig.gapX * 0)
    slot._staticHp:SetPosY(statConfig.startValueY + statConfig.gapY * 1)
    slot._staticStamina:SetPosX(statConfig.startValueX + statConfig.gapX * 0)
    slot._staticStamina:SetPosY(statConfig.startValueY + statConfig.gapY * 2)
    slot._staticWeight:SetPosX(statConfig.startValueX + statConfig.gapX * 0)
    slot._staticWeight:SetPosY(statConfig.startValueY + statConfig.gapY * 3)
    slot._staticLvValue:SetPosX(statConfig.startValueX + statConfig.gapX * 1)
    slot._staticLvValue:SetPosY(statConfig.startValueY + statConfig.gapY * 0)
    slot._staticHpValue:SetPosX(statConfig.startValueX + statConfig.gapX * 1)
    slot._staticHpValue:SetPosY(statConfig.startValueY + statConfig.gapY * 1)
    slot._staticStaminaValue:SetPosX(statConfig.startValueX + statConfig.gapX * 1)
    slot._staticStaminaValue:SetPosY(statConfig.startValueY + statConfig.gapY * 2)
    slot._staticWeightValue:SetPosX(statConfig.startValueX + statConfig.gapX * 1)
    slot._staticWeightValue:SetPosY(statConfig.startValueY + statConfig.gapY * 3)
    slot._staticMoveSpeed:SetPosX(statConfig.startValueX + statConfig.gapX * 2 + 10)
    slot._staticMoveSpeed:SetPosY(statConfig.startValueY + statConfig.gapY * 0)
    slot._staticAcceleration:SetPosX(statConfig.startValueX + statConfig.gapX * 2 + 10)
    slot._staticAcceleration:SetPosY(statConfig.startValueY + statConfig.gapY * 1)
    slot._staticCornering:SetPosX(statConfig.startValueX + statConfig.gapX * 2 + 10)
    slot._staticCornering:SetPosY(statConfig.startValueY + statConfig.gapY * 2)
    slot._staticBrake:SetPosX(statConfig.startValueX + statConfig.gapX * 2 + 10)
    slot._staticBrake:SetPosY(statConfig.startValueY + statConfig.gapY * 3)
    slot._staticMoveSpeedValue:SetPosX(statConfig.startValueX + statConfig.gapX * 3 + 10)
    slot._staticMoveSpeedValue:SetPosY(statConfig.startValueY + statConfig.gapY * 0)
    slot._staticAccelerationValue:SetPosX(statConfig.startValueX + statConfig.gapX * 3 + 10)
    slot._staticAccelerationValue:SetPosY(statConfig.startValueY + statConfig.gapY * 1)
    slot._staticCorneringValue:SetPosX(statConfig.startValueX + statConfig.gapX * 3 + 10)
    slot._staticCorneringValue:SetPosY(statConfig.startValueY + statConfig.gapY * 2)
    slot._staticBrakeValue:SetPosX(statConfig.startValueX + statConfig.gapX * 3 + 10)
    slot._staticBrakeValue:SetPosY(statConfig.startValueY + statConfig.gapY * 3)
    slot._staticPrice:SetPosX(statConfig.startValueX + statConfig.gapX * 0)
    slot._staticPrice:SetPosY(statConfig.startValueY + statConfig.gapY * 4 + 5)
    slot._staticPriceValue:SetPosX(statConfig.startValueX + statConfig.gapX * 1.6)
    slot._staticPriceValue:SetPosY(statConfig.startValueY + statConfig.gapY * 4 + 5)
    slot._staticDeadCount:SetPosX(statConfig.startValueX + statConfig.gapX * 3.3)
    slot._staticDeadCount:SetPosY(statConfig.startValueY + statConfig.gapY * 3.9 + 5)
    slot._staticDeadCountValue:SetPosX(statConfig.startValueX + statConfig.gapX * 4.8)
    slot._staticDeadCountValue:SetPosY(statConfig.startValueY + statConfig.gapY * 3.9 + 5)
    local skillConfig = self._config.skill
    slot._skillBack:SetPosX(skillConfig.startX + 20)
    slot._skillBack:SetPosY(skillConfig.startY)
    slot.skillPrevPage:SetPosX(slot._skillBack:GetSizeX())
    slot.skillPrevPage:SetPosY(skillConfig.startY)
    slot.skillPageValue:SetPosX(slot._skillBack:GetSizeX())
    slot.skillPageValue:SetPosY(skillConfig.startY + slot.skillPrevPage:GetSizeY())
    slot.skillNextPage:SetPosX(slot._skillBack:GetSizeX())
    slot.skillNextPage:SetPosY(slot.skillPageValue:GetPosY() + slot.skillPageValue:GetSizeY())
    for jj = 0, self._config.skill.count - 1 do
      slot._skill[jj]._expBG:SetPosX(skillConfig.iconX + skillConfig.gapX * jj - 5 + 10)
      slot._skill[jj]._expBG:SetPosY(skillConfig.iconY - 13)
      slot._skill[jj]._exp:SetPosX(skillConfig.iconX + skillConfig.gapX * jj - 3 + 10)
      slot._skill[jj]._exp:SetPosY(skillConfig.iconY - 13)
      slot._skill[jj]._skillIcon:SetPosX(skillConfig.iconX + skillConfig.gapX * jj + 10)
      slot._skill[jj]._skillIcon:SetPosY(skillConfig.iconY - 10)
      slot._skill[jj]._skillText:SetPosX(skillConfig.textX + skillConfig.gapX * jj + 10)
      slot._skill[jj]._skillText:SetPosY(skillConfig.textY - 10)
      slot._skill[jj]._expText:SetPosX(skillConfig.iconX + skillConfig.gapX * jj + 20 + 10)
      slot._skill[jj]._expText:SetPosY(skillConfig.iconY + 20)
      slot._skill[jj]._skillIcon:addInputEvent("Mouse_UpScroll", "StableMating_ScrollEvent(" .. ii .. ", true)")
      slot._skill[jj]._skillIcon:addInputEvent("Mouse_DownScroll", "StableMating_ScrollEvent(" .. ii .. ", false)")
    end
    local buttonConfig = self._config.button
    slot._buttonStart:SetPosX(buttonConfig.startX + 20)
    slot._buttonStart:SetPosY(buttonConfig.startY)
    slot._buttonMating:SetPosX(buttonConfig.startX + 20)
    slot._buttonMating:SetPosY(buttonConfig.startY)
    slot._buttonCancel:SetPosX(buttonConfig.startX + 20)
    slot._buttonCancel:SetPosY(buttonConfig.startY)
    slot._buttonReceive:SetPosX(buttonConfig.startX + 20)
    slot._buttonReceive:SetPosY(buttonConfig.startY)
    slot._buttonEnd:SetPosX(buttonConfig.startX + 20)
    slot._buttonEnd:SetPosY(buttonConfig.startY)
    slot._buttonStart:addInputEvent("Mouse_LUp", "StableMating_Mating(" .. ii .. ")")
    slot._buttonCancel:addInputEvent("Mouse_LUp", "StableMating_Cancel(" .. ii .. ")")
    slot._buttonEnd:addInputEvent("Mouse_LUp", "StableMating_Cancel(" .. ii .. ")")
    slot._buttonReceive:addInputEvent("Mouse_LUp", "StableMating_Receive(" .. ii .. ")")
    slot._baseSlot:addInputEvent("Mouse_UpScroll", "StableMating_ScrollEvent(" .. ii .. ", true)")
    slot._baseSlot:addInputEvent("Mouse_DownScroll", "StableMating_ScrollEvent(" .. ii .. ", false)")
    slot._buttonStart:SetAutoDisableTime(4)
    slot._buttonCancel:SetAutoDisableTime(4)
    slot._buttonEnd:SetAutoDisableTime(4)
    slot._buttonReceive:SetAutoDisableTime(4)
    slot._baseSlot:SetShow(false)
    self._slots[ii] = slot
  end
end
function PaGlobalFunc_StableMating_DisCountRateToolTip(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  if nil == stableMating then
    UI.ASSERT_NAME(nil ~= stableMating, "stableMating\234\176\128 \236\132\160\236\150\184\235\144\152\236\167\128 \236\149\138\236\149\152\236\138\181\235\139\136\235\139\164.", "\234\185\128\236\157\152\236\167\132")
    return
  end
  if nil == ToClient_GetServantMarketTaxPercent() then
    UI.ASSERT_NAME(nil ~= ToClient_GetServantMarketTaxPercent(), "ToClient_GetServantMarketTaxPercent()\234\176\128 nil", "\234\185\128\236\157\152\236\167\132")
    return
  end
  local disCountRate = ToClient_GetServantMarketTaxPercent() / 10000
  local control = stableMating._buttonDisCountRate
  local name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMARKET_DISCOUNT_TOOLTIP_NAME")
  local desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEMARKET_DISCOUNT_BTN_TOOLTIP_DESC", "rate", disCountRate)
  TooltipSimple_Show(control, name, desc)
end
function stableMating:updateSlot(isClear)
  StableMating_UpdateMoney()
  for ii = 0, self._config.slotCount - 1 do
    local slot = self._slots[ii]
    if isClear then
      slot._learnSkillCount = 0
      slot._startSlotIndex = 0
    end
    slot._baseSlot:SetShow(false)
    slot.skillPrevPage:SetShow(false)
    slot.skillNextPage:SetShow(false)
    slot.skillPageValue:SetShow(false)
    slot._iconStallion:SetShow(false)
  end
  local myAuctionInfo = RequestGetAuctionInfo()
  local startSlotNo = 0
  local endSlotNo = 0
  if self._config.tab.eMy == StableMating_CurrentTab() then
    startSlotNo = self._selectPage * self._config.slotCount
    endSlotNo = startSlotNo + self._config.slotCount - 1
    local maxCount = myAuctionInfo:getServantAuctionListCount()
    self._selectMaxPage = math.floor(maxCount / self._config.slotCount) - 1
    if 0 < maxCount % self._config.slotCount then
      self._selectMaxPage = self._selectMaxPage + 1
    end
  else
    startSlotNo = 0
    endSlotNo = myAuctionInfo:getServantAuctionListCount() - 1
  end
  local slotNo = 0
  for ii = startSlotNo, endSlotNo do
    local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(ii)
    if nil ~= auctionServantInfo and slotNo < self._config.slotCount then
      local slot = self._slots[slotNo]
      slot._icon:ChangeTextureInfoName(auctionServantInfo:getIconPath1())
      if auctionServantInfo:isMale() then
        slot._iconMale:SetShow(true)
        slot._iconFemale:SetShow(false)
      else
        slot._iconMale:SetShow(false)
        slot._iconFemale:SetShow(true)
      end
      if 9 == auctionServantInfo:getTier() and isContentsStallionEnable then
        slot._grade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9"))
        slot._iconStallion:SetShow(false)
      else
        slot._grade:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", auctionServantInfo:getTier()))
        if isContentsStallionEnable then
          slot._iconStallion:SetShow(true)
          local isStallion = auctionServantInfo:isStallion()
          if true == isStallion then
            slot._iconStallion:SetMonoTone(false)
          else
            slot._iconStallion:SetMonoTone(true)
          end
        end
      end
      slot._staticLvValue:SetText(auctionServantInfo:getLevel())
      slot._staticHpValue:SetText(auctionServantInfo:getMaxHp())
      slot._staticStaminaValue:SetText(auctionServantInfo:getMaxMp())
      slot._staticWeightValue:SetText(tostring(auctionServantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000))
      slot._staticMoveSpeedValue:SetText(string.format("%.1f", auctionServantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
      slot._staticAccelerationValue:SetText(string.format("%.1f", auctionServantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
      slot._staticCorneringValue:SetText(string.format("%.1f", auctionServantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
      slot._staticBrakeValue:SetText(string.format("%.1f", auctionServantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
      slot._staticPriceValue:SetText(makeDotMoney(auctionServantInfo:getAuctoinPrice_s64()))
      local deadCount = auctionServantInfo:getDeadCount()
      slot._staticDeadCountValue:SetText(deadCount)
      for ii = 0, self._config.skill.count - 1 do
        slot._skill[ii]._expBG:SetShow(false)
        slot._skill[ii]._skillIcon:SetShow(false)
        slot._skill[ii]._skillText:SetShow(false)
        slot._skill[ii]._exp:SetShow(false)
        slot._skill[ii]._expText:SetShow(false)
      end
      slot._learnSkillCount = 0
      local skillSlotNo = 0
      local tempIndex = 0
      local learnSkillCount = vehicleSkillStaticStatus_skillCount()
      for jj = 1, learnSkillCount - 1 do
        local skillWrapper = auctionServantInfo:getSkill(jj)
        if nil ~= skillWrapper then
          if skillSlotNo < self._config.skill.count then
            if tempIndex >= slot._startSlotIndex then
              local expTxt = tonumber(string.format("%.0f", auctionServantInfo:getSkillExp(jj) / (skillWrapper:get()._maxExp / 100)))
              if expTxt >= 100 then
                expTxt = 100
              end
              slot._skill[skillSlotNo]._skillIcon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
              slot._skill[skillSlotNo]._skillText:SetTextMode(UI_TM.eTextMode_AutoWrap)
              slot._skill[skillSlotNo]._skillText:SetText(skillWrapper:getName())
              slot._skill[skillSlotNo]._exp:SetProgressRate(auctionServantInfo:getSkillExp(jj) / (skillWrapper:get()._maxExp / 100))
              slot._skill[skillSlotNo]._expText:SetText(expTxt .. "%")
              slot._skill[skillSlotNo]._expBG:SetShow(true)
              slot._skill[skillSlotNo]._exp:SetShow(true)
              slot._skill[skillSlotNo]._expText:SetShow(true)
              slot._skill[skillSlotNo]._skillIcon:SetShow(true)
              slot._skill[skillSlotNo]._skillText:SetShow(true)
              skillSlotNo = skillSlotNo + 1
            end
            tempIndex = tempIndex + 1
          end
          slot._learnSkillCount = slot._learnSkillCount + 1
        end
      end
      if slot._learnSkillCount > 5 then
        slot.skillPageValue:SetText(string.format("%.0f", slot._startSlotIndex / self._config.skill.count) + 1)
        slot.skillPrevPage:addInputEvent("Mouse_LUp", "StableMating_ScrollEvent( " .. ii .. ", true )")
        slot.skillNextPage:addInputEvent("Mouse_LUp", "StableMating_ScrollEvent( " .. ii .. ", false )")
        slot.skillPrevPage:SetShow(true)
        slot.skillNextPage:SetShow(true)
        slot.skillPageValue:SetShow(true)
      end
      slot._buttonStart:SetShow(false)
      slot._buttonMating:SetShow(false)
      slot._buttonCancel:SetShow(false)
      slot._buttonReceive:SetShow(false)
      slot._buttonEnd:SetShow(false)
      if self._config.tab.eMy == StableMating_CurrentTab() then
        local isAuctionEnd = auctionServantInfo:isAuctionEnd()
        local servantInfo = stable_getServantByServantNo(auctionServantInfo:getServantNo())
        if nil ~= servantInfo then
          if CppEnums.ServantStateType.Type_RegisterMating == servantInfo:getStateType() then
            if isAuctionEnd then
              slot._buttonEnd:SetShow(true)
            else
              slot._buttonCancel:SetShow(true)
            end
          elseif CppEnums.ServantStateType.Type_Mating == servantInfo:getStateType() then
            if servantInfo:isMatingComplete() then
              slot._buttonReceive:SetShow(true)
            else
              slot._buttonMating:SetShow(true)
            end
          end
        end
      else
        slot._buttonStart:SetShow(true)
      end
      slot._baseSlot:SetShow(true)
      slotNo = slotNo + 1
    end
  end
  if self._config.tab.eMy == StableMating_CurrentTab() then
    self._staticPageNo:SetText(self._selectPage + 1)
  else
    self._staticPageNo:SetText(myAuctionInfo:getCurrentPage() + 1)
  end
end
function StableMating_SimpleTooltips(tipType, isShow)
  local name, desc, control
  local self = stableMating
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_INVEN_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_INVEN_DESC")
    control = self._radioInven
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_WAREHOUSE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_WAREHOUSE_DESC")
    control = self._radioWarehouse
  end
  if true == isShow then
    registTooltipControl(control, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function stableMating:registEventHandler()
  self._buttonTabMarket:addInputEvent("Mouse_LUp", "StableMating_TabEvent( 0 )")
  self._buttonTabMy:addInputEvent("Mouse_LUp", "StableMating_TabEvent( 1 )")
  self._buttonTabGroup:addInputEvent("Mouse_LUp", "StableMating_TabEvent( 2 )")
  self._buttonNext:addInputEvent("Mouse_LUp", "StableMating_NextPage()")
  self._buttonPrev:addInputEvent("Mouse_LUp", "StableMating_PrevPage()")
  self._buttonDisCountRate:addInputEvent("Mouse_On", "PaGlobalFunc_StableMating_DisCountRateToolTip(true)")
  self._buttonDisCountRate:addInputEvent("Mouse_Out", "PaGlobalFunc_StableMating_DisCountRateToolTip(false)")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowStableMating\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowStableMating\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindowStableMating\", \"false\")")
  self._buttonClose:addInputEvent("Mouse_LUp", "StableMating_Close()")
  self._radioInven:addInputEvent("Mouse_On", "StableMating_SimpleTooltips( 0, true )")
  self._radioInven:addInputEvent("Mouse_Out", "StableMating_SimpleTooltips( false )")
  self._radioWarehouse:addInputEvent("Mouse_On", "StableMating_SimpleTooltips( 1, true )")
  self._radioWarehouse:addInputEvent("Mouse_Out", "StableMating_SimpleTooltips( false )")
  self._radioInven:setTooltipEventRegistFunc("StableMating_SimpleTooltips( 0, true )")
  self._radioWarehouse:setTooltipEventRegistFunc("StableMating_SimpleTooltips( 1, true )")
  self._buttonTabMarket:SetAutoDisableTime(4)
  self._buttonTabMy:SetAutoDisableTime(4)
  self._buttonTabGroup:SetAutoDisableTime(4)
  self._buttonNext:SetAutoDisableTime(4)
  self._buttonPrev:SetAutoDisableTime(4)
end
function stableMating:registMessageHandler()
  registerEvent("onScreenResize", "StableMating_Resize")
  registerEvent("FromClient_AuctionServantList", "StableMating_UpdateSlotData")
  registerEvent("FromClient_ServantRegisterToAuction", "StableMating_TabEventFromRegister")
  registerEvent("FromClient_InventoryUpdate", "StableMating_UpdateMoney")
  registerEvent("EventWarehouseUpdate", "StableMating_UpdateMoney")
end
function StableMating_Resize()
  local self = stableMating
  screenX = getScreenSizeX()
  screenY = getScreenSizeY()
end
function StableMating_CurrentTab()
  local self = stableMating
  return self._currentTab
end
function StableMating_TransferType(tab)
  local self = stableMating
  local transferType = CppEnums.TransferType.TransferType_Normal
  if self._config.tab.eGroup == tab then
    transferType = CppEnums.TransferType.TransferType_Self
  end
  return transferType
end
function StableMating_UpdateSlotData()
  if not Panel_Window_StableMating:GetShow() then
    return
  end
  local self = stableMating
  self:updateSlot(true)
end
function StableMating_TabEventFromRegister()
  if not Panel_Window_StableMating:GetShow() then
    return
  end
  local self = stableMating
  StableMating_TabEventXXX(StableMating_CurrentTab())
end
function StableMating_UpdateMoney()
  if true == _ContentsGroup_InvenUpdateCheck and false == Panel_Window_StableMating:GetShow() then
    return
  end
  local self = stableMating
  self._staticInven:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  local warehouseMoney = warehouse_moneyFromNpcShop_s64()
  self._staticWarehouse:SetText(makeDotMoney(warehouseMoney))
  local warehouseMoneyEnabledFlag = warehouseMoney > Defines.s64_const.s64_0
  self._radioWarehouse:SetEnable(warehouseMoneyEnabledFlag)
  if not warehouseMoneyEnabledFlag then
    self._radioInven:SetCheck(true)
    self._radioWarehouse:SetCheck(false)
  end
end
function StableMating_TabEvent(tab)
  local self = stableMating
  if StableMating_CurrentTab() == tab then
    return
  end
  StableMating_TabEventXXX(tab)
end
function StableMating_TabEventXXX(tab)
  local self = stableMating
  self._selectPage = 0
  self._selectMaxPage = 100
  self._currentTab = tab
  if self._config.tab.eMy == StableMating_CurrentTab() then
    requestMyServantMatingList()
  else
    requestServantMatingListPage(StableMating_TransferType(StableMating_CurrentTab()))
  end
end
function StableMating_NextPage()
  audioPostEvent_SystemUi(0, 0)
  local self = stableMating
  if self._selectMaxPage <= self._selectPage then
    return
  end
  self._selectPage = self._selectPage + 1
  if self._config.tab.eMy == StableMating_CurrentTab() then
    self:updateSlot()
  else
    RequestAuctionNextPage(StableMating_TransferType(StableMating_CurrentTab()))
  end
end
function StableMating_PrevPage()
  audioPostEvent_SystemUi(0, 0)
  local self = stableMating
  if 0 < self._selectPage then
    self._selectPage = self._selectPage - 1
  end
  if self._config.tab.eMy == StableMating_CurrentTab() then
    self:updateSlot()
  else
    RequestAuctionPrevPage(StableMating_TransferType(StableMating_CurrentTab()))
  end
end
function StableMating_Mating(slotNo)
  local self = stableMating
  self._selectSlotNo = slotNo
  local _listSelectSlot = StableList_SelectSlotNo()
  if nil == _listSelectSlot then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABLE_MATING_PLZSELECT"))
    return
  end
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_MATING_NOTIFY")
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = StableMating_MatingXXX,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function StableMating_MatingXXX()
  local self = stableMating
  local transferType = StableMating_TransferType(StableMating_CurrentTab())
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  if self._radioWarehouse:IsCheck() then
    fromWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  stable_startServantMating(StableList_SelectSlotNo(), self._selectSlotNo, transferType, fromWhereType)
  self._selectSlotNo = nil
end
function StableMating_Cancel(slotNo)
  local function stableMating_CancelDo()
    local selectSlotNo = stableMating._selectPage * stableMating._config.slotCount + slotNo
    stable_cancelServantFromSomeWhereElse(selectSlotNo, CppEnums.AuctionType.AuctionGoods_ServantMating)
  end
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTCANCEL_DO")
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = stableMating_CancelDo,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function StableMating_Receive(slotNo)
  local self = stableMating
  local selectSlotNo = self._selectPage * self._config.slotCount + slotNo
  local toWhereType = CppEnums.ItemWhereType.eInventory
  if self._radioWarehouse:IsCheck() then
    toWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  stable_popServantPrice(selectSlotNo, CppEnums.AuctionType.AuctionGoods_ServantMating, toWhereType)
end
function StableMating_ScrollEvent(slotNo, isUp)
  local self = stableMating
  local slot = self._slots[slotNo]
  local maxSlotNo = slot._learnSkillCount - self._config.skill.count
  if isUp then
    if 0 < slot._startSlotIndex then
      slot._startSlotIndex = slot._startSlotIndex - self._config.skill.count
    end
  elseif maxSlotNo > slot._startSlotIndex then
    slot._startSlotIndex = slot._startSlotIndex + self._config.skill.count
  end
  self:updateSlot(false)
end
function StableMating_Open()
  local self = stableMating
  Panel_Window_StableMating:SetPosX(getScreenSizeX() / 2 - Panel_Window_StableMating:GetSizeX() / 2)
  Panel_Window_StableMating:SetPosY(getScreenSizeY() / 2 - Panel_Window_StableMating:GetSizeY() / 2 - 10)
  if Panel_Window_StableMating:GetShow() then
    return
  end
  if Panel_Window_StableMarket:GetShow() then
    StableMarket_Close()
  end
  if Panel_Window_StableMix:GetShow() then
    StableMix_Close()
  end
  PaGlobalFunc_ServantRentPromoteMarketClose()
  warehouse_requestInfoFromNpc()
  self._radioInven:SetEnableArea(0, 0, 230, self._radioInven:GetSizeY())
  self._radioWarehouse:SetEnableArea(0, 0, 230, self._radioInven:GetSizeY())
  self._radioInven:SetCheck(false)
  self._radioWarehouse:SetCheck(true)
  self._selectSlotNo = nil
  self._selectPage = 0
  self._selectMaxPage = 100
  self._currentTab = self._config.tab.eMy
  self._buttonTabMy:SetCheck(false)
  self._buttonTabMarket:SetCheck(true)
  self._buttonTabGroup:SetCheck(false)
  StableMating_TabEvent(self._config.tab.eNormal)
  Panel_Window_StableMating:SetShow(true)
end
function StableMating_Close()
  if not Panel_Window_StableMating:GetShow() then
    return
  end
  Panel_Window_StableMating:SetShow(false)
end
stableMating:init()
stableMating:registEventHandler()
stableMating:registMessageHandler()
StableMating_Resize()
