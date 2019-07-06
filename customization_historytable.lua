local customization_HistoryBG = UI.getChildControl(Panel_CustomizationStatic, "Static_HistoryBG")
local checkbox_Close = UI.getChildControl(customization_HistoryBG, "CheckButton_Close")
local Static_HistoryTableTitle = UI.getChildControl(customization_HistoryBG, "StaticText_Title")
local BTN_Previous = UI.getChildControl(customization_HistoryBG, "Button_CtrlZ")
local BTN_Next = UI.getChildControl(customization_HistoryBG, "Button_CtrlY")
local list2_HistoryList = UI.getChildControl(customization_HistoryBG, "List2_History")
local listMaxCount = 12
local selectIndex = 1
local currentactive
local isHistroyTableShow = true
local selectColor = Defines.Color.C_FFEF9C7F
local PosY = customization_HistoryBG:GetPosY()
local BGSizeY = customization_HistoryBG:GetSizeY()
function HistoryTableOpen()
  Initialize()
  registEventHandler()
end
function historyTableClose()
  currentactive = nil
  selectIndex = 1
  isHistroyTableShow = false
  historyTableRePosY(false)
end
function historyTableSetShow(flag)
  isHistroyTableShow = flag
  customization_HistoryBG:SetShow(flag)
  checkbox_Close:SetShow(flag)
  Static_HistoryTableTitle:SetShow(flag)
  BTN_Previous:SetShow(flag)
  BTN_Next:SetShow(flag)
  list2_HistoryList:SetShow(flag)
  HidehistoryTable()
end
function historyTableGetShow()
  return isHistroyTableShow
end
function Initialize()
  checkbox_Close:ComputePos()
  Static_HistoryTableTitle:ComputePos()
  BTN_Previous:ComputePos()
  BTN_Next:ComputePos()
  list2_HistoryList:ComputePos()
  customization_HistoryBG:SetPosX(getScreenSizeX() - customization_HistoryBG:GetSizeX() * 2 - 30)
  customization_HistoryBG:SetPosX(getScreenSizeX() - customization_HistoryBG:GetSizeX() - 20)
  checkbox_Close:SetCheck(true)
  registEventHandler()
end
function SetHistroyList()
  local toIndex = 0
  local scrollvalue = 0
  local vscroll = list2_HistoryList:GetVScroll()
  local hscroll = list2_HistoryList:GetHScroll()
  toIndex = list2_HistoryList:getCurrenttoIndex()
  local historyCount = ToClient_getHistoryCount()
  if listMaxCount - 1 <= selectIndex and selectIndex <= toIndex + (listMaxCount - 1) then
    toIndex = selectIndex - listMaxCount + 1
    if toIndex < 0 then
      toIndex = 0
    end
  end
  list2_HistoryList:getElementManager():clearKey()
  local historyGroupIndex = 0
  local historyPartIndex = 0
  local pushindex = 0
  for index = 1, historyCount do
    historyGroupIndex = ToClient_getControlGroupIndex(index - 1)
    historyPartIndex = ToClient_getControlPartIndex(index - 1)
    if 0 == index - 1 and -1 == historyGroupIndex then
      pushindex = 50001
    else
      pushindex = calculateListKeyIndex(historyGroupIndex, historyPartIndex, index)
    end
    list2_HistoryList:getElementManager():pushKey(pushindex)
  end
  list2_HistoryList:setCurrenttoIndex(toIndex)
end
function HistoryListControlCreate(control, key)
  local bg = UI.getChildControl(control, "Static_BG")
  local active = UI.getChildControl(control, "Static_Active")
  local statictext = UI.getChildControl(control, "StaticText_Item")
  local GroupIndex = 0
  local PartIndex = 0
  local index = 0
  GroupIndex, PartIndex, index = calculateGroupPartIndex(key)
  local inputtext = calculateText(GroupIndex, PartIndex)
  statictext:SetText(inputtext)
  if index == selectIndex then
    if nil ~= currentactive then
      currentactive:SetColor(Defines.Color.C_FFFFFFFF)
    end
    active:SetColor(selectColor)
    currentactive = active
  else
    active:SetColor(Defines.Color.C_FFFFFFFF)
  end
  statictext:SetIgnore(false)
  statictext:addInputEvent("Mouse_LUp", "HistoryApply(" .. GroupIndex .. ", " .. PartIndex .. ", " .. index .. ")")
