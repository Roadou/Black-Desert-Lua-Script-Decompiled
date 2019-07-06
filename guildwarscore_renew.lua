local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_Window_GuildWarScore:SetShow(false)
PAGlobal_GuildWarScore = {
  _scoreList = {},
  _constGuildListMaxCount = 11,
  _selectedGuildNo = 0,
  _ui = {
    _buildingTitle = UI.getChildControl(Panel_Window_GuildWarScore, "Static_M_Destroyed"),
    _killTitle = UI.getChildControl(Panel_Window_GuildWarScore, "Static_M_Kill"),
    _deathTitle = UI.getChildControl(Panel_Window_GuildWarScore, "Static_M_Dead"),
    _vehicleTitle = UI.getChildControl(Panel_Window_GuildWarScore, "Static_M_StableDead")
  }
}
function PAGlobal_GuildWarScore:init()
  local copyCharName = UI.getChildControl(Panel_Window_GuildWarScore, "StaticText_CharacterName")
  local copyBuilding = UI.getChildControl(Panel_Window_GuildWarScore, "StaticText_V_Destroyed")
  local copyKill = UI.getChildControl(Panel_Window_GuildWarScore, "StaticText_V_Kill")
  local copyDead = UI.getChildControl(Panel_Window_GuildWarScore, "StaticText_V_Dead")
  local copyVehicle = UI.getChildControl(Panel_Window_GuildWarScore, "StaticText_V_StableDead")
  local ui_btn_Close = UI.getChildControl(Panel_Window_GuildWarScore, "Button_Win_Close")
  ui_btn_Close:addInputEvent("Mouse_LUp", "FGlobal_GuildWarScore_renew_Close()")
  local constStartY = UI.getChildControl(Panel_Window_GuildWarScore, "StaticText_M_CharName"):GetPosY() + 25
  local function createWarfareInfo(pIndex)
    local rtGuildWarfareInfo = {}
    rtGuildWarfareInfo._txtCharName = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Window_GuildWarScore, "StaticText_CharacterName" .. pIndex)
    rtGuildWarfareInfo._txtBuilding = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Window_GuildWarScore, "StaticText_V_Destroyed" .. pIndex)
    rtGuildWarfareInfo._txtKill = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Window_GuildWarScore, "StaticText_V_Kill" .. pIndex)
    rtGuildWarfareInfo._txtDead = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Window_GuildWarScore, "StaticText_V_Dead" .. pIndex)
    rtGuildWarfareInfo._txtVehicle = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Window_GuildWarScore, "StaticText_V_StableDead" .. pIndex)
    CopyBaseProperty(copyCharName, rtGuildWarfareInfo._txtCharName)
    CopyBaseProperty(copyBuilding, rtGuildWarfareInfo._txtBuilding)
    CopyBaseProperty(copyKill, rtGuildWarfareInfo._txtKill)
    CopyBaseProperty(copyDead, rtGuildWarfareInfo._txtDead)
    CopyBaseProperty(copyVehicle, rtGuildWarfareInfo._txtVehicle)
    rtGuildWarfareInfo._txtCharName:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtBuilding:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtKill:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtDead:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtVehicle:SetPosY(constStartY + pIndex * 25)
    function rtGuildWarfareInfo:SetShow(isShow)
      rtGuildWarfareInfo._txtCharName:SetShow(isShow)
      rtGuildWarfareInfo._txtBuilding:SetShow(isShow)
      rtGuildWarfareInfo._txtKill:SetShow(isShow)
      rtGuildWarfareInfo._txtDead:SetShow(isShow)
      rtGuildWarfareInfo._txtVehicle:SetShow(isShow)
    end
    function rtGuildWarfareInfo:SetData(pData)
      if nil == pData then
        return
      end
      if pData:isOnline() then
        rtGuildWarfareInfo._txtCharName:SetText(pData:getName() .. " (" .. pData:getCharacterName() .. ")")
        rtGuildWarfareInfo._txtCharName:SetFontColor(UI_color.C_FFEFEFEF)
      else
        rtGuildWarfareInfo._txtCharName:SetText(pData:getName() .. " ( - )")
        rtGuildWarfareInfo._txtCharName:SetFontColor(UI_color.C_FFC4BEBE)
      end
      rtGuildWarfareInfo._txtBuilding:SetText(pData:commandPostCount() + pData:towerCount() + pData:gateCount())
      rtGuildWarfareInfo._txtKill:SetText(pData:guildMasterCount() + pData:squadLeaderCount() + pData:squadMemberCount())
      rtGuildWarfareInfo._txtDead:SetText(pData:deathCount())
      rtGuildWarfareInfo._txtVehicle:SetText(pData:summonedCount())
    end
    return rtGuildWarfareInfo
  end
  for index = 0, self._constGuildListMaxCount - 1 do
    self._scoreList[index] = createWarfareInfo(index)
    self._scoreList[index]:SetShow(false)
  end
  UI.deleteControl(copyCharName)
  UI.deleteControl(copyBuilding)
  UI.deleteControl(copyKill)
  UI.deleteControl(copyDead)
  UI.deleteControl(copyVehicle)
  copyCharName, copyBuilding, copyKill, copyDead, copyVehicle = nil, nil, nil, nil, nil
  self._ui._buildingTitle:addInputEvent("Mouse_On", "GuildWarScore_Tooltip_Show(" .. 0 .. ")")
  self._ui._buildingTitle:addInputEvent("Mouse_Out", "GuildWarScore_Tooltip_Hide()")
  self._ui._killTitle:addInputEvent("Mouse_On", "GuildWarScore_Tooltip_Show(" .. 1 .. ")")
  self._ui._killTitle:addInputEvent("Mouse_Out", "GuildWarScore_Tooltip_Hide()")
  self._ui._deathTitle:addInputEvent("Mouse_On", "GuildWarScore_Tooltip_Show(" .. 2 .. ")")
  self._ui._deathTitle:addInputEvent("Mouse_Out", "GuildWarScore_Tooltip_Hide()")
  self._ui._vehicleTitle:addInputEvent("Mouse_On", "GuildWarScore_Tooltip_Show(" .. 3 .. ")")
  self._ui._vehicleTitle:addInputEvent("Mouse_Out", "GuildWarScore_Tooltip_Hide()")
