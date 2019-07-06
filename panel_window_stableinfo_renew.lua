local Panel_Window_StableInfo_info = {
  _ui = {
    static_TabBg = nil,
    staticText_LeftMatingTimeTitle = nil,
    staticText_LeftMatingTimeValue = nil,
    static_TopBg = nil,
    static_Image = nil,
    staticText_Tier = nil,
    static_SexIcon = nil,
    staticText_Name = nil,
    staticText_Level = nil,
    staticText_Location = nil,
    staticText_Weight = nil,
    staticText_Swift = nil,
    static_InfoBg = nil,
    staticText_HPVal = nil,
    progress2_HP = nil,
    staticText_SP = nil,
    staticText_SPVal = nil,
    progress2_SP = nil,
    staticText_EXP = nil,
    staticText_EXPVal = nil,
    static_EXP_BG = nil,
    progress2_EXP = nil,
    staticText_SpeedVal = nil,
    staticText_Dead = nil,
    staticText_DeadVal = nil,
    staticText_AccVal = nil,
    staticText_Life = nil,
    staticText_LifeVal = nil,
    staticText_RotateVal = nil,
    staticText_Stamping = nil,
    staticText_StampingVal = nil,
    staticText_BreakVal = nil,
    staticText_MatingVal = nil,
    staticText_Desc = nil,
    staticText_Desc2 = nil,
    staticText_DescValue = nil,
    staticText_DescValue1 = nil,
    equipSlot = {},
    equipOverfitSlot = {}
  },
  _value = {
    lastEquipIndex = 0,
    currentEquipIndex = 0,
    lastOverfitIndex = 0,
    currentOverfitIndex = 0,
    currnetInfoType = 0,
    selectSceneIndex = -1
  },
  _enum = {eTYPE_SEALED = 0, eTYPE_UNSEALED = 1},
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
  _progressTexture = {
    path = "renewal/Progress/console_Progressbar_01.dds",
    blue = {
      420,
      324,
      456,
      330
    },
    yellow = {
      467,
      278,
      503,
      284
    }
  },
  _equipSlotNo = {
    [1] = 3,
    [2] = 4,
    [3] = 5,
    [4] = 6,
    [5] = 12,
    [6] = 13,
    [7] = 25
  },
  _equipSlotTextureHorse = {
    ["path"] = "renewal/ui_icon/console_icon_equip.dds",
    [3] = {
      259,
      87,
      301,
      129
    },
    [4] = {
      259,
      44,
      301,
      86
    },
    [5] = {
      259,
      173,
      301,
      215
    },
    [6] = {
      259,
      130,
      301,
      172
    }
  },
  _equipSlotTextureCarrage = {
    ["path"] = "renewal/ui_icon/console_icon_equip.dds",
    [3] = {
      173,
      216,
      215,
      258
    },
    [4] = {
      173,
      173,
      215,
      215
    },
    [5] = {
      130,
      302,
      172,
      344
    },
    [6] = {
      87,
      302,
      129,
      344
    }
  },
  _equipOverfitSlotNo = {
    [1] = 14,
    [2] = 15,
    [3] = 16,
    [4] = 17,
    [5] = 26
  },
  _equipOverfitSlotTextureHorse = {
    ["path"] = "renewal/ui_icon/console_icon_equip.dds",
    [14] = {
      302,
      87,
      344,
      129
    },
    [15] = {
      302,
      44,
      344,
      86
    },
    [16] = {
      302,
      173,
      344,
      215
    },
    [17] = {
      302,
      130,
      344,
      172
    }
  },
  _equipOverfitSlotTextureCarrage = {
    ["path"] = "renewal/ui_icon/console_icon_equip.dds",
    [14] = {
      216,
      216,
      258,
      258
    },
    [15] = {
      216,
      173,
      258,
      215
    },
    [16] = {
      130,
      345,
      172,
      387
    },
    [17] = {
      87,
      345,
      129,
      387
    }
  },
  _config = {
    equipCheckFlag = {
      [3] = 1,
      [4] = 2,
      [5] = 4,
      [6] = 8,
      [14] = 16,
      [15] = 32,
      [16] = 64,
      [17] = 128
    },
    itemSlot = {
      createIcon = true,
      createBorder = true,
      createCount = true,
      createEnchant = true,
      createCash = true,
      createEnduranceIcon = true
    }
  }
}
local isContentsEnable = ToClient_IsContentsGroupOpen("61")
local isContentsStallionEnable = ToClient_IsContentsGroupOpen("243")
local isContentsNineTierEnable = ToClient_IsContentsGroupOpen("80")
function Panel_Window_StableInfo_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_StableInfo_Resize")
end
function Panel_Window_StableInfo_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
end
function Panel_Window_StableInfo_info:initValue()
  self._value.lastEquipIndex = 0
  self._value.currentEquipIndex = 0
  self._value.lastOverfitIndex = 0
  self._value.currentOverfitIndex = 0
  self._value.selectSceneIndex = -1
  self._value.currnetInfoType = self._enum.eTYPE_SEALED
