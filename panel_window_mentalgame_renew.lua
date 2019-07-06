local Window_MentalGameInfo = {
  _ui = {
    _static_LeftBg = UI.getChildControl(Panel_Window_MentalGame, "LeftBG"),
    _static_BottomBg = UI.getChildControl(Panel_Window_MentalGame, "BottomBG"),
    _static_keyGuide = UI.getChildControl(Panel_Window_MentalGame, "Static_Key_Guide"),
    _static_TopBg = UI.getChildControl(Panel_Window_MentalGame, "TopBG"),
    _staticText_addInterest = UI.getChildControl(Panel_Window_MentalGame, "StaticText_AddInterest"),
    _top = {},
    _static_Finished = UI.getChildControl(Panel_Window_MentalGame_Finish, "Static_Finish"),
    _staticText_Finished = UI.getChildControl(Panel_Window_MentalGame_Finish, "StaticText_Finish"),
    _left = {},
    _bottom = {},
    _tooltip = {
      _stc_topBG = UI.getChildControl(Panel_Window_MentalGame_Tooltip, "Static_TopBG"),
      _stc_centerBG = UI.getChildControl(Panel_Window_MentalGame_Tooltip, "Static_CenterBG"),
      _stc_bottomBG = UI.getChildControl(Panel_Window_MentalGame_Tooltip, "Static_BottomBG")
    },
    _static_Zodiac = {}
  },
  _config = {
    _interestValueMax = 1000,
    _slotCountMax = 10,
    _hideTime = 5,
    _maxPlayCount = 3,
    _gameStep_CardSelect = 0,
    _gameStep_StartGame = 1,
    _gameStep_ReadyGame = 2,
    _gameStep_EndGame = 3,
    _gameStep_GameExit = 4,
    _defaultScale = 0.7
  },
  _configStr = {
    _buffTypeString = {
      [0] = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_BUFFTYPE_FAVOR"),
      [1] = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_BUFFTYPE_INTERESTING"),
      [2] = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_BUFFTYPE_DEMANDINGINTERESTING"),
      [3] = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_BUFFTYPE_DEMANDINGFAVOR")
    },
    _operatorString = {
      [CppEnums.DlgCommonConditionOperatorType.Equal] = "",
      [CppEnums.DlgCommonConditionOperatorType.Large] = "<PAColor0xFFFF0000>\226\150\178<PAOldColor>",
      [CppEnums.DlgCommonConditionOperatorType.Small] = "<PAColor0xFF0000FF>\226\150\188<PAOldColor>"
    },
    _hasMentalCardText = PAGetString(Defines.StringSheet_GAME, "LUA_INTIMACY_INFORMATION_HASMENTALCARD"),
    _hasntMentalCardText = PAGetString(Defines.StringSheet_GAME, "LUA_INTIMACY_INFORMATION_HASNTMENTALCARD")
  },
  _configUV = {
    _intimacyIcon = {
      [0] = {
        [0] = {
          texture = "Renewal/UI_Icon/Console_Icon_00.dds",
          x1 = 38,
          y1 = 200,
          x2 = 65,
          y2 = 227
        },
        [1] = {
          texture = "Renewal/UI_Icon/Console_Icon_00.dds",
          x1 = 94,
          y1 = 200,
          x2 = 121,
          y2 = 227
        },
        [2] = {
          texture = "Renewal/UI_Icon/Console_Icon_00.dds",
          x1 = 66,
          y1 = 200,
          x2 = 93,
          y2 = 227
        }
      },
      [1] = {
        texture = "Renewal/UI_Icon/Console_Icon_00.dds",
        x1 = 150,
        y1 = 200,
        x2 = 177,
        y2 = 227
      },
      [2] = {
        texture = "Renewal/UI_Icon/Console_Icon_00.dds",
        x1 = 122,
        y1 = 200,
        x2 = 149,
        y2 = 227
      },
      [3] = {
        texture = "Renewal/UI_Icon/Console_Icon_00.dds",
        x1 = 178,
        y1 = 200,
        x2 = 205,
        y2 = 227
      },
      [4] = {
        texture = "Renewal/UI_Icon/Console_Icon_00.dds",
        x1 = 231,
        y1 = 1,
        x2 = 253,
        y2 = 23
      },
      [5] = {
        texture = "Renewal/UI_Icon/Console_Icon_00.dds",
        x1 = 231,
        y1 = 24,
        x2 = 205,
        y2 = 227
      }
    }
  },
  _gameStep = 0,
  _gamePlayCount = 0,
  _bestPoint = 0,
  _addIntimacy = 0,
  _renderMode = RenderModeWrapper.new(100, {
    Defines.RenderMode.eRenderMode_MentalGame
  }, false),
  _rewardIconTable = {},
  _rewardTextTable = {},
  _rewardToolTipDescTable = {},
  _selectCardTemplete = {},
  _bottomCardTemplete = {},
  _selectCardTable = {},
  _circleKeyList = {},
  _infomationUIList = {},
  _animationUIList = {},
  _animationList = {},
  _animationIndex = 0,
  _bottomCardList = {},
  _bottomCardInfoList = {},
  _mentalObject,
  _scrollPositionResult = 0,
  _scrollPosition = -5,
  _selectCardIndex = -1,
  _overKey = -1,
  _hideTime = 0
}
function Window_MentalGameInfo:Clear()
  self._gameStep = 0
  self._gamePlayCount = 0
  self._addIntimacy = 0
  self._scrollPositionResult = 0
  self._scrollPosition = -5
  self._hideTime = 0
  self._overKey = -1
  for _, control in pairs(self._rewardIconTable) do
    if nil ~= control then
      control:SetShow(false)
    end
  end
  for _, control in pairs(self._rewardTextTable) do
    if nil ~= control then
      control:SetShow(false)
    end
  end
  for _, control in pairs(self._selectCardTable) do
    if nil ~= control then
      control._static_Bg:SetShow(false)
    end
  end
  for _, control in pairs(self._bottomCardList) do
    if nil ~= control then
      control._static_CardIcon:SetShow(false)
      control._staticText_CardText:SetShow(false)
    end
  end
  for _, control in pairs(self._bottomCardList) do
    if nil ~= control then
      control._static_CardIcon:SetShow(false)
      control._staticText_CardText:SetShow(false)
    end
  end
  for _, from in pairs(self._animationUIList) do
    if nil ~= from then
      for __, to in pairs(from) do
        if nil ~= to then
          to._pointImage:SetShow(false)
          to._nameTag:SetShow(false)
        end
      end
    end
  end
  for _, from in pairs(self._infomationUIList) do
    if nil ~= from then
      for __, to in pairs(from) do
        if nil ~= to then
          to._pointImage:SetShow(false)
          to._nameTag:SetShow(false)
        end
      end
    end
  end
  self._ui._static_Zodiac._control:SetShow(false)
  self:CircleLineAndObjectClear()
end
function Window_MentalGameInfo:StageClear()
  for value, control in pairs(self._selectCardTable) do
    control._circularProgress_Progress:SetCurrentControlPos(0)
    control._circularProgress_Progress:SetProgressRate(0)
    control._static_Success:ResetVertexAni()
    control._static_Success:SetShow(false)
    control._static_Failed:ResetVertexAni()
    control._static_Failed:SetShow(false)
  end
end
function Window_MentalGameInfo:UpdateStageInfo()
end
function Window_MentalGameInfo:Initialize()
  self._bottomCardList = {}
  self:InitRegister()
  self:InitControl()
  self:InitEvent()
  self:XB_Control_Init()
  PaGlobalFunc_MentalGame_ScreenResize()
end
function Window_MentalGameInfo:UpdateBottomUIPos(deltaTime)
  local diff = self._scrollPositionResult - self._scrollPosition
  local rightArrow = self._ui._bottom._button_RightArrow
  local leftArrow = self._ui._bottom._button_LeftArrow
  if 0 == diff then
    return
  end
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  self._scrollPosition = self._scrollPosition + diff * math.min(deltaTime * 8, 1)
  if math.abs(self._scrollPositionResult - self._scrollPosition) < 0.05 then
    self._scrollPosition = self._scrollPositionResult
  end
  local isIgnore = self._scrollPosition ~= self._scrollPositionResult
  for index, value in pairs(self._bottomCardList) do
    local text = value._staticText_CardText
    local icon = value._static_CardIcon
    local selectBg = value._static_SelectBg
    if nil ~= text and nil ~= icon then
      icon:SetIgnore(isIgnore)
      local posIndex = index - self._scrollPosition
      local position = mentalObject:getCirclePosition(float2((leftArrow:GetPosX() + rightArrow:GetPosX() + (leftArrow:GetSizeX() + rightArrow:GetSizeX()) / 2) / 2, leftArrow:GetPosY() + leftArrow:GetSizeY() / 2 + 320), 400, posIndex - 2)
      text:SetPosX(position.x - text:GetSizeX() / 2)
      text:SetPosY(position.y - text:GetSizeY() / 2)
      if posIndex >= -0.25 and posIndex <= 4.25 then
        text:SetShow(true)
        text:SetAlphaExtraChild(1)
        icon:SetShow(true)
        icon:SetAlphaExtraChild(1)
      elseif posIndex >= -0.75 and posIndex < -0.25 then
        text:SetShow(true)
        text:SetAlphaExtraChild((posIndex + 0.75) * 2)
        icon:SetShow(true)
        icon:SetAlphaExtraChild((posIndex + 0.75) * 2)
      elseif posIndex > 4.25 and posIndex <= 4.75 then
        text:SetShow(true)
        text:SetAlphaExtraChild((4.75 - posIndex) * 2)
        icon:SetShow(true)
        icon:SetAlphaExtraChild((4.75 - posIndex) * 2)
      else
        text:SetShow(false)
        icon:SetShow(false)
        selectBg:SetShow(false)
      end
      local txtPosY = text:GetPosY() - 10
      text:SetPosY(txtPosY)
      icon:SetPosX(text:GetPosX())
      icon:SetPosY(txtPosY - 80)
      selectBg:SetPosX(icon:GetPosX() + 5)
      selectBg:SetPosY(icon:GetPosY() + 3)
    end
  end
