Panel_Party:ActiveMouseEventEffect(true)
Panel_Party:SetShow(false, false)
Panel_PartyOption:SetShow(false, false)
Panel_Party:RegisterShowEventFunc(true, "PartyShowAni()")
Panel_Party:RegisterShowEventFunc(false, "PartyHideAni()")
Panel_PartyOption:RegisterShowEventFunc(true, "PartyOptionShowAni()")
Panel_PartyOption:RegisterShowEventFunc(false, "PartyOptionHideAni()")
local isContentsEnable = ToClient_IsContentsGroupOpen("38")
local isLargePartyOpen = ToClient_IsContentsGroupOpen("286")
local CT2S = CppEnums.ClassType2String
local PLT = CppEnums.PartyLootType
local PLT2S = CppEnums.PartyLootType2String
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local PP = CppEnums.PAUIMB_PRIORITY
local UI_color = Defines.Color
local UI_Class = CppEnums.ClassType
local registMarket = true
local _last_Index
local _partyData = {}
local withdrawMember
local requestPlayerList = {}
local refuseName = ""
local isMainChannel, isDevServer
local partyType = 0
local controlTemplate = {
  _styleLeaderIcon = UI.getChildControl(Panel_Party, "Static_Icon_Leader"),
  _styleBackGround = UI.getChildControl(Panel_Party, "Static_ClassSlot"),
  _styleClassIcon = UI.getChildControl(Panel_Party, "Static_Icon_Class"),
  _styleUserName = UI.getChildControl(Panel_Party, "StaticText_UserName"),
  _styleHpBG = UI.getChildControl(Panel_Party, "Static_HpBG"),
  _styleHp = UI.getChildControl(Panel_Party, "Progress2_Hp"),
  _styleMp = UI.getChildControl(Panel_Party, "Progress2_Mp"),
  _styleUserLevel = UI.getChildControl(Panel_Party, "StaticText_UserLevel"),
  _styleConditionBG = UI.getChildControl(Panel_Party, "Static_DeadConditionBG"),
  _styleConditionTxt = UI.getChildControl(Panel_Party, "StaticText_NowCondition"),
  _stylePartyOptionBtn = UI.getChildControl(Panel_Party, "Button_Option"),
  _styleFollowBtn = UI.getChildControl(Panel_Party, "Button_Follow"),
  _distance = UI.getChildControl(Panel_Party, "Static_Distance")
}
local partyMarketOption = UI.getChildControl(Panel_Party, "Static_MarketOption")
partyMarketOption:addInputEvent("Mouse_On", "Show_Tooltips_SpecialGoods( " .. 1 .. ", true )")
partyMarketOption:addInputEvent("Mouse_Out", "Show_Tooltips_SpecialGoods( " .. 1 .. ", false )")
partyMarketOption:SetShow(registMarket)
local btnSpecialGoods = UI.getChildControl(Panel_Party, "Static_RegistSpecialGoods")
btnSpecialGoods:addInputEvent("Mouse_On", "Show_Tooltips_SpecialGoods( " .. 2 .. ", true )")
btnSpecialGoods:addInputEvent("Mouse_Out", "Show_Tooltips_SpecialGoods( " .. 2 .. ", false )")
btnSpecialGoods:SetShow(registMarket)
local partyPenalty = UI.getChildControl(Panel_Party, "Static_Penalty")
partyPenalty:addInputEvent("Mouse_On", "PartyPop_SimpleTooltip_Show( true, 2)")
partyPenalty:addInputEvent("Mouse_Out", "PartyPop_SimpleTooltip_Show( false, 2 )")
partyPenalty:setTooltipEventRegistFunc("PartyPop_SimpleTooltip_Show( true, 2)")
partyPenalty:SetShow(false)
local _tooltipBg = UI.getChildControl(Panel_Party, "Static_TooltipBG")
local _tooltipText = UI.getChildControl(Panel_Party, "Tooltip_Name")
local registItem = {
  _bg = UI.getChildControl(Panel_Party, "Static_MarketOptionBg"),
  _checkMoney = UI.getChildControl(Panel_Party, "CheckButton_Money"),
  _checkGrade = UI.getChildControl(Panel_Party, "CheckButton_Grade"),
  _moneyValue = UI.getChildControl(Panel_Party, "StaticText_MoneyValue"),
  _comboBox = UI.getChildControl(Panel_Party, "Combobox_MarketGrade"),
  _option = UI.getChildControl(Panel_Party, "Static_Option"),
  _btnAdmin = UI.getChildControl(Panel_Party, "Button_Admin"),
  _btnCancel = UI.getChildControl(Panel_Party, "Button_Cancel")
}
registItem._option:addInputEvent("Mouse_LUp", "Party_RegistItem_ChangeMoney()")
registItem._comboBox:setListTextHorizonCenter()
registItem._comboBox:addInputEvent("Mouse_LUp", "Party_RegistItem_ShowComboBox()")
registItem._comboBox:GetListControl():addInputEvent("Mouse_LUp", "Party_RegistItem_SetGrade()")
registItem._btnAdmin:addInputEvent("Mouse_LUp", "Party_RegistItem_Set()")
registItem._btnCancel:addInputEvent("Mouse_LUp", "Party_RegistItem_Show( false )")
registItem._bg:AddChild(registItem._checkMoney)
registItem._bg:AddChild(registItem._checkGrade)
registItem._bg:AddChild(registItem._moneyValue)
registItem._bg:AddChild(registItem._comboBox)
registItem._bg:AddChild(registItem._option)
registItem._bg:AddChild(registItem._btnAdmin)
registItem._bg:AddChild(registItem._btnCancel)
Panel_Party:RemoveControl(registItem._checkMoney)
Panel_Party:RemoveControl(registItem._checkGrade)
Panel_Party:RemoveControl(registItem._moneyValue)
Panel_Party:RemoveControl(registItem._comboBox)
Panel_Party:RemoveControl(registItem._option)
Panel_Party:RemoveControl(registItem._btnAdmin)
Panel_Party:RemoveControl(registItem._btnCancel)
registItem._bg:SetChildIndex(registItem._comboBox, 9999)
local bgSizeX = registItem._bg:GetSizeX()
local optionPosX = registItem._option:GetPosX()
local moneyValuePosX = registItem._moneyValue:GetPosX()
local comboBoxPosX = registItem._comboBox:GetPosX()
local btnAdminPosX = registItem._btnAdmin:GetPosX()
local btnCancelPosX = registItem._btnCancel:GetPosX()
local function registItem_Resize()
  local plusSizeX = 0
  if isGameTypeRussia() then
    plusSizeX = 50
  elseif isGameTypeEnglish() then
    plusSizeX = 50
  end
  registItem._bg:SetSize(bgSizeX + plusSizeX, registItem._bg:GetSizeY())
  registItem._option:SetPosX(optionPosX + plusSizeX)
  registItem._moneyValue:SetPosX(moneyValuePosX + plusSizeX)
  registItem._comboBox:SetPosX(comboBoxPosX + plusSizeX)
  registItem._btnAdmin:SetPosX(btnAdminPosX + plusSizeX / 2)
  registItem._btnCancel:SetPosX(btnCancelPosX + plusSizeX / 2)
