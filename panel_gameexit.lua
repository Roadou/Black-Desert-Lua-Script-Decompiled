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
Panel_GameExit:setMaskingChild(true)
Panel_GameExit:ActiveMouseEventEffect(true)
Panel_GameExit:setGlassBackground(true)
Panel_ExitConfirm:setMaskingChild(true)
Panel_ExitConfirm:ActiveMouseEventEffect(true)
Panel_ExitConfirm:setGlassBackground(true)
Panel_ExitConfirm:SetShow(false)
Panel_GameExit:SetShow(false)
local userConnectionType = 0
Panel_GameExit:RegisterShowEventFunc(true, "Panel_GameExit_ShowAni()")
Panel_GameExit:RegisterShowEventFunc(false, "Panel_GameExit_HideAni()")
local isValksItem = ToClient_IsContentsGroupOpen("47")
function Panel_GameExit_ShowAni()
  UIAni.fadeInSCR_Down(Panel_GameExit)
  audioPostEvent_SystemUi(1, 0)
end
function Panel_GameExit_HideAni()
  Panel_GameExit:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_GameExit:addColorAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
  ButtonFacePhoto_ToolTip(false)
  audioPostEvent_SystemUi(1, 1)
end
local _btn_winClose = UI.getChildControl(Panel_GameExit, "Button_Win_Close")
local _btn_selectCharacter = UI.getChildControl(Panel_GameExit, "Button_CharacterSelect")
local _btn_gameExit = UI.getChildControl(Panel_GameExit, "Button_GameExit")
local _btn_Tray = UI.getChildControl(Panel_GameExit, "Button_Tray")
local _charSlotBG = UI.getChildControl(Panel_GameExit, "Static_CharSlot_BG")
local _btn_NoticeMsg = UI.getChildControl(Panel_GameExit, "Button_NoticeMsg")
local _btn_PreCharPage = UI.getChildControl(Panel_GameExit, "Button_PrePage")
local _btn_NextCharPage = UI.getChildControl(Panel_GameExit, "Button_NextPage")
local _btn_ChangeChannel = UI.getChildControl(Panel_GameExit, "Button_ChangeChannel")
local _btn_CharTransport = UI.getChildControl(Panel_GameExit, "Button_Transport")
local _block_BG = UI.getChildControl(Panel_GameExit, "Static_block_BG")
local _dailyStampBanner = UI.getChildControl(Panel_GameExit, "Static_DailyCheckBanner")
local _dailyStampSlotBg = UI.getChildControl(Panel_GameExit, "Static_DailyCheckSlotBg")
local _dailyStampText = UI.getChildControl(Panel_GameExit, "StaticText_DailycheckAlert")
local _btn_FacePhoto = UI.getChildControl(Panel_GameExit, "Button_FacePhoto")
local photoIndex = 0
local isExitPhoto = false
local isTrayMode = false
local _exitConfirm_TitleText = UI.getChildControl(Panel_ExitConfirm, "StaticText_Title")
local _exitConfirm_Btn_Confirm = UI.getChildControl(Panel_ExitConfirm, "Button_Confirm")
local _exitConfirm_Btn_Cancle = UI.getChildControl(Panel_ExitConfirm, "Button_Cancle")
local _exitConfirm_Chk_Tray = UI.getChildControl(Panel_ExitConfirm, "CheckButton_Tray")
local _exitConfirm_TrayString = UI.getChildControl(Panel_ExitConfirm, "StaticText_TrayHelp")
local _exitConfirm_ContentsString = UI.getChildControl(Panel_ExitConfirm, "StaticText_GameExit")
_exitConfirm_ContentsString:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEEXIT_TRAY_ASK"))
_exitConfirm_TrayString:SetTextMode(UI_TM.eTextMode_AutoWrap)
_exitConfirm_TrayString:SetAutoResize(true)
_exitConfirm_TrayString:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITTRAY_TRAYHELP"))
_exitConfirm_Chk_Tray:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITTRAY_CHKTRAY"))
_exitConfirm_Chk_Tray:SetEnableArea(0, 0, _exitConfirm_Chk_Tray:GetSizeX() + _exitConfirm_Chk_Tray:GetTextSizeX(), _exitConfirm_Chk_Tray:GetSizeY())
_exitConfirm_Chk_Tray:SetPosX(Panel_ExitConfirm:GetSizeX() / 2 - _exitConfirm_Chk_Tray:GetTextSizeX() / 2 - 20)
local _exitConfirm_Chk_Tray_2 = UI.createControl(UCT.PA_UI_CONTROL_CHECKBUTTON, Panel_ExitConfirm, "CheckButton_Tray_2")
CopyBaseProperty(_exitConfirm_Chk_Tray, _exitConfirm_Chk_Tray_2)
_exitConfirm_Chk_Tray_2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEXITTRAYCHECKBUTTONTEXT"))
_exitConfirm_Chk_Tray_2:SetPosX(Panel_ExitConfirm:GetSizeX() / 2 - _exitConfirm_Chk_Tray_2:GetTextSizeX() / 2 - 20)
local _progressingQuest = UI.getChildControl(Panel_GameExit, "StaticText_ProgressingQuest_Value")
local _completeQuest = UI.getChildControl(Panel_GameExit, "StaticText_LastCompleteQuest_Value")
local _addMessage = UI.getChildControl(Panel_GameExit, "Edit_AddMessage")
local journalFrame = UI.getChildControl(Panel_GameExit, "Frame_TodayMyChallenge")
local journalFrameContents = UI.getChildControl(journalFrame, "Frame_1_Content")
local journalFrameScroll = UI.getChildControl(journalFrame, "Frame_Scroll_TodayMyChallenge")
local journalContents = UI.getChildControl(Panel_GameExit, "StaticText_TodayMyChallenge_Contents")
journalFrameContents:AddChild(journalContents)
Panel_GameExit:RemoveControl(journalContents)
journalContents:SetAutoResize(true)
journalContents:SetTextMode(UI_TM.eTextMode_AutoWrap)
journalContents:SetPosX(0)
journalContents:SetPosY(0)
_addMessage:SetMaxInput(24)
local normalStack = {}
local valksStack = {}
_btn_PreCharPage:SetAutoDisableTime(0)
_btn_NextCharPage:SetAutoDisableTime(0)
local _buttonQuestion = UI.getChildControl(Panel_GameExit, "Button_Question")
local Copy_UI_CharChange = {
  _copy_CharSlot = UI.getChildControl(Panel_GameExit, "Static_CharSlot"),
  _copy_CharLevel = UI.getChildControl(Panel_GameExit, "StaticText_Char_Level"),
  _copy_CharName = UI.getChildControl(Panel_GameExit, "StaticText_Char_Name"),
  _copy_NormalStack = UI.getChildControl(Panel_GameExit, "StaticText_NormalStack"),
  _copy_CharGaugeBG = UI.getChildControl(Panel_GameExit, "Static_Char_GaugeBG"),
  _copy_CharGauge = UI.getChildControl(Panel_GameExit, "Static_Char_Gauge"),
  _copy_CharWorkTxt = UI.getChildControl(Panel_GameExit, "StaticText_Char_Work"),
  _copy_CharPcDeliveryRemainTime = UI.getChildControl(Panel_GameExit, "StaticText_PcDeliveryRemainTime"),
  _copy_CharWhere = UI.getChildControl(Panel_GameExit, "StaticText_Char_Where"),
  _copy_CharPosition = UI.getChildControl(Panel_GameExit, "StaticText_Char_Position"),
  _copy_CharEnterWaiting = UI.getChildControl(Panel_GameExit, "StaticText_EnterWaiting"),
  _copy_CharChange = UI.getChildControl(Panel_GameExit, "Button_Change"),
  _copy_CharSelect = UI.getChildControl(Panel_GameExit, "Static_CharSlot_Select"),
  _copy_CharSlot_BG2 = UI.getChildControl(Panel_GameExit, "Static_CharSlot_BG2"),
  _copy_CharWpCount = UI.getChildControl(Panel_GameExit, "StaticText_WpCount")
}
local totalCharacterCount = 4
local startPosX = 4
local exitMode = -1
local logoutDelayTime = getLogoutWaitingTime()
enum_ExitMode = {
  eExitMode_GameExit = 0,
  eExitMode_BackCharacter = 1,
  eExitMode_SwapCharacter = 2
}
local exit_Time = 0
local prevTime = 0
local selectCharacterIndex = -1
local back_CharacterSelectTime = 0
local selfCharacterIndex = -1
local isCharacterSlotBG = {}
local isCharacterSlot = {}
local CharacterChangeButton = {}
local isCharacterSelect = {}
local charWorking = {}
local charPcDeliveryRemainTime = {}
local charEnterWaiting = {}
local charLevelPool = {}
local charNamePool = {}
local charPositionPool = {}
local beginnerReward = {}
local normalStackPool = {}
local charWpCountPool = {}
local _selectChannel = -1
local slot = {}
local _dailyStampSlotConfig = {
  createIcon = true,
  createBorder = true,
  createCount = true,
  createClassEquipBG = true,
  createCash = true
}
function Panel_GameExit_Initialize()
  local selfProxy = getSelfPlayer()
  local characterNo_64 = toInt64(0, 0)
  if nil ~= selfProxy then
    characterNo_64 = selfProxy:getCharacterNo_64()
  end
  for idx = 0, totalCharacterCount - 1 do
    local charSlotBG2 = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _charSlotBG, "Static_CharSlotBG2_" .. idx)
    CopyBaseProperty(Copy_UI_CharChange._copy_CharSlot_BG2, charSlotBG2)
    charSlotBG2:SetShow(false)
    charSlotBG2:SetIgnore(true)
    charSlotBG2:SetPosX(startPosX + idx * 159)
    charSlotBG2:SetPosY(4)
    isCharacterSlotBG[idx] = charSlotBG2
    local charSlot = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _charSlotBG, "Static_CharSlot_" .. idx)
    CopyBaseProperty(Copy_UI_CharChange._copy_CharSlot, charSlot)
    charSlot:SetShow(false)
    charSlot:SetPosX(startPosX + idx * 159)
    charSlot:SetPosY(4)
    isCharacterSlot[idx] = charSlot
    local charLevel = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, charSlot, "StaticText_CharLevel_" .. idx)
    CopyBaseProperty(Copy_UI_CharChange._copy_CharLevel, charLevel)
    charLevel:SetShow(false)
    charLevelPool[idx] = charLevel
    local charName = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, charSlot, "StaticText_CharName_" .. idx)
    CopyBaseProperty(Copy_UI_CharChange._copy_CharName, charName)
    charName:SetShow(false)
    charName:SetTextMode(UI_TM.eTextMode_AutoWrap)
    charNamePool[idx] = charName
    local charWorkTxt = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, charSlot, "StaticText_CharWorkText_" .. idx)
    CopyBaseProperty(Copy_UI_CharChange._copy_CharWorkTxt, charWorkTxt)
    charWorkTxt:SetShow(false)
    charWorkTxt:SetPosY(charWorkTxt:GetPosY() + 20)
    charWorking[idx] = charWorkTxt
    local charWorkRemainText = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, charSlot, "StaticText_PcDeliveryRamainTimeText_" .. idx)
    CopyBaseProperty(Copy_UI_CharChange._copy_CharPcDeliveryRemainTime, charWorkRemainText)
    charWorkRemainText:SetShow(false)
    charPcDeliveryRemainTime[idx] = charWorkRemainText
    local charPositionTxt = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, charSlot, "StaticText_CharPosition_" .. idx)
    CopyBaseProperty(Copy_UI_CharChange._copy_CharPosition, charPositionTxt)
    charPositionTxt:SetShow(false)
    charPositionPool[idx] = charPositionTxt
    local charEnterWaitingTxt = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, charSlot, "StaticText_EnterWaiting_" .. idx)
    CopyBaseProperty(Copy_UI_CharChange._copy_CharEnterWaiting, charEnterWaitingTxt)
    charEnterWaitingTxt:SetShow(false)
    charEnterWaiting[idx] = charEnterWaitingTxt
    local charChange = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, charSlot, "Button_CharChange_" .. idx)
    CopyBaseProperty(Copy_UI_CharChange._copy_CharChange, charChange)
    charChange:SetShow(false)
    CharacterChangeButton[idx] = charChange
    local charSelected = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _charSlotBG, "Statc_CharSelected_" .. idx)
    CopyBaseProperty(Copy_UI_CharChange._copy_CharSelect, charSelected)
    charSelected:SetShow(false)
    charSelected:SetPosX(2 + idx * 159)
    charSelected:SetPosY(2)
    isCharacterSelect[idx] = charSelected
    local normalStack = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, charSlot, "StaticText_NormalStack_" .. idx)
    CopyBaseProperty(Copy_UI_CharChange._copy_NormalStack, normalStack)
    normalStack:SetShow(false)
    normalStack:SetPosX(127)
    normalStack:SetPosY(170)
    normalStackPool[idx] = normalStack
    local charWpCount = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, charSlot, "StaticText_charWpCount_" .. idx)
    CopyBaseProperty(Copy_UI_CharChange._copy_CharWpCount, charWpCount)
    charWpCount:SetShow(false)
    charWpCount:SetPosX(2)
    charWpCount:SetPosY(176)
    charWpCountPool[idx] = charWpCount
  end
  for _, value in pairs(Copy_UI_CharChange) do
    value:SetShow(false)
  end
  Panel_GameExit:SetChildIndex(_btn_ChangeChannel, 9999)
  _block_BG:SetSize(getScreenSizeX() + 200, getScreenSizeY() + 200)
  _block_BG:SetHorizonCenter()
  _block_BG:SetVerticalMiddle()
  _btn_ChangeChannel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"))
  _btn_FacePhoto:SetShow(true)
  _btn_FacePhoto:addInputEvent("Mouse_On", "ButtonFacePhoto_ToolTip( true )")
  _btn_FacePhoto:addInputEvent("Mouse_Out", "ButtonFacePhoto_ToolTip( false )")
  _btn_FacePhoto:addInputEvent("Mouse_LUp", "GameExit_ForFacePhoto()")
  local temp = {}
  SlotItem.new(temp, "DailyStamp_RewardItem", 0, _dailyStampSlotBg, _dailyStampSlotConfig)
  temp:createChild()
  temp.icon:SetPosX(4)
  temp.icon:SetPosY(12)
  slot = temp
  _btn_selectCharacter:SetText(_btn_selectCharacter:GetText())
  _btn_gameExit:SetText(_btn_gameExit:GetText())
  _btn_Tray:SetText(_btn_Tray:GetText())
  _btn_selectCharacter:setChangeFontAfterTransSizeValue()
  _btn_gameExit:setChangeFontAfterTransSizeValue()
  _btn_Tray:setChangeFontAfterTransSizeValue()
