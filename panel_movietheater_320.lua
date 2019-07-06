local UI_TM = CppEnums.TextMode
value_Panel_MovieTheater_320_IsCheckedShow = false
Panel_MovieTheater_320:ActiveMouseEventEffect(true)
Panel_MovieTheater_320:setGlassBackground(true)
Panel_MovieTheater_320:SetShow(false, false)
Panel_MovieTheater_320:RegisterShowEventFunc(true, "Panel_MovieTheater320_ShowAni()")
Panel_MovieTheater_320:RegisterShowEventFunc(false, "PanelMovieTheater320_HideAni()")
function Panel_MovieTheater320_ShowAni()
  UIAni.AlphaAnimation(1, Panel_MovieTheater_320, 0, 0.15)
  Panel_MovieTheater_320:SetShow(true)
end
function Panel_MovieTheater320_HideAni()
  local aniInfo = UIAni.AlphaAnimation(0, Panel_MovieTheater_320, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local isMoviePlay = false
local _btn_Close = UI.getChildControl(Panel_MovieTheater_320, "Button_Close")
local _btn_Replay = UI.getChildControl(Panel_MovieTheater_320, "Button_Replay")
local _btn_Nomore = UI.getChildControl(Panel_MovieTheater_320, "Button_Nomore")
local _txt_Title = UI.getChildControl(Panel_MovieTheater_320, "StaticText_Title")
local _movieTheater_320 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_MovieTheater_320, "WebControl_SkillGuide")
local helpBubble = UI.getChildControl(Panel_MovieTheater_320, "Static_HelpBubble")
local helpMsg = UI.getChildControl(Panel_MovieTheater_320, "StaticText_HelpMsg")
local _comboList = UI.getChildControl(Panel_MovieTheater_320, "StaticText_ComboList")
local messageUI = {
  _messageBox = UI.getChildControl(Panel_MovieTheater_MessageBox, "Static_MessageBox"),
  _message_Title = UI.getChildControl(Panel_MovieTheater_MessageBox, "Static_Text_Title"),
  _messageText = UI.getChildControl(Panel_MovieTheater_MessageBox, "Static_Text"),
  _btn_Yes = UI.getChildControl(Panel_MovieTheater_MessageBox, "Button_Yes"),
  _btn_No = UI.getChildControl(Panel_MovieTheater_MessageBox, "Button_No")
}
_btn_Close:addInputEvent("Mouse_LUp", "Panel_MovieTheater320_JustClose()")
_btn_Replay:addInputEvent("Mouse_LUp", "Panel_MovieTheater320_Replay()")
_btn_Nomore:addInputEvent("Mouse_LUp", "Panel_MovieTheater320_MessageBox()")
_movieTheater_320:addInputEvent("Mouse_Out", "Panel_MovieTheater320_HideControl()")
_movieTheater_320:addInputEvent("Mouse_On", "Panel_MovieTheater320_ShowControl()")
function Panel_MovieTheater320_Initialize()
  _movieTheater_320:SetPosX(5)
  _movieTheater_320:SetPosY(50)
  _movieTheater_320:ResetUrl()
  Panel_MovieTheater_320:SetSize(Panel_MovieTheater_320:GetSizeX(), 317)
  Panel_MovieTheater320_ResetMessageBox()
end
function Panel_MovieTheater320_ResetMessageBox()
  Panel_MovieTheater_MessageBox:SetShow(false)
  for _, v in pairs(messageUI) do
    v:SetShow(false)
  end
