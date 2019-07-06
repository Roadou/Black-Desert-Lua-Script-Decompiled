local Panel_Window_StableInfo_Menu_info = {
  _ui = {
    radioButton_Template = nil,
    static_A_ConsoleUI = nil,
    buttonList = {}
  },
  _value = {
    currentButtonCount = 0,
    lastSelectButtonIndex = 0,
    currentSelectButtonIndex = 0,
    selectedServantSlotNo = nil
  },
  _pos = {
    startPosX = 0,
    startPosY = 10,
    buttonSizeY = 0,
    buttonSpaceY = 0,
    buttonSpaceX = 5
  },
  _config = {maxButtonCount = 16},
  _enum = {eTYPE_SEALED = 0, eTYPE_UNSEALED = 1},
  _string = {
    unseal = nil,
    recovery = nil,
    releaseToCarriage = nil,
    repair = nil,
    getHorse = nil,
    marketRegister = nil,
    matingRegister = nil,
    changeName = nil,
    killCountReset = nil,
    destroyCountReset = nil,
    clearMatingCount = nil,
    stamping = nil,
    lookChange = nil,
    stallionTraining = nil,
    supply = nil,
    release = nil,
    sell = nil,
    trainFinish = nil,
    move = nil,
    skillChange = nil,
    mateImmediately = nil,
    showBreedingMarket = nil,
    seal = nil,
    remote = nil
  },
  _enumButtonType = {
    eNONE = 0,
    eUNSEAL = 1,
    eRECOVERY = 2,
    eRELEASE_TO_CARRIGAGE = 3,
    eREPAIR = 4,
    eGET_HORSE = 5,
    eMARKET_REGISTER = 6,
    eMATING_REGISTER = 7,
    eCHANGE_NAME = 8,
    eDEAD_RESET = 9,
    eCLEAR_MATING_COUNT = 10,
    eSTAMPING = 11,
    eLOOK_CHANGE = 12,
    eSTALLION_TRAINING = 13,
    eSUPPLY = 14,
    eRELEASE = 15,
    eSELL = 16,
    eTRAINFINISH = 17,
    eMOVE = 18,
    eSTALLION_TRAINFINISH = 19,
    eSKILLCHANGE = 20,
    eMATING_IMMEDIATELY = 21,
    eSHOW_BREEDING_MARKET = 22,
    eSEAL = 31,
    eREMOTE = 32,
    eRECOVERY_UNSEAL = 33,
    eREPAIR_UNSEAL = 34
  },
  _buttonFunc = {
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil,
    [6] = nil,
    [7] = nil,
    [8] = nil,
    [9] = nil,
    [10] = nil,
    [11] = nil,
    [12] = nil,
    [13] = nil,
    [14] = nil,
    [15] = nil,
    [16] = nil,
    [17] = nil,
    [18] = nil,
    [19] = nil,
    [20] = nil,
    [21] = nil,
    [31] = nil,
    [32] = nil,
    [33] = nil,
    [34] = nil
  }
}
local servantInvenAlert = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SELL_WITHITEM_MSG")
local isContentsEnableChangeLook = ToClient_IsContentsGroupOpen("61")
local isContentsEnableSupply = ToClient_IsContentsGroupOpen("42")
local isContentsStallionEnable = ToClient_IsContentsGroupOpen("243")
local isContentsNineTierEnable = ToClient_IsContentsGroupOpen("80")
local stable = CppEnums.ServantStateType.Type_Stable
local nowMating = CppEnums.ServantStateType.Type_Mating
local regMarket = CppEnums.ServantStateType.Type_RegisterMarket
local regMating = CppEnums.ServantStateType.Type_RegisterMating
local training = CppEnums.ServantStateType.Type_SkillTraining
local stallionTraining = CppEnums.ServantStateType.Type_StallionTraining
function Panel_Window_StableInfo_Menu_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_StableInfo_Menu_Resize")
end
function Panel_Window_StableInfo_Menu_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:createControl()
  self:setPosControl()
  self:getStringTable()
  self:linkButtonFunction()
end
function Panel_Window_StableInfo_Menu_info:initValue()
  self._value.selectedServantSlotNo = nil
  self._value.currentButtonCount = 0
  self._value.lastSelectButtonIndex = 0
  self._value.currentSelectButtonIndex = 0
end
function Panel_Window_StableInfo_Menu_info:setServantNo(selectServantNo)
  self._value.selectedServantSlotNo = selectServantNo
end
function Panel_Window_StableInfo_Menu_info:resize()
end
function Panel_Window_StableInfo_Menu_info:childControl()
  self._ui.radioButton_Template = UI.getChildControl(Panel_Window_StableInfo_Menu, "RadioButton_Template")
  self._ui.static_A_ConsoleUI = UI.getChildControl(self._ui.radioButton_Template, "Static_A_ConsoleUI")
  self._ui.radioButton_Template:SetShow(false)
  self._pos.buttonSizeY = self._ui.radioButton_Template:GetSizeY() + 5