end
registItem_Resize()
local itemGrade = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_NOT_SETTING"),
  PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ITEMGRADE_GREEN"),
  PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ITEMGRADE_BLUE"),
  PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ITEMGRADE_YELLOW"),
  PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ITEMGRADE_ORANGE")
}
local _grade = 0
local _baseMoney, _money = toInt64(0, 1000000)
function Party_RegistItem_ChangeMoney()
  Panel_NumberPad_Show(true, toInt64(0, 100000000), param0, setMoney)
end
function setMoney(inputNum)
  local _inputNum
  if 100000000 < Int64toInt32(inputNum) then
    _inputNum = toInt64(0, 100000000)
  elseif Int64toInt32(inputNum) < 1000000 then
    _inputNum = _baseMoney
  else
    _inputNum = inputNum
  end
  _money = _inputNum
  registItem._moneyValue:SetText("<PAColor0xffe7d583>" .. makeDotMoney(_inputNum) .. "<PAOldColor>")
end
function Party_RegistItem_ShowComboBox()
  Party_RegistItem_PopOption()
end
function Party_RegistItem_PopOption()
  local self = registItem
  self._comboBox:DeleteAllItem()
  for ii = 0, #itemGrade do
    self._comboBox:AddItem(itemGrade[ii], ii)
  end
  self._comboBox:ToggleListbox()
  self._comboBox:SetShow(true)
end
function Party_RegistItem_SetGrade()
  local self = registItem
  self._comboBox:SetSelectItemIndex(self._comboBox:GetSelectIndex())
  self._comboBox:ToggleListbox()
end
function Party_RegistItem_Show(isShow)
  local self = registItem
  if nil == isShow then
    self._bg:SetShow(not self._bg:GetShow())
  else
    self._bg:SetShow(isShow)
  end
  local isPartyLeader = RequestParty_isLeader()
  self._checkGrade:SetEnable(isPartyLeader)
  self._checkMoney:SetEnable(isPartyLeader)
  self._option:SetEnable(isPartyLeader)
  self._comboBox:SetEnable(isPartyLeader)
  if isPartyLeader then
    self._btnAdmin:SetShow(true)
    self._btnCancel:SetShow(true)
    self._bg:SetSize(self._bg:GetSizeX(), 75)
  else
    self._btnAdmin:SetShow(false)
    self._btnCancel:SetShow(false)
    self._bg:SetSize(self._bg:GetSizeX(), 45)
  end
  _money = RequestParty_getDistributionPrice()
  if toInt64(0, 0) ~= _money then
    self._moneyValue:SetText("<PAColor0xffe7d583>" .. makeDotMoney(_money) .. "<PAOldColor>")
    self._checkMoney:SetCheck(true)
  else
    self._moneyValue:SetText("<PAColor0xffe7d583>" .. makeDotMoney(_baseMoney) .. "<PAOldColor>")
    self._checkMoney:SetCheck(false)
  end
  self._comboBox:DeleteAllItem()
  for ii = 0, #itemGrade do
    self._comboBox:AddItem(itemGrade[ii], ii)
  end
  if 0 < RequestParty_getDistributionGrade() and RequestParty_getDistributionGrade() < 5 then
    self._comboBox:SetSelectItemIndex(RequestParty_getDistributionGrade())
    self._comboBox:SetText(itemGrade[RequestParty_getDistributionGrade()])
    self._checkGrade:SetCheck(true)
  else
    self._comboBox:SetSelectItemIndex(0)
    self._checkGrade:SetCheck(false)
  end
end
Party_RegistItem_Show(false)
function Party_RegistItem_Option_Init()
  local self = registItem
  self._checkMoney:SetCheck(false)
  self._checkGrade:SetCheck(false)
  self._moneyValue:SetText("<PAColor0xffe7d583>" .. makeDotMoney(_money) .. "<PAOldColor>")
  self._comboBox:SetSelectItemIndex(0)
end
function Party_RegistItem_Set()
  local self = registItem
  local price, grade
  if self._checkMoney:IsCheck() then
    price = toInt64(0, math.max(Int64toInt32(_money), Int64toInt32(_baseMoney)))
  else
    price = toInt64(0, 0)
  end
  if self._checkGrade:IsCheck() then
    grade = self._comboBox:GetSelectIndex()
  else
    grade = 5
    self._comboBox:SetSelectItemIndex(0)
  end
  if 0 < self._comboBox:GetSelectIndex() and self._comboBox:GetSelectIndex() < 5 then
    self._comboBox:SetSelectItemIndex(self._comboBox:GetSelectIndex())
  else
    grade = 5
    self._comboBox:SetSelectItemIndex(0)
  end
  RequestParty_changeDistributionOption(price, grade)
  Party_RegistItem_Show(false)
