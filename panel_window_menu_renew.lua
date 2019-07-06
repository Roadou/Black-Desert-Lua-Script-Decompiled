PaGlobal_Menu_Renew = {
  _ui = {
    txt_btnBG = {},
    btn_icon = {},
    txt_hotKey = {},
    stc_newIcon = {},
    stc_hotIcon = {},
    stc_checkIcon = {},
    stc_important = {},
    _topBg = UI.getChildControl(Panel_Window_Menu_Renew, "Static_TopBg")
  },
  _xbox = {},
  _animationTable = {}
}
PaGlobal_Menu_Renew._xbox = {
  _siegeWarCall = 0,
  _busterCall = 1,
  _summonPartyCall = 2,
  _keyGuide = 3,
  _escape = 4,
  _inven = 5,
  _option = 6,
  _gameExit = 7,
  _blackSpirit = 8,
  _questInfo = 9,
  _skill = 10,
  _myInfo = 11,
  _knowledge = 12,
  _worldMap = 13,
  _guild = 14,
  _friend = 15,
  _ringMenu = 16,
  _cashShop = 17,
  _pet = 18,
  _beauty = 19,
  _beautyAlbum = 20,
  _partyRecruite = 21,
  _localWar = 22,
  _freeFight = 23,
  _couquestStatus = 24,
  _partySetting = 25,
  _dailyStamp = 26,
  _craftingNote = 27,
  _tradeInfo = 28,
  _worldMarketPlace = 29,
  _mail = 30,
  _help = 31,
  _copyright = 32,
  _news = 33,
  _challengeReward = 34,
  _report = 35,
  _count = 36
}
PaGlobal_Menu_Renew._categoryData = {
  [PaGlobal_Menu_Renew._xbox._siegeWarCall] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_WARCALL_TOOLTIP_NAME"),
    txt_hotKey = "",
    _path = "renewal/ui_icon/Console_ESCMenuIcon.dds",
    _isImportant = true,
    _isVisible = false,
    _x1 = 344,
    _y1 = 116,
    _x2 = 399,
    _y2 = 171
  },
  [PaGlobal_Menu_Renew._xbox._busterCall] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_NAME"),
    txt_hotKey = "",
    _path = "renewal/ui_icon/Console_ESCMenuIcon.dds",
    _isImportant = true,
    _isVisible = false,
    _x1 = 116,
    _y1 = 173,
    _x2 = 171,
    _y2 = 228
  },
  [PaGlobal_Menu_Renew._xbox._summonPartyCall] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MENU_COMPASS_TITLE"),
    txt_hotKey = "",
    _path = "renewal/ui_icon/Console_ESCMenuIcon.dds",
    _isImportant = true,
    _isVisible = false,
    _x1 = 344,
    _y1 = 230,
    _x2 = 399,
    _y2 = 285
  },
  [PaGlobal_Menu_Renew._xbox._help] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TERMSOFUSE_TITLE"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/XboxConsole_Icon_Title.dds",
    _x1 = 59,
    _y1 = 287,
    _x2 = 114,
    _y2 = 342
  },
  [PaGlobal_Menu_Renew._xbox._escape] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_ESCAPE"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 59,
    _y1 = 2,
    _x2 = 114,
    _y2 = 57
  },
  [PaGlobal_Menu_Renew._xbox._option] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_OPTION"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 173,
    _y1 = 2,
    _x2 = 228,
    _y2 = 57
  },
  [PaGlobal_Menu_Renew._xbox._inven] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_BAG"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 116,
    _y1 = 2,
    _x2 = 171,
    _y2 = 57
  },
  [PaGlobal_Menu_Renew._xbox._gameExit] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_EXIT"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 230,
    _y1 = 2,
    _x2 = 285,
    _y2 = 57
  },
  [PaGlobal_Menu_Renew._xbox._blackSpirit] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_BLACKSPIRIT"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 287,
    _y1 = 2,
    _x2 = 342,
    _y2 = 57
  },
  [PaGlobal_Menu_Renew._xbox._questInfo] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_QUESTHISTORY"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 344,
    _y1 = 2,
    _x2 = 399,
    _y2 = 57
  },
  [PaGlobal_Menu_Renew._xbox._skill] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_SKILL"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 2,
    _y1 = 59,
    _x2 = 57,
    _y2 = 114
  },
  [PaGlobal_Menu_Renew._xbox._myInfo] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_MYINFO"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/XboxConsole_Icon_Title.dds",
    _x1 = 59,
    _y1 = 59,
    _x2 = 114,
    _y2 = 114
  },
  [PaGlobal_Menu_Renew._xbox._knowledge] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_MENTALKNOWLEDGE"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 116,
    _y1 = 59,
    _x2 = 171,
    _y2 = 114
  },
  [PaGlobal_Menu_Renew._xbox._worldMap] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_WORLDMAP"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 173,
    _y1 = 59,
    _x2 = 228,
    _y2 = 114
  },
  [PaGlobal_Menu_Renew._xbox._guild] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_GUILD"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 230,
    _y1 = 59,
    _x2 = 285,
    _y2 = 114
  },
  [PaGlobal_Menu_Renew._xbox._friend] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_FRIENDLIST"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 287,
    _y1 = 59,
    _x2 = 342,
    _y2 = 114
  },
  [PaGlobal_Menu_Renew._xbox._ringMenu] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUICKMENU_RINGMENUSETTING"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 344,
    _y1 = 59,
    _x2 = 399,
    _y2 = 114
  },
  [PaGlobal_Menu_Renew._xbox._cashShop] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_UiCashShop"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 230,
    _y1 = 116,
    _x2 = 285,
    _y2 = 171
  },
  [PaGlobal_Menu_Renew._xbox._pet] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_PET"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 2,
    _y1 = 116,
    _x2 = 57,
    _y2 = 171
  },
  [PaGlobal_Menu_Renew._xbox._beauty] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_BEAUTY"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 59,
    _y1 = 116,
    _x2 = 114,
    _y2 = 171
  },
  [PaGlobal_Menu_Renew._xbox._beautyAlbum] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BEAUTYALBUM_TITLE"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 173,
    _y1 = 173,
    _x2 = 228,
    _y2 = 228
  },
  [PaGlobal_Menu_Renew._xbox._craftingNote] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PRODUCTNOTE_TITLE"),
    txt_hotKey = "",
    _isVisible = false == ToClient_isPS4(),
    _path = "Renewal/UI_Icon/XboxConsole_Icon_Title.dds",
    _x1 = 344,
    _y1 = 59,
    _x2 = 399,
    _y2 = 114
  },
  [PaGlobal_Menu_Renew._xbox._partyRecruite] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PARTYLISTRECRUITE_TITLE"),
    txt_hotKey = "",
    _isVisible = ToClient_IsContentsGroupOpen("254"),
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 117,
    _y1 = 116,
    _x2 = 172,
    _y2 = 171
  },
  [PaGlobal_Menu_Renew._xbox._localWar] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_LOCALWAR"),
    txt_hotKey = "",
    _isVisible = ToClient_IsContentsGroupOpen("43"),
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 173,
    _y1 = 116,
    _x2 = 228,
    _y2 = 171
  },
  [PaGlobal_Menu_Renew._xbox._freeFight] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_FREEFIGHT"),
    txt_hotKey = "",
    _isVisible = ToClient_IsContentsGroupOpen("255"),
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 173,
    _y1 = 230,
    _x2 = 228,
    _y2 = 285
  },
  [PaGlobal_Menu_Renew._xbox._mail] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_MAIL_TITLE"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 287,
    _y1 = 116,
    _x2 = 342,
    _y2 = 171
  },
  [PaGlobal_Menu_Renew._xbox._keyGuide] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_KEYGUIDE_TITLE"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/XboxConsole_Icon_Title.dds",
    _x1 = 59,
    _y1 = 401,
    _x2 = 114,
    _y2 = 456
  },
  [PaGlobal_Menu_Renew._xbox._partySetting] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PARTYSETTING_TITLE"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/XboxConsole_Icon_Title.dds",
    _x1 = 116,
    _y1 = 287,
    _x2 = 171,
    _y2 = 342
  },
  [PaGlobal_Menu_Renew._xbox._dailyStamp] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_DAILYSTAMP_NEWTITLE"),
    txt_hotKey = "",
    _isVisible = ToClient_IsContentsGroupOpen("1025"),
    _path = "Renewal/UI_Icon/XboxConsole_Icon_Title.dds",
    _x1 = 401,
    _y1 = 230,
    _x2 = 456,
    _y2 = 285
  },
  [PaGlobal_Menu_Renew._xbox._worldMarketPlace] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_TITLE"),
    txt_hotKey = "",
    _isVisible = ToClient_IsContentsGroupOpen("464"),
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 2,
    _y1 = 173,
    _x2 = 57,
    _y2 = 228
  },
  [PaGlobal_Menu_Renew._xbox._couquestStatus] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_TITLE"),
    txt_hotKey = "",
    _isVisible = ToClient_IsContentsGroupOpen("21"),
    _path = "Renewal/UI_Icon/XboxConsole_Icon_Title.dds",
    _x1 = 116,
    _y1 = 344,
    _x2 = 171,
    _y2 = 399
  },
  [PaGlobal_Menu_Renew._xbox._copyright] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_COPYRIGHT_TITLE"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 230,
    _y1 = 173,
    _x2 = 285,
    _y2 = 228
  },
  [PaGlobal_Menu_Renew._xbox._news] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MENU_NEWS_TITLE"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 344,
    _y1 = 173,
    _x2 = 399,
    _y2 = 228
  },
  [PaGlobal_Menu_Renew._xbox._challengeReward] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "UI_WIN_CHALLENGE_REWARD_TITLE"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 59,
    _y1 = 230,
    _x2 = 114,
    _y2 = 285
  },
  [PaGlobal_Menu_Renew._xbox._tradeInfo] = {
    _string = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_TRADEMARKET"),
    txt_hotKey = "",
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 2,
    _y1 = 230,
    _x2 = 57,
    _y2 = 285
  },
  [PaGlobal_Menu_Renew._xbox._report] = {
    _string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SAVAGEDEFENCE_RESULT_REPORT"),
    txt_hotKey = "",
    _isVisible = ToClient_isPS4(),
    _path = "Renewal/UI_Icon/Console_ESCMenuIcon.dds",
    _x1 = 116,
    _y1 = 230,
    _x2 = 171,
    _y2 = 285
  }
}
function PaGlobal_Menu_Renew:ShowAni()
end
function PaGlobal_Menu_Renew:HideAni()
end
function PaGlobal_Menu_Renew:Init()
  Panel_Window_Menu_Renew:SetShow(false)
  Panel_Window_Menu_Renew:setGlassBackground(true)
  Panel_Window_Menu_Renew:ActiveMouseEventEffect(true)
  Panel_Window_Menu_Renew:RegisterShowEventFunc(true, "PaGlobal_Menu_Renew:ShowAni()")
  Panel_Window_Menu_Renew:RegisterShowEventFunc(false, "PaGlobal_Menu_Renew:HideAni()")
  local buttonTemplate = UI.getChildControl(Panel_Window_Menu_Renew, "StaticText_ButtonBg_Template")
  buttonTemplate:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  for index = 0, self._xbox._count - 1 do
    self._ui.txt_btnBG[index] = UI.createAndCopyBasePropertyControl(Panel_Window_Menu_Renew, "StaticText_ButtonBg_Template", Panel_Window_Menu_Renew, "StaticText_ButtonBg_" .. index)
    self._ui.btn_icon[index] = UI.createAndCopyBasePropertyControl(buttonTemplate, "Button_MenuIcon", self._ui.txt_btnBG[index], "Button_MenuIcon")
    self._ui.txt_hotKey[index] = UI.createAndCopyBasePropertyControl(buttonTemplate, "StaticText_HotKey", self._ui.txt_btnBG[index], "StaticText_HotKey")
    self._ui.stc_newIcon[index] = UI.createAndCopyBasePropertyControl(buttonTemplate, "Static_NewIcon", self._ui.txt_btnBG[index], "Static_NewIcon")
    self._ui.stc_hotIcon[index] = UI.createAndCopyBasePropertyControl(buttonTemplate, "Static_HotIcon", self._ui.txt_btnBG[index], "Static_HotIcon")
    self._ui.stc_checkIcon[index] = UI.createAndCopyBasePropertyControl(buttonTemplate, "Static_CheckIcon", self._ui.txt_btnBG[index], "Static_CheckIcon")
    self._ui.stc_important[index] = UI.createAndCopyBasePropertyControl(buttonTemplate, "Static_Important", self._ui.txt_btnBG[index], "Static_Important")
    self._ui.txt_btnBG[index]:SetShow(false)
    self._ui.txt_hotKey[index]:SetShow(false)
    self._ui.stc_newIcon[index]:SetShow(false)
    self._ui.stc_hotIcon[index]:SetShow(false)
    self._ui.stc_checkIcon[index]:SetShow(false)
    self._ui.stc_important[index]:SetShow(false)
  end
  registerEvent("FromClient_ResponseBustCall", "FromClient_ResponseBustCall_Menu_Renew")
  registerEvent("FromClient_ResponseTeleportToSiegeTent", "FromClient_ResponseSiegeWarCall_Menu_Renew")
  registerEvent("FromClient_ResponseUseCompass", "FromClient_ResponseSummonPartyCall_Menu_Renew")
  registerEvent("ResponseParty_updatePartyList", "PaGlobalFunc_Menu_Renew_SummonPartyCallCheck")
