PaGloabl_BlackSpiritSkillSelect = {
  _ui = {
    _btn_cancel = nil,
    _btn_apply = nil,
    _btn_skinSelect = nil
  },
  _control = {},
  _texUV = {
    [0] = {
      1,
      398,
      206,
      793
    },
    [1] = {
      208,
      398,
      413,
      793
    },
    [2] = {
      415,
      398,
      620,
      793
    },
    [3] = {
      622,
      398,
      827,
      793
    },
    [4] = {
      829,
      1,
      1034,
      396
    },
    [10] = {
      622,
      1,
      827,
      396
    },
    [11] = {
      829,
      398,
      1034,
      793
    }
  },
  _defaultPosX = nil,
  _blackSpiritKey = nil,
  _initialize = false,
  _isOpen = false,
  _totalSizeY = nil
}
runLua("UI_Data/Script/Widget/BlackSpirit_SkillSelect/Panel_Widget_BlackSpirit_SkillSelect_1.lua")
runLua("UI_Data/Script/Widget/BlackSpirit_SkillSelect/Panel_Widget_BlackSpirit_SkillSelect_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_BlackSpiritSkillSelect")
function FromClient_BlackSpiritSkillSelect()
  PaGloabl_BlackSpiritSkillSelect:initialize()
end
