Panel_Window_PetControl:SetShow(false, false)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local isPlayOpen = ToClient_IsContentsGroupOpen("256")
local PetControl = {
  Btn_PetInfo = UI.getChildControl(Panel_Window_PetControl, "Button_PetInfo"),
  Btn_Follow = UI.getChildControl(Panel_Window_PetControl, "Button_Follow"),
  Btn_Wait = UI.getChildControl(Panel_Window_PetControl, "Button_Wait"),
  Btn_Find = UI.getChildControl(Panel_Window_PetControl, "Button_Find"),
  Btn_GetItem = UI.getChildControl(Panel_Window_PetControl, "Button_GetItem"),
  Btn_Play = UI.getChildControl(Panel_Window_PetControl, "CheckButton_Play"),
  Btn_Seal = UI.getChildControl(Panel_Window_PetControl, "Button_Seal"),
  Dot_RedIcon = UI.getChildControl(Panel_Window_PetControl, "Static_RedDotIcon"),
  Dot_GreenIcon = UI.getChildControl(Panel_Window_PetControl, "Static_GreenDotIcon"),
  Dot_YellowIcon = UI.getChildControl(Panel_Window_PetControl, "Static_YellowDotIcon"),
  Dot_PurpleIcon = UI.getChildControl(Panel_Window_PetControl, "Static_PurpleDotIcon"),
  Dot_GrayIcon1 = UI.getChildControl(Panel_Window_PetControl, "Static_GrayDotIcon1"),
  Dot_GrayIcon2 = UI.getChildControl(Panel_Window_PetControl, "Static_GrayDotIcon2"),
  Btn_IconPet = UI.getChildControl(Panel_Window_PetControl, "Button_IconPet"),
  Stc_IconPetBg = UI.getChildControl(Panel_Window_PetControl, "Static_IconPetBG"),
  Stc_HungryBG = UI.getChildControl(Panel_Window_PetControl, "Static_HungryBG"),
  Progrss_Hungry = UI.getChildControl(Panel_Window_PetControl, "Progress2_Hungry"),
  Txt_HungryAlert = UI.getChildControl(Panel_Window_PetIcon, "StaticText_HungryAlert"),
  Btn_AllSeal = UI.getChildControl(Panel_Window_PetControl, "Button_Allseal")
}
local btnPetIcon = UI.getChildControl(Panel_Window_PetIcon, "Button_PetIcon")
for v, control in pairs(PetControl) do
  control:SetShow(false)
end
local posX = PetControl.Btn_IconPet:GetSizeX()
local maxUnsealCount = ToClient_getPetUseMaxCount()
local temporaryPCRoomWrapper = getTemporaryInformationWrapper()
local isPremiumPcRoom = temporaryPCRoomWrapper:isPremiumPcRoom()
if isPremiumPcRoom then
  maxUnsealCount = maxUnsealCount + ToClient_getPetUseMaxCountPcRoom()
end
local maxPetControlCount = maxUnsealCount
local petCond = {}
local petIcon = {}
local haveUnsealPetNo = {}
local petIconPosX = {}
local petOrderList = {
  _follow = {},
  _find = {},
  _getItem = {}
}
for index = 0, maxPetControlCount - 1 do
  petIconPosX[index] = {}
  petCond[index] = {}
