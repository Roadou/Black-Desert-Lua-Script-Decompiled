Panel_UI_Setting:SetShow(false)
local UI_TM = CppEnums.TextMode
local renderMode = RenderModeWrapper.new(100, {
  Defines.RenderMode.eRenderMode_UISetting
}, false)
local _isMenu = true
local _prevRemasterUI
local _isShowRemasterUI = true
local UiSet = {
  title = UI.getChildControl(Panel_UI_Setting, "StaticText_Title"),
  main_BG = UI.getChildControl(Panel_UI_Setting, "Static_MainBG"),
  btn_Win_Close = UI.getChildControl(Panel_UI_Setting, "Button_Win_Close"),
  btn_save = UI.getChildControl(Panel_UI_Setting, "Button_Save"),
  btn_cancel = UI.getChildControl(Panel_UI_Setting, "Button_Cancel"),
  btn_reset = UI.getChildControl(Panel_UI_Setting, "Button_Reset"),
  btn_remsaterUI = UI.getChildControl(Panel_UI_Setting, "CheckButton_Remaster"),
  bg_Grid = UI.getChildControl(Panel_UI_Setting, "Static_Grid"),
  btn_FieldView = UI.getChildControl(Panel_UI_Setting, "CheckButton_FieldView"),
  btn_QuickSlotMagnetic = UI.getChildControl(Panel_UI_Setting, "CheckButton_QuickSlot"),
  chk_GridView = UI.getChildControl(Panel_UI_Setting, "CheckButton_GridView"),
  txt_UISize = UI.getChildControl(Panel_UI_Setting, "StaticText_UISize"),
  txt_UI_LOW = UI.getChildControl(Panel_UI_Setting, "StaticText_UI_LOW"),
  txt_UI_HIGH = UI.getChildControl(Panel_UI_Setting, "StaticText_UI_HIGH"),
  slider_UI_Scale = UI.getChildControl(Panel_UI_Setting, "Slider_UI_Scaling"),
  txt_UIFreeSet = UI.getChildControl(Panel_UI_Setting, "StaticText_FreeSet"),
  btn_UIFreeSet1 = UI.getChildControl(Panel_UI_Setting, "Button_UI1"),
  btn_UIFreeSet2 = UI.getChildControl(Panel_UI_Setting, "Button_UI2"),
  btn_UIFreeSet3 = UI.getChildControl(Panel_UI_Setting, "Button_UI3"),
  btn_DefaultSet1 = UI.getChildControl(Panel_UI_Setting, "Button_DefaultSet1"),
  btn_DefaultSet2 = UI.getChildControl(Panel_UI_Setting, "Button_DefaultSet2"),
  txt_UIHelp = UI.getChildControl(Panel_UI_Setting, "StaticText_Help"),
  panelCount = 0,
  panelPool = {},
  preScale = 0,
  currentScale = 100,
  minScale = 50,
  maxScale = 120,
  replaceScale = 0,
  nowCurrentPercent = 0,
  saveScale = 100
}
local UiSave = {
  txt_Desc = UI.getChildControl(Panel_SaveFreeSet, "StaticText_Desc"),
  btn_SaveClose = UI.getChildControl(Panel_SaveFreeSet, "Button_Win_Close"),
  btn_SaveDefault = UI.getChildControl(Panel_SaveFreeSet, "Button_DefaultUI"),
  btn_SaveUI1 = UI.getChildControl(Panel_SaveFreeSet, "Button_UI1"),
  btn_SaveUI2 = UI.getChildControl(Panel_SaveFreeSet, "Button_UI2"),
  btn_SaveUI3 = UI.getChildControl(Panel_SaveFreeSet, "Button_UI3"),
  bg_Block = UI.getChildControl(Panel_SaveFreeSet, "Static_Block")
}
UiSave.txt_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
UiSet.btn_Scale = UI.getChildControl(UiSet.slider_UI_Scale, "Slider_UI_Scaling_Button")
UiSave.txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SAVEFREESET_DESC"))
UiSet.txt_UIHelp:SetTextMode(UI_TM.eTextMode_AutoWrap)
UiSet.txt_UIHelp:SetText(UiSet.txt_UIHelp:GetText())
UiSet.txt_UIHelp:SetSize(UiSet.txt_UIHelp:GetSizeX(), UiSet.txt_UIHelp:GetTextSizeY() + 10)
UiSet.btn_QuickSlotMagnetic:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_UISETTING_QUICKSLOT_MAGNETIC"))
UiSet.btn_FieldView:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_UI_SETTING_CHKBTN_FIELDVIEW"))
UiSet.chk_GridView:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_UISETTING_GRIDVIEW"))
UiSet.title:AddChild(UiSet.main_BG)
UiSet.title:AddChild(UiSet.btn_save)
UiSet.title:AddChild(UiSet.btn_cancel)
UiSet.title:AddChild(UiSet.btn_reset)
UiSet.title:AddChild(UiSet.btn_FieldView)
UiSet.title:AddChild(UiSet.chk_GridView)
UiSet.title:AddChild(UiSet.btn_QuickSlotMagnetic)
UiSet.title:AddChild(UiSet.txt_UIFreeSet)
UiSet.title:AddChild(UiSet.txt_UISize)
UiSet.title:AddChild(UiSet.txt_UI_LOW)
UiSet.title:AddChild(UiSet.txt_UI_HIGH)
UiSet.title:AddChild(UiSet.slider_UI_Scale)
UiSet.title:AddChild(UiSet.btn_UIFreeSet1)
UiSet.title:AddChild(UiSet.btn_UIFreeSet2)
UiSet.title:AddChild(UiSet.btn_UIFreeSet3)
UiSet.title:AddChild(UiSet.btn_DefaultSet1)
UiSet.title:AddChild(UiSet.btn_DefaultSet2)
UiSet.title:AddChild(UiSet.btn_remsaterUI)
UiSet.title:AddChild(UiSet.btn_Win_Close)
UiSet.title:AddChild(UiSet.txt_UIHelp)
Panel_UI_Setting:RemoveControl(UiSet.main_BG)
Panel_UI_Setting:RemoveControl(UiSet.btn_save)
Panel_UI_Setting:RemoveControl(UiSet.btn_cancel)
Panel_UI_Setting:RemoveControl(UiSet.btn_reset)
Panel_UI_Setting:RemoveControl(UiSet.btn_FieldView)
Panel_UI_Setting:RemoveControl(UiSet.chk_GridView)
Panel_UI_Setting:RemoveControl(UiSet.btn_QuickSlotMagnetic)
Panel_UI_Setting:RemoveControl(UiSet.txt_UIFreeSet)
Panel_UI_Setting:RemoveControl(UiSet.txt_UISize)
Panel_UI_Setting:RemoveControl(UiSet.txt_UI_LOW)
Panel_UI_Setting:RemoveControl(UiSet.txt_UI_HIGH)
Panel_UI_Setting:RemoveControl(UiSet.slider_UI_Scale)
Panel_UI_Setting:RemoveControl(UiSet.btn_UIFreeSet1)
Panel_UI_Setting:RemoveControl(UiSet.btn_UIFreeSet2)
Panel_UI_Setting:RemoveControl(UiSet.btn_UIFreeSet3)
Panel_UI_Setting:RemoveControl(UiSet.btn_DefaultSet1)
Panel_UI_Setting:RemoveControl(UiSet.btn_DefaultSet2)
Panel_UI_Setting:RemoveControl(UiSet.btn_remsaterUI)
Panel_UI_Setting:RemoveControl(UiSet.btn_Win_Close)
Panel_UI_Setting:RemoveControl(UiSet.txt_UIHelp)
if true == _ContentsGroup_SimpleUI then
  UiSet.txt_UIHelp:SetSpanSize(5, 350)
  UiSet.title:SetSize(UiSet.title:GetSizeX(), UiSet.txt_UIHelp:GetPosY() + UiSet.txt_UIHelp:GetSizeY() + 50)
  UiSet.main_BG:SetSize(350, 310)
  UiSet.btn_DefaultSet1:SetShow(true)
  UiSet.btn_DefaultSet2:SetShow(true)
  UiSet.btn_remsaterUI:SetSpanSize(40, 245)
  UiSet.btn_FieldView:SetSpanSize(40, 270)
  UiSet.btn_QuickSlotMagnetic:SetSpanSize(40, 295)
  UiSet.chk_GridView:SetSpanSize(40, 320)
  UiSet.txt_UISize:SetSpanSize(0, 180)
  UiSet.txt_UI_LOW:SetSpanSize(40, 205)
  UiSet.txt_UI_HIGH:SetSpanSize(40, 205)
  UiSet.slider_UI_Scale:SetSpanSize(0, 230)
else
  UiSet.txt_UIHelp:SetSpanSize(5, 320)
  UiSet.title:SetSize(UiSet.title:GetSizeX(), UiSet.txt_UIHelp:GetPosY() + UiSet.txt_UIHelp:GetSizeY() + 50)
  UiSet.main_BG:SetSize(350, 310)
  UiSet.btn_DefaultSet1:SetShow(false)
  UiSet.btn_DefaultSet2:SetShow(false)
  UiSet.btn_remsaterUI:SetSpanSize(40, 205)
  UiSet.btn_FieldView:SetSpanSize(40, 230)
  UiSet.btn_QuickSlotMagnetic:SetSpanSize(40, 255)
  UiSet.chk_GridView:SetSpanSize(40, 280)
  UiSet.txt_UISize:SetSpanSize(0, 140)
  UiSet.txt_UI_LOW:SetSpanSize(40, 165)
  UiSet.txt_UI_HIGH:SetSpanSize(40, 165)
  UiSet.slider_UI_Scale:SetSpanSize(0, 190)
