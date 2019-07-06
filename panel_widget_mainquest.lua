Panel_MainQuest:SetDragEnable(false)
local _static_active = UI.getChildControl(Panel_MainQuest, "Static_Active")
local mainQuestWidget = {
  _ui = {
    _static_TitleBG = UI.getChildControl(_static_active, "Static_TitleBG"),
    _staticText_Quest_Title = UI.getChildControl(_static_active, "StaticText_Quest_Title"),
    _static_Eff_Complete_Eff1 = UI.getChildControl(_static_active, "Static_Eff_Complete_Eff1"),
    _static_Quest_Type = UI.getChildControl(_static_active, "Static_Quest_Type"),
    _staticText_WidgetGroupTitle = UI.getChildControl(_static_active, "StaticText_WidgetGroupTitle"),
    _staticText_Quest_ClearNpc = UI.getChildControl(_static_active, "StaticText_Quest_ClearNpc"),
    _clearNpcEffect = UI.getChildControl(_static_active, "StaticText_ClearNpc_Effect"),
    _clearNpcEffect2 = UI.getChildControl(_static_active, "StaticText_ClearNpc_Effect_2"),
    _staticText_Quest_Demand = UI.getChildControl(_static_active, "StaticText_Quest_Demand"),
    _checkButton_AutoNavi = UI.getChildControl(_static_active, "CheckButton_AutoNavi"),
    _checkbox_Quest_Navi = UI.getChildControl(_static_active, "Checkbox_Quest_Navi"),
    _button_Quest_Giveup = UI.getChildControl(_static_active, "Checkbox_Quest_Giveup"),
    _mouseR = UI.getChildControl(_static_active, "Static_MouseR"),
    _blackSpirit = UI.getChildControl(_static_active, "Static_BlackSpirit"),
    _bubbleBg = UI.getChildControl(_static_active, "Static_Bubble"),
    _bubbleText = nil,
    _bubbleCtrlBg = nil,
    _bubbleCtrlText = nil
  },
  _config = {_maxConditionCount = 5, _closableLevel = 50},
  _uiQuestConditions = {},
  _isButtonOn = false,
  _mainQuestNo = nil,
  _isInitialized = false,
  _tutorialShowLevelLimit = 20,
  _tutorialDesc = {
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_TUTORIALDESC_1"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_TUTORIALDESC_2"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_TUTORIALDESC_3")
  },
  _currentDesc = nil,
  _isUIMode = false,
  _isTutorialAni = false,
  _isBlabla = false,
  _isQuestGuide = false,
  _blabla = {
    [1] = {
      _questGroup = 21117,
      _questId = 2,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_1")
      }
    },
    [2] = {
      _questGroup = 21117,
      _questId = 3,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_2")
      }
    },
    [3] = {
      _questGroup = 21117,
      _questId = 4,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_3")
      }
    },
    [4] = {
      _questGroup = 21117,
      _questId = 5,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_4"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_5"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_6"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_7")
      }
    },
    [5] = {
      _questGroup = 21117,
      _questId = 6,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_8"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_9")
      }
    },
    [6] = {
      _questGroup = 21117,
      _questId = 7,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_10"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_11"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_12"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_13")
      }
    },
    [7] = {
      _questGroup = 21117,
      _questId = 8,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_14")
      }
    },
    [8] = {
      _questGroup = 21117,
      _questId = 9,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_15")
      }
    },
    [9] = {
      _questGroup = 21117,
      _questId = 10,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_16"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_17")
      }
    },
    [10] = {
      _questGroup = 21117,
      _questId = 11,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_18")
      }
    },
    [11] = {
      _questGroup = 21117,
      _questId = 12,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_19")
      }
    },
    [12] = {
      _questGroup = 21117,
      _questId = 13,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_20"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_21"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_22")
      }
    },
    [13] = {
      _questGroup = 21001,
      _questId = 19,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_23")
      }
    },
    [14] = {
      _questGroup = 21001,
      _questId = 20,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_24")
      }
    },
    [15] = {
      _questGroup = 21001,
      _questId = 21,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_25")
      }
    },
    [16] = {
      _questGroup = 21001,
      _questId = 22,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_26")
      }
    },
    [17] = {
      _questGroup = 21001,
      _questId = 23,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_27")
      }
    },
    [18] = {
      _questGroup = 21001,
      _questId = 24,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_28")
      }
    },
    [19] = {
      _questGroup = 21001,
      _questId = 25,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_29")
      }
    },
    [20] = {
      _questGroup = 21001,
      _questId = 26,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_30"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_31"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_32")
      }
    },
    [21] = {
      _questGroup = 21001,
      _questId = 27,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_33")
      }
    },
    [22] = {
      _questGroup = 21001,
      _questId = 28,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_34"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_35"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_36")
      }
    },
    [23] = {
      _questGroup = 21001,
      _questId = 30,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_37"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_38")
      }
    },
    [24] = {
      _questGroup = 21002,
      _questId = 1,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_39"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_40")
      }
    },
    [25] = {
      _questGroup = 21002,
      _questId = 2,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_41")
      }
    },
    [26] = {
      _questGroup = 21002,
      _questId = 3,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_42")
      }
    },
    [27] = {
      _questGroup = 21002,
      _questId = 4,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_43"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_44")
      }
    },
    [28] = {
      _questGroup = 21002,
      _questId = 5,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_45")
      }
    },
    [29] = {
      _questGroup = 21002,
      _questId = 6,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_46"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_47")
      }
    },
    [30] = {
      _questGroup = 21002,
      _questId = 7,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_48"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_49")
      }
    },
    [31] = {
      _questGroup = 21002,
      _questId = 8,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_50"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_51")
      }
    },
    [32] = {
      _questGroup = 21002,
      _questId = 9,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_52"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_53"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_54")
      }
    },
    [33] = {
      _questGroup = 21002,
      _questId = 10,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_55"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_56")
      }
    },
    [34] = {
      _questGroup = 21002,
      _questId = 11,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_57"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_58")
      }
    },
    [35] = {
      _questGroup = 21002,
      _questId = 12,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_59"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_60")
      }
    },
    [36] = {
      _questGroup = 21002,
      _questId = 13,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_61"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_62")
      }
    },
    [37] = {
      _questGroup = 21002,
      _questId = 14,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_63")
      }
    },
    [38] = {
      _questGroup = 21002,
      _questId = 16,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_64"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_65")
      }
    },
    [39] = {
      _questGroup = 21002,
      _questId = 22,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_66")
      }
    },
    [40] = {
      _questGroup = 21002,
      _questId = 23,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_67")
      }
    },
    [41] = {
      _questGroup = 21002,
      _questId = 25,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_68")
      }
    },
    [42] = {
      _questGroup = 21002,
      _questId = 26,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_69"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_70")
      }
    },
    [43] = {
      _questGroup = 21002,
      _questId = 19,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_71")
      }
    },
    [44] = {
      _questGroup = 21002,
      _questId = 20,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_72"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_73")
      }
    },
    [45] = {
      _questGroup = 21002,
      _questId = 21,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_74"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_75"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_76"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_77"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_78"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_79")
      }
    },
    [46] = {
      _questGroup = 21003,
      _questId = 1,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_80"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_81"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_82"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_83")
      }
    },
    [47] = {
      _questGroup = 21003,
      _questId = 12,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_84"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_85")
      }
    },
    [48] = {
      _questGroup = 21003,
      _questId = 13,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_86"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_87")
      }
    },
    [49] = {
      _questGroup = 21003,
      _questId = 2,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_88"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_89")
      }
    },
    [50] = {
      _questGroup = 21003,
      _questId = 3,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_90"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_91")
      }
    },
    [51] = {
      _questGroup = 21003,
      _questId = 4,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_92"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_93"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_94"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_95"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_96")
      }
    },
    [52] = {
      _questGroup = 21003,
      _questId = 5,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_97"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_98"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_99")
      }
    },
    [53] = {
      _questGroup = 21003,
      _questId = 11,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_100"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_101")
      }
    },
    [54] = {
      _questGroup = 21003,
      _questId = 6,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_102"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_103"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_104"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_105")
      }
    },
    [55] = {
      _questGroup = 21003,
      _questId = 7,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_106"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_107"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_108"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_109")
      }
    },
    [56] = {
      _questGroup = 21003,
      _questId = 8,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_110"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_111"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_112")
      }
    },
    [57] = {
      _questGroup = 21003,
      _questId = 9,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_113"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_114"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_115")
      }
    },
    [58] = {
      _questGroup = 21003,
      _questId = 10,
      _message = {
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_116"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_117"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_118"),
        PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_BLABLADESC_119")
      }
    }
  }
}
function mainQuestWidget:initialize()
  self:createControl()
  self:initControl()
