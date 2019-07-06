local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local UI_color = Defines.Color
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local shortClearCount, dailyChallengeValue, clearCountText, clearCountValue, remainRewardCountValue, btnRewardShow, contentBody, contentBG, contentTitle, contentDesc, contentIcon, contentComplete, normalText, selectText, rewardBG, itemSlotBG0, itemSlotBG1, itemSlotBG2, itemSlotBG3, itemIcon0, itemIcon1, itemIcon2, itemIcon3, selectSlotBG0, selectSlotBG1, selectSlotBG2, selectSlotBG3, selectSlotBG4, selectSlotBG5, selectSlotBGCover, selectItemIcon0, selectItemIcon1, selectItemIcon2, selectItemIcon3, selectItemIcon4, selectItemIcon5, explainBG, _scroll, _scrollCtrlBtn
local _scrollIndex = 0
local isInit = true
local currentRewardCount = 0
local expTooltip
local function createExpTooltip()
  if nil == Panel_Window_Challenge then
    return
  end
  local _checkedQuestStaticActive = UI.getChildControl(Panel_CheckedQuest, "Static_Active")
  local expTooltipBase = UI.getChildControl(_checkedQuestStaticActive, "StaticText_Notice_2")
  expTooltip = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_Challenge, "expTooltip")
  CopyBaseProperty(expTooltipBase, expTooltip)
  expTooltip:SetColor(UI_color.C_FFFFFFFF)
  expTooltip:SetAlpha(1)
  expTooltip:SetFontColor(UI_color.C_FFFFFFFF)
  expTooltip:SetAutoResize(true)
  expTooltip:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  expTooltip:SetTextHorizonCenter()
  expTooltip:SetShow(false)
end
local tapCount = 6
if isGameTypeKorea() then
  tapCount = 6
elseif isGameTypeRussia() then
  tapCount = 6
elseif isGameTypeEnglish() then
  tapCount = 6
elseif isGameTypeJapan() then
  tapCount = 6
else
  tapCount = 6
end
local tapMenu = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_SHORT"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_DAILY"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_COMPLETE"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_EVENT"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_PCROOM"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_COMPLETEGETITEM")
}
local tabTexture = {
  [0] = {
    [0] = {
      124,
      63,
      164,
      103
    },
    [1] = {
      370,
      63,
      410,
      103
    },
    [2] = {
      83,
      63,
      123,
      103
    }
  },
  [1] = {
    [0] = {
      124,
      63,
      164,
      103
    },
    [1] = {
      370,
      63,
      410,
      103
    },
    [2] = {
      83,
      63,
      123,
      103
    }
  },
  [2] = {
    [0] = {
      124,
      63,
      164,
      103
    },
    [1] = {
      370,
      63,
      410,
      103
    },
    [2] = {
      83,
      63,
      123,
      103
    }
  },
  [3] = {
    [0] = {
      124,
      63,
      164,
      103
    },
    [1] = {
      370,
      63,
      410,
      103
    },
    [2] = {
      83,
      63,
      123,
      103
    }
  },
  [4] = {
    [0] = {
      124,
      63,
      164,
      103
    },
    [1] = {
      370,
      63,
      410,
      103
    },
    [2] = {
      83,
      63,
      123,
      103
    }
  },
  [5] = {
    [0] = {
      124,
      63,
      164,
      103
    },
    [1] = {
      370,
      63,
      410,
      103
    },
    [2] = {
      83,
      63,
      123,
      103
    }
  }
}
local _tapMenu = {}
local _tapIcon = {}
local _tapValue = 0
local _menuTextspan = 7
local countrySet = true
local maxCount = 0
local _selectedReward_ChallengeIndex, _selectedReward_SlotIndex, radioBtn_TapMenu, tapPosX, tapSizeX
function Challenge_TapMenu_Create()
  if nil == Panel_Window_Challenge then
    return
  end
  if isGameTypeRussia() then
    countrySet = true
  elseif isGameTypeEnglish() or isGameTypeTaiwan() or isGameTypeSA() or isGameTypeKR2() or isGameTypeTR() or isGameTypeTH() or isGameTypeID() then
    countrySet = false
  else
    countrySet = true
  end
  for index = 0, tapCount - 1 do
    _tapMenu[index] = {}
    _tapMenu[index] = UI.createControl(UCT.PA_UI_CONTROL_RADIOBUTTON, Panel_Window_Challenge, "Challenge_Tapmenu_" .. index)
    CopyBaseProperty(radioBtn_TapMenu, _tapMenu[index])
    _tapMenu[index]:addInputEvent("Mouse_LUp", "HandleClickedTapButton(" .. index .. ")")
    _tapMenu[index]:SetText(tapMenu[index])
    _tapMenu[index]:SetTextSpan(_tapMenu[index]:GetSizeX() / 2 - _tapMenu[index]:GetTextSizeX() / 2 + _menuTextspan)
    if 4 == index then
      if isGameTypeRussia() then
        _tapMenu[index]:SetShow(true)
      elseif isGameTypeEnglish() or isGameTypeTaiwan() or isGameTypeSA() or isGameTypeKR2() or isGameTypeTR() or isGameTypeTH() or isGameTypeID() then
        _tapMenu[index]:SetShow(false)
      else
        _tapMenu[index]:SetShow(true)
      end
    else
      _tapMenu[index]:SetShow(true)
    end
    if 0 == index then
      _tapMenu[0]:SetPosX(tapPosX + (tapSizeX - 4) * 0)
    elseif 1 == index then
      _tapMenu[1]:SetPosX(tapPosX + (tapSizeX + 5) * 1)
    elseif 2 == index then
      if countrySet then
        _tapMenu[2]:SetPosX(tapPosX + (tapSizeX + 5) * 4)
      else
        _tapMenu[2]:SetPosX(tapPosX + (tapSizeX - 4) * 3)
      end
    elseif 3 == index then
      if countrySet then
        _tapMenu[3]:SetPosX(tapPosX + (tapSizeX + 5) * 3)
      else
        _tapMenu[3]:SetPosX(tapPosX + (tapSizeX - 4) * 2)
      end
    elseif 4 == index then
      _tapMenu[4]:SetPosX(tapPosX + (tapSizeX + 5) * 2)
    elseif 5 == index then
      if countrySet then
        _tapMenu[5]:SetPosX(tapPosX + (tapSizeX + 5) * 5)
      else
        _tapMenu[5]:SetPosX(tapPosX + (tapSizeX - 4) * 4)
      end
    end
    local texturePath = "renewal/pcremaster/remaster_common_00.dds"
    if 5 == index then
      texturePath = "renewal/pcremaster/remaster_common_00.dds"
    end
    _tapMenu[index]:ChangeTextureInfoName(texturePath)
    local x1, y1, x2, y2 = setTextureUV_Func(_tapMenu[index], tabTexture[index][0][1], tabTexture[index][0][2], tabTexture[index][0][3], tabTexture[index][0][4])
    _tapMenu[index]:getBaseTexture():setUV(x1, y1, x2, y2)
    _tapMenu[index]:ChangeOnTextureInfoName(texturePath)
    local x1, y1, x2, y2 = setTextureUV_Func(_tapMenu[index], tabTexture[index][1][1], tabTexture[index][1][2], tabTexture[index][1][3], tabTexture[index][1][4])
    _tapMenu[index]:getOnTexture():setUV(x1, y1, x2, y2)
    _tapMenu[index]:ChangeClickTextureInfoName(texturePath)
    local x1, y1, x2, y2 = setTextureUV_Func(_tapMenu[index], tabTexture[index][2][1], tabTexture[index][2][2], tabTexture[index][2][3], tabTexture[index][2][4])
    _tapMenu[index]:getClickTexture():setUV(x1, y1, x2, y2)
    _tapMenu[index]:setRenderTexture(_tapMenu[index]:getBaseTexture())
  end
