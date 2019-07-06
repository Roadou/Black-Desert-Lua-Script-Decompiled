PaGlobal_TutorialUiMasking = {
  _ui = {
    _static_MaskingBg = UI.getChildControl(Panel_Tutorial_Renew, "Static_MaskingBg")
  }
}
local invenTutorialMaskCheck = false
function PaGlobal_TutorialUiMasking:showMasking(posX, posY)
  self._ui._static_MaskingBg:SetShow(true)
  self._ui._static_MaskingBg:SetPosX(posX)
  self._ui._static_MaskingBg:SetPosY(posY)
end
function PaGlobal_TutorialUiMasking:showInventoryMasking(posX, posY)
  if true == invenTutorialMaskCheck then
    return
  end
  self:showMasking(posX, posY)
end
function PaGlobal_TutorialUiMasking:showQuestMasking(posX, posY)
  naviTutorialMaskCheck = true
end
function PaGlobal_TutorialUiMasking:hideQuestMasking()
  self._ui._static_MaskingBg:SetShow(false)
end
function PaGlobal_TutorialUiMasking:showQuickSlotMasking(posX, posY)
  if true == invenTutorialMaskCheck then
    return
  end
end
function PaGlobal_TutorialUiMasking:showNewQuickSlotMasking(posX, posY)
  if true == invenTutorialMaskCheck then
    return
  end
end
function PaGlobal_TutorialUiMasking:showSpiritMasking()
  local _posX = 100
  local _posY = 100
end
function PaGlobal_TutorialUiMasking:showPanelMasking(targetPanel)
  self:showMasking(targetPanel:GetPosX(), targetPanel:GetPosY())
end
function PaGlobal_TutorialUiMasking:showChildControlMasking(parentPanel, childControl, offsetPosX, offsetPosY)
  if nil == offsetPosX then
    offsetPosX = 0
  end
  if nil == offsetPosY then
    offsetPosY = 0
  end
  local posX = parentPanel:GetPosX() + childControl:GetPosX() + childControl:GetSizeX() / 2 + offsetPosX - 136
  local posY = parentPanel:GetPosY() + childControl:GetPosY() + childControl:GetSizeY() / 2 + offsetPosY - 136
  self:showMasking(posX, posY)
end
