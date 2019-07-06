local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local IM = CppEnums.EProcessorInputMode
local VCK = CppEnums.VirtualKeyCode
local _panel = Panel_Window_Guild_Renew
local GuildMain = {
  _ui = {
    stc_TopBg = UI.getChildControl(_panel, "Static_TopBg"),
    stc_RadioBtnBg = UI.getChildControl(_panel, "Static_RadioButtonBg"),
    stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  },
  _tabBg = {},
  _tabIdxData = {
    guildInfo = 0,
    guildMember = 1,
    guildQuest = 2,
    guildSkill = 3,
    guildWarfareInfo = 4,
    dataCount = 5
  },
  _keyGuideList = {},
  _keyGuideType = {
    buttonA = 1,
    buttonY = 2,
    buttonX = 3,
    buttonB = 4
  },
  _btnCtrl = {},
  _currentTabIdx = 0,
  _keyGuideStartPos = 80,
  _targetUserNo = nil,
  _targetGuildNo = nil,
  _targetGuildName = nil
}
function GuildMain:open()
  ToClient_updateXboxGuildUserGamerTag()
  _panel:SetShow(true)
  self:openTab(self._tabIdxData.guildInfo)
end
function GuildMain:openTab(tabIdx_)
  for idx = 0, self._tabIdxData.dataCount - 1 do
    if tabIdx_ == idx then
      self._btnCtrl[tabIdx_]:SetFontColor(Defines.Color.C_FFEEEEEE)
      self._tabBg[tabIdx_]:SetShow(true)
    else
      self._btnCtrl[idx]:SetFontColor(Defines.Color.C_FF888888)
      self._tabBg[idx]:SetShow(false)
    end
  end
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LT, "")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RT, "")
  self._ui.txt_YConsoleUI:SetShow(false)
  self._ui.txt_XConsoleUI:SetShow(false)
  PaGlobalFunc_GuildMain_SetKeyGuide(1, true)
  if tabIdx_ == self._tabIdxData.guildInfo then
    self:updateGuildInfo()
    self:updateDeclareInfo()
    self:updateDeclaredByInfo()
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_GuildSettingFunction_Open()")
    self._ui.txt_YConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_MANAGER_TEXT_TITLE"))
    self._ui.txt_YConsoleUI:SetShow(true)
  elseif tabIdx_ == self._tabIdxData.guildMember then
    self._ui.txt_XConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_XBOX_PROFILE"))
    self._ui.txt_XConsoleUI:SetPosX(self._ui.txt_YConsoleUI:GetPosX() - self._ui.txt_XConsoleUI:GetSizeX() - self._ui.txt_XConsoleUI:GetTextSizeX() - 10)
    self._ui.txt_YConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_TOGGLE_SHOW"))
    self._ui.txt_YConsoleUI:SetShow(true)
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_GuildMemberList_SwapFamilyOrCharacterName()")
    PaGlobalFunc_GuildMemberList_Open()
  elseif tabIdx_ == self._tabIdxData.guildQuest then
    self._ui.txt_XConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_GETGUILDMEMBERBONUS_TITLE"))
    self._ui.txt_XConsoleUI:SetShow(true)
    _panel:registerPadEvent(__eConsoleUIPadEvent_LT, "InputMLUp_GuildQuestList_OpenQuestTabToLeft()")
    _panel:registerPadEvent(__eConsoleUIPadEvent_RT, "InputMLUp_GuildQuestList_OpenQuestTabToRight()")
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "FGlobal_GetGuildMemberBonus_Show()")
    PaGlobalFunc_GuildMain_SetKeyGuide(1, false)
    PaGlobalFunc_GuildQuestList_Open()
  elseif tabIdx_ == self._tabIdxData.guildSkill then
    self._ui.txt_XConsoleUI:SetPosX(500)
    PaGlobalFunc_GuildSkillList_Open()
  else
    if tabIdx_ == self._tabIdxData.guildWarfareInfo then
      PaGlobalFunc_GuildMain_SetKeyGuide(self._keyGuideType.buttonA, false)
      PaGlobalFunc_GuildWarfareInfo_Open()
    else
    end
  end
  PaGlobalFunc_GuildMain_updateKeyGuide()
