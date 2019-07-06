local partyWidget = {
  _ui = {
    _static_PartyMember = {},
    _static_PartyMember_Template = UI.getChildControl(LobbyInstance_Widget_Party, "Static_PartyMember_Template")
  },
  _config = {
    _maxPartyMemberCount = 5,
    _gabY = 10,
    _isContentsEnable = ToClient_IsContentsGroupOpen("38"),
    _isLargePartyOpen = ToClient_IsContentsGroupOpen("286"),
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
    }
  },
  _isInitailized,
  _partyType,
  _refuseName,
  _isMainChannel,
  _isDevServer,
  _partyMemberCount,
  _partyData = {},
  _firstCheck = 0,
  _inviteRequestPlayerList = {}
}
function partyWidget:initialize()
  self:initControl()
  self:createControl()
  self:initData()
  self:addInputEvent()
  self._isInitailized = true
  self:setScreenSize()
end
function partyWidget:initData()
  self._isMainChannel = getCurrentChannelServerData()._isMain
  self._isDevServer = ToClient_IsDevelopment()
  self._partyMemberCount = 0
  self._partyData = {}
end
function partyWidget:initControl()
  LobbyInstance_Widget_Party:SetShow(false, false)
  changePositionBySever(LobbyInstance_Widget_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
end
function partyWidget:createControl()
  self._ui._static_PartyMember_Template:SetShow(false)
  local startPosY = self._ui._static_PartyMember_Template:GetPosY()
  for index = 1, self._config._maxPartyMemberCount do
    local info = {}
    info.control = UI.cloneControl(self._ui._static_PartyMember_Template, LobbyInstance_Widget_Party, "Static_PartyMember_" .. index)
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
  for index = 1, self._config._maxPartyMemberCount do
    local control = self._ui._static_PartyMember[index]
    control._button_Option:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyWidget_SelectPartyOption(" .. index .. ")")
  end
end
function PaGlobalFunc_PartyWidget_SelectPartyOption(index)
  partyWidget:selectPartyOption(index)
end
function partyWidget:selectPartyOption(index)
  local partyData = self._partyData[index]
  local control = self._ui._static_PartyMember[index]
  self:closePartyOption()
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
function PaGlobalFunc_PartyWidget_GetShow()
  return partyWidget:getShow()
end
function partyWidget:getShow()
  return LobbyInstance_Widget_Party:GetShow()
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
  self._inviteRequestPlayerList = {}
end
function PaGlobalFunc_PartyWidget_Open()
  if not partyWidget._isInitailized then
    return
  end
  partyWidget:open()
  partyWidget:createPartyList()
  partyWidget:updatePartyList()
end
function partyWidget:open()
  if true == LobbyInstance_Widget_Party:GetShow() then
    return
  end
  LobbyInstance_Widget_Party:SetShow(true)
end
function PaGlobalFunc_PartyWidget_Close()
  partyWidget:close()
end
function partyWidget:close()
  if false == LobbyInstance_Widget_Party:GetShow() then
    return
  end
  self:resetData()
  LobbyInstance_Widget_Party:SetShow(false)
end
function partyWidget:update()
  self._partyMemberCount = RequestParty_getPartyMemberCount()
end
function FGlobal_PartyMemberCount()
  return partyWidget._partyMemberCount
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
  if nil ~= PaGlobal_SetCreatePartyOnOptionPart then
    PaGlobal_SetCreatePartyOnOptionPart()
  end
end
function partyWidget:createPartyList()
  local partyMemberCount = RequestParty_getPartyMemberCount()
  if partyMemberCount > 0 then
    self._partyType = ToClient_GetPartyType()
    if not isFlushedUI() then
      self:open()
    end
    self:updatePartyList()
    self._partyMemberCount = partyMemberCount
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
  if true == LobbyInstance_Widget_Party:GetShow() then
    self:resetPartyData()
    self:setPartyMember(partyMemberCount)
    self:setMemberTexture(partyMemberCount)
    if partyMemberCount <= 0 then
      self:close()
    end
    self._partyMemberCount = partyMemberCount
  elseif false == LobbyInstance_Widget_Party:GetShow() and partyMemberCount > 1 then
    self:createPartyList()
    self:open()
  end
end
function partyWidget:setPartyMember(partyMemberCount)
  if partyMemberCount <= 0 then
    return
  end
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
  end
  local sortFunc = function(a, b)
    return a._isSelf
  end
  table.sort(self._partyData, sortFunc)
end
function partyWidget:setMemberTexture(partyMemberCount)
  local count = partyMemberCount + 1
  for index = 1, count do
    local memberControl = self._ui._static_PartyMember[index]
    local partyData = self._partyData[index]
    if nil ~= partyData then
      local characterValue = partyData._name
      memberControl.control:SetShow(true)
      memberControl._staticText_CharacterValue:SetText(characterValue)
      memberControl._progress2_Hp:SetProgressRate(partyData._currentHp / partyData._maxHp)
      memberControl._progress2_Mp:SetProgressRate(partyData._currentMp / partyData._maxMp)
      self:setClassIcon(memberControl._static_ClassIcon, partyData._class)
      self:setClassMpBar(memberControl._progress2_Mp, partyData._class)
      self:setStateIcon(memberControl, partyData)
    end
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
function partyWidget:setStateIcon(memberControl, partyData)
  if nil == memberControl then
    return
  end
  local isDead = partyData._currentHp <= 0
  local control = memberControl._staic_DeadState
  control:SetShow(isDead)
  control = memberControl._progress2_Mp
  control:SetShow(not isDead)
  control = memberControl._progress2_Hp
  control:SetShow(not isDead)
  control = memberControl._static_ProgressBg
  control:SetShow(not isDead)
  control = memberControl._static_ClassIconLeaderBg
  control:SetShow(false)
  local posX = memberControl._staticText_CharacterValue:GetTextSizeX()
  posX = posX + memberControl._staticText_CharacterValue:GetPosX() + 10
  control:SetPosX(posX)
end
function ResponseParty_invite(hostName, invitePartyType)
  partyWidget:invite(hostName, invitePartyType)
end
function partyWidget:invite(hostName, invitePartyType)
  if MessageBox:isShow() then
    return
  end
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
function PaGlobalFunc_PartyWidget_RenderModeChange(prevRenderModeList, nextRenderModeList)
  partyWidget:renderModeChange(prevRenderModeList, nextRenderModeList)
end
function partyWidget:renderModeChange(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  if 1 <= RequestParty_getPartyMemberCount() then
    self:resetData()
    self:close()
  else
    PaGlobalFunc_PartyWidget_Open()
  end
end
function PaGlobalFunc_PartyWidget_SetScreenSize()
  partyWidget:setScreenSize()
end
function partyWidget:setScreenSize()
  if not self._isInitailized then
    return
  end
  if 0 >= RequestParty_getPartyMemberCount() then
    self:resetData()
    self:close()
  else
    if not isFlushedUI() then
      PaGlobalFunc_PartyWidget_Open()
    end
    self:updatePartyList()
  end
  local initPosX = 10
  local initPosY = LobbyInstance_Widget_MyInfo:GetSizeY()
  local result = getScreenSizeY() - self._ui._static_PartyMember_Template:GetSizeY() * self._config._maxPartyMemberCount
  if result <= LobbyInstance_Widget_MyInfo:GetSizeY() + Instance_Chat:GetSizeY() then
    initPosX = LobbyInstance_Widget_MyInfo:GetSizeX() + 10
    initPosY = 0
  end
  LobbyInstance_Widget_Party:SetPosX(initPosX)
  LobbyInstance_Widget_Party:SetPosY(initPosY)
  FGlobal_PanelRepostionbyScreenOut(LobbyInstance_Widget_Party)
end
function PaGlobal_Widget_Party_PosUpdate()
  partyWidget:setScreenSize()
end
function FromClient_PartyWidget_luaLoadComplete()
  partyWidget:initialize()
end
function PartyOption_Hide()
  partyWidget:closePartyOption()
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
  registerEvent("FromClient_RenderModeChangeState", "PaGlobalFunc_PartyWidget_RenderModeChange")
end
changePositionBySever(LobbyInstance_Widget_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
partyWidget:registEventHandler()
