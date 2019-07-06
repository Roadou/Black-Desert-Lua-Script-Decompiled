Panel_Window_Camp:SetShow(false)
Panel_Window_Camp:setGlassBackground(true)
Panel_Window_Camp:ActiveMouseEventEffect(true)
Panel_Icon_Camp:ActiveMouseEventEffect(true)
PaGlobal_Camp = {
  _ui = {
    _btn_UnSealTent = UI.getChildControl(Panel_Window_Camp, "Button_UnsealTent"),
    _unsealBG = UI.getChildControl(Panel_Window_Camp, "Static_UnsealCampBg"),
    _btn_InvenOpen = UI.getChildControl(Panel_Window_Camp, "Button_Warehouse"),
    _btn_Repair = UI.getChildControl(Panel_Window_Camp, "Button_Repair"),
    _btn_ShopOpen = UI.getChildControl(Panel_Window_Camp, "Button_Shop"),
    _btn_Close = UI.getChildControl(Panel_Window_Camp, "Button_Win_Close"),
    _btn_Seal = UI.getChildControl(Panel_Window_Camp, "Button_SealTent"),
    _btn_RemoteSeal = UI.getChildControl(Panel_Window_Camp, "Button_RemoteSealTent"),
    _guideIcon = UI.getChildControl(Panel_Window_Camp, "Static_GuideIcon"),
    _txtTitle = UI.getChildControl(Panel_Window_Camp, "Static_Panel_Camp_Tent_Title"),
    _titleBG = UI.getChildControl(Panel_Window_Camp, "Static_Panel_Camp_TitleBG"),
    _contentBG = UI.getChildControl(Panel_Window_Camp, "Static_Panel_Camp_Tent_Content_Bg"),
    _txtTentTitle = UI.getChildControl(Panel_Window_Camp, "StaticText_TentSlotTitle"),
    _slotBg = {
      [3] = UI.getChildControl(Panel_Window_Camp, "Static_ItemSlotBg_Warehouse"),
      [4] = UI.getChildControl(Panel_Window_Camp, "Static_ItemSlotBg_Repair"),
      [5] = UI.getChildControl(Panel_Window_Camp, "Static_ItemSlotBg_Shop"),
      [6] = UI.getChildControl(Panel_Window_Camp, "Static_TentSlotBg")
    }
  },
  _config = {
    _itemSlot = {
      createIcon = false,
      createBorder = true,
      createCount = true,
      createEnchant = true,
      createCash = true,
      createEnduranceIcon = true
    },
    _slotNo = {
      3,
      4,
      5,
      6
    },
    _slotID = {
      [3] = "Static_Icon_CampInven",
      [4] = "Static_Icon_CampRepair",
      [5] = "Static_Icon_CampShop"
    },
    _isSetItem = {
      [3] = false,
      [4] = false,
      [5] = false,
      [6] = false
    }
  },
  _btn_Camp = UI.getChildControl(Panel_Icon_Camp, "Button_CampIcon"),
  _itemSlots = Array.new(),
  _actorKeyRaw = nil,
  _isCamping = false,
  _panelSizeY = 0,
  _isOpen = false,
  _btnCount = 0,
  _defaultSlotPosY = 0,
  _defaultBtnPosY = 0
}
function PaGlobal_Camp:initialize()
  PaGlobal_Camp:setPos()
  local isShow = ToClient_isCampingReigsted()
  Panel_Icon_Camp:SetShow(isShow)
  if true == _ContentsGroup_RemasterUI_Main then
    if nil ~= PaGlobalFunc_ServantIcon_UpdateOtherIcon then
      PaGlobalFunc_ServantIcon_UpdateOtherIcon(PaGlobalFunc_ServantIcon_GetCampIndex())
    end
    Panel_Icon_Camp:SetShow(false)
  end
  if true == _ContentsGroup_RenewUI_Main then
    Panel_Icon_Camp:SetShow(false)
  end
  for index, value in pairs(self._config._slotNo) do
    local slot = {}
    SlotItem.new(slot, "CampEquip_" .. value, value, self._ui._slotBg[value], self._config._itemSlot)
    slot:createChild()
    slot.icon:addInputEvent("Mouse_RUp", "PaGlobal_Camp:slotRClick(" .. value .. ")")
    slot.icon:addInputEvent("Mouse_On", "PaGlobal_Camp:equipItemTooltipShow(" .. value .. ", true)")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobal_Camp:equipItemTooltipShow(" .. value .. ", false)")
    self._itemSlots[value] = slot
  end
  self._btn_Camp:ActiveMouseEventEffect(true)
  self._panelSizeY = Panel_Window_Camp:GetSizeY()
  self._defaultSlotPosY = self._ui._slotBg[4]:GetPosY()
  self._defaultBtnPosY = self._ui._btn_Repair:GetPosY()
