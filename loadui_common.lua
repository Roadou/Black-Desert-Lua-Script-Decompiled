local UIGroup = Defines.UIGroup
local RenderMode = Defines.RenderMode
local _IsXbox = ToClient_isConsole()
runLua("UI_Data/Script/RenderMode/renderMode.lua")
local isActionModeActive = false
function isActionUiOpen()
  return isActionModeActive
end
local _isRemasterUIOption = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eSwapRemasterUISetting)
local _isRemasterUIInit = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eInitRemasterUI)
function PaGlobalFunc_IsRemasterUIOption()
  if false == _isRemasterUIInit then
    return true
  end
  return _isRemasterUIOption
end
function PaGlobalFunc_SetRemasterUIOption(isRemaster)
  _isRemasterUIOption = isRemaster
end
function basicLoadUI(panelNodeName, panelID, panelGroup)
  loadUI(panelNodeName, panelID, panelGroup, SETRENDERMODE_BITSET_DEFULAT())
end
function CheckTutorialEnd()
  if getSelfPlayer() == nil then
    return false
  end
  if true == _ContentsGroup_Tutorial_Renewal then
    return 7 <= getSelfPlayer():get():getLevel()
  end
  return ToClient_getTutorialLimitLevel() <= getSelfPlayer():get():getLevel()
end
LOADUI_TYPE = {
  logoUI = 0,
  loginUI = 1,
  serverSelectUI = 2,
  loadingUI = 3,
  lobbyUI = 4,
  preLoadGameUI = 5,
  GameUI = 6
}
local _loadUIFunc = {}
function PaGlobal_SetLoadUIFunc(func, Type)
  _loadUIFunc[Type] = func
end
local ePlatform = {
  PC = 0,
  XBox = 1,
  PS4 = 2,
  Instance = 3,
  InstanceLobby = 4
}
local platformType = ePlatform.PC
function PaGlobal_LoadPlatformUI()
  if true == ToClient_isConsole() then
    runLua("UI_Data/Script/loadUI_XBOX.lua")
    platformType = ePlatform.XBox
  elseif true == ToClient_IsInstanceFieldPlayerbyContentsType(__eInstanceContentsType_BattleRoyale) and _ContentsGroup_RedDesert then
    runLua("UI_Data/Script/loadUI_Instance.lua")
    platformType = ePlatform.Instance
  elseif true == ToClient_IsInstanceFieldPlayerbyContentsType(__eInstanceContentsType_SavageDefence) and _ContentsGroup_InfinityDefence then
    runLua("UI_Data/Script/loadUI_PC.lua")
    platformType = ePlatform.PC
  elseif true == ToClient_isInstanceFieldServer() and _ContentsGroup_RedDesert then
    runLua("UI_Data/Script/loadUI_InstanceLobby.lua")
    platformType = ePlatform.InstanceLobby
  else
    runLua("UI_Data/Script/loadUI_PC.lua")
    platformType = ePlatform.PC
  end
end
PaGlobal_LoadPlatformUI()
function loadLogoUI()
  local func = _loadUIFunc[LOADUI_TYPE.logoUI]
  func()
end
function loadLoginUI()
  local func = _loadUIFunc[LOADUI_TYPE.loginUI]
  func()
end
function loadServerSelectUI()
  local func = _loadUIFunc[LOADUI_TYPE.serverSelectUI]
  func()
end
function loadLoadingUI()
  local func = _loadUIFunc[LOADUI_TYPE.loadingUI]
  func()
end
function loadSceneEditUI()
end
function loadLobbyUI()
  local func = _loadUIFunc[LOADUI_TYPE.lobbyUI]
  func()
