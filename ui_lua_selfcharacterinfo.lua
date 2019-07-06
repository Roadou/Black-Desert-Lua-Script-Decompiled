local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local UI_color = Defines.Color
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local UI_PD = CppEnums.Padding
local isFamilyPoint = ToClient_IsContentsGroupOpen("212")
local profileOpen = ToClient_IsContentsGroupOpen("271")
local CharacterInfo = {
  _frameDefaultBG_Basic = nil,
  _frameDefaultBG_Title = nil,
  _frameDefaultBG_History = nil,
  _frameDefaultBG_Challenge = nil,
  _frameDefaultBG_Profile = nil,
  BTN_Tab_Basic = nil,
  BTN_Tab_Title = nil,
  BTN_Tab_History = nil,
  BTN_Tab_Challenge = nil,
  BTN_Tab_Profile = nil,
  txt_BaseInfo_Title = nil,
  txt_CharinfoDesc = nil,
  txt_TitleDesc = nil,
  txt_HistoryDesc = nil,
  txt_ChallengeDesc = nil,
  _familyname = nil,
  _charactername = nil,
  _zodiac = nil,
  _tendency = nil,
  _mental = nil,
  _contribution = nil,
  _characterlevel = nil,
  _progress2_characterlevel = nil,
  _hpTitle = nil,
  _hpvalue = nil,
  _progress2_hp = nil,
  _mpTitle = nil,
  _mpvalue = nil,
  _progress2_mp = nil,
  _weightTitle = nil,
  _weightvalue = nil,
  _progress2_weightvalue_Money = nil,
  _progress2_weightvalue_Equip = nil,
  _progress2_weightvalue_Inventory = nil,
  _attackTitle = nil,
  _attack = nil,
  _awakenAttackTitle = nil,
  _awakenAttack = nil,
  _defenceTitle = nil,
  _defence = nil,
  _staminaTitle = nil,
  _stamina = nil,
  _battlePoint = nil,
  _battlePointIcon = nil,
  _stunTitle = nil,
  _downTitle = nil,
  _captureTitle = nil,
  _knockBackTitle = nil,
  _stunPercent = nil,
  _downPercent = nil,
  _capturePercent = nil,
  _knockBackPercent = nil,
  _gatherTitle = nil,
  _gather = nil,
  _gatherPercent = nil,
  _progress2_gather = nil,
  _manufactureTitle = nil,
  _manufacture = nil,
  _manufacturePercent = nil,
  _progress2_manufacture = nil,
  _cookingTitle = nil,
  _cooking = nil,
  _cookingPercent = nil,
  _progress2_cooking = nil,
  _alchemyTitle = nil,
  _alchemy = nil,
  _alchemyPercent = nil,
  _progress2_alchemy = nil,
  _fishingTitle = nil,
  _fishing = nil,
  _fishingPercent = nil,
  _progress2_fishing = nil,
  _huntingTitle = nil,
  _hunting = nil,
  _huntingPercent = nil,
  _progress2_hunting = nil,
  _trainingTitle = nil,
  _training = nil,
  _trainingPercent = nil,
  _progress2_training = nil,
  _tradeTitle = nil,
  _trade = nil,
  _tradePercent = nil,
  _progress2_trade = nil,
  _growthTitle = nil,
  _growth = nil,
  _growthPercent = nil,
  _progress2_growth = nil,
  _sailTitle = nil,
  _sail = nil,
  _sailPercent = nil,
  _progress2_sail = nil,
  sailProgressBG = nil,
  sailIcon = nil,
  attackspeed = nil,
  _asttackspeed = nil,
  castspeed = nil,
  _castspeed = nil,
  movespeed = nil,
  _movespeed = nil,
  critical = nil,
  _critical = nil,
  fishTime = nil,
  _fishTime = nil,
  product = nil,
  _product = nil,
  dropChance = nil,
  _dropChance = nil,
  _potentialSlot = nil,
  _potentialMinusSlot = nil,
  _potentialSlotBG = nil,
  _title_stamina = nil,
  _title_strength = nil,
  _title_health = nil,
  _progress2_stamina = nil,
  _progress2_strength = nil,
  _progress2_health = nil,
  _value_stamina = nil,
  _value_strength = nil,
  _value_health = nil,
  _progress2_resiststun = nil,
  _progress2_resistdown = nil,
  _progress2_resistcapture = nil,
  _progress2_resistknockback = nil,
  _hpRegen = nil,
  _mpRegen = nil,
  _weightTooltip = nil,
  _potenHelp = nil,
  _buttonClose = nil,
  _buttonQuestion = nil,
  checkPopUp = nil,
  _selfTimer = nil,
  _PcRoomTimer = nil,
  _todayPlayTime = nil,
  _selfTimerIcon = nil,
  _lifeTitle = nil,
  _ranker = nil,
  _btnIntroduce = nil,
  _introduce = {
    _bg = nil,
    _title = nil,
    _textBg = nil,
    _editText = nil,
    _btnSetIntro = nil,
    _btnResetIntro = nil,
    _closeIntro = nil
  },
  familyPoints = nil,
  familyCombatPoints = nil,
  familyLifePoints = nil,
  familyEtcPoints = nil,
  familyLeftBracket = nil,
  familyRightBracket = nil,
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
  dropChance_MinusSlot = {},
  potenTooltip = nil,
  fitnessTooltip = nil
}
local isPopUpContentsEnable = ToClient_IsContentsGroupOpen("240")
local currentPotencial = {
  [0] = "Attack_Speed",
  [1] = "Casting_Speed",
  [2] = "Move_Speed",
  [3] = "Critical_Rate",
  [4] = "Fishing_Rate",
  [5] = "Product_Rate",
  [6] = "Drop_Item_Rate"
}
function CharInfoStatusShowAni()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  local aniInfo1 = Panel_Window_CharInfo_Status:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.12)
  aniInfo1.AxisX = Panel_Window_CharInfo_Status:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_CharInfo_Status:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Window_CharInfo_Status:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.12)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_CharInfo_Status:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_CharInfo_Status:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function CharInfoStatusHideAni()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  local aniInfo1 = Panel_Window_CharInfo_Status:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
function FGlobal_CharInfoStatusShowAni()
  CharInfoStatusShowAni()
end
function CharacterInfo:createControl()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  CharacterInfo._frameDefaultBG_Basic = UI.getChildControl(Panel_Window_CharInfo_Status, "Static_BasicInfo")
  CharacterInfo._frameDefaultBG_Title = UI.getChildControl(Panel_Window_CharInfo_Status, "Static_TitleInfo")
  CharacterInfo._frameDefaultBG_History = UI.getChildControl(Panel_Window_CharInfo_Status, "Static_HistoryInfo")
  CharacterInfo._frameDefaultBG_Challenge = UI.getChildControl(Panel_Window_CharInfo_Status, "Static_ChallengeInfo")
  CharacterInfo._frameDefaultBG_Profile = UI.getChildControl(Panel_Window_CharInfo_Status, "Static_ProfileInfo")
  CharacterInfo.BTN_Tab_Basic = UI.getChildControl(Panel_Window_CharInfo_Status, "RadioButton_Tab_CharacterInfo")
  CharacterInfo.BTN_Tab_Title = UI.getChildControl(Panel_Window_CharInfo_Status, "RadioButton_Tab_CharacterTitle")
  CharacterInfo.BTN_Tab_History = UI.getChildControl(Panel_Window_CharInfo_Status, "RadioButton_Tab_CharacterHistory")
  CharacterInfo.BTN_Tab_Challenge = UI.getChildControl(Panel_Window_CharInfo_Status, "RadioButton_Tab_Challenge")
  CharacterInfo.BTN_Tab_Profile = UI.getChildControl(Panel_Window_CharInfo_Status, "RadioButton_Tab_Profile")
  CharacterInfo.txt_BaseInfo_Title = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Title_Base_Title")
  CharacterInfo.txt_CharinfoDesc = UI.getChildControl(Panel_Window_CharInfo_Status, "StaticText_CharinfoDesc")
  CharacterInfo.txt_TitleDesc = UI.getChildControl(Panel_Window_CharInfo_Status, "StaticText_TitleDesc")
  CharacterInfo.txt_HistoryDesc = UI.getChildControl(Panel_Window_CharInfo_Status, "StaticText_HistoryDesc")
  CharacterInfo.txt_ChallengeDesc = UI.getChildControl(Panel_Window_CharInfo_Status, "StaticText_ChallengeDesc")
  CharacterInfo._familyname = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FamilyName_Value")
  CharacterInfo._charactername = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_CharacterName_Value")
  CharacterInfo._zodiac = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Zodiac_Value")
  CharacterInfo._tendency = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Tendency_Value")
  CharacterInfo._mental = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Mental_Value")
  CharacterInfo._contribution = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Contribution_Value")
  CharacterInfo._characterlevel = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_BattleLevel_Value")
  CharacterInfo._progress2_characterlevel = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_BattleLevel_Gauge")
  CharacterInfo._hpTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_HP_Title")
  CharacterInfo._hpvalue = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_HP_Value")
  CharacterInfo._progress2_hp = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_HP_Gauge")
  CharacterInfo._mpTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_MP_Title")
  CharacterInfo._mpvalue = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_MP_value")
  CharacterInfo._progress2_mp = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_MP_Gauge")
  CharacterInfo._weightTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Weight_Title")
  CharacterInfo._weightvalue = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Weight_Value")
  CharacterInfo._progress2_weightvalue_Money = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Weight_Money")
  CharacterInfo._progress2_weightvalue_Equip = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Weight_Equip")
  CharacterInfo._progress2_weightvalue_Inventory = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Weight_Inventory")
  CharacterInfo._attackTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_AttackPower_Title")
  CharacterInfo._attack = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_AttackPower_Value")
  CharacterInfo._awakenAttackTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_AwakenAttackPower_Title")
  CharacterInfo._awakenAttack = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_AwakenAttackPower_Value")
  CharacterInfo._defenceTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Defence_Title")
  CharacterInfo._defence = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Defence_Value")
  CharacterInfo._staminaTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Stamina_Title")
  CharacterInfo._stamina = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Stamina_Value")
  CharacterInfo._battlePoint = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_BattlePoint")
  CharacterInfo._battlePointIcon = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_BattlePointIcon")
  CharacterInfo._stunTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ResistStun_Title")
  CharacterInfo._downTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ResistDown_Title")
  CharacterInfo._captureTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ResistCapture_Title")
  CharacterInfo._knockBackTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ResistKnockback_Title")
  CharacterInfo._stunPercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_RegistStun_Percent")
  CharacterInfo._downPercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_RegistDown_Percent")
  CharacterInfo._capturePercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_RegistCapture_Percent")
  CharacterInfo._knockBackPercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_RegistKnockBack_Percent")
  CharacterInfo._gatherTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_GatheringLevel_Title")
  CharacterInfo._gather = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_GatheringLevel_Value")
  CharacterInfo._gatherPercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_GatheringPercent_Value")
  CharacterInfo._progress2_gather = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_GatheringLevel_Gauge")
  CharacterInfo._manufactureTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ManufactureLevel_Title")
  CharacterInfo._manufacture = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ManufactureLevel_Value")
  CharacterInfo._manufacturePercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ManufacturePercent_Value")
  CharacterInfo._progress2_manufacture = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_ManufactureLevel_Gauge")
  CharacterInfo._cookingTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_CookingLevel_Title")
  CharacterInfo._cooking = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_CookingLevel_Value")
  CharacterInfo._cookingPercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_CookingPercent_Value")
  CharacterInfo._progress2_cooking = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_CookingLevel_Gauge")
  CharacterInfo._alchemyTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_AlchemyLevel_Title")
  CharacterInfo._alchemy = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_AlchemyLevel_Value")
  CharacterInfo._alchemyPercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_AlchemyPercent_Value")
  CharacterInfo._progress2_alchemy = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_AlchemyLevel_Gauge")
  CharacterInfo._fishingTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FishingLevel_Title")
  CharacterInfo._fishing = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FishingLevel_Value")
  CharacterInfo._fishingPercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FishingPercent_Value")
  CharacterInfo._progress2_fishing = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_FishingLevel_Gauge")
  CharacterInfo._huntingTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_HuntingLevel_Title")
  CharacterInfo._hunting = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_HuntingLevel_Value")
  CharacterInfo._huntingPercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_HuntingPercent_Value")
  CharacterInfo._progress2_hunting = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_HuntingLevel_Gauge")
  CharacterInfo._trainingTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_TrainingLevel_Title")
  CharacterInfo._training = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_TrainingLevel_Value")
  CharacterInfo._trainingPercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_TrainingPercent_Value")
  CharacterInfo._progress2_training = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_TrainingLevel_Gauge")
  CharacterInfo._tradeTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Trade")
  CharacterInfo._trade = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Trade_Value")
  CharacterInfo._tradePercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_TradePercent_Value")
  CharacterInfo._progress2_trade = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Trade")
  CharacterInfo._growthTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_GrowthLevel_Title")
  CharacterInfo._growth = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_GrowthLevel_Value")
  CharacterInfo._growthPercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_GrowthPercent_Value")
  CharacterInfo._progress2_growth = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_GrowthLevel_Gauge")
  CharacterInfo._sailTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_SailLevel_Title")
  CharacterInfo._sail = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_SailLevel_Value")
  CharacterInfo._sailPercent = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_SailPercent_Value")
  CharacterInfo._progress2_sail = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_SailLevel_Gauge")
  CharacterInfo.sailProgressBG = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_SailLevel_GaugeBG")
  CharacterInfo.sailIcon = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_Icon_Sail")
  CharacterInfo.attackspeed = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_AttackSpeed_Title")
  CharacterInfo._asttackspeed = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_AttackSpeed_Value")
  CharacterInfo.castspeed = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_CastingSpeed_Title")
  CharacterInfo._castspeed = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_CastingSpeed_Value")
  CharacterInfo.movespeed = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_MoveSpeed_Title")
  CharacterInfo._movespeed = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_MoveSpeed_Value")
  CharacterInfo.critical = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_Critical_Title")
  CharacterInfo._critical = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_Critical_Value")
  CharacterInfo.fishTime = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Poten_FishTime")
  CharacterInfo._fishTime = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FishTime_Grade")
  CharacterInfo.product = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Poten_Product")
  CharacterInfo._product = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Product_Grade")
  CharacterInfo.dropChance = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Poten_DropChance")
  CharacterInfo._dropChance = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_DropChance_Grade")
  CharacterInfo._potentialSlot = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_PotentialSlot")
  CharacterInfo._potentialMinusSlot = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_PotentialMinusSlot")
  CharacterInfo._potentialSlotBG = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_PotentialSlotBG")
  CharacterInfo._title_stamina = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Fitness_Stamina_Title")
  CharacterInfo._title_strength = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Fitness_Strength_Title")
  CharacterInfo._title_health = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Fitness_Health_Title")
  CharacterInfo._progress2_stamina = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Fitness_Stamina_Gauge")
  CharacterInfo._progress2_strength = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Fitness_Strength_Gauge")
  CharacterInfo._progress2_health = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Fitness_Health_Gauge")
  CharacterInfo._value_stamina = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Fitness_Stamina_Value")
  CharacterInfo._value_strength = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Fitness_Strength_Value")
  CharacterInfo._value_health = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Fitness_Health_Value")
  CharacterInfo._progress2_resiststun = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_ResistStun_Gauge")
  CharacterInfo._progress2_resistdown = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_ResistDown_Gauge")
  CharacterInfo._progress2_resistcapture = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_ResistCapture_Gauge")
  CharacterInfo._progress2_resistknockback = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_ResistKnockback_Gauge")
  CharacterInfo._hpRegen = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_HpRegen")
  CharacterInfo._mpRegen = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_MpRegen")
  CharacterInfo._weightTooltip = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Weight_Tooltip")
  CharacterInfo._potenHelp = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Poten_Help")
  CharacterInfo._buttonClose = UI.getChildControl(Panel_Window_CharInfo_Status, "Button_Close")
  CharacterInfo._buttonQuestion = UI.getChildControl(Panel_Window_CharInfo_Status, "Button_Question")
  CharacterInfo.checkPopUp = UI.getChildControl(Panel_Window_CharInfo_Status, "CheckButton_PopUp")
  CharacterInfo._selfTimer = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_SelfTimer")
  CharacterInfo._PcRoomTimer = UI.getChildControl(Panel_Window_CharInfo_Status, "StaticText_PCRoomTimer")
  CharacterInfo._todayPlayTime = UI.getChildControl(Panel_Window_CharInfo_Status, "StaticText_TodayPlayTime")
  CharacterInfo._selfTimerIcon = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_SelfTimerIcon")
  CharacterInfo._lifeTitle = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_CraftLevel_Title")
  CharacterInfo._ranker = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Button_Ranker")
  CharacterInfo._btnIntroduce = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Button_Introduce")
  CharacterInfo._introduce._bg = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_IntroduceBg")
  CharacterInfo._introduce._title = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Title_Introduce")
  CharacterInfo._introduce._textBg = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_MultilineTextBg")
  CharacterInfo._introduce._editText = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "MultilineEdit_Introduce")
  CharacterInfo._introduce._btnSetIntro = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Button_SetIntroduce")
  CharacterInfo._introduce._btnResetIntro = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Button_ResetIntroduce")
  CharacterInfo._introduce._closeIntro = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Button_CloseIntroduce")
  CharacterInfo.familyPoints = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FamilyPoint")
  CharacterInfo.familyCombatPoints = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FamilyCombatPoint")
  CharacterInfo.familyLifePoints = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FamilyLifePoint")
  CharacterInfo.familyEtcPoints = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FamilyEtcPoint")
  CharacterInfo.familyLeftBracket = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_LeftBracket")
  CharacterInfo.familyRightBracket = UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_RightBracket")