end
local playedNo = 0
local warriorText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_WARRIORTEXT")
local rangerText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_RANGERTEXT")
local sorcererText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_SORCERERTEXT")
local giantText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_GIANTTEXT")
local tamerText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_TAMERTEXT")
local bladerText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_BLADERTEXT")
local valkyrieText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_VALKYRIETEXT")
local bladerWomenText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_BLADERWOMENTEXT")
local wizardWomenText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_WIZARDWOMENTEXT")
local wizardText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_WIZARDTEXT")
local ninjaWomenText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_NINJAWOMENTEXT")
local ninjaNanText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_NINJAMANTEXT")
local darkelfText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_DARKELFTEXT")
local combattantText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBATTANT")
local combattantWomenText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBATTANTWOMEN")
local comboDesc = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_0"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_2"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_3"),
  [16] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_16"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_4"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_5"),
  [6] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_6"),
  [7] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_7"),
  [17] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_17"),
  [8] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_8"),
  [9] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_9"),
  [10] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_10"),
  [11] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_11"),
  [18] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_18"),
  [12] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_12"),
  [13] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_13"),
  [14] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_14"),
  [15] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_15"),
  [19] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_19"),
  [20] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_20"),
  [21] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_21"),
  [22] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_22"),
  [23] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_23"),
  [24] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_24"),
  [25] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_25"),
  [26] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_26"),
  [27] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_27"),
  [28] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_28"),
  [29] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_29"),
  [30] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_30"),
  [31] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_31"),
  [32] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_32"),
  [33] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_33"),
  [34] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_34"),
  [35] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_35"),
  [36] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_36"),
  [37] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_37"),
  [38] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_38"),
  [39] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_39"),
  [40] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_40"),
  [41] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_41"),
  [42] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_42"),
  [43] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_43"),
  [44] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_44"),
  [45] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_45"),
  [46] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_46"),
  [47] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_47"),
  [48] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_48"),
  [49] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_49"),
  [50] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_45"),
  [51] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_46"),
  [52] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_47"),
  [53] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_50"),
  [54] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_51"),
  [55] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_55"),
  [56] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_56"),
  [57] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_57"),
  [58] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_58"),
  [59] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_59"),
  [60] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_93"),
  [61] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_94"),
  [62] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_95"),
  [63] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_96"),
  [64] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_97"),
  [65] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_60"),
  [66] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_61"),
  [67] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_62"),
  [68] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_63"),
  [69] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_64"),
  [70] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_65"),
  [71] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_66"),
  [72] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_67"),
  [73] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_68"),
  [74] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_69"),
  [75] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_70"),
  [76] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_71"),
  [77] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_72"),
  [78] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_73"),
  [79] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_74"),
  [80] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_75"),
  [81] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_76"),
  [82] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_77"),
  [83] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_78"),
  [84] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_79"),
  [85] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_80"),
  [86] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_81"),
  [87] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_82"),
  [88] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_83"),
  [89] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_84"),
  [90] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_85"),
  [91] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_86"),
  [92] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_87"),
  [93] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_88"),
  [94] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_89"),
  [95] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_90"),
  [96] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_91"),
  [97] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_92"),
  [98] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_98"),
  [99] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_99"),
  [100] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_100"),
  [101] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_101"),
  [102] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_102")
}
function Panel_MovieTheater320_JustClose()
  Panel_MovieTheater_320:SetShow(false)
  _movieTheater_320:ResetUrl()
  isMoviePlay = false
