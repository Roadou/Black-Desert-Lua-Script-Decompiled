Panel_House_SellBuy_Condition:SetShow(false)
Panel_House_SellBuy_Condition:setGlassBackground(true)
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local UI_PP = CppEnums.PAUIMB_PRIORITY
local nextHouse_List = {}
local prevHouse_List = {}
local total_Cost = 0
local target_UseType
local House_Name_List = {}
local House_List = {}
local tempTable = {}
local currentExplorePoint = 0
House_SellBuy_Condition = {
  conditionKey = -1,
  isNext = nil,
  isAll = false,
  isFirst = false,
  checkBuyAll = true,
  sellBuy_Index = nil
}
local default_Control = {
  _Title = UI.getChildControl(Panel_House_SellBuy_Condition, "StaticText_Condtion_Title"),
  _Btn_Close = UI.getChildControl(Panel_House_SellBuy_Condition, "Button_Win_Close"),
  _Desc = UI.getChildControl(Panel_House_SellBuy_Condition, "StaticText_Condition_Description"),
  _Cost_Title = UI.getChildControl(Panel_House_SellBuy_Condition, "StaticText_Condtion_Cost_Title"),
  _Cost_BG = UI.getChildControl(Panel_House_SellBuy_Condition, "Static_Condition_Cost_BG"),
  _Cost_Need = nil,
  _Cost_Need_Value = nil,
  _Cost_Have = nil,
  _Cost_Have_Value = nil,
  _List_Title = UI.getChildControl(Panel_House_SellBuy_Condition, "StaticText_Condition_List_Title"),
  _List_BG = UI.getChildControl(Panel_House_SellBuy_Condition, "Static_Condition_List_BG"),
  _List_Scroll = UI.getChildControl(Panel_House_SellBuy_Condition, "ConditionList_ScrollBar"),
  _List_Scroll_Button = nil,
  _List_Value = {},
  _List_Button = {},
  _List_Button_Text = nil,
  _Btn_All = UI.getChildControl(Panel_House_SellBuy_Condition, "Button_SellBuy_All"),
  _Guide = UI.getChildControl(Panel_House_SellBuy_Condition, "StaticText_Buy_Guide")
}
local template_Control = {
  _Cost_Need = UI.getChildControl(Panel_House_SellBuy_Condition, "StaticText_Condition_Cost_Need"),
  _Cost_Need_Value = UI.getChildControl(Panel_House_SellBuy_Condition, "StaticText_Condition_Cost_Need_Value"),
  _Cost_Have = UI.getChildControl(Panel_House_SellBuy_Condition, "StaticText_Condition_Cost_Have"),
  _Cost_Have_Value = UI.getChildControl(Panel_House_SellBuy_Condition, "StaticText_Condition_Cost_HaveValue"),
  _List_Value = UI.getChildControl(Panel_House_SellBuy_Condition, "Button_Condtion_List_Value"),
  _List_Button = UI.getChildControl(Panel_House_SellBuy_Condition, "Button_Condtion_List_SellBuy")
}
local default_Pos_Size = {
  _Panel_SizeY = 0,
  _Title_SizeY = 0,
  _Desc_PosY = 0,
  _Desc_SizeY = 0,
  _Cost_Title_PosY = 0,
  _Cost_BG_PosY = 0,
  _Cost_BG_SizeY = 0,
  _Cost_BG_SpanX = 0,
  _Cost_BG_SpanY = 0,
  _List_Title_PosY = 0,
  _List_BG_PosY = 0,
  _List_BG_SizeY = 0,
  _List_BG_SpanX = 0,
  _List_BG_SpanY = 0,
  _List_Scroll_PosY = 0,
  _List_Value_SizeX = 0,
  _List_Value_SizeY = 0,
  _List_Button_SizeX = 0,
  _List_Button_SpanX = 0,
  _List_GapX = 10,
  _List_GapY = 35,
  _Btn_All_PosY = 0,
  _Guide_PosY = 0,
  _Guide_SizeY = 0,
  _Guide_GapY = 0,
  _Adjust_1 = 0,
  _Adjust_2 = 0,
  _Adjust_3 = 0
}
local param_Scroll = {
  _offsetIndex = 0,
  _offsetMax = 0,
  _listMax = 3,
  _contentCount = 0
}
local clear_Control = function(target)
  for _, vlaue in pairs(target) do
    vlaue:SetShow(false)
  end