end
function Panel_Window_StableInfo_info:resize()
  Panel_Window_StableInfo:ComputePos()
end
function Panel_Window_StableInfo_info:childControl()
  self._ui.static_TabBg = UI.getChildControl(Panel_Window_StableInfo, "Static_TabBg")
  self._ui.staticText_LeftMatingTimeTitle = UI.getChildControl(self._ui.static_TabBg, "StaticText_LeftMatingTimeTitle")
  self._ui.staticText_LeftMatingTimeValue = UI.getChildControl(self._ui.static_TabBg, "StaticText_LeftMatingTimeValue")
  self._ui.static_TopBg = UI.getChildControl(Panel_Window_StableInfo, "Static_TopBg")
  self._ui.staticText_Tier = UI.getChildControl(self._ui.static_TopBg, "StaticText_Tier")
  self._ui.static_Image = UI.getChildControl(self._ui.static_TopBg, "Static_Image")
  self._ui.static_SexIcon = UI.getChildControl(self._ui.static_TopBg, "Static_SexIcon")
  self._ui.staticText_Name = UI.getChildControl(self._ui.static_TopBg, "StaticText_Name")
  self._ui.staticText_Level = UI.getChildControl(self._ui.static_TopBg, "StaticText_Level")
  self._ui.staticText_Location = UI.getChildControl(self._ui.static_TopBg, "StaticText_Location")
  self._ui.staticText_Swift = UI.getChildControl(self._ui.static_TopBg, "StaticText_Swift")
  self._ui.static_InfoBg = UI.getChildControl(Panel_Window_StableInfo, "Static_InfoBg")
  self._ui.staticText_HPVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_HPVal")
  self._ui.progress2_HP = UI.getChildControl(self._ui.static_InfoBg, "Progress2_HP")
  self._ui.staticText_SP = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SP")
  self._ui.staticText_SPVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SPVal")
  self._ui.progress2_SP = UI.getChildControl(self._ui.static_InfoBg, "Progress2_SP")
  self._ui.staticText_EXP = UI.getChildControl(self._ui.static_InfoBg, "StaticText_EXP")
  self._ui.staticText_EXPVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_EXPVal")
  self._ui.static_EXP_BG = UI.getChildControl(self._ui.static_InfoBg, "Static_EXP_BG")
  self._ui.progress2_EXP = UI.getChildControl(self._ui.static_InfoBg, "Progress2_EXP")
  self._ui.staticText_Weight = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Weight")
  self._ui.staticText_SpeedVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SpeedVal")
  self._ui.staticText_Dead = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Dead")
  self._ui.staticText_DeadVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_DeadVal")
  self._ui.staticText_AccVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_AccVal")
  self._ui.staticText_Life = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Life")
  self._ui.staticText_LifeVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_LifeVal")
  self._ui.staticText_RotateVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_RotateVal")
  self._ui.staticText_Stamping = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Stamping")
  self._ui.staticText_StampingVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_StampingVal")
  self._ui.staticText_BreakVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_BreakVal")
  self._ui.staticText_Mating = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Mating")
  self._ui.staticText_MatingVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_MatingVal")
  self._ui.staticText_Desc = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Desc")
  self._ui.staticText_Desc2 = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Desc2")
  self._ui.staticText_DescValue = UI.getChildControl(self._ui.static_InfoBg, "StaticText_DescValue1")
  self._ui.staticText_DescValue1 = UI.getChildControl(self._ui.static_InfoBg, "StaticText_DescValue2")
  self._ui.static_Line2 = UI.getChildControl(Panel_Window_StableInfo, "Static_Line2")
  for key, value in pairs(self._equipSlotNo) do
    local slot = {}
    slot.control = UI.getChildControl(self._ui.static_InfoBg, "Static_Equip" .. key)
    slot.check = UI.getChildControl(slot.control, "CheckButton_EquipWear" .. key)
    slot.iconBG = UI.getChildControl(slot.control, "Static_Icon_Slot" .. key)
    SlotItem.new(slot, "ServantInfoEquipment_" .. key, value, slot.control, self._config.itemSlot)
    slot:createChild()
    slot:clearItem()
    slot.control:SetChildOrder(slot.icon:GetKey(), slot.check:GetKey())
    Panel_Tooltip_Item_SetPosition(value, slot, "ServantEquipment")
    self._ui.equipSlot[value] = slot
  end
  for key, value in pairs(self._equipOverfitSlotNo) do
    local slot = {}
    slot.control = UI.getChildControl(self._ui.static_InfoBg, "Static_Outfit" .. key)
    slot.check = UI.getChildControl(slot.control, "CheckButton_OutfitWear" .. key)
    slot.iconBG = UI.getChildControl(slot.control, "Static_Icon_OutfitSlot" .. key)
    SlotItem.new(slot, "ServantInfoOverfit_" .. key, value, slot.control, self._config.itemSlot)
    slot:createChild()
    slot:clearItem()
    slot.control:SetChildOrder(slot.icon:GetKey(), slot.check:GetKey())
    Panel_Tooltip_Item_SetPosition(value, slot, "ServantEquipment")
    self._ui.equipOverfitSlot[value] = slot
  end
