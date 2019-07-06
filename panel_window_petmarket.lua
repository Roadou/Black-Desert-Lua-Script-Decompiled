Panel_Window_PetMarket:SetShow(false, false)
Panel_Window_PetMarket:setMaskingChild(true)
Panel_Window_PetMarket:ActiveMouseEventEffect(true)
Panel_Window_PetMarket:SetDragEnable(true)
Panel_Window_PetMarket:RegisterShowEventFunc(true, "PetMarketShowAni()")
Panel_Window_PetMarket:RegisterShowEventFunc(false, "PetMarketHideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
function PetMarketShowAni()
  local isShow = Panel_Window_PetMarket:IsShow()
  if isShow then
    Panel_Window_PetMarket:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
    local aniInfo1 = Panel_Window_PetMarket:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
    aniInfo1:SetStartIntensity(3)
    aniInfo1:SetEndIntensity(1)
    aniInfo1.IsChangeChild = true
    aniInfo1:SetHideAtEnd(true)
    aniInfo1:SetDisableWhileAni(true)
  else
    UIAni.fadeInSCR_Down(Panel_Window_PetMarket)
    Panel_Window_PetMarket:SetShow(true, false)
  end
end
function PetMarketHideAni()
  Panel_Window_PetMarket:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_PetMarket:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
function PetMarket_Resize()
  screenX = getScreenSizeX()
  screenY = getScreenSizeY()
end
local PetMarket = {
  _config = {
    slot = {
      startX = 0,
      startY = 10,
      gapY = 127
    },
    icon = {
      startX = 15,
      startY = 10,
      startValueX = 0,
      startValueY = 0,
      startKindX = -15,
      startKindY = -10,
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
      startX = 345,
      startY = 10,
      iconX = 10,
      iconY = 15,
      textX = 15,
      textY = 55,
      gapX = 69,
      count = 5
    },
    button = {startX = 710, startY = 10},
    slotCount = 4
  },
  _mainBG = UI.getChildControl(Panel_Window_PetMarket, "Static_MainBG"),
  _buttonQuestion = UI.getChildControl(Panel_Window_PetMarket, "Button_Question"),
  _buttonClose = UI.getChildControl(Panel_Window_PetMarket, "Button_Close"),
  _myMoneyValue = UI.getChildControl(Panel_Window_PetMarket, "Static_Text_Money"),
  _staticPageNo = UI.getChildControl(Panel_Window_PetMarket, "Static_PageNo"),
  _buttonNext = UI.getChildControl(Panel_Window_PetMarket, "Button_Next"),
  _buttonPrev = UI.getChildControl(Panel_Window_PetMarket, "Button_Prev"),
  _buttonTabMarket = UI.getChildControl(Panel_Window_PetMarket, "RadioButton_List"),
  _buttonTabMy = UI.getChildControl(Panel_Window_PetMarket, "RadioButton_ListMy"),
  _buttonBuy = UI.getChildControl(Panel_Window_PetMarket, "Button_Buy"),
  _buttonCancel = UI.getChildControl(Panel_Window_PetMarket, "Button_Cancel"),
  _buttonReceive = UI.getChildControl(Panel_Window_PetMarket, "Button_Receive"),
  _buttonEnd = UI.getChildControl(Panel_Window_PetMarket, "Button_End"),
  _slots = Array.new(),
  _selectSlotNo = nil,
  _selectPage = 0,
  _selectMaxPage = 0,
  _isTabMy = false
}
function PetMarket:init()
  for ii = 0, self._config.slotCount - 1 do
    local slot = {}
    slot._slotNo = ii
    slot._panel = Panel_Window_PetMarket
    slot._baseSlot = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_Slot", self._mainBG, "ServantMarket_Slot_" .. ii)
    slot._iconBack = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_IconBack", slot._baseSlot, "ServantMarket_Slot_IconBack_" .. ii)
    slot._icon = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_Icon", slot._iconBack, "ServantMarket_Slot_Icon_" .. ii)
    slot._iconMale = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_Male", slot._iconBack, "ServantMarket_Slot_Male_" .. ii)
    slot._iconFemale = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_Female", slot._iconBack, "ServantMarket_Slot_Female_" .. ii)
    slot._staticMatingCount = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_MatingCount", slot._iconBack, "ServantMarket_Slot_Count_" .. ii)
    slot._staticMatingCountValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_MatingCountValue", slot._iconBack, "ServantMarket_Slot_CountValue_" .. ii)
    slot._statusBack = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_StatusBack", slot._baseSlot, "ServantMarket_Slot_StatusBack_" .. ii)
    slot._staticLv = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_Lv", slot._statusBack, "ServantMarket_Slot_StatusLv_" .. ii)
    slot._staticLvValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_LvValue", slot._statusBack, "ServantMarket_Slot_StatusLvValue_" .. ii)
    slot._staticHp = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_Hp", slot._statusBack, "ServantMarket_Slot_StatusHp_" .. ii)
    slot._staticHpValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_HpValue", slot._statusBack, "ServantMarket_Slot_StatusHpValue_" .. ii)
    slot._staticStamina = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_Stamina", slot._statusBack, "ServantMarket_Slot_StatusStamina_" .. ii)
    slot._staticStaminaValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_StaminaValue", slot._statusBack, "ServantMarket_Slot_StatusStaminaValue_" .. ii)
    slot._staticWeight = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_Weight", slot._statusBack, "ServantMarket_Slot_StatusWeight_" .. ii)
    slot._staticWeightValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_WeightValue", slot._statusBack, "ServantMarket_Slot_StatusWeightValue_" .. ii)
    slot._staticPrice = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_Price", slot._statusBack, "ServantMarket_Slot_StatusPrice_" .. ii)
    slot._staticPriceValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_PriceValue", slot._statusBack, "ServantMarket_Slot_StatusPriceValue_" .. ii)
    slot._staticMoveSpeed = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_MoveSpeed", slot._statusBack, "ServantMarket_Slot_MoveSpeed" .. ii)
    slot._staticMoveSpeedValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_MoveSpeedValue", slot._statusBack, "ServantMarket_Slot_MoveSpeedValue" .. ii)
    slot._staticAcceleration = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_Acceleration", slot._statusBack, "ServantMarket_Slot_Acceleration" .. ii)
    slot._staticAccelerationValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_AccelerationValue", slot._statusBack, "ServantMarket_Slot_AccelerationValue" .. ii)
    slot._staticCornering = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_Cornering", slot._statusBack, "ServantMarket_Slot_Cornering" .. ii)
    slot._staticCorneringValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_CorneringValue", slot._statusBack, "ServantMarket_Slot_CorneringValue" .. ii)
    slot._staticBrake = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_Brake", slot._statusBack, "ServantMarket_Slot_Brake" .. ii)
    slot._staticBrakeValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_BrakeValue", slot._statusBack, "ServantMarket_Slot_BrakeValue" .. ii)
    slot._skillBack = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_SkillBack", slot._baseSlot, "ServantMarket_Slot_SkillBack_" .. ii)
    slot._skill = Array.new()
    for jj = 0, self._config.skill.count - 1 do
      local skill = {}
      skill._skillIcon = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_SkillIcon", slot._skillBack, "ServantMarket_Slot_SkillIcon_" .. ii .. "_" .. jj)
      skill._skillText = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Static_SkillText", slot._skillBack, "ServantMarket_Slot_SkillText_" .. ii .. "_" .. jj)
      slot._skill[jj] = skill
    end
    slot._buttonBuy = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Button_Buy", slot._baseSlot, "ServantMarket_Buy_" .. ii)
    slot._buttonCancel = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Button_Cancel", slot._baseSlot, "ServantMarket_Cancel_" .. ii)
    slot._buttonReceive = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Button_Receive", slot._baseSlot, "ServantMarket_Receive_" .. ii)
    slot._buttonEnd = UI.createAndCopyBasePropertyControl(Panel_Window_PetMarket, "Button_End", slot._baseSlot, "ServantMarket_End_" .. ii)
    local slotConfig = self._config.slot
    slot._baseSlot:SetPosX(slotConfig.startX)
    slot._baseSlot:SetPosY(slotConfig.startY + slotConfig.gapY * ii)
    local iconConfig = self._config.icon
    slot._iconBack:SetPosX(iconConfig.startX)
    slot._iconBack:SetPosY(iconConfig.startY)
    slot._icon:SetPosX(iconConfig.startValueX)
    slot._icon:SetPosY(iconConfig.startValueY)
    slot._iconMale:SetPosX(iconConfig.startKindX)
    slot._iconMale:SetPosY(iconConfig.startKindY)
    slot._iconFemale:SetPosX(iconConfig.startKindX)
    slot._iconFemale:SetPosY(iconConfig.startKindY)
    slot._staticMatingCount:SetPosX(iconConfig.startMatingX)
    slot._staticMatingCount:SetPosY(iconConfig.startMatingY)
    slot._staticMatingCountValue:SetPosX(iconConfig.startMatingX + iconConfig.gapMatingX)
    slot._staticMatingCountValue:SetPosY(iconConfig.startMatingY)
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
    slot._staticMoveSpeed:SetPosX(statConfig.startValueX + statConfig.gapX * 2)
    slot._staticMoveSpeed:SetPosY(statConfig.startValueY + statConfig.gapY * 0)
    slot._staticAcceleration:SetPosX(statConfig.startValueX + statConfig.gapX * 2)
    slot._staticAcceleration:SetPosY(statConfig.startValueY + statConfig.gapY * 1)
    slot._staticCornering:SetPosX(statConfig.startValueX + statConfig.gapX * 2)
    slot._staticCornering:SetPosY(statConfig.startValueY + statConfig.gapY * 2)
    slot._staticBrake:SetPosX(statConfig.startValueX + statConfig.gapX * 2)
    slot._staticBrake:SetPosY(statConfig.startValueY + statConfig.gapY * 3)
    slot._staticMoveSpeedValue:SetPosX(statConfig.startValueX + statConfig.gapX * 3)
    slot._staticMoveSpeedValue:SetPosY(statConfig.startValueY + statConfig.gapY * 0)
    slot._staticAccelerationValue:SetPosX(statConfig.startValueX + statConfig.gapX * 3)
    slot._staticAccelerationValue:SetPosY(statConfig.startValueY + statConfig.gapY * 1)
    slot._staticCorneringValue:SetPosX(statConfig.startValueX + statConfig.gapX * 3)
    slot._staticCorneringValue:SetPosY(statConfig.startValueY + statConfig.gapY * 2)
    slot._staticBrakeValue:SetPosX(statConfig.startValueX + statConfig.gapX * 3)
    slot._staticBrakeValue:SetPosY(statConfig.startValueY + statConfig.gapY * 3)
    slot._staticPrice:SetPosX(statConfig.startValueX + statConfig.gapX * 0)
    slot._staticPrice:SetPosY(statConfig.startValueY + statConfig.gapY * 4)
    slot._staticPriceValue:SetPosX(statConfig.startValueX + statConfig.gapX * 2)
    slot._staticPriceValue:SetPosY(statConfig.startValueY + statConfig.gapY * 4)
    local skillConfig = self._config.skill
    slot._skillBack:SetPosX(skillConfig.startX)
    slot._skillBack:SetPosY(skillConfig.startY)
    for jj = 0, self._config.skill.count - 1 do
      slot._skill[jj]._skillIcon:SetPosX(skillConfig.iconX + skillConfig.gapX * jj)
      slot._skill[jj]._skillIcon:SetPosY(skillConfig.iconY)
      slot._skill[jj]._skillText:SetPosX(skillConfig.textX + skillConfig.gapX * jj)
      slot._skill[jj]._skillText:SetPosY(skillConfig.textY)
    end
    local buttonConfig = self._config.button
    slot._buttonBuy:SetPosX(buttonConfig.startX)
    slot._buttonBuy:SetPosY(buttonConfig.startY)
    slot._buttonCancel:SetPosX(buttonConfig.startX)
    slot._buttonCancel:SetPosY(buttonConfig.startY)
    slot._buttonReceive:SetPosX(buttonConfig.startX)
    slot._buttonReceive:SetPosY(buttonConfig.startY)
    slot._buttonEnd:SetPosX(buttonConfig.startX)
    slot._buttonEnd:SetPosY(buttonConfig.startY)
    slot._buttonBuy:addInputEvent("Mouse_LUp", "PetMarket_Buy(" .. ii .. ")")
    slot._buttonCancel:addInputEvent("Mouse_LUp", "PetMarket_Cancel(" .. ii .. ")")
    slot._buttonReceive:addInputEvent("Mouse_LUp", "PetMarket_Receive(" .. ii .. ")")
    slot._buttonEnd:addInputEvent("Mouse_LUp", "PetMarket_Cancel(" .. ii .. ")")
    slot._buttonBuy:SetAutoDisableTime(4)
    slot._buttonCancel:SetAutoDisableTime(4)
    slot._buttonReceive:SetAutoDisableTime(4)
    slot._buttonEnd:SetAutoDisableTime(4)
    slot._baseSlot:SetShow(false)
    self._slots[ii] = slot
  end
end
function PetMarket:registEventHandler()
  self._buttonTabMarket:addInputEvent("Mouse_LUp", "PetMarket_TabEvent( false )")
  self._buttonTabMy:addInputEvent("Mouse_LUp", "PetMarket_TabEvent( true )")
  self._buttonNext:addInputEvent("Mouse_LUp", "PetMarket_NextPage()")
  self._buttonPrev:addInputEvent("Mouse_LUp", "PetMarket_PrevPage()")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowPetMarket\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowPetMarket\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindowPetMarket\", \"false\")")
  self._buttonClose:addInputEvent("Mouse_LUp", "PetMarket_Close()")
  self._buttonTabMarket:SetAutoDisableTime(4)
  self._buttonTabMy:SetAutoDisableTime(4)
  self._buttonNext:SetAutoDisableTime(4)
  self._buttonPrev:SetAutoDisableTime(4)
