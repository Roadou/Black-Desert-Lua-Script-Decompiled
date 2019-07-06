Panel_Window_GuildStable_List:SetShow(false, false)
Panel_Window_GuildStable_List:setMaskingChild(true)
Panel_Window_GuildStable_List:ActiveMouseEventEffect(true)
Panel_Window_GuildStable_List:setGlassBackground(true)
Panel_Window_GuildStable_List:RegisterShowEventFunc(true, "StableListShowAni()")
Panel_Window_GuildStable_List:RegisterShowEventFunc(false, "StableListHideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_SW = CppEnums.ServantWhereType
local servantInvenAlert = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SELL_WITHITEM_MSG")
function GuildStableListShowAni()
  local isShow = Panel_Window_GuildStable_List:IsShow()
  if isShow then
    Panel_Window_GuildStable_List:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
    local aniInfo1 = Panel_Window_GuildStable_List:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
    aniInfo1:SetStartIntensity(3)
    aniInfo1:SetEndIntensity(1)
    aniInfo1.IsChangeChild = true
    aniInfo1:SetHideAtEnd(true)
    aniInfo1:SetDisableWhileAni(true)
  else
    UIAni.fadeInSCR_Down(Panel_Window_GuildStable_List)
    Panel_Window_GuildStable_List:SetShow(true, false)
  end
end
function GuildStableListHideAni()
  Inventory_SetFunctor(nil)
  Panel_Window_GuildStable_List:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_GuildStable_List:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local guildStableList = {
  _const = {
    eTypeSealed = 0,
    eTypeUnsealed = 1,
    eTypeTaming = 2
  },
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
      startEffectY = -1,
      startSexIconX = 0,
      startSexIconY = 0,
      startStateX = 23,
      startStateY = 3
    },
    unseal = {
      startX = 230,
      startY = 0,
      startTitleX = -15,
      startTitleY = 0,
      startButtonX = 25,
      startButtonY = 25,
      startIconX = 25,
      startIconY = 35,
      startEffectX = -1,
      startEffectY = -1
    },
    taming = {
      startX = 230,
      startY = 50,
      startTitleX = 30,
      startTitleY = 0,
      startButtonX = 25,
      startButtonY = 25,
      startIconX = 25,
      startIconY = 35,
      startEffectX = -1,
      startEffectY = -1
    },
    button = {
      startX = 180,
      startY = 0,
      startButtonX = 10,
      startButtonY = 10,
      gapY = 40,
      sizeY = 40,
      sizeYY = 10
    },
    slotCount = 4
  },
  _staticListBG = UI.getChildControl(Panel_Window_GuildStable_List, "Static_ListBG"),
  _staticButtonListBG = UI.getChildControl(Panel_Window_GuildStable_List, "Static_PopupBG"),
  _staticNotice = UI.getChildControl(Panel_Window_GuildStable_List, "StaticText_Notice"),
  _staticSlotCount = UI.getChildControl(Panel_Window_GuildStable_List, "StaticText_Slot_Count"),
  _scroll = UI.getChildControl(Panel_Window_GuildStable_List, "Scroll_Slot_List"),
  _slots = Array.new(),
  _selectSlotNo = nil,
  _startSlotIndex = 0,
  _selectSceneIndex = -1,
  _unseal = {},
  _taming = {},
  _servantMaxLevel = 30
}
local sellCheck = true
function guildStableList:init()
  for ii = 0, self._config.slotCount - 1 do
    local slot = {}
    slot.slotNo = ii
    slot.panel = Panel_Window_GuildStable_List
    slot.button = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Static_Button", self._staticListBG, "StableList_Slot_" .. ii)
    slot.effect = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Static_Button_Effect", slot.button, "StableList_Slot_Effect_" .. ii)
    slot.icon = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Static_Icon", slot.button, "StableList_Slot_Icon_" .. ii)
    slot.name = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Static_Name", slot.button, "StableList_Slot_Name_" .. ii)
    slot.maleIcon = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Static_MaleIcon", slot.button, "StableList_Slot_IconMale_" .. ii)
    slot.femaleIcon = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Static_FemaleIcon", slot.button, "StableList_Slot_IconFemale_" .. ii)
    slot.coma = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "StaticText_Coma", slot.button, "ServantList_Slot_Coma_" .. ii)
    slot.grade = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "StaticText_HorseGrade", slot.button, "ServantList_Slot_Grade_" .. ii)
    slot.isSeized = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "StaticText_Attachment", slot.button, "ServantList_Slot_Seized" .. ii)
    slot.unSeal = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "StaticText_SealServant", slot.button, "ServantList_Slot_UnSeal_" .. ii)
    local slotConfig = self._config.slot
    slot.button:SetPosX(slotConfig.startX)
    slot.button:SetPosY(slotConfig.startY + slotConfig.gapY * ii)
    local iconConfig = self._config.icon
    slot.icon:SetPosX(iconConfig.startX)
    slot.icon:SetPosY(iconConfig.startY)
    slot.name:SetPosX(iconConfig.startNameX)
    slot.name:SetPosY(iconConfig.startNameY)
    slot.effect:SetPosX(iconConfig.startEffectX)
    slot.effect:SetPosY(iconConfig.startEffectY)
    slot.maleIcon:SetPosX(iconConfig.startSexIconX)
    slot.maleIcon:SetPosY(iconConfig.startSexIconY)
    slot.femaleIcon:SetPosX(iconConfig.startSexIconX)
    slot.femaleIcon:SetPosY(iconConfig.startSexIconY)
    slot.coma:SetPosX(iconConfig.startStateX)
    slot.coma:SetPosY(iconConfig.startStateY)
    slot.grade:SetPosY(iconConfig.startStateY)
    slot.isSeized:SetPosX(iconConfig.startStateX)
    slot.isSeized:SetPosY(iconConfig.startStateY)
    slot.unSeal:SetPosX(iconConfig.startStateX)
    slot.unSeal:SetPosY(iconConfig.startStateY)
    slot.icon:ActiveMouseEventEffect(true)
    slot.button:addInputEvent("Mouse_LUp", "GuildStableList_SlotSelect(" .. ii .. ")")
    UIScroll.InputEventByControl(slot.button, "GuildStableList_ScrollEvent")
    self._slots[ii] = slot
  end
  self._taming._bg = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Static_BG", Panel_Window_GuildStable_List, "StableList_Taming_BG")
  self._taming._title = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "StaticText_SubTitle", self._taming._bg, "StableList_Taming_Title")
  self._taming._button = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Static_Button", self._taming._bg, "StableList_Taming_Button")
  self._taming._icon = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Static_Icon", self._taming._bg, "StableList_Taming_Icon")
  self._taming._effect = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Static_Button_Taming_Effect", self._taming._bg, "StableList_Taming_Effect")
  self._taming._title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDSTABLELIST_TAME_VEHICLE"))
  local taminglConfig = self._config.taming
  self._taming._bg:SetPosX(taminglConfig.startX)
  self._taming._bg:SetPosY(taminglConfig.startY)
  self._taming._title:SetPosX(taminglConfig.startTitleX)
  self._taming._title:SetPosY(taminglConfig.startTitleY)
  self._taming._button:SetPosX(taminglConfig.startButtonX)
  self._taming._button:SetPosY(taminglConfig.startButtonY)
  self._taming._icon:SetPosX(taminglConfig.startIconX)
  self._taming._icon:SetPosY(taminglConfig.startIconY)
  self._taming._effect:SetPosX(taminglConfig.startButtonX - 2)
  self._taming._effect:SetPosY(taminglConfig.startButtonY - 2)
  self._taming._button:addInputEvent("Mouse_LUp", "GuildStableList_ButtonOpen( 2, 0 )")
  self._buttonRegister = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Button_Register", self._staticButtonListBG, "GuildStableList_Button_Register")
  self._buttonSeal = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Button_Seal", self._staticButtonListBG, "GuildStableList_Button_Seal")
  self._buttonCompulsionSeal = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Button_CompulsionSeal", self._staticButtonListBG, "GuildStableList_Button_CompulsionSeal")
  self._buttonUnseal = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Button_Unseal", self._staticButtonListBG, "GuildStableList_Button_Unseal")
  self._buttonRepair = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Button_Repair", self._staticButtonListBG, "GuildStableList_Button_Repair")
  self._buttonRecovery = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Button_Recovery", self._staticButtonListBG, "GuildStableList_Button_Recovery")
  self._buttonRelease = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Button_Release", self._staticButtonListBG, "GuildStableList_Button_Release")
  self._buttonInjury = UI.createAndCopyBasePropertyControl(Panel_Window_GuildStable_List, "Button_Injury", self._staticButtonListBG, "GuildStableList_Button_Injury")
  self._scroll:SetControlPos(0)
  Panel_Window_GuildStable_List:SetChildIndex(self._staticButtonListBG, 9999)
