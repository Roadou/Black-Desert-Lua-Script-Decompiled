local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
Panel_Improvement:setMaskingChild(true)
Panel_Improvement:setGlassBackground(true)
Panel_Improvement:SetDragEnable(true)
Panel_Improvement:SetDragAll(true)
Panel_Improvement:RegisterShowEventFunc(true, "Improvement_ShowAni()")
Panel_Improvement:RegisterShowEventFunc(false, "Improvement_HideAni()")
function Improvement_ShowAni()
  local ImageMoveAni = Panel_Improvement:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni:SetStartPosition(getScreenSizeX() / 2 - Panel_Improvement:GetSizeX() / 2, 0 - Panel_Improvement:GetSizeY())
  ImageMoveAni:SetEndPosition(getScreenSizeX() / 2 - Panel_Improvement:GetSizeX() / 2, getScreenSizeY() - getScreenSizeY() / 2 - Panel_Improvement:GetSizeY() / 2)
  ImageMoveAni.IsChangeChild = true
  Panel_Improvement:CalcUIAniPos(ImageMoveAni)
  ImageMoveAni:SetDisableWhileAni(true)
end
function Improvement_HideAni()
  local ImageMoveAni = Panel_Improvement:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni:SetStartPosition(getScreenSizeX() / 2 - Panel_Improvement:GetSizeX() / 2, getScreenSizeY() - getScreenSizeY() / 2 - Panel_Improvement:GetSizeY() / 2)
  ImageMoveAni:SetEndPosition(getScreenSizeX() / 2 - Panel_Improvement:GetSizeX() / 2, 0 - Panel_Improvement:GetSizeY())
  ImageMoveAni.IsChangeChild = true
  Panel_Improvement:CalcUIAniPos(ImageMoveAni)
  ImageMoveAni:SetDisableWhileAni(true)
  ImageMoveAni:SetHideAtEnd(true)
  ImageMoveAni:SetDisableWhileAni(true)
end
local improvement = {
  title = UI.getChildControl(Panel_Improvement, "Static_Text_Title"),
  effectControl = UI.getChildControl(Panel_Improvement, "Static_AddEffect"),
  slot_0 = UI.getChildControl(Panel_Improvement, "Static_Slot_0"),
  slot_1 = UI.getChildControl(Panel_Improvement, "Static_Slot_1"),
  descBg = UI.getChildControl(Panel_Improvement, "StaticText_CommentBG"),
  desc = UI.getChildControl(Panel_Improvement, "StaticText_Comment"),
  btnApply = UI.getChildControl(Panel_Improvement, "Button_Apply"),
  _chk_Skip = UI.getChildControl(Panel_Improvement, "CheckButton_SkipImprovement"),
  txt_result = UI.getChildControl(Panel_Improvement, "StaticText_Result"),
  equipItem = nil,
  materialItem = nil,
  equipSlot = {},
  materialSlot = {},
  animationTime = 0,
  _doImprove = false,
  _doAnimation = false
}
improvement.btnApply:addInputEvent("Mouse_LUp", "DoImprove()")
improvement.descBg:SetTextMode(UI_TM.eTextMode_AutoWrap)
improvement.descBg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_DESC"))
improvement.title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_TITLE"))
improvement.desc:SetShow(false)
improvement.descBg:SetShow(true)
local textSizeY = improvement.descBg:GetTextSizeY()
local addSizeY = textSizeY + 15 - improvement.descBg:GetSizeY()
improvement.descBg:SetSize(improvement.descBg:GetSizeX(), textSizeY + 15)
Panel_Improvement:SetSize(Panel_Improvement:GetSizeX(), Panel_Improvement:GetSizeY() + addSizeY)
improvement.descBg:ComputePos()
improvement.desc:ComputePos()
improvement.btnApply:ComputePos()
local slotConfig = {
  createIcon = true,
  createBorder = true,
  createCount = true,
  createEnchant = true,
  createCash = false
}
function improvement:Init()
  SlotItem.new(self.equipSlot, "Improvement_EquipSlot", 0, self.slot_0, slotConfig)
  self.equipSlot:createChild()
  self.equipSlot.icon:SetPosX(0)
  self.equipSlot.icon:SetPosY(0)
  self.equipSlot.icon:addInputEvent("Mouse_On", "Improvement_Tooltip( true, " .. 0 .. " )")
  self.equipSlot.icon:addInputEvent("Mouse_Out", "Improvement_Tooltip( false, " .. 0 .. " )")
  self.equipSlot.icon:addInputEvent("Mouse_RUp", "Improvement_SlotInit()")
  SlotItem.new(self.materialSlot, "Improvement_MaterialSlot", 0, self.slot_1, slotConfig)
  self.materialSlot:createChild()
  self.materialSlot.icon:SetPosX(0)
  self.materialSlot.icon:SetPosY(0)
  self.materialSlot.icon:addInputEvent("Mouse_On", "Improvement_Tooltip( true, " .. 1 .. " )")
  self.materialSlot.icon:addInputEvent("Mouse_Out", "Improvement_Tooltip( false, " .. 1 .. " )")
  self.materialSlot.icon:addInputEvent("Mouse_RUp", "Improvement_SlotInit()")
  self._chk_Skip:SetCheck(false)
  self._chk_Skip:addInputEvent("Mouse_On", "Improvement_SimpleTooltip(true, 0)")
  self._chk_Skip:addInputEvent("Mouse_Out", "Improvement_SimpleTooltip(false)")
  self._chk_Skip:SetText(self._chk_Skip:GetText())
  self._chk_Skip:SetEnableArea(0, 0, self._chk_Skip:GetTextSizeX() + 30, 25)