end
function default_Pos_Size:Init()
  self._Panel_SizeY = Panel_House_SellBuy_Condition:GetSizeY()
  self._Title_SizeY = default_Control._Title:GetSizeY()
  self._Desc_PosY = default_Control._Desc:GetPosY()
  self._Desc_SizeY = default_Control._Desc:GetSizeY()
  self._Cost_Title_PosY = default_Control._Cost_Title:GetPosY()
  self._Cost_BG_PosY = default_Control._Cost_BG:GetPosY()
  self._Cost_BG_SizeY = default_Control._Cost_BG:GetSizeY()
  self._Cost_BG_SpanX = default_Control._Cost_BG:GetSpanSize().x
  self._Cost_BG_SpanY = default_Control._Cost_BG:GetSpanSize().y
  self._List_Title_PosY = default_Control._List_Title:GetPosY()
  self._List_BG_PosY = default_Control._List_BG:GetPosY()
  self._List_BG_SizeY = default_Control._List_BG:GetSizeY()
  self._List_BG_SpanX = default_Control._List_BG:GetSpanSize().x
  self._List_BG_SpanY = default_Control._List_BG:GetSpanSize().y
  self._List_Scroll_PosY = default_Control._List_BG:GetPosY()
  self._List_Value_SizeX = template_Control._List_Value:GetSizeX()
  self._List_Value_SizeY = template_Control._List_Value:GetSizeY()
  self._List_Button_SizeX = template_Control._List_Button:GetSizeX()
  self._Btn_All_PosY = default_Control._Btn_All:GetPosY()
  self._Guide_PosY = default_Control._Guide:GetPosY()
  self._Guide_SizeY = default_Control._Guide:GetSizeY()
  self._Guide_GapY = self._Panel_SizeY - self._Guide_PosY
