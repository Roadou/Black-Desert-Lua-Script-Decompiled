Instance_CoolTime_Effect:SetShow(false, false)
Instance_SkillCooltime:SetShow(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
Instance_CoolTime_Effect:RegisterShowEventFunc(true, "SkillCoolTime_Effect_HideAni()")
function SkillCoolTime_Effect_HideAni()
  Instance_CoolTime_Effect:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local coolTime = Instance_CoolTime_Effect:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  coolTime:SetStartColor(UI_color.C_FFFFFFFF)
  coolTime:SetEndColor(UI_color.C_00FFFFFF)
  coolTime:SetStartIntensity(3)
  coolTime:SetEndIntensity(1)
  coolTime.IsChangeChild = true
  coolTime:SetHideAtEnd(true)
  coolTime:SetDisableWhileAni(true)
end
local skillCooltime = {
  config = {
    slotGapX = 50,
    slotGapY = 50,
    screenPosX = 0.33,
    screenPosY = 0.42
  },
  slotConfig = {
    createIcon = true,
    createEffect = false,
    createFG = false,
    createFGDisabled = false,
    createLevel = false,
    createLearnButton = false,
    createCooltime = true,
    createCooltimeText = true
  },
  slots = {},
  slots_description = {},
  slotPool = Array.new(),
  slotPool_desc = Array.new(),
  slotCount = 0,
  slotCount_desc = 0,
  textRemainTime = 1.5,
  textTemplate = UI.getChildControl(Instance_SkillCooltime, "StaticText_CoolTimeTitle")
}
local showToggle = true
function skillCooltime:createNewSlot()
  self.slotCount = self.slotCount + 1
  local slot = {}
  SlotSkill.new(slot, self.slotCount, Instance_SkillCooltime, self.slotConfig)
  slot.icon:SetIgnore(true)
  slot.iconBg = UI.createAndCopyBasePropertyControl(Instance_SkillCooltime, "Static_Icon_GuildSkillBG", slot.icon, "GuildSkillCoolTimeBG_" .. self.slotCount)
  slot.iconBg:SetPosX(slot.icon:GetPosX() - 6)
  slot.iconBg:SetPosY(slot.icon:GetPosY() - 6)
  return slot
end
function skillCooltime:createNewSlot_Desc()
end
function skillCooltime:getSlot()
  if 0 < self.slotPool:length() then
    return self.slotPool:pop_back()
  else
    return self:createNewSlot()
  end
end
local skillReuseTime
function SkillCooltime_Add(TSkillKey, TSkillNo)
  local self = skillCooltime
  local slot = self.slots[TSkillKey]
  if nil == slot then
    slot = self:getSlot()
    self.slots[TSkillKey] = slot
  end
  local slotDesc = self.slots_description[TSkillKey]
  if nil == slotDesc then
    slotDesc = {
      remainTime = self.textRemainTime,
      skillNo = TSkillNo
    }
    self.slots_description[TSkillKey] = slotDesc
  end
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(TSkillNo)
  local isGuildSkill = skillTypeStaticWrapper:isGuildSkill()
  if true == isGuildSkill then
    slot.iconBg:SetShow(true)
  else
    slot.iconBg:SetShow(false)
  end
  local level = getLearnedSkillLevel(skillTypeStaticWrapper)
  local skillSS = getSkillStaticStatus(TSkillNo, level)
  skillReuseTime = skillSS:get()._reuseCycle / 1000
  slot:clearSkill()
  slot:setSkillTypeStatic(skillTypeStaticWrapper)
  slotDesc.remainTime = self.textRemainTime
end
function SkillCooltime_OnResize()
  local self = skillCooltime
  local sizeX = getScreenSizeX()
  local sizeY = getScreenSizeY()
  if Instance_SkillCooltime:GetRelativePosX() == -1 and Instance_SkillCooltime:GetRelativePosY() == -1 then
    local initPosX = sizeX * self.config.screenPosX
    local initPosY = sizeY * self.config.screenPosY
    Instance_SkillCooltime:SetPosX(initPosX)
    Instance_SkillCooltime:SetPosY(initPosY)
    changePositionBySever(Instance_SkillCooltime, CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTime, true, true, false)
    FGlobal_InitPanelRelativePos(Instance_SkillCooltime, initPosX, initPosY)
  elseif Instance_SkillCooltime:GetRelativePosX() == 0 and Instance_SkillCooltime:GetRelativePosY() == 0 then
    Instance_SkillCooltime:SetPosX(sizeX * self.config.screenPosX)
    Instance_SkillCooltime:SetPosY(sizeY * self.config.screenPosY)
  else
    Instance_SkillCooltime:SetPosX(sizeX * Instance_SkillCooltime:GetRelativePosX() - Instance_SkillCooltime:GetSizeX() / 2)
    Instance_SkillCooltime:SetPosY(sizeY * Instance_SkillCooltime:GetRelativePosY() - Instance_SkillCooltime:GetSizeY() / 2)
  end
  if 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTime, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved) then
    Instance_SkillCooltime:SetShow(ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTime, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
  end
  FGlobal_PanelRepostionbyScreenOut(Instance_SkillCooltime)
end
function SkillCooltime_UpdatePerFrame(deltaTime)
  if false == showToggle then
    return
  end
  local self = skillCooltime
  local remainTime = 0
  local row = 0
  local col = 0
  local count = 0
  local readyCount = 0
  for tSkillKey, slot_desc in pairs(self.slots_description) do
    local slot = self.slots[tSkillKey]
    remainTime = getSkillCooltime(tSkillKey)
    local realRemainTime = 0
    local intRemainTime = 0
    local skillReuseTime = 0
    local skillStaticWrapper = getSkillStaticStatus(slot_desc.skillNo, 1)
    if nil ~= skillStaticWrapper then
      skillReuseTime = skillStaticWrapper:get()._reuseCycle / 1000
    end
    if 0 < slot_desc.remainTime then
      row = count % 2
      col = math.floor(count / 2)
    end
    if remainTime > 0 and nil ~= slot then
      slot.icon:SetShow(true)
      slot.cooltime:UpdateCoolTime(remainTime)
      slot.cooltime:SetShow(true)
      realRemainTime = remainTime * skillReuseTime
      intRemainTime = realRemainTime - realRemainTime % 1 + 1
      slot.cooltimeText:SetText(Time_Formatting_ShowTop(intRemainTime))
      if skillReuseTime >= intRemainTime then
        slot.cooltimeText:SetShow(true)
      else
        slot.cooltimeText:SetShow(false)
      end
      slot:setPos(col * self.config.slotGapX, row * self.config.slotGapY)
    elseif nil ~= slot then
      slot.icon:SetShow(false)
      local slotPosX = slot.icon:GetParentPosX()
      local slotPosY = slot.icon:GetParentPosY()
      audioPostEvent_SystemUi(2, 1)
      _AudioPostEvent_SystemUiForXBOX(2, 1)
      Instance_CoolTime_Effect:SetShow(true, true)
      Instance_CoolTime_Effect:SetIgnore(true)
      Instance_CoolTime_Effect:AddEffect("fUI_Light", false, 0, 0)
      Instance_CoolTime_Effect:SetPosX(slotPosX - 5)
      Instance_CoolTime_Effect:SetPosY(slotPosY - 5)
      slot:clearSkill()
      self.slotPool:push_back(slot)
      self.slots[tSkillKey] = nil
    end
    if nil == self.slots[tSkillKey] then
      slot_desc.remainTime = slot_desc.remainTime - deltaTime
    end
    if 0 < slot_desc.remainTime then
      count = count + 1
    end
  end
end
function SkillCooltime_Reload()
  local coolTimeSkillList = getCoolTimeSkillList()
  if nil ~= coolTimeSkillList then
    for index = 0, coolTimeSkillList:size() - 1 do
      local skillInfo = coolTimeSkillList:atPointer(index)
      local skillKey = skillInfo._skillKey:get()
      local skillNo = skillInfo._skillKey:getSkillNo()
      SkillCooltime_Add(skillKey, skillNo)
    end
  end
end
function skillCooltime:registEventHandler()
  Instance_SkillCooltime:RegisterUpdateFunc("SkillCooltime_UpdatePerFrame")
end
function FromClient_SkillCoolTime_luaLoadComplete()
  if 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTime, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved) then
    Instance_SkillCooltime:SetShow(ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTime, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
  end
end
function skillCooltime:registMessageHandler()
  registerEvent("EventSkillCooltime", "SkillCooltime_Add")
  registerEvent("onScreenResize", "SkillCooltime_OnResize")
  registerEvent("FromClient_luaLoadComplete", "FromClient_SkillCoolTime_luaLoadComplete")
end
SkillCooltime_Reload()
skillCooltime:registEventHandler()
skillCooltime:registMessageHandler()
function Panel_SkillCooltime_ShowToggle()
  local isShow = Instance_SkillCooltime:IsShow()
  if isShow then
    showToggle = false
    Instance_SkillCooltime:SetShow(false, false)
  else
    showToggle = true
    Instance_SkillCooltime:SetShow(true, true)
  end
end
registerEvent("FromClient_RenderModeChangeState", "SkillCooltime_OnResize")