end
function PaGlobal_Menu_Renew:updateButtons()
  if getSelfPlayer():get():getLevel() < 7 or false == ToClient_IsContentsGroupOpen("1025") then
    self._categoryData[PaGlobal_Menu_Renew._xbox._dailyStamp]._isVisible = false
  else
    self._categoryData[PaGlobal_Menu_Renew._xbox._dailyStamp]._isVisible = true
  end
  local mailMenuIndex = 0
  local rewardMenuIndex = 0
  local visibleCount = 0
  local visibleButtons = {}
  for index = 0, self._xbox._count - 1 do
    self._ui.txt_btnBG[index]:SetShow(false)
    if false ~= self._categoryData[index]._isVisible then
      visibleButtons[#visibleButtons + 1] = index
      visibleCount = visibleCount + 1
    end
  end
  local index = 1
  while visibleCount > index * index do
    index = index + 1
  end
  local horizontalCount = math.max(4, index)
  self._animationTable = {}
  for ii = 1, #visibleButtons do
    local index = visibleButtons[ii]
    local uiIndex = ii - 1
    local categoryData = self._categoryData[index]
    if self._xbox._mail == index then
      mailMenuIndex = uiIndex
    elseif self._xbox._challengeReward == index then
      rewardMenuIndex = uiIndex
    end
    if false ~= self._categoryData[index]._isVisible then
      self._ui.txt_btnBG[uiIndex]:SetShow(true)
      self._ui.txt_btnBG[uiIndex]:SetText(categoryData._string)
      self._ui.txt_btnBG[uiIndex]:addInputEvent("Mouse_LUp", "PaGlobal_Menu_Renew:HandleClicked_MenuButton(" .. index .. ")")
      self._ui.txt_btnBG[uiIndex]:SetPosX(20 + uiIndex % horizontalCount * (self._ui.txt_btnBG[uiIndex]:GetSizeX() + 10))
      self._ui.txt_btnBG[uiIndex]:SetPosY(90 + math.floor(uiIndex / horizontalCount) * (self._ui.txt_btnBG[uiIndex]:GetSizeX() + 10))
      self._ui.btn_icon[uiIndex]:ChangeTextureInfoName(categoryData._path)
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.btn_icon[uiIndex], categoryData._x1, categoryData._y1, categoryData._x2, categoryData._y2)
      self._ui.btn_icon[uiIndex]:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.btn_icon[uiIndex]:setRenderTexture(self._ui.btn_icon[uiIndex]:getBaseTexture())
      if categoryData._isImportant then
        self._animationTable[#self._animationTable + 1] = uiIndex
        self._ui.stc_important[uiIndex]:SetShow(true)
      else
        self._ui.stc_important[uiIndex]:SetShow(false)
      end
    else
      self._ui.txt_btnBG[uiIndex]:SetShow(false)
    end
  end
  local newMailFlag = RequestMail_getNewMailFlag()
  self._ui.stc_important[mailMenuIndex]:SetShow(newMailFlag)
  local rewardListCount = ToClient_GetChallengeRewardInfoCount()
  if rewardListCount > 0 then
    self._ui.stc_important[rewardMenuIndex]:SetShow(true)
  else
    self._ui.stc_important[rewardMenuIndex]:SetShow(false)
  end
  Panel_Window_Menu_Renew:SetSize((self._ui.txt_btnBG[0]:GetSizeX() + 10) * horizontalCount + 30, (self._ui.txt_btnBG[0]:GetSizeY() + 10) * math.ceil(visibleCount / horizontalCount) + 110)
  Panel_Window_Menu_Renew:ComputePos()
  self._ui._topBg:SetSize(Panel_Window_Menu_Renew:GetSizeX() - 8, self._ui._topBg:GetSizeY())
end
function PaGlobal_Menu_Renew:HandleClicked_MenuButton(index)
  if self._xbox._gameExit ~= index and nil ~= Panel_Window_QuestBranch and true == Panel_Window_QuestBranch:GetShow() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_NO_ENTER_BECAUSE_QUESTBRANCH"))
    return
  end
  if self._xbox._help == index then
    PaGlobal_Copyright:open(1)
  elseif self._xbox._busterCall == index then
    PaGlobal_Menu_Renew:busterCall()
  elseif self._xbox._siegeWarCall == index then
    PaGlobal_Menu_Renew:siegeWarCall()
  elseif self._xbox._summonPartyCall == index then
    PaGlobal_Menu_Renew:summonPartyCall()
  elseif self._xbox._escape == index then
    if ToClient_IsMyselfInArena() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_COMMON_ARLERT"))
      return
    elseif true == ToClient_getJoinGuildBattle() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_CANTDO_GUILDBATTLE"))
      return
    end
    _AudioPostEvent_SystemUiForXBOX(1, 41)
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MSGBOX_RESCUE")
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = RescueExecute,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  elseif self._xbox._inven == index then
    GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Inventory)
  elseif self._xbox._option == index then
    showGameOption()
  elseif self._xbox._gameExit == index then
    GameExitShowToggle(false)
  elseif self._xbox._blackSpirit == index then
    GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_BlackSpirit)
  elseif self._xbox._questInfo == index then
    GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_QuestHistory)
  elseif self._xbox._skill == index then
    GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Skill)
  elseif self._xbox._myInfo == index then
    GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_PlayerInfo)
  elseif self._xbox._knowledge == index then
    GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_MentalKnowledge)
  elseif self._xbox._worldMap == index then
    GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_WorldMap)
  elseif self._xbox._guild == index then
    GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Guild)
  elseif self._xbox._friend == index then
    GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_FriendList)
  elseif self._xbox._ringMenu == index then
    FromClient_ConsoleQuickMenu_OpenCustomPage(2)
  elseif self._xbox._cashShop == index then
    GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_CashShop)
  elseif self._xbox._pet == index then
    FGlobal_PetListNew_Toggle()
  elseif self._xbox._beauty == index then
    GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_BeautyShop)
  elseif self._xbox._beautyAlbum == index then
    if true == _ContentsGroup_RenewUI_BeautyAlbum then
      FGlobal_CustomizingAlbum_Show(false, CppEnums.ClientSceneState.eClientSceneStateType_InGame)
    end
  elseif self._xbox._craftingNote == index then
    Panel_ProductNote_ShowToggle()
  elseif self._xbox._partyRecruite == index then
    if true == _ContentsGroup_NewUI_PartyFind_All then
      PaGlobalFunc_PartyList_All_Open()
    else
      PaGlobalFunc_FindParty_Show()
    end
  elseif self._xbox._localWar == index then
    if getSelfPlayer():get():getLevel() < 7 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LEVEL_LIMIT"))
      return
    end
    PaGlobalFunc_LocalWarInfo_Show()
  elseif self._xbox._freeFight == index then
    PaGlobalFunc_FreeFight_Open()
  elseif self._xbox._mail == index then
    Mail_Open()
  elseif self._xbox._keyGuide == index then
    PaGlobalFunc_KeyGuidWindow_Open()
  elseif self._xbox._partySetting == index then
    PaGlobalFunc_PartySetting_Open()
  elseif self._xbox._dailyStamp == index then
    if true == _ContentsGroup_NewUI_DailyStamp_All then
      PaGlobalFunc_DailyStamp_All_Open()
    else
      PaGlobalFunc_DailyStamp_Open()
    end
  elseif self._xbox._worldMarketPlace == index then
    PaGlobalFunc_MarketPlaceConsole_OpenByMenu()
  elseif self._xbox._couquestStatus == index then
    PaGlobalFunc_GuildWarInfo_Open()
  elseif self._xbox._copyright == index then
    PaGlobal_Copyright:open(0)
  elseif self._xbox._news == index then
    PaGlobalFunc_NewsBanner_Open()
  elseif self._xbox._challengeReward == index then
    GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_PlayerInfo)
    PaGlobalFunc_SetCharacterChallengeInfo()
    PaGlobalFunc_SetCharacterChallengeInfoReward()
  elseif self._xbox._tradeInfo == index then
    PaGlobal_TradeInformation:Show()
  elseif self._xbox._report == index then
    PaGloabl_Report_Open()
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  Panel_Window_Menu_Close()
end
local setJumpAnimation = function(control)
  control:ResetVertexAni()
  local ImageMoveAni1 = control:addMoveAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_PI)
  ImageMoveAni1:SetStartPosition(control:GetPosX(), 20)
  ImageMoveAni1:SetEndPosition(control:GetPosX(), 26)
  ImageMoveAni1.IsChangeChild = true
  local scaleAni1 = control:addScaleAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_PI)
  scaleAni1:SetStartScale(1)
  scaleAni1:SetEndScale(0.9)
  scaleAni1.ScaleType = 2
  scaleAni1.IsChangeChild = true
  local ImageMoveAni2 = control:addMoveAnimation(0.201, 0.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_PI)
  ImageMoveAni2:SetStartPosition(control:GetPosX(), 20)
  ImageMoveAni2:SetEndPosition(control:GetPosX(), 10)
  ImageMoveAni2.IsChangeChild = true
  control:CalcUIAniPos(ImageMoveAni2)
  local ImageMoveAni3 = control:addMoveAnimation(0.501, 0.7, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_PI)
  ImageMoveAni3:SetStartPosition(control:GetPosX(), 20)
  ImageMoveAni3:SetEndPosition(control:GetPosX(), 26)
  ImageMoveAni3.IsChangeChild = true
  local scaleAni2 = control:addScaleAnimation(0.501, 0.7, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_PI)
  scaleAni2:SetStartScale(1)
  scaleAni2:SetEndScale(0.9)
  scaleAni2.ScaleType = 2
  scaleAni2.IsChangeChild = true