end
default_Pos_Size:Init()
function default_Control:Init()
  self._Title:SetAutoResize(true)
  self._Desc:SetAutoResize(true)
  self._Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._Guide:SetAutoResize(true)
  self._Guide:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._Guide:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_GUIDE"))
  self._Btn_Close:addInputEvent("Mouse_LUp", "HandleClick_House_SellBuy_Close()")
  self._List_Scroll_Button = UI.getChildControl(self._List_Scroll, "Frame_ScrollBar_thumb")
  self._List_BG:addInputEvent("Mouse_UpScroll", "SellBuy_Condition_Scroll(true)")
  self._List_BG:addInputEvent("Mouse_DownScroll", "SellBuy_Condition_Scroll(false)")
  self._List_Scroll:addInputEvent("Mouse_UpScroll", "SellBuy_Condition_Scroll(true)")
  self._List_Scroll:addInputEvent("Mouse_DownScroll", "SellBuy_Condition_Scroll(false)")
  self._List_Scroll:addInputEvent("Mouse_LDown", "SellBuy_Condition_ScrollOnClick()")
  self._List_Scroll:addInputEvent("Mouse_LUp", "SellBuy_Condition_ScrollOnClick()")
  self._List_Scroll_Button:addInputEvent("Mouse_UpScroll", "SellBuy_Condition_Scroll(true)")
  self._List_Scroll_Button:addInputEvent("Mouse_DownScroll", "SellBuy_Condition_Scroll(false)")
  self._List_Scroll_Button:addInputEvent("Mouse_LPress", "SellBuy_Condition_ScrollOnClick()")
  self._Cost_Need = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, self._Cost_BG, "Cost_Need")
  self._Cost_Need_Value = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, self._Cost_BG, "Cost_Need_Value")
  self._Cost_Have = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, self._Cost_BG, "Cost_Have")
  self._Cost_Have_Value = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, self._Cost_BG, "Cost_Have_Value")
  CopyBaseProperty(template_Control._Cost_Need, self._Cost_Need)
  CopyBaseProperty(template_Control._Cost_Need_Value, self._Cost_Need_Value)
  CopyBaseProperty(template_Control._Cost_Have, self._Cost_Have)
  CopyBaseProperty(template_Control._Cost_Have_Value, self._Cost_Have_Value)
  clear_Control(template_Control)
  self._Cost_Need:SetSpanSize(self._Cost_Need:GetSpanSize().x - default_Pos_Size._Cost_BG_SpanX, self._Cost_Need:GetSpanSize().y - default_Pos_Size._Cost_BG_SpanY)
  self._Cost_Need_Value:SetSpanSize(self._Cost_Need_Value:GetSpanSize().x - default_Pos_Size._Cost_BG_SpanX, self._Cost_Need_Value:GetSpanSize().y - default_Pos_Size._Cost_BG_SpanY)
  self._Cost_Have:SetSpanSize(self._Cost_Have:GetSpanSize().x - default_Pos_Size._Cost_BG_SpanX, self._Cost_Have:GetSpanSize().y - default_Pos_Size._Cost_BG_SpanY)
  self._Cost_Have_Value:SetSpanSize(self._Cost_Have_Value:GetSpanSize().x - default_Pos_Size._Cost_BG_SpanX, self._Cost_Have_Value:GetSpanSize().y - default_Pos_Size._Cost_BG_SpanY)
  for idx = 0, param_Scroll._listMax - 1 do
    self._List_Value[idx] = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._List_BG, "List_Value_" .. idx)
    CopyBaseProperty(template_Control._List_Value, self._List_Value[idx])
    self._List_Value[idx]:SetSpanSize(self._List_Value[idx]:GetSpanSize().x - default_Pos_Size._List_BG_SpanX, self._List_Value[idx]:GetSpanSize().y - default_Pos_Size._List_BG_SpanY + default_Pos_Size._List_GapY * idx)
    self._List_Value[idx]:addInputEvent("Mouse_LUp", "HandleClick_ListValueButton(" .. idx .. ")")
    self._List_Value[idx]:addInputEvent("Mouse_UpScroll", "SellBuy_Condition_Scroll(true)")
    self._List_Value[idx]:addInputEvent("Mouse_DownScroll", "SellBuy_Condition_Scroll(false)")
    self._List_Value[idx]:addInputEvent("Mouse_On", "HandleOn_ListValueButton(" .. idx .. ", true)")
    self._List_Value[idx]:addInputEvent("Mouse_Out", "HandleOut_ListValueButton(" .. idx .. ", true)")
    self._List_Button[idx] = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._List_BG, "List_Button_" .. idx)
    CopyBaseProperty(template_Control._List_Button, self._List_Button[idx])
    self._List_Button[idx]:SetSpanSize(self._List_Button[idx]:GetSpanSize().x - default_Pos_Size._List_BG_SpanX, self._List_Button[idx]:GetSpanSize().y - default_Pos_Size._List_BG_SpanY + default_Pos_Size._List_GapY * idx)
    self._List_Button[idx]:addInputEvent("Mouse_LUp", "HandleClick_ListSellBuyButton(" .. idx .. ")")
    self._List_Button[idx]:addInputEvent("Mouse_UpScroll", "SellBuy_Condition_Scroll(true)")
    self._List_Button[idx]:addInputEvent("Mouse_DownScroll", "SellBuy_Condition_Scroll(false)")
    self._List_Button[idx]:addInputEvent("Mouse_On", "HandleOn_ListValueButton(" .. idx .. ", false)")
    self._List_Button[idx]:addInputEvent("Mouse_Out", "HandleOut_ListValueButton(" .. idx .. ", false)")
    self._List_Button[idx]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  end
  default_Pos_Size._List_Button_SpanX = self._List_Button[0]:GetSpanSize().x
end
default_Control:Init()
function FGlobal_Reset_HouseSellBuy_PanelPos()
  local PosX = (getScreenSizeX() - Panel_House_SellBuy_Condition:GetSizeX()) / 2
  local PosY = getScreenSizeY() / 2 - Panel_House_SellBuy_Condition:GetSizeY()
  Panel_House_SellBuy_Condition:SetPosX(PosX)
  Panel_House_SellBuy_Condition:SetPosY(PosY)
