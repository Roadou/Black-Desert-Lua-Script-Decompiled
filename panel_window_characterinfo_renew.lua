local _panel = Panel_Window_CharacterInfo_Renew
local Class_BattleSpeed = CppEnums.ClassType_BattleSpeed
local UI_DefaultFaceTexture = CppEnums.ClassType_DefaultFaceTexture
local UI_classType = CppEnums.ClassType
local UI_ClassSymbol = CppEnums.ClassType_Symbol
local TAB_TYPE = {
  BASIC = 1,
  TITLE = 2,
  CHALLENGE = 3,
  LIFE = 4,
  QUEST_TOGGLE = 5,
  CASH_BUFF = 6,
  HISTORY = 7
}
local CharacterInfo = {
  _ui = {
    stc_TitleBg = UI.getChildControl(_panel, "Static_Title"),
    stc_tabGroup = UI.getChildControl(_panel, "Static_Tab_Group"),
    stc_CharacterInfoBg = UI.getChildControl(_panel, "Static_CharacterInfoBg"),
    stc_LifeInfoBg = UI.getChildControl(_panel, "Static_LifeInfoBg"),
    stc_TitleInfoBg = UI.getChildControl(_panel, "Static_TitleInfoBg"),
    stc_HistoryInfoBg = UI.getChildControl(_panel, "Static_HistoryInfoBg"),
    stc_ChallengeInfoBg = UI.getChildControl(_panel, "Static_ChallengeInfoBg"),
    stc_ProfileInfoBg = UI.getChildControl(_panel, "Static_ProfileInfoBg"),
    stc_questInfo = UI.getChildControl(_panel, "Static_QuestInfoBg"),
    txt_keyGuideA = UI.getChildControl(_panel, "StaticText_A_ConsoleUI"),
    txt_keyGuideB = UI.getChildControl(_panel, "StaticText_B_ConsoleUI"),
    txt_keyGuideX = UI.getChildControl(_panel, "StaticText_X_ConsoleUI"),
    txt_keyGuideY = UI.getChildControl(_panel, "StaticText_Y_ConsoleUI")
  },
  _potentialUIData = {
    limitPotentialLevel = 5,
    maxX = 280,
    posX = 260,
    posY = 96,
    gapY = 35,
    sizeY = 2
  },
  _fitness = {
    stamina = 0,
    strength = 1,
    health = 2
  },
  _currentTab = 0,
  _maxPanelTypeNumber = 6,
  POTENTIAL_TYPE = {
    MOVESPEED = 0,
    ATTACKSPEED = 1,
    CRITICALLEVEL = 2,
    FISHINGLEVEL = 3,
    GATHERLEVEL = 4,
    LUCKLEVEL = 5,
    TOTALCOUNT = 6
  },
  _tapName = {
    [TAB_TYPE.BASIC] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_BASICTAPNAME"),
    [TAB_TYPE.TITLE] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_TITLETAPNAME"),
    [TAB_TYPE.HISTORY] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_HISTORYTABNAME"),
    [TAB_TYPE.QUEST_TOGGLE] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUESTOPTION_TITLE"),
    [TAB_TYPE.LIFE] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_LIFEINFOTABNAME"),
    [TAB_TYPE.CHALLENGE] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_CHALLENGETABNAME"),
    [TAB_TYPE.CASH_BUFF] = PAGetString(Defines.StringSheet_GAME, "BUFF_LIST")
  },
  attackspeed_SlotBG = {},
  attackspeed_Slot = {},
  attackspeed_MinusSlot = {},
  castspeed_SlotBG = {},
  castspeed_Slot = {},
  castspeed_MinusSlot = {},
  movespeed_SlotBG = {},
  movespeed_Slot = {},
  movespeed_MinusSlot = {},
  critical_SlotBG = {},
  critical_Slot = {},
  critical_MinusSlot = {},
  fishTime_SlotBG = {},
  fishTime_Slot = {},
  fishTime_MinusSlot = {},
  product_SlotBG = {},
  product_Slot = {},
  product_MinusSlot = {},
  dropChance_SlotBG = {},
  dropChance_Slot = {},
  dropChance_MinusSlot = {}
}
function CharacterInfo:close()
  if true == Panel_Window_CharacterInfo_Renew:GetShow() then
    _AudioPostEvent_SystemUiForXBOX(1, 1)
  end
  Panel_Window_CharacterInfo_Renew:SetShow(false, false)
  UI.ClearFocusEdit()
  Panel_Window_CharacterInfo_Renew:CloseUISubApp()
  HelpMessageQuestion_Out()
  Panel_Tooltip_Item_hideTooltip()
