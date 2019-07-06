Panel_Npc_Dialog:SetShow(false)
Panel_Npc_Dialog:setGlassBackground(true)
Panel_Npc_Dialog:setFlushAble(false)
Panel_Npc_Dialog:RegisterShowEventFunc(true, "NpcDialogShowAni()")
Panel_Npc_Dialog:RegisterShowEventFunc(false, "NpcDialogHideAni()")
FGlobal_Dialog_renderMode = RenderModeWrapper.new(100, {
  Defines.RenderMode.eRenderMode_Dialog
}, false)
function FGlobal_Dialog_SetRenderMode(renderModeList)
  FGlobal_Dialog_renderMode:setRenderMode(renderModeList)
end
function FGlobal_Dialog_ResetRenderMode()
  FGlobal_Dialog_renderMode:reset()
end
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_DS = CppEnums.DialogState
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_BTN_TYPE = CppEnums.DialogButtonType
local UI_PD = CppEnums.Padding
local getScrX = getScreenSizeX()
local getScrY = getScreenSizeY()
local _mainDialog = {}
local _currentLine = 0
local _maxLine = 0
local _equipRewardCount = 0
local giftIcon = {}
local _ignoreShowDialog = false
local _doConfirmIndex = 0
local _isQuestComplete = false
local dialogCountList = {}
local isFirstShowTooltip = true
local _math_AddVectorToVector = Util.Math.AddVectorToVector
local _math_MulNumberToVector = Util.Math.MulNumberToVector
local isAuctionDialog = false
local isReContactDialog = false
local isDialogFunctionQuest = false
local _questDialogButtonIndex = -1
local isExchangeButtonIndex = {}
local isPromiseToken = {}
local _exchangalbeButtonIndex = -1
local _skillTutorial = false
local handleClickedQuestComplete = false
local nextQuestFunctionBtnClick = {}
local isAllowTutorialPanelShow = false
local warehouseIndex = -1
local tradeIndex = -1
local uv = {
  [0] = {
    _fileName = "Renewal/Progress/Console_Progressbar_02.dds",
    x1 = 163,
    y1 = 416,
    x2 = 194,
    y2 = 447
  },
  {
    _fileName = "Renewal/Progress/Console_Progressbar_02.dds",
    x1 = 195,
    y1 = 416,
    x2 = 226,
    y2 = 447
  },
  {
    _fileName = "Renewal/Progress/Console_Progressbar_02.dds",
    x1 = 163,
    y1 = 448,
    x2 = 194,
    y2 = 479
  },
  {
    _fileName = "Renewal/Progress/Console_Progressbar_02.dds",
    x1 = 195,
    y1 = 448,
    x2 = 226,
    y2 = 479
  },
  {
    _fileName = "Renewal/Progress/Console_Progressbar_02.dds",
    x1 = 163,
    y1 = 448,
    x2 = 194,
    y2 = 479
  },
  {
    _fileName = "Renewal/Progress/Console_Progressbar_02.dds",
    x1 = 227,
    y1 = 448,
    x2 = 258,
    y2 = 479
  }
}
local _shopType = {
  eShopType_None = 0,
  eShopType_Potion = 1,
  eShopType_Weapon = 2,
  eShopType_Jewel = 3,
  eShopType_Furniture = 4,
  eShopType_Collect = 5,
  eShopType_Fish = 6,
  eShopType_Worker = 7,
  eShopType_Alchemy = 8,
  eShopType_Cook = 9,
  eShopType_PC = 10,
  eShopType_Grocery = 11,
  eShopType_RandomShop = 12,
  eShopType_DayRandomShop = 13,
  eShopType_Count = 14
}
local _dialogIndex = 0
local dialogButtonMaxSize = 0
function FGlobal_Dialog_SetAllowTutorialPanelShow(bShow)
  isAllowTutorialPanelShow = bShow
end
function FGlobal_Dialog_IsAllowTutorialPanelShow()
  return isAllowTutorialPanelShow
end
local _uiNpcTitle = UI.getChildControl(Panel_Npc_Dialog, "Static_NPC")
local _uiNpcName = UI.getChildControl(Panel_Npc_Dialog, "Static_NPC_Name")
local _uiNpcDialog = UI.getChildControl(Panel_Npc_Dialog, "Static_NPC_Content")
local _uiDialogButton = {}
local _uiDialogIcon = {}
local _uiFuncButton = {}
local _uiFuncBG = {}
local _uiNoticeNeedInfo = {}
local _uiCutSceneDesc = {}
local _uiNeedWpAni = {}
local _uiIntimacyIcon = {}
local _styleNormalTalkButton = UI.getChildControl(Panel_Npc_Dialog, "style_Button_Original")
local _styleExploreTalkButton = UI.getChildControl(Panel_Npc_Dialog, "style_Button_Explore")
local _styleDialogButtonIcon = UI.getChildControl(Panel_Npc_Dialog, "Static_DialogButtonIcon")
local _styleNoticeNeedInfo = UI.getChildControl(Panel_Npc_Dialog, "StaticText_Notice")
local _styleNeedWpAni = UI.getChildControl(Panel_Npc_Dialog, "Static_NeedWpAni")
local _SpacebarIcon = UI.getChildControl(Panel_Npc_Dialog, "StaticText_Spacebar")
local _uiNextButton = UI.getChildControl(Panel_Npc_Dialog, "Button_Next")
local _uiButtonExit = UI.getChildControl(Panel_Npc_Dialog, "Button_Exit")
local _uiButtonBack = UI.getChildControl(Panel_Npc_Dialog, "Button_Back")
local _intimacyProgressBG = UI.getChildControl(Panel_Npc_Dialog, "Static_ProgressBG")
local _txt_intimacy = UI.getChildControl(_intimacyProgressBG, "StaticText_Intimacy")
local _intimacyFruitageValue = UI.getChildControl(_intimacyProgressBG, "StaticText_Fruitage_Value")
local _intimacyCircularProgress = UI.getChildControl(_intimacyProgressBG, "CircularProgress_Current")
local _intimacyGiftIcon = UI.getChildControl(Panel_Npc_Dialog, "Static_GiftIcon")
local _intimacyButtonIcon = UI.getChildControl(Panel_Npc_Dialog, "Static_Intimacy")
local intimacyNotice = UI.getChildControl(Panel_Npc_Dialog, "Static_Notice")
local intimacyNoticeStyle = UI.getChildControl(Panel_Npc_Dialog, "StaticText_IntimacyNotice")
local _txt_EnchantHelp = UI.getChildControl(Panel_Npc_Dialog, "StaticText_EnchantMsg")
local _txt_EnchantHelp_Desc = UI.getChildControl(Panel_Npc_Dialog, "StaticText_EnchantMsg_Desc")
local _txt_SocketHelp = UI.getChildControl(Panel_Npc_Dialog, "StaticText_SocketMsg")
local _txt_SocketHelp_Desc = UI.getChildControl(Panel_Npc_Dialog, "StaticText_SocketMsg_Desc")
local giftNotice = UI.getChildControl(Panel_Npc_Dialog, "StaticText_GiftNotice")
local _wpHelp = UI.getChildControl(Panel_Npc_Dialog, "StaticText_BubbleBox")
local _uiHalfLine = UI.getChildControl(Panel_Npc_Dialog, "Static_HalfLine")
local _prevPageButton = UI.getChildControl(Panel_Npc_Dialog, "Button_PrevPage")
local _nextPageButton = UI.getChildControl(Panel_Npc_Dialog, "Button_NextPage")
local _pageValue = UI.getChildControl(Panel_Npc_Dialog, "StaticText_PageValue")
local _scrollControl = UI.getChildControl(Panel_Npc_Dialog, "Static_ContolForScroll")
local _staticTutorialMenuBG = UI.getChildControl(Panel_Npc_Dialog, "Static_Dialog_TutorialMenu_BG")
local _buttonTutorialMenu = UI.getChildControl(Panel_Npc_Dialog, "Button_Dialog_TutorialMenu")
local _staticTutorialTriDeco = UI.getChildControl(Panel_Npc_Dialog, "Static_Dialog_TriangleDecoration")
local _tutorialStartButtonList = {}
local _tutorialMenuButtonMarginSize = 5
local _buttonBlackSpiritSkillSelect = UI.getChildControl(Panel_Npc_Dialog, "Button_BlackSpirt_SkillSelect")
local intimacyNoticeText = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, intimacyNotice, "intimacyNoticeText")
local _uiFilterRadioButton = {
  [0] = UI.getChildControl(Panel_Npc_Dialog, "RadioButton_Filter_All"),
  [1] = UI.getChildControl(Panel_Npc_Dialog, "RadioButton_Filter_Main"),
  [2] = UI.getChildControl(Panel_Npc_Dialog, "RadioButton_Filter_Recommend"),
  [3] = UI.getChildControl(Panel_Npc_Dialog, "RadioButton_Filter_Repeat")
}
local _uiFilterString = {
  [1] = _uiFilterRadioButton[1]:GetText(),
  [2] = _uiFilterRadioButton[2]:GetText(),
  [3] = _uiFilterRadioButton[3]:GetText()
}
local dialogShowCheck_Once = false
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_DialogMain")
function FromClient_luaLoadComplete_DialogMain()
  FGlobal_Dialog_TutorialStartButton_Init()
  _uiNpcDialog:SetIgnore(false)
  _buttonTutorialMenu:addInputEvent("Mouse_LUp", "FGlobal_Dialog_HandleClicked_TutorialMenuButton()")
end
function FGlobal_Dialog_TutorialStartButton_Init()
  _tutorialStartButtonList[1] = UI.getChildControl(Panel_Npc_Dialog, "Button_TutorialStart_1")
  _tutorialStartButtonList[2] = UI.getChildControl(Panel_Npc_Dialog, "Button_TutorialStart_2")
  _tutorialStartButtonList[3] = UI.getChildControl(Panel_Npc_Dialog, "Button_TutorialStart_3")
  _tutorialStartButtonList[4] = UI.getChildControl(Panel_Npc_Dialog, "Button_TutorialStart_4")
  _tutorialStartButtonList[1]:addInputEvent("Mouse_LUp", "FGlobal_Dialog_HandleClicked_TutorialStartButton(1)")
  _tutorialStartButtonList[2]:addInputEvent("Mouse_LUp", "FGlobal_Dialog_HandleClicked_TutorialStartButton(2)")
  _tutorialStartButtonList[3]:addInputEvent("Mouse_LUp", "FGlobal_Dialog_HandleClicked_TutorialStartButton(3)")
  _tutorialStartButtonList[4]:addInputEvent("Mouse_LUp", "FGlobal_Dialog_HandleClicked_TutorialStartButton(4)")
end
function FGlobal_Dialog_ShowTutorialMenuButton()
  FGlobal_Dialog_FoldTutorialMenu(_tutorialMenuButtonMarginSize)
  _buttonTutorialMenu:SetShow(true, true)
  _staticTutorialMenuBG:SetShow(true, true)
  _staticTutorialTriDeco:SetShow(true, true)
  local triDecoPosX = Panel_Npc_Dialog:GetSizeX() / 2 - _staticTutorialTriDeco:GetSizeX() / 2
  _staticTutorialTriDeco:SetPosX(triDecoPosX - 1)
  _staticTutorialTriDeco:SetPosY(-_tutorialMenuButtonMarginSize)
  _buttonTutorialMenu:AddEffect("UI_ItemInstall", false, 0, 0)
end
function FGlobal_Dialog_HideTutorialMenuButton()
  _buttonTutorialMenu:SetShow(false, true)
  _staticTutorialMenuBG:SetShow(false, false)
  _staticTutorialTriDeco:SetShow(false, false)
  FGlobal_Dialog_HideTutorialStartButtonList()
end
function FGlobal_Dialog_HandleClicked_TutorialMenuButton()
  _buttonTutorialMenu:AddEffect("fUI_Light", false, 0, 0)
  local isShown = false
  for key, value in pairs(_tutorialStartButtonList) do
    if true == value:GetShow() then
      isShown = true
      break
    end
  end
  if true == isShown then
    FGlobal_Dialog_HideTutorialStartButtonList()
  elseif false == isShown then
    FGlobal_Dialog_ShowTutorialStartButtonList()
  end
end
function FGlobal_Dialog_CheckConditionTutorialMenuButton()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local playerLevel = getSelfPlayer():get():getLevel()
  if playerLevel >= 10 and playerLevel <= 40 and false and -1 ~= FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Shop) then
    local talker = dialog_getTalker()
    if nil == talker then
      return false
    end
    local actorProxyWrapper = getNpcActor(talker:getActorKey())
    if nil == actorProxyWrapper then
      return false
    end
    local characterSSW = actorProxyWrapper:getCharacterStaticStatusWrapper()
    if nil == characterSSW then
      return false
    end
    if true == characterSSW:isSellingNormalShop() then
      return true
    end
  end
  if playerLevel >= 25 and playerLevel <= 53 and false and -1 ~= FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Enchant) then
    return not _ContentsGroup_isUsedNewEnchant
  end
  if playerLevel >= 40 and playerLevel <= 56 and false and -1 ~= FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Extract) then
    return true
  end
  if playerLevel >= 50 and playerLevel <= 56 and false and -1 ~= FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Enchant) then
    return true
  end
  return false
end
function FGlobal_Dialog_ShowTutorialStartButtonList()
  FGlobal_Dialog_HideTutorialStartButtonList()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local playerLevel = getSelfPlayer():get():getLevel()
  local orderNum = 1
  local marginSize = _tutorialMenuButtonMarginSize
  local lastButtonPosY = 0
  local function placePos(tutorialStartButton, orderNum)
    local endTime = 0.25
    local startPosX = Panel_Npc_Dialog:GetSizeX() / 2 - tutorialStartButton:GetSizeX() / 2
    local endPosX = Panel_Npc_Dialog:GetSizeX() / 2 - tutorialStartButton:GetSizeX() / 2
    local startPosY = tutorialStartButton:GetSizeY() * -1
    local endPosY = orderNum * (tutorialStartButton:GetSizeY() + marginSize) * -1
    tutorialStartButton:SetPosX(startPosX)
    tutorialStartButton:SetPosY(startPosY)
    tutorialStartButton:SetShow(true)
    local aniMove = tutorialStartButton:addMoveAnimation(0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    aniMove:SetStartPosition(startPosX, startPosY)
    aniMove:SetEndPosition(endPosX, endPosY)
    aniMove:SetDisableWhileAni(true)
    lastButtonPosY = endPosY
  end
  if playerLevel >= 10 and playerLevel <= 40 and -1 ~= FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Shop) then
    local talker = dialog_getTalker()
    if nil == talker then
      return false
    end
    local actorProxyWrapper = getNpcActor(talker:getActorKey())
    if nil == actorProxyWrapper then
      return false
    end
    local characterSSW = actorProxyWrapper:getCharacterStaticStatusWrapper()
    if nil == characterSSW then
      return false
    end
    if true == characterSSW:isSellingNormalShop() then
      placePos(_tutorialStartButtonList[1], orderNum)
      orderNum = orderNum + 1
    end
  end
  if playerLevel >= 25 and playerLevel <= 53 and -1 ~= FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Enchant) then
    placePos(_tutorialStartButtonList[2], orderNum)
    orderNum = orderNum + 1
  end
  if playerLevel >= 40 and playerLevel <= 56 and -1 ~= FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Extract) then
    placePos(_tutorialStartButtonList[3], orderNum)
    orderNum = orderNum + 1
  end
  if playerLevel >= 50 and playerLevel <= 56 and -1 ~= FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Enchant) then
    placePos(_tutorialStartButtonList[4], orderNum)
    orderNum = orderNum + 1
  end
  FGlobal_Dialog_UnfoldTutorialMenu(lastButtonPosY, marginSize)
