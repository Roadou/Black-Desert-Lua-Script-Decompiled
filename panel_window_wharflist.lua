Panel_Window_WharfList:SetShow(false, false)
Panel_Window_WharfList:setMaskingChild(true)
Panel_Window_WharfList:ActiveMouseEventEffect(true)
Panel_Window_WharfList:setGlassBackground(true)
Panel_Window_WharfList:RegisterShowEventFunc(true, "WharfListShowAni()")
Panel_Window_WharfList:RegisterShowEventFunc(false, "WharfListHideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local wharfInvenAlert = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SELL_WITHITEM_MSG")
function WharfListShowAni()
  local isShow = Panel_Window_WharfList:IsShow()
  if isShow == true then
    Panel_Window_WharfList:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
    local aniInfo1 = Panel_Window_WharfList:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
    aniInfo1:SetStartIntensity(3)
    aniInfo1:SetEndIntensity(1)
    aniInfo1.IsChangeChild = true
    aniInfo1:SetHideAtEnd(true)
    aniInfo1:SetDisableWhileAni(true)
  else
    UIAni.fadeInSCR_Down(Panel_Window_WharfList)
    Panel_Window_WharfList:SetShow(true, false)
  end
end
function WharfListHideAni()
  Inventory_SetFunctor(nil)
  Panel_Window_WharfList:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_WharfList:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
  WharfList_ButtonClose()