end
function CharacterInfo:init()
  self._ui.txt_title = UI.getChildControl(self._ui.stc_TitleBg, "StaticText_Title")
  self._ui.tabGroups = {
    [TAB_TYPE.BASIC] = self._ui.stc_CharacterInfoBg,
    [TAB_TYPE.TITLE] = self._ui.stc_TitleInfoBg,
    [TAB_TYPE.CHALLENGE] = self._ui.stc_ChallengeInfoBg,
    [TAB_TYPE.LIFE] = self._ui.stc_LifeInfoBg,
    [TAB_TYPE.QUEST_TOGGLE] = self._ui.stc_questInfo,
    [TAB_TYPE.CASH_BUFF] = UI.getChildControl(_panel, "Static_CashBuff")
  }
  self._ui.stc_LB = UI.getChildControl(self._ui.stc_tabGroup, "Static_LB")
  self._ui.stc_LB:addInputEvent("Mouse_LUp", "PaGlobalFunc_CharacterInfo_ShowLeftNextTab()")
  self._ui.stc_RB = UI.getChildControl(self._ui.stc_tabGroup, "Static_RB")
  self._ui.stc_RB:addInputEvent("Mouse_LUp", "PaGlobalFunc_CharacterInfo_ShowRightNextTab()")
  self._ui.rdo_tabs = {
    [TAB_TYPE.BASIC] = UI.getChildControl(self._ui.stc_tabGroup, "RadioButton_Basic"),
    [TAB_TYPE.TITLE] = UI.getChildControl(self._ui.stc_tabGroup, "RadioButton_Named"),
    [TAB_TYPE.HISTORY] = UI.getChildControl(self._ui.stc_tabGroup, "RadioButton_Dairy"),
    [TAB_TYPE.CHALLENGE] = UI.getChildControl(self._ui.stc_tabGroup, "RadioButton_Task"),
    [TAB_TYPE.LIFE] = UI.getChildControl(self._ui.stc_tabGroup, "RadioButton_Life"),
    [TAB_TYPE.QUEST_TOGGLE] = UI.getChildControl(self._ui.stc_tabGroup, "RadioButton_Quest"),
    [TAB_TYPE.CASH_BUFF] = UI.getChildControl(self._ui.stc_tabGroup, "RadioButton_CashBuff")
  }
  self._maxPanelTypeNumber = #self._ui.tabGroups
  for ii = 1, self._maxPanelTypeNumber do
    self._ui.rdo_tabs[ii]:SetShow(true)
  end
  local rdoBtns = {}
  for ii = 1, self._maxPanelTypeNumber do
    self._ui.rdo_tabs[ii]:addInputEvent("Mouse_LUp", "InputMLUp_TapToOpenWindow(" .. ii .. ")")
    if true == self._ui.rdo_tabs[ii]:GetShow() then
      rdoBtns[#rdoBtns + 1] = self._ui.rdo_tabs[ii]
    end
  end
  local centerX = self._ui.stc_tabGroup:GetSizeX() * 0.5
  local rdoXGab = (self._ui.stc_tabGroup:GetSizeX() - 240) / #rdoBtns
  local rdoStartX = centerX - (rdoXGab * (#rdoBtns - 1) + self._ui.rdo_tabs[1]:GetSizeX()) * 0.5
  for ii = 1, #rdoBtns do
    rdoBtns[ii]:SetPosX(rdoStartX + rdoXGab * (ii - 1))
  end
  self._ui.txt_CharacterName = UI.getChildControl(self._ui.stc_CharacterInfoBg, "StaticText_CharacterName")
  self._ui.stc_CharacterIcon = UI.getChildControl(self._ui.txt_CharacterName, "Static_Icon")
  self._ui.txt_Journey = UI.getChildControl(self._ui.stc_CharacterInfoBg, "StaticText_Journey")
  self._ui.stc_ProfileImageBg = UI.getChildControl(self._ui.stc_CharacterInfoBg, "Static_LeftBg")
  self._ui.stc_ProfileSlot = UI.getChildControl(self._ui.stc_ProfileImageBg, "Static_Profile_Image")
  self._ui.stc_TakePicBg = UI.getChildControl(self._ui.stc_ProfileSlot, "Static_Bg")
  self._ui.stc_TakePic = UI.getChildControl(self._ui.stc_ProfileSlot, "StaticText_Take_Pic")
  self._ui.stc_TakePicBg:SetShow(false)
  self._ui.stc_TakePic:SetShow(false)
  self._ui.stc_FamilyInfoBg = UI.getChildControl(self._ui.stc_CharacterInfoBg, "Static_Fam_Info")
  self._ui.txt_FamilyPoint = UI.getChildControl(self._ui.stc_FamilyInfoBg, "StaticText_Fam_Point_Val")
  self._ui.txt_BattlePoint = UI.getChildControl(self._ui.stc_FamilyInfoBg, "StaticText_Battle_Point_Val")
  self._ui.txt_LifePoint = UI.getChildControl(self._ui.stc_FamilyInfoBg, "StaticText_Life_Point_Val")
  self._ui.txt_SpecialPoint = UI.getChildControl(self._ui.stc_FamilyInfoBg, "StaticText_Special_Point_Val")
  self._ui.txt_Family = UI.getChildControl(self._ui.stc_FamilyInfoBg, "StaticText_Fam_Point")
  self._ui.txt_Battle = UI.getChildControl(self._ui.stc_FamilyInfoBg, "StaticText_Battle_Point")
  self._ui.txt_Life = UI.getChildControl(self._ui.stc_FamilyInfoBg, "StaticText_Life_Point")
  self._ui.txt_Special = UI.getChildControl(self._ui.stc_FamilyInfoBg, "StaticText_Special_Point")
  self._ui.edit_Introduce = UI.getChildControl(self._ui.stc_ProfileImageBg, "Edit_Introduce")
  self._ui.StaticText_IntroduceSave = UI.getChildControl(self._ui.stc_ProfileImageBg, "Static_IntroduceSave")
  self._ui.stc_StatInfoBg = UI.getChildControl(self._ui.stc_CharacterInfoBg, "Static_Stat_Basic")
  self._ui.txt_MentalTitle = UI.getChildControl(self._ui.stc_StatInfoBg, "StaticText_Mental")
  self._ui.txt_HealthPoint = UI.getChildControl(self._ui.stc_StatInfoBg, "StaticText_Health_Val")
  self._ui.txt_MentalPoint = UI.getChildControl(self._ui.stc_StatInfoBg, "StaticText_Mental_Val")
  self._ui.txt_WeightPoint = UI.getChildControl(self._ui.stc_StatInfoBg, "StaticText_Weight_Val")
  self._ui.progress_Health = UI.getChildControl(self._ui.stc_StatInfoBg, "Progress2_Health")
  self._ui.progress_Mental = UI.getChildControl(self._ui.stc_StatInfoBg, "Progress2_Mental")
  self._ui.progress_Weight = UI.getChildControl(self._ui.stc_StatInfoBg, "Progress2_Weight")
  self._ui.progress_Weight2 = UI.getChildControl(self._ui.stc_StatInfoBg, "Progress2_Weight2")
  self._ui.progress_Weight3 = UI.getChildControl(self._ui.stc_StatInfoBg, "Progress2_Weight3")
  self._ui.stc_StatBattleInfoBg = UI.getChildControl(self._ui.stc_CharacterInfoBg, "Static_Stat_Battle")
  self._ui.txt_AtkPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Atk_Val")
  self._ui.txt_DefTxt = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Def")
  self._ui.txt_DefPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Def_Val")
  self._ui.txt_StaminaTxt = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Stamina")
  self._ui.txt_StaminaPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Stamina_Val")
  self._ui.txt_AwakenAtkTxt = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Atk_Awaken")
  self._ui.txt_AwakenAtkPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Atk_Awaken_Val")
  self._ui.txt_SKillTitle = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Skill_Point_Title")
  self._ui.txt_SKillPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Skill_Point_Val")
  self._ui.txt_StaminaTxt:SetPosY(self._ui.txt_DefTxt:GetPosY())
  self._ui.txt_StaminaPoint:SetPosY(self._ui.txt_DefPoint:GetPosY())
  self._ui.txt_DefTxt:SetPosY(self._ui.txt_AwakenAtkTxt:GetPosY())
  self._ui.txt_DefPoint:SetPosY(self._ui.txt_AwakenAtkPoint:GetPosY())
  self._ui.txt_SKillTitle:SetPosY(self._ui.txt_StaminaTxt:GetPosY() + self._ui.txt_StaminaTxt:GetSizeY() + 15)
  self._ui.txt_SKillPoint:SetPosY(self._ui.txt_StaminaTxt:GetPosY() + self._ui.txt_StaminaTxt:GetSizeY() + 15)
  self._ui.txt_AwakenAtkTxt:SetShow(false)
  self._ui.txt_AwakenAtkPoint:SetShow(false)
  self._ui.stc_AbilityBg = UI.getChildControl(self._ui.stc_CharacterInfoBg, "Static_AbliltyBg")
  self._ui.txt_AtkSpeed = UI.getChildControl(self._ui.stc_AbilityBg, "StaticText_Atk_Speed")
  self._ui.txt_AtkSpeedLevel = UI.getChildControl(self._ui.stc_AbilityBg, "StaticText_Atk_Speed_Level")
  self._ui.txt_MoveSpeedLevel = UI.getChildControl(self._ui.stc_AbilityBg, "StaticText_Move_Speed_Level")
  self._ui.txt_CriticalLevel = UI.getChildControl(self._ui.stc_AbilityBg, "StaticText_Cri_Level")
  self._ui.txt_FishingLevel = UI.getChildControl(self._ui.stc_AbilityBg, "StaticText_Fish_Level")
  self._ui.txt_GatherLevel = UI.getChildControl(self._ui.stc_AbilityBg, "StaticText_Gather_Level")
  self._ui.txt_LuckLevel = UI.getChildControl(self._ui.stc_AbilityBg, "StaticText_Luck_Level")
  self._ui.txt_SlotBg = UI.getChildControl(self._ui.stc_AbilityBg, "Static_SlotBg")
  self._ui.txt_Slot = UI.getChildControl(self._ui.stc_AbilityBg, "Static_Slot")
  self._ui.txt_MinusSlot = UI.getChildControl(self._ui.stc_AbilityBg, "Static_PotentialMinusSlot")
  self._ui.stc_Potential_BarBgTemplete = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "Static_Potential_GaugeBG")
  self._ui.stc_Potential_BarTemplete = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "Static_Potential_Gauge")
  self._ui.stc_BaseInfoBg = UI.getChildControl(self._ui.stc_CharacterInfoBg, "Static_BaseInfoBg")
  self._ui.txt_Style = UI.getChildControl(self._ui.stc_BaseInfoBg, "StaticText_Style")
  self._ui.txt_Enegy = UI.getChildControl(self._ui.stc_BaseInfoBg, "StaticText_Energy")
  self._ui.txt_Contribution = UI.getChildControl(self._ui.stc_BaseInfoBg, "StaticText_Contrib")
  self._ui.txt_Star = UI.getChildControl(self._ui.stc_BaseInfoBg, "StaticText_Star")
  self._ui.txt_Count = UI.getChildControl(self._ui.stc_BaseInfoBg, "StaticText_Count")
  self._ui.txt_CountPoint = UI.getChildControl(self._ui.stc_BaseInfoBg, "StaticText_Count_Val")
  self._ui.txt_CountIcon = UI.getChildControl(self._ui.stc_BaseInfoBg, "StaticText_CountIcon")
  self._ui.txt_EnergyIcon = UI.getChildControl(self._ui.stc_BaseInfoBg, "StaticText_EnergyIcon")
  self._ui.txt_ContribIcon = UI.getChildControl(self._ui.stc_BaseInfoBg, "StaticText_ContribIcon")
  self._ui.stc_StatPotentialInfoBg = UI.getChildControl(self._ui.stc_CharacterInfoBg, "Static_Potential")
  self._ui.txt_BreathInfo = UI.getChildControl(self._ui.stc_StatPotentialInfoBg, "StaticText_Breath")
  self._ui.txt_BreathLevel = UI.getChildControl(self._ui.stc_StatPotentialInfoBg, "StaticText_Breath_level")
  self._ui.progress_Breath = UI.getChildControl(self._ui.stc_StatPotentialInfoBg, "Progress2_Breath")
  self._ui.txt_PowerInfo = UI.getChildControl(self._ui.stc_StatPotentialInfoBg, "StaticText_Power")
  self._ui.txt_PowerLevel = UI.getChildControl(self._ui.stc_StatPotentialInfoBg, "StaticText_Power_level")
  self._ui.progress_Power = UI.getChildControl(self._ui.stc_StatPotentialInfoBg, "Progress2_Power")
  self._ui.txt_HealthInfo = UI.getChildControl(self._ui.stc_StatPotentialInfoBg, "StaticText_Health")
  self._ui.txt_HealthLevel = UI.getChildControl(self._ui.stc_StatPotentialInfoBg, "StaticText_Health_level")
  self._ui.progress_Health2 = UI.getChildControl(self._ui.stc_StatPotentialInfoBg, "Progress2_Health")
  self._ui.txt_StunPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Stun_Reg_Val")
  self._ui.progress_Stun = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "Progress2_Stun")
  self._ui.txt_GrabPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Grab_Reg_Val")
  self._ui.progress_Grab = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "Progress2_Grab")
  self._ui.txt_KnockDownPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Down_Reg_Val")
  self._ui.progress_KnockDown = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "Progress2_KnockDown")
  self._ui.txt_KnockBackPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Air_Reg_Val")
  self._ui.progress_KnockBack = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "Progress2_KnockBack")
  self.keyGuideBtnGroup = {
    self._ui.txt_keyGuideY,
    self._ui.txt_keyGuideX,
    self._ui.txt_keyGuideA,
    self._ui.txt_keyGuideB
  }
  self:mpTitle_Init()
  self:potentialGauge_Init()
  self:abilitystatic_Init()
  self:XB_Contorl_Init()
  _panel:RegisterUpdateFunc("CoolTimeCountdown_UpdatePerFrame")
  self:registMessageHandler()
