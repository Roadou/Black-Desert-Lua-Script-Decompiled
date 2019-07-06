local _panel = Panel_Window_QuestBranch
local _questType = {
  calpheon = 0,
  media = 1,
  blackStar = 2
}
local isClearedQuestList = {
  [_questType.calpheon] = {questGroupNo = 21003, questNo = 10},
  [_questType.media] = {questGroupNo = 21403, questNo = 6},
  [_questType.blackStar] = {questGroupNo = 3408, questNo = 8}
}
local questData = {
  [_questType.calpheon] = {
    [0] = {
      questTitle = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_CALPHEON_1"),
      bottomDesc = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_CALPHEON_DESC_1"),
      bottomDialog = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_CALPHEON_DIALOG_1"),
      texturePath = "Icon/Quest/questBranch_21004_1.dds",
      texturePathClear = "Icon/Quest/questBranch_21004_1_clear.dds",
      startGroupNo = 21004,
      startQuestNo = 1,
      clearQuestGroupNo = 21100,
      clearQuestNo = 4,
      clearQuestGroupNo_2 = 21101,
      clearQuestNo_2 = 4,
      spanSizeX = -330,
      branchcleared = false
    },
    [1] = {
      questTitle = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_CALPHEON_2"),
      bottomDesc = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_CALPHEON_DESC_2"),
      bottomDialog = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_CALPHEON_DIALOG_2"),
      texturePath = "Icon/Quest/questBranch_21201_1.dds",
      texturePathClear = "Icon/Quest/questBranch_21201_1_clear.dds",
      startGroupNo = 21201,
      startQuestNo = 1,
      clearQuestGroupNo = 21100,
      clearQuestNo = 5,
      clearQuestGroupNo_2 = 21101,
      clearQuestNo_2 = 4,
      spanSizeX = 0,
      branchcleared = false
    },
    [2] = {
      questTitle = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_CALPHEON_3"),
      bottomDesc = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_CALPHEON_DESC_3"),
      bottomDialog = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_CALPHEON_DIALOG_3"),
      texturePath = "Icon/Quest/questBranch_21301_1.dds",
      texturePathClear = "Icon/Quest/questBranch_21301_1_clear.dds",
      startGroupNo = 21301,
      startQuestNo = 1,
      clearQuestGroupNo = 21101,
      clearQuestNo = 8,
      clearQuestGroupNo_2 = nil,
      clearQuestNo_2 = nil,
      spanSizeX = 330,
      branchcleared = false
    },
    ["_branchCount"] = 3,
    ["_completeQuestGroupNo"] = 21108,
    ["_completeQuestNo"] = 1,
    ["_contentConsole"] = true
  },
  [_questType.media] = {
    [0] = {
      questTitle = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_MEDIA_1"),
      bottomDesc = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_MEDIA_DESC_1"),
      bottomDialog = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_MEDIA_DIALOG_1"),
      texturePath = "Icon/Quest/questBranch_21404_1.dds",
      texturePathClear = "Icon/Quest/questBranch_21404_1_clear.dds",
      startGroupNo = 21404,
      startQuestNo = 1,
      clearQuestGroupNo = 21100,
      clearQuestNo = 4,
      spanSizeX = -175,
      branchcleared = false
    },
    [1] = {
      questTitle = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_MEDIA_2"),
      bottomDesc = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_MEDIA_DESC_2"),
      bottomDialog = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_MEDIA_DIALOG_2"),
      texturePath = "Icon/Quest/questBranch_21501_1.dds",
      texturePathClear = "Icon/Quest/questBranch_21501_1_clear.dds",
      startGroupNo = 21501,
      startQuestNo = 1,
      clearQuestGroupNo = 21100,
      clearQuestNo = 5,
      spanSizeX = 175,
      branchcleared = false
    },
    ["_branchCount"] = 2,
    ["_contentConsole"] = true
  },
  [_questType.blackStar] = {
    [0] = {
      questTitle = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_BLACKSTAREQUIP_1"),
      bottomDesc = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_BLACKSTAREQUIP_DESC_1"),
      bottomDialog = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_BLACKSTAREQUIP_DIALOG_1"),
      texturePath = "Icon/Quest/questBranch_3408_9.dds",
      texturePathClear = "Icon/Quest/questBranch_3408_9_clear.dds",
      startGroupNo = 3408,
      startQuestNo = 9,
      clearQuestGroupNo = 3408,
      clearQuestNo = 9,
      spanSizeX = -175,
      branchcleared = false
    },
    [1] = {
      questTitle = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_BLACKSTAREQUIP_2"),
      bottomDesc = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_BLACKSTAREQUIP_DESC_2"),
      bottomDialog = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_BLACKSTAREQUIP_DIALOG_2"),
      texturePath = "Icon/Quest/questBranch_3417_1.dds",
      texturePathClear = "Icon/Quest/questBranch_3417_1_clear.dds",
      startGroupNo = 3417,
      startQuestNo = 1,
      clearQuestGroupNo = 3417,
      clearQuestNo = 5,
      spanSizeX = 175,
      branchcleared = false
    },
    ["_branchCount"] = 2,
    ["_contentConsole"] = false
  }
}
local questBranch = {
  _ui = {
    _stc_BranchMiddleGroup = UI.getChildControl(Panel_Window_QuestBranch, "Static_QuestBranchMiddleGroup"),
    _stc_BranchBottomGroup = UI.getChildControl(Panel_Window_QuestBranch, "Static_QuestBranchBottomGroup"),
    _stc_BranchTitle = UI.getChildControl(Panel_Window_QuestBranch, "Static_BranchDeco"),
    _radiobtn = {},
    _radioImg = {},
    _radioTxt = {}
  },
  _selectedQuestBranch = nil,
  _selectedQuestType = 0,
  _originalPanelSizeY = 700,
  _originalPanelPosY = 150,
  _questTypeCount = 0,
  _currentBranchCount = nil,
  _currentBranchIndex = 0,
  _savePanelSizeY = Panel_Window_QuestBranch:GetSizeY()
}
function questBranch:init()
  local count = 0
  for k, v in pairs(questData) do
    if false == ToClient_isConsole() then
      count = count + 1
    elseif true == questData[k]._contentConsole then
      count = count + 1
    end
  end
  questBranch._questTypeCount = count
  self._ui._txt_bottomDesc = UI.getChildControl(self._ui._stc_BranchMiddleGroup, "StaticText_BranchBottomDesc")
  self._ui._txt_bottomDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_bottomDialog = UI.getChildControl(self._ui._stc_BranchMiddleGroup, "StaticText_BranchBottomDialog")
  self._ui._txt_bottomDialog:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_bottomDialog:SetAutoResize(true)
  self._ui._btn_cancel = UI.getChildControl(self._ui._stc_BranchBottomGroup, "Button_Cancel")
  self._ui._btn_selectBranch = UI.getChildControl(self._ui._stc_BranchBottomGroup, "Button_SelectBranch")
  self._ui._stc_keyGuide_selectBranch = UI.getChildControl(self._ui._stc_BranchBottomGroup, "StaticText_SelectBranch")
  self._ui._stc_keyGuide_leftShoulder = UI.getChildControl(self._ui._stc_BranchBottomGroup, "Static_LB")
  self._ui._stc_keyGuide_rightShoulder = UI.getChildControl(self._ui._stc_BranchBottomGroup, "Static_RB")
  if false == ToClient_isConsole() then
    self._ui._stc_keyGuide_selectBranch:SetShow(false)
    self._ui._stc_keyGuide_leftShoulder:SetShow(false)
    self._ui._stc_keyGuide_rightShoulder:SetShow(false)
  else
    self._ui._btn_cancel:SetShow(false)
    self._ui._btn_selectBranch:SetShow(false)
    self._ui._stc_keyGuide_selectBranch:SetShow(true)
    self._ui._stc_keyGuide_leftShoulder:SetShow(true)
    self._ui._stc_keyGuide_rightShoulder:SetShow(true)
    self._currentBranchIndex = 0
  end
  self._ui._radio = UI.getChildControl(self._ui._stc_BranchMiddleGroup, "Radiobutton_Branch_Templete")
  self._ui._radio:SetShow(false)
  self._selectedTab = nil
  self._prevSelectedTab = 0
  self._isPlayEffect = {}
  for index = 0, 3 do
    self._ui._radiobtn[index] = UI.createAndCopyBasePropertyControl(self._ui._stc_BranchMiddleGroup, "Radiobutton_Branch_Templete", self._ui._stc_BranchMiddleGroup, "QuestBranch_Radio_" .. index)
    self._ui._radioImg[index] = UI.createAndCopyBasePropertyControl(self._ui._radio, "Static_Branch_Img_Templete", self._ui._radiobtn[index], "QuestBranch_RadioImg_" .. index)
    self._ui._radioTxt[index] = UI.createAndCopyBasePropertyControl(self._ui._radio, "StaticText_Branch_Title_Templete", self._ui._radiobtn[index], "QuestBranch_RadioTxt" .. index)
    self._ui._radioTxt[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui._radiobtn[index]:SetShow(false)
    self._isPlayEffect[index] = false
  end
  self._ui._txt_bottomDialog:SetPosY(self._ui._radiobtn[0]:GetPosY() + self._ui._radiobtn[0]:GetSizeY() + 10)
  self._ui._txt_bottomDesc:SetPosY(self._ui._txt_bottomDialog:GetPosY() + self._ui._txt_bottomDialog:GetSizeY() + 10)
  self:checkQuestBranch()
  self:resizePanel()
  self:registEventHandler()
end
function questBranch:registEventHandler()
  if false == ToClient_isConsole() then
    self._ui._btn_cancel:addInputEvent("Mouse_LUp", "PaGlobal_questBranch_Close()")
    self._ui._btn_selectBranch:addInputEvent("Mouse_LUp", "InputMLUp_questBranch_ApplyBtn()")
    for index = 0, 3 do
      self._ui._radiobtn[index]:addInputEvent("Mouse_LUp", "InputMLUp_questBranch_SelectedBtn(" .. index .. ")")
    end
  else
    Panel_Window_QuestBranch:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_QuestBranch_PadControl(true)")
    Panel_Window_QuestBranch:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_QuestBranch_PadControl(false)")
    Panel_Window_QuestBranch:registerPadEvent(__eConsoleUIPadEvent_Up_A, "InputMLUp_questBranch_ApplyBtn()")
  end
  registerEvent("FromClient_UpdateQuestList", "PaGlobal_questBranch_IsQuestBranch")
  registerEvent("onScreenResize", "PaGlobal_questBranch_ResizePanel")
  registerEvent("FromClient_FindedLeafQuest", "PaGlobal_FromClient_FindedLeafQuest")
end
function questBranch:open()
  self._currentBranchCount = questData[self._selectedQuestType]._branchCount
  self:resizePanel()
  self:settingControl()
  self:OpenShowAni()
  if true == ToClient_isConsole() then
    close_WindowPanelList()
    InputMLUp_questBranch_SelectedBtn(0)
  end
  _panel:SetShow(true)
end
function questBranch:close()
  _panel:SetShow(false)
end
function questBranch:resizePanel()
  local screenX, screenY
  screenX = getScreenSizeX()
  screenY = getScreenSizeY()
  local consoleGabY = 0
  if true == ToClient_isConsole() then
    consoleGabY = 20
  end
  if screenY <= self._originalPanelSizeY + 20 then
    _panel:SetPosY(30 - consoleGabY)
    _panel:SetSize(screenX, self._savePanelSizeY + consoleGabY)
  elseif screenY <= self._originalPanelSizeY + 170 then
    _panel:SetPosY(self._originalPanelPosY * 0.2 - consoleGabY)
    _panel:SetSize(screenX, self._savePanelSizeY + consoleGabY)
  else
    _panel:SetPosY(150 - consoleGabY)
    _panel:SetSize(screenX, self._savePanelSizeY + consoleGabY)
  end
  for index = 0, 3 do
    self._ui._radiobtn[index]:ComputePos()
  end
  self._ui._txt_bottomDesc:ComputePos()
  self._ui._txt_bottomDialog:ComputePos()
  self._ui._btn_cancel:ComputePos()
  self._ui._btn_selectBranch:ComputePos()
  self._ui._stc_BranchTitle:ComputePos()
  self._ui._stc_BranchMiddleGroup:ComputePos()
  self._ui._stc_BranchBottomGroup:ComputePos()
  _panel:ComputePos()
end
function questBranch:checkQuestBranch()
  for typeindex = 0, self._questTypeCount - 1 do
    local groupNo = isClearedQuestList[typeindex].questGroupNo
    local questNo = isClearedQuestList[typeindex].questNo
    local isOpen = true
    if true == questList_isClearQuest(groupNo, questNo) then
      for branchindex = 0, questData[typeindex]._branchCount - 1 do
        local acceptGroupNo = questData[typeindex][branchindex].startGroupNo
        local acceptQuestNo = questData[typeindex][branchindex].startQuestNo
        if false == questList_isAcceptableQuest(acceptGroupNo, acceptQuestNo) then
          isOpen = false
          break
        end
      end
      if true == isOpen and false == _panel:GetShow() then
        if false == ToClient_isConsole() then
          self._ui._btn_selectBranch:SetSpanSize(0, self._ui._btn_selectBranch:GetSpanSize().y)
          self._ui._btn_cancel:SetShow(false)
        end
        self._selectedQuestType = typeindex
        self._currentBranchIndex = 0
        self:open()
        break
      end
    end
  end
end
function questBranch:settingControl()
  for index = 0, self._currentBranchCount - 1 do
    self._ui._radiobtn[index]:SetShow(true)
    self._ui._radioImg[index]:ChangeTextureInfoName(questData[self._selectedQuestType][index].texturePath)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._radioImg[index], 0, 0, 280, 380)
    self._ui._radioImg[index]:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui._radioImg[index]:setRenderTexture(self._ui._radioImg[index]:getBaseTexture())
    self._ui._radioTxt[index]:SetText(questData[self._selectedQuestType][index].questTitle)
    local SpanX = questData[self._selectedQuestType][index].spanSizeX
    local SpanY = self._ui._radiobtn[index]:GetSpanSize().y
    self._ui._radiobtn[index]:SetSpanSize(SpanX, SpanY)
  end
