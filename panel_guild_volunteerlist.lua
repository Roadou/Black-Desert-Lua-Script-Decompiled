local UCT = CppEnums.PA_UI_CONTROL_TYPE
PaGlobal_VolunteerListInfoPage = {
  _frameDefaultBG = nil,
  _subButtonMenuBG = nil,
  _ui = {
    listInfoTitleBG = nil,
    listening_Volume = nil,
    volunteerListBG = nil,
    bottomBg = nil,
    desc = nil,
    btnRecruite = nil
  },
  isGuildMaster = false,
  isGuildSubMaster = false,
  _volunteerList = {},
  _subButtonList = {},
  curClickVolunteerIdx = 0,
  _constVolunteerListMaxCount = 150
}
local subButtonStartPosX = 5
local _UI_SUB_MENU_BUTTON = {Type_ActivityCost = 1, Type_Count = 2}
function PaGlobal_VolunteerListInfoPage:init()
  if nil == Panel_Window_Guild then
    return
  end
  self._frameDefaultBG = UI.getChildControl(Panel_Window_Guild, "Static_Frame_VolunteerListBG")
  self._subButtonMenuBG = UI.getChildControl(Panel_Guild_Volunteer, "Static_FunctionBG")
  self._ui.listInfoTitleBG = UI.getChildControl(Panel_Guild_Volunteer, "Static_List_BG")
  self._ui.listening_Volume = UI.getChildControl(Panel_Guild_Volunteer, "Static_Listening_VolumeBG")
  self._ui.volunteerListBG = UI.getChildControl(Panel_Guild_Volunteer, "List2_VolunteerListBG")
  self._ui.bottomBg = UI.getChildControl(Panel_Guild_Volunteer, "Static_BottonBg")
  self._ui.staticText_Grade = UI.getChildControl(self._ui.listInfoTitleBG, "StaticText_M_Grade")
  self._ui.staticText_Level = UI.getChildControl(self._ui.listInfoTitleBG, "StaticText_M_Level")
  self._ui.staticText_Class = UI.getChildControl(self._ui.listInfoTitleBG, "StaticText_M_Class")
  self._ui.staticText_activity = UI.getChildControl(self._ui.listInfoTitleBG, "StaticText_M_Activity")
  self._ui.staticText_contributedTendency = UI.getChildControl(self._ui.listInfoTitleBG, "StaticText_M_ContributedTendency")
  self._ui.staticText_contract = UI.getChildControl(self._ui.listInfoTitleBG, "StaticText_M_Contract")
  self._ui.staticText_charName = UI.getChildControl(self._ui.listInfoTitleBG, "StaticText_M_CharName")
  self._ui.staticText_Voice = UI.getChildControl(self._ui.listInfoTitleBG, "StaticText_M_Voice")
  self._ui.staticText_WarGrade = UI.getChildControl(self._ui.listInfoTitleBG, "StaticText_WarGrade")
  self._ui.listening_VolumeSlider = UI.getChildControl(self._ui.listening_Volume, "Slider_ListeningVolume")
  self._ui.listening_VolumeSliderBtn = UI.getChildControl(self._ui.listening_VolumeSlider, "Slider_MicVol_Button")
  self._ui.listening_VolumeClose = UI.getChildControl(self._ui.listening_Volume, "Button_VolumeSetClose")
  self._ui.listening_VolumeButton = UI.getChildControl(self._ui.listening_Volume, "Checkbox_SpeakerIcon")
  self._ui.listening_VolumeValue = UI.getChildControl(self._ui.listening_Volume, "StaticText_SpeakerVolumeValue")
  self._ui.staticText_activity:addInputEvent("Mouse_On", "HandleOnOut_VolunteerList_titleTooltipShow(true, 0)")
  self._ui.staticText_activity:addInputEvent("Mouse_Out", "HandleOnOut_VolunteerList_titleTooltipShow(false, 0)")
  self._ui.staticText_contributedTendency:addInputEvent("Mouse_On", "HandleOnOut_VolunteerList_titleTooltipShow(true, 1)")
  self._ui.staticText_contributedTendency:addInputEvent("Mouse_Out", "HandleOnOut_VolunteerList_titleTooltipShow(false, 1)")
  self._ui.staticText_Voice:addInputEvent("Mouse_On", "HandleOnOut_VolunteerList_titleTooltipShow(true , 2)")
  self._ui.staticText_Voice:addInputEvent("Mouse_Out", "HandleOnOut_VolunteerList_titleTooltipShow(false, 2)")
  self._ui.staticText_WarGrade:addInputEvent("Mouse_On", "HandleOnOut_VolunteerList_titleTooltipShow(true, 3)")
  self._ui.staticText_WarGrade:addInputEvent("Mouse_Out", "HandleOnOut_VolunteerList_titleTooltipShow(false, 3)")
  self._ui.staticText_contract:addInputEvent("Mouse_On", "HandleOnOut_VolunteerList_titleTooltipShow(true, 4)")
  self._ui.staticText_contract:addInputEvent("Mouse_Out", "HandleOnOut_VolunteerList_titleTooltipShow(false, 4)")
  self._subButtonMenuBG:SetShow(false)
  self._ui.btn_activityCost = UI.getChildControl(self._subButtonMenuBG, "Button_AcivityCost")
  self._ui.btn_activityCost:addInputEvent("Mouse_LUp", "HandleClicked_VolunteerList_ActivityButton()")
  self._ui.desc = UI.getChildControl(self._ui.bottomBg, "StaticText_Desc")
  self._ui.btnRecruite = UI.getChildControl(self._ui.bottomBg, "Button_Invite")
  self._ui.btnRecruite:addInputEvent("Mouse_LUp", "HandleClicked_GuildVolunteer_Recruite()")
  if nil ~= getSelfPlayer() then
    self.isGuildMaster = getSelfPlayer():get():isGuildMaster()
    self.isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
    if true == self.isGuildMaster or true == self.isGuildSubMaster then
      self._ui.btnRecruite:SetShow(true)
    else
      self._ui.btnRecruite:SetShow(false)
    end
  else
    self._ui.btnRecruite:SetShow(false)
  end
  if false == isGameTypeKorea() then
    self._ui.staticText_contributedTendency:SetShow(false)
    self._ui.staticText_Voice:SetSpanSize(610, self._ui.staticText_Voice:GetSpanSize().y)
    self._ui.staticText_WarGrade:SetSpanSize(720, self._ui.staticText_WarGrade:GetSpanSize().y)
  end
  self._ui.volunteerListBG:changeAnimationSpeed(11)
  self._ui.volunteerListBG:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "Volunteerlist_ControlCreate")
  self._ui.volunteerListBG:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  PaGlobal_VolunteerListInfoPage_listUpdateData()
  self._ui.listening_Volume:SetShow(false)
  self._frameDefaultBG:MoveChilds(self._frameDefaultBG:GetID(), Panel_Guild_Volunteer)
