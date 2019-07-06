local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local IM = CppEnums.EProcessorInputMode
Panel_Chat_SocialMenu:setGlassBackground(true)
Panel_Chat_SocialMenu:SetDragEnable(true)
Panel_Chat_SocialMenu:SetDragAll(true)
Panel_Chat_SocialMenu:SetPosX(getScreenSizeX() / 2 + Panel_Chat_SocialMenu:GetSizeX() / 2)
Panel_Chat_SocialMenu:SetPosY(getScreenSizeY() / 2 - Panel_Chat_SocialMenu:GetSizeY() / 2)
local btn_winClose = UI.getChildControl(Panel_Chat_SocialMenu, "Button_WinClose")
local mainBg = UI.getChildControl(Panel_Chat_SocialMenu, "Static_MainBg")
local socialIconSlotBG = UI.getChildControl(Panel_Chat_SocialMenu, "Static_C_IconBG")
local socialIconSlot = UI.getChildControl(Panel_Chat_SocialMenu, "Static_C_SocialIcon")
local selectedSlotBG = UI.getChildControl(Panel_Chat_SocialMenu, "Static_C_IconSelect")
local frameSocialAction = UI.getChildControl(Panel_Chat_SocialMenu, "Frame_SocialAction")
local socialActioncontent = UI.getChildControl(frameSocialAction, "Frame_1_Content")
local _scroll = UI.getChildControl(frameSocialAction, "VerticalScroll")
local _socialIconSlot = {}
local _socialIconSlotBG = {}
local _selectedSlotBG
function SocialAction_Icon_Initialize()
  local socialIconCount = ToClient_getSocialActionInfoList()
  local iconGap = 55
  local _columnCount = 0
  local _rowCount = 0
  if 0 == socialIconCount then
    return
  end
  socialActioncontent:DestroyAllChild()
  for index = 0, socialIconCount do
    _socialIconSlotBG[index] = {}
    _socialIconSlot[index] = {}
    _socialIconSlotBG[index] = createControl(UI_PUCT.PA_UI_CONTROL_STATIC, socialActioncontent, "Static_SocialIconSlotBG_" .. index)
    _socialIconSlot[index] = createControl(UI_PUCT.PA_UI_CONTROL_STATIC, socialActioncontent, "Static_SocialIconSlot_" .. index)
    CopyBaseProperty(socialIconSlotBG, _socialIconSlotBG[index])
    CopyBaseProperty(socialIconSlot, _socialIconSlot[index])
    socialActioncontent:SetChildIndex(_socialIconSlot[index], 3000)
    if 0 == index % 6 then
      _columnCount = 0
      _rowCount = _rowCount + 1
    else
      _columnCount = _columnCount + 1
    end
    _socialIconSlotBG[index]:SetPosX(socialIconSlotBG:GetPosX() + iconGap * _columnCount)
    _socialIconSlotBG[index]:SetPosY(socialIconSlotBG:GetPosY() + iconGap * (_rowCount - 1))
    _socialIconSlot[index]:SetPosX(socialIconSlot:GetPosX() + iconGap * _columnCount)
    _socialIconSlot[index]:SetPosY(socialIconSlot:GetPosY() + iconGap * (_rowCount - 1))
    _socialIconSlotBG[index]:SetShow(true)
    _socialIconSlot[index]:SetShow(true)
    if socialIconCount ~= index then
      local socialActionInfo = ToClient_getSocialActionInfoByIndex(index)
      local sASS = socialActionInfo:getStaticStatus()
      local socialKey = sASS:getKey()
      if true == ToClient_isUsableSocialAction(socialKey) then
        _socialIconSlot[index]:ActiveMouseEventEffect(true)
        _socialIconSlot[index]:SetMonoTone(false)
        _socialIconSlot[index]:addInputEvent("Mouse_LUp", "HandleClicked_SocialIcon(" .. index .. ")")
        _socialIconSlot[index]:addInputEvent("Mouse_RUp", "HandleClicked_DoAction(" .. index .. ")")
        _socialIconSlot[index]:addInputEvent("Mouse_On", "Show_Condition_SocialIcon(" .. index .. ", true )")
        _socialIconSlot[index]:addInputEvent("Mouse_Out", "Show_Condition_SocialIcon()")
      else
        _socialIconSlot[index]:ActiveMouseEventEffect(false)
        _socialIconSlot[index]:SetMonoTone(true)
        _socialIconSlot[index]:addInputEvent("Mouse_On", "Show_Condition_SocialIcon(" .. index .. ")")
        _socialIconSlot[index]:addInputEvent("Mouse_Out", "Show_Condition_SocialIcon()")
      end
      _socialIconSlot[index]:ChangeTextureInfoName("Icon/" .. sASS:getIconPath())
      _socialIconSlot[index]:SetAlpha(1)
    else
      _socialIconSlot[index]:ChangeTextureInfoName("Icon/New_Icon/03_ETC/item_unknown.dds")
      _socialIconSlot[index]:SetAlpha(1)
      _socialIconSlot[index]:SetIgnore(true)
      _socialIconSlotBG[index]:SetIgnore(true)
    end
  end
  _selectedSlotBG = createControl(UI_PUCT.PA_UI_CONTROL_STATIC, socialActioncontent, "Static_SelectedSlot")
  CopyBaseProperty(selectedSlotBG, _selectedSlotBG)
  socialActioncontent:SetSize(socialActioncontent:GetSizeX(), _socialIconSlot[socialIconCount - 1]:GetPosY() + iconGap - 10)
  if frameSocialAction:GetSizeY() < socialActioncontent:GetSizeY() then
    frameSocialAction:UpdateContentScroll()
    _scroll:SetShow(true)
  else
    _scroll:SetShow(false)
  end
  btn_winClose:addInputEvent("Mouse_LUp", "HandleClicked_Button(1,0)")