end
function PetControl:Init()
  for index = 0, maxPetControlCount - 1 do
    local temp = {}
    local _petInfo = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, Panel_Window_PetControl, "Button_PetInfo_" .. index)
    CopyBaseProperty(self.Btn_PetInfo, _petInfo)
    _petInfo:addInputEvent("Mouse_LUp", "PetInfoNew_Open(" .. index .. ")")
    _petInfo:addInputEvent("Mouse_On", "petControl_Button_Tooltip( true," .. 4 .. ", " .. index .. ")")
    _petInfo:addInputEvent("Mouse_Out", "petControl_Button_Tooltip( false )")
    _petInfo:setTooltipEventRegistFunc("petControl_Button_Tooltip( true, " .. 4 .. " )")
    temp._petInfo = _petInfo
    local _follow = UI.createControl(UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, Panel_Window_PetControl, "Button_Follow_" .. index)
    CopyBaseProperty(self.Btn_Follow, _follow)
    _follow:addInputEvent("Mouse_LUp", "PetControl_Follow(" .. index .. ")")
    _follow:addInputEvent("Mouse_On", "petControl_Button_Tooltip( true," .. 0 .. ", " .. index .. ")")
    _follow:addInputEvent("Mouse_Out", "petControl_Button_Tooltip( false )")
    _follow:setTooltipEventRegistFunc("petControl_Button_Tooltip( true, " .. 0 .. " )")
    _follow:SetCheck(true)
    temp._follow = _follow
    local _wait = UI.createControl(UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, Panel_Window_PetControl, "Button_Wait_" .. index)
    CopyBaseProperty(self.Btn_Wait, _wait)
    _wait:addInputEvent("Mouse_LUp", "PetControl_Wait(" .. index .. ")")
    _wait:addInputEvent("Mouse_On", "petControl_Button_Tooltip( true," .. 1 .. ", " .. index .. ")")
    _wait:addInputEvent("Mouse_Out", "petControl_Button_Tooltip( false )")
    _wait:setTooltipEventRegistFunc("petControl_Button_Tooltip( true, " .. 1 .. " )")
    temp._wait = _wait
    local _find = UI.createControl(UI_PUCT.PA_UI_CONTROL_CHECKBUTTON, Panel_Window_PetControl, "Button_Find_" .. index)
    CopyBaseProperty(self.Btn_Find, _find)
    _find:addInputEvent("Mouse_LUp", "PetControl_Find(" .. index .. ")")
    _find:addInputEvent("Mouse_On", "petControl_Button_Tooltip( true," .. 3 .. ", " .. index .. ")")
    _find:addInputEvent("Mouse_Out", "petControl_Button_Tooltip( false )")
    _find:setTooltipEventRegistFunc("petControl_Button_Tooltip( true, " .. 3 .. " )")
    _find:SetCheck(false)
    temp._find = _find
    local _getItem = UI.createControl(UI_PUCT.PA_UI_CONTROL_CHECKBUTTON, Panel_Window_PetControl, "Button_GetItem_" .. index)
    CopyBaseProperty(self.Btn_GetItem, _getItem)
    _getItem:addInputEvent("Mouse_LUp", "PetControl_GetItem(" .. index .. ")")
    _getItem:addInputEvent("Mouse_On", "petControl_Button_Tooltip( true," .. 2 .. ", " .. index .. ")")
    _getItem:addInputEvent("Mouse_Out", "petControl_Button_Tooltip( false )")
    _getItem:setTooltipEventRegistFunc("petControl_Button_Tooltip( true, " .. 2 .. " )")
    _getItem:SetCheck(true)
    temp._getItem = _getItem
    local _getPlay = UI.createControl(UI_PUCT.PA_UI_CONTROL_CHECKBUTTON, Panel_Window_PetControl, "Button_Play_" .. index)
    CopyBaseProperty(self.Btn_Play, _getPlay)
    _getPlay:addInputEvent("Mouse_LUp", "PetControl_WithPlay(" .. index .. ")")
    _getPlay:addInputEvent("Mouse_On", "petControl_Button_Tooltip( true," .. 5 .. ", " .. index .. ")")
    _getPlay:addInputEvent("Mouse_Out", "petControl_Button_Tooltip( false )")
    _getPlay:setTooltipEventRegistFunc("petControl_Button_Tooltip( true, " .. 5 .. " )")
    _getPlay:SetCheck(true)
    temp._withPlay = _getPlay
    local _seal = UI.createControl(UI_PUCT.PA_UI_CONTROL_CHECKBUTTON, Panel_Window_PetControl, "Button_Seal_" .. index)
    CopyBaseProperty(self.Btn_Seal, _seal)
    _seal:addInputEvent("Mouse_LUp", "HandleClicked_petControl_Seal(" .. index .. ")")
    _seal:addInputEvent("Mouse_On", "petControl_Button_Tooltip( true," .. 97 .. ", " .. index .. ")")
    _seal:addInputEvent("Mouse_Out", "petControl_Button_Tooltip( false )")
    _seal:setTooltipEventRegistFunc("petControl_Button_Tooltip( true, " .. 97 .. " )")
    temp._seal = _seal
    local _redDotIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, "Static_RedDotIcon_" .. index)
    CopyBaseProperty(self.Dot_RedIcon, _redDotIcon)
    temp._redDotIcon = _redDotIcon
    local _greenDotIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, "Static_GreenDotIcon_" .. index)
    CopyBaseProperty(self.Dot_GreenIcon, _greenDotIcon)
    temp._greenDotIcon = _greenDotIcon
    local _yellowDotIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, "Static_YellowDotIcon_" .. index)
    CopyBaseProperty(self.Dot_YellowIcon, _yellowDotIcon)
    temp._yellowDotIcon = _yellowDotIcon
    local _purpleDotIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, "Static_PurpleDotIcon_" .. index)
    CopyBaseProperty(self.Dot_PurpleIcon, _purpleDotIcon)
    temp._purpleDotIcon = _purpleDotIcon
    local _grayDotIcon1 = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, "Static_GrayDotIcon1_" .. index)
    CopyBaseProperty(self.Dot_GrayIcon1, _grayDotIcon1)
    temp._grayDotIcon1 = _grayDotIcon1
    local _grayDotIcon2 = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, "Static_GrayDotIcon2_" .. index)
    CopyBaseProperty(self.Dot_GrayIcon2, _grayDotIcon2)
    temp._grayDotIcon2 = _grayDotIcon2
    local _iconPet = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, Panel_Window_PetControl, "Button_IconPet_" .. index)
    CopyBaseProperty(self.Btn_IconPet, _iconPet)
    _iconPet:addInputEvent("Mouse_LUp", "HandleClicked_petControl_IconShow(" .. index .. ")")
    _iconPet:addInputEvent("Mouse_On", "petControl_Button_Tooltip( true," .. 98 .. ", " .. index .. ")")
    _iconPet:addInputEvent("Mouse_Out", "petControl_Button_Tooltip( false )")
    _iconPet:setTooltipEventRegistFunc("petControl_Button_Tooltip( true, " .. 98 .. " )")
    temp._iconPet = _iconPet
    local _iconPetBg = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, "Static_IconPetBG_" .. index)
    CopyBaseProperty(self.Stc_IconPetBg, _iconPetBg)
    temp._iconPetBg = _iconPetBg
    local _hungryBg = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, "Static_HungryBG_" .. index)
    CopyBaseProperty(self.Stc_HungryBG, _hungryBg)
    temp._hungryBg = _hungryBg
    local _progress = UI.createControl(UI_PUCT.PA_UI_CONTROL_PROGRESS2, Panel_Window_PetControl, "Progress2_Hungry_" .. index)
    CopyBaseProperty(self.Progrss_Hungry, _progress)
    temp._progress = _progress
    for v, control in pairs(temp) do
      control:SetPosX(control:GetPosX() + (posX + 13) * index)
      control:SetShow(false)
    end
    petIcon[index] = temp
    petIconPosX[index]._petInfo = petIcon[index]._petInfo:GetPosX()
    petIconPosX[index]._seal = petIcon[index]._seal:GetPosX()
    petIconPosX[index]._follow = petIcon[index]._follow:GetPosX()
    petIconPosX[index]._find = petIcon[index]._find:GetPosX()
    petIconPosX[index]._getItem = petIcon[index]._getItem:GetPosX()
    petIconPosX[index]._withPlay = petIcon[index]._withPlay:GetPosX()
  end
  for index = 0, maxPetControlCount - 1 do
    petIcon[index]._petInfo:SetText("")
    petIcon[index]._follow:SetText("")
    petIcon[index]._wait:SetText("")
    petIcon[index]._find:SetText("")
    petIcon[index]._getItem:SetText("")
    petIcon[index]._withPlay:SetText("")
    petIcon[index]._seal:SetText("")
  end
  self.Btn_AllSeal:addInputEvent("Mouse_LUp", "HandleClicked_petControl_AllUnSeal()")
  btnPetIcon:addInputEvent("Mouse_LUp", "FGlobal_PetListNew_Toggle()")
  btnPetIcon:addInputEvent("Mouse_RUp", "Panel_Window_PetControl_ShowToggle()")
  btnPetIcon:addInputEvent("Mouse_On", "petControl_Button_Tooltip( true, 99 )")
  btnPetIcon:addInputEvent("Mouse_Out", "petControl_Button_Tooltip( false )")
  btnPetIcon:setTooltipEventRegistFunc("petControl_Button_Tooltip( true, " .. 99 .. " )")
  btnPetIcon:ActiveMouseEventEffect(true)
  self.Btn_AllSeal:SetShow(false)
  self:unSealSetting()