end
function CharacterInfo:Init()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  CharacterInfo:createControl()
  CharacterInfo._potenHelp:SetShow(false)
  CharacterInfo.potenTooltip = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_CharInfo_Status, "PotenTooltip")
  CopyBaseProperty(CharacterInfo._potenHelp, CharacterInfo.potenTooltip)
  CharacterInfo.potenTooltip:SetColor(UI_color.C_FFFFFFFF)
  CharacterInfo.potenTooltip:SetAlpha(1)
  CharacterInfo.potenTooltip:SetFontColor(UI_color.C_FFFFFFFF)
  CharacterInfo.potenTooltip:SetShow(false)
  CharacterInfo.potenTooltip:SetNotAbleMasking(true)
  CharacterInfo.fitnessTooltip = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_CharInfo_Status, "FitnessTooltip")
  CopyBaseProperty(CharacterInfo._potenHelp, CharacterInfo.fitnessTooltip)
  CharacterInfo.fitnessTooltip:SetColor(UI_color.C_FFFFFFFF)
  CharacterInfo.fitnessTooltip:SetAlpha(1)
  CharacterInfo.fitnessTooltip:SetFontColor(UI_color.C_FFFFFFFF)
  CharacterInfo.fitnessTooltip:SetAutoResize(true)
  CharacterInfo.fitnessTooltip:SetTextMode(CppEnums.TextMode.eTextMode_None)
  CharacterInfo.fitnessTooltip:SetShow(false)
  CharacterInfo.fitnessTooltip:SetNotAbleMasking(true)
  CharacterInfo.checkPopUp:SetShow(isPopUpContentsEnable)
  Panel_Window_CharInfo_Status:SetShow(false)
  Panel_Window_CharInfo_Status:setMaskingChild(true)
  Panel_Window_CharInfo_Status:ActiveMouseEventEffect(true)
  Panel_Window_CharInfo_Status:setGlassBackground(true)
  Panel_Window_CharInfo_Status:SetDragEnable(true)
  Panel_Window_CharInfo_Status:RegisterShowEventFunc(true, "CharInfoStatusShowAni()")
  Panel_Window_CharInfo_Status:RegisterShowEventFunc(false, "CharInfoStatusHideAni()")
  Panel_Window_CharInfo_BasicStatus:SetShow(false)
  self._frameDefaultBG_Basic:MoveChilds(self._frameDefaultBG_Basic:GetID(), Panel_Window_CharInfo_BasicStatus)
  UI.deletePanel(Panel_Window_CharInfo_BasicStatus:GetID())
  self._frameDefaultBG_Title:MoveChilds(self._frameDefaultBG_Title:GetID(), Panel_Window_CharInfo_TitleInfo)
  UI.deletePanel(Panel_Window_CharInfo_TitleInfo:GetID())
  self._frameDefaultBG_History:MoveChilds(self._frameDefaultBG_History:GetID(), Panel_Window_CharInfo_HistoryInfo)
  UI.deletePanel(Panel_Window_CharInfo_HistoryInfo:GetID())
  self._frameDefaultBG_Challenge:MoveChilds(self._frameDefaultBG_Challenge:GetID(), Panel_Window_Challenge)
  UI.deletePanel(Panel_Window_Challenge:GetID())
  if profileOpen then
    self._frameDefaultBG_Profile:MoveChilds(self._frameDefaultBG_Profile:GetID(), Panel_Window_Profile)
    UI.deletePanel(Panel_Window_Profile:GetID())
    CharacterInfo.BTN_Tab_Profile:SetShow(true)
  else
    CharacterInfo.BTN_Tab_Profile:SetShow(false)
  end
  self._gatherTitle:SetIgnore(false)
  self._manufactureTitle:SetIgnore(false)
  self._cookingTitle:SetIgnore(false)
  self._alchemyTitle:SetIgnore(false)
  self._trainingTitle:SetIgnore(false)
  self._tradeTitle:SetIgnore(false)
  self._growthTitle:SetIgnore(false)
  self._sailTitle:SetIgnore(false)
  self._lifeTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "CHARACTERINFO_TEXT_SUBTITLE_CRAFT"))
  self._ranker:SetPosX(self._lifeTitle:GetTextSizeX() + 35, 438)
  self._potentialSlotBG:SetSize(46, self._potentialSlotBG:GetSizeY())
  self._potentialSlot:SetSize(44, self._potentialSlot:GetSizeY())
  for idx = 0, 6 do
    self.attackspeed_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.attackspeed, "attackSpeed_SlotBG_" .. idx)
    CopyBaseProperty(self._potentialSlotBG, self.attackspeed_SlotBG[idx])
    self.attackspeed_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.attackspeed_SlotBG[idx]:SetPosX(0)
    else
      self.attackspeed_SlotBG[idx]:SetPosX(self.attackspeed_SlotBG[idx - 1]:GetPosX() + self.attackspeed_SlotBG[idx - 1]:GetSizeX())
    end
    self.attackspeed_SlotBG[idx]:SetPosY(21)
    self.attackspeed_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.attackspeed, "attackSpeed_Slot_" .. idx)
    CopyBaseProperty(self._potentialSlot, self.attackspeed_Slot[idx])
    self.attackspeed_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.attackspeed_Slot[idx]:SetPosX(0)
    else
      self.attackspeed_Slot[idx]:SetPosX(self.attackspeed_Slot[idx - 1]:GetPosX() + self.attackspeed_Slot[idx - 1]:GetSizeX() + 2)
    end
    self.attackspeed_Slot[idx]:SetPosY(22)
    self.attackspeed_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.attackspeed, "attackSpeed_MinusSlot_" .. idx)
    CopyBaseProperty(self._potentialMinusSlot, self.attackspeed_MinusSlot[idx])
    self.attackspeed_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.attackspeed_MinusSlot[idx]:SetPosX(0)
    else
      self.attackspeed_MinusSlot[idx]:SetPosX(self.attackspeed_MinusSlot[idx - 1]:GetPosX() + self.attackspeed_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    self.attackspeed_MinusSlot[idx]:SetPosY(22)
    self.castspeed_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.castspeed, "castspeed_SlotBG_" .. idx)
    CopyBaseProperty(self._potentialSlotBG, self.castspeed_SlotBG[idx])
    self.castspeed_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.castspeed_SlotBG[idx]:SetPosX(0)
    else
      self.castspeed_SlotBG[idx]:SetPosX(self.castspeed_SlotBG[idx - 1]:GetPosX() + self.castspeed_SlotBG[idx - 1]:GetSizeX())
    end
    self.castspeed_SlotBG[idx]:SetPosY(21)
    self.castspeed_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.castspeed, "castspeed_Slot_" .. idx)
    CopyBaseProperty(self._potentialSlot, self.castspeed_Slot[idx])
    self.castspeed_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.castspeed_Slot[idx]:SetPosX(0)
    else
      self.castspeed_Slot[idx]:SetPosX(self.castspeed_Slot[idx - 1]:GetPosX() + self.castspeed_Slot[idx - 1]:GetSizeX() + 2)
    end
    self.castspeed_Slot[idx]:SetPosY(22)
    self.castspeed_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.castspeed, "castspeed_MinusSlot_" .. idx)
    CopyBaseProperty(self._potentialMinusSlot, self.castspeed_MinusSlot[idx])
    self.castspeed_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.castspeed_MinusSlot[idx]:SetPosX(0)
    else
      self.castspeed_MinusSlot[idx]:SetPosX(self.castspeed_MinusSlot[idx - 1]:GetPosX() + self.castspeed_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    self.castspeed_MinusSlot[idx]:SetPosY(22)
    self.movespeed_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.movespeed, "movespeed_SlotBG_" .. idx)
    CopyBaseProperty(self._potentialSlotBG, self.movespeed_SlotBG[idx])
    self.movespeed_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.movespeed_SlotBG[idx]:SetPosX(0)
    else
      self.movespeed_SlotBG[idx]:SetPosX(self.movespeed_SlotBG[idx - 1]:GetPosX() + self.movespeed_SlotBG[idx - 1]:GetSizeX())
    end
    self.movespeed_SlotBG[idx]:SetPosY(21)
    self.movespeed_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.movespeed, "movespeed_Slot_" .. idx)
    CopyBaseProperty(self._potentialSlot, self.movespeed_Slot[idx])
    self.movespeed_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.movespeed_Slot[idx]:SetPosX(0)
    else
      self.movespeed_Slot[idx]:SetPosX(self.movespeed_Slot[idx - 1]:GetPosX() + self.movespeed_Slot[idx - 1]:GetSizeX() + 2)
    end
    self.movespeed_Slot[idx]:SetPosY(22)
    self.movespeed_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.movespeed, "movespeed_MinusSlot_" .. idx)
    CopyBaseProperty(self._potentialMinusSlot, self.movespeed_MinusSlot[idx])
    self.movespeed_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.movespeed_MinusSlot[idx]:SetPosX(0)
    else
      self.movespeed_MinusSlot[idx]:SetPosX(self.movespeed_MinusSlot[idx - 1]:GetPosX() + self.movespeed_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    self.movespeed_MinusSlot[idx]:SetPosY(22)
    self.critical_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.critical, "critical_SlotBG_" .. idx)
    CopyBaseProperty(self._potentialSlotBG, self.critical_SlotBG[idx])
    self.critical_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.critical_SlotBG[idx]:SetPosX(0)
    else
      self.critical_SlotBG[idx]:SetPosX(self.critical_SlotBG[idx - 1]:GetPosX() + self.critical_SlotBG[idx - 1]:GetSizeX())
    end
    self.critical_SlotBG[idx]:SetPosY(21)
    self.critical_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.critical, "critical_Slot_" .. idx)
    CopyBaseProperty(self._potentialSlot, self.critical_Slot[idx])
    self.critical_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.critical_Slot[idx]:SetPosX(0)
    else
      self.critical_Slot[idx]:SetPosX(self.critical_Slot[idx - 1]:GetPosX() + self.critical_Slot[idx - 1]:GetSizeX() + 2)
    end
    self.critical_Slot[idx]:SetPosY(22)
    self.critical_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.critical, "critical_MinusSlot_" .. idx)
    CopyBaseProperty(self._potentialMinusSlot, self.critical_MinusSlot[idx])
    self.critical_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.critical_MinusSlot[idx]:SetPosX(0)
    else
      self.critical_MinusSlot[idx]:SetPosX(self.critical_MinusSlot[idx - 1]:GetPosX() + self.critical_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    self.critical_MinusSlot[idx]:SetPosY(22)
    self.fishTime_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.fishTime, "fishTime_SlotBG_" .. idx)
    CopyBaseProperty(self._potentialSlotBG, self.fishTime_SlotBG[idx])
    self.fishTime_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.fishTime_SlotBG[idx]:SetPosX(0)
    else
      self.fishTime_SlotBG[idx]:SetPosX(self.fishTime_SlotBG[idx - 1]:GetPosX() + self.fishTime_SlotBG[idx - 1]:GetSizeX())
    end
    self.fishTime_SlotBG[idx]:SetPosY(21)
    self.fishTime_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.fishTime, "fishTime_Slot_" .. idx)
    CopyBaseProperty(self._potentialSlot, self.fishTime_Slot[idx])
    self.fishTime_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.fishTime_Slot[idx]:SetPosX(0)
    else
      self.fishTime_Slot[idx]:SetPosX(self.fishTime_Slot[idx - 1]:GetPosX() + self.fishTime_Slot[idx - 1]:GetSizeX() + 2)
    end
    self.fishTime_Slot[idx]:SetPosY(22)
    self.fishTime_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.fishTime, "fishTime_MinusSlot_" .. idx)
    CopyBaseProperty(self._potentialMinusSlot, self.fishTime_MinusSlot[idx])
    self.fishTime_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.fishTime_MinusSlot[idx]:SetPosX(0)
    else
      self.fishTime_MinusSlot[idx]:SetPosX(self.fishTime_MinusSlot[idx - 1]:GetPosX() + self.fishTime_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    self.fishTime_MinusSlot[idx]:SetPosY(22)
    self.product_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.product, "product_SlotBG_" .. idx)
    CopyBaseProperty(self._potentialSlotBG, self.product_SlotBG[idx])
    self.product_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.product_SlotBG[idx]:SetPosX(0)
    else
      self.product_SlotBG[idx]:SetPosX(self.product_SlotBG[idx - 1]:GetPosX() + self.product_SlotBG[idx - 1]:GetSizeX())
    end
    self.product_SlotBG[idx]:SetPosY(21)
    self.product_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.product, "product_Slot_" .. idx)
    CopyBaseProperty(self._potentialSlot, self.product_Slot[idx])
    self.product_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.product_Slot[idx]:SetPosX(0)
    else
      self.product_Slot[idx]:SetPosX(self.product_Slot[idx - 1]:GetPosX() + self.product_Slot[idx - 1]:GetSizeX() + 2)
    end
    self.product_Slot[idx]:SetPosY(22)
    self.product_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.product, "product_MinusSlot_" .. idx)
    CopyBaseProperty(self._potentialMinusSlot, self.product_MinusSlot[idx])
    self.product_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.product_MinusSlot[idx]:SetPosX(0)
    else
      self.product_MinusSlot[idx]:SetPosX(self.product_MinusSlot[idx - 1]:GetPosX() + self.product_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    self.product_MinusSlot[idx]:SetPosY(22)
    self.dropChance_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.dropChance, "dropChance_SlotBG_" .. idx)
    CopyBaseProperty(self._potentialSlotBG, self.dropChance_SlotBG[idx])
    self.dropChance_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      self.dropChance_SlotBG[idx]:SetPosX(0)
    else
      self.dropChance_SlotBG[idx]:SetPosX(self.dropChance_SlotBG[idx - 1]:GetPosX() + self.dropChance_SlotBG[idx - 1]:GetSizeX())
    end
    self.dropChance_SlotBG[idx]:SetPosY(21)
    self.dropChance_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.dropChance, "dropChance_Slot_" .. idx)
    CopyBaseProperty(self._potentialSlot, self.dropChance_Slot[idx])
    self.dropChance_Slot[idx]:SetShow(false)
    if 0 == idx then
      self.dropChance_Slot[idx]:SetPosX(0)
    else
      self.dropChance_Slot[idx]:SetPosX(self.dropChance_Slot[idx - 1]:GetPosX() + self.dropChance_Slot[idx - 1]:GetSizeX() + 2)
    end
    self.dropChance_Slot[idx]:SetPosY(22)
    self.dropChance_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.dropChance, "dropChance_MinusSlot_" .. idx)
    CopyBaseProperty(self._potentialMinusSlot, self.dropChance_MinusSlot[idx])
    self.dropChance_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      self.dropChance_MinusSlot[idx]:SetPosX(0)
    else
      self.dropChance_MinusSlot[idx]:SetPosX(self.dropChance_MinusSlot[idx - 1]:GetPosX() + self.dropChance_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    self.dropChance_MinusSlot[idx]:SetPosY(22)
  end
  if isFamilyPoint then
    self.familyPoints:SetShow(true)
    self.familyCombatPoints:SetShow(true)
    self.familyLifePoints:SetShow(true)
    self.familyEtcPoints:SetShow(true)
    self.familyLeftBracket:SetShow(true)
    self.familyRightBracket:SetShow(true)
  else
    self.familyPoints:SetShow(false)
    self.familyCombatPoints:SetShow(false)
    self.familyLifePoints:SetShow(false)
    self.familyEtcPoints:SetShow(false)
    self.familyLeftBracket:SetShow(false)
    self.familyRightBracket:SetShow(false)
  end
  if ToClient_IsContentsGroupOpen("83") then
    self._sailTitle:SetShow(true)
    self._sail:SetShow(true)
    self._sailPercent:SetShow(true)
    self._progress2_sail:SetShow(true)
    self.sailProgressBG:SetShow(true)
    self.sailIcon:SetShow(true)
  else
    self._sailTitle:SetShow(false)
    self._sail:SetShow(false)
    self._sailPercent:SetShow(false)
    self._progress2_sail:SetShow(false)
    self.sailProgressBG:SetShow(false)
    self.sailIcon:SetShow(false)
  end
  CharacterInfo._PcRoomTimer:addInputEvent("Mouse_On", "CharacterInfo_SimpleTooltip( true, 0 )")
  CharacterInfo._PcRoomTimer:addInputEvent("Mouse_Out", "CharacterInfo_SimpleTooltip()")
  CharacterInfo._todayPlayTime:addInputEvent("Mouse_On", "CharacterInfo_SimpleTooltip( true, 1 )")
  CharacterInfo._todayPlayTime:addInputEvent("Mouse_Out", "CharacterInfo_SimpleTooltip()")
  CharacterInfo._selfTimer:addInputEvent("Mouse_LUp", "HandleClicked_SelfTimer_BlackAnimation()")
end
function FGlobal_CraftLevel_Replace(lev, lifeType)
  if lev >= 1 and lev <= 10 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_1") .. lev
  elseif lev >= 11 and lev <= 20 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_2") .. lev - 10
  elseif lev >= 21 and lev <= 30 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_3") .. lev - 20
  elseif lev >= 31 and lev <= 40 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_4") .. lev - 30
  elseif lev >= 41 and lev <= 50 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_5") .. lev - 40
  elseif lev >= 51 and lev <= 80 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_6") .. lev - 50
  elseif lev >= 81 and lev <= 100 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_7") .. lev - 80
  end
  return lev
end
function FGlobal_CraftLevelColor_Replace(lev)
  if lev >= 1 and lev <= 10 then
    levColor = UI_color.C_FFC4C4C4
  elseif lev >= 11 and lev <= 20 then
    levColor = UI_color.C_FF76B24D
  elseif lev >= 21 and lev <= 30 then
    levColor = UI_color.C_FF3B8BBE
  elseif lev >= 31 and lev <= 40 then
    levColor = UI_color.C_FFEBC467
  elseif lev >= 41 and lev <= 50 then
    levColor = UI_color.C_FFD04D47
  elseif lev >= 51 and lev <= 80 then
    levColor = UI_color.C_FFB23BC7
  elseif lev >= 81 and lev <= 100 then
    levColor = UI_color.C_FFC78045
  end
  return levColor
end
function FGlobal_CraftType_ReplaceName(typeNo)
  local typeName
  if 0 == typeNo then
    typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_GATHER")
  elseif 1 == typeNo then
    typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_FISH")
  elseif 2 == typeNo then
    typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_HUNT")
  elseif 3 == typeNo then
    typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_COOK")
  elseif 4 == typeNo then
    typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_ALCHEMY")
  elseif 5 == typeNo then
    typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_MANUFACTURE")
  elseif 6 == typeNo then
    typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_OBEDIENCE")
  elseif 7 == typeNo then
    typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_TRADE")
  elseif 8 == typeNo then
    typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_GROWTH")
  elseif 9 == typeNo then
    typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_SAIL")
  else
    typeName = "???"
  end
  return typeName
end
function SelfCharacterInfo_UpdateCharacterBasicInfo()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local playerGet = player:get()
  local UI_classType = CppEnums.ClassType
  local FamiName = player:getUserNickname()
  CharacterInfo._familyname:SetText(tostring(FamiName))
  local ChaName = player:getOriginalName()
  CharacterInfo._charactername:SetText(tostring(ChaName))
  if nil ~= player:getZodiacSignOrderStaticStatusWrapper() then
    local ZodiacName = player:getZodiacSignOrderStaticStatusWrapper():getZodiacName()
    CharacterInfo._zodiac:SetText(tostring(ZodiacName))
  end
end
function SelfCharacterInfo_UpdateAffiliatedTerritory()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local affiliatedTerritoryKey = temporaryWrapper:getAffiliatedTerritoryKeyRaw()
  local territoryInfoWrapper = getTerritoryInfoWrapper(affiliatedTerritoryKey)
  local affiliatedterritoryName = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_AFFILIATEDTERRITORY")
  if nil ~= territoryInfoWrapper then
    affiliatedterritoryName = territoryInfoWrapper:getTerritoryName()
  end
  CharacterInfo._affiliatedterritory:SetText(tostring(affiliatedterritoryName))
end
function SelfCharacterInfo_UpdateWp()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local Wp = player:getWp()
  local maxWp = player:getMaxWp()
  CharacterInfo._mental:SetText(tostring(Wp) .. " / " .. tostring(maxWp))
end
function SelfCharacterInfo_UpdateExplorePoint()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local territoryKeyRaw = ToClient_getDefaultTerritoryKey()
  local explorePoint = ToClient_getExplorePointByTerritoryRaw(territoryKeyRaw)
  CharacterInfo._contribution:SetText(tostring(explorePoint:getRemainedPoint()) .. " / " .. tostring(explorePoint:getAquiredPoint()))
end
function SelfCharacterInfo_UpdateLevel()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local playerGet = player:get()
  local ChaLevel = playerGet:getLevel()
  CharacterInfo._characterlevel:SetText(tostring(ChaLevel))
  local needExp = playerGet:getNeedExp_s64()
  local currentExp = playerGet:getExp_s64()
  local _const = Defines.s64_const
  local expRate = 0
  if needExp > _const.s64_10000 then
    expRate = Int64toInt32(currentExp / (needExp / _const.s64_100))
  elseif _const.s64_0 ~= needExp then
    expRate = Int64toInt32(currentExp * _const.s64_100 / needExp)
  end
  CharacterInfo._progress2_characterlevel:SetProgressRate(expRate)
end
function SelfCharacterInfo_UpdateFamilyPoints()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  local self = CharacterInfo
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local playerGet = player:get()
  local battleFP = playerGet:getBattleFamilyPoint()
  local lifeFP = playerGet:getLifeFamilyPoint()
  local etcFP = playerGet:getEtcFamilyPoint()
  local sumFP = battleFP + lifeFP + etcFP
  self.familyPoints:SetText(tostring(sumFP))
  self.familyCombatPoints:SetText(tostring(battleFP))
  self.familyLifePoints:SetText(tostring(lifeFP))
  self.familyEtcPoints:SetText(tostring(etcFP))
end
function SelfCharacterInfo_UpdateMainStatus()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local playerGet = player:get()
  local UI_classType = CppEnums.ClassType
  local hp = playerGet:getHp()
  local maxHp = playerGet:getMaxHp()
  local hpRate = hp / maxHp * 100
  CharacterInfo._hpvalue:SetText(makeDotMoney(hp) .. " / " .. makeDotMoney(maxHp))
  CharacterInfo._progress2_hp:SetProgressRate(hpRate)
  if UI_classType.ClassType_Ranger == player:getClassType() or UI_classType.ClassType_Orange == player:getClassType() then
    CharacterInfo._mpTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_EP"))
    CharacterInfo._progress2_mp:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(CharacterInfo._progress2_mp, 2, 71, 232, 76)
    CharacterInfo._progress2_mp:getBaseTexture():setUV(x1, y1, x2, y2)
    CharacterInfo._progress2_mp:setRenderTexture(CharacterInfo._progress2_mp:getBaseTexture())
  elseif UI_classType.ClassType_Warrior == player:getClassType() or UI_classType.ClassType_Giant == player:getClassType() or UI_classType.ClassType_BladeMaster == player:getClassType() or UI_classType.ClassType_BladeMasterWomen == player:getClassType() or UI_classType.ClassType_NinjaWomen == player:getClassType() or UI_classType.ClassType_NinjaMan == player:getClassType() or UI_classType.ClassType_Combattant == player:getClassType() or UI_classType.ClassType_CombattantWomen == player:getClassType() or UI_classType.ClassType_Lahn == player:getClassType() then
    CharacterInfo._mpTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_FP"))
    CharacterInfo._progress2_mp:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(CharacterInfo._progress2_mp, 2, 57, 232, 62)
    CharacterInfo._progress2_mp:getBaseTexture():setUV(x1, y1, x2, y2)
    CharacterInfo._progress2_mp:setRenderTexture(CharacterInfo._progress2_mp:getBaseTexture())
  elseif UI_classType.ClassType_Sorcerer == player:getClassType() or UI_classType.ClassType_Tamer == player:getClassType() or UI_classType.ClassType_Wizard == player:getClassType() or UI_classType.ClassType_WizardWomen == player:getClassType() then
    CharacterInfo._mpTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_MP"))
    CharacterInfo._progress2_mp:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(CharacterInfo._progress2_mp, 2, 64, 232, 69)
    CharacterInfo._progress2_mp:getBaseTexture():setUV(x1, y1, x2, y2)
    CharacterInfo._progress2_mp:setRenderTexture(CharacterInfo._progress2_mp:getBaseTexture())
  elseif UI_classType.ClassType_Valkyrie == player:getClassType() then
    CharacterInfo._mpTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_BP"))
    CharacterInfo._progress2_mp:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(CharacterInfo._progress2_mp, 2, 250, 232, 255)
    CharacterInfo._progress2_mp:getBaseTexture():setUV(x1, y1, x2, y2)
    CharacterInfo._progress2_mp:setRenderTexture(CharacterInfo._progress2_mp:getBaseTexture())
  elseif UI_classType.ClassType_DarkElf == player:getClassType() then
    CharacterInfo._mpTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_MP_DARKELF"))
    CharacterInfo._progress2_mp:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/default_gauges_03.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(CharacterInfo._progress2_mp, 1, 1, 256, 10)
    CharacterInfo._progress2_mp:getBaseTexture():setUV(x1, y1, x2, y2)
    CharacterInfo._progress2_mp:setRenderTexture(CharacterInfo._progress2_mp:getBaseTexture())
  end
  local mp = playerGet:getMp()
  local maxMp = playerGet:getMaxMp()
  local MpRate = mp / maxMp * 100
  CharacterInfo._mpvalue:SetText(makeDotMoney(mp) .. " / " .. makeDotMoney(maxMp))
  CharacterInfo._progress2_mp:SetProgressRate(MpRate)
  local totalPlayTime = Util.Time.timeFormatting_Minute(Int64toInt32(ToClient_GetCharacterPlayTime()))
  CharacterInfo._selfTimer:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CONTRACT_TIME_BLACKSPIRIT") .. "<PAColor0xFFFFC730> " .. totalPlayTime .. "<PAOldColor> ")
  CharacterInfo._selfTimer:SetSize(CharacterInfo._selfTimer:GetTextSizeX(), CharacterInfo._selfTimer:GetSizeY())
  CharacterInfo._selfTimer:ComputePos()
  CharacterInfo._selfTimerIcon:SetPosX(CharacterInfo._selfTimer:GetPosX() - CharacterInfo._selfTimerIcon:GetSizeX())
  local temporaryPCRoomWrapper = getTemporaryInformationWrapper()
  local isPremiumPcRoom = temporaryPCRoomWrapper:isPremiumPcRoom()
  local userPlayTime = Util.Time.timeFormatting(Int64toInt32(ToClient_GetUserPlayTimePerDay()))
  CharacterInfo._todayPlayTime:SetShow(true)
  CharacterInfo._PcRoomTimer:SetShow(false)
  CharacterInfo._todayPlayTime:SetPosX(521)
  CharacterInfo._todayPlayTime:SetPosY(58)
  if isPremiumPcRoom and (isGameTypeKorea() or isGameTypeJapan()) then
    CharacterInfo._PcRoomTimer:SetShow(true)
    CharacterInfo._PcRoomTimer:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_PCROOMTIME", "getPcRoomPlayTime", convertStringFromDatetime(ToClient_GetPcRoomPlayTime())))
    CharacterInfo._todayPlayTime:SetText("<PAColor0xFFFFC730>" .. tostring(userPlayTime) .. "<PAOldColor>")
  else
    CharacterInfo._PcRoomTimer:SetShow(false)
    CharacterInfo._todayPlayTime:SetText("<PAColor0xFFFFC730>" .. tostring(userPlayTime) .. "<PAOldColor>")
  end
  CharacterInfo._PcRoomTimer:SetPosX(CharacterInfo._todayPlayTime:GetPosX() + CharacterInfo._todayPlayTime:GetTextSizeX() + 20)
  CharacterInfo._PcRoomTimer:SetPosY(60)
  if profileOpen then
    CharacterInfo._selfTimer:SetShow(false)
    CharacterInfo._selfTimerIcon:SetShow(false)
    CharacterInfo._PcRoomTimer:SetShow(false)
    CharacterInfo._todayPlayTime:SetShow(false)
  end
end
function HandleClicked_SelfTimer_BlackAnimation()
  CharacterInfo._selfTimerIcon:ResetVertexAni()
  CharacterInfo._selfTimerIcon:SetVertexAniRun("Ani_Rotate_New", true)
end
function SelfCharacterInfo_UpdateMainStatusRegen()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local playerGet = player:get()
  local UI_classType = CppEnums.ClassType
  CharacterInfo._hpRegen:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_HPREGEN") .. " : " .. tostring(playerGet:getRegenHp()))
  CharacterInfo._hpRegen:SetSize(CharacterInfo._hpRegen:GetTextSizeX() + 10, 30)
  if UI_classType.ClassType_Ranger == player:getClassType() or UI_classType.ClassType_DarkElf == player:getClassType() or UI_classType.ClassType_Orange == player:getClassType() then
    CharacterInfo._mpRegen:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_EPREGEN") .. " : " .. tostring(playerGet:getRegenMp()))
  elseif UI_classType.ClassType_Sorcerer == player:getClassType() or UI_classType.ClassType_Tamer == player:getClassType() or UI_classType.ClassType_Wizard == player:getClassType() or UI_classType.ClassType_WizardWomen == player:getClassType() then
    CharacterInfo._mpRegen:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_MPREGEN") .. " : " .. tostring(playerGet:getRegenMp()))
  elseif UI_classType.ClassType_Valkyrie == player:getClassType() then
    CharacterInfo._mpRegen:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_BPREGEN") .. " : " .. tostring(playerGet:getRegenMp()))
  elseif UI_classType.ClassType_Warrior == player:getClassType() or UI_classType.ClassType_Giant == player:getClassType() or UI_classType.ClassType_BladeMaster == player:getClassType() or UI_classType.ClassType_BladeMasterWomen == player:getClassType() or UI_classType.ClassType_NinjaWomen == player:getClassType() or UI_classType.ClassType_NinjaMan == player:getClassType() or UI_classType.ClassType_Combattant == player:getClassType() or UI_classType.ClassType_CombattantWomen == player:getClassType() or UI_classType.ClassType_Lahn == player:getClassType() then
    CharacterInfo._mpRegen:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_FPREGEN") .. " : " .. tostring(playerGet:getRegenMp()))
  end
  CharacterInfo._mpRegen:SetSize(CharacterInfo._mpRegen:GetTextSizeX() + 10, 30)
end
function SelfCharacterInfo_UpdateWeight()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  if true == _ContentsGroup_InvenUpdateCheck and false == Panel_Window_CharInfo_Status:GetShow() then
    return
  end
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local _const = Defines.s64_const
  local selfPlayer = player:get()
  local s64_moneyWeight = selfPlayer:getInventory():getMoneyWeight_s64()
  local s64_equipmentWeight = selfPlayer:getEquipment():getWeight_s64()
  local s64_allWeight = selfPlayer:getCurrentWeight_s64()
  local s64_maxWeight = selfPlayer:getPossessableWeight_s64()
  local s64_allWeight_div = s64_allWeight / _const.s64_100
  local s64_maxWeight_div = s64_maxWeight / _const.s64_100
  local str_AllWeight = string.format("%.1f", Int64toInt32(s64_allWeight_div) / 100)
  local str_MaxWeight = string.format("%.0f", Int64toInt32(s64_maxWeight_div) / 100)
  if s64_allWeight_div <= s64_maxWeight_div then
    CharacterInfo._progress2_weightvalue_Money:SetProgressRate(Int64toInt32(s64_moneyWeight / s64_maxWeight_div))
    CharacterInfo._progress2_weightvalue_Equip:SetProgressRate(Int64toInt32((s64_moneyWeight + s64_equipmentWeight) / s64_maxWeight_div))
    CharacterInfo._progress2_weightvalue_Inventory:SetProgressRate(Int64toInt32(s64_allWeight / s64_maxWeight_div))
  else
    CharacterInfo._progress2_weightvalue_Money:SetProgressRate(Int64toInt32(s64_moneyWeight / s64_allWeight_div))
    CharacterInfo._progress2_weightvalue_Equip:SetProgressRate(Int64toInt32((s64_moneyWeight + s64_equipmentWeight) / s64_allWeight_div))
    CharacterInfo._progress2_weightvalue_Inventory:SetProgressRate(Int64toInt32(s64_allWeight / s64_allWeight_div))
  end
  CharacterInfo._weightvalue:SetText(tostring(str_AllWeight) .. " / " .. tostring(str_MaxWeight) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT"))
end
function SelfCharacterInfo_UpdateAttackStat()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  ToClient_updateAttackStat()
  local ChaAttack = ToClient_getOffence()
  CharacterInfo._attack:SetText(tostring(ChaAttack))
  local ChaAwakenAttack = ToClient_getAwakenOffence()
  local isSetAwakenWeapon = ToClient_getEquipmentItem(CppEnums.EquipSlotNo.awakenWeapon)
  if nil ~= isSetAwakenWeapon then
    CharacterInfo._awakenAttackTitle:SetShow(true)
    CharacterInfo._awakenAttack:SetShow(true)
    CharacterInfo._awakenAttack:SetText(tostring(ChaAwakenAttack))
    CharacterInfo._staminaTitle:SetSpanSize(550, 157)
    CharacterInfo._stamina:SetSpanSize(655, 152)
  else
    CharacterInfo._awakenAttackTitle:SetShow(false)
    CharacterInfo._awakenAttack:SetShow(false)
    CharacterInfo._staminaTitle:SetSpanSize(550, 157)
    CharacterInfo._stamina:SetSpanSize(655, 152)
  end
  local ChaDefence = ToClient_getDefence()
  CharacterInfo._defence:SetText(tostring(ChaDefence))
end
function SelfCharacterInfo_UpdateTendency()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local playerGet = player:get()
  local ChaTendency = playerGet:getTendency()
  CharacterInfo._tendency:SetText(tostring(ChaTendency))
end
function SelfCharacterInfo_UpdateStamina()
  CharacterInfo._stamina:SetText(makeDotMoney(getSelfPlayer():get():getStamina():getMaxSp()))
end
function SelfCharacterInfo_UpdateCraftLevel()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local playerGet = player:get()
  local craftType = {
    gather = 0,
    fishing = 1,
    hunting = 2,
    cooking = 3,
    alchemy = 4,
    manufacture = 5,
    training = 6,
    trade = 7,
    growth = 8,
    sail = 9,
    levelText = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_CRAFTLEVEL")
  }
  local gatherLevel = playerGet:getLifeExperienceLevel(craftType.gather)
  local gatherCurrentExp = playerGet:getCurrLifeExperiencePoint(craftType.gather)
  local gatherMaxExp = playerGet:getDemandLifeExperiencePoint(craftType.gather)
  local gatherExpRate = Int64toInt32(gatherCurrentExp * toInt64(0, 100) / gatherMaxExp)
  CharacterInfo._gather:SetText(FGlobal_CraftLevel_Replace(gatherLevel, craftType.gather))
  CharacterInfo._gather:SetFontColor(FGlobal_CraftLevelColor_Replace(gatherLevel))
  CharacterInfo._progress2_gather:SetProgressRate(gatherExpRate)
  CharacterInfo._gatherPercent:SetText(gatherExpRate .. "%")
  CharacterInfo._gatherPercent:SetFontColor(FGlobal_CraftLevelColor_Replace(gatherLevel))
  local manufatureLevel = playerGet:getLifeExperienceLevel(craftType.manufacture)
  local manufatureCurrentExp = playerGet:getCurrLifeExperiencePoint(craftType.manufacture)
  local manufatureMaxExp = playerGet:getDemandLifeExperiencePoint(craftType.manufacture)
  local manufatureExpRate = Int64toInt32(manufatureCurrentExp * toInt64(0, 100) / manufatureMaxExp)
  CharacterInfo._manufacture:SetText(FGlobal_CraftLevel_Replace(manufatureLevel, craftType.manufacture))
  CharacterInfo._manufacture:SetFontColor(FGlobal_CraftLevelColor_Replace(manufatureLevel))
  CharacterInfo._progress2_manufacture:SetProgressRate(manufatureExpRate)
  CharacterInfo._manufacturePercent:SetText(manufatureExpRate .. "%")
  CharacterInfo._manufacturePercent:SetFontColor(FGlobal_CraftLevelColor_Replace(manufatureLevel))
  local cookingLevel = playerGet:getLifeExperienceLevel(craftType.cooking)
  local cookingCurrentExp = playerGet:getCurrLifeExperiencePoint(craftType.cooking)
  local cookingMaxExp = playerGet:getDemandLifeExperiencePoint(craftType.cooking)
  local cookingExpRate = Int64toInt32(cookingCurrentExp * toInt64(0, 100) / cookingMaxExp)
  CharacterInfo._cooking:SetText(FGlobal_CraftLevel_Replace(cookingLevel, craftType.cooking))
  CharacterInfo._cooking:SetFontColor(FGlobal_CraftLevelColor_Replace(cookingLevel))
  CharacterInfo._progress2_cooking:SetProgressRate(cookingExpRate)
  CharacterInfo._cookingPercent:SetText(cookingExpRate .. "%")
  CharacterInfo._cookingPercent:SetFontColor(FGlobal_CraftLevelColor_Replace(cookingLevel))
  local alchemyLevel = playerGet:getLifeExperienceLevel(craftType.alchemy)
  local alchemyCurrentExp = playerGet:getCurrLifeExperiencePoint(craftType.alchemy)
  local alchemyMaxExp = playerGet:getDemandLifeExperiencePoint(craftType.alchemy)
  local alchemyExpRate = Int64toInt32(alchemyCurrentExp * toInt64(0, 100) / alchemyMaxExp)
  CharacterInfo._alchemy:SetText(FGlobal_CraftLevel_Replace(alchemyLevel, craftType.alchemy))
  CharacterInfo._alchemy:SetFontColor(FGlobal_CraftLevelColor_Replace(alchemyLevel))
  CharacterInfo._progress2_alchemy:SetProgressRate(alchemyExpRate)
  CharacterInfo._alchemyPercent:SetText(alchemyExpRate .. "%")
  CharacterInfo._alchemyPercent:SetFontColor(FGlobal_CraftLevelColor_Replace(alchemyLevel))
  local fishingLevel = playerGet:getLifeExperienceLevel(craftType.fishing)
  local fishingCurrentExp = playerGet:getCurrLifeExperiencePoint(craftType.fishing)
  local fishingMaxExp = playerGet:getDemandLifeExperiencePoint(craftType.fishing)
  local fishingExpRate = Int64toInt32(fishingCurrentExp * toInt64(0, 100) / fishingMaxExp)
  CharacterInfo._fishing:SetText(FGlobal_CraftLevel_Replace(fishingLevel, craftType.fishing))
  CharacterInfo._fishing:SetFontColor(FGlobal_CraftLevelColor_Replace(fishingLevel))
  CharacterInfo._progress2_fishing:SetProgressRate(fishingExpRate)
  CharacterInfo._fishingPercent:SetText(fishingExpRate .. "%")
  CharacterInfo._fishingPercent:SetFontColor(FGlobal_CraftLevelColor_Replace(fishingLevel))
  local huntingLevel = playerGet:getLifeExperienceLevel(craftType.hunting)
  local huntingCurrentExp = playerGet:getCurrLifeExperiencePoint(craftType.hunting)
  local huntingMaxExp = playerGet:getDemandLifeExperiencePoint(craftType.hunting)
  local huntingExpRate = Int64toInt32(huntingCurrentExp * toInt64(0, 100) / huntingMaxExp)
  CharacterInfo._hunting:SetText(FGlobal_CraftLevel_Replace(huntingLevel, craftType.hunting))
  CharacterInfo._hunting:SetFontColor(FGlobal_CraftLevelColor_Replace(huntingLevel))
  CharacterInfo._progress2_hunting:SetProgressRate(huntingExpRate)
  CharacterInfo._huntingPercent:SetText(huntingExpRate .. "%")
  CharacterInfo._huntingPercent:SetFontColor(FGlobal_CraftLevelColor_Replace(huntingLevel))
  local trainingLevel = playerGet:getLifeExperienceLevel(craftType.training)
  local trainingCurrentExp = playerGet:getCurrLifeExperiencePoint(craftType.training)
  local trainingMaxExp = playerGet:getDemandLifeExperiencePoint(craftType.training)
  local trainingExpRate = Int64toInt32(trainingCurrentExp * toInt64(0, 100) / trainingMaxExp)
  CharacterInfo._training:SetText(FGlobal_CraftLevel_Replace(trainingLevel, craftType.training))
  CharacterInfo._training:SetFontColor(FGlobal_CraftLevelColor_Replace(trainingLevel))
  CharacterInfo._progress2_training:SetProgressRate(trainingExpRate)
  CharacterInfo._trainingPercent:SetText(trainingExpRate .. "%")
  CharacterInfo._trainingPercent:SetFontColor(FGlobal_CraftLevelColor_Replace(trainingLevel))
  local tradeLevel = playerGet:getLifeExperienceLevel(craftType.trade)
  local tradeCurrentExp = playerGet:getCurrLifeExperiencePoint(craftType.trade)
  local tradeMaxExp = playerGet:getDemandLifeExperiencePoint(craftType.trade)
  local tradeExpRate = Int64toInt32(tradeCurrentExp * toInt64(0, 100) / tradeMaxExp)
  CharacterInfo._trade:SetText(FGlobal_CraftLevel_Replace(tradeLevel, craftType.trade))
  CharacterInfo._trade:SetFontColor(FGlobal_CraftLevelColor_Replace(tradeLevel))
  CharacterInfo._progress2_trade:SetProgressRate(tradeExpRate)
  CharacterInfo._tradePercent:SetText(tradeExpRate .. "%")
  CharacterInfo._tradePercent:SetFontColor(FGlobal_CraftLevelColor_Replace(tradeLevel))
  local growthLevel = playerGet:getLifeExperienceLevel(craftType.growth)
  local growthCurrentExp = playerGet:getCurrLifeExperiencePoint(craftType.growth)
  local growthMaxExp = playerGet:getDemandLifeExperiencePoint(craftType.growth)
  local growthExpRate = Int64toInt32(growthCurrentExp * toInt64(0, 100) / growthMaxExp)
  CharacterInfo._growth:SetText(FGlobal_CraftLevel_Replace(growthLevel, craftType.growth))
  CharacterInfo._growth:SetFontColor(FGlobal_CraftLevelColor_Replace(growthLevel))
  CharacterInfo._progress2_growth:SetProgressRate(growthExpRate)
  CharacterInfo._growthPercent:SetText(growthExpRate .. "%")
  CharacterInfo._growthPercent:SetFontColor(FGlobal_CraftLevelColor_Replace(growthLevel))
  local sailLevel = playerGet:getLifeExperienceLevel(craftType.sail)
  local sailCurrentExp = playerGet:getCurrLifeExperiencePoint(craftType.sail)
  local sailMaxExp = playerGet:getDemandLifeExperiencePoint(craftType.sail)
  local sailExpRate = Int64toInt32(sailCurrentExp * toInt64(0, 100) / sailMaxExp)
  CharacterInfo._sail:SetText(FGlobal_CraftLevel_Replace(sailLevel, craftType.sail))
  CharacterInfo._sail:SetFontColor(FGlobal_CraftLevelColor_Replace(sailLevel))
  CharacterInfo._progress2_sail:SetProgressRate(sailExpRate)
  CharacterInfo._sailPercent:SetText(sailExpRate .. "%")
  CharacterInfo._sailPercent:SetFontColor(FGlobal_CraftLevelColor_Replace(sailLevel))
end
function SelfCharacterInfo_UpdatePotenGradeInfo()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local playerGet = player:get()
  local potentialType = {
    move = 0,
    attack = 1,
    cast = 2,
    levelText = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_POTENLEVEL")
  }
  local currentAttackSpeedPoint = player:characterStatPointSpeed(potentialType.attack)
  local limitAttackSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.attack)
  if currentAttackSpeedPoint > limitAttackSpeedPoint then
    currentAttackSpeedPoint = limitAttackSpeedPoint
  end
  local equipedAttackSpeedPoint = currentAttackSpeedPoint - 5
  local maxAttackSpeedPoint = limitAttackSpeedPoint - 5
  for Idx = 0, 6 do
    CharacterInfo.attackspeed_SlotBG[Idx]:SetShow(false)
    CharacterInfo.attackspeed_Slot[Idx]:SetShow(false)
    CharacterInfo.attackspeed_MinusSlot[Idx]:SetShow(false)
  end
  for bg_Idx = 0, maxAttackSpeedPoint - 1 do
    CharacterInfo.attackspeed_SlotBG[bg_Idx]:SetShow(true)
  end
  if equipedAttackSpeedPoint > 0 then
    for slot_Idx = 0, equipedAttackSpeedPoint - 1 do
      CharacterInfo.attackspeed_Slot[slot_Idx]:SetShow(true)
    end
  else
    local minus_equipedAttackSpeedPoint = -equipedAttackSpeedPoint
    for slot_Idx = 0, minus_equipedAttackSpeedPoint - 1 do
      CharacterInfo.attackspeed_MinusSlot[slot_Idx]:SetShow(true)
    end
  end
  CharacterInfo._asttackspeed:SetText(tostring(equipedAttackSpeedPoint) .. " " .. potentialType.levelText)
  currentPotencial[0] = equipedAttackSpeedPoint
  local currentCastingSpeedPoint = player:characterStatPointSpeed(potentialType.cast)
  local limitCastingSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.cast)
  if currentCastingSpeedPoint > limitCastingSpeedPoint then
    currentCastingSpeedPoint = limitCastingSpeedPoint
  end
  local equipedCastingSpeedPoint = currentCastingSpeedPoint - 5
  local maxCastingSpeedPoint = limitCastingSpeedPoint - 5
  for Idx = 0, 6 do
    CharacterInfo.castspeed_SlotBG[Idx]:SetShow(false)
    CharacterInfo.castspeed_Slot[Idx]:SetShow(false)
    CharacterInfo.castspeed_MinusSlot[Idx]:SetShow(false)
  end
  for bg_Idx = 0, maxCastingSpeedPoint - 1 do
    CharacterInfo.castspeed_SlotBG[bg_Idx]:SetShow(true)
  end
  if equipedCastingSpeedPoint > 0 then
    for slot_Idx = 0, equipedCastingSpeedPoint - 1 do
      CharacterInfo.castspeed_Slot[slot_Idx]:SetShow(true)
    end
  else
    local minus_equipedCastingSpeedPoint = -equipedCastingSpeedPoint
    for slot_Idx = 0, minus_equipedCastingSpeedPoint - 1 do
      CharacterInfo.castspeed_MinusSlot[slot_Idx]:SetShow(true)
    end
  end
  CharacterInfo._castspeed:SetText(tostring(equipedCastingSpeedPoint) .. " " .. potentialType.levelText)
  currentPotencial[1] = equipedCastingSpeedPoint
  local currentMoveSpeedPoint = player:characterStatPointSpeed(potentialType.move)
  local limitMoveSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.move)
  if currentMoveSpeedPoint > limitMoveSpeedPoint then
    currentMoveSpeedPoint = limitMoveSpeedPoint
  end
  local equipedMoveSpeedPoint = currentMoveSpeedPoint - 5
  local maxMoveSpeedPoint = limitMoveSpeedPoint - 5
  for Idx = 0, 6 do
    CharacterInfo.movespeed_SlotBG[Idx]:SetShow(false)
    CharacterInfo.movespeed_Slot[Idx]:SetShow(false)
    CharacterInfo.movespeed_MinusSlot[Idx]:SetShow(false)
  end
  for bg_Idx = 0, maxMoveSpeedPoint - 1 do
    CharacterInfo.movespeed_SlotBG[bg_Idx]:SetShow(true)
  end
  if equipedMoveSpeedPoint > 0 then
    for slot_Idx = 0, equipedMoveSpeedPoint - 1 do
      CharacterInfo.movespeed_Slot[slot_Idx]:SetShow(true)
    end
  else
    local minus_equipedMoveSpeedPoint = -equipedMoveSpeedPoint
    for slot_Idx = 0, minus_equipedMoveSpeedPoint - 1 do
      CharacterInfo.movespeed_MinusSlot[slot_Idx]:SetShow(true)
    end
  end
  CharacterInfo._movespeed:SetText(tostring(equipedMoveSpeedPoint) .. " " .. potentialType.levelText)
  currentPotencial[2] = equipedMoveSpeedPoint
  local currentCriticalRatePoint = player:characterStatPointCritical()
  local limitCriticalRatePoint = player:characterStatPointLimitedCritical()
  if currentCriticalRatePoint > limitCriticalRatePoint then
    currentCriticalRatePoint = limitCriticalRatePoint
  end
  local equipedCriticalRatePoint = currentCriticalRatePoint
  local maxCriticalRatePoint = limitCriticalRatePoint
  for Idx = 0, 6 do
    CharacterInfo.critical_SlotBG[Idx]:SetShow(false)
    CharacterInfo.critical_Slot[Idx]:SetShow(false)
    CharacterInfo.critical_MinusSlot[Idx]:SetShow(false)
  end
  for bg_Idx = 0, maxCriticalRatePoint - 1 do
    CharacterInfo.critical_SlotBG[bg_Idx]:SetShow(true)
  end
  if equipedCriticalRatePoint > 0 then
    for slot_Idx = 0, equipedCriticalRatePoint - 1 do
      CharacterInfo.critical_Slot[slot_Idx]:SetShow(true)
    end
  else
    local minus_equipedCriticalRatePoint = -equipedCriticalRatePoint
    for slot_Idx = 0, minus_equipedCriticalRatePoint - 1 do
      CharacterInfo.critical_MinusSlot[slot_Idx]:SetShow(true)
    end
  end
  CharacterInfo._critical:SetText(tostring(equipedCriticalRatePoint) .. " " .. potentialType.levelText)
  currentPotencial[3] = equipedCriticalRatePoint
  local currentFishingRatePoint = player:getCharacterStatPointFishing()
  local limitFishingRatePoint = player:getCharacterStatPointLimitedFishing()
  if currentFishingRatePoint > limitFishingRatePoint then
    currentFishingRatePoint = limitFishingRatePoint
  end
  local equipedFishingRatePoint = currentFishingRatePoint
  local maxFishingRatePoint = limitFishingRatePoint
  for Idx = 0, 6 do
    CharacterInfo.fishTime_SlotBG[Idx]:SetShow(false)
    CharacterInfo.fishTime_Slot[Idx]:SetShow(false)
    CharacterInfo.fishTime_MinusSlot[Idx]:SetShow(false)
  end
  for bg_Idx = 0, maxFishingRatePoint - 1 do
    CharacterInfo.fishTime_SlotBG[bg_Idx]:SetShow(true)
  end
  if equipedFishingRatePoint > 0 then
    for slot_Idx = 0, equipedFishingRatePoint - 1 do
      CharacterInfo.fishTime_Slot[slot_Idx]:SetShow(true)
    end
  else
    local minus_equipedFishingRatePoint = -equipedFishingRatePoint
    for slot_Idx = 0, minus_equipedFishingRatePoint - 1 do
      CharacterInfo.fishTime_MinusSlot[slot_Idx]:SetShow(true)
    end
  end
  CharacterInfo._fishTime:SetText(tostring(equipedFishingRatePoint) .. " " .. potentialType.levelText)
  currentPotencial[4] = equipedFishingRatePoint
  local currentProductRatePoint = player:getCharacterStatPointCollection()
  local limitProductRatePoint = player:getCharacterStatPointLimitedCollection()
  if currentProductRatePoint > limitProductRatePoint then
    currentProductRatePoint = limitProductRatePoint
  end
  local equipedProductRatePoint = currentProductRatePoint
  local maxProductRatePoint = limitProductRatePoint
  for Idx = 0, 6 do
    CharacterInfo.product_SlotBG[Idx]:SetShow(false)
    CharacterInfo.product_Slot[Idx]:SetShow(false)
    CharacterInfo.product_MinusSlot[Idx]:SetShow(false)
  end
  for bg_Idx = 0, maxProductRatePoint - 1 do
    CharacterInfo.product_SlotBG[bg_Idx]:SetShow(true)
  end
  if equipedProductRatePoint > 0 then
    for slot_Idx = 0, equipedProductRatePoint - 1 do
      CharacterInfo.product_Slot[slot_Idx]:SetShow(true)
    end
  else
    local minus_equipedProductRatePoint = -equipedProductRatePoint
    for slot_Idx = 0, minus_equipedProductRatePoint - 1 do
      CharacterInfo.product_MinusSlot[slot_Idx]:SetShow(true)
    end
  end
  CharacterInfo._product:SetText(tostring(equipedProductRatePoint) .. " " .. potentialType.levelText)
  currentPotencial[5] = equipedProductRatePoint
  local currentDropItemRatePoint = player:getCharacterStatPointDropItem()
  local limitDropItemRatePoint = player:getCharacterStatPointLimitedDropItem()
  if currentDropItemRatePoint > limitDropItemRatePoint then
    currentDropItemRatePoint = limitDropItemRatePoint
  end
  local equipedDropItemRatePoint = currentDropItemRatePoint
  local maxDropItemRatePoint = limitDropItemRatePoint
  for Idx = 0, 6 do
    CharacterInfo.dropChance_SlotBG[Idx]:SetShow(false)
    CharacterInfo.dropChance_Slot[Idx]:SetShow(false)
    CharacterInfo.dropChance_MinusSlot[Idx]:SetShow(false)
  end
  for bg_Idx = 0, maxDropItemRatePoint - 1 do
    CharacterInfo.dropChance_SlotBG[bg_Idx]:SetShow(true)
  end
  if equipedDropItemRatePoint > 0 then
    for slot_Idx = 0, equipedDropItemRatePoint - 1 do
      CharacterInfo.dropChance_Slot[slot_Idx]:SetShow(true)
    end
  else
    local minus_equipedDropItemRatePoint = -equipedDropItemRatePoint
    for slot_Idx = 0, minus_equipedDropItemRatePoint - 1 do
      CharacterInfo.dropChance_Slot[slot_Idx]:SetShow(true)
    end
  end
  CharacterInfo._dropChance:SetText(tostring(equipedDropItemRatePoint) .. " " .. potentialType.levelText)
  currentPotencial[6] = equipedDropItemRatePoint
