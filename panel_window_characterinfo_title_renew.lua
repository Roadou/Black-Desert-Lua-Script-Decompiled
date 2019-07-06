local _panel = Panel_Window_CharacterInfo_Title_Renew
local _mainPanel = Panel_Window_CharacterInfo_Renew
local CharacterTitleInfo = {
  _ui = {
    stc_GraphBg = UI.getChildControl(_panel, "Static_Graph_BG"),
    stc_TitleTapBg = UI.getChildControl(_panel, "Static_Title_Tap"),
    list_TitleList = UI.getChildControl(_panel, "List2_Title_List"),
    stc_TotalInfoBg = UI.getChildControl(_panel, "Static_Total_Progress_BG"),
    stc_KeyGuide_Select = UI.getChildControl(_mainPanel, "StaticText_A_ConsoleUI"),
    radiobutton_Category = {}
  },
  _currentCategoryCount = 0,
  _currentCategoryIdx = 0,
  _currentClickTitleIdx = -1,
  defaultFrameBG_CharacterInfo_Title = nil,
  _isSelectedTitle = false,
  _currentTitleListType = 0,
  _maxTitleListType = 4,
  _previousTitleListType = nil
}
function CharacterTitleInfo:init()
  self._ui.txt_Character_Title = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_TitleName")
  self._ui.txt_Title_Name_Info = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_Title_Name_Info")
  self._ui.txt_Title_Name_Info:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self:current_TitleName()
  self._ui.progress_World = UI.getChildControl(self._ui.stc_GraphBg, "Progress2_World")
  self._ui.txt_WorldPercent = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_World_Percent")
  self._ui.progress_Battle = UI.getChildControl(self._ui.stc_GraphBg, "Progress2_Battle")
  self._ui.txt_BattlePercent = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_Battle_Percent")
  self._ui.progress_Life = UI.getChildControl(self._ui.stc_GraphBg, "Progress2_Life")
  self._ui.txt_LifePercent = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_Life_Percent")
  self._ui.progress_Fish = UI.getChildControl(self._ui.stc_GraphBg, "Progress2_Fish")
  self._ui.txt_FishPercent = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_Fish_Percent")
  local tabGroup = {}
  self._ui.radiobutton_Category[0] = UI.getChildControl(self._ui.stc_TitleTapBg, "RadioButton_World")
  self._ui.radiobutton_Category[1] = UI.getChildControl(self._ui.stc_TitleTapBg, "RadioButton_Battle")
  self._ui.radiobutton_Category[2] = UI.getChildControl(self._ui.stc_TitleTapBg, "RadioButton_Life")
  self._ui.radiobutton_Category[3] = UI.getChildControl(self._ui.stc_TitleTapBg, "RadioButton_Fish")
  for ii = 0, 3 do
    self._ui.radiobutton_Category[ii]:addInputEvent("Mouse_LUp", "InputMLUp_CharacterTitleInfo_TapToOpen(" .. ii .. " )")
    tabGroup[ii + 1] = self._ui.radiobutton_Category[ii]
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tabGroup, self._ui.stc_TitleTapBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_CENTER, 0)
  self._ui.txt_LastUpdateTime = UI.getChildControl(self._ui.stc_TitleTapBg, "StaticText_AcceptCooltime")
  self._ui.txt_Total_Progress = UI.getChildControl(self._ui.stc_TotalInfoBg, "StaticText_Progress")
  self._ui.progress_Total_Percent = UI.getChildControl(self._ui.stc_TotalInfoBg, "Progress2_Percent")
  self._ui.txt_Reward = UI.getChildControl(self._ui.stc_TotalInfoBg, "StaticText_Reward")
  self._ui.scroll_VerticalTitleList = UI.getChildControl(self._ui.list_TitleList, "List2_1_VerticalScroll")
  self._ui.stc_LTButton = UI.getChildControl(self._ui.stc_TitleTapBg, "Static_LT_ConsoleUI")
  self._ui.stc_LTButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_CharacterTitleInfo_ShowLeftNextTab()")
  self._ui.stc_RTButton = UI.getChildControl(self._ui.stc_TitleTapBg, "Static_RT_ConsoleUI")
  self._ui.stc_RTButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_CharacterTitleInfo_ShowRightNextTab()")
  self:titleListCheck(0)
  CharacterTitleInfo:registMessageHandler()
end
function CharacterTitleInfo:registMessageHandler()
  self._ui.list_TitleList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "CharacterInfo_TitleList_ControlCreate")
  self._ui.list_TitleList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  registerEvent("FromClient_TitleInfo_UpdateText", "FromClient_CharacterTitleInfo_Update")
end
function CharacterTitleInfo:current_TitleName()
  local selfplayer = getSelfPlayer()
  if nil == selfplayer then
    return
  end
  self._ui.txt_Character_Title:SetShow(true)
  if selfplayer:checkToTitleKey() then
    self._ui.txt_Character_Title:SetText(selfplayer:getTitleName())
  else
    self._ui.txt_Character_Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_TITLE_NOAPPLIEDTITLEYET"))
  end