end
local isFirstPlay = true
function Panel_MovieTheater320_ShowToggle()
  if Panel_MovieTheater_MessageBox:IsShow() == true then
    return
  end
  if isGameTypeKR2() then
    return
  end
  value_Panel_MovieTheater_320_IsCheckedShow = true
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local UI_classType = CppEnums.ClassType
  local isWarrior = UI_classType.ClassType_Warrior == player:getClassType()
  local isRanger = UI_classType.ClassType_Ranger == player:getClassType()
  local isSorcerer = UI_classType.ClassType_Sorcerer == player:getClassType()
  local isGiant = UI_classType.ClassType_Giant == player:getClassType()
  local isTamer = UI_classType.ClassType_Tamer == player:getClassType()
  local isBlader = UI_classType.ClassType_BladeMaster == player:getClassType()
  local isValkyrie = UI_classType.ClassType_Valkyrie == player:getClassType()
  local isBladerWomen = UI_classType.ClassType_BladeMasterWomen == player:getClassType()
  local isWizard = UI_classType.ClassType_Wizard == player:getClassType()
  local isWizardWomen = UI_classType.ClassType_WizardWomen == player:getClassType()
  local isNinjaWomen = UI_classType.ClassType_NinjaWomen == player:getClassType()
  local isNinjaMan = UI_classType.ClassType_NinjaMan == player:getClassType()
  local isDarkElf = UI_classType.ClassType_DarkElf == player:getClassType()
  local isCombattant = UI_classType.ClassType_Combattant == player:getClassType()
  local isCombattantWomen = UI_classType.ClassType_CombattantWomen == player:getClassType()
  local playerGet = player:get()
  local playerLevel = playerGet:getLevel()
  local isShow = Panel_MovieTheater_320:IsShow()
  local gameOptionSetting = ToClient_getGameOptionControllerWrapper()
  if false == gameOptionSetting:getShowComboGuide() and false == isShow then
    return
  end
  if playerLevel >= 36 or playerLevel <= 6 then
    return
  end
  if false == isShow then
    _movieTheater_320:SetUrl(320, 240, "coui://UI_Data/UI_Html/UI_Guide_Movie.html")
  end
  helpBubble:SetShow(true)
  helpMsg:SetShow(true)
  helpMsg:SetAutoResize(true)
  helpMsg:SetTextMode(UI_TM.eTextMode_AutoWrap)
  local isShow = false
  if isWarrior == true then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISWARRIOR"))
  elseif isRanger == true then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISRANGER"))
  elseif isSorcerer == true then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISSORCERER"))
  elseif isGiant == true then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISGIANT"))
  elseif isTamer == true then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISTAMER"))
  elseif isBlader == true then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISBLADER"))
  elseif isValkyrie == true then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISVALKYRIE"))
  elseif isBladerWomen == true then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISBLADERWOMEN"))
  elseif true == isWizard or true == isWizardWomen then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISWIZARD"))
  elseif true == isNinjaWomen then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISNINJAWOMEN"))
  elseif true == isNinjaMan then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISNINJAMAN"))
  elseif true == isDarkElf then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISDARKELF"))
  elseif true == isCombattant then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISCOMBATTANT"))
  elseif true == isCombattantWomen then
    isShow = true
    helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISCOMBATTANTWOMEN"))
  end
  helpBubble:SetSize(helpBubble:GetSizeX(), helpMsg:GetTextSizeY() + 35)
  _movieTheater_320:SetSize(320, 240)
  _comboList:SetTextMode(UI_TM.eTextMode_AutoWrap)
  _comboList:SetPosX(5)
  _comboList:SetPosY(_movieTheater_320:GetPosY() + _movieTheater_320:GetSizeY() + 5)
  _comboList:SetSize(_movieTheater_320:GetSizeX(), _comboList:GetTextSizeY() + 7)
  if isFirstPlay then
    isFirstPlay = false
    _comboList:SetText("")
  end
  Panel_MovieTheater_320:SetPosX(getScreenSizeX() - Panel_MovieTheater_320:GetSizeX() - 7)
  Panel_MovieTheater_320:SetPosY(getScreenSizeY() - Panel_MovieTheater_320:GetSizeY() - Panel_QuickSlot:GetSizeY())
  Panel_MovieTheater_320:SetShow(isShow, false)
  _txt_Title:SetSize(Panel_MovieTheater_320:GetSizeX() - 8, _txt_Title:GetSizeY())
  _txt_Title:ComputePos()
  _btn_Close:ComputePos()
  _btn_Replay:addInputEvent("Mouse_LUp", "Panel_MovieTheater320_Replay()")
  _btn_Nomore:SetShow(isShow)
  isMoviePlay = isShow
