local _panel = Panel_Window_DyeingEject_Renew
local DyeingEject = {
  _ui = {
    txt_title = UI.getChildControl(_panel, "StaticText_Title"),
    stc_inner = UI.getChildControl(_panel, "Static_Inner"),
    stc_line1 = nil,
    stc_line3 = nil,
    edit_dyeIcon = UI.getChildControl(_panel, "Static_Dye_Icon"),
    txt_nameDesc = UI.getChildControl(_panel, "StaticText_Dye_NameDec"),
    stc_line2 = UI.getChildControl(_panel, "Static_Line2"),
    stc_bottomBG = UI.getChildControl(_panel, "Static_BottomGg"),
    btn_A = nil,
    btn_B = nil,
    stc_bottomBG = UI.getChildControl(_panel, "Static_BottomGg")
  }
}
function FromClient_luaLoadComplete_DyeingEject_Init()
  DyeingEject:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_DyeingEject_Init")
function DyeingEject:initialize()
  self._ui.stc_line1 = UI.getChildControl(self._ui.stc_inner, "Static_Line1")
  self._ui.stc_line3 = UI.getChildControl(self._ui.stc_inner, "Static_Line3")
  self._ui.btn_A = UI.getChildControl(self._ui.stc_bottomBG, "Button_A_ConsoleUI")
  self._ui.btn_B = UI.getChildControl(self._ui.stc_bottomBG, "Button_B_ConsoleUI")
end
function PaGlobalFunc_DyeingEject_Open()
  DyeingEject:open()
end
function DyeingEject:open()
  _panel:SetShow(true)
end