end
function CharacterInfoWindowUpdate()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local playerGet = player:get()
  local UI_classType = CppEnums.ClassType
  SelfCharacterInfo_UpdateCharacterBasicInfo()
  SelfCharacterInfo_UpdateTendency()
  SelfCharacterInfo_UpdateWp()
  SelfCharacterInfo_UpdateExplorePoint()
  SelfCharacterInfo_UpdateLevel()
  SelfCharacterInfo_UpdateMainStatus()
  SelfCharacterInfo_UpdateMainStatusRegen()
  SelfCharacterInfo_UpdateWeight()
  SelfCharacterInfo_UpdateAttackStat()
  SelfCharacterInfo_UpdateStamina()
  SelfCharacterInfo_UpdateFamilyPoints()
  SelfCharacterInfo_UpdateTolerance()
  SelfCharacterInfo_UpdateCraftLevel()
  SelfCharacterInfo_UpdatePotenGradeInfo()
  CharacterInfo_updatePlayerTotalStat()
end
function HandleClicked_CharacterInfo_Tab(index)
  if nil == index then
    return
  end
  IntroduceMyself_ShowToggle(false)
  local self = CharacterInfo
  self._frameDefaultBG_Basic:SetShow(false)
  self._frameDefaultBG_Title:SetShow(false)
  self._frameDefaultBG_History:SetShow(false)
  self._frameDefaultBG_Challenge:SetShow(false)
  self._frameDefaultBG_Profile:SetShow(false)
  CharacterInfo.BTN_Tab_Basic:SetCheck(false)
  CharacterInfo.BTN_Tab_Title:SetCheck(false)
  CharacterInfo.BTN_Tab_History:SetCheck(false)
  CharacterInfo.BTN_Tab_Challenge:SetCheck(false)
  CharacterInfo.BTN_Tab_Profile:SetCheck(false)
  if 0 == index then
    self._frameDefaultBG_Basic:SetShow(true)
    CharacterInfo.BTN_Tab_Basic:SetCheck(true)
    CharacterInfo.BTN_Tab_Title:SetCheck(false)
    CharacterInfo.BTN_Tab_History:SetCheck(false)
    CharacterInfo.BTN_Tab_Challenge:SetCheck(false)
    CharacterInfo.BTN_Tab_Profile:SetCheck(false)
    FromClientFitnessUp(0, 0, 0, 0)
  elseif 1 == index then
    self._frameDefaultBG_Title:SetShow(true)
    CharacterInfo.BTN_Tab_Basic:SetCheck(false)
    CharacterInfo.BTN_Tab_Title:SetCheck(true)
    CharacterInfo.BTN_Tab_History:SetCheck(false)
    CharacterInfo.BTN_Tab_Challenge:SetCheck(false)
    CharacterInfo.BTN_Tab_Profile:SetCheck(false)
    TitleInfo_Open()
  elseif 2 == index then
    self._frameDefaultBG_History:SetShow(true)
    CharacterInfo.BTN_Tab_Basic:SetCheck(false)
    CharacterInfo.BTN_Tab_Title:SetCheck(false)
    CharacterInfo.BTN_Tab_History:SetCheck(true)
    CharacterInfo.BTN_Tab_Challenge:SetCheck(false)
    CharacterInfo.BTN_Tab_Profile:SetCheck(false)
    MyHistory_DataUpdate()
  elseif 3 == index then
    self._frameDefaultBG_Challenge:SetShow(true)
    CharacterInfo.BTN_Tab_Basic:SetCheck(false)
    CharacterInfo.BTN_Tab_Title:SetCheck(false)
    CharacterInfo.BTN_Tab_History:SetCheck(false)
    CharacterInfo.BTN_Tab_Challenge:SetCheck(true)
    CharacterInfo.BTN_Tab_Profile:SetCheck(false)
    Fglobal_Challenge_UpdateData()
  elseif 4 == index then
    self._frameDefaultBG_Profile:SetShow(true)
    CharacterInfo.BTN_Tab_Basic:SetCheck(false)
    CharacterInfo.BTN_Tab_Title:SetCheck(false)
    CharacterInfo.BTN_Tab_History:SetCheck(false)
    CharacterInfo.BTN_Tab_Challenge:SetCheck(false)
    CharacterInfo.BTN_Tab_Profile:SetCheck(true)
    FGlobal_Profile_Update()
  end
