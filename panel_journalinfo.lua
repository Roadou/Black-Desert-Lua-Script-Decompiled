Panel_JournalInfo:SetShow(false)
local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local uiBackGround = UI.getChildControl(Panel_JournalInfo, "Static_JournalInfo_BG")
local needJournalText = UI.getChildControl(Panel_JournalInfo, "StaticText_NeedJournal")
local _journalInfoList = UI.getChildControl(Panel_JournalInfo, "StaticText_JournalInfo_List")
local _scroll = UI.getChildControl(Panel_JournalInfo, "VerticalScroll")
local _scrollCtrlBtn = UI.getChildControl(_scroll, "VerticalScroll_CtrlButton")
local uiText = {}
local scrollIndex = 0
local Panel_JournalInfo_Value_elementCount = 0
needJournalText:SetTextMode(UI_TM.eTextMode_AutoWrap)
needJournalText:SetAutoResize(true)
needJournalText:SetFontColor(Defines.Color.C_FF96D4FC)
local constSizeX = Panel_JournalInfo:GetSizeX()
local constSizeY = Panel_JournalInfo:GetSizeY()
local _listPosY = _journalInfoList:GetPosY()
local _scrollSize = _journalInfoList:GetSizeY()
local uiBG_PosY = uiBackGround:GetPosY()
local _scroll_PosY = _scroll:GetPosY()
local _needJournalTextSize = needJournalText:GetSizeY()
local _needJournalTextGap = 19
local _journalInfoMaxCount = 9
Panel_JournalInfo:RegisterShowEventFunc(true, "Journal_ShowAni()")
Panel_JournalInfo:RegisterShowEventFunc(false, "Journal_HideAni()")
function Journal_ShowAni()
end
function Journal_HideAni()
end
function FromClient_JournalInfo_UpdateText()
  Panel_JournalInfo_Value_elementCount = ToClient_GetJournalListCount(2014, 11, 0)
  for index = 0, _journalInfoMaxCount - 1 do
    local _journalInfo = ToClient_GetJournal(2014, 11, 0, index + scrollIndex)
    if nil == _journalInfo then
      uiText[index]:SetShow(false)
    else
      uiText[index]:SetText(_journalInfo:getJournalYear() .. "/" .. _journalInfo:getJournalMonth() .. "/" .. _journalInfo:getJournalDay() .. " " .. _journalInfo:getJournalHour() .. ":" .. _journalInfo:getJournalMinute() .. ":" .. _journalInfo:getJournalSecond() .. " " .. _journalInfo:getName())
      uiText[index]:SetPosY(_listPosY + _needJournalTextGap * index)
      uiText[index]:SetShow(true)
    end
  end
  if Panel_JournalInfo_Value_elementCount > _journalInfoMaxCount then
    _scroll:SetShow(true)
  else
    _scroll:SetShow(false)
  end
  UIScroll.SetButtonSize(_scroll, _journalInfoMaxCount, Panel_JournalInfo_Value_elementCount)
end
function uiText_RePosY(count, isReposition)
  if true == isReposition then
    for i = 0, count - 1 do
      uiText[i]:SetPosY(uiBG_PosY + 6 + _needJournalTextGap + _needJournalTextGap * i)
    end
  else
    for i = 0, count - 1 do
      uiText[i]:SetPosY(uiBG_PosY + 6 + _needJournalTextGap * i)
    end
  end
end
function JournalInfo_Scroll(isUp)
  scrollIndex = UIScroll.ScrollEvent(_scroll, isUp, _journalInfoMaxCount, Panel_JournalInfo_Value_elementCount, scrollIndex, 1)
  FromClient_JournalInfo_UpdateText()
end
function Panel_JournalInfo_Show()
  Panel_JournalInfo:SetShow(true, true)
end
function Panel_JournalInfo_Hide()
  Panel_JournalInfo:SetShow(false, false)
  scrollIndex = 0
  _scrollCtrlBtn:SetPosY(0)
end
function JournalInfo_Init()
  for index = 0, _journalInfoMaxCount - 1 do
    uiText[index] = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_JournalInfo, "StaticText_journalInfoList_" .. index)
    CopyBaseProperty(_journalInfoList, uiText[index])
  end
  Panel_JournalInfo:RemoveControl(_journalInfoList)
  _journalInfoList = nil
  UIScroll.InputEvent(_scroll, "JournalInfo_Scroll")
  uiBackGround:addInputEvent("Mouse_UpScroll", "JournalInfo_Scroll( true )")
  uiBackGround:addInputEvent("Mouse_DownScroll", "JournalInfo_Scroll( false )")
end
function FGlobal_SetShowJournalWindow(isShow)
  if isShow then
    ToClient_RequestJournalList(2014, 11, 0)
    Panel_JournalInfo_Show()
  else
    Panel_JournalInfo_Hide()
  end
end
JournalInfo_Init()
registerEvent("FromClient_JournalInfo_UpdateText", "FromClient_JournalInfo_UpdateText")
