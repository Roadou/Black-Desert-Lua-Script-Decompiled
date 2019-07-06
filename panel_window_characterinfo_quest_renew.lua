local _mainPanel = Panel_Window_CharacterInfo_Renew
local _panel = Panel_Window_CharacterInfo_Quest_Renew
local QUEST_TYPE = {
  BLACK_SPIRIT = 1,
  COMBAT = 2,
  LIFE = 3,
  FISHING = 4,
  ADVENTURE = 5,
  ETC = 6
}
local CharacterQuestInfo = {
  _ui = {
    stc_questInfoBG = nil,
    txt_desc = UI.getChildControl(_panel, "StaticText_Desc"),
    stc_centerBG = UI.getChildControl(_panel, "Static_CenterBg"),
    stc_deco = UI.getChildControl(_panel, "Static_Deco"),
    chk_quest = {},
    stc_checkImage = {},
    txt_selectedType = UI.getChildControl(_panel, "StaticText_SelectedTypeTitle"),
    txt_selectedTypeDesc = UI.getChildControl(_panel, "StaticText_SelectedTypeDesc"),
    txt_keyGuideSelect = nil,
    txt_keyGuideClose = nil
  },
  _initialize = false
}
local _questTypeData = {
  [QUEST_TYPE.BLACK_SPIRIT] = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_QUEST_T_BLACK_SPIRIT"),
    titleDesc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_QUEST_BLACK_SPIRIT")
  },
  [QUEST_TYPE.COMBAT] = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_QUEST_T_GENERAL"),
    titleDesc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_QUEST_GENERAL")
  },
  [QUEST_TYPE.LIFE] = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_QUEST_T_GATHERING"),
    titleDesc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_QUEST_GATHERING")
  },
  [QUEST_TYPE.FISHING] = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_QUEST_T_FISHING"),
    titleDesc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_QUEST_FISHING")
  },
  [QUEST_TYPE.ADVENTURE] = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_QUEST_T_TRADE"),
    titleDesc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_QUEST_TRADE")
  },
  [QUEST_TYPE.ETC] = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_QUEST_T_REPEATABLE"),
    titleDesc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_QUEST_REPEATABLE")
  }
}
local self = CharacterQuestInfo
function FromClient_luaLoadComplete_CharacterQuestInfo_Title()
  self:initialize()
  self._ui.stc_questInfoBG = UI.getChildControl(_mainPanel, "Static_QuestInfoBg")
  self._ui.stc_questInfoBG:SetShow(false)
  self._ui.stc_questInfoBG:MoveChilds(self._ui.stc_questInfoBG:GetID(), _panel)
  self._ui.txt_keyGuideSelect = PaGlobalFunc_CharacterInfo_GetKeyGuideA()
  self._ui.txt_keyGuideClose = PaGlobalFunc_CharacterInfo_GetKeyGuideB()
  deletePanel(_panel:GetID())
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_CharacterQuestInfo_Title")
function CharacterQuestInfo:initialize()
  if true == self._initialize then
    return
  end
  self._ui.chk_quest = {
    [QUEST_TYPE.BLACK_SPIRIT] = UI.getChildControl(self._ui.stc_deco, "CheckButton_BlackSpirit"),
    [QUEST_TYPE.COMBAT] = UI.getChildControl(self._ui.stc_deco, "CheckButton_Combat"),
    [QUEST_TYPE.LIFE] = UI.getChildControl(self._ui.stc_deco, "CheckButton_Life"),
    [QUEST_TYPE.FISHING] = UI.getChildControl(self._ui.stc_deco, "CheckButton_Fishing"),
    [QUEST_TYPE.ADVENTURE] = UI.getChildControl(self._ui.stc_deco, "CheckButton_Adventure"),
    [QUEST_TYPE.ETC] = UI.getChildControl(self._ui.stc_deco, "CheckButton_Etc")
  }
  for ii = 1, #self._ui.chk_quest do
    self._ui.chk_quest[ii]:addInputEvent("Mouse_LUp", "Input_CharacterQuestInfo_CheckButton(" .. ii .. ")")
    self._ui.chk_quest[ii]:addInputEvent("Mouse_On", "Input_CharacterQuestInfo_ShowDescription(" .. ii .. ")")
    self._ui.chk_quest[ii]:SetCheck(false)
    self._ui.stc_checkImage[ii] = UI.getChildControl(self._ui.chk_quest[ii], "Static_CheckIcon")
    self._ui.stc_checkImage[ii]:SetShow(false)
  end
  local QuestListInfo = ToClient_GetQuestList()
  local isOn = QuestListInfo:isQuestSelectType(QUEST_TYPE.COMBAT - 1)
  if false == isOn then
    ToClient_ToggleQuestSelectType(QUEST_TYPE.COMBAT - 1)
  end
  self._ui.txt_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_QUEST_MAIN_DESC"))
  self._ui.txt_selectedTypeDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self:registerEventHandler()