end
function PaGlobal_Camp:open()
  if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= PaGlobalFunc_NPCShop_ALL_GetShow then
    if true == PaGlobalFunc_NPCShop_ALL_GetShow() then
      return
    end
  elseif true == _ContentsGroup_RenewUI_NpcShop then
    if true == PaGlobalFunc_Dialog_NPCShop_GetShow() then
      return
    end
  elseif true == Panel_Window_NpcShop:GetShow() then
    return
  end
  if Panel_Window_Repair:GetShow() then
    return
  end
  ToClient_openCampingInfo()
  PaGlobal_Camp:setBtnPos()
  self:update()
end
function PaGlobal_Camp:close()
  if Panel_Window_Inventory:GetShow() then
    Inventory_ShowToggle()
    if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= HandleEventLUp_NPCShop_ALL_Close then
      HandleEventLUp_NPCShop_ALL_Close()
    elseif true == _ContentsGroup_RenewUI_NpcShop then
      PaGlobalFunc_Dialog_NPCShop_ExitButton()
    else
      handleClickedNpcShow_WindowClose()
    end
  end
  if Panel_Window_Repair:GetShow() then
    handleMClickedRepairExitButton()
  end
  Panel_Window_Camp:SetShow(false)
  self._isCamping = false
  PaGlobal_Repair:setIsCamping(false)
  if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= PaGlobalFunc_NPCShop_ALL_SetIsCamping then
    PaGlobalFunc_NPCShop_ALL_SetIsCamping(false)
  else
    npcShop:setIsCamping(false)
  end
  self._btnCount = 0
end
function PaGlobal_Camp:navi()
  ToClient_requestCampingNavi()
end
function FromClient_Camp_OpenByActorKeyRaw(actorKeyRaw)
  PaGlobal_Camp:openByActorKeyRaw(actorKeyRaw)
  if Panel_Window_Camp:GetShow() and false == PaGlobal_Camp._isOpen then
    PaGlobal_Camp:close()
    return
  end
  PaGlobal_Camp._isOpen = false
  if false == Panel_Window_Inventory:GetShow() then
    Inventory_ShowToggle()
  end
  PaGlobal_Camp:setPos()
  PaGlobal_Camp:setBtnPos()
  Panel_Window_Camp:SetShow(true)
  PaGlobal_Camp:update()
  PaGlobal_Camp._isCamping = true
  PaGlobal_Repair:setIsCamping(true)
  if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= PaGlobalFunc_NPCShop_ALL_SetIsCamping then
    PaGlobalFunc_NPCShop_ALL_SetIsCamping(true)
  else
    npcShop:setIsCamping(true)
  end
end
function PaGlobal_Camp:openByActorKeyRaw(actorKeyRaw)
  self._actorKeyRaw = actorKeyRaw
end
function PaGlobal_Camp:sealTent()
  PaGlobal_BuildingBuff:open()
  PaGlobal_Camp:close()
end
function PaGlobal_Camp:unSealTent()
  ToClient_requestServantUnsealCampingTent(0)
  self._isOpen = true
