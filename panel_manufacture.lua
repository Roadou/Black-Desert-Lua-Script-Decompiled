Panel_Manufacture:ActiveMouseEventEffect(true)
Panel_Manufacture:SetShow(false, false)
Panel_Manufacture:setGlassBackground(true)
Panel_Manufacture:RegisterShowEventFunc(true, "ManufactureShowAni()")
Panel_Manufacture:RegisterShowEventFunc(false, "ManufactureHideAni()")
registerEvent("Event_ManufactureUpdateSlot", "Manufacture_Response")
registerEvent("EventShowManufactureWindow", "Manufacture_ToggleWindow")
registerEvent("Event_ManufactureResultList", "Manufacture_ResponseResultItem")
local IM = CppEnums.EProcessorInputMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UIMode = Defines.UIMode
local territorySupply = ToClient_IsContentsGroupOpen("22")
local contentsOption = ToClient_IsContentsGroupOpen("36")
local enableCraft = ToClient_IsContentsGroupOpen("285")
local manufacture_Init = function()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  Panel_Manufacture:SetPosX((screenSizeX - Panel_Manufacture:GetSizeX()) / 2)
  Panel_Manufacture:SetPosY((screenSizeY - Panel_Window_Inventory:GetSizeY()) / 2)
end
manufacture_Init()
function manufacture_Repos()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  Panel_Manufacture:SetPosX((screenSizeX - Panel_Manufacture:GetSizeX()) / 2)
  Panel_Manufacture:SetPosY((screenSizeY - Panel_Window_Inventory:GetSizeY()) / 2)
end
local noneStackItemList = Array.new()
local noneStackItemCheck = false
local hasNoneStackItem = false
local selectedWarehouseItemKey = -1
local selectedWarehouseItemSlotNo = -1
local targetWarehouseSlotNo = -1
local noneStackItem_ChkBtn = UI.getChildControl(Panel_Manufacture, "CheckButton_Action2")
noneStackItem_ChkBtn:SetShow(false)
noneStackItem_ChkBtn:SetCheck(false)
noneStackItem_ChkBtn:addInputEvent("Mouse_LUp", "noneStackItemCheckBT()")
noneStackItem_ChkBtn:SetEnableArea(0, 0, noneStackItem_ChkBtn:GetSizeX() + noneStackItem_ChkBtn:GetTextSizeX() + 10, noneStackItem_ChkBtn:GetSizeY())
local _ACTIONNAME_SHAKE = "MANUFACTURE_SHAKE"
local _ACTIONNAME_GRIND = "MANUFACTURE_GRIND"
local _ACTIONNAME_FIREWOOD = "MANUFACTURE_FIREWOOD"
local _ACTIONNAME_DRY = "MANUFACTURE_DRY"
local _ACTIONNAME_THINNING = "MANUFACTURE_THINNING"
local _ACTIONNAME_HEAT = "MANUFACTURE_HEAT"
local _ACTIONNAME_RAINWATER = "MANUFACTURE_RAINWATER"
local _ACTIONNAME_REPAIR = "REPAIR_ITEM"
local _ACTIONNAME_ALCHEMY = "MANUFACTURE_ALCHEMY"
local _ACTIONNAME_COOK = "MANUFACTURE_COOK"
local _ACTIONNAME_RG_COOK = "MANUFACTURE_ROYALGIFT_COOK"
local _ACTIONNAME_RG_ALCHEMY = "MANUFACTURE_ROYALGIFT_ALCHEMY"
local _ACTIONNAME_GUILDMANUFACTURE = "MANUFACTURE_GUILD"
local _ACTIONNAME_CRAFT = "MANUFACTURE_CRAFT"
local CURRENT_ACTIONNAME = ""
local MAX_ACTION_BTN = 13
local SUBTEXT_OFFSETX = 60
local SUBTEXT_OFFSETY = 17
local ACTION_BTN_HEIGHT = 50
local waypointKey_ByWareHouse = 0
local invenShow = false
local isEnableMsg = {}
local materialItemWhereType = CppEnums.ItemWhereType.eInventory
local INSTALLATIONTYPE_ACTIONNAME = {}
INSTALLATIONTYPE_ACTIONNAME[CppEnums.InstallationType.eType_Mortar] = _ACTIONNAME_GRIND
INSTALLATIONTYPE_ACTIONNAME[CppEnums.InstallationType.eType_Stump] = _ACTIONNAME_FIREWOOD
INSTALLATIONTYPE_ACTIONNAME[CppEnums.InstallationType.eType_FireBowl] = _ACTIONNAME_HEAT
INSTALLATIONTYPE_ACTIONNAME[CppEnums.InstallationType.eType_Anvil] = _ACTIONNAME_REPAIR
local _defaultSlotNo = 255
local _materialSlotNoList = {
  [0] = _defaultSlotNo,
  _defaultSlotNo,
  _defaultSlotNo,
  _defaultSlotNo,
  _defaultSlotNo
}
local _materialSlotNoListItemIn = {
  [0] = false,
  false,
  false,
  false,
  false
}
local _actionIndex = -1
local _actionName = "NONE"
local _usingInstallationType = CppEnums.InstallationType.TypeCount
local _listAction = {}
local manufactureAction = {_radioBtn, _actionName}
local manufactureListDesc = {
  [0] = "GAME_MANUFACTURE_DESC_SHAKE",
  [1] = "GAME_MANUFACTURE_DESC_GRIND",
  [2] = "GAME_MANUFACTURE_DESC_FIREWOOD",
  [3] = "GAME_MANUFACTURE_DESC_DRY",
  [4] = "GAME_MANUFACTURE_DESC_THINNING",
  [5] = "GAME_MANUFACTURE_DESC_HEAT",
  [6] = "GAME_MANUFACTURE_DESC_RAINWATER",
  [7] = "GAME_MANUFACTURE_DESC_REPAIR",
  [8] = "GAME_MANUFACTURE_DESC_ALCHEMY",
  [9] = "GAME_MANUFACTURE_DESC_COOK",
  [10] = "GAME_MANUFACTURE_DESC_ROYALGIFT_COOK",
  [11] = "GAME_MANUFACTURE_DESC_ROYALGIFT_ALCHEMY",
  [12] = "LUA_MANUFACTURE_GUILDMANURACTURE_NAME",
  [13] = "LUA_MANUFACTURE_CRAFT_NAME"
}
local manufactureListName = {
  [0] = "ALCHEMY_MANUFACTURE_SHAKE",
  [1] = "ALCHEMY_MANUFACTURE_GRIND",
  [2] = "ALCHEMY_MANUFACTURE_WOODSPLITTING",
  [3] = "ALCHEMY_MANUFACTURE_DRY",
  [4] = "ALCHEMY_MANUFACTURE_THINNING",
  [5] = "ALCHEMY_MANUFACTURE_HEATING",
  [6] = "",
  [7] = "ALCHEMY_MANUFACTURE_REPAIR",
  [8] = "LUA_ALCHEMY_MANUFACTURE_ALCHEMY",
  [9] = "LUA_ALCHEMY_MANUFACTURE_COOK",
  [10] = "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_COOK",
  [11] = "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_ALCHEMY",
  [12] = "LUA_MANUFACTURE_GUILDMANURACTURE_NAME",
  [13] = "LUA_MANUFACTURE_CRAFT_NAME"
}
local _usingItemSlotCount = 0
local _whiteCircle = UI.getChildControl(Panel_Manufacture, "Static_Circle")
local _slotConfig = {
  createIcon = true,
  createBorder = false,
  createCount = true,
  createCash = true
}
local _slotCount = 5
local _pointList = {}
local function contentsOptionCheck()
  if contentsOption then
    if enableCraft then
      MAX_ACTION_BTN = 14
    else
      MAX_ACTION_BTN = 13
    end
  elseif enableCraft then
    MAX_ACTION_BTN = 13
  else
    MAX_ACTION_BTN = 12
  end
end
contentsOptionCheck()
for ii = 0, _slotCount - 1 do
  _pointList[ii] = UI.getChildControl(Panel_Manufacture, "Static_Point_" .. ii + 1)
  _pointList[ii]:SetShow(false)
end
local _slotList = {}
for index = 0, _slotCount - 1 do
  local createdSlot = {}
  SlotItem.new(createdSlot, "ItemIconSlot" .. index, 0, _pointList[index], _slotConfig)
  createdSlot:createChild()
  createdSlot.icon:SetPosX(1)
  createdSlot.icon:SetPosY(1)
  createdSlot.icon:addInputEvent("Mouse_RUp", "Material_Mouse_RUp(" .. index .. ")")
  _slotList[index] = createdSlot
