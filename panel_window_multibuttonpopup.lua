local _panel = Panel_Window_MultiButtonPopup
local BUTTON = {
  UP = CppEnums.PA_CONSOLE_UI_EVENT_TYPE.eCONSOLE_UI_EVENT_TYPE_UP,
  DOWN = CppEnums.PA_CONSOLE_UI_EVENT_TYPE.eCONSOLE_UI_EVENT_TYPE_DOWN,
  LEFT = CppEnums.PA_CONSOLE_UI_EVENT_TYPE.eCONSOLE_UI_EVENT_TYPE_LEFT,
  RIGHT = CppEnums.PA_CONSOLE_UI_EVENT_TYPE.eCONSOLE_UI_EVENT_TYPE_RIGHT,
  LB = CppEnums.PA_CONSOLE_UI_EVENT_TYPE.eCONSOLE_UI_EVENT_TYPE_LB,
  RB = CppEnums.PA_CONSOLE_UI_EVENT_TYPE.eCONSOLE_UI_EVENT_TYPE_RB,
  LB2 = CppEnums.PA_CONSOLE_UI_EVENT_TYPE.eCONSOLE_UI_EVENT_TYPE_LB2,
  RB2 = CppEnums.PA_CONSOLE_UI_EVENT_TYPE.eCONSOLE_UI_EVENT_TYPE_RB2,
  X = 8,
  Y = 9,
  A = 10,
  B = 11
}
local MultiButtonPopup = {
  _ui = {
    stc_BG = UI.getChildControl(_panel, "Static_BG"),
    btn_ButtonTemplate = nil,
    txt_descTemplate = nil,
    stc_iconTemplate = nil,
    btn_functions = {},
    stc_icons = {},
    txt_descriptions = {}
  },
  _buttonYGab = nil,
  _pooledButtonCount = 0,
  _visibleButtonCount = 0
}
local _buttonUV = {
  [BUTTON.UP] = {
    181,
    136,
    225,
    180
  },
  [BUTTON.DOWN] = {
    181,
    46,
    225,
    90
  },
  [BUTTON.LEFT] = {
    181,
    91,
    225,
    135
  },
  [BUTTON.RIGHT] = {
    181,
    1,
    225,
    45
  },
  [BUTTON.LB] = {
    91,
    136,
    135,
    180
  },
  [BUTTON.RB] = {
    136,
    136,
    180,
    180
  },
  [BUTTON.X] = {
    136,
    1,
    180,
    45
  },
  [BUTTON.Y] = {
    46,
    1,
    90,
    45
  },
  [BUTTON.A] = {
    1,
    1,
    45,
    45
  },
  [BUTTON.B] = {
    91,
    1,
    135,
    45
  }
}
local _popupConfig = {
  [1] = {
    func = nil,
    param = nil,
    icon = nil,
    desc = nil
  }
}
function FromClient_luaLoadComplete_MultiButtonPopup_Init()
  MultiButtonPopup:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MultiButtonPopup_Init")
function MultiButtonPopup:initialize()
  self._ui.btn_ButtonTemplate = UI.getChildControl(self._ui.stc_BG, "Button_Template")
  self._ui.txt_descTemplate = UI.getChildControl(self._ui.btn_ButtonTemplate, "StaticText_DescTemplate")
  self._ui.stc_iconTemplate = UI.getChildControl(self._ui.btn_ButtonTemplate, "Static_IconTemplate")
  self._buttonYGab = self._ui.btn_ButtonTemplate:GetSizeY() + 10
  self:registEventHandler()
end
function MultiButtonPopup:registEventHandler()
  self._ui.stc_BG:addInputEvent("Mouse_Out", "PaGlobalFunc_MultiButtonPopup_CheckMouseAndClose()")
  _panel:registerPadEvent(__eCONSOLE_UI_INPUT_TYPE_B, "PaGlobalFunc_MultiButtonPopup_Close")