end
Party_RegistItem_Option_Init()
function Show_Tooltips_SpecialGoods(btnType, isShow)
  local itemCount = ToClient_requestGetMySellInfoCount()
  local self = registItem
  local msg
  if 1 == btnType then
    if 0 < Int64toInt32(RequestParty_getDistributionPrice()) then
      if 0 < RequestParty_getDistributionGrade() and RequestParty_getDistributionGrade() < 5 then
        msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_HIGHSILVER", "getDistributionPrice", makeDotMoney(RequestParty_getDistributionPrice())) .. ", " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_HIGHGRADE", "getDistributionGrade", itemGrade[RequestParty_getDistributionGrade()])
      else
        msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_HIGHSILVER", "getDistributionPrice", makeDotMoney(RequestParty_getDistributionPrice()))
      end
    elseif 0 < RequestParty_getDistributionGrade() and RequestParty_getDistributionGrade() < 5 then
      msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_HIGHGRADE2", "getDistributionGrade", itemGrade[RequestParty_getDistributionGrade()])
    else
      msg = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_NOT_OPTION_SETTING")
    end
  elseif 2 == btnType then
    msg = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_REGISTITEM_VIEW")
  end
  _tooltipBg:SetShow(isShow)
  _tooltipText:SetShow(isShow)
  _tooltipText:SetText(msg)
  _tooltipBg:SetSize(_tooltipText:GetTextSizeX() + 10, _tooltipBg:GetSizeY())
end
function Party_ShowMessageAlert()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_ONLY_MASTER"))
end
controlTemplate._styleBackGround:SetShow(false)
controlTemplate._styleUserName:SetShow(false)
controlTemplate._styleHpBG:SetShow(false)
controlTemplate._styleHp:SetShow(false)
controlTemplate._styleUserLevel:SetShow(false)
controlTemplate._styleClassIcon:SetShow(false)
controlTemplate._styleLeaderIcon:SetShow(false)
controlTemplate._styleConditionBG:SetShow(false)
controlTemplate._styleConditionTxt:SetShow(false)
controlTemplate._stylePartyOptionBtn:SetShow(false)
controlTemplate._styleFollowBtn:SetShow(false)
controlTemplate._distance:SetShow(false)
local Match_Button_Info = UI.getChildControl(Panel_Party, "Match_Button_MatchInfo")
local _styleLootType = UI.getChildControl(Panel_Party, "StaticText_LootType")
local _uiComboLootingOption = UI.getChildControl(Panel_Party, "Combobox_Looting_Option")
local _comboBoxList = UI.getChildControl(_uiComboLootingOption, "Combobox_List")
_styleLootType:SetShow(false)
_uiComboLootingOption:SetShow(true)
_uiComboLootingOption:setListTextHorizonCenter()
Panel_Party:SetChildIndex(_uiComboLootingOption, 9999)
local _uiPartyMemberList = {}
_maxPartyMemberCount = 5
local _preLootType
local _uiButtonChangeLeader = UI.getChildControl(Panel_PartyOption, "Button_Change_Leader")
local _uiButtonWithdrawMember = UI.getChildControl(Panel_PartyOption, "Button_Withdraw_Member")
if isContentsEnable then
  isMainChannel = getCurrentChannelServerData()._isMain
  isDevServer = ToClient_IsDevelopment()
end
local closePartyOption = function()
  Panel_PartyOption:SetShow(false)
end
function PartyShowAni()
end
function PartyHideAni()
end
function PartyOptionShowAni()
  UIAni.fadeInSCR_Down(Panel_PartyOption)
end
function PartyOptionHideAni()
  Panel_PartyOption:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_PartyOption:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
  local aniInfo2 = Panel_PartyOption:addScaleAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo2:SetStartScale(1)
  aniInfo2:SetEndScale(0.97)
  aniInfo2.AxisX = 200
  aniInfo2.AxisY = 295
  aniInfo2.IsChangeChild = true
end
function Looting_ComboBox()
  if false == RequestParty_isLeader() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ONLYLEADERCHANGE"))
    return
  end
  PartyPop_onLootingOptionUI()
  local lootingList = _uiComboLootingOption:GetListControl()
  lootingList:addInputEvent("Mouse_LUp", "changeLooting()")
  _uiComboLootingOption:ToggleListbox()
end
function changeLooting()
  local selectKey = _uiComboLootingOption:GetSelectKey()
  _uiComboLootingOption:SetSelectItemIndex(selectKey)
  RequestParty_changeLooting(selectKey)