end
function SelfCharacterInfo_UpdateTolerance()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local resistStunRate = player:getStunResistance()
  CharacterInfo._progress2_resiststun:SetProgressRate(math.floor(resistStunRate / 10000))
  CharacterInfo._stunPercent:SetText(math.floor(resistStunRate / 10000) .. "%")
  local resistDownRate = player:getKnockdownResistance()
  CharacterInfo._progress2_resistdown:SetProgressRate(math.floor(resistDownRate / 10000))
  CharacterInfo._downPercent:SetText(math.floor(resistDownRate / 10000) .. "%")
  local resistCaptureRate = player:getCatchResistance()
  CharacterInfo._progress2_resistcapture:SetProgressRate(math.floor(resistCaptureRate / 10000))
  CharacterInfo._capturePercent:SetText(math.floor(resistCaptureRate / 10000) .. "%")
  local resistKnockbackRate = player:getKnockbackResistance()
  CharacterInfo._progress2_resistknockback:SetProgressRate(math.floor(resistKnockbackRate / 10000))
  CharacterInfo._knockBackPercent:SetText(math.floor(resistKnockbackRate / 10000) .. "%")
end
local fitness = {
  stamina = 0,
  strength = 1,
  health = 2
}
local staminaLevel = 1
local strengthLevel = 1
local healthLevel = 1
if nil ~= getSelfPlayer() then
  staminaLevel = getSelfPlayer():get():getFitnessLevel(fitness.stamina)
  strengthLevel = getSelfPlayer():get():getFitnessLevel(fitness.strength)
  healthLevel = getSelfPlayer():get():getFitnessLevel(fitness.health)