end
function Panel_Window_StableInfo_Menu_info:getStringTable()
  self._string.unseal = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_FUNCTION_BTN_UNSEAL")
  self._string.recovery = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_HEAL")
  self._string.releaseToCarriage = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_STABLELIST_RELEASETOCARRIAGE")
  self._string.repair = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_REPAIR")
  self._string.getHorse = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_GETHORSE")
  self._string.marketRegister = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_MARKETREGISTER")
  self._string.matingRegister = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_MATINGREGISTER")
  self._string.changeName = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_CHANGENAME")
  self._string.killCountReset = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_KILLCOUNTRESET")
  self._string.destroyCountReset = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_DESTROYCOUNTRESET")
  self._string.clearMatingCount = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_LIST_INCREASEMATINGCOUNT")
  self._string.stamping = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_LIST_STAMPING")
  self._string.lookChange = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_STABLEFUNCTION_LOOKCHANGE")
  self._string.stallionTraining = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLESTALLION_TRAINING")
  self._string.supply = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_SUPPLY")
  self._string.release = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SELL_NOTIFY_TITLE")
  self._string.sell = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_SELL")
  self._string.trainFinish = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_STABLEFUNCTION_TRAINFINISH")
  self._string.move = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLELIST_BUTTONMOVE")
  self._string.skillChange = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_CHANGESKILL_TITLE")
  self._string.mateImmediately = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_INFO_BTN_MATINGIMMEDIATELY")
  self._string.showBreedingMarket = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLEMATING_TITLE")
  self._string.seal = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_FUNCTION_BTN_SEAL")
  self._string.remote = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_REMOTE")
end
function Panel_Window_StableInfo_Menu_info:linkButtonFunction()
  self._buttonFunc[self._enumButtonType.eUNSEAL] = PaGlobalFunc_StableInfo_Menu_Unseal
  self._buttonFunc[self._enumButtonType.eRECOVERY] = PaGlobalFunc_StableInfo_Menu_Recovery
  self._buttonFunc[self._enumButtonType.eRELEASE_TO_CARRIGAGE] = PaGlobalFunc_StableInfo_Menu_UnLink
  self._buttonFunc[self._enumButtonType.eREPAIR] = PaGlobalFunc_StableInfo_Menu_Recovery
  self._buttonFunc[self._enumButtonType.eGET_HORSE] = PaGlobalFunc_StableInfo_Menu_ReceiveChildServant
  self._buttonFunc[self._enumButtonType.eMARKET_REGISTER] = PaGlobalFunc_StableInfo_Menu_RegisterMarket
  self._buttonFunc[self._enumButtonType.eMATING_REGISTER] = PaGlobalFunc_StableInfo_Menu_RegisterMating
  self._buttonFunc[self._enumButtonType.eCHANGE_NAME] = PaGlobalFunc_StableInfo_Menu_ChangeName
  self._buttonFunc[self._enumButtonType.eDEAD_RESET] = PaGlobalFunc_StableInfo_Menu_ClearDeadCount
  self._buttonFunc[self._enumButtonType.eCLEAR_MATING_COUNT] = PaGlobalFunc_StableInfo_Menu_ClearMatingCount
  self._buttonFunc[self._enumButtonType.eSTAMPING] = PaGlobalFunc_StableInfo_Menu_Stamping
  self._buttonFunc[self._enumButtonType.eLOOK_CHANGE] = PaGlobalFunc_StableInfo_Menu_LookChange
  self._buttonFunc[self._enumButtonType.eSTALLION_TRAINING] = PaGlobalFunc_StableInfo_Menu_StartStallionTraining
  self._buttonFunc[self._enumButtonType.eSUPPLY] = PaGlobalFunc_StableInfo_Menu_Supply
  self._buttonFunc[self._enumButtonType.eRELEASE] = PaGlobalFunc_StableInfo_Menu_Release
  self._buttonFunc[self._enumButtonType.eSELL] = PaGlobalFunc_StableInfo_Menu_SellToNpc
  self._buttonFunc[self._enumButtonType.eTRAINFINISH] = PaGlobalFunc_StableInfo_Menu_TrainFinish
  self._buttonFunc[self._enumButtonType.eMOVE] = PaGlobalFunc_StableInfo_Menu_Move
  self._buttonFunc[self._enumButtonType.eSTALLION_TRAINFINISH] = PaGlobalFunc_StableInfo_Menu_StallionTrainFinish
  self._buttonFunc[self._enumButtonType.eSKILLCHANGE] = PaGlobalFunc_StableInfo_Menu_ChangSKill
  self._buttonFunc[self._enumButtonType.eMATING_IMMEDIATELY] = PaGlobalFunc_StableInfo_Menu_MatingImmediately
  self._buttonFunc[self._enumButtonType.eSHOW_BREEDING_MARKET] = PaGlobalFunc_StableInfo_Menu_SeeBreedingMarket
  self._buttonFunc[self._enumButtonType.eSEAL] = PaGlobalFunc_StableInfo_Menu_Seal
  self._buttonFunc[self._enumButtonType.eREMOTE] = PaGlobalFunc_StableInfo_Menu_RemoteSeal
  self._buttonFunc[self._enumButtonType.eRECOVERY_UNSEAL] = PaGlobalFunc_StableInfo_Menu_RecoveryUnseal
  self._buttonFunc[self._enumButtonType.eREPAIR_UNSEAL] = PaGlobalFunc_StableInfo_Menu_RecoveryUnseal
end
function Panel_Window_StableInfo_Menu_info:createControl()
  for index = 0, self._config.maxButtonCount - 1 do
    local slot = {}
    slot.buttonType = self._enumButtonType.eNONE
    slot.button = UI.createAndCopyBasePropertyControl(Panel_Window_StableInfo_Menu, "RadioButton_Template", Panel_Window_StableInfo_Menu, "radioButton_Template_" .. index)
    slot.static_A = UI.createAndCopyBasePropertyControl(self._ui.radioButton_Template, "Static_A_ConsoleUI", slot.button, "static_A_ConsoleUI_" .. index)
    self._ui.buttonList[index] = slot
  end
