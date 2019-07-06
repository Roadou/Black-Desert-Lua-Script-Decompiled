Panel_Interest_Knowledge:SetShow(false, false)
Panel_Interest_Knowledge:RegisterShowEventFunc(true, "InterestKnowledgeShowAni()")
Panel_Interest_Knowledge:RegisterShowEventFunc(false, "InterestKnowledgeHideAni()")
local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local uiBackGround = UI.getChildControl(Panel_Interest_Knowledge, "Static_Interest_KnowledgeBG")
local needKnowledgeText = UI.getChildControl(Panel_Interest_Knowledge, "StaticText_Need_Knowledge")
local _knowledgeList = UI.getChildControl(Panel_Interest_Knowledge, "StaticText_Knowledge_List")
local _scroll = UI.getChildControl(Panel_Interest_Knowledge, "VerticalScroll")
local _scrollCtrlBtn = UI.getChildControl(_scroll, "VerticalScroll_CtrlButton")
local stc_titleBG = UI.getChildControl(Panel_Interest_Knowledge, "Static_TitleBg")
local uiText = {}
local scrollIndex = 0
local Panel_Interest_Knowledge_Value_elementCount = 0
needKnowledgeText:SetTextMode(UI_TM.eTextMode_AutoWrap)
needKnowledgeText:SetFontColor(Defines.Color.C_FF96D4FC)
function InterestKnowledgeShowAni()
end
function InterestKnowledgeHideAni()
end
function Dialog_InterestKnowledgeUpdate()
  local talker = dialog_getTalker()
  if nil == talker then
    return
  end
  local actorKeyRaw = talker:getActorKey()
  local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local mentalObject = knowledge:getThemeByKeyRaw(npcActorProxyWrapper:getNpcThemeKey())
  if nil == mentalObject then
    Panel_Interest_Knowledge_Hide()
    return
  end
  InterestKnowledge_SetText(mentalObject, npcActorProxyWrapper)
end
local constSizeX = Panel_Interest_Knowledge:GetSizeX()
local constSizeY = Panel_Interest_Knowledge:GetSizeY()
local _listPosY = _knowledgeList:GetPosY()
local _scrollSize = _knowledgeList:GetSizeY()
local uiBG_PosY = uiBackGround:GetPosY()
local _scroll_PosY = _scroll:GetPosY()
local _needKnowledgeTextSize = needKnowledgeText:GetSizeY()
local _needKnowledgeTextGap = 19
local _knowledgeMaxCount = 8
local originPanelSizeX = Panel_Interest_Knowledge:GetSizeX()
local uiBackGroundSizeX = uiBackGround:GetSizeX()
local stc_titleBGSizeX = stc_titleBG:GetSizeX()
local needKnowledgeTextSizeX = needKnowledgeText:GetSizeX()
function InterestKnowledge_SetText(theme, npcActorProxyWrapper)
  local _needKnowledge = npcActorProxyWrapper:getNpcTheme()
  local _needCount = npcActorProxyWrapper:getNeedCount()
  local _currCount = getKnowledgeCountMatchTheme(npcActorProxyWrapper:getNpcThemeKey())
  local _currentKnowledge = ""
  for index = 0, _knowledgeMaxCount - 1 do
    local _childCard = theme:getChildCardByIndex(index + scrollIndex)
    if nil == _childCard then
      uiText[index]:SetShow(false)
    else
      uiText[index]:SetText(_childCard:getName())
      uiText[index]:SetPosY(_listPosY + _needKnowledgeTextGap * index)
      uiText[index]:SetShow(true)
    end
  end
  needKnowledgeText:SetText(_needKnowledge .. " ( " .. _currCount .. "/" .. theme:getChildCardCount() .. " ) ")
  Panel_Interest_Knowledge_Show()
  Panel_Interest_Knowledge_Value_elementCount = theme:getChildCardCount()
  local isGameTypeDE = CppEnums.ServiceResourceType.eServiceResourceType_DE == getGameServiceResType()
  if isGameTypeDE then
    local panel = Panel_Interest_Knowledge
    local btn_question = UI.getChildControl(panel, "Button_Question")
    local vScroll = UI.getChildControl(panel, "VerticalScroll")
    uiBackGround:SetSize(uiBackGroundSizeX + 100, uiBackGround:GetSizeY())
    stc_titleBG:SetSize(stc_titleBGSizeX + 100, stc_titleBG:GetSizeY())
    needKnowledgeText:SetSize(needKnowledgeTextSizeX + 100, needKnowledgeText:GetSizeY())
    constSizeX = originPanelSizeX + 100
    panel:ComputePos()
    btn_question:ComputePos()
    vScroll:ComputePos()
  end
  if _needKnowledgeTextSize < needKnowledgeText:GetSizeY() then
    Panel_Interest_Knowledge:SetSize(constSizeX, constSizeY + _needKnowledgeTextGap)
    uiBackGround:SetPosY(uiBG_PosY + _needKnowledgeTextGap)
    _scroll:SetPosY(_scroll_PosY + _needKnowledgeTextGap)
    uiText_RePosY(_knowledgeMaxCount, true)
  else
    Panel_Interest_Knowledge:SetSize(constSizeX, constSizeY)
    uiBackGround:SetPosY(uiBG_PosY)
    _scroll:SetPosY(_scroll_PosY)
    uiText_RePosY(_knowledgeMaxCount, false)
  end
  if Panel_Interest_Knowledge_Value_elementCount > _knowledgeMaxCount then
    _scroll:SetShow(true)
  else
    _scroll:SetShow(false)
  end
  UIScroll.SetButtonSize(_scroll, _knowledgeMaxCount, Panel_Interest_Knowledge_Value_elementCount)
