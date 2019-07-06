function PaGlobal_LevelupInfo:initialize()
  if true == PaGlobal_LevelupInfo._initialize then
    return
  end
  Panel_Levelup_Info:SetDragAll(true)
  PaGlobal_LevelupInfo._ui._txt_titleLevel = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_titleBar, "StaticText_LevelTitle")
  PaGlobal_LevelupInfo._ui._btn_close = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_titleBar, "Button_CloseIcon")
  PaGlobal_LevelupInfo._ui._txt_maxHpTitle = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_statusBG, "StaticText_HpTitle")
  PaGlobal_LevelupInfo._ui._txt_maxHpValue = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_statusBG, "StaticText_PrevHp")
  PaGlobal_LevelupInfo._ui._stc_hpArrow = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_statusBG, "Static_HpArrow")
  PaGlobal_LevelupInfo._ui._txt_increaseHpValue = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_statusBG, "StaticText_CurrentHp")
  PaGlobal_LevelupInfo._ui._txt_maxMpTitle = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_statusBG, "StaticText_MpTitle")
  PaGlobal_LevelupInfo._ui._txt_maxMpValue = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_statusBG, "StaticText_PrevMp")
  PaGlobal_LevelupInfo._ui._stc_mpArrow = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_statusBG, "Static_MpArrow")
  PaGlobal_LevelupInfo._ui._txt_increaseMpValue = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_statusBG, "StaticText_CurrentMp")
  PaGlobal_LevelupInfo._ui._txt_weightTitle = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_statusBG, "StaticText_WeightTitle")
  PaGlobal_LevelupInfo._ui._txt_weightValue = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_statusBG, "StaticText_PrevWeight")
  PaGlobal_LevelupInfo._ui._stc_weightArrow = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_statusBG, "Static_WeightArrow")
  PaGlobal_LevelupInfo._ui._txt_increaseWeightValue = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_statusBG, "StaticText_CurrentWeight")
  PaGlobal_LevelupInfo._ui._txt_learnSkillTitle = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_LearnSkillBG, "StaticText_LearnSkillTitle")
  PaGlobal_LevelupInfo._ui._stc_learnSkillLine_Deco = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_LearnSkillBG, "Static_LearnSkillTitleLine")
  PaGlobal_LevelupInfo._ui._frm_learnSkill = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_LearnSkillBG, "Frame_LearnSkill")
  PaGlobal_LevelupInfo._ui._frm_learnSkillContent = PaGlobal_LevelupInfo._ui._frm_learnSkill:GetFrameContent()
  PaGlobal_LevelupInfo._ui._frm_learnSkillScroll = PaGlobal_LevelupInfo._ui._frm_learnSkill:GetVScroll()
  PaGlobal_LevelupInfo._ui._txt_learnSkillNoSkill = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_LearnSkillBG, "StaticText_NoSkill")
  PaGlobal_LevelupInfo._ui._stc_learnSkillArea = UI.getChildControl(PaGlobal_LevelupInfo._ui._frm_learnSkillContent, "Static_TemplateArea1")
  PaGlobal_LevelupInfo._ui._txt_learnableSkillTitle = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_LearnableSkillBG, "StaticText_LearnableSkillTitle")
  PaGlobal_LevelupInfo._ui._stc_learnableSkillLine_Deco = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_LearnableSkillBG, "Static_LearnableSkillTitleLine")
  PaGlobal_LevelupInfo._ui._frm_learnableSkill = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_LearnableSkillBG, "Frame_LearnableSkill")
  PaGlobal_LevelupInfo._ui._frm_learnableSkillContent = PaGlobal_LevelupInfo._ui._frm_learnableSkill:GetFrameContent()
  PaGlobal_LevelupInfo._ui._frm_learnableSkillScroll = PaGlobal_LevelupInfo._ui._frm_learnableSkill:GetVScroll()
  PaGlobal_LevelupInfo._ui._txt_learnableSkillNoSkill = UI.getChildControl(PaGlobal_LevelupInfo._ui._stc_LearnableSkillBG, "StaticText_NoSkill")
  PaGlobal_LevelupInfo._ui._stc_learnableSkillArea = UI.getChildControl(PaGlobal_LevelupInfo._ui._frm_learnableSkillContent, "Static_TemplateArea1")
  PaGlobal_LevelupInfo._ui._txt_maxHpTitle:SetTextMode(__eTextMode_LimitText)
  PaGlobal_LevelupInfo._ui._txt_maxMpTitle:SetTextMode(__eTextMode_LimitText)
  PaGlobal_LevelupInfo._ui._txt_weightTitle:SetTextMode(__eTextMode_LimitText)
  PaGlobal_LevelupInfo._ui._txt_maxHpTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXHPUP"))
  PaGlobal_LevelupInfo._ui._txt_weightTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXWEIGHTUP"))
  PaGlobal_LevelupInfo._ui._txt_learnSkillTitle:SetTextMode(__eTextMode_LimitText)
  PaGlobal_LevelupInfo._ui._txt_learnSkillTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_INFO_LEARNSKILL_TITLE"))
  PaGlobal_LevelupInfo._ui._txt_learnableSkillTitle:SetTextMode(__eTextMode_LimitText)
  PaGlobal_LevelupInfo._ui._txt_learnableSkillTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_INFO_LEARNABLESKILL_TITLE"))
  PaGlobal_LevelupInfo:registEventHandler()
  PaGlobal_LevelupInfo:validate()
  PaGlobal_LevelupInfo._initialize = true