end
function CharacterTitleInfo:titleListCheck(categoryIdx)
  self._currentTitleListType = categoryIdx
  self._currentCategoryCount = ToClient_GetCategoryTitleCount(categoryIdx)
  self._currentCategoryIdx = categoryIdx
  local _fontColor = {
    selected = Defines.Color.C_FFEEEEEE,
    defalut = Defines.Color.C_FF76747D
  }
  ToClient_SetCurrentTitleCategory(categoryIdx)
  for ii = 0, 3 do
    self._ui.radiobutton_Category[ii]:SetFontColor(_fontColor.defalut)
  end
  self._ui.radiobutton_Category[categoryIdx]:SetFontColor(_fontColor.selected)
  FromClient_CharacterTitleInfo_Update()
end
function CharacterTitleInfo:updateCoolTime()
  local coolTime = ToClient_GetUpdateTitleDelay()
  if coolTime > 0 then
    self._isSelectedTitle = true
    self._ui.txt_LastUpdateTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_LASTUPDATETIME", "coolTime", coolTime))
  else
    self._isSelectedTitle = false
    self._ui.txt_LastUpdateTime:SetText("")
  end
end
function CharacterTitleInfo:titleInfoUpdate()
  local titleCountByAll = ToClient_GetTotalTitleCount()
  local acquiredTitleCountByAll = ToClient_GetTotalAcquiredTitleCount()
  local titleTotalCount = ToClient_GetTotalTitleBuffCount()
  self._ui.txt_Reward:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_Reward:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_TOTALREWARD_VALUE"))
  if nil ~= titleCountByAll and nil ~= acquiredTitleCountByAll and nil ~= titleTotalCount then
    local totalPercent = acquiredTitleCountByAll / titleCountByAll * 100
    self._ui.progress_Total_Percent:SetProgressRate(totalPercent)
    self._ui.txt_Total_Progress:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_TITLE_TOTALPROGRESS") .. " : " .. string.format("%.1f", totalPercent) .. "%")
    for index = 0, titleTotalCount - 1 do
      local titleBuffWrapper = ToClient_GetTitleBuffWrapper(index)
      if nil ~= titleBuffWrapper then
        local buffDescription = titleBuffWrapper:getBuffDescription()
        self._ui.txt_Reward:SetText(buffDescription)
      end
    end
    local _categoryProgressDisplay = {
      [1] = self._ui.progress_World,
      [2] = self._ui.progress_Battle,
      [3] = self._ui.progress_Life,
      [4] = self._ui.progress_Fish
    }
    local _categoryPersentDisplay = {
      [1] = self._ui.txt_WorldPercent,
      [2] = self._ui.txt_BattlePercent,
      [3] = self._ui.txt_LifePercent,
      [4] = self._ui.txt_FishPercent
    }
    for ii = 1, 4 do
      local titleCurrentCount = ToClient_GetCategoryTitleCount(ii - 1)
      local titleCurrentGetCount = ToClient_GetAcquiredTitleCount(ii - 1)
      if nil == titleCurrentCount or nil == titleCurrentGetCount then
        break
      end
      local titleCurrentPercent = titleCurrentGetCount / titleCurrentCount * 100
      _categoryProgressDisplay[ii]:SetProgressRate(titleCurrentPercent)
      _categoryPersentDisplay[ii]:SetText(string.format("%.1f", titleCurrentPercent) .. "%")
    end
  end
  local lastCount = self._currentCategoryCount
  if lastCount < 1 then
    return
  end
  if self._previousTitleListType == self._currentTitleListType then
    for titleIndex = 0, lastCount - 1 do
      self._ui.list_TitleList:requestUpdateByKey(toInt64(0, titleIndex))
    end
  else
    self._previousTitleListType = self._currentTitleListType
    self._ui.list_TitleList:getElementManager():clearKey()
    for titleIndex = 0, lastCount - 1 do
      self._ui.list_TitleList:getElementManager():pushKey(toInt64(0, titleIndex))
    end
    ToClient_padSnapResetPanelControl(Panel_Window_CharacterInfo_Renew)
  end