end
improvement:Init()
function Panel_Improvement_Show()
  Panel_Improvement:SetShow(true, true)
  improvement.btnApply:SetIgnore(false)
  improvement.equipItem = nil
  improvement.materialItem = nil
  improvement._doImprove = false
  improvement._doAnimation = false
  InventoryWindow_Show()
  getImproveInformation():clearData()
  improvement.equipSlot:clearItem()
  improvement.materialSlot:clearItem()
  Inventory_SetFunctor(ImproveInvenFilerMainItem, ImproveSetMainItemFromInventory, Panel_Improvement_Hide, nil)
  FGlobal_SetInventoryDragNoUse(Panel_Improvement)
  Equipment_PosSaveMemory()
  if false == _ContentsGroup_RenewUI then
    Panel_Equipment:SetShow(true, true)
    Panel_Equipment:SetPosX(10)
    Panel_Equipment:SetPosY(Panel_Window_Inventory:GetPosY())
  end
  audioPostEvent_SystemUi(1, 0)
  improvement._chk_Skip:SetCheck(false)
end
function Panel_Improvement_Hide()
  local self = improvement
  self.animationTime = 0
  self._doImprove = false
  self._doAnimation = false
  self.equipSlot:clearItem()
  self.materialSlot:clearItem()
  self.effectControl:EraseAllEffect()
  self.equipSlot.icon:EraseAllEffect()
  self.materialSlot.icon:EraseAllEffect()
  getImproveInformation():clearData()
  ToClient_BlackspiritEnchantClose()
  Panel_Equipment:SetShow(false)
  Panel_Improvement:SetShow(false, true)
  Equipment_PosLoadMemory()
end
function ImproveInvenFilerMainItem(slotNo, notUse_itemWrappers, whereType)
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  local ssW = itemWrapper:getStaticStatus():get()
  return not ssW:isImprovable()
end
function ImproveSetMainItemFromInventory(slotNo, itemWrapper, count, inventoryType)
  local self = improvement
  local improveInfo = getImproveInformation()
  if nil == improveInfo then
    return
  end
  improveInfo:SetImproveSlot(inventoryType, slotNo)
  self.equipSlot:clearItem()
  self.equipSlot:setItem(itemWrapper)
  self.equipItem = slotNo
  audioPostEvent_SystemUi(0, 16)
  Inventory_SetFunctor(ImproveInvenFilerSubItem, ImproveSetMaterialItemFromInventory, Panel_Improvement_Hide, nil)