end
local SLOT_POSITION = {}
SLOT_POSITION[0] = {
  [0] = {206, 76}
}
SLOT_POSITION[1] = {
  [0] = {84, 198},
  [1] = {327, 198}
}
SLOT_POSITION[2] = {
  [0] = {206, 76},
  [1] = {90, 236},
  [2] = {313, 236}
}
SLOT_POSITION[3] = {
  [0] = {124, 112},
  [1] = {287, 112},
  [2] = {124, 283},
  [3] = {287, 283}
}
SLOT_POSITION[4] = {
  [0] = {206, 76},
  [1] = {94, 156},
  [2] = {317, 156},
  [3] = {124, 283},
  [4] = {287, 283}
}
local _manufactureText = UI.getChildControl(_whiteCircle, "StaticText_CircleName")
_manufactureText:SetShow(false)
local _title_BG = UI.getChildControl(Panel_Manufacture, "Static_TitleBG")
local _circle_BG = UI.getChildControl(Panel_Manufacture, "Static_Circle")
local _uiButtonClose = UI.getChildControl(_title_BG, "Button_Close")
_uiButtonClose:addInputEvent("Mouse_LUp", "Manufacture_Close()")
local _buttonQuestion = UI.getChildControl(_title_BG, "Button_Question")
_buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelManufacture\" )")
_buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelManufacture\", \"true\")")
_buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelManufacture\", \"false\")")
local _uiButtonManufacture = UI.getChildControl(Panel_Manufacture, "Button_Manufacture")
_uiButtonManufacture:addInputEvent("Mouse_LUp", "Manufacture_RepeatAction(false)")
_uiButtonManufacture:addInputEvent("Mouse_On", "Manufacture_Mouse_On()")
local _uiButtonMassManufacture = UI.getChildControl(Panel_Manufacture, "Button_MassManufacture")
_uiButtonMassManufacture:addInputEvent("Mouse_LUp", "Manufacture_RepeatAction(true)")
_uiButtonMassManufacture:addInputEvent("Mouse_On", "Manufacture_Mouse_On()")
_uiButtonMassManufacture:SetShow(false)
local _textDescBG = UI.getChildControl(Panel_Manufacture, "Static_DescBG")
_textDescBG:SetIgnore(true)
local _textDesc = UI.getChildControl(Panel_Manufacture, "StaticText_Desc")
_textDesc:SetIgnore(true)
_textDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
_textDesc:SetText("")
local checkBtn_ShowDetail = UI.getChildControl(Panel_Manufacture, "CheckButton_ShowDetail")
checkBtn_ShowDetail:addInputEvent("Mouse_LUp", "Manufacture_ShowKnowledgeList()")
local _btn_funcBG = UI.getChildControl(Panel_Manufacture, "Static_FrameBG")
local list2 = UI.getChildControl(_btn_funcBG, "List2_Manufacture")
local limitTextTooltip = {}
local IsLimitText = {}
local selectIndex = -1
local Manufacture_Notify = {
  _progress_BG = UI.getChildControl(Panel_Manufacture_Notify, "Static_Progress_BG"),
  _progress_Bar = UI.getChildControl(Panel_Manufacture_Notify, "Progress2_Manufacture"),
  _progress_Text = UI.getChildControl(Panel_Manufacture_Notify, "StaticText_Manufacture_Progress"),
  _progress_Effect = UI.getChildControl(Panel_Manufacture_Notify, "Static_Progress_Effect"),
  _type_Name = UI.getChildControl(Panel_Manufacture_Notify, "StaticText_Manufacture_Type"),
  _result_Title = UI.getChildControl(Panel_Manufacture_Notify, "StaticText_Result_Title"),
  _item_Resource = {},
  _icon_ResourceBG = {},
  _icon_Resource = {},
  _item_Result = {},
  _icon_ResultBG = {},
  _icon_Result = {},
  _templat = {
    _item_Resource = UI.getChildControl(Panel_Manufacture_Notify, "StaticText_ResourceItem"),
    _icon_ResourceBG = UI.getChildControl(Panel_Manufacture_Notify, "Static_ResourceIcon_BG"),
    _icon_Resource = UI.getChildControl(Panel_Manufacture_Notify, "Static_ResourceIcon"),
    _item_Result = UI.getChildControl(Panel_Manufacture_Notify, "StaticText_ResultItem"),
    _icon_ResultBG = UI.getChildControl(Panel_Manufacture_Notify, "Static_ResultIcon_BG"),
    _icon_Result = UI.getChildControl(Panel_Manufacture_Notify, "Static_ResultIcon")
  },
  _data_Resource = {},
  _data_Result = {},
  _gapY = 20,
  _defalutSpanY = 0,
  _failCount = 0,
  _successCount = 0
}
local _defaultMSG1 = UI.getChildControl(_btn_funcBG, "StaticText_DefaultMSG1")
_defaultMSG1:SetShow(false)
_defaultMSG1:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
local _defaultMSG2 = UI.getChildControl(_btn_funcBG, "StaticText_DefaultMSG2")
_defaultMSG2:SetShow(false)
local _uiButtonNote = UI.getChildControl(Panel_Manufacture, "Button_Note")
if isGameTypeKR2() then
  _uiButtonNote:SetShow(false)
end
_uiButtonNote:addInputEvent("Mouse_LUp", "Note_Mouse_LUp()")
_uiButtonNote:addInputEvent("Mouse_On", "Note_Mouse_On()")
local _frameManufactureDesc = UI.getChildControl(_btn_funcBG, "Frame_ManufactureDesc")
local _frameContent = UI.getChildControl(_frameManufactureDesc, "Frame_1_Content")
local _frameScroll = UI.getChildControl(_frameManufactureDesc, "VerticalScroll")
local _uiKnowledgeDesc = UI.getChildControl(_frameContent, "StaticText_KnowledgeDesc")
_uiKnowledgeDesc:SetAutoResize(true)
local _uiKnowledgeIcon = UI.getChildControl(_btn_funcBG, "Static_KnoeledgeIcon")
local _startKnowledgeIndex = 0
local _isMassManufacture = false
local SHAKE_MENTALTHEMEKEY = 30200
local DRY_MENTALTHEMEKEY = 30300
local THINNING_MENTALTHEMEKEY = 30400
local GRIND_MENTALTHEMEKEY = 30500
local HEAT_MENTALTHEMEKEY = 30600
local FIREWOOD_MENTALTHEMEKEY = 30700
local COOK_MENTALTHEMEKEY = 30109
local ALCHEMY_MENTALTHEMEKEY = 31009
local ROYALCOOK_MENTALTHEMEKEY = 30110
local ROYALALCHEMY_MENTALTHEMEKEY = 31012
local GUILDMANUFACTURE_MENTALTHEMEKEY = 31013
local CRAFT_MENTALTHEMEKEY = 30800
local RAINWATER_MENTALTHEMEKEY = 30800
function ManufactureControlInit()
  _frameScroll:SetShow(false)
  local manufactureAction1 = {}
  manufactureAction1._actionName = _ACTIONNAME_SHAKE
  manufactureAction1._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action1")
  manufactureAction1._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_Shake(true)")
  _listAction[0] = manufactureAction1
  local manufactureAction2 = {}
  manufactureAction2._actionName = _ACTIONNAME_GRIND
  manufactureAction2._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action2")
  manufactureAction2._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_Grind(true)")
  _listAction[1] = manufactureAction2
  local manufactureAction3 = {}
  manufactureAction3._actionName = _ACTIONNAME_FIREWOOD
  manufactureAction3._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action3")
  manufactureAction3._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_FireWood(true)")
  _listAction[2] = manufactureAction3
  local manufactureAction4 = {}
  manufactureAction4._actionName = _ACTIONNAME_DRY
  manufactureAction4._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action4")
  manufactureAction4._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_Dry(true)")
  _listAction[3] = manufactureAction4
  local manufactureAction5 = {}
  manufactureAction5._actionName = _ACTIONNAME_THINNING
  manufactureAction5._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action5")
  manufactureAction5._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_Thinning(true)")
  _listAction[4] = manufactureAction5
  local manufactureAction6 = {}
  manufactureAction6._actionName = _ACTIONNAME_HEAT
  manufactureAction6._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action6")
  manufactureAction6._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_Heat(true)")
  _listAction[5] = manufactureAction6
  local manufactureAction7 = {}
  manufactureAction7._actionName = _ACTIONNAME_RAINWATER
  manufactureAction7._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action7")
  manufactureAction7._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_Rainwater(true)")
  _listAction[6] = manufactureAction7
  local manufactureAction8 = {}
  manufactureAction8._actionName = _ACTIONNAME_REPAIR
  manufactureAction8._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_RepairItem")
  manufactureAction8._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_RepairItem(true)")
  _listAction[7] = manufactureAction8
  local manufactureAction9 = {}
  manufactureAction9._actionName = _ACTIONNAME_ALCHEMY
  manufactureAction9._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action9")
  manufactureAction9._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_Alchemy(true)")
  _listAction[8] = manufactureAction9
  local manufactureAction10 = {}
  manufactureAction10._actionName = _ACTIONNAME_COOK
  manufactureAction10._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action10")
  manufactureAction10._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_Cook(true)")
  _listAction[9] = manufactureAction10
  local manufactureAction11 = {}
  manufactureAction11._actionName = _ACTIONNAME_RG_COOK
  manufactureAction11._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action11")
  manufactureAction11._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_RGCook(true)")
  _listAction[10] = manufactureAction11
  local manufactureAction12 = {}
  manufactureAction12._actionName = _ACTIONNAME_RG_ALCHEMY
  manufactureAction12._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action12")
  manufactureAction12._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_RGAlchemy(true)")
  _listAction[11] = manufactureAction12
  local manufactureAction13 = {}
  if contentsOption then
    manufactureAction13._actionName = _ACTIONNAME_GUILDMANUFACTURE
    manufactureAction13._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action13")
    manufactureAction13._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_GuildManufacture(true)")
    _listAction[12] = manufactureAction13
  else
    manufactureAction13._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action13")
    manufactureAction13._radioBtn:SetShow(false)
  end
  local manufactureAction14 = {}
  if enableCraft then
    manufactureAction14._actionName = _ACTIONNAME_CRAFT
    manufactureAction14._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action14")
    manufactureAction14._radioBtn:addInputEvent("Mouse_LUp", "Manufacture_Button_LUp_Craft(true)")
    _listAction[13] = manufactureAction14
  else
    manufactureAction14._radioBtn = UI.getChildControl(Panel_Manufacture, "RadioButton_Action14")
    manufactureAction14._radioBtn:SetShow(false)
  end
end
function ManufactureControlEnable(control, isEnable)
  if true == isEnable then
    control:SetIgnore(false)
    control:SetEnable(true)
    control:SetDisableColor(false)
  else
    control:SetIgnore(false)
    control:SetEnable(false)
    control:SetDisableColor(true)
  end
end
function ManufactureShowAni()
  UIAni.fadeInSCR_Down(Panel_Manufacture)
  _whiteCircle:SetShow(true)
  _whiteCircle:SetAlpha(0)
  UIAni.AlphaAnimation(1, _whiteCircle, 0, 0.2)
  local aniInfo1 = Panel_Manufacture:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_Manufacture:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Manufacture:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Manufacture:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Manufacture:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Manufacture:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function ManufactureHideAni()
  Panel_Manufacture:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Manufacture:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
  local alphaAni = UIAni.AlphaAnimation(0, _whiteCircle, 0, 0.12)
  alphaAni:SetHideAtEnd(true)
end
function Manufacture_SetRadioBtnFontColor(control)
  if control:IsChecked() then
    control:SetFontColor(UI_color.C_FFFFFFFF)
  else
    control:SetFontColor(UI_color.C_FFC4BEBE)
  end
end
function Manufacture_UpdateCheckRadioButton(isClear)
  for i = 0, MAX_ACTION_BTN - 1 do
    if nil ~= isClear and true == isClear then
      _listAction[i]._radioBtn:SetCheck(false)
    end
    Manufacture_SetRadioBtnFontColor(_listAction[i]._radioBtn)
  end
end
function Manufacture_UpdateVisibleRadioButton(installationType)
  if nil ~= installationType and CppEnums.InstallationType.TypeCount ~= installationType then
    local tempActionName = INSTALLATIONTYPE_ACTIONNAME[installationType]
    for i = 0, MAX_ACTION_BTN - 1 do
      if tempActionName == _listAction[i]._actionName then
        local isVisible = isVisibleManufactureAction(_listAction[i]._actionName)
        _listAction[i]._radioBtn:SetShow(isVisible)
      else
        _listAction[i]._radioBtn:SetShow(false)
      end
    end
  else
    for i = 0, MAX_ACTION_BTN - 1 do
      local isVisible = isVisibleManufactureAction(_listAction[i]._actionName)
      _listAction[i]._radioBtn:SetShow(isVisible)
    end
  end
  if not territorySupply then
    _listAction[10]._radioBtn:SetShow(false)
    _listAction[11]._radioBtn:SetShow(false)
  end
  local isNearAnvil = isNearInstallation(CppEnums.InstallationType.eType_Anvil)
  local isNearMortar = true
  local isNearStump = true
  local isNearFireBowl = true
  for i = 0, MAX_ACTION_BTN - 1 do
    if true == _listAction[i]._radioBtn:GetShow() then
      local isEnable = isEnableManufactureAction(_listAction[i]._actionName)
      if _ACTIONNAME_GRIND == _listAction[i]._actionName then
        ManufactureControlEnable(_listAction[i]._radioBtn, isEnable and isNearMortar)
        isEnableMsg[i] = isEnable and isNearMortar and true or false
      elseif _ACTIONNAME_FIREWOOD == _listAction[i]._actionName then
        ManufactureControlEnable(_listAction[i]._radioBtn, isEnable and isNearStump)
        isEnableMsg[i] = isEnable and isNearStump and true or false
      elseif _ACTIONNAME_HEAT == _listAction[i]._actionName then
        ManufactureControlEnable(_listAction[i]._radioBtn, isEnable and isNearFireBowl)
        isEnableMsg[i] = isEnable and isNearFireBowl and true or false
      elseif _ACTIONNAME_REPAIR == _listAction[i]._actionName then
        ManufactureControlEnable(_listAction[i]._radioBtn, isEnable and isNearAnvil)
        isEnableMsg[i] = isEnable and isNearAnvil and true or false
      else
        ManufactureControlEnable(_listAction[i]._radioBtn, isEnable)
        isEnableMsg[i] = true
      end
    end
  end
