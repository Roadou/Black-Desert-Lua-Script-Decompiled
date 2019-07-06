local IM = CppEnums.EProcessorInputMode
Panel_Window_Policy:SetShow(false)
local PolicyTextType = {
  Title = 1,
  SubTitle = 2,
  Desc = 3,
  DescSub = 4,
  DescRed = 5
}
local PolicyTextGap = {
  [PolicyTextType.Title] = 40,
  [PolicyTextType.SubTitle] = 30,
  [PolicyTextType.Desc] = 5,
  [PolicyTextType.DescSub] = 20,
  [PolicyTextType.DescRed] = 20
}
local PolicyTextData = {}
if true == ToClient_isPS4() then
  PolicyTextData = {
    [1] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY1")
    },
    [2] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY2")
    },
    [3] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY3")
    },
    [4] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY4")
    },
    [5] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY5")
    },
    [6] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY6")
    },
    [7] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY7")
    },
    [8] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY8")
    },
    [9] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY9")
    },
    [10] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY10")
    },
    [11] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY11")
    },
    [12] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY12")
    },
    [13] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY13")
    },
    [14] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY14")
    },
    [15] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY15")
    },
    [16] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY16")
    },
    [17] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY17")
    },
    [18] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY18")
    },
    [19] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY19")
    },
    [20] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY20")
    },
    [21] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY21")
    },
    [22] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY22")
    },
    [23] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_EULA_POLICY23")
    }
  }
else
  PolicyTextData = {
    [1] = {
      _type = PolicyTextType.SubTitle,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_1")
    },
    [2] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_1")
    },
    [3] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_2")
    },
    [4] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_2")
    },
    [5] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_3")
    },
    [6] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_3")
    },
    [7] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_4")
    },
    [8] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_4")
    },
    [9] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_5")
    },
    [10] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_5")
    },
    [11] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_5_1")
    },
    [12] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_5_2")
    },
    [13] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_5_3")
    },
    [14] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_6")
    },
    [15] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6")
    },
    [16] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_1")
    },
    [17] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_2")
    },
    [18] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_3")
    },
    [19] = {
      _type = PolicyTextType.DescRed,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_4")
    },
    [20] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_5")
    },
    [21] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_6")
    },
    [22] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_7")
    },
    [23] = {
      _type = PolicyTextType.DescRed,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_8")
    },
    [24] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_9")
    },
    [25] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_10")
    },
    [26] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_11")
    },
    [27] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_12")
    },
    [28] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_13")
    },
    [29] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_14")
    },
    [30] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_15")
    },
    [31] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_16")
    },
    [32] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_6_17")
    },
    [33] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_7")
    },
    [34] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_7")
    },
    [35] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_8")
    },
    [36] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_8")
    },
    [37] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_8_1")
    },
    [38] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_8_2")
    },
    [39] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_8_3")
    },
    [40] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_8_4")
    },
    [41] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_8_5")
    },
    [42] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_8_6")
    },
    [43] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_8_7")
    },
    [44] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_9")
    },
    [45] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_9")
    },
    [46] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_10")
    },
    [47] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_10")
    },
    [48] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_11")
    },
    [49] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_11")
    },
    [50] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_12")
    },
    [51] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_12")
    },
    [52] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_13")
    },
    [53] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_13")
    },
    [54] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_13_1")
    },
    [55] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_13_2")
    },
    [56] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_13_3")
    },
    [57] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_13_4")
    },
    [58] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_14")
    },
    [59] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_14")
    },
    [60] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_15")
    },
    [61] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_15")
    },
    [62] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_16")
    },
    [63] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_16")
    },
    [64] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_17")
    },
    [65] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_17")
    },
    [66] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_18")
    },
    [67] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_18")
    },
    [68] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_18_1")
    },
    [69] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_18_2")
    },
    [70] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_18_3")
    },
    [71] = {
      _type = PolicyTextType.DescSub,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_18_4")
    },
    [72] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_18_5")
    },
    [73] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_19")
    },
    [74] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_19")
    },
    [75] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_20")
    },
    [76] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_20")
    },
    [77] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_21")
    },
    [78] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_21")
    },
    [79] = {
      _type = PolicyTextType.Title,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_22")
    },
    [80] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_22")
    },
    [81] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_22_1")
    },
    [82] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_22_2")
    },
    [83] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_22_3")
    },
    [84] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_22_4")
    },
    [85] = {
      _type = PolicyTextType.SubTitle,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_TITLE_23")
    },
    [86] = {
      _type = PolicyTextType.Desc,
      _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_XBOXPOLICY_DESC_23")
    }
  }
