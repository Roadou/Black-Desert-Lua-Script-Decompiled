local UI_TM = CppEnums.TextMode
local VCK = CppEnums.VirtualKeyCode
local UI_color = Defines.Color
Panel_Widget_Keyboard:SetDragAll(false)
Panel_Widget_Keyboard:SetIgnore(true)
local ui = {
  _button_Q = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_Q"),
  _button_W = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_W"),
  _button_A = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_A"),
  _button_S = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_S"),
  _button_D = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_D"),
  _button_E = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_E"),
  _button_F = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_F"),
  _button_C = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_C"),
  _button_Tab = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_Tab"),
  _button_Shift = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_Shift"),
  _button_Space = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_Space"),
  _m0 = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_M0"),
  _m1 = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_M1"),
  _mBody = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Mouse_Body"),
  _buttonLock = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Button_Lock"),
  _m0_Lock = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_M0_Lock"),
  _m1_Lock = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_M1_Lock")
}
local ui_2 = {
  _button_Q = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_Q_2"),
  _button_W = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_W_2"),
  _button_A = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_A_2"),
  _button_S = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_S_2"),
  _button_D = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_D_2"),
  _button_E = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_E_2"),
  _button_F = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_F_2"),
  _button_C = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_C_2"),
  _button_Tab = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_Tab_2"),
  _button_Shift = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_Shift_2"),
  _button_Space = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Btn_Space_2"),
  _m0 = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_M0_2"),
  _m1 = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_M1_2"),
  _mBody = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Mouse_Body_2"),
  _buttonLock = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_Button_Lock_2"),
  _m0_Lock = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_M0_Lock_2"),
  _m1_Lock = UI.getChildControl(Panel_Widget_Keyboard, "StaticText_M1_Lock_2")
}
local uvSet = {
  _m0 = {
    on = {
      1,
      66,
      74,
      143
    },
    click = {
      75,
      65,
      148,
      143
    },
    off = {
      149,
      66,
      222,
      143
    }
  },
  _m1 = {
    on = {
      1,
      144,
      74,
      221
    },
    click = {
      75,
      143,
      148,
      221
    },
    off = {
      149,
      144,
      222,
      221
    }
  },
  _button_W = {
    on = {
      1,
      1,
      63,
      65
    },
    click = {
      63,
      0,
      126,
      65
    },
    off = {
      127,
      1,
      189,
      65
    }
  },
  _button_A = {
    on = {
      1,
      1,
      63,
      65
    },
    click = {
      63,
      0,
      126,
      65
    },
    off = {
      127,
      1,
      189,
      65
    }
  },
  _button_S = {
    on = {
      1,
      1,
      63,
      65
    },
    click = {
      63,
      0,
      126,
      65
    },
    off = {
      127,
      1,
      189,
      65
    }
  },
  _button_D = {
    on = {
      1,
      1,
      63,
      65
    },
    click = {
      63,
      0,
      126,
      65
    },
    off = {
      127,
      1,
      189,
      65
    }
  },
  _button_E = {
    on = {
      1,
      1,
      63,
      65
    },
    click = {
      63,
      0,
      126,
      65
    },
    off = {
      127,
      1,
      189,
      65
    }
  },
  _button_F = {
    on = {
      1,
      1,
      63,
      65
    },
    click = {
      63,
      0,
      126,
      65
    },
    off = {
      127,
      1,
      189,
      65
    }
  },
  _button_C = {
    on = {
      1,
      1,
      63,
      65
    },
    click = {
      63,
      0,
      126,
      65
    },
    off = {
      127,
      1,
      189,
      65
    }
  },
  _button_Tab = {
    on = {
      1,
      1,
      63,
      65
    },
    click = {
      63,
      0,
      126,
      65
    },
    off = {
      127,
      1,
      189,
      65
    }
  },
  _button_Shift = {
    on = {
      1,
      1,
      63,
      65
    },
    click = {
      63,
      0,
      126,
      65
    },
    off = {
      127,
      1,
      189,
      65
    }
  },
  _button_Space = {
    on = {
      1,
      1,
      63,
      65
    },
    click = {
      63,
      0,
      126,
      65
    },
    off = {
      127,
      1,
      189,
      65
    }
  },
  _button_Q = {
    on = {
      1,
      1,
      63,
      65
    },
    click = {
      63,
      0,
      126,
      65
    },
    off = {
      127,
      1,
      189,
      65
    }
  }
}
local keyIndexSet = {
  _m0 = 4,
  _m1 = 5,
  _button_Q = 12,
  _button_W = 0,
  _button_A = 2,
  _button_S = 1,
  _button_D = 3,
  _button_E = 13,
  _button_F = 14,
  _button_C = 17,
  _button_T = 9,
  _button_Tab = 10,
  _button_Shift = 6,
  _button_Space = 7
}
local keyToVirtualKey = {
  _m0 = 4,
  _m1 = 5,
  _button_Q = 12,
  _button_W = 0,
  _button_A = 2,
  _button_S = 1,
  _button_D = 3,
  _button_E = 13,
  _button_F = 14,
  _button_C = 17,
  _button_T = 9,
  _button_Tab = 10,
  _button_Shift = 6,
  _button_Space = 7
}
local keyIsUpdate = {
  _m0 = "off",
  _m1 = "off",
  _button_W = "off",
  _button_A = "off",
  _button_S = "off",
  _button_D = "off",
  _button_E = "off",
  _button_F = "off",
  _button_C = "off",
  _button_Tab = "off",
  _button_Shift = "off",
  _button_Space = "off",
  _button_Q = "off"
}
Panel_Widget_Keyboard:SetPosX(getScreenSizeX() - (getScreenSizeX() - Panel_Widget_Keyboard:GetSizeX()) - Panel_Widget_Keyboard:GetSizeX() / 1.5)
Panel_Widget_Keyboard:SetPosY(getScreenSizeY() - (getScreenSizeY() - Panel_Widget_Keyboard:GetSizeY() * 2.3))
local panelKeyViewerPosX = Panel_Widget_Keyboard:GetPosX()
local panelKeyViewerPosY = Panel_Widget_Keyboard:GetPosY()
function Panel_AutoQuest_KeyViewer_ScreenRePosition()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  if Panel_Widget_Keyboard:GetRelativePosX() == -1 and Panel_Widget_Keyboard:GetRelativePosY() == -1 then
    local initPosX = Panel_Widget_Keyboard:GetSizeX() / 3
    local initPosY = Panel_Widget_Keyboard:GetSizeY() * 2.3
    Panel_Widget_Keyboard:SetPosX(initPosX)
    Panel_Widget_Keyboard:SetPosY(initPosY)
    changePositionBySever(Panel_Widget_Keyboard, CppEnums.PAGameUIType.PAGameUIPanel_KeyViewer, true, true, false)
    FGlobal_InitPanelRelativePos(Panel_Widget_Keyboard, initPosX, initPosY)
  elseif Panel_Widget_Keyboard:GetRelativePosX() == 0 and Panel_Widget_Keyboard:GetRelativePosY() == 0 then
    Panel_Widget_Keyboard:SetPosX(Panel_Widget_Keyboard:GetSizeX() / 3)
    Panel_Widget_Keyboard:SetPosY(Panel_Widget_Keyboard:GetSizeY() * 2.3)
  else
    Panel_Widget_Keyboard:SetPosX(scrX * Panel_Widget_Keyboard:GetRelativePosX() - Panel_Widget_Keyboard:GetSizeX() / 2)
    Panel_Widget_Keyboard:SetPosY(scrY * Panel_Widget_Keyboard:GetRelativePosY() - Panel_Widget_Keyboard:GetSizeY() / 2)
  end
  if 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_KeyViewer, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved) then
  end
  FGlobal_PanelRepostionbyScreenOut(Panel_Widget_Keyboard)
  for key, value in pairs(ui) do
    value:ComputePos()
  end
