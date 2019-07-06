function PaGlobal_Guild_Create_All:initialize()
  if true == PaGlobal_Guild_Create_All._initialize then
    return
  end
  PaGlobal_Guild_Create_All._isConsole = ToClient_isConsole()
  PaGlobal_Guild_Create_All:controlAll_Init()
  PaGlobal_Guild_Create_All:controlPc_Init()
  PaGlobal_Guild_Create_All:controlConsole_Init()
  PaGlobal_Guild_Create_All:SetUiSetting()
  PaGlobal_Guild_Create_All._isConfirm = false
  if true == PaGlobal_Guild_Create_All._isConsole then
    local tempBtnGroup = {
      PaGlobal_Guild_Create_All._ui_console.btn_confirm,
      PaGlobal_Guild_Create_All._ui_console.btn_close
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, PaGlobal_Guild_Create_All._ui_console.stc_bottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  end
  PaGlobal_Guild_Create_All:registEventHandler()
  PaGlobal_Guild_Create_All:validate()
  PaGlobal_Guild_Create_All._initialize = true
end
function PaGlobal_Guild_Create_All:controlAll_Init()
  if nil == Panel_Guild_Create_All then
    return
  end
  PaGlobal_Guild_Create_All._ui.stc_nameBg = UI.getChildControl(Panel_Guild_Create_All, "Static_NameBg")
  PaGlobal_Guild_Create_All._ui.stc_guildName = UI.getChildControl(PaGlobal_Guild_Create_All._ui.stc_nameBg, "Edit_GuildName")
  local guildBg = UI.getChildControl(Panel_Guild_Create_All, "StaticText_GuildBg")
  PaGlobal_Guild_Create_All._ui.stc_guildDesc = UI.getChildControl(guildBg, "StaticText_GuildDesc")
  PaGlobal_Guild_Create_All:setGuildDese()
end
function PaGlobal_Guild_Create_All:controlPc_Init()
  if nil == Panel_Guild_Create_All then
    return
  end
  PaGlobal_Guild_Create_All._ui_pc.btn_close = UI.getChildControl(Panel_Guild_Create_All, "Button_Close_PCUI")
  PaGlobal_Guild_Create_All._ui_pc.btn_confirm = UI.getChildControl(Panel_Guild_Create_All, "Button_Confirm_PCUI")
  PaGlobal_Guild_Create_All._ui_pc.btn_cancle = UI.getChildControl(Panel_Guild_Create_All, "Button_Cancel_PCUI")
end
function PaGlobal_Guild_Create_All:controlConsole_Init()
  if nil == Panel_Guild_Create_All then
    return
  end
  PaGlobal_Guild_Create_All._ui_console.stc_bottomBg = UI.getChildControl(Panel_Guild_Create_All, "Static_BottomBg_ConsoleUI")
  PaGlobal_Guild_Create_All._ui_console.btn_confirm = UI.getChildControl(PaGlobal_Guild_Create_All._ui_console.stc_bottomBg, "StaticText_A_ConsoleUI")
  PaGlobal_Guild_Create_All._ui_console.btn_close = UI.getChildControl(PaGlobal_Guild_Create_All._ui_console.stc_bottomBg, "StaticText_B_ConsoleUI")
end
function PaGlobal_Guild_Create_All:SetUiSetting()
  if false == PaGlobal_Guild_Create_All._isConsole then
    Panel_Guild_Create_All:SetSize(Panel_Guild_Create_All:GetSizeX(), PaGlobal_Guild_Create_All._pcPanelSizeY)
    PaGlobal_Guild_Create_All._ui_pc.btn_close:SetShow(true)
    PaGlobal_Guild_Create_All._ui_pc.btn_confirm:SetShow(true)
    PaGlobal_Guild_Create_All._ui_pc.btn_cancle:SetShow(true)
    PaGlobal_Guild_Create_All._ui_console.stc_bottomBg:SetShow(false)
    UI.getChildControl(PaGlobal_Guild_Create_All._ui.stc_guildName, "StaticText_X_ConsoleUI"):SetShow(false)
    UI.getChildControl(PaGlobal_Guild_Create_All._ui.stc_nameBg, "Static_TextIcon"):SetShow(false)
    PaGlobal_Guild_Create_All._ui.stc_nameBg:SetSize(PaGlobal_Guild_Create_All._consoleBgSizeX, PaGlobal_Guild_Create_All._consoleBgSizeY)
  else
    Panel_Guild_Create_All:SetSize(Panel_Guild_Create_All:GetSizeX(), PaGlobal_Guild_Create_All._consolePanelSizeY)
    PaGlobal_Guild_Create_All._ui_pc.btn_close:SetShow(false)
    PaGlobal_Guild_Create_All._ui_pc.btn_confirm:SetShow(false)
    PaGlobal_Guild_Create_All._ui_pc.btn_cancle:SetShow(false)
    PaGlobal_Guild_Create_All._ui_console.stc_bottomBg:SetShow(true)
    UI.getChildControl(PaGlobal_Guild_Create_All._ui.stc_guildName, "StaticText_X_ConsoleUI"):SetShow(true)
    UI.getChildControl(PaGlobal_Guild_Create_All._ui.stc_nameBg, "Static_TextIcon"):SetShow(true)
  end
end
function PaGlobal_Guild_Create_All:registEventHandler()
  if nil == Panel_Guild_Create_All then
    return
  end
  registerEvent("onScreenResize", "FromClient_Guild_Create_All_onScreenResize")
  if false == PaGlobal_Guild_Create_All._isConsole then
    PaGlobal_Guild_Create_All._ui_pc.btn_close:addInputEvent("Mouse_LUp", "PaGlobal_Guild_Create_All_Close()")
    PaGlobal_Guild_Create_All._ui_pc.btn_confirm:addInputEvent("Mouse_LUp", "HandleEventLUp_Guild_Create_All_clickedConfirm()")
    PaGlobal_Guild_Create_All._ui_pc.btn_cancle:addInputEvent("Mouse_LUp", "HandleEventLUp_Guild_Create_All_clickedCancel()")
    PaGlobal_Guild_Create_All._ui.stc_guildName:RegistReturnKeyEvent("HandleEventLUp_Guild_Create_All_clickedConfirm()")
  else
    Panel_Guild_Create_All:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventLUp_Guild_Create_All_clickedConfirm()")
    Panel_Guild_Create_All:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_Guild_Create_All_setFocus()")
  end
end
function PaGlobal_Guild_Create_All:prepareOpen()
  if nil == Panel_Guild_Create_All then
    return
  end
  PaGlobal_Guild_Create_All._ui.stc_guildName:SetEditText("")
  PaGlobal_Guild_Create_All._ui.stc_guildName:SetMaxInput(getGameServiceTypeGuildNameLength())
  PaGlobal_Guild_Create_All:open()
end
function PaGlobal_Guild_Create_All:open()
  if nil == Panel_Guild_Create_All then
    return
  end
  Panel_Guild_Create_All:SetShow(true)
end
function PaGlobal_Guild_Create_All:prepareClose()
  if nil == Panel_Guild_Create_All then
    return
  end
  if false == PaGlobal_Guild_Create_All._isConfirm and PaGlobal_Guild_Create_All._isConsole then
    _AudioPostEvent_SystemUiForXBOX(50, 3)
  end
  PaGlobal_Guild_Create_All:close()
end
function PaGlobal_Guild_Create_All:close()
  if nil == Panel_Guild_Create_All then
    return
  end
  Panel_Guild_Create_All:SetShow(false)
end
function PaGlobal_Guild_Create_All:update()
  if nil == Panel_Guild_Create_All then
    return
  end
end
function PaGlobal_Guild_Create_All:validate()
  if nil == Panel_Guild_Create_All then
    return
  end
  PaGlobal_Guild_Create_All:allValidate()
  PaGlobal_Guild_Create_All:pcValidate()
  PaGlobal_Guild_Create_All:consoleValidate()
end
function PaGlobal_Guild_Create_All:allValidate()
  PaGlobal_Guild_Create_All._ui.stc_nameBg:isValidate()
  PaGlobal_Guild_Create_All._ui.stc_guildName:isValidate()
  PaGlobal_Guild_Create_All._ui.stc_guildDesc:isValidate()
end
function PaGlobal_Guild_Create_All:pcValidate()
  PaGlobal_Guild_Create_All._ui_pc.btn_close:isValidate()
  PaGlobal_Guild_Create_All._ui_pc.btn_confirm:isValidate()
  PaGlobal_Guild_Create_All._ui_pc.btn_cancle:isValidate()
end
function PaGlobal_Guild_Create_All:consoleValidate()
  PaGlobal_Guild_Create_All._ui_console.stc_bottomBg:isValidate()
  PaGlobal_Guild_Create_All._ui_console.btn_confirm:isValidate()
  PaGlobal_Guild_Create_All._ui_console.btn_close:isValidate()
end
function PaGlobal_Guild_Create_All:setGuildDese()
  PaGlobal_Guild_Create_All._ui.stc_guildDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local txt_NameDesc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_POPUP_1")
  if isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeTH() or isGameTypeRussia() or isGameTypeID() or isGameTypeTR() then
    txt_NameDesc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_POPUP_1") .. [[


<PAColor0xFFF26A6A>]] .. PAGetString(Defines.StringSheet_GAME, "LUA_MAKENAME_WARNING") .. "<PAOldColor>"
  else
    txt_NameDesc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_POPUP_1")
  end
  PaGlobal_Guild_Create_All._ui.stc_guildDesc:SetText(txt_NameDesc)
end
