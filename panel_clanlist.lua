local CT2S = CppEnums.ClassType2String
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local IM = CppEnums.EProcessorInputMode
Panel_ClanList:SetShow(false)
Panel_ClanList:setMaskingChild(true)
Panel_ClanList:setGlassBackground(true)
Panel_ClanList:RegisterShowEventFunc(true, "clanList_ShowAni()")
Panel_ClanList:RegisterShowEventFunc(false, "clanList_HideAni()")
local clanList = {
  btn_Close = UI.getChildControl(Panel_ClanList, "Button_Win_Close"),
  btn_Question = UI.getChildControl(Panel_ClanList, "Button_Question"),
  btn_ClanDispersal = UI.getChildControl(Panel_ClanList, "Button_ClanDispersal"),
  btn_setSubMaster = nil,
  btn_kickClan = nil,
  btn_unsetSubMaster = nil,
  memberMenuBG = UI.getChildControl(Panel_ClanList, "Static_FunctionBG"),
  selectedMemberIdx = 0,
  selectedMemberUserNo = 0,
  frame = UI.getChildControl(Panel_ClanList, "Frame_ClanList"),
  listPool = {},
  maxMemberCount = 15
}
clanList.frameContent = UI.getChildControl(clanList.frame, "Frame_1_Content")
clanList.btn_Question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelClan\" )")
clanList.btn_Question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelClan\", \"true\")")
clanList.btn_Question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelClan\", \"false\")")
local Template = {
  memberGrade = UI.getChildControl(clanList.frameContent, "StaticText_C_Grade"),
  memberLevel = UI.getChildControl(clanList.frameContent, "StaticText_C_Level"),
  memberClass = UI.getChildControl(clanList.frameContent, "StaticText_C_Class"),
  memberName = UI.getChildControl(clanList.frameContent, "StaticText_C_CharName"),
  btn_memberMenu = UI.getChildControl(Panel_ClanList, "Button_Function")
}
function clanList_ShowAni()
  local aniInfo1 = Panel_ClanList:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.12)
  aniInfo1.AxisX = Panel_ClanList:GetSizeX() / 2
  aniInfo1.AxisY = Panel_ClanList:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_ClanList:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.12)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_ClanList:GetSizeX() / 2
  aniInfo2.AxisY = Panel_ClanList:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function clanList_HideAni()
  local aniInfo1 = Panel_ClanList:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