end
UiSet.main_BG:ComputePos()
UiSet.title:ComputePos()
UiSet.btn_save:ComputePos()
UiSet.btn_cancel:ComputePos()
UiSet.btn_reset:ComputePos()
UiSet.btn_FieldView:ComputePos()
UiSet.chk_GridView:ComputePos()
UiSet.btn_QuickSlotMagnetic:ComputePos()
UiSet.txt_UIFreeSet:ComputePos()
UiSet.txt_UISize:ComputePos()
UiSet.txt_UI_LOW:ComputePos()
UiSet.txt_UI_HIGH:ComputePos()
UiSet.slider_UI_Scale:ComputePos()
UiSet.btn_UIFreeSet1:ComputePos()
UiSet.btn_UIFreeSet2:ComputePos()
UiSet.btn_UIFreeSet3:ComputePos()
UiSet.btn_DefaultSet1:ComputePos()
UiSet.btn_DefaultSet2:ComputePos()
UiSet.btn_remsaterUI:ComputePos()
UiSet.btn_Win_Close:ComputePos()
UiSet.txt_UIHelp:ComputePos()
UiSet.btn_FieldView:SetEnableArea(0, 0, UiSet.btn_FieldView:GetTextSizeX() + 25, UiSet.btn_FieldView:GetSizeY())
UiSet.btn_QuickSlotMagnetic:SetEnableArea(0, 0, UiSet.btn_QuickSlotMagnetic:GetTextSizeX() + 25, UiSet.btn_QuickSlotMagnetic:GetSizeY())
UiSet.chk_GridView:SetEnableArea(0, 0, UiSet.chk_GridView:GetTextSizeX() + 25, UiSet.chk_GridView:GetSizeY())
UiSet.btn_remsaterUI:SetEnableArea(0, 0, UiSet.btn_remsaterUI:GetTextSizeX() + 25, UiSet.btn_remsaterUI:GetSizeY())
local Template = {
  static_able = UI.getChildControl(Panel_UI_Setting, "Static_Able"),
  static_disAble = UI.getChildControl(Panel_UI_Setting, "Static_DisAble"),
  btn_close = UI.getChildControl(Panel_UI_Setting, "Button_Close")
}
Template.static_able:SetShow(false)
Template.static_disAble:SetShow(false)
Template.btn_close:SetShow(false)
local original_MouseX = 0
local original_MouseY = 0
local original_controlPosX = 0
local original_controlPosY = 0
local posGapX = 0
local posGapY = 0
local isLargePartyOpen = ToClient_IsContentsGroupOpen("286")
local closePanelState = {
  [0] = false,
  [1] = false,
  [2] = false,
  [3] = false,
  [4] = false
}
local closeEmptyPanelState = {
  [0] = false,
  [1] = false,
  [2] = false,
  [3] = false,
  [4] = false
}
local panelID = {
  ExpGage = 1,
  ServantIcon = 2,
  Radar = 3,
  Quest = 4,
  Chat0 = 5,
  Chat1 = 6,
  Chat2 = 7,
  Chat3 = 8,
  Chat4 = 9,
  GameTip = 10,
  QuickSlot = 11,
  HPBar = 12,
  Pvp = 13,
  ClassResource = 14,
  Adrenallin = 15,
  UIMain = 16,
  House = 17,
  NewEquip = 18,
  Party = 19,
  TimeBar = 20,
  ActionGuide = 21,
  KeyGuide = 22,
  NewQuickSlot0 = 23,
  NewQuickSlot1 = 24,
  NewQuickSlot2 = 25,
  NewQuickSlot3 = 26,
  NewQuickSlot4 = 27,
  NewQuickSlot5 = 28,
  NewQuickSlot6 = 29,
  NewQuickSlot7 = 30,
  NewQuickSlot8 = 31,
  NewQuickSlot9 = 32,
  NewQuickSlot10 = 33,
  NewQuickSlot11 = 34,
  NewQuickSlot12 = 35,
  NewQuickSlot13 = 36,
  NewQuickSlot14 = 37,
  NewQuickSlot15 = 38,
  NewQuickSlot16 = 39,
  NewQuickSlot17 = 40,
  NewQuickSlot18 = 41,
  NewQuickSlot19 = 42,
  SkillCoolTime = 43,
  MainQuest = 44,
  LargeParty = 45,
  SkillCoolTimeQuickSlot0 = 46,
  SkillCoolTimeQuickSlot1 = 47,
  SkillCoolTimeQuickSlot2 = 48,
  SkillCoolTimeQuickSlot3 = 49,
  SkillCoolTimeQuickSlot4 = 50,
  SkillCoolTimeQuickSlot5 = 51,
  SkillCoolTimeQuickSlot6 = 52,
  SkillCoolTimeQuickSlot7 = 53,
  SkillCoolTimeQuickSlot8 = 54,
  SkillCoolTimeQuickSlot9 = 55,
  MainStatusRemaster = 56,
  ServantIconRemaster = 57,
  AppliedBuffList = 58,
  LeftIcon = 59,
  RightIcon = 60,
  AreaOfHadum = 61
}
local panelControl = {
  [panelID.ExpGage] = {
    control = Panel_SelfPlayerExpGage,
    posFixed = true,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_SelfPlayer_ExpGage,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_1"),
    isShow = true
  },
  [panelID.ServantIcon] = {
    control = Panel_Window_Servant,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_ServantWindow,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_2"),
    isShow = true
  },
  [panelID.Radar] = {
    control = Panel_Radar,
    posFixed = true,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_RadarMap,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_3"),
    isShow = true
  },
  [panelID.Quest] = {
    control = Panel_CheckedQuest,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_4"),
    isShow = true
  },
  [panelID.Chat0] = {
    control = Panel_Chat0,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_ChattingWindow,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_5"),
    isShow = true
  },
  [panelID.Chat1] = {
    control = Panel_Chat1,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_ChattingWindow,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_6"),
    isShow = false
  },
  [panelID.Chat2] = {
    control = Panel_Chat2,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_ChattingWindow,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_7"),
    isShow = false
  },
  [panelID.Chat3] = {
    control = Panel_Chat3,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_ChattingWindow,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_8"),
    isShow = false
  },
  [panelID.Chat4] = {
    control = Panel_Chat4,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_ChattingWindow,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_9"),
    isShow = false
  },
  [panelID.GameTip] = {
    control = Panel_GameTips,
    posFixed = true,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_GameTips,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_10"),
    isShow = true
  },
  [panelID.QuickSlot] = {
    control = Panel_QuickSlot,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_QuickSlot,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_11"),
    isShow = true
  },
  [panelID.HPBar] = {
    control = Panel_MainStatus_User_Bar,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_MainStatusBar,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_12"),
    isShow = false
  },
  [panelID.Pvp] = {
    control = Panel_PvpMode,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_PvpMode,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_13"),
    isShow = true
  },
  [panelID.ClassResource] = {
    control = Panel_ClassResource,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_ClassResource,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_14"),
    isShow = true
  },
  [panelID.Adrenallin] = {
    control = Panel_Adrenallin,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_Adrenallin,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_15"),
    isShow = true
  },
  [panelID.UIMain] = {
    control = Panel_UIMain,
    posFixed = true,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_UIMenu,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_16"),
    isShow = true
  },
  [panelID.House] = {
    control = Panel_MyHouseNavi,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_MyHouseNavi,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_17"),
    isShow = false
  },
  [panelID.NewEquip] = {
    control = Panel_NewEquip,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewEquipment,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_18"),
    isShow = true
  },
  [panelID.Party] = {
    control = Panel_Party,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_Party,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_19"),
    isShow = true
  },
  [panelID.TimeBar] = {
    control = Panel_TimeBar,
    posFixed = true,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_TimeBar,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_20"),
    isShow = true
  },
  [panelID.ActionGuide] = {
    control = Panel_SkillCommand,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_21"),
    isShow = true
  },
  [panelID.KeyGuide] = {
    control = Panel_Movie_KeyViewer,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_KeyViewer,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_22"),
    isShow = false
  },
  [panelID.NewQuickSlot0] = {
    control = Panel_NewQuickSlot_0,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_0,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_1"),
    isShow = false
  },
  [panelID.NewQuickSlot1] = {
    control = Panel_NewQuickSlot_1,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_1,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_2"),
    isShow = false
  },
  [panelID.NewQuickSlot2] = {
    control = Panel_NewQuickSlot_2,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_2,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_3"),
    isShow = false
  },
  [panelID.NewQuickSlot3] = {
    control = Panel_NewQuickSlot_3,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_3,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_4"),
    isShow = false
  },
  [panelID.NewQuickSlot4] = {
    control = Panel_NewQuickSlot_4,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_4,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_5"),
    isShow = false
  },
  [panelID.NewQuickSlot5] = {
    control = Panel_NewQuickSlot_5,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_5,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_6"),
    isShow = false
  },
  [panelID.NewQuickSlot6] = {
    control = Panel_NewQuickSlot_6,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_6,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_7"),
    isShow = false
  },
  [panelID.NewQuickSlot7] = {
    control = Panel_NewQuickSlot_7,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_7,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_8"),
    isShow = false
  },
  [panelID.NewQuickSlot8] = {
    control = Panel_NewQuickSlot_8,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_8,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_9"),
    isShow = false
  },
  [panelID.NewQuickSlot9] = {
    control = Panel_NewQuickSlot_9,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_9,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_10"),
    isShow = false
  },
  [panelID.NewQuickSlot10] = {
    control = Panel_NewQuickSlot_10,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_10,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_11"),
    isShow = false
  },
  [panelID.NewQuickSlot11] = {
    control = Panel_NewQuickSlot_11,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_11,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_12"),
    isShow = false
  },
  [panelID.NewQuickSlot12] = {
    control = Panel_NewQuickSlot_12,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_12,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_13"),
    isShow = false
  },
  [panelID.NewQuickSlot13] = {
    control = Panel_NewQuickSlot_13,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_13,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_14"),
    isShow = false
  },
  [panelID.NewQuickSlot14] = {
    control = Panel_NewQuickSlot_14,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_14,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_15"),
    isShow = false
  },
  [panelID.NewQuickSlot15] = {
    control = Panel_NewQuickSlot_15,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_15,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_16"),
    isShow = false
  },
  [panelID.NewQuickSlot16] = {
    control = Panel_NewQuickSlot_16,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_16,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_17"),
    isShow = false
  },
  [panelID.NewQuickSlot17] = {
    control = Panel_NewQuickSlot_17,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_17,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_18"),
    isShow = false
  },
  [panelID.NewQuickSlot18] = {
    control = Panel_NewQuickSlot_18,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_18,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_19"),
    isShow = false
  },
  [panelID.NewQuickSlot19] = {
    control = Panel_NewQuickSlot_19,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_19,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_QUICKSLOT_20"),
    isShow = false
  },
  [panelID.SkillCoolTime] = {
    control = Panel_SkillCooltime,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTime,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UISETTING_SKILLCOOLTIME"),
    isShow = false
  },
  [panelID.MainQuest] = {
    control = Panel_MainQuest,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_MainQuest,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_MAINQUEST_TITLE"),
    isShow = false
  },
  [panelID.LargeParty] = {
    control = Panel_LargeParty,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_LargeParty,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_LARGEPARTY_TITLE"),
    isShow = true
  },
  [panelID.SkillCoolTimeQuickSlot0] = {
    control = Panel_SkillCoolTimeQuickSlot_0,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTimeQuickSlot_0,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_1"),
    isShow = false
  },
  [panelID.SkillCoolTimeQuickSlot1] = {
    control = Panel_SkillCoolTimeQuickSlot_1,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTimeQuickSlot_1,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_2"),
    isShow = false
  },
  [panelID.SkillCoolTimeQuickSlot2] = {
    control = Panel_SkillCoolTimeQuickSlot_2,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTimeQuickSlot_2,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_3"),
    isShow = false
  },
  [panelID.SkillCoolTimeQuickSlot3] = {
    control = Panel_SkillCoolTimeQuickSlot_3,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTimeQuickSlot_3,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_4"),
    isShow = false
  },
  [panelID.SkillCoolTimeQuickSlot4] = {
    control = Panel_SkillCoolTimeQuickSlot_4,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTimeQuickSlot_4,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_5"),
    isShow = false
  },
  [panelID.SkillCoolTimeQuickSlot5] = {
    control = Panel_SkillCoolTimeQuickSlot_5,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTimeQuickSlot_5,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_6"),
    isShow = false
  },
  [panelID.SkillCoolTimeQuickSlot6] = {
    control = Panel_SkillCoolTimeQuickSlot_6,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTimeQuickSlot_6,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_7"),
    isShow = false
  },
  [panelID.SkillCoolTimeQuickSlot7] = {
    control = Panel_SkillCoolTimeQuickSlot_7,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTimeQuickSlot_7,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_8"),
    isShow = false
  },
  [panelID.SkillCoolTimeQuickSlot8] = {
    control = Panel_SkillCoolTimeQuickSlot_8,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTimeQuickSlot_8,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_9"),
    isShow = false
  },
  [panelID.SkillCoolTimeQuickSlot9] = {
    control = Panel_SkillCoolTimeQuickSlot_9,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_SkillCoolTimeQuickSlot_9,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_10"),
    isShow = false
  },
  [panelID.MainStatusRemaster] = {
    control = Panel_MainStatus_Remaster,
    posFixed = true,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_MainStatusRemaster,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_1"),
    isShow = true
  },
  [panelID.ServantIconRemaster] = {
    control = Panel_Widget_ServantIcon,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_ServantIcon,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_2"),
    isShow = true
  },
  [panelID.AppliedBuffList] = {
    control = Panel_AppliedBuffList,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_AppliedBuffList,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "BUFF_LIST"),
    isShow = true
  },
  [panelID.LeftIcon] = {
    control = Panel_PersonalIcon_Left,
    posFixed = true,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_LeftIcon,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_FAMILYBUFF_NAME"),
    isShow = true
  },
  [panelID.RightIcon] = {
    control = Panel_Widget_Function,
    posFixed = true,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_WidgetFunction,
    prePos = {x = 0, y = 0},
    name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_FUNCTIONBUTTON_NAME"),
    isShow = true
  },
  [panelID.AreaOfHadum] = {
    control = Panel_Widget_AreaOfHadum,
    posFixed = false,
    isChange = false,
    PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_AreaOfHadum,
    prePos = {x = 0, y = 0},
    name = "\237\149\152\235\145\160\236\157\152 \236\152\129\236\151\173",
    isShow = true
  }
}
local swapPanelList = {
  panelID.ExpGage,
  panelID.Pvp,
  panelID.Adrenallin,
  panelID.HPBar,
  panelID.MainStatusRemaster,
  panelID.ClassResource
}
UiSet.panelCount = #panelControl
function PaGlobal_UiSetting_DefaultSet(isType)
  if nil == isType then
    return
  end
  if false == isGameTypeGT() and false == isGameServiceTypeDev() and not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_NOTCURRENTACTION_ACK"))
    return
  end
  _prevRemasterUI = remasterUIOption
  _isShowRemasterUI = remasterUIOption
  local hideControl = {
    panelID.ServantIcon,
    panelID.Quest,
    panelID.Chat0,
    panelID.Chat1,
    panelID.Chat2,
    panelID.Chat3,
    panelID.Chat4,
    panelID.GameTip,
    panelID.UIMain,
    panelID.House,
    panelID.NewEquip,
    panelID.ActionGuide,
    panelID.KeyGuide,
    panelID.MainQuest,
    panelID.ServantIconRemaster,
    panelID.LeftIcon,
    panelID.RightIcon
  }
  for _, v in pairs(hideControl) do
    if true == panelControl[v].isShow then
      HandleClicked_UiSet_ControlShowToggle(v)
    end
  end
  isChecked_SkillCommand = false
  if 1 == isType then
    UiSet.btn_remsaterUI:SetCheck(true)
    HandleClicked_UiSet_SwapRemasterUI()
  else
    UiSet.btn_remsaterUI:SetCheck(false)
    HandleClicked_UiSet_SwapRemasterUI()
  end
  if true == _isShowRemasterUI then
    if false == panelControl[panelID.MainStatusRemaster].isShow then
      HandleClicked_UiSet_ControlShowToggle(panelID.MainStatusRemaster)
    end
    if false == panelControl[panelID.Radar].isShow then
      HandleClicked_UiSet_ControlShowToggle(panelID.Radar)
    end
    if false == panelControl[panelID.TimeBar].isShow then
      HandleClicked_UiSet_ControlShowToggle(panelID.TimeBar)
    end
  else
    if true == panelControl[panelID.ExpGage].isShow then
      HandleClicked_UiSet_ControlShowToggle(panelID.ExpGage)
    end
    if true == panelControl[panelID.Radar].isShow then
      HandleClicked_UiSet_ControlShowToggle(panelID.Radar)
    end
    if true == panelControl[panelID.TimeBar].isShow then
      HandleClicked_UiSet_ControlShowToggle(panelID.TimeBar)
    end
  end
  HandleClicked_UiSet_ConfirmSetting_Shortcuts()
