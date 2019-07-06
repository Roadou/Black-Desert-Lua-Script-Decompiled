Panel_Window_PetMating:SetShow(false, false)
Panel_Window_PetMating:setMaskingChild(true)
Panel_Window_PetMating:ActiveMouseEventEffect(true)
Panel_Window_PetMating:SetDragEnable(true)
Panel_Window_PetMating:RegisterShowEventFunc(true, "PetMatingShowAni()")
Panel_Window_PetMating:RegisterShowEventFunc(false, "PetMatingHideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
function PetMatingShowAni()
  local isShow = Panel_Window_PetMating:IsShow()
  if isShow == true then
    Panel_Window_PetMating:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
    local aniInfo1 = Panel_Window_PetMating:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
    aniInfo1:SetStartIntensity(3)
    aniInfo1:SetEndIntensity(1)
    aniInfo1.IsChangeChild = true
    aniInfo1:SetHideAtEnd(true)
    aniInfo1:SetDisableWhileAni(true)
  else
    UIAni.fadeInSCR_Down(Panel_Window_PetMating)
    Panel_Window_PetMating:SetShow(true, false)
  end
end
function PetMatingHideAni()
  Inventory_SetFunctor(nil)
  Panel_Window_PetMating:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_PetMating:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
function PetMating_Resize()
  local self = PetMating
  screenX = getScreenSizeX()
  screenY = getScreenSizeY()
end
local PetMating = {
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
  _mainBG = UI.getChildControl(Panel_Window_PetMating, "Static_MainBG"),
  _buttonQuestion = UI.getChildControl(Panel_Window_PetMating, "Button_Question"),
  _buttonClose = UI.getChildControl(Panel_Window_PetMating, "Button_Close"),
  _mygold_Value = UI.getChildControl(Panel_Window_PetMating, "Static_Text_Money"),
  _staticPageNo = UI.getChildControl(Panel_Window_PetMating, "Static_PageNo"),
  _buttonNext = UI.getChildControl(Panel_Window_PetMating, "Button_Next"),
  _buttonPrev = UI.getChildControl(Panel_Window_PetMating, "Button_Prev"),
  _buttonTabMarket = UI.getChildControl(Panel_Window_PetMating, "RadioButton_List"),
  _buttonTabMy = UI.getChildControl(Panel_Window_PetMating, "RadioButton_ListMy"),
  _buttonStart = UI.getChildControl(Panel_Window_PetMating, "Button_Start"),
  _buttonMating = UI.getChildControl(Panel_Window_PetMating, "Button_Mating"),
  _buttonCancel = UI.getChildControl(Panel_Window_PetMating, "Button_Cancel"),
  _buttonReceive = UI.getChildControl(Panel_Window_PetMating, "Button_Receive"),
  _buttonEnd = UI.getChildControl(Panel_Window_PetMating, "Button_End"),
  _slots = Array.new(),
  _selectSlotNo = 0,
  _selectPage = 0,
  _selectMaxPage = 0,
  _isMyTab = false
}
function PetMating:init()
  for ii = 0, self._config.slotCount - 1 do
    local slot = {}
    slot._slotNo = ii
    slot._panel = Panel_Window_PetMating
    slot._baseSlot = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_Slot", self._mainBG, "ServantMating_Slot_" .. ii)
    slot._iconBack = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_IconBack", slot._baseSlot, "ServantMating_Slot_IconBack_" .. ii)
    slot._icon = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_Icon", slot._iconBack, "ServantMating_Slot_Icon_" .. ii)
    slot._iconMale = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_Male", slot._iconBack, "ServantMating_Slot_Male_" .. ii)
    slot._iconFemale = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_Female", slot._iconBack, "ServantMating_Slot_Female_" .. ii)
    slot._statusBack = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_StatusBack", slot._baseSlot, "ServantMating_Slot_StatusBack_" .. ii)
    slot._staticLv = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_Lv", slot._statusBack, "ServantMating_Slot_StatusLv_" .. ii)
    slot._staticLvValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_LvValue", slot._statusBack, "ServantMating_Slot_StatusLvValue_" .. ii)
    slot._staticHp = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_Hp", slot._statusBack, "ServantMating_Slot_StatusHp_" .. ii)
    slot._staticHpValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_HpValue", slot._statusBack, "ServantMating_Slot_StatusHpValue_" .. ii)
    slot._staticStamina = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_Stamina", slot._statusBack, "ServantMating_Slot_StatusStamina_" .. ii)
    slot._staticStaminaValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_StaminaValue", slot._statusBack, "ServantMating_Slot_StatusStaminaValue_" .. ii)
    slot._staticWeight = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_Weight", slot._statusBack, "ServantMating_Slot_StatusWeight_" .. ii)
    slot._staticWeightValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_WeightValue", slot._statusBack, "ServantMating_Slot_StatusWeightValue_" .. ii)
    slot._staticPrice = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_Price", slot._statusBack, "ServantMating_Slot_StatusPrice_" .. ii)
    slot._staticPriceValue = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_PriceValue", slot._statusBack, "ServantMating_Slot_StatusPriceValue_" .. ii)
    slot._skillBack = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_SkillBack", slot._baseSlot, "ServantMating_Slot_SkillBack_" .. ii)
    slot._skill = Array.new()
    for jj = 0, self._config.skill.count - 1 do
      local skill = {}
      skill._skillIcon = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_SkillIcon", slot._skillBack, "ServantMating_Slot_SkillIcon_" .. ii .. "_" .. jj)
      skill._skillText = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Static_SkillText", slot._skillBack, "ServantMating_Slot_SkillText_" .. ii .. "_" .. jj)
      slot._skill[jj] = skill
    end
    slot._buttonStart = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Button_Start", slot._baseSlot, "ServantMating_Start_" .. ii)
    slot._buttonMating = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Button_Mating", slot._baseSlot, "ServantMating_Mating_" .. ii)
    slot._buttonCancel = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Button_Cancel", slot._baseSlot, "ServantMating_Cancel_" .. ii)
    slot._buttonReceive = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Button_Receive", slot._baseSlot, "ServantMating_Receive_" .. ii)
    slot._buttonEnd = UI.createAndCopyBasePropertyControl(Panel_Window_PetMating, "Button_End", slot._baseSlot, "ServantMating_End_" .. ii)
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
    slot._buttonStart:SetPosX(buttonConfig.startX)
    slot._buttonStart:SetPosY(buttonConfig.startY)
    slot._buttonMating:SetPosX(buttonConfig.startX)
    slot._buttonMating:SetPosY(buttonConfig.startY)
    slot._buttonCancel:SetPosX(buttonConfig.startX)
    slot._buttonCancel:SetPosY(buttonConfig.startY)
    slot._buttonReceive:SetPosX(buttonConfig.startX)
    slot._buttonReceive:SetPosY(buttonConfig.startY)
    slot._buttonEnd:SetPosX(buttonConfig.startX)
    slot._buttonEnd:SetPosY(buttonConfig.startY)
    slot._buttonStart:addInputEvent("Mouse_LUp", "PetMating_Mating(" .. ii .. ")")
    slot._buttonCancel:addInputEvent("Mouse_LUp", "PetMating_Cancel(" .. ii .. ")")
    slot._buttonEnd:addInputEvent("Mouse_LUp", "PetMating_Cancel(" .. ii .. ")")
    slot._buttonReceive:addInputEvent("Mouse_LUp", "PetMating_Receive(" .. ii .. ")")
    slot._buttonStart:SetAutoDisableTime(4)
    slot._buttonCancel:SetAutoDisableTime(4)
    slot._buttonEnd:SetAutoDisableTime(4)
    slot._buttonReceive:SetAutoDisableTime(4)
    slot._baseSlot:SetShow(false)
    self._slots[ii] = slot
  end
end
function PetMating:registEventHandler()
  self._buttonTabMarket:addInputEvent("Mouse_LUp", "PetMating_TabEvent( false )")
  self._buttonTabMy:addInputEvent("Mouse_LUp", "PetMating_TabEvent( true )")
  self._buttonNext:addInputEvent("Mouse_LUp", "PetMating_NextPage()")
  self._buttonPrev:addInputEvent("Mouse_LUp", "PetMating_PrevPage()")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowPetMating\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowPetMating\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindowPetMating\", \"false\")")
  self._buttonClose:addInputEvent("Mouse_LUp", "PetMating_Close()")
  self._buttonTabMarket:SetAutoDisableTime(4)
  self._buttonTabMy:SetAutoDisableTime(4)
  self._buttonNext:SetAutoDisableTime(4)
  self._buttonPrev:SetAutoDisableTime(4)