end
function PaGlobal_LevelupInfo:CurrentState()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  PaGlobal_LevelupInfo._maxHp = selfPlayer:get():getMaxHp()
  PaGlobal_LevelupInfo._maxMp = selfPlayer:get():getMaxMp()
  PaGlobal_LevelupInfo._maxWeight = selfPlayer:get():getPossessableWeight_s64()
end
function PaGlobal_LevelupInfo:registEventHandler()
  if nil == Panel_Levelup_Info then
    return
  end
  PaGlobal_LevelupInfo._ui._btn_close:addInputEvent("Mouse_LUp", "PaGlobal_LevelupInfo_Close()")
  registerEvent("FromClient_SelfPlayerCurrentLevelInfo", "FromClient_SelfPlayerCurrentLevelInfo")
end
function PaGlobal_LevelupInfo:prepareOpen()
  if nil == Panel_Levelup_Info then
    return
  end
  if false == _ContentsGroup_LevelupInfo then
    return
  end
  Panel_Levelup_Info:ComputePos()
  PaGlobal_LevelupInfo._ui._frm_learnSkill:UpdateContentPos()
  PaGlobal_LevelupInfo._ui._frm_learnSkill:UpdateContentScroll()
  PaGlobal_LevelupInfo._ui._frm_learnSkillScroll:SetControlTop()
  PaGlobal_LevelupInfo._ui._frm_learnableSkill:UpdateContentPos()
  PaGlobal_LevelupInfo._ui._frm_learnableSkill:UpdateContentScroll()
  PaGlobal_LevelupInfo._ui._frm_learnableSkillScroll:SetControlTop()
  Panel_Levelup_Info:SetPosX(getScreenSizeX() + Panel_Levelup_Info:GetSizeX())
  Panel_Levelup_Info:SetPosY(getScreenSizeY() - Panel_Levelup_Info:GetSizeY() - 30)
  local moveAni1 = Panel_Levelup_Info:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  moveAni1:SetStartPosition(getScreenSizeX() + Panel_Levelup_Info:GetSizeX(), getScreenSizeY() - Panel_Levelup_Info:GetSizeY() - 30)
  moveAni1:SetEndPosition(getScreenSizeX() - Panel_Levelup_Info:GetSizeX() - 20, getScreenSizeY() - Panel_Levelup_Info:GetSizeY() - 30)
  moveAni1:SetDisableWhileAni(true)
  PaGlobal_LevelupInfo:open()
end
function PaGlobal_LevelupInfo:open()
  if nil == Panel_Levelup_Info then
    return
  end
  Panel_Levelup_Info:SetShow(true)
  Panel_Levelup_Info:ComputePos()
end
function PaGlobal_LevelupInfo:prepareClose()
  if nil == Panel_Levelup_Info then
    return
  end
  local moveAni2 = Panel_Levelup_Info:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SQUARE)
  moveAni2:SetStartPosition(getScreenSizeX() - Panel_Levelup_Info:GetSizeX() - 20, getScreenSizeY() - Panel_Levelup_Info:GetSizeY() - 30)
  moveAni2:SetEndPosition(getScreenSizeX() - Panel_Levelup_Info:GetSizeX() - 20, getScreenSizeY() + Panel_Levelup_Info:GetSizeY() + 30)
  moveAni2:SetHideAtEnd(true)
  moveAni2:SetDisableWhileAni(true)
end
function PaGlobal_LevelupInfo:close()
  if nil == Panel_Levelup_Info then
    return
  end
  Panel_Levelup_Info:SetShow(false)
end
function PaGlobal_LevelupInfo:validate()
  if nil == Panel_Levelup_Info then
    return
  end
end