end
function get_HouseName_SellBuy(_List, idx)
  local List = _List
  local houseKey = List[idx]
  local indexKey = housing_getHouseIndexByCharacterKey(houseKey) + 1
  local houseName = ""
  local houseInfo = FGlobal_SelectedHouseInfo(houseKey)
  houseName = houseInfo:getName()
  return houseName
end
function get_UseTypeName_SellBuy()
  if nil == prevHouse_List[1] or nil == target_UseType then
    return
  end
  local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper(prevHouse_List[1])
  local realIndex = houseInfoStaticStatusWrapper:getIndexByReceipeKey(target_UseType)
  local houseInfoCraftWrapper = houseInfoStaticStatusWrapper:getHouseCraftWrapperByIndex(realIndex)
  local useTypeName = houseInfoCraftWrapper:getReciepeName()
  return useTypeName
end
function default_Control:Set(count)
  default_Pos_Size._Adjust_1 = default_Control._Title:GetSizeY() - default_Pos_Size._Title_SizeY
  default_Pos_Size._Adjust_2 = default_Control._Desc:GetSizeY() - default_Pos_Size._Desc_SizeY
  self._Btn_All:addInputEvent("Mouse_LUp", "HandleClick_House_SellBuy_All()")
  if true == House_SellBuy_Condition.isNext then
    default_Pos_Size._Adjust_4 = -default_Pos_Size._Guide_GapY
    default_Control._Guide:SetShow(false)
    default_Control._Btn_All:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_BTN_ALL") .. " ( + " .. total_Cost .. " )")
  elseif false == House_SellBuy_Condition.isNext then
    default_Pos_Size._Adjust_4 = default_Control._Guide:GetSizeY() - default_Pos_Size._Guide_SizeY
    default_Control._Guide:SetShow(true)
    if House_SellBuy_Condition.checkBuyAll then
      default_Control._Btn_All:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_BTN_ALL") .. " ( - " .. total_Cost .. " )")
    else
      default_Control._Btn_All:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_BTN_ALL_CNT"))
      self._Btn_All:addInputEvent("Mouse_LUp", "")
    end
  end
  Panel_House_SellBuy_Condition:SetSize(Panel_House_SellBuy_Condition:GetSizeX(), default_Pos_Size._Panel_SizeY + default_Pos_Size._Adjust_1 + default_Pos_Size._Adjust_2 + default_Pos_Size._Adjust_4)
  self._Desc:SetPosY(default_Pos_Size._Desc_PosY + default_Pos_Size._Adjust_1)
  self._Cost_Title:SetPosY(default_Pos_Size._Cost_Title_PosY + default_Pos_Size._Adjust_1 + default_Pos_Size._Adjust_2)
  self._Cost_BG:SetPosY(default_Pos_Size._Cost_BG_PosY + default_Pos_Size._Adjust_1 + default_Pos_Size._Adjust_2)
  self._List_Title:SetPosY(default_Pos_Size._List_Title_PosY + default_Pos_Size._Adjust_1 + default_Pos_Size._Adjust_2)
  self._List_BG:SetPosY(default_Pos_Size._List_BG_PosY + default_Pos_Size._Adjust_1 + default_Pos_Size._Adjust_2)
  self._List_Scroll:SetPosY(default_Pos_Size._List_Scroll_PosY + default_Pos_Size._Adjust_1 + default_Pos_Size._Adjust_2)
  self._Btn_All:SetPosY(default_Pos_Size._Btn_All_PosY + default_Pos_Size._Adjust_1 + default_Pos_Size._Adjust_2)
  self._Guide:SetPosY(default_Pos_Size._Guide_PosY + default_Pos_Size._Adjust_1 + default_Pos_Size._Adjust_2)
