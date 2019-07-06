function PaGlobal_PartyRecruite_All:initialize()
  if true == PaGlobal_PartyRecruite_All._initialize then
    return
  end
  if nil == Panel_PartyRecruite_All then
    return
  end
  self:controlAll_Init()
  self:controlPc_Init()
  self:controlConsole_Init()
  self:controlSetShow()
  self:registEventHandler()
  self:validate()
  self._initialize = true
end
function PaGlobal_PartyRecruite_All:controlAll_Init()
  if nil == Panel_PartyRecruite_All then
    return
  end
  Panel_PartyRecruite_All:SetShow(false, false)
  Panel_PartyRecruite_All:setGlassBackground(true)
  Panel_PartyRecruite_All:SetDragAll(true)
  self._ui.stc_centerBg = UI.getChildControl(Panel_PartyRecruite_All, "Static_CenterBg")
  self._ui.edit_adDesc = UI.getChildControl(self._ui.stc_centerBg, "Edit_AdDesc")
  self._ui.stc_level = UI.getChildControl(self._ui.stc_centerBg, "Static_Level")
end
function PaGlobal_PartyRecruite_All:controlPc_Init()
  if nil == Panel_PartyRecruite_All then
    return
  end
  self._ui_pc.btn_close = UI.getChildControl(Panel_PartyRecruite_All, "Button_Close_PCUI")
  self._ui_pc.stc_icon_Text = UI.getChildControl(self._ui.stc_centerBg, "Static_TextIcon")
  self._ui_pc.btn_admin = UI.getChildControl(Panel_PartyRecruite_All, "Button_Admin_PCUI")
end
function PaGlobal_PartyRecruite_All:controlConsole_Init()
  if nil == Panel_PartyRecruite_All then
    return
  end
  self._ui_console.stc_icon_X = UI.getChildControl(self._ui.edit_adDesc, "StaticText_X_ConsoleUI")
  self._ui_console.stc_arrow = UI.getChildControl(self._ui.stc_centerBg, "Static_Arrow")
  self._ui_console.stc_bottomBg = UI.getChildControl(Panel_PartyRecruite_All, "Static_BottomBg_ConsoleUI")
  self._ui_console.stc_icon_A = UI.getChildControl(self._ui_console.stc_bottomBg, "StaticText_A_ConsoleUI")
  self._ui_console.stc_icon_B = UI.getChildControl(self._ui_console.stc_bottomBg, "StaticText_B_ConsoleUI")
end
function PaGlobal_PartyRecruite_All:controlSetShow()
  if nil == Panel_PartyRecruite_All then
    return
  end
  if false == ToClient_isConsole() then
    self._ui_pc.btn_close:SetShow(true)
    self._ui_pc.stc_icon_Text:SetShow(true)
    self._ui_pc.btn_admin:SetShow(true)
    self._ui_console.stc_icon_X:SetShow(false)
    self._ui_console.stc_arrow:SetShow(false)
    self._ui_console.stc_bottomBg:SetShow(false)
  else
    self._ui_pc.btn_close:SetShow(false)
    self._ui_pc.stc_icon_Text:SetShow(false)
    self._ui_pc.btn_admin:SetShow(false)
    self._ui_console.stc_icon_X:SetShow(true)
    self._ui_console.stc_arrow:SetShow(true)
    self._ui_console.stc_bottomBg:SetShow(true)
  end
end
function PaGlobal_PartyRecruite_All:registEventHandler()
  if nil == Panel_PartyRecruite_All then
    return
  end
  if false == ToClient_isConsole() then
    self._ui.edit_adDesc:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyRecruite_All_TextSet()")
    self._ui.stc_level:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyRecruite_All_LevelChange()")
    self._ui_pc.btn_admin:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyRecruite_All_Request()")
    self._ui_pc.btn_close:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyRecruite_All_Close()")
  else
    Panel_PartyRecruite_All:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PadEventDpad_PartyRecruite_All_SetLevel(1)")
    Panel_PartyRecruite_All:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PadEventDpad_PartyRecruite_All_SetLevel(-1)")
    Panel_PartyRecruite_All:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PadEventXUp_PartyRecruite_All_Edit()")
    Panel_PartyRecruite_All:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventLUp_PartyRecruite_All_Request()")
    self._ui.edit_adDesc:setXboxVirtualKeyBoardEndEvent("PaGlobalFunc_PartyRecruite_All_OnVirtualKeyboardEnd")
  end
  Panel_PartyRecruite_All:RegisterShowEventFunc(true, "PaGlobalFunc_PartyRecruite_All_ShowAni()")
  Panel_PartyRecruite_All:RegisterShowEventFunc(false, "PaGlobalFunc_PartyRecruite_All_HideAni()")
  registerEvent("onScreenResize", "FromClient_PartyRecruite_All_Resize")
