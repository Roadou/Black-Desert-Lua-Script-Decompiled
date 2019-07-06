local IM = CppEnums.EProcessorInputMode
local UI_color = Defines.Color
local UI_ST = CppEnums.SpawnType
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV = CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local UI_VT = CppEnums.VillageSiegeType
local PlunderTerritoryKey = {
  calpheon = 2,
  media = 3,
  valencia = 4
}
local PaGlobal_ApprovalRating = {
  ui = {
    approvalRatingBg = UI.getChildControl(Panel_WorldMap_Main, "Static_ApprovalRatingBg"),
    approvalUi = {}
  },
  _checkRadioBtn = 0,
  _approvalRatingValue = {},
  _territoryGuildMaster = {}
}
function PaGlobal_ApprovalRating:initApprovalRating()
  self.ui.approvalUi = {
    calpheonBg = UI.getChildControl(self.ui.approvalRatingBg, "Static_CalpheonBg"),
    mediaBg = UI.getChildControl(self.ui.approvalRatingBg, "Static_MediaBg"),
    valenciaBg = UI.getChildControl(self.ui.approvalRatingBg, "Static_ValenciaBg")
  }
  self.ui.approvalUi = {
    calpheonText = UI.getChildControl(self.ui.approvalUi.calpheonBg, "StaticText_Calpheon"),
    calpheonValue = UI.getChildControl(self.ui.approvalUi.calpheonBg, "StaticText_CalpheonValue"),
    calpheonRadioBtn = UI.getChildControl(self.ui.approvalUi.calpheonBg, "RadioButton_Calpheon"),
    mediaText = UI.getChildControl(self.ui.approvalUi.mediaBg, "StaticText_Media"),
    mediaValue = UI.getChildControl(self.ui.approvalUi.mediaBg, "StaticText_MediaValue"),
    mediaRadioBtn = UI.getChildControl(self.ui.approvalUi.mediaBg, "RadioButton_Media"),
    valenciaText = UI.getChildControl(self.ui.approvalUi.valenciaBg, "StaticText_Valencia"),
    valenciaValue = UI.getChildControl(self.ui.approvalUi.valenciaBg, "StaticText_ValenciaValue"),
    valenciaRadioBtn = UI.getChildControl(self.ui.approvalUi.valenciaBg, "RadioButton_Valencia"),
    voteBtn = UI.getChildControl(self.ui.approvalRatingBg, "Button_Vote")
  }
  self._approvalRatingValue[PlunderTerritoryKey.calpheon] = ""
  self._approvalRatingValue[PlunderTerritoryKey.media] = ""
  self._approvalRatingValue[PlunderTerritoryKey.valencia] = ""
  self.ui.approvalUi.voteBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_APPROVERATINGRATING_VOTE"))
  self.ui.approvalUi.calpheonText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_KALPEON"))
  self.ui.approvalUi.mediaText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_MEDIA"))
  self.ui.approvalUi.valenciaText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_BALENCIA"))
  self.ui.approvalRatingBg:SetShow(false)
  self.ui.approvalUi.calpheonRadioBtn:SetShow(false)
  self.ui.approvalUi.mediaRadioBtn:SetShow(false)
  self.ui.approvalUi.valenciaRadioBtn:SetShow(false)
  self.ui.approvalUi.voteBtn:SetShow(false)
end
function FGlobal_WorldMap_OpenPlunderVote()
  local ui = PaGlobal_ApprovalRating.ui
  local territoryKey = PaGlobal_ApprovalRating._checkRadioBtn
  if 0 == PaGlobal_ApprovalRating._checkRadioBtn then
    _PA_LOG("\235\172\180\236\160\149", "plundergameVote \237\130\164 \234\176\146\236\157\180 \236\151\134\235\138\148 \234\178\189\236\154\176\235\138\148 \236\158\136\236\150\180\236\132\160 \236\149\136 \235\144\169\235\139\136\235\139\164.")
    return
  end
  FGlobal_PlunderVoteOpen(territoryKey, PaGlobal_ApprovalRating._approvalRatingValue[territoryKey], PaGlobal_ApprovalRating._territoryGuildMaster[territoryKey])
end
function FGlobal_ApprovalRating_SetShow(isShow)
  PaGlobal_ApprovalRating.ui.approvalRatingBg:SetShow(isShow)
  if true == isShow then
    PaGlobal_ApprovalRating.ui.approvalRatingBg:ComputePos()
    ToClient_requestApprovalRating()
  end
end
function HandleClicked_WorldMap_ApprovalRating_Vote(territoryKey)
  local self = PaGlobal_ApprovalRating
  self._checkRadioBtn = territoryKey
  if false == self._territoryGuildMaster[territoryKey] then
    self.ui.approvalUi.voteBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_APPROVERATINGRATING_VOTE"))
  else
    self.ui.approvalUi.voteBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_APPROVERATINGRATING_MANAGEMENT"))
  end