end
function HandleOnOut_VolunteerList_titleTooltipShow(isShow, titleType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_VolunteerListInfoPage
  local control, name, desc
  if 0 == titleType then
    control = self._ui.staticText_activity
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_ACTIVITY_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_ACTIVITY_CONTENTS")
  elseif 1 == titleType then
    control = self._ui.staticText_contributedTendency
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_CONTRIBUTEDTENDENCY_TOOLTIP_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_CONTRIBUTEDTENDENCY_TOOLTIP_DESC")
  elseif 2 == titleType then
    control = self._ui.staticText_Voice
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_VOICECHAT_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_VOICECHAT_TOOLTIP_DESC")
  elseif 3 == titleType then
    control = self._ui.staticText_WarGrade
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_DESC")
  elseif 4 == titleType then
    control = self._ui.staticText_contract
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRACT_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRACT_CONTENTS")
  end
  TooltipSimple_Show(control, name, desc)
end
function HandleClicked_GuildVolunteer_Recruite()
  PaGlobalFunc_GuildRegistSoldier_Open()
end
function HandleClicked_VolunteerList_ContractButton(isSelf, index)
  FGlobal_AgreementVolunteer_ListContract_Open(isSelf, index)
end
function HandleClicked_VolunteerList_Menu(index)
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_VolunteerListInfoPage
  local volunteerMember = ToClient_GetMyGuildInfoWrapper():getVolunteerMember(index - 1)
  local buttonPosY = 5
  self.curClickVolunteerIdx = 0
  if true == self._subButtonMenuBG:GetShow() then
    self._subButtonMenuBG:SetShow(false)
    return
  end
  local isOnline = false
  if true == volunteerMember:isOnline() and false == volunteerMember:isGhostMode() then
    self._subButtonMenuBG:SetPosX(self._ui.staticText_charName:GetPosX() + 150)
    self._subButtonMenuBG:SetPosY(self._ui.staticText_charName:GetPosY() + 30 * index)
    self._subButtonMenuBG:SetShow(true)
    self.curClickVolunteerIdx = index
  end
end
function HandleClicked_VolunteerList_ActivityButton()
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_VolunteerListInfoPage
  if 0 == self.curClickVolunteerIdx then
    return
  end
  self._subButtonMenuBG:SetShow(false)
  PaGlobal_Guild_UseGuildFunds:ShowToggle(self.curClickVolunteerIdx - 1, true, true)
end
function HandleOnOut_VolunteerList_GradeTooltip(isShow, index)
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_VolunteerListInfoPage
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_VOLUNTEER_LIST_GRADE_ICON_TOOLTIP")
  control = self._volunteerList[index]._stc_grade
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HandleOnOut_VolunteerList_ContractTooltipShow(isShow, index)
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_VolunteerListInfoPage
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_VOLUNTEER_LIST_CONTRACT_BUTTON_TOOLTIP_TITLE")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_VOLUNTEER_LIST_CONTRACT_BUTTON_TOOLTIP_DESC")
  control = self._volunteerList[index]._btn_contract
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function FromeClient_ResponsVolunteerUpdate()
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_VolunteerListInfoPage
  if true == Panel_Window_Guild:GetShow() then
    self._ui.volunteerListBG:getElementManager():clearKey()
    PaGlobal_VolunteerListInfoPage_listUpdateData()
  end
  if nil == self._ui.btnRecruite then
    return
  end
  if nil ~= getSelfPlayer() then
    self.isGuildMaster = getSelfPlayer():get():isGuildMaster()
    self.isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
    if true == self.isGuildMaster or true == self.isGuildSubMaster then
      self._ui.btnRecruite:SetShow(true)
    else
      self._ui.btnRecruite:SetShow(false)
    end
  else
    self._ui.btnRecruite:SetShow(false)
  end