end
local function reducedPerframe(deltaTime)
  local self = PaGlobal_Menu_Renew
  if nil == PaGlobal_Menu_Renew or nil == self._animationTable then
    return
  end
  for ii = 1, #self._animationTable do
    local uiIndex = self._animationTable[ii]
    setJumpAnimation(self._ui.stc_important[uiIndex])
  end
end
local accumulatedTime = 0
function PaGlobal_Menu_Renew_UpdatePerFrame(deltaTime)
  accumulatedTime = accumulatedTime + deltaTime
  if accumulatedTime > 1 then
    reducedPerframe(deltaTime)
    accumulatedTime = 0
  end
end
function RescueExecute()
  callRescue()
end
function Panel_Window_Menu_ShowToggle()
  local self = PaGlobal_Menu_Renew
  local isShow = Panel_Window_Menu_Renew:GetShow()
  Panel_Window_Menu_Renew:SetShow(not isShow)
  if not isShow then
    _AudioPostEvent_SystemUiForXBOX(53, 37)
    PaGlobal_Menu_Renew:updateButtons()
    for ii = 1, #self._animationTable do
      local uiIndex = self._animationTable[ii]
      setJumpAnimation(self._ui.stc_important[uiIndex])
    end
  end
  if _ContentsGroup_XB_Obt then
    PaGlobalFunc_PreOrder_Open(Panel_Window_Menu_Renew)
  end
