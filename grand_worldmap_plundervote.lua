local PlunderTerritoryKey = {
  calpheon = 2,
  media = 3,
  valencia = 4
}
local PaGlobal_PlunderVote = {
  ui = {
    _staticTitle = UI.getChildControl(Panel_WorldMap_PlunderVote, "Static_Text_Title"),
    _approvalRatingBg = UI.getChildControl(Panel_WorldMap_PlunderVote, "Static_ApprovalRatingBg"),
    _approvalRating = {},
    _decreaseDisLikeBg = UI.getChildControl(Panel_WorldMap_PlunderVote, "Static_DecreaseBg"),
    _decreaseDisLike = {},
    _voteBtn = UI.getChildControl(Panel_WorldMap_PlunderVote, "Button_Vote"),
    _decreaseDislikeBtn = UI.getChildControl(Panel_WorldMap_PlunderVote, "Button_DecreaseDislike"),
    _voteCancelBtn = UI.getChildControl(Panel_WorldMap_PlunderVote, "Button_Cancel")
  },
  _territoryKey = 0,
  _isLike = 0,
  _decreaseDisLikeCount = 0
}
function PaGlobal_PlunderVote:init()
  self.ui._approvalRating = {
    _territoryName = UI.getChildControl(self.ui._approvalRatingBg, "StaticText_TerritoryName"),
    _guildIconBG = UI.getChildControl(self.ui._approvalRatingBg, "Static_GuildIcon_BG"),
    _guildIcon = UI.getChildControl(self.ui._approvalRatingBg, "Static_Guild_Icon"),
    _guildName = UI.getChildControl(self.ui._approvalRatingBg, "StaticText_GuildName"),
    _currentState = UI.getChildControl(self.ui._approvalRatingBg, "StaticText_CurrentState"),
    _plusRadioBtn = UI.getChildControl(self.ui._approvalRatingBg, "RadioButton_Plus"),
    _minusRadioBtn = UI.getChildControl(self.ui._approvalRatingBg, "RadioButton_Minus")
  }
  self.ui._voteBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_APPROVERATINGRATING_BTN_VOTE"))
  self.ui._decreaseDislikeBtn:SetText(PAGetString(Defines.StringSheet_RESOURCE, "AUCTION_POPUP_BTN_YES"))
  self.ui._voteCancelBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_APPROVERATINGRATING_BTN_CANCEL"))
  self.ui._approvalRating._plusRadioBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_APPROVERATINGRATING_SUPPORT_VOTE"))
  self.ui._approvalRating._minusRadioBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_APPROVERATINGRATING_COMPLAIN_VOTE"))
  PaGlobal_PlunderVote._territoryKey = 0
  self.ui._decreaseDisLike = {
    _territoryName = UI.getChildControl(self.ui._decreaseDisLikeBg, "StaticText_TerritoryName"),
    _guildIconBG = UI.getChildControl(self.ui._decreaseDisLikeBg, "Static_GuildIcon_BG"),
    _guildIcon = UI.getChildControl(self.ui._decreaseDisLikeBg, "Static_Guild_Icon"),
    _guildName = UI.getChildControl(self.ui._decreaseDisLikeBg, "StaticText_GuildName"),
    _currentState = UI.getChildControl(self.ui._decreaseDisLikeBg, "StaticText_CurrentState"),
    _editCount = UI.getChildControl(self.ui._decreaseDisLikeBg, "Edit_Count"),
    _needMoneyValue = UI.getChildControl(self.ui._decreaseDisLikeBg, "StaticText_NeedMoneyValue")
  }
end
function PaGlobal_PlunderVote:open(key, currentstate, territoryName, guildName, isGuildMaster)
  self._territoryKey = key
  self._decreaseDisLikeCount = 0
  if false == isGuildMaster then
    self.ui._approvalRatingBg:SetShow(true)
    self.ui._voteBtn:SetShow(true)
    self.ui._decreaseDisLikeBg:SetShow(false)
    self.ui._decreaseDislikeBtn:SetShow(false)
    self.ui._approvalRating._currentState:SetText(currentstate)
    self.ui._approvalRating._territoryName:SetText(territoryName)
    self.ui._approvalRating._guildName:SetText(guildName)
    HandleClicked_PlunderGameRadioBtn(true)
  else
    self.ui._approvalRatingBg:SetShow(false)
    self.ui._voteBtn:SetShow(false)
    self.ui._decreaseDisLikeBg:SetShow(true)
    self.ui._decreaseDislikeBtn:SetShow(true)
    self.ui._decreaseDisLike._currentState:SetText(currentstate)
    self.ui._decreaseDisLike._territoryName:SetText(territoryName)
    self.ui._decreaseDisLike._guildName:SetText(guildName)
    self.ui._decreaseDisLike._editCount:SetEditText("0")
    self.ui._decreaseDisLike._needMoneyValue:SetText("0")
  end