end
function FromClient_PlunderGame_ApprovalRating(territoryKey, like, disLike)
  local ui = PaGlobal_ApprovalRating.ui
  local stringText
  if like < disLike then
    stringText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_APPROVERATINGRATING_COMPLAIN_COUNT", "count", tostring(disLike - like))
  else
    stringText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_APPROVERATINGRATING_SUPPORT_COUNT", "count", tostring(like - disLike))
  end
  PaGlobal_ApprovalRating._approvalRatingValue[territoryKey] = stringText
  if PlunderTerritoryKey.calpheon == territoryKey then
    ui.approvalUi.calpheonValue:SetText(stringText)
  elseif PlunderTerritoryKey.media == territoryKey then
    ui.approvalUi.mediaValue:SetText(stringText)
  elseif PlunderTerritoryKey.valencia == territoryKey then
    ui.approvalUi.valenciaValue:SetText(stringText)
  end
end
function FromClient_PlunderGameVote_Setting(voteCount)
  PaGlobal_ApprovalRating._checkRadioBtn = 0
  PaGlobal_ApprovalRating._territoryGuildMaster[PlunderTerritoryKey.calpheon] = false
  PaGlobal_ApprovalRating._territoryGuildMaster[PlunderTerritoryKey.media] = false
  PaGlobal_ApprovalRating._territoryGuildMaster[PlunderTerritoryKey.valencia] = false
  local ui = PaGlobal_ApprovalRating.ui
  ui.approvalUi.calpheonRadioBtn:SetCheck(false)
  ui.approvalUi.mediaRadioBtn:SetCheck(false)
  ui.approvalUi.valenciaRadioBtn:SetCheck(false)
  ui.approvalUi.calpheonRadioBtn:SetShow(false)
  ui.approvalUi.mediaRadioBtn:SetShow(false)
  ui.approvalUi.valenciaRadioBtn:SetShow(false)
  ui.approvalUi.voteBtn:SetShow(false)
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer and true == selfPlayer:get():isGuildMaster() and 0 < myGuildInfo:getTerritoryCount() then
    for idx = 0, myGuildInfo:getTerritoryCount() - 1 do
      local territoryKey = myGuildInfo:getTerritoryKeyAt(idx)
      if PlunderTerritoryKey.calpheon == territoryKey then
        ui.approvalUi.calpheonRadioBtn:SetShow(true)
        ui.approvalUi.voteBtn:SetShow(true)
        PaGlobal_ApprovalRating._territoryGuildMaster[territoryKey] = true
      elseif PlunderTerritoryKey.media == territoryKey then
        ui.approvalUi.mediaRadioBtn:SetShow(true)
        ui.approvalUi.voteBtn:SetShow(true)
        PaGlobal_ApprovalRating._territoryGuildMaster[territoryKey] = true
      elseif PlunderTerritoryKey.valencia == territoryKey then
        ui.approvalUi.valenciaRadioBtn:SetShow(true)
        ui.approvalUi.voteBtn:SetShow(true)
        PaGlobal_ApprovalRating._territoryGuildMaster[territoryKey] = true
      end
    end
  end
  if voteCount <= 0 then
    return
  end
  if 0 < myGuildInfo:getSiegeCount() then
    for idx = 0, myGuildInfo:getSiegeCount() - 1 do
      local regionKey = myGuildInfo:getSiegeKeyAt(idx)
      local regionInfoWrapper = getRegionInfoWrapper(regionKey)
      local territoryKey = regionInfoWrapper:getTerritoryKeyRaw()
      if PlunderTerritoryKey.calpheon == territoryKey then
        ui.approvalUi.calpheonRadioBtn:SetShow(true)
        ui.approvalUi.voteBtn:SetShow(true)
      elseif PlunderTerritoryKey.media == territoryKey then
        ui.approvalUi.mediaRadioBtn:SetShow(true)
        ui.approvalUi.voteBtn:SetShow(true)
      elseif PlunderTerritoryKey.valencia == territoryKey then
        ui.approvalUi.valenciaRadioBtn:SetShow(true)
        ui.approvalUi.voteBtn:SetShow(true)
      end
    end
  end
end
function PaGlobal_ApprovalRating:registEventHandler()
  self.ui.approvalUi.calpheonRadioBtn:addInputEvent("Mouse_LUp", "HandleClicked_WorldMap_ApprovalRating_Vote(" .. PlunderTerritoryKey.calpheon .. ")")
  self.ui.approvalUi.mediaRadioBtn:addInputEvent("Mouse_LUp", "HandleClicked_WorldMap_ApprovalRating_Vote(" .. PlunderTerritoryKey.media .. ")")
  self.ui.approvalUi.valenciaRadioBtn:addInputEvent("Mouse_LUp", "HandleClicked_WorldMap_ApprovalRating_Vote(" .. PlunderTerritoryKey.valencia .. ")")
  self.ui.approvalUi.voteBtn:addInputEvent("Mouse_LUp", "FGlobal_WorldMap_OpenPlunderVote()")
end
PaGlobal_ApprovalRating:initApprovalRating()
PaGlobal_ApprovalRating:registEventHandler()
registerEvent("FromClient_PlunderGame_ApprovalRating", "FromClient_PlunderGame_ApprovalRating")
registerEvent("FromClient_PlunderGameVote_Setting", "FromClient_PlunderGameVote_Setting")
