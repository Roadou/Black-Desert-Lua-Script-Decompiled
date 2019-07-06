local FairyMessageType = {eTurnOnLantern = 0, eTurnOffLantern = 1}
Panel_Window_FairyList:SetShow(false)
Panel_Window_FairyCompose:SetShow(false)
local UI_classType = CppEnums.ClassType
local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local isFairyOpen = true
local maxUnsealCount = 1
local nowFairyCompose = false
local composeFairyTier = 0
local ClassType_Valkiry = 24
local spiritClass = {
  [0] = 0,
  12,
  19,
  20,
  21,
  23,
  26,
  30
}
local fairyMainPotionData = {
  [0] = 502,
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
  19935
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
    810,
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
    19938
  },
  [2] = {
    [0] = 591,
    592,
    593,
    594,
    810,
    827,
    828,
    829,
    830,
    16334,
    17707,
    17708,
    17709,
    17710
  },
  [3] = {
    [0] = 595,
    596,
    597,
    598,
    810,
    831,
    832,
    833,
    834,
    17711,
    17712,
    17713,
    17714
  }
}
local Static_FairySetting_all = UI.getChildControl(Panel_Window_FairyList, "Static_FairyListWindow")
local FairyHpRateText = {
  [0] = "\236\178\180\235\160\165 \237\154\140\235\179\181\236\160\156\235\165\188 \235\147\177\235\161\157\237\149\180\236\163\188\236\132\184\236\154\148.",
  [10] = "\236\178\180\235\160\165 10% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169",
  [20] = "\236\178\180\235\160\165 20% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169",
  [30] = "\236\178\180\235\160\165 30% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169",
  [50] = "\236\178\180\235\160\165 50% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169"
}
local fairySubGageRateText = {
  [1] = {
    [0] = "\236\160\149\236\139\160\235\160\165 \237\154\140\235\179\181\236\160\156\235\165\188 \235\147\177\235\161\157\237\149\180\236\163\188\236\132\184\236\154\148.",
    [10] = "\236\160\149\236\139\160\235\160\165 10% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169",
    [20] = "\236\160\149\236\139\160\235\160\165 20% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169",
    [30] = "\236\160\149\236\139\160\235\160\165 30% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169",
    [50] = "\236\160\149\236\139\160\235\160\165 50% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169"
  },
  [2] = {
    [0] = "\237\136\172\236\167\128 \237\154\140\235\179\181\236\160\156\235\165\188 \235\147\177\235\161\157\237\149\180\236\163\188\236\132\184\236\154\148.",
    [10] = "\237\136\172\236\167\128 10% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169",
    [20] = "\237\136\172\236\167\128 20% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169",
    [30] = "\237\136\172\236\167\128 30% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169",
    [50] = "\237\136\172\236\167\128 50% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169"
  },
  [3] = {
    [0] = "\236\139\160\236\132\177\235\160\165 \237\154\140\235\179\181\236\160\156\235\165\188 \235\147\177\235\161\157\237\149\180\236\163\188\236\132\184\236\154\148.",
    [10] = "\236\139\160\236\132\177\235\160\165 10% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169",
    [20] = "\236\139\160\236\132\177\235\160\165 20% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169",
    [30] = "\236\139\160\236\132\177\235\160\165 30% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169",
    [50] = "\236\139\160\236\132\177\235\160\165 50% \236\157\180\237\149\152\236\157\188 \235\149\140 \236\158\144\235\143\153\236\130\172\236\154\169"
  }
}
local FairyList = {
  BTN_Close = UI.getChildControl(Panel_Window_FairyList, "Button_Win_Close"),
  BTN_Question = UI.getChildControl(Panel_Window_FairyList, "Button_Question"),
  List2_FairyList = UI.getChildControl(Panel_Window_FairyList, "List2_FairyList"),
  Static_FairySetting = UI.getChildControl(Panel_Window_FairyList, "Static_FairyListWindow"),
  Static_SkillList = UI.getChildControl(Static_FairySetting_all, "Static_SkillListBG2"),
  Radio_HpRate = {
    [0] = UI.getChildControl(Static_FairySetting_all, "Radiobutton_HP50Percent"),
    [10] = UI.getChildControl(Static_FairySetting_all, "Radiobutton_HP10Percent"),
    [20] = UI.getChildControl(Static_FairySetting_all, "Radiobutton_HP20Percent"),
    [30] = UI.getChildControl(Static_FairySetting_all, "Radiobutton_HP30Percent"),
    [50] = UI.getChildControl(Static_FairySetting_all, "Radiobutton_HP50Percent")
  },
  Radio_MpRate = {
    [0] = UI.getChildControl(Static_FairySetting_all, "Radiobutton_MP50Percent"),
    [10] = UI.getChildControl(Static_FairySetting_all, "Radiobutton_MP10Percent"),
    [20] = UI.getChildControl(Static_FairySetting_all, "Radiobutton_MP20Percent"),
    [30] = UI.getChildControl(Static_FairySetting_all, "Radiobutton_MP30Percent"),
    [50] = UI.getChildControl(Static_FairySetting_all, "Radiobutton_MP50Percent")
  },
  Slot_HpItem = UI.getChildControl(Static_FairySetting_all, "Static_HPItemSlotBig"),
  Slot_MpItem = UI.getChildControl(Static_FairySetting_all, "Static_MPItemSlotBig"),
  BTN_SettingYes = UI.getChildControl(Static_FairySetting_all, "Button_Yes"),
  BTN_SettingNo = UI.getChildControl(Static_FairySetting_all, "Button_No"),
  _currentPetNoStr = nil,
  _cacheSetting = {
    _hpKey = 0,
    _mpKey = 0,
    _hpRate = 0,
    _mpRate = 0
  },
  _isSubGageClassType = nil
}
FairyList.Static_SkillList:SetShow(true)
function FairyList:GetSubGageRateText(value)
  if nil == fairySubGageRateText[1][value] then
    value = 0
  end
  return fairySubGageRateText[self._isSubGageClassType][value]