end
function Panel_Window_StableInfo_info:setContent(unsealType)
  local servantInfo
  if 0 == unsealType then
    servantInfo = stable_getServant(PaGlobalFunc_StableList_SelectSlotNo())
    PaGlobalFunc_StableInfo_Menu_Show(Panel_Window_StableInfo, unsealType, PaGlobalFunc_StableList_SelectSlotNo())
  elseif 1 == unsealType then
    local temporaryWrapper = getTemporaryInformationWrapper()
    if nil == temporaryWrapper then
      return
    end
    servantInfo = temporaryWrapper:getUnsealVehicle(stable_getServantType())
    PaGlobalFunc_StableInfo_Menu_Show(Panel_Window_StableInfo, unsealType)
  else
    if 2 == unsealType then
    else
    end
  end
  if nil == servantInfo then
    return
  end
  self._value.selectSceneIndex = Servant_ScenePushObject(servantInfo, self._value.selectSceneIndex)
  if nil ~= servantInfo:getActionIndex() then
    showSceneCharacter(self._value.selectSceneIndex, false)
    showSceneCharacter(self._value.selectSceneIndex, true, servantInfo:getActionIndex())
  end
  local vehicleType = servantInfo:getVehicleType()
  if vehicleType ~= CppEnums.VehicleType.Type_Horse then
    self._ui.staticText_LeftMatingTimeTitle:SetShow(false)
    self._ui.staticText_LeftMatingTimeValue:SetShow(false)
    self._ui.static_Line2:SetShow(true)
    self._ui.staticText_Swift:SetShow(false)
    self._ui.static_SexIcon:SetShow(false)
  else
    if servantInfo:doMating() and 9 ~= servantInfo:getTier() and CppEnums.ServantStateType.Type_Mating == servantInfo:getStateType() then
      self._ui.staticText_LeftMatingTimeValue:SetText(convertStringFromDatetime(servantInfo:getMatingTime()))
      self._ui.staticText_LeftMatingTimeTitle:SetShow(true)
      self._ui.staticText_LeftMatingTimeValue:SetShow(true)
      self._ui.static_Line2:SetShow(false)
    else
      self._ui.staticText_LeftMatingTimeTitle:SetShow(false)
      self._ui.staticText_LeftMatingTimeValue:SetShow(false)
      self._ui.static_Line2:SetShow(true)
    end
    self._ui.staticText_Swift:SetShow(true)
    self._ui.static_SexIcon:SetShow(true)
    if servantInfo:isMale() then
      self._ui.static_SexIcon:ChangeTextureInfoName(self._texture.sexIcon)
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_SexIcon, self._texture.male.x1, self._texture.male.y1, self._texture.male.x2, self._texture.male.y2)
      self._ui.static_SexIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.static_SexIcon:setRenderTexture(self._ui.static_SexIcon:getBaseTexture())
    else
      self._ui.static_SexIcon:ChangeTextureInfoName(self._texture.sexIcon)
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_SexIcon, self._texture.female.x1, self._texture.female.y1, self._texture.female.x2, self._texture.female.y2)
      self._ui.static_SexIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.static_SexIcon:setRenderTexture(self._ui.static_SexIcon:getBaseTexture())
    end
  end
  if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse and 9 ~= servantInfo:getTier() and false == servantInfo:isPcroomOnly() and isContentsStallionEnable then
    self._ui.staticText_Swift:SetShow(true)
    local isStallion = servantInfo:isStallion()
    if true == isStallion then
      self._ui.staticText_Swift:SetMonoTone(false)
    else
      self._ui.staticText_Swift:SetMonoTone(true)
    end
  else
    self._ui.staticText_Swift:SetShow(false)
  end
  local isCarriage = false
  if vehicleType == CppEnums.VehicleType.Type_Carriage or vehicleType == CppEnums.VehicleType.Type_CowCarriage or vehicleType == CppEnums.VehicleType.Type_Train or vehicleType == CppEnums.VehicleType.Type_RepairableCarriage then
    isCarriage = true
  end
  if true == isCarriage then
    self._ui.staticText_SP:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_INFO_LIFECOUNT"))
    self._ui.progress2_SP:ChangeTextureInfoName(self._progressTexture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.progress2_SP, self._progressTexture.yellow[1], self._progressTexture.yellow[2], self._progressTexture.yellow[3], self._progressTexture.yellow[4])
    self._ui.progress2_SP:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.progress2_SP:setRenderTexture(self._ui.progress2_SP:getBaseTexture())
    self._ui.staticText_EXP:SetShow(false)
    self._ui.staticText_EXPVal:SetShow(false)
    self._ui.static_EXP_BG:SetShow(false)
    self._ui.progress2_EXP:SetShow(false)
    self._ui.staticText_Stamping:SetShow(false)
    self._ui.staticText_StampingVal:SetShow(false)
    self._ui.staticText_LifeVal:SetShow(false)
    self._ui.staticText_Life:SetShow(false)
  else
    self._ui.staticText_SP:SetText(PAGetString(Defines.StringSheet_RESOURCE, "SERVANT_INFO_TEXT_STAMINA"))
    self._ui.progress2_SP:ChangeTextureInfoName(self._progressTexture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.progress2_SP, self._progressTexture.blue[1], self._progressTexture.blue[2], self._progressTexture.blue[3], self._progressTexture.blue[4])
    self._ui.progress2_SP:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.progress2_SP:setRenderTexture(self._ui.progress2_SP:getBaseTexture())
    self._ui.staticText_EXP:SetShow(true)
    self._ui.staticText_EXPVal:SetShow(true)
    self._ui.static_EXP_BG:SetShow(true)
    self._ui.progress2_EXP:SetShow(true)
    if servantInfo:isImprint() then
      self._ui.staticText_Stamping:SetShow(true)
      self._ui.staticText_StampingVal:SetShow(true)
      self._ui.staticText_StampingVal:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_ISIMPRINTING"))
    else
      self._ui.staticText_Stamping:SetShow(true)
      self._ui.staticText_StampingVal:SetShow(true)
      self._ui.staticText_StampingVal:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_ISIMPRINTPOSSIBLE"))
    end
    self._ui.staticText_LifeVal:SetShow(true)
    self._ui.staticText_Life:SetShow(true)
  end
  self._ui.staticText_Name:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.staticText_Name:SetText(servantInfo:getName())
  self._ui.staticText_Level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(servantInfo:getLevel()))
  self._ui.staticText_Weight:SetText(makeDotMoney(servantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000) .. "LT")
  self._ui.static_Image:SetShow(true)
  self._ui.static_Image:ChangeTextureInfoName(servantInfo:getIconPath1())
  self._ui.staticText_Location:SetText(servantInfo:getRegionName())
  self._ui.staticText_Location:SetPosY(self._ui.staticText_Name:GetPosY() + self._ui.staticText_Name:GetTextSizeY() + 5)
  self._ui.staticText_HPVal:SetText(makeDotMoney(servantInfo:getHp()) .. " / " .. makeDotMoney(servantInfo:getMaxHp()))
  self._ui.progress2_HP:SetProgressRate(servantInfo:getHp() * 100 / servantInfo:getMaxHp())
  self._ui.staticText_SPVal:SetText(makeDotMoney(servantInfo:getMp()) .. " / " .. makeDotMoney(servantInfo:getMaxMp()))
  self._ui.progress2_SP:SetProgressRate(servantInfo:getMp() * 100 / servantInfo:getMaxMp())
  self._ui.staticText_EXPVal:SetText(makeDotMoney(servantInfo:getExp_s64()) .. " / " .. makeDotMoney(servantInfo:getNeedExp_s64()))
  local expRate = Int64toInt32(servantInfo:getExp_s64() * 100 / servantInfo:getNeedExp_s64())
  self._ui.progress2_EXP:SetProgressRate(expRate)
  if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
    self._ui.staticText_Tier:SetShow(true)
    if 9 == servantInfo:getTier() then
      self._ui.staticText_Tier:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9"))
    else
      self._ui.staticText_Tier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", servantInfo:getTier()))
    end
  else
    self._ui.staticText_Tier:SetShow(false)
  end
  self._ui.staticText_SpeedVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
  self._ui.staticText_AccVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
  self._ui.staticText_RotateVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
  self._ui.staticText_BreakVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
  if servantInfo:isPeriodLimit() then
    self._ui.staticText_LifeVal:SetText(convertStringFromDatetime(servantInfo:getExpiredTime()))
  else
    self._ui.staticText_LifeVal:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFEVALUE"))
  end
  local descText = ""
  local descText2 = ""
  local descValue = ""
  local descValue2 = ""
  if servantInfo:doMating() and 9 ~= servantInfo:getTier() then
    local matingCount = servantInfo:getMatingCount()
    descText = "" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_INFO_MATINGCOUNT")
    if servantInfo:doClearCountByMating() then
      descValue = "<PAColor0xffeeeeee>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RESET_POSSIBLE") .. "<PAOldColor>"
    else
      descValue = "<PAColor0xffeeeeee>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RESET_IMPOSSIBLE") .. "<PAOldColor>"
    end
    self._ui.staticText_Mating:SetShow(true)
    self._ui.staticText_MatingVal:SetShow(true)
    self._ui.staticText_MatingVal:SetText(matingCount)
  else
    self._ui.staticText_Mating:SetShow(false)
    self._ui.staticText_MatingVal:SetShow(false)
  end
  local deadCount = servantInfo:getDeadCount()
  if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Camel or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Donkey or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant then
    self._ui.staticText_Dead:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_KILLCOUNT"))
    descText2 = descText2 .. PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_KILLCOUNT")
  elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Carriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_CowCarriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_RepairableCarriage then
    self._ui.staticText_Dead:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_DESTROYCOUNT"))
    descText2 = descText2 .. PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_DESTROYCOUNT")
  elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Boat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Raft or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_FishingBoat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_SailingBoat then
    self._ui.staticText_Dead:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_DESTROYCOUNT"))
    descText2 = descText2 .. PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_DESTROYCOUNT")
  end
  self._ui.staticText_DeadVal:SetText(deadCount)
  if servantInfo:doClearCountByDead() then
    descValue2 = "<PAColor0xffeeeeee>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RESET_POSSIBLE") .. "<PAOldColor>"
  else
    descValue2 = "<PAColor0xffeeeeee>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RESET_IMPOSSIBLE") .. "<PAOldColor>"
  end
  if "" == descText then
    self._ui.staticText_Desc:SetShow(false)
  else
    self._ui.staticText_Desc:SetShow(true)
    self._ui.staticText_Desc:SetText(descText)
  end
  if "" == descText2 then
    self._ui.staticText_Desc2:SetShow(false)
  else
    self._ui.staticText_Desc2:SetShow(true)
    self._ui.staticText_Desc2:SetText(descText2)
  end
  if "" == descValue then
    self._ui.staticText_DescValue:SetShow(false)
  else
    self._ui.staticText_DescValue:SetShow(true)
    self._ui.staticText_DescValue:SetText(descValue)
  end
  if "" == descValue2 then
    self._ui.staticText_DescValue1:SetShow(false)
  else
    self._ui.staticText_DescValue1:SetShow(true)
    self._ui.staticText_DescValue1:SetText(descValue2)
  end
