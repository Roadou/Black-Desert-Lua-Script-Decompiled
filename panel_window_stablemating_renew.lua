local Panel_Window_StableMating_info = {
  _ui = {
    static_TopBg = nil,
    radioButton_MarketList_ConsoleUI = nil,
    radioButton_MyList_ConsoleUI = nil,
    radioButton_Mine_ConsoleUI = nil,
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
    staticText_Death = nil,
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
    staticText_DeathVal = nil,
    staticText_Silver = nil,
    staticText_Select_ConsoleUI = nil,
    staticText_Select_Name = nil,
    staticText_Inven = nil,
    staticText_Inven_Val = nil,
    staticText_Storage = nil,
    staticText_Storage_Val = nil,
    list2_1_Skill = nil,
    list2_1_Content_Skill = nil,
    static_SkillSlot_Template = nil,
    static_Progress_BG = nil,
    static_Skill_Icon = nil,
    circularProgress_Train = nil,
    staticText_Percent = nil,
    staticText_Name = nil,
    staticText_Command = nil
  },
  _value = {
    lastTab = 0,
    currentTab = 0,
    lastMatingIndex = 0,
    currentMatingIndex = 0,
    startMatingSlotNo = 0,
    matingAllCount = 0,
    currentPage = 0
  },
  _pos = {
    firstPosX = 0,
    firstPosY = 0,
    marketSlotSizeY = 120,
    marketSlotSpaceY = 10
  },
  _config = {
    maxShowListCnt = 6,
    isResizeListContent = false,
    listDefaultSizeX = 315,
    tabCount = 3,
    maxSlotCount = 4,
    maxPage = 99
  },
  _enum = {
    eNORMAL = 0,
    eMYLIST = 1,
    eMINE = 2,
    eTAB_COUNT = 3
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
  _tabList = {},
  _slotMating = {},
  _skillId = {}
}
function Panel_Window_StableMating_info:registEventHandler()
  Panel_Window_StableMating:registerPadEvent(__eConsoleUIPadEvent_LT, "PaGlobalFunc_StableMating_TabEventMove(-1)")
  Panel_Window_StableMating:registerPadEvent(__eConsoleUIPadEvent_RT, "PaGlobalFunc_StableMating_TabEventMove(1)")
  Panel_Window_StableMating:registerPadEvent(__eConsoleUIPadEvent_Up_DpadLeft, "PaGlobalFunc_StableMating_PageChange(false)")
  Panel_Window_StableMating:registerPadEvent(__eConsoleUIPadEvent_Up_DpadRight, "PaGlobalFunc_StableMating_PageChange(true)")
  self._ui.radioButton_MarketList_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMating_TabEvent( 0 )")
  self._ui.radioButton_MyList_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMating_TabEvent( 1 )")
  self._ui.radioButton_Mine_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMating_TabEvent( 2 )")
end
function Panel_Window_StableMating_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_StableMating_Resize")
  registerEvent("FromClient_AuctionServantList", "PaGlobalFunc_StableMating_Update")
  registerEvent("FromClient_ServantRegisterToAuction", "PaGlobalFunc_StableMating_TabEventFromRegister")
  registerEvent("FromClient_InventoryUpdate", "PaGlobalFunc_StableMating_Update_Money")
  registerEvent("EventWarehouseUpdate", "PaGlobalFunc_StableMating_Update_Money")
end
function Panel_Window_StableMating_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:createMatingSlot()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_StableMating_info:initValue()
  self._value.lastTab = self._enum.eNORMAL
  self._value.currentTab = self._enum.eNORMAL
  self._value.lastMatingIndex = 0
  self._value.currentMatingIndex = 0
  self._value.startMatingSlotNo = 0
  self._value.matingAllCount = 0
  self._value.currentPage = 0
end
function Panel_Window_StableMating_info:initUpdateValue()
  self._value.lastMatingIndex = 0
  self._value.currentMatingIndex = 0
  self._value.startMatingSlotNo = 0
  self._value.matingAllCount = 0
  self._value.currentPage = 0
end
function Panel_Window_StableMating_info:createMatingSlot()
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
      staticText_Death = nil,
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
      staticText_DeathVal = nil,
      staticText_Silver = nil,
      staticText_Select_ConsoleUI = nil
    }
    function slot:setPos(index)
      local matingInfo = Panel_Window_StableMating_info
      self.radiobutton:SetPosXY(matingInfo._pos.firstPosX, matingInfo._pos.firstPosY + index * (matingInfo._pos.marketSlotSizeY + matingInfo._pos.marketSlotSpaceY))
    end
    function slot:setShow(bShow)
      bShow = bShow or false
      self.radiobutton:SetShow(bShow)
    end
    function slot:setServant(slotNo)
      self.slotNo = slotNo
      local myAuctionInfo = RequestGetAuctionInfo()
      local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(slotNo)
      if auctionServantInfo:getBaseIconPath1() ~= auctionServantInfo:getIconPath1() then
        self.static_Image:ChangeTextureInfoName(auctionServantInfo:getIconPath1())
      else
        self.static_Image:ChangeTextureInfoName(auctionServantInfo:getBaseIconPath1())
      end
      local matingInfo = Panel_Window_StableMating_info
      if auctionServantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
        self.static_Gender:SetShow(true)
        if auctionServantInfo:isMale() then
          self.static_Gender:ChangeTextureInfoName(matingInfo._texture.sexIcon)
          local x1, y1, x2, y2 = setTextureUV_Func(self.static_Gender, matingInfo._texture.male.x1, matingInfo._texture.male.y1, matingInfo._texture.male.x2, matingInfo._texture.male.y2)
          self.static_Gender:getBaseTexture():setUV(x1, y1, x2, y2)
          self.static_Gender:setRenderTexture(self.static_Gender:getBaseTexture())
        else
          self.static_Gender:ChangeTextureInfoName(matingInfo._texture.sexIcon)
          local x1, y1, x2, y2 = setTextureUV_Func(self.static_Gender, matingInfo._texture.female.x1, matingInfo._texture.female.y1, matingInfo._texture.female.x2, matingInfo._texture.female.y2)
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
    slot.staticText_Death = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_Death", slot.radiobutton, "StaticText_Death_" .. index)
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
    slot.staticText_DeathVal = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_DeathVal", slot.radiobutton, "StaticText_DeathVal_" .. index)
    slot.staticText_Line = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "Static_Line2", slot.radiobutton, "Static_Line2_" .. index)
    slot.staticText_Silver = UI.createAndCopyBasePropertyControl(self._ui.radioButton_List_Templete, "StaticText_Silver", slot.radiobutton, "StaticText_Silver_" .. index)
    slot.slotNo = index
    slot:setPos(index)
    slot:setShow(false)
    self._slotMating[index] = slot
  end
