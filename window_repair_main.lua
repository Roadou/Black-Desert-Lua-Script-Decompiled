local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_Group = Defines.UIGroup
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
Panel_Window_Repair:SetShow(false, false)
Panel_Window_Repair:setMaskingChild(true)
Panel_Window_Repair:ActiveMouseEventEffect(true)
Panel_LuckyRepair_Result:SetShow(false)
PaGlobal_Repair = {
  _screenX = nil,
  _screenY = nil,
  _repairWhereType = nil,
  _repairSlotNo = nil,
  _uiRepairCursor = UI.getChildControl(Panel_Window_Repair, "Static_Cursor"),
  _uiRepairMessageBG = nil,
  _repairMessage,
  _repairMessageJP,
  _isContentsEnable = ToClient_IsContentsGroupOpen("36"),
  _uiRepairInven = nil,
  _uiRepairWareHouse = nil,
  _uiRepairInvenMoney = nil,
  _uiRepairWareHouseMoney = nil,
  _uiRepairBG = UI.getChildControl(Panel_Window_Repair, "RepairBackGround"),
  _uiRepairStableEquippedItemButton = UI.getChildControl(Panel_Window_Repair, "Button_Repair_Servant"),
  _uiRepairWharfEquippedItemButton = UI.getChildControl(Panel_Window_Repair, "Button_Repair_Ship"),
  _uiRepairElephantButton = UI.getChildControl(Panel_Window_Repair, "Button_Repair_Elephant"),
  _uiRepairAllEquippedItemButton = UI.getChildControl(Panel_Window_Repair, "Button_Repair_EquipItem"),
  _uiRepairAllInvenItemButton = UI.getChildControl(Panel_Window_Repair, "Button_Repair_InvenItem"),
  _uiFixEquipItemButton = UI.getChildControl(Panel_Window_Repair, "Button_FixEquip"),
  _uiRepairExitButton = UI.getChildControl(Panel_Window_Repair, "Button_Exit"),
  _resultMsg_ShowTime = 0,
  _luckyRepairMSG = {},
  _uiRepairInvenMoneyTextSizeX = 0,
  _uiRepairWareHouseMoneyTextSizeX = 0,
  _uiRepairTextSizeX = 0,
  _isCamping = false
}
function PaGlobal_Repair:initialize()
  if false == _ContentsGroup_RenewUI then
    self._uiRepairMessageBG = UI.getChildControl(Panel_Equipment, "Static_Repair_Message")
    self._uiRepairInven = UI.getChildControl(Panel_Equipment, "Static_Text_Money")
    self._uiRepairWareHouse = UI.getChildControl(Panel_Equipment, "Static_Text_Money2")
    self._uiRepairInvenMoney = UI.getChildControl(Panel_Equipment, "RadioButton_Icon_Money")
    self._uiRepairWareHouseMoney = UI.getChildControl(Panel_Equipment, "RadioButton_Icon_Money2")
  else
    self._uiRepairMessageBG = UI.getChildControl(Panel_Window_Inventory, "Static_Repair_Message")
    self._uiRepairInven = UI.getChildControl(Panel_Window_Inventory, "Static_Text_Money")
    self._uiRepairWareHouse = UI.getChildControl(Panel_Window_Inventory, "Static_Text_Money2")
    self._uiRepairInvenMoney = UI.getChildControl(Panel_Window_Inventory, "RadioButton_Icon_Money")
    self._uiRepairWareHouseMoney = UI.getChildControl(Panel_Window_Inventory, "RadioButton_Icon_Money2")
  end
  self._uiRepairBG:setGlassBackground(true)
  self._uiRepairBG:SetShow(true)
  self._uiRepairStableEquippedItemButton:addInputEvent("Mouse_LUp", "PaGlobal_Repair:handleMClickedHorseItemRepairButton()")
  self._uiRepairWharfEquippedItemButton:addInputEvent("Mouse_LUp", "PaGlobal_Repair:handleMClickedShipItemRepairButton()")
  self._uiRepairElephantButton:addInputEvent("Mouse_LUp", "PaGlobal_Repair:handleMClickedElephantRepairButton()")
  if getContentsServiceType() ~= CppEnums.ContentsServiceType.eContentsServiceType_Commercial then
    self._uiRepairStableEquippedItemButton:SetShow(false)
    self._uiRepairWharfEquippedItemButton:SetShow(false)
  else
    self._uiRepairStableEquippedItemButton:SetShow(true)
    self._uiRepairWharfEquippedItemButton:SetShow(true)
  end
  if self._isContentsEnable then
    self._uiRepairElephantButton:SetShow(true)
  else
    self._uiRepairElephantButton:SetShow(false)
  end
  self._uiRepairAllEquippedItemButton:SetShow(true)
  self._uiRepairAllEquippedItemButton:addInputEvent("Mouse_LUp", "PaGlobal_Repair:handleMClickedEquippedItemButton()")
  self._uiRepairAllInvenItemButton:SetShow(true)
  self._uiRepairAllInvenItemButton:addInputEvent("Mouse_LUp", "PaGlobal_Repair:handleMClickedInvenItemButton()")
  self._uiFixEquipItemButton:SetShow(true)
  self._uiFixEquipItemButton:addInputEvent("Mouse_LUp", "PaGlobal_FixEquip:handleMClickedFixEquipItemButton()")
  self._uiRepairExitButton:SetShow(true)
  self._uiRepairExitButton:addInputEvent("Mouse_LUp", "handleMClickedRepairExitButton()")
  self._repairMessage = UI.getChildControl(self._uiRepairMessageBG, "StaticText_Repair_Message")
  self._repairMessageJP = UI.getChildControl(self._uiRepairMessageBG, "StaticText_Repair_MessageJP")
  if repair_SetRepairMode ~= nil then
    repair_SetRepairMode(false)
  end
  self._uiRepairStableEquippedItemButton:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._uiRepairWharfEquippedItemButton:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._uiRepairElephantButton:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._uiRepairAllEquippedItemButton:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._uiRepairAllInvenItemButton:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._uiFixEquipItemButton:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._uiRepairStableEquippedItemButton:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_REPAIR_BTN_REPAIR_VEHICLE"))
  self._uiRepairWharfEquippedItemButton:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_REPAIR_BTN_REPAIR_SHIP"))
  self._uiRepairElephantButton:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_REPAIR_ELEPHANT"))
  self._uiRepairAllEquippedItemButton:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_REPAIR_BTN_EQUIPITEM"))
  self._uiRepairAllInvenItemButton:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_REPAIR_BTN_IVNENITEM"))
  self._uiFixEquipItemButton:SetText(PAGetString(Defines.StringSheet_RESOURCE, "REPAIR_MAXENDURANCE_TITLE"))
  local isLimitTextStable = self._uiRepairStableEquippedItemButton:IsLimitText()
  local isLimitTextWharf = self._uiRepairWharfEquippedItemButton:IsLimitText()
  local isLimitTextElephant = self._uiRepairElephantButton:IsLimitText()
  local isLimitTextAllEquiped = self._uiRepairAllEquippedItemButton:IsLimitText()
  local isLimitTextAllInven = self._uiRepairAllInvenItemButton:IsLimitText()
  local isLimitTextFixEquip = self._uiFixEquipItemButton:IsLimitText()
  self._uiRepairStableEquippedItemButton:addInputEvent("Mouse_On", "")
  self._uiRepairStableEquippedItemButton:addInputEvent("Mouse_Out", "")
  self._uiRepairWharfEquippedItemButton:addInputEvent("Mouse_On", "")
  self._uiRepairWharfEquippedItemButton:addInputEvent("Mouse_Out", "")
  self._uiRepairElephantButton:addInputEvent("Mouse_On", "")
  self._uiRepairElephantButton:addInputEvent("Mouse_Out", "")
  self._uiRepairAllEquippedItemButton:addInputEvent("Mouse_On", "")
  self._uiRepairAllEquippedItemButton:addInputEvent("Mouse_Out", "")
  self._uiRepairAllInvenItemButton:addInputEvent("Mouse_On", "")
  self._uiRepairAllInvenItemButton:addInputEvent("Mouse_Out", "")
  self._uiFixEquipItemButton:addInputEvent("Mouse_On", "")
  self._uiFixEquipItemButton:addInputEvent("Mouse_Out", "")
  if isLimitTextStable then
    self._uiRepairStableEquippedItemButton:addInputEvent("Mouse_On", "PaGlobal_Repair_MouseTooltip(true, 0)")
    self._uiRepairStableEquippedItemButton:addInputEvent("Mouse_Out", "PaGlobal_Repair_MouseTooltip(false)")
  end
  if isLimitTextWharf then
    self._uiRepairWharfEquippedItemButton:addInputEvent("Mouse_On", "PaGlobal_Repair_MouseTooltip(true, 1)")
    self._uiRepairWharfEquippedItemButton:addInputEvent("Mouse_Out", "PaGlobal_Repair_MouseTooltip(false)")
  end
  if isLimitTextElephant then
    self._uiRepairElephantButton:addInputEvent("Mouse_On", "PaGlobal_Repair_MouseTooltip(true, 2)")
    self._uiRepairElephantButton:addInputEvent("Mouse_Out", "PaGlobal_Repair_MouseTooltip(false)")
  end
  if isLimitTextAllEquiped then
    self._uiRepairAllEquippedItemButton:addInputEvent("Mouse_On", "PaGlobal_Repair_MouseTooltip(true, 3)")
    self._uiRepairAllEquippedItemButton:addInputEvent("Mouse_Out", "PaGlobal_Repair_MouseTooltip(false)")
  end
  if isLimitTextAllInven then
    self._uiRepairAllInvenItemButton:addInputEvent("Mouse_On", "PaGlobal_Repair_MouseTooltip(true, 4)")
    self._uiRepairAllInvenItemButton:addInputEvent("Mouse_Out", "PaGlobal_Repair_MouseTooltip(false)")
  end
  if isLimitTextFixEquip then
    self._uiFixEquipItemButton:addInputEvent("Mouse_On", "PaGlobal_Repair_MouseTooltip(true, 5)")
    self._uiFixEquipItemButton:addInputEvent("Mouse_Out", "PaGlobal_Repair_MouseTooltip(false)")
  end
  self._uiRepairInvenMoneyTextSizeX = self._uiRepairInvenMoney:GetTextSizeX()
  self._uiRepairWareHouseMoneyTextSizeX = self._uiRepairWareHouseMoney:GetTextSizeX()
  if self._uiRepairInvenMoneyTextSizeX > self._uiRepairWareHouseMoneyTextSizeX then
    self._uiRepairTextSizeX = self._uiRepairInvenMoneyTextSizeX
  else
    self._uiRepairTextSizeX = self._uiRepairWareHouseMoneyTextSizeX
  end
  self._uiRepairInvenMoney:SetText(self._uiRepairInvenMoney:GetText())
  self._uiRepairWareHouseMoney:SetText(self._uiRepairWareHouseMoney:GetText())
  self._uiRepairInvenMoney:SetEnableArea(0, 0, self._uiRepairInvenMoney:GetTextSizeX() + 30, 25)
  self._uiRepairWareHouseMoney:SetEnableArea(0, 0, self._uiRepairWareHouseMoney:GetTextSizeX() + 30, 25)
