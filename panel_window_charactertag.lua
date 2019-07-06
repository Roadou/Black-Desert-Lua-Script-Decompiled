local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_Class = CppEnums.ClassType
local UI_DefaultFaceTexture = CppEnums.ClassType_DefaultFaceTexture
local PP = CppEnums.PAUIMB_PRIORITY
local ePcWorkingType = CppEnums.PcWorkType
local const_64 = Defines.s64_const
local isDev = ToClient_IsDevelopment()
local isOpenCharacterTag = ToClient_IsContentsGroupOpen("330")
local LOCAL_DEFINE = {
  CHARSLOTCOLMAX = 6,
  CHARSLOTROWMAX = 2,
  CHARSLOTLISTMAX = 12,
  SCROLLVERTICAL = 270,
  NODUEL = -1
}
local CharacterTag = {
  _doTag = false,
  _UI = {
    _Static_CharacterList = {}
  },
  _requestCharacterKey = -1,
  _currentTagState = false,
  _selfCharTag = false,
  _maxCharacterCount = 0,
  _pageIndex = 0
}
local SHOW_TYPE = {
  NORMAL = 0,
  ARCHER_TAG = 1,
  TAKE_EXP = 2
}
local sideImg = {_page = -1, _index = -1}
local selectCharaterSlot = {_Lv = -1, _ClassType = -1}
function CharacterTag:Initialize()
  local selfUI = self._UI
  selfUI._StaticText_TagAreaTitle = UI.getChildControl(Panel_CharacterTag, "StaticText_TagAreaTitle")
  selfUI._StaticText_TagAreaValue = UI.getChildControl(Panel_CharacterTag, "StaticText_TagAreaValue")
  local aaa = UI.getChildControl(Panel_CharacterTag, "Static_MainImageBorder_1")
  local stc_mainImageBorder_2 = UI.getChildControl(Panel_CharacterTag, "Static_MainImageBorder_2")
  selfUI._Static_MainImage_1 = UI.getChildControl(Panel_CharacterTag, "Static_MainImage_1")
  selfUI._Static_MainImage_2 = UI.getChildControl(Panel_CharacterTag, "Static_MainImage_2")
  selfUI._Static_MainImage_2:addInputEvent("Mouse_RUp", "HandleEvent_Delete_TagCharacter()")
  selfUI._Static_QuestionIcon_2 = UI.getChildControl(selfUI._Static_MainImage_2, "Static_QuestionIcon")
  selfUI._CheckButton_showTypeNormal = UI.getChildControl(Panel_CharacterTag, "CheckButton_TagState")
  selfUI._CheckButton_showTypeTakeEXP = UI.getChildControl(Panel_CharacterTag, "CheckButton_TagState2")
  selfUI._Static_TopDeco_1 = UI.getChildControl(Panel_CharacterTag, "Static_TopDeco_1")
  selfUI._Static_TopDeco_2 = UI.getChildControl(Panel_CharacterTag, "Static_TopDeco_2")
  selfUI._Static_TopDeco_3 = UI.getChildControl(Panel_CharacterTag, "Static_TopDeco_3")
  selfUI._Static_TopDeco_4 = UI.getChildControl(Panel_CharacterTag, "Static_TopDeco_4")
  selfUI.Static_TopDeco_Left = UI.getChildControl(Panel_CharacterTag, "Static_TopDeco_Left")
  selfUI._Button_Close = UI.getChildControl(Panel_CharacterTag, "Button_Close")
  selfUI._Button_Close:addInputEvent("Mouse_LUp", "PaGlobal_CharacterTag_Close()")
  selfUI._CheckButton_PopUp = UI.getChildControl(Panel_CharacterTag, "CheckButton_PopUp")
  selfUI._CheckButton_PopUp:addInputEvent("Mouse_LUp", "CharacterTag_PopUp_UI()")
  selfUI._CheckButton_PopUp:addInputEvent("Mouse_On", "CharacterTag_PopUp_ShowIconToolTip(true)")
  selfUI._CheckButton_PopUp:addInputEvent("Mouse_Out", "CharacterTag_PopUp_ShowIconToolTip(false)")
  selfUI._StaticText_Name_1 = UI.getChildControl(Panel_CharacterTag, "StaticText_Name_1")
  selfUI._StaticText_Name_2 = UI.getChildControl(Panel_CharacterTag, "StaticText_Name_2")
  local descBg = UI.getChildControl(Panel_CharacterTag, "Static_DescBg")
  selfUI._StaticText_Desc = UI.getChildControl(descBg, "StaticText_Desc")
  selfUI._StaticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  selfUI._StaticText_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_DESC"))
  selfUI._StaticText_Desc:SetShow(true)
  local textSizeY = selfUI._StaticText_Desc:GetTextSizeY()
  local sumSizeY = textSizeY + 10 - descBg:GetSizeY()
  descBg:SetSize(descBg:GetSizeX(), textSizeY + 10)
  Panel_CharacterTag:SetSize(Panel_CharacterTag:GetSizeX(), Panel_CharacterTag:GetSizeY() + sumSizeY)
  descBg:ComputePos()
  selfUI._StaticText_Desc:ComputePos()
  local templateCharacterList = UI.getChildControl(Panel_CharacterTag, "Static_CharacterImageBorderTemplate")
  local templateImage = UI.getChildControl(templateCharacterList, "Static_Image")
  local templateLevel = UI.getChildControl(templateCharacterList, "StaticText_Level")
  local templateState = UI.getChildControl(templateCharacterList, "StaticText_State")
  local templateExpImg = UI.getChildControl(templateCharacterList, "Static_EXP")
  local templateExpBG = UI.getChildControl(templateCharacterList, "Static_BG")
  local mainBg = UI.getChildControl(Panel_CharacterTag, "Static_MainBg")
  mainBg:addInputEvent("Mouse_UpScroll", "PaGlobal_CharacterTag_ScrollEvent(true)")
  mainBg:addInputEvent("Mouse_DownScroll", "PaGlobal_CharacterTag_ScrollEvent(false)")
  local listBg = UI.getChildControl(Panel_CharacterTag, "Static_MidBg")
  listBg:addInputEvent("Mouse_UpScroll", "PaGlobal_CharacterTag_ScrollEvent(true)")
  listBg:addInputEvent("Mouse_DownScroll", "PaGlobal_CharacterTag_ScrollEvent(false)")
  templateExpBG:addInputEvent("Mouse_UpScroll", "PaGlobal_CharacterTag_ScrollEvent(true)")
  templateExpBG:addInputEvent("Mouse_DownScroll", "PaGlobal_CharacterTag_ScrollEvent(false)")
  self._maxCharacterCount = getCharacterDataCount()
  for index = 0, 5 do
    selfUI._Static_CharacterList[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CharacterTag, "Static_CharacterList_" .. index)
    CopyBaseProperty(templateCharacterList, selfUI._Static_CharacterList[index])
    local Static_Image = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, selfUI._Static_CharacterList[index], "Static_Image")
    CopyBaseProperty(templateImage, Static_Image)
    local StaticText_State = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, selfUI._Static_CharacterList[index], "StaticText_State")
    CopyBaseProperty(templateState, StaticText_State)
    local StaticText_Level = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, selfUI._Static_CharacterList[index], "StaticText_Level")
    CopyBaseProperty(templateLevel, StaticText_Level)
    local Static_EXP = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, selfUI._Static_CharacterList[index], "Static_EXP")
    CopyBaseProperty(templateExpImg, Static_EXP)
    local Static_BG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, selfUI._Static_CharacterList[index], "Static_BG")
    CopyBaseProperty(templateExpBG, Static_BG)
    Static_BG:SetShow(false)
    selfUI._Static_CharacterList[index]:SetShow(false)
    selfUI._Static_CharacterList[index]:addInputEvent("Mouse_UpScroll", "PaGlobal_CharacterTag_ScrollEvent(true)")
    selfUI._Static_CharacterList[index]:addInputEvent("Mouse_DownScroll", "PaGlobal_CharacterTag_ScrollEvent(false)")
    Static_BG:addInputEvent("Mouse_UpScroll", "PaGlobal_CharacterTag_ScrollEvent(true)")
    Static_BG:addInputEvent("Mouse_DownScroll", "PaGlobal_CharacterTag_ScrollEvent(false)")
    selfUI._Static_CharacterList[index]:SetPosX(10 + listBg:GetPosX() + 110 * (index % LOCAL_DEFINE.CHARSLOTCOLMAX))
    selfUI._Static_CharacterList[index]:SetPosY(25 + listBg:GetPosY() + math.floor(index / LOCAL_DEFINE.CHARSLOTCOLMAX) * 138)
  end
  templateCharacterList:SetShow(false)
  templateCharacterList:SetIgnore(true)
  selfUI._CheckButton_showTypeNormal:addInputEvent("Mouse_LUp", "HandleEvent_ClickRequestTag()")
  selfUI._CheckButton_showTypeNormal:SetIgnore(false)
  selfUI._CheckButton_showTypeTakeEXP:addInputEvent("Mouse_LUp", "HandleEvent_ClickRequestTag()")
  selfUI._CheckButton_showTypeTakeEXP:SetIgnore(false)
  selfUI._Scroll_Tag = UI.getChildControl(Panel_CharacterTag, "Scroll_Tag")
  selfUI._Scroll_CtrlButton = UI.getChildControl(selfUI._Scroll_Tag, "Scroll_CtrlButton")
  selfUI._StaticText_TagState = UI.getChildControl(Panel_CharacterTag, "StaticText_TagState")
  UIScroll.SetButtonSize(selfUI._Scroll_Tag, 1, math.ceil(self._maxCharacterCount / 6))
  UIScroll.InputEvent(selfUI._Scroll_Tag, "PaGlobal_CharacterTag_ScrollEvent")
  selfUI._Button_TakeEXP = UI.getChildControl(Panel_CharacterTag, "Button_TakeEXP")
  selfUI._Button_TakeEXP:addInputEvent("Mouse_LUp", "HandleEvent_CharacterTagButton()")
  selfUI._Button_TakeEXP:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_BUTTON_TAKEEXP"))
  selfUI.Button_CharTag = UI.getChildControl(Panel_CharacterTag, "Button_CharTag")
  selfUI.Button_CharTag:addInputEvent("Mouse_LUp", "HandleEvent_ClickRequestTag()")
  selfUI._Static_TopBg = UI.getChildControl(Panel_CharacterTag, "Static_TopBg")
  selfUI.StaticText_getEXP_Right = UI.getChildControl(selfUI._Static_TopBg, "StaticText_getEXP_Right")
  selfUI.StaticText_getSkillEXP_Right = UI.getChildControl(selfUI._Static_TopBg, "StaticText_getSkillEXP_Right")
  selfUI.StaticText_getEXP_Right:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_GETEXP"))
  selfUI.StaticText_getSkillEXP_Right:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_GETSKILLEXP"))
  selfUI.StaticText_getEXP_Left = UI.getChildControl(selfUI._Static_TopBg, "StaticText_getEXP_Left")
  selfUI.StaticText_getSkillEXP_Left = UI.getChildControl(selfUI._Static_TopBg, "StaticText_getSkillEXP_Left")
  selfUI.StaticText_getEXP_Left:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_GETEXP"))
  selfUI.StaticText_getSkillEXP_Left:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_GETSKILLEXP"))
  selfUI._StaticText_EventDesc = UI.getChildControl(Panel_CharacterTag, "StaticText_EventDesc")
  selfUI._StaticText_EventDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAKEEXP_EVENT"))
  selfUI._StaticText_EventDesc:SetShow(_ContentsGroup_AddExpEvent_TagCharacter)
  if false == _ContentsGroup_AddExpEvent_TagCharacter then
    selfUI._Static_TopBg:SetPosY(selfUI._Static_TopBg:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI._Static_MainImage_1:SetPosY(selfUI._Static_MainImage_1:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI._Static_MainImage_2:SetPosY(selfUI._Static_MainImage_2:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI.Button_CharTag:SetPosY(selfUI.Button_CharTag:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    aaa:SetPosY(aaa:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    stc_mainImageBorder_2:SetPosY(stc_mainImageBorder_2:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI._StaticText_Name_1:SetPosY(selfUI._StaticText_Name_1:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI._StaticText_Name_2:SetPosY(selfUI._StaticText_Name_2:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI._StaticText_TagAreaTitle:SetPosY(selfUI._StaticText_TagAreaTitle:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI._StaticText_TagAreaValue:SetPosY(selfUI._StaticText_TagAreaValue:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI._Static_TopDeco_1:SetPosY(selfUI._Static_TopDeco_1:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI._Static_TopDeco_2:SetPosY(selfUI._Static_TopDeco_2:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI._Static_TopDeco_3:SetPosY(selfUI._Static_TopDeco_3:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI._Static_TopDeco_4:SetPosY(selfUI._Static_TopDeco_4:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI.Static_TopDeco_Left:SetPosY(selfUI.Static_TopDeco_Left:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI._CheckButton_showTypeNormal:SetPosY(selfUI._CheckButton_showTypeNormal:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
    selfUI._CheckButton_showTypeTakeEXP:SetPosY(selfUI._CheckButton_showTypeTakeEXP:GetPosY() - selfUI._StaticText_EventDesc:GetTextSizeY())
  end
end
function PaGlobal_Request_TagCharacter(characterKey)
  ToClient_RequestDuelCharacter(characterKey)
end
function PaGlobal_Delete_TagCharacter(characterKey)
  ToClient_RequestDeleteDuelCharacter(characterKey)
end
function HandleEvent_ClickRequestTag()
  local self = CharacterTag
  self._UI._CheckButton_showTypeNormal:SetCheck(self._currentTagState)
  self._UI._CheckButton_showTypeTakeEXP:SetCheck(self._currentTagState)
  if false == self._selfCharTag then
    return
  end
  if LOCAL_DEFINE.NODUEL == self._requestCharacterKey then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_NEEDSELECTCHARACTER"))
    return
  end
  if self._currentTagState then
    PaGlobal_Delete_TagCharacter(self._requestCharacterKey)
  else
    PaGlobal_Request_TagCharacter(self._requestCharacterKey)
  end
end
function HandleEvent_Delete_TagCharacter()
  local self = CharacterTag
  self._UI._CheckButton_showTypeNormal:SetCheck(self._currentTagState)
  self._UI._CheckButton_showTypeTakeEXP:SetCheck(self._currentTagState)
  if false == self._selfCharTag then
    return
  end
  if LOCAL_DEFINE.NODUEL == self._requestCharacterKey then
    return
  end
  if self._currentTagState then
    PaGlobal_Delete_TagCharacter(self._requestCharacterKey)
  end
end
function PaGlobal_IsTagChange()
  local retBool = CharacterTag._doTag
  if true == CharacterTag._doTag then
    CharacterTag._doTag = false
  end
  return retBool
end
function PaGlobal_TagCharacter_Change()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local index = ToClient_GetMyDuelCharacterIndex()
  if LOCAL_DEFINE.NODUEL == index then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_CURRENT_NOT_TAGGING"))
    return
  end
  if true == ToClient_getJoinGuildBattle() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_CANTDO_GUILDBATTLE"))
    return
  end
  local regionInfo = getRegionInfoByPosition(selfPlayer:get():getPosition())
  if true == regionInfo:isPrison() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERTAG_PRISON_CANT_TAG"))
    return
  end
  CharacterTag._doTag = true
  Panel_GameExit_ChangeCharacter(index)
end
function CharacterTag:SetLeftFace(idx, isRegionKey)
  local characterData = getCharacterDataByIndex(idx)
  local char_Type = getCharacterClassType(characterData)
  local char_Level = string.format("%d", characterData._level)
  local char_Name = getCharacterName(characterData)
  local char_TextureName = getCharacterFaceTextureByIndex(idx)
  local duelChar_No_s64 = characterData._duelCharacterNo
  local duelRegion_Key = characterData._duelRegionKey
  local isCaptureExist = self._UI._Static_MainImage_1:ChangeTextureInfoNameNotDDS(char_TextureName, char_Type, PaGlobal_getIsExitPhoto())
  if true == isCaptureExist then
    self._UI._Static_MainImage_1:getBaseTexture():setUV(0, 0, 1, 1)
  else
    self:FaceSetting(self._UI._Static_MainImage_1, char_Type)
  end
  self._UI._Static_MainImage_1:setRenderTexture(self._UI._Static_MainImage_1:getBaseTexture())
  self._UI._StaticText_Name_1:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. char_Level .. " " .. char_Name)
  local RegionInfo = getRegionInfoByRegionKey(duelRegion_Key)
  if nil ~= RegionInfo then
    self._UI._StaticText_TagAreaValue:SetText(getRegionInfoByRegionKey(duelRegion_Key):getAreaName())
  end
end
function CharacterTag:SetRightFace(idx)
  local characterData = getCharacterDataByIndex(idx)
  local char_Type = getCharacterClassType(characterData)
  local char_Level = string.format("%d", characterData._level)
  local char_Name = getCharacterName(characterData)
  local char_TextureName = getCharacterFaceTextureByIndex(idx)
  local duelChar_No_s64 = characterData._duelCharacterNo
  local duelRegion_Key = characterData._duelRegionKey
  local isCaptureExist = self._UI._Static_MainImage_2:ChangeTextureInfoNameNotDDS(char_TextureName, char_Type, PaGlobal_getIsExitPhoto())
  if true == isCaptureExist then
    self._UI._Static_MainImage_2:getBaseTexture():setUV(0, 0, 1, 1)
  else
    self:FaceSetting(self._UI._Static_MainImage_2, char_Type)
  end
  self._UI._Static_MainImage_2:setRenderTexture(self._UI._Static_MainImage_2:getBaseTexture())
  self._UI._StaticText_Name_2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. char_Level .. " " .. char_Name)
  self._requestCharacterKey = characterData._characterNo_s64
  selectCharaterSlot._Lv = characterData._level
  selectCharaterSlot._ClassType = char_Type
end
function CharacterTag:LoadMainFace()
  local selfPlayer = getSelfPlayer()
  local duelCharIndex = ToClient_GetMyDuelCharacterIndex()
  local selfCharIndex = ToClient_GetMyCharacterIndex()
  local isSetLeft = false
  local isSetRight = false
  local selfPlayerChar_No_s64 = selfPlayer:getCharacterNo_64()
  local selfPos = float3(selfPlayer:get():getPositionX(), selfPlayer:get():getPositionY(), selfPlayer:get():getPositionZ())
  self._UI._StaticText_TagAreaValue:SetText(getRegionInfoByPosition(selfPos):getAreaName())
  local characterCount = getCharacterDataCount() - 1
  self._UI._StaticText_TagState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_ALREADY_TAG"))
  if LOCAL_DEFINE.NODUEL == duelCharIndex then
    self._selfCharTag = false
    for idx = 0, characterCount do
      local characterData = getCharacterDataByIndex(idx)
      local duelChar_No_s64 = characterData._duelCharacterNo
      local duelChar_No_s32 = Int64toInt32(duelChar_No_s64)
      if LOCAL_DEFINE.NODUEL ~= duelChar_No_s32 then
        if false == isSetLeft then
          self:SetLeftFace(idx)
          isSetLeft = true
          self._UI._CheckButton_showTypeNormal:SetCheck(true)
          self._UI._CheckButton_showTypeTakeEXP:SetCheck(true)
        else
          self:SetRightFace(idx)
          isSetRight = true
          self._currentTagState = true
          self._UI._Static_QuestionIcon_2:SetShow(false)
        end
      end
    end
    if false == isSetLeft or false == isSetRight then
      isSetLeft = true
      self:SetLeftFace(selfCharIndex, false)
      self._UI._CheckButton_showTypeNormal:SetCheck(false)
      self._UI._CheckButton_showTypeTakeEXP:SetCheck(false)
      self._UI._Static_MainImage_2:ChangeTextureInfoName("")
      self._UI._StaticText_Name_2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_SETTING_TARGET"))
      self._selfCharTag = true
      self._currentTagState = false
      self._UI._Static_QuestionIcon_2:SetShow(true)
      self._UI._StaticText_TagState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_CANDO"))
    end
  else
    isSetLeft = true
    self:SetLeftFace(selfCharIndex)
    self:SetRightFace(duelCharIndex)
    self._currentTagState = true
    self._UI._CheckButton_showTypeNormal:SetCheck(true)
    self._UI._CheckButton_showTypeTakeEXP:SetCheck(true)
    self._selfCharTag = true
    self._UI._Static_QuestionIcon_2:SetShow(false)
  end
  if false == self._selfCharTag then
    self._UI._CheckButton_showTypeNormal:SetMonoTone(true)
    self._UI._CheckButton_showTypeNormal:SetIgnore(true)
    self._UI._CheckButton_showTypeTakeEXP:SetMonoTone(true)
    self._UI._CheckButton_showTypeTakeEXP:SetIgnore(true)
  end
end
function CharacterTag:FaceSetting(targetImage, char_Type)
  if _ContentsGroup_isUsedNewCharacterInfo == false then
    if char_Type == UI_Class.ClassType_Warrior then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 1, 1, 156, 201)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_Ranger then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 157, 1, 312, 201)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_Sorcerer then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 313, 1, 468, 201)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_Giant then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 1, 202, 156, 402)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_Tamer then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 157, 202, 312, 402)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_BladeMaster then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 313, 202, 468, 402)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_Valkyrie then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 1, 1, 156, 201)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_BladeMasterWomen then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 157, 1, 312, 201)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_Wizard then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 313, 1, 468, 201)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_WizardWomen then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 1, 202, 156, 402)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_NinjaWomen then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 157, 202, 312, 402)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_NinjaMan then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 313, 202, 468, 402)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_DarkElf then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_02.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 1, 1, 156, 201)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_Combattant then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_02.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 157, 1, 312, 201)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    elseif char_Type == UI_Class.ClassType_CombattantWomen then
      targetImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_02.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(targetImage, 313, 1, 468, 201)
      targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
      targetImage:setRenderTexture(targetImage:getBaseTexture())
    end
  else
    local DefaultFace = UI_DefaultFaceTexture[char_Type]
    targetImage:ChangeTextureInfoName(DefaultFace[1])
    local x1, y1, x2, y2 = setTextureUV_Func(targetImage, DefaultFace[2], DefaultFace[3], DefaultFace[4], DefaultFace[5])
    targetImage:getBaseTexture():setUV(x1, y1, x2, y2)
  end
