local Panel_Window_StableList_info = {
  _ui = {
    static_Stable_BG = nil,
    staticText_Icon = nil,
    staticText_Region = nil,
    static_LT_ConsoleUI = nil,
    static_RT_ConsoleUI = nil,
    button_Unseal_Vehicle = nil,
    static_Unseal_SexIcon = nil,
    staticText_Unseal_Tier = nil,
    staticText_Unseal_Name = nil,
    staticText_Unseal_Location = nil,
    staticText_Unseal_NoUnseal = nil,
    static_Unseal_SwiftIcon = nil,
    button_HorseEmblem_Regist = nil,
    static_HorseRegist_Icon = nil,
    staticText_HorseRegist_Icon = nil,
    button_WildHorse_Regist = nil,
    staticText_WildRegist_Icon = nil,
    static_Horse_List = nil,
    radioButton_Slot = nil,
    static_Image_Template = nil,
    static_SexIcon_Template = nil,
    staticText_Tier_Template = nil,
    staticText_Name_Template = nil,
    staticText_Location_Template = nil,
    staticText_State_Template = nil,
    static_SwiftIcon_Template = nil,
    static_StateBg = nil,
    static_StateIcon = nil,
    radioButton_Slot_List = {},
    horse_List_HorizontalScroll = nil,
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
    lastToggleIndex = 0,
    currentToggleIndex = 0,
    startButtonIndex = 0,
    stableSlotCount = 0,
    isUnseal = false,
    buttonPosCount = 0
  },
  _enum = {
    eTYPE_SEALED = 0,
    eTYPE_UNSEALED = 1,
    eBUTTON_UNSEAL = 0,
    eBUTTON_MAPAE = 1,
    eBUTTON_TAMING = 2,
    eBUTTON_SEAL = 3
  },
  _buttonPos = {
    [0] = 0,
    [1] = 0,
    [2] = 0
  },
  _buttonAble = {
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false
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
    maxButtonPosCount = 2,
    slotRows = 1,
    slotCount = 6,
    maxSlotCount = 8,
    nowSlotCount = 6
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
    stateIcon = "Renewal/UI_Icon/Console_Icon_03.dds",
    registMarket = {
      x1 = 129,
      y1 = 1,
      x2 = 179,
      y2 = 51
    },
    registMating = {
      x1 = 180,
      y1 = 1,
      x2 = 230,
      y2 = 51
    },
    progressMating = {
      x1 = 231,
      y1 = 1,
      x2 = 281,
      y2 = 51
    },
    dead = {
      x1 = 129,
      y1 = 52,
      x2 = 179,
      y2 = 102
    },
    training = {
      x1 = 180,
      y1 = 52,
      x2 = 230,
      y2 = 102
    },
    stallionTraining = {
      x1 = 231,
      y1 = 52,
      x2 = 281,
      y2 = 102
    },
    linked = {
      x1 = 282,
      y1 = 1,
      x2 = 332,
      y2 = 51
    },
    isSeized = {
      x1 = 282,
      y1 = 103,
      x2 = 332,
      y2 = 153
    },
    completeMating = {
      x1 = 282,
      y1 = 52,
      x2 = 332,
      y2 = 102
    },
    recoveryCarriage = {
      x1 = 180,
      y1 = 103,
      x2 = 230,
      y2 = 153
    },
    recoveryHorse = {
      x1 = 231,
      y1 = 103,
      x2 = 281,
      y2 = 153
    },
    completeTraining = {
      x1 = 129,
      y1 = 103,
      x2 = 179,
      y2 = 153
    }
  },
  _slots = {}
}
local stable = CppEnums.ServantStateType.Type_Stable
local nowMating = CppEnums.ServantStateType.Type_Mating
local regMarket = CppEnums.ServantStateType.Type_RegisterMarket
local regMating = CppEnums.ServantStateType.Type_RegisterMating
local training = CppEnums.ServantStateType.Type_SkillTraining
local stallionTraining = CppEnums.ServantStateType.Type_StallionTraining
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_SW = CppEnums.ServantWhereType
local isContentsEnable = ToClient_IsContentsGroupOpen("61")
local isContentsStallionEnable = ToClient_IsContentsGroupOpen("243")
local isContentsNineTierEnable = ToClient_IsContentsGroupOpen("80")
function StableSlotTemplete:New()
  return slot
end
function Panel_Window_StableList_info:registerEventHandler()
end
function Panel_Window_StableList_info:registerMessageHandler()
  Panel_Window_StableList:RegisterShowEventFunc(true, "PaGlobalFunc_StableList_ShowAni()")
  Panel_Window_StableList:RegisterShowEventFunc(false, "PaGlobalFunc_StableList_HideAni()")
  registerEvent("onScreenResize", "FromClient_StableList_Resize")
  registerEvent("FromClient_ServantUpdate", "PaGlobalFunc_StableList_Update")
  registerEvent("FromClient_ServantRegisterToAuction", "PaGlobalFunc_StableList_Update")
  registerEvent("FromClient_ServantTaming", "PaGlobalFunc_StableList_Update")
  registerEvent("FromClient_RegisterServantFail", "FromClient_StableList_PopMessageBox")
  registerEvent("FromClient_ServantSeal", "FromClient_StableList_ServantSeal")
  registerEvent("FromClient_ServantUnseal", "FromClient_StableList_ServantUnseal")
  registerEvent("FromClient_ServantToReward", "FromClient_StableList_ServantToReward")
  registerEvent("FromClient_ServantRecovery", "FromClient_StableList_ServantRecovery")
  registerEvent("FromClient_ServantChangeName", "FromClient_StableList_ServantChangeName")
  registerEvent("FromClient_ServantRegisterAuction", "FromClient_StableList_ServantRegisterAuction")
  registerEvent("FromClient_ServantCancelAuction", "FromClient_StableList_ServantCancelAuction")
  registerEvent("FromClient_ServantReceiveAuction", "FromClient_StableList_ServantReceiveAuction")
  registerEvent("FromClient_ServantBuyMarket", "FromClient_StableList_ServantBuyMarket")
  registerEvent("FromClient_ServantStartMating", "FromClient_StableList_ServantStartMating")
  registerEvent("FromClient_ServantChildMating", "FromClient_StableList_ServantChildMating")
  registerEvent("FromClient_ServantEndMating", "FromClien_StableList_ServantEndMating")
  registerEvent("FromClient_ServantClearDeadCount", "FromClient_StableList_ServantClearDeadCount")
  registerEvent("FromClient_ServantImprint", "FromClient_StableList_ServantImprint")
  registerEvent("FromClient_ServantClearMatingCount", "FromClient_StableList_ServantClearMatingCount")
  registerEvent("FromClient_ServantLink", "FromClient_StableList_StableList_ServantLink")
  registerEvent("FromClient_ServantStartSkillTraining", "FromClient_StableList_ServantStartSkillTraining")
  registerEvent("FromClient_ServantEndSkillTraining", "FromClient_StableList_ServantEndSkillTraining")
  registerEvent("FromClient_StartStallionSkillTraining", "FromClient_StableList_StartStallionSkillTraining")
  registerEvent("FromClient_EndStallionSkillTraining", "FromClient_StableList_EndStallionSkillTraining")
  registerEvent("FromClient_IncreaseStallionSkillExpAck", "FromClient_StableList_IncreaseStallionSkillExpAck")
  registerEvent("FromClient_OnChangeServantRegion", "FromClient_StableList_ChangeServantRegion_HandleUpdate")