end
function questBranch:resetRadiobutton()
  if nil == self._currentBranchCount then
    return
  end
  for index = 0, self._currentBranchCount - 1 do
    self._ui._radiobtn[index]:SetCheck(false)
    self._ui._radiobtn[index]:SetShow(false)
    self._ui._txt_bottomDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUESTBRANCH_SELECTBRANCH"))
    self._ui._txt_bottomDialog:SetText("")
    if true == questBranch._isPlayEffect[index] then
      questBranch._ui._radioImg[index]:EraseAllEffect()
    end
  end
end
function questBranch:checkClearQuest()
  for branchindex = 0, questData[self._selectedQuestType]._branchCount - 1 do
    local groupNo = questData[self._selectedQuestType][branchindex].clearQuestGroupNo
    local questNo = questData[self._selectedQuestType][branchindex].clearQuestNo
    if true == questList_isClearQuest(groupNo, questNo) then
      local groupNo_second = questData[self._selectedQuestType][branchindex].clearQuestGroupNo_2
      local questNo_second = questData[self._selectedQuestType][branchindex].clearQuestNo_2
      if nil ~= groupNo_second and nil ~= questNo_second and true == questList_isClearQuest(groupNo_second, questNo_second) then
        questData[self._selectedQuestType][branchindex].branchcleared = true
        self._ui._radiobtn[branchindex]:SetIgnore(true)
      end
    end
  end
