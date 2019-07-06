local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
function PaGlobal_GuideMessage:initialize()
  if true == PaGlobal_GuideMessage._initialize then
    return
  end
  PaGlobal_GuideMessage._ui._static_State1BG = UI.getChildControl(Instance_Widget_GuideMessage, "Static_State1BG")
  PaGlobal_GuideMessage._ui._static_State2BG = UI.getChildControl(Instance_Widget_GuideMessage, "Static_State2BG")
  PaGlobal_GuideMessage._isStart = false
  PaGlobal_GuideMessage:registEventHandler()
  PaGlobal_GuideMessage:validate()
  PaGlobal_GuideMessage._initialize = true
end
function PaGlobal_GuideMessage:registEventHandler()
  if nil == Instance_Widget_GuideMessage then
    return
  end
  registerEvent("FromClient_BattleRoyaleStateChanged", "FromClient_GuideMessage_BattleRoyaleStateChanged")
  registerEvent("FromClient_ClassChangeBattleRoyale", "FromClient_GuideMessage_ClassChangeBattleRoyale")
end
function PaGlobal_GuideMessage:prepareOpen()
end
function PaGlobal_GuideMessage:open()
  if nil == Instance_Widget_GuideMessage then
    return
  end
  Instance_Widget_GuideMessage:SetShow(true)
end
function PaGlobal_GuideMessage:prepareClose()
end
function PaGlobal_GuideMessage:close()
  if nil == Instance_Widget_GuideMessage then
    return
  end
  Instance_Widget_GuideMessage:SetShow(false)
end
function PaGlobal_GuideMessage:update()
end
function PaGlobal_GuideMessage:validate()
  if nil == Instance_Widget_GuideMessage then
    return
  end
  PaGlobal_GuideMessage._ui._static_State1BG:isValidate()
  PaGlobal_GuideMessage._ui._static_State2BG:isValidate()
end
function PaGlobal_GuideMessage:startTimer()
  if true == PaGlobal_GuideMessage._isStart then
    return
  end
  if false == PaGlobal_GuideMessage:isCheckShowGuide() then
    return
  end
  PaGlobal_GuideMessage._currentTime = 0
  PaGlobal_GuideMessage._currentState = PaGlobal_GuideMessage._eState._non
  Instance_Widget_GuideMessage:RegisterUpdateFunc("PaGlobal_GuideMessage_UpdatePerFrame")
  PaGlobal_GuideMessage._isStart = true
  PaGlobal_GuideMessage:open()
end
function PaGlobal_GuideMessage:endTimer()
  Instance_Widget_GuideMessage:ClearUpdateLuaFunc()
end
function PaGlobal_GuideMessage:updateTimer(deltaTime)
  PaGlobal_GuideMessage._currentTime = PaGlobal_GuideMessage._currentTime + deltaTime
end
function PaGlobal_GuideMessage:updateCheckCurrentState()
  if PaGlobal_GuideMessage._eState._non == PaGlobal_GuideMessage._currentState then
    if PaGlobal_GuideMessage._STATE1_START_TIME < PaGlobal_GuideMessage._currentTime then
      PaGlobal_GuideMessage:startStateOne()
    end
    return
  end
  if PaGlobal_GuideMessage._eState._state1Ing == PaGlobal_GuideMessage._currentState then
    if PaGlobal_GuideMessage._STATE1_END_TIME < PaGlobal_GuideMessage._currentTime then
      PaGlobal_GuideMessage:endStateOne()
    end
    return
  end
  if PaGlobal_GuideMessage._eState._state1End == PaGlobal_GuideMessage._currentState then
    if PaGlobal_GuideMessage._STATE2_START_TIME < PaGlobal_GuideMessage._currentTime then
      PaGlobal_GuideMessage:startStateTwo()
    end
    return
  end
end
function PaGlobal_GuideMessage:startStateOne()
  PaGlobal_GuideMessage._ui._static_State1BG:SetShow(true)
  local ImageAni = PaGlobal_GuideMessage._ui._static_State1BG:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageAni:SetStartColor(Defines.Color.C_00FFFFFF)
  ImageAni:SetEndColor(Defines.Color.C_FFFFFFFF)
  ImageAni.IsChangeChild = true
  PaGlobal_GuideMessage._currentState = PaGlobal_GuideMessage._eState._state1Ing
end
function PaGlobal_GuideMessage:endStateOne()
  local ImageAni = PaGlobal_GuideMessage._ui._static_State1BG:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageAni:SetStartColor(Defines.Color.C_FFFFFFFF)
  ImageAni:SetEndColor(Defines.Color.C_00FFFFFF)
  ImageAni.IsChangeChild = true
  PaGlobal_GuideMessage._currentState = PaGlobal_GuideMessage._eState._state1End
end
function PaGlobal_GuideMessage:startStateTwo()
  PaGlobal_GuideMessage._ui._static_State2BG:SetShow(true)
  local ImageAni = PaGlobal_GuideMessage._ui._static_State2BG:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageAni:SetStartColor(Defines.Color.C_00FFFFFF)
  ImageAni:SetEndColor(Defines.Color.C_FFFFFFFF)
  ImageAni.IsChangeChild = true
  PaGlobal_GuideMessage._currentState = PaGlobal_GuideMessage._eState._state2Ing
  PaGlobal_GuideMessage:endTimer()
end
function PaGlobal_GuideMessage:endStateTwo()
  if false == PaGlobal_GuideMessage._isStart then
    return
  end
  local ImageAni = PaGlobal_GuideMessage._ui._static_State2BG:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageAni:SetStartColor(Defines.Color.C_FFFFFFFF)
  ImageAni:SetEndColor(Defines.Color.C_00FFFFFF)
  ImageAni.IsChangeChild = true
  PaGlobal_GuideMessage._currentState = PaGlobal_GuideMessage._eState._state2End
  PaGlobal_GuideMessage:close()
end
function PaGlobal_GuideMessage:isCheckShowGuide()
  local soloRate = PaGlobal_GuideMessage:getSoloScore()
  local teamRate = PaGlobal_GuideMessage:getTeamScore()
  local rate = soloRate + teamRate
  return rate <= toInt64(0, 0)
end
function PaGlobal_GuideMessage:getSoloScore()
  local score = toInt64(0, 0)
  if true == _ContentsGroup_Instance_Tier then
    score = ToClient_GetBattleRoyaleCurrentSeasonScore(__eBattleRoyaleMode_Solo)
    if nil == score then
      score = toInt64(0, 0)
    end
  else
    local season = ToClient_BattleRoyaleSeason()
    for i = 1, #PaGlobal_GuideMessage._classList do
      local wrapper = ToClient_UserBattleRoyaleRecordWrapper(__eBattleRoyaleMode_Solo, PaGlobal_GuideMessage._classList[i], season)
      if nil ~= wrapper then
        score = score + wrapper:getScore()
      end
    end
  end
  return score
end
function PaGlobal_GuideMessage:getTeamScore()
  local score = toInt64(0, 0)
  if true == _ContentsGroup_Instance_Tier then
    score = ToClient_GetBattleRoyaleCurrentSeasonScore(__eBattleRoyaleMode_Team)
    if nil == score then
      score = toInt64(0, 0)
    end
  else
    local season = ToClient_BattleRoyaleSeason()
    for i = 1, #PaGlobal_GuideMessage._classList do
      local wrapper = ToClient_UserBattleRoyaleRecordWrapper(__eBattleRoyaleMode_Team, PaGlobal_GuideMessage._classList[i], season)
      if nil ~= wrapper then
        score = score + wrapper:getScore()
      end
    end
  end
  return score
end