end
function PaGlobal_Camp:functionOpen(slotIndex)
  local isSetItem = self._config._isSetItem[slotIndex]
  ClothInventory_Close()
  if isSetItem then
    if 3 == slotIndex then
      ToClient_requestCampingInventoryOpen()
      Panel_Window_Camp:SetShow(false)
    elseif 4 == slotIndex then
      ToClient_requestCampingRepairOpen()
      Panel_Window_Camp:SetShow(false)
    elseif 5 == slotIndex then
      ToClient_requestCampingShopOpen()
      Panel_Window_Camp:SetShow(false)
    end
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CAMP_UNEQUIPEDITEM"))
  end
end
function PaGlobal_Camp:remoteSeal()
  local hasTent = ToClient_requestCheckHasServantCampingTent()
  if false == hasTent then
    return
  end
  local FunctionYesRemoteSeal = function()
    ToClient_requestServantCompulsionSealCampingTent()
    PaGlobal_Camp:close()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CAMP_REMOTERESET_DESC")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CAMP_REMOTERESET_TITLE"),
    content = messageBoxMemo,
    functionYes = FunctionYesRemoteSeal,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FromClient_OpenCampingRepair()
  PaGlobal_Repair:repair_OpenPanel(true)
end
function FromClient_OpenCampingShop()
  if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= FromClient_NPCShop_ALL_Open then
    FromClient_NPCShop_ALL_Open(true)
  else
    NpcShop_UpdateContent()
  end
end
function FromClient_CampingUpdate()
  PaGlobal_Camp:update()
end
function PaGlobal_Camp:update()
  local isUnseal = ToClient_isCampingUnseal()
  for index, value in pairs(self._config._slotNo) do
    local slot = self._itemSlots[value]
    if isUnseal then
      local itemWrapper = ToClient_requestCampingEquipItem(value)
      if nil ~= itemWrapper then
        self._config._isSetItem[value] = true
        slot:setItem(itemWrapper)
      else
        self._config._isSetItem[value] = false
        slot:clearItem()
      end
    else
      self._config._isSetItem[value] = false
      slot:clearItem()
    end
  end
  if isUnseal then
    if _ContentsGroup_isCamp then
      self._ui._btn_Seal:SetShow(true)
      self._ui._btn_Seal:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CAMP_BUILDINGBUFFLIST_BUTTON_TEXT"))
    else
      self._ui._btn_Seal:SetShow(false)
      self._ui._btn_RemoteSeal:SetPosX(Panel_Window_Camp:GetSizeX() / 2 - self._ui._btn_RemoteSeal:GetSizeX() / 2)
    end
    self._ui._btn_RemoteSeal:SetShow(true)
    self._ui._btn_UnSealTent:SetShow(false)
    self._ui._unsealBG:SetShow(false)
    self._ui._unsealBG:SetSize(self._ui._unsealBG:GetSizeX(), 222)
    self._ui._txtTentTitle:SetShow(true)
    self._ui._btn_Seal:addInputEvent("Mouse_LUp", "PaGlobal_Camp:sealTent()")
  else
    self._ui._btn_UnSealTent:SetShow(true)
    self._ui._unsealBG:SetShow(true)
    self._ui._unsealBG:SetSize(self._ui._unsealBG:GetSizeX(), 252)
    self._ui._btn_Seal:SetShow(false)
    self._ui._btn_RemoteSeal:SetShow(false)
    self._ui._txtTentTitle:SetShow(false)
  end
