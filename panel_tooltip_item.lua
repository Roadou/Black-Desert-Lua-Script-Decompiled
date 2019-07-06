local UI_TM = CppEnums.TextMode
local _const = Defines.u64_const
local u64_hour = toUint64(0, 3600)
local u64_minute = toUint64(0, 60)
local UI_color = Defines.Color
local isGrowthContents = ToClient_IsContentsGroupOpen("35")
local isTotemContents = ToClient_IsContentsGroupOpen("44")
local isQuestBookContents = ToClient_IsContentsGroupOpen("335")
local isExtractionCommon = ToClient_IsContentsGroupOpen("1006")
local isExtractionJapan = ToClient_IsContentsGroupOpen("1007")
local isItemLock = ToClient_IsContentsGroupOpen("219")
local isCronStone = ToClient_IsContentsGroupOpen("74")
local isMaxEnchanterEnable = ToClient_IsContentsGroupOpen("352")
local _firstTradeInfoData, _secondTradeInfoData
local normalTooltip = {
  mainPanel = Panel_Tooltip_Item,
  itemName = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_Name"),
  itemIcon = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_Icon"),
  enchantLevel = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_Enchant_value"),
  itemType = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_Type"),
  dying = UI.getChildControl(Panel_Tooltip_Item, "StaticText_Dying"),
  isEnchantable = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_isEnchantable"),
  _txt_repair = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_isRepair"),
  isSealed = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_isSealed"),
  bindType = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_BindType"),
  balksExtraction = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_Balks"),
  cronsExtraction = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_Cron"),
  useDyeColorTitle = UI.getChildControl(Panel_Tooltip_Item, "StaticText_DyeColorInfo"),
  useDyeColorIcon_Part = {
    [0] = UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part1"),
    UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part2"),
    UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part3"),
    UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part4"),
    UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part5"),
    UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part6"),
    UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part7"),
    UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part8"),
    UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part9"),
    UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part10"),
    UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part11"),
    UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part12")
  },
  useLimit_category = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_category"),
  useLimit_panel = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_panel"),
  useLimit_level = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_level"),
  useLimit_level_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_level_value"),
  useLimit_extendedslot = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_extendedslot"),
  useLimit_extendedslot_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_extendedslot_value"),
  useLimit_class = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_class"),
  useLimit_class_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_class_value"),
  useLimit_Exp = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_Exp"),
  useLimit_Exp_gage = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_Exp_gage"),
  useLimit_Exp_gage_value = UI.getChildControl(Panel_Tooltip_Item, "Progress_UseLimit_Exp_gage_value"),
  useLimit_Exp_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_Exp_value"),
  useLimit_endurance = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_endurance"),
  useLimit_endurance_gage = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_endurance_gage"),
  useLimit_endurance_gage_value = UI.getChildControl(Panel_Tooltip_Item, "Progress_UseLimit_endurance_gage_value"),
  useLimit_dynamic_endurance_gage_value = UI.getChildControl(Panel_Tooltip_Item, "Progress2_MaxEndurance"),
  useLimit_endurance_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_endurance_value"),
  remainTime = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_remainTime"),
  remainTime_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_remainTime_value"),
  expireIcon_white = UI.getChildControl(Panel_Tooltip_Item, "Static_Expire_Icon1"),
  expireIcon_red = UI.getChildControl(Panel_Tooltip_Item, "Static_Expire_Icon2"),
  expireIcon_end = UI.getChildControl(Panel_Tooltip_Item, "Static_Expire_Icon3"),
  defaultEffect_category = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_category"),
  defaultEffect_panel = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_panel"),
  attack = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attack"),
  attack_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attack_value"),
  attack_diffValue = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attackDiff_value"),
  isMeleeAttack = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attack_isMeleeAttack"),
  isRangeAttack = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attack_isRangeAttack"),
  isMagicAttack = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attack_isMagicAttack"),
  defense = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_defense"),
  defense_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_defense_value"),
  defense_diffValue = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_defenseDiff_value"),
  weight = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_weight"),
  weight_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_weight_value"),
  weight_diffValue = UI.getChildControl(Panel_Tooltip_Item, "StaticText_DefaultEffect_weightDiff_value"),
  _hit = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_hit"),
  _hit_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_hit_value"),
  _hit_diffValue = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_hitDiff_value"),
  _dv = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_dv"),
  _dv_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_dv_value"),
  _dv_diffValue = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_dvDiff_value"),
  _pv = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_pv"),
  _pv_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_pv_value"),
  _pv_diffValue = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_pvDiff_value"),
  _txt_MaxEnchanter = UI.getChildControl(Panel_Tooltip_Item, "StaticText_MaxEnchantCharName"),
  soketOption_panel = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_SoketOption_panel"),
  soketSlot = {},
  soketName = {},
  soketEffect = {},
  itemProducedPlace = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ProducedPlace"),
  itemDescription = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_Description"),
  itemPrice_panel = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ItemPrice_panel"),
  itemPrice_transportBuy = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ItemPrice_transportBuy"),
  itemPrice_transportBuy_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ItemPrice_transportBuy_value"),
  itemPrice_storeSell = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ItemPrice_storeSell"),
  itemPrice_storeSell_value = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ItemPrice_storeSell_value"),
  grapeSize = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_endurance_value"):GetSizeX(),
  panelSize = Panel_Tooltip_Item:GetSizeY(),
  socketSize = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_SoketOption_panel"):GetSizeY(),
  deltaTime = 0,
  att_Value = 0,
  def_Value = 0,
  wei_Value = 0,
  tradeInfo_Panel = UI.getChildControl(Panel_Tooltip_Item, "Static_TradeInfoPanel"),
  tradeInfo_Title = UI.getChildControl(Panel_Tooltip_Item, "StaticText_TradePriceTitle"),
  tradeInfo_Value = UI.getChildControl(Panel_Tooltip_Item, "StaticText_TradePriceValue"),
  equipSlotName = UI.getChildControl(Panel_Tooltip_Item, "StaticText_EquipTypeName"),
  productNotify = UI.getChildControl(Panel_Tooltip_Item, "Static_ProductNotify"),
  itemLockNotify = UI.getChildControl(Panel_Tooltip_Item, "Static_ItemLockNotify"),
  personalTrade = UI.getChildControl(Panel_Tooltip_Item, "StaticText_IsPersnalTrade"),
  itemLock = UI.getChildControl(Panel_Tooltip_Item, "StaticText_IsItemLock"),
  exchangeTitle = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ExchangeTitle"),
  exchangeDesc = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ExchangeDescription"),
  recoveryDesc = UI.getChildControl(Panel_Tooltip_Item, "StaticText_ItemRecoveryDesc"),
  bagSize = UI.getChildControl(Panel_Tooltip_Item, "StaticText_BagSize"),
  equipmentInBag = UI.getChildControl(Panel_Tooltip_Item, "StaticText_EquipmentInBag"),
  cronStoneEnchant = UI.getChildControl(Panel_Tooltip_Item, "StaticText_CronEnchant"),
  cronStoneGrade = UI.getChildControl(Panel_Tooltip_Item, "StaticText_CronGrade"),
  cronStoneProgressBg = UI.getChildControl(Panel_Tooltip_Item, "Static_CronStoneStackBg"),
  cronStoneProgress = UI.getChildControl(Panel_Tooltip_Item, "Progress2_StackCount"),
  cronStoneGradeValue = {
    [0] = UI.getChildControl(Panel_Tooltip_Item, "StaticText_Grade1"),
    [1] = UI.getChildControl(Panel_Tooltip_Item, "StaticText_Grade2"),
    [2] = UI.getChildControl(Panel_Tooltip_Item, "StaticText_Grade3"),
    [3] = UI.getChildControl(Panel_Tooltip_Item, "StaticText_Grade4")
  },
  cronStoneCountValue = {
    [0] = UI.getChildControl(Panel_Tooltip_Item, "StaticText_Count1"),
    [1] = UI.getChildControl(Panel_Tooltip_Item, "StaticText_Count2"),
    [2] = UI.getChildControl(Panel_Tooltip_Item, "StaticText_Count3"),
    [3] = UI.getChildControl(Panel_Tooltip_Item, "StaticText_Count4")
  },
  cronStoneValue = UI.getChildControl(Panel_Tooltip_Item, "StaticText_CronStackDesc"),
  enchantDifficulty = UI.getChildControl(Panel_Tooltip_Item, "StaticText_EnchantDifficulty"),
  soulCollector = UI.getChildControl(Panel_Tooltip_Item, "StaticText_SoulCollector")
}
local equippedTooltip = {
  equippedTag = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_nowEquiped_tag"),
  mainPanel = Panel_Tooltip_Item_equipped,
  itemName = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_Name"),
  itemIcon = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_Icon"),
  enchantLevel = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_Enchant_value"),
  itemType = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_Type"),
  dying = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_Dying"),
  isEnchantable = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_isEnchantable"),
  _txt_repair = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_isRepair"),
  isSealed = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_isSealed"),
  bindType = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_BindType"),
  balksExtraction = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_Balks"),
  cronsExtraction = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_Cron"),
  useDyeColorTitle = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_DyeColorInfo"),
  useDyeColorIcon_Part = {
    [0] = UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part1"),
    UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part2"),
    UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part3"),
    UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part4"),
    UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part5"),
    UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part6"),
    UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part7"),
    UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part8"),
    UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part9"),
    UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part10"),
    UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part11"),
    UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part12")
  },
  useLimit_category = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_category"),
  useLimit_panel = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_panel"),
  useLimit_level = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_level"),
  useLimit_level_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_level_value"),
  useLimit_extendedslot = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_extendedslot"),
  useLimit_extendedslot_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_extendedslot_value"),
  useLimit_class = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_class"),
  useLimit_class_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_class_value"),
  useLimit_Exp = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_Exp"),
  useLimit_Exp_gage = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_Exp_gage"),
  useLimit_Exp_gage_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Progress_UseLimit_Exp_gage_value"),
  useLimit_Exp_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_Exp_value"),
  useLimit_endurance = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_endurance"),
  useLimit_endurance_gage = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_endurance_gage"),
  useLimit_endurance_gage_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Progress_UseLimit_endurance_gage_value"),
  useLimit_dynamic_endurance_gage_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Progress2_MaxEndurance"),
  useLimit_endurance_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_endurance_value"),
  remainTime = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_remainTime"),
  remainTime_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_remainTime_value"),
  expireIcon_white = UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_Expire_Icon1"),
  expireIcon_red = UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_Expire_Icon2"),
  expireIcon_end = UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_Expire_Icon3"),
  defaultEffect_category = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_category"),
  defaultEffect_panel = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_panel"),
  attack = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_attack"),
  attack_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_attack_value"),
  attack_diffValue = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attackDiff_value"),
  isMeleeAttack = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_attack_isMeleeAttack"),
  isRangeAttack = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_attack_isRangeAttack"),
  isMagicAttack = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_attack_isMagicAttack"),
  defense = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_defense"),
  defense_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_defense_value"),
  defense_diffValue = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_defenseDiff_value"),
  weight = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_weight"),
  weight_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_weight_value"),
  weight_diffValue = UI.getChildControl(Panel_Tooltip_Item, "StaticText_DefaultEffect_weightDiff_value"),
  _hit = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_hit"),
  _hit_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_hit_value"),
  _hit_diffValue = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_hitDiff_value"),
  _dv = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_dv"),
  _dv_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_dv_value"),
  _dv_diffValue = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_dvDiff_value"),
  _pv = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_pv"),
  _pv_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_pv_value"),
  _pv_diffValue = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_pvDiff_value"),
  _txt_MaxEnchanter = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_MaxEnchantCharName"),
  soketOption_panel = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_SoketOption_panel"),
  soketSlot = {},
  soketName = {},
  soketEffect = {},
  itemProducedPlace = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ProducedPlace"),
  itemDescription = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_Description"),
  itemPrice_panel = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ItemPrice_panel"),
  itemPrice_transportBuy = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ItemPrice_transportBuy"),
  itemPrice_transportBuy_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ItemPrice_transportBuy_value"),
  itemPrice_storeSell = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ItemPrice_storeSell"),
  itemPrice_storeSell_value = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ItemPrice_storeSell_value"),
  arrow = UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_Arrow"),
  arrow_L = UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_Arrow_L"),
  grapeSize = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_endurance_value"):GetSizeX(),
  panelSize = Panel_Tooltip_Item:GetSizeY(),
  socketSize = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_SoketOption_panel"):GetSizeY(),
  deltaTime = 0,
  att_Value = 0,
  def_Value = 0,
  wei_Value = 0,
  tradeInfo_Panel = UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_TradeInfoPanel"),
  tradeInfo_Title = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_TradePriceTitle"),
  tradeInfo_Value = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_TradePriceValue"),
  equipSlotName = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_EquipTypeName"),
  productNotify = UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_ProductNotify"),
  itemLockNotify = UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_ItemLockNotify"),
  personalTrade = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_IsPersnalTrade"),
  itemLock = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_IsItemLock"),
  exchangeTitle = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ExchangeTitle"),
  exchangeDesc = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ExchangeDescription"),
  recoveryDesc = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_ItemRecoveryDesc"),
  cronStoneEnchant = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_CronEnchant"),
  cronStoneGrade = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_CronGrade"),
  cronStoneProgressBg = UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_CronStoneStackBg"),
  cronStoneProgress = UI.getChildControl(Panel_Tooltip_Item_equipped, "Progress2_StackCount"),
  cronStoneGradeValue = {
    [0] = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_Grade1"),
    [1] = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_Grade2"),
    [2] = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_Grade3"),
    [3] = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_Grade4")
  },
  cronStoneCountValue = {
    [0] = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_Count1"),
    [1] = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_Count2"),
    [2] = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_Count3"),
    [3] = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_Count4")
  },
  cronStoneValue = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_CronStackDesc"),
  enchantDifficulty = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_EnchantDifficulty"),
  soulCollector = UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_SoulCollector")
}
local chattingLinkedItemTooltip = {
  mainPanel = Panel_Tooltip_Item_chattingLinkedItem,
  itemName = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_Name"),
  itemIcon = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_Icon"),
  closeBtn = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Button_Win_Close"),
  enchantLevel = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_Enchant_value"),
  itemType = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_Type"),
  dying = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_Dying"),
  isEnchantable = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_isEnchantable"),
  _txt_repair = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_isRepair"),
  isSealed = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_isSealed"),
  bindType = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_BindType"),
  balksExtraction = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_Balks"),
  cronsExtraction = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_Cron"),
  useDyeColorTitle = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_DyeColorInfo"),
  useDyeColorIcon_Part = {
    [0] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part1"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part2"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part3"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part4"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part5"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part6"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part7"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part8"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part9"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part10"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part11"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part12")
  },
  useLimit_category = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_category"),
  useLimit_panel = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_panel"),
  useLimit_level = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_level"),
  useLimit_level_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_level_value"),
  useLimit_extendedslot = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_extendedslot"),
  useLimit_extendedslot_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_extendedslot_value"),
  useLimit_class = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_class"),
  useLimit_class_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_class_value"),
  useLimit_Exp = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_Exp"),
  useLimit_Exp_gage = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_Exp_gage"),
  useLimit_Exp_gage_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Progress_UseLimit_Exp_gage_value"),
  useLimit_Exp_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_Exp_value"),
  useLimit_endurance = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_endurance"),
  useLimit_endurance_gage = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_endurance_gage"),
  useLimit_endurance_gage_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Progress_UseLimit_endurance_gage_value"),
  useLimit_dynamic_endurance_gage_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Progress2_MaxEndurance"),
  useLimit_endurance_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_endurance_value"),
  remainTime = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_remainTime"),
  remainTime_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_remainTime_value"),
  expireIcon_white = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_Expire_Icon1"),
  expireIcon_red = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_Expire_Icon2"),
  expireIcon_end = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_Expire_Icon3"),
  defaultEffect_category = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_category"),
  defaultEffect_panel = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_panel"),
  attack = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_attack"),
  attack_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_attack_value"),
  attack_diffValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_attackDiff_value"),
  isMeleeAttack = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_attack_isMeleeAttack"),
  isRangeAttack = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_attack_isRangeAttack"),
  isMagicAttack = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_attack_isMagicAttack"),
  defense = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_defense"),
  defense_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_defense_value"),
  defense_diffValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_defenseDiff_value"),
  weight = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_weight"),
  weight_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_weight_value"),
  weight_diffValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_DefaultEffect_weightDiff_value"),
  _hit = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_hit"),
  _hit_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_hit_value"),
  _hit_diffValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_hitDiff_value"),
  _dv = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_dv"),
  _dv_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_dv_value"),
  _dv_diffValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_dvDiff_value"),
  _pv = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_pv"),
  _pv_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_pv_value"),
  _pv_diffValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_pvDiff_value"),
  _txt_MaxEnchanter = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_MaxEnchantCharName"),
  soketOption_panel = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_SoketOption_panel"),
  soketSlot = {},
  soketName = {},
  soketEffect = {},
  itemProducedPlace = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ProducedPlace"),
  itemDescription = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_Description"),
  itemPrice_panel = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ItemPrice_panel"),
  itemPrice_transportBuy = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ItemPrice_transportBuy"),
  itemPrice_transportBuy_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ItemPrice_transportBuy_value"),
  itemPrice_storeSell = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ItemPrice_storeSell"),
  itemPrice_storeSell_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ItemPrice_storeSell_value"),
  grapeSize = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_endurance_value"):GetSizeX(),
  panelSize = Panel_Tooltip_Item_chattingLinkedItem:GetSizeY(),
  socketSize = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_SoketOption_panel"):GetSizeY(),
  deltaTime = 0,
  att_Value = 0,
  def_Value = 0,
  wei_Value = 0,
  tradeInfo_Panel = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_TradeInfoPanel"),
  tradeInfo_Title = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_TradePriceTitle"),
  tradeInfo_Value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_TradePriceValue"),
  equipSlotName = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_EquipTypeName"),
  productNotify = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_ProductNotify"),
  itemLockNotify = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_ItemLockNotify"),
  personalTrade = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_IsPersnalTrade"),
  itemLock = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_IsItemLock"),
  exchangeTitle = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ExchangeTitle"),
  exchangeDesc = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ExchangeDescription"),
  recoveryDesc = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_ItemRecoveryDesc"),
  cronStoneEnchant = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_CronEnchant"),
  cronStoneGrade = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_CronGrade"),
  cronStoneProgressBg = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_CronStoneStackBg"),
  cronStoneProgress = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Progress2_StackCount"),
  cronStoneGradeValue = {
    [0] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_Grade1"),
    [1] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_Grade2"),
    [2] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_Grade3"),
    [3] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_Grade4")
  },
  cronStoneCountValue = {
    [0] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_Count1"),
    [1] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_Count2"),
    [2] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_Count3"),
    [3] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_Count4")
  },
  cronStoneValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_CronStackDesc"),
  enchantDifficulty = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_EnchantDifficulty"),
  soulCollector = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_SoulCollector")
}
local chattingLinkedItemClickTooltip = {
  mainPanel = Panel_Tooltip_Item_chattingLinkedItemClick,
  itemName = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_Name"),
  itemIcon = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_Icon"),
  closeBtn = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Button_Win_Close"),
  enchantLevel = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_Enchant_value"),
  itemType = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_Type"),
  dying = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_Dying"),
  isEnchantable = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_isEnchantable"),
  _txt_repair = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_isRepair"),
  isSealed = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_isSealed"),
  bindType = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_BindType"),
  balksExtraction = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_Balks"),
  cronsExtraction = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_Cron"),
  useDyeColorTitle = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_DyeColorInfo"),
  useDyeColorIcon_Part = {
    [0] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_DyeColorIcon_Part1"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_DyeColorIcon_Part2"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_DyeColorIcon_Part3"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_DyeColorIcon_Part4"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_DyeColorIcon_Part5"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_DyeColorIcon_Part6"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_DyeColorIcon_Part7"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_DyeColorIcon_Part8"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_DyeColorIcon_Part9"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_DyeColorIcon_Part10"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_DyeColorIcon_Part11"),
    UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_DyeColorIcon_Part12")
  },
  useLimit_category = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_category"),
  useLimit_panel = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_panel"),
  useLimit_level = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_level"),
  useLimit_level_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_level_value"),
  useLimit_extendedslot = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_extendedslot"),
  useLimit_extendedslot_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_extendedslot_value"),
  useLimit_class = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_class"),
  useLimit_class_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_class_value"),
  useLimit_Exp = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_Exp"),
  useLimit_Exp_gage = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_Exp_gage"),
  useLimit_Exp_gage_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Progress_UseLimit_Exp_gage_value"),
  useLimit_Exp_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_Exp_value"),
  useLimit_endurance = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_endurance"),
  useLimit_endurance_gage = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_endurance_gage"),
  useLimit_endurance_gage_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Progress_UseLimit_endurance_gage_value"),
  useLimit_dynamic_endurance_gage_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Progress2_MaxEndurance"),
  useLimit_endurance_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_endurance_value"),
  remainTime = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_remainTime"),
  remainTime_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_remainTime_value"),
  expireIcon_white = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_Expire_Icon1"),
  expireIcon_red = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_Expire_Icon2"),
  expireIcon_end = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_Expire_Icon3"),
  defaultEffect_category = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_category"),
  defaultEffect_panel = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_panel"),
  attack = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_attack"),
  attack_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_attack_value"),
  attack_diffValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_attackDiff_value"),
  isMeleeAttack = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_attack_isMeleeAttack"),
  isRangeAttack = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_attack_isRangeAttack"),
  isMagicAttack = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_attack_isMagicAttack"),
  defense = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_defense"),
  defense_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_defense_value"),
  defense_diffValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_defenseDiff_value"),
  weight = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_weight"),
  weight_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_weight_value"),
  weight_diffValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_DefaultEffect_weightDiff_value"),
  _hit = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_hit"),
  _hit_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_hit_value"),
  _hit_diffValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_hitDiff_value"),
  _dv = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_dv"),
  _dv_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_dv_value"),
  _dv_diffValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_dvDiff_value"),
  _pv = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_pv"),
  _pv_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_pv_value"),
  _pv_diffValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_DefaultEffect_pvDiff_value"),
  _txt_MaxEnchanter = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_MaxEnchantCharName"),
  soketOption_panel = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_SoketOption_panel"),
  soketSlot = {},
  soketName = {},
  soketEffect = {},
  itemProducedPlace = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_ProducedPlace"),
  itemDescription = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_Description"),
  itemPrice_panel = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_ItemPrice_panel"),
  itemPrice_transportBuy = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_ItemPrice_transportBuy"),
  itemPrice_transportBuy_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_ItemPrice_transportBuy_value"),
  itemPrice_storeSell = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_ItemPrice_storeSell"),
  itemPrice_storeSell_value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_ItemPrice_storeSell_value"),
  grapeSize = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_UseLimit_endurance_value"):GetSizeX(),
  panelSize = Panel_Tooltip_Item_chattingLinkedItemClick:GetSizeY(),
  socketSize = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_SoketOption_panel"):GetSizeY(),
  deltaTime = 0,
  att_Value = 0,
  def_Value = 0,
  wei_Value = 0,
  tradeInfo_Panel = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_TradeInfoPanel"),
  tradeInfo_Title = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_TradePriceTitle"),
  tradeInfo_Value = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_TradePriceValue"),
  equipSlotName = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_EquipTypeName"),
  productNotify = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_ProductNotify"),
  itemLockNotify = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_ItemLockNotify"),
  personalTrade = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_IsPersnalTrade"),
  itemLock = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_IsItemLock"),
  exchangeTitle = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_ExchangeTitle"),
  exchangeDesc = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_ExchangeDescription"),
  recoveryDesc = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_ItemRecoveryDesc"),
  cronStoneEnchant = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_CronEnchant"),
  cronStoneGrade = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_CronGrade"),
  cronStoneProgressBg = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Static_CronStoneStackBg"),
  cronStoneProgress = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Progress2_StackCount"),
  cronStoneGradeValue = {
    [0] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_Grade1"),
    [1] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_Grade2"),
    [2] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_Grade3"),
    [3] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_Grade4")
  },
  cronStoneCountValue = {
    [0] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_Count1"),
    [1] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_Count2"),
    [2] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_Count3"),
    [3] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_Count4")
  },
  cronStoneValue = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_CronStackDesc"),
  enchantDifficulty = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_EnchantDifficulty"),
  soulCollector = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "StaticText_SoulCollector")
}
local servantKindTypeString = {
  [0] = {
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BARD"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SADDLE"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_STIRRUP"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HORSEHEAD"),
    [12] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_FOOT"),
    [14] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_ARMOR"),
    [15] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_STIRRUP"),
    [16] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_SADDLE"),
    [17] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_FACE")
  },
  [1] = {
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_CORVER"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_TIRE"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_FLAG"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_INSIGNIA"),
    [13] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_LAMP"),
    [25] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_BODY"),
    [14] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_BODY"),
    [15] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_TIRE"),
    [16] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_FLAG"),
    [17] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_INSIGNIA"),
    [26] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_CORVER")
  },
  [2] = {
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_SHIPARMOR_25"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_SHIPARMOR_4"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_SHIPARMOR_5"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_SHIPARMOR_6"),
    [25] = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_SHIPARMOR_3"),
    [14] = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_SHIPARMOR_13"),
    [15] = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_SHIPARMOR_15"),
    [16] = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_SHIPARMOR_16"),
    [26] = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_SHIPARMOR_14")
  }
}
local Panel_Tooltip_Item_DataObject = {
  slotData = {},
  currentSlotNo = -1,
  currentSlotType = "",
  index = -1,
  isNormal = false,
  isSkill = false,
  itemMarket = false,
  inventory = false,
  equip = false,
  isTooltipClickOpen = false
}
local EquipItem_Lock = {
  itemLock = false,
  equipment = false,
  itemAccNo = -1
}
local savedSlotNo = 0
function Panel_Tooltip_Item_Initialize()
  Panel_Tooltip_Item:SetShow(false, false)
  Panel_Tooltip_Item:setMaskingChild(true)
  Panel_Tooltip_Item:SetIgnore(true)
  Panel_Tooltip_Item:SetIgnoreChild(true)
  Panel_Tooltip_Item:setGlassBackground(true)
  Panel_Tooltip_Item_equipped:SetShow(false, false)
  Panel_Tooltip_Item_equipped:setMaskingChild(true)
  Panel_Tooltip_Item_equipped:SetIgnore(true)
  Panel_Tooltip_Item_equipped:SetIgnoreChild(true)
  Panel_Tooltip_Item_equipped:setGlassBackground(true)
  Panel_Tooltip_Item_chattingLinkedItem:SetShow(false, false)
  Panel_Tooltip_Item_chattingLinkedItem:setMaskingChild(true)
  Panel_Tooltip_Item_chattingLinkedItem:SetIgnore(true)
  Panel_Tooltip_Item_chattingLinkedItem:SetIgnoreChild(true)
  Panel_Tooltip_Item_chattingLinkedItem:setGlassBackground(true)
  chattingLinkedItemTooltip.closeBtn:addInputEvent("Mouse_LUp", "Panel_Tooltip_Item_chattingLinkedItem_hideTooltip()")
  chattingLinkedItemClickTooltip.closeBtn:addInputEvent("Mouse_LUp", "Panel_Tooltip_Item_chattingLinkedItemClick_hideTooltip()")
  for idx = 1, 6 do
    normalTooltip.soketSlot[idx] = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_SoketOption_soketSlot" .. idx)
    normalTooltip.soketName[idx] = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_SoketOption_soketName" .. idx)
    normalTooltip.soketEffect[idx] = UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_SoketOption_soketEffect" .. idx)
    equippedTooltip.soketSlot[idx] = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_SoketOption_soketSlot" .. idx)
    equippedTooltip.soketName[idx] = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_SoketOption_soketName" .. idx)
    equippedTooltip.soketEffect[idx] = UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_SoketOption_soketEffect" .. idx)
    chattingLinkedItemTooltip.soketSlot[idx] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_SoketOption_soketSlot" .. idx)
    chattingLinkedItemTooltip.soketName[idx] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_SoketOption_soketName" .. idx)
    chattingLinkedItemTooltip.soketEffect[idx] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_SoketOption_soketEffect" .. idx)
    chattingLinkedItemClickTooltip.soketSlot[idx] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_SoketOption_soketSlot" .. idx)
    chattingLinkedItemClickTooltip.soketName[idx] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_SoketOption_soketName" .. idx)
    chattingLinkedItemClickTooltip.soketEffect[idx] = UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItemClick, "Tooltip_Item_SoketOption_soketEffect" .. idx)
  end
  local function SetTextWrap(control)
    if nil == control then
      UI.ASSERT(false, "SetTextWrap(control) , control nil")
      return
    end
    control:SetTextMode(UI_TM.eTextMode_AutoWrap)
    control:SetAutoResize(true)
  end
  local function InitControls(target)
    SetTextWrap(target.itemType)
    SetTextWrap(target._txt_MaxEnchanter)
    SetTextWrap(target.isEnchantable)
    SetTextWrap(target._txt_repair)
    SetTextWrap(target.isSealed)
    SetTextWrap(target.useLimit_category)
    SetTextWrap(target.useLimit_level)
    SetTextWrap(target.useLimit_extendedslot)
    SetTextWrap(target.useLimit_extendedslot_value)
    SetTextWrap(target.useLimit_class)
    SetTextWrap(target.useLimit_class_value)
    SetTextWrap(target.useLimit_Exp)
    SetTextWrap(target.useLimit_Exp_value)
    SetTextWrap(target.useLimit_endurance)
    SetTextWrap(target.useLimit_endurance_value)
    SetTextWrap(target.remainTime)
    SetTextWrap(target.remainTime_value)
    SetTextWrap(target.defaultEffect_category)
    SetTextWrap(target.attack)
    SetTextWrap(target.attack_value)
    SetTextWrap(target.attack_diffValue)
    SetTextWrap(target.defense)
    SetTextWrap(target.defense_value)
    SetTextWrap(target.defense_diffValue)
    SetTextWrap(target._hit)
    SetTextWrap(target._hit_value)
    SetTextWrap(target._hit_diffValue)
    SetTextWrap(target._dv)
    SetTextWrap(target._dv_value)
    SetTextWrap(target._dv_diffValue)
    SetTextWrap(target._pv)
    SetTextWrap(target._pv_value)
    SetTextWrap(target._pv_diffValue)
    SetTextWrap(target.weight)
    SetTextWrap(target.weight_value)
    SetTextWrap(target.weight_diffValue)
    SetTextWrap(target.itemProducedPlace)
    SetTextWrap(target.itemDescription)
    SetTextWrap(target.tradeInfo_Title)
    SetTextWrap(target.tradeInfo_Value)
    target.tradeInfo_Ani = UI.getChildControl(target.tradeInfo_Value, "Static_Construction")
    SetTextWrap(target.equipSlotName)
    SetTextWrap(target.exchangeDesc)
    SetTextWrap(target.productNotify)
    SetTextWrap(target.itemLockNotify)
    SetTextWrap(target.itemLock)
    SetTextWrap(target.recoveryDesc)
    for idx = 1, 6 do
      SetTextWrap(target.soketName[idx])
      SetTextWrap(target.soketEffect[idx])
    end
  end
  InitControls(normalTooltip)
  InitControls(equippedTooltip)
  InitControls(chattingLinkedItemTooltip)
  InitControls(chattingLinkedItemClickTooltip)
  SetTextWrap(normalTooltip.bagSize)
  SetTextWrap(normalTooltip.equipmentInBag)
  local skillTooltipFunctionList = {
    GetParentPosX = function()
      local slot = Panel_Tooltip_Item_DataObject.skillSlot
      return slot.icon:GetParentPosX()
    end,
    GetParentPosY = function()
      local slot = Panel_Tooltip_Item_DataObject.skillSlot
      return slot.icon:GetParentPosY()
    end,
    GetSizeX = function()
      local slot = Panel_Tooltip_Item_DataObject.skillSlot
      return slot.icon:GetSizeX()
    end,
    GetSizeY = function()
      local slot = Panel_Tooltip_Item_DataObject.skillSlot
      return slot.icon:GetSizeY()
    end,
    GetParentPanel = function()
      local slot = Panel_Tooltip_Item_DataObject.skillSlot
      return slot.icon:GetParentPanel()
    end
  }
  Panel_SkillTooltip_SetPosition(1, skillTooltipFunctionList, "itemToSkill")
  registerEvent("FromClient_responseTradePrice", "FromClient_responseTradePrice_Tooltip_Item")