end
function GuildWarScore_Tooltip_Show(controlType)
  local self = PAGlobal_GuildWarScore
  local control, name
  if 0 == controlType then
    control = self._ui._buildingTitle
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_OBJECTKILLCOUNTTITLE")
  elseif 1 == controlType then
    control = self._ui._killTitle
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_PLAYERKILLCOUNTTITLE")
  elseif 2 == controlType then
    control = self._ui._deathTitle
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_DEATHCOUNTTITLE")
  elseif 3 == controlType then
    control = self._ui._vehicleTitle
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_SERVANTKILLCOUNTTITLE")
  else
    return
  end
  TooltipSimple_Show(control, name)
end
function GuildWarScore_Tooltip_Hide()
  TooltipSimple_Hide()
end
function PAGlobal_GuildWarScore:UpdateData(guildNo)
  for index = 0, self._constGuildListMaxCount - 1 do
    self._scoreList[index]:SetShow(false)
  end
  self._selectedGuildNo = guildNo
  local guildAlliance = ToClient_GetGuildAllianceWrapperbyNo(guildNo)
  local memberCount = 0
  if nil ~= guildAlliance then
    for index = 0, guildAlliance:getMemberCount() - 1 do
      local guildWrapper = guildAlliance:getMemberGuild(index)
      if nil == guildWrapper then
        return
      end
      self:SetWarScoreList(guildWrapper, memberCount)
      memberCount = memberCount + guildWrapper:getTopMemberCount()
    end
  else
    local guildWrapper = ToClient_GetGuildInfoWrapperByGuildNo(guildNo)
    if nil == guildWrapper then
      return
    end
    self:SetWarScoreList(guildWrapper, memberCount)
    memberCount = guildWrapper:getMemberCount()
  end
end
function PAGlobal_GuildWarScore:SetWarScoreList(guildWrapper, uiIndex)
  local memberCount = guildWrapper:getTopMemberCount()
  for index = 0, self._constGuildListMaxCount - 1 do
    if uiIndex >= self._constGuildListMaxCount then
      return
    end
    if index < memberCount then
      local userNo = guildWrapper:getTopMemberUserNobyIndex(index)
      self._scoreList[uiIndex]:SetData(guildWrapper:getMemberByUserNo(userNo))
      self._scoreList[uiIndex]:SetShow(true)
    else
      self._scoreList[uiIndex]:SetShow(false)
    end
    uiIndex = uiIndex + 1
  end
end
function FGlobal_GuildWarScore_renew_Open(guildNo)
  if false == Panel_Window_GuildWarScore:GetShow() then
    PAGlobal_GuildWarScore:UpdateData(guildNo)
    Panel_Window_GuildWarScore:SetShow(true)
  else
    PAGlobal_GuildWarScore:UpdateData(guildNo)
  end
end
function FGlobal_GuildWarScore_renew_Update()
  if true == Panel_Window_GuildWarScore:GetShow() and 0 ~= PAGlobal_GuildWarScore._selectedGuildNo then
    PAGlobal_GuildWarScore:UpdateData(PAGlobal_GuildWarScore._selectedGuildNo)
  end
end
function FGlobal_GuildWarScore_renew_Close()
  PAGlobal_GuildWarScore._selectedGuildNo = 0
  Panel_Window_GuildWarScore:SetShow(false)
  TooltipSimple_Hide()
end
PAGlobal_GuildWarScore:init()