end
function mainQuestWidget:createControl()
  self._ui._staticText_Quest_Demand:SetShow(false)
  for index = 0, self._config._maxConditionCount - 1 do
    self._uiQuestConditions[index] = UI.cloneControl(self._ui._staticText_Quest_Demand, _static_active, "uiCondition_" .. index)
    self._uiQuestConditions[index]:SetText("")
    self._uiQuestConditions[index]:SetIgnore(true)
    self._uiQuestConditions[index]:SetShow(false)
    self._uiQuestConditions[index]:SetPosX(2)
    self._uiQuestConditions[index]:addInputEvent("Mouse_Out", "PaGlobalFunc_MainQuestWidget_MouseOutEvent()")
  end
  self._ui._bubbleText = UI.getChildControl(self._ui._bubbleBg, "StaticText_Desc")
  self._ui._bubbleText:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._bubbleCtrlBg = UI.getChildControl(self._ui._bubbleBg, "StaticText_CtrlBg")
  self._ui._bubbleCtrlText = UI.getChildControl(self._ui._bubbleBg, "StaticText_CtrlText")
  self._ui._bubbleCtrlBg:SetShow(false)
  self._ui._bubbleCtrlText:SetShow(false)
  self._ui._blackSpirit:AddEffect("fN_DarkSpirit_Gage_01A", true, 0, 0)
  self._ui._blackSpirit:SetShow(false)
  self:clearConditionInfo()
