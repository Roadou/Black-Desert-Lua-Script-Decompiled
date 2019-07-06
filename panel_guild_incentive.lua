local UI_TM = CppEnums.TextMode
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local IM = CppEnums.EProcessorInputMode
local maxGuildList = 20
local maxIncentiveGrade = 4
local _guildList = {}
local _selectedMemberIndex = 0
local _isAllButton = {}
local _selectSortType = -1
local _listSort = {name = false}
local tempGuildIncentive = {}
local guildIncentiveMoneyValue = {
  _btn_Apply = nil,
  _btn_Close = nil,
  _txt_Desc = nil,
  _txt_Founds = nil,
  _edit_MoneyValue = nil
}
local Guild_Incentive = {
  _memberGrade = nil,
  _memberName = nil,
  _memberContribution = nil,
  _memberIncentiveValue = nil,
  _comboboxRank = nil,
  _radio_All = nil,
  _radio_Personal = nil,
  _btn_IncentiveLevel = nil,
  _listTitleBG = nil,
  _frameGuildList = nil,
  _contentGuildList = nil,
  _scroll = nil,
  _guildFoundationValue = nil,
  _guildMoney = nil,
  _totalIncentiveValue = nil,
  _leftTime = nil,
  _leftTimeValue = nil,
  _btnIncentive = nil,
  _btnClose = nil,
  _btnQuestion = nil,
  _desc = nil,
  _moneyValue = nil
}
local frameTextGap = 10
local _memberCtrlCount = 0
function Guild_Incentive:initialize()
  if nil == Panel_Guild_IncentiveOption then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_IncentiveOption:SetShow(false)
  end
  Panel_Guild_IncentiveOption:ActiveMouseEventEffect(true)
  Panel_Guild_IncentiveOption:setMaskingChild(true)
  Panel_Guild_IncentiveOption:setGlassBackground(true)
  Panel_Guild_IncentiveOption:SetDragEnable(true)
  Panel_Guild_IncentiveOption:SetDragAll(true)
  Guild_Incentive._memberGrade = UI.getChildControl(Panel_Guild_IncentiveOption, "StaticText_C_Grade")
  Guild_Incentive._memberName = UI.getChildControl(Panel_Guild_IncentiveOption, "StaticText_C_CharName")
  Guild_Incentive._memberContribution = UI.getChildControl(Panel_Guild_IncentiveOption, "StaticText_C_ContributedTendency")
  Guild_Incentive._memberIncentiveValue = UI.getChildControl(Panel_Guild_IncentiveOption, "StaticText_C_IncentiveValue")
  Guild_Incentive._comboboxRank = UI.getChildControl(Panel_Guild_IncentiveOption, "Combobox_Destination")
  Guild_Incentive._radio_All = UI.getChildControl(Panel_Guild_IncentiveOption, "RadioButton_All")
  Guild_Incentive._radio_Personal = UI.getChildControl(Panel_Guild_IncentiveOption, "RadioButton_Personal")
  Guild_Incentive._btn_IncentiveLevel = UI.getChildControl(Panel_Guild_IncentiveOption, "StaticText_Grade")
  Guild_Incentive._listTitleBG = UI.getChildControl(Panel_Guild_IncentiveOption, "Static_List_BG")
  Guild_Incentive._frameGuildList = UI.getChildControl(Panel_Guild_IncentiveOption, "Frame_GuildList")
  Guild_Incentive._contentGuildList = UI.getChildControl(Guild_Incentive._frameGuildList, "Frame_1_Content")
  Guild_Incentive._scroll = UI.getChildControl(Guild_Incentive._frameGuildList, "VerticalScroll")
  Guild_Incentive._guildFoundationValue = UI.getChildControl(Panel_Guild_IncentiveOption, "StaticText_GuildMoney")
  Guild_Incentive._guildMoney = UI.getChildControl(Panel_Guild_IncentiveOption, "StaticText_GuildMoney_Value")
  Guild_Incentive._totalIncentiveValue = UI.getChildControl(Panel_Guild_IncentiveOption, "StaticText_Incentive_Value")
  Guild_Incentive._leftTime = UI.getChildControl(Panel_Guild_IncentiveOption, "StaticText_Incentive_LeftTime")
  Guild_Incentive._leftTimeValue = UI.getChildControl(Panel_Guild_IncentiveOption, "StaticText_Incentive_LeftTimeValue")
  Guild_Incentive._btnIncentive = UI.getChildControl(Panel_Guild_IncentiveOption, "Button_Incentive")
  Guild_Incentive._btnClose = UI.getChildControl(Panel_Guild_IncentiveOption, "Button_WinClose")
  Guild_Incentive._btnQuestion = UI.getChildControl(Panel_Guild_IncentiveOption, "Button_Question")
  Guild_Incentive._desc = UI.getChildControl(Panel_Guild_IncentiveOption, "StaticText_Incentive_Explain")
  Guild_Incentive._desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  Guild_Incentive._desc:SetText(Guild_Incentive._desc:GetText())
  local sizeY = math.max(16, Guild_Incentive._desc:GetTextSizeY()) - 16
  Panel_Guild_IncentiveOption:SetSize(Panel_Guild_IncentiveOption:GetSizeX(), Panel_Guild_IncentiveOption:GetSizeY() + sizeY)
  Guild_Incentive._btnIncentive:SetSize(Guild_Incentive._btnIncentive:GetSizeX(), Guild_Incentive._btnIncentive:GetSizeY() + sizeY)
  Guild_Incentive._memberGrade:SetShow(false)
  Guild_Incentive._memberName:SetShow(false)
  Guild_Incentive._memberContribution:SetShow(false)
  Guild_Incentive._memberIncentiveValue:SetShow(false)
  Guild_Incentive._comboboxRank:SetShow(false)
  Guild_Incentive._btnIncentive:ComputePos()
  Guild_Incentive._desc:ComputePos()
  Guild_Incentive._guildMoney:ComputePos()
  Guild_Incentive._guildFoundationValue:ComputePos()
  Guild_Incentive._totalIncentiveValue:ComputePos()
  Guild_Incentive:registEventHandler()
