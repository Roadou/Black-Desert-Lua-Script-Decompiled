function HandleEventMouseLup_FamilySkill_applySkill(familySkillKind, familySkillLevel)
  if nil == Panel_Window_FamilySkill_Main then
    return
  end
  local playerLevel = getSelfPlayer():get():getLevel()
  local familySkillWrapper = ToClient_GetFamilySkillWrapper(familySkillLevel)
  if playerLevel < familySkillWrapper:getLearnLevel() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_NOLEVEL_ACK"))
    return
  end
  if true == ToClient_IsSetFamilySkill(familySkillLevel) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_FAMILYSKILL_ALREADY_APPLY_SKILL"))
    return
  end
  local preStatLevel = familySkillLevel - ToClient_GetFamilySkillKindCount()
  if preStatLevel > 0 and false == ToClient_IsSetFamilySkill(preStatLevel) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_FAMILYSKILL_MUST_APPLY_PREVIOUS_SKILL"))
    return
  end
  if ToClient_GetFamilySkillPoint() < familySkillWrapper:getNeedPoint() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_FAMILYSKILL_NOT_ENOUGH_SKILLPOINT"))
    return
  end
  ToClient_RequestVaryFamilySkill(familySkillLevel)
  local self = PaGlobal_Window_FamilySkill_Main
  self._learnFamilySkillKind = familySkillKind
  self._learnFamilySkillLevel = familySkillLevel
end
function HandleEventMouseOn_FamilySkill_ShowTooltip(isShowTooltip, listContentKey, familySkillKind, familySkillLevel)
  if nil == Panel_Window_FamilySkill_Main then
    return
  end
  local familySkillList = PaGlobal_Window_FamilySkill_Main._ui._skillList
  if true == isShowTooltip then
    local familySkillWrapper = ToClient_GetFamilySkillWrapper(familySkillLevel)
    local tooltipName = familySkillWrapper:getFamilySkillName()
    local tooltipDesc = familySkillWrapper:getFamilySkillDescription()
    local listContent = familySkillList:GetContentByKey(toInt64(0, listContentKey))
    if nil ~= listContent then
      local skillIconBg = UI.getChildControl(listContent, "Static_SkillBg" .. familySkillKind)
      local skillIcon = UI.getChildControl(skillIconBg, "Static_SkillIcon" .. familySkillKind)
      TooltipSimple_Show(skillIcon, tooltipName, tooltipDesc)
    end
  else
    TooltipSimple_Hide()
  end
end
function HandleEventMouseLup_FamilySkill_resetSkill()
  if nil == Panel_Window_FamilySkill_Main then
    return
  end
  ToClient_RequestAllClearFamilySkill()
end
function FromClient_UpdateFamilySkillExpAndPoint()
  if nil == Panel_Window_FamilySkill_Main then
    return
  end
  local self = PaGlobal_Window_FamilySkill_Main
  self:updatePointDescription()
end
function FromClient_UpdateFamilySkill()
  if nil == Panel_Window_FamilySkill_Main then
    return
  end
  local self = PaGlobal_Window_FamilySkill_Main
  self:update()