end
function CharacterInfo:registMessageHandler()
  registerEvent("FromClient_SelfPlayerTendencyChanged", "FromClient_CharacterInfo_Basic_TendencyChanged")
  registerEvent("FromClient_WpChanged", "FromClient_CharacterInfo_Basic_MentalChanged")
  registerEvent("FromClient_UpdateExplorePoint", "FromClient_CharacterInfo_Basic_ContributionChanged")
  registerEvent("FromClient_SelfPlayerExpChanged", "FromClient_CharacterInfo_Basic_LevelChanged")
  registerEvent("EventSelfPlayerLevelUp", "FromClient_CharacterInfo_Basic_LevelChanged")
  registerEvent("FromClient_SelfPlayerHpChanged", "FromClient_CharacterInfo_Basic_HpChanged")
  registerEvent("FromClient_SelfPlayerMpChanged", "FromClient_CharacterInfo_Basic_MpChanged")
  registerEvent("FromClient_InventoryUpdate", "FromClient_CharacterInfo_Basic_WeightChanged")
  registerEvent("FromClient_WeightChanged", "FromClient_CharacterInfo_WeightChanged")
  registerEvent("EventEquipmentUpdate", "FromClient_CharacterInfo_Basic_AttackChanged")
  registerEvent("EventStaminaUpdate", "FromClient_CharacterInfo_Basic_StaminaChanged")
  registerEvent("FromClient_SelfPlayerCombatSkillPointChanged", "FromClient_CharacterInfo_Basic_SkillPointChanged")
  registerEvent("FromClient_UpdateTolerance", "FromClient_CharacterInfo_Basic_ResistChanged")
  registerEvent("FromClient_UpdateSelfPlayerLifeExp", "FromClient_UI_CharacterInfo_Basic_CraftLevelChanged")
  registerEvent("FromClient_UpdateSelfPlayerStatPoint", "FromClient_CharacterInfo_Basic_PotentialChanged")
  registerEvent("FromClientFitnessUp", "FromClient_CharacterInfo_Basic_FitnessChanged")
  registerEvent("FromClient_ShowLifeRank", "FromClient_UI_CharacterInfo_Basic_RankChanged")
  registerEvent("onScreenResize", "FromClient_UI_CharacterInfo_Basic_ScreenResize")
  registerEvent("FromClient_PlayerTotalStat_Changed", "FromClient_CharacterInfo_PlayerTotalStat_Changed")
  registerEvent("FromClient_IntroductionFail", "FromClient_CharacterInfo_IntroductionFail")
  _panel:RegisterShowEventFunc(true, "PaGlobalFunc_CharacterInfo_ShowAni()")
  _panel:RegisterShowEventFunc(false, "PaGlobalFunc_CharacterInfo_HideAni()")
  if true == ToClient_isConsole() and false == ToClient_IsDevelopment() then
    self._ui.edit_Introduce:setXboxVirtualKeyBoardEndEvent("PaGlobalFunc_CharacterLifeInfo_EndVirtualKeyBoard")
  else
    self._ui.edit_Introduce:RegistReturnKeyEvent("PaGlobalFunc_CharacterLifeInfo_EndVirtualKeyBoard()")
  end
end
function CharacterInfo:potentialGauge_Init()
  local _sizeX = math.floor(self._potentialUIData.maxX / self._potentialUIData.limitPotentialLevel)
  local _gapX = _sizeX + 3
  self._ui.stc_PotentialBarBg = {}
  self._ui.stc_PotentialBar = {}
  for ii = 1, self.POTENTIAL_TYPE.TOTALCOUNT do
    self._ui.stc_PotentialBarBg[ii] = {}
    self._ui.stc_PotentialBar[ii] = {}
    for jj = 1, self._potentialUIData.limitPotentialLevel do
      self._ui.stc_PotentialBarBg[ii][jj] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_StatBattleInfoBg, "Static_Potential_BarBg" .. ii .. jj)
      CopyBaseProperty(self._ui.stc_Potential_BarBgTemplete, self._ui.stc_PotentialBarBg[ii][jj])
      self._ui.stc_PotentialBar[ii][jj] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_PotentialBarBg[ii][jj], "Static_Potential_Bar" .. ii .. jj)
      CopyBaseProperty(self._ui.stc_Potential_BarTemplete, self._ui.stc_PotentialBar[ii][jj])
      self._ui.stc_PotentialBarBg[ii][jj]:SetSize(_sizeX, self._potentialUIData.sizeY)
      self._ui.stc_PotentialBarBg[ii][jj]:SetPosX(self._potentialUIData.posX + _gapX * (jj - 1))
      self._ui.stc_PotentialBarBg[ii][jj]:SetPosY(self._potentialUIData.posY + self._potentialUIData.gapY * (ii - 1))
      self._ui.stc_PotentialBar[ii][jj]:SetSize(_sizeX, self._potentialUIData.sizeY)
      self._ui.stc_PotentialBar[ii][jj]:SetShow(false)
    end
  end
  self._ui.stc_Potential_BarBgTemplete:SetShow(false)
  self._ui.stc_Potential_BarTemplete:SetShow(false)
