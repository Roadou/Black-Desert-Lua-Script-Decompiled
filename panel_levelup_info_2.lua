function ToClient_SelfPlayerLevelUp_StatusDataSet(hp, mp, stun, weight)
  if false == _ContentsGroup_LevelupInfo then
    return
  end
  if nil == Panel_Levelup_Info then
    return
  end
  if nil == hp then
    UI_ASSERT_NAME(nil ~= hp, "hp\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\134", "\236\160\149\237\131\156\234\179\164")
  end
  if nil == mp then
    UI_ASSERT_NAME(nil ~= mp, "mp\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\134", "\236\160\149\237\131\156\234\179\164")
  end
  if nil == weight then
    UI_ASSERT_NAME(nil ~= weight, "weight\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\134", "\236\160\149\237\131\156\234\179\164")
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local isLevel = selfPlayer:get():getLevel()
  local isMyClassType = selfPlayer:getClassType()
  PaGlobal_LevelupInfo._ui._txt_titleLevel:SetText(tostring(isLevel))
  PaGlobal_LevelupInfo._ui._txt_titleLevel:EraseAllEffect()
  if mp > 0 then
    if __eClassType_ElfRanger == isMyClassType or __eClassType_RangerMan == isMyClassType then
      PaGlobal_LevelupInfo._ui._txt_maxMpTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXMPUP"))
    elseif isMyClassType == __eClassType_Warrior or isMyClassType == __eClassType_Giant or isMyClassType == __eClassType_Lhan or isMyClassType == __eClassType_Combattant or isMyClassType == __eClassType_Mystic or isMyClassType == __eClassType_BladeMaster or isMyClassType == __eClassType_BladeMasterWoman or isMyClassType == __eClassType_Kunoichi or isMyClassType == __eClassType_NinjaMan then
      PaGlobal_LevelupInfo._ui._txt_maxMpTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXFPUP"))
    elseif isMyClassType == __eClassType_Sorcerer or isMyClassType == __eClassType_WizardWoman or isMyClassType == __eClassType_WizardMan or isMyClassType == __eClassType_Tamer or isMyClassType == __eClassType_DarkElf then
      PaGlobal_LevelupInfo._ui._txt_maxMpTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXMPUP"))
    elseif __eClassType_Valkyrie == isMyClassType then
      PaGlobal_LevelupInfo._ui._txt_maxMpTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXBPUP"))
    else
      PaGlobal_LevelupInfo._ui._txt_maxMpTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXFPUP"))
    end
  end
  PaGlobal_LevelupInfo._ui._txt_maxHpValue:SetText(tostring(PaGlobal_LevelupInfo._maxHp))
  PaGlobal_LevelupInfo._ui._txt_increaseHpValue:SetText("+" .. tostring(PaGlobal_LevelupInfo._maxHp + hp))
  PaGlobal_LevelupInfo._ui._txt_increaseHpValue:SetFontColor(Defines.Color.C_FF00C0D7)
  PaGlobal_LevelupInfo._ui._txt_maxMpValue:SetText(tostring(PaGlobal_LevelupInfo._maxMp))
  PaGlobal_LevelupInfo._ui._txt_increaseMpValue:SetText("+" .. tostring(PaGlobal_LevelupInfo._maxMp + mp))
  PaGlobal_LevelupInfo._ui._txt_increaseMpValue:SetFontColor(Defines.Color.C_FF00C0D7)
  PaGlobal_LevelupInfo._ui._txt_weightValue:SetText(tostring(Int64toInt32(PaGlobal_LevelupInfo._maxWeight) / 10000))
  if weight > Defines.s64_const.s64_0 then
    PaGlobal_LevelupInfo._ui._txt_increaseWeightValue:SetText("+" .. tostring(Int64toInt32(PaGlobal_LevelupInfo._maxWeight + weight) / 10000) .. " LT")
    PaGlobal_LevelupInfo._ui._txt_increaseWeightValue:SetFontColor(Defines.Color.C_FF00C0D7)
  end