end
function PaGlobal_FairySetting_IsOpen()
  return FairyList.Static_FairySetting:GetShow()
end
function FairyList:ClearCache()
  self._cacheSetting._hpKey = ItemEnchantKey(0, 0)
  self._cacheSetting._mpKey = ItemEnchantKey(0, 0)
  self._cacheSetting._hpRate = 50
  self._cacheSetting._mpRate = 50
end
function FairyList:SetPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_Window_FairyList:GetSizeX()
  local panelSizeY = Panel_Window_FairyList:GetSizeY()
  Panel_Window_FairyList:SetPosX(scrSizeX / 2)
  Panel_Window_FairyList:SetPosY(scrSizeY / 2 - panelSizeY / 2 - 100)
end
function FairyList:Open()
  if nil == self._isSubGageClassType then
    local selfPlayer = getSelfPlayer()
    local classType = selfPlayer:getClassType()
    self._isSubGageClassType = 1
    for ii = 0, #spiritClass do
      if classType == spiritClass[ii] then
        self._isSubGageClassType = 2
      end
    end
    if ClassType_Valkiry == classType then
      self._isSubGageClassType = 3
    end
  end
  self:SetPosition()
  Panel_Window_FairyList:SetShow(true, true)
  self.Static_FairySetting:SetShow(false, false)
  self:ClearCache()
  self:SetFairyList()
end
function FairyList:SetFairyList(noclearscroll)
  if not Panel_Window_FairyList:GetShow() then
    return
  end
  local toIndex = 0
  local scrollvalue = 0
  local vscroll = self.List2_FairyList:GetVScroll()
  local hscroll = self.List2_FairyList:GetHScroll()
  if noclearscroll then
    toIndex = self.List2_FairyList:getCurrenttoIndex()
    if false == self.List2_FairyList:IsIgnoreVerticalScroll() then
      scrollvalue = vscroll:GetControlPos()
    elseif false == self.List2_FairyList:IsIgnoreHorizontalScroll() then
      scrollvalue = hscroll:GetControlPos()
    end
  end
  self.List2_FairyList:getElementManager():clearKey()
  self.UnSealDATACount = ToClient_getFairyUnsealedList()
  self.SealDATACount = ToClient_getFairySealedList()
  local petCount = self.UnSealDATACount + self.SealDATACount
  for index = 0, petCount do
    local petNo
    if 0 == index and 0 == self.UnSealDATACount then
      petNo = toInt64(0, -1)
    elseif index < self.UnSealDATACount then
      local petData = ToClient_getFairyUnsealedDataByIndex(index)
      if nil ~= petData then
        petNo = petData:getPcPetNo()
      end
    else
      index = index - self.UnSealDATACount
      if 0 == self.UnSealDATACount then
        index = index - 1
      end
      local petData = ToClient_getFairySealedDataByIndex(index)
      if nil ~= petData then
        petNo = petData._petNo
      end
    end
    if nil ~= petNo then
      self.List2_FairyList:getElementManager():pushKey(petNo)
    end
  end
  if noclearscroll then
    self.List2_FairyList:setCurrenttoIndex(toIndex)
    if false == self.List2_FairyList:IsIgnoreVerticalScroll() then
      vscroll:SetControlPos(scrollvalue)
    elseif false == self.List2_FairyList:IsIgnoreHorizontalScroll() then
      hscroll:SetControlPos(scrollvalue)
    end
  end