end
function CharacterInfo:abilitystatic_Init()
  for idx = 0, 4 do
    self.attackspeed_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "attackSpeed_SlotBG_" .. idx)
    CopyBaseProperty(self._ui.txt_SlotBg, self.attackspeed_SlotBG[idx])
    self.attackspeed_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.attackspeed_SlotBG[idx]:SetPosX(20)
    else
      self.attackspeed_SlotBG[idx]:SetPosX(self.attackspeed_SlotBG[idx - 1]:GetPosX() + self.attackspeed_SlotBG[idx - 1]:GetSizeX() + 5)
    end
    self.attackspeed_SlotBG[idx]:SetPosY(80)
    self.attackspeed_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "attackSpeed_Slot_" .. idx)
    CopyBaseProperty(self._ui.txt_Slot, self.attackspeed_Slot[idx])
    self.attackspeed_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.attackspeed_Slot[idx]:SetPosX(20)
    else
      self.attackspeed_Slot[idx]:SetPosX(self.attackspeed_Slot[idx - 1]:GetPosX() + self.attackspeed_Slot[idx - 1]:GetSizeX() + 5)
    end
    self.attackspeed_Slot[idx]:SetPosY(81)
    self.attackspeed_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "attackSpeed_MinusSlot_" .. idx)
    CopyBaseProperty(self._ui.txt_MinusSlot, self.attackspeed_MinusSlot[idx])
    self.attackspeed_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.attackspeed_MinusSlot[idx]:SetPosX(20)
    else
      self.attackspeed_MinusSlot[idx]:SetPosX(self.attackspeed_MinusSlot[idx - 1]:GetPosX() + self.attackspeed_MinusSlot[idx - 1]:GetSizeX() + 5)
    end
    self.attackspeed_MinusSlot[idx]:SetPosY(80)
    self.castspeed_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "castspeed_SlotBG_" .. idx)
    CopyBaseProperty(self._ui.txt_SlotBg, self.castspeed_SlotBG[idx])
    self.castspeed_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.castspeed_SlotBG[idx]:SetPosX(20)
    else
      self.castspeed_SlotBG[idx]:SetPosX(self.castspeed_SlotBG[idx - 1]:GetPosX() + self.castspeed_SlotBG[idx - 1]:GetSizeX() + 5)
    end
    self.castspeed_SlotBG[idx]:SetPosY(80)
    self.castspeed_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "castspeed_Slot_" .. idx)
    CopyBaseProperty(self._ui.txt_Slot, self.castspeed_Slot[idx])
    self.castspeed_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.castspeed_Slot[idx]:SetPosX(20)
    else
      self.castspeed_Slot[idx]:SetPosX(self.castspeed_Slot[idx - 1]:GetPosX() + self.castspeed_Slot[idx - 1]:GetSizeX() + 5)
    end
    self.castspeed_Slot[idx]:SetPosY(81)
    self.castspeed_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "castspeed_MinusSlot_" .. idx)
    CopyBaseProperty(self._ui.txt_MinusSlot, self.castspeed_MinusSlot[idx])
    self.castspeed_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.castspeed_MinusSlot[idx]:SetPosX(20)
    else
      self.castspeed_MinusSlot[idx]:SetPosX(self.castspeed_MinusSlot[idx - 1]:GetPosX() + self.castspeed_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    self.castspeed_MinusSlot[idx]:SetPosY(80)
    self.movespeed_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "movespeed_SlotBG_" .. idx)
    CopyBaseProperty(self._ui.txt_SlotBg, self.movespeed_SlotBG[idx])
    self.movespeed_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.movespeed_SlotBG[idx]:SetPosX(20)
    else
      self.movespeed_SlotBG[idx]:SetPosX(self.movespeed_SlotBG[idx - 1]:GetPosX() + self.movespeed_SlotBG[idx - 1]:GetSizeX() + 5)
    end
    self.movespeed_SlotBG[idx]:SetPosY(135)
    self.movespeed_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "movespeed_Slot_" .. idx)
    CopyBaseProperty(self._ui.txt_Slot, self.movespeed_Slot[idx])
    self.movespeed_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.movespeed_Slot[idx]:SetPosX(20)
    else
      self.movespeed_Slot[idx]:SetPosX(self.movespeed_Slot[idx - 1]:GetPosX() + self.movespeed_Slot[idx - 1]:GetSizeX() + 5)
    end
    self.movespeed_Slot[idx]:SetPosY(136)
    self.movespeed_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "movespeed_MinusSlot_" .. idx)
    CopyBaseProperty(self._ui.txt_MinusSlot, self.movespeed_MinusSlot[idx])
    self.movespeed_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.movespeed_MinusSlot[idx]:SetPosX(20)
    else
      self.movespeed_MinusSlot[idx]:SetPosX(self.movespeed_MinusSlot[idx - 1]:GetPosX() + self.movespeed_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    self.movespeed_MinusSlot[idx]:SetPosY(135)
    self.critical_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "critical_SlotBG_" .. idx)
    CopyBaseProperty(self._ui.txt_SlotBg, self.critical_SlotBG[idx])
    self.critical_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.critical_SlotBG[idx]:SetPosX(20)
    else
      self.critical_SlotBG[idx]:SetPosX(self.critical_SlotBG[idx - 1]:GetPosX() + self.critical_SlotBG[idx - 1]:GetSizeX() + 5)
    end
    self.critical_SlotBG[idx]:SetPosY(190)
    self.critical_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "critical_Slot_" .. idx)
    CopyBaseProperty(self._ui.txt_Slot, self.critical_Slot[idx])
    self.critical_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.critical_Slot[idx]:SetPosX(20)
    else
      self.critical_Slot[idx]:SetPosX(self.critical_Slot[idx - 1]:GetPosX() + self.critical_Slot[idx - 1]:GetSizeX() + 5)
    end
    self.critical_Slot[idx]:SetPosY(191)
    self.critical_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "critical_MinusSlot_" .. idx)
    CopyBaseProperty(self._ui.txt_MinusSlot, self.critical_MinusSlot[idx])
    self.critical_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.critical_MinusSlot[idx]:SetPosX(20)
    else
      self.critical_MinusSlot[idx]:SetPosX(self.critical_MinusSlot[idx - 1]:GetPosX() + self.critical_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    self.critical_MinusSlot[idx]:SetPosY(190)
    self.fishTime_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "fishTime_SlotBG_" .. idx)
    CopyBaseProperty(self._ui.txt_SlotBg, self.fishTime_SlotBG[idx])
    self.fishTime_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.fishTime_SlotBG[idx]:SetPosX(20)
    else
      self.fishTime_SlotBG[idx]:SetPosX(self.fishTime_SlotBG[idx - 1]:GetPosX() + self.fishTime_SlotBG[idx - 1]:GetSizeX() + 5)
    end
    self.fishTime_SlotBG[idx]:SetPosY(245)
    self.fishTime_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "fishTime_Slot_" .. idx)
    CopyBaseProperty(self._ui.txt_Slot, self.fishTime_Slot[idx])
    self.fishTime_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.fishTime_Slot[idx]:SetPosX(20)
    else
      self.fishTime_Slot[idx]:SetPosX(self.fishTime_Slot[idx - 1]:GetPosX() + self.fishTime_Slot[idx - 1]:GetSizeX() + 5)
    end
    self.fishTime_Slot[idx]:SetPosY(246)
    self.fishTime_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "fishTime_MinusSlot_" .. idx)
    CopyBaseProperty(self._ui.txt_MinusSlot, self.fishTime_MinusSlot[idx])
    self.fishTime_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.fishTime_MinusSlot[idx]:SetPosX(20)
    else
      self.fishTime_MinusSlot[idx]:SetPosX(self.fishTime_MinusSlot[idx - 1]:GetPosX() + self.fishTime_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    self.fishTime_MinusSlot[idx]:SetPosY(245)
    self.product_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "product_SlotBG_" .. idx)
    CopyBaseProperty(self._ui.txt_SlotBg, self.product_SlotBG[idx])
    self.product_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.product_SlotBG[idx]:SetPosX(20)
    else
      self.product_SlotBG[idx]:SetPosX(self.product_SlotBG[idx - 1]:GetPosX() + self.product_SlotBG[idx - 1]:GetSizeX() + 5)
    end
    self.product_SlotBG[idx]:SetPosY(300)
    self.product_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "product_Slot_" .. idx)
    CopyBaseProperty(self._ui.txt_Slot, self.product_Slot[idx])
    self.product_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.product_Slot[idx]:SetPosX(20)
    else
      self.product_Slot[idx]:SetPosX(self.product_Slot[idx - 1]:GetPosX() + self.product_Slot[idx - 1]:GetSizeX() + 5)
    end
    self.product_Slot[idx]:SetPosY(301)
    self.product_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "product_MinusSlot_" .. idx)
    CopyBaseProperty(self._ui.txt_MinusSlot, self.product_MinusSlot[idx])
    self.product_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.product_MinusSlot[idx]:SetPosX(20)
    else
      self.product_MinusSlot[idx]:SetPosX(self.product_MinusSlot[idx - 1]:GetPosX() + self.product_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    self.product_MinusSlot[idx]:SetPosY(300)
    self.dropChance_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "dropChance_SlotBG_" .. idx)
    CopyBaseProperty(self._ui.txt_SlotBg, self.dropChance_SlotBG[idx])
    self.dropChance_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.dropChance_SlotBG[idx]:SetPosX(20)
    else
      self.dropChance_SlotBG[idx]:SetPosX(self.dropChance_SlotBG[idx - 1]:GetPosX() + self.dropChance_SlotBG[idx - 1]:GetSizeX() + 5)
    end
    self.dropChance_SlotBG[idx]:SetPosY(355)
    self.dropChance_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "dropChance_Slot_" .. idx)
    CopyBaseProperty(self._ui.txt_Slot, self.dropChance_Slot[idx])
    self.dropChance_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.dropChance_Slot[idx]:SetPosX(20)
    else
      self.dropChance_Slot[idx]:SetPosX(self.dropChance_Slot[idx - 1]:GetPosX() + self.dropChance_Slot[idx - 1]:GetSizeX() + 5)
    end
    self.dropChance_Slot[idx]:SetPosY(356)
    self.dropChance_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_AbilityBg, "dropChance_MinusSlot_" .. idx)
    CopyBaseProperty(self._ui.txt_MinusSlot, self.dropChance_MinusSlot[idx])
    self.dropChance_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.dropChance_MinusSlot[idx]:SetPosX(20)
    else
      self.dropChance_MinusSlot[idx]:SetPosX(self.dropChance_MinusSlot[idx - 1]:GetPosX() + self.dropChance_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    self.dropChance_MinusSlot[idx]:SetPosY(355)
  end
end
function CharacterInfo:mpTitle_Init()
  self._player = getSelfPlayer()
  if UI_classType.ClassType_Ranger == self._player:getClassType() or UI_classType.ClassType_ShyWomen == self._player:getClassType() then
    self._ui.txt_MentalTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_EP"))
    self._ui.progress_Mental:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.progress_Mental, 2, 71, 232, 76)
    self._ui.progress_Mental:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.progress_Mental:setRenderTexture(self._ui.progress_Mental:getBaseTexture())
  elseif UI_classType.ClassType_Warrior == self._player:getClassType() or UI_classType.ClassType_Giant == self._player:getClassType() or UI_classType.ClassType_BladeMaster == self._player:getClassType() or UI_classType.ClassType_BladeMasterWomen == self._player:getClassType() or UI_classType.ClassType_NinjaWomen == self._player:getClassType() or UI_classType.ClassType_NinjaMan == self._player:getClassType() or UI_classType.ClassType_Combattant == self._player:getClassType() or UI_classType.ClassType_CombattantWomen == self._player:getClassType() then
    self._ui.txt_MentalTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_FP"))
    self._ui.progress_Mental:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.progress_Mental, 2, 57, 232, 62)
    self._ui.progress_Mental:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.progress_Mental:setRenderTexture(self._ui.progress_Mental:getBaseTexture())
  elseif UI_classType.ClassType_Sorcerer == self._player:getClassType() or UI_classType.ClassType_Tamer == self._player:getClassType() or UI_classType.ClassType_Wizard == self._player:getClassType() or UI_classType.ClassType_WizardWomen == self._player:getClassType() then
    self._ui.txt_MentalTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_MP"))
    self._ui.progress_Mental:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.progress_Mental, 2, 64, 232, 69)
    self._ui.progress_Mental:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.progress_Mental:setRenderTexture(self._ui.progress_Mental:getBaseTexture())
  elseif UI_classType.ClassType_Valkyrie == self._player:getClassType() then
    self._ui.txt_MentalTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_BP"))
    self._ui.progress_Mental:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.progress_Mental, 2, 250, 232, 255)
    self._ui.progress_Mental:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.progress_Mental:setRenderTexture(self._ui.progress_Mental:getBaseTexture())
  elseif UI_classType.ClassType_DarkElf == self._player:getClassType() then
    self._ui.txt_MentalTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_MP_DARKELF"))
    self._ui.progress_Mental:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/default_gauges_03.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.progress_Mental, 1, 1, 256, 10)
    self._ui.progress_Mental:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.progress_Mental:setRenderTexture(self._ui.progress_Mental:getBaseTexture())
  end
