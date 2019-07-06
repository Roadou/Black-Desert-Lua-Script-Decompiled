local Panel_Window_WharfList_info = {
  _ui = {
    static_Wharf_BG = nil,
    staticText_Icon = nil,
    staticText_Region = nil,
    static_LT_ConsoleUI = nil,
    static_RT_ConsoleUI = nil,
    button_Unseal_Vehicle = nil,
    staticText_Unseal_Name = nil,
    staticText_Unseal_Location = nil,
    staticText_Unseal_NoUnseal = nil,
    button_WharfEmblem_Regist = nil,
    staticText_WharfRegist_Icon = nil,
    static_Wharf_List = nil,
    radioButton_Slot = nil,
    static_Image_Template = nil,
    staticText_Name_Template = nil,
    staticText_Location_Template = nil,
    staticText_State_Template = nil,
    static_StateBg = nil,
    static_StateIcon = nil,
    radioButton_Slot_List = {},
    wharf_List_HorizontalScroll = nil,
    static_CountBg = nil,
    staticText_UnsealCount = nil,
    staticText_SealCount = nil,
    staticText_MaxCount = nil,
    static_KeyGuideBg = nil,
    staticText_Confirm_ConsoleUI = nil,
    staticText_Exit_ConsoleUI = nil,
    staticText_Move_ConsoleUI = nil
  },
  _value = {
    lastButtonIndex = 0,
    currentButtonIndex = 0,
    lastButtonSlotNo = 0,
    currentButtonSlotNo = 0,
    startButtonIndex = 0,
    stableSlotCount = 0,
    isUnseal = false,
    buttonPosCount = 0
  },
  _enum = {eTYPE_SEALED = 0, eTYPE_UNSEALED = 1},
  _buttonPos = {
    [0] = 0,
    [1] = 0
  },
  _pos = {
    firstPosX = 0,
    buttonSizeX = 0,
    buttonSpaceSizeX = 10,
    stableInfoButtonSize = 0,
    stableInfoButtonSpace = 20,
    keyGuideButtonSize = 0,
    keyGuideButtonSpace = 10
  },
  _config = {
    fisrtButtonPosX = 460,
    maxButtonPosCount = 1,
    slotRows = 1,
    slotCount = 7,
    maxSlotCount = 8,
    nowSlotCount = 7
  },
  _texture = {
    stateIcon = "Renewal/UI_Icon/Console_Icon_03.dds",
    isSeized = {
      x1 = 282,
      y1 = 103,
      x2 = 332,
      y2 = 153
    },
    recoveryWharf = {
      x1 = 180,
      y1 = 103,
      x2 = 230,
      y2 = 153
    }
  },
  _slots = {}
}
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_SW = CppEnums.ServantWhereType
function Panel_Window_WharfList_info:registerEventHandler()
end
function Panel_Window_WharfList_info:registerMessageHandler()
  Panel_Window_WharfList:RegisterShowEventFunc(true, "PaGlobalFunc_WharfList_ShowAni()")
  Panel_Window_WharfList:RegisterShowEventFunc(false, "PaGlobalFunc_WharfList_HideAni()")
  registerEvent("onScreenResize", "FromClient_WharfList_Resize")
  registerEvent("FromClient_ServantUpdate", "PaGlobalFunc_WharfList_Update")
end
function Panel_Window_WharfList_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:createSlot()
  self:registerMessageHandler()
  self:registerEventHandler()
end
function Panel_Window_WharfList_info:initValue()
  self._value.lastButtonIndex = -1
  self._value.currentButtonIndex = -1
  self._value.lastButtonSlotNo = -1
  self._value.currentButtonSlotNo = -1
  self._value.startButtonIndex = 0
  self._value.stableSlotCount = 0
  self._value.isUnseal = false
  self._value.buttonPosCount = 0
