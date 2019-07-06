local UI_TM = CppEnums.TextMode
PaGlobal_Memo = {
  _id = {},
  _stickyMemoList = {},
  _ui = {
    _buttonAddMemo = UI.getChildControl(Panel_Memo_List, "Button_AddMemo"),
    _buttonAllRemove = UI.getChildControl(Panel_Memo_List, "Button_AllDelete"),
    _buttonClose = UI.getChildControl(Panel_Memo_List, "Button_Win_Close"),
    _list2 = UI.getChildControl(Panel_Memo_List, "List2_MemoList"),
    _noMemoAlert = UI.getChildControl(Panel_Memo_List, "StaticText_NoMemoAlert")
  },
  _currentFocusId = nil,
  _currentFocusContent = nil,
  _SaveMode_ = {
    TEXT = 0,
    SETTING = 1,
    ALL = 2
  },
  Add,
  Save,
  Remove,
  ListOpen,
  ListClose,
  StickyClose,
  StickyClicked,
  StickyToggleShow,
  StickyAlphaSlider,
  StickyResizeStartPos,
  StickyResize,
  StickyClearFocus
}
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Memo")
function FromClient_luaLoadComplete_Memo()
  PaGlobal_Memo:Initialize()
end
function PaGlobal_Memo:Initialize()
  Panel_Memo_List:SetShow(false)
  Panel_Memo_List:RegisterShowEventFunc(true, "Panel_Memo_List_ShowAni()")
  Panel_Memo_List:RegisterShowEventFunc(false, "Panel_Memo_List_HideAni()")
  self:RegistEventHandler()
  local result = self:DataInitialize()
  if false == result then
    return
  end
end
function PaGlobal_Memo:DataInitialize()
  ToClient_initMemoList()
  local memoCount = ToClient_getMemoCount()
  if memoCount == 0 then
    return false
  end
  local elements = {}
  for index = 0, memoCount - 1 do
    elements[index] = ToClient_getMemoAt(index)
  end
  for index = 0, memoCount - 1 do
    local info = elements[index]
    local id = info:getId()
    local reverse_index = memoCount - 1 - index
    self._id[reverse_index] = id
  end
  local list = self._ui._list2
  for index = 0, memoCount - 1 do
    list:getElementManager():pushKey(toInt64(0, self._id[index]))
    list:requestUpdateByKey(toInt64(0, self._id[index]))
  end
  for index = 0, memoCount - 1 do
    local info = elements[index]
    if true == info:isOn() then
      self:createStickyMemoWrapper(info:getId())
    end
  end
end
function PaGlobal_Memo:RegistEventHandler()
  self._ui._buttonAddMemo:addInputEvent("Mouse_LUp", "PaGlobal_Memo:Add()")
  self._ui._buttonAllRemove:addInputEvent("Mouse_LUp", "PaGlobal_Memo:AllRemove()")
  self._ui._buttonClose:addInputEvent("Mouse_LUp", "PaGlobal_Memo:ListClose()")
  self._ui._list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FGlobal_Memo_List2EventControlCreate")
  self._ui._list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function PaGlobal_Memo:Add()
  local info = ToClient_addMemo()
  if nil == info then
    return
  end
  local newId = info:getId()
  self._currentFocusId = newId
  self._ui._list2:getElementManager():pushKey(toInt64(0, newId))
  self:createStickyMemoWrapper(newId)
  if true == Panel_Memo_List:GetShow() then
    self:StickySetDefaultPos(newId)
  end
  self:ListUpdate()
end
function PaGlobal_Memo:Save(saveMode, inputId)
  if inputId ~= nil then
    self._currentFocusId = inputId
  end
  local id = self._currentFocusId
  local _saveMode = self:ReCheckSaveMode(saveMode)
  if nil == _saveMode then
    return
  end
  local info = self:getInfoByCurData(id)
  local result = ToClient_updateMemo(info, _saveMode)
  if false == result or _saveMode == self._SaveMode_.SETTING then
    return
  end
  self:ListUpdate()
  self:StickyClearFocus()
  self:ComputeFrameContentSizeY(id)