end
function PaGlobalFunc_MentalGame_UpdateHideTime(deltaTime)
  local self = Window_MentalGameInfo
  if self._config._gameStep_GameExit == self._gameStep then
    self._hideTime = self._hideTime + deltaTime
    if self._config._hideTime < self._hideTime then
      PaGlobalFunc_MentalGame_Close()
    end
  end
end
function PaGlobalFunc_MentalGame_BaseUpdatePerFrame(deltaTime)
  local self = Window_MentalGameInfo
  self:SetSelectCardPos()
  self:UpdateAnimationList(deltaTime)
  PaGlobalFunc_MentalGame_UpdateHideTime(deltaTime)
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local yawpitchroll = mentalObject:getYawPitchRoll()
  local zodiac = self._ui._static_Zodiac
  zodiac._panel:Set3DRotationX(yawpitchroll.x)
  zodiac._panel:Set3DRotationY(yawpitchroll.y)
  zodiac._panel:Set3DRotationZ(yawpitchroll.z)
  zodiac._panel:SetWorldPosX(mentalObject:getCardPos().x)
  zodiac._panel:SetWorldPosY(mentalObject:getCardPos().y)
  zodiac._panel:SetWorldPosZ(mentalObject:getCardPos().z)
  zodiac._panel:SetScale(mentalObject:getScale() * self._config._defaultScale, mentalObject:getScale() * self._config._defaultScale)
  zodiac._control:SetScale(mentalObject:getScale() * self._config._defaultScale, mentalObject:getScale() * self._config._defaultScale)
  self:UpdateBottomUIPos(deltaTime)
end
function Window_MentalGameInfo:InitEvent()
  Panel_Window_MentalGame:RegisterUpdateFunc("PaGlobalFunc_MentalGame_BaseUpdatePerFrame")
  self._ui._bottom._button_RightArrow:addInputEvent("Mouse_LUp", "PaGlobalFunc_MentalGame_LClick_Arrow(false)")
  self._ui._bottom._button_LeftArrow:addInputEvent("Mouse_LUp", "PaGlobalFunc_MentalGame_LClick_Arrow(true)")
  self._ui._button_Back:addInputEvent("Mouse_LUp", "PaGlobalFunc_MentalGame_LClick_Back()")
  self._ui._button_Select:addInputEvent("Mouse_LUp", "PaGlobalFunc_MentalGame_LClick_SlectCard()")
  self._ui._button_Clear:addInputEvent("Mouse_LDown", "PaGlobalFunc_MentalGame_SelectClear()")
end
function PaGlobalFunc_MentalGame_SelectClear()
  local self = Window_MentalGameInfo
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  for index = 0, #self._selectCardTable do
    RequestMentalGame_clearSelectCard(index)
    if mentalObject:getCardBySlotIndex(index) ~= nil then
      _AudioPostEvent_SystemUiForXBOX(0, 2)
    end
  end
end
function PaGlobalFunc_MentalGame_LClick_Back()
  local self = Window_MentalGameInfo
  local mentalStage = RequestMentalGame_getMentalStage()
  if true == mentalStage._isSuccess then
    self:SetGameStep(self._config._gameStep_GameExit)
  else
    PaGlobalFunc_MentalGame_Close()
  end
end
function PaGlobalFunc_MentalGame_LClick_SlectCard()
end
function PaGlobalFunc_MentalGame_LClick_StartGame()
  local self = Window_MentalGameInfo
  local mentalObject = getMentalgameObject()
  if nil == mentalObject or self._config._gameStep_ReadyGame ~= self._gameStep then
    return
  end
  self:SetGameStep(self._config._gameStep_StartGame)
  self._selectCardTable[mentalObject:getOrder(0)]._circularProgress_Progress:SetProgressRate(100)
  RequestMentalGame_startCard()
end
function PaGlobalFunc_MentalGame_Restart()
  local self = Window_MentalGameInfo
  self._gameStep = 0
  self._gamePlayCount = self._gamePlayCount + 1
  self._bestPoint = 0
  self._scrollPositionResult = 0
  self._scrollPosition = -5
  self._selectCardIndex = -1
  self:StageClear()
  self:Update()
  RequestMentalGame_restartCard()
end
function PaGlobalFunc_MentalGame_LClick_Arrow(isleft)
  local self = Window_MentalGameInfo
  local mentalObject = getMentalgameObject()
  if nil == mentalObject or self._config._gameStep_CardSelect ~= self._gameStep then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  if true == isleft then
    local maxValue = mentalObject:getCardCount() - 5
    self._scrollPositionResult = math.min(self._scrollPositionResult + 5, maxValue)
  else
    local totalCard = mentalObject:getCardCount()
    self._scrollPositionResult = math.max(self._scrollPositionResult - 5, 0)
  end
  self:UpdateCardScrollButton()
end
function Window_MentalGameInfo:UpdateCardScrollButton()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local maxValue = mentalObject:getCardCount() - 5
  local totalCard = mentalObject:getCardCount()
  if totalCard <= 4 then
    self._ui._bottom._button_LeftArrow:SetShow(false)
    self._ui._bottom._button_RightArrow:SetShow(false)
    return
  end
  self._ui._bottom._button_LeftArrow:SetShow(maxValue > self._scrollPositionResult)
  self._ui._bottom._button_RightArrow:SetShow(self._scrollPositionResult > 0)
end
function Window_MentalGameInfo:InitControl()
  local left = self._ui._left
  local bottom = self._ui._bottom
  left._staticIcon_Type = UI.getChildControl(self._ui._static_LeftBg, "StaticText_TypeIcon")
  left._staticText_Name = UI.getChildControl(self._ui._static_LeftBg, "StaticText_Name")
  left._staticText_Mission = UI.getChildControl(self._ui._static_LeftBg, "StaticText_Mission")
  left._staticText_Tip = UI.getChildControl(self._ui._static_LeftBg, "StaticText_Tip")
  left._static_CircularProgressBg = UI.getChildControl(self._ui._static_LeftBg, "Static_CircularProgress_BG")
  left._circularProgress_IntimacyPoint = UI.getChildControl(self._ui._static_LeftBg, "CircularProgress_Friend_Point")
  left._staticText_IntimacyPoint = UI.getChildControl(left._static_CircularProgressBg, "StaticText_CurrentIntimacyPoint")
  left._staticText_Interest = UI.getChildControl(self._ui._static_LeftBg, "StaticText_Interest")
  left._staticText_Impression = UI.getChildControl(self._ui._static_LeftBg, "StaticText_Impression")
  left._static_RewardIcon = UI.getChildControl(left._static_CircularProgressBg, "Static_RewardIcon")
  left._static_RewardIcon:SetShow(false)
  left._static_RewardText = UI.getChildControl(left._static_CircularProgressBg, "StaticText_Reward")
  left._static_RewardText:SetShow(false)
  bottom._button_RightArrow = UI.getChildControl(self._ui._static_BottomBg, "Button_RightArrow")
  bottom._button_LeftArrow = UI.getChildControl(self._ui._static_BottomBg, "Button_LeftArrow")
  bottom._button_RB = UI.getChildControl(bottom._button_RightArrow, "Static_RB")
  bottom._button_LB = UI.getChildControl(bottom._button_LeftArrow, "Static_LB")
  if _ContentsGroup_isConsolePadControl then
    bottom._button_RB:SetShow(true)
    bottom._button_LB:SetShow(true)
  end
  self._ui._button_Back = UI.getChildControl(self._ui._static_keyGuide, "Button_Key_Guide_Back")
  self._ui._button_Select = UI.getChildControl(self._ui._static_keyGuide, "Button_Key_Guide_Select")
  self._ui._button_Restart = UI.getChildControl(self._ui._static_keyGuide, "Button_Key_Guide_Restart")
  self._ui._button_Clear = UI.getChildControl(self._ui._static_keyGuide, "Button_Key_Guide_Clear")
  self._ui._staticText_addInterest:SetShow(false)
  self._ui._top._staticText_CommentTitle = UI.getChildControl(self._ui._static_TopBg, "StaticText_Comment_1")
  self._ui._top._staticText_CommentTitle:SetTextHorizonCenter()
  self._ui._top._staticText_CommentDesc = UI.getChildControl(self._ui._static_TopBg, "StaticText_Comment_2")
  self._ui._top._staticText_CommentDesc:SetAutoResize(true)
  self._ui._top._staticText_CommentDesc:SetTextHorizonCenter()
  self._ui._staitcText_NpcName = UI.getChildControl(Panel_Window_MentalGame_Tooltip, "StaticText_NPC_Name")
  self._ui._staticText_StatusTitle = UI.getChildControl(self._ui._tooltip._stc_topBG, "StaticText_StatusTitle")
  self._ui._staticText_HitBase = UI.getChildControl(self._ui._tooltip._stc_topBG, "StaticText_Hit_Base")
  self._ui._staticText_HitBonus = UI.getChildControl(self._ui._tooltip._stc_topBG, "StaticText_Hit_Bonus")
  self._ui._staticText_DDBase = UI.getChildControl(self._ui._tooltip._stc_topBG, "StaticText_DD_Base")
  self._ui._staticText_DDBonus = UI.getChildControl(self._ui._tooltip._stc_topBG, "StaticText_DD_Bonus")
  self._ui._staticText_InterestComment = UI.getChildControl(self._ui._tooltip._stc_centerBG, "StaticText_Comment_1")
  self._ui._staticText_FavorityComment = UI.getChildControl(self._ui._tooltip._stc_centerBG, "StaticText_Comment_2")
  self._ui._staticText_Bonus = UI.getChildControl(self._ui._tooltip._stc_bottomBG, "StaticText_Bonus")
  self._ui._staitcText_NpcName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._staticText_Bonus:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._bottomCardTemplete._static_CardBg = UI.getChildControl(self._ui._static_BottomBg, "Static_CircleBG")
  self._bottomCardTemplete._static_CardIcon = UI.getChildControl(self._ui._static_BottomBg, "Static_MentalIcon_C_0")
  self._bottomCardTemplete._staticText_CardText = UI.getChildControl(self._ui._static_BottomBg, "StaticText_MentalTxt_C_0")
  self._bottomCardTemplete._static_SelectBg = UI.getChildControl(self._ui._static_BottomBg, "Static_Selected_Npc")
  self._bottomCardTemplete._staticText_CardText:SetTextHorizonCenter()
  self._bottomCardTemplete._staticText_CardText:SetTextVerticalTop()
  self._selectCardTemplete._static_Bg = UI.getChildControl(Panel_Window_MentalGame, "SelectCardTemplete")
  self._selectCardTemplete._circularProgress_Progress = UI.getChildControl(self._selectCardTemplete._static_Bg, "CircularProgress_Progress")
  self._selectCardTemplete._static_Success = UI.getChildControl(self._selectCardTemplete._static_Bg, "Static_Success")
  self._selectCardTemplete._static_Failed = UI.getChildControl(self._selectCardTemplete._static_Bg, "Static_Failed")
  self._selectCardTemplete._static_Bg:SetShow(false)
  self._bottomCardTemplete._static_SelectBg:SetShow(false)
  self._ui._static_Zodiac._panel = UI.createOtherPanel("ZodiacCenterPanel", CppEnums.OtherListType.OtherPanelType_Wiki)
  self._ui._static_Zodiac._control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._static_Zodiac._panel, "ZodiacCenterPanelImage")
  self._ui._static_Zodiac._panel:SetShow(true)
  self._ui._static_Zodiac._control:SetShow(true)
  local zodiac = self._ui._static_Zodiac
  if nil ~= zodiac._panel then
    zodiac._panel:SetAlpha(0)
    zodiac._panel:SetSize(600, 600)
    zodiac._panel:Set3DRenderType(3)
    zodiac._panel:SetDepth(0)
    zodiac._panel:SetIgnore(true)
    zodiac._panel:SetShow(true, false)
    zodiac._control:SetPosX(0)
    zodiac._control:SetPosY(0)
    zodiac._control:SetSize(600, 600)
    zodiac._control:SetAlpha(1)
    zodiac._control:SetVerticalMiddle()
    zodiac._control:SetHorizonCenter()
    zodiac._control:SetIgnore(true)
    zodiac._control:SetShow(true)
  end
  self._renderMode:setPrefunctor(self._renderMode, PaGlobalFunc_MentalGame_PreRenderMode)
  self._renderMode:setClosefunctor(self._renderMode, PaGlobalFunc_MentalGame_HideByDead)
  PaGlobalFunc_MentalGame_SetAlignGuide()