function clanList:Initialize()
  self.btn_setSubMaster = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self.memberMenuBG, "ClanList_SetSubMaster_BTN")
  CopyBaseProperty(Template.btn_memberMenu, self.btn_setSubMaster)
  self.btn_setSubMaster:SetPosX(8)
  self.btn_setSubMaster:SetPosY(8)
  self.btn_setSubMaster:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLANLIST_SUBMASTER"))
  self.btn_setSubMaster:SetShow(true)
  self.btn_kickClan = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self.memberMenuBG, "ClanList_KickClan_BTN")
  CopyBaseProperty(Template.btn_memberMenu, self.btn_kickClan)
  self.btn_kickClan:SetPosX(8)
  self.btn_kickClan:SetPosY(38)
  self.btn_kickClan:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_BTN_FIRE"))
  self.btn_kickClan:SetShow(true)
  self.btn_unsetSubMaster = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self.memberMenuBG, "ClanList_UnsetSubMasterClan_BTN")
  CopyBaseProperty(Template.btn_memberMenu, self.btn_unsetSubMaster)
  self.btn_unsetSubMaster:SetPosX(8)
  self.btn_unsetSubMaster:SetPosY(68)
  self.btn_unsetSubMaster:SetText(PAGetString(Defines.StringSheet_GAME, "GULD_BUTTON3"))
  self.btn_unsetSubMaster:SetShow(true)
  self.memberMenuBG:SetShow(false)
  local memberList_PosY = 5
  for memberIdx = 0, self.maxMemberCount - 1 do
    local temSlot = {}
    local Created_MemberGrade = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, self.frameContent, "ClanList_MemberGrade_" .. memberIdx)
    CopyBaseProperty(Template.memberGrade, Created_MemberGrade)
    Created_MemberGrade:SetPosY(memberList_PosY)
    Created_MemberGrade:SetText(memberIdx)
    Created_MemberGrade:SetShow(false)
    temSlot.MemberGrade = Created_MemberGrade
    local Created_MemberLevel = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_MemberGrade, "ClanList_MemberLevel_" .. memberIdx)
    CopyBaseProperty(Template.memberLevel, Created_MemberLevel)
    Created_MemberLevel:SetPosY(0)
    Created_MemberLevel:SetPosX(145)
    Created_MemberLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. memberIdx)
    Created_MemberLevel:SetShow(true)
    temSlot.MemberLevel = Created_MemberLevel
    local Created_MemberClass = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_MemberGrade, "ClanList_MemberClass_" .. memberIdx)
    CopyBaseProperty(Template.memberClass, Created_MemberClass)
    Created_MemberClass:SetPosY(0)
    Created_MemberClass:SetPosX(287)
    Created_MemberClass:SetText("")
    Created_MemberClass:SetShow(true)
    temSlot.MemberClass = Created_MemberClass
    local Created_MemberName = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_MemberGrade, "ClanList_MemberName_" .. memberIdx)
    CopyBaseProperty(Template.memberName, Created_MemberName)
    Created_MemberName:SetPosY(0)
    Created_MemberName:SetText("")
    Created_MemberName:SetShow(true)
    temSlot.MemberName = Created_MemberName
    self.listPool[memberIdx] = temSlot
    memberList_PosY = memberList_PosY + Created_MemberGrade:GetSizeY() + 10
  end
  self.frameContent:SetSize(self.frameContent:GetSizeX(), memberList_PosY)
  self.frame:UpdateContentPos()
  self.frame:UpdateContentScroll()
  Template.memberGrade:SetShow(false)
  Template.memberLevel:SetShow(false)
  Template.memberClass:SetShow(false)
  Template.memberName:SetShow(false)
  self.btn_ClanDispersal:SetShow(true)
end
function clanList:Update()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  if true == isGuildMaster then
    self.btn_ClanDispersal:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_CLAN"))
  else
    self.btn_ClanDispersal:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_WITHDRAW_CLAN"))
  end
  for memberIdx = 0, self.maxMemberCount - 1 do
    self.listPool[memberIdx].MemberGrade:SetShow(false)
  end
  local memberCount = myGuildInfo:getMemberCount()
  for memberIdx = 0, memberCount - 1 do
    local uiPool = self.listPool[memberIdx]
    uiPool.MemberGrade:SetShow(true)
    local memberData = myGuildInfo:getMember(memberIdx)
    local memberGrade = memberData:getGrade()
    local memberLevel = memberData:getLevel()
    local memberClass = memberData:getClassType()
    local memberName = memberData:getName() .. "(" .. memberData:getCharacterName() .. ")"
    local memberConnect = memberData:isOnline()
    if 0 == memberGrade then
      uiPool.MemberGrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMASTER"))
    elseif 1 == memberGrade then
      uiPool.MemberGrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDSUBMASTER"))
    elseif 2 == memberGrade then
      uiPool.MemberGrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMEMBER"))
    end
    uiPool.MemberLevel:SetText(memberData:getLevel())
    uiPool.MemberClass:SetText(CppEnums.ClassType2String[memberClass])
    if 12 == memberClass then
      uiPool.MemberClass:SetPosX(262)
    else
      uiPool.MemberClass:SetPosX(287)
    end
    if memberData:isOnline() == true then
      uiPool.MemberLevel:SetFontColor(UI_color.C_FFC4BEBE)
      uiPool.MemberClass:SetFontColor(UI_color.C_FFC4BEBE)
      uiPool.MemberName:SetFontColor(UI_color.C_FFC4BEBE)
      uiPool.MemberName:SetText(memberData:getName() .. " (" .. memberData:getCharacterName() .. ")")
    else
      uiPool.MemberLevel:SetFontColor(UI_color.C_FF515151)
      uiPool.MemberClass:SetFontColor(UI_color.C_FF515151)
      uiPool.MemberName:SetFontColor(UI_color.C_FF515151)
      uiPool.MemberName:SetText(memberData:getName() .. " ( - )")
      uiPool.MemberLevel:SetText("-")
      uiPool.MemberClass:SetText("-")
    end
    uiPool.MemberName:addInputEvent("Mouse_LUp", "HandleClicked_ClanList_MemberMenu(" .. memberIdx .. ")")
  end