end
function Panel_MovieTheater320_TriggerEvent()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local UI_classType = CppEnums.ClassType
  local isWarrior = UI_classType.ClassType_Warrior == player:getClassType()
  local isRanger = UI_classType.ClassType_Ranger == player:getClassType()
  local isSorcerer = UI_classType.ClassType_Sorcerer == player:getClassType()
  local isGiant = UI_classType.ClassType_Giant == player:getClassType()
  local isTamer = UI_classType.ClassType_Tamer == player:getClassType()
  local isBlader = UI_classType.ClassType_BladeMaster == player:getClassType()
  local isValkyrie = UI_classType.ClassType_Valkyrie == player:getClassType()
  local isBladerWomen = UI_classType.ClassType_BladeMasterWomen == player:getClassType()
  local isWizard = UI_classType.ClassType_Wizard == player:getClassType()
  local isWizardWomen = UI_classType.ClassType_WizardWomen == player:getClassType()
  local isNinjaWomen = UI_classType.ClassType_NinjaWomen == player:getClassType()
  local isNinjaMan = UI_classType.ClassType_NinjaMan == player:getClassType()
  local isDarkelf = UI_classType.ClassType_DarkElf == player:getClassType()
  local isCombattant = UI_classType.ClassType_Combattant == player:getClassType()
  local isCombattantWomen = UI_classType.ClassType_CombattantWomen == player:getClassType()
  local playerGet = player:get()
  local playerLevel = playerGet:getLevel()
  if isWarrior then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", warriorText))
        _comboList:SetText(comboDesc[65])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", warriorText))
        _comboList:SetText(comboDesc[0])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/100.webm")
      playedNo = 100
    elseif playerLevel >= 16 and playerLevel <= 20 then
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", warriorText))
        _comboList:SetText(comboDesc[66])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", warriorText))
        _comboList:SetText(comboDesc[1])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/101.webm")
      playedNo = 101
    elseif playerLevel >= 21 and playerLevel <= 25 then
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", warriorText))
        _comboList:SetText(comboDesc[67])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", warriorText))
        _comboList:SetText(comboDesc[2])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/102.webm")
      playedNo = 102
    elseif playerLevel >= 26 and playerLevel <= 30 then
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", warriorText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/103.webm")
      _comboList:SetText(comboDesc[3])
      playedNo = 103
    elseif playerLevel >= 31 and playerLevel <= 35 then
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", warriorText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/104.webm")
      _comboList:SetText(comboDesc[16])
      playedNo = 104
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isRanger then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", rangerText))
        _comboList:SetText(comboDesc[68])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", rangerText))
        _comboList:SetText(comboDesc[4])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/200.webm")
      playedNo = 200
    elseif playerLevel >= 16 and playerLevel <= 20 then
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", rangerText))
        _comboList:SetText(comboDesc[69])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", rangerText))
        _comboList:SetText(comboDesc[5])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/201.webm")
      playedNo = 201
    elseif playerLevel >= 21 and playerLevel <= 25 then
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", rangerText))
        _comboList:SetText(comboDesc[70])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", rangerText))
        _comboList:SetText(comboDesc[6])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/202.webm")
      playedNo = 202
    elseif playerLevel >= 26 and playerLevel <= 30 then
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", rangerText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/203.webm")
      _comboList:SetText(comboDesc[7])
      playedNo = 203
    elseif playerLevel >= 31 and playerLevel <= 35 then
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", rangerText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/204.webm")
      _comboList:SetText(comboDesc[17])
      playedNo = 204
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isSorcerer then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", sorcererText))
        _comboList:SetText(comboDesc[71])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", sorcererText))
        _comboList:SetText(comboDesc[8])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/300.webm")
      playedNo = 300
    elseif playerLevel >= 16 and playerLevel <= 20 then
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", sorcererText))
        _comboList:SetText(comboDesc[72])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", sorcererText))
        _comboList:SetText(comboDesc[9])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/301.webm")
      playedNo = 301
    elseif playerLevel >= 21 and playerLevel <= 25 then
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", sorcererText))
        _comboList:SetText(comboDesc[73])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", sorcererText))
        _comboList:SetText(comboDesc[10])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/302.webm")
      playedNo = 302
    elseif playerLevel >= 26 and playerLevel <= 30 then
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", sorcererText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/303.webm")
      _comboList:SetText(comboDesc[11])
      playedNo = 303
    elseif playerLevel >= 31 and playerLevel <= 35 then
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", sorcererText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/304.webm")
      _comboList:SetText(comboDesc[18])
      playedNo = 304
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isGiant then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", giantText))
        _comboList:SetText(comboDesc[74])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", giantText))
        _comboList:SetText(comboDesc[12])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/400.webm")
      playedNo = 400
    elseif playerLevel >= 16 and playerLevel <= 20 then
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", giantText))
        _comboList:SetText(comboDesc[75])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", giantText))
        _comboList:SetText(comboDesc[13])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/401.webm")
      playedNo = 401
    elseif playerLevel >= 21 and playerLevel <= 25 then
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", giantText))
        _comboList:SetText(comboDesc[76])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", giantText))
        _comboList:SetText(comboDesc[14])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/402.webm")
      playedNo = 402
    elseif playerLevel >= 26 and playerLevel <= 30 then
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", giantText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/403.webm")
      _comboList:SetText(comboDesc[15])
      playedNo = 403
    elseif playerLevel >= 31 and playerLevel <= 35 then
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", giantText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/404.webm")
      _comboList:SetText(comboDesc[19])
      playedNo = 404
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isTamer then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      playedNo = 500
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", tamerText))
        _comboList:SetText(comboDesc[77])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", tamerText))
        _comboList:SetText(comboDesc[20])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 16 and playerLevel <= 20 then
      playedNo = 501
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", tamerText))
        _comboList:SetText(comboDesc[78])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", tamerText))
        _comboList:SetText(comboDesc[21])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 21 and playerLevel <= 25 then
      playedNo = 502
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", tamerText))
        _comboList:SetText(comboDesc[79])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", tamerText))
        _comboList:SetText(comboDesc[22])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 26 and playerLevel <= 30 then
      playedNo = 503
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", tamerText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[23])
    elseif playerLevel >= 31 and playerLevel <= 35 then
      playedNo = 504
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", tamerText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[24])
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isBlader then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      playedNo = 600
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", bladerText))
        _comboList:SetText(comboDesc[86])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerText))
        _comboList:SetText(comboDesc[25])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 16 and playerLevel <= 20 then
      playedNo = 601
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", bladerText))
        _comboList:SetText(comboDesc[87])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerText))
        _comboList:SetText(comboDesc[26])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 21 and playerLevel <= 25 then
      playedNo = 602
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", bladerText))
        _comboList:SetText(comboDesc[88])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerText))
        _comboList:SetText(comboDesc[27])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 26 and playerLevel <= 30 then
      playedNo = 603
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", bladerText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[28])
    elseif playerLevel >= 31 and playerLevel <= 35 then
      playedNo = 604
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", bladerText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[29])
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isValkyrie then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      playedNo = 700
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", valkyrieText))
        _comboList:SetText(comboDesc[83])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", valkyrieText))
        _comboList:SetText(comboDesc[30])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 16 and playerLevel <= 20 then
      playedNo = 701
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", valkyrieText))
        _comboList:SetText(comboDesc[84])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", valkyrieText))
        _comboList:SetText(comboDesc[31])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 21 and playerLevel <= 25 then
      playedNo = 702
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", valkyrieText))
        _comboList:SetText(comboDesc[85])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", valkyrieText))
        _comboList:SetText(comboDesc[32])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 26 and playerLevel <= 30 then
      playedNo = 703
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", valkyrieText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[33])
    elseif playerLevel >= 31 and playerLevel <= 35 then
      playedNo = 704
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", valkyrieText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[34])
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isBladerWomen then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      playedNo = 800
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", bladerWomenText))
        _comboList:SetText(comboDesc[89])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", bladerWomenText))
        _comboList:SetText(comboDesc[35])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 16 and playerLevel <= 20 then
      playedNo = 801
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", bladerWomenText))
        _comboList:SetText(comboDesc[90])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", bladerWomenText))
        _comboList:SetText(comboDesc[36])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 21 and playerLevel <= 25 then
      playedNo = 802
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", bladerWomenText))
        _comboList:SetText(comboDesc[91])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerWomenText))
        _comboList:SetText(comboDesc[37])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 26 and playerLevel <= 30 then
      playedNo = 803
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", bladerWomenText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[38])
    elseif playerLevel >= 31 and playerLevel <= 35 then
      playedNo = 804
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", bladerWomenText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[39])
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isWizard then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      playedNo = 900
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", wizardText))
        _comboList:SetText(comboDesc[80])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardText))
        _comboList:SetText(comboDesc[40])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 16 and playerLevel <= 20 then
      playedNo = 901
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", wizardText))
        _comboList:SetText(comboDesc[81])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardText))
        _comboList:SetText(comboDesc[41])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 21 and playerLevel <= 25 then
      playedNo = 902
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", wizardText))
        _comboList:SetText(comboDesc[82])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", wizardText))
        _comboList:SetText(comboDesc[42])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 26 and playerLevel <= 30 then
      playedNo = 903
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", wizardText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[43])
    elseif playerLevel >= 31 and playerLevel <= 35 then
      playedNo = 904
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", wizardText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[44])
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isWizardWomen then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      playedNo = 900
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", wizardWomenText))
        _comboList:SetText(comboDesc[80])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardWomenText))
        _comboList:SetText(comboDesc[40])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 16 and playerLevel <= 20 then
      playedNo = 901
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", wizardWomenText))
        _comboList:SetText(comboDesc[81])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardWomenText))
        _comboList:SetText(comboDesc[41])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 21 and playerLevel <= 25 then
      playedNo = 902
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", wizardWomenText))
        _comboList:SetText(comboDesc[82])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", wizardWomenText))
        _comboList:SetText(comboDesc[42])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 26 and playerLevel <= 30 then
      playedNo = 903
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", wizardWomenText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[43])
    elseif playerLevel >= 31 and playerLevel <= 35 then
      playedNo = 904
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", wizardWomenText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[44])
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isNinjaWomen then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      playedNo = 1001
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", ninjaWomenText))
        _comboList:SetText(comboDesc[92])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaWomenText))
        _comboList:SetText(comboDesc[45])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 16 and playerLevel <= 20 then
      playedNo = 1002
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", ninjaWomenText))
        _comboList:SetText(comboDesc[93])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaWomenText))
        _comboList:SetText(comboDesc[46])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 21 and playerLevel <= 25 then
      playedNo = 1003
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", ninjaWomenText))
        _comboList:SetText(comboDesc[94])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", ninjaWomenText))
        _comboList:SetText(comboDesc[47])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 26 and playerLevel <= 30 then
      playedNo = 1004
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", ninjaWomenText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[48])
    elseif playerLevel >= 31 and playerLevel <= 35 then
      playedNo = 1005
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", ninjaWomenText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[49])
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isNinjaMan then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      playedNo = 1100
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", ninjaManText))
        _comboList:SetText(comboDesc[95])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaManText))
        _comboList:SetText(comboDesc[50])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 16 and playerLevel <= 20 then
      playedNo = 1101
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", ninjaManText))
        _comboList:SetText(comboDesc[96])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaManText))
        _comboList:SetText(comboDesc[51])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 21 and playerLevel <= 25 then
      playedNo = 1102
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", ninjaManText))
        _comboList:SetText(comboDesc[97])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", ninjaManText))
        _comboList:SetText(comboDesc[52])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 26 and playerLevel <= 30 then
      playedNo = 1103
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", ninjaManText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[53])
    elseif playerLevel >= 31 and playerLevel <= 35 then
      playedNo = 1104
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", ninjaManText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[54])
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isDarkelf then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      playedNo = 1200
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", darkelfText))
        _comboList:SetText(comboDesc[55])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", darkelfText))
        _comboList:SetText(comboDesc[55])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 16 and playerLevel <= 20 then
      playedNo = 1201
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", darkelfText))
        _comboList:SetText(comboDesc[56])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", darkelfText))
        _comboList:SetText(comboDesc[56])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 21 and playerLevel <= 25 then
      playedNo = 1202
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", darkelfText))
        _comboList:SetText(comboDesc[57])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", darkelfText))
        _comboList:SetText(comboDesc[57])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 26 and playerLevel <= 30 then
      playedNo = 1203
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", darkelfText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[58])
    elseif playerLevel >= 31 and playerLevel <= 35 then
      playedNo = 1204
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", darkelfText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[59])
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isCombattant then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      playedNo = 1300
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", combattantText))
        _comboList:SetText(comboDesc[60])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", combattantText))
        _comboList:SetText(comboDesc[60])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 16 and playerLevel <= 20 then
      playedNo = 1301
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", combattantText))
        _comboList:SetText(comboDesc[61])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", combattantText))
        _comboList:SetText(comboDesc[61])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 21 and playerLevel <= 25 then
      playedNo = 1302
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", combattantText))
        _comboList:SetText(comboDesc[62])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", combattantText))
        _comboList:SetText(comboDesc[62])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 26 and playerLevel <= 30 then
      playedNo = 1303
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", combattantText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[63])
    elseif playerLevel >= 31 and playerLevel <= 35 then
      playedNo = 1304
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", combattantText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[64])
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  elseif isCombattantWomen then
    if playerLevel <= 6 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    elseif playerLevel >= 7 and playerLevel <= 15 then
      playedNo = 1400
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", combattantWomenTextText))
        _comboList:SetText(comboDesc[98])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", combattantWomenTextText))
        _comboList:SetText(comboDesc[98])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 16 and playerLevel <= 20 then
      playedNo = 1401
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", combattantWomenTextText))
        _comboList:SetText(comboDesc[99])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", combattantWomenTextText))
        _comboList:SetText(comboDesc[99])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 21 and playerLevel <= 25 then
      playedNo = 1402
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", combattantWomenTextText))
        _comboList:SetText(comboDesc[100])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", combattantWomenTextText))
        _comboList:SetText(comboDesc[100])
      end
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif playerLevel >= 26 and playerLevel <= 30 then
      playedNo = 1403
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", combattantWomenTextText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[101])
    elseif playerLevel >= 31 and playerLevel <= 35 then
      playedNo = 1404
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", combattantWomenTextText))
      _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[102])
    elseif playerLevel >= 36 then
      Panel_MovieTheater_320:SetShow(false, false)
      helpBubble:SetShow(false)
      helpMsg:SetShow(false)
    end
  end
  _comboList:SetSize(_movieTheater_320:GetSizeX(), _comboList:GetTextSizeY() + 7)
  Panel_MovieTheater_320:SetSize(Panel_MovieTheater_320:GetSizeX(), _comboList:GetPosY() + _comboList:GetSizeY() + _btn_Nomore:GetSizeY() + 15)
  _btn_Nomore:ComputePos()
  _btn_Replay:ComputePos()
  Panel_MovieTheater_320:SetPosX(getScreenSizeX() - Panel_MovieTheater_320:GetSizeX() - 7)
  Panel_MovieTheater_320:SetPosY(getScreenSizeY() - Panel_MovieTheater_320:GetSizeY() - Panel_QuickSlot:GetSizeY())
  _txt_Title:SetSize(Panel_MovieTheater_320:GetSizeX() - 8, _txt_Title:GetSizeY())
  _txt_Title:ComputePos()
  _btn_Close:ComputePos()