end
function Panel_Window_StableList_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:createSlot()
  self:registerMessageHandler()
  self:registerEventHandler()
end
function Panel_Window_StableList_info:initValue()
  self._value.lastButtonIndex = -1
  self._value.currentButtonIndex = -1
  self._value.lastButtonSlotNo = -1
  self._value.currentButtonSlotNo = -1
  self._value.startButtonIndex = 0
  self._value.stableSlotCount = 0
  self._value.isUnseal = false
  self._value.buttonPosCount = 0
  self._value.lastToggleIndex = 0
  self._value.currentToggleIndex = 0
  for key, value in pairs(self._buttonAble) do
    value = false
  end
end
function Panel_Window_StableList_info:resize()
end
function Panel_Window_StableList_info:childControl()
  self._ui.static_Stable_BG = UI.getChildControl(Panel_Window_StableList, "Static_Stable_BG")
  self._ui.staticText_Icon = UI.getChildControl(self._ui.static_Stable_BG, "StaticText_Icon")
  self._ui.staticText_Region = UI.getChildControl(self._ui.static_Stable_BG, "StaticText_Region")
  self._ui.staticText_Region:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.button_Unseal_Vehicle = UI.getChildControl(Panel_Window_StableList, "Button_Unseal_Vehicle")
  self._ui.static_Unseal_Image = UI.getChildControl(self._ui.button_Unseal_Vehicle, "Static_Unseal_Image")
  self._ui.static_Unseal_SexIcon = UI.getChildControl(self._ui.button_Unseal_Vehicle, "Static_Unseal_SexIcon")
  self._ui.staticText_Unseal_Tier = UI.getChildControl(self._ui.button_Unseal_Vehicle, "StaticText_Unseal_Tier")
  self._ui.staticText_Unseal_Name = UI.getChildControl(self._ui.button_Unseal_Vehicle, "StaticText_Unseal_Name")
  self._ui.staticText_Unseal_Location = UI.getChildControl(self._ui.button_Unseal_Vehicle, "StaticText_Unseal_Location")
  self._ui.staticText_Unseal_NoUnseal = UI.getChildControl(self._ui.button_Unseal_Vehicle, "StaticText_Unseal_NoUnseal")
  self._ui.static_Unseal_SwiftIcon = UI.getChildControl(self._ui.button_Unseal_Vehicle, "Static_Unseal_SwiftIcon")
  self._ui.staticText_Unseal_NoUnseal:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.button_HorseEmblem_Regist = UI.getChildControl(Panel_Window_StableList, "Button_HorseEmblem_Regist")
  self._ui.staticText_HorseRegist_Icon = UI.getChildControl(self._ui.button_HorseEmblem_Regist, "StaticText_HorseRegist_Icon")
  self._buttonPos[0] = self._ui.button_HorseEmblem_Regist:GetPosX()
  self._ui.button_WildHorse_Regist = UI.getChildControl(Panel_Window_StableList, "Button_WildHorse_Regist")
  self._ui.staticText_WildRegist_Icon = UI.getChildControl(self._ui.button_WildHorse_Regist, "StaticText_WildRegist_Icon")
  self._buttonPos[1] = self._ui.button_WildHorse_Regist:GetPosX()
  self._ui.staticText_HorseRegist_Icon:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.staticText_HorseRegist_Icon:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEFUNCTION_BTN_REGISTERBYITEM"))
  self._ui.staticText_WildRegist_Icon:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.staticText_WildRegist_Icon:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_FUNCTION_BTN_REGISTHORSE"))
  self._ui.static_Horse_List = UI.getChildControl(Panel_Window_StableList, "Static_Horse_List")
  self._buttonPos[2] = self._ui.static_Horse_List:GetPosX()
  self._ui.radioButton_Slot = UI.getChildControl(self._ui.static_Horse_List, "RadioButton_Slot")
  self._ui.radioButton_Slot:SetShow(false)
  self._ui.static_Image_Template = UI.getChildControl(self._ui.radioButton_Slot, "Static_Image_Template")
  self._ui.static_SexIcon_Template = UI.getChildControl(self._ui.radioButton_Slot, "Static_SexIcon_Template")
  self._ui.staticText_Tier_Template = UI.getChildControl(self._ui.radioButton_Slot, "StaticText_Tier_Template")
  self._ui.staticText_Name_Template = UI.getChildControl(self._ui.radioButton_Slot, "StaticText_Name_Template")
  self._ui.staticText_Location_Template = UI.getChildControl(self._ui.radioButton_Slot, "StaticText_Location_Template")
  self._ui.staticText_State_Template = UI.getChildControl(self._ui.radioButton_Slot, "StaticText_State_Template")
  self._ui.static_SwiftIcon_Template = UI.getChildControl(self._ui.radioButton_Slot, "Static_SwiftIcon_Template")
  self._ui.static_StateBg = UI.getChildControl(self._ui.radioButton_Slot, "Static_StateBg")
  self._ui.static_StateIcon = UI.getChildControl(self._ui.radioButton_Slot, "Static_StateIcon")
  self._ui.horse_List_HorizontalScroll = UI.getChildControl(self._ui.static_Horse_List, "Horse_List_HorizontalScroll")
  self._ui.horse_List_HorizontalScroll:SetEnable(false)
  self._pos.firstPosX = self._ui.radioButton_Slot:GetPosX()
  self._pos.buttonSizeX = self._ui.radioButton_Slot:GetSizeX()
  self._ui.static_CountBg = UI.getChildControl(Panel_Window_StableList, "Static_CountBg")
  self._ui.staticText_UnsealCount = UI.getChildControl(self._ui.static_CountBg, "StaticText_UnsealCount")
  self._ui.staticText_SealCount = UI.getChildControl(self._ui.static_CountBg, "StaticText_SealCount")
  self._ui.staticText_MaxCount = UI.getChildControl(self._ui.static_CountBg, "StaticText_MaxCount")
  self._pos.stableInfoButtonSize = self._ui.staticText_UnsealCount:GetSizeX()
  self._ui.static_KeyGuideBg = UI.getChildControl(Panel_Window_StableList, "Static_KeyGuideBg")
  self._ui.staticText_Confirm_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuideBg, "StaticText_Confirm_ConsoleUI")
  self._ui.staticText_Exit_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuideBg, "StaticText_Exit_ConsoleUI")
  self._ui.staticText_Move_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuideBg, "StaticText_Move_ConsoleUI")
  self._pos.keyGuideButtonSize = self._ui.staticText_Confirm_ConsoleUI:GetSizeX()
