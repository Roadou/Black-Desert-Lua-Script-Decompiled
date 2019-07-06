FullSizeMode = {}
FullSizeMode.isFullSizeWindowOn = false
FullSizeMode.fullSizeWindow = 0
FullSizeMode.fullSizeModeEnum = {
  Worldmap = 0,
  MentalKnowledge = 1,
  Intimacy = 2,
  Dialog = 3
}
function setFullSizeMode(isFull, fullSizePanel)
  FullSizeMode.isFullSizeWindowOn = isFull
  if isFull then
    FullSizeMode.fullSizeWindow = fullSizePanel
  end
end
function isFullSizeModeAble(fullSizePanel)
  if not FullSizeMode.isFullSizeWindowOn then
    return true
  else
    return FullSizeMode.fullSizeWindow == fullSizePanel
  end
end
