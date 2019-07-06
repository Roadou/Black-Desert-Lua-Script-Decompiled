Panel_GoldenTreasureBox:SetShow(false, false)
Panel_GoldenTreasureBox:setMaskingChild(true)
Panel_GoldenTreasureBox:setGlassBackground(true)
Panel_GoldenTreasureBox:SetDragAll(true)
Panel_GoldenTreasureBox:RegisterShowEventFunc(true, "Panel_GoldenTreasureBox_ShowAni()")
Panel_GoldenTreasureBox:RegisterShowEventFunc(false, "Panel_GoldenTreasureBox_HideAni()")
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
function Panel_GoldenTreasureBox_ShowAni()
  UIAni.fadeInSCR_Down(Panel_GoldenTreasureBox)
  local aniInfo1 = Panel_GoldenTreasureBox:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_GoldenTreasureBox:GetSizeX() / 2
  aniInfo1.AxisY = Panel_GoldenTreasureBox:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_GoldenTreasureBox:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_GoldenTreasureBox:GetSizeX() / 2
  aniInfo2.AxisY = Panel_GoldenTreasureBox:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_GoldenTreasureBox_HideAni()
  Panel_GoldenTreasureBox:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_GoldenTreasureBox:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local treasureBox = {
  btnClose = UI.getChildControl(Panel_GoldenTreasureBox, "Button_CloseIcon"),
  closeBox_Head = UI.getChildControl(Panel_GoldenTreasureBox, "Static_CloseBox_Head"),
  closeBox_Body = UI.getChildControl(Panel_GoldenTreasureBox, "Static_CloseBox_Body"),
  openBox = UI.getChildControl(Panel_GoldenTreasureBox, "Static_OpenBox"),
  windowTitle = UI.getChildControl(Panel_GoldenTreasureBox, "StaticText_Title"),
  txt_Title = UI.getChildControl(Panel_GoldenTreasureBox, "Static_PartLine"),
  boxBG = UI.getChildControl(Panel_GoldenTreasureBox, "Static_BoxBg"),
  radioBG = UI.getChildControl(Panel_GoldenTreasureBox, "Static_RadioBtnBg"),
  radioBtn_NormalKey = UI.getChildControl(Panel_GoldenTreasureBox, "RadioButton_GoldenKey"),
  radioBtn_CashKey = UI.getChildControl(Panel_GoldenTreasureBox, "RadioButton_GoldenCashKey"),
  descBG = UI.getChildControl(Panel_GoldenTreasureBox, "Static_DescBg"),
  txt_Desc = UI.getChildControl(Panel_GoldenTreasureBox, "StaticText_1"),
  btn_Open = UI.getChildControl(Panel_GoldenTreasureBox, "Button_Open"),
  normalKeyCount = 0,
  cashKeyCount = 0,
  keyContentsEventType = 50,
  _fromWhereType,
  _fromSlotNo,
  materialWhereType,
  materialSlotNo = {
    [0] = nil,
    [1] = nil
  },
  _driganBoxItemKey = 750041,
  _driganKeyItemKey = 750042
}
treasureBox.btnClose:addInputEvent("Mouse_LUp", "Panel_GoldenTreasureBox_Close()")
treasureBox.btn_Open:addInputEvent("Mouse_LUp", "GoldenTreasureBox_Open()")
function GoldenTreasureData_Init(isDrigan)
  treasureBox.normalKeyCount = 0
  treasureBox.cashKeyCount = 0
  treasureBox.materialSlotNo[0] = nil
  treasureBox.materialSlotNo[1] = nil
  GoldenKey_CheckInventory(isDrigan)
  treasureBox.radioBtn_NormalKey:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TREASUREBOX_GOLDKEY", "count", treasureBox.normalKeyCount))
  treasureBox.radioBtn_CashKey:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TREASUREBOX_GOLDENKEY", "count", treasureBox.cashKeyCount))
  local checkBtnTextSizeX = math.max(treasureBox.radioBtn_NormalKey:GetTextSizeX(), treasureBox.radioBtn_CashKey:GetTextSizeX())
  treasureBox.radioBtn_NormalKey:SetPosX(treasureBox.radioBG:GetSizeX() / 2 - checkBtnTextSizeX / 2 - 10)
  treasureBox.radioBtn_CashKey:SetPosX(treasureBox.radioBG:GetSizeX() / 2 - checkBtnTextSizeX / 2 - 10)
  treasureBox.txt_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  if isDrigan then
    treasureBox.radioBtn_NormalKey:SetPosY(432)
    treasureBox.radioBtn_CashKey:SetShow(false)
    treasureBox.windowTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TREASUREBOX_DRIGANTITLE"))
    treasureBox.radioBtn_NormalKey:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TREASUREBOX_DRIGANGOLDKEY", "count", treasureBox.normalKeyCount))
    treasureBox.txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TREASUREBOX_DRIGANDESC"))
  else
    treasureBox.radioBtn_NormalKey:SetPosY(445)
    treasureBox.radioBtn_CashKey:SetShow(true)
    treasureBox.windowTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GOLDENTREASUREBOX_TITLE"))
    treasureBox.txt_Desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GOLDENTREASUREBOX_DESC"))
  end
  treasureBox.descBG:SetSize(treasureBox.descBG:GetSizeX(), treasureBox.txt_Desc:GetTextSizeY() + 20)
  Panel_GoldenTreasureBox:SetSize(Panel_GoldenTreasureBox:GetSizeX(), treasureBox.txt_Title:GetSizeY() + treasureBox.boxBG:GetSizeY() + treasureBox.radioBG:GetSizeY() + treasureBox.txt_Desc:GetTextSizeY() + 100)
  treasureBox.btn_Open:ComputePos()
