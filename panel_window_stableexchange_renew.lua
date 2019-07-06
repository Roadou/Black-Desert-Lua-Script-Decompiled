local Panel_Window_StableExchange_info = {
  _ui = {
    static_Title = nil,
    staticText_Title = nil,
    staticText_SubTitle1 = nil,
    staticText_SubTitle2 = nil,
    static_Left = nil,
    radioButton_Horse_Left = nil,
    static_Image_Left = nil,
    static_SexIcon_Left = nil,
    staticText_Tier_Left = nil,
    staticText_Name_Left = nil,
    staticText_Location_Left = nil,
    left_VerticalScroll = nil,
    static_Icon = nil,
    static_Right = nil,
    radioButton_Horse_Right = nil,
    static_Image_Right = nil,
    static_SexIcon_Right = nil,
    staticText_Tier_Right = nil,
    staticText_Name_Right = nil,
    staticText_Location_Right = nil,
    right_VerticalScroll = nil,
    static_Mating_Right = nil,
    static_Mating_Right = nil,
    static_Image_Mating_Right = nil,
    static_SexIcon_Mating_Right = nil,
    staticText_Tier_Mating_Right = nil,
    staticText_Name_Mating_Right = nil,
    staticText_Location_Mating_Right = nil,
    static_BottomBg = nil,
    staticText_Select_ConsoleUI = nil,
    staticText_Exchange_ConsoleUI = nil
  },
  _value = {
    leftLastSlotIndex = nil,
    leftCurrnetSlotIndex = nil,
    leftCurrentSlotNo = nil,
    leftStartIndex = 0,
    leftSlotCount = 0,
    rightLastSlotIndex = nil,
    rightCurrnetSlotIndex = nil,
    rightCurrentSlotNo = nil,
    rightStartIndex = 0,
    rightSlotCount = 0,
    currentOpenType = 0,
    matingPrice = nil,
    matingSlotNo = nil,
    transferType = nil
  },
  _pos = {
    buttonSizeX = 0,
    buttonSizeY = 0,
    buttonSpaceX = 10,
    buttonSpaceY = 10,
    keyGuideButtonSize = 0,
    keyGuideButtonSpace = 1
  },
  _config = {
    maxSlotCount = 4,
    slotRow = 3,
    slotCol = 1
  },
  _enum = {
    eTYPE_EXCHANGE = 0,
    eTYPE_MATING = 1,
    eTYPE_LINK = 2
  },
  _texture = {
    sexIcon = "Renewal/UI_Icon/Console_Icon_01.dds",
    male = {
      x1 = 82,
      y1 = 1,
      x2 = 101,
      y2 = 20
    },
    female = {
      x1 = 62,
      y1 = 1,
      x2 = 81,
      y2 = 20
    },
    typeIcon = "Renewal/UI_Icon/Console_Icon_01.dds",
    exchange = {
      x1 = 1,
      y1 = 1,
      x2 = 61,
      y2 = 61
    },
    link = {
      x1 = 1,
      y1 = 62,
      x2 = 61,
      y2 = 122
    },
    mate = {
      x1 = 1,
      y1 = 123,
      x2 = 61,
      y2 = 183
    }
  },
  _nowLeftServantNo = nil,
  _nowRightServantNo = nil,
  _leftSlot = {},
  _rightSlot = {},
  _leftDataIndex = {},
  _rightDataIndex = {}
}
local isContentsStallionEnable = ToClient_IsContentsGroupOpen("243")
local isContentsNineTierEnable = ToClient_IsContentsGroupOpen("80")
function Panel_Window_StableExchange_info:registEventHandler()
  Panel_Window_Stable_Exchange:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_StableExchange_PadButton_X()")
end
function Panel_Window_StableExchange_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_StableExchange_Resize")
  registerEvent("FromClient_ServantMix", "FromClient_StableExchange_ServantMix")
end
function Panel_Window_StableExchange_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:createSlot()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_StableExchange_info:initValue()
  self._value.leftLastSlotIndex = nil
  self._value.leftCurrnetSlotIndex = nil
  self._value.leftCurrentSlotNo = nil
  self._value.leftStartIndex = 0
  self._value.leftSlotCount = 0
  self._value.rightLastSlotIndex = nil
  self._value.rightCurrnetSlotIndex = nil
  self._value.rightCurrentSlotNo = nil
  self._value.rightStartIndex = 0
  self._value.rightSlotCount = 0
  self._value.currentOpenType = 0
  self._value.matingPrice = 0
  self._value.matingSlotNo = nil
  self._value.transferType = CppEnums.TransferType.TransferType_Normal