end
function PetMating:registMessageHandler()
end
function PetMating:updateSlot()
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local inventory = selfPlayer:getInventory()
  self._mygold_Value:SetText(makeDotMoney(inventory:getMoney_s64()))
  for ii = 0, self._config.slotCount - 1 do
    local slot = self._slots[ii]
    slot._baseSlot:SetShow(false)
  end
  local myAuctionInfo = RequestGetAuctionInfo()
  local startSlotNo = 0
  local endSlotNo = 0
  if PetMating_IsTabMy() then
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
      slot._buttonStart:SetShow(false)
      slot._buttonMating:SetShow(false)
      slot._buttonCancel:SetShow(false)
      slot._buttonReceive:SetShow(false)
      slot._buttonEnd:SetShow(false)
      if PetMating_IsTabMy() then
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
  if PetMating_IsTabMy() then
    self._staticPageNo:SetText(self._selectPage + 1)
  else
    self._staticPageNo:SetText(myAuctionInfo:getCurrentPage() + 1)
  end
end
function PetMating_IsTabMy()
  local self = PetMating
  return self._isTabMy
end
function PetMating_UpdateSlotData()
  local self = PetMating
  self:updateSlot()
end
function PetMating_TabEventFromRegister()
  if not Panel_Window_PetMating:GetShow() then
    return
  end
  local self = PetMating
  PetMating_TabEventXXX(PetMating_IsTabMy)
