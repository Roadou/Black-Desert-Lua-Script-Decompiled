local UI_TM = CppEnums.TextMode
Panel_Tooltip_SimpleText:SetShow(false)
Panel_Tooltip_SimpleText:setGlassBackground(true)
Panel_Tooltip_SimpleText:SetIgnoreChild(true)
Panel_Tooltip_SimpleText:SetIgnore(true)
local _uiName = UI.getChildControl(Panel_Tooltip_SimpleText, "Tooltip_Name")
local _styleDesc = UI.getChildControl(Panel_Tooltip_SimpleText, "Tooltip_Description")
local _mouseL = UI.getChildControl(Panel_Tooltip_SimpleText, "Static_Help_MouseL")
local _mouseR = UI.getChildControl(Panel_Tooltip_SimpleText, "Static_Help_MouseR")
local _gaugeBG = UI.getChildControl(Panel_Tooltip_SimpleText, "Static_Gauge_BG")
local _gaugeProgress = UI.getChildControl(Panel_Tooltip_SimpleText, "Progress_Gauge")
local _gaugeBarHead = UI.getChildControl(_gaugeProgress, "Progress2_1_Bar_Head")
local _gaugeTime = UI.getChildControl(Panel_Tooltip_SimpleText, "StaticText_Gauge_Main")
local _isTooltipShow = false
local uiTextGroup = {_uiName = _uiName, _styleDesc = _styleDesc}
local TooltipSimple_SetPosition = function(parentPos, size, reversePosX)
  local itemShow = Panel_Tooltip_SimpleText:GetShow()
  if not itemShow then
    return
  end
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local itemPosX = Panel_Tooltip_SimpleText:GetSizeX()
  local itemPosY = Panel_Tooltip_SimpleText:GetSizeY()
  local posX = parentPos.x
  local posY = parentPos.y
  local isLeft = false
  if true == reversePosX then
    isLeft = posX < screenSizeX / 2
  else
    isLeft = posX > screenSizeX / 2
  end
  local isTop = posY > screenSizeY / 2
  local tooltipSize = {width = 0, height = 0}
  local tooltipEquipped = {width = 0, height = 0}
  local sumSize = {width = 0, height = 0}
  if Panel_Tooltip_SimpleText:GetShow() then
    tooltipSize.width = Panel_Tooltip_SimpleText:GetSizeX()
    tooltipSize.height = Panel_Tooltip_SimpleText:GetSizeY()
    sumSize.width = sumSize.width + tooltipSize.width
    sumSize.height = math.max(sumSize.height, tooltipSize.height)
  end
  if not isLeft then
    posX = posX + size.x
  end
  if isTop then
    posY = posY + size.y
    local yDiff = posY - sumSize.height
    if yDiff < 0 then
      posY = posY - yDiff
    end
  else
    local yDiff = screenSizeY - (posY + sumSize.height)
    if yDiff < 0 then
      posY = posY + yDiff
    end
  end
  if Panel_Tooltip_SimpleText:GetShow() then
    if isLeft then
      posX = posX - tooltipSize.width
    end
    local yTmp = posY
    if isTop then
      yTmp = yTmp - tooltipSize.height
    end
    Panel_Tooltip_SimpleText:SetPosX(mousePosX + 15)
    Panel_Tooltip_SimpleText:SetPosY(mousePosY + 15)
    if screenSizeX < Panel_Tooltip_SimpleText:GetPosX() + Panel_Tooltip_SimpleText:GetSizeX() then
      Panel_Tooltip_SimpleText:SetPosX(mousePosX - Panel_Tooltip_SimpleText:GetSizeX())
    else
      Panel_Tooltip_SimpleText:SetPosX(mousePosX + 15)
    end
    if screenSizeY < Panel_Tooltip_SimpleText:GetPosY() + Panel_Tooltip_SimpleText:GetSizeY() then
      Panel_Tooltip_SimpleText:SetPosY(mousePosY - Panel_Tooltip_SimpleText:GetSizeY())
    else
      Panel_Tooltip_SimpleText:SetPosY(mousePosY + 15)
    end
  end
