Panel_SetShortCut:SetShow(false)
local UI_color = Defines.Color
local newShortCut = {
  ui = {
    key_ESC = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_ESC"),
    key_F1 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_F1"),
    key_F2 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_F2"),
    key_F3 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_F3"),
    key_F4 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_F4"),
    key_F5 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_F5"),
    key_F6 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_F6"),
    key_F7 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_F7"),
    key_F8 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_F8"),
    key_F9 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_F9"),
    key_F10 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_F10"),
    key_F11 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_F11"),
    key_F12 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_F12"),
    key_Wave = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Wave"),
    key_1 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_1"),
    key_2 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_2"),
    key_3 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_3"),
    key_4 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_4"),
    key_5 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_5"),
    key_6 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_6"),
    key_7 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_7"),
    key_8 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_8"),
    key_9 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_9"),
    key_0 = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_0"),
    key_Minus = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Minus"),
    key_Plus = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Plus"),
    key_BackSpace = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_BackSpace"),
    key_Tab = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Tab"),
    key_Q = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Q"),
    key_W = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_W"),
    key_E = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_E"),
    key_R = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_R"),
    key_T = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_T"),
    key_Y = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Y"),
    key_U = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_U"),
    key_I = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_I"),
    key_O = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_O"),
    key_P = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_P"),
    key_MiddilParenthesisLeft = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_MiddilParenthesisLeft"),
    key_MiddilParenthesisRight = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_MiddilParenthesisRight"),
    key_ReverseSlash = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_ReverseSlash"),
    key_Caps = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Caps"),
    key_A = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_A"),
    key_S = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_S"),
    key_D = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_D"),
    key_F = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_F"),
    key_G = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_G"),
    key_H = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_H"),
    key_J = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_J"),
    key_K = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_K"),
    key_L = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_L"),
    key_Colon = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Colon"),
    key_DubbleQuotes = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_DubbleQuotes"),
    key_Enter = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Enter"),
    key_ShiftLeft = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_ShiftLeft"),
    key_Z = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Z"),
    key_X = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_X"),
    key_C = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_C"),
    key_V = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_V"),
    key_B = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_B"),
    key_N = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_N"),
    key_M = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_M"),
    key_Comma = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Comma"),
    key_Dot = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Dot"),
    key_Question = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Question"),
    key_ShiftRight = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_ShiftRight"),
    key_CtrlLeft = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_CtrlLeft"),
    key_WinLeft = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_WinLeft"),
    key_AltLeft = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_AltLeft"),
    key_Space = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_Space"),
    key_AltRight = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_AltRight"),
    key_WinRight = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_WinRight"),
    key_CtrlRight = UI.getChildControl(Panel_SetShortCut, "StaticText_Key_CtrlRight"),
    guideMsg = UI.getChildControl(Panel_SetShortCut, "Static_NotifyText"),
    noneSetKeyBG = UI.getChildControl(Panel_SetShortCut, "Static_BotBG"),
    noneSetKeyScroll = UI.getChildControl(Panel_SetShortCut, "Scroll_List"),
    btn_Close = UI.getChildControl(Panel_SetShortCut, "Button_Win_Close"),
    btn_Question = UI.getChildControl(Panel_SetShortCut, "Button_Question"),
    btn_UnSet = UI.getChildControl(Panel_SetShortCut, "Button_Key_Unset")
  },
  noneSetPool = {},
  noneSetDataArray = {},
  config = {
    tempKey = -1,
    tempType = false,
    noneSetCount = 0,
    noneSetUiCount = 6,
    noneSetUiGapX = 230,
    noneSetImportantCount = 0,
    noneSetStartIdx = 0
  }
}
local keyMatching = {
  [CppEnums.VirtualKeyCode.KeyCode_ESCAPE] = {
    ui = newShortCut.ui.key_ESC,
    isEnable = false
  },
  [CppEnums.VirtualKeyCode.KeyCode_F1] = {
    ui = newShortCut.ui.key_F1,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_F2] = {
    ui = newShortCut.ui.key_F2,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_F3] = {
    ui = newShortCut.ui.key_F3,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_F4] = {
    ui = newShortCut.ui.key_F4,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_F5] = {
    ui = newShortCut.ui.key_F5,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_F6] = {
    ui = newShortCut.ui.key_F6,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_F7] = {
    ui = newShortCut.ui.key_F7,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_F8] = {
    ui = newShortCut.ui.key_F8,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_F9] = {
    ui = newShortCut.ui.key_F9,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_F10] = {
    ui = newShortCut.ui.key_F10,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_F11] = {
    ui = newShortCut.ui.key_F11,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_F12] = {
    ui = newShortCut.ui.key_F12,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_OEM_3] = {
    ui = newShortCut.ui.key_Wave,
    isEnable = false
  },
  [CppEnums.VirtualKeyCode.KeyCode_1] = {
    ui = newShortCut.ui.key_1,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_2] = {
    ui = newShortCut.ui.key_2,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_3] = {
    ui = newShortCut.ui.key_3,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_4] = {
    ui = newShortCut.ui.key_4,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_5] = {
    ui = newShortCut.ui.key_5,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_6] = {
    ui = newShortCut.ui.key_6,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_7] = {
    ui = newShortCut.ui.key_7,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_8] = {
    ui = newShortCut.ui.key_8,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_9] = {
    ui = newShortCut.ui.key_9,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_0] = {
    ui = newShortCut.ui.key_0,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_SUBTRACT] = {
    ui = newShortCut.ui.key_Minus,
    isEnable = false
  },
  [CppEnums.VirtualKeyCode.KeyCode_ADD] = {
    ui = newShortCut.ui.key_Plus,
    isEnable = false
  },
  [CppEnums.VirtualKeyCode.KeyCode_BACK] = {
    ui = newShortCut.ui.key_BackSpace,
    isEnable = false
  },
  [CppEnums.VirtualKeyCode.KeyCode_TAB] = {
    ui = newShortCut.ui.key_Tab,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_Q] = {
    ui = newShortCut.ui.key_Q,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_W] = {
    ui = newShortCut.ui.key_W,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_E] = {
    ui = newShortCut.ui.key_E,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_R] = {
    ui = newShortCut.ui.key_R,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_T] = {
    ui = newShortCut.ui.key_T,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_Y] = {
    ui = newShortCut.ui.key_Y,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_U] = {
    ui = newShortCut.ui.key_U,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_I] = {
    ui = newShortCut.ui.key_I,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_O] = {
    ui = newShortCut.ui.key_O,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_P] = {
    ui = newShortCut.ui.key_P,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_CAPITAL] = {
    ui = newShortCut.ui.key_Caps,
    isEnable = false
  },
  [CppEnums.VirtualKeyCode.KeyCode_A] = {
    ui = newShortCut.ui.key_A,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_S] = {
    ui = newShortCut.ui.key_S,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_D] = {
    ui = newShortCut.ui.key_D,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_F] = {
    ui = newShortCut.ui.key_F,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_G] = {
    ui = newShortCut.ui.key_G,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_H] = {
    ui = newShortCut.ui.key_H,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_J] = {
    ui = newShortCut.ui.key_J,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_K] = {
    ui = newShortCut.ui.key_K,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_L] = {
    ui = newShortCut.ui.key_L,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_OEM_7] = {
    ui = newShortCut.ui.key_DubbleQuotes,
    isEnable = false
  },
  [CppEnums.VirtualKeyCode.KeyCode_RETURN] = {
    ui = newShortCut.ui.key_Enter,
    isEnable = false
  },
  [CppEnums.VirtualKeyCode.KeyCode_Z] = {
    ui = newShortCut.ui.key_Z,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_X] = {
    ui = newShortCut.ui.key_X,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_C] = {
    ui = newShortCut.ui.key_C,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_V] = {
    ui = newShortCut.ui.key_V,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_B] = {
    ui = newShortCut.ui.key_B,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_N] = {
    ui = newShortCut.ui.key_N,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_M] = {
    ui = newShortCut.ui.key_M,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_OEM_2] = {
    ui = newShortCut.ui.key_Question,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_SHIFT] = {
    ui = newShortCut.ui.key_ShiftLeft,
    isEnable = true
  },
  [CppEnums.VirtualKeyCode.KeyCode_CONTROL] = {
    ui = newShortCut.ui.key_CtrlLeft,
    isEnable = false
  },
  [CppEnums.VirtualKeyCode.KeyCode_MENU] = {
    ui = newShortCut.ui.key_AltLeft,
    isEnable = false
  },
  [CppEnums.VirtualKeyCode.KeyCode_SPACE] = {
    ui = newShortCut.ui.key_Space,
    isEnable = true
  }
}
local keyString = {
  [CppEnums.VirtualKeyCode.KeyCode_ESCAPE] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Esc"),
  [CppEnums.VirtualKeyCode.KeyCode_F1] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F1"),
  [CppEnums.VirtualKeyCode.KeyCode_F2] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F2"),
  [CppEnums.VirtualKeyCode.KeyCode_F3] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F3"),
  [CppEnums.VirtualKeyCode.KeyCode_F4] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F4"),
  [CppEnums.VirtualKeyCode.KeyCode_F5] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F5"),
  [CppEnums.VirtualKeyCode.KeyCode_F6] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F6"),
  [CppEnums.VirtualKeyCode.KeyCode_F7] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F7"),
  [CppEnums.VirtualKeyCode.KeyCode_F8] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F8"),
  [CppEnums.VirtualKeyCode.KeyCode_F9] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F9"),
  [CppEnums.VirtualKeyCode.KeyCode_F10] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F10"),
  [CppEnums.VirtualKeyCode.KeyCode_F11] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F11"),
  [CppEnums.VirtualKeyCode.KeyCode_F12] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F12"),
  [CppEnums.VirtualKeyCode.KeyCode_OEM_3] = "OEM_3",
  [CppEnums.VirtualKeyCode.KeyCode_1] = "1",
  [CppEnums.VirtualKeyCode.KeyCode_2] = "2",
  [CppEnums.VirtualKeyCode.KeyCode_3] = "3",
  [CppEnums.VirtualKeyCode.KeyCode_4] = "4",
  [CppEnums.VirtualKeyCode.KeyCode_5] = "5",
  [CppEnums.VirtualKeyCode.KeyCode_6] = "6",
  [CppEnums.VirtualKeyCode.KeyCode_7] = "7",
  [CppEnums.VirtualKeyCode.KeyCode_8] = "8",
  [CppEnums.VirtualKeyCode.KeyCode_9] = "9",
  [CppEnums.VirtualKeyCode.KeyCode_0] = "0",
  [CppEnums.VirtualKeyCode.KeyCode_SUBTRACT] = "SUBTRACT",
  [CppEnums.VirtualKeyCode.KeyCode_ADD] = "ADD",
  [CppEnums.VirtualKeyCode.KeyCode_BACK] = "BACK",
  [CppEnums.VirtualKeyCode.KeyCode_TAB] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Tab"),
  [CppEnums.VirtualKeyCode.KeyCode_Q] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Q"),
  [CppEnums.VirtualKeyCode.KeyCode_W] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_W"),
  [CppEnums.VirtualKeyCode.KeyCode_E] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_E"),
  [CppEnums.VirtualKeyCode.KeyCode_R] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_R"),
  [CppEnums.VirtualKeyCode.KeyCode_T] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_T"),
  [CppEnums.VirtualKeyCode.KeyCode_Y] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Y"),
  [CppEnums.VirtualKeyCode.KeyCode_U] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_U"),
  [CppEnums.VirtualKeyCode.KeyCode_I] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_I"),
  [CppEnums.VirtualKeyCode.KeyCode_O] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_O"),
  [CppEnums.VirtualKeyCode.KeyCode_P] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_P"),
  [CppEnums.VirtualKeyCode.KeyCode_CAPITAL] = "CAPITAL",
  [CppEnums.VirtualKeyCode.KeyCode_A] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_A"),
  [CppEnums.VirtualKeyCode.KeyCode_S] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_S"),
  [CppEnums.VirtualKeyCode.KeyCode_D] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_D"),
  [CppEnums.VirtualKeyCode.KeyCode_F] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F"),
  [CppEnums.VirtualKeyCode.KeyCode_G] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_G"),
  [CppEnums.VirtualKeyCode.KeyCode_H] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_H"),
  [CppEnums.VirtualKeyCode.KeyCode_J] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_J"),
  [CppEnums.VirtualKeyCode.KeyCode_K] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_K"),
  [CppEnums.VirtualKeyCode.KeyCode_L] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_L"),
  [CppEnums.VirtualKeyCode.KeyCode_OEM_7] = "'",
  [CppEnums.VirtualKeyCode.KeyCode_RETURN] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Enter"),
  [CppEnums.VirtualKeyCode.KeyCode_SHIFT] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Shift"),
  [CppEnums.VirtualKeyCode.KeyCode_Z] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Z"),
  [CppEnums.VirtualKeyCode.KeyCode_X] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_X"),
  [CppEnums.VirtualKeyCode.KeyCode_C] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_C"),
  [CppEnums.VirtualKeyCode.KeyCode_V] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_V"),
  [CppEnums.VirtualKeyCode.KeyCode_B] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_B"),
  [CppEnums.VirtualKeyCode.KeyCode_N] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_N"),
  [CppEnums.VirtualKeyCode.KeyCode_M] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_M"),
  [CppEnums.VirtualKeyCode.KeyCode_OEM_2] = "/",
  [CppEnums.VirtualKeyCode.KeyCode_SHIFT] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Shift"),
  [CppEnums.VirtualKeyCode.KeyCode_CONTROL] = "CONTROL",
  [CppEnums.VirtualKeyCode.KeyCode_MENU] = "MENU",
  [CppEnums.VirtualKeyCode.KeyCode_SPACE] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Space")
}
local actionString = {
  [CppEnums.ActionInputType.ActionInputType_MoveFront] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_0"),
  [CppEnums.ActionInputType.ActionInputType_MoveBack] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_1"),
  [CppEnums.ActionInputType.ActionInputType_MoveLeft] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_2"),
  [CppEnums.ActionInputType.ActionInputType_MoveRight] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_3"),
  [CppEnums.ActionInputType.ActionInputType_Attack1] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_4"),
  [CppEnums.ActionInputType.ActionInputType_Attack2] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_5"),
  [CppEnums.ActionInputType.ActionInputType_Dash] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_6"),
  [CppEnums.ActionInputType.ActionInputType_Jump] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_7"),
  [CppEnums.ActionInputType.ActionInputType_Interaction] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_8"),
  [CppEnums.ActionInputType.ActionInputType_AutoRun] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_9"),
  [CppEnums.ActionInputType.ActionInputType_WeaponInOut] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_10"),
  [CppEnums.ActionInputType.ActionInputType_CameraReset] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_11"),
  [CppEnums.ActionInputType.ActionInputType_CrouchOrSkill] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_12"),
  [CppEnums.ActionInputType.ActionInputType_GrabOrGuard] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_13"),
  [CppEnums.ActionInputType.ActionInputType_Kick] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_14"),
  [CppEnums.ActionInputType.ActionInputType_ServantOrder1] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_15"),
  [CppEnums.ActionInputType.ActionInputType_ServantOrder2] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_16"),
  [CppEnums.ActionInputType.ActionInputType_ServantOrder3] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_17"),
  [CppEnums.ActionInputType.ActionInputType_ServantOrder4] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_18"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot1] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_19"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot2] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_20"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot3] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_21"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot4] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_22"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot5] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_23"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot6] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_24"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot7] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_25"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot8] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_26"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot9] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_27"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot10] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_28"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot11] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_29"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot12] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_30"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot13] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_31"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot14] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_32"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot15] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_33"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot16] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_34"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot17] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_35"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot18] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_36"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot19] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_37"),
  [CppEnums.ActionInputType.ActionInputType_QuickSlot20] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_38"),
  [CppEnums.ActionInputType.ActionInputType_Complicated0] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_39"),
  [CppEnums.ActionInputType.ActionInputType_Complicated1] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_40"),
  [CppEnums.ActionInputType.ActionInputType_Complicated2] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_41"),
  [CppEnums.ActionInputType.ActionInputType_Complicated3] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_42"),
  [CppEnums.ActionInputType.ActionInputType_AutoMoveWalkMode] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_43"),
  [CppEnums.ActionInputType.ActionInputType_CameraUp] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_44"),
  [CppEnums.ActionInputType.ActionInputType_CameraDown] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_45"),
  [CppEnums.ActionInputType.ActionInputType_CameraLeft] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_46"),
  [CppEnums.ActionInputType.ActionInputType_CameraRight] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_47"),
  [CppEnums.ActionInputType.ActionInputType_CameraRotateGameMode] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_48"),
  [CppEnums.ActionInputType.ActionInputType_PushToTalk] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_49"),
  [CppEnums.ActionInputType.ActionInputType_Undefined] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_00")
}
local uiString = {
  [CppEnums.UiInputType.UiInputType_CursorOnOff] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_0"),
  [CppEnums.UiInputType.UiInputType_Help] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_1"),
  [CppEnums.UiInputType.UiInputType_MentalKnowledge] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_2"),
  [CppEnums.UiInputType.UiInputType_Inventory] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_3"),
  [CppEnums.UiInputType.UiInputType_BlackSpirit] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_4"),
  [CppEnums.UiInputType.UiInputType_Chat] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_5"),
  [CppEnums.UiInputType.UiInputType_PlayerInfo] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_6"),
  [CppEnums.UiInputType.UiInputType_Skill] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_7"),
  [CppEnums.UiInputType.UiInputType_WorldMap] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_8"),
  [CppEnums.UiInputType.UiInputType_Dyeing] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_9"),
  [CppEnums.UiInputType.UiInputType_ProductionNote] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_10"),
  [CppEnums.UiInputType.UiInputType_Manufacture] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_11"),
  [CppEnums.UiInputType.UiInputType_Guild] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_12"),
  [CppEnums.UiInputType.UiInputType_Mail] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_13"),
  [CppEnums.UiInputType.UiInputType_FriendList] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_14"),
  [CppEnums.UiInputType.UiInputType_Present] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_15"),
  [CppEnums.UiInputType.UiInputType_QuestHistory] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_16"),
  [CppEnums.UiInputType.UiInputType_Cancel] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_17"),
  [CppEnums.UiInputType.UiInputType_CashShop] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_18"),
  [CppEnums.UiInputType.UiInputType_BeautyShop] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_19"),
  [CppEnums.UiInputType.UiInputType_AlchemySton] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_20"),
  [CppEnums.UiInputType.UiInputType_Undefined] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_00"),
  [CppEnums.UiInputType.UiInputType_House] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_21"),
  [CppEnums.UiInputType.UiInputType_Worker] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_22"),
  [CppEnums.UiInputType.UiInputType_Pet] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_23"),
  [CppEnums.UiInputType.UiInputType_Maid] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_24"),
  [CppEnums.UiInputType.UiInputType_Servant] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_25"),
  [CppEnums.UiInputType.UiInputType_GuildServant] = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_26")
}
local shortCutType = {action = 0, ui = 1}
local defaultShortCut = {
  [CppEnums.ContryCode.eContryCode_KOR] = {
    [shortCutType.action] = {
      [CppEnums.ActionInputType.ActionInputType_MoveFront] = CppEnums.VirtualKeyCode.KeyCode_W,
      [CppEnums.ActionInputType.ActionInputType_MoveBack] = CppEnums.VirtualKeyCode.KeyCode_S,
      [CppEnums.ActionInputType.ActionInputType_MoveLeft] = CppEnums.VirtualKeyCode.KeyCode_A,
      [CppEnums.ActionInputType.ActionInputType_MoveRight] = CppEnums.VirtualKeyCode.KeyCode_D,
      [CppEnums.ActionInputType.ActionInputType_Attack1] = CppEnums.VirtualKeyCode.KeyCode_LBUTTON,
      [CppEnums.ActionInputType.ActionInputType_Attack2] = CppEnums.VirtualKeyCode.KeyCode_RBUTTON,
      [CppEnums.ActionInputType.ActionInputType_Dash] = CppEnums.VirtualKeyCode.KeyCode_SHIFT,
      [CppEnums.ActionInputType.ActionInputType_Jump] = CppEnums.VirtualKeyCode.KeyCode_SPACE,
      [CppEnums.ActionInputType.ActionInputType_Interaction] = CppEnums.VirtualKeyCode.KeyCode_R,
      [CppEnums.ActionInputType.ActionInputType_AutoRun] = CppEnums.VirtualKeyCode.KeyCode_T,
      [CppEnums.ActionInputType.ActionInputType_WeaponInOut] = CppEnums.VirtualKeyCode.KeyCode_TAB,
      [CppEnums.ActionInputType.ActionInputType_CameraReset] = nil,
      [CppEnums.ActionInputType.ActionInputType_CrouchOrSkill] = CppEnums.VirtualKeyCode.KeyCode_Q,
      [CppEnums.ActionInputType.ActionInputType_GrabOrGuard] = CppEnums.VirtualKeyCode.KeyCode_E,
      [CppEnums.ActionInputType.ActionInputType_Kick] = CppEnums.VirtualKeyCode.KeyCode_F,
      [CppEnums.ActionInputType.ActionInputType_ServantOrder1] = CppEnums.VirtualKeyCode.KeyCode_Z,
      [CppEnums.ActionInputType.ActionInputType_ServantOrder2] = CppEnums.VirtualKeyCode.KeyCode_X,
      [CppEnums.ActionInputType.ActionInputType_ServantOrder3] = CppEnums.VirtualKeyCode.KeyCode_C,
      [CppEnums.ActionInputType.ActionInputType_ServantOrder4] = CppEnums.VirtualKeyCode.KeyCode_V,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot1] = CppEnums.VirtualKeyCode.KeyCode_0,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot2] = CppEnums.VirtualKeyCode.KeyCode_1,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot3] = CppEnums.VirtualKeyCode.KeyCode_2,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot4] = CppEnums.VirtualKeyCode.KeyCode_3,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot5] = CppEnums.VirtualKeyCode.KeyCode_4,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot6] = CppEnums.VirtualKeyCode.KeyCode_5,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot7] = CppEnums.VirtualKeyCode.KeyCode_6,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot8] = CppEnums.VirtualKeyCode.KeyCode_7,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot9] = CppEnums.VirtualKeyCode.KeyCode_8,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot10] = CppEnums.VirtualKeyCode.KeyCode_9,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot11] = nil,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot12] = nil,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot13] = nil,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot14] = nil,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot15] = nil,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot16] = nil,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot17] = nil,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot18] = nil,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot19] = nil,
      [CppEnums.ActionInputType.ActionInputType_QuickSlot20] = nil
    },
    [shortCutType.ui] = {
      [CppEnums.UiInputType.UiInputType_CursorOnOff] = CppEnums.VirtualKeyCode.KeyCode_CONTROL,
      [CppEnums.UiInputType.UiInputType_Help] = CppEnums.VirtualKeyCode.KeyCode_F1,
      [CppEnums.UiInputType.UiInputType_MentalKnowledge] = CppEnums.VirtualKeyCode.KeyCode_H,
      [CppEnums.UiInputType.UiInputType_Inventory] = CppEnums.VirtualKeyCode.KeyCode_I,
      [CppEnums.UiInputType.UiInputType_BlackSpirit] = CppEnums.VirtualKeyCode.KeyCode_OEM_2,
      [CppEnums.UiInputType.UiInputType_Chat] = CppEnums.VirtualKeyCode.KeyCode_RETURN,
      [CppEnums.UiInputType.UiInputType_PlayerInfo] = CppEnums.VirtualKeyCode.KeyCode_P,
      [CppEnums.UiInputType.UiInputType_Skill] = CppEnums.VirtualKeyCode.KeyCode_K,
      [CppEnums.UiInputType.UiInputType_WorldMap] = CppEnums.VirtualKeyCode.KeyCode_M,
      [CppEnums.UiInputType.UiInputType_Dyeing] = CppEnums.VirtualKeyCode.KeyCode_J,
      [CppEnums.UiInputType.UiInputType_ProductionNote] = CppEnums.VirtualKeyCode.KeyCode_F2,
      [CppEnums.UiInputType.UiInputType_Manufacture] = CppEnums.VirtualKeyCode.KeyCode_L,
      [CppEnums.UiInputType.UiInputType_Guild] = CppEnums.VirtualKeyCode.KeyCode_G,
      [CppEnums.UiInputType.UiInputType_Mail] = CppEnums.VirtualKeyCode.KeyCode_B,
      [CppEnums.UiInputType.UiInputType_FriendList] = CppEnums.VirtualKeyCode.KeyCode_N,
      [CppEnums.UiInputType.UiInputType_Present] = CppEnums.VirtualKeyCode.KeyCode_Y,
      [CppEnums.UiInputType.UiInputType_QuestHistory] = CppEnums.VirtualKeyCode.KeyCode_O,
      [CppEnums.UiInputType.UiInputType_Cancel] = CppEnums.VirtualKeyCode.KeyCode_ESCAPE,
      [CppEnums.UiInputType.UiInputType_CashShop] = CppEnums.VirtualKeyCode.KeyCode_F3,
      [CppEnums.UiInputType.UiInputType_BeautyShop] = CppEnums.VirtualKeyCode.KeyCode_F4,
      [CppEnums.UiInputType.UiInputType_AlchemySton] = CppEnums.VirtualKeyCode.KeyCode_U,
      [CppEnums.UiInputType.UiInputType_House] = nil,
      [CppEnums.UiInputType.UiInputType_Worker] = nil,
      [CppEnums.UiInputType.UiInputType_Pet] = nil,
      [CppEnums.UiInputType.UiInputType_Maid] = nil,
      [CppEnums.UiInputType.UiInputType_Servant] = nil,
      [CppEnums.UiInputType.UiInputType_GuildServant] = nil
    }
  },
  [CppEnums.ContryCode.eContryCode_JAP] = {
    [shortCutType.action] = {},
    [shortCutType.ui] = {}
  },
  [CppEnums.ContryCode.eContryCode_RUS] = {
    [shortCutType.action] = {},
    [shortCutType.ui] = {}
  },
  [CppEnums.ContryCode.eContryCode_KR2] = {
    [shortCutType.action] = {},
    [shortCutType.ui] = {}
  },
  [CppEnums.ContryCode.eContryCode_NA] = {
    [shortCutType.action] = {},
    [shortCutType.ui] = {}
  }
}
local myKey = {
  action = {},
  ui = {}
}
function newShortCut:SetDefaultKey()
  for key, value in pairs(keyMatching) do
    local isDefine = keyCustom_IsDefine(key)
    if false == isDefine then
    else
      local actionKey = keyCustom_getDefineAction(key)
      if actionKey <= CppEnums.ActionInputType.ActionInputType_Undefined then
        myKey.action = {enums = actionKey, virtualKeyCode = key}
      else
        local uiKey = keyCustom_getDefineUI(key)
        if uiKey <= CppEnums.UiInputType.UiInputType_Undefined then
          myKey.ui = {enums = actionKey, virtualKeyCode = key}
        else
        end
      end
    end
  end