end
function PaGlobalFunc_MentalGame_SetAlignGuide()
  local self = Window_MentalGameInfo
  local tempBtnGroup = {
    self._ui._button_Back,
    self._ui._button_Select,
    self._ui._button_Clear,
    self._ui._button_Restart
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui._static_keyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_LEFT)
end
function PaGlobalFunc_MentalGame_PreRenderMode()
end
function Window_MentalGameInfo:SetGameStep(gameStep)
  self._gameStep = gameStep
  self:UpdateStageByStep()
end
function Window_MentalGameInfo:SetCircleLineAndObject()
  MentalKnowledgeBase.init()
  MentalKnowledgeBase.circleSize = 25 * self._config._defaultScale
  MentalKnowledgeBase.color = float4(1, 1, 1, 1)
  MentalKnowledgeBase.lineWidth = 1.5
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local basePos = mentalObject:getCardPos()
  local slotCount = mentalObject:getSlotCount()
  local pointCount = mentalObject:getPointCount()
  local orderCount = mentalObject:getOrderCount()
  for index = 0, pointCount - 1 do
    local starPos = mentalObject:getPoint(index)
    local float3Pos = Util.Math.AddVectorToVector(basePos, starPos)
    local circleKey = MentalKnowledgeBase.InsertCircle(float3Pos, 1)
    self._circleKeyList[index] = circleKey
  end
  local lineCount = mentalObject:getLineCount()
  for index = 0, lineCount - 1 do
    local firstIndex = mentalObject:getLineFirst(index)
    local secondIndex = mentalObject:getLineSecond(index)
    MentalKnowledgeBase.InsertLineByCircle(self._circleKeyList[firstIndex], self._circleKeyList[secondIndex])
  end
  MentalKnowledgeBase.usingEndArrow = true
  MentalKnowledgeBase.arrowLineWidth = 9
  MentalKnowledgeBase.lineWidth = 20
  MentalKnowledgeBase.color = float4(0.11764705882352941, 0.8196078431372549, 0.9921568627450981, 0.3)
  MentalKnowledgeBase.arrowColor = float4(0.11764705882352941, 0.8196078431372549, 0.9921568627450981, 0.3)
  for srcSlot = 0, orderCount - 2 do
    for dstSlot = srcSlot + 1, orderCount - 1 do
      local srcIndex = mentalObject:getOrder(srcSlot)
      local dstIndex = mentalObject:getOrder(dstSlot)
      if -1 ~= srcIndex and -1 ~= dstIndex then
        local isApplied = mentalObject:isAppliedEffect(srcSlot, dstSlot)
        local card = mentalObject:getCardBySlotIndex(srcIndex)
        if true == isApplied then
          MentalKnowledgeBase.InsertLineByCircle(self._circleKeyList[srcIndex], self._circleKeyList[dstIndex])
        end
      end
    end
  end
  MentalKnowledgeBase.lineWidth = 4
  MentalKnowledgeBase.arrowLineWidth = 4
  MentalKnowledgeBase.color = float4(0.83, 0.79, 0.54, 1)
  MentalKnowledgeBase.arrowColor = float4(0.83, 0.79, 0.54, 1)
  local prevIndex = -1
  for srcIndex = 0, orderCount - 1 do
    if nil ~= mentalObject:getCardBySlotOrder(srcIndex) then
      local currIndex = srcIndex
      if prevIndex > -1 then
        local slotNumberSrc = mentalObject:getOrder(prevIndex)
        local slotNumberDst = mentalObject:getOrder(currIndex)
        MentalKnowledgeBase.InsertLineByCircle(self._circleKeyList[slotNumberSrc], self._circleKeyList[slotNumberDst])
      end
      prevIndex = currIndex
    end
  end
  MentalKnowledgeBase.UpdateLineAndCircle()
end
function Window_MentalGameInfo:CircleLineAndObjectClear()
  self._circleKeyList = {}
  MentalKnowledgeBase.ClearLineAndCircle()
end
function Window_MentalGameInfo:SetBottomCardList()
  local UCT = CppEnums.PA_UI_CONTROL_TYPE
  local index = 0
  local PrePosY = 0
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local count = mentalObject:getCardCount()
  local gap = self._bottomCardTemplete._static_CardIcon:GetSizeY() * 13 / 10
  for index = 0, count - 1 do
    local cardWrapper = mentalObject:getCard(index)
    if nil == self._bottomCardList[index] then
      self._bottomCardList[index] = {}
      local ui = {}
      ui._static_SelectBg = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self._ui._static_BottomBg, "selectIcon_" .. index)
      CopyBaseProperty(self._bottomCardTemplete._static_SelectBg, ui._static_SelectBg)
      ui._static_SelectBg:SetPosX(index * gap)
      ui._static_SelectBg:ComputePos()
      ui._static_CardIcon = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self._ui._static_BottomBg, "cardIcon_" .. index)
      CopyBaseProperty(self._bottomCardTemplete._static_CardIcon, ui._static_CardIcon)
      ui._static_CardIcon:ComputePos()
      ui._static_CardIcon:ChangeTextureInfoName(cardWrapper:getPicture())
      ui._static_CardIcon:SetVerticalTop()
      ui._static_CardIcon:SetSpanSize(0, 0 - ui._static_CardIcon:GetSizeY())
      ui._static_CardIcon:SetShow(false)
      ui._static_CardIcon:SetIgnore(false)
      if false == ToClient_isXBox() then
        ui._static_CardIcon:addInputEvent("Mouse_RUp", "PaGlobalFunc_MentalGame_RClick_BottomCard(" .. index .. " )")
      end
      ui._static_CardIcon:addInputEvent("Mouse_On", "PaGlobalFunc_MentalGame_CardOver(" .. index .. ",false,true)")
      ui._static_CardIcon:addInputEvent("Mouse_Out", "PaGlobalFunc_MentalGame_CardOver(" .. index .. ",false,false)")
      if true == mentalObject:isBanedCard(cardWrapper) or true == mentalObject:isSelectedCard(cardWrapper) then
        ui._static_CardIcon:SetColor(Defines.Color.C_FF626262)
      else
        ui._static_CardIcon:SetColor(Defines.Color.C_FFFFFFFF)
      end
      if PrePosY < ui._static_CardIcon:GetSizeY() then
        PrePosY = ui._static_CardIcon:GetSizeY()
      end
      ui._staticText_CardText = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._ui._static_BottomBg, "cardText_" .. index)
      CopyBaseProperty(self._bottomCardTemplete._staticText_CardText, ui._staticText_CardText)
      ui._staticText_CardText:ComputePos()
      ui._staticText_CardText:SetShow(true)
      ui._staticText_CardText:SetPosX(index * gap)
      ui._staticText_CardText:SetAutoResize(true)
      ui._staticText_CardText:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      ui._staticText_CardText:SetText(cardWrapper:getName())
      ui._staticText_CardText:SetVerticalBottom()
      ui._staticText_CardText:ComputePos()
      ui._static_CardIcon:ComputePos()
      self._bottomCardList[index] = ui
    end
  end
end
function Window_MentalGameInfo:SetCardColor()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local count = mentalObject:getCardCount()
  for index = 0, count - 1 do
    local cardWrapper = mentalObject:getCard(index)
    if nil == self._bottomCardList[index] or nil == self._bottomCardList[index]._static_CardIcon or nil == self._bottomCardList[index]._static_CardText then
      return
    end
    local iconUI = self._bottomCardList[index]._static_CardIcon
    if mentalObject:isBanedCard(cardWrapper) or mentalObject:isSelectedCard(cardWrapper) then
      iconUI:SetColor(Defines.Color.C_FF626262)
    else
      iconUI:SetColor(Defines.Color.C_FFFFFFFF)
    end
  end