end
function ImproveInvenFilerSubItem(slotNo, notUse_itemWrappers, whereType)
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if CppEnums.ItemWhereType.eCashInventory == whereType then
    return true
  end
  local returnValue = true
  if 0 ~= getImproveInformation():checkIsValidSubItem(slotNo) then
    returnValue = true
  else
    returnValue = false
    if CppEnums.ItemWhereType.eInventory ~= whereType then
      returnValue = true
    end
  end
  return returnValue
end
function ImproveSetMaterialItemFromInventory(slotNo, itemWrapper, count, inventoryType)
  local self = improvement
  local improveInfo = getImproveInformation()
  if nil == improveInfo then
    return
  end
  improveInfo:SetImproveSlot(inventoryType, slotNo)
  self.materialSlot:clearItem()
  self.materialSlot:setItem(itemWrapper)
  improvement.materialItem = slotNo
  Inventory_SetFunctor(ImproveInvenFilerAll, nil, Panel_Improvement_Hide, nil)
  audioPostEvent_SystemUi(0, 16)
end
function ImproveInvenFilerAll()
  return true
end
function Improvement_SlotInit()
  local self = improvement
  if self._doImprove then
    self.effectControl:EraseAllEffect()
    self.equipSlot.icon:EraseAllEffect()
    self.materialSlot.icon:EraseAllEffect()
    ToClient_BlackspiritEnchantCancel()
    self._doImprove = false
  end
  self.equipSlot:clearItem()
  self.materialSlot:clearItem()
  self.effectControl:EraseAllEffect()
  self.equipSlot.icon:EraseAllEffect()
  self.materialSlot.icon:EraseAllEffect()
  getImproveInformation():clearData()
  self._doAnimation = false
  self.equipItem = nil
  self.materialItem = nil
  Inventory_SetFunctor(ImproveInvenFilerMainItem, ImproveSetMainItemFromInventory, Panel_Improvement_Hide, nil)
end
function Improvement_Tooltip(isShow, slotType)
  if false == isShow then
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  local self = improvement
  local slotNo, itemWrapper, uiBase
  if 0 == slotType then
    slotNo = self.equipItem
    uiBase = self.equipSlot.icon
  elseif 1 == slotType then
    slotNo = self.materialItem
    uiBase = self.materialSlot.icon
  end
  if nil == slotNo then
    return
  end
  local itemWrapper = getInventoryItemByType(0, slotNo)
  if nil == itemWrapper then
    return
  end
  if isShow then
    Panel_Tooltip_Item_Show(itemWrapper, uiBase, false, true, nil, nil, nil, nil, "Improve", slotNo)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function Improvement_SimpleTooltip(isShow, tipType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = improvement
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_SIMPLETOOLTIP_SKIP_NAME")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_SIMPLETOOLTIP_SKIP_DESC")
  control = self._chk_Skip
  TooltipSimple_Show(control, name, desc)
end
function DoImprove()
  local self = improvement
  if self._doImprove then
    self.effectControl:EraseAllEffect()
    self.equipSlot.icon:EraseAllEffect()
    self.materialSlot.icon:EraseAllEffect()
    ToClient_BlackspiritEnchantCancel()
    self._doImprove = false
    return
  end
  local improveInfo = getImproveInformation()
  if improveInfo:IsReadyImprove() ~= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_NEEDITEMALERT"))
    return
  end
  if self._chk_Skip:IsCheck() then
    getImproveInformation():doImprove()
    self.equipSlot.icon:EraseAllEffect()
    self.equipSlot.icon:AddEffect("UI_ItemEnchant01", false, -6, -6)
    ToClient_BlackspiritEnchantClose()
    self._doImprove = false
    self._doAnimation = false
    self.animationTime = 0
    self.effectControl:EraseAllEffect()
    self.materialSlot.icon:EraseAllEffect()
    return
  else
    self.effectControl:EraseAllEffect()
    self.equipSlot.icon:EraseAllEffect()
    self.materialSlot.icon:EraseAllEffect()
    self.equipSlot.icon:AddEffect("fUI_LimitOver01A", false, 0, 0)
    self.materialSlot.icon:AddEffect("fUI_LimitOver01A", false, 0, 0)
    self.effectControl:AddEffect("fUI_LimitOver02A", true, 0, 0)
    self.effectControl:AddEffect("UI_LimitOverLine_02", false, 0, 0)
    self.effectControl:AddEffect("fUI_LimitOver_Spark", false, 0, 0)
    audioPostEvent_SystemUi(5, 6)
    audioPostEvent_SystemUi(5, 9)
  end
  self.animationTime = 0
  self._doImprove = true
  ToClient_BlackspiritEnchantStart()
