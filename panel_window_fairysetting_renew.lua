Panel_Window_FairySetting:SetShow(false)
local ClassType_Valkiry = 24
local UI_TM = CppEnums.TextMode
local spiritClass = {
  [0] = 0,
  12,
  19,
  20,
  21,
  23,
  26,
  30,
  11,
  25
}
local fairyMainPotionData = {
  [0] = {
    502,
    513,
    514,
    517,
    518,
    519,
    524,
    525,
    528,
    529,
    530,
    538,
    551,
    552,
    553,
    554,
    555,
    17568,
    17569,
    19932,
    19933,
    19934,
    19935,
    566,
    567,
    568,
    578,
    17679,
    17684,
    580,
    583,
    18853,
    56090,
    56093,
    17681,
    17682,
    17683
  }
}
local fairySubPotionData = {
  [1] = {
    [0] = 503,
    520,
    521,
    522,
    526,
    527,
    515,
    516,
    531,
    532,
    533,
    17570,
    17571,
    17680,
    17685,
    17686,
    17687,
    17688,
    18854,
    19936,
    19937,
    19938,
    569,
    570,
    571,
    582,
    561,
    562,
    563,
    564,
    565,
    18857,
    579,
    56092,
    56091,
    56094,
    581,
    584
  },
  [2] = {
    [0] = 591,
    592,
    593,
    594,
    827,
    828,
    829,
    830,
    17707,
    17708,
    17709,
    17710,
    569,
    570,
    571,
    582,
    18857,
    579,
    56092
  },
  [3] = {
    [0] = 595,
    596,
    597,
    598,
    831,
    832,
    833,
    834,
    17711,
    17712,
    17713,
    17714,
    569,
    570,
    571,
    582,
    18857,
    579,
    56092
  }
}
local subPotionStr = {
  [1] = PAGetString(Defines.StringSheet_RESOURCE, "CHARACTERINFO_TEXT_MPREGEN"),
  [2] = PAGetString(Defines.StringSheet_RESOURCE, "CHARACTERINFO_TEXT_FPREGEN"),
  [3] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRY_SETTING_GPREGEN")
}
local _Static_MainBG = UI.getChildControl(Panel_Window_FairySetting, "Static_SettingMainBG")
local FairySetting_ReNew = {
  _currentFairyNoStr = nil,
  _currentHpKey = nil,
  _currentMpKey = nil,
  _currentHpRate = 0,
  _currentMpRate = 0,
  _currentClassType = nil,
  _currentTier = 0,
  _UI = {
    _StaticText_MPTitle = UI.getChildControl(_Static_MainBG, "StaticText_MPTitle"),
    _Static_HPItemSlotBigBG = UI.getChildControl(_Static_MainBG, "Static_HPItemSlotBGBig"),
    _Static_MPItemSlotBigBG = UI.getChildControl(_Static_MainBG, "Static_MPItemSlotBGBig"),
    _Static_SkillListBG2 = UI.getChildControl(Panel_Window_FairySetting, "Static_SkillListBG2"),
    _Static_InsideBg = UI.getChildControl(Panel_Window_FairySetting, "Static_InsideBg"),
    _Button_Yes = UI.getChildControl(Panel_Window_FairySetting, "Button_Yes"),
    _Button_No = UI.getChildControl(Panel_Window_FairySetting, "Button_No"),
    _Button_Close = UI.getChildControl(Panel_Window_FairySetting, "Button_Win_Close"),
    _hp_Value = UI.getChildControl(_Static_MainBG, "HpSlider_CurrentValue"),
    _mp_Value = UI.getChildControl(_Static_MainBG, "MpSlider_CurrentValue"),
    _hp_Slider = UI.getChildControl(_Static_MainBG, "Slider_HpSlider"),
    _mp_Slider = UI.getChildControl(_Static_MainBG, "Slider_MpSlider"),
    _hp_Progress = UI.getChildControl(_Static_MainBG, "Progress2_Hp"),
    _mp_Progress = UI.getChildControl(_Static_MainBG, "Progress2_Mp")
  }
}
function FairySetting_ReNew:RegistEvent()
  self._UI._Button_No:addInputEvent("Mouse_LUp", "PaGlobal_FairySetting_Close()")
  self._UI._Button_Yes:addInputEvent("Mouse_LUp", "PaGlobal_FairySetting_Request()")
  self._UI._Button_Close:addInputEvent("Mouse_LUp", "PaGlobal_FairySetting_Close()")
  self._UI._Button_Close:addInputEvent("Mouse_LUp", "PaGlobal_FairySetting_Close()")
  self._UI._Static_HPItemSlotBig:addInputEvent("Mouse_RUp", "PaGlobal_FairySetting_ClearHP()")
  self._UI._Static_MPItemSlotBig:addInputEvent("Mouse_RUp", "PaGlobal_FairySetting_ClearMP()")
  self._UI._Static_HPItemSlotBig:addInputEvent("Mouse_On", "PaGlobal_FairySetting_ShowToolTip(true, true)")
  self._UI._Static_MPItemSlotBig:addInputEvent("Mouse_On", "PaGlobal_FairySetting_ShowToolTip(false, true)")
  self._UI._Static_HPItemSlotBig:addInputEvent("Mouse_Out", "PaGlobal_FairySetting_ShowToolTip(true, false)")
  self._UI._Static_MPItemSlotBig:addInputEvent("Mouse_Out", "PaGlobal_FairySetting_ShowToolTip(false, false)")
  self._UI._hp_Slider:addInputEvent("Mouse_LPress", "PaGlobal_FairyInfo_HpSlider()")
  self._UI._btn_HpSlider:addInputEvent("Mouse_LPress", "PaGlobal_FairyInfo_HpSlider()")
  self._UI._mp_Slider:addInputEvent("Mouse_LPress", "PaGlobal_FairyInfo_MpSlider()")
  self._UI._btn_MpSlider:addInputEvent("Mouse_LPress", "PaGlobal_FairyInfo_MpSlider()")
