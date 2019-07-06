PaGlobal_TutorialUiMasking = {
  _ui = {
    _static_MaskingBg = UI.getChildControl(Panel_Tutorial_Renew, "Static_MaskingBg"),
    _maskBg_Quest = UI.getChildControl(Panel_Tutorial_Renew, "Static_MaskBg_Quest"),
    _maskBg_SelfExpGuage = UI.getChildControl(Panel_Tutorial_Renew, "Static_MaskBg_SelfExpGauge"),
    _maskBg_Spirit = UI.getChildControl(Panel_Tutorial_Renew, "Static_MaskBg_Spirit")
  }
}
local invenTutorialMaskCheck = false
function PaGlobal_TutorialUiMasking:showMasking(posX, posY)
  if not ToClient_isConsole() then
    self._ui._maskBg_Quest:SetShow(true)
    local _posX = Panel_Window_Inventory:GetPosX() + posX - 130
    local _posY = Panel_Window_Inventory:GetPosY() + posY - 115
    self._ui._maskBg_Quest:SetPosX(_posX)
    self._ui._maskBg_Quest:SetPosY(_posY)
    return
  end
  self._ui._static_MaskingBg:SetShow(true)
  self._ui._static_MaskingBg:SetPosX(posX)
  self._ui._static_MaskingBg:SetPosY(posY)
end
function PaGlobal_TutorialUiMasking:showBackgroundMasking(posX, posY)
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
  self._ui._maskBg_Quest:SetShow(true)
  local _posX = Panel_CheckedQuest:GetPosX() + posX - 150
  local _posY = Panel_CheckedQuest:GetPosY() + posY - 120
  self._ui._maskBg_Quest:SetPosX(_posX)
  self._ui._maskBg_Quest:SetPosY(_posY)
end
function PaGlobal_TutorialUiMasking:hideQuestMasking()
  self._ui._maskBg_Quest:SetShow(false)
  self._ui._static_MaskingBg:SetShow(false)
  self._ui._maskBg_SelfExpGuage:SetShow(false)
  self._ui._maskBg_Spirit:SetShow(false)
end
function PaGlobal_TutorialUiMasking:showQuickSlotMasking(posX, posY)
  if true == invenTutorialMaskCheck then
    return
  end
  invenTutorialMaskCheck = true
  self._ui._maskBg_Quest:SetShow(true)
  local _posX = Panel_QuickSlot:GetPosX() + posX - 130
  local _posY = Panel_QuickSlot:GetPosY() + posY - 115
  self._ui._maskBg_Quest:SetPosX(_posX)
  self._ui._maskBg_Quest:SetPosY(_posY)
end
function PaGlobal_TutorialUiMasking:showSpiritMasking()
  self._ui._maskBg_Spirit:SetShow(true)
  local _posX = Panel_NewQuest_Alarm:GetPosX() - 100
  local _posY = Panel_NewQuest_Alarm:GetPosY() - 70
  self._ui._maskBg_Spirit:SetPosX(_posX)
  self._ui._maskBg_Spirit:SetPosY(_posY)
end
function PaGlobal_TutorialUiMasking:showPanelMasking(targetPanel)
  self._ui._maskBg_Quest:SetShow(true)
  self._ui._maskBg_Quest:SetPosX(targetPanel:GetPosX())
  self._ui._maskBg_Quest:SetPosY(targetPanel:GetPosY())
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