end
function Panel_Window_WharfList_info:resize()
end
function Panel_Window_WharfList_info:childControl()
  self._ui.static_Wharf_BG = UI.getChildControl(Panel_Window_WharfList, "Static_Wharf_BG")
  self._ui.staticText_Icon = UI.getChildControl(self._ui.static_Wharf_BG, "StaticText_Icon")
  self._ui.staticText_Region = UI.getChildControl(self._ui.static_Wharf_BG, "StaticText_Region")
  self._ui.staticText_Region:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.button_Unseal_Vehicle = UI.getChildControl(Panel_Window_WharfList, "Button_Unseal_Vehicle")
  self._ui.static_Unseal_Image = UI.getChildControl(self._ui.button_Unseal_Vehicle, "Static_Unseal_Image")
  self._ui.staticText_Unseal_Name = UI.getChildControl(self._ui.button_Unseal_Vehicle, "StaticText_Unseal_Name")
  self._ui.staticText_Unseal_Location = UI.getChildControl(self._ui.button_Unseal_Vehicle, "StaticText_Unseal_Location")
  self._ui.staticText_Unseal_NoUnseal = UI.getChildControl(self._ui.button_Unseal_Vehicle, "StaticText_Unseal_NoUnseal")
  self._ui.staticText_Unseal_NoUnseal:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.button_WharfEmblem_Regist = UI.getChildControl(Panel_Window_WharfList, "Button_WharfEmblem_Regist")
  self._ui.staticText_WharfRegist = UI.getChildControl(self._ui.button_WharfEmblem_Regist, "StaticText_WharfRegist")
  self._ui.staticText_WharfRegist:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.staticText_WharfRegist:SetText(self._ui.staticText_WharfRegist:GetText())
  self._buttonPos[0] = self._ui.button_WharfEmblem_Regist:GetPosX()
  self._ui.static_Wharf_List = UI.getChildControl(Panel_Window_WharfList, "Static_Wharf_List")
  self._buttonPos[1] = self._ui.static_Wharf_List:GetPosX()
  self._ui.radioButton_Slot = UI.getChildControl(self._ui.static_Wharf_List, "RadioButton_Slot")
  self._ui.radioButton_Slot:SetShow(false)
  self._ui.static_Image_Template = UI.getChildControl(self._ui.radioButton_Slot, "Static_Image_Template")
  self._ui.staticText_Name_Template = UI.getChildControl(self._ui.radioButton_Slot, "StaticText_Name_Template")
  self._ui.staticText_Location_Template = UI.getChildControl(self._ui.radioButton_Slot, "StaticText_Location_Template")
  self._ui.staticText_State_Template = UI.getChildControl(self._ui.radioButton_Slot, "StaticText_State_Template")
  self._ui.static_StateBg = UI.getChildControl(self._ui.radioButton_Slot, "Static_StateBg")
  self._ui.static_StateIcon = UI.getChildControl(self._ui.radioButton_Slot, "Static_StateIcon")
  self._ui.wharf_List_HorizontalScroll = UI.getChildControl(self._ui.static_Wharf_List, "Wharf_List_HorizontalScroll")
  self._ui.wharf_List_HorizontalScroll:SetEnable(false)
  self._pos.firstPosX = self._ui.radioButton_Slot:GetPosX()
  self._pos.buttonSizeX = self._ui.radioButton_Slot:GetSizeX()
  self._ui.static_CountBg = UI.getChildControl(Panel_Window_WharfList, "Static_CountBg")
  self._ui.staticText_UnsealCount = UI.getChildControl(self._ui.static_CountBg, "StaticText_UnsealCount")
  self._ui.staticText_SealCount = UI.getChildControl(self._ui.static_CountBg, "StaticText_SealCount")
  self._ui.staticText_MaxCount = UI.getChildControl(self._ui.static_CountBg, "StaticText_MaxCount")
  self._pos.stableInfoButtonSize = self._ui.staticText_UnsealCount:GetSizeX()
  self._ui.static_KeyGuideBg = UI.getChildControl(Panel_Window_WharfList, "Static_KeyGuideBg")
  self._ui.staticText_Confirm_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuideBg, "StaticText_Confirm_ConsoleUI")
  self._ui.staticText_Exit_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuideBg, "StaticText_Exit_ConsoleUI")
  self._ui.staticText_Move_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuideBg, "StaticText_Move_ConsoleUI")
  self._pos.keyGuideButtonSize = self._ui.staticText_Confirm_ConsoleUI:GetSizeX()