end
function Panel_Window_StableInfo_Menu_info:setPosControl()
  for index = 0, self._config.maxButtonCount - 1 do
    self._ui.buttonList[index].button:SetPosY(self._pos.startPosY + index * (self._pos.buttonSizeY + self._pos.buttonSpaceY))
  end
end
function Panel_Window_StableInfo_Menu_info:clearButton()
  self._value.currentButtonCount = 0
  for index = 0, self._config.maxButtonCount - 1 do
    self._ui.buttonList[index].button:SetShow(false)
    self._ui.buttonList[index].button:SetCheck(false)
    self._ui.buttonList[index].static_A:SetShow(false)
    self._ui.buttonList[index].buttonType = self._enumButtonType.eNONE
  end
end
function Panel_Window_StableInfo_Menu_info:readyToOpen(baseCotrol, eType, selectServantNo)
  if nil ~= baseCotrol then
    Panel_Window_StableInfo_Menu:SetPosXY(baseCotrol:GetPosX() + baseCotrol:GetSizeX() + self._pos.buttonSpaceX, baseCotrol:GetPosY())
  end
  self:clearButton()
  if eType == self._enum.eTYPE_SEALED then
    self:setSealedButton(selectServantNo)
  elseif eType == self._enum.eTYPE_UNSEALED then
    self:setUnSealedButton()
  end
  self:setBgSize()
end
function Panel_Window_StableInfo_Menu_info:setButton(buttonType, string, param)
  self._ui.buttonList[self._value.currentButtonCount].button:SetShow(true)
  self._ui.buttonList[self._value.currentButtonCount].button:addInputEvent("Mouse_On", "PaGlobalFunc_StableInfo_Menu_SelectButton(" .. self._value.currentButtonCount .. ")")
  self._ui.buttonList[self._value.currentButtonCount].button:addInputEvent("Mouse_Out", "PaGlobalFunc_StableInfo_Menu_OutFocus(" .. self._value.currentButtonCount .. ")")
  self._ui.buttonList[self._value.currentButtonCount].button:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableInfo_Menu_ClickButton(" .. self._value.currentButtonCount .. ")")
  self._ui.buttonList[self._value.currentButtonCount].button:SetText(string)
  self._ui.buttonList[self._value.currentButtonCount].buttonType = buttonType
  self._value.currentButtonCount = self._value.currentButtonCount + 1