end
function Panel_Window_StableExchange_info:resize()
end
function Panel_Window_StableExchange_info:childControl()
  self._ui.static_Title = UI.getChildControl(Panel_Window_Stable_Exchange, "Static_Title")
  self._ui.staticText_Title = UI.getChildControl(self._ui.static_Title, "StaticText_Title")
  self._ui.staticText_SubTitle1 = UI.getChildControl(Panel_Window_Stable_Exchange, "StaticText_SubTitle1")
  self._ui.staticText_SubTitle2 = UI.getChildControl(Panel_Window_Stable_Exchange, "StaticText_SubTitle2")
  self._ui.static_Left = UI.getChildControl(Panel_Window_Stable_Exchange, "Static_Left")
  self._ui.radioButton_Horse_Left = UI.getChildControl(self._ui.static_Left, "RadioButton_Horse_Left")
  self._ui.static_Image_Left = UI.getChildControl(self._ui.radioButton_Horse_Left, "Static_Image_Left")
  self._ui.static_SexIcon_Left = UI.getChildControl(self._ui.radioButton_Horse_Left, "Static_SexIcon_Left")
  self._ui.staticText_Tier_Left = UI.getChildControl(self._ui.radioButton_Horse_Left, "StaticText_Tier_Left")
  self._ui.staticText_Name_Left = UI.getChildControl(self._ui.radioButton_Horse_Left, "StaticText_Name_Left")
  self._ui.staticText_Location_Left = UI.getChildControl(self._ui.radioButton_Horse_Left, "StaticText_Location_Left")
  self._ui.radioButton_Horse_Left:SetShow(false)
  self._ui.left_VerticalScroll = UI.getChildControl(self._ui.static_Left, "Left_VerticalScroll")
  self._pos.buttonSizeX = self._ui.radioButton_Horse_Left:GetSizeX()
  self._pos.buttonSizeY = self._ui.radioButton_Horse_Left:GetSizeY()
  self._ui.static_Icon = UI.getChildControl(Panel_Window_Stable_Exchange, "Static_Icon")
  self._ui.static_Right = UI.getChildControl(Panel_Window_Stable_Exchange, "Static_Right")
  self._ui.radioButton_Horse_Right = UI.getChildControl(self._ui.static_Right, "RadioButton_Horse_Right")
  self._ui.static_Image_Right = UI.getChildControl(self._ui.radioButton_Horse_Right, "Static_Image_Right")
  self._ui.static_SexIcon_Right = UI.getChildControl(self._ui.radioButton_Horse_Right, "Static_SexIcon_Right")
  self._ui.staticText_Tier_Right = UI.getChildControl(self._ui.radioButton_Horse_Right, "StaticText_Tier_Right")
  self._ui.staticText_Name_Right = UI.getChildControl(self._ui.radioButton_Horse_Right, "StaticText_Name_Right")
  self._ui.staticText_Location_Right = UI.getChildControl(self._ui.radioButton_Horse_Right, "StaticText_Location_Right")
  self._ui.radioButton_Horse_Right:SetShow(false)
  self._ui.right_VerticalScroll = UI.getChildControl(self._ui.static_Right, "Right_VerticalScroll")
  self._ui.static_Mating_Right = UI.getChildControl(Panel_Window_Stable_Exchange, "Static_Mating_Right")
  self._ui.static_Horse_Mating_Right = UI.getChildControl(self._ui.static_Mating_Right, "Static_Horse_Mating_Right")
  self._ui.static_Image_Mating_Right = UI.getChildControl(self._ui.static_Horse_Mating_Right, "Static_Image_Mating_Right")
  self._ui.static_SexIcon_Mating_Right = UI.getChildControl(self._ui.static_Horse_Mating_Right, "Static_SexIcon_Mating_Right")
  self._ui.staticText_Tier_Mating_Right = UI.getChildControl(self._ui.static_Horse_Mating_Right, "StaticText_Tier_Mating_Right")
  self._ui.staticText_Name_Mating_Right = UI.getChildControl(self._ui.static_Horse_Mating_Right, "StaticText_Name_Mating_Right")
  self._ui.staticText_Location_Mating_Right = UI.getChildControl(self._ui.static_Horse_Mating_Right, "StaticText_Location_Mating_Right")
  self._ui.radioButton_Horse_Right:SetShow(false)
  self._ui.static_BottomBg = UI.getChildControl(Panel_Window_Stable_Exchange, "Static_BottomBg")
  self._ui.staticText_Select_ConsoleUI = UI.getChildControl(self._ui.static_BottomBg, "StaticText_Select_ConsoleUI")
  self._ui.staticText_Exchange_ConsoleUI = UI.getChildControl(self._ui.static_BottomBg, "StaticText_Exchange_ConsoleUI")
  self._pos.keyGuideButtonSize = self._ui.staticText_Select_ConsoleUI:GetSizeX()