end
local _havePetCount = 0
local _unSealPetCount = 0
function PetInfoInit_ByPetNo()
  local unSealPetCount = ToClient_getPetUnsealedList()
  local sealPetCount = ToClient_getPetSealedList()
  local havePetCount = unSealPetCount + sealPetCount
  if havePetCount <= 0 then
    return
  end
  if unSealPetCount > _unSealPetCount then
    for index = 0, unSealPetCount - 1 do
      local petData = ToClient_getPetUnsealedDataByIndex(index)
      local newUnsealPetCheck = true
      for pIndex = 0, _unSealPetCount - 1 do
        local _petData = ToClient_getPetUnsealedDataByIndex(pIndex)
        if petData:getPcPetNo() == _petData:getPcPetNo() then
          petCond[index]._petNo = petData:getPcPetNo()
          petCond[index]._follow = petIcon[pIndex]._follow:IsCheck()
          petCond[index]._find = petIcon[pIndex]._find:IsCheck()
          petCond[index]._getItem = petIcon[pIndex]._getItem:IsCheck()
          newUnsealPetCheck = false
        end
      end
      if newUnsealPetCheck then
        petCond[index]._petNo = petData:getPcPetNo()
        petCond[index]._follow = true
        petCond[index]._getItem = true
        local isFind = false
        if nil ~= petData:getSkillParam(1) then
          isFind = petData:getSkillParam(1):isPassiveSkill()
        end
        petCond[index]._find = isFind
        ToClient_callHandlerToPetNo("handlePetFollowMaster", petCond[index]._petNo)
        ToClient_callHandlerToPetNo("handlePetGetItemOn", petCond[index]._petNo)
        if isFind then
          ToClient_callHandlerToPetNo("handlePetFindThatOn", petCond[index]._petNo)
        else
          ToClient_callHandlerToPetNo("handlePetFindThatOff", petCond[index]._petNo)
        end
      end
    end
    _havePetCount = havePetCount
    _unSealPetCount = unSealPetCount
  elseif unSealPetCount < _unSealPetCount then
    if unSealPetCount > 0 then
      for index = 0, unSealPetCount - 1 do
        local petData = ToClient_getPetUnsealedDataByIndex(index)
        for pIndex = 0, _unSealPetCount - 1 do
          local _petData = ToClient_getPetUnsealedDataByIndex(pIndex)
          if nil ~= _petData and petData:getPcPetNo() == _petData:getPcPetNo() then
            petCond[index]._petNo = petData:getPcPetNo()
            petCond[index]._follow = petIcon[pIndex]._follow:IsCheck()
            petCond[index]._find = petIcon[pIndex]._find:IsCheck()
            petCond[index]._getItem = petIcon[pIndex]._getItem:IsCheck()
          end
        end
      end
    end
    _unSealPetCount = unSealPetCount
  end
  PetControl_IconSettingUpdate()
end
function PetControl_IconSettingUpdate()
  local unSealPetCount = ToClient_getPetUnsealedList()
  for index = 0, unSealPetCount - 1 do
    petIcon[index]._follow:SetCheck(petCond[index]._follow)
    petIcon[index]._find:SetCheck(petCond[index]._find)
    petIcon[index]._getItem:SetCheck(petCond[index]._getItem)
  end
  FGlobal_PetControl_CheckUnSealPet()
end
function FGlobal_PetInfoInit()
  PetInfoInit_ByPetNo()