end
function PaGlobal_Repair:BottomButtonSort_Center()
  local _btnTable = {}
  local _btnCount = 0
  _btnTable[0] = self._uiRepairElephantButton
  _btnTable[1] = self._uiRepairWharfEquippedItemButton
  _btnTable[2] = self._uiRepairStableEquippedItemButton
  _btnTable[3] = self._uiFixEquipItemButton
  _btnTable[4] = self._uiRepairAllEquippedItemButton
  _btnTable[5] = self._uiRepairAllInvenItemButton
  _btnTable[6] = self._uiRepairExitButton
  if self._uiRepairStableEquippedItemButton:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self._uiRepairWharfEquippedItemButton:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self._uiRepairElephantButton:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self._uiRepairAllEquippedItemButton:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self._uiRepairAllInvenItemButton:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self._uiFixEquipItemButton:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self._uiRepairExitButton:GetShow() then
    _btnCount = _btnCount + 1
  end
  local sizeX = getScreenSizeX()
  local funcButtonCount = _btnCount
  local buttonSize = _btnTable[6]:GetSizeX()
  local buttonGap = 10
  local startPosX = (sizeX - (buttonSize * funcButtonCount + buttonGap * (funcButtonCount - 1))) / 2
  local posX = 0
  local jindex = 0
  for index = 0, 6 do
    if _btnTable[index]:GetShow() then
      posX = startPosX + (buttonSize + buttonGap) * jindex
      jindex = jindex + 1
    end
    _btnTable[index]:SetPosX(posX)
  end