end
function PaGlobal_VolunteerListInfoPage_listUpdateData()
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_VolunteerListInfoPage
  local curGuildInfoWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == curGuildInfoWrapper then
    return
  end
  local volunteerCount = curGuildInfoWrapper:getVolunteerMemberCount()
  if 0 == volunteerCount then
    return
  end
  for ii = 1, volunteerCount do
    self._ui.volunteerListBG:getElementManager():pushKey(toInt64(0, ii))
  end
  Panel_Window_Guild:SetChildIndex(self._subButtonMenuBG, 9998)
end
function Volunteerlist_ControlCreate(contents, index)
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_VolunteerListInfoPage
  local listContents = {
    _stc_grade = UI.getChildControl(contents, "StaticText_Grade"),
    _stc_level = UI.getChildControl(contents, "StaticText_Level"),
    _stc_class = UI.getChildControl(contents, "StaticText_Class"),
    _stc_nickName = UI.getChildControl(contents, "StaticText_CharName"),
    _stc_activity = UI.getChildControl(contents, "StaticText_Activity"),
    _stc_contribute = UI.getChildControl(contents, "StaticText_ContributedTendency"),
    _stc_voiceSaying = UI.getChildControl(contents, "StaticText_Voice_Saying"),
    _stc_voiceListening = UI.getChildControl(contents, "StaticText_Voice_Listening"),
    _btn_joinWar = UI.getChildControl(contents, "Button_WarGrade"),
    _stc_stateWar = UI.getChildControl(contents, "Button_WarState"),
    _btn_contract = UI.getChildControl(contents, "Button_Contract")
  }
  if false == isGameTypeKorea() then
    listContents._stc_contribute:SetShow(false)
    listContents._stc_voiceSaying:SetSpanSize(605, listContents._stc_voiceSaying:GetSpanSize().y)
    listContents._stc_voiceListening:SetSpanSize(630, listContents._stc_voiceListening:GetSpanSize().y)
    listContents._btn_joinWar:SetSpanSize(720, listContents._btn_joinWar:GetSpanSize().y)
    listContents._stc_stateWar:SetSpanSize(720, listContents._stc_stateWar:GetSpanSize().y)
  end
  local index32 = Int64toInt32(index)
  self._volunteerList[index32] = listContents
  local curGuildInfoWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == curGuildInfoWrapper then
    return
  end
  local volunteerMemberInfo = curGuildInfoWrapper:getVolunteerMember(index32 - 1)
  if nil == volunteerMemberInfo then
    return
  end
  listContents._stc_grade:SetText("")
  listContents._stc_grade:SetSize(43, 26)
  listContents._stc_grade:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_ETC_Guild.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(listContents._stc_grade, 227, 17, 270, 43)
  listContents._stc_grade:getBaseTexture():setUV(x1, y1, x2, y2)
  listContents._stc_grade:setRenderTexture(listContents._stc_grade:getBaseTexture())
  listContents._stc_grade:SetIgnore(false)
  listContents._stc_grade:addInputEvent("Mouse_On", "HandleOnOut_VolunteerList_GradeTooltip(true, " .. index32 .. ")")
  listContents._stc_grade:addInputEvent("Mouse_Out", "HandleOnOut_VolunteerList_GradeTooltip(false, " .. index32 .. ")")
  local volunteerLevel = volunteerMemberInfo:getLevel()
  listContents._stc_level:SetText(volunteerLevel)
  local volunteerClass = self:getClassText(volunteerMemberInfo:getClassType())
  listContents._stc_class:SetText(volunteerClass)
  local volunteerName = volunteerMemberInfo:getName() .. " (" .. volunteerMemberInfo:getCharacterName() .. ")"
  listContents._stc_nickName:SetText(volunteerName)
  if false == volunteerMemberInfo:isSelf() and nil ~= getSelfPlayer() then
    if true == self.isGuildMaster or true == self.isGuildSubMaster then
      listContents._stc_nickName:SetIgnore(false)
      listContents._stc_nickName:addInputEvent("Mouse_LUp", "HandleClicked_VolunteerList_Menu(" .. index32 .. ")")
    end
  else
    listContents._stc_nickName:SetIgnore(true)
  end
  listContents._stc_activity:SetText("-")
  local maxWp = volunteerMemberInfo:getMaxWp()
  if 0 == maxWp or true == volunteerMemberInfo:isGhostMode() then
    maxWp = "-"
  end
  local explorationPoint = volunteerMemberInfo:getExplorationPoint()
  listContents._stc_contribute:SetText(maxWp .. "/" .. explorationPoint)
  local participantText = PAGetString(Defines.StringSheet_GAME, "LUA_SIEGE_PARTICIPANT")
  local nonparticipantText = PAGetString(Defines.StringSheet_GAME, "LUA_SIEGE_NONPARTICIPANT")
  if true == volunteerMemberInfo:isSelf() or true == self.isGuildMaster or true == self.isGuildSubMaster then
    listContents._btn_joinWar:SetShow(true)
    listContents._stc_stateWar:SetShow(false)
    if volunteerMemberInfo:isSiegeParticipant() then
      listContents._btn_joinWar:SetText(participantText)
      listContents._btn_joinWar:addInputEvent("Mouse_LUp", "FGlobal_requestParticipateAtSiege( false )")
    else
      listContents._btn_joinWar:SetText(nonparticipantText)
      listContents._btn_joinWar:addInputEvent("Mouse_LUp", "FGlobal_requestParticipateAtSiege( true )")
    end
  else
    listContents._btn_joinWar:SetShow(false)
    listContents._stc_stateWar:SetShow(true)
    listContents._stc_stateWar:SetIgnore(true)
    if false == isRealServiceMode() then
      listContents._stc_stateWar:addInputEvent("Mouse_LUp", "FGlobal_requestParticipateAtSiegeFromMaster( " .. tostring(volunteerMemberInfo:getUserNo()) .. " )")
    end
    if volunteerMemberInfo:isSiegeParticipant() then
      listContents._stc_stateWar:SetText(participantText)
    else
      listContents._stc_stateWar:SetText(nonparticipantText)
    end
  end
  local isOnline = true == volunteerMemberInfo:isOnline() and false == volunteerMemberInfo:isGhostMode()
  if false == isOnline then
    listContents._stc_level:SetText("-")
    listContents._stc_level:SetFontColor(Defines.Color.C_FF515151)
    listContents._stc_class:SetText("-")
    listContents._stc_class:SetFontColor(Defines.Color.C_FF515151)
    listContents._stc_nickName:SetText(volunteerMemberInfo:getName() .. " ( - )")
    listContents._stc_nickName:SetFontColor(Defines.Color.C_FF515151)
    listContents._stc_activity:SetFontColor(Defines.Color.C_FF515151)
    listContents._stc_contribute:SetFontColor(Defines.Color.C_FF515151)
  else
    listContents._stc_level:SetFontColor(Defines.Color.C_FFC4BEBE)
    listContents._stc_class:SetFontColor(Defines.Color.C_FFC4BEBE)
    if true == volunteerMemberInfo:isSelf() then
      listContents._stc_nickName:SetFontColor(Defines.Color.C_FFEF9C7F)
    else
      listContents._stc_nickName:SetFontColor(Defines.Color.C_FFC4BEBE)
    end
    listContents._stc_activity:SetFontColor(Defines.Color.C_FFC4BEBE)
    listContents._stc_contribute:SetFontColor(Defines.Color.C_FFC4BEBE)
  end
  if true == self.isGuildMaster or true == self.isGuildSubMaster or true == volunteerMemberInfo:isSelf() then
    listContents._btn_contract:SetMonoTone(false)
    listContents._btn_contract:SetIgnore(false)
    if true == volunteerMemberInfo:isSelf() then
      listContents._btn_contract:addInputEvent("Mouse_LUp", "HandleClicked_VolunteerList_ContractButton( true, " .. index32 .. ")")
    else
      listContents._btn_contract:addInputEvent("Mouse_LUp", "HandleClicked_VolunteerList_ContractButton( false, " .. index32 .. ")")
    end
  else
    listContents._btn_contract:SetMonoTone(true)
    listContents._btn_contract:addInputEvent("Mouse_LUp", "")
  end
  listContents._btn_contract:addInputEvent("Mouse_On", "HandleOnOut_VolunteerList_ContractTooltipShow(true, " .. index32 .. ")")
  listContents._btn_contract:addInputEvent("Mouse_Out", "HandleOnOut_VolunteerList_ContractTooltipShow(false, " .. index32 .. ")")