end
function GuildMain:init()
  self._ui.stc_TopBg:SetShow(true)
  self._btnCtrl[self._tabIdxData.guildInfo] = UI.getChildControl(self._ui.stc_RadioBtnBg, "RadioButton_Information")
  self._btnCtrl[self._tabIdxData.guildMember] = UI.getChildControl(self._ui.stc_RadioBtnBg, "RadioButton_MemberList")
  self._btnCtrl[self._tabIdxData.guildQuest] = UI.getChildControl(self._ui.stc_RadioBtnBg, "RadioButton_Quest")
  self._btnCtrl[self._tabIdxData.guildSkill] = UI.getChildControl(self._ui.stc_RadioBtnBg, "RadioButton_Skill")
  self._btnCtrl[self._tabIdxData.guildWarfareInfo] = UI.getChildControl(self._ui.stc_RadioBtnBg, "RadioButton_WarfareInfo")
  self._btnCtrl[self._tabIdxData.guildMember]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._btnCtrl[self._tabIdxData.guildMember]:SetText(self._btnCtrl[self._tabIdxData.guildMember]:GetText())
  local tempBtnGroup = {
    self._btnCtrl[self._tabIdxData.guildInfo],
    self._btnCtrl[self._tabIdxData.guildMember],
    self._btnCtrl[self._tabIdxData.guildQuest],
    self._btnCtrl[self._tabIdxData.guildSkill],
    self._btnCtrl[self._tabIdxData.guildWarfareInfo]
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui.stc_RadioBtnBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_CENTER, 0, 30)
  self._tabBg[self._tabIdxData.guildInfo] = UI.getChildControl(_panel, "Static_GuildInformationBg")
  self._tabBg[self._tabIdxData.guildMember] = UI.getChildControl(_panel, "Static_GuildMemberBg")
  self._tabBg[self._tabIdxData.guildQuest] = UI.getChildControl(_panel, "Static_GuildQuestBg")
  self._tabBg[self._tabIdxData.guildSkill] = UI.getChildControl(_panel, "Static_GuildSkillBg")
  self._tabBg[self._tabIdxData.guildWarfareInfo] = UI.getChildControl(_panel, "Static_GuildWarfareInfoBg")
  self._ui.stc_InfoBg = UI.getChildControl(self._tabBg[self._tabIdxData.guildInfo], "Static_Bg_LeftTop")
  self._ui.stc_GuildMarkBg = UI.getChildControl(self._ui.stc_InfoBg, "Static_GuildMarkBg")
  self._ui.stc_GuildMarkIcon = UI.getChildControl(self._ui.stc_InfoBg, "Static_GuildMarkIcon")
  self._ui.txt_WarinfoTitle = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_WarinfoTitle")
  self._ui.txt_GuildName = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_GuildName")
  self._ui.txt_Fund = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_Fund")
  self._ui.txt_MasterName = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_MasterValue")
  self._ui.txt_GuildScale = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_ScaleValue")
  self._ui.txt_Protect = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_ProtectTitle")
  self._ui.txt_ProtectValue = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_ProtectValue")
  self._ui.txt_ProtectValue:SetSpanSize(self._ui.txt_Protect:GetSpanSize().x + self._ui.txt_Protect:GetTextSizeX() + 10, self._ui.txt_ProtectValue:GetSpanSize().y)
  self._ui.txt_GuildPoint = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_PointValue")
  self._ui.txt_WarinfoValue = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_WarinfoValue")
  self._ui.stc_InfoRightTopBg = UI.getChildControl(self._tabBg[self._tabIdxData.guildInfo], "Static_RightTop")
  self._ui.txt_GuildNotice = UI.getChildControl(self._ui.stc_InfoRightTopBg, "StaticText_NoticeValue")
  self._ui.txt_GuildNotice:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.stc_InfoRightMidBg = UI.getChildControl(self._tabBg[self._tabIdxData.guildInfo], "Static_RightMid")
  self._ui.txt_GuildIntroduce = UI.getChildControl(self._ui.stc_InfoRightMidBg, "StaticText_InfoValue")
  self._ui.txt_GuildIntroduce:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.stc_InfoBottomBg = UI.getChildControl(self._tabBg[self._tabIdxData.guildInfo], "Static_Bottom")
  self._ui.list_DeclareGuild = UI.getChildControl(self._ui.stc_InfoBottomBg, "List2_DeclareGuild")
  self._ui.list_DeclaredByGuild = UI.getChildControl(self._ui.stc_InfoBottomBg, "List2_DeclaredGuild")
  self._ui.txt_NoDeclaredBy = UI.getChildControl(self._ui.stc_InfoBottomBg, "StaticText_NoDeclare")
  self._ui.txt_NoDeclare = UI.getChildControl(self._ui.stc_InfoBottomBg, "StaticText_NoDeclared")
  self._ui.txt_BConsoleUI = UI.getChildControl(self._ui.stc_BottomBg, "Button_B_ConsoleUI")
  self._keyGuideList[self._keyGuideType.buttonB] = self._ui.txt_BConsoleUI
  self._ui.txt_AConsoleUI = UI.getChildControl(self._ui.stc_BottomBg, "Button_A_ConsoleUI")
  self._keyGuideList[self._keyGuideType.buttonA] = self._ui.txt_AConsoleUI
  self._ui.txt_YConsoleUI = UI.getChildControl(self._ui.stc_BottomBg, "Button_Y_ConsoleUI")
  self._keyGuideList[self._keyGuideType.buttonY] = self._ui.txt_YConsoleUI
  self._ui.txt_XConsoleUI = UI.getChildControl(self._ui.stc_BottomBg, "Button_X_ConsoleUI")
  self._keyGuideList[self._keyGuideType.buttonX] = self._ui.txt_XConsoleUI
  self:registEvent()