end
function Panel_Window_Menu_Close()
  Panel_Window_Menu_Renew:SetShow(false)
  if _ContentsGroup_XB_Obt then
    PaGlobalFunc_PreOrder_Close(Panel_Window_Menu_Renew, Panel_Window_Inventory:IsShow())
  end
end
function PaGlobal_Menu_Renew:ShowAni()
end
function PaGlobal_Menu_Renew:HideAni()
end
function FromClient_ResponseBustCall_Menu_Renew(sendType)
  local self = PaGlobal_Menu_Renew
  if 0 == sendType then
    local leftTime = Int64toInt32(getLeftSecond_TTime64(ToClient_GetGuildBustCallTime()))
    self._categoryData[self._xbox._busterCall]._isVisible = true
    luaTimer_AddEvent(PaGlobalFunc_Menu_Renew_BusterCallCheck, leftTime * 1000, false, 0)
  else
    self._categoryData[self._xbox._busterCall]._isVisible = false
  end
end
function PaGlobal_Menu_Renew:busterCall()
  local regionInfoWrapper = ToClient_getRegionInfoWrapperByPosition(ToClient_GetGuildBustCallPos())
  if nil == regionInfoWrapper then
    return
  end
  local areaName = regionInfoWrapper:getAreaName()
  local usableTime64 = ToClient_GetGuildBustCallTime()
  local descStr = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_DESC", "areaName", areaName, "time", convertStringFromDatetime(getLeftSecond_TTime64(usableTime64)))
  MessageBox.showMessageBox({
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_NAME"),
    content = descStr,
    functionYes = PaGlobal_Menu_Renew_BusterCallConfirm,
    functionNo = MessageBox_Empty_function
  })