end
local GetBottomPos = function(control, isText)
  if nil == control then
    UI.ASSERT(false, "GetBottomPos(control) , control nil")
    return
  end
  local controlSizeY = 0
  if isText then
    controlSizeY = control:GetPosY() + control:GetTextSizeY()
  else
    controlSizeY = control:GetPosY() + control:GetSizeY()
  end
  return controlSizeY
end
function Panel_Tooltip_Item_SetPosition(slotNo, slot, slotType)
  if nil == Panel_Tooltip_Item_DataObject.slotData[slotType] then
    Panel_Tooltip_Item_DataObject.slotData[slotType] = {}
  end
  Panel_Tooltip_Item_DataObject.slotData[slotType][slotNo] = slot
end
function Panel_Tooltip_Item_GetCurrentSlotType()
  return Panel_Tooltip_Item_DataObject.currentSlotType
end
function Panel_Tooltip_Item_Refresh(posX, posY)
  if Panel_Tooltip_Item_DataObject.currentSlotNo == -2 then
    return
  elseif Panel_Tooltip_Item_DataObject.currentSlotNo ~= -1 then
    if Panel_Tooltip_Item_DataObject.isNormal then
      Panel_Tooltip_Item_Show_GeneralNormal(Panel_Tooltip_Item_DataObject.currentSlotNo, Panel_Tooltip_Item_DataObject.currentSlotType, true, Panel_Tooltip_Item_DataObject.index, posX, posY)
    else
      Panel_Tooltip_Item_Show_GeneralStatic(Panel_Tooltip_Item_DataObject.currentSlotNo, Panel_Tooltip_Item_DataObject.currentSlotType, true, Panel_Tooltip_Item_DataObject.index)
    end
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function Panel_Tooltip_Item_Show(itemStaticStatus, uiBase, isSSW, isItemWrapper, chattingLinkedItem, index, isItemMarket, invenSlotNo, TooltipType, indexForNaming)
  Panel_Tooltip_Item_DataObject.itemMarket = isItemMarket
  Panel_Tooltip_Item_DataObject.inventory = nil
  local itemNamingStr
  if nil ~= TooltipType and nil ~= indexForNaming then
    if "Dye" == TooltipType then
      itemNamingStr = getItemNaming(getTItemNoBySlotNo(indexForNaming, true))
    elseif "Improve" == TooltipType then
      itemNamingStr = getItemNaming(getTItemNoBySlotNo(indexForNaming, false))
    elseif "InventoryBag" == TooltipType then
      itemNamingStr = getItemNaming(indexForNaming)
    elseif "WeaponChange" == TooltipType then
      itemNamingStr = getItemNaming(getTItemNoBySlotNo(indexForNaming, false))
    elseif "Delivery" == TooltipType then
      itemNamingStr = getItemNaming(indexForNaming)
    end
  end
  local isEquipableItem, servantItem = showTooltip_Item(normalTooltip, itemStaticStatus, isSSW, isItemWrapper, chattingLinkedItem, index, nil, invenSlotNo, itemNamingStr)
  local equipItemWrapper
  if isEquipableItem and not servantItem and isItemMarket then
    if isSSW then
      equipItemWrapper = ToClient_getEquipmentItem(itemStaticStatus:getEquipSlotNo())
    else
      equipItemWrapper = ToClient_getEquipmentItem(itemStaticStatus:getStaticStatus():getEquipSlotNo())
    end
    if nil ~= equipItemWrapper then
      showTooltip_Item(equippedTooltip, equipItemWrapper, false, true)
    end
  end
  if uiBase:IsUISubApp() then
    Panel_Tooltip_Item_Set_Position_UISubApp(uiBase)
    normalTooltip.mainPanel:OpenUISubApp()
    if nil ~= equipItemWrapper then
      equippedTooltip.mainPanel:OpenUISubApp()
    end
  else
    Panel_Tooltip_Item_Set_Position(uiBase)
  end
end
function Panel_Tooltip_Item_Show_ForQuest(itemEnchantKey, isSSW, isItemWrapper)
  Panel_Tooltip_Item_DataObject.itemMarket = nil
  Panel_Tooltip_Item_DataObject.inventory = nil
  local itemStaticStatus = getItemEnchantStaticStatus(ItemEnchantKey(itemEnchantKey))
  showTooltip_Item(normalTooltip, itemStaticStatus, isSSW, isItemWrapper)
  Panel_Tooltip_Item_Set_Position(Panel_QuestInfo)
  Panel_Tooltip_Item_DataObject.currentSlotNo = -2
end
function Panel_Tooltip_Item_Show_ForChattingLinkedItem(itemStaticStatus, uiBase, isSSW, isItemWrapper, chattingLinkedItem, isClicked)
  Panel_Tooltip_Item_DataObject.itemMarket = nil
  Panel_Tooltip_Item_DataObject.inventory = nil
  chattingLinkedItemTooltip.closeBtn:SetIgnore(false)
  chattingLinkedItemClickTooltip.closeBtn:SetIgnore(false)
  if isClicked then
    showTooltip_Item(chattingLinkedItemClickTooltip, itemStaticStatus, isSSW, isItemWrapper, chattingLinkedItem, index)
  else
    showTooltip_Item(chattingLinkedItemTooltip, itemStaticStatus, isSSW, isItemWrapper, chattingLinkedItem, index)
  end
  Panel_Tooltip_Item_chattingLinkedItem_Set_Position(uiBase, isClicked)