end
function default_Control:UpdateList()
  local lastIndex = param_Scroll._contentCount - (param_Scroll._offsetIndex + 1)
  if lastIndex > param_Scroll._listMax - 1 then
    lastIndex = param_Scroll._listMax - 1
  end
  clear_Control(default_Control._List_Value)
  clear_Control(default_Control._List_Button)
  UIScroll.SetButtonSize(default_Control._List_Scroll, param_Scroll._listMax, param_Scroll._contentCount)
  default_Control._List_Scroll:SetControlPos(param_Scroll._offsetIndex / param_Scroll._offsetMax)
  for idx = 0, lastIndex do
    local index = param_Scroll._offsetIndex + idx
    local name = House_List[index]._Name
    local cost = House_List[index]._Cost
    local count = index + 1
    local Adjust = 0
    local checkButton = true
    if false == House_SellBuy_Condition.isNext then
      checkButton = cost <= currentExplorePoint
      cost = " ( - " .. cost .. " )"
    else
      cost = " ( + " .. cost .. " )"
    end
    if House_List[index]._isOnButton and checkButton then
      default_Control._List_Button[idx]:SetText(default_Control._List_Button_Text .. cost)
      default_Control._List_Button[idx]:SetSpanSize(default_Pos_Size._List_Button_SpanX - param_Scroll._Adjust_3, default_Control._List_Button[idx]:GetSpanSize().y)
      if default_Control._List_Button[index]:IsLimitText() then
        tempTable[index] = {}
        tempTable[index].control = default_Control._List_Button[index]
        tempTable[index].desc = default_Control._List_Button[index]:GetText()
        default_Control._List_Button[index]:addInputEvent("Mouse_On", "PaGlobalFunc_HouseSellBuy_TooltipLimitedText(" .. index .. ",true)")
        default_Control._List_Button[index]:addInputEvent("Mouse_Out", "PaGlobalFunc_HouseSellBuy_TooltipLimitedText(" .. index .. ",false)")
      end
      default_Control._List_Button[idx]:SetShow(true)
      Adjust = default_Pos_Size._List_Button_SizeX
    end
    default_Control._List_Value[idx]:SetTextMode(UI_TM.eTextMode_LimitText)
    default_Control._List_Value[idx]:SetText(count .. ". " .. name)
    default_Control._List_Value[idx]:SetShow(true)
  end
end
function SellBuy_Condition_Scroll(isUp)
  if param_Scroll._offsetIndex == 0 and param_Scroll._offsetMax == 0 then
    return
  end
  local save_offset = param_Scroll._offsetIndex
  if true == isUp then
    param_Scroll._offsetIndex = param_Scroll._offsetIndex - 1
    if param_Scroll._offsetIndex < 0 then
      param_Scroll._offsetIndex = 0
    end
  else
    param_Scroll._offsetIndex = param_Scroll._offsetIndex + 1
    if param_Scroll._offsetIndex > param_Scroll._offsetMax then
      param_Scroll._offsetIndex = param_Scroll._offsetMax
    end
  end
  if save_offset ~= param_Scroll._offsetIndex then
    default_Control:UpdateList()
    Reflesh_HandleOn_ListValueButton()
  end
end
function SellBuy_Condition_ScrollOnClick()
  local namnunSize = default_Control._List_Scroll:GetSizeY() - default_Control._List_Scroll_Button:GetSizeY()
  local namnunPercents = default_Control._List_Scroll_Button:GetPosY() / namnunSize
  param_Scroll._offsetIndex = math.floor(namnunPercents * param_Scroll._offsetMax)
  default_Control:UpdateList()