end
function PaGlobal_Menu_Renew_BusterCallConfirm()
  local self = PaGlobal_Menu_Renew
  self._categoryData[self._xbox._busterCall]._isVisible = false
  ToClient_RequestTeleportGuildBustCall()
end
function PaGlobalFunc_Menu_Renew_BusterCallCheck()
  local self = PaGlobal_Menu_Renew
  local leftTime = Int64toInt32(getLeftSecond_TTime64(ToClient_GetGuildBustCallTime()))
  self._categoryData[self._xbox._busterCall]._isVisible = leftTime > 0
end
function FromClient_ResponseSiegeWarCall_Menu_Renew(sendType)
  local self = PaGlobal_Menu_Renew
  if 0 == sendType then
    local leftTime = Int64toInt32(getLeftSecond_TTime64(ToClient_GetTeleportToSiegeTentTime()))
    self._categoryData[self._xbox._siegeWarCall]._isVisible = true
    luaTimer_AddEvent(PaGlobalFunc_Menu_Renew_SiegeWarCallCheck, leftTime * 1000, false, 0)
  else
    self._categoryData[self._xbox._siegeWarCall]._isVisible = false
  end
end
function PaGlobal_Menu_Renew:siegeWarCall()
  local regionInfoWrapper = ToClient_getRegionInfoWrapperByPosition(ToClient_GetTeleportToSiegeTentPos())
  if nil == regionInfoWrapper then
    return
  end
  local areaName = regionInfoWrapper:getAreaName()
  local usableTime64 = ToClient_GetTeleportToSiegeTentTime()
  local descStr = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_DESC", "areaName", areaName, "time", convertStringFromDatetime(getLeftSecond_TTime64(usableTime64)))
  MessageBox.showMessageBox({
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_NAME"),
    content = descStr,
    functionYes = PaGlobal_Menu_Renew_SiegeWarCallConfirm,
    functionNo = MessageBox_Empty_function
  })