end
function Panel_Window_StableExchange_info:createSlot()
  for left = 0, 1 do
    for index = 0, self._config.maxSlotCount - 1 do
      local slot = {
        selected = false,
        slotNo = 0,
        servantNo = nil,
        radioButton = nil,
        static_Image = nil,
        static_SexIcon = nil,
        staticText_Tier = nil,
        staticText_Name = nil,
        staticText_Location = nil
      }
      function slot:setPos(row, col)
        local exPanelinfo = Panel_Window_StableExchange_info
        local newPosX = 0 + col * (exPanelinfo._pos.buttonSizeX + exPanelinfo._pos.buttonSpaceX) + 10
        local newPosY = 0 + row * (exPanelinfo._pos.buttonSizeY + exPanelinfo._pos.buttonSpaceY) + 10
        self.radioButton:SetPosXY(newPosX, newPosY)
      end
      function slot:setSlotHorseByMating(slotNo)
        local exchangeInfo = Panel_Window_StableExchange_info
        local myAuctionInfo = RequestGetAuctionInfo()
        local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(slotNo)
        self:setShow(true)
        self.static_Image:ChangeTextureInfoName(auctionServantInfo:getIconPath1())
        if auctionServantInfo:isMale() then
          self.static_SexIcon:ChangeTextureInfoName(exchangeInfo._texture.sexIcon)
          local x1, y1, x2, y2 = setTextureUV_Func(self.static_SexIcon, exchangeInfo._texture.male.x1, exchangeInfo._texture.male.y1, exchangeInfo._texture.male.x2, exchangeInfo._texture.male.y2)
          self.static_SexIcon:getBaseTexture():setUV(x1, y1, x2, y2)
          self.static_SexIcon:setRenderTexture(self.static_SexIcon:getBaseTexture())
        else
          self.static_SexIcon:ChangeTextureInfoName(exchangeInfo._texture.sexIcon)
          local x1, y1, x2, y2 = setTextureUV_Func(self.static_SexIcon, exchangeInfo._texture.female.x1, exchangeInfo._texture.female.y1, exchangeInfo._texture.female.x2, exchangeInfo._texture.female.y2)
          self.static_SexIcon:getBaseTexture():setUV(x1, y1, x2, y2)
          self.static_SexIcon:setRenderTexture(self.static_SexIcon:getBaseTexture())
        end
        self.staticText_Tier:SetShow(true)
        if 9 == auctionServantInfo:getTier() then
          self.staticText_Tier:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9"))
        else
          self.staticText_Tier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", auctionServantInfo:getTier()))
        end
        self.staticText_Name:SetShow(false)
        self.staticText_Location:SetShow(true)
        self.staticText_Location:SetText(auctionServantInfo:getRegionName())
      end
      function slot:setSlotHorse(servantIndex)
        self:setShow(true)
        local servantInfo = stable_getServant(servantIndex)
        self.static_Image:ChangeTextureInfoName(servantInfo:getIconPath1())
        self.static_SexIcon:SetShow(true)
        local exchangeInfo = Panel_Window_StableExchange_info
        if servantInfo:isMale() then
          self.static_SexIcon:ChangeTextureInfoName(exchangeInfo._texture.sexIcon)
          local x1, y1, x2, y2 = setTextureUV_Func(self.static_SexIcon, exchangeInfo._texture.male.x1, exchangeInfo._texture.male.y1, exchangeInfo._texture.male.x2, exchangeInfo._texture.male.y2)
          self.static_SexIcon:getBaseTexture():setUV(x1, y1, x2, y2)
          self.static_SexIcon:setRenderTexture(self.static_SexIcon:getBaseTexture())
        else
          self.static_SexIcon:ChangeTextureInfoName(exchangeInfo._texture.sexIcon)
          local x1, y1, x2, y2 = setTextureUV_Func(self.static_SexIcon, exchangeInfo._texture.female.x1, exchangeInfo._texture.female.y1, exchangeInfo._texture.female.x2, exchangeInfo._texture.female.y2)
          self.static_SexIcon:getBaseTexture():setUV(x1, y1, x2, y2)
          self.static_SexIcon:setRenderTexture(self.static_SexIcon:getBaseTexture())
        end
        self.staticText_Tier:SetShow(true)
        if 9 == servantInfo:getTier() then
          self.staticText_Tier:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9"))
        else
          self.staticText_Tier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", servantInfo:getTier()))
        end
        self.staticText_Name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
        self.staticText_Name:SetShow(true)
        self.staticText_Name:SetText(servantInfo:getName())
        self.staticText_Location:SetShow(true)
        self.staticText_Location:SetText(servantInfo:getRegionName())
      end
      function slot:setSlotLink(servantIndex)
        self:setShow(true)
        local servantInfo = stable_getServant(servantIndex)
        if CppEnums.VehicleType.Type_Carriage == servantInfo:getVehicleType() or CppEnums.VehicleType.Type_RepairableCarriage == servantInfo:getVehicleType() then
          self.static_SexIcon:SetShow(false)
          self.staticText_Tier:SetShow(false)
          self.staticText_Name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
          self.staticText_Name:SetShow(true)
          self.staticText_Name:SetText(servantInfo:getName())
          self.staticText_Location:SetShow(true)
          self.staticText_Location:SetText(servantInfo:getRegionName())
          self.static_Image:ChangeTextureInfoName(servantInfo:getIconPath1())
          self.radioButton:addInputEvent("Mouse_On", "")
        end
        if CppEnums.VehicleType.Type_Horse == servantInfo:getVehicleType() then
          self:setSlotHorse(servantIndex)
          self.radioButton:addInputEvent("Mouse_On", "")
        end
      end
      function slot:selectSlot(bSelect)
        self.selected = bSelect
        self.radioButton:SetCheck(bSelect)
      end
      function slot:setShow(bShow)
        if 0 == left and self.radioButton:GetPosY() > Panel_Window_StableExchange_info._ui.static_Left:GetSizeY() then
          self.radioButton:SetShow(false)
        elseif 1 == left and self.radioButton:GetPosY() > Panel_Window_StableExchange_info._ui.static_Right:GetSizeY() then
          self.radioButton:SetShow(false)
        else
          self.radioButton:SetShow(bShow)
        end
      end
      function slot:clear()
        self:setShow(false)
        self:selectSlot(false)
        self.servantNo = nil
      end
      local row = math.floor(index / self._config.slotCol)
      local col = index % self._config.slotCol
      if left == 0 then
        slot.radioButton = UI.createAndCopyBasePropertyControl(self._ui.static_Left, "RadioButton_Horse_Left", self._ui.static_Left, "RadioButton_Horse_Left_" .. index)
        slot.static_Image = UI.createAndCopyBasePropertyControl(self._ui.radioButton_Horse_Left, "Static_Image_Left", slot.radioButton, "Static_Image_Left_" .. index)
        slot.static_SexIcon = UI.createAndCopyBasePropertyControl(self._ui.radioButton_Horse_Left, "Static_SexIcon_Left", slot.radioButton, "Static_SexIcon_Left_" .. index)
        slot.staticText_Tier = UI.createAndCopyBasePropertyControl(self._ui.radioButton_Horse_Left, "StaticText_Tier_Left", slot.radioButton, "StaticText_Tier_Left_" .. index)
        slot.staticText_Name = UI.createAndCopyBasePropertyControl(self._ui.radioButton_Horse_Left, "StaticText_Name_Left", slot.radioButton, "StaticText_Name_Left_" .. index)
        slot.staticText_Location = UI.createAndCopyBasePropertyControl(self._ui.radioButton_Horse_Left, "StaticText_Location_Left", slot.radioButton, "StaticText_Location_Left_" .. index)
        if row == 0 then
          slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_StableExchange_ScrollEvent( true, true )")
        elseif row == self._config.slotRow then
          slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_StableExchange_ScrollEvent( false, true )")
        end
        slot.radioButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableExchange_ClickSelect(" .. index .. ",true)")
      else
        slot.radioButton = UI.createAndCopyBasePropertyControl(self._ui.static_Right, "RadioButton_Horse_Right", self._ui.static_Right, "RadioButton_Horse_Right_" .. index)
        slot.static_Image = UI.createAndCopyBasePropertyControl(self._ui.radioButton_Horse_Right, "Static_Image_Right", slot.radioButton, "Static_Image_Right_" .. index)
        slot.static_SexIcon = UI.createAndCopyBasePropertyControl(self._ui.radioButton_Horse_Right, "Static_SexIcon_Right", slot.radioButton, "Static_SexIcon_Right_" .. index)
        slot.staticText_Tier = UI.createAndCopyBasePropertyControl(self._ui.radioButton_Horse_Right, "StaticText_Tier_Right", slot.radioButton, "StaticText_Tier_Right_" .. index)
        slot.staticText_Name = UI.createAndCopyBasePropertyControl(self._ui.radioButton_Horse_Right, "StaticText_Name_Right", slot.radioButton, "StaticText_Name_Right_" .. index)
        slot.staticText_Location = UI.createAndCopyBasePropertyControl(self._ui.radioButton_Horse_Right, "StaticText_Location_Right", slot.radioButton, "StaticText_Location_Right_" .. index)
        if row == 0 then
          slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_StableExchange_ScrollEvent( true, false )")
        elseif row == self._config.slotRow then
          slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_StableExchange_ScrollEvent( false, false )")
        end
        slot.radioButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableExchange_ClickSelect(" .. index .. ",false)")
      end
      slot.slotNo = index
      slot:setPos(row, col)
      slot:clear()
      if left == 0 then
        self._leftSlot[index] = slot
      else
        self._rightSlot[index] = slot
      end
    end
  end
end
function Panel_Window_StableExchange_info:clearSlotBoth()
  for index = 0, self._config.maxSlotCount - 1 do
    local lSlot = self._leftSlot[index]
    local rSlot = self._rightSlot[index]
    lSlot:clear()
    rSlot:clear()
  end