end
function PaGlobal_Repair:luckyRepair_Set()
  Panel_LuckyRepair_Result:SetSize(getScreenSizeX(), getScreenSizeY())
  Panel_LuckyRepair_Result:SetPosX(0)
  Panel_LuckyRepair_Result:SetPosY(0)
  Panel_LuckyRepair_Result:SetColor(UI_color.C_00FFFFFF)
  Panel_LuckyRepair_Result:SetIgnore(true)
  local tempSlot = {}
  local MSGBG = UI.getChildControl(Panel_LuckyRepair_Result, "LuckyRepair_BG")
  tempSlot.MSGBG = MSGBG
  local MSG = UI.getChildControl(Panel_LuckyRepair_Result, "LuckyRepair_MSG")
  tempSlot.MSG = MSG
  MSG:SetSize(getScreenSizeX(), 90)
  MSG:ComputePos()
  MSGBG:SetSize(getScreenSizeX() + 40, 90)
  MSGBG:SetPosX(-20)
  MSGBG:ComputePos()
  MSGBG:ResetVertexAni()
  MSGBG:SetVertexAniRun("Ani_Scale_0", true)
  self._luckyRepairMSG = tempSlot
end
PaGlobal_Repair:luckyRepair_Set()
function FromClient_LuckyRepair_resultShow()
  local self = PaGlobal_Repair
  if false == Panel_LuckyRepair_Result:GetShow() then
    self._luckyRepairMSG.MSG:SetText(PAGetString(Defines.StringSheet_GAME, "REPAIR_LUCKY_TEXT"))
    Panel_LuckyRepair_Result:SetShow(true)
    self._resultMsg_ShowTime = 0
  end