end
function GuildMain:updateGuildInfo()
  local guildInfo = ToClient_GetMyGuildInfoWrapper()
  if false == _panel:GetShow() then
    return
  end
  if nil == guildInfo then
    return
  end
  local guildAllianceChair = ToClient_GetMyGuildAlliancChairGuild()
  self._ui.txt_GuildName:SetText(guildInfo:getName())
  local guildFundString = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_GUILDMONEY")
  self._ui.txt_Fund:SetText(guildFundString .. " : " .. makeDotMoney(guildInfo:getGuildBusinessFunds_s64()))
  self._ui.txt_MasterName:SetText(guildInfo:getGuildMasterName())
  local guildRank = guildInfo:getMemberCountLevel()
  local guildRankString = ""
  if 1 == guildRank then
    guildRankString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_SMALL")
  elseif 2 == guildRank then
    guildRankString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_MIDDLE")
  elseif 3 == guildRank then
    guildRankString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_BIG")
  elseif 4 == guildRank then
    guildRankString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_BIGGEST")
  end
  self._ui.txt_GuildScale:SetText(guildRankString .. " (" .. guildInfo:getMemberCount() .. "/" .. guildInfo:getJoinableMemberCount() .. ")")
  self._ui.txt_ProtectValue:SetText(guildInfo:getProtectGuildMemberCount() .. "/" .. guildInfo:getAvaiableProtectGuildMemberCount())
  local skillPointInfo = ToClient_getSkillPointInfo(3)
  local skillPointPercent = string.format("%.0f", skillPointInfo._currentExp / skillPointInfo._nextLevelExp * 100)
  if 100 < tonumber(skillPointPercent) then
    skillPointPercent = 100
  end
  local pointValue = tostring(skillPointInfo._remainPoint) .. "/" .. tostring(skillPointInfo._acquirePoint - 1)
  local pointPercent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_SKILLPOINTPERCENT_SUBTITLE", "skillPointPercent", skillPointPercent)
  self._ui.txt_GuildPoint:SetText(pointValue .. " " .. pointPercent)
  self._ui.txt_GuildNotice:SetText(guildInfo:getGuildNotice())
  self._ui.txt_GuildIntroduce:SetText(guildInfo:getGuildIntrodution())
  local markData = getGuildMarkIndexByGuildNoForXBox(guildInfo:getGuildNo_s64())
  if nil ~= markData then
    self._ui.stc_GuildMarkBg:ChangeTextureInfoName("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
    local bgx1, bgy1, bgx2, bgy2 = PaGlobalFunc_GuildMark_GetBackGroundUV(markData:getBackGroundIdx())
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_GuildMarkBg, bgx1, bgy1, bgx2, bgy2)
    self._ui.stc_GuildMarkBg:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.stc_GuildMarkBg:setRenderTexture(self._ui.stc_GuildMarkBg:getBaseTexture())
    self._ui.stc_GuildMarkIcon:ChangeTextureInfoName("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
    local iconx1, icony1, iconx2, icony2 = PaGlobalFunc_GuildMark_GetIconUV(markData:getIconIdx())
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_GuildMarkIcon, iconx1, icony1, iconx2, icony2)
    self._ui.stc_GuildMarkIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.stc_GuildMarkIcon:setRenderTexture(self._ui.stc_GuildMarkIcon:getBaseTexture())
  end
  local territoryKey
  local territoryWarName = ""
  local SiegeWarName = ""
  local regionKey, myGuildCache
  local myGuildAllianceChair = ToClient_GetMyGuildAlliancChairGuild()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil ~= myGuildAllianceChair then
    myGuildCache = myGuildAllianceChair
  else
    myGuildCache = myGuildInfo
  end
  if nil == myGuildCache then
    return
  else
    local txt = ""
    if 0 < myGuildCache:getTerritoryCount() then
      for idx = 0, myGuildCache:getTerritoryCount() - 1 do
        territoryKey = myGuildCache:getTerritoryKeyAt(idx)
        if territoryKey >= 0 then
          local territoryInfoWrapper = getTerritoryInfoWrapperByIndex(territoryKey)
          if nil ~= territoryInfoWrapper then
            territoryWarName = territoryInfoWrapper:getTerritoryName()
            if "" == txt then
              txt = territoryInfoWrapper:getTerritoryName()
              self._ui.txt_WarinfoValue:SetSize(self._ui.txt_WarinfoValue:GetSizeX(), 20)
            else
              txt = txt .. "\n" .. territoryWarName
              self._ui.txt_WarinfoValue:SetSize(self._ui.txt_WarinfoValue:GetSizeX(), 50)
            end
            self._ui.txt_WarinfoValue:SetText(txt)
          end
        end
      end
    elseif 0 < myGuildCache:getSiegeCount() then
      for idx = 0, myGuildCache:getSiegeCount() - 1 do
        regionKey = myGuildCache:getSiegeKeyAt(idx)
        if regionKey > 0 then
          local regionInfoWrapper = getRegionInfoWrapper(regionKey)
          if nil ~= regionInfoWrapper then
            SiegeWarName = regionInfoWrapper:getAreaName()
            if "" == txt then
              txt = regionInfoWrapper:getAreaName()
              self._ui.txt_WarinfoValue:SetSize(self._ui.txt_WarinfoValue:GetSizeX(), 20)
            else
              txt = txt .. "\n" .. SiegeWarName
              self._ui.txt_WarinfoValue:SetSize(self._ui.txt_WarinfoValue:GetSizeX(), 50)
            end
            self._ui.txt_WarinfoValue:SetText(txt)
          end
        end
      end
    end
  end
end
function GuildMain:updateDeclareInfo()
  ToClient_RequestDeclareGuildWarToMyGuild()
  local listCount = ToClient_GetWarringGuildListCount()
  self._ui.list_DeclareGuild:getElementManager():clearKey()
  if 0 == listCount then
    self._ui.txt_NoDeclare:SetShow(true)
  else
    self._ui.txt_NoDeclare:SetShow(false)
    for listIdx = 0, listCount - 1 do
      self._ui.list_DeclareGuild:getElementManager():pushKey(toInt64(0, listIdx))
    end
  end
end
function GuildMain:updateDeclaredByInfo()
  ToClient_RequestDeclareGuildWarToMyGuild()
  local listCount = ToClient_GetCountDeclareGuildWarToMyGuild()
  self._ui.list_DeclaredByGuild:getElementManager():clearKey()
  if 0 == listCount then
    self._ui.txt_NoDeclaredBy:SetShow(true)
  else
    self._ui.txt_NoDeclaredBy:SetShow(false)
    for listIdx = 0, listCount - 1 do
      self._ui.list_DeclaredByGuild:getElementManager():pushKey(toInt64(0, listIdx))
    end
  end