end
local screenX = getScreenSizeX()
local screenY = getScreenSizeY()
local panelSizeX = PetControl.Btn_GetItem:GetSizeX()
local panelSizeY = PetControl.Btn_GetItem:GetSizeY()
local unSealPetNo = {
  [0] = nil,
  nil,
  nil
}
local PetControl_CurrentButtonTooltipType = -1
PetControl.Btn_Follow:ActiveMouseEventEffect(true)
PetControl.Btn_Wait:ActiveMouseEventEffect(true)
function PetControl:ButtonShow(isShow, index)
  petIcon[index]._petInfo:SetShow(isShow)
  petIcon[index]._follow:SetShow(isShow)
  petIcon[index]._wait:SetShow(isShow)
  petIcon[index]._find:SetShow(isShow)
  petIcon[index]._getItem:SetShow(isShow)
  petIcon[index]._withPlay:SetShow(isShow and isPlayOpen)
  petIcon[index]._seal:SetShow(isShow)
end
local showIndex = -1
function FGlobal_PetControl_CheckUnSealPet(petNo_s64)
  if isFlushedUI() then
    return
  end
  if not Panel_Window_PetControl:GetShow() then
    return
  end
  local isUnSealPet = ToClient_getPetUnsealedList()
  if isUnSealPet > 0 then
    PetControl_RePos()
    for index = 0, maxUnsealCount - 1 do
      local PetUnSealData = ToClient_getPetUnsealedDataByIndex(index)
      if nil ~= PetUnSealData then
        local self = petIcon[index]
        local unsealPetStaticStatus = PetUnSealData:getPetStaticStatus()
        local unsealIconPath = PetUnSealData:getIconPath()
        local petNo = PetUnSealData:getPcPetNo()
        petIcon[index]._iconPet:ChangeTextureInfoName(unsealIconPath)
        for v, control in pairs(petIcon[index]) do
          control:SetShow(true)
        end
        if isShowIndex() ~= index then
          PetControl:ButtonShow(false, index)
        else
          self._wait:SetShow(false)
        end
        if nil == petCond[index]._follow then
          petCond[index]._petNo = petNo
          petCond[index]._follow = true
          petCond[index]._find = false
          petCond[index]._getItem = true
          ToClient_callHandlerToPetNo("handlePetFollowMaster", petCond[index]._petNo)
          ToClient_callHandlerToPetNo("handlePetFindThatOff", petCond[index]._petNo)
          ToClient_callHandlerToPetNo("handlePetGetItemOn", petCond[index]._petNo)
        end
        if nil ~= PetUnSealData:getSkillParam(1) and PetUnSealData:getSkillParam(1):isPassiveSkill() then
          petCond[index]._find = true
        end
        self._follow:SetCheck(petCond[index]._follow)
        self._find:SetCheck(petCond[index]._find)
        self._getItem:SetCheck(petCond[index]._getItem)
        local isFollow = self._follow:IsCheck()
        self._greenDotIcon:SetShow(isFollow)
        self._redDotIcon:SetShow(not isFollow)
        local isFind = self._find:IsCheck()
        self._yellowDotIcon:SetShow(isFind)
        self._grayDotIcon1:SetShow(not isFind)
        local isGetItem = self._getItem:IsCheck()
        self._purpleDotIcon:SetShow(isGetItem)
        self._grayDotIcon2:SetShow(not isGetItem)
        local petLootingType = PetUnSealData:getPetLootingType()
        self._withPlay:ChangeTextureInfoName("new_ui_common_forlua/window/servant/pet_00.dds")
        local x1, y1, x2, y2
        if 0 == petLootingType then
          x1, y1, x2, y2 = setTextureUV_Func(self._withPlay, 140, 280, 172, 312)
        elseif 1 == petLootingType then
          x1, y1, x2, y2 = setTextureUV_Func(self._withPlay, 104, 280, 136, 312)
        elseif 2 == petLootingType then
          x1, y1, x2, y2 = setTextureUV_Func(self._withPlay, 176, 280, 208, 312)
        end
        self._withPlay:getBaseTexture():setUV(x1, y1, x2, y2)
        self._withPlay:setRenderTexture(self._withPlay:getBaseTexture())
        if Panel_Window_PetIcon:GetShow() then
          petIcon[index]._progress:SetShow(true)
          petIcon[index]._hungryBg:SetShow(true)
        else
          petIcon[index]._progress:SetShow(false)
          petIcon[index]._hungryBg:SetShow(false)
        end
        FGlobal_PetContorl_HungryGaugeUpdate(petNo)
      else
        for v, control in pairs(petIcon[index]) do
          control:SetShow(false)
        end
      end
    end
  else
    if Panel_Window_PetControl:GetShow() then
      Panel_Window_PetControl_ShowToggle()
    end
    haveUnsealPetNo = {}
  end
  PetControl_RePos()
end
function isShowIndex()
  return showIndex
end
function PetControl_SetPositon()
  Panel_Window_PetControl:SetPosX(10)
  Panel_Window_PetControl:SetPosY(Panel_SelfPlayerExpGage:GetSizeY() * 2.2)
end
function PetInfoNew_Open(index)
  TooltipSimple_Hide()
  local petCount = ToClient_getPetUnsealedList()
  if petCount == 0 then
    return
  end
  local petNo = ToClient_getPetUnsealedDataByIndex(index):getPcPetNo()
  FGlobal_PetInfoNew_Open(petNo, true)
end
function PetControl_Follow(index)
  TooltipSimple_Hide()
  PetControl_BTNCheckedUpdate(index)
end
function PetControl_Wait(index)
  TooltipSimple_Hide()
  PetControl_BTNCheckedUpdate(index)