end
function guildStableList:clear()
  self._selectSlotNo = nil
  self._startSlotIndex = 0
end
function guildStableList:update()
  local servantCount = guildStable_count()
  if 0 == servantCount then
    guildStableList._staticNotice:SetShow(true)
  else
    guildStableList._staticNotice:SetShow(false)
  end
  self._staticSlotCount:SetText(guildStable_currentSlotCount() .. " / " .. guildStable_maxSlotCount())
  for ii = 0, self._config.slotCount - 1 do
    local slot = self._slots[ii]
    slot.index = -1
    slot.button:SetShow(false)
  end
  if servantCount > 0 then
    GuildStableList_ServantCountInit(servantCount)
    GuildStable_SortDataupdate()
  end
  local slotNo = 0
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local regionName = regionInfo:getAreaName()
  if servantCount > 0 then
    for ii = self._startSlotIndex, servantCount - 1 do
      local sortIndex = GuildStable_SortByWayPointKey(ii)
      local servantInfo = guildStable_getServant(sortIndex)
      if nil ~= servantInfo then
        local servantRegionName = servantInfo:getRegionName()
        local currentServantRegionName = servantInfo:getRegionName(ii)
        local regionKey = servantInfo:getRegionKeyRaw()
        local regionInfoWrapper = getRegionInfoWrapper(regionKey)
        local exploerKey = regionInfoWrapper:getExplorationKey()
        local getState = servantInfo:getStateType()
        local vehicleType = servantInfo:getVehicleType()
        if slotNo <= self._config.slotCount - 1 then
          local slot = self._slots[slotNo]
          slot.maleIcon:SetShow(false)
          slot.femaleIcon:SetShow(false)
          slot.isSeized:SetShow(false)
          slot.unSeal:SetShow(false)
          slot.coma:SetShow(false)
          slot.grade:SetShow(false)
          slot.name:SetText(servantInfo:getName(ii) .. [[

(]] .. servantInfo:getRegionName(ii) .. ")")
          slot.icon:ChangeTextureInfoName(servantInfo:getIconPath1())
          slot.button:SetMonoTone(false)
          if 0 == servantInfo:getHp() and (CppEnums.VehicleType.Type_Elephant == vehicleType or CppEnums.VehicleType.Type_Train == vehicleType) then
            slot.button:SetMonoTone(true)
          else
            slot.button:SetMonoTone(false)
          end
          slot.isSeized:SetShow(false)
          slot.coma:SetShow(false)
          slot.unSeal:SetShow(false)
          if servantInfo:isSeized() then
            slot.isSeized:SetShow(true)
          elseif CppEnums.ServantStateType.Type_Coma == servantInfo:getStateType() then
            slot.coma:SetShow(true)
          elseif CppEnums.ServantStateType.Type_Field == servantInfo:getStateType() then
            slot.unSeal:SetShow(true)
            slot.unSeal:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_ISIMPRINTING"))
          end
          if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
            if servantInfo:isMale() then
              slot.maleIcon:SetShow(true)
              slot.femaleIcon:SetShow(false)
            else
              slot.maleIcon:SetShow(false)
              slot.femaleIcon:SetShow(true)
            end
            slot.grade:SetShow(true)
            slot.grade:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", servantInfo:getTier()))
          else
            slot.grade:SetShow(false)
            slot.maleIcon:SetShow(false)
            slot.femaleIcon:SetShow(false)
          end
          slot.button:SetShow(true)
          slot.index = ii
          slotNo = slotNo + 1
        end
      end
    end
  end
  self._taming._bg:SetShow(false)
  local characterKey = stable_getTamingServantCharacterKey()
  if nil ~= characterKey then
    local servantInfo = stable_getServantByCharacterKey(characterKey, 1)
    if nil ~= servantInfo then
      if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_BabyElephant then
        self._taming._icon:ChangeTextureInfoName(servantInfo:getIconPath1())
        self._taming._bg:SetShow(true)
        self._taming._bg:SetPosY(self._config.taming.startButtonY)
      else
        self._taming._bg:SetShow(false)
      end
    end
  end
  UIScroll.SetButtonSize(self._scroll, self._config.slotCount, servantCount)
  FGlobal_NeedGuildStableRegistItem_Print()
end
function FGlobal_GuildStableList_CloseTamingBg()
  local self = guildStableList
  self._taming._bg:SetShow(false)
end
function guildStableList:registEventHandler()
  UIScroll.InputEvent(self._scroll, "GuildStableList_ScrollEvent")
  Panel_Window_GuildStable_List:addInputEvent("Mouse_UpScroll", "GuildStableList_ScrollEvent( true )")
  Panel_Window_GuildStable_List:addInputEvent("Mouse_DownScroll", "GuildStableList_ScrollEvent( false )")
  self._buttonSeal:addInputEvent("Mouse_LUp", "GuildStableList_Seal( false )")
  self._buttonCompulsionSeal:addInputEvent("Mouse_LUp", "GuildStableList_Seal( true )")
  self._buttonRegister:addInputEvent("Mouse_LUp", "GuildStableList_RegisterFromTaming()")
  self._buttonRelease:addInputEvent("Mouse_LUp", "GuildStableList_Release()")
  self._buttonInjury:addInputEvent("Mouse_LUp", "GuildStableList_Injury()")
  self._buttonUnseal:addInputEvent("Mouse_LUp", "GuildStableList_Unseal()")
  self._buttonRepair:addInputEvent("Mouse_LUp", "GuildStableList_Recovery()")
  self._buttonRecovery:addInputEvent("Mouse_LUp", "GuildStableList_Recovery()")
end
function guildStableList:registMessageHandler()
  registerEvent("onScreenResize", "GuildStableList_Resize")
  registerEvent("FromClient_ServantUnseal", "GuildStableList_ServantUnseal")
  registerEvent("FromClient_ServantSeal", "GuildStableList_ServantSeal")
  registerEvent("FromClient_ServantRecovery", "GuildStableList_ServantRecovery")
  registerEvent("FromClient_ServantUpdate", "GuildStableList_UpdateSlotData")
  registerEvent("FromClient_GroundMouseClick", "GuildStableList_ButtonClose")
  registerEvent("FromClient_RegisterServantFail", "GuildStableList_PopMessageBox")
  registerEvent("FromClient_ServantToReward", "GuildStableList_ServantToReward")
  registerEvent("FromClient_ClearGuildServantDeadCount", "GuildStableList_UpdateSlotData")
end
function GuildStableList_Resize()
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  local self = guildStableList
  local panelSize = 0
  local panelBGSize = 0
  local scrollSize = 0
  local slotCount = 4
  if screenY > 1000 then
    panelSize = 700
    panelBGSize = 648
    scrollSize = 635
    slotCount = 4
    if nil ~= self._slots[3] then
      self._slots[3].button:SetShow(true)
    end
  else
    panelSize = 540
    panelBGSize = 488
    scrollSize = 475
    slotCount = 3
    if nil ~= self._slots[3] then
      self._slots[3].button:SetShow(false)
    end
  end
  Panel_Window_GuildStable_List:SetSize(Panel_Window_GuildStable_List:GetSizeX(), panelSize)
  self._staticListBG:SetSize(self._staticListBG:GetSizeX(), panelBGSize)
  self._scroll:SetSize(self._scroll:GetSizeX(), scrollSize)
  self._config.slotCount = slotCount
end
function GuildStableList_ButtonOpen(eType, slotNo)
  if Panel_Window_StableMix:GetShow() then
    return
  end
  local self = guildStableList
  self._buttonSeal:SetShow(false)
  self._buttonCompulsionSeal:SetShow(false)
  self._buttonRegister:SetShow(false)
  self._buttonUnseal:SetShow(false)
  self._buttonRepair:SetShow(false)
  self._buttonRecovery:SetShow(false)
  self._buttonRelease:SetShow(false)
  self._buttonInjury:SetShow(false)
  local buttonList = {}
  local buttonConfig = self._config.button
  local positionX = 0
  local positionY = 0
  local buttonSlotNo = 0
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local regionName = regionInfo:getAreaName()
  if eType == self._const.eTypeSealed then
    local index = GuildStableList_SelectSlotNo()
    local servantInfo = guildStable_getServant(index)
    if nil == servantInfo then
      return
    end
    local vehicleType = servantInfo:getVehicleType()
    local servantRegionName = servantInfo:getRegionName(index)
    local servantLevel = servantInfo:getLevel()
    local getState = servantInfo:getStateType()
    local deadCount = servantInfo:getDeadCount()
    if regionName == servantRegionName then
      audioPostEvent_SystemUi(1, 0)
      if deadCount >= 10 then
        if CppEnums.ServantStateType.Type_Coma ~= servantInfo:getStateType() then
          buttonList[buttonSlotNo] = self._buttonRelease
          buttonSlotNo = buttonSlotNo + 1
        end
        buttonList[buttonSlotNo] = self._buttonInjury
        buttonSlotNo = buttonSlotNo + 1
        if servantInfo:getHp() < servantInfo:getMaxHp() or servantInfo:getMp() < servantInfo:getMaxMp() then
          buttonList[buttonSlotNo] = self._buttonRecovery
          buttonSlotNo = buttonSlotNo + 1
        end
      elseif CppEnums.ServantStateType.Type_Stable == servantInfo:getStateType() then
        buttonList[buttonSlotNo] = self._buttonUnseal
        buttonSlotNo = buttonSlotNo + 1
        buttonList[buttonSlotNo] = self._buttonRelease
        buttonSlotNo = buttonSlotNo + 1
        if servantInfo:getHp() < servantInfo:getMaxHp() or servantInfo:getMp() < servantInfo:getMaxMp() then
          buttonList[buttonSlotNo] = self._buttonRecovery
          buttonSlotNo = buttonSlotNo + 1
        end
        if 0 < servantInfo:getDeadCount() then
          buttonList[buttonSlotNo] = self._buttonInjury
          buttonSlotNo = buttonSlotNo + 1
        end
      elseif CppEnums.ServantStateType.Type_Coma == servantInfo:getStateType() then
        buttonList[buttonSlotNo] = self._buttonRecovery
        buttonSlotNo = buttonSlotNo + 1
      end
    end
    if CppEnums.ServantStateType.Type_Field == servantInfo:getStateType() then
      buttonList[buttonSlotNo] = self._buttonSeal
      buttonSlotNo = buttonSlotNo + 1
      buttonList[buttonSlotNo] = self._buttonCompulsionSeal
      buttonSlotNo = buttonSlotNo + 1
    end
    positionX = self._slots[slotNo].button:GetPosX() + buttonConfig.startX
    positionY = self._slots[slotNo].button:GetPosY() + buttonConfig.startY
  else
    buttonList[buttonSlotNo] = self._buttonRegister
    buttonSlotNo = buttonSlotNo + 1
    positionX = self._taming._bg:GetPosX() + buttonConfig.startX
    positionY = self._taming._bg:GetPosY() + buttonConfig.startY
  end
  local sizeX = self._staticButtonListBG:GetSizeX()
  local sizeY = buttonConfig.sizeYY
  for index, button in pairs(buttonList) do
    button:SetShow(true)
    button:SetPosX(buttonConfig.startButtonX)
    button:SetPosY(buttonConfig.startButtonY + buttonConfig.gapY * index)
    sizeY = sizeY + buttonConfig.sizeY
  end
  if 0 ~= buttonSlotNo then
    self._staticButtonListBG:SetPosX(positionX)
    self._staticButtonListBG:SetPosY(positionY)
    self._staticButtonListBG:SetSize(sizeX, sizeY)
    self._staticButtonListBG:SetShow(true)
  else
    self._staticButtonListBG:SetShow(false)
  end
end
function GuildStableList_ButtonClose()
  local self = guildStableList
  if not self._staticButtonListBG:GetShow() then
    return false
  end
  self._staticButtonListBG:SetShow(false)
  return false
end
function GuildStableList_SlotSelect(slotNo)
  local self = guildStableList
  if nil == slotNo then
    return
  end
  if GuildStable_WindowOpenCheck() or not Panel_Window_GuildStable_List:GetShow() then
    return
  end
  audioPostEvent_SystemUi(0, 0)
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
  local servantInfo = guildStable_getServant(GuildStableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  self._selectSceneIndex = Servant_ScenePushObject(servantInfo, self._selectSceneIndex)
  if nil ~= servantInfo:getActionIndex() then
    showSceneCharacter(self._selectSceneIndex, false)
    showSceneCharacter(self._selectSceneIndex, true, servantInfo:getActionIndex())
  end
  GuildStableInfo_Open()
  GuildStableList_ButtonOpen(self._const.eTypeSealed, slotNo)
end
function GuildStableList_Seal(isCompulsion)
  local self = guildStableList
  GuildStableList_ButtonClose()
  audioPostEvent_SystemUi(0, 0)
  local servantInfo = guildStable_getServant(GuildStableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  guildStable_seal(servantInfo:getServantNo(), isCompulsion)
  GuildStableList_UpdateSlotData()
  FGlobal_Window_Servant_Update()
end
function GuildStableList_Unseal()
  local self = guildStableList
  GuildStableList_ButtonClose()
  audioPostEvent_SystemUi(0, 0)
  local servantInfo = guildStable_getServant(GuildStableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  guildStable_unseal(servantInfo:getServantNo())
  GuildStableList_UpdateSlotData()
  guildStableList._scroll:SetControlTop()
  FGlobal_Window_Servant_Update()
  self._startSlotIndex = 0
end
function GuildStableList_RecoveryUnseal()
  GuildStableList_ButtonClose()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local servantWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
  if nil == servantWrapper then
    return
  end
  local needMoney = makeDotMoney(servantWrapper:getRecoveryCost_s64())
  if servantWrapper:getRecoveryOriginalCost_s64() <= Defines.s64_const.s64_1 then
    return
  end
  guildStableList._scroll:SetControlTop()
  _startSlotIndex = 0
end
function GuildStableList_Recovery()
  GuildStableList_ButtonClose()
  local servantInfo = guildStable_getServant(GuildStableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  local function GuildStableList_RecoveryXXX()
    audioPostEvent_SystemUi(5, 7)
    guildStable_recovery(servantInfo:getServantNo())
    GuildStableInfo_Open()
  end
  local function GuildStableList_ReviveXXX()
    audioPostEvent_SystemUi(5, 7)
    guildStable_revive(servantInfo:getServantNo())
    GuildStableInfo_Open()
  end
  local needMoney = 0
  local confirmFunction
  local vehicleType = servantInfo:getVehicleType()
  if 0 == servantInfo:getHp() then
    needMoney = makeDotMoney(servantInfo:getReviveCost_s64())
    confirmFunction = GuildStableList_ReviveXXX
  else
    needMoney = makeDotMoney(servantInfo:getRecoveryCost_s64())
    confirmFunction = GuildStableList_RecoveryXXX
  end
  if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Train then
    Imprint_Notify_Title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_GUILDSTABEL_RECOVERY_NOTIFY_MSG", "needMoney", needMoney)
  end
  local Recovery_Notify_Title = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_TITLE")
  if CppEnums.VehicleType.Type_Carriage == vehicleType or CppEnums.VehicleType.Type_CowCarriage == vehicleType or CppEnums.VehicleType.Type_Boat == vehicleType or CppEnums.VehicleType.Type_Raft == vehicleType then
    Servant_Confirm(Recovery_Notify_Title, PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_CARRIAGE_RECOVERY_NOTIFY_MSG", "needMoney", needMoney), confirmFunction, MessageBox_Empty_function)
  else
    Servant_Confirm(Recovery_Notify_Title, Imprint_Notify_Title, confirmFunction, MessageBox_Empty_function)
  end
end
function GuildStableList_Release()
  GuildStableList_ButtonClose()
  local servantInfo = guildStable_getServant(GuildStableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  Servant_Confirm(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RELEASE_NOTIFY_TITLE"), PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RELEASE_NOTIFY_MSG") .. servantInvenAlert .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SELL_LETOUT_MSG"), GuildStableList_ReleaseXXX, MessageBox_Empty_function)
end
function GuildStableList_ReleaseXXX()
  local servantInfo = guildStable_getServant(GuildStableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  local servantNo = servantInfo:getServantNo()
  guildStable_changeToReward(servantNo, CppEnums.ServantToRewardType.Type_Experience)
  sellCheck = false
end
function GuildStableList_Injury()
  GuildStableList_ButtonClose()
  local servantInfo = guildStable_getServant(GuildStableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  local servantNo = servantInfo:getServantNo()
  local needMoney = guildStable_getClearGuildServantDeadCountCost_s64(servantNo)
  Servant_Confirm(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDSTABLE_RECOVERYINJURY"), PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDSTABLE_MSG_INJURYRECOVERY", "money", tostring(needMoney)), GuildStableList_InjuryXXX, MessageBox_Empty_function)
end
function GuildStableList_InjuryXXX()
  local servantInfo = guildStable_getServant(GuildStableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  local servantNo = servantInfo:getServantNo()
  guildStable_clearDeadCount(servantNo)
end
function GuildStableList_RegisterCancel()
  GuildStableList_ButtonClose()
  GuildStableMating_Cancel(GuildStableList_SelectSlotNo())
end
function FGlobal_GuildStableList_Update()
  guildStableList:update()
end
function GuildStableList_SelectSlotNo()
  local self = guildStableList
  return (GuildStable_SortByWayPointKey(self._selectSlotNo))
end
function GuildStableList_ScrollEvent(isScrollUp)
  local self = guildStableList
  local servantCount = stable_count()
  self._startSlotIndex = UIScroll.ScrollEvent(self._scroll, isScrollUp, self._config.slotCount, servantCount, self._startSlotIndex, 1)
  self:update()
  GuildStableList_ButtonClose()
end
function GuildStable_SlotSound(slotNo)
  if isFirstSlot == true then
    GuildStableList_SlotLClick(slotNo)
    isFirstSlot = false
  else
    audioPostEvent_SystemUi(1, 0)
    GuildStableList_SlotLClick(slotNo)
  end
end
function GuildStable_WindowOpenCheck()
  if Panel_Win_System:GetShow() or Panel_Window_StableRegister:GetShow() then
    return true
  end
  return false
end
function GuildStableList_RegisterFromTaming()
  GuildStableList_ButtonClose()
  audioPostEvent_SystemUi(0, 0)
  GuildStableRegister_OpenByTaming()
  Panel_FrameLoop_Widget:SetShow(false)
end
local sortByExploreKey = {}
function GuildStableList_ServantCountInit(nums)
  sortByExploreKey = {}
  for i = 1, nums do
    sortByExploreKey[i] = {
      _index = nil,
      _servantNo = nil,
      _exploreKey = nil
    }
  end
end
function GuildStable_SortDataupdate()
  local maxStableServantCount = guildStable_count()
  for ii = 1, maxStableServantCount do
    local servantInfo = guildStable_getServant(ii - 1)
    if nil ~= servantInfo then
      local regionKey = servantInfo:getRegionKeyRaw()
      local regionInfoWrapper = getRegionInfoWrapper(regionKey)
      sortByExploreKey[ii]._index = ii - 1
      sortByExploreKey[ii]._servantNo = servantInfo:getServantNo()
      sortByExploreKey[ii]._exploreKey = regionInfoWrapper:getExplorationKey()
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
  elseif 4 == myTerritoriKey then
    sortByTerritory(4)
    sortByTerritory(3)
    sortByTerritory(1)
    sortByTerritory(0)
    sortByTerritory(2)
  end
  for i = 1, maxStableServantCount do
    sortByExploreKey[i] = temp[i - 1]
  end
end
function GuildStable_SortByWayPointKey(index)
  if nil == index then
    return nil
  else
    if nil == sortByExploreKey[index + 1] then
      return nil
    end
    return sortByExploreKey[index + 1]._index
  end
end
function GuildStableList_UpdateSlotData()
  if not Panel_Window_GuildStable_List:GetShow() then
    return
  end
  local self = guildStableList
  if true == guildWharfFunction._isOpen then
    guildWharfFunction._isOpen = false
    return
  elseif true == guildStableFunction._isOpen then
    guildStableFunction._isOpen = false
    return
  end
  self:update()
  for ii = 0, self._config.slotCount - 1 do
    self._slots[ii].effect:SetShow(false)
  end
  GuildStableInfo_Close()
  if nil == GuildStableList_SelectSlotNo() then
    GuildStableInfo_Open(1)
  else
    GuildStableInfo_Open()
  end
  GuildStableList_ButtonClose()
  GuildStableList_ScrollEvent(true)
end
function GuildStableList_PopMessageBox(possibleTime_s64)
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
function GuildStableList_ServantToReward(servantNo, servantWhereType)
  if not Panel_Window_GuildStable_List:GetShow() then
    return
  end
  if UI_SW.ServantWhereTypeUser == servantWhereType then
    return
  end
  Servant_ScenePopObject(self._selectSceneIndex)
  GuildStableList_UpdateSlotData()
  FGlobal_Window_Servant_Update()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_LOOSE_SERVANT_ACK"))
end
function GuildStableList_ServantUnseal(servantNo, servantWhereType)
  if UI_SW.ServantWhereTypeGuild ~= servantWhereType then
    return
  end
  GuildStableList_UpdateSlotData()
  FGlobal_Window_Servant_Update()
  if Panel_Window_GuildStable_List:GetShow() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_GET_SERVANT_ACK"))
  end
end
function GuildStableList_ServantSeal(servantNo, regionKey, servantWhereType)
  local self = guildStableList
  if UI_SW.ServantWhereTypeGuild ~= servantWhereType then
    return
  end
  self:clear()
  GuildStableList_UpdateSlotData()
  Servant_ScenePopObject(self._selectSceneIndex)
  GuildStableList_SlotSelect(0)
  FGlobal_Window_Servant_Update()
  if Panel_Window_GuildStable_List:GetShow() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_GIVE_SERVANT_ACK"))
  end
end
function GuildStableList_ServantRecovery(servantNo, servantWhereType)
  if UI_SW.ServantWhereTypeGuild ~= servantWhereType then
    return
  end
  GuildStableList_UpdateSlotData()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_RECOVERY_ACK"))
end
function GuildStableList_Open()
  local self = guildStableList
  self:clear()
  self:update()
  UIAni.fadeInSCR_Down(Panel_Window_GuildStable_List)
  for ii = 0, self._config.slotCount - 1 do
    self._slots[ii].effect:SetShow(false)
  end
  if not Panel_Window_GuildStable_List:GetShow() then
    Panel_Window_GuildStable_List:SetShow(true)
  end
  GuildStableList_SlotSelect(0)
end
function GuildStableList_Close()
  if not Panel_Window_GuildStable_List:GetShow() then
    return
  end
  local self = guildStableList
  Servant_ScenePopObject(self._selectSceneIndex)
  self._scroll:SetControlTop()
  self._startSlotIndex = 0
  GuildStableInfo_Close()
  GuildStableList_ButtonClose()
  Panel_Window_GuildStable_List:SetShow(false)
end
guildStableList:init()
guildStableList:registEventHandler()
guildStableList:registMessageHandler()
GuildStableList_Resize()
