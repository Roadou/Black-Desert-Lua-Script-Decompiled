PaGlobal_TotalReward = {
  _ui = {
    stc_topGroup = UI.getChildControl(Panel_Window_TotalReward, "Static_TopGroup"),
    stc_contentGroup = UI.getChildControl(Panel_Window_TotalReward, "Static_ContentGroup"),
    stc_bottomGroup = UI.getChildControl(Panel_Window_TotalReward, "Static_BottomGroup"),
    stc_itemLog_widget = UI.getChildControl(Panel_Window_TotalReward, "Static_ItemLog_Widget")
  },
  REWARD_KEY_GROUP = {
    ETC = 0,
    BATTLEROYALE_RANK = 1,
    BATTLEROYALE_ROOT = 2,
    BATTLEROYALE_MISSION = 3,
    BATTLEROYALE_TIER = 4,
    FAMILY_RECEIVE = 5
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true,
    createCount = true,
    createCash = true,
    createEnduranceIcon = true
  },
  scrollPos = 0,
  categoryGroups = {},
  itemLogControl = {},
  uiSlot = {},
  scrollIndex = 0,
  rewardSilver = toInt64(0, 0),
  rewardSilverIndex = {},
  _COL_SLOT_COUNT = 8,
  _CONTENT_FRAME_SIZE_Y = 460,
  _ITEMLOG_FRAME_SIZE_Y = 180,
  _initialize = false
}
runLua("UI_Data/Script/Window/RewardList/Panel_Window_TotalReward_1.lua")
runLua("UI_Data/Script/Window/RewardList/Panel_Window_TotalReward_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_TotalRewardInit")
function FromClient_TotalRewardInit()
  PaGlobal_TotalReward:initialize()
end