end
local clothBagSlotNo
local bagInWarehouse = false
function Panel_Tooltip_Item_Show_GeneralNormal(slotNo, slotType, isOn, index, targetX, targetY)
  Panel_Tooltip_Item_DataObject.itemMarket = nil
  EquipItem_Lock.equipment = false
  if false == Panel_Tooltip_Item_Show_General(slotNo, slotType, isOn, true, index) then
    return
  end
  clothBagSlotNo = nil
  bagInWarehouse = "WareHouse" == slotType
  local slot = Panel_Tooltip_Item_DataObject.slotData[slotType][slotNo]
  local parent = false
  local inven = false
  if slotType == "servant_inventory" then
    if true == _ContentsGroup_RenewUI then
      actorKey = PaGlobalFunc_InventoryInfo_GetServantActorKey()
    else
      actorKey = ServantInventory_GetActorKeyRawFromIndex(0)
    end
    if slotNo >= getServantInventorySize(actorKey) then
      return
    end
    parent = true
  elseif "inventory" == slotType then
    Panel_Tooltip_Item_DataObject.inventory = true
    local selfPlayerWrapper = getSelfPlayer()
    if nil == selfPlayerWrapper then
      return
    end
    local selfPlayer = selfPlayerWrapper:get()
    if nil == selfPlayer then
      return
    end
    clothBagSlotNo = Global_GetInventorySlotNoByNotSorted(slotNo)
    local inventory = Inventory_GetCurrentInventory()
    local inventorySlotNo = slotNo + Inventory_GetStartIndex() + inventorySlotNoUserStart()
    if inventorySlotNo >= inventory:sizeXXX() then
      return
    end
    parent = true
    inven = true
  elseif "Auction" == slotType then
    local myAuctionInfo = RequestGetAuctionInfo()
    local auctionType = myAuctionInfo:getAuctionType()
    local itemCount = 0
    if auctionType == 0 then
      itemCount = myAuctionInfo:getItemAuctionListCount()
    elseif auctionType == 4 then
      itemCount = myAuctionInfo:getMySellingItemAuctionCount()
    elseif auctionType == 6 then
      itemCount = myAuctionInfo:getMyItemBidListCount()
    end
    if slotNo > itemCount then
      return
    end
  end
  local itemWrapper
  local isEquipOn = false
  local isServantEquipOn = false
  local DeliveryItemNo
  if "servant_inventory" == slotType then
    if true == _ContentsGroup_RenewUI then
      actorKey = PaGlobalFunc_InventoryInfo_GetServantActorKey()
    else
      actorKey = ServantInventory_GetActorKeyRawFromIndex(index)
    end
    itemWrapper = getServantInventoryItemBySlotNo(actorKey, slotNo)
    inven = true
  elseif "QuickSlot" == slotType then
    local quickSlotInfo = getQuickSlotItem(slotNo)
    if nil == quickSlotInfo then
      return
    end
    local selfPlayerWrapper = getSelfPlayer()
    if nil == selfPlayerWrapper then
      return
    end
    local selfPlayer = selfPlayerWrapper:get()
    if nil == selfPlayer then
      return
    end
    local whereType = QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
    local inventory = selfPlayer:getInventoryByType(whereType)
    local invenSlotNo = inventory:getSlot(quickSlotInfo._itemKey)
    if invenSlotNo >= inventory:sizeXXX() then
      return
    end
    itemWrapper = getInventoryItemByType(whereType, invenSlotNo)
    if CppEnums.ContentsEventType.ContentsType_InventoryBag == itemWrapper:getStaticStatus():get():getContentsEventType() then
      invenSlotNo = ToClient_GetItemNoByInventory(whereType, quickSlotInfo._itemNo_s64)
      itemWrapper = getInventoryItemByType(whereType, invenSlotNo)
      clothBagSlotNo = invenSlotNo
    end
  elseif "betterItemList" == slotType then
    itemWrapper = PaGlobal_BetterEquipment_GetItemWrapper(slotNo)
  elseif "inventory" == slotType then
    itemWrapper = Inventory_GetToopTipItem()
  elseif "Enchant" == slotType then
    if 0 == slotNo then
      itemWrapper = PaGlobal_Enchant:enchantItem_ToItemWrapper()
    else
      itemWrapper = PaGlobal_Enchant:enchantItem_FromItemWrapper()
    end
  elseif "SocketItem" == slotType then
    itemWrapper = getInventoryItemByType(slot.whereType, slot.slotNo)
    isEquipOn = true
  elseif "WareHouse" == slotType then
    itemWrapper = Warehouse_GetToopTipItem()
    if itemWrapper and CppEnums.ContentsEventType.ContentsType_InventoryBag == itemWrapper:getStaticStatus():get():getContentsEventType() then
      clothBagSlotNo = FGlobal_Warehouse_GetToolTipItemSlotNo()
    end
    parent = true
    inven = true
  elseif "looting" == slotType then
    itemWrapper = looting_getItem(slotNo)
  elseif "equipment" == slotType then
    itemWrapper = ToClient_getEquipmentItem(slotNo)
    isEquipOn = true
    parent = true
    inven = true
    EquipItem_Lock.equipment = true
    EquipItem_Lock.itemLock = ToClient_EquipSlot_CheckItemLock(slotNo, 1)
  elseif "disassemble_source" == slotType then
    itemWrapper = disassemble_GetSourceItem(slotNo)
  elseif "disassemble_result" == slotType then
    itemWrapper = disassemble_GetResultItem(slotNo)
  elseif "product_recipe" == slotType then
    itemWrapper = product_GetRecipeItem(0)
  elseif "product_result" == slotType then
    itemWrapper = product_GetResultItem(slotNo)
  elseif "ServantEquipment" == slotType then
    local actorKey
    if true == _ContentsGroup_RenewUI then
      actorKey = PaGlobalFunc_InventoryInfo_GetServantActorKey()
    else
      actorKey = Servant_GetActorKeyFromItemToolTip()
    end
    local servantWrapper = getServantInfoFromActorKey(actorKey)
    if nil ~= servantWrapper then
      itemWrapper = servantWrapper:getEquipItem(slotNo)
    end
    isEquipOn = true
    isServantEquipOn = false
  elseif "ServantShipEquipment" == slotType then
    if true == _ContentsGroup_RenewUI then
      actorKey = PaGlobalFunc_InventoryInfo_GetServantActorKey()
    else
      actorKey = Servant_GetActorKeyFromItemToolTip()
    end
    local servantWrapper = getServantInfoFromActorKey(actorKey)
    if nil ~= servantWrapper then
      itemWrapper = servantWrapper:getEquipItem(slotNo)
    end
    isEquipOn = true
    isServantEquipOn = true
  elseif "StableEquipment" == slotType then
    local servantInfo = stable_getServant(StableList_SelectSlotNo())
    if nil ~= servantInfo then
      itemWrapper = servantInfo:getEquipItem(slotNo)
    end
  elseif "LinkedHorseEquip" == slotType then
    if true == _ContentsGroup_RenewUI then
      actorKey = PaGlobalFunc_InventoryInfo_GetServantActorKey()
    else
      actorKey = Servant_GetActorKeyFromItemToolTip()
    end
    local servantWrapper = getServantInfoFromActorKey(actorKey)
    local servantInfo = stable_getServantFromOwnerServant(servantWrapper:getServantNo(), FGlobal_LinkedHorse_SelectedIndex())
    if nil ~= servantInfo then
      itemWrapper = servantInfo:getEquipItem(slotNo)
    end
  elseif "exchangeOther" == slotType then
    itemWrapper = tradePC_GetOtherItem(slotNo)
  elseif "tradeMarket_Sell" == slotType then
    itemWrapper = npcShop_getItemWrapperByShopSlotNo(slotNo)
  elseif "tradeMarket_VehicleSell" == slotType then
    itemWrapper = npcShop_getVehicleItemWrapper(slotNo)
  elseif "exchangeSelf" == slotType then
    itemWrapper = tradePC_GetMyItem(slotNo)
  elseif "DeliveryInformation" == slotType then
    local deliverySlotNo = DeliveryInformation_SlotIndex(slotNo)
    local deliveryList = delivery_list(DeliveryInformation_WaypointKey())
    if nil ~= deliveryList and deliverySlotNo < deliveryList:size() then
      local deliveryInfo = deliveryList:atPointer(deliverySlotNo)
      if nil ~= deliveryInfo then
        itemWrapper = deliveryInfo:getItemWrapper(deliverySlotNo)
      end
    end
  elseif "DeliveryCarriageInformation" == slotType then
    local deliverySlotNo = DeliveryCarriageInformation_SlotIndex(slotNo)
    local deliveryList = deliveryCarriage_dlieveryList(DeliveryCarriageInformation_ObjectID())
    if nil ~= deliveryList and deliverySlotNo < deliveryList:size() then
      local deliveryInfo = deliveryList:atPointer(deliverySlotNo)
      if nil ~= deliveryInfo then
        itemWrapper = deliveryInfo:getItemWrapper(deliverySlotNo)
        DeliveryItemNo = deliveryInfo:getItemNo()
      end
    end
  elseif "DeliveryRequest" == slotType then
    if true == _ContentsGroup_NewDelivery then
      itemWrapper = ToClient_NewDeliveryGetPackItemBySlotNo(slotNo)
    else
      itemWrapper = delivery_packItem(slotNo)
    end
  elseif "Auction" == slotType then
    local myAuctionInfo = RequestGetAuctionInfo()
    local auctionType = myAuctionInfo:getAuctionType()
    local itemAuctionData
    if auctionType == 0 then
      itemAuctionData = myAuctionInfo:getItemAuctionListAt(slotNo - 1)
    elseif auctionType == 4 then
      itemAuctionData = myAuctionInfo:getMySellingItemAuctionAt(slotNo - 1)
    elseif auctionType == 6 then
      itemAuctionData = myAuctionInfo:getMyItemBidListAt(slotNo - 1)
    end
    if nil ~= itemAuctionData then
      itemWrapper = itemAuctionData:getItem()
    end
  elseif "AuctionRegister" == slotType then
    slotNo = Auction_GetSeletedItemSlot()
    if -1 ~= slotNo then
      itemWrapper = getInventoryItem(slotNo)
    end
  elseif "Socket" == slotType then
    slotNo = Socket_GetSlotNo()
    if -1 ~= slotNo then
      itemWrapper = getInventoryItem(slotNo)
    end
  elseif "HousingMode" == slotType then
    local realSlotNo = Panel_Housing_SlotNo(slotNo)
    if -1 ~= realSlotNo then
      itemWrapper = getInventoryItem(realSlotNo)
    end
  elseif "FixEquip" == slotType then
    local slotNumber = 0
    if slotNo == 0 then
      slotNumber = PaGlobal_FixEquip:fixEquip_GetMainSlotNo()
      if nil ~= slotNumber then
        itemWrapper = getInventoryItem(slotNumber)
      end
    else
      slotNumber = PaGlobal_FixEquip:fixEquip_GetSubSlotNo()
      if nil ~= slotNumber then
        itemWrapper = getInventoryItem(slotNumber)
      end
    end
  elseif "DailyStamp" == slotType then
    itemWrapper = ToClient_getRewardItem(slotNo)
  elseif "clothExtraction" == slotType then
    local isWhereType = Inventory_GetCurrentInventoryType()
    if CppEnums.ItemWhereType.eInventory == isWhereType then
      itemWrapper = getInventoryItem(slotNo)
    elseif CppEnums.ItemWhereType.eCashInventory == isWhereType then
      itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, slotNo)
    end
  elseif "CampEquip" == slotType then
    local actorKeyRaw = PaGlobal_Camp:getActorKeyRaw()
    local servantWrapper = getServantInfoFromActorKey(actorKeyRaw)
    if nil ~= servantWrapper then
      itemWrapper = servantWrapper:getEquipItem(slotNo)
    end
    if nil ~= itemWrapper then
      isEquipOn = true
      isServantEquipOn = true
    end
  else
    UI.ASSERT(false, "showTooltip(normal)\236\156\188\235\161\156 \236\160\149\236\157\152\235\144\152\236\167\128 \236\149\138\236\157\128 slot\237\131\128\236\158\133(" .. slotType .. ")\236\157\180 \235\147\164\236\150\180\236\153\148\236\138\181\235\139\136\235\139\164. \237\153\149\236\157\184\237\149\180\236\163\188\236\132\184\236\154\148.")
    return
  end
  if nil == itemWrapper then
    return
  end
  local itemNamingStr
  if isEquipOn and "SocketItem" ~= slotType then
    itemNamingStr = getItemNaming(getTItemNoBySlotNo(slotNo, true))
  elseif "Enchant" == slotType then
    itemNamingStr = getItemNaming(PaGlobal_Enchant:enchantItem_ToItemNo())
  elseif "WareHouse" == slotType then
    local warehouseItemNo = Warehouse_GetToolTipItemNo()
    if nil ~= warehouseItemNo then
      itemNamingStr = getItemNaming(warehouseItemNo)
    end
  elseif "servant_inventory" == slotType then
    if true == _ContentsGroup_RenewUI then
      actorKey = PaGlobalFunc_InventoryInfo_GetServantActorKey()
    else
      actorKey = ServantInventory_GetActorKeyRawFromIndex(index)
    end
    itemNamingStr = getItemNaming(servantInventory_getItemNoBySlotNo(actorKey, slotNo))
  elseif "SocketItem" == slotType then
    itemNamingStr = getItemNaming(getTItemNoBySlotNo(slotNo, false))
  elseif "FixEquip" == slotType then
    slotNumber = PaGlobal_FixEquip:fixEquip_GetMainSlotNo()
    if nil ~= slotNumber then
      itemNamingStr = getItemNaming(getTItemNoBySlotNo(slotNumber, false))
    end
  elseif "DeliveryRequest" == slotType then
    if true == _ContentsGroup_NewDelivery then
      itemNamingStr = getItemNaming(ToClient_NewDeliveryGetPackItemNoBySlotNo(slotNo))
    else
      itemNamingStr = getItemNaming(delivery_packItemNoByIndex(slotNo))
    end
  elseif "DeliveryCarriageInformation" == slotType then
    if nil ~= DeliveryItemNo then
      itemNamingStr = getItemNaming(DeliveryItemNo)
    end
  else
    itemNamingStr = getItemNaming(getTItemNoBySlotNo(getInventory_RealSlotNo(slotNo), false))
  end
  local isEquipableItem = false
  local servantItem = false
  local skillKey = SkillKey()
  Panel_Tooltip_Item_DataObject.isSkill = false
  if itemWrapper:getStaticStatus():isSkillBook(skillKey) then
    Panel_Tooltip_Item_DataObject.skillSlot = slot
    Panel_SkillTooltip_Show(skillKey:getSkillNo(), false, "itemToSkill", false)
    Panel_Tooltip_Item_DataObject.isSkill = true
    return
  elseif not isEquipOn then
    local itemSSW = itemWrapper:getStaticStatus()
    if not itemSSW:isEquipable() then
      isEquipableItem, servantItem = showTooltip_Item(normalTooltip, itemWrapper, false, true, nil, nil, nil, nil, itemNamingStr)
    else
      isEquipableItem, servantItem = showTooltip_Item(normalTooltip, itemWrapper, false, true, nil, slotNo, nil, nil, itemNamingStr)
    end
  else
    showTooltip_Item(equippedTooltip, itemWrapper, false, true, nil, nil, nil, nil, itemNamingStr)
  end
  if isEquipableItem and not isEquipOn then
    local equipItemWrapper, campingItemWrapper
    if servantItem or isServantEquipOn then
      local temporaryWrapper = getTemporaryInformationWrapper()
      if nil ~= temporaryWrapper then
        local campingWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_CampingTent)
        if nil ~= campingWrapper then
          local servantKind = campingWrapper:getServantKind()
          if itemWrapper:getStaticStatus():get():isServantTypeUsable(servantKind) then
            campingItemWrapper = campingWrapper:getEquipItem(itemWrapper:getStaticStatus():getEquipSlotNo())
          end
        else
          local servantWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
          if nil ~= servantWrapper then
            local servantKind = servantWrapper:getServantKind()
            if itemWrapper:getStaticStatus():get():isServantTypeUsable(servantKind) then
              equipItemWrapper = servantWrapper:getEquipItem(itemWrapper:getStaticStatus():getEquipSlotNo())
            end
          end
        end
      end
    else
      local accSlotNo = FGlobal_AccSlotNo(itemWrapper)
      if "betterItemList" == slotType then
        accSlotNo = PaGlobalFunc_GetAccesoryWorseEquipment_Key(itemWrapper)
      end
      if nil ~= accSlotNo then
        EquipItem_Lock.itemAccNo = accSlotNo
        equipItemWrapper = ToClient_getEquipmentItem(accSlotNo)
      else
        EquipItem_Lock.itemAccNo = -1
        equipItemWrapper = ToClient_getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo())
      end
    end
    if nil ~= equipItemWrapper and "Enchant" ~= slotType then
      local equipNamingStr = ""
      equipNamingStr = getItemNaming(getTItemNoBySlotNo(equipItemWrapper:getStaticStatus():getEquipSlotNo(), true))
      showTooltip_Item(equippedTooltip, equipItemWrapper, false, true, nil, nil, nil, nil, equipNamingStr)
      equippedTooltip.arrow:ChangeTextureInfoName("new_ui_common_forlua/widget/tooltip/tooltip_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(equippedTooltip.arrow, 38, 43, 74, 109)
      equippedTooltip.arrow:getBaseTexture():setUV(x1, y1, x2, y2)
      equippedTooltip.arrow:setRenderTexture(equippedTooltip.arrow:getBaseTexture())
    end
    if nil ~= campingItemWrapper and "Enchant" ~= slotType then
      showTooltip_Item(equippedTooltip, campingItemWrapper, false, true)
      equippedTooltip.arrow:ChangeTextureInfoName("new_ui_common_forlua/widget/tooltip/tooltip_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(equippedTooltip.arrow, 38, 43, 74, 109)
      equippedTooltip.arrow:getBaseTexture():setUV(x1, y1, x2, y2)
      equippedTooltip.arrow:setRenderTexture(equippedTooltip.arrow:getBaseTexture())
    end
    if "Enchant" == slotType then
      local isCash = itemWrapper:getStaticStatus():get():isCash()
      local balksCount = itemWrapper:getStaticStatus():getExtractionCount_s64()
      local cronsCount = itemWrapper:getStaticStatus():getCronCount_s64()
      if false ~= isCash or nil ~= balksCount and toInt64(0, 0) ~= balksCount and nil ~= cronsCount and toInt64(0, 0) ~= cronsCount then
      else
        showTooltip_Item(equippedTooltip, itemWrapper, false, true, nil, nil, true, nil, itemNamingStr)
      end
      equippedTooltip.arrow:ChangeTextureInfoName("new_ui_common_forlua/widget/tooltip/tooltip_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(equippedTooltip.arrow, 1, 43, 37, 109)
      equippedTooltip.arrow:getBaseTexture():setUV(x1, y1, x2, y2)
      equippedTooltip.arrow:setRenderTexture(equippedTooltip.arrow:getBaseTexture())
    end
  end
  if slot.icon:getParent():IsUISubApp() then
    Panel_Tooltip_Item_Set_Position_UISubApp(slot.icon, parent, inven)
    equippedTooltip.mainPanel:OpenUISubApp()
    if not isEquipOn then
      normalTooltip.mainPanel:OpenUISubApp()
    end
  else
    Panel_Tooltip_Item_Set_Position(slot.icon, parent, inven, targetX, targetY)
  end
end
function Panel_Tooltip_Item_Show_GeneralStatic(slotNo, slotType, isOn, index, posX, posY)
  Panel_Tooltip_Item_DataObject.itemMarket = nil
  Panel_Tooltip_Item_DataObject.inventory = nil
  if false == Panel_Tooltip_Item_Show_General(slotNo, slotType, isOn, false, index) then
    return
  end
  local isSSW = true
  local isItemWrapper = false
  local inven = false
  local parent = false
  local slot = Panel_Tooltip_Item_DataObject.slotData[slotType][slotNo]
  local itemSSW
  if "QuestReward_Base" == slotType or "QuestReward_Select" == slotType or "Dialog_QuestReward_Base" == slotType or "Dialog_QuestReward_Select" == slotType or "Dialog_GuildQuestReward_Base" == slotType or "Dialog_GuildQuestReward_Money" == slotType or "AccesoryQuest_Base" == slotType or "betterItemList" == slotType or "totalReward" == slotType then
    itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(slot._item))
  elseif "shop" == slotType then
    if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= Panel_Dialog_NPCShop_All then
      local currentTabIdx = PaGlobalFunc_NPCShop_ALL_GetCurrentTabIndex()
      if nil ~= currentTabIdx then
        local shopItemWrapper
        if 0 == currentTabIdx or nil == currentTabIdx then
          shopItemWrapper = npcShop_getItemBuy(slotNo)
          if nil ~= shopItemWrapper then
            itemSSW = shopItemWrapper:getStaticStatus()
          end
        elseif 1 == currentTabIdx then
          itemSSW = npcShop_getItemWrapperByShopSlotNo(slotNo)
          isSSW = false
        else
          itemSSW = npcShop_getItemRepurchaseForToolTip(slotNo)
          isItemWrapper = true
          isSSW = false
        end
        inven = true
        parent = true
      end
    elseif true == _ContentsGroup_RenewUI_NpcShop then
      local NPCShopInfo = PaGlobalFunc_Dialog_NPCShop_GetNPCShop()
      local shopItemWrapper
      if 0 == NPCShopInfo._value.lastTabIndex or nil == NPCShopInfo._value.lastTabIndex then
        shopItemWrapper = npcShop_getItemBuy(slotNo)
        if nil ~= shopItemWrapper then
          itemSSW = shopItemWrapper:getStaticStatus()
        end
      elseif 1 == NPCShopInfo._value.lastTabIndex then
        itemSSW = npcShop_getItemWrapperByShopSlotNo(slotNo)
        isSSW = false
      else
        itemSSW = npcShop_getItemRepurchaseForToolTip(slotNo)
        isItemWrapper = true
        isSSW = false
      end
      inven = true
      parent = true
    else
      local shopItemWrapper
      if 0 == Panel_Window_NpcShop.npcShop.lastTabIndex or nil == Panel_Window_NpcShop.npcShop.lastTabIndex then
        shopItemWrapper = npcShop_getItemBuy(slotNo)
        if nil ~= shopItemWrapper then
          itemSSW = shopItemWrapper:getStaticStatus()
        end
      elseif 1 == Panel_Window_NpcShop.npcShop.lastTabIndex then
        itemSSW = npcShop_getItemWrapperByShopSlotNo(slotNo)
        isSSW = false
      else
        itemSSW = npcShop_getItemRepurchaseForToolTip(slotNo)
        isItemWrapper = true
        isSSW = false
      end
      inven = true
      parent = true
    end
  elseif "workListMilibogi" == slotType then
    itemSSW = HouseControl_getItemStaticStatusByIndex(slotNo)
  elseif "tradeMarket" == slotType then
    itemSSW = global_TradeMarketGraph_StaticStatus(slotNo)
  elseif "tradeMarket_Buy" == slotType then
    itemSSW = npcShop_getItemBuy(slotNo):getStaticStatus()
  elseif "tradeSupply" == slotType then
    local shopItemWrapper = ToClient_worldmap_getTradeSupplyItem(TradeNpcItemInfo_getTerritoryKey(), slotNo - 1)
    if nil ~= shopItemWrapper then
      itemSSW = shopItemWrapper:getStaticStatus()
    end
  elseif "tradeEventInfo" == slotType then
    local shopItemWrapper = ToClient_worldmap_getTradeSupplyItem(index, slotNo)
    if nil ~= shopItemWrapper then
      itemSSW = shopItemWrapper:getStaticStatus()
    end
  elseif "product_source" == slotType then
    local informationWrapper = product_GetSourceItem(slotNo)
    if nil ~= informationWrapper then
      itemSSW = informationWrapper:getStaticStatus()
      if nil ~= itemSSW then
        showTooltip_Item(normalTooltip, itemSSW, true, false)
      end
    end
  elseif "Socket_Insert" == slotType then
    local mainSlotNo = Socket_GetSlotNo()
    local invenItemWrapper = getInventoryItem(mainSlotNo)
    if nil ~= invenItemWrapper then
      itemSSW = invenItemWrapper:getPushedItem(slotNo - 1)
    end
  elseif "Socket_InsertExtraction" == slotType then
    local mainSlotNo = Socket_GetExtractionSlotNo()
    local invenItemWrapper = getInventoryItem(mainSlotNo)
    if nil ~= invenItemWrapper then
      itemSSW = invenItemWrapper:getPushedItem(slotNo - 1)
    end
  elseif "popupItem" == slotType then
    local ESSWrapper = getPopupIteWrapper()
    if nil ~= ESSWrapper then
      itemSSW = ESSWrapper:getPopupItemAt(slotNo - 1)
    end
  elseif "TerritoryAuth_Auction" == slotType then
    local myAuctionInfo = RequestGetAuctionInfo()
    itemSSW = myAuctionInfo:getTerritoryTradeitem(slotNo)
  elseif "Dialog_ChallengeReward_Base" == slotType or "Dialog_ChallengeReward_Select" == slotType then
    itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(slot._item))
  elseif "Dialog_ChallengePcroomReward_Base" == slotType or "Dialog_ChallengePcroomReward_Select" == slotType then
    itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(slot._item))
  elseif "DailyStamp" == slotType then
    itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(slotNo))
  elseif "masterpiecdAuction" == slotType then
    local myAuctionInfo = RequestGetAuctionInfo()
    local goodsInfo
    if CppEnums.AuctionTabType.AuctionTab_SellItem == index then
      goodsInfo = myAuctionInfo:getItemAuctionListAt(slotNo)
    elseif CppEnums.AuctionTabType.AuctionTab_MySellPage == index then
      goodsInfo = myAuctionInfo:getMySellingItemAuctionAt(slotNo)
    elseif CppEnums.AuctionTabType.AuctionTab_MyBidPage == index then
      goodsInfo = myAuctionInfo:getMyItemBidListAt(slotNo)
    end
    if nil == goodsInfo then
      return
    end
    local itemWrapper = goodsInfo:getItem()
    itemSSW = itemWrapper:getStaticStatus()
  else
    UI.ASSERT(false, "showTooltip(static)\236\156\188\235\161\156 \236\160\149\236\157\152\235\144\152\236\167\128 \236\149\138\236\157\128 slot\237\131\128\236\158\133(" .. slotType .. ")\236\157\180 \235\147\164\236\150\180\236\153\148\236\138\181\235\139\136\235\139\164. \237\153\149\236\157\184\237\149\180\236\163\188\236\132\184\236\154\148.")
    return
  end
  if nil == itemSSW then
    return
  end
  local skillKey = SkillKey()
  local isSkillBook = false
  if true == isSSW and false == isItemWrapper then
    isSkillBook = itemSSW:isSkillBook(skillKey)
  else
    isSkillBook = itemSSW:getStaticStatus():isSkillBook(skillKey)
  end
  if isSkillBook then
    Panel_Tooltip_Item_DataObject.isSkill = true
    Panel_Tooltip_Item_DataObject.skillSlot = slot
    Panel_SkillTooltip_Show(skillKey:getSkillNo(), false, "itemToSkill", false)
    return
  end
  Panel_Tooltip_Item_DataObject.isSkill = false
  local isEquipableItem, servantItem = showTooltip_Item(normalTooltip, itemSSW, isSSW, isItemWrapper)
  if isEquipableItem then
    local equipItemWrapper
    if servantItem then
      local temporaryWrapper = getTemporaryInformationWrapper()
      if nil ~= temporaryWrapper and temporaryWrapper:isSelfVehicle() then
        if isItemWrapper or not isSSW then
          equipItemWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle):getEquipItem(itemSSW:getStaticStatus():getEquipSlotNo())
        else
          equipItemWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle):getEquipItem(itemSSW:getEquipSlotNo())
        end
      end
    elseif isItemWrapper or not isSSW then
      equipItemWrapper = ToClient_getEquipmentItem(itemSSW:getStaticStatus():getEquipSlotNo())
    else
      equipItemWrapper = ToClient_getEquipmentItem(itemSSW:getEquipSlotNo())
    end
    if nil ~= equipItemWrapper and not servantItem then
      showTooltip_Item(equippedTooltip, equipItemWrapper, false, true)
    end
  end
  if slot.icon:getParent():IsUISubApp() then
    Panel_Tooltip_Item_Set_Position_UISubApp(slot.icon:getParent())
    normalTooltip.mainPanel:OpenUISubApp()
    if nil ~= equipItemWrapper then
      equippedTooltip.mainPanel:OpenUISubApp()
    end
  elseif nil ~= posX and nil ~= posY then
    Panel_Tooltip_Item_Set_Position(slot.icon:getParent(), nil, nil, posX, posY, false)
  else
    Panel_Tooltip_Item_Set_Position(slot.icon:getParent())
  end