end
function Panel_Window_StableExchange_info:clearSlotEach(isLeft)
  if nil == isLeft then
    isLeft = true
  end
  if true == isLeft then
    for index = 0, self._config.maxSlotCount - 1 do
      local lSlot = self._leftSlot[index]
      lSlot:clear()
    end
  else
    for index = 0, self._config.maxSlotCount - 1 do
      local rSlot = self._rightSlot[index]
      rSlot:clear()
    end
  end
end
function Panel_Window_StableExchange_info:setTextByType(eOpenType)
  local defaultPosX = 497
  local defaultPosY = 115
  if self._enum.eTYPE_EXCHANGE == eOpenType then
    self._ui.staticText_Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_EXCHANGE_TITLE"))
    self._ui.staticText_SubTitle1:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_EXCHANGE_MALEDESC"))
    self._ui.staticText_SubTitle2:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_EXCHANGE_FEMAILDESC"))
    self._ui.staticText_SubTitle2:SetShow(true)
    self._ui.staticText_Exchange_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_EXCHANGE_EXCHANGE"))
  elseif self._enum.eTYPE_MATING == eOpenType then
    self._ui.staticText_Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_MARKET_REQUEST"))
    self._ui.staticText_SubTitle1:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_MATING_FEMALEDESC"))
    self._ui.staticText_SubTitle2:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_MATING_MALEDESC"))
    self._ui.staticText_SubTitle2:SetShow(false)
    self._ui.staticText_Exchange_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_MARKET_REQUEST"))
  elseif self._enum.eTYPE_LINK == eOpenType then
    self._ui.staticText_Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_STABLEFUNCTION_HORSELINK"))
    self._ui.staticText_SubTitle1:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_EXCHANGE_SELECT_CARRiAGE"))
    self._ui.staticText_SubTitle2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_EXCHANGE_SELECT_HORSE"))
    self._ui.staticText_SubTitle2:SetShow(true)
    self._ui.staticText_Exchange_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_STABLEFUNCTION_HORSELINK"))
  end
  local tempSizeX = self._ui.staticText_SubTitle1:GetPosX() + self._ui.staticText_SubTitle1:GetTextSizeX() + self._ui.staticText_SubTitle1:GetSizeX()
  if tempSizeX > self._ui.staticText_SubTitle2:GetPosX() - 20 then
    self._ui.staticText_SubTitle1:SetPosY(defaultPosY - 20)
    self._ui.staticText_SubTitle2:SetPosXY(self._ui.staticText_SubTitle1:GetPosX(), defaultPosY + 20)
  else
    self._ui.staticText_SubTitle1:SetPosY(defaultPosY)
    self._ui.staticText_SubTitle2:SetPosXY(defaultPosX, defaultPosY)
  end
end
function Panel_Window_StableExchange_info:setKeyGuidePos()
  local parantSizeX = self._ui.static_BottomBg:GetSizeX()
  local space = self._pos.keyGuideButtonSize + self._pos.keyGuideButtonSpace
  local textLength1 = self._ui.staticText_Select_ConsoleUI:GetTextSizeX()
  local textLength2 = self._ui.staticText_Exchange_ConsoleUI:GetTextSizeX()
  self._ui.staticText_Exchange_ConsoleUI:SetPosX(parantSizeX - (space * 2 + textLength1 + textLength2) - 20)
  self._ui.staticText_Select_ConsoleUI:SetPosX(parantSizeX - (space + textLength1))
end
function Panel_Window_StableExchange_info:setContent(eOpenType)
  if nil == updateBoth then
    updateBoth = true
  end
  self._ui.left_VerticalScroll:SetControlTop()
  self._ui.right_VerticalScroll:SetControlTop()
  UIScroll.SetButtonSize(self._ui.left_VerticalScroll, self._config.maxSlotCount, self._value.leftSlotCount)
  UIScroll.SetButtonSize(self._ui.right_VerticalScroll, self._config.maxSlotCount, self._value.rightSlotCount)
  self:setCenterIcon(eOpenType)
  self:setTextByType(eOpenType)
  if self._enum.eTYPE_EXCHANGE == eOpenType then
    self:clearSlotBoth()
    self:setContentExchange(true)
  elseif self._enum.eTYPE_MATING == eOpenType then
    self:clearSlotBoth(true)
    self:setContentMating(true)
  elseif self._enum.eTYPE_LINK == eOpenType then
    self:clearSlotBoth()
    self:setContentLink(true)
  end
  self:setKeyGuidePos()
end
function Panel_Window_StableExchange_info:setCenterIcon(eOpenType)
  if self._enum.eTYPE_EXCHANGE == eOpenType then
    self._ui.static_Icon:ChangeTextureInfoName(self._texture.typeIcon)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon, self._texture.exchange.x1, self._texture.exchange.y1, self._texture.exchange.x2, self._texture.exchange.y2)
    self._ui.static_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.static_Icon:setRenderTexture(self._ui.static_Icon:getBaseTexture())
  elseif self._enum.eTYPE_MATING == eOpenType then
    self._ui.static_Icon:ChangeTextureInfoName(self._texture.typeIcon)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon, self._texture.mate.x1, self._texture.mate.y1, self._texture.mate.x2, self._texture.mate.y2)
    self._ui.static_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.static_Icon:setRenderTexture(self._ui.static_Icon:getBaseTexture())
  elseif self._enum.eTYPE_LINK == eOpenType then
    self._ui.static_Icon:ChangeTextureInfoName(self._texture.typeIcon)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon, self._texture.link.x1, self._texture.link.y1, self._texture.link.x2, self._texture.link.y2)
    self._ui.static_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.static_Icon:setRenderTexture(self._ui.static_Icon:getBaseTexture())
  end
end
function Panel_Window_StableExchange_info:updateContent(eOpenType, updateBoth, updateLeft)
  if nil == updateBoth then
    updateBoth = true
  end
  if nil == updateLeft then
    updateLeft = true
  end
  UIScroll.SetButtonSize(self._ui.left_VerticalScroll, self._config.maxSlotCount, self._value.leftSlotCount)
  UIScroll.SetButtonSize(self._ui.right_VerticalScroll, self._config.maxSlotCount, self._value.rightSlotCount)
  if self._enum.eTYPE_EXCHANGE == eOpenType then
    self:clearSlotEach(updateLeft)
    self:setContentExchange(updateBoth, updateLeft)
  elseif self._enum.eTYPE_MATING == eOpenType then
    self:clearSlotEach(updateLeft)
    self:setContentMating(updateBoth, updateLeft)
  elseif self._enum.eTYPE_LINK == eOpenType then
    self:clearSlotEach(updateLeft)
    self:setContentLink(updateBoth, updateLeft)
  end