end
function PaGlobalFunc_MentalGame_RClick_BanedCard(index)
  local self = Window_MentalGameInfo
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  RequestMentalGame_clearSelectCard(index)
  if mentalObject:getCardBySlotIndex(key) ~= nil then
    _AudioPostEvent_SystemUiForXBOX(0, 2)
  end
end
function PaGlobalFunc_MentalGame_ButtonA_BottomCard()
  local self = Window_MentalGameInfo
  if self._config._gameStep_ReadyGame == self._gameStep or self._config._gameStep_StartGame == self._gameStep or self._config._gameStep_EndGame == self._gameStep then
    return
  end
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  if self._selectCardIndex < mentalObject:getCardCount() then
    local value = mentalObject:getCard(self._selectCardIndex)
    if nil ~= value then
      local staticKey = value:getStaticStatus():getKey()
      if false == mentalObject:isSelectedCard(value) then
        RequestMentalGame_selectCardByKey(staticKey, 99)
        _AudioPostEvent_SystemUiForXBOX(0, 2)
      end
    end
  end
  self._selectCardIndex = -1
end
function PaGlobalFunc_MentalGame_RClick_BottomCard(index)
  local self = Window_MentalGameInfo
  self._selectCardIndex = index
  if self._config._gameStep_ReadyGame == self._gameStep or self._config._gameStep_StartGame == self._gameStep or self._config._gameStep_EndGame == self._gameStep then
    return
  end
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  if self._selectCardIndex < mentalObject:getCardCount() then
    local value = mentalObject:getCard(self._selectCardIndex)
    if nil ~= value then
      local staticKey = value:getStaticStatus():getKey()
      if false == mentalObject:isSelectedCard(value) then
        RequestMentalGame_selectCardByKey(staticKey, 99)
        _AudioPostEvent_SystemUiForXBOX(0, 2)
      end
    end
  end
  self._selectCardIndex = -1
end
function Window_MentalGameInfo:InitRegister()
  registerEvent("startMentalGame", "PaGlobalFunc_FromClient_MentalGame_Open")
  registerEvent("onScreenResize", "PaGlobalFunc_MentalGame_ScreenResize")
  registerEvent("ResponseMentalGame_updateStage", "PaGlobalFunc_FromClient_MentalGame_UpdateStage")
  registerEvent("ResponseMentalGame_endStage", "PaGlobalFunc_MentalGame_endStage")
  registerEvent("MentalGame_updateMatrix", "PaGlobalFunc_MentalGame_updateMatrix")
  registerEvent("EventSelfPlayerPreDead", "PaGlobalFunc_MentalGame_HideByDead")
  registerEvent("progressEventCancelByAttacked", "PaGlobalFunc_MentalGame_HideByDamage")
end
function PaGlobalFunc_MentalGame_ScreenResize()
  local self = Window_MentalGameInfo
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  Panel_Window_MentalGame:SetSize(screenX, screenY)
  Panel_Window_MentalGame:ComputePos()
  self._ui._static_LeftBg:ComputePos()
  self._ui._static_BottomBg:ComputePos()
  self._ui._static_keyGuide:ComputePos()
end
function PaGlobalFunc_FromClient_MentalGame_Open()
  local self = Window_MentalGameInfo
  ToClient_SaveUiInfo(false)
  if GetUIMode() ~= Defines.UIMode.eUIMode_NpcDialog then
    return
  end
  SetUIMode(Defines.UIMode.eUIMode_MentalGame)
  PaGlobalFunc_MainDialog_Close(false)
  Panel_Dialogue_Itemtake:SetShow(false)
  if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= HandleEventLUp_NPCShop_ALL_Close then
    HandleEventLUp_NPCShop_ALL_Close()
  elseif true == _ContentsGroup_RenewUI_NpcShop then
    PaGlobalFunc_Dialog_NPCShop_Close()
  end
  local isSuccess = show_MentalGame()
  if false == isSuccess then
    return
  end
  Panel_Window_MentalGame_Finish:SetShow(false)
  self._ui._static_LeftBg:SetShow(true)
  self._ui._static_BottomBg:SetShow(true)
  self._ui._static_keyGuide:SetShow(true)
  self._ui._static_TopBg:SetShow(true)
  self:Clear()
  self:SetMentalGameInfo()
  self:SetZodiac()
  self:SetBottomCardList()
  self:CreateInfomationUI()
  self:CreateAnimationUI()
  self:CircleLineAndObjectClear()
  self:SetCircleLineAndObject()
  self:SetSelectCardPos()
  self:UpdateState()
  PaGlobalFunc_MentalGame_Open()
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_STORY")
end
function Window_MentalGameInfo:SetZodiac()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  mentalObject:setScaleForConsole(self._config._defaultScale)
  local zodiacStaticStatusWrapper = mentalObject:getZodiacStaticStatusWrapper()
  if nil ~= zodiacStaticStatusWrapper then
    self._ui._static_Zodiac._control:SetShow(true)
    self._ui._static_Zodiac._control:ChangeTextureInfoName(zodiacStaticStatusWrapper:getZodiacImagePath())
  end
end
function Window_MentalGameInfo:SetSelectCardPos()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local basePos = mentalObject:getCardPos()
  local count = mentalObject:getPointCount()
  local gameOptionSetting = ToClient_getGameOptionControllerWrapper()
  local CropModeEnable = gameOptionSetting:getCropModeEnable()
  local CropModeScaleX = gameOptionSetting:getCropModeScaleX()
  local CropModeScaleY = gameOptionSetting:getCropModeScaleY()
  local screenX = getScreenSizeX() - getScreenSizeX() * CropModeScaleX
  local screenY = getScreenSizeY() - getScreenSizeY() * CropModeScaleY
  for index = 0, count - 1 do
    local starPos = mentalObject:getPoint(index)
    local float3Pos = Util.Math.AddVectorToVector(basePos, starPos)
    if nil == self._selectCardTable[index] then
      self._selectCardTable[index] = self:CreateSelectCard(index)
    end
    local selectCard = self._selectCardTable[index]
    local transformData = getTransformRevers(float3Pos.x, float3Pos.y, float3Pos.z)
    if transformData.x > -1 and transformData.y > -1 then
      local cameraDistance = distanceFromCamera(float3Pos.x, float3Pos.y, float3Pos.z)
      local scaleSize = 100000 / cameraDistance * 0.85
      selectCard._static_Bg:SetSize(scaleSize, scaleSize)
      transformData.x = transformData.x - (getOriginScreenSizeX() - getScreenSizeX()) / 2
      transformData.y = transformData.y - (getOriginScreenSizeY() - getScreenSizeY()) / 2
      if true == CropModeEnable then
        selectCard._static_Bg:SetPosX(transformData.x * CropModeScaleX + screenX / 2 - selectCard._static_Bg:GetSizeX() / 2)
        selectCard._static_Bg:SetPosY(transformData.y * CropModeScaleY + screenY / 2 - selectCard._static_Bg:GetSizeY() / 2)
      else
        selectCard._static_Bg:SetPosX(transformData.x - selectCard._static_Bg:GetSizeX() / 2)
        selectCard._static_Bg:SetPosY(transformData.y - selectCard._static_Bg:GetSizeY() / 2)
      end
      selectCard._static_Bg:SetAlpha(1)
      selectCard._static_Bg:SetDepth(cameraDistance)
      selectCard._circularProgress_Progress:ComputePos()
      selectCard._static_Success:ComputePos()
      selectCard._static_Failed:ComputePos()
      selectCard._circularProgress_Progress:SetAniSpeed(mentalObject:getMentalGameSpeed() / 100)
      self._selectCardTable[index] = selectCard
    end
  end
end
function Window_MentalGameInfo:CreateSelectCard(index)
  local selectCard = {}
  local UCT = CppEnums.PA_UI_CONTROL_TYPE
  selectCard._static_Bg = UI.createAndCopyBasePropertyControl(Panel_Window_MentalGame, "SelectCardTemplete", Panel_Window_MentalGame, "static_Bg_" .. index)
  selectCard._static_Bg:SetIgnore(false)
  selectCard._static_Bg:addInputEvent("Mouse_RUp", "PaGlobalFunc_MentalGame_RClick_BanedCard(" .. index .. ")")
  selectCard._static_Bg:addInputEvent("Mouse_On", "PaGlobalFunc_MentalGame_CardOver(" .. index .. ",true,true)")
  selectCard._static_Bg:addInputEvent("Mouse_Out", "PaGlobalFunc_MentalGame_CardOver(" .. index .. ",true,false)")
  selectCard._static_Bg:ComputePos()
  selectCard._circularProgress_Progress = UI.createAndCopyBasePropertyControl(self._selectCardTemplete._static_Bg, "CircularProgress_Progress", selectCard._static_Bg, "circular_Progress_" .. index)
  selectCard._circularProgress_Progress:SetShow(true)
  selectCard._circularProgress_Progress:SetCurrentControlPos(0)
  selectCard._circularProgress_Progress:SetProgressRate(0)
  selectCard._circularProgress_Progress:SetSmoothMode(true)
  selectCard._static_Success = UI.createAndCopyBasePropertyControl(self._selectCardTemplete._static_Bg, "Static_Success", selectCard._static_Bg, "static_Success_" .. index)
  selectCard._static_Success:SetShow(false)
  selectCard._static_Failed = UI.createAndCopyBasePropertyControl(self._selectCardTemplete._static_Bg, "Static_Failed", selectCard._static_Bg, "static_Failed_" .. index)
  selectCard._static_Failed:SetShow(false)
  return selectCard
