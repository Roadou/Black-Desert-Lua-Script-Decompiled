local UI_TM = CppEnums.TextMode
value_Panel_MovieTheater_SkillGuide_640_IsCheckedShow = false
Panel_MovieTheater_SkillGuide_640:ActiveMouseEventEffect(true)
Panel_MovieTheater_SkillGuide_640:setGlassBackground(true)
Panel_MovieTheater_SkillGuide_640:SetShow(false, false)
Panel_MovieTheater_SkillGuide_640:RegisterShowEventFunc(true, "Panel_MovieTheater320_ShowAni()")
Panel_MovieTheater_SkillGuide_640:RegisterShowEventFunc(false, "PanelMovieTheater320_HideAni()")
function Panel_MovieTheater320_ShowAni()
  UIAni.AlphaAnimation(1, Panel_MovieTheater_SkillGuide_640, 0, 0.15)
  Panel_MovieTheater_SkillGuide_640:SetShow(true)
end
function Panel_MovieTheater320_HideAni()
  local aniInfo = UIAni.AlphaAnimation(0, Panel_MovieTheater_SkillGuide_640, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local _btn_Close = UI.getChildControl(Panel_MovieTheater_SkillGuide_640, "Button_Close")
local _btn_Replay = UI.getChildControl(Panel_MovieTheater_SkillGuide_640, "Button_Replay")
local _txt_Title = UI.getChildControl(Panel_MovieTheater_SkillGuide_640, "StaticText_Title")
local _movieTheater_640 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_MovieTheater_SkillGuide_640, "WebControl_SkillGuide")
local helpBubble = UI.getChildControl(Panel_MovieTheater_SkillGuide_640, "Static_HelpBubble")
local helpMsg = UI.getChildControl(Panel_MovieTheater_SkillGuide_640, "StaticText_HelpMsg")
local _comboList = UI.getChildControl(Panel_MovieTheater_SkillGuide_640, "StaticText_ComboList")
local messageUI = {
  _messageBox = UI.getChildControl(Panel_MovieTheater_MessageBox, "Static_MessageBox"),
  _message_Title = UI.getChildControl(Panel_MovieTheater_MessageBox, "Static_Text_Title"),
  _messageText = UI.getChildControl(Panel_MovieTheater_MessageBox, "Static_Text"),
  _btn_Yes = UI.getChildControl(Panel_MovieTheater_MessageBox, "Button_Yes"),
  _btn_No = UI.getChildControl(Panel_MovieTheater_MessageBox, "Button_No")
}
_btn_Close:addInputEvent("Mouse_LUp", "Panel_MovieTheater_SkillGuide_640_JustClose()")
_btn_Replay:addInputEvent("Mouse_LUp", "Panel_MovieTheater_SkillGuide_640_Replay()")
_movieTheater_640:addInputEvent("Mouse_Out", "Panel_MovieTheater_SkillGuide_640_HideControl()")
_movieTheater_640:addInputEvent("Mouse_On", "Panel_MovieTheater_SkillGuide_640_ShowControl()")
function Panel_MovieTheater_SkillGuide_640_Initialize()
  _movieTheater_640:SetPosX(5)
  _movieTheater_640:SetPosY(38)
  _movieTheater_640:SetUrl(640, 480, "coui://UI_Data/UI_Html/UI_Guide_Movie_640.html")
  Panel_MovieTheater_SkillGuide_640:SetSize(Panel_MovieTheater_SkillGuide_640:GetSizeX(), 317)
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
local bladerWomenText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_BLADERWOMENTEXT")
local valkyrieText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_VALKYRIETEXT")
local wizardWomenText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_WIZARDWOMENTEXT")
local wizardText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_WIZARDTEXT")
local ninjaWomenText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_NINJAWOMENTEXT")
local ninjaManText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_NINJAMANTEXT")
local darkelfText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_DARKELFTEXT")
local combattantText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBATTANT")
local combattantWomenText = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBATTANTWOMEN")
local comboDesc = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_0"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_2"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_3"),
  [16] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_16"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_4"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_5"),
  [6] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_6"),
  [7] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_7"),
  [17] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_17"),
  [8] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_8"),
  [9] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_9"),
  [10] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_10"),
  [11] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_11"),
  [18] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_18"),
  [12] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_12"),
  [13] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_13"),
  [14] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_14"),
  [15] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_15"),
  [19] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_19"),
  [20] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_20"),
  [21] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_21"),
  [22] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_22"),
  [23] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_23"),
  [24] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_24"),
  [25] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_25"),
  [26] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_26"),
  [27] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_27"),
  [28] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_28"),
  [29] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_29"),
  [30] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_30"),
  [31] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_31"),
  [32] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_32"),
  [33] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_33"),
  [34] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_34"),
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
  [45] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_40"),
  [46] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_41"),
  [47] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_42"),
  [48] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_43"),
  [49] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_44"),
  [50] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_45"),
  [51] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_46"),
  [52] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_47"),
  [53] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_48"),
  [54] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_49"),
  [55] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_45"),
  [56] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_46"),
  [57] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_47"),
  [58] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_50"),
  [59] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_51"),
  [60] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_55"),
  [61] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_56"),
  [62] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_57"),
  [63] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_58"),
  [64] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_59"),
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
  [98] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_93"),
  [99] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_94"),
  [100] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_95"),
  [101] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_96"),
  [102] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_97"),
  [103] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_98"),
  [104] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_99"),
  [105] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_100"),
  [106] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_101"),
  [107] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_102")
}
function Panel_MovieTheater_SkillGuide_640_JustClose()
  if not Panel_MovieTheater_SkillGuide_640:GetShow() then
    return
  end
  Panel_MovieTheater_SkillGuide_640:SetShow(false)
