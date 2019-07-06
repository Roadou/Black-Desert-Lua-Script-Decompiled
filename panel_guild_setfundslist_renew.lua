Panel_Guild_SetFundsList:SetShow(false)
Panel_Guild_SetFundsList:ActiveMouseEventEffect(true)
Panel_Guild_SetFundsList:setMaskingChild(true)
Panel_Guild_SetFundsList:setGlassBackground(true)
Panel_Guild_SetFundsList:SetDragEnable(true)
Panel_Guild_SetFundsList:SetDragAll(true)
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local maxGuildList = 19
local maxIncentiveGrade = 4
local _guildList = {}
local _selectedMemberIndex = 0
local _selectSortType = -1
local _listSort = {name = false, tempFundsVal = "0"}
local _guildMemberList = {}
local _guildInfo = {}
local _frameGuildList = UI.getChildControl(Panel_Guild_SetFundsList, "Frame_GuildList")
local _contentGuildList = UI.getChildControl(_frameGuildList, "Frame_1_Content")
local _scroll = UI.getChildControl(_frameGuildList, "VerticalScroll")
local _staticBottomBG = UI.getChildControl(Panel_Guild_SetFundsList, "Static_BottomBG")
local _staticBottomBG2 = UI.getChildControl(Panel_Guild_SetFundsList, "Static_BottomBG2")
local _btnSetEachFunds = UI.getChildControl(_staticBottomBG, "Button_SetEachFunds")
local _btnSetAllFunds = UI.getChildControl(_staticBottomBG2, "Button_SetAllFunds")
local _editAllFunds = UI.getChildControl(_staticBottomBG2, "Edit_InputAllFunds")
local _checkAllUnlimited = UI.getChildControl(_staticBottomBG2, "CheckButton_FundsLimit")
local _btnClose = UI.getChildControl(Panel_Guild_SetFundsList, "Button_WinClose")
local _btnQuestion = UI.getChildControl(Panel_Guild_SetFundsList, "Button_Question")
_btnSetAllFunds:addInputEvent("Mouse_LUp", "Guild_Funds_SetAllFunds()")
_btnSetEachFunds:addInputEvent("Mouse_LUp", "Guild_Funds_SetEachFunds()")
_editAllFunds:addInputEvent("Mouse_LUp", "Guild_Funds_EditAllFunds()")
_checkAllUnlimited:addInputEvent("Mouse_LUp", "Guild_Funds_CheckAllUnlimited()")
_btnClose:addInputEvent("Mouse_LUp", "Panel_Guild_SetFundsList_Close()")
_btnQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelGuild\" )")
_btnQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelGuild\", \"true\")")
_btnQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelGuild\", \"false\")")
local Guild_Funds = {
  _memberGrade = UI.getChildControl(Panel_Guild_SetFundsList, "StaticText_C_Grade"),
  _memberName = UI.getChildControl(Panel_Guild_SetFundsList, "StaticText_C_CharName"),
  _memberContribution = UI.getChildControl(Panel_Guild_SetFundsList, "StaticText_C_ContributedTendency"),
  _memberFundsLimitEdit = UI.getChildControl(Panel_Guild_SetFundsList, "Edit_C_InputFunds"),
  _memberFundsIsUnlimited = UI.getChildControl(Panel_Guild_SetFundsList, "CheckButton_C_FundsLimit"),
  _title_CharName = UI.getChildControl(Panel_Guild_SetFundsList, "StaticText_M_CharName"),
  _title_Ap = UI.getChildControl(Panel_Guild_SetFundsList, "StaticText_M_ContributedTendency"),
  _title_Funds = UI.getChildControl(Panel_Guild_SetFundsList, "StaticText_M_Funds")
}
Guild_Funds._title_CharName:addInputEvent("Mouse_LUp", "HandleClicked_GuildFundsSort(0)")
Guild_Funds._title_Ap:addInputEvent("Mouse_LUp", "HandleClicked_GuildFundsSort(1)")
Guild_Funds._title_Funds:addInputEvent("Mouse_LUp", "HandleClicked_GuildFundsSort(2)")
Guild_Funds._memberGrade:SetShow(false)
Guild_Funds._memberName:SetShow(false)
Guild_Funds._memberContribution:SetShow(false)
Guild_Funds._memberFundsLimitEdit:SetShow(false)
Guild_Funds._memberFundsIsUnlimited:SetShow(false)
local _ySize = Guild_Funds._memberGrade:GetSizeY()
local frameTextGap = 10
local _memberCtrlCount = 0
function Guild_Funds:ResetControl()
  _guildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == _guildInfo then
    return
  end
  _memberCtrlCount = _guildInfo:getMemberCount()
  if maxGuildList < _memberCtrlCount then
    _scroll:SetShow(true)
  else
    _scroll:SetShow(false)
  end
  _contentGuildList:DestroyAllChild()
  for index = 1, _memberCtrlCount do
    _guildList[index] = {}
    _guildList[index]._memberGrade = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, _contentGuildList, "StaticText_Grade_" .. index - 1)
    _guildList[index]._memberName = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, _contentGuildList, "StaticText_MemberName_" .. index - 1)
    _guildList[index]._memberContribution = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, _contentGuildList, "StaticText_MemberContribution_" .. index - 1)
    _guildList[index]._memberFundsLimitEdit = UI.createControl(UCT.PA_UI_CONTROL_EDIT, _contentGuildList, "Edit_memberInputFunds_" .. index - 1)
    _guildList[index]._memberFundsIsUnlimited = UI.createControl(UCT.PA_UI_CONTROL_CHECKBUTTON, _contentGuildList, "Check_memberFundsButton_" .. index - 1)
    CopyBaseProperty(Guild_Funds._memberGrade, _guildList[index]._memberGrade)
    CopyBaseProperty(Guild_Funds._memberName, _guildList[index]._memberName)
    CopyBaseProperty(Guild_Funds._memberContribution, _guildList[index]._memberContribution)
    CopyBaseProperty(Guild_Funds._memberFundsLimitEdit, _guildList[index]._memberFundsLimitEdit)
    CopyBaseProperty(Guild_Funds._memberFundsIsUnlimited, _guildList[index]._memberFundsIsUnlimited)
    local guildMemberInfo = _guildInfo:getMember(index - 1)
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
    posY = (_ySize + frameTextGap / 2) * (index - 1) + frameTextGap
    _guildList[index]._memberGrade:SetPosY(posY)
    _guildList[index]._memberGrade:SetShow(true)
    _guildList[index]._memberName:SetPosY(posY)
    _guildList[index]._memberName:SetShow(true)
    _guildList[index]._memberContribution:SetPosY(posY)
    _guildList[index]._memberContribution:SetShow(true)
    _guildList[index]._memberFundsLimitEdit:SetPosY(posY)
    _guildList[index]._memberFundsLimitEdit:SetShow(true)
    _guildList[index]._memberFundsIsUnlimited:SetPosY(posY)
    _guildList[index]._memberFundsIsUnlimited:SetShow(true)
  end
  Panel_Guild_SetFundsList:SetChildIndex(Guild_Funds._title_CharName, 9999)
  Panel_Guild_SetFundsList:SetChildIndex(Guild_Funds._title_Ap, 9999)
  Panel_Guild_SetFundsList:SetChildIndex(Guild_Funds._title_Funds, 9999)
  _frameGuildList:UpdateContentScroll()
  _scroll:SetControlTop()
  _frameGuildList:UpdateContentPos()
