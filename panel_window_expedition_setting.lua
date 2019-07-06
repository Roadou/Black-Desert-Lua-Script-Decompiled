local expeditionSettingInfo = {
  _ui = {
    _button_close = UI.getChildControl(Panel_ArmyUnitSetting, "Button_Win_Close"),
    _button_save = UI.getChildControl(Panel_ArmyUnitSetting, "Button_Save"),
    _button_manage = UI.getChildControl(Panel_ArmyUnitSetting, "Button_Manage"),
    _button_allReceive = UI.getChildControl(Panel_ArmyUnitSetting, "Button_AllReceive"),
    _button_selectReceive = UI.getChildControl(Panel_ArmyUnitSetting, "Button_SelectReceive"),
    _button_report = UI.getChildControl(Panel_ArmyUnitSetting, "Button_Report"),
    _text_time = UI.getChildControl(Panel_ArmyUnitSetting, "StaticText_Time"),
    _baseBG = UI.getChildControl(Panel_ArmyUnitSetting, "Static_LeftBG"),
    _txt_supply = UI.getChildControl(Panel_ArmyUnitSetting, "StaticText_Supply")
  },
  _config = {
    _posX = 20,
    _posY = 80,
    _bgMaxCount = 3,
    _rewardItemMaxCount = 48
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true,
    createCount = true
  },
  _settingBG = Array.new(),
  _selectInfo = {
    [0] = {
      _characterNo = nil,
      _unitNo = nil,
      _groupKey = nil,
      _reset = false
    },
    [1] = {
      _characterNo = nil,
      _unitNo = nil,
      _groupKey = nil,
      _reset = false
    },
    [2] = {
      _characterNo = nil,
      _unitNo = nil,
      _groupKey = nil,
      _reset = false
    }
  },
  _initialize = false,
  _isShowMessageRegisterExpedition = false,
  _rewardItemSlot = Array.new(),
  _selectItemEnchantKeyList = Array.new()
}
function expeditionSettingInfo:selectInfoClear()
  for ii = 0, self._config._bgMaxCount - 1 do
    local info = _selectInfo[ii]
    info._characterNo = nil
    info._unitNo = nil
    info._groupKey = nil
    info._reset = false
  end
end
function expeditionSettingInfo:initialize()
  if false == self._initialize then
    self:createControl()
    self:registEventHandler()
    self:selectInfoClear()
  end
  Panel_ArmyUnitSetting:SetShow(false)
  self._initialize = true
  self._isShowMessageRegisterExpedition = false
end
function expeditionSettingInfo:registEventHandler()
  self._ui._button_close:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionSettingInfo_Close()")
  self._ui._button_save:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionSettingInfo_Save()")
  self._ui._button_manage:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionUnitSelectInfo_Open(0, true)")
  self._ui._button_report:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionSettingInfo_ClickReport()")
  self._ui._button_selectReceive:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionSettingInfo_ReceiveItem(false)")
  self._ui._button_allReceive:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionSettingInfo_ReceiveItem(true)")