end
function PaGlobal_VolunteerListInfoPage:getClassText(classType)
  if nil == classType then
    return
  end
  return CppEnums.ClassType2String[classType]
end
function PaGlobal_VolunteerListInfoPage:registMessageHandler()
  if false == _ContentsGroup_RenewUI_Guild then
    registerEvent("FromClient_ResponseGuildUpdate", "FromeClient_ResponsVolunteerUpdate")
    registerEvent("FromClient_ResponseParticipateSiege", "FromeClient_ResponsVolunteerUpdate")
    registerEvent("FromClient_ResponseChangeGuildMemberGrade", "FromeClient_ResponsVolunteerUpdate")
  end
end
function FGlobal_Guild_VolunteerList_Open()
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_VolunteerListInfoPage
  self._frameDefaultBG:SetShow(true)
  FromeClient_ResponsVolunteerUpdate()
  self._subButtonMenuBG:SetShow(false)
end
function FGlobal_Guild_VolunteerList_Close()
  if nil == Panel_Window_Guild then
    return
  end
  PaGlobal_VolunteerListInfoPage._frameDefaultBG:SetShow(false)
end
function FromClient_luaLoadComplete_Guild_VolunteerList()
  PaGlobal_GuildVolunteerList_Init()
  PaGlobal_VolunteerListInfoPage:registMessageHandler()
end
function PaGlobal_GuildVolunteerList_Init()
  PaGlobal_VolunteerListInfoPage:init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Guild_VolunteerList")