end
function GameExit_ForFacePhoto()
  isExitPhoto = true
  GameExit_Close()
  IsGameExitPhoto(true)
  IngameCustomize_Show()
  characterSlot_Index(photoIndex)
end
function ButtonFacePhoto_ToolTip(isOn)
  if false == isOn then
    TooltipSimple_Hide()
    return
  end
  local self, uiControl, name, desc
  uiControl = _btn_FacePhoto
  name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_FACEPHOTO_TOOLTIP_NAME")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_FACEPHOTO_TOOLTIP_DESC")
  local reversePosX = true
  registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
  TooltipSimple_Show(uiControl, name, desc, reversePosX)
end
function refreshCharacterInfoData(startIdx)
  local selfProxy = getSelfPlayer()
  local characterNo_64 = toInt64(0, 0)
  if nil == startIdx or startIdx <= 0 then
    startIdx = 0
  end
  if nil ~= selfProxy then
    characterNo_64 = selfProxy:getCharacterNo_64()
  end
  photoIndex = startIdx - 1
  if false == Panel_GameExit:IsShow() then
    return
  end
  local currentTicketNo = getCurrentTicketNo()
  local uiCount = 0
  local characterTicketNo
  local firstTicketNo = getFirstTicketNoByAll()
  local characterDatacount = getCharacterDataCount()
  local nowPlayCharaterSlotNo
  local serverUtc64 = getServerUtc64()
  for idx = startIdx, characterDatacount - 1 do
    local characterData = getCharacterDataByIndex(idx)
    local char_Type = getCharacterClassType(characterData)
    local char_Level = string.format("%d", characterData._level)
    local char_Name = getCharacterName(characterData)
    local char_wp = ToClient_getWpInCharacterDataList(idx)
    local defaultCount = characterData._enchantFailCount
    local valksCount = characterData._valuePackCount
    local char_No_s64 = characterData._characterNo_s64
    local char_TextureName = getCharacterFaceTextureByIndex(idx)
    local char_WorkTxt = ""
    local pcDeliveryRemainTimeText = ""
    local pcDeliveryRegionKey = characterData._arrivalRegionKey
    if 0 ~= pcDeliveryRegionKey:get() and serverUtc64 < characterData._arrivalTime then
      char_WorkTxt = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_DELIVERY")
      local remainTime = characterData._arrivalTime - serverUtc64
      pcDeliveryRemainTimeText = convertStringFromDatetime(remainTime)
    else
      char_WorkTxt = global_workTypeToStringSwap(characterData._pcWorkingType)
    end
    local regionInfo = getRegionInfoByPosition(characterData._currentPosition)
    isCharacterSlot[uiCount]:SetShow(true)
    local isCaptureExist = isCharacterSlot[uiCount]:ChangeTextureInfoNameNotDDS(char_TextureName, char_Type, isExitPhoto)
    if isCaptureExist == true then
      isCharacterSlot[uiCount]:getBaseTexture():setUV(0, 0, 1, 1)
    elseif _ContentsGroup_isUsedNewCharacterInfo == false then
      if char_Type == __eClassType_Warrior then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 1, 1, 156, 201)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_ElfRanger then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 157, 1, 312, 201)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_Sorcerer then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 313, 1, 468, 201)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_Giant then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 1, 202, 156, 402)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_Tamer then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 157, 202, 312, 402)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_BladeMaster then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 313, 202, 468, 402)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_Valkyrie then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 1, 1, 156, 201)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_BladeMasterWoman then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 157, 1, 312, 201)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_WizardMan then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 313, 1, 468, 201)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_WizardWoman then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 1, 202, 156, 402)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_Kunoichi then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 157, 202, 312, 402)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_NinjaMan then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 313, 202, 468, 402)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_DarkElf then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_02.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 1, 1, 156, 201)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_Combattant then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_02.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 157, 1, 312, 201)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_Mystic then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_02.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 313, 1, 468, 201)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_Lhan then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_03.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 1, 1, 156, 201)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_RangerMan then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_03.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 157, 1, 312, 201)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      elseif char_Type == __eClassType_ShyWaman then
        isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_03.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], 313, 1, 468, 201)
        isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
        isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
      end
    else
      local DefaultFace = UI_DefaultFaceTexture[char_Type]
      isCharacterSlot[uiCount]:ChangeTextureInfoName(DefaultFace[1])
      local x1, y1, x2, y2 = setTextureUV_Func(isCharacterSlot[uiCount], DefaultFace[2], DefaultFace[3], DefaultFace[4], DefaultFace[5])
      isCharacterSlot[uiCount]:getBaseTexture():setUV(x1, y1, x2, y2)
    end
    isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
    charLevelPool[uiCount]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. char_Level)
    charNamePool[uiCount]:SetText(char_Name)
    if 0 == characterData._currentPosition.x and 0 == characterData._currentPosition.y and 0 == characterData._currentPosition.z then
      charPositionPool[uiCount]:SetText("")
    elseif 0 ~= pcDeliveryRegionKey:get() and serverUtc64 > characterData._arrivalTime then
      local retionInfoArrival = getRegionInfoByRegionKey(pcDeliveryRegionKey)
      charPositionPool[uiCount]:SetText(retionInfoArrival:getAreaName())
    else
      charPositionPool[uiCount]:SetText(regionInfo:getAreaName())
    end
    normalStackPool[uiCount]:SetShow(true)
    charWpCountPool[uiCount]:SetShow(true)
    charWpCountPool[uiCount]:SetText(char_wp)
    if ToClient_IsReceivedEnchantFailCount() then
      normalStackPool[uiCount]:SetText(defaultCount + valksCount)
    else
      normalStackPool[uiCount]:SetText("-")
    end
    normalStackPool[uiCount]:SetFontColor(UI_color.C_FFE7E7E7)
    charWpCountPool[uiCount]:SetFontColor(UI_color.C_FFE7E7E7)
    normalStackPool[uiCount]:addInputEvent("Mouse_On", "GameExit_SimpleTooltips( true, " .. uiCount .. ", 0," .. defaultCount .. "," .. valksCount .. " )")
    normalStackPool[uiCount]:addInputEvent("Mouse_Out", "GameExit_SimpleTooltips( false, " .. uiCount .. ", 0 )")
    charWpCountPool[uiCount]:addInputEvent("Mouse_On", "GameExit_SimpleTooltips( true, " .. uiCount .. ", 1 )")
    charWpCountPool[uiCount]:addInputEvent("Mouse_Out", "GameExit_SimpleTooltips( false, " .. uiCount .. ", 1 )")
    charWorking[uiCount]:SetShow(true)
    charPcDeliveryRemainTime[uiCount]:SetShow(true)
    charLevelPool[uiCount]:SetShow(true)
    charNamePool[uiCount]:SetShow(true)
    charPositionPool[uiCount]:SetShow(true)
    charEnterWaiting[uiCount]:SetShow(true)
    if false == _ContentsGroup_isConsolePadControl then
      isCharacterSlot[uiCount]:addInputEvent("Mouse_LUp", "Panel_GameExit_ClickCharSlot(" .. uiCount .. ")")
    else
      isCharacterSlot[uiCount]:addInputEvent("Mouse_On", "Panel_GameExit_ClickCharSlot(" .. uiCount .. ")")
    end
    CharacterChangeButton[uiCount]:addInputEvent("Mouse_LUp", "Panel_GameExit_ChangeCharacter(" .. idx .. ")")
    local selfProxy = getSelfPlayer()
    local characterNo_64 = toInt64(0, 0)
    if nil ~= selfProxy then
      characterNo_64 = selfProxy:getCharacterNo_64()
    end
    CharacterChangeButton[uiCount]:SetShow(false)
    if characterNo_64 == characterData._characterNo_s64 then
      isCharacterSlot[uiCount]:SetMonoTone(false)
      isCharacterSlot[uiCount]:SetIgnore(true)
      isCharacterSlotBG[uiCount]:SetShow(true)
      if startIdx + 4 <= characterDatacount - 1 then
        isCharacterSlot[uiCount]:addInputEvent("Mouse_DownScroll", "refreshCharacterInfoData(" .. startIdx + 1 .. ")")
        _charSlotBG:addInputEvent("Mouse_DownScroll", "refreshCharacterInfoData(" .. startIdx + 1 .. " )")
      end
      isCharacterSlot[uiCount]:addInputEvent("Mouse_UpScroll", "refreshCharacterInfoData(" .. startIdx - 1 .. " )")
      _charSlotBG:addInputEvent("Mouse_UpScroll", "refreshCharacterInfoData(" .. startIdx - 1 .. " )")
      CharacterChangeButton[uiCount]:SetShow(false)
      CharacterChangeButton[uiCount]:SetIgnore(true)
      CharacterChangeButton[uiCount]:SetEnable(false)
      normalStackPool[uiCount]:SetFontColor(UI_color.C_FFE7E7E7)
      charWorking[uiCount]:SetText("")
      charWorking[uiCount]:SetFontColor(UI_color.C_FF6DC6FF)
      charPositionPool[uiCount]:SetShow(false)
      charPcDeliveryRemainTime[uiCount]:SetText("")
      nowPlayCharaterSlotNo = uiCount
    else
      isCharacterSlot[uiCount]:SetIgnore(false)
      isCharacterSlot[uiCount]:SetMonoTone(true)
      if startIdx + 4 <= characterDatacount - 1 then
        isCharacterSlot[uiCount]:addInputEvent("Mouse_DownScroll", "refreshCharacterInfoData(" .. startIdx + 1 .. ")")
        _charSlotBG:addInputEvent("Mouse_DownScroll", "refreshCharacterInfoData(" .. startIdx + 1 .. ")")
      end
      isCharacterSlot[uiCount]:addInputEvent("Mouse_UpScroll", "refreshCharacterInfoData(" .. startIdx - 1 .. " )")
      _charSlotBG:addInputEvent("Mouse_UpScroll", "refreshCharacterInfoData(" .. startIdx - 1 .. " )")
      isCharacterSlotBG[uiCount]:SetShow(false)
      normalStackPool[uiCount]:SetFontColor(UI_color.C_FFC4BEBE)
      CharacterChangeButton[uiCount]:SetIgnore(false)
      CharacterChangeButton[uiCount]:SetEnable(true)
      charWorking[uiCount]:SetText(char_WorkTxt)
      charWorking[uiCount]:SetFontColor(UI_color.C_FFE7E7E7)
      charPcDeliveryRemainTime[uiCount]:SetText(pcDeliveryRemainTimeText)
      local removeTime = getCharacterDataRemoveTime(idx)
      if nil ~= removeTime then
        charWorking[uiCount]:SetText(PAGetString(Defines.StringSheet_GAME, "CHARACTER_DELETING"))
        charEnterWaiting[uiCount]:SetShow(false)
        CharacterChangeButton[uiCount]:SetEnable(false)
        charPositionPool[uiCount]:SetShow(false)
      else
        charWorking[uiCount]:SetText(char_WorkTxt)
      end
    end
    characterTicketNo = currentTicketNo - characterData._lastTicketNoByRegion
    if const_64.s64_m1 ~= firstTicketNo or const_64.s64_m1 ~= characterData._lastTicketNoByRegion and characterTicketNo > const_64.s64_m1 then
      charEnterWaiting[uiCount]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_NOT_ENTER_TO_FIELD"))
    elseif characterNo_64 == characterData._characterNo_s64 then
      charEnterWaiting[uiCount]:SetShow(false)
    end
    uiCount = uiCount + 1
    if 4 == uiCount then
      break
    end
  end
  if nil ~= nowPlayCharaterSlotNo then
    local basePosX = _charSlotBG:GetPosX()
    local basePosY = _charSlotBG:GetPosY()
    local posX = basePosX + isCharacterSlot[nowPlayCharaterSlotNo]:GetPosX() + isCharacterSlot[nowPlayCharaterSlotNo]:GetSizeX() / 2 - _btn_ChangeChannel:GetSizeX() / 2
    local posY = basePosY + isCharacterSlot[nowPlayCharaterSlotNo]:GetPosY() + isCharacterSlot[nowPlayCharaterSlotNo]:GetSizeY() - _btn_ChangeChannel:GetSizeY() - 10
    _btn_ChangeChannel:SetPosX(posX)
    _btn_ChangeChannel:SetPosY(posY)
    _btn_ChangeChannel:SetShow(true)
    _btn_ChangeChannel:addInputEvent("Mouse_LUp", "FGlobal_ChannelSelect_Show()")
    local posX2 = basePosX + isCharacterSlot[nowPlayCharaterSlotNo]:GetPosX() + isCharacterSlot[nowPlayCharaterSlotNo]:GetSizeX() / 2 - _btn_CharTransport:GetSizeX() / 2
    local posY2 = basePosY + isCharacterSlot[nowPlayCharaterSlotNo]:GetPosY() + isCharacterSlot[nowPlayCharaterSlotNo]:GetSizeY() - _btn_CharTransport:GetSizeY() - 10
    _btn_CharTransport:SetPosX(posX2)
    _btn_CharTransport:SetPosY(posY2 + 37)
    _btn_CharTransport:SetShow(true)
    _btn_CharTransport:addInputEvent("Mouse_LUp", "Panel_GameExit_Transport()")
  else
    _btn_ChangeChannel:SetShow(false)
    _btn_CharTransport:SetShow(false)
  end
  if characterDatacount - 1 < startIdx + 4 then
    _btn_NextCharPage:addInputEvent("Mouse_LUp", "")
    _btn_NextCharPage:SetShow(false)
  else
    _btn_NextCharPage:addInputEvent("Mouse_LUp", "refreshCharacterInfoData(" .. startIdx + 1 .. ")")
    _btn_NextCharPage:SetShow(true)
  end
  if startIdx > 0 then
    _btn_PreCharPage:addInputEvent("Mouse_LUp", "refreshCharacterInfoData(" .. startIdx - 1 .. ")")
    _btn_PreCharPage:SetShow(true)
  else
    _btn_PreCharPage:addInputEvent("Mouse_LUp", "")
    _btn_PreCharPage:SetShow(false)
  end