end
function PaGlobalFunc_MultiButtonPopup_Open(option, posX, posY)
  local self = MultiButtonPopup
  if nil == option then
    return
  end
  _popupConfig = nil
  _popupConfig = option
  _panel:SetShow(true)
  self._visibleButtonCount = 0
  for ii = 1, #_popupConfig do
    if nil ~= _popupConfig[ii].func and "function" == type(_popupConfig[ii].func) then
      if nil == self._ui.btn_functions[ii] then
        self._ui.btn_functions[ii] = UI.createAndCopyBasePropertyControl(self._ui.stc_BG, "Button_Template", self._ui.stc_BG, "Button_" .. ii)
        self._ui.stc_icons[ii] = UI.createAndCopyBasePropertyControl(self._ui.btn_ButtonTemplate, "Static_IconTemplate", self._ui.btn_functions[ii], "Static_Icon_" .. ii)
        self._ui.txt_descriptions[ii] = UI.createAndCopyBasePropertyControl(self._ui.btn_ButtonTemplate, "StaticText_DescTemplate", self._ui.btn_functions[ii], "StaticText_Desc_" .. ii)
        self._ui.btn_functions[ii]:SetPosY(self._ui.btn_ButtonTemplate:GetPosY() + (ii - 1) * self._buttonYGab)
        self._pooledButtonCount = self._pooledButtonCount + 1
      end
      self._ui.btn_functions[ii]:SetShow(true)
      self._ui.btn_functions[ii]:addInputEvent("Mouse_LUp", "PaGlobalFunc_MultiButtonPopup_ProcessFunc(" .. ii .. ")")
      self._ui.btn_functions[ii]:addInputEvent("Mouse_RUp", "PaGlobalFunc_MultiButtonPopup_Close()")
      self._ui.btn_functions[ii]:addInputEvent("Mouse_Out", "PaGlobalFunc_MultiButtonPopup_CheckMouseAndClose()")
      if nil ~= _popupConfig[ii].enable then
        self._ui.btn_functions[ii]:SetEnable(_popupConfig[ii].enable)
        self._ui.btn_functions[ii]:SetMonoTone(not _popupConfig[ii].enable)
      else
        self._ui.btn_functions[ii]:SetEnable(true)
        self._ui.btn_functions[ii]:SetMonoTone(false)
      end
      local icon = self._ui.stc_icons[ii]
      if nil ~= _popupConfig[ii].icon then
        icon:SetShow(true)
        local x1, y1, x2, y2 = setTextureUV_Func(icon, _buttonUV[ii][1], _buttonUV[ii][2], _buttonUV[ii][3], _buttonUV[ii][4])
        icon:getBaseTexture():setUV(x1, y1, x2, y2)
        icon:setRenderTexture(icon:getBaseTexture())
      else
        icon:SetShow(false)
      end
      self._ui.txt_descriptions[ii]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      self._ui.txt_descriptions[ii]:SetText(_popupConfig[ii].desc)
      self._visibleButtonCount = self._visibleButtonCount + 1
    end
  end
  if self._visibleButtonCount < 1 then
    PaGlobalFunc_MultiButtonPopup_Close()
    return
  end
  for ii = #_popupConfig + 1, #self._ui.btn_functions do
    self._ui.btn_functions[ii]:SetShow(false)
  end
  local bgYResize = self._visibleButtonCount * self._buttonYGab + self._ui.btn_ButtonTemplate:GetPosY()
  _panel:SetSize(_panel:GetSizeX(), bgYResize)
  self._ui.stc_BG:SetSize(_panel:GetSizeX(), bgYResize)
  self._ui.stc_BG:ComputePos()
  if nil ~= posX and nil ~= posY then
    self:setPosition(posX, posY)
  end
end
function MultiButtonPopup:setPosition(posX, posY)
  local targetX, targetY = posX, posY
  local screenX, screenY = getScreenSizeX(), getScreenSizeY()
  local bgSizeX = _panel:GetSizeX()
  local bgSizeY = _panel:GetSizeY()
  if screenX < targetX + bgSizeX then
    targetX = targetX - bgSizeX
  end
  if screenY < targetY + bgSizeY then
    targetY = targetY - bgSizeY
  end
  _panel:SetPosX(targetX)
  _panel:SetPosY(targetY)
end
function PaGlobalFunc_MultiButtonPopup_ProcessFunc(index)
  if nil ~= _popupConfig[index].func and "function" == type(_popupConfig[index].func) then
    _popupConfig[index].func(_popupConfig[index].param)
    PaGlobalFunc_MultiButtonPopup_Close()
  end
end
function PaGlobalFunc_MultiButtonPopup_CheckMouseAndClose()
  if false == _panel:IsShow() then
    return
  end
  if true == _ContentsGroup_RenewUI then
    return
  end
  local panelPosX, panelPosY = _panel:GetPosX(), _panel:GetPosY()
  local panelSizeX, panelSizeY = _panel:GetSizeX(), _panel:GetSizeY()
  local mousePosX, mousePosY = getMousePosX(), getMousePosY()
  if panelPosX <= mousePosX and mousePosX <= panelPosX + panelSizeX and panelPosY <= mousePosY and mousePosY <= panelPosY + panelSizeY then
    return
  end
  PaGlobalFunc_MultiButtonPopup_Close()
end
function PaGlobalFunc_MultiButtonPopup_IsOpened()
  return _panel:GetShow()
end
function PaGlobalFunc_MultiButtonPopup_Close()
  _panel:SetShow(false)
end