end
local function createPartyControls()
  for index = 0, _maxPartyMemberCount - 1 do
    local partyMember = {}
    partyMember._base = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Party, "PartyMember_Back" .. index)
    partyMember._leader = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, partyMember._base, "PartyMember_Leader" .. index)
    partyMember._name = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, partyMember._base, "PartyMember_UserName" .. index)
    partyMember._class = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, partyMember._base, "PartyMember_Class" .. index)
    partyMember._hpBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, partyMember._base, "PartyMember_HpBG" .. index)
    partyMember._hp = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_PROGRESS2, partyMember._base, "PartyMember_Hp" .. index)
    partyMember._mp = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_PROGRESS2, partyMember._base, "PartyMember_Mp" .. index)
    partyMember._level = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, partyMember._base, "PartyMember_UserLevel" .. index)
    partyMember._conditionBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, partyMember._base, "PartyMember_ConditionBG" .. index)
    partyMember._stylePartyOptionBtn = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, partyMember._base, "PartyMember_OptionBtn" .. index)
    partyMember._styleFollowBtn = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, partyMember._base, "PartyMember_FollowBtn" .. index)
    partyMember._distance = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, partyMember._base, "PartyMember_Distance" .. index)
    partyMember._conditionTxt = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, partyMember._base, "PartyMember_ConditionTxt" .. index)
    CopyBaseProperty(controlTemplate._styleLeaderIcon, partyMember._leader)
    CopyBaseProperty(controlTemplate._styleUserName, partyMember._name)
    CopyBaseProperty(controlTemplate._styleBackGround, partyMember._base)
    CopyBaseProperty(controlTemplate._styleClassIcon, partyMember._class)
    CopyBaseProperty(controlTemplate._styleHpBG, partyMember._hpBG)
    CopyBaseProperty(controlTemplate._styleHp, partyMember._hp)
    CopyBaseProperty(controlTemplate._styleMp, partyMember._mp)
    CopyBaseProperty(controlTemplate._styleUserLevel, partyMember._level)
    CopyBaseProperty(controlTemplate._styleConditionBG, partyMember._conditionBG)
    CopyBaseProperty(controlTemplate._stylePartyOptionBtn, partyMember._stylePartyOptionBtn)
    CopyBaseProperty(controlTemplate._styleFollowBtn, partyMember._styleFollowBtn)
    CopyBaseProperty(controlTemplate._distance, partyMember._distance)
    CopyBaseProperty(controlTemplate._styleConditionTxt, partyMember._conditionTxt)
    partyMember._leader:SetShow(false)
    partyMember._name:SetShow(true)
    partyMember._base:SetShow(true)
    partyMember._class:SetShow(true)
    partyMember._hpBG:SetShow(true)
    partyMember._hp:SetShow(true)
    partyMember._mp:SetShow(true)
    partyMember._level:SetShow(true)
    partyMember._conditionBG:SetShow(true)
    partyMember._conditionTxt:SetShow(true)
    partyMember._base:SetAlpha(0.7)
    partyMember._base:SetShow(true)
    partyMember._base:SetPosY(index * partyMember._base:GetSizeY() * 1.08)
    partyMember._name:SetIgnore(true)
    partyMember._class:SetIgnore(true)
    partyMember._hpBG:SetIgnore(true)
    partyMember._hp:SetIgnore(true)
    partyMember._mp:SetIgnore(true)
    partyMember._level:SetIgnore(true)
    partyMember._leader:SetIgnore(true)
    partyMember._conditionBG:SetIgnore(true)
    partyMember._conditionTxt:SetIgnore(true)
    partyMember._stylePartyOptionBtn:addInputEvent("Mouse_LUp", "PartyPop_clickPartyOption(" .. index .. ")")
    partyMember._styleFollowBtn:addInputEvent("Mouse_LUp", "PartyPop_clickPartyFollow(" .. index .. ")")
    partyMember._styleFollowBtn:addInputEvent("Mouse_On", "PartyPop_SimpleTooltip_Show(true, 0, " .. index .. ")")
    partyMember._styleFollowBtn:addInputEvent("Mouse_Out", "PartyPop_SimpleTooltip_Show(false, 0, " .. index .. ")")
    partyMember._styleFollowBtn:setTooltipEventRegistFunc("PartyPop_SimpleTooltip_Show(true, 0, " .. index .. ")")
    _uiPartyMemberList[index] = partyMember
  end
  Panel_Party:SetChildIndex(_styleLootType, Panel_Party:GetChildSize())
end
createPartyControls()
local _partyMemberCount = RequestParty_getPartyMemberCount()
function ResponseParty_createPartyList()
  local partyMemberCount = RequestParty_getPartyMemberCount()
  if partyMemberCount > 0 then
    partyType = ToClient_GetPartyType()
    if CppEnums.PartyType.ePartyType_Normal == partyType then
      if not isFlushedUI() then
        Panel_Party:SetShow(true, false)
      end
      table.remove(requestPlayerList)
      ResponseParty_updatePartyList()
      _partyMemberCount = partyMemberCount
      Party_RegistItem_Show(false)
      ToClient_requestListMySellInfo()
      Panel_LargeParty:SetShow(false)
    elseif CppEnums.PartyType.ePartyType_Large == partyType then
      Panel_LargeParty:SetShow(true)
      PaGlobal_LargeParty:Update()
      Panel_Party:SetShow(false)
    end
  end
end
local savedPrice = toInt64(0, 0)
local savedGrade = 0
local firstCheck = 0
local isSelfMaster = false
function FGlobal_ResponseParty_PartyMemberSet(partyMemberCount)
  local _idx = 0
  local partyData = {}
  for index = 0, partyMemberCount - 1 do
    local idx = 0
    local memberData = RequestParty_getPartyMemberAt(index)
    if true == RequestParty_isSelfPlayer(index) then
      idx = 0
    else
      idx = _idx + 1
      _idx = idx
    end
    partyData[idx] = {
      _index = index,
      _isMaster = memberData._isMaster,
      _isSelf = RequestParty_isSelfPlayer(index),
      _name = memberData:name(),
      _class = memberData:classType(),
      _level = memberData._level,
      _nowHp = memberData._hp * 100,
      _maxHp = memberData._maxHp,
      _nowMp = memberData._mp * 100,
      _maxMp = memberData._maxMp,
      _distance = memberData:getExperienceGrade()
    }
    if true == partyData[idx]._isSelf and true == partyData[idx]._isMaster then
      isSelfMaster = true
    end
  end
  return partyData