end
function Panel_Window_StableInfo_Menu_info:setSealedButton(selectServantNo)
  local servantInfo = stable_getServant(selectServantNo)
  if nil == servantInfo then
    return
  elseif servantInfo:isChangingRegion() then
    PaGlobalFunc_StableInfo_Menu_Close()
    return
  end
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local regionName = regionInfo:getAreaName()
  local vehicleType = servantInfo:getVehicleType()
  local isLinkedHorse = servantInfo:isLink() and CppEnums.VehicleType.Type_Horse == servantInfo:getVehicleType()
  local servantRegionName = servantInfo:getRegionName(selectServantNo)
  local servantLevel = servantInfo:getLevel()
  local getState = servantInfo:getStateType()
  local isPcroomOnly = servantInfo:isPcroomOnly()
  local showChangeRegionButtonFlag = false
  if isSiegeStable() then
    self:setButton(self._enumButtonType.eUNSEAL, self._string.unseal)
  else
    if regionName == servantRegionName then
      if isLinkedHorse and stallionTraining ~= getState then
        self:setButton(self._enumButtonType.eRELEASE_TO_CARRIGAGE, self._string.releaseToCarriage)
      else
        if CppEnums.VehicleType.Type_Horse == vehicleType or CppEnums.VehicleType.Type_Donkey == vehicleType or CppEnums.VehicleType.Type_Camel == vehicleType or CppEnums.VehicleType.Type_RidableBabyElephant == vehicleType then
          if nowMating ~= getState and regMarket ~= getState and regMating ~= getState and training ~= getState and stallionTraining ~= getState then
            self:setButton(self._enumButtonType.eUNSEAL, self._string.unseal)
            showChangeRegionButtonFlag = not servantInfo:isChangingRegion()
          end
        else
          self:setButton(self._enumButtonType.eUNSEAL, self._string.unseal)
          showChangeRegionButtonFlag = not servantInfo:isChangingRegion()
        end
        if (servantInfo:getHp() < servantInfo:getMaxHp() or servantInfo:getMp() < servantInfo:getMaxMp()) and (CppEnums.VehicleType.Type_Horse == vehicleType or CppEnums.VehicleType.Type_Donkey == vehicleType or CppEnums.VehicleType.Type_Camel == vehicleType or CppEnums.VehicleType.Type_MountainGoat == vehicleType or CppEnums.VehicleType.Type_RidableBabyElephant == vehicleType) and not servantInfo:isMatingComplete() and nowMating ~= getState and regMarket ~= getState and regMating ~= getState and training ~= getState and stallionTraining ~= getState then
          self:setButton(self._enumButtonType.eRECOVERY, self._string.recovery)
        end
        if CppEnums.VehicleType.Type_RepairableCarriage == vehicleType then
          if servantInfo:getHp() < servantInfo:getMaxHp() or servantInfo:getMp() < servantInfo:getMaxMp() then
            self:setButton(self._enumButtonType.eREPAIR, self._string.repair)
          end
        elseif (CppEnums.VehicleType.Type_Carriage == vehicleType or CppEnums.VehicleType.Type_CowCarriage == vehicleType) and servantInfo:getHp() < servantInfo:getMaxHp() and stallionTraining ~= getState then
          self:setButton(self._enumButtonType.eREPAIR, self._string.repair)
        end
        if not servantInfo:isMatingComplete() or stallionTraining == getState or servantInfo:isMale() then
        else
          self:setButton(self._enumButtonType.eGET_HORSE, self._string.getHorse)
        end
        if stable_isMarket() and nowMating ~= getState and regMarket ~= getState and regMating ~= getState and training ~= getState and stallionTraining ~= getState and (CppEnums.VehicleType.Type_Horse == vehicleType or CppEnums.VehicleType.Type_Donkey == vehicleType or CppEnums.VehicleType.Type_Camel == vehicleType) and regionName == servantRegionName and not servantInfo:isChangingRegion() then
          self:setButton(self._enumButtonType.eMARKET_REGISTER, self._string.marketRegister)
        end
        if stable_isMating() and servantInfo:doMating() and servantInfo:isMale() and nowMating ~= getState and regMarket ~= getState and regMating ~= getState and training ~= getState and stallionTraining ~= getState and CppEnums.ServantStateType.Type_Stable == servantInfo:getStateType() and regionName == servantRegionName then
          self:setButton(self._enumButtonType.eMATING_REGISTER, self._string.matingRegister)
        end
        if false == isPcroomOnly and nowMating ~= getState and regMarket ~= getState and regMating ~= getState and training ~= getState and FGlobal_IsCommercialService() and stallionTraining ~= getState then
          self:setButton(self._enumButtonType.eCHANGE_NAME, self._string.changeName)
        end
        if false == isPcroomOnly and nowMating ~= getState and regMarket ~= getState and regMating ~= getState and training ~= getState and FGlobal_IsCommercialService() and stallionTraining ~= getState then
          if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Camel or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Donkey or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant then
            self:setButton(self._enumButtonType.eDEAD_RESET, self._string.killCountReset)
          elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Carriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_CowCarriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_RepairableCarriage then
            self:setButton(self._enumButtonType.eDEAD_RESET, self._string.destroyCountReset)
          elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Boat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Raft or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_FishingBoat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_SailingBoat then
            self:setButton(self._enumButtonType.eDEAD_RESET, self._string.destroyCountReset)
          end
        end
        if servantInfo:doClearCountByMating() and servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse and training ~= getState and FGlobal_IsCommercialService() and stallionTraining ~= getState and nowMating ~= getState and regMarket ~= getState and regMating ~= getState then
          self:setButton(self._enumButtonType.eCLEAR_MATING_COUNT, self._string.clearMatingCount)
        end
        if CppEnums.ServantStateType.Type_Mating == servantInfo:getStateType() and FGlobal_IsCommercialService() and not servantInfo:isMale() and not servantInfo:isMatingComplete() then
          self:setButton(self._enumButtonType.eMATING_IMMEDIATELY, self._string.mateImmediately)
        end
        if CppEnums.ServantStateType.Type_RegisterMating == getState then
          self:setButton(self._enumButtonType.eSHOW_BREEDING_MARKET, self._string.showBreedingMarket)
        end
        if false == isPcroomOnly and servantInfo:doImprint() and FGlobal_IsCommercialService() and stallionTraining ~= getState then
          self:setButton(self._enumButtonType.eSTAMPING, self._string.stamping)
        end
        if false == isPcroomOnly and CppEnums.VehicleType.Type_Horse == servantInfo:getVehicleType() and nowMating ~= getState and regMarket ~= getState and regMating ~= getState and training ~= getState and regionName == servantRegionName and isContentsEnableChangeLook and stallionTraining ~= getState then
          self:setButton(self._enumButtonType.eLOOK_CHANGE, self._string.lookChange)
        end
        if false == isPcroomOnly then
          if CppEnums.VehicleType.Type_Horse == vehicleType or CppEnums.VehicleType.Type_Donkey == vehicleType or CppEnums.VehicleType.Type_Camel == vehicleType or CppEnums.VehicleType.Type_RidableBabyElephant == vehicleType and stallionTraining ~= getState then
            if nowMating ~= getState and regMarket ~= getState and regMating ~= getState and training ~= getState then
              if stable_isMarket() and servantLevel >= 15 and CppEnums.VehicleType.Type_Horse == vehicleType and isContentsEnableSupply then
                self:setButton(self._enumButtonType.eSUPPLY, self._string.supply)
              elseif stallionTraining ~= getState then
                self:setButton(self._enumButtonType.eRELEASE, self._string.release)
              end
            end
          else
            self:setButton(self._enumButtonType.eSELL, self._string.sell)
          end
        end
        if CppEnums.VehicleType.Type_Horse == servantInfo:getVehicleType() and true == servantInfo:isStallion() and stable_isPossibleStallionSkillExpTraining() and isContentsStallionEnable and isContentsNineTierEnable and 30 == servantInfo:getLevel() and 8 == servantInfo:getTier() and nowMating ~= getState and regMarket ~= getState and regMating ~= getState and training ~= getState then
          self:setButton(self._enumButtonType.eSTALLION_TRAINING, self._string.stallionTraining)
        end
        if not servantInfo:doHaveVehicleSkill() then
          if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Carriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_RepairableCarriage then
            local carriageNo = servantInfo:getServantNo()
          end
        elseif nil ~= getState and CppEnums.ServantStateType.Type_Stable == getState or CppEnums.ServantStateType.Type_Field == getState then
          self:setButton(self._enumButtonType.eSKILLCHANGE, self._string.skillChange)
        end
      end
    elseif not isLinkedHorse and 0 == servantInfo:getHp() and (CppEnums.VehicleType.Type_Horse == vehicleType or CppEnums.VehicleType.Type_Donkey == vehicleType or CppEnums.VehicleType.Type_Camel == vehicleType or CppEnums.VehicleType.Type_MountainGoat == vehicleType) and not servantInfo:isMatingComplete() and nowMating ~= getState and regMarket ~= getState and regMating ~= getState and training ~= getState and stallionTraining ~= getState then
      self:setButton(self._enumButtonType.eRECOVERY, self._string.recovery)
      self:setButton(self._enumButtonType.eUNSEAL, self._string.unseal)
    end
    if stable_isSkillExpTrainingComplete(selectServantNo) then
      self:setButton(self._enumButtonType.eTRAINFINISH, self._string.trainFinish)
    elseif isContentsStallionEnable and stable_isEndStallionSkillExpTraining(selectServantNo) and isContentsNineTierEnable then
      self:setButton(self._enumButtonType.eSTALLION_TRAINFINISH, self._string.trainFinish)
    end
    if showChangeRegionButtonFlag and false then
      self:setButton(self._enumButtonType.eMOVE, self._string.move)
    end
  end