end
function setChangeUiSettingRadarUI(panel, uiType)
  panelControl[panelID.Radar].control = panel
  panelControl[panelID.Radar].PAGameUIType = uiType
end
function PAGlobal_setIsChangePanelState(index, state, ischatPanel)
  if false == ischatPanel then
    for idx = 1, UiSet.panelCount do
      if panelControl[idx].PAGameUIType == index then
        panelControl[idx].isChange = state
        return
      end
    end
  else
    panelControl[index].isChange = state
  end
end
function PAGlobal_setPanelChattingPoolRelativeSize(index, sizex, sizey)
  local scale = UiSet.currentScale / 100
  local preScale = UiSet.preScale
  local currentScreenSize = {
    x = getScreenSizeX(),
    y = getScreenSizeY()
  }
  index = index + panelID.Chat0
  local slot = panelControl[index].control
  local posX = slot:GetPosX()
  local posY = slot:GetPosY()
  local rateX = 0
  local rateY = 0
  rateX = posX + slot:GetSizeX() / 2
  rateY = posY + slot:GetSizeY() / 2
  if panelControl[index].isChange == false then
    panelControl[index].control:SetRelativePosX(0)
    panelControl[index].control:SetRelativePosY(0)
    slot:SetRelativePosX(0)
    slot:SetRelativePosY(0)
  else
    panelControl[index].control:SetRelativePosX(rateX / currentScreenSize.x)
    panelControl[index].control:SetRelativePosY(rateY / currentScreenSize.y)
    slot:SetRelativePosX(rateX / currentScreenSize.x)
    slot:SetRelativePosY(rateY / currentScreenSize.y)
  end
end
local BG_Texture = {
  {
    107,
    1,
    159,
    53
  },
  {
    1,
    1,
    53,
    53
  },
  {
    54,
    1,
    106,
    53
  }
}
local cachePosX = {}
local cachePosY = {}
local cacheSizeX = {}
local cacheSizeY = {}
local cachePreScale = {}
local ChatPanelIsOpenState = {
  [1] = false,
  [2] = false,
  [3] = false,
  [4] = false,
  [5] = false
}
function UiSet_Initialize()
  if false == ToClient_isConsole() and true == _ContentsGroup_RemasterUI_Party then
    panelControl[panelID.LargeParty] = {
      control = Panel_Widget_Raid,
      posFixed = false,
      isChange = false,
      PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_LargeParty,
      prePos = {x = 0, y = 0},
      name = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_LARGEPARTY_TITLE"),
      isShow = true
    }
    panelControl[panelID.Party] = {
      control = Panel_Widget_Party,
      posFixed = false,
      isChange = false,
      PAGameUIType = CppEnums.PAGameUIType.PAGameUIPanel_Party,
      prePos = {x = 0, y = 0},
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_19"),
      isShow = true
    }
  end
  for idx = 1, UiSet.panelCount do
    if nil ~= panelControl[idx].control then
      local slot = {}
      local fixedType = ""
      if panelControl[idx].posFixed then
        fixedType = "Static_DisAble"
      else
        fixedType = "Static_Able"
      end
      slot.control = UI.createAndCopyBasePropertyControl(Panel_UI_Setting, fixedType, Panel_UI_Setting, "UiSet_CreateControl_" .. idx)
      slot.control:SetShow(true)
      slot.control:SetSize(panelControl[idx].control:GetSizeX(), panelControl[idx].control:GetSizeY())
      slot.control:SetPosX(panelControl[idx].control:GetPosX())
      slot.control:SetPosY(panelControl[idx].control:GetPosY())
      slot.control:addInputEvent("Mouse_LDown", "HandleClicked_UiSet_MoveControlSet_Start( " .. idx .. " )")
      slot.control:addInputEvent("Mouse_LPress", "HandleClicked_UiSet_MoveControl( " .. idx .. " )")
      slot.control:addInputEvent("Mouse_LUp", "HandleClicked_UiSet_PositionCheck( " .. idx .. " )")
      if idx >= 46 and idx <= 55 then
        slot.control:addInputEvent("Mouse_On", "PaGlobal_SimpleTooltips_Index(true, " .. idx .. ")")
        slot.control:addInputEvent("Mouse_Out", "PaGlobal_SimpleTooltips_Index(false, " .. idx .. ")")
      end
      slot.close = UI.createAndCopyBasePropertyControl(Panel_UI_Setting, "Button_Close", slot.control, "UiSet_Btn_CreateClose_" .. idx)
      slot.close:SetShow(true)
      slot.close:SetPosX(slot.control:GetSizeX() - slot.close:GetSizeX() - 3)
      slot.close:SetPosY(3)
      slot.close:addInputEvent("Mouse_LUp", "HandleClicked_UiSet_ControlShowToggle( " .. idx .. " )")
      slot.close:SetCheck(panelControl[idx].control:GetShow())
      UiSet.panelPool[idx] = slot
      panelControl[idx].isShow = panelControl[idx].control:GetShow()
      if panelControl[idx].isShow then
        if panelControl[idx].posFixed then
          slot.control:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UI_SETTING_SLOTCONTROL_IMPOSSIBLE", "name", panelControl[idx].name))
        else
          slot.control:SetText(panelControl[idx].name)
        end
      elseif 21 == idx then
        slot.control:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_UISETTING_SKILLGUIDE_EXTRA"))
      else
        slot.control:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UI_SETTING_SLOTCONTROL_OFF", "name", panelControl[idx].name))
      end
      local stateValue = 0
      if not panelControl[idx].isShow then
        stateValue = 1
      elseif panelControl[idx].posFixed then
        stateValue = 3
      else
        stateValue = 2
      end
      UiSet_ChangeTexture_BG(idx, stateValue)
      if 0 < ToClient_GetUiInfo(panelControl[idx].PAGameUIType, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved) then
        local relativePosX, relativePosY
        if idx >= panelID.Chat0 and idx <= panelID.Chat4 then
          relativePosX = ToClient_GetUiInfo(panelControl[idx].PAGameUIType, idx - panelID.Chat0, CppEnums.PanelSaveType.PanelSaveType_RelativePositionX)
          relativePosY = ToClient_GetUiInfo(panelControl[idx].PAGameUIType, idx - panelID.Chat0, CppEnums.PanelSaveType.PanelSaveType_RelativePositionY)
        else
          relativePosX = ToClient_GetUiInfo(panelControl[idx].PAGameUIType, 0, CppEnums.PanelSaveType.PanelSaveType_RelativePositionX)
          relativePosY = ToClient_GetUiInfo(panelControl[idx].PAGameUIType, 0, CppEnums.PanelSaveType.PanelSaveType_RelativePositionY)
        end
        if relativePosX == -1 or relativePosX == -1 then
          if 0 < panelControl[idx].control:GetRelativePosX() or 0 < panelControl[idx].control:GetRelativePosY() then
            panelControl[idx].isChange = true
          else
            panelControl[idx].isChange = false
          end
        elseif relativePosX > 0 or relativePosY > 0 then
          panelControl[idx].isChange = true
        end
        if panelControl[idx].posFixed == true then
          panelControl[idx].isChange = false
        end
        panelControl[idx].control:SetRelativePosX(relativePosX)
        panelControl[idx].control:SetRelativePosY(relativePosY)
        UiSet.panelPool[idx].control:SetRelativePosX(relativePosX)
        UiSet.panelPool[idx].control:SetRelativePosY(relativePosY)
      end
    end
  end
  if true == _ContentsGroup_RenewUI_Main then
    Panel_SkillCommand:SetShow(false)
    Panel_UIMain:SetShow(false)
  end
  UiSet.slider_UI_Scale:SetInterval(160)