end
function Panel_Tooltip_Item_Show_General(slotNo, slotType, isOn, isNormal, index)
  Panel_Tooltip_Item_DataObject.itemMarket = nil
  Panel_Tooltip_Item_DataObject.inventory = nil
  if true ~= isOn then
    if Panel_Tooltip_Item_DataObject.currentSlotNo == slotNo then
      Panel_Tooltip_Item_hideTooltip()
      Panel_Tooltip_Item_DataObject.currentSlotNo = -1
      Panel_Tooltip_Item_DataObject.currentSlotType = ""
      Panel_Tooltip_Item_DataObject.index = -1
    end
    return false
  end
  if slotNo < 0 then
    return false
  end
  Panel_Tooltip_Item_hideTooltip()
  Panel_Tooltip_Item_DataObject.currentSlotNo = slotNo
  Panel_Tooltip_Item_DataObject.currentSlotType = slotType
  Panel_Tooltip_Item_DataObject.index = index
  Panel_Tooltip_Item_DataObject.isNormal = isNormal
  normalTooltip.deltaTime = 0
  equippedTooltip.deltaTime = 0
  local slot = Panel_Tooltip_Item_DataObject.slotData[slotType][slotNo]
  if nil == slot then
    return false
  end
  if nil ~= slot._type and (__eRewardExp == slot._type or __eRewardSkillExp == slot._type or __eRewardLifeExp == slot._type) then
    return false
  end
  return true
end
local linkItemTooltipParent
function Panel_Tooltip_Item_chattingLinkedItem_Set_Position(positionData, isClicked)
  local target
  if isClicked then
    target = Panel_Tooltip_Item_chattingLinkedItemClick
    linkItemTooltipParent = positionData
  else
    target = Panel_Tooltip_Item_chattingLinkedItem
  end
  local chattingLinkedItemShow = target:GetShow()
  if not chattingLinkedItemShow then
    return
  end
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local itemLinkedPosX = target:GetSizeX()
  local itemLinkedPosY = target:GetSizeY()
  local posX = positionData:GetParentPosX()
  local posY = positionData:GetParentPosY()
  local isLeft = posX > screenSizeX / 2
  local isTop = posY > screenSizeY / 2
  if not isLeft then
    posX = posX + positionData:GetSizeX()
  end
  if isTop then
    posY = posY + positionData:GetSizeY()
    local yDiff = posY - itemLinkedPosY
    if yDiff < 0 then
      posY = posY - yDiff
    end
  else
    local yDiff = screenSizeY - (posY + itemLinkedPosY)
    if yDiff < 0 then
      posY = posY + yDiff
    end
  end
  if isLeft then
    posX = posX - itemLinkedPosX
  end
  local yTmp = posY
  if isTop then
    yTmp = yTmp - itemLinkedPosY
  end
  target:SetPosX(posX)
  target:SetPosY(yTmp)
  if Panel_Tooltip_Item_chattingLinkedItemClick:GetShow() and target ~= Panel_Tooltip_Item_chattingLinkedItemClick then
    if positionData == linkItemTooltipParent then
      if isLeft then
        target:SetPosX(posX - Panel_Tooltip_Item_chattingLinkedItemClick:GetSizeX())
      else
        target:SetPosX(posX + Panel_Tooltip_Item_chattingLinkedItemClick:GetSizeX())
      end
    else
      target:SetPosX(posX)
    end
    target:SetPosY(yTmp)
  end
end
function Panel_Tooltip_Item_Set_Position_UISubApp(positionData, parent, inven)
  local itemShow = Panel_Tooltip_Item:GetShow()
  local equipItemShow = Panel_Tooltip_Item_equipped:GetShow()
  if not itemShow and not equipItemShow then
    return
  end
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local itemPosX = Panel_Tooltip_Item:GetSizeX()
  local itemPosY = Panel_Tooltip_Item:GetSizeY()
  local itemEquipPosX = Panel_Tooltip_Item_equipped:GetSizeX()
  local itemEquipPosY = Panel_Tooltip_Item_equipped:GetSizeY()
  local posX = positionData:GetScreenParentPosX()
  local posY = positionData:GetScreenParentPosY()
  if parent and inven then
    posX = positionData:getParent():GetScreenParentPosX()
    posY = positionData:getParent():GetScreenParentPosY() + 10
  elseif parent then
    posX = positionData:getParent():GetScreenParentPosX()
    posY = positionData:getParent():GetScreenParentPosY() - 500
  end
  local isLeft = posX > screenSizeX / 2
  local isTop = posY > screenSizeY / 2
  local tooltipSize = {width = 0, height = 0}
  local tooltipEquipped = {width = 0, height = 0}
  local sumSize = {width = 0, height = 0}
  if Panel_Tooltip_Item:GetShow() then
    tooltipSize.width = Panel_Tooltip_Item:GetSizeX()
    tooltipSize.height = Panel_Tooltip_Item:GetSizeY()
    sumSize.width = sumSize.width + tooltipSize.width
    sumSize.height = math.max(sumSize.height, tooltipSize.height)
  end
  if Panel_Tooltip_Item_equipped:GetShow() then
    tooltipEquipped.width = Panel_Tooltip_Item_equipped:GetSizeX()
    tooltipEquipped.height = Panel_Tooltip_Item_equipped:GetSizeY()
    sumSize.width = sumSize.width + tooltipEquipped.width
    sumSize.height = math.max(sumSize.height, tooltipEquipped.height)
  end
  if not isLeft then
    if parent and inven then
      posX = positionData:getParent():GetSizeX() + posX
    elseif nil ~= positionData:getParent() then
      posX = posX + positionData:getParent():GetSizeX() + positionData:GetSizeX()
    else
      posX = posX + positionData:GetSizeX()
    end
  end
  if Panel_Tooltip_Item:GetShow() then
    if isLeft then
      posX = posX - tooltipSize.width
    end
    local yTmp = posY
    if isTop then
    end
    Panel_Tooltip_Item:SetPosX(posX)
    Panel_Tooltip_Item:SetPosY(yTmp)
  end
  if Panel_Tooltip_Item_equipped:GetShow() then
    if isLeft then
      posX = posX - tooltipEquipped.width
    else
      posX = posX + tooltipSize.width
    end
    local yTmp = posY
    if isTop then
    end
    Panel_Tooltip_Item_equipped:SetPosX(posX)
    Panel_Tooltip_Item_equipped:SetPosY(yTmp)
  end
  if equippedTooltip.mainPanel:GetShow() and normalTooltip.mainPanel:GetShow() then
    local arrow = equippedTooltip.arrow
    if Panel_Tooltip_Item:GetPosX() < Panel_Tooltip_Item_equipped:GetPosX() then
      equippedTooltip.arrow:SetShow(false)
      arrow = equippedTooltip.arrow_L
      arrow:SetShow(true)
      arrow:SetPosY((equippedTooltip.mainPanel:GetSizeY() - arrow:GetSizeY()) / 2)
      arrow:SetPosX(-arrow:GetSizeX() / 2)
    else
      equippedTooltip.arrow_L:SetShow(false)
      arrow = equippedTooltip.arrow
      arrow:SetShow(true)
      arrow:SetPosY((equippedTooltip.mainPanel:GetSizeY() - arrow:GetSizeY()) / 2)
      arrow:SetPosX(equippedTooltip.mainPanel:GetSizeX() - arrow:GetSizeX() / 2)
    end
  else
    equippedTooltip.arrow:SetShow(false)
    equippedTooltip.arrow_L:SetShow(false)
  end
end
function Panel_Tooltip_Item_Set_Position(positionData, parent, inven, targetX, targetY, absolutLeft)
  local itemShow = Panel_Tooltip_Item:GetShow()
  local equipItemShow = Panel_Tooltip_Item_equipped:GetShow()
  if not itemShow and not equipItemShow then
    return
  end
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local itemPosX = Panel_Tooltip_Item:GetSizeX()
  local itemPosY = Panel_Tooltip_Item:GetSizeY()
  local itemEquipPosX = Panel_Tooltip_Item_equipped:GetSizeX()
  local itemEquipPosY = Panel_Tooltip_Item_equipped:GetSizeY()
  local posX = positionData:GetParentPosX()
  local posY = positionData:GetParentPosY()
  if parent and inven then
    posX = positionData:getParent():GetParentPosX() + 7
    posY = positionData:getParent():GetParentPosY() + 10
  elseif parent then
    posX = positionData:getParent():GetParentPosX()
    posY = positionData:getParent():GetParentPosY() - 500
  end
  local isLeft = posX > screenSizeX / 2
  local isTop = posY > screenSizeY / 2
  if nil ~= targetX and nil ~= targetY then
    isLeft = targetX > screenSizeX / 2
    isTop = targetY > screenSizeY / 2
  end
  if nil ~= absolutLeft then
    isLeft = absolutLeft
  end
  local tooltipSize = {width = 0, height = 0}
  local tooltipEquipped = {width = 0, height = 0}
  local sumSize = {width = 0, height = 0}
  if Panel_Tooltip_Item:GetShow() then
    tooltipSize.width = Panel_Tooltip_Item:GetSizeX()
    tooltipSize.height = Panel_Tooltip_Item:GetSizeY()
    sumSize.width = sumSize.width + tooltipSize.width
    sumSize.height = math.max(sumSize.height, tooltipSize.height)
  end
  if Panel_Tooltip_Item_equipped:GetShow() then
    tooltipEquipped.width = Panel_Tooltip_Item_equipped:GetSizeX()
    tooltipEquipped.height = Panel_Tooltip_Item_equipped:GetSizeY()
    sumSize.width = sumSize.width + tooltipEquipped.width
    sumSize.height = math.max(sumSize.height, tooltipEquipped.height)
  end
  if not isLeft then
    if parent and inven then
      posX = positionData:getParent():GetSizeX() + positionData:getParent():GetParentPosX()
    else
      posX = posX + positionData:GetSizeX()
    end
  end
  if isTop then
    posY = posY + positionData:GetSizeY()
    local yDiff = posY - sumSize.height
    if yDiff < 0 then
      posY = posY - yDiff
    end
  else
    local yDiff = screenSizeY - (posY + sumSize.height)
    if yDiff < 0 then
      posY = posY + yDiff
    end
  end
  if nil ~= targetX and nil ~= targetY then
    posX, posY = targetX, targetY
  end
  if Panel_Tooltip_Item:GetShow() then
    if isLeft then
      posX = posX - tooltipSize.width
    end
    local yTmp = posY
    if isTop then
      yTmp = yTmp - tooltipSize.height
    end
    Panel_Tooltip_Item:SetPosX(posX)
    Panel_Tooltip_Item:SetPosY(yTmp)
  end
  if Panel_Tooltip_Item_equipped:GetShow() then
    if isLeft then
      posX = posX - tooltipEquipped.width
    else
      posX = posX + tooltipSize.width
    end
    local yTmp = posY
    if isTop then
      yTmp = yTmp - tooltipEquipped.height
    end
    Panel_Tooltip_Item_equipped:SetPosX(posX)
    Panel_Tooltip_Item_equipped:SetPosY(yTmp)
  end
  if equippedTooltip.mainPanel:GetShow() and normalTooltip.mainPanel:GetShow() then
    local arrow = equippedTooltip.arrow
    if Panel_Tooltip_Item:GetPosX() < Panel_Tooltip_Item_equipped:GetPosX() then
      equippedTooltip.arrow:SetShow(false)
      arrow = equippedTooltip.arrow_L
      arrow:SetShow(true)
      arrow:SetPosY((equippedTooltip.mainPanel:GetSizeY() - arrow:GetSizeY()) / 2)
      arrow:SetPosX(-arrow:GetSizeX() / 2)
    else
      equippedTooltip.arrow_L:SetShow(false)
      arrow = equippedTooltip.arrow
      arrow:SetShow(true)
      arrow:SetPosY((equippedTooltip.mainPanel:GetSizeY() - arrow:GetSizeY()) / 2)
      arrow:SetPosX(equippedTooltip.mainPanel:GetSizeX() - arrow:GetSizeX() / 2)
    end
  else
    equippedTooltip.arrow:SetShow(false)
    equippedTooltip.arrow_L:SetShow(false)
  end
end
function Panel_Tooltip_Item_hideTooltip()
  if Panel_Tooltip_Item_DataObject.isSkill then
    Panel_SkillTooltip_Hide()
    return
  end
  if Panel_Tooltip_Item:IsShow() then
    Panel_Tooltip_Item:SetShow(false, false)
    Panel_Tooltip_Item:CloseUISubApp()
    Panel_Tooltip_Item_DataObject.currentSlotNo = -1
  end
  if Panel_Tooltip_Item_equipped:IsShow() then
    Panel_Tooltip_Item_equipped:SetShow(false, false)
    Panel_Tooltip_Item_equipped:CloseUISubApp()
    Panel_Tooltip_Item_DataObject.currentSlotNo = -1
  end
  if Panel_Tooltip_Item_chattingLinkedItem:IsShow() then
    Panel_Tooltip_Item_chattingLinkedItem:SetShow(false, false)
    Panel_Tooltip_Item_DataObject.currentSlotNo = -1
  end
  _firstTradeInfoData = nil
  _secondTradeInfoData = nil
end
function Panel_Tooltip_Item_chattingLinkedItem_hideTooltip()
  if Panel_Tooltip_Item_chattingLinkedItem:IsShow() then
    Panel_Tooltip_Item_chattingLinkedItem:SetShow(false, false)
  end
  _firstTradeInfoData = nil
  _secondTradeInfoData = nil
end
function Panel_Tooltip_Item_chattingLinkedItemClick_hideTooltip()
  if Panel_Tooltip_Item_chattingLinkedItemClick:IsShow() then
    linkItemTooltipParent = nil
    Panel_Tooltip_Item_chattingLinkedItemClick:SetShow(false, false)
  end
  _firstTradeInfoData = nil
  _secondTradeInfoData = nil
end
function _toolTip_ChangeDyeInfoTexture(target, bEmpty, dyeingPart_Index, dyeingPartColor)
  local texturePath = "New_UI_Common_forLua/Widget/ToolTip/ToolTip_00.dds"
  local control = target.useDyeColorIcon_Part[dyeingPart_Index]
  if not bEmpty then
    control:ChangeTextureInfoName(texturePath)
    local x1, y1, x2, y2 = setTextureUV_Func(control, 75, 43, 93, 61)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:SetAlphaIgnore(true)
    control:SetColor(dyeingPartColor)
  else
    control:ChangeTextureInfoName(texturePath)
    local x1, y1, x2, y2 = setTextureUV_Func(control, 98, 43, 116, 61)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:SetAlphaIgnore(true)
    control:SetColor(UI_color.C_FFFFFFFF)
  end