end
function PaGlobalFunc_MentalGame_CardOver(mouseOverKey, isInserted, isShow)
  local self = Window_MentalGameInfo
  local prevIndex = self._selectCardIndex
  self._selectCardIndex = mouseOverKey
  if -1 ~= prevIndex then
    self._bottomCardList[prevIndex]._static_SelectBg:SetShow(false)
  end
  if -1 ~= self._selectCardIndex then
    self._bottomCardList[self._selectCardIndex]._static_SelectBg:SetShow(true == isShow)
  end
  Panel_Window_MentalGame_Tooltip:SetShow(false)
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  if self._config._gameStep_StartGame ~= self._gameStep then
    if self._overKey == mouseOverKey then
      if false == isShow then
        Panel_Window_MentalGame_Tooltip:SetShow(false)
        self._overKey = -1
      end
    elseif true == isShow then
      local targetUI
      local isSuccess = true
      if true == isInserted then
        isSuccess = self:UpdateTooltipContext(mentalObject:getCardBySlotIndex(mouseOverKey), isInserted, mouseOverKey)
        uiGroup = self._selectCardTable[mouseOverKey]
        if nil ~= self._selectCardTable[mouseOverKey] then
          targetUI = self._selectCardTable[mouseOverKey]._static_Bg
        end
      else
        isSuccess = self:UpdateTooltipContext(mentalObject:getCard(mouseOverKey), isInserted, mouseOverKey)
        if nil ~= self._bottomCardList[mouseOverKey] and nil ~= self._bottomCardList[mouseOverKey]._static_CardIcon then
          targetUI = self._bottomCardList[mouseOverKey]._static_CardIcon
        end
      end
      if true == isSuccess then
        Panel_Window_MentalGame_Tooltip:SetShow(true)
      end
    end
  end
end
function Window_MentalGameInfo:UpdateTooltipContext(mentalCard, isInserted, slotIndex)
  local mentalObject = getMentalgameObject()
  if nil == mentalCard or nil == mentalObject then
    return false
  end
  self._ui._staitcText_NpcName:SetText(mentalCard:getName())
  local tooltipPanel = Panel_Window_MentalGame_Tooltip
  tooltipPanel:SetSize(tooltipPanel:GetSizeX(), 440 + self._ui._staitcText_NpcName:GetTextSizeY())
  self._ui._tooltip._stc_topBG:ComputePos()
  self._ui._tooltip._stc_centerBG:ComputePos()
  self._ui._tooltip._stc_bottomBG:ComputePos()
  local maxHitPercent = mentalCard:getHit() / mentalObject:getCurrentDV() * 100
  local minDamage = mentalCard:getMinDD() - mentalObject:getCurrentPV()
  local maxDamage = mentalCard:getMaxDD() - mentalObject:getCurrentPV()
  local _mentalCard = mentalCard:getStaticStatus()
  local objectHit = mentalCard:getHit()
  if maxHitPercent < 0 then
    maxHitPercent = 0
  elseif maxHitPercent > 100 then
    maxHitPercent = 100
  end
  if minDamage < 0 then
    minDamage = 0
  end
  if maxDamage < 0 then
    maxDamage = 0
  end
  local buffText = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_BUFF_EMPTY")
  if true == _mentalCard:isBuff() then
    if _mentalCard:getApplyTurn() == 0 then
      if 2 > _mentalCard:getBuffType() then
        buffText = PAGetStringParam3(Defines.StringSheet_GAME, "MENTALGAME_BUFF_MESSAGE_1_UP", "buff", self._configStr._buffTypeString[_mentalCard:getBuffType()], "turn", tostring(_mentalCard:getValidTurn()), "value", tostring(_mentalCard:getVariedValue()))
      else
        buffText = PAGetStringParam3(Defines.StringSheet_GAME, "MENTALGAME_BUFF_MESSAGE_1_DOWN", "buff", self._configStr._buffTypeString[_mentalCard:getBuffType()], "turn", tostring(_mentalCard:getValidTurn()), "value", tostring(_mentalCard:getVariedValue()))
      end
    elseif 2 > _mentalCard:getBuffType() then
      buffText = PAGetStringParam4(Defines.StringSheet_GAME, "MENTALGAME_BUFF_MESSAGE_ANY_UP", "count", tostring(_mentalCard:getApplyTurn() + 1), "buff", self._configStr._buffTypeString[_mentalCard:getBuffType()], "turn", tostring(_mentalCard:getValidTurn()), "value", tostring(_mentalCard:getVariedValue()))
    else
      buffText = PAGetStringParam4(Defines.StringSheet_GAME, "MENTALGAME_BUFF_MESSAGE_ANY_DOWN", "count", tostring(_mentalCard:getApplyTurn() + 1), "buff", self._configStr._buffTypeString[_mentalCard:getBuffType()], "turn", tostring(_mentalCard:getValidTurn()), "value", tostring(_mentalCard:getVariedValue()))
    end
  end
  local overKey_StaticKey = _mentalCard:getKey()
  local overKeyIndex = -1
  for index = 0, self._config._slotCountMax - 1 do
    local mentalCardData = RequestMentalGame_getCardSlotAt(index)
    if nil ~= mentalCardData then
      if mentalCardData:getStaticStatus():getKey() == overKey_StaticKey then
        overKeyIndex = index
        break
      end
    else
      overKeyIndex = index
      break
    end
  end
  self._ui._staticText_HitBase:SetText(self._configStr._buffTypeString[1] .. " : " .. mentalCard:getHit())
  self._ui._staticText_DDBase:SetText(self._configStr._buffTypeString[0] .. " : " .. mentalCard:getMinDD() .. " ~ " .. mentalCard:getMaxDD())
  local temp1 = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_TOOLTIP_CAUSE_INTERESTING", "hit", tostring(objectHit), "percent", string.format("%.0f", maxHitPercent))
  local temp2 = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_TOOLTIP_FAVOR", "min", tostring(minDamage), "max", tostring(maxDamage))
  self._ui._staticText_InterestComment:SetText(temp1)
  self._ui._staticText_FavorityComment:SetText(temp2)
  local hitBonusText = ""
  local ddBonusText = ""
  local valueText = ""
  if true == isInserted then
    local startIndex = mentalObject:getBuffStartIndex(slotIndex, 0)
    for index = startIndex, slotIndex - 1 do
      local value = mentalObject:getBuffValue(index)
      if value > 0 then
        valueText = " +" .. tostring(value)
      elseif value < 0 then
        valueText = " " .. tostring(value)
      else
        valueText = ""
      end
      ddBonusText = ddBonusText .. valueText
    end
    local startIndex = mentalObject:getBuffStartIndex(slotIndex, 1)
    for index = startIndex, slotIndex - 1 do
      local value = mentalObject:getBuffValue(index)
      if value > 0 then
        valueText = " +" .. tostring(value)
      elseif value < 0 then
        valueText = " " .. tostring(value)
      else
        valueText = ""
      end
      hitBonusText = hitBonusText .. valueText
    end
  end
  self._ui._staticText_Bonus:SetText(buffText)
  self._ui._staticText_HitBonus:SetText(hitBonusText)
  self._ui._staticText_DDBonus:SetText(ddBonusText)
  self._ui._staticText_HitBonus:SetPosX(self._ui._staticText_HitBase:GetPosX() + self._ui._staticText_HitBase:GetSizeX() + self._ui._staticText_HitBase:GetTextSizeX() + 5)
  self._ui._staticText_DDBonus:SetPosX(self._ui._staticText_DDBase:GetPosX() + self._ui._staticText_DDBase:GetSizeX() + self._ui._staticText_DDBase:GetTextSizeX() + 5)
  return true