end
function UiSet_update(isRemasterSwap)
  if true == isRemasterSwap then
    for _, pID in pairs(swapPanelList) do
      if nil ~= panelControl[pID] then
        panelControl[pID].isShow = true
      end
    end
  else
    UiSet.slider_UI_Scale:SetControlPos(UiSet.nowCurrentPercent)
  end
  local scaleText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UI_SETTING_SCALETEXT", "currentScale", UiSet.currentScale)
  UiSet.txt_UISize:SetText(tostring(scaleText))
  UiSet.txt_UI_LOW:SetText(UiSet.minScale)
  UiSet.txt_UI_HIGH:SetText(UiSet.maxScale)
  for idx = 1, UiSet.panelCount do
    local slot = UiSet.panelPool[idx]
    if nil ~= slot and nil ~= slot.control then
      slot.control:SetScale(1, 1)
      slot.control:SetShow(true)
      if idx == panelID.LargeParty and false == isLargePartyOpen then
        slot.control:SetShow(false)
      end
      if true ~= isRemasterSwap then
        slot.originPosX = panelControl[idx].control:GetPosX()
        slot.originPosY = panelControl[idx].control:GetPosY()
        slot.originSizeX = panelControl[idx].control:GetSizeX()
        slot.originSizeY = panelControl[idx].control:GetSizeY()
        slot.control:SetPosX(slot.originPosX)
        slot.control:SetPosY(slot.originPosY)
        slot.control:SetSize(slot.originSizeX, slot.originSizeY)
      end
      slot.close:SetScale(1, 1)
      slot.close:SetShow(true)
      slot.close:SetPosX(slot.control:GetSizeX() - slot.close:GetSizeX() - 3)
      slot.close:SetPosY(3)
      slot.close:SetCheck(panelControl[idx].isShow)
      if idx == panelID.Chat0 or idx == panelID.Chat1 or idx == panelID.Chat2 or idx == panelID.Chat3 or idx == panelID.Chat4 then
        local chatPanel = ToClient_getChattingPanel(idx - panelID.Chat0)
        if chatPanel:isOpen() then
          if idx == panelID.Chat0 then
            slot.control:SetShow(true)
            slot.close:SetShow(true)
          elseif chatPanel:isCombinedToMainPanel() then
            slot.control:SetShow(false)
            slot.close:SetShow(false)
          else
            slot.control:SetShow(true)
            slot.close:SetShow(true)
          end
        elseif chatPanel:isCombinedToMainPanel() == false or idx == panelID.Chat0 then
          slot.control:SetShow(true)
          slot.close:SetShow(true)
        else
          slot.control:SetShow(false)
          slot.close:SetShow(false)
        end
      elseif idx == panelID.ClassResource then
        if __eClassType_Sorcerer == getSelfPlayer():getClassType() or __eClassType_Combattant == getSelfPlayer():getClassType() or __eClassType_Mystic == getSelfPlayer():getClassType() or __eClassType_ShyWaman == getSelfPlayer():getClassType() then
          slot.control:SetShow(not _isShowRemasterUI)
          slot.close:SetShow(not _isShowRemasterUI)
          panelControl[pID].isShow = not _isShowRemasterUI
          if __eClassType_Combattant == getSelfPlayer():getClassType() or __eClassType_Mystic == getSelfPlayer():getClassType() then
            panelControl[panelID.ClassResource].name = PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_FIGHTERTITLE")
          elseif __eClassType_ShyWaman == getSelfPlayer():getClassType() then
            panelControl[panelID.ClassResource].name = PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_SHY_NAME")
          end
        else
          slot.control:SetShow(false)
          slot.close:SetShow(false)
          panelControl[pID].isShow = false
        end
      elseif idx == panelID.ActionGuide then
        if true == isChecked_SkillCommand then
          UiSet_ChangeTexture_BG(idx, 2)
        else
          UiSet_ChangeTexture_BG(idx, 1)
        end
        slot.close:SetCheck(isChecked_SkillCommand)
        panelControl[idx].isShow = isChecked_SkillCommand
      elseif idx == panelID.KeyGuide then
        if true == isChecked_KeyViewer then
          UiSet_ChangeTexture_BG(idx, 2)
        else
          UiSet_ChangeTexture_BG(idx, 1)
        end
      elseif idx == panelID.Adrenallin then
        if getSelfPlayer():isEnableAdrenalin() then
          slot.control:SetShow(not _isShowRemasterUI)
          slot.close:SetShow(not _isShowRemasterUI)
          panelControl[pID].isShow = not _isShowRemasterUI
        else
          slot.control:SetShow(false)
          slot.close:SetShow(false)
          panelControl[pID].isShow = false
        end
      elseif idx == panelID.Pvp then
        if isPvpEnable() and true == ToClient_isAdultUser() then
          slot.control:SetShow(not _isShowRemasterUI)
          slot.close:SetShow(not _isShowRemasterUI)
          panelControl[pID].isShow = not _isShowRemasterUI
        else
          slot.control:SetShow(false)
          slot.close:SetShow(false)
          panelControl[pID].isShow = false
        end
      elseif idx == panelID.UIMain then
        if true == _ContentsGroup_RenewUI_Main then
          slot.control:SetShow(false)
        end
      elseif idx == panelID.AreaOfHadum and false == _ContentsGroup_AreaOfHadum then
        slot.control:SetShow(false)
        slot.close:SetShow(false)
      end
      if panelControl[idx].isShow then
        if panelControl[idx].posFixed then
          slot.control:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UI_SETTING_SLOTCONTROL_IMPOSSIBLE", "name", panelControl[idx].name))
        else
          slot.control:SetText(panelControl[idx].name)
        end
      elseif 21 == idx then
        slot.control:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_UISETTING_SKILLGUIDE_EXTRA"))
      else
        slot.control:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UI_SETTING_SLOTCONTROL_OFF", "name", panelControl[idx].name))
      end
      local stateValue = 0
      if not panelControl[idx].isShow then
        stateValue = 1
      elseif panelControl[idx].posFixed then
        stateValue = 3
      else
        stateValue = 2
      end
      UiSet_ChangeTexture_BG(idx, stateValue)
      if true == _ContentsGroup_RemasterUI_Main then
        if idx == panelID.House or idx == panelID.NewEquip or idx == panelID.ServantIcon then
          slot.control:SetShow(false)
        elseif idx == panelID.ExpGage or idx == panelID.HPBar then
          slot.control:SetShow(not _isShowRemasterUI)
          slot.close:SetShow(not _isShowRemasterUI)
          panelControl[pID].isShow = not _isShowRemasterUI
        elseif idx == panelID.MainStatusRemaster then
          slot.control:SetShow(_isShowRemasterUI)
          slot.close:SetShow(_isShowRemasterUI)
          panelControl[pID].isShow = _isShowRemasterUI
        end
      end
    end
  end
end
function HandleClicked_UiSet_MoveControlSet_Start(idx)
  if panelControl[idx].posFixed then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_POSFIXED_ACK"))
    return
  end
  original_MouseX = getMousePosX()
  original_MouseY = getMousePosY()
  local control = UiSet.panelPool[idx].control
  original_controlPosX = control:GetPosX()
  original_controlPosY = control:GetPosY()
  posGapX = original_MouseX - original_controlPosX
  posGapY = original_MouseY - original_controlPosY
end
function HandleClicked_UiSet_MoveControl(idx)
  if panelControl[idx].posFixed then
    return
  end
  local scale = UiSet.currentScale / 100
  local mouseX = getMousePosX()
  local mouseY = getMousePosY()
  local control = UiSet.panelPool[idx].control
  control:SetPosX(mouseX - posGapX)
  control:SetPosY(mouseY - posGapY)
  cachePosX[idx] = control:GetPosX()
  cachePosY[idx] = control:GetPosY()
  cachePreScale[idx] = scale
  cacheSizeX[idx] = control:GetSizeX()
  cacheSizeY[idx] = control:GetSizeY()
  panelControl[idx].isChange = true
end
function HandleClicked_UiSet_PositionCheck(index)
  local checkindex = false
  if index >= panelID.NewQuickSlot0 and index <= panelID.NewQuickSlot19 or index >= panelID.SkillCoolTimeQuickSlot0 and index <= panelID.SkillCoolTimeQuickSlot9 then
    checkindex = true
  end
  if false == checkindex then
    return
  end
  if not UiSet.btn_QuickSlotMagnetic:IsCheck() then
    return
  end
  if index >= panelID.NewQuickSlot0 and index <= panelID.NewQuickSlot19 then
    HandleClicked_UiSet_PositionCheck_SetPos(index, panelID.NewQuickSlot0, panelID.NewQuickSlot19)
  elseif index >= panelID.SkillCoolTimeQuickSlot0 and index <= panelID.SkillCoolTimeQuickSlot9 then
    HandleClicked_UiSet_PositionCheck_SetPos(index, panelID.SkillCoolTimeQuickSlot0, panelID.SkillCoolTimeQuickSlot9)
  end
end
function HandleClicked_UiSet_PositionCheck_SetPos(index, startIndex, endIndex)
  local basePosX = UiSet.panelPool[index].control:GetPosX()
  local basePosY = UiSet.panelPool[index].control:GetPosY()
  for qIndex = startIndex, endIndex do
    if index ~= qIndex then
      local control = UiSet.panelPool[qIndex].control
      if basePosX < control:GetPosX() + control:GetSizeX() + 25 and basePosX > control:GetPosX() and basePosY > control:GetPosY() - 20 and basePosY < control:GetPosY() + 20 then
        UiSet.panelPool[index].control:SetPosX(control:GetPosX() + control:GetSizeX())
        UiSet.panelPool[index].control:SetPosY(control:GetPosY())
        break
      end
      if basePosY < control:GetPosY() + control:GetSizeY() + 32 and basePosY > control:GetPosY() and basePosX > control:GetPosX() - 20 and basePosX < control:GetPosX() + 20 then
        UiSet.panelPool[index].control:SetPosX(control:GetPosX())
        UiSet.panelPool[index].control:SetPosY(control:GetPosY() + control:GetSizeY())
        break
      end
      if basePosX > control:GetPosX() - control:GetSizeX() - 25 and basePosX < control:GetPosX() and basePosY > control:GetPosY() - 20 and basePosY < control:GetPosY() + 20 then
        UiSet.panelPool[index].control:SetPosX(control:GetPosX() - control:GetSizeX())
        UiSet.panelPool[index].control:SetPosY(control:GetPosY())
        break
      end
      if basePosY > control:GetPosY() - control:GetSizeY() - 32 and basePosY < control:GetPosY() and basePosX > control:GetPosX() - 20 and basePosX < control:GetPosX() + 20 then
        UiSet.panelPool[index].control:SetPosX(control:GetPosX())
        UiSet.panelPool[index].control:SetPosY(control:GetPosY() - control:GetSizeY())
        break
      end
    end
  end
end
function UiSet_MoveControlSet_End(idx)
  if panelControl[idx].posFixed then
    return
  end