end
function confirm_MoveChannel_From_MessageBox()
  FGlobal_gameExit_saveCurrentData()
  gameExit_MoveChannel(_selectChannel)
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELWAIT_MSG")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"),
    content = messageBoxMemo,
    functionYes = nil,
    functionClose = nil,
    exitButton = true,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function global_workTypeToStringSwap(workingType)
  local workingText
  if ePcWorkingType.ePcWorkType_Empty == workingType then
    workingText = ""
  elseif ePcWorkingType.ePcWorkType_Play == workingType then
    workingText = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_PLAY")
  elseif ePcWorkingType.ePcWorkType_RepairItem == workingType then
    workingText = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_REPAIRITEM")
  elseif ePcWorkingType.ePcWorkType_Relax == workingType then
    workingText = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_RELEX")
  elseif ePcWorkingType.ePcWorkType_ReadBook == workingType then
    workingText = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_READBOOK")
  else
    _PA_ASSERT(false, "\236\186\144\235\166\173\237\132\176 \236\158\145\236\151\133 \237\131\128\236\158\133\236\157\180 \236\182\148\234\176\128 \235\144\152\236\151\136\236\138\181\235\139\136\235\139\164. Lobby_New.lua \235\143\132 \236\182\148\234\176\128\237\149\180 \236\163\188\236\150\180\236\149\188 \237\149\169\235\139\136\235\139\164.")
    workingText = "unKnown"
  end
  return workingText