end
function Panel_Window_StableList_info:createSlot()
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
      static_SexIcon = nil,
      staticText_Tier = nil,
      staticText_SwiftIcon = nil,
      static_StateBg = nil,
      static_StateIcon = nil
    }
    function slot:setPos(index)
      local stableList = Panel_Window_StableList_info
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
      self.staticText_Location:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
      self.staticText_Location:SetText(servantInfo:getRegionName())
      self.static_Image:SetShow(true)
      self.static_Image:ChangeTextureInfoName(servantInfo:getIconPath1())
      local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
      local regionName = regionInfo:getAreaName()
      if regionName == servantRegionName then
        self.radioButton:SetMonoTone(false)
        self.slotEnable = true
      elseif 0 == servantInfo:getHp() and (CppEnums.VehicleType.Type_Horse == vehicleType or CppEnums.VehicleType.Type_Donkey == vehicleType or CppEnums.VehicleType.Type_Camel == vehicleType or CppEnums.VehicleType.Type_MountainGoat == vehicleType) and not servantInfo:isMatingComplete() and nowMating ~= getState and regMarket ~= getState and regMating ~= getState and training ~= getState then
        self.radioButton:SetMonoTone(false)
        self.slotEnable = true
      elseif servantInfo:getHp() < servantInfo:getMaxHp() and CppEnums.VehicleType.Type_Carriage == vehicleType or CppEnums.VehicleType.Type_CowCarriage == vehicleType then
        self.radioButton:SetMonoTone(false)
        self.slotEnable = true
      elseif not isSiegeStable() then
        self.radioButton:SetMonoTone(true)
        self.slotEnable = false
      end
      local stableinfo = Panel_Window_StableList_info
      local showState = false
      local x1, y1, x2, y2
      if nil ~= getState then
        self.staticText_State:SetShow(true)
        self.staticText_State:SetText("")
        self.static_StateBg:SetShow(false)
        self.static_StateIcon:SetShow(false)
      end
      self.static_StateIcon:ChangeTextureInfoName(stableinfo._texture.stateIcon)
      if servantInfo:isSeized() then
        self.staticText_State:SetShow(true)
        self.staticText_State:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_LIST_ATTACHMENT"))
        showState = true
        x1, y1, x2, y2 = setTextureUV_Func(self.static_StateIcon, stableinfo._texture.isSeized.x1, stableinfo._texture.isSeized.y1, stableinfo._texture.isSeized.x2, stableinfo._texture.isSeized.y2)
      elseif CppEnums.ServantStateType.Type_RegisterMarket == getState then
        self.staticText_State:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_TXT_MARKETREGISTER"))
        showState = true
        x1, y1, x2, y2 = setTextureUV_Func(self.static_StateIcon, stableinfo._texture.registMarket.x1, stableinfo._texture.registMarket.y1, stableinfo._texture.registMarket.x2, stableinfo._texture.registMarket.y2)
      elseif CppEnums.ServantStateType.Type_RegisterMating == getState then
        self.staticText_State:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_MATINGREGISTER"))
        showState = true
        x1, y1, x2, y2 = setTextureUV_Func(self.static_StateIcon, stableinfo._texture.registMating.x1, stableinfo._texture.registMating.y1, stableinfo._texture.registMating.x2, stableinfo._texture.registMating.y2)
      elseif CppEnums.ServantStateType.Type_Mating == getState then
        if servantInfo:isMatingComplete() then
          self.staticText_State:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_TXT_MATED"))
          showState = true
          x1, y1, x2, y2 = setTextureUV_Func(self.static_StateIcon, stableinfo._texture.completeMating.x1, stableinfo._texture.completeMating.y1, stableinfo._texture.completeMating.x2, stableinfo._texture.completeMating.y2)
        else
          self.staticText_State:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_TXT_MATING"))
          showState = true
          x1, y1, x2, y2 = setTextureUV_Func(self.static_StateIcon, stableinfo._texture.progressMating.x1, stableinfo._texture.progressMating.y1, stableinfo._texture.progressMating.x2, stableinfo._texture.progressMating.y2)
        end
      elseif CppEnums.ServantStateType.Type_Coma == getState then
        if vehicleType == CppEnums.VehicleType.Type_Carriage or vehicleType == CppEnums.VehicleType.Type_CowCarriage or vehicleType == CppEnums.VehicleType.Type_RepairableCarriage then
          self.staticText_State:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_REPAIR"))
          showState = true
          x1, y1, x2, y2 = setTextureUV_Func(self.static_StateIcon, stableinfo._texture.recoveryCarriage.x1, stableinfo._texture.recoveryCarriage.y1, stableinfo._texture.recoveryCarriage.x2, stableinfo._texture.recoveryCarriage.y2)
        else
          self.staticText_State:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_TXT_HURT"))
          showState = true
          x1, y1, x2, y2 = setTextureUV_Func(self.static_StateIcon, stableinfo._texture.recoveryHorse.x1, stableinfo._texture.recoveryHorse.y1, stableinfo._texture.recoveryHorse.x2, stableinfo._texture.recoveryHorse.y2)
        end
      elseif CppEnums.ServantStateType.Type_SkillTraining == getState then
        if stable_isSkillExpTrainingComplete(sortIndex) then
          self.staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TRAINFINISH"))
          showState = true
          x1, y1, x2, y2 = setTextureUV_Func(self.static_StateIcon, stableinfo._texture.completeTraining.x1, stableinfo._texture.completeTraining.y1, stableinfo._texture.completeTraining.x2, stableinfo._texture.completeTraining.y2)
        else
          self.staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TRAINING"))
          showState = true
          x1, y1, x2, y2 = setTextureUV_Func(self.static_StateIcon, stableinfo._texture.training.x1, stableinfo._texture.training.y1, stableinfo._texture.training.x2, stableinfo._texture.training.y2)
        end
      elseif CppEnums.ServantStateType.Type_StallionTraining == getState and isContentsStallionEnable and isContentsNineTierEnable then
        self.staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TRAINING"))
        showState = true
        x1, y1, x2, y2 = setTextureUV_Func(self.static_StateIcon, stableinfo._texture.stallionTraining.x1, stableinfo._texture.stallionTraining.y1, stableinfo._texture.stallionTraining.x2, stableinfo._texture.stallionTraining.y2)
      elseif servantInfo:isChangingRegion() then
      end
      if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse and servantInfo:isLink() then
        showState = true
        self.staticText_State:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_STABLEFUNCTION_HORSELINK"))
        x1, y1, x2, y2 = setTextureUV_Func(self.static_StateIcon, stableinfo._texture.linked.x1, stableinfo._texture.linked.y1, stableinfo._texture.linked.x2, stableinfo._texture.linked.y2)
      end
      if true == showState then
        self.staticText_State:SetShow(false)
        self.static_StateBg:SetShow(true)
        self.static_StateIcon:SetShow(true)
        self.static_StateIcon:getBaseTexture():setUV(x1, y1, x2, y2)
        self.static_StateIcon:setRenderTexture(self.static_StateIcon:getBaseTexture())
      end
      if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
        self.static_SexIcon:SetShow(true)
        self.staticText_Tier:SetShow(true)
        self.staticText_SwiftIcon:SetShow(true)
        local listInfo = Panel_Window_StableList_info
        if servantInfo:isMale() then
          self.static_SexIcon:ChangeTextureInfoName(listInfo._texture.sexIcon)
          local x1, y1, x2, y2 = setTextureUV_Func(self.static_SexIcon, listInfo._texture.male.x1, listInfo._texture.male.y1, listInfo._texture.male.x2, listInfo._texture.male.y2)
          self.static_SexIcon:getBaseTexture():setUV(x1, y1, x2, y2)
          self.static_SexIcon:setRenderTexture(self.static_SexIcon:getBaseTexture())
        else
          self.static_SexIcon:ChangeTextureInfoName(listInfo._texture.sexIcon)
          local x1, y1, x2, y2 = setTextureUV_Func(self.static_SexIcon, listInfo._texture.female.x1, listInfo._texture.female.y1, listInfo._texture.female.x2, listInfo._texture.female.y2)
          self.static_SexIcon:getBaseTexture():setUV(x1, y1, x2, y2)
          self.static_SexIcon:setRenderTexture(self.static_SexIcon:getBaseTexture())
        end
        if 9 == servantInfo:getTier() then
          self.staticText_Tier:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9"))
        else
          self.staticText_Tier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", servantInfo:getTier()))
        end
        if 9 ~= servantInfo:getTier() and false == servantInfo:isPcroomOnly() and isContentsStallionEnable then
          local stallion = servantInfo:isStallion()
          if true == stallion and regionName == servantRegionName then
            self.staticText_SwiftIcon:SetMonoTone(false)
          else
            self.staticText_SwiftIcon:SetMonoTone(true)
          end
        else
          self.staticText_SwiftIcon:SetShow(false)
        end
        if servantInfo:isLink() then
          self.staticText_Location:SetShow(false)
        else
          self.staticText_Location:SetShow(true)
        end
      end
    end
    function slot:setShow(bShow)
      bShow = bShow or false
      self.radioButton:SetShow(bShow)
      self.static_Image:SetShow(bShow)
      self.static_SexIcon:SetShow(bShow)
      self.staticText_Tier:SetShow(bShow)
      self.staticText_Name:SetShow(bShow)
      self.staticText_Location:SetShow(bShow)
      self.staticText_State:SetShow(bShow)
      self.staticText_SwiftIcon:SetShow(bShow)
    end
    function slot:setShowInner(bShow)
      bShow = bShow or false
      self.static_Image:SetShow(bShow)
      self.static_SexIcon:SetShow(bShow)
      self.staticText_Tier:SetShow(bShow)
      self.staticText_Name:SetShow(bShow)
      self.staticText_Location:SetShow(bShow)
      self.staticText_State:SetShow(bShow)
      self.staticText_SwiftIcon:SetShow(bShow)
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
    slot.radioButton = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui.static_Horse_List, "radioButton_Slot_" .. index)
    CopyBaseProperty(self._ui.radioButton_Slot, slot.radioButton)
    slot.static_Image = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.radioButton, "Static_Image_Template_" .. index)
    CopyBaseProperty(self._ui.static_Image_Template, slot.static_Image)
    slot.static_SexIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.radioButton, "Static_SexIcon_Template_" .. index)
    CopyBaseProperty(self._ui.static_SexIcon_Template, slot.static_SexIcon)
    slot.staticText_Tier = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.radioButton, "StaticText_Tier_Template_" .. index)
    CopyBaseProperty(self._ui.staticText_Tier_Template, slot.staticText_Tier)
    slot.staticText_Name = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.radioButton, "StaticText_Name_Template_" .. index)
    CopyBaseProperty(self._ui.staticText_Name_Template, slot.staticText_Name)
    slot.staticText_Location = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.radioButton, "StaticText_Location_Template_" .. index)
    CopyBaseProperty(self._ui.staticText_Location_Template, slot.staticText_Location)
    slot.staticText_State = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.radioButton, "StaticText_State_Template_" .. index)
    CopyBaseProperty(self._ui.staticText_State_Template, slot.staticText_State)
    slot.staticText_SwiftIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.radioButton, "Static_SwiftIcon_Template_" .. index)
    CopyBaseProperty(self._ui.static_SwiftIcon_Template, slot.staticText_SwiftIcon)
    slot.static_StateBg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.radioButton, "Static_StateBg_" .. index)
    CopyBaseProperty(self._ui.static_StateBg, slot.static_StateBg)
    slot.static_StateIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.radioButton, "Static_StateIcon_" .. index)
    CopyBaseProperty(self._ui.static_StateIcon, slot.static_StateIcon)
    slot.slotNo = index
    slot:setPos(index)
    self._slots[index] = slot
    slot.radioButton:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_StableList_ScrollEvent( true )")
    slot.radioButton:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_StableList_ScrollEvent( false )")
  end
