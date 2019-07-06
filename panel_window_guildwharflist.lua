Panel_Window_GuildWharf_List:SetShow(false, false)
Panel_Window_GuildWharf_List:setMaskingChild(true)
Panel_Window_GuildWharf_List:ActiveMouseEventEffect(true)
Panel_Window_GuildWharf_List:setGlassBackground(true)
Panel_Window_GuildWharf_List:RegisterShowEventFunc(true, "GuildWharfListShowAni()")
Panel_Window_GuildWharf_List:RegisterShowEventFunc(false, "GuildWharfListHideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_SW = CppEnums.ServantWhereType
local wharfInvenAlert = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SELL_WITHITEM_MSG")
function GuildWharfListShowAni()
  local isShow = Panel_Window_GuildWharf_List:IsShow()
  if isShow == true then
    Panel_Window_GuildWharf_List:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
    local aniInfo1 = Panel_Window_GuildWharf_List:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
    aniInfo1:SetStartIntensity(3)
    aniInfo1:SetEndIntensity(1)
    aniInfo1.IsChangeChild = true
    aniInfo1:SetHideAtEnd(true)
    aniInfo1:SetDisableWhileAni(true)
  else
    UIAni.fadeInSCR_Down(Panel_Window_GuildWharf_List)
    Panel_Window_GuildWharf_List:SetShow(true, false)
  end
end
function GuildWharfListHideAni()
  Inventory_SetFunctor(nil)
  Panel_Window_GuildWharf_List:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_GuildWharf_List:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
  GuildWharfList_ButtonClose()
end
local guildWharfList = {
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
      startButtonX = 25,
      startButtonY = 25,
      startIconX = 25,
      startIconY = 35
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
  _staticListBG = UI.getChildControl(Panel_Window_GuildWharf_List, "Static_ListBG"),
  _staticButtonListBG = UI.getChildControl(Panel_Window_GuildWharf_List, "Static_ButtonBG"),
  _staticUnsealBG = UI.getChildControl(Panel_Window_GuildWharf_List, "Static_UnsealBG"),
  _staticNoticeText = UI.getChildControl(Panel_Window_GuildWharf_List, "StaticText_Notice"),
  _staticSlotCount = UI.getChildControl(Panel_Window_GuildWharf_List, "StaticText_Slot_Count"),
  _scroll = UI.getChildControl(Panel_Window_GuildWharf_List, "Scroll_Slot_List"),
  _slots = Array.new(),
  _selectSlotNo = 0,
  _startSlotIndex = 0,
  _selectSceneIndex = -1,
  _unseal = {}
}
function guildWharfList:init()
  for ii = 0, self._config.slotCount - 1 do
    local slot = {}
    slot.slotNo = ii
    slot.panel = Panel_Window_GuildWharf_List
    slot.button = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "Static_Button", self._staticListBG, "WharfList_Slot_" .. ii)
    slot.effect = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "Static_Button_Effect", slot.button, "WharfList_Slot_Effect_" .. ii)
    slot.icon = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "Static_Icon", slot.button, "WharfList_Slot_Icon_" .. ii)
    slot.name = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "StaticText_Name", slot.button, "WharfList_Slot_Name_" .. ii)
    slot.stateComa = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "StaticText_Coma", slot.button, "WharfList_Slot_StateComa_" .. ii)
    slot.isSeized = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "StaticText_Attachment", slot.button, "WharfList_Slot_Seize_" .. ii)
    slot.unseal = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "StaticText_Unseal", slot.button, "WharfList_Slot_Unseal_" .. ii)
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
    slot.isSeized:SetPosX(iconConfig.startX)
    slot.isSeized:SetPosY(iconConfig.startY)
    slot.unseal:SetPosX(iconConfig.startX)
    slot.unseal:SetPosY(iconConfig.startY)
    slot.effect:SetPosX(iconConfig.startEffectX)
    slot.effect:SetPosY(iconConfig.startEffectY)
    slot.icon:ActiveMouseEventEffect(true)
    slot.button:addInputEvent("Mouse_LUp", "GuildWharfList_SlotSelect(" .. ii .. ")")
    UIScroll.InputEventByControl(slot.button, "GuildWharfList_ScrollEvent")
    self._slots[ii] = slot
  end
  self._unseal._button = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "Static_Button", self._staticUnsealBG, "WharfList_Unseal_Button")
  self._unseal._icon = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "Static_Icon", self._staticUnsealBG, "WharfList_Unseal_Icon")
  local unsealConfig = self._config.unseal
  self._unseal._button:SetPosX(unsealConfig.startButtonX)
  self._unseal._button:SetPosY(unsealConfig.startButtonY)
  self._unseal._icon:SetPosX(unsealConfig.startIconX)
  self._unseal._icon:SetPosY(unsealConfig.startIconY)
  self._unseal._icon:SetIgnore(true)
  self._unseal._button:addInputEvent("Mouse_LUp", "GuildWharfList_ButtonOpen( 1, 0 )")
  self._buttonSeal = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "Button_Seal", self._staticButtonListBG, "WharfList_Button_Seal")
  self._buttonCompulsionSeal = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "Button_CompulsionSeal", self._staticButtonListBG, "WharfList_Button_CompulsionSeal")
  self._buttonUnseal = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "Button_Unseal", self._staticButtonListBG, "WharfList_Button_Unseal")
  self._buttonRepair = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "Button_Repair", self._staticButtonListBG, "WharfList_Button_Repair")
  self._buttonSell = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "Button_Sell", self._staticButtonListBG, "WharfList_Button_Sell")
  self._buttonChangeName = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "Button_ChangeName", self._staticButtonListBG, "WharfList_Button_ChangeName")
  self._buttonClearDeadCount = UI.createAndCopyBasePropertyControl(Panel_Window_GuildWharf_List, "Button_KillReset", self._staticButtonListBG, "WharfList_DeadCountReset")
  self._scroll:SetControlPos(0)
  Panel_Window_GuildWharf_List:SetChildIndex(self._staticButtonListBG, 9999)