end
function Panel_Window_StableExchange_info:setContentExchange(isBoth, isLeft)
  if nil == isBoth then
    isBoth = true
  end
  if true == isBoth or true == isLeft then
    for index = 0, self._config.maxSlotCount - 1 do
      local slot = self._leftSlot[index]
      slot.slotNo = self._value.leftStartIndex + index
      if slot.slotNo < self._value.leftSlotCount then
        local servantIndex = self._leftDataIndex[slot.slotNo]
        if slot.slotNo == self._value.leftCurrentSlotNo then
          slot:selectSlot(true)
        end
        slot:setSlotHorse(servantIndex)
      end
    end
  end
  self._ui.static_Mating_Right:SetShow(false)
  self._ui.static_Right:SetShow(true)
  if true == isBoth or false == isLeft then
    for index = 0, self._config.maxSlotCount - 1 do
      local slot = self._rightSlot[index]
      slot.slotNo = self._value.rightStartIndex + index
      if slot.slotNo < self._value.rightSlotCount then
        local servantIndex = self._rightDataIndex[slot.slotNo]
        if slot.slotNo == self._value.rightCurrentSlotNo then
          slot:selectSlot(true)
        end
        slot:setSlotHorse(servantIndex)
      end
    end
  end
end
function Panel_Window_StableExchange_info:setMatingSlot(slotNo)
  local self = Panel_Window_StableExchange_info
  local myAuctionInfo = RequestGetAuctionInfo()
  if nil == myAuctionInfo then
    return
  end
  local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(slotNo)
  if nil == auctionServantInfo then
    return
  end
  self._ui.static_Image_Mating_Right:ChangeTextureInfoName(auctionServantInfo:getIconPath1())
  if auctionServantInfo:isMale() then
    self._ui.static_SexIcon_Mating_Right:ChangeTextureInfoName(self._texture.sexIcon)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_SexIcon_Mating_Right, self._texture.male.x1, self._texture.male.y1, self._texture.male.x2, self._texture.male.y2)
    self._ui.static_SexIcon_Mating_Right:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.static_SexIcon_Mating_Right:setRenderTexture(self._ui.static_SexIcon_Mating_Right:getBaseTexture())
  else
    self._ui.static_SexIcon_Mating_Right:ChangeTextureInfoName(self._texture.sexIcon)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_SexIcon_Mating_Right, self._texture.female.x1, self._texture.female.y1, self._texture.female.x2, self._texture.female.y2)
    self._ui.static_SexIcon_Mating_Right:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.static_SexIcon_Mating_Right:setRenderTexture(self._ui.static_SexIcon_Mating_Right:getBaseTexture())
  end
  self._ui.staticText_Tier_Mating_Right:SetShow(true)
  if 9 == auctionServantInfo:getTier() then
    self._ui.staticText_Tier_Mating_Right:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9"))
  else
    self._ui.staticText_Tier_Mating_Right:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", auctionServantInfo:getTier()))
  end
  self._ui.staticText_Name_Mating_Right:SetShow(false)
  self._ui.staticText_Location_Mating_Right:SetShow(true)
  self._ui.staticText_Location_Mating_Right:SetText(auctionServantInfo:getRegionName())
end
function Panel_Window_StableExchange_info:setContentMating()
  if nil == isBoth then
    isBoth = true
  end
  if true == isBoth or true == isLeft then
    for index = 0, self._config.maxSlotCount - 1 do
      local slot = self._leftSlot[index]
      slot.slotNo = self._value.leftStartIndex + index
      if slot.slotNo < self._value.leftSlotCount then
        local servantIndex = self._leftDataIndex[slot.slotNo]
        if slot.slotNo == self._value.leftCurrentSlotNo then
          slot:selectSlot(true)
        end
        slot:setSlotHorse(servantIndex)
      end
    end
  end
  self._ui.static_Mating_Right:SetShow(true)
  self._ui.static_Right:SetShow(false)
  self:setMatingSlot(self._value.matingSlotNo)
  if true == isBoth or false == isLeft then
    for index = 0, self._config.maxSlotCount - 1 do
      local slot = self._rightSlot[index]
      slot.slotNo = self._value.rightStartIndex + index
      if slot.slotNo < self._value.rightSlotCount then
        if slot.slotNo == self._value.rightCurrentSlotNo then
          slot:selectSlot(true)
        end
        slot:setSlotHorseByMating(self._value.matingSlotNo)
      end
    end
  end
end
function Panel_Window_StableExchange_info:setContentLink(isBoth, isLeft)
  if nil == isBoth then
    isBoth = true
  end
  if true == isBoth or true == isLeft then
    for index = 0, self._config.maxSlotCount - 1 do
      local slot = self._leftSlot[index]
      slot.slotNo = self._value.leftStartIndex + index
      if slot.slotNo < self._value.leftSlotCount then
        local servantIndex = self._leftDataIndex[slot.slotNo]
        if slot.slotNo == self._value.leftCurrentSlotNo then
          slot:selectSlot(true)
        end
        slot:setSlotLink(servantIndex)
      end
    end
  end
  self._ui.static_Mating_Right:SetShow(false)
  self._ui.static_Right:SetShow(true)
  if true == isBoth or false == isLeft then
    for index = 0, self._config.maxSlotCount - 1 do
      local slot = self._rightSlot[index]
      slot.slotNo = self._value.rightStartIndex + index
      if slot.slotNo < self._value.rightSlotCount then
        local servantIndex = self._rightDataIndex[slot.slotNo]
        if slot.slotNo == self._value.rightCurrentSlotNo then
          slot:selectSlot(true)
        end
        slot:setSlotLink(servantIndex)
      end
    end
  end
end
function Panel_Window_StableExchange_info:setMatingData()
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local regionName = regionInfo:getAreaName()
  local maleHorse = 1
  local femaleHorse = 0
  local servantCount = stable_count()
  for index = 0, stable_count() - 1 do
    local servantInfo = stable_getServant(index)
    if regionName == servantInfo:getRegionName() then
      local isUnLinkedHorse = not servantInfo:isLink() and CppEnums.VehicleType.Type_Horse == servantInfo:getVehicleType() and not servantInfo:isSeized() and CppEnums.ServantStateType.Type_Stable == servantInfo:getStateType() and 0 ~= servantInfo:getMatingCount()
      if isUnLinkedHorse and not servantInfo:isMale() then
        self._leftDataIndex[femaleHorse] = index
        femaleHorse = femaleHorse + 1
      end
    end
  end
  self._value.leftSlotCount = femaleHorse
  self._value.rightSlotCount = maleHorse
  if 0 == femaleHorse then
    return false
  else
    return true
  end