end
function UiSet_ChangeTexture_BG(idx, state)
  local control = UiSet.panelPool[idx].control
  control:ChangeTextureInfoName("New_UI_Common_forLua/Default/UIcontrolPanel.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, BG_Texture[state][1], BG_Texture[state][2], BG_Texture[state][3], BG_Texture[state][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function HandleClicked_UiSet_ControlShowToggle(idx)
  local panelOpen = 0
  if idx == panelID.MainQuest then
    if nil == getSelfPlayer() then
      _PA_ASSERT(false, "SelfPlayer\234\176\128 nil \236\158\133\235\139\136\235\139\164.")
      return
    end
    local closableLevel = 0
    if true == _ContentsGroup_RemasterUI_QuestWidget then
      closableLevel = PaGlobalFunc_MainQuestWidget_GetClosableLevel()
    else
      closableLevel = PaGlobal_MainQuest._closeableLevel
    end
    if closableLevel > getSelfPlayer():get():getLevel() and true == Panel_MainQuest:GetShow() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_MAINQUESTWIDGET_NOTYETCLOSEABLELEVEL_ACK"))
      return
    end
  end
  if idx == panelID.Pvp and not isPvpEnable() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_NOTYETPVP_ACK"))
    UiSet.panelPool[idx].close:SetCheck(panelControl[idx].isShow)
    return
  elseif idx == panelID.Adrenallin and not getSelfPlayer():isEnableAdrenalin() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_NOTYETSPRIT_ACK"))
    UiSet.panelPool[idx].close:SetCheck(panelControl[idx].isShow)
    return
  elseif idx == panelID.House or idx == panelID.NewEquip or idx == panelID.Party or idx == panelID.QuickSlot or idx == panelID.Adrenallin or idx == panelID.LargeParty then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_NOTRANDOMHIDE_ACK"))
    UiSet.panelPool[idx].close:SetCheck(panelControl[idx].isShow)
    return
  elseif (idx == panelID.NewQuickSlot0 or idx == panelID.NewQuickSlot1 or idx == panelID.NewQuickSlot2 or idx == panelID.NewQuickSlot3 or idx == panelID.NewQuickSlot4 or idx == panelID.NewQuickSlot5 or idx == panelID.NewQuickSlot6 or idx == panelID.NewQuickSlot7 or idx == panelID.NewQuickSlot8 or idx == panelID.NewQuickSlot9 or idx == panelID.NewQuickSlot10 or idx == panelID.NewQuickSlot11 or idx == panelID.NewQuickSlot12 or idx == panelID.NewQuickSlot13 or idx == panelID.NewQuickSlot14 or idx == panelID.NewQuickSlot15 or idx == panelID.NewQuickSlot16 or idx == panelID.NewQuickSlot17 or idx == panelID.NewQuickSlot18 or idx == panelID.NewQuickSlot19) and not isUseNewQuickSlot() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_NEWQUICKSETTING"))
    UiSet.panelPool[idx].close:SetCheck(panelControl[idx].isShow)
    return
  elseif panelControl[idx].isShow then
    panelControl[idx].isShow = false
    UiSet_ChangeTexture_BG(idx, 1)
    panelControl[idx].isShow = false
    if 21 == idx then
      UiSet.panelPool[idx].control:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_UISETTING_SKILLGUIDE_EXTRA"))
    else
      UiSet.panelPool[idx].control:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UI_SETTING_SLOTCONTROL_OFF", "name", panelControl[idx].name))
    end
    panelOpen = false
  else
    panelControl[idx].isShow = true
    if panelControl[idx].posFixed then
      UiSet_ChangeTexture_BG(idx, 3)
    else
      UiSet_ChangeTexture_BG(idx, 2)
    end
    panelControl[idx].isShow = true
    if panelControl[idx].posFixed then
      UiSet.panelPool[idx].control:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UI_SETTING_SLOTCONTROL_IMPOSSIBLE", "name", panelControl[idx].name))
    else
      UiSet.panelPool[idx].control:SetText(panelControl[idx].name)
    end
    panelOpen = true
  end
  if idx == panelID.Chat0 or idx == panelID.Chat1 or idx == panelID.Chat2 or idx == panelID.Chat3 or idx == panelID.Chat4 then
    Chatting_setIsOpenValue(idx - 5, panelOpen)
  end
end
function UiSet_FreeSet_Open()
  Panel_SaveFreeSet:SetShow(true)
  UiSet.title:SetShow(false)
  PaGlobal_Panel_SaveSetting_Hide()
end
function PaGlobal_UiSet_FreeSet_Close()
  Panel_SaveFreeSet:SetShow(false)
  UiSet.title:SetShow(true)
  UiSet.chk_GridView:SetCheck(false)
end
function UiSet_GridView()
  local isCheck = UiSet.chk_GridView:IsCheck()
  if isCheck then
    UiSet.bg_Grid:SetShow(true)
  else
    UiSet.bg_Grid:SetShow(false)
  end
end
function UiSet_ConfrimSetting_Sub(isReset)
  local scale = UiSet.currentScale / 100
  local preScale = UiSet.preScale
  local currentScreenSize = {
    x = getScreenSizeX(),
    y = getScreenSizeY()
  }
  local preScreenSize = {
    x = currentScreenSize.x / preScale,
    y = currentScreenSize.y / preScale
  }
  local changeScreenSize = {
    x = currentScreenSize.x / scale,
    y = currentScreenSize.y / scale
  }
  for idx = 1, UiSet.panelCount do
    local controlPosX = UiSet.panelPool[idx].control:GetPosX()
    local controlPosY = UiSet.panelPool[idx].control:GetPosY()
    local slot = UiSet.panelPool[idx].control
    local posX = slot:GetPosX()
    local posY = slot:GetPosY()
    local rateX = 0
    local rateY = 0
    rateX = posX + slot:GetSizeX() / 2
    rateY = posY + slot:GetSizeY() / 2
    if panelControl[idx].isChange == false then
      panelControl[idx].control:SetRelativePosX(0)
      panelControl[idx].control:SetRelativePosY(0)
      slot:SetRelativePosX(0)
      slot:SetRelativePosY(0)
    else
      panelControl[idx].control:SetRelativePosX(rateX / currentScreenSize.x)
      panelControl[idx].control:SetRelativePosY(rateY / currentScreenSize.y)
      slot:SetRelativePosX(rateX / currentScreenSize.x)
      slot:SetRelativePosY(rateY / currentScreenSize.y)
    end
    if idx == panelID.Pvp then
      if isPvpEnable() and true == ToClient_isAdultUser() then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      end
    elseif idx == panelID.Adrenallin then
      panelControl[idx].control:SetShow(getSelfPlayer():isEnableAdrenalin())
    elseif idx == panelID.GameTip then
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
      if false == _ContentsGroup_RenewUI then
        Panel_GameTipMask:SetShow(panelControl[idx].isShow)
        Panel_GameTipMask:SetPosX(controlPosX + 15)
        Panel_GameTipMask:SetPosY(controlPosY - 7)
      end
    elseif idx == panelID.ClassResource then
      if false == _ContentsGroup_RenewUI_Main and (__eClassType_Sorcerer == getSelfPlayer():getClassType() or __eClassType_Combattant == getSelfPlayer():getClassType() or __eClassType_Mystic == getSelfPlayer():getClassType() or __eClassType_ShyWaman == getSelfPlayer():getClassType()) then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      end
    elseif idx == panelID.ActionGuide then
      setShowSkillCmd(panelControl[idx].isShow)
      isChecked_SkillCommand = panelControl[idx].isShow
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
      GameOption_UpdateOptionChanged()
      FGlobal_SkillCommand_Show(panelControl[idx].isShow)
    elseif idx == panelID.KeyGuide then
      if true == panelControl[idx].isShow then
        FGlobal_KeyViewer_Show()
      else
        FGlobal_KeyViewer_Hide()
      end
      isChecked_KeyViewer = panelControl[idx].isShow
      GameOption_UpdateOptionChanged()
    elseif idx == panelID.UIMain then
      if true == _ContentsGroup_RenewUI_Main then
        panelControl[idx].control:SetShow(false)
      else
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      end
    elseif idx == panelID.NewQuickSlot0 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(0)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot1 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(1)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot2 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(2)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot3 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(3)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot4 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(4)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot5 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(5)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot6 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(6)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot7 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(7)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot8 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(8)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot9 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(9)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot10 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(10)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot11 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(11)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot12 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(12)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot13 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(13)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot14 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(14)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot15 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(15)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot16 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(16)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot17 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(17)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot18 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(18)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.NewQuickSlot19 then
      if false == panelControl[idx].isShow and isUseNewQuickSlot() then
        quickSlot_Clear(19)
      end
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx >= panelID.SkillCoolTimeQuickSlot0 and idx <= panelID.SkillCoolTimeQuickSlot9 then
      panelControl[idx].control:SetPosX(controlPosX)
      panelControl[idx].control:SetPosY(controlPosY)
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.LeftIcon then
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.RightIcon then
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    elseif idx == panelID.AreaOfHadum then
      if true == _ContentsGroup_AreaOfHadum then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      else
        panelControl[idx].control:SetShow(false)
      end
    else
      panelControl[idx].control:SetShow(panelControl[idx].isShow)
    end
  end
  UISetting_CheckOldMainStatus()
  ToClient_SaveUiInfo(true)
  return scale
end
function HandleClicked_UiSet_ConfirmSetting(isReset)
  PaGlobal_UiSet_FreeSet_Close()
  SetUIMode(Defines.UIMode.eUIMode_Default)
  renderMode:reset()
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eSwapRemasterUISetting, _isShowRemasterUI, CppEnums.VariableStorageType.eVariableStorageType_User)
  if _prevRemasterUI ~= _isShowRemasterUI then
    FromClient_MainStatus_SwapUIOption(_isShowRemasterUI)
  end
  local scale = UiSet_ConfrimSetting_Sub(isReset)
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    Panel_NewEquip_EffectLastUpdate()
  end
  FGlobal_PetListNew_NoPet()
  scale = scale + 0.002
  local uiScale_Percent = math.floor(scale * 100)
  scale = uiScale_Percent / 100
  if true == UI.checkResolution4KForXBox() then
    scale = 2
  end
  setUIScale(scale)
  GameOption_SetUIMode(scale)
  saveGameOption(false)
  if _isMenu then
    Panel_Menu_ShowToggle()
  else
    Panel_Window_Skill:SetShow(true, true)
    PaGlobal_Window_Skill_CoolTimeSlot:showFunc()
  end
  if false == ToClient_isConsole() then
    ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
  end
end
function HandleClicked_UiSet_ConfirmSetting_Shortcuts()
  PaGlobal_UiSet_FreeSet_Close()
  SetUIMode(Defines.UIMode.eUIMode_Default)
  renderMode:reset()
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eSwapRemasterUISetting, _isShowRemasterUI, CppEnums.VariableStorageType.eVariableStorageType_User)
  if _prevRemasterUI ~= _isShowRemasterUI then
    FromClient_MainStatus_SwapUIOption(_isShowRemasterUI)
  end
  local scale = UiSet_ConfrimSetting_Sub(isReset)
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    Panel_NewEquip_EffectLastUpdate()
  end
  FGlobal_PetListNew_NoPet()
  scale = scale + 0.002
  local uiScale_Percent = math.floor(scale * 100)
  scale = uiScale_Percent / 100
  if true == UI.checkResolution4KForXBox() then
    scale = 2
  end
  setUIScale(scale)
  GameOption_SetUIMode(scale)
  saveGameOption(false)
  if false == ToClient_isConsole() then
    ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
  end
end
function UiSet_Panel_ShowValueUpdate()
  for idx = 1, UiSet.panelCount do
    panelControl[idx].isShow = panelControl[idx].control:GetShow()
    panelControl[idx].prePos.x = panelControl[idx].control:GetPosX()
    panelControl[idx].prePos.y = panelControl[idx].control:GetPosY()
  end
end
function HandleClicked_UiSet_FieldViewToggle()
  if UiSet.btn_FieldView:IsCheck() then
    FieldViewMode_ShowToggle(true)
  else
    FieldViewMode_ShowToggle(false)
  end
end
function HandleClicked_UiSet_SwapRemasterUI()
  if UiSet.btn_remsaterUI:IsCheck() then
    _isShowRemasterUI = false
  else
    _isShowRemasterUI = true
  end
  UiSet_update(true)
end
function HandleClicked_UiSet_ChangeScale()
  local nowPercent = UiSet.slider_UI_Scale:GetControlPos()
  local realPercent = math.ceil(UiSet.replaceScale / 100 * (nowPercent * 100) + UiSet.minScale)
  UiSet.currentScale = realPercent
  local scaleText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UI_SETTING_SCALETEXT", "currentScale", realPercent)
  UiSet.txt_UISize:SetText(tostring(scaleText))
  local scale = UiSet.currentScale / 100
  local screensizeX = getScreenSizeX()
  local screensizeY = getScreenSizeY()
  for idx = 1, UiSet.panelCount do
    local slot = UiSet.panelPool[idx]
    local parentsPosX = cachePosX[idx]
    if nil == parentsPosX then
      parentsPosX = slot.originPosX
    end
    local parentsPosY = cachePosY[idx]
    if nil == parentsPosY then
      parentsPosY = slot.originPosY
    end
    local sizeX = cacheSizeX[idx]
    if nil == sizeX then
      sizeX = slot.originSizeX
    end
    local sizeY = cacheSizeY[idx]
    if nil == sizeY then
      sizeY = slot.originSizeY
    end
    local preScale = cachePreScale[idx]
    if nil == preScale then
      preScale = UiSet.preScale
    end
    local rateX = parentsPosX / (screensizeX - sizeX)
    local rateY = parentsPosY / (screensizeY - sizeY)
    slot.control:SetSize(sizeX * (1 / preScale) * scale, sizeY * (1 / preScale) * scale)
    if idx == panelID.ExpGage then
      slot.control:SetHorizonLeft()
      slot.control:SetVerticalTop()
    elseif idx == panelID.Radar then
      slot.control:SetHorizonRight()
      slot.control:SetVerticalTop()
      slot.control:SetSpanSize(0, 20)
    elseif idx == panelID.GameTip then
      slot.control:SetHorizonLeft()
      slot.control:SetVerticalBottom()
    elseif idx == panelID.UIMain then
      slot.control:SetHorizonRight()
      slot.control:SetVerticalBottom()
    else
      slot.control:SetPosX(parentsPosX + rateX * sizeX - rateX * slot.control:GetSizeX())
      slot.control:SetPosY(parentsPosY + rateY * sizeY - rateY * slot.control:GetSizeY())
    end
    slot.control:ComputePos()
    slot.close:ComputePos()
  end
end
function HandleClicked_UiSet_ChangeScale_LDown()
  local scale = UiSet.currentScale / 100
  for idx = 1, UiSet.panelCount do
    local control = UiSet.panelPool[idx].control
    cachePosX[idx] = control:GetPosX()
    cachePosY[idx] = control:GetPosY()
    cachePreScale[idx] = scale
    cacheSizeX[idx] = control:GetSizeX()
    cacheSizeY[idx] = control:GetSizeY()
  end
end
function UiSet_ScaleSet()
  local scaleValue = FGlobal_getUIScale()
  UiSet.minScale = scaleValue.min
  UiSet.maxScale = scaleValue.max
  UiSet.currentScale = FGlobal_returnUIScale() * 100
  UiSet.replaceScale = UiSet.maxScale - UiSet.minScale
  UiSet.preScale = FGlobal_returnUIScale()
  UiSet.nowCurrentPercent = math.ceil((UiSet.currentScale - UiSet.minScale) / UiSet.replaceScale * 100)
  if true == UI.checkResolution4KForXBox() then
    UiSet.nowCurrentPercent = 200
  end
