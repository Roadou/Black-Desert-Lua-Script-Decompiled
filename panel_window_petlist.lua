Panel_Window_PetList:SetShow(false, false)
Panel_Window_PetList:setMaskingChild(true)
Panel_Window_PetList:ActiveMouseEventEffect(true)
Panel_Window_PetList:setGlassBackground(true)
Panel_Window_PetList:RegisterShowEventFunc(true, "PetListShowAni()")
Panel_Window_PetList:RegisterShowEventFunc(false, "PetListHideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
function PetListShowAni()
  local isShow = Panel_Window_PetList:IsShow()
  if isShow == true then
    Panel_Window_PetList:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
    local aniInfo1 = Panel_Window_PetList:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
    aniInfo1:SetStartIntensity(3)
    aniInfo1:SetEndIntensity(1)
    aniInfo1.IsChangeChild = true
    aniInfo1:SetHideAtEnd(true)
    aniInfo1:SetDisableWhileAni(true)
  else
    UIAni.fadeInSCR_Down(Panel_Window_PetList)
    Panel_Window_PetList:SetShow(true, false)
  end
end
function PetListHideAni()
  Inventory_SetFunctor(nil)
  Panel_Window_PetList:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_PetList:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
  PetList_ClosePopup()
end
local PetList = {
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
      startY = 25,
      startButtonX = 15,
      startButtonY = 10,
      gapY = 40,
      sizeY = 40,
      sizeYY = 10
    },
    slotCount = 4
  },
  _staticListBG = UI.getChildControl(Panel_Window_PetList, "Static_ListBG"),
  _staticButtonListBG = UI.getChildControl(Panel_Window_PetList, "Static_ButtonBG"),
  _staticUnsealBG = UI.getChildControl(Panel_Window_PetList, "Static_UnsealBG"),
  _staticNoticeText = UI.getChildControl(Panel_Window_PetList, "StaticText_Notice"),
  _staticSlotCount = UI.getChildControl(Panel_Window_PetList, "StaticText_Slot_Count"),
  _scroll = UI.getChildControl(Panel_Window_PetList, "Scroll_Slot_List"),
  _slots = Array.new(),
  _selectSlotNo = 0,
  _startSlotIndex = 0,
  _unseal = {}
}
function PetList:init()
  for ii = 0, self._config.slotCount - 1 do
    local slot = {}
    slot.slotNo = ii
    slot.panel = Panel_Window_PetList
    slot.button = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Static_Button", self._staticListBG, "PetList_Slot_" .. ii)
    slot.effect = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Static_Button_Effect", slot.button, "PetList_Slot_Effect_" .. ii)
    slot.icon = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Static_Icon", slot.button, "PetList_Slot_Icon_" .. ii)
    slot.name = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "StaticText_Name", slot.button, "PetList_Slot_Name_" .. ii)
    slot.state = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "StaticText_Coma", slot.button, "PetList_Slot_state_" .. ii)
    slot.maleIcon = UI.createAndCopyBasePropertyControl(Panel_Window_StableList, "Static_MaleIcon", slot.button, "PetList_Slot_IconMale_" .. ii)
    slot.femaleIcon = UI.createAndCopyBasePropertyControl(Panel_Window_StableList, "Static_FemaleIcon", slot.button, "PetList_Slot_IconFemale_" .. ii)
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
    slot.maleIcon:SetPosX(iconConfig.startX)
    slot.maleIcon:SetPosY(iconConfig.startY)
    slot.femaleIcon:SetPosX(iconConfig.startX)
    slot.femaleIcon:SetPosY(iconConfig.startY)
    slot.icon:ActiveMouseEventEffect(true)
    slot.icon:SetIgnore(true)
    slot.effect:SetIgnore(true)
    slot.name:SetIgnore(true)
    slot.maleIcon:SetIgnore(true)
    slot.femaleIcon:SetIgnore(true)
    slot.effect:SetShow(false)
    slot.button:addInputEvent("Mouse_LUp", "PetList_SlotSelect(" .. ii .. ")")
    UIScroll.InputEventByControl(slot.button, "PetList_ScrollEvent")
    UIScroll.InputEventByControl(slot.effect, "PetList_ScrollEvent")
    UIScroll.InputEventByControl(slot.icon, "PetList_ScrollEvent")
    UIScroll.InputEventByControl(slot.name, "PetList_ScrollEvent")
    UIScroll.InputEventByControl(slot.maleIcon, "PetList_ScrollEvent")
    UIScroll.InputEventByControl(slot.femaleIcon, "PetList_ScrollEvent")
    self._slots[ii] = slot
  end
  self._unseal._button = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Static_Button", self._staticUnsealBG, "PetList_Unseal_Button")
  self._unseal._icon = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Static_Icon", self._staticUnsealBG, "PetList_Unseal_Icon")
  local unsealConfig = self._config.unseal
  self._unseal._button:SetPosX(unsealConfig.startButtonX)
  self._unseal._button:SetPosY(unsealConfig.startButtonY)
  self._unseal._icon:SetPosX(unsealConfig.startIconX)
  self._unseal._icon:SetPosY(unsealConfig.startIconY)
  self._unseal._icon:SetIgnore(true)
  self._unseal._button:addInputEvent("Mouse_LUp", "PetList_ButtonOpen( 1, 0 )")
  self._buttonSeal = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Button_Seal", self._staticButtonListBG, "PetList_Button_Seal")
  self._buttonUnseal = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Button_Unseal", self._staticButtonListBG, "PetList_Button_Unseal")
  self._buttonRecovery = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Button_Recovery", self._staticButtonListBG, "PetList_Button_Recovery")
  self._buttonSell = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Button_Sell", self._staticButtonListBG, "PetList_Button_Sell")
  self._buttonRelease = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Button_Release", self._staticButtonListBG, "PetList_Button_Release")
  self._buttonChangeName = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Button_ChangeName", self._staticButtonListBG, "PetList_Button_ChangeName")
  self._buttonRegisterMating = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Button_RegisterMating", self._staticButtonListBG, "PetList_Button_RegisterMating")
  self._buttonRegisterMarket = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Button_RegisterMarket", self._staticButtonListBG, "PetList_Button_RegisterMarket")
  self._buttonReceiveChild = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Button_ReceiveChildServant", self._staticButtonListBG, "PetList_Button_ReceiveChildServant")
  self._buttonReturnMating = UI.createAndCopyBasePropertyControl(Panel_Window_PetList, "Button_ReturnMating", self._staticButtonListBG, "PetList_Button_ReturnMating")
  self._scroll:SetControlPos(0)
  Panel_Window_PetList:SetChildIndex(self._staticButtonListBG, 9999)