end
function Panel_Window_StableList_info:setInfoCount()
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
    self._ui.staticText_UnsealCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_UNSEALCOUNT_TITLE") .. " : " .. unsealedCount)
    self._ui.staticText_SealCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SEALCOUNT_TITLE") .. " : " .. sealedCount)
    self._ui.staticText_MaxCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_MAXCOUNT_TITLE") .. " : " .. stable_maxSlotCount())
    self:setInfoCountPos()
  end
end
function Panel_Window_StableList_info:setInfoCountPos()
  local space = self._pos.stableInfoButtonSize + self._pos.stableInfoButtonSpace
  local textLength1 = self._ui.staticText_UnsealCount:GetTextSizeX()
  local textLength2 = self._ui.staticText_SealCount:GetTextSizeX()
  self._ui.staticText_SealCount:SetPosX(space + textLength1)
  self._ui.staticText_MaxCount:SetPosX(space * 2 + textLength1 + textLength2)
end
function Panel_Window_StableList_info:setKeyGuidePos()
  local keyGuides = {
    self._ui.staticText_Move_ConsoleUI,
    self._ui.staticText_Confirm_ConsoleUI,
    self._ui.staticText_Exit_ConsoleUI
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.static_KeyGuideBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Panel_Window_StableList_info:setUnsealButton()
  self._ui.button_Unseal_Vehicle:SetShow(true)
  self._ui.static_Unseal_Image:SetShow(false)
  self._ui.static_Unseal_SexIcon:SetShow(false)
  self._ui.staticText_Unseal_Tier:SetShow(false)
  self._ui.staticText_Unseal_Name:SetShow(false)
  self._ui.staticText_Unseal_Location:SetShow(false)
  self._ui.static_Unseal_SwiftIcon:SetShow(false)
  self._ui.staticText_Unseal_NoUnseal:SetShow(true)
  self._ui.staticText_Unseal_NoUnseal:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLELIST_NOT_UNSEAL_SERVANT"))
  self._buttonAble[self._enum.eBUTTON_UNSEAL] = true
  self._ui.button_Unseal_Vehicle:addInputEvent("Mouse_On", "PaGlobalFunc_StableList_ShowButtonA(false)")
  local temporaryWrapper = getTemporaryInformationWrapper()
  local servantInfo = temporaryWrapper:getUnsealVehicle(stable_getServantType())
  if nil ~= servantInfo then
    self._value.isUnseal = true
    self._ui.button_Unseal_Vehicle:addInputEvent("Mouse_On", "PaGlobalFunc_StableList_ShowButtonA(true)")
    self._ui.button_Unseal_Vehicle:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableList_ClickUnsealed()")
    local servantRegionName = servantInfo:getRegionName()
    local vehicleType = servantInfo:getVehicleType()
    self._ui.staticText_Unseal_NoUnseal:SetShow(false)
    self._ui.staticText_Unseal_Name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    self._ui.staticText_Unseal_Name:SetShow(true)
    self._ui.staticText_Unseal_Name:SetText(servantInfo:getName())
    self._ui.static_Unseal_Image:SetShow(true)
    self._ui.static_Unseal_Image:ChangeTextureInfoName(servantInfo:getIconPath1())
    if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
      self._ui.static_Unseal_SexIcon:SetShow(true)
      if servantInfo:isMale() then
        self._ui.static_Unseal_SexIcon:ChangeTextureInfoName(self._texture.sexIcon)
        local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Unseal_SexIcon, self._texture.male.x1, self._texture.male.y1, self._texture.male.x2, self._texture.male.y2)
        self._ui.static_Unseal_SexIcon:getBaseTexture():setUV(x1, y1, x2, y2)
        self._ui.static_Unseal_SexIcon:setRenderTexture(self._ui.static_Unseal_SexIcon:getBaseTexture())
      else
        self._ui.static_Unseal_SexIcon:ChangeTextureInfoName(self._texture.sexIcon)
        local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Unseal_SexIcon, self._texture.female.x1, self._texture.female.y1, self._texture.female.x2, self._texture.female.y2)
        self._ui.static_Unseal_SexIcon:getBaseTexture():setUV(x1, y1, x2, y2)
        self._ui.static_Unseal_SexIcon:setRenderTexture(self._ui.static_Unseal_SexIcon:getBaseTexture())
      end
      self._ui.staticText_Unseal_Tier:SetShow(true)
      if 9 == servantInfo:getTier() then
        self._ui.staticText_Unseal_Tier:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9"))
      else
        self._ui.staticText_Unseal_Tier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", servantInfo:getTier()))
      end
      if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse and 9 ~= servantInfo:getTier() and false == servantInfo:isPcroomOnly() and isContentsStallionEnable then
        self._ui.static_Unseal_SwiftIcon:SetShow(true)
        local stallion = servantInfo:isStallion()
        if true == stallion and regionName == servantRegionName then
          self._ui.static_Unseal_SwiftIcon:SetMonoTone(false)
        else
          self._ui.static_Unseal_SwiftIcon:SetMonoTone(true)
        end
      end
    end
  end
