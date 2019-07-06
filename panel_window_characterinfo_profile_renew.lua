local _panel = Panel_Window_CharacterInfo_Profile_Renew
local _mainPanel = Panel_Window_CharacterInfo_Renew
local CharacterProfileInfo = {
  _ui = {
    stc_BG = UI.getChildControl(_panel, "Static_BG"),
    stc_CategoryTap = UI.getChildControl(_panel, "Static_Category_Tap"),
    stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  },
  defaultFrameBG_CharacterInfo_Profile = nil,
  termIndex = {
    [0] = 1,
    [1] = 7,
    [2] = 30,
    [3] = 0
  },
  _maxCategoryType = 4,
  _currentCategoryType = 0
}
function CharacterProfileInfo:init()
  self._ui.radioButton = {
    [0] = UI.getChildControl(self._ui.stc_CategoryTap, "RadioButton_Day"),
    [1] = UI.getChildControl(self._ui.stc_CategoryTap, "RadioButton_Week"),
    [2] = UI.getChildControl(self._ui.stc_CategoryTap, "RadioButton_Month"),
    [3] = UI.getChildControl(self._ui.stc_CategoryTap, "RadioButton_Total")
  }
  for inputIdx = 0, 3 do
    self._ui.radioButton[inputIdx]:addInputEvent("Mouse_LUp", "InputMLUp_CharacterProfileInfo_TapToOpen(" .. inputIdx .. ")")
  end
  self._ui.stc_LT_ConsoleUI = UI.getChildControl(self._ui.stc_CategoryTap, "Static_LT_ConsoleUI")
  self._ui.stc_LT_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_CharacterProfileInfo_ShowLeftNextTab()")
  self._ui.stc_RT_ConsoleUI = UI.getChildControl(self._ui.stc_CategoryTap, "Static_RT_ConsoleUI")
  self._ui.stc_RT_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_CharacterProfileInfo_ShowRightNextTab()")
  self._ui.stc_MonsterBG = UI.getChildControl(self._ui.stc_BottomBg, "Static_Monster_BG")
  self._ui.stc_MonsterIconBG = UI.getChildControl(self._ui.stc_MonsterBG, "Static_Monster_Icon_BG")
  self._ui.stc_MonsterIcon = UI.getChildControl(self._ui.stc_MonsterBG, "Static_Monster_Icon")
  self._ui.txt_MonsterTitle = UI.getChildControl(self._ui.stc_MonsterBG, "StaticText_Monster_Title")
  self._ui.txt_MonsterTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_TITLE_1"))
  self._ui.txt_MonsterCount = UI.getChildControl(self._ui.stc_MonsterBG, "StaticText_Monster_Count")
  self._ui.txt_MonsterDesc = UI.getChildControl(self._ui.stc_MonsterBG, "StaticText_Monster_Desc")
  self._ui.txt_MonsterDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_MonsterDesc:SetAutoResize(true)
  self._ui.txt_MonsterDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_DESC_1"))
  self._ui.stc_FishBG = UI.getChildControl(self._ui.stc_BottomBg, "Static_Fish_BG")
  self._ui.stc_FishIconBG = UI.getChildControl(self._ui.stc_FishBG, "Static_Fish_Icon_BG")
  self._ui.stc_FishIcon = UI.getChildControl(self._ui.stc_FishBG, "Static_Fish_Icon")
  self._ui.txt_FishTitle = UI.getChildControl(self._ui.stc_FishBG, "StaticText_Fish_Title")
  self._ui.txt_FishTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_TITLE_2"))
  self._ui.txt_FishCount = UI.getChildControl(self._ui.stc_FishBG, "StaticText_Fish_Count")
  self._ui.txt_FishDesc = UI.getChildControl(self._ui.stc_FishBG, "StaticText_Fish_Desc")
  self._ui.txt_FishDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_FishDesc:SetAutoResize(true)
  self._ui.txt_FishDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_DESC_2"))
  self._ui.stc_GatherBG = UI.getChildControl(self._ui.stc_BottomBg, "Static_Gather_BG")
  self._ui.stc_GatherIconBG = UI.getChildControl(self._ui.stc_GatherBG, "Static_Gather_Icon_BG")
  self._ui.stc_GatherIcon = UI.getChildControl(self._ui.stc_GatherBG, "Static_Gather_Icon")
  self._ui.txt_GatherTitle = UI.getChildControl(self._ui.stc_GatherBG, "StaticText_Gather_Title")
  self._ui.txt_GatherTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_TITLE_3"))
  self._ui.txt_GatherCount = UI.getChildControl(self._ui.stc_GatherBG, "StaticText_Gather_Count")
  self._ui.txt_GatherDesc = UI.getChildControl(self._ui.stc_GatherBG, "StaticText_Gather_Desc")
  self._ui.txt_GatherDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_GatherDesc:SetAutoResize(true)
  self._ui.txt_GatherDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_DESC_3"))
  self._ui.stc_WeightBG = UI.getChildControl(self._ui.stc_BottomBg, "Static_Weight_BG")
  self._ui.stc_WeightIconBG = UI.getChildControl(self._ui.stc_WeightBG, "Static_Weight_Icon_BG")
  self._ui.stc_WeightIcon = UI.getChildControl(self._ui.stc_WeightBG, "Static_Weight_Icon")
  self._ui.txt_WeightTitle = UI.getChildControl(self._ui.stc_WeightBG, "StaticText_Weight_Title")
  self._ui.txt_WeightTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_TITLE_4"))
  self._ui.txt_WeightCount = UI.getChildControl(self._ui.stc_WeightBG, "StaticText_Weight_Count")
  self._ui.txt_WeightDesc = UI.getChildControl(self._ui.stc_WeightBG, "StaticText_Weight_Desc")
  self._ui.txt_WeightDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_WeightDesc:SetAutoResize(true)
  self._ui.txt_WeightDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_DESC_4"))
  self._ui.txt_PlayTimeTotal = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_PlayTimeTotal")
  self._ui.txt_PlayTimeDay = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_PlayTimeToday")
  self._ui.txt_PlayTimePcRoom = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_PlayTimePcRoom")
  self._ui.txt_PlayTimePcRoom:SetShow(false)