end
function expeditionSettingInfo:createControl()
  for ii = 0, self._config._bgMaxCount - 1 do
    local settingBG = {
      _parent = nil,
      _mainBG = nil,
      _itemBG = nil,
      _areaDesc = nil,
      _image = nil,
      _imageInfo = nil,
      _warningText1 = nil,
      _warningText2 = nil
    }
    local cloneBG = UI.cloneControl(self._ui._baseBG, Panel_ArmyUnitSetting, "SettingBG_" .. ii)
    settingBG._parent = cloneBG
    cloneBG:SetPosX(self._config._posX + ii * 351)
    cloneBG:SetPosY(self._config._posY)
    local defaultBG = UI.getChildControl(cloneBG, "Static_DefaultBG")
    local mainBG = UI.getChildControl(cloneBG, "Static_SelectMainBG")
    settingBG._mainBG = mainBG
    local subTitle = UI.getChildControl(defaultBG, "StaticText_SubTitle")
    subTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXPEDITION_SUBTITLE", "number", tostring(ii + 1)))
    local button_areaSelect = UI.getChildControl(mainBG, "Button_Reset")
    button_areaSelect:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionSettingInfo_Reset(" .. ii .. ")")
    local button_areaSelect = UI.getChildControl(mainBG, "Button_SelectArea")
    button_areaSelect:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionAreaSelectInfo_Open(" .. ii .. ")")
    local unitSelect = UI.getChildControl(mainBG, "Static_MercenaryList")
    local button_change = UI.getChildControl(unitSelect, "Button_Change")
    button_change:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionUnitSelectInfo_Open(" .. ii .. ", false )")
    local recovery = UI.getChildControl(unitSelect, "Button_Recover")
    recovery:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionUnitRecovery(" .. ii .. ")")
    local text_desc = UI.getChildControl(mainBG, "StaticText_AreaDesc")
    text_desc:SetText("")
    settingBG._areaDesc = text_desc
    local text_warning1 = UI.getChildControl(mainBG, "StaticText_ResultWarning1")
    settingBG._warningText1 = text_warning1
    settingBG._warningText1:SetShow(false)
    settingBG._warningText1:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    settingBG._warningText1:SetText(settingBG._warningText1:GetText())
    local text_warning2 = UI.getChildControl(mainBG, "StaticText_ResultWarning2")
    settingBG._warningText2 = text_warning2
    settingBG._warningText2:SetShow(false)
    settingBG._warningText2:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    settingBG._warningText2:SetText(settingBG._warningText2:GetText())
    local imageBorder = UI.getChildControl(mainBG, "Static_TemPleate_CharacterImageBorder")
    local image = UI.getChildControl(imageBorder, "Static_Image")
    local imageBtn = UI.getChildControl(imageBorder, "Static_Image_Button")
    imageBtn:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionCharacterSelectInfo_Open(" .. ii .. ")")
    imageBtn:setGlassBackground(true)
    settingBG._image = image
    local imageInfo = UI.getChildControl(imageBorder, "StaticText_Info")
    settingBG._imageInfo = imageInfo
    settingBG._imageInfo:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._settingBG[ii] = settingBG
  end
  deleteControl(self._ui._baseBG)
  self._ui._baseBG = nil
end
function expeditionSettingInfo:open()
  PaGlobalFunc_ExpeditionSettingInfo_ClickRadioButton(0)
  expeditionSettingInfo:initSetting()
  PaGlobalFunc_ExpeditionUpdateSupplySetting()
  Panel_ArmyUnitSetting:SetShow(true)
end
function expeditionSettingInfo:initSetting()
  if nil ~= ToClient_updateExpeditionSelfPlayerTotalStatValue() then
    ToClient_updateExpeditionSelfPlayerTotalStatValue()
  end
  for ii = 0, self._config._bgMaxCount - 1 do
    local expeditionInfo = ToClient_getExpeditionInfo(ii)
    if nil ~= expeditionInfo then
      PaGlobalFunc_ExpeditionSettingInfo_SelectCharacterSet(ii, expeditionInfo._characterNo)
      PaGlobalFunc_ExpeditionSettingInfo_SelectUnitSet(ii, expeditionInfo._unitNo)
      PaGlobalFunc_ExpeditionSettingInfo_SelectAreaSet(ii, expeditionInfo._groupKey, expeditionInfo._unitNo, true)
    end
  end
end
function expeditionSettingInfo:close()
  Panel_ArmyUnitSetting:SetShow(false)
  Panel_NumberPad_Close()
end
function expeditionSettingInfo:isRepetition()
  for ii = 0, self._config._bgMaxCount - 1 do
    for jj = ii + 1, self._config._bgMaxCount - 1 do
      local info1 = self._selectInfo[ii]
      local info2 = self._selectInfo[jj]
      if nil ~= info1._characterNo and nil ~= info1._unitNo and info1._groupKey and nil ~= info2._characterNo and nil ~= info2._unitNo and info2._groupKey then
        if info1._characterNo == info2._characterNo then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXPEDITION_DUPLICATION_MESSAGE1"))
          return 1
        elseif info1._unitNo == info2._unitNo then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXPEDITION_DUPLICATION_MESSAGE2"))
          return 1
        elseif info1._groupKey == info2._groupKey then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXPEDITION_DUPLICATION_MESSAGE3"))
          return 1
        end
      end
    end
  end
  return 0
end
function PaGlobalFunc_ExpeditionSettingInfo_Open()
  local self = expeditionSettingInfo
  self:open()