end
function PetControl_BTNCheckedUpdate(index, isByPetListUpdate)
  local petCount = ToClient_getPetUnsealedList()
  if petCount == 0 then
    return
  end
  local petNo = ToClient_getPetUnsealedDataByIndex(index):getPcPetNo()
  petCond[index]._follow = not petCond[index]._follow
  local isFollow = petCond[index]._follow
  if isFollow then
    ToClient_callHandlerToPetNo("handlePetFollowMaster", petNo)
  else
    ToClient_callHandlerToPetNo("handlePetWaitMaster", petNo)
  end
  petIcon[index]._follow:SetShow(isFollow)
  petIcon[index]._wait:SetShow(not isFollow)
  petOrderList._follow[tostring(petNo)] = isFollow
  PetControl_IconSettingUpdate()
  FGlobal_PetList_PetOrder(index)
end
function PetControl_WithPlay(index)
  TooltipSimple_Hide()
  local PetUnSealData = ToClient_getPetUnsealedDataByIndex(index)
  if nil ~= PetUnSealData then
    local petNo = PetUnSealData:getPcPetNo()
    local petLootingType = (PetUnSealData:getPetLootingType() + 1) % 3
    ToClient_requestChangePetLootingType(petNo, petLootingType)
  end
end
function PetControl_GetItem(index, isByPetListUpdate)
  TooltipSimple_Hide()
  local petCount = ToClient_getPetUnsealedList()
  if petCount == 0 then
    return
  end
  local petNo = ToClient_getPetUnsealedDataByIndex(index):getPcPetNo()
  petCond[index]._getItem = not petCond[index]._getItem
  local isGetItem = petCond[index]._getItem
  if isGetItem then
    ToClient_callHandlerToPetNo("handlePetGetItemOn", petNo)
  else
    ToClient_callHandlerToPetNo("handlePetGetItemOff", petNo)
  end
  petOrderList._getItem[tostring(petNo)] = isGetItem
  PetControl_IconSettingUpdate()
  FGlobal_PetList_PetOrder(index)
end
function PetControl_Find(index, isByPetListUpdate)
  TooltipSimple_Hide()
  if PetTalentCheck(index) then
    petIcon[index]._find:SetCheck(true)
    petIcon[index]._yellowDotIcon:SetShow(true)
    petIcon[index]._grayDotIcon1:SetShow(false)
    return
  end
  local petCount = ToClient_getPetUnsealedList()
  if petCount == 0 then
    return
  end
  local petNo = ToClient_getPetUnsealedDataByIndex(index):getPcPetNo()
  petCond[index]._find = not petCond[index]._find
  local isFind = petCond[index]._find
  if isFind then
    ToClient_callHandlerToPetNo("handlePetFindThatOn", petNo)
  else
    ToClient_callHandlerToPetNo("handlePetFindThatOff", petNo)
  end
  petOrderList._find[tostring(petNo)] = isFind
  PetControl_IconSettingUpdate()
  FGlobal_PetList_PetOrder(index)
end
function PetTalentCheck(index)
  local petCount = ToClient_getPetUnsealedList()
  if petCount == 0 then
    return false
  end
  local petData = ToClient_getPetUnsealedDataByIndex(index)
  local petRace = petData:getPetStaticStatus():getPetRace()
  if nil ~= petData and nil ~= petData:getSkillParam(1) then
    return petData:getSkillParam(1):isPassiveSkill()
  end
  return false
end
function FGlobal_PetControl_OrderList(orderType, index)
  local petCount = ToClient_getPetUnsealedList()
  if petCount == 0 then
    return
  end
  local petNo = ToClient_getPetUnsealedDataByIndex(index):getPcPetNo()
  if 0 == orderType then
    PetControl_BTNCheckedUpdate(index, true)
  elseif 1 == orderType then
    PetControl_Find(index, true)
  elseif 2 == orderType then
    PetControl_GetItem(index, true)
  end
end
function FGlobal_PetControl_SealPet(index)
  local self = petIcon[index]
  local unsealedPetList = ToClient_getPetUnsealedList()
  if unsealedPetList > 0 then
    local petData = ToClient_getPetUnsealedDataByIndex(index)
    local petNo = petData:getPcPetNo()
    for petIconIndex = 0, maxUnsealCount - 1 do
      local petData = ToClient_getPetUnsealedDataByIndex(petIconIndex)
      if nil ~= petData then
        FGlobal_PetContorl_HungryGaugeUpdate(petData:getPcPetNo())
        PetControl:ButtonShow(false, petIconIndex)
      end
    end
  end
  if Panel_Window_PetIcon:GetShow() then
    self._progress:SetShow(true)
    self._hungryBg:SetShow(true)
  else
    self._progress:SetShow(false)
    self._hungryBg:SetShow(false)
  end
  FGlobal_PetControl_RestoreUI()
end
function FGlobal_PetControl_RestoreUI()
  local self = PetControl
  TooltipSimple_Hide()
  local unsealedCount = ToClient_getPetUnsealedList()
  if unsealedCount <= 0 then
    return
  end
  if Panel_Window_PetControl:GetShow() or Panel_Window_PetIcon:GetShow() then
    local isUnSealPetIndex = unsealedCount - 1
  end
end
function HandleClicked_petControl_IconShow(index)
  for i = 0, maxUnsealCount - 1 do
    if true == petIcon[i]._petInfo:GetShow() then
      PetControl_ButtonHide(i)
      return
    end
  end
  PetControl_ButtonShow(index)
end
function HandleClicked_petControl_Seal(index)
  TooltipSimple_Hide()
  local self = petIcon[index]
  local unSealPetInfo = ToClient_getPetUnsealedList()
  local PetUnSealData = ToClient_getPetUnsealedDataByIndex(index)
  if nil ~= PetUnSealData then
    local unsealPetNo_s64 = PetUnSealData:getPcPetNo()
    FGlobal_petListNew_Seal(tostring(unsealPetNo_s64), index)
  end
  FGlobal_AllSealButtonPosition(unSealPetInfo, false)