end
function FGlobal_UiSet_Open(isMenu)
  if nil == getSelfPlayer() or nil == getSelfPlayer():get() then
    return
  end
  if false == isGameTypeGT() and false == isGameServiceTypeDev() and not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_NOTCURRENTACTION_ACK"))
    return
  end
  local levelLimit = 7
  if levelLimit > getSelfPlayer():get():getLevel() then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UI_SETTING_LEVELLIMIT_ACK", "level", levelLimit))
    return
  end
  close_force_WindowPanelList()
  ToClient_SaveUiInfo(false)
  UiSet.bg_Grid:SetShow(false)
  UiSet.chk_GridView:SetCheck(false)
  if true == _ContentsGroup_RemasterUI_Radar then
    FGlobal_ResetTimeBar()
  end
  local remasterUIOption = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eSwapRemasterUISetting)
  UiSet.btn_remsaterUI:SetCheck(not remasterUIOption)
  _prevRemasterUI = remasterUIOption
  _isShowRemasterUI = remasterUIOption
  Panel_FieldViewMode:SetShow(false)
  UiSet_Panel_ShowValueUpdate()
  SetUIMode(Defines.UIMode.eUIMode_UiSetting)
  renderMode:set()
  Panel_UI_Setting:SetShow(true)
  UiSet.btn_FieldView:SetCheck(false)
  UiSet.btn_QuickSlotMagnetic:SetCheck(true)
  UiSet_ScaleSet()
  for idx = 1, UiSet.panelCount do
    local slot = UiSet.panelPool[idx]
    if idx == panelID.ExpGage then
      slot.control:SetHorizonLeft()
      slot.control:SetVerticalTop()
    elseif idx == panelID.TimeBar then
      slot.control:SetHorizonRight()
      slot.control:SetVerticalTop()
    elseif idx == panelID.Radar then
      slot.control:SetHorizonRight()
      slot.control:SetVerticalTop()
      slot.control:SetSpanSize(0, 20)
    elseif idx == panelID.GameTip then
      slot.control:SetHorizonLeft()
      slot.control:SetVerticalBottom()
    elseif idx == panelID.UIMain then
      slot.control:SetHorizonRight()
      slot.control:SetVerticalBottom()
    end
  end
  UiSet.bg_Grid:SetAlpha(0.7)
  UiSet_update()
  local count = ToClient_getChattingPanelCount()
  for chattingPanelindex = 0, count - 1 do
    local chatPanel = ToClient_getChattingPanel(chattingPanelindex)
    if chatPanel:isOpen() then
      ChatPanelIsOpenState[chattingPanelindex + 1] = true
    else
      ChatPanelIsOpenState[chattingPanelindex + 1] = false
    end
  end
  if nil == isMenu then
    _isMenu = true
  else
    _isMenu = isMenu
  end
  if false == ToClient_isConsole() then
    ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_UIEDIT")
  end
end
function PaGlobal_UiSetting_RemasterHPSet()
  local remasterUIOption = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eSwapRemasterUISetting)
  UiSet.btn_remsaterUI:SetCheck(not remasterUIOption)
  FromClient_MainStatus_SwapUIOption(remasterUIOption)
  if true == remasterUIOption then
    UISetting_CheckOldMainStatus()
    UiSet_update(true)
  else
  end
  _prevRemasterUI = remasterUIOption
  _isShowRemasterUI = remasterUIOption
end
function FGlobal_UiSet_Close()
  PaGlobal_UiSet_FreeSet_Close()
  if false == Panel_UI_Setting:IsShow() then
    return
  end
  if true == _ContentsGroup_RemasterUI_Radar then
    PaGlobalFunc_Radar_Resize()
  end
  PaGlobal_UiSet_FreeSet_Close()
  SetUIMode(Defines.UIMode.eUIMode_Default)
  renderMode:reset()
  Panel_UI_Setting:SetShow(false)
  if _isMenu then
    Panel_Menu_ShowToggle()
  else
    Panel_Window_Skill:SetShow(true, true)
    PaGlobal_Window_Skill_CoolTimeSlot:showFunc()
  end
  local count = ToClient_getChattingPanelCount()
  for chattingPanelindex = 0, count - 1 do
    Chatting_setIsOpenValue(chattingPanelindex, ChatPanelIsOpenState[chattingPanelindex + 1])
    ChatPanelIsOpenState[chattingPanelindex + 1] = false
  end
  for idx = 0, 4 do
    if closePanelState[idx] == true then
      HandleClicked_Chatting_Close(idx, 0)
    end
    closePanelState[idx] = false
  end
  if false == ToClient_isConsole() then
    ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
  end
  if true == ToClient_IsInstanceFieldPlayerbyContentsType(__eInstanceContentsType_SavageDefence) then
    FromClient_BloodAltar_OnScreenResize()
  end
end
function UiSet_OnScreenEvent()
  Panel_UI_Setting:SetSize(getScreenSizeX(), getScreenSizeY())
  Panel_SaveFreeSet:ComputePos()
  UiSet.title:ComputePos()
  UiSet.bg_Grid:ComputePos()
  UiSave.bg_Block:ComputePos()
  local scale = ToClient_GetUIScale()
  scale = scale + 0.002
  scale = math.floor(scale * 100)
  FGlobal_saveUIScale(scale)
end
function UiSet_registEventHandler()
  UiSave.btn_SaveClose:addInputEvent("Mouse_LUp", "PaGlobal_UiSet_FreeSet_Close()")
  UiSave.btn_SaveDefault:addInputEvent("Mouse_LUp", "HandleClicked_UiSet_ConfirmSetting()")
  UiSet.btn_save:addInputEvent("Mouse_LUp", "UiSet_FreeSet_Open()")
  UiSet.btn_cancel:addInputEvent("Mouse_LUp", "FGlobal_UiSet_Close()")
  UiSet.btn_reset:addInputEvent("Mouse_LUp", "HandleClicked_Reset_UiSetting_Msg()")
  UiSet.btn_Win_Close:addInputEvent("Mouse_LUp", "FGlobal_UiSet_Close()")
  UiSet.chk_GridView:addInputEvent("Mouse_LUp", "UiSet_GridView()")
  UiSet.btn_Scale:addInputEvent("Mouse_LDown", "HandleClicked_UiSet_ChangeScale_LDown()")
  UiSet.slider_UI_Scale:addInputEvent("Mouse_LDown", "HandleClicked_UiSet_ChangeScale_LDown()")
  UiSet.btn_Scale:addInputEvent("Mouse_LPress", "HandleClicked_UiSet_ChangeScale()")
  UiSet.slider_UI_Scale:addInputEvent("Mouse_LPress", "HandleClicked_UiSet_ChangeScale()")
  UiSet.btn_FieldView:addInputEvent("Mouse_LUp", "HandleClicked_UiSet_FieldViewToggle()")
  UiSet.btn_remsaterUI:addInputEvent("Mouse_LUp", "HandleClicked_UiSet_SwapRemasterUI()")
