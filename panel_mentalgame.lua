local renderMode = RenderModeWrapper.new(100, {
  Defines.RenderMode.eRenderMode_MentalGame
}, false)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local _math_MulNumberToVector = Util.Math.MulNumberToVector
local _math_AddVectorToVector = Util.Math.AddVectorToVector
local OPT = CppEnums.OtherListType
local UI_color = Defines.Color
local constValue = {
  interestValueMax = 1000,
  slotCountMax = 10,
  buffTypeString = {
    [0] = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_BUFFTYPE_FAVOR"),
    PAGetString(Defines.StringSheet_GAME, "MENTALGAME_BUFFTYPE_INTERESTING"),
    PAGetString(Defines.StringSheet_GAME, "MENTALGAME_BUFFTYPE_DEMANDINGINTERESTING"),
    PAGetString(Defines.StringSheet_GAME, "MENTALGAME_BUFFTYPE_DEMANDINGFAVOR")
  },
  hideTime = 5,
  maxPlayCount = 3
}
local mgUI = {
  base = {},
  select = {},
  tooltip = {},
  left = {},
  center = {},
  right = {},
  zodiac = {}
}
local giftIcon = {}
local gameStep = 0
local mouseInputer
local isRdown = false
local rMovePos = {x = 0, y = 0}
local addIntimacy = 0
local _bestPoint = 0
local hideDeltaTime = 0
local endTimechk = 0
local gamePlayCount = 0
local centerUiList = {}
local animationUIList = {}
local informationUI = {}
local animationList = {}
local animationIndex = 0
local selectCardIndex = -1
local prevDragImageSizeX, prevDragImageSizeY = 20, 20
local mentalGame_End = false
local scrollPosition = -5
local scrollPositionResult = 0
local scrX = getScreenSizeX()
local scrY = getScreenSizeY()
local function uiInit()
  local left = mgUI.left
  left.panel = Panel_MentalGame_Left
  left.statusBG = UI.getChildControl(Panel_MentalGame_Left, "Static_StatusBG")
  left.statusBG_1 = UI.getChildControl(Panel_MentalGame_Left, "Static_StatusBG_1")
  left.npc_Name = UI.getChildControl(Panel_MentalGame_Left, "StaticText_NPC_Name")
  left.npc_Status = UI.getChildControl(Panel_MentalGame_Left, "StaticText_NPCStatus")
  left.npcDV = UI.getChildControl(Panel_MentalGame_Left, "StaticText_npcDV")
  left.npcPV = UI.getChildControl(Panel_MentalGame_Left, "StaticText_npcPV")
  left.statusBG_2 = UI.getChildControl(Panel_MentalGame_Left, "Static_StatusBG_2")
  left.effect = UI.getChildControl(Panel_MentalGame_Left, "StaticText_Effect")
  left.comboCount = UI.getChildControl(Panel_MentalGame_Left, "StaticText_ComboCount")
  left.comboCount_1 = UI.getChildControl(Panel_MentalGame_Left, "StaticText_ComboCountValue")
  left.circle = UI.getChildControl(Panel_MentalGame_Left, "Static_Circle")
  left.circle2 = UI.getChildControl(Panel_MentalGame_Left, "Static_Circle2")
  left.failCount = UI.getChildControl(Panel_MentalGame_Left, "StaticText_FailCount")
  left.failCount_1 = UI.getChildControl(Panel_MentalGame_Left, "StaticText_FailCountValue")
  left.cumulativePoint = UI.getChildControl(Panel_MentalGame_Left, "StaticText_CumulativePoint")
  left.cumulativePoint_1 = UI.getChildControl(Panel_MentalGame_Left, "StaticText_CumulativePointValue")
  left.bestPoint = UI.getChildControl(Panel_MentalGame_Left, "StaticText_BestPoint")
  left.bestPoint_1 = UI.getChildControl(Panel_MentalGame_Left, "StaticText_BestPointValue")
  left.statusBG_3 = UI.getChildControl(Panel_MentalGame_Left, "Static_StatusBG_3")
  left.fruitage = UI.getChildControl(Panel_MentalGame_Left, "StaticText_Fruitage")
  left.fruitage_Value = UI.getChildControl(Panel_MentalGame_Left, "StaticText_Fruitage_Value")
  left.fruitage_Add = UI.getChildControl(Panel_MentalGame_Left, "StaticText_Fruitage_Add")
  left.giftNotice = UI.getChildControl(Panel_MentalGame_Left, "StaticText_GiftNotice")
  left.progressBG = UI.getChildControl(Panel_MentalGame_Left, "Static_ProgressBG")
  left.prograss_Current = UI.getChildControl(Panel_MentalGame_Left, "CircularProgress_Current")
  left.prograss_Success = UI.getChildControl(Panel_MentalGame_Left, "CircularProgress_Success")
  left.giftIcon = UI.getChildControl(Panel_MentalGame_Left, "Static_GiftIcon")
  left.statusBG_4 = UI.getChildControl(Panel_MentalGame_Left, "Static_StatusBg_4")
  left.gameDesc = UI.getChildControl(Panel_MentalGame_Left, "StaticText_Desc")
  local base = mgUI.base
  base.panel = Panel_MentalGame_Base
  base.comment_1 = UI.getChildControl(Panel_MentalGame_Base, "StaticText_Comment_1")
  base.comment_Value = UI.getChildControl(Panel_MentalGame_Base, "StaticText_Comment_Value")
  base.comment_2 = UI.getChildControl(Panel_MentalGame_Base, "StaticText_Comment_2")
  base.btnTryAgain = UI.getChildControl(Panel_MentalGame_Base, "Button_TryAgain")
  base.tryAgain = UI.getChildControl(Panel_MentalGame_Base, "StaticText_TryAgain")
  base.nextSuccess = UI.getChildControl(Panel_MentalGame_Base, "StaticText_NextSuccess")
  base.nextFail = UI.getChildControl(Panel_MentalGame_Base, "StaticText_NextFail")
  base.btnGameEnd = UI.getChildControl(Panel_MentalGame_Base, "Button_GameEnd")
  base.gameEnd = UI.getChildControl(Panel_MentalGame_Base, "StaticText_GameEnd")
  base.result = UI.getChildControl(Panel_MentalGame_Base, "StaticText_Result")
  base.condition = UI.getChildControl(Panel_MentalGame_Base, "StaticText_Condition")
  base.explain = UI.getChildControl(Panel_MentalGame_Base, "StaticText_Explain")
  base.statusBG_4 = UI.getChildControl(Panel_MentalGame_Base, "Static_StatusBG_4")
  base.bgPosX = base.statusBG_4:GetPosX()
  base.bgSizeX = base.statusBG_4:GetSizeX()
  local select = mgUI.select
  select.panel = Panel_MentalGame_Select
  select.interest = UI.getChildControl(Panel_MentalGame_Select, "StaticText_Interest")
  select.worth = UI.getChildControl(Panel_MentalGame_Select, "StaticText_Worth")
  select.interestAdd = UI.getChildControl(Panel_MentalGame_Select, "StaticText_InterestAdd")
  select.worthAdd = UI.getChildControl(Panel_MentalGame_Select, "StaticText_WorthAdd")
  select.name = UI.getChildControl(Panel_MentalGame_Select, "StaticText_Name")
  select.number = UI.getChildControl(Panel_MentalGame_Select, "StaticText_Number")
  select.addInterest = UI.getChildControl(Panel_MentalGame_Select, "StaticText_AddInterest")
  select.Combo = UI.getChildControl(Panel_MentalGame_Select, "Static_Combo")
  select.CircularProgress = UI.getChildControl(Panel_MentalGame_Select, "CircularProgress_Progress")
  select.SuccessIcon = UI.getChildControl(Panel_MentalGame_Select, "Static_Success")
  select.FailedIcon = UI.getChildControl(Panel_MentalGame_Select, "Static_Failed")
  local tooltip = mgUI.tooltip
  tooltip.panel = Panel_MentalGame_Tooltip
  tooltip.background = UI.getChildControl(Panel_MentalGame_Tooltip, "Static_Tooltip_BG")
  tooltip.statusBG = UI.getChildControl(Panel_MentalGame_Tooltip, "Static_Tooltip_StatusBG")
  tooltip.CommentBG = UI.getChildControl(Panel_MentalGame_Tooltip, "Static_Tooltip_CommentBG")
  tooltip.BonusBG = UI.getChildControl(Panel_MentalGame_Tooltip, "Static_Tooltip_BonusBG")
  tooltip.npcName = UI.getChildControl(Panel_MentalGame_Tooltip, "StaticText_NPC_Name")
  tooltip.background = UI.getChildControl(Panel_MentalGame_Tooltip, "Static_Tooltip_BG")
  tooltip.hitBase = UI.getChildControl(Panel_MentalGame_Tooltip, "StaticText_Hit_Base")
  tooltip.hitBonus = UI.getChildControl(Panel_MentalGame_Tooltip, "StaticText_Hit_Bonus")
  tooltip.ddBase = UI.getChildControl(Panel_MentalGame_Tooltip, "StaticText_DD_Base")
  tooltip.ddBonus = UI.getChildControl(Panel_MentalGame_Tooltip, "StaticText_DD_Bonus")
  tooltip.comment_1 = UI.getChildControl(Panel_MentalGame_Tooltip, "StaticText_Comment_1")
  tooltip.comment_2 = UI.getChildControl(Panel_MentalGame_Tooltip, "StaticText_Comment_2")
  tooltip.nextBonus = UI.getChildControl(Panel_MentalGame_Tooltip, "StaticText_Bonus")
  local center = mgUI.center
  center.panel = Panel_MentalGame_Center
  center.finishImage = UI.getChildControl(Panel_MentalGame_Center, "Static_Finish")
  center.finishText = UI.getChildControl(Panel_MentalGame_Center, "StaticText_Finish")
  center.finishImage:SetPosX(0)
  center.finishText:SetPosX(0)
  center.finishImage:SetPosY(getScreenSizeY() / 2 - center.finishImage:GetSizeY() / 2)
  center.finishText:SetPosY(getScreenSizeY() / 2 - center.finishText:GetSizeY() / 2)
  center.finishText:SetSize(getScreenSizeX(), center.finishText:GetSizeY())
  local right = mgUI.right
  right.panel = Panel_MentalGame_Right
  right.cardIcon = UI.getChildControl(Panel_MentalGame_Right, "Static_MentalIcon_C_0")
  right.cardText = UI.getChildControl(Panel_MentalGame_Right, "StaticText_MentalTxt_C_0")
  right.cardLeftArrow = UI.getChildControl(Panel_MentalGame_Right, "Button_LeftArrow")
  right.cardRightArrow = UI.getChildControl(Panel_MentalGame_Right, "Button_RightArrow")
  right.apply = UI.getChildControl(Panel_MentalGame_Right, "Button_Apply_New")
  right.interest = UI.getChildControl(Panel_MentalGame_Right, "StaticText_Interest")
  local zodiac = mgUI.zodiac
  zodiac.panel = UI.createOtherPanel("ZodiacCenterPanel", OPT.OtherPanelType_Wiki)
  zodiac.control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, zodiac.panel, "ZodiacCenterPanelImage")
  if nil ~= zodiac.panel then
    zodiac.panel:SetAlpha(0)
    zodiac.panel:SetSize(600, 600)
    zodiac.panel:Set3DRenderType(3)
    zodiac.panel:SetDepth(0)
    zodiac.panel:SetIgnore(true)
    zodiac.panel:SetShow(false, false)
    zodiac.control:SetPosX(0)
    zodiac.control:SetPosY(0)
    zodiac.control:SetSize(600, 600)
    zodiac.control:SetAlpha(1)
    zodiac.control:SetVerticalMiddle()
    zodiac.control:SetHorizonCenter()
    zodiac.control:SetIgnore(true)
    zodiac.control:SetShow(true)
  end
  select.addInterest:SetShow(false)
  left.giftIcon:SetShow(false)
  local UI_TM = CppEnums.TextMode
  tooltip.nextBonus:SetTextMode(UI_TM.eTextMode_AutoWrap)
  left.gameDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  left.gameDesc:SetText(left.gameDesc:GetText())
  right.cardLeftArrow:SetAutoDisableTime(0)
  right.cardRightArrow:SetAutoDisableTime(0)
  local temp1 = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_INTERESTING_FAILED")
  local temp2 = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_ACC_INTERESTING")
  local temp3 = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_MOST_INTERESTING")
  left.comboCount:SetTextMode(UI_TM.eTextMode_LimitText)
  left.failCount:SetTextMode(UI_TM.eTextMode_LimitText)
  left.cumulativePoint:SetTextMode(UI_TM.eTextMode_LimitText)
  left.bestPoint:SetTextMode(UI_TM.eTextMode_LimitText)
  left.comboCount:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MENTAL_LEFT_TEXT_COMBOCOUNT") .. " : ")
  left.failCount:SetText(temp1 .. " : ")
  left.cumulativePoint:SetText(temp2 .. " : ")
  left.bestPoint:SetText(temp3 .. " : ")
  local isComboLimit = left.comboCount:IsLimitText()
  local isFailLimit = left.failCount:IsLimitText()
  local isCumulativeLimit = left.cumulativePoint:IsLimitText()
  local isBestLimit = left.bestPoint:IsLimitText()
  if isComboLimit then
    left.comboCount:addInputEvent("Mouse_On", "MentalGame_Simpletooltips(true, 0)")
    left.comboCount:addInputEvent("Mouse_Out", "MentalGame_Simpletooltips(false)")
  end
  if isFailLimit then
    left.failCount:addInputEvent("Mouse_On", "MentalGame_Simpletooltips(true, 1)")
    left.failCount:addInputEvent("Mouse_Out", "MentalGame_Simpletooltips(false)")
  end
  if isCumulativeLimit then
    left.cumulativePoint:addInputEvent("Mouse_On", "MentalGame_Simpletooltips(true, 2)")
    left.cumulativePoint:addInputEvent("Mouse_Out", "MentalGame_Simpletooltips(false)")
  end
  if isBestLimit then
    left.bestPoint:addInputEvent("Mouse_On", "MentalGame_Simpletooltips(true, 3)")
    left.bestPoint:addInputEvent("Mouse_Out", "MentalGame_Simpletooltips(false)")
  end