end
function FGlobal_gameExit_saveCurrentData()
  getSelfPlayer():updateNavigationInformation(_addMessage:GetEditText())
  getSelfPlayer():saveCurrentDataForGameExit()
  ToClient_SaveUiInfo(false)
end
function gameExit_UpdatePerFrame(deltaTime)
  if exit_Time > 0 then
    exit_Time = exit_Time - deltaTime
    local remainTime = math.floor(exit_Time)
    if prevTime ~= remainTime then
      if remainTime < 0 then
        remainTime = 0
      end
      prevTime = remainTime
      if enum_ExitMode.eExitMode_GameExit == exitMode then
        _btn_NoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_EXIT", "remainTime", tostring(remainTime)))
        if prevTime <= 0 then
          exit_Time = -1
          _btn_NoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_PROGRESS"))
          doGameLogOut()
        end
      elseif enum_ExitMode.eExitMode_BackCharacter == exitMode then
        _btn_NoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_SELECT", "remainTime", tostring(remainTime)))
        if prevTime <= 0 then
          exit_Time = -1
          _btn_NoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_CHARACTERSELECT"))
        end
      elseif enum_ExitMode.eExitMode_SwapCharacter == exitMode then
        _btn_NoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_CHANGE", "remainTime", tostring(remainTime)))
        if prevTime <= 0 then
          exit_Time = -1
          _btn_NoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_SWAPCHARACTER"))
        end
      else
        _btn_NoticeMsg:SetShow(false)
      end
    end
  end
