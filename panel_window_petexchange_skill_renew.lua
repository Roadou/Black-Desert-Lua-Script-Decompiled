Panel_Window_PetExchange_Skill_Renew:SetShow(false)
local PetExchangeSkill = {
  _ui = {
    _txt_title = UI.getChildControl(Panel_Window_PetExchange_Skill_Renew, "StaticText_Title"),
    _stc_centerBG = UI.getChildControl(Panel_Window_PetExchange_Skill_Renew, "Static_CenterBG"),
    _stc_bottomKeyBG = UI.getChildControl(Panel_Window_PetExchange_Skill_Renew, "Static_BottomKeyBG"),
    _chk_skillList = {},
    _stc_skillIconList = {}
  },
  _config = {
    _rowCount = 3,
    _columnCount = 2,
    _subPetSlotCount = 0
  },
  _subPetTotalCount = 0,
  _subPetIndexList = {},
  _petSkillCount = 4,
  _curSubPetRow = 0,
  _showStartRow = 0,
  _curShowStartIndex = 0,
  _curShowPetIndexList = {},
  _keyGuideAlign = {},
  _panel = Panel_Window_PetExchange_Skill_Renew
}
function PetExchangeSkill:InitControl()
  self._ui._stc_buttonGroup = UI.getChildControl(self._ui._stc_centerBG, "Static_ButtonGroup")
  self._ui._chk_defaultSkill = UI.getChildControl(self._ui._stc_buttonGroup, "CheckButton_Skill")
  self._ui._scroll_vertical = UI.getChildControl(self._ui._stc_buttonGroup, "Scroll_VerticalScroll")
  self._ui._btn_confirm = UI.getChildControl(self._ui._stc_bottomKeyBG, "StaticText_Confirm_ConsoleUI")
  self._ui._btn_exit = UI.getChildControl(self._ui._stc_bottomKeyBG, "StaticText_Cancel_ConsoleUI")
  self._keyGuideAlign = {
    self._ui._btn_confirm,
    self._ui._btn_exit
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._stc_bottomKeyBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self:CreateSubSkillButton()
end
function PetExchangeSkill:RegistEventHandler()
  registerEvent("onScreenResize", "PaGlobalFunc_PetExchangeSkill_OnScreenResize")
end
function PetExchangeSkill:Initialize()
  self:InitControl()
  self:RegistEventHandler()
  self:onScreenResize()
  self._config._subPetSlotCount = self._config._rowCount * self._config._columnCount
  self._ui._chk_defaultSkill:SetShow(false)
end
function PetExchangeSkill:onScreenResize()
  self._panel:ComputePos()
end
function PetExchangeSkill:InitSubPetIndexList(selectIndexTable)
  self._curSubPetRow = 0
  self._subPetIndexList = {}
  self._curShowPetIndexList = {}
  self._subPetIndexList[0] = -1
  self._curShowPetIndexList[0] = 0
  self._subPetTotalCount = 1
  local subPetWrapper, subPetSSW
  local subPetTier = 0
  local totalPetSkillCount = ToClient_getPetEquipSkillMax()
  for i = 1, #selectIndexTable do
    subPetWrapper = ToClient_getPetSealedDataByIndex(selectIndexTable[i])
    subPetSSW = subPetWrapper:getPetStaticStatus()
    subPetTier = subPetSSW:getPetTier() + 1
    local isLearn = false
    if nil ~= subPetWrapper then
      for skillIndex = 0, totalPetSkillCount - 1 do
        isLearn = subPetWrapper:isPetEquipSkillLearned(skillIndex)
        if isLearn then
          break
        end
      end
    end
    if isLearn then
      self._subPetIndexList[self._subPetTotalCount] = selectIndexTable[i]
      self._curShowPetIndexList[self._subPetTotalCount] = i
      self._subPetTotalCount = self._subPetTotalCount + 1
    end
  end
  UIScroll.SetButtonSize(self._ui._scroll_vertical, self._config._subPetSlotCount, self._subPetTotalCount)
end
function PetExchangeSkill:UpdateSkillButton()
  local subPetWrapper
  local subPetTier = -1
  local totalPetSkillCount = ToClient_getPetEquipSkillMax()
  self._ui._stc_randomIcon:SetShow(false)
  for startIndex = 0, self._config._subPetSlotCount - 1 do
    self._ui._chk_skillList[startIndex]:SetShow(false)
    local showIndex = self._curShowStartIndex + startIndex
    if 0 ~= showIndex and nil ~= self._subPetIndexList[showIndex] then
      subPetWrapper = ToClient_getPetSealedDataByIndex(self._subPetIndexList[showIndex])
      if nil ~= subPetWrapper then
        local skillLearnCount = 0
        local skillIconIndex = 0
        for skillIndex = 0, totalPetSkillCount - 1 do
          skillIconIndex = startIndex * self._petSkillCount + skillLearnCount
          local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skillIndex)
          local isLearn = subPetWrapper:isPetEquipSkillLearned(skillIndex)
          if true == isLearn and nil ~= skillStaticStatus then
            local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
            if nil ~= skillTypeStaticWrapper then
              self._ui._stc_skillIconList[skillIconIndex]:ChangeTextureInfoName("Icon/" .. skillTypeStaticWrapper:getIconPath())
              self._ui._stc_skillIconList[skillIconIndex]:setRenderTexture(self._ui._stc_skillIconList[skillIconIndex]:getBaseTexture())
              self._ui._stc_skillIconList[skillIconIndex]:SetText(skillTypeStaticWrapper:getDescription())
              self._ui._stc_skillIconList[skillIconIndex]:SetShow(true)
              self._ui._chk_skillList[startIndex]:SetShow(true)
              self._ui._chk_skillList[startIndex]:SetCheck(false)
              skillLearnCount = skillLearnCount + 1
            end
          end
        end
        if true == self._ui._chk_skillList[startIndex]:GetShow() then
          for slotIndex = 0, self._petSkillCount - skillLearnCount - 1 do
            self._ui._stc_skillIconList[skillIconIndex + slotIndex]:SetShow(false)
          end
        end
      end
    elseif 0 == showIndex then
      self._ui._chk_skillList[startIndex]:SetShow(true)
      self._ui._stc_skillIconList[0]:SetShow(false)
      self._ui._stc_skillIconList[1]:SetShow(false)
      self._ui._stc_skillIconList[2]:SetShow(false)
      self._ui._stc_skillIconList[3]:SetShow(false)
      self._ui._stc_randomIcon:SetShow(true)
    end
  end