end
function CharacterInfo:update()
  self._player = getSelfPlayer()
  self._playerGet = self._player:get()
  FromClient_CharacterInfo_Basic_LevelChanged()
  local _totalPlayTime = Util.Time.timeFormatting_Minute(Int64toInt32(ToClient_GetCharacterPlayTime()))
  self._ui.txt_Journey:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CONTRACT_TIME_BLACKSPIRIT") .. "<PAColor0xFFFFC730> " .. _totalPlayTime .. "<PAOldColor> ")
  local classType = self._player:getClassType()
  local classSymbol = UI_ClassSymbol[classType]
  self._ui.stc_CharacterIcon:ChangeTextureInfoName(classSymbol[1])
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_CharacterIcon, classSymbol[2], classSymbol[3], classSymbol[4], classSymbol[5])
  self._ui.stc_CharacterIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui.stc_CharacterIcon:setRenderTexture(self._ui.stc_CharacterIcon:getBaseTexture())
  local totalPlayTime = Util.Time.timeFormatting_Minute(Int64toInt32(ToClient_GetCharacterPlayTime()))
  self._ui.txt_Journey:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CONTRACT_TIME_BLACKSPIRIT") .. "<PAColor0xFFFFC730> " .. totalPlayTime .. "<PAOldColor> ")
  self._ui.txt_Journey:SetSize(self._ui.txt_Journey:GetTextSizeX(), self._ui.txt_Journey:GetSizeY())
  self._ui.txt_Journey:ComputePos()
  local battleFP = self._playerGet:getBattleFamilyPoint()
  local lifeFP = self._playerGet:getLifeFamilyPoint()
  local etcFP = self._playerGet:getEtcFamilyPoint()
  local sumFP = battleFP + lifeFP + etcFP
  self._ui.txt_FamilyPoint:SetText(tostring(sumFP))
  self._ui.txt_BattlePoint:SetText(tostring(battleFP))
  self._ui.txt_LifePoint:SetText(tostring(lifeFP))
  self._ui.txt_SpecialPoint:SetText(tostring(etcFP))
  self._ui.edit_Introduce:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.edit_Introduce:SetMaxEditLine(3)
  self._ui.edit_Introduce:SetMaxInput(70)
  local msg = ToClient_GetUserIntroduction()
  if "" == msg then
    self._ui.edit_Introduce:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_MYINTRODUCE_INPUT"), true)
    self._ui.edit_Introduce:SetFontColor(Defines.Color.C_FF525B6D)
  else
    self._ui.edit_Introduce:SetEditText(msg, true)
    self._ui.edit_Introduce:SetFontColor(Defines.Color.C_FFEEEEEE)
  end
  self._ui.stc_CharacterInfoBg:registerPadEvent(__eConsoleUIPadEvent_Up_X, "InputMLUp_CharacterInfo_Edit_Introduce()")
  self:updateFacePhoto()
  FromClient_CharacterInfo_Basic_HpChanged()
  FromClient_CharacterInfo_Basic_MpChanged()
  FromClient_CharacterInfo_Basic_WeightChanged()
  local _defaultCount = self._playerGet:getEnchantFailCount()
  local _valksCount = self._playerGet:getEnchantValuePackCount()
  self._ui.txt_CountPoint:SetText(_defaultCount + _valksCount)
  self._ui.txt_CountIcon:SetHorizonRight()
  self._ui.txt_CountIcon:SetSpanSize(self._ui.txt_CountPoint:GetTextSizeX() + 5, 2)
  FromClient_CharacterInfo_Basic_AttackChanged()
  FromClient_CharacterInfo_Basic_StaminaChanged()
  FromClient_CharacterInfo_Basic_SkillPointChanged()
  FromClient_CharacterInfo_Basic_PotentialChanged()
  FromClient_CharacterInfo_Basic_TendencyChanged()
  FromClient_CharacterInfo_Basic_MentalChanged()
  FromClient_CharacterInfo_Basic_ContributionChanged()
  local _zodiacName = self._player:getZodiacSignOrderStaticStatusWrapper():getZodiacName()
  self._ui.txt_Star:SetText(tostring(_zodiacName))
  FromClient_CharacterInfo_Basic_FitnessChanged(0, 0, 0, 0)
  FromClient_CharacterInfo_Basic_ResistChanged()
end
function CharacterInfo:ShowNextTab(isLeft)
  if true == isLeft then
    if 1 < self._currentTab then
      self._currentTab = self._currentTab - 1
    else
      self._currentTab = self._maxPanelTypeNumber
    end
    InputMLUp_TapToOpenWindow(self._currentTab)
  else
    if self._currentTab < self._maxPanelTypeNumber then
      self._currentTab = self._currentTab + 1
    else
      self._currentTab = 1
    end
    InputMLUp_TapToOpenWindow(self._currentTab)
  end
end
function PaGlobalFunc_CharacterLifeInfo_ClearFocus()
  local self = CharacterInfo
  self._ui.edit_Introduce:SetEditText(self._ui.edit_Introduce:GetEditText(), true)
  ToClient_RequestSetUserIntroduction(self._ui.edit_Introduce:GetText())
  ClearFocusEdit()
  self._ui.edit_Introduce:addInputEvent("Mouse_LUp", "InputMLUp_CharacterInfo_Edit_Introduce()")
  self._ui.stc_CharacterInfoBg:registerPadEvent(__eConsoleUIPadEvent_Up_X, "InputMLUp_CharacterInfo_Edit_Introduce()")
end
function PaGlobalFunc_CharacterLifeInfo_EndVirtualKeyBoard(str)
  local self = CharacterInfo
  if false == ToClient_isConsole() then
    str = self._ui.edit_Introduce:GetEditText()
  end
  if getGameServiceTypeCharacterNameLength() < string.len(str) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrInputTooLong"))
    str = string.sub(str, 1, getGameServiceTypeCharacterNameLength())
  end
  self._ui.edit_Introduce:SetEditText(str, true)
  ToClient_RequestSetUserIntroduction(str)
  ClearFocusEdit()
  self._ui.stc_CharacterInfoBg:registerPadEvent(__eConsoleUIPadEvent_Up_X, "InputMLUp_CharacterInfo_Edit_Introduce()")
end
function InputMLUp_CharacterInfo_Edit_Introduce()
  local self = CharacterInfo
  if true == ToClient_isPS4() and false == ToClient_isUserCreateContentsAllowed() then
    ToClient_SystemMsgDialogPS4(__ePS4SystemMsgDialogType_TRC_PSN_UGC_RESTRICTION)
    return
  end
  self._ui.edit_Introduce:SetFontColor(Defines.Color.C_FFEEEEEE)
  ClearFocusEdit()
  self._ui.edit_Introduce:SetEditText(self._ui.edit_Introduce:GetEditText(), true)
  self._ui.edit_Introduce:SetMaxInput(getGameServiceTypePetNameLength())
  self._ui.edit_Introduce:addInputEvent("Mouse_LUp", "PaGlobalFunc_CharacterLifeInfo_ClearFocus()")
  SetFocusEdit(self._ui.edit_Introduce)
end
function InputPadY_CharacterInfo_AccountLinking()
  if _ContentsGroup_Console_AccountLinking then
    PaGlobalFunc_AccountLinking_Open()
  end
end
function PaGlobalFunc_CharacterInfo_UpdateFacePhoto()
  local self = CharacterInfo
  CharacterInfo:updateFacePhoto()
end
function CharacterInfo:updateFacePhoto()
  local classType = self._player:getClassType()
  local TextureName = ToClient_GetCharacterFaceTexturePath(self._player:getCharacterNo_64())
  local isCaptureExist = self._ui.stc_ProfileSlot:ChangeTextureInfoNameNotDDS(TextureName, classType, true)
  if isCaptureExist == true then
    self._ui.stc_ProfileSlot:getBaseTexture():setUV(0, 0, 1, 1)
  else
    local DefaultFace = UI_DefaultFaceTexture[classType]
    self._ui.stc_ProfileSlot:ChangeTextureInfoName(DefaultFace[1])
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_ProfileSlot, DefaultFace[2], DefaultFace[3], DefaultFace[4], DefaultFace[5])
    self._ui.stc_ProfileSlot:getBaseTexture():setUV(x1, y1, x2, y2)
  end
  self._ui.stc_ProfileSlot:setRenderTexture(self._ui.stc_ProfileSlot:getBaseTexture())
end
function InputMLUp_CharacterInfo_TakePicButton()
  FGlobal_InGameCustomize_SetCharacterInfo(true)
  IngameCustomize_Show()
end
function FromClient_CharacterInfo_Basic_HpChanged()
  local self = CharacterInfo
  if _panel:IsShow() == false then
    return
  end
  local _hp = self._playerGet:getHp()
  local _maxHp = self._playerGet:getMaxHp()
  local _hpRate = _hp / _maxHp * 100
  self._ui.txt_HealthPoint:SetText(tostring(_hp) .. " / " .. tostring(_maxHp))
  self._ui.progress_Health:SetProgressRate(_hpRate)
end
function FromClient_CharacterInfo_Basic_MpChanged()
  local self = CharacterInfo
  if _panel:IsShow() == false then
    return
  end
  local _mp = self._playerGet:getMp()
  local _maxMp = self._playerGet:getMaxMp()
  local _mpRate = _mp / _maxMp * 100
  self._ui.txt_MentalPoint:SetText(tostring(_mp) .. " / " .. tostring(_maxMp))
  self._ui.progress_Mental:SetProgressRate(_mpRate)