end
local TooltipSimple_SetPosition_UISubApp = function(parent, size, reversePosX)
  local itemShow = Panel_Tooltip_SimpleText:GetShow()
  if not itemShow then
    return
  end
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local itemPosX = Panel_Tooltip_SimpleText:GetSizeX()
  local itemPosY = Panel_Tooltip_SimpleText:GetSizeY()
  local posX = parent:GetScreenParentPosX()
  local posY = parent:GetScreenParentPosY()
  local isLeft = false
  if true == reversePosX then
    isLeft = posX < screenSizeX / 2
  else
    isLeft = posX > screenSizeX / 2
  end
  local isTop = posY > screenSizeY / 2
  local tooltipSize = {width = 0, height = 0}
  local tooltipEquipped = {width = 0, height = 0}
  local sumSize = {width = 0, height = 0}
  if Panel_Tooltip_SimpleText:GetShow() then
    tooltipSize.width = Panel_Tooltip_SimpleText:GetSizeX()
    tooltipSize.height = Panel_Tooltip_SimpleText:GetSizeY()
    sumSize.width = sumSize.width + tooltipSize.width
    sumSize.height = math.max(sumSize.height, tooltipSize.height)
  end
  if not isLeft then
    posX = posX + size.x
  end
  if isTop then
    posY = posY + size.y
    local yDiff = posY - sumSize.height
    if yDiff < 0 then
      posY = posY - yDiff
    end
  else
    local yDiff = screenSizeY - (posY + sumSize.height)
    if yDiff < 0 then
      posY = posY + yDiff
    end
  end
  if Panel_Tooltip_SimpleText:GetShow() then
    if isLeft then
      posX = posX - tooltipSize.width
    end
    local yTmp = posY
    if isTop then
      yTmp = yTmp - tooltipSize.height
    end
    posX = parent:GetScreenParentPosX() + parent:GetParentPosX()
    yTmp = parent:GetScreenParentPosY() + parent:GetParentPosY()
    local mousePosX = getMousePosX()
    local mousePosY = getMousePosY()
    if screenSizeX < Panel_Tooltip_SimpleText:GetPosX() + Panel_Tooltip_SimpleText:GetSizeX() then
      Panel_Tooltip_SimpleText:SetPosX(posX - Panel_Tooltip_SimpleText:GetSizeX())
    else
      Panel_Tooltip_SimpleText:SetPosX(mousePosX + 15)
    end
    if screenSizeY < Panel_Tooltip_SimpleText:GetPosY() + Panel_Tooltip_SimpleText:GetSizeY() then
      Panel_Tooltip_SimpleText:SetPosY(yTmp - Panel_Tooltip_SimpleText:GetSizeY())
    else
      Panel_Tooltip_SimpleText:SetPosY(mousePosY + 15)
    end
  end