end
local wharfList = {
  _const = {eTypeSealed = 0, eTypeUnsealed = 1},
  _config = {
    slot = {
      startX = 15,
      startY = 15,
      gapY = 158
    },
    icon = {
      startX = 0,
      startY = 0,
      startNameX = 5,
      startNameY = 120,
      startEffectX = -1,
      startEffectY = -1
    },
    unseal = {
      startX = 230,
      startY = 0,
      startButtonX = 20,
      startButtonY = 57,
      startIconX = 20,
      startIconY = 57
    },
    button = {
      startX = 180,
      startY = 0,
      startButtonX = 15,
      startButtonY = 10,
      gapY = 40,
      sizeY = 40,
      sizeYY = 10
    },
    slotCount = 4
  },
  _staticListBG = UI.getChildControl(Panel_Window_WharfList, "Static_ListBG"),
  _staticButtonListBG = UI.getChildControl(Panel_Window_WharfList, "Static_ButtonBG"),
  _staticUnsealBG = UI.getChildControl(Panel_Window_WharfList, "Static_UnsealBG"),
  _staticNoticeText = UI.getChildControl(Panel_Window_WharfList, "StaticText_Notice"),
  _staticSlotCount = UI.getChildControl(Panel_Window_WharfList, "StaticText_Slot_Count"),
  _sealedCount = UI.getChildControl(Panel_Window_WharfList, "StaticText_SealedCount"),
  _unsealedCount = UI.getChildControl(Panel_Window_WharfList, "StaticText_UnsealedCount"),
  _maxCount = UI.getChildControl(Panel_Window_WharfList, "StaticText_MaxCount"),
  _scroll = UI.getChildControl(Panel_Window_WharfList, "Scroll_Slot_List"),
  _slots = Array.new(),
  _selectSlotNo = 0,
  _startSlotIndex = 0,
  _selectSceneIndex = -1,
  _unseal = {}
}
local _initialized = false
function wharfList:init()
  for ii = 0, self._config.slotCount - 1 do
    local slot = {}
    slot.slotNo = ii
    slot.panel = Panel_Window_WharfList
    slot.button = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Static_Button", self._staticListBG, "WharfList_Slot_" .. ii)
    slot.effect = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Static_Button_Effect", slot.button, "WharfList_Slot_Effect_" .. ii)
    slot.icon = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Static_Icon", slot.button, "WharfList_Slot_Icon_" .. ii)
    slot.name = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "StaticText_Name", slot.button, "WharfList_Slot_Name_" .. ii)
    slot.stateComa = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "StaticText_Coma", slot.button, "WharfList_Slot_StateComa_" .. ii)
    slot.regionChanging = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "StaticText_RegionChanging", slot.button, "WharfList_Slot_RegionChanging_" .. ii)
    slot.isSeized = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "StaticText_Attachment", slot.button, "WharfList_Slot_Seize_" .. ii)
    local slotConfig = self._config.slot
    slot.button:SetPosX(slotConfig.startX)
    slot.button:SetPosY(slotConfig.startY + slotConfig.gapY * ii)
    local iconConfig = self._config.icon
    slot.icon:SetPosX(iconConfig.startX)
    slot.icon:SetPosY(iconConfig.startY)
    slot.name:SetPosX(iconConfig.startNameX)
    slot.name:SetPosY(iconConfig.startNameY)
    slot.stateComa:SetPosX(iconConfig.startX)
    slot.stateComa:SetPosY(iconConfig.startY)
    slot.regionChanging:SetPosX(iconConfig.startX)
    slot.regionChanging:SetPosY(iconConfig.startY)
    slot.isSeized:SetPosX(iconConfig.startX)
    slot.isSeized:SetPosY(iconConfig.startY)
    slot.effect:SetPosX(iconConfig.startEffectX)
    slot.effect:SetPosY(iconConfig.startEffectY)
    slot.icon:ActiveMouseEventEffect(true)
    slot.button:addInputEvent("Mouse_LUp", "WharfList_SlotSelect(" .. ii .. ")")
    UIScroll.InputEventByControl(slot.button, "WharfList_ScrollEvent")
    self._slots[ii] = slot
  end
  self._unseal._button = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Static_Button", self._staticUnsealBG, "WharfList_Unseal_Button")
  self._unseal._bgTitle = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "StaticText_BGTitle", self._staticUnsealBG, "StableList_Unseal_BG_Title")
  self._unseal._icon = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Static_Icon", self._staticUnsealBG, "WharfList_Unseal_Icon")
  self._unseal._effect = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Static_Button_UnSeal_Effect", self._staticUnsealBG, "StableList_Unseal_Effect")
  local unsealConfig = self._config.unseal
  self._unseal._button:SetPosX(unsealConfig.startButtonX)
  self._unseal._button:SetPosY(unsealConfig.startButtonY)
  self._unseal._icon:SetPosX(unsealConfig.startIconX)
  self._unseal._icon:SetPosY(unsealConfig.startIconY)
  self._unseal._bgTitle:ComputePos()
  self._unseal._bgTitle:SetShow(true)
  self._unseal._effect:SetPosX(unsealConfig.startButtonX - 2)
  self._unseal._effect:SetPosY(unsealConfig.startButtonY - 2)
  self._unseal._icon:SetIgnore(true)
  self._unseal._button:addInputEvent("Mouse_LUp", "WharfList_ButtonOpen( 1, 0 )")
  self._buttonSeal = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Button_Seal", self._staticButtonListBG, "WharfList_Button_Seal")
  self._buttonCompulsionSeal = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Button_CompulsionSeal", self._staticButtonListBG, "WharfList_Button_CompulsionSeal")
  self._buttonUnseal = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Button_Unseal", self._staticButtonListBG, "WharfList_Button_Unseal")
  self._buttonMove = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Button_Move", self._staticButtonListBG, "WharfList_Button_Move")
  self._buttonRepair = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Button_Repair", self._staticButtonListBG, "WharfList_Button_Repair")
  self._buttonSell = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Button_Sell", self._staticButtonListBG, "WharfList_Button_Sell")
  self._buttonChangeName = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Button_ChangeName", self._staticButtonListBG, "WharfList_Button_ChangeName")
  self._buttonClearDeadCount = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Button_KillReset", self._staticButtonListBG, "WharfList_DeadCountReset")
  self._buttonTransform = UI.createAndCopyBasePropertyControl(Panel_Window_WharfList, "Button_ChangeLook", self._staticButtonListBG, "WharfList_Button_LookChange")
  self._scroll:SetControlPos(0)
  self._sealedCount:addInputEvent("Mouse_On", "wharfList_ShowCountTooltip(" .. 0 .. ")")
  self._sealedCount:addInputEvent("Mouse_Out", "wharfList_HideCountTooltip()")
  self._unsealedCount:addInputEvent("Mouse_On", "wharfList_ShowCountTooltip(" .. 1 .. ")")
  self._unsealedCount:addInputEvent("Mouse_Out", "wharfList_HideCountTooltip()")
  self._maxCount:addInputEvent("Mouse_On", "wharfList_ShowCountTooltip(" .. 2 .. ")")
  self._maxCount:addInputEvent("Mouse_Out", "wharfList_HideCountTooltip()")
  Panel_Window_WharfList:SetChildIndex(self._staticButtonListBG, 9999)
  _initialized = true
end
function wharfList_ShowCountTooltip(iconType)
  local self = wharfList
  local uiControl, name, desc
  if 0 == iconType then
    uiControl = self._sealedCount
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WHARFLIST_SEALCOUNT_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WHARFLIST_SEALCOUNT_DESC")
  elseif 1 == iconType then
    uiControl = self._unsealedCount
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WHARFLIST_UNSEALCOUNT_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WHARFLIST_UNSEALCOUNT_DESC")
  elseif 2 == iconType then
    uiControl = self._maxCount
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WHARFLIST_MAXCOUNT_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WHARFLIST_MAXCOUNT_DESC")
  end
  TooltipSimple_Show(uiControl, name, desc)
end
function wharfList_HideCountTooltip()
  TooltipSimple_Hide()