end
function PaGlobal_FairySetting_ClearHP()
  local self = FairySetting_ReNew
  self._currentHpKey = nil
  self._currentHpRate = 0
  self._UI._Static_HPItemSlotBig:SetShow(false)
  self:UpdateSetting(false)
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_FairySetting_ClearMP()
  local self = FairySetting_ReNew
  self._currentMpKey = nil
  self._currentMpRate = 0
  self._UI._Static_MPItemSlotBig:SetShow(false)
  self:UpdateSetting(false)
  Panel_Tooltip_Item_hideTooltip()
end
function FairySetting_ReNew:Initialize()
  self._currentFairyNoStr = nil
  self._currentHpKey = nil
  self._currentHpRate = 0
  self._currentMpKey = nil
  self._currentMpRate = 0
  self._currentTier = 0
  self._UI._Static_HPItemSlotBig = UI.getChildControl(self._UI._Static_HPItemSlotBigBG, "Static_HPItemSlotBig")
  self._UI._Static_MPItemSlotBig = UI.getChildControl(self._UI._Static_MPItemSlotBigBG, "Static_MPItemSlotBig")
  self._UI._btn_HpSlider = UI.getChildControl(self._UI._hp_Slider, "Slider_Hp_Button")
  self._UI._btn_MpSlider = UI.getChildControl(self._UI._mp_Slider, "Slider_Mp_Button")
  self._UI._txt_BottomDesc = UI.getChildControl(self._UI._Static_SkillListBG2, "StaticText_SkillListDesc")
  self._UI._txt_BottomDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._UI._txt_BottomDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRY_SETTING_BOTTOM_DESC"))
  local _sizeUp = self._UI._txt_BottomDesc:GetTextSizeY() - self._UI._Static_SkillListBG2:GetSizeY() + 20
  if _sizeUp > 0 then
    Panel_Window_FairySetting:SetSize(Panel_Window_FairySetting:GetSizeX(), Panel_Window_FairySetting:GetSizeY() + _sizeUp)
    self._UI._Static_InsideBg:SetSize(self._UI._Static_InsideBg:GetSizeX(), Panel_Window_FairySetting:GetSizeY() - 114)
    self._UI._Static_InsideBg:SetSpanSize(0, 0)
    self._UI._Static_InsideBg:ComputePos()
    self._UI._Static_SkillListBG2:SetSize(self._UI._Static_SkillListBG2:GetSizeX(), self._UI._Static_SkillListBG2:GetSizeY() + _sizeUp + 10)
    self._UI._txt_BottomDesc:SetSpanSize(0, 0)
  end
  self._UI._Button_Yes:ComputePos()
  self._UI._Button_No:ComputePos()
  self:RegistEvent()