end
function PaGlobal_Menu_Renew_SiegeWarCallConfirm()
  local self = PaGlobal_Menu_Renew
  self._categoryData[self._xbox._siegeWarCall]._isVisible = false
  ToClient_RequestTeleportToSiegeTentCall()
end
function PaGlobalFunc_Menu_Renew_SiegeWarCallCheck()
  local self = PaGlobal_Menu_Renew
  local leftTime = Int64toInt32(getLeftSecond_TTime64(ToClient_GetTeleportToSiegeTentTime()))
  self._categoryData[self._xbox._siegeWarCall]._isVisible = leftTime > 0
end
function FromClient_ResponseSummonPartyCall_Menu_Renew()
  local self = PaGlobal_Menu_Renew
  local partyActorKey = ToClient_GetCharacterActorKeyRawUseCompass()
  local playerActorKey = getSelfPlayer():getActorKey()
  if partyActorKey == playerActorKey then
    self._categoryData[self._xbox._summonPartyCall]._isVisible = false
  else
    local leftTime = Int64toInt32(ToClient_GetLeftUsableTeleportCompassTime())
    self._categoryData[self._xbox._summonPartyCall]._isVisible = true
    luaTimer_AddEvent(PaGlobalFunc_Menu_Renew_SummonPartyCallCheck, leftTime * 1000, false, 0)
  end