end
function PaGlobalFunc_ExpeditionSettingInfo_Close()
  local self = expeditionSettingInfo
  self:close()
  PaGlobalFunc_ExpeditionRewardItemInfo_Close()
  PaGlobalFunc_ExpeditionUnitSelectInfo_Close()
  PaGlobalFunc_ExpeditionAreaSelectInfo_Close()
  PaGlobalFunc_ExpeditionCharacterSelectInfo_Close()
end
function PaGlobalFunc_ExpeditionSettingInfo_Save()
  local self = expeditionSettingInfo
  local rv = self:isRepetition()
  if 0 ~= rv then
    return
  end
  for ii = 0, self._config._bgMaxCount - 1 do
    local info = self._selectInfo[ii]
    local checkSet = 0
    if nil ~= info._characterNo then
      checkSet = checkSet + 1
    end
    if nil ~= info._unitNo then
      checkSet = checkSet + 1
    end
    if nil ~= info._groupKey then
      checkSet = checkSet + 1
    end
    if 0 ~= checkSet and 3 ~= checkSet then
      Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXPEDITION_NOT_FILL_MESSAGE", "number", ii + 1))
      return
    end
  end
  self._isShowMessageRegisterExpedition = false
  local notSendExpedition = 0
  for ii = 0, self._config._bgMaxCount - 1 do
    local info = self._selectInfo[ii]
    if nil ~= info._characterNo and nil ~= info._unitNo and nil ~= info._groupKey then
      ToClient_requestExpeditionSet(info._characterNo, info._unitNo, info._groupKey, ii)
    elseif true == info._reset then
      ToClient_cancelExpedition(ii)
    else
      notSendExpedition = notSendExpedition + 1
    end
  end
  if notSendExpedition == self._config._bgMaxCount then
    self._isShowMessageRegisterExpedition = true
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXPEDITION_SUCCESS_SAVE"))
  end
end
function PaGlobalFunc_ExpeditionSettingInfo_ClickRadioButton(radioButtonType)
  local self = expeditionSettingInfo
  for ii = 0, self._config._bgMaxCount - 1 do
    if 0 == radioButtonType then
      self._settingBG[ii]._mainBG:SetShow(true)
      self._ui._button_save:SetShow(true)
      self._ui._button_selectReceive:SetShow(false)
      self._ui._button_allReceive:SetShow(false)
    else
      self._settingBG[ii]._mainBG:SetShow(false)
      self._ui._button_save:SetShow(false)
      self._ui._button_selectReceive:SetShow(true)
      self._ui._button_allReceive:SetShow(true)
    end
  end
end
function PaGlobalFunc_ExpeditionSettingInfo_SelectUnitSet(index, unitNo)
  local myUnit = ToClient_getMyExpeditionUnitInfo(unitNo)
  if nil == myUnit then
    PaGlobalFunc_ExpeditionSettingInfo_Reset(index)
    return
  end
  local self = expeditionSettingInfo
  local mainBG = self._settingBG[index]._mainBG
  local content = UI.getChildControl(mainBG, "Static_MercenaryList")
  local textStatus = UI.getChildControl(content, "StaticText_Top_Status")
  local expValue = UI.getChildControl(content, "StaticText_ExpValue")
  local guageBar = UI.getChildControl(content, "Progress2_ExpGauge")
  local unitInfoBG = UI.getChildControl(content, "StaticText_SlotIconBG")
  local textLevel = UI.getChildControl(unitInfoBG, "StaticText_GradeEdge")
  local atkPoint = myUnit:getAttackPoint()
  local level = myUnit._level
  local curExp = myUnit._experience
  local maxExp = myUnit:getMaxExperience()
  local curEnergyPoint = myUnit._energyPoint
  local maxEnergy = myUnit:getMaxEnergyPoint()
  local unitName = myUnit:getUnitName()
  textLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXPEDITION_UNIT_LEVEL", "level", level))
  local expRate = math.floor(Int64toInt32(curExp) * 100 / Int64toInt32(maxExp))
  expValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXPEDITION_UNIT_EXP", "exp", tostring(expRate)))
  guageBar:SetProgressRate(expRate)
  textStatus:SetShow(true)
  textStatus:SetText(PAGetStringParam4(Defines.StringSheet_GAME, "LUA_EXPEDITION_UNIT_ENERGY", "unitname", unitName, "attack", atkPoint, "curenergy", curEnergyPoint, "maxenergy", maxEnergy))
  self._selectInfo[index]._unitNo = myUnit._expeditionUnitNo
  self._selectInfo[index]._reset = false