end
function FairyList(control, key)
  local bg = UI.getChildControl(control, "Template_Static_ListContentBG")
  local iconBg = UI.getChildControl(control, "Template_Static_IconFairyBG")
  local icon = UI.getChildControl(control, "Template_Static_IconFairy")
  local name = UI.getChildControl(control, "Template_StaticText_FairyName")
  local btn_Setting = UI.getChildControl(control, "Template_Button_Setting")
  local btn_unSeal = UI.getChildControl(control, "Template_Button_Unseal")
  local btn_Seal = UI.getChildControl(control, "Template_Button_Seal")
  local slot_HpItem = UI.getChildControl(control, "Static_HPItemSlot")
  local slot_MpItem = UI.getChildControl(control, "Static_MPItemSlot")
  local text_HpItem = UI.getChildControl(control, "StaticText_HPItemSlotBG")
  local text_MpItem = UI.getChildControl(control, "StaticText_MPItemSlotBG")
  local noUnsealpet = UI.getChildControl(control, "StaticText_NoneUnsealFairy")
  local sealPetCount = ToClient_getFairySealedList()
  local unsealPetCount = ToClient_getFairyUnsealedList()
  local function isUnsealPet(petNo_s64)
    if unsealPetCount > 0 then
      for index = 0, unsealPetCount - 1 do
        local pcPetData = ToClient_getFairyUnsealedDataByIndex(index)
        if petNo_s64 == pcPetData:getPcPetNo() then
          return true
        end
      end
    end
    return false
  end
  local isShow
  if toInt64(0, -1) == key then
    isShow = false
  else
    isShow = true
  end
  iconBg:SetShow(isShow)
  icon:SetShow(isShow)
  name:SetShow(isShow)
  name:SetIgnore(false)
  btn_Setting:SetShow(isShow)
  btn_unSeal:SetShow(isShow)
  btn_Seal:SetShow(isShow)
  slot_HpItem:SetShow(isShow)
  slot_MpItem:SetShow(isShow)
  text_HpItem:SetShow(isShow)
  text_MpItem:SetShow(isShow)
  noUnsealpet:SetShow(not isShow)
  if not isShow then
    return
  end
  local petStaticStatus, iconPath, petNo_s64, petName, petLevel, petLovely, pethungry, petMaxLevel, petMaxHungry, petRace, petTier, petState, skillType, isPassive, tempIndex
  if isUnsealPet(key) then
    for index = 0, unsealPetCount - 1 do
      local pcPetData = ToClient_getFairyUnsealedDataByIndex(index)
      if nil ~= pcPetData and key == pcPetData:getPcPetNo() then
        petStaticStatus = pcPetData:getPetStaticStatus()
        iconPath = pcPetData:getIconPath()
        petNo_s64 = pcPetData:getPcPetNo()
        petName = pcPetData:getName()
        if nil ~= pcPetData:getSkillParam(1) then
          skillType = pcPetData:getSkillParam(1)._type
          isPassive = pcPetData:getSkillParam(1):isPassiveSkill()
        end
        name:SetTextMode(UI_TM.eTextMode_LimitText)
        name:SetText(petName)
        if name:IsLimitText() then
          name:addInputEvent("Mouse_On", "PetListNew_NameSimpleTooltip( true,\t" .. index .. ", " .. tostring(true) .. ", " .. tostring(key) .. ")")
          name:addInputEvent("Mouse_Out", "PetListNew_NameSimpleTooltip( false,\t" .. index .. ", " .. tostring(true) .. ", " .. tostring(key) .. ")")
        else
          name:addInputEvent("Mouse_On", "")
          name:addInputEvent("Mouse_Out", "")
        end
        btn_unSeal:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_UnSeal( \"" .. tostring(petNo_s64) .. "\")")
        btn_Seal:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_Seal( \"" .. tostring(petNo_s64) .. "\")")
        btn_Setting:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_Setting(\"" .. tostring(petNo_s64) .. "\")")
        local SettingData = ToClient_getFairySettingData(petNo_s64)
        if nil ~= SettingData then
          text_HpItem:SetText(FairyHpRateText[SettingData._hpMinRate])
          text_MpItem:SetText(FairyList:GetSubGageRateText(SettingData._mpMinRate))
          local ItemSSW = getItemEnchantStaticStatus(SettingData._hpItemKey)
          if nil ~= ItemSSW then
            slot_HpItem:ChangeTextureInfoName("Icon/" .. ItemSSW:getIconPath())
            slot_HpItem:setRenderTexture(slot_HpItem:getBaseTexture())
            slot_HpItem:SetShow(true)
          else
            slot_HpItem:SetShow(false)
          end
          ItemSSW = getItemEnchantStaticStatus(SettingData._mpItemKey)
          if nil ~= ItemSSW then
            slot_MpItem:ChangeTextureInfoName("Icon/" .. ItemSSW:getIconPath())
            slot_MpItem:setRenderTexture(slot_MpItem:getBaseTexture())
            slot_MpItem:SetShow(true)
          else
            slot_MpItem:SetShow(false)
          end
        else
          text_HpItem:SetText(FairyHpRateText[50])
          text_MpItem:SetText(FairyList:GetSubGageRateText(50))
          slot_MpItem:SetShow(false)
          slot_HpItem:SetShow(false)
        end
        btn_unSeal:SetShow(false)
        btn_Seal:SetShow(true)
      end
    end
    local uiIndex = 0
  else
    local unsealPetIndex = -1
    for index = 0, sealPetCount - 1 do
      local pcPetData = ToClient_getFairySealedDataByIndex(index)
      if nil ~= pcPetData and key == pcPetData._petNo then
        petStaticStatus = pcPetData:getPetStaticStatus()
        iconPath = pcPetData:getIconPath()
        petNo_s64 = pcPetData._petNo
        petName = pcPetData:getName()
        petRace = petStaticStatus:getPetRace()
        if nil ~= pcPetData:getSkillParam(1) then
          skillType = pcPetData:getSkillParam(1)._type
          isPassive = pcPetData:getSkillParam(1):isPassiveSkill()
        end
        name:SetTextMode(UI_TM.eTextMode_LimitText)
        name:SetText(petName)
        if name:IsLimitText() then
          name:addInputEvent("Mouse_On", "PetListNew_NameSimpleTooltip( true,\t" .. index .. ", " .. tostring(false) .. ", " .. tostring(key) .. ")")
          name:addInputEvent("Mouse_Out", "PetListNew_NameSimpleTooltip( false,\t" .. index .. ", " .. tostring(false) .. ", " .. tostring(key) .. ")")
        else
          name:addInputEvent("Mouse_On", "")
          name:addInputEvent("Mouse_Out", "")
        end
        unsealPetIndex = index
        btn_unSeal:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_UnSeal( \"" .. tostring(petNo_s64) .. "\")")
        btn_Seal:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_Seal( \"" .. tostring(petNo_s64) .. "\")")
        btn_Setting:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_Setting(\"" .. tostring(petNo_s64) .. "\")")
        local SettingData = ToClient_getFairySettingData(petNo_s64)
        if nil ~= SettingData then
          text_HpItem:SetText(FairyHpRateText[SettingData._hpMinRate])
          text_MpItem:SetText(FairyList:GetSubGageRateText(SettingData._mpMinRate))
          local ItemSSW = getItemEnchantStaticStatus(SettingData._hpItemKey)
          if nil ~= ItemSSW then
            slot_HpItem:ChangeTextureInfoName("Icon/" .. ItemSSW:getIconPath())
            slot_HpItem:setRenderTexture(slot_HpItem:getBaseTexture())
            slot_HpItem:SetShow(true)
          else
            slot_HpItem:SetShow(false)
          end
          ItemSSW = getItemEnchantStaticStatus(SettingData._mpItemKey)
          if nil ~= ItemSSW then
            slot_MpItem:ChangeTextureInfoName("Icon/" .. ItemSSW:getIconPath())
            slot_MpItem:setRenderTexture(slot_MpItem:getBaseTexture())
            slot_MpItem:SetShow(true)
          else
            slot_MpItem:SetShow(false)
          end
        else
          text_HpItem:SetText(FairyHpRateText[50])
          text_MpItem:SetText(FairyList:GetSubGageRateText(50))
          slot_MpItem:SetShow(false)
          slot_HpItem:SetShow(false)
        end
        btn_unSeal:SetShow(true)
        btn_Seal:SetShow(false)
        btn_unSeal:addInputEvent("Mouse_RUp", "PaGlobal_FairyComposeSetting(\"" .. tostring(petNo_s64) .. "," .. petRace .. "," .. unsealPetIndex .. "\")")
      end
    end
  end
  icon:ChangeTextureInfoName(iconPath)
