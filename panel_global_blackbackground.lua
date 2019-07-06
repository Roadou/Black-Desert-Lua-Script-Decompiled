local BlackBackground = {
  _targetList = {},
  _current = nil
}
Panel_Global_BlackBackGround:SetIgnore(true)
Panel_Global_BlackBackGround:SetEnable(false)
Panel_Global_BlackBackGround:SetOffsetIgnorePanel(true)
Panel_Global_BlackBackGround:SetSize(getOriginScreenSizeX(), getOriginScreenSizeY())
Panel_Global_BlackBackGround:ComputePos()
function BlackBackground:show()
  Panel_Global_BlackBackGround:SetShow(true)
end
function BlackBackground:hide()
  Panel_Global_BlackBackGround:SetShow(false)
end
function FromClient_BlakcBackGround_PadSnapChangePanel(fromPanel, toPanel)
  if nil == fromPanel and nil ~= toPanel then
    if true == BlackBackground:isExistPanelInList(toPanel) then
      BlackBackground:applyBlackBg(toPanel)
    end
  elseif nil ~= fromPanel and nil == toPanel then
    BlackBackground:hide()
  elseif true == BlackBackground:isExistPanelInList(toPanel) then
    BlackBackground:applyBlackBg(toPanel)
  else
    BlackBackground:hide()
  end
end
function FromClient_BlakcBackGround_OnResize()
  Panel_Global_BlackBackGround:SetSize(getOriginScreenSizeX(), getOriginScreenSizeY())
  Panel_Global_BlackBackGround:ComputePos()
end
function BlackBackground:isExistPanelInList(checkPanel)
  if nil ~= checkPanel then
    for index, panel in ipairs(BlackBackground._targetList) do
      if nil ~= panel and panel:GetKey() == checkPanel:GetKey() then
        return true
      end
    end
  end
  return false
end
function PaGlobal_registerPanelOnBlackBackground(targetPanel)
  if not _ContentsGroup_RenewUI then
    return
  end
  if nil == targetPanel then
    _PA_LOG("\237\155\132\236\167\132", " BlackBackground \235\147\177\235\161\157 \237\149\152\235\138\148\235\141\176 targetPanel\236\157\180 nil \236\158\133\235\139\136\235\139\164. ")
    return
  end
  BlackBackground._targetList[#BlackBackground._targetList + 1] = targetPanel
end
function BlackBackground:applyBlackBg(targetPanel)
  if nil == targetPanel then
    return
  end
  local rv = ToClient_padSnapApplyBlackBackGround(Panel_Global_BlackBackGround, targetPanel)
  if true == rv then
    BlackBackground:show()
  end
end
Panel_Global_BlackBackGround:SetAlpha(0.7)
registerEvent("FromClient_PadSnapChangePanel", "FromClient_BlakcBackGround_PadSnapChangePanel")
registerEvent("onScreenResize", "FromClient_BlakcBackGround_OnResize")