end
function Panel_Window_StableMating_info:resize()
end
function Panel_Window_StableMating_info:childControl()
  self._ui.static_TopBg = UI.getChildControl(Panel_Window_StableMating, "Static_TopBg")
  self._ui.radioButton_MarketList_ConsoleUI = UI.getChildControl(self._ui.static_TopBg, "RadioButton_MarketList_ConsoleUI")
  self._ui.radioButton_MyList_ConsoleUI = UI.getChildControl(self._ui.static_TopBg, "RadioButton_MyList_ConsoleUI")
  self._ui.radioButton_Mine_ConsoleUI = UI.getChildControl(self._ui.static_TopBg, "RadioButton_Mine_ConsoleUI")
  self._ui.static_Page = UI.getChildControl(Panel_Window_StableMating, "Static_Page")
  self._ui.static_PagePre_ConsoleUI = UI.getChildControl(self._ui.static_Page, "Static_PagePre_ConsoleUI")
  self._ui.static_PageNext_ConsoleUI = UI.getChildControl(self._ui.static_Page, "Static_PageNext_ConsoleUI")
  self._ui.staticText_Page = UI.getChildControl(self._ui.static_Page, "StaticText_Page")
  self._ui.static_CenterBg = UI.getChildControl(Panel_Window_StableMating, "Static_CenterBg")
  self._ui.radioButton_List_Templete = UI.getChildControl(self._ui.static_CenterBg, "RadioButton_List_Templete")
  self._ui.static_Profile = UI.getChildControl(self._ui.radioButton_List_Templete, "Static_Profile")
  self._ui.static_Image = UI.getChildControl(self._ui.radioButton_List_Templete, "Static_Image")
  self._ui.static_Gender = UI.getChildControl(self._ui.radioButton_List_Templete, "Static_Gender")
  self._ui.staticText_LV = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_LV")
  self._ui.staticText_HP = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_HP")
  self._ui.staticText_SP = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_SP")
  self._ui.staticText_Weight = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Weight")
  self._ui.staticText_Speed = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Speed")
  self._ui.staticText_Acc = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Acc")
  self._ui.staticText_Rotate = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Rotate")
  self._ui.staticText_Break = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Break")
  self._ui.staticText_Death = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Death")
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
  self._ui.staticText_DeathVal = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_DeathVal")
  self._ui.staticText_Line = UI.getChildControl(self._ui.radioButton_List_Templete, "Static_Line2")
  self._ui.staticText_Silver = UI.getChildControl(self._ui.radioButton_List_Templete, "StaticText_Silver")
  self._ui.radioButton_List_Templete:SetShow(false)
  self._pos.firstPosX = self._ui.radioButton_List_Templete:GetPosX()
  self._pos.firstPosY = self._ui.radioButton_List_Templete:GetPosY()
  self._pos.marketSlotSizeY = self._ui.radioButton_List_Templete:GetSizeY()
  self._ui.staticText_Select_ConsoleUI = UI.getChildControl(Panel_Window_StableMating, "StaticText_Select_ConsoleUI")
  self._ui.staticText_Select_Name = UI.getChildControl(Panel_Window_StableMating, "StaticText_Select_Name")
  self._ui.staticText_Inven_Val = UI.getChildControl(Panel_Window_StableMating, "StaticText_Inven_Val")
  self._ui.staticText_Storage = UI.getChildControl(Panel_Window_StableMating, "StaticText_Storage")
  self._ui.staticText_Storage_Val = UI.getChildControl(Panel_Window_StableMating, "StaticText_Storage_Val")
  self._ui.list2_1_Skill = UI.getChildControl(Panel_Window_StableMating, "List2_1_Skill")
  self._ui.list2_1_Skill:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_StableMating_SkillEventControlCreate")
  self._ui.list2_1_Skill:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function Panel_Window_StableMating_info:setTab()
  self._ui.radioButton_MarketList_ConsoleUI:SetCheck(false)
  self._ui.radioButton_MyList_ConsoleUI:SetCheck(false)
  self._ui.radioButton_Mine_ConsoleUI:SetCheck(false)
  self._ui.radioButton_MarketList_ConsoleUI:SetFontColor(Defines.Color.C_FF626262)
  self._ui.radioButton_MyList_ConsoleUI:SetFontColor(Defines.Color.C_FF626262)
  self._ui.radioButton_Mine_ConsoleUI:SetFontColor(Defines.Color.C_FF626262)
  if self._value.currentTab == self._enum.eNORMAL then
    self._ui.radioButton_MarketList_ConsoleUI:SetCheck(true)
    self._ui.radioButton_MarketList_ConsoleUI:SetFontColor(Defines.Color.C_FFEEEEEE)
  end
  if self._value.currentTab == self._enum.eMYLIST then
    self._ui.radioButton_MyList_ConsoleUI:SetCheck(true)
    self._ui.radioButton_MyList_ConsoleUI:SetFontColor(Defines.Color.C_FFEEEEEE)
  end
  if self._value.currentTab == self._enum.eMINE then
    self._ui.radioButton_Mine_ConsoleUI:SetCheck(true)
    self._ui.radioButton_Mine_ConsoleUI:SetFontColor(Defines.Color.C_FFEEEEEE)
  end
