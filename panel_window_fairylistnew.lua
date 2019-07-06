Panel_Window_FairyListNew:SetShow(false)
local FairyMessageType = {eTurnOnLantern = 0, eTurnOffLantern = 1}
local UI_classType = CppEnums.ClassType
local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local maxUnsealCount = 1
local FairyListNew = {
  _list2_FairyListNew = UI.getChildControl(Panel_Window_FairyListNew, "List2_FairyList"),
  _unSealDATACount = 0,
  _sealDATACount = 0,
  _isUpgradeState = false,
  _UI = {
    _Button_Upgrade = UI.getChildControl(Panel_Window_FairyListNew, "Button_Upgrade"),
    _Button_Close = UI.getChildControl(Panel_Window_FairyListNew, "Button_Win_Close"),
    _Static_FeedinfBg = UI.getChildControl(Panel_Window_FairyListNew, "Static_FeedingBg")
  }
}
function PaGlobal_FairyListNew_UnSeal(petNoStr)
  audioPostEvent_SystemUi(1, 40)
  local self = FairyListNew
  local petNo_s64 = tonumber64(petNoStr)
  if 0 ~= self._unSealDATACount then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_UNABLE_SUMMON_PET"))
    return
  end
  ToClient_requestPetUnseal(petNo_s64)
end
function PaGlobal_FairyListNew_Seal(petNoStr)
  audioPostEvent_SystemUi(1, 40)
  local petNo_s64 = tonumber64(petNoStr)
  ToClient_requestPetSeal(petNo_s64)
end
function PaGlobal_FairyListNew_Setting(petNoStr, tier)
  PaGlobal_FairySetting_Open(petNoStr, tier)
end
function PaGlobal_FairyUpgrade_Open_Call()
  PaGlobal_FairyUpgrade_Open()
  FairyListNew:UpdateList(true)
end
function FairyListNew:UpdateList(noclearscroll)
  local toIndex = 0
  local scrollvalue = 0
  local vscroll = self._list2_FairyListNew:GetVScroll()
  local hscroll = self._list2_FairyListNew:GetHScroll()
  if noclearscroll then
    toIndex = self._list2_FairyListNew:getCurrenttoIndex()
    if false == self._list2_FairyListNew:IsIgnoreVerticalScroll() then
      scrollvalue = vscroll:GetControlPos()
    elseif false == self._list2_FairyListNew:IsIgnoreHorizontalScroll() then
      scrollvalue = hscroll:GetControlPos()
    end
  end
  self._list2_FairyListNew:getElementManager():clearKey()
  self._unSealDATACount = ToClient_getFairyUnsealedList()
  self._sealDATACount = ToClient_getFairySealedList()
  local fairyCount = self._unSealDATACount + self._sealDATACount
  for index = 0, fairyCount do
    local fairyNo
    if 0 == index and 0 == self._unSealDATACount then
    elseif index < self._unSealDATACount then
      local fairyData = ToClient_getFairyUnsealedDataByIndex(index)
      if nil ~= fairyData then
        fairyNo = fairyData:getPcPetNo()
      end
    else
      index = index - self._unSealDATACount
      if 0 == self._unSealDATACount then
        index = index - 1
      end
      local fairyData = ToClient_getFairySealedDataByIndex(index)
      if nil ~= fairyData then
        fairyNo = fairyData._petNo
      end
    end
    if nil ~= fairyNo then
      self._list2_FairyListNew:getElementManager():pushKey(fairyNo)
    end
  end
  if noclearscroll then
    self._list2_FairyListNew:setCurrenttoIndex(toIndex)
    if false == self._list2_FairyListNew:IsIgnoreVerticalScroll() then
      vscroll:SetControlPos(scrollvalue)
    elseif false == self._list2_FairyListNew:IsIgnoreHorizontalScroll() then
      hscroll:SetControlPos(scrollvalue)
    end
  end