end
function FromClient_SelfPlayerCurrentLevelInfo(learnableSkillCount, learnSkillCount, hp, mp, stun, weight, lvdd, lvpv)
  if nil == Panel_Levelup_Info then
    return
  end
  if nil == learnSkillCount then
    UI_ASSERT_NAME(nil ~= learnSkillCount, "learnSkillCount\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\1341", "\236\160\149\237\131\156\234\179\164")
    return
  end
  if nil == learnableSkillCount then
    UI_ASSERT_NAME(nil ~= learnableSkillCount, "learnSkillCount\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\1341", "\236\160\149\237\131\156\234\179\164")
    return
  end
  if nil == hp then
    UI_ASSERT_NAME(nil ~= hp, "learnSkillCount\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\1341", "\236\160\149\237\131\156\234\179\164")
    return
  end
  if nil == mp then
    UI_ASSERT_NAME(nil ~= mp, "learnSkillCount\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\1341", "\236\160\149\237\131\156\234\179\164")
    return
  end
  if nil == weight then
    UI_ASSERT_NAME(nil ~= weight, "learnSkillCount\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\1341", "\236\160\149\237\131\156\234\179\164")
    return
  end
  if nil == lvdd then
    UI_ASSERT_NAME(nil ~= lvdd, "learnSkillCount\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\1341", "\236\160\149\237\131\156\234\179\164")
    return
  end
  if nil == lvpv then
    UI_ASSERT_NAME(nil ~= lvpv, "learnSkillCount\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\1341", "\236\160\149\237\131\156\234\179\164")
    return
  end
  PaGlobal_LevelupInfo:CurrentState()
  ToClient_SelfPlayerLevelUp_StatusDataSet(hp, mp, stun, weight)
  PaGlobal_LevelupInfo._ui._txt_learnSkillNoSkill:SetShow(false)
  PaGlobal_LevelupInfo._ui._txt_learnableSkillNoSkill:SetShow(false)
  PaGlobal_LevelupInfo._ui._frm_learnSkill:SetShow(false)
  PaGlobal_LevelupInfo._ui._frm_learnSkillContent:SetShow(false)
  PaGlobal_LevelupInfo._ui._frm_learnableSkill:SetShow(false)
  PaGlobal_LevelupInfo._ui._frm_learnableSkillContent:SetShow(false)
  PaGlobal_LevelupInfo._ui._frm_learnSkillScroll:SetShow(false)
  PaGlobal_LevelupInfo._ui._frm_learnableSkillScroll:SetShow(false)
  PaGlobal_LevelupInfo._ui._txt_learnSkillTitle:SetFontColor(Defines.Color.C_FFEE7001)
  PaGlobal_LevelupInfo._ui._txt_learnableSkillTitle:SetFontColor(Defines.Color.C_FFEE7001)
  PaGlobal_LevelupInfo_SkillClear(0)
  PaGlobal_LevelupInfo_SkillClear(1)
  if 0 == learnSkillCount then
    PaGlobal_LevelupInfo._ui._txt_learnSkillNoSkill:SetShow(true)
  end
  if 0 == learnableSkillCount then
    PaGlobal_LevelupInfo._ui._txt_learnableSkillNoSkill:SetShow(true)
  end
  if learnSkillCount > 3 then
    PaGlobal_LevelupInfo._ui._frm_learnSkillScroll:SetShow(true)
  end
  if learnableSkillCount > 3 then
    PaGlobal_LevelupInfo._ui._frm_learnableSkillScroll:SetShow(true)
  end
  if learnSkillCount > 0 then
    for i = 0, learnSkillCount - 1 do
      local learnSkillWrapper = ToClient_getCurrentLearnedSkill(i)
      if nil ~= learnSkillWrapper then
        local isKey = learnSkillWrapper:getKey()
        local isSkillNo = learnSkillWrapper:getSkillNo()
        local isSkillName = learnSkillWrapper:getName()
        PaGlobal_LevelupInfo_LearnSkillDataSet(isSkillNo, i)
      end
    end
    PaGlobal_LevelupInfo._ui._frm_learnSkill:SetShow(true)
    PaGlobal_LevelupInfo._ui._frm_learnSkillContent:SetShow(true)
  end
  if learnableSkillCount > 0 then
    for j = 0, learnableSkillCount - 1 do
      local learnableSkillWrapper = ToClient_getCurrentLearnableSkill(j)
      if nil ~= learnableSkillWrapper then
        local isKey = learnableSkillWrapper:getKey()
        local isSkillNo = learnableSkillWrapper:getSkillNo()
        local isSkillName = learnableSkillWrapper:getName()
        PaGlobal_LevelupInfo_LearnableSkillDataSet(isSkillNo, j)
      end
    end
    PaGlobal_LevelupInfo._ui._frm_learnableSkill:SetShow(true)
    PaGlobal_LevelupInfo._ui._frm_learnableSkillContent:SetShow(true)
  end
  Panel_Levelup_Info:ComputePos()
  PaGlobal_LevelupInfo_Open()