end
function PaGlobalFunc_ExpeditionSettingInfo_SelectAreaSet(index, groupKey, unitNo, allRefresh)
  local self = expeditionSettingInfo
  if nil == unitNo then
    unitNo = self._selectInfo[index]._unitNo
  end
  local regionWrapper = ToClient_getExpeditionRegionWrapper(groupKey)
  if nil == regionWrapper then
    self._settingBG[index]._warningText1:SetShow(false)
    self._settingBG[index]._warningText2:SetShow(false)
    return
  end
  if true == allRefresh then
    local desc = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_EXPEDITION_REGION_DESC", "name", regionWrapper:getGroupName(), "value", regionWrapper:getRecommendCombatPoint())
    self._settingBG[index]._areaDesc:SetText(desc)
    self._selectInfo[index]._groupKey = groupKey
    self._selectInfo[index]._reset = false
  end
  local myUnit = ToClient_getMyExpeditionUnitInfo(unitNo)
  if nil ~= myUnit and "" ~= self._settingBG[index]._areaDesc:GetText() then
    local curEnergyPoint = myUnit._energyPoint
    local needEnergyPoint = regionWrapper:getUseEnergyPoint()
    if curEnergyPoint <= needEnergyPoint then
      self._settingBG[index]._warningText1:SetShow(true)
    else
      self._settingBG[index]._warningText1:SetShow(false)
    end
  else
    self._settingBG[index]._warningText1:SetShow(false)
  end
  local combatPoint = ToClient_getExpeditionTotalCombatPoint(index)
  if combatPoint > 0 then
    if false == self._settingBG[index]._warningText1:GetShow() and combatPoint < regionWrapper:getRecommendCombatPoint() and "" ~= self._settingBG[index]._areaDesc:GetText() then
      self._settingBG[index]._warningText2:SetShow(true)
    else
      self._settingBG[index]._warningText2:SetShow(false)
    end
  end
end
function PaGlobalFunc_ExpeditionSettingInfo_GetMyCharacterData(characterNo)
  local charList = ToClient_getMyCharacterInfo()
  for ii = 0, #charList do
    if characterNo == charList[ii]._characterNo then
      return charList[ii]
    end
  end
  return nil
end
function PaGlobalFunc_ExpeditionSettingInfo_SelectCharacterSet(index, characterNo)
  local myCharData = PaGlobalFunc_ExpeditionSettingInfo_GetMyCharacterData(characterNo)
  if nil == myCharData then
    return
  end
  local self = expeditionSettingInfo
  local settingBG = self._settingBG[index]
  local mainBG = settingBG._mainBG
  local travelValue = UI.getChildControl(mainBG, "StaticText_TravelNumber")
  local image = settingBG._image
  local charType = myCharData:getClassType()
  local charName = myCharData:getCharacterName()
  local textureName = myCharData:getFaceTexture()
  local isCaptureExist = image:ChangeTextureInfoNameNotDDS(textureName, charType, PaGlobal_getIsExitPhoto())
  if isCaptureExist == true then
    image:getBaseTexture():setUV(0, 0, 1, 1)
    image:SetShow(true)
  else
  end
  image:setRenderTexture(image:getBaseTexture())
  travelValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXPEDITION_COMBATPOINT", "value", tostring(math.floor(myCharData._totalStatValue))))
  settingBG._imageInfo:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_EXPEDITION_LEVEL_CHARACTERNAME", "level", myCharData._level, "name", charName))
  self._selectInfo[index]._characterNo = myCharData._characterNo
  self._selectInfo[index]._reset = false
end
function FromClient_ExpeditionSettingInfo_Initialize()
  local self = expeditionSettingInfo
  self:initialize()
end
function PaGlobalFunc_ExpeditionCharacterSelectInfo_SelectRewardItem(index, slotIndex)
  local self = expeditionSettingInfo
  local rewardSlot = self._rewardItemSlot[index][slotIndex]
  if true == rewardSlot.select:GetShow() then
    rewardSlot.select:SetShow(false)
    self._selectItemEnchantKeyList[slotIndex] = nil
  else
    rewardSlot.select:SetShow(true)
    self._selectItemEnchantKeyList[slotIndex] = rewardSlot.itemEnchantKey
  end