end
function Panel_Window_WharfList_info:createSlot()
  for index = 0, self._config.maxSlotCount - 1 do
    local slot = {
      selected = false,
      slotNo = 0,
      slotEnable = false,
      radioButton = nil,
      static_Image = nil,
      staticText_Name = nil,
      staticText_Location = nil,
      staticText_State = nil,
      static_StateBg = nil,
      static_StateIcon = nil
    }
    function slot:setPos(index)
      local stableList = Panel_Window_WharfList_info
      self.radioButton:SetPosX(stableList._pos.firstPosX + stableList._pos.buttonSizeX * index + (stableList._pos.buttonSpaceSizeX - 1) * index)
    end
    function slot:setServant(index)
      local servantInfo = stable_getServant(index)
      if nil == servantInfo then
        return
      end
      local servantRegionName = servantInfo:getRegionName()
      local regionKey = servantInfo:getRegionKeyRaw()
      local regionInfoWrapper = getRegionInfoWrapper(regionKey)
      local exploerKey = regionInfoWrapper:getExplorationKey()
      local getState = servantInfo:getStateType()
      local vehicleType = servantInfo:getVehicleType()
      self:setShowInner(false)
      self.radioButton:SetEnable(true)
      self.staticText_Name:SetShow(true)
      self.staticText_Name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
      self.staticText_Name:SetText(servantInfo:getName())
      self.staticText_Location:SetShow(true)
      self.staticText_Location:SetText(servantInfo:getRegionName())
      self.static_Image:SetShow(true)
      self.static_Image:ChangeTextureInfoName(servantInfo:getIconPath1())
      local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
      local regionName = regionInfo:getAreaName()
      if regionName == servantRegionName then
        self.radioButton:SetMonoTone(false)
        self.slotEnable = true
      elseif not isSiegeStable() then
        self.radioButton:SetMonoTone(true)
        self.slotEnable = false
      end
      local wharfInfo = Panel_Window_WharfList_info
      local showState = false
      local x1, y1, x2, y2
      if nil ~= getState then
        self.staticText_State:SetShow(true)
        self.staticText_State:SetText("")
        self.static_StateBg:SetShow(false)
        self.static_StateIcon:SetShow(false)
      end
      if servantInfo:isSeized() then
        self.staticText_State:SetShow(true)
        self.staticText_State:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_LIST_ATTACHMENT"))
        showState = true
        x1, y1, x2, y2 = setTextureUV_Func(self.static_StateIcon, wharfInfo._texture.isSeized.x1, wharfInfo._texture.isSeized.y1, wharfInfo._texture.isSeized.x2, wharfInfo._texture.isSeized.y2)
      elseif CppEnums.ServantStateType.Type_Coma == getState then
        self.staticText_State:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_REPAIR"))
        showState = true
        x1, y1, x2, y2 = setTextureUV_Func(self.static_StateIcon, wharfInfo._texture.recoveryWharf.x1, wharfInfo._texture.recoveryWharf.y1, wharfInfo._texture.recoveryWharf.x2, wharfInfo._texture.recoveryWharf.y2)
      elseif servantInfo:isChangingRegion() then
      end
      if true == showState then
        self.staticText_State:SetShow(false)
        self.static_StateBg:SetShow(true)
        self.static_StateIcon:SetShow(true)
        self.static_StateIcon:getBaseTexture():setUV(x1, y1, x2, y2)
        self.static_StateIcon:setRenderTexture(self.static_StateIcon:getBaseTexture())
      end
    end
    function slot:setShow(bShow)
      bShow = bShow or false
      self.radioButton:SetShow(bShow)
      self.static_Image:SetShow(bShow)
      self.staticText_Name:SetShow(bShow)
      self.staticText_Location:SetShow(bShow)
      self.staticText_State:SetShow(bShow)
    end
    function slot:setShowInner(bShow)
      bShow = bShow or false
      self.static_Image:SetShow(bShow)
      self.staticText_Name:SetShow(bShow)
      self.staticText_Location:SetShow(bShow)
      self.staticText_State:SetShow(bShow)
    end
    function slot:setSelect(bSelect)
      self.selected = bSelect
      self.radioButton:SetCheck(bSelect)
    end
    function slot:clearServant()
      self:setSelect(false)
      self:setShow(false)
      self.slotEnable = false
    end
    slot.radioButton = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui.static_Wharf_List, "radioButton_Slot_" .. index)
    CopyBaseProperty(self._ui.radioButton_Slot, slot.radioButton)
    slot.static_Image = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.radioButton, "Static_Image_Template_" .. index)
    CopyBaseProperty(self._ui.static_Image_Template, slot.static_Image)
    slot.staticText_Name = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.radioButton, "StaticText_Name_Template_" .. index)
    CopyBaseProperty(self._ui.staticText_Name_Template, slot.staticText_Name)
    slot.staticText_Location = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.radioButton, "StaticText_Location_Template_" .. index)
    CopyBaseProperty(self._ui.staticText_Location_Template, slot.staticText_Location)
    slot.staticText_State = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.radioButton, "StaticText_State_Template_" .. index)
    CopyBaseProperty(self._ui.staticText_State_Template, slot.staticText_State)
    slot.static_StateBg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.radioButton, "Static_StateBg_" .. index)
    CopyBaseProperty(self._ui.static_StateBg, slot.static_StateBg)
    slot.static_StateIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.radioButton, "Static_StateIcon_" .. index)
    CopyBaseProperty(self._ui.static_StateIcon, slot.static_StateIcon)
    slot.slotNo = index
    slot:setPos(index)
    self._slots[index] = slot
    slot.radioButton:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_WharfList_ScrollEvent( true )")
    slot.radioButton:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_WharfList_ScrollEvent( false )")
  end