end
function FromClient_RequestUseSealItemBox(fromWhereType, fromSlotNo)
  Panel_TresureBox_RePos()
  Panel_GoldenTreasureBox:SetShow(true, true)
  treasureBox.radioBtn_NormalKey:SetCheck(true)
  treasureBox.radioBtn_CashKey:SetCheck(false)
  treasureBox._fromWhereType = fromWhereType
  treasureBox._fromSlotNo = fromSlotNo
  local isDrigan = treasureBox:CheckDriganBox(fromWhereType, fromSlotNo)
  GoldenTreasureData_Init(isDrigan)
end
function treasureBox:CheckDriganBox(fromWhereType, fromSlotNo)
  local itemWrapper = getInventoryItemByType(fromWhereType, fromSlotNo)
  if nil ~= itemWrapper then
    local itemKey = itemWrapper:getStaticStatus():get()._key:getItemKey()
    if treasureBox._driganBoxItemKey == itemKey then
      return true
    end
  end
  return false
end
function GoldenKey_CheckInventory(isDrigan)
  local self = treasureBox
  local inventory = Inventory_GetCurrentInventory()
  local invenMaxSize = inventory:sizeXXX()
  if isDrigan then
    for index = 1, invenMaxSize - 1 do
      local itemWrapper = getInventoryItemByType(0, index)
      if nil ~= itemWrapper and self.keyContentsEventType == itemWrapper:getStaticStatus():get():getContentsEventType() then
        local itemKey = itemWrapper:getStaticStatus():get()._key:getItemKey()
        if treasureBox._driganKeyItemKey == itemKey then
          self.normalKeyCount = self.normalKeyCount + Int64toInt32(itemWrapper:get():getCount_s64())
          if nil == self.materialSlotNo[0] then
            self.materialSlotNo[0] = index
            break
          end
        end
      end
    end
  else
    for index = 1, invenMaxSize - 1 do
      local itemWrapper = getInventoryItemByType(0, index)
      if nil ~= itemWrapper and self.keyContentsEventType == itemWrapper:getStaticStatus():get():getContentsEventType() then
        local itemKey = itemWrapper:getStaticStatus():get()._key:getItemKey()
        if treasureBox._driganKeyItemKey ~= itemKey then
          self.normalKeyCount = self.normalKeyCount + Int64toInt32(itemWrapper:get():getCount_s64())
          if nil == self.materialSlotNo[0] then
            self.materialSlotNo[0] = index
          end
        end
      end
      local cashItemWrapper = getInventoryItemByType(17, index)
      if nil ~= cashItemWrapper and self.keyContentsEventType == cashItemWrapper:getStaticStatus():get():getContentsEventType() then
        self.cashKeyCount = self.cashKeyCount + Int64toInt32(cashItemWrapper:get():getCount_s64())
        if nil == self.materialSlotNo[1] then
          self.materialSlotNo[1] = index
        end
      end
    end
  end