end
function Panel_SocialMenu_ResetVertexAni()
  for _, v in pairs(_socialIconSlot) do
    v:ResetVertexAni()
    v:SetVertexAniRun("Ani_Color_Reset", true)
  end
end
local SocialAction = {
  _name = UI.getChildControl(Panel_Chat_SocialMenu, "StaticText_SocialName"),
  _conditionText = UI.getChildControl(Panel_Chat_SocialMenu, "StaticText_ConditionMessage"),
  _icon = UI.getChildControl(Panel_Chat_SocialMenu, "Static_SelectedIcon"),
  _command = UI.getChildControl(Panel_Chat_SocialMenu, "Edit_Command"),
  _keyword_1 = UI.getChildControl(Panel_Chat_SocialMenu, "Edit_Keyword_1"),
  _keyword_2 = UI.getChildControl(Panel_Chat_SocialMenu, "Edit_Keyword_2"),
  _keyword_3 = UI.getChildControl(Panel_Chat_SocialMenu, "Edit_Keyword_3"),
  _desc = UI.getChildControl(Panel_Chat_SocialMenu, "StaticText_Desc"),
  _btnApply = UI.getChildControl(Panel_Chat_SocialMenu, "Button_Apply"),
  _btnReset = UI.getChildControl(Panel_Chat_SocialMenu, "Button_Reset"),
  _btnCancel = UI.getChildControl(Panel_Chat_SocialMenu, "Button_Cancel"),
  _descBG = UI.getChildControl(Panel_Chat_SocialMenu, "Static_DescBG"),
  _keyTitle = UI.getChildControl(Panel_Chat_SocialMenu, "StaticText_Key_Title")
}
Panel_Chat_SocialMenu:SetChildIndex(SocialAction._icon, 9999)
SocialAction._conditionText:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
SocialAction._desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
SocialAction._desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SOCIALACTION_DESC"))
function HandleClicked_Button(number, index)
  if 0 == number then
    ToClient_resetSocialActionInfo()
  elseif 1 == number then
    ToClient_cancelSocialActionInfo()
    FGlobal_SocialAction_ShowToggle()
    if false == CheckChattingInput() then
      ClearFocusEdit()
    end
  end
  SocialAction:Description_Setting(index)
end
local Control_Location_Save = {
  _panelSizeX = Panel_Chat_SocialMenu:GetSizeX(),
  _panelSizeY = Panel_Chat_SocialMenu:GetSizeY(),
  _descBGSizeX = SocialAction._descBG:GetSizeX(),
  _descBGSizeY = SocialAction._descBG:GetSizeY(),
  _keyTitlePosY = SocialAction._keyTitle:GetPosY(),
  _keywordPosY = SocialAction._keyword_1:GetPosY(),
  _descPosY = SocialAction._desc:GetPosY(),
  _bottomBtnPosY = SocialAction._btnApply:GetPosY(),
  _mainBgSizeX = mainBg:GetSizeX(),
  _mainBgSizeY = mainBg:GetSizeY()
}
local isConditionGap = 25
function HandleClicked_Apply(index)
  local self = SocialAction
  local _command = self._command:GetEditText()
  local keyword_1 = self._keyword_1:GetEditText()
  local keyword_2 = self._keyword_2:GetEditText()
  local keyword_3 = self._keyword_3:GetEditText()
  local keyWordValue = ""
  local keyword1 = PAGetString(Defines.StringSheet_GAME, "LUA_SOCIALACTION_KEYWORD_1")
  local keyword2 = PAGetString(Defines.StringSheet_GAME, "LUA_SOCIALACTION_KEYWORD_2")
  local keyword3 = PAGetString(Defines.StringSheet_GAME, "LUA_SOCIALACTION_KEYWORD_3")
  if keyword1 ~= keyword_1 then
    keyWordValue = keyword_1
    if keyword2 ~= keyword_2 then
      keyWordValue = keyWordValue .. ";" .. keyword_2
      if keyword3 ~= keyword_3 then
        keyWordValue = keyWordValue .. ";" .. keyword_3
      end
    end
  end
  local socialActionInfo = ToClient_getSocialActionInfoByIndex(index)
  local sASS = socialActionInfo:getStaticStatus()
  ToClient_setSocialActionCommand(sASS:getKey(), _command)
  ToClient_setSocialActionKeyword(sASS:getKey(), keyWordValue)
  ToClient_applySocialActionInfo()
  SocialAction:Description_Setting(index)