end
function Panel_Window_WharfList_info:setInfoCount()
  if isSiegeStable() then
    self._ui.staticText_SealCount:SetShow(false)
    self._ui.staticText_UnsealCount:SetShow(false)
    self._ui.staticText_MaxCount:SetShow(false)
  else
    local sealedCount = stable_currentSlotCount()
    local unsealedCount = stable_currentRegionSlotCountAll() - sealedCount + Int64toInt32(stable_currentRegionSlotCountOfOtherCharacter())
    self._ui.staticText_SealCount:SetShow(true)
    self._ui.staticText_UnsealCount:SetShow(true)
    self._ui.staticText_MaxCount:SetShow(true)
    self._ui.staticText_UnsealCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WHARFLIST_UNSEALCOUNT_TITLE") .. " : " .. unsealedCount)
    self._ui.staticText_SealCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WHARFLIST_SEALCOUNT_TITLE") .. " : " .. sealedCount)
    self._ui.staticText_MaxCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WHARFLIST_MAXCOUNT_TITLE") .. " : " .. stable_maxSlotCount())
    self:setInfoCountPos()
  end
end
function Panel_Window_WharfList_info:setInfoCountPos()
  local space = self._pos.stableInfoButtonSize + self._pos.stableInfoButtonSpace
  local textLength1 = self._ui.staticText_UnsealCount:GetTextSizeX()
  local textLength2 = self._ui.staticText_SealCount:GetTextSizeX()
  self._ui.staticText_SealCount:SetPosX(space + textLength1)
  self._ui.staticText_MaxCount:SetPosX(space * 2 + textLength1 + textLength2)
