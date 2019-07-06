local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
Instance_Chatting_Filter:RegisterShowEventFunc(true, "ChattingFilterList_ShowAni()")
Instance_Chatting_Filter:RegisterShowEventFunc(false, "ChattingFilterList_HideAni()")
Instance_Chatting_Filter:SetShow(false, false)
Instance_Chatting_Filter:ActiveMouseEventEffect(true)
Instance_Chatting_Filter:setGlassBackground(true)
local ChattingFilter = {
  ui = {
    title = UI.getChildControl(Instance_Chatting_Filter, "StaticText_Title"),
    main_BG = UI.getChildControl(Instance_Chatting_Filter, "Static_MainBg"),
    btn_Close = UI.getChildControl(Instance_Chatting_Filter, "Button_Win_Close"),
    bg = UI.getChildControl(Instance_Chatting_Filter, "Static_BG"),
    edit_Filter = UI.getChildControl(Instance_Chatting_Filter, "Edit_Filter"),
    btn_Filter = UI.getChildControl(Instance_Chatting_Filter, "Button_Yes"),
    btn_Reset = UI.getChildControl(Instance_Chatting_Filter, "Button_Reset"),
    desc_Txt = UI.getChildControl(Instance_Chatting_Filter, "StaticText_Desc"),
    temp_FilterBG = UI.getChildControl(Instance_Chatting_Filter, "Static_SlotBG"),
    temp_Filter_ItemName = UI.getChildControl(Instance_Chatting_Filter, "StaticText_FilterName"),
    temp_Button_Delete = UI.getChildControl(Instance_Chatting_Filter, "Button_Delete"),
    scroll = UI.getChildControl(Instance_Chatting_Filter, "Scroll_List")
  },
  config = {
    maxFilterCount = 8,
    totalFilterCount = 0,
    startIndex = 0
  },
  uiPool = {}
}
local _buttonQuestion = UI.getChildControl(Instance_Chatting_Filter, "Button_Question")
_buttonQuestion:SetShow(false)
function ChattingFilterList_ShowAni()
  local aniInfo1 = Instance_Chatting_Filter:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.12)
  aniInfo1.AxisX = Instance_Chatting_Filter:GetSizeX() / 2
  aniInfo1.AxisY = Instance_Chatting_Filter:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Instance_Chatting_Filter:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.12)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Instance_Chatting_Filter:GetSizeX() / 2
  aniInfo2.AxisY = Instance_Chatting_Filter:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function ChattingFilterList_HideAni()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  local aniInfo1 = Instance_Chatting_Filter:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
function ChattingFilter:Init()
  for slotIdx = 0, self.config.maxFilterCount - 1 do
    self.uiPool[slotIdx] = {}
    local slot = self.uiPool[slotIdx]
    slot.FilterNameBG = UI.createAndCopyBasePropertyControl(Instance_Chatting_Filter, "Static_SlotBG", self.ui.bg, "ChattingFilter_BG_" .. slotIdx)
    slot.FilterName = UI.createAndCopyBasePropertyControl(Instance_Chatting_Filter, "StaticText_FilterName", slot.FilterNameBG, "ChattingFilter_FilterItemName_" .. slotIdx)
    slot.Delete = UI.createAndCopyBasePropertyControl(Instance_Chatting_Filter, "Button_Delete", slot.FilterNameBG, "ChattingFilter_FilterDeleteBtn_" .. slotIdx)
    slot.FilterNameBG:SetPosX(8)
    slot.FilterNameBG:SetPosY(5 + (slot.FilterNameBG:GetSizeY() + 5) * slotIdx)
    slot.FilterName:SetPosX(12)
    slot.FilterName:SetPosY(12)
    slot.Delete:SetPosX(300)
    slot.Delete:SetPosY(5)
    slot.FilterNameBG:SetShow(false)
    slot.FilterNameBG:addInputEvent("Mouse_UpScroll", "Scroll_ChattingFilterList( true )")
    slot.FilterNameBG:addInputEvent("Mouse_DownScroll", "Scroll_ChattingFilterList( false )")
    slot.FilterName:addInputEvent("Mouse_UpScroll", "Scroll_ChattingFilterList( true )")
    slot.FilterName:addInputEvent("Mouse_DownScroll", "Scroll_ChattingFilterList( false )")
    slot.Delete:addInputEvent("Mouse_UpScroll", "Scroll_ChattingFilterList( true )")
    slot.Delete:addInputEvent("Mouse_DownScroll", "Scroll_ChattingFilterList( false )")
    self.ui.btn_Filter:addInputEvent("Mouse_LUp", "ChattingFilter_InsertFilterString()")
    self.ui.btn_Reset:addInputEvent("Mouse_LUp", "ChattingFilter_ResetFilterString()")
    self.ui.edit_Filter:addInputEvent("Mouse_LUp", "HandleClicked_ChattingFilter_EditName()")
    self.ui.edit_Filter:RegistReturnKeyEvent("ChattingFilter_InsertFilterString()")
    self.ui.temp_FilterBG:SetShow(false)
    self.ui.temp_Filter_ItemName:SetShow(false)
    self.ui.temp_Button_Delete:SetShow(false)
    self.ui.scroll:SetShow(false)
    self.ui.desc_Txt:SetTextMode(UI_TM.eTextMode_AutoWrap)
    self.ui.desc_Txt:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_FILTER_DESC"))
    self.ui.edit_Filter:SetMaxInput(50)
  end
  local descSizeY = self.ui.desc_Txt:GetTextSizeY() - self.ui.desc_Txt:GetSizeY() + 10
  if descSizeY > 0 then
    self.ui.main_BG:SetSize(self.ui.main_BG:GetSizeX(), self.ui.main_BG:GetSizeY() + descSizeY)
    self.ui.main_BG:ComputePos()
    Instance_Chatting_Filter:SetSize(Instance_Chatting_Filter:GetSizeX(), Instance_Chatting_Filter:GetSizeY() + descSizeY)
    self.ui.btn_Reset:ComputePos()
    self.ui.btn_Filter:ComputePos()
  end