end
function param_Scroll:Init()
  self._offsetIndex = 0
  local List
  if true == House_SellBuy_Condition.isNext then
    List = nextHouse_List
  elseif false == House_SellBuy_Condition.isNext then
    List = prevHouse_List
  end
  House_List = {}
  for idx = 0, #List - 1 do
    House_List[idx] = {}
    House_List[idx]._Key = List[#List - idx]
    House_List[idx]._Name = get_HouseName_SellBuy(List, #List - idx)
    local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper(House_List[idx]._Key)
    if true == House_SellBuy_Condition.isNext then
      House_List[idx]._isOnButton = houseInfoStaticStatusWrapper:isSalable()
    elseif false == House_SellBuy_Condition.isNext then
      House_List[idx]._isOnButton = houseInfoStaticStatusWrapper:isPurchasable(CppEnums.eHouseUseType.Depot)
    end
    House_List[idx]._Cost = houseInfoStaticStatusWrapper:getNeedExplorePoint()
  end
  self._contentCount = #List
  self._Adjust_3 = 0
  if self._listMax < self._contentCount then
    self._Adjust_3 = default_Pos_Size._List_GapX
  end
  self._offsetMax = self._contentCount - self._listMax
  if 0 > self._offsetMax then
    self._offsetMax = 0
  end
end
function set_NextHouse()
  local targetName = get_HouseName_SellBuy(nextHouse_List, 1)
  default_Control._Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_TITLE") .. " : " .. targetName)
  if default_Control._Title:GetTextSizeX() > default_Control._Title:GetSizeX() then
    default_Control._Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_TITLE") .. " :\n" .. targetName)
  end
  default_Control._Desc:SetText("[<PAColor0xFF00D8FF> " .. targetName .. "<PAOldColor> ] " .. PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_DESC"))
  default_Control._Cost_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_COST_TITLE"))
  default_Control._Cost_Need:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_COST_NEED"))
  default_Control._Cost_Need_Value:SetText(total_Cost)
  currentExplorePoint = ToClient_RequestGetMyExploredPoint()
  default_Control._Cost_Have_Value:SetText(currentExplorePoint)
  local count = #nextHouse_List
  default_Control._List_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_LIST_TITLE") .. " ( " .. count .. " )")
  param_Scroll:Init()
  default_Control:UpdateList()
  default_Control:Set()
end
function set_PrevHouse()
  local targetName = get_HouseName_SellBuy(prevHouse_List, 1)
  local useTypeName = get_UseTypeName_SellBuy()
  default_Control._Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_TITLE") .. " : " .. targetName)
  if default_Control._Title:GetTextSizeX() < default_Control._Title:GetSizeY() then
    default_Control._Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_TITLE") .. " :\n" .. targetName)
  end
  default_Control._Desc:SetText("[<PAColor0xFF00D8FF> " .. targetName .. " - " .. useTypeName .. "<PAOldColor> ] " .. PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_DESC"))
  default_Control._Cost_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_COST_TITLE"))
  default_Control._Cost_Need:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_COST_NEED"))
  default_Control._Cost_Need_Value:SetText(total_Cost)
  currentExplorePoint = ToClient_RequestGetMyExploredPoint()
  default_Control._Cost_Have_Value:SetText(currentExplorePoint)
  if total_Cost > currentExplorePoint then
    House_SellBuy_Condition.checkBuyAll = false
  else
    House_SellBuy_Condition.checkBuyAll = true
  end
  local count = #prevHouse_List
  default_Control._List_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_LIST_TITLE") .. " ( " .. count .. " )")
  param_Scroll._Adjust_3 = 0
  if count > param_Scroll._listMax then
    param_Scroll._Adjust_3 = default_Pos_Size._List_GapX
  end
  param_Scroll:Init()
  default_Control:UpdateList()
  default_Control:Set()
end
function show_NextHouse(_List, _Cost)
  nextHouse_List = _List
  total_Cost = _Cost
  House_SellBuy_Condition.isNext = true
  House_SellBuy_Condition.conditionKey = nextHouse_List[1]
  default_Control._List_Button_Text = PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_BTN_TXT")
  show_HouseSelectedAni_bySellBuy()
  FGlobal_Reset_HouseSellBuy_PanelPos()
  set_NextHouse()
end
function show_PrevHouse(_List, _Cost, _UseType)
  prevHouse_List = _List
  total_Cost = _Cost
  target_UseType = _UseType
  House_SellBuy_Condition.isNext = false
  House_SellBuy_Condition.conditionKey = prevHouse_List[1]
  default_Control._List_Button_Text = PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_BTN_TXT")
  show_HouseSelectedAni_bySellBuy()
  FGlobal_Reset_HouseSellBuy_PanelPos()
  set_PrevHouse()
end
function show_HouseSelectedAni_bySellBuy()
  local _List = {}
  if true == House_SellBuy_Condition.isNext then
    _List = nextHouse_List
  elseif false == House_SellBuy_Condition.isNext then
    _List = prevHouse_List
  else
    return
  end
  for idx, HouseKey in pairs(_List) do
    local HouseBtn = ToClient_findHouseButtonByKey(HouseKey)
    if HouseBtn ~= nil then
      local selectedAni = HouseBtn:FromClient_getSelectedAni()
      selectedAni:SetHorizonCenter()
      selectedAni:SetVerticalMiddle()
      selectedAni:SetShow(true)
    end
  end
end
function clear_HouseSelectedAni_bySellBuy()
  if #prevHouse_List > 0 then
    for index, HouseKey in pairs(prevHouse_List) do
      local HouseBtn = ToClient_findHouseButtonByKey(HouseKey)
      if HouseBtn ~= nil then
        local selectedAni = HouseBtn:FromClient_getSelectedAni()
        selectedAni:SetShow(false)
      end
    end
    prevHouse_List = {}
    total_Cost = 0
  end
  if #nextHouse_List > 0 then
    for idx, HouseKey in pairs(nextHouse_List) do
      local HouseBtn = ToClient_findHouseButtonByKey(HouseKey)
      if HouseBtn ~= nil then
        local selectedAni = HouseBtn:FromClient_getSelectedAni()
        selectedAni:SetShow(false)
      end
    end
    nextHouse_List = {}
    total_Cost = 0
  end
  House_SellBuy_Condition.isNext = nil
end
function check_SellBuyList(Input_houseKey)
  if false == House_SellBuy_Condition.isNext and #prevHouse_List > 0 then
    for idx, HouseKey in pairs(prevHouse_List) do
      if Input_houseKey == HouseKey then
        return true
      end
    end
  elseif true == House_SellBuy_Condition.isNext and #nextHouse_List > 0 then
    for idx, HouseKey in pairs(nextHouse_List) do
      if Input_houseKey == HouseKey then
        return true
      end
    end
  end
  return false
end
local checkControl, currentIdx, currentIndex
function HandleOn_ListValueButton(idx, isValue)
  checkControl = isValue
  local index = param_Scroll._offsetIndex + idx
  if nil ~= House_List[index] then
    local HouseKey = House_List[index]._Key
    local indexKey = housing_getHouseIndexByCharacterKey(HouseKey) + 1
    local HouseBtn = ToClient_findHouseButtonByKey(HouseKey)
    FromClient_OnWorldMapHouse(HouseBtn)
    currentIndex = indexKey
    currentIdx = idx
  end
end
function HandleOut_ListValueButton(idx, isValue)
  if checkControl ~= isValue then
    return
  end
  local index = param_Scroll._offsetIndex + idx
  local HouseKey = House_List[index]._Key
  local indexKey = housing_getHouseIndexByCharacterKey(HouseKey) + 1
  local HouseBtn = ToClient_findHouseButtonByKey(HouseKey)
  FromClient_OutWorldMapHouse(HouseBtn)
  currentIdx = nil
  currentIndex = nil
end
function Reflesh_HandleOn_ListValueButton()
  if nil ~= currentIdx then
    local index = param_Scroll._offsetIndex + currentIdx
    if currentIndex ~= index then
      HandleOut_ListValueButton(currentIndex, true)
      HandleOn_ListValueButton(index, true)
    end
  end
end
function HandleClick_ListValueButton(idx)
  local index = param_Scroll._offsetIndex + idx
  local HouseKey = House_List[index]._Key
  local indexKey = housing_getHouseIndexByCharacterKey(HouseKey) + 1
  local HouseBtn = ToClient_findHouseButtonByKey(HouseKey)
  FromClient_LClickedWorldMapHouse(HouseBtn)
end
function HandleClick_ListSellBuyButton(idx)
  if false == default_Control._List_Button[idx]:GetShow() then
    if nil ~= default_Control._List_Button[idx + 1] then
      HandleClick_ListSellBuyButton(idx + 1)
    end
    return
  end
  House_SellBuy_Condition.sellBuy_Index = idx
  if true == House_SellBuy_Condition.isNext then
    local sellHouseContent
    if House_SellBuy_Condition.isAll == true then
      local isUsable = true
      for key, value in pairs(House_List) do
        local HouseKey = value._Key
        local workingcnt = getWorkingListAtRentHouse(HouseKey)
        if workingcnt > 0 then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ALL_ONCRAFT"))
          House_SellBuy_Condition.isAll = false
          return
        end
        local plantKey = PlantKey()
        plantKey:setRaw(-HouseKey)
        local largeCraftExchange = getLargeCraftExchange(plantKey)
        if 0 ~= largeCraftExchange then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ALL_ONLARGECRAFT"))
          House_SellBuy_Condition.isAll = false
          return
        end
        if false == ToClient_IsUsable(HouseKey) then
          isUsable = false
        end
        local Dwellingcnt = getNextHouseisDwelling(HouseKey)
        if Dwellingcnt > 0 then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ALL_DWELLING"))
          House_SellBuy_Condition.isAll = false
          return
        end
      end
      if House_SellBuy_Condition.isFirst == true then
        if false == isUsable then
          sellHouseContent = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ALL_ONCHANGEUSETYPE") .. [[


]] .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_RETURNPOINT", "returnPoint", total_Cost)
        else
          sellHouseContent = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ALL") .. [[


]] .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_RETURNPOINT", "returnPoint", total_Cost)
        end
      end
    else
      local index = param_Scroll._offsetIndex + idx
      local HouseKey = House_List[index]._Key
      local workingcnt = getWorkingListAtRentHouse(HouseKey)
      if false == ToClient_IsUsable(HouseKey) then
        local houseName = House_List[index]._Name
        sellHouseContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ONCHANGEUSETYPE", "houseName", houseName)
      elseif workingcnt > 0 then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ONCRAFT"))
        return
      end
    end
    if sellHouseContent ~= nil then
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_TITLE"),
        content = sellHouseContent,
        functionYes = HandleClick_ListSellBuyButton_Continue,
        functionCancel = HandleClick_House_SellBuy_All_Cancel,
        priority = UI_PP.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData, "top")
      return
    end
  end
  HandleClick_ListSellBuyButton_Continue()