end
function PaGlobal_Menu_Renew:summonPartyCall()
  local partyActorKey = ToClient_GetCharacterActorKeyRawUseCompass()
  local playerActorKey = getSelfPlayer():getActorKey()
  local descStr = ""
  local partyLeaderName = ToClient_GetCharacterNameUseCompass()
  local usableTime64 = ToClient_GetLeftUsableTeleportCompassTime()
  if partyActorKey == playerActorKey then
    descStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPASS_DESC_1", "remainTime", convertStringFromDatetime(usableTime64))
  else
    descStr = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_WIDGET_COMPASS_MESSAGEBOXDESC", "partyName", partyLeaderName, "partyName1", partyLeaderName, "remainTime", convertStringFromDatetime(usableTime64))
  end
  MessageBox.showMessageBox({
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMPASS_NAME"),
    content = descStr,
    functionYes = PaGlobal_Menu_Renew_SummonPartyCallConfirm,
    functionNo = MessageBox_Empty_function
  })
end
function PaGlobal_Menu_Renew_SummonPartyCallConfirm()
  local self = PaGlobal_Menu_Renew
  local leftTime_s64 = ToClient_GetLeftUsableTeleportCompassTime()
  local leftTime = Int64toInt32(leftTime_s64)
  if leftTime > 0 then
    if IsSelfPlayerWaitAction() then
      self._categoryData[self._xbox._summonPartyCall]._isVisible = false
      ToClient_RequestTeleportPosUseCompass()
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ALERTAREA_NOTUSEALERT"))
    end
  end