end
function ResponseParty_PartyMemberTextureSet(partyData, partyMemberCount, index)
  local _partyData = partyData
  local classTypeTexture
  local classMP = ""
  _uiPartyMemberList[index]._hpBG:SetShow(true)
  if index <= partyMemberCount - 1 and nil ~= _partyData[index] then
    _uiPartyMemberList[index]._name:SetText(_partyData[index]._name)
    _uiPartyMemberList[index]._level:SetText(_partyData[index]._level)
    _uiPartyMemberList[index]._hp:SetProgressRate(_partyData[index]._nowHp / _partyData[index]._maxHp)
    _uiPartyMemberList[index]._mp:SetProgressRate(_partyData[index]._nowMp / _partyData[index]._maxMp)
    if true == isSelfMaster or true == _partyData[index]._isSelf then
      local spanSizeX = _uiPartyMemberList[index]._name:GetTextSizeX() + _uiPartyMemberList[index]._name:GetPosX()
      _uiPartyMemberList[index]._stylePartyOptionBtn:SetSpanSize(-185, _uiPartyMemberList[index]._stylePartyOptionBtn:GetSpanSize().y)
      if isContentsEnable then
        _uiPartyMemberList[index]._stylePartyOptionBtn:SetShow(true)
      else
        _uiPartyMemberList[index]._stylePartyOptionBtn:SetShow(true)
      end
    else
      _uiPartyMemberList[index]._stylePartyOptionBtn:SetShow(false)
    end
    classTypeTexture = "new_ui_common_forlua/widget/party/portrait_" .. CT2S[_partyData[index]._class] .. ".dds"
    if _partyData[index]._class == 4 or _partyData[index]._class == 29 then
      classMP = "new_ui_common_forlua/default/Default_Gauges.dds"
      _uiPartyMemberList[index]._mp:ChangeTextureInfoNameAsync(classMP)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._mp, 1, 70, 233, 76)
      _uiPartyMemberList[index]._mp:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._mp:setRenderTexture(_uiPartyMemberList[index]._mp:getBaseTexture())
    elseif _partyData[index]._class == 8 or _partyData[index]._class == 16 or _partyData[index]._class == 28 or _partyData[index]._class == 31 then
      classMP = "new_ui_common_forlua/default/Default_Gauges.dds"
      _uiPartyMemberList[index]._mp:ChangeTextureInfoNameAsync(classMP)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._mp, 1, 63, 233, 69)
      _uiPartyMemberList[index]._mp:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._mp:setRenderTexture(_uiPartyMemberList[index]._mp:getBaseTexture())
    elseif _partyData[index]._class == 24 then
      classMP = "new_ui_common_forlua/default/Default_Gauges.dds"
      _uiPartyMemberList[index]._mp:ChangeTextureInfoNameAsync(classMP)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._mp, 2, 250, 232, 255)
      _uiPartyMemberList[index]._mp:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._mp:setRenderTexture(_uiPartyMemberList[index]._mp:getBaseTexture())
    elseif _partyData[index]._class == 0 or _partyData[index]._class == 12 or _partyData[index]._class == 20 or _partyData[index]._class == 21 or _partyData[index]._class == 25 or _partyData[index]._class == 26 or _partyData[index]._class == 19 or _partyData[index]._class == 23 then
      classMP = "new_ui_common_forlua/default/Default_Gauges.dds"
      _uiPartyMemberList[index]._mp:ChangeTextureInfoNameAsync(classMP)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._mp, 1, 56, 233, 62)
      _uiPartyMemberList[index]._mp:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._mp:setRenderTexture(_uiPartyMemberList[index]._mp:getBaseTexture())
    elseif _partyData[index]._class == 27 then
      classMP = "new_ui_common_forlua/default/Default_Gauges.dds"
      _uiPartyMemberList[index]._mp:ChangeTextureInfoNameAsync(classMP)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._mp, 206, 214, 255, 217)
      _uiPartyMemberList[index]._mp:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._mp:setRenderTexture(_uiPartyMemberList[index]._mp:getBaseTexture())
    end
    if _partyData[index]._class == __eClassType_Warrior then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 77, 25, 107, 55)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_ElfRanger then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 108, 25, 138, 55)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_Sorcerer then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 139, 25, 169, 55)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_Giant then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 170, 25, 200, 55)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_Tamer then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 167, 56, 197, 86)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_BladeMaster then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 198, 56, 228, 86)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_BladeMasterWoman then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 198, 87, 228, 117)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_Valkyrie then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 167, 87, 197, 117)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_WizardMan then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 198, 118, 228, 148)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_WizardWoman then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 198, 149, 228, 179)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_Kunoichi then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 201, 25, 231, 55)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_NinjaMan then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 198, 180, 228, 210)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_DarkElf then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_01.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 1, 1, 31, 31)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_Combattant then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_01.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 1, 222, 31, 252)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_Mystic then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_01.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 21, 191, 51, 221)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_Lhan then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_01.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 57, 216, 87, 246)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_RangerMan then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_01.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 89, 216, 119, 246)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    elseif _partyData[index]._class == __eClassType_ShyWaman then
      classTypeTexture = "new_ui_common_forlua/widget/party/Party_01.dds"
      _uiPartyMemberList[index]._class:ChangeTextureInfoNameAsync(classTypeTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._class, 121, 216, 151, 246)
      _uiPartyMemberList[index]._class:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
    end
    _uiPartyMemberList[index]._distance:SetShow(true)
    _uiPartyMemberList[index]._distance:ChangeTextureInfoNameAsync("new_ui_common_forlua/widget/party/party_00.dds")
    if 0 == _partyData[index]._distance then
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._distance, 152, 1, 174, 23)
      _uiPartyMemberList[index]._distance:getBaseTexture():setUV(x1, y1, x2, y2)
    elseif 1 == _partyData[index]._distance then
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._distance, 176, 1, 198, 23)
      _uiPartyMemberList[index]._distance:getBaseTexture():setUV(x1, y1, x2, y2)
    elseif 2 == _partyData[index]._distance then
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._distance, 200, 1, 222, 23)
      _uiPartyMemberList[index]._distance:getBaseTexture():setUV(x1, y1, x2, y2)
    elseif 3 == _partyData[index]._distance then
      local x1, y1, x2, y2 = setTextureUV_Func(_uiPartyMemberList[index]._distance, 224, 1, 246, 23)
      _uiPartyMemberList[index]._distance:getBaseTexture():setUV(x1, y1, x2, y2)
    end
    _uiPartyMemberList[index]._distance:setRenderTexture(_uiPartyMemberList[index]._distance:getBaseTexture())
    _uiPartyMemberList[index]._distance:addInputEvent("Mouse_On", "PartyPop_SimpleTooltip_Show( true, 1," .. index .. "," .. _partyData[index]._distance .. " )")
    _uiPartyMemberList[index]._distance:addInputEvent("Mouse_Out", "PartyPop_SimpleTooltip_Show( false, 1," .. index .. "," .. _partyData[index]._distance .. " )")
    _uiPartyMemberList[index]._distance:setTooltipEventRegistFunc("PartyPop_SimpleTooltip_Show( true, 1," .. index .. "," .. _partyData[index]._distance .. " )")
    if _partyData[index]._nowHp <= 0 then
      _uiPartyMemberList[index]._conditionBG:SetShow(true)
      _uiPartyMemberList[index]._conditionTxt:SetShow(true)
      _uiPartyMemberList[index]._conditionTxt:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_DEATH"))
    elseif 1 <= _partyData[index]._nowHp then
      _uiPartyMemberList[index]._conditionBG:SetShow(false)
      _uiPartyMemberList[index]._conditionTxt:SetShow(false)
      _uiPartyMemberList[index]._conditionTxt:SetText("")
    end
    if true == _partyData[index]._isMaster then
      _uiPartyMemberList[index]._leader:SetShow(true)
    else
      _uiPartyMemberList[index]._leader:SetShow(false)
    end
    if _partyData[index]._isSelf then
      _uiPartyMemberList[index]._styleFollowBtn:SetShow(false)
      _uiPartyMemberList[index]._distance:SetShow(false)
      _uiPartyMemberList[index]._distance:SetSpanSize(-125, _uiPartyMemberList[index]._distance:GetSpanSize().y)
    else
      _uiPartyMemberList[index]._styleFollowBtn:SetShow(true)
      if _uiPartyMemberList[index]._stylePartyOptionBtn:GetShow() then
        _uiPartyMemberList[index]._styleFollowBtn:SetSpanSize(-165, _uiPartyMemberList[index]._styleFollowBtn:GetSpanSize().y)
      else
        _uiPartyMemberList[index]._styleFollowBtn:SetSpanSize(-185, _uiPartyMemberList[index]._styleFollowBtn:GetSpanSize().y)
      end
      _uiPartyMemberList[index]._distance:SetSpanSize(_uiPartyMemberList[index]._styleFollowBtn:GetSpanSize().x + 23, _uiPartyMemberList[index]._distance:GetSpanSize().y)
    end
    _uiPartyMemberList[index]._base:SetShow(true)
  else
    _uiPartyMemberList[index]._base:SetShow(false)
  end