end
function Panel_Window_StableMating_info:clearSlot()
  for index = 0, self._config.maxSlotCount - 1 do
    self._slotMating[index]:clearServant()
  end
end
function Panel_Window_StableMating_info:setContent()
  self:clearSlot()
  ToClient_padSnapResetControl()
  if self._value.currentTab == self._enum.eNORMAL then
    self:setContentIsMarket()
  end
  if self._value.currentTab == self._enum.eMYLIST then
    self:setContentIsMyList()
  end
  if self._value.currentTab == self._enum.eMINE then
    self:setContentIsMyList()
  end
end
function Panel_Window_StableMating_info:setContentIsMyList()
  local myAuctionInfo = RequestGetAuctionInfo()
  local servantCount = myAuctionInfo:getServantAuctionListCount()
  local currentPage = self._value.currentPage + 1
  self._ui.staticText_Page:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLE_MARKET_PAGE", "page", currentPage))
  self._value.startMatingSlotNo = self._value.currentPage * self._config.maxSlotCount
  self._value.matingAllCount = servantCount
  for index = 0, self._config.maxSlotCount - 1 do
    local slot = self._slotMating[index]
    slot.slotNo = self._value.startMatingSlotNo + index
    if servantCount > slot.slotNo then
      slot:setShow(true)
      slot:setServant(slot.slotNo)
      slot.radiobutton:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMating_ClickList(" .. index .. ")")
      slot.radiobutton:addInputEvent("Mouse_On", "PaGlobalFunc_StableMating_SelectList(" .. index .. ")")
    end
  end