end
function FGlobal_TapButton_Complete()
  HandleClickedTapButton(5)
end
function HandleClickedTapButton(index)
  if nil == Panel_Window_Challenge then
    return
  end
  for i = 0, tapCount - 1 do
    _tapMenu[i]:SetCheck(false)
  end
  _tapValue = index
  _tapMenu[index]:SetCheck(true)
  _scroll:SetControlPos(0)
  _scrollIndex = 0
  maxCount = 0
  Challenge_Update()
end
local _content = {}
local _baseReward = {}
local _selectReward = {}
local controlCount = 4
local isInitChallenge = false
function Challenge_Initialize()
  if true == isInitChallenge then
    return
  end
  if nil == Panel_Window_Challenge then
    return
  end
  local sizeY = contentBG:GetSizeY() + 10
  for index = 0, controlCount - 1 do
    _content[index] = {}
    _content[index].BG = UI.createControl(UCT.PA_UI_CONTROL_STATIC, contentBody, "Challenge_content_BG_" .. index)
    _content[index].Title = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, _content[index].BG, "Challenge_content_Title_" .. index)
    _content[index].Desc = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, _content[index].BG, "Challenge_content_Desc_" .. index)
    _content[index].Icon = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_content_Icon_" .. index)
    _content[index].btnGetReward = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, _content[index].BG, "Challenge_content_btnGetReward_" .. index)
    _content[index].normalText = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, _content[index].BG, "StaticText_NormalReward_" .. index)
    _content[index].selectText = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, _content[index].BG, "StaticText_SelectReward_" .. index)
    _content[index].rewardBG = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_RewardBG_" .. index)
    _content[index].itemSlotBG0 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_ResultSlot0_" .. index)
    _content[index].itemSlotBG1 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_ResultSlot1_" .. index)
    _content[index].itemSlotBG2 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_ResultSlot2_" .. index)
    _content[index].itemSlotBG3 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_ResultSlot3_" .. index)
    _content[index].itemIcon0 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_ItemIcon0_" .. index)
    _content[index].itemIcon1 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_ItemIcon1_" .. index)
    _content[index].itemIcon2 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_ItemIcon2_" .. index)
    _content[index].itemIcon3 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_ItemIcon3_" .. index)
    _content[index].selectSlotBG0 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_SelectSlot0_" .. index)
    _content[index].selectSlotBG1 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_SelectSlot1_" .. index)
    _content[index].selectSlotBG2 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_SelectSlot2_" .. index)
    _content[index].selectSlotBG3 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_SelectSlot3_" .. index)
    _content[index].selectSlotBG4 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_SelectSlot4_" .. index)
    _content[index].selectSlotBG5 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_SelectSlot5_" .. index)
    _content[index].selectItemIcon0 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_SelectItemIcon0_" .. index)
    _content[index].selectItemIcon1 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_SelectItemIcon1_" .. index)
    _content[index].selectItemIcon2 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_SelectItemIcon2_" .. index)
    _content[index].selectItemIcon3 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_SelectItemIcon3_" .. index)
    _content[index].selectItemIcon4 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_SelectItemIcon4_" .. index)
    _content[index].selectItemIcon5 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _content[index].BG, "Challenge_Static_SelectItemIcon5_" .. index)
    _content[index].contentComplete = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, _content[index].BG, "Challenge_content_Complete_" .. index)
    CopyBaseProperty(contentBG, _content[index].BG)
    CopyBaseProperty(contentTitle, _content[index].Title)
    CopyBaseProperty(contentDesc, _content[index].Desc)
    CopyBaseProperty(contentIcon, _content[index].Icon)
    CopyBaseProperty(btnRewardShow, _content[index].btnGetReward)
    CopyBaseProperty(normalText, _content[index].normalText)
    CopyBaseProperty(selectText, _content[index].selectText)
    CopyBaseProperty(rewardBG, _content[index].rewardBG)
    CopyBaseProperty(itemSlotBG0, _content[index].itemSlotBG0)
    CopyBaseProperty(itemSlotBG1, _content[index].itemSlotBG1)
    CopyBaseProperty(itemSlotBG2, _content[index].itemSlotBG2)
    CopyBaseProperty(itemSlotBG3, _content[index].itemSlotBG3)
    CopyBaseProperty(itemIcon0, _content[index].itemIcon0)
    CopyBaseProperty(itemIcon1, _content[index].itemIcon1)
    CopyBaseProperty(itemIcon2, _content[index].itemIcon2)
    CopyBaseProperty(itemIcon3, _content[index].itemIcon3)
    CopyBaseProperty(selectSlotBG0, _content[index].selectSlotBG0)
    CopyBaseProperty(selectSlotBG1, _content[index].selectSlotBG1)
    CopyBaseProperty(selectSlotBG2, _content[index].selectSlotBG2)
    CopyBaseProperty(selectSlotBG3, _content[index].selectSlotBG3)
    CopyBaseProperty(selectSlotBG4, _content[index].selectSlotBG4)
    CopyBaseProperty(selectSlotBG5, _content[index].selectSlotBG5)
    CopyBaseProperty(selectItemIcon0, _content[index].selectItemIcon0)
    CopyBaseProperty(selectItemIcon1, _content[index].selectItemIcon1)
    CopyBaseProperty(selectItemIcon2, _content[index].selectItemIcon2)
    CopyBaseProperty(selectItemIcon3, _content[index].selectItemIcon3)
    CopyBaseProperty(selectItemIcon4, _content[index].selectItemIcon4)
    CopyBaseProperty(selectItemIcon5, _content[index].selectItemIcon5)
    CopyBaseProperty(contentComplete, _content[index].contentComplete)
    _content[index].BG:SetShow(false)
    _content[index].Title:SetShow(false)
    _content[index].Desc:SetShow(false)
    _content[index].Icon:SetShow(false)
    _content[index].contentComplete:SetShow(false)
    _content[index].btnGetReward:SetShow(false)
    _content[index].btnGetReward:SetAutoDisableTime(0.5)
    _content[index].normalText:SetShow(false)
    _content[index].selectText:SetShow(false)
    _content[index].rewardBG:SetShow(false)
    _content[index].itemSlotBG0:SetShow(false)
    _content[index].itemSlotBG1:SetShow(false)
    _content[index].itemSlotBG2:SetShow(false)
    _content[index].itemSlotBG3:SetShow(false)
    _content[index].itemIcon0:SetShow(false)
    _content[index].itemIcon1:SetShow(false)
    _content[index].itemIcon2:SetShow(false)
    _content[index].itemIcon3:SetShow(false)
    _content[index].selectSlotBG0:SetShow(false)
    _content[index].selectSlotBG1:SetShow(false)
    _content[index].selectSlotBG2:SetShow(false)
    _content[index].selectSlotBG3:SetShow(false)
    _content[index].selectSlotBG4:SetShow(false)
    _content[index].selectSlotBG5:SetShow(false)
    _content[index].selectItemIcon0:SetShow(false)
    _content[index].selectItemIcon1:SetShow(false)
    _content[index].selectItemIcon2:SetShow(false)
    _content[index].selectItemIcon3:SetShow(false)
    _content[index].selectItemIcon4:SetShow(false)
    _content[index].selectItemIcon5:SetShow(false)
    _content[index].Desc:setLineCountByLimitAutoWrap(3)
    _content[index].Desc:SetTextMode(UI_TM.eTextMode_Limit_AutoWrap)
    if 0 == index then
      _content[index].BG:SetPosY(15)
    else
      _content[index].BG:SetPosY(_content[index - 1].BG:GetPosY() + sizeY)
    end
    _content[index].Icon:SetPosY(0)
    _content[index].contentComplete:SetPosX(415)
    _content[index].contentComplete:SetPosY(15)
    _content[index].btnGetReward:SetPosX(350)
    _content[index].btnGetReward:SetPosY(15)
    _baseReward[index] = {}
    _baseReward[index][0] = _content[index].itemIcon0
    _baseReward[index][1] = _content[index].itemIcon1
    _baseReward[index][2] = _content[index].itemIcon2
    _baseReward[index][3] = _content[index].itemIcon3
    _selectReward[index] = {}
    _selectReward[index][0] = _content[index].selectItemIcon0
    _selectReward[index][1] = _content[index].selectItemIcon1
    _selectReward[index][2] = _content[index].selectItemIcon2
    _selectReward[index][3] = _content[index].selectItemIcon3
    _selectReward[index][4] = _content[index].selectItemIcon4
    _selectReward[index][5] = _content[index].selectItemIcon5
    Challenge_SlotSetting(index)
    explainBG:SetText("")
    _content[index].BG:addInputEvent("Mouse_UpScroll", "Challenge_Scroll( true )")
    _content[index].BG:addInputEvent("Mouse_DownScroll", "Challenge_Scroll( false )")
  end
  isInitChallenge = true