end
function FairyListNew:SetPos()
  local ScreenX = getScreenSizeX()
  local ScreenY = getScreenSizeY()
  Panel_Window_FairyListNew:SetPosX(ScreenX / 2 - Panel_Window_FairyListNew:GetSizeX() / 2)
  Panel_Window_FairyListNew:SetPosY(ScreenY / 2 - Panel_Window_FairyListNew:GetSizeY() / 2)
end
function FairyListNew:Open()
  self._isUpgradeState = false
  self:SetPos()
  Panel_Window_FairyListNew:SetShow(true)
  self:UpdateList()
  Panel_Window_FairyListNew:SetShow(false)
  Panel_Window_FairyListNew:SetShow(true)
end
function PaGlobal_FairyListNew_Open()
  local self = FairyListNew
  self:Open()
end
function PaGlobal_FairyListNew_Update(control, key)
  local bg = UI.getChildControl(control, "Static_BG")
  local iconBg = UI.getChildControl(control, "Static_IconBG")
  local icon = UI.getChildControl(control, "Static_Icon")
  local name = UI.getChildControl(control, "StaticText_Name")
  local btn_Setting = UI.getChildControl(control, "Button_Setting")
  local btn_unSeal = UI.getChildControl(control, "Button_Summon")
  local btn_Seal = UI.getChildControl(control, "Button_UnSummon")
  local btn_Upgrade = UI.getChildControl(control, "Button_Upgrade_Select")
  local slot_HpItem = UI.getChildControl(control, "Static_Hp")
  local slot_MpItem = UI.getChildControl(control, "Static_Mp")
  local btn_Feeding = UI.getChildControl(control, "Button_Feeding")
  local tier = UI.getChildControl(control, "StaticText_Tier")
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
  local petStaticStatus, iconPath, petNo_s64, petName, petLevel, petLovely, pethungry, petMaxLevel, petMaxHungry, petRace, petTier, petState, skillType, isPassive, tempIndex
  if isUnsealPet(key) then
    for index = 0, unsealPetCount - 1 do
      local pcPetData = ToClient_getFairyUnsealedDataByIndex(index)
      if nil ~= pcPetData and key == pcPetData:getPcPetNo() then
        petStaticStatus = pcPetData:getPetStaticStatus()
        iconPath = pcPetData:getIconPath()
        petNo_s64 = pcPetData:getPcPetNo()
        petName = pcPetData:getName()
        petRace = petStaticStatus:getPetRace()
        petTier = petStaticStatus:getPetTier()
        petLevel = pcPetData:getLevel()
        if nil ~= pcPetData:getSkillParam(1) then
          skillType = pcPetData:getSkillParam(1)._type
          isPassive = pcPetData:getSkillParam(1):isPassiveSkill()
        end
        name:SetTextMode(UI_TM.eTextMode_None)
        name:SetText(petName)
        if name:IsLimitText() then
          name:addInputEvent("Mouse_On", "PetListNew_NameSimpleTooltip( true,\t" .. index .. ", " .. tostring(true) .. ", " .. tostring(key) .. ")")
          name:addInputEvent("Mouse_Out", "PetListNew_NameSimpleTooltip( false,\t" .. index .. ", " .. tostring(true) .. ", " .. tostring(key) .. ")")
        else
          name:addInputEvent("Mouse_On", "")
          name:addInputEvent("Mouse_Out", "")
        end
        btn_Seal:addInputEvent("Mouse_LUp", "PaGlobal_FairyListNew_Seal( \"" .. tostring(petNo_s64) .. "\")")
        btn_Setting:addInputEvent("Mouse_LUp", "PaGlobal_FairyListNew_Setting(\"" .. tostring(petNo_s64) .. "\"," .. petTier .. ")")
        local SettingData = ToClient_getFairySettingData(petNo_s64)
        if nil ~= SettingData then
          local ItemSSW = getItemEnchantStaticStatus(SettingData._hpItemKey)
          if nil ~= ItemSSW then
            slot_HpItem:ChangeTextureInfoName("Icon/" .. ItemSSW:getIconPath())
            local x1, y1, x2, y2 = setTextureUV_Func(slot_HpItem, 0, 0, 44, 44)
            slot_HpItem:getBaseTexture():setUV(x1, y1, x2, y2)
            slot_HpItem:setRenderTexture(slot_HpItem:getBaseTexture())
            slot_HpItem:SetShow(true)
          else
            slot_HpItem:SetShow(false)
          end
          ItemSSW = getItemEnchantStaticStatus(SettingData._mpItemKey)
          if nil ~= ItemSSW then
            slot_MpItem:ChangeTextureInfoName("Icon/" .. ItemSSW:getIconPath())
            local x1, y1, x2, y2 = setTextureUV_Func(slot_MpItem, 0, 0, 44, 44)
            slot_MpItem:getBaseTexture():setUV(x1, y1, x2, y2)
            slot_MpItem:setRenderTexture(slot_MpItem:getBaseTexture())
            slot_MpItem:SetShow(true)
          else
            slot_MpItem:SetShow(false)
          end
        else
          slot_MpItem:SetShow(false)
          slot_HpItem:SetShow(false)
        end
        btn_unSeal:SetShow(false)
        btn_Seal:SetShow(true)
        btn_Upgrade:SetShow(false)
        btn_Setting:SetShow(true)
        btn_Feeding:SetShow(true)
        control:SetMonoTone(false)
        tier:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(petTier * 10 + petLevel))
        local x1, y1, x2, y2 = setTextureUV_Func(bg, 50, 195, 94, 239)
        bg:getBaseTexture():setUV(x1, y1, x2, y2)
        bg:setRenderTexture(bg:getBaseTexture())
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
        petTier = petStaticStatus:getPetTier()
        petLevel = pcPetData._level
        if nil ~= pcPetData:getSkillParam(1) then
          skillType = pcPetData:getSkillParam(1)._type
          isPassive = pcPetData:getSkillParam(1):isPassiveSkill()
        end
        name:SetTextMode(UI_TM.eTextMode_None)
        name:SetText(petName)
        if name:IsLimitText() then
          name:addInputEvent("Mouse_On", "PetListNew_NameSimpleTooltip( true,\t" .. index .. ", " .. tostring(false) .. ", " .. tostring(key) .. ")")
          name:addInputEvent("Mouse_Out", "PetListNew_NameSimpleTooltip( false,\t" .. index .. ", " .. tostring(false) .. ", " .. tostring(key) .. ")")
        else
          name:addInputEvent("Mouse_On", "")
          name:addInputEvent("Mouse_Out", "")
        end
        unsealPetIndex = index
        btn_unSeal:addInputEvent("Mouse_LUp", "PaGlobal_FairyListNew_UnSeal( \"" .. tostring(petNo_s64) .. "\")")
        btn_Setting:addInputEvent("Mouse_LUp", "PaGlobal_FairyListNew_Setting(\"" .. tostring(petNo_s64) .. "\"," .. petTier .. ")")
        local SettingData = ToClient_getFairySettingData(petNo_s64)
        if nil ~= SettingData then
          local ItemSSW = getItemEnchantStaticStatus(SettingData._hpItemKey)
          if nil ~= ItemSSW then
            slot_HpItem:ChangeTextureInfoName("Icon/" .. ItemSSW:getIconPath())
            local x1, y1, x2, y2 = setTextureUV_Func(slot_HpItem, 0, 0, 44, 44)
            slot_HpItem:getBaseTexture():setUV(x1, y1, x2, y2)
            slot_HpItem:setRenderTexture(slot_HpItem:getBaseTexture())
            slot_HpItem:SetShow(true)
          else
            slot_HpItem:SetShow(false)
          end
          ItemSSW = getItemEnchantStaticStatus(SettingData._mpItemKey)
          if nil ~= ItemSSW then
            slot_MpItem:ChangeTextureInfoName("Icon/" .. ItemSSW:getIconPath())
            local x1, y1, x2, y2 = setTextureUV_Func(slot_MpItem, 0, 0, 44, 44)
            slot_MpItem:getBaseTexture():setUV(x1, y1, x2, y2)
            slot_MpItem:setRenderTexture(slot_MpItem:getBaseTexture())
            slot_MpItem:SetShow(true)
          else
            slot_MpItem:SetShow(false)
          end
        else
          slot_MpItem:SetShow(false)
          slot_HpItem:SetShow(false)
        end
        btn_unSeal:SetShow(true)
        btn_Seal:SetShow(false)
        btn_Upgrade:SetShow(false)
        btn_Setting:SetShow(true)
        btn_Feeding:SetShow(false)
        control:SetMonoTone(false)
        tier:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(petTier * 10 + petLevel))
        if 100 == petRace then
          btn_unSeal:SetShow(false)
          btn_Seal:SetShow(false)
          btn_Setting:SetShow(false)
          tier:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(0))
          name:SetText("\236\154\148\236\160\149\236\151\172\236\153\149\236\157\152 \234\182\140\235\138\165")
        end
        if true == Panel_Window_FairyUpgrade:GetShow() then
          btn_unSeal:SetShow(false)
          btn_Seal:SetShow(false)
          btn_Setting:SetShow(false)
          btn_Upgrade:SetIgnore(false)
          if 100 == petRace then
            btn_Upgrade:addInputEvent("Mouse_LUp", "PaGlobal_FairyUpgrade_RegistStone(\"" .. tostring(petNo_s64) .. "\")")
            btn_Upgrade:SetShow(true)
          elseif 10 == petLevel and petTier < 2 then
            btn_Upgrade:addInputEvent("Mouse_LUp", "PaGlobal_FairyUpgrade_RegistFairy(\"" .. tostring(petNo_s64) .. "\")")
            btn_Upgrade:SetShow(true)
          else
            control:SetMonoTone(true)
            btn_Upgrade:SetShow(true)
            btn_Upgrade:SetIgnore(true)
          end
        end
        local x1, y1, x2, y2 = setTextureUV_Func(bg, 3, 195, 47, 239)
        bg:getBaseTexture():setUV(x1, y1, x2, y2)
        bg:setRenderTexture(bg:getBaseTexture())
      end
    end
  end
  icon:ChangeTextureInfoName(iconPath)