end
function PaGlobal_LevelupInfo_ShowAni()
  if nil == Panel_Levelup_Info then
    return
  end
end
function PaGlobal_LevelupInfo_HideAni()
  if nil == Panel_Levelup_Info then
    return
  end
end
function PaGlobal_LevelupInfo_Open()
  if false == _ContentsGroup_LevelupInfo then
    return
  end
  if nil == Panel_Levelup_Info then
    return
  end
  PaGlobal_LevelupInfo:CurrentState()
  PaGlobal_LevelupInfo:prepareOpen()
end
function PaGlobal_LevelupInfo_Close()
  if nil == Panel_Levelup_Info then
    return
  end
  PaGlobal_LevelupInfo:CurrentState()
  PaGlobal_LevelupInfo:prepareClose()
end
function PaGlobal_LevelupInfo_SkillClear(skillType)
  if false == _ContentsGroup_LevelupInfo then
    return
  end
  if nil == Panel_Levelup_Info then
    return
  end
  if 0 == skillType then
    for index, value in pairs(PaGlobal_LevelupInfo._skillBG) do
      value:SetShow(false)
    end
  elseif 1 == skillType then
    for index, value in pairs(PaGlobal_LevelupInfo._learnableSkillBG) do
      value:SetShow(false)
    end
  end
  Panel_Levelup_Info:SetSize(330, 525)
end
function PaGlobal_LevelupInfo_LearnSkillDataSet(skillNo, index)
  if nil == Panel_Levelup_Info then
    return
  end
  if nil == skillNo then
    UI_ASSERT_NAME(nil ~= skillNo, "skillNo\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\1341", "\236\160\149\237\131\156\234\179\164")
    return
  end
  PaGlobal_LevelupInfo._ui._txt_learnSkillNoSkill:SetShow(false)
  local posIndex = index - 1
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
  if nil == PaGlobal_LevelupInfo._skillBG[index] then
    PaGlobal_LevelupInfo._skillBG[index] = UI.cloneControl(PaGlobal_LevelupInfo._ui._stc_learnSkillArea, PaGlobal_LevelupInfo._ui._frm_learnSkillContent, "Static_LearnSkillAreaBG_" .. index)
  end
  PaGlobal_LevelupInfo._skillBG[index]:SetPosY(index * 45)
  PaGlobal_LevelupInfo._ui._frm_learnSkillContent:SetSize(310, 45 + index * 45)
  PaGlobal_LevelupInfo._skillBG[index]:SetShow(true)
  local skillIcon = UI.getChildControl(PaGlobal_LevelupInfo._skillBG[index], "Static_LearnSkillIcon")
  skillIcon:SetShow(true)
  skillIcon:ChangeTextureInfoNameAsync("Icon/" .. skillTypeStaticWrapper:getIconPath())
  skillIcon:SetPosX(10)
  skillIcon:SetPosY(0)
  skillIcon:addInputEvent("Mouse_On", "Panel_SkillTooltip_Show(" .. skillNo .. ", false, \"LevelupInfoLearn\", false)")
  skillIcon:addInputEvent("Mouse_Out", "Panel_SkillTooltip_Hide()")
  Panel_SkillTooltip_SetPosition(skillNo, skillIcon, "LevelupInfoLearn")
  local skillName = UI.getChildControl(PaGlobal_LevelupInfo._skillBG[index], "StaticText_LearnSkillName")
  skillName:SetShow(true)
  skillName:SetText(tostring(skillTypeStaticWrapper:getName()))
  skillName:SetPosX(skillIcon:GetPosX() + skillIcon:GetSizeX() + 10)
  skillName:SetPosY(skillIcon:GetPosY() + skillIcon:GetSizeY() / 2 - skillName:GetTextSizeY() / 2)