end
function ResponseParty_updatePartyList()
  if Panel_Party:IsShow() and 0 == partyType then
    local partyMemberCount = RequestParty_getPartyMemberCount()
    local lootType = RequestParty_getPartyLootType()
    _partyData = {}
    _partyData = FGlobal_ResponseParty_PartyMemberSet(partyMemberCount)
    for index = 0, _maxPartyMemberCount - 1 do
      ResponseParty_PartyMemberTextureSet(_partyData, partyMemberCount, index)
    end
    if _preLootType ~= nil and _preLootType ~= PLT2S[lootType] then
      local rottingMsg = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_CHANGE_LOOTING_RULE1", "plt2s_lootType", PLT2S[lootType])
      _uiComboLootingOption:SetText(PLT2S[lootType])
      Proc_ShowMessage_Ack(rottingMsg)
    elseif nil == _preLootType then
      _uiComboLootingOption:SetText(PLT2S[lootType])
    end
    _preLootType = PLT2S[lootType]
    if 4 ~= lootType then
      FGlobal_PartyInventoryClose()
    else
      FGlobal_PartyInventoryOpen()
      for i = 1, partyMemberCount do
        Panel_Window_PartyInventory:SetPosY(i * Panel_Party:GetSizeY() + Panel_Party:GetPosY() + 40)
      end
    end
    if 0 == partyMemberCount then
      _styleLootType:SetShow(false)
      Panel_Party:SetShow(false, false)
      requestPlayerList = {}
      Panel_PartyOption:SetShow(false, false)
    else
      _uiComboLootingOption:SetSpanSize(3, partyMemberCount * Panel_Party:GetSizeY() + 10)
    end
    _partyMemberCount = partyMemberCount
    if isContentsEnable then
      if _partyMemberCount > 0 then
        Match_Button_Info:SetShow(false)
        Match_Button_Info:SetSpanSize(_uiComboLootingOption:GetSpanSize().x + 115, _uiComboLootingOption:GetSpanSize().y - 1)
        Match_Button_Info:ComputePos()
        if isMainChannel or isDevServer then
          FGlobal_UpdatePartyState(_partyMemberCount, RequestParty_isLeader())
        end
      end
      partyPenalty:SetPosX(Match_Button_Info:GetSpanSize().x + 60)
      partyPenalty:SetPosY(Match_Button_Info:GetSpanSize().y - 1)
    else
      partyPenalty:SetPosX(_uiComboLootingOption:GetSizeX() + _uiComboLootingOption:GetSpanSize().x + 10)
      partyPenalty:SetPosY(_uiComboLootingOption:GetSpanSize().y - 1)
      Match_Button_Info:SetShow(false)
    end
    if RequestParty_isLeader() then
      partyMarketOption:addInputEvent("Mouse_LUp", "Party_RegistItem_Show()")
    else
      partyMarketOption:addInputEvent("Mouse_LUp", "Party_ShowMessageAlert()")
    end
    btnSpecialGoods:addInputEvent("Mouse_LUp", "Panel_Party_ItemList_Open()")
    if partyMemberCount > firstCheck then
      firstCheck = firstCheck + 1
    else
      local currentPrice = RequestParty_getDistributionPrice()
      local currentGrade = RequestParty_getDistributionGrade()
      if (currentPrice ~= savedPrice or currentGrade ~= savedGrade) and registMarket then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_CHANGE_OPTION"))
        savedPrice = currentPrice
        savedGrade = currentGrade
      end
      local sizeY = isShow_PartyMatchBg()
      registItem._bg:SetPosY(partyMemberCount * Panel_Party:GetSizeY() + 40 + sizeY)
    end
  elseif Panel_LargeParty:GetShow() and 1 == partyType then
    Panel_Party:SetShow(false)
    PaGlobal_LargeParty:Update()
  end
end
function FGlobal_PartyMemberCount()
  return _partyMemberCount
end
local function messageBox_party_accept()
  requestPlayerList = {}
  RequestParty_acceptInvite(partyType)
end
local function messageBox_party_refuse()
  RequestParty_refuseInvite()
  for ii = 0, #requestPlayerList do
    if requestPlayerList[ii] == refuseName then
      requestPlayerList[ii] = ""
      return
    end
  end
end
function ResponseParty_withdraw(withdrawType, actorKey, isMe)
  if ToClient_IsRequestedPvP() or ToClient_IsMyselfInEntryUser() then
    return
  end
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
  partyPenalty:SetPosX(Match_Button_Info:GetSpanSize().x + 60)
  partyPenalty:SetPosY(Match_Button_Info:GetSpanSize().y - 1)
end
function ResponseParty_changeLeader(actorKey)
  local actorProxyWrapper = getActor(actorKey)
  if nil == actorProxyWrapper then
    return
  end
  local textName = actorProxyWrapper:getName()
  if 0 == partyType then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_CHANGE_PARTY_LEADER", "text_name", tostring(textName)))
  else
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_CHANGE_PARTY_LEADER", "text_name", tostring(textName)))
  end
  ResponseParty_updatePartyList()
  Party_RegistItem_Show(false)