end
local function registEventInit()
  registerEvent("startMentalGame", "MentalGame_Show")
  registerEvent("onScreenResize", "MentalGame_ScreenResize")
  registerEvent("ResponseMentalGame_updateStage", "MentalGame_StateUpdate")
  registerEvent("ResponseMentalGame_tryCard", "MentalGame_tryCard")
  registerEvent("ResponseMentalGame_endStage", "MentalGame_endStage")
  registerEvent("MentalGame_updateMatrix", "MentalGame_updateMatrix")
  registerEvent("EventSelfPlayerPreDead", "MentalGame_HideByDead")
  registerEvent("progressEventCancelByAttacked", "MentalGame_HideByDamage")
  mgUI.left.panel:RegisterUpdateFunc("MentalKnowledge_UpdatePosition")
  mgUI.center.panel:RegisterUpdateFunc("MentalGame_UpdateHideTime")
  mgUI.right.panel:RegisterUpdateFunc("MentalGame_UpdateEndTimer")
  local base = mgUI.base
  base.btnGameEnd:addInputEvent("Mouse_LDown", "MentalKnowledge_GameEnd_LClick()")
  base.btnTryAgain:addInputEvent("Mouse_LDown", "MentalKnowledge_TryAgain_LClick()")
  local right = mgUI.right
  right.cardLeftArrow:addInputEvent("Mouse_LDown", "MentalKnowledge_CardRotation_Left()")
  right.cardRightArrow:addInputEvent("Mouse_LDown", "MentalKnowledge_CardRotation_Right()")
  right.apply:addInputEvent("Mouse_LDown", "MentalKnowledge_Apply_LClick()")
end
local mentalBaseInit = function()
  MentalKnowledgeBase.init()
end
local function createCenterUI()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local function createUI(key, uiGroup)
    if nil ~= uiGroup.panel then
      return
    end
    local select = mgUI.select
    local panel = UI.createPanelAndSetPanelRenderMode("Panel_MentalGame_Select_" .. tostring(key), Defines.UIGroup.PAGameUIGroup_QuestLog, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_MentalGame
    }))
    panel:SetAlpha(1)
    panel:SetSize(10, 10)
    panel:addInputEvent("Mouse_On", "MentalKnowledge_Over(" .. key .. ",true,true)")
    panel:addInputEvent("Mouse_Out", "MentalKnowledge_Over(" .. key .. ",true,false)")
    panel:addInputEvent("Mouse_RUp", "MentalKnowledge_UpdateCenterSlot(" .. key .. ")")
    uiGroup.panel = panel
    panel:SetAlpha(1)
    panel:SetPosX(0)
    panel:SetPosY(0)
    panel:SetIgnore(false)
    panel:SetShow(false, false)
    local circularProgress = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CIRCULAR_PROGRESS, panel, "CircularProgres_" .. key)
    CopyBaseProperty(select.CircularProgress, circularProgress)
    uiGroup.circularProgress = circularProgress
    circularProgress:ComputePos()
    circularProgress:SetPosX(0)
    circularProgress:SetPosY(0)
    circularProgress:SetShow(true)
    circularProgress:SetCurrentControlPos(0)
    circularProgress:SetProgressRate(0)
    circularProgress:SetSmoothMode(true)
    circularProgress:SetAniSpeed(mentalObject:getMentalGameSpeed() / 100)
    local SuccessIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, panel, "SuccessIcon_" .. key)
    CopyBaseProperty(select.SuccessIcon, SuccessIcon)
    uiGroup.SuccessIcon = SuccessIcon
    SuccessIcon:ComputePos()
    local FailedIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, panel, "FailedIcon_" .. key)
    CopyBaseProperty(select.FailedIcon, FailedIcon)
    uiGroup.FailedIcon = FailedIcon
    FailedIcon:ComputePos()
  end
  local slotCount = mentalObject:getSlotCount()
  for index = 0, slotCount - 1 do
    if nil == centerUiList[index] then
      centerUiList[index] = {}
    end
    createUI(index, centerUiList[index])
  end
end
local function createAnimationUI()
  local select = mgUI.select
  local left = mgUI.left
  local otherControlTextType = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT
  for from = 0, 19 do
    if nil == animationUIList[from] then
      animationUIList[from] = {}
    end
    for to = from + 1, 19 do
      if nil == animationUIList[from][to] then
        animationUIList[from][to] = {}
      end
      local targetGroup = animationUIList[from][to]
      if nil == targetGroup.panel then
        local target = UI.createPanelAndSetPanelRenderMode("MentalGame_Animation_" .. tostring(from) .. "_" .. tostring(to), Defines.UIGroup.PAGameUIGroup_QuestLog, PAUIRenderModeBitSet({
          Defines.RenderMode.eRenderMode_MentalGame
        }))
        target:SetIgnore(true)
        target:SetShow(false)
        target:SetSpanSize(0, 0)
        target:SetAlpha(1)
        target:ComputePos()
        targetGroup.panel = target
      end
      if nil == targetGroup.pointImage then
        local target = UI.createControl(otherControlTextType, targetGroup.panel, "PointImage")
        CopyBaseProperty(select.addInterest, target)
        target:SetIgnore(true)
        target:SetShow(true)
        target:SetAlpha(0.5)
        target:SetFontAlpha(0)
        target:SetSpanSize(0, 0)
        target:ComputePos()
        target:SetHorizonCenter()
        target:SetVerticalMiddle()
        targetGroup.pointImage = target
      end
      if nil == targetGroup.nameTag then
        local nameTag = UI.createControl(otherControlTextType, targetGroup.pointImage, "NameTag")
        nameTag:SetIgnore(true)
        nameTag:SetShow(true)
        nameTag:SetSpanSize(0, 30)
        nameTag:SetHorizonCenter()
        nameTag:SetVerticalBottom()
        targetGroup.nameTag = nameTag
      end
    end
  end