end
function Chk_LuckyRepair_ResultMsg_ShowTime(deltaTime)
  local self = PaGlobal_Repair
  self._resultMsg_ShowTime = self._resultMsg_ShowTime + deltaTime
  if self._resultMsg_ShowTime > 3 and true == Panel_LuckyRepair_Result:GetShow() then
    Panel_LuckyRepair_Result:SetShow(false)
  end
  if self._resultMsg_ShowTime > 5 then
    self._resultMsg_ShowTime = 0
  end
end
function PaGlobal_Repair:repair_BtnResize_Camping()
  PaGlobal_Repair:BottomButtonSort_Center()
end
function Repair_Resize()
  local self = PaGlobal_Repair
  self._screenX = getScreenSizeX()
  self._screenY = getScreenSizeY()
  Panel_Window_Repair:SetSize(self._screenX, Panel_Window_Repair:GetSizeY())
  Panel_Window_Repair:ComputePos()
  self._uiRepairBG:SetSize(self._screenX, self._uiRepairBG:GetSizeY())
  self._uiRepairBG:ComputePos()
  Panel_LuckyRepair_Result:SetSize(getScreenSizeX(), getScreenSizeY())
  Panel_LuckyRepair_Result:SetPosX(0)
  Panel_LuckyRepair_Result:SetPosY(0)
  Panel_LuckyRepair_Result:SetColor(UI_color.C_00FFFFFF)
  Panel_LuckyRepair_Result:SetIgnore(true)
  self._luckyRepairMSG.MSGBG:SetSize(getScreenSizeX() + 40, 90)
  self._luckyRepairMSG.MSGBG:SetPosX(-20)
  self._luckyRepairMSG.MSGBG:ComputePos()
  self._luckyRepairMSG.MSG:SetSize(getScreenSizeX(), 90)
  self._luckyRepairMSG.MSG:ComputePos()
  self._luckyRepairMSG.MSGBG:ResetVertexAni()
  self._luckyRepairMSG.MSGBG:SetVertexAniRun("Ani_Scale_0", true)
  PaGlobal_Repair:BottomButtonSort_Center()