end
function PaGlobal_Camp:tooltipShow(isShow)
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_CAMP_TOOLTIP_TITLE")
    local desc = PAGetString(Defines.StringSheet_GAME, "LUA_CAMP_TOOLTIP_DESC")
    TooltipSimple_Show(self._btn_Camp, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_Camp:guideTooltipShow(isShow)
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_CAMP_GUIDETOOLTIP_TITLE")
    local desc = PAGetString(Defines.StringSheet_GAME, "LUA_CAMP_GUIDETOOLTIP_DESC")
    TooltipSimple_Show(self._ui._guideIcon, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_Camp:remoteSealTooltipShow(isShow)
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_CAMP_REMOTEBUTTON_TOOLTIP")
    local desc = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_NPCNAVI_BUTTON_DESC") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
    TooltipSimple_Show(self._ui._btn_RemoteSeal, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_Camp:UnSealTooltipShow(isShow)
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_SETUP")
    local desc = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_CAMP_INSTALL_BUTTON_DESC") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
    TooltipSimple_Show(self._ui._btn_UnSealTent, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_Camp:equipItemTooltipShow(slotNo, isShow)
  local slot = self._itemSlots[slotNo]
  Panel_Tooltip_Item_SetPosition(slotNo, slot, "CampEquip")
  Panel_Tooltip_Item_Show_GeneralNormal(slotNo, "CampEquip", isShow)
end
function PaGlobal_Camp:getActorKeyRaw()
  local self = PaGlobal_Camp
  return self._actorKeyRaw
end
function PaGlobal_Camp:setPos()
  if true == _ContentsGroup_RemasterUI_Main then
    if nil ~= PaGlobalFunc_ServantIcon_UpdateOtherIcon then
      PaGlobalFunc_ServantIcon_UpdateOtherIcon(PaGlobalFunc_ServantIcon_GetCampIndex())
      return
    end
    Panel_Icon_Camp:SetShow(false)
  else
    local posX = 0
    local posY = 0
    if Panel_Icon_Duel:GetShow() then
      posX = Panel_Icon_Duel:GetPosX() + Panel_Icon_Duel:GetSizeX() - 3
      posY = Panel_Icon_Duel:GetPosY()
    elseif nil ~= Panel_Icon_Maid and true == Panel_Icon_Maid:GetShow() then
      posX = Panel_Icon_Maid:GetPosX() + Panel_Icon_Maid:GetSizeX() - 3
      posY = Panel_Icon_Maid:GetPosY()
    elseif false == _ContentsGroup_RenewUI_Pet and Panel_Window_PetIcon:GetShow() then
      posX = Panel_Window_PetIcon:GetPosX() + Panel_Window_PetIcon:GetSizeX() - 3
      posY = Panel_Window_PetIcon:GetPosY()
    elseif 0 < FGlobal_HouseIconCount() and Panel_MyHouseNavi:GetShow() then
      posX = Panel_MyHouseNavi:GetPosX() + 60 * FGlobal_HouseIconCount() - 3
      posY = Panel_MyHouseNavi:GetPosY()
    elseif 0 < FGlobal_ServantIconCount() and Panel_Window_Servant:GetShow() then
      posX = Panel_Window_Servant:GetPosX() + 60 * FGlobal_ServantIconCount() - 3
      posY = Panel_Window_Servant:GetPosY()
    else
      posX = 0
      posY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15
    end
    Panel_Icon_Camp:SetPosX(posX)
    Panel_Icon_Camp:SetPosY(posY)
    if nil ~= PaGlobal_PossessByBlackSpiritIcon then
      PaGlobal_PossessByBlackSpiritIcon:setPosIcon()
    end
    PaGlobal_CharacterTag_SetPosIcon()
    if nil ~= PaGlobal_Fairy_SetPosIcon then
      PaGlobal_Fairy_SetPosIcon()
    end
  end
end
function PaGlobal_Camp:register()
  FGlobal_CampRegister_Open()
end
function PaGlobal_Camp:slotRClick(slotNo)
  local self = PaGlobal_Camp
  local campWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil == campWrapper then
    return
  end
  local itemWrapper = campWrapper:getEquipItem(slotNo)
  if nil == itemWrapper then
    return
  end
  if 3 == slotNo then
    if true == PaGlobalFunc_ServantInventory_GetShow() then
      return
    end
  elseif 4 == slotNo then
    if Panel_Window_Repair:GetShow() then
      return
    end
  elseif 5 == slotNo then
    if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= PaGlobalFunc_NPCShop_ALL_GetShow then
      if true == PaGlobalFunc_NPCShop_ALL_GetShow() then
        return
      end
    elseif true == _ContentsGroup_RenewUI_NpcShop then
      if true == PaGlobalFunc_Dialog_NPCShop_GetShow() then
        return
      end
    elseif true == Panel_Window_NpcShop:GetShow() then
      return
    end
  end
  servant_doUnequip(campWrapper:getActorKeyRaw(), slotNo)
end
function EventServantEquipItem(slotNo)
  PaGlobal_Camp:changeEquipItem(slotNo)
end
function PaGlobal_Camp:changeEquipItem(slotNo)
  if 4 == slotNo or 5 == slotNo or 6 == slotNo then
    local self = PaGlobal_Camp
    local slot = self._itemSlots[slotNo]
    if nil == slot then
      return
    end
    if nil == self._actorKeyRaw then
      return
    end
    local campWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
    if nil == campWrapper then
      return
    end
    slot.icon:AddEffect("UI_ItemInstall", false, 0, 0)
    slot.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
    local itemWrapper = campWrapper:getEquipItem(slotNo + 1)
    if nil == itemWrapper then
      return
    end
  end
end
function PaGlobal_Camp:getIsCamping()
  return PaGlobal_Camp._isCamping
end
function PaGlobal_Camp:setIsCamping(isCamping)
  PaGlobal_Camp._isCamping = isCamping
end
function FromClient_InitializeCamp()
  if true == _ContentsGroup_RemasterUI_Main then
    Panel_Icon_Camp:SetShow(false)
    PaGlobalFunc_ServantIcon_UpdateOtherIcon(PaGlobalFunc_ServantIcon_GetCampIndex())
  else
    local isShow = ToClient_isCampingReigsted()
    Panel_Icon_Camp:SetShow(isShow)
    if true == _ContentsGroup_RenewUI_Main then
      Panel_Icon_Camp:SetShow(false)
    end
  end
end
function PaGlobal_Camp:isUnsealShow(isShow)
  for index, value in pairs(self._config._slotNo) do
    self._ui._slotBg[value]:SetShow(isShow)
  end
  self._ui._txtTitle:SetShow(isShow)
  self._ui._btn_ShopOpen:SetShow(isShow)
  self._ui._btn_Repair:SetShow(isShow)
  self._ui._btn_InvenOpen:SetShow(isShow)
  self._ui._contentBG:SetShow(isShow)
end
function PaGlobal_Camp:setBtnPos()
  local isUnseal = ToClient_isCampingUnseal()
  PaGlobal_Camp:isUnsealShow(isUnseal)
  if false == isUnseal then
    Panel_Window_Camp:SetSize(Panel_Window_Camp:GetSizeX(), self._panelSizeY - 151)
    self._ui._titleBG:SetSize(self._ui._titleBG:GetSizeX(), self._panelSizeY - 244)
    self._ui._btn_UnSealTent:SetSpanSize(self._ui._btn_UnSealTent:GetPosX() / 2 - 50, 10)
  else
    Panel_Window_Camp:SetSize(Panel_Window_Camp:GetSizeX(), self._panelSizeY)
    self._ui._titleBG:SetSize(self._ui._titleBG:GetSizeX(), self._panelSizeY - 64)
  end
  self._btnCount = 0
  for index, value in pairs(self._config._slotNo) do
    local btn
    if 3 == value then
      btn = self._ui._btn_InvenOpen
    elseif 4 == value then
      btn = self._ui._btn_Repair
    elseif 5 == value then
      btn = self._ui._btn_ShopOpen
    elseif 6 == value then
      btn = nil
    end
    if nil == btn or false == isUnseal then
    else
      self._ui._slotBg[value]:SetPosY(self._defaultSlotPosY + 55 * self._btnCount)
      btn:SetPosY(self._defaultBtnPosY + 55 * self._btnCount)
      self._ui._contentBG:SetSize(self._ui._contentBG:GetSizeX(), 55 * (self._btnCount + 1) + 25)
      self._ui._titleBG:SetSize(self._ui._titleBG:GetSizeX(), 190 + 55 * (self._btnCount + 1) + 5)
      Panel_Window_Camp:SetSize(Panel_Window_Camp:GetSizeX(), 290 + 55 * (self._btnCount + 1) + 70)
      self._ui._btn_Seal:SetPosY(Panel_Window_Camp:GetSizeY() - self._ui._btn_Seal:GetSizeY() - 10)
      self._ui._btn_RemoteSeal:SetPosY(Panel_Window_Camp:GetSizeY() - self._ui._btn_RemoteSeal:GetSizeY() - 10)
      self._btnCount = self._btnCount + 1
    end
  end
end
function FromClient_CampingTentSeal()
  PaGlobal_Camp:close()
end
function PaGlobal_Camp:registMessageHandler()
  self._ui._btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_Camp:close()")
  self._btn_Camp:addInputEvent("Mouse_LUp", "PaGlobal_Camp:open()")
  self._btn_Camp:addInputEvent("Mouse_RUp", "PaGlobal_Camp:navi()")
  self._btn_Camp:addInputEvent("Mouse_On", "PaGlobal_Camp:tooltipShow( true )")
  self._btn_Camp:addInputEvent("Mouse_Out", "PaGlobal_Camp:tooltipShow( false )")
  self._ui._btn_Repair:addInputEvent("Mouse_LUp", "PaGlobal_Camp:functionOpen(" .. 4 .. ")")
  self._ui._btn_InvenOpen:addInputEvent("Mouse_LUp", "PaGlobal_Camp:functionOpen(" .. 3 .. ")")
  self._ui._btn_ShopOpen:addInputEvent("Mouse_LUp", "PaGlobal_Camp:functionOpen(" .. 5 .. ")")
  self._ui._guideIcon:addInputEvent("Mouse_On", "PaGlobal_Camp:guideTooltipShow( true )")
  self._ui._guideIcon:addInputEvent("Mouse_Out", "PaGlobal_Camp:guideTooltipShow( false )")
  self._ui._btn_RemoteSeal:addInputEvent("Mouse_LUp", "PaGlobal_Camp:remoteSeal()")
  self._ui._btn_RemoteSeal:addInputEvent("Mouse_On", "PaGlobal_Camp:remoteSealTooltipShow( true )")
  self._ui._btn_RemoteSeal:addInputEvent("Mouse_Out", "PaGlobal_Camp:remoteSealTooltipShow( false )")
  self._ui._btn_UnSealTent:addInputEvent("Mouse_LUp", "PaGlobal_Camp:unSealTent()")
  self._ui._btn_UnSealTent:addInputEvent("Mouse_On", "PaGlobal_Camp:UnSealTooltipShow( true )")
  self._ui._btn_UnSealTent:addInputEvent("Mouse_Out", "PaGlobal_Camp:UnSealTooltipShow( false )")
  if _ContentsGroup_isCamp then
    self._ui._btn_RemoteSeal:setButtonShortcuts("PANEL_SIMPLESHORTCUT_TENT_UNINSTALL")
    self._ui._btn_UnSealTent:setButtonShortcuts("PANEL_SIMPLESHORTCUT_TENT_INSTALL")
  end
  registerEvent("FromClient_OpenCampingRepair", "FromClient_OpenCampingRepair")
  registerEvent("FromClient_OpenCampingShop", "FromClient_OpenCampingShop")
  registerEvent("FromClient_OpenCampingInfo", "FromClient_Camp_OpenByActorKeyRaw")
  registerEvent("EventServantEquipItem", "EventServantEquipItem")
  registerEvent("EventServantEquipmentUpdate", "FromClient_CampingUpdate")
  registerEvent("FromClient_CampingTentSeal", "FromClient_CampingTentSeal")
  registerEvent("FromClient_CampingTentUnSeal", "FromClient_CampingUpdate")
  registerEvent("FromClient_InitializeCamp", "FromClient_InitializeCamp")
end
function PaGlobal_Camp_Initialize()
  PaGlobal_Camp:initialize()
  PaGlobal_Camp:registMessageHandler()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_Camp_Initialize")
