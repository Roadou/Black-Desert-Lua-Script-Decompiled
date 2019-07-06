PaGlobal_Itemwarp = {
  _ui = {
    stc_Partline = nil,
    btn_Close = nil,
    list2_Town = nil,
    btn_Apply = nil,
    stc_KeyGuideBG = nil,
    stc_KeyGuide_A = nil,
    stc_KeyGuide_B = nil
  },
  _selectTownKey = nil,
  _selectSlotNo = nil,
  _selectWhereType = nil
}
runLua("UI_Data/Script/Window/Item/Panel_Itemwarp_All_1.lua")
runLua("UI_Data/Script/Window/Item/Panel_Itemwarp_All_2.lua")
function PaGlobal_Itemwarp_Init()
  PaGlobal_Itemwarp:init()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_Itemwarp_Init")