end
function PaGlobalFunc_ExpeditionSettingInfo_ReceiveItem(isAll)
  _PA_LOG("\235\176\149\234\183\156\235\130\152_\237\134\160\235\178\140", "\236\132\160\237\131\157\235\176\155\234\184\176 \235\136\140\235\160\164 \236\161\140\235\139\164...")
  local self = expeditionSettingInfo
  if true == isAll then
    ToClient_ReceiveExpeditionRewardItemAll()
  else
    for ii = 0, self._config._rewardItemMaxCount - 1 do
      local itemEnchantKey = self._selectItemEnchantKeyList[ii]
      if nil ~= itemEnchantKey then
        _PA_LOG("\235\176\149\234\183\156\235\130\152_\237\134\160\235\178\140", "\236\132\160\237\131\157\235\176\155\234\184\176" .. ii .. "/" .. tostring(itemEnchantKey))
        ToClient_ReceiveExpeditionRewardItem(itemEnchantKey)
      end
    end
  end
end
function PaGlobalFunc_ExpeditionSettingInfo_Reset(index)
  local self = expeditionSettingInfo
  self._selectInfo[index]._characterNo = nil
  self._selectInfo[index]._unitNo = nil
  self._selectInfo[index]._groupKey = nil
  self._selectInfo[index]._reset = true
  local mainBG = self._settingBG[index]._mainBG
  local settingBG = self._settingBG[index]
  local travelValue = UI.getChildControl(mainBG, "StaticText_TravelNumber")
  local image = settingBG._image
  image:SetShow(false)
  travelValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXPEDITION_COMBATPOINT", "value", 0))
  settingBG._imageInfo:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_EXPEDITION_LEVEL_CHARACTERNAME", "level", 0, "name", ""))
  self._settingBG[index]._areaDesc:SetText("")
  local content = UI.getChildControl(mainBG, "Static_MercenaryList")
  local textStatus = UI.getChildControl(content, "StaticText_Top_Status")
  local expValue = UI.getChildControl(content, "StaticText_ExpValue")
  local guageBar = UI.getChildControl(content, "Progress2_ExpGauge")
  local unitInfoBG = UI.getChildControl(content, "StaticText_SlotIconBG")
  local textLevel = UI.getChildControl(unitInfoBG, "StaticText_GradeEdge")
  textLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXPEDITION_UNIT_LEVEL", "level", 0))
  local expRate = 0
  expValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXPEDITION_UNIT_EXP", "exp", tostring(expRate)))
  guageBar:SetProgressRate(expRate)
  textStatus:SetShow(false)
  textStatus:SetText(PAGetStringParam4(Defines.StringSheet_GAME, "LUA_EXPEDITION_UNIT_ENERGY", "unitname", "", "attack", 0, "curenergy", 0, "maxenergy", 0))
  self._settingBG[index]._warningText1:SetShow(false)
  self._settingBG[index]._warningText2:SetShow(false)
end
function PaGlobalFunc_ExpeditionUnitRecovery(index)
  local self = expeditionSettingInfo
  if nil == self._selectInfo[index]._unitNo then
    return
  end
  PaGlobalFunc_ExpeditionUnitRecoveryDetail(self._selectInfo[index]._unitNo)
end
function PaGlobalFunc_ExpeditionUnitRecoveryDetail(unitNo)
  local myUnit = ToClient_getMyExpeditionUnitInfo(unitNo)
  if nil == myUnit then
    return
  end
  local curEnergyPoint = myUnit._energyPoint
  local maxEnergy = myUnit:getMaxEnergyPoint()
  local canFillEnergy = maxEnergy - curEnergyPoint
  if canFillEnergy <= 0 then
    return
  end
  fillEnergy = toInt64(0, canFillEnergy)
  local totalEnergy = ToClient_getExpeditionTotalSupplyEnergy()
  if totalEnergy < fillEnergy then
    fillEnergy = totalEnergy
  end
  local Expedition_confirmRecovery = function(energyPoint, unitNo)
    local function doRecovery()
      ToClient_requestExpeditionFillEnergy(unitNo, energyPoint)
    end
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXPEDITION_RECOVERY_MESSAGE", "value", tostring(energyPoint))
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = doRecovery,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "middle")
  end
  Panel_NumberPad_Show(true, fillEnergy, unitNo, Expedition_confirmRecovery, nil)