end
local PaGlobal_Policy = {
  _ui = {
    btnConfirm = UI.getChildControl(Panel_Window_Policy, "StaticText_Confirm"),
    btnCancel = UI.getChildControl(Panel_Window_Policy, "StaticText_Close"),
    _content = UI.getChildControl(Panel_Window_Policy, "Frame_Content"),
    _text = {}
  },
  _defaultBtnConfirmPosX = 0,
  _defaultBtnCancelPosX = 0,
  _isLogin = nil
}
function PaGlobal_Policy:init()
  local frameContent = UI.getChildControl(self._ui._content, "Frame_1_Content")
  local control = self._ui._text
  local posY = 0
  for index = 1, #PolicyTextData do
    if PolicyTextType.Title == PolicyTextData[index]._type then
      control[index] = UI.createAndCopyBasePropertyControl(frameContent, "StaticText_Title", frameContent, "StaticText_Title_" .. index)
    elseif PolicyTextType.SubTitle == PolicyTextData[index]._type then
      control[index] = UI.createAndCopyBasePropertyControl(frameContent, "StaticText_SubTitle", frameContent, "StaticText_SubTitle_" .. index)
    elseif PolicyTextType.Desc == PolicyTextData[index]._type then
      control[index] = UI.createAndCopyBasePropertyControl(frameContent, "StaticText_Desc", frameContent, "StaticText_Desc_" .. index)
    elseif PolicyTextType.DescSub == PolicyTextData[index]._type then
      control[index] = UI.createAndCopyBasePropertyControl(frameContent, "StaticText_DescSub", frameContent, "StaticText_DescSub_" .. index)
    else
      control[index] = UI.createAndCopyBasePropertyControl(frameContent, "StaticText_DescRed", frameContent, "StaticText_DescRed_" .. index)
    end
    control[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    control[index]:SetText(PolicyTextData[index]._string)
    posY = posY + PolicyTextGap[PolicyTextData[index]._type]
    control[index]:SetPosY(posY)
    posY = posY + control[index]:GetTextSizeY()
  end
  self._ui.frame_VScroll = UI.getChildControl(self._ui._content, "Frame_1_VerticalScroll")
  self._ui.frame_VScroll:SetControlPos(0)
  self._ui._content:UpdateContentPos()
  self._ui._content:UpdateContentScroll()
  frameContent:SetSize(frameContent:GetSizeX(), posY + 10)
  self._defaultBtnConfirmPosX = self._ui.btnConfirm:GetPosX()
  self._defaultBtnCancelPosX = self._ui.btnCancel:GetPosX()
  self:registEventHandler()
end
function PaGlobal_Policy:registEventHandler()
  if true == ToClient_isConsole() then
    Panel_Window_Policy:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_Policy_Confirm()")
  end
end
function PaGlobal_Policy_ShowWindow(isLogin)
  local self = PaGlobal_Policy
  _AudioPostEvent_SystemUiForXBOX(1, 22)
  _isLogin = isLogin
  Panel_Window_Policy:SetShow(true)
  self._ui.btnConfirm:SetShow(isLogin)
  self._ui.btnCancel:SetShow(true)
  if true == isLogin then
    self._ui.btnConfirm:SetPosX(self._defaultBtnConfirmPosX - 100)
    self._ui.btnCancel:SetPosX(self._defaultBtnCancelPosX + 100)
  else
    self._ui.btnConfirm:SetPosX(self._defaultBtnConfirmPosX)
    self._ui.btnCancel:SetPosX(self._defaultBtnCancelPosX)
  end
end
function PaGlobal_Policy_Close()
  local self = PaGlobal_Policy
  _AudioPostEvent_SystemUiForXBOX(1, 21)
  Panel_Window_Policy:SetShow(false)
  if true == ToClient_isConsole() and true == _isLogin then
    PaGlobalFunc_LoginNickname_Open()
  end
end
function PaGlobal_Policy_Confirm()
  PaGlobal_Policy_Close()
end
function PaGlobal_Policy_Decline()
  PaGlobal_Policy_Close()
  LoginNickname_Close()
  if nil ~= ToClient_SetProcessor_XboxHome() then
    ToClient_SetProcessor_XboxHome()
  end
end
PaGlobal_Policy:init()