end
function PaGlobalFunc_GuildMain_updateKeyGuide()
  local self = GuildMain
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideList, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function GuildMain:registEvent()
  self._btnCtrl[self._tabIdxData.guildInfo]:addInputEvent("Mouse_LUp", "PaGlobalFunc_GuildMain_OpenTab(" .. self._tabIdxData.guildInfo .. ")")
  self._btnCtrl[self._tabIdxData.guildMember]:addInputEvent("Mouse_LUp", "PaGlobalFunc_GuildMain_OpenTab(" .. self._tabIdxData.guildMember .. ")")
  self._btnCtrl[self._tabIdxData.guildQuest]:addInputEvent("Mouse_LUp", "PaGlobalFunc_GuildMain_OpenTab(" .. self._tabIdxData.guildQuest .. ")")
  self._btnCtrl[self._tabIdxData.guildSkill]:addInputEvent("Mouse_LUp", "PaGlobalFunc_GuildMain_OpenTab(" .. self._tabIdxData.guildSkill .. ")")
  self._ui.list_DeclareGuild:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_GuildMain_CreateDeclareGuild")
  self._ui.list_DeclareGuild:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.list_DeclaredByGuild:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_GuildMain_CreateDeclaredByGuild")
  self._ui.list_DeclaredByGuild:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  _panel:registerPadEvent(__eConsoleUIPadEvent_LB, "InputMLUp_GuildMain_MoveTabToLeft()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RB, "InputMLUp_GuildMain_MoveTabToRight()")
  registerEvent("FromClient_ResponseGuildUpdate", "FromClient_GuildMain_ResponseGuildUpdate")
  registerEvent("ResponseGuild_invite", "FromClient_GuildMain_ResponseGuildinvite")
  registerEvent("ResponseGuild_refuse", "FromClient_GuildMain_ResponseGuildRefuse")
  registerEvent("EventChangeGuildInfo", "FromClient_GuildMain_EventActorChangeGuildInfo")
  registerEvent("FromClient_GuildInviteForGuildGrade", "FromClient_GuildMain_ResponseGuildInviteForGuild")
  registerEvent("FromClient_NotifyGuildMessage", "FromClient_GuildMain_NotifyGuildMessage")
  registerEvent("FromClient_RequestGuildWar", "FromClient_GuildMain_RequestGuildWar")
  registerEvent("FromClient_ResponseDeclareGuildWarToMyGuild", "FromClient_GuildMain_ResponseDeclareWarToMyGuild")
  registerEvent("FromClient_UpdateGuildContract", "FromClient_GuildMain_ResponseUpdateGuildContract")
  registerEvent("FromClient_ResponseGuildNotice", "FromClient_GuildMain_ResponseGuildNotice")
  registerEvent("FromClient_ResponseChangeProtectGuildMember", "FromClient_GuildMain_ResponseProtectMember")
end
function GuildMain:close()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  _panel:SetShow(false)
end
function PaGlobalFunc_GuildMain_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_GuildMain_Init()
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  self:init()
end
function PaGlobalFunc_GuildMain_Open()
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  self._currentTabIdx = 0
  self:open()
end
function PaGlobalFunc_GuildMain_Close()
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  self:close()
end
function PaGlobalFunc_GuildMain_OpenTab(tabIdx)
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  self:openTab(tabIdx)
end
function PaGlobalFunc_GuildMain_GetKeyGuide(keyType)
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  local control = self._keyGuideList[keyType]
  if nil ~= control then
    return control
  end
end
function PaGlobalFunc_GuildMain_SetKeyGuide(keyType, isShow)
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  if nil ~= self._keyGuideList[keyType] then
    self._keyGuideList[keyType]:SetShow(isShow)
  end
  PaGlobalFunc_GuildMain_updateKeyGuide()
end
function InputMLUp_GuildMain_MoveTabToRight()
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  self._currentTabIdx = self._currentTabIdx + 1
  self._currentTabIdx = self._currentTabIdx % self._tabIdxData.dataCount
  self:openTab(self._currentTabIdx)
  _AudioPostEvent_SystemUiForXBOX(51, 6)
end
function InputMLUp_GuildMain_MoveTabToLeft()
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  self._currentTabIdx = self._currentTabIdx - 1
  self._currentTabIdx = self._currentTabIdx % self._tabIdxData.dataCount
  self:openTab(self._currentTabIdx)
end
function PaGlobalFunc_GuildMain_CreateDeclareGuild(content, key)
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  local guildIdx = Int64toInt32(key)
  local guildWrapper = ToClient_GetWarringGuildListAt(guildIdx)
  if nil == guildWrapper then
    _PA_ASSERT(false, "\236\160\132\236\159\129\235\176\155\236\157\128 \234\184\184\235\147\156 \236\160\149\235\179\180\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PaGlobalFunc_GuildMain_CreateDeclareGuild")
    return
  end
  local guildSlot = UI.getChildControl(content, "Button_GuildSlot")
  local guildName = UI.getChildControl(content, "StaticText_GuildName")
  local guildKillDeath = UI.getChildControl(content, "StaticText_KillDeath")
  if false == guildWrapper:isExist() then
    guildName:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DISSOLUTION"))
  else
    guildName:SetText(guildWrapper:getGuildName())
  end
  guildName:SetShow(true)
  local guildWarKillScore = tostring(Uint64toUint32(guildWrapper:getKillCount()))
  local guildWarDeathScore = tostring(Uint64toUint32(guildWrapper:getDeathCount()))
  guildKillDeath:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_GUILDWARSCORE", "killCount", guildWarKillScore, "deathCount", guildWarDeathScore))
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  if true == isGuildMaster or true == isGuildSubMaster then
    guildSlot:addInputEvent("Mouse_LUp", "InputMLUp_GuildMain_StopWar(" .. guildIdx .. ")")
  else
    guildSlot:addInputEvent("Mouse_LUp", "")
  end
end
function PaGlobalFunc_GuildMain_CreateDeclaredByGuild(content, key)
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  local guildIdx = Int64toInt32(key)
  local guildNo = ToClient_GetDeclareGuildWarToMyGuild_s64(guildIdx)
  local guildWrapper = ToClient_GetGuildInfoWrapperByGuildNo(guildNo)
  if nil == guildWrapper then
    _PA_ASSERT(false, "\236\160\132\236\159\129\235\176\155\236\157\128 \234\184\184\235\147\156 \236\160\149\235\179\180\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PaGlobalFunc_GuildMain_CreateDeclaredByGuild")
    return
  end
  local guildName = UI.getChildControl(content, "StaticText_GuildName")
  local guildMasterName = UI.getChildControl(content, "StaticText_MasterName")
  guildName:SetText(guildWrapper:getName())
  guildMasterName:SetText(guildWrapper:getGuildMasterName())
end
function FromClient_GuildMain_ResponseGuildInviteForGuild(targetActorKeyRaw, targetName, preGuildActivity)
  local guildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == guildInfo then
    _PA_ASSERT(false, "\234\184\184\235\147\156 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164!! : FromClient_GuildMain_ResponseGuildInviteForGuild")
    return
  end
  if nil == targetName then
    _PA_ASSERT(false, "targetName \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164!! : FromClient_GuildMain_ResponseGuildInviteForGuild")
    return
  end
  local guildGrade = guildInfo:getGuildGrade()
  if 0 == guildGrade then
    toClient_RequestInviteGuild(targetName, 0, 0, 0)
  else
    PaGlobalFunc_AgreementGuild_Open_ForJoin(targetActorKeyRaw, targetName, preGuildActivity)
  end
end
function FromClient_GuildMain_ResponseGuildUpdate(notifyType)
  if false == PaGlobalFunc_GuildMain_GetShow() then
    return
  end
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  local guildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == guildInfo then
    _PA_ASSERT(false, "\234\184\184\235\147\156 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164!! : FromClient_GuildMain_ResponseGuildUpdate")
    return
  end
  self:updateGuildInfo()
  self:updateDeclareInfo()
  self:updateDeclaredByInfo()
  if nil == notifyType or 10 ~= notifyType then
    FromClient_GuildMemberList_RequestClearAndUpdateMember()
    PaGlobalFunc_GuildSkill_UpdateData()
  end
end
function FromClient_GuildMain_ResponseGuildinvite(s64_guildNo, hostUsername, hostName, guildName, guildGrade, periodDay, benefit, penalty)
  if 0 == guildGrade then
    local luaGuildTextGuildInviteMsg = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLAN_INVITE_MSG")
    local luaGuildTextGuildInvite = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLAN_INVITE")
    local contentString = hostUsername .. "(" .. hostName .. ")" .. luaGuildTextGuildInviteMsg
    local messageboxData = {
      title = luaGuildTextGuildInvite,
      content = contentString,
      functionYes = PaGlobalFunc_GuildMain_AcceptClan,
      functionCancel = PaGlobalFunc_GuildMain_RefuseClan,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  elseif 1 == guildGrade then
    PaGlobal_AgreementGuild_InviteOpen(true, hostUsername, hostName, guildName, periodDay, benefit, penalty, s64_guildNo)
  end
end
function PaGlobalFunc_GuildMain_AcceptClan()
  ToClient_RequestAcceptGuildInvite()
end
function PaGlobalFunc_GuildMain_RefuseClan()
  ToClient_RequestRefuseGuildInvite()
end
function FromClient_GuildMain_ResponseGuildRefuse(questName, s64_joinableTime)
  if s64_joinableTime > toInt64(0, 0) then
    local lefttimeText = convertStringFromDatetime(getLeftSecond_TTime64(s64_joinableTime))
    local contentString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_MSGBOX_JOINWAITTIME_CONTENT", "questName", questName, "lefttimeText", lefttimeText)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_INVITE"),
      content = contentString,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
    if nil == myGuildInfo then
      _PA_ASSERT(false, "\234\184\184\235\147\156 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164!! : FromClient_GuildMain_ResponseGuildRefuse")
    end
    local textGuild = ""
    local guildGrade = myGuildInfo:getGuildGrade()
    if 0 == guildGrade then
      textGuild = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLAN")
    else
      textGuild = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD")
    end
    local contentString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_REFUSE_GUILDINVITE", "name", questName, "guild", textGuild)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_INVITE"),
      content = contentString,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function InputMLUp_GuildMain_StopWar(index)
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  if false == isGuildMaster and false == isGuildSubMaster then
    return
  end
  ToClient_RequestStopGuildWar(index)