end
local slideBtnSize = 0
function Manufacture_Show(installationType, materialWhereType, isClear, showType, waypointKey)
  if false == ToClient_IsGrowStepOpen(__eGrowStep_manufacture) then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if 0 ~= ToClient_GetMyTeamNoLocalWar() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_LOCALWAR_ALERT"))
    return
  end
  if selfPlayerIsInCompetitionArea() then
    return
  end
  if Panel_AlchemyFigureHead:GetShow() then
    FGlobal_AlchemyFigureHead_Close()
  end
  if Panel_AlchemyStone:GetShow() then
    FGlobal_AlchemyStone_Close()
  end
  if Panel_DyePalette:GetShow() then
    FGlobal_DyePalette_Close()
  end
  if false == _ContentsGroup_RenewUI and Panel_Equipment:GetShow() then
    EquipmentWindow_Close()
  end
  if true == Panel_Window_ItemMarket_RegistItem:GetShow() then
    FGlobal_ItemMarketRegistItem_Close()
  end
  ClothInventory_Close()
  local noticeText = ""
  invenShow = showType
  StopManufactureAction()
  Manufacture_Reset_ContinueGrindJewel()
  if nil == materialWhereType then
    return
  end
  if materialWhereType ~= CppEnums.ItemWhereType.eInventory and materialWhereType ~= CppEnums.ItemWhereType.eCashInventory and materialWhereType ~= CppEnums.ItemWhereType.eWarehouse then
    return
  end
  materialItemWhereType = materialWhereType
  if materialWhereType == CppEnums.ItemWhereType.eWarehouse and nil == waypointKey then
    return
  end
  if CppEnums.ItemWhereType.eInventory == materialWhereType or CppEnums.ItemWhereType.eCashInventory == materialWhereType then
    InventoryWindow_Show()
    Inventory_SetFunctor(Manufacture_SelectCheck1, Manufacture_SelectCheck2, Manufacture_Close, nil)
  else
    waypointKey_ByWareHouse = waypointKey
    InventoryWindow_Close()
    Warehouse_OpenPanelFromManufacture()
    Warehouse_SetFunctor(nil, nil)
  end
  ReconstructionAlchemyKnowledge()
  Panel_Manufacture:SetShow(true, true)
  if Panel_Window_Inventory:IsUISubApp() then
    Panel_Manufacture:OpenUISubApp()
  end
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  Manufacture_UpdateVisibleRadioButton(installationType)
  if nil ~= installationType then
    local isEnable = false
    if installationType == CppEnums.InstallationType.eType_Mortar then
      isEnable = isEnableManufactureAction(_listAction[1]._actionName)
      _listAction[1]._radioBtn:SetCheck(true)
      Manufacture_Button_LUp_Grind(false)
      if not isEnable then
        _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_NEED_KNOWLEDGE_MORTAR"))
      end
    elseif installationType == CppEnums.InstallationType.eType_Anvil then
      isEnable = isEnableManufactureAction(_listAction[7]._actionName)
      _listAction[7]._radioBtn:SetCheck(true)
      Manufacture_Button_LUp_RepairItem(true)
      if not isEnable then
        _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_NEED_KNOWLEDGE_ANVIL"))
      end
    elseif installationType == CppEnums.InstallationType.eType_Stump then
      isEnable = isEnableManufactureAction(_listAction[2]._actionName)
      _listAction[2]._radioBtn:SetCheck(true)
      Manufacture_Button_LUp_FireWood(false)
      if not isEnable then
        _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_NEED_KNOWLEDGE_STUMP"))
      end
    elseif installationType == CppEnums.InstallationType.eType_FireBowl then
      isEnable = isEnableManufactureAction(_listAction[5]._actionName)
      _listAction[5]._radioBtn:SetCheck(true)
      Manufacture_Button_LUp_Heat(false)
      if not isEnable then
        _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_NEED_KNOWLEDGE_FIREBOWL"))
      end
    else
      _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_SELECT_TYPE"))
    end
    Manufacture_UpdateCheckRadioButton()
    if isEnable then
    else
    end
    _uiButtonManufacture:SetShow(isEnable)
  else
    Manufacture_UpdateCheckRadioButton(true)
    ManufactureKnowledge_ShowList(true)
    _uiButtonManufacture:SetShow(false)
    _listAction[0]._radioBtn:SetCheck(true)
    Manufacture_Button_LUp_Shake(true)
    Manufacture_RefreshIsMassCheckButton(0)
  end
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if contentsOption then
    if nil ~= houseWrapper then
      local isMyGuildHouse = houseWrapper:isMyGuildHouse()
      if true == isMyGuildHouse then
        _listAction[12]._radioBtn:SetIgnore(false)
        _listAction[12]._radioBtn:SetMonoTone(false)
      else
        _listAction[12]._radioBtn:SetIgnore(true)
        _listAction[12]._radioBtn:SetMonoTone(true)
      end
    else
      _listAction[12]._radioBtn:SetIgnore(true)
      _listAction[12]._radioBtn:SetMonoTone(true)
    end
  end
  _frameManufactureDesc:UpdateContentPos()
end
function Manufacture_Close()
  list2:getElementManager():clearKey()
  selectIndex = -1
  Panel_Manufacture:SetShow(false, false)
  Panel_Manufacture:CloseUISubApp()
  Inventory_SetFunctor(nil, nil, nil, nil)
  Warehouse_SetFunctor(nil, nil)
  if true == invenShow and not FGlobal_InventoryIsClosing() then
    if true == _ContentsGroup_RenewUI then
      Panel_Equipment:SetShow(true)
    end
    Panel_Window_Inventory:SetShow(true)
    invenShow = false
  else
    EquipmentWindow_Close()
    InventoryWindow_Close()
    ClothInventory_Close()
    HelpMessageQuestion_Out()
  end
  TooltipSimple_Hide()
  audioPostEvent_SystemUi(1, 25)
end
function Manufacture_ClearMaterial()
  audioPostEvent_SystemUi(10, 3)
  _materialSlotNoList = {
    [0] = _defaultSlotNo,
    _defaultSlotNo,
    _defaultSlotNo,
    _defaultSlotNo,
    _defaultSlotNo
  }
  _materialSlotNoListItemIn = {
    [0] = false,
    false,
    false,
    false
  }
  _actionIndex = -1
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _usingItemSlotCount = 0
  for ii = 0, _slotCount - 1 do
    _pointList[ii]:SetShow(false)
  end
  _manufactureText:SetText("")
  _manufactureText:SetShow(false)
  _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_SELECT_TYPE"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateSlot()
end
function Manufacture_SelectCheck1()
  return true