end
function Panel_Window_StableList_info:setRegistAndTameButton()
  if stable_doHaveRegisterItem() then
    self._ui.button_HorseEmblem_Regist:SetPosX(self._buttonPos[self._value.buttonPosCount])
    self._value.buttonPosCount = self._value.buttonPosCount + 1
    self._buttonAble[self._enum.eBUTTON_MAPAE] = true
    self._ui.button_HorseEmblem_Regist:SetShow(true)
    self._ui.button_HorseEmblem_Regist:addInputEvent("Mouse_On", "PaGlobalFunc_StableList_ShowButtonA(true)")
    self._ui.button_HorseEmblem_Regist:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableList_ClickMapae()")
  else
    self._ui.button_HorseEmblem_Regist:SetShow(false)
  end
  local characterKey = stable_getTamingServantCharacterKey()
  if nil ~= characterKey then
    local servantInfo = stable_getServantByCharacterKey(characterKey, 1)
    if nil ~= servantInfo then
      self._ui.button_WildHorse_Regist:SetPosX(self._buttonPos[self._value.buttonPosCount])
      self._value.buttonPosCount = self._value.buttonPosCount + 1
      self._buttonAble[self._enum.eBUTTON_TAMING] = true
      self._ui.button_WildHorse_Regist:SetShow(true)
      self._ui.button_WildHorse_Regist:addInputEvent("Mouse_On", "PaGlobalFunc_StableList_ShowButtonA(true)")
      self._ui.button_WildHorse_Regist:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableList_ClickTaming()")
    end
  else
    self._ui.button_WildHorse_Regist:SetShow(false)
  end