end
function SocialAction:Description_Setting(index)
  ToClient_getSocialActionInfoList()
  local socialActionInfo = ToClient_getSocialActionInfoByIndex(index)
  local sASS = socialActionInfo:getStaticStatus()
  local socialKey = sASS:getKey()
  local allKeyword = socialActionInfo:getKeywordBuffer()
  self._name:SetText(sASS:getName())
  self._conditionText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SOCIALACTION_CONDITIONTEXT") .. sASS:getConditionMessage())
  self._icon:ChangeTextureInfoName("Icon/" .. sASS:getIconPath())
  self._icon:addInputEvent("Mouse_LUp", "ToClient_requestStartSocialAction(" .. socialKey .. ")")
  self._command:SetEditText(socialActionInfo:getCommand())
  local cls = Control_Location_Save
  if "" == sASS:getConditionMessage() then
    self._conditionText:SetShow(false)
    Panel_Chat_SocialMenu:SetSize(cls._panelSizeX, cls._panelSizeY)
    self._descBG:SetSize(cls._descBGSizeX, cls._descBGSizeY)
    self._keyTitle:SetPosY(cls._keyTitlePosY)
    self._keyword_1:SetPosY(cls._keywordPosY)
    self._keyword_2:SetPosY(cls._keywordPosY)
    self._keyword_3:SetPosY(cls._keywordPosY)
    self._desc:SetPosY(cls._descPosY)
    self._btnApply:SetPosY(cls._bottomBtnPosY)
    self._btnReset:SetPosY(cls._bottomBtnPosY)
    self._btnCancel:SetPosY(cls._bottomBtnPosY)
    mainBg:SetSize(cls._mainBgSizeX, cls._mainBgSizeY)
    mainBg:ComputePos()
  else
    self._conditionText:SetShow(true)
    if self._conditionText:GetSizeY() < self._conditionText:GetTextSizeY() then
      isConditionGap = self._conditionText:GetTextSizeY() + 10
    else
      isConditionGap = 30
    end
    Panel_Chat_SocialMenu:SetSize(cls._panelSizeX, cls._panelSizeY + isConditionGap)
    mainBg:SetSize(cls._mainBgSizeX, cls._mainBgSizeY + isConditionGap)
    mainBg:ComputePos()
    self._descBG:SetSize(cls._descBGSizeX, cls._descBGSizeY + isConditionGap)
    self._keyTitle:SetPosY(cls._keyTitlePosY + isConditionGap)
    self._keyword_1:SetPosY(cls._keywordPosY + isConditionGap)
    self._keyword_2:SetPosY(cls._keywordPosY + isConditionGap)
    self._keyword_3:SetPosY(cls._keywordPosY + isConditionGap)
    self._desc:SetPosY(cls._descPosY + isConditionGap)
    self._btnApply:SetPosY(cls._bottomBtnPosY + isConditionGap)
    self._btnReset:SetPosY(cls._bottomBtnPosY + isConditionGap)
    self._btnCancel:SetPosY(cls._bottomBtnPosY + isConditionGap)
  end
  local stringren = string.len(allKeyword)
  local semicolonCount = 0
  local locationSemicolon = 0
  local stringStartIndex = 1
  local keyWord = {}
  while true do
    locationSemicolon = string.find(allKeyword, ";", locationSemicolon + 1)
    if locationSemicolon == nil then
      break
    end
    local string = string.sub(allKeyword, stringStartIndex, locationSemicolon - 1)
    if nil == string then
      string = ""
    end
    keyWord[semicolonCount] = string
    stringStartIndex = locationSemicolon + 1
    semicolonCount = semicolonCount + 1
  end
  if semicolonCount < 3 then
    local string = string.sub(allKeyword, stringStartIndex, string.len(allKeyword))
    if nil == string then
      string = ""
    end
    keyWord[semicolonCount] = string
  end
  if nil == keyWord[2] then
    keyWord[2] = ""
  end
  self._keyword_1:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_SOCIALACTION_KEYWORD_1"))
  self._keyword_2:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_SOCIALACTION_KEYWORD_2"))
  self._keyword_3:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_SOCIALACTION_KEYWORD_3"))
  if "" ~= keyWord[0] then
    self._keyword_1:SetEditText(keyWord[0])
  end
  self._keyword_2:SetEditText(keyWord[1])
  self._keyword_3:SetEditText(keyWord[2])
  self._command:addInputEvent("Mouse_LUp", "HandleClicked_EditBox(" .. 0 .. ")")
  self._keyword_1:addInputEvent("Mouse_LUp", "HandleClicked_EditBox(" .. 1 .. ")")
  self._keyword_2:addInputEvent("Mouse_LUp", "HandleClicked_EditBox(" .. 2 .. ")")
  self._keyword_3:addInputEvent("Mouse_LUp", "HandleClicked_EditBox(" .. 3 .. ")")
  self._btnApply:addInputEvent("Mouse_LUp", "HandleClicked_Apply(" .. index .. ")")
  self._btnReset:addInputEvent("Mouse_LUp", "HandleClicked_Button(" .. 0 .. ", " .. index .. ")")
  self._btnCancel:addInputEvent("Mouse_LUp", "HandleClicked_Button(" .. 1 .. ", " .. index .. ")")