end
function TooltipSimple_CommonShow(name, desc)
  _isTooltipShow = Panel_Tooltip_SimpleText:GetShow()
  if Panel_Tooltip_SimpleText:GetShow() then
    Panel_Tooltip_SimpleText:SetShow(false)
  end
  if nil == name then
    _PA_ASSERT(false, "\236\157\184\236\158\144 name\236\157\128 \235\176\152\235\147\156\236\139\156 \236\158\133\235\160\165\237\149\180\236\149\188\237\149\169\235\139\136\235\139\164.")
    return
  end
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
      _PA_ASSERT(false, "\237\133\141\236\138\164\237\138\184\235\159\137\236\157\180 \235\132\136\235\172\180 \235\167\142\236\138\181\235\139\136\235\139\164. desc \236\157\184\236\158\144\235\165\188 \236\157\180\236\154\169\237\149\152\236\132\184\236\154\148. \236\131\137\236\131\129 \237\131\156\234\183\184 \235\149\140\235\172\184\236\157\180\235\157\188\235\169\180 \235\172\180\236\139\156\237\149\152\236\132\184\236\154\148.")
      _uiName:SetTextHorizonLeft()
      _uiName:SetTextMode(UI_TM.eTextMode_AutoWrap)
      _uiName:SetSize(220, _uiName:GetSizeY())
      _uiName:SetText(name)
    end
    Panel_Tooltip_SimpleText:SetSize(_uiName:GetSizeX() + _uiName:GetSpanSize().x * 2, _uiName:GetTextSizeY() + _uiName:GetSpanSize().x * 2)
    _styleDesc:SetShow(false)
  end
  if nil ~= desc then
    local descLength = string.len(desc)
    local panelWidth = 150
    if descLength < 100 then
      _uiName:SetSize(panelWidth - 20, _uiName:GetSizeY())
      _styleDesc:SetSize(panelWidth - 20, _styleDesc:GetSizeY())
      Panel_Tooltip_SimpleText:SetSize(panelWidth, Panel_Tooltip_SimpleText:GetSizeY())
    elseif descLength >= 100 and descLength < 400 then
      _uiName:SetSize(panelWidth + 80, _uiName:GetSizeY())
      _styleDesc:SetSize(panelWidth + 80, _styleDesc:GetSizeY())
      Panel_Tooltip_SimpleText:SetSize(panelWidth + 100, Panel_Tooltip_SimpleText:GetSizeY())
    else
      _uiName:SetSize(panelWidth + 120, _uiName:GetSizeY())
      _styleDesc:SetSize(panelWidth + 120, _styleDesc:GetSizeY())
      Panel_Tooltip_SimpleText:SetSize(panelWidth + 140, Panel_Tooltip_SimpleText:GetSizeY())
    end
    _uiName:SetTextHorizonLeft()
    _uiName:SetText(name)
    _gaugeBG:SetShow(false)
    _gaugeProgress:SetShow(false)
    _gaugeBarHead:SetShow(false)
    _gaugeTime:SetShow(false)
    if Panel_Tooltip_SimpleText:GetSizeX() < _uiName:GetTextSizeX() + 20 then
      Panel_Tooltip_SimpleText:SetSize(_uiName:GetTextSizeX() + 20, Panel_Tooltip_SimpleText:GetSizeY())
      _styleDesc:SetSize(Panel_Tooltip_SimpleText:GetSizeX() - 20, _styleDesc:GetSizeY())
    end
    _styleDesc:SetTextHorizonLeft()
    _styleDesc:SetAutoResize()
    _styleDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
    _styleDesc:SetText(desc)
    _styleDesc:SetShow(true)
    _styleDesc:SetPosY(_uiName:GetTextSizeY() + 10)
    Panel_Tooltip_SimpleText:SetSize(Panel_Tooltip_SimpleText:GetSizeX(), _uiName:GetTextSizeY() + _styleDesc:GetTextSizeY() + _uiName:GetSpanSize().x * 2)
  end
  Panel_Tooltip_SimpleText:SetShow(true)
end
function TooltipSimple_Common_Pos(posX, posY)
  Panel_Tooltip_SimpleText:SetPosXY(posX, posY)