end
function newShortCut:Init()
  for noneSetIdx = 0, self.config.noneSetUiCount - 1 do
    local tempArray = {}
    tempArray.keyDesc = UI.createAndCopyBasePropertyControl(Panel_SetShortCut, "StaticText_SelectValue", self.ui.noneSetKeyBG, "SetShortCut_noneSetKeyDesc_" .. noneSetIdx)
    tempArray.btn = UI.createAndCopyBasePropertyControl(Panel_SetShortCut, "StaticText_SelectButton", tempArray.keyDesc, "SetShortCut_noneSetKeyBtn_" .. noneSetIdx)
    tempArray.keyDesc:SetPosX(10 + noneSetIdx % 2 * self.config.noneSetUiGapX)
    tempArray.keyDesc:SetPosY(33 + (tempArray.keyDesc:GetSizeY() + 5) * math.floor(noneSetIdx / 2))
    tempArray.btn:SetPosX(145)
    tempArray.btn:SetPosY(0)
    tempArray.keyDesc:addInputEvent("Mouse_UpScroll", "newShortCut_NoneSetScroll( true )")
    tempArray.keyDesc:addInputEvent("Mouse_DownScroll", "newShortCut_NoneSetScroll( false )")
    tempArray.btn:addInputEvent("Mouse_UpScroll", "newShortCut_NoneSetScroll( true )")
    tempArray.btn:addInputEvent("Mouse_DownScroll", "newShortCut_NoneSetScroll( false )")
    self.noneSetPool[noneSetIdx] = tempArray
  end
  newShortCut:Update()