end
function Panel_Window_WharfList_info:setUnsealButton()
  self._ui.button_Unseal_Vehicle:SetShow(true)
  self._ui.static_Unseal_Image:SetShow(false)
  self._ui.staticText_Unseal_Name:SetShow(false)
  self._ui.staticText_Unseal_Location:SetShow(false)
  self._ui.staticText_Unseal_NoUnseal:SetShow(true)
  self._ui.staticText_Unseal_NoUnseal:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLELIST_NOT_UNSEAL_SERVANT"))
  self._ui.button_Unseal_Vehicle:addInputEvent("Mouse_On", "PaGlobalFunc_WharfList_ShowButtonA(false)")
  local temporaryWrapper = getTemporaryInformationWrapper()
  local servantInfo = temporaryWrapper:getUnsealVehicle(stable_getServantType())
  if nil ~= servantInfo then
    self._value.isUnseal = true
    self._ui.button_Unseal_Vehicle:addInputEvent("Mouse_On", "PaGlobalFunc_WharfList_ShowButtonA(true)")
    self._ui.button_Unseal_Vehicle:addInputEvent("Mouse_LUp", "PaGlobalFunc_WharfList_ClickUnsealed()")
    local servantRegionName = servantInfo:getRegionName()
    local vehicleType = servantInfo:getVehicleType()
    self._ui.staticText_Unseal_NoUnseal:SetShow(false)
    self._ui.staticText_Unseal_Name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    self._ui.staticText_Unseal_Name:SetShow(true)
    self._ui.staticText_Unseal_Name:SetText(servantInfo:getName())
    self._ui.static_Unseal_Image:SetShow(true)
    self._ui.static_Unseal_Image:ChangeTextureInfoName(servantInfo:getIconPath1())
  end
end
function Panel_Window_WharfList_info:setRegistButton()
  if stable_doHaveRegisterItem() then
    self._ui.button_WharfEmblem_Regist:SetPosX(self._buttonPos[self._value.buttonPosCount])
    self._value.buttonPosCount = self._value.buttonPosCount + 1
    self._ui.button_WharfEmblem_Regist:SetShow(true)
    self._ui.button_WharfEmblem_Regist:addInputEvent("Mouse_LUp", "PaGlobalFunc_WharfList_ClickRegist()")
    self._ui.button_WharfEmblem_Regist:addInputEvent("Mouse_On", "PaGlobalFunc_WharfList_ShowButtonA(true)")
  else
    self._ui.button_WharfEmblem_Regist:SetShow(false)
    self._ui.button_WharfEmblem_Regist:addInputEvent("Mouse_LUp", "")
    self._ui.button_WharfEmblem_Regist:addInputEvent("Mouse_On", "")
  end
end
function Panel_Window_WharfList_info:setWharfListSizeAndPos()
  local servantCount = stable_count()
  self._ui.static_Wharf_List:SetPosX(self._buttonPos[self._value.buttonPosCount])
  local plusButtonCount = self._config.maxButtonPosCount - self._value.buttonPosCount
  self._config.nowSlotCount = self._config.slotCount + plusButtonCount
  local sizeX = self._config.nowSlotCount * self._pos.buttonSizeX + (self._config.nowSlotCount - 1) * self._pos.buttonSpaceSizeX
  self._ui.static_Wharf_List:SetSize(sizeX, self._ui.static_Wharf_List:GetSizeY())
  self._ui.wharf_List_HorizontalScroll:SetSize(sizeX - 10, self._ui.wharf_List_HorizontalScroll:GetSizeY())
  self._ui.wharf_List_HorizontalScroll:SetHorizonCenter()
  self._value.stableSlotCount = servantCount
  UIScroll_Horizontal_SetButtonSize(self._ui.wharf_List_HorizontalScroll, self._config.nowSlotCount, self._value.stableSlotCount)