end
function PaGlobal_LevelupInfo_LearnableSkillDataSet(skillNo, index)
  if false == _ContentsGroup_LevelupInfo then
    return
  end
  if nil == Panel_Levelup_Info then
    return
  end
  if nil == skillNo then
    UI_ASSERT_NAME(nil ~= skillNo, "skillNo\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\1342", "\236\160\149\237\131\156\234\179\164")
    return
  end
  if nil == index then
    UI_ASSERT_NAME(nil ~= index, "index\234\176\128 nil\236\157\180\235\169\180 \236\149\136\235\144\1342", "\236\160\149\237\131\156\234\179\164")
    return
  end
  PaGlobal_LevelupInfo._ui._txt_learnableSkillNoSkill:SetShow(false)
  local posIndex = index - 1
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
  if nil == PaGlobal_LevelupInfo._learnableSkillBG[index] then
    PaGlobal_LevelupInfo._learnableSkillBG[index] = UI.cloneControl(PaGlobal_LevelupInfo._ui._stc_learnableSkillArea, PaGlobal_LevelupInfo._ui._frm_learnableSkillContent, "Static_LearnableSkillAreaBG_" .. index)
  end
  PaGlobal_LevelupInfo._learnableSkillBG[index]:SetPosY(index * 45)
  PaGlobal_LevelupInfo._ui._frm_learnableSkillContent:SetSize(310, 45 + index * 45)
  PaGlobal_LevelupInfo._learnableSkillBG[index]:SetShow(true)
  local skillIcon = UI.getChildControl(PaGlobal_LevelupInfo._learnableSkillBG[index], "Static_LearnableSkillIcon")
  skillIcon:SetShow(true)
  skillIcon:ChangeTextureInfoNameAsync("Icon/" .. skillTypeStaticWrapper:getIconPath())
  skillIcon:SetPosX(10)
  skillIcon:SetPosY(0)
  skillIcon:addInputEvent("Mouse_On", "Panel_SkillTooltip_Show(" .. skillNo .. ", false, \"LevelupInfoLearnable\", false)")
  skillIcon:addInputEvent("Mouse_Out", "Panel_SkillTooltip_Hide()")
  Panel_SkillTooltip_SetPosition(skillNo, skillIcon, "LevelupInfoLearnable")
  local skillName = UI.getChildControl(PaGlobal_LevelupInfo._learnableSkillBG[index], "StaticText_LearnableSkillName")
  skillName:SetShow(true)
  skillName:SetText(tostring(skillTypeStaticWrapper:getName()))
  skillName:SetPosX(skillIcon:GetPosX() + skillIcon:GetSizeX() + 10)
  skillName:SetPosY(skillIcon:GetPosY() + skillIcon:GetSizeY() / 2 - skillName:GetTextSizeY() / 2)
end