end
function PaGlobal_FairyList_Question()
  _PA_LOG("\236\167\128\235\175\188\237\152\129", "\236\154\148\236\160\149 \235\143\132\236\155\128\235\167\144\236\160\149\235\179\180\235\165\188 \236\154\148\236\178\173\237\149\169\235\139\136\235\139\164. \237\149\168\236\136\152 \235\130\180\235\182\128\234\181\172\237\152\132\237\149\180\236\163\188\236\132\184\236\154\148...")
end
function PaGlobal_FairyList_Close()
  Panel_Window_FairyList:SetShow(false, false)
  Static_FairySetting_all:SetShow(false, false)
end
function PaGlobal_FairyList_UnSeal(petNoStr)
  audioPostEvent_SystemUi(1, 40)
  local self = FairyList
  local petNo_s64 = tonumber64(petNoStr)
  if 0 ~= self.UnSealDATACount then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_UNABLE_SUMMON_PET"))
    return
  end
  ToClient_requestPetUnseal(petNo_s64)
end
function PaGlobal_FairyList_Seal(petNoStr)
  audioPostEvent_SystemUi(1, 40)
  local self = FairyList
  local petNo_s64 = tonumber64(petNoStr)
  ToClient_requestPetSeal(petNo_s64)
end
function PaGlobal_FairyList_Setting(petNoStr)
  audioPostEvent_SystemUi(1, 40)
  local self = FairyList
  if true == self.Static_FairySetting:GetShow() then
    PaGlobal_FairyList_SetNo()
    return
  end
  self._currentPetNoStr = petNoStr
  self.Static_FairySetting:SetShow(true, true)
  self:Update_Setting(petNoStr, true)
end
function PaGlobal_FairySettingList_GetShow()
  local self = FairyList
  return self.Static_FairySetting:GetShow()
end
function PaGlobal_FairyList_SetYes()
  local self = FairyList
  if ItemEnchantKey(0, 0) == self._cacheSetting._hpKey then
    self._cacheSetting._hpRate = 0
  end
  if ItemEnchantKey(0, 0) == self._cacheSetting._mpKey then
    self._cacheSetting._mpRate = 0
  end
  ToClient_setFairySettingData(tonumber64(self._currentPetNoStr), self._cacheSetting._hpKey, self._cacheSetting._hpRate, self._cacheSetting._mpKey, self._cacheSetting._mpRate)
  self.Static_FairySetting:SetShow(false, false)
  self:SetFairyList()
end
function PaGlobal_FairyList_SetNo()
  local self = FairyList
  self._currentPetNoStr = nil
  self:ClearCache()
  self.Static_FairySetting:SetShow(false, false)
end
function FairyList:Update_Setting(petNoStr, notDataUpdate)
  local petNo_s64 = tonumber64(petNoStr)
  local settingData = ToClient_getFairySettingData(petNo_s64)
  if notDataUpdate then
    if nil == settingData then
      self:ClearCache()
    else
      self._cacheSetting._hpKey = settingData._hpItemKey
      self._cacheSetting._mpKey = settingData._mpItemKey
      self._cacheSetting._hpRate = settingData._hpMinRate
      self._cacheSetting._mpRate = settingData._mpMinRate
      if self._cacheSetting._hpRate <= 0 then
        self._cacheSetting._hpRate = 50
      end
      if self._cacheSetting._mpRate <= 0 then
        self._cacheSetting._mpRate = 50
      end
    end
  end
  for key, value in pairs(self.Radio_HpRate) do
    value:SetCheck(false)
  end
  for key, value in pairs(self.Radio_MpRate) do
    value:SetCheck(false)
  end
  self.Radio_HpRate[self._cacheSetting._hpRate]:SetCheck(true)
  self.Radio_MpRate[self._cacheSetting._mpRate]:SetCheck(true)
  local ItemHpSSW, ItemMpSSW
  if 0 ~= self._cacheSetting._hpKey then
    ItemHpSSW = getItemEnchantStaticStatus(self._cacheSetting._hpKey)
  end
  if nil ~= ItemHpSSW then
    self.Slot_HpItem:ChangeTextureInfoName("Icon/" .. ItemHpSSW:getIconPath())
    self.Slot_HpItem:setRenderTexture(self.Slot_HpItem:getBaseTexture())
    self.Slot_HpItem:SetShow(true)
  else
    self.Slot_HpItem:SetShow(false)
  end
  if 0 ~= self._cacheSetting._mpKey then
    ItemMpSSW = getItemEnchantStaticStatus(self._cacheSetting._mpKey)
  end
  if nil ~= ItemMpSSW then
    self.Slot_MpItem:ChangeTextureInfoName("Icon/" .. ItemMpSSW:getIconPath())
    self.Slot_MpItem:setRenderTexture(self.Slot_MpItem:getBaseTexture())
    self.Slot_MpItem:SetShow(true)
  else
    self.Slot_MpItem:SetShow(false)
  end
end
function PaGlobal_FairyList_HpRateCheck(rate)
  local self = FairyList
  self._cacheSetting._hpRate = tonumber(rate)