end
function Panel_Window_StableMating_info:setContentIsMarket()
  local myAuctionInfo = RequestGetAuctionInfo()
  local servantCount = myAuctionInfo:getServantAuctionListCount()
  local currentPage = myAuctionInfo:getCurrentPage() + 1
  self._ui.staticText_Page:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLE_MARKET_PAGE", "page", currentPage))
  self._ui.staticText_Select_ConsoleUI:SetShow(true)
  self._ui.staticText_Select_Name:SetShow(true)
  self._value.startMatingSlotNo = self._value.currentPage * self._config.maxSlotCount
  self._value.matingAllCount = servantCount
  if 0 == self._value.matingAllCount then
    self._ui.staticText_Select_ConsoleUI:SetShow(false)
    self._ui.staticText_Select_Name:SetShow(false)
  end
  for index = 0, self._config.maxSlotCount - 1 do
    local slot = self._slotMating[index]
    slot.slotNo = index
    if servantCount > index then
      slot:setShow(true)
      slot:setServant(slot.slotNo)
      slot.radiobutton:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMating_ClickList(" .. index .. ")")
      slot.radiobutton:addInputEvent("Mouse_On", "PaGlobalFunc_StableMating_SelectList(" .. index .. ")")
    end
  end
end
function Panel_Window_StableMating_info:setContentSkill()
  self._ui.list2_1_Skill:getElementManager():clearKey()
  for k in pairs(self._skillId) do
    self._skillId[k] = nil
  end
  local myAuctionInfo = RequestGetAuctionInfo()
  local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(self._slotMating[self._value.currentMatingIndex].slotNo)
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
function Panel_Window_StableMating_info:open()
  Panel_Window_StableMating:SetShow(true)
end
function Panel_Window_StableMating_info:close()
  Panel_Window_StableMating:SetShow(false)
end
function Panel_Window_StableMating_info:closeSkill()
  self._ui.list2_1_Skill:SetShow(false)
end
function PaGlobalFunc_StableMating_GetShow()
  return Panel_Window_StableMating:GetShow()
end
function PaGlobalFunc_StableMating_Open()
  local self = Panel_Window_StableMating_info
  self:open()
end
function PaGlobalFunc_StableMating_Close()
  local self = Panel_Window_StableMating_info
  self:close()
end
function PaGlobalFunc_StableMating_Show(tab)
  local self = Panel_Window_StableMating_info
  self:initValue()
  warehouse_requestInfoFromNpc()
  self._value.currentTab = self._enum.eNORMAL
  if nil ~= tab then
    self._value.currentTab = tab
  end
  self:closeSkill()
  self:setTab()
  self:open()
  PaGlobalFunc_StableMating_TabEventXXX(self._enum.eNORMAL)
end
function PaGlobalFunc_StableMating_Update()
  if not PaGlobalFunc_StableMating_GetShow() then
    return
  end
  local self = Panel_Window_StableMating_info
  PaGlobalFunc_StableMating_Update_Money()
  self:closeSkill()
  self:setTab()
  self:setContent()
end
function PaGlobalFunc_StableMating_TransferType(tab)
  local self = Panel_Window_StableMating_info
  local transferType = CppEnums.TransferType.TransferType_Normal
  if self._enum.eMINE == tab then
    transferType = CppEnums.TransferType.TransferType_Self
  end
  return transferType
end
function PaGlobalFunc_StableMating_GetCurrentTab()
  local self = Panel_Window_StableMating_info
  return self._value.currentTab
end
function PaGlobalFunc_StableMating_Update_Money()
  if true == _ContentsGroup_InvenUpdateCheck and false == Panel_Window_StableMating:GetShow() then
    return
  end
  local self = Panel_Window_StableMating_info
  self._ui.staticText_Inven_Val:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  self._ui.staticText_Storage_Val:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