end
function Manufacture_SelectCheck2()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_SELECTCHECK2"))
end
function Manufacture_PushItemFromInventory(slotNo, itemWrapper, count, inventoryType)
  if checkManufactureAction() and (0 == #noneStackItemList or nil == #noneStackItemList) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_DONT_CHANGE_ACTION"))
    return
  end
  local inventory = getSelfPlayer():get():getInventory()
  local invenSize = inventory:size()
  for ii = 0, _usingItemSlotCount - 1 do
    if slotNo == _materialSlotNoList[ii] then
      break
    end
    if _defaultSlotNo == _materialSlotNoList[ii] then
      _materialSlotNoList[ii] = slotNo
      audioPostEvent_SystemUi(13, 8)
      break
    end
  end
  materialItemWhereType = inventoryType
  if (0 == #noneStackItemList or nil == #noneStackItemList) and (true ~= _materialSlotNoListItemIn[0] or true ~= _materialSlotNoListItemIn[1] or true ~= _materialSlotNoListItemIn[2] or true ~= _materialSlotNoListItemIn[3]) then
    noneStackItemList = Array.new()
    local selectedItemWrapper = getInventoryItemByType(inventoryType, slotNo)
    local selectedItemKey = selectedItemWrapper:get():getKey():getItemKey()
    local inventory = Inventory_GetCurrentInventory()
    local curentInventoryType = Inventory_GetCurrentInventoryType()
    local invenMaxSize = inventory:sizeXXX()
    for ii = 2, invenMaxSize - 1 do
      local itemWrapper = getInventoryItemByType(inventoryType, ii)
      if nil ~= itemWrapper then
        local itemKey = itemWrapper:get():getKey():getItemKey()
        if selectedItemKey == itemKey and not selectedItemWrapper:getStaticStatus():isStackable() and not itemWrapper:isEnchanted() and slotNo ~= ii and false == ToClient_Inventory_CheckItemLock(ii, inventoryType) then
          noneStackItemList:push_back(ii)
        end
      end
    end
    if #noneStackItemList > 0 then
      noneStackItem_ChkBtn:SetCheck(false)
      noneStackItem_ChkBtn:SetShow(true)
    end
  end
  Manufacture_UpdateSlot()
end
function Manufacture_PushItemFromWarehouse(slotNo, itemWrapper, count)
  if checkManufactureAction() and (0 == #noneStackItemList or nil == #noneStackItemList) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_DONT_CHANGE_ACTION"))
    return
  end
  for ii = 0, _usingItemSlotCount - 1 do
    if slotNo == _materialSlotNoList[ii] then
      break
    end
    if _defaultSlotNo == _materialSlotNoList[ii] then
      _materialSlotNoList[ii] = slotNo
      audioPostEvent_SystemUi(13, 8)
      break
    end
  end
  Manufacture_UpdateSlotWarehouse()
  Manufacture_HasNoneStackItem(slotNo)
end
function Manufacture_HasNoneStackItem(slotNo)
  hasNoneStackItem = false
  selectedWarehouseItemSlotNo = slotNo
  local warehouseWrapper = warehouse_get(waypointKey_ByWareHouse)
  local useMaxCount = warehouseWrapper:getUseMaxCount()
  local selectedItemWrapper = warehouseWrapper:getItem(slotNo)
  selectedWarehouseItemKey = selectedItemWrapper:get():getKey():getItemKey()
  local hasNoneStackItemCount = 0
  for ii = 1, useMaxCount - 1 do
    local itemWrapper = warehouseWrapper:getItem(ii)
    if nil ~= itemWrapper then
      local itemKey = itemWrapper:get():getKey():getItemKey()
      if selectedWarehouseItemKey == itemKey and not selectedItemWrapper:getStaticStatus():isStackable() and slotNo ~= ii then
        hasNoneStackItemCount = hasNoneStackItemCount + 1
      end
    end
  end
  if hasNoneStackItemCount > 0 then
    hasNoneStackItem = true
    noneStackItem_ChkBtn:SetCheck(false)
    noneStackItem_ChkBtn:SetShow(true)
  end
end
function Manufacture_GetNextNoneStackItemSlotNo_ByWarehouse()
  local warehouseWrapper = warehouse_get(waypointKey_ByWareHouse)
  local useMaxCount = warehouseWrapper:getUseMaxCount()
  for ii = 1, useMaxCount - 1 do
    local itemWrapper = warehouseWrapper:getItem(ii)
    if nil ~= itemWrapper then
      local itemKey = itemWrapper:get():getKey():getItemKey()
      if selectedWarehouseItemKey == itemKey then
        targetWarehouseSlotNo = ii
        hasNoneStackItem = true
        break
      end
    end
  end
  return hasNoneStackItem
end
function Manufacture_ShowPointEffect()
  for ii = 0, _slotCount - 1 do
    if ii < _usingItemSlotCount then
      _pointList[ii]:SetShow(true)
      _pointList[ii]:AddEffect("fUI_Light", true, 0, 0)
    else
      _pointList[ii]:SetShow(false)
    end
  end
end
function Manufacture_UpdateSlotPos()
  local posIndex = _usingItemSlotCount - 1
  if posIndex < 0 then
    return
  end
  local posArray = SLOT_POSITION[posIndex]
  for ii = 0, posIndex do
    local pos = posArray[ii]
    _pointList[ii]:SetPosX(pos[1])
    _pointList[ii]:SetPosY(pos[2])
  end
end
function Manufacture_UpdateSlotWarehouse()
  _whiteCircle:EraseAllEffect()
  local warehouseSize = 0
  local warehouseWrapper = Warehouse_GetWarehouseWarpper()
  if nil == warehouseWrapper then
    return
  end
  warehouseSize = warehouseWrapper:getUseMaxCount()
  for ii = 0, _slotCount - 1 do
    _slotList[ii].icon:SetShow(false)
    _slotList[ii].icon:addInputEvent("Mouse_On", "")
    _slotList[ii].icon:addInputEvent("Mouse_Out", "")
    if nil ~= _materialSlotNoList[ii] and warehouseSize >= _materialSlotNoList[ii] then
      local itemWrapper = warehouseWrapper:getItem(_materialSlotNoList[ii])
      if nil ~= itemWrapper then
        _slotList[ii]:setItemByStaticStatus(itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64())
        _slotList[ii].icon:SetShow(true)
        _slotList[ii].icon:AddEffect("fUI_ItemInstall_Produce", false, 0, 0)
        _slotList[ii].icon:addInputEvent("Mouse_On", "Material_Mouse_On( " .. ii .. " )")
        _slotList[ii].icon:addInputEvent("Mouse_Out", "Material_Mouse_Out( " .. ii .. " )")
        _whiteCircle:AddEffect("UI_ItemInstall_ProduceRing", false, 0, 0)
        _materialSlotNoListItemIn[ii] = true
      else
        _materialSlotNoList[ii] = _defaultSlotNo
        _materialSlotNoListItemIn[ii] = false
      end
    end
  end
  local isEnable = false
  for i = 0, MAX_ACTION_BTN - 1 do
    if true == _listAction[i]._radioBtn:IsCheck() then
      isEnable = true
    end
  end
  _uiButtonManufacture:SetShow(isEnable)
  Warehouse_updateSlotData()
end
function Manufacture_UpdateSlot()
  _whiteCircle:EraseAllEffect()
  local inventory = Inventory_GetCurrentInventory()
  if nil == inventory then
    return
  end
  local invenSize = inventory:size()
  for ii = 0, _slotCount - 1 do
    _slotList[ii].icon:SetShow(false)
    _slotList[ii].icon:addInputEvent("Mouse_On", "")
    _slotList[ii].icon:addInputEvent("Mouse_Out", "")
    if nil ~= _materialSlotNoList[ii] and invenSize >= _materialSlotNoList[ii] then
      local itemWrapper
      if CppEnums.ItemWhereType.eWarehouse == materialItemWhereType then
        itemWrapper = Warehouse_GetWarehouseWarpper():getItem(_materialSlotNoList[ii])
      else
        local curentInventoryType = Inventory_GetCurrentInventoryType()
        itemWrapper = getInventoryItemByType(curentInventoryType, _materialSlotNoList[ii])
      end
      if nil ~= itemWrapper then
        _slotList[ii]:setItemByStaticStatus(itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64())
        _slotList[ii].icon:SetShow(true)
        _slotList[ii].icon:AddEffect("fUI_ItemInstall_Produce", false, 0, 0)
        _slotList[ii].icon:addInputEvent("Mouse_On", "Material_Mouse_On( " .. ii .. " )")
        _slotList[ii].icon:addInputEvent("Mouse_Out", "Material_Mouse_Out( " .. ii .. " )")
        _whiteCircle:AddEffect("UI_ItemInstall_ProduceRing", false, 0, 0)
        _materialSlotNoListItemIn[ii] = true
        local isStack = itemWrapper:getStaticStatus():isStackable()
        if isStack then
          noneStackItem_ChkBtn:SetCheck(false)
          noneStackItem_ChkBtn:SetShow(false)
        end
      else
        _materialSlotNoList[ii] = _defaultSlotNo
        _materialSlotNoListItemIn[ii] = false
      end
    end
  end
  local isEnable = false
  for i = 0, MAX_ACTION_BTN - 1 do
    if true == _listAction[i]._radioBtn:IsCheck() then
      isEnable = true
    end
  end
  _uiButtonManufacture:SetShow(isEnable)
  Inventory_updateSlotData()
end
function Manufacture_Response()
  if _ContentsGroup_RenewUI_Manufacture then
    return
  end
  local _uiMode = GetUIMode()
  if nil ~= #noneStackItemList and #noneStackItemList > 0 and true == noneStackItemCheck then
    return
  end
  if _uiMode == Defines.UIMode.eUIMode_Default then
    Manufacture_Show(nil, materialItemWhereType, true)
  end
end
function Manufacture_RepeatManufacture()
  if -1 == _actionIndex then
    return
  end
  if 0 == _actionIndex then
    Manufacture_Button_LUp_Shake(true)
  elseif 1 == _actionIndex then
    Manufacture_Button_LUp_Grind(true)
  elseif 2 == _actionIndex then
    Manufacture_Button_LUp_FireWood(true)
  elseif 3 == _actionIndex then
    Manufacture_Button_LUp_Dry(true)
  elseif 4 == _actionIndex then
    Manufacture_Button_LUp_Thinning(true)
  elseif 5 == _actionIndex then
    Manufacture_Button_LUp_Heat(true)
  elseif 6 == _actionIndex then
    Manufacture_Button_LUp_Rainwater(true)
  elseif 7 == _actionIndex then
    Manufacture_Button_LUp_RepairItem(true)
  elseif 8 == _actionIndex then
    Manufacture_Button_LUp_Alchemy(true)
  elseif 9 == _actionIndex then
    Manufacture_Button_LUp_Cook(true)
  elseif 10 == _actionIndex then
    Manufacture_Button_LUp_RGCook(true)
  elseif 11 == _actionIndex then
    Manufacture_Button_LUp_RGAlchemy(true)
  elseif 12 == _actionIndex then
    Manufacture_Button_LUp_GuildManufacture(true)
  elseif 13 == _actionIndex then
    Manufacture_Button_LUp_Craft(true)
  end
end
function Manufacture_RefreshIsMassCheckButton(actionIndex)
  if true == _ContentsGroup_LifeStatManufacturing then
    local enableMassActionIndex = actionIndex >= 0 and actionIndex <= 5
    local isManufactureMassItemEquip = false
    local itemWrapper = ToClient_getEquipmentItem(CppEnums.EquipSlotNoClient.eEquipSlotNoSubTool)
    if itemWrapper ~= nil then
      local itemSSW = itemWrapper:getStaticStatus()
      if __ePlayerLifeStatType_Manufacture == itemSSW:getLifeStatMainType() and actionIndex + 1 == itemSSW:getLifeStatSubType() then
        isManufactureMassItemEquip = true
      end
    end
    if true == enableMassActionIndex and true == isManufactureMassItemEquip then
      Manufacture_SetShowMassManufacture(true)
    else
      Manufacture_SetShowMassManufacture(false)
    end
  else
    Manufacture_SetShowMassManufacture(false)
  end
end
function Manufacture_ContinueGrindJewel()
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    if nil ~= #noneStackItemList and #noneStackItemList > 0 and true == noneStackItemCheck then
      Manufacture_RepeatManufacture()
      local nextSlotNo = noneStackItemList[1]
      local curentInventoryType = Inventory_GetCurrentInventoryType()
      local itemWrapper = getInventoryItemByType(curentInventoryType, nextSlotNo)
      if nil == itemWrapper then
        return
      end
      local itemCount = itemWrapper:get():getCount_s64()
      Manufacture_PushItemFromInventory(nextSlotNo, itemWrapper, itemCount, curentInventoryType)
      Manufacture_Mouse_LUp()
      noneStackItemList:pop_front()
    end
  else
    local hasNext = Manufacture_GetNextNoneStackItemSlotNo_ByWarehouse()
    if true == hasNext and true == hasNoneStackItem and true == noneStackItemCheck then
      local warehouseWrapper = warehouse_get(waypointKey_ByWareHouse)
      if nil == warehouseWrapper then
        return
      end
      local itemWrapper = warehouseWrapper:getItem(targetWarehouseSlotNo)
      if nil == itemWrapper then
        return
      end
      Manufacture_RepeatManufacture()
      Manufacture_PushItemFromWarehouse(targetWarehouseSlotNo, itemWrapper, 1)
      Manufacture_Mouse_LUp()
    end
  end
end
local function checkManufactureFailCount(currentFailCount)
  local defaultFailCount = 30
  if false == _isMassManufacture or _actionIndex < 0 then
    if currentFailCount > defaultFailCount then
      return true
    else
      return false
    end
  else
    return (ToClient_CheckIsManufactureFail(_actionIndex + 1, defaultFailCount, currentFailCount))
  end
end
function Manufacture_ResponseResultItem(itemDynamicListWrapper, failReason)
  if _ContentsGroup_RenewUI_Manufacture then
    return
  end
  local size = itemDynamicListWrapper:getSize()
  if size > 0 then
    Manufacture_Notify._failCount = 0
    Manufacture_Notify._successCount = Manufacture_Notify._successCount + 1
    for index = 0, size - 1 do
      local itemDynamicInformationWrapper = itemDynamicListWrapper:getElement(index)
      local ItemEnchantStaticStatusWrapper = itemDynamicInformationWrapper:getStaticStatus()
      local itemKey = ItemEnchantStaticStatusWrapper:get()._key
      local s64_stackCount = Int64toInt32(itemDynamicInformationWrapper:getCount_s64())
      local idx
      for key, value in pairs(Manufacture_Notify._data_Result) do
        if value._key:getItemKey() == itemKey:getItemKey() then
          idx = key
        end
      end
      if nil == idx then
        idx = #Manufacture_Notify._data_Result + 1
        Manufacture_Notify._data_Result[idx] = {}
        Manufacture_Notify._data_Result[idx]._key = itemKey
        Manufacture_Notify._data_Result[idx]._name = ItemEnchantStaticStatusWrapper:getName()
        Manufacture_Notify._data_Result[idx]._iconPath = "Icon/" .. ItemEnchantStaticStatusWrapper:getIconPath()
        Manufacture_Notify._data_Result[idx]._currentCnt = s64_stackCount
      else
        Manufacture_Notify._data_Result[idx]._currentCnt = Manufacture_Notify._data_Result[idx]._currentCnt + s64_stackCount
      end
    end
    for key, value in pairs(Manufacture_Notify._data_Resource) do
      local itemWrapper
      local count = 0
      if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
        local curentInventoryType = Inventory_GetCurrentInventoryType()
        itemWrapper = getInventoryItemByType(curentInventoryType, value._slotNo)
      else
        local warehouseWrapper = warehouse_get(waypointKey_ByWareHouse)
        itemWrapper = warehouseWrapper:getItem(value._slotNo)
      end
      if nil ~= itemWrapper then
        local itemStaticWrapper = itemWrapper:getStaticStatus()
        count = Int64toInt32(itemWrapper:get():getCount_s64())
      end
      value._currentCnt = count
    end
    if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
      if nil ~= #noneStackItemList and #noneStackItemList > 0 and true == noneStackItemCheck then
        StopManufactureAction()
        luaTimer_AddEvent(Manufacture_ContinueGrindJewel, 500, false, 0)
      else
        if noneStackItemCheck then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_COMPLETE_REPEAT"))
        end
        Manufacture_Reset_ContinueGrindJewel()
      end
      Manufacture_Progress_Update(materialItemWhereType)
    else
      if true == hasNoneStackItem then
        StopManufactureAction()
        luaTimer_AddEvent(Manufacture_ContinueGrindJewel, 500, false, 0)
      else
        if noneStackItemCheck then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_COMPLETE_REPEAT"))
        end
        Manufacture_Reset_ContinueGrindJewel()
      end
      Manufacture_Progress_Update(materialItemWhereType)
    end
  else
    local message
    if 0 == failReason then
    elseif 1 == failReason then
      message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_FAILREASON1")
      Manufacture_Response()
    elseif 2 == failReason then
      message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_FAILREASON2")
      Manufacture_ClearValues()
      Manufacture_Response()
    elseif 3 == failReason then
      message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_FAILREASON3")
    elseif 4 == failReason then
      message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_FAILREASON4")
    elseif 5 == failReason then
      message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_FAILREASON5")
    elseif 6 == failReason then
    elseif 7 == failReason then
      message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_FAILREASON7")
    elseif 8 == failReason then
      message = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_INVENTORY_LEAST_ONE")
      Manufacture_ClearValues()
      Manufacture_Response()
    elseif 9 == failReason then
      message = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_INVENTORY_WEIGHTOVER")
      Manufacture_ClearValues()
      Manufacture_Response()
    elseif 10 == failReason then
      message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WP_IS_LACK")
      Manufacture_ClearValues()
      Manufacture_Response()
    elseif 11 == failReason then
      message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_FAILREASON_MASS")
    end
    if 6 ~= failReason and nil ~= message then
      Proc_ShowMessage_Ack(message)
    end
    Manufacture_Notify._failCount = Manufacture_Notify._failCount + 1
    local isFailManufacture = checkManufactureFailCount(Manufacture_Notify._failCount)
    if true == isFailManufacture then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_DONT_THIS_WAY"))
      Manufacture_Notify._failCount = 0
      Manufacture_Response()
    end
  end
end
function Manufacture_Reset_ContinueGrindJewel()
  noneStackItemList = Array.new()
  noneStackItemCheck = false
  hasNoneStackItem = false
  selectedWarehouseItemKey = -1
  selectedWarehouseItemSlotNo = -1
  targetWarehouseSlotNo = -1
  noneStackItem_ChkBtn:SetCheck(false)
  noneStackItem_ChkBtn:SetShow(false)
end
function Manufacture_ToggleWindow(installationType, isClear)
  if Panel_Manufacture:GetShow() then
    Manufacture_Close()
  else
    InventoryWindow_Show()
    local curentInventoryType = Inventory_GetCurrentInventoryType()
    Manufacture_Show(installationType, curentInventoryType, isClear)
  end
end
function Manufacture_Mouse_LUp()
  if _actionIndex == -1 then
    return
  end
  if true == ToClient_IsInClientInstanceDungeon() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantDoClientDungeon"))
    return
  end
  if _listAction[3]._radioBtn:IsCheck() then
    local terraintype = selfPlayerNaviMaterial()
    local onBoat = selfplayerIsCurrentlyOnShip()
    if (2 == terraintype or 4 == terraintype or 6 == terraintype or 8 == terraintype or getSelfPlayer():getCurrentRegionInfo():isOcean()) and not onBoat then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_DONT_WARTER_ACK"))
      return
    end
  end
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper and 12 == _actionIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_INNTER_GUILDHOUSE_USE"))
    return
  end
  local inventory = getSelfPlayer():get():getInventory()
  local cashInventory = getSelfPlayer():get():getInventoryByType(CppEnums.ItemWhereType.eCashInventory)
  local freeCount = inventory:getFreeCount()
  local size = 0
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType then
    size = inventory:size()
  elseif CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    size = cashInventory:size()
  else
    local warehouseWrapper = warehouse_get(waypointKey_ByWareHouse)
    size = warehouseWrapper:getSize()
  end
  if freeCount < 2 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_INVENTORY_LEAST_ONE"))
    return
  end
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local s64_allWeight = selfPlayer:getCurrentWeight_s64()
  local s64_maxWeight = selfPlayer:getPossessableWeight_s64()
  local allWeight = Int64toInt32(s64_allWeight) / 10000
  local maxWeight = Int64toInt32(s64_maxWeight) / 10000
  local playerWeightPercent = allWeight / maxWeight * 100
  local s64_moneyWeight = selfPlayer:getInventory():getMoneyWeight_s64()
  local s64_equipmentWeight = selfPlayer:getEquipment():getWeight_s64()
  local s64_allWeight = selfPlayer:getCurrentWeight_s64()
  local s64_maxWeight = selfPlayer:getPossessableWeight_s64()
  local moneyWeight = Int64toInt32(s64_moneyWeight) / 10000
  local equipmentWeight = Int64toInt32(s64_equipmentWeight) / 10000
  local allWeight = Int64toInt32(s64_allWeight) / 10000
  local maxWeight = Int64toInt32(s64_maxWeight) / 10000
  local invenWeight = allWeight - equipmentWeight - moneyWeight
  local playerFairyWeight = ToClient_getDecreaseWeightByFairy() / 10000
  if playerFairyWeight < 0 then
    playerFairyWeight = 0
  end
  local totalWeight = allWeight / maxWeight * 100
  if totalWeight >= 100 + playerFairyWeight then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_INVENTORY_WEIGHTOVER"))
    return
  end
  local sum_MaterialSlot = {}
  Manufacture_Notify:clear()
  local doHaveNonStackableItem = false
  for index = 0, _usingItemSlotCount - 1 do
    if true == _materialSlotNoListItemIn[index] and size >= _materialSlotNoList[index] then
      sum_MaterialSlot[#sum_MaterialSlot + 1] = _materialSlotNoList[index]
      local itemWrapper
      if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
        local curentInventoryType = Inventory_GetCurrentInventoryType()
        itemWrapper = getInventoryItemByType(curentInventoryType, _materialSlotNoList[index])
      else
        local warehouseWrapper = warehouse_get(waypointKey_ByWareHouse)
        itemWrapper = warehouseWrapper:getItem(_materialSlotNoList[index])
      end
      local itemStaticWrapper = itemWrapper:getStaticStatus()
      local idx = #Manufacture_Notify._data_Resource + 1
      Manufacture_Notify._data_Resource[idx] = {}
      Manufacture_Notify._data_Resource[idx]._slotNo = _materialSlotNoList[index]
      Manufacture_Notify._data_Resource[idx]._key = itemStaticWrapper:get()._key
      Manufacture_Notify._data_Resource[idx]._name = itemStaticWrapper:getName()
      Manufacture_Notify._data_Resource[idx]._iconPath = "Icon/" .. itemStaticWrapper:getIconPath()
      Manufacture_Notify._data_Resource[idx]._originalCnt = Int64toInt32(itemWrapper:get():getCount_s64())
      Manufacture_Notify._data_Resource[idx]._currentCnt = Manufacture_Notify._data_Resource[idx]._originalCnt
      if false == itemStaticWrapper:isStackable() then
        doHaveNonStackableItem = true
      end
    end
  end
  if true == _isMassManufacture and true == doHaveNonStackableItem then
    local message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_MASSMANUFACTURE_BTN_TOOLTIP")
    Proc_ShowMessage_Ack(message)
    return
  end
  if #sum_MaterialSlot == 0 then
    if _actionIndex == 0 or _actionIndex == 5 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_SLOT_LEAST_ONE"))
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_SLOT_EMPTY"))
    end
    return
  end
  Panel_Window_Warehouse:SetShow(false)
  _whiteCircle:AddEffect("UI_ItemInstall_Spin", true, 0, 0)
  if _actionIndex == 7 then
    for key, value in pairs(sum_MaterialSlot) do
      local rv = repair_RepairItemBySelf(value)
      if rv == 0 then
        break
      end
    end
  else
    if CppEnums.ItemWhereType.eWarehouse == materialItemWhereType then
      if true == _ContentsGroup_RenewUI_Dailog then
        PaGlobalFunc_MainDialog_Hide()
      elseif false == _ContentsGroup_NewUI_Dialog_All then
        FGlobal_HideDialog()
      else
        PaGlobalFunc_DialogMain_All_Close()
      end
    end
    if true == _ContentsGroup_LifeStatManufacturing and true == _isMassManufacture then
      CURRENT_ACTIONNAME = _listAction[_actionIndex]._actionName
      CURRENT_ACTIONNAME = CURRENT_ACTIONNAME .. "_MASS"
      Manufacture_Do(_usingInstallationType, CURRENT_ACTIONNAME, materialItemWhereType, _materialSlotNoList[0], _materialSlotNoList[1], _materialSlotNoList[2], _materialSlotNoList[3], _materialSlotNoList[4])
    else
      CURRENT_ACTIONNAME = _listAction[_actionIndex]._actionName
      local rv = Manufacture_Do(_usingInstallationType, CURRENT_ACTIONNAME, materialItemWhereType, _materialSlotNoList[0], _materialSlotNoList[1], _materialSlotNoList[2], _materialSlotNoList[3], _materialSlotNoList[4])
    end
  end
  audioPostEvent_SystemUi(0, 0)
  Manufacture_Notify._failCount = 0
  Manufacture_Notify._successCount = 0
  Manufacture_Close()
  Interaction_Close()
  audioPostEvent_SystemUi(13, 11)
end
function Manufacture_Mouse_On()
  audioPostEvent_SystemUi(1, 13)
end
function Manufacture_UpdateRepairTime()
  local repairTime = repair_getRepairTime(_materialSlotNoList[0])
  if repairTime > toUint64(0, 0) then
    local tempString = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_REPAIR_TOTAL_TIME") .. " : " .. convertStringFromMillisecondtime(repairTime)
    _manufactureText:SetText(tempString)
  end
end
function Material_Mouse_RUp(index)
  if Panel_Win_System:GetShow() then
    return
  end
  audioPostEvent_SystemUi(13, 12)
  StopManufactureAction()
  noneStackItemList = Array.new()
  noneStackItemCheck = false
  hasNoneStackItem = false
  selectedWarehouseItemKey = -1
  selectedWarehouseItemSlotNo = -1
  targetWarehouseSlotNo = -1
  noneStackItem_ChkBtn:SetCheck(false)
  noneStackItem_ChkBtn:SetShow(false)
  if index < _usingItemSlotCount then
    _materialSlotNoList[index] = _defaultSlotNo
    _materialSlotNoListItemIn[index] = false
    for ii = index, _usingItemSlotCount - 1 - 1 do
      if _defaultSlotNo == _materialSlotNoList[ii] and _defaultSlotNo ~= _materialSlotNoList[ii + 1] then
        _materialSlotNoList[ii] = _materialSlotNoList[ii + 1]
        _materialSlotNoList[ii + 1] = _defaultSlotNo
      else
        break
      end
    end
  end
  Panel_Tooltip_Item_hideTooltip()
  if materialItemWhereType == CppEnums.ItemWhereType.eInventory or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Manufacture_UpdateSlot()
  else
    Manufacture_UpdateSlotWarehouse()
  end
end
function Material_Mouse_On(index)
  local itemWrapper
  if materialItemWhereType == CppEnums.ItemWhereType.eInventory or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    local curentInventoryType = Inventory_GetCurrentInventoryType()
    itemWrapper = getInventoryItemByType(curentInventoryType, _materialSlotNoList[index])
  else
    itemWrapper = Warehouse_GetWarehouseWarpper():getItem(_materialSlotNoList[index])
  end
  local slot = _slotList[index].icon
  Panel_Tooltip_Item_Show(itemWrapper, slot, false, true, nil, nil, nil)
end
function Material_Mouse_Out(index)
  Panel_Tooltip_Item_hideTooltip()
end
function Manufacture_Button_LUp_Shake(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  audioPostEvent_SystemUi(13, 10)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 0
  _usingItemSlotCount = 2
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_SHAKE"))
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_SHAKE"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateCheckRadioButton()
  _startKnowledgeIndex = 0
  ReconstructionAlchemyKnowledge(SHAKE_MENTALTHEMEKEY)
  ManufactureKnowledge_UpdateList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_DEFAULT_DESC"))
  Material_Update(_usingItemSlotCount)
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_Button_LUp_Grind(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  audioPostEvent_SystemUi(13, 2)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 1
  _usingItemSlotCount = 2
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_GRIND"))
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_GRIND"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateCheckRadioButton()
  _startKnowledgeIndex = 0
  ReconstructionAlchemyKnowledge(GRIND_MENTALTHEMEKEY)
  ManufactureKnowledge_UpdateList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_DEFAULT_DESC"))
  Material_Update(_usingItemSlotCount)
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_Button_LUp_FireWood(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  audioPostEvent_SystemUi(13, 0)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 2
  _usingItemSlotCount = 1
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_WOODSPLITTING"))
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_FIREWOOD"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateCheckRadioButton()
  _startKnowledgeIndex = 0
  ReconstructionAlchemyKnowledge(FIREWOOD_MENTALTHEMEKEY)
  ManufactureKnowledge_UpdateList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_DEFAULT_DESC"))
  Material_Update(_usingItemSlotCount)
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_Button_LUp_Dry(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  audioPostEvent_SystemUi(13, 1)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 3
  _usingItemSlotCount = 1
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_DRY"))
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_DRY"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateCheckRadioButton()
  _startKnowledgeIndex = 0
  ReconstructionAlchemyKnowledge(DRY_MENTALTHEMEKEY)
  ManufactureKnowledge_UpdateList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_DEFAULT_DESC"))
  Material_Update(_usingItemSlotCount)
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_Button_LUp_Thinning(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  audioPostEvent_SystemUi(13, 3)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 4
  _usingItemSlotCount = 1
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_THINNING"))
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_THINNING"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateCheckRadioButton()
  _startKnowledgeIndex = 0
  ReconstructionAlchemyKnowledge(THINNING_MENTALTHEMEKEY)
  ManufactureKnowledge_UpdateList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_DEFAULT_DESC"))
  Material_Update(_usingItemSlotCount)
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_Button_LUp_Heat(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  audioPostEvent_SystemUi(13, 4)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 5
  if true == _ContentsGroup_BlackStarWeapon then
    _usingItemSlotCount = 3
  else
    _usingItemSlotCount = 2
  end
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_HEATING"))
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_HEAT"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateCheckRadioButton()
  _startKnowledgeIndex = 0
  ReconstructionAlchemyKnowledge(HEAT_MENTALTHEMEKEY)
  ManufactureKnowledge_UpdateList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_KNOWLEDGE_DESC"))
  Material_Update(_usingItemSlotCount)
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_Button_LUp_Rainwater(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  audioPostEvent_SystemUi(0, 0)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 6
  _usingItemSlotCount = 1
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_RAINWATER"))
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_RAINWATER"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateCheckRadioButton()
  _startKnowledgeIndex = 0
  ReconstructionAlchemyKnowledge(RAINWATER_MENTALTHEMEKEY)
  ManufactureKnowledge_UpdateList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_DEFAULT_DESC"))
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_Button_LUp_RepairItem(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  audioPostEvent_SystemUi(13, 9)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 7
  _usingItemSlotCount = 1
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.eType_Anvil
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_REPAIR"))
  _PA_LOG("\236\155\144\236\132\160", "\235\170\168\235\163\168!")
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_REPAIR"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_REPAIR"))
  Manufacture_UpdateCheckRadioButton()
  ManufactureKnowledge_ClearList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_DEFAULT_DESC"))
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_Button_LUp_Alchemy(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  audioPostEvent_SystemUi(13, 13)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 8
  _usingItemSlotCount = 5
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ALCHEMY"))
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC2_ALCHEMY"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateCheckRadioButton()
  _startKnowledgeIndex = 0
  ReconstructionAlchemyKnowledge(ALCHEMY_MENTALTHEMEKEY)
  ManufactureKnowledge_UpdateList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_DEFAULT_DESC"))
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_Button_LUp_Cook(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  audioPostEvent_SystemUi(13, 14)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 9
  if ToClient_IsContentsGroupOpen("327") then
    _usingItemSlotCount = 4
  elseif ToClient_IsContentsGroupOpen("228") then
    _usingItemSlotCount = 3
  else
    _usingItemSlotCount = 3
  end
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_COOK"))
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC2_COOK"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateCheckRadioButton()
  _startKnowledgeIndex = 0
  ReconstructionAlchemyKnowledge(COOK_MENTALTHEMEKEY)
  ManufactureKnowledge_UpdateList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_DEFAULT_DESC"))
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_Button_LUp_RGCook(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  audioPostEvent_SystemUi(13, 14)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 10
  _usingItemSlotCount = 3
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_COOK"))
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GAME_MANUFACTURE_DESC_ROYALGIFT_COOK"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateCheckRadioButton()
  _startKnowledgeIndex = 0
  ReconstructionAlchemyKnowledge(ROYALCOOK_MENTALTHEMEKEY)
  ManufactureKnowledge_UpdateList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_DEFAULT_DESC"))
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_Button_LUp_RGAlchemy(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  audioPostEvent_SystemUi(13, 13)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 11
  _usingItemSlotCount = 3
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_ALCHEMY"))
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GAME_MANUFACTURE_DESC_ROYALGIFT_ALCHEMY"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateCheckRadioButton()
  _startKnowledgeIndex = 0
  ReconstructionAlchemyKnowledge(ROYALALCHEMY_MENTALTHEMEKEY)
  ManufactureKnowledge_UpdateList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_DEFAULT_DESC"))
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_Button_LUp_GuildManufacture(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_INNTER_GUILDHOUSE_USE"))
    return
  end
  audioPostEvent_SystemUi(13, 13)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 12
  _usingItemSlotCount = 5
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_GUILDMANURACTURE_NAME"))
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_GUILDMANUFACTURE_DESC"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateCheckRadioButton()
  _startKnowledgeIndex = 0
  ReconstructionAlchemyKnowledge(GUILDMANUFACTURE_MENTALTHEMEKEY)
  ManufactureKnowledge_UpdateList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_DEFAULT_DESC"))
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_Button_LUp_Craft(isClear)
  if Panel_Win_System:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  if not enableCraft then
    return
  end
  audioPostEvent_SystemUi(13, 23)
  if nil ~= isClear and true == isClear then
    Manufacture_ClearMaterial()
  end
  StopManufactureAction()
  _actionIndex = 13
  _usingItemSlotCount = 5
  Manufacture_UpdateSlotPos()
  Manufacture_ShowPointEffect()
  _usingInstallationType = CppEnums.InstallationType.TypeCount
  _manufactureText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_CRAFT_NAME"))
  _manufactureText:SetShow(true)
  _textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_CRAFT_DESC"))
  _uiButtonManufacture:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE"))
  Manufacture_UpdateCheckRadioButton()
  _startKnowledgeIndex = 0
  ReconstructionAlchemyKnowledge(CRAFT_MENTALTHEMEKEY)
  ManufactureKnowledge_UpdateList()
  _defaultMSG1:SetShow(false)
  _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_DEFAULT_DESC"))
  if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
    Inventory_SetFunctor(ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil)
    Inventory_updateSlotData()
  else
    Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
    Warehouse_updateSlotData()
  end
  Manufacture_RefreshIsMassCheckButton(_actionIndex)
end
function Manufacture_KnowledgeList_SelectKnowledge(index)
  if Panel_Win_System:GetShow() then
    return
  end
  local knowledgeIndex = _startKnowledgeIndex + index
  local mentalCardStaticWrapper = getAlchemyKnowledge(knowledgeIndex)
  if nil ~= mentalCardStaticWrapper then
    local isLearn = isLearnMentalCardForAlchemy(mentalCardStaticWrapper:getKey())
    if true == isLearn then
      _uiKnowledgeDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      _uiKnowledgeDesc:SetText(mentalCardStaticWrapper:getDesc())
      _frameContent:SetSize(_frameContent:GetSizeX(), _uiKnowledgeDesc:GetSizeY())
      _uiKnowledgeIcon:ChangeTextureInfoName(mentalCardStaticWrapper:getImagePath())
      local x1, y1, x2, y2 = setTextureUV_Func(_uiKnowledgeIcon, 0, 0, 360, 360)
      _uiKnowledgeIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiKnowledgeIcon:setRenderTexture(_uiKnowledgeIcon:getBaseTexture())
      _defaultMSG2:SetShow(false)
    else
      _uiKnowledgeDesc:SetText("")
      _defaultMSG2:SetShow(true)
      _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WARNING_KNOWLEDGE_DESC"))
      _uiKnowledgeIcon:ChangeTextureInfoName("UI_Artwork/Unkown_Intelligence.dds")
      _frameContent:SetSize(_frameContent:GetSizeX(), _uiKnowledgeDesc:GetSizeY())
    end
    _frameScroll:SetShow(false)
    if _frameManufactureDesc:GetSizeY() < _uiKnowledgeDesc:GetTextSizeY() then
      _frameScroll:SetShow(true)
    end
    _frameScroll:SetControlTop()
    _frameManufactureDesc:UpdateContentScroll()
    _frameManufactureDesc:UpdateContentPos()
  end
  local prevSelectIndex = selectIndex
  selectIndex = index
  list2:requestUpdateByKey(toInt64(0, index))
  list2:requestUpdateByKey(toInt64(0, prevSelectIndex))
end
function Manufacture_KnowledgeList_Tooltip(isShow, index)
  local knowledgeIndex = _startKnowledgeIndex + index
  local mentalCardStaticWrapper = getAlchemyKnowledge(knowledgeIndex)
  if isShow then
    if nil ~= mentalCardStaticWrapper then
      local isLearn = isLearnMentalCardForAlchemy(mentalCardStaticWrapper:getKey())
      if not isLearn then
        local name = "???"
        local desc = mentalCardStaticWrapper:getKeyword()
        TooltipSimple_Show(uiControl, name, desc)
      end
    end
  else
    TooltipSimple_Hide()
  end
end
function ManufactureKnowledge_UpdateList()
  list2:getElementManager():clearKey()
  selectIndex = -1
  ManufactureKnowledge_ClearList()
  local count = getCountAlchemyKnowledge()
  for index = _startKnowledgeIndex, count - 1 do
    list2:getElementManager():pushKey(toInt64(0, index))
  end
end
function ManufactureKnowledge_ShowList(isShow)
  if isShow then
    _defaultMSG1:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_DEFAULT_MSG_1"))
    _defaultMSG2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_DEFAULT_MSG_2"))
    _defaultMSG1:SetShow(true)
    _defaultMSG2:SetShow(true)
  end
  _uiKnowledgeIcon:ComputePos()
  _uiKnowledgeIcon:ReleaseTexture()
  _uiKnowledgeDesc:SetText("")
  _uiKnowledgeDesc:SetShow(isShow)
  _frameContent:SetSize(_frameContent:GetSizeX(), _uiKnowledgeDesc:GetSizeY())
  UI.getChildControl(_title_BG, "Button_Close"):ComputePos()
  UI.getChildControl(_title_BG, "Button_Question"):ComputePos()
  UI.getChildControl(_title_BG, "StaticText_Title"):ComputePos()
end
function ManufactureKnowledge_ClearList()
  _uiKnowledgeIcon:ReleaseTexture()
  _uiKnowledgeDesc:SetText("")
  _frameContent:SetSize(_frameContent:GetSizeX(), _uiKnowledgeDesc:GetSizeY())
  _uiKnowledgeDesc:SetShow(true)
end
function Note_Mouse_LUp()
  if Panel_Win_System:GetShow() then
    return
  end
  Panel_ProductNote_ShowToggle()
end
function Note_Mouse_On()
  audioPostEvent_SystemUi(1, 13)
end
ManufactureControlInit()
Manufacture_Reset_ContinueGrindJewel()
function Material_Update(slotCount)
  local inventory = getSelfPlayer():get():getInventory()
  local invenSize = inventory:size()
  for ii = 0, slotCount - 1 do
    if nil ~= _materialSlotNoList[ii] and invenSize >= _materialSlotNoList[ii] then
      local curentInventoryType = Inventory_GetCurrentInventoryType()
      local itemWrapper = getInventoryItemByType(curentInventoryType, _materialSlotNoList[ii])
      if nil ~= itemWrapper then
        _slotList[ii]:setItemByStaticStatus(itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64())
      end
    end
  end
end
function Manufacture_Notify:Init()
  for key, value in pairs(self._templat) do
    value:SetShow(false)
  end
  self._defalutSpanY = Panel_Manufacture_Notify:GetSpanSize().y
  self._result_Title:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_RESULT"))
  self._progress_Effect:AddEffect("UI_Quest_Complete_GreenAura", true, 15, 0)
end
Manufacture_Notify:Init()
function Manufacture_Notify:createResultControl(index)
  if nil == self._item_Result[index] or nil == self._icon_ResultBG[index] or nil == self._icon_Result[index] then
    self._item_Result[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Manufacture_Notify, "item_Result_" .. index)
    self._icon_ResultBG[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Manufacture_Notify, "icon_ResultBG_" .. index)
    self._icon_Result[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Manufacture_Notify, "icon_Result_" .. index)
    CopyBaseProperty(self._templat._item_Result, self._item_Result[index])
    CopyBaseProperty(self._templat._icon_ResultBG, self._icon_ResultBG[index])
    CopyBaseProperty(self._templat._icon_Result, self._icon_Result[index])
    self._item_Result[index]:SetSpanSize(self._item_Result[index]:GetSpanSize().x, self._item_Result[index]:GetSpanSize().y - self._gapY * (index - 1))
    self._icon_ResultBG[index]:SetSpanSize(self._icon_ResultBG[index]:GetSpanSize().x, self._icon_ResultBG[index]:GetSpanSize().y - self._gapY * (index - 1))
    self._icon_Result[index]:SetSpanSize(self._icon_Result[index]:GetSpanSize().x, self._icon_Result[index]:GetSpanSize().y - self._gapY * (index - 1))
    self._icon_ResultBG[index]:addInputEvent("Mouse_On", "Manufacture_Tooltip_Item_Show(" .. index .. ", true)")
    self._icon_ResultBG[index]:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
  end
end
function Manufacture_Notify:createResourceControl(index)
  if nil == self._item_Resource[index] or nil == self._icon_ResourceBG[index] or nil == self._icon_Resource[index] then
    self._item_Resource[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Manufacture_Notify, "item_Resource_" .. index)
    self._icon_ResourceBG[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Manufacture_Notify, "icon_ResourceBG_" .. index)
    self._icon_Resource[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Manufacture_Notify, "icon_Resource_" .. index)
    CopyBaseProperty(self._templat._item_Resource, self._item_Resource[index])
    CopyBaseProperty(self._templat._icon_ResourceBG, self._icon_ResourceBG[index])
    CopyBaseProperty(self._templat._icon_Resource, self._icon_Resource[index])
    self._item_Resource[index]:SetSpanSize(self._templat._item_Resource:GetSpanSize().x, self._templat._item_Resource:GetSpanSize().y + self._gapY * (index - 1))
    self._icon_ResourceBG[index]:SetSpanSize(self._templat._icon_ResourceBG:GetSpanSize().x, self._templat._icon_ResourceBG:GetSpanSize().y + self._gapY * (index - 1))
    self._icon_Resource[index]:SetSpanSize(self._templat._icon_Resource:GetSpanSize().x, self._templat._icon_Resource:GetSpanSize().y + self._gapY * (index - 1))
    self._icon_ResourceBG[index]:addInputEvent("Mouse_On", "Manufacture_Tooltip_Item_Show(" .. index .. ", false)")
    self._icon_ResourceBG[index]:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
  end
end
function Manufacture_Notify:clear()
  Manufacture_Notify._data_Resource = {}
  Manufacture_Notify._data_Result = {}
  Manufacture_Notify._progress_Bar:SetSmoothMode(false)
  Manufacture_Notify._progress_Bar:SetProgressRate(0)
  for key, value in pairs(self._item_Resource) do
    value:SetShow(false)
  end
  for key, value in pairs(self._icon_ResourceBG) do
    value:SetShow(false)
  end
  for key, value in pairs(self._icon_Resource) do
    value:SetShow(false)
  end
  for key, value in pairs(self._item_Result) do
    value:SetShow(false)
  end
  for key, value in pairs(self._icon_ResultBG) do
    value:SetShow(false)
  end
  for key, value in pairs(self._icon_Result) do
    value:SetShow(false)
  end
end
function Manufacture_Notify:SetPos()
  local gapCnt = #self._data_Resource
  Panel_Manufacture_Notify:SetSpanSize(Panel_Manufacture_Notify:GetSpanSize().x, self._defalutSpanY + self._gapY * gapCnt)
end
function Manufacture_Progress_Update(materialItemWhereType)
  local progressRate = 0
  local currentInventoryType = Inventory_GetCurrentInventoryType()
  for key, value in pairs(Manufacture_Notify._data_Resource) do
    local index = key
    local _name = value._name
    local _originalCnt = value._originalCnt
    local _currentCnt = value._currentCnt
    local _iconPath = value._iconPath
    local _param = Manufacture_Notify._successCount / math.floor(_originalCnt / ((_originalCnt - _currentCnt) / Manufacture_Notify._successCount))
    local _rate = math.floor(_param * 100)
    Manufacture_Notify:createResourceControl(index)
    Manufacture_Notify._item_Resource[index]:SetText(_name .. " (" .. _currentCnt .. ")")
    Manufacture_Notify._icon_Resource[index]:ChangeTextureInfoName(_iconPath)
    local width
    Manufacture_Notify._item_Resource[index]:SetShow(true)
    Manufacture_Notify._icon_Resource[index]:SetShow(true)
    Manufacture_Notify._icon_ResourceBG[index]:SetShow(true)
    Manufacture_Notify._icon_ResourceBG[index]:SetEnableArea(0, 0, Manufacture_Notify._icon_ResourceBG[index]:GetSizeX() + Manufacture_Notify._item_Resource[index]:GetTextSizeX(), Manufacture_Notify._icon_ResourceBG[index]:GetSizeY())
    if progressRate < _rate then
      progressRate = _rate
    end
  end
  if 0 < Manufacture_Notify._successCount then
    Manufacture_Notify._progress_Bar:SetSmoothMode(true)
  end
  Manufacture_Notify._progress_Bar:SetProgressRate(progressRate)
  Manufacture_Notify._progress_Text:SetText(progressRate .. "%")
  if materialItemWhereType ~= currentInventoryType and currentInventoryType ~= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_BAG_TABSELECT"))
    Manufacture_ClearValues()
    Manufacture_Response()
  end
  for key, value in pairs(Manufacture_Notify._data_Result) do
    local index = key
    local _name = value._name
    local _iconPath = value._iconPath
    local _currentCnt = value._currentCnt
    Manufacture_Notify:createResultControl(index)
    Manufacture_Notify._item_Result[index]:SetText(_name .. " (" .. _currentCnt .. ")")
    Manufacture_Notify._icon_Result[index]:ChangeTextureInfoName(_iconPath)
    Manufacture_Notify._item_Result[index]:SetShow(true)
    Manufacture_Notify._icon_Result[index]:SetShow(true)
    Manufacture_Notify._icon_ResultBG[index]:SetShow(true)
    Manufacture_Notify._icon_ResultBG[index]:SetEnableArea(-Manufacture_Notify._item_Result[index]:GetTextSizeX(), 0, Manufacture_Notify._icon_ResultBG[index]:GetSizeX(), Manufacture_Notify._icon_ResultBG[index]:GetSizeY())
  end
  if 0 < #Manufacture_Notify._data_Result then
    Manufacture_Notify._result_Title:SetSpanSize(Manufacture_Notify._result_Title:GetSpanSize().x, Manufacture_Notify._templat._item_Result:GetSpanSize().y - Manufacture_Notify._gapY * #Manufacture_Notify._data_Result)
    Manufacture_Notify._result_Title:SetShow(true)
  else
    Manufacture_Notify._result_Title:SetShow(false)
  end
end
function Manufacture_Tooltip_Item_Show(index, isResult)
  local itemKey, uiBase
  if isResult then
    itemKey = Manufacture_Notify._data_Result[index]._key
    uiBase = Manufacture_Notify._icon_ResultBG[index]
  elseif false == isResult then
    itemKey = Manufacture_Notify._data_Resource[index]._key
    uiBase = Manufacture_Notify._icon_ResourceBG[index]
  end
  if itemKey == nil or nil == uiBase then
    return
  end
  local staticStatusWrapper = getItemEnchantStaticStatus(itemKey)
  Panel_Tooltip_Item_Show(staticStatusWrapper, uiBase, true, false)
end
function IsManufacture_Chk(variableName, value)
  if variableName == "IsManufactureChk" then
    if value == 0 then
      Panel_Manufacture_Notify:SetShow(false)
      Manufacture_Notify:clear()
    else
      Panel_Manufacture_Notify:SetShow(true)
      Manufacture_Notify._type_Name:SetText(PAGetString(Defines.StringSheet_GAME, manufactureListName[_actionIndex]))
      Manufacture_Notify:SetPos()
      Manufacture_Progress_Update(materialItemWhereType)
    end
    CheckChattingInput()
  else
    Panel_Manufacture_Notify:SetShow(false)
    Manufacture_Notify:clear()
  end
end
function Manufacture_Notify_Check()
  if true == Panel_Manufacture_Notify:GetShow() and 0 == #Manufacture_Notify._data_Resource then
    Panel_Manufacture_Notify:SetShow(false)
  end
end
function Manufacture_Full_Check()
  local useSlotCount = 0
  for ii = 0, _usingItemSlotCount - 1 do
    if _defaultSlotNo ~= _materialSlotNoList[ii] then
      useSlotCount = useSlotCount + 1
    end
  end
  if useSlotCount == _usingItemSlotCount then
    return true
  end
  return false
end
function ManufactureAction_InvenFiler(slotNo, itemWrapper, inventoryType)
  if -1 == _actionIndex then
    return false
  end
  local isVested = itemWrapper:get():isVested()
  local isPersonalTrade = itemWrapper:getStaticStatus():isPersonalTrade()
  if true == Manufacture_Full_Check() then
    return true
  end
  if isUsePcExchangeInLocalizingValue() then
    local isFilter = isVested and isPersonalTrade
    if isFilter then
      return isFilter
    end
  end
  local actionName = _listAction[_actionIndex]._actionName
  local isEnable
  if 7 == _actionIndex then
    isEnable = itemWrapper:checkToRepairItem()
  else
    isEnable = isManufactureItem(inventoryType, slotNo, actionName)
  end
  if ToClient_Inventory_CheckItemLock(slotNo, inventoryType) then
    isEnable = false
  end
  return not isEnable
end
function ManufactureAction_WarehouseFilter(slotNo, itemWrapper, stackCount)
  if -1 == _actionIndex then
    return false
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return false
  end
  local isVested = itemWrapper:get():isVested()
  local isPersonalTrade = itemWrapper:getStaticStatus():isPersonalTrade()
  if true == Manufacture_Full_Check() then
    return true
  end
  if isUsePcExchangeInLocalizingValue() then
    local isFilter = isVested and isPersonalTrade
    if isFilter then
      return isFilter
    end
  end
  local regionKey = selfPlayer:getRegionKey()
  local actionName = _listAction[_actionIndex]._actionName
  local isEnable
  if 7 == _actionIndex then
    isEnable = itemWrapper:checkToRepairItem()
  else
    isEnable = isManufactureItemInWareHouse(regionKey, slotNo, actionName)
  end
  return not isEnable
end
function manufactureClickSetTextureUV(uiBase, x1, y1, x2, y2, isType)
  if isType > 11 then
    uiBase:ChangeTextureInfoName("new_ui_common_forlua/window/manufacture/manufacture_01.dds")
  else
    uiBase:ChangeTextureInfoName("new_ui_common_forlua/window/manufacture/manufacture_00.dds")
  end
  local x1, y1, x2, y2 = setTextureUV_Func(uiBase, x1, y1, x2, y2)
  uiBase:getBaseTexture():setUV(x1, y1, x2, y2)
  uiBase:setRenderTexture(uiBase:getBaseTexture())
  uiBase:SetShow(true)
end
function manufacture_ShowIconToolTip(isShow, idx)
  local name, desc
  if isShow == true then
    audioPostEvent_SystemUi(1, 13)
    if idx == 0 then
      name = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_SHAKE")
      desc = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_SHAKE")
    elseif 1 == idx then
      name = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_GRIND")
      desc = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_GRIND")
    elseif 2 == idx then
      name = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_WOODSPLITTING")
      desc = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_FIREWOOD")
    elseif 3 == idx then
      name = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_DRY")
      desc = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_DRY")
    elseif 4 == idx then
      name = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_THINNING")
      desc = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_THINNING")
    elseif 5 == idx then
      name = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_HEATING")
      desc = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_HEAT")
    elseif 6 == idx then
      name = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_RAINWATER")
      desc = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_RAINWATER")
    elseif 7 == idx then
      name = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_REPAIR")
      desc = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_REPAIR")
    elseif 8 == idx then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ALCHEMY")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC_ALCHEMY")
    elseif 9 == idx then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_COOK")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC_COOK")
    elseif 10 == idx then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_COOK")
      desc = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_ROYALGIFT_COOK")
    elseif 11 == idx then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_ALCHEMY")
      desc = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_ROYALGIFT_ALCHEMY")
    elseif 12 == idx then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_GUILDMANURACTURE_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_GUILDMANUFACTURE_SUBDESC")
    elseif 13 == idx then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_CRAFT_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_CRAFT_SUBDESC")
    end
    if false == isEnableMsg[idx] then
      desc = desc .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_NEED_KNOWLEDGE")
    end
    registTooltipControl(_listAction[idx]._radioBtn, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(_listAction[idx]._radioBtn, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function noneStackItemCheckBT()
  if Panel_Manufacture:GetShow() then
    noneStackItemCheck = noneStackItem_ChkBtn:IsCheck()
  end
end
function Manufacture_RepeatAction(isMassManufacture)
  if Panel_Win_System:GetShow() then
    return
  end
  _isMassManufacture = isMassManufacture
  if nil ~= #noneStackItemList and #noneStackItemList > 0 and true == noneStackItemCheck or true == hasNoneStackItem and true == noneStackItemCheck then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_CONTINUEGRIND_MSGBOX_DESC"),
      functionYes = Manufacture_Mouse_LUp,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "middle")
  else
    Manufacture_Mouse_LUp()
  end
end
function registEventHandler()
  for i = 0, MAX_ACTION_BTN - 1 do
    _listAction[i]._radioBtn:addInputEvent("Mouse_On", "manufacture_ShowIconToolTip( true, " .. i .. " )")
    _listAction[i]._radioBtn:addInputEvent("Mouse_Out", "manufacture_ShowIconToolTip( false )")
  end
end
function Manufacture_ListControlCreate(content, key)
  local index = Int64toInt32(key)
  local recipe = UI.getChildControl(content, "StaticText_List2_AlchemyRecipe")
  local selectList = UI.getChildControl(content, "Static_List2_SelectList")
  local mentalCardStaticWrapper = getAlchemyKnowledge(index)
  selectList:SetIgnore(true)
  if selectIndex == index then
    selectList:SetShow(true)
  else
    selectList:SetShow(false)
  end
  if nil ~= mentalCardStaticWrapper then
    local isLearn = isLearnMentalCardForAlchemy(mentalCardStaticWrapper:getKey())
    recipe:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    if true == isLearn then
      recipe:SetFontColor(UI_color.C_FF84FFF5)
      recipe:SetText(mentalCardStaticWrapper:getName())
      limitTextTooltip[index] = mentalCardStaticWrapper:getName()
    else
      recipe:SetFontColor(UI_color.C_FF9397A7)
      recipe:SetText("??? ( " .. mentalCardStaticWrapper:getKeyword() .. " )")
      limitTextTooltip[index] = mentalCardStaticWrapper:getKeyword()
    end
    if recipe:IsLimitText() then
      IsLimitText[index] = true
    else
      IsLimitText[index] = false
    end
    recipe:addInputEvent("Mouse_On", "ManufactureLimitTextTooptip( true, " .. index .. " )")
    recipe:addInputEvent("Mouse_Out", "ManufactureLimitTextTooptip( false )")
    recipe:SetShow(true)
    recipe:SetPosY(6)
    recipe:addInputEvent("Mouse_LUp", "Manufacture_KnowledgeList_SelectKnowledge( " .. index .. " )")
  else
    recipe:SetShow(false)
  end
end
function ManufactureLimitTextTooptip(isShow, index)
  if isShow == false or false == IsLimitText[index] then
    TooltipSimple_Hide()
    return
  end
  TooltipSimple_Show(Panel_Manufacture, limitTextTooltip[index])
end
function Manufacture_SetShowMassManufacture(isShow)
  if false == _ContentsGroup_LifeStatManufacturing then
    isShow = false
  end
  _uiButtonMassManufacture:SetShow(isShow)
end
function Manufacture_SetEnableMassManufacture(isEnable)
end
function Manufacture_ShowKnowledgeList()
  _btn_funcBG:SetShow(checkBtn_ShowDetail:IsCheck())
end
Manufacture_ShowKnowledgeList()
registerEvent("onScreenResize", "manufacture_Repos")
registerEvent("EventChangedSelfPlayerActionVariable", "IsManufacture_Chk")
list2:changeAnimationSpeed(10)
list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "Manufacture_ListControlCreate")
list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
Panel_Manufacture_Notify:RegisterUpdateFunc("Manufacture_Notify_Check")
registEventHandler()
