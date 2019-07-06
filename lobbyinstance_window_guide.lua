PaGlobal_Guide = {
  _ui = {
    _stc_headerGroup = UI.getChildControl(LobbyInstance_Window_Guide, "Static_Header_Group"),
    _stc_topGroup = UI.getChildControl(LobbyInstance_Window_Guide, "Static_Top_Group"),
    _stc_contentGroup = UI.getChildControl(LobbyInstance_Window_Guide, "Static_Content_Group"),
    descBg = {},
    descGroup = {}
  },
  categoryInfo = {
    {
      "PANEL_BATTLEROYAL_GUIDE_STORY_",
      3
    },
    {
      "PANEL_BATTLEROYAL_GUIDE_RULE_",
      9
    },
    {
      "PANEL_BATTLEROYAL_GUIDE_TIP_",
      7
    },
    {
      "PANEL_BATTLEROYAL_GUIDE_KEY_",
      10
    },
    {
      "PANEL_BATTLEROYAL_GUIDE_REWARD_",
      4
    }
  },
  _tabBtnGroup = {},
  _MAX_DESC_COUNT = 5,
  _initialize = false,
  _descMaskingSizeY = {},
  _nowIndex = 1,
  _nowSubIndex = 1
}
runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Window_Guide_1.lua")
runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Window_Guide_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_Guide_Init")
function FromClient_Guide_Init()
  PaGlobal_Guide:initialize()
end
