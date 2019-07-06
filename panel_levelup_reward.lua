local _const = Defines.s64_const
local UI_color = Defines.Color
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local _lvupTitle = UI.getChildControl(Panel_Levelup_Reward, "StaticText_LeveupTitle")
local _stminaupTitle = UI.getChildControl(Panel_Levelup_Reward, "StaticText_StaminaupTitle")
local _strengthupTitle = UI.getChildControl(Panel_Levelup_Reward, "StaticText_StrengthupTitle")
local _healthupTitle = UI.getChildControl(Panel_Levelup_Reward, "StaticText_HealthupTitle")
local _txt_lvupStatus = {}
local copyBaseCount = 4
local currTime = 0
local isFirstShow = true
local isUpdateList = {
  false,
  false,
  false,
  false
}
local GetBottomPos = function(control)
  if nil == control then
    return
  end
  return control:GetPosY() + control:GetSizeY()
end
function LevelUp_ShowStatus_Init()
  local _c_lvup_Status = UI.getChildControl(Panel_Levelup_Reward, "StaticText_Status_sample")
  for index = 1, copyBaseCount do
    local _lvup_Status = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Levelup_Reward, "StaticText_Status_" .. index)
    CopyBaseProperty(_c_lvup_Status, _lvup_Status)
    _lvup_Status:SetShow(false)
    _lvup_Status:SetAlpha(0)
    _txt_lvupStatus[index] = _lvup_Status
  end
  Panel_Levelup_Reward:RemoveControl(_c_lvup_Status)
end
local aniType = {
  staminaUp = 0,
  strengthUp = 1,
  healthUp = 2,
  levelUP = 3
}
local function Reward_AniFunc(_type)
  local endTime = {
    0.3,
    0.6,
    0.9,
    1.2
  }
  if aniType.levelUP == _type then
    chatting_sendMessage("", PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LEVELUP_REWARD_LEVELUP_TITLE"), CppEnums.ChatType.System)
    _lvupTitle:SetShow(true)
    _stminaupTitle:SetShow(false)
    _strengthupTitle:SetShow(false)
    _healthupTitle:SetShow(false)
  elseif aniType.staminaUp == _type then
    chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_STAMINAUP"), CppEnums.ChatType.System)
    _lvupTitle:SetShow(false)
    _stminaupTitle:SetShow(true)
    _strengthupTitle:SetShow(false)
    _healthupTitle:SetShow(false)
  elseif aniType.strengthUp == _type then
    chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_STRENGTHUP"), CppEnums.ChatType.System)
    _lvupTitle:SetShow(false)
    _stminaupTitle:SetShow(false)
    _strengthupTitle:SetShow(true)
    _healthupTitle:SetShow(false)
  elseif aniType.healthUp == _type then
    chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_HEALTHUP"), CppEnums.ChatType.System)
    _lvupTitle:SetShow(false)
    _stminaupTitle:SetShow(false)
    _strengthupTitle:SetShow(false)
    _healthupTitle:SetShow(true)
  end
  local isShow = false
  for index = 1, copyBaseCount do
    if isUpdateList[index] then
      _txt_lvupStatus[index]:SetShow(true)
      _txt_lvupStatus[index]:SetFontAlpha(0)
      _txt_lvupStatus[index]:SetAlpha(0)
      local statusAni1 = _txt_lvupStatus[index]:addColorAnimation(0, endTime[index], UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
      statusAni1:SetStartColor(UI_color.C_00FFFFFF)
      statusAni1:SetEndColor(UI_color.C_FFFFFFFF)
      statusAni1:SetStartIntensity(3)
      statusAni1:SetEndIntensity(1)
      _txt_lvupStatus[index]:AddEffect("UI_ButtonLineRight_Blue", false, -20, 0)
      chatting_sendMessage("", _txt_lvupStatus[index]:GetText(), CppEnums.ChatType.System)
      isShow = true
    else
      _txt_lvupStatus[index]:SetShow(false)
      _txt_lvupStatus[index]:SetFontAlpha(0)
      _txt_lvupStatus[index]:SetAlpha(0)
    end
  end
  Panel_Levelup_Reward:SetShow(isShow)
end
local positionY = GetBottomPos(_lvupTitle)
local posY_gab = 5
function LevelUp_Update_ShowFunction(deltaTime)
  currTime = currTime + deltaTime
  if currTime > 5 and Panel_Levelup_Reward:IsShow() == true then
    currTime = 0
    local levelUP_Reward_Hide = UIAni.AlphaAnimation(0, Panel_Levelup_Reward, 0, 0.6)
    levelUP_Reward_Hide:SetHideAtEnd(true)
  end
end
function ToClient_SelfPlayerLevelUp(hp, mp, stun, weight)
  local playerWrapper = getSelfPlayer()
  local classType = playerWrapper:getClassType()
  local positionY = GetBottomPos(_lvupTitle)
  if hp > 0 then
    _txt_lvupStatus[1]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXHPUP") .. "<PAColor0xFFFFBD2E>+" .. hp .. "<PAOldColor>")
    _txt_lvupStatus[1]:SetPosY(25)
    positionY = GetBottomPos(_txt_lvupStatus[1])
    isUpdateList[1] = true
  else
    isUpdateList[1] = false
  end
  if mp > 0 then
    if classType == 0 then
      _txt_lvupStatus[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXFPUP") .. "<PAColor0xFFFFBD2E>+" .. mp .. "<PAOldColor>")
    elseif classType == 4 then
      _txt_lvupStatus[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXMPUP") .. "<PAColor0xFFFFBD2E>+" .. mp .. "<PAOldColor>")
    elseif classType == 8 then
      _txt_lvupStatus[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXMPUP") .. "<PAColor0xFFFFBD2E>+" .. mp .. "<PAOldColor>")
    elseif classType == 12 then
      _txt_lvupStatus[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXFPUP") .. "<PAColor0xFFFFBD2E>+" .. mp .. "<PAOldColor>")
    else
      _txt_lvupStatus[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXMPUP") .. "<PAColor0xFFFFBD2E>+" .. mp .. "<PAOldColor>")
    end
    _txt_lvupStatus[2]:SetPosY(positionY + posY_gab)
    positionY = GetBottomPos(_txt_lvupStatus[2])
    isUpdateList[2] = true
  else
    isUpdateList[2] = false
  end
  isUpdateList[3] = false
  if weight > Defines.s64_const.s64_0 then
    _txt_lvupStatus[4]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXWEIGHTUP") .. "<PAColor0xFFFFBD2E>+" .. Int64toInt32(weight) / 10000 .. "<PAOldColor>")
    _txt_lvupStatus[4]:SetPosY(positionY + posY_gab)
    positionY = GetBottomPos(_txt_lvupStatus[4])
    isUpdateList[4] = true
  else
    isUpdateList[4] = false
  end
  Reward_AniFunc(aniType.levelUP)
  if false == _ContentsGroup_RenewUI_Skill then
    enableSkill_UpdateData()
  end
  if 6 >= getSelfPlayer():get():getLevel() then
    SimpleUI_Check()
  end
end
LevelUp_ShowStatus_Init()
Panel_Levelup_Reward:RegisterUpdateFunc("LevelUp_Update_ShowFunction")
registerEvent("ToClient_SelfPlayerLevelUp", "ToClient_SelfPlayerLevelUp")