end
function PaGlobal_FairyList_MpRateCheck(mpCheck)
  local self = FairyList
  self._cacheSetting._mpRate = tonumber(mpCheck)
end
function PaGlobal_FairyList_IsHp(hpKeyStr)
  local key = tonumber(hpKeyStr)
  for idx, value in pairs(fairyMainPotionData) do
    if key == value then
      return true
    end
  end
  return false
end
function PaGlobal_FairyList_IsMp(mpKeyStr)
  local key = tonumber(mpKeyStr)
  for idx, value in pairs(fairySubPotionData[FairyList._isSubGageClassType]) do
    if key == value then
      return true
    end
  end
  return false
end
function FromClient_FairyUpdate()
  FairyList:SetFairyList()
end
function PaGlobal_FairySetting_HpReset()
  local self = FairyList
  self._cacheSetting._hpKey = ItemEnchantKey(0, 0)
  Panel_Tooltip_Item_hideTooltip()
  self:Update_Setting(self._currentPetNoStr, false)
end
function PaGlobal_FairySetting_MpReset()
  local self = FairyList
  self._cacheSetting._mpKey = ItemEnchantKey(0, 0)
  Panel_Tooltip_Item_hideTooltip()
  self:Update_Setting(self._currentPetNoStr, false)
end
function FromClient_ShowFairyMessageByType(msgType)
  if false == ToClient_IsDevelopment() then
    return
  end
  if FairyMessageType.eTurnOnLantern == msgType then
    Proc_ShowMessage_Ack("\236\154\148\236\160\149\236\157\180 \236\163\188\235\179\128\236\157\132 \235\176\157\237\152\128\236\164\141\235\139\136\235\139\164.")
  elseif FairyMessageType.eTurnOffLantern == msgType then
    Proc_ShowMessage_Ack("\236\154\148\236\160\149\236\157\152 \235\176\157\236\157\128 \235\185\155\236\157\180 \236\130\172\235\157\188\236\167\145\235\139\136\235\139\164.")
  else
    _PA_LOG("\236\167\128\235\175\188\237\152\129", "\236\160\149\236\157\152\235\144\152\236\167\128 \236\149\138\236\157\128 \234\176\146\236\157\180 \235\147\164\236\150\180\236\153\148\236\138\181\235\139\136\235\139\164. msgType = " .. tostring(msgType) .. " , GameEnginePetManager.h \236\151\144 enum \234\176\146 \237\153\149\236\157\184\237\149\180\236\163\188\236\132\184\236\154\148.")
  end
end
function FairyList:Initialize()
  self.List2_FairyList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FairyListCreate")
  self.List2_FairyList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self.BTN_Close:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_Close()")
  self.BTN_Question:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_Question()")
  self.Static_FairySetting:SetShow(false, false)
  self.BTN_SettingYes:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_SetYes()")
  self.BTN_SettingNo:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_SetNo()")
  registerEvent("FromClient_PetAddSealedList", "FromClient_FairyUpdate")
  registerEvent("FromClient_PetDelSealedList", "FromClient_FairyUpdate")
  registerEvent("FromClient_PetDelList", "FromClient_FairyUpdate")
  registerEvent("FromClient_InputPetName", "FromClient_FairyUpdate")
  registerEvent("FromClient_PetInfoChanged", "FromClient_FairyUpdate")
  registerEvent("FromClient_ShowFairyMessageByType", "FromClient_ShowFairyMessageByType")
  self.Radio_HpRate[10]:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_HpRateCheck(10)")
  self.Radio_HpRate[20]:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_HpRateCheck(20)")
  self.Radio_HpRate[30]:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_HpRateCheck(30)")
  self.Radio_HpRate[50]:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_HpRateCheck(50)")
  self.Radio_MpRate[10]:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_MpRateCheck(10)")
  self.Radio_MpRate[20]:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_MpRateCheck(20)")
  self.Radio_MpRate[30]:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_MpRateCheck(30)")
  self.Radio_MpRate[50]:addInputEvent("Mouse_LUp", "PaGlobal_FairyList_MpRateCheck(50)")
  self.Slot_HpItem:addInputEvent("Mouse_RUp", "PaGlobal_FairySetting_HpReset()")
  self.Slot_MpItem:addInputEvent("Mouse_RUp", "PaGlobal_FairySetting_MpReset()")
  self.Slot_HpItem:addInputEvent("Mouse_On", "HandleClicked_OnOut_ShowHpEquipItemToolTip(true)")
  self.Slot_HpItem:addInputEvent("Mouse_Out", "HandleClicked_OnOut_ShowHpEquipItemToolTip(false)")
  self.Slot_MpItem:addInputEvent("Mouse_On", "HandleClicked_OnOut_ShowMpEquipItemToolTip(true)")
  self.Slot_MpItem:addInputEvent("Mouse_Out", "HandleClicked_OnOut_ShowMpEquipItemToolTip(false)")
end
function HandleClicked_OnOut_ShowHpEquipItemToolTip(isShow)
  local self = FairyList
  local selfPlayer = getSelfPlayer():get()
  local inventory = selfPlayer:getInventoryByType(CppEnums.ItemWhereType.eInventory)
  local slotNo = inventory:getSlot(self._cacheSetting._hpKey)
  if true == isShow then
    local itemWrapper = getInventoryItem(slotNo)
    if nil == itemWrapper then
      return
    end
    local SlotIcon = self.Slot_HpItem
    Panel_Tooltip_Item_Show(itemWrapper, SlotIcon, false, true)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function HandleClicked_OnOut_ShowMpEquipItemToolTip(isShow)
  local self = FairyList
  local selfPlayer = getSelfPlayer():get()
  local inventory = selfPlayer:getInventoryByType(CppEnums.ItemWhereType.eInventory)
  local slotNo = inventory:getSlot(self._cacheSetting._mpKey)
  if true == isShow then
    local itemWrapper = getInventoryItem(slotNo)
    if nil == itemWrapper then
      return
    end
    local SlotIcon = self.Slot_HpItem
    Panel_Tooltip_Item_Show(itemWrapper, SlotIcon, false, true)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