end
function PetExchangeSkill:Update()
  self._curShowStartIndex = self._curSubPetRow * self._config._columnCount
  self:UpdateSkillButton()
end
function PetExchangeSkill:CreateSubSkillButton()
  self._ui._stc_buttonGroup = UI.getChildControl(self._ui._stc_centerBG, "Static_ButtonGroup")
  local index = 0
  local posX = 0
  local posY = 0
  for row = 0, self._config._rowCount - 1 do
    for col = 0, self._config._columnCount - 1 do
      index = row * self._config._columnCount + col
      self._ui._chk_skillList[index] = UI.cloneControl(self._ui._chk_defaultSkill, self._ui._stc_buttonGroup, "CheckButton_Skil" .. index)
      local skillIconIndex = index * self._petSkillCount
      self._ui._stc_skillIconList[skillIconIndex] = UI.getChildControl(self._ui._chk_skillList[index], "StaticText_Skill_Info_1")
      self._ui._stc_skillIconList[skillIconIndex + 1] = UI.getChildControl(self._ui._chk_skillList[index], "StaticText_Skill_Info_2")
      self._ui._stc_skillIconList[skillIconIndex + 2] = UI.getChildControl(self._ui._chk_skillList[index], "StaticText_Skill_Info_3")
      self._ui._stc_skillIconList[skillIconIndex + 3] = UI.getChildControl(self._ui._chk_skillList[index], "StaticText_Skill_Info_4")
      posX = self._ui._chk_defaultSkill:GetPosX() + (self._ui._chk_defaultSkill:GetSizeX() + 10) * col
      posY = self._ui._chk_defaultSkill:GetPosY() + (self._ui._chk_defaultSkill:GetSizeY() + 10) * row
      self._ui._chk_skillList[index]:SetPosX(posX)
      self._ui._chk_skillList[index]:SetPosY(posY)
      self._ui._chk_skillList[index]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_PetExchangeSkill_SubPetButtonAUp(" .. index .. ")")
    end
  end
  self._ui._stc_randomIcon = UI.getChildControl(self._ui._chk_skillList[0], "StaticText_RandomLook")
  for col = 0, self._config._columnCount - 1 do
    self._ui._chk_skillList[col]:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_PetExchangeSkill_SubPetButtonDUp()")
  end
  for col = 0, self._config._columnCount - 1 do
    index = (self._config._rowCount - 1) * self._config._columnCount + col
    self._ui._chk_skillList[index]:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_PetExchangeSkill_SubPetButtonDDown()")
  end
end
function PaGlobalFunc_PetExchangeSkill_SubPetButtonDUp()
  local self = PetExchangeSkill
  if self._curSubPetRow <= 0 then
    return
  else
    self._curSubPetRow = self._curSubPetRow - 1
  end
  UIScroll.ScrollEvent(self._ui._scroll_vertical, true, self._config._rowCount, self._subPetTotalCount, self._curSubPetRow, self._config._columnCount)
  self:Update()
end
function PaGlobalFunc_PetExchangeSkill_SubPetButtonDDown()
  local self = PetExchangeSkill
  local rowCount = math.ceil(self._subPetTotalCount / self._config._columnCount)
  if self._curSubPetRow < rowCount - 2 then
    self._curSubPetRow = self._curSubPetRow + 1
    self:Update()
    ToClient_padSnapIgnoreGroupMove()
  end
  UIScroll.ScrollEvent(self._ui._scroll_vertical, false, self._config._rowCount, self._subPetTotalCount, self._curSubPetRow, self._config._columnCount)
end
function PaGlobalFunc_PetExchangeSkill_SubPetButtonAUp(index)
  local self = PetExchangeSkill
  self._panel:SetShow(false)
  local selectIndex = self._curShowStartIndex + index
  PaGlobalFunc_PetExchange_SelectNewSkill(self._curShowPetIndexList[selectIndex], self._subPetIndexList[selectIndex])
end
function PetExchangeSkill:Open(selectIndexTable)
  if true == self._panel:GetShow() then
    return
  end
  self._panel:ignorePadSnapMoveToOtherPanel()
  self:InitSubPetIndexList(selectIndexTable)
  self:Update()
  self._panel:SetShow(true)
end
function PetExchangeSkill:Close()
  self._panel:SetShow(false)
end
function PaGlobalFunc_PetExchangeSkill_Open(selectIndexTable)
  local self = PetExchangeSkill
  self:Open(selectIndexTable)
end
function PaGlobalFunc_PetExchangeSkill_Close()
  local self = PetExchangeSkill
  self:Close()
end
function FromClient_luaLoadComplete_PetExchangeSkill()
  local self = PetExchangeSkill
  self:Initialize()
end
function PaGlobalFunc_PetExchangeSkill_OnScreenResize()
  PetExchangeSkill:onScreenResize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_PetExchangeSkill")