end
function ResponseParty_refuse(reason)
  local contentString = reason
  local messageboxData
  messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = contentString,
    functionYes = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function ResponseParty_invite(hostName, invitePartyType)
  for ii = 0, #requestPlayerList do
    if requestPlayerList[ii] == hostName then
      return
    end
  end
  partyType = invitePartyType
  refuseName = hostName
  requestPlayerList[#requestPlayerList] = hostName
  local messageboxMemo = ""
  local messageboxData = ""
  if 0 == partyType then
    messageboxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_INVITE_ACCEPT", "host_name", hostName)
    messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "PARTY_INVITE_MESSAGEBOX_TITLE"),
      content = messageboxMemo,
      functionYes = messageBox_party_accept,
      functionNo = messageBox_party_refuse,
      priority = PP.PAUIMB_PRIORITY_LOW
    }
  else
    messageboxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LARGEPARTY_INVITE_ACCEPT", "host_name", hostName)
    messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_LARGEPARTY_INVITE_MESSAGEBOX_TITLE"),
      content = messageboxMemo,
      functionYes = messageBox_party_accept,
      functionNo = messageBox_party_refuse,
      priority = PP.PAUIMB_PRIORITY_LOW
    }
  end
  MessageBox.showMessageBox(messageboxData, "top", false, true, 0)
end
function PartyPop_clickChangeLeader(index)
  RequestParty_changeLeader(index)
  local memberData = RequestParty_getPartyMemberAt(index)
  closePartyOption()
end
function PartyPop_clickWithdrawMember(index)
  local isPlayingPvPMatch = getSelfPlayer():isDefinedPvPMatch()
  if true == isPlayingPvPMatch then
    RequestParty_withdrawMember(index)
    return
  end
  local function partyOut()
    RequestParty_withdrawMember(index)
    FGlobal_PartyInventoryClose()
    closePartyOption()
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
function messageBox_party_withdrawMember()
  local memberData = RequestParty_getPartyMemberAt(withdrawMember)
  RequestParty_withdrawMember(withdrawMember)
  if true == getSelfPlayer():isDefinedPvPMatch() then
    return
  end
