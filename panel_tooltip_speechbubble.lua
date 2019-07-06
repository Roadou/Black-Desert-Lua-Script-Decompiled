local speechBubble = {
  _ui = {_txt_tooltipName = nil, _txt_tooltipDesc = nil},
  _initialize = false
}
function speechBubble:initialize()
  if true == speechBubble._initialize then
    return
  end
  speechBubble._ui._txt_tooltipName = UI.getChildControl(Panel_Tooltip_SpeechBubble, "Tooltip_Name")
  speechBubble._ui._txt_tooltipDesc = UI.getChildControl(Panel_Tooltip_SpeechBubble, "Tooltip_Description")
  speechBubble:registEventHandler()
  speechBubble:validate()
  speechBubble._initialize = true
end
function speechBubble:open()
  if nil == Panel_Tooltip_SpeechBubble then
    return
  end
  Panel_Tooltip_SpeechBubble:SetShow(true)
end
function speechBubble:close()
  if nil == Panel_Tooltip_SpeechBubble then
    return
  end
  Panel_Tooltip_SpeechBubble:SetShow(false)
end
function speechBubble:registEventHandler()
end
function speechBubble:validate()
  speechBubble._ui._txt_tooltipName:isValidate()
  speechBubble._ui._txt_tooltipDesc:isValidate()
end
function FromClient_SpeechBubble_Init()
  speechBubble:initialize()
end
function PaGlobal_SpeechBubble_Show(name, desc)
  if nil == name then
    _PA_ASSERT(false, "\236\157\184\236\158\144 name\236\157\128 \235\176\152\235\147\156\236\139\156 \236\158\133\235\160\165\237\149\180\236\149\188\237\149\169\235\139\136\235\139\164.")
    return
  end
  local _uiName = speechBubble._ui._txt_tooltipName
  local _styleDesc = speechBubble._ui._txt_tooltipDesc
  if nil == desc and nil ~= name then
    local nameLength = string.len(name)
    _uiName:SetSize(220, _uiName:GetSizeY())
    if nameLength < 30 then
      _uiName:SetTextHorizonCenter()
      _uiName:SetText(name)
      _uiName:SetSize(_uiName:GetTextSizeX() + _uiName:GetSpanSize().x, _uiName:GetSizeY())
    elseif nameLength >= 30 and nameLength < 60 then
      _uiName:SetTextHorizonLeft()
      _uiName:SetTextMode(UI_TM.eTextMode_AutoWrap)
      _uiName:SetSize(220, _uiName:GetSizeY())
      _uiName:SetText(name)
    else
      _uiName:SetTextHorizonLeft()
      _uiName:SetTextMode(UI_TM.eTextMode_AutoWrap)
      _uiName:SetSize(220, _uiName:GetSizeY())
      _uiName:SetText(name)
    end
    Panel_Tooltip_SpeechBubble:SetSize(_uiName:GetSizeX() + _uiName:GetSpanSize().x * 2, _uiName:GetTextSizeY() + _uiName:GetSpanSize().x * 2)
    _styleDesc:SetShow(false)
  end
  if nil ~= desc then
    local descLength = string.len(desc)
    local panelWidth = 150
    if descLength < 100 then
      _uiName:SetSize(panelWidth - 20, _uiName:GetSizeY())
      _styleDesc:SetSize(panelWidth - 20, _styleDesc:GetSizeY())
      Panel_Tooltip_SpeechBubble:SetSize(panelWidth, Panel_Tooltip_SpeechBubble:GetSizeY())
    elseif descLength >= 100 and descLength < 400 then
      _uiName:SetSize(panelWidth + 80, _uiName:GetSizeY())
      _styleDesc:SetSize(panelWidth + 80, _styleDesc:GetSizeY())
      Panel_Tooltip_SpeechBubble:SetSize(panelWidth + 100, Panel_Tooltip_SpeechBubble:GetSizeY())
    else
      _uiName:SetSize(panelWidth + 120, _uiName:GetSizeY())
      _styleDesc:SetSize(panelWidth + 120, _styleDesc:GetSizeY())
      Panel_Tooltip_SpeechBubble:SetSize(panelWidth + 140, Panel_Tooltip_SpeechBubble:GetSizeY())
    end
    _uiName:SetTextHorizonLeft()
    _uiName:SetText(name)
    _gaugeBG:SetShow(false)
    _gaugeProgress:SetShow(false)
    _gaugeBarHead:SetShow(false)
    _gaugeTime:SetShow(false)
    if Panel_Tooltip_SpeechBubble:GetSizeX() < _uiName:GetTextSizeX() + 20 then
      Panel_Tooltip_SpeechBubble:SetSize(_uiName:GetTextSizeX() + 20, Panel_Tooltip_SpeechBubble:GetSizeY())
      _styleDesc:SetSize(Panel_Tooltip_SpeechBubble:GetSizeX() - 20, _styleDesc:GetSizeY())
    end
    _styleDesc:SetTextHorizonLeft()
    _styleDesc:SetAutoResize()
    _styleDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
    _styleDesc:SetText(desc)
    _styleDesc:SetShow(true)
    _styleDesc:SetPosY(_uiName:GetTextSizeY() + 10)
    Panel_Tooltip_SpeechBubble:SetSize(Panel_Tooltip_SpeechBubble:GetSizeX(), _uiName:GetTextSizeY() + _styleDesc:GetTextSizeY() + _uiName:GetSpanSize().x * 2)
  end
  speechBubble:open()
end
function PaGlobal_SpeechBubble_Hide()
  speechBubble:close()
end
function PaGlobal_SpeechBubble_Pos(posX, posY)
  Panel_Tooltip_SpeechBubble:SetPosXY(posX, posY)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_SpeechBubble_Init")