end
function FGlobal_PlunderVoteOpen(key, currentstate, isGuildMaster)
  if true == Panel_WorldMap_PlunderVote:GetShow() then
    return
  end
  local territorySiege = ToClient_GetSiegeWrapper(key)
  if nil == territorySiege then
    _PA_LOG("\235\172\180\236\160\149", "\236\151\172\234\184\176\234\185\140\236\167\128 \236\153\128\236\132\156 \237\149\180\235\139\185 \236\152\129\236\167\128\234\176\128 \236\151\134\235\138\148\234\177\180 \235\167\144\236\157\180 \236\149\136 \235\144\169\235\139\136\235\139\164.")
    return
  end
  local guildNo = territorySiege:getGuildNo()
  local guildIcon
  if false == isGuildMaster then
    guildIcon = PaGlobal_PlunderVote.ui._approvalRating._guildIcon
    PaGlobal_PlunderVote.ui._staticTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_GRAND_VOTE_POPUP"))
  else
    guildIcon = PaGlobal_PlunderVote.ui._decreaseDisLike._guildIcon
    PaGlobal_PlunderVote.ui._staticTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_GRAND_COMPLAINT_MANAGEMENT"))
  end
  local isSet = setGuildTextureByGuildNo(guildNo, guildIcon)
  if false == isSet then
    _PA_LOG("\235\172\180\236\160\149", "\236\160\144\235\160\185\237\149\156 \234\184\184\235\147\156\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164. \237\149\132\236\154\148\237\149\152\235\139\164\235\169\180 \235\169\148\236\139\156\236\167\128 \235\157\132\236\154\184 \234\178\131")
    return
  else
    guildIcon:getBaseTexture():setUV(0, 0, 1, 1)
    guildIcon:setRenderTexture(guildIcon:getBaseTexture())
  end
  PaGlobal_PlunderVote:open(key, currentstate, territorySiege:getTerritoryName(), territorySiege:getGuildName(), isGuildMaster)
  Panel_WorldMap_PlunderVote:SetShow(true)
end
function FGlobal_PlunderDecreaseDisLike(count)
  count = Int64toInt32(count)
  PaGlobal_PlunderVote._decreaseDisLikeCount = count
  PaGlobal_PlunderVote.ui._decreaseDisLike._editCount:SetEditText(tostring(count))
  local money = ToClient_GetPlunderGameDecreaseDislikeNeedMoney(PaGlobal_PlunderVote._decreaseDisLikeCount)
  PaGlobal_PlunderVote.ui._decreaseDisLike._needMoneyValue:SetText(makeDotMoney(money))
end
function HandleClicked_PlunderGameVote()
  ToClient_PlunderGameVote(PaGlobal_PlunderVote._territoryKey, PaGlobal_PlunderVote._isLike)
  Panel_WorldMap_PlunderVote:SetShow(false)
end
function HandleClicked_PlunderGameDecreaseDislike()
  if 0 < PaGlobal_PlunderVote._decreaseDisLikeCount then
    ToClient_decreaseDisLike(PaGlobal_PlunderVote._decreaseDisLikeCount)
    Panel_WorldMap_PlunderVote:SetShow(false)
  end
end
function HandleClicked_PlunderGameVoteCancel()
  Panel_WorldMap_PlunderVote:SetShow(false)
end
function HandleClicked_PlunderGameRadioBtn(isPlue)
  local ui = PaGlobal_PlunderVote.ui
  if true == isPlue then
    ui._approvalRating._plusRadioBtn:SetCheck(true)
    ui._approvalRating._minusRadioBtn:SetCheck(false)
    paGlobal_PlunderVote._isLike = true
  else
    ui._approvalRating._plusRadioBtn:SetCheck(false)
    ui._approvalRating._minusRadioBtn:SetCheck(true)
    paGlobal_PlunderVote._isLike = false
  end
end
function HandleClicked_PlunderGameEditCount()
  local count = ToClient_getMaxDecreaseDisLikeCount()
  Panel_NumberPad_Show(true, toInt64(0, count), 0, FGlobal_PlunderDecreaseDisLike)
end
function FromClient_luaLoadComplete_PlunderVote()
  PaGlobal_PlunderVote:init()
  PaGlobal_PlunderVote:registEventHandler()
end
function PaGlobal_PlunderVote:registEventHandler()
  local ui = self.ui
  ui._voteBtn:addInputEvent("Mouse_LUp", "HandleClicked_PlunderGameVote()")
  ui._decreaseDislikeBtn:addInputEvent("Mouse_LUp", "HandleClicked_PlunderGameDecreaseDislike()")
  ui._voteCancelBtn:addInputEvent("Mouse_LUp", "HandleClicked_PlunderGameVoteCancel()")
  ui._approvalRating._plusRadioBtn:addInputEvent("Mouse_LUp", "HandleClicked_PlunderGameRadioBtn(true)")
  ui._approvalRating._minusRadioBtn:addInputEvent("Mouse_LUp", "HandleClicked_PlunderGameRadioBtn(false)")
  ui._decreaseDisLike._editCount:addInputEvent("Mouse_LUp", "HandleClicked_PlunderGameEditCount()")
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_PlunderVote")