end
function HandleClicked_Reset_UiSetting_Msg()
  local function reset_GameUI()
    local screenSizeX = getScreenSizeX()
    local screenSizeY = getScreenSizeY()
    local const_LowMaxScaleValue = 90
    local const_MidleMaxScaleValue = 100
    local const_HightMaxScaleValue = 120
    local minScaleHeight = 720
    local midleScaleHeight = 900
    local uiScale = 1
    local gameOptionSetting = ToClient_getGameOptionControllerWrapper()
    local screenWidth = gameOptionSetting:getScreenResolutionWidth()
    local screenHeight = gameOptionSetting:getScreenResolutionHeight()
    if false == isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_KOR) then
      const_LowMaxScaleValue = 100
    end
    if minScaleHeight >= screenHeight then
      maxScaleValue = const_LowMaxScaleValue
    elseif minScaleHeight < screenHeight and midleScaleHeight >= screenHeight then
      maxScaleValue = const_MidleMaxScaleValue
    else
      maxScaleValue = const_HightMaxScaleValue
    end
    uiScale = math.floor(uiScale * 100) / 100
    if uiScale * 100 > maxScaleValue then
      uiScale = 0.8
    end
    if true == UI.checkResolution4KForXBox() then
      uiScale = 2
    end
    UiSet.nowCurrentPercent = uiScale
    SetUIMode(Defines.UIMode.eUIMode_Default)
    renderMode:reset()
    for idx = 1, UiSet.panelCount do
      panelControl[idx].control:SetRelativePosX(0)
      panelControl[idx].control:SetRelativePosY(0)
      panelControl[idx].isChange = false
    end
    for idx = 1, UiSet.panelCount do
      if idx == panelID.ServantIcon or idx == panelID.House or idx == panelID.NewEquip or idx == panelID.Party or idx == panelID.Adrenallin or idx == panelID.QuickSlot or idx == panelID.NewQuickSlot0 or idx == panelID.NewQuickSlot1 or idx == panelID.NewQuickSlot2 or idx == panelID.NewQuickSlot3 or idx == panelID.NewQuickSlot4 or idx == panelID.NewQuickSlot5 or idx == panelID.NewQuickSlot6 or idx == panelID.NewQuickSlot7 or idx == panelID.NewQuickSlot8 or idx == panelID.NewQuickSlot9 or idx == panelID.NewQuickSlot10 or idx == panelID.NewQuickSlot11 or idx == panelID.NewQuickSlot12 or idx == panelID.NewQuickSlot13 or idx == panelID.NewQuickSlot14 or idx == panelID.NewQuickSlot15 or idx == panelID.NewQuickSlot16 or idx == panelID.NewQuickSlot17 or idx == panelID.NewQuickSlot18 or idx == panelID.NewQuickSlot19 or idx == panelID.LargeParty or idx == panelID.ServantIconRemaster then
      else
        panelControl[idx].isShow = true
      end
      if panelControl[idx].posFixed then
        UiSet_ChangeTexture_BG(idx, 3)
      else
        UiSet_ChangeTexture_BG(idx, 2)
      end
      if idx == panelID.Pvp then
        if isPvpEnable() then
          panelControl[idx].control:SetShow(panelControl[idx].isShow)
        end
      elseif idx == panelID.Adrenallin then
        if getSelfPlayer():isEnableAdrenalin() then
          panelControl[idx].control:SetShow(panelControl[idx].isShow)
        end
      elseif idx == panelID.GameTip then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
        if false == _ContentsGroup_RenewUI then
          Panel_GameTipMask:SetShow(panelControl[idx].isShow)
          Panel_GameTipMask:SetPosX(UiSet.panelPool[idx].control:GetPosX() + 15)
          Panel_GameTipMask:SetPosY(UiSet.panelPool[idx].control:GetPosY() - 7)
        end
      elseif idx == panelID.ClassResource then
        if __eClassType_Sorcerer == getSelfPlayer():getClassType() or __eClassType_Combattant == getSelfPlayer():getClassType() or __eClassType_Mystic == getSelfPlayer():getClassType() or __eClassType_ShyWaman == getSelfPlayer():getClassType() then
          panelControl[idx].control:SetShow(panelControl[idx].isShow)
        end
      elseif idx == panelID.QuickSlot then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.ActionGuide then
        setShowSkillCmd(panelControl[idx].isShow)
        isChecked_SkillCommand = panelControl[idx].isShow
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
        GameOption_UpdateOptionChanged()
      elseif idx == panelID.KeyGuide then
        panelControl[idx].isShow = false
        Panel_KeyViewer_Hide()
        PanelMovieKeyViewer_RestorePosition()
      elseif idx == panelID.NewQuickSlot0 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot1 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot2 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot3 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot4 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot5 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot6 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot7 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot8 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot9 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot10 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot11 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot12 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot13 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot14 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot15 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot16 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot17 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot18 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.NewQuickSlot19 then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.Party then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.LargeParty then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx >= panelID.SkillCoolTimeQuickSlot0 and idx <= panelID.SkillCoolTimeQuickSlot9 then
        panelControl[idx].control:SetShow(false)
      elseif idx == panelID.AppliedBuffList then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.LeftIcon then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.RightIcon then
        panelControl[idx].control:SetShow(panelControl[idx].isShow)
      elseif idx == panelID.AreaOfHadum then
        if true == _ContentsGroup_AreaOfHadum then
          panelControl[idx].control:SetShow(panelControl[idx].isShow)
        else
          panelControl[idx].control:SetShow(false)
        end
      else
        panelControl[idx].control:SetShow(true)
      end
      if idx == panelID.ServantIcon then
        cachePosX[idx] = 10
        cachePosY[idx] = UiSet.panelPool[panelID.ExpGage].control:GetPosY() + UiSet.panelPool[panelID.ExpGage].control:GetSizeY() + 15
      elseif idx == panelID.ServantIconRemaster then
        cachePosX[idx] = 10
        cachePosY[idx] = UiSet.panelPool[panelID.MainStatusRemaster].control:GetPosY() + UiSet.panelPool[panelID.MainStatusRemaster].control:GetSizeY() - 50
      elseif idx == panelID.Quest then
        cachePosX[idx] = screenSizeX - UiSet.panelPool[panelID.Quest].control:GetSizeX() - 20
        cachePosY[idx] = UiSet.panelPool[panelID.Radar].control:GetPosY() + UiSet.panelPool[panelID.Radar].control:GetSizeY() + UiSet.panelPool[panelID.MainQuest].control:GetSizeY() + 20 + UiSet.panelPool[panelID.NewEquip].control:GetSizeY()
      elseif idx == panelID.Chat0 or idx == panelID.Chat1 or idx == panelID.Chat2 or idx == panelID.Chat3 or idx == panelID.Chat4 then
        cachePosX[idx] = 0
        cachePosY[idx] = screenSizeY - UiSet.panelPool[idx].control:GetSizeY() - Panel_GameTips:GetSizeY()
      elseif idx == panelID.QuickSlot then
        cachePosX[idx] = (screenSizeX - UiSet.panelPool[panelID.QuickSlot].control:GetSizeX()) / 2
        cachePosY[idx] = screenSizeY - UiSet.panelPool[panelID.QuickSlot].control:GetSizeY()
      elseif idx == panelID.HPBar then
        cachePosX[idx] = screenSizeX / 2 - UiSet.panelPool[panelID.HPBar].control:GetSizeX() / 2
        cachePosY[idx] = screenSizeY - UiSet.panelPool[panelID.QuickSlot].control:GetSizeY() - UiSet.panelPool[panelID.HPBar].control:GetSizeY()
      elseif idx == panelID.Pvp then
        cachePosX[idx] = screenSizeX / 2 - UiSet.panelPool[panelID.HPBar].control:GetSizeX() / 2 - 20
        cachePosY[idx] = screenSizeY - UiSet.panelPool[panelID.QuickSlot].control:GetSizeY() - UiSet.panelPool[panelID.Pvp].control:GetSizeY()
      elseif idx == panelID.ClassResource then
        cachePosX[idx] = screenSizeX / 2 - UiSet.panelPool[panelID.HPBar].control:GetSizeX() / 2 + UiSet.panelPool[panelID.ClassResource].control:GetSizeX() - 5
        cachePosY[idx] = screenSizeY - UiSet.panelPool[panelID.QuickSlot].control:GetSizeY() - UiSet.panelPool[panelID.HPBar].control:GetSizeY() - UiSet.panelPool[panelID.ClassResource].control:GetSizeY() + 5
      elseif idx == panelID.Adrenallin then
        cachePosX[idx] = screenSizeX / 2 - UiSet.panelPool[panelID.Adrenallin].control:GetSizeX() / 2 + 225
        cachePosY[idx] = screenSizeY - UiSet.panelPool[panelID.QuickSlot].control:GetSizeY() - 76
      elseif idx == panelID.House then
        cachePosX[idx] = 10
        if Panel_Window_Servant:GetShow() then
          cachePosX[idx] = UiSet.panelPool[panelID.ServantIcon].control:GetSizeX() + 10
        end
        cachePosY[idx] = UiSet.panelPool[panelID.ExpGage].control:GetPosY() + UiSet.panelPool[panelID.ExpGage].control:GetSizeY() + 15
      elseif idx == panelID.NewEquip then
        cachePosX[idx] = FGlobal_GetPersonalIconPosY(4) + FGlobal_GetPersonalIconSizeY()
        cachePosY[idx] = FGlobal_GetPersonalIconPosX(4)
      elseif idx == panelID.ActionGuide then
        cacahePosX[idx] = screenSizeX / 2 * 1.2
        cachePosY[idx] = screenSizeY / 2 * 0.85
      elseif idx == panelID.KeyGuide then
        cachePosX[idx] = UiSet.panelPool[panelID.KeyGuide].control:GetSizeX() / 3
        cachePosY[idx] = UiSet.panelPool[panelID.KeyGuide].control:GetSizeY() * 2.3
      elseif idx == panelID.SkillCoolTime then
        cachePosX[idx] = screenSizeX * 0.33
        cachePosY[idx] = screenSizeY * 0.42
      elseif idx == panelID.MainQuest then
        cachePosX[idx] = screenSizeX - UiSet.panelPool[panelID.MainQuest].control:GetSizeX() - 20
        cachePosY[idx] = UiSet.panelPool[panelID.Radar].control:GetPosY() + UiSet.panelPool[panelID.Radar].control:GetSizeY() + 10
      end
      if idx == panelID.NewQuickSlot0 or idx == panelID.NewQuickSlot1 or idx == panelID.NewQuickSlot2 or idx == panelID.NewQuickSlot3 or idx == panelID.NewQuickSlot4 or idx == panelID.NewQuickSlot5 or idx == panelID.NewQuickSlot6 or idx == panelID.NewQuickSlot7 or idx == panelID.NewQuickSlot8 or idx == panelID.NewQuickSlot9 or idx == panelID.NewQuickSlot10 or idx == panelID.NewQuickSlot11 or idx == panelID.NewQuickSlot12 or idx == panelID.NewQuickSlot13 or idx == panelID.NewQuickSlot14 or idx == panelID.NewQuickSlot15 or idx == panelID.NewQuickSlot16 or idx == panelID.NewQuickSlot17 or idx == panelID.NewQuickSlot18 or idx == panelID.NewQuickSlot19 then
        local panelIdx = idx - panelID.NewQuickSlot0
        cachePosX[idx] = screenSizeX * 0.35 + (panelControl[idx].control:GetSizeX() + 5) * panelIdx
        cachePosY[idx] = screenSizeY - panelControl[idx].control:GetSizeY() - 5
      end
      if idx >= panelID.SkillCoolTimeQuickSlot0 and idx <= panelID.SkillCoolTimeQuickSlot9 then
        local panelIdx = idx - panelID.SkillCoolTimeQuickSlot0
        cachePosX[idx] = screenSizeX * 0.25 + panelControl[idx].control:GetSizeX() * (panelIdx % 2)
        cachePosY[idx] = screenSizeY * 0.29 + panelControl[idx].control:GetSizeY() * math.floor(panelIdx / 2)
      end
    end
    if false == _ContentsGroup_RemasterUI_Main_Alert then
      Panel_NewEquip_EffectLastUpdate()
    end
    FGlobal_ResetRadarUI(true)
    if nil ~= PaGlobal_WorldMiniMap then
      PaGlobal_WorldMiniMap:resetPanelSize()
    end
    HouseNaviBasicInitPosition()
    FGlobal_PetListNew_NoPet()
    PartyPanel_Repos()
    local count = ToClient_getChattingPanelCount()
    for chattingPanelindex = 0, count - 1 do
      Chatting_setIsOpenValue(chattingPanelindex, ChatPanelIsOpenState[chattingPanelindex + 1])
      ChatPanelIsOpenState[chattingPanelindex + 1] = false
    end
    Chatting_setIsOpenValue(0, true)
    ChatPanelIsOpenState[1] = true
    FGlobal_ChattingPanel_Reset()
    FGlobal_NewQuickSlot_InitPos(false)
    PaGlobal_SkillCoolTimeQuickSlot:settingPos(false)
    FGlobal_SkillCommand_ResetPosition()
    PaGlobalFunc_AppliedBuffList_ResetPosition()
    _isShowRemasterUI = true
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eSwapRemasterUISetting, _isShowRemasterUI, CppEnums.VariableStorageType.eVariableStorageType_User)
    FromClient_MainStatus_SwapUIOption(_isShowRemasterUI)
    UISetting_CheckOldMainStatus()
    resetGameUI()
    UiSet_update()
    ToClient_SaveUiInfo(true)
    FGlobal_MyHouseNavi_Update()
    if false == ToClient_isConsole() then
      ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
    end
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_ALLINTERFACERESET_CONFIRM")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_ALLINTERFACERESET"),
    content = messageBoxMemo,
    functionYes = reset_GameUI,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
UiSet_Initialize()
UiSet_registEventHandler()
UiSave.btn_SaveUI1:addInputEvent("Mouse_LUp", "savePresetInfo( " .. 0 .. ")")
UiSave.btn_SaveUI2:addInputEvent("Mouse_LUp", "savePresetInfo( " .. 1 .. ")")
UiSave.btn_SaveUI3:addInputEvent("Mouse_LUp", "savePresetInfo( " .. 2 .. ")")
UiSave.btn_SaveDefault:addInputEvent("Mouse_LUp", "HandleClicked_UiSet_ConfirmSetting()")
UiSet.btn_UIFreeSet1:addInputEvent("Mouse_LUp", "applyPresetInfo( " .. 0 .. ")")
UiSet.btn_UIFreeSet2:addInputEvent("Mouse_LUp", "applyPresetInfo( " .. 1 .. ")")
UiSet.btn_UIFreeSet3:addInputEvent("Mouse_LUp", "applyPresetInfo( " .. 2 .. ")")
UiSet.btn_DefaultSet1:addInputEvent("Mouse_LUp", "PaGlobal_UiSetting_DefaultSet(1)")
UiSet.btn_DefaultSet2:addInputEvent("Mouse_LUp", "PaGlobal_UiSetting_DefaultSet(2)")
if true == isGameTypeGT() or true == isGameServiceTypeDev() then
  UiSet.btn_DefaultSet1:setButtonShortcutsWithEvent("PaGlobal_UiSetting_DefaultSet(1)", "PANEL_UISETTING_COMBAT_FOCUS_MODE")