end
function PaGlobal_Repair:repair_OpenPanel(isShow)
  self._isCamping = PaGlobal_Camp:getIsCamping()
  if true == isShow then
    SetUIMode(Defines.UIMode.eUIMode_Repair)
    repair_SetRepairMode(true)
    if true == _ContentsGroup_RenewUI_Dailog then
      PaGlobalFunc_MainDialog_setIgnoreShowDialog(true)
    elseif false == _ContentsGroup_NewUI_Dialog_All then
      setIgnoreShowDialog(true)
    else
      PaGlobalFunc_DialogMain_All_SetIgnoreShowDialog(true)
    end
    UIAni.fadeInSCR_Down(Panel_Window_Repair)
    Inventory_SetFunctor(Repair_InvenFilter, Repair_InvenRClick, handleMClickedRepairExitButton, nil)
    InventoryWindow_Show(true)
    Panel_Equipment:SetPosY(Panel_Window_Inventory:GetPosY())
    Inventory_PosSaveMemory()
    if ToClient_HasWareHouseFromNpc() then
      if toInt64(0, 0) == warehouse_moneyFromNpcShop_s64() then
        self._uiRepairInvenMoney:SetCheck(true)
        self._uiRepairWareHouseMoney:SetCheck(false)
        self._uiRepairWareHouseMoney:SetShow(true)
        self._uiRepairWareHouse:SetShow(true)
      else
        self._uiRepairInvenMoney:SetCheck(false)
        self._uiRepairWareHouseMoney:SetCheck(true)
        self._uiRepairWareHouseMoney:SetShow(true)
        self._uiRepairWareHouse:SetShow(true)
      end
    else
      self._uiRepairInvenMoney:SetCheck(true)
      self._uiRepairWareHouseMoney:SetCheck(false)
      self._uiRepairWareHouseMoney:SetShow(false)
      self._uiRepairWareHouse:SetShow(false)
    end
  else
    if self._isCamping then
      SetUIMode(Defines.UIMode.eUIMode_Default)
    else
      SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
    end
    repair_SetRepairMode(false)
    if true == _ContentsGroup_RenewUI_Dailog then
      PaGlobalFunc_MainDialog_setIgnoreShowDialog(false)
    elseif false == _ContentsGroup_NewUI_Dialog_All then
      setIgnoreShowDialog(false)
    else
      PaGlobalFunc_DialogMain_All_SetIgnoreShowDialog(false)
    end
    Inventory_SetFunctor(nil, nil, nil, nil)
    self._uiRepairWareHouseMoney:SetShow(false)
    self._uiRepairWareHouse:SetShow(false)
    InventoryWindow_Close()
  end
  if not _ContentsGroup_RenewUI then
    Panel_Equipment:SetShow(isShow, true)
  end
  self:repairMoneyUpdate()
  if true == _ContentsGroup_RenewUI_Dailog then
    if true == isShow then
      PaGlobalFunc_MainDialog_Close()
    else
      PaGlobalFunc_MainDialog_ReOpen()
    end
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    Panel_Npc_Dialog:SetShow(not isShow)
  else
    PaGlobalFunc_DialogMain_All_ShowToggle(not isShow)
  end
  Panel_Window_Repair:SetShow(isShow, false)
  if false == isGameTypeKorea() then
    self._uiRepairMessageBG:SetShow(isShow)
    self._uiRepairInven:SetShow(isShow)
    self._uiRepairInvenMoney:SetShow(isShow)
    if false == _ContentsGroup_RenewUI then
      FGlobal_Equipment_SetFunctionButtonHide(not isShow)
    end
    self._repairMessage:SetShow(false)
    self._repairMessageJP:SetShow(true)
    self._repairMessageJP:SetText(PAGetString(Defines.StringSheet_GAME, "REPAIR_SELECTITEM_TEXT"))
  else
    self._uiRepairMessageBG:SetShow(isShow)
    self._uiRepairInven:SetShow(isShow)
    self._uiRepairInvenMoney:SetShow(isShow)
    if false == _ContentsGroup_RenewUI then
      FGlobal_Equipment_SetFunctionButtonHide(not isShow)
    end
    self._repairMessageJP:SetShow(false)
    self._repairMessage:SetShow(true)
    self._repairMessage:SetText(PAGetString(Defines.StringSheet_GAME, "REPAIR_SELECTITEM_TEXT"))
  end
  if not Panel_Equipment:IsShow() then
    self._uiRepairMessageBG:SetShow(false)
  end
  self:Repair_Money_SetPos()
  if self._isCamping then
    self._uiRepairStableEquippedItemButton:SetIgnore(true)
    self._uiRepairWharfEquippedItemButton:SetIgnore(true)
    self._uiRepairElephantButton:SetIgnore(true)
    self._uiFixEquipItemButton:SetIgnore(true)
    self._uiRepairStableEquippedItemButton:SetShow(false)
    self._uiRepairWharfEquippedItemButton:SetShow(false)
    self._uiRepairElephantButton:SetShow(false)
    self._uiFixEquipItemButton:SetShow(false)
    PaGlobal_Repair:repair_BtnResize_Camping()
  else
    self._uiRepairStableEquippedItemButton:SetIgnore(false)
    self._uiRepairWharfEquippedItemButton:SetIgnore(false)
    self._uiRepairElephantButton:SetIgnore(false)
    self._uiFixEquipItemButton:SetIgnore(false)
    self._uiRepairStableEquippedItemButton:SetShow(true)
    self._uiRepairWharfEquippedItemButton:SetShow(true)
    self._uiFixEquipItemButton:SetShow(true)
    if self._isContentsEnable then
      self._uiRepairElephantButton:SetShow(true)
    else
      self._uiRepairElephantButton:SetShow(false)
    end
    PaGlobal_Repair:BottomButtonSort_Center()
  end
