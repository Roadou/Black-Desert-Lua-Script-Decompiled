function PaGlobal_WorkerRandomSelectOption_All:initialize()
  if nil == Panel_Window_WorkerRandomSelectOption_All or true == PaGlobal_WorkerRandomSelectOption_All._initialize then
    return
  end
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_TitleBg = UI.getChildControl(Panel_Window_WorkerRandomSelectOption_All, "Static_MainTitleBar")
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_Close_PC = UI.getChildControl(PaGlobal_WorkerRandomSelectOption_All._ui._stc_TitleBg, "Button_Close_PCUI")
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_Continue_PC = UI.getChildControl(Panel_Window_WorkerRandomSelectOption_All, "Button_Continue")
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_Cancel_PC = UI.getChildControl(Panel_Window_WorkerRandomSelectOption_All, "Button_Cancel")
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGuide = UI.getChildControl(Panel_Window_WorkerRandomSelectOption_All, "Static_BottomBG_ConsoleUI")
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGuide_A = UI.getChildControl(PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGuide, "StaticText_A_ConsoleUI")
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGudie_B = UI.getChildControl(PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGuide, "StaticText_B_ConsoleUI")
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGudie_Y = UI.getChildControl(PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGuide, "StaticText_Y_ConsoleUI")
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainDescBg = UI.getChildControl(Panel_Window_WorkerRandomSelectOption_All, "Static_DescBg")
  PaGlobal_WorkerRandomSelectOption_All._ui._txt_MainDesc = UI.getChildControl(PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainDescBg, "StaticText_Desc")
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_WorkerGrade = UI.getChildControl(Panel_Window_WorkerRandomSelectOption_All, "Button_WorkerGrade")
  PaGlobal_WorkerRandomSelectOption_All._ui._txt_WorkerGrade = UI.getChildControl(PaGlobal_WorkerRandomSelectOption_All._ui._btn_WorkerGrade, "StaticText_SelectGrade")
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_WorkerCount = UI.getChildControl(Panel_Window_WorkerRandomSelectOption_All, "Button_Count")
  PaGlobal_WorkerRandomSelectOption_All._ui._txt_workerCount = UI.getChildControl(PaGlobal_WorkerRandomSelectOption_All._ui._btn_WorkerCount, "StaticText_Count")
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg = UI.getChildControl(Panel_Window_WorkerRandomSelectOption_All, "Static_GradeSelectBg")
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_All = UI.getChildControl(PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg, "RadioButton_1")
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Normal = UI.getChildControl(PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg, "RadioButton_5")
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Skilled = UI.getChildControl(PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg, "RadioButton_4")
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Expert = UI.getChildControl(PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg, "RadioButton_3")
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_OnlyMaster = UI.getChildControl(PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg, "RadioButton_2")
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Confirm = UI.getChildControl(PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg, "Button_Confirm")
  local ENUM = PaGlobal_WorkerRandomSelectOption_All._ENUM_GRADE
  PaGlobal_WorkerRandomSelectOption_All._gradeButtons[ENUM._ALL] = PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_All
  PaGlobal_WorkerRandomSelectOption_All._gradeButtons[ENUM._NORMAL] = PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Normal
  PaGlobal_WorkerRandomSelectOption_All._gradeButtons[ENUM._SKILLED] = PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Skilled
  PaGlobal_WorkerRandomSelectOption_All._gradeButtons[ENUM._EXPERT] = PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Expert
  PaGlobal_WorkerRandomSelectOption_All._gradeButtons[ENUM._ONLYMASTER] = PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_OnlyMaster
  PaGlobal_WorkerRandomSelectOption_All._isConsole = ToClient_isConsole()
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGuide:SetShow(PaGlobal_WorkerRandomSelectOption_All._isConsole)
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_Close_PC:SetShow(not PaGlobal_WorkerRandomSelectOption_All._isConsole)
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_Continue_PC:SetShow(not PaGlobal_WorkerRandomSelectOption_All._isConsole)
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_Cancel_PC:SetShow(not PaGlobal_WorkerRandomSelectOption_All._isConsole)
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Confirm:SetShow(not PaGlobal_WorkerRandomSelectOption_All._isConsole)
  if true == PaGlobal_WorkerRandomSelectOption_All._isConsole then
    local panelSizeX = Panel_Window_WorkerRandomSelectOption_All:GetSizeX()
    local panelSizeY = Panel_Window_WorkerRandomSelectOption_All:GetSizeY()
    local mainBgBtnSizeX = PaGlobal_WorkerRandomSelectOption_All._ui._btn_Continue_PC:GetSizeX()
    local mainBgBtnSizeY = PaGlobal_WorkerRandomSelectOption_All._ui._btn_Continue_PC:GetSizeY()
    local gradeOptionSizeX = PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg:GetSizeX()
    local gradeOptionSizeY = PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg:GetSizeY()
    local confirmBtnSizeY = PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Confirm:GetSizeY()
    Panel_Window_WorkerRandomSelectOption_All:SetSize(panelSizeX, panelSizeY - (mainBgBtnSizeY + 10))
    PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGuide:SetPosY(Panel_Window_WorkerRandomSelectOption_All:GetSizeY())
    PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg:SetSize(gradeOptionSizeX, gradeOptionSizeY - (confirmBtnSizeY + 20))
    local keyguide = {
      PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGudie_Y,
      PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGuide_A,
      PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGudie_B
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyguide, PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  end
  PaGlobal_WorkerRandomSelectOption_All:validate()
  PaGlobal_WorkerRandomSelectOption_All:registerEventHandler()
end
function PaGlobal_WorkerRandomSelectOption_All:validate()
  if nil == Panel_Window_WorkerRandomSelectOption_All then
    return
  end
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_TitleBg:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_Close_PC:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_Continue_PC:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_Cancel_PC:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGuide:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGuide_A:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainBg_KeyGudie_B:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_MainDescBg:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._txt_MainDesc:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_WorkerGrade:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._txt_WorkerGrade:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_WorkerCount:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._txt_workerCount:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_All:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Normal:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Skilled:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Expert:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_OnlyMaster:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Confirm:isValidate()
  PaGlobal_WorkerRandomSelectOption_All._initialize = true
end
function PaGlobal_WorkerRandomSelectOption_All:registerEventHandler()
  if nil == Panel_Window_WorkerRandomSelectOption_All and false == PaGlobal_WorkerRandomSelectOption_All._initialize then
    return
  end
  registerEvent("onScreenResize", "FromClient_WorkerRandomSelectOption_OnScreenResize()")
  if false == PaGlobal_WorkerRandomSelectOption_All._isConsole then
    PaGlobal_WorkerRandomSelectOption_All._ui._btn_WorkerGrade:addInputEvent("Mouse_LUp", "HandleEventLUp_WorkerRandomSelectOption_All_OptionOpen( 0 )")
    PaGlobal_WorkerRandomSelectOption_All._ui._btn_WorkerCount:addInputEvent("Mouse_LUp", "HandleEventLUp_WorkerRandomSelectOption_All_OptionOpen( 1 )")
    PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Confirm:addInputEvent("Mouse_LUp", "HandleEventLUp_WorkerRandomSelectOption_All_SelectGradeConfirm()")
    PaGlobal_WorkerRandomSelectOption_All._ui._btn_Continue_PC:addInputEvent("Mouse_LUp", "HandleEventLUp_WorkerRandomSelectOption_All_ContinueSelectStart()")
    PaGlobal_WorkerRandomSelectOption_All._ui._btn_Cancel_PC:addInputEvent("Mouse_LUp", "HandleEventLUp_WorkerRandomSelectOption_All_Close()")
    PaGlobal_WorkerRandomSelectOption_All._ui._btn_Close_PC:addInputEvent("Mouse_LUp", "HandleEventLUp_WorkerRandomSelectOption_All_Close()")
    for i = 0, #PaGlobal_WorkerRandomSelectOption_All._gradeButtons do
      PaGlobal_WorkerRandomSelectOption_All._gradeButtons[i]:addInputEvent("Mouse_LUp", "HandleEventLUp_WorkerRandomSelectOption_All_SelectGradeConfirm(" .. i .. ")")
    end
  else
    Panel_Window_WorkerRandomSelectOption_All:ignorePadSnapMoveToOtherPanel()
    Panel_Window_WorkerRandomSelectOption_All:registerPadEvent(__eConsoleUIPadEvent_Y, "HandleEventLUp_WorkerRandomSelectOption_All_ContinueSelectStart()")
    PaGlobal_WorkerRandomSelectOption_All._ui._btn_GradeSelect_Confirm:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventLUp_WorkerRandomSelectOption_All_SelectGrade()")
    PaGlobal_WorkerRandomSelectOption_All._ui._btn_WorkerGrade:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventLUp_WorkerRandomSelectOption_All_OptionOpen( 0 )")
    PaGlobal_WorkerRandomSelectOption_All._ui._btn_WorkerCount:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventLUp_WorkerRandomSelectOption_All_OptionOpen( 1 )")
    for i = 0, #PaGlobal_WorkerRandomSelectOption_All._gradeButtons do
      PaGlobal_WorkerRandomSelectOption_All._gradeButtons[i]:registerPadEvent(__eConsoleUIPadEvent_A, "HandleEventLUp_WorkerRandomSelectOption_All_SelectGradeConfirm(" .. i .. ")")
    end
  end
end
function PaGlobal_WorkerRandomSelectOption_All:onScreenResize()
  if nil == Panel_Window_WorkerRandomSelectOption_All or false == Panel_Window_WorkerRandomSelectOption_All:GetShow() then
    return
  end
  Panel_Window_WorkerRandomSelectOption_All:ComputePos()
end
function PaGlobal_WorkerRandomSelectOption_All:clearData()
  if nil == Panel_Window_WorkerRandomSelectOption_All or false == Panel_Window_WorkerRandomSelectOption_All:GetShow() then
    return
  end
  PaGlobal_WorkerRandomSelectOption_All._config._repetitionCount = 1
  PaGlobal_WorkerRandomSelectOption_All._config._workerGrade = 0
end
function PaGlobal_WorkerRandomSelectOption_All:prepareClose()
  if nil == Panel_Window_WorkerRandomSelectOption_All or false == Panel_Window_WorkerRandomSelectOption_All:GetShow() then
    return
  end
  PaGlobal_WorkerRandomSelectOption_All:clearData()
  PaGlobal_WorkerRandomSelectOption_All:close()
end
function PaGlobal_WorkerRandomSelectOption_All:prepareOpen()
  if nil == Panel_Window_WorkerRandomSelectOption_All or true == Panel_Window_WorkerRandomSelectOption_All:GetShow() then
    return
  end
  PaGlobal_WorkerRandomSelectOption_All:clearData()
  PaGlobal_WorkerRandomSelectOption_All:open()
  PaGlobal_WorkerRandomSelectOption_All:onScreenResize()
  PaGlobal_WorkerRandomSelectOption_All:update()
end
function PaGlobal_WorkerRandomSelectOption_All:open()
  if nil == Panel_Window_WorkerRandomSelectOption_All then
    return
  end
  Panel_Window_WorkerRandomSelectOption_All:SetShow(true)
end
function PaGlobal_WorkerRandomSelectOption_All:close()
  if nil == Panel_Window_WorkerRandomSelectOption_All then
    return
  end
  Panel_Window_WorkerRandomSelectOption_All:SetShow(false)
end
function PaGlobal_WorkerRandomSelectOption_All:update()
  if nil == Panel_Window_WorkerRandomSelectOption_All then
    return
  end
  local config = PaGlobal_WorkerRandomSelectOption_All._config
  local gradeButtons = PaGlobal_WorkerRandomSelectOption_All._gradeButtons
  if nil ~= config._repetitionCount and config._repetitionCount > -1 then
    PaGlobal_WorkerRandomSelectOption_All._ui._txt_workerCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERRANDOMSELECT_COUNT", "count", tostring(config._repetitionCount)))
  end
  if nil ~= config._workerGrade and -1 < config._workerGrade then
    PaGlobal_WorkerRandomSelectOption_All:setGradeText(config._workerGrade)
    if nil ~= PaGlobal_WorkerRandomSelectOption_All._selectedButton then
      PaGlobal_WorkerRandomSelectOption_All._selectedButton:SetCheck(false)
    end
    PaGlobal_WorkerRandomSelectOption_All._selectedButton = gradeButtons[config._workerGrade]
    gradeButtons[config._workerGrade]:SetCheck(true)
  end
end
function PaGlobal_WorkerRandomSelectOption_All:setGradeText(idx)
  if nil ~= idx then
    if PaGlobal_WorkerRandomSelectOption_All._ENUM_GRADE._ALL == idx then
      PaGlobal_WorkerRandomSelectOption_All._ui._txt_WorkerGrade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERRANDOMSELECT_GRADE_ALL"))
    elseif PaGlobal_WorkerRandomSelectOption_All._ENUM_GRADE._NORMAL == idx then
      PaGlobal_WorkerRandomSelectOption_All._ui._txt_WorkerGrade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERRANDOMSELECT_GRADE_NORMAL"))
    elseif PaGlobal_WorkerRandomSelectOption_All._ENUM_GRADE._SKILLED == idx then
      PaGlobal_WorkerRandomSelectOption_All._ui._txt_WorkerGrade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERRANDOMSELECT_GRADE_SKILLED"))
    elseif PaGlobal_WorkerRandomSelectOption_All._ENUM_GRADE._EXPERT == idx then
      PaGlobal_WorkerRandomSelectOption_All._ui._txt_WorkerGrade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERRANDOMSELECT_GRADE_EXPERT"))
    elseif PaGlobal_WorkerRandomSelectOption_All._ENUM_GRADE._ONLYMASTER == idx then
      PaGlobal_WorkerRandomSelectOption_All._ui._txt_WorkerGrade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERRANDOMSELECT_GRADE_MASTER"))
    end
  end
end
