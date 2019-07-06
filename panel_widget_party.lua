Panel_Widget_Party:SetShow(false, false)
local partyWidget = {
  _ui = {
    _static_OptionBg = UI.getChildControl(Panel_Widget_Party, "Static_OptionBg"),
    _button_SpecialItem = nil,
    _button_MarketOption = nil,
    _button_Option = nil,
    _checkButton_DropItem = nil,
    _radioButton_Free = nil,
    _radioButton_Turn = nil,
    _radioButton_Random = nil,
    _radioButton_LeaderOnly = nil,
    _static_PartyMember = {},
    _static_PartyMember_Template = UI.getChildControl(Panel_Widget_Party, "Static_PartyMember_Template"),
    _static_MarketOptionBg = UI.getChildControl(Panel_Widget_Party, "Static_MarketOptionBg"),
    _checkButton_Money = nil,
    _checkButton_Grade = nil,
    _staticText_MoneyValue = nil,
    _combobox_MarketGrade = nil,
    _combobox_1_List = nil,
    _static_Option = nil,
    _button_Admin = nil,
    _button_Cancel = nil
  },
  _config = {
    _maxPartyMemberCount = 5,
    _gabY = 10,
    _isContentsEnable = ToClient_IsContentsGroupOpen("38"),
    _isLargePartyOpen = ToClient_IsContentsGroupOpen("286"),
    _itemGradeString = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_NOT_SETTING"),
      [1] = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ITEMGRADE_GREEN"),
      [2] = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ITEMGRADE_BLUE"),
      [3] = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ITEMGRADE_YELLOW"),
      [4] = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ITEMGRADE_ORANGE")
    },
    _baseMoney = toInt64(0, 1000000),
    _maxMoney = toInt64(0, 100000000),
    _textureClassSymbol = {
      ["path"] = "Renewal/UI_Icon/Console_ClassSymbol.dds",
      [CppEnums.ClassType.ClassType_Warrior] = {
        x1 = 1,
        x2 = 172,
        y1 = 57,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_Ranger] = {
        x1 = 58,
        x2 = 172,
        y1 = 114,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_Sorcerer] = {
        x1 = 115,
        x2 = 172,
        y1 = 171,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_Lahn] = {
        x1 = 400,
        x2 = 229,
        y1 = 456,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_Giant] = {
        x1 = 172,
        x2 = 172,
        y1 = 228,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_Tamer] = {
        x1 = 229,
        x2 = 172,
        y1 = 285,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_Combattant] = {
        x1 = 286,
        x2 = 229,
        y1 = 342,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_BladeMaster] = {
        x1 = 286,
        x2 = 172,
        y1 = 342,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_BladeMasterWomen] = {
        x1 = 400,
        x2 = 172,
        y1 = 456,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_CombattantWomen] = {
        x1 = 343,
        x2 = 229,
        y1 = 399,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_Valkyrie] = {
        x1 = 343,
        x2 = 172,
        y1 = 399,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_NinjaWomen] = {
        x1 = 115,
        x2 = 229,
        y1 = 171,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_NinjaMan] = {
        x1 = 172,
        x2 = 229,
        y1 = 228,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_DarkElf] = {
        x1 = 229,
        x2 = 229,
        y1 = 285,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_Wizard] = {
        x1 = 1,
        x2 = 229,
        y1 = 57,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_Orange] = {
        x1 = 1,
        x2 = 286,
        y1 = 57,
        y2 = 342
      },
      [CppEnums.ClassType.ClassType_WizardWomen] = {
        x1 = 58,
        x2 = 229,
        y1 = 114,
        y2 = 285
      },
      [__eClassType_ShyWaman] = {
        x1 = 58,
        x2 = 115,
        y1 = 114,
        y2 = 171
      }
    },
    _textureMPBar = {
      ["path"] = "Renewal/progress/Console_Progressbar_03.dds",
      [CppEnums.ClassType.ClassType_Warrior] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_Ranger] = {
        [1] = 331,
        [2] = 290,
        [3] = 504,
        [4] = 294
      },
      [CppEnums.ClassType.ClassType_Orange] = {
        [1] = 331,
        [2] = 290,
        [3] = 504,
        [4] = 294
      },
      [CppEnums.ClassType.ClassType_Sorcerer] = {
        [1] = 331,
        [2] = 296,
        [3] = 504,
        [4] = 300
      },
      [CppEnums.ClassType.ClassType_Lahn] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_Giant] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_Tamer] = {
        [1] = 331,
        [2] = 296,
        [3] = 504,
        [4] = 300
      },
      [CppEnums.ClassType.ClassType_Combattant] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_BladeMaster] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_BladeMasterWomen] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_CombattantWomen] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_Valkyrie] = {
        [1] = 331,
        [2] = 308,
        [3] = 504,
        [4] = 312
      },
      [CppEnums.ClassType.ClassType_NinjaWomen] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_Kunoichi] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_NinjaMan] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_DarkElf] = {
        [1] = 331,
        [2] = 302,
        [3] = 504,
        [4] = 306
      },
      [CppEnums.ClassType.ClassType_Wizard] = {
        [1] = 331,
        [2] = 296,
        [3] = 504,
        [4] = 300
      },
      [CppEnums.ClassType.ClassType_WizardWomen] = {
        [1] = 331,
        [2] = 296,
        [3] = 504,
        [4] = 300
      }
    },
    _textureWifi = {
      ["path"] = "Renewal/ETC/Console_ETC_00.dds",
      [1] = {
        [1] = 51,
        [2] = 275,
        [3] = 74,
        [4] = 295
      },
      [2] = {
        [1] = 51,
        [2] = 296,
        [3] = 74,
        [4] = 316
      },
      [3] = {
        [1] = 51,
        [2] = 317,
        [3] = 74,
        [4] = 337
      },
      [4] = {
        [1] = 51,
        [2] = 338,
        [3] = 74,
        [4] = 358
      }
    },
    _textureRootInfo = {
      [1] = {
        [1] = 51,
        [2] = 359,
        [3] = 74,
        [4] = 379
      },
      [2] = {
        [1] = 51,
        [2] = 380,
        [3] = 74,
        [4] = 400
      }
    }
  },
  _isInitailized,
  _partyType,
  _refuseName,
  _withdrawMember,
  _isMainChannel,
  _isDevServer,
  _partyMemberCount,
  _preLootType,
  _currentMoney,
  _partyData = {},
  _firstCheck = 0,
  _lastSelectUser,
  _prevPrice,
  _prevGrade,
  _minPartyMemberLevel = 999,
  _maxPartyMemberLevel = 0,
  _inviteRequestPlayerList = {},
  rootShowFlag = false
}
function partyWidget:initialize()
  self:initControl()
  self:createControl()
  self:initData()
  self:addInputEvent()
  self:setPosition()
  self._isInitailized = true