end
function CharacterInfo_TitleList_ControlCreate(content, key)
  local self = CharacterTitleInfo
  local titleIndex = Int64toInt32(key)
  local titleWrapper = ToClient_GetTitleStaticStatusWrapper(titleIndex)
  if nil == titleWrapper then
    return
  end
  local titleBG = UI.getChildControl(content, "RadioButton_Select_Title_Template")
  local titleName = UI.getChildControl(content, "StaticText_Title_Name_Template")
  local radioButton_NA = UI.getChildControl(content, "RadioButton_NA_Template")
  local stc_Selected = UI.getChildControl(content, "Static_Selected")
  local icon_Selected = UI.getChildControl(stc_Selected, "Static_Select_Icon")
  local text_Selected = UI.getChildControl(icon_Selected, "StaticText_Selected")
  titleBG:SetIgnore(false)
  stc_Selected:SetShow(false)
  radioButton_NA:SetIgnore(true)
  titleName:SetText(titleWrapper:getName())
  titleName:SetShow(true)
  local possibleColor = Defines.Color.C_FFEEEEEE
  local impossibleColor = Defines.Color.C_FF76747D
  local totalX = titleBG:GetSizeX()
  local selectedSizeX = text_Selected:GetTextSizeX() + 20
  stc_Selected:SetPosX(totalX - selectedSizeX)
  if titleWrapper:isAcquired() == true then
    radioButton_NA:SetShow(false)
    titleName:SetFontColor(possibleColor)
    titleBG:addInputEvent("Mouse_LUp", "InputMLUp_CharacterTitleInfo_TitleSet(" .. self._currentCategoryIdx .. ", " .. titleIndex .. " )")
    if ToClient_IsAppliedTitle(titleWrapper:getKey()) then
      stc_Selected:SetShow(true)
    end
  else
    radioButton_NA:SetIgnore(false)
    radioButton_NA:SetShow(true)
    stc_Selected:SetShow(false)
    titleName:SetFontColor(impossibleColor)
    titleBG:addInputEvent("Mouse_LUp", "")
    radioButton_NA:addInputEvent("Mouse_On", "InputMOn_CharacterTitleInfo_ShowDescription(" .. titleIndex .. " )")
  end
  titleBG:addInputEvent("Mouse_On", "InputMOn_CharacterTitleInfo_ShowDescription(" .. titleIndex .. " )")
end
function InputMLUp_CharacterTitleInfo_TapToOpen(categoryIdx)
  local self = CharacterTitleInfo
  self._previousTitleListType = nil
  self:titleListCheck(categoryIdx)
end
function InputMOn_CharacterTitleInfo_ShowDescription(titleIdx)
  local self = CharacterTitleInfo
  local titleWrapper = ToClient_GetTitleStaticStatusWrapper(titleIdx)
  if nil == titleWrapper then
    return
  end
  self._ui.stc_KeyGuide_Select:SetShow(titleWrapper:isAcquired())
  self._ui.txt_Title_Name_Info:SetText(titleWrapper:getDescription())
  self._ui.txt_Title_Name_Info:SetFontColor(Defines.Color.C_FF76747D)
end
function InputMOut_CharacterTitleInfo_CloseDescription()
  local self = CharacterTitleInfo
  self._ui.txt_Title_Name_Info:SetText("")
end
function InputMLUp_CharacterTitleInfo_TitleSet(categoryIdx, titleIdx)
  local self = CharacterTitleInfo
  ToClient_SetCurrentTitleCategory(categoryIdx)
  CharacterTitleInfo:current_TitleName()
  ToClient_TitleSetRequest(categoryIdx, titleIdx)
  self._isSelectedTitle = true
  self._currentClickTitleIdx = titleIdx
end
function FromClient_CharacterTitleInfo_Update()
  local self = CharacterTitleInfo
  if _mainPanel:IsShow() == false then
    return
  end
  self:titleInfoUpdate()
  self:current_TitleName()
  self:updateCoolTime()
end
function FromClient_luaLoadComplete_Panel_Window_CharacterInfo_Title()
  local self = CharacterTitleInfo
  self:init()
  self.defaultFrameBG_CharacterInfo_Title = UI.getChildControl(Panel_Window_CharacterInfo_Renew, "Static_TitleInfoBg")
  self.defaultFrameBG_CharacterInfo_Title:SetShow(false)
  self.defaultFrameBG_CharacterInfo_Title:MoveChilds(self.defaultFrameBG_CharacterInfo_Title:GetID(), _panel)
  deletePanel(_panel:GetID())
end
function CoolTimeCountdown_UpdatePerFrame(deltaTime)
  local self = CharacterTitleInfo
  if self._isSelectedTitle then
    self:updateCoolTime()
  end
end
function PaGlobalFunc_CharacterTitleInfo_ShowRightNextTab()
  local self = CharacterTitleInfo
  self:ShowNextTab(false)
end
function PaGlobalFunc_CharacterTitleInfo_ShowLeftNextTab()
  local self = CharacterTitleInfo
  self:ShowNextTab(true)
end
function CharacterTitleInfo:ShowNextTab(isLeft)
  if true == isLeft then
    if 0 < self._currentTitleListType then
      self._currentTitleListType = self._currentTitleListType - 1
    else
      self._currentTitleListType = self._maxTitleListType - 1
    end
    self:titleListCheck(self._currentTitleListType)
  else
    if self._currentTitleListType < self._maxTitleListType - 1 then
      self._currentTitleListType = self._currentTitleListType + 1
    else
      self._currentTitleListType = 0
    end
    self:titleListCheck(self._currentTitleListType)
  end
  _AudioPostEvent_SystemUiForXBOX(51, 7)
end
function PaGlobalFunc_CharacterTitleInfoTab_PadControl(index)
  self = CharacterTitleInfo
  if 0 == index then
    self:ShowNextTab(true)
  else
    self:ShowNextTab(false)
  end
  ToClient_padSnapResetControl(Panel_Window_CharacterInfo_Renew)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Panel_Window_CharacterInfo_Title")