end
function HandleClicked_petControl_AllUnSeal(groupIndex)
  if Panel_Window_PetFusion:GetShow() then
    return
  end
  for index = 0, maxUnsealCount - 1 do
    local self = petIcon[index]
    local unSealPetInfo = ToClient_getPetUnsealedList()
    local PetUnSealData = ToClient_getPetUnsealedDataByIndex(index)
    if nil ~= PetUnSealData then
      local unsealPetNo_s64 = PetUnSealData:getPcPetNo()
      if nil ~= groupIndex then
        if true ~= checkUnSealGroupList[groupIndex][Int64toInt32(unsealPetNo_s64)] then
          FGlobal_petListNew_Seal(tostring(unsealPetNo_s64), index)
        end
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_ALLUNSEAL"))
        FGlobal_petListNew_Seal(tostring(unsealPetNo_s64), index)
      end
    end
  end
  PetList_VScroll_MoveTop()
  FGlobal_PetList_FeedClose()
end
function FGlobal_HandleClicked_petControl_AllUnSeal(groupIndex)
  HandleClicked_petControl_AllUnSeal(groupIndex)
end
local unSealPetCounting = 0
function FGlobal_AllSealButtonPosition(sealCount, sealType)
  local self = PetControl
  if nil == sealCount then
    unSealPetCounting = ToClient_getPetUnsealedList()
  elseif true == sealType then
    unSealPetCounting = sealCount + 1
  else
    unSealPetCounting = sealCount - 1
  end
  self.Btn_AllSeal:SetPosX(20 + 57 * unSealPetCounting)