else
end
function FromClientFitnessUp(addSp, addWeight, addHp, addMp)
  local selfPlayerGet = getSelfPlayer():get()
  local currStamina = Int64toInt32(selfPlayerGet:getCurrFitnessExperiencePoint(fitness.stamina))
  local maxStamina = Int64toInt32(selfPlayerGet:getDemandFItnessExperiencePoint(fitness.stamina))
  local staminaRate = currStamina / maxStamina * 100
  local currStaminaLv = selfPlayerGet:getFitnessLevel(fitness.stamina)
  CharacterInfo._progress2_stamina:SetProgressRate(staminaRate)
  CharacterInfo._value_stamina:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_CRAFTLEVEL") .. tostring(currStaminaLv))
  local currStrength = Int64toInt32(selfPlayerGet:getCurrFitnessExperiencePoint(fitness.strength))
  local maxStrength = Int64toInt32(selfPlayerGet:getDemandFItnessExperiencePoint(fitness.strength))
  local strengthRate = currStrength / maxStrength * 100
  local currStrengthLv = selfPlayerGet:getFitnessLevel(fitness.strength)
  CharacterInfo._progress2_strength:SetProgressRate(strengthRate)
  CharacterInfo._value_strength:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_CRAFTLEVEL") .. tostring(currStrengthLv))
  local currHealth = Int64toInt32(selfPlayerGet:getCurrFitnessExperiencePoint(fitness.health))
  local maxHealth = Int64toInt32(selfPlayerGet:getDemandFItnessExperiencePoint(fitness.health))
  local healthRate = currHealth / maxHealth * 100
  local currHealthLv = selfPlayerGet:getFitnessLevel(fitness.health)
  CharacterInfo._progress2_health:SetProgressRate(healthRate)
  CharacterInfo._value_health:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_CRAFTLEVEL") .. tostring(currHealthLv))
  if currStaminaLv > staminaLevel then
    FGlobal_FitnessLevelUp(addSp, addWeight, addHp, addMp, fitness.stamina)
    staminaLevel = currStaminaLv
    SelfCharacterInfo_UpdateStamina()
  elseif currStrengthLv > strengthLevel then
    FGlobal_FitnessLevelUp(addSp, addWeight, addHp, addMp, fitness.strength)
    strengthLevel = currStrengthLv
    SelfCharacterInfo_UpdateWeight()
  elseif currHealthLv > healthLevel then
    FGlobal_FitnessLevelUp(addSp, addWeight, addHp, addMp, fitness.health)
    healthLevel = currHealthLv
    SelfCharacterInfo_UpdateMainStatus()
    Panel_MainStatus_User_Bar_CharacterInfoWindowUpdate()
  end