end
function FGlobal_Dialog_UnfoldTutorialMenu(lastButtonPosY, marginSize)
  local endTime = 0.25
  local menuBG_StartPosX = Panel_Npc_Dialog:GetSizeX() / 2 - _staticTutorialMenuBG:GetSizeX() / 2
  local menuBG_StartPosY = -_buttonTutorialMenu:GetSizeY() / 2 - marginSize
  local menuBG_EndPosX = menuBG_StartPosX
  local menuBG_EndPosY = lastButtonPosY - marginSize - _buttonTutorialMenu:GetSizeY() / 2
  local aniMoveMenuBG = _staticTutorialMenuBG:addMoveAnimation(0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniMoveMenuBG:SetStartPosition(menuBG_StartPosX, menuBG_StartPosY)
  aniMoveMenuBG:SetEndPosition(menuBG_EndPosX, menuBG_EndPosY)
  aniMoveMenuBG:SetDisableWhileAni(true)
  _staticTutorialMenuBG:SetSize(_staticTutorialMenuBG:GetSizeX(), math.abs(menuBG_EndPosY))
  local menuButton_StartPosX = Panel_Npc_Dialog:GetSizeX() / 2 - _buttonTutorialMenu:GetSizeX() / 2 - 1
  local menuButton_StartPosY = menuBG_StartPosY - _buttonTutorialMenu:GetSizeY() / 2 + 1
  local menuButton_EndPosX = menuButton_StartPosX
  local menuButton_EndPosY = menuBG_EndPosY - _buttonTutorialMenu:GetSizeY() / 2 + 1
  local aniMoveMenuButton = _buttonTutorialMenu:addMoveAnimation(0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniMoveMenuButton:SetStartPosition(menuButton_StartPosX, menuButton_StartPosY)
  aniMoveMenuButton:SetEndPosition(menuButton_EndPosX, menuButton_EndPosY)
  aniMoveMenuButton:SetDisableWhileAni(true)
end
function FGlobal_Dialog_FoldTutorialMenu(marginSize)
  local endTime = 0.25
  local menuBG_StartPosX = Panel_Npc_Dialog:GetSizeX() / 2 - _staticTutorialMenuBG:GetSizeX() / 2
  local menuBG_StartPosY = _staticTutorialMenuBG:GetPosY()
  local menuBG_EndPosX = menuBG_StartPosX
  local menuBG_EndPosY = -_buttonTutorialMenu:GetSizeY() / 2 - marginSize
  local aniMoveMenuBG = _staticTutorialMenuBG:addMoveAnimation(0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniMoveMenuBG:SetStartPosition(menuBG_StartPosX, menuBG_StartPosY)
  aniMoveMenuBG:SetEndPosition(menuBG_EndPosX, menuBG_EndPosY)
  aniMoveMenuBG:SetDisableWhileAni(true)
  _staticTutorialMenuBG:SetSize(_staticTutorialMenuBG:GetSizeX(), math.abs(menuBG_EndPosY))
  local menuButton_StartPosX = Panel_Npc_Dialog:GetSizeX() / 2 - _buttonTutorialMenu:GetSizeX() / 2 - 1
  local menuButton_StartPosY = _buttonTutorialMenu:GetPosY()
  local menuButton_EndPosX = menuButton_StartPosX
  local menuButton_EndPosY = menuBG_EndPosY - _buttonTutorialMenu:GetSizeY() / 2 + 1
  local aniMoveMenuButton = _buttonTutorialMenu:addMoveAnimation(0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniMoveMenuButton:SetStartPosition(menuButton_StartPosX, menuButton_StartPosY)
  aniMoveMenuButton:SetEndPosition(menuButton_EndPosX, menuButton_EndPosY)
  aniMoveMenuButton:SetDisableWhileAni(true)
end
function FGlobal_Dialog_HideTutorialStartButtonList()
  for key, value in pairs(_tutorialStartButtonList) do
    value:SetShow(false)
  end
  FGlobal_Dialog_FoldTutorialMenu(_tutorialMenuButtonMarginSize)
end
function FGlobal_Dialog_HandleClicked_TutorialStartButton(listIndex)
  FGlobal_Dialog_HideTutorialStartButtonList()
  local phaseNo = -1
  if 1 == listIndex then
    phaseNo = 21
  elseif 2 == listIndex then
    phaseNo = 18
  elseif 3 == listIndex then
    phaseNo = 19
  elseif 4 == listIndex then
    phaseNo = 22
  else
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\235\139\164\236\157\180\236\150\188\235\161\156\234\183\184 \237\138\156\237\134\160\235\166\172\236\150\188 \236\139\156\236\158\145\235\178\132\237\138\188\236\157\152 \235\178\136\237\152\184\234\176\128 \236\158\152\235\170\187 \235\144\152\236\151\136\236\138\181\235\139\136\235\139\164. listIndex : " .. tostring(listIndex))
    return
  end
  PaGlobal_TutorialManager:handleClickedDialogTutorialStartButton(phaseNo)
end
function Panel_Npc_Dialog:Initialize()
  for index = 0, 3 do
    _uiDialogButton[index] = UI.getChildControl(Panel_Npc_Dialog, "Button_Dialog_" .. tostring(index))
    _uiDialogButton[index]:addInputEvent("Mouse_LUp", "HandleClickedDialogButton(" .. index .. ")")
    if isGameTypeEnglish() or isGameTypeSA() or isGameTypeTH() or isGameTypeID() or isGameTypeTR() or isGameTypeRussia() then
      _uiDialogButton[index]:SetSize(500, _uiDialogButton[index]:GetSizeY())
    else
      _uiDialogButton[index]:SetSize(395, _uiDialogButton[index]:GetSizeY())
    end
    _uiDialogButton[index]:ComputePos()
    _uiDialogIcon[index] = UI.createControl(UCT.PA_UI_CONTROL_STATIC, _uiDialogButton[index], "StaticText_DialogIcon_" .. tostring(index))
    CopyBaseProperty(_styleDialogButtonIcon, _uiDialogIcon[index])
    _uiDialogIcon[index]:SetPosX(5)
    _uiDialogIcon[index]:SetPosY(4)
  end
  for index = 0, 5 do
    _uiFuncButton[index] = UI.getChildControl(Panel_Npc_Dialog, "Button_Menu_" .. tostring(index))
    _uiFuncButton[index]:addInputEvent("Mouse_LUp", "HandleClickedFuncButton(" .. index .. ")")
    _uiFuncButton[index]:SetPosX(index * 180 + 200)
    _uiFuncButton[index]:SetPosY(38)
    _uiFuncButton[index]:SetTextVerticalCenter()
    _uiFuncButton[index]:SetTextHorizonCenter()
    if not isGameTypeKorea() then
      _uiFuncButton[index]:SetTextMode(UI_TM.eTextMode_LimitText)
    end
  end
  for index = 0, 5 do
    _uiFuncBG[index] = UI.getChildControl(Panel_Npc_Dialog, "Static_MenuAni_" .. tostring(index))
  end
  for index = 0, 3 do
    _uiCutSceneDesc[index] = UI.getChildControl(Panel_Npc_Dialog, "StaticText_CutSceneDesc_" .. tostring(index))
    _uiCutSceneDesc[index]:SetPosX(getScrX / 2 + 180)
    _uiCutSceneDesc[index]:SetPosY(_uiDialogButton[index]:GetPosY())
  end
  for index = 0, 3 do
    _uiNoticeNeedInfo[index] = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, Panel_Npc_Dialog, "StaticText_Notice_" .. tostring(index))
    CopyBaseProperty(_styleNoticeNeedInfo, _uiNoticeNeedInfo[index])
    _uiNoticeNeedInfo[index]:SetPosX(getScrX / 2 + 180)
    _uiNoticeNeedInfo[index]:SetPosY(_uiDialogButton[index]:GetPosY())
  end
  for index = 0, 3 do
    _uiNeedWpAni[index] = UI.createControl(UCT.PA_UI_CONTROL_STATIC, Panel_Npc_Dialog, "Static_NeedWpAni_" .. tostring(index))
    CopyBaseProperty(_styleNeedWpAni, _uiNeedWpAni[index])
    _uiNeedWpAni[index]:SetPosX(getScrX / 2 - 170)
    _uiNeedWpAni[index]:SetPosY(_uiDialogButton[index]:GetPosY())
  end
  for index = 0, 3 do
    _uiIntimacyIcon[index] = UI.createControl(UCT.PA_UI_CONTROL_STATIC, Panel_Npc_Dialog, "Static_Intimacy_Button_" .. tostring(index))
    CopyBaseProperty(_intimacyButtonIcon, _uiIntimacyIcon[index])
  end
  for index = 0, 3 do
    _uiFilterRadioButton[index]:addInputEvent("Mouse_LUp", "HandleClickedFilterButton(" .. index .. ")")
    _uiFilterRadioButton[index]:SetShow(false)
    _uiFilterRadioButton[index]:SetCheck(0 == index)
  end
  _uiFilterRadioButton[0]:addInputEvent("Mouse_On", "HandleOverd_FilterAllButton(true)")
  _uiFilterRadioButton[0]:addInputEvent("Mouse_Out", "HandleOverd_FilterAllButton(false)")
end
Panel_Npc_Dialog:Initialize()
CopyBaseProperty(intimacyNoticeStyle, intimacyNoticeText)
UI.deleteControl(intimacyNoticeStyle)
intimacyNoticeStyle = nil
intimacyNoticeText:SetSpanSize(10, 0)
_wpHelp:SetFontAlpha(0)
_wpHelp:SetAlpha(0)
_styleNoticeNeedInfo:SetAlpha(0)
_styleNoticeNeedInfo:SetFontAlpha(0)
_styleNormalTalkButton:SetShow(false)
_styleExploreTalkButton:SetShow(false)
_uiNextButton:addInputEvent("Mouse_LUp", "HandleClickedDialogNextButton()")
_uiNextButton:SetPosX(getScrX / 2 - _uiNextButton:GetSizeX() / 2)
_SpacebarIcon:SetSize(40, 28)
_SpacebarIcon:SetPosX(_uiDialogButton[0]:GetPosX() + _uiDialogButton[0]:GetSizeX() - _SpacebarIcon:GetSizeX() - 5)
local defaultDialogBtnSizeX = _uiDialogButton[0]:GetSizeX()
local _rBtnPosX = _uiDialogButton[0]:GetPosX() + _uiDialogButton[0]:GetSizeX() - _SpacebarIcon:GetSizeX() - 5
local _rBtnPosY = _uiDialogButton[0]:GetPosY()
_uiButtonExit:addInputEvent("Mouse_On", "Dialog_EtcButtonToolTips( true," .. 0 .. ")")
_uiButtonExit:addInputEvent("Mouse_Out", "Dialog_EtcButtonToolTips( false," .. 0 .. ")")
function PaGlobalFunc_BlackSpiritSkillSelect_ShowToolTip()
  local name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WIDGET_BLACKSPIRIT_SKINSELECT_TITLE")
  local dese = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NPC_DIALOG_BACK_BLACKSPIRIT_BUTTON_DESE")
  TooltipSimple_Show(_buttonBlackSpiritSkillSelect, name, dese)
end
_buttonBlackSpiritSkillSelect:addInputEvent("Mouse_LUp", "PaGloabl_BlackSpiritSkillSelect_Open()")
_buttonBlackSpiritSkillSelect:addInputEvent("Mouse_On", "PaGlobalFunc_BlackSpiritSkillSelect_ShowToolTip()")
_buttonBlackSpiritSkillSelect:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
function Button_Exit()
  _uiButtonExit:addInputEvent("Mouse_LUp", "FGlobal_HideDialog()")
end
_uiButtonBack:addInputEvent("Mouse_On", "Dialog_EtcButtonToolTips( true," .. 1 .. ")")
_uiButtonBack:addInputEvent("Mouse_Out", "Dialog_EtcButtonToolTips( false," .. 1 .. ")")
function Button_Back()
  _uiButtonBack:addInputEvent("Mouse_LUp", "HandleClickedBackButton()")
end
function NpcDialogShowAni()
  audioPostEvent_SystemUi(1, 19)
  UIAni.fadeInSCR_Up(Panel_Npc_Dialog)
  Button_Exit()
  Button_Back()
  _uiNpcDialog:SetVerticalMiddle()
  if 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
    _uiNpcDialog:SetPosY(78)
  else
    _uiNpcDialog:SetPosY(78)
  end
  Inventory_PosSaveMemory()
end
function NpcDialogHideAni()
  audioPostEvent_SystemUi(1, 20)
  Panel_Npc_Dialog:ResetVertexAni()
  Panel_Npc_Dialog:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local Ani1 = Panel_Npc_Dialog:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  Ani1:SetStartColor(UI_color.C_FFFFFFFF)
  Ani1:SetEndColor(UI_color.C_00FFFFFF)
  Ani1:SetStartIntensity(3)
  Ani1:SetEndIntensity(1)
  Ani1.IsChangeChild = true
  Ani1:SetHideAtEnd(true)
  Ani1:SetDisableWhileAni(true)
end
function Dialog_updateMainDialog()
  _dialogIndex = 0
  local realDialog = ToClient_getReplaceDialog(_mainDialog[_currentLine])
  _uiNpcDialog:SetText(realDialog)
  if _currentLine < _maxLine then
    _uiNextButton:SetShow(true)
    _SpacebarIcon:SetShow(true)
    Dialog_updateButtons(false)
    _SpacebarIcon:SetSize(40, _uiDialogButton[0]:GetSizeY())
    _SpacebarIcon:SetPosX(_rBtnPosX)
    _SpacebarIcon:SetPosY(_rBtnPosY)
  else
    _uiNextButton:SetShow(false)
    _SpacebarIcon:SetShow(false)
    Dialog_updateButtons(true)
    PaGlobal_TutorialManager:handleUpdateMainDialog()
  end
  _SpacebarIcon:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_INTERACTION_FUNCTIONKEY"))
  Auto_NotifyChangeDialog()
end
local function PreclosePanel_OpenDialog()
  if Panel_QuestInfo:GetShow() then
    questInfo_TooltipShow(false)
  end
  if PaGlobalFunc_ItemMarketRegistItem_GetShow() then
    FGlobal_ItemMarketRegistItem_Close()
  end
  if FGlobal_Option_GetShow() then
    GameOption_Cancel()
    TooltipSimple_Hide()
  end
  if false == _ContentsGroup_NewUI_BlackSmith_All then
    if nil ~= Panel_Window_Extraction_Caphras and Panel_Window_Extraction_Caphras:GetShow() then
      PaGlobal_ExtractionCaphras_Close()
    end
  elseif nil ~= Panel_Window_Extraction_Caphras_All and Panel_Window_Extraction_Caphras_All:GetShow() then
    PaGlobal_Extraction_Caphras_All_Close()
  end
  if Panel_ColorBalance:GetShow() then
    Panel_ColorBalance_Close()
  end
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    if nil ~= Panel_Window_WorkerManager_All and Panel_Window_WorkerManager_All:GetShow() then
      PaGlobalFunc_WorkerManager_All_Close()
      FGlobal_InitWorkerTooltip()
    end
  elseif nil ~= Panel_WorkerManager and Panel_WorkerManager:GetShow() then
    workerManager_Close()
    FGlobal_InitWorkerTooltip()
  end
  if Panel_Menu:GetShow() then
    Panel_Menu_Close()
  end
  if Panel_Window_Camp:GetShow() then
    PaGlobal_Camp:close()
  end
  DetectPlayer_Close()
  if PaGlobalFunc_ItemMarket_GetShow() then
    FGolbal_ItemMarketNew_Close()
    if Panel_Win_System:GetShow() then
      messageBox_NoButtonUp()
    end
  end
  if dialogShowCheck_Once == false then
    InventoryWindow_Close()
    ClothInventory_Close()
  end
  if false == _ContentsGroup_RenewUI_SearchMode then
    if Panel_Dialog_Search:IsShow() then
      searchView_Close()
    end
  elseif true == PaGlobalFunc_SearchMode_IsSearchMode() then
    searchView_Close()
  end
  if true == _ContentsGroup_RenewUI_ItemMarketPlace and (true == PaGlobalFunc_MarketPlace_GetShow() or true == PaGlobalFunc_MarketWallet_GetShow()) then
    PaGlobalFunc_MarketPlace_CloseAllCheck()
  end
  _PA_LOG("\235\172\184\236\158\165\237\153\152", "Check")
end
function FromClient_ShowFilterButton(isShow)
  local isDev = ToClient_IsDevelopment()
  if false == isDev then
    isShow = false
  end
end
function FromClient_ShowDialog()
  if true == PaGlobal_QAServantSupportOn then
    return
  end
  PaGlobal_TutorialManager:handleBeforeShowDialog()
  FGlobal_RemoteControl_Hide()
  FGlobal_WebHelper_ForceClose()
  local charLevel = getSelfPlayer():get():getLevel()
  if CheckTutorialEnd() then
    ToClient_SaveUiInfo(false)
  end
  PreclosePanel_OpenDialog()
  local isShow = Panel_GameExit:IsShow()
  if true == isShow then
    Panel_GameExit:SetShow(false)
  end
  _wpHelp:SetShow(false)
  intimacyNotice:SetShow(false)
  intimacyNoticeText:SetShow(false)
  if true == _ignoreShowDialog then
    return
  end
  if GetUIMode() ~= Defines.UIMode.eUIMode_Default and GetUIMode() ~= Defines.UIMode.eUIMode_NpcDialog and GetUIMode() ~= Defines.UIMode.eUIMode_NpcDialog_Dummy and GetUIMode() ~= Defines.UIMode.eUIMode_ItemMarket then
    ToClient_PopDialogueFlush()
    return
  end
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    ToClient_PopDialogueFlush()
    return
  end
  local mainDialog = dialogData:getMainDialog()
  if mainDialog == "" then
    ToClient_PopDialogueFlush()
    return
  end
  local localizedType = dialogData:getLocalizedTypeForLua()
  local mainDialogLocalizedKey = dialogData:getMainDialogLocalizedKey()
  if mainDialogLocalizedKey == nil then
    ToClient_PopDialogueFlush()
    return
  end
  _uiNpcDialog:setLocalizedStaticType(localizedType)
  _uiNpcDialog:setLocalizedKey(mainDialogLocalizedKey)
  if not isFullSizeModeAble(FullSizeMode.fullSizeModeEnum.Dialog) then
    ToClient_PopDialogueFlush()
    return
  else
    setFullSizeMode(true, FullSizeMode.fullSizeModeEnum.Dialog)
  end
  SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
  warehouse_requestInfo(getCurrentWaypointKey())
  Panel_Tooltip_Item_hideTooltip()
  Panel_SkillTooltip_Hide()
  FGlobal_BuffTooltipOff()
  Interaction_Close()
  FGlobal_Dialog_renderMode:set()
  setShowLine(false)
  PaGlobalAppliedBuffList:hide()
  for index = 0, 5 do
    _uiFuncBG[index]:SetShow(false)
  end
  _equipRewardCount = 0
  _currentLine = 0
  if Panel_Window_Exchange:GetShow() then
    ExchangePC_MessageBox_ResponseCancel()
  end
  setShowNpcDialog(true)
  local npcTitle = dialogData:getContactNpcTitle()
  local npcName = dialogData:getContactNpcName()
  local talkerNpcKey = dialog_getTalkNpcKey()
  if 0 ~= talkerNpcKey then
    _buttonBlackSpiritSkillSelect:SetShow(false)
    _uiNpcTitle:SetText(npcTitle)
    _uiNpcName:SetText(npcName)
  else
    _buttonBlackSpiritSkillSelect:SetShow(ToClient_isAvailableSelectBlackSpirit())
    _uiNpcTitle:SetText(npcTitle)
    _uiNpcName:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_BLACKSOUL"))
  end
  if npcTitle == "" or npcTitle == nil then
    _uiNpcName:SetPosX(getScreenSizeX() / 2 - _uiNpcName:GetTextSizeX() / 2)
  else
    _uiNpcTitle:SetPosX(getScreenSizeX() / 2 - (_uiNpcTitle:GetTextSizeX() + _uiNpcName:GetTextSizeX() + 16) / 2)
    _uiNpcName:SetPosX(_uiNpcTitle:GetPosX() + _uiNpcTitle:GetTextSizeX() + 16)
  end
  _mainDialog = {}
  local stringList = string.split(mainDialog, "\n")
  local i = 0
  local strFirst, strSecond
  while true do
    strFirst = stringList[i * 2 + 1]
    strSecond = stringList[i * 2 + 2]
    if strFirst ~= nil and strSecond ~= nil then
      _mainDialog[i] = strFirst .. "\n" .. strSecond
    elseif strFirst == nil then
      break
    elseif strSecond == nil then
      _mainDialog[i] = strFirst
      break
    end
    i = i + 1
  end
  _maxLine = #_mainDialog
  local questData = questList_getQuestInfo(dialogData:getQuestRaw())
  local baseCount = dialogData:getBaseRewardCount()
  local _baseReward = {}
  for idx = 1, baseCount do
    local baseReward = dialogData:getBaseRewardAt(idx - 1)
    _baseReward[idx] = {}
    _baseReward[idx]._type = baseReward._type
    if __eRewardExp == baseReward._type then
      _baseReward[idx]._exp = baseReward._experience
    elseif __eRewardSkillExp == baseReward._type then
      _baseReward[idx]._exp = baseReward._skillExperience
    elseif __eRewardLifeExp == baseReward._type then
      _baseReward[idx]._exp = baseReward._productExperience
    elseif __eRewardItem == baseReward._type then
      _baseReward[idx]._item = baseReward:getItemEnchantKey()
      _baseReward[idx]._count = baseReward._itemCount
    elseif __eRewardIntimacy == baseReward._type then
      _baseReward[idx]._character = baseReward:getIntimacyCharacter()
      _baseReward[idx]._value = baseReward._intimacyValue
    elseif __eRewardKnowledge == baseReward._type then
      _baseReward[idx]._mentalCard = baseReward:getMentalCardKey()
    end
  end
  local selectCount = dialogData:getSelectRewardCount()
  local _selectReward = {}
  for idx = 1, selectCount do
    local selectReward = dialogData:getSelectRewardAt(idx - 1)
    _selectReward[idx] = {}
    _selectReward[idx]._type = selectReward._type
    if __eRewardExp == selectReward._type then
      _selectReward[idx]._exp = selectReward._experience
    elseif __eRewardSkillExp == selectReward._type then
      _selectReward[idx]._exp = selectReward._skillExperience
    elseif __eRewardLifeExp == selectReward._type then
      _selectReward[idx]._exp = selectReward._productExperience
    elseif __eRewardItem == selectReward._type then
      _selectReward[idx]._item = selectReward:getItemEnchantKey()
      _selectReward[idx]._count = selectReward._itemCount
      local selfPlayer = getSelfPlayer()
      if nil ~= selfPlayer then
        local classType = selfPlayer:getClassType()
        _selectReward[idx]._isEquipable = selectReward:isEquipable(classType)
      end
    elseif __eRewardIntimacy == selectReward._type then
      _selectReward[idx]._character = selectReward:getIntimacyCharacter()
      _selectReward[idx]._value = selectReward._intimacyValue
    elseif __eRewardKnowledge == selectReward._type then
      _selectReward[idx]._mentalCard = selectReward:getMentalCardKey()
    end
  end
  FGlobal_SetRewardList(_baseReward, _selectReward, questData)
  isFirstShowTooltip = true
  Dialog_updateMainDialog()
  Dialog_intimacyValueUpdate()
  Dialog_PageButton_Init()
  Panel_Npc_Dialog:SetShow(true, true)
  Panel_MovieTheater_LowLevel_WindowClose()
  ExecuteAfterDialogLoad()
  FGlobal_Dialog_HideTutorialStartButtonList()
  if true == FGlobal_Dialog_CheckConditionTutorialMenuButton() then
    FGlobal_Dialog_ShowTutorialMenuButton()
  else
    FGlobal_Dialog_HideTutorialMenuButton()
  end
  PaGlobal_TutorialManager:handleShowDialog(dialogData)
  _uiNpcDialog:SetShow(not _uiFilterRadioButton[0]:GetShow())
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_DIALOG")
  Panel_Npc_Dialog:ComputePos()
end
function HandleClickedDialogNextButton()
  _currentLine = _currentLine + 1
  Dialog_updateMainDialog()
end
local hasMentalCardText = PAGetString(Defines.StringSheet_GAME, "LUA_INTIMACY_INFORMATION_HASMENTALCARD")
local hasntMentalCardText = PAGetString(Defines.StringSheet_GAME, "LUA_INTIMACY_INFORMATION_HASNTMENTALCARD")
local intimacyValueBuffer = {}
function Dialog_intimacyValueUpdate()
  local dialogData = ToClient_GetCurrentDialogData()
  local groupIndex = 1
  if nil ~= dialogData then
    local dialogButtonCount = dialogData:getDialogButtonCount()
    if dialogButtonCount > 0 then
      groupIndex = 2
    end
  end
  intimacyValueBuffer = {}
  local index = 0
  local talker = dialog_getTalker()
  if nil ~= talker then
    local characterKey = talker:getCharacterKey()
    local npcData = getNpcInfoByCharacterKeyRaw(characterKey, talker:get():getDialogIndex())
    if nil ~= npcData and true == npcData:hasSpawnType(CppEnums.SpawnType.eSpawnType_intimacy) then
      local intimacy = getIntimacyByCharacterKey(characterKey)
      _txt_intimacy:SetShow(true)
      _intimacyFruitageValue:SetShow(true)
      _intimacyFruitageValue:SetText(tostring(intimacy))
      local valuePercent = intimacy / 1000 * 100
      if valuePercent > 100 then
        valuePercent = 100
      end
      _intimacyCircularProgress:SetShow(true)
      _intimacyCircularProgress:SetProgressRate(valuePercent)
      _intimacyCircularProgress:addInputEvent("Mouse_On", "FruitageValue_ShowTooltip(true)")
      _intimacyCircularProgress:addInputEvent("Mouse_Out", "FruitageValue_ShowTooltip(false)")
      if true == _ContentsGroup_GrowStep then
        _intimacyProgressBG:SetShow(ToClient_IsGrowStepOpen(__eGrowStep_relationNPC))
      else
        _intimacyProgressBG:SetShow(true)
      end
      local count = getIntimacyInformationCount(characterKey)
      local colorKey = float4(1, 1, 1, 1)
      local startSize = 28
      local endSize = (_intimacyProgressBG:GetSizeX() + _intimacyGiftIcon:GetSizeX()) / 2
      local centerPosition = float3(_intimacyProgressBG:GetPosX() + _intimacyProgressBG:GetSizeX() / 2, _intimacyProgressBG:GetPosY() + _intimacyProgressBG:GetSizeY() / 2, 0)
      for index, value in pairs(giftIcon) do
        UI.deleteControl(value)
      end
      giftIcon = {}
      for index = 0, count - 1 do
        local intimacyInformationData = getIntimacyInformation(characterKey, index)
        if nil ~= intimacyInformationData then
          local percent = intimacyInformationData:getIntimacy() / 1000
          local imageType = intimacyInformationData:getTypeIndex()
          local giftName = intimacyInformationData:getTypeName()
          local giftDesc = intimacyInformationData:getTypeDescription()
          local giftMentalCardWrapper = ToClinet_getMentalCardStaticStatus(intimacyInformationData:getMentalCardKeyRaw())
          if nil ~= giftMentalCardWrapper then
            if giftMentalCardWrapper:isHasCard() then
              giftDesc = giftDesc .. hasMentalCardText
            else
              giftDesc = giftDesc .. hasntMentalCardText
            end
          end
          local giftOperator = intimacyInformationData:getOperatorType()
          local imageFileName = ""
          if percent >= 0 and percent <= 1 and ToClient_checkIntimacyInformationFixedState(intimacyInformationData) then
            local angle = math.pi * 2 * percent
            local lineStart = float3(math.sin(angle), -math.cos(angle), 0)
            local lineEnd = float3(math.sin(angle), -math.cos(angle), 0)
            lineStart = _math_AddVectorToVector(centerPosition, _math_MulNumberToVector(lineStart, startSize))
            lineEnd = _math_AddVectorToVector(centerPosition, _math_MulNumberToVector(lineEnd, endSize))
            local target = giftIcon[index]
            if nil == target then
              target = UI.createControl(UCT.PA_UI_CONTROL_STATIC, Panel_Npc_Dialog, "GiftIcon_" .. tostring(index))
              giftIcon[index] = target
              CopyBaseProperty(_intimacyGiftIcon, target)
            end
            if true == _ContentsGroup_GrowStep then
              target:SetShow(ToClient_IsGrowStepOpen(__eGrowStep_relationNPC))
            else
              target:SetShow(true)
            end
            target:ChangeTextureInfoNameAsync(uv[imageType]._fileName)
            local x1, y1, x2, y2 = setTextureUV_Func(target, uv[imageType].x1, uv[imageType].y1, uv[imageType].x2, uv[imageType].y2)
            target:getBaseTexture():setUV(x1, y1, x2, y2)
            target:setRenderTexture(target:getBaseTexture())
            target:SetPosX(lineEnd.x - target:GetSizeX() / 2)
            target:SetPosY(lineEnd.y - target:GetSizeY() / 2)
            local targetPosX = target:GetPosX()
            local targetPosY = target:GetPosY()
            intimacyValueBuffer[index] = {
              giftName = giftName,
              giftDesc = giftDesc,
              giftPercent = percent,
              giftOperator = giftOperator
            }
            target:addInputEvent("Mouse_On", "FruitageItem_ShowTooltip(" .. percent .. ")")
            target:addInputEvent("Mouse_Out", "FruitageItem_HideTooltip()")
          end
        end
      end
      return
    end
  end
  _txt_intimacy:SetShow(false)
  _intimacyFruitageValue:SetShow(false)
  _intimacyCircularProgress:SetShow(false)
  _intimacyProgressBG:SetShow(false)
  for index, value in pairs(giftIcon) do
    value:SetShow(false)
  end
end
function FromClient_VaryIntimacy_Dialog()
  if Defines.UIMode.eUIMode_NpcDialog == GetUIMode() then
    Dialog_intimacyValueUpdate()
  end
end
function Dialog_PageButton_Init()
  _prevPageButton:SetIgnore(true)
  _nextPageButton:SetIgnore(false)
  _dialogIndex = 0
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local dialogButtonCount = dialogData:getDialogButtonCount()
  local pageCount = (dialogButtonCount - 1) / 4 - (dialogButtonCount - 1) / 4 % 1
  _pageValue:SetText("1/" .. pageCount + 1)
end
Dialog_PageButton_Init()
function HandleClicked_Next_Dialog(_startIndex)
  Page_Setting(_startIndex)
  Dialog_updateButtons(true)
  Auto_NotifyChangeDialog()
end
function Page_Setting(_startIndex)
  local dialogData = ToClient_GetCurrentDialogData()
  local dialogButtonCount = dialogData:getDialogButtonCount()
  local pageCount = (dialogButtonCount - 1) / 4 - (dialogButtonCount - 1) / 4 % 1
  if _startIndex < 0 or _startIndex >= dialogButtonCount then
    return
  end
  _dialogIndex = _startIndex
  if 0 == _startIndex then
    _prevPageButton:SetIgnore(true)
    _nextPageButton:SetIgnore(false)
    _pageValue:SetText(_startIndex / 4 + 1 .. "/" .. pageCount + 1)
  elseif _startIndex / 4 == pageCount then
    _prevPageButton:SetIgnore(false)
    _nextPageButton:SetIgnore(true)
    _pageValue:SetText(_startIndex / 4 + 1 .. "/" .. pageCount + 1)
  else
    _prevPageButton:SetIgnore(false)
    _nextPageButton:SetIgnore(false)
    _pageValue:SetText(_startIndex / 4 + 1 .. "/" .. pageCount + 1)
  end
end
local promiseTokenKey = 44192
function Dialog_updateButtons(isVisible)
  local sizeX = getScreenSizeX()
  local sizeY = getScreenSizeY()
  local pos, displayData
  local linkType = 0
  local Wp = 0
  local playerLevel = 0
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer then
    Wp = selfPlayer:getWp()
    playerLevel = selfPlayer:get():getLevel()
  end
  local isBlackStone_16001 = Panel_Inventory_isBlackStone_16001
  local isBlackStone_16002 = Panel_Inventory_isBlackStone_16002
  local value_IsSocket = Panel_Inventory_isSocketItem
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local dialogButtonCount = dialogData:getDialogButtonCount()
  isReContactDialog = false
  isDialogFunctionQuest = false
  local isExchangalbeButtonCheck = false
  _questDialogButtonIndex = -1
  _exchangalbeButtonIndex = -1
  for i = 0, 3 do
    _uiDialogButton[i]:SetShow(false)
    _uiDialogButton[i]:EraseAllEffect()
    _uiNoticeNeedInfo[i]:SetShow(false)
    _uiNeedWpAni[i]:SetShow(false)
    _uiIntimacyIcon[i]:SetShow(false)
    _uiCutSceneDesc[i]:SetShow(false)
  end
  if dialogButtonCount > 4 and true == isVisible then
    _prevPageButton:SetShow(true)
    _nextPageButton:SetShow(true)
    _scrollControl:SetShow(true)
    _scrollControl:SetIgnore(false)
    _pageValue:SetShow(true)
    _prevPageButton:SetAutoDisableTime(0.2)
    _nextPageButton:SetAutoDisableTime(0.2)
    _prevPageButton:addInputEvent("Mouse_LUp", "HandleClicked_Next_Dialog(" .. _dialogIndex - 4 .. ")")
    _nextPageButton:addInputEvent("Mouse_LUp", "HandleClicked_Next_Dialog(" .. _dialogIndex + 4 .. ")")
    for dialogBTScrollIndex = 0, 3 do
      _uiDialogButton[dialogBTScrollIndex]:addInputEvent("Mouse_UpScroll", "HandleClicked_Next_Dialog(" .. _dialogIndex - 4 .. ")")
      _uiDialogButton[dialogBTScrollIndex]:addInputEvent("Mouse_DownScroll", "HandleClicked_Next_Dialog(" .. _dialogIndex + 4 .. ")")
    end
    _scrollControl:addInputEvent("Mouse_UpScroll", "HandleClicked_Next_Dialog(" .. _dialogIndex - 4 .. ")")
    _scrollControl:addInputEvent("Mouse_DownScroll", "HandleClicked_Next_Dialog(" .. _dialogIndex + 4 .. ")")
    _prevPageButton:addInputEvent("Mouse_UpScroll", "HandleClicked_Next_Dialog(" .. _dialogIndex - 4 .. ")")
    _prevPageButton:addInputEvent("Mouse_DownScroll", "HandleClicked_Next_Dialog(" .. _dialogIndex + 4 .. ")")
    _nextPageButton:addInputEvent("Mouse_UpScroll", "HandleClicked_Next_Dialog(" .. _dialogIndex - 4 .. ")")
    _nextPageButton:addInputEvent("Mouse_DownScroll", "HandleClicked_Next_Dialog(" .. _dialogIndex + 4 .. ")")
  else
    _prevPageButton:SetShow(false)
    _nextPageButton:SetShow(false)
    _scrollControl:SetShow(false)
    _scrollControl:SetIgnore(true)
    _pageValue:SetShow(false)
  end
  local _dialogCount = 0
  local _firstDisplayQuest = false
  local _btnPositionType = 0
  local _questDialogButtonPosY = 0
  local _exchangalbeButtonPosY = 0
  local _rBtnPlusPosX = 0
  local _dialogBtnSizeX = defaultDialogBtnSizeX
  local maxsize = 500
  if isGameTypeEnglish() or isGameTypeSA() or isGameTypeTH() or isGameTypeID() or isGameTypeTR() or isGameTypeRussia() then
    maxsize = 500
  else
    maxsize = 395
  end
  for i = _dialogIndex, dialogButtonCount - 1 do
    local dialogButton
    local needThings = ""
    if not isVisible or _dialogCount > 3 then
      break
    end
    dialogButton = dialogData:getDialogButtonAt(i)
    _uiDialogButton[_dialogCount]:SetText(dialogButton:getText())
    maxsize = math.max(_uiDialogButton[_dialogCount]:GetTextSizeX() + 80, maxsize)
    dialogButtonMaxSize = maxsize
  end
  if maxsize > 1000 then
    maxsize = 900
  end
  for i = _dialogIndex, dialogButtonCount - 1 do
    local dialogButton
    local needThings = ""
    local isNeedThings = false
    local itemStaticWrapper
    isExchangeButtonIndex[i] = false
    isPromiseToken[i] = false
    if not isVisible or _dialogCount > 3 then
      break
    end
    pos = _uiDialogButton[_dialogCount]:GetSpanSize()
    displayData = Dialog_getButtonDisplayData(i)
    dialogButton = dialogData:getDialogButtonAt(i)
    _uiDialogButton[_dialogCount]:SetSize(maxsize, _uiDialogButton[_dialogCount]:GetSizeY())
    _uiDialogButton[_dialogCount]:SetText(dialogButton:getText())
    if _dialogBtnSizeX < _uiDialogButton[_dialogCount]:GetTextSizeX() + 80 then
      _dialogBtnSizeX = _uiDialogButton[_dialogCount]:GetTextSizeX() + 80
    end
    if displayData:empty() then
      _uiDialogButton[_dialogCount]:SetEnable(dialogButton._enable)
      if dialogButton._enable then
        if false == dialogButton._invenPushable then
          _uiDialogButton[_dialogCount]:SetEnable(dialogButton._invenPushable)
          _uiDialogButton[_dialogCount]:SetMonoTone(true)
          _uiDialogButton[_dialogCount]:SetFontColor(UI_color.C_FF515151)
          _uiNoticeNeedInfo[_dialogCount]:SetFontColor(UI_color.C_FFF26A6A)
        else
          _uiDialogButton[_dialogCount]:SetMonoTone(false)
          _uiDialogButton[_dialogCount]:SetFontColor(UI_color.C_FFDFDFDF)
          _uiNoticeNeedInfo[_dialogCount]:SetFontColor(UI_color.C_FFDFDFDF)
        end
      else
        _uiDialogButton[_dialogCount]:SetMonoTone(true)
        _uiDialogButton[_dialogCount]:SetFontColor(UI_color.C_FF515151)
        _uiNoticeNeedInfo[_dialogCount]:SetFontColor(UI_color.C_FFF26A6A)
      end
      linkType = dialogButton._linkType
      _uiNoticeNeedInfo[_dialogCount]:SetShow(false)
      _uiNeedWpAni[_dialogCount]:SetShow(false)
      if UI_DS.eDialogState_ReContact == tostring(linkType) then
        isReContactDialog = true
        _btnPositionType = 2
      elseif UI_DS.eDialogState_QuestComplete == tostring(linkType) or UI_DS.eDialogState_AcceptQuest == tostring(linkType) then
        isReContactDialog = true
        _btnPositionType = 2
      end
      if UI_DS.eDialogState_RefuseQuest == tostring(linkType) then
        _uiDialogButton[_dialogCount]:addInputEvent("Mouse_LUp", "HandleClickedBackButton()")
      else
        _uiDialogButton[_dialogCount]:addInputEvent("Mouse_LUp", "HandleClickedDialogButton(" .. _dialogCount .. ")")
      end
      if UI_DS.eDialogState_QuestComplete == tostring(linkType) then
        _isQuestComplete = true
      else
        _isQuestComplete = false
      end
      if UI_DS.eDialogState_DisplayQuest == tostring(linkType) and false == _firstDisplayQuest then
        _firstDisplayQuest = true
        _btnPositionType = 4
        _questDialogButtonIndex = _dialogCount
        _questDialogButtonPosY = _uiDialogButton[_questDialogButtonIndex]:GetPosY()
      end
      local needWp = dialogButton:getNeedWp()
      if UI_DS.eDialogState_Talk == tostring(linkType) and needWp > 0 then
        needThings = needThings .. PAGetStringParam1(Defines.StringSheet_GAME, "DIALOG_NEED_WP", "wp", needWp) .. " (" .. PAGetString(Defines.StringSheet_GAME, "DIALOG_WP_GOT") .. "" .. Wp .. ") "
        isNeedThings = true
        if 0 < dialogButton:getNeedItemCount() then
          itemStaticWrapper = getItemEnchantStaticStatus(ItemEnchantKey(dialogButton:getNeedItemKey()))
          if itemStaticWrapper ~= nil then
            needThings = needThings .. itemStaticWrapper:getName() .. " " .. PAGetStringParam1(Defines.StringSheet_GAME, "DIALOG_NEEDCOUNT", "item_count", tostring(dialogButton:getNeedItemCount()))
          end
          _uiNeedWpAni[_dialogCount]:SetShow(false)
        else
          _uiNeedWpAni[_dialogCount]:SetShow(false)
        end
      elseif 0 < dialogButton:getNeedItemCount() then
        itemStaticWrapper = getItemEnchantStaticStatus(ItemEnchantKey(dialogButton:getNeedItemKey()))
        if itemStaticWrapper ~= nil then
          needThings = needThings .. itemStaticWrapper:getName() .. " " .. PAGetStringParam1(Defines.StringSheet_GAME, "DIALOG_NEEDCOUNT", "item_count", tostring(dialogButton:getNeedItemCount()))
          isNeedThings = true
          isExchangeButtonIndex[_dialogCount + _dialogIndex] = true
          if dialogButton:getNeedItemKey() == promiseTokenKey then
            isPromiseToken[_dialogCount + _dialogIndex] = true
          end
        end
        _uiNeedWpAni[_dialogCount]:SetShow(false)
      else
        _uiNeedWpAni[_dialogCount]:SetShow(false)
      end
      if isNeedThings then
        if dialogButton._invenPushable then
          _uiNoticeNeedInfo[_dialogCount]:SetText(needThings)
        else
          _uiNoticeNeedInfo[_dialogCount]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PLAYER_INVENTORY_FULL"))
        end
        _uiNoticeNeedInfo[_dialogCount]:SetSize(_uiNoticeNeedInfo[_dialogCount]:GetTextSizeX() + 10, 23)
        _uiNoticeNeedInfo[_dialogCount]:SetAutoResize(true)
        _uiNoticeNeedInfo[_dialogCount]:SetShow(true)
        if dialogButton._enable and false == isExchangalbeButtonCheck and UI_BTN_TYPE.eDialogButton_CutScene ~= dialogButton._dialogButtonType and UI_BTN_TYPE.eDialogButton_ExceptExchange ~= dialogButton._dialogButtonType and UI_BTN_TYPE.eDialogButton_Exchange ~= dialogButton._dialogButtonType then
          _exchangalbeButtonPosY = _uiDialogButton[_dialogCount]:GetPosY()
          _rBtnPlusPosX = _uiNoticeNeedInfo[_dialogCount]:GetSizeX()
          isExchangalbeButtonCheck = true
          _btnPositionType = 5
          _exchangalbeButtonIndex = _dialogCount
        end
      elseif UI_BTN_TYPE.eDialogButton_Knowledge == dialogButton._dialogButtonType and UI_DS.eDialogState_ProgressQuest ~= tostring(linkType) and not isExchangalbeButtonCheck then
        _exchangalbeButtonPosY = _uiDialogButton[_dialogCount]:GetPosY()
        _rBtnPlusPosX = 0
        isExchangalbeButtonCheck = true
        _btnPositionType = 5
        _exchangalbeButtonIndex = _dialogCount
      end
    else
      _uiDialogButton[_dialogCount]:SetMonoTone(false)
      _uiDialogButton[_dialogCount]:SetFontColor(UI_color.C_FFDFDFDF)
      _uiNoticeNeedInfo[_dialogCount]:SetShow(false)
      _uiNeedWpAni[_dialogCount]:SetShow(false)
    end
    _uiDialogButton[_dialogCount]:SetShow(true)
    if UI_DS.eDialogState_Talk == tostring(linkType) then
      if 0 < dialogButton._dialogButtonType and dialogButton._dialogButtonType < CppEnums.DialogButtonType.eDialogButton_Count then
        FGlobal_ChangeOnTextureForDialogIcon(_uiDialogIcon[_dialogCount], dialogButton._dialogButtonType)
        _uiDialogIcon[_dialogCount]:SetShow(true)
        if true == questList_hasProgressQuest(21117, 2) then
          _uiDialogButton[_dialogCount]:AddEffect("fUI_Tuto_Button_Arrow_01A", true, _uiDialogButton[_dialogCount]:GetSizeX() / 2 + 25, 0)
        end
      else
        _uiDialogIcon[_dialogCount]:SetShow(false)
      end
    elseif UI_DS.eDialogState_QuestList == tostring(linkType) or UI_DS.eDialogState_DisplayQuest == tostring(linkType) or UI_DS.eDialogState_ProgressQuest == tostring(linkType) then
      if 0 <= dialogButton._dialogButtonType and dialogButton._dialogButtonType < CppEnums.DialogQuestButtonType.eDialogButton_QuestCount then
        FGlobal_ChangeOnTextureForDialogQuestIcon(_uiDialogIcon[_dialogCount], dialogButton._dialogButtonType)
        _uiDialogIcon[_dialogCount]:SetShow(true)
      else
        _uiDialogIcon[_dialogCount]:SetShow(false)
      end
    else
      _uiDialogIcon[_dialogCount]:SetShow(false)
    end
    if UI_BTN_TYPE.eDialogButton_CutScene == dialogButton._dialogButtonType and UI_DS.eDialogState_Talk == tostring(linkType) and false == isNeedThings then
      _uiCutSceneDesc[_dialogCount]:SetShow(true)
      _uiCutSceneDesc[_dialogCount]:SetSize(_uiCutSceneDesc[_dialogCount]:GetTextSizeX() + 10, _uiCutSceneDesc[_dialogCount]:GetSizeY())
    else
      _uiCutSceneDesc[_dialogCount]:SetShow(false)
    end
    _uiIntimacyIcon[_dialogCount]:SetShow(false)
    local talker = dialog_getTalker()
    if nil ~= talker then
      local characterKey = talker:getCharacterKey()
      local count = getIntimacyInformationCount(characterKey)
      local intimacyValue = talker:getIntimacy()
      for indexIntimacy = 0, count - 1 do
        local intimacyInformationData = getIntimacyInformation(characterKey, indexIntimacy)
        local giftDesc = intimacyInformationData:getTypeDescription()
        local intimacyType = intimacyInformationData:getTypeName()
        local giftMentalCardWrapper = ToClinet_getMentalCardStaticStatus(intimacyInformationData:getMentalCardKeyRaw())
        if nil ~= giftMentalCardWrapper then
          if giftMentalCardWrapper:isHasCard() then
            giftDesc = giftDesc .. hasMentalCardText
          else
            giftDesc = giftDesc .. hasntMentalCardText
          end
        end
        if giftDesc == dialogButton:getText() and intimacyValue > 1 then
          if intimacyType == PAGetString(Defines.StringSheet_GAME, "INTIMACYINFORMATION_TYPE_QUEST") then
            _uiIntimacyIcon[_dialogCount]:SetPosX(_uiDialogButton[_dialogCount]:GetPosX() + _uiIntimacyIcon[_dialogCount]:GetSizeX() - 8)
            _uiIntimacyIcon[_dialogCount]:SetPosY(_uiDialogButton[_dialogCount]:GetPosY() + 1)
          else
            _uiIntimacyIcon[_dialogCount]:SetPosX(_uiDialogButton[_dialogCount]:GetPosX() + 3)
            _uiIntimacyIcon[_dialogCount]:SetPosY(_uiDialogButton[_dialogCount]:GetPosY() + 1)
          end
          if 0 < dialogButton._dialogButtonType then
            _uiIntimacyIcon[_dialogCount]:SetShow(false)
          else
            _uiIntimacyIcon[_dialogCount]:SetShow(true)
          end
        end
      end
    end
    _dialogCount = _dialogCount + 1
  end
  for i = 0, 3 do
    if 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
      _uiNeedWpAni[i]:SetPosX(getScreenSizeX() / 2 + _uiDialogButton[i]:GetSizeX() / 2 - _uiNeedWpAni[i]:GetSizeX() - 5)
      _uiNeedWpAni[i]:SetPosY(_uiDialogButton[i]:GetPosY())
    else
      _uiNeedWpAni[i]:SetPosY(_uiDialogButton[i]:GetPosY())
    end
    _uiDialogButton[i]:ComputePos()
    _uiNoticeNeedInfo[i]:SetPosX(_uiDialogButton[i]:GetPosX() + _uiDialogButton[i]:GetSizeX() + 10)
    _uiCutSceneDesc[i]:SetPosX(_uiDialogButton[i]:GetPosX() + _uiDialogButton[i]:GetSizeX() + 10)
    _uiCutSceneDesc[i]:SetPosY(_uiDialogButton[i]:GetPosY() + 2)
  end
  dialogButtonMaxSize = math.max(dialogButtonMaxSize, maxsize)
  _uiNextButton:SetSize(dialogButtonMaxSize, 28)
  _uiNextButton:ComputePos()
  _uiNextButton:SetPosY(_rBtnPosY)
  _SpacebarIcon:SetSize(40, 28)
  _SpacebarIcon:SetPosX(_uiDialogButton[0]:GetPosX() + _uiDialogButton[0]:GetSizeX() - _SpacebarIcon:GetSizeX() - 5)
  _SpacebarIcon:SetPosY(_rBtnPosY + 1)
  _prevPageButton:SetPosX(_uiDialogButton[0]:GetPosX() - _prevPageButton:GetSizeX() * 2)
  _nextPageButton:SetPosX(_prevPageButton:GetPosX())
  _pageValue:SetPosX(_prevPageButton:GetPosX())
  _rBtnPosX = _uiDialogButton[0]:GetPosX() + _uiDialogButton[0]:GetSizeX() - _SpacebarIcon:GetSizeX() - 5
  local totalQuestCount = 0
  local progressQuestCount = questList_getCheckedProgressQuestCount()
  local groupNo, questNo, progressQuest
  local groupCount = 0
  for questIndex = 1, progressQuestCount do
    progressQuest = questList_getCheckedProgressQuestAt(questIndex - 1)
    if nil == progressQuest then
      return
    end
    totalQuestCount = totalQuestCount + 1
    groupCount = progressQuest:getQuestGroupQuestCount()
    if groupCount > 0 and groupCount >= progressQuest:getQuestGroupQuestNo() then
      groupNo = progressQuest:getQuestGroup()
      questNo = progressQuest:getQuestGroupQuestNo()
    end
  end
  local funcButtonCount = dialogData:getFuncButtonCount()
  local buttonSize = _uiFuncButton[0]:GetSizeX()
  local buttonGap = 10
  local startPosX = (sizeX - (buttonSize * funcButtonCount + buttonGap * (funcButtonCount - 1))) / 2
  local funcButton
  local intimacyGame_Alert = UI.getChildControl(Panel_Npc_Dialog, "Static_BubbleBox")
  local intimacyGame_Alert_Txt = UI.getChildControl(Panel_Npc_Dialog, "StaticText_BubbleBox")
  intimacyGame_Alert:SetShow(false)
  intimacyGame_Alert_Txt:SetShow(false)
  local investNode_Alert = UI.getChildControl(Panel_Npc_Dialog, "Static_BubbleBox2")
  local investNode_Alert_Txt = UI.getChildControl(Panel_Npc_Dialog, "StaticText_BubbleBox2")
  investNode_Alert:SetShow(false)
  investNode_Alert_Txt:SetShow(false)
  tradeIndex = -1
  warehouseIndex = -1
  for index = 0, 5 do
    local posX = startPosX + (buttonSize + buttonGap) * index
    _uiFuncButton[index]:EraseAllEffect()
    _uiFuncButton[index]:addInputEvent("Mouse_On", "")
    _uiFuncButton[index]:addInputEvent("Mouse_Out", "")
    _uiFuncBG[index]:ResetVertexAni()
    _uiFuncBG[index]:SetShow(false)
    nextQuestFunctionBtnClick[index] = false
    if index < funcButtonCount then
      funcButton = dialogData:getFuncButtonAt(index)
      _uiFuncButton[index]:SetIgnore(false)
      _uiFuncButton[index]:SetFontColor(4291083966)
      _uiFuncButton[index]:ResetVertexAni()
      _uiFuncButton[index]:SetAlpha(1)
      _uiFuncButton[index]:SetPosX(posX)
      _uiFuncButton[index]:SetMonoTone(false)
      local funcButtonType = tonumber(funcButton._param)
      Dialog_InterestKnowledgeUpdate()
      local displayExchangeWrapper = dialogData:getCurrentDisplayExchangeWrapper()
      if nil ~= displayExchangeWrapper then
        FGlobal_Exchange_Item()
      end
      _uiFuncButton[index]:addInputEvent("Mouse_On", "Dialog_MouseToolTips(true, " .. funcButtonType .. "," .. index .. ")")
      _uiFuncButton[index]:addInputEvent("Mouse_Out", "Dialog_MouseToolTips(false, " .. funcButtonType .. "," .. index .. ")")
      local tempIconSizeX = 23
      if funcButtonType == CppEnums.ContentsType.Contents_IntimacyGame then
        _uiFuncButton[index]:SetText(funcButton:getText() .. " (" .. funcButton:getNeedWp() .. "/" .. Wp .. ")")
        _uiFuncButton[index]:SetEnable(funcButton._enable)
      elseif funcButtonType == CppEnums.ContentsType.Contents_NewQuest then
        _uiFuncButton[index]:SetText(funcButton:getText())
        _uiFuncButton[index]:SetEnable(true)
      else
        _uiFuncButton[index]:SetEnable(true)
        _uiFuncButton[index]:SetText(funcButton:getText())
        local btnTextSizeX = _uiFuncButton[index]:GetSizeX() + tempIconSizeX
        local btnTextPosX = btnTextSizeX - btnTextSizeX / 2 - _uiFuncButton[index]:GetTextSizeX() / 2
      end
      _uiFuncButton[index]:SetShow(true)
      if funcButtonType == CppEnums.ContentsType.Contents_Quest then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_NewQuest then
        _uiFuncBG[index]:SetPosX(_uiFuncButton[index]:GetPosX() - 6)
        _uiFuncBG[index]:SetPosY(_uiFuncButton[index]:GetPosY() - 5)
        audioPostEvent_SystemUi(4, 4)
        _uiFuncBG[index]:SetShow(true)
        _uiFuncBG[index]:SetVertexAniRun("Ani_Color_1", true)
        _uiFuncButton[index]:SetFontColor(4289626129)
        _uiFuncButton[index]:SetVertexAniRun("Ani_Color_Bright", true)
        _uiFuncButton[index]:SetMonoTone(false)
        isDialogFunctionQuest = true
        _btnPositionType = 3
        if true == handleClickedQuestComplete then
          nextQuestFunctionBtnClick[index] = true
        end
      elseif funcButtonType == CppEnums.ContentsType.Contents_Shop then
        if funcButton:getText() == PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_EXCHANGEMONEY") then
        else
        end
        _uiFuncButton[index]:SetMonoTone(false)
        if isNormalTradeMerchant() then
          FGlobal_RemoteControl_Show(5)
          tradeIndex = index
        end
      elseif funcButtonType == CppEnums.ContentsType.Contents_Skill then
        local skillCount = FGlobal_EnableSkillReturn()
        _uiFuncButton[index]:ResetAndClearVertexAni()
        if skillCount > 0 then
          _uiFuncButton[index]:SetFontColor(4289626129)
          _uiFuncButton[index]:SetVertexAniRun("Ani_Color_Bright", true)
        else
          _uiFuncButton[index]:SetFontColor(Defines.Color.C_FFC4BEBE)
        end
        _uiFuncButton[index]:SetIgnore(false)
        _uiFuncButton[index]:SetText(PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_SKILL"))
        _uiFuncButton[index]:SetMonoTone(false)
        if groupNo == 1067 and questNo == 4 then
          _uiFuncButton[index]:EraseAllEffect()
          _uiFuncButton[index]:AddEffect("UI_ArrowMark02", true, 0, -_uiFuncButton[index]:GetSizeY() * 1.7)
        elseif groupNo == 1600 and questNo == 4 then
          _uiFuncButton[index]:EraseAllEffect()
          _uiFuncButton[index]:AddEffect("UI_ArrowMark02", true, 0, -_uiFuncButton[index]:GetSizeY() * 1.7)
        elseif groupNo == 1070 and questNo == 4 then
          _uiFuncButton[index]:EraseAllEffect()
          _uiFuncButton[index]:AddEffect("UI_ArrowMark02", true, 0, -_uiFuncButton[index]:GetSizeY() * 1.7)
        elseif groupNo == 1071 and questNo == 4 then
          _uiFuncButton[index]:EraseAllEffect()
          _uiFuncButton[index]:AddEffect("UI_ArrowMark02", true, 0, -_uiFuncButton[index]:GetSizeY() * 1.7)
        else
          _uiFuncButton[index]:EraseAllEffect()
        end
      elseif funcButtonType == CppEnums.ContentsType.Contents_Repair then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_Auction then
        _uiFuncButton[index]:SetMonoTone(false)
        isAuctionDialog = true
      elseif funcButtonType == CppEnums.ContentsType.Contents_Inn then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_Warehouse then
        _uiFuncButton[index]:SetMonoTone(false)
        if not Panel_Window_Warehouse:GetShow() then
          FGlobal_RemoteControl_Show(6)
          warehouseIndex = index
        end
      elseif funcButtonType == CppEnums.ContentsType.Contents_IntimacyGame then
        if true == funcButton._enable then
          _uiFuncButton[index]:SetMonoTone(false)
          intimacyGame_Alert:SetShow(false)
          intimacyGame_Alert_Txt:SetShow(false)
        else
          _uiFuncButton[index]:SetMonoTone(true)
          local talker = dialog_getTalker()
          local ActorKeyRaw = talker:getActorKey()
          local npcActorProxyWrapper = getNpcActor(ActorKeyRaw)
          local needCount = npcActorProxyWrapper:getNeedCount()
          local currCount = getKnowledgeCountMatchTheme(npcActorProxyWrapper:getNpcThemeKey())
          local text = PAGetStringParam3(Defines.StringSheet_GAME, "HUMANRELATION_TEXT", "getNpcTheme", npcActorProxyWrapper:getNpcTheme(), "currCount", tostring(currCount), "needCount", tostring(needCount))
          intimacyGame_Alert:SetShow(true)
          intimacyGame_Alert_Txt:SetShow(true)
          intimacyGame_Alert:SetPosX(_uiFuncButton[index]:GetPosX() - 24)
          intimacyGame_Alert:SetPosY(_uiFuncButton[index]:GetPosY() - 60)
          intimacyGame_Alert_Txt:SetPosX(intimacyGame_Alert:GetPosX() - 5)
          intimacyGame_Alert_Txt:SetPosY(intimacyGame_Alert:GetPosY())
          intimacyGame_Alert_Txt:SetAutoResize(true)
          intimacyGame_Alert_Txt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HUMANRELATION_ALERT_TEXT", "txt", text))
          intimacyGame_Alert_Txt:SetSize(intimacyGame_Alert_Txt:GetTextSizeX(), intimacyGame_Alert_Txt:GetTextSizeY())
          intimacyGame_Alert:SetSize(intimacyGame_Alert_Txt:GetSizeX() + 70, intimacyGame_Alert_Txt:GetSizeY() + 34)
        end
      elseif funcButtonType == CppEnums.ContentsType.Contents_Stable then
        if false == isSiegeStable() and stable_doHaveRegisterItem() then
          _uiFuncBG[index]:SetPosX(_uiFuncButton[index]:GetPosX() - 6)
          _uiFuncBG[index]:SetPosY(_uiFuncButton[index]:GetPosY() - 5)
          _uiFuncBG[index]:SetShow(true)
          _uiFuncBG[index]:SetVertexAniRun("Ani_Color_1", true)
        else
          _uiFuncBG[index]:SetShow(false)
        end
        local NpcDialogData = ToClient_GetCurrentDialogData()
        _PA_LOG("\236\155\144\236\132\160", "test" .. tostring(NpcDialogData:isWharf()))
        if true == NpcDialogData:isWharf() then
        else
        end
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_Transfer then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_Guild then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_Explore then
        if false == dialog_getIsExplorationUseableCurrentTalker() then
          investNode_Alert:SetShow(true)
          investNode_Alert_Txt:SetShow(true)
          investNode_Alert_Txt:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_INVESTNODE_ALERT_TXT"))
          if true == intimacyGame_Alert:GetShow() then
            investNode_Alert:SetPosX(_uiFuncButton[index]:GetPosX() + _uiFuncButton[index]:GetSizeX() - 30)
          else
            investNode_Alert:SetPosX(_uiFuncButton[index]:GetPosX() - 35)
          end
          investNode_Alert:SetPosY(_uiFuncButton[index]:GetPosY() - 60)
          investNode_Alert_Txt:SetPosX(investNode_Alert:GetPosX() - 5)
          investNode_Alert_Txt:SetPosY(investNode_Alert:GetPosY())
          investNode_Alert_Txt:SetAutoResize(true)
          investNode_Alert_Txt:SetSize(investNode_Alert_Txt:GetTextSizeX(), investNode_Alert_Txt:GetTextSizeY())
          investNode_Alert:SetSize(investNode_Alert_Txt:GetSizeX() + 70, investNode_Alert_Txt:GetSizeY() + 34)
        else
          investNode_Alert:SetShow(false)
          investNode_Alert_Txt:SetShow(false)
        end
      elseif funcButtonType == CppEnums.ContentsType.Contents_DeliveryPerson then
      elseif funcButtonType == CppEnums.ContentsType.Contents_Enchant then
        local posX = _uiFuncButton[index]:GetPosX()
        local posY = _uiFuncButton[index]:GetPosY()
        if isBlackStone_16001 or isBlackStone_16002 then
          _uiFuncButton[index]:EraseAllEffect()
          _uiFuncButton[index]:AddEffect("fUI_EnchantButton_Dark", false, 0, 0)
        end
      elseif funcButtonType == CppEnums.ContentsType.Contents_Socket then
        local posX = _uiFuncButton[index]:GetPosX()
        local posY = _uiFuncButton[index]:GetPosY()
        if value_IsSocket == true then
          _uiFuncButton[index]:EraseAllEffect()
          _uiFuncButton[index]:AddEffect("fUI_EnchantButton_Jewel", false, 0, 0)
        end
      elseif funcButtonType == CppEnums.ContentsType.Contents_Awaken then
        local player = getSelfPlayer()
        if nil == player then
          return
        end
        local selfPlayLevel = player:get():getLevel()
        local reinforceableSkillCount = 0
        if selfPlayLevel < 50 then
          reinforceableSkillCount = 0
        elseif selfPlayLevel < 52 then
          reinforceableSkillCount = 1
        elseif selfPlayLevel < 54 then
          reinforceableSkillCount = 2
        elseif selfPlayLevel < 56 then
          reinforceableSkillCount = 3
        elseif selfPlayLevel < 58 then
          reinforceableSkillCount = 4
        elseif selfPlayLevel < 60 then
          reinforceableSkillCount = 5
        else
          reinforceableSkillCount = 6
        end
        local skillAwakeningCount = ToClient_GetSkillAwakeningCount()
        local weaponSkillAwakeningCount = ToClient_GetWeaponSkillAwakeningCount()
        local currentSkillAwakeningCount = skillAwakeningCount + weaponSkillAwakeningCount
        _uiFuncButton[index]:EraseAllEffect()
        if reinforceableSkillCount > currentSkillAwakeningCount then
          _uiFuncButton[index]:AddEffect("fUI_Skill_Up_01A", true, 0, 0)
          _uiFuncButton[index]:AddEffect("UI_Skill_Up_1", true, 0, 0)
        end
      elseif funcButtonType == CppEnums.ContentsType.Contents_ReAwaken then
        _uiFuncButton[index]:SetMonoTone(false)
        _uiFuncButton[index]:AddEffect("fUI_Skill_ReUp_01A", true, 0, 0)
        _uiFuncButton[index]:AddEffect("UI_Skill_ReUp_1", true, 0, 0)
      elseif funcButtonType == CppEnums.ContentsType.Contents_LordMenu then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_Extract then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_TerritoryTrade then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_TerritorySupply then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_GuildShop then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_ItemMarket then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_NewItemMarket then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_Knowledge then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_HelpDesk then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_SupplyShop then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_MinorLordMenu then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_FishSupplyShop then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_GuildSupplyShop then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_Join then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_Improve then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_WeakenEnchant then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_NpcGift then
        _uiFuncButton[index]:SetMonoTone(false)
      elseif funcButtonType == CppEnums.ContentsType.Contents_DiceGame then
        _uiFuncButton[index]:SetMonoTone(false)
      end
    else
      _uiFuncButton[index]:SetShow(false)
    end
  end
  if funcButtonCount > 6 then
    funcButtonCount = 6
  end
  if 0 == funcButtonCount then
    _uiButtonBack:SetSize(160, 32)
    _uiButtonExit:SetSize(160, 32)
    _uiButtonBack:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Common_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 1, 22, 41, 62)
    _uiButtonBack:getBaseTexture():setUV(x1, y1, x2, y2)
    _uiButtonBack:setRenderTexture(_uiButtonBack:getBaseTexture())
    _uiButtonBack:ChangeOnTextureInfoName("Renewal/PcRemaster/Remaster_Common_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 42, 22, 82, 62)
    _uiButtonBack:getOnTexture():setUV(x1, y1, x2, y2)
    _uiButtonBack:ChangeClickTextureInfoName("Renewal/PcRemaster/Remaster_Common_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 83, 22, 123, 62)
    _uiButtonBack:getClickTexture():setUV(x1, y1, x2, y2)
    _uiButtonExit:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Common_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 124, 22, 164, 62)
    _uiButtonExit:getBaseTexture():setUV(x1, y1, x2, y2)
    _uiButtonExit:setRenderTexture(_uiButtonExit:getBaseTexture())
    _uiButtonExit:ChangeOnTextureInfoName("Renewal/PcRemaster/Remaster_Common_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 165, 22, 205, 62)
    _uiButtonExit:getOnTexture():setUV(x1, y1, x2, y2)
    _uiButtonExit:ChangeClickTextureInfoName("Renewal/PcRemaster/Remaster_Common_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 206, 22, 246, 62)
    _uiButtonExit:getClickTexture():setUV(x1, y1, x2, y2)
    _uiButtonBack:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NPC_DIALOG_BACK"))
    _uiButtonExit:SetText(PAGetString(Defines.StringSheet_RESOURCE, "DIALOGUE_BTN_EXIT"))
    _uiButtonBack:SetPosX((sizeX - (buttonSize * 2 + buttonGap * 1)) / 2)
    _uiButtonExit:SetPosX((sizeX - (buttonSize * 2 + buttonGap * 1)) / 2 + buttonSize + buttonGap)
  elseif 0 < _uiFuncButton[0]:GetPosX() - buttonSize - buttonGap then
    _uiButtonBack:SetSize(160, 32)
    _uiButtonExit:SetSize(160, 32)
    _uiButtonBack:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Common_00.dds")
    x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 1, 22, 41, 62)
    _uiButtonBack:getBaseTexture():setUV(x1, y1, x2, y2)
    _uiButtonBack:setRenderTexture(_uiButtonBack:getBaseTexture())
    _uiButtonBack:ChangeOnTextureInfoName("Renewal/PcRemaster/Remaster_Common_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 42, 22, 82, 62)
    _uiButtonBack:getOnTexture():setUV(x1, y1, x2, y2)
    _uiButtonBack:ChangeClickTextureInfoName("Renewal/PcRemaster/Remaster_Common_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 83, 22, 123, 62)
    _uiButtonBack:getClickTexture():setUV(x1, y1, x2, y2)
    _uiButtonExit:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Common_00.dds")
    x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 124, 22, 164, 62)
    _uiButtonExit:getBaseTexture():setUV(x1, y1, x2, y2)
    _uiButtonExit:setRenderTexture(_uiButtonExit:getBaseTexture())
    _uiButtonExit:ChangeOnTextureInfoName("Renewal/PcRemaster/Remaster_Common_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 165, 22, 205, 62)
    _uiButtonExit:getOnTexture():setUV(x1, y1, x2, y2)
    _uiButtonExit:ChangeClickTextureInfoName("Renewal/PcRemaster/Remaster_Common_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 206, 22, 246, 62)
    _uiButtonExit:getClickTexture():setUV(x1, y1, x2, y2)
    _uiButtonBack:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NPC_DIALOG_BACK"))
    _uiButtonExit:SetText(PAGetString(Defines.StringSheet_RESOURCE, "DIALOGUE_BTN_EXIT"))
    _uiButtonBack:SetPosX(_uiFuncButton[0]:GetPosX() - buttonSize - buttonGap)
    _uiButtonExit:SetPosX(_uiFuncButton[funcButtonCount - 1]:GetPosX() + buttonSize + buttonGap)
  else
    _uiButtonBack:SetSize(32, 32)
    _uiButtonExit:SetSize(32, 32)
    _uiButtonBack:ChangeTextureInfoName("New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_09.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 1, 100, 33, 132)
    _uiButtonBack:getBaseTexture():setUV(x1, y1, x2, y2)
    _uiButtonBack:setRenderTexture(_uiButtonBack:getBaseTexture())
    _uiButtonBack:ChangeOnTextureInfoName("New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_09.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 156, 100, 188, 132)
    _uiButtonBack:getOnTexture():setUV(x1, y1, x2, y2)
    _uiButtonBack:ChangeClickTextureInfoName("New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_09.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonBack, 311, 100, 343, 132)
    _uiButtonBack:getClickTexture():setUV(x1, y1, x2, y2)
    _uiButtonExit:ChangeTextureInfoName("New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_09.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonExit, 1, 133, 33, 165)
    _uiButtonExit:getBaseTexture():setUV(x1, y1, x2, y2)
    _uiButtonExit:setRenderTexture(_uiButtonExit:getBaseTexture())
    _uiButtonExit:ChangeOnTextureInfoName("New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_09.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonExit, 156, 133, 188, 165)
    _uiButtonExit:getOnTexture():setUV(x1, y1, x2, y2)
    _uiButtonExit:ChangeClickTextureInfoName("New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_09.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(_uiButtonExit, 311, 133, 343, 165)
    _uiButtonExit:getClickTexture():setUV(x1, y1, x2, y2)
    _uiButtonBack:SetText("")
    _uiButtonExit:SetText("")
    _uiButtonBack:SetPosX(_uiFuncButton[0]:GetPosX() - buttonGap * 4)
    _uiButtonExit:SetPosX(_uiFuncButton[funcButtonCount - 1]:GetPosX() + buttonSize + buttonGap)
  end
  Panel_Npc_Quest_Reward:SetPosX(sizeX - Panel_Npc_Quest_Reward:GetSizeX())
  Panel_Npc_Quest_Reward:SetPosY(sizeY - Panel_Npc_Quest_Reward:GetSizeY() - Panel_Npc_Dialog:GetSizeY())
  FGlobal_ShowRewardList(isVisible)
  _SpacebarIcon:SetSize(40, 28)
  _SpacebarIcon:SetShow(true)
  _SpacebarIcon:SetPosX(_rBtnPosX + _SpacebarIcon:GetSizeX() - 30)
  _SpacebarIcon:SetPosY(_rBtnPosY + 1)
  if isShowReContactDialog() or _uiNextButton:GetShow() or isShowDialogFunctionQuest() or -1 < questDialogIndex() or -1 < exchangalbeButtonIndex() then
    if 1 == _btnPositionType then
      _SpacebarIcon:SetPosX(_rBtnPosX + _SpacebarIcon:GetSizeX() - 30)
      _SpacebarIcon:SetPosY(_rBtnPosY + 1)
    elseif 2 == _btnPositionType then
      _SpacebarIcon:SetPosX(_rBtnPosX + _SpacebarIcon:GetSizeX() - 30)
      _SpacebarIcon:SetPosY(_rBtnPosY + 1)
    elseif 3 == _btnPositionType then
      _SpacebarIcon:SetSize(_SpacebarIcon:GetSizeX(), _uiFuncButton[0]:GetSizeY())
      _SpacebarIcon:SetPosX(startPosX + buttonSize - _SpacebarIcon:GetSizeX())
      _SpacebarIcon:SetPosY(_uiFuncButton[0]:GetPosY())
    elseif 4 == _btnPositionType then
      _SpacebarIcon:SetPosX(_rBtnPosX + _SpacebarIcon:GetSizeX() - 30)
      _SpacebarIcon:SetPosY(_rBtnPosY + 1)
    elseif 5 == _btnPositionType then
      _SpacebarIcon:SetPosX(_rBtnPosX + _SpacebarIcon:GetSizeX() - 30)
      _SpacebarIcon:SetPosY(_rBtnPosY + 1)
    elseif 6 == _btnPositionType then
      _SpacebarIcon:SetPosX(_rBtnPosX + _SpacebarIcon:GetSizeX() - 30)
      _SpacebarIcon:SetPosY(_rBtnPosY + 1)
    end
  else
    _SpacebarIcon:SetShow(false)
  end
  for i = 0, 5 do
    if true == handleClickedQuestComplete and true == nextQuestFunctionBtnClick[i] then
      handleClickedQuestComplete = false
      nextQuestFunctionBtnClick[i] = false
      Dialog_clickFuncButtonReq(i)
      Panel_Interest_Knowledge_Hide()
      if -1 < questDialogIndex() then
        HandleClickedDialogButton(questDialogIndex())
        handleClickedQuestComplete = false
      end
      break
    end
  end
end
function FromClient_hideDialog(isSetWait)
  if false == Panel_Npc_Dialog:IsShow() then
    return
  end
  SetUIMode(Defines.UIMode.eUIMode_Default)
  hide_DialogSceneUIPanel()
  InventoryWindow_Close()
  if Panel_Window_Warehouse:GetShow() then
    Warehouse_Close()
  end
  if false == _ContentsGroup_NewUI_CreateClan_All then
    if Panel_CreateClan ~= nil and Panel_CreateClan:GetShow() or nil ~= Panel_CreateGuild and Panel_CreateGuild:GetShow() then
      CreateClan_Close()
    end
  elseif Panel_CreateClan_All ~= nil and Panel_CreateClan_All:GetShow() or nil ~= Panel_CreateGuild and Panel_CreateGuild:GetShow() then
    PaGlobal_CreateClan_All_Close()
  end
  if true == _ContentsGroup_NewUI_WorkerAuction_All and nil ~= Panel_Window_WorkerAuction_All then
    HandleEventLUp_WorkerAuction_All_Close()
  elseif nil ~= Panel_WorkerResist_Auction and nil ~= Panel_WorkerList_Auction then
    Panel_WorkerResist_Auction:SetShow(false)
    Panel_WorkerList_Auction:SetShow(false)
  end
  FGolbal_ItemMarketNew_Close()
  PaGlobalFunc_ItemMarketRegistItem_SetShow(false)
  Panel_Window_Delivery_Information:SetShow(false)
  Panel_Window_Delivery_Request:SetShow(false)
  Panel_Dialogue_Itemtake:SetShow(false)
  Panel_SkillReinforce:SetShow(false)
  Panel_Window_ReinforceSkill:SetShow(false)
  if nil ~= Panel_Worker_Auction then
    Panel_Worker_Auction:SetShow(false)
  end
  if false == _ContentsGroup_NewUI_WorkerRandomSelect_All then
    if nil ~= Panel_Window_WorkerRandomSelect then
      Panel_Window_WorkerRandomSelect:SetShow(false)
    end
  else
    HandleEventLUp_WorkerRandomSelect_All_Close()
  end
  if false == _ContentsGroup_NewUI_RandomShop_All then
    randomSelectHide()
  else
    PaGlobalFunc_RandomShop_All_Close()
  end
  DetectPlayer_Close()
  BlackSpiritAd_Hide()
  dialog_CloseNpcTalk(isSetWait)
  Panel_Npc_Dialog:ResetVertexAni()
  searchView_Close()
  setIgnoreShowDialog(false)
  FGlobal_ShowRewardList(false)
  setShowLine(true)
  _blackStone_CallingTime = 0
  setFullSizeMode(false, FullSizeMode.fullSizeModeEnum.Dialog)
  if false == _ContentsGroup_RenewUI_Skill then
    HandleMLUp_SkillWindow_Close()
  end
  click_DeliveryForPerson_Close()
  if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= HandleEventLUp_NPCShop_ALL_Close then
    HandleEventLUp_NPCShop_ALL_Close()
  elseif nil ~= Panel_Window_NpcShop then
    NpcShop_WindowClose()
  end
  FGlobal_NodeWarMenuClose()
  if isMonsterBarShow then
    Panel_Monster_Bar:SetShow(true, false)
    isMonsterBarShow = false
  end
  if isNpcNaviShow then
    isNpcNaviShow = false
  end
  FGlobal_NpcNavi_ShowRequestOuter()
  AcquireDirecteReShowUpdate()
  isAuctionDialog = false
  FGlobal_QuestWidget_UpdateList()
  PaGlobalAppliedBuffList:show()
  setShowNpcDialog(false)
  ChatInput_Close()
  if Panel_Window_Exchange:IsShow() then
    ExchangePc_MessageBox_CloseConfirm()
  end
  Panel_Exchange_Item_Hide()
  Panel_Interest_Knowledge_Hide()
  Inventory_PosLoadMemory()
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    FGlobal_Inventory_WeightCheck()
    UIMain_QuestUpdate()
  end
  if ToClient_IsSavedUi() then
    ToClient_SaveUiInfo(false)
    ToClient_SetSavedUi(false)
  end
end
local _indexWhenWorkerShopClicked
function RandomWorkerSelectUseMyWpConfirm(index)
  if nil == index then
    index = _indexWhenWorkerShopClicked
  end
  npcShop_requestList(CppEnums.ContentsType.Contents_Shop)
  Dialog_clickFuncButtonReq(index)
  Panel_Interest_Knowledge_Hide()
end
function ClickFunctionButtonByType(type)
  if Panel_Win_System:GetShow() then
    return
  end
  if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= HandleEventLUp_NPCShop_ALL_Close then
    HandleEventLUp_NPCShop_ALL_Close()
  else
    NpcShop_WindowClose()
  end
  if false == _ContentsGroup_RenewUI_Skill then
    HandleMLUp_SkillWindow_Close()
  end
  Warehouse_Close()
  FGlobal_ItemMarketRegistItem_Close()
  TerritoryAuth_Auction_Close()
  InventoryWindow_Close()
  Panel_Dialogue_Itemtake:SetShow(false)
  LordMenu_Hide()
  if false == _ContentsGroup_NewUI_CreateClan_All then
    CreateClan_Close()
  else
    PaGlobal_CreateClan_All_Close()
  end
  if not _ContentsGroup_RenewUI_Manufacture then
    Manufacture_Close()
  end
  if true == _ContentsGroup_NewUI_WorkerAuction_All and nil ~= Panel_Window_WorkerAuction_All then
    HandleEventLUp_WorkerAuction_All_Close()
  elseif nil ~= Panel_Worker_Auction then
    WorkerAuction_Close()
  end
  Panel_Exchange_Item_Hide()
  Panel_Window_ReinforceSkill_Close()
  Panel_SkillReinforce_Close()
  local count = 0
  local targetWindowList = {}
  audioPostEvent_SystemUi(0, 0)
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local dlgFuncCnt = dialogData:getFuncButtonCount()
  if dlgFuncCnt <= 0 then
    return
  end
  local funcButton
  local funcButtonType = -1
  for index = 0, dlgFuncCnt - 1 do
    local afuncButton = dialogData:getFuncButtonAt(index)
    if nil == afuncButton then
      return
    end
    afuncButtonType = tonumber(afuncButton._param)
    if afuncButtonType == type then
      funcButton = afuncButton
      funcButtonType = afuncButtonType
      break
    end
  end
  if nil == funcButton then
    return
  end
  local MyWp = getSelfPlayer():getWp()
  local inventory = getSelfPlayer():get():getInventory()
  local invenSize = inventory:getFreeCount()
  if CppEnums.ContentsType.Contents_Quest == funcButtonType or CppEnums.ContentsType.Contents_NewQuest == funcButtonType then
    local talker = dialog_getTalker()
    if nil == talker then
      _uiNpcDialog:SetShow(false)
      for index = 0, 3 do
        _uiFilterRadioButton[index]:SetShow(true)
        _uiFilterRadioButton[index]:SetCheck(1 == index)
      end
      ToClient_SetFilterType(1, true)
    end
  end
  if CppEnums.ContentsType.Contents_Shop == funcButtonType then
    local shopType = dialogData:getShopType()
    if _shopType.eShopType_Worker == shopType then
      _indexWhenWorkerShopClicked = index
      local pcPosition = getSelfPlayer():get():getPosition()
      local regionInfo = getRegionInfoByPosition(pcPosition)
      local region = regionInfo:get()
      local regionPlantKey = regionInfo:getPlantKeyByWaypointKey()
      local waitWorkerCount = ToClient_getPlantWaitWorkerListCount(regionPlantKey, 0)
      local maxWorkerCount = ToClient_getTownWorkerMaxCapacity(regionPlantKey)
      local s64_allWeight = Int64toInt32(getSelfPlayer():get():getCurrentWeight_s64())
      local s64_maxWeight = Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64())
      if s64_allWeight >= s64_maxWeight then
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_WEIGHTOVER_ALERTTITLE"),
          content = PAGetString(Defines.StringSheet_GAME, "LUA_WEIGHTOVER_ALERTDESC"),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
        return
      end
      if 0 ~= getSelfPlayer():get():checkWorkerWorkingServerNo() then
        local messageboxData3 = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = PAGetString(Defines.StringSheet_GAME, "Lua_WorkerShop_Cant_Employ_NotSameServerNo"),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData3)
        return
      end
      if waitWorkerCount == maxWorkerCount then
        local buyCash = function()
          PaGlobal_EasyBuy:Open(16, getCurrentWaypointKey())
        end
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "Lua_WorkerShop_ReSelect"),
          content = PAGetString(Defines.StringSheet_GAME, "Lua_WorkerShop_Cant_Employ") .. [[


]] .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERHOUSE_EASYBUY"),
          functionYes = buyCash,
          functionNo = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
      end
      if MyWp >= 5 then
        local messageboxData2 = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_CONFIRM_WORKER", "MyWp", MyWp),
          functionYes = RandomWorkerSelectUseMyWpConfirm,
          functionNo = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData2)
        return
      end
    end
    if _shopType.eShopType_RandomShop == shopType then
      local s64_allWeight = Int64toInt32(getSelfPlayer():get():getCurrentWeight_s64())
      local s64_maxWeight = Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64())
      if s64_allWeight >= s64_maxWeight then
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_WEIGHTOVER_ALERTTITLE"),
          content = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_SECRETSHOP_WEIGHTOVER"),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
        return
      end
      local IsRamdomShopkeepItem = ToClient_IsRandomShopKeepItem()
      if IsRamdomShopkeepItem == false then
        local randomShopConsumeWp = ToClient_getRandomShopConsumWp()
        if invenSize <= 0 then
          local messageboxData = {
            title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
            content = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_SECRETSHOP_FREESLOT"),
            functionApply = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageboxData)
          return
        end
        if MyWp < randomShopConsumeWp then
          local messageboxData2 = {
            title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
            content = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_LACK_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", MyWp),
            functionApply = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageboxData2)
          return
        elseif MyWp >= randomShopConsumeWp then
          local messageboxData2 = {
            title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
            content = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_CONFIRM_RANDOMITEM_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", MyWp),
            functionYes = RandomWorkerSelectUseMyWpConfirm,
            functionNo = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageboxData2)
          return
        end
      end
    end
    if _shopType.eShopType_DayRandomShop == shopType then
      local s64_allWeight = Int64toInt32(getSelfPlayer():get():getCurrentWeight_s64())
      local s64_maxWeight = Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64())
      if s64_allWeight >= s64_maxWeight then
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_WEIGHTOVER_ALERTTITLE"),
          content = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_SECRETSHOP_WEIGHTOVER"),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
        return
      end
      local randomShopConsumeWp = 10
      if invenSize <= 0 then
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_SECRETSHOP_FREESLOT"),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
        return
      end
      if MyWp < randomShopConsumeWp then
        local messageboxData2 = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_LACK_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", MyWp),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData2)
        return
      elseif MyWp >= randomShopConsumeWp then
        local messageboxData2 = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_CONFIRM_RANDOMITEM_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", MyWp),
          functionYes = RandomWorkerSelectUseMyWpConfirm,
          functionNo = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData2)
        return
      end
    end
    count = 2
    if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= Panel_Dialog_NPCShop_All then
      targetWindowList = {Panel_Dialog_NPCShop_All, Panel_Window_Inventory}
    else
      targetWindowList = {Panel_Window_NpcShop, Panel_Window_Inventory}
    end
    show_DialogPanel()
  elseif CppEnums.ContentsType.Contents_Skill == funcButtonType then
    if false == _ContentsGroup_RenewUI_Skill then
      count = 1
      targetWindowList = {Panel_Window_Skill}
    end
  elseif CppEnums.ContentsType.Contents_Auction == funcButtonType then
  elseif CppEnums.ContentsType.Contents_Inn == funcButtonType then
  elseif CppEnums.ContentsType.Contents_IntimacyGame == funcButtonType then
  elseif CppEnums.ContentsType.Contents_DeliveryPerson == funcButtonType then
    count = 1
    targetWindowList = {Panel_Window_DeliveryForPerson}
  elseif CppEnums.ContentsType.Contents_Guild == funcButtonType then
    FGlobal_GuildCreateManagerPopup()
  elseif CppEnums.ContentsType.Contents_Explore == funcButtonType then
  elseif CppEnums.ContentsType.Contents_Enchant == funcButtonType then
    PaGlobal_Enchant:enchant_Show()
  elseif CppEnums.ContentsType.Contents_Socket == funcButtonType then
    Socket_Window_Show()
  elseif CppEnums.ContentsType.Contents_LordMenu == funcButtonType then
    LordMenu_Show()
  elseif CppEnums.ContentsType.Contents_Extract == funcButtonType then
    extraction_Open()
  elseif CppEnums.ContentsType.Contents_TerritoryTrade == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_TerritorySupply == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_GuildShop == funcButtonType then
    count = 2
    if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= Panel_Dialog_NPCShop_All then
      targetWindowList = {Panel_Dialog_NPCShop_All, Panel_Window_Inventory}
    else
      targetWindowList = {Panel_Window_NpcShop, Panel_Window_Inventory}
    end
  elseif CppEnums.ContentsType.Contents_SupplyShop == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_FishSupplyShop == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_GuildSupplyShop == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_MinorLordMenu == funcButtonType then
    FGlobal_NodeWarMenuOpen()
  end
  Dialog_innerPanelShow(count, targetWindowList)
  if CppEnums.ContentsType.Contents_Shop == funcButtonType then
    npcShop_requestList(funcButtonType)
    FGlobal_NodeWarMenuClose()
  elseif CppEnums.ContentsType.Contents_Skill == funcButtonType then
    if false == _ContentsGroup_RenewUI_Skill then
      HandleMLUp_SkillWindow_OpenForLearn()
    else
      PaGlobalFunc_Skill_Open()
    end
  elseif CppEnums.ContentsType.Contents_Repair == funcButtonType then
    if true == _ContentsGroup_RenewUI_Repair then
      PaGlobalFunc_RepairInfo_Open()
    else
      PaGlobal_Repair:repair_OpenPanel(true)
    end
  elseif CppEnums.ContentsType.Contents_Warehouse == funcButtonType then
    Warehouse_OpenPanelFromDialog()
  elseif CppEnums.ContentsType.Contents_Stable == funcButtonType then
    if isGuildStable() then
      if CppEnums.ServantType.Type_Vehicle == stable_getServantType() then
        GuildStableFunction_Open()
      elseif CppEnums.ServantType.Type_Ship == stable_getServantType() then
        GuildWharfFunction_Open()
      end
    else
      warehouse_requestInfoFromNpc()
      if CppEnums.ServantType.Type_Vehicle == stable_getServantType() then
        StableFunction_Open()
      elseif CppEnums.ServantType.Type_Ship == stable_getServantType() then
        WharfFunction_Open()
      else
        PetFunction_Open()
        PetList_Open()
      end
    end
    show_DialogPanel()
  elseif CppEnums.ContentsType.Contents_Transfer == funcButtonType then
    DeliveryInformation_OpenPanelFromDialog()
  elseif CppEnums.ContentsType.Contents_Explore == funcButtonType then
  elseif CppEnums.ContentsType.Contents_DeliveryPerson == funcButtonType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_ReMake"))
  elseif CppEnums.ContentsType.Contents_GuildShop == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_ItemMarket == funcButtonType then
    if PaGlobalFunc_ItemMarket_IsUISubApp() then
      Panel_Window_ItemMarket:CloseUISubApp()
      Panel_Window_ItemMarket:SetShow(false)
    end
    if not PaGlobalFunc_ItemMarket_GetShow() then
      FGolbal_ItemMarket_Function_Open()
    else
      FGolbal_ItemMarket_Function_Close()
    end
  elseif CppEnums.ContentsType.Contents_NewItemMarket == funcButtonType then
    if not PaGlobalFunc_MarketPlace_GetShow() then
      PaGlobalFunc_MarketPlace_OpenFromDialog()
    else
      PaGlobalFunc_MarketPlace_CloseToDialog()
    end
  elseif CppEnums.ContentsType.Contents_Knowledge == funcButtonType then
    FGlobal_KnowledgeManagementShow()
  elseif CppEnums.ContentsType.Contents_Join == funcButtonType then
    Panel_Join_Show()
  elseif CppEnums.ContentsType.Contents_Improve == funcButtonType then
    Panel_Improvement_Show()
  end
  Dialog_clickFuncButtonReq(index)
  Panel_Interest_Knowledge_Hide()
end
function HandleClickedFilterButton(index)
  ToClient_SetFilterType(index, true)
  Page_Setting(0)
  Dialog_updateMainDialog()
end
function HandleOverd_FilterAllButton(isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local uiControl = _uiFilterRadioButton[0]
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_QUESTFILTER_ALL")
  TooltipSimple_Show(uiControl, name)
end
function HandleClickedFuncButton(index)
  if Panel_Win_System:GetShow() then
    return
  end
  if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= HandleEventLUp_NPCShop_ALL_Close then
    HandleEventLUp_NPCShop_ALL_Close()
  else
    NpcShop_WindowClose()
  end
  if false == _ContentsGroup_RenewUI_Skill then
    HandleMLUp_SkillWindow_Close()
  end
  Warehouse_Close()
  FGlobal_ItemMarketRegistItem_Close()
  TerritoryAuth_Auction_Close()
  InventoryWindow_Close()
  Panel_Dialogue_Itemtake:SetShow(false)
  LordMenu_Hide()
  if false == _ContentsGroup_NewUI_CreateClan_All then
    CreateClan_Close()
  else
    PaGlobal_CreateClan_All_Close()
  end
  if not _ContentsGroup_RenewUI_Manufacture then
    Manufacture_Close()
  end
  if true == _ContentsGroup_NewUI_WorkerAuction_All and nil ~= Panel_Window_WorkerAuction_All then
    HandleEventLUp_WorkerAuction_All_Close()
  elseif nil ~= Panel_Worker_Auction then
    WorkerAuction_Close()
  end
  Panel_Exchange_Item_Hide()
  Panel_Window_ReinforceSkill_Close()
  Panel_SkillReinforce_Close()
  BlackSpiritAd_Hide()
  if true == _ContentsGroup_RenewUI_Gift then
    PaGlobalFunc_NpcGift_Close()
  else
    FGlobal_NpcGift_Close()
  end
  if true == _ContentsGroup_NewUI_Purification_All and nil ~= Panel_Purification_All then
    HandleEventLUp_Purification_All_Close()
  elseif nil ~= Panel_Purification_Renew or nil ~= Panel_Purification then
    PaGlobal_Purification_Close()
  end
  if Panel_Window_Enchant:GetShow() then
    PaGlobal_Enchant:enchantClose()
  end
  if Panel_Window_Socket:GetShow() then
    Socket_WindowClose()
  end
  if Panel_Improvement:GetShow() then
    Panel_Improvement_Hide()
  end
  if Panel_SkillAwaken:GetShow() then
    SkillAwaken_Close()
  end
  if Panel_Window_MasterpieceAuction:GetShow() then
    PaGlobal_MasterpieceAuction:close()
  end
  if nil ~= Panel_GuildHouse_Auction_All and Panel_GuildHouse_Auction_All:GetShow() then
    PaGlobal_GuildHouse_Auction_All_Close()
  end
  if nil ~= Panel_GuildHouse_Auction_Detail_All and Panel_GuildHouse_Auction_Detail_All:GetShow() then
    PaGlobal_GuildHouse_Auction_Detail_All_Close()
  end
  if nil ~= Panel_GuildHouse_Auction_Bid_All and Panel_GuildHouse_Auction_Bid_All:GetShow() then
    PaGlobal_GuildHouse_Auction_Bid_All_Close()
  end
  if nil ~= Panel_CreateClan_All and Panel_CreateClan_All:GetShow() then
    PaGlobal_CreateClan_All_Close()
  end
  if nil ~= Panel_Guild_Create_All and Panel_Guild_Create_All:GetShow() then
    PaGlobal_Guild_Create_All_Close()
  end
  local count = 0
  local targetWindowList = {}
  audioPostEvent_SystemUi(0, 0)
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local dlgFuncCnt = dialogData:getFuncButtonCount()
  if dlgFuncCnt <= 0 then
    return
  end
  local funcButton = dialogData:getFuncButtonAt(index)
  if nil == funcButton then
    return
  end
  local funcButtonType = tonumber(funcButton._param)
  local MyWp = getSelfPlayer():getWp()
  local inventory = getSelfPlayer():get():getInventory()
  local invenSize = inventory:getFreeCount()
  if CppEnums.ContentsType.Contents_Quest == funcButtonType or CppEnums.ContentsType.Contents_NewQuest == funcButtonType then
    local talker = dialog_getTalker()
    if nil == talker then
      _uiNpcDialog:SetShow(false)
      dialogData:setEmptyMainDialog()
      for index = 0, 3 do
        _uiFilterRadioButton[index]:SetShow(true)
        _uiFilterRadioButton[index]:SetCheck(1 == index)
        if 0 ~= index then
          ToClient_SetFilterType(index, true)
          local dialogData = ToClient_GetCurrentDialogData()
          local dialogButtonCount = dialogData:getDialogButtonCount()
          dialogCountList[index] = dialogButtonCount
          _uiFilterRadioButton[index]:SetText(_uiFilterString[index] .. "(" .. dialogCountList[index] .. ")")
        end
      end
      ToClient_SetFilterType(1, true)
    end
  end
  if CppEnums.ContentsType.Contents_Shop == funcButtonType then
    local shopType = dialogData:getShopType()
    if _shopType.eShopType_Worker == shopType then
      _indexWhenWorkerShopClicked = index
      local pcPosition = getSelfPlayer():get():getPosition()
      local regionInfo = getRegionInfoByPosition(pcPosition)
      local region = regionInfo:get()
      local regionPlantKey = regionInfo:getPlantKeyByWaypointKey()
      local waitWorkerCount = ToClient_getPlantWaitWorkerListCount(regionPlantKey, 0)
      local maxWorkerCount = ToClient_getTownWorkerMaxCapacity(regionPlantKey)
      local s64_allWeight = Int64toInt32(getSelfPlayer():get():getCurrentWeight_s64())
      local s64_maxWeight = Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64())
      if s64_allWeight >= s64_maxWeight then
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_WEIGHTOVER_ALERTTITLE"),
          content = PAGetString(Defines.StringSheet_GAME, "LUA_WEIGHTOVER_ALERTDESC"),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
        return
      end
      if 0 ~= getSelfPlayer():get():checkWorkerWorkingServerNo() then
        local messageboxData3 = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = PAGetString(Defines.StringSheet_GAME, "Lua_WorkerShop_Cant_Employ_NotSameServerNo"),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData3)
        return
      end
      if waitWorkerCount == maxWorkerCount then
        local buyCash = function()
          PaGlobal_EasyBuy:Open(16, getCurrentWaypointKey())
        end
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "Lua_WorkerShop_ReSelect"),
          content = PAGetString(Defines.StringSheet_GAME, "Lua_WorkerShop_Cant_Employ") .. [[


]] .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERHOUSE_EASYBUY"),
          functionYes = buyCash,
          functionNo = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
      end
      if MyWp >= 5 then
        local messageboxData2 = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_CONFIRM_WORKER", "MyWp", MyWp),
          functionYes = RandomWorkerSelectUseMyWpConfirm,
          functionNo = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData2)
        return
      end
    end
    if _shopType.eShopType_RandomShop == shopType then
      if invenSize <= 0 then
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_SECRETSHOP_FREESLOT"),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
        return
      end
      local s64_allWeight = Int64toInt32(getSelfPlayer():get():getCurrentWeight_s64())
      local s64_maxWeight = Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64())
      if s64_allWeight >= s64_maxWeight then
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_WEIGHTOVER_ALERTTITLE"),
          content = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_SECRETSHOP_WEIGHTOVER"),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
        return
      end
      local IsRamdomShopkeepItem = ToClient_IsRandomShopKeepItem()
      if IsRamdomShopkeepItem == false then
        local randomShopConsumeWp = ToClient_getRandomShopConsumWp()
        if MyWp < randomShopConsumeWp then
          local messageboxData2 = {
            title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
            content = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_LACK_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", MyWp),
            functionApply = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageboxData2)
          return
        elseif MyWp >= randomShopConsumeWp then
          local messageboxData2 = {
            title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
            content = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_CONFIRM_RANDOMITEM_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", MyWp),
            functionYes = RandomWorkerSelectUseMyWpConfirm,
            functionNo = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageboxData2)
          return
        end
      end
    end
    if _shopType.eShopType_DayRandomShop == shopType then
      if invenSize <= 0 then
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_SECRETSHOP_FREESLOT"),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
        return
      end
      local s64_allWeight = Int64toInt32(getSelfPlayer():get():getCurrentWeight_s64())
      local s64_maxWeight = Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64())
      if s64_allWeight >= s64_maxWeight then
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_WEIGHTOVER_ALERTTITLE"),
          content = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_SECRETSHOP_WEIGHTOVER"),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
        return
      end
      local randomShopConsumeWp = 10
      if MyWp < randomShopConsumeWp then
        local messageboxData2 = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_LACK_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", MyWp),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData2)
        return
      elseif MyWp >= randomShopConsumeWp then
        local messageboxData2 = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_CONFIRM_RANDOMITEM_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", MyWp),
          functionYes = RandomWorkerSelectUseMyWpConfirm,
          functionNo = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData2)
        return
      end
    end
    count = 2
    if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= Panel_Dialog_NPCShop_All then
      targetWindowList = {Panel_Dialog_NPCShop_All, Panel_Window_Inventory}
    else
      targetWindowList = {Panel_Window_NpcShop, Panel_Window_Inventory}
    end
    show_DialogPanel()
  elseif CppEnums.ContentsType.Contents_Skill == funcButtonType then
    if false == _ContentsGroup_RenewUI_Skill then
      count = 1
      targetWindowList = {Panel_Window_Skill}
    end
  elseif CppEnums.ContentsType.Contents_Auction == funcButtonType then
  elseif CppEnums.ContentsType.Contents_Inn == funcButtonType then
  elseif CppEnums.ContentsType.Contents_IntimacyGame == funcButtonType then
  elseif CppEnums.ContentsType.Contents_DeliveryPerson == funcButtonType then
    count = 1
    targetWindowList = {Panel_Window_DeliveryForPerson}
  elseif CppEnums.ContentsType.Contents_Guild == funcButtonType then
    if false == _ContentsGroup_NewUI_CreateClan_All then
      FGlobal_GuildCreateManagerPopup()
    else
      PaGlobal_CreateClan_All_Open()
    end
  elseif CppEnums.ContentsType.Contents_Explore == funcButtonType then
  elseif CppEnums.ContentsType.Contents_Enchant == funcButtonType then
    PaGlobal_Enchant:enchant_Show()
  elseif CppEnums.ContentsType.Contents_Socket == funcButtonType then
    Socket_Window_Show()
  elseif CppEnums.ContentsType.Contents_LordMenu == funcButtonType then
    LordMenu_Show()
  elseif CppEnums.ContentsType.Contents_Extract == funcButtonType then
    extraction_Open()
  elseif CppEnums.ContentsType.Contents_TerritoryTrade == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_TerritorySupply == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_GuildShop == funcButtonType then
    count = 2
    if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= Panel_Dialog_NPCShop_All then
      targetWindowList = {Panel_Dialog_NPCShop_All, Panel_Window_Inventory}
    else
      targetWindowList = {Panel_Window_NpcShop, Panel_Window_Inventory}
    end
  elseif CppEnums.ContentsType.Contents_SupplyShop == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_FishSupplyShop == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_GuildSupplyShop == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_MinorLordMenu == funcButtonType then
    FGlobal_NodeWarMenuOpen()
  elseif CppEnums.ContentsType.Contents_Improve == funcButtonType then
    Panel_Improvement_Show()
  end
  Dialog_innerPanelShow(count, targetWindowList)
  if CppEnums.ContentsType.Contents_Shop == funcButtonType then
    npcShop_requestList(funcButtonType)
    FGlobal_NodeWarMenuClose()
  elseif CppEnums.ContentsType.Contents_Skill == funcButtonType then
    if false == _ContentsGroup_RenewUI_Skill then
      HandleMLUp_SkillWindow_OpenForLearn()
    else
      PaGlobalFunc_Skill_Open()
    end
  elseif CppEnums.ContentsType.Contents_Repair == funcButtonType then
    if true == _ContentsGroup_RenewUI_Repair then
      PaGlobalFunc_RepairInfo_Open()
    else
      PaGlobal_Repair:repair_OpenPanel(true)
    end
  elseif CppEnums.ContentsType.Contents_Warehouse == funcButtonType then
    Warehouse_OpenPanelFromDialog()
  elseif CppEnums.ContentsType.Contents_Stable == funcButtonType then
    if isGuildStable() then
      if CppEnums.ServantType.Type_Vehicle == stable_getServantType() then
        GuildStableFunction_Open()
      elseif CppEnums.ServantType.Type_Ship == stable_getServantType() then
        GuildWharfFunction_Open()
      end
    else
      warehouse_requestInfoFromNpc()
      if CppEnums.ServantType.Type_Vehicle == stable_getServantType() then
        StableFunction_Open()
      elseif CppEnums.ServantType.Type_Ship == stable_getServantType() then
        WharfFunction_Open()
      else
        PetFunction_Open()
        PetList_Open()
      end
    end
    show_DialogPanel()
  elseif CppEnums.ContentsType.Contents_Transfer == funcButtonType then
    DeliveryInformation_OpenPanelFromDialog()
  elseif CppEnums.ContentsType.Contents_Explore == funcButtonType then
  elseif CppEnums.ContentsType.Contents_DeliveryPerson == funcButtonType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_ReMake"))
  elseif CppEnums.ContentsType.Contents_GuildShop == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_ItemMarket == funcButtonType then
    if PaGlobalFunc_ItemMarket_IsUISubApp() then
      Panel_Window_ItemMarket:CloseUISubApp()
      Panel_Window_ItemMarket:SetShow(false)
    end
    if not PaGlobalFunc_ItemMarket_GetShow() then
      FGolbal_ItemMarket_Function_Open()
    else
      FGolbal_ItemMarket_Function_Close()
    end
  elseif CppEnums.ContentsType.Contents_NewItemMarket == funcButtonType then
    if not PaGlobalFunc_MarketPlace_GetShow() then
      PaGlobalFunc_MarketPlace_OpenFromDialog()
    else
      PaGlobalFunc_MarketPlace_CloseToDialog()
    end
  elseif CppEnums.ContentsType.Contents_Knowledge == funcButtonType then
    FGlobal_KnowledgeManagementShow()
  elseif CppEnums.ContentsType.Contents_Join == funcButtonType then
    Panel_Join_Show()
  elseif CppEnums.ContentsType.Contents_NpcGift == funcButtonType then
    FGlobal_NpcGift_Open()
  elseif CppEnums.ContentsType.Contents_WeakenEnchant == funcButtonType then
    if true == _ContentsGroup_NewUI_Purification_All and nil ~= Panel_Purification_All then
      PaGlobalFunc_Purification_All_Open()
    elseif nil ~= Panel_Purification then
      PuriManager:Open()
    end
  elseif CppEnums.ContentsType.Contents_DiceGame == funcButtonType then
  elseif CppEnums.ContentsType.Contents_Barter == funcButtonType then
    local talker = dialog_getTalker()
    if nil ~= talker then
      local charSSW = getCharacterStaticStatusWarpper(talker:getCharacterKey())
      if nil ~= charSSW then
        PaGlobal_Barter:setWhereType(CppEnums.ItemWhereType.eInventory)
        PaGlobal_Barter_Open(talker:getActorKey(), charSSW:getBarterRegionKey())
      end
    end
  elseif CppEnums.ContentsType.Contents_EmploySailor == funcButtonType then
    local talker = dialog_getTalker()
    if nil ~= talker then
      local charSSW = getCharacterStaticStatusWarpper(talker:getCharacterKey())
      if nil ~= charSSW then
        local actorKeyRaw = talker:getActorKey()
        local sailorKey = charSSW:getSailorKey()
        local sailorSSW = ToClient_GetSailorWrapper(sailorKey)
        local needItemKey = sailorSSW:getNeedItemKey()
        local slotNo = ToClient_InventoryGetSlotNo(needItemKey)
        ToClient_BuySailor(actorKeyRaw, sailorKey, slotNo)
      end
    end
  end
  PaGlobal_TutorialManager:handleClickedDialogFuncButton(funcButtonType)
  Dialog_clickFuncButtonReq(index)
  Panel_Interest_Knowledge_Hide()
end
function FGlobal_FirstLearnSkill_WindowShow()
  _skillTutorial = true
  HandleClickedFuncButton(CppEnums.ContentsType.Contents_Skill)
  _skillTutorial = false
end
function isSkillLearnTutorial()
  return _skillTutorial
end
function FGlobal_Dialog_TradeOpen()
  if tradeIndex >= 0 then
    HandleClickedFuncButton(tradeIndex)
  end
end
function Dialog_innerPanelShow(count, targetWindowList)
  if count <= 0 then
    return
  end
  dialog_setPositionSelectList(count)
  local index = 0
  for _, v in pairs(targetWindowList) do
    dialog_setPositionSelectSizeSet(index, v:GetSizeX(), v:GetSizeY())
    index = index + 1
  end
  dialog_calcPositionSelectList()
  index = 0
  for _, v in pairs(targetWindowList) do
    if false == v:GetShow() then
      local pos = dialog_PositionSelect(index)
      if 0 ~= pos.x or 0 ~= pos.y then
        if v == Panel_Window_Inventory then
        end
        v:ComputePos()
        v:SetPosX(pos.x)
        v:SetPosY(pos.y)
        index = index + 1
      else
        break
      end
    end
  end
end
function HandleClickedDialogButton(index)
  if Panel_Win_System:GetShow() then
    return
  end
  local _selectRewardItemName = FGlobal_SelectedRewardConfirm()
  _doConfirmIndex = index
  if _selectRewardItemName ~= false and _isQuestComplete == true then
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NOTIFICATIONS_SELECTREWARD", "_selectRewardItemName", _selectRewardItemName)
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = _doConfirmYes,
      functionNo = _doConfirmNo,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "middle")
    return
  else
    HandleClickedDialogButtonReal(_doConfirmIndex)
  end
  for fIndex = 0, 3 do
    _uiFilterRadioButton[fIndex]:SetShow(false)
  end
  _uiNpcDialog:SetShow(true)
