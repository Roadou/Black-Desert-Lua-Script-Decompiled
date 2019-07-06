local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local _panel = Instance_Mission
local MissionSystem = {
  _ui = {
    _stc_mission_templete = UI.getChildControl(_panel, "Static_Mission_Templete"),
    _stc_messageBg = UI.getChildControl(_panel, "Static_MessageBG"),
    _stc_misson = {},
    _txt_mission_title = {},
    _txt_mission_desc = {},
    _txt_mission_icon = {}
  },
  _successTextureUV = {
    _missionBG = {
      x1 = 1,
      y1 = 81,
      x2 = 331,
      y2 = 160
    },
    _icon = {
      x1 = 467,
      y1 = 161,
      x2 = 511,
      y2 = 205
    }
  },
  _progressMissionInfo = {},
  _templetePosOffsetY = 0,
  _templetePosGapY = 90,
  _missionCount = 0,
  _timer = 0,
  _lastUpdateTime = 0,
  _strMissionSuccess1 = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MISSION_COMPLETE1"),
  _strMissionSuccess2 = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MISSION_COMPLETE2"),
  _strMissionAccept = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MISSION_MESSAGE_TITLE"),
  _isBlackSpirit = true
}
function MissionSystem:initialize()
  self._templetePosOffsetY = self._ui._stc_mission_templete:GetPosY()
  self._ui._txt_message_title = UI.getChildControl(self._ui._stc_messageBg, "StaticText_Message_Title")
  self._ui._txt_message_reward = UI.getChildControl(self._ui._stc_messageBg, "StaticText_Reward")
  if 1 <= ToClient_GetProgressMissionInfoCount() then
    self:refreshMission()
    self:updateMissionCondition()
  end
  local curClassType = getSelfPlayer():getClassType()
  if nil ~= curClassType and __eClassType_BlackSpirit == curClassType then
    self._isBlackSpirit = true
  else
    self._isBlackSpirit = false
  end
  self:registEventHandler()
  if true == ToClient_IsContentsGroupOpen("1340") then
    _panel:SetShow(true)
  end