end
function CharInfo_MouseOverEvent(sourceType, isOn)
  if isOn == true then
    if sourceType == 0 then
      registTooltipControl(CharacterInfo._hpRegen, Panel_Window_CharInfo_BasicStatus)
      CharacterInfo._hpRegen:SetSize(CharacterInfo._hpRegen:GetTextSizeX() + 20, CharacterInfo._hpRegen:GetSizeY())
      CharacterInfo._hpRegen:SetShow(true)
    elseif sourceType == 1 then
      registTooltipControl(CharacterInfo._mpRegen, Panel_Window_CharInfo_BasicStatus)
      CharacterInfo._mpRegen:SetSize(CharacterInfo._mpRegen:GetTextSizeX() + 20, CharacterInfo._mpRegen:GetSizeY())
      CharacterInfo._mpRegen:SetShow(true)
    elseif sourceType == 2 then
      registTooltipControl(CharacterInfo._weightTooltip, Panel_Window_CharInfo_BasicStatus)
      CharacterInfo._weightTooltip:SetSize(CharacterInfo._weightTooltip:GetTextSizeX() + 20, CharacterInfo._weightTooltip:GetSizeY())
      CharacterInfo._weightTooltip:SetShow(true)
    end
  else
    CharacterInfo._hpRegen:SetShow(false)
    CharacterInfo._mpRegen:SetShow(false)
    CharacterInfo._weightTooltip:SetShow(false)
  end
end
function Fitness_MouseOverEvent(_type)
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  if nil == _type then
    CharacterInfo.fitnessTooltip:SetShow(false)
    return
  end
  local posX = 0
  local posY = 0
  local msg = ""
  if fitness.stamina == _type then
    posX = CharacterInfo._title_stamina:GetSpanSize().x + 70
    posY = CharacterInfo._title_stamina:GetSpanSize().y + 80
    msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_FITNESS_STAMINA_MSG", "type", tostring(ToClient_GetFitnessLevelStatus(_type)))
  elseif fitness.strength == _type then
    posX = CharacterInfo._title_strength:GetSpanSize().x + 70
    posY = CharacterInfo._title_strength:GetSpanSize().y + 80
    msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_FITNESS_STRENGTH_MSG", "type", tostring(ToClient_GetFitnessLevelStatus(_type) / 10000))
  elseif fitness.health == _type then
    posX = CharacterInfo._title_health:GetSpanSize().x + 70
    posY = CharacterInfo._title_health:GetSpanSize().y + 80
    msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_FITNESS_HEALTH_MSG", "type", tostring(ToClient_GetFitnessLevelStatus(_type)))
  else
    return
  end
  CharacterInfo.fitnessTooltip:SetPosX(posX)
  CharacterInfo.fitnessTooltip:SetPosY(posY)
  CharacterInfo.fitnessTooltip:SetText(msg)
  CharacterInfo.fitnessTooltip:SetSize(CharacterInfo.fitnessTooltip:GetTextSizeX() + 20, CharacterInfo.fitnessTooltip:GetSizeY())
  registTooltipControl(CharacterInfo.fitnessTooltip, Panel_Window_CharInfo_BasicStatus)
  CharacterInfo.fitnessTooltip:SetShow(true)
end
function Poten_MouseOverEvent(sourceType, isOn)
  if isOn == true then
    if sourceType == 0 then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo.attackspeed:GetSpanSize().x + 70)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo.attackspeed:GetSpanSize().y + 40)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_0"))
    elseif sourceType == 1 then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo.castspeed:GetSpanSize().x + 70)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo.castspeed:GetSpanSize().y + 40)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_1"))
    elseif sourceType == 2 then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo.movespeed:GetSpanSize().x + 70)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo.movespeed:GetSpanSize().y + 40)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_2"))
    elseif sourceType == 3 then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo.critical:GetSpanSize().x + 70)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo.critical:GetSpanSize().y + 40)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_3"))
    elseif sourceType == 4 then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo.fishTime:GetSpanSize().x + 70)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo.fishTime:GetSpanSize().y + 40)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_4"))
    elseif sourceType == 5 then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo.product:GetSpanSize().x + 70)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo.product:GetSpanSize().y + 40)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_5"))
    elseif sourceType == 6 then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo.dropChance:GetSpanSize().x + 70)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo.dropChance:GetSpanSize().y + 40)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_6"))
    end
    registTooltipControl(CharacterInfo.potenTooltip, Panel_Window_CharInfo_BasicStatus)
    CharacterInfo.potenTooltip:SetShow(true)
    CharacterInfo.potenTooltip:SetSize(CharacterInfo.potenTooltip:GetTextSizeX() + 20, CharacterInfo.potenTooltip:GetTextSizeY() + 5)
    CharacterInfo.potenTooltip:setPadding(UI_PD.ePadding_Left, 5)
    CharacterInfo.potenTooltip:setPadding(UI_PD.ePadding_Top, 5)
    CharacterInfo.potenTooltip:setPadding(UI_PD.ePadding_Right, 5)
    CharacterInfo.potenTooltip:setPadding(UI_PD.ePadding_Bottom, 5)
  else
    CharacterInfo.potenTooltip:SetShow(false)
  end
end
function Craft_MouseOverEvent(sourceType, isOn)
  if true == isOn then
    if 0 == sourceType then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo._gatherTitle:GetPosX() + 40)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo._gatherTitle:GetPosY() + 30)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_1"))
    elseif 1 == sourceType then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo._manufactureTitle:GetPosX() + 40)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo._manufactureTitle:GetPosY() + 30)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_2"))
    elseif 2 == sourceType then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo._cookingTitle:GetPosX() + 40)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo._cookingTitle:GetPosY() + 30)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_2"))
    elseif 3 == sourceType then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo._alchemyTitle:GetPosX() + 40)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo._alchemyTitle:GetPosY() + 30)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_2"))
    elseif 4 == sourceType then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo._trainingTitle:GetPosX() + 40)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo._trainingTitle:GetPosY() + 30)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_3"))
    elseif 5 == sourceType then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo._tradeTitle:GetPosX() + 40)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo._tradeTitle:GetPosY() + 30)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_4"))
    elseif 6 == sourceType then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo._fishingTitle:GetPosX() + 40)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo._fishingTitle:GetPosY() + 30)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_5"))
    elseif 7 == sourceType then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo._huntingTitle:GetPosX() + 40)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo._huntingTitle:GetPosY() + 30)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_6"))
    elseif 8 == sourceType then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo._growthTitle:GetPosX() + 40)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo._growthTitle:GetPosY() + 30)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_7"))
    elseif 9 == sourceType then
      CharacterInfo.potenTooltip:SetPosX(CharacterInfo._sailTitle:GetPosX() + 40)
      CharacterInfo.potenTooltip:SetPosY(CharacterInfo._sailTitle:GetPosY() + 30)
      CharacterInfo.potenTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_8"))
    end
    registTooltipControl(CharacterInfo.potenTooltip, Panel_Window_CharInfo_BasicStatus)
    CharacterInfo.potenTooltip:SetShow(true)
    CharacterInfo.potenTooltip:SetSize(CharacterInfo.potenTooltip:GetTextSizeX() + 20, CharacterInfo.potenTooltip:GetTextSizeY() + 5)
    CharacterInfo.potenTooltip:setPadding(UI_PD.ePadding_Left, 5)
    CharacterInfo.potenTooltip:setPadding(UI_PD.ePadding_Top, 5)
    CharacterInfo.potenTooltip:setPadding(UI_PD.ePadding_Right, 5)
    CharacterInfo.potenTooltip:setPadding(UI_PD.ePadding_Bottom, 5)
  else
    CharacterInfo.potenTooltip:SetShow(false)
  end