end
function PetMarket:registMessageHandler()
end
function PetMarket:update()
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local inventory = selfPlayer:getInventory()
  self._myMoneyValue:SetText(makeDotMoney(inventory:getMoney_s64()))
  for ii = 0, self._config.slotCount - 1 do
    local slot = self._slots[ii]
    slot._baseSlot:SetShow(false)
  end
  local myAuctionInfo = RequestGetAuctionInfo()
  local startSlotNo = 0
  local endSlotNo = 0
  if PetMarket_IsTabMy() then
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
    if nil ~= auctionServantInfo then
      local slot = self._slots[slotNo]
      slot._icon:ChangeTextureInfoName(auctionServantInfo:getIconPath1())
      slot._staticMatingCount:SetShow(true)
      slot._staticMatingCountValue:SetShow(true)
      slot._staticMatingCountValue:SetText(auctionServantInfo:getMatingCount())
      if auctionServantInfo:isMale() then
        slot._iconMale:SetShow(true)
        slot._iconFemale:SetShow(false)
      else
        slot._iconMale:SetShow(false)
        slot._iconFemale:SetShow(true)
      end
      slot._staticLvValue:SetText("-")
      slot._staticHpValue:SetText("-")
      slot._staticStaminaValue:SetText("-")
      slot._staticWeightValue:SetText("-")
      slot._staticMoveSpeed:SetShow(false)
      slot._staticAcceleration:SetShow(false)
      slot._staticCornering:SetShow(false)
      slot._staticBrake:SetShow(false)
      slot._staticMoveSpeedValue:SetShow(false)
      slot._staticAccelerationValue:SetShow(false)
      slot._staticCorneringValue:SetShow(false)
      slot._staticBrakeValue:SetShow(false)
      slot._staticPriceValue:SetText(tostring(auctionServantInfo:getAuctoinPrice_s64()))
      for ii = 0, self._config.skill.count - 1 do
        slot._skill[ii]._skillIcon:SetShow(false)
        slot._skill[ii]._skillText:SetShow(false)
      end
      local skillSlotNo = 0
      local learnSkillCount = vehicleSkillStaticStatus_skillCount()
      for jj = 1, learnSkillCount - 1 do
        if skillSlotNo < self._config.skill.count then
          local skillWrapper = auctionServantInfo:getSkill(jj)
          if nil ~= skillWrapper then
            slot._skill[skillSlotNo]._skillIcon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
            slot._skill[skillSlotNo]._skillText:SetText(skillWrapper:getName())
            slot._skill[skillSlotNo]._skillIcon:SetShow(true)
            slot._skill[skillSlotNo]._skillText:SetShow(true)
            skillSlotNo = skillSlotNo + 1
          end
        end
      end
      slot._buttonBuy:SetShow(false)
      slot._buttonCancel:SetShow(false)
      slot._buttonReceive:SetShow(false)
      slot._buttonEnd:SetShow(false)
      if PetMarket_IsTabMy() then
        slot._staticMatingCount:SetShow(false)
        slot._staticMatingCountValue:SetShow(false)
        local isAuctionEnd = auctionServantInfo:isAuctionEnd()
        local servantInfo = stable_getServantByServantNo(auctionServantInfo:getServantNo())
        if nil ~= servantInfo then
          if CppEnums.ServantStateType.Type_RegisterMarket == servantInfo:getStateType() then
            if isAuctionEnd then
              slot._buttonEnd:SetShow(true)
            else
              slot._buttonCancel:SetShow(true)
            end
          end
        else
          slot._buttonReceive:SetShow(true)
        end
      else
        slot._buttonBuy:SetShow(true)
      end
      slot._baseSlot:SetShow(true)
      slotNo = slotNo + 1
    end
  end
  if PetMarket_IsTabMy() then
    self._staticPageNo:SetText(self._selectPage + 1)
  else
    self._staticPageNo:SetText(myAuctionInfo:getCurrentPage() + 1)
  end