end
function PaGlobal_Memo:Remove(id)
  local result = ToClient_removeMemo(id)
  if false == result then
    return
  end
  self._ui._list2:getElementManager():removeKey(id)
  if nil ~= self._stickyMemoList[id] then
    self._stickyMemoList[id]:clear()
    self._stickyMemoList[id] = nil
  end
  TooltipSimple_Hide()
  self:ListUpdate()
  self:StickyClearFocus()
end
function PaGlobal_Memo:AllRemove()
  local memoCount = ToClient_getMemoCount()
  if 0 == memoCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MEMOLIST_NOMEMO"))
    return
  end
  local function applyFunc()
    ToClient_removeAllMemo()
    for k in pairs(self._id) do
      local id = self._id[k]
      if nil ~= self._stickyMemoList[id] then
        self._stickyMemoList[id]:clear()
        self._stickyMemoList[id] = nil
      end
      self._ui._list2:getElementManager():removeKey(id)
    end
    self:ListUpdate()
    self:StickyClearFocus()
  end
  local _title = PAGetString(Defines.StringSheet_GAME, "LUA_MEMOLIST_DELETETITLE")
  local _content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MEMOLIST_DELETEDESC", "count", memoCount)
  local messageBoxData = {
    title = _title,
    content = _content,
    functionYes = applyFunc,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_Memo:RemoveConfirmPopUp(id)
  local function applyFunc()
    self:Remove(id)
  end
  local _title = PAGetString(Defines.StringSheet_GAME, "LUA_MEMOLIST_CURRENTDELETEDTITLE")
  local _content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MEMOLIST_CURRENTDELETEDESC", "count", memoCount)
  local messageBoxData = {
    title = _title,
    content = _content,
    functionYes = applyFunc,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_Memo:ReCheckSaveMode(saveMode)
  if saveMode ~= self._SaveMode_.SETTING then
    if nil == self._currentFocusId then
      return nil
    end
    if saveMode == self._SaveMode_.ALL then
      return self._SaveMode_.ALL
    end
    if false == self:IsChanged() then
      self:StickyClearFocus()
      return nil
    end
    return self._SaveMode_.TEXT
  else
    return self._SaveMode_.SETTING
  end
end
function PaGlobal_Memo:ListUpdate()
  if false == Panel_Memo_List:IsShow() then
    return
  end
  local memoCount = ToClient_getMemoCount()
  if memoCount == 0 then
    self._ui._noMemoAlert:SetShow(true)
    return false
  end
  self._ui._noMemoAlert:SetShow(false)
  for k in pairs(self._id) do
    self._id[k] = nil
  end
  for index = 0, memoCount - 1 do
    local reverse_index = memoCount - 1 - index
    self._id[index] = ToClient_getMemoIdAt(reverse_index)
  end
  self._ui._list2:getElementManager():clearKey()
  for index = 0, memoCount - 1 do
    self._ui._list2:getElementManager():pushKey(toInt64(0, self._id[index]))
    self._ui._list2:requestUpdateByKey(toInt64(0, self._id[index]))
  end
end
function FGlobal_Memo_List2EventControlCreate(list_content, key)
  local id = Int64toInt32(key)
  local info = ToClient_getMemo(id)
  local _content = info:getContent()
  local bg = UI.getChildControl(list_content, "List2_Static_MemoList_TitleBG")
  local content = UI.getChildControl(list_content, "List2_StaticText_MemoList_Content")
  local toggleButton = UI.getChildControl(list_content, "List2_CheckButton_MemoList_ToggleShow")
  local removeButton = UI.getChildControl(list_content, "List2_Button_MemoList_RemoveMemo")
  local updatetime = UI.getChildControl(list_content, "List2_StaticText_MemoList_UpdateTime")
  content:SetShow(true)
  if "" == _content or "Content" == _content then
    _content = PAGetString(Defines.StringSheet_GAME, "LUA_MEMO_INSERTCONTENT")
  end
  content:SetText(_content)
  content:setLineCountByLimitAutoWrap(3)
  content:SetTextMode(UI_TM.eTextMode_Limit_AutoWrap)
  updatetime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MEMO_LASTUPDATE", "time", info:getUpdateTime()))
  toggleButton:SetCheck(true == info:isOn())
  function MemoList_SimpleTooltipShow(uiType)
    local uiControl, name
    if 0 == uiType then
      uiControl = toggleButton
      name = PAGetString(Defines.StringSheet_GAME, "LUA_MEMOLIST_TOGGLE")
    elseif 1 == uiType then
      uiControl = removeButton
      name = PAGetString(Defines.StringSheet_GAME, "LUA_MEMOLIST_DELETE")
    end
    TooltipSimple_Show(uiControl, name)
  end
  function MemoList_SimpleTooltipHide()
    TooltipSimple_Hide()
  end
  bg:addInputEvent("Mouse_LDClick", "PaGlobal_Memo:StickyToggleShow( " .. id .. ")")
  toggleButton:addInputEvent("Mouse_LUp", "PaGlobal_Memo:StickyToggleShow( " .. id .. ")")
  toggleButton:addInputEvent("Mouse_On", "MemoList_SimpleTooltipShow(" .. 0 .. ")")
  toggleButton:addInputEvent("Mouse_Out", "MemoList_SimpleTooltipHide()")
  removeButton:addInputEvent("Mouse_LUp", "PaGlobal_Memo:RemoveConfirmPopUp( " .. id .. " ) ")
  removeButton:addInputEvent("Mouse_On", "MemoList_SimpleTooltipShow(" .. 1 .. ")")
  removeButton:addInputEvent("Mouse_Out", "MemoList_SimpleTooltipHide()")
end
function PaGlobal_Memo:StickyClearFocus()
  ClearFocusEdit()
  self._currentFocusId = nil
  self._currentFocusContent = nil
end
function PaGlobal_Memo:IsChanged()
  if self._currentFocusId == nil then
    return false
  end
  local stickyMemo = self._stickyMemoList[self._currentFocusId]
  if self._currentFocusContent == stickyMemo._uiMultiLineText:GetEditText() then
    return false
  end
  return true
end
function Panel_Memo_List_ShowAni()
  audioPostEvent_SystemUi(1, 22)
  _AudioPostEvent_SystemUiForXBOX(1, 22)
  local aniInfo1 = Panel_Memo_List:addScaleAnimation(0, 0.08, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.12)
  aniInfo1.AxisX = Panel_Memo_List:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Memo_List:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Memo_List:addScaleAnimation(0.08, 0.15, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.12)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Memo_List:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Memo_List:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_Memo_List_HideAni()
  audioPostEvent_SystemUi(1, 21)
  _AudioPostEvent_SystemUiForXBOX(1, 21)
  local aniInfo1 = Panel_Memo_List:addColorAnimation(0, 0.1, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(Defines.Color.C_FFFFFFFF)
  aniInfo1:SetEndColor(Defines.Color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
function PaGlobal_Memo:ListOpen()
  if not Panel_Memo_List:IsShow() then
    Panel_Memo_List:SetShow(true, true)
    ToClient_refreshMemoUpdateTime()
    self:ListUpdate()
  end
end
function PaGlobal_Memo:ListClose()
  if Panel_Memo_List:IsShow() then
    Panel_Memo_List:SetShow(false, true)
  end
  TooltipSimple_Hide()
end
function PaGlobal_Memo:getInfoByCurData(id)
  local stickyMemo = self._stickyMemoList[id]
  local posX = stickyMemo._mainPanel:GetPosX()
  local posY = stickyMemo._mainPanel:GetPosY()
  if true == stickyMemo._isSubAppMode then
    local info = ToClient_getMemo(id)
    posX = info:getPositionX()
    posY = info:getPositionY()
  end
  local info = MemoInfo(id)
  info:setInfo(stickyMemo._uiMultiLineText:GetEditText(), stickyMemo._isOn, int2(posX, posY), int2(stickyMemo._mainPanel:GetSizeX(), stickyMemo._mainPanel:GetSizeY()), stickyMemo._stickyMemoAlpha, stickyMemo._stickyMemoColor)
  return info
end
function PaGlobal_Memo:Tablelength(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end