end
function Regist_MouseOverEvent(tipType, isShow)
  local name, desc, control
  local self = CharacterInfo
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_STUN_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_STUN_TOOLTIP_DESC")
    control = self._stunTitle
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_DOWN_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_DOWN_TOOLTIP_DESC")
    control = self._downTitle
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_CAPTURE_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_CAPTURE_TOOLTIP_DESC")
    control = self._captureTitle
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_KNOCKBACK_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_KNOCKBACK_TOOLTIP_DESC")
    control = self._knockBackTitle
  end
  if isShow == true then
    registTooltipControl(control, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
local function initProgress()
  CharacterInfo._progress2_characterlevel:SetProgressRate(0)
  CharacterInfo._progress2_hp:SetProgressRate(0)
  CharacterInfo._progress2_mp:SetProgressRate(0)
  CharacterInfo._progress2_weightvalue_Money:SetProgressRate(0)
  CharacterInfo._progress2_weightvalue_Equip:SetProgressRate(0)
  CharacterInfo._progress2_weightvalue_Inventory:SetProgressRate(0)
  CharacterInfo._progress2_gather:SetProgressRate(0)
  CharacterInfo._progress2_manufacture:SetProgressRate(0)
  CharacterInfo._progress2_cooking:SetProgressRate(0)
  CharacterInfo._progress2_alchemy:SetProgressRate(0)
  CharacterInfo._progress2_resiststun:SetProgressRate(0)
  CharacterInfo._progress2_resistdown:SetProgressRate(0)
  CharacterInfo._progress2_resistcapture:SetProgressRate(0)
  CharacterInfo._progress2_resistknockback:SetProgressRate(0)
  CharacterInfo._progress2_stamina:SetProgressRate(0)
  CharacterInfo._progress2_strength:SetProgressRate(0)
  CharacterInfo._progress2_health:SetProgressRate(0)
end
function CharacterInfoWindow_Show()
  PaGlobal_CharacterInfoPanel_SetShowPanelStatus(true, true)
  CharacterInfoWindowUpdate()
  HandleClicked_CharacterInfo_Tab(0)
  CharacterInfo.BTN_Tab_Basic:SetCheck(true)
  CharacterInfo.BTN_Tab_Title:SetCheck(false)
  CharacterInfo.BTN_Tab_History:SetCheck(false)
  CharacterInfo.BTN_Tab_Challenge:SetCheck(false)
  CharacterInfo.BTN_Tab_Profile:SetCheck(false)
  FromClientFitnessUp(0, 0, 0, 0)
  local msg = ToClient_GetUserIntroduction()
  if nil == msg or "" == msg then
  end
  CharacterInfo._btnIntroduce:SetPosX(CharacterInfo.txt_BaseInfo_Title:GetTextSizeX() + 30)
end
function CharacterInfoWindow_Hide()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  if CharacterInfo._frameDefaultBG_Challenge:GetShow() then
    CharacterInfoWindowUpdate()
    HandleClicked_CharacterInfo_Tab(0)
    FromClientFitnessUp(0, 0, 0, 0)
    CharacterInfo.BTN_Tab_Basic:SetCheck(true)
    CharacterInfo.BTN_Tab_Title:SetCheck(false)
    CharacterInfo.BTN_Tab_History:SetCheck(false)
    CharacterInfo.BTN_Tab_Challenge:SetCheck(false)
    CharacterInfo.BTN_Tab_Profile:SetCheck(false)
    PaGlobal_CharacterInfoPanel_SetShowPanelStatus(false, false)
    initProgress()
    HelpMessageQuestion_Out()
  else
    PaGlobal_CharacterInfoPanel_SetShowPanelStatus(false, false)
    initProgress()
    HelpMessageQuestion_Out()
  end
  if false == CheckChattingInput() then
    ClearFocusEdit()
  end
  Panel_Window_CharInfo_Status:CloseUISubApp()
  CharacterInfo.checkPopUp:SetCheck(false)
  Panel_Tooltip_Item_hideTooltip()
end
function HandleClicked_CharacterInfo_PopUp()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  if CharacterInfo.checkPopUp:IsCheck() then
    Panel_Window_CharInfo_Status:OpenUISubApp()
  else
    Panel_Window_CharInfo_Status:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function FGlobal_Challenge_Show()
  PaGlobal_CharacterInfoPanel_SetShowPanelStatus(true, true)
  HandleClicked_CharacterInfo_Tab(3)
  FGlobal_TapButton_Complete()
  CharacterInfo.BTN_Tab_Basic:SetCheck(false)
  CharacterInfo.BTN_Tab_Title:SetCheck(false)
  CharacterInfo.BTN_Tab_History:SetCheck(false)
  CharacterInfo.BTN_Tab_Challenge:SetCheck(true)
  CharacterInfo.BTN_Tab_Profile:SetCheck(false)
end
function FGlobal_Challenge_Hide()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  if CharacterInfo._frameDefaultBG_Basic:GetShow() then
    HandleClicked_CharacterInfo_Tab(3)
    CharacterInfo.BTN_Tab_Basic:SetCheck(false)
    CharacterInfo.BTN_Tab_Title:SetCheck(false)
    CharacterInfo.BTN_Tab_History:SetCheck(false)
    CharacterInfo.BTN_Tab_Challenge:SetCheck(true)
    CharacterInfo.BTN_Tab_Profile:SetCheck(false)
  else
    PaGlobal_CharacterInfoPanel_SetShowPanelStatus(false, false)
    Panel_Tooltip_Item_hideTooltip()
  end
  if false == CheckChattingInput() then
    ClearFocusEdit()
  end
end
function CharacterInfoWindow_ShowToggle()
  if PaGlobal_CharacterInfoPanel_GetShowPanelStatus() then
    CharacterInfoWindow_Hide()
    audioPostEvent_SystemUi(1, 0)
    CraftLevInfo_Show()
  else
    CharacterInfoWindow_Show()
    audioPostEvent_SystemUi(1, 1)
    CraftLevInfo_Hide()
  end
end
function MyIntroduce_Init()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  local self = CharacterInfo._introduce
  self._editText:SetMaxEditLine(6)
  self._editText:SetMaxInput(120)
  self._closeIntro:addInputEvent("Mouse_LUp", "IntroduceMyself_ShowToggle(false)")
  self._editText:addInputEvent("Mouse_LUp", "HandleClicked_IntroduceMyself()")
  self._btnSetIntro:addInputEvent("Mouse_LUp", "HandleClicked_SetIntroduce()")
  self._btnResetIntro:addInputEvent("Mouse_LUp", "HandleClicked_ResetIntroduce()")
end
function IntroduceMyself_ShowToggle(isShow)
  local self = CharacterInfo._introduce
  if nil == isShow then
    isShow = true
  end
  if self._bg:GetShow() then
    isShow = false
  end
  for _, control in pairs(self) do
    control:SetShow(isShow)
  end
  if not isShow then
    FGlobal_MyIntroduceClearFocusEdit()
  end
  local msg = ToClient_GetUserIntroduction()
  CharacterInfo._introduce._editText:SetEditText(msg)
end
function HandleClicked_IntroduceMyself()
  local self = CharacterInfo._introduce
  SetFocusEdit(self._editText)
  self._editText:SetEditText(self._editText:GetEditText(), true)
end
function HandleClicked_SetIntroduce()
  local self = CharacterInfo._introduce
  local msg = self._editText:GetEditText()
  ToClient_RequestSetUserIntroduction(msg)
  ClearFocusEdit()
  IntroduceMyself_ShowToggle(false)
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_MYINTRODUCE_REGIST"))
  CharacterInfo._btnIntroduce:EraseAllEffect()
  if nil == msg or "" == nil then
    CharacterInfo._btnIntroduce:AddEffect("fUI_SelfCharacterInfo_01A", true, 0, 0)
  end
end
function HandleClicked_ResetIntroduce()
  local self = CharacterInfo._introduce
  local msg = ""
  self._editText:SetEditText(msg)
  ToClient_RequestSetUserIntroduction(msg)
  ClearFocusEdit()
  CharacterInfo._btnIntroduce:EraseAllEffect()
  CharacterInfo._btnIntroduce:AddEffect("fUI_SelfCharacterInfo_01A", true, 0, 0)
end
function FGlobal_MyIntroduceClearFocusEdit()
  ClearFocusEdit()
  CheckChattingInput()
end
function FGlobal_CheckMyIntroduceUiEdit(targetUI)
  return nil ~= targetUI and targetUI:GetKey() == CharacterInfo._introduce._editText:GetKey()
end
function FamilyPoints_SimpleTooltip(isShow, tipType)
  local self = CharacterInfo
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAMILYPOINTS_SUM_TOOLTIP_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAMILYPOINTS_SUM_TOOLTIP_DESC")
    control = self.familyPoints
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAMILYPOINTS_COMBAT_TOOLTIP_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAMILYPOINTS_COMBAT_TOOLTIP_DESC")
    control = self.familyCombatPoints
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAMILYPOINTS_LIFE_TOOLTIP_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAMILYPOINTS_LIFE_TOOLTIP_DESC")
    control = self.familyLifePoints
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAMILYPOINTS_ETC_TOOLTIP_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAMILYPOINTS_ETC_TOOLTIP_DESC")
    control = self.familyEtcPoints
  end
  if isShow == true then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function CharacterInfo:registEventHandler()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  self._hpTitle:addInputEvent("Mouse_On", "CharInfo_MouseOverEvent( 0, true )")
  self._hpTitle:addInputEvent("Mouse_Out", "CharInfo_MouseOverEvent( 0, false )")
  self._mpTitle:addInputEvent("Mouse_On", "CharInfo_MouseOverEvent( 1, true )")
  self._mpTitle:addInputEvent("Mouse_Out", "CharInfo_MouseOverEvent( 1, false )")
  self._weightTitle:addInputEvent("Mouse_On", "CharInfo_MouseOverEvent( 2, true )")
  self._weightTitle:addInputEvent("Mouse_Out", "CharInfo_MouseOverEvent( 2, false )")
  self.attackspeed:addInputEvent("Mouse_On", "Poten_MouseOverEvent( 0, true )")
  self.attackspeed:addInputEvent("Mouse_Out", "Poten_MouseOverEvent( 0, false )")
  self.castspeed:addInputEvent("Mouse_On", "Poten_MouseOverEvent( 1, true )")
  self.castspeed:addInputEvent("Mouse_Out", "Poten_MouseOverEvent( 1, false )")
  self.movespeed:addInputEvent("Mouse_On", "Poten_MouseOverEvent( 2, true )")
  self.movespeed:addInputEvent("Mouse_Out", "Poten_MouseOverEvent( 2, false )")
  self.critical:addInputEvent("Mouse_On", "Poten_MouseOverEvent( 3, true )")
  self.critical:addInputEvent("Mouse_Out", "Poten_MouseOverEvent( 3, false )")
  self.fishTime:addInputEvent("Mouse_On", "Poten_MouseOverEvent( 4, true )")
  self.fishTime:addInputEvent("Mouse_Out", "Poten_MouseOverEvent( 4, false )")
  self.product:addInputEvent("Mouse_On", "Poten_MouseOverEvent( 5, true )")
  self.product:addInputEvent("Mouse_Out", "Poten_MouseOverEvent( 5, false )")
  self.dropChance:addInputEvent("Mouse_On", "Poten_MouseOverEvent( 6, true )")
  self.dropChance:addInputEvent("Mouse_Out", "Poten_MouseOverEvent( 6, false )")
  self._gatherTitle:addInputEvent("Mouse_On", "Craft_MouseOverEvent( 0, true )")
  self._gatherTitle:addInputEvent("Mouse_Out", "Craft_MouseOverEvent( 0, false )")
  self._manufactureTitle:addInputEvent("Mouse_On", "Craft_MouseOverEvent( 1, true )")
  self._manufactureTitle:addInputEvent("Mouse_Out", "Craft_MouseOverEvent( 1, false )")
  self._cookingTitle:addInputEvent("Mouse_On", "Craft_MouseOverEvent( 2, true )")
  self._cookingTitle:addInputEvent("Mouse_Out", "Craft_MouseOverEvent( 2, false )")
  self._alchemyTitle:addInputEvent("Mouse_On", "Craft_MouseOverEvent( 3, true )")
  self._alchemyTitle:addInputEvent("Mouse_Out", "Craft_MouseOverEvent( 3, false )")
  self._trainingTitle:addInputEvent("Mouse_On", "Craft_MouseOverEvent( 4, true )")
  self._trainingTitle:addInputEvent("Mouse_Out", "Craft_MouseOverEvent( 4, false )")
  self._tradeTitle:addInputEvent("Mouse_On", "Craft_MouseOverEvent( 5, true )")
  self._tradeTitle:addInputEvent("Mouse_Out", "Craft_MouseOverEvent( 5, false )")
  self._fishingTitle:addInputEvent("Mouse_On", "Craft_MouseOverEvent( 6, true )")
  self._fishingTitle:addInputEvent("Mouse_Out", "Craft_MouseOverEvent( 6, false )")
  self._huntingTitle:addInputEvent("Mouse_On", "Craft_MouseOverEvent( 7, true )")
  self._huntingTitle:addInputEvent("Mouse_Out", "Craft_MouseOverEvent( 7, false )")
  self._growthTitle:addInputEvent("Mouse_On", "Craft_MouseOverEvent( 8, true )")
  self._growthTitle:addInputEvent("Mouse_Out", "Craft_MouseOverEvent( 8, false )")
  self._sailTitle:addInputEvent("Mouse_On", "Craft_MouseOverEvent( 9, true )")
  self._sailTitle:addInputEvent("Mouse_Out", "Craft_MouseOverEvent( 9, false )")
  self._stunTitle:addInputEvent("Mouse_On", "Regist_MouseOverEvent( 0, true)")
  self._stunTitle:addInputEvent("Mouse_Out", "Regist_MouseOverEvent( false)")
  self._downTitle:addInputEvent("Mouse_On", "Regist_MouseOverEvent( 1, true)")
  self._downTitle:addInputEvent("Mouse_Out", "Regist_MouseOverEvent( false)")
  self._captureTitle:addInputEvent("Mouse_On", "Regist_MouseOverEvent( 2, true)")
  self._captureTitle:addInputEvent("Mouse_Out", "Regist_MouseOverEvent( false)")
  self._knockBackTitle:addInputEvent("Mouse_On", "Regist_MouseOverEvent( 3, true)")
  self._knockBackTitle:addInputEvent("Mouse_Out", "Regist_MouseOverEvent( false)")
  self._hpTitle:setTooltipEventRegistFunc("CharInfo_MouseOverEvent( 0, true )")
  self._mpTitle:setTooltipEventRegistFunc("CharInfo_MouseOverEvent( 1, true )")
  self._weightTitle:setTooltipEventRegistFunc("CharInfo_MouseOverEvent( 2, true )")
  self.attackspeed:setTooltipEventRegistFunc("Poten_MouseOverEvent( 0, true )")
  self.castspeed:setTooltipEventRegistFunc("Poten_MouseOverEvent( 1, true )")
  self.movespeed:setTooltipEventRegistFunc("Poten_MouseOverEvent( 2, true )")
  self.critical:setTooltipEventRegistFunc("Poten_MouseOverEvent( 3, true )")
  self.fishTime:setTooltipEventRegistFunc("Poten_MouseOverEvent( 4, true )")
  self.product:setTooltipEventRegistFunc("Poten_MouseOverEvent( 5, true )")
  self.dropChance:setTooltipEventRegistFunc("Poten_MouseOverEvent( 6, true )")
  self._gatherTitle:setTooltipEventRegistFunc("Craft_MouseOverEvent( 0, true )")
  self._manufactureTitle:setTooltipEventRegistFunc("Craft_MouseOverEvent( 1, true )")
  self._cookingTitle:setTooltipEventRegistFunc("Craft_MouseOverEvent( 2, true )")
  self._alchemyTitle:setTooltipEventRegistFunc("Craft_MouseOverEvent( 3, true )")
  self._trainingTitle:setTooltipEventRegistFunc("Craft_MouseOverEvent( 4, true )")
  self._tradeTitle:setTooltipEventRegistFunc("Craft_MouseOverEvent( 5, true )")
  self._fishingTitle:setTooltipEventRegistFunc("Craft_MouseOverEvent( 6, true )")
  self._huntingTitle:setTooltipEventRegistFunc("Craft_MouseOverEvent( 7, true )")
  self._growthTitle:setTooltipEventRegistFunc("Craft_MouseOverEvent( 8, true )")
  self._sailTitle:setTooltipEventRegistFunc("Craft_MouseOverEvent( 9, true )")
  self._stunTitle:setTooltipEventRegistFunc(" Regist_MouseOverEvent( 0, true) ")
  self._downTitle:setTooltipEventRegistFunc(" Regist_MouseOverEvent( 1, true) ")
  self._captureTitle:setTooltipEventRegistFunc(" Regist_MouseOverEvent( 2, true) ")
  self._knockBackTitle:setTooltipEventRegistFunc(" Regist_MouseOverEvent( 3, true) ")
  self.BTN_Tab_Basic:addInputEvent("Mouse_LUp", "HandleClicked_CharacterInfo_Tab(" .. 0 .. ")")
  self.BTN_Tab_Title:addInputEvent("Mouse_LUp", "HandleClicked_CharacterInfo_Tab(" .. 1 .. ")")
  self.BTN_Tab_History:addInputEvent("Mouse_LUp", "HandleClicked_CharacterInfo_Tab(" .. 2 .. ")")
  self.BTN_Tab_Challenge:addInputEvent("Mouse_LUp", "HandleClicked_CharacterInfo_Tab(" .. 3 .. ")")
  self.BTN_Tab_Profile:addInputEvent("Mouse_LUp", "HandleClicked_CharacterInfo_Tab(" .. 4 .. ")")
  self._btnIntroduce:addInputEvent("Mouse_LUp", "IntroduceMyself_ShowToggle()")
  if false == _ContentsGroup_NewUI_LifeRanking_All then
    self._ranker:addInputEvent("Mouse_LUp", "FGlobal_LifeRanking_Open()")
  else
    self._ranker:addInputEvent("Mouse_LUp", "PaGlobal_LifeRanking_Open_All()")
  end
  self._title_stamina:addInputEvent("Mouse_On", "Fitness_MouseOverEvent(" .. 0 .. ")")
  self._title_stamina:addInputEvent("Mouse_Out", "Fitness_MouseOverEvent()")
  self._title_strength:addInputEvent("Mouse_On", "Fitness_MouseOverEvent(" .. 1 .. ")")
  self._title_strength:addInputEvent("Mouse_Out", "Fitness_MouseOverEvent()")
  self._title_health:addInputEvent("Mouse_On", "Fitness_MouseOverEvent(" .. 2 .. ")")
  self._title_health:addInputEvent("Mouse_Out", "Fitness_MouseOverEvent()")
  self._title_stamina:setTooltipEventRegistFunc("Fitness_MouseOverEvent(" .. 0 .. ")")
  self._title_strength:setTooltipEventRegistFunc("Fitness_MouseOverEvent(" .. 1 .. ")")
  self._title_health:setTooltipEventRegistFunc("Fitness_MouseOverEvent(" .. 2 .. ")")
  self.familyPoints:addInputEvent("Mouse_On", "FamilyPoints_SimpleTooltip(true,\t0)")
  self.familyPoints:addInputEvent("Mouse_Out", "FamilyPoints_SimpleTooltip(false,\t0)")
  self.familyCombatPoints:addInputEvent("Mouse_On", "FamilyPoints_SimpleTooltip(true,\t1)")
  self.familyCombatPoints:addInputEvent("Mouse_Out", "FamilyPoints_SimpleTooltip(false,\t1)")
  self.familyLifePoints:addInputEvent("Mouse_On", "FamilyPoints_SimpleTooltip(true,\t2)")
  self.familyLifePoints:addInputEvent("Mouse_Out", "FamilyPoints_SimpleTooltip(false,\t2)")
  self.familyEtcPoints:addInputEvent("Mouse_On", "FamilyPoints_SimpleTooltip(true,\t3)")
  self.familyEtcPoints:addInputEvent("Mouse_Out", "FamilyPoints_SimpleTooltip(false,\t3)")
  self.checkPopUp:addInputEvent("Mouse_LUp", "HandleClicked_CharacterInfo_PopUp()")
  self.checkPopUp:addInputEvent("Mouse_On", "CharacterInfo_PopUp_ShowIconToolTip( true )")
  self.checkPopUp:addInputEvent("Mouse_Out", "CharacterInfo_PopUp_ShowIconToolTip( false )")
  self._buttonClose:addInputEvent("Mouse_LUp", "CharacterInfoWindow_Hide()")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"SelfCharacterInfo\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"SelfCharacterInfo\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"SelfCharacterInfo\", \"false\")")