end
function Guild_Funds:UpdateData()
  GuildFunds_SetGuildMemberList()
  GuildFunds_updateSort()
  _guildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == _guildInfo then
    return
  end
  local memberCount = _guildInfo:getMemberCount()
  for index = 1, memberCount do
    local dataIdx = _guildMemberList[index].idxFromServer
    local guildMemberInfo = _guildInfo:getMember(dataIdx)
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
    local memberIsLimit = guildMemberInfo:getIsPriceLimit()
    _guildList[index]._memberFundsIsUnlimited:SetCheck(not memberIsLimit)
    if true == memberIsLimit then
      _guildList[index]._memberFundsLimitEdit:SetText(makeDotMoney(guildMemberInfo:getPriceLimit()))
      _guildList[index]._memberFundsLimitEdit:SetIgnore(false)
    else
      _guildList[index]._memberFundsLimitEdit:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_USEGUILDFUNDS_UNLIMITED"))
      _guildList[index]._memberFundsLimitEdit:SetIgnore(true)
    end
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
    if 0 == gradeType then
      _guildList[index]._memberFundsLimitEdit:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_USEGUILDFUNDS_UNLIMITED"))
      _guildList[index]._memberFundsLimitEdit:SetIgnore(true)
      _guildList[index]._memberFundsIsUnlimited:SetCheck(true)
      _guildList[index]._memberFundsIsUnlimited:SetIgnore(true)
    else
      _guildList[index]._memberFundsIsUnlimited:SetIgnore(false)
      _guildList[index]._memberFundsIsUnlimited:addInputEvent("Mouse_LUp", "ToggleLimitOfMember(" .. index .. ")")
      _guildList[index]._memberFundsLimitEdit:addInputEvent("Mouse_LUp", "SetTempFundsOfMember(" .. index .. ")")
    end
  end
  _scroll:SetInterval(_contentGuildList:GetSizeY() / 100 * 1.1)