end
function PetMarket_IsTabMy()
  local self = PetMarket
  return self._isTabMy
end
function PetMarket_UpdateSlotData()
  local self = PetMarket
  self:update()
end
function PetMarket_TabEventFromRegister()
  if not Panel_Window_PetMarket:GetShow() then
    return
  end
  local self = PetMarket
  PetMarket_TabEventXXX(PetMarket_IsTabMy())
end
function PetMarket_TabEvent(isTabMy)
  local self = PetMarket
  if PetMarket_IsTabMy() == isTabMy then
    return
  end
  PetMarket_TabEventXXX(isTabMy)
end
function PetMarket_TabEventXXX(isTabMy)
  local self = PetMarket
  self._selectPage = 0
  self._selectMaxPage = 100
  self._isTabMy = isTabMy
  if PetMarket_IsTabMy() then
    requestMyServantMarketList()
  else
    RequestAuctionListPage(CppEnums.AuctionType.AuctionGoods_ServantMarket)
  end
end
function PetMarket_NextPage()
  local self = PetMarket
  if self._selectMaxPage <= self._selectPage then
    return
  end
  self._selectPage = self._selectPage + 1
  if PetMarket_IsTabMy() then
    self:update()
  else
    RequestAuctionNextPage()
  end
end
function PetMarket_PrevPage()
  local self = PetMarket
  if 0 < self._selectPage then
    self._selectPage = self._selectPage - 1
  end
  if PetMarket_IsTabMy() then
    self:update()
  else
    RequestAuctionPrevPage()
  end
