PaGlobal_DialogQuest_All = {
  _ui = {
    stc_title = nil,
    stc_questTitle = nil,
    txt_questTitleName = nil,
    frame_questMain = nil,
    frame_content = nil,
    frame_txtNpcWord = nil,
    frame_VScroll = nil,
    frame_VScroll_Ctrl = nil,
    stc_DecoBg = nil,
    stc_rewardMain = nil,
    stc_basicRewardBg = nil,
    txt_basicReward = nil,
    stc_selectRewardBg = nil,
    txt_selectReward = nil
  },
  _ui_pc = {btn_confirm = nil, btn_cancle = nil},
  _ui_console = {stc_guideIconA = nil, stc_guideIconB = nil},
  _itemSlotConfig = {
    createIcon = true,
    createEnchant = true,
    createBorder = true,
    createCount = true,
    createClassEquipBG = true,
    createCash = true
  },
  _baseRewardCount = 0,
  _maxBaseSlotCount = 8,
  _listBaseRewardSlots = {},
  _uiBackBaseRewardBg = {},
  _selectRewardCount = 0,
  _maxSelectSlotCount = 8,
  _listSelectRewardSlots = {},
  _uiBackSelectRewardCheck = {},
  _selectRewardItemName = nil,
  _selectRewardItemNameList = {},
  _equipRewardItemCount = 0,
  _selectCheckBaseTexture = nil,
  _selectCheckOnTexture = nil,
  _selectCheckClickTexture = nil,
  _panelSizeY = 0,
  _frameContentSizeY = 0,
  _isQuest = false,
  _isComplete = false,
  _initialize = false
}
runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_Quest_All_1.lua")
runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_Quest_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_DialogQuest_All_Init")
function FromClient_DialogQuest_All_Init()
  PaGlobal_DialogQuest_All:initialize()
end