end
function Panel_Window_StableInfo_Menu_info:setUnSealedButton()
  if false == isSiegeStable() then
    local temporaryWrapper = getTemporaryInformationWrapper()
    if nil == temporaryWrapper then
      return
    end
    local unSealServantInfo = temporaryWrapper:getUnsealVehicle(stable_getServantType())
    if nil == unSealServantInfo then
      return
    end
    local vehicleType = unSealServantInfo:getVehicleType()
    local getState = unSealServantInfo:getStateType()
    local nowMating = CppEnums.ServantStateType.Type_Mating
    local regMarket = CppEnums.ServantStateType.Type_RegisterMarket
    local regMating = CppEnums.ServantStateType.Type_RegisterMating
    self:setButton(self._enumButtonType.eSEAL, self._string.seal)
    self:setButton(self._enumButtonType.eREMOTE, self._string.remote)
    if (unSealServantInfo:getHp() < unSealServantInfo:getMaxHp() or unSealServantInfo:getMp() < unSealServantInfo:getMaxMp()) and (CppEnums.VehicleType.Type_Horse == vehicleType or CppEnums.VehicleType.Type_Donkey == vehicleType or CppEnums.VehicleType.Type_Camel == vehicleType or CppEnums.VehicleType.Type_MountainGoat == vehicleType or CppEnums.VehicleType.Type_RidableBabyElephant == vehicleType) and not unSealServantInfo:isMatingComplete() and nowMating ~= getState and regMarket ~= getState and regMating ~= getState then
      self:setButton(self._enumButtonType.eRECOVERY_UNSEAL, self._string.recovery)
    end
    if CppEnums.VehicleType.Type_RepairableCarriage == vehicleType then
      if unSealServantInfo:getHp() < unSealServantInfo:getMaxHp() or unSealServantInfo:getMp() < unSealServantInfo:getMaxMp() then
        self:setButton(self._enumButtonType.eREPAIR_UNSEAL, self._string.repair)
      end
    elseif (CppEnums.VehicleType.Type_Carriage == vehicleType or CppEnums.VehicleType.Type_CowCarriage == vehicleType) and unSealServantInfo:getHp() < unSealServantInfo:getMaxHp() then
      self:setButton(self._enumButtonType.eREPAIR_UNSEAL, self._string.repair)
    end
  end
end
function Panel_Window_StableInfo_Menu_info:readyToClose()
end
function Panel_Window_StableInfo_Menu_info:setBgSize()
  local newSizeY = self._value.currentButtonCount * (self._pos.buttonSizeY + self._pos.buttonSpaceY) + self._pos.startPosY * 2 - 5
  Panel_Window_StableInfo_Menu:SetSize(Panel_Window_StableInfo_Menu:GetSizeX(), newSizeY)
end
function Panel_Window_StableInfo_Menu_info:open()
  Panel_Window_StableInfo_Menu:SetShow(true)
end
function Panel_Window_StableInfo_Menu_info:close()
  Panel_Window_StableInfo_Menu:SetShow(false)
end
function PaGlobalFunc_StableInfo_Menu_GetShow()
  return Panel_Window_StableInfo_Menu:GetShow()
end
function PaGlobalFunc_StableInfo_Menu_Open()
  local self = Panel_Window_StableInfo_Menu_info
  self:open()
end
function PaGlobalFunc_StableInfo_Menu_Show(baseCotrol, eType, selectServantNo)
  local self = Panel_Window_StableInfo_Menu_info
  self:initValue()
  self:setServantNo(selectServantNo)
  self:readyToOpen(baseCotrol, eType, selectServantNo)
  PaGlobalFunc_StableInfo_Menu_SelectButton(self._value.currentSelectButtonIndex)
  if 0 == self._value.currentButtonCount then
    self:close()
  else
    self:open()
  end
end
function PaGlobalFunc_StableInfo_Menu_Close()
  local self = Panel_Window_StableInfo_Menu_info
  self:close()
end
function PaGlobalFunc_StableInfo_Menu_Update()
end
function PaGlobalFunc_StableInfo_Menu_OutFocus(index)
  local self = Panel_Window_StableInfo_Menu_info
  self._ui.buttonList[index].static_A:SetShow(false)
  self._ui.buttonList[index].button:SetCheck(false)