local FairyCompose = {
  _button_Compose = UI.getChildControl(Panel_Window_FairyList, "Button_Compose"),
  icon_1 = UI.getChildControl(Panel_Window_FairyCompose, "Static_Icon_1"),
  icon_2 = UI.getChildControl(Panel_Window_FairyCompose, "Static_Icon_2"),
  icon_3 = UI.getChildControl(Panel_Window_FairyCompose, "Static_Icon_3"),
  icon_question = UI.getChildControl(Panel_Window_FairyCompose, "StaticText_QuestionMark"),
  editName = UI.getChildControl(Panel_Window_FairyCompose, "Edit_Naming"),
  desc = UI.getChildControl(Panel_Window_FairyCompose, "StaticText_Desc"),
  descBg = UI.getChildControl(Panel_Window_FairyCompose, "Static_DescBg"),
  btn_Yes = UI.getChildControl(Panel_Window_FairyCompose, "Button_Yes"),
  btn_No = UI.getChildControl(Panel_Window_FairyCompose, "Button_No"),
  btn_Question = UI.getChildControl(Panel_Window_FairyCompose, "Button_Question"),
  radioBtn_PetSkill_1 = UI.getChildControl(Panel_Window_FairyCompose, "RadioButton_Skill_1"),
  radioBtn_PetSkill_2 = UI.getChildControl(Panel_Window_FairyCompose, "RadioButton_Skill_2"),
  radioBtn_PetSkill_3 = UI.getChildControl(Panel_Window_FairyCompose, "RadioButton_Skill_3"),
  radioBtn_PetLook_1 = UI.getChildControl(Panel_Window_FairyCompose, "RadioButton_Look_1"),
  radioBtn_PetLook_2 = UI.getChildControl(Panel_Window_FairyCompose, "RadioButton_Look_2"),
  radioBtn_PetLook_3 = UI.getChildControl(Panel_Window_FairyCompose, "RadioButton_Look_3"),
  skillSlotBg = {
    [1] = {
      [1] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillSlotBg_1_1"),
      [2] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillSlotBg_1_2"),
      [3] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillSlotBg_1_3")
    },
    [2] = {
      [1] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillSlotBg_2_1"),
      [2] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillSlotBg_2_2"),
      [3] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillSlotBg_2_3")
    },
    [3] = {
      [1] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillSlotBg_3_1"),
      [2] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillSlotBg_3_2"),
      [3] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillSlotBg_3_3")
    }
  },
  skillSlot = {
    [1] = {
      [1] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillPetSlot_1_1"),
      [2] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillPetSlot_1_2"),
      [3] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillPetSlot_1_3")
    },
    [2] = {
      [1] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillPetSlot_2_1"),
      [2] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillPetSlot_2_2"),
      [3] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillPetSlot_2_3")
    },
    [3] = {
      [1] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillPetSlot_3_1"),
      [2] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillPetSlot_3_2"),
      [3] = UI.getChildControl(Panel_Window_FairyCompose, "Static_SkillPetSlot_3_3")
    }
  },
  skillNoList = {
    [0] = nil,
    nil,
    nil,
    nil,
    nil,
    nil
  },
  preserveSkillNo = nil,
  FairyComposeNo = {
    [0] = nil,
    [1] = nil
  },
  race = nil
}
function FairyCompose:Initialize()
  self._button_Compose:addInputEvent("Mouse_LUp", "PaGlobal_FairyComposeOpen()")
  self.btn_Yes:addInputEvent("Mouse_LUp", "Confirm_FairyCompose()")
  self.btn_No:addInputEvent("Mouse_LUp", "PaGlobal_FairyComposeClose()")
  self.editName:addInputEvent("Mouse_LUp", "HandleClicked_FairyCompose_ClearEdit()")
  self.radioBtn_PetSkill_1:addInputEvent("Mouse_LUp", "FairyCompose_UpdateFairySkillList()")
  self.radioBtn_PetSkill_2:addInputEvent("Mouse_LUp", "FairyCompose_UpdateFairySkillList()")
  self.radioBtn_PetSkill_3:addInputEvent("Mouse_LUp", "FairyCompose_UpdateFairySkillList()")
  self.radioBtn_PetLook_1:addInputEvent("Mouse_LUp", "FairyCompose_UpdateFairySkillList()")
  self.radioBtn_PetLook_2:addInputEvent("Mouse_LUp", "FairyCompose_UpdateFairySkillList()")
  self.radioBtn_PetLook_3:addInputEvent("Mouse_LUp", "FairyCompose_UpdateFairySkillList()")
end
function FairyCompose_Init()
  FairyCompose.FairyComposeNo[0] = nil
  FairyCompose.FairyComposeNo[1] = nil
  FairyCompose._race = nil
  FairyCompose.icon_1:ChangeTextureInfoName("")
  FairyCompose.icon_2:ChangeTextureInfoName("")
  FairyCompose.icon_3:ChangeTextureInfoName("")
  FairyCompose.icon_1:SetShow(false)
  FairyCompose.icon_2:SetShow(false)
  FairyCompose.icon_3:SetShow(false)
  composableCheck = false
  FairyCompose.preserveSkillNo = nil
  ClearFocusEdit(FairyCompose.editName)
  FairyCompose.radioBtn_PetSkill_1:SetCheck(false)
  FairyCompose.radioBtn_PetSkill_2:SetCheck(false)
  FairyCompose.radioBtn_PetSkill_3:SetCheck(true)
  FairyCompose.radioBtn_PetLook_1:SetCheck(false)
  FairyCompose.radioBtn_PetLook_2:SetCheck(false)
  FairyCompose.radioBtn_PetLook_3:SetCheck(true)
  FairyCompose.radioBtn_PetLook_2:SetShow(true)
  FairyCompose.radioBtn_PetSkill_2:SetShow(true)
  for index = 1, 3 do
    FairyCompose.skillSlotBg[index][1]:SetShow(true)
    FairyCompose.skillSlotBg[index][2]:SetShow(true)
    FairyCompose.skillSlotBg[index][3]:SetShow(true)
    FairyCompose.skillSlot[index][1]:SetShow(false)
    FairyCompose.skillSlot[index][2]:SetShow(false)
    FairyCompose.skillSlot[index][3]:SetShow(false)
  end
  FairyCompose_UpdateFairySkillList()