end
function Window_MentalGameInfo:SetMentalGameInfo()
  local left = self._ui._left
  local mentalStage = RequestMentalGame_getMentalStage()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local npcTitle = dialogData:getContactNpcTitle()
  local goaltype = mentalObject:getGoalType()
  local destGoalValue = mentalObject:getDestGoalValue()
  local currentDv = mentalObject:getCurrentDV()
  local currentPv = mentalObject:getCurrentPV()
  local comboCount = mentalObject:getCombo()
  local variedDv = mentalObject:getVariedDv()
  local variedPv = mentalObject:getVariedPv()
  local characterkey
  local talker = dialog_getTalker()
  local talkerName = ""
  local intimacy
  if nil ~= talker then
    talkerName = talker:getName()
    intimacy = talker:getIntimacy()
    characterkey = talker:getCharacterKey()
  end
  left._staticIcon_Type:SetText(npcTitle)
  left._staticText_Name:SetText(talkerName)
  left._staticText_IntimacyPoint:SetText(intimacy)
  local valuePercent = intimacy / self._config._interestValueMax * 100
  if valuePercent > 100 then
    valuePercent = 100
  end
  left._circularProgress_IntimacyPoint:SetProgressRate(valuePercent)
  local intimacyRewardCount = getIntimacyInformationCount(characterkey)
  local startSize = 28
  local endSize = (left._circularProgress_IntimacyPoint:GetSizeX() + left._static_RewardIcon:GetSizeX()) / 2
  local centerPosition = float3(left._circularProgress_IntimacyPoint:GetPosX() + left._circularProgress_IntimacyPoint:GetSizeX() / 2, left._circularProgress_IntimacyPoint:GetPosY() + left._circularProgress_IntimacyPoint:GetSizeY() / 2, 0)
  local questIndex = 0
  self._rewardToolTipDescTable = {}
  for index = 0, intimacyRewardCount - 1 do
    local intimacyInformationData = getIntimacyInformation(characterkey, index)
    if nil == intimacyInformationData then
      return
    end
    local percent = intimacyInformationData:getIntimacy() / 1000
    local imageType = intimacyInformationData:getTypeIndex()
    local giftName = intimacyInformationData:getTypeName()
    local giftDesc = intimacyInformationData:getTypeDescription()
    local giftMentalCardWrapper = ToClinet_getMentalCardStaticStatus(intimacyInformationData:getMentalCardKeyRaw())
    local giftOperator = intimacyInformationData:getOperatorType()
    if nil ~= giftMentalCardWrapper then
      if true == giftMentalCardWrapper:isHasCard() then
        giftDesc = giftDesc .. self._configStr._hasMentalCardText
      else
        giftDesc = giftDesc .. self._configStr._hasntMentalCardText
      end
    end
    giftDesc = giftDesc .. "(" .. self._configStr._operatorString[giftOperator] .. " " .. percent * 1000 .. ")"
    local imageFileName = ""
    if percent >= 0 and percent <= 1 and true == ToClient_checkIntimacyInformationFixedState(intimacyInformationData) then
      local angle = math.pi * 2 * percent
      local lineStart = float3(math.sin(angle), -math.cos(angle), 0)
      local lineEnd = float3(math.sin(angle), -math.cos(angle), 0)
      lineStart = Util.Math.AddVectorToVector(centerPosition, Util.Math.MulNumberToVector(lineStart, startSize))
      lineEnd = Util.Math.AddVectorToVector(centerPosition, Util.Math.MulNumberToVector(lineEnd, endSize))
      local rewardIcon = self._rewardIconTable[index]
      if nil == rewardIcon then
        rewardIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._static_LeftBg, "static_rewardIcon_" .. tostring(index))
        CopyBaseProperty(left._static_RewardIcon, rewardIcon)
        self._rewardIconTable[index] = rewardIcon
      end
      local icon
      if 0 == imageType then
        icon = self._configUV._intimacyIcon[imageType][questIndex]
        questIndex = questIndex + 1
      else
        icon = self._configUV._intimacyIcon[imageType]
      end
      rewardIcon:SetShow(true)
      rewardIcon:ChangeTextureInfoName(icon.texture)
      local x1, y1, x2, y2 = setTextureUV_Func(rewardIcon, icon.x1, icon.y1, icon.x2, icon.y2)
      rewardIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      rewardIcon:setRenderTexture(rewardIcon:getBaseTexture())
      rewardIcon:SetPosX(lineEnd.x - rewardIcon:GetSizeX() / 2)
      rewardIcon:SetPosY(lineEnd.y - rewardIcon:GetSizeY() / 2)
      local rewardText = self._rewardTextTable[index]
      if nil == rewardText then
        rewardText = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui._static_LeftBg, "static_rewardText_" .. tostring(index))
        CopyBaseProperty(left._static_RewardText, rewardText)
        rewardText:SetPosY(rewardText:GetPosY() + (rewardText:GetSizeY() + 3) * index)
        self._rewardTextTable[index] = rewardText
      end
      rewardText:SetShow(true)
      rewardText:ChangeTextureInfoName(icon.texture)
      local x1, y1, x2, y2 = setTextureUV_Func(rewardText, icon.x1, icon.y1, icon.x2, icon.y2)
      rewardText:getBaseTexture():setUV(x1, y1, x2, y2)
      rewardText:setRenderTexture(rewardText:getBaseTexture())
      rewardText:SetText(giftName .. " : " .. giftDesc)
      if intimacy < percent * 1000 then
        rewardIcon:SetColor(Defines.Color.C_FF888888)
        rewardText:SetColor(Defines.Color.C_FF888888)
        rewardText:SetFontColor(Defines.Color.C_FF888888)
      else
        rewardIcon:SetColor(Defines.Color.C_FFEFEFEF)
        rewardText:SetColor(Defines.Color.C_FFEFEFEF)
        rewardText:SetFontColor(Defines.Color.C_FFEFEFEF)
      end
    end
  end
  local DvStr = ""
  local PvStr = ""
  if variedDv ~= 0 and variedPv ~= 0 then
    DvStr = self._configStr._buffTypeString[1] .. " : " .. tostring(currentDv) .. " - " .. variedDv
    PvStr = self._configStr._buffTypeString[0] .. " : " .. tostring(currentPv) .. " - " .. variedPv
  elseif variedDv == 0 and variedPv ~= 0 then
    DvStr = self._configStr._buffTypeString[1] .. " : " .. tostring(currentDv)
    PvStr = self._configStr._buffTypeString[0] .. " : " .. tostring(currentPv) .. " - " .. variedPv
  elseif variedDv ~= 0 and variedPv == 0 then
    DvStr = self._configStr._buffTypeString[1] .. " : " .. tostring(currentDv) .. " - " .. variedDv
    PvStr = self._configStr._buffTypeString[0] .. " : " .. tostring(currentPv)
  else
    DvStr = self._configStr._buffTypeString[1] .. " : " .. tostring(currentDv)
    PvStr = self._configStr._buffTypeString[0] .. " : " .. tostring(currentPv)
  end
  left._staticText_Interest:SetText(DvStr)
  left._staticText_Impression:SetText(PvStr)
end
function Window_MentalGameInfo:Update()
  self:SetMentalGameInfo()
  self:SetZodiac()
  self:CircleLineAndObjectClear()
  self:SetCircleLineAndObject()
  self:SetSelectCardPos()
  self:UpdateCardScrollButton()
end
function Window_MentalGameInfo:UpdateState()
  local left = self._ui._left
  local mentalStage = RequestMentalGame_getMentalStage()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local goaltype = mentalObject:getGoalType()
  local destGoalValue = mentalObject:getDestGoalValue()
  local currentDv = mentalObject:getCurrentDV()
  local currentPv = mentalObject:getCurrentPV()
  local comboCount = mentalObject:getCombo()
  local talker = dialog_getTalker()
  local talkerName = ""
  local intimacy
  if nil ~= talker then
    talkerName = talker:getName()
  end
  local missionStr = ""
  local tipStr = ""
  if 3 == gameStep then
    tipStr = ""
  elseif goaltype == 0 then
    tipStr = ""
    missionStr = PAGetStringParam1(Defines.StringSheet_GAME, "MENTALGAME_TALKING_FREE", "target", tostring(talkerName))
  elseif goaltype == 1 then
    tipStr = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_TIP1")
    if 1 == destGoalValue then
      missionStr = PAGetStringParam1(Defines.StringSheet_GAME, "MENTALGAME_TALKING_INTERESTING", "target", tostring(talkerName))
    else
      missionStr = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_TALKING_INTERESTING_COMBO", "target", tostring(talkerName), "count", tostring(destGoalValue))
    end
  elseif goaltype == 2 then
    tipStr = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_TIP2")
    missionStr = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_TALKING_ACCUMULATE", "target", tostring(talkerName), "count", tostring(destGoalValue))
  elseif goaltype == 3 then
    tipStr = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_TIP3")
    missionStr = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_TALKING_MOST", "target", tostring(talkerName), "count", tostring(destGoalValue))
  elseif goaltype == 4 then
    tipStr = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_TIP4")
    missionStr = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_TALKING_FAILED", "target", tostring(talkerName), "count", tostring(destGoalValue))
  end
  left._staticText_Tip:SetText(tipStr)
  left._staticText_Mission:SetText(missionStr)
end
function PaGlobalFunc_FromClient_MentalGame_UpdateStage(isNext)
  local self = Window_MentalGameInfo
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local slotCount = mentalObject:getSlotCount()
  local Cardcount = mentalObject:getCardCount()
  for index = 0, slotCount - 1 do
    local cardWrapper = mentalObject:getCardBySlotIndex(index)
    if nil ~= self._selectCardTable[index] and nil ~= self._selectCardTable[index]._static_Bg then
      local target = self._selectCardTable[index]._static_Bg
      if nil ~= cardWrapper then
        target:ChangeTextureInfoName(cardWrapper:getPicture())
        target:SetIgnore(false)
      else
        target:ChangeTextureInfoName("")
        target:SetIgnore(true)
      end
      target:SetShow(true, false)
    end
  end
  local goaltype = mentalObject:getGoalType()
  local destGoalValue = mentalObject:getDestGoalValue()
  local currentDv = mentalObject:getCurrentDV()
  local currentPv = mentalObject:getCurrentPV()
  local comboCount = mentalObject:getCombo()
  local variedDv = mentalObject:getVariedDv()
  local variedPv = mentalObject:getVariedPv()
  local minCardSlotCount = mentalObject:getMinCardSlotCount()
  local filledSlotCount = mentalObject:getFilledSlotCount()
  self._ui._button_Clear:SetShow(0 ~= filledSlotCount)
  PaGlobalFunc_MentalGame_SetAlignGuide()
  local count = minCardSlotCount - filledSlotCount
  local commentDesc = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MENTALGAME_BASE_COMMENT2")
  if self._config._gameStep_CardSelect == self._gameStep and 0 ~= count then
    self._ui._top._staticText_CommentTitle:SetFontColor(Defines.Color.C_FF888888)
    self._ui._top._staticText_CommentTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MENTALGAME_BASE_COMMENT1"))
    self._ui._top._staticText_CommentDesc:SetFontColor(Defines.Color.C_FF888888)
    self._ui._top._staticText_CommentDesc:SetText(count .. commentDesc)
  else
    self._ui._top._staticText_CommentDesc:SetText("")
  end
  if self._config._gameStep_StartGame == self._gameStep then
    local currentPoint = mentalObject:getInterestValue()
    self._bestPoint = math.max(self._bestPoint, currentPoint)
    local descStr = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MENTALGAME_INTEREST_COMBOANDFAILED", "combo", comboCount, "failed", mentalObject:getFail()) .. "\n"
    descStr = descStr .. "      " .. PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_ACC_INTERESTING") .. " : " .. mentalObject:getTotalInterest() .. "\n"
    descStr = descStr .. "      " .. PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_MOST_INTERESTING") .. " : " .. self._bestPoint
    self._ui._top._staticText_CommentDesc:SetFontColor(Defines.Color.C_FFEFEFEF)
    self._ui._top._staticText_CommentDesc:SetText(descStr)
  end
  if minCardSlotCount <= filledSlotCount then
    if self._config._gameStep_CardSelect == self._gameStep then
      self:SetGameStep(self._config._gameStep_ReadyGame)
    end
  elseif self._config._gameStep_ReadyGame == self._gameStep then
    self:SetGameStep(self._config._gameStep_CardSelect)
  end
  self:CircleLineAndObjectClear()
  self:SetCircleLineAndObject()
  self:UpdateState()
  self:UpdateStageByStep()
  self:SetCardColor()
  self:UpdateCardScrollButton()
  for index = 0, Cardcount - 1 do
    local cardWrapper = mentalObject:getCard(index)
    if nil ~= self._bottomCardList[index] and nil ~= self._bottomCardList[index]._static_CardIcon then
      if true == mentalObject:isBanedCard(cardWrapper) or true == mentalObject:isSelectedCard(cardWrapper) then
        self._bottomCardList[index]._static_CardIcon:SetColor(Defines.Color.C_FF626262)
      else
        self._bottomCardList[index]._static_CardIcon:SetColor(Defines.Color.C_FFFFFFFF)
      end
    end
  end
  if true == isNext then
    self:UpdateNextTryEvent()
  end