end
function uiText_RePosY(count, isReposition)
  if true == isReposition then
    for i = 0, count - 1 do
      uiText[i]:SetPosY(uiBG_PosY + 6 + _needKnowledgeTextGap + _needKnowledgeTextGap * i)
    end
  else
    for i = 0, count - 1 do
      uiText[i]:SetPosY(uiBG_PosY + 6 + _needKnowledgeTextGap * i)
    end
  end
end
function InterestKnowledge_UpScroll()
  InterestKnowledge_Scroll(true)
end
function InterestKnowledge_DownScroll()
  InterestKnowledge_Scroll(false)
end
function InterestKnowledge_Scroll(isUp)
  scrollIndex = UIScroll.ScrollEvent(_scroll, isUp, _knowledgeMaxCount, Panel_Interest_Knowledge_Value_elementCount, scrollIndex, 1)
  Dialog_InterestKnowledgeUpdate()
end
function Panel_Interest_Knowledge_Show()
  Panel_Interest_Knowledge:SetShow(true, true)
end
function PaGlobalFunc_Panel_Interest_Knowledge_ShowToggle()
  if Panel_Interest_Knowledge:IsShow() then
    Panel_Interest_Knowledge_Hide()
  else
    Dialog_InterestKnowledgeUpdate()
  end
end
function Panel_Interest_Knowledge_Hide()
  Panel_Interest_Knowledge:SetShow(false, false)
  scrollIndex = 0
  _scrollCtrlBtn:SetPosY(0)
end
function InterestKnowledge_onScreenResize()
  local scrY = getScreenSizeY()
  local dialogSizeY = 0
  if true == _ContentsGroup_RenewUI_Dailog then
    Panel_Interest_Knowledge:SetPosY(scrY - (PaGlobalFunc_MainDialog_Bottom_GetSizeY() + Panel_Interest_Knowledge:GetSizeY() + 50))
  else
    if false == _ContentsGroup_NewUI_Dialog_All then
      dialogSizeY = Panel_Npc_Dialog:GetSizeY()
    else
      dialogSizeY = Panel_Npc_Dialog_All:GetSizeY()
    end
    Panel_Interest_Knowledge:SetPosY(scrY - (dialogSizeY + Panel_Interest_Knowledge:GetSizeY() + 50))
  end
end
function InterestKnowledge_Init()
  for index = 0, _knowledgeMaxCount - 1 do
    uiText[index] = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Interest_Knowledge, "StaticText_InterestKnowledgeList_" .. index)
    CopyBaseProperty(_knowledgeList, uiText[index])
  end
  Panel_Interest_Knowledge:RemoveControl(_knowledgeList)
  _knowledgeList = nil
  UIScroll.InputEvent(_scroll, "InterestKnowledge_Scroll")
  uiBackGround:addInputEvent("Mouse_UpScroll", "InterestKnowledge_Scroll( true )")
  uiBackGround:addInputEvent("Mouse_DownScroll", "InterestKnowledge_Scroll( false )")
end
InterestKnowledge_Init()
InterestKnowledge_onScreenResize()
local _buttonQuestion = UI.getChildControl(Panel_Interest_Knowledge, "Button_Question")
_buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelImportantKnowledge\" )")
_buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelImportantKnowledge\", \"true\")")
_buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelImportantKnowledge\", \"false\")")