end
function PaGlobalFunc_StableInfo_Menu_SelectButton(index)
  local self = Panel_Window_StableInfo_Menu_info
  self._value.lastSelectButtonIndex = self._value.currentSelectButtonIndex
  self._value.currentSelectButtonIndex = index
  self._ui.buttonList[self._value.lastSelectButtonIndex].static_A:SetShow(false)
  self._ui.buttonList[self._value.currentSelectButtonIndex].static_A:SetShow(true)
  self._ui.buttonList[self._value.lastSelectButtonIndex].button:SetCheck(false)
  self._ui.buttonList[self._value.currentSelectButtonIndex].button:SetCheck(true)
end
function PaGlobalFunc_StableInfo_Menu_ClickButton(index)
  local self = Panel_Window_StableInfo_Menu_info
  PaGlobalFunc_StableInfo_Menu_SelectButton(index)
  local buttonType = self._ui.buttonList[index].buttonType
  local excuteFunction
  local buttonType = self._ui.buttonList[index].buttonType
  excuteFunction = self._buttonFunc[buttonType]
  if nil ~= excuteFunction then
    excuteFunction()
  else
  end
end
function PaGlobalFunc_StableInfo_Menu_Unseal()
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local servantInfo = stable_getServant(self._value.selectedServantSlotNo)
  if nil == servantInfo then
    return
  end
  local currentButtonServantNo = servantInfo:getServantNo()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  stable_unsealByServantNo(currentButtonServantNo)
  PaGlobalFunc_StableInfo_Exit()
end
function PaGlobalFunc_StableInfo_Menu_RecoveryXXX()
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(5, 7)
  stable_recovery(self._value.selectedServantSlotNo, MessageBoxCheck.isCheck())
  PaGlobalFunc_StableInfo_Exit()
end
function PaGlobalFunc_StableInfo_Menu_ReviveXXX()
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(5, 7)
  stable_revive(self._value.selectedServantSlotNo, MessageBoxCheck.isCheck())
  PaGlobalFunc_StableInfo_Exit()
end
function PaGlobalFunc_StableInfo_Menu_Recovery()
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local servantInfo = stable_getServant(self._value.selectedServantSlotNo)
  if nil == servantInfo then
    return
  end
  local needMoney = 0
  local confirmFunction
  local vehicleType = servantInfo:getVehicleType()
  local servantHp = servantInfo:getHp()
  if 0 == servantHp then
    imprintMoney = makeDotMoney(servantInfo:getReviveOriginalCost_s64())
    needMoney = makeDotMoney(servantInfo:getReviveCost_s64())
    confirmFunction = PaGlobalFunc_StableInfo_Menu_ReviveXXX
  else
    imprintMoney = makeDotMoney(servantInfo:getRecoveryOriginalCost_s64())
    needMoney = makeDotMoney(servantInfo:getRecoveryCost_s64())
    confirmFunction = PaGlobalFunc_StableInfo_Menu_RecoveryXXX
  end
  if servantInfo:isImprint() then
    if vehicleType == CppEnums.VehicleType.Type_RepairableCarriage then
      Imprint_Notify_Title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_REPAIRABLECARRIAGE_RECOVERY_NOTIFY_MSG", "needMoney", imprintMoney) .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLELIST_STAMPING_DISCOUNT", "needMoney", needMoney)
    else
      Imprint_Notify_Title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_MSG", "needMoney", imprintMoney) .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLELIST_STAMPING_DISCOUNT", "needMoney", needMoney)
    end
  elseif vehicleType == CppEnums.VehicleType.Type_Horse or vehicleType == CppEnums.VehicleType.Type_Camel or vehicleType == CppEnums.VehicleType.Type_Donkey or vehicleType == CppEnums.VehicleType.Type_Elephant then
    Imprint_Notify_Title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_MSG", "needMoney", imprintMoney) .. PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_STAMPING_NOT")
  elseif vehicleType == CppEnums.VehicleType.Type_RepairableCarriage then
    Imprint_Notify_Title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_REPAIRABLECARRIAGE_RECOVERY_NOTIFY_MSG", "needMoney", imprintMoney)
  else
    Imprint_Notify_Title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_MSG", "needMoney", imprintMoney)
  end
  local Recovery_Notify_Title = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_TITLE")
  if CppEnums.VehicleType.Type_Carriage == vehicleType or CppEnums.VehicleType.Type_CowCarriage == vehicleType or CppEnums.VehicleType.Type_Boat == vehicleType or CppEnums.VehicleType.Type_Raft == vehicleType then
    local messageData = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_CARRIAGE_RECOVERY_NOTIFY_MSG", "needMoney", needMoney)
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageData,
      functionApply = confirmFunction,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBoxCheck.showMessageBox(messageBoxData)
  else
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = Imprint_Notify_Title,
      functionApply = confirmFunction,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBoxCheck.showMessageBox(messageBoxData)
  end
end
function PaGlobalFunc_StableInfo_Menu_UnLink()
  local self = Panel_Window_StableInfo_Menu_info
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local servantInfo = stable_getServant(self._value.selectedServantSlotNo)
  if nil == servantInfo then
    return
  end
  local carriageNo = servantInfo:getOwnerServantNo_s64()
  local carriageCheck = false
  for index = 0, stable_count() - 1 do
    local sInfo = stable_getServant(index)
    local sNo = sInfo:getServantNo()
    if carriageNo == sNo then
      PaGlobalFunc_StableExchange_ReleaseLink(self._value.selectedServantSlotNo, index)
      carriageCheck = true
      PaGlobalFunc_StableInfo_CloseWith()
    end
  end
  if false == carriageCheck then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_CARRIAGE_CANCEL"))
  end