end
function CharacterProfileInfo:updateData(period)
  self._currentCategoryType = period
  ToClient_RequestUserProfileInfo()
  for btnIdx = 0, #self._ui.radioButton do
    self._ui.radioButton[btnIdx]:SetFontColor(Defines.Color.C_FF888888)
  end
  self._ui.radioButton[period]:SetFontColor(Defines.Color.C_FFEEEEEE)
  local _dayPlayTime = Util.Time.timeFormatting(Int64toInt32(ToClient_GetUserPlayTimePerDay()))
  self._ui.txt_PlayTimeDay:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_TODAYPLAYTIME") .. " <PAColor0xFFFFC730>" .. _dayPlayTime)
  local _totalPlayTime = Util.Time.timeFormatting_Minute(Int64toInt32(ToClient_GetCharacterPlayTime()))
  self._ui.txt_PlayTimeTotal:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CONTRACT_TIME_BLACKSPIRIT") .. " <PAColor0xFFFFC730>" .. _totalPlayTime)
  local _temporaryPCRoomWrapper = getTemporaryInformationWrapper()
  local _isPremiumPcRoom = _temporaryPCRoomWrapper:isPremiumPcRoom()
  if true == _isPremiumPcRoom and (isGameTypeKorea() or isGameTypeJapan()) then
    self._ui.txt_PlayTimePcRoom:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_PCROOMPLAYTIME") .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_PCROOMTIME", "getPcRoomPlayTime", convertStringFromDatetime(ToClient_GetPcRoomPlayTime())))
    self._ui.txt_PlayTimePcRoom:SetShow(true)
  elseif false == _isPremiumPcRoom then
    self._ui.txt_PlayTimePcRoom:SetShow(false)
  end
  local _periodIdx = self.termIndex[period]
  local _monsterCountText = tostring(ToClient_GetProfileInfo(_periodIdx, CppEnums.ProfileIndex.eUserProfileValueType_MonsterKillCount))
  self._ui.txt_MonsterCount:SetText(_monsterCountText)
  local _fishCountText = tostring(ToClient_GetProfileInfo(_periodIdx, CppEnums.ProfileIndex.eUserProfileValueType_FishingSuccessCount))
  self._ui.txt_FishCount:SetText(_fishCountText)
  local _gatherCountText = tostring(ToClient_GetProfileInfo(_periodIdx, CppEnums.ProfileIndex.eUserProfileValueType_ItemGainCount))
  self._ui.txt_GatherCount:SetText(_gatherCountText)
  local _weightText = ToClient_GetProfileInfo(_periodIdx, CppEnums.ProfileIndex.eUserProfileValueType_ProductSuccessCount)
  _weightText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_WEIGHT", "count", makeWeightString(_weightText))
  self._ui.txt_WeightCount:SetText(_weightText)
end
function InputMLUp_CharacterProfileInfo_TapToOpen(radioBtnIdx)
  self = CharacterProfileInfo
  self:updateData(radioBtnIdx)
end
function FromClient_luaLoadComplete_Panel_Window_Character_ProfileInfo()
  local self = CharacterProfileInfo
  self:init()
  self.defaultFrameBG_CharacterInfo_Profile = UI.getChildControl(_mainPanel, "Static_ProfileInfoBg")
  self.defaultFrameBG_CharacterInfo_Profile:SetShow(false)
  self.defaultFrameBG_CharacterInfo_Profile:MoveChilds(self.defaultFrameBG_CharacterInfo_Profile:GetID(), _panel)
  deletePanel(_panel:GetID())
  InputMLUp_CharacterProfileInfo_TapToOpen(0)
end
function PaGlobalFunc_CharacterProfileInfo_ShowRightNextTab()
  local self = CharacterProfileInfo
  self:ShowNextTab(false)
end
function PaGlobalFunc_CharacterProfileInfo_ShowLeftNextTab()
  local self = CharacterProfileInfo
  self:ShowNextTab(true)
end
function CharacterProfileInfo:ShowNextTab(isLeft)
  if true == isLeft then
    if 0 < self._currentCategoryType then
      self._currentCategoryType = self._currentCategoryType - 1
    else
      self._currentCategoryType = self._maxCategoryType - 1
    end
    self:updateData(self._currentCategoryType)
  else
    if self._currentCategoryType < self._maxCategoryType - 1 then
      self._currentCategoryType = self._currentCategoryType + 1
    else
      self._currentCategoryType = 0
    end
    self:updateData(self._currentCategoryType)
  end
end
function PaGlobalFunc_CharacterProfileInfoTab_PadControl(index)
  self = CharacterProfileInfo
  _PA_LOG("\236\155\144\236\132\160", "PaGlobalFunc_CharacterInfoTab_PadControl" .. index)
  if 0 == index then
    self:ShowNextTab(true)
  else
    self:ShowNextTab(false)
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Panel_Window_Character_ProfileInfo")