end
function loadLobbyUI_SteamBattleRoyal()
  loadUI("UI_Data/UI_Loading/UI_Loading_Progress_BattleRoyal.xml", "Panel_Loading", UIGroup.PAGameUIGroup_GameSystemMenu, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Loading
  }))
  runLua("UI_Data/Script/Panel_Loading_BattleRoyal.lua")
  loadUI("UI_Data/Instance/Instance_Cursor.XML", "Instance_Cursor", UIGroup.PAGameUIGroup_Window_Progress, SETRENDERMODE_BITSET_ALLRENDER())
  runLua("UI_Data/Script/Instance/Instance_globalPreLoadUI.lua")
  basicLoadUI("UI_Data/Instance/Lobby/LobbyInstance_Widget_Leave.XML", "LobbyInstance_Widget_Leave", UIGroup.PAGameUIGroup_Interaction)
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Widget_Leave.lua")
  loadUI("UI_Data/Instance/Lobby/LobbyInstance_RoomMessageBox.XML", "LobbyInstance_RoomMessageBox", UIGroup.PAGameUIGroup_FadeScreen, SETRENDERMODE_BITSET_ALLRENDER())
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_RoomMessageBox.lua")
  basicLoadUI("UI_Data/Instance/Lobby/LobbyInstance_Window_ModeBranch.xml", "LobbyInstance_Window_ModeBranch", UIGroup.PAGameUIGroup_Windows)
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Window_ModeBranch.lua")
  basicLoadUI("UI_Data/Window/MessageBox/UI_Win_System.XML", "Panel_Win_System", UIGroup.PAGameUIGroup_ModalDialog)
  basicLoadUI("UI_Data/Window/MessageBox/Panel_ScreenShot_For_Desktop.XML", "Panel_ScreenShot_For_Desktop", UIGroup.PAGameUIGroup_ModalDialog)
  basicLoadUI("UI_Data/Window/MessageBox/Panel_KickOff.XML", "Panel_KickOff", UIGroup.PAGameUIGroup_ModalDialog)
  runLua("UI_Data/Script/Window/MessageBox/MessageBox.lua")
  runLua("UI_Data/Script/Window/MessageBox/Panel_ScreenShot_For_Desktop.lua")
  runLua("UI_Data/Script/Window/MessageBox/Panel_KickOff.lua")
  loadUI("UI_Data/Instance/Instance_MessageBox.XML", "Instance_MessageBox", UIGroup.PAGameUIGroup_FadeScreen, SETRENDERMODE_BITSET_ALLRENDER())
  runLua("UI_Data/Script/Instance/Instance_MessageBox.lua")
end
function preLoadGameUI()
  local func = _loadUIFunc[LOADUI_TYPE.preLoadGameUI]
  func()
  basicLoadUI("UI_Data/Widget/UIcontrol/QASupport_AutomationPanel.XML", "QASupport_AutomationPanel", UIGroup.PAGameUIGroup_DeadMessage)
end
function loadGameUI()
  local func = _loadUIFunc[LOADUI_TYPE.GameUI]
  func()
  runLua("UI_Data/Script/QASupport/QASupport_AutomationPanel/QASupport_AutomationPanel.lua")
end
function preLoadGameOptionUI()
  basicLoadUI("UI_Data/Window/WebHelper/Panel_WebControl.XML", "Panel_WebControl", UIGroup.PAGameUIGroup_DeadMessage)
  if true == _ContentsGroup_isNewOption then
    basicLoadUI("UI_Data/Window/c_Option/Panel_Option_Main.XML", "Panel_Window_cOption", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Performance_Camera.XML", "Panel_Performance_Camera", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Performance_GraphicQuality.XML", "Panel_Performance_GraphicQuality", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Performance_Npc.XML", "Panel_Performance_Npc", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Performance_Optimize.XML", "Panel_Performance_Optimize", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Function_Alert.XML", "Panel_Function_Alert", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Function_Nation.XML", "Panel_Function_Nation", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Graphic_Camera.XML", "Panel_Graphic_Camera", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Graphic_Effect.XML", "Panel_Graphic_Effect", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Graphic_Quality.XML", "Panel_Graphic_Quality", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Graphic_ScreenShot.XML", "Panel_Graphic_ScreenShot", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Graphic_Window.XML", "Panel_Graphic_Window", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Graphic_Hdr.XML", "Panel_Graphic_HDR", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Sound_OnOff.XML", "Panel_Sound_OnOff", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Sound_Volume.XML", "Panel_Sound_Volume", UIGroup.PAGameUIGroup_Windows)
  elseif true == _ContentsGroup_RenewUI_RenewOPtion then
    basicLoadUI("UI_Data/Window/c_Option/Console/Panel_Window_OptionMain_Renew.XML", "Panel_Window_Option_Main", UIGroup.PAGameUIGroup_Windows)
  end
  basicLoadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Skill.XML", "Panel_Tooltip_Skill", UIGroup.PAGameUIGroup_GameMenu)
  basicLoadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Skill_forLearning.XML", "Panel_Tooltip_Skill_forLearning", UIGroup.PAGameUIGroup_GameMenu)
  basicLoadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Skill_BlackSpirit.XML", "Panel_Tooltip_Skill_forBlackSpirit", UIGroup.PAGameUIGroup_GameMenu)
  loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Item.XML", "Panel_Tooltip_Item", UIGroup.PAGameUIGroup_ModalDialog, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_InGameCashShop,
    RenderMode.eRenderMode_WorldMap
  }))
  basicLoadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Item_chattingLinkedItem.XML", "Panel_Tooltip_Item_chattingLinkedItem", UIGroup.PAGameUIGroup_ModalDialog)
  basicLoadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Item_chattingLinkedItemClick.XML", "Panel_Tooltip_Item_chattingLinkedItemClick", UIGroup.PAGameUIGroup_ModalDialog)
  basicLoadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Item_equipped.XML", "Panel_Tooltip_Item_equipped", UIGroup.PAGameUIGroup_ModalDialog)
  basicLoadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Guild_Introduce.XML", "Panel_Tooltip_Guild_Introduce", UIGroup.PAGameUIGroup_GameMenu)
  basicLoadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Common.XML", "Panel_Tooltip_Common", UIGroup.PAGameUIGroup_GameMenu)
  basicLoadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Worker.XML", "Panel_Worker_Tooltip", UIGroup.PAGameUIGroup_GameMenu)
  basicLoadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Work.XML", "Panel_Tooltip_Work", UIGroup.PAGameUIGroup_GameMenu)
  basicLoadUI("UI_Data/Widget/Tooltip/UI_Tooltip_SimpleText.XML", "Panel_Tooltip_SimpleText", UIGroup.PAGameUIGroup_SimpleTooltip)