end
function SetTempFundsOfMember(index)
  local dataIdx = _guildMemberList[index].idxFromServer
  Panel_NumberPad_Show(true, _guildInfo:getGuildBusinessFunds_s64(), index, SetTempFundsOfMemberCallback)
end
function SetTempFundsOfMemberCallback(fundsValue, index)
  local dataIdx = _guildMemberList[index].idxFromServer
  local guildMemberInfo = _guildInfo:getMember(dataIdx)
  if fundsValue == guildMemberInfo:getPriceLimit() then
    _guildList[index]._memberFundsLimitEdit:SetText("<PAColor0xffefefef>" .. tostring(makeDotMoney(fundsValue)) .. "<PAOldColor>")
  else
    _guildList[index]._memberFundsLimitEdit:SetText("<PAColor0xff00b4ff>" .. tostring(makeDotMoney(fundsValue)) .. "<PAOldColor>")
  end
  _guildMemberList[index].tempFundsVal = tostring(fundsValue)
end
function ToggleLimitOfMember(index)
  local dataIdx = _guildMemberList[index].idxFromServer
  local guildMemberInfo = _guildInfo:getMember(dataIdx)
  local memberIsUnlimited = not guildMemberInfo:getIsPriceLimit()
  if _guildList[index]._memberFundsIsUnlimited:IsCheck() then
    if memberIsUnlimited then
      _guildList[index]._memberFundsLimitEdit:SetText("<PAColor0xffefefef>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_USEGUILDFUNDS_UNLIMITED") .. "<PAOldColor>")
    else
      _guildList[index]._memberFundsLimitEdit:SetText("<PAColor0xff00b4ff>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_USEGUILDFUNDS_UNLIMITED") .. "<PAOldColor>")
    end
    _guildList[index]._memberFundsLimitEdit:SetIgnore(true)
    _guildMemberList[index].tempFundsVal = "0"
  else
    local priceLimit = guildMemberInfo:getPriceLimit()
    if memberIsUnlimited then
      _guildList[index]._memberFundsLimitEdit:SetText("<PAColor0xff00b4ff>" .. tostring(makeDotMoney(priceLimit)) .. "<PAOldColor>")
    else
      _guildList[index]._memberFundsLimitEdit:SetText("<PAColor0xffefefef>" .. tostring(makeDotMoney(priceLimit)) .. "<PAOldColor>")
    end
    _guildList[index]._memberFundsLimitEdit:SetIgnore(false)
    _guildMemberList[index].tempFundsVal = tostring(priceLimit)
  end