end
function FromClient_GuildMain_NotifyGuildMessage(msgType, strParam1, strParam2, s64_param1, s64_param2, s64_param3)
  local param1 = Int64toInt32(s64_param1)
  local param2 = Int64toInt32(s64_param2)
  local param3 = Int64toInt32(s64_param3)
  if 0 == msgType then
    local message = ""
    if 0 == param1 then
      message = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_CLAN_OUT")
    else
      message = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_GUILD_OUT")
    end
    Proc_ShowMessage_Ack(message)
  elseif 1 == msgType then
    local message = ""
    if 0 == param1 then
      message = PAGetStringParam1(Defines.StringSheet_GAME, "GAME_MESSAGE_CLANMEMBER_OUT", "familyName", strParam1)
    else
      message = PAGetStringParam1(Defines.StringSheet_GAME, "GAME_MESSAGE_GUILDMEMBER_OUT", "familyName", strParam1)
    end
    Proc_ShowMessage_Ack(message)
  elseif 2 == msgType then
    local message = ""
    if 0 == param1 then
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_JOIN_GUILD", "name", strParam1)
    else
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_JOIN_GUILD", "name", strParam1)
    end
    Proc_ShowMessage_Ack(message)
  elseif 3 == msgType then
    local message = ""
    if 0 == param1 then
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_WHO_JOIN_CLAN", "name", strParam1)
    else
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_WHO_JOIN_GUILD", "name", strParam1)
    end
    Proc_ShowMessage_Ack(message)
  elseif 4 == msgType then
    local message = ""
    if 0 == param1 then
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_CLAN_MSG", "name", strParam1)
    else
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_GUILD_MSG", "name", strParam1)
    end
    Proc_ShowMessage_Ack(message)
  elseif 5 == msgType then
    local textGrade = ""
    if 0 == param1 then
      textGrade = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLAN")
    else
      textGrade = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD")
    end
    local message = ""
    if 0 == param2 then
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_EXPEL_SELF", "guild", strParam2)
    else
      message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_EXPEL_OTHER", "name", strParam1, "guild", strParam2)
    end
    Proc_ShowMessage_Ack(message)
  elseif 6 == msgType then
    local message = ""
    if param1 <= 30 and param2 > 30 then
      message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_COMPORATETAX_GUILDMEMBERCOUNT", "membercount", "30", "silver", PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERCOUNT_10"))
    elseif param1 <= 50 and param2 > 50 then
      message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_COMPORATETAX_GUILDMEMBERCOUNT", "membercount", "50", "silver", PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERCOUNT_25"))
    elseif param1 <= 75 and param2 > 75 then
      message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_COMPORATETAX_GUILDMEMBERCOUNT", "membercount", "75", "silver", PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERCOUNT_50"))
    else
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_INCREASE_GUILDMEMBERCOUNT", "membercount", param2)
    end
    Proc_ShowMessage_Ack(message)
  elseif 7 == msgType then
    local message = ""
    local characterName = strParam1
    local userNickName = strParam2
    if true == GameOption_ShowGuildLoginMessage() then
      if 0 == param1 then
        message = PAGetStringParam2(Defines.StringSheet_GAME, "GAME_MESSAGE_LOGIN_GUILD_MEMBER", "familyName", userNickName, "characterName", characterName)
      elseif 1 == param1 then
        message = PAGetStringParam2(Defines.StringSheet_GAME, "GAME_MESSAGE_LOGOUT_GUILD_MEMBER", "familyName", userNickName, "characterName", characterName)
      end
      Proc_ShowMessage_Ack(message)
    end
  elseif 8 == msgType then
    local message = ""
    local characterName = strParam1
    local userNickName = strParam2
  elseif 9 == msgType then
    local message = {}
    if param1 > 15 then
      message.main = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERLEVELUP_MAIN", "strParam1", strParam1, "param1", param1)
      message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBER_CHEER")
      message.addMsg = ""
      Proc_ShowMessage_Ack_For_RewardSelect(message, 3.2, 22)
    end
  elseif 10 == msgType then
    local message = {}
    if param1 <= 8 then
      local lifeLevel
      if _ContentsGroup_isUsedNewCharacterInfo == false then
        lifeLevel = FGlobal_CraftLevel_Replace(param2, param1)
      else
        lifeLevel = FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(param2)
      end
      message.main = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERLIFELEVELUP_MAIN", "strParam1", strParam1, "param1", lifeType[param1], "lifeLevel", lifeLevel)
      message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBER_CHEER")
      message.addMsg = ""
      Proc_ShowMessage_Ack_For_RewardSelect(message, 3.2, 22)
    end
  elseif 11 == msgType then
    local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(param1))
    if itemSSW == nil then
      return
    end
    local itemName = itemSSW:getName()
    local itemClassify = itemSSW:getItemClassify()
    local enchantLevel = itemSSW:get()._key:getEnchantLevel()
    local enchantLevelHigh = 0
    if nil ~= enchantLevel and 0 ~= enchantLevel then
      if enchantLevel >= 16 then
        enchantLevelHigh = HighEnchantLevel_ReplaceString(enchantLevel)
      elseif CppEnums.ItemClassifyType.eItemClassify_Accessory == itemClassify then
        enchantLevelHigh = HighEnchantLevel_ReplaceString(enchantLevel + 15)
      else
        enchantLevelHigh = "+ " .. enchantLevel
      end
    end
    local message = {}
    message.main = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERENCHANTSUCCESS_MAIN1", "strParam1", strParam1, "param1", enchantLevelHigh, "strParam2", itemName)
    message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBER_CHEER")
    message.addMsg = ""
    Proc_ShowMessage_Ack_For_RewardSelect(message, 3.2, 22)
  elseif 12 == msgType then
    local message = ""
    message = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDDUELWILLBEEND")
    Proc_ShowMessage_Ack(message)
  elseif 13 == msgType then
    local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(param1))
    if itemSSW == nil then
      return
    end
    local itemName = itemSSW:getName()
    local itemClassify = itemSSW:getItemClassify()
    local enchantLevel = itemSSW:get()._key:getEnchantLevel()
    local enchantLevelHigh = 0
    if nil ~= enchantLevel and 0 ~= enchantLevel then
      if enchantLevel >= 16 then
        enchantLevelHigh = HighEnchantLevel_ReplaceString(enchantLevel)
      elseif CppEnums.ItemClassifyType.eItemClassify_Accessory == itemClassify then
        enchantLevelHigh = HighEnchantLevel_ReplaceString(enchantLevel + 15)
      else
        enchantLevelHigh = "+ " .. enchantLevel
      end
    end
    local message = {}
    message.main = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERPROMOTION_CAPHRAS", "strParam1", strParam1, "param1", enchantLevelHigh, "strParam2", itemName)
    message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBER_CHEER")
    message.addMsg = ""
    Proc_ShowMessage_Ack_For_RewardSelect(message, 3.2, 22)
  end