end
function _doConfirmYes()
  FGlobal_SelectRewardItemNameClear()
  HandleClickedDialogButtonReal(_doConfirmIndex)
end
function _doConfirmNo()
end
function HandleClickedDialogButtonReal(index)
  local dialogData = ToClient_GetCurrentDialogData()
  local dlgBtnCnt = dialogData:getDialogButtonCount()
  if dlgBtnCnt <= 0 then
    _PA_LOG("\234\185\128\236\176\189\236\154\177", "from. \236\181\156\235\140\128\237\152\184. \235\139\164\236\157\180\236\150\188\235\161\156\234\183\184 lua 2011\235\157\188\236\157\184. \236\157\180\235\159\176\236\157\188\236\157\180 \236\131\157\234\184\176\235\169\180 \236\149\136\235\144\169\235\139\136\235\139\164. \237\153\149\236\157\184\237\149\180\236\163\188\236\132\184\236\154\148")
    return
  end
  index = index + _dialogIndex
  local function clickDialogButtonReq()
    local displayData = Dialog_getButtonDisplayData(index)
    local questInfo = questList_isClearQuest(1038, 2)
    if displayData:empty() then
      Dialog_clickDialogButtonReq(index)
      if questInfo then
        handleClickedQuestComplete = false
      elseif 10 < getSelfPlayer():get():getLevel() then
        handleClickedQuestComplete = false
      else
        handleClickedQuestComplete = true
      end
    else
      TalkPopup_SelectedIndex(index)
      TalkPopup_Show(displayData)
    end
  end
  if true == isCheckExchangeItemButton(index) then
    audioPostEvent_SystemUi(0, 17)
    do
      local dialogButton = dialogData:getDialogButtonAt(index)
      if ExpirationItemCheck(dialogButton:getNeedItemKey()) then
        local CancelExchange = function()
          return
        end
        local function GoExchange()
          HandleClickedDialogButton_ShowData(index)
        end
        local stringExchange = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_ITEMEXCHANGE_EXPIRATIONCHECK")
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_ITEMEXCHANGE_TITLE"),
          content = stringExchange,
          functionYes = GoExchange,
          functionNo = CancelExchange,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
      elseif true == ToClient_isAnyLockedItem(ItemEnchantKey(dialogButton:getNeedItemKey())) then
        local CancelExchange = function()
          return
        end
        local function GoExchange()
          HandleClickedDialogButton_ShowData(index)
        end
        local stringExchange = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_ITEMEXCHANGE_ITEMLOCKED")
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_ITEMEXCHANGE_TITLE"),
          content = stringExchange,
          functionYes = GoExchange,
          functionNo = CancelExchange,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData, nil, false, false)
      else
        do
          local needItemCount = dialogButton:getNeedItemCount()
          if UI_BTN_TYPE.eDialogButton_Exchange == dialogButton._dialogButtonType and needItemCount > 0 then
            local itemStaticWrapper = getItemEnchantStaticStatus(ItemEnchantKey(dialogButton:getNeedItemKey()))
            if itemStaticWrapper ~= nil then
              local itemCount = ExchangeItem_HaveCount(dialogButton:getNeedItemKey())
              if itemCount > 0 then
                local exchangeCount = math.floor(itemCount / needItemCount)
                if exchangeCount > 1 and dialogButton._isValidMultipleExchange then
                  local function dialogExchangeCountSet(inputNum)
                    local itemStaticWrapper = getItemEnchantStaticStatus(ItemEnchantKey(dialogButton:getNeedItemKey()))
                    local _exchangeCount = Int64toInt32(inputNum)
                    local function doExchange()
                      dialogData:setExchangeCount(_exchangeCount)
                      clickDialogButtonReq()
                    end
                    local function exchangeOne()
                      dialogData:setExchangeCount(1)
                      clickDialogButtonReq()
                    end
                    local CancelExchange = function()
                      return
                    end
                    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
                    local messageBoxMemo = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DIALOG_EXCHANGEITEM_CANCLE", "itemName", itemStaticWrapper:getName(), "count", _exchangeCount * needItemCount)
                    local messageBoxData = {
                      title = messageBoxTitle,
                      content = messageBoxMemo,
                      functionYes = doExchange,
                      functionNo = CancelExchange,
                      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
                    }
                    MessageBox.showMessageBox(messageBoxData, "middle")
                  end
                  Panel_NumberPad_Show(true, toInt64(0, exchangeCount), 0, dialogExchangeCountSet)
                  return
                end
              end
            end
          end
          clickDialogButtonReq()
        end
      end
    end
  else
    local dialogButton = dialogData:getDialogButtonAt(index)
    local linkType = dialogButton._linkType
    if UI_BTN_TYPE.eDialogButton_CutScene == dialogButton._dialogButtonType and UI_DS.eDialogState_Talk == tostring(linkType) then
      FGlobal_SetIsCutScenePlay(true)
    end
    HandleClickedDialogButton_ShowData(index)
  end