end
function loadGameOptionUI()
  if true == _ContentsGroup_isNewOption then
    runLua("UI_Data/Script/Window/Option/GameOptionHeader.lua")
    runLua("UI_Data/Script/Window/Option/GameOptionMain.lua")
    runLua("UI_Data/Script/Window/Option/GameOptionUtil.lua")
    runLua("UI_Data/Script/Window/Option/Panel_Option_Main.lua")
    PaGlobal_Option:Init()
    ToClient_initGameOption()
  elseif true == _ContentsGroup_RenewUI_RenewOPtion then
    runLua("UI_Data/Script/Window/Option/GameOptionHeader_Renew.lua")
    runLua("UI_Data/Script/Window/Option/GameOptionMain_Renew.lua")
    runLua("UI_Data/Script/Window/Option/GameOptionUtil.lua")
    runLua("UI_Data/Script/Window/Option/Panel_Option_Main_Renew.lua")
    PaGlobal_Option:Init()
    ToClient_initGameOption()
  end
  runLua("UI_Data/Script/GlobalKeyBinder/globalKeyBinderManager.lua")
  runLua("UI_Data/Script/GlobalKeyBinder/globalKeyBinder.lua")
  runLua("UI_Data/Script/Tutorial/Panel_WebControl.lua")
  runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Skill.lua")
  runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Item.lua")
  runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Guild_Introduce.lua")
  runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Common.lua")
  runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_SimpleText.lua")
  runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_New_Worker.lua")
  runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_New_Work.lua")
end
function loadOceanUI()
  basicLoadUI("UI_Data/Window/Cutscene/Panel_CutsceneMovie.XML", "Panel_Cutscene", UIGroup.PAGameUIGroup_MainUI)
  basicLoadUI("UI_Data/Widget/Acquire/Acquire.XML", "Panel_Acquire", UIGroup.PAGameUIGroup_MainUI)
  basicLoadUI("UI_Data/Widget/Acquire/Acquire_QuestDirect.XML", "Panel_QuestDirect", UIGroup.PAGameUIGroup_ModalDialog)
  runLua("UI_Data/Script/Widget/Acquire/Acquire.lua")
  runLua("UI_Data/Script/CutScene_Ocean.lua")
  runLua("UI_Data/Script/Widget/Acquire/Acquire_QuestDirect.lua")
end
function PaGlobal_GetPanelWindowInventory()
  if ePlatform.Instance == platformType then
    return Instance_Window_Inventory
  elseif ePlatform.InstanceLobby == platformType then
    return Instance_Window_Inventory
  else
    return Panel_Window_Inventory
  end
end
function PaGlobal_GetPanelTooltipSimpleText()
  if ePlatform.Instance == platformType then
    return Instance_Tooltip_SimpleText
  elseif ePlatform.InstanceLobby == platformType then
    return Instance_Tooltip_SimpleText
  else
    return Panel_Tooltip_SimpleText
  end
end