end
local function createInformationUI()
  local select = mgUI.select
  local left = mgUI.left
  local otherControlTextType = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT
  for from = 0, 19 do
    if nil == informationUI[from] then
      informationUI[from] = {}
    end
    for to = from + 1, 19 do
      if nil == informationUI[from][to] then
        informationUI[from][to] = {}
      end
      local targetGroup = informationUI[from][to]
      if nil == targetGroup.panel then
        local target = UI.createPanel("MentalGame_Information_" .. tostring(from) .. "_" .. tostring(to), Defines.UIGroup.PAGameUIGroup_QuestLog)
        target:SetIgnore(true)
        target:SetShow(false)
        target:SetSpanSize(0, 0)
        target:SetAlpha(1)
        target:ComputePos()
        targetGroup.panel = target
      end
      if nil == targetGroup.pointImage then
        local target = UI.createControl(otherControlTextType, targetGroup.panel, "PointImage")
        CopyBaseProperty(select.addInterest, target)
        target:SetIgnore(false)
        target:SetShow(true)
        target:SetAlpha(1)
        target:SetSpanSize(0, 0)
        target:SetFontAlpha(0)
        target:ComputePos()
        target:SetHorizonCenter()
        target:SetVerticalMiddle()
        target:addInputEvent("Mouse_On", "MentalKnowledge_InformationUIFontAlpha(" .. from .. ", " .. to .. ", 1.0,true)")
        target:addInputEvent("Mouse_Out", "MentalKnowledge_InformationUIFontAlpha(" .. from .. ", " .. to .. ", 0.0,true)")
        targetGroup.pointImage = target
      end
      if nil == targetGroup.nameTag then
        local nameTag = UI.createControl(otherControlTextType, targetGroup.pointImage, "NameTag")
        nameTag:SetIgnore(true)
        nameTag:SetShow(true)
        nameTag:SetFontAlpha(0)
        nameTag:SetSpanSize(0, 30)
        nameTag:SetHorizonCenter()
        nameTag:SetVerticalBottom()
        targetGroup.nameTag = nameTag
      end
    end
  end
end
local function createMouseInputerAndSetting()
  mouseInputer = UI.createPanel("MentalGame_MouseInputer", Defines.UIGroup.PAGameUIGroup_ScreenEffect)
  mouseInputer:SetAlpha(0)
  mouseInputer:SetPosX(0)
  mouseInputer:SetPosY(0)
  mouseInputer:SetSize(getScreenSizeX(), getScreenSizeY())
  mouseInputer:addInputEvent("Mouse_LDown", "MentalKnowledge_OnLDown()")
  mouseInputer:addInputEvent("Mouse_LUp", "MentalKnowledge_OnLUp()")
  mouseInputer:addInputEvent("Mouse_RDown", "MentalKnowledge_OnRDown()")
  mouseInputer:addInputEvent("Mouse_RUp", "MentalKnowledge_OnRUp()")
  mouseInputer:addInputEvent("Mouse_UpScroll", "MentalKnowledge_OnWheelUp()")
  mouseInputer:addInputEvent("Mouse_DownScroll", "MentalKnowledge_OnWheelDown()")
  mouseInputer:SetShow(false, false)
end
local function mentalGameinit()
  uiInit()
  registEventInit()
  mentalBaseInit()
  createCenterUI()
  createAnimationUI()
  createInformationUI()
  createMouseInputerAndSetting()
end
local function maxPointUpdate()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local currentPoint = mentalObject:getInterestValue()
  _bestPoint = math.max(_bestPoint, currentPoint)
end
local posUpdateAnimation = function(key, value)
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local basePos = mentalObject:getCardPos()
  local pos = mentalObject:getLerpBySlot(value.startIndex, value.endIndex, (value.deltaTime - value.startTime) / (value.endTime - value.startTime))
  local float3Pos = Util.Math.AddVectorToVector(basePos, pos)
  local transformData = getTransformRevers(float3Pos.x, float3Pos.y, float3Pos.z)
  value.ui:SetPosX(transformData.x - value.ui:GetSizeX() / 2)
  value.ui:SetPosY(transformData.y - value.ui:GetSizeY() / 2)
end
local fontalphaUpdateAnimation = function(key, value)
  local playTime = value.endTime - value.startTime
  local halfPlayTime = (value.endTime - value.startTime) / 2
  local inPlayDelta = value.deltaTime - value.startTime
  if value.startTime + halfPlayTime <= value.deltaTime then
    value.ui:SetFontAlpha((playTime - inPlayDelta) / halfPlayTime)
    value.ui:SetAlpha(inPlayDelta / halfPlayTime)
  else
    value.ui:SetFontAlpha(inPlayDelta / halfPlayTime)
    value.ui:SetAlpha(inPlayDelta / halfPlayTime)
  end
end
local function addAnimation(ui, startTime, endTime, startIndex, endIndex, animationFunc)
  if endTime <= startTime or nil == ui or endTime <= 0 or nil == animationFunc then
    return
  end
  animationList[animationIndex] = {
    ui = ui,
    startTime = startTime,
    endTime = endTime,
    startIndex = startIndex,
    endIndex = endIndex,
    deltaTime = 0,
    animationFunc = animationFunc
  }
  animationIndex = animationIndex + 1
end
local function updateAnimationList(deltaTime)
  for key, value in pairs(animationList) do
    value.deltaTime = value.deltaTime + deltaTime
    if value.endTime < value.deltaTime then
      value.ui:SetShow(false)
      animationList[key] = nil
    elseif value.startTime <= value.deltaTime then
      value.animationFunc(key, value)
      value.ui:SetShow(true)
    else
      value.ui:SetShow(false)
    end
  end
end
local function clearAnimation()
  for key, value in pairs(animationList) do
    value.ui:SetShow(false)
  end
  animationList = {}
end
local function createControl(panel, fromType, name, targetObject, key)
  local target = UI.createControl(fromType, panel, name .. tostring(key))
  CopyBaseProperty(mgUI.select[name], target)
  target:SetIgnore(true)
  target:SetShow(true)
  target:ComputePos()
  return target
end
local circleKeyList = {}
local function insertCircleLineAndObject()
  MentalKnowledgeBase.init()
  MentalKnowledgeBase.circleSize = 25
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
    circleKeyList[index] = circleKey
  end
  local lineCount = mentalObject:getLineCount()
  for index = 0, lineCount - 1 do
    local firstIndex = mentalObject:getLineFirst(index)
    local secondIndex = mentalObject:getLineSecond(index)
    MentalKnowledgeBase.InsertLineByCircle(circleKeyList[firstIndex], circleKeyList[secondIndex])
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
        local panel = informationUI[srcSlot][dstSlot].panel
        local nameTag = informationUI[srcSlot][dstSlot].nameTag
        local card = mentalObject:getCardBySlotIndex(srcIndex)
        if isApplied then
          MentalKnowledgeBase.InsertLineByCircle(circleKeyList[srcIndex], circleKeyList[dstIndex])
          local inputText = constValue.buffTypeString[card:getBuffType()] .. " : " .. card:getVariedValue()
          local pos = mentalObject:getLerpBySlot(srcSlot, dstSlot, 0.5)
          local float3Pos = Util.Math.AddVectorToVector(basePos, pos)
          local transformData = getTransformRevers(float3Pos.x, float3Pos.y, float3Pos.z)
          nameTag:SetText(inputText)
          panel:SetPosX(transformData.x - panel:GetSizeX() / 2)
          panel:SetPosY(transformData.y - panel:GetSizeY() / 2)
          panel:SetShow(true)
        else
          panel:SetShow(false)
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
        MentalKnowledgeBase.InsertLineByCircle(circleKeyList[slotNumberSrc], circleKeyList[slotNumberDst])
      end
      prevIndex = currIndex
    end
  end
  MentalKnowledgeBase.UpdateLineAndCircle()
end
local function removeCircleLineAndObject()
  circleKeyList = {}
  MentalKnowledgeBase.ClearLineAndCircle()
end
local insertCircleLine_CardEffect = function()
end
local rightCardList = {}
local function createControlRight(panel, fromType, name, targetObject, key)
  local target = UI.createControl(fromType, panel, name .. tostring(key))
  targetObject.ui[name] = target
  CopyBaseProperty(mgUI.right[name], target)
  target:SetShow(true)
  target:ComputePos()
  return target