end
function registEventHandler()
  BTN_Previous:addInputEvent("Mouse_LUp", "customHistoryUnDo()")
  BTN_Next:addInputEvent("Mouse_LUp", "customHistoryDo()")
  checkbox_Close:addInputEvent("Mouse_LUp", "HidehistoryTable()")
  list2_HistoryList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "HistoryListControlCreate")
  list2_HistoryList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function calculateListKeyIndex(historyGroupIndex, historyPartIndex, index)
  return (historyGroupIndex + 1) * 10000 + (historyPartIndex + 1) * 100 + index
end
function calculateGroupPartIndex(key)
  local strkey = tostring(key)
  local GroupIndex = tonumber(string.sub(strkey, 1, 1)) - 1
  local historyPartIndex = tonumber(string.sub(strkey, 2, 3)) - 1
  local index = tonumber(string.sub(strkey, 4, 5))
  return GroupIndex, historyPartIndex, index
end
function calculateText(GroupIndex, PartIndex)
  local text = {}
  local partStr = ""
  local partcount = ToClient_HistoryUIPartCount(GroupIndex)
  if 0 == GroupIndex then
    text = PAGetString(Defines.StringSheet_RESOURCE, "UI_CUSTOMIZATION_MAIN_HAIR") .. " - "
    partStr = getUiPartDescName(GroupIndex, PartIndex)
    text = text .. PAGetString(Defines.StringSheet_GAME, partStr)
  elseif 1 == GroupIndex then
    text = PAGetString(Defines.StringSheet_RESOURCE, "UI_CUSTOMIZATION_MAIN_FACE") .. " - "
    partStr = getUiPartDescName(GroupIndex, PartIndex)
    text = text .. PAGetString(Defines.StringSheet_GAME, partStr)
  elseif 2 == GroupIndex then
    text = PAGetString(Defines.StringSheet_RESOURCE, "UI_CUSTOMIZATION_MAIN_FORM") .. " - "
    partStr = getUiPartDescName(GroupIndex, PartIndex)
    text = text .. PAGetString(Defines.StringSheet_GAME, partStr)
  else
    text = PAGetString(Defines.StringSheet_GAME, "XML_CUSTOMIZATION_NORMAL")
  end
  return text
end
function setCurrentActive(setindex)
  local historyCount = ToClient_getHistoryCount()
  local key = -1
  if nil == setindex then
    key = list2_HistoryList:getKeyByIndex(historyCount - 1)
  else
    key = list2_HistoryList:getKeyByIndex(setindex - 1)
  end
  local GroupIndex = 0
  local PartIndex = 0
  local index = 0
  GroupIndex, PartIndex, index = calculateGroupPartIndex(key)
  local inputtext = calculateText(GroupIndex, PartIndex)
  selectIndex = index
  local toIndex = list2_HistoryList:getCurrenttoIndex()
  toIndex = math.floor(toIndex)
  if selectIndex < toIndex + 1 or toIndex + listMaxCount <= selectIndex then
    if nil ~= currentactive then
      currentactive:SetColor(Defines.Color.C_FFFFFFFF)
    end
    return
  end
  if nil ~= currentactive then
    currentactive:SetColor(Defines.Color.C_FFFFFFFF)
  end
  local control = list2_HistoryList:GetContentByKey(key)
  local active = UI.getChildControl(control, "Static_Active")
  active:SetColor(selectColor)
  currentactive = active