end
function questBranch:checkLeafQuestCleared()
  local isBtnShow
  for typeindex = 0, self._questTypeCount - 1 do
    isBtnShow = true
    local groupNo = questData[typeindex]._completeQuestGroupNo
    local questNo = questData[typeindex]._completeQuestNo
    if true == questList_isClearQuest(groupNo, questNo) then
      for branchindex = 0, questData[typeindex]._branchCount - 1 do
        local startGroupNo = questData[typeindex][branchindex].startGroupNo
        local startQuestNo = questData[typeindex][branchindex].startQuestNo
        local completeGroupNo = questData[typeindex][branchindex].clearQuestGroupNo
        local completeQuestNo = questData[typeindex][branchindex].clearQuestNo
        local isAcceptable = questList_isAcceptableQuest(startGroupNo, startQuestNo)
        local isComplete = questList_isClearQuest(completeGroupNo, completeQuestNo)
        if false == isAcceptable and false == isComplete and false == questData[typeindex][branchindex].branchcleared then
          isBtnShow = false
        end
      end
    else
      isBtnShow = false
    end
  end
  return isBtnShow
end
function questBranch:checkLeafQuestClearedOpen()
  for typeindex = 0, self._questTypeCount - 1 do
    local groupNo = questData[typeindex]._completeQuestGroupNo
    local questNo = questData[typeindex]._completeQuestNo
    if true == questList_isClearQuest(groupNo, questNo) then
      if false == ToClient_isConsole() then
        self._ui._btn_selectBranch:SetSpanSize(-70, self._ui._btn_selectBranch:GetSpanSize().y)
        self._ui._btn_cancel:SetShow(true)
      end
      self._selectedQuestType = typeindex
      self:open()
    end
  end