end
function mainQuestWidget:initControl()
  _static_active:SetChildIndex(self._ui._checkbox_Quest_Navi, 9999)
  _static_active:SetChildIndex(self._ui._checkButton_AutoNavi, 9999)
  Panel_MainQuest:addInputEvent("Mouse_Out", "PaGlobalFunc_MainQuestWidget_MouseOutEvent()")
  for _key, _value in pairs(self._ui) do
    if nil ~= _value then
      _value:addInputEvent("Mouse_Out", "PaGlobalFunc_MainQuestWidget_MouseOutEvent()")
    end
  end
  self._ui._checkButton_AutoNavi:addInputEvent("Mouse_On", "HandleMouseOver_Button( true , 1 )")
  self._ui._checkButton_AutoNavi:addInputEvent("Mouse_Out", "HandleMouseOver_Button( false ,1 )")
  self._ui._checkbox_Quest_Navi:addInputEvent("Mouse_On", "HandleMouseOver_Button( true , 2 )")
  self._ui._checkbox_Quest_Navi:addInputEvent("Mouse_Out", "HandleMouseOver_Button( false , 2 )")
  if -1 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_MainQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow) then
    if 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_MainQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow) then
      Panel_MainQuest:SetShow(true)
    else
      Panel_MainQuest:SetShow(false)
    end
  else
    Panel_MainQuest:SetShow(true)
  end
  self._isInitialized = true
  local questList = ToClient_GetQuestList()
  if false == questList:isMainQuestClearAll() then
    Panel_MainQuest:SetIgnore(false)
    self._ui._static_TitleBG:SetShow(true)
    self:open()
  else
    self:clearAll()
  end
  if true == Panel_MainQuest:GetShow() then
    self:update()
  end
  self._ui._static_TitleBG:SetIgnore(true)
end
function PaGlobalFunc_MainQuestWidget_Open()
  mainQuestWidget:open()
end
function mainQuestWidget:open()
  self:update()
end
function PaGlobalFunc_MainQuestWidget_Close()
  mainQuestWidget:close()
end
function mainQuestWidget:close()
  Panel_MainQuest:SetShow(false)
  self:clearAll()
end
function PaGlobalFunc_MainQuestWidget_SetQuestGroupTitleInfo(uiQuestInfo)
  return mainQuestWidget:setQuestGroupTitleInfo(uiQuestInfo)
end
function mainQuestWidget:setQuestGroupTitleInfo(uiQuestInfo)
  local startPosY = self._ui._staticText_Quest_Title:GetPosY() + self._ui._staticText_Quest_Title:GetSizeY() * 2
  if uiQuestInfo:isSatisfied() or not uiQuestInfo._isCleared and not uiQuestInfo._isProgressing then
    return startPosY
  end
  local questNo = uiQuestInfo:getQuestNo()
  local questListInfo = ToClient_GetQuestList()
  local uiQuestGroupInfo = questListInfo:getQuestGroup(questNo)
  if nil ~= uiQuestGroupInfo and uiQuestGroupInfo:isGroupQuest() then
    local groupTitle = uiQuestGroupInfo:getTitle()
    local questGroupCount = uiQuestGroupInfo:getTotalQuestCount()
    local groupQuestTitleInfo = " " .. groupTitle .. " (" .. questNo._quest .. "/" .. questGroupCount .. ")"
    self._ui._staticText_WidgetGroupTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_GROUPTITLEINFO", "titleinfo", groupQuestTitleInfo))
    self._ui._staticText_WidgetGroupTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    self._ui._staticText_WidgetGroupTitle:SetSize(230, self._ui._staticText_Quest_Title:GetSizeY())
    self._ui._staticText_WidgetGroupTitle:SetPosX(8)
    self._ui._staticText_WidgetGroupTitle:SetPosY(self._ui._staticText_Quest_Title:GetPosY() + self._ui._staticText_Quest_Title:GetSizeY() + self._ui._staticText_Quest_Title:GetSizeY() + 5)
    self._ui._staticText_WidgetGroupTitle:SetAutoResize(true)
    self._ui._staticText_WidgetGroupTitle:SetIgnore(true)
    self._ui._staticText_WidgetGroupTitle:SetShow(true)
    startPosY = startPosY + self._ui._staticText_Quest_Title:GetSizeY() * 2
  end
  return startPosY
end
function FGlobal_MainQuest_Update()
  mainQuestWidget:update()
end
function mainQuestWidget:update()
  if false == self._isInitialized then
    return
  end
  if true == ToClient_IsInstanceFieldPlayerbyContentsType(__eInstanceContentsType_SavageDefence) then
    Panel_MainQuest:SetShow(false)
    self:clearAll()
    return
  end
  local questList = ToClient_GetQuestList()
  if true == questList:isMainQuestClearAll() then
    Panel_MainQuest:SetIgnore(true)
    self._ui._static_TitleBG:SetShow(false)
    self:clearAll()
    return
  end
  self:clearAll()
  local uiQuestInfo = questList:getMainQuestInfo()
  if nil ~= uiQuestInfo then
    self._mainQuestNo = uiQuestInfo:getQuestNo()
    self:setIconInfo(uiQuestInfo)
    self:setQuestTitleInfo(uiQuestInfo)
    local startPosY = self:setQuestGroupTitleInfo(uiQuestInfo)
    self:setConditionInfo(uiQuestInfo, startPosY)
    self:setButtonCheckState(uiQuestInfo)
  else
  end
end
function mainQuestWidget:clearAll()
  self._ui._staticText_Quest_Title:SetShow(false)
  self._ui._static_Eff_Complete_Eff1:SetShow(false)
  self._ui._static_Quest_Type:SetShow(false)
  self._ui._staticText_WidgetGroupTitle:SetShow(false)
  self._ui._staticText_Quest_ClearNpc:SetShow(false)
  self._ui._staticText_Quest_Demand:SetShow(false)
  self._ui._checkButton_AutoNavi:SetShow(false)
  self._ui._checkbox_Quest_Navi:SetShow(false)
  self._ui._button_Quest_Giveup:SetShow(false)
  for index = 0, self._config._maxConditionCount - 1 do
    if nil ~= self._uiQuestConditions[index] then
      self._uiQuestConditions[index]:SetText("")
      self._uiQuestConditions[index]:SetIgnore(true)
      self._uiQuestConditions[index]:SetShow(false)
    end
  end
  self._isButtonOn = false
  self._mainQuestNo = nil
  self:clearConditionInfo()