end
registerEvent("ButtonToggle", "autoQuest_invokeButtonToggle")
function autoQuest_invokeButtonToggle(key, isOn)
  local keyValueToIndex = {
    "_button_Q",
    "_button_W",
    "_button_E",
    "_button_R",
    "_button_T",
    "_button_A",
    "_button_S",
    "_button_D",
    "_button_F",
    "_button_Z",
    "_button_X",
    "_button_C",
    "_button_V",
    "_button_Tab",
    "_button_Shift",
    "",
    "_button_Space",
    "_m0",
    "_m1"
  }
  if key >= table.getn(keyValueToIndex) then
    return
  end
  if keyValueToIndex[key + 1] == nil or keyValueToIndex[key + 1] == "" then
    return
  end
  ButtonToggle_AutoQuest_AI(keyValueToIndex[key + 1], isOn)
end
function ButtonToggle_AutoQuest_AI(key, isOn)
  local aUI = ui[key]
  local aUI2 = ui_2[key]
  local keyName = "on"
  if aUI == nil or aUI2 == nil then
    return
  end
  if true == isOn then
    keyName = "click"
    aUI2:SetFontColor(UI_color.C_FFFFCE22)
    aUI:SetShow(false)
    aUI2:SetShow(true)
    if keyIsUpdate[key] ~= "click" then
      keyIsUpdate[key] = "click"
      aUI:SetAlpha(0)
      aUI2:SetAlpha(1)
    end
  else
    aUI:SetShow(true)
    if keyIsUpdate[key] ~= "on" then
      keyIsUpdate[key] = "on"
      aUI:SetShow(true)
      aUI:SetAlpha(0.8)
      aUI2:SetAlpha(0)
    end
  end
  if isOn then
    if "_m0" == key then
      aUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVIE_KEYVIEWER_LEFT"))
      aUI2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVIE_KEYVIEWER_LEFT"))
    elseif "_m1" == key then
      aUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVIE_KEYVIEWER_RIGHT"))
      aUI2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVIE_KEYVIEWER_RIGHT"))
    else
      local actionString = ""
      if getGamePadEnable() then
        actionString = keyCustom_GetString_ActionPad(keyIndexSet[key])
      else
        actionString = keyCustom_GetString_ActionKey(keyIndexSet[key])
      end
      aUI:SetText(actionString)
      aUI2:SetText(actionString)
    end
  else
  end