end
function PaGlobalFunc_Menu_Renew_SummonPartyCallCheck()
  local self = PaGlobal_Menu_Renew
  local partyActorKey = ToClient_GetCharacterActorKeyRawUseCompass()
  local playerActorKey = getSelfPlayer():getActorKey()
  if partyActorKey == playerActorKey then
    self._categoryData[self._xbox._summonPartyCall]._isVisible = false
  else
    local partyMemeberCnt = RequestParty_getPartyMemberCount()
    if partyMemeberCnt > 0 then
      local leftTime = Int64toInt32(ToClient_GetLeftUsableTeleportCompassTime())
      self._categoryData[self._xbox._summonPartyCall]._isVisible = leftTime > 0
    else
      self._categoryData[self._xbox._summonPartyCall]._isVisible = false
    end
  end
end
function PaGlobal_Menu_Renew_Init()
  PaGlobal_Menu_Renew:Init()
  Panel_Window_Menu_Renew:RegisterUpdateFunc("PaGlobal_Menu_Renew_UpdatePerFrame")
  PaGlobalFunc_Menu_Renew_BusterCallCheck()
  PaGlobalFunc_Menu_Renew_SiegeWarCallCheck()
  PaGlobalFunc_Menu_Renew_SummonPartyCallCheck()
end
function PaGlobalFunc_FreeFight_Open()
  local player = getSelfPlayer():get()
  local maxHp = player:getMaxHp()
  local playerHp = player:getHp()
  if player:getLevel() < 50 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_FREEFIGHTALERT"))
    return
  end
  local curChannelData = getCurrentChannelServerData()
  if true == curChannelData._isSiegeChannel then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BATTLEGROURND"))
    return
  end
  if ToClient_IsJoinPvpBattleGround() then
    local FunctionYesUnJoinPvpBattle = function()
      ToClient_UnJoinPvpBattleGround()
    end
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_PVPBATTLEGROUND_UNJOIN")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = messageBoxMemo,
      functionYes = FunctionYesUnJoinPvpBattle,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  elseif maxHp == playerHp then
    if false == IsSelfPlayerWaitAction() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_PVPBATTLEGROUND_CONDITION_WAIT"))
      return
    end
    _AudioPostEvent_SystemUiForXBOX(1, 18)
    local FunctionYesJoinPvpBattle = function()
      ToClient_JoinPvpBattleGround(0)
    end
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_PVPBATTLEGROUND_JOIN")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = messageBoxMemo,
      functionYes = FunctionYesJoinPvpBattle,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_CHECKHP"))
  end
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_Menu_Renew_Init")