end
function CharacterQuestInfo:registerEventHandler()
  registerEvent("EventSelfPlayerLevelUp", "PaGlobalFunc_CharacterInfo_LvFiftySetQuestFavorType")
end
function PaGlobalFunc_CharacterQuestInfo_Open()
  CharacterQuestInfo:open()
end
function CharacterQuestInfo:open()
  self:update()
  self._ui.txt_keyGuideSelect:SetShow(false)
end
function CharacterQuestInfo:update()
  local QuestListInfo = ToClient_GetQuestList()
  for ii = 1, #self._ui.chk_quest do
    if QUEST_TYPE.BLACK_SPIRIT ~= ii then
      local isOn = QuestListInfo:isQuestSelectType(ii - 1)
      self._ui.chk_quest[ii]:SetCheck(isOn)
      self._ui.stc_checkImage[ii]:SetShow(isOn)
    end
  end
  self._ui.chk_quest[1]:SetCheck(true)
  self._ui.stc_checkImage[1]:SetShow(true)
end
function PaGlobalFunc_CharacterInfo_LvFiftySetQuestFavorType()
  if nil == getSelfPlayer() then
    return
  end
  if 50 ~= getSelfPlayer():get():getLevel() then
    return
  end
  if CharacterQuestInfo._ui.chk_quest[QUEST_TYPE.ETC]:IsCheck() then
    return
  end
  self._ui.chk_quest[QUEST_TYPE.ETC]:SetCheck(true)
  self._ui.stc_checkImage[QUEST_TYPE.ETC]:SetShow(true)
end
function Input_CharacterQuestInfo_CheckButton(buttonIndex)
  CharacterQuestInfo:checkButton(buttonIndex)
end
function CharacterQuestInfo:checkButton(buttonIndex)
  if QUEST_TYPE.BLACK_SPIRIT == buttonIndex then
    return
  end
  local QuestListInfo = ToClient_GetQuestList()
  local bool = QuestListInfo:isQuestSelectType(buttonIndex - 1)
  ToClient_ToggleQuestSelectType(buttonIndex - 1)
  self._ui.chk_quest[buttonIndex]:SetCheck(not bool)
  self._ui.stc_checkImage[buttonIndex]:SetShow(not bool)
end
function Input_CharacterQuestInfo_ShowDescription(index)
  self._ui.txt_keyGuideSelect:SetShow(QUEST_TYPE.BLACK_SPIRIT ~= index)
  if QUEST_TYPE.BLACK_SPIRIT ~= index then
    local tempKeyGuideGroup = {
      self._ui.txt_keyGuideSelect,
      self._ui.txt_keyGuideClose
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempKeyGuideGroup, _mainPanel, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  end
  self._ui.txt_selectedType:SetText(_questTypeData[index].title)
  self._ui.txt_selectedTypeDesc:SetText(_questTypeData[index].titleDesc)
end