end
function InputMLUp_questBranch_SelectedBtn(index)
  local self = questBranch
  if nil == self then
    return
  end
  self._prevSelectedTab = self._selectedTab
  self._selectedTab = index
  PaGlobal_questBranch_ShowEffect()
  self._ui._txt_bottomDesc:SetText(questData[self._selectedQuestType][index].bottomDesc)
  self._ui._txt_bottomDialog:SetText(questData[self._selectedQuestType][index].bottomDialog)
  self._ui._txt_bottomDesc:SetPosY(self._ui._radiobtn[0]:GetPosY() + self._ui._radiobtn[0]:GetSizeY() + 10)
  self._ui._txt_bottomDialog:SetPosY(self._ui._txt_bottomDesc:GetPosY() + self._ui._txt_bottomDesc:GetTextSizeY() + 10)
end
function PaGlobal_questBranch_ShowEffect()
  if true == questBranch._isPlayEffect[questBranch._prevSelectedTab] then
    questBranch._ui._radioImg[questBranch._prevSelectedTab]:EraseAllEffect()
    questBranch._isPlayEffect[questBranch._prevSelectedTab] = false
  end
  questBranch._ui._radioImg[questBranch._selectedTab]:AddEffect("fUI_MainQuestChoice_01A", true, 0, 0)
  questBranch._isPlayEffect[questBranch._selectedTab] = true