end
function Panel_Tooltip_Item_ShowInfo(target, inputValue, isSSW, isItemWrapper, chattingLinkedItem, index, isNextEnchantInfo, invenSlotNo, itemNamingStr)
  target.expireIcon_white:SetShow(false)
  target.expireIcon_red:SetShow(false)
  target.expireIcon_end:SetShow(false)
  local itemSSW, itemWrapper, item, itemKeyForTradeInfo
  if isSSW and not isItemWrapper then
    itemSSW = inputValue
    if nil == itemSSW then
      target.mainPanel:SetShow(false, false)
      target.mainPanel:CloseUISubApp()
      return false, false
    end
    item = itemSSW:get()
    itemKeyForTradeInfo = itemSSW:get()._key:get()
  else
    itemWrapper = inputValue
    if nil == itemWrapper then
      target.mainPanel:SetShow(false, false)
      target.mainPanel:CloseUISubApp()
      return false, false
    end
    itemSSW = itemWrapper:getStaticStatus()
    item = itemWrapper:get()
    itemKeyForTradeInfo = itemSSW:get()._key:get()
  end
  if equippedTooltip == target and true == isNextEnchantInfo then
    equippedTooltip.equippedTag:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_NEXT_ENCHANT"))
    local nextEnchantLevel = itemSSW:get()._key:getEnchantLevel() + 1
    if nextEnchantLevel > 20 then
      target.mainPanel:SetShow(false, false)
      target.mainPanel:CloseUISubApp()
      return false, false
    end
    local enchantItemKey = ItemEnchantKey(itemSSW:get()._key:getItemKey(), nextEnchantLevel)
    enchantItemKey:set(itemSSW:get()._key:getItemKey(), nextEnchantLevel)
    itemSSW = getItemEnchantStaticStatus(enchantItemKey)
    if nil == itemSSW or nil == itemSSW:get() then
      target.mainPanel:SetShow(false, false)
      target.mainPanel:CloseUISubApp()
      return false, false
    end
    itemKeyForTradeInfo = itemSSW:get()._key:get()
  else
    equippedTooltip.equippedTag:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_CURRENT_EQUIP"))
  end
  if nil ~= invenSlotNo then
    clothBagSlotNo = invenSlotNo
  end
  if normalTooltip == target then
    normalTooltip.bagSize:SetShow(false)
    normalTooltip.equipmentInBag:SetShow(false)
    if CppEnums.ContentsEventType.ContentsType_InventoryBag == itemSSW:get():getContentsEventType() and nil ~= clothBagSlotNo then
      local bagSize = itemSSW:getContentsEventParam2()
      normalTooltip.bagSize:SetShow(true)
      normalTooltip.bagSize:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_BAGSIZE", "size", bagSize))
      local itemNameinBag = ""
      for index = 0, bagSize - 1 do
        local bagItemWrapper
        if bagInWarehouse then
          bagItemWrapper = Warehouse_GetWarehouseWarpper():getItemInBag(clothBagSlotNo, index)
        else
          local whereType = CppEnums.ItemWhereType.eInventory
          if itemSSW:get():isCash() then
            whereType = CppEnums.ItemWhereType.eCashInventory
          end
          bagItemWrapper = getInventoryBagItemByType(whereType, clothBagSlotNo, index)
        end
        if nil ~= bagItemWrapper then
          if "" == itemNameinBag then
            itemNameinBag = tostring(bagItemWrapper:getStaticStatus():getName())
          else
            itemNameinBag = itemNameinBag .. "\n" .. tostring(bagItemWrapper:getStaticStatus():getName())
          end
        end
      end
      if "" == itemNameinBag then
        normalTooltip.equipmentInBag:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_BAG_EMPTY"))
      else
        normalTooltip.equipmentInBag:SetText(itemNameinBag)
      end
      normalTooltip.equipmentInBag:SetShow(true)
    end
  end
  if true == _ContentsGroup_RenewUI_ItemMarketPlace then
    local itemKey = itemSSW:get()._key:getItemKey()
    local enchantLevel = itemSSW:get()._key:getEnchantLevel()
    local enchantKey = ItemEnchantKey(itemKey, enchantLevel)
    local isAble = requestIsRegisterItemForItemMarket(itemSSW:get()._key)
    if isAble then
      local enchantKeyRaw = enchantKey:get()
      if nil == _firstTradeInfoData then
        ToClient_getWorldMarketTradePrice(enchantKeyRaw)
        target.tradeInfo_Panel:SetSize(target.tradeInfo_Panel:GetSizeX(), target.tradeInfo_Title:GetTextSizeY() + target.tradeInfo_Value:GetTextSizeY() + 35)
        target.tradeInfo_Panel:SetShow(true)
        target.tradeInfo_Title:SetShow(true)
        target.tradeInfo_Value:SetShow(true)
        target.tradeInfo_Value:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_TRADEPRICE_TITLE"))
        target.tradeInfo_Ani:SetShow(true)
        target.tradeInfo_Ani:SetPosX(target.tradeInfo_Value:GetTextSizeX() + 10)
        _firstTradeInfoData = {}
        _firstTradeInfoData.key = enchantKeyRaw
        _firstTradeInfoData.txt_valuePrice = target.tradeInfo_Value
        _firstTradeInfoData.pendingAnimation = target.tradeInfo_Ani
      elseif nil == _secondTradeInfoData then
        ToClient_getWorldMarketTradePrice(enchantKeyRaw)
        target.tradeInfo_Panel:SetSize(target.tradeInfo_Panel:GetSizeX(), target.tradeInfo_Title:GetTextSizeY() + target.tradeInfo_Value:GetTextSizeY() + 35)
        target.tradeInfo_Panel:SetShow(true)
        target.tradeInfo_Title:SetShow(true)
        target.tradeInfo_Value:SetShow(true)
        target.tradeInfo_Value:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_TRADEPRICE_TITLE"))
        target.tradeInfo_Ani:SetShow(true)
        target.tradeInfo_Ani:SetPosX(target.tradeInfo_Value:GetTextSizeX() + 10)
        _secondTradeInfoData = {}
        _secondTradeInfoData.key = enchantKeyRaw
        _secondTradeInfoData.txt_valuePrice = target.tradeInfo_Value
        _secondTradeInfoData.pendingAnimation = target.tradeInfo_Ani
      else
        _firstTradeInfoData = nil
        _secondTradeInfoData = nil
      end
    else
      target.tradeInfo_Panel:SetShow(false)
      target.tradeInfo_Title:SetShow(false)
      target.tradeInfo_Value:SetShow(false)
      target.tradeInfo_Ani:SetShow(false)
    end
  else
    target.tradeInfo_Ani:SetShow(false)
    local tradeInfo
    local tradeSummaryInfo = getItemMarketSummaryInClientByItemEnchantKey(itemKeyForTradeInfo)
    local tradeMasterInfo = getItemMarketMasterByItemEnchantKey(itemKeyForTradeInfo)
    local itemClassifyType = itemSSW:getItemClassify()
    if nil ~= tradeSummaryInfo then
      tradeInfo = tradeSummaryInfo
    elseif nil ~= tradeMasterInfo then
      tradeInfo = tradeMasterInfo
    else
      tradeInfo = nil
    end
    if nil ~= tradeInfo and not _ContentsGroup_RenewUI then
      local tradeMasterItemName = tradeInfo:getItemEnchantStaticStatusWrapper():getName()
      if nil ~= tradeSummaryInfo and toInt64(0, 0) ~= tradeSummaryInfo:getDisplayedTotalAmount() then
        target.tradeInfo_Value:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_TRADEINFO_REGISTPRICE", "highestOnePrice", makeDotMoney(tradeInfo:getDisplayedHighestOnePrice()), "LowestOnePrice", makeDotMoney(tradeInfo:getDisplayedLowestOnePrice())))
      else
        target.tradeInfo_Value:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_TRADEINFO_HIGHANDLOWPRICE", "getMaxPrice", makeDotMoney(tradeMasterInfo:getMaxPrice()), "getMinPrice", makeDotMoney(tradeMasterInfo:getMinPrice())))
      end
      target.tradeInfo_Panel:SetSize(target.tradeInfo_Panel:GetSizeX(), target.tradeInfo_Title:GetTextSizeY() + target.tradeInfo_Value:GetTextSizeY() + 10)
      target.tradeInfo_Panel:SetShow(true)
      target.tradeInfo_Title:SetShow(true)
      target.tradeInfo_Value:SetShow(true)
    else
      target.tradeInfo_Panel:SetShow(false)
      target.tradeInfo_Title:SetShow(false)
      target.tradeInfo_Value:SetShow(false)
    end
  end
  target.equipSlotName:SetShow(false)
  if 1 == itemSSW:getItemType() then
    local EquipslotNo = itemSSW:getEquipSlotNo()
    if 21 == EquipslotNo then
      target.equipSlotName:SetShow(true)
      target.equipSlotName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_EQUIPSLOTNAME_HEAD"))
    elseif 22 == EquipslotNo then
      target.equipSlotName:SetShow(true)
      target.equipSlotName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_EQUIPSLOTNAME_EYES"))
    elseif 23 == EquipslotNo then
      target.equipSlotName:SetShow(true)
      target.equipSlotName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_EQUIPSLOTNAME_MOUSE"))
    end
  end
  local classType = getSelfPlayer():getClassType()
  local nameColorGrade = itemSSW:getGradeType()
  if 0 == nameColorGrade then
    target.itemName:SetFontColor(UI_color.C_FFFFFFFF)
  elseif 1 == nameColorGrade then
    target.itemName:SetFontColor(4284350320)
  elseif 2 == nameColorGrade then
    target.itemName:SetFontColor(4283144191)
  elseif 3 == nameColorGrade then
    target.itemName:SetFontColor(4294953010)
  elseif 4 == nameColorGrade then
    target.itemName:SetFontColor(4294929408)
  else
    target.itemName:SetFontColor(UI_color.C_FFFFFFFF)
  end
  target.itemIcon:ChangeTextureInfoName("icon/" .. itemSSW:getIconPath())
  if nil ~= itemWrapper then
    local isSoulCollector = itemWrapper:isSoulCollector()
    local isCurrentSoulCount = itemWrapper:getSoulCollectorCount()
    local isMaxSoulCount = itemWrapper:getSoulCollectorMaxCount()
    if isSoulCollector then
      target.itemIcon:ChangeTextureInfoName("icon/" .. itemWrapper:getStaticStatus():getIconPath())
      if 0 == isCurrentSoulCount then
        target.itemIcon:ChangeTextureInfoName("icon/" .. itemWrapper:getStaticStatus():getIconPath())
      end
      if isCurrentSoulCount > 0 then
        target.itemIcon:ChangeTextureInfoName("New_UI_Common_forLua/ExceptionIcon/00040351_1.dds")
      end
      if isCurrentSoulCount == isMaxSoulCount then
        target.itemIcon:ChangeTextureInfoName("New_UI_Common_forLua/ExceptionIcon/00040351_2.dds")
      end
    end
  end
  local enchantLevel = itemSSW:get()._key:getEnchantLevel()
  local isEnchantLevel5 = false
  if enchantLevel > 0 and enchantLevel < 16 then
    target.enchantLevel:SetText("+" .. tostring(enchantLevel))
    target.enchantLevel:SetShow(true)
  elseif 16 == enchantLevel then
    target.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1"))
    target.enchantLevel:SetShow(true)
  elseif 17 == enchantLevel then
    target.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2"))
    target.enchantLevel:SetShow(true)
  elseif 18 == enchantLevel then
    target.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3"))
    target.enchantLevel:SetShow(true)
  elseif 19 == enchantLevel then
    target.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4"))
    target.enchantLevel:SetShow(true)
  elseif 20 == enchantLevel then
    target.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5"))
    target.enchantLevel:SetShow(true)
    isEnchantLevel5 = true
  else
    target.enchantLevel:SetShow(false)
  end
  if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
    if 1 == enchantLevel then
      target.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1"))
      target.enchantLevel:SetShow(true)
    elseif 2 == enchantLevel then
      target.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2"))
      target.enchantLevel:SetShow(true)
    elseif 3 == enchantLevel then
      target.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3"))
      target.enchantLevel:SetShow(true)
    elseif 4 == enchantLevel then
      target.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4"))
      target.enchantLevel:SetShow(true)
    elseif 5 == enchantLevel then
      target.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5"))
      target.enchantLevel:SetShow(true)
      isEnchantLevel5 = true
    end
  end
  if itemSSW:get():isCash() then
    target.enchantLevel:SetShow(false)
  end
  local isCash = itemSSW:get():isCash()
  local balksCount = itemSSW:getExtractionCount_s64()
  local cronsCount = itemSSW:getCronCount_s64()
  if false == isCash and nil ~= balksCount and toInt64(0, 0) ~= balksCount and nil ~= cronsCount and toInt64(0, 0) ~= cronsCount then
    target.enchantLevel:SetShow(false)
  end
  target._txt_MaxEnchanter:SetShow(false)
  target.itemName:SetTextMode(UI_TM.eTextMode_AutoWrap)
  if 1 == itemSSW:getItemType() and enchantLevel > 15 then
    local itemAndEnchantName = HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemSSW:getName()
    if nil ~= itemNamingStr and true == isEnchantLevel5 then
      target.itemName:SetText(itemAndEnchantName)
      target._txt_MaxEnchanter:SetShow(isMaxEnchanterEnable)
      target._txt_MaxEnchanter:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_MAXENCHANTER", "name", itemNamingStr))
    elseif nil ~= chattingLinkedItem and "" ~= chattingLinkedItem:getItemNamingUserName() then
      target.itemName:SetText(itemAndEnchantName)
      target._txt_MaxEnchanter:SetShow(isMaxEnchanterEnable)
      target._txt_MaxEnchanter:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_MAXENCHANTER", "name", chattingLinkedItem:getItemNamingUserName()))
    else
      target.itemName:SetText(itemAndEnchantName)
    end
  elseif enchantLevel > 0 and CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
    local itemAndEnchantName = HighEnchantLevel_ReplaceString(enchantLevel + 15) .. " " .. itemSSW:getName()
    if nil ~= itemNamingStr and true == isEnchantLevel5 then
      target.itemName:SetText(itemAndEnchantName)
      target._txt_MaxEnchanter:SetShow(isMaxEnchanterEnable)
      target._txt_MaxEnchanter:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_MAXENCHANTER", "name", itemNamingStr))
    elseif nil ~= chattingLinkedItem and "" ~= chattingLinkedItem:getItemNamingUserName() then
      target.itemName:SetText(itemAndEnchantName)
      target._txt_MaxEnchanter:SetShow(isMaxEnchanterEnable)
      target._txt_MaxEnchanter:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_MAXENCHANTER", "name", chattingLinkedItem:getItemNamingUserName()))
    else
      target.itemName:SetText(itemAndEnchantName)
    end
  elseif nil ~= itemNamingStr and true == isEnchantLevel5 then
    target.itemName:SetText(itemSSW:getName())
    target._txt_MaxEnchanter:SetShow(isMaxEnchanterEnable)
    target._txt_MaxEnchanter:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_MAXENCHANTER", "name", itemNamingStr))
  elseif nil ~= chattingLinkedItem and "" ~= chattingLinkedItem:getItemNamingUserName() then
    target.itemName:SetText(itemSSW:getName())
    target._txt_MaxEnchanter:SetShow(isMaxEnchanterEnable)
    target._txt_MaxEnchanter:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_MAXENCHANTER", "name", chattingLinkedItem:getItemNamingUserName()))
  else
    target.itemName:SetText(itemSSW:getName())
  end
  local changeItemNamePos = 25
  local iconMovePos = 0
  if 1 < target.itemName:GetLineCount() then
    changeItemNamePos = (target.itemName:GetLineCount() - 1) * 11 + target.itemName:GetTextSizeY()
    iconMovePos = -30
  elseif 3 == target.itemName:GetLineCount() then
    changeItemNamePos = (target.itemName:GetLineCount() - 1) * 11 + target.itemName:GetTextSizeY()
    iconMovePos = -60
  elseif 4 == target.itemName:GetLineCount() then
    changeItemNamePos = (target.itemName:GetLineCount() - 1) * 11 + target.itemName:GetTextSizeY()
    iconMovePos = -90
  end
  local item_type = itemSSW:getItemType()
  local isTradeItem = itemSSW:isTradeAble()
  if item_type == 1 then
    target.itemType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIPMENT"))
  elseif item_type == 2 then
    if isTradeItem == true then
      target.itemType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_ITEM"))
    else
      target.itemType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_CONSUME"))
    end
  elseif item_type == 3 then
    target.itemType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TENT_TOOL"))
  elseif item_type == 4 then
    target.itemType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_INSTALL_TOOL"))
  elseif item_type == 5 then
    target.itemType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_SOCKET_ITEM"))
  elseif item_type == 6 then
    target.itemType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_CANNONBALL"))
  elseif item_type == 7 then
    target.itemType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_LICENCE"))
  elseif item_type == 8 then
    target.itemType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PRODUCTION"))
  elseif item_type == 9 then
    target.itemType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_ENTER_AIR"))
  elseif item_type == 10 then
    target.itemType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_SPECIAL_PRODUCTION"))
  elseif true == itemSSW:get():isForJustTrade() then
    target.itemType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOMAL") .. "/" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_ITEM"))
  else
    target.itemType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOMAL"))
  end
  if item_type == 8 and true == itemSSW:get():isForJustTrade() then
    target.itemType:SetText(target.itemType:GetText() .. "/" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_ITEM"))
  end
  target.isSealed:SetShow(false)
  if itemSSW:isEquipable() and not isSSW and not itemSSW:get():isCash() and item:isSealed() then
    target.isSealed:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_ISEQUIPSEAL"))
    target.isSealed:SetShow(true)
  end
  local isAble = false
  if nil ~= itemWrapper then
    isAble = requestIsRegisterItemForItemMarket(itemWrapper:get():getKey())
  end
  if itemSSW:get():isCash() and not isSSW and isAble and item:isSealed() and not itemSSW:isStackable() and not item:isVested() then
    target.isSealed:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_TAXFREE"))
    target.isSealed:SetShow(true)
  end
  target.isEnchantable:SetShow(false)
  local isPossibleToEnchant = itemSSW:get():isEnchantable()
  if itemSSW:isEquipable() then
    if isPossibleToEnchant == false then
      target.isEnchantable:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOT_ENCHANT"))
      target.isEnchantable:SetShow(true)
    else
      target.isEnchantable:SetShow(false)
    end
  end
  local interiorPoint = 0
  if itemSSW:get():isItemInstallation() then
    interiorPoint = itemSSW:getCharacterStaticStatus():getObjectStaticStatus():getInteriorSensPoint()
    if interiorPoint > 0 then
      target.isEnchantable:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_INTERIOR_POINT") .. interiorPoint .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_POINT"))
      target.isEnchantable:SetShow(true)
    end
  elseif not target.isEnchantable:GetShow() then
    target.isEnchantable:SetShow(false)
  end
  local itemBindType = itemSSW:get()._vestedType:getItemKey()
  if not isSSW and item:isVested() then
    if itemSSW:isUserVested() then
      target.bindType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_HOLDED_FAMILYACOUNT"))
    else
      target.bindType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_HOLDED"))
    end
    target.bindType:SetShow(true)
  elseif itemSSW:isGuildStockable() then
    target.bindType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_HOLDED_GUILD"))
    target.bindType:SetShow(true)
  elseif itemBindType == 1 then
    if isSSW and itemSSW:isUserVested() then
      target.bindType:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_GETBIND_FAMILY"))
      target.bindType:SetShow(true)
    else
      target.bindType:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_GETBIND_CHARACTER"))
      target.bindType:SetShow(true)
    end
  elseif itemBindType == 2 then
    if isSSW and itemSSW:isUserVested() then
      target.bindType:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_EQUIPBIND_FAMILY"))
      target.bindType:SetShow(true)
    else
      target.bindType:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_EQUIPBIND_CHARACTER"))
      target.bindType:SetShow(true)
    end
  else
    target.bindType:SetShow(false)
  end
  local balksCount = itemSSW:getExtractionCount_s64()
  local cronsCount = itemSSW:getCronCount_s64()
  if nil ~= balksCount and toInt64(0, 0) ~= balksCount and (isExtractionCommon or isExtractionJapan) then
    target.balksExtraction:SetShow(true)
    target.balksExtraction:SetFontColor(UI_color.C_FFBC56E1)
    target.balksExtraction:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_BALKS_EXTRACTION", "balksCount", Int64toInt32(balksCount)))
  else
    target.balksExtraction:SetShow(false)
  end
  if nil ~= cronsCount and toInt64(0, 0) ~= cronsCount and isCronStone and (isExtractionJapan or isExtractionCommon) then
    target.cronsExtraction:SetShow(true)
    target.cronsExtraction:SetFontColor(UI_color.C_FFBC56E1)
    target.cronsExtraction:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_CRONS_EXTRACTION", "cronsCount", Int64toInt32(cronsCount)))
  else
    target.cronsExtraction:SetShow(false)
  end
  target.personalTrade:SetShow(false)
  if isUsePcExchangeInLocalizingValue() and CppEnums.CountryType.DEV ~= getGameServiceType() then
    target.personalTrade:SetShow(true)
    if nil ~= itemWrapper then
      if itemSSW:isPersonalTrade() and not itemWrapper:get():isVested() then
        target.personalTrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_PERSONALTRADE_ENABLE"))
      else
        target.personalTrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_PERSONALTRADE_DISABLE"))
      end
    elseif nil ~= itemSSW then
      if itemSSW:isPersonalTrade() then
        target.personalTrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_PERSONALTRADE_ENABLE"))
      else
        target.personalTrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_PERSONALTRADE_DISABLE"))
      end
    end
  end
  target.cronStoneEnchant:SetShow(false)
  target.cronStoneValue:SetShow(false)
  target.cronStoneGrade:SetShow(false)
  target.cronStoneProgressBg:SetShow(false)
  target.cronStoneProgress:SetShow(false)
  target.cronStoneGradeValue[0]:SetShow(false)
  target.cronStoneGradeValue[1]:SetShow(false)
  target.cronStoneGradeValue[2]:SetShow(false)
  target.cronStoneGradeValue[3]:SetShow(false)
  target.cronStoneCountValue[0]:SetShow(false)
  target.cronStoneCountValue[1]:SetShow(false)
  target.cronStoneCountValue[2]:SetShow(false)
  target.cronStoneCountValue[3]:SetShow(false)
  target.cronStoneValue:SetSize(300, target.cronStoneValue:GetSizeY())
  target.cronStoneValue:SetTextMode(UI_TM.eTextMode_AutoWrap)
  local itemaddedDD = 0
  local itemaddedHit = 0
  local itemaddedDV = 0
  local itemaddedHDV = 0
  local itemaddedPV = 0
  local itemaddedHPV = 0
  if (equippedTooltip ~= target or true ~= isNextEnchantInfo) and (true ~= ItemMarket_getIsMarketItem() or equippedTooltip == target) then
    local currentEnchantFailCount = 0
    if nil ~= itemWrapper then
      currentEnchantFailCount = itemWrapper:getCronEnchantFailCount()
    elseif nil ~= chattingLinkedItem then
      currentEnchantFailCount = chattingLinkedItem:getItemParam(0)
    end
    if currentEnchantFailCount > 0 then
      local itemSSW, itemEnchantWrapper
      if nil ~= itemWrapper then
        itemSSW = itemWrapper:getStaticStatus()
        itemEnchantWrapper = itemWrapper
      elseif nil ~= chattingLinkedItem then
        itemSSW = chattingLinkedItem:getLinkedItemStaticStatus()
        itemEnchantWrapper = chattingLinkedItem
      end
      local cronKey = itemSSW:getCronKey()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      local gradeCount = ToClient_GetCronEnchnatInfoCount(cronKey, enchantLevel)
      local startPosX = 2
      local lastCount = 0
      local currentGrade = 0
      local lastIndex = gradeCount - 1
      if gradeCount > 0 then
        local cronEnchantSSW = ToClient_GetCronEnchantWrapper(cronKey, enchantLevel, lastIndex)
        local enchantablelastCount = cronEnchantSSW:getCount()
        if currentEnchantFailCount > 0 then
          for gradeIndex = 0, gradeCount - 1 do
            local cronEnchantSSW = ToClient_GetCronEnchantWrapper(cronKey, enchantLevel, gradeIndex)
            local enchantableCount = cronEnchantSSW:getCount()
            if currentEnchantFailCount < enchantableCount then
            else
              currentGrade = currentGrade + 1
            end
            if gradeCount - 1 == gradeIndex then
              lastCount = enchantableCount
            end
          end
        end
        currentEnchantFailCount = math.min(currentEnchantFailCount, lastCount)
        local bonusText = ""
        itemaddedDD = itemEnchantWrapper:getAddedDD()
        itemaddedHit = itemEnchantWrapper:getAddedHIT()
        itemaddedDV = itemEnchantWrapper:getAddedDV()
        itemaddedHDV = itemEnchantWrapper:getCronHDV()
        itemaddedPV = itemEnchantWrapper:getAddedPV()
        itemaddedHPV = itemEnchantWrapper:getCronHPV()
        local itemMaxHp = itemEnchantWrapper:getAddedMaxHP()
        local itemMaxMp = itemEnchantWrapper:getAddedMaxMP()
        if itemaddedDD > 0 then
          if "" == bonusText then
            bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_ATTACK", "value", itemaddedDD)
          else
            bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_ATTACKB", "value", itemaddedDD)
          end
        end
        if 0 < math.floor(itemaddedHit) then
          if "" == bonusText then
            bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_HIT", "value", math.floor(itemaddedHit))
          else
            bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_HITB", "value", math.floor(itemaddedHit))
          end
        end
        if itemaddedDV > 0 then
          if "" == bonusText then
            bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_DODGE", "value", itemaddedDV)
          else
            bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_DODGEB", "value", itemaddedDV)
          end
        end
        if itemaddedHDV > 0 then
          if 0 == itemaddedDV then
            if "" == bonusText then
              bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_DODGE", "value", 0) .. "(+" .. tostring(itemaddedHDV) .. ")"
            else
              bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_DODGEB", "value", 0) .. "(+" .. tostring(itemaddedHDV) .. ")"
            end
          else
            bonusText = bonusText .. "(+" .. tostring(itemaddedHDV) .. ")"
          end
        end
        if itemaddedPV > 0 then
          if "" == bonusText then
            bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_REDUCE", "value", itemaddedPV)
          else
            bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_REDUCEB", "value", itemaddedPV)
          end
        end
        if itemaddedHPV > 0 then
          if 0 == itemaddedPV then
            if "" == bonusText then
              bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_REDUCE", "value", 0) .. "(+" .. tostring(itemaddedHPV) .. ")"
            else
              bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_REDUCEB", "value", 0) .. "(+" .. tostring(itemaddedHPV) .. ")"
            end
          else
            bonusText = bonusText .. "(+" .. tostring(itemaddedHPV) .. ")"
          end
        end
        if itemMaxHp > 0 then
          if "" == bonusText then
            bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_HP", "value", itemMaxHp)
          else
            bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_HPB", "value", itemMaxHp)
          end
        end
        if itemMaxMp > 0 then
          if "" == bonusText then
            bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_MP", "value", itemMaxMp)
          else
            bonusText = bonusText .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_MPB", "value", itemMaxMp)
          end
        end
        if "" == bonusText then
          bonusText = PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_NOTHING")
        end
        target.cronStoneEnchant:SetShow(true)
        target.cronStoneValue:SetShow(true)
        target.cronStoneEnchant:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANTGRADE_CAPHRAS", "grade", currentGrade))
        target.cronStoneValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_BONUS", "bonusText", bonusText))
      end
    end
  end
  target.itemLock:SetShow(false)
  if true == Panel_Tooltip_Item_DataObject.inventory and true == isItemLock and not Panel_Tooltip_Item_equipped:GetShow() then
    local itemSSW = itemWrapper:getStaticStatus()
    if ToClient_Inventory_CheckItemLock(Inventory_GetToolTipItemSlotNo()) and false == itemSSW:get():isCash() then
      target.itemLock:SetShow(true)
      target.itemLock:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TOOLTIP_ITEM_ITEMLOCK"))
      target.productNotify:SetText(PAGetString(Defines.StringSheet_RESOURCE, "UI_TOOLTIP_ITEM_SHIFTCLICK") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TOOLTIP_ITEM_SHIFTRCLICK_UNLOCK"))
    else
      target.itemLock:SetShow(false)
      target.productNotify:SetText(PAGetString(Defines.StringSheet_RESOURCE, "UI_TOOLTIP_ITEM_SHIFTCLICK") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TOOLTIP_ITEM_SHIFTRCLICK_LOCK"))
    end
  elseif true == EquipItem_Lock.equipment then
    if EquipItem_Lock.itemLock then
      target.itemLock:SetShow(true)
      target.itemLock:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TOOLTIP_ITEM_ITEMLOCK"))
    else
      target.itemLock:SetShow(false)
    end
  else
    local itemCheckLock = false
    if -1 ~= EquipItem_Lock.itemAccNo then
      itemCheckLock = ToClient_EquipSlot_CheckItemLock(EquipItem_Lock.itemAccNo, 1)
      if itemCheckLock then
        equippedTooltip.itemLock:SetShow(true)
        equippedTooltip.itemLock:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TOOLTIP_ITEM_ITEMLOCK"))
      else
        equippedTooltip.itemLock:SetShow(false)
      end
    end
  end
  target.useDyeColorTitle:SetShow(false)
  target.useDyeColorIcon_Part[0]:SetShow(false)
  target.useDyeColorIcon_Part[1]:SetShow(false)
  target.useDyeColorIcon_Part[2]:SetShow(false)
  target.useDyeColorIcon_Part[3]:SetShow(false)
  target.useDyeColorIcon_Part[4]:SetShow(false)
  target.useDyeColorIcon_Part[5]:SetShow(false)
  target.useDyeColorIcon_Part[6]:SetShow(false)
  target.useDyeColorIcon_Part[7]:SetShow(false)
  target.useDyeColorIcon_Part[8]:SetShow(false)
  target.useDyeColorIcon_Part[9]:SetShow(false)
  target.useDyeColorIcon_Part[10]:SetShow(false)
  target.useDyeColorIcon_Part[11]:SetShow(false)
  target.dying:SetShow(false)
  if nil ~= itemWrapper or nil ~= chattingLinkedItem then
    local dyeAble = itemSSW:isDyeable()
    if itemSSW:isEquipable() then
      local dyeingPartCount = 0
      if nil ~= itemWrapper then
        dyeingPartCount = itemWrapper:getDyeingPartCount()
      elseif nil ~= chattingLinkedItem then
        dyeingPartCount = chattingLinkedItem:getDyeingPartCount()
      end
      if true == dyeAble then
        for dyeingPart_Index = 0, dyeingPartCount - 1 do
          local bEmpty = false
          if nil ~= itemWrapper then
            bEmpty = itemWrapper:isEmptyDyeingPartColorAt(dyeingPart_Index)
            if not itemWrapper:isAllreadyDyeingSlot(dyeingPart_Index) then
              bEmpty = true
            end
          elseif nil ~= chattingLinkedItem then
            bEmpty = chattingLinkedItem:isEmptyDyeingPartColorAt(dyeingPart_Index)
            if not chattingLinkedItem:isAllreadyDyeingSlot(dyeingPart_Index) then
              bEmpty = true
            end
          end
          if not bEmpty then
            target.dying:SetShow(true)
            local dyeingPartColor
            if nil ~= itemWrapper then
              dyeingPartColor = itemWrapper:getDyeingPartColorAt(dyeingPart_Index)
            elseif nil ~= chattingLinkedItem then
              dyeingPartColor = chattingLinkedItem:getDyeingPartColorAt(dyeingPart_Index)
            end
            _toolTip_ChangeDyeInfoTexture(target, bEmpty, dyeingPart_Index, dyeingPartColor)
          else
            _toolTip_ChangeDyeInfoTexture(target, bEmpty, dyeingPart_Index, UI_color.C_FFFFFFFF)
          end
          target.useDyeColorIcon_Part[dyeingPart_Index]:SetShow(true)
        end
        if dyeingPartCount > 0 then
          local isPearlPallete = ""
          if nil ~= itemWrapper and itemWrapper:isExpirationDyeing() then
            isPearlPallete = "(" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAUGE_DYEINGPACKEAGE_TITLE") .. ")"
          end
          target.useDyeColorTitle:SetShow(true)
          target.useDyeColorTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_DYE_DYEINFO") .. isPearlPallete)
        end
      else
        target.useDyeColorTitle:SetShow(true)
        target.useDyeColorTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_DYE_DYEIMPOSSIBLE"))
      end
    else
    end
    if _ContentsGroup_RenewUI then
      target.useDyeColorTitle:SetShow(false)
      target.useDyeColorIcon_Part[0]:SetShow(false)
      target.useDyeColorIcon_Part[1]:SetShow(false)
      target.useDyeColorIcon_Part[2]:SetShow(false)
      target.useDyeColorIcon_Part[3]:SetShow(false)
      target.useDyeColorIcon_Part[4]:SetShow(false)
      target.useDyeColorIcon_Part[5]:SetShow(false)
      target.useDyeColorIcon_Part[6]:SetShow(false)
      target.useDyeColorIcon_Part[7]:SetShow(false)
      target.useDyeColorIcon_Part[8]:SetShow(false)
      target.useDyeColorIcon_Part[9]:SetShow(false)
      target.useDyeColorIcon_Part[10]:SetShow(false)
      target.useDyeColorIcon_Part[11]:SetShow(false)
      target.dying:SetShow(false)
    end
  end
  target._txt_repair:SetShow(false)
  if nil ~= itemSSW and nil ~= item then
    local equipType = itemSSW:getEquipType()
    local enduranceLimit = item:getMaxEndurance()
    local repairPriceByNpc_s64 = itemSSW:isRepairPriceByNpc()
    PaGlobalFunc_Tooltip_Item_Repaircheck(target, equipType, enduranceLimit, repairPriceByNpc_s64)
  end
  local useLimitShow = false
  local minLevel = itemSSW:get()._minLevel
  local isExistMaxLevel = itemSSW:get():isMaxLevelRestricted()
  local myInfo = getSelfPlayer()
  local myLevel = myInfo:get():getLevel()
  local minLevelString = tostring(minLevel)
  local jewelLevel = 0
  local maxLevel = itemSSW:get()._maxLevel
  local maxLevelString = tostring(maxLevel)
  if not isSSW then
    jewelLevel = item:getJewelValidLevel()
    if 0 ~= jewelLevel then
      minLevelString = minLevelString .. "(" .. tostring(minLevel + jewelLevel) .. ")"
    end
  end
  if isExistMaxLevel == true then
    if not isSSW and 0 ~= jewelLevel then
      maxLevelString = maxLevelString .. "(" .. tostring(maxLevel + jewelLevel) .. ")"
    end
    target.useLimit_level_value:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_TOOLTIP_USEITEM_LIMIT", "minLevel", minLevelString, "maxLevel", maxLevelString))
    target.useLimit_level_value:SetShow(true)
    target.useLimit_level:SetShow(true)
    useLimitShow = true
    if myLevel < maxLevel then
      target.useLimit_level_value:SetFontColor(UI_color.C_FFC4BEBE)
    end
  elseif minLevel > 1 then
    if minLevel > myLevel then
      target.useLimit_level_value:SetFontColor(UI_color.C_FFF26A6A)
    else
      target.useLimit_level_value:SetFontColor(UI_color.C_FFC4BEBE)
    end
    target.useLimit_level_value:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_TOOLTIP_USEITEM_FROM", "limitLevel", minLevelString))
    target.useLimit_level_value:SetShow(true)
    target.useLimit_level:SetShow(true)
    useLimitShow = true
  else
    target.useLimit_level_value:SetShow(false)
    target.useLimit_level:SetShow(false)
  end
  local craftType
  local gather = 0
  fishing = 1
  hunting = 2
  cooking = 3
  alchemy = 4
  manufacture = 5
  training = 6
  trade = 7
  growth = 8
  sail = 9
  local lifeminLevel = 0
  local lifeType = {
    [0] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_GATHERING"),
    [1] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_FISHING"),
    [2] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_HUNTING"),
    [3] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_COOKING"),
    [4] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_ALCHEMY"),
    [5] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PROCESSING"),
    [6] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_OBEDIENCE"),
    [7] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE"),
    [8] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_GROWTH"),
    [9] = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_SAIL")
  }
  local craftType = itemSSW:get():getLifeExperienceType()
  local lifeminLevel = itemSSW:get():getLifeMinLevel(craftType)
  if lifeminLevel > 0 then
    local myLifeLevel = myInfo:get():getLifeExperienceLevel(craftType)
    if true == _ContentsGroup_RenewUI then
      target.useLimit_level_value:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_TOOLTIP_USELIMIT_LEVEL_VALUE", "craftType", lifeType[craftType], "lifeminLevel", PaGlobalFunc_CharacterLifeInfo_CraftLevel_Replace(lifeminLevel, craftType)))
    elseif _ContentsGroup_isUsedNewCharacterInfo == false then
      target.useLimit_level_value:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_TOOLTIP_USELIMIT_LEVEL_VALUE", "craftType", lifeType[craftType], "lifeminLevel", FGlobal_CraftLevel_Replace(lifeminLevel, craftType)))
    else
      target.useLimit_level_value:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_TOOLTIP_USELIMIT_LEVEL_VALUE", "craftType", lifeType[craftType], "lifeminLevel", FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(lifeminLevel)))
    end
    target.useLimit_level_value:SetShow(true)
    target.useLimit_level:SetShow(true)
    useLimitShow = true
    if lifeminLevel > myLifeLevel then
      target.useLimit_level_value:SetFontColor(UI_color.C_FFF26A6A)
    else
      target.useLimit_level_value:SetFontColor(UI_color.C_FFC4BEBE)
    end
  end
  local item_type = itemSSW:getItemType()
  local equip = {
    slotNoId = {
      [0] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_MAINHAND"),
      [1] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_SUBHAND"),
      [2] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_PICKINGTOOLS"),
      [3] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_UPPERBODY"),
      [4] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_GLOVES"),
      [5] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_BOOTS"),
      [6] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_HELM"),
      [7] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_NECKLACE"),
      [8] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_RING"),
      [9] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_RING"),
      [10] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_EARRING"),
      [11] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_EARRING"),
      [12] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_WAISTBAND"),
      [13] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_LANTERN"),
      [14] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_UPPERBODY"),
      [15] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_GLOVES"),
      [16] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_BOOTS"),
      [17] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_HELM"),
      [18] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_MAINHAND"),
      [19] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_SUBHAND"),
      [29] = PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_awakenWeapon")
    },
    extendedSlotInfoArray = {},
    checkExtendedSlot = 0
  }
  target.useLimit_extendedslot_value:SetShow(false)
  if 1 == item_type then
    if ItemTooltip_UsableClssTypeCheck(itemSSW) then
      local itemName = itemSSW:getName()
      local slotNoMax = itemSSW:getExtendedSlotCount()
      local extendedSlotString = ""
      local compareSlot = {}
      for i = 1, slotNoMax do
        local extendSlotNo = itemSSW:getExtendedSlotIndex(i - 1)
        if slotNoMax ~= extendSlotNo then
          equip.extendedSlotInfoArray[extendSlotNo] = i
          equip.checkExtendedSlot = 1
          compareSlot[i] = extendSlotNo
          local compareCheck = false
          if 1 == i then
            extendedSlotString = extendedSlotString .. ", " .. equip.slotNoId[extendSlotNo]
          elseif i > 1 then
            extendedSlotString = extendedSlotString .. ", " .. equip.slotNoId[extendSlotNo]
          end
        end
      end
      if 1 == equip.checkExtendedSlot then
        local selfSlotNo = itemSSW:getEquipSlotNo()
        equip.extendedSlotInfoArray[selfSlotNo] = selfSlotNo
        target.useLimit_extendedslot_value:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_EXTENDEDSLOT", "selfSlotNo", equip.slotNoId[selfSlotNo], "extendedSlotString", extendedSlotString))
        target.useLimit_extendedslot_value:SetShow(true)
        useLimitShow = true
      else
        target.useLimit_extendedslot_value:SetShow(false)
      end
    else
      local itemName = itemSSW:getName()
      local slotNoMax = itemSSW:getExtendedSlotCount()
      local extendedSlotString = ""
      local compareSlot = {}
      local servantKindType = ItemTooltip_UsableServantKind(itemSSW)
      if nil ~= servantKindType then
        for i = 1, slotNoMax do
          local extendSlotNo = itemSSW:getExtendedSlotIndex(i - 1)
          if slotNoMax ~= extendSlotNo then
            equip.extendedSlotInfoArray[extendSlotNo] = i
            equip.checkExtendedSlot = 1
            compareSlot[i] = extendSlotNo
            local compareCheck = false
            if 1 == i then
              extendedSlotString = extendedSlotString .. ", " .. servantKindTypeString[servantKindType][extendSlotNo]
            elseif i > 1 then
              extendedSlotString = extendedSlotString .. ", " .. servantKindTypeString[servantKindType][extendSlotNo]
            end
          end
        end
      end
      if 1 == equip.checkExtendedSlot then
        local selfSlotNo = itemSSW:getEquipSlotNo()
        equip.extendedSlotInfoArray[selfSlotNo] = selfSlotNo
        target.useLimit_extendedslot_value:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_EXTENDEDSLOT", "selfSlotNo", servantKindTypeString[servantKindType][selfSlotNo], "extendedSlotString", extendedSlotString))
        target.useLimit_extendedslot_value:SetShow(true)
        useLimitShow = true
      else
        target.useLimit_extendedslot_value:SetShow(false)
      end
    end
  end
  local isAllClass = true
  local classNameList
  for idx = 0, getCharacterClassCount() - 1 do
    local classType = getCharacterClassTypeByIndex(idx)
    local className = getCharacterClassName(classType)
    if nil ~= className and "" ~= className and " " ~= className then
      if itemSSW:get()._usableClassType:isOn(classType) then
        if nil == classNameList then
          classNameList = className
        else
          classNameList = classNameList .. ", " .. className
        end
      else
        isAllClass = false
      end
    end
  end
  if isAllClass or nil == classNameList then
    target.useLimit_class_value:SetShow(false)
    target.useLimit_class:SetShow(false)
  else
    useLimitShow = true
    target.useLimit_class_value:SetTextMode(UI_TM.eTextMode_AutoWrap)
    target.useLimit_class_value:SetShow(true)
    target.useLimit_class:SetShow(true)
    local isUsableClass = itemSSW:get()._usableClassType:isOn(classType)
    if isUsableClass == false then
      target.useLimit_class_value:SetFontColor(UI_color.C_FFF26A6A)
    else
      target.useLimit_class_value:SetFontColor(UI_color.C_FFC4BEBE)
    end
    if nil ~= classNameList then
      target.useLimit_class_value:SetText("- " .. classNameList .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_CLASSONLY"))
    else
      target.useLimit_class_value:SetText(" ")
    end
  end
  if not isSSW then
    if item:getExpirationDate():isIndefinite() then
      target.remainTime_value:SetShow(false)
      target.remainTime:SetShow(false)
    else
      local s64_remainingTime = getLeftSecond_s64(item:getExpirationDate())
      local fontColor = UI_color.C_FFC4BEBE
      local itemExpiration = item:getExpirationDate()
      local leftPeriod = FromClient_getTradeItemExpirationDate(itemExpiration, itemWrapper:getStaticStatus():get()._expirationPeriod)
      if not itemSSW:get():isCash() and itemSSW:isTradeAble() then
        target.remainTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_REMAINTIME_PRICEREMAIN"))
      else
        target.remainTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_REMAINTIME_REMAINTIME"))
      end
      if Defines.s64_const.s64_0 == s64_remainingTime then
        if not itemSSW:get():isCash() and itemSSW:isTradeAble() then
          target.remainTime_value:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_REMAIN_TIME") .. " (" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_MARKETPRICE") .. " : " .. leftPeriod / 10000 .. " %)")
        else
          target.remainTime_value:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_REMAIN_TIME"))
        end
        fontColor = UI_color.C_FFF26A6A
      elseif not itemSSW:get():isCash() and itemSSW:isTradeAble() then
        target.remainTime_value:SetText(convertStringFromDatetime(s64_remainingTime) .. " (" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_MARKETPRICE") .. " : " .. leftPeriod / 10000 .. " %)")
      else
        target.remainTime_value:SetText(convertStringFromDatetime(s64_remainingTime))
      end
      target.remainTime_value:SetFontColor(fontColor)
      target.remainTime_value:SetShow(true)
      target.remainTime:SetShow(true)
      useLimitShow = true
    end
  else
    target.remainTime_value:SetShow(false)
    target.remainTime:SetShow(false)
  end
  target.useLimit_category:SetShow(false)
  target.useLimit_panel:SetShow(useLimitShow)
  local attackShow = false
  local defenseShow = false
  local attackString = ""
  local minAttack = 0
  local maxAttack = 0
  for idx = 0, 2 do
    local currentMin = itemSSW:getMinDamage(idx)
    if minAttack < currentMin then
      minAttack = currentMin
    end
    local currentMax = itemSSW:getMaxDamage(idx)
    if maxAttack < currentMax then
      maxAttack = currentMax
    end
  end
  if 0 ~= maxAttack and 0 ~= minAttack then
    attackShow = true
  end
  if 1 == itemSSW:getItemType() and 36 == itemSSW:getEquipType() then
    minAttack = itemSSW:getMinDamage(0)
    maxAttack = itemSSW:getMaxDamage(0)
  end
  minAttack = minAttack + itemaddedDD
  maxAttack = maxAttack + itemaddedDD
  attackString = tostring(minAttack) .. " ~ " .. tostring(maxAttack)
  target.attack_value:SetText(attackString)
  target.attack_value:SetShow(attackShow)
  target.attack:SetShow(attackShow)
  target.att_Value = (maxAttack + minAttack) / 2
  local defenseString = ""
  local def_value = 0
  if item_type == 1 then
    for idx = 0, 2 do
      local currentdef_value = itemSSW:getDefence(idx) + itemaddedDV + itemaddedPV
      if 0 ~= currentdef_value then
        def_value = currentdef_value
      end
    end
  end
  if 0 ~= def_value then
    defenseShow = true
  end
  defenseString = tostring(def_value)
  target.defense_value:SetText(defenseString)
  target.defense_value:SetShow(defenseShow)
  target.defense:SetShow(defenseShow)
  target.def_Value = def_value
  local gotWeight = itemSSW:get()._weight
  local hit = 0
  local hitShow = false
  local hitString = ""
  for idx = 0, 2 do
    local currentHit = itemSSW:ToClient_getHit(idx)
    if hit < currentHit then
      hit = currentHit
    end
  end
  if 1 == itemSSW:getItemType() and 36 == itemSSW:getEquipType() then
    hit = itemSSW:ToClient_getHit(0)
  end
  hit = hit + itemaddedHit
  if 0 ~= hit then
    hitShow = true
  end
  hitString = tostring(hit)
  target._hit_value:SetText(hitString)
  target._hit_value:SetShow(hitShow)
  target._hit:SetShow(hitShow)
  local dv = 0
  local hdv = 0
  local dvShow = false
  local dvString = ""
  if item_type == 1 then
    for idx = 0, 2 do
      local currnetDv = itemSSW:ToClient_getDV(idx)
      if 0 ~= currnetDv then
        dv = currnetDv
      end
      local currentHDV = itemSSW:ToClient_getHDV(idx)
      if 0 ~= currentHDV then
        hdv = currentHDV
      end
    end
  end
  dv = dv + itemaddedDV
  if 0 ~= dv + hdv + itemaddedHDV then
    dvShow = true
  end
  if 0 ~= hdv + itemaddedHDV then
    dvString = tostring(dv) .. " (+" .. tostring(hdv + itemaddedHDV) .. ")"
  else
    dvString = tostring(dv)
  end
  target._dv_value:SetText(dvString)
  target._dv_value:SetShow(dvShow)
  target._dv:SetShow(dvShow)
  local pv = 0
  local hpv = 0
  local pvShow = false
  local pvString = ""
  if item_type == 1 then
    for idx = 0, 2 do
      local currentPv = itemSSW:ToClient_getPV(idx)
      if 0 ~= currentPv then
        pv = currentPv
      end
      local currentHPv = itemSSW:ToClient_getHPV(idx)
      if 0 ~= currentHPv then
        hpv = currentHPv
      end
    end
  end
  pv = pv + itemaddedPV
  if 0 ~= pv + hpv + itemaddedHPV then
    pvShow = true
  end
  if 0 ~= hpv + itemaddedHPV then
    pvString = tostring(pv) .. " (+" .. tostring(hpv + itemaddedHPV) .. ")"
  else
    pvString = tostring(pv)
  end
  target._pv_value:SetText(pvString)
  target._pv_value:SetShow(pvShow)
  target._pv:SetShow(pvShow)
  if gotWeight > 99 then
    target.weight:SetShow(true)
    target.weight_value:SetShow(true)
    local calcWeight = gotWeight / 10000
    target.weight_value:SetText(string.format("%.2f", calcWeight) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT"))
  else
    target.weight:SetShow(true)
    target.weight_value:SetShow(true)
    local calcWeight = gotWeight / 10000
    target.weight_value:SetText(string.format("%.2f", calcWeight) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT"))
  end
  target.wei_Value = gotWeight / 10000
  if itemSSW:get():isCash() then
    target.weight:SetShow(false)
    target.weight_value:SetShow(false)
  end
  if Panel_Tooltip_Item_equipped:GetShow() then
    local _weightPoint = 0
    local _offencePoint = 0
    local _defencePoint = 0
    if 0 == normalTooltip.att_Value then
      _offencePoint = 0
    else
      _offencePoint = normalTooltip.att_Value - equippedTooltip.att_Value
    end
    if 0 == normalTooltip.def_Value then
      _defencePoint = 0
    else
      _defencePoint = normalTooltip.def_Value - equippedTooltip.def_Value
    end
    _weightPoint = normalTooltip.wei_Value - equippedTooltip.wei_Value
    if _weightPoint > 0 then
      _weightPoint = "<PAColor0xFFFF0000>\226\150\178" .. string.format("%.2f", _weightPoint) .. "<PAOldColor>"
    elseif _weightPoint < 0 then
      _weightPoint = "<PAColor0xFFFFCE22>\226\150\188" .. string.format("%.2f", _weightPoint * -1) .. "<PAOldColor>"
    end
    if 0 ~= _offencePoint and 0 == _defencePoint then
      if _offencePoint > 0 then
        _offencePoint = "<PAColor0xFFFFCE22>\226\150\178" .. _offencePoint .. "<PAOldColor>"
      elseif _offencePoint < 0 then
        _offencePoint = "<PAColor0xFFFF0000>\226\150\188" .. _offencePoint * -1 .. "<PAOldColor>"
      end
      attackString = "(" .. _offencePoint .. " )"
      normalTooltip.attack_diffValue:SetText(attackString)
      normalTooltip.attack_diffValue:SetShow(true)
      normalTooltip.defense_diffValue:SetText("")
      normalTooltip.defense_diffValue:SetShow(false)
    elseif 0 ~= _offencePoint and 0 ~= _defencePoint then
      if _offencePoint > 0 then
        _offencePoint = "<PAColor0xFFFFCE22>\226\150\178" .. _offencePoint .. "<PAOldColor>"
      elseif _offencePoint < 0 then
        _offencePoint = "<PAColor0xFFFF0000>\226\150\188" .. _offencePoint * -1 .. "<PAOldColor>"
      end
      if _defencePoint > 0 then
        _defencePoint = "<PAColor0xFFFFCE22>\226\150\178" .. _defencePoint .. "<PAOldColor>"
      elseif _defencePoint < 0 then
        _defencePoint = "<PAColor0xFFFF0000>\226\150\188" .. _defencePoint * -1 .. "<PAOldColor>"
      end
      attackString = "(" .. _offencePoint .. " )"
      normalTooltip.attack_diffValue:SetText(attackString)
      defenseString = "(" .. _defencePoint .. " )"
      normalTooltip.defense_diffValue:SetText(defenseString)
      normalTooltip.attack_diffValue:SetShow(true)
      normalTooltip.defense_diffValue:SetShow(true)
    elseif 0 == _offencePoint and 0 ~= _defencePoint then
      if _defencePoint > 0 then
        _defencePoint = "<PAColor0xFFFFCE22>\226\150\178" .. _defencePoint .. "<PAOldColor>"
      elseif _defencePoint < 0 then
        _defencePoint = "<PAColor0xFFFF0000>\226\150\188" .. _defencePoint * -1 .. "<PAOldColor>"
      end
      defenseString = "(" .. _defencePoint .. " )"
      normalTooltip.defense_diffValue:SetText(defenseString)
      normalTooltip.attack_diffValue:SetText("")
      normalTooltip.attack_diffValue:SetShow(false)
      normalTooltip.defense_diffValue:SetShow(true)
    else
      normalTooltip.attack_diffValue:SetShow(false)
      normalTooltip.defense_diffValue:SetShow(false)
    end
    if 0 ~= _weightPoint then
      normalTooltip.weight_diffValue:SetText(" (" .. _weightPoint .. " )")
      normalTooltip.weight_diffValue:SetShow(true)
    end
    if 0 == normalTooltip.att_Value and 0 == normalTooltip.def_Value then
      normalTooltip.attack_diffValue:SetShow(false)
      normalTooltip.defense_diffValue:SetShow(false)
      normalTooltip.weight_diffValue:SetShow(false)
    end
  else
    normalTooltip.attack_diffValue:SetShow(false)
    normalTooltip.defense_diffValue:SetShow(false)
    normalTooltip.weight_diffValue:SetShow(false)
  end
  local soketCount = 0
  if false == itemSSW:get():getEnchant():empty() then
    soketCount = itemSSW:get():getEnchant()._socketCount
  end
  local itemEnchantSSW
  if not isSSW then
    soketCount = item:getUsableItemSocketCount()
  end
  local socketMaxCount = ToClient_GetMaxItemSocketCount()
  for jewelIdx = 0, 5 do
    if jewelIdx < socketMaxCount - 1 then
      if not isSSW then
        itemEnchantSSW = itemWrapper:getPushedItem(jewelIdx)
      else
        itemEnchantSSW = nil
        if isItemWrapper or nil ~= chattingLinkedItem then
          local pushedKey
          if isItemWrapper then
            pushedKey = item:getPushedKey(jewelIdx)
          elseif nil ~= chattingLinkedItem then
            pushedKey = chattingLinkedItem:getPushedKey(jewelIdx)
          end
          if pushedKey ~= nil and pushedKey:get() > 0 then
            itemEnchantSSW = getItemEnchantStaticStatus(pushedKey)
          end
        end
      end
      if target.mainPanel ~= Panel_Tooltip_Item_equipped and nil ~= Panel_Tooltip_Item_DataObject.itemMarket then
        itemEnchantSSW = nil
      end
      if jewelIdx >= soketCount then
        target.soketName[jewelIdx + 1]:SetShow(false)
        target.soketEffect[jewelIdx + 1]:SetShow(false)
        target.soketSlot[jewelIdx + 1]:SetShow(false)
      elseif nil ~= itemEnchantSSW then
        target.soketName[jewelIdx + 1]:SetShow(true)
        target.soketEffect[jewelIdx + 1]:SetShow(true)
        target.soketSlot[jewelIdx + 1]:SetShow(true)
        target.soketName[jewelIdx + 1]:SetText(itemEnchantSSW:getName())
        target.soketSlot[jewelIdx + 1]:ChangeTextureInfoName("icon/" .. itemEnchantSSW:getIconPath())
        local x1, y1, x2, y2 = setTextureUV_Func(target.soketSlot[jewelIdx + 1], 0, 0, 42, 42)
        target.soketSlot[jewelIdx + 1]:getBaseTexture():setUV(x1, y1, x2, y2)
        target.soketSlot[jewelIdx + 1]:setRenderTexture(target.soketSlot[jewelIdx + 1]:getBaseTexture())
        local skillSSW = itemEnchantSSW:getSkillByIdx(classType)
        if nil == skillSSW then
          target.soketEffect[jewelIdx + 1]:SetText(" ")
        else
          local buffList = ""
          for buffIdx = 0, skillSSW:getBuffCount() - 1 do
            local desc = skillSSW:getBuffDescription(buffIdx)
            if nil == desc or "" == desc then
              break
            end
            if nil == buffList or "" == buffList then
              buffList = desc
            else
              buffList = buffList .. " / " .. desc
            end
          end
          target.soketEffect[jewelIdx + 1]:SetText(buffList)
        end
      else
        target.soketName[jewelIdx + 1]:SetShow(true)
        target.soketEffect[jewelIdx + 1]:SetShow(true)
        target.soketSlot[jewelIdx + 1]:SetShow(true)
        target.soketName[jewelIdx + 1]:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EMPTY_SLOT"))
        target.soketEffect[jewelIdx + 1]:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EMPTY_SLOT_DESC"))
        target.soketSlot[jewelIdx + 1]:ChangeTextureInfoName(" ")
      end
    else
      target.soketName[jewelIdx + 1]:SetShow(false)
      target.soketEffect[jewelIdx + 1]:SetShow(false)
      target.soketSlot[jewelIdx + 1]:SetShow(false)
    end
  end
  target.soketOption_panel:SetShow(0 ~= soketCount)
  target.useLimit_Exp:SetShow(false)
  target.useLimit_Exp_gage:SetShow(false)
  target.useLimit_Exp_gage_value:SetShow(false)
  target.useLimit_Exp_value:SetShow(false)
  if isGrowthContents or isTotemContents or true == isQuestBookContents then
    if nil ~= itemWrapper and (32 == itemSSW:get():getContentsEventType() or 37 == itemSSW:get():getContentsEventType()) then
      local alchemyStoneType = itemWrapper:getStaticStatus():get()._contentsEventParam1
      if alchemyStoneType < 3 then
        local alchemystoneExp = itemWrapper:getExperience() / 10000
        target.useLimit_Exp:SetShow(true)
        target.useLimit_Exp_gage:SetShow(true)
        target.useLimit_Exp_gage_value:SetShow(true)
        target.useLimit_Exp_value:SetShow(true)
        target.useLimit_Exp_value:SetText(string.format("%.2f", alchemystoneExp) .. "%")
        target.useLimit_Exp_gage_value:SetCurrentProgressRate(alchemystoneExp)
        target.useLimit_Exp_gage_value:SetProgressRate(alchemystoneExp)
        target.useLimit_Exp_gage_value:SetAniSpeed(0)
      end
    elseif nil ~= itemWrapper and CppEnums.ContentsEventType.ContentsType_QuestBook == itemSSW:get():getContentsEventType() then
      local dstExp = itemWrapper:getExperience() / 15000
      target.useLimit_Exp:SetShow(true)
      target.useLimit_Exp_gage:SetShow(true)
      target.useLimit_Exp_gage_value:SetShow(true)
      target.useLimit_Exp_value:SetShow(true)
      target.useLimit_Exp_value:SetText(string.format("%.2f", dstExp) .. "%")
      target.useLimit_Exp_gage_value:SetCurrentProgressRate(dstExp)
      target.useLimit_Exp_gage_value:SetProgressRate(dstExp)
      target.useLimit_Exp_gage_value:SetAniSpeed(0)
    end
  end
  local maxEndurance = 32767
  local dynamicMaxEndurance = 32767
  if false == itemSSW:get():isUnbreakable() then
    maxEndurance = itemSSW:get():getMaxEndurance()
  end
  if not isSSW then
    dynamicMaxEndurance = item:getMaxEndurance()
  end
  local currentEndurance = maxEndurance
  if not isSSW then
    currentEndurance = item:getEndurance()
  end
  local calcEndurance = currentEndurance / maxEndurance
  local calcDynamicEndurance = dynamicMaxEndurance / maxEndurance
  target.useLimit_endurance_gage_value:SetCurrentProgressRate(calcEndurance * 100)
  target.useLimit_endurance_gage_value:SetProgressRate(calcEndurance * 100)
  target.useLimit_endurance_gage_value:SetAniSpeed(0)
  target.useLimit_dynamic_endurance_gage_value:SetCurrentProgressRate(calcDynamicEndurance * 100)
  target.useLimit_dynamic_endurance_gage_value:SetProgressRate(calcDynamicEndurance * 100)
  target.useLimit_dynamic_endurance_gage_value:SetAniSpeed(0)
  if 32767 ~= dynamicMaxEndurance then
    target.useLimit_endurance_value:SetText(currentEndurance .. " / " .. dynamicMaxEndurance .. "  [" .. maxEndurance .. "]")
    target.useLimit_endurance:SetShow(true)
    target.useLimit_endurance_value:SetShow(true)
    target.useLimit_endurance_gage_value:SetShow(true)
    target.useLimit_dynamic_endurance_gage_value:SetShow(true)
    target.useLimit_endurance_gage:SetShow(true)
  elseif 32767 ~= maxEndurance then
    target.useLimit_endurance_value:SetText(currentEndurance .. " / " .. maxEndurance)
    target.useLimit_endurance:SetShow(true)
    target.useLimit_endurance_value:SetShow(true)
    target.useLimit_endurance_gage_value:SetShow(true)
    target.useLimit_dynamic_endurance_gage_value:SetShow(false)
    target.useLimit_endurance_gage:SetShow(true)
  else
    target.useLimit_endurance:SetShow(false)
    target.useLimit_endurance_value:SetShow(false)
    target.useLimit_endurance_gage_value:SetShow(false)
    target.useLimit_dynamic_endurance_gage_value:SetShow(false)
    target.useLimit_endurance_gage:SetShow(false)
  end
  if Panel_House_InstallationMode:GetShow() then
    target.useLimit_endurance:SetShow(false)
    target.useLimit_endurance_value:SetShow(false)
    target.useLimit_endurance_gage_value:SetShow(false)
    target.useLimit_dynamic_endurance_gage_value:SetShow(false)
    target.useLimit_endurance_gage:SetShow(false)
  end
  local checkEnduranceShowItem = function(itemKey)
    if 17591 == itemKey or 17592 == itemKey or 17596 == itemKey or 17612 == itemKey or 17613 == itemKey or 17669 == itemKey or 570001 == itemKey or 570002 == itemKey or 18861 == itemKey or 18862 == itemKey then
      return true
    else
      return false
    end
  end
  if nil ~= itemWrapper then
    local isCash = itemWrapper:getStaticStatus():get():isCash()
    if true == isCash and false == checkEnduranceShowItem(itemSSW:get()._key:getItemKey()) then
      target.useLimit_endurance:SetShow(false)
      target.useLimit_endurance_value:SetShow(false)
      target.useLimit_endurance_gage_value:SetShow(false)
      target.useLimit_dynamic_endurance_gage_value:SetShow(false)
      target.useLimit_endurance_gage:SetShow(false)
    end
  end
  if nil ~= itemSSW then
    local isCash = itemSSW:get():isCash()
    local balksCount = itemSSW:getExtractionCount_s64()
    local cronsCount = itemSSW:getCronCount_s64()
    if true == isCash and false == checkEnduranceShowItem(itemSSW:get()._key:getItemKey()) then
      target.useLimit_endurance:SetShow(false)
      target.useLimit_endurance_value:SetShow(false)
      target.useLimit_endurance_gage_value:SetShow(false)
      target.useLimit_dynamic_endurance_gage_value:SetShow(false)
      target.useLimit_endurance_gage:SetShow(false)
    end
    if false == isCash and nil ~= balksCount and toInt64(0, 0) ~= balksCount and nil ~= cronsCount and toInt64(0, 0) ~= cronsCount then
      target.useLimit_endurance:SetShow(false)
      target.useLimit_endurance_value:SetShow(false)
      target.useLimit_endurance_gage_value:SetShow(false)
      target.useLimit_dynamic_endurance_gage_value:SetShow(false)
      target.useLimit_endurance_gage:SetShow(false)
    end
  end
  target.enchantDifficulty:SetShow(false)
  if nil ~= itemSSW then
    local enchantDifficulty = itemSSW:get():getEnchantDifficulty()
    if enchantDifficulty > __eEnchantDifficulty_None and not _ContentsGroup_RenewUI then
      target.enchantDifficulty:SetShow(true)
      if __eEnchantDifficulty_Easy == enchantDifficulty then
        target.enchantDifficulty:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ENCHANTDIFFICULTY_EASY"))
      elseif __eEnchantDifficulty_Normal == enchantDifficulty then
        target.enchantDifficulty:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ENCHANTDIFFICULTY_NORMAL"))
      elseif __eEnchantDifficulty_Hard == enchantDifficulty or __eEnchantDifficulty_NotExtractHard == enchantDifficulty then
        target.enchantDifficulty:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ENCHANTDIFFICULTY_HARD"))
      end
    end
  end
  target.soulCollector:SetShow(false)
  if true == Panel_Tooltip_Item_DataObject.inventory and nil ~= itemWrapper then
    local isSoulCollecTor = itemWrapper:isSoulCollector()
    if true == isSoulCollecTor then
      target.soulCollector:SetShow(true)
      local countSoul
      if itemWrapper:getSoulCollectorMaxCount() < itemWrapper:getSoulCollectorCount() then
        countSoul = itemWrapper:getSoulCollectorMaxCount()
      else
        countSoul = itemWrapper:getSoulCollectorCount()
      end
      target.soulCollector:SetText("- " .. PAGetString(Defines.StringSheet_GAME, "LUA_SOULCOLLECTOR_STATE") .. " : " .. tostring(countSoul) .. "/" .. tostring(itemWrapper:getSoulCollectorMaxCount()))
    end
  end
  target.mainPanel:SetSize(target.mainPanel:GetSizeX(), target.panelSize - 30 * (6 - soketCount - 1))
  target.soketOption_panel:SetSize(target.soketOption_panel:GetSizeX(), target.socketSize - 30 * (6 - soketCount))
  target.itemProducedPlace:ComputePos()
  target.itemDescription:ComputePos()
  target.itemPrice_panel:ComputePos()
  target.itemPrice_transportBuy:ComputePos()
  target.itemPrice_transportBuy_value:ComputePos()
  target.itemPrice_storeSell:ComputePos()
  target.itemPrice_storeSell_value:ComputePos()
  local isNodeFreeTrade = itemSSW:get():isNodeFreeTrade()
  if true == itemSSW:get():isForJustTrade() and not isSSW then
    if isNodeFreeTrade then
      target.itemProducedPlace:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PRODUCT_PLACE") .. " : " .. itemWrapper:getProductionRegion())
    else
      local nodeLevel = ToClient_GetNodeLevel(itemWrapper:getProductionRegionKey())
      if nodeLevel >= 1 then
        target.itemProducedPlace:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PRODUCT_PLACE") .. " : " .. itemWrapper:getProductionRegion() .. " (" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_LINK") .. ")")
      else
        target.itemProducedPlace:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PRODUCT_PLACE") .. " : " .. itemWrapper:getProductionRegion() .. " (" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOLINK") .. ")")
      end
    end
  else
    target.itemProducedPlace:SetText("")
  end
  target.itemDescription:SetTextMode(UI_TM.eTextMode_AutoWrap)
  target.itemDescription:SetAutoResize(true)
  local _desc = PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_DESC_TITLE") .. " " .. itemSSW:getDescription()
  if isNodeFreeTrade then
    _desc = _desc .. " " .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TOOLTIP_ITEM_NODEFREETRADE_DESC")
  end
  if item_type == 2 and true == itemSSW:get():isForJustTrade() then
    _desc = _desc .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_DESC_TRADEITEM")
  end
  if "" ~= itemSSW:getEnchantDescription() then
    _desc = _desc .. [[


- ]] .. itemSSW:getEnchantDescription()
  end
  target.itemDescription:SetText(_desc)
  if _ContentsGroup_RenewUI then
    target.itemDescription:SetShow(false)
  end
  local isExchangeItem = itemSSW:isExchangeItem()
  local exchangeDesc = ""
  if isExchangeItem and not _ContentsGroup_RenewUI then
    target.exchangeTitle:SetShow(true)
    target.exchangeDesc:SetShow(true)
    target.exchangeDesc:SetText(itemSSW:getExchangeDescription())
  else
    target.exchangeTitle:SetShow(false)
    target.exchangeDesc:SetShow(false)
    target.exchangeDesc:SetText("")
  end
  local _const = Defines.s64_const
  local isTradeItem = itemSSW:isTradeAble()
  if isTradeItem == true and not isSSW then
    if item:getBuyingPrice_s64() > _const.s64_0 then
      target.itemPrice_transportBuy_value:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_AUCTION_GOLDTEXT") .. " " .. tostring(makeDotMoney(item:getBuyingPrice_s64())))
    else
      target.itemPrice_transportBuy_value:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOTHING"))
    end
    target.itemPrice_transportBuy:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_BUY_PRICE") .. " : ")
    target.itemPrice_transportBuy:SetFontColor(4287137928)
    target.itemPrice_transportBuy:SetShow(true)
    target.itemPrice_transportBuy_value:SetShow(true)
    target.itemPrice_panel:SetSize(target.itemPrice_panel:GetSizeX(), 50)
    target.itemPrice_transportBuy_value:SetSpanSize(target.itemPrice_transportBuy:GetTextSizeX() + 20, 0)
  else
    target.itemPrice_transportBuy:SetText("")
    target.itemPrice_transportBuy:SetFontColor(4290733156)
    target.itemPrice_transportBuy:SetShow(true)
    target.itemPrice_transportBuy_value:SetShow(false)
    target.itemPrice_panel:SetSize(target.itemPrice_panel:GetSizeX(), 25)
    target.itemPrice_transportBuy_value:SetSpanSize(target.itemPrice_transportBuy:GetTextSizeX() + 20, 0)
  end
  local s64_originalPrice = itemSSW:get()._originalPrice_s64
  local s64_sellPrice = itemSSW:get()._sellPriceToNpc_s64
  if isTradeItem then
    target.itemPrice_storeSell:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_ORIGINAL_PRICE") .. ":")
    if s64_originalPrice > _const.s64_0 and 0 == enchantLevel then
      target.itemPrice_storeSell_value:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_AUCTION_GOLDTEXT") .. " " .. tostring(makeDotMoney(s64_originalPrice)))
      target.itemPrice_storeSell_value:SetFontColor(4292726146)
    else
      target.itemPrice_storeSell_value:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOT_SELLING_ITEM"))
      target.itemPrice_storeSell_value:SetFontColor(4290733156)
    end
  else
    target.itemPrice_storeSell:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_SELL_PRICE") .. " : ")
    if s64_sellPrice > _const.s64_0 and 0 == enchantLevel then
      target.itemPrice_storeSell_value:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_AUCTION_GOLDTEXT") .. " " .. tostring(makeDotMoney(s64_sellPrice)))
      target.itemPrice_storeSell_value:SetFontColor(4292726146)
    else
      target.itemPrice_storeSell_value:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOT_SELLING_ITEM"))
      target.itemPrice_storeSell_value:SetFontColor(4290733156)
    end
  end
  target.itemPrice_storeSell_value:SetSpanSize(target.itemPrice_storeSell:GetTextSizeX() + 20, 0)
  local elementBiggap = 10
  local elementgap = 2
  local TooltipYPos = 10
  if target.mainPanel == Panel_Tooltip_Item_equipped then
  end
  target.itemType:SetPosY(8)
  target.dying:SetPosY(50 + changeItemNamePos)
  local function showPosisionSetting(target, attackShow, defenseShow, hitShow, dvShow, pvShow)
    local index = -1
    local bottomTarget = 0
    local stringPos = 31
    local stringInterval = 22
    local valuePos = 22
    local valueInterval = 22
    local resultStringPos = 0
    local resultValuePos = 0
    if true == attackShow then
      index = index + 1
      bottomTarget = 1
      resultStringPos = stringPos + stringInterval * index
      resultValuePos = valuePos + valueInterval * index
      target.attack:SetPosY(resultStringPos + changeItemNamePos)
      target.attack_value:SetPosY(resultValuePos + changeItemNamePos)
    end
    if true == hitShow then
      index = index + 1
      bottomTarget = 2
      resultStringPos = stringPos + stringInterval * index
      resultValuePos = valuePos + valueInterval * index
      target._hit:SetPosY(resultStringPos + changeItemNamePos)
      target._hit_value:SetPosY(resultValuePos + changeItemNamePos)
    end
    if true == defenseShow then
      index = index + 1
      bottomTarget = 3
      resultStringPos = stringPos + stringInterval * index
      resultValuePos = valuePos + valueInterval * index
      target.defense:SetPosY(resultStringPos + changeItemNamePos)
      target.defense_value:SetPosY(resultValuePos + changeItemNamePos)
    end
    if true == dvShow then
      index = index + 1
      bottomTarget = 4
      resultStringPos = stringPos + stringInterval * index
      resultValuePos = valuePos + valueInterval * index
      target._dv:SetPosY(resultStringPos + changeItemNamePos)
      target._dv_value:SetPosY(resultValuePos + changeItemNamePos + 4)
      target._dv_value:SetPosX(target._dv:GetPosX() + target._dv:GetTextSizeX() + 10)
    end
    if true == pvShow then
      index = index + 1
      bottomTarget = 5
      resultStringPos = stringPos + stringInterval * index
      resultValuePos = valuePos + valueInterval * index
      target._pv:SetPosY(resultStringPos + changeItemNamePos)
      target._pv_value:SetPosY(resultValuePos + changeItemNamePos + 4)
      target._pv_value:SetPosX(target._pv:GetPosX() + target._pv:GetTextSizeX() + 10)
    end
    return bottomTarget
  end
  local bottomTarget = showPosisionSetting(target, attackShow, defenseShow, hitShow, dvShow, pvShow)
  if 0 == bottomTarget then
    target.itemIcon:SetPosY(30 + changeItemNamePos)
    local iconPosY = target.itemIcon:GetPosY()
    local iconSizeY = target.itemIcon:GetSizeY()
    target.weight:SetPosY(iconPosY + iconSizeY - 15)
    target.weight_value:SetPosY(iconPosY + iconSizeY - 15)
  else
    if 1 == bottomTarget then
      TooltipYPos = GetBottomPos(target.attack) + elementgap
    elseif 2 == bottomTarget then
      TooltipYPos = GetBottomPos(target._hit) + elementgap
    elseif 3 == bottomTarget then
      TooltipYPos = GetBottomPos(target.defense) + elementgap
    elseif 4 == bottomTarget then
      TooltipYPos = GetBottomPos(target._dv) + elementgap
    elseif 5 == bottomTarget then
      TooltipYPos = GetBottomPos(target._pv) + elementgap
    end
    local iconSizeY = target.itemIcon:GetSizeY()
    local iconPosY = (TooltipYPos - changeItemNamePos) * 0.5 - iconSizeY * 0.5 + changeItemNamePos + iconMovePos
    target.itemIcon:SetPosY(iconPosY + changeItemNamePos)
    target.weight:SetPosY(TooltipYPos)
    target.weight_value:SetPosY(TooltipYPos)
  end
  TooltipYPos = GetBottomPos(target.weight_value) + elementgap
  local itemiconPosY = GetBottomPos(target.itemIcon) + elementgap
  if TooltipYPos < itemiconPosY then
    TooltipYPos = itemiconPosY
  end
  local iconPosY = target.itemIcon:GetPosY()
  local iconSizeY = target.itemIcon:GetSizeY()
  local enchantSizeY = target.enchantLevel:GetSizeY()
  target.enchantLevel:SetPosY(iconPosY + iconSizeY * 0.5 - enchantSizeY * 0.5)
  if normalTooltip.attack_diffValue:GetShow() then
    normalTooltip.attack_diffValue:SetPosX(normalTooltip.attack_value:GetPosX() + normalTooltip.attack_value:GetTextSizeX() + 10)
    normalTooltip.attack_diffValue:SetPosY(normalTooltip.attack_value:GetPosY() + 7)
  end
  if normalTooltip.defense_diffValue:GetShow() then
    normalTooltip.defense_diffValue:SetPosX(normalTooltip.defense_value:GetPosX() + normalTooltip.defense_value:GetTextSizeX() + 10)
    normalTooltip.defense_diffValue:SetPosY(normalTooltip.defense_value:GetPosY() + 7)
  end
  if normalTooltip.weight_diffValue:GetShow() then
    normalTooltip.weight_diffValue:SetPosX(normalTooltip.weight_value:GetPosX() + normalTooltip.weight_value:GetTextSizeX() + 10)
    normalTooltip.weight_diffValue:SetPosY(normalTooltip.weight_value:GetPosY())
  end
  if target._txt_MaxEnchanter:GetShow() then
    target._txt_MaxEnchanter:SetPosY(TooltipYPos + 5)
    TooltipYPos = GetBottomPos(target._txt_MaxEnchanter) + elementgap
  end
  if target.isEnchantable:GetShow() then
    target.isEnchantable:SetPosY(TooltipYPos + 5)
    TooltipYPos = GetBottomPos(target.isEnchantable) + elementgap
  end
  if target._txt_repair:GetShow() then
    target._txt_repair:SetPosY(TooltipYPos)
    TooltipYPos = GetBottomPos(target._txt_repair) + elementgap
  end
  if target.isSealed:GetShow() then
    target.isSealed:SetPosY(TooltipYPos + 5)
    TooltipYPos = GetBottomPos(target.isSealed) + elementgap
  end
  if target.bindType:GetShow() then
    target.bindType:SetPosY(TooltipYPos)
    TooltipYPos = GetBottomPos(target.bindType) + elementgap
  end
  if target.cronStoneEnchant:GetShow() then
    target.cronStoneEnchant:SetPosY(TooltipYPos + 5)
    TooltipYPos = GetBottomPos(target.cronStoneEnchant, true)
    target.cronStoneValue:SetPosY(TooltipYPos + 5)
    TooltipYPos = GetBottomPos(target.cronStoneValue, true)
  end
  if target.personalTrade:GetShow() then
    target.personalTrade:SetPosY(TooltipYPos + 5)
    TooltipYPos = GetBottomPos(target.personalTrade) + elementgap
  end
  if target.enchantDifficulty:GetShow() then
    target.enchantDifficulty:SetPosY(TooltipYPos + 5)
    TooltipYPos = GetBottomPos(target.enchantDifficulty) + elementgap
  end
  if target.itemLock:GetShow() then
    target.itemLock:SetPosY(TooltipYPos)
    TooltipYPos = GetBottomPos(target.itemLock) + elementgap
  end
  if target.soulCollector:GetShow() then
    target.soulCollector:SetPosY(TooltipYPos)
    TooltipYPos = GetBottomPos(target.soulCollector) + elementgap
  end
  if target.tradeInfo_Panel:GetShow() then
    target.tradeInfo_Panel:SetPosY(TooltipYPos)
    target.tradeInfo_Title:SetPosY(TooltipYPos + 5)
    target.tradeInfo_Value:SetPosY(TooltipYPos + target.tradeInfo_Title:GetSizeY() + 5)
    TooltipYPos = GetBottomPos(target.tradeInfo_Panel) + elementgap
  end
  if target.balksExtraction:GetShow() then
    target.balksExtraction:SetPosY(TooltipYPos)
    TooltipYPos = GetBottomPos(target.balksExtraction) + elementgap
  end
  if target.cronsExtraction:GetShow() then
    target.cronsExtraction:SetPosY(TooltipYPos - 5)
    TooltipYPos = GetBottomPos(target.cronsExtraction) + elementgap
  end
  if itemSSW:isEquipable() and itemSSW:isDyeable() then
    if target.useDyeColorTitle:GetShow() then
      target.useDyeColorTitle:SetPosY(TooltipYPos)
      TooltipYPos = GetBottomPos(target.useDyeColorTitle) + elementgap
    end
    local dyeingPartCount = 0
    if nil ~= itemWrapper then
      dyeingPartCount = itemWrapper:getDyeingPartCount()
    elseif nil ~= chattingLinkedItem then
      dyeingPartCount = chattingLinkedItem:getDyeingPartCount()
    end
    if dyeingPartCount > 0 then
      for dyeingPart_Index = 0, dyeingPartCount - 1 do
        target.useDyeColorIcon_Part[dyeingPart_Index]:SetPosY(TooltipYPos)
        if 0 == dyeingPart_Index then
          target.useDyeColorIcon_Part[dyeingPart_Index]:SetPosX(15)
        else
          target.useDyeColorIcon_Part[dyeingPart_Index]:SetPosX(target.useDyeColorIcon_Part[dyeingPart_Index - 1]:GetPosX() + target.useDyeColorIcon_Part[dyeingPart_Index]:GetSizeX() + 6)
        end
      end
      TooltipYPos = GetBottomPos(target.useDyeColorIcon_Part[0]) + elementgap + 10
    end
  elseif itemSSW:isEquipable() and false == itemSSW:isDyeable() then
    target.useDyeColorTitle:SetShow(true)
    target.useDyeColorTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_DYE_DYEIMPOSSIBLE"))
    if target.useDyeColorTitle:GetShow() then
      target.useDyeColorTitle:SetPosY(TooltipYPos)
      TooltipYPos = GetBottomPos(target.useDyeColorTitle) + elementgap
    end
  end
  if useLimitShow == true then
    target.useLimit_category:SetShow(true)
    if target.useLimit_category:GetShow() then
      target.useLimit_panel:SetPosY(TooltipYPos)
      target.useLimit_category:SetPosY(TooltipYPos)
      TooltipYPos = TooltipYPos + elementgap
      if target.useLimit_class_value:GetShow() then
        target.useLimit_class_value:SetPosY(TooltipYPos + 4)
        TooltipYPos = GetBottomPos(target.useLimit_class_value) + elementgap
      end
      if target.useLimit_level_value:GetShow() then
        target.useLimit_level_value:SetPosY(TooltipYPos + 4)
        TooltipYPos = GetBottomPos(target.useLimit_level_value) + elementgap
      end
      if target.useLimit_extendedslot_value:GetShow() then
        target.useLimit_extendedslot_value:SetPosY(TooltipYPos)
        TooltipYPos = GetBottomPos(target.useLimit_extendedslot_value) + elementgap
      end
      if target.remainTime:GetShow() then
        target.remainTime:SetPosY(TooltipYPos)
        target.remainTime_value:SetPosY(TooltipYPos)
        TooltipYPos = GetBottomPos(target.remainTime_value) + elementgap
        local s64_remainingTime = getLeftSecond_s64(item:getExpirationDate())
        if Defines.s64_const.s64_0 == s64_remainingTime then
          target.expireIcon_end:SetShow(true)
          target.expireIcon_end:SetPosX(target.remainTime_value:GetPosX() - 15)
          target.expireIcon_end:SetPosY(TooltipYPos - 17)
        elseif Int64toInt32(s64_remainingTime) <= 7200 then
          target.expireIcon_red:SetShow(true)
          target.expireIcon_red:SetPosX(target.remainTime_value:GetPosX() - 15)
          target.expireIcon_red:SetPosY(TooltipYPos - 17)
        else
          target.expireIcon_white:SetShow(true)
          target.expireIcon_white:SetPosX(target.remainTime_value:GetPosX() - 15)
          target.expireIcon_white:SetPosY(TooltipYPos - 17)
        end
      else
        target.expireIcon_white:SetShow(false)
        target.expireIcon_red:SetShow(false)
        target.expireIcon_end:SetShow(false)
      end
      target.useLimit_panel:SetSize(target.useLimit_panel:GetSizeX(), TooltipYPos - target.useLimit_panel:GetPosY() + elementBiggap / 2)
      TooltipYPos = GetBottomPos(target.useLimit_panel) + elementBiggap / 2
    end
  end
  if target.soketOption_panel:GetShow() then
    target.soketOption_panel:SetPosY(TooltipYPos)
    TooltipYPos = TooltipYPos + elementgap
    for idx = 1, 6 do
      if target.soketSlot[idx]:GetShow() then
        target.soketSlot[idx]:SetPosY(TooltipYPos + 1)
        target.soketName[idx]:SetPosY(TooltipYPos)
        TooltipYPos = GetBottomPos(target.soketName[idx]) + elementgap
        target.soketEffect[idx]:SetPosY(TooltipYPos)
        TooltipYPos = GetBottomPos(target.soketEffect[idx]) + elementgap
        TooltipYPos = TooltipYPos + elementBiggap
      end
    end
    target.soketOption_panel:SetSize(target.soketOption_panel:GetSizeX(), TooltipYPos - target.soketOption_panel:GetPosY() - elementBiggap / 2)
    TooltipYPos = GetBottomPos(target.soketOption_panel) + elementBiggap
  end
  if true == itemSSW:get():isForJustTrade() and not isSSW then
    target.itemProducedPlace:SetPosY(TooltipYPos)
    TooltipYPos = GetBottomPos(target.itemProducedPlace) + elementBiggap
  end
  if normalTooltip == target and target.bagSize:GetShow() then
    target.bagSize:SetPosY(TooltipYPos)
    TooltipYPos = GetBottomPos(target.bagSize)
    if target.equipmentInBag:GetShow() then
      target.equipmentInBag:SetPosY(TooltipYPos)
      TooltipYPos = GetBottomPos(target.equipmentInBag) + elementBiggap
    end
  end
  if target.itemDescription:GetShow() and false == _ContentsGroup_RenewUI then
    target.itemDescription:SetPosY(TooltipYPos)
    TooltipYPos = GetBottomPos(target.itemDescription) + elementgap
  end
  if target.exchangeTitle:GetShow() then
    target.exchangeTitle:SetPosY(TooltipYPos)
    TooltipYPos = GetBottomPos(target.exchangeTitle) + elementgap
    target.exchangeDesc:SetPosY(TooltipYPos)
    TooltipYPos = GetBottomPos(target.exchangeDesc) + elementgap
  end
  if target.equipSlotName:GetShow() then
    target.equipSlotName:SetPosY(TooltipYPos)
    TooltipYPos = GetBottomPos(target.equipSlotName) + elementgap
  end
  target.itemPrice_panel:SetPosY(TooltipYPos)
  TooltipYPos = TooltipYPos + elementgap * 2
  target.itemPrice_transportBuy:SetPosY(TooltipYPos + 20)
  target.itemPrice_transportBuy_value:SetPosY(TooltipYPos + 20)
  target.itemPrice_storeSell:SetPosY(TooltipYPos)
  target.itemPrice_storeSell_value:SetPosY(TooltipYPos)
  TooltipYPos = GetBottomPos(target.itemPrice_storeSell_value) + elementBiggap
  TooltipYPos = GetBottomPos(target.itemPrice_panel) + elementBiggap / 2
  if target.useLimit_Exp:GetShow() then
    target.useLimit_Exp:SetPosY(TooltipYPos + elementgap)
    target.useLimit_Exp_gage:SetPosY(TooltipYPos + 15)
    target.useLimit_Exp_gage_value:SetPosY(TooltipYPos + 20)
    target.useLimit_Exp_value:SetPosY(TooltipYPos + 15 + (target.useLimit_Exp_gage:GetSizeY() - target.useLimit_Exp_value:GetSizeY()) / 2)
    TooltipYPos = GetBottomPos(target.useLimit_Exp) + elementBiggap
  end
  if target.useLimit_endurance:GetShow() then
    target.useLimit_endurance:SetPosY(TooltipYPos + elementgap)
    target.useLimit_endurance_gage:SetPosY(TooltipYPos + 15)
    target.useLimit_endurance_value:SetPosY(TooltipYPos + 15)
    target.useLimit_endurance_gage_value:SetPosY(TooltipYPos + 15 + (target.useLimit_endurance_gage:GetSizeY() - target.useLimit_endurance_gage_value:GetSizeY()) / 2)
    target.useLimit_dynamic_endurance_gage_value:SetPosY(TooltipYPos + 15 + (target.useLimit_endurance_gage:GetSizeY() - target.useLimit_dynamic_endurance_gage_value:GetSizeY()) / 2)
    TooltipYPos = GetBottomPos(target.useLimit_endurance) + elementBiggap
  end
  target.itemLockNotify:SetShow(false)
  if normalTooltip == target and true == Panel_Tooltip_Item_DataObject.inventory then
    if (isGameTypeKorea() or isGameTypeJapan() or isGameTypeRussia() or isGameTypeEnglish() or isGameTypeTaiwan()) and getContentsServiceType() ~= CppEnums.ContentsServiceType.eContentsServiceType_CBT then
      if false == itemSSW:get():isCash() and false == itemWrapper:isSoulCollector() and not _ContentsGroup_RenewUI then
        target.productNotify:SetShow(true)
      else
        target.productNotify:SetShow(false)
      end
    else
      target.productNotify:SetShow(false)
    end
    if true == isItemLock and not itemSSW:get():isCash() then
      target.itemLockNotify:SetShow(false)
      if false == itemWrapper:getStaticStatus():isStackable() then
        if ToClient_Inventory_CheckItemLock(Inventory_GetToolTipItemSlotNo()) then
          if false == itemWrapper:getStaticStatus():get()._hideFromNote then
            target.productNotify:SetText(PAGetString(Defines.StringSheet_RESOURCE, "UI_TOOLTIP_ITEM_SHIFTCLICK") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TOOLTIP_ITEM_SHIFTRCLICK_UNLOCK"))
          else
            target.productNotify:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TOOLTIP_ITEM_SHIFTRCLICK_UNLOCK"))
          end
        elseif false == itemWrapper:getStaticStatus():get()._hideFromNote then
          target.productNotify:SetText(PAGetString(Defines.StringSheet_RESOURCE, "UI_TOOLTIP_ITEM_SHIFTCLICK") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TOOLTIP_ITEM_SHIFTRCLICK_LOCK"))
        else
          target.productNotify:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TOOLTIP_ITEM_SHIFTRCLICK_LOCK"))
        end
      elseif false == itemWrapper:getStaticStatus():get()._hideFromNote then
        target.productNotify:SetText(PAGetString(Defines.StringSheet_RESOURCE, "UI_TOOLTIP_ITEM_SHIFTCLICK"))
      else
        target.productNotify:SetShow(false)
      end
    end
  else
    target.productNotify:SetShow(false)
    target.itemLockNotify:SetShow(false)
  end
  target.recoveryDesc:SetShow(false)
  if not itemSSW:get():isCash() then
    if itemSSW:isEquipable() and 0 < itemSSW:getRecoveryMaxEndurance() and dynamicMaxEndurance <= 50 and 16145 ~= itemSSW:get()._key:getItemKey() and not _ContentsGroup_RenewUI then
      target.recoveryDesc:SetShow(true)
      target.recoveryDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_RECOVOERYDESC"))
    else
      target.recoveryDesc:SetShow(false)
    end
  end
  if itemSSW:isStackable() then
  end
  if target.productNotify:GetShow() then
    target.productNotify:SetPosY(TooltipYPos + elementgap)
    TooltipYPos = GetBottomPos(target.productNotify) + elementgap
  end
  if target.itemLockNotify:GetShow() then
    target.itemLockNotify:SetPosY(TooltipYPos + elementgap)
    TooltipYPos = GetBottomPos(target.itemLockNotify) + elementgap
  end
  if target.recoveryDesc:GetShow() then
    target.recoveryDesc:SetPosY(TooltipYPos + elementgap)
    TooltipYPos = GetBottomPos(target.recoveryDesc) + elementgap
  end
  target.mainPanel:SetSize(target.mainPanel:GetSizeX(), TooltipYPos + elementBiggap / 2)
  if true == _ContentsGroup_RenewUI then
    target.productNotify:SetShow(false)
  end
  return item_type == 1, (itemSSW:isUsableServant())
end
function FromClient_responseTradePrice_Tooltip_Item(price, key, enchantLevel)
  if nil == key or nil == enchantLevel then
    return
  end
  local enchantKey = ItemEnchantKey(key, enchantLevel)
  local enchantKeyRaw = enchantKey:get()
  local itemSSW = getItemEnchantStaticStatus(enchantKey)
  local str_itemWeight = string.format("%.2f", Int64toInt32(itemSSW:getWorldMarketVolume()) / 10)
  local data
  if nil ~= _firstTradeInfoData and _firstTradeInfoData.key == enchantKeyRaw then
    data = _firstTradeInfoData
    _firstTradeInfoData.key = 0
  elseif nil ~= _secondTradeInfoData and _secondTradeInfoData.key == enchantKeyRaw then
    data = _secondTradeInfoData
    _secondTradeInfoData.key = 0
  else
    return
  end
  if nil == data then
    return
  end
  local txt = data.txt_valuePrice
  txt:SetShow(true)
  data.pendingAnimation:SetShow(false)
  if price <= Defines.s64_const.s64_0 then
    txt:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_TRADEPRICE_TITLE") .. " " .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKET_PLACE_NO_PRICE_INFO") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_CARRYING_CAPACITY") .. " : " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_VOLUME_VT_PARAM_NONCOLOR", "Weight", str_itemWeight))
  else
    txt:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_TRADEPRICE_TITLE") .. " " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(price)) .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_CARRYING_CAPACITY") .. " : " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_VOLUME_VT_PARAM_NONCOLOR", "Weight", str_itemWeight))
  end
