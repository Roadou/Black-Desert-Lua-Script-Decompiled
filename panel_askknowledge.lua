Panel_AskKnowledge:SetShow(false, false)
Panel_AskKnowledge:setMaskingChild(true)
Panel_AskKnowledge:ActiveMouseEventEffect(true)
Panel_AskKnowledge:setGlassBackground(true)
local _uiBackGround = UI.getChildControl(Panel_AskKnowledge, "Static_BackGround")
local _styleButton = UI.getChildControl(Panel_AskKnowledge, "Style_Button")
local _scroll = UI.getChildControl(Panel_AskKnowledge, "VerticalScroll")
local _scrollIndex = 0
local _knowledgeSize
_styleButton:SetShow(false)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PP = CppEnums.PAUIMB_PRIORITY
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
local buttonGap = 5
Panel_AskKnowledge:RegisterShowEventFunc(true, "AskKnowledgeShowAni()")
Panel_AskKnowledge:RegisterShowEventFunc(false, "AskKnowledgeHideAni()")
function AskKnowledgeShowAni()
  UIAni.fadeInSCR_Down(Panel_AskKnowledge)
  audioPostEvent_SystemUi(1, 0)
  _AudioPostEvent_SystemUiForXBOX(1, 0)
end
function AskKnowledgeHideAni()
  Panel_AskKnowledge:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_AskKnowledge:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(Defines.Color.C_FFFFFFFF)
  aniInfo1:SetEndColor(Defines.Color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
end
local askKnowledge = {}
function askKnowledge.createSlot(index)
  local uiAskButton = {}
  uiAskButton._base = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, Panel_AskKnowledge, "ButtonKnowledge_" .. index)
  CopyBaseProperty(_styleButton, uiAskButton._base)
  uiAskButton._base:SetShow(true)
  uiAskButton._base:addInputEvent("Mouse_LUp", "clickAskKnowledge(" .. index .. ")")
  uiAskButton._base:SetPosY(60 + index * uiAskButton._base:GetSizeY() + (index - 1) * buttonGap)
  uiAskButton._base:addInputEvent("Mouse_UpScroll", "askKnowledge_Scroll( true )")
  uiAskButton._base:addInputEvent("Mouse_DownScroll", "askKnowledge_Scroll( false )")
  function uiAskButton:SetShow(isShow)
    uiAskButton._base:SetShow(isShow)
  end
  function uiAskButton:SetButtonData(data)
    uiAskButton._base:SetText(data:getName())
  end
  return uiAskButton
end
local AskKnowledgeManager = {
  _dataList = {},
  _buttonCount = 8,
  _uiButtonKnowledgeList = {}
}
function AskKnowledgeManager:initialize()
  for index = 0, self._buttonCount - 1 do
    self._uiButtonKnowledgeList[index] = askKnowledge.createSlot(index)
    self._uiButtonKnowledgeList[index]:SetShow(false)
  end
  UIScroll.InputEvent(_scroll, "askKnowledge_Scroll")
  _uiBackGround:addInputEvent("Mouse_UpScroll", "askKnowledge_Scroll( true )")
  _uiBackGround:addInputEvent("Mouse_DownScroll", "askKnowledge_Scroll( false )")
end
function AskKnowledgeManager:update()
  Panel_AskKnowledge:SetShow(true, true)
  local count = _knowledgeSize
  if count > 5 then
    _scroll:SetShow(true)
  else
    _scroll:SetShow(false)
  end
  for index = 0, 4 do
    if count > _scrollIndex + index then
      local data = ToClient_GetKnowledgeStatus(_scrollIndex + index)
      self._uiButtonKnowledgeList[index]:SetButtonData(data)
      self._uiButtonKnowledgeList[index]:SetShow(true)
    else
      self._uiButtonKnowledgeList[index]:SetShow(false)
    end
  end
end
AskKnowledgeManager:initialize()
function FromClient_AskKnowledge()
  _scroll:SetControlPos(0)
  _scrollIndex = 0
  _knowledgeSize = ToClient_GetKnowledgeSize()
  AskKnowledgeManager:update()
end
function askKnowledge_Scroll(isUp)
  _scrollIndex = UIScroll.ScrollEvent(_scroll, isUp, 5, _knowledgeSize, _scrollIndex, 1)
  AskKnowledgeManager:update()
end
function clickAskKnowledge(index)
  Panel_AskKnowledge:SetShow(false, false)
  local clickedKnowledge = ToClient_GetKnowledgeStatus(_scrollIndex + index)
  local pos = clickedKnowledge:getPosition()
  setShowNpcDialog(false)
  FGlobal_PushOpenWorldMap()
  FromClient_KnowledgeWorldMapPath(float3(pos.x, 0, pos.z))
end
registerEvent("FromClient_AskKnowledge", "FromClient_AskKnowledge")