end
function historyTableDoChangeActive()
  local historyCount = ToClient_getHistoryCount()
  selectIndex = selectIndex + 1
  if historyCount <= selectIndex then
    selectIndex = historyCount
  end
  local toIndex = list2_HistoryList:getCurrenttoIndex()
  toIndex = math.floor(toIndex)
  if selectIndex < toIndex + 1 or toIndex + listMaxCount < selectIndex then
    if nil ~= currentactive then
      currentactive:SetColor(Defines.Color.C_FFFFFFFF)
    end
    return
  end
  local key = list2_HistoryList:getKeyByIndex(selectIndex - 1)
  if nil ~= currentactive then
    currentactive:SetColor(Defines.Color.C_FFFFFFFF)
  end
  if -1 == key then
    selectIndex = selectIndex - 1
    key = list2_HistoryList:getKeyByIndex(selectIndex - 1)
  end
  local control = list2_HistoryList:GetContentByKey(key)
  if nil == control then
    return
  end
  local active = UI.getChildControl(control, "Static_Active")
  if nil == active then
    return
  end
  active:SetColor(selectColor)
  currentactive = active
end
function historyTableUnDoChangeActive()
  selectIndex = selectIndex - 1
  if selectIndex <= 1 then
    selectIndex = 1
  end
  local toIndex = list2_HistoryList:getCurrenttoIndex()
  toIndex = math.floor(toIndex)
  if selectIndex < toIndex + 1 or toIndex + listMaxCount < selectIndex then
    if nil ~= currentactive then
      currentactive:SetColor(Defines.Color.C_FFFFFFFF)
    end
    return
  end
  local key = list2_HistoryList:getKeyByIndex(selectIndex - 1)
  if nil ~= currentactive then
    currentactive:SetColor(Defines.Color.C_FFFFFFFF)
  end
  if -1 == key then
    selectIndex = selectIndex + 1
    key = list2_HistoryList:getKeyByIndex(selectIndex - 1)
  end
  local control = list2_HistoryList:GetContentByKey(key)
  if nil == control then
    return
  end
  local active = UI.getChildControl(control, "Static_Active")
  if nil == active then
    return
  end
  active:SetColor(selectColor)
  currentactive = active
end
function historyTableRePosY(flag)
  customization_HistoryBG:SetPosX(getScreenSizeX() - customization_HistoryBG:GetSizeX() - 20)
  if nil ~= Panel_Cash_Customization then
    if Panel_Cash_Customization:GetShow() then
      customization_HistoryBG:SetPosY(Panel_Cash_Customization:GetPosY() + FGlobal_CashCustom_CashBgSizeY() + 10)
    else
      customization_HistoryBG:SetPosY(40)
    end
  else
    customization_HistoryBG:SetPosY(40)
  end
end
function HidehistoryTable()
  if checkbox_Close:IsCheck() then
    BTN_Previous:SetShow(false)
    BTN_Next:SetShow(false)
    list2_HistoryList:SetShow(false)
    checkbox_Close:SetCheck(true)
    customization_HistoryBG:SetSize(customization_HistoryBG:GetSizeX(), checkbox_Close:GetSizeY() + 10)
    checkbox_Close:setRenderTexture(checkbox_Close:getClickTexture())
  else
    BTN_Previous:SetShow(true)
    BTN_Next:SetShow(true)
    list2_HistoryList:SetShow(true)
    checkbox_Close:SetCheck(false)
    customization_HistoryBG:SetSize(customization_HistoryBG:GetSizeX(), BGSizeY)
    checkbox_Close:setRenderTexture(checkbox_Close:getBaseTexture())
  end
end
function HistoryApply(GroupIndex, PartIndex, index)
  selectIndex = index
  local key = calculateListKeyIndex(GroupIndex, PartIndex, index)
  if nil ~= currentactive then
    currentactive:SetColor(Defines.Color.C_FFFFFFFF)
  end
  local control = list2_HistoryList:GetContentByKey(key)
  local active = UI.getChildControl(control, "Static_Active")
  active:SetColor(selectColor)
  currentactive = active
  faceHairCustomUpdate(false)
  ToClient_HistorySelectByIndex(selectIndex - 1)
end