end
function PaGlobal_PartyRecruite_All:resize()
  if nil == Panel_PartyRecruite_All then
    return
  end
  Panel_PartyRecruite_All:SetPosX(getScreenSizeX() / 2 - Panel_PartyRecruite_All:GetSizeX() / 2)
  Panel_PartyRecruite_All:SetPosY(getScreenSizeY() / 2 - Panel_PartyRecruite_All:GetSizeY() / 2 - 100)
  self._ui_pc.btn_close:ComputePos()
  self._ui_pc.stc_icon_Text:ComputePos()
  self._ui_pc.btn_admin:ComputePos()
  self._ui_console.stc_icon_X:ComputePos()
  self._ui_console.stc_arrow:ComputePos()
  self._ui_console.stc_bottomBg:ComputePos()
  if true == ToClient_isConsole() then
    Panel_PartyRecruite_All:SetSize(Panel_PartyRecruite_All:GetSizeX(), 350)
    self._ui.stc_centerBg:SetSize(self._ui.stc_centerBg:GetSizeX(), 290)
    local tempBtnGroup = {
      self._ui_console.stc_icon_A,
      self._ui_console.stc_icon_B
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui_console.stc_bottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  end
end
function PaGlobal_PartyRecruite_All:prepareOpen()
  if nil == Panel_PartyRecruite_All then
    return
  end
  if false == _ContentsGroup_NewUI_PartyFind_All then
    return
  end
  self._ui.edit_adDesc:SetMaxEditLine(2)
  self._ui.edit_adDesc:SetMaxInput(30)
  self._ui.edit_adDesc:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLISTRECRUITE_DEFALUTTEXT"))
  self._selectLevel = 1
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer and false == ToClient_isConsole() then
    local minLevel = math.min(60, selfPlayer:get():getLevel())
    self._selectLevel = minLevel
    self._ui.stc_level:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PARTYLISTRECRUITE_MINLEVEL", "level", minLevel))
  else
    self._ui.stc_level:SetText(tostring(self._selectLevel))
  end
  PaGlobal_PartyRecruite_All:resize()
  PaGlobal_PartyRecruite_All:open()
end
function PaGlobal_PartyRecruite_All:open()
  if nil == Panel_PartyRecruite_All then
    return
  end
  Panel_PartyRecruite_All:SetShow(true, true)
end
function PaGlobal_PartyRecruite_All:prepareClose()
  if nil == Panel_PartyRecruite_All then
    return
  end
  PaGlobalFunc_PartyList_All_ClearFocusEdit()
  PaGlobal_PartyRecruite_All:close()
end
function PaGlobal_PartyRecruite_All:close()
  if nil == Panel_PartyRecruite_All then
    return
  end
  Panel_PartyRecruite_All:SetShow(false, false)
end
function PaGlobal_PartyRecruite_All:update()
  if nil == Panel_PartyRecruite_All then
    return
  end
end
function PaGlobal_PartyRecruite_All:validate()
  if nil == Panel_PartyRecruite_All then
    return
  end
  self._ui.stc_centerBg:isValidate()
  self._ui.edit_adDesc:isValidate()
  self._ui.stc_level:isValidate()
  if false == ToClient_isConsole() then
    self._ui_pc.btn_close:isValidate()
    self._ui_pc.stc_icon_Text:isValidate()
    self._ui_pc.btn_admin:isValidate()
  else
    self._ui_console.stc_icon_X:isValidate()
    self._ui_console.stc_arrow:isValidate()
    self._ui_console.stc_bottomBg:isValidate()
    self._ui_console.stc_icon_A:isValidate()
    self._ui_console.stc_icon_B:isValidate()
  end
end