end
function ExchangeItem_HaveCount(itemKey)
  local selfProxy = getSelfPlayer():get()
  if nil == selfProxy then
    return
  end
  local itemCount = 0
  local inventory = selfProxy:getInventory()
  local invenUseSize = getSelfPlayer():get():getInventorySlotCount(true)
  local useStartSlot = inventorySlotNoUserStart()
  local invenSize = invenUseSize - useStartSlot
  for i = 1, invenSize - 1 do
    if not inventory:empty(i) then
      local itemWrapper = getInventoryItem(i)
      if nil ~= itemWrapper and itemKey == itemWrapper:get():getKey():getItemKey() then
        itemCount = Int64toInt32(itemWrapper:get():getCount_s64())
        return itemCount
      end
    end
  end
  return itemCount
end
function HandleClickedDialogButton_ShowData(index)
  local displayData = Dialog_getButtonDisplayData(index)
  local questInfo = questList_isClearQuest(1038, 2)
  if displayData:empty() then
    Dialog_clickDialogButtonReq(index)
    if questInfo then
      handleClickedQuestComplete = false
    elseif 10 < getSelfPlayer():get():getLevel() then
      handleClickedQuestComplete = false
    else
      handleClickedQuestComplete = true
    end
  else
    TalkPopup_SelectedIndex(index)
    TalkPopup_Show(displayData)
  end