end
function newShortCut:Update()
  for key, value in pairs(keyMatching) do
    local isDefine = keyCustom_IsDefine(key)
    if false == isDefine then
      value.ui:SetFontColor(UI_color.C_FFEFEFEF)
    else
      local actionKey = keyCustom_getDefineAction(key)
      if actionKey <= CppEnums.ActionInputType.ActionInputType_Undefined then
        value.ui:SetFontColor(UI_color.C_FFEF5378)
        value.ui:addInputEvent("Mouse_On", "HandleOnOut_newShortCut_ActionKeyToolTip( true, true, " .. actionKey .. ", " .. key .. " )")
        value.ui:addInputEvent("Mouse_Out", "HandleOnOut_newShortCut_ActionKeyToolTip( false, true, " .. actionKey .. ", " .. key .. " )")
        value.ui:setTooltipEventRegistFunc("HandleOnOut_newShortCut_ActionKeyToolTip( true, true, " .. actionKey .. ", " .. key .. " )")
      else
        local uiKey = keyCustom_getDefineUI(key)
        if uiKey <= CppEnums.UiInputType.UiInputType_Undefined then
          value.ui:SetFontColor(UI_color.C_FF8EBD00)
          value.ui:addInputEvent("Mouse_On", "HandleOnOut_newShortCut_ActionKeyToolTip( true, false, " .. uiKey .. ", " .. key .. " )")
          value.ui:addInputEvent("Mouse_Out", "HandleOnOut_newShortCut_ActionKeyToolTip( false, false, " .. uiKey .. ", " .. key .. " )")
          value.ui:setTooltipEventRegistFunc("HandleOnOut_newShortCut_ActionKeyToolTip( true, false, " .. uiKey .. ", " .. key .. " )")
        else
          _PA_ASSERT(true, "\236\181\156\235\140\128\237\152\184 : \237\130\164\234\176\128 \236\132\164\236\160\149\235\144\152\236\150\180 \236\158\136\235\139\164\235\169\180, \236\149\161\236\133\152\236\157\180\235\130\152 UI \236\164\145 \237\149\152\235\130\152\236\151\172\236\149\188 \237\149\152\235\138\148\235\141\176 ???")
        end
      end
    end
    if value.isEnable then
      value.ui:SetEnable(true)
    else
      value.ui:SetEnable(false)
      value.ui:SetFontColor(UI_color.C_FF888888)
    end
  end
  self:UpdateNoneSetKey()