end
function mainQuestWidget:getQuestTitle(uiQuestInfo)
  local questTitle = uiQuestInfo:getTitle()
  local recommandLevel = uiQuestInfo:getRecommendLevel()
  if nil ~= recommandLevel and 0 ~= recommandLevel then
    questTitle = "[" .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. recommandLevel .. "] " .. questTitle
  end
  return questTitle
end
function mainQuestWidget:setQuestTitleInfo(uiQuestInfo)
  local questTitle = self:getQuestTitle(uiQuestInfo)
  local isAccepted = 1
  if not uiQuestInfo._isCleared and not uiQuestInfo._isProgressing then
    isAccepted = 0
  end
  self._ui._staticText_Quest_Title:SetAutoResize(true)
  self._ui._staticText_Quest_Title:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui._staticText_Quest_Title:SetSize(200, self._ui._staticText_Quest_Title:GetSizeY())
  if 0 == isAccepted then
    self._ui._staticText_Quest_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWINDOW_NOTACCEPTTITLE", "title", questTitle))
  else
    self._ui._staticText_Quest_Title:SetText(questTitle)
  end
  Panel_MainQuest:SetIgnore(false)
  self._ui._static_TitleBG:SetShow(true)
  self._ui._staticText_Quest_Title:SetLineRender(false)
  self._ui._staticText_Quest_Title:SetShow(true)
  self._ui._staticText_Quest_Title:SetIgnore(true)
  self._ui._staticText_Quest_Title:SetFontColor(Defines.Color.C_FFEFEFEF)
  self._ui._staticText_Quest_Title:useGlowFont(true, "BaseFont_8_Glow", 4287655978)
  local questNo = uiQuestInfo:getQuestNo()
  local questStaticStatus = questList_getQuestStatic(questNo._group, questNo._quest)
  local checkCondition
  if true == uiQuestInfo:isSatisfied() then
    checkCondition = QuestConditionCheckType.eQuestConditionCheckType_Complete
  elseif 0 == isAccepted then
    checkCondition = QuestConditionCheckType.eQuestConditionCheckType_NotAccept
  else
    checkCondition = QuestConditionCheckType.eQuestConditionCheckType_Progress
  end
  local groupTitle = "nil"
  local questGroupCnt = 0
  local questListInfo = ToClient_GetQuestList()
  local uiQuestGroupInfo = questListInfo:getQuestGroup(questNo)
  if nil ~= uiQuestGroupInfo then
    groupTitle = uiQuestGroupInfo:getTitle()
    questGroupCnt = uiQuestGroupInfo:getTotalQuestCount()
  end
  Panel_MainQuest:addInputEvent("Mouse_LUp", "HandleClicked_ShowMainQuestDetail( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", \"" .. groupTitle .. "\", " .. questGroupCnt .. " )")
  Panel_MainQuest:addInputEvent("Mouse_RUp", "HandleClicked_MainQuest_FindWay( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", false ," .. isAccepted .. ", \"GroupBG\" )")
  self._ui._staticText_Quest_ClearNpc:addInputEvent("Mouse_LUp", "HandleClicked_ShowMainQuestDetail( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", \"" .. groupTitle .. "\", " .. questGroupCnt .. " )")
  self._ui._staticText_Quest_ClearNpc:addInputEvent("Mouse_RUp", "HandleClicked_MainQuest_FindWay( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", false ," .. isAccepted .. ", \"GroupBG\" )")
  self._ui._checkbox_Quest_Navi:addInputEvent("Mouse_LUp", "HandleClicked_MainQuest_FindWay( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", false ," .. isAccepted .. ", \"Navi\" )")
  self._ui._checkButton_AutoNavi:addInputEvent("Mouse_LUp", "HandleClicked_MainQuest_FindWay( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", true ," .. isAccepted .. ", \"AutoNavi\" )")
  self._ui._static_TitleBG:addInputEvent("Mouse_On", "HandleMouseOver_MainQuestWidget( true," .. isAccepted .. ")")
  self._ui._static_TitleBG:addInputEvent("Mouse_Out", "HandleMouseOver_MainQuestWidget( false," .. isAccepted .. ")")
  self._ui._staticText_Quest_ClearNpc:addInputEvent("Mouse_On", "HandleMouseOver_MainQuestWidget( true," .. isAccepted .. ")")
  self._ui._staticText_Quest_ClearNpc:addInputEvent("Mouse_Out", "HandleMouseOver_MainQuestWidget( false," .. isAccepted .. ")")
  Panel_MainQuest:addInputEvent("Mouse_On", "HandleMouseOver_MainQuestWidget( true," .. isAccepted .. ")")
  Panel_MainQuest:addInputEvent("Mouse_Out", "HandleMouseOver_MainQuestWidget( false," .. isAccepted .. ")")
  local posCount = questStaticStatus:getQuestPositionCount()
  local enable = false == uiQuestInfo:isSatisfied() and 0 ~= posCount
  enable = true
  self._ui._checkButton_AutoNavi:SetEnable(enable)
  self._ui._checkbox_Quest_Navi:SetEnable(enable)