end
function Panel_Window_StableExchange_info:setExchangeData()
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local regionName = regionInfo:getAreaName()
  local maleHorse = 0
  local femaleHorse = 0
  local servantCount = stable_count()
  for index = 0, stable_count() - 1 do
    local servantInfo = stable_getServant(index)
    if regionName == servantInfo:getRegionName() then
      local isUnLinkedHorse = not servantInfo:isLink() and CppEnums.VehicleType.Type_Horse == servantInfo:getVehicleType() and not servantInfo:isSeized() and CppEnums.ServantStateType.Type_Stable == servantInfo:getStateType()
      if isUnLinkedHorse then
        if servantInfo:isMale() then
          self._leftDataIndex[maleHorse] = index
          maleHorse = maleHorse + 1
        else
          self._rightDataIndex[femaleHorse] = index
          femaleHorse = femaleHorse + 1
        end
      end
    end
  end
  self._value.leftSlotCount = maleHorse
  self._value.rightSlotCount = femaleHorse
  if 0 == maleHorse or 0 == femaleHorse then
    return false
  else
    return true
  end
end
function Panel_Window_StableExchange_info:setLinkData()
  local talker = dialog_getTalker()
  local npcActorproxy = talker:get()
  local npcPosition = npcActorproxy:getPosition()
  local npcRegionInfo = getRegionInfoByPosition(npcPosition)
  local linkAbleHorse = 0
  local linkAbleCarrige = 0
  local servantCount = stable_count()
  for index = 0, stable_count() - 1 do
    local servantInfo = stable_getServant(index)
    local name = servantInfo:getName()
    if npcRegionInfo:getAreaName() == servantInfo:getRegionName() then
      local isUnLinkedHorse = not servantInfo:isLink() and CppEnums.VehicleType.Type_Horse == servantInfo:getVehicleType() and not servantInfo:isSeized() and CppEnums.ServantStateType.Type_Stable == servantInfo:getStateType()
      if isUnLinkedHorse then
        self._rightDataIndex[linkAbleHorse] = index
        linkAbleHorse = linkAbleHorse + 1
      end
      if CppEnums.VehicleType.Type_Carriage == servantInfo:getVehicleType() or CppEnums.VehicleType.Type_RepairableCarriage == servantInfo:getVehicleType() then
        local maxLinkCount = servantInfo:getLinkCount()
        local currentLinkCount = servantInfo:getCurrentLinkCount()
        if maxLinkCount > currentLinkCount then
          self._leftDataIndex[linkAbleCarrige] = index
          linkAbleCarrige = linkAbleCarrige + 1
        end
      end
    end
  end
  self._value.leftSlotCount = linkAbleCarrige
  self._value.rightSlotCount = linkAbleHorse
  if 0 == linkAbleCarrige or 0 == linkAbleHorse then
    return false
  else
    return true
  end
end
function Panel_Window_StableExchange_info:open()
  Panel_Window_Stable_Exchange:SetShow(true)
end
function Panel_Window_StableExchange_info:close()
  Panel_Window_Stable_Exchange:SetShow(false)
end
function Panel_Window_StableExchange_info:checkRemainMate(index, isLeft)
  local servantInfo
  if true == isLeft then
    local leftSlot = self._value.leftStartIndex + index
    local leftSlotNo = self._leftDataIndex[leftSlot]
    servantInfo = stable_getServant(leftSlotNo)
    self._nowLeftServantNo = leftSlotNo
  else
    local rightSlot = self._value.rightStartIndex + index
    local rightSlotNo = self._rightDataIndex[rightSlot]
    servantInfo = stable_getServant(rightSlotNo)
    self._nowRightServantNo = rightSlotNo
  end
  if nil == servantInfo then
    return
  end
  local function doSelect()
    PaGlobalFunc_StableExchange_ClickSelectXXX(index, isLeft)
  end
  local function doUnSelect()
    PaGlobalFunc_StableExchange_ClickUnSelectXXX(index, isLeft)
  end
  local matingCount = servantInfo:getMatingCount()
  if matingCount > 0 then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SELECTSERVANT")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_EXCHANGE_CONFIRM"),
      content = messageBoxMemo,
      functionYes = doSelect,
      functionNo = doUnSelect,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  elseif true == isLeft then
    self._value.leftLastSlotIndex = self._value.leftCurrnetSlotIndex
    self._value.leftCurrnetSlotIndex = index
    self._value.leftCurrentSlotNo = self._value.leftStartIndex + self._value.leftCurrnetSlotIndex
    if nil ~= self._value.leftLastSlotIndex then
      local lastleftSlotNo = self._value.leftStartIndex + self._value.leftLastSlotIndex
      if nil ~= self._leftSlot[lastleftSlotNo] then
        self._leftSlot[lastleftSlotNo]:selectSlot(false)
      end
    end
    self._leftSlot[index]:selectSlot(true)
  else
    self._value.rightLastSlotIndex = self._value.rightCurrnetSlotIndex
    self._value.rightCurrnetSlotIndex = index
    self._value.rightCurrentSlotNo = self._value.rightStartIndex + self._value.rightCurrnetSlotIndex
    if nil ~= self._value.rightLastSlotIndex then
      local lastRightSlotNo = self._value.rightStartIndex + self._value.rightLastSlotIndex
      if nil ~= self._rightSlot[lastRightSlotNo] then
        self._rightSlot[lastRightSlotNo]:selectSlot(false)
      end
    end
    self._rightSlot[index]:selectSlot(true)
  end
end
function PaGlobalFunc_StableExchange_GetShow()
  return Panel_Window_Stable_Exchange:GetShow()
end
function PaGlobalFunc_StableExchange_Open()
  local self = Panel_Window_StableExchange_info
  self:open()
end
function PaGlobalFunc_StableExchange_Close()
  local self = Panel_Window_StableExchange_info
  self:close()
end
function PaGlobalFunc_StableExchange_Exit()
  local retval = false
  local self = Panel_Window_StableExchange_info
  if self._value.currentOpenType == self._enum.eTYPE_MATING then
    PaGlobalFunc_StableMating_Show()
    retval = true
  end
  self:close()
  return retval