end
function HandleMouseEvent_TabButtonDesc(descType, isOn)
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  if descType == 0 and isOn == true then
    CharacterInfo.txt_CharinfoDesc:SetAlpha(0)
    CharacterInfo.txt_CharinfoDesc:SetFontAlpha(0)
    CharacterInfo.txt_CharinfoDesc:ResetVertexAni()
    local AniInfo = UIAni.AlphaAnimation(1, CharacterInfo.txt_CharinfoDesc, 0, 0.15)
    CharacterInfo.txt_CharinfoDesc:SetShow(true)
  elseif descType == 1 and isOn == true then
    CharacterInfo.txt_TitleDesc:SetAlpha(0)
    CharacterInfo.txt_TitleDesc:SetFontAlpha(0)
    CharacterInfo.txt_TitleDesc:ResetVertexAni()
    local AniInfo = UIAni.AlphaAnimation(1, CharacterInfo.txt_TitleDesc, 0, 0.15)
    CharacterInfo.txt_TitleDesc:SetShow(true)
  elseif descType == 2 and isOn == true then
    CharacterInfo.txt_HistoryDesc:SetAlpha(0)
    CharacterInfo.txt_HistoryDesc:SetFontAlpha(0)
    CharacterInfo.txt_HistoryDesc:ResetVertexAni()
    local AniInfo = UIAni.AlphaAnimation(1, CharacterInfo.txt_HistoryDesc, 0, 0.15)
    CharacterInfo.txt_HistoryDesc:SetShow(true)
  elseif descType == 3 and isOn == true then
    CharacterInfo.txt_ChallengeDesc:SetAlpha(0)
    CharacterInfo.txt_ChallengeDesc:SetFontAlpha(0)
    CharacterInfo.txt_ChallengeDesc:ResetVertexAni()
    local AniInfo = UIAni.AlphaAnimation(1, CharacterInfo.txt_ChallengeDesc, 0, 0.15)
    CharacterInfo.txt_ChallengeDesc:SetShow(true)
  end
  if descType == 0 and isOn == false then
    CharacterInfo.txt_CharinfoDesc:ResetVertexAni()
    local AniInfo = UIAni.AlphaAnimation(0, CharacterInfo.txt_CharinfoDesc, 0, 0.1)
    AniInfo:SetHideAtEnd(true)
  elseif descType == 1 and isOn == false then
    CharacterInfo.txt_TitleDesc:ResetVertexAni()
    local AniInfo1 = UIAni.AlphaAnimation(0, CharacterInfo.txt_TitleDesc, 0, 0.1)
    AniInfo1:SetHideAtEnd(true)
  elseif descType == 2 and isOn == false then
    CharacterInfo.txt_HistoryDesc:ResetVertexAni()
    local AniInfo2 = UIAni.AlphaAnimation(0, CharacterInfo.txt_HistoryDesc, 0, 0.1)
    AniInfo2:SetHideAtEnd(true)
  elseif descType == 3 and isOn == false then
    CharacterInfo.txt_ChallengeDesc:ResetVertexAni()
    local AniInfo3 = UIAni.AlphaAnimation(0, CharacterInfo.txt_ChallengeDesc, 0, 0.1)
    AniInfo3:SetHideAtEnd(true)
  end
end
function FGlobal_MaxWeightChanged()
  SelfCharacterInfo_UpdateWeight()
end
function CharacterInfo_SimpleTooltip(isShow, tipType)
  if nil == isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_PCROOMPLAYTIME")
    control = CharacterInfo._PcRoomTimer
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TODAYJOINTIME")
    control = CharacterInfo._todayPlayTime
  end
  TooltipSimple_Show(control, name, desc)
end
function FromClient_CharacterInfo_PlayerTotalStat_Changed(actorKey, totalStatValue)
  if false == PaGlobal_CharacterInfoPanel_GetShowPanelStatus() then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local playerActorProxyWrapper = getPlayerActor(actorKey)
  if nil == playerActorProxyWrapper then
    return
  end
  if playerActorProxyWrapper:getActorKey() ~= selfPlayer:getActorKey() then
    return
  end
  local totalStatValue = math.floor(totalStatValue)
  local tier = ToClient_GetTier(totalStatValue) - 1
  CharacterInfo_changedBattlePoint(totalStatValue, tier)
end
local setTierIcon = function(iconControl, iconIdx, leftX, topY, xCount, iconSize)
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  iconControl:ChangeTextureInfoName("new_ui_common_forlua/default/Default_Etc_04.dds")
  iconControl:SetShow(true)
  local x1, y1, x2, y2
  x1 = leftX + (iconSize + 1) * (iconIdx % xCount)
  y1 = topY + (iconSize + 1) * math.floor(iconIdx / xCount)
  x2 = x1 + iconSize
  y2 = y1 + iconSize
  x1, y1, x2, y2 = setTextureUV_Func(iconControl, x1, y1, x2, y2)
  iconControl:getBaseTexture():setUV(x1, y1, x2, y2)
  iconControl:setRenderTexture(iconControl:getBaseTexture())
end
function CharacterInfo_changedBattlePoint(battlePoint, tier)
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  if false == PaGlobal_CharacterInfoPanel_GetShowPanelStatus() then
    return
  end
  local tierName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOTALSTAT_TIERNAME_" .. tier + 1, "totalStat", battlePoint)
  CharacterInfo._battlePoint:SetText(tierName)
  CharacterInfo._battlePoint:ChangeTextureInfoName("")
  CharacterInfo._battlePoint:SetShow(true)
  CharacterInfo._battlePointIcon:SetShow(true)
  CharacterInfo._battlePointIcon:SetPosX(Panel_Window_CharInfo_BasicStatus:GetSizeX() - (CharacterInfo._battlePoint:GetTextSizeX() + CharacterInfo._battlePointIcon:GetSizeX() + 30))
  local battlePoint = math.floor(getSelfPlayer():getTotalStatValue())
  local highTier = ToClient_GetHighTierByTotalStat(battlePoint)
  if true == _ContentsGroup_StatTierIcon and highTier >= 1 and highTier <= ToClient_GetHighTierCount() then
    setTierIcon(CharacterInfo._battlePointIcon, 3 - highTier, 225, 142, 3, 42)
  else
    local tier = ToClient_GetTier(battlePoint)
    setTierIcon(CharacterInfo._battlePointIcon, 8 - tier, 354, 99, 4, 24)
  end
end
function CharacterInfo_updatePlayerTotalStat()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local totalStatValue = math.floor(selfPlayer:getTotalStatValue())
  local tier = ToClient_GetTier(totalStatValue) - 1
  CharacterInfo_changedBattlePoint(totalStatValue, tier)
end
function CharacterInfo:registMessageHandler()
  registerEvent("FromClient_SelfPlayerHpChanged", "SelfCharacterInfo_UpdateMainStatus")
  registerEvent("FromClient_SelfPlayerMpChanged", "SelfCharacterInfo_UpdateMainStatus")
  registerEvent("FromClient_SelfPlayerMainStatusRegenChanged", "SelfCharacterInfo_UpdateMainStatusRegen")
  registerEvent("FromClient_WpChanged", "SelfCharacterInfo_UpdateWp")
  registerEvent("FromClient_UpdateExplorePoint", "SelfCharacterInfo_UpdateExplorePoint")
  registerEvent("FromClient_SelfPlayerExpChanged", "SelfCharacterInfo_UpdateLevel")
  registerEvent("EventSelfPlayerLevelUp", "SelfCharacterInfo_UpdateLevel")
  registerEvent("FromClient_InventoryUpdate", "SelfCharacterInfo_UpdateWeight")
  registerEvent("FromClient_WeightChanged", "SelfCharacterInfo_UpdateWeight")
  registerEvent("EventEquipmentUpdate", "SelfCharacterInfo_UpdateAttackStat")
  registerEvent("FromClient_SelfPlayerTendencyChanged", "SelfCharacterInfo_UpdateTendency")
  registerEvent("FromClient_UpdateSelfPlayerStatPoint", "SelfCharacterInfo_UpdatePotenGradeInfo")
  registerEvent("FromClientFitnessUp", "FromClientFitnessUp")
  registerEvent("FromClient_UpdateSelfPlayerLifeExp", "SelfCharacterInfo_UpdateCraftLevel")
  registerEvent("FromClient_UpdateTolerance", "SelfCharacterInfo_UpdateTolerance")
  registerEvent("EventStaminaUpdate", "SelfCharacterInfo_UpdateStamina")
  registerEvent("onScreenResize", "CharacterInfo_onScreenResize")
  registerEvent("FromClient_PlayerTotalStat_Changed", "FromClient_CharacterInfo_PlayerTotalStat_Changed")
  registerEvent("FromClient_FamilySpeicalInfoChange", "FromClient_FamilySpeicalInfoChange_CharacterInfo")
  registerEvent("FromClient_CharacterSpeicalInfoChange", "FromClient_CharacterSpeicalInfoChange_CharacterInfo")
end
function FromClient_FamilySpeicalInfoChange_CharacterInfo()
  if PaGlobal_CharacterInfoPanel_GetShowPanelStatus() then
    return
  end
  CharacterInfoWindowUpdate()
end
function FromClient_CharacterSpeicalInfoChange_CharacterInfo()
  if PaGlobal_CharacterInfoPanel_GetShowPanelStatus() then
    return
  end
  CharacterInfoWindowUpdate()
end
function CharacterInfo_PopUp_ShowIconToolTip(isShow)
  if isShow then
    local self = CharacterInfo
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
    if self.checkPopUp:IsCheck() then
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_CHECK_TOOLTIP")
    else
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_NOCHECK_TOOLTIP")
    end
    TooltipSimple_Show(self.checkPopUp, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function CharacterInfo_onScreenResize()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  Panel_Window_CharInfo_Status:SetPosX(5)
  Panel_Window_CharInfo_Status:SetPosY(getScreenSizeY() / 2 - Panel_Window_CharInfo_Status:GetSizeY() / 2)
end
function FromClient_CharacterInfo_Init()
  PaGlobal_CharacterInfo_Initialize()
  CharacterInfo:registMessageHandler()
end
function PaGlobal_CharacterInfo_Initialize()
  CharacterInfo:Init()
  CharacterInfoWindowUpdate()
  CharacterInfo:registEventHandler()
  MyIntroduce_Init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_CharacterInfo_Init")