end
function Panel_Window_WharfList_info:clearCheck()
  for ii = 0, self._config.maxSlotCount - 1 do
    local slot = self._slots[ii]
    slot:setSelect(false)
  end
end
function Panel_Window_WharfList_info:setWharfListButton()
  local servantCount = stable_count()
  if 0 == servantCount then
    self._ui.static_Wharf_List:SetShow(false)
    return
  else
    self._ui.static_Wharf_List:SetShow(true)
    PaGlobalFunc_WharfList_ServantCountInit(servantCount)
  end
  for ii = 0, self._config.maxSlotCount - 1 do
    local slot = self._slots[ii]
    slot:clearServant()
  end
  PaGlobalFunc_WharfList_SortDataupdate()
  local slotNo = 0
  local linkedHorseCount = 0
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local currentRegionKey = regionInfo:getRegionKey()
  local regionName = regionInfo:getAreaName()
  for index = 0, self._config.nowSlotCount - 1 do
    local slot = self._slots[index]
    slot.slotNo = self._value.startButtonIndex + index
    if index == 0 then
      slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "PaGlobalFunc_WharfList_ScrollEvent( true )")
    elseif index == self._config.nowSlotCount - 1 then
      slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "PaGlobalFunc_WharfList_ScrollEvent( false )")
    end
    if slot.slotNo < self._value.stableSlotCount then
      slot.slotNo = PaGlobalFunc_WharfList_SortByWayPointKey(slot.slotNo)
      if self._value.currentButtonSlotNo == slot.slotNo then
        slot:setSelect(true)
      end
      slot:setShow(true)
      slot:setServant(slot.slotNo)
      slot.radioButton:addInputEvent("Mouse_On", "PaGlobalFunc_WharfList_ShowButtonA(" .. tostring(slot.slotEnable) .. ")")
      slot.radioButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_WharfList_ClickList(" .. slot.slotNo .. "," .. index .. ")")
    end
  end
end
function Panel_Window_WharfList_info:setRegion()
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local regionName = regionInfo:getAreaName()
  self._ui.staticText_Icon:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_8"))
  self._ui.staticText_Region:SetText(regionName)