end
function Panel_GameExit_sendGameDelayExitCancel()
  if not _btn_NoticeMsg:GetShow() then
    return
  end
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local cancelAble = true
  if exitMode == enum_ExitMode.eExitMode_BackCharacter and true == regionInfo:get():isSafeZone() or prevTime < 2 then
    cancelAble = false
  end
  if true == cancelAble then
    sendGameDelayExitCancel()
  end
  _btn_NoticeMsg:SetShow(false)
  _btn_selectCharacter:SetShow(true)
  _btn_gameExit:SetShow(true)
  _btn_Tray:SetShow(true)
  exit_Time = 0
  exitMode = -1
end
local prevClickIndex = 0
function Panel_GameExit_ClickCharSlot(idx)
  if prevClickIndex ~= idx then
    isCharacterSelect[prevClickIndex]:SetShow(false)
    CharacterChangeButton[prevClickIndex]:SetShow(false)
    isCharacterSlot[prevClickIndex]:ResetVertexAni()
    isCharacterSlot[prevClickIndex]:SetAlpha(1)
  end
  isCharacterSelect[idx]:SetShow(true)
  CharacterChangeButton[idx]:SetShow(true)
  if true == _ContentsGroup_isConsolePadControl then
    isCharacterSlot[idx]:addInputEvent("Mouse_LUp", "Panel_GameExit_ChangeCharacter(" .. idx .. ")")
  end
  isCharacterSlot[idx]:ResetVertexAni()
  isCharacterSlot[idx]:SetVertexAniRun("Ani_Color_New", true)
  prevClickIndex = idx