end
function PaGlobalFunc_StableExchange_ShowByExchange()
  local self = Panel_Window_StableExchange_info
  self:initValue()
  local canOpen = self:setExchangeData()
  if false == canOpen then
    local text = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_EXCHANGE_NOT_SATISFIED_EXCHANGE")
    Proc_ShowMessage_Ack(text)
    return
  end
  self._value.currentOpenType = self._enum.eTYPE_EXCHANGE
  self:setContent(self._enum.eTYPE_EXCHANGE)
  self:open()
end
function PaGlobalFunc_StableExchange_ShowByMating(matingSlotNo, transferType, price)
  local self = Panel_Window_StableExchange_info
  if nil == matingSlotNo then
    return
  end
  self:initValue()
  if nil == transferType then
    self._value.transferType = CppEnums.TransferType.TransferType_Normal
  end
  self._value.transferType = transferType
  local canOpen = self:setMatingData()
  if false == canOpen then
    local text = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_EXCHANGE_NOT_SATISFIED_MATE")
    Proc_ShowMessage_Ack(text)
    self:close()
    return
  end
  self._value.matingPrice = price
  self._value.matingSlotNo = matingSlotNo
  self._value.currentOpenType = self._enum.eTYPE_MATING
  self:setContent(self._enum.eTYPE_MATING)
  self:open()
  PaGlobalFunc_StableMating_Close()
end
function PaGlobalFunc_StableExchange_ShowByLink()
  local self = Panel_Window_StableExchange_info
  self:initValue()
  local canOpen = self:setLinkData(self._enum.eTYPE_LINK)
  if false == canOpen then
    local text = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_EXCHANGE_NOT_SATISFIED_LINK")
    Proc_ShowMessage_Ack(text)
    self:close()
    return
  end
  self._value.currentOpenType = self._enum.eTYPE_LINK
  self:setContent(self._enum.eTYPE_LINK)
  self:open()
end
function PaGlobalFunc_StableExchange_PadButton_X()
  local self = Panel_Window_StableExchange_info
  if self._value.currentOpenType == self._enum.eTYPE_EXCHANGE then
    PaGlobalFunc_StableExchange_DoExchange()
  elseif self._value.currentOpenType == self._enum.eTYPE_MATING then
    PaGlobalFunc_StableExchange_DoMate()
  elseif self._value.currentOpenType == self._enum.eTYPE_LINK then
    PaGlobalFunc_StableExchange_DoLink()
  end
end
function PaGlobalFunc_StableExchange_DoLink()
  local self = Panel_Window_StableExchange_info
  if nil == self._value.leftCurrnetSlotIndex then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_EXCHANGE_NOT_SATISFIED_EXCHANGE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if nil == self._value.rightCurrnetSlotIndex then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_EXCHANGE_SELECT_HORSE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if nil ~= self._nowLeftServantNo and nil ~= self._nowRightServantNo then
    stable_link(self._nowRightServantNo, self._nowLeftServantNo, true)
    PaGlobalFunc_StableList_Update()
  end
  self:close()
end
function PaGlobalFunc_StableExchange_ReleaseLink(servantSlotNo, CarriageSlotNo)
  if nil == servantSlotNo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_STABLE_ALERT"))
    return
  end
  local function releaseCarriage()
    stable_link(servantSlotNo, CarriageSlotNo, false)
    PaGlobalFunc_StableList_Update()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_CARRIAGE_UNLINK_ALERT")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_CARRIAGE_UNLINK"),
    content = messageBoxMemo,
    functionYes = releaseCarriage,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_StableExchange_DoExchange()
  local self = Panel_Window_StableExchange_info
  if nil == self._value.leftCurrnetSlotIndex or nil == self._value.rightCurrnetSlotIndex then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMIX_SELECTMIX_PLS")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  local function servantMix()
    local self = Panel_Window_StableExchange_info
    local whereType = MessageBoxCheck.isCheck()
    local leftServantNo = stable_getServant(self._nowLeftServantNo):getServantNo()
    local rightServantNo = stable_getServant(self._nowRightServantNo):getServantNo()
    PaGlobalFunc_StableRegister_Name_Show(leftServantNo, rightServantNo, whereType)
    self:close()
  end
  local messageBoxMemo = ""
  if isContentsStallionEnable then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMIX_TEXT_MIXHELPMSG")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMIX_TEXT_MIXHELPMSG2")
  end
  local matingServantPrice = getServantSelfMatingPrice()
  messageBoxMemo = messageBoxMemo .. "\n" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEMIX_MATINGPRICE", "matingServantPrice", makeDotMoney(matingServantPrice))
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_EXCHANGE_CONFIRM"),
    content = messageBoxMemo,
    functionApply = servantMix,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBoxCheck.showMessageBox(messageBoxData)
end
function PaGlobalFunc_StableExchange_DoMate()
  local self = Panel_Window_StableExchange_info
  if nil == self._value.leftCurrnetSlotIndex then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABLE_MATING_PLZSELECT")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if nil == self._value.matingSlotNo then
    return
  end
  local function servantMate()
    local whereType = MessageBoxCheck.isCheck()
    local leftSlot = self._value.leftStartIndex + self._value.leftCurrnetSlotIndex
    local leftSlotNo = self._leftDataIndex[leftSlot]
    if nil ~= self._nowLeftServantNo then
      stable_startServantMating(self._nowLeftServantNo, self._value.matingSlotNo, self._value.transferType, whereType)
    end
    if true == PaGlobalFunc_StableExchange_Exit() then
      PaGlobalFunc_StableMating_Show()
    end
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_MATING_NOTIFY") .. "\n" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEREGISTER_MATING_PRICE", "matingPrice", self._value.matingPrice)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = messageBoxMemo,
    functionApply = servantMate,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBoxCheck.showMessageBox(messageBoxData)
end
function PaGlobalFunc_StableExchange_Select(index, isLeft)
  local self = Panel_Window_StableExchange_info
  if true == isLeft then
    if index == self._value.leftCurrnetSlotIndex then
      return
    end
    self._value.leftLastSlotIndex = self._value.leftCurrnetSlotIndex
    self._value.leftCurrnetSlotIndex = index
  else
    if index == self._value.rightCurrnetSlotIndex then
      return
    end
    self._value.rightLastSlotIndex = self._value.rightCurrnetSlotIndex
    self._value.rightCurrnetSlotIndex = index
  end