end
function ExpirationItemCheck(itemKey)
  local selfProxy = getSelfPlayer():get()
  if nil == selfProxy then
    return
  end
  local inventory = selfProxy:getInventory()
  local invenSize = getSelfPlayer():get():getInventorySlotCount(true)
  for i = 1, invenSize - 1 do
    if not inventory:empty(i) then
      local itemWrapper = getInventoryItem(i)
      if nil ~= itemWrapper and itemKey == itemWrapper:get():getKey():getItemKey() then
        local itemExpiration = itemWrapper:getExpirationDate()
        if nil ~= itemExpiration and false == itemExpiration:isIndefinite() then
          local remainTime = Int64toInt32(getLeftSecond_s64(itemExpiration))
          if remainTime <= 0 then
            return true
          end
        end
      end
    end
  end
  return false
end
function FGlobal_HideDialog()
  if Panel_Win_System:GetShow() then
    return
  end
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return
  end
  local selfPlayer = selfPlayerWrapper:get()
  if nil == selfPlayer then
    return
  end
  local currentRegionKeyRaw = selfPlayerWrapper:getRegionKeyRaw()
  if 1 == selfPlayer:getLevel() and 10 == currentRegionKeyRaw and nil == dialog_getTalker() and false == questList_isClearQuest(21117, 1) and false == questList_hasProgressQuest(21117, 1) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TUTIRIAL_DIALOGCLOSEALERT"))
    return
  end
  Auto_NotifyChangeDialog()
  dialogShowCheck_Once = false
  ToClient_PopDialogueFlush()
  FromClient_WarehouseUpdate()
  Dialog_PageButton_Init()
  inventory_FlushRestoreFunc()
  handleClickedQuestComplete = false
  PaGlobal_ExtractionResult:setHide()
  if selfPlayer:getLevel() < 5 and false == _ContentsGroup_RenewUI_Chatting then
    Panel_Chat0:SetShow(false)
  end
  FGlobal_NewLocalWar_Show()
  PaGlobal_TutorialManager:handleAfterAndPopFlush()
  FGlobal_RemoteControl_Hide()
  FGlobal_RemoteControl_Show(1)
  RemoteControl_Interaction_ShowToggloe(true)
  if true == Panel_TranslationReport:GetShow() then
    TranslationReport_Close()
  end
  ToClient_SetFilterType(0, false)
  for index = 0, 3 do
    _uiFilterRadioButton[index]:SetShow(false)
    _uiFilterRadioButton[index]:SetCheck(0 == index)
  end
  if Panel_IngameCashShop_EasyPayment:GetShow() then
    if Panel_IngameCashShop_BuyOrGift:GetShow() then
      local couponOpen = Panel_IngameCashShop_Coupon:GetShow()
      InGameShopBuy_Close(couponOpen)
    end
    PaGlobal_EasyBuy_Close()
  end
  PaGlobal_LocalQuestAlert_AlertOpen()
