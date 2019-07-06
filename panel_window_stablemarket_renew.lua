local Panel_Window_StableMarket_info = {
  _ui = {
    static_TopBg = nil,
    radioButton_MarketList_ConsoleUI = nil,
    radioButton_MyList_ConsoleUI = nil,
    static_Page = nil,
    static_PagePre_ConsoleUI = nil,
    static_PageNext_ConsoleUI = nil,
    staticText_Page = nil,
    static_CenterBg = nil,
    radioButton_List_Templete = nil,
    static_Profile = nil,
    staticText_LV = nil,
    staticText_HP = nil,
    staticText_SP = nil,
    staticText_Weight = nil,
    staticText_Speed = nil,
    staticText_Acc = nil,
    staticText_Rotate = nil,
    staticText_Break = nil,
    staticText_LeftMatingCountTitle = nil,
    static_Image = nil,
    static_Gender = nil,
    staticText_Generation = nil,
    staticText_LVVal = nil,
    staticText_HPVal = nil,
    staticText_SPVal = nil,
    staticText_WeightVal = nil,
    staticText_SpeedVal = nil,
    staticText_AccVal = nil,
    staticText_RotateVal = nil,
    staticText_BreakVal = nil,
    staticText_LeftMatingCountValue = nil,
    staticText_Silver = nil,
    staticText_Select_ConsoleUI = nil,
    staticText_Inven_Val = nil,
    staticText_Storage = nil,
    staticText_Storage_Val = nil,
    static_Filter = nil,
    staticText_Filter = nil,
    staticText_Filter_Setting_ConsoleUI = nil,
    list2_1_Skill = nil,
    list2_1_Content_Skill = nil,
    static_SkillSlot_Template = nil,
    static_Skill_Icon = nil,
    circularProgress_Train = nil,
    staticText_Percent = nil,
    staticText_Name = nil,
    staticText_Command = nil
  },
  _value = {
    openByNpc = true,
    lastTab = 0,
    currentTab = 0,
    lastMarketIndex = 0,
    currentMarketIndex = 0,
    startMarketSlotNo = 0,
    currentPage = 0,
    myAuctionInfo = nil
  },
  _pos = {
    firstPosX = 0,
    firstPosY = 0,
    marketSlotSizeY = 120,
    marketSlotSpaceY = 10
  },
  _enum = {eTAB_MARKET = 0, eTAB_MY_MARKET = 1},
  _config = {
    maxShowListCnt = 6,
    isResizeListContent = false,
    listDefaultSizeX = 315,
    maxSlotCount = 4,
    maxPage = 99
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
    }
  },
  _slotMarket = {},
  _skillId = {}
}
local isContentsStallionEnable = ToClient_IsContentsGroupOpen("243")
function Panel_Window_StableMarket_info:registEventHandler()
  Panel_Window_StableMarket:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_StableMarket_SetFilter()")
  Panel_Window_StableMarket:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_StableMarket_Reload()")
  Panel_Window_StableMarket:registerPadEvent(__eConsoleUIPadEvent_LT, "PaGlobalFunc_StableMarket_TabEvent(false)")
  Panel_Window_StableMarket:registerPadEvent(__eConsoleUIPadEvent_RT, "PaGlobalFunc_StableMarket_TabEvent(true)")
  Panel_Window_StableMarket:registerPadEvent(__eConsoleUIPadEvent_Up_DpadLeft, "PaGlobalFunc_StableMarket_PageChange(false)")
  Panel_Window_StableMarket:registerPadEvent(__eConsoleUIPadEvent_Up_DpadRight, "PaGlobalFunc_StableMarket_PageChange(true)")
  self._ui.static_PagePre_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMarket_PageChange(false)")
  self._ui.static_PageNext_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMarket_PageChange(true)")
  self._ui.radioButton_MarketList_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMarket_TabEvent(false)")
  self._ui.radioButton_MyList_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMarket_TabEvent(true)")
end
function Panel_Window_StableMarket_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_StableMarket_Resize")
  registerEvent("FromClient_AuctionServantList", "PaGlobalFunc_StableMarket_Update")
  registerEvent("FromClient_ServantRegisterToAuction", "PaGlobalFunc_StableMarket_TabEventFromRegister")
  registerEvent("FromClient_InventoryUpdate", "PaGlobalFunc_StableMarket_Update_Money")
  registerEvent("EventWarehouseUpdate", "PaGlobalFunc_StableMarket_Update_Money")
  registerEvent("FromClient_ServantBuyMarket", "PaGlobalFunc_StableMarket_Update_Money")
  registerEvent("FromClient_ResponseServantBuyItNowFail", "PaGlobalFunc_StableMarket_ResponseServantBuyItNowFail")