end
function FairySetting_ReNew:UpdateSetting(updateData)
  if nil == self._currentFairyNoStr then
    return
  end
  local fairyNo_s64 = tonumber64(self._currentFairyNoStr)
  local settingData = ToClient_getFairySettingData(fairyNo_s64)
  if nil ~= settingData and true == updateData then
    self._currentHpKey = settingData._hpItemKey
    self._currentMpKey = settingData._mpItemKey
    self._currentHpRate = settingData._hpMinRate
    self._currentMpRate = settingData._mpMinRate
  end
  local ItemHpSSW, ItemMpSSW
  if nil ~= self._currentHpKey then
    ItemHpSSW = getItemEnchantStaticStatus(self._currentHpKey)
  end
  if nil ~= ItemHpSSW then
    self._UI._Static_HPItemSlotBig:ChangeTextureInfoName("Icon/" .. ItemHpSSW:getIconPath())
    self._UI._Static_HPItemSlotBig:SetShow(true)
  else
    self._UI._Static_HPItemSlotBig:SetShow(false)
  end
  if nil ~= self._currentMpKey then
    ItemMpSSW = getItemEnchantStaticStatus(self._currentMpKey)
  end
  if nil ~= ItemMpSSW then
    self._UI._Static_MPItemSlotBig:ChangeTextureInfoName("Icon/" .. ItemMpSSW:getIconPath())
    self._UI._Static_MPItemSlotBig:SetShow(true)
  else
    self._UI._Static_MPItemSlotBig:SetShow(false)
  end
  local hpValue = 0
  local mpValue = 0
  if nil == self._currentHpRate then
    hpValue = 0
    self._currentHpRate = 0
  end
  if nil == self._currentMpRate then
    mpValue = 0
    self._currentMpRate = 0
  end
  if self._currentHpRate >= 0 and self._currentHpRate <= 100 then
    hpValue = self._currentHpRate .. "%"
  end
  if 0 == self._currentHpRate then
    hpValue = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYSETTING_NO_USE")
  end
  if 100 == self._currentHpRate then
    hpValue = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYSETTING_ONLY_USE")
  end
  if self._currentMpRate >= 0 and self._currentMpRate <= 100 then
    mpValue = self._currentMpRate .. "%"
  end
  if 0 == self._currentMpRate then
    mpValue = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYSETTING_NO_USE")
  end
  if 100 == self._currentMpRate then
    mpValue = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYSETTING_ONLY_USE")
  end
  PaGlobal_FairyInfo_SetHpSlider(self._currentHpRate)
  PaGlobal_FairyInfo_SetMpSlider(self._currentMpRate)
  self._UI._btn_HpSlider:SetText(tostring(hpValue))
  self._UI._btn_MpSlider:SetText(tostring(mpValue))
  self._UI._hp_Value:SetText("")
  self._UI._mp_Value:SetText("")
end
function FairySetting_ReNew:Clear()
  self._currentHpKey = nil
  self._currentHpRate = nil
  self._currentMpKey = nil
  self._currentMpRate = nil
end
function FairySetting_ReNew:SetPos()
  Panel_Window_FairySetting:SetPosX(Panel_FairyInfo:GetPosX() + Panel_FairyInfo:GetSizeX() / 2 - Panel_Window_FairySetting:GetSizeX() / 2)
  Panel_Window_FairySetting:SetPosY(Panel_FairyInfo:GetPosY() + 20)
end
function PaGlobal_FairySetting_Request()
  local self = FairySetting_ReNew
  if nil == self._currentHpKey then
    self._currentHpKey = ItemEnchantKey(0, 0)
    self._cacheSetting._hpRate = 0
  end
  if nil == self._currentMpKey then
    self._currentMpKey = ItemEnchantKey(0, 0)
    self._cacheSetting._mpRate = 0
  end
  if nil == self._currentFairyNoStr then
    return
  end
  ToClient_setFairySettingData(tonumber64(self._currentFairyNoStr), self._currentHpKey, self._currentHpRate, self._currentMpKey, self._currentMpRate)
  PaGlobal_FairySetting_Close()
  PaGlobal_FairyInfo_Update()
end
function PaGlobal_FairySetting_Open(petNoStr)
  if not Panel_FairyInfo:GetShow() then
    return
  end
  if Panel_Window_FairyUpgrade:GetShow() then
    PaGlobal_FairyUpgrade_Close()
  end
  if Panel_Window_FairySetting:GetShow() then
    PaGlobal_FairySetting_Close()
    return
  end
  if nil == petNoStr then
    return
  end
  local self = FairySetting_ReNew
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local classType = selfPlayer:getClassType()
  self._currentClassType = 1
  for ii = 0, #spiritClass do
    if classType == spiritClass[ii] then
      self._currentClassType = 2
    end
  end
  if ClassType_Valkiry == classType then
    self._currentClassType = 3
  end
  self._currentFairyNoStr = petNoStr
  HandleClicked_Inventory_FairySetting_Open()
  Panel_Window_Inventory:SetShow(true)
  Inventory_SetFunctor(PaGlobal_Fairy_FileterForSetting, nil, PaGlobal_FairySetting_Close, nil)
  self:Clear()
  self:SetPos()
  audioPostEvent_SystemUi(1, 40)
  _AudioPostEvent_SystemUiForXBOX(1, 40)
  Panel_Window_FairySetting:SetShow(true)
  self:UpdateSetting(true)