end
function HandleClicked_EditBox(editControlNo)
  if 0 == editControlNo then
    SetFocusEdit(SocialAction._command)
  elseif 1 == editControlNo then
    SetFocusEdit(SocialAction._keyword_1)
  elseif 2 == editControlNo then
    SetFocusEdit(SocialAction._keyword_2)
  elseif 3 == editControlNo then
    SetFocusEdit(SocialAction._keyword_3)
  end
end
function HandleClicked_SocialIcon(iconIndex)
  local socialIconCount = ToClient_getSocialActionInfoList()
  if 0 == socialIconCount then
    return
  end
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  Panel_SocialMenu_ResetVertexAni()
  _socialIconSlot[iconIndex]:ResetVertexAni()
  _socialIconSlot[iconIndex]:SetVertexAniRun("Ani_Color", true)
  _selectedSlotBG:SetPosX(_socialIconSlotBG[iconIndex]:GetPosX())
  _selectedSlotBG:SetPosY(_socialIconSlotBG[iconIndex]:GetPosY())
  _selectedSlotBG:SetShow(true)
  SocialAction:Description_Setting(iconIndex)
  HandleClicked_DoAction(iconIndex)
end
function HandleClicked_DoAction(iconIndex)
  local socialActionInfo = ToClient_getSocialActionInfoByIndex(iconIndex)
  local sASS = socialActionInfo:getStaticStatus()
  local socialKey = sASS:getKey()
  ToClient_requestStartSocialAction(socialKey)
end
function Show_Condition_SocialIcon(iconIndex, conditionCheck)
  if nil == iconIndex then
    TooltipSimple_Hide()
    return
  end
  local socialActionInfo = ToClient_getSocialActionInfoByIndex(iconIndex)
  local sASS = socialActionInfo:getStaticStatus()
  if true == conditionCheck then
    local name = sASS:getName()
    TooltipSimple_Show(_socialIconSlot[iconIndex], name)
  else
    local conditionText = sASS:getConditionMessage()
    if "" == conditionText then
      return
    end
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_SOCIALACTION_CONDITIONTEXT")
    TooltipSimple_Show(_socialIconSlot[iconIndex], name, conditionText)
  end
end
function FGlobal_SocialAction_ShowToggle()
  if Panel_Chat_SocialMenu:GetShow() then
    audioPostEvent_SystemUi(1, 1)
    _AudioPostEvent_SystemUiForXBOX(1, 1)
    Panel_Chat_SocialMenu:SetShow(false)
    FGlobal_SocialAction_SetCHK(false)
    TooltipSimple_Hide()
    return false
  elseif Panel_Chatting_Macro:IsShow() then
    Panel_Chatting_Macro:SetShow(false, false)
    SocialAction_Icon_Initialize()
    Panel_Chat_SocialMenu:SetShow(true)
    return true
  else
    audioPostEvent_SystemUi(1, 0)
    _AudioPostEvent_SystemUiForXBOX(1, 0)
    SocialAction_Icon_Initialize()
    Panel_Chat_SocialMenu:SetShow(true)
    return true
  end
  return false
end
SocialAction_Icon_Initialize()
HandleClicked_SocialIcon(0)