end
function PartyPop_clickBanishMember(index)
  withdrawMember = index
  local withdrawMemberData = RequestParty_getPartyMemberAt(withdrawMember)
  local withdrawMemberActorKey = withdrawMemberData:getActorKey()
  local withdrawMemberPlayerActor = getPlayerActor(withdrawMemberActorKey)
  local contentString = ""
  local titleForceOut = ""
  if 0 == partyType then
    contentString = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT_QUESTION", "member_name", withdrawMemberData:name())
    titleForceOut = PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT")
  else
    contentString = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_FORCEOUT_QUESTION", "member_name", withdrawMemberData:name())
    titleForceOut = PAGetString(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_FORCEOUT")
  end
  local messageboxData = {
    title = titleForceOut,
    content = contentString,
    functionYes = messageBox_party_withdrawMember,
    functionNo = MessageBox_Empty_function,
    priority = PP.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
  closePartyOption()
end
local function ResponseParty_showList(idx)
  local index = _partyData[idx]._index
  local isShow = Panel_PartyOption:IsShow()
  if isShow == true and _last_Index == idx then
    closePartyOption()
  else
    local posY = _uiPartyMemberList[idx]._stylePartyOptionBtn:GetParentPosY() - 2
    local posX = _uiPartyMemberList[idx]._stylePartyOptionBtn:GetParentPosX() + _uiPartyMemberList[idx]._stylePartyOptionBtn:GetSizeX()
    if isContentsEnable then
      if _partyData[idx]._isSelf == true then
        _uiButtonWithdrawMember:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_SELF_OUT"))
        _uiButtonWithdrawMember:addInputEvent("Mouse_LUp", "PartyPop_clickWithdrawMember(" .. index .. ")")
        _uiButtonWithdrawMember:SetShow(true)
        _uiButtonChangeLeader:SetShow(false)
        Panel_PartyOption:SetPosX(posX)
        Panel_PartyOption:SetPosY(posY)
        Panel_PartyOption:SetShow(true, true)
      elseif _partyData[0]._isMaster == true then
        _uiButtonWithdrawMember:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_MEMBER_FORCEOUT"))
        _uiButtonWithdrawMember:addInputEvent("Mouse_LUp", "PartyPop_clickBanishMember(" .. index .. ")")
        _uiButtonChangeLeader:addInputEvent("Mouse_LUp", "PartyPop_clickChangeLeader(" .. index .. ")")
        _uiButtonChangeLeader:SetShow(true)
        Panel_PartyOption:SetPosX(posX)
        Panel_PartyOption:SetPosY(posY)
        Panel_PartyOption:SetShow(true, true)
      else
        _uiButtonWithdrawMember:SetShow(false)
        _uiButtonChangeLeader:SetShow(false)
      end
    elseif _partyData[idx]._isSelf == true then
      _uiButtonWithdrawMember:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_SELF_OUT"))
      _uiButtonWithdrawMember:addInputEvent("Mouse_LUp", "PartyPop_clickWithdrawMember(" .. index .. ")")
      _uiButtonWithdrawMember:SetShow(true)
      _uiButtonChangeLeader:SetShow(false)
      Panel_PartyOption:SetPosX(posX)
      Panel_PartyOption:SetPosY(posY)
      Panel_PartyOption:SetShow(true, true)
    elseif _partyData[0]._isMaster == true then
      _uiButtonWithdrawMember:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_MEMBER_FORCEOUT"))
      _uiButtonWithdrawMember:addInputEvent("Mouse_LUp", "PartyPop_clickBanishMember(" .. index .. ")")
      _uiButtonChangeLeader:addInputEvent("Mouse_LUp", "PartyPop_clickChangeLeader(" .. index .. ")")
      _uiButtonChangeLeader:SetShow(true)
      Panel_PartyOption:SetPosX(posX)
      Panel_PartyOption:SetPosY(posY)
      Panel_PartyOption:SetShow(true, true)
    else
      _uiButtonWithdrawMember:SetShow(false)
      _uiButtonChangeLeader:SetShow(false)
    end
  end
  _last_Index = idx
end
function PartyPop_clickPartyOption(index)
  ResponseParty_showList(index)
end
function PartyPop_clickPartyFollow(index)
  local selfPlayer = getSelfPlayer()
  local memberData = RequestParty_getPartyMemberAt(index)
  if nil ~= memberData then
    local actorKey = memberData:getActorKey()
    selfPlayer:setFollowActor(actorKey)
  end
end
function PartyPop_SimpleTooltip_Show(isShow, tipType, index, isDistance)
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "INTERACTION_BTN_FOLLOW_ACTOR")
    control = _uiPartyMemberList[index]._styleFollowBtn
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_DISTANCE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_DISTANCE_DESC")
    control = _uiPartyMemberList[index]._distance
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_PENALTY_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_PENALTY_DESC")
    control = partyPenalty
  end
  registTooltipControl(control, Panel_Tooltip_SimpleText)
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PartyOption_Hide()
  Panel_PartyOption:SetShow(false)
  return false
end
function PartyPop_onLootingOptionUI()
  if RequestParty_isLeader() == true then
    local lootType = RequestParty_getPartyLootType()
    _uiComboLootingOption:DeleteAllItem()
    for ii = 0, PLT.LootType_Bound - 2 do
      _uiComboLootingOption:AddItem(PLT2S[ii], ii)
    end
    _uiComboLootingOption:SetSelectItemIndex(lootType)
    _uiComboLootingOption:SetShow(true, false)
  end
end
function PartyPop_offLootingOptionUI()
  local list = _uiComboLootingOption:GetListControl()
  if list:GetShow() then
    return
  end
end
function Panel_Party_ShowToggle()
  local isShow = Panel_Party:GetShow()
  if RequestParty_getPartyMemberCount() == 0 then
    return
  end
  if isShow == true then
    Panel_Party:SetShow(false)
    requestPlayerList = {}
  else
    Panel_Party:SetShow(true)
  end
end
function partWidget_OnscreenEvent()
  if 0 == RequestParty_getPartyMemberCount() then
    Panel_Party:SetShow(false)
    requestPlayerList = {}
  else
    if not isFlushedUI() then
      Panel_Party:SetShow(true)
    end
    ResponseParty_updatePartyList()
  end
  if Panel_Party:GetRelativePosX() == -1 or Panel_Party:GetRelativePosY() == -1 then
    local initPosX = 10
    local initPosY = 200
    changePositionBySever(Panel_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
    FGlobal_InitPanelRelativePos(Panel_Party, initPosX, initPosY)
  elseif Panel_Party:GetRelativePosX() == 0 or Panel_Party:GetRelativePosY() == 0 then
    Panel_Party:SetPosX(10)
    Panel_Party:SetPosY(200)
  else
    Panel_Party:SetPosX(getScreenSizeX() * Panel_Party:GetRelativePosX() - Panel_Party:GetSizeX() / 2)
    Panel_Party:SetPosY(getScreenSizeY() * Panel_Party:GetRelativePosY() - Panel_Party:GetSizeY() / 2)
  end
  _uiComboLootingOption:ComputePos()
  FGlobal_PanelRepostionbyScreenOut(Panel_Party)
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
function PartyPanel_Repos()
  if not Panel_Window_PetControl:GetShow() then
    Panel_Party:SetSpanSize(10, 200)
  else
    Panel_Party:SetSpanSize(10, 310)
  end
end
function FGlobal_PartyListUpdate()
  ResponseParty_updatePartyList()
end
function FromClient_UpdatePartyExperiencePenalty(isPenalty)
  if nil == isPenalty then
    return
  end
  if isPenalty then
    partyPenalty:SetShow(false)
    partyPenalty:SetPosX(Match_Button_Info:GetSpanSize().x + 60)
    partyPenalty:SetPosY(Match_Button_Info:GetSpanSize().y - 1)
  else
    partyPenalty:SetShow(false)
  end
end
function PartyInit()
  partyType = ToClient_GetPartyType()
end
_uiComboLootingOption:addInputEvent("Mouse_LUp", "Looting_ComboBox()")
Panel_Party:addInputEvent("Mouse_LUp", "ResetPos_WidgetButton()")
registerEvent("ResponseParty_createPartyList", "ResponseParty_createPartyList")
registerEvent("ResponseParty_updatePartyList", "ResponseParty_updatePartyList")
registerEvent("ResponseParty_invite", "ResponseParty_invite")
registerEvent("ResponseParty_refuse", "ResponseParty_refuse")
registerEvent("ResponseParty_changeLeader", "ResponseParty_changeLeader")
registerEvent("ResponseParty_withdraw", "ResponseParty_withdraw")
registerEvent("FromClient_GroundMouseClick", "PartyOption_Hide")
registerEvent("onScreenResize", "partWidget_OnscreenEvent")
registerEvent("FromClient_UpdatePartyExperiencePenalty", "FromClient_UpdatePartyExperiencePenalty")
registerEvent("FromClient_NotifyPartyMemberPickupItem", "FromClient_NotifyPartyMemberPickupItem")
registerEvent("FromClient_NotifyPartyMemberPickupItemFromPartyInventory", "FromClient_NotifyPartyMemberPickupItemFromPartyInventory")
PartyInit()
ResponseParty_createPartyList()
ResponseParty_updatePartyList()
function renderModeChange_Panel_Party(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  if 0 == RequestParty_getPartyMemberCount() then
    Panel_Party:SetShow(false)
    requestPlayerList = {}
  else
    Panel_Party:SetShow(true)
    ResponseParty_updatePartyList()
  end
  partWidget_OnscreenEvent()
end
function FGlobal_Party_ConditionalShow()
  if 0 == RequestParty_getPartyMemberCount() then
    Panel_Party:SetShow(false)
    requestPlayerList = {}
  else
    Panel_Party:SetShow(true)
    ResponseParty_updatePartyList()
  end
end
function PaGlobalFunc_PartyOption_Close()
  closePartyOption()
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_Panel_Party")
changePositionBySever(Panel_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
