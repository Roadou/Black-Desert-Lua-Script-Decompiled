function HandleEventMouseLup_AreaOfHadum_CreateTotem()
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
  local self = PaGlobal_AreaOfHadum
  if false == ToClient_IsExistAreaOfHadumTotem() then
    ToClient_CreateAreaOfHadumTotemByAction()
  else
    ToClient_ClearAreaOfHadumTotem()
  end
end
function HandleEventMouseLup_AreaOfHadum_ChangeOpenState()
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
  local self = PaGlobal_AreaOfHadum
  if true == self._ui._isOpen then
    self:CloseAnimation()
    self:OpenAndCloseButtonChangeToOpenIcon()
    self._ui._isOpen = false
  else
    self:OpenAnimation()
    self:OpenAndCloseButtonChangeToCloseIcon()
    self._ui._isOpen = true
  end
end
function HandleEventMouseOn_AreaOfHadum_ShowTooltip(isShowTooltip)
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
  local hadumIcon = PaGlobal_AreaOfHadum._ui._hadumIcon
  if true == isShowTooltip then
    if nil ~= hadumIcon then
      local tooltipName = PAGetString(Defines.StringSheet_GAME, "LUA_AREAOFHADUM_TOOLTIP_NAME")
      local tooltipDesc = PAGetString(Defines.StringSheet_GAME, "LUA_AREAOFHADUM_TOOLTIP_DESC")
      TooltipSimple_Show(hadumIcon, tooltipName, tooltipDesc)
    end
  else
    TooltipSimple_Hide()
  end
end
function FromClient_UpdateAreaOfHadumPoint()
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
  local self = PaGlobal_AreaOfHadum
  if false == self._initialize then
    return
  end
  local AreaOfHadumPointProgressBar = self._ui._pointProgressBar
  local AreaOfHadumPointTextBox = self._ui._pointTextBox
  local currentPoint = ToClient_GetAreaOfHadumPoint()
  local progressbarMaxPoint = 1000
  local progressbarCurrentPoint = currentPoint % progressbarMaxPoint
  local pointRate = progressbarCurrentPoint / progressbarMaxPoint * 100
  AreaOfHadumPointProgressBar:SetProgressRate(pointRate)
  AreaOfHadumPointProgressBar:ChangeTextureInfoName("renewal/pcremaster/remaster_hadum_01.dds")
  local x1, y1, x2, y2
  if currentPoint >= 5000 then
    x1, y1, x2, y2 = setTextureUV_Func(AreaOfHadumPointProgressBar, 17, 148, 24, 155)
    AreaOfHadumPointProgressBar:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif currentPoint >= 4000 then
    x1, y1, x2, y2 = setTextureUV_Func(AreaOfHadumPointProgressBar, 25, 148, 32, 155)
    AreaOfHadumPointProgressBar:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif currentPoint >= 3000 then
    x1, y1, x2, y2 = setTextureUV_Func(AreaOfHadumPointProgressBar, 33, 148, 40, 155)
    AreaOfHadumPointProgressBar:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif currentPoint >= 2000 then
    x1, y1, x2, y2 = setTextureUV_Func(AreaOfHadumPointProgressBar, 41, 148, 48, 155)
    AreaOfHadumPointProgressBar:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif currentPoint >= 1000 then
    x1, y1, x2, y2 = setTextureUV_Func(AreaOfHadumPointProgressBar, 49, 148, 56, 155)
    AreaOfHadumPointProgressBar:getBaseTexture():setUV(x1, y1, x2, y2)
  else
    x1, y1, x2, y2 = setTextureUV_Func(AreaOfHadumPointProgressBar, 9, 148, 16, 155)
    AreaOfHadumPointProgressBar:getBaseTexture():setUV(x1, y1, x2, y2)
  end
  local textMaxPoint = ToClient_GetAreaOfHadumMaxPoint()
  AreaOfHadumPointTextBox:SetText(tostring(currentPoint) .. " / " .. tostring(textMaxPoint))
end
function FromClient_SpawnTotemUpdated(isSpawn)
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
  local self = PaGlobal_AreaOfHadum
  if false == self._initialize then
    return
  end
  if true == isSpawn then
    self:CreateTotemButtonChangeToClearIcon()
  else
    self:CreateTotemButtonChangeToCreateIcon()
  end
end