end
function guildWharfList:update()
  local servantCount = guildStable_count()
  if 0 == servantCount then
    self._staticNoticeText:SetShow(true)
  else
    self._staticNoticeText:SetShow(false)
    guildWharfList_SortDataupdate()
  end
  self._staticSlotCount:SetText(guildStable_currentSlotCount() .. " / " .. guildStable_maxSlotCount())
  for ii = 0, self._config.slotCount - 1 do
    local slot = self._slots[ii]
    slot.index = -1
    slot.button:SetShow(false)
  end
  if servantCount > 0 then
    local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
    local regionName = regionInfo:getAreaName()
    local slotNo = 0
    for ii = self._startSlotIndex, servantCount - 1 do
      local sortIndex = guildWharfList_SortByWayPointKey(ii)
      local servantInfo = guildStable_getServant(sortIndex)
      if nil ~= servantInfo then
        local servantRegionName = servantInfo:getRegionName()
        if slotNo <= self._config.slotCount - 1 then
          local slot = self._slots[slotNo]
          slot.name:SetText(servantInfo:getName(ii) .. [[

(]] .. servantInfo:getRegionName(ii) .. ")")
          slot.icon:ChangeTextureInfoName(servantInfo:getIconPath1())
          slot.stateComa:SetShow(false)
          slot.isSeized:SetShow(false)
          slot.unseal:SetShow(false)
          if servantInfo:isSeized() then
            slot.isSeized:SetShow(true)
          elseif CppEnums.ServantStateType.Type_Coma == servantInfo:getStateType() then
            slot.stateComa:SetShow(true)
          elseif CppEnums.ServantStateType.Type_Field == servantInfo:getStateType() then
            slot.unseal:SetShow(true)
            slot.unseal:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_ISIMPRINTING"))
          end
          slot.button:SetShow(true)
          slot.index = ii
          slotNo = slotNo + 1
          if regionName == servantRegionName then
            slot.button:SetMonoTone(false)
          elseif CppEnums.ServantStateType.Type_Field == servantInfo:getStateType() then
            slot.button:SetMonoTone(false)
          else
            slot.button:SetMonoTone(true)
          end
        end
      end
    end
  end
  UIScroll.SetButtonSize(self._scroll, self._config.slotCount, servantCount)
end
function guildWharfList:registEventHandler()
  UIScroll.InputEvent(self._scroll, "GuildWharfList_ScrollEvent")
  Panel_Window_GuildWharf_List:addInputEvent("Mouse_UpScroll", "GuildWharfList_ScrollEvent( true  )")
  Panel_Window_GuildWharf_List:addInputEvent("Mouse_DownScroll", "GuildWharfList_ScrollEvent( false )")
  self._buttonSeal:addInputEvent("Mouse_LUp", "GuildWharfList_Seal( false )")
  self._buttonCompulsionSeal:addInputEvent("Mouse_LUp", "GuildWharfList_Seal( true  )")
  self._buttonUnseal:addInputEvent("Mouse_LUp", "GuildWharfList_Unseal()")
  self._buttonRepair:addInputEvent("Mouse_LUp", "GuildWharfList_Recovery()")
  self._buttonSell:addInputEvent("Mouse_LUp", "GuildWharfList_SellToNpc()")
  self._buttonChangeName:addInputEvent("Mouse_LUp", "GuildWharfList_ChangeName()")
  self._buttonClearDeadCount:addInputEvent("Mouse_LUp", "GuildWharfList_ClearDeadCount()")
end
function guildWharfList:clear()
  self._selectSlotNo = nil
  self._startSlotIndex = 0
end
function guildWharfList:registMessageHandler()
  registerEvent("onScreenResize", "GuildWharfList_Resize")
  registerEvent("FromClient_ServantUnseal", "GuildWharfList_ServantUnseal")
  registerEvent("FromClient_ServantSeal", "GuildWharfList_ServantSeal")
  registerEvent("FromClient_ServantRecovery", "GuildWharfList_ServantRecovery")
  registerEvent("FromClient_ServantUpdate", "GuildWharfList_UpdateSlotData")
  registerEvent("FromClient_GroundMouseClick", "GuildWharfList_ButtonClose")
  registerEvent("FromClient_RegisterServantFail", "GuildWharfList_PopMessageBox")
end
function GuildWharfList_ServantToReward(servantNo, servantWhereType)
  if not Panel_Window_WharfStable_List:GetShow() then
    return
  end
  if UI_SW.ServantWhereTypeUser == servantWhereType then
    return
  end
  Servant_ScenePopObject(self._selectSceneIndex)
  GuildWharfList_UpdateSlotData()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_LOOSE_SERVANT_ACK"))
end
function GuildWharfList_PopMessageBox(possibleTime_s64)
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
function GuildWharfList_ServantRecovery(servantNo, servantWhereType)
  if UI_SW.ServantWhereTypeGuild ~= servantWhereType then
    return
  end
  GuildWharfList_UpdateSlotData()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_RECOVERY_ACK"))
end
function GuildWharfList_ServantSeal(servantNo, regionKey, servantWhereType)
  if UI_SW.ServantWhereTypeGuild ~= servantWhereType then
    return
  end
  guildWharfList:clear()
  GuildWharfList_UpdateSlotData()
  GuildStableList_SlotSelect(0)
  FGlobal_Window_Servant_Update()
  if Panel_Window_GuildStable_List:GetShow() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_GIVE_SERVANT_ACK"))
  end
end
function GuildWharfList_ServantUnseal(servantNo, servantWhereType)
  if UI_SW.ServantWhereTypeGuild ~= servantWhereType then
    return
  end
  GuildWharfList_UpdateSlotData()
  if Panel_Window_GuildWharf_List:GetShow() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_GET_SERVANT_ACK"))
  end
end
function GuildWharfList_Resize()
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  local self = guildWharfList
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
  Panel_Window_GuildWharf_List:SetSize(Panel_Window_GuildWharf_List:GetSizeX(), panelSize)
  self._staticListBG:SetSize(self._staticListBG:GetSizeX(), panelBGSize)
  self._scroll:SetSize(self._scroll:GetSizeX(), scrollSize)
  self._config.slotCount = slotCount
end
function GuildWharfList_ButtonOpen(eType, slotNo)
  local self = guildWharfList
  self._buttonSeal:SetShow(false)
  self._buttonCompulsionSeal:SetShow(false)
  self._buttonUnseal:SetShow(false)
  self._buttonRepair:SetShow(false)
  self._buttonSell:SetShow(false)
  self._buttonChangeName:SetShow(false)
  self._buttonClearDeadCount:SetShow(false)
  local buttonList = {}
  local buttonConfig = self._config.button
  local positionX = 0
  local positionY = 0
  local buttonSlotNo = 0
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local regionName = regionInfo:getAreaName()
  if eType == self._const.eTypeSealed then
    local index = GuildWharfList_SelectSlotNo()
    local servantInfo = guildStable_getServant(index)
    if nil == servantInfo then
      return
    end
    local vehicleType = servantInfo:getVehicleType()
    local servantRegionName = servantInfo:getRegionName(index)
    local servantLevel = servantInfo:getLevel()
    local getState = servantInfo:getStateType()
    local deadCount = servantInfo:getDeadCount()
    if CppEnums.ServantStateType.Type_Field == servantInfo:getStateType() then
      buttonList[buttonSlotNo] = self._buttonSeal
      buttonSlotNo = buttonSlotNo + 1
      buttonList[buttonSlotNo] = self._buttonCompulsionSeal
      buttonSlotNo = buttonSlotNo + 1
    elseif regionName == servantRegionName then
      audioPostEvent_SystemUi(1, 0)
      if deadCount >= 10 then
        if CppEnums.ServantStateType.Type_Coma ~= servantInfo:getStateType() then
          buttonList[buttonSlotNo] = self._buttonSell
          buttonSlotNo = buttonSlotNo + 1
        end
        buttonList[buttonSlotNo] = self._buttonClearDeadCount
        buttonSlotNo = buttonSlotNo + 1
        if servantInfo:getHp() < servantInfo:getMaxHp() then
          buttonList[buttonSlotNo] = self._buttonRepair
          buttonSlotNo = buttonSlotNo + 1
        end
      elseif CppEnums.ServantStateType.Type_Stable == servantInfo:getStateType() then
        buttonList[buttonSlotNo] = self._buttonUnseal
        buttonSlotNo = buttonSlotNo + 1
        buttonList[buttonSlotNo] = self._buttonSell
        buttonSlotNo = buttonSlotNo + 1
        if servantInfo:getHp() < servantInfo:getMaxHp() or servantInfo:getMp() < servantInfo:getMaxMp() then
          buttonList[buttonSlotNo] = self._buttonRepair
          buttonSlotNo = buttonSlotNo + 1
        end
        if deadCount > 0 then
          buttonList[buttonSlotNo] = self._buttonClearDeadCount
          buttonSlotNo = buttonSlotNo + 1
        end
      elseif CppEnums.ServantStateType.Type_Coma == servantInfo:getStateType() then
        buttonList[buttonSlotNo] = self._buttonRepair
        buttonSlotNo = buttonSlotNo + 1
      end
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
function GuildWharfList_ButtonClose()
  local self = guildWharfList
  if not self._staticButtonListBG:GetShow() then
    return false
  end
  self._staticButtonListBG:SetShow(false)
  return false
end
function GuildWharfList_SlotSelect(slotNo)
  if not Panel_Window_GuildWharf_List:GetShow() then
    return
  end
  audioPostEvent_SystemUi(0, 0)
  local self = guildWharfList
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
  local servantInfo = guildStable_getServant(GuildWharfList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  self._selectSceneIndex = Servant_ScenePushObject(servantInfo, self._selectSceneIndex)
  GuildWharfInfo_Open()
  GuildWharfList_ButtonOpen(self._const.eTypeSealed, slotNo)
end
function WharfList_UnsealSlotSelect()
  GuildWharfList_ButtonClose()
  GuildWharfList_ButtonOpen(0, slotNo)
end
function GuildWharfList_Seal(isCompulsionSeal)
  local self = guildWharfList
  audioPostEvent_SystemUi(0, 0)
  GuildWharfList_ButtonClose()
  local servantInfo = guildStable_getServant(GuildWharfList_SelectSlotNo())
  if isCompulsionSeal then
    local needGold = tostring(getServantCompulsionSealPrice())
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEFUNCTION_MESSAGEBOX_TITLE")
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWHAFT_COMPULSIONSEALDESC", "needMoney", needGold)
    Servant_Confirm(messageBoxTitle, messageBoxMemo, GuildWharfList_Button_CompulsionSeal, MessageBox_Empty_function)
  else
    guildStable_seal(servantInfo:getServantNo(), false)
  end
end
function GuildWharfList_Button_CompulsionSeal()
  local servantInfo = guildStable_getServant(GuildWharfList_SelectSlotNo())
  guildStable_seal(servantInfo:getServantNo(), true)
end
function GuildWharfList_Unseal()
  audioPostEvent_SystemUi(0, 0)
  local servantInfo = guildStable_getServant(GuildWharfList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  guildStable_unseal(servantInfo:getServantNo())
  GuildWharfList_ButtonClose()
  guildWharfList:update()
end
function GuildWharfList_Recovery()
  local servantInfo = guildStable_getServant(GuildWharfList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  local needMoney = 0
  local confirmFunction
  if 0 == servantInfo:getHp() then
    needMoney = Int64toInt32(servantInfo:getReviveCost_s64())
    confirmFunction = GuildWharfList_ReviveXXX
  else
    needMoney = Int64toInt32(servantInfo:getRecoveryCost_s64())
    confirmFunction = GuildWharfList_RecoveryXXX
  end
  local useLifeMsgFlag = CppEnums.VehicleType.Type_SailingBoat == servantInfo:getVehicleType() or CppEnums.VehicleType.Type_PersonalBattleShip == servantInfo:getVehicleType() or CppEnums.VehicleType.Type_PersonTradeShip == servantInfo:getVehicleType() or CppEnums.VehicleType.Type_CashPersonalTradeShip == servantInfo:getVehicleType() or CppEnums.VehicleType.Type_CashPersonalBattleShip == servantInfo:getVehicleType()
  local msg = useLifeMsgFlag and "LUA_SERVANT_STABEL_SHIP_RECOVERY_NOTIFY_MSG" or "LUA_SERVANT_STABEL_CARRIAGE_RECOVERY_NOTIFY_MSG"
  Servant_Confirm(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_TITLE"), PAGetStringParam1(Defines.StringSheet_GAME, msg, "needMoney", needMoney), confirmFunction, MessageBox_Empty_function)
end
function GuildWharfList_RecoveryXXX()
  audioPostEvent_SystemUi(5, 7)
  GuildWharfList_ButtonClose()
  local servantInfo = guildStable_getServant(GuildWharfList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  guildStable_recovery(servantInfo:getServantNo())
  guildWharfList:update()
end
function GuildWharfList_ReviveXXX()
  GuildWharfList_ButtonClose()
  local servantInfo = guildStable_getServant(GuildWharfList_SelectSlotNo())
  guildStable_revive(servantInfo:getServantNo())
end
function GuildWharfList_SellToNpc()
  local servantInfo = guildStable_getServant(GuildWharfList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  local resultMoney = makeDotMoney(servantInfo:getSellCost_s64())
  Servant_Confirm(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RETURN_NOTIFY_TITLE"), PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RETURN_NOTIFY_MSG") .. wharfInvenAlert, GuildWharfList_SellToNpcXXX, MessageBox_Empty_function)
end
function GuildWharfList_SellToNpcXXX()
  GuildWharfList_ButtonClose()
  local servantInfo = guildStable_getServant(GuildWharfList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  guildStable_changeToReward(servantInfo:getServantNo(), CppEnums.ServantToRewardType.Type_Experience)
  Servant_ScenePopObject(guildWharfList._selectSceneIndex)
end
function GuildWharfList_ChangeName()
  GuildWharfList_ButtonClose()
  GuildWharfRegister_OpenByChangeName()
end
function GuildWharfList_ClearDeadCount()
  GuildWharfList_ButtonClose()
  audioPostEvent_SystemUi(0, 0)
  local servantInfo = guildStable_getServant(GuildWharfList_SelectSlotNo())
  local servantNo = servantInfo:getServantNo()
  local needMoney = guildStable_getClearGuildServantDeadCountCost_s64(servantNo)
  local function clearDeadCountDo()
    guildStable_clearDeadCount(servantNo)
  end
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDSERVANTINFO_WOUND", "money", tostring(makeDotMoney(needMoney)))
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWHARF_REPAIRWOUND"),
    content = messageBoxMemo,
    functionYes = clearDeadCountDo,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function GuildWharfList_SelectSlotNo()
  if 0 == guildStable_count() then
    return nil
  end
  local self = guildWharfList
  return (guildWharfList_SortByWayPointKey(self._selectSlotNo))
end
function GuildWharfList_SlotSound(slotNo)
  if isFirstSlot then
    isFirstSlot = false
  else
    audioPostEvent_SystemUi(1, 0)
  end
end
function GuildWharfList_ScrollEvent(isScrollUp)
  local self = guildWharfList
  local servantCount = guildStable_count()
  self._startSlotIndex = UIScroll.ScrollEvent(self._scroll, isScrollUp, self._config.slotCount, servantCount, self._startSlotIndex, 1)
  self:update()
  self._staticButtonListBG:SetShow(false)
end
local sortByExploreKey = {}
function guildWharfList_ServantCountInit(nums)
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
function guildWharfList_SortDataupdate()
  local maxWharfServantCount = guildStable_count()
  guildWharfList_ServantCountInit(maxWharfServantCount)
  for ii = 1, maxWharfServantCount do
    local servantInfo = guildStable_getServant(ii - 1)
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
    elseif exploerKey > 1300 then
      territoryKey = 4
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
  elseif 1 == myTerritoriKey then
    sortByTerritory(1)
    sortByTerritory(0)
    sortByTerritory(2)
    sortByTerritory(3)
    sortByTerritory(4)
  elseif 2 == myTerritoriKey then
    sortByTerritory(2)
    sortByTerritory(1)
    sortByTerritory(0)
    sortByTerritory(3)
    sortByTerritory(4)
  elseif 3 == myTerritoriKey then
    sortByTerritory(3)
    sortByTerritory(1)
    sortByTerritory(0)
    sortByTerritory(2)
    sortByTerritory(4)
  elseif 4 == myTerritoriKey then
    sortByTerritory(4)
    sortByTerritory(3)
    sortByTerritory(1)
    sortByTerritory(0)
    sortByTerritory(2)
  end
  for i = 1, maxWharfServantCount do
    sortByExploreKey[i] = temp[i - 1]
  end
end
function guildWharfList_SortByWayPointKey(index)
  if nil == index then
    return nil
  elseif nil == sortByExploreKey[index + 1] then
    return nil
  else
    return sortByExploreKey[index + 1]._index
  end
end
function GuildWharfList_UpdateSlotData()
  if Panel_Window_GuildWharf_List:GetShow() then
    local self = guildWharfList
    self:update()
    GuildWharfInfo_Open()
  end
end
function GuildWharfList_Open()
  if Panel_Window_GuildWharf_List:IsShow() then
    return
  end
  local self = guildWharfList
  self._selectSlotNo = 0
  self._startSlotIndex = 0
  self:update()
  Panel_Window_GuildWharf_List:SetShow(true)
  for ii = 0, self._config.slotCount - 1 do
    self._slots[ii].effect:SetShow(false)
  end
  if not Panel_Window_GuildWharf_List:GetShow() then
    Panel_Window_GuildWharf_List:SetShow(true)
  end
  self._selectSceneIndex = -1
  GuildWharfList_SlotSelect(0)
end
function GuildWharfList_Close()
  if not Panel_Window_GuildWharf_List:GetShow() then
    return
  end
  local self = guildWharfList
  Servant_ScenePopObject(self._selectSceneIndex)
  GuildWharfList_ButtonClose()
  GuildWharfInfo_Close()
  GuildWharfRegister_Close()
  Panel_Window_GuildWharf_List:SetShow(false, false)
end
guildWharfList:init()
guildWharfList:registEventHandler()
guildWharfList:registMessageHandler()
GuildWharfList_Resize()