end
function mainQuestWidget:setIconInfo(uiQuestInfo)
  self._ui._static_Quest_Type:EraseAllEffect()
  self._ui._static_Quest_Type:SetShow(true)
  self._ui._static_Quest_Type:SetIgnore(true)
  FGlobal_ChangeOnTextureForDialogQuestIcon(self._ui._static_Quest_Type, uiQuestInfo:getQuestType())
end
function mainQuestWidget:setConditionInfo(uiQuestInfo, startPosY)
  self:clearConditionInfo()
  local checkCondition
  if true == uiQuestInfo:isSatisfied() then
    checkCondition = 0
  else
    checkCondition = 1
  end
  local uiQuestCondition
  self._ui._staticText_Quest_ClearNpc:SetLineRender(false)
  if not uiQuestInfo._isCleared and not uiQuestInfo._isProgressing then
    self._ui._staticText_Quest_ClearNpc:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_ACCEPT_NOTICE"))
    self._ui._staticText_Quest_ClearNpc:SetFontColor(Defines.Color.C_FFC4BEBE)
    self._ui._staticText_Quest_ClearNpc:SetShow(true)
    self._isBlabla = false
    self:SetTutorial(3)
    startPosY = startPosY + self._ui._staticText_Quest_ClearNpc:GetSizeY() + 2
  elseif 1 == checkCondition then
    for conditionIndex = 0, uiQuestInfo:getDemandCount() - 1 do
      local conditionInfo = uiQuestInfo:getDemandAt(conditionIndex)
      uiQuestCondition = self._uiQuestConditions[conditionIndex]
      uiQuestCondition:SetAutoResize(true)
      uiQuestCondition:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      uiQuestCondition:SetFontColor(Defines.Color.C_FFC4BEBE)
      uiQuestCondition:SetPosY(startPosY)
      uiQuestCondition:SetSize(self._ui._static_TitleBG:GetSizeX(), uiQuestCondition:GetTextSizeY())
      local conditionText
      if conditionInfo._currentCount == conditionInfo._destCount or conditionInfo._destCount <= conditionInfo._currentCount then
        uiQuestCondition:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
        uiQuestCondition:SetLineCount(1)
        conditionText = " - " .. conditionInfo._desc .. " (" .. PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST_COMPLETE") .. ")"
        uiQuestCondition:SetText(ToClient_getReplaceDialog(conditionText))
        uiQuestCondition:SetLineRender(true)
        uiQuestCondition:SetFontColor(Defines.Color.C_FF626262)
      elseif 1 == conditionInfo._destCount then
        conditionText = " - " .. conditionInfo._desc
        uiQuestCondition:SetText(ToClient_getReplaceDialog(conditionText))
        uiQuestCondition:SetLineRender(false)
      else
        conditionText = " - " .. conditionInfo._desc .. " (" .. conditionInfo._currentCount .. "/" .. conditionInfo._destCount .. ")"
        uiQuestCondition:SetText(ToClient_getReplaceDialog(conditionText))
        uiQuestCondition:SetLineRender(false)
      end
      uiQuestCondition:SetShow(true)
      uiQuestCondition:SetIgnore(true)
      startPosY = startPosY + uiQuestCondition:GetSizeY() + 2
    end
    self:SetBlabla(uiQuestInfo)
  elseif 0 == checkCondition then
    self._ui._static_Quest_Type:AddEffect("UI_Quest_Complete_GoldAura", true, 130, 0)
    self._ui._staticText_Quest_ClearNpc:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    self._isBlabla = false
    if true == uiQuestInfo:isCompleteBlackSpirit() then
      self._ui._staticText_Quest_ClearNpc:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUESTCOMPLETE_BLACKSPIRIT"))
      self:SetTutorial(1)
    else
      self._ui._staticText_Quest_ClearNpc:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_QUESTCOMPLETENPC"))
      self:SetTutorial(2)
    end
    self._ui._staticText_Quest_ClearNpc:SetLineRender(true)
    self._ui._staticText_Quest_ClearNpc:SetFontColor(Defines.Color.C_FFF26A6A)
    self._ui._staticText_Quest_ClearNpc:SetShow(true)
    FGlobal_ChangeOnTextureForDialogQuestIcon(self._ui._static_Quest_Type, 8)
    startPosY = startPosY + self._ui._staticText_Quest_ClearNpc:GetSizeY() + 2
    FGlobal_QuestWidget_AutoReleaseNavi(uiQuestInfo)
  end
  Panel_MainQuest:SetSize(Panel_MainQuest:GetSizeX(), startPosY + 10)
  _static_active:SetSize(Panel_MainQuest:GetSizeX(), startPosY + 10)
end
function mainQuestWidget:tutorialSetText(text)
  self._ui._bubbleText:SetText(text)
  self._ui._bubbleBg:SetSize(self._ui._bubbleBg:GetSizeX(), math.max(66, self._ui._bubbleText:GetTextSizeY() + 50))
  self._ui._bubbleBg:SetSpanSize(self._ui._bubbleBg:GetSpanSize().x, 41 - self._ui._bubbleBg:GetSizeY())
  self._ui._bubbleText:ComputePos()
  self._ui._bubbleCtrlBg:ComputePos()
  self._ui._bubbleCtrlText:ComputePos()