end
local isAni = false
local _time = 0
function GoldenTreasureBox_Open()
  local self = treasureBox
  local isDrigan = self:CheckDriganBox(self._fromWhereType, self._fromSlotNo)
  local normalKeyUse = self.radioBtn_NormalKey:IsCheck()
  local materialWhereType, materialSlotNo
  if normalKeyUse then
    if self.normalKeyCount <= 0 then
      if isDrigan then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TREASUREBOX_NEEDDRIGANGOLDKEY"))
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TREASUREBOX_NEEDGOLDKEY"))
      end
      return
    end
    materialWhereType = 0
    materialSlotNo = self.materialSlotNo[0]
  else
    if 0 >= self.cashKeyCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TREASUREBOX_NEEDGOLDENKEY"))
      return
    end
    materialWhereType = 17
    materialSlotNo = self.materialSlotNo[1]
  end
  treasureBox.closeBox_Head:SetShow(false)
  treasureBox.closeBox_Body:SetShow(false)
  treasureBox.openBox:SetShow(true)
  self.openBox:EraseAllEffect()
  self.openBox:AddEffect("fCO_Egg_Random_01B", false, 0, 0)
  isAni = true
  _time = 0
  ToClient_requestOpenSealItemBox(self._fromWhereType, self._fromSlotNo, materialWhereType, materialSlotNo)
  audioPostEvent_SystemUi(11, 14)
  _AudioPostEvent_SystemUiForXBOX(11, 14)
end
function GoldenTreasureBox_Animation(deltaTime)
  if not isAni then
    return
  end
  _time = _time + deltaTime
  if _time > 5 then
    treasureBox.closeBox_Head:SetShow(true)
    treasureBox.closeBox_Body:SetShow(true)
    treasureBox.openBox:SetShow(false)
    isAni = false
    _time = 0
    audioPostEvent_SystemUi(11, 15)
    _AudioPostEvent_SystemUiForXBOX(11, 15)
    isTreasureBoxCheck()
  end
end
function isTreasureBoxCheck()
  local itemWrapper = getInventoryItemByType(treasureBox._fromWhereType, treasureBox._fromSlotNo)
  if nil == itemWrapper then
    treasureBox._fromWhereType = nil
    treasureBox._fromSlotNo = nil
    Panel_GoldenTreasureBox_Close()
  end
end
function FromClient_ResponseSealItemBox(itemKey)
  local isDrigan = treasureBox:CheckDriganBox(treasureBox._fromWhereType, treasureBox._fromSlotNo)
  GoldenTreasureData_Init(isDrigan)
  local itemESSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
  local sendMsg = {
    main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GACHA_ROULETTE_GETITEM", "getName", itemESSW:getName()),
    sub = "",
    addMsg = ""
  }
  Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect(sendMsg, 3.5, 17)
end
function Panel_GoldenTreasureBox_Close()
  Panel_GoldenTreasureBox:SetShow(false, true)
end
function Panel_TresureBox_RePos()
  Panel_GoldenTreasureBox:SetPosX(getScreenSizeX() / 2 - Panel_GoldenTreasureBox:GetSizeX() / 2)
  Panel_GoldenTreasureBox:SetPosY(getScreenSizeY() / 2 - Panel_GoldenTreasureBox:GetSizeY() / 2)
  local strNormalKey = treasureBox.radioBtn_NormalKey:GetTextSizeX()
  local strCashKey = treasureBox.radioBtn_CashKey:GetTextSizeX()
  local normalPosX = treasureBox.radioBtn_NormalKey:GetPosX()
  local cashPosX = treasureBox.radioBtn_CashKey:GetPosX()
  local strPos = 0
  local strSize = 0
  if strNormalKey > strCashKey then
    strPos = normalPosX
    strSize = strNormalKey
  else
    strPos = cashPosX
    strSize = strCashKey
  end
  local panelSizeX = Panel_GoldenTreasureBox:GetSizeX()
end
Panel_GoldenTreasureBox:RegisterUpdateFunc("GoldenTreasureBox_Animation")
registerEvent("FromClient_RequestUseSealItemBox", "FromClient_RequestUseSealItemBox")
registerEvent("FromClient_ResponseSealItemBox", "FromClient_ResponseSealItemBox")
registerEvent("onScreenResize", "Panel_TresureBox_RePos")