end
function savePresetInfo(presetIndex)
  local currentScreenSize = {
    x = getScreenSizeX(),
    y = getScreenSizeY()
  }
  for idx = 1, UiSet.panelCount do
    local slot = UiSet.panelPool[idx].control
    local controlPos = float2()
    controlPos.x = slot:GetPosX()
    controlPos.y = slot:GetPosY()
    local rateX = controlPos.x + slot:GetSizeX() / 2
    local rateY = controlPos.y + slot:GetSizeY() / 2
    local relativePos = float2()
    relativePos.x = rateX / currentScreenSize.x
    relativePos.y = rateY / currentScreenSize.y
    local isShow = panelControl[idx].isShow
    local controlShowToggle = UiSet.panelPool[idx].close:IsCheck()
    local uiType = panelControl[idx].PAGameUIType
    local chatWindowIndex = 0
    if idx >= panelID.Chat0 and idx <= panelID.Chat4 then
      chatWindowIndex = idx - panelID.Chat0
      local chatPanel = ToClient_getChattingPanel(idx - panelID.Chat0)
      local chatPanelSize = float2()
      chatPanelSize.x = chatPanel:getPanelSizeX()
      chatPanelSize.y = chatPanel:getPanelSizeY()
      ToClient_setUISettingChattingPanelInfo(presetIndex, chatWindowIndex, chatPanel:isOpen(), chatPanel:isCombinedToMainPanel(), uiType, controlPos, controlShowToggle, relativePos, chatPanelSize, setUISettingChattingPanelInfo)
      ToClient_setUISettingChattingOption(presetIndex, chatWindowIndex, Chatting_getUsedSmoothChattingUp())
      panelControl[idx].control:SetSize(sizeX, sizeY)
    end
    ToClient_setUISettingPanelInfo(uiType, controlPos.x, controlPos.y, controlShowToggle, chatWindowIndex, relativePos.x, relativePos.y)
  end
  ToClient_getGameUIManagerWrapper():saveUISettingPresetInfo(presetIndex)
  ToClient_getGameUIManagerWrapper():saveUISettingChattingPresetInfo(presetIndex)
  HandleClicked_UiSet_ConfirmSetting()
  local remasterUIIndex = 0
  if 0 == presetIndex then
    remasterUIIndex = __eSwapRemasterUISettingPreset0
  elseif 1 == presetIndex then
    remasterUIIndex = __eSwapRemasterUISettingPreset1
  elseif 2 == presetIndex then
    remasterUIIndex = __eSwapRemasterUISettingPreset2
  end
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(remasterUIIndex, not UiSet.btn_remsaterUI:IsCheck(), CppEnums.VariableStorageType.eVariableStorageType_User)
end
function applyPresetInfo(presetIndex)
  if ToClient_getGameUIManagerWrapper():isPresetListEmpty(presetIndex) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UISETTING_NOPRESET"))
    return
  end
  local remasterUIIndex = 0
  local isSetRemasterUI = false
  if 0 == presetIndex then
    remasterUIIndex = __eSwapRemasterUISettingPreset0
  elseif 1 == presetIndex then
    remasterUIIndex = __eSwapRemasterUISettingPreset1
  elseif 2 == presetIndex then
    remasterUIIndex = __eSwapRemasterUISettingPreset2
  end
  if false == ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(remasterUIIndex) then
    isSetRemasterUI = false
  else
    isSetRemasterUI = true
  end
  _isShowRemasterUI = isSetRemasterUI
  UiSet.btn_remsaterUI:SetCheck(not isSetRemasterUI)
  for idx = 1, UiSet.panelCount do
    local chatWindowIndex = 0
    if idx >= panelID.Chat0 and idx <= panelID.Chat4 then
      chatWindowIndex = idx - panelID.Chat0
      ToClient_getUISettingChattingPanelInfo(presetIndex, chatWindowIndex)
    end
    ToClient_getUISettingPanelInfo(presetIndex, idx, panelControl[idx].PAGameUIType, chatWindowIndex)
  end
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eSwapRemasterUISetting, _isShowRemasterUI, CppEnums.VariableStorageType.eVariableStorageType_User)
  FromClient_MainStatus_SwapUIOption(_isShowRemasterUI)
  UiSet_update()
  UiSet_ConfrimSetting_Sub(false)
end
function FromClient_getUiSettingChattingPanelInfo(chatWindowIndex, isOpen, isCombined, sizeX, sizeY, isUsedSmoothChattingup)
  local index = chatWindowIndex + panelID.Chat0
  closePanelState[chatWindowIndex] = false
  closeEmptyPanelState[chatWindowIndex] = false
  local chatPanel = ToClient_getChattingPanel(chatWindowIndex)
  if isOpen then
    ChatPanelIsOpenState[chatWindowIndex + 1] = true
    HandleClicked_Chatting_AddTabByIndex(chatWindowIndex)
    if index == panelID.Chat0 then
      UiSet.panelPool[index].control:SetShow(true)
      UiSet.panelPool[index].close:SetShow(true)
      panelControl[index].control:SetSize(sizeX, sizeY)
      UiSet.panelPool[index].control:SetSize(sizeX, sizeY)
      chatPanel:setPanelSize(sizeX, sizeY)
    elseif isCombined then
      HandleClicked_Chatting_Close(chatWindowIndex, 0)
      UiSet.panelPool[index].control:SetShow(false)
      UiSet.panelPool[index].close:SetShow(false)
    else
      HandleClicked_Chatting_Division(chatWindowIndex)
      UiSet.panelPool[index].control:SetShow(true)
      UiSet.panelPool[index].close:SetShow(true)
      panelControl[index].control:SetSize(sizeX, sizeY)
      UiSet.panelPool[index].control:SetSize(sizeX, sizeY)
      chatPanel:setPanelSize(sizeX, sizeY)
    end
  elseif isCombined == false or index == panelID.Chat0 then
    if index ~= panelID.Chat0 then
      HandleClicked_Chatting_Division(chatWindowIndex)
    end
    UiSet.panelPool[index].control:SetShow(true)
    UiSet.panelPool[index].close:SetShow(true)
    panelControl[index].control:SetSize(sizeX, sizeY)
    UiSet.panelPool[index].control:SetSize(sizeX, sizeY)
    panelControl[index].control:SetShow(true)
    chatPanel:setPanelSize(sizeX, sizeY)
    closeEmptyPanelState[chatWindowIndex] = true
    ChatPanelIsOpenState[chatWindowIndex + 1] = false
  else
    UiSet.panelPool[index].control:SetShow(false)
    UiSet.panelPool[index].close:SetShow(false)
    HandleClicked_Chatting_Close(chatWindowIndex, 0)
    closePanelState[chatWindowIndex] = true
  end
  Chatting_setUsedSmoothChattingUp(isUsedSmoothChattingup)
end
function FromClient_getUiSettingPanelInfo(panelIndex, posX, posY, isShow, chatWindowIndex, relativePosX, relativePosY)
  if panelControl[panelIndex].posFixed == false then
    UiSet.panelPool[panelIndex].control:SetPosX(posX)
    UiSet.panelPool[panelIndex].control:SetPosY(posY)
    UiSet.panelPool[panelIndex].control:SetRelativePosX(relativePosX)
    UiSet.panelPool[panelIndex].control:SetRelativePosY(relativePosY)
    panelControl[panelIndex].control:SetPosX(posX)
    panelControl[panelIndex].control:SetPosY(posY)
    panelControl[panelIndex].control:SetRelativePosX(relativePosX)
    panelControl[panelIndex].control:SetRelativePosY(relativePosY)
    panelControl[panelIndex].isChange = true
  else
    panelControl[panelIndex].isChange = false
  end
  UiSet.panelPool[panelIndex].control:SetShow(isShow)
  panelControl[panelIndex].control:SetShow(isShow)
  if true == _ContentsGroup_RenewUI_Main then
    panelControl[panelID.UIMain].control:SetShow(false)
  end
  if closeEmptyPanelState[panelIndex - panelID.Chat0] == false then
    panelControl[panelIndex].control:SetShow(isShow)
  end
  if false == _ContentsGroup_RenewUI and panelIndex == panelID.GameTip then
    Panel_GameTipMask:SetShow(isShow)
  end
  if UiSet.panelPool[panelIndex].close:IsCheck() ~= isShow then
    if panelIndex == panelID.ActionGuide then
      isChecked_SkillCommand = isShow
    end
    if panelIndex ~= panelID.House and panelIndex ~= panelID.NewEquip and panelIndex ~= panelID.Party and panelIndex ~= panelID.QuickSlot and panelIndex ~= panelID.Adrenallin and panelIndex ~= panelID.LargeParty then
      HandleClicked_UiSet_ControlShowToggle(panelIndex)
    end
  end
end
function PaGlobal_SimpleTooltips(isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_SAVESETTING")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_SAVESETTING_BTN_DESC")
  control = UiSet.btn_save
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_SimpleTooltips_Index(isShow, idx)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if idx >= 46 and idx <= 55 then
    local name, desc, control
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILLCOOLTIME_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_UISETTING_COOLTIME_DESC")
    control = UiSet.panelPool[idx].control
    TooltipSimple_Show(control, name, desc)
  end
end
function FromClient_applyChattingOptionToLua(presetIndex, chatWindowIndex, chatFontSizeType, chatNameType, isCombined, transparency, isUsedSmoothChattingUp)
  ChattingOption_Open(chatWindowIndex, chatWindowIndex, isCombined)
  FGlobal_Chatting_PanelTransparency(chatWindowIndex, transparency, false)
  HandleClicked_ChattingTypeFilter_Notice(chatWindowIndex)
  HandleClicked_ChattingTypeFilter_World(chatWindowIndex)
  HandleClicked_ChattingTypeFilter_Battle(chatWindowIndex)
  HandleClicked_ChattingTypeFilter_Public(chatWindowIndex)
  HandleClicked_ChattingTypeFilter_RolePlay(chatWindowIndex)
  HandleClicked_ChattingTypeFilter_Team(chatWindowIndex)
  HandleClicked_ChattingDivision()
  HandleClicked_ChattingTypeFilter_WorldWithItem(chatWindowIndex)
  HandleClicked_ChattingTypeFilter_Guild(chatWindowIndex)
  HandleClicked_ChattingTypeFilter_Party(chatWindowIndex)
  HandleClicked_ChattingTypeFilter_Private(chatWindowIndex)
  HandleClicked_ChattingTypeFilter_Arsha(chatWindowIndex)
  HandleClicked_ChattingTypeFilter_System(chatWindowIndex)
  HandleClicked_ChattingSystemTypeFilter_Undefine(chatWindowIndex)
  HandleClicked_ChattingSystemTypeFilter_PrivateItem(chatWindowIndex)
  HandleClicked_ChattingSystemTypeFilter_PartyItem(chatWindowIndex)
  HandleClicked_ChattingSystemTypeFilter_Market(chatWindowIndex)
  HandleClicked_ChattingSystemTypeFilter_Worker(chatWindowIndex)
  HandleClicked_ChattingSystemTypeFilter_Harvest(chatWindowIndex)
  HandleClicked_ChattingColor_Notice(chatWindowIndex)
  HandleClicked_ChattingColor_World(chatWindowIndex)
  HandleClicked_ChattingColor_Public(chatWindowIndex)
  HandleClicked_ChattingColor_RolePlay(chatWindowIndex)
  HandleClicked_ChattingColor_Team(chatWindowIndex)
  HandleClicked_ChattingColor_WorldWithItem(chatWindowIndex)
  HandleClicked_ChattingColor_Guild(chatWindowIndex)
  HandleClicked_ChattingColor_Party(chatWindowIndex)
  HandleClicked_ChattingColor_Private(chatWindowIndex)
  HandleClicked_ChattingColor_Arsha(chatWindowIndex)
  HandleClicked_ChattingColor_MainSystem(chatWindowIndex)
  Panel_ChatOption:SetShow(false, false)
  Panel_ChatOption:SetIgnore(true)
  ChattingColor_Hide()
  Chatting_setUsedSmoothChattingUp(isUsedSmoothChattingUp)
  ChattingOption_UpdateChattingAnimationControl(isUsedSmoothChattingUp)
  setisChangeFontSize(true)
end
function UISetting_CheckOldMainStatus()
  if true == _ContentsGroup_RemasterUI_Main then
    panelControl[panelID.MainStatusRemaster].control:SetShow(panelControl[panelID.MainStatusRemaster].isShow and PaGlobalFunc_IsRemasterUIOption())
    panelControl[panelID.ExpGage].control:SetShow(panelControl[panelID.ExpGage].isShow and not PaGlobalFunc_IsRemasterUIOption())
    panelControl[panelID.Adrenallin].control:SetShow(panelControl[panelID.Adrenallin].isShow and not PaGlobalFunc_IsRemasterUIOption())
    panelControl[panelID.Pvp].control:SetShow(panelControl[panelID.Pvp].isShow and not PaGlobalFunc_IsRemasterUIOption())
    panelControl[panelID.ClassResource].control:SetShow(panelControl[panelID.ClassResource].isShow and not PaGlobalFunc_IsRemasterUIOption())
    panelControl[panelID.HPBar].control:SetShow(panelControl[panelID.HPBar].isShow and not PaGlobalFunc_IsRemasterUIOption())
    panelControl[panelID.House].control:SetShow(false)
    panelControl[panelID.ServantIcon].control:SetShow(false)
    panelControl[panelID.NewEquip].control:SetShow(false)
  end
end
registerEvent("FromClient_getUiSettingPanelInfo", "FromClient_getUiSettingPanelInfo")
registerEvent("FromClient_getUiSettingChattingPanelInfo", "FromClient_getUiSettingChattingPanelInfo")
registerEvent("FromClient_applyChattingOptionToLua", "FromClient_applyChattingOptionToLua")
registerEvent("onScreenResize", "UiSet_OnScreenEvent")
renderMode:setClosefunctor(renderMode, FGlobal_UiSet_Close)