end
function Panel_Window_StableMarket_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:createMarketSlot()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_StableMarket_info:initValue()
  self._value.openByNpc = true
  self._value.lastTab = self._enum.eTAB_MARKET
  self._value.currentTab = self._enum.eTAB_MARKET
  self._value.lastMarketIndex = 0
  self._value.currentMarketIndex = 0
  self._value.startMarketSlotNo = 0
  self._value.currentPage = 0
  self._value.myAuctionInfo = nil
end
function Panel_Window_StableMarket_info:initUpdateValue()
  self._value.lastMarketIndex = 0
  self._value.currentMarketIndex = 0
  self._value.startMarketSlotNo = 0
  self._value.currentPage = 0
  self._value.myAuctionInfo = nil
end
function Panel_Window_StableMarket_info:setValueOpenByNpc()
  self._value.openByNpc = not ToClient_WorldMapIsShow()
end
function Panel_Window_StableMarket_info:resize()
end
function Panel_Window_StableMarket_info:childControl()
  self._ui.static_TopBg = UI.getChildControl(Panel_Window_StableMarket, "Static_TopBg")
  self._ui.radioButton_MarketList_ConsoleUI = UI.getChildControl(self._ui.static_TopBg, "RadioButton_MarketList_ConsoleUI")
  self._ui.radioButton_MyList_ConsoleUI = UI.getChildControl(self._ui.static_TopBg, "RadioButton_MyList_ConsoleUI")
  self._ui.static_Page = UI.getChildControl(Panel_Window_StableMarket, "Static_Page")
  self._ui.static_PagePre_ConsoleUI = UI.getChildControl(self._ui.static_Page, "Static_PagePre_ConsoleUI")
  self._ui.static_PageNext_ConsoleUI = UI.getChildControl(self._ui.static_Page, "Static_PageNext_ConsoleUI")
  self._ui.staticText_Page = UI.getChildControl(self._ui.static_Page, "StaticText_Page")
  self._ui.static_CenterBg = UI.getChildControl(Panel_Window_StableMarket, "Static_CenterBg")
  self._ui.radioButton_List_Templete = UI.getChildControl(self._ui.static_CenterBg, "RadioButton_List_Templete")
  self._ui.static_Profile = UI.getChildControl(self._ui.radioButton_List_Templete, "Static_Profile")
  self._ui.staticText_LV = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_LV")
  self._ui.staticText_HP = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_HP")
  self._ui.staticText_SP = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_SP")
  self._ui.staticText_Weight = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Weight")
  self._ui.staticText_Speed = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Speed")
  self._ui.staticText_Acc = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Acc")
  self._ui.staticText_Rotate = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Rotate")
  self._ui.staticText_Break = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Break")
  self._ui.staticText_LeftMatingCountTitle = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_LeftMatingCountTitle")
  self._ui.static_Image = UI.getChildControl(self._ui.radioButton_List_Templete, "Static_Image")
  self._ui.static_Gender = UI.getChildControl(self._ui.radioButton_List_Templete, "Static_Gender")
  self._ui.staticText_Generation = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Generation")
  self._ui.staticText_LVVal = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_LVVal")
  self._ui.staticText_HPVal = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_HPVal")
  self._ui.staticText_SPVal = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_SPVal")
  self._ui.staticText_WeightVal = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_WeightVal")
  self._ui.staticText_SpeedVal = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_SpeedVal")
  self._ui.staticText_AccVal = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_AccVal")
  self._ui.staticText_RotateVal = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_RotateVal")
  self._ui.staticText_BreakVal = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_BreakVal")
  self._ui.staticText_LeftMatingCountValue = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_LeftMatingCountValue")
  self._ui.staticText_Line = UI.getChildControl(self._ui.radioButton_List_Templete, "Static_Line2")
  self._ui.staticText_Silver = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Silver")
  self._ui.radioButton_List_Templete:SetShow(false)
  self._pos.firstPosX = self._ui.radioButton_List_Templete:GetPosX()
  self._pos.firstPosY = self._ui.radioButton_List_Templete:GetPosY()
  self._pos.marketSlotSizeY = self._ui.radioButton_List_Templete:GetSizeY()
  self._ui.staticText_Inven_Val = UI.getChildControl(Panel_Window_StableMarket, "StaticText_Inven_Val")
  self._ui.staticText_Storage = UI.getChildControl(Panel_Window_StableMarket, "StaticText_Storage")
  self._ui.staticText_Storage_Val = UI.getChildControl(Panel_Window_StableMarket, "StaticText_Storage_Val")
  self._ui.static_Filter = UI.getChildControl(Panel_Window_StableMarket, "Static_Filter")
  self._ui.staticText_Select_ConsoleUI = UI.getChildControl(self._ui.static_Filter, "StaticText_Select_ConsoleUI")
  self._ui.staticText_Filter = UI.getChildControl(self._ui.static_Filter, "StaticText_Filter")
  self._ui.staticText_Filter_Setting_ConsoleUI = UI.getChildControl(self._ui.static_Filter, "StaticText_Filter_Setting_ConsoleUI")
  self._ui.staticText_Keyguide_A = UI.getChildControl(self._ui.static_Filter, "StaticText_Refresh_ConsoleUI")
  self._ui.staticText_Keyguide_Y = UI.getChildControl(self._ui.static_Filter, "StaticText_Select_ConsoleUI")
  self.keyguideGroup = {
    self._ui.staticText_Keyguide_A,
    self._ui.staticText_Keyguide_Y
  }
  self._ui.list2_1_Skill = UI.getChildControl(Panel_Window_StableMarket, "List2_1_Skill")
  self._ui.list2_1_Content_Skill = UI.getChildControl(self._ui.list2_1_Skill, "List2_1_Content_Skill")
  self._ui.list2_1_Skill:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_StableMarket_SkillEventControlCreate")
  self._ui.list2_1_Skill:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function Panel_Window_StableMarket_info:createMarketSlot()
  for index = 0, self._config.maxSlotCount - 1 do
    local slot = {
      selected = false,
      slotNo = 0,
      radiobutton = nil,
      static_Profile = nil,
      staticText_LV = nil,
      staticText_HP = nil,
      staticText_SP = nil,
      staticText_Weight = nil,
      staticText_Speed = nil,
      staticText_Acc = nil,
      staticText_Rotate = nil,
      staticText_Break = nil,
      staticText_LeftMatingCountTitle = nil,
      static_Image = nil,
      static_Gender = nil,
      staticText_Generation = nil,
      staticText_LVVal = nil,
      staticText_HPVal = nil,
      staticText_SPVal = nil,
      staticText_WeightVal = nil,
      staticText_SpeedVal = nil,
      staticText_AccVal = nil,
      staticText_RotateVal = nil,
      staticText_BreakVal = nil,
      staticText_LeftMatingCountValue = nil,
      Static_Line2 = nil,
      staticText_Silver = nil,
      staticText_Select_ConsoleUI = nil
    }
    function slot:setPos(index)
      local marketInfo = Panel_Window_StableMarket_info
      self.radiobutton:SetPosXY(marketInfo._pos.firstPosX, marketInfo._pos.firstPosY + index * (marketInfo._pos.marketSlotSizeY + marketInfo._pos.marketSlotSpaceY))
    end
    function slot:setServant(myAuctionInfo, slotNo)
      self.slotNo = slotNo
      local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(slotNo)
      if auctionServantInfo:getBaseIconPath1() ~= auctionServantInfo:getIconPath1() then
        self.static_Image:ChangeTextureInfoName(auctionServantInfo:getIconPath1())
      else
        self.static_Image:ChangeTextureInfoName(auctionServantInfo:getBaseIconPath1())
      end
      if auctionServantInfo:doMating() and 9 ~= auctionServantInfo:getTier() then
        local matintext = ""
        local matingCount = auctionServantInfo:getMatingCount()
        if auctionServantInfo:doClearCountByMating() then
          matintext = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETOK", "deadCount", matingCount)
        else
          matintext = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETNO", "deadCount", matingCount)
        end
        self.staticText_LeftMatingCountTitle:SetShow(true)
        self.staticText_LeftMatingCountValue:SetShow(true)
        self.staticText_LeftMatingCountValue:SetText(matintext)
      else
        self.staticText_LeftMatingCountTitle:SetShow(false)
        self.staticText_LeftMatingCountValue:SetShow(false)
      end
      local marketInfo = Panel_Window_StableMarket_info
      if auctionServantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
        self.static_Gender:SetShow(true)
        if auctionServantInfo:isMale() then
          self.static_Gender:ChangeTextureInfoName(marketInfo._texture.sexIcon)
          local x1, y1, x2, y2 = setTextureUV_Func(self.static_Gender, marketInfo._texture.male.x1, marketInfo._texture.male.y1, marketInfo._texture.male.x2, marketInfo._texture.male.y2)
          self.static_Gender:getBaseTexture():setUV(x1, y1, x2, y2)
          self.static_Gender:setRenderTexture(self.static_Gender:getBaseTexture())
        else
          self.static_Gender:ChangeTextureInfoName(marketInfo._texture.sexIcon)
          local x1, y1, x2, y2 = setTextureUV_Func(self.static_Gender, marketInfo._texture.female.x1, marketInfo._texture.female.y1, marketInfo._texture.female.x2, marketInfo._texture.female.y2)
          self.static_Gender:getBaseTexture():setUV(x1, y1, x2, y2)
          self.static_Gender:setRenderTexture(self.static_Gender:getBaseTexture())
        end
        self.staticText_Generation:SetShow(true)
        if 9 == auctionServantInfo:getTier() and isContentsStallionEnable then
          self.staticText_Generation:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9"))
        else
          self.staticText_Generation:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", auctionServantInfo:getTier()))
        end
      else
        self.static_Gender:SetShow(false)
        self.staticText_Generation:SetShow(false)
      end
      self.staticText_LVVal:SetText(auctionServantInfo:getLevel())
      self.staticText_HPVal:SetText(auctionServantInfo:getMaxHp())
      self.staticText_SPVal:SetText(auctionServantInfo:getMaxMp())
      self.staticText_WeightVal:SetText(tostring(auctionServantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000))
      self.staticText_SpeedVal:SetText(string.format("%.1f", auctionServantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
      self.staticText_AccVal:SetText(string.format("%.1f", auctionServantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
      self.staticText_RotateVal:SetText(string.format("%.1f", auctionServantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
      self.staticText_BreakVal:SetText(string.format("%.1f", auctionServantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
      self.staticText_Silver:SetText(makeDotMoney(auctionServantInfo:getAuctoinPrice_s64()))
      self.staticText_Silver:SetSpanSize(self.staticText_Silver:GetSizeX() + self.staticText_Silver:GetTextSizeX() + 7, 8)
      local deadCount = auctionServantInfo:getDeadCount()
      if auctionServantInfo:doClearCountByDead() then
        deadCount = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETOK", "deadCount", deadCount)
      else
        deadCount = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETNO", "deadCount", deadCount)
      end
      local servantInfo = stable_getServantByServantNo(auctionServantInfo:getServantNo())
      if nil == servantInfo or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Camel or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Donkey or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant then
      elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Carriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_CowCarriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_RepairableCarriage then
      elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Boat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Raft or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_FishingBoat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_SailingBoat then
      end
    end
    function slot:setShow(bShow)
      bShow = bShow or false
      self.radiobutton:SetShow(bShow)
    end
    function slot:setSelect(bSelect)
      self.selected = bSelect
      self.radiobutton:SetCheck(bSelect)
    end
    function slot:clearServant()
      self.slotNo = 0
      self:setSelect(false)
      self:setShow(false)
    end
    slot.radiobutton = UI.createAndCopyBasePropertyControl(self._ui.static_CenterBg, "RadioButton_List_Templete", self._ui.static_CenterBg, "RadioButton_" .. index)
    slot.static_Profile = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "Static_Profile", slot.radiobutton, "Static_Profile_" .. index)
    slot.staticText_LV = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_LV", slot.radiobutton, "StaticText_LV_" .. index)
    slot.staticText_HP = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_HP", slot.radiobutton, "StaticText_HP_" .. index)
    slot.staticText_SP = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_SP", slot.radiobutton, "StaticText_SP_" .. index)
    slot.staticText_Weight = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_Weight", slot.radiobutton, "StaticText_Weight_" .. index)
    slot.staticText_Speed = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_Speed", slot.radiobutton, "StaticText_Speed_" .. index)
    slot.staticText_Acc = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_Acc", slot.radiobutton, "StaticText_Acc_" .. index)
    slot.staticText_Rotate = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_Rotate", slot.radiobutton, "StaticText_Rotate_" .. index)
    slot.staticText_Break = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_Break", slot.radiobutton, "StaticText_Break_" .. index)
    slot.staticText_LeftMatingCountTitle = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_LeftMatingCountTitle", slot.radiobutton, "StaticText_LeftMatingCountTitle_" .. index)
    slot.staticText_Line = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "Static_Line2", slot.radiobutton, "Static_Line2_" .. index)
    slot.static_Image = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "Static_Image", slot.radiobutton, "Static_Image_" .. index)
    slot.static_Gender = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "Static_Gender", slot.radiobutton, "Static_Gender_" .. index)
    slot.staticText_Generation = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_Generation", slot.radiobutton, "StaticText_Generation_" .. index)
    slot.staticText_LVVal = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_LVVal", slot.radiobutton, "StaticText_LVVal_" .. index)
    slot.staticText_HPVal = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_HPVal", slot.radiobutton, "StaticText_HPVal_" .. index)
    slot.staticText_SPVal = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_SPVal", slot.radiobutton, "StaticText_SPVal_" .. index)
    slot.staticText_WeightVal = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_WeightVal", slot.radiobutton, "StaticText_WeightVal_" .. index)
    slot.staticText_SpeedVal = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_SpeedVal", slot.radiobutton, "StaticText_SpeedVal_" .. index)
    slot.staticText_AccVal = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_AccVal", slot.radiobutton, "StaticText_AccVal_" .. index)
    slot.staticText_RotateVal = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_RotateVal", slot.radiobutton, "StaticText_RotateVal_" .. index)
    slot.staticText_BreakVal = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_BreakVal", slot.radiobutton, "StaticText_BreakVal_" .. index)
    slot.staticText_LeftMatingCountValue = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_LeftMatingCountValue", slot.radiobutton, "StaticText_LeftMatingCountValue_" .. index)
    slot.staticText_Silver = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_Silver", slot.radiobutton, "StaticText_Silver_" .. index)
    slot.slotNo = index
    slot:setPos(index)
    self._slotMarket[index] = slot
  end
end
function Panel_Window_StableMarket_info:clearSlot()
  for index = 0, self._config.maxSlotCount - 1 do
    self._slotMarket[index]:clearServant()
  end
end
function Panel_Window_StableMarket_info:setContent()
  ToClient_padSnapResetControl()
  self:clearSlot()
  if self._value.currentTab == self._enum.eTAB_MARKET then
    self:showFilter(true)
    self:setContentIsMarket()
  end
  if self._value.currentTab == self._enum.eTAB_MY_MARKET then
    self:showFilter(false)
    self:setContentIsMine()
  end
end
function Panel_Window_StableMarket_info:setPageText()
end
function Panel_Window_StableMarket_info:setContentIsMine()
  self._value.myAuctionInfo = RequestGetAuctionInfo()
  local myAuctionInfo = self._value.myAuctionInfo
  local servantCount = myAuctionInfo:getServantAuctionListCount()
  local currentPage = self._value.currentPage + 1
  self._ui.staticText_Page:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLE_MARKET_PAGE", "page", currentPage))
  self._value.startMarketSlotNo = self._value.currentPage * self._config.maxSlotCount
  for index = 0, self._config.maxSlotCount - 1 do
    local slot = self._slotMarket[index]
    slot.slotNo = self._value.startMarketSlotNo + index
    if servantCount > slot.slotNo then
      slot:setShow(true)
      slot:setServant(myAuctionInfo, slot.slotNo)
      slot.radiobutton:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMarket_ClickList(" .. index .. ")")
      slot.radiobutton:addInputEvent("Mouse_On", "PaGlobalFunc_StableMarket_SelectList(" .. index .. ")")
    end
  end
end
function Panel_Window_StableMarket_info:setContentIsMarket()
  self._value.myAuctionInfo = RequestGetAuctionInfo()
  local myAuctionInfo = self._value.myAuctionInfo
  local servantCount = myAuctionInfo:getServantAuctionListCount()
  local currentPage = myAuctionInfo:getCurrentPage() + 1
  self._ui.staticText_Page:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLE_MARKET_PAGE", "page", currentPage))
  for index = 0, self._config.maxSlotCount - 1 do
    local slot = self._slotMarket[index]
    slot.slotNo = index
    if servantCount > index then
      slot:setShow(true)
      slot:setServant(myAuctionInfo, slot.slotNo)
      slot.radiobutton:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMarket_ClickList(" .. index .. ")")
      slot.radiobutton:addInputEvent("Mouse_On", "PaGlobalFunc_StableMarket_SelectList(" .. index .. ")")
    end
  end
end
function Panel_Window_StableMarket_info:setContentSkill()
  self._ui.list2_1_Skill:getElementManager():clearKey()
  for k in pairs(self._skillId) do
    self._skillId[k] = nil
  end
  local myAuctionInfo = self._value.myAuctionInfo
  if nil == myAuctionInfo then
    return
  end
  local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(self._slotMarket[self._value.currentMarketIndex].slotNo)
  if nil == auctionServantInfo then
    return
  end
  local slotSkillCount = 0
  local skillKey = {}
  local learnSkillCount = vehicleSkillStaticStatus_skillCount()
  for jj = 1, learnSkillCount - 1 do
    local skillWrapper = auctionServantInfo:getSkill(jj)
    if nil ~= skillWrapper then
      self._skillId[slotSkillCount] = jj
      slotSkillCount = slotSkillCount + 1
    end
  end
  if 0 == slotSkillCount then
    self._ui.list2_1_Skill:SetShow(false)
    return
  end
  self._ui.list2_1_Skill:SetShow(true)
  self._config.isResizeListContent = false
  if slotSkillCount > self._config.maxShowListCnt then
    self._config.isResizeListContent = true
  end
  for index = 0, slotSkillCount - 1 do
    self._ui.list2_1_Skill:getElementManager():pushKey(toInt64(0, self._skillId[index]))
    self._ui.list2_1_Skill:requestUpdateByKey(toInt64(0, self._skillId[index]))
  end
end
function Panel_Window_StableMarket_info:setTab()
  self._ui.radioButton_MarketList_ConsoleUI:SetCheck(false)
  self._ui.radioButton_MyList_ConsoleUI:SetCheck(false)
  self._ui.radioButton_MarketList_ConsoleUI:SetFontColor(Defines.Color.C_FF626262)
  self._ui.radioButton_MyList_ConsoleUI:SetFontColor(Defines.Color.C_FF626262)
  if self._value.currentTab == self._enum.eTAB_MARKET then
    self._ui.radioButton_MarketList_ConsoleUI:SetCheck(true)
    self._ui.radioButton_MarketList_ConsoleUI:SetFontColor(Defines.Color.C_FFEEEEEE)
  end
  if self._value.currentTab == self._enum.eTAB_MY_MARKET then
    self._ui.radioButton_MyList_ConsoleUI:SetCheck(true)
    self._ui.radioButton_MyList_ConsoleUI:SetFontColor(Defines.Color.C_FFEEEEEE)
  end
end
function Panel_Window_StableMarket_info:open()
  Panel_Window_StableMarket:SetShow(true)
end
function Panel_Window_StableMarket_info:close()
  Panel_Window_StableMarket:SetShow(false)
end
function Panel_Window_StableMarket_info:closeSkill()
  self._ui.list2_1_Skill:SetShow(false)
end
function Panel_Window_StableMarket_info:showFilter(bShow)
  self._ui.staticText_Filter:SetShow(bShow)
  self._ui.staticText_Filter_Setting_ConsoleUI:SetShow(bShow)
end
function PaGlobalFunc_StableMarket_Open()
  local self = Panel_Window_StableMarket_info
  self:open()
end
function PaGlobalFunc_StableMarket_Show()
  local self = Panel_Window_StableMarket_info
  self:initValue()
  self:setValueOpenByNpc()
  PaGlobalFunc_StableMarket_Update_Money()
  setAuctionServantAllFilter(2, 0, 0, self._value.openByNpc)
  PaGlobalFunc_StableMarket_SetFilterText(PaGlobalFunc_StableMarket_Filter_GetDefaultFilterText())
  local isMine = PaGlobalFunc_StableMarket_ChecKTabMy()
  PaGlobalFunc_StableMarket_TabEventFromRegister(isMine)
  self:closeSkill()
  self:open()
end
function PaGlobalFunc_StableMarket_Close()
  local self = Panel_Window_StableMarket_info
  self:close()
end
function PaGlobalFunc_StableMarket_GetShow()
  return Panel_Window_StableMarket:GetShow()
end
function PaGlobalFunc_StableMarket_Update()
  if not PaGlobalFunc_StableMarket_GetShow() then
    return
  end
  local self = Panel_Window_StableMarket_info
  PaGlobalFunc_StableMarket_Update_Money()
  self:closeSkill()
  self:setTab()
  self:setContent()
end
function PaGlobalFunc_StableMarket_Update_Money()
  if true == _ContentsGroup_InvenUpdateCheck and false == Panel_Window_StableMarket:GetShow() then
    return
  end
  local self = Panel_Window_StableMarket_info
  self._ui.staticText_Inven_Val:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  if true == self._value.openByNpc then
    self._ui.staticText_Storage:SetShow(true)
    self._ui.staticText_Storage_Val:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
  else
    self._ui.staticText_Storage:SetShow(false)
    self._ui.staticText_Storage_Val:SetShow(false)
  end
end
function PaGlobalFunc_StableMarket_ChecKTabMy()
  local self = Panel_Window_StableMarket_info
  return self._value.currentTab == self._enum.eTAB_MY_MARKET
end
function PaGlobalFunc_StableMarket_TabEvent(isMyTab)
  local self = Panel_Window_StableMarket_info
  if PaGlobalFunc_StableMarket_ChecKTabMy() == isMyTab then
    self:closeSkill()
    PaGlobalFunc_StableMarket_TabEventXXX(not isMyTab)
    return
  end
  self:closeSkill()
  PaGlobalFunc_StableMarket_TabEventXXX(isMyTab)
end
function PaGlobalFunc_StableMarket_TabEventXXX(isMyTab)
  local self = Panel_Window_StableMarket_info
  self:initUpdateValue()
  if true == isMyTab then
    self._value.currentTab = self._enum.eTAB_MY_MARKET
    requestMyServantMarketList(self._value.openByNpc)
  else
    self._value.currentTab = self._enum.eTAB_MARKET
    requestServantMarketListPage(self._value.openByNpc)
  end
  _AudioPostEvent_SystemUiForXBOX(51, 7)
end
function PaGlobalFunc_StableMarket_TabEventFromRegister()
  local self = Panel_Window_StableMarket_info
  if not PaGlobalFunc_StableMarket_GetShow() then
    return
  end
  PaGlobalFunc_StableMarket_TabEventXXX(PaGlobalFunc_StableMarket_ChecKTabMy())
end
function PaGlobalFunc_StableMarket_SelectList(index)
  local self = Panel_Window_StableMarket_info
  self._value.lastMarketIndex = self._value.currentMarketIndex
  self._value.currentMarketIndex = index
  self._slotMarket[self._value.lastMarketIndex]:setSelect(false)
  self._slotMarket[self._value.currentMarketIndex]:setSelect(true)
  if true == PaGlobalFunc_StableMarket_ChecKTabMy() then
    local myAuctionInfo = self._value.myAuctionInfo
    if nil ~= myAuctionInfo then
      local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(self._slotMarket[self._value.currentMarketIndex].slotNo)
      if nil == auctionServantInfo then
        return
      end
      local isAuctionEnd = false
      local expireTime = auctionServantInfo:getMarketExpiredTime()
      if expireTime <= toInt64(0, 0) then
        isAuctionEnd = true
      end
      if true == self._value.openByNpc then
        local servantInfo = stable_getServantByServantNo(auctionServantInfo:getServantNo())
        if nil ~= servantInfo then
          if CppEnums.ServantStateType.Type_RegisterMarket == servantInfo:getStateType() then
            if isAuctionEnd then
              self._ui.staticText_Select_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMARKET_END"))
            else
              self._ui.staticText_Select_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMARKET_BTN_CANCEL"))
            end
          else
            self._ui.staticText_Select_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMARKET_BTN_RECEIVE"))
          end
        else
          self._ui.staticText_Select_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMARKET_BTN_RECEIVE"))
        end
      end
    end
  elseif true == self._value.openByNpc then
    self._ui.staticText_Select_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMARKET_BTN_BUY"))
    self._ui.staticText_Select_ConsoleUI:SetShow(true)
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self.keyguideGroup, self._ui.static_Filter, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self:setContentSkill()
end
function PaGlobalFunc_StableMarket_ClickList(index)
  local self = Panel_Window_StableMarket_info
  if true == PaGlobalFunc_StableMarket_ChecKTabMy() then
    local myAuctionInfo = self._value.myAuctionInfo
    if nil ~= myAuctionInfo then
      local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(self._slotMarket[self._value.currentMarketIndex].slotNo)
      local isAuctionEnd = false
      local expireTime = auctionServantInfo:getMarketExpiredTime()
      if expireTime <= toInt64(0, 0) then
        isAuctionEnd = true
      end
      if true == self._value.openByNpc then
        local servantInfo = stable_getServantByServantNo(auctionServantInfo:getServantNo())
        if nil ~= servantInfo then
          if CppEnums.ServantStateType.Type_RegisterMarket == servantInfo:getStateType() then
            if isAuctionEnd then
              PaGlobalFunc_StableMarket_Cancel()
            else
              PaGlobalFunc_StableMarket_Cancel()
            end
          else
            PaGlobalFunc_StableMarket_Receive()
          end
        else
          PaGlobalFunc_StableMarket_Receive()
        end
      end
    end
  else
    if true == self._value.openByNpc then
      PaGlobalFunc_StableMarket_Buy()
    else
    end
  end
end
function PaGlobalFunc_StableMarket_PageChange(isNext)
  local self = Panel_Window_StableMarket_info
  if true == isNext then
    if self._config.maxPage <= self._value.currentPage then
      return
    end
    self:closeSkill()
    self._value.currentPage = self._value.currentPage + 1
    if true == PaGlobalFunc_StableMarket_ChecKTabMy() then
      self:setContent()
    else
      RequestAuctionNextPage(0, self._value.openByNpc)
    end
  else
    if self._value.currentPage > 0 then
      self._value.currentPage = self._value.currentPage - 1
      self:closeSkill()
    end
    if true == PaGlobalFunc_StableMarket_ChecKTabMy() then
      self:setContent()
    else
      RequestAuctionPrevPage(0, self._value.openByNpc)
    end
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
end
function PaGlobalFunc_StableMarket_SkillEventControlCreate(list_content, key)
  local self = Panel_Window_StableMarket_info
  local id = Int64toInt32(key)
  local myAuctionInfo = self._value.myAuctionInfo
  if nil == myAuctionInfo then
    return
  end
  local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(self._slotMarket[self._value.currentMarketIndex].slotNo)
  if nil == auctionServantInfo then
    return
  end
  local skillWrapper = auctionServantInfo:getSkill(id)
  if nil == skillWrapper then
    return
  end
  local static_SkillSlot_Template = UI.getChildControl(list_content, "Static_SkillSlot_Template")
  local static_Skill_Icon = UI.getChildControl(static_SkillSlot_Template, "Static_Skill_Icon")
  local circularProgress_Train = UI.getChildControl(static_SkillSlot_Template, "CircularProgress_Train")
  local staticText_Percent = UI.getChildControl(static_SkillSlot_Template, "StaticText_Percent")
  local staticText_Name = UI.getChildControl(static_SkillSlot_Template, "StaticText_Name")
  local staticText_Command = UI.getChildControl(static_SkillSlot_Template, "StaticText_Command")
  static_Skill_Icon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
  staticText_Name:SetText(skillWrapper:getName())
  local expTxt = tonumber(string.format("%.0f", auctionServantInfo:getSkillExp(id) / (skillWrapper:get()._maxExp / 100)))
  if expTxt >= 100 then
    expTxt = 100
  end
  circularProgress_Train:SetProgressRate(expTxt)
  staticText_Percent:SetText(expTxt .. "%")
  staticText_Command:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  staticText_Command:SetText(skillWrapper:getDescription())
  if true == self._config.isResizeListContent then
    static_SkillSlot_Template:SetSize(self._config.listDefaultSizeX - 15, static_SkillSlot_Template:GetSizeY())
    list_content:SetSize(self._config.listDefaultSizeX - 15, list_content:GetSizeY())
  else
    static_SkillSlot_Template:SetSize(self._config.listDefaultSizeX, static_SkillSlot_Template:GetSizeY())
    list_content:SetSize(self._config.listDefaultSizeX, list_content:GetSizeY())
  end
end
function PaGlobalFunc_StableMarket_BuyXXX()
  local self = Panel_Window_StableMarket_info
  stable_requestBuyItNowServant(self._slotMarket[self._value.currentMarketIndex].slotNo, MessageBoxCheck.isCheck())
end
function PaGlobalFunc_StableMarket_Buy()
  local self = Panel_Window_StableMarket_info
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_BUY_NOTIFY")
  local messageBoxData = {
    title = titleString,
    content = contentString,
    functionApply = PaGlobalFunc_StableMarket_BuyXXX,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBoxCheck.showMessageBox(messageBoxData, nil, true)
end
function PaGlobalFunc_StableMarket_Cancel()
  local self = Panel_Window_StableMarket_info
  local function stableMarket_CancelDo()
    local selectSlotNo = self._slotMarket[self._value.currentMarketIndex].slotNo
    stable_cancelServantFromSomeWhereElse(selectSlotNo, CppEnums.AuctionType.AuctionGoods_ServantMarket)
  end
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTCANCEL_DO")
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = stableMarket_CancelDo,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_StableMarket_Receive()
  local self = Panel_Window_StableMarket_info
  local selectSlotNo = self._slotMarket[self._value.currentMarketIndex].slotNo
  local toWhereType = CppEnums.ItemWhereType.eInventory
  stable_popServantPrice(selectSlotNo, CppEnums.AuctionType.AuctionGoods_ServantMarket, CppEnums.ItemWhereType.eWarehouse)
end
function PaGlobalFunc_StableMarket_SetFilterText(text)
  local self = Panel_Window_StableMarket_info
  self._ui.staticText_Filter:SetText(text)
end
function PaGlobalFunc_StableMarket_ResponseServantBuyItNowFail()
  if GetUIMode() == Defines.UIMode.eUIMode_Default then
    return
  end
  if false == PaGlobalFunc_StableList_GetShow() then
    return
  end
  RequestActionReloadPage(0, self._value.openByNpc)
  PaGlobalFunc_StableMarket_Update()
end
function PaGlobalFunc_StableMarket_Reload()
  local self = Panel_Window_StableMarket_info
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  RequestActionReloadPage(0, self._value.openByNpc)
end
function PaGlobalFunc_StableMarket_SetFilter()
  if not PaGlobalFunc_StableMarket_ChecKTabMy() then
    _AudioPostEvent_SystemUiForXBOX(50, 0)
    PaGlobalFunc_StableMarket_Filter_Show()
  end
end
function FromClient_StableMarket_Init()
  local self = Panel_Window_StableMarket_info
  self:initialize()
end
function FromClient_StableMarket_Resize()
  local self = Panel_Window_StableMarket_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_StableMarket_Init")