end
function Panel_GameExit_ClickSelectCharacter()
  if ToClient_SelfPlayerCheckAction("READ_BOOK") then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_READBOOK_WARNNING")
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = messageBoxMemo,
      functionYes = Panel_GameExit_CharChange_Confirm,
      functionCancel = MessageBox_Empty_function,
      priority = PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    local contentStr = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_BACK_TO_CHARACTERSELECT_Q")
    local messageboxData = {
      title = "",
      content = contentStr,
      functionYes = Panel_GameExit_CharSelect_Yes,
      functionCancel = MessageBox_Empty_function,
      priority = PP.PAUIMB_PRIORITY_LOW,
      exitButton = true
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function Panel_GameExit_CharSelect_Yes()
  exitMode = enum_ExitMode.eExitMode_BackCharacter
  FGlobal_gameExit_saveCurrentData()
  if false == sendCharacterSelect() then
    exitMode = -1
    return
  end
  _btn_selectCharacter:SetShow(false)
  _btn_gameExit:SetShow(false)
  _btn_Tray:SetShow(false)
  _btn_NoticeMsg:SetShow(true)
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  if true == regionInfo:get():isSafeZone() then
    _btn_NoticeMsg:SetIgnore(true)
    _btn_NoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_CHARACTERSELECT"))
  else
    _btn_NoticeMsg:SetIgnore(false)
    _btn_NoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_SELECT", "remainTime", logoutDelayTime))
  end
end
local changeIndex = 0
function Panel_GameExit_ChangeCharacter(index)
  changeIndex = index
  local characterData = getCharacterDataByIndex(index)
  local classType = getCharacterClassType(characterData)
  if ToClient_IsCustomizeOnlyClass(classType) then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "LUA_LOBBY_SELECTCHARACTER_NOTYET_1"))
    return
  end
  if characterData._level < 5 then
    NotifyDisplay(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GAMEEXIT_DONT_CHAGECHARACTER", "iLevel", 4))
    return
  end
  local removeTime = getCharacterDataRemoveTime(index)
  if nil ~= removeTime then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_CHARACTER_DELETE"))
    return
  end
  local usabelSlotCount = getUsableCharacterSlotCount()
  if index >= usabelSlotCount then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_CLOSE_CHARACTER_SLOT"))
    return
  end
  if true == ToClient_CheckDuelCharacterInPrison(index) then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERTAG_PRISON_CANT_LOGIN"))
    return
  end
  local contentString = ""
  if const_64.s64_m1 ~= characterData._lastTicketNoByRegion then
    contentString = PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_WAIT") .. "\n"
  end
  if ToClient_SelfPlayerCheckAction("READ_BOOK") then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_READBOOK_WARNNING")
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = messageBoxMemo,
      functionYes = Panel_GameExit_CharChange_Confirm,
      functionCancel = MessageBox_Empty_function,
      priority = PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
  if ePcWorkingType.ePcWorkType_Empty ~= characterData._pcWorkingType then
    if ePcWorkingType.ePcWorkType_ReadBook == characterData._pcWorkingType then
      contentString = contentString .. PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_WORKING_NOW_READ_BOOK")
    else
      contentString = contentString .. PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_WORKING_NOW_CHANGE_Q")
    end
  end
  local pcDeliveryRegionKey = characterData._arrivalRegionKey
  local serverUtc64 = getServerUtc64()
  if 0 ~= pcDeliveryRegionKey:get() and serverUtc64 < characterData._arrivalTime then
    contentString = PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_SelectPcDelivery") .. "\n"
  end
  if nil ~= contentString then
    if ToClient_SelfPlayerCheckAction("READ_BOOK") then
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_READBOOK_WARNNING")
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = messageBoxMemo,
        functionYes = Panel_GameExit_CharChange_Confirm,
        functionCancel = MessageBox_Empty_function,
        priority = PP.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
    else
      contentString = contentString .. PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHARACTER_CHANGE_QUESTION")
      local messageboxData = {
        title = "",
        content = contentString,
        functionYes = Panel_GameExit_CharChange_Confirm,
        functionCancel = MessageBox_Empty_function,
        priority = PP.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
    end
  elseif ToClient_SelfPlayerCheckAction("READ_BOOK") then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_READBOOK_WARNNING")
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = messageBoxMemo,
      functionYes = Panel_GameExit_CharChange_Confirm,
      functionCancel = MessageBox_Empty_function,
      priority = PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    Panel_GameExit_CharChange_Confirm()
  end
  _PA_LOG("\236\160\149\237\131\156\234\179\164", "\236\151\172\234\184\176\235\165\188 \237\131\128\235\130\152\236\154\148?")
end
function Panel_GameExit_Transport()
  FGlobal_DeliveryForGameExit_Show(true)
end
function Panel_GameExit_CharChange_Confirm()
  FGlobal_gameExit_saveCurrentData()
  local rv = swapCharacter_Select(changeIndex, true)
  if false == rv then
    return
  end
  exitMode = enum_ExitMode.eExitMode_SwapCharacter
  _btn_selectCharacter:SetShow(false)
  _btn_gameExit:SetShow(false)
  _btn_Tray:SetShow(false)
  _btn_NoticeMsg:SetShow(true)
  _btn_NoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_CHANGE", "remainTime", logoutDelayTime))
  if true == PaGlobal_IsTagChange() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TAG_CHANGING")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function Panel_GameExit_ClickGameOff()
  _exitConfirm_TitleText:SetText(PAGetString(Defines.StringSheet_GAME, "GAME_EXIT_MESSAGEBOX_TITLE"))
  _exitConfirm_ContentsString:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_GAMEEXIT_TRAY_ASK"))
  if false == isFullscreenMode() then
    _exitConfirm_TrayString:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITTRAY_TRAYHELP"))
    _exitConfirm_Chk_Tray:SetCheck(false)
    _exitConfirm_Chk_Tray:SetShow(true)
  else
    _exitConfirm_TrayString:SetText("")
    _exitConfirm_Chk_Tray:SetCheck(false)
    _exitConfirm_Chk_Tray:SetShow(false)
  end
  Panel_ExitConfirm:SetShow(true)
  _exitConfirm_Chk_Tray_2:SetShow(false)
end
function FromClient_TrayIconMessageBox()
  _exitConfirm_TitleText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITCONFIRM_TITLE"))
  _exitConfirm_ContentsString:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_GAMEEXIT_TRAY_ASK2"))
  _exitConfirm_TrayString:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_TRAYLIMIT"))
  _exitConfirm_Chk_Tray:SetCheck(true)
  _exitConfirm_Chk_Tray:SetShow(false)
  Panel_ExitConfirm:SetShow(true)
  _exitConfirm_Chk_Tray_2:SetShow(true)
end
function Panel_GameExit_Minimize()
  Panel_ExitConfirm:SetShow(false)
end
function Panel_GameExit_MinimizeTray()
  if Panel_GameExit:GetShow() then
    if false == _exitConfirm_Chk_Tray:IsCheck() then
      Panel_GameExit_GameOff_Yes()
    else
      Panel_ExitConfirm:SetShow(false)
      GameExit_Close()
      ToClient_CheckTrayIcon()
    end
  else
    if _exitConfirm_Chk_Tray_2:IsCheck() then
      ToClient_CheckTrayIcon()
    else
      ToClient_UnCheckTrayIcon()
    end
    Panel_ExitConfirm:SetShow(false)
  end
end
function Panel_GameExit_GameOff_Yes()
  exitMode = enum_ExitMode.eExitMode_GameExit
  FGlobal_gameExit_saveCurrentData()
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  if true == regionInfo:get():isSafeZone() then
    _btn_NoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_PROGRESS"))
    _btn_NoticeMsg:SetIgnore(true)
  else
    _btn_NoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_EXIT", "remainTime", logoutDelayTime))
    _btn_NoticeMsg:SetIgnore(false)
  end
  sendBeginGameDelayExit(enum_ExitMode.eExitMode_SwapCharacter == exitMode)
  _btn_selectCharacter:SetShow(false)
  _btn_gameExit:SetShow(false)
  _btn_Tray:SetShow(false)
  _btn_NoticeMsg:SetShow(true)
end
function doGameLogOut()
  SetUIMode(Defines.UIMode.eUIMode_Default)
  sendGameLogOut()
end
function setGameExitDelayTime(delayTime)
  if false == Panel_GameExit:GetShow() then
    return
  end
  exit_Time = delayTime
  _btn_NoticeMsg:SetIgnore(false)
  if 0 == exit_Time then
    if enum_ExitMode.eExitMode_SwapCharacter == exitMode then
      _btn_NoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_SWAPCHARACTER"))
    elseif enum_ExitMode.eExitMode_GameExit == exitMode then
      _btn_NoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_PROGRESS"))
    elseif enum_ExitMode.eExitMode_BackCharacter == exitMode then
      _btn_NoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_CHARACTERSELECT"))
    end
  elseif enum_ExitMode.eExitMode_SwapCharacter ~= exitMode then
    _btn_NoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_CHANGE", "remainTime", tostring(delayTime)))
  elseif enum_ExitMode.eExitMode_GameExit == exitMode then
    _btn_NoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_EXIT", "remainTime", tostring(delayTime)))
  elseif enum_ExitMode.eExitMode_BackCharacter == exitMode then
    _btn_NoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_SELECT", "remainTime", tostring(delayTime)))
  end
end
function characterInfoRequest()
end
local prevUIMode = 0
function GameExitShowToggle(isAttacked)
  if isDeadInWatchingMode() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITOPENALERT_INDEAD"))
    return
  end
  if CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode == UI.Get_ProcessorInputMode() then
    return
  end
  local currentUIMode = GetUIMode()
  if currentUIMode == Defines.UIMode.eUIMode_Gacha_Roulette or currentUIMode == Defines.UIMode.eUIMode_DeadMessage then
    return
  end
  if ToClient_cutsceneIsPlay() then
    return
  end
  if isFlushedUI() then
    return
  end
  if isAttacked then
    return
  end
  if isGameTypeRussia() and isAttacked then
    local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
    if regionInfo:get():isSafeZone() then
      return
    end
  end
  local isShow = Panel_GameExit:IsShow()
  if true == isShow then
    if _btn_NoticeMsg:GetShow() then
      return
    end
    Panel_GameExit:SetShow(false, true)
    SetUIMode(prevUIMode)
    if -1 ~= exitMode then
      Panel_GameExit_sendGameDelayExitCancel()
    end
    local focusEdit = GetFocusEdit()
    if nil ~= focusEdit and focusEdit:GetKey() == _addMessage:GetKey() then
      ClearFocusEdit()
    end
    if Panel_ExitConfirm:GetShow() then
      _exitConfirm_Chk_Tray:SetCheck(false)
      Panel_ExitConfirm:SetShow(false)
    end
  else
    prevUIMode = GetUIMode()
    SetUIMode(Defines.UIMode.eUIMode_GameExit)
    Panel_GameExit:SetShow(true, true)
    sendWaitingListOfMyCharacters()
    if true == isExitPhoto then
      refreshCharacterInfoData(photoIndex)
    else
      refreshCharacterInfoData(0)
    end
    isExitPhoto = false
    ToClient_RequestRecentJournalByCount(5)
    ToClient_RequestCharacterEnchantFailCount()
    local questWrapper
    local questNo0 = getSelfPlayer():get():getLastCompleteQuest(0)
    questWrapper = ToClient_getQuestWrapper(questNo0)
    if nil ~= questWrapper then
      _completeQuest:SetText(questWrapper:getTitle())
    else
      _completeQuest:SetText("-")
    end
    local questNo1 = getSelfPlayer():get():getLastCompleteQuest(1)
    questWrapper = ToClient_getQuestWrapper(questNo1)
    if nil ~= questWrapper then
      _progressingQuest:SetText(questWrapper:getTitle())
    else
      _progressingQuest:SetText("-")
    end
    _addMessage:SetEditText(getSelfPlayer():get():getUserMemo())
  end
  local selfProxy = getSelfPlayer()
  local characterNo_64 = toInt64(0, 0)
  if nil ~= selfProxy then
    characterNo_64 = selfProxy:getCharacterNo_64()
  end
  _dailyStampBanner:SetShow(false)
  _dailyStampSlotBg:SetShow(false)
  _dailyStampText:SetShow(false)
  if false then
    local rewardIndex = ToClient_getAttendanceCount()
    if rewardIndex > 0 then
      return
    end
    if nil ~= nil then
      _dailyStampBanner:SetShow(true)
      _dailyStampSlotBg:SetShow(true)
      _dailyStampText:SetShow(true)
      slot:setItem(ToClient_getRewardItem(rewardIndex))
      slot.icon:addInputEvent("Mouse_On", "GameExit_Tooltip_Show(" .. rewardIndex .. ")")
      slot.icon:addInputEvent("Mouse_Out", "GameExit_Tooltip_Show()")
    end
  end
  local uiCount = 0
  local characterDatacount = getCharacterDataCount()
  for index = 0, 3 do
    local characterData = getCharacterDataByIndex(index)
    if nil == characterData then
      return
    end
    if characterNo_64 ~= characterData._characterNo_s64 then
      isCharacterSlot[index]:ResetVertexAni()
      isCharacterSelect[index]:SetShow(false)
      CharacterChangeButton[index]:SetShow(false)
    end
    if 4 == uiCount then
      break
    end
    uiCount = uiCount + 1
  end
  local uiCount = 0
  local characterDatacount = getCharacterDataCount()
  for charIndex = 0, 3 do
    local characterData = getCharacterDataByIndex(charIndex)
    if nil == characterData then
      return
    end
    if nil ~= characterData and characterNo_64 ~= characterData._characterNo_s64 then
      charEnterWaiting[uiCount]:SetText("")
      uiCount = uiCount + 1
    end
    if 4 == uiCount then
      break
    end
  end
end
function GameExit_Tooltip_Show(index)
  if nil == index then
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  local itemWrapper = ToClient_getRewardItem(index)
  local uiBase = slot.icon
  Panel_Tooltip_Item_Show(itemWrapper, uiBase, false, true)
end
function FromClient_ResponseEnchantFailCountOfMyCharacters()
  local uiCount = 0
  local characterDatacount = getCharacterDataCount()
  normalStack = {}
  valksStack = {}
  for index = 0, characterDatacount - 1 do
    local characterData = getCharacterDataByIndex(index)
    if nil == characterData then
      return
    end
    local defaultCount = characterData._enchantFailCount
    local valksCount = characterData._valuePackCount
    local characterNo_64 = characterData._characterNo_s64
    normalStack[characterNo_64] = defaultCount
    valksStack[characterNo_64] = valksCount
  end
end
function GameExit_SimpleTooltips(isShow, index, tipType, defaultCount, valksCount)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  if 0 == tipType then
    local isValksItemCheck = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GAMEEXIT_ENCHANTCOUNT_TOOLTIP", "defaultCount", tostring(defaultCount), "valksCount", tostring(valksCount))
    if isValksItem then
      isValksItemCheck = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GAMEEXIT_ENCHANTCOUNT_TOOLTIP", "defaultCount", tostring(defaultCount), "valksCount", tostring(valksCount))
    else
      isValksItemCheck = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GAMEEXIT_ENCHANTCOUNT_TOOLTIP_ADDCOUNT_NONE", "defaultCount", tostring(defaultCount))
    end
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_NORMALSTACK_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_NORMALSTACK_TOOLTIP_DESC") .. isValksItemCheck
    control = normalStackPool[index]
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHARWP_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "MAINSTATUS_DESC_WP")
    control = charWpCountPool[index]
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEEXIT_TRAYWINDOW")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_TOOLTIP_TRAYFORBLACKDESERT_DESC")
    control = _btn_Tray
  end
  if isShow == true then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function GameExit_Mini()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_TRAYBLACKDESERT_ACK"))
  ToClient_CheckTrayIcon()
  if Panel_GameExit:IsShow() then
    GameExit_Close()
  end