end
function newShortCut:UpdateNoneSetKey()
  for idx = 0, self.config.noneSetUiCount - 1 do
    local slot = self.noneSetPool[idx]
    slot.keyDesc:SetShow(false)
  end
  self.noneSetDataArray = {}
  self.config.noneSetCount = 0
  self.config.noneSetImportantCount = 0
  for idx = 0, CppEnums.ActionInputType.ActionInputType_Undefined - 1 do
    local checkValue = keyCustom_GetString_ActionKey(idx)
    if "" == checkValue then
      local isImportant = self:CheckImportantShortCut(true, idx)
      if 1 == isImportant then
        self.config.noneSetImportantCount = self.config.noneSetImportantCount + 1
      end
      self.noneSetDataArray[self.config.noneSetCount] = {
        isAction = true,
        idx = idx,
        important = isImportant
      }
      self.config.noneSetCount = self.config.noneSetCount + 1
    end
  end
  for idx = 0, CppEnums.UiInputType.UiInputType_Undefined - 1 do
    local checkValue = keyCustom_GetString_UiKey(idx)
    if "" == checkValue then
      local isImportant = self:CheckImportantShortCut(false, idx)
      if 1 == isImportant then
        self.config.noneSetImportantCount = self.config.noneSetImportantCount + 1
      end
      self.noneSetDataArray[self.config.noneSetCount] = {
        isAction = false,
        idx = idx,
        important = isImportant
      }
      self.config.noneSetCount = self.config.noneSetCount + 1
    end
  end
  local noneSetKetSort = function(a, b)
    if b.important < a.important then
      return true
    else
      return false
    end
  end
  table.sort(self.noneSetDataArray, noneSetKetSort)
  local uiIdx = 0
  for idx = self.config.noneSetStartIdx, self.config.noneSetCount - 1 do
    if uiIdx >= self.config.noneSetUiCount then
      break
    end
    local data = self.noneSetDataArray[idx]
    local _string = ""
    if data.isAction then
      _string = actionString[data.idx]
    else
      _string = uiString[data.idx]
    end
    if nil == _string then
      _string = ""
    end
    local slot = self.noneSetPool[uiIdx]
    if 1 == data.important then
      slot.keyDesc:SetFontColor(UI_color.C_FFF26A6A)
      slot.btn:SetFontColor(UI_color.C_FFF26A6A)
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_SETSHORTCUT_NECESSARY") .. " " .. _string
    else
      slot.keyDesc:SetFontColor(UI_color.C_FFEFEFEF)
      slot.btn:SetFontColor(UI_color.C_FFEFEFEF)
    end
    slot.keyDesc:SetText(_string)
    slot.keyDesc:SetShow(true)
    slot.btn:addInputEvent("Mouse_LUp", "HandleClicked_NewShortCut_SetImportantKey( " .. idx .. ", " .. data.idx .. " )")
    uiIdx = uiIdx + 1
  end
  UIScroll.SetButtonSize(self.ui.noneSetKeyScroll, self.config.noneSetUiCount / 2, self.config.noneSetCount / 2)
  if self.config.noneSetCount > 6 then
    self.ui.noneSetKeyScroll:SetShow(true)
  else
    self.ui.noneSetKeyScroll:SetShow(false)
  end