end
function PetMating_TabEvent(isTabMy)
  local self = PetMating
  if PetMating_IsTabMy() == isTabMy then
    return
  end
  PetMating_TabEventXXX(isTabMy)
end
function PetMating_TabEventXXX(isTabMy)
  local self = PetMating
  self._selectPage = 0
  self._selectMaxPage = 100
  self._isTabMy = isTabMy
  if PetMating_IsTabMy() then
    requestMyServantMatingList()
  else
    requestServantMatingListPage()
  end
end
function PetMating_NextPage()
  local self = PetMating
  if self._selectMaxPage <= self._selectPage then
    return
  end
  self._selectPage = self._selectPage + 1
  if PetMating_IsTabMy() then
    self:update()
  else
    RequestAuctionNextPage()
  end
end
function PetMating_PrevPage()
  local self = PetMating
  if 0 < self._selectPage then
    self._selectPage = self._selectPage - 1
  end
  if PetMating_IsTabMy() then
    self:update()
  else
    RequestAuctionPrevPage()
  end
end
function PetMating_Mating(slotNo)
  local self = PetMating
  self._selectSlotNo = slotNo
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_PET_MATING_NOTIFY")
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = PetMating_MatingXXX,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PetMating_MatingXXX()
  local self = PetMating
  stable_startServantMating(PetList_SelectSlotNo(), self._selectSlotNo)
  self._selectSlotNo = nil
end
function PetMating_Cancel(slotNo)
  local self = PetMating
  stable_cancelServantFromSomeWhereElse(slotNo, CppEnums.AuctionType.AuctionGoods_ServantMating)
end
function PetMating_Receive(slotNo)
  local self = PetMating
  local selectSlotNo = self._selectPage * self._config.slotCount + slotNo
  stable_popServantPrice(selectSlotNo, CppEnums.AuctionType.AuctionGoods_ServantMating)
end
function PetMating_Open()
  Panel_Window_PetMating:SetPosX(getScreenSizeX() / 2 - Panel_Window_PetMating:GetSizeX() / 2)
  Panel_Window_PetMating:SetPosY(getScreenSizeY() / 2 - Panel_Window_PetMating:GetSizeY() / 2 - 30)
  if Panel_Window_PetMating:GetShow() then
    return
  end
  if Panel_Window_PetMarket:GetShow() then
    PetMarket_Close()
  end
  local self = PetMating
  self._selectSlotNo = nil
  self._selectPage = 0
  self._selectMaxPage = 100
  self._isTabMy = false
  self._buttonTabMy:SetCheck(true)
  self._buttonTabMarket:SetCheck(false)
  PetMating_TabEvent(true)
  Panel_Window_PetMating:SetShow(true)
end
function PetMating_Close()
  if not Panel_Window_PetMating:IsShow() then
    return
  end
  Panel_Window_PetMating:SetShow(false)
end
PetMating:init()
PetMating:registEventHandler()
PetMating:registMessageHandler()
PetMating_Resize()
