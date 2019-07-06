PaGlobal_ExtractionSystem = {
  _ui = {
    stc_SacrificeItemSlotBG = UI.getChildControl(Panel_Window_ExtractionSystem, "Static_SacrificeSlotBG"),
    stc_CatalystItemSlotBG = UI.getChildControl(Panel_Window_ExtractionSystem, "Static_CatalystSlotBG"),
    stc_ExtractionItemSlotBG_1 = UI.getChildControl(Panel_Window_ExtractionSystem, "Static_ExtractSlotBG_1"),
    stc_ExtractionItemSlotBG_2 = UI.getChildControl(Panel_Window_ExtractionSystem, "Static_ExtractSlotBG_2"),
    btn_Extraction = UI.getChildControl(Panel_Window_ExtractionSystem, "Button_Extraction"),
    stc_ExtractionBG = UI.getChildControl(Panel_Window_ExtractionSystem, "Static_ExtractionBG"),
    txt_CatalystNeed = UI.getChildControl(Panel_Window_ExtractionSystem, "StaticText_CatalystNeed"),
    txt_BottomDesc = UI.getChildControl(Panel_Window_ExtractionSystem, "StaticText_Comment"),
    stc_subBG = UI.getChildControl(Panel_Window_ExtractionSystem, "Static_SubFrame"),
    txt_Title = UI.getChildControl(Panel_Window_ExtractionSystem, "Static_Text_Title"),
    slot_SacrificeItem = {},
    slot_CatalystItem = {},
    slot_ExtractItem_1 = {},
    slot_ExtractItem_2 = {}
  },
  _currentInfo = {
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {}
  },
  _catalystItemKey = -1,
  _const_AniTime = 3.8,
  _current_AniTime = 0,
  _isAnimation = false,
  _resultShowTime = 0,
  _initialize = false
}
runLua("UI_Data/Script/Window/Extraction/Panel_Window_ExtractionSystem_1.lua")
runLua("UI_Data/Script/Window/Extraction/Panel_Window_ExtractionSystem_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_ExtractionSystem_luaLoadComplete")
function FromClient_ExtractionSystem_luaLoadComplete()
  PaGlobal_ExtractionSystem:initialize()
end