end
function setIgnoreShowDialog(ignoreShowDialog)
  _ignoreShowDialog = ignoreShowDialog
end
function dialog_CloseNpcTalk(isSetWait)
  if FGlobal_IsChecked_SkillCommand() == true then
    Panel_SkillCommand:SetShow(true)
    changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
  else
    Panel_SkillCommand:SetShow(false)
    changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
  end
  FruitageItem_HideTooltip()
  FruitageValue_ShowTooltip(false)
  Panel_Dialog_RestoreUI()
  Dialog_clickExitReq(isSetWait)
  checkHpAlertPostEvent()
  handleClickedQuestComplete = false
end
function Panel_Dialog_RestoreUI()
  SetUIMode(Defines.UIMode.eUIMode_Default)
  if Panel_Npc_Dialog:IsShow() then
    FGlobal_Dialog_renderMode:reset()
    Panel_Npc_Dialog:SetShow(false, false)
  end
  if false == _ContentsGroup_NewUI_GuildHouse_Auction_All then
    if nil ~= Panel_GuildHouse_Auction and Panel_GuildHouse_Auction:GetShow() then
      Panel_GuildHouse_Auction:SetShow(false)
    end
  elseif nil ~= Panel_GuildHouse_Auction_All and Panel_GuildHouse_Auction_All:GetShow() then
    Panel_GuildHouse_Auction_All:SetShow(false)
  end
  local questNo = getTutorialQuestNo()
  if -1 == questNo then
    setTutorialQuestNo(-1)
  elseif 0 ~= questNo then
    Tutorial_Quest(questNo)
    setTutorialQuestNo(0)
  else
    setTutorialQuestNo(-1)
  end
  Inven_FindPuzzle()
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    Panel_NewEquip_EffectLastUpdate()
  end
  if ExitStable_VehicleInfo_Off() == true then
    Panel_ServantInfo:SetShow(false)
    Panel_CarriageInfo:SetShow(false)
    ServantInventory_Close()
  end
  ExitStable_VehicleInfo_Off(false)
  handleClickedQuestComplete = false
  if FGlobal_IsChecked_SkillCommand() == true then
    Panel_SkillCommand:SetShow(true)
    changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
  else
    Panel_SkillCommand:SetShow(false)
    changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
  end
  FGlobal_RemoteControl_Hide()
  FGlobal_RemoteControl_Show(1)
  RemoteControl_Interaction_ShowToggloe(true)