end
function Panel_MovieTheater320_Replay()
  if playedNo == 100 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 101 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 102 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 103 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 104 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 200 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 201 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 202 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 203 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 204 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 300 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 301 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 302 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 303 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 304 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 400 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 401 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 402 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 403 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 404 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 500 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 501 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 502 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 503 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 504 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 600 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 601 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 602 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 603 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 604 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 700 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 701 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 702 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 703 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 704 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 800 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 801 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 802 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 803 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 804 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 900 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 901 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 902 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 903 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 904 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1001 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1002 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1003 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1004 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1005 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1100 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1101 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1102 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1103 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1104 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1200 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1201 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1202 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1203 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1204 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1300 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1301 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1302 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1303 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1304 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1400 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1401 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1402 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1403 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1404 then
    _movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  end
end
function Panel_MovieTheater320_MessageBox()
  Panel_MovieTheater_320:SetShow(true)
  isComboMovieClosedCount = 0
  value_Panel_MovieTheater_320_IsCheckedShow = false
  Panel_MovieTheater_MessageBox:SetPosX(getScreenSizeX() - Panel_MovieTheater_MessageBox:GetSizeX() - 7)
  Panel_MovieTheater_MessageBox:SetPosY(getScreenSizeY() - Panel_MovieTheater_320:GetSizeY() - Panel_QuickSlot:GetSizeY())
  Panel_MovieTheater_MessageBox:SetShow(true)
  for _, v in pairs(messageUI) do
    v:SetShow(true)
    v:ComputePos()
  end
  messageUI._btn_Yes:addInputEvent("Mouse_LUp", "Panel_MovieTheater320_Clicked_Func( true )")
  messageUI._btn_No:addInputEvent("Mouse_LUp", "Panel_MovieTheater320_Clicked_Func( false )")