end
function FromClient_FairyUpdateNew()
  FairyListNew:UpdateList()
end
function FairyListNew:RegistEvent()
  self._list2_FairyListNew:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_FairyListNew_Update")
  self._list2_FairyListNew:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._UI._Button_Upgrade:addInputEvent("Mouse_LUp", "PaGlobal_FairyUpgrade_Open_Call()")
  self._UI._Button_Close:addInputEvent("Mouse_LUp", "PaGlobal_FairyListNew_Close()")
  self._UI._Button_Close:SetShow(true)
  self._UI._Static_FeedinfBg:SetShow(false)
  registerEvent("FromClient_PetAddSealedList", "FromClient_FairyUpdateNew")
  registerEvent("FromClient_PetDelSealedList", "FromClient_FairyUpdateNew")
  registerEvent("FromClient_PetDelList", "FromClient_FairyUpdateNew")
  registerEvent("FromClient_InputPetName", "FromClient_FairyUpdateNew")
  registerEvent("FromClient_PetInfoChanged", "FromClient_FairyUpdateNew")
  registerEvent("FromClient_ShowFairyMessageByType", "FromClient_ShowFairyMessageByType")
end
function PaGlobal_FairyListNew_Close()
  PaGlobal_FairyUpgrade_Close()
  PaGlobal_FairySetting_Close()
  Panel_Window_FairyListNew:SetShow(false)
end
function FromClient_ShowFairyMessageByType(msgType)
  if FairyMessageType.eTurnOnLantern == msgType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_TURNON_LANTERN"))
  end
end
function FairyListNew:Initialize()
  self:RegistEvent()
  self:Open()
  Panel_Window_FairyListNew:SetShow(false)
end
function PaGlobal_FairyList_Update()
  FairyListNew:UpdateList(true)
end
FairyListNew:Initialize()