end
function FromClient_CharacterInfo_Basic_WeightChanged()
  local self = CharacterInfo
  if _panel:IsShow() == false then
    return
  end
  local _const = Defines.s64_const
  local s64_moneyWeight = self._playerGet:getInventory():getMoneyWeight_s64()
  local s64_equipmentWeight = self._playerGet:getEquipment():getWeight_s64()
  local s64_allWeight = self._playerGet:getCurrentWeight_s64()
  local s64_maxWeight = self._playerGet:getPossessableWeight_s64()
  local s64_allWeight_div = s64_allWeight / _const.s64_100
  local s64_maxWeight_div = s64_maxWeight / _const.s64_100
  local str_AllWeight = string.format("%.1f", Int64toInt32(s64_allWeight_div) / 100)
  local str_MaxWeight = string.format("%.0f", Int64toInt32(s64_maxWeight_div) / 100)
  if s64_allWeight_div <= s64_maxWeight_div then
    self._ui.progress_Weight = UI.getChildControl(self._ui.stc_StatInfoBg, "Progress2_Weight")
    self._ui.progress_Weight3:SetProgressRate(Int64toInt32(s64_moneyWeight / s64_maxWeight_div))
    self._ui.progress_Weight2:SetProgressRate(Int64toInt32((s64_moneyWeight + s64_equipmentWeight) / s64_maxWeight_div))
    self._ui.progress_Weight:SetProgressRate(Int64toInt32(s64_allWeight / s64_maxWeight_div))
  else
    self._ui.progress_Weight3:SetProgressRate(Int64toInt32(s64_moneyWeight / s64_allWeight_div))
    self._ui.progress_Weight2:SetProgressRate(Int64toInt32((s64_moneyWeight + s64_equipmentWeight) / s64_allWeight_div))
    self._ui.progress_Weight:SetProgressRate(Int64toInt32(s64_allWeight / s64_allWeight_div))
  end
  self._ui.txt_WeightPoint:SetText(tostring(str_AllWeight) .. " / " .. tostring(str_MaxWeight) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT"))
end
function FromClient_CharacterInfo_Basic_AttackChanged()
  local self = CharacterInfo
  if _panel:IsShow() == false then
    return
  end
  ToClient_updateAttackStat()
  local _charAttack = ToClient_getOffence()
  self._ui.txt_AtkPoint:SetText(tostring(_charAttack))
  local _charAwakenAttack = ToClient_getAwakenOffence()
  self._ui.txt_AwakenAtkPoint:SetText(tostring(_charAwakenAttack))
  local _charDefence = ToClient_getDefence()
  self._ui.txt_DefPoint:SetText(tostring(_charDefence))
  self._ui.stc_StatBattleInfoBg = UI.getChildControl(self._ui.stc_CharacterInfoBg, "Static_Stat_Battle")
  self._ui.txt_AtkPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Atk_Val")
  self._ui.txt_AwakenAtkPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Atk_Awaken_Val")
  self._ui.txt_DefPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Def_Val")
  self._ui.txt_StaminaPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Stamina_Val")
  self._ui.txt_SKillPoint = UI.getChildControl(self._ui.stc_StatBattleInfoBg, "StaticText_Skill_Point_Val")
end
function FromClient_CharacterInfo_Basic_SkillPointChanged()
  local self = CharacterInfo
  if _panel:IsShow() == false then
    return
  end
  local _skillPointInfo = ToClient_getSkillPointInfo(0)
  if nil ~= _skillPointInfo then
    self._ui.txt_SKillPoint:SetText(tostring(_skillPointInfo._remainPoint .. " / " .. _skillPointInfo._acquirePoint))
  end
end
function FromClient_CharacterInfo_Basic_StaminaChanged()
  local self = CharacterInfo
  if _panel:IsShow() == false then
    return
  end
  local _maxStamina = self._playerGet:getStamina():getMaxSp()
  self._ui.txt_StaminaPoint:SetText(tostring(_maxStamina))
end
function FromClient_CharacterInfo_Basic_PotentialChanged()
  local self = CharacterInfo
  if _panel:IsShow() == false then
    return
  end
  local levelText = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_POTENLEVEL")
  local classType = self._player:getClassType()
  local _txt_PotentialDisplay = {
    [1] = self._ui.txt_AtkSpeedLevel,
    [2] = self._ui.txt_MoveSpeedLevel,
    [3] = self._ui.txt_CriticalLevel,
    [4] = self._ui.txt_FishingLevel,
    [5] = self._ui.txt_GatherLevel,
    [6] = self._ui.txt_LuckLevel
  }
  local _potentialData = {
    [1] = self._player:characterStatPointSpeed(self.POTENTIAL_TYPE.ATTACKSPEED + Class_BattleSpeed[classType]) - 5,
    [2] = self._player:characterStatPointSpeed(self.POTENTIAL_TYPE.MOVESPEED) - 5,
    [3] = self._player:characterStatPointCritical(),
    [4] = self._player:getCharacterStatPointFishing(),
    [5] = self._player:getCharacterStatPointCollection(),
    [6] = self._player:getCharacterStatPointDropItem()
  }
  local battleSpeed = CppEnums.ClassType_BattleSpeed[classType]
  if battleSpeed == CppEnums.BattleSpeedType.SpeedType_Cast then
    self._ui.txt_AtkSpeed:SetText(PAGetString(Defines.StringSheet_RESOURCE, "CHARACTERINFO_TEXT_CASTSPEED"))
  else
    self._ui.txt_AtkSpeed:SetText(PAGetString(Defines.StringSheet_RESOURCE, "CHARACTERINFO_TEXT_ATTACKSPEED"))
  end
  for ii = 1, self.POTENTIAL_TYPE.TOTALCOUNT do
    if self._potentialUIData.limitPotentialLevel <= _potentialData[ii] then
      _potentialData[ii] = self._potentialUIData.limitPotentialLevel
    end
    _txt_PotentialDisplay[ii]:SetText(_potentialData[ii] .. " " .. levelText)
    for jj = 1, self._potentialUIData.limitPotentialLevel do
      if jj <= _potentialData[ii] then
        self._ui.stc_PotentialBar[ii][jj]:SetShow(true)
      else
        self._ui.stc_PotentialBar[ii][jj]:SetShow(false)
      end
    end
  end
  local player = getSelfPlayer()
  local playerGet = player:get()
  local potentialType = {
    move = 0,
    attack = 1,
    cast = 2,
    levelText = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_POTENLEVEL")
  }
  if battleSpeed == CppEnums.BattleSpeedType.SpeedType_Attack then
    local currentAttackSpeedPoint = player:characterStatPointSpeed(potentialType.attack)
    local limitAttackSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.attack)
    if currentAttackSpeedPoint > limitAttackSpeedPoint then
      currentAttackSpeedPoint = limitAttackSpeedPoint
    end
    local equipedAttackSpeedPoint = currentAttackSpeedPoint - 5
    local maxAttackSpeedPoint = limitAttackSpeedPoint - 5
    for Idx = 0, 4 do
      self.attackspeed_SlotBG[Idx]:SetShow(false)
      self.attackspeed_Slot[Idx]:SetShow(false)
      self.attackspeed_MinusSlot[Idx]:SetShow(false)
    end
    for bg_Idx = 0, maxAttackSpeedPoint - 1 do
      self.attackspeed_SlotBG[bg_Idx]:SetShow(true)
    end
    if equipedAttackSpeedPoint > 0 then
      for slot_Idx = 0, equipedAttackSpeedPoint - 1 do
        self.attackspeed_Slot[slot_Idx]:SetShow(true)
      end
    else
      local minus_equipedAttackSpeedPoint = -equipedAttackSpeedPoint
      for slot_Idx = 0, minus_equipedAttackSpeedPoint - 1 do
        self.attackspeed_MinusSlot[slot_Idx]:SetShow(true)
      end
    end
  end
  if battleSpeed == CppEnums.BattleSpeedType.SpeedType_Cast then
    local currentCastingSpeedPoint = player:characterStatPointSpeed(potentialType.cast)
    local limitCastingSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.cast)
    if currentCastingSpeedPoint > limitCastingSpeedPoint then
      currentCastingSpeedPoint = limitCastingSpeedPoint
    end
    local equipedCastingSpeedPoint = currentCastingSpeedPoint - 5
    local maxCastingSpeedPoint = limitCastingSpeedPoint - 5
    for Idx = 0, 4 do
      self.castspeed_SlotBG[Idx]:SetShow(false)
      self.castspeed_Slot[Idx]:SetShow(false)
      self.castspeed_MinusSlot[Idx]:SetShow(false)
    end
    for bg_Idx = 0, maxCastingSpeedPoint - 1 do
      self.castspeed_SlotBG[bg_Idx]:SetShow(true)
    end
    if equipedCastingSpeedPoint > 0 then
      for slot_Idx = 0, equipedCastingSpeedPoint - 1 do
        self.castspeed_Slot[slot_Idx]:SetShow(true)
      end
    else
      local minus_equipedCastingSpeedPoint = -equipedCastingSpeedPoint
      for slot_Idx = 0, minus_equipedCastingSpeedPoint - 1 do
        self.castspeed_MinusSlot[slot_Idx]:SetShow(true)
      end
    end
  end
  local currentMoveSpeedPoint = player:characterStatPointSpeed(potentialType.move)
  local limitMoveSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.move)
  if currentMoveSpeedPoint > limitMoveSpeedPoint then
    currentMoveSpeedPoint = limitMoveSpeedPoint
  end
  local equipedMoveSpeedPoint = currentMoveSpeedPoint - 5
  local maxMoveSpeedPoint = limitMoveSpeedPoint - 5
  for Idx = 0, 4 do
    self.movespeed_SlotBG[Idx]:SetShow(false)
    self.movespeed_Slot[Idx]:SetShow(false)
    self.movespeed_MinusSlot[Idx]:SetShow(false)
  end
  for bg_Idx = 0, maxMoveSpeedPoint - 1 do
    self.movespeed_SlotBG[bg_Idx]:SetShow(true)
  end
  if equipedMoveSpeedPoint > 0 then
    for slot_Idx = 0, equipedMoveSpeedPoint - 1 do
      self.movespeed_Slot[slot_Idx]:SetShow(true)
    end
  else
    local minus_equipedMoveSpeedPoint = -equipedMoveSpeedPoint
    for slot_Idx = 0, minus_equipedMoveSpeedPoint - 1 do
      self.movespeed_MinusSlot[slot_Idx]:SetShow(true)
    end
  end
  local currentCriticalRatePoint = player:characterStatPointCritical()
  local limitCriticalRatePoint = player:characterStatPointLimitedCritical()
  if currentCriticalRatePoint > limitCriticalRatePoint then
    currentCriticalRatePoint = limitCriticalRatePoint
  end
  local equipedCriticalRatePoint = currentCriticalRatePoint
  local maxCriticalRatePoint = limitCriticalRatePoint
  for Idx = 0, 4 do
    self.critical_SlotBG[Idx]:SetShow(false)
    self.critical_Slot[Idx]:SetShow(false)
    self.critical_MinusSlot[Idx]:SetShow(false)
  end
  for bg_Idx = 0, maxCriticalRatePoint - 1 do
    self.critical_SlotBG[bg_Idx]:SetShow(true)
  end
  if equipedCriticalRatePoint > 0 then
    for slot_Idx = 0, equipedCriticalRatePoint - 1 do
      self.critical_Slot[slot_Idx]:SetShow(true)
    end
  else
    local minus_equipedCriticalRatePoint = -equipedCriticalRatePoint
    for slot_Idx = 0, minus_equipedCriticalRatePoint - 1 do
      self.critical_MinusSlot[slot_Idx]:SetShow(true)
    end
  end
  local currentFishingRatePoint = player:getCharacterStatPointFishing()
  local limitFishingRatePoint = player:getCharacterStatPointLimitedFishing()
  if currentFishingRatePoint > limitFishingRatePoint then
    currentFishingRatePoint = limitFishingRatePoint
  end
  local equipedFishingRatePoint = currentFishingRatePoint
  local maxFishingRatePoint = limitFishingRatePoint
  for Idx = 0, 4 do
    self.fishTime_Slot[Idx]:SetShow(false)
    self.fishTime_SlotBG[Idx]:SetShow(false)
    self.fishTime_MinusSlot[Idx]:SetShow(false)
  end
  for bg_Idx = 0, maxFishingRatePoint - 1 do
    self.fishTime_SlotBG[bg_Idx]:SetShow(true)
  end
  if equipedFishingRatePoint > 0 then
    for slot_Idx = 0, equipedFishingRatePoint - 1 do
      self.fishTime_Slot[slot_Idx]:SetShow(true)
    end
  else
    local minus_equipedFishingRatePoint = -equipedFishingRatePoint
    for slot_Idx = 0, minus_equipedFishingRatePoint - 1 do
      self.fishTime_MinusSlot[slot_Idx]:SetShow(true)
    end
  end
  local currentProductRatePoint = player:getCharacterStatPointCollection()
  local limitProductRatePoint = player:getCharacterStatPointLimitedCollection()
  if currentProductRatePoint > limitProductRatePoint then
    currentProductRatePoint = limitProductRatePoint
  end
  local equipedProductRatePoint = currentProductRatePoint
  local maxProductRatePoint = limitProductRatePoint
  for Idx = 0, 4 do
    self.product_SlotBG[Idx]:SetShow(false)
    self.product_Slot[Idx]:SetShow(false)
    self.product_MinusSlot[Idx]:SetShow(false)
  end
  for bg_Idx = 0, maxProductRatePoint - 1 do
    self.product_SlotBG[bg_Idx]:SetShow(true)
  end
  if equipedProductRatePoint > 0 then
    for slot_Idx = 0, equipedProductRatePoint - 1 do
      self.product_Slot[slot_Idx]:SetShow(true)
    end
  else
    local minus_equipedProductRatePoint = -equipedProductRatePoint
    for slot_Idx = 0, minus_equipedProductRatePoint - 1 do
      self.product_MinusSlot[slot_Idx]:SetShow(true)
    end
  end
  local currentDropItemRatePoint = player:getCharacterStatPointDropItem()
  local limitDropItemRatePoint = player:getCharacterStatPointLimitedDropItem()
  if currentDropItemRatePoint > limitDropItemRatePoint then
    currentDropItemRatePoint = limitDropItemRatePoint
  end
  local equipedDropItemRatePoint = currentDropItemRatePoint
  local maxDropItemRatePoint = limitDropItemRatePoint
  for Idx = 0, 4 do
    self.dropChance_SlotBG[Idx]:SetShow(false)
    self.dropChance_Slot[Idx]:SetShow(false)
    self.dropChance_MinusSlot[Idx]:SetShow(false)
  end
  for bg_Idx = 0, maxDropItemRatePoint - 1 do
    self.dropChance_SlotBG[bg_Idx]:SetShow(true)
  end
  if equipedDropItemRatePoint > 0 then
    for slot_Idx = 0, equipedDropItemRatePoint - 1 do
      self.dropChance_Slot[slot_Idx]:SetShow(true)
    end
  else
    local minus_equipedDropItemRatePoint = -equipedDropItemRatePoint
    for slot_Idx = 0, minus_equipedDropItemRatePoint - 1 do
      self.dropChance_Slot[slot_Idx]:SetShow(true)
    end
  end