end
function FGlobal_Panel_MovieTheater_SkillGuide_640_UrlReset()
  _movieTheater_640:ResetUrl()
end
function Panel_MovieTheaterSkillGuide640_ShowToggle(classNo, titleNo)
  Panel_MovieTheater_MessageBox:SetShow(false)
  for _, v in pairs(messageUI) do
    v:SetShow(false)
  end
  if not _movieTheater_640:isReadyView() then
    return
  end
  helpBubble:SetShow(false)
  helpMsg:SetShow(false)
  local isShow = Panel_MovieTheater_SkillGuide_640:IsShow()
  _movieTheater_640:SetSize(640, 480)
  if isShow == true then
    Panel_MovieTheater_SkillGuide_640:SetShow(false, false)
  else
    Panel_MovieTheater_SkillGuide_640:SetShow(true, false)
  end
  _comboList:SetSize(635, _comboList:GetTextSizeY() + 7)
  _comboList:SetTextMode(UI_TM.eTextMode_AutoWrap)
  if classNo == 0 then
    if titleNo == 0 then
      playedNo = 100
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", warriorText))
        _comboList:SetText(comboDesc[65])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", warriorText))
        _comboList:SetText(comboDesc[0])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 1 then
      playedNo = 101
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", warriorText))
        _comboList:SetText(comboDesc[66])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", warriorText))
        _comboList:SetText(comboDesc[1])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 2 then
      playedNo = 102
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", warriorText))
        _comboList:SetText(comboDesc[67])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", warriorText))
        _comboList:SetText(comboDesc[2])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 3 then
      playedNo = 103
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", warriorText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[3])
    elseif titleNo == 4 then
      playedNo = 104
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", warriorText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[16])
    end
  elseif classNo == 4 then
    if titleNo == 0 then
      playedNo = 200
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", rangerText))
        _comboList:SetText(comboDesc[68])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", rangerText))
        _comboList:SetText(comboDesc[4])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 1 then
      playedNo = 201
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", rangerText))
        _comboList:SetText(comboDesc[69])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", rangerText))
        _comboList:SetText(comboDesc[5])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 2 then
      playedNo = 202
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", rangerText))
        _comboList:SetText(comboDesc[70])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", rangerText))
        _comboList:SetText(comboDesc[6])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 3 then
      playedNo = 203
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", rangerText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[7])
    elseif titleNo == 4 then
      playedNo = 204
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", rangerText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[17])
    end
  elseif classNo == 8 then
    if titleNo == 0 then
      playedNo = 300
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", sorcererText))
        _comboList:SetText(comboDesc[71])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", sorcererText))
        _comboList:SetText(comboDesc[8])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 1 then
      playedNo = 301
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", sorcererText))
        _comboList:SetText(comboDesc[72])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", sorcererText))
        _comboList:SetText(comboDesc[9])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 2 then
      playedNo = 302
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", sorcererText))
        _comboList:SetText(comboDesc[73])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", sorcererText))
        _comboList:SetText(comboDesc[10])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 3 then
      playedNo = 303
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", sorcererText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[11])
    elseif titleNo == 4 then
      playedNo = 304
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", sorcererText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[18])
    end
  elseif classNo == 12 then
    if titleNo == 0 then
      playedNo = 400
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", giantText))
        _comboList:SetText(comboDesc[74])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", giantText))
        _comboList:SetText(comboDesc[12])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 1 then
      playedNo = 401
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", giantText))
        _comboList:SetText(comboDesc[75])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", giantText))
        _comboList:SetText(comboDesc[13])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 2 then
      playedNo = 402
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", giantText))
        _comboList:SetText(comboDesc[76])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", giantText))
        _comboList:SetText(comboDesc[14])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 3 then
      playedNo = 403
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", giantText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[15])
    elseif titleNo == 4 then
      playedNo = 404
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", giantText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[19])
    end
  elseif classNo == 16 then
    if titleNo == 0 then
      playedNo = 500
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", tamerText))
        _comboList:SetText(comboDesc[77])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", tamerText))
        _comboList:SetText(comboDesc[20])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 1 then
      playedNo = 501
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", tamerText))
        _comboList:SetText(comboDesc[78])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", tamerText))
        _comboList:SetText(comboDesc[21])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 2 then
      playedNo = 502
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", tamerText))
        _comboList:SetText(comboDesc[79])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", tamerText))
        _comboList:SetText(comboDesc[22])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 3 then
      playedNo = 503
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", tamerText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[23])
    elseif titleNo == 4 then
      playedNo = 504
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", tamerText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[24])
    end
  elseif classNo == 19 then
    if titleNo == 0 then
      playedNo = 1300
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", combattantText))
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", combattantText))
      end
      _comboList:SetText(comboDesc[98])
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 1 then
      playedNo = 1301
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", combattantText))
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", combattantText))
      end
      _comboList:SetText(comboDesc[99])
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 2 then
      playedNo = 1302
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", combattantText))
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", combattantText))
      end
      _comboList:SetText(comboDesc[100])
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 3 then
      playedNo = 1303
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", combattantText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[101])
    elseif titleNo == 4 then
      playedNo = 1304
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", combattantText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[102])
    end
  elseif classNo == 20 then
    if titleNo == 0 then
      playedNo = 600
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", bladerText))
        _comboList:SetText(comboDesc[86])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerText))
        _comboList:SetText(comboDesc[25])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 1 then
      playedNo = 601
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", bladerText))
        _comboList:SetText(comboDesc[87])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerText))
        _comboList:SetText(comboDesc[26])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 2 then
      playedNo = 602
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", bladerText))
        _comboList:SetText(comboDesc[88])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerText))
        _comboList:SetText(comboDesc[27])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 3 then
      playedNo = 603
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", bladerText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[28])
    elseif titleNo == 4 then
      playedNo = 604
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", bladerText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[29])
    end
  elseif classNo == 21 then
    if titleNo == 0 then
      playedNo = 800
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", bladerWomenText))
        _comboList:SetText(comboDesc[89])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", bladerWomenText))
        _comboList:SetText(comboDesc[35])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 1 then
      playedNo = 801
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", bladerWomenText))
        _comboList:SetText(comboDesc[90])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", bladerWomenText))
        _comboList:SetText(comboDesc[36])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 2 then
      playedNo = 802
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", bladerWomenText))
        _comboList:SetText(comboDesc[91])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerWomenText))
        _comboList:SetText(comboDesc[37])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 3 then
      playedNo = 803
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", bladerWomenText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[38])
    elseif titleNo == 4 then
      playedNo = 804
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", bladerWomenText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[39])
    end
  elseif classNo == 24 then
    if titleNo == 0 then
      playedNo = 700
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", valkyrieText))
        _comboList:SetText(comboDesc[83])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", valkyrieText))
        _comboList:SetText(comboDesc[30])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 1 then
      playedNo = 701
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", valkyrieText))
        _comboList:SetText(comboDesc[84])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", valkyrieText))
        _comboList:SetText(comboDesc[31])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 2 then
      playedNo = 702
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", valkyrieText))
        _comboList:SetText(comboDesc[85])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", valkyrieText))
        _comboList:SetText(comboDesc[32])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 3 then
      playedNo = 703
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", valkyrieText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[33])
    elseif titleNo == 4 then
      playedNo = 704
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", valkyrieText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[34])
    end
  elseif classNo == 25 then
    if titleNo == 0 then
      playedNo = 1001
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", ninjaWomenText))
        _comboList:SetText(comboDesc[92])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaWomenText))
        _comboList:SetText(comboDesc[50])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 1 then
      playedNo = 1002
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", ninjaWomenText))
        _comboList:SetText(comboDesc[93])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaWomenText))
        _comboList:SetText(comboDesc[51])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 2 then
      playedNo = 1003
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", ninjaWomenText))
        _comboList:SetText(comboDesc[94])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", ninjaWomenText))
        _comboList:SetText(comboDesc[52])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 3 then
      playedNo = 1004
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", ninjaWomenText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[53])
    elseif titleNo == 4 then
      playedNo = 1005
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", ninjaWomenText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[54])
    end
  elseif classNo == 26 then
    if titleNo == 0 then
      playedNo = 1100
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", ninjaManText))
        _comboList:SetText(comboDesc[95])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaManText))
        _comboList:SetText(comboDesc[55])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 1 then
      playedNo = 1101
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", ninjaManText))
        _comboList:SetText(comboDesc[96])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaManText))
        _comboList:SetText(comboDesc[56])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 2 then
      playedNo = 1102
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", ninjaManText))
        _comboList:SetText(comboDesc[97])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", ninjaManText))
        _comboList:SetText(comboDesc[57])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 3 then
      playedNo = 1103
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", ninjaManText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[58])
    elseif titleNo == 4 then
      playedNo = 1104
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", ninjaManText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[59])
    end
  elseif classNo == 28 then
    if titleNo == 0 then
      playedNo = 900
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", wizardText))
        _comboList:SetText(comboDesc[80])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardText))
        _comboList:SetText(comboDesc[40])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 1 then
      playedNo = 901
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", wizardText))
        _comboList:SetText(comboDesc[81])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardText))
        _comboList:SetText(comboDesc[41])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 2 then
      playedNo = 902
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", wizardText))
        _comboList:SetText(comboDesc[82])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", wizardText))
        _comboList:SetText(comboDesc[42])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 3 then
      playedNo = 903
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", wizardText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[43])
    elseif titleNo == 4 then
      playedNo = 904
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", wizardText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[44])
    end
  elseif classNo == 31 then
    if titleNo == 0 then
      playedNo = 900
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW_TW", "getText", wizardWomenText))
        _comboList:SetText(comboDesc[80])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardWomenText))
        _comboList:SetText(comboDesc[40])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 1 then
      playedNo = 901
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE_TW", "getText", wizardWomenText))
        _comboList:SetText(comboDesc[81])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardWomenText))
        _comboList:SetText(comboDesc[41])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 2 then
      playedNo = 902
      if isGameTypeTaiwan() then
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH_TW", "getText", wizardWomenText))
        _comboList:SetText(comboDesc[82])
      else
        _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", wizardWomenText))
        _comboList:SetText(comboDesc[42])
      end
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
    elseif titleNo == 3 then
      playedNo = 903
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", wizardWomenText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[43])
    elseif titleNo == 4 then
      playedNo = 904
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", wizardWomenText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[44])
    end
  elseif classNo == 27 then
    if titleNo == 0 then
      playedNo = 1200
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", darkelfText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[60])
    elseif titleNo == 1 then
      playedNo = 1201
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", darkelfText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[61])
    elseif titleNo == 2 then
      playedNo = 1202
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", darkelfText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[62])
    elseif titleNo == 3 then
      playedNo = 1203
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", darkelfText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[63])
    elseif titleNo == 4 then
      playedNo = 1204
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", darkelfText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[64])
    end
  elseif classNo == 23 then
    if titleNo == 0 then
      playedNo = 1400
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", combattantWomenText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[103])
    elseif titleNo == 1 then
      playedNo = 1401
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", combattantWomenText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[104])
    elseif titleNo == 2 then
      playedNo = 1402
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", combattantWomenText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[105])
    elseif titleNo == 3 then
      playedNo = 1403
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", combattantWomenText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[106])
    elseif titleNo == 4 then
      playedNo = 1404
      _txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", combattantWomenText))
      _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
      _comboList:SetText(comboDesc[107])
    end
  end
  _comboList:SetShow(true)
  _comboList:SetSize(635, _comboList:GetTextSizeY() + 7)
  Panel_MovieTheater_SkillGuide_640:SetSize(650, _movieTheater_640:GetSizeY() / 2 + _comboList:GetSizeY() + _btn_Replay:GetSizeY() + _comboList:GetSpanSize().y + 10)
  _comboList:SetPosY(_movieTheater_640:GetSizeY() + 43)
  _btn_Replay:SetPosY(Panel_MovieTheater_SkillGuide_640:GetSizeY() - _btn_Replay:GetSizeY() - 5)
  Panel_MovieTheater_SkillGuide_640:SetPosX(getScreenSizeX() / 2 - Panel_MovieTheater_SkillGuide_640:GetSizeX() / 2)
  Panel_MovieTheater_SkillGuide_640:SetPosY(getScreenSizeY() / 2 - Panel_MovieTheater_SkillGuide_640:GetSizeY() / 2 - 15)
  _txt_Title:SetSize(Panel_MovieTheater_640:GetSizeX(), _txt_Title:GetSizeY())
  _txt_Title:ComputePos()
  _btn_Close:ComputePos()
  _btn_Replay:SetPosX(Panel_MovieTheater_SkillGuide_640:GetSizeX() / 2 - _btn_Replay:GetSizeX() / 2)