end
function clanList:SetPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_ClanList:GetSizeX()
  local panelSizeY = Panel_ClanList:GetSizeY()
  Panel_ClanList:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Panel_ClanList:SetPosY(scrSizeY / 2 - panelSizeY / 2)
end
function clanList:Open()
  self:SetPosition()
  self:Update()
  Panel_ClanList:SetShow(true, true)
end
function clanList:Close()
  Panel_ClanList:SetShow(false, false)
end
function MouseOutClanMenuButton(isAlways)
  local self = clanList
  local sizeX = self.memberMenuBG:GetSizeX()
  local sizeY = self.memberMenuBG:GetSizeY()
  local posX = self.memberMenuBG:GetPosX()
  local posY = self.memberMenuBG:GetPosY()
  local mousePosX = getMousePosX() - Panel_ClanList:GetPosX()
  local mousePosY = getMousePosY() - Panel_ClanList:GetPosY()
  if false == isAlways then
    self.memberMenuBG:SetShow(false)
  elseif posX < mousePosX and mousePosX < posX + sizeX and posY < mousePosY and mousePosY < posY + sizeY then
  else
    self.memberMenuBG:SetShow(false)
  end
end
function HandleClicked_ClanList_MemberMenu(memberIdx)
  local self = clanList
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local memberData = myGuildInfo:getMember(memberIdx)
  if nil == memberData then
    return
  end
  local grade = memberData:getGrade()
  self.selectedMemberIdx = memberIdx
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local buttonListBgX = getMousePosX() - Panel_ClanList:GetPosX()
  local buttonListBgY = getMousePosY() - Panel_ClanList:GetPosY()
  self.memberMenuBG:SetPosX(buttonListBgX)
  self.memberMenuBG:SetPosY(buttonListBgY)
  self.memberMenuBG:SetSize(self.memberMenuBG:GetSizeX(), memberMenuBGSizeY)
  self.memberMenuBG:SetShow(true)
  self.memberMenuBG:SetIgnore(false)
  self.memberMenuBG:addInputEvent("Mouse_Out", "MouseOutClanMenuButton()")
  self.btn_setSubMaster:SetShow(false)
  self.btn_kickClan:SetShow(false)
  self.btn_unsetSubMaster:SetShow(false)
  if true == isGuildMaster then
    if 0 == grade then
      self.memberMenuBG:SetShow(false)
    elseif 1 == grade then
      self.btn_unsetSubMaster:SetShow(true)
      self.btn_unsetSubMaster:SetPosY(8)
      self.btn_kickClan:SetShow(true)
      self.btn_kickClan:SetPosY(38)
      self.memberMenuBG:SetSize(140, 70)
    else
      self.btn_setSubMaster:SetShow(true)
      self.btn_setSubMaster:SetPosY(8)
      self.btn_kickClan:SetShow(true)
      self.btn_kickClan:SetPosY(38)
      self.memberMenuBG:SetSize(140, 70)
    end
  elseif true == isGuildSubMaster then
    if 2 == grade then
      self.btn_kickClan:SetShow(true)
      self.btn_kickClan:SetPosY(38)
      self.memberMenuBG:SetSize(140, 40)
    else
      self.memberMenuBG:SetShow(false)
    end
  else
    self.memberMenuBG:SetShow(false)
  end
  self.btn_setSubMaster:addInputEvent("Mouse_LUp", "HandleClicked_ClanList_SetSubMaster()")
  self.btn_kickClan:addInputEvent("Mouse_LUp", "HandleClicked_ClanList_KickClan()")
  self.btn_unsetSubMaster:addInputEvent("Mouse_LUp", "HandleClicked_ClanList_UnsetSubMaster()")