end
function InputMLUp_questBranch_ApplyBtn()
  local self = questBranch
  if nil == self then
    return
  end
  if nil == self._selectedTab then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_ACK"))
  else
    if true == ToClient_isConsole() then
      _AudioPostEvent_SystemUiForXBOX(0, 1)
    end
    PaGlobal_questBranch_MessageBox()
  end
end
function PaGlobalFunc_QuestBranch_PadControl(isLeft)
  if false == ToClient_isConsole() then
    return
  end
  local self = questBranch
  local prevBranchIndex = self._currentBranchIndex
  if true == isLeft then
    self._currentBranchIndex = prevBranchIndex - 1
    if self._currentBranchIndex < 0 then
      self._currentBranchIndex = 0
    end
  else
    self._currentBranchIndex = prevBranchIndex + 1
    if self._currentBranchCount <= self._currentBranchIndex then
      self._currentBranchIndex = self._currentBranchCount - 1
    end
  end
  _AudioPostEvent_SystemUiForXBOX(0, 0)
  InputMLUp_questBranch_SelectedBtn(self._currentBranchIndex)
end
function PaGlobal_FromClient_FindedLeafQuest(groupNo, questNo)
  local self = questBranch
  if nil == self then
    return
  end
end
function PaGlobal_questBranch_ResizePanel()
  local self = questBranch
  if nil == self then
    return
  end
  self:resizePanel()
end
function PaGlobal_questBranch_MessageBox()
  local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_MESSAGEBOX_DESC")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTBRANCH_MESSAGEBOX_TITLE"),
    content = messageContent,
    functionYes = PaGlobal_questBranch_SetQuestBranch,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_questBranch_IsLeafCleared()
  local self = questBranch
  if nil == self then
    return
  end
  return false
end
function PaGlobal_questBranch_IsQuestBranch()
  local self = questBranch
  if nil == self then
    return
  end
  self:checkQuestBranch()
end
function PaGlobal_questBranch_SetQuestBranch()
  local self = questBranch
  if nil == self then
    return
  end
  local groupNo = questData[self._selectedQuestType][self._selectedTab].startGroupNo
  local questNo = questData[self._selectedQuestType][self._selectedTab].startQuestNo
  ToClient_AcceptQuest(groupNo, questNo)
  PaGlobal_questBranch_Close()
end
function questBranch:OpenShowAni()
  local aniInfo1 = _panel:addScaleAnimation(0, 0.08, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.12)
  aniInfo1.AxisX = _panel:GetSizeX() / 2
  aniInfo1.AxisY = _panel:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = _panel:addScaleAnimation(0.08, 0.15, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.12)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = _panel:GetSizeX() / 2
  aniInfo2.AxisY = _panel:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function questBranch:CloseHideAni()
  local aniInfo1 = _panel:addColorAnimation(0, 0.1, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(Defines.Color.C_FFFFFFFF)
  aniInfo1:SetEndColor(Defines.Color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
function PaGlobal_questBranch_Open(index)
  local self = questBranch
  if nil == self then
    return
  end
  if false == ToClient_isConsole() then
    self._ui._btn_selectBranch:SetSpanSize(-70, self._ui._btn_selectBranch:GetSpanSize().y)
    self._ui._btn_cancel:SetShow(true)
  end
  self._selectedQuestType = index
  self:open()
end
function PaGlobal_questBranch_Close()
  local self = questBranch
  if nil == self then
    return
  end
  self._isClickedBranchButton = false
  self._selectedTab = nil
  self:resetRadiobutton()
  self:CloseHideAni()
  self:close()
end
function PaGlobal_questBranch_Init()
  local self = questBranch
  if nil == self then
    return
  end
  self:init()
end
registerEvent("FromClient_luaLoadCompleteLateUdpate", "PaGlobal_questBranch_Init")