end
function newShortCut:CheckImportantShortCut(isAction, key)
  if isAction then
    if key == CppEnums.ActionInputType.ActionInputType_MoveFront or key == CppEnums.ActionInputType.ActionInputType_MoveBack or key == CppEnums.ActionInputType.ActionInputType_MoveLeft or key == CppEnums.ActionInputType.ActionInputType_MoveRight or key == CppEnums.ActionInputType.ActionInputType_Attack1 or key == CppEnums.ActionInputType.ActionInputType_Attack2 or key == CppEnums.ActionInputType.ActionInputType_Dash or key == CppEnums.ActionInputType.ActionInputType_Jump or key == CppEnums.ActionInputType.ActionInputType_Interaction or key == CppEnums.ActionInputType.ActionInputType_CrouchOrSkill or key == CppEnums.ActionInputType.ActionInputType_GrabOrGuard or key == CppEnums.ActionInputType.ActionInputType_Kick or key == CppEnums.ActionInputType.ActionInputType_QuickSlot1 or key == CppEnums.ActionInputType.ActionInputType_QuickSlot2 or key == CppEnums.ActionInputType.ActionInputType_QuickSlot3 or key == CppEnums.ActionInputType.ActionInputType_QuickSlot4 or key == CppEnums.ActionInputType.ActionInputType_QuickSlot5 or key == CppEnums.ActionInputType.ActionInputType_QuickSlot6 or key == CppEnums.ActionInputType.ActionInputType_QuickSlot7 or key == CppEnums.ActionInputType.ActionInputType_QuickSlot8 or key == CppEnums.ActionInputType.ActionInputType_QuickSlot9 or key == CppEnums.ActionInputType.ActionInputType_QuickSlot10 then
      return 1
    end
  elseif key == CppEnums.UiInputType.UiInputType_Inventory or key == CppEnums.UiInputType.UiInputType_BlackSpirit or key == CppEnums.UiInputType.UiInputType_Chat or key == CppEnums.UiInputType.UiInputType_PlayerInfo or key == CppEnums.UiInputType.UiInputType_Skill or key == CppEnums.UiInputType.UiInputType_WorldMap or key == CppEnums.UiInputType.UiInputType_Manufacture or key == CppEnums.UiInputType.UiInputType_Guild or key == CppEnums.UiInputType.UiInputType_Mail or key == CppEnums.UiInputType.UiInputType_FriendList or key == CppEnums.UiInputType.UiInputType_QuestHistory or key == CppEnums.UiInputType.UiInputType_Cancel or key == CppEnums.UiInputType.UiInputType_CashShop or key == CppEnums.UiInputType.UiInputType_BeautyShop or key == CppEnums.UiInputType.UiInputType_AlchemySton or key == CppEnums.UiInputType.UiInputType_House or key == CppEnums.UiInputType.UiInputType_Worker or key == CppEnums.UiInputType.UiInputType_Pet or key == CppEnums.UiInputType.UiInputType_Maid or key == CppEnums.UiInputType.UiInputType_Servant or key == CppEnums.UiInputType.UiInputType_GuildServant then
    return 1
  end
  return 0