end
function PaGlobalFunc_StableInfo_Menu_ReceiveChildServant()
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  stable_getServantMatingChildInfo(self._value.selectedServantSlotNo)
  PaGlobalFunc_StableInfo_CloseWith()
end
function PaGlobalFunc_StableInfo_Menu_RegisterMarketXXX()
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local slotNo = self._value.selectedServantSlotNo
  local servantInfo = stable_getServant(slotNo)
  if nil == servantInfo then
    return
  end
  PaGlobalFunc_StableRegister_Market_ShowByType(CppEnums.ServantRegist.eEventType_RegisterMarket)
  PaGlobalFunc_StableInfo_CloseWith()
end
function PaGlobalFunc_StableInfo_Menu_RegisterMarket()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  Servant_Confirm(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_REGISTERMARKET_NOTIFY_TITLE"), PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_REGISTERMARKET_NOTIFY_MSG"), PaGlobalFunc_StableInfo_Menu_RegisterMarketXXX, MessageBox_Empty_function)
end
function PaGlobalFunc_StableInfo_Menu_RegisterMatingXXX()
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local slotNo = self._value.selectedServantSlotNo
  local servantInfo = stable_getServant(slotNo)
  if nil == servantInfo then
    return
  end
  PaGlobalFunc_StableRegister_Market_ShowByType(CppEnums.ServantRegist.eEventType_RegisterMating)
  PaGlobalFunc_StableInfo_CloseWith()
end
function PaGlobalFunc_StableInfo_Menu_RegisterMating()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  Servant_Confirm(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_REGISTERMATING_NOTIFY_TITLE"), PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_REGISTERMATING_NOTIFY_MSG"), PaGlobalFunc_StableInfo_Menu_RegisterMatingXXX, MessageBox_Empty_function)
end
function PaGlobalFunc_StableInfo_Menu_ChangeName()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local executeChangeName = function()
    PaGlobalFunc_StableRegister_OpenByRename()
    PaGlobalFunc_StableInfo_CloseWith()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_POPMSGBOX_CHANGENAME_MEMO")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = executeChangeName,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_StableInfo_Menu_ClearDeadCount()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local function clearDeadCountDo()
    stable_clearDeadCount(self._value.selectedServantSlotNo)
    PaGlobalFunc_StableInfo_Exit()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_KILLCOUNTRESET_ALLRECOVERY")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = clearDeadCountDo,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_StableInfo_Menu_ClearMatingCount()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local function clearMatingCountDo()
    stable_clearMatingCount(self._value.selectedServantSlotNo)
    PaGlobalFunc_StableInfo_Exit()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_MATINGCOUNTRESET")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = clearMatingCountDo,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_StableInfo_Menu_MatingImmediately()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local servantInfo = stable_getServant(self._value.selectedServantSlotNo)
  if nil == servantInfo then
    return
  end
  local function matingImmediately()
    stable_requestCompleteServantMating(self._value.selectedServantSlotNo, servantInfo:getCompleteMatingFromPearl_s64())
    PaGlobalFunc_StableInfo_Exit()
  end
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_IMMDEDIATELY_MSGBOX_TITLE")
  local contentString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_IMMDEDIATELY_MSGBOX_SERVANT_MEMO", "pearl", tostring(servantInfo:getCompleteMatingFromPearl_s64()))
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = matingImmediately,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_StableInfo_Menu_SeeBreedingMarket()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  PaGlobalFunc_StableFunction_SelectButton(3, 1)
end
function PaGlobalFunc_StableInfo_Menu_Stamping(isImprint)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  isImprint = true
  local function imprint()
    stable_imprint(self._value.selectedServantSlotNo, isImprint)
    PaGlobalFunc_StableInfo_Exit()
  end
  if false == isImprint then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_ISIMPRINT_RECOVERY")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_STAMPING_IS_DISCOUNT")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = imprint,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_StableInfo_Menu_LookChange()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local servantInfo = stable_getServant(self._value.selectedServantSlotNo)
  if nil == servantInfo then
    return
  end
end
function PaGlobalFunc_StableInfo_Menu_StartStallionTraining()
  if not isContentsStallionEnable and not isContentsNineTierEnable then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local servantInfo = stable_getServant(self._value.selectedServantSlotNo)
  if nil == servantInfo then
    return
  end
  local servantNo = servantInfo:getServantNo()
  if CppEnums.ServantStateType.Type_StallionTraining == servantInfo:getStateType() then
    return
  end
  ToClient_startStallionSkillExpTraining(servantNo)
end
local sellCheck = true
function PaGlobalFunc_StableInfo_Menu_SellToNpcXXX()
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  stable_changeToReward(self._value.selectedServantSlotNo, CppEnums.ServantToRewardType.Type_Money)
  sellCheck = true
  PaGlobalFunc_StableInfo_Exit()
end
function PaGlobalFunc_StableInfo_Menu_Supply()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local servantInfo = stable_getServant(self._value.selectedServantSlotNo)
  if nil == servantInfo then
    return
  end
  local resultMoney = makeDotMoney(servantInfo:getSellCost_s64())
  local title = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_SUPPLY")
  local content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABLE_SUPPLY", "resultMoney", resultMoney) .. servantInvenAlert
  if ToClient_IsContentsGroupOpen("1067") then
    content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABLE_SUPPLYEVENT", "resultMoney", resultMoney) .. servantInvenAlert
  end
  Servant_Confirm(title, content, PaGlobalFunc_StableInfo_Menu_SellToNpcXXX, MessageBox_Empty_function)