end
local _maxBaseSlotCount = 4
local _maxSelectSlotCount = 6
local _uiBackBaseReward = {}
local _listBaseRewardSlots = {}
local _uiButtonSelectRewardSlots = {}
local _listSelectRewardSlots = {}
local _challengerewardSlotConfig = {
  createIcon = true,
  createBorder = true,
  createCount = true,
  createClassEquipBG = true,
  createCash = true
}
local baseRewardPosY = 0
function Challenge_SlotSetting(index)
  if nil == Panel_Window_Challenge then
    return
  end
  _uiBackBaseReward[index] = {}
  _listBaseRewardSlots[index] = {}
  for ii = 0, _maxBaseSlotCount - 1 do
    _baseReward[index][ii]:SetIgnore(true)
    _uiBackBaseReward[index][ii] = _baseReward[index][ii]
    local slot = {}
    SlotItem.new(slot, "BaseReward_" .. ii, ii, _baseReward[index][ii], _challengerewardSlotConfig)
    slot:createChild()
    slot.icon:SetSize(44, 44)
    slot.icon:SetPosX(0)
    slot.icon:SetPosY(0)
    slot.border:SetSize(44, 44)
    slot.border:SetPosX(1)
    slot.border:SetPosY(1)
    _listBaseRewardSlots[index][ii] = slot
  end
  _uiButtonSelectRewardSlots[index] = {}
  _listSelectRewardSlots[index] = {}
  for jj = 0, _maxSelectSlotCount - 1 do
    _uiButtonSelectRewardSlots[index][jj] = _selectReward[index][jj]
    local slot = {}
    SlotItem.new(slot, "SelectReward_" .. jj, jj, _selectReward[index][jj], _challengerewardSlotConfig)
    slot:createChild()
    slot.icon:SetPosX(0)
    slot.icon:SetPosY(0)
    slot.icon:SetSize(30, 30)
    slot.icon:SetIgnore(false)
    slot.border:SetSize(30, 30)
    slot.count:SetPosX(-10)
    slot.count:SetPosY(8)
    slot.classEquipBG:SetHorizonRight()
    slot.classEquipBG:SetVerticalBottom()
    slot.classEquipBG:SetSpanSize(2, 2)
    slot.selectedSatic = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _selectReward[index][jj], "Challenge_Static_SelectedSlot_" .. index .. "_" .. jj)
    CopyBaseProperty(selectSlotBGCover, slot.selectedSatic)
    slot.selectedSatic:SetPosX(-2)
    slot.selectedSatic:SetPosY(-2)
    slot.selectedSatic:SetSize(32, 32)
    slot.selectedSatic:SetShow(false)
    slot.selectedSatic:SetIgnore(true)
    _listSelectRewardSlots[index][jj] = slot
  end
end
function Challenge_clearRewardSlot(index)
  if nil == Panel_Window_Challenge then
    return
  end
  for ii = 0, _maxBaseSlotCount - 1 do
    local slot = _listBaseRewardSlots[index][ii]
    slot:clearItem()
    slot.icon:addInputEvent("Mouse_On", "")
    slot.icon:addInputEvent("Mouse_Out", "")
  end
  for jj = 0, _maxSelectSlotCount - 1 do
    local slot = _listSelectRewardSlots[index][jj]
    slot:clearItem()
    slot.icon:addInputEvent("Mouse_On", "")
    slot.icon:addInputEvent("Mouse_Out", "")
  end
end
function Challenge_clearSlot(list_Idx)
  if nil == Panel_Window_Challenge then
    return
  end
  _content[list_Idx].BG:SetShow(false)
  _content[list_Idx].btnGetReward:SetShow(false)
end
local controlValueCount = 0
local _count = 0
local specialRewardWrapper = {}
local normalRewardWrapper = {}
local challengeType = 0
local challengeWrapper
local baseCount = 0
function Fglobal_Challenge_UpdateData()
  Challenge_Update()
end
local GetChallengeRewardFirstIndex = function(groupIndex)
  local length = ToClient_GetChallengeRewardInfoCount()
  local count = -1
  local prevGroup = -1
  for index = 0, length - 1 do
    local rewardWrapper = ToClient_GetChallengeRewardInfoWrapper(index)
    if nil ~= rewardWrapper and (prevGroup ~= rewardWrapper:getOptionalType() or 0 == rewardWrapper:getOptionalType()) then
      count = count + 1
      prevGroup = rewardWrapper:getOptionalType()
    end
    if count == groupIndex then
      return index
    end
  end
  return -1