end
function PetList:updateSlot()
  local servantCount = stable_count()
  if 0 == servantCount then
    self._staticNoticeText:SetShow(true)
  else
    self._staticNoticeText:SetShow(false)
  end
  self._staticSlotCount:SetText(stable_currentSlotCount() .. " / " .. stable_maxSlotCount())
  for ii = 0, self._config.slotCount - 1 do
    local slot = self._slots[ii]
    slot.index = -1
    slot.button:SetShow(false)
  end
  local slotNo = 0
  for ii = self._startSlotIndex, servantCount - 1 do
    local servantInfo = stable_getServant(ii)
    if nil ~= servantInfo and slotNo <= self._config.slotCount - 1 then
      local slot = self._slots[slotNo]
      slot.name:SetText(servantInfo:getName(ii) .. [[

(]] .. servantInfo:getRegionName(ii) .. ")")
      slot.icon:ChangeTextureInfoName(servantInfo:getIconPath1())
      slot.maleIcon:SetShow(false)
      slot.femaleIcon:SetShow(false)
      if servantInfo:doMating() then
        if servantInfo:isMale() then
          slot.maleIcon:SetShow(true)
        else
          slot.femaleIcon:SetShow(true)
        end
      end
      slot.state:SetShow(false)
      slot.state:SetPosX(slot.icon:GetPosX() + slot.icon:GetSizeX() - slot.state:GetSizeX() - 10)
      slot.state:SetPosY(slot.icon:GetPosY())
      local stateText
      if CppEnums.ServantStateType.Type_Coma == servantInfo:getStateType() then
        slot.state:SetShow(true)
        stateText = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_PET_STATE_COMA")
      elseif CppEnums.ServantStateType.Type_RegisterMating == servantInfo:getStateType() then
        slot.state:SetShow(true)
        stateText = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_PET_STATE_REGISTERMATING")
      elseif CppEnums.ServantStateType.Type_Mating == servantInfo:getStateType() then
        slot.state:SetShow(true)
        if servantInfo:isMatingComplete() then
          stateText = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_PET_STATE_MATINGCOMPLETE")
        else
          stateText = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_PET_STATE_MATING")
        end
      elseif CppEnums.ServantStateType.Type_RegisterMarket == servantInfo:getStateType() then
        slot.state:SetShow(true)
        stateText = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_PET_STATE_REGISTERMARKET")
      end
      slot.state:SetText(stateText)
      slot.button:SetShow(true)
      slot.index = ii
      slotNo = slotNo + 1
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
function PetList:registEventHandler()
  UIScroll.InputEvent(self._scroll, "PetList_ScrollEvent")
  Panel_Window_PetList:addInputEvent("Mouse_UpScroll", "PetList_ScrollEvent( true  )")
  Panel_Window_PetList:addInputEvent("Mouse_DownScroll", "PetList_ScrollEvent( false )")
  self._buttonSeal:addInputEvent("Mouse_LUp", "PetList_Button_Seal( false )")
  self._buttonUnseal:addInputEvent("Mouse_LUp", "PetList_Button_Unseal()")
  self._buttonRecovery:addInputEvent("Mouse_LUp", "PetList_Button_Recovery()")
  self._buttonSell:addInputEvent("Mouse_LUp", "PetList_Button_SellToNpc()")
  self._buttonRelease:addInputEvent("Mouse_LUp", "PetList_Button_Release()")
  self._buttonChangeName:addInputEvent("Mouse_LUp", "PetList_Button_ChangeName()")
  self._buttonRegisterMating:addInputEvent("Mouse_LUp", "PetList_Button_RegisterMating()")
  self._buttonRegisterMarket:addInputEvent("Mouse_LUp", "PetList_Button_RegisterMarket()")
  self._buttonReceiveChild:addInputEvent("Mouse_LUp", "PetInfo_ReceiveChildServant()")
  self._buttonReturnMating:addInputEvent("Mouse_LUp", "PetList_RegisterCancel()")
end
function PetList:registMessageHandler()
  registerEvent("FromClient_ServantUpdate", "PetList_updateSlotData")
  registerEvent("FromClient_ServantRegisterToAuction", "PetList_updateSlotData")
  registerEvent("FromClient_GroundMouseClick", "PetList_ClosePopup")
  registerEvent("onScreenResize", "PetList_Resize")
end
function PetList_Resize()
  screenX = getScreenSizeX()
  screenY = getScreenSizeY()
  local self = PetList
  if screenY > 1000 then
    Panel_Window_PetList:SetSize(Panel_Window_PetList:GetSizeX(), 700)
    self._staticListBG:SetSize(self._staticListBG:GetSizeX(), 660)
    self._scroll:SetSize(self._scroll:GetSizeX(), 660)
    self._config.slotCount = 4
    if nil ~= self._slots[3] then
      self._slots[3].button:SetShow(true)
    end
  else
    Panel_Window_PetList:SetSize(Panel_Window_PetList:GetSizeX(), 540)
    self._staticListBG:SetSize(self._staticListBG:GetSizeX(), 500)
    self._scroll:SetSize(self._scroll:GetSizeX(), 500)
    self._config.slotCount = 3
    if nil ~= self._slots[3] then
      self._slots[3].button:SetShow(false)
    end
  end
end
function PetList_ButtonOpen(eType, slotNo)
  local self = PetList
  local iconConfig = self._config.icon
  self._buttonSeal:SetShow(false)
  self._buttonUnseal:SetShow(false)
  self._buttonRecovery:SetShow(false)
  self._buttonSell:SetShow(false)
  self._buttonRelease:SetShow(false)
  self._buttonChangeName:SetShow(false)
  self._buttonRegisterMating:SetShow(false)
  self._buttonRegisterMarket:SetShow(false)
  self._buttonReceiveChild:SetShow(false)
  self._buttonReturnMating:SetShow(false)
  local buttonList = {}
  local button_Index = 0
  local buttonConfig = self._config.button
  local positionX = 0
  local positionY = 0
  if eType == self._const.eTypeUnsealed then
    buttonList[button_Index] = self._buttonSeal
    button_Index = button_Index + 1
    positionX = self._staticUnsealBG:GetPosX() + self._staticUnsealBG:GetSizeX()
    positionY = self._staticUnsealBG:GetPosY() + 20
  elseif eType == self._const.eTypeSealed then
    local index = PetList_SelectSlotNo()
    local servantInfo = stable_getServant(index)
    if nil == servantInfo then
      return
    end
    Pet_SlotSound(slotNo)
    local getState = servantInfo:getStateType()
    local nowMating = CppEnums.ServantStateType.Type_Mating
    local regMarket = CppEnums.ServantStateType.Type_RegisterMarket
    local regMating = CppEnums.ServantStateType.Type_RegisterMating
    local doneMating = servantInfo:isMatingComplete()
    local nowHp = servantInfo:getHp()
    local maxHp = servantInfo:getMaxHp()
    local nowMp = servantInfo:getMp()
    local maxMp = servantInfo:getMaxMp()
    if nowMating ~= getState and regMating ~= getState and regMarket ~= getState then
      buttonList[button_Index] = self._buttonUnseal
      button_Index = button_Index + 1
    end
    if nowMating ~= getState and regMating ~= getState and regMarket ~= getState then
      buttonList[button_Index] = self._buttonSell
      button_Index = button_Index + 1
    end
    if nowHp < maxHp or nowMp < maxMp then
      buttonList[button_Index] = self._buttonRecovery
      button_Index = button_Index + 1
    end
    if true == servantInfo:isMale() and nowMating ~= getState and regMating ~= getState then
      buttonList[button_Index] = self._buttonRegisterMating
      button_Index = button_Index + 1
    end
    if nowMating ~= getState and regMating ~= getState and regMarket ~= getState then
      buttonList[button_Index] = self._buttonRegisterMarket
      button_Index = button_Index + 1
    end
    if doneMating and not servantInfo:isMale() then
      buttonList[button_Index] = self._buttonReceiveChild
      button_Index = button_Index + 1
    end
    if nowMating ~= getState and regMating ~= getState and regMarket ~= getState then
      buttonList[button_Index] = self._buttonChangeName
      button_Index = button_Index + 1
    end
    positionX = self._slots[slotNo].button:GetPosX() + buttonConfig.startX
    positionY = self._slots[slotNo].button:GetPosY() + buttonConfig.startY
  end
  local sizeX = self._staticButtonListBG:GetSizeX()
  local sizeY = 0
  for button_idx = 0, button_Index - 1 do
    buttonList[button_idx]:SetShow(true)
    buttonList[button_idx]:SetPosX(buttonConfig.startButtonX)
    buttonList[button_idx]:SetPosY(buttonConfig.startButtonY + buttonConfig.gapY * button_idx)
    sizeY = sizeY + buttonConfig.sizeY
  end
  if 0 == button_Index then
    self._staticButtonListBG:SetShow(false)
  else
    self._staticButtonListBG:SetPosX(positionX)
    self._staticButtonListBG:SetPosY(positionY)
    self._staticButtonListBG:SetSize(sizeX, sizeY + buttonConfig.sizeYY)
    self._staticButtonListBG:SetShow(true)
  end
  button_Index = 0
end
function PetList_SlotSelect(slotNo)
  audioPostEvent_SystemUi(0, 0)
  local self = PetList
  for ii = 0, self._config.slotCount - 1 do
    self._slots[ii].effect:SetShow(false)
  end
  if -1 == self._slots[slotNo].index then
    return
  end
  self._slots[slotNo].effect:SetShow(true)
  self._selectSlotNo = self._slots[slotNo].index
  PetInfo_Update(PetList_SelectSlotNo())
  PetList_ButtonOpen(0, slotNo)
end
function PetList_Button_Seal(isCompulsionSeal)
  audioPostEvent_SystemUi(0, 0)
  if isCompulsionSeal then
    local needGold = tostring(getServantCompulsionSealPrice())
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEFUNCTION_MESSAGEBOX_TITLE")
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEFUNCTION_COMPULSIONSEAL_MESSAGE", "cost", needGold)
    local messageboxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = PetList_Button_CompulsionSeal,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    stable_seal(false)
  end
  PetList_ClosePopup()
end
function PetList_Button_Unseal()
  audioPostEvent_SystemUi(0, 0)
  stable_unseal(PetList_SelectSlotNo())
  PetList_ClosePopup()
  local servantInfo = stable_getServant(PetList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
end
function PetList_Button_CompulsionSeal()
  stable_seal(true)
end
function PetList_Button_Recovery()
  local servantInfo = stable_getServant(PetList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  local confirmFunction
  if 0 == servantInfo:getHp() then
    needMoney = Int64toInt32(servantInfo:getReviveCost_s64())
    confirmFunction = PetList_Revive
  else
    needMoney = Int64toInt32(servantInfo:getRecoveryCost_s64())
    confirmFunction = PetList_Recovery
  end
  local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local messageboxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_PET_RECOVERY_DO_MSG", "needMoney", needMoney)
  local messageboxData = {
    title = messageboxTitle,
    content = messageboxMemo,
    functionYes = confirmFunction,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
  PetList_ClosePopup()
end
function PetList_Recovery()
  stable_recovery(PetList_SelectSlotNo())
end
function PetList_Revive()
  stable_revive(PetList_SelectSlotNo())
end
function PetList_Button_SellToNpc()
  local servantInfo = stable_getServant(PetList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  local resultMoney = Int64toInt32(servantInfo:getSellCost_s64())
  local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_PET_SELL_TITLE")
  local messageboxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_PET_SELL_MSG", "resultMoney", resultMoney)
  local messageboxData = {
    title = messageboxTitle,
    content = messageboxMemo,
    functionYes = PetList_Button_SellToNpcXXX,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
  PetList_ClosePopup()
end
function PetList_Button_SellToNpcXXX()
  stable_changeToReward(PetList_SelectSlotNo(), CppEnums.ServantToRewardType.Type_Money)
end
function PetList_Button_ChangeName()
  local servantInfo = stable_getServant(PetList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  PetRegister_OpenByChangeName(PetList_SelectSlotNo())
  PetList_ClosePopup()
end
function PetList_Button_RegisterMating()
  PetList_ButtonClose()
  audioPostEvent_SystemUi(0, 0)
  Servant_Confirm(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_PET_REGISTERMATING_TITLE"), PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_PET_REGISTERMATING_MSG"), PetList_RegisterMatingXXX, MessageBox_Empty_function)
end
function PetList_RegisterMatingXXX()
  local slotNo = PetList_SelectSlotNo()
  local servantInfo = stable_getServant(slotNo)
  if nil == servantInfo then
    return
  end
  local characterKey = CharacterKey(servantInfo:getCharacterKeyRaw())
  local minPice_s64 = servantInfo:getMinRegisterPrice_s64()
  Panel_NumberPad_Show_Min(true, minPice_s64, slotNo, PetList_RegisterMatingXXXXX)
end
function PetList_RegisterMatingXXXXX(s64_inputNumber, slotNo)
  stable_registerServantToSomeWhereElse(PetList_SelectSlotNo(), CppEnums.AuctionType.AuctionGoods_ServantMating, CppEnums.TransferType.TransferType_Normal, s64_inputNumber)
end
function PetList_Button_RegisterMarket()
  PetList_ButtonClose()
  audioPostEvent_SystemUi(0, 0)
  Servant_Confirm(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_PET_REGISTERMARKET_TITLE"), PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_PET_REGISTERMARKET_MSG"), PetList_RegisterMarketXXX, MessageBox_Empty_function)
end
function PetList_RegisterMarketXXX()
  local slotNo = PetList_SelectSlotNo()
  local servantInfo = stable_getServant(slotNo)
  if nil == servantInfo then
    return
  end
  local characterKey = CharacterKey(servantInfo:getCharacterKeyRaw())
  local minPice_s64 = servantInfo:getMinRegisterPrice_s64()
  Panel_NumberPad_Show_Min(true, minPice_s64, slotNo, PetList_RegisterMarketXXXXXX)
end
function PetList_RegisterMarketXXXXXX(s64_inputNumber, slotNo)
  stable_registerServantToSomeWhereElse(PetList_SelectSlotNo(), CppEnums.AuctionType.AuctionGoods_ServantMarket, CppEnums.TransferType.TransferType_Normal, s64_inputNumber)
end
function PetList_ClosePopup()
  local self = PetList
  if not self._staticButtonListBG:GetShow() then
    return false
  end
  self._staticButtonListBG:SetShow(false)
  return false
end
function PetList_RegisterCancel()
  PetMating_Cancel(PetList_SelectSlotNo())
end
function Pet_SlotSound(slotNo)
  if isFirstSlot then
    isFirstSlot = false
  else
    audioPostEvent_SystemUi(1, 0)
  end
end
function PetList_ScrollEvent(isScrollUp)
  local self = PetList
  local servantCount = stable_count()
  self._startSlotIndex = UIScroll.ScrollEvent(self._scroll, isScrollUp, self._config.slotCount, servantCount, self._startSlotIndex, 1)
  self:updateSlot()
  self._staticButtonListBG:SetShow(false)
end
function PetList_SlotSelectFirst()
  local self = PetList
  if -1 == self._slots[0].index then
    PetInfo_Close()
    return
  end
  PetList_SlotSelect(self._slots[0].index)
end
function PetList_ButtonClose()
  local self = PetList
  if not self._staticButtonListBG:GetShow() then
    return
  end
  self._staticButtonListBG:SetShow(false)
end
function PetList_SelectSlotNo()
  local self = PetList
  return self._selectSlotNo
end
function PetList_updateSlotData()
  if not Panel_Window_PetList:GetShow() then
    return
  end
  local self = PetList
  self:updateSlot()
end
function PetList_Open()
  if Panel_Window_PetList:IsShow() then
    return
  end
  local self = PetList
  self._selectSlotNo = 0
  self._startSlotIndex = 0
  self:updateSlot()
  UIAni.fadeInSCR_Down(Panel_Window_PetList)
  Panel_Window_PetList:SetShow(true, true)
end
function PetList_Close()
  if not Panel_Window_PetList:IsShow() then
    return
  end
  Panel_Window_PetList:SetShow(false, false)
end
function Servant_SceneView(beforeSceneIndex, afterSceneIndex)
  if beforeSceneIndex == afterSceneIndex then
    return
  end
  showSceneCharacter(beforeSceneIndex, false)
  showSceneCharacter(afterSceneIndex, true)
end
PetList:init()
PetList:registEventHandler()
PetList:registMessageHandler()
PetList_Resize()
