PaGlobal_TutorialUiMasking = {
  _ui = {
    _maskBg_Quest = UI.getChildControl(Panel_Masking_Tutorial, "Static_MaskBg_Quest"),
    _maskBg_SelfExpGuage = UI.getChildControl(Panel_Masking_Tutorial, "Static_MaskBg_SelfExpGauge"),
    _maskBg_Spirit = UI.getChildControl(Panel_Masking_Tutorial, "Static_MaskBg_Spirit")
  }
}
local invenTutorialMaskCheck = false
function PaGlobal_TutorialUiMasking:showInventoryMasking(posX, posY)
  if true == invenTutorialMaskCheck then
    return
  end
  invenTutorialMaskCheck = true
  Panel_Masking_Tutorial:SetShow(true)
  self._ui._maskBg_Quest:SetShow(true)
  self._ui._maskBg_SelfExpGuage:SetShow(false)
  self._ui._maskBg_Spirit:SetShow(false)
  local _posX = Panel_Window_Inventory:GetPosX() + posX - 130
  local _posY = Panel_Window_Inventory:GetPosY() + posY - 115
  Panel_Masking_Tutorial:SetPosX(_posX)
  Panel_Masking_Tutorial:SetPosY(_posY)
end
function PaGlobal_TutorialUiMasking:showQuestMasking(posX, posY)
  naviTutorialMaskCheck = true
  Panel_Masking_Tutorial:SetShow(true)
  self._ui._maskBg_Quest:SetShow(true)
  self._ui._maskBg_SelfExpGuage:SetShow(false)
  self._ui._maskBg_Spirit:SetShow(false)
  local _posX = Panel_CheckedQuest:GetPosX() + posX - 150
  local _posY = Panel_CheckedQuest:GetPosY() + posY - 120
  Panel_Masking_Tutorial:SetPosX(_posX)
  Panel_Masking_Tutorial:SetPosY(_posY)
end
function PaGlobal_TutorialUiMasking:hideQuestMasking()
  Panel_Masking_Tutorial:SetShow(false)
  self._ui._maskBg_Quest:SetShow(false)
  self._ui._maskBg_SelfExpGuage:SetShow(false)
  self._ui._maskBg_Spirit:SetShow(false)
  invenTutorialMaskCheck = false
end
function PaGlobal_TutorialUiMasking:showQuickSlotMasking(posX, posY)
  if true == invenTutorialMaskCheck then
    return
  end
  invenTutorialMaskCheck = true
  Panel_Masking_Tutorial:SetShow(true)
  self._ui._maskBg_Quest:SetShow(true)
  self._ui._maskBg_SelfExpGuage:SetShow(false)
  self._ui._maskBg_Spirit:SetShow(false)
  local _posX = Panel_QuickSlot:GetPosX() + posX - 130
  local _posY = Panel_QuickSlot:GetPosY() + posY - 115
  Panel_Masking_Tutorial:SetPosX(_posX)
  Panel_Masking_Tutorial:SetPosY(_posY)
end
function PaGlobal_TutorialUiMasking:showNewQuickSlotMasking(posX, posY)
  if true == invenTutorialMaskCheck then
    return
  end
  invenTutorialMaskCheck = true
  Panel_Masking_Tutorial:SetShow(true)
  self._ui._maskBg_Quest:SetShow(true)
  self._ui._maskBg_SelfExpGuage:SetShow(false)
  self._ui._maskBg_Spirit:SetShow(false)
  local _posX = posX - 136
  local _posY = posY - 136
  Panel_Masking_Tutorial:SetPosX(_posX)
  Panel_Masking_Tutorial:SetPosY(_posY)
end
function PaGlobal_TutorialUiMasking:showSpiritMasking()
  Panel_Masking_Tutorial:SetShow(true)
  self._ui._maskBg_Quest:SetShow(false)
  self._ui._maskBg_SelfExpGuage:SetShow(false)
  self._ui._maskBg_Spirit:SetShow(true)
  local _posX = Panel_NewQuest_Alarm:GetPosX() - 100
  local _posY = Panel_NewQuest_Alarm:GetPosY() - 70
  Panel_Masking_Tutorial:SetPosX(_posX)
  Panel_Masking_Tutorial:SetPosY(_posY)
end
function PaGlobal_TutorialUiMasking:showPanelMasking(targetPanel)
  Panel_Masking_Tutorial:SetShow(true)
  self._ui._maskBg_Quest:SetShow(true)
  self._ui._maskBg_SelfExpGuage:SetShow(false)
  self._ui._maskBg_Spirit:SetShow(false)
  Panel_Masking_Tutorial:SetPosX(targetPanel:GetPosX())
  Panel_Masking_Tutorial:SetPosY(targetPanel:GetPosY())
end
function PaGlobal_TutorialUiMasking:showChildControlMasking(parentPanel, childControl, offsetPosX, offsetPosY)
  Panel_Masking_Tutorial:SetShow(true)
  self._ui._maskBg_Quest:SetShow(true)
  self._ui._maskBg_SelfExpGuage:SetShow(false)
  self._ui._maskBg_Spirit:SetShow(false)
  if nil == offsetPosX then
    offsetPosX = 0
  end
  if nil == offsetPosY then
    offsetPosY = 0
  end
  local posX = parentPanel:GetPosX() + childControl:GetPosX() + childControl:GetSizeX() / 2 + offsetPosX - 136
  local posY = parentPanel:GetPosY() + childControl:GetPosY() + childControl:GetSizeY() / 2 + offsetPosY - 136
  Panel_Masking_Tutorial:SetPosX(posX)
  Panel_Masking_Tutorial:SetPosY(posY)
end