end
function PaGlobalFunc_StableExchange_ClickUnSelectXXX(index, isLeft)
  local self = Panel_Window_StableExchange_info
  if true == isLeft then
    self._value.leftLastSlotIndex = self._value.leftCurrnetSlotIndex
    self._value.leftCurrnetSlotIndex = index
    self._value.leftCurrentSlotNo = self._value.leftStartIndex + self._value.leftCurrnetSlotIndex
    self._leftSlot[index]:selectSlot(false)
    self._value.leftCurrnetSlotIndex = nil
  else
    self._value.rightLastSlotIndex = self._value.rightCurrnetSlotIndex
    self._value.rightCurrnetSlotIndex = index
    self._value.rightCurrentSlotNo = self._value.rightStartIndex + self._value.rightCurrnetSlotIndex
    self._rightSlot[index]:selectSlot(false)
    self._value.rightCurrnetSlotIndex = nil
  end
end
function PaGlobalFunc_StableExchange_ClickSelectXXX(index, isLeft)
  local self = Panel_Window_StableExchange_info
  if true == isLeft then
    self._value.leftLastSlotIndex = self._value.leftCurrnetSlotIndex
    self._value.leftCurrnetSlotIndex = index
    if nil ~= self._value.leftLastSlotIndex then
      local lastleftSlotNo = self._value.leftStartIndex + self._value.leftLastSlotIndex
      if nil ~= self._leftSlot[lastleftSlotNo] then
        self._leftSlot[lastleftSlotNo]:selectSlot(false)
      end
    end
    self._value.leftCurrentSlotNo = self._value.leftStartIndex + self._value.leftCurrnetSlotIndex
    self._leftSlot[index]:selectSlot(true)
  else
    self._value.rightLastSlotIndex = self._value.rightCurrnetSlotIndex
    self._value.rightCurrnetSlotIndex = index
    if nil ~= self._value.rightLastSlotIndex then
      local lastRightSlotNo = self._value.rightStartIndex + self._value.rightLastSlotIndex
      if nil ~= self._rightSlot[lastRightSlotNo] then
        self._rightSlot[lastRightSlotNo]:selectSlot(false)
      end
    end
    self._value.rightCurrentSlotNo = self._value.rightStartIndex + self._value.rightCurrnetSlotIndex
    self._rightSlot[index]:selectSlot(true)
  end
end
function PaGlobalFunc_StableExchange_ClickSelect(index, isLeft)
  local self = Panel_Window_StableExchange_info
  if true == isLeft then
    if self._value.currentOpenType == self._enum.eTYPE_EXCHANGE then
      self:checkRemainMate(index, isLeft)
      return
    end
    local leftSlot = self._value.leftStartIndex + index
    local leftSlotNo = self._leftDataIndex[leftSlot]
    self._nowLeftServantNo = leftSlotNo
    self._value.leftLastSlotIndex = self._value.leftCurrnetSlotIndex
    self._value.leftCurrnetSlotIndex = index
    self._value.leftCurrentSlotNo = self._value.leftStartIndex + self._value.leftCurrnetSlotIndex
    if nil ~= self._value.leftLastSlotIndex then
      local lastleftSlotNo = self._value.leftStartIndex + self._value.leftLastSlotIndex
      if nil ~= self._leftSlot[lastleftSlotNo] then
        self._leftSlot[lastleftSlotNo]:selectSlot(false)
      end
    end
    self._leftSlot[index]:selectSlot(true)
  else
    if self._value.currentOpenType == self._enum.eTYPE_EXCHANGE then
      self:checkRemainMate(index, isLeft)
      return
    end
    local rightSlot = self._value.rightStartIndex + index
    local rightSlotNo = self._rightDataIndex[rightSlot]
    self._nowRightServantNo = rightSlotNo
    self._value.rightLastSlotIndex = self._value.rightCurrnetSlotIndex
    self._value.rightCurrnetSlotIndex = index
    self._value.rightCurrentSlotNo = self._value.rightStartIndex + self._value.rightCurrnetSlotIndex
    if nil ~= self._value.rightLastSlotIndex then
      local lastRightSlotNo = self._value.rightStartIndex + self._value.rightLastSlotIndex
      if nil ~= self._rightSlot[lastRightSlotNo] then
        self._rightSlot[lastRightSlotNo]:selectSlot(false)
      end
    end
    self._rightSlot[index]:selectSlot(true)
  end
end
function PaGlobalFunc_StableExchange_ScrollEvent(isUpScroll, isLeft)
  local self = Panel_Window_StableExchange_info
  if true == isLeft then
    if self._value.leftSlotCount <= self._config.maxSlotCount then
      return
    end
    local beforeSlotIndex = self._value.leftStartIndex
    self._value.leftStartIndex = UIScroll.ScrollEvent(self._ui.left_VerticalScroll, isUpScroll, self._config.slotRow, self._value.leftSlotCount, self._value.leftStartIndex, self._config.slotCol)
    if self._value.leftStartIndex < self._config.slotCol then
      self._value.leftStartIndex = self._value.leftStartIndex * self._config.slotCol
    end
    if (ToClient_isConsole() or ToClient_IsDevelopment()) and beforeSlotIndex ~= self._value.leftStartIndex then
      ToClient_padSnapIgnoreGroupMove()
    end
    self:updateContent(self._value.currentOpenType, false, true)
  else
    if self._value.rightSlotCount <= self._config.maxSlotCount then
      return
    end
    local beforeSlotIndex = self._value.rightStartIndex
    self._value.rightStartIndex = UIScroll.ScrollEvent(self._ui.right_VerticalScroll, isUpScroll, self._config.slotRow, self._value.rightSlotCount, self._value.rightStartIndex, self._config.slotCol)
    if self._value.rightStartIndex < self._config.slotCol then
      self._value.rightStartIndex = self._value.rightStartIndex * self._config.slotCol
    end
    if (ToClient_isConsole() or ToClient_IsDevelopment()) and beforeSlotIndex ~= self._value.rightStartIndex then
      ToClient_padSnapIgnoreGroupMove()
    end
    self:updateContent(self._value.currentOpenType, false, false)
  end
end
function FromClient_StableExchange_Init()
  local self = Panel_Window_StableExchange_info
  self:initialize()
end
function FromClient_StableExchange_Resize()
  local self = Panel_Window_StableExchange_info
  self:resize()
end
function FromClient_StableExchange_ServantMix(servantNo1, servantNo2)
  local self = stableMix
  local servantInfo1 = stable_getServantByServantNo(servantNo1)
  local servantName1 = servantInfo1:getName()
  local servantInfo2 = stable_getServantByServantNo(servantNo2)
  local servantName2 = servantInfo2:getName()
  Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_STABLEMIX_MIX_ACK", "servantName1", servantName1, "servantName2", servantName2))
  PaGlobalFunc_StableExchange_Close()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_StableExchange_Init")