end
function PaGlobalFunc_MentalGame_PosUpdateAnimation(key, value)
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local basePos = mentalObject:getCardPos()
  local pos = mentalObject:getLerpBySlot(value._startIndex, value._endIndex, (value._deltaTime - value._startTime) / (value._endTime - value._startTime))
  local float3Pos = Util.Math.AddVectorToVector(basePos, pos)
  local transformData = getTransformRevers(float3Pos.x, float3Pos.y, float3Pos.z)
  transformData.x = transformData.x - (getOriginScreenSizeX() - getScreenSizeX()) / 2
  transformData.y = transformData.y - (getOriginScreenSizeY() - getScreenSizeY()) / 2
  value._ui:SetPosX(transformData.x - value._ui:GetSizeX() / 2)
  value._ui:SetPosY(transformData.y - value._ui:GetSizeY() / 2)
end
function PaGlobalFunc_MentalGame_FontAlphaUpdateAnimation(key, value)
  local playTime = value._endTime - value._startTime
  local halfPlayTime = (value._endTime - value._startTime) / 2
  local inPlayDelta = value._deltaTime - value._startTime
  if value._startTime + halfPlayTime <= value._deltaTime then
    value._ui:SetFontAlpha((playTime - inPlayDelta) / halfPlayTime)
    value._ui:SetAlpha(inPlayDelta / halfPlayTime)
  else
    value._ui:SetFontAlpha(inPlayDelta / halfPlayTime)
    value._ui:SetAlpha(inPlayDelta / halfPlayTime)
  end
end
function Window_MentalGameInfo:CreateInfomationUI()
  local otherControlTextType = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT
  for from = 0, 19 do
    if nil == self._infomationUIList[from] then
      self._infomationUIList[from] = {}
    end
    for to = from + 1, 19 do
      if nil == self._infomationUIList[from][to] then
        self._infomationUIList[from][to] = {}
      end
      local targetGroup = self._infomationUIList[from][to]
      if nil == targetGroup._panel then
        local target = UI.createPanel("MentalGame_Information_" .. tostring(from) .. "_" .. tostring(to), Defines.UIGroup.PAGameUIGroup_QuestLog)
        target:SetIgnore(true)
        target:SetShow(true)
        target:SetSpanSize(0, 0)
        target:SetAlpha(1)
        target:ComputePos()
        targetGroup._panel = target
      end
      if nil == targetGroup._pointImage then
        local target = UI.createControl(otherControlTextType, targetGroup._panel, "PointImage")
        CopyBaseProperty(self._ui._staticText_addInterest, target)
        target:SetIgnore(false)
        target:SetShow(true)
        target:SetAlpha(1)
        target:SetSpanSize(0, 0)
        target:SetFontAlpha(0)
        target:ComputePos()
        target:SetHorizonCenter()
        target:SetVerticalMiddle()
        targetGroup._pointImage = target
      end
      if nil == targetGroup._nameTag then
        local nameTag = UI.createControl(otherControlTextType, targetGroup._pointImage, "NameTag")
        nameTag:SetIgnore(true)
        nameTag:SetShow(true)
        nameTag:SetFontAlpha(0)
        nameTag:SetSpanSize(0, 30)
        nameTag:SetHorizonCenter()
        nameTag:SetVerticalBottom()
        targetGroup._nameTag = nameTag
      end
      self._infomationUIList[from][to] = targetGroup
    end
  end
end
function Window_MentalGameInfo:CreateAnimationUI()
  local otherControlTextType = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT
  for from = 0, 19 do
    if nil == self._animationUIList[from] then
      self._animationUIList[from] = {}
    end
    for to = from + 1, 19 do
      if nil == self._animationUIList[from][to] then
        self._animationUIList[from][to] = {}
      end
      local targetGroup = self._animationUIList[from][to]
      if nil == targetGroup._pointImage then
        local target = UI.createControl(otherControlTextType, Panel_Window_MentalGame, "PointImage_" .. tostring(from) .. "_" .. tostring(to))
        CopyBaseProperty(self._ui._staticText_addInterest, target)
        target:SetIgnore(true)
        target:SetShow(false)
        target:SetAlpha(0.5)
        target:SetFontAlpha(0)
        target:SetSpanSize(0, 0)
        target:SetPosX(0)
        target:SetPosY(0)
        target:ChangeTextureInfoName("new_ui_common_forlua/widget/worldmap/worldmap_etc_00.dds")
        target:ComputePos()
        target:SetHorizonCenter()
        target:SetVerticalMiddle()
        targetGroup._pointImage = target
      end
      if nil == targetGroup._nameTag then
        local nameTag = UI.createControl(otherControlTextType, targetGroup._pointImage, "NameTag_" .. tostring(from) .. "_" .. tostring(to))
        nameTag:SetIgnore(true)
        nameTag:SetShow(true)
        nameTag:SetSpanSize(0, 30)
        nameTag:SetHorizonCenter()
        nameTag:SetVerticalBottom()
        targetGroup._nameTag = nameTag
      end
    end
  end