end
function Guild_Incentive:ResetControl()
  if nil == Panel_Guild_IncentiveOption then
    return
  end
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  Guild_Incentive._guildMoney:SetText(0 .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_MONEY"))
  _memberCtrlCount = ToClient_getGuildIncentiveListCount()
  if maxGuildList < _memberCtrlCount then
    Guild_Incentive._scroll:SetShow(true)
  else
    Guild_Incentive._scroll:SetShow(false)
  end
  local _contentGuildList = Guild_Incentive._contentGuildList
  _contentGuildList:DestroyAllChild()
  local _ySize = Guild_Incentive._memberGrade:GetSizeY()
  for i = 1, _memberCtrlCount do
    local index = i - 1
    _guildList[index] = {}
    _guildList[index]._memberGrade = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, _contentGuildList, "StaticText_Grade_" .. i)
    _guildList[index]._memberName = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, _contentGuildList, "StaticText_MemberName_" .. i)
    _guildList[index]._memberContribution = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, _contentGuildList, "StaticText_MemberContribution_" .. i)
    _guildList[index]._memberIncentiveValue = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, _contentGuildList, "StaticText_memberIncentiveValue_" .. i)
    _guildList[index]._comboboxRank = UI.createControl(UCT.PA_UI_CONTROL_COMBOBOX, _contentGuildList, "Combobox_Rank_" .. i)
    _guildList[index]._radio_All = UI.createControl(UCT.PA_UI_CONTROL_RADIOBUTTON, _contentGuildList, "Radiobutton_All_" .. i)
    _guildList[index]._radio_Personal = UI.createControl(UCT.PA_UI_CONTROL_RADIOBUTTON, _contentGuildList, "Radiobutton_Personal_" .. i)
    _guildList[index]._btn_IncentiveLevel = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, _contentGuildList, "Button_IncentiveLevel_" .. i)
    CopyBaseProperty(Guild_Incentive._memberGrade, _guildList[index]._memberGrade)
    CopyBaseProperty(Guild_Incentive._memberName, _guildList[index]._memberName)
    CopyBaseProperty(Guild_Incentive._memberContribution, _guildList[index]._memberContribution)
    CopyBaseProperty(Guild_Incentive._memberIncentiveValue, _guildList[index]._memberIncentiveValue)
    CopyBaseProperty(Guild_Incentive._comboboxRank, _guildList[index]._comboboxRank)
    CopyBaseProperty(Guild_Incentive._radio_All, _guildList[index]._radio_All)
    CopyBaseProperty(Guild_Incentive._radio_Personal, _guildList[index]._radio_Personal)
    CopyBaseProperty(Guild_Incentive._btn_IncentiveLevel, _guildList[index]._btn_IncentiveLevel)
    _guildList[index]._radio_All:SetGroup(i)
    _guildList[index]._radio_Personal:SetGroup(i)
    local guildMemberInfo = ToClient_getMemberGuildIncentiveListByIndex(index)
    local gradeType = guildMemberInfo:getGrade()
    local gradeValue = ""
    if 0 == gradeType then
      gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMASTER")
    elseif 1 == gradeType then
      gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDSUBMASTER")
    elseif 2 == gradeType then
      gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMEMBER")
    elseif 3 == gradeType then
      gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_SUPPLYOFFICER")
    end
    _guildList[index]._memberGrade:SetText(gradeValue)
    _guildList[index]._memberName:SetText(guildMemberInfo:getName() .. " (" .. guildMemberInfo:getCharacterName() .. ")")
    local tempActivityText = "0"
    _guildList[index]._memberContribution:SetText(tempActivityText)
    local posY = 0
    posY = (_ySize + frameTextGap / 2 + 5) * index + frameTextGap
    _guildList[index]._memberGrade:SetPosY(posY)
    _guildList[index]._memberGrade:SetShow(true)
    _guildList[index]._memberName:SetPosY(posY)
    _guildList[index]._memberName:SetShow(true)
    _guildList[index]._memberContribution:SetPosY(posY)
    _guildList[index]._memberContribution:SetShow(true)
    _guildList[index]._memberIncentiveValue:SetPosY(posY)
    _guildList[index]._memberIncentiveValue:SetShow(true)
    _guildList[index]._comboboxRank:SetPosY(posY)
    _guildList[index]._comboboxRank:SetShow(false)
    _guildList[index]._radio_All:SetPosY(posY)
    _guildList[index]._radio_Personal:SetPosY(posY)
    _guildList[index]._radio_All:SetShow(true)
    _guildList[index]._radio_Personal:SetShow(true)
    _guildList[index]._radio_All:SetCheck(true)
    _guildList[index]._radio_Personal:SetCheck(false)
    _guildList[index]._radio_All:SetEnableArea(0, 0, _guildList[index]._radio_All:GetSizeX() + _guildList[index]._radio_All:GetTextSizeX() + 5, _guildList[index]._radio_All:GetSizeY())
    _guildList[index]._radio_Personal:SetEnableArea(0, 0, _guildList[index]._radio_Personal:GetSizeX() + _guildList[index]._radio_Personal:GetTextSizeX() + 5, _guildList[index]._radio_Personal:GetSizeY())
    _guildList[index]._radio_Personal:SetPosX(_guildList[index]._radio_All:GetPosX() + _guildList[index]._radio_All:GetSizeX() + _guildList[index]._radio_All:GetTextSizeX() + 10)
    if isGameTypeKorea or isGameTypeJapan or isGameTypeTaiwan then
      _guildList[index]._radio_Personal:SetPosX(_guildList[index]._radio_All:GetPosX() + _guildList[index]._radio_All:GetSizeX() + _guildList[index]._radio_All:GetTextSizeX() + 20)
      _guildList[index]._btn_IncentiveLevel:SetSize(100, _guildList[index]._btn_IncentiveLevel:GetSizeY())
      _guildList[index]._btn_IncentiveLevel:ComputePos()
    end
    _guildList[index]._btn_IncentiveLevel:SetSize(60, _guildList[index]._btn_IncentiveLevel:GetSizeY())
    _guildList[index]._btn_IncentiveLevel:ComputePos()
    _guildList[index]._btn_IncentiveLevel:SetPosY(posY)
    _guildList[index]._btn_IncentiveLevel:SetShow(true)
    _guildList[index]._btn_IncentiveLevel:addInputEvent("Mouse_LUp", "PaGlobal_SetInventive_Grade(" .. index .. ")")
    _guildList[index]._comboboxRank:DeleteAllItem()
    for i = 1, maxIncentiveGrade do
      _guildList[index]._comboboxRank:AddItem(i)
    end
    _guildList[index]._comboboxRank:SetText(1)
    _guildList[index]._comboboxRank:addInputEvent("Mouse_LUp", "click_Incentive_GradeList(" .. index .. ")")
    _guildList[index]._comboboxRank:GetListControl():addInputEvent("Mouse_LUp", "Set_Incentive_Grade(" .. index .. ")")
  end
  Guild_Incentive._title_CharName = UI.getChildControl(Guild_Incentive._listTitleBG, "StaticText_M_CharName")
  Guild_Incentive._title_Ap = UI.getChildControl(Guild_Incentive._listTitleBG, "StaticText_M_ContributedTendency")
  Guild_Incentive._title_CharName:addInputEvent("Mouse_LUp", "HandleClicked_GuildIncentiveSort(0)")
  Guild_Incentive._title_Ap:addInputEvent("Mouse_LUp", "HandleClicked_GuildIncentiveSort(1)")
  Panel_Guild_IncentiveOption:SetChildIndex(Guild_Incentive._title_CharName, 9999)
  Panel_Guild_IncentiveOption:SetChildIndex(Guild_Incentive._title_Ap, 9999)
  Guild_Incentive._frameGuildList:UpdateContentScroll()
  Guild_Incentive._scroll:SetControlTop()
  Guild_Incentive._frameGuildList:UpdateContentPos()
  _isAllButton = {}