end
function Panel_Window_StableList_info:setStableListSizeAndPos()
  local servantCount = stable_count()
  self._ui.static_Horse_List:SetPosX(self._buttonPos[self._value.buttonPosCount])
  local plusButtonCount = self._config.maxButtonPosCount - self._value.buttonPosCount
  self._config.nowSlotCount = self._config.slotCount + plusButtonCount
  local sizeX = self._config.nowSlotCount * self._pos.buttonSizeX + (self._config.nowSlotCount - 1) * self._pos.buttonSpaceSizeX
  self._ui.static_Horse_List:SetSize(sizeX, self._ui.static_Horse_List:GetSizeY())
  self._ui.horse_List_HorizontalScroll:SetSize(sizeX - 10, self._ui.horse_List_HorizontalScroll:GetSizeY())
  self._ui.horse_List_HorizontalScroll:SetHorizonCenter()
  self._value.stableSlotCount = servantCount
  UIScroll_Horizontal_SetButtonSize(self._ui.horse_List_HorizontalScroll, self._config.nowSlotCount, self._value.stableSlotCount)
end
function Panel_Window_StableList_info:clearCheck()
  self._value.lastButtonSlotNo = -1
  self._value.currentButtonSlotNo = -1
  for ii = 0, self._config.maxSlotCount - 1 do
    local slot = self._slots[ii]
    slot:setSelect(false)
  end
end
function Panel_Window_StableList_info:setStableListButton()
  local servantCount = stable_count()
  if 0 == servantCount then
    self._buttonAble[self._enum.eBUTTON_SEAL] = false
    self._ui.static_Horse_List:SetShow(false)
    return
  else
    self._ui.static_Horse_List:SetShow(true)
    PaGlobalFunc_StableList_ServantCountInit(servantCount)
  end
  for ii = 0, self._config.maxSlotCount - 1 do
    local slot = self._slots[ii]
    slot:clearServant()
  end
  self._buttonAble[self._enum.eBUTTON_SEAL] = true
  PaGlobalFunc_StableList_SortDataupdate()
  local slotNo = 0
  local linkedHorseCount = 0
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local currentRegionKey = regionInfo:getRegionKey()
  local regionName = regionInfo:getAreaName()
  for index = 0, self._config.nowSlotCount - 1 do
    local slot = self._slots[index]
    slot.slotNo = self._value.startButtonIndex + index
    if index == 0 then
      slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "PaGlobalFunc_StableList_ScrollEvent( true )")
    elseif index == self._config.nowSlotCount - 1 then
      slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "PaGlobalFunc_StableList_ScrollEvent( false )")
    end
    if slot.slotNo < self._value.stableSlotCount then
      slot.slotNo = PaGlobalFunc_StableList_SortByWayPointKey(slot.slotNo)
      if self._value.currentButtonSlotNo == slot.slotNo then
        slot:setSelect(true)
      end
      slot:setShow(true)
      slot:setServant(slot.slotNo)
      slot.radioButton:addInputEvent("Mouse_On", "PaGlobalFunc_StableList_ShowButtonA(" .. tostring(slot.slotEnable) .. ")")
      slot.radioButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableList_ClickList(" .. slot.slotNo .. "," .. index .. ")")
    end
  end
end
function Panel_Window_StableList_info:setRegion()
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local regionName = regionInfo:getAreaName()
  self._ui.staticText_Icon:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_FUNCTION_STABLE"))
  self._ui.staticText_Region:SetText(regionName)
end
function Panel_Window_StableList_info:readyToShow()
  self:setKeyGuidePos()
  self:setRegion()
  self:setInfoCount()
  self:setUnsealButton()
  self:setRegistAndTameButton()
  self._ui.horse_List_HorizontalScroll:SetControlPos(0)
  self:setStableListSizeAndPos()
  self:setStableListButton()
end
function Panel_Window_StableList_info:open()
  _AudioPostEvent_SystemUiForXBOX(1, 30)
  Panel_Window_StableList:SetShow(true)
end
function Panel_Window_StableList_info:close()
  _AudioPostEvent_SystemUiForXBOX(1, 31)
  Panel_Window_StableList:SetShow(false)
end
function Panel_Window_StableList_info:findPossibleToggle(value)
  if 1 == value then
    local newToggleIndex = self._value.currentToggleIndex + 1
    local isEnd = false
    while true ~= self._buttonAble[newToggleIndex] do
      newToggleIndex = newToggleIndex + 1
      if nil == self._buttonAble[newToggleIndex] then
        isEnd = true
        break
      end
    end
    if false == isEnd then
      self._value.lastToggleIndex = self._value.currentToggleIndex
      self._value.currentToggleIndex = newToggleIndex
      return true
    else
      return false
    end
  end
  if -1 == value then
    local newToggleIndex = self._value.currentToggleIndex - 1
    local isEnd = false
    while true ~= self._buttonAble[newToggleIndex] do
      newToggleIndex = newToggleIndex - 1
      if nil == self._buttonAble[newToggleIndex] then
        isEnd = true
        break
      end
    end
    if false == isEnd then
      self._value.lastToggleIndex = self._value.currentToggleIndex
      self._value.currentToggleIndex = newToggleIndex
      return true
    else
      return false
    end
  end
end
function PaGlobalFunc_StableList_GetShow()
  return Panel_Window_StableList:GetShow()
end
function PaGlobalFunc_StableList_Open()
  local self = Panel_Window_StableList_info
  self:open()