end
function PaGlobalFunc_ExpeditionSettingInfo_ClickRewardItem()
  PaGlobalFunc_ExpeditionRewardItemInfo_Open()
end
function PaGlobalFunc_ExpeditionSettingInfo_ClickReport()
  PaGlobalFunc_ExpeditionReportInfo_Open()
end
function PaGlobalFunc_SellExpeditionUnit(unitNo)
  ToClient_sellExpeditionUnit(unitNo)
end
function PaGlobalFunc_ExpeditionUpdateSupplySetting()
  local self = expeditionSettingInfo
  local totalPoint = ToClient_getExpeditionTotalSupplyEnergy()
  self._ui._txt_supply:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXPEDITION_SUPPLYPOINT_REMAIN", "value", tostring(totalPoint)))
end
function FromClient_registExpeditionSuccess(slotIndex)
  local self = expeditionSettingInfo
  if false == self._isShowMessageRegisterExpedition then
    self._isShowMessageRegisterExpedition = true
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXPEDITION_SUCCESS_SAVE"))
  end
  if nil ~= ToClient_updateExpeditionSelfPlayerTotalStatValue() then
    ToClient_updateExpeditionSelfPlayerTotalStatValue()
  end
  local expeditionInfo = ToClient_getExpeditionInfo(slotIndex)
  if nil ~= expeditionInfo then
    PaGlobalFunc_ExpeditionSettingInfo_SelectCharacterSet(slotIndex, expeditionInfo._characterNo)
    PaGlobalFunc_ExpeditionSettingInfo_SelectUnitSet(slotIndex, expeditionInfo._unitNo)
    PaGlobalFunc_ExpeditionSettingInfo_SelectAreaSet(slotIndex, expeditionInfo._groupKey, expeditionInfo._unitNo, true)
  end
end
function FromClient_fillExpeditionSuccess(unitNo)
  local self = expeditionSettingInfo
  for ii = 0, self._config._bgMaxCount - 1 do
    if self._selectInfo[ii]._unitNo == unitNo then
      PaGlobalFunc_ExpeditionSettingInfo_SelectUnitSet(ii, unitNo)
      PaGlobalFunc_ExpeditionSettingInfo_SelectAreaSet(ii, self._selectInfo[ii]._groupKey, unitNo, false)
    end
  end
  PaGlobalFunc_ExpeditionUnitSelectInfo_reOpen()
end
function FromClient_sellExpeditionSuccess(unitNo)
  local self = expeditionSettingInfo
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXPEDITION_SELL_UNIT_SUCCESS"))
  PaGlobalFunc_ExpeditionUnitSelectInfo_reOpen()
end
function FromClient_refreshExpeditionSupplyPoint()
  PaGlobalFunc_ExpeditionUpdateSupplySetting()
end
function FromClient_registerExpeditionUnitSuccess()
  local self = expeditionSettingInfo
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXPEDITION_REGISTER_UNIT_SUCCESS"))
  PaGlobalFunc_ExpeditionUnitSelectInfo_reOpen()
end
function FromClient_updateExpeditionUnitSuccess()
  local self = expeditionSettingInfo
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXPEDITION_UPDATE_UNIT_SUCCESS"))
  PaGlobalFunc_ExpeditionUnitSelectInfo_reOpen()
  expeditionSettingInfo:initSetting()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_ExpeditionSettingInfo_Initialize")
registerEvent("FromClient_registExpeditionSuccess", "FromClient_registExpeditionSuccess")
registerEvent("FromClient_registerExpeditionSuccess", "FromClient_registerExpeditionSuccess")
registerEvent("FromClient_fillExpeditionSuccess", "FromClient_fillExpeditionSuccess")
registerEvent("FromClient_sellExpeditionSuccess", "FromClient_sellExpeditionSuccess")
registerEvent("FromClient_refreshExpeditionSupplyPoint", "FromClient_refreshExpeditionSupplyPoint")
registerEvent("FromClient_registerExpeditionUnitSuccess", "FromClient_registerExpeditionUnitSuccess")
registerEvent("FromClient_updateExpeditionUnitSuccess", "FromClient_updateExpeditionUnitSuccess")