end
function newShortCut:Open()
  Panel_SetShortCut:SetShow(true)
  self:Update()
end
function newShortCut:Close()
  self.config.tempKey = -1
  self.config.tempType = false
  if Panel_Tooltip_SimpleText:GetShow() then
    TooltipSimple_Hide()
  end
  Panel_SetShortCut:SetShow(false)
end
function FGlobal_NewShortCut_SetQuickSlot(actionKey, isActionType)
  newShortCut.config.tempKey = actionKey
  newShortCut.config.tempType = isActionType
  newShortCut:Open()
  newShortCut:Update()
  local targetKeyString = ""
  if newShortCut.config.tempType then
    targetKeyString = actionString[newShortCut.config.tempKey]
  else
    targetKeyString = uiString[newShortCut.config.tempKey]
  end
  newShortCut.ui.guideMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SETSHORTCUT_SELECTKEY", "key", targetKeyString))
end
function FGlobal_NewShortCut_Close()
  newShortCut:Close()
end
function HandleClicked_NewShortCut_Close()
  newShortCut:Close()
end
function HandleClicked_NewShortCut_SetImportantKey(dataIdx, index)
  local data = newShortCut.noneSetDataArray[dataIdx]
  local string = ""
  if data.isAction then
    string = actionString[data.idx]
  else
    string = uiString[data.idx]
  end
  newShortCut.config.tempKey = data.idx
  newShortCut.config.tempType = data.isAction
  newShortCut.ui.guideMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SETSHORTCUT_SELECTKEY", "key", string))