end
function showTooltip_Item(target, itemWrapper, isSSW, isItemWrapper, chattingLinkedItem, index, isNextEnchantInfo, invenSlotNo, itemNamingStr)
  audioPostEvent_SystemUi(1, 13)
  _AudioPostEvent_SystemUiForXBOX(1, 13)
  target.mainPanel:SetShow(true, false)
  local ret, ret2 = Panel_Tooltip_Item_ShowInfo(target, itemWrapper, isSSW, isItemWrapper, chattingLinkedItem, index, isNextEnchantInfo, invenSlotNo, itemNamingStr)
  return ret, ret2
end
function ItemTooltip_UsableClssTypeCheck(itemSSW)
  if nil == itemSSW then
    return
  end
  local isUsable = false
  for idx = 0, getCharacterClassCount() - 1 do
    local classType = getCharacterClassTypeByIndex(idx)
    if itemSSW:get()._usableClassType:isOn(classType) then
      isUsable = true
      break
    end
  end
  return isUsable
end
function ItemTooltip_UsableServantKind(itemSSW)
  if nil == itemSSW then
    return
  end
  local servantKind = CppEnums.ServantKind
  local servantKindType
  for index = 0, servantKind.Type_Count - 1 do
    if itemSSW:get():isServantTypeUsable(index) then
      if servantKind.Type_Horse == index or servantKind.Type_Camel == index or servantKind.Type_Donkey == index or servantKind.Type_Elephant == index then
        servantKindType = 0
      elseif servantKind.Type_TwoWheelCarriage == index or servantKind.Type_FourWheeledCarriage == index then
        servantKindType = 1
      elseif servantKind.Type_Ship == index or servantKind.Type_Raft == index or servantKind.Type_FishingBoat == index then
        servantKindType = 2
      end
    end
  end
  return servantKindType