end
function wharfList:update()
  if false == _initialized then
    return
  end
  local servantCount = stable_count()
  if 0 == servantCount then
    self._staticNoticeText:SetShow(true)
  else
    self._staticNoticeText:SetShow(false)
    wharfList_SortDataupdate()
  end
  self._staticSlotCount:SetText(stable_currentSlotCount() .. " / " .. stable_maxSlotCount())
  self._staticSlotCount:SetShow(false)
  self._sealedCount:SetShow(true)
  self._unsealedCount:SetShow(true)
  self._maxCount:SetShow(true)
  local sealedCount = stable_currentSlotCount()
  local unsealedCount = stable_currentRegionSlotCountAll() - sealedCount + Int64toInt32(stable_currentRegionSlotCountOfOtherCharacter())
  self._sealedCount:SetText(sealedCount)
  self._unsealedCount:SetText(unsealedCount)
  self._maxCount:SetText(sealedCount + unsealedCount .. " / " .. stable_maxSlotCount())
  for ii = 0, self._config.slotCount - 1 do
    local slot = self._slots[ii]
    slot.index = -1
    slot.button:SetShow(false)
  end
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local regionName = regionInfo:getAreaName()
  local slotNo = 0
  for ii = self._startSlotIndex, servantCount - 1 do
    local sortIndex = wharfList_SortByWayPointKey(ii)
    local servantInfo = stable_getServant(sortIndex)
    if nil ~= servantInfo then
      local servantRegionName = servantInfo:getRegionName()
      if slotNo <= self._config.slotCount - 1 then
        local slot = self._slots[slotNo]
        slot.name:SetText(servantInfo:getName(ii) .. [[

(]] .. servantInfo:getRegionName(ii) .. ")")
        slot.icon:ChangeTextureInfoName(servantInfo:getIconPath1())
        slot.stateComa:SetShow(false)
        slot.regionChanging:SetShow(false)
        slot.isSeized:SetShow(false)
        if servantInfo:isSeized() then
          slot.isSeized:SetShow(true)
        elseif CppEnums.ServantStateType.Type_Coma == servantInfo:getStateType() then
          slot.stateComa:SetShow(true)
        end
        slot.button:SetShow(true)
        slot.index = ii
        slotNo = slotNo + 1
        if regionName == servantRegionName then
          slot.button:SetMonoTone(false)
        else
          slot.button:SetMonoTone(true)
        end
        if servantInfo:isChangingRegion() then
          slot.regionChanging:SetShow(true)
          slot.button:SetMonoTone(true)
        end
      end
    end
  end
  self._staticUnsealBG:SetShow(false)
  local temporaryWrapper = getTemporaryInformationWrapper()
  local servantInfo = temporaryWrapper:getUnsealVehicle(stable_getServantType())
  if nil ~= servantInfo then
    self._unseal._icon:ChangeTextureInfoName(servantInfo:getIconPath1())
    self._staticUnsealBG:SetShow(true)
  end
  UIScroll.SetButtonSize(self._scroll, self._config.slotCount, servantCount)
end
function wharfList:registEventHandler()
  UIScroll.InputEvent(self._scroll, "WharfList_ScrollEvent")
  Panel_Window_WharfList:addInputEvent("Mouse_UpScroll", "WharfList_ScrollEvent( true  )")
  Panel_Window_WharfList:addInputEvent("Mouse_DownScroll", "WharfList_ScrollEvent( false )")
  self._buttonSeal:addInputEvent("Mouse_LUp", "WharfList_Seal( false )")
  self._buttonCompulsionSeal:addInputEvent("Mouse_LUp", "WharfList_Seal( true  )")
  self._buttonUnseal:addInputEvent("Mouse_LUp", "WharfList_Unseal()")
  self._buttonMove:addInputEvent("Mouse_LUp", "WharfList_HandleMoveButtonClick()")
  self._buttonRepair:addInputEvent("Mouse_LUp", "WharfList_Recovery()")
  self._buttonSell:addInputEvent("Mouse_LUp", "WharfList_SellToNpc()")
  self._buttonChangeName:addInputEvent("Mouse_LUp", "WharfList_ChangeName()")
  self._buttonClearDeadCount:addInputEvent("Mouse_LUp", "WharfList_ClearDeadCount()")
end
function wharfList:registMessageHandler()
  registerEvent("onScreenResize", "WharfList_Resize")
  registerEvent("FromClient_ServantUpdate", "WharfList_updateSlotData")
  registerEvent("FromClient_GroundMouseClick", "WharfList_ButtonClose")
  registerEvent("FromClient_OnChangeServantRegion", "ChangeServantRegion_HandleUpdate")
  registerEvent("FromClient_ServantTransform", "applyTransform")
end
function applyTransform(servantNo)
  if false == Panel_Window_WharfList:GetShow() then
    return
  end
  local index = WharfList_SelectSlotNo()
  local servantInfo = stable_getServant(index)
  if nil == servantInfo then
    return
  end
  if servantNo ~= servantInfo:getServantNo() then
    return
  end
  local self = wharfList
  self._selectSceneIndex = Servant_ScenePushObject(servantInfo, self._selectSceneIndex)
end
function WharfList_Resize()
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  local self = wharfList
  local panelSize = 0
  local panelBGSize = 0
  local scrollSize = 0
  local slotCount = 4
  if screenY > 1000 then
    panelSize = 700
    panelBGSize = 645
    scrollSize = 635
    slotCount = 4
    if nil ~= self._slots[3] then
      self._slots[3].button:SetShow(true)
    end
  else
    panelSize = 540
    panelBGSize = 485
    scrollSize = 475
    slotCount = 3
    if nil ~= self._slots[3] then
      self._slots[3].button:SetShow(false)
    end
  end
  Panel_Window_WharfList:SetSize(Panel_Window_WharfList:GetSizeX(), panelSize + 30)
  self._sealedCount:ComputePos()
  self._unsealedCount:ComputePos()
  self._maxCount:ComputePos()
  self._staticListBG:SetSize(self._staticListBG:GetSizeX(), panelBGSize)
  self._scroll:SetSize(self._scroll:GetSizeX(), scrollSize)
  self._config.slotCount = slotCount
end
local beforeSlotNo, beforeEType
function WharfList_ButtonOpen(eType, slotNo)
  local self = wharfList
  changeServantRegion:close()
  if self._staticButtonListBG:GetShow() and nil ~= beforeSlotNo and beforeSlotNo == slotNo and nil ~= beforeEType and beforeEType == eType then
    self._staticButtonListBG:SetShow(false)
    return
  end
  beforeSlotNo = slotNo
  beforeEType = eType
  self._buttonSeal:SetShow(false)
  self._buttonCompulsionSeal:SetShow(false)
  self._buttonUnseal:SetShow(false)
  self._buttonMove:SetShow(false)
  self._buttonRepair:SetShow(false)
  self._buttonSell:SetShow(false)
  self._buttonChangeName:SetShow(false)
  self._buttonClearDeadCount:SetShow(false)
  self._buttonTransform:SetShow(false)
  self._unseal._effect:SetShow(false)
  self._unseal._effect:SetShow(false)
  if Panel_Window_HorseLookChange:GetShow() then
    Panel_WharfLookChange_Close()
  end
  local buttonList = {}
  local button_Index = 0
  local buttonConfig = self._config.button
  local positionX = 0
  local positionY = 0
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local regionName = regionInfo:getAreaName()
  if eType == self._const.eTypeSealed then
    local index = WharfList_SelectSlotNo()
    local servantInfo = stable_getServant(index)
    if nil == servantInfo then
      return
    elseif servantInfo:isChangingRegion() then
      WharfList_ButtonClose()
      return
    end
    WharfList_SlotSound(slotNo)
    local servantRegionName = servantInfo:getRegionName()
    local getState = servantInfo:getStateType()
    local nowHp = servantInfo:getHp()
    local maxHp = servantInfo:getMaxHp()
    local nowMp = servantInfo:getMp()
    local maxMp = servantInfo:getMaxMp()
    local vehicleType = servantInfo:getVehicleType()
    local showChangeRegionButtonFlag = false
    if regionName == servantRegionName then
      buttonList[button_Index] = self._buttonUnseal
      button_Index = button_Index + 1
      showChangeRegionButtonFlag = not servantInfo:isChangingRegion()
      if nowHp < maxHp then
        buttonList[button_Index] = self._buttonRepair
        button_Index = button_Index + 1
      end
      if nowHp == maxHp and nowMp < maxMp and (CppEnums.VehicleType.Type_PersonTradeShip == vehicleType or CppEnums.VehicleType.Type_PersonalBattleShip == vehicleType or CppEnums.VehicleType.Type_CashPersonalTradeShip == vehicleType or CppEnums.VehicleType.Type_CashPersonalBattleShip == vehicleType) then
        buttonList[button_Index] = self._buttonRepair
        button_Index = button_Index + 1
      end
      _PA_LOG("GG", "GGGGGGGGGGG:" .. tostring(vehicleType))
      if FGlobal_IsCommercialService() then
        buttonList[button_Index] = self._buttonChangeName
        button_Index = button_Index + 1
      end
      if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Camel or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Donkey or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant then
        self._buttonClearDeadCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_KILLCOUNTRESET"))
      elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Carriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_CowCarriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_RepairableCarriage then
        self._buttonClearDeadCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_DESTROYCOUNTRESET"))
      elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Boat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Raft or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_FishingBoat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_SailingBoat then
        self._buttonClearDeadCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_DESTROYCOUNTRESET"))
      end
      if FGlobal_IsCommercialService() then
        buttonList[button_Index] = self._buttonClearDeadCount
        button_Index = button_Index + 1
      end
      buttonList[button_Index] = self._buttonSell
      button_Index = button_Index + 1
    elseif 0 == nowHp then
      buttonList[button_Index] = self._buttonRepair
      button_Index = button_Index + 1
    end
    if showChangeRegionButtonFlag and changeServantRegion:isEnabled() then
      buttonList[button_Index] = self._buttonMove
      button_Index = button_Index + 1
    end
    if true == _ContentsGroup_SailBoatCash and (CppEnums.VehicleType.Type_PersonTradeShip == servantInfo:getVehicleType() or CppEnums.VehicleType.Type_PersonalBattleShip == servantInfo:getVehicleType()) then
      buttonList[button_Index] = self._buttonTransform
      button_Index = button_Index + 1
      self._buttonTransform:addInputEvent("Mouse_LUp", "WharfList_LookChange(" .. slotNo .. ")")
    end
    positionX = self._slots[slotNo].button:GetPosX() + buttonConfig.startX
    positionY = self._slots[slotNo].button:GetPosY() + buttonConfig.startY
    FGlobal_WharfList_UnsealInfo(0)
  elseif eType == self._const.eTypeUnsealed then
    buttonList[button_Index] = self._buttonSeal
    buttonList[button_Index + 1] = self._buttonCompulsionSeal
    button_Index = button_Index + 2
    for ii = 0, self._config.slotCount - 1 do
      self._slots[ii].effect:SetShow(false)
    end
    local temporaryWrapper = getTemporaryInformationWrapper()
    if nil == temporaryWrapper then
      return
    end
    self._unseal._effect:SetShow(true)
    positionX = self._staticUnsealBG:GetPosX() + self._staticUnsealBG:GetSizeX()
    positionY = self._staticUnsealBG:GetPosY() + 20
    FGlobal_WharfList_UnsealInfo(1)
  end
  local sizeX = self._staticButtonListBG:GetSizeX()
  local sizeY = buttonConfig.sizeYY
  if #buttonList > 0 then
    for index, button in pairs(buttonList) do
      button:SetShow(true)
      button:SetPosX(buttonConfig.startButtonX - 5)
      button:SetPosY(buttonConfig.startButtonY + buttonConfig.gapY * index)
      sizeY = sizeY + buttonConfig.sizeY
    end
    self._staticButtonListBG:SetPosX(positionX)
    self._staticButtonListBG:SetPosY(positionY)
    self._staticButtonListBG:SetSize(sizeX, sizeY)
    self._staticButtonListBG:SetShow(true)
  else
    self._staticButtonListBG:SetShow(false)
  end
  button_Index = 0
end
function WharfList_ButtonClose()
  local self = wharfList
  if not self._staticButtonListBG:GetShow() then
    return false
  end
  self._staticButtonListBG:SetShow(false)
  changeServantRegion:close()
  return false
end
function WharfList_SlotSelect(slotNo)
  if not Panel_Window_WharfList:GetShow() then
    return
  end
  audioPostEvent_SystemUi(0, 0)
  local self = wharfList
  if slotNo >= self._config.slotCount then
    self._startSlotIndex = slotNo - self._config.slotCount
    self:update()
    return
  end
  if -1 == self._slots[slotNo].index then
    return
  end
  for ii = 0, self._config.slotCount - 1 do
    self._slots[ii].effect:SetShow(false)
  end
  self._slots[slotNo].effect:SetShow(true)
  self._selectSlotNo = self._slots[slotNo].index
  local servantInfo = stable_getServant(WharfList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  self._selectSceneIndex = Servant_ScenePushObject(servantInfo, self._selectSceneIndex)
  WharfInfo_Open()
  WharfList_ButtonOpen(self._const.eTypeSealed, slotNo)
end
function WharfList_UnsealSlotSelect()
  WharfList_ButtonClose()
  WharfList_ButtonOpen(0, slotNo)
end
function WharfList_HandleMoveButtonClick()
  local index = WharfList_SelectSlotNo()
  local servantInfo = stable_getServant(index)
  if nil == servantInfo then
    return
  end
  local posX = wharfList._staticButtonListBG:GetParentPosX() + wharfList._staticButtonListBG:GetSizeX()
  local posY = wharfList._staticButtonListBG:GetParentPosY()
  changeServantRegion:open(servantInfo:getServantNo(), posX, posY)
end
function WharfList_Seal(isCompulsionSeal)
  local self = wharfList
  audioPostEvent_SystemUi(0, 0)
  WharfList_ButtonClose()
  if isCompulsionSeal then
    local needGold = tostring(getServantCompulsionSealPrice())
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEFUNCTION_MESSAGEBOX_TITLE")
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WHAFT_COMPULSIONSEALDESC", "needMoney", needGold)
    Servant_Confirm(messageBoxTitle, messageBoxMemo, WharfList_Button_CompulsionSeal, MessageBox_Empty_function)
  else
    stable_seal(false)
  end
  WharfInfo_Close()
  for ii = 0, self._config.slotCount - 1 do
    self._slots[ii].effect:SetShow(false)
  end
end
function WharfList_Button_CompulsionSeal()
  stable_seal(true)
end
function WharfList_Unseal()
  audioPostEvent_SystemUi(0, 0)
  local self = wharfList
  stable_unseal(WharfList_SelectSlotNo())
  WharfList_ButtonClose()
  for ii = 0, self._config.slotCount - 1 do
    self._slots[ii].effect:SetShow(false)
  end
end
function WharfList_Recovery()
  local servantInfo = stable_getServant(WharfList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  local needMoney = 0
  local confirmFunction
  local isVehicleType = servantInfo:getVehicleType()
  if 0 == servantInfo:getHp() then
    needMoney = Int64toInt32(servantInfo:getReviveCost_s64())
    confirmFunction = WharfList_ReviveXXX
  else
    needMoney = Int64toInt32(servantInfo:getRecoveryCost_s64())
    confirmFunction = WharfList_RecoveryXXX
  end
  if CppEnums.VehicleType.Type_SailingBoat == isVehicleType or CppEnums.VehicleType.Type_PersonalBattleShip == isVehicleType or CppEnums.VehicleType.Type_PersonTradeShip == isVehicleType or CppEnums.VehicleType.Type_CashPersonalTradeShip == isVehicleType or CppEnums.VehicleType.Type_CashPersonalBattleShip == isVehicleType then
    local messageData = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SHIP_RECOVERY_NOTIFY_MSG", "needMoney", needMoney)
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageData,
      functionApply = confirmFunction,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBoxCheck.showMessageBox(messageBoxData)
  else
    local messageData = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_CARRIAGE_RECOVERY_NOTIFY_MSG", "needMoney", needMoney)
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageData,
      functionApply = confirmFunction,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBoxCheck.showMessageBox(messageBoxData)
  end
end
function WharfList_RecoveryXXX()
  audioPostEvent_SystemUi(5, 7)
  WharfList_ButtonClose()
  stable_recovery(WharfList_SelectSlotNo(), MessageBoxCheck.isCheck())
end
function WharfList_ReviveXXX()
  WharfList_ButtonClose()
  stable_revive(WharfList_SelectSlotNo(), MessageBoxCheck.isCheck())
end
function WharfList_SellToNpc()
  local servantInfo = stable_getServant(WharfList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  local resultMoney = makeDotMoney(servantInfo:getSellCost_s64())
  Servant_Confirm(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SELL_NOTIFY_TITLE"), PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SELL_NOTIFY_MSG", "resultMoney", resultMoney) .. wharfInvenAlert, WharfList_SellToNpcXXX, MessageBox_Empty_function)
end
function WharfList_SellToNpcXXX()
  WharfList_ButtonClose()
  stable_changeToReward(WharfList_SelectSlotNo(), CppEnums.ServantToRewardType.Type_Experience)
end
function WharfList_ChangeName()
  WharfList_ButtonClose()
  WharfRegister_OpenByChangeName()
end
function WharfList_ClearDeadCount()
  WharfList_ButtonClose()
  audioPostEvent_SystemUi(0, 0)
  local clearDeadCountDo = function()
    stable_clearDeadCount(WharfList_SelectSlotNo())
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
local lookIndex = 0
local currentPage = 0
function WharfList_LookChange(slotNo)
  PaGlobal_StableType = CppEnums.ServantType.Type_Ship
  WharfList_ButtonClose()
  audioPostEvent_SystemUi(0, 0)
  local servantInfo = stable_getServant(slotNo)
  if nil == servantInfo then
    return
  end
  currentPage = 0
  Panel_LookChange_Open()
  PaGlobal_ServantChangeFormPanel._staticText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WHARFLIST_CHANGECONFIRM_TITLE"))
  PaGlobal_ServantChangeFormPanel._comboBox:SetShow(false)
  PaGlobal_ServantChangeFormPanel._btnPremium:SetShow(false)
  PaGlobal_ServantChangeFormPanel._btnChange:SetShow(false)
  PaGlobal_ServantChangeFormPanel._btnShipChange:SetShow(true)
  WharfInfo_Close()
  WharfLookChange_Set()
end
function WharfLookChange_Set(isNext, index)
  local slotNo = WharfList_SelectSlotNo()
  if nil == slotNo then
    return
  end
  local servantInfo = stable_getServant(slotNo)
  if nil == servantInfo then
    return
  end
  local self = wharfList
  local fromCharacterKey = servantInfo:getCharacterKeyRaw()
  local transformManager = getServantTransformManager()
  local lookCount = 1
  PaGlobal_ServantChangeFormPanel._LCSelectSlot:SetShow(false)
  if transformManager:size() <= 0 then
    return
  end
  if nil ~= isNext then
    currentPage = currentPage + isNext
  end
  if nil == index then
    index = 0
  end
  lookIndex = currentPage * PaGlobal_ServantChangeFormPanel._lookChangeMaxSlotCount + index
  lookCount = transformManager:getFormListSize(fromCharacterKey)
  local maxPage = math.ceil(lookCount / PaGlobal_ServantChangeFormPanel._lookChangeMaxSlotCount)
  if maxPage > 1 then
    PaGlobal_ServantChangeFormPanel._textPage:SetText("( " .. currentPage + 1 .. " / " .. maxPage .. " )")
    PaGlobal_ServantChangeFormPanel._textPage:SetShow(true)
  else
    PaGlobal_ServantChangeFormPanel._textPage:SetShow(false)
  end
  for ii = 1, PaGlobal_ServantChangeFormPanel._lookChangeMaxSlotCount do
    PaGlobal_ServantLookChangeSlot[ii]:SetShow(false)
  end
  if currentPage > 0 then
    PaGlobal_ServantChangeFormPanel._btnLeft:SetShow(true)
  else
    PaGlobal_ServantChangeFormPanel._btnLeft:SetShow(false)
  end
  local showCount = 1
  if maxPage - currentPage - 1 > 0 then
    showCount = PaGlobal_ServantChangeFormPanel._lookChangeMaxSlotCount
    PaGlobal_ServantChangeFormPanel._btnRight:SetShow(true)
  else
    PaGlobal_ServantChangeFormPanel._btnRight:SetShow(false)
    local leftCount = lookCount % PaGlobal_ServantChangeFormPanel._lookChangeMaxSlotCount
    if 0 == leftCount then
      showCount = 0
    else
      showCount = leftCount
    end
  end
  local formInfo
  local isSet = false
  if showCount > 0 then
    for ii = 1, showCount do
      PaGlobal_ServantLookChangeSlot[ii]:SetShow(true)
      local value = currentPage * PaGlobal_ServantChangeFormPanel._lookChangeMaxSlotCount + ii - 1
      formInfo = transformManager:getFormStaticWrapper(fromCharacterKey, value)
      if nil ~= formInfo then
        isSet = true
        PaGlobal_ServantLookChangeSlot[ii]:ChangeTextureInfoName(formInfo:getIcon1())
      end
    end
  end
  PaGlobal_ServantChangeFormPanel._textCurrentLook:SetShow(false)
  formInfo = transformManager:getFormStaticWrapper(fromCharacterKey, lookIndex)
  if isSet == false or nil ~= formInfo and fromCharacterKey == formInfo:getTransformCharacterKey() then
    PaGlobal_ServantChangeFormPanel._btnShipChange:SetIgnore(true)
    PaGlobal_ServantChangeFormPanel._btnShipChange:SetMonoTone(true)
  else
    PaGlobal_ServantChangeFormPanel._LCSelectSlot:SetShow(true)
    PaGlobal_ServantChangeFormPanel._btnShipChange:SetIgnore(false)
    PaGlobal_ServantChangeFormPanel._btnShipChange:SetMonoTone(false)
    self._selectSceneIndex = Servant_ScenePushObjectByKey(formInfo:getTransformCharacterKey(), self._selectSceneIndex)
  end
end
function WharfLookChange_ChangeConfirm()
  local slotNo = WharfList_SelectSlotNo()
  if nil == slotNo then
    return
  end
  local servantInfo = stable_getServant(slotNo)
  if nil == servantInfo then
    return
  end
  local formManager = getServantTransformManager()
  local formIndex
  local chracterKey = servantInfo:getCharacterKeyRaw()
  lookCount = formManager:getFormListSize(chracterKey)
  if lookCount <= lookIndex then
    return
  end
  local formInfo = formManager:getFormStaticWrapper(chracterKey, lookIndex)
  if nil == formInfo then
    return
  end
  formIndex = formInfo:getTransformIndex()
  local function changeConfirm()
    stable_servantTransform(slotNo, formIndex)
    wharfList:update()
    Panel_WharfLookChange_Close()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_WHARFLIST_CHANGECONFIRM_MEMO")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WHARFLIST_CHANGECONFIRM_TITLE"),
    content = messageBoxMemo,
    functionYes = changeConfirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function Panel_WharfLookChange_Close()
  if false == Panel_Window_HorseLookChange:GetShow() then
    return
  end
  local slotNo = WharfList_SelectSlotNo()
  if nil == slotNo then
    return
  end
  local servantInfo = stable_getServant(slotNo)
  if nil == servantInfo then
    return
  end
  Panel_Window_HorseLookChange:SetShow(false)
  local self = wharfList
  self._selectSceneIndex = Servant_ScenePushObject(servantInfo, self._selectSceneIndex)
  if Panel_Window_WharfList:GetShow() then
    WharfInfo_Open()
  end
end
function WharfList_SelectSlotNo()
  local self = wharfList
  return (wharfList_SortByWayPointKey(self._selectSlotNo))
end
function WharfList_SlotSound(slotNo)
  if isFirstSlot then
    isFirstSlot = false
  else
    audioPostEvent_SystemUi(1, 0)
  end
end
function WharfList_ScrollEvent(isScrollUp)
  local self = wharfList
  local servantCount = stable_count()
  self._startSlotIndex = UIScroll.ScrollEvent(self._scroll, isScrollUp, self._config.slotCount, servantCount, self._startSlotIndex, 1)
  self:update()
  self._staticButtonListBG:SetShow(false)
end
local sortByExploreKey = {}
function wharfList_ServantCountInit(nums)
  sortByExploreKey = {}
  for i = 1, nums do
    sortByExploreKey[i] = {
      _index = nil,
      _servantNo = nil,
      _exploreKey = nil,
      _areaName = nil
    }
  end
end
function wharfList_SortDataupdate()
  local maxWharfServantCount = stable_count()
  wharfList_ServantCountInit(maxWharfServantCount)
  for ii = 1, maxWharfServantCount do
    local servantInfo = stable_getServant(ii - 1)
    if nil ~= servantInfo then
      local regionKey = servantInfo:getRegionKeyRaw()
      local regionInfoWrapper = getRegionInfoWrapper(regionKey)
      sortByExploreKey[ii]._index = ii - 1
      sortByExploreKey[ii]._servantNo = servantInfo:getServantNo()
      sortByExploreKey[ii]._exploreKey = regionInfoWrapper:getExplorationKey()
      sortByExploreKey[ii]._areaName = regionInfoWrapper:getAreaName()
    end
  end
  local sortExplaoreKey = function(a, b)
    if a._exploreKey < b._exploreKey then
      return true
    end
    return false
  end
  table.sort(sortByExploreKey, sortExplaoreKey)
  local myRegionKey = getSelfPlayer():getRegionKey():get()
  local myRegionInfoWrapper = getRegionInfoWrapper(myRegionKey)
  local myWayPointKey = myRegionInfoWrapper:getExplorationKey()
  local areaName = myRegionInfoWrapper:getAreaName()
  local matchCount = 0
  local areaSortCount = 0
  local temp = {}
  local temp1 = {}
  for i = 1, maxWharfServantCount do
    if myWayPointKey == sortByExploreKey[i]._exploreKey then
      temp1[matchCount] = sortByExploreKey[i]
      matchCount = matchCount + 1
    end
  end
  for ii = 0, matchCount - 1 do
    if areaName == temp1[ii]._areaName then
      temp[areaSortCount] = temp1[ii]
      areaSortCount = areaSortCount + 1
    end
  end
  for ii = 0, matchCount - 1 do
    if areaName ~= temp1[ii]._areaName then
      temp[areaSortCount] = temp1[ii]
      areaSortCount = areaSortCount + 1
    end
  end
  for i = 1, maxWharfServantCount do
    if myWayPointKey ~= sortByExploreKey[i]._exploreKey then
      temp[matchCount] = sortByExploreKey[i]
      matchCount = matchCount + 1
    end
  end
  for i = 1, maxWharfServantCount do
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
    elseif exploerKey > 1300 and exploerKey < 1395 then
      territoryKey = 4
    else
      territoryKey = 5
    end
    return territoryKey
  end
  local sIndex = 0
  local function sortByTerritory(territoryKey)
    for servantIndex = 1, maxWharfServantCount do
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
    sortByTerritory(4)
    sortByTerritory(5)
  elseif 1 == myTerritoriKey then
    sortByTerritory(1)
    sortByTerritory(0)
    sortByTerritory(2)
    sortByTerritory(3)
    sortByTerritory(4)
    sortByTerritory(5)
  elseif 2 == myTerritoriKey then
    sortByTerritory(2)
    sortByTerritory(1)
    sortByTerritory(0)
    sortByTerritory(3)
    sortByTerritory(4)
    sortByTerritory(5)
  elseif 3 == myTerritoriKey then
    sortByTerritory(3)
    sortByTerritory(1)
    sortByTerritory(0)
    sortByTerritory(2)
    sortByTerritory(4)
    sortByTerritory(5)
  elseif 4 == myTerritoriKey then
    sortByTerritory(4)
    sortByTerritory(3)
    sortByTerritory(1)
    sortByTerritory(0)
    sortByTerritory(2)
    sortByTerritory(5)
  elseif 5 == myTerritoriKey then
    sortByTerritory(5)
    sortByTerritory(0)
    sortByTerritory(2)
    sortByTerritory(3)
    sortByTerritory(4)
    sortByTerritory(1)
  end
  for i = 1, maxWharfServantCount do
    sortByExploreKey[i] = temp[i - 1]
  end
end
function wharfList_SortByWayPointKey(index)
  if nil == index then
    return nil
  elseif nil == sortByExploreKey[index + 1] then
    return nil
  else
    return sortByExploreKey[index + 1]._index
  end
end
function WharfList_updateSlotData()
  if not Panel_Window_WharfList:GetShow() then
    return
  end
  local self = wharfList
  self:update()
end
function WharfList_Open()
  if Panel_Window_WharfList:IsShow() then
    return
  end
  local self = wharfList
  self._selectSlotNo = 0
  self._startSlotIndex = 0
  self:update()
  Panel_Window_WharfList:SetShow(true)
  for ii = 0, self._config.slotCount - 1 do
    self._slots[ii].effect:SetShow(false)
  end
  if not Panel_Window_WharfList:GetShow() then
    Panel_Window_WharfList:SetShow(true)
  end
  self._selectSceneIndex = -1
  local temporaryWrapper = getTemporaryInformationWrapper()
  local wharfInfo = temporaryWrapper:getUnsealVehicle(stable_getServantType())
  if nil ~= wharfInfo then
    WharfList_ButtonOpen(1, 0)
  else
    WharfList_SlotSelect(0)
  end
end
function WharfList_Close()
  if not Panel_Window_WharfList:GetShow() then
    return
  end
  local self = wharfList
  Servant_ScenePopObject(self._selectSceneIndex)
  WharfList_ButtonClose()
  WharfRegister_Close()
  Panel_WharfLookChange_Close()
  WharfInfo_Close()
  Panel_Window_WharfList:SetShow(false, false)
end
wharfList:init()
wharfList:registEventHandler()
wharfList:registMessageHandler()
WharfList_Resize()