end
function FromClient_CharacterInfo_Basic_TendencyChanged()
  local self = CharacterInfo
  if _panel:IsShow() == false then
    return
  end
  local _style = self._playerGet:getTendency()
  self._ui.txt_Style:SetText(tostring(_style))
end
function FromClient_CharacterInfo_Basic_MentalChanged()
  local self = CharacterInfo
  if _panel:IsShow() == false then
    return
  end
  local _mental = self._player:getWp()
  local _maxMental = self._player:getMaxWp()
  self._ui.txt_Enegy:SetText(tostring(_mental) .. " / " .. tostring(_maxMental))
  self._ui.txt_EnergyIcon:SetHorizonRight()
  self._ui.txt_EnergyIcon:SetSpanSize(self._ui.txt_Enegy:GetTextSizeX() + 4, 35)
end
function FromClient_CharacterInfo_Basic_ContributionChanged()
  local self = CharacterInfo
  if _panel:IsShow() == false then
    return
  end
  local _territoryKeyRaw = ToClient_getDefaultTerritoryKey()
  local _contribution = ToClient_getExplorePointByTerritoryRaw(_territoryKeyRaw)
  local _remainContribution = _contribution:getRemainedPoint()
  local _aquiredContribution = _contribution:getAquiredPoint()
  self._ui.txt_Contribution:SetText(tostring(_remainContribution) .. " / " .. tostring(_aquiredContribution))
  self._ui.txt_ContribIcon:SetHorizonRight()
  self._ui.txt_ContribIcon:SetSpanSize(self._ui.txt_Contribution:GetTextSizeX() + 4, 90)
end
function FromClient_CharacterInfo_Basic_FitnessChanged(addSp, addWeight, addHp, addMp)
  local self = CharacterInfo
  if _panel:IsShow() == false then
    return
  end
  if addSp > 0 then
    FGlobal_FitnessLevelUp(addSp, addWeight, addHp, addMp, self._fitness.stamina)
  elseif addWeight > 0 then
    FGlobal_FitnessLevelUp(addSp, addWeight, addHp, addMp, self._fitness.strength)
  elseif addHp > 0 or addMp > 0 then
    FGlobal_FitnessLevelUp(addSp, addWeight, addHp, addMp, self._fitness.health)
  end
  local _txt_FitnessDisplay = {
    [1] = self._ui.txt_BreathInfo,
    [2] = self._ui.txt_PowerInfo,
    [3] = self._ui.txt_HealthInfo
  }
  local _txt_FitnessLevelDisplay = {
    [1] = self._ui.txt_BreathLevel,
    [2] = self._ui.txt_PowerLevel,
    [3] = self._ui.txt_HealthLevel
  }
  local _progressFitnessDisplay = {
    [1] = self._ui.progress_Breath,
    [2] = self._ui.progress_Power,
    [3] = self._ui.progress_Health2
  }
  local _titleString = {}
  if isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeJapan() then
    _titleString = {
      [1] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_STAMINA_TITLE"),
      [2] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_STRENGTH_TITLE"),
      [3] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_HEALTH_TITLE")
    }
  else
    _titleString = {
      [1] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_STAMINA_TITLE_ONE"),
      [2] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_STRENGTH_TITLE_ONE"),
      [3] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_HEALTH_TITLE_ONE")
    }
  end
  for ii = 1, 3 do
    local current = Int64toInt32(self._playerGet:getCurrFitnessExperiencePoint(ii - 1))
    local max = Int64toInt32(self._playerGet:getDemandFItnessExperiencePoint(ii - 1))
    local rate = current / max * 100
    local level = self._playerGet:getFitnessLevel(ii - 1)
    _progressFitnessDisplay[ii]:SetProgressRate(rate)
    _txt_FitnessLevelDisplay[ii]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_CRAFTLEVEL") .. tostring(level))
    _txt_FitnessDisplay[ii]:SetText(_titleString[ii] .. " " .. tostring(ToClient_GetFitnessLevelStatus(ii - 1)))
    if ii ~= self._fitness.strength then
      if isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeJapan() then
        _txt_FitnessDisplay[ii]:SetText(_titleString[ii] .. " " .. tostring(ToClient_GetFitnessLevelStatus(ii - 1)))
      else
        _txt_FitnessDisplay[ii]:SetText(_titleString[ii])
      end
    elseif isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeJapan() then
      _txt_FitnessDisplay[ii]:SetText(_titleString[ii] .. " " .. tostring(ToClient_GetFitnessLevelStatus(ii - 1) / 10000))
    else
      _txt_FitnessDisplay[ii]:SetText(_titleString[ii])
    end
  end