end
function Panel_Tooltip_Item_Show_WithoutEndurance(itemStaticStatus, uiBase, isSSW, isItemWrapper, chattingLinkedItem, index, isItemMarket, invenSlotNo, TooltipType, indexForNaming)
  Panel_Tooltip_Item_Show(itemStaticStatus, uiBase, isSSW, isItemWrapper, chattingLinkedItem, index, isItemMarket, invenSlotNo, TooltipType, indexForNaming)
  normalTooltip.useLimit_endurance:SetShow(false)
  normalTooltip.useLimit_endurance_gage:SetShow(false)
  normalTooltip.useLimit_endurance_gage_value:SetShow(false)
  normalTooltip.useLimit_dynamic_endurance_gage_value:SetShow(false)
  normalTooltip.useLimit_endurance_value:SetShow(false)
  normalTooltip.mainPanel:SetSize(normalTooltip.mainPanel:GetSizeX(), normalTooltip.mainPanel:GetSizeY() - 30)
end
function PaGlobalFunc_Tooltip_Item_Repaircheck(target, equipType, enduranceLimit, repairPriceByNpc_s64)
  if 0 ~= equipType and 0 ~= enduranceLimit then
    target._txt_repair:SetShow(true)
    if toInt64(0, 0) ~= repairPriceByNpc_s64 then
      target._txt_repair:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_ABLE_REPAIR"))
    else
      target._txt_repair:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_DISABLE_REPAIR"))
    end
  end
end
Panel_Tooltip_Item_Initialize()
