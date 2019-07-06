PaGlobal_ExtractionSystem = {
  _ui = {
    stc_ExtractionSystem = nil,
    stc_SacrificeItemSlotBG = nil,
    stc_CatalystItemSlotBG = nil,
    stc_ExtractionItemSlotBG_1 = nil,
    stc_ExtractionItemSlotBG_2 = nil,
    stc_ExtractionBG = nil,
    txt_CatalystNeed = nil,
    txt_BottomDesc = nil,
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
runLua("UI_Data/Script/Window/Extraction/Console/Panel_Tab_ExtractSystem_Renew_1.lua")
runLua("UI_Data/Script/Window/Extraction/Console/Panel_Tab_ExtractSystem_Renew_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_ExtractionSystem_luaLoadComplete")
function FromClient_ExtractionSystem_luaLoadComplete()
  PaGlobal_ExtractionSystem:initialize()
end