end
function Window_MentalGameInfo:UpdateStageByStep()
  self._ui._button_Select:addInputEvent("Mouse_LUp", "")
  Panel_Window_MentalGame:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
  Panel_Window_MentalGame:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
  Panel_Window_MentalGame:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  self._ui._button_Restart:SetShow(false)
  if self._config._gameStep_CardSelect == self._gameStep then
    self._ui._button_Select:SetShow(true)
    self._ui._button_Back:SetShow(true)
    self._ui._button_Select:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_GUILDHOUSE_CHANGEWORKER_SELECTBTN"))
    self._ui._button_Select:addInputEvent("Mouse_LUp", "PaGlobalFunc_MentalGame_LClick_SlectCard()")
    Panel_Window_MentalGame:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_MentalGame_SelectClear()")
    Panel_Window_MentalGame:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_MentalGame_ButtonA_BottomCard()")
    self._ui._top._staticText_CommentTitle:SetShow(true)
    self._ui._top._staticText_CommentDesc:SetShow(true)
  elseif self._config._gameStep_ReadyGame == self._gameStep then
    self._ui._button_Select:SetShow(true)
    self._ui._button_Back:SetShow(true)
    self._ui._button_Select:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MENTALGAME_RIGHT_APPLY_NEW_BTN"))
    self._ui._button_Select:addInputEvent("Mouse_LUp", "PaGlobalFunc_MentalGame_LClick_StartGame()")
    Panel_Window_MentalGame:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_MentalGame_LClick_StartGame()")
    Panel_Window_MentalGame:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_MentalGame_SelectClear()")
    self._ui._top._staticText_CommentDesc:SetShow(true)
    self._ui._top._staticText_CommentTitle:SetShow(false)
  elseif self._config._gameStep_StartGame == self._gameStep then
    self._ui._button_Back:SetShow(false)
    self._ui._button_Select:SetShow(false)
    self._ui._top._staticText_CommentDesc:SetShow(true)
    self._ui._button_Clear:SetShow(false)
  elseif self._config._gameStep_EndGame == self._gameStep then
    self._ui._button_Back:SetShow(true)
    self._ui._button_Clear:SetShow(false)
    self._ui._button_Select:SetShow(false)
    self._ui._top._staticText_CommentTitle:SetShow(true)
    local mentalStage = RequestMentalGame_getMentalStage()
    local playableNextGame = self._gamePlayCount < self._config._maxPlayCount - 1
    self._ui._button_Restart:SetShow(mentalStage._isSuccess and playableNextGame)
    if mentalStage._isSuccess and playableNextGame then
      Panel_Window_MentalGame:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_MentalGame_Restart()")
    end
  elseif self._config._gameStep_GameExit == self._gameStep then
    self._ui._button_Clear:SetShow(false)
    self._ui._top._staticText_CommentDesc:SetShow(true)
    self._ui._top._staticText_CommentTitle:SetShow(true)
    self._ui._button_Select:SetShow(false)
    self._ui._button_Back:SetShow(false)
    local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
    Panel_Window_MentalGame_Finish:SetShow(true)
    local talker = dialog_getTalker()
    local intimacy = 0
    if nil ~= talker then
      intimacy = talker:getIntimacy()
    end
    local addIntimacyValue = self._addIntimacy
    local resultIntimacy = intimacy + addIntimacyValue
    local resultStr = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_AQUIRE_INTIMACY_POINT", "result", tostring(resultIntimacy), "point", tostring(addIntimacyValue))
    self._ui._staticText_Finished:SetText(resultStr)
    local aniInfo1 = self._ui._static_Finished:addScaleAnimation(0, 0.16, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    aniInfo1:SetStartScale(0.5)
    aniInfo1:SetEndScale(1.15)
    aniInfo1.AxisX = self._ui._static_Finished:GetSizeX() / 2
    aniInfo1.AxisY = self._ui._static_Finished:GetSizeY() / 2
    aniInfo1.ScaleType = 2
    aniInfo1.IsChangeChild = true
    local aniInfo2 = self._ui._static_Finished:addScaleAnimation(0.16, 0.3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    aniInfo2:SetStartScale(1.15)
    aniInfo2:SetEndScale(1)
    aniInfo2.AxisX = self._ui._static_Finished:GetSizeX() / 2
    aniInfo2.AxisY = self._ui._static_Finished:GetSizeY() / 2
    aniInfo2.ScaleType = 2
    aniInfo2.IsChangeChild = true
    local aniInfo3 = self._ui._staticText_Finished:addScaleAnimation(0, 0.16, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    aniInfo3:SetStartScale(0.5)
    aniInfo3:SetEndScale(1.15)
    aniInfo3.AxisX = self._ui._staticText_Finished:GetSizeX() / 2
    aniInfo3.AxisY = self._ui._staticText_Finished:GetSizeY() / 2
    aniInfo3.ScaleType = 2
    aniInfo3.IsChangeChild = true
    local aniInfo4 = self._ui._staticText_Finished:addScaleAnimation(0.16, 0.3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    aniInfo4:SetStartScale(1.15)
    aniInfo4:SetEndScale(1)
    aniInfo4.AxisX = self._ui._staticText_Finished:GetSizeX() / 2
    aniInfo4.AxisY = self._ui._staticText_Finished:GetSizeY() / 2
    aniInfo4.ScaleType = 2
    aniInfo4.IsChangeChild = true
  end
  PaGlobalFunc_MentalGame_SetAlignGuide()
end
function Window_MentalGameInfo:UpdateNextTryEvent()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local nextSlot = mentalObject:getNextSlot()
  if nextSlot > 0 then
    local prevSlot = nextSlot - 1
    local index = mentalObject:getOrder(prevSlot)
    if nil == self._selectCardTable[index] or nil == self._selectCardTable[index]._static_Success then
      return
    end
    self._selectCardTable[index]._static_Success:ResetVertexAni()
    self._selectCardTable[index]._static_Failed:ResetVertexAni()
    self._selectCardTable[index]._static_Success:SetShow(false)
    self._selectCardTable[index]._static_Failed:SetShow(false)
    if true == mentalObject:isComboSuccess() then
      self._selectCardTable[index]._static_Bg:AddEffect("fUI_KnowledgeNotice02", false, 0, 0)
      self._selectCardTable[index]._static_Success:SetVertexAniRun("Ani_Color_New", true)
      self._selectCardTable[index]._static_Success:SetVertexAniRun("Ani_Move_Pos_New", true)
      self._selectCardTable[index]._static_Success:SetShow(true)
      _AudioPostEvent_SystemUiForXBOX(4, 9)
    else
      self._selectCardTable[index]._static_Failed:SetVertexAniRun("Ani_Color_New", true)
      self._selectCardTable[index]._static_Failed:SetVertexAniRun("Ani_Move_Pos_New", true)
      self._selectCardTable[index]._static_Failed:SetShow(true)
      _AudioPostEvent_SystemUiForXBOX(4, 8)
    end
    local lastIndex = mentalObject:getOrderCount() - 1
    local nextIndex = mentalObject:getOrder(nextSlot)
    if mentalObject:getHasNextSlot() and nil ~= self._selectCardTable[nextIndex]._circularProgress_Progress then
      self._selectCardTable[nextIndex]._circularProgress_Progress:SetShow(true)
      self._selectCardTable[nextIndex]._circularProgress_Progress:SetCurrentControlPos(0)
      self._selectCardTable[nextIndex]._circularProgress_Progress:SetProgressRate(100)
    end
    local isFirst = true
    for index = nextSlot, lastIndex do
      local isApplied = mentalObject:isAppliedEffect(prevSlot, index)
      local isFirstAnimation = false
      if true == isFirst and nil ~= mentalObject:getCardBySlotOrder(index) then
        isFirst = false
        isFirstAnimation = true
      end
      if true == isApplied or true == isFirstAnimation then
        if true == isFirstAnimation then
          self._animationUIList[prevSlot][index]._pointImage:SetColor(Defines.Color.C_FFEF9C7F)
        else
          self._animationUIList[prevSlot][index]._pointImage:SetColor(Defines.Color.C_FFFFFFFF)
        end
        local playCount = index - prevSlot - mentalObject:getEmptyCount(prevSlot, index)
        self:AddAnimation(self._animationUIList[prevSlot][index]._pointImage, 0, mentalObject:getMentalGameSpeed() / 1000 * playCount, prevSlot, index, PaGlobalFunc_MentalGame_PosUpdateAnimation)
        self:AddAnimation(self._infomationUIList[prevSlot][index]._nameTag, 0, mentalObject:getMentalGameSpeed() / 1000 * playCount, prevSlot, index, PaGlobalFunc_MentalGame_FontAlphaUpdateAnimation)
      end
    end
  end
end
function Window_MentalGameInfo:AddAnimation(ui, startTime, endTime, startIndex, endIndex, animationFunc)
  if endTime <= startTime or nil == ui or endTime <= 0 or nil == animationFunc then
    return
  end
  self._animationList[self._animationIndex] = {
    _ui = ui,
    _startTime = startTime,
    _endTime = endTime,
    _startIndex = startIndex,
    _endIndex = endIndex,
    _deltaTime = 0,
    _animationFunc = animationFunc
  }
  self._animationIndex = self._animationIndex + 1
end
function Window_MentalGameInfo:UpdateAnimationList(deltaTime)
  for key, value in pairs(self._animationList) do
    value._deltaTime = value._deltaTime + deltaTime
    if value._endTime < value._deltaTime then
      value._ui:SetShow(false)
      self._animationList[key] = nil
    elseif value._startTime <= value._deltaTime then
      value._animationFunc(key, value)
      value._ui:SetShow(true)
    else
      value._ui:SetShow(false)
    end
  end
end
function PaGlobalFunc_MentalGame_tryCard()
end
function PaGlobalFunc_MentalGame_endStage(addedIntimacy)
  local self = Window_MentalGameInfo
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local mentalStage = RequestMentalGame_getMentalStage()
  if true == mentalStage._isSuccess then
    self._addIntimacy = self._addIntimacy + addedIntimacy
  else
    self._addIntimacy = 0
  end
  if 0 == self._addIntimacy then
    self._ui._top._staticText_CommentTitle:SetFontColor(Defines.Color.C_FF888888)
    self._ui._top._staticText_CommentTitle:SetText(PAGetString(Defines.StringSheet_GAME, "MENTALGAME_INTIMACY_ACQUIRE_EMPTY"))
  else
    self._ui._top._staticText_CommentTitle:SetFontColor(Defines.Color.C_FF00C0D7)
    self._ui._top._staticText_CommentTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MENTALGAME_ADDINTIMACY", "value", self._addIntimacy))
  end
  self._bestPoint = 0
  self:UpdateState()
  self:SetGameStep(self._config._gameStep_EndGame)
end
function PaGlobalFunc_MentalGame_updateMatrix()
  local self = Window_MentalGameInfo
  self:CircleLineAndObjectClear()
  self:SetCircleLineAndObject()
  self:SetSelectCardPos()
end
function PaGlobalFunc_MentalGame_HideByDead()
  local self = Window_MentalGameInfo
  if false == PaGlobalFunc_MentalGame_GetShow() then
    return
  end
  PaGlobalFunc_MentalGame_SelectClear()
  Panel_Window_MentalGame:SetShow(false)
  Panel_Window_MentalGame_Tooltip:SetShow(false)
  Panel_Window_MentalGame_Finish:SetShow(false)
  self._ui._static_LeftBg:SetShow(false)
  self._ui._static_BottomBg:SetShow(false)
  self._ui._static_keyGuide:SetShow(false)
  self._ui._static_TopBg:SetShow(false)
  self:Clear()
  self:StageClear()
  hide_MentalGame(true)
  RequestMentalGame_endGame()
  self._renderMode:reset()
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_Open()
    PaGlobalFunc_Dialog_Main_CloseNpcTalk()
  else
    Panel_Npc_Dialog:SetShow(true)
    dialog_CloseNpcTalk(true)
  end
  setShowNpcDialog(false)
  setShowLine(true)
  ToClient_PopDialogueFlush()
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function PaGlobalFunc_MentalGame_HideByDamage()
  local self = Window_MentalGameInfo
  if false == PaGlobalFunc_MentalGame_GetShow() then
    return
  end
  PaGlobalFunc_MentalGame_SelectClear()
  Panel_Window_MentalGame:SetShow(false)
  Panel_Window_MentalGame_Tooltip:SetShow(false)
  Panel_Window_MentalGame_Finish:SetShow(false)
  self._ui._static_LeftBg:SetShow(false)
  self._ui._static_BottomBg:SetShow(false)
  self._ui._static_keyGuide:SetShow(false)
  self._ui._static_TopBg:SetShow(false)
  self:Clear()
  self:StageClear()
  hide_MentalGame(false)
  RequestMentalGame_endGame()
  SetUIMode(Defines.UIMode.eUIMode_Default)
  self._renderMode:reset()
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_Open()
    PaGlobalFunc_Dialog_Main_CloseNpcTalk()
  else
    Panel_Npc_Dialog:SetShow(true)
    dialog_CloseNpcTalk(true)
  end
  setShowNpcDialog(false)
  setShowLine(true)
  ToClient_PopDialogueFlush()
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function PaGlobalFunc_FromClient_MentalGame_luaLoadComplete()
  local self = Window_MentalGameInfo
  self:Initialize()
end
function PaGlobalFunc_MentalGame_Close(isDead)
  local self = Window_MentalGameInfo
  if false == PaGlobalFunc_MentalGame_GetShow() then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(1, 33)
  PaGlobalFunc_MentalGame_SelectClear()
  if nil == isDead then
    isDead = false
  end
  hide_MentalGame(isDead)
  RequestMentalGame_endGame()
  self._renderMode:reset()
  Panel_Window_MentalGame:SetShow(false)
  Panel_Window_MentalGame_Tooltip:SetShow(false)
  Panel_Window_MentalGame_Finish:SetShow(false)
  self._ui._static_LeftBg:SetShow(false)
  self._ui._static_BottomBg:SetShow(false)
  self._ui._static_keyGuide:SetShow(false)
  self._ui._static_TopBg:SetShow(false)
  self:Clear()
  self:StageClear()
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_ReOpen()
  else
    FromClient_ShowDialog()
  end
  SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function PaGlobalFunc_MentalGame_Open()
  Panel_Window_MentalGame:SetShow(true)
  _AudioPostEvent_SystemUiForXBOX(1, 32)
end
function Window_MentalGameInfo:XB_Control_Init()
  Panel_Window_MentalGame:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_MentalGame_SelectClear()")
  Panel_Window_MentalGame:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_MentalGame_LClick_Arrow(true)")
  Panel_Window_MentalGame:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_MentalGame_LClick_Arrow(false)")
end
function PaGlobalFunc_MentalGame_GetShow()
  return Panel_Window_MentalGame:GetShow()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_MentalGame_luaLoadComplete")