end
function Panel_Window_StableInfo_info:setEquipment()
  local servantWrapper
  if self._value.currnetInfoType == self._enum.eTYPE_SEALED then
    servantWrapper = stable_getServant(PaGlobalFunc_StableList_SelectSlotNo())
  elseif self._value.currnetInfoType == self._enum.eTYPE_UNSEALED then
    local temporaryWrapper = getTemporaryInformationWrapper()
    if nil == temporaryWrapper then
      return
    end
    servantWrapper = temporaryWrapper:getUnsealVehicle(stable_getServantType())
  end
  local isVehicleType = servantWrapper:getVehicleType()
  if CppEnums.VehicleType.Type_Elephant == isVehicleType or CppEnums.VehicleType.Type_Horse ~= isVehicleType then
    for key, value in pairs(self._equipSlotNo) do
      self._ui.equipSlot[value].check:SetShow(false)
    end
    for key, value in pairs(self._equipOverfitSlotNo) do
      self._ui.equipOverfitSlot[value].check:SetShow(false)
    end
  else
    for key, value in pairs(self._equipSlotNo) do
      if nil == self._config.equipCheckFlag[value] then
        self._ui.equipSlot[value].check:SetShow(false)
      else
        self._ui.equipSlot[value].check:SetShow(true)
      end
    end
    for key, value in pairs(self._equipOverfitSlotNo) do
      if nil == self._config.equipCheckFlag[value] then
        self._ui.equipOverfitSlot[value].check:SetShow(false)
      else
        self._ui.equipOverfitSlot[value].check:SetShow(true)
      end
    end
  end
  if nil ~= servantWrapper then
    for key, value in pairs(self._equipSlotNo) do
      isCheck = ToClient_IsSetVehicleEquipSlotFlag(servantWrapper:getVehicleType(), self._config.equipCheckFlag[value])
      self._ui.equipSlot[value].check:SetCheck(not isCheck)
    end
    for key, value in pairs(self._equipOverfitSlotNo) do
      isCheck = ToClient_IsSetVehicleEquipSlotFlag(servantWrapper:getVehicleType(), self._config.equipCheckFlag[value])
      self._ui.equipOverfitSlot[value].check:SetCheck(not isCheck)
    end
  end
  local isHoresEquip = true
  if CppEnums.VehicleType.Type_Horse == isVehicleType or CppEnums.VehicleType.Type_Camel == isVehicleType or CppEnums.VehicleType.Type_Donkey == isVehicleType or CppEnums.VehicleType.Type_Elephant == isVehicleType then
    self._ui.equipSlot[3].control:SetShow(true)
    self._ui.equipSlot[12].control:SetShow(true)
    self._ui.equipSlot[13].control:SetShow(false)
    self._ui.equipSlot[25].control:SetShow(false)
    self._ui.equipOverfitSlot[26].control:SetShow(false)
    self._ui.equipOverfitSlot[16].control:SetShow(true)
    self._ui.equipOverfitSlot[17].control:SetShow(true)
  elseif CppEnums.VehicleType.Type_Carriage == isVehicleType or CppEnums.VehicleType.Type_CowCarriage == isVehicleType or CppEnums.VehicleType.Type_RepairableCarriage == isVehicleType then
    isHoresEquip = false
    self._ui.equipSlot[3].control:SetShow(false)
    self._ui.equipSlot[12].control:SetShow(false)
    self._ui.equipSlot[13].control:SetShow(true)
    self._ui.equipSlot[25].control:SetShow(true)
    self._ui.equipOverfitSlot[26].control:SetShow(true)
    self._ui.equipOverfitSlot[16].control:SetShow(false)
    self._ui.equipOverfitSlot[17].control:SetShow(false)
  end
  for key, value in pairs(self._equipSlotNo) do
    local slot = self._ui.equipSlot[value]
    local itemWrapper = servantWrapper:getEquipItem(value)
    if nil ~= itemWrapper then
      slot.iconBG:SetShow(false)
      slot:setItem(itemWrapper)
    else
      slot.iconBG:SetShow(true)
      slot:clearItem()
      if true == isHoresEquip then
        if nil ~= self._equipSlotTextureHorse[value] then
          slot.iconBG:ChangeTextureInfoName(self._equipSlotTextureHorse.path)
          local x1, y1, x2, y2 = setTextureUV_Func(slot.iconBG, self._equipSlotTextureHorse[value][1], self._equipSlotTextureHorse[value][2], self._equipSlotTextureHorse[value][3], self._equipSlotTextureHorse[value][4])
          slot.iconBG:getBaseTexture():setUV(x1, y1, x2, y2)
          slot.iconBG:setRenderTexture(slot.iconBG:getBaseTexture())
        end
      elseif nil ~= self._equipSlotTextureCarrage[value] then
        slot.iconBG:ChangeTextureInfoName(self._equipSlotTextureCarrage.path)
        local x1, y1, x2, y2 = setTextureUV_Func(slot.iconBG, self._equipSlotTextureCarrage[value][1], self._equipSlotTextureCarrage[value][2], self._equipSlotTextureCarrage[value][3], self._equipSlotTextureCarrage[value][4])
        slot.iconBG:getBaseTexture():setUV(x1, y1, x2, y2)
        slot.iconBG:setRenderTexture(slot.iconBG:getBaseTexture())
      end
    end
  end
  for key, value in pairs(self._equipOverfitSlotNo) do
    local slot = self._ui.equipOverfitSlot[value]
    local itemWrapper = servantWrapper:getEquipItem(value)
    if nil ~= itemWrapper then
      slot.iconBG:SetShow(false)
      slot:setItem(itemWrapper)
    else
      slot.iconBG:SetShow(true)
      slot:clearItem()
      if true == isHoresEquip then
        if nil ~= self._equipOverfitSlotTextureHorse[value] then
          slot.iconBG:ChangeTextureInfoName(self._equipOverfitSlotTextureHorse.path)
          local x1, y1, x2, y2 = setTextureUV_Func(slot.iconBG, self._equipOverfitSlotTextureHorse[value][1], self._equipOverfitSlotTextureHorse[value][2], self._equipOverfitSlotTextureHorse[value][3], self._equipOverfitSlotTextureHorse[value][4])
          slot.iconBG:getBaseTexture():setUV(x1, y1, x2, y2)
          slot.iconBG:setRenderTexture(slot.iconBG:getBaseTexture())
        end
      elseif nil ~= self._equipOverfitSlotTextureCarrage[value] then
        slot.iconBG:ChangeTextureInfoName(self._equipOverfitSlotTextureCarrage.path)
        local x1, y1, x2, y2 = setTextureUV_Func(slot.iconBG, self._equipOverfitSlotTextureCarrage[value][1], self._equipOverfitSlotTextureCarrage[value][2], self._equipOverfitSlotTextureCarrage[value][3], self._equipOverfitSlotTextureCarrage[value][4])
        slot.iconBG:getBaseTexture():setUV(x1, y1, x2, y2)
        slot.iconBG:setRenderTexture(slot.iconBG:getBaseTexture())
      end
    end
  end