end
function PaGlobalFunc_StableInfo_Menu_ReleaseXXX()
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  stable_changeToReward(self._value.selectedServantSlotNo, CppEnums.ServantToRewardType.Type_Experience)
  sellCheck = true
  PaGlobalFunc_StableInfo_Exit()
end
function PaGlobalFunc_StableInfo_Menu_Release()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local servantInfo = stable_getServant(self._value.selectedServantSlotNo)
  if nil == servantInfo then
    return
  end
  local resultMoney = makeDotMoney(servantInfo:getSellCost_s64())
  if servantInfo:isPcroomOnly() then
    resultMoney = 0
  end
  Servant_Confirm(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SELL_NOTIFY_TITLE"), PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SELL_NOTIFY_MSG", "resultMoney", resultMoney) .. servantInvenAlert, PaGlobalFunc_StableInfo_Menu_ReleaseXXX, MessageBox_Empty_function)
end
function PaGlobalFunc_StableInfo_Menu_SellToNpc()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local servantInfo = stable_getServant(self._value.selectedServantSlotNo)
  if nil == servantInfo then
    return
  end
  local resultMoney = makeDotMoney(servantInfo:getSellCost_s64())
  Servant_Confirm(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SELL_NOTIFY_TITLE"), PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SELL_NOTIFY_MSG", "resultMoney", resultMoney) .. servantInvenAlert, PaGlobalFunc_StableInfo_Menu_ReleaseXXX, MessageBox_Empty_function)
end
function PaGlobalFunc_StableInfo_Menu_TrainFinish()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  stable_endServantSkillExpTraining(self._value.selectedServantSlotNo)
  PaGlobalFunc_StableInfo_Exit()
end
function PaGlobalFunc_StableInfo_Menu_StallionTrainFinish()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  stable_endStallionSkillExpTraining(self._value.selectedServantSlotNo)
  PaGlobalFunc_StableInfo_Exit()
end
function PaGlobalFunc_StableInfo_Menu_Move()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
end
function PaGlobalFunc_StableInfo_Menu_ChangSKill()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_StableInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  PaGlobalFunc_StableChangeSkill_Show()
end
function PaGlobalFunc_StableInfo_Menu_Seal()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  stable_seal(false)
  PaGlobalFunc_StableInfo_Exit()
end
function PaGlobalFunc_StableInfo_Menu_RemoteSeal()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local seal_Go = function()
    stable_seal(true)
    PaGlobalFunc_StableInfo_Exit()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_ISCOMPULSION_MESSAGEBOX")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = seal_Go,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_StableInfo_Menu_RecoveryUnsealXXX()
  _AudioPostEvent_SystemUiForXBOX(5, 7)
  stable_recoveryUnseal(MessageBoxCheck.isCheck())
  PaGlobalFunc_StableInfo_Exit()
end
function PaGlobalFunc_StableInfo_Menu_RecoveryUnseal()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local temporaryWrapper = getTemporaryInformationWrapper()
  local servantWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
  if nil == servantWrapper then
    return
  end
  local imprintMoney = makeDotMoney(servantWrapper:getRecoveryOriginalCost_s64())
  local needMoney = makeDotMoney(servantWrapper:getRecoveryCost_s64())
  if servantWrapper:getRecoveryOriginalCost_s64() <= Defines.s64_const.s64_1 then
    return
  end
  if servantWrapper:isImprint() then
    if servantWrapper:getVehicleType() == CppEnums.VehicleType.Type_RepairableCarriage then
      Imprint_Notify_Title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_REPAIRABLECARRIAGE_RECOVERY_NOTIFY_MSG", "needMoney", imprintMoney) .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLELIST_STAMPING_DISCOUNT", "needMoney", needMoney)
    else
      Imprint_Notify_Title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_MSG", "needMoney", imprintMoney) .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLELIST_STAMPING_DISCOUNT", "needMoney", needMoney)
    end
  elseif servantWrapper:getVehicleType() == CppEnums.VehicleType.Type_Horse or servantWrapper:getVehicleType() == CppEnums.VehicleType.Type_Camel or servantWrapper:getVehicleType() == CppEnums.VehicleType.Type_Donkey or servantWrapper:getVehicleType() == CppEnums.VehicleType.Type_Elephant then
    Imprint_Notify_Title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_MSG", "needMoney", imprintMoney) .. PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_STAMPING_NOT")
  elseif servantWrapper:getVehicleType() == CppEnums.VehicleType.Type_RepairableCarriage then
    Imprint_Notify_Title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_REPAIRABLECARRIAGE_RECOVERY_NOTIFY_MSG", "needMoney", imprintMoney)
  else
    Imprint_Notify_Title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_MSG", "needMoney", imprintMoney)
  end
  local RecoveryUnseal = function()
    PaGlobalFunc_StableInfo_Menu_RecoveryUnsealXXX()
  end
  local vehicleType = servantWrapper:getVehicleType()
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_TITLE"),
    content = Imprint_Notify_Title,
    functionApply = RecoveryUnseal,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBoxCheck.showMessageBox(messageBoxData)
end
function FromClient_StableInfo_Menu_Init()
  local self = Panel_Window_StableInfo_Menu_info
  self:initialize()
end
function FromClient_StableInfo_Menu_Resize()
  local self = Panel_Window_StableInfo_Menu_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_StableInfo_Menu_Init")