end
function Guild_Funds_SetEachFunds()
  if false == PaGlobal_Guild_SetFundsList_safeZoneCheck() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_ALERT"))
    return
  end
  for index = 1, _guildInfo:getMemberCount() do
    local dataIdx = _guildMemberList[index].idxFromServer
    local guildMember = _guildInfo:getMember(dataIdx)
    if 0 ~= guildMember:getGrade() then
      if _guildList[index]._memberFundsIsUnlimited:IsCheck() then
        if guildMember:getIsPriceLimit() then
          ToClient_SetGuildMemberPriceLimit(dataIdx, 0, false)
          _guildList[index]._memberFundsLimitEdit:SetText("<PAColor0xffefefef>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_USEGUILDFUNDS_UNLIMITED") .. "<PAOldColor>")
        end
      elseif not guildMember:getIsPriceLimit() then
        ToClient_SetGuildMemberPriceLimit(dataIdx, _guildMemberList[index].tempFundsVal, true)
        _guildList[index]._memberFundsLimitEdit:SetText("<PAColor0xffefefef>" .. tostring(makeDotMoney(_guildMemberList[index].tempFundsVal)) .. "<PAOldColor>")
      elseif _guildMemberList[index].tempFundsVal ~= tostring(guildMember:getPriceLimit()) then
        ToClient_SetGuildMemberPriceLimit(dataIdx, _guildMemberList[index].tempFundsVal, true)
        _guildList[index]._memberFundsLimitEdit:SetText("<PAColor0xffefefef>" .. tostring(makeDotMoney(_guildMemberList[index].tempFundsVal)) .. "<PAOldColor>")
      end
    end
  end
end
function Panel_Guild_SetFundsList_Close()
  if Panel_Guild_SetFundsList:GetShow() then
    Panel_Guild_SetFundsList:SetShow(false)
  end
end
function Panel_Guild_SetFundsList_Resize()
  Panel_Guild_SetFundsList:SetPosX(getScreenSizeX() / 2 - Panel_Guild_SetFundsList:GetSizeX() / 2)
  Panel_Guild_SetFundsList:SetPosY(getScreenSizeY() / 2 - Panel_Guild_SetFundsList:GetSizeY() / 2 - 50)
end
function PaGlobal_Guild_SetFundsList_Open()
  if PaGlobal_Guild_SetFundsList_safeZoneCheck() then
    _guildInfo = ToClient_GetMyGuildInfoWrapper()
    Panel_Guild_SetFundsList:SetShow(true)
    Guild_Funds:ResetControl()
    Guild_Funds:UpdateData()
    Panel_Guild_SetFundsList_Resize()
    _editAllFunds:SetText("0")
    _editAllFunds:SetIgnore(false)
    _checkAllUnlimited:SetCheck(false)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_ALERT"))
  end
end
function PaGlobal_Guild_SetFundsList_safeZoneCheck()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local pcPosition = player:get():getPosition()
  if nil == pcPosition then
    return
  end
  local regionInfo = getRegionInfoByPosition(pcPosition)
  return regionInfo:get():isSafeZone()
end
function GuildFunds_TitleLineReset()
  local self = Guild_Funds
  self._title_CharName:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CHARNAME"))
  self._title_Ap:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_ACTIVITY"))
  self._title_Funds:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CURRENTFUNDS"))
end
function GuildFunds_SetGuildMemberList()
  _guildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == _guildInfo then
    return
  end
  local memberCount = _guildInfo:getMemberCount()
  _guildMemberList = {}
  for index = 1, memberCount do
    local myGuildMemberInfo = _guildInfo:getMember(index - 1)
    _guildMemberList[index] = {
      idxFromServer = index - 1,
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
      tempFundsVal = tostring(myGuildMemberInfo:getPriceLimit())
    }
  end
end
local function guildFundsCompareByName(w1, w2)
  if true == _listSort.name then
    if w1.name < w2.name then
      return true
    end
  elseif w2.name < w1.name then
    return true
  end