end
function HandleEvent_ClickCharacterList(charIndex)
  local self = CharacterTag
  local slotNo = LOCAL_DEFINE.CHARSLOTCOLMAX * self._pageIndex
  local charMaxCount = getCharacterDataCount()
  if charIndex < 0 or charIndex > charMaxCount then
    return
  end
  self:SetRightFace(charIndex)
  self._UI._Static_QuestionIcon_2:SetShow(false)
  local characterData = getCharacterDataByIndex(charIndex)
  self._requestCharacterKey = characterData._characterNo_s64
  for idx = 0, 5 do
    local targetUI = self._UI._Static_CharacterList[idx]
    local Static_BG = UI.getChildControl(targetUI, "Static_BG")
    if idx == charIndex - slotNo then
      Static_BG:SetShow(true)
      sideImg._page = self._pageIndex
      sideImg._index = idx
    else
      Static_BG:SetShow(false)
    end
  end
end
function CharacterTag:LoadList()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local isSetLeft = false
  local selfPlayerIndex = ToClient_GetMyCharacterIndex()
  local selfPlayerChar_No_s64 = selfPlayer:getCharacterNo_64()
  local selfPos = float3(selfPlayer:get():getPositionX(), selfPlayer:get():getPositionY(), selfPlayer:get():getPositionZ())
  local selfPlayerRegionInfoKey = getRegionInfoByPosition(selfPos):getRegionKey()
  local duelCharIndex = ToClient_GetMyDuelCharacterIndex()
  local characterListMax = getCharacterDataCount()
  for jj = 0, 5 do
    self._UI._Static_CharacterList[jj]:SetShow(false)
  end
  for idx = 0, 5 do
    local ii = idx + self._pageIndex * 6
    if ii > characterListMax - 1 then
      return
    end
    local targetUI = self._UI._Static_CharacterList[idx]
    local targetLevel = UI.getChildControl(targetUI, "StaticText_Level")
    local targetImage = UI.getChildControl(targetUI, "Static_Image")
    local targetState = UI.getChildControl(targetUI, "StaticText_State")
    local targetExpIMG = UI.getChildControl(targetUI, "Static_EXP")
    local characterData = getCharacterDataByIndex(ii)
    local char_Type = getCharacterClassType(characterData)
    local char_Level = string.format("%d", characterData._level)
    local char_Name = getCharacterName(characterData)
    local char_No_s64 = characterData._characterNo_s64
    local char_TextureName = getCharacterFaceTextureByIndex(ii)
    local pcDeliveryRegionKey = characterData._arrivalRegionKey
    local char_float3_position = characterData._currentPosition
    local duelChar_No_s64 = characterData._duelCharacterNo
    local duelRegion_Key = characterData._duelRegionKey
    local currentChar_Tag = false
    targetUI:SetShow(true)
    self:SetMonotoneIgnore(targetUI, targetImage, false)
    targetState:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    targetState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_CANDO"))
    local isCaptureExist = targetImage:ChangeTextureInfoNameNotDDS(char_TextureName, char_Type, PaGlobal_getIsExitPhoto())
    if isCaptureExist == true then
      targetImage:getBaseTexture():setUV(0, 0, 1, 1)
    else
      self:FaceSetting(targetImage, char_Type)
    end
    targetImage:setRenderTexture(targetImage:getBaseTexture())
    targetLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. char_Level)
    targetState:SetShow(true)
    targetImage:addInputEvent("Mouse_LUp", "HandleEvent_ClickCharacterList(" .. tostring(ii) .. ")")
    targetImage:addInputEvent("Mouse_UpScroll", "PaGlobal_CharacterTag_ScrollEvent(true)")
    targetImage:addInputEvent("Mouse_DownScroll", "PaGlobal_CharacterTag_ScrollEvent(false)")
    local regionInfo = getRegionInfoByPosition(char_float3_position)
    local serverUtc64 = getServerUtc64()
    local workingText
    if false == _ContentsGroup_RenewUI_ExitGame then
      workingText = global_workTypeToStringSwap(characterData._pcWorkingType)
    else
      workingText = PaGlobalFunc_GameExit_workTypeToStringSwap(characterData._pcWorkingType)
    end
    if 0 ~= pcDeliveryRegionKey:get() and serverUtc64 < characterData._arrivalTime then
      self:SetMonotoneIgnore(targetUI, targetImage, true)
      targetState:SetText(PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_DELIVERY"))
    elseif selfPlayerRegionInfoKey ~= pcDeliveryRegionKey:get() and 0 ~= pcDeliveryRegionKey:get() and serverUtc64 > characterData._arrivalTime then
      local retionInfoArrival = getRegionInfoByRegionKey(pcDeliveryRegionKey)
      self:SetMonotoneIgnore(targetUI, targetImage, true)
      targetState:SetText(tostring(retionInfoArrival:getAreaName()))
    elseif "" ~= workingText then
      targetState:SetText(workingText)
      self:SetMonotoneIgnore(targetUI, targetImage, true)
    elseif LOCAL_DEFINE.NODUEL ~= Int64toInt32(duelChar_No_s64) then
      self:SetMonotoneIgnore(targetUI, targetImage, true)
      targetState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_ALREADY_TAG"))
    elseif selfPlayerRegionInfoKey ~= regionInfo:getRegionKey() or false == regionInfo:get():isMainOrMinorTown() then
      self:SetMonotoneIgnore(targetUI, targetImage, true)
      targetState:SetText(tostring(regionInfo:getAreaName()))
    end
    if selfPlayerRegionInfoKey == pcDeliveryRegionKey:get() and 0 ~= pcDeliveryRegionKey:get() and serverUtc64 > characterData._arrivalTime then
      self:SetMonotoneIgnore(targetUI, targetImage, false)
      targetState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_CANDO"))
    end
    local removeTime = getCharacterDataRemoveTime(idx)
    if nil ~= removeTime then
      self:SetMonotoneIgnore(targetUI, targetImage, true)
      targetState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTER_DELETE"))
    end
    if ii == selfPlayerIndex then
      targetState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_LASTONLINETIME"))
      self:SetMonotoneIgnore(targetUI, targetImage, true)
    end
    if true == self._currentTagState then
      self:SetMonotoneIgnore(targetUI, targetImage, true)
      targetState:SetText(tostring(regionInfo:getAreaName()))
    end
    if true == _ContentsGroup_AddExpEvent_TagCharacter then
      if true == ToClient_isDuelCharacterExpClass(char_Type) then
        targetExpIMG:SetShow(true)
      else
        targetExpIMG:SetShow(false)
      end
    end
  end
end
function CharacterTag:SetMonotoneIgnore(UIControl, ImageControl, value)
  UIControl:SetIgnore(value)
  ImageControl:SetMonoTone(value)
  ImageControl:SetIgnore(value)
end
function CharacterTag:Clear()
  self._UI._CheckButton_showTypeNormal:SetIgnore(false)
  self._UI._CheckButton_showTypeNormal:SetMonoTone(false)
  self._UI._CheckButton_showTypeTakeEXP:SetIgnore(false)
  self._UI._CheckButton_showTypeTakeEXP:SetMonoTone(false)
  self._UI._Static_MainImage_2:SetShow(true)
  self._UI._Static_QuestionIcon_2:SetShow(true)
  self._UI._Static_MainImage_2:ChangeTextureInfoName("")
  self._UI._Static_MainImage_2:setRenderTexture(self._UI._Static_MainImage_2:getBaseTexture())
  self._requestCharacterKey = -1
  for ii = 0, 5 do
    self._UI._Static_CharacterList[ii]:SetShow(false)
  end
end
function CharacterTag:WindowPosition()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local panelSizeX = Panel_CharacterTag:GetSizeX()
  local panelSizeY = Panel_CharacterTag:GetSizeY()
  Panel_CharacterTag:SetPosX(screenSizeX / 2 - panelSizeX / 2)
  Panel_CharacterTag:SetPosY(math.max(0, (screenSizeY - panelSizeY) / 2))
end
function CharacterTag:Open()
  if false == isOpenCharacterTag then
    return
  end
  if -1 == ToClient_GetMyCharacterIndex() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WARNING_PREMIUMCHARACTER"))
    return
  end
  self:WindowPosition()
  self:Clear()
  self:LoadMainFace()
  self:LoadList()
  CharacterTag:expInfoShow()
  Panel_CharacterTag:SetShow(true, true)
end
function CharacterTag:Close()
  Panel_CharacterTag:CloseUISubApp()
  self._UI._CheckButton_PopUp:SetCheck(false)
  Panel_CharacterTag:SetShow(false, false)
end
function CharacterTag:showManager(showModeNum, CharLV)
  self._UI._Button_TakeEXP:SetShow(false)
  self._UI.Button_CharTag:SetShow(true)
  self._UI.StaticText_getEXP_Right:SetShow(false)
  self._UI.StaticText_getSkillEXP_Right:SetShow(false)
  self._UI.StaticText_getEXP_Left:SetShow(false)
  self._UI.StaticText_getSkillEXP_Left:SetShow(false)
  if -1 == ToClient_GetMyDuelCharacterIndex() and true == self._currentTagState then
    self._UI.Button_CharTag:SetShow(false)
  end
  if false == _ContentsGroup_AddExpEvent_TagCharacter and false == ToClient_doHaveDuelExp() then
    showModeNum = 0
  end
  for idx = 0, 5 do
    local targetUI = self._UI._Static_CharacterList[idx]
    local Static_BG = UI.getChildControl(targetUI, "Static_BG")
    Static_BG:SetShow(false)
    sideImg._page = -1
    sideImg._index = -1
  end
  if true == ToClient_doHaveDuelExp() then
    self._UI._Button_TakeEXP:SetShow(true)
    self._UI.Button_CharTag:SetShow(false)
  else
    self._UI._Button_TakeEXP:SetShow(false)
    self._UI.Button_CharTag:SetShow(true)
  end
  if SHOW_TYPE.NORMAL == showModeNum or -1 == ToClient_GetMyDuelCharacterIndex() then
    CharacterTag._UI._Static_TopDeco_1:SetShow(true)
    CharacterTag._UI._Static_TopDeco_2:SetShow(true)
    CharacterTag._UI._Static_TopDeco_3:SetShow(false)
    CharacterTag._UI._Static_TopDeco_4:SetShow(false)
    CharacterTag._UI.Static_TopDeco_Left:SetShow(false)
    CharacterTag._UI._CheckButton_showTypeNormal:SetShow(true)
    CharacterTag._UI._CheckButton_showTypeTakeEXP:SetShow(false)
    CharacterTag._UI._StaticText_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_DESC"))
  elseif showModeNum >= SHOW_TYPE.ARCHER_TAG then
    CharacterTag._UI._Static_TopDeco_1:SetShow(false)
    CharacterTag._UI._Static_TopDeco_2:SetShow(false)
    CharacterTag._UI._Static_TopDeco_3:SetShow(true)
    CharacterTag._UI._Static_TopDeco_4:SetShow(true)
    CharacterTag._UI.Static_TopDeco_Left:SetShow(false)
    CharacterTag._UI._CheckButton_showTypeNormal:SetShow(false)
    CharacterTag._UI._CheckButton_showTypeTakeEXP:SetShow(true)
    CharacterTag._UI._StaticText_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAKEEXP_DESC"))
    CharacterTag:changeExpBG()
  end
  if true == self._currentTagState then
    self._UI.Button_CharTag:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_DELETEDUEL"))
  else
    self._UI.Button_CharTag:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_REQUESTDUEL"))
  end
end
function CharacterTag:expInfoShow()
  local showType = SHOW_TYPE.NORMAL
  local subCharacter = getCharacterDataByIndex(ToClient_GetMyDuelCharacterIndex())
  local subCharacterLV = 0
  if true == ToClient_isDuelCharacterExpClass(getSelfPlayer():getClassType()) then
    showType = SHOW_TYPE.ARCHER_TAG
  end
  if nil ~= subCharacter then
    local subType = getCharacterClassType(subCharacter)
    if true == ToClient_isDuelCharacterExpClass(subType) then
      showType = SHOW_TYPE.TAKE_EXP
    end
    subCharacterLV = subCharacter._level
  end
  self:showManager(showType, subCharacterLV)
end
function CharacterTag:changeExpBG()
  if -1 == ToClient_GetMyDuelCharacterIndex() then
    return
  end
  local characterData = getCharacterDataByIndex(ToClient_GetMyDuelCharacterIndex())
  local char_Type = getCharacterClassType(characterData)
  local CharLV = characterData._level
  if true == ToClient_isDuelCharacterExpClass(char_Type) and false == ToClient_isDuelCharacterExpClass(getSelfPlayer():getClassType()) then
    self._UI.StaticText_getEXP_Left:SetShow(true)
    self._UI.StaticText_getSkillEXP_Left:SetShow(true)
    self._UI.Static_TopDeco_Left:SetShow(true)
    self._UI.StaticText_getEXP_Right:SetShow(false)
    self._UI.StaticText_getSkillEXP_Right:SetShow(false)
    self._UI._Static_TopDeco_3:SetShow(false)
    CharLV = getSelfPlayer():get():getLevel()
  else
    self._UI.StaticText_getEXP_Left:SetShow(false)
    self._UI.StaticText_getSkillEXP_Left:SetShow(false)
    self._UI.Static_TopDeco_Left:SetShow(false)
    self._UI.StaticText_getEXP_Right:SetShow(true)
    self._UI.StaticText_getSkillEXP_Right:SetShow(true)
    self._UI._Static_TopDeco_3:SetShow(true)
  end
  if nil ~= CharLV and CharLV > 0 and CharLV >= ToClient_getSubDuelCharacterLimitLevel() then
    self._UI.StaticText_getEXP_Right:SetShow(false)
    self._UI.StaticText_getEXP_Left:SetShow(false)
  end
end
function InitializeCharacterTag()
  CharacterTag:Initialize()
end
function FromClient_SuccessRequest()
  local showModeNum = 0
  local mainCharater = getCharacterDataByIndex(ToClient_GetMyCharacterIndex())
  local subCharacter = getCharacterDataByIndex(ToClient_GetMyDuelCharacterIndex())
  local subCharacterLV = 0
  if nil ~= mainCharater and true == ToClient_isDuelCharacterExpClass(mainCharater) then
    expUI_Show = 1
  end
  if nil ~= subCharacter then
    local subType = getCharacterClassType(subCharacter)
    if true == ToClient_isDuelCharacterExpClass(subType) then
      expUI_Show = 2
    end
    subCharacterLV = subCharacter._level
  end
  CharacterTag:showManager(showModeNum, subCharacterLV)
  CharacterTag:Open()
end
function FromClient_SuccessDelete()
  local showModeNum = 0
  CharacterTag._doTag = false
  CharacterTag:Open()
  if true == ToClient_isDuelCharacterExpClass(getSelfPlayer():getClassType()) then
    showModeNum = 1
  end
  CharacterTag:showManager(showModeNum)
end
function FromClient_NotifyUpdateDuelCharacterExp(result)
  if true == result then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TAKEEXP_WARNING"))
    return
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_TAKEEXP_SUCCESS"))
    CharacterTag._UI._Button_TakeEXP:SetShow(false)
    CharacterTag._UI.Button_CharTag:SetShow(true)
    CharacterTag._UI.Button_CharTag:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_DELETEDUEL"))
    if false == _ContentsGroup_AddExpEvent_TagCharacter then
      CharacterTag:showManager(0)
    end
  end
end
function PaGlobal_CharacterTag_Open()
  CharacterTag:Open()
end
function PaGlobal_CharacterTag_Close()
  CharacterTag:Close()
end
function PaGlobal_CharacterTag_ScrollEvent(isUp)
  local self = CharacterTag
  self._pageIndex = UIScroll.ScrollEvent(self._UI._Scroll_Tag, isUp, 1, math.ceil(self._maxCharacterCount / 6), self._pageIndex, 1)
  for idx = 0, 5 do
    local targetUI = self._UI._Static_CharacterList[idx]
    local Static_BG = UI.getChildControl(targetUI, "Static_BG")
    if self._pageIndex == sideImg._page and idx == sideImg._index then
      Static_BG:SetShow(true)
    else
      Static_BG:SetShow(false)
    end
  end
  self:LoadList()
end
registerEvent("FromClient_luaLoadComplete", "InitializeCharacterTag")
registerEvent("FromClient_SuccessRequest", "FromClient_SuccessRequest")
registerEvent("FromClient_SuccessDelete", "FromClient_SuccessDelete")
registerEvent("FromClient_NotifyUpdateDuelCharacterExp", "FromClient_NotifyUpdateDuelCharacterExp")
function CharacterTag_PopUp_UI()
  local self = CharacterTag
  if self._UI._CheckButton_PopUp:IsCheck() then
    Panel_CharacterTag:OpenUISubApp()
  else
    Panel_CharacterTag:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function CharacterTag_PopUp_ShowIconToolTip(isShow)
  local self = CharacterTag
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
    if self._UI._CheckButton_PopUp:IsCheck() then
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_CHECK_TOOLTIP")
    else
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_NOCHECK_TOOLTIP")
    end
    TooltipSimple_Show(self._UI._CheckButton_PopUp, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function CharacterTag_WebHelper_ShowToolTip(isShow)
  local self = CharacterTag
  if isShow then
    local name = ""
    local desc = ""
    TooltipSimple_Show(self._UI._Button_Question, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function CharacterTag_WebHelper()
  Panel_WebHelper_ShowToggle("CharacterTag")
end
function HandleEvent_CharacterTagButton()
  local selfPlayer = getSelfPlayer()
  local duelCharIndex = ToClient_GetMyDuelCharacterIndex()
  local selfPlayerChar_No_s64 = selfPlayer:getCharacterNo_64()
  local selfPlayerChar_No_s32 = Int64toInt32(selfPlayerChar_No_s64)
  local characterData = getCharacterDataByIndex(duelCharIndex)
  if nil == characterData then
    return
  end
  local duelChar_No_s64 = characterData._duelCharacterNo
  local duelChar_No_s32 = Int64toInt32(duelChar_No_s64)
  if selfPlayerChar_No_s32 == duelChar_No_s32 then
    ToClient_updateDuelExp()
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TAKEEXP_WARNING2"))
  end
end
