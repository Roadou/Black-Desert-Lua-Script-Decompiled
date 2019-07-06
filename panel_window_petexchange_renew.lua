Panel_Window_PetExchange_Renew:SetShow(false, false)
local PetExchange = {
  _ui = {
    _stc_mainTitleBG = UI.getChildControl(Panel_Window_PetExchange_Renew, "Static_MainTitleBG"),
    _stc_centerBG = UI.getChildControl(Panel_Window_PetExchange_Renew, "Static_CenterBG"),
    _stc_bottomBG = UI.getChildControl(Panel_Window_PetExchange_Renew, "Static_BottomBG"),
    _stc_bottomKeyBG = UI.getChildControl(Panel_Window_PetExchange_Renew, "Static_BottomKeyBG"),
    _chk_subPetList = {},
    _stc_subPetIconList = {},
    _txt_subPetTierList = {},
    _txt_subPetNameList = {},
    _txt_subPetLevelList = {},
    _stc_selectEffectList = {}
  },
  _config = {
    _rowCount = 2,
    _columnCount = 3,
    _subPetSlotCount = 0
  },
  _tierProgressTextureConfig = {
    [0] = {
      435,
      205,
      458,
      216
    },
    [1] = {
      435,
      217,
      458,
      228
    },
    [2] = {
      435,
      229,
      458,
      240
    },
    [3] = {
      435,
      241,
      458,
      252
    },
    [4] = {
      435,
      241,
      458,
      252
    }
  },
  _colorTable = {
    [0] = Defines.Color.C_FF686868,
    [1] = Defines.Color.C_FF6F6D10,
    [2] = Defines.Color.C_FF3B6491,
    [3] = Defines.Color.C_FFB68827,
    [4] = Defines.Color.C_FFC95A40
  },
  _defaultPetNameCount = 10,
  _defaultPetName = {
    [0] = "Darcy",
    [1] = "Buddy",
    [2] = "Orbit",
    [3] = "Rushmore",
    [4] = "Carolina",
    [5] = "Cindy",
    [6] = "Waffles",
    [7] = "Sparky",
    [8] = "Bailey",
    [9] = "Wichita",
    [10] = "Buck"
  },
  _mainPetIndex = 0,
  _mainPetWrapper = nil,
  _mainPetSSW = nil,
  _mainPetGrade = -1,
  _mainPetTier = -1,
  _mainPetIsJokerPetUse = false,
  _subPetTotalCount = 0,
  _subPetIndexList = {},
  _subPetSelectCount = 0,
  _subPetSelectStateList = {},
  _subPetSelectIndexList = {},
  _curSubPetRow = 0,
  _showStartRow = 0,
  _showStartIndex = 0,
  _newPetName = nil,
  _newAppearanceIndex = -1,
  _selectAppearance = false,
  _newSkillIndex = -1,
  _selectSkill = false,
  _topPetTier = 4,
  _mainPetRate = 0,
  _firstTierRate = 0,
  _secondTierRate = 0,
  _jokerPetIndex = 99,
  _exchangeTargetFirstTier = nil,
  _exchangeTargetSecondTier = nil,
  _keyGuideAlign = {},
  _panel = Panel_Window_PetExchange_Renew
}
function PetExchange:InitControl()
  self._ui._txt_title = UI.getChildControl(self._ui._stc_mainTitleBG, "StaticText_Title")
  self._ui._stc_mainPetSlot = UI.getChildControl(self._ui._stc_centerBG, "Static_MainPetSlot")
  self._ui._stc_mainPetIcon = UI.getChildControl(self._ui._stc_mainPetSlot, "Static_MainPetIcon")
  self._ui._txt_mainPetLevel = UI.getChildControl(self._ui._stc_mainPetSlot, "StaticText_MainPetLevel")
  self._ui._txt_mainPetName = UI.getChildControl(self._ui._stc_mainPetSlot, "StaticText_MainPetName")
  self._ui._txt_mainPetTier = UI.getChildControl(self._ui._stc_mainPetSlot, "StaticText_MainPetTier")
  self._ui._txt_petExchangeDesc = UI.getChildControl(self._ui._stc_centerBG, "StaticText_ExchangeDesc")
  self._ui._txt_curSelectCount = UI.getChildControl(self._ui._stc_centerBG, "StaticText_CurSelectCount")
  self._ui._stc_buttonGroup = UI.getChildControl(self._ui._stc_centerBG, "Static_ButtonGroup")
  self._ui._chk_subPet = UI.getChildControl(self._ui._stc_buttonGroup, "Button_PetIconSlot")
  self._ui._scroll_vertical = UI.getChildControl(self._ui._stc_buttonGroup, "Scroll_VerticalScroll")
  self._ui._btn_selectAppearance = UI.getChildControl(self._ui._stc_bottomBG, "Button_SelectLook")
  self._ui._stc_defaultLookIcon = UI.getChildControl(self._ui._btn_selectAppearance, "Static_AppearanceDefault")
  self._ui._stc_randomLookIcon = UI.getChildControl(self._ui._btn_selectAppearance, "StaticText_RandomLook")
  self._ui._stc_selectLookIcon = UI.getChildControl(self._ui._btn_selectAppearance, "Static_SelectLook")
  self._ui._btn_selectSkill = UI.getChildControl(self._ui._stc_bottomBG, "Button_SelectSkill")
  self._ui._stc_defaultSkill = UI.getChildControl(self._ui._btn_selectSkill, "StaticText_SkillDefault")
  self._ui._stc_randomSkillIcon = UI.getChildControl(self._ui._btn_selectSkill, "StaticText_RandomSkill")
  self._ui._stc_skillIcon = {}
  self._ui._stc_skillIcon[0] = UI.getChildControl(self._ui._btn_selectSkill, "StaticText_Skill_Info_1")
  self._ui._stc_skillIcon[1] = UI.getChildControl(self._ui._btn_selectSkill, "StaticText_Skill_Info_2")
  self._ui._stc_skillIcon[2] = UI.getChildControl(self._ui._btn_selectSkill, "StaticText_Skill_Info_3")
  self._ui._stc_skillIcon[3] = UI.getChildControl(self._ui._btn_selectSkill, "StaticText_Skill_Info_4")
  self._ui._edit_newPetName = UI.getChildControl(self._ui._stc_bottomBG, "Edit_NewPetName")
  self._ui._txt_petNameDesc = UI.getChildControl(self._ui._edit_newPetName, "StaticText_PetNameDesc")
  self._ui._txt_newPetName = UI.getChildControl(self._ui._edit_newPetName, "StaticText_NewPetName")
  self._ui._progress_firstTier = UI.getChildControl(self._ui._stc_bottomBG, "Static_Progress_FirstTier")
  self._ui._firstTierBar = UI.getChildControl(self._ui._progress_firstTier, "Progress2_1")
  self._ui._txt_firstTier = UI.getChildControl(self._ui._progress_firstTier, "StaticText_FirstTier")
  self._ui._txt_firstTierPercent = UI.getChildControl(self._ui._progress_firstTier, "StaticText_FirstTier_Percent")
  self._ui._progress_secondTier = UI.getChildControl(self._ui._stc_bottomBG, "Static_Progress_SecondTier")
  self._ui._secondTierBar = UI.getChildControl(self._ui._progress_secondTier, "Progress2_1")
  self._ui._txt_secondTier = UI.getChildControl(self._ui._progress_secondTier, "StaticText_SecondTier")
  self._ui._txt_secondTierPercent = UI.getChildControl(self._ui._progress_secondTier, "StaticText_SecondTier_Percent")
  self._ui._btn_exchange = UI.getChildControl(self._ui._stc_bottomKeyBG, "StaticText_Exchange_ConsoleUI")
  self._ui._btn_select = UI.getChildControl(self._ui._stc_bottomKeyBG, "StaticText_Confirm_ConsoleUI")
  self._ui._btn_close = UI.getChildControl(self._ui._stc_bottomKeyBG, "StaticText_Cancel_ConsoleUI")
  self._keyGuideAlign = {
    self._ui._btn_exchange,
    self._ui._btn_select,
    self._ui._btn_close
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._stc_bottomKeyBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PetExchange:RegistEventHandler()
  self._panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_PetExchange_ExchangeConfirm()")
  if true == ToClient_isConsole() and false == ToClient_IsDevelopment() then
    self._ui._edit_newPetName:setXboxVirtualKeyBoardEndEvent("PaGlobalFunc_PetExchange_EndVirtualKeyBoard")
  else
    self._ui._edit_newPetName:RegistReturnKeyEvent("PaGlobalFunc_PetExchange_EndVirtualKeyBoard()")
  end
  self._panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_PetExchange_EditControlXUp()")
  self._ui._btn_selectAppearance:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_PetExchange_AppearanceButtonAUp()")
  self._ui._btn_selectSkill:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_PetExchange_SkillButtonAUp()")
  registerEvent("FromClient_PetFusionResult", "FromClient_PetExchange_PetFusionResult")
  registerEvent("FromClient_FusionComplete", "FromClient_PetExchange_FusionComplete")
  registerEvent("onScreenResize", "PaGlobalFunc_PetExchange_OnScreenResize")
end
function PetExchange:Initialize()
  self:InitControl()
  self:CreateSubPetButton()
  self:RegistEventHandler()
  self._config._subPetSlotCount = self._config._rowCount * self._config._columnCount
  self._ui._txt_petNameDesc:SetColor(Defines.Color.C_FF626262)
  self._ui._txt_mainPetName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui._txt_mainPetName:SetText(self._ui._txt_mainPetName:GetText())
  self._ui._chk_subPet:SetShow(false)
  self:onScreenResize()
end
function PetExchange:InitSubPetIndexList()
  local sealPetCount = ToClient_getPetSealedList()
  if sealPetCount <= 0 then
    return
  end
  local subPetSSW
  local subPetGrade = -1
  local subPetNo = -1
  local subPetTier = -1
  local subPetRace
  for subPetIndex = 0, sealPetCount - 1 do
    subPetSSW = ToClient_getPetSealedDataByIndex(subPetIndex):getPetStaticStatus()
    subPetGrade = ToClient_getGrade(subPetSSW:getPetRace(), subPetSSW:getPetKind())
    subPetTier = subPetSSW:getPetTier() + 1
    subPetRace = subPetSSW:getPetRace()
    local isCombinable = subPetGrade == self._mainPetGrade and subPetTier <= self._mainPetTier and subPetIndex ~= self._mainPetIndex
    local isJokerPetUse = true == self._mainPetIsJokerPetUse and self._jokerPetIndex == subPetRace
    if isCombinable or isJokerPetUse then
      self._subPetIndexList[self._subPetTotalCount] = subPetIndex
      self._subPetSelectStateList[self._subPetTotalCount] = false
      self._subPetTotalCount = self._subPetTotalCount + 1
    end
  end
  self._ui._txt_curSelectCount:SetText(tostring(self._subPetSelectCount) .. " / " .. tostring(self._subPetTotalCount))
  UIScroll.SetButtonSize(self._ui._scroll_vertical, self._config._subPetSlotCount, self._subPetTotalCount)
  self._ui._scroll_vertical:SetControlTop()
end
function PetExchange:UpdateSubPetButton()
  local subPetWrapper, subPetSSW
  local subPetTier = -1
  for startIndex = 0, self._config._subPetSlotCount - 1 do
    subPetWrapper = nil
    self._ui._chk_subPetList[startIndex]:SetShow(false)
    local showIndex = self._showStartIndex + startIndex
    if nil ~= self._subPetIndexList[showIndex] then
      subPetWrapper = ToClient_getPetSealedDataByIndex(self._subPetIndexList[showIndex])
    end
    if nil ~= subPetWrapper then
      subPetWrapper = ToClient_getPetSealedDataByIndex(self._subPetIndexList[showIndex])
      subPetTier = subPetWrapper:getPetStaticStatus():getPetTier() + 1
      self._ui._stc_subPetIconList[startIndex]:ChangeTextureInfoNameAsync(subPetWrapper:getIconPath())
      self._ui._txt_subPetTierList[startIndex]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETLIST_TIER_SHORT", "tier", subPetTier))
      self._ui._txt_subPetTierList[startIndex]:SetColor(self._colorTable[subPetTier - 1])
      self._ui._txt_subPetNameList[startIndex]:SetText(subPetWrapper:getName())
      self._ui._txt_subPetLevelList[startIndex]:SetText("Lv. " .. tostring(subPetWrapper._level))
      self._ui._chk_subPetList[startIndex]:SetShow(true)
      if self._subPetSelectStateList[showIndex] == true then
        self._ui._stc_selectEffectList[startIndex]:SetShow(true)
      else
        self._ui._stc_selectEffectList[startIndex]:SetShow(false)
      end
    end
  end
  PaGlobalFunc_PetExchange_SelectNewAppearance(1, self._mainPetIndex)
end
function PetExchange:Update()
  self._showStartIndex = self._curSubPetRow * self._config._columnCount
  self:UpdateSubPetButton()
  self:UpdateProgressBar()
end
function PetExchange:UpdateProgressBar()
  local subPetWrapper, subPetSSW
  local rateToAdd = 0
  for index = 0, self._subPetSelectCount - 1 do
    subPetWrapper = ToClient_getPetSealedDataByIndex(self._subPetSelectIndexList[index + 2])
    subPetSSW = subPetWrapper:getPetStaticStatus()
    if nil ~= subPetSSW then
      local subPetTier = subPetSSW:getPetTier()
      local subPetRace = subPetSSW:getPetRace()
      rateToAdd = rateToAdd + Int64toInt32(ToClient_getAddFusionRate(self._mainPetTier - 1, subPetTier, subPetRace)) / 10000
    end
  end
  local rateSum = math.min(100, self._mainPetRate + rateToAdd)
  rateSum = math.floor(rateSum + 0.5)
  self._firstTierRate = 100 - rateSum
  self._secondTierRate = rateSum
  self:SetProgressBarColor(self._ui._firstTierBar, self._exchangeTargetFirstTier)
  if nil ~= self._exchangeTargetSecondTier then
    self._ui._firstTierBar:SetProgressRate(self._firstTierRate)
    self._ui._txt_firstTierPercent:SetText(self._firstTierRate .. "%")
    self:SetProgressBarColor(self._ui._secondTierBar, self._exchangeTargetSecondTier)
    self._ui._secondTierBar:SetProgressRate(self._secondTierRate)
    self._ui._txt_secondTierPercent:SetText(self._secondTierRate .. "%")
  else
    self._ui._firstTierBar:SetProgressRate(self._secondTierRate)
    self._ui._txt_firstTierPercent:SetText(self._secondTierRate .. "%")
  end
end
function PetExchange:onScreenResize()
  Panel_Window_PetExchange_Renew:ComputePos()
end
function PetExchange:SetProgressBarColor(progressBar, Tier)
  progressBar:ChangeTextureInfoName("renewal/progress/console_progressbar_02.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(progressBar, self._tierProgressTextureConfig[Tier - 1][1], self._tierProgressTextureConfig[Tier - 1][2], self._tierProgressTextureConfig[Tier - 1][3], self._tierProgressTextureConfig[Tier - 1][4])
  progressBar:getBaseTexture():setUV(x1, y1, x2, y2)
end
function PaGlobalFunc_PetExchange_OnScreenResize()
  PetExchange:onScreenResize()
end
function PaGlobalFunc_PetExchange_SubPetButtonDUp()
  local self = PetExchange
  local listRowCount = math.ceil(self._subPetTotalCount / self._config._columnCount)
  if self._curSubPetRow <= 0 then
    return
  else
    UIScroll.ScrollEvent(self._ui._scroll_vertical, true, self._config._rowCount, listRowCount, self._curSubPetRow, 1)
    self._curSubPetRow = self._curSubPetRow - 1
  end
  self:Update()
end
function PaGlobalFunc_PetExchange_SubPetButtonDDown()
  local self = PetExchange
  local rowCount = math.ceil(self._subPetTotalCount / self._config._columnCount)
  if self._curSubPetRow < rowCount - 2 then
    UIScroll.ScrollEvent(self._ui._scroll_vertical, false, self._config._rowCount, rowCount, self._curSubPetRow, 1)
    self._curSubPetRow = self._curSubPetRow + 1
    self:Update()
    ToClient_padSnapIgnoreGroupMove()
  end
end
function PaGlobalFunc_PetExchange_SubPetButtonAUp(index)
  local self = PetExchange
  local selectIndex = self._showStartIndex + index
  if false == self._subPetSelectStateList[selectIndex] then
    if 4 <= self._subPetSelectCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETEXCHANGE_FULLGAUGE"))
      return
    end
    if 100 <= self._secondTierRate and nil ~= self._exchangeTargetSecondTier then
      self._ui._stc_selectEffectList[index]:SetShow(false)
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETEXCHANGE_FULLGAUGE"))
      return
    end
    self._ui._stc_selectEffectList[index]:SetShow(true)
    self._subPetSelectStateList[selectIndex] = true
    self:UpdateSelectIndexList()
  else
    self._ui._stc_selectEffectList[index]:SetShow(false)
    self:ReleaseSelectData()
    self._subPetSelectStateList[selectIndex] = false
    self:UpdateSelectIndexList()
  end
  self._ui._txt_curSelectCount:SetText(tostring(self._subPetSelectCount) .. " / " .. tostring(self._subPetTotalCount))
  self:UpdateProgressBar()
end
function PaGlobalFunc_PetExchange_SubPetButtonMOut(index)
  local self = PetExchange
  local selectIndex = self._showStartIndex + index
end
function PaGlobalFunc_PetExchange_AppearanceButtonAUp()
  local self = PetExchange
  if 1 > self._subPetSelectCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_REGIST"))
    return
  end
  PaGlobalFunc_PetExchangeAppearance_Open(self._subPetSelectIndexList)
end
function PaGlobalFunc_PetExchange_SelectNewAppearance(index, petIndex)
  local self = PetExchange
  self._selectAppearance = true
  self._newAppearanceIndex = index
  if -1 == petIndex then
    self._ui._stc_defaultLookIcon:SetShow(false)
    self._ui._stc_selectLookIcon:SetShow(false)
    self._ui._stc_randomLookIcon:SetShow(true)
    return
  end
  local subPetWrapper = ToClient_getPetSealedDataByIndex(petIndex)
  if nil == subPetWrapper then
    return
  end
  self._ui._stc_selectLookIcon:ChangeTextureInfoNameAsync(subPetWrapper:getIconPath())
  self._ui._stc_selectLookIcon:SetShow(true)
  self._ui._stc_randomLookIcon:SetShow(false)
  self._ui._stc_defaultLookIcon:SetShow(false)
end
function PaGlobalFunc_PetExchange_SkillButtonAUp()
  local self = PetExchange
  if 1 > self._subPetSelectCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_REGIST"))
    return
  end
  PaGlobalFunc_PetExchangeSkill_Open(self._subPetSelectIndexList)
end
function PaGlobalFunc_PetExchange_SelectNewSkill(index, petIndex)
  local self = PetExchange
  self._selectSkill = true
  self._newSkillIndex = index
  self._ui._stc_randomSkillIcon:SetShow(false)
  self._ui._stc_defaultSkill:SetShow(false)
  self._ui._stc_skillIcon[0]:SetShow(false)
  self._ui._stc_skillIcon[1]:SetShow(false)
  self._ui._stc_skillIcon[2]:SetShow(false)
  self._ui._stc_skillIcon[3]:SetShow(false)
  if -1 == petIndex then
    self._ui._stc_randomSkillIcon:SetShow(true)
    return
  end
  local subPetWrapper = ToClient_getPetSealedDataByIndex(petIndex)
  if nil == subPetWrapper then
    return
  end
  local totalPetSkillCount = ToClient_getPetEquipSkillMax()
  local skillLearnCount = 0
  for skillIndex = 0, totalPetSkillCount - 1 do
    local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skillIndex)
    local isLearn = subPetWrapper:isPetEquipSkillLearned(skillIndex)
    if true == isLearn and nil ~= skillStaticStatus then
      local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
      if nil ~= skillTypeStaticWrapper then
        self._ui._stc_skillIcon[skillLearnCount]:ChangeTextureInfoName("Icon/" .. skillTypeStaticWrapper:getIconPath())
        self._ui._stc_skillIcon[skillLearnCount]:setRenderTexture(self._ui._stc_skillIcon[skillLearnCount]:getBaseTexture())
        self._ui._stc_skillIcon[skillLearnCount]:SetText(skillTypeStaticWrapper:getDescription())
        self._ui._stc_skillIcon[skillLearnCount]:SetShow(true)
        skillLearnCount = skillLearnCount + 1
      end
    end
  end
end
function PaGlobalFunc_PetExchange_EditControlXUp()
  local self = PetExchange
  self:SetFocusNameEdit()
end
function PetExchange:SetFocusNameEdit()
  local randomName
  randomName = self._defaultPetName[math.random(0, self._defaultPetNameCount)]
  ClearFocusEdit()
  self._ui._txt_petNameDesc:SetShow(false)
  self._ui._edit_newPetName:SetEditText(randomName, true)
  self._ui._edit_newPetName:SetMaxInput(getGameServiceTypePetNameLength())
  SetFocusEdit(self._ui._edit_newPetName)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
end
function PetExchange:ClearFocusNameEdit()
  self._ui._edit_newPetName:SetEditText("", true)
  ClearFocusEdit()
end
function PaGlobalFunc_PetExchange_EndVirtualKeyBoard(str)
  local self = PetExchange
  if nil == str then
    local newName = self._ui._edit_newPetName:GetEditText()
    self._newPetName = newName
  else
    self._newPetName = str
  end
  self._ui._edit_newPetName:SetEditText(self._newPetName, true)
  ClearFocusEdit()
  self._ui._edit_newPetName:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_PetExchange_EditControlXUp()")
end
function PaGlobalFunc_PetExchange_ExchangeConfirm()
  local self = PetExchange
  self:ExchangeConfirm()
end
function PetExchange:ExchangeConfirm()
  if 0 == self._subPetSelectCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_REGIST"))
    return
  elseif "" == self._ui._edit_newPetName:GetEditText() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PETEXCHANGE_NAMEDESC"))
    return
  elseif false == self._selectAppearance then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETEXCHANGE_LOOKDESC"))
    return
  elseif false == self._selectSkill then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETEXCHANGE_SKILLDESC"))
    return
  end
  local mainPetNo = ToClient_getPetSealedDataByIndex(self._mainPetIndex)._petNo
  ToClient_pushFusionPetList(mainPetNo, 0)
  local count = 1
  local petNo = 0
  for index = 0, self._subPetTotalCount - 1 do
    if true == self._subPetSelectStateList[index] then
      petNo = ToClient_getPetSealedDataByIndex(self._subPetIndexList[index])._petNo
      ToClient_pushFusionPetList(petNo, count)
      count = count + 1
    end
  end
  local skillIndex, appearanceIndex
  if 0 == self._newSkillIndex then
    skillIndex = -1
  else
    skillIndex = self._newSkillIndex - 1
  end
  if 0 == self._newAppearanceIndex then
    appearanceIndex = -1
  else
    appearanceIndex = self._newAppearanceIndex - 1
  end
  ToClient_requestPetFusion(self._ui._edit_newPetName:GetEditText(), skillIndex, appearanceIndex)
  self:Close()
end
function PetExchange:UpdateSelectIndexList()
  local listIndex = 2
  self._subPetSelectCount = 0
  self._subPetSelectIndexList = {}
  self._subPetSelectIndexList[0] = -1
  self._subPetSelectIndexList[1] = self._mainPetIndex
  for i = 0, #self._subPetIndexList do
    if true == self._subPetSelectStateList[i] then
      self._subPetSelectIndexList[listIndex] = self._subPetIndexList[i]
      self._subPetSelectCount = self._subPetSelectCount + 1
      listIndex = listIndex + 1
    end
  end
end
function PetExchange:InitMainSlot()
  self._mainPetWrapper = ToClient_getPetSealedDataByIndex(self._mainPetIndex)
  self._mainPetSSW = self._mainPetWrapper:getPetStaticStatus()
  self._mainPetGrade = ToClient_getGrade(self._mainPetSSW:getPetRace(), self._mainPetSSW:getPetKind())
  self._mainPetTier = self._mainPetSSW:getPetTier() + 1
  self._mainPetRate = Int64toInt32(ToClient_getMainFusionRate(self._mainPetTier - 1)) / 10000
  self._mainPetIsJokerPetUse = self._mainPetSSW._isJokerPetUse
  local mainPetLevel = self._mainPetWrapper._level
  local mainPetName = self._mainPetWrapper:getName()
  self._ui._stc_mainPetIcon:ChangeTextureInfoNameAsync(self._mainPetWrapper:getIconPath())
  self._ui._txt_mainPetName:SetText(mainPetName)
  self._ui._txt_mainPetLevel:SetText("Lv. " .. tostring(mainPetLevel))
  self._ui._txt_mainPetTier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PET_TIER", "tier", self._mainPetTier))
  self._ui._txt_mainPetTier:SetColor(self._colorTable[self._mainPetTier - 1])
  if self._topPetTier == self._mainPetTier then
    self._exchangeTargetFirstTier = self._topPetTier
    self._exchangeTargetSecondTier = nil
  elseif 1 == self._mainPetTier then
    self._exchangeTargetFirstTier = 2
    self._exchangeTargetSecondTier = 3
  else
    self._exchangeTargetFirstTier = self._mainPetTier
    self._exchangeTargetSecondTier = self._mainPetTier + 1
  end
  self._ui._progress_firstTier:SetShow(true)
  self._ui._txt_firstTier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PET_TIER", "tier", self._exchangeTargetFirstTier))
  self._ui._txt_firstTierPercent:SetFontColor(self._colorTable[self._exchangeTargetFirstTier - 1])
  self._ui._txt_firstTier:SetFontColor(self._colorTable[self._exchangeTargetFirstTier - 1])
  self:SetProgressBarColor(self._ui._firstTierBar, self._exchangeTargetFirstTier)
  if nil == self._exchangeTargetSecondTier then
    self._ui._progress_secondTier:SetShow(false)
  else
    self._ui._progress_secondTier:SetShow(true)
    self._ui._txt_secondTier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PET_TIER", "tier", self._exchangeTargetSecondTier))
    self._ui._txt_secondTierPercent:SetFontColor(self._colorTable[self._exchangeTargetSecondTier - 1])
    self._ui._txt_secondTier:SetFontColor(self._colorTable[self._exchangeTargetSecondTier - 1])
    self:SetProgressBarColor(self._ui._secondTierBar, self._exchangeTargetSecondTier)
  end
end
function PetExchange:CreateSubPetButton()
  self._ui._stc_buttonGroup = UI.getChildControl(self._ui._stc_centerBG, "Static_ButtonGroup")
  local index = 0
  local posX = 0
  local posY = 0
  for row = 0, self._config._rowCount - 1 do
    for col = 0, self._config._columnCount - 1 do
      index = row * self._config._columnCount + col
      self._ui._chk_subPetList[index] = UI.cloneControl(self._ui._chk_subPet, self._ui._stc_buttonGroup, "Button_PetIconSlot" .. index)
      self._ui._stc_subPetIconList[index] = UI.getChildControl(self._ui._chk_subPetList[index], "Static_SubPetIcon")
      self._ui._txt_subPetTierList[index] = UI.getChildControl(self._ui._chk_subPetList[index], "StaticText_SubPetTier")
      self._ui._txt_subPetNameList[index] = UI.getChildControl(self._ui._chk_subPetList[index], "StaticText_SubPetName")
      self._ui._txt_subPetLevelList[index] = UI.getChildControl(self._ui._chk_subPetList[index], "StaticText_SubPetLevel")
      self._ui._stc_selectEffectList[index] = UI.getChildControl(self._ui._chk_subPetList[index], "Static_Selected")
      posX = self._ui._chk_subPet:GetPosX() + (self._ui._chk_subPet:GetSizeX() + 6) * col
      posY = self._ui._chk_subPet:GetPosY() + (self._ui._chk_subPet:GetSizeY() + 6) * row
      self._ui._chk_subPetList[index]:SetPosX(posX)
      self._ui._chk_subPetList[index]:SetPosY(posY)
      self._ui._txt_subPetNameList[index]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
      self._ui._txt_subPetNameList[index]:SetText(self._ui._txt_subPetNameList[index]:GetText())
      self._ui._chk_subPetList[index]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_PetExchange_SubPetButtonAUp(" .. index .. ")")
      self._ui._chk_subPetList[index]:addInputEvent("Mouse_Out", "PaGlobalFunc_PetExchange_SubPetButtonMOut(" .. index .. ")")
    end
  end
  for col = 0, self._config._columnCount - 1 do
    self._ui._chk_subPetList[col]:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_PetExchange_SubPetButtonDUp()")
  end
  for col = 0, self._config._columnCount - 1 do
    index = (self._config._rowCount - 1) * self._config._columnCount + col
    self._ui._chk_subPetList[index]:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_PetExchange_SubPetButtonDDown()")
  end
end
function FGlobal_CheckEditBox_PetCompose(uiEditBox)
  local self = PetExchange
  return nil ~= uiEditBox and nil ~= self._ui._edit_newPetName and uiEditBox:GetKey() == self._ui._edit_newPetName:GetKey()
end
function PaGlobalFunc_PetExchange_GetMainPetIndex()
  local self = PetExchange
  return self._mainPetIndex
end
function PetExchange:ReleaseSelectData()
  self._newAppearanceIndex = -1
  self._selectAppearance = false
  self._newSkillIndex = -1
  self._selectSkill = false
  self._ui._stc_selectLookIcon:SetShow(false)
  self._ui._stc_randomLookIcon:SetShow(false)
  self._ui._stc_defaultLookIcon:SetShow(true)
  self._ui._stc_defaultSkill:SetShow(true)
  self._ui._stc_randomSkillIcon:SetShow(false)
  self._ui._stc_skillIcon[0]:SetShow(false)
  self._ui._stc_skillIcon[1]:SetShow(false)
  self._ui._stc_skillIcon[2]:SetShow(false)
  self._ui._stc_skillIcon[3]:SetShow(false)
end
function PetExchange:ClearData()
  self._subPetTotalCount = 0
  self._subPetIndexList = {}
  self._curSubPetRow = 0
  self._subPetSelectCount = 0
  self._subPetSelectStateList = {}
  self._newPetName = nil
  self._ui._edit_newPetName:SetEditText("", true)
  self._ui._txt_petNameDesc:SetShow(true)
  self:ClearFocusNameEdit()
  self:ReleaseSelectData()
end
function PaGlobalFunc_PetExchange_Open(selectPetNoStr)
  if nil == selectPetNoStr or "" == selectPetNoStr then
    return
  end
  local self = PetExchange
  self:Open(selectPetNoStr)
end
function PetExchange:Open(selectPetNoStr)
  if true == self._panel:GetShow() then
    return
  end
  self:ClearData()
  self._mainPetIndex = selectPetNoStr
  self:InitMainSlot()
  self:InitSubPetIndexList()
  self:Update()
  self._panel:SetShow(true)
end
function PetExchange:Close()
  self._panel:SetShow(false)
  self._panel:CloseUISubApp()
  UI.ClearFocusEdit()
  PaGlobalFunc_PetExchangeSkill_Close()
  PaGlobalFunc_PetExchangeAppearance_Close()
  PaGlobalFunc_Petlist_TemporaryOpen()
end
function PetExchange:CloseGlobal()
  self._panel:SetShow(false)
  self._panel:CloseUISubApp()
  UI.ClearFocusEdit()
  PaGlobalFunc_PetExchangeSkill_Close()
  PaGlobalFunc_PetExchangeAppearance_Close()
end
function FromClient_PetExchange_FusionComplete(petNo)
end
function FromClient_PetExchange_PetFusionResult(rv)
  if 0 ~= rv then
  end
end
function PaGlobalFunc_PetExchange_Close()
  local self = PetExchange
  self:Close()
end
function PaGlobalFunc_PetExchange_Close_Global()
  local self = PetExchange
  self:CloseGlobal()
end
function FromClient_luaLoadComplete_PetExchange()
  local self = PetExchange
  self:Initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_PetExchange")