end
function PaGlobalFunc_StableMating_TabEventMove(value)
  local self = Panel_Window_StableMating_info
  if nil == value then
    value = 1
  end
  local newTabIndex = self._value.currentTab + value
  newTabIndex = newTabIndex % self._enum.eTAB_COUNT
  PaGlobalFunc_StableMating_TabEvent(newTabIndex)
end
function PaGlobalFunc_StableMating_TabEvent(tab)
  local self = Panel_Window_StableMating_info
  if PaGlobalFunc_StableMating_GetCurrentTab() == tab then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(51, 7)
  self._value.currentTab = tab
  self:closeSkill()
  PaGlobalFunc_StableMating_TabEventXXX(tab)
end
function PaGlobalFunc_StableMating_TabEventFromRegister()
  local self = Panel_Window_StableMating_info
  if not PaGlobalFunc_StableMarket_GetShow() then
    return
  end
  PaGlobalFunc_StableMating_TabEventXXX(PaGlobalFunc_StableMating_GetCurrentTab())
end
function PaGlobalFunc_StableMating_TabEventXXX(tab)
  local self = Panel_Window_StableMating_info
  self:initUpdateValue()
  if self._enum.eMYLIST == PaGlobalFunc_StableMating_GetCurrentTab() then
    requestMyServantMatingList()
  else
    requestServantMatingListPage(PaGlobalFunc_StableMating_TransferType(PaGlobalFunc_StableMating_GetCurrentTab()))
  end
end
function PaGlobalFunc_StableMating_PageChange(isNext)
  local self = Panel_Window_StableMating_info
  if true == isNext then
    if self._config.maxPage <= self._value.currentPage then
      return
    end
    self:closeSkill()
    self._value.currentPage = self._value.currentPage + 1
    if self._enum.eMYLIST == PaGlobalFunc_StableMating_GetCurrentTab() then
      self:setContent(true)
    else
      RequestAuctionNextPage(PaGlobalFunc_StableMating_TransferType(PaGlobalFunc_StableMating_GetCurrentTab()))
    end
  else
    if self._value.currentPage > 0 then
      self._value.currentPage = self._value.currentPage - 1
      self:closeSkill()
    end
    if self._enum.eMYLIST == PaGlobalFunc_StableMating_GetCurrentTab() then
      self:setContent(true)
    else
      RequestAuctionPrevPage(PaGlobalFunc_StableMating_TransferType(PaGlobalFunc_StableMating_GetCurrentTab()))
    end
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
end
function PaGlobalFunc_StableMating_SelectList(index)
  local self = Panel_Window_StableMating_info
  self._value.lastMatingIndex = self._value.currentMatingIndex
  self._value.currentMatingIndex = index
  self._slotMating[self._value.lastMatingIndex]:setSelect(false)
  self._slotMating[self._value.currentMatingIndex]:setSelect(true)
  if self._enum.eMYLIST == PaGlobalFunc_StableMating_GetCurrentTab() then
    local isAuctionEnd = false
    local myAuctionInfo = RequestGetAuctionInfo()
    local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(self._slotMating[self._value.currentMatingIndex].slotNo)
    if nil == auctionServantInfo then
      return
    end
    local isAuctionEnd = auctionServantInfo:isAuctionEnd()
    local servantInfo = stable_getServantByServantNo(auctionServantInfo:getServantNo())
    if nil ~= servantInfo then
      if CppEnums.ServantStateType.Type_RegisterMating == servantInfo:getStateType() then
        if isAuctionEnd then
          self._ui.staticText_Select_Name:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMATING_BTN_END"))
        else
          self._ui.staticText_Select_Name:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMATING_BTN_CANCEL"))
        end
      elseif CppEnums.ServantStateType.Type_Mating == servantInfo:getStateType() then
        if servantInfo:isMatingComplete() then
          self._ui.staticText_Select_Name:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMATING_BTN_RECEIVE"))
        else
          self._ui.staticText_Select_Name:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMATING_BTN_MATING"))
        end
      end
    end
  else
    self._ui.staticText_Select_Name:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMATING_BTN_START"))
  end
  self._ui.staticText_Select_Name:SetSize(self._ui.staticText_Select_Name:GetTextSizeX(), self._ui.staticText_Select_Name:GetSizeY())
  self._ui.staticText_Select_ConsoleUI:SetPosX(self._ui.staticText_Select_Name:GetPosX() - self._ui.staticText_Select_ConsoleUI:GetSizeX() - 5)
  self:setContentSkill()