end
function PaGlobal_Fairy_FileterForSetting(slotNo, notUse_itemWrappers, whereType)
  local self = FairySetting_ReNew
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  local itemKey = itemWrapper:get():getKey()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local classType = selfPlayer:getClassType()
  if true == ToClient_checkUsableFairyPotion(itemKey, classType) then
    return false
  end
  return true
end
function PaGlobal_FairySetting_Close()
  local self = FairySetting_ReNew
  self._currentFairyNoStr = nil
  Panel_Window_FairySetting:SetShow(false)
  HandleClicked_InventoryWindow_Close()
end
function PaGlobal_FairySetting_SetPortion(itemKey)
  local self = FairySetting_ReNew
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local classType = selfPlayer:getClassType()
  if -1 == ToClient_getFairyPotionType(itemKey, classType) then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYSETTING_NOT_ITEM"))
    return
  elseif 0 == ToClient_getFairyPotionType(itemKey, classType) then
    self._currentHpKey = itemKey
  else
    self._currentMpKey = itemKey
  end
  self:UpdateSetting(false)
end
function PaGlobal_FairyList_IsMp(mpKeyStr)
  local self = FairySetting_ReNew
  local key = tonumber(mpKeyStr)
  for idx, value in pairs(fairySubPotionData[self._currentClassType]) do
    if key == value then
      return true
    end
  end
  return false
end
function PaGlobal_FairyList_IsHp(hpKeyStr)
  local key = tonumber(hpKeyStr)
  for idx, value in pairs(fairyMainPotionData[0]) do
    if key == value then
      return true
    end
  end
  return false
end
function PaGlobal_FairySetting_ShowToolTip(isHp, isShow)
  local self = FairySetting_ReNew
  local itemSSW
  local index = 0
  local control
  if true == isHp then
    itemSSW = getItemEnchantStaticStatus(self._currentHpKey)
    index = 0
    control = self._UI._Static_HPItemSlotBig
  else
    itemSSW = getItemEnchantStaticStatus(self._currentMpKey)
    index = 1
    control = self._UI._Static_MPItemSlotBig
  end
  if nil == itemSSW then
    return
  end
  if true == isShow then
    Panel_Tooltip_Item_SetPosition(index, control, "fairySetting")
    Panel_Tooltip_Item_Show(itemSSW, Panel_Window_FairySetting, true)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function PaGlobal_FairyInfo_HpSlider()
  local self = FairySetting_ReNew
  local fValue = self._UI._btn_HpSlider:GetPosX() / (self._UI._hp_Slider:GetSizeX() - self._UI._btn_HpSlider:GetSizeX())
  local fValueTest = self._UI._hp_Slider:GetInterval()
  self._currentHpRate = math.ceil(fValue * 100)
  local hpValue = 0
  if self._currentHpRate >= 0 and self._currentHpRate <= 100 then
    hpValue = self._currentHpRate .. "%"
  end
  if 100 == self._currentHpRate then
    hpValue = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYSETTING_ONLY_USE")
  end
  if 0 == self._currentHpRate then
    hpValue = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYSETTING_NO_USE")
  end
  self._UI._hp_Value:SetText("")
  self._UI._btn_HpSlider:SetText(tostring(hpValue))
  self._UI._hp_Progress:SetProgressRate(self._currentHpRate)
end
function PaGlobal_FairyInfo_MpSlider()
  local self = FairySetting_ReNew
  local fValue = self._UI._btn_MpSlider:GetPosX() / (self._UI._mp_Slider:GetSizeX() - self._UI._btn_MpSlider:GetSizeX())
  self._currentMpRate = math.ceil(fValue * 100)
  local mpValue = 0
  if self._currentMpRate >= 0 and self._currentMpRate <= 100 then
    mpValue = self._currentMpRate .. "%"
  end
  if 100 == self._currentMpRate then
    mpValue = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYSETTING_ONLY_USE")
  end
  if 0 == self._currentMpRate then
    mpValue = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYSETTING_NO_USE")
  end
  self._UI._mp_Value:SetText("")
  self._UI._btn_MpSlider:SetText(tostring(mpValue))
  self._UI._mp_Progress:SetProgressRate(self._currentMpRate)
end
function PaGlobal_FairyInfo_SetHpSlider(fValue)
  local self = FairySetting_ReNew
  self._UI._hp_Slider:SetControlPos(fValue)
  self._UI._hp_Progress:SetProgressRate(fValue)
end
function PaGlobal_FairyInfo_SetMpSlider(fValue)
  local self = FairySetting_ReNew
  self._UI._mp_Slider:SetControlPos(fValue)
  self._UI._mp_Progress:SetProgressRate(fValue)
end
FairySetting_ReNew:Initialize()