end
function GameExit_Close()
  if _btn_NoticeMsg:GetShow() then
    return
  end
  Panel_GameExit:SetShow(false, true)
  SetUIMode(prevUIMode)
  if -1 ~= exitMode then
    Panel_GameExit_sendGameDelayExitCancel()
  end
  local focusEdit = GetFocusEdit()
  if nil ~= focusEdit and focusEdit:GetKey() == _addMessage:GetKey() then
    ClearFocusEdit()
  end
  if Panel_ExitConfirm:GetShow() then
    _exitConfirm_Chk_Tray:SetCheck(false)
    Panel_ExitConfirm:SetShow(false)
  end
  local selfProxy = getSelfPlayer()
  local characterNo_64 = toInt64(0, 0)
  if nil ~= selfProxy then
    characterNo_64 = selfProxy:getCharacterNo_64()
  end
  local uiCount = 0
  local characterDatacount = getCharacterDataCount()
  for index = 0, 3 do
    local characterData = getCharacterDataByIndex(index)
    if nil == characterData then
      return
    end
    if characterNo_64 ~= characterData._characterNo_s64 then
      isCharacterSlot[index]:ResetVertexAni()
      isCharacterSelect[index]:SetShow(false)
      CharacterChangeButton[index]:SetShow(false)
    end
    if 4 == uiCount then
      break
    end
    uiCount = uiCount + 1
  end
  local uiCount = 0
  local characterDatacount = getCharacterDataCount()
  for charIndex = 0, 3 do
    local characterData = getCharacterDataByIndex(charIndex)
    if nil == characterData then
      return
    end
    if nil ~= characterData and characterNo_64 ~= characterData._characterNo_s64 then
      charEnterWaiting[uiCount]:SetText("-")
      uiCount = uiCount + 1
    end
    if 4 == uiCount then
      break
    end
  end
  if true == isTrayMode then
    ToClient_UnCheckTrayIcon()
    Panel_ExitConfirm:SetShow(false)
  end