end
function PaGlobalFunc_StableMating_ClickList(index)
  local self = Panel_Window_StableMating_info
  if self._enum.eMYLIST == PaGlobalFunc_StableMating_GetCurrentTab() then
    local isAuctionEnd = false
    local myAuctionInfo = RequestGetAuctionInfo()
    local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(self._slotMating[self._value.currentMatingIndex].slotNo)
    if nil == auctionServantInfo then
      return
    end
    local isAuctionEnd = auctionServantInfo:isAuctionEnd()
    local servantInfo = stable_getServantByServantNo(auctionServantInfo:getServantNo())
    if nil ~= servantInfo then
      if CppEnums.ServantStateType.Type_RegisterMating == servantInfo:getStateType() then
        if isAuctionEnd then
          PaGlobalFunc_StableMating_Cancel()
        else
          PaGlobalFunc_StableMating_Cancel()
        end
      elseif CppEnums.ServantStateType.Type_Mating == servantInfo:getStateType() and servantInfo:isMatingComplete() then
        PaGlobalFunc_StableMating_Receive()
        else
          PaGlobalFunc_StableMating_Mating()
        end
      end
    else
    end
end
function PaGlobalFunc_StableMating_Cancel()
  local self = Panel_Window_StableMating_info
  local function stableMating_CancelDo()
    local selectSlotNo = self._slotMating[self._value.currentMatingIndex].slotNo
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
function PaGlobalFunc_StableMating_Receive()
  local self = Panel_Window_StableMating_info
  local selectSlotNo = self._slotMating[self._value.currentMatingIndex].slotNo
  local toWhereType = CppEnums.ItemWhereType.eInventory
  stable_popServantPrice(selectSlotNo, CppEnums.AuctionType.AuctionGoods_ServantMating, CppEnums.ItemWhereType.eWarehouse)
end
function PaGlobalFunc_StableMating_Mating()
  local self = Panel_Window_StableMating_info
  local selectSlotNo = self._slotMating[self._value.currentMatingIndex].slotNo
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_MATING_NOTIFY")
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = PaGlobalFunc_StableMating_MatingXXX,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_StableMating_MatingXXX()
  local self = Panel_Window_StableMating_info
  local transferType = PaGlobalFunc_StableMating_TransferType(PaGlobalFunc_StableMating_GetCurrentTab())
  local matingSlotNo = self._slotMating[self._value.currentMatingIndex].slotNo
  local myAuctionInfo = RequestGetAuctionInfo()
  if nil == myAuctionInfo then
    return
  end
  local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(matingSlotNo)
  if nil == auctionServantInfo then
    return
  end
  local price32 = Int64toInt32(auctionServantInfo:getAuctoinPrice_s64())
  PaGlobalFunc_StableExchange_ShowByMating(matingSlotNo, transferType, price32)
end
function PaGlobalFunc_StableMating_SkillEventControlCreate(list_content, key)
  local self = Panel_Window_StableMating_info
  local id = Int64toInt32(key)
  local myAuctionInfo = RequestGetAuctionInfo()
  local static_SkillSlot_Template = UI.getChildControl(list_content, "Static_SkillSlot_Template")
  local static_Skill_Icon = UI.getChildControl(static_SkillSlot_Template, "Static_Skill_Icon")
  local circularProgress_Train = UI.getChildControl(static_SkillSlot_Template, "CircularProgress_Train")
  local staticText_Percent = UI.getChildControl(static_SkillSlot_Template, "StaticText_Percent")
  local staticText_Name = UI.getChildControl(static_SkillSlot_Template, "StaticText_Name")
  local staticText_Command = UI.getChildControl(static_SkillSlot_Template, "StaticText_Command")
  circularProgress_Train:SetProgressRate(0)
  local auctionServantInfo = myAuctionInfo:getServantAuctionListAt(self._slotMating[self._value.currentMatingIndex].slotNo)
  if nil == auctionServantInfo then
    return
  end
  local skillWrapper = auctionServantInfo:getSkill(id)
  if nil == skillWrapper then
    return
  end
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
function FromClient_StableMating_Init()
  local self = Panel_Window_StableMating_info
  self:initialize()
end
function FromClient_StableMating_Resize()
  local self = Panel_Window_StableMating_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_StableMating_Init")