end
function PaGlobalFunc_StableList_Show()
  local self = Panel_Window_StableList_info
  self:initValue()
  self:readyToShow()
  self:open()
end
function PaGlobalFunc_StableList_Close()
  local self = Panel_Window_StableList_info
  self:close()
end
function PaGlobalFunc_StableList_Update()
  local self = Panel_Window_StableList_info
  if false == PaGlobalFunc_StableList_GetShow() then
    return
  end
  self:initValue()
  self:readyToShow()
end
function PaGlobalFunc_StableList_ShowAni()
end
function PaGlobalFunc_StableList_HideAni()
end
function PaGlobalFunc_StableList_ScrollEvent(isUpScroll)
  local self = Panel_Window_StableList_info
  local beforeSlotIndex = self._value.startButtonIndex
  self._value.startButtonIndex = UIScroll_Horizontal_ScrollEvent(self._ui.horse_List_HorizontalScroll, isUpScroll, self._config.slotRows, self._value.stableSlotCount, self._value.startButtonIndex, self._config.nowSlotCount)
  if (ToClient_isConsole() or ToClient_IsDevelopment()) and 0 ~= self._value.startButtonIndex then
    ToClient_padSnapIgnoreGroupMove()
  end
  if beforeSlotIndex ~= self._value.startButtonIndex then
    self:setStableListButton()
  end
end
local sortByExploreKey = {}
function PaGlobalFunc_StableList_SelectSlotNo()
  local self = Panel_Window_StableList_info
  if nil == self._value.currentButtonIndex then
    return nil
  end
  return (PaGlobalFunc_StableList_SortByWayPointKey(self._value.startButtonIndex + self._value.currentButtonIndex))
end
function PaGlobalFunc_StableList_SortByWayPointKey(index)
  local self = Panel_Window_StableList_info
  if nil == index then
    return nil
  else
    return sortByExploreKey[index + 1]._index
  end
end
function PaGlobalFunc_StableList_ServantCountInit(nums)
  sortByExploreKey = {}
  for i = 0, nums do
    sortByExploreKey[i] = {
      _index = nil,
      _servantNo = nil,
      _exploreKey = nil
    }
  end
end
function PaGlobalFunc_StableList_SortDataupdate()
  local maxStableServantCount = stable_count()
  PaGlobalFunc_StableList_ServantCountInit(maxStableServantCount)
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
function PaGlobalFunc_StableList_ClickUnsealed()
  local self = Panel_Window_StableList_info
  local temporaryWrapper = getTemporaryInformationWrapper()
  local servantInfo = temporaryWrapper:getUnsealVehicle(stable_getServantType())
  if nil == servantInfo then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  PaGlobalFunc_StableInfo_Show(self._enum.eTYPE_UNSEALED)
end
function PaGlobalFunc_StableList_UnClickList()
  local self = Panel_Window_StableList_info
  self:clearCheck()
end
function PaGlobalFunc_StableList_ShowButtonA(enable)
  local self = Panel_Window_StableList_info
  if nil == enable then
    enable = false
  end
  self._ui.staticText_Confirm_ConsoleUI:SetShow(enable)
  self:setKeyGuidePos()
end
function PaGlobalFunc_StableList_ClickList(slotNo, index)
  local self = Panel_Window_StableList_info
  local slot = self._slots[index]
  if nil == slot then
    return
  end
  if false == slot.slotEnable then
    PaGlobalFunc_StableInfo_Menu_Close()
    PaGlobalFunc_StableInfo_Close()
    return
  end
  slot:setSelect(true)
  self._value.lastButtonSlotNo = self._value.currentButtonSlotNo
  self._value.currentButtonSlotNo = slotNo
  self._value.lastButtonIndex = self._value.currentButtonIndex
  self._value.currentButtonIndex = index
  local servantInfo = stable_getServant(slotNo)
  PaGlobalFunc_StableInfo_Show(self._enum.eTYPE_SEALED)
end
function PaGlobalFunc_StableList_ClickMapae()
  local self = Panel_Window_StableList_info
  if 0 < PaGlobalFunc_StableRegister_CheckIsMapae() then
    _AudioPostEvent_SystemUiForXBOX(50, 0)
    PaGlobalFunc_StableRegister_OpenByMapae()
    self:close()
    PaGlobalFunc_StableInfo_CloseWith()
  end
end
function PaGlobalFunc_StableList_ClickTaming()
  local self = Panel_Window_StableList_info
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  PaGlobalFunc_StableRegister_OpenByTaming()
  self:close()
  PaGlobalFunc_StableInfo_CloseWith()
end
function PaGlobalFunc_StableList_forPadEventInite()
  local self = Panel_Window_StableList_info
  for key, value in pairs(self._buttonAble) do
    if true == value then
      self._value.currentToggleIndex = key
      break
    end
  end
end
function FromClient_StableList_Init()
  local self = Panel_Window_StableList_info
  self:initialize()
end
function FromClient_StableList_Resize()
  local self = Panel_Window_StableList_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_StableList_Init")
function FromClient_StableList_ServantSeal(servantNo, regionKey, servantWhereType)
  if not PaGlobalFunc_StableList_GetShow() then
    return
  end
  if UI_SW.ServantWhereTypeUser ~= servantWhereType and UI_SW.ServantWhereTypePcRoom ~= servantWhereType then
    return
  end
  local servantInfo = stable_getServantByServantNo(servantNo, servantWhereType)
  if nil == servantInfo then
    return
  end
  PaGlobalFunc_StableList_Update()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_GIVE_SERVANT_ACK"))
end
function FromClient_StableList_ServantUnseal(servantNo, servantWhereType)
  if not PaGlobalFunc_StableList_GetShow() then
    return
  end
  if UI_SW.ServantWhereTypeUser ~= servantWhereType and UI_SW.ServantWhereTypePcRoom ~= servantWhereType then
    return
  end
  local servantInfo = stable_getServantByServantNo(servantNo, servantWhereType)
  if nil == servantInfo then
    return
  end
  PaGlobalFunc_StableList_Update()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_GET_SERVANT_ACK"))