end
function FromClient_RecentJournal_Update()
  journalContents:SetText("")
  local journal_Count = ToClient_GetRecentJournalCount()
  if journal_Count > 0 then
    for journal_Idx = 0, journal_Count - 1 do
      local journalWrapper = ToClient_GetRecentJournalByIndex(journal_Idx)
      if nil ~= journalWrapper then
        local stringData = "[" .. string.format("%.02d", journalWrapper:getJournalHour()) .. ":" .. string.format("%.02d", journalWrapper:getJournalMinute()) .. "] " .. journalWrapper:getName()
        if 0 == journal_Idx then
          journalContents:SetTextMode(UI_TM.eTextMode_LimitText)
          journalContents:SetText(stringData)
        else
          journalContents:SetTextMode(UI_TM.eTextMode_LimitText)
          journalContents:SetText(journalContents:GetText() .. "\n" .. stringData)
        end
      else
        journalContents:SetTextMode(UI_TM.eTextMode_LimitText)
        journalContents:SetText(journalContents:GetText() .. "\n" .. stringData)
      end
      journalFrameContents:SetSize(journalFrameContents:GetSizeX(), journalContents:GetTextSizeY())
    end
  else
    journalContents:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_JOURNALCONTENTS"))
  end
  if journalFrame:GetSizeY() < journalFrameContents:GetSizeY() then
    journalFrameScroll:SetShow(true)
  else
    journalFrameScroll:SetShow(false)
  end
  journalFrame:UpdateContentScroll()
  journalFrame:UpdateContentPos()
end
function GameExit_onScreenResize()
  Panel_GameExit:ComputePos()
  _block_BG:SetSize(getScreenSizeX() + 50, getScreenSizeY() + 50)
  _block_BG:SetHorizonCenter()
  _block_BG:SetVerticalMiddle()
end
Panel_GameExit_Initialize()
local function registEventHandler()
  _btn_Tray:addInputEvent("Mouse_LUp", "GameExit_Mini()")
  _btn_Tray:addInputEvent("Mouse_On", "GameExit_SimpleTooltips(true, 0, 2)")
  _btn_Tray:addInputEvent("Mouse_Out", "GameExit_SimpleTooltips(false)")
  _btn_Tray:setButtonShortcuts("PANEL_GAMEEXIT_TRAYWINDOW")
  _btn_winClose:addInputEvent("Mouse_LUp", "GameExit_Close()")
  _btn_gameExit:addInputEvent("Mouse_LUp", "Panel_GameExit_ClickGameOff()")
  _btn_selectCharacter:addInputEvent("Mouse_LUp", "Panel_GameExit_ClickSelectCharacter()")
  _btn_NoticeMsg:addInputEvent("Mouse_LUp", "Panel_GameExit_sendGameDelayExitCancel()")
  _buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelGameExit\" )")
  _buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelGameExit\", \"true\")")
  _buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelGameExit\", \"false\")")
  _exitConfirm_Btn_Confirm:addInputEvent("Mouse_LUp", "Panel_GameExit_MinimizeTray()")
  _exitConfirm_Btn_Cancle:addInputEvent("Mouse_LUp", "Panel_GameExit_Minimize()")
end
local function registMessageHandler()
  Panel_GameExit:RegisterUpdateFunc("gameExit_UpdatePerFrame")
  registerEvent("EventGameExitDelayTime", "setGameExitDelayTime")
  registerEvent("EventReceiveEnterWating", "refreshCharacterInfoData(" .. photoIndex .. ")")
  registerEvent("EventGameWindowClose", "GameExitShowToggle()")
  registerEvent("FromClient_RecentJournal_Update", "FromClient_RecentJournal_Update")
  registerEvent("FromClient_TrayIconMessageBox", "FromClient_TrayIconMessageBox")
  registerEvent("FromClient_ResponseEnchantFailCountOfMyCharacters", "refreshCharacterInfoData(" .. photoIndex .. ")")
  registerEvent("onScreenResize", "GameExit_onScreenResize")
end
function PaGlobal_getIsExitPhoto()
  return isExitPhoto
end
registEventHandler()
registMessageHandler()
ToClient_RequestCharacterEnchantFailCount()