end
function PaGlobal_Repair_MouseTooltip(isShow, tipType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  local self = PaGlobal_Repair
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_REPAIR_BTN_REPAIR_VEHICLE")
    control = self._uiRepairStableEquippedItemButton
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_REPAIR_BTN_REPAIR_SHIP")
    control = self._uiRepairWharfEquippedItemButton
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_REPAIR_ELEPHANT")
    control = self._uiRepairElephantButton
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_REPAIR_BTN_EQUIPITEM")
    control = self._uiRepairAllEquippedItemButton
  elseif 4 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_REPAIR_BTN_IVNENITEM")
    control = self._uiRepairAllInvenItemButton
  elseif 5 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "REPAIR_MAXENDURANCE_TITLE")
    control = self._uiFixEquipItemButton
  end
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_Repair:repairMoneyUpdate()
  Repair_Money_Update()
end
function Repair_Money_Update()
  local self = PaGlobal_Repair
  self._uiRepairInven:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  self._uiRepairWareHouse:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
end
function PaGlobal_Repair:cursor_PosUpdate()
  self._uiRepairCursor:SetPosX(getMousePosX() - Panel_Window_Repair:GetPosX())
  self._uiRepairCursor:SetPosY(getMousePosY() - Panel_Window_Repair:GetPosY())
end
function PaGlobal_Repair:Repair_Money_SetPos()
  if self._uiRepairInven:GetPosX() - self._uiRepairInvenMoney:GetPosX() - 24 < self._uiRepairTextSizeX then
    self._uiRepairInven:SetPosX(self._uiRepairInvenMoney:GetPosX() + self._uiRepairInvenMoney:GetSizeX() + self._uiRepairInvenMoney:GetTextSizeX() + 20)
    self._uiRepairInven:SetPosY(self._uiRepairInvenMoney:GetPosY())
    self._uiRepairWareHouse:SetPosX(self._uiRepairWareHouseMoney:GetPosX() + self._uiRepairWareHouseMoney:GetSizeX() + self._uiRepairWareHouseMoney:GetTextSizeX() + 20)
    self._uiRepairWareHouse:SetPosY(self._uiRepairWareHouseMoney:GetPosY())
  end
end
function PaGlobal_Repair:repair_registMessageHandler()
  registerEvent("onScreenResize", "Repair_Resize")
  registerEvent("FromClient_MaxEnduranceLuckyRepairEvent", "FromClient_LuckyRepair_resultShow")
  registerEvent("EventWarehouseUpdate", "Repair_Money_Update")
  Panel_LuckyRepair_Result:RegisterUpdateFunc("Chk_LuckyRepair_ResultMsg_ShowTime")
end
function PaGlobal_Repair:setIsCamping(isCamping)
  self._isCamping = isCamping
end
PaGlobal_Repair:initialize()
PaGlobal_Repair:repair_registMessageHandler()
PaGlobal_Repair:repairMoneyUpdate()