end
function HandleEventChangeListContent_createSkillList(list_content, key)
  local self = PaGlobal_Window_FamilySkill_Main
  if nil == Panel_Window_FamilySkill_Main or false == self._initialize then
    return
  end
  key = Int64toInt32(key)
  local skillKindCount = ToClient_GetFamilySkillKindCount()
  for skillKind = 1, skillKindCount do
    local skillLevel = math.floor(skillKind + key * skillKindCount)
    local levelText = UI.getChildControl(list_content, "StaticText_Lv")
    local skillIconBg = UI.getChildControl(list_content, "Static_SkillBg" .. skillKind)
    local skillIcon = UI.getChildControl(skillIconBg, "Static_SkillIcon" .. skillKind)
    local skillLearnIcon = UI.getChildControl(skillIconBg, "Static_EnableLearnIcon_" .. skillKind)
    local familySkillWrapper = ToClient_GetFamilySkillWrapper(skillLevel)
    levelText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_CRAFTLEVEL") .. " " .. familySkillWrapper:getLearnLevel())
    local iconBackgroundFile = familySkillWrapper:getIconBackgroundPath()
    local iconFile = familySkillWrapper:getIconPath()
    local leftTopUV, rightBottomUV, x1, y1, x2, y2
    local isLearnSkill = false
    skillLearnIcon:SetShow(false)
    if true == ToClient_IsSetFamilySkill(skillLevel) then
      leftTopUV = familySkillWrapper:getBackgroundLeftTopUV()
      rightBottomUV = familySkillWrapper:getBackgroundRightBottomUV()
      isLearnSkill = true
      if skillKind == self._learnFamilySkillKind and skillLevel == self._learnFamilySkillLevel then
        skillIcon:EraseAllEffect()
        skillIcon:AddEffect("UI_NewSkill01", false, 0, 0)
        skillIcon:AddEffect("fUI_NewSkill01", false, 0, 0)
        self._learnFamilySkillKind = nil
        self._learnFamilySkillLevel = nil
      end
    else
      leftTopUV = familySkillWrapper:getDefaultBackgroundLeftTopUV()
      rightBottomUV = familySkillWrapper:getDefaultBackgroundRightBottomUV()
      if 0 == key then
        skillLearnIcon:addInputEvent("Mouse_LUp", "HandleEventMouseLup_FamilySkill_applySkill(" .. skillKind .. ", " .. skillLevel .. ")")
        skillLearnIcon:addInputEvent("Mouse_On", "HandleEventMouseOn_FamilySkill_ShowTooltip(true, " .. key .. ", " .. skillKind .. ", " .. skillLevel .. ")")
        skillLearnIcon:addInputEvent("Mouse_Out", "HandleEventMouseOn_FamilySkill_ShowTooltip(false, " .. key .. ", " .. skillKind .. ", " .. skillLevel .. ")")
        skillLearnIcon:SetShow(true)
      end
      local preStatLevel = skillLevel - skillKindCount
      if preStatLevel >= 0 and true == ToClient_IsSetFamilySkill(preStatLevel) then
        skillLearnIcon:addInputEvent("Mouse_LUp", "HandleEventMouseLup_FamilySkill_applySkill(" .. skillKind .. ", " .. skillLevel .. ")")
        skillLearnIcon:addInputEvent("Mouse_On", "HandleEventMouseOn_FamilySkill_ShowTooltip(true, " .. key .. ", " .. skillKind .. ", " .. skillLevel .. ")")
        skillLearnIcon:addInputEvent("Mouse_Out", "HandleEventMouseOn_FamilySkill_ShowTooltip(false, " .. key .. ", " .. skillKind .. ", " .. skillLevel .. ")")
        skillLearnIcon:SetShow(true)
      end
    end
    skillIconBg:ChangeTextureInfoName(iconBackgroundFile)
    x1, y1, x2, y2 = setTextureUV_Func(skillIconBg, leftTopUV.x, leftTopUV.y, rightBottomUV.x, rightBottomUV.y)
    skillIconBg:getBaseTexture():setUV(x1, y1, x2, y2)
    skillIconBg:setRenderTexture(skillIconBg:getBaseTexture())
    skillIconBg:SetShow(true)
    skillIcon:ChangeTextureInfoName(iconFile)
    if 1 == skillKind then
      if true == isLearnSkill then
        x1, y1, x2, y2 = setTextureUV_Func(skillIcon, 2, 2, 46, 46)
      else
        x1, y1, x2, y2 = setTextureUV_Func(skillIcon, 2, 48, 46, 92)
      end
    elseif 2 == skillKind then
      if true == isLearnSkill then
        x1, y1, x2, y2 = setTextureUV_Func(skillIcon, 48, 2, 92, 46)
      else
        x1, y1, x2, y2 = setTextureUV_Func(skillIcon, 48, 48, 92, 92)
      end
    elseif 3 == skillKind then
      if true == isLearnSkill then
        x1, y1, x2, y2 = setTextureUV_Func(skillIcon, 94, 2, 138, 46)
      else
        x1, y1, x2, y2 = setTextureUV_Func(skillIcon, 94, 48, 138, 92)
      end
    elseif 4 == skillKind then
      if true == isLearnSkill then
        x1, y1, x2, y2 = setTextureUV_Func(skillIcon, 140, 2, 184, 46)
      else
        x1, y1, x2, y2 = setTextureUV_Func(skillIcon, 140, 48, 184, 92)
      end
    end
    skillIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    skillIcon:setRenderTexture(skillIcon:getBaseTexture())
    skillIcon:SetShow(true)
    skillIcon:addInputEvent("Mouse_LUp", "HandleEventMouseLup_FamilySkill_applySkill(" .. skillKind .. ", " .. skillLevel .. ")")
    skillIcon:addInputEvent("Mouse_On", "HandleEventMouseOn_FamilySkill_ShowTooltip(true, " .. key .. ", " .. skillKind .. ", " .. skillLevel .. ")")
    skillIcon:addInputEvent("Mouse_Out", "HandleEventMouseOn_FamilySkill_ShowTooltip(false, " .. key .. ", " .. skillKind .. ", " .. skillLevel .. ")")
  end
end
function HandleEventChangeListContent_createSkillDescription(list_content, key)
  local self = PaGlobal_Window_FamilySkill_Main
  if nil == Panel_Window_FamilySkill_Main or false == self._initialize then
    return
  end
  local skillType = Int64toInt32(key)
  local nextLevel = ToClient_GetFamilySkillKindCount()
  local skillCount = ToClient_GetFamilySkillCount()
  local skillValue = 0
  local familySkillWrapper
  local apply = false
  for skill = skillType, skillCount, nextLevel do
    if true == ToClient_IsSetFamilySkill(skill) then
      familySkillWrapper = ToClient_GetFamilySkillWrapper(skill)
      skillValue = skillValue + familySkillWrapper:getParam()
      apply = true
    end
  end
  if true == apply then
    local skillDescriptionControl = UI.getChildControl(list_content, "StaticText_ResultDesc")
    local skillDescriptionText
    if 4 == skillType then
      skillValue = skillValue / 10000
      skillDescriptionText = string.gsub(familySkillWrapper:getFamilySkillDescription(), "%d.%d+", skillValue)
    else
      skillDescriptionText = string.gsub(familySkillWrapper:getFamilySkillDescription(), "%d+", skillValue)
    end
    skillDescriptionControl:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    skillDescriptionControl:SetText(skillDescriptionText)
    skillDescriptionControl:SetShow(true)
  end
end