end
function Panel_MovieTheater320_Clicked_Func(isYes)
  if isYes == true then
    GameOption_ComboGuideValueChange(false)
    setShowComboGuide(false)
    GameOption_UpdateOptionChanged()
    _currentSpiritGuideCheck = false
    saveGameOption(false)
    Panel_MovieTheater_320:SetShow(false)
    Panel_MovieTheater_MessageBox:SetShow(false)
  else
    Panel_MovieTheater_320:SetShow(false)
    Panel_MovieTheater_MessageBox:SetShow(false)
  end
  _movieTheater_320:ResetUrl()
  isMoviePlay = false
end
local updateTime = 0
function UpdateMovieTheater320(deltaTime)
  if not isMoviePlay then
    return
  end
  updateTime = updateTime + deltaTime
  if updateTime > 1 and _movieTheater_320:isReadyView() then
    Panel_MovieTheater320_TriggerEvent()
    isMoviePlay = false
    updateTime = 0
  end
  if updateTime > 3 then
    isMoviePlay = true
    updateTime = 0
  end
end
function Panel_MovieTheater320_ShowControl()
  _movieTheater_320:TriggerEvent("ShowControl", "true")
end
function Panel_MovieTheater320_HideControl()
  _movieTheater_320:TriggerEvent("ShowControl", "false")
end
Panel_MovieTheater320_Initialize()
Panel_MovieTheater_320:RegisterUpdateFunc("UpdateMovieTheater320")