end
function Panel_MovieTheater_SkillGuide_640_Replay()
  if not _movieTheater_640:isReadyView() then
    return
  end
  if playedNo == 100 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 101 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 102 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 103 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 104 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 200 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 201 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 202 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 203 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 204 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 300 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 301 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 302 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 303 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 304 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 400 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 401 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 402 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 403 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 404 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 500 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 501 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 502 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 503 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 504 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 600 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 601 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 602 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 603 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 604 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 800 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 801 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 802 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 803 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 804 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 700 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 701 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 702 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 703 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 704 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 900 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 901 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 902 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 903 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 904 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1001 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1002 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1003 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1004 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1005 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1100 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1101 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1102 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1103 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1104 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1200 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1201 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1202 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1203 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1204 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1300 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1301 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1302 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1303 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1304 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1400 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1401 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1402 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1403 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  elseif playedNo == 1404 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
  end
end
function Panel_MovieTheater_SkillGuide_640_Clicked_Func(isYes)
  if isYes == true then
    GameOption_ComboGuideValueChange(false)
    _currentSpiritGuideCheck = false
    Panel_MovieTheater_SkillGuide_640:SetShow(false)
    Panel_MovieTheater_MessageBox:SetShow(false)
  else
    Panel_MovieTheater_SkillGuide_640:SetShow(false)
    Panel_MovieTheater_MessageBox:SetShow(false)
  end
end
function Panel_MovieTheater_SkillGuide_640_ShowControl()
  _movieTheater_640:TriggerEvent("ShowControl", "true")
end
function Panel_MovieTheater_SkillGuide_640_HideControl()
  _movieTheater_640:TriggerEvent("ShowControl", "false")
end
