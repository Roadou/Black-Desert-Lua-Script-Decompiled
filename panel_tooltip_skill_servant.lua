Panel_Tooltip_Skill_Servant:SetShow(false)
local UI_TM = CppEnums.TextMode
local PaGlobal_Tooltip_Servant = {
  _ui = {
    _txt_SkillName = UI.getChildControl(Panel_Tooltip_Skill_Servant, "Tooltip_Skill_Name"),
    _stc_SkillIcon = UI.getChildControl(Panel_Tooltip_Skill_Servant, "Tooltip_Skill_Icon"),
    _txt_SkillDesc = UI.getChildControl(Panel_Tooltip_Skill_Servant, "StaticText_Description_Value"),
    _txt_SkillCondition_Title = UI.getChildControl(Panel_Tooltip_Skill_Servant, "StaticText_Condition_Title"),
    _txt_SkillCondition_Value = UI.getChildControl(Panel_Tooltip_Skill_Servant, "StaticText_Condition_Value"),
    _stc_DescBG = UI.getChildControl(Panel_Tooltip_Skill_Servant, "Static_DescBG"),
    _web_Servant_Skill_Movie = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Tooltip_Skill_Servant, "WebControl_Servant_Skill_Movie")
  },
  slotData = {}
}
function PaGlobal_Tooltip_Servant:Init()
  self._ui._txt_SkillName:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._txt_SkillDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._web_Servant_Skill_Movie:ResetUrl()
end
function PaGlobal_Tooltip_Servant:Open(actorKeyRaw, slot, ii)
  if not ToClient_IsDevelopment() then
    return
  end
  if nil == actorKeyRaw then
    return
  end
  local servantWrapper = getServantInfoFromActorKey(actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  local skillCount = servantWrapper:getSkillCount()
  local skillWrapper = servantWrapper:getSkill(ii)
  local savedPosY = 0
  local posY = 0
  if nil ~= skillWrapper then
    local expTxt = math.floor(servantWrapper:getSkillExp(ii) / (skillWrapper:get()._maxExp / 100))
    local skillIcon = skillWrapper:getIconPath()
    local skillKey = skillWrapper:getKey()
    local skillName = skillWrapper:getName()
    local skillDesc = skillWrapper:getDescription()
    local skillCondition = skillWrapper:getConditionDescription()
    self._ui._stc_SkillIcon:ChangeTextureInfoName("Icon/" .. skillIcon)
    self._ui._txt_SkillName:SetText(tostring(skillName))
    self._ui._txt_SkillDesc:SetText(tostring(skillDesc))
    if "" ~= skillCondition then
      self._ui._txt_SkillCondition_Title:SetShow(true)
      self._ui._txt_SkillCondition_Title:SetText("<PAColor0xFFEEEEEE>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TOOLTIP_NEED_BEFORE_RUN_SKILL") .. "<PAOldColor>")
      self._ui._txt_SkillCondition_Title:SetPosY(self._ui._txt_SkillDesc:GetPosY() + self._ui._txt_SkillDesc:GetTextSizeY() + 30)
      self._ui._txt_SkillCondition_Value:SetShow(true)
      self._ui._txt_SkillCondition_Value:SetText(tostring(skillCondition))
      self._ui._txt_SkillCondition_Value:SetPosY(self._ui._txt_SkillCondition_Title:GetPosY() + self._ui._txt_SkillCondition_Title:GetTextSizeY() + 10)
      posY = posY + self._ui._txt_SkillCondition_Value:GetTextSizeY()
      self._ui._stc_DescBG:SetSize(self._ui._stc_DescBG:GetSizeX(), self._ui._txt_SkillDesc:GetTextSizeY() + self._ui._txt_SkillCondition_Title:GetTextSizeY() + self._ui._txt_SkillCondition_Value:GetTextSizeY() + 60)
    else
      self._ui._txt_SkillCondition_Title:SetShow(false)
      self._ui._txt_SkillCondition_Value:SetShow(false)
      self._ui._stc_DescBG:SetSize(self._ui._stc_DescBG:GetSizeX(), self._ui._txt_SkillDesc:GetTextSizeY() + 20)
      posY = 0
    end
  end
  local url = "coui://UI_Data/UI_Html/Skill_Movie.html"
  self._ui._web_Servant_Skill_Movie:SetShow(true)
  self._ui._web_Servant_Skill_Movie:SetSize(320, 240)
  self._ui._web_Servant_Skill_Movie:SetUrl(320, 240, url)
  self._ui._web_Servant_Skill_Movie:SetHorizonCenter()
  self._ui._web_Servant_Skill_Movie:SetVerticalBottom()
  if nil ~= self._ui._web_Servant_Skill_Movie then
    posY = posY + self._ui._web_Servant_Skill_Movie:GetSizeY()
  end
  Panel_Tooltip_Skill_Servant:SetSize(Panel_Tooltip_Skill_Servant:GetSizeX(), 180 + self._ui._txt_SkillDesc:GetTextSizeY() + posY + 20)
  Panel_Tooltip_Skill_Servant:SetPosX(slot.icon:GetParentPosX() + slot.icon:GetSizeX() + 10)
  Panel_Tooltip_Skill_Servant:SetPosY(slot.icon:GetParentPosY())
  self._ui._web_Servant_Skill_Movie:ComputePos()
  Panel_Tooltip_Skill_Servant:SetShow(true)
end
function PaGlobal_Tooltip_Servant:Close()
  Panel_Tooltip_Skill_Servant:SetShow(false)
  self._ui._web_Servant_Skill_Movie:SetShow(false)
  self._ui._web_Servant_Skill_Movie:ResetUrl()
  self._ui._web_Servant_Skill_Movie:TriggerEvent("StopMovie", "test")
end
function PaGlobal_Tooltip_Servant_Open(actorKeyRaw, slot, ii)
  PaGlobal_Tooltip_Servant:Open(actorKeyRaw, slot, ii)
end
function PaGlobal_Tooltip_Servant_Close()
  PaGlobal_Tooltip_Servant:Close()
end
PaGlobal_Tooltip_Servant:Init()