end
function Guild_Incentive:registEventHandler()
  if nil == Panel_Guild_IncentiveOption then
    return
  end
  Guild_Incentive._btnIncentive:addInputEvent("Mouse_LUp", "Give_Incentive()")
  Guild_Incentive._btnClose:addInputEvent("Mouse_LUp", "Panel_GuildIncentiveOption_Close()")
  Guild_Incentive._btnQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelGuild\" )")
  Guild_Incentive._btnQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelGuild\", \"true\")")
  Guild_Incentive._btnQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelGuild\", \"false\")")
end
function guildIncentiveMoneyValue:initialize()
  if nil == Panel_Guild_Incentive_Foundation then
    return
  end
  Panel_Guild_Incentive_Foundation:SetDragEnable(true)
  Panel_Guild_Incentive_Foundation:SetDragAll(true)
  guildIncentiveMoneyValue._btn_Apply = UI.getChildControl(Panel_Guild_Incentive_Foundation, "Button_Apply")
  guildIncentiveMoneyValue._btn_Close = UI.getChildControl(Panel_Guild_Incentive_Foundation, "Button_Cancel")
  guildIncentiveMoneyValue._txt_Desc = UI.getChildControl(Panel_Guild_Incentive_Foundation, "StaticText_Desc")
  guildIncentiveMoneyValue._txt_Founds = UI.getChildControl(Panel_Guild_Incentive_Foundation, "StaticText_Founds")
  guildIncentiveMoneyValue._edit_MoneyValue = UI.getChildControl(Panel_Guild_Incentive_Foundation, "Edit_MoneyValue")
  guildIncentiveMoneyValue._txt_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  guildIncentiveMoneyValue._txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_FOUNDATION_DESC"))
  Panel_Guild_Incentive_Foundation:SetSize(Panel_Guild_Incentive_Foundation:GetSizeX(), guildIncentiveMoneyValue._txt_Desc:GetTextSizeY() + 210)
  guildIncentiveMoneyValue._btn_Close:ComputePos()
  guildIncentiveMoneyValue._btn_Apply:ComputePos()
  guildIncentiveMoneyValue._edit_MoneyValue:SetEditText("", true)
  guildIncentiveMoneyValue:registEventHandler()