end
function UpdateFunc_DoingImprove(deltaTime)
  local self = improvement
  self.animationTime = self.animationTime + deltaTime
  if self._doImprove then
    self.btnApply:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_CANCEL"))
  else
    self.btnApply:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_TITLE"))
  end
  if self._doAnimation then
    self.btnApply:SetIgnore(true)
  else
    self.btnApply:SetIgnore(false)
  end
  if self.animationTime > 6 and self._doImprove then
    getImproveInformation():doImprove()
    self.equipSlot.icon:EraseAllEffect()
    self.equipSlot.icon:AddEffect("UI_ItemEnchant01", false, -6, -6)
    ToClient_BlackspiritEnchantClose()
    self._doImprove = false
    self._doAnimation = true
    self.animationTime = 0
  end
  if self.animationTime > 3 and self._doAnimation then
    self.animationTime = 0
    self.effectControl:EraseAllEffect()
    self.equipSlot.icon:EraseAllEffect()
    self.materialSlot.icon:EraseAllEffect()
    self._doAnimation = false
  end
end
function FromClient_ResponseImporve(itemEnchantKey, index)
  local self = improvement
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemEnchantKey))
  local resultText = self.txt_result
  local isSuccess = false
  resultText:EraseAllEffect()
  if 0 == index then
    resultText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_SUCCESSMSG_NEW"))
    resultText:AddEffect("UI_QustComplete01", false, 0, 0)
    audioPostEvent_SystemUi(5, 1)
    self.equipSlot:clearItem()
    self.materialSlot:clearItem()
    self.materialItem = nil
    self.equipItem = nil
    getImproveInformation():clearData()
    Inventory_SetFunctor(ImproveInvenFilerMainItem, ImproveSetMainItemFromInventory, Panel_Improvement_Hide, nil)
    isSuccess = true
  else
    resultText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_FAILMSG_NEW"))
    resultText:AddEffect("fUI_Enchant_Fail", false, 0, 0)
    audioPostEvent_SystemUi(5, 2)
    local itemWrapper = getInventoryItemByType(0, self.materialItem)
    if nil ~= itemWrapper then
      self.materialSlot:setItem(itemWrapper)
    else
      self.equipSlot:clearItem()
      self.materialSlot:clearItem()
      self.materialItem = nil
      self.equipItem = nil
      getImproveInformation():clearData()
      Inventory_SetFunctor(ImproveInvenFilerMainItem, ImproveSetMainItemFromInventory, Panel_Improvement_Hide, nil)
    end
    isSuccess = false
  end
  Improvement_Result_ShowAni()
  Improvement_Result_HideAni(isSuccess)
end
function Improvement_Result_ShowAni()
  if nil == Panel_Improvement then
    return
  end
  improvement.txt_result:SetShow(true)
  local showAni = improvement.txt_result:addColorAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  showAni:SetStartColor(Defines.Color.C_00FFFFFF)
  showAni:SetEndColor(Defines.Color.C_FFFFFFFF)
  showAni:SetStartIntensity(3)
  showAni:SetEndIntensity(1)
  showAni.IsChangeChild = true
end
function Improvement_Result_HideAni(isSuccess)
  if nil == Panel_Improvement then
    return
  end
  local aniTime = 1
  if true == isSuccess then
    aniTime = 1.5
  end
  local closeAni = improvement.txt_result:addColorAnimation(aniTime, aniTime + 0.22, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(Defines.Color.C_FFFFFFFF)
  closeAni:SetEndColor(Defines.Color.C_00FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
  closeAni:SetDisableWhileAni(true)
end
Panel_Improvement:RegisterUpdateFunc("UpdateFunc_DoingImprove")
registerEvent("FromClient_ResponseImporve", "FromClient_ResponseImporve")