end
function MissionSystem:showAni(control)
  local closeAni = control:addColorAnimation(0, 1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(UI_color.C_00FFFFFF)
  closeAni:SetEndColor(UI_color.C_FFFFFFFF)
  closeAni:SetStartIntensity(1)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
end
function MissionSystem:closeAni(control)
  local closeAni = control:addColorAnimation(3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(UI_color.C_FFFFFFFF)
  closeAni:SetEndColor(UI_color.C_00FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
end
function MissionSystem:registEventHandler()
  registerEvent("FromClient_AcceptMission", "FromClient_RefreshMission")
  registerEvent("FromClient_CompleteMission", "FromClient_CompleteMission")
  registerEvent("FromClient_UpdateMission", "FromClient_UpdateMission")
  registerEvent("FromClient_DeleteMission", "FromClient_RefreshMission")
  registerEvent("onScreenResize", "PaGlobal_MissionSystem_OnScreen")
  Instance_Mission:RegisterUpdateFunc("PaGlobal_MissionSystem_ShowMissionNotifyMessage")
end
function MissionSystem:refreshMission()
  self._missionCount = ToClient_GetProgressMissionInfoCount()
  for _, control in pairs(self._ui._stc_misson) do
    control:SetShow(false)
  end
  for i = 0, self._missionCount - 1 do
    if nil == self._ui._stc_misson[i] then
      self._ui._stc_misson[i] = UI.cloneControl(self._ui._stc_mission_templete, _panel, "Static_Mission_" .. i)
      self._ui._stc_misson[i]:SetPosY(self._templetePosOffsetY + i * self._templetePosGapY)
      self._ui._txt_mission_title[i] = UI.getChildControl(self._ui._stc_misson[i], "StaticText_Mission_Title")
      self._ui._txt_mission_desc[i] = {}
      self._ui._txt_mission_desc[i][0] = UI.getChildControl(self._ui._stc_misson[i], "StaticText_Mission_Description1")
      self._ui._txt_mission_desc[i][1] = UI.getChildControl(self._ui._stc_misson[i], "StaticText_Mission_Description2")
      self._ui._txt_mission_icon[i] = UI.getChildControl(self._ui._stc_misson[i], "StaticText_Icon")
    end
    self._ui._txt_mission_icon[i]:addInputEvent("Mouse_On", "PaGlobalFunc_Mission_ShowTooltip(" .. i .. ")")
    self._ui._txt_mission_icon[i]:addInputEvent("Mouse_Out", "PaGlobalFunc_Mission_ShowTooltip()")
    local progressMissionInfo = ToClient_GetProgressMissionInfoByIndex(i)
    if nil ~= progressMissionInfo then
      local missionInfo = {}
      missionInfo._title = progressMissionInfo:getMissionTitle()
      missionInfo._rewardDesc = progressMissionInfo:getMissionDescription()
      missionInfo._showType = progressMissionInfo:getMissionShowType()
      missionInfo._alreadyShow = false
      missionInfo._bonusMoneyRate = math.ceil(ToClient_GetProgressMissionBonusMoneyRate(i) / 100000) / 10
      missionInfo._itemKey = ToClient_GetProgressMissionItemKeyByIndex(i, 0)
      missionInfo._itemCount = ToClient_GetProgressMissionItemCountByIndex(i, 0)
      self._progressMissionInfo[i] = missionInfo
      self._ui._txt_mission_title[i]:SetText(missionInfo._title)
      if 1 < missionInfo._itemCount then
        self._ui._txt_mission_icon[i]:SetText("x" .. tostring(missionInfo._itemCount))
      end
      local conditionCount = progressMissionInfo:getCompleteConditionCount()
      if 1 == conditionCount then
        self._ui._txt_mission_desc[i][1]:SetShow(false)
      elseif conditionCount > 1 then
        self._ui._txt_mission_desc[i][1]:SetShow(true)
      end
      self._ui._stc_misson[i]:SetShow(true)
    end
  end
end
function MissionSystem:updateMissionCondition()
  for i = 0, self._missionCount - 1 do
    local missionInfo = ToClient_GetProgressMissionInfoByIndex(i)
    if nil ~= missionInfo then
      for ii = 0, missionInfo:getCompleteConditionCount() - 1 do
        local textDesc = self._ui._txt_mission_desc[i][ii]
        local missionBG = self._ui._stc_misson[i]
        textDesc:SetShow(false)
        local descText = ""
        descText = "- " .. descText .. missionInfo:getConditionText(ii)
        local maxConditionCount = missionInfo:getMaxConditionCount(ii)
        local conditionCount = missionInfo:getConditionCount(ii)
        if maxConditionCount > 1 then
          descText = descText .. " (" .. tostring(conditionCount) .. "/" .. tostring(maxConditionCount) .. ")"
        end
        textDesc:SetText(descText)
        if maxConditionCount == conditionCount then
          textDesc:SetFontColor(Defines.Color.C_FF888888)
        end
        textDesc:SetShow(true)
        if missionBG:GetSizeX() - 77 < textDesc:GetTextSizeX() + textDesc:GetPosX() then
          local gapX = textDesc:GetTextSizeX() + textDesc:GetPosX() - (missionBG:GetSizeX() - 77) + 5
          missionBG:SetSize(missionBG:GetSizeX() + gapX, missionBG:GetSizeY())
          self._ui._txt_mission_icon[i]:ComputePos()
        end
      end
    end
  end
end
function PaGlobal_MissionSystem_ShowMissionNotifyMessage(deltatime)
  MissionSystem:showMissionNotifyMessage(deltatime)
end
function MissionSystem:showMissionNotifyMessage(deltatime)
  if self._missionCount < 1 then
    return
  end
  local isNakShow = false
  local showNakMissionIndex = -1
  for ii = 0, self._missionCount - 1 do
    local showType = self._progressMissionInfo[ii]._showType
    if false == self._progressMissionInfo[ii]._alreadyShow then
      local isShow = self:checkShowType(showType)
      if true == isShow then
        self._progressMissionInfo[ii]._alreadyShow = true
        isNakShow = true
        if __eShowType_Before == showType and false == self._isBlackSpirit then
          isNakShow = false
        end
        showNakMissionIndex = ii
      end
    end
    if true == self._progressMissionInfo[ii]._alreadyShow then
      self._ui._stc_misson[ii]:SetShow(true)
    else
      self._ui._stc_misson[ii]:SetShow(false)
    end
  end
  if true == isNakShow and -1 ~= showNakMissionIndex then
    self._ui._stc_messageBg:SetShow(true)
    self._ui._txt_message_title:SetText(self._strMissionAccept .. self._progressMissionInfo[showNakMissionIndex]._title)
    self._ui._txt_message_reward:SetText(self._progressMissionInfo[showNakMissionIndex]._rewardDesc)
    self:showAni(self._ui._stc_messageBg)
    self:closeAni(self._ui._stc_messageBg)
  end
end
function MissionSystem:checkShowType(showType)
  local isShow = false
  local brStartTime = ToClient_BattleRoyaleStartTime()
  local serverUtcTime = getServerUtc64()
  if Int64toInt32(brStartTime) < 1 then
    return false
  end
  local elapsedTime = 0
  if nil ~= brStartTime and nil ~= serverUtcTime then
    elapsedTime = Int64toInt32(serverUtcTime - brStartTime)
  end
  if elapsedTime < 23 then
    return
  end
  local elapsedMinutes = math.floor(elapsedTime / 60)
  if __eShowType_Before == showType then
    return true
  elseif __eShowType_Start == showType and false == self._isBlackSpirit then
    isShow = true
  elseif __eShowType_Time0 == showType and elapsedMinutes >= 5 then
    isShow = true
  elseif __eShowType_Time1 == showType and elapsedMinutes >= 10 then
    isShow = true
  elseif __eShowType_Time2 == showType and elapsedMinutes >= 15 then
    isShow = true
  elseif __eShowType_Time3 == showType and elapsedMinutes >= 20 then
    isShow = true
  end
  return isShow
end
function PaGlobalFunc_Mission_ShowTooltip(index)
  if nil == index then
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  local self = MissionSystem
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._progressMissionInfo[index]._itemKey))
  Panel_Tooltip_Item_Show(itemSSW, self._ui._txt_mission_icon[index], true, false)
end
function FromClient_RefreshMission()
  if false == _panel:GetShow() then
    return
  end
  local self = MissionSystem
  self:refreshMission()
  self:updateMissionCondition()
end
function FromClient_CompleteMission()
  if false == _panel:GetShow() then
    return
  end
  local self = MissionSystem
  local successTitle = ToClient_GetClearedMissionTitle()
  for i = 0, self._missionCount - 1 do
    if successTitle == self._ui._txt_mission_title[i]:GetText() then
      self._ui._txt_mission_desc[i][0]:SetFontColor(Defines.Color.C_FFF26A6A)
      self._ui._txt_mission_desc[i][0]:SetText(self._strMissionSuccess1)
      self._ui._txt_mission_desc[i][1]:SetShow(true)
      self._ui._txt_mission_desc[i][1]:SetFontColor(Defines.Color.C_FFF26A6A)
      self._ui._txt_mission_desc[i][1]:SetText(self._strMissionSuccess2)
      self._ui._txt_mission_icon[i]:addInputEvent("Mouse_On", "")
      self._ui._txt_mission_icon[i]:addInputEvent("Mouse_Out", "")
      self:closeAni(self._ui._stc_misson[i])
    end
  end
end
function FromClient_UpdateMission()
  local self = MissionSystem
  self:updateMissionCondition()
end
function PaGlobal_MissionSystem_OnScreen()
  local self = MissionSystem
  local screenX = getScreenSizeX()
  local panelPosY = _panel:GetPosY()
  local posY = 50 - panelPosY
  self._ui._stc_messageBg:SetPosX((screenX - self._ui._stc_messageBg:GetSizeX()) * 0.5)
  self._ui._stc_messageBg:SetPosY(posY)
end
function PaGlobal_MissionSystem_Initialize()
  local self = MissionSystem
  self:initialize()
end
function PaGlobal_MissionSystem_CatchClassChange()
  local classType = getSelfPlayer():getClassType()
  if getSelfPlayer():getClassType() ~= __eClassType_BlackSpirit then
    MissionSystem._isBlackSpirit = false
  else
    MissionSystem._isBlackSpirit = true
  end
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_MissionSystem_Initialize")
registerEvent("FromClient_ClassChangeBattleRoyale", "PaGlobal_MissionSystem_CatchClassChange")