end
function HandleClickedExitButton(isSetWait)
  FGlobal_Dialog_HideTutorialStartButtonList()
  QuickSlot_UpdateData()
  FGlobal_QuestWidget_CalcScrollButtonSize()
  FGlobal_QuestWidget_UpdateList()
  PaGlobal_TutorialManager:handleClickedExitButton(dialog_getTalker())
  FromClient_hideDialog(isSetWait)
  ServantInfo_Close()
  CarriageInfo_Close()
  ServantInventory_Close()
  FGlobal_RaceInfo_Hide()
  GuildServantList_Close()
  LordMenu_Hide()
  PaGlobal_MasterpieceAuction:close()
  if nil ~= PaGlobal_Barter_Close then
    PaGlobal_Barter_Close()
  end
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function HandleClickedBackButton()
  if Panel_Win_System:GetShow() then
    return
  end
  if false == _ContentsGroup_NewCloseManager and Panel_Window_Enchant:GetShow() then
    PaGlobal_Enchant:enchantClose()
  end
  if check_ShowWindow() then
    close_WindowPanelList()
  end
  if false == _ContentsGroup_NewCloseManager then
    if false == _ContentsGroup_RenewUI_Skill and Panel_Window_Skill:IsShow() then
      HandleMLUp_SkillWindow_Close()
    end
    if Panel_Window_Warehouse:IsShow() then
      Warehouse_Close()
    end
    if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= PaGlobalFunc_NPCShop_ALL_GetShow then
      if true == PaGlobalFunc_NPCShop_ALL_GetShow() then
        HandleEventLUp_NPCShop_ALL_Close(false)
      end
    elseif nil ~= Panel_Window_NpcShop and true == Panel_Window_NpcShop:IsShow() then
      NpcShop_WindowClose()
    end
    if Panel_AskKnowledge:IsShow() then
      Panel_AskKnowledge:SetShow(false)
    end
    if Panel_TerritoryAuth_Auction:IsShow() then
      TerritoryAuth_Auction_Close()
    end
    if Panel_Window_ReinforceSkill:GetShow() then
      Panel_Window_ReinforceSkill_Close()
    end
    if Panel_SkillReinforce:GetShow() then
      Panel_SkillReinforce_Close()
    end
    if Panel_Window_MasterpieceAuction:GetShow() then
      PaGlobal_MasterpieceAuction:close()
    end
  end
  if false == _ContentsGroup_RenewUI_SearchMode then
    if Panel_Dialog_Search:IsShow() then
      searchView_Close()
    end
  elseif true == PaGlobalFunc_SearchMode_IsSearchMode() then
    searchView_Close()
  end
  ToClient_SetFilterType(0, false)
  for index = 0, 3 do
    _uiFilterRadioButton[index]:SetShow(false)
    _uiFilterRadioButton[index]:SetCheck(0 == index)
  end
  BlackSpiritAd_Hide()
  _dialogIndex = 0
  Dialog_PageButton_Init()
  ReqeustDialog_retryTalk()
end
local DCCOT = CppEnums.DlgCommonConditionOperatorType
local operatorString = {
  [CppEnums.DlgCommonConditionOperatorType.Equal] = "",
  [CppEnums.DlgCommonConditionOperatorType.Large] = "<PAColor0xFFFF0000>\226\150\178<PAOldColor>",
  [CppEnums.DlgCommonConditionOperatorType.Small] = "<PAColor0xFF0000FF>\226\150\188<PAOldColor>"
}
local giftshowgap = 0.025
function FruitageItem_ShowTooltip(percent)
  local textSum = ""
  for key, value in pairs(intimacyValueBuffer) do
    if math.abs(value.giftPercent - percent) < giftshowgap or math.abs(value.giftPercent - (percent - 1)) < giftshowgap or math.abs(value.giftPercent - (percent + 1)) < giftshowgap then
      if textSum ~= "" then
        textSum = textSum .. "\n"
      end
      textSum = textSum .. value.giftName .. " : " .. value.giftDesc .. "(" .. operatorString[value.giftOperator] .. " " .. value.giftPercent * 1000 .. ")"
    end
  end
  Panel_Npc_Dialog:SetChildIndex(giftNotice, 9999)
  giftNotice:SetText(textSum)
  giftNotice:SetSize(giftNotice:GetTextSizeX() + 15, giftNotice:GetTextSizeY() + 10)
  giftNotice:SetPosX(getMousePosX() + 10)
  giftNotice:SetPosY(getMousePosY() - Panel_Npc_Dialog:GetPosY() - 35)
  giftNotice:SetShow(true)
end
function FruitageItem_HideTooltip()
  giftNotice:SetShow(false)
end
function FruitageValue_ShowTooltip(isShow)
  intimacyNoticeText:SetAutoResize(true)
  intimacyNoticeText:SetTextMode(UI_TM.eTextMode_AutoWrap)
  intimacyNoticeText:SetSize(200, 250)
  intimacyNoticeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_DIALOG_INTIMACYNOTICETEXT"))
  intimacyNotice:SetPosX(_intimacyCircularProgress:GetPosX())
  intimacyNotice:SetPosY(_intimacyCircularProgress:GetPosY() + 20)
  if isShow == true then
    intimacyNotice:SetSize(intimacyNoticeText:GetSizeX() + 20, intimacyNoticeText:GetSizeY() + 20)
    intimacyNotice:SetShow(true)
    intimacyNoticeText:SetShow(true)
  else
    intimacyNotice:SetShow(false)
    intimacyNoticeText:SetShow(false)
  end
end
local VehicleInfo_Window
function ExitStable_VehicleInfo_Off(value)
  if value == true then
    VehicleInfo_Window = value
  elseif value == false then
    VehicleInfo_Window = value
  end
  return VehicleInfo_Window
end
function FGlobal_Dialog_FindFuncButtonIndexByType(targetFuncButtonType)
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return -1
  end
  local dialogButtonCount = dialogData:getFuncButtonCount()
  for index = 0, dialogButtonCount - 1 do
    local funcButton = dialogData:getFuncButtonAt(index)
    local funcButtonType = tonumber(funcButton._param)
    if targetFuncButtonType == funcButtonType then
      return index
    end
  end
  return -1