end
function FromClient_StableList_PopMessageBox(possibleTime_s64)
  local stringText = convertStringFromDatetime(possibleTime_s64)
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLELIST_POPMSGBOX_MEMO", "stringText", stringText)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionApply = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FromClient_StableList_ServantToReward(servantNo, servantWhereType)
  if not PaGlobalFunc_StableList_GetShow() then
    return
  end
  if UI_SW.ServantWhereTypeUser ~= servantWhereType then
    return
  end
  if sellCheck == true then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SELL_SERVANT_ACK"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_LOOSE_SERVANT_ACK"))
  end
  PaGlobalFunc_StableInfo_Exit()
end
function FromClient_StableList_ServantRecovery(servantNo, servantWhereType)
  if UI_SW.ServantWhereTypeUser ~= servantWhereType and UI_SW.ServantWhereTypePcRoom ~= servantWhereType then
    return
  end
  local servantInfo = stable_getServantByServantNo(servantNo, servantWhereType)
  if nil == servantInfo then
    return
  end
  if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Camel or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Donkey or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_MountainGoat then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_RECOVERY_ACK"))
  elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Carriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Boat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_CowCarriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Raft or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_FishingBoat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_SailingBoat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_RepairableCarriage then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_REPAIR_ACK"))
  end
  PaGlobalFunc_StableList_Update()
end
function FromClient_StableList_ServantChangeName(servantNo)
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_CHANGENAME_ACK"))
end
function FromClient_StableList_ServantRegisterAuction(servantNo)
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_REGISTMARKET_ACK"))
  PaGlobalFunc_StableFunction_List()
end
function FromClient_StableList_ServantCancelAuction(servantNo)
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_REGISTMARKETCANCEL_ACK"))
end
function FromClient_StableList_ServantReceiveAuction(servantNo)
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_GETREGISTMARKET_ACK"))
end
function FromClient_StableList_ServantBuyMarket(servantNo)
  if nil == doRemove then
    return
  end
  if doRemove then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SELL_SERVANT_ACK"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_MARKETBUY_ACK"))
  end
end
function FromClient_StableList_ServantStartMating(servantNo)
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_MATINGSTART_ACK"))
end
function FromClient_StableList_ServantChildMating(servantNo)
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_GETCOLT_ACK"))
end
function FromClien_StableList_ServantEndMating(servantNo)
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_CONDITION_MATINGCOMPLETEDESC"))
end
function FromClient_StableList_ServantClearDeadCount()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_KILLCOUNTRESET_ACK"))
end
function FromClient_StableList_ServantImprint(servantNo, isImprint)
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  if true == isImprint then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_STAMPING_ACK"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_ISIMPRINT_ACK"))
  end
end
function FromClient_StableList_ServantClearMatingCount(servantNo)
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_MATINGCOUNTRESET_ACK"))
end
function FromClient_StableList_StableList_ServantLink(horseNo, carriageNo, isLinkSuccess)
  PaGlobalFunc_StableList_Update()
  local horseInfo = stable_getServantByServantNo(horseNo)
  local carriageInfo = stable_getServantByServantNo(carriageNo)
  if isLinkSuccess then
    if nil == horseInfo or nil == carriageInfo then
      return
    end
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_LINK_XBOX"))
  else
    if nil == horseInfo then
      return
    end
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_UNLINK", "horseName", stable_getServantByServantNo(horseNo):getName()))
  end
end
function FromClient_StableList_ServantStartSkillTraining(servantNo)
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TRAINSTART", "servantName", servantInfo:getName()))
  PaGlobalFunc_StableInfo_Exit()
  PaGlobalFunc_StableChangeSkill_Close()
end
function FromClient_StableList_ServantEndSkillTraining(servantNo)
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TRAINEND", "servantName", servantInfo:getName()))
end
function FromClient_StableList_StartStallionSkillTraining(servantNo)
  if not isContentsStallionEnable and not isContentsNineTierEnable then
    return
  end
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  PaGlobalFunc_StableList_Update()
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TRAINSTART", "servantName", servantInfo:getName()))
end
function FromClient_StableList_EndStallionSkillTraining(servantNo)
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  PaGlobalFunc_StableList_Update()
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TRAINEND", "servantName", servantInfo:getName()))
end
function FromClient_StableList_IncreaseStallionSkillExpAck(servantNo, skillKey, skillExp)
end
function FromClient_StableList_ChangeServantRegion_HandleUpdate()
  local self = Panel_Window_StableList_info
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "LUA_SERVANT_CHANGE_REGION_ACK_DESC"))
  PaGlobalFunc_StableList_Update()
  PaGlobalFunc_WharfList_Update()
end
function UIScroll_Horizontal_SetButtonSize(scroll, configSlotCount, contentsCount)
  if configSlotCount < contentsCount then
    local size = configSlotCount / contentsCount
    local sizeResult = scroll:GetSizeX() * size
    if sizeResult < 50 then
      sizeResult = 50
    end
    scroll:GetControlButton():SetSize(sizeResult, scroll:GetControlButton():GetSizeY())
    scroll:SetShow(true)
  else
    scroll:SetShow(false)
  end
end
function UIScroll_Horizontal_ScrollEvent(scroll, isScrollUp, row, contentsCount, startSlot, column)
  if contentsCount <= row * column then
    return 0
  end
  local returnStartSlot = startSlot
  local maxStartSlotCount = (contentsCount - row * column) / row
  local slotSize = 1 / maxStartSlotCount
  if nil ~= isScrollUp then
    returnStartSlot = UIScroll.ScrollPosition(isScrollUp, column, contentsCount, startSlot, row)
  else
    local currentScrollPos = scroll:GetControlPos()
    local starSlotIndexString = string.format("%.0f", currentScrollPos / slotSize)
    returnStartSlot = tonumber(starSlotIndexString) * row
  end
  scroll:SetControlPos(slotSize * returnStartSlot / row)
  return returnStartSlot
end
function UIScroll_Horizontal_MoveRightEvent(isRight, row, contentsCount, startSlot, column, scrollCount)
  if contentsCount <= row * column then
    return 0
  end
  if nil == scrollCount then
    scrollCount = 1
  end
  local returnStartSlot = startSlot
  local maxStartSlotCount = (contentsCount - row * column) / row
  local slotSize = 1 / maxStartSlotCount
  if true == isRight then
    returnStartSlot = returnStartSlot + scrollCount
  else
    returnStartSlot = returnStartSlot - scrollCount
  end
  if maxStartSlotCount < returnStartSlot then
    returnStartSlot = maxStartSlotCount
  end
  if returnStartSlot < 0 then
    returnStartSlot = 0
  end
  return returnStartSlot
end