end
local function guildFundsCompareByAp(w1, w2)
  if true == _listSort.ap then
    if w2.ap < w1.ap then
      return true
    end
  elseif w1.ap < w2.ap then
    return true
  end
end
local function guildFundsCompareByFunds(w1, w2)
  if true == _listSort.funds then
    if tonumber(w2.tempFundsVal) < tonumber(w1.tempFundsVal) then
      return true
    end
  elseif tonumber(w1.tempFundsVal) < tonumber(w2.tempFundsVal) then
    return true
  end
end
function HandleClicked_GuildFundsSort(sortType)
  local self = Guild_Funds
  GuildFunds_TitleLineReset()
  _selectSortType = sortType
  if 0 == sortType then
    if false == _listSort.name then
      self._title_CharName:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CHARNAME") .. "\226\150\178")
      _listSort.name = true
    else
      self._title_CharName:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CHARNAME") .. "\226\150\188")
      _listSort.name = false
    end
    table.sort(_guildMemberList, guildFundsCompareByName)
  elseif 1 == sortType then
    if false == _listSort.ap then
      self._title_Ap:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_ACTIVITY") .. "\226\150\178")
      _listSort.ap = true
    else
      self._title_Ap:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_ACTIVITY") .. "\226\150\188")
      _listSort.ap = false
    end
    table.sort(_guildMemberList, guildFundsCompareByAp)
  elseif 2 == sortType then
    if false == _listSort.funds then
      self._title_Funds:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CURRENTFUNDS") .. "\226\150\178")
      _listSort.funds = true
    else
      self._title_Funds:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CURRENTFUNDS") .. "\226\150\188")
      _listSort.funds = false
    end
    table.sort(_guildMemberList, guildFundsCompareByFunds)
  end
  Guild_Funds:UpdateData()
end
function GuildFunds_updateSort()
  local self = Guild_Funds
  if 0 == _selectSortType then
    table.sort(_guildMemberList, guildFundsCompareByName)
  elseif 1 == _selectSortType then
    table.sort(_guildMemberList, guildFundsCompareByAp)
  elseif 2 == _selectSortType then
    table.sort(_guildMemberList, guildFundsCompareByFunds)
  end
end
function Guild_Funds_EditAllFunds()
  Panel_NumberPad_Show(true, _guildInfo:getGuildBusinessFunds_s64(), 0, Guild_Funds_EditAllFundsCallBack)
end
function Guild_Funds_EditAllFundsCallBack(inputNumber)
  _editAllFunds:SetText(tostring(inputNumber))
end
function Guild_Funds_CheckAllUnlimited()
  if _checkAllUnlimited:IsCheck() then
    _editAllFunds:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_USEGUILDFUNDS_UNLIMITED"))
    _editAllFunds:SetIgnore(true)
  else
    _editAllFunds:SetText("0")
    _editAllFunds:SetIgnore(false)
  end
end
function Guild_Funds_SetAllFunds()
  _guildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == _guildInfo then
    return
  end
  if false == PaGlobal_Guild_SetFundsList_safeZoneCheck() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_ALERT"))
    return
  end
  local allFundsVal = _editAllFunds:GetText()
  for i = 0, _guildInfo:getMemberCount() - 1 do
    local processed = false
    local guildMemberInfo = _guildInfo:getMember(i)
    if 0 ~= guildMemberInfo:getGrade() then
      if _checkAllUnlimited:IsCheck() then
        if guildMemberInfo:getIsPriceLimit() then
          ToClient_SetGuildMemberPriceLimit(i, 0, false)
        end
      elseif not guildMemberInfo:getIsPriceLimit() then
        ToClient_SetGuildMemberPriceLimit(i, allFundsVal, true)
      elseif allFundsVal ~= tostring(guildMemberInfo:getPriceLimit()) then
        ToClient_SetGuildMemberPriceLimit(i, allFundsVal, true)
      end
    end
  end
  Panel_Guild_SetFundsList_Close()
end
registerEvent("onScreenResize", "Panel_Guild_SetFundsList_Resize")