end
ChattingFilter:Init()
function ChattingFilter:Update()
  for slotIdx = 0, self.config.maxFilterCount - 1 do
    local slot = self.uiPool[slotIdx]
    slot.FilterNameBG:SetShow(false)
    self.ui.scroll:SetShow(false)
    slot.Delete:addInputEvent("Mouse_LUp", "")
  end
  self.config.totalFilterCount = ToClient_getBlockStringListCount()
  if 0 >= self.config.totalFilterCount then
    return
  end
  if self.config.totalFilterCount <= self.config.maxFilterCount then
    self.config.startIndex = 0
    self.ui.scroll:SetControlPos(0)
  elseif self.config.totalFilterCount - self.config.startIndex < self.config.maxFilterCount then
    self.config.startIndex = self.config.totalFilterCount - self.config.maxFilterCount
  end
  if self.config.maxFilterCount < self.config.totalFilterCount then
    UIScroll.SetButtonSize(self.ui.scroll, self.config.maxFilterCount, self.config.totalFilterCount)
    self.ui.scroll:SetControlPos(self.config.startIndex / (self.config.totalFilterCount - self.config.maxFilterCount))
  else
    self.ui.scroll:SetShow(false)
  end
  local uiCount = 0
  for slotIdx = self.config.startIndex, self.config.totalFilterCount - 1 do
    if uiCount >= self.config.maxFilterCount then
      break
    end
    local slot = self.uiPool[uiCount]
    local filterStringGet = ToClient_getBlockStringListByIndex(slotIdx)
    slot.FilterNameBG:SetShow(true)
    slot.FilterName:SetTextMode(UI_TM.eTextMode_LimitText)
    slot.FilterName:SetText(tostring(filterStringGet))
    slot.Delete:addInputEvent("Mouse_LUp", "HandleClicked_ChattingFilter_Delete(" .. slotIdx .. ")")
    uiCount = uiCount + 1
  end
end
function ChattingFilter:Open()
  Instance_Chatting_Filter:SetShow(true, true)
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Instance_Chatting_Filter:GetSizeX()
  local panelSizeY = Instance_Chatting_Filter:GetSizeY()
  Instance_Chatting_Filter:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Instance_Chatting_Filter:SetPosY(scrSizeY / 2 - panelSizeY / 2)
  self.ui.scroll:SetControlPos(0)
  self.config.startIndex = 0
  self.config.totalFilterCount = 0
  self:Update()
end
function ChattingFilter:Close()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  Instance_Chatting_Filter:SetShow(false, false)
  self.ui.scroll:SetControlPos(0)
  self.config.startIndex = 0
  self.config.totalFilterCount = 0
end
function ChattingFilter_InsertFilterString()
  local self = ChattingFilter
  local filterString = self.ui.edit_Filter:GetEditText()
  if false == ToClient_InsertBlockStringList(filterString) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_FILTER_NOWORD_ACK"))
    self.ui.edit_Filter:SetEditText("", true)
    return
  end
  self.ui.edit_Filter:SetEditText("", true)
  self.config.totalFilterCount = ToClient_getBlockStringListCount()
  self.config.startIndex = math.max(self.config.totalFilterCount - self.config.maxFilterCount, 0)
  ChattingFilter:Update()
end
function ChattingFilter_ResetFilterString()
  ToClient_ClearBlockStringList()
  ChattingFilter:Update()
end
function Scroll_ChattingFilterList(isScrollUp)
  ChattingFilter.config.startIndex = UIScroll.ScrollEvent(ChattingFilter.ui.scroll, isScrollUp, ChattingFilter.config.maxFilterCount, ChattingFilter.config.totalFilterCount, ChattingFilter.config.startIndex, 1)
  ChattingFilter:Update()
end
function HandleClicked_ChattingFilter_EditName()
  SetFocusEdit(ChattingFilter.ui.edit_Filter)
  ChattingFilter.ui.edit_Filter:SetEditText("", true)
end
function FGlobal_ChattingFilter_ClearFocusEdit()
  ClearFocusEdit()
  CheckChattingInput()
end
function FGlobal_ChattingFilter_UiEdit(targetUI)
  return nil ~= targetUI and targetUI:GetKey() == ChattingFilter.ui.edit_Filter:GetKey()
end
function HandleClicked_ChattingFilter_Delete(index)
  ToClient_EraseBlockStringList(index)
  ChattingFilter:Update()
end
function HandleClicked_ChattingFilterList_Close()
  ChattingFilter:Close()
end
function FGlobal_ChattingFilterList_Open()
  ChattingFilter:Open()
end
function FGlobal_ChattingFilterList_Close()
  ChattingFilter:Close()
end
function ChattingFilter:registEventHandler()
  self.ui.btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_ChattingFilterList_Close()")
  self.ui.bg:addInputEvent("Mouse_UpScroll", "Scroll_ChattingFilterList( true )")
  self.ui.bg:addInputEvent("Mouse_DownScroll", "Scroll_ChattingFilterList( false )")
  UIScroll.InputEvent(self.ui.scroll, "Scroll_ChattingFilterList")
end
function ChattingFilter:registMessageHandler()
end
ChattingFilter:registEventHandler()
ChattingFilter:registMessageHandler()