end
function FGlobal_Dialog_GetPositionByIndex(ii)
  local Position = {
    _Return = false,
    _PosX = -1,
    _PosY = -1
  }
  if ii < 0 then
    return Position
  end
  Position._Return = true
  Position._PosX = _uiDialogButton[ii]:GetPosX()
  Position._PosY = _uiDialogButton[ii]:GetPosY()
  return Position
end
function FGlobal_Dialog_GetFuncPositionNewQuestButton()
  local Position = {
    _Return = false,
    _PosX = -1,
    _PosY = -1
  }
  local Index = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
  if -1 == Index then
    return Position
  end
  Position._Return = true
  Position._PosX = _uiFuncButton[Index]:GetPosX()
  Position._PosY = _uiFuncButton[Index]:GetPosY()
  return Position
end
function FGlobal_Dialog_FindDialogButtonIndexByType(targetFuncButtonType)
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return -1
  end
  local dialogButtonCount = dialogData:getDialogButtonCount()
  for index = 0, dialogButtonCount - 1 do
    local dialogButton = dialogData:getDialogButtonAt(index)
    local dialogButtonType = tonumber(funcButton._param)
    if targetFuncButtonType == funcButtonType then
      return index
    end
  end
  return -1
end
function FGlobal_Dialog_GetDialogButtonPositionByIndex(ii)
  if ii < 0 then
    return nil
  end
  local Position = {_PosX = -1, _PosY = -1}
  Position._posX = _uiFuncButton[ii]:GetPosX()
  Position._posY = _uiFuncButton[ii]:GetPosY()
  return Position
end
function FGlobal_AddEffect_ExitButton(effectName, isLoop, offsetEffectPosX, offsetEffectPosY)
  if false == ToClient_isConsole() then
    offsetEffectPosX = _uiFuncButton[0]:GetSizeX() / 2
    offsetEffectPosY = 0
  end
  _uiButtonExit:AddEffect(effectName, isLoop, offsetEffectPosX, offsetEffectPosY)
end
function FGlobal_EraseAllEffect_ExitButton()
  _uiButtonExit:EraseAllEffect()
end
function FGlobal_AddEffect_DialogButton(buttonNo, effectName, isLoop, offsetEffectPosX, offsetEffectPosY)
  if -1 == buttonNo or nil == buttonNo then
    return
  end
  if false == ToClient_isConsole() then
    offsetEffectPosX = _uiFuncButton[0]:GetSizeX() / 2
    offsetEffectPosY = 0
  end
  _uiFuncButton[buttonNo]:AddEffect(effectName, isLoop, offsetEffectPosX, offsetEffectPosY)
end
function FGlobal_EraseAllEffect_DialogButton(buttonNo)
  if -1 == buttonNo or nil == buttonNo then
    return
  end
  _uiFuncButton[buttonNo]:EraseAllEffect()
end
function FromClient_Dialog_onScreenResize()
  local sizeX = getScreenSizeX()
  local sizeY = getScreenSizeY()
  Panel_Npc_Dialog:SetSize(sizeX, Panel_Npc_Dialog:GetSizeY())
  _uiNpcDialog:SetSize(getScreenSizeX(), _uiNpcDialog:GetSizeY())
  _scrollControl:SetSize(sizeX, sizeY)
  _uiHalfLine:SetSize(sizeX, 3)
  _uiHalfLine:SetVerticalMiddle()
  _uiHalfLine:SetPosY(78)
  Panel_Npc_Quest_Reward:SetPosY(sizeY - Panel_Npc_Quest_Reward:GetSizeY() - Panel_Npc_Dialog:GetSizeY())
  for index = 0, 3 do
    _uiDialogButton[index]:ComputePos()
    _uiNoticeNeedInfo[index]:SetPosX(sizeX / 2 + _uiDialogButton[index]:GetSizeX() / 2 + 10)
    _uiNoticeNeedInfo[index]:SetPosY(_uiDialogButton[index]:GetPosY() + 2)
    _uiNeedWpAni[index]:SetPosX(sizeX / 2 + _uiDialogButton[index]:GetSizeX() / 2 - _uiNeedWpAni[index]:GetSizeX() - 5)
    _uiNeedWpAni[index]:SetPosY(_uiDialogButton[index]:GetPosY())
  end
  _SpacebarIcon:SetSize(40, 28)
  _SpacebarIcon:SetPosX(_uiDialogButton[0]:GetPosX() + _uiDialogButton[0]:GetSizeX() - _SpacebarIcon:GetSizeX() - 5)
  _uiNextButton:ComputePos()
  _prevPageButton:SetPosX(_uiNextButton:GetPosX() - _prevPageButton:GetSizeX() * 2)
  _nextPageButton:SetPosX(_prevPageButton:GetPosX())
  _pageValue:SetPosX(_prevPageButton:GetPosX())
  InterestKnowledge_onScreenResize()
  _rBtnPosX = _uiDialogButton[0]:GetPosX() + _uiDialogButton[0]:GetSizeX() - _SpacebarIcon:GetSizeX() - 5
  _rBtnPosY = _uiDialogButton[0]:GetPosY()
  for index = 0, 3 do
    _uiFilterRadioButton[index]:ComputePos()
  end
  _buttonBlackSpiritSkillSelect:ComputePos()
end
function Panel_Dialog_EnchantHelp_Func(isOn)
  local mouse_posX = getMousePosX()
  local mouse_posY = getMousePosY()
  local panel_posX = Panel_Npc_Dialog:GetPosX()
  local panel_posY = Panel_Npc_Dialog:GetPosY()
  if isOn == true then
    _txt_EnchantHelp:SetShow(true)
    _txt_EnchantHelp_Desc:SetShow(true)
    _txt_EnchantHelp:SetAutoResize(true)
    _txt_EnchantHelp_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
    _txt_EnchantHelp_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DIALOGUE_TXT_ENCHANTHELP"))
    _txt_EnchantHelp:SetSize(_txt_EnchantHelp_Desc:GetSizeX() + 25, _txt_EnchantHelp_Desc:GetSizeY() + 22)
    _txt_EnchantHelp:SetPosX(mouse_posX - panel_posX - 200)
    _txt_EnchantHelp:SetPosY(mouse_posY - panel_posY - 80)
    _txt_EnchantHelp_Desc:SetPosX(mouse_posX - panel_posX - 190)
    _txt_EnchantHelp_Desc:SetPosY(mouse_posY - panel_posY - 80)
  else
    _txt_EnchantHelp:SetShow(false)
    _txt_EnchantHelp_Desc:SetShow(false)
    _txt_EnchantHelp:SetSize(250, 60)
    _txt_EnchantHelp_Desc:SetSize(230, 40)
  end
end
function Panel_Dialog_SocketHelp_Func(isOn)
  local mouse_posX = getMousePosX()
  local mouse_posY = getMousePosY()
  local panel_posX = Panel_Npc_Dialog:GetPosX()
  local panel_posY = Panel_Npc_Dialog:GetPosY()
  if isOn == true then
    _txt_SocketHelp:SetShow(true)
    _txt_SocketHelp_Desc:SetShow(true)
    _txt_SocketHelp:SetAutoResize(true)
    _txt_SocketHelp_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
    _txt_SocketHelp_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DIALOGUE_TXT_SOCKETHELP"))
    _txt_SocketHelp:SetSize(_txt_SocketHelp_Desc:GetSizeX() + 25, _txt_SocketHelp_Desc:GetSizeY() + 22)
    _txt_SocketHelp:SetPosX(mouse_posX - panel_posX - 200)
    _txt_SocketHelp:SetPosY(mouse_posY - panel_posY - 80)
    _txt_SocketHelp_Desc:SetPosX(mouse_posX - panel_posX - 190)
    _txt_SocketHelp_Desc:SetPosY(mouse_posY - panel_posY - 80)
  else
    _txt_SocketHelp:SetShow(false)
    _txt_SocketHelp_Desc:SetShow(false)
    _txt_SocketHelp:SetSize(250, 60)
    _txt_SocketHelp_Desc:SetSize(230, 40)
  end
end
function wpHelp_Func(isOn)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local Wp = selfPlayer:getWp()
  local mouse_posX = getMousePosX()
  local mouse_posY = getMousePosY()
  local panel_posX = Panel_Npc_Dialog:GetPosX()
  local panel_posY = Panel_Npc_Dialog:GetPosY()
  if Wp < 10 and isOn == true then
    _wpHelp:SetAutoResize(true)
    _wpHelp:SetTextMode(UI_TM.eTextMode_AutoWrap)
    _wpHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DIALOGUE_TXT_WPHELP"))
    _wpHelp:SetSize(_wpHelp:GetSizeX(), _wpHelp:GetSizeY() + 5 + _wpHelp:GetTextSizeY() * 2)
    _wpHelp:SetPosX(mouse_posX - panel_posX - 25)
    _wpHelp:SetPosY(mouse_posY - panel_posY - 60)
    if isFirstShowTooltip then
      _wpHelp:SetAlpha(0)
      _wpHelp:SetFontAlpha(0)
      isFirstShowTooltip = false
    end
    local AniInfo = UIAni.AlphaAnimation(1, _wpHelp, 0, 0.2)
    _wpHelp:SetShow(true)
  else
    local aniInfo = UIAni.AlphaAnimation(0, _wpHelp, 0, 0.2)
    aniInfo:SetHideAtEnd(true)
  end
end
function getAuctionState()
  return isAuctionDialog
end
function FromClient_CloseAllPanelWhenNpcGoHome()
  if GetUIMode() == Defines.UIMode.eUIMode_Stable then
    StableFunction_Close()
  end
  if Panel_Window_WharfFunction:GetShow() then
    WharfFunction_Close()
  end
  if GetUIMode() == Defines.UIMode.eUIMode_Trade then
    closeNpcTrade_Basket()
  end
  if GetUIMode() == Defines.UIMode.eUIMode_Repair then
    if true == _ContentsGroup_RenewUI_Repair then
      PaGlobalFunc_RepairInfo_Close()
    else
      PaGlobal_Repair:repair_OpenPanel(false)
    end
  end
  if GetUIMode() == Defines.UIMode.eUIMode_Extraction then
    PaGlobal_Extraction:openPanel(false)
  end
  if GetUIMode() == Defines.UIMode.eUIMode_MentalGame then
    MentalGame_Hide()
  end
end
function Dialog_MouseToolTips(isShow, tipType, index)
  local name, desc, control
  local Wp = 0
  local playerLevel = 0
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer then
    Wp = selfPlayer:getWp()
    playerLevel = selfPlayer:get():getLevel()
  end
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local funcButton = dialogData:getFuncButtonAt(index)
  if nil == funcButton then
    return
  end
  local funcButtonType = tonumber(funcButton._param)
  if tipType == CppEnums.ContentsType.Contents_IntimacyGame then
    name = funcButton:getText() .. " (" .. funcButton:getNeedWp() .. "/" .. Wp .. ")"
    control = _uiFuncButton[index]
  else
    name = funcButton:getText()
    control = _uiFuncButton[index]
  end
  registTooltipControl(control, Panel_Tooltip_SimpleText)
  if isShow == true then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function Dialog_EtcButtonToolTips(isShow, tipType)
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "DIALOGUE_BTN_EXIT")
    control = _uiButtonExit
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NPC_DIALOG_BACK")
    control = _uiButtonBack
  end
  registTooltipControl(control, Panel_Tooltip_SimpleText)
  if isShow == true then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function extraction_Open()
  if false == Panel_Window_Extraction:GetShow() then
    PaGlobal_Extraction:openPanel(true)
  else
    PaGlobal_Extraction:openPanel(false)
  end
end
function isShowReContactDialog()
  return isReContactDialog
end
function isShowDialogFunctionQuest()
  return isDialogFunctionQuest
end
function questDialogIndex()
  return _questDialogButtonIndex
end
function isCheckExchangeItemButton(index)
  return isExchangeButtonIndex[index]
end
function exchangalbeButtonIndex()
  return _exchangalbeButtonIndex
end
local _blackSpiritButtonPos = {
  eBlackSpiritButtonType_Quest = 0,
  eBlackSpiritButtonType_Enchant = 1,
  eBlackSpiritButtonType_Socket = 2,
  eBlackSpiritButtonType_Improve = 3,
  eBlackSpiritButtonType_Count = 4
}
function ExecuteAfterDialogLoad()
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  if false == dialogData:isHaveQuest() then
    _blackSpiritButtonPos.eBlackSpiritButtonType_Enchant = 0
    _blackSpiritButtonPos.eBlackSpiritButtonType_Socket = 1
    _blackSpiritButtonPos.eBlackSpiritButtonType_Improve = 2
  else
    _blackSpiritButtonPos.eBlackSpiritButtonType_Enchant = 1
    _blackSpiritButtonPos.eBlackSpiritButtonType_Socket = 2
    _blackSpiritButtonPos.eBlackSpiritButtonType_Improve = 3
  end
  local blackSpiritUiType = getBlackSpiritUiType()
  if CppEnums.EFlush_BlackSpirit_Ui_Type.eFlush_BlackSpirit_Ui_None ~= blackSpiritUiType and true == ToClient_IsGrowStepOpen(__eGrowStep_enchant) then
    if CppEnums.EFlush_BlackSpirit_Ui_Type.eFlush_BlackSpirit_Ui_ItemEnchant == blackSpiritUiType then
      HandleClickedFuncButton(_blackSpiritButtonPos.eBlackSpiritButtonType_Enchant)
    elseif CppEnums.EFlush_BlackSpirit_Ui_Type.eFlush_BlackSpirit_Ui_Socket == blackSpiritUiType then
      HandleClickedFuncButton(_blackSpiritButtonPos.eBlackSpiritButtonType_Socket)
    elseif CppEnums.EFlush_BlackSpirit_Ui_Type.eFlush_BlackSpirit_Ui_Improve == blackSpiritUiType then
      HandleClickedFuncButton(_blackSpiritButtonPos.eBlackSpiritButtonType_Improve)
    end
  else
  end
end
function isNormalTradeMerchant()
  local talker = dialog_getTalker()
  if nil ~= talker then
    local characterKey = talker:getCharacterKey()
    local npcData = getNpcInfoByCharacterKeyRaw(characterKey, talker:get():getDialogIndex())
    if nil ~= npcData then
      return npcData:hasSpawnType(CppEnums.SpawnType.eSpawnType_TradeMerchant)
    end
  end
  return false
end
function isQuestComplete()
  return _isQuestComplete
end
function FGlobal_CloseNpcDialogForDetail()
  if getCustomizingManager():isShow() then
    HandleClicked_CloseIngameCustomization()
    return true
  end
  if Panel_Npc_Trade_Market:IsShow() then
    closeNpcTrade_Basket()
    return true
  end
  if Panel_Window_StableFunction:IsShow() then
    StableFunction_Close()
    return true
  end
  if Panel_Window_Extraction:IsShow() then
    PaGlobal_Extraction:openPanel(false)
    retval = true
  end
  if Panel_FixEquip:GetShow() then
    handleMClickedRepairExitButton()
    PaGlobal_Repair:repair_OpenPanel(false)
    Panel_FixEquip:SetShow(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
  end
  if Panel_Window_Repair:IsShow() and false == PaGlobal_Camp:getIsCamping() then
    Panel_FixEquip:SetShow(false)
    PaGlobal_Repair:repair_OpenPanel(false)
    return true
  end
  if Panel_Window_GuildStableFunction:IsShow() then
    GuildStableFunction_Close()
    return true
  end
  if PaGlobalFunc_ItemMarketFunction_GetShow() then
    FGolbal_ItemMarket_Function_Close()
    if PaGlobalFunc_ItemMarketRegistItem_GetShow() then
      FGlobal_ItemMarketRegistItem_Close()
    end
    if PaGlobalFunc_ItemMarketBuyConfirm_GetShow() then
      FGlobal_ItemMarket_BuyConfirm_Close()
      return true
    end
    if PaGlobalFunc_ItemMarketItemSet_GetShow() then
      FGlobal_ItemMarketItemSet_Close()
    end
    if PaGlobalFunc_ItemMarket_GetShow() then
      FGolbal_ItemMarketNew_Close()
    end
    return true
  end
  if true == _ContentsGroup_RenewUI_ItemMarketPlace and true == PaGlobalFunc_MarketPlace_Function_GetShow() then
    PaGlobalFunc_MarketPlace_Function_Close()
  end
  if Panel_Window_WharfFunction:GetShow() then
    WharfFunction_Close()
    return true
  end
  if Panel_Window_GuildWharfFunction:GetShow() then
    GuildWharfFunction_Close()
    return true
  end
  if Panel_FixEquip:GetShow() then
    FixEquip_Close()
    return true
  end
  if Panel_Knowledge_Main:GetShow() then
    Panel_Knowledge_Hide()
    return true
  end
  if false == _ContentsGroup_RenewUI_Dyeing and Panel_DyeNew_CharacterController:GetShow() then
    FGlobal_Panel_DyeReNew_Hide()
    return true
  end
  if Panel_CustomizationMain:GetShow() then
    IngameCustomize_Hide()
    return true
  end
  return false
end
registerEvent("FromClient_ShowDialog", "FromClient_ShowDialog")
registerEvent("FromClient_HideDialog", "HandleClickedExitButton")
registerEvent("FromClient_CloseNpcTalkForDead", "FGlobal_HideDialog")
registerEvent("FromClient_CloseNpcTradeMarketTalkForDead", "FGlobal_CloseNpcDialogForDetail")
registerEvent("FromClient_CloseAllPanelWhenNpcGoHome", "FromClient_CloseAllPanelWhenNpcGoHome")
registerEvent("FromClient_ShowFilterButton", "FromClient_ShowFilterButton")
registerEvent("FromClient_VaryIntimacy_Dialog", "FromClient_VaryIntimacy_Dialog")
registerEvent("onScreenResize", "FromClient_Dialog_onScreenResize")
function RenderMode_DialogListClose()
  FGlobal_CloseNpcDialogForDetail()
  Panel_Npc_Dialog:SetShow(true)
  FGlobal_HideDialog(true)
end
function proRenderModeSet()
  dialogShowCheck_Once = true
end
function FromClient_CloseDialogByAttacked()
  FGlobal_Dialog_renderMode:reset()
end
FGlobal_Dialog_renderMode:setPrefunctor(renderMode, proRenderModeSet)
FGlobal_Dialog_renderMode:setClosefunctor(renderMode, RenderMode_DialogListClose)
registerEvent("progressEventCancelByAttacked", "FromClient_CloseDialogByAttacked")
function isVisibleButton(buttonValue)
  local dialogData = ToClient_GetCurrentDialogData()
  if dialogData ~= nil then
    local dialogButtonCount = dialogData:getDialogButtonCount()
    for i = _dialogIndex, dialogButtonCount - 1 do
      local dialogButton = dialogData:getDialogButtonAt(i)
      if dialogButton ~= nil and buttonValue == tostring(dialogButton._linkType) then
        return true
      end
    end
  end
  return false
end
function isVisibleAcceptButton()
  return isVisibleButton(UI_DS.eDialogState_AcceptQuest)
end
function isVisibleRecontactButton()
  return isVisibleButton(UI_DS.eDialogState_ReContact)
end
function isVisibleTalkButton()
  return isVisibleButton(UI_DS.eDialogState_Talk)
end
function isVisibleDisplayQuestButton()
  return isVisibleButton(UI_DS.eDialogState_DisplayQuest)
end
function isVisibleProgressButton()
  return isVisibleButton(UI_DS.eDialogState_ProgressQuest)
end
function isNextButtonShow()
  if _uiNextButton ~= nil then
    return _uiNextButton:GetShow()
  end
  return false
end
function PaGlobal_SetProposeToNpc()
  local dialog = ToClient_getNpcProposeTalk()
  if "" ~= dialog then
    _mainDialog = {}
    local stringList = string.split(dialog, "\n")
    local i = 0
    local strFirst, strSecond
    while true do
      strFirst = stringList[i * 2 + 1]
      strSecond = stringList[i * 2 + 2]
      if strFirst ~= nil and strSecond ~= nil then
        _mainDialog[i] = strFirst .. "\n" .. strSecond
      elseif strFirst == nil then
        break
      elseif strSecond == nil then
        _mainDialog[i] = strFirst
        break
      end
      i = i + 1
    end
    _maxLine = #_mainDialog
    Dialog_updateMainDialog()
  end
end