end
function PetControl_ButtonShow(index)
  local self = petIcon[index]
  local endTime = 0.08
  local MoveAni1 = self._petInfo:addMoveAnimation(0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MoveAni1:SetStartPosition(petIconPosX[index]._petInfo, self._petInfo:GetPosY())
  MoveAni1:SetEndPosition(petIconPosX[index]._petInfo, self._petInfo:GetPosY())
  self._petInfo:SetShow(true)
  local MoveAni2 = self._seal:addMoveAnimation(0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MoveAni2:SetStartPosition(petIconPosX[index]._petInfo, self._seal:GetPosY())
  MoveAni2:SetEndPosition(petIconPosX[index]._seal, self._seal:GetPosY())
  self._seal:SetShow(true)
  local MoveAni3 = self._follow:addMoveAnimation(0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MoveAni3:SetStartPosition(petIconPosX[index]._petInfo, self._follow:GetPosY())
  MoveAni3:SetEndPosition(petIconPosX[index]._follow, self._follow:GetPosY())
  if self._greenDotIcon:GetShow() then
    self._follow:SetShow(true)
    self._wait:SetShow(false)
  else
    self._wait:SetShow(true)
    self._follow:SetShow(false)
  end
  local MoveAni4 = self._wait:addMoveAnimation(0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MoveAni4:SetStartPosition(petIconPosX[index]._petInfo, self._follow:GetPosY())
  MoveAni4:SetEndPosition(petIconPosX[index]._follow, self._follow:GetPosY())
  local MoveAni5 = self._find:addMoveAnimation(0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MoveAni5:SetStartPosition(petIconPosX[index]._petInfo, self._find:GetPosY())
  MoveAni5:SetEndPosition(petIconPosX[index]._find, self._find:GetPosY())
  self._find:SetShow(true)
  local MoveAni6 = self._getItem:addMoveAnimation(0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MoveAni6:SetStartPosition(petIconPosX[index]._petInfo, self._getItem:GetPosY())
  MoveAni6:SetEndPosition(petIconPosX[index]._getItem, self._getItem:GetPosY())
  self._getItem:SetShow(true)
  local MoveAni7 = self._withPlay:addMoveAnimation(0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MoveAni7:SetStartPosition(petIconPosX[index]._petInfo, self._withPlay:GetPosY())
  MoveAni7:SetEndPosition(petIconPosX[index]._withPlay, self._withPlay:GetPosY())
  self._withPlay:SetShow(isPlayOpen)
end
function PetControl_ButtonHide(index)
  local self = petIcon[index]
  PetControl:ButtonShow(false, index)
end
function Panel_Window_PetControl_ShowToggle()
  if Panel_Window_PetControl:GetShow() then
    Panel_Window_PetControl:SetShow(false)
  else
    Panel_Window_PetControl:SetShow(true)
    FGlobal_PetControl_CheckUnSealPet()
    local unSealPetCount = ToClient_getPetUnsealedList()
    for index = 0, unSealPetCount - 1 do
      PetControl_ButtonHide(index)
    end
  end
  PetControl_RePos()
  PetControl.Btn_AllSeal:SetShow(true)
  FGlobal_AllSealButtonPosition()
  local panelParty
  if false == _ContentsGroup_RemasterUI_Party then
    panelParty = Panel_Party
  else
    panelParty = Panel_Widget_Party
  end
  if panelParty:GetShow() and Panel_Window_PetControl:GetShow() then
    local petCount = ToClient_getPetUnsealedList()
    local isOverlap = false
    for overlapY = panelParty:GetPosY(), panelParty:GetPosY() + panelParty:GetSizeY(), panelParty:GetSizeY() do
      if overlapY >= Panel_Window_PetControl:GetPosY() and overlapY <= Panel_Window_PetControl:GetPosY() + Panel_Window_PetControl:GetSizeY() then
        isOverlap = true
      end
    end
    if isOverlap then
      for overlapX = panelParty:GetPosX(), panelParty:GetPosX() + panelParty:GetSizeX(), panelParty:GetSizeX() do
        if overlapX >= Panel_Window_PetControl:GetPosX() and overlapX <= Panel_Window_PetControl:GetPosX() + (Panel_Window_PetControl:GetSizeX() + 10) * petCount + 60 then
          PartyPanel_Repos()
          return
        end
      end
    end
  end
end
function PetControl_RePos()
  local posX = PaGlobalFunc_PetIcon_GetPosX()
  local posY = PaGlobalFunc_PetIcon_GetPosY()
  local screenX = getScreenSizeX()
  if posX < screenX / 4 then
    Panel_Window_PetControl:SetPosX(10)
  else
    local unSealPetCount = ToClient_getPetUnsealedList()
    local controlSizeX = math.max(184, 57 * unSealPetCount + 70)
    if screenX >= posX + controlSizeX then
      Panel_Window_PetControl:SetPosX(posX)
    else
      Panel_Window_PetControl:SetPosX(screenX - controlSizeX)
    end
  end
  Panel_Window_PetControl:SetPosY(posY + PaGlobalFunc_PetIcon_GetSizeY() + 10)
end
function petControl_Button_Tooltip(isShow, buttonType, index)
  if false == isShow then
    TooltipSimple_Hide()
    PetControl.Txt_HungryAlert:SetShow(false)
    return
  end
  local self, uiControl, name, desc
  if nil ~= index then
    self = petIcon[index]
  else
    if 99 == buttonType then
      uiControl = Panel_Window_PetIcon
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_BUTTONTOOLTIP_PETLIST_NAME")
      if 0 == ToClient_getPetUnsealedList() then
        desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_BUTTONTOOLTIP_WAITPET_DESC")
      else
        if Panel_Window_PetControl:GetShow() then
          desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_BUTTONTOOLTIP_ICONHIDE_DESC")
        else
          desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_BUTTONTOOLTIP_ICONSHOW_DESC")
        end
        if PetHungryConditionCheck() then
          desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETCONTROL_BUTTONTOOLTIP_PETHUNGRY_DESC", "desc", desc)
        end
      end
    else
      return
    end
    registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(uiControl, name, desc)
    return
  end
  if true == isShow then
    if 0 == buttonType then
      uiControl = self._follow
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_FOLLOW_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_FOLLOW_DESC")
    elseif 1 == buttonType then
      uiControl = self._wait
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_WAIT_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_WAIT_DESC")
    elseif 2 == buttonType then
      uiControl = self._getItem
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_GETITEM_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_GETITEM_DESC")
    elseif 3 == buttonType then
      uiControl = self._find
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_FIND_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_FIND_DESC")
    elseif 4 == buttonType then
      uiControl = self._petInfo
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PETINFO_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PETINFO_DESC")
    elseif 5 == buttonType then
      local pcPetData = ToClient_getPetUnsealedDataByIndex(index)
      if nil == pcPetData then
        return
      end
      local petLootingType = pcPetData:getPetLootingType()
      local lootingTypeString = ""
      if 0 == petLootingType then
        lootingTypeString = PAGetString(Defines.StringSheet_GAME, "LUA_IPETCONTROL_TOOLTIP_LOOTINGTYPE_0")
      elseif 1 == petLootingType then
        lootingTypeString = PAGetString(Defines.StringSheet_GAME, "LUA_IPETCONTROL_TOOLTIP_LOOTINGTYPE_1")
      elseif 2 == petLootingType then
        lootingTypeString = PAGetString(Defines.StringSheet_GAME, "LUA_IPETCONTROL_TOOLTIP_LOOTINGTYPE_2")
      end
      uiControl = self._withPlay
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PLAY_NAME") .. lootingTypeString
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PLAY_DESC")
    elseif 97 == buttonType then
      uiControl = self._seal
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PETSEAL_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PETSEAL_DESC")
    elseif 98 == buttonType then
      uiControl = self._iconPet
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PETCONTROL_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PETCONTROL_DESC")
    end
    registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(uiControl, name, desc)
  end
end
function FGlobal_PetContorl_HungryGaugeUpdate(petNo_s64)
  if isFlushedUI() then
    return
  end
  local petCount = ToClient_getPetUnsealedList()
  if petCount == 0 then
    return
  end
  local isHungry = false
  for index = 0, petCount - 1 do
    local pcPetData = ToClient_getPetUnsealedDataByIndex(index)
    if nil ~= pcPetData then
      local petStaticStatus = pcPetData:getPetStaticStatus()
      local petHungry = pcPetData:getHungry()
      local petMaxHungry = petStaticStatus._maxHungry
      local petHungryPercent = petHungry / petMaxHungry * 100
      petIcon[index]._progress:SetProgressRate(petHungryPercent)
      petIcon[index]._progress:SetShow(true)
      if petHungryPercent < 10 then
        isHungry = true
      end
    end
  end
  FGlobal_PetHungryAlert(isHungry)
end
local hungryCheck = false
function FGlobal_PetHungryAlert(petHungryCheck)
  if isFlushedUI() then
    return
  end
  btnPetIcon:EraseAllEffect()
  if petHungryCheck and 0 < ToClient_getPetUnsealedList() then
    btnPetIcon:AddEffect("fUI_Pet_01A", true, -1, -0.5)
  end
  hungryCheck = petHungryCheck
end
function PetHungryConditionCheck()
  return hungryCheck
end
function PetControl_registMessageHandler()
  registerEvent("FromClient_PetAddList", "FGlobal_PetContorl_HungryGaugeUpdate")
  registerEvent("FromClient_PetInfoChanged", "FGlobal_PetContorl_HungryGaugeUpdate")
  registerEvent("FromClient_UpdateControlIconInfo", "UpdateControlIconInfo")
end
local petIndex = 0
function PetControl:unSealSetting()
  petIndex = 0
  ToClient_getPetInitLuaInfo()
end
function PetControl:isUnSealPet(petNo_s64)
  local unsealPetCount = ToClient_getPetUnsealedList()
  if unsealPetCount > 0 then
    for index = 0, unsealPetCount - 1 do
      local pcPetData = ToClient_getPetUnsealedDataByIndex(index)
      if nil ~= pcPetData and petNo_s64 == pcPetData:getPcPetNo() then
        return true
      end
    end
  end
  return false
end
function PetControl:returnUnSealIndex(petNo_s64)
  local unSealPetCount = ToClient_getPetUnsealedList()
  for index = 0, unSealPetCount - 1 do
    local petData = ToClient_getPetUnsealedDataByIndex(index)
    if nil ~= petData and petData:getPcPetNo() == petNo_s64 then
      return index
    end
  end
  return nil
end
function UpdateControlIconInfo(petNo64, followAndWait, isFind, isGetItem)
  if false == PetControl:isUnSealPet(petNo64) then
    return
  end
  local petCondIndex = PetControl:returnUnSealIndex(petNo64)
  petCond[petCondIndex]._petNo = petNo64
  if followAndWait then
    ToClient_callHandlerToPetNo("handlePetFollowMaster", petNo64)
  else
    ToClient_callHandlerToPetNo("handlePetWaitMaster", petNo64)
  end
  petIcon[petCondIndex]._follow:SetCheck(followAndWait)
  petIcon[petCondIndex]._wait:SetCheck(not followAndWait)
  petIcon[petCondIndex]._greenDotIcon:SetShow(followAndWait)
  petIcon[petCondIndex]._redDotIcon:SetShow(not followAndWait)
  if isFind then
    ToClient_callHandlerToPetNo("handlePetFindThatOn", petNo64)
  else
    ToClient_callHandlerToPetNo("handlePetFindThatOff", petNo64)
  end
  petIcon[petCondIndex]._find:SetCheck(isFind)
  petIcon[petCondIndex]._yellowDotIcon:SetShow(isFind)
  petIcon[petCondIndex]._grayDotIcon1:SetShow(not isFind)
  if isGetItem then
    ToClient_callHandlerToPetNo("handlePetGetItemOn", petNo64)
  else
    ToClient_callHandlerToPetNo("handlePetGetItemOff", petNo64)
  end
  petIcon[petCondIndex]._getItem:SetCheck(isGetItem)
  petIcon[petCondIndex]._purpleDotIcon:SetShow(isGetItem)
  petIcon[petCondIndex]._grayDotIcon2:SetShow(not isGetItem)
  petCond[petCondIndex]._follow = followAndWait
  petCond[petCondIndex]._find = isFind
  petCond[petCondIndex]._getItem = isGetItem
  petOrderList._follow[tostring(petNo64)] = followAndWait
  petOrderList._find[tostring(petNo64)] = isFind
  petOrderList._getItem[tostring(petNo64)] = isGetItem
  petIndex = petIndex + 1
  _unSealPetCount = petIndex
end
function PetControl_UnsealPetOrderInfo(petNo64)
  if nil == petOrderList._follow[tostring(petNo64)] then
    for index = 0, ToClient_getPetUnsealedList() - 1 do
      local pcPetData = ToClient_getPetUnsealedDataByIndex(index)
      if nil ~= pcPetData and petNo64 == tostring(pcPetData:getPcPetNo()) then
        if nil ~= pcPetData:getSkillParam(1) then
          local isCheckTalent = pcPetData:getSkillParam(1):isPassiveSkill()
          petOrderList._find[tostring(petNo64)] = isCheckTalent
        else
          petOrderList._find[tostring(petNo64)] = false
        end
        petOrderList._follow[tostring(petNo64)] = true
        petOrderList._getItem[tostring(petNo64)] = true
        if petNo64 == petCond[index]._petNo then
          petCond[index]._follow = petOrderList._follow[tostring(petNo64)]
          petCond[index]._find = petOrderList._find[tostring(petNo64)]
          petCond[index]._getItem = petOrderList._getItem[tostring(petNo64)]
        end
        PetInfoInit_ByPetNo()
        return petOrderList
      end
    end
  else
    return petOrderList
  end
end
PetControl:Init()
PetControl_registMessageHandler()
function renderModeChange_PetControl_RestoreUI(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  FGlobal_PetControl_RestoreUI()
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_PetControl_RestoreUI")
function PaGlobalFunc_PetIcon_GetPosX()
  if true == _ContentsGroup_RemasterUI_Main then
    return PaGlobalFunc_ServantIcon_GetIconPosX(9)
  else
    return Panel_Window_PetIcon:GetPosX()
  end
end
function PaGlobalFunc_PetIcon_GetPosY()
  if true == _ContentsGroup_RemasterUI_Main then
    return PaGlobalFunc_ServantIcon_GetIconPosY(9)
  else
    return Panel_Window_PetIcon:GetPosY()
  end
end
function PaGlobalFunc_PetIcon_GetSizeY()
  if true == _ContentsGroup_RemasterUI_Main then
    return PaGlobalFunc_ServantIcon_GetIconSizeY(9)
  else
    return Panel_Window_PetIcon:GetSizeY()
  end
end