end
function guildIncentiveMoneyValue:registEventHandler()
  if nil == Panel_Guild_Incentive_Foundation then
    return
  end
  Panel_Guild_Incentive_Foundation:RegisterCloseLuaFunc(PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Escape
  }), "Panel_Guild_Incentive_Foundation_Close()")
  guildIncentiveMoneyValue._btn_Close:addInputEvent("Mouse_LUp", "Panel_Guild_Incentive_Foundation_Close()")
  guildIncentiveMoneyValue._edit_MoneyValue:addInputEvent("Mouse_LUp", "Panel_Guild_Incentive_Foundation_Editing()")
end
function guildIncentiveMoneyValue:registMessageHandler()
  registerEvent("onScreenResize", "Panel_Guild_IncentiveOption_Resize")
end
function Guild_IncentiveTax_SimpleTooltip(isShow, index)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_SEVERSELECT_PK")
  local dataIdx = tempGuildIncentive[index + 1].idx
  local incentive = ToClient_getGuildMemberIncentiveMoney_s64(dataIdx)
  local incentiveAfterTax = ToClient_getGuildMemberIncentiveMoneyAfterTax_s64(dataIdx)
  TooltipSimple_Show(_guildList[index]._memberIncentiveValue, "", PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_INCENTIVE_MONEY") .. " " .. makeDotMoney(incentiveAfterTax))
end
function Guild_Incentive:UpdateData()
  if nil == Panel_Guild_IncentiveOption then
    return
  end
  GuildIncentive_SetGuildIncentive()
  GuildIncentive_updateSort()
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local businessFunds = myGuildListInfo:getGuildBusinessFunds_s64()
  local totalMoney64 = ToClient_getGuildTotalIncentiveMoney_s64()
  Guild_Incentive._guildFoundationValue:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_FOUNDATIONVALUE", "businessFunds", makeDotMoney(businessFunds), "totalMoney64", makeDotMoney(totalMoney64)))
  local memberCount = ToClient_getGuildIncentiveListCount()
  local leftTime = myGuildListInfo:getIncentiveDate()
  for i = 1, memberCount do
    local index = i - 1
    local dataIdx = tempGuildIncentive[index + 1].idx
    local guildMemberInfo = ToClient_getMemberGuildIncentiveListByIndex(dataIdx)
    local gradeType = guildMemberInfo:getGrade()
    local gradeValue = ""
    if 0 == gradeType then
      gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMASTER")
    elseif 1 == gradeType then
      gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDSUBMASTER")
    elseif 2 == gradeType then
      gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMEMBER")
    elseif 3 == gradeType then
      gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_SUPPLYOFFICER")
    end
    _guildList[index]._memberGrade:SetText(gradeValue)
    if true == guildMemberInfo:isOnline() then
      _guildList[index]._memberName:SetText(guildMemberInfo:getName() .. " (" .. guildMemberInfo:getCharacterName() .. ")")
      local usableActivity = guildMemberInfo:getUsableActivity()
      if usableActivity > 10000 then
        usableActivity = 10000
      end
      local tempActivityText = tostring(guildMemberInfo:getTotalActivity()) .. "(<PAColor0xfface400>+" .. tostring(usableActivity) .. "<PAOldColor>)"
      _guildList[index]._memberContribution:SetText(tempActivityText)
    else
      _guildList[index]._memberName:SetText(guildMemberInfo:getName() .. " ( - )")
      local tempActivityText = tostring(guildMemberInfo:getTotalActivity()) .. "(+" .. tostring(guildMemberInfo:getUsableActivity()) .. ")"
      _guildList[index]._memberContribution:SetText(tempActivityText)
    end
    local grade = ToClient_getGuildMemberIncentiveGrade(dataIdx)
    _guildList[index]._btn_IncentiveLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_GRADE_FOR_WHAT", "grade", tostring(grade)))
    local incentive = ToClient_getGuildMemberIncentiveMoney_s64(dataIdx)
    local incentiveAfterTax = ToClient_getGuildMemberIncentiveMoneyAfterTax_s64(dataIdx)
    local rate = ToClient_GetCalculateRate(incentiveAfterTax, incentive)
    rate = 1 - rate
    rate = rate * 100
    rate = math.ceil(rate)
    if rate > 1.0E-5 then
      _guildList[index]._memberIncentiveValue:SetText(makeDotMoney(incentive) .. "(<PAColor0xFFD20000>-" .. tostring(rate) .. "%<PAOldColor>)")
      _guildList[index]._memberIncentiveValue:SetIgnore(false)
      _guildList[index]._memberIncentiveValue:addInputEvent("Mouse_On", "Guild_IncentiveTax_SimpleTooltip(true ," .. tostring(index) .. ")")
      _guildList[index]._memberIncentiveValue:addInputEvent("Mouse_Out", "Guild_IncentiveTax_SimpleTooltip(false ," .. tostring(index) .. ")")
    else
      _guildList[index]._memberIncentiveValue:SetText(makeDotMoney(incentive))
      _guildList[index]._memberIncentiveValue:SetIgnore(true)
    end
    _guildList[index]._comboboxRank:SetText(tostring(grade))
    local isAll = tempGuildIncentive[index + 1].isAll
    if true == isAll then
      _guildList[index]._radio_All:SetCheck(true)
      _guildList[index]._radio_Personal:SetCheck(false)
    else
      _guildList[index]._radio_All:SetCheck(false)
      _guildList[index]._radio_Personal:SetCheck(true)
    end
    _guildList[index]._radio_All:addInputEvent("Mouse_LUp", "GuildIncentive_UpdateIncentiveRadioButton(" .. tostring(index) .. ",true)")
    _guildList[index]._radio_Personal:addInputEvent("Mouse_LUp", "GuildIncentive_UpdateIncentiveRadioButton(" .. tostring(index) .. ",false)")
  end
  Guild_Incentive._scroll:SetInterval(Guild_Incentive._contentGuildList:GetSizeY() / 100 * 1.1)
end
function GuildIncentive_UpdateIncentiveRadioButton(index, bValue)
  local userNoStr = tostring(tempGuildIncentive[index + 1].userNo)
  _isAllButton[userNoStr] = bValue
end
function click_Incentive_GradeList(index)
  if nil == Panel_Guild_IncentiveOption then
    return
  end
  _selectedMemberIndex = index
  local listCombbox = _guildList[index]._comboboxRank:GetListControl()
  if Guild_Incentive._frameGuildList:GetSizeY() - Guild_Incentive._contentGuildList:GetPosY() - listCombbox:GetSizeY() < _guildList[index]._comboboxRank:GetPosY() then
    listCombbox:SetPosY(listCombbox:GetSizeY() * -1)
  else
    listCombbox:SetPosY(_guildList[index]._comboboxRank:GetSizeY())
  end
  _guildList[index]._comboboxRank:ToggleListbox()
  Guild_Incentive._contentGuildList:SetChildIndex(_guildList[index]._comboboxRank, 9999)
end
local temp_Incentive_Idx = 0
function PaGlobal_SetInventive_Grade(index)
  temp_Incentive_Idx = index
  Panel_NumberPad_Show(true, toInt64(0, 10), 0, PaGlobal_SetInventive_Grade_CallBack)
end
function PaGlobal_SetInventive_Grade_CallBack(count)
  if nil == Panel_Guild_IncentiveOption then
    return
  end
  local index = temp_Incentive_Idx
  local dataIdx = tempGuildIncentive[index + 1].idx
  local editMoney = Guild_Incentive._moneyValue
  local isAll = _guildList[index]._radio_All:IsCheck()
  if true == isAll then
    local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
    if nil == myGuildListInfo then
      return
    end
    local memberCount = ToClient_getGuildIncentiveListCount()
    for i = 0, memberCount - 1 do
      if true == _guildList[i]._radio_All:IsCheck() then
        local tempIdx = tempGuildIncentive[i + 1].idx
        ToClient_SetGuildMemberIncentiveGrade(tempIdx, Int64toInt32(count), editMoney)
      end
    end
  else
    ToClient_SetGuildMemberIncentiveGrade(dataIdx, Int64toInt32(count), editMoney)
  end
  Guild_Incentive:UpdateData()
end
function Set_Incentive_Grade(index)
  if nil == Panel_Guild_IncentiveOption then
    return
  end
  local dataIdx = tempGuildIncentive[index + 1].idx
  _guildList[index]._comboboxRank:SetSelectItemIndex(_guildList[index]._comboboxRank:GetSelectIndex())
  local grade = 1
  _guildList[index]._comboboxRank:SetText(tostring(grade))
  _guildList[index]._comboboxRank:ToggleListbox()
  local level1 = _guildList[index]._level1:IsCheck()
  local level2 = _guildList[index]._level2:IsCheck()
  local level3 = _guildList[index]._level3:IsCheck()
  local level4 = _guildList[index]._level4:IsCheck()
  if level1 then
    grade = 1
  elseif level2 then
    grade = 2
  elseif level3 then
    grade = 3
  elseif level4 then
    grade = 4
  end
  local editMoney = Guild_Incentive._moneyValue
  ToClient_SetGuildMemberIncentiveGrade(dataIdx, grade, editMoney)
  Guild_Incentive:UpdateData()
end
function Give_Incentive()
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_PAYMENTS")
  local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_PAYMENTS_CONFIRM")
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = PayIncentiveConfirm,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PayIncentiveConfirm()
  ToClient_PayGuildMemberIncentive()
  Panel_GuildIncentiveOption_Close()
  Panel_Guild_Incentive_Foundation_Close()
end
function Panel_GuildIncentiveOption_ShowToggle()
  if PaGlobal_GuildIncentive_GetShowOption() then
    Panel_GuildIncentiveOption_Close()
    Panel_Guild_Incentive_Foundation_Close()
  else
    Panel_Guild_Incentive_Foundation_Open()
  end
end
function Panel_GuildIncentiveOption_Close()
  if PaGlobal_GuildIncentive_GetShowOption() then
    PaGlobal_GuildIncentive_CheckCloseUIOption()
    Panel_Guild_Incentive_Foundation_Close()
  end
end
function Panel_Guild_IncentiveOption_Resize()
  if nil == Panel_Guild_IncentiveOption then
    return
  end
  Panel_Guild_IncentiveOption:SetPosX(getScreenSizeX() / 2 - Panel_Guild_IncentiveOption:GetSizeX() / 2)
  Panel_Guild_IncentiveOption:SetPosY(getScreenSizeY() / 2 - Panel_Guild_IncentiveOption:GetSizeY() / 2 - 50)
end
function Panel_Guild_Incentive_Foundation_Update()
  if nil == Panel_Guild_Incentive_Foundation then
    return
  end
  local self = guildIncentiveMoneyValue
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local businessFunds = myGuildListInfo:getGuildBusinessFunds_s64()
  local businessFunds10 = businessFunds * toInt64(0, 10) / toInt64(0, 100)
  local businessFunds30 = businessFunds * toInt64(0, 40) / toInt64(0, 100)
  self._txt_Founds:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_FOUNDATION_RANGEOFMONEY", "businessFunds", makeDotMoney(businessFunds), "businessFunds10", makeDotMoney(businessFunds10), "businessFunds30", makeDotMoney(businessFunds30)))
  self._btn_Apply:addInputEvent("Mouse_LUp", "Panel_Guild_Incentive_Foundation_MainShowToggle()")
end
function Panel_Guild_Incentive_Foundation_MainShowToggle()
  if nil == Panel_Guild_Incentive_Foundation then
    return
  end
  local self = guildIncentiveMoneyValue
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local businessFunds = myGuildListInfo:getGuildBusinessFunds_s64()
  local businessFunds10 = businessFunds * toInt64(0, 10) / toInt64(0, 100)
  local businessFunds30 = businessFunds * toInt64(0, 40) / toInt64(0, 100)
  local editMoney = tonumber64(string.gsub(self._edit_MoneyValue:GetEditText(), ",", ""))
  if businessFunds10 > editMoney or businessFunds30 < editMoney then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_FOUNDATION_RANGEOFMONEY_ALERT"))
    return
  end
  if PaGlobal_GuildIncentive_GetShowOption() then
    Panel_GuildIncentiveOption_Close()
    Panel_Guild_Incentive_Foundation_Close()
  else
    ToClient_InitGuildIncentiveList(editMoney)
    Guild_Incentive._moneyValue = editMoney
    PaGlobal_GuildIncentive_CheckLoadUIOption()
    Guild_Incentive:ResetControl()
    Guild_Incentive:UpdateData()
    Panel_Guild_IncentiveOption_Resize()
    Panel_Guild_Incentive_Foundation_Close()
  end
end
function Panel_Guild_Incentive_Foundation_Editing()
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local businessFunds = myGuildListInfo:getGuildBusinessFunds_s64()
  local businessFunds10 = businessFunds * toInt64(0, 10) / toInt64(0, 100)
  local businessFunds30 = businessFunds * toInt64(0, 40) / toInt64(0, 100)
  Panel_NumberPad_Show(true, businessFunds30, nil, Panel_Guild_Incentive_Foundation_ConfirmFunction)
end
function Panel_Guild_Incentive_Foundation_ConfirmFunction(inputNumber, param)
  if nil == Panel_Guild_Incentive_Foundation then
    return
  end
  local self = guildIncentiveMoneyValue
  self._edit_MoneyValue:SetEditText(makeDotMoney(inputNumber), false)
end
function FGlobal_CheckGuildIncentiveUiEdit(targetUI)
  if nil == Panel_Guild_Incentive_Foundation then
    return false
  end
  return nil ~= targetUI and targetUI:GetKey() == guildIncentiveMoneyValue._edit_MoneyValue:GetKey()
end
function FGlobal_GuildIncentiveClearFocusEdit()
  ClearFocusEdit()
  CheckChattingInput()
end
function Panel_Guild_Incentive_Foundation_Open()
  PaGlobal_GuildIncentive_CheckLoadUIFoundation()
  guildIncentiveMoneyValue._edit_MoneyValue:SetEditText("0", true)
  Panel_Guild_Incentive_Foundation_Update()
end
function Panel_Guild_Incentive_Foundation_Close()
  PaGlobal_GuildIncentive_CheckCloseUIFoundation()
end
function GuildIncentive_TitleLineReset()
  if nil == Panel_Guild_IncentiveOption then
    return
  end
  local self = Guild_Incentive
  self._title_CharName:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CHARNAME"))
  self._title_Ap:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_ACTIVITY"))
end
function GuildIncentive_SetGuildIncentive()
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local memberCount = ToClient_getGuildIncentiveListCount()
  tempGuildIncentive = {}
  for index = 1, memberCount do
    local myGuildMemberInfo = ToClient_getMemberGuildIncentiveListByIndex(index - 1)
    tempGuildIncentive[index] = {
      idx = index - 1,
      online = myGuildMemberInfo:isOnline(),
      grade = myGuildMemberInfo:getGrade(),
      level = myGuildMemberInfo:getLevel(),
      class = myGuildMemberInfo:getClassType(),
      name = myGuildMemberInfo:getName(),
      ap = Int64toInt32(myGuildMemberInfo:getTotalActivity()),
      expiration = myGuildMemberInfo:getContractedExpirationUtc(),
      wp = myGuildMemberInfo:getMaxWp(),
      kp = myGuildMemberInfo:getExplorationPoint(),
      userNo = myGuildMemberInfo:getUserNo(),
      isAll = true
    }
    local userNoStr = tostring(tempGuildIncentive[index].userNo)
    if nil == _isAllButton[userNoStr] then
      _isAllButton[userNoStr] = true
      tempGuildIncentive[index].isAll = true
    else
      tempGuildIncentive[index].isAll = _isAllButton[userNoStr]
    end
  end
end
local function guildIncentiveCompareName(w1, w2)
  if true == _listSort.name then
    if w1.name < w2.name then
      return true
    end
  elseif w2.name < w1.name then
    return true
  end
end
local function guildIncentiveCompareAp(w1, w2)
  if true == _listSort.ap then
    if w2.ap < w1.ap then
      return true
    end
  elseif w1.ap < w2.ap then
    return true
  end
end
function HandleClicked_GuildIncentiveSort(sortType)
  if nil == Panel_Guild_IncentiveOption then
    return
  end
  local self = Guild_Incentive
  GuildIncentive_TitleLineReset()
  _selectSortType = sortType
  if 0 == sortType then
    if false == _listSort.name then
      self._title_CharName:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CHARNAME") .. "\226\150\178")
      _listSort.name = true
    else
      self._title_CharName:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CHARNAME") .. "\226\150\188")
      _listSort.name = false
    end
    table.sort(tempGuildIncentive, guildIncentiveCompareName)
  elseif 1 == sortType then
    if false == _listSort.ap then
      self._title_Ap:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_ACTIVITY") .. "\226\150\178")
      _listSort.ap = true
    else
      self._title_Ap:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_ACTIVITY") .. "\226\150\188")
      _listSort.ap = false
    end
    table.sort(tempGuildIncentive, guildIncentiveCompareAp)
  end
  Guild_Incentive:UpdateData()
end
function GuildIncentive_updateSort()
  if 0 == _selectSortType then
    table.sort(tempGuildIncentive, guildIncentiveCompareName)
  elseif 1 == _selectSortType then
    table.sort(tempGuildIncentive, guildIncentiveCompareAp)
  end
end
function PaGlobal_GuildIncentive_CheckLoadUIOption()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_IncentiveOption:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_Guild_Incentive.XML", "Panel_Guild_IncentiveOption", Defines.UIGroup.PAGameUIGroup_Window_Progress, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_Guild_IncentiveOption = rv
    rv = nil
    Guild_Incentive:initialize()
  end
  Panel_Guild_IncentiveOption:SetShow(true)
end
function PaGlobal_GuildIncentive_CheckCloseUIOption()
  if false == PaGlobal_GuildIncentive_GetShowOption() then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_IncentiveOption:SetShow(false)
  else
    reqCloseUI(Panel_Guild_IncentiveOption)
  end
end
function PaGlobal_GuildIncentive_GetShowOption()
  if nil == Panel_Guild_IncentiveOption then
    return false
  end
  return Panel_Guild_IncentiveOption:GetShow()
end
function PaGlobal_GuildIncentive_CheckLoadUIFoundation()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_Incentive_Foundation:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_Guild_Incentive_Foundation.XML", "Panel_Guild_Incentive_Foundation", Defines.UIGroup.PAGameUIGroup_Window_Progress, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_Guild_Incentive_Foundation = rv
    rv = nil
    guildIncentiveMoneyValue:initialize()
  end
  Panel_Guild_Incentive_Foundation:SetShow(true)
end
function PaGlobal_GuildIncentive_CheckCloseUIFoundation()
  if false == PaGlobal_GuildIncentive_GetShowFoundation() then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_Incentive_Foundation:SetShow(false)
  else
    reqCloseUI(Panel_Guild_Incentive_Foundation)
  end
end
function PaGlobal_GuildIncentive_GetShowFoundation()
  if nil == Panel_Guild_Incentive_Foundation then
    return false
  end
  return Panel_Guild_Incentive_Foundation:GetShow()
end
function FromClient_GuildIncentive_Init()
  Guild_Incentive:initialize()
  guildIncentiveMoneyValue:initialize()
  guildIncentiveMoneyValue:registMessageHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildIncentive_Init")