end
local function ButtonAutoQuestToggle(key, isOn)
  local aUI = ui[key]
  local aUI2 = ui_2[key]
  local keyName = "on"
  aUI:SetFontColor(UI_color.C_FFC4BEBE)
  if false == isOn then
    keyName = "off"
    aUI:SetShow(true)
    aUI2:SetShow(false)
    if keyIsUpdate[key] ~= "off" then
      keyIsUpdate[key] = "off"
    end
  elseif true == isOn and keyCustom_IsPressed_Action(keyToVirtualKey[key]) then
    keyName = "click"
    aUI2:SetFontColor(UI_color.C_FFFFCE22)
    aUI:SetShow(false)
    aUI2:SetShow(true)
    if keyIsUpdate[key] ~= "click" then
      keyIsUpdate[key] = "click"
      aUI:SetAlpha(0)
      aUI2:SetAlpha(1)
    end
  else
    aUI:SetShow(true)
    if keyIsUpdate[key] ~= "on" then
      keyIsUpdate[key] = "on"
      aUI:SetShow(true)
      aUI:SetAlpha(0.8)
      aUI2:SetAlpha(0)
    end
  end
  if isOn then
    if "_m0" == key then
      aUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVIE_KEYVIEWER_LEFT"))
      aUI2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVIE_KEYVIEWER_LEFT"))
    elseif "_m1" == key then
      aUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVIE_KEYVIEWER_RIGHT"))
      aUI2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVIE_KEYVIEWER_RIGHT"))
    else
      local actionString = ""
      if getGamePadEnable() then
        actionString = keyCustom_GetString_ActionPad(keyIndexSet[key])
      else
        actionString = keyCustom_GetString_ActionKey(keyIndexSet[key])
      end
      aUI:SetText(actionString)
      aUI2:SetText(actionString)
    end
  else
    aUI:SetText(" ")
    aUI2:SetText(" ")
  end
end
local function ButtonAutoQuestToggleAll(isOn)
  if ToClient_getAutoMode() ~= CppEnums.Client_AutoControlStateType.BATTLE then
    for key, value in pairs(uvSet) do
      ButtonAutoQuestToggle(key, isOn)
    end
  end
end
function FGlobal_AutoQuest_KeyViewer_Show()
  Panel_Widget_Keyboard:SetShow(true)
  PaGlobal_AutoQuestMsg:StartGrayAniHide()
  Panel_AutoQuest_KeyViewer_KeyUpdate()
end
function FGlobal_AutoQuest_KeyViewer_Hide()
  PaGlobal_AutoQuestMsg:StartGrayAniShow()
  Panel_Widget_Keyboard:SetShow(false)
end
function Panel_AutoQuest_KeyViewer_Show()
  Panel_Widget_Keyboard:SetShow(true)
  Panel_AutoQuest_KeyViewer_KeyUpdate()
end
function Panel_AutoQuest_KeyViewer_Hide()
  Panel_Widget_Keyboard:SetShow(false)
end
function Panel_AutoQuest_KeyViewer_KeyUpdate()
  ui._m0:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVIE_KEYVIEWER_LEFT"))
  ui._m1:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MOVIE_KEYVIEWER_RIGHT"))
  ButtonAutoQuestToggleAll(true)
end
function PanelMovieKeyViewer_AutoQuest_RestorePosition()
  Panel_Widget_Keyboard:SetPosX(panelKeyViewerPosX)
  Panel_Widget_Keyboard:SetPosY(panelKeyViewerPosY)
end
registerEvent("onScreenResize", "Panel_AutoQuest_KeyViewer_ScreenRePosition")
Panel_Widget_Keyboard:RegisterUpdateFunc("Panel_AutoQuest_KeyViewer_KeyUpdate")