end
function HandleClick_ListSellBuyButton_Continue()
  local idx = House_SellBuy_Condition.sellBuy_Index
  HandleOut_ListValueButton(idx, checkControl)
  local index = param_Scroll._offsetIndex + idx
  local HouseKey = House_List[index]._Key
  local indexKey = housing_getHouseIndexByCharacterKey(HouseKey) + 1
  HouseControlManager._houseIndex = indexKey
  HouseControlManager._houseInfo = housing_getHouseInfo(indexKey - 1)
  if true == House_SellBuy_Condition.isNext then
    ToClient_RequestReturnHouse(HouseKey)
  elseif false == House_SellBuy_Condition.isNext then
    if House_SellBuy_Condition.conditionKey == HouseKey and target_UseType ~= nil then
      ToClient_RequestBuyHouse(HouseKey, target_UseType, 1)
      target_UseType = nil
    else
      ToClient_RequestBuyHouse(HouseKey, 2, 1)
    end
  end
end
function HandleClick_House_SellBuy_Close()
  local maxCostCalcCount = 10
  local costCalcCount = 0
  while Panel_House_SellBuy_Condition:GetShow() and maxCostCalcCount > costCalcCount do
    WorldMapPopupManager:pop()
    costCalcCount = costCalcCount + 1
  end
end
function HandleClick_House_SellBuy_All_Cancel()
  House_SellBuy_Condition.isAll = false
end
function HandleClick_House_SellBuy_All()
  local temp_Continue = House_List
  param_Scroll._offsetIndex = 0
  if House_SellBuy_Condition.isAll == false then
    House_SellBuy_Condition.isAll = true
    House_SellBuy_Condition.isFirst = true
  elseif House_SellBuy_Condition.isAll == true then
    House_SellBuy_Condition.isFirst = false
  end
  HandleClick_ListSellBuyButton(0)
end
function PaGlobalFunc_HouseSellBuy_TooltipLimitedText(index, isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if nil == tempTable then
    return
  end
  TooltipSimple_Show(tempTable[index].control, "", tempTable[index].desc)
end