end
local petComposeString = PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_NAME")
local petComposeDesc = PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_DESC")
function FairyCompose:Open()
  nowFairyCompose = true
  Panel_Window_FairyCompose:SetShow(true)
  Panel_Window_FairyCompose:SetPosX(Panel_Window_FairyList:GetPosX() + Panel_Window_FairyList:GetSizeX() + 10)
  Panel_Window_FairyCompose:SetPosY(Panel_Window_FairyList:GetPosY())
  FairyCompose_Init()
  FairyCompose.editName:SetEditText(petComposeString)
  composeFairyTier = 0
end
function FairyCompose:Clear()
end
function FairyCompose:Close()
  nowFairyCompose = false
  Panel_Window_FairyCompose:SetShow(false)
end
function FairyList_Compose()
end
function PaGlobal_FairyComposeOpen()
  FairyCompose:Open()
end
function PaGlobal_FairyComposeClose()
  FairyCompose:Close()
end
function testFairy1()
  PaGlobal_FairyComposeSetting("2404", 1, 1)
end
function testFairy2()
  PaGlobal_FairyComposeSetting("2405", 1, 1)
end
function testFairy3()
  PaGlobal_FairyComposeSetting("2422", 1, 3)
end
function PaGlobal_FairyComposeSetting(fairyNoStr, fairyRace, sealFairyIndex)
  local self = FairyCompose
  if nil == self.FairyComposeNo[0] then
    self.FairyComposeNo[0] = tonumber64(fairyNoStr)
    PaGlobal_FairyImgChange(self.FairyComposeNo[0], 0)
    FairyCompose._curRace = fairyRace
    FairyCompose_UpdateFairySkillList()
    composePetTier = composeFairyNo(self.FairyComposeNo[0])
    FairyCompose_SkillSet(sealFairyIndex, 1)
  elseif nil == self.FairyComposeNo[1] then
    self.FairyComposeNo[1] = tonumber64(fairyNoStr)
    PaGlobal_FairyImgChange(self.FairyComposeNo[1], 1)
    FairyCompose_UpdateFairySkillList()
    FairyCompose_SkillSet(sealFairyIndex, 2)
  end
  FairyList:SetFairyList(true)
end
function composeFairyNo(fairyNo)
  for sealFairyIndex = 0, ToClient_getFairySealedList() - 1 do
    local fairyData = ToClient_getFairySealedDataByIndex(sealFairyIndex)
    local _fairyNo = fairyData._petNo
    if fairyNo == _fairyNo then
      local fairySS = fairyData:getPetStaticStatus()
      local fairyTier = fairySS:getPetTier() + 1
      return fairyTier
    end
  end
end
function PaGlobal_FairyImgChange(fairyNo, index)
  for sealFairyIndex = 0, ToClient_getFairySealedList() - 1 do
    local fairyData = ToClient_getPetSealedDataByIndex(sealFairyIndex)
    local _fairyNo = fairyData._petNo
    if fairyNo == _fairyNo then
      local petSS = fairyData:getPetStaticStatus()
      local iconPath = fairyData:getIconPath()
      if 0 == index then
        FairyCompose.icon_1:ChangeTextureInfoName(iconPath)
        FairyCompose.icon_1:SetShow(true)
      elseif 1 == index then
        FairyCompose.icon_2:ChangeTextureInfoName(iconPath)
        FairyCompose.icon_2:SetShow(true)
      end
    end
  end
end
function FairyCompose_SkillSet(fairyIndex, uiIndex)
  local self = FairyCompose
  local fairyData = ToClient_getFairySealedDataByIndex(fairyIndex)
  if nil == fairyData then
    return
  end
  local skillMaxCount = ToClient_getPetEquipSkillMax()
  FairyCompose.skillNoList[0] = nil
  skillLearnCount = 0
  petSkillCheck = {}
  for skill_idx = 0, skillMaxCount - 1 do
    local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
    local isLearn = fairyData:isPetEquipSkillLearned(skill_idx)
    if true == isLearn and nil ~= skillStaticStatus and true ~= petSkillCheck[skill_idx] then
      skillLearnCount = skillLearnCount + 1
      petSkillCheck[skill_idx] = true
      local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
      if nil ~= skillTypeStaticWrapper and skillLearnCount <= #FairyCompose.skillSlot then
        local skillNo = skillStaticStatus:getSkillNo()
        FairyCompose.skillNoList[skillLearnCount] = skill_idx
        FairyCompose.skillSlot[uiIndex][skillLearnCount]:SetShow(true)
        FairyCompose.skillSlot[uiIndex][skillLearnCount]:SetIgnore(false)
        FairyCompose.skillSlot[uiIndex][skillLearnCount]:ChangeTextureInfoName("Icon/" .. skillTypeStaticWrapper:getIconPath())
        Panel_SkillTooltip_SetPosition(skillNo, FairyCompose.skillSlot[uiIndex][skillLearnCount], "FairySkill")
      end
    end
  end
  if 2 == uiIndex and 99 == fairyData:getPetStaticStatus():getPetRace() then
    FairyCompose.radioBtn_PetLook_2:SetShow(false)
    FairyCompose.radioBtn_PetSkill_2:SetShow(false)
  else
    FairyCompose.radioBtn_PetLook_2:SetShow(true)
    FairyCompose.radioBtn_PetSkill_2:SetShow(true)
  end