end
function TooltipSimple_CommonShow_Gauge(name, desc, needTime, useTime)
  if Panel_Tooltip_SimpleText:GetShow() then
    Panel_Tooltip_SimpleText:SetShow(false)
  end
  if nil == name then
    _PA_ASSERT(false, "\236\157\184\236\158\144 name\236\157\128 \235\176\152\235\147\156\236\139\156 \236\158\133\235\160\165\237\149\180\236\149\188\237\149\169\235\139\136\235\139\164.")
    return
  end
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
      _PA_ASSERT(false, "\237\133\141\236\138\164\237\138\184\235\159\137\236\157\180 \235\132\136\235\172\180 \235\167\142\236\138\181\235\139\136\235\139\164. desc \236\157\184\236\158\144\235\165\188 \236\157\180\236\154\169\237\149\152\236\132\184\236\154\148. \236\131\137\236\131\129 \237\131\156\234\183\184 \235\149\140\235\172\184\236\157\180\235\157\188\235\169\180 \235\172\180\236\139\156\237\149\152\236\132\184\236\154\148.")
      _uiName:SetTextHorizonLeft()
      _uiName:SetTextMode(UI_TM.eTextMode_AutoWrap)
      _uiName:SetSize(220, _uiName:GetSizeY())
      _uiName:SetText(name)
    end
    Panel_Tooltip_SimpleText:SetSize(_uiName:GetSizeX() + _uiName:GetSpanSize().x * 2, _uiName:GetTextSizeY() + _uiName:GetSpanSize().x * 2)
    _styleDesc:SetShow(false)
  end
  if nil ~= desc then
    local descLength = string.len(desc)
    local panelWidth = 250
    if descLength < 100 then
      _uiName:SetSize(panelWidth - 20, _uiName:GetSizeY())
      _styleDesc:SetSize(panelWidth - 20, _styleDesc:GetSizeY())
      Panel_Tooltip_SimpleText:SetSize(panelWidth, Panel_Tooltip_SimpleText:GetSizeY())
    elseif descLength >= 100 and descLength < 400 then
      _uiName:SetSize(panelWidth + 80, _uiName:GetSizeY())
      _styleDesc:SetSize(panelWidth + 80, _styleDesc:GetSizeY())
      Panel_Tooltip_SimpleText:SetSize(panelWidth + 100, Panel_Tooltip_SimpleText:GetSizeY())
    else
      _uiName:SetSize(panelWidth + 120, _uiName:GetSizeY())
      _styleDesc:SetSize(panelWidth + 120, _styleDesc:GetSizeY())
      Panel_Tooltip_SimpleText:SetSize(panelWidth + 140, Panel_Tooltip_SimpleText:GetSizeY())
    end
    _uiName:SetTextHorizonLeft()
    _uiName:SetText(name)
    if Panel_Tooltip_SimpleText:GetSizeX() < _uiName:GetTextSizeX() + 20 then
      Panel_Tooltip_SimpleText:SetSize(_uiName:GetTextSizeX() + 20, Panel_Tooltip_SimpleText:GetSizeY())
      _styleDesc:SetSize(Panel_Tooltip_SimpleText:GetSizeX() - 20, _styleDesc:GetSizeY())
    end
    local gaugeText = ""
    local gaugeSizeY = 0
    if needTime <= useTime then
      gaugeText = PAGetString(Defines.StringSheet_GAME, "LUA_SIMPLETOOLTIP_PCROOMTIMEENOUGH")
      _gaugeBG:SetShow(false)
      _gaugeProgress:SetShow(false)
      _gaugeBarHead:SetShow(false)
      _gaugeTime:SetShow(false)
    else
      _gaugeBG:SetShow(true)
      _gaugeProgress:SetShow(true)
      _gaugeBarHead:SetShow(true)
      _gaugeTime:SetShow(true)
      gaugeText = PAGetString(Defines.StringSheet_GAME, "LUA_SIMPLETOOLTIP_PCROOMTIMELACK")
      gaugeSizeY = 30
      local minuteUseTime = Util.Time.timeFormatting_Minute(useTime)
      local minuteNeedTime = Util.Time.timeFormatting_Minute(needTime)
      _gaugeTime:SetText(tostring(minuteUseTime) .. " /" .. tostring(minuteNeedTime))
      _gaugeBG:SetSize(Panel_Tooltip_SimpleText:GetSizeX() - 20, _gaugeBG:GetSizeY())
      _gaugeProgress:SetSize(Panel_Tooltip_SimpleText:GetSizeX() - 20, _gaugeProgress:GetSizeY())
      _gaugeBarHead:SetSize(Panel_Tooltip_SimpleText:GetSizeX() - 20, _gaugeProgress:GetSizeY())
      local gaugeRate = useTime / needTime * 100
      _gaugeProgress:SetProgressRate(gaugeRate)
    end
    _styleDesc:SetTextHorizonLeft()
    _styleDesc:SetAutoResize()
    _styleDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
    _styleDesc:SetText(desc .. gaugeText)
    _styleDesc:SetShow(true)
    _styleDesc:SetPosY(_uiName:GetTextSizeY() + 10)
    Panel_Tooltip_SimpleText:SetSize(Panel_Tooltip_SimpleText:GetSizeX(), _uiName:GetTextSizeY() + _styleDesc:GetTextSizeY() + _uiName:GetSpanSize().x * 2 + gaugeSizeY)
    _gaugeBG:SetPosY(Panel_Tooltip_SimpleText:GetSizeY() - 15)
    _gaugeProgress:SetPosY(Panel_Tooltip_SimpleText:GetSizeY() - 15)
    _gaugeBarHead:SetPosY(Panel_Tooltip_SimpleText:GetSizeY() - 15)
    _gaugeTime:SetPosY(Panel_Tooltip_SimpleText:GetSizeY() - 36)
    _gaugeTime:SetPosX(Panel_Tooltip_SimpleText:GetSizeX() - 10 - _gaugeTime:GetSizeX())
  end
  Panel_Tooltip_SimpleText:SetShow(true)