end
function PetMarket_Buy(slotNo)
  local self = PetMarket
  self._selectSlotNo = slotNo
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_PET_BUY_NOTIFY")
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = PetMarket_BuyXXX,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PetMarket_BuyXXX()
  local self = PetMarket
  stable_requestBuyItNowServant(self._selectSlotNo)
  self._selectSlotNo = nil
end
function PetMarket_Cancel(slotNo)
  local self = PetMarket
  stable_cancelServantFromSomeWhereElse(slotNo, CppEnums.AuctionType.AuctionGoods_ServantMarket)
end
function PetMarket_Receive(slotNo)
  local self = PetMarket
  local selectSlotNo = self._selectPage * self._config.slotCount + slotNo
  stable_popServantPrice(selectSlotNo, CppEnums.AuctionType.AuctionGoods_ServantMarket)
end
function PetMarket_Open()
  Panel_Window_PetMarket:SetPosX(getScreenSizeX() / 2 - Panel_Window_PetMarket:GetSizeX() / 2)
  Panel_Window_PetMarket:SetPosY(getScreenSizeY() / 2 - Panel_Window_PetMarket:GetSizeY() / 2 - 30)
  if Panel_Window_PetMarket:GetShow() then
    return
  end
  if Panel_Window_PetMating:GetShow() then
    PetMating_Close()
  end
  local self = PetMarket
  self._selectSlotNo = nil
  self._selectPage = 0
  self._selectMaxPage = 100
  self._isTabMy = false
  self._buttonTabMy:SetCheck(true)
  self._buttonTabMarket:SetCheck(false)
  PetMarket_TabEvent(true)
  Panel_Window_PetMarket:SetShow(true)
end
function PetMarket_Close()
  if not Panel_Window_PetMarket:IsShow() then
    return
  end
  Panel_Window_PetMarket:SetShow(false)
end
PetMarket:init()
PetMarket:registEventHandler()
PetMarket:registMessageHandler()
PetMarket_Resize()