end
function HandleClicked_ClanList_SetSubMaster()
  local self = clanList
  local memberIdx = self.selectedMemberIdx
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local memberData = myGuildInfo:getMember(memberIdx)
  if nil == memberData then
    return
  end
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_APPOINT_GUILDSUBMASTER")
  local messageContent = "'" .. memberData:getName() .. "'" .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_APPOINT_GUILDSUBMASTER_QUESTION")
  local yesFunction = _ClanList_SetSubMasterDo
  local messageboxData = {
    title = messageTitle,
    content = messageContent,
    functionYes = yesFunction,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
  MouseOutClanMenuButton(false)
  self.memberMenuBG:SetShow(false)
end
function _ClanList_SetSubMasterDo()
  local self = clanList
  local memberIdx = self.selectedMemberIdx
  ToClient_RequestChangeGuildMemberGrade(memberIdx, 1)
end
function HandleClicked_ClanList_KickClan()
  local self = clanList
  local memberIdx = self.selectedMemberIdx
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local memberData = myGuildInfo:getMember(memberIdx)
  if nil == memberData then
    return
  end
  self.selectedMemberUserNo = memberData:getUserNo()
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_EXPEL_CLANMEMBER")
  local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CLAN_TEXT_EXPEL_CLANMEMBER_QUESTION", "name", memberData:getName())
  local yesFunction = _ClanList_KickClanDo
  local messageboxData = {
    title = messageTitle,
    content = messageContent,
    functionYes = yesFunction,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
  MouseOutClanMenuButton(false)
  self.memberMenuBG:SetShow(false)
end
function _ClanList_KickClanDo()
  local self = clanList
  local memberIdx = self.selectedMemberIdx
  ToClient_RequestExpelMemberFromGuild(memberIdx, self.selectedMemberUserNo)
end
function HandleClicked_ClanList_UnsetSubMaster()
  local self = clanList
  local memberIdx = self.selectedMemberIdx
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local memberData = myGuildInfo:getMember(memberIdx)
  if nil == memberData then
    return
  end
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_CLAN_TEXT_DEMOTE_CLANMEMBER_TITLE")
  local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CLAN_TEXT_DEMOTE_CLANMEMBER_QUESTION", "name", memberData:getName())
  local yesFunction = _ClanList_UnsetSubMaster
  local messageboxData = {
    title = messageTitle,
    content = messageContent,
    functionYes = yesFunction,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MouseOutClanMenuButton(false)
  MessageBox.showMessageBox(messageboxData)
end
function _ClanList_UnsetSubMaster()
  local self = clanList
  local memberIdx = self.selectedMemberIdx
  ToClient_RequestChangeGuildMemberGrade(memberIdx, 2)
end
function HandleClicked_ClanList_LeaveClan()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    _PA_ASSERT(false, "ResponseGuildInviteForGuildGrade \236\151\144\236\132\156 \234\184\184\235\147\156 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local messageboxData
  if true == getSelfPlayer():get():isGuildMaster() then
    if ToClient_GetMyGuildInfoWrapper():getMemberCount() <= 1 then
      messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_CLAN"),
        content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_CLAN_ASK"),
        functionYes = _ClanList_LeaveClanContinue,
        functionNo = MessageBox_Empty_function,
        priority = UCT.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_CANT_CLAN_DISPERSE"))
    end
  else
    local tempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLANLIST_CLANOUT_ASK")
    messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_WITHDRAW_CLAN"),
      content = tempText,
      functionYes = _ClanList_DisJoinContinue,
      functionNo = MessageBox_Empty_function,
      priority = UCT.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function _ClanList_LeaveClanContinue()
  _ClanList_Close()
  ToClient_RequestDestroyGuild()
end
function _ClanList_DisJoinContinue()
  _ClanList_Close()
  ToClient_RequestDisjoinGuild()
end
function _ClanList_Close()
  clanList:Close()
end
function FGlobal_ClanList_Open()
  clanList:Open()
end
function FGlobal_ClanList_Close()
  clanList:Close()
end
function FGlobal_ClanList_Update()
  clanList:Update()
end
function clanList:registEventHandler()
  self.btn_Close:addInputEvent("Mouse_LUp", "_ClanList_Close()")
  self.btn_ClanDispersal:addInputEvent("Mouse_LUp", "HandleClicked_ClanList_LeaveClan()")
end
function clanList:registMessageHandler()
end
clanList:Initialize()
clanList:registEventHandler()
clanList:registMessageHandler()