end
function FromClient_CharacterInfo_Basic_ResistChanged()
  local self = CharacterInfo
  if _panel:IsShow() == false then
    return
  end
  local _data = {
    sturn = self._player:getStunResistance(),
    grab = self._player:getCatchResistance(),
    knockDown = self._player:getKnockdownResistance(),
    knockBack = self._player:getKnockbackResistance()
  }
  local _dataDisplay = {
    [1] = _data.sturn,
    [2] = _data.grab,
    [3] = _data.knockDown,
    [4] = _data.knockBack
  }
  local _registTextDisplay = {
    [1] = self._ui.txt_StunPoint,
    [2] = self._ui.txt_GrabPoint,
    [3] = self._ui.txt_KnockDownPoint,
    [4] = self._ui.txt_KnockBackPoint
  }
  local _registProgressDisplay = {
    [1] = self._ui.progress_Stun,
    [2] = self._ui.progress_Grab,
    [3] = self._ui.progress_KnockDown,
    [4] = self._ui.progress_KnockBack
  }
  for ii = 1, 4 do
    _registProgressDisplay[ii]:SetProgressRate(math.floor(_dataDisplay[ii] / 10000))
    _registTextDisplay[ii]:SetText(math.floor(_dataDisplay[ii] / 10000) .. "%")
  end
end
function PaGlobalFunc_Window_CharacterInfo_Open()
  CharacterInfo:open()
end
function CharacterInfo:open()
  _panel:SetShow(true, true)
  _AudioPostEvent_SystemUiForXBOX(1, 0)
  self:update()
  InputMLUp_TapToOpenWindow(1)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self.keyGuideBtnGroup, _panel, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobalFunc_Window_CharacterInfo_Close()
  local self = CharacterInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : CharacterInfo")
    return
  end
  self:close()
end
function PaGlobalFunc_Window_CharacterInfo_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_Window_CharacterInfo_SaveUserIntroduction()
  local self = CharacterInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : CharacterInfo")
    return
  end
  PaGlobalFunc_CharacterLifeInfo_EndVirtualKeyBoard(self._ui.edit_Introduce:GetEditText())
end
function PaGlobalFunc_CharacterInfo_CheckIntroduceUiEdit(targetUI)
  local self = CharacterInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : CharacterInfo")
    return
  end
  return nil ~= targetUI and targetUI:GetKey() == self._ui.edit_Introduce:GetKey()
end
function PaGlobalFunc_CharacterInfo_ShowRightNextTab()
  local self = CharacterInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : CharacterInfo")
    return
  end
  self:ShowNextTab(false)
end
function PaGlobalFunc_CharacterInfo_ShowLeftNextTab()
  local self = CharacterInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : CharacterInfo")
    return
  end
  self:ShowNextTab(true)
end
function PaGlobalFunc_CharacterInfo_ShowAni()
end
function PaGlobalFunc_CharacterInfo_HideAni()
end
function InputMLUp_TapToOpenWindow(index)
  local self = CharacterInfo
  Panel_Tooltip_Item_hideTooltip()
  self._currentTab = index
  for ii = 1, self._maxPanelTypeNumber do
    self._ui.tabGroups[ii]:SetShow(false)
    self._ui.rdo_tabs[ii]:SetCheck(false)
  end
  self._ui.tabGroups[index]:SetShow(true)
  self._ui.rdo_tabs[index]:SetCheck(true)
  local radioButtonXAxis = self._ui.rdo_tabs[index]:GetPosX() + self._ui.rdo_tabs[index]:GetSizeX() * 0.5
  self._ui.txt_title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "CHARACTERINFO_TEXT_TITLE") .. "  -  " .. self._tapName[index])
  self._ui.txt_keyGuideA:SetShow(false)
  self._ui.txt_keyGuideX:SetShow(false)
  self._ui.txt_keyGuideY:SetShow(false)
  if TAB_TYPE.BASIC == index then
    self._ui.txt_keyGuideY:SetShow(_ContentsGroup_Console_AccountLinking)
    self:update()
  elseif TAB_TYPE.TITLE == index then
    InputMLUp_CharacterTitleInfo_TapToOpen(0)
  elseif TAB_TYPE.HISTORY == index then
    PaGlobalFunc_CharacterHistoryInfo_Open()
  elseif TAB_TYPE.QUEST_TOGGLE == index then
    PaGlobalFunc_CharacterQuestInfo_Open()
  elseif TAB_TYPE.FOOT_STEP == index and false == _ContentsGroup_RenewUI then
    InputMLUp_CharacterProfileInfo_TapToOpen(0)
  elseif TAB_TYPE.LIFE == index then
    PaGlobalFunc_CharacterLifeInfo_Update()
  elseif TAB_TYPE.CHALLENGE == index then
    InputMLUp_CharacterChallengeInfo_TapToOpen(1)
  elseif TAB_TYPE.CASH_BUFF == index then
    PaGlobalFunc_CashBuff_Open()
  end
end
function FromClient_CharacterInfo_Basic_LevelChanged()
  local self = CharacterInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : CharacterInfo")
    return
  end
  local _playerLevel = self._player:get():getLevel()
  local _famiName = self._player:getUserNickname()
  local _charName = self._player:getOriginalName()
  self._ui.txt_CharacterName:SetText("LV." .. _playerLevel .. " " .. tostring(_charName) .. "(" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDLIST_FAMILYNAME", "name", tostring(_famiName)) .. ")")
end
function FromClient_luaLoadComplete_CharaterInfo_Init()
  local self = CharacterInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : CharacterInfo")
    return
  end
  self:init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_CharaterInfo_Init")
function PaGlobalFunc_CharacterInfoTab_PadControl(index)
  local self = CharacterInfo
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  if 0 == index then
    self:ShowNextTab(true)
  else
    self:ShowNextTab(false)
  end
end
function CharacterInfo:XB_Contorl_Init()
  _panel:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_CharacterInfoTab_PadControl(0)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_CharacterInfoTab_PadControl(1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LT, "Input_CharacterInfo_LT()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RT, "Input_CharacterInfo_RT()")
  self._ui.stc_CharacterInfoBg:registerPadEvent(__eConsoleUIPadEvent_Up_X, "InputMLUp_CharacterInfo_Edit_Introduce()")
  self._ui.stc_CharacterInfoBg:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "InputPadY_CharacterInfo_AccountLinking()")
end
function Input_CharacterInfo_LT()
  local self = CharacterInfo
  if self._currentTab == TAB_TYPE.TITLE then
    PaGlobalFunc_CharacterTitleInfoTab_PadControl(0)
  elseif self._currentTab == TAB_TYPE.HISTORY then
    InputMLUp_CharacterHistoryInfo_DecreaseMonth()
  elseif self._currentTab == TAB_TYPE.CHALLENGE then
    PaGlobalFunc_CharacterChallengeInfoTab_PadControl(0)
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self.keyGuideBtnGroup, _panel, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Input_CharacterInfo_RT()
  local self = CharacterInfo
  if self._currentTab == TAB_TYPE.TITLE then
    PaGlobalFunc_CharacterTitleInfoTab_PadControl(1)
  elseif self._currentTab == TAB_TYPE.HISTORY then
    InputMLUp_CharacterHistoryInfo_IncreaseMonth()
  elseif self._currentTab == TAB_TYPE.CHALLENGE then
    PaGlobalFunc_CharacterChallengeInfoTab_PadControl(1)
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self.keyGuideBtnGroup, _panel, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobalFunc_CharacterInfo_GetKeyGuideA()
  return CharacterInfo._ui.txt_keyGuideA
end
function PaGlobalFunc_CharacterInfo_GetKeyGuideB()
  return CharacterInfo._ui.txt_keyGuideB
end
function FromClient_CharacterInfo_IntroductionFail()
  local self = CharacterInfo
  local msg = ToClient_GetUserIntroduction()
  self._ui.edit_Introduce:SetEditText(msg, true)
end
function PaGlobalFunc_SetCharacterChallengeInfo()
  if nil == CharacterInfo then
    return
  end
  InputMLUp_TapToOpenWindow(TAB_TYPE.CHALLENGE)
end