end
function Panel_Window_WharfList_info:setKeyGuidePos()
  local keyGuides = {
    self._ui.staticText_Move_ConsoleUI,
    self._ui.staticText_Confirm_ConsoleUI,
    self._ui.staticText_Exit_ConsoleUI
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.static_KeyGuideBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Panel_Window_WharfList_info:readyToShow()
  self:setKeyGuidePos()
  self:setRegion()
  self:setInfoCount()
  self:setUnsealButton()
  self:setRegistButton()
  self._ui.wharf_List_HorizontalScroll:SetControlPos(0)
  self:setWharfListSizeAndPos()
  self:setWharfListButton()
end
function Panel_Window_WharfList_info:open()
  _AudioPostEvent_SystemUiForXBOX(1, 30)
  Panel_Window_WharfList:SetShow(true)
end
function Panel_Window_WharfList_info:close()
  _AudioPostEvent_SystemUiForXBOX(1, 30)
  Panel_Window_WharfList:SetShow(false)
end
function PaGlobalFunc_WharfList_GetShow()
  return Panel_Window_WharfList:GetShow()
end
function PaGlobalFunc_WharfList_Open()
  local self = Panel_Window_WharfList_info
  self:open()
end
function PaGlobalFunc_WharfList_Show()
  local self = Panel_Window_WharfList_info
  self:initValue()
  self:readyToShow()
  self:open()
end
function PaGlobalFunc_WharfList_Close()
  local self = Panel_Window_WharfList_info
  self:close()
end
function PaGlobalFunc_WharfList_Update()
  local self = Panel_Window_WharfList_info
  if false == PaGlobalFunc_WharfList_GetShow() then
    return
  end
  self:initValue()
  self:readyToShow()
end
function PaGlobalFunc_WharfList_ShowAni()
end
function PaGlobalFunc_WharfList_HideAni()
end
function PaGlobalFunc_WharfList_ScrollEvent(isUpScroll)
  local self = Panel_Window_WharfList_info
  local beforeSlotIndex = self._value.startButtonIndex
  self._value.startButtonIndex = UIScroll_Horizontal_ScrollEvent(self._ui.wharf_List_HorizontalScroll, isUpScroll, self._config.slotRows, self._value.stableSlotCount, self._value.startButtonIndex, self._config.nowSlotCount)
  if (ToClient_isConsole() or ToClient_IsDevelopment()) and 0 ~= self._value.startButtonIndex then
    ToClient_padSnapIgnoreGroupMove()
  end
  if beforeSlotIndex ~= self._value.startButtonIndex then
    self:setWharfListButton()
  end
end
local sortByExploreKey = {}
function PaGlobalFunc_WharfList_SelectSlotNo()
  local self = Panel_Window_WharfList_info
  if nil == self._value.currentButtonIndex then
    return nil
  end
  return (PaGlobalFunc_WharfList_SortByWayPointKey(self._value.startButtonIndex + self._value.currentButtonIndex))
end
function PaGlobalFunc_WharfList_SortByWayPointKey(index)
  local self = Panel_Window_WharfList_info
  if nil == index then
    return nil
  else
    return sortByExploreKey[index + 1]._index
  end
end
function PaGlobalFunc_WharfList_ServantCountInit(nums)
  sortByExploreKey = {}
  for i = 0, nums do
    sortByExploreKey[i] = {
      _index = nil,
      _servantNo = nil,
      _exploreKey = nil
    }
  end
end
function PaGlobalFunc_WharfList_SortDataupdate()
  local maxStableServantCount = stable_count()
  PaGlobalFunc_WharfList_ServantCountInit(maxStableServantCount)
  for ii = 1, maxStableServantCount do
    local servantInfo = stable_getServant(ii - 1)
    if nil ~= servantInfo then
      local regionKey = servantInfo:getRegionKeyRaw()
      local regionInfoWrapper = getRegionInfoWrapper(regionKey)
      sortByExploreKey[ii]._index = ii - 1
      sortByExploreKey[ii]._servantNo = servantInfo:getServantNo()
      sortByExploreKey[ii]._exploreKey = regionInfoWrapper:getExplorationKey()
    end
  end
  local sortExplaoreKey = function(a, b)
    return a._exploreKey < b._exploreKey
  end
  table.sort(sortByExploreKey, sortExplaoreKey)
  local myRegionKey = getSelfPlayer():getRegionKey():get()
  local myRegionInfoWrapper = getRegionInfoWrapper(myRegionKey)
  local myWayPointKey = myRegionInfoWrapper:getExplorationKey()
  local matchCount = 0
  local temp = {}
  for i = 1, maxStableServantCount do
    if myWayPointKey == sortByExploreKey[i]._exploreKey then
      temp[matchCount] = sortByExploreKey[i]
      matchCount = matchCount + 1
    end
  end
  for i = 1, maxStableServantCount do
    if myWayPointKey ~= sortByExploreKey[i]._exploreKey then
      temp[matchCount] = sortByExploreKey[i]
      matchCount = matchCount + 1
    end
  end
  for i = 1, maxStableServantCount do
    sortByExploreKey[i] = temp[i - 1]
  end
  local affiliatedTerritory = function(exploerKey)
    local territoryKey = -1
    if exploerKey > 0 and exploerKey <= 300 then
      territoryKey = 0
    elseif exploerKey > 300 and exploerKey <= 600 then
      territoryKey = 1
    elseif exploerKey > 600 and exploerKey <= 1100 then
      territoryKey = 2
    elseif exploerKey > 1100 and exploerKey <= 1300 then
      territoryKey = 3
    elseif exploerKey > 1300 then
      territoryKey = 4
    end
    return territoryKey
  end
  local sIndex = 0
  local function sortByTerritory(territoryKey)
    for servantIndex = 1, maxStableServantCount do
      if affiliatedTerritory(sortByExploreKey[servantIndex]._exploreKey) == territoryKey then
        temp[sIndex] = sortByExploreKey[servantIndex]
        sIndex = sIndex + 1
      end
    end
  end
  local myTerritoriKey = affiliatedTerritory(myWayPointKey)
  if 0 == myTerritoriKey then
    sortByTerritory(0)
    sortByTerritory(1)
    sortByTerritory(2)
    sortByTerritory(3)
  elseif 1 == myTerritoriKey then
    sortByTerritory(1)
    sortByTerritory(0)
    sortByTerritory(2)
    sortByTerritory(3)
  elseif 2 == myTerritoriKey then
    sortByTerritory(2)
    sortByTerritory(1)
    sortByTerritory(0)
    sortByTerritory(3)
  elseif 3 == myTerritoriKey then
    sortByTerritory(3)
    sortByTerritory(1)
    sortByTerritory(0)
    sortByTerritory(2)
  end
  for i = 1, maxStableServantCount do
    sortByExploreKey[i] = temp[i - 1]
  end
end
function PaGlobalFunc_WharfList_ClickUnsealed()
  local self = Panel_Window_WharfList_info
  local temporaryWrapper = getTemporaryInformationWrapper()
  local servantInfo = temporaryWrapper:getUnsealVehicle(stable_getServantType())
  if nil == servantInfo then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  PaGlobalFunc_WharfInfo_Show(self._enum.eTYPE_UNSEALED)
end
function PaGlobalFunc_WharfList_UnClickList()
  local self = Panel_Window_WharfList_info
  self:clearCheck()
end
function PaGlobalFunc_WharfList_ShowButtonA(enable)
  local self = Panel_Window_WharfList_info
  if nil == enable then
    enable = false
  end
  self._ui.staticText_Confirm_ConsoleUI:SetShow(enable)
  self:setKeyGuidePos()
end
function PaGlobalFunc_WharfList_ClickList(slotNo, index)
  local self = Panel_Window_WharfList_info
  local slot = self._slots[index]
  if nil == slot then
    return
  end
  if false == slot.slotEnable then
    PaGlobalFunc_WharfInfo_Menu_Close()
    PaGlobalFunc_WharfInfo_Close()
    return
  end
  slot:setSelect(true)
  self._value.lastButtonSlotNo = self._value.currentButtonSlotNo
  self._value.currentButtonSlotNo = slotNo
  self._value.lastButtonIndex = self._value.currentButtonIndex
  self._value.currentButtonIndex = index
  local servantInfo = stable_getServant(slotNo)
  PaGlobalFunc_WharfInfo_Show(self._enum.eTYPE_SEALED)
end
function PaGlobalFunc_WharfList_ClickRegist()
  local self = Panel_Window_WharfList_info
  if 0 < PaGlobalFunc_WharfRegister_CheckIsWharf() then
    _AudioPostEvent_SystemUiForXBOX(50, 0)
    PaGlobalFunc_WharfRegister_OpenByWharf()
    self:close()
  end
end
function FromClient_WharfList_Init()
  local self = Panel_Window_WharfList_info
  self:initialize()
end
function FromClient_WharfList_Resize()
  local self = Panel_Window_WharfList_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_WharfList_Init")
function FromClient_WharfList_applyTransform(servantNo)
  if false == PaGlobalFunc_WharfList_GetShow() then
    return
  end
  local index = PaGlobalFunc_WharfList_SelectSlotNo()
  local servantInfo = stable_getServant(index)
  if nil == servantInfo then
    return
  end
  if servantNo ~= servantInfo:getServantNo() then
    return
  end
  PaGlobalFunc_WharfList_Update()
end