end
function Panel_Window_StableInfo_info:open()
  Panel_Window_StableInfo:SetShow(true)
end
function Panel_Window_StableInfo_info:close()
  Panel_Window_StableInfo:SetShow(false)
end
function PaGlobalFunc_StableInfo_GetShow()
  return Panel_Window_StableInfo:GetShow()
end
function PaGlobalFunc_StableInfo_Open()
  local self = Panel_Window_StableInfo_info
  self:open()
end
function PaGlobalFunc_StableInfo_Close()
  local self = Panel_Window_StableInfo_info
  self:close()
end
function PaGlobalFunc_StableInfo_Show(eType)
  local self = Panel_Window_StableInfo_info
  if nil == eType then
    eType = self._enum.eTYPE_SEALED
  end
  PaGlobalFunc_StableInfo_Menu_Close()
  Servant_ScenePopObject(self._value.selectSceneIndex)
  self:initValue()
  self._value.currnetInfoType = eType
  self:setContent(self._value.currnetInfoType)
  self:setEquipment()
  self:open()
end
function PaGlobalFunc_StableInfo_CloseWith()
  local self = Panel_Window_StableInfo_info
  self:close()
  Servant_ScenePopObject(self._value.selectSceneIndex)
  PaGlobalFunc_StableInfo_Menu_Close()
end
function PaGlobalFunc_StableInfo_Exit()
  PaGlobalFunc_StableInfo_CloseWith()
  PaGlobalFunc_StableList_UnClickList()
  PaGlobalFunc_StableList_Open()
end
function PaGlobalFunc_StableInfo_Update()
  local self = Panel_Window_StableInfo_info
  if not PaGlobalFunc_StableInfo_GetShow() then
    return
  end
  self:setContent(self._value.currnetInfoType)
  self:setEquipment()
end
function PaGlobalFunc_StableInfo_CharacterSceneResetServantNo(servantNo)
  local self = Panel_Window_StableInfo_info
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  self._value.selectSceneIndex = Servant_ScenePushObject(servantInfo, self._value.selectSceneIndex)
  if nil ~= servantInfo:getActionIndex() then
    showSceneCharacter(self._value.selectSceneIndex, false)
    showSceneCharacter(self._value.selectSceneIndex, true, servantInfo:getActionIndex())
  end
end
function FromClient_StableInfo_Init()
  local self = Panel_Window_StableInfo_info
  self:initialize()
end
function FromClient_StableInfo_Resize()
  local self = Panel_Window_StableInfo_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_StableInfo_Init")
