function PaGlobal_LobbyInstanceRating:initialize()
  if nil == LobbyInstance_Widget_Rating then
    return
  end
  if true == PaGlobal_LobbyInstanceRating.initialize then
    return
  end
  PaGlobal_LobbyInstanceRating._ui.stc_tierIconGroup = UI.getChildControl(PaGlobal_LobbyInstanceRating._ui._topArea, "Static_Tier_Icon_Group")
  PaGlobal_LobbyInstanceRating._ui.stc_tierIcon = UI.getChildControl(PaGlobal_LobbyInstanceRating._ui.stc_tierIconGroup, "Static_Tier_Icon")
  PaGlobal_LobbyInstanceRating._ui.rdo_solo = UI.getChildControl(PaGlobal_LobbyInstanceRating._ui._topArea, "RadioButton_Solo")
  PaGlobal_LobbyInstanceRating._ui.rdo_team = UI.getChildControl(PaGlobal_LobbyInstanceRating._ui._topArea, "RadioButton_Party")
  PaGlobal_LobbyInstanceRating._ui.stc_scoreCurrentValue = UI.getChildControl(PaGlobal_LobbyInstanceRating._ui._topArea, "StaticText_ScoreCurrentValue")
  PaGlobal_LobbyInstanceRating._ui.stc_scoreNextValue = UI.getChildControl(PaGlobal_LobbyInstanceRating._ui._topArea, "StaticText_ScoreNextValue")
  PaGlobal_LobbyInstanceRating._ui.progress_score = UI.getChildControl(PaGlobal_LobbyInstanceRating._ui._topArea, "Progress2_Score")
  PaGlobal_LobbyInstanceRating:registEventHandler()
  PaGlobal_LobbyInstanceRating.initialize = true
  PaGlobal_LobbyInstanceRating:statusUpdate()
  PaGlobal_LobbyInstanceRating:open()
end
function PaGlobal_LobbyInstanceRating:open()
  if nil == LobbyInstance_Widget_Rating then
    return
  end
  LobbyInstance_Widget_Rating:SetShow(true)
end
function PaGlobal_LobbyInstanceRating:close()
  if nil == LobbyInstance_Widget_Rating then
    return
  end
  LobbyInstance_Widget_Rating:SetShow(false)
end
function PaGlobal_LobbyInstanceRating:registEventHandler()
  if nil == LobbyInstance_Widget_Rating then
    return
  end
  registerEvent("FromClient_BattleRoyaleUserRecords", "PaGlobal_LobbyInstanceRating_RefreshInfo")
  registerEvent("FromClient_BattleRoyaleUserTiers", "PaGlobal_LobbyInstanceRating_RefreshInfo")
  PaGlobal_LobbyInstanceRating._ui._topArea:addInputEvent("Mouse_LUp", "PaGlobalFunc_lobbyMyInfo_Open()")
  PaGlobal_LobbyInstanceRating._ui.rdo_solo:addInputEvent("Mouse_LUp", "HandleEventLUp_LobbyInstanceRating_TogleStatus(" .. __eBattleRoyaleMode_Solo .. ")")
  PaGlobal_LobbyInstanceRating._ui.rdo_team:addInputEvent("Mouse_LUp", "HandleEventLUp_LobbyInstanceRating_TogleStatus(" .. __eBattleRoyaleMode_Team .. ")")
end
function PaGlobal_LobbyInstanceRating:statusUpdate()
  if nil == LobbyInstance_Widget_Rating then
    return
  end
  if PaGlobal_LobbyInstanceRating.nowToggleKey == __eBattleRoyaleMode_Solo then
    PaGlobal_LobbyInstanceRating._ui.rdo_solo:SetCheck(true)
    PaGlobal_LobbyInstanceRating._ui.rdo_team:SetCheck(false)
  else
    PaGlobal_LobbyInstanceRating._ui.rdo_team:SetCheck(true)
    PaGlobal_LobbyInstanceRating._ui.rdo_solo:SetCheck(false)
  end
  local nowScore = ToClient_GetBattleRoyaleCurrentSeasonScore(PaGlobal_LobbyInstanceRating.nowToggleKey)
  if nil == nowScore then
    return
  end
  nowScore = Int64toInt32(nowScore)
  local tierWrapper = ToClient_GetBattleRoyaleTierByScore(nowScore)
  if nil == tierWrapper then
    return
  end
  local tier = tierWrapper:getTier()
  local rankScore = tierWrapper:getRankScore()
  local iconPath = tierWrapper:getIconPath()
  local nextScore = 1
  local nextTierWrapper = ToClient_GetBattleRoyaleTierByIndex(tier - 2)
  if nil ~= nextTierWrapper then
    nextScore = nextTierWrapper:getRankScore()
  else
    nextScore = rankScore
  end
  PaGlobal_LobbyInstanceRating._ui.stc_tierIcon:ChangeTextureInfoName(iconPath)
  PaGlobal_LobbyInstanceRating._ui.stc_tierIcon:setRenderTexture(PaGlobal_LobbyInstanceRating._ui.stc_tierIcon:getBaseTexture())
  PaGlobal_LobbyInstanceRating._ui.stc_scoreCurrentValue:SetText(makeDotMoney(nowScore))
  PaGlobal_LobbyInstanceRating._ui.stc_scoreNextValue:SetText("/ " .. makeDotMoney(nextScore))
  PaGlobal_LobbyInstanceRating._ui.stc_scoreNextValue:SetPosX(PaGlobal_LobbyInstanceRating._ui.stc_scoreCurrentValue:GetPosX() + PaGlobal_LobbyInstanceRating._ui.stc_scoreCurrentValue:GetSizeX() + PaGlobal_LobbyInstanceRating._ui.stc_scoreCurrentValue:GetTextSizeX() + 5)
  nowScore = nowScore - rankScore
  if nextScore > 1 then
    nextScore = nextScore - rankScore
  end
  local rate = math.floor(nowScore / nextScore * 100)
  PaGlobal_LobbyInstanceRating._ui.progress_score:SetProgressRate(rate)
end
function PaGlobal_LobbyInstanceRating_RefreshInfo()
  if nil == LobbyInstance_Widget_Rating then
    return
  end
  PaGlobal_LobbyInstanceRating:statusUpdate()
end