end
function FairyComposeSkill_Init()
  for ii, aSkillSlot in pairs(FairyCompose.skillSlot[3]) do
    aSkillSlot:SetShow(false)
    aSkillSlot:addInputEvent("Mouse_On", "")
    aSkillSlot:addInputEvent("Mouse_Out", "")
  end
end
local fairySkillCheck
function FairyCompose_UpdateFairySkillList()
  local fairyNo0 = FairyCompose.FairyComposeNo[0]
  local fairyNo1 = FairyCompose.FairyComposeNo[1]
  FairyComposeSkill_Init()
  FairyCompose.skillNoList[0] = nil
  fairySkillCheck = {}
  local function havePetSkillCheck(fairyNo)
    if fairyNo ~= nil then
      local skillLearnCount = 0
      local skillMaxCount = ToClient_getPetEquipSkillMax()
      for sealFairyIndex = 0, ToClient_getFairySealedList() - 1 do
        local fairyData = ToClient_getFairySealedDataByIndex(sealFairyIndex)
        local _fairyNo = fairyData._petNo
        if _fairyNo ~= nil and fairyNo == _fairyNo then
          for skill_idx = 0, skillMaxCount - 1 do
            local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
            local isLearn = fairyData:isPetEquipSkillLearned(skill_idx)
            if true == isLearn and nil ~= skillStaticStatus and true ~= fairySkillCheck[skill_idx] then
              skillLearnCount = skillLearnCount + 1
              fairySkillCheck[skill_idx] = true
              local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
              if nil ~= skillTypeStaticWrapper and skillLearnCount <= #FairyCompose.skillSlot then
                local skillNo = skillStaticStatus:getSkillNo()
                FairyCompose.skillNoList[skillLearnCount] = skill_idx
                FairyCompose.skillSlot[3][skillLearnCount]:SetShow(true)
                FairyCompose.skillSlot[3][skillLearnCount]:SetIgnore(false)
                FairyCompose.skillSlot[3][skillLearnCount]:ChangeTextureInfoName("Icon/" .. skillTypeStaticWrapper:getIconPath())
              end
            end
          end
        end
      end
    end
  end
  if FairyCompose.radioBtn_PetSkill_1:IsCheck() and nil ~= fairyNo0 then
    havePetSkillCheck(fairyNo0)
  elseif FairyCompose.radioBtn_PetSkill_2:IsCheck() and nil ~= fairyNo1 then
    havePetSkillCheck(fairyNo1)
  end
  local function fairyIconChange(fairyNo)
    for sealPetIndex = 0, ToClient_getFairySealedList() - 1 do
      local fairyData = ToClient_getFairySealedDataByIndex(sealPetIndex)
      local _fairyNo = fairyData._petNo
      if _fairyNo == fairyNo then
        local iconPath = fairyData:getIconPath()
        FairyCompose.icon_3:ChangeTextureInfoName(iconPath)
        FairyCompose.icon_3:SetShow(true)
      end
    end
  end
  FairyCompose.icon_question:SetShow(false)
  if FairyCompose.radioBtn_PetLook_1:IsCheck() and nil ~= fairyNo0 then
    fairyIconChange(fairyNo0)
  elseif FairyCompose.radioBtn_PetLook_2:IsCheck() and nil ~= fairyNo1 then
    fairyIconChange(fairyNo1)
  else
    FairyCompose.icon_3:SetShow(false)
    FairyCompose.icon_question:SetShow(true)
  end
end
function HandleClicked_FairyCompose_ClearEdit()
  FairyCompose.editName:SetMaxInput(getGameServiceTypePetNameLength())
  SetFocusEdit(FairyCompose.editName)
  FairyCompose.editName:SetEditText("", true)
end
function Confirm_FairyCompose()
  ClearFocusEdit(FairyCompose.editName)
  local fairyName = FairyCompose.editName:GetEditText()
  if "" == fairyName or petComposeString == fairyName then
    Proc_ShowMessage_Ack(petComposeString)
    return
  end
  if nil ~= FairyCompose.FairyComposeNo[1] then
    local function confirm_compose()
      if FairyCompose.preserveSkillNo == nil then
        FairyCompose.preserveSkillNo = ToClient_getPetEquipSkillMax()
      end
      local isInherit = 0
      local isLookChange = 0
      local fairyNo_1 = FairyCompose.FairyComposeNo[0]
      local fairyNo_2 = FairyCompose.FairyComposeNo[1]
      if FairyCompose.radioBtn_PetSkill_1:IsCheck() then
        isInherit = 2
      elseif FairyCompose.radioBtn_PetSkill_2:IsCheck() then
        isInherit = 1
      end
      if FairyCompose.radioBtn_PetLook_1:IsCheck() then
        isLookChange = 2
      elseif FairyCompose.radioBtn_PetLook_2:IsCheck() then
        isLookChange = 1
      end
      ToClient_requestPetFusion(fairyName, fairyNo_1, fairyNo_2, isInherit, isLookChange)
      PaGlobal_FairyComposeClose()
    end
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_MSGCONTENT")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "PANEL_SERVANTMIX_TITLE"),
      content = messageBoxMemo,
      functionYes = confirm_compose,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_REGIST"))
    return
  end
end
FairyList:Initialize()
FairyCompose:Initialize()
function PaGlobal_FairyList_Open()
  FairyList:Open()
end
function OpenFairyList()
  if false == isFairyOpen then
    return
  end
  FairyList:Open()
end
function TestLua()
  if false == ToClient_IsDevelopment() then
    return
  end
  ToClient_SettingSiegeCamera()
end