end
function HandleOnOut_newShortCut_ActionKeyToolTip(isShow, isAction, keyIdx, uiIdx)
  local keyString = ""
  if isAction then
    keyString = actionString[keyIdx]
  else
    keyString = uiString[keyIdx]
  end
  local control = keyMatching[uiIdx].ui
  if isShow then
    registTooltipControl(control, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(control, keyString, nil)
  else
    TooltipSimple_Hide()
  end
end
function HandleClicked_NewShortCutPushed(virtualKeyCode)
  if -1 ~= newShortCut.config.tempKey then
    local function doSetKey()
      _NewShortCutPushed(virtualKeyCode)
    end
    local pressedKeyString = keyString[virtualKeyCode]
    local targetKeyString = ""
    if newShortCut.config.tempType then
      targetKeyString = actionString[newShortCut.config.tempKey]
    else
      targetKeyString = uiString[newShortCut.config.tempKey]
    end
    local messageBoxMemo = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SETSHORTCUT_SURETHISKEY", "press", pressedKeyString, "string", targetKeyString)
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = doSetKey,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function HandleClicked_NewShortCut_Unset()
  local string = ""
  if true == newShortCut.config.tempType then
    string = actionString[newShortCut.config.tempKey]
  else
    string = uiString[newShortCut.config.tempKey]
  end
  local function doUnSet()
    if true == newShortCut.config.tempType then
      keyCustom_clearActionVirtualKeyCode(newShortCut.config.tempKey)
    else
      keyCustom_clearUIVirtualKeyCode(newShortCut.config.tempKey)
    end
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SETSHORTCUT_DELETEKEY", "key", string))
    newShortCut:Close()
  end
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SETSHORTCUT_SUREDELETEKEY", "key", string)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = doUnSet,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function _NewShortCutPushed(virtualKeyCode)
  if true == newShortCut.config.tempType then
    keyCustom_CheckAndSet_ActionKeyUseVirtualKeyCode(newShortCut.config.tempKey, virtualKeyCode)
  else
    keyCustom_CheckAndSet_UiKeyUseVirtualKeyCode(newShortCut.config.tempKey, virtualKeyCode)
  end
  keyCustom_applyChange()
  newShortCut:Update()
  FGlobal_NewQuickSlot_Update()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SETSHORTCUT_COMPLETESETKEY"))
  newShortCut.config.tempKey = -1
  newShortCut:Close()
end
function newShortCut_NoneSetScroll(isScrollUp)
  newShortCut.config.noneSetStartIdx = UIScroll.ScrollEvent(newShortCut.ui.noneSetKeyScroll, isScrollUp, newShortCut.config.noneSetUiCount / 2, newShortCut.config.noneSetCount, newShortCut.config.noneSetStartIdx, 2)
  newShortCut:UpdateNoneSetKey()
end
function newShortCut:registEventHandler()
  for key, value in pairs(keyMatching) do
    if value.isEnable then
      value.ui:addInputEvent("Mouse_LUp", "HandleClicked_NewShortCutPushed( " .. key .. " )")
    end
  end
  self.ui.noneSetKeyBG:addInputEvent("Mouse_UpScroll", "newShortCut_NoneSetScroll( true )")
  self.ui.noneSetKeyBG:addInputEvent("Mouse_DownScroll", "newShortCut_NoneSetScroll( false )")
  self.ui.btn_UnSet:addInputEvent("Mouse_LUp", "HandleClicked_NewShortCut_Unset()")
  self.ui.btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_NewShortCut_Close()")
  if isGameTypeEnglish() then
    self.ui.btn_Question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"QuickSlot\" )")
  end
end
newShortCut:Init()
newShortCut:registEventHandler()