end
function mainQuestWidget:tutorialShowAni(control)
  control:SetShow(true)
  local showAni = control:addColorAnimation(0, 0.22, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  showAni:SetStartColor(Defines.Color.C_00FFFFFF)
  showAni:SetEndColor(Defines.Color.C_FFFFFFFF)
  showAni:SetStartIntensity(3)
  showAni:SetEndIntensity(1)
  showAni.IsChangeChild = true
end
function mainQuestWidget:tutorialHideAni(control)
  local closeAni = control:addColorAnimation(5, 5.22, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(Defines.Color.C_FFFFFFFF)
  closeAni:SetEndColor(Defines.Color.C_00FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
  closeAni:SetDisableWhileAni(true)
end
function mainQuestWidget:autoRunAni()
  self:tutorialSetText(PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_TUTORIALDESC_AUTORUN"))
  self:tutorialHideAni(self._ui._mouseR)
  self:tutorialHideAni(self._ui._blackSpirit)
  self:tutorialHideAni(self._ui._bubbleBg)
  self:tutorialHideAni(self._ui._clearNpcEffect)
  self:tutorialHideAni(self._ui._clearNpcEffect2)
  self._isTutorialAni = true
end
function mainQuestWidget:SetTutorial(index)
  self._currentDesc = index
  local selfProxy = getSelfPlayer()
  if nil == selfProxy then
    return
  end
  if false == questList_isClearQuest(21117, 1) or self._tutorialShowLevelLimit < selfProxy:get():getLevel() then
    return
  end
  local isTutorialSkip = 1 == ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eTutorialSkip)
  if true == isTutorialSkip then
    return
  end
  if true == self._isBlabla then
    return
  end
  local tutorialString
  local ctrlGuideShow = currentMode ~= CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode
  if true == ctrlGuideShow then
    tutorialString = PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_TUTORIALDESC_CTRL")
  else
    tutorialString = self._tutorialDesc[index]
  end
  self:tutorialSetText(tutorialString)
  self:tutorialShowAni(self._ui._mouseR)
  self:tutorialShowAni(self._ui._blackSpirit)
  self:tutorialShowAni(self._ui._bubbleBg)
  self:tutorialShowAni(self._ui._clearNpcEffect)
  self:tutorialShowAni(self._ui._clearNpcEffect2)
  self._isTutorialAni = false
end
function mainQuestWidget:SetBlabla(uiQuestInfo)
  if true == self._isBlabla then
    return
  end
  local questNo = uiQuestInfo:getQuestNo()
  local groupId = questNo._group
  local questId = questNo._quest
  for index = 1, #self._blabla do
    if self._blabla[index]._questGroup == groupId and self._blabla[index]._questId == questId then
      local descIndex = math.random(1, #self._blabla[index]._message)
      self:tutorialSetText(self._blabla[index]._message[descIndex])
      self:tutorialShowAni(self._ui._blackSpirit)
      self:tutorialShowAni(self._ui._bubbleBg)
      self._isBlabla = true
      break
    end
  end
end
function mainQuestWidget:showClearedTooltip(isMouseOver)
  if false == self._ui._staticText_Quest_ClearNpc:IsLimitText() then
    return
  end
  if true == isMouseOver then
    TooltipSimple_Show(self._ui._staticText_Quest_ClearNpc, "", self._ui._staticText_Quest_ClearNpc:GetText())
  else
    TooltipSimple_Hide()
  end
end
function mainQuestWidget:setButtonCheckState(uiQuestInfo)
  local questNo = uiQuestInfo:getQuestNo()
  local questGroup, questId, naviInfoAgain = FGlobal_QuestWidget_GetSelectedNaviInfo()
  if questGroup == questNo._group and questId == questNo._quest then
    if true == naviInfoAgain then
      self._ui._checkButton_AutoNavi:SetCheck(false)
      self._ui._checkbox_Quest_Navi:SetCheck(false)
    elseif true == self._ui._checkButton_AutoNavi:IsCheck() then
      self._ui._checkbox_Quest_Navi:SetCheck(true)
      self._ui._checkButton_AutoNavi:SetCheck(false)
    else
      self._ui._checkbox_Quest_Navi:SetCheck(false)
      self._ui._checkButton_AutoNavi:SetCheck(true)
    end
  else
    self._ui._checkButton_AutoNavi:SetCheck(false)
    self._ui._checkbox_Quest_Navi:SetCheck(false)
  end
end
function mainQuestWidget:setButtonState(isMouseOver)
end
function HandleClicked_ShowMainQuestDetail(groupId, questId, checkCondition, groupTitle, questGroupCount)
  if false == _static_active:GetShow() then
    return
  end
  local fromQuestWidget = true
  Toggle_QuestInfoTabMain_forPadEventFunc()
  HandleClick_QuestWindow_Update()
  FGlobal_QuestInfoDetail(groupId, questId, checkCondition, groupTitle, questGroupCount, true)
  audioPostEvent_SystemUi(0, 0)
end
function HandleClicked_MainQuest_FindWay(gruopNo, questNo, questCondition, isAuto, checkAcceptable, control)
  if false == _static_active:GetShow() then
    return
  end
  local self = mainQuestWidget
  if true == self._ui._bubbleBg:GetShow() then
    self:autoRunAni()
  end
  if 0 == checkAcceptable then
    local isAcceptable = questList_isAcceptableQuest(gruopNo, questNo)
    if false == isAcceptable then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_CHECH_CONDITION_NOTICE"))
      return
    end
  end
  HandleClicked_QuestWindow_FindWay(gruopNo, questNo, questCondition, isAuto)
end
function mainQuestWidget:showAcceptConditionTooltip(show)
  if true == show then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWINDOW_ACCEPTCONDITION")
    local questList = ToClient_GetQuestList()
    local uiQuestInfo = questList:getMainQuestInfo()
    if nil ~= uiQuestInfo then
      local desc = uiQuestInfo:getAcceptConditionText()
      registTooltipControl(Panel_MainQuest, Panel_Tooltip_SimpleText)
      TooltipSimple_Show(Panel_MainQuest, name, desc)
    end
  else
    TooltipSimple_Hide()
  end
end
function mainQuestWidget:clearConditionInfo()
  self._ui._staticText_Quest_ClearNpc:SetShow(false)
  self._ui._staticText_Quest_ClearNpc:SetText("")
  for index = 0, self._config._maxConditionCount - 1 do
    self._uiQuestConditions[index]:SetShow(false)
    self._uiQuestConditions[index]:SetText("")
  end
  if false == self._isBlabla then
    self._ui._mouseR:SetShow(false)
    self._ui._blackSpirit:SetShow(false)
    self._ui._bubbleBg:SetShow(false)
    self._ui._clearNpcEffect:SetShow(false)
    self._ui._clearNpcEffect2:SetShow(false)
  end
end
function mainQuestWidget:ShowGroupBG(show)
end
function mainQuestWidget:isHitTest(control)
  local panel = Panel_MainQuest
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local panelPosX = panel:GetPosX()
  local panelPosY = panel:GetPosY()
  local bgPosX = panelPosX
  local bgPosY = panelPosY
  local bgSizeX = panel:GetSizeX()
  local bgSizeY = panel:GetSizeY()
  if mousePosX >= bgPosX and mousePosX <= bgPosX + bgSizeX and mousePosY >= bgPosY and mousePosY <= bgPosY + bgSizeY then
    return true
  end
  return false
end
function mainQuestWidget:setTooltipPos(posY)
end
function mainQuestWidget:isShownQuest(questNo)
  local uiQuestInfo = self._mainQuestNo
  if nil ~= uiQuestInfo then
    if uiQuestInfo._group == questNo._group and uiQuestInfo._quest == questNo._quest then
      return true
    else
      return false
    end
  end
  return false
end
function HandleMouseOver_Button(show, target)
  if false == _static_active:GetShow() then
    return
  end
  mainQuestWidget:mouseOverToButton(show, target)
end
function mainQuestWidget:mouseOverToButton(show, target)
  local control, msg = nil, ""
  local posY = 0
  if true == show then
    if 2 == target then
      msg = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_NAVITOOLTIP")
      control = self._ui._checkbox_Quest_Navi
    elseif 1 == target then
      msg = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_AUTONAVITOOLTIP")
      control = self._ui._checkButton_AutoNavi
    end
    registTooltipControl(control, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(control, "", msg)
    self._isButtonOn = true
  else
    TooltipSimple_Hide()
    self._isButtonOn = false
  end
end
function mainQuestWidget:Common_WidgetMouseOut()
  if CppEnums.EProcessorInputMode.eProcessorInputMode_GameMode ~= UI.Get_ProcessorInputMode() then
    local panelPosX = Panel_MainQuest:GetPosX()
    local panelPosY = Panel_MainQuest:GetPosY()
    local panelSizeX = Panel_MainQuest:GetSizeX()
    local panelSizeY = Panel_MainQuest:GetSizeY()
    local mousePosX = getMousePosX()
    local mousePosY = getMousePosY()
    if panelPosX < mousePosX and mousePosX < panelPosX + panelSizeX and panelPosY < mousePosY and mousePosY < panelPosY + panelSizeY then
      return false
    end
  end
  return true
end
function PaGlobalFunc_MainQuestWidget_MouseOutEvent()
  if false == _static_active:GetShow() then
    return
  end
  mainQuestWidget:Common_HideTooltip()
end
function mainQuestWidget:Common_HideTooltip()
  if false == Panel_MainQuest:GetShow() then
    return
  end
  if true == self:Common_WidgetMouseOut() and true == self._isButtonOn then
    self:mouseOverToButton(false)
  end
end
local isMouseOnWidget = false
function HandleMouseOver_MainQuestWidget(isMouseOver, isAcceptedQuest)
  if false == _static_active:GetShow() then
    return
  end
  mainQuestWidget:mouseOverToMaindQuestWidget(isMouseOver, isAcceptedQuest)
end
function mainQuestWidget:mouseOverToMaindQuestWidget(isMouseOver, isAcceptedQuest)
  if true == self._isButtonOn then
    return
  end
  if true == isMouseOver then
    if self._ui._checkButton_AutoNavi:IsEnable() then
      self._ui._checkButton_AutoNavi:SetShow(true)
      self._ui._checkbox_Quest_Navi:SetShow(true)
    end
    isMouseOnWidget = true
  else
    self._ui._checkButton_AutoNavi:SetShow(false)
    self._ui._checkbox_Quest_Navi:SetShow(false)
    if true == self:isHitTest(Panel_MainQuest) then
      return
    end
    local isSelectedNaviBtn = not self._ui._checkButton_AutoNavi:IsCheck() and self._ui._checkbox_Quest_Navi:IsCheck()
    isMouseOnWidget = false
    self:showAcceptConditionTooltip(false)
  end
  self:showClearedTooltip(isMouseOver)
  if 0 == isAcceptedQuest then
    self:showAcceptConditionTooltip(isMouseOver)
  end
end
function PaGlobalFunc_MainQuestWidget_IsShownQuest(questNo)
  return mainQuestWidget:isShownQuest(questNo)
end
function PaGlobalFunc_MainQuestWidget_GetAutoNaviButton()
  return mainQuestWidget._ui._checkbox_Quest_Navi
end
function PaGlobalFunc_MainQuestWidget_GetClosableLevel()
  return mainQuestWidget._config._closableLevel
end
function FromClient_MainQuestWidget_ResetPosition()
  if Panel_MainQuest:GetRelativePosX() == -1 and Panel_MainQuest:GetRelativePosY() == -1 then
    local initPosX = getScreenSizeX() - Panel_MainQuest:GetSizeX() - 16
    local initPosY = FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 10
    local haveServerPosition = 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_MainQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved)
    if not haveServerPosition then
      Panel_MainQuest:SetPosX(initPosX)
      Panel_MainQuest:SetPosY(initPosY)
    end
    FGlobal_InitPanelRelativePos(Panel_MainQuest, initPosX, initPosY)
  elseif Panel_MainQuest:GetRelativePosX() == 0 and Panel_MainQuest:GetRelativePosY() == 0 then
    Panel_MainQuest:SetPosX(getScreenSizeX() - Panel_MainQuest:GetSizeX() - 16)
    Panel_MainQuest:SetPosY(FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 10)
    PaGlobalFunc_Quest_UpdatePosition()
  else
    Panel_MainQuest:SetPosX(getScreenSizeX() * Panel_MainQuest:GetRelativePosX() - Panel_MainQuest:GetSizeX() / 2)
    Panel_MainQuest:SetPosY(getScreenSizeY() * Panel_MainQuest:GetRelativePosY() - Panel_MainQuest:GetSizeY() / 2)
  end
  if -1 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_MainQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow) then
    if 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_MainQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow) then
      Panel_MainQuest:SetShow(true)
    else
      Panel_MainQuest:SetShow(false)
    end
  else
    Panel_MainQuest:SetShow(true)
  end
  FGlobal_PanelRepostionbyScreenOut(Panel_MainQuest)
  if true == Panel_MainQuest:GetShow() then
    FGlobal_MainQuest_Update()
  end
  if nil ~= FromClient_NationSiegeStatus_ResetPosition then
    FromClient_NationSiegeStatus_ResetPosition()
  end
end
function FGlobal_QuestWidget_CalcScrollButtonSize()
end
function FromClient_luaLoadComplete_MainQuest()
  mainQuestWidget:initialize()
end
function renderModeChange_Panel_MainQuest_ResetPosition(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  FromClient_MainQuestWidget_ResetPosition()
end
function FromClient_MainQuestWidget_TutorialCheck(prevMode, currentMode)
  local self = mainQuestWidget
  if false == self._ui._bubbleBg:GetShow() then
    self._isQuestGuide = false
    return
  end
  if nil == self._ui._bubbleCtrlBg then
    return
  end
  if true == self._isTutorialAni then
    return
  end
  if true == self._isBlabla then
    return
  end
  if true == self._isQuestGuide then
    return
  end
  local ctrlGuideShow = currentMode ~= CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode
  local tutorialString
  if true == ctrlGuideShow then
    tutorialString = PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_TUTORIALDESC_CTRL")
  else
    tutorialString = self._tutorialDesc[self._currentDesc]
  end
  self._isUIMode = currentMode
  self:tutorialSetText(tutorialString)
  self._ui._bubbleCtrlBg:SetShow(false)
  self._ui._bubbleCtrlText:SetShow(false)
end
function mainQuestWidget:registEventHandler()
  registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MainQuest")
  registerEvent("onScreenResize", "FromClient_MainQuestWidget_ResetPosition")
  registerEvent("FromClient_RenderModeChangeState", "renderModeChange_Panel_MainQuest_ResetPosition")
  registerEvent("EventProcessorInputModeChange", "FromClient_MainQuestWidget_TutorialCheck")
end
function PaGlobal_MainQuest_SetShowControl(isShow)
  _static_active:SetShow(isShow)
end
function PaGlobal_MainQuestWidget_TopQuestGuide_Open()
  local self = mainQuestWidget
  local uiQuestInfo = ToClient_GetQuestList():getMainQuestInfo()
  if nil ~= uiQuestInfo and true == PaGlobal_MainQuestWidget_IsCorrectQuest(uiQuestInfo) then
    self:tutorialSetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MAINQUESTWIDGET_TOPQUESTBUBBLE"))
    self:tutorialShowAni(self._ui._bubbleBg)
    self:tutorialShowAni(self._ui._blackSpirit)
    self._isQuestGuide = true
    PaGlobal_MainQuestWidget_TopQuestGuide_Close()
  end
end
function PaGlobal_MainQuestWidget_TopQuestGuide_Close()
  local self = mainQuestWidget
  self:tutorialHideAni(self._ui._bubbleBg)
  self:tutorialHideAni(self._ui._blackSpirit)
end
function PaGlobal_MainQuestWidget_IsCorrectQuest(questInfo)
  if nil == questInfo then
    return false
  end
  local groupId = questInfo:getQuestNo()._group
  if nil == groupId then
    return false
  end
  if false == (21001 == groupId or 21117 == groupId or 21112 == groupId) then
    if 1 == questInfo:getQuestNo()._quest and false == questInfo._isProgressing then
      return true
    else
      return false
    end
  end
  return false
end
mainQuestWidget:registEventHandler()
changePositionBySever(Panel_MainQuest, CppEnums.PAGameUIType.PAGameUIPanel_MainQuest, true, true, true)