end
function partyWidget:setPosition()
  changePositionBySever(Panel_Widget_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
end
function partyWidget:initData()
  self._isMainChannel = getCurrentChannelServerData()._isMain
  self._isDevServer = ToClient_IsDevelopment()
  self._partyMemberCount = 0
  self._partyData = {}
end
function partyWidget:initControl()
  Panel_Widget_Party:SetShow(false, false)
  Panel_Widget_Party:ActiveMouseEventEffect(true)
  Panel_Widget_Party:RegisterShowEventFunc(true, "PartyShowAni()")
  Panel_Widget_Party:RegisterShowEventFunc(false, "PartyHideAni()")
  changePositionBySever(Panel_Widget_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
  self._ui._button_SpecialItem = UI.getChildControl(self._ui._static_OptionBg, "Button_SpecialItem")
  self._ui._button_MarketOption = UI.getChildControl(self._ui._static_OptionBg, "Button_MarketOption")
  self._ui._checkButton_DropItem = UI.getChildControl(self._ui._static_OptionBg, "CheckButton_DropItem")
  self._ui._radioButton_Free = UI.getChildControl(self._ui._static_OptionBg, "RadioButton_Free")
  self._ui._radioButton_Turn = UI.getChildControl(self._ui._static_OptionBg, "RadioButton_Turn")
  self._ui._radioButton_Random = UI.getChildControl(self._ui._static_OptionBg, "RadioButton_Random")
  self._ui._radioButton_LeaderOnly = UI.getChildControl(self._ui._static_OptionBg, "RadioButton_LeaderOnly")
  self._ui._radioButton_Free:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._radioButton_Turn:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._radioButton_Random:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._radioButton_LeaderOnly:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._radioButton_Free:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PARTYSETTING_FREE"))
  self._ui._radioButton_Turn:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PARTYSETTING_TURN"))
  self._ui._radioButton_Random:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PARTYSETTING_RANDOM"))
  self._ui._radioButton_LeaderOnly:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PARTYSETTING_LEADERONLY"))
  self._ui._checkButton_Money = UI.getChildControl(self._ui._static_MarketOptionBg, "CheckButton_Money")
  self._ui._checkButton_Grade = UI.getChildControl(self._ui._static_MarketOptionBg, "CheckButton_Grade")
  self._ui._staticText_MoneyValue = UI.getChildControl(self._ui._static_MarketOptionBg, "StaticText_MoneyValue")
  self._ui._combobox_MarketGrade = UI.getChildControl(self._ui._static_MarketOptionBg, "Combobox_MarketGrade")
  self._ui._combobox_1_List = UI.getChildControl(self._ui._combobox_MarketGrade, "Combobox_1_List")
  self._ui._static_Option = UI.getChildControl(self._ui._static_MarketOptionBg, "Static_Option")
  self._ui._button_Admin = UI.getChildControl(self._ui._static_MarketOptionBg, "Button_Admin")
  self._ui._button_Cancel = UI.getChildControl(self._ui._static_MarketOptionBg, "Button_Cancel")
end
function partyWidget:createControl()
  self._ui._static_PartyMember_Template:SetShow(false)
  local startPosY = self._ui._static_PartyMember_Template:GetPosY()
  for index = 1, self._config._maxPartyMemberCount do
    local info = {}
    info.control = UI.cloneControl(self._ui._static_PartyMember_Template, Panel_Widget_Party, "Static_PartyMember_" .. index)
    info.control:SetIgnore(false)
    info.control:SetPosY(startPosY + (info.control:GetSizeY() + self._config._gabY) * index)
    info._static_ClassIconBg = UI.getChildControl(info.control, "Static_ClassIconBg")
    info._static_ClassIconLeaderBg = UI.getChildControl(info.control, "Static_ClassIconLeaderBg")
    info._static_ClassIcon = UI.getChildControl(info.control, "Static_ClassIcon")
    info._staticText_CharacterValue = UI.getChildControl(info.control, "StaticText_CharacterValue")
    info._static_ProgressBg = UI.getChildControl(info.control, "Static_ProgressBg")
    info._progress2_Hp = UI.getChildControl(info.control, "Progress2_Hp")
    info._progress2_Mp = UI.getChildControl(info.control, "Progress2_Mp")
    info._staic_DeadState = UI.getChildControl(info.control, "Static_DeadState")
    info._staic_RootInfoIcon = UI.getChildControl(info.control, "Static_RootInfoIcon")
    info._staic_DistanceWifi = UI.getChildControl(info.control, "Static_DistanceWifi")
    info._staic_Follow = UI.getChildControl(info.control, "Static_Follow")
    info._staic_LeaderIcon = UI.getChildControl(info.control, "Static_LeaderIcon")
    info._button_Option = UI.getChildControl(info.control, "Button_Option")
    info._button_Leave = UI.getChildControl(info.control, "Button_Leave")
    info._button_SetLeader = UI.getChildControl(info.control, "Button_SetLeader")
    info._button_ForceOut = UI.getChildControl(info.control, "Button_ForceOut")
    info._button_Leave:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    info._button_SetLeader:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    info._button_ForceOut:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    info._button_Leave:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PARTYSETTING_LEAVE"))
    info._button_SetLeader:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PARTYSETTING_AUTORIZE"))
    info._button_ForceOut:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PARTYSETTING_KICKOUT"))
    local colorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
    if colorBlindMode >= 1 then
      info._progress2_Hp:ChangeTextureInfoName("Renewal/Progress/Console_Progressbar_02.dds")
      local xx1, yy1, xx2, yy2 = setTextureUV_Func(info._progress2_Hp, 314, 483, 492, 492)
      info._progress2_Hp:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
      info._progress2_Hp:setRenderTexture(info._progress2_Hp:getBaseTexture())
      info._progress2_Mp:ChangeTextureInfoName("Renewal/Progress/Console_Progressbar_02.dds")
      local xx1, yy1, xx2, yy2 = setTextureUV_Func(info._progress2_Mp, 314, 493, 487, 497)
      info._progress2_Mp:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
      info._progress2_Mp:setRenderTexture(info._progress2_Mp:getBaseTexture())
    end
    self._ui._static_PartyMember[index] = info
  end
end
function partyWidget:addInputEvent()
  Panel_Widget_Party:addInputEvent("Mouse_LUp", "ResetPos_WidgetButton()")
  for index = 1, self._config._maxPartyMemberCount do
    local control = self._ui._static_PartyMember[index]
    control._staic_Follow:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_SelectPartyFollow(" .. index .. ")")
    control._staic_Follow:addInputEvent("Mouse_On", "PaGlobalFunc_PartyWidget_ShowSimpleTooltip(true, 0, " .. index .. ")")
    control._staic_Follow:addInputEvent("Mouse_Out", "PaGlobalFunc_PartyWidget_ShowSimpleTooltip(false, 0, " .. index .. ")")
    control._staic_Follow:setTooltipEventRegistFunc("PaGlobalFunc_PartyWidget_ShowSimpleTooltip(true, 0, " .. index .. ")")
    control._staic_DistanceWifi:addInputEvent("Mouse_On", "PaGlobalFunc_PartyWidget_ShowSimpleTooltip(true, 1, " .. index .. ")")
    control._staic_DistanceWifi:addInputEvent("Mouse_Out", "PaGlobalFunc_PartyWidget_ShowSimpleTooltip(false, 1, " .. index .. ")")
    control._staic_DistanceWifi:setTooltipEventRegistFunc("Mouse_On", "PaGlobalFunc_PartyWidget_ShowSimpleTooltip(true, 1, " .. index .. ")")
    control._staic_LeaderIcon:addInputEvent("Mouse_On", "PaGlobalFunc_PartyWidget_ShowSimpleTooltip(true, 3, " .. index .. ")")
    control._staic_LeaderIcon:addInputEvent("Mouse_Out", "PaGlobalFunc_PartyWidget_ShowSimpleTooltip(false, 3, " .. index .. ")")
    control._button_Option:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_SelectPartyOption(" .. index .. ")")
    control._staic_RootInfoIcon:addInputEvent("Mouse_On", "PaGlobalFunc_PartyWidget_ShowSimpleTooltip(true, 4, " .. index .. ")")
    control._staic_RootInfoIcon:addInputEvent("Mouse_Out", "PaGlobalFunc_PartyWidget_ShowSimpleTooltip(false, 4, " .. index .. ")")
  end
  self._ui._button_SpecialItem:addInputEvent("Mouse_On", "PaGlobalFunc_PartyWidget_ShowSepcialGoodsToolTip( 2, true )")
  self._ui._button_SpecialItem:addInputEvent("Mouse_Out", "PaGlobalFunc_PartyWidget_ShowSepcialGoodsToolTip( 2, false )")
  self._ui._button_SpecialItem:addInputEvent("Mouse_LUp", "Panel_Party_ItemList_Open()")
  self._ui._button_MarketOption:addInputEvent("Mouse_On", "PaGlobalFunc_PartyWidget_ShowSepcialGoodsToolTip( 1, true )")
  self._ui._button_MarketOption:addInputEvent("Mouse_Out", "PaGlobalFunc_PartyWidget_ShowSepcialGoodsToolTip( 1, false )")
  self._ui._button_MarketOption:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_ShowMarkerOption()")
  self._ui._radioButton_Free:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_selectLootingType(" .. CppEnums.PartyLootType.LootType_Free .. ")")
  self._ui._radioButton_Turn:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_selectLootingType(" .. CppEnums.PartyLootType.LootType_Shuffle .. ")")
  self._ui._radioButton_Random:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_selectLootingType(" .. CppEnums.PartyLootType.LootType_Random .. ")")
  self._ui._radioButton_LeaderOnly:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_selectLootingType(" .. CppEnums.PartyLootType.LootType_Master .. ")")
  self._ui._combobox_MarketGrade:setListTextHorizonCenter()
  self._ui._combobox_MarketGrade:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_ShowComboBox()")
  self._ui._combobox_MarketGrade:GetListControl():addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_SetGrade()")
  self._ui._checkButton_DropItem:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_SetLootingOption()")
  self._ui._static_Option:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_ChangeMoney()")
  self._ui._button_Admin:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_SetRegistItem()")
  self._ui._button_Cancel:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_ShowRegistItem(false)")
end
function PaGlobalFunc_PartyWidget_SetLootingOption()
  partyWidget:setLootingType()
end
function partyWidget:setLootingType()
  self:closePartyOption()
  self._lastSelectUser = nil
  if false == RequestParty_isLeader() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ONLYLEADERCHANGE"))
    self._ui._checkButton_DropItem:SetCheck(false)
    return
  end
  self:showLootingType()
end
function partyWidget:showLootingType()
  local lootType = RequestParty_getPartyLootType()
  local setShow = self._ui._checkButton_DropItem:IsCheck()
  self._ui._radioButton_Free:SetShow(setShow)
  self._ui._radioButton_Turn:SetShow(setShow)
  self._ui._radioButton_Random:SetShow(setShow)
  self._ui._radioButton_LeaderOnly:SetShow(setShow)
  if true == setShow then
    self:changeLootingType(lootType)
  end
end
function PaGlobalFunc_PartyWidget_changeLootingType(lootType)
  partyWidget:changeLootingType(lootType)
end
function partyWidget:changeLootingType(lootType)
  self._ui._radioButton_Free:SetCheck(false)
  self._ui._radioButton_Turn:SetCheck(false)
  self._ui._radioButton_Random:SetCheck(false)
  self._ui._radioButton_LeaderOnly:SetCheck(false)
  if lootType == CppEnums.PartyLootType.LootType_Free then
    self._ui._radioButton_Free:SetCheck(true)
  elseif lootType == CppEnums.PartyLootType.LootType_Shuffle then
    self._ui._radioButton_Turn:SetCheck(true)
  elseif lootType == CppEnums.PartyLootType.LootType_Random then
    self._ui._radioButton_Random:SetCheck(true)
  elseif lootType == CppEnums.PartyLootType.LootType_Master then
    self._ui._radioButton_LeaderOnly:SetCheck(true)
  end
end
function PaGlobalFunc_PartyWidget_selectLootingType(lootType)
  partyWidget:selectLootingType(lootType)
end
function partyWidget:selectLootingType(lootType)
  RequestParty_changeLooting(lootType)
  local showString
  if lootType == CppEnums.PartyLootType.LootType_Free then
    showString = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_LOOTTYPE_FREE")
  elseif lootType == CppEnums.PartyLootType.LootType_Shuffle then
    showString = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_LOOTTYPE_SHUFFLE")
  elseif lootType == CppEnums.PartyLootType.LootType_Random then
    showString = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_LOOTTYPE_RANDOM")
  elseif lootType == CppEnums.PartyLootType.LootType_Master then
    showString = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_LOOTTYPE_MASTER")
  end
  self._ui._checkButton_DropItem:SetText(showString)
  self._ui._checkButton_DropItem:SetCheck(false)
  self:showLootingType()
end
function PaGlobalFunc_PartyWidget_GetShow()
  return partyWidget:getShow()
end
function partyWidget:getShow()
  return Panel_Widget_Party:GetShow()
end
function partyWidget:resetData()
  if not self._isInitailized then
    return
  end
  self._partyType = ToClient_GetPartyType()
  self._refuseName = nil
  self._withdrawMember = nil
  self._partyMemberCount = RequestParty_getPartyMemberCount()
  self._partyData = {}
  self._currentMoney = self._config._baseMoney
  self._preLootType = nil
  self._ui._static_MarketOptionBg:SetShow(false)
  self._ui._checkButton_DropItem:SetCheck(false)
  self:showLootingType()
  self._ui._checkButton_Money:SetCheck(false)
  self._ui._checkButton_Grade:SetCheck(false)
  self._ui._staticText_MoneyValue:SetText("<PAColor0xffe7d583>" .. makeDotMoney(self._currentMoney) .. "<PAOldColor>")
  self._ui._combobox_MarketGrade:SetSelectItemIndex(0)
  self._firstCheck = 0
  self._lastSelectUser = nil
  self._inviteRequestPlayerList = {}
  self._prevPrice = nil
  self._prevGrade = nil
end
function PaGlobalFunc_PartyWidget_Open()
  if not partyWidget._isInitailized then
    return
  end
  partyWidget:open()
  partyWidget:createPartyList()
  partyWidget:updatePartyList()
  partyWidget:setScreenSize()
end
function partyWidget:open()
  if true == Panel_Widget_Party:GetShow() then
    return
  end
  Panel_Widget_Party:SetShow(true)
end
function PaGlobalFunc_PartyWidget_Close()
  partyWidget:close()
end
function partyWidget:close()
  if false == Panel_Widget_Party:GetShow() then
    return
  end
  self:resetData()
  Panel_Widget_Party:SetShow(false)
end
function partyWidget:update()
  self._partyMemberCount = RequestParty_getPartyMemberCount()
  local lootType = RequestParty_getPartyLootType()
end
function FGlobal_PartyMemberCount()
  return partyWidget._partyMemberCount
end
function PaGlobalFunc_PartyWidget_ChangeMoney()
  partyWidget:changeMoney()
end
function partyWidget:changeMoney()
  Panel_NumberPad_Show(true, self._config._maxMoney, nil, PaGlobalFunc_PartyWidget_setMoney)
end
function PaGlobalFunc_PartyWidget_setMoney(inputNum)
  partyWidget:setMoney(inputNum)
end
function partyWidget:setMoney(inputNum)
  local _inputNum
  if Int64toInt32(self._config._maxMoney) < Int64toInt32(inputNum) then
    _inputNum = self._config._maxMoney
  elseif Int64toInt32(inputNum) < 1000000 then
    _inputNum = self._config._baseMoney
  else
    _inputNum = inputNum
  end
  self._currentMoney = _inputNum
  self._ui._staticText_MoneyValue:SetText("<PAColor0xffe7d583>" .. makeDotMoney(_inputNum) .. "<PAOldColor>")
end
function PaGlobalFunc_PartyWidget_ShowComboBox()
  partyWidget:showComboBox()
end
function partyWidget:showComboBox()
  self._ui._combobox_MarketGrade:DeleteAllItem()
  for index = 0, #self._config._itemGradeString do
    self._ui._combobox_MarketGrade:AddItem(self._config._itemGradeString[index], index)
  end
  self._ui._combobox_MarketGrade:ToggleListbox()
  self._ui._combobox_MarketGrade:SetShow(true)
end
function PaGlobalFunc_PartyWidget_SetGrade()
  partyWidget:setGrade()
end
function partyWidget:setGrade()
  self._ui._combobox_MarketGrade:SetSelectItemIndex(self._ui._combobox_MarketGrade:GetSelectIndex())
  self._ui._combobox_MarketGrade:ToggleListbox()
end
function PaGlobalFunc_PartyWidget_SetRegistItem()
  partyWidget:setRegistItem()
end
function partyWidget:setRegistItem()
  local price = toInt64(0, 0)
  local grade = 5
  if true == self._ui._checkButton_Money:IsCheck() then
    price = toInt64(0, math.max(Int64toInt32(self._currentMoney), Int64toInt32(self._config._baseMoney)))
  end
  if true == self._ui._checkButton_Grade:IsCheck() then
    grade = self._ui._combobox_MarketGrade:GetSelectIndex()
  else
    grade = self._ui._combobox_MarketGrade:SetSelectItemIndex(0)
  end
  if 0 < self._ui._combobox_MarketGrade:GetSelectIndex() and self._ui._combobox_MarketGrade:GetSelectIndex() < #self._config._itemGradeString then
    self._ui._combobox_MarketGrade:SetSelectItemIndex(self._ui._combobox_MarketGrade:GetSelectIndex())
  else
    grade = 5
    self._ui._combobox_MarketGrade:SetSelectItemIndex(0)
  end
  RequestParty_changeDistributionOption(price, grade)
  self:showRegistItem(false)
end
function PaGlobalFunc_PartyWidget_ShowMarkerOption()
  partyWidget:showMarketOption()
end
function partyWidget:showMarketOption()
  if false == RequestParty_isLeader() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ONLYLEADERCHANGE"))
    return
  end
  self:showRegistItem(not self._ui._static_MarketOptionBg:GetShow())
end
function PaGlobalFunc_PartyWidget_ShowRegistItem(isShow)
  partyWidget:showRegistItem(isShow)
end
function partyWidget:showRegistItem(isShow)
  if nil == isShow then
    self._ui._static_MarketOptionBg:SetShow(not self._ui._static_MarketOptionBg:GetShow())
  else
    self._ui._static_MarketOptionBg:SetShow(isShow)
  end
  if false == self._ui._static_MarketOptionBg:GetShow() then
    return
  end
  local isPartyLeader = RequestParty_isLeader()
  self._ui._checkButton_Grade:SetEnable(isPartyLeader)
  self._ui._checkButton_Money:SetEnable(isPartyLeader)
  self._ui._static_Option:SetEnable(isPartyLeader)
  self._ui._combobox_MarketGrade:SetEnable(isPartyLeader)
  local posY = self._ui._static_PartyMember[self._partyMemberCount].control:GetPosY() + self._ui._static_MarketOptionBg:GetSizeY() * 0.8
  self._ui._static_MarketOptionBg:SetPosY(posY)
  self._currentMoney = RequestParty_getDistributionPrice()
  if toInt64(0, 0) ~= self._currentMoney then
    self._ui._staticText_MoneyValue:SetText("<PAColor0xffe7d583>" .. makeDotMoney(self._currentMoney) .. "<PAOldColor>")
    self._ui._checkButton_Money:SetCheck(true)
  else
    self._ui._staticText_MoneyValue:SetText("<PAColor0xffe7d583>" .. makeDotMoney(self._config._baseMoney) .. "<PAOldColor>")
    self._ui._checkButton_Money:SetCheck(false)
  end
  self._ui._combobox_MarketGrade:DeleteAllItem()
  for index = 0, #self._config._itemGradeString do
    self._ui._combobox_MarketGrade:AddItem(self._config._itemGradeString[index], index)
  end
  local currentGrade = RequestParty_getDistributionGrade()
  if currentGrade > 0 and currentGrade < #self._config._itemGradeString then
    self._ui._combobox_MarketGrade:SetSelectItemIndex(currentGrade)
    self._ui._combobox_MarketGrade:SetText(self._config._itemGradeString[currentGrade])
    self._ui._checkButton_Grade:SetCheck(true)
  else
    self._ui._combobox_MarketGrade:SetSelectItemIndex(0)
    self._ui._checkButton_Grade:SetCheck(false)
  end
end
function partyWidget:resetPartyData()
  if not self._isInitailized then
    return
  end
  self._partyData = {}
  for index = 1, self._config._maxPartyMemberCount do
    self._ui._static_PartyMember[index].control:SetShow(false)
  end
end
function ResponseParty_createPartyList()
  partyWidget:createPartyList()
end
function partyWidget:createPartyList()
  local partyMemberCount = RequestParty_getPartyMemberCount()
  if partyMemberCount > 0 then
    self._partyType = ToClient_GetPartyType()
    if CppEnums.PartyType.ePartyType_Normal == self._partyType then
      if not isFlushedUI() then
        self:open()
      end
      self:updatePartyList()
      self:showRegistItem(false)
      self._partyMemberCount = partyMemberCount
      ToClient_requestListMySellInfo()
      PaGlobal_RaidParty_Close()
    elseif CppEnums.PartyType.ePartyType_Large == self._partyType then
      PaGlobal_RaidParty_Open()
      PaGlobal_RaidParty_Update()
      self:close()
    end
  end
end
function ResponseParty_updatePartyList()
  partyWidget:updatePartyList()
end
function partyWidget:updatePartyList()
  if not self._isInitailized then
    return
  end
  local partyMemberCount = RequestParty_getPartyMemberCount()
  if true == Panel_Widget_Party:GetShow() and CppEnums.PartyType.ePartyType_Normal == self._partyType then
    local lootType = RequestParty_getPartyLootType()
    self:resetPartyData()
    self:setPartyMember(partyMemberCount)
    self:setMemberTexture(partyMemberCount)
    local currentLootTypeString = CppEnums.PartyLootType2String[lootType]
    if self._preLootType ~= nil and self._preLootType ~= currentLootTypeString then
      local rottingMsg = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_CHANGE_LOOTING_RULE1", "plt2s_lootType", currentLootTypeString)
      Proc_ShowMessage_Ack(rottingMsg)
      self._ui._checkButton_DropItem:SetText(currentLootTypeString)
    elseif self._preLootType == nil then
      self._ui._checkButton_DropItem:SetText(currentLootTypeString)
    end
    self._preLootType = currentLootTypeString
    if CppEnums.PartyLootType.LootType_PartyInven ~= lootType then
      FGlobal_PartyInventoryClose()
    else
      FGlobal_PartyInventoryOpen()
      for i = 1, partyMemberCount do
        Panel_Window_PartyInventory:SetPosY(i * Panel_Widget_Party:GetSizeY() + Panel_Widget_Party:GetPosY() + 40)
      end
    end
    if 0 == partyMemberCount then
      self:close()
    end
    self._partyMemberCount = partyMemberCount
    if partyMemberCount > self._firstCheck then
      self._firstCheck = self._firstCheck + 1
    else
      local currentPrice = RequestParty_getDistributionPrice()
      local currentGrade = RequestParty_getDistributionGrade()
      if self._prevPrice ~= currentPrice or self._prevGrade ~= currentGrade then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_CHANGE_OPTION"))
        self._prevPrice = currentPrice
        self._prevGrade = currentGrade
      end
    end
  elseif PaGlobal_RaidParty_GetShow() and CppEnums.PartyType.ePartyType_Large == self._partyType then
    Panel_Widget_Party:SetShow(false)
    PaGlobal_RaidParty_Update()
  elseif false == Panel_Widget_Party:GetShow() and partyMemberCount > 0 then
    self:createPartyList()
    self:open()
  end
end
function PaGlobalFunc_PartyWidget_setMemeberData(partyMemberCount)
  partyWidget:setPartyMember(partyMemberCount)
  return partyWidget._partyData
end
function partyWidget:setPartyMember(partyMemberCount)
  if partyMemberCount <= 0 then
    return
  end
  self._minPartyMemberLevel = 999
  self._maxPartyMemberLevel = 0
  self._partyData = {}
  for index = 0, partyMemberCount - 1 do
    local memberData = RequestParty_getPartyMemberAt(index)
    if nil == memberData then
      return
    end
    local partyMemberInfo = {}
    partyMemberInfo._index = index
    partyMemberInfo._isMaster = memberData._isMaster
    partyMemberInfo._isSelf = RequestParty_isSelfPlayer(index)
    partyMemberInfo._name = memberData:name()
    partyMemberInfo._class = memberData:classType()
    partyMemberInfo._level = memberData._level
    partyMemberInfo._currentHp = memberData._hp * 100
    partyMemberInfo._maxHp = memberData._maxHp
    partyMemberInfo._currentMp = memberData._mp * 100
    partyMemberInfo._maxMp = memberData._maxMp
    partyMemberInfo._distance = memberData:getExperienceGrade()
    table.insert(self._partyData, partyMemberInfo)
    if self._maxPartyMemberLevel < memberData._level then
      self._maxPartyMemberLevel = memberData._level
    end
    if self._minPartyMemberLevel > memberData._level then
      self._minPartyMemberLevel = memberData._level
    end
  end
  local sortFunc = function(a, b)
    return a._isSelf
  end
  table.sort(self._partyData, sortFunc)
end
function partyWidget:setMemberTexture(partyMemberCount)
  local isSelfMaster = RequestParty_isLeader()
  for index = 1, partyMemberCount do
    local memberControl = self._ui._static_PartyMember[index]
    local partyData = self._partyData[index]
    local characterValue = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. partyData._level .. " " .. partyData._name
    memberControl.control:SetShow(true)
    memberControl._staticText_CharacterValue:SetText(characterValue)
    memberControl._progress2_Hp:SetProgressRate(partyData._currentHp / partyData._maxHp)
    memberControl._progress2_Mp:SetProgressRate(partyData._currentMp / partyData._maxMp)
    self:setClassIcon(memberControl._static_ClassIcon, partyData._class)
    self:setClassMpBar(memberControl._progress2_Mp, partyData._class)
    if true == partyData._isSelf then
      self:setRootInfo(memberControl._staic_RootInfoIcon, partyData)
    end
    self:setStateIcon(memberControl, partyData)
  end
end
function partyWidget:setClassIcon(control, class)
  if nil == control then
    return
  end
  local iconTexture = self._config._textureClassSymbol[class]
  if nil == iconTexture then
    return
  end
  control:ChangeTextureInfoName(self._config._textureClassSymbol.path)
  local x1, y1, x2, y2 = setTextureUV_Func(control, iconTexture.x1, iconTexture.x2, iconTexture.y1, iconTexture.y2)
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function partyWidget:setClassMpBar(control, class)
  if nil == control then
    return
  end
  local colorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  if 0 == colorBlindMode then
    local mpBarTexture = self._config._textureMPBar[class]
    if nil == mpBarTexture then
      return
    end
    control:ChangeTextureInfoName(self._config._textureMPBar.path)
    local x1, y1, x2, y2 = setTextureUV_Func(control, mpBarTexture[1], mpBarTexture[2], mpBarTexture[3], mpBarTexture[4])
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif colorBlindMode >= 1 then
    control:ChangeTextureInfoName("Renewal/Progress/Console_Progressbar_02.dds")
    local xx1, yy1, xx2, yy2 = setTextureUV_Func(control, 314, 493, 487, 497)
    control:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
    control:setRenderTexture(control:getBaseTexture())
  end
end
function partyWidget:setRootInfo(control, partyData)
  if false == partyData._isSelf then
    return
  end
  local rootInfo = self._config._textureRootInfo
  local rootInfoTexture
  if self._maxPartyMemberLevel - self._minPartyMemberLevel >= 10 then
    rootInfoTexture = self._config._textureRootInfo[2]
    local x1, y1, x2, y2 = setTextureUV_Func(control, rootInfoTexture[1], rootInfoTexture[2], rootInfoTexture[3], rootInfoTexture[4])
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:SetShow(true)
  else
    if true == partyWidget.rootShowFlag then
      partyWidget.rootShowFlag = false
      TooltipSimple_Hide()
    end
    control:SetShow(false)
  end
end
function partyWidget:setStateIcon(memberControl, partyData)
  if nil == memberControl then
    return
  end
  local control = memberControl._staic_DistanceWifi
  local wifiTexture = self._config._textureWifi[partyData._distance + 1]
  if nil == wifiTexture then
    return
  end
  control:ChangeTextureInfoName(self._config._textureWifi.path)
  local x1, y1, x2, y2 = setTextureUV_Func(control, wifiTexture[1], wifiTexture[2], wifiTexture[3], wifiTexture[4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
  local isDead = partyData._currentHp <= 0
  control = memberControl._staic_DeadState
  control:SetShow(isDead)
  control = memberControl._progress2_Mp
  control:SetShow(not isDead)
  control = memberControl._progress2_Hp
  control:SetShow(not isDead)
  control = memberControl._static_ProgressBg
  control:SetShow(not isDead)
  control = memberControl._static_ClassIconLeaderBg
  control:SetShow(partyData._isMaster)
  control = memberControl._button_Option
  control:SetShow(RequestParty_isLeader() or partyData._isSelf)
  control = memberControl._staic_LeaderIcon
  control:SetShow(false)
  local posX = memberControl._staticText_CharacterValue:GetTextSizeX()
  posX = posX + memberControl._staticText_CharacterValue:GetPosX() + 10
  control:SetPosX(posX)
  control = memberControl._staic_Follow
  control:SetShow(not partyData._isSelf)
  control = memberControl._staic_DistanceWifi
  control:SetShow(not partyData._isSelf)
  local posX = memberControl._button_Option:GetPosX()
  if true == memberControl._button_Option:GetShow() then
    memberControl._staic_Follow:SetPosX(posX - 21)
    memberControl._staic_DistanceWifi:SetPosX(posX - 48)
  else
    memberControl._staic_Follow:SetPosX(posX)
    memberControl._staic_DistanceWifi:SetPosX(posX - 25)
  end
end
function ResponseParty_invite(hostName, invitePartyType)
  partyWidget:invite(hostName, invitePartyType)
end
function partyWidget:invite(hostName, invitePartyType)
  if true == self._inviteRequestPlayerList[hostName] then
    return
  end
  self._partyType = invitePartyType
  self._refuseName = hostName
  self._inviteRequestPlayerList[hostName] = true
  local function messageBox_party_accept()
    self._inviteRequestPlayerList = {}
    RequestParty_acceptInvite(self._partyType)
  end
  local function messageBox_party_refuse()
    RequestParty_refuseInvite()
    if true == self._inviteRequestPlayerList[self._refuseName] then
      self._inviteRequestPlayerList[self._refuseName] = nil
    end
  end
  local messageboxMemo = ""
  local messageboxData = ""
  if 0 == invitePartyType then
    messageboxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_INVITE_ACCEPT", "host_name", hostName)
    messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "PARTY_INVITE_MESSAGEBOX_TITLE"),
      content = messageboxMemo,
      functionYes = messageBox_party_accept,
      functionNo = messageBox_party_refuse,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
  else
    messageboxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LARGEPARTY_INVITE_ACCEPT", "host_name", hostName)
    messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_LARGEPARTY_INVITE_MESSAGEBOX_TITLE"),
      content = messageboxMemo,
      functionYes = messageBox_party_accept,
      functionNo = messageBox_party_refuse,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
  end
  MessageBox.showMessageBox(messageboxData, "top", false, true, 0)
end
function ResponseParty_refuse(reason)
  partyWidget:refuse(reason)
end
function partyWidget:refuse(reason)
  local contentString = reason
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = contentString,
    functionYes = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function ResponseParty_changeLeader(actorKey)
  partyWidget:changeLeader(actorKey)
end
function partyWidget:changeLeader(actorKey)
  local actorProxyWrapper = getActor(actorKey)
  if nil == actorProxyWrapper then
    return
  end
  local textName = actorProxyWrapper:getName()
  if CppEnums.PartyType.ePartyType_Normal == self._partyType then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_CHANGE_PARTY_LEADER", "text_name", tostring(textName)))
  else
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_CHANGE_PARTY_LEADER", "text_name", tostring(textName)))
  end
  self:updatePartyList()
  self:showRegistItem(false)
end
function PaGlobalFunc_PartyWidget_SelectChangeLeader(index)
  partyWidget:selectChangeLeader(index)
end
function partyWidget:selectChangeLeader(index)
  RequestParty_changeLeader(index)
  self:closePartyOption()
end
function ResponseParty_withdraw(withdrawType, actorKey, isMe)
  partyWidget:withdraw(withdrawType, actorKey, isMe)
end
function partyWidget:withdraw(withdrawType, actorKey, isMe)
  if ToClient_IsRequestedPvP() or ToClient_IsMyselfInEntryUser() then
    return
  end
  local partyType = self._partyType
  local message = ""
  if 0 == withdrawType then
    if isMe then
      if 0 == partyType then
        message = PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_LEAVE_PARTY_SELF")
      else
        message = PAGetString(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_LEAVE_PARTY_SELF")
      end
    else
      local actorProxyWrapper = getActor(actorKey)
      if nil ~= actorProxyWrapper then
        local textName = actorProxyWrapper:getOriginalName()
        if 0 == partyType then
          message = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_LEAVE_PARTY_MEMBER", "text_name", tostring(textName))
        else
          message = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_LEAVE_PARTY_MEMBER", "text_name", tostring(textName))
        end
      end
    end
  elseif 1 == withdrawType then
    if isMe then
      if 0 == partyType then
        message = PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT_SELF")
      else
        message = PAGetString(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_FORCEOUT_SELF")
      end
    else
      local actorProxyWrapper = getActor(actorKey)
      if nil ~= actorProxyWrapper then
        local textName = actorProxyWrapper:getOriginalName()
        if 0 == partyType then
          message = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT_MEMBER", "text_name", tostring(textName))
        else
          message = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_FORCEOUT_MEMBER", "text_name", tostring(textName))
        end
      end
    end
  elseif 2 == withdrawType then
    if 0 == partyType then
      message = PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_DISPERSE")
    else
      message = PAGetString(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_DISPERSE")
    end
  end
  NakMessagePanel_Reset()
  if "" ~= message and nil ~= message then
    Proc_ShowMessage_Ack(message)
  end
end
function PaGlobalFunc_PartyWidget_SelectWithDrawMember(index)
  partyWidget:selectWithdrawMember(index)
end
function partyWidget:selectWithdrawMember(index)
  local isPlayingPvPMatch = getSelfPlayer():isDefinedPvPMatch()
  if true == isPlayingPvPMatch then
    RequestParty_withdrawMember(index)
    return
  end
  local function partyOut()
    RequestParty_withdrawMember(index)
    FGlobal_PartyInventoryClose()
    self:closePartyOption()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_GETOUTPARTY")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = partyOut,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_PartyWidget_SelectBanishMember(index)
  partyWidget:banishMember(index)
end
function partyWidget:banishMember(index)
  self._withdrawMember = index
  local withdrawMemberData = RequestParty_getPartyMemberAt(self._withdrawMember)
  local withdrawMemberActorKey = withdrawMemberData:getActorKey()
  local withdrawMemberPlayerActor = getPlayerActor(withdrawMemberActorKey)
  local contentString = ""
  local titleForceOut = ""
  if CppEnums.PartyType.ePartyType_Normal == self._partyType then
    contentString = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT_QUESTION", "member_name", withdrawMemberData:name())
    titleForceOut = PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT")
  else
    contentString = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_FORCEOUT_QUESTION", "member_name", withdrawMemberData:name())
    titleForceOut = PAGetString(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_FORCEOUT")
  end
  local function messageBox_party_withdrawMember()
    local memberData = RequestParty_getPartyMemberAt(self._withdrawMember)
    RequestParty_withdrawMember(self._withdrawMember)
    if true == getSelfPlayer():isDefinedPvPMatch() then
      return
    end
  end
  local messageboxData = {
    title = titleForceOut,
    content = contentString,
    functionYes = messageBox_party_withdrawMember,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
  self:closePartyOption()
end
function PaGlobalFunc_PartyWidget_SelectPartyOption(index)
  partyWidget:selectPartyOption(index)
end
function partyWidget:selectPartyOption(index)
  local partyData = self._partyData[index]
  local control = self._ui._static_PartyMember[index]
  self:closePartyOption()
  self._ui._checkButton_DropItem:SetCheck(false)
  self:showLootingType()
  if self._lastSelectUser == index then
    self._lastSelectUser = nil
  else
    if partyData._isSelf == true then
      control._button_Leave:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_SelectWithDrawMember(" .. partyData._index .. ")")
      control._button_Leave:SetShow(true)
    elseif RequestParty_isLeader() == true then
      control._button_ForceOut:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_SelectBanishMember(" .. partyData._index .. ")")
      control._button_SetLeader:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_SelectChangeLeader(" .. partyData._index .. ")")
      control._button_ForceOut:SetShow(true)
      control._button_SetLeader:SetShow(true)
    end
    self._lastSelectUser = index
  end
end
function PaGlobalFunc_PartyWidget_ClosePartyOption(index)
  partyWidget:closePartyOption(index)
end
function partyWidget:closePartyOption(index)
  if nil ~= index then
    local control = self._ui._static_PartyMember[index]
    control._button_Leave:SetShow(false)
    control._button_ForceOut:SetShow(false)
    control._button_SetLeader:SetShow(false)
  else
    for index = 1, self._config._maxPartyMemberCount do
      local control = self._ui._static_PartyMember[index]
      control._button_Leave:SetShow(false)
      control._button_ForceOut:SetShow(false)
      control._button_SetLeader:SetShow(false)
    end
  end
end
function PaGlobalFunc_PartyWidget_SelectPartyFollow(index)
  partyWidget:selectPartyFollow(index)
end
function partyWidget:selectPartyFollow(index)
  index = self._partyData[index]._index
  local selfPlayer = getSelfPlayer()
  local memberData = RequestParty_getPartyMemberAt(index)
  if nil ~= memberData then
    _PA_LOG("\236\157\180\235\139\164\237\152\156", "!!!!!!!!!")
    local actorKey = memberData:getActorKey()
    selfPlayer:setFollowActor(actorKey)
  end
end
function PaGlobalFunc_PartyWidget_ShowSimpleTooltip(isShow, tipType, index)
  if 4 == tipType then
    if true == isShow then
      partyWidget.rootShowFlag = true
    else
      partyWidget.rootShowFlag = false
    end
  end
  partyWidget:showSimpleTooltip(isShow, tipType, index)
end
function partyWidget:showSimpleTooltip(isShow, tipType, index)
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "INTERACTION_BTN_FOLLOW_ACTOR")
    control = self._ui._static_PartyMember[index]._staic_Follow
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_DISTANCE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_DISTANCE_DESC")
    control = self._ui._static_PartyMember[index]._staic_DistanceWifi
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_PENALTY_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_PENALTY_DESC")
  elseif 4 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_PENALTY_ROOTNAME_NO")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_PENALTY_ROOTDESC")
    control = self._ui._static_PartyMember[index]._staic_RootInfoIcon
  else
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PARTYLIST_PARTYLEADERTITLE")
    control = self._ui._static_PartyMember[index]._staic_LeaderIcon
  end
  registTooltipControl(control, Panel_Tooltip_SimpleText)
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobalFunc_PartyWidget_ShowSepcialGoodsToolTip(btnType, isShow)
  partyWidget:showSpecialGoodsTooltip(btnType, isShow)
end
function partyWidget:showSpecialGoodsTooltip(btnType, isShow)
  local itemCount = ToClient_requestGetMySellInfoCount()
  local msg = ""
  local control
  if 1 == btnType then
    control = self._ui._button_MarketOption
    if 0 < Int64toInt32(RequestParty_getDistributionPrice()) then
      if 0 < RequestParty_getDistributionGrade() and RequestParty_getDistributionGrade() < 5 then
        msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_HIGHSILVER", "getDistributionPrice", makeDotMoney(RequestParty_getDistributionPrice())) .. ", " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_HIGHGRADE", "getDistributionGrade", self._config._itemGradeString[RequestParty_getDistributionGrade()])
      else
        msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_HIGHSILVER", "getDistributionPrice", makeDotMoney(RequestParty_getDistributionPrice()))
      end
    elseif 0 < RequestParty_getDistributionGrade() and RequestParty_getDistributionGrade() < 5 then
      msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_HIGHGRADE2", "getDistributionGrade", self._config._itemGradeString[RequestParty_getDistributionGrade()])
    else
      msg = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_NOT_OPTION_SETTING")
    end
  elseif 2 == btnType then
    control = self._ui._button_SpecialItem
    msg = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_REGISTITEM_VIEW")
  end
  registTooltipControl(control, Panel_Tooltip_SimpleText)
  if true == isShow then
    TooltipSimple_Show(control, msg, nil)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobalFunc_PartyWidget_RenderModeChange(prevRenderModeList, nextRenderModeList)
  partyWidget:renderModeChange(prevRenderModeList, nextRenderModeList)
end
function partyWidget:renderModeChange(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  if 0 == RequestParty_getPartyMemberCount() then
    self:resetData()
    self:close()
  else
    PaGlobalFunc_PartyWidget_Open()
  end
end
function PaGlobalFunc_PartyWidget_SetScreenSize()
  if not partyWidget._isInitailized then
    return
  end
  if 0 == RequestParty_getPartyMemberCount() then
    partyWidget:resetData()
    partyWidget:close()
  else
    if not isFlushedUI() then
      PaGlobalFunc_PartyWidget_Open()
    end
    partyWidget:updatePartyList()
  end
  partyWidget:setScreenSize()
end
function partyWidget:setScreenSize()
  if not self._isInitailized then
    return
  end
  local initPosX = 10
  local initPosY = 200
  if nil ~= PaGlobal_AreaOfHadum_IsDefaultPos and true == PaGlobal_AreaOfHadum_IsDefaultPos() and nil ~= Panel_Widget_AreaOfHadum and true == Panel_Widget_AreaOfHadum:GetShow() then
    initPosY = Panel_Widget_AreaOfHadum:GetPosY() + Panel_Widget_AreaOfHadum:GetSizeY() + 10
  end
  if Panel_Widget_Party:GetRelativePosX() == -1 or Panel_Widget_Party:GetRelativePosY() == -1 then
    changePositionBySever(Panel_Widget_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
    FGlobal_InitPanelRelativePos(Panel_Widget_Party, initPosX, initPosY)
  elseif Panel_Widget_Party:GetRelativePosX() == 0 or Panel_Widget_Party:GetRelativePosY() == 0 then
    Panel_Widget_Party:SetPosX(initPosX)
    Panel_Widget_Party:SetPosY(initPosY)
  else
    Panel_Widget_Party:SetPosX(getScreenSizeX() * Panel_Widget_Party:GetRelativePosX() - Panel_Widget_Party:GetSizeX() / 2)
    Panel_Widget_Party:SetPosY(getScreenSizeY() * Panel_Widget_Party:GetRelativePosY() - Panel_Widget_Party:GetSizeY() / 2)
  end
  self._ui._static_OptionBg:ComputePos()
  FGlobal_PanelRepostionbyScreenOut(Panel_Widget_Party)
end
function FGlobal_Party_ConditionalShow()
  partyWidget:partyConditionalShow()
end
function partyWidget:partyConditionalShow()
  if 0 == RequestParty_getPartyMemberCount() then
    Panel_Widget_Party:SetShow(false)
    self:resetData()
  else
    Panel_Widget_Party:SetShow(true)
    self:updatePartyList()
  end
end
function FromClient_PartyWidget_luaLoadComplete()
  partyWidget:initialize()
end
function PartyOption_Hide()
  partyWidget:showRegistItem(false)
  partyWidget:closePartyOption()
  partyWidget._ui._checkButton_DropItem:SetCheck(false)
  partyWidget:showLootingType()
end
function FromClient_UpdatePartyExperiencePenalty(isPenalty)
  if nil == isPenalty then
    return
  end
end
function PartyPanel_Repos()
end
function FromClient_NotifyPartyMemberPickupItem(userName, itemName)
  local message = ""
  message = PAGetStringParam2(Defines.StringSheet_GAME, "GAME_MESSAGE_NOTIFY_PARTYMEMBER_PICKUP_ITEM", "userName", userName, "itemName", itemName)
  Proc_ShowMessage_Ack_With_ChatType(message, nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.PartyItem)
end
function FromClient_NotifyPartyMemberPickupItemFromPartyInventory(userName, itemName, itemCount)
  local message = ""
  message = PAGetStringParam3(Defines.StringSheet_GAME, "GAME_MESSAGE_NOTIFY_PARTYMEMBER_PICKUP_ITEM_FOR_PARTYINVENTORY", "userName", userName, "itemName", itemName, "itemCount", tostring(itemCount))
  Proc_ShowMessage_Ack_With_ChatType(message, nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.PartyItem)
end
function partyWidget:registEventHandler()
  registerEvent("FromClient_luaLoadComplete", "FromClient_PartyWidget_luaLoadComplete")
  registerEvent("ResponseParty_createPartyList", "ResponseParty_createPartyList")
  registerEvent("ResponseParty_updatePartyList", "ResponseParty_updatePartyList")
  registerEvent("ResponseParty_invite", "ResponseParty_invite")
  registerEvent("ResponseParty_refuse", "ResponseParty_refuse")
  registerEvent("ResponseParty_changeLeader", "ResponseParty_changeLeader")
  registerEvent("ResponseParty_withdraw", "ResponseParty_withdraw")
  registerEvent("FromClient_GroundMouseClick", "PartyOption_Hide")
  registerEvent("onScreenResize", "PaGlobalFunc_PartyWidget_SetScreenSize")
  registerEvent("FromClient_UpdatePartyExperiencePenalty", "FromClient_UpdatePartyExperiencePenalty")
  registerEvent("FromClient_NotifyPartyMemberPickupItem", "FromClient_NotifyPartyMemberPickupItem")
  registerEvent("FromClient_NotifyPartyMemberPickupItemFromPartyInventory", "FromClient_NotifyPartyMemberPickupItemFromPartyInventory")
  registerEvent("FromClient_RenderModeChangeState", "PaGlobalFunc_PartyWidget_RenderModeChange")
end
changePositionBySever(Panel_Widget_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
partyWidget:registEventHandler()