end
function FromClient_GuildMain_RequestGuildWar(userNo, guildNo, guildName)
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  if MessageBox.isPopUp() and targetGuildNo == guildNo then
    return
  end
  if isGameTypeJapan() or isGameTypeKR2() then
    keyUseCheck = false
  end
  self._targetUserNo = userNo
  self._targetGuildNo = guildNo
  self._targetGuildName = guildName
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_DECLAREWAR", "guildName", targetGuildName)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = PaGlobalFunc_GuildMain_AcceptWar,
    functionNo = PaGlobalFunc_GuildMain_RefuseWar,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData, nil, nil, keyUseCheck)
end
function PaGlobalFunc_GuildMain_AcceptWar()
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  ToClient_RequestDeclareGuildWar(self._targetGuildNo, self._targetGuildName, true)
  self._targetUserNo = nil
  self._targetGuildNo = nil
  self._targetGuildName = nil
end
function PaGlobalFunc_GuildMain_RefuseWar()
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  ToClient_RequestRefuseGuildWar(self._targetUserNo, self._targetGuildName)
  self._targetUserNo = nil
  self._targetGuildNo = nil
  self._targetGuildName = nil
end
function FromClient_GuildMain_EventActorChangeGuildInfo()
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  self:updateGuildInfo()
end
function FromClient_GuildMain_ResponseUpdateGuildContract(notifyType, userNickName, characterName, strParam1, strParam2, s64_param1, s64_param2, s64_param3)
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  local param1 = Int64toInt32(s64_param1)
  local param2 = Int64toInt32(s64_param2)
  local param3 = Int64toInt32(s64_param3)
  if 0 == notifyType then
    local tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PENSION")
    local guildWrapper = ToClient_GetMyGuildInfoWrapper()
    if nil == guildWrapper then
      return
    end
    local guildGrade = guildWrapper:getGuildGrade()
    if 1 == guildGrade then
      Proc_ShowMessage_Ack(tempStr)
    end
  elseif 1 == notifyType then
    local tempStr = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_MONEY_DEPOSIT", "userNickName", userNickName, "money", tostring(param1))
    Proc_ShowMessage_Ack(tempStr)
  elseif 2 == notifyType then
    local isWarehouseGet = PaGlobalFunc_GuildReceivePay_PayTypeReturn()
    local tempStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_MONEY_COLLECTION_INVEN", "money", makeDotMoney(param1))
    if true == isWarehouseGet then
      tempStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_MONEY_COLLECTION_WAREHOUSE", "money", makeDotMoney(param1))
    else
      tempStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_MONEY_COLLECTION_INVEN", "money", makeDotMoney(param1))
    end
    if 1 == param2 then
      Proc_ShowMessage_Ack(tempStr)
    end
  elseif 3 == notifyType then
    local tempStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_HIRE_RENEWAL", "userNickName", userNickName)
    Proc_ShowMessage_Ack(tempStr)
  elseif 4 == notifyType then
    local tempStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_EXPIRATION", "userNickName", userNickName)
    Proc_ShowMessage_Ack(tempStr)
  elseif 5 == notifyType then
    local guildWrapper = ToClient_GetMyGuildInfoWrapper()
    if nil == guildWrapper then
      _PA_ASSERT(false, "\234\184\184\235\147\156\236\155\144\236\157\180 \234\179\160\236\154\169\234\179\132\236\149\189\236\132\156\235\165\188 \235\176\155\235\138\148\235\141\176 \234\184\184\235\147\156 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
      return
    end
    local guildName = guildWrapper:getName()
    local periodDay = getTemporaryInformationWrapper():getContractedPeriodDay()
    local benefit = getTemporaryInformationWrapper():getContractedBenefit()
    local penalty = getTemporaryInformationWrapper():getContractedPenalty()
    PaGlobal_AgreementGuild_InviteOpen(false, userNickName, characterName, guildName, periodDay, benefit, penalty, guildWrapper:getGuildNo_s64())
  elseif 6 == notifyType then
    local tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PAYMENTS", "typeMoney", tostring(param2))
    if 0 ~= param1 then
      tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UNPAID", "typeMoney", tostring(param2))
    end
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_INCOMETAX", "type", tempTxt))
  elseif 7 == notifyType then
    local tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_LEAVE", "userNickName", userNickName)
    if param1 > 0 then
      tempTxt = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PENALTIES", "tempTxt", tempTxt, "money", tostring(param1))
    end
    Proc_ShowMessage_Ack(tempTxt)
  elseif 8 == notifyType then
    local tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_FIRE", "userNickName", userNickName)
    if param1 > 0 then
      tempTxt = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_BONUS", "tempTxt", tempTxt, "money", tostring(param1))
    end
    Proc_ShowMessage_Ack(tempTxt)
  elseif 9 == notifyType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UPGRADES"))
  elseif 10 == notifyType then
  elseif 11 == notifyType then
    local text = ""
    if 1 == param3 then
      text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_BESTMONEY", "money", makeDotMoney(s64_param1))
    else
      text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_NOTBESTMONEY", "money", makeDotMoney(s64_param1))
    end
    Proc_ShowMessage_Ack(text)
  elseif 12 == notifyType then
    local text
    if 1 == param1 then
      text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_BIDCANCEL")
    else
      text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_BIDSUCCESS")
    end
    Proc_ShowMessage_Ack(text)
  elseif 13 == notifyType then
    if toInt64(0, 0) == s64_param1 then
      Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_USEGUILDSHOP_BUY", "userNickName", tostring(userNickName), "param2", makeDotMoney(s64_param2)))
    end
    if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= PaGlobalFunc_NPCShop_ALL_GetShow then
      if true == PaGlobalFunc_NPCShop_ALL_GetShow() and npcShop_isGuildShopContents() then
        PaGlobalFunc_NPCShop_ALL_UpdateMoney()
        return
      end
    elseif true == _ContentsGroup_RenewUI_NpcShop then
      if PaGlobalFunc_Dialog_NPCShop_IsShow() and npcShop_isGuildShopContents() then
        FromClient_Dialog_NPCShop_UpdateMoneyWarehouse()
        return
      end
    elseif Panel_Window_NpcShop:IsShow() and npcShop_isGuildShopContents() then
      NpcShop_UpdateMoneyWarehouse()
      return
    end
  elseif 14 == notifyType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_INCENTIVE"))
  elseif 15 == notifyType then
    local tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PAYMENTS", "typeMoney", tostring(param2))
    if 0 ~= param1 then
      tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UNPAID", "typeMoney", tostring(param2))
    end
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_HOUSECOSTS", "tempTxt", tempTxt))
  elseif 16 == notifyType then
    local text = ""
    if 0 == param1 then
      text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_CREATE_CLAN", "name", userNickName)
    else
      text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_CREATE_GUILD", "name", userNickName)
    end
    Proc_ShowMessage_Ack(text)
  elseif 17 == notifyType then
    if false == ToClient_GetMessageFilter(9) then
      local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ACCEPT_GUILDQUEST")
      Proc_ShowMessage_Ack(text)
    end
  elseif 18 == notifyType then
    if false == ToClient_GetMessageFilter(9) then
      local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_COMPLETE_GUILDQUEST")
      Proc_ShowMessage_Ack(text)
    end
  elseif 19 == notifyType then
    local regionInfoWrapper = getRegionInfoWrapper(param2)
    if nil == regionInfoWrapper then
      _PA_ASSERT(false, "\236\132\177\236\163\188\234\176\128 \235\167\136\236\157\132\236\132\184\234\184\136\236\157\132 \236\136\152\234\184\136\237\150\136\235\138\148\235\141\176 \235\167\136\236\157\132 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
      return
    end
    local text = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_LORD_MOVETAX_TO_GUILDMONEY", "region", regionInfoWrapper:getAreaName(), "silver", makeDotMoney(s64_param1))
    Proc_ShowMessage_Ack(text)
  elseif 20 == notifyType then
  elseif 21 == notifyType then
    if CppEnums.GuildWarType.GuildWarType_Normal == ToClient_GetGuildWarType() then
      if param3 == 1 then
        local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ACCEPT_BATTLE_NO_RESOURCE")
        Proc_ShowMessage_Ack(text)
      else
        local tendency = param1
        local text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_DECLARE_WAR_CONSUME", "silver", makeDotMoney(s64_param2))
        Proc_ShowMessage_Ack(text)
      end
    end
  elseif 22 == notifyType then
  elseif 23 == notifyType then
  elseif 24 == notifyType then
  elseif 25 == notifyType then
  elseif 26 == notifyType then
  elseif 27 == notifyType then
  elseif 28 == notifyType then
    if 0 == param1 then
      local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMP_DOWN")
      Proc_ShowMessage_Ack(userNickName .. text)
    else
      local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMP_UP")
      Proc_ShowMessage_Ack(userNickName .. text)
    end
    if nil ~= Panel_GuildWarInfo and Panel_GuildWarInfo:GetShow() then
      FromClient_WarInfoContent_Set()
    end
  elseif 29 == notifyType then
    if 0 == param1 then
      local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_CHEER_GUILD")
      Proc_ShowMessage_Ack(userNickName .. text)
      FromClient_NotifySiegeScoreToLog()
    else
      FromClient_NotifySiegeScoreToLog()
    end
  elseif 30 == notifyType then
    local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DONOT_GUILDQUEST")
    Proc_ShowMessage_Ack(text)
  elseif 31 == notifyType then
  elseif 32 == notifyType then
    local regionInfoWrapper = getRegionInfoWrapper(param3)
    local areaName = ""
    if nil ~= regionInfoWrapper then
      areaName = regionInfoWrapper:getAreaName()
    end
    local characterStaticStatusWarpper = getCharacterStaticStatusWarpper(param2)
    local characterName = ""
    if nil ~= characterStaticStatusWarpper then
      characterName = characterStaticStatusWarpper:getName()
    end
    local msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BUILDING_AUTODESTROYBUILD", "areaName", areaName, "characterName", characterName)
    Proc_ShowMessage_Ack(msg)
  elseif 38 == notifyType then
    local tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDE_PAYPROPERTYTAX", "typeMoney", makeDotMoney(s64_param1))
    Proc_ShowMessage_Ack(tempTxt)
  elseif 39 == notifyType then
    local tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_GETWELFARE", "typeMoney", makeDotMoney(s64_param1))
    Proc_ShowMessage_Ack(tempTxt)
  elseif 43 == notifyType then
    local tempTxt = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_NOTIFYWELFARE")
    Proc_ShowMessage_Ack(tempTxt)
  end
  FromClient_GuildMain_ResponseGuildUpdate(notifyType)
end
function FromClient_GuildMain_ResponseGuildNotice()
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == guildWrapper then
    return
  end
  local guildNotice = guildWrapper:getGuildNotice()
  self._ui.txt_GuildNotice:SetText(guildNotice)
end
function FromClient_GuildMain_ResponseProtectMember(targetNo, isProtectable)
  local userNum = Int64toInt32(getSelfPlayer():get():getUserNo())
  if userNum == Int64toInt32(targetNo) then
    if true == isProtectable then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PROTECT_GUILDMEMBER_MESSAGE_0"))
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PROTECT_GUILDMEMBER_MESSAGE_1"))
    end
  end
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  if self._tabIdxData.guildMember == self._currentTabIdx then
    FromClient_GuildMemberList_GuildListUpdate(userNum)
  end
end
function FromClient_GuildMain_ResponseDeclareWarToMyGuild()
  local self = GuildMain
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMain")
    return
  end
  self:updateDeclaredByInfo()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_GuildMain_Init")