end
local _aControlPos = 0
local _aTextControlPos = 0
local function insertCardList()
  local right = mgUI.right
  local aControl = {}
  local aTextControl = {}
  local index = 0
  local PrePosY = 0
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local count = mentalObject:getCardCount()
  for index = 0, count - 1 do
    local cardWrapper = mentalObject:getCard(index)
    local gap = right.cardIcon:GetSizeY() * 13 / 10
    if nil == rightCardList[index] then
      rightCardList[index] = {
        ui = {}
      }
    end
    if nil == rightCardList[index].ui then
      rightCardList[index].ui = {}
    end
    if nil == rightCardList[index].ui.cardText then
      aTextControl[index] = createControlRight(right.panel, UCT.PA_UI_CONTROL_STATICTEXT, "cardText", rightCardList[index], index)
      aTextControl[index]:SetPosX(index * gap)
      aTextControl[index]:SetAutoResize(true)
      aTextControl[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      aTextControl[index]:SetText(cardWrapper:getName())
      aTextControl[index]:SetVerticalBottom()
      aControl[index] = createControlRight(aTextControl[index], UCT.PA_UI_CONTROL_STATIC, "cardIcon", rightCardList[index], index)
      aControl[index]:ChangeTextureInfoName(cardWrapper:getPicture())
      aControl[index]:SetVerticalTop()
      aControl[index]:SetSpanSize(0, 0 - aControl[index]:GetSizeY())
      aControl[index]:SetIgnore(false)
      aControl[index]:addInputEvent("Mouse_LDown", "MentalKnowledge_OnLDown_Card(" .. index .. " )")
      aControl[index]:addInputEvent("Mouse_RDown", "MentalKnowledge_OnRDown_Card(" .. index .. " )")
      aControl[index]:addInputEvent("Mouse_On", "MentalKnowledge_Over(" .. index .. ",false,true)")
      aControl[index]:addInputEvent("Mouse_Out", "MentalKnowledge_Over(" .. index .. ",false,false)")
      if mentalObject:isBanedCard(cardWrapper) or mentalObject:isSelectedCard(cardWrapper) then
        aControl[index]:SetColor(UI_color.C_FF626262)
      else
        aControl[index]:SetColor(UI_color.C_FFFFFFFF)
      end
      aControl[index]:SetHorizonCenter()
      _aControlPos = aControl[index]:GetPosY()
    else
      aControl[index] = rightCardList[index].ui.cardIcon
    end
    if PrePosY < aTextControl[index]:GetSizeY() then
      PrePosY = aTextControl[index]:GetSizeY()
    end
  end
  for index = 0, count - 1 do
    aTextControl[index]:SetSize(aTextControl[index]:GetSizeX(), PrePosY)
    aTextControl[index]:ComputePos()
    aControl[index]:ComputePos()
  end
end
local function updateCardColor()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local count = mentalObject:getCardCount()
  for index = 0, count - 1 do
    local cardWrapper = mentalObject:getCard(index)
    if nil ~= rightCardList[index] and nil ~= rightCardList[index].ui and nil ~= rightCardList[index].ui.cardIcon then
      local iconUI = rightCardList[index].ui.cardIcon
      if mentalObject:isBanedCard(cardWrapper) or mentalObject:isSelectedCard(cardWrapper) then
        iconUI:SetColor(UI_color.C_FF626262)
      else
        iconUI:SetColor(UI_color.C_FFFFFFFF)
      end
    end
  end
end
local function clearCardList()
  local right = mgUI.right
  for _, value in pairs(rightCardList) do
    if nil ~= value.ui and nil ~= value.ui.cardText then
      right.panel:RemoveControl(value.ui.cardText)
    end
  end
  rightCardList = {}
end
local function updateCenterBackground()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local yawpitchroll = mentalObject:getYawPitchRoll()
  mgUI.zodiac.panel:Set3DRotationX(yawpitchroll.x)
  mgUI.zodiac.panel:Set3DRotationY(yawpitchroll.y)
  mgUI.zodiac.panel:Set3DRotationZ(yawpitchroll.z)
  mgUI.zodiac.panel:SetWorldPosX(mentalObject:getCardPos().x)
  mgUI.zodiac.panel:SetWorldPosY(mentalObject:getCardPos().y)
  mgUI.zodiac.panel:SetWorldPosZ(mentalObject:getCardPos().z)
  mgUI.zodiac.control:SetScale(mentalObject:getScale(), mentalObject:getScale())
end
local function updateStateUIShow()
  if false == mouseInputer:GetShow() then
    return
  end
  local base = mgUI.base
  local left = mgUI.left
  local center = mgUI.center
  local right = mgUI.right
  if 0 == gameStep then
    right.panel:SetShow(true, false)
    left.fruitage_Add:SetShow(true)
    base.comment_1:SetShow(true)
    base.comment_Value:SetShow(true)
    base.comment_2:SetShow(true)
    right.apply:SetShow(false)
    right.interest:SetShow(true)
    base.btnTryAgain:SetShow(false)
    base.tryAgain:SetShow(false)
    base.nextSuccess:SetShow(false)
    base.nextFail:SetShow(false)
    base.btnGameEnd:SetShow(false)
    base.gameEnd:SetShow(false)
    base.result:SetShow(false)
    center.finishText:SetShow(false)
    center.finishImage:SetShow(false)
    center.panel:SetShow(false)
  elseif 1 == gameStep then
    left.fruitage_Add:SetShow(true)
    base.comment_1:SetShow(true)
    base.comment_Value:SetShow(false)
    base.comment_2:SetShow(false)
    right.apply:SetShow(true)
    right.apply:SetIgnore(false)
    right.interest:SetShow(false)
    base.btnTryAgain:SetShow(false)
    base.tryAgain:SetShow(false)
    base.nextSuccess:SetShow(false)
    base.nextFail:SetShow(false)
    base.btnGameEnd:SetShow(false)
    base.gameEnd:SetShow(false)
    base.result:SetShow(false)
    center.finishText:SetShow(false)
    center.finishImage:SetShow(false)
    center.panel:SetShow(false)
  elseif 2 == gameStep then
    left.fruitage_Add:SetShow(true)
    base.comment_1:SetShow(false)
    base.comment_Value:SetShow(false)
    base.comment_2:SetShow(false)
    right.apply:SetShow(false)
    right.interest:SetShow(true)
    base.btnTryAgain:SetShow(false)
    base.tryAgain:SetShow(false)
    base.nextSuccess:SetShow(false)
    base.nextFail:SetShow(false)
    base.btnGameEnd:SetShow(false)
    base.gameEnd:SetShow(false)
    base.result:SetShow(false)
    center.finishText:SetShow(false)
    center.finishImage:SetShow(false)
    center.panel:SetShow(false)
  elseif 3 == gameStep then
    local mentalStage = RequestMentalGame_getMentalStage()
    local playableNextGame = gamePlayCount < constValue.maxPlayCount
    left.fruitage_Add:SetShow(true)
    base.comment_1:SetShow(false)
    base.comment_Value:SetShow(false)
    base.comment_2:SetShow(false)
    right.apply:SetShow(false)
    right.interest:SetShow(true)
    base.btnTryAgain:SetShow(mentalStage._isSuccess and playableNextGame)
    base.tryAgain:SetShow(mentalStage._isSuccess and playableNextGame)
    base.nextSuccess:SetShow(mentalStage._isSuccess and playableNextGame)
    base.nextFail:SetShow(mentalStage._isSuccess and playableNextGame)
    base.btnGameEnd:SetShow(true)
    base.gameEnd:SetShow(true)
    base.result:SetShow(true)
    center.finishText:SetShow(false)
    center.finishImage:SetShow(false)
    center.panel:SetShow(false)
  elseif 4 == gameStep then
    left.panel:SetShow(false)
    base.panel:SetShow(false)
    center.panel:SetShow(true)
    center.finishText:SetShow(true)
    center.finishText:SetTextHorizonCenter()
    center.finishText:SetTextVerticalCenter()
    center.finishImage:SetShow(true)
    local aniInfo1 = center.finishImage:addScaleAnimation(0, 0.16, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    aniInfo1:SetStartScale(0.5)
    aniInfo1:SetEndScale(1.15)
    aniInfo1.AxisX = center.finishImage:GetSizeX() / 2
    aniInfo1.AxisY = center.finishImage:GetSizeY() / 2
    aniInfo1.ScaleType = 2
    aniInfo1.IsChangeChild = true
    local aniInfo2 = center.finishImage:addScaleAnimation(0.16, 0.3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    aniInfo2:SetStartScale(1.15)
    aniInfo2:SetEndScale(1)
    aniInfo2.AxisX = center.finishImage:GetSizeX() / 2
    aniInfo2.AxisY = center.finishImage:GetSizeY() / 2
    aniInfo2.ScaleType = 2
    aniInfo2.IsChangeChild = true
    local aniInfo3 = center.finishText:addScaleAnimation(0, 0.16, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    aniInfo3:SetStartScale(0.5)
    aniInfo3:SetEndScale(1.15)
    aniInfo3.AxisX = center.finishText:GetSizeX() / 2
    aniInfo3.AxisY = center.finishText:GetSizeY() / 2
    aniInfo3.ScaleType = 2
    aniInfo3.IsChangeChild = true
    local aniInfo4 = center.finishText:addScaleAnimation(0.16, 0.3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    aniInfo4:SetStartScale(1.15)
    aniInfo4:SetEndScale(1)
    aniInfo4.AxisX = center.finishText:GetSizeX() / 2
    aniInfo4.AxisY = center.finishText:GetSizeY() / 2
    aniInfo4.ScaleType = 2
    aniInfo4.IsChangeChild = true
  end
end
local function updateState()
  local left = mgUI.left
  local base = mgUI.base
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
  local variedDv = mentalObject:getVariedDv()
  local variedPv = mentalObject:getVariedPv()
  local talker = dialog_getTalker()
  local talkerName = ""
  if nil ~= talker then
    talkerName = talker:getName()
  end
  left.npc_Name:SetText(tostring(talkerName))
  if variedDv ~= 0 and variedPv ~= 0 then
    left.npcDV:SetText(constValue.buffTypeString[1] .. " : " .. tostring(currentDv) .. " - " .. variedDv)
    left.npcPV:SetText(constValue.buffTypeString[0] .. " : " .. tostring(currentPv) .. " - " .. variedPv)
  elseif variedDv == 0 and variedPv ~= 0 then
    left.npcDV:SetText(constValue.buffTypeString[1] .. " : " .. tostring(currentDv))
    left.npcPV:SetText(constValue.buffTypeString[0] .. " : " .. tostring(currentPv) .. " - " .. variedPv)
  elseif variedDv ~= 0 and variedPv == 0 then
    left.npcDV:SetText(constValue.buffTypeString[1] .. " : " .. tostring(currentDv) .. " - " .. variedDv)
    left.npcPV:SetText(constValue.buffTypeString[0] .. " : " .. tostring(currentPv))
  else
    left.npcDV:SetText(constValue.buffTypeString[1] .. " : " .. tostring(currentDv))
    left.npcPV:SetText(constValue.buffTypeString[0] .. " : " .. tostring(currentPv))
  end
  base.condition:SetShow(true)
  base.statusBG_4:SetShow(true)
  if 3 == gameStep then
    base.condition:SetShow(false)
    base.statusBG_4:SetShow(false)
  elseif goaltype == 0 then
    local temp1 = PAGetStringParam1(Defines.StringSheet_GAME, "MENTALGAME_TALKING_FREE", "target", tostring(talkerName))
    base.condition:SetText(temp1)
  elseif goaltype == 1 then
    local temp1 = ""
    if 1 == destGoalValue then
      temp1 = PAGetStringParam1(Defines.StringSheet_GAME, "MENTALGAME_TALKING_INTERESTING", "target", tostring(talkerName))
    else
      temp1 = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_TALKING_INTERESTING_COMBO", "target", tostring(talkerName), "count", tostring(destGoalValue))
    end
    base.condition:SetText(temp1)
  elseif goaltype == 2 then
    local temp1 = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_TALKING_ACCUMULATE", "target", tostring(talkerName), "count", tostring(destGoalValue))
    base.condition:SetText(temp1)
  elseif goaltype == 3 then
    local temp1 = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_TALKING_MOST", "target", tostring(talkerName), "count", tostring(destGoalValue))
    base.condition:SetText(temp1)
  elseif goaltype == 4 then
    local temp1 = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_TALKING_FAILED", "target", tostring(talkerName), "count", tostring(destGoalValue))
    base.condition:SetText(temp1)
  end
  if base.condition:GetShow() then
    local leftPos = 0
    leftPos = base.condition:GetTextSizeX() + 5
    leftPos = (base.panel:GetSizeX() - leftPos) / 2
  end
  left.comboCount_1:SetPosX(left.comboCount:GetPosX() + left.comboCount:GetTextSizeX() + 3)
  left.comboCount_1:SetText(tostring(comboCount))
  if comboCount > 0 and gameStep == 2 then
    left.comboCount_1:ResetVertexAni()
    left.comboCount_1:SetVertexAniRun("Ani_Color_0", true)
    left.comboCount_1:SetVertexAniRun("Ani_Color_1", true)
    left.circle:ResetVertexAni()
    left.circle:SetPosX(left.comboCount_1:GetPosX() - 3)
    left.circle:SetPosY(left.comboCount_1:GetPosY() - 3)
    left.circle2:ResetVertexAni()
    left.circle2:SetPosX(left.comboCount_1:GetPosX())
    left.circle2:SetPosY(left.comboCount_1:GetPosY())
  end
  maxPointUpdate()
  left.failCount_1:SetText(mentalObject:getFail())
  left.cumulativePoint_1:SetText(mentalObject:getTotalInterest())
  left.bestPoint_1:SetText(_bestPoint)
  left.failCount_1:SetPosX(left.failCount:GetPosX() + left.failCount:GetTextSizeX() + 3)
  left.cumulativePoint_1:SetPosX(left.cumulativePoint:GetPosX() + left.cumulativePoint:GetTextSizeX() + 3)
  left.bestPoint_1:SetPosX(left.bestPoint:GetPosX() + left.bestPoint:GetTextSizeX() + 3)
  if 3 == gameStep then
    base.explain:SetShow(false)
  elseif goaltype == 0 then
    base.explain:SetShow(false)
  elseif goaltype == 1 then
    base.explain:SetText(PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_TIP1"))
    base.explain:SetShow(true)
  elseif goaltype == 2 then
    base.explain:SetText(PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_TIP2"))
    base.explain:SetShow(true)
  elseif goaltype == 3 then
    base.explain:SetText(PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_TIP3"))
    base.explain:SetShow(true)
  elseif goaltype == 4 then
    base.explain:SetText(PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_TIP4"))
    base.explain:SetShow(true)
  end
  local sizeX = math.max(base.explain:GetTextSizeX(), base.condition:GetTextSizeX()) + 40
  base.statusBG_4:SetSize(sizeX, base.statusBG_4:GetSizeY())
  base.statusBG_4:SetPosX(base.bgPosX + (base.bgSizeX - sizeX) / 2)
  local talker = dialog_getTalker()
  local intimacy = 0
  if nil ~= talker then
    intimacy = talker:getIntimacy()
  end
  left.fruitage_Value:SetText(tostring(intimacy))
  local valuePercent = intimacy / constValue.interestValueMax * 100
  if valuePercent > 100 then
    valuePercent = 100
  end
  left.prograss_Success:SetProgressRate(valuePercent)
  valuePercent = (intimacy + addIntimacy) / constValue.interestValueMax * 100
  if valuePercent > 100 then
    valuePercent = 100
  end
  left.prograss_Current:SetProgressRate(valuePercent)
end
local function updateTooltipContext(mentalCard, isInserted, slotIndex)
  local mentalObject = getMentalgameObject()
  if nil == mentalCard or nil == mentalObject then
    return false
  end
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
  if _mentalCard:isBuff() then
    if _mentalCard:getApplyTurn() == 0 then
      if _mentalCard:getBuffType() < 2 then
        buffText = PAGetStringParam3(Defines.StringSheet_GAME, "MENTALGAME_BUFF_MESSAGE_1_UP", "buff", constValue.buffTypeString[_mentalCard:getBuffType()], "turn", tostring(_mentalCard:getValidTurn()), "value", tostring(_mentalCard:getVariedValue()))
      else
        buffText = PAGetStringParam3(Defines.StringSheet_GAME, "MENTALGAME_BUFF_MESSAGE_1_DOWN", "buff", constValue.buffTypeString[_mentalCard:getBuffType()], "turn", tostring(_mentalCard:getValidTurn()), "value", tostring(_mentalCard:getVariedValue()))
      end
    elseif _mentalCard:getBuffType() < 2 then
      buffText = PAGetStringParam4(Defines.StringSheet_GAME, "MENTALGAME_BUFF_MESSAGE_ANY_UP", "count", tostring(_mentalCard:getApplyTurn() + 1), "buff", constValue.buffTypeString[_mentalCard:getBuffType()], "turn", tostring(_mentalCard:getValidTurn()), "value", tostring(_mentalCard:getVariedValue()))
    else
      buffText = PAGetStringParam4(Defines.StringSheet_GAME, "MENTALGAME_BUFF_MESSAGE_ANY_DOWN", "count", tostring(_mentalCard:getApplyTurn() + 1), "buff", constValue.buffTypeString[_mentalCard:getBuffType()], "turn", tostring(_mentalCard:getValidTurn()), "value", tostring(_mentalCard:getVariedValue()))
    end
  end
  local overKey_StaticKey = _mentalCard:getKey()
  local overKeyIndex = -1
  for index = 0, constValue.slotCountMax - 1 do
    local mentalCardData = RequestMentalGame_getCardSlotAt(index)
    if mentalCardData ~= nil then
      if mentalCardData:getStaticStatus():getKey() == overKey_StaticKey then
        overKeyIndex = index
        break
      end
    else
      overKeyIndex = index
      break
    end
  end
  local tooltip = mgUI.tooltip
  tooltip.hitBase:SetText(constValue.buffTypeString[1] .. " : " .. mentalCard:getHit())
  tooltip.ddBase:SetText(constValue.buffTypeString[0] .. " : " .. mentalCard:getMinDD() .. " ~ " .. mentalCard:getMaxDD())
  tooltip.npcName:SetText(mentalCard:getName())
  local temp1 = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_TOOLTIP_CAUSE_INTERESTING", "hit", tostring(objectHit), "percent", string.format("%.0f", maxHitPercent))
  local temp2 = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_TOOLTIP_FAVOR", "min", tostring(minDamage), "max", tostring(maxDamage))
  tooltip.comment_1:SetText(temp1)
  tooltip.comment_2:SetText(temp2)
  local hitBonusText = ""
  local ddBonusText = ""
  local valueText = ""
  if isInserted then
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
  tooltip.nextBonus:SetText(buffText)
  tooltip.hitBonus:SetText(hitBonusText)
  tooltip.ddBonus:SetText(ddBonusText)
  tooltip.hitBonus:SetPosX(tooltip.hitBase:GetPosX() + tooltip.hitBase:GetSizeX() + tooltip.hitBase:GetTextSizeX() + 5)
  tooltip.ddBonus:SetPosX(tooltip.ddBase:GetPosX() + tooltip.ddBase:GetSizeX() + tooltip.ddBase:GetTextSizeX() + 5)
  return true
end
local function updateCardScrollButton()
  local right = mgUI.right
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local maxValue = mentalObject:getCardCount() - 5
  local totalCard = mentalObject:getCardCount()
  if totalCard <= 4 then
    right.cardLeftArrow:SetShow(false)
    right.cardRightArrow:SetShow(false)
    return
  end
  right.cardLeftArrow:SetShow(maxValue > scrollPositionResult)
  right.cardRightArrow:SetShow(scrollPositionResult > 0)
end
local function endUIProcessMentalOnly(isDead)
  if false == isShow_MentalGame() then
    return false
  end
  for key, value in pairs(centerUiList) do
    if nil ~= value.panel then
      value.panel:SetShow(false, false)
      value.panel:SetPosX(-1000)
      value.panel:SetPosY(-1000)
    end
  end
  for _, value in pairs(informationUI) do
    for _, value2 in pairs(value) do
      value2.panel:SetShow(false)
    end
  end
  clearCardList()
  clearAnimation()
  mentalBaseInit()
  removeCircleLineAndObject()
  hide_MentalGame(isDead)
  DragManager:setDragImageSize(prevDragImageSizeX, prevDragImageSizeY)
  DragManager:clearInfo()
  mouseInputer:SetShow(false, false)
  for _, value in pairs(mgUI) do
    if nil ~= value.panel then
      value.panel:SetShow(false, false)
    end
  end
  RequestMentalGame_endGame()
  return true
end
local function endUIProcess()
  renderMode:reset()
  SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
  local isClose = endUIProcessMentalOnly(false)
  if false == isClose then
    return
  end
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_ReOpen()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    FromClient_ShowDialog()
  else
    PaGlobalFunc_DialogMain_All_ShowToggle(true)
  end
end
function MentalGame_Hide()
  endUIProcess()
end
function MentalGame_HideByDamage()
  local isClose = endUIProcessMentalOnly(false)
  if false == isClose then
    return
  end
  SetUIMode(Defines.UIMode.eUIMode_Default)
  renderMode:reset()
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_Open()
    PaGlobalFunc_Dialog_Main_CloseNpcTalk()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    Panel_Npc_Dialog:SetShow(true)
    dialog_CloseNpcTalk(true)
  else
    PaGlobalFunc_DialogMain_All_ShowToggle(true)
  end
  setShowNpcDialog(false)
  setShowLine(true)
  ToClient_PopDialogueFlush()
  mouseInputer:SetAlpha(0)
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function MentalGame_HideByDead()
  local isClose = endUIProcessMentalOnly(true)
  if false == isClose then
    return
  end
  renderMode:reset()
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_Open()
    PaGlobalFunc_Dialog_Main_CloseNpcTalk()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    Panel_Npc_Dialog:SetShow(true)
    dialog_CloseNpcTalk(true)
  else
    PaGlobalFunc_DialogMain_All_ShowToggle(true)
  end
  setShowNpcDialog(false)
  setShowLine(true)
  ToClient_PopDialogueFlush()
  mouseInputer:SetAlpha(0)
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
local function gameStartInit()
  _bestPoint = 0
  scrollPositionResult = 0
  scrollPosition = -5
  nonSelectPlayAlpha = 0.3
  gamePlayCount = gamePlayCount + 1
  mouseInputer:SetShow(true, false)
  mgUI.zodiac.panel:SetShow(true, false)
  prevDragImageSizeX, prevDragImageSizeY = DragManager:getDragImageSize()
  DragManager:setDragImageSize(80, 80)
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local zodiacStaticStatusWrapper = mentalObject:getZodiacStaticStatusWrapper()
  if nil ~= zodiacStaticStatusWrapper then
    mgUI.zodiac.control:ChangeTextureInfoName(zodiacStaticStatusWrapper:getZodiacImagePath())
  end
  for key, value in pairs(centerUiList) do
    value.circularProgress:SetCurrentControlPos(0)
    value.circularProgress:SetProgressRate(0)
    value.SuccessIcon:ResetVertexAni()
    value.SuccessIcon:SetShow(false)
    value.FailedIcon:ResetVertexAni()
    value.FailedIcon:SetShow(false)
  end
  updateCardScrollButton()
end
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
local hasMentalCardText = PAGetString(Defines.StringSheet_GAME, "LUA_INTIMACY_INFORMATION_HASMENTALCARD")
local hasntMentalCardText = PAGetString(Defines.StringSheet_GAME, "LUA_INTIMACY_INFORMATION_HASNTMENTALCARD")
local operatorString = {
  [CppEnums.DlgCommonConditionOperatorType.Equal] = "",
  [CppEnums.DlgCommonConditionOperatorType.Large] = "<PAColor0xFFFF0000>\226\150\178<PAOldColor>",
  [CppEnums.DlgCommonConditionOperatorType.Small] = "<PAColor0xFF0000FF>\226\150\188<PAOldColor>"
}
local function giftIconInit()
  local left = mgUI.left
  local talker = dialog_getTalker()
  if nil == talker then
    return
  end
  local characterKey = talker:getCharacterKey()
  local count = getIntimacyInformationCount(characterKey)
  local colorKey = float4(1, 1, 1, 1)
  local startSize = 28
  local endSize = (left.progressBG:GetSizeX() + left.giftIcon:GetSizeX()) / 2
  local centerPosition = float3(left.progressBG:GetPosX() + left.progressBG:GetSizeX() / 2, left.progressBG:GetPosY() + left.progressBG:GetSizeY() / 2, 0)
  for index, value in pairs(giftIcon) do
    UI.deleteControl(value)
  end
  giftIcon = {}
  for index = 0, count - 1 do
    local intimacyInformationData = getIntimacyInformation(characterKey, index)
    local percent = intimacyInformationData:getIntimacy() / 1000
    local imageType = intimacyInformationData:getTypeIndex()
    local giftName = intimacyInformationData:getTypeName()
    local giftDesc = intimacyInformationData:getTypeDescription()
    local giftMentalCardWrapper = ToClinet_getMentalCardStaticStatus(intimacyInformationData:getMentalCardKeyRaw())
    local giftOperator = intimacyInformationData:getOperatorType()
    if nil ~= giftMentalCardWrapper then
      if giftMentalCardWrapper:isHasCard() then
        giftDesc = giftDesc .. hasMentalCardText
      else
        giftDesc = giftDesc .. hasntMentalCardText
      end
    end
    giftDesc = giftDesc .. "(" .. operatorString[giftOperator] .. " " .. percent * 1000 .. ")"
    local imageFileName = ""
    if percent >= 0 and percent <= 1 and ToClient_checkIntimacyInformationFixedState(intimacyInformationData) then
      local angle = math.pi * 2 * percent
      local lineStart = float3(math.sin(angle), -math.cos(angle), 0)
      local lineEnd = float3(math.sin(angle), -math.cos(angle), 0)
      lineStart = _math_AddVectorToVector(centerPosition, _math_MulNumberToVector(lineStart, startSize))
      lineEnd = _math_AddVectorToVector(centerPosition, _math_MulNumberToVector(lineEnd, endSize))
      local target = giftIcon[index]
      if nil == target then
        target = UI.createControl(UCT.PA_UI_CONTROL_STATIC, left.panel, "GiftIcon_" .. tostring(index))
        giftIcon[index] = target
        CopyBaseProperty(left.giftIcon, target)
      end
      target:SetShow(true)
      target:ChangeTextureInfoNameAsync(uv[imageType]._fileName)
      local x1, y1, x2, y2 = setTextureUV_Func(target, uv[imageType].x1, uv[imageType].y1, uv[imageType].x2, uv[imageType].y2)
      target:getBaseTexture():setUV(x1, y1, x2, y2)
      target:setRenderTexture(target:getBaseTexture())
      target:SetPosX(lineEnd.x - target:GetSizeX() / 2)
      target:SetPosY(lineEnd.y - target:GetSizeY() / 2)
      target:addInputEvent("Mouse_On", "FruitageGift_ShowTooltip(\"" .. giftName .. "\", \"" .. giftDesc .. "\", " .. target:GetPosX() .. ", " .. target:GetPosY() .. ")")
      target:addInputEvent("Mouse_Out", "FruitageGift_HideTooltip()")
    end
  end
end
function MentalGame_Show()
  ToClient_SaveUiInfo(false)
  if GetUIMode() ~= Defines.UIMode.eUIMode_NpcDialog then
    return
  end
  SetUIMode(Defines.UIMode.eUIMode_MentalGame)
  mentalGame_End = false
  if mgUI.left.panel:GetShow() then
    return
  end
  renderMode:set()
  MentalGame_ScreenResize()
  mgUI.left.panel:SetPosY(0)
  mgUI.left.panel:SetShow(true, false)
  mgUI.base.panel:SetShow(true, false)
  mgUI.right.panel:SetShow(true, false)
  mgUI.zodiac.panel:SetShow(true, false)
  if false == _ContentsGroup_NewUI_WorkerRandomSelect_All then
    Panel_Window_WorkerRandomSelect:SetShow(false, false)
  else
    HandleEventLUp_WorkerRandomSelect_All_Close()
  end
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_Close(false)
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    Panel_Npc_Dialog:SetShow(false, false)
    FGlobal_ShowRewardList(false)
  else
    PaGlobalFunc_DialogMain_All_ShowToggle(false)
  end
  Panel_Dialogue_Itemtake:SetShow(false)
  if false == _ContentsGroup_RenewUI_Skill then
    HandleMLUp_SkillWindow_Close(true)
  end
  if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= HandleEventLUp_NPCShop_ALL_Close then
    HandleEventLUp_NPCShop_ALL_Close()
  elseif true == _ContentsGroup_RenewUI_NpcShop then
    PaGlobalFunc_Dialog_NPCShop_Close()
  else
    NpcShop_WindowClose()
  end
  mgUI.left.panel:SetShow(true, false)
  local isSuccess = show_MentalGame()
  if false == isSuccess then
  end
  local selfProxy = getSelfPlayer():get()
  local selfPosition = selfProxy:getCameraTargetPos()
  gameStep = 0
  gamePlayCount = 0
  addIntimacy = 0
  mgUI.left.fruitage_Add:SetText("+0")
  gameStartInit()
  insertCircleLineAndObject()
  insertCardList()
  giftIconInit()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  mentalObject:scaling(-0.2)
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_STORY")
end
function MentalGame_ScreenResize()
  local sizeX = getScreenSizeX()
  local sizeY = getScreenSizeY()
  local leftPanel = mgUI.left.panel
  local centerPanel = mgUI.center.panel
  local basePanel = mgUI.base.panel
  local emptySize = sizeX - leftPanel:GetSizeX() - basePanel:GetSizeX()
  leftPanel:SetPosX(emptySize * 17 / 27)
  basePanel:SetPosX(emptySize * 20 / 27 + leftPanel:GetSizeX())
  centerPanel:SetPosX(0)
  centerPanel:SetPosY(0)
  centerPanel:SetSize(sizeX, sizeY)
  mgUI.center.finishImage:SetSize(sizeX, mgUI.center.finishImage:GetSizeY())
  mgUI.center.finishText:SetSize(sizeX, mgUI.center.finishText:GetSizeY())
  mgUI.center.finishImage:ComputePos()
  mgUI.center.finishText:ComputePos()
end
local function updateRotateProcess(deltaTime)
  if false == isRdown then
    return
  end
  local currPos = {
    x = getMousePosX(),
    y = getMousePosY()
  }
  if currPos.x == rMovePos.x and currPos.y == rMovePos.y then
    return
  end
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local diffPos = {
    x = (currPos.x - rMovePos.x) / getScreenSizeX(),
    y = (currPos.y - rMovePos.y) / getScreenSizeY()
  }
  mentalObject:rotate(diffPos.x * -3, diffPos.y * -3)
  updateCenterBackground()
  rMovePos = currPos
end
local function updateCenterUIPos(deltaTime)
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
    local panel = centerUiList[index].panel
    local progress = centerUiList[index].circularProgress
    local transformData = getTransformRevers(float3Pos.x, float3Pos.y, float3Pos.z)
    if transformData.x > -1 and transformData.y > -1 then
      local cameraDistance = distanceFromCamera(float3Pos.x, float3Pos.y, float3Pos.z)
      local scaleSize = 100000 / cameraDistance * 0.85
      panel:SetSize(scaleSize, scaleSize)
      progress:ComputePos()
      if CropModeEnable == true then
        panel:SetPosX(transformData.x * CropModeScaleX + screenX / 2 - panel:GetSizeX() / 2)
        panel:SetPosY(transformData.y * CropModeScaleY + screenY / 2 - panel:GetSizeY() / 2)
      else
        panel:SetPosX(transformData.x - panel:GetSizeX() / 2)
        panel:SetPosY(transformData.y - panel:GetSizeY() / 2)
      end
      panel:SetAlpha(1)
      panel:SetDepth(cameraDistance)
    end
  end
end
local function updateRightUIPos(deltaTime, forceRun)
  local diff = scrollPositionResult - scrollPosition
  if gameStep >= 2 then
    return
  end
  if 0 == diff and false == forceRun then
    return
  end
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  scrollPosition = scrollPosition + diff * math.min(deltaTime * 8, 1)
  if math.abs(scrollPositionResult - scrollPosition) < 0.05 then
    scrollPosition = scrollPositionResult
  end
  local right = mgUI.right
  local isIgnore = scrollPosition ~= scrollPositionResult
  for index, value in pairs(rightCardList) do
    if nil ~= value.ui and nil ~= value.ui.cardText then
      value.ui.cardIcon:SetIgnore(isIgnore)
      local posIndex = index - scrollPosition
      local position = mentalObject:getCirclePosition(float2((right.cardLeftArrow:GetPosX() + right.cardRightArrow:GetPosX() + (right.cardLeftArrow:GetSizeX() + right.cardRightArrow:GetSizeX()) / 2) / 2, right.cardLeftArrow:GetPosY() + right.cardLeftArrow:GetSizeY() / 2 + 320), 400, posIndex - 2)
      value.ui.cardText:SetPosX(position.x - value.ui.cardText:GetSizeX() / 2)
      value.ui.cardText:SetPosY(position.y - value.ui.cardText:GetSizeY() / 2)
      if posIndex >= -0.25 and posIndex <= 4.25 then
        value.ui.cardText:SetShow(true)
        value.ui.cardText:SetAlphaExtraChild(1)
      elseif posIndex >= -0.75 and posIndex < -0.25 then
        value.ui.cardText:SetShow(true)
        value.ui.cardText:SetAlphaExtraChild((posIndex + 0.75) * 2)
      elseif posIndex > 4.25 and posIndex <= 4.75 then
        value.ui.cardText:SetShow(true)
        value.ui.cardText:SetAlphaExtraChild((4.75 - posIndex) * 2)
      else
        value.ui.cardText:SetShow(false)
      end
    end
  end
end
function MentalKnowledge_UpdatePosition(deltaTime)
  updateCenterUIPos(deltaTime)
  updateRotateProcess(deltaTime)
  updateAnimationList(deltaTime)
  updateCenterBackground(deltaTime)
  updateRightUIPos(deltaTime, false)
end
local function selectCardReset()
  selectCardIndex = -1
  DragManager:clearInfo()
end
function MentalKnowledge_CardRotation_Left()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local maxValue = mentalObject:getCardCount() - 5
  scrollPositionResult = math.min(scrollPositionResult + 5, maxValue)
  updateCardScrollButton()
end
function MentalKnowledge_CardRotation_Right()
  local right = mgUI.right
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local totalCard = mentalObject:getCardCount()
  scrollPositionResult = math.max(scrollPositionResult - 5, 0)
  updateCardScrollButton()
end
function MentalKnowledge_OnLDown_Card(cardIndex)
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local cardWrapper = mentalObject:getCard(cardIndex)
  if nil == cardWrapper then
    return
  end
  if true == mentalObject:isSelectedCard(cardWrapper) then
    return
  end
  selectCardIndex = cardIndex
  DragManager:setDragInfo(nil, nil, cardIndex, cardWrapper:getPicture(), nil, nil)
end
function MentalKnowledge_OnRDown_Card(cardIndex)
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  if cardIndex < mentalObject:getCardCount() then
    if gameStep < 2 then
      local value = mentalObject:getCard(cardIndex)
      if nil ~= value then
        local staticKey = value:getStaticStatus():getKey()
        if false == mentalObject:isSelectedCard(value) then
          RequestMentalGame_selectCardByKey(staticKey, 99)
          audioPostEvent_SystemUi(0, 2)
        end
      end
    end
    selectCardIndex = -1
    DragManager:clearInfo()
  end
end
function MentalKnowledge_OnLDown()
  selectCardReset()
end
function MentalKnowledge_OnLUp()
  selectCardReset()
end
function MentalKnowledge_OnRDown()
  isRdown = true
  rMovePos = {
    x = getMousePosX(),
    y = getMousePosY()
  }
  selectCardReset()
end
function MentalKnowledge_OnRUp()
  isRdown = false
  selectCardReset()
end
function MentalKnowledge_OnWheelUp()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  mentalObject:scaling(0.1)
end
function MentalKnowledge_OnWheelDown()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  mentalObject:scaling(-0.1)
end
local overKey = -1
function MentalKnowledge_Over(mouseOverKey, isInserted, isShow)
  local tooltip = mgUI.tooltip
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  if gameStep < 2 then
    if mouseOverKey == overKey then
      if false == isShow then
        tooltip.panel:SetShow(false, false)
        overKey = -1
      end
    elseif isShow then
      local targetUI
      local isSuccess = true
      if isInserted then
        isSuccess = updateTooltipContext(mentalObject:getCardBySlotIndex(mouseOverKey), isInserted, mouseOverKey)
        uiGroup = centerUiList[mouseOverKey]
        if nil ~= centerUiList[mouseOverKey] then
          targetUI = centerUiList[mouseOverKey].panel
        end
      else
        isSuccess = updateTooltipContext(mentalObject:getCard(mouseOverKey), isInserted, mouseOverKey)
        if nil ~= rightCardList[mouseOverKey] and nil ~= rightCardList[mouseOverKey].ui then
          targetUI = rightCardList[mouseOverKey].ui.cardIcon
        end
      end
      if isSuccess then
        tooltip.panel:SetShow(true, false)
        overKey = mouseOverKey
        if nil ~= targetUI then
          tooltip.panel:SetPosX(targetUI:GetParentPosX() - (tooltip.panel:GetSizeX() - 40))
          tooltip.panel:SetPosY(math.max(0, targetUI:GetParentPosY() - (tooltip.panel:GetSizeY() - 50)))
        end
      end
    end
  end
end
function MentalKnowledge_UpdateCenterSlot(key)
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local value = mentalObject:getCard(selectCardIndex)
  if selectCardIndex < mentalObject:getCardCount() and nil ~= value then
    if false == mentalObject:isSelectedCard(value) then
      audioPostEvent_SystemUi(0, 2)
    end
    RequestMentalGame_clearSelectCard(key)
    local staticKey = value:getStaticStatus():getKey()
    RequestMentalGame_selectCardByKey(staticKey, key)
    selectCardIndex = -1
    DragManager:clearInfo()
  else
    RequestMentalGame_clearSelectCard(key)
    MentalKnowledge_Over(key, true, false)
  end
  if mentalObject:getCardBySlotIndex(key) ~= nil then
    audioPostEvent_SystemUi(0, 2)
  end
end
function MentalKnowledge_InsertCard(key)
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  if selectCardIndex < mentalObject:getCardCount() then
    if gameStep < 2 then
      local value = mentalObject:getCard(selectCardIndex)
      if nil ~= value then
        local staticKey = value:getStaticStatus():getKey()
        RequestMentalGame_selectCardByKey(staticKey, 99)
      end
    end
    selectCardIndex = -1
    DragManager:clearInfo()
  end
end
function MentalKnowledge_ClearCard(key)
  RequestMentalGame_clearSelectCard(key)
  MentalKnowledge_Over(key, true, false)
end
function MentalKnowledge_Apply_LClick()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  RequestMentalGame_startCard()
  DragManager:clearInfo()
  centerUiList[mentalObject:getOrder(0)].circularProgress:SetProgressRate(100)
  local right = mgUI.right
  right.apply:SetShow(false)
end
function MentalKnowledge_GameEnd_LClick()
  RequestMentalGame_endGame()
  local mentalStage = RequestMentalGame_getMentalStage()
  if false == mentalStage._isSuccess then
    endUIProcess()
    return
  end
  gameStep = 4
  updateStateUIShow()
  hideDeltaTime = 0
  endTimechk = 0
  local talker = dialog_getTalker()
  local intimacy = 0
  if nil ~= talker then
    intimacy = talker:getIntimacy()
  end
  local addIntimacyValue = addIntimacy
  local resultIntimacy = intimacy + addIntimacyValue
  local center = mgUI.center
  local tempString = PAGetStringParam2(Defines.StringSheet_GAME, "MENTALGAME_AQUIRE_INTIMACY_POINT", "result", tostring(resultIntimacy), "point", tostring(addIntimacyValue))
  center.finishText:SetText(tempString)
  audioPostEvent_SystemUi(4, 3)
  mentalGame_End = true
end
function MentalKnowledge_TryAgain_LClick()
  gameStep = 0
  _bestPoint = 0
  gameStartInit()
  RequestMentalGame_restartCard()
end
function MentalKnowledge_InformationUIFontAlpha(srcKey, dstKey, alpha, isOver)
  if nil == informationUI[srcKey] or nil == informationUI[srcKey][dstKey] then
    return
  end
  if isOver and gameStep > 1 then
    return
  end
  informationUI[srcKey][dstKey].nameTag:SetFontAlpha(alpha)
end
function FruitageGift_ShowTooltip(Name, Desc, X, Y)
  mgUI.left.giftNotice:SetText(Name .. " : " .. Desc)
  mgUI.left.giftNotice:SetSize(mgUI.left.giftNotice:GetTextSizeX() + 15, mgUI.left.giftNotice:GetSizeY())
  mgUI.left.giftNotice:SetPosX(X)
  mgUI.left.giftNotice:SetPosY(Y - mgUI.left.giftNotice:GetSizeY())
  mgUI.left.giftNotice:SetShow(true)
end
function FruitageGift_HideTooltip()
  mgUI.left.giftNotice:SetShow(false)
end
local uv = {
  [0] = {
    x1 = 0,
    y1 = 0,
    x2 = 0,
    y2 = 0
  },
  [1] = {
    x1 = 1,
    y1 = 258,
    x2 = 245,
    y2 = 325
  },
  [2] = {
    x1 = 246,
    y1 = 258,
    x2 = 490,
    y2 = 325
  },
  [3] = {
    x1 = 1,
    y1 = 326,
    x2 = 245,
    y2 = 393
  },
  [4] = {
    x1 = 246,
    y1 = 326,
    x2 = 490,
    y2 = 393
  },
  [5] = {
    x1 = 1,
    y1 = 394,
    x2 = 245,
    y2 = 461
  }
}
local function updateNextTryEvent()
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local nextSlot = mentalObject:getNextSlot()
  if nextSlot > 0 then
    local prevSlot = nextSlot - 1
    local index = mentalObject:getOrder(prevSlot)
    if centerUiList[index] == nil or centerUiList[index].SuccessIcon == nil then
      return
    end
    centerUiList[index].SuccessIcon:ResetVertexAni()
    centerUiList[index].FailedIcon:ResetVertexAni()
    centerUiList[index].SuccessIcon:SetShow(false)
    centerUiList[index].FailedIcon:SetShow(false)
    if mentalObject:isComboSuccess() then
      centerUiList[index].panel:AddEffect("fUI_KnowledgeNotice02", false, 0, 0)
      centerUiList[index].SuccessIcon:SetVertexAniRun("Ani_Color_New", true)
      centerUiList[index].SuccessIcon:SetVertexAniRun("Ani_Move_Pos_New", true)
      centerUiList[index].SuccessIcon:SetShow(true)
      audioPostEvent_SystemUi(4, 9)
    else
      centerUiList[index].FailedIcon:SetVertexAniRun("Ani_Color_New", true)
      centerUiList[index].FailedIcon:SetVertexAniRun("Ani_Move_Pos_New", true)
      centerUiList[index].FailedIcon:SetShow(true)
      audioPostEvent_SystemUi(4, 8)
    end
    local lastIndex = mentalObject:getOrderCount() - 1
    local nextIndex = mentalObject:getOrder(nextSlot)
    if mentalObject:getHasNextSlot() and nil ~= centerUiList[nextIndex] then
      centerUiList[nextIndex].circularProgress:SetCurrentControlPos(0)
      centerUiList[nextIndex].circularProgress:SetProgressRate(100)
    end
    local isFirst = true
    for index = nextSlot, lastIndex do
      local isApplied = mentalObject:isAppliedEffect(prevSlot, index)
      local isFirstAnimation = false
      if isFirst and nil ~= mentalObject:getCardBySlotOrder(index) then
        isFirst = false
        isFirstAnimation = true
      end
      if isApplied or isFirstAnimation then
        if isFirstAnimation then
          animationUIList[prevSlot][index].pointImage:SetColor(Defines.Color.C_FFEF9C7F)
        else
          animationUIList[prevSlot][index].pointImage:SetColor(Defines.Color.C_FFFFFFFF)
        end
        local playCount = index - prevSlot - mentalObject:getEmptyCount(prevSlot, index)
        addAnimation(animationUIList[prevSlot][index].panel, 0, mentalObject:getMentalGameSpeed() / 1000 * playCount, prevSlot, index, posUpdateAnimation)
        addAnimation(informationUI[prevSlot][index].nameTag, 0, mentalObject:getMentalGameSpeed() / 1000 * playCount, prevSlot, index, fontalphaUpdateAnimation)
      end
    end
  end
end
function MentalGame_updateMatrix()
  removeCircleLineAndObject()
  insertCircleLineAndObject()
  updateCenterUIPos(0)
end
function MentalGame_StateUpdate(isNext)
  local mentalObject = getMentalgameObject()
  if nil == mentalObject then
    return
  end
  local count = mentalObject:getSlotCount()
  for index = 0, count - 1 do
    local cardWrapper = mentalObject:getCardBySlotIndex(index)
    if nil ~= centerUiList[index] and nil ~= centerUiList[index].panel then
      local target = centerUiList[index].panel
      if nil ~= cardWrapper then
        target:ChangeTextureInfoName(cardWrapper:getPicture())
      else
        target:ChangeTextureInfoName("")
      end
      target:SetShow(true, false)
    end
  end
  local minCardSlotCount = mentalObject:getMinCardSlotCount()
  local filledSlotCount = mentalObject:getFilledSlotCount()
  mgUI.base.comment_Value:SetText(tostring(minCardSlotCount - filledSlotCount))
  if minCardSlotCount <= filledSlotCount then
    if 0 == gameStep then
      gameStep = 1
    end
  elseif 1 == gameStep then
    gameStep = 0
  end
  removeCircleLineAndObject()
  insertCircleLineAndObject()
  updateState()
  updateStateUIShow()
  updateCardColor()
  updateCardScrollButton()
  local right = mgUI.right
  local count = mentalObject:getCardCount()
  for index = 0, count - 1 do
    local cardWrapper = mentalObject:getCard(index)
    if nil ~= rightCardList[index] and nil ~= rightCardList[index].ui and nil ~= rightCardList[index].ui.cardIcon then
      rightCardList[index].ui.cardIcon:SetMonoTone(mentalObject:isBanedCard(cardWrapper))
    end
  end
  if isNext then
    updateNextTryEvent()
  end
end
function MentalGame_tryCard(slotIndex)
  gameStep = 2
  maxPointUpdate()
end
function MentalGame_Simpletooltips(isShow, tipType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  local self = mgUI.left
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "MENTAL_LEFT_TEXT_COMBOCOUNT")
    control = mgUI.left.comboCount
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_INTERESTING_FAILED")
    control = mgUI.left.failCount
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_ACC_INTERESTING")
    control = mgUI.left.cumulativePoint
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "MENTALGAME_TALK_MOST_INTERESTING")
    control = mgUI.left.bestPoint
  end
  TooltipSimple_Show(control, name, desc)
end
function MentalGame_endStage(addedIntimacy)
  gameStep = 3
  local mentalStage = RequestMentalGame_getMentalStage()
  maxPointUpdate()
  if mentalStage._isSuccess then
    addIntimacy = addIntimacy + addedIntimacy
  else
    addIntimacy = 0
  end
  local intimacyText = tostring(addIntimacy)
  if addedIntimacy >= 0 then
    intimacyText = "+" .. intimacyText
  end
  local base = mgUI.base
  local left = mgUI.left
  left.fruitage_Add:SetText(intimacyText)
  if 0 == addIntimacy then
    base.result:SetText(PAGetString(Defines.StringSheet_GAME, "MENTALGAME_INTIMACY_ACQUIRE_EMPTY"))
  else
    base.result:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "MENTALGAME_INTIMACY_ACQUIRE", "count", intimacyText))
  end
  base.nextFail:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "MENTALGAME_INTIMACY_ACQUIRE", "count", tostring(addIntimacy)))
  updateState()
  updateStateUIShow()
end
function MentalGame_UpdateEndTimer(deltaTime)
  endTimechk = endTimechk + deltaTime
  if endTimechk > 5 and true == mentalGame_End then
    MentalGame_Hide()
    mentalGame_End = false
  end
  if endTimechk > 6 then
    endTimechk = 0
  end
end
function MentalGame_UpdateHideTime(deltaTime)
  hideDeltaTime = hideDeltaTime + deltaTime
  if constValue.hideTime <= hideDeltaTime and gameStep == 4 then
    endUIProcess()
  end
end
mentalGameinit()
renderMode:setClosefunctor(renderMode, MentalGame_HideByDamage)