end
local GetChallengeRewardGroupCount = function()
  local length = ToClient_GetChallengeRewardInfoCount()
  local count = 0
  local prevGroup = -1
  local optionalCount = 0
  for index = 0, length - 1 do
    local rewardWrapper = ToClient_GetChallengeRewardInfoWrapper(index)
    if nil ~= rewardWrapper and (prevGroup ~= rewardWrapper:getOptionalType() or 0 == rewardWrapper:getOptionalType()) then
      count = count + 1
      prevGroup = rewardWrapper:getOptionalType()
    end
  end
  return count
end
function Challenge_Update()
  if nil == Panel_Window_Challenge then
    return
  end
  _selectedReward_ChallengeIndex = nil
  _selectedReward_SlotIndex = nil
  _tapMenu[_tapValue]:SetCheck(true)
  local totalCompleteCount = ToClient_GetCompletedChallengeCount()
  local totalProgressCount = ToClient_GetProgressChallengeCount(1) + ToClient_GetProgressChallengeCount(2) + ToClient_GetProgressChallengeCount(3)
  clearCountValue:SetText(totalCompleteCount .. " / " .. totalCompleteCount + totalProgressCount)
  clearCountValue:SetPosX(clearCountText:GetPosX() + clearCountText:GetTextSizeX() + 10)
  shortClearCount:SetText("")
  dailyChallengeValue:SetText("")
  local remainRewardCount = PaGlobalFunc_Challenge_GetTotalRemainRewardCount()
  if remainRewardCount <= 0 then
    remainRewardCountValue:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_REWARDCOUNTVALUE_EMPTY"))
    remainRewardCountValue:SetFontColor(UI_color.C_FF888888)
    Panel_ChallengeReward_Alert:SetShow(false)
    PaGlobal_SelfPlayer_Expgage()
  else
    remainRewardCountValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHALLENGE_REWARDCOUNTVALUE_HAVE", "remainRewardCount", remainRewardCount))
    remainRewardCountValue:SetFontColor(UI_color.C_FFFFFFFF)
    Panel_ChallengeReward_Alert:SetShow(false)
    PackageIconPosition()
    FromClient_PackageIconUpdate()
  end
  local viewCount = 4
  for list_Idx = 0, viewCount - 1 do
    _content[list_Idx].itemSlotBG0:SetShow(false)
    _content[list_Idx].itemSlotBG1:SetShow(false)
    _content[list_Idx].itemSlotBG2:SetShow(false)
    _content[list_Idx].selectSlotBG0:SetShow(false)
    _content[list_Idx].selectSlotBG1:SetShow(false)
    _content[list_Idx].selectSlotBG2:SetShow(false)
    _content[list_Idx].selectSlotBG3:SetShow(false)
    _content[list_Idx].selectSlotBG4:SetShow(false)
    _content[list_Idx].selectSlotBG5:SetShow(false)
    _baseReward[list_Idx][0]:SetShow(false)
    _baseReward[list_Idx][1]:SetShow(false)
    _baseReward[list_Idx][2]:SetShow(false)
    _selectReward[list_Idx][0]:SetShow(false)
    _selectReward[list_Idx][1]:SetShow(false)
    _selectReward[list_Idx][2]:SetShow(false)
    _selectReward[list_Idx][3]:SetShow(false)
    _selectReward[list_Idx][4]:SetShow(false)
    _selectReward[list_Idx][5]:SetShow(false)
    _content[list_Idx].BG:SetShow(false)
    _content[list_Idx].Title:SetShow(false)
    _content[list_Idx].Desc:SetShow(false)
    _content[list_Idx].Icon:SetShow(false)
    _content[list_Idx].normalText:SetShow(false)
    _content[list_Idx].selectText:SetShow(false)
    _content[list_Idx].rewardBG:SetShow(false)
    _content[list_Idx].contentComplete:SetShow(false)
  end
  local function rewardPositionSet()
    for list_Idx = 0, viewCount - 1 do
      Challenge_clearRewardSlot(list_Idx)
      Challenge_clearSlot(list_Idx)
      if 0 == _tapValue then
        challengeType = 1
      elseif 1 == _tapValue then
        challengeType = 2
      elseif 3 == _tapValue then
        challengeType = 3
      elseif 4 == _tapValue then
        if isGameTypeRussia() then
          challengeType = 7
        else
          challengeType = 4
        end
      elseif 5 == _tapValue then
        challengeType = 5
      end
      if 2 == _tapValue then
        challengeWrapper = ToClient_GetCompletedChallengeAt(list_Idx + _scrollIndex)
        if nil ~= challengeWrapper then
          baseCount = challengeWrapper:getBaseRewardCount()
        end
      elseif 5 == _tapValue then
        challengeWrapper = ToClient_GetChallengeRewardInfoWrapper(GetChallengeRewardFirstIndex(list_Idx + _scrollIndex))
        if nil ~= challengeWrapper then
          baseCount = challengeWrapper:getBaseRewardCount()
        end
      else
        challengeWrapper = ToClient_GetProgressChallengeAt(challengeType, list_Idx + _scrollIndex)
        if nil ~= challengeWrapper then
          baseCount = challengeWrapper:getBaseRewardCount()
        end
      end
      if baseCount > 3 then
        _content[list_Idx].itemSlotBG3:SetShow(true)
        _baseReward[list_Idx][3]:SetShow(true)
        _content[list_Idx].itemSlotBG0:SetSpanSize(180, 10)
        _content[list_Idx].itemSlotBG1:SetSpanSize(130, 10)
        _content[list_Idx].itemSlotBG2:SetSpanSize(80, 10)
        _content[list_Idx].itemSlotBG3:SetSpanSize(30, 10)
        _baseReward[list_Idx][0]:SetSpanSize(180, 10)
        _baseReward[list_Idx][1]:SetSpanSize(130, 10)
        _baseReward[list_Idx][2]:SetSpanSize(80, 10)
        _baseReward[list_Idx][3]:SetSpanSize(30, 10)
      else
        _content[list_Idx].itemSlotBG3:SetShow(false)
        _baseReward[list_Idx][3]:SetShow(false)
        _content[list_Idx].itemSlotBG0:SetSpanSize(180, 10)
        _content[list_Idx].itemSlotBG1:SetSpanSize(130, 10)
        _content[list_Idx].itemSlotBG2:SetSpanSize(80, 10)
        _content[list_Idx].itemSlotBG3:SetSpanSize(30, 10)
        _baseReward[list_Idx][0]:SetSpanSize(180, 10)
        _baseReward[list_Idx][1]:SetSpanSize(130, 10)
        _baseReward[list_Idx][2]:SetSpanSize(80, 10)
        _baseReward[list_Idx][3]:SetSpanSize(30, 10)
      end
      _content[list_Idx].itemSlotBG0:SetShow(true)
      _content[list_Idx].itemSlotBG1:SetShow(true)
      _content[list_Idx].itemSlotBG2:SetShow(true)
      _content[list_Idx].selectSlotBG0:SetShow(true)
      _content[list_Idx].selectSlotBG1:SetShow(true)
      _content[list_Idx].selectSlotBG2:SetShow(true)
      _content[list_Idx].selectSlotBG3:SetShow(true)
      _content[list_Idx].selectSlotBG4:SetShow(true)
      _content[list_Idx].selectSlotBG5:SetShow(true)
      _baseReward[list_Idx][0]:SetShow(true)
      _baseReward[list_Idx][1]:SetShow(true)
      _baseReward[list_Idx][2]:SetShow(true)
      _selectReward[list_Idx][0]:SetShow(true)
      _selectReward[list_Idx][1]:SetShow(true)
      _selectReward[list_Idx][2]:SetShow(true)
      _selectReward[list_Idx][3]:SetShow(true)
      _selectReward[list_Idx][4]:SetShow(true)
      _selectReward[list_Idx][5]:SetShow(true)
      _content[list_Idx].BG:ChangeTextureInfoName("renewal/pcremaster/remaster_common_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(_content[list_Idx].BG, 106, 1, 126, 21)
      _content[list_Idx].BG:getBaseTexture():setUV(x1, y1, x2, y2)
      _content[list_Idx].BG:setRenderTexture(_content[list_Idx].BG:getBaseTexture())
      _content[list_Idx].BG:SetIgnore(false)
    end
  end
  rewardPositionSet()
  for i = 0, tapCount - 1 do
    if true == _tapMenu[i]:IsChecked() then
      _tapMenu[i]:SetFontColor(UI_color.C_FFFFFFFF)
    else
      _tapMenu[i]:SetFontColor(UI_color.C_FF888888)
    end
  end
  if 2 ~= _tapValue and 5 ~= _tapValue then
    if 0 == _tapValue then
      challengeType = 1
    elseif 1 == _tapValue then
      challengeType = 2
    elseif 3 == _tapValue then
      challengeType = 3
    elseif 4 == _tapValue then
      if isGameTypeRussia() then
        challengeType = 7
      else
        challengeType = 4
      end
    elseif 5 == _tapValue then
      challengeType = 5
    end
    controlValueCount = ToClient_GetProgressChallengeCount(challengeType)
    UIScroll.SetButtonSize(_scroll, controlCount, controlValueCount)
    if controlValueCount > 0 then
      if controlValueCount < controlCount then
        _count = controlValueCount
      else
        _count = controlCount
      end
      local uiIdx = 0
      for i = 0, _count - 1 do
        local dataIdx = i + _scrollIndex
        local progressInfo = ToClient_GetProgressChallengeAt(challengeType, dataIdx)
        if nil ~= progressInfo then
          _content[uiIdx].Title:SetTextMode(CppEnums.TextMode.eTextMode_None)
          _content[uiIdx].Title:SetText(progressInfo:getName())
          _content[uiIdx].Desc:SetText(progressInfo:getDesc())
          _content[uiIdx].BG:SetShow(true)
          _content[uiIdx].Title:SetShow(true)
          _content[uiIdx].Desc:SetShow(true)
          _content[uiIdx].Icon:SetShow(false)
          _content[uiIdx].Icon:ChangeTextureInfoName("new_ui_common_forlua/window/itemmarket/itemmarket_00.dds")
          local x1, y1, x2, y2 = setTextureUV_Func(_content[uiIdx].Icon, 1, 386, 104, 481)
          _content[uiIdx].Icon:getBaseTexture():setUV(x1, y1, x2, y2)
          _content[uiIdx].Icon:setRenderTexture(_content[uiIdx].Icon:getBaseTexture())
          _content[uiIdx].normalText:SetShow(true)
          _content[uiIdx].selectText:SetShow(true)
          _content[uiIdx].rewardBG:SetShow(true)
          ChallengeReward_Update(progressInfo, dataIdx, uiIdx)
          _content[uiIdx].contentComplete:SetShow(false)
          uiIdx = uiIdx + 1
        end
      end
    end
  elseif 2 == _tapValue then
    controlValueCount = totalCompleteCount
    UIScroll.SetButtonSize(_scroll, controlCount, controlValueCount)
    if controlValueCount > 0 then
      if controlValueCount < controlCount then
        _count = controlValueCount
      else
        _count = controlCount
      end
      local viewCount = 4
      for challenge_Idx = 0, controlValueCount - 1 do
        local completeInfo = ToClient_GetCompletedChallengeAt(challenge_Idx + _scrollIndex)
        _content[challenge_Idx].Title:SetText(completeInfo:getName())
        UI.setLimitTextAndAddTooltip(_content[challenge_Idx].Title)
        _content[challenge_Idx].Desc:SetText(completeInfo:getDesc())
        _content[challenge_Idx].BG:SetShow(true)
        _content[challenge_Idx].Title:SetShow(true)
        _content[challenge_Idx].Desc:SetShow(true)
        local existRewardCount = completeInfo:getExistRewardCount()
        _content[challenge_Idx].btnGetReward:SetMonoTone(true)
        _content[challenge_Idx].btnGetReward:SetIgnore(true)
        _content[challenge_Idx].BG:ChangeTextureInfoName("renewal/pcremaster/remaster_common_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(_content[challenge_Idx].BG, 106, 1, 127, 21)
        _content[challenge_Idx].BG:getBaseTexture():setUV(x1, y1, x2, y2)
        _content[challenge_Idx].BG:setRenderTexture(_content[challenge_Idx].BG:getBaseTexture())
        _content[challenge_Idx].btnGetReward:SetShow(false)
        _content[challenge_Idx].contentComplete:SetShow(true)
        _content[challenge_Idx].normalText:SetShow(false)
        _content[challenge_Idx].selectText:SetShow(false)
        _content[challenge_Idx].rewardBG:SetShow(true)
        _content[challenge_Idx].BG:SetIgnore(true)
        ChallengeReward_Update(completeInfo, challenge_Idx + _scrollIndex, challenge_Idx)
        if challenge_Idx == viewCount - 1 then
          return
        end
      end
    end
  elseif 5 == _tapValue then
    controlValueCount = GetChallengeRewardGroupCount()
    UIScroll.SetButtonSize(_scroll, controlCount, controlValueCount)
    if controlValueCount > 0 then
      if controlValueCount < controlCount then
        _count = controlValueCount
      else
        _count = controlCount
      end
      if maxCount > 4 and 1 == maxCount - controlValueCount then
        if controlValueCount < _scrollIndex + 4 then
          _scrollIndex = math.max(0, _scrollIndex - 1)
          rewardPositionSet()
        end
        _scroll:SetControlPos(_scrollIndex / (controlValueCount - 4))
      end
      maxCount = controlValueCount
      local viewCount = 4
      for challenge_Idx = 0, controlValueCount - 1 do
        local firstIndex = GetChallengeRewardFirstIndex(challenge_Idx + _scrollIndex)
        local rewardWrapper = ToClient_GetChallengeRewardInfoWrapper(firstIndex)
        if nil ~= rewardWrapper then
          _content[challenge_Idx].Title:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
          _content[challenge_Idx].Title:SetText(rewardWrapper:getName())
          _content[challenge_Idx].Desc:SetText(rewardWrapper:getDesc())
          _content[challenge_Idx].BG:SetShow(true)
          _content[challenge_Idx].Title:SetShow(true)
          _content[challenge_Idx].Desc:SetShow(true)
          local existRewardCount
          if 0 == rewardWrapper:getOptionalType() then
            existRewardCount = rewardWrapper:getRewardCount()
          else
            existRewardCount = ToClient_GetChallengeRewardCountByOptionalType(rewardWrapper:getOptionalType())
          end
          if existRewardCount > 0 then
            _content[challenge_Idx].contentComplete:SetShow(false)
            _content[challenge_Idx].normalText:SetShow(true)
            _content[challenge_Idx].selectText:SetShow(true)
            _content[challenge_Idx].rewardBG:SetShow(true)
            _content[challenge_Idx].btnGetReward:SetShow(true)
            _content[challenge_Idx].btnGetReward:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHALLENGE_BTNGETREWARD", "existRewardCount", existRewardCount))
            _content[challenge_Idx].btnGetReward:addInputEvent("Mouse_LUp", "HandleClicked_Reward_Show( " .. firstIndex .. ", " .. _scrollIndex .. " )")
            _content[challenge_Idx].BG:SetIgnore(false)
            local isAcceptAbleReward = rewardWrapper:isAcceptAbleReward()
            if isAcceptAbleReward then
              _content[challenge_Idx].btnGetReward:SetMonoTone(false)
              _content[challenge_Idx].btnGetReward:SetIgnore(false)
            else
              _content[challenge_Idx].btnGetReward:SetMonoTone(true)
            end
          else
          end
          ChallengeReward_Update(rewardWrapper, firstIndex, challenge_Idx)
          if challenge_Idx == viewCount - 1 then
            return
          end
        end
      end
    end
  end
end
function HandleClicked_Challenge_ProgressReward(index)
  if nil == Panel_Window_Challenge then
    return
  end
  local progressInfo = ToClient_GetProgressChallengeAt(index)
  ChallengeReward_Update(progressInfo, index, index)
end
function HandleClicked_Challenge_CompleteReward(completeInfo, index)
  if nil == Panel_Window_Challenge then
    return
  end
  local completeInfo = ToClient_GetChallengeRewardInfoWrapper(index)
  ChallengeReward_Update(completeInfo, index, index)
end
function HandleClicked_Reward_Show(challenge_Idx, selectIndex)
  if nil == Panel_Window_Challenge then
    return
  end
  local selectedRewardSlotIndex = _selectedReward_SlotIndex
  local challengeWrapper = ToClient_GetChallengeRewardInfoWrapper(challenge_Idx)
  local selectRewardCount = challengeWrapper:getSelectRewardCount()
  if 0 ~= selectRewardCount and nil == selectedRewardSlotIndex then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_YOUCANSELECTITEM"))
    return
  end
  if nil == challengeWrapper then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_WRONGINFOCHALLENGE"))
    return
  end
  if 0 ~= selectRewardCount and selectedRewardSlotIndex > selectRewardCount - 1 then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_WRONGSELECTVALUE"))
    return
  end
  if _selectedReward_ChallengeIndex ~= challenge_Idx and 0 ~= selectRewardCount then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_WRONGSELECTVALUE"))
    return
  end
  if 0 == selectRewardCount or nil == selectedRewardSlotIndex then
    selectedRewardSlotIndex = selectRewardCount
  end
  local challengeKey = challengeWrapper:getKey()
  ToClient_AcceptReward_ButtonClicked(challengeKey, selectedRewardSlotIndex)
  for ui_idx = 0, controlCount - 1 do
    for idx = 0, _maxSelectSlotCount - 1 do
      _listSelectRewardSlots[ui_idx][idx].selectedSatic:SetShow(false)
    end
  end
  local remainRewardCount = ToClient_GetChallengeRewardInfoCount()
  if 1 == remainRewardCount - _scrollIndex then
    _scroll:SetControlTop()
    _scrollIndex = 0
  end
end
function ChallengeReward_Update(challengeWrapper, challenge_Idx, uiIdx)
  if nil == challengeWrapper then
    return
  end
  local baseCount = challengeWrapper:getBaseRewardCount()
  local _baseReward = {}
  for idx = 1, baseCount do
    local baseReward = challengeWrapper:getBaseRewardAt(idx - 1)
    _baseReward[idx] = {}
    _baseReward[idx]._type = baseReward._type
    if __eRewardExp == baseReward._type then
      _baseReward[idx]._exp = baseReward._experience
    elseif __eRewardSkillExp == baseReward._type then
      _baseReward[idx]._exp = baseReward._skillExperience
    elseif __eRewardLifeExp == baseReward._type then
      _baseReward[idx]._exp = baseReward._productExperience
    elseif __eRewardItem == baseReward._type then
      _baseReward[idx]._item = baseReward:getItemEnchantKey()
      _baseReward[idx]._count = baseReward._itemCount
    elseif __eRewardIntimacy == baseReward._type then
      _baseReward[idx]._character = baseReward:getIntimacyCharacter()
      _baseReward[idx]._value = baseReward._intimacyValue
    end
  end
  local selectCount = challengeWrapper:getSelectRewardCount()
  local _selectReward = {}
  if selectCount > 0 then
    for idx = 1, selectCount do
      local selectReward = challengeWrapper:getSelectRewardAt(idx - 1)
      _selectReward[idx] = {}
      _selectReward[idx]._type = selectReward._type
      if __eRewardExp == selectReward._type then
        _selectReward[idx]._exp = selectReward._experience
      elseif __eRewardSkillExp == selectReward._type then
        _selectReward[idx]._exp = selectReward._skillExperience
      elseif __eRewardLifeExp == selectReward._type then
        _selectReward[idx]._exp = selectReward._productExperience
      elseif __eRewardItem == selectReward._type then
        _selectReward[idx]._item = selectReward:getItemEnchantKey()
        _selectReward[idx]._count = selectReward._itemCount
        local selfPlayer = getSelfPlayer()
        if nil ~= selfPlayer then
          local classType = selfPlayer:getClassType()
          _selectReward[idx]._isEquipable = selectReward:isEquipable(classType)
        end
      elseif __eRewardIntimacy == selectReward._type then
        _selectReward[idx]._character = selectReward:getIntimacyCharacter()
        _selectReward[idx]._value = selectReward._intimacyValue
      end
    end
  end
  SetChallengeRewardList(_baseReward, _selectReward, challenge_Idx, uiIdx)
end
function SetChallengeRewardList(baseReward, selectReward, challenge_Idx, uiIdx)
  if nil == Panel_Window_Challenge then
    return
  end
  _baseRewardCount = #baseReward
  for ii = 0, _maxBaseSlotCount - 1 do
    _uiBackBaseReward[uiIdx][ii]:EraseAllEffect()
    if ii < _baseRewardCount then
      setChallengeRewardShow(_listBaseRewardSlots[uiIdx][ii], baseReward[ii + 1], uiIdx, ii, "main")
      _uiBackBaseReward[uiIdx][ii]:SetShow(true)
    else
      _uiBackBaseReward[uiIdx][ii]:SetShow(false)
    end
  end
  local _selectRewardCount = #selectReward
  for ii = 0, _maxSelectSlotCount - 1 do
    if ii < _selectRewardCount then
      setChallengeRewardShow(_listSelectRewardSlots[uiIdx][ii], selectReward[ii + 1], uiIdx, ii, "sub")
      _uiButtonSelectRewardSlots[uiIdx][ii]:SetShow(true)
      if _tapMenu[5]:IsCheck() then
        _listSelectRewardSlots[uiIdx][ii].icon:addInputEvent("Mouse_LUp", "_challengeSelectReward_Set( " .. challenge_Idx .. ", " .. uiIdx .. ", " .. ii .. " )")
      end
    else
      _uiButtonSelectRewardSlots[uiIdx][ii]:SetShow(false)
    end
  end
end
function _challengeSelectReward_Set(challenge_Idx, uiIdx, slot_Idx)
  if nil == Panel_Window_Challenge then
    return
  end
  _selectedReward_ChallengeIndex = challenge_Idx
  _selectedReward_SlotIndex = slot_Idx
  for ui_idx = 0, controlCount - 1 do
    for idx = 0, _maxSelectSlotCount - 1 do
      _listSelectRewardSlots[ui_idx][idx].selectedSatic:SetShow(false)
    end
  end
  _listSelectRewardSlots[uiIdx][slot_Idx].selectedSatic:SetShow(true)
  local challengeWrapper = ToClient_GetChallengeRewardInfoWrapper(challenge_Idx)
  local selectRewardCount = challengeWrapper:getSelectRewardCount()
  if 0 == selectRewardCount then
    _selectedReward_SlotIndex = 0
  end
end
function ChallengeRewardTooltip(type, show, questtype, index, uiIdx)
  if nil == Panel_Window_Challenge then
    return
  end
  if true == show then
    if "Exp" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP"))
    elseif "SkillExp" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP"))
    elseif "ProductExp" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_PRODUCTEXP"))
    elseif "Intimacy" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_INTIMACY"))
    end
    if "main" == questtype then
      expTooltip:SetPosX(_uiBackBaseReward[uiIdx][index]:GetPosX() - expTooltip:GetSizeX() / 2)
      expTooltip:SetPosY(_uiBackBaseReward[uiIdx][index]:GetPosY() - expTooltip:GetSizeY() - 10)
    else
      expTooltip:SetPosX(_uiButtonSelectRewardSlots[uiIdx][index]:GetPosX() - expTooltip:GetSizeX() / 2)
      expTooltip:SetPosY(_uiButtonSelectRewardSlots[uiIdx][index]:GetPosY() - expTooltip:GetSizeY())
    end
    registTooltipControl(expTooltip, Panel_CheckedQuest)
    expTooltip:SetShow(true)
  else
    expTooltip:SetShow(false)
  end
end
function setChallengeRewardShow(uiSlot, reward, uiIdx, index, questType)
  if nil == Panel_Window_Challenge then
    return
  end
  uiSlot._type = reward._type
  if __eRewardExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "ChallengeRewardTooltip( \"Exp\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "ChallengeRewardTooltip( \"Exp\", false, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )")
    uiSlot.icon:setTooltipEventRegistFunc("ChallengeRewardTooltip( \"Exp\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )")
  elseif __eRewardSkillExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "ChallengeRewardTooltip( \"SkillExp\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "ChallengeRewardTooltip( \"SkillExp\", false, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )")
    uiSlot.icon:setTooltipEventRegistFunc("ChallengeRewardTooltip( \"SkillExp\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )")
  elseif __eRewardLifeExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "ChallengeRewardTooltip( \"ProductExp\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "ChallengeRewardTooltip( \"ProductExp\", false, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )")
    uiSlot.icon:setTooltipEventRegistFunc("ChallengeRewardTooltip( \"ProductExp\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )")
  elseif __eRewardItem == reward._type then
    local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(reward._item))
    uiSlot:setItemByStaticStatus(itemStatic, reward._count)
    uiSlot._item = reward._item
    if "main" == questType then
      uiSlot.icon:addInputEvent("Mouse_On", "Challenge_RewardTooltipShow( true, " .. uiIdx .. ", " .. index .. ", \"" .. questType .. "\" )")
      uiSlot.icon:addInputEvent("Mouse_Out", "Challenge_RewardTooltipShow( false, " .. uiIdx .. ", " .. index .. ", \"" .. questType .. "\" )")
      uiSlot.icon:setTooltipEventRegistFunc("Challenge_RewardTooltipShow( true, " .. uiIdx .. ", " .. index .. ", \"" .. questType .. "\" )")
    else
      uiSlot.icon:addInputEvent("Mouse_On", "Challenge_RewardTooltipShow( true, " .. uiIdx .. ", " .. index .. ", \"" .. questType .. "\" )")
      uiSlot.icon:addInputEvent("Mouse_Out", "Challenge_RewardTooltipShow( false, " .. uiIdx .. ", " .. index .. ", \"" .. questType .. "\" )")
      uiSlot.icon:setTooltipEventRegistFunc("Challenge_RewardTooltipShow( true, " .. uiIdx .. ", " .. index .. ", \"" .. questType .. "\" )")
    end
    return reward._isEquipable
  elseif __eRewardIntimacy == reward._type then
    uiSlot.count:SetText(tostring(reward._value))
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "ChallengeRewardTooltip( \"Intimacy\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "ChallengeRewardTooltip( \"Intimacy\", false, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )")
    uiSlot.icon:setTooltipEventRegistFunc("ChallengeRewardTooltip( \"Intimacy\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )")
  else
    uiSlot.icon:addInputEvent("Mouse_On", "")
    uiSlot.icon:addInputEvent("Mouse_Out", "")
  end
  return false
end
function Challenge_Scroll(isUp)
  if nil == Panel_Window_Challenge then
    return
  end
  _scrollIndex = UIScroll.ScrollEvent(_scroll, isUp, controlCount, controlValueCount, _scrollIndex, 1)
  Challenge_Update()
  for ui_idx = 0, controlCount - 1 do
    for idx = 0, _maxSelectSlotCount - 1 do
      _listSelectRewardSlots[ui_idx][idx].selectedSatic:SetShow(false)
    end
  end
end
function Challenge_RewardTooltipShow(isShow, uiIdx, slotNo, rewardType)
  if nil == Panel_Window_Challenge then
    return
  end
  local passTooltipType, uiSlot
  if "main" == rewardType then
    passTooltipType = "Dialog_ChallengeReward_Base"
    uiSlot = _listBaseRewardSlots[uiIdx][slotNo]
  else
    passTooltipType = "Dialog_ChallengeReward_Select"
    uiSlot = _listSelectRewardSlots[uiIdx][slotNo]
  end
  Panel_Tooltip_Item_SetPosition(slotNo, uiSlot, passTooltipType)
  if true == isShow then
    Panel_Tooltip_Item_Show_GeneralStatic(slotNo, passTooltipType, true)
  elseif false == isShow then
    Panel_Tooltip_Item_hideTooltip()
  end
end
function FromClient_ChallengeReward_UpdateText()
  Challenge_Update()
end
function PaGlobalFunc_Challenge_GetTotalRemainRewardCount()
  local remainRewardGroupCount = GetChallengeRewardGroupCount()
  local count = 0
  for index = 0, remainRewardGroupCount - 1 do
    local firstIndex = GetChallengeRewardFirstIndex(index)
    local rewardWrapper = ToClient_GetChallengeRewardInfoWrapper(firstIndex)
    if 0 == rewardWrapper:getOptionalType() then
      count = count + rewardWrapper:getRewardCount()
    else
      count = count + ToClient_GetChallengeRewardCountByOptionalType(rewardWrapper:getOptionalType())
    end
  end
  return count
end
local function initializeChallengeInfo()
  if nil == Panel_Window_Challenge then
    return
  end
  _tapMenu = {}
  _tapIcon = {}
  _tapValue = 0
  maxCount = 0
  _selectedReward_ChallengeIndex = nil
  _selectedReward_SlotIndex = nil
  radioBtn_TapMenu = nil
  tapPosX = nil
  tapSizeX = nil
  _content = {}
  _baseReward = {}
  _selectReward = {}
  controlCount = 4
  isInitChallenge = false
  _uiBackBaseReward = {}
  _listBaseRewardSlots = {}
  _uiButtonSelectRewardSlots = {}
  _listSelectRewardSlots = {}
  Panel_Window_Challenge:SetShow(false)
  shortClearCount = UI.getChildControl(Panel_Window_Challenge, "StaticText_ShortClearCount_Value")
  dailyChallengeValue = UI.getChildControl(Panel_Window_Challenge, "StaticText_DailyChallenge_Value")
  clearCountText = UI.getChildControl(Panel_Window_Challenge, "StaticText_ClearCountText")
  clearCountValue = UI.getChildControl(Panel_Window_Challenge, "StaticText_ClearCountValue")
  remainRewardCountValue = UI.getChildControl(Panel_Window_Challenge, "StaticText_RemailRewardCount")
  btnRewardShow = UI.getChildControl(Panel_Window_Challenge, "Button_ChallengeReward_Show")
  contentBody = UI.getChildControl(Panel_Window_Challenge, "Static_CallengeBodyBG")
  contentBG = UI.getChildControl(Panel_Window_Challenge, "Static_ChallengeContent_BG")
  contentTitle = UI.getChildControl(Panel_Window_Challenge, "StaticText_ChallengeContent_Title")
  contentDesc = UI.getChildControl(Panel_Window_Challenge, "StaticText_ChallengeContent_Desc")
  contentIcon = UI.getChildControl(Panel_Window_Challenge, "Static_ChallengeContent_Icon")
  contentComplete = UI.getChildControl(Panel_Window_Challenge, "StaticText_ChallengeCompleteIcon")
  normalText = UI.getChildControl(Panel_Window_Challenge, "StaticText_NormalReward")
  selectText = UI.getChildControl(Panel_Window_Challenge, "StaticText_SelectReward")
  rewardBG = UI.getChildControl(Panel_Window_Challenge, "Static_RewardBG")
  itemSlotBG0 = UI.getChildControl(Panel_Window_Challenge, "Static_ResultSlot0")
  itemSlotBG1 = UI.getChildControl(Panel_Window_Challenge, "Static_ResultSlot1")
  itemSlotBG2 = UI.getChildControl(Panel_Window_Challenge, "Static_ResultSlot2")
  itemSlotBG3 = UI.getChildControl(Panel_Window_Challenge, "Static_ResultSlot3")
  itemIcon0 = UI.getChildControl(Panel_Window_Challenge, "Static_SlotIcon0")
  itemIcon1 = UI.getChildControl(Panel_Window_Challenge, "Static_SlotIcon1")
  itemIcon2 = UI.getChildControl(Panel_Window_Challenge, "Static_SlotIcon2")
  itemIcon3 = UI.getChildControl(Panel_Window_Challenge, "Static_SlotIcon3")
  selectSlotBG0 = UI.getChildControl(Panel_Window_Challenge, "Static_SelectSlot0")
  selectSlotBG1 = UI.getChildControl(Panel_Window_Challenge, "Static_SelectSlot1")
  selectSlotBG2 = UI.getChildControl(Panel_Window_Challenge, "Static_SelectSlot2")
  selectSlotBG3 = UI.getChildControl(Panel_Window_Challenge, "Static_SelectSlot3")
  selectSlotBG4 = UI.getChildControl(Panel_Window_Challenge, "Static_SelectSlot4")
  selectSlotBG5 = UI.getChildControl(Panel_Window_Challenge, "Static_SelectSlot5")
  selectSlotBGCover = UI.getChildControl(Panel_Window_Challenge, "Template_Static_SlotSelectBG")
  selectItemIcon0 = UI.getChildControl(Panel_Window_Challenge, "Static_SelectItemIcon0")
  selectItemIcon1 = UI.getChildControl(Panel_Window_Challenge, "Static_SelectItemIcon1")
  selectItemIcon2 = UI.getChildControl(Panel_Window_Challenge, "Static_SelectItemIcon2")
  selectItemIcon3 = UI.getChildControl(Panel_Window_Challenge, "Static_SelectItemIcon3")
  selectItemIcon4 = UI.getChildControl(Panel_Window_Challenge, "Static_SelectItemIcon4")
  selectItemIcon5 = UI.getChildControl(Panel_Window_Challenge, "Static_SelectItemIcon5")
  explainBG = UI.getChildControl(Panel_Window_Challenge, "Static_ChallengeExplainBG")
  _scroll = UI.getChildControl(Panel_Window_Challenge, "VerticalScroll")
  _scrollCtrlBtn = UI.getChildControl(_scroll, "VerticalScroll_CtrlButton")
  radioBtn_TapMenu = UI.getChildControl(Panel_Window_Challenge, "RadioButton_Tap")
  tapPosX = radioBtn_TapMenu:GetPosX()
  tapSizeX = radioBtn_TapMenu:GetSizeX()
  createExpTooltip()
end
local registMessageHandler = function()
  registerEvent("FromClient_ChallengeReward_UpdateText", "FromClient_ChallengeReward_UpdateText")
end
local function registEventHandler()
  if nil == Panel_Window_Challenge then
    return
  end
  UIScroll.InputEvent(_scroll, "Challenge_Scroll")
  contentBody:addInputEvent("Mouse_UpScroll", "Challenge_Scroll( true )")
  contentBody:addInputEvent("Mouse_DownScroll", "Challenge_Scroll( false )")
end
function FromClient_CharacterInfoChallenge_Init()
  PaGlobal_CharacterInfoChallenge_Init()
  registMessageHandler()
end
function PaGlobal_CharacterInfoChallenge_Init()
  initializeChallengeInfo()
  Challenge_Initialize()
  Challenge_TapMenu_Create()
  registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_CharacterInfoChallenge_Init")