end
function TooltipSimple_ShowSetSetPos_Console(pos, name, desc)
  if nil == pos.x then
    pos.x = 0
  end
  if nil == pos.y then
    pos.y = 0
  end
  Panel_Tooltip_SimpleText:ChangeTextureInfoName("new_ui_common_forlua/default/blackpanel_series.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(Panel_Tooltip_SimpleText, 127, 1, 189, 63)
  Panel_Tooltip_SimpleText:getBaseTexture():setUV(x1, y1, x2, y2)
  Panel_Tooltip_SimpleText:setRenderTexture(Panel_Tooltip_SimpleText:getBaseTexture())
  _mouseL:SetShow(false)
  _mouseR:SetShow(false)
  Panel_Tooltip_SimpleText:SetPosXY(pos.x, pos.y)
  TooltipSimple_CommonShow(name, desc)
end
function TooltipSimple_Show(uiControl, name, desc, reversePosX)
  Panel_Tooltip_SimpleText:ChangeTextureInfoName("new_ui_common_forlua/default/blackpanel_series.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(Panel_Tooltip_SimpleText, 127, 1, 189, 63)
  Panel_Tooltip_SimpleText:getBaseTexture():setUV(x1, y1, x2, y2)
  Panel_Tooltip_SimpleText:setRenderTexture(Panel_Tooltip_SimpleText:getBaseTexture())
  _mouseL:SetShow(false)
  _mouseR:SetShow(false)
  TooltipSimple_CommonShow(name, desc)
  local parentPos = {
    x = uiControl:GetParentPosX(),
    y = uiControl:GetParentPosY()
  }
  local size = {
    x = uiControl:GetSizeX(),
    y = uiControl:GetSizeY()
  }
  if uiControl:IsUISubApp() == true then
    TooltipSimple_SetPosition_UISubApp(uiControl, size, reversePosX)
    Panel_Tooltip_SimpleText:OpenUISubApp()
  else
    TooltipSimple_SetPosition(parentPos, size, reversePosX)
  end
end
function TooltipSimple_PCRoomHomeBuff_Show(uiControl, name, desc, reversePosX, needTime, useTime)
  Panel_Tooltip_SimpleText:ChangeTextureInfoName("new_ui_common_forlua/default/blackpanel_series.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(Panel_Tooltip_SimpleText, 127, 1, 189, 63)
  Panel_Tooltip_SimpleText:getBaseTexture():setUV(x1, y1, x2, y2)
  Panel_Tooltip_SimpleText:setRenderTexture(Panel_Tooltip_SimpleText:getBaseTexture())
  _mouseL:SetShow(false)
  _mouseR:SetShow(false)
  TooltipSimple_CommonShow_Gauge(name, desc, needTime, useTime)
  local parentPos = {
    x = uiControl:GetParentPosX(),
    y = uiControl:GetParentPosY()
  }
  local size = {
    x = uiControl:GetSizeX(),
    y = uiControl:GetSizeY()
  }
  if uiControl:IsUISubApp() == true then
    TooltipSimple_SetPosition_UISubApp(uiControl, size, reversePosX)
    Panel_Tooltip_SimpleText:OpenUISubApp()
  else
    TooltipSimple_SetPosition(parentPos, size, reversePosX)
  end
end
function TooltipSimple_ShowUsePosSize(parentPos, size, name, desc)
  Panel_Tooltip_SimpleText:ChangeTextureInfoName("new_ui_common_forlua/default/blackpanel_series.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(Panel_Tooltip_SimpleText, 127, 1, 189, 63)
  Panel_Tooltip_SimpleText:getBaseTexture():setUV(x1, y1, x2, y2)
  Panel_Tooltip_SimpleText:setRenderTexture(Panel_Tooltip_SimpleText:getBaseTexture())
  _mouseL:SetShow(false)
  _mouseR:SetShow(false)
  TooltipSimple_CommonShow(name, desc)
  TooltipSimple_SetPosition(parentPos, size)
end
function TooltipSimple_ShowMouseGuide(uiControl, onL, onR)
  if nil == uiControl then
    return
  end
  Panel_Tooltip_SimpleText:ChangeTextureInfoName("new_ui_common_forlua/default/blackpanel_series.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(Panel_Tooltip_SimpleText, 127, 64, 189, 126)
  Panel_Tooltip_SimpleText:getBaseTexture():setUV(x1, y1, x2, y2)
  Panel_Tooltip_SimpleText:setRenderTexture(Panel_Tooltip_SimpleText:getBaseTexture())
  TooltipSimple_CommonShow("                ")
  local parentPos = {
    x = uiControl:GetParentPosX(),
    y = uiControl:GetParentPosY()
  }
  local size = {
    x = uiControl:GetSizeX(),
    y = uiControl:GetSizeY()
  }
  TooltipSimple_SetPosition(parentPos, size)
  if true == onL then
    _mouseL:SetShow(true)
  else
    _mouseL:SetShow(false)
  end
  _mouseL:SetPosX(5)
  _mouseL:SetPosY(5)
  if true == onR then
    _mouseR:SetShow(true)
  else
    _mouseR:SetShow(false)
  end
  _mouseR:SetPosX(5)
  if _mouseL:GetShow() then
    _mouseR:SetPosY(35)
  else
    _mouseR:SetPosY(5)
  end
  if _mouseL:GetShow() and _mouseR:GetShow() then
    Panel_Tooltip_SimpleText:SetSize(Panel_Tooltip_SimpleText:GetSizeX(), _mouseR:GetPosY() + _mouseR:GetSizeY() + 5)
  else
    Panel_Tooltip_SimpleText:SetSize(Panel_Tooltip_SimpleText:GetSizeX(), 38)
  end
end
function TooltipSimple_Hide()
  Panel_Tooltip_SimpleText:SetShow(false)
  if Panel_Tooltip_SimpleText:IsUISubApp() == true then
    Panel_Tooltip_SimpleText:CloseUISubApp()
  end
  _gaugeBG:SetShow(false)
  _gaugeProgress:SetShow(false)
  _gaugeBarHead:SetShow(false)
  _gaugeTime:SetShow(false)
end
