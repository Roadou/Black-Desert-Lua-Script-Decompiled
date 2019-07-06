local Panel_Dialog_Main_Right_Info = {
  _ui = {
    static_RightBg = UI.getChildControl(Panel_Dialog_Main, "Static_RightBg"),
    staticText_DialogTitle = nil,
    static_Bg = nil,
    staticText_Dialog_Text = nil,
    btn_DialogTemplete = nil,
    btn_Dialog_List = {
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil
    },
    static_TypeIcon = nil,
    staticText_Name = nil,
    staticText_Needs = nil,
    static_ExchangeBg = nil,
    staticText_Exchange_Title = nil,
    list2_Exchange_List = nil,
    list2_2_Content = nil,
    list2_3_VerticalScroll = nil,
    static_DialogGroup = nil,
    static_Dialog = nil
  },
  _config = {
    maxButtonDialogCount = 6,
    maxExchangeSlotCount = 6,
    itemSlot = {
      createIcon = true,
      createBorder = true,
      createCount = true,
      createEnchant = false,
      createCash = false,
      createEnduranceIcon = false
    }
  },
  _enum = {eDefaultIndex = -1, eDefaultDialogSize = 4},
  _value = {
    currentDialogButtonIndex = 0,
    lastDialogButtonIndex = -1,
    exchangelistCount = 0,
    promiseTokenKey = 44192,
    allContentsSize = 0,
    isSetData = false
  },
  _text = {},
  _localize = {localizedType = nil, mainDialogLocalizedKey = nil},
  _pos = {
    exchangeStartPosY = 0,
    exchangeArrowStartPosY = 0,
    exchangePosY = 0
  },
  _space = {contentsSpace = 16, exchangeTextSpace = 0},
  _exchangIcon = {
    [0] = {
      texture = "Renewal/UI_Icon/Console_DialogueIcon_00.dds",
      x1 = 1,
      y1 = 1,
      x2 = 31,
      y2 = 31
    },
    [1] = {
      texture = "Renewal/UI_Icon/Console_DialogueIcon_00.dds",
      x1 = 32,
      y1 = 1,
      x2 = 62,
      y2 = 31
    },
    [2] = {
      texture = "Renewal/UI_Icon/Console_DialogueIcon_00.dds",
      x1 = 63,
      y1 = 1,
      x2 = 93,
      y2 = 31
    }
  },
  _dialogInfo = {
    _nextPosY = 0,
    _dialogNameOriSizeX = 430,
    _controlCnt = 10
  },
  _exchangeSlot = {},
  _dialogId = {},
  _exchangeId = {}
}
function Panel_Dialog_Main_Right_Info:initialize()
  self:close()
  self:initControl()
end
function Panel_Dialog_Main_Right_Info:initControl()
  self._ui.staticText_DialogTitle = UI.getChildControl(self._ui.static_RightBg, "StaticText_DialogTitle")
  self._ui.staticText_DialogTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui.static_Bg = UI.getChildControl(self._ui.static_RightBg, "Static_Bg")
  self._ui.frame_DialogText = UI.getChildControl(self._ui.static_RightBg, "Frame_Dialog_Text")
  self._ui.frame_Content = UI.getChildControl(self._ui.frame_DialogText, "Frame_1_Content")
  self._ui.staticText_Dialog_Text = UI.getChildControl(self._ui.frame_Content, "StaticText_Dialog_Text")
  self._ui.frame_VScroll = UI.getChildControl(self._ui.frame_DialogText, "Frame_1_VerticalScroll")
  self._ui.static_ExchangeBg = UI.getChildControl(self._ui.static_RightBg, "Static_ExchangeBg")
  self._ui.staticText_Title = UI.getChildControl(self._ui.static_ExchangeBg, "StaticText_Title")
  self._ui.list2_Exchange_List = UI.getChildControl(self._ui.static_ExchangeBg, "List2_Exchange_List")
  self._ui.list2_Exchange_List:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_MainDialog_Right_List2EventControlCreateExchange")
  self._ui.list2_Exchange_List:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.static_DialogGroup = UI.getChildControl(self._ui.static_RightBg, "Static_DialogGroup")
  self._ui.static_Dialog = UI.getChildControl(self._ui.static_DialogGroup, "Static_Dialog0")
  self._dialogInfo._dialogNameOriSizeX = self._ui.static_Dialog:GetSizeX()
end
function Panel_Dialog_Main_Right_Info:open()
  self._ui.static_RightBg:SetShow(true)
end
function Panel_Dialog_Main_Right_Info:close()
  self._ui.static_RightBg:SetShow(false)
end
function Panel_Dialog_Main_Right_Info:update()
  self:close()
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  self._localize.localizedType = dialogData:getLocalizedTypeForLua()
  self._localize.mainDialogLocalizedKey = dialogData:getMainDialogLocalizedKey()
  if self._localize.mainDialogLocalizedKey == nil then
    ToClient_PopDialogueFlush()
    return
  end
  self._ui.staticText_Dialog_Text:setLocalizedStaticType(self._localize.localizedType)
  self._ui.staticText_Dialog_Text:setLocalizedKey(self._localize.mainDialogLocalizedKey)
  local npcWord = dialogData:getMainDialog()
  local realDialog = ToClient_getReplaceDialog(npcWord)
  if true == PaGlobalFunc_MainDialog_Quest_GetShow() then
    self._value.isSetData = true
    self:setData(dialogData, realDialog)
    return
  end
  local openCheck = PaGlobalFunc_Dialog_Main_GetShowCheckOnce()
  if true == openCheck then
    self._value.isSetData = true
    self:openAndSetData(dialogData, realDialog, true, true)
  elseif true == PaGlobalFunc_MainDialog_Bottom_IsLeastFunButtonDefault() then
    self._value.isSetData = true
    self:openAndSetData(dialogData, realDialog, true, true)
  else
    local leasFunButtomIndex = PaGlobalFunc_MainDialog_Bottom_GetLeastFunButtonIndex()
    local funcButton = dialogData:getFuncButtonAt(leasFunButtomIndex)
    if funcButton == nil then
      return
    end
    local QuestCount = dialogData:getHaveQuestCount()
    local funcButtonType = tonumber(funcButton._param)
    if funcButtonType == CppEnums.ContentsType.Contents_HelpDesk then
      self._value.isSetData = true
      self:openAndSetData(dialogData, realDialog, true, false)
    elseif false then
    end
  end
end
function Panel_Dialog_Main_Right_Info:makeNewLineInTwoColumn(realDialog)
  local newNpcWord = ""
  newNpcWord = string.gsub(realDialog, "?\n", "?\t")
  newNpcWord = string.gsub(newNpcWord, "!\n", "!\t")
  newNpcWord = string.gsub(newNpcWord, "%.\n", "%.\t")
  newNpcWord = string.gsub(newNpcWord, "\n", " ")
  newNpcWord = string.gsub(newNpcWord, "?\t", "?\n")
  newNpcWord = string.gsub(newNpcWord, "!\t", "!\n")
  newNpcWord = string.gsub(newNpcWord, "%.\t", ".\n")
  return newNpcWord
end
function Panel_Dialog_Main_Right_Info:setData(dialogData, realDialog, showButton, showExchange)
  local npcName = dialogData:getContactNpcName()
  local talkerNpcKey = dialog_getTalkNpcKey()
  if 0 == talkerNpcKey then
    self._ui.staticText_DialogTitle:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_BLACKSOUL"))
  else
    self._ui.staticText_DialogTitle:SetText(npcName)
  end
  if "" == realDialog or nil == realDialog then
    self._ui.staticText_Dialog_Text:SetShow(false)
  else
    local newNpcWord = self:makeNewLineInTwoColumn(realDialog)
    self._ui.staticText_Dialog_Text:SetShow(true)
    self._ui.staticText_Dialog_Text:SetAutoResize(true)
    self._ui.staticText_Dialog_Text:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui.staticText_Dialog_Text:SetText(newNpcWord)
  end
  self:updateDialogList(dialogData, showButton)
  self:ResizeContents(dialogData, showButton, showExchange)
  self:updateExchange(dialogData, showExchange)
end
function Panel_Dialog_Main_Right_Info:setDataOnlyMent(dialogData, realDialog)
  local npcName = dialogData:getContactNpcName()
  local talkerNpcKey = dialog_getTalkNpcKey()
  if 0 == talkerNpcKey then
    self._ui.staticText_DialogTitle:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_BLACKSOUL"))
  else
    self._ui.staticText_DialogTitle:SetText(npcName)
  end
  if "" == realDialog or nil == realDialog then
    self._ui.staticText_Dialog_Text:SetShow(false)
  else
    local newNpcWord = self:makeNewLineInTwoColumn(realDialog)
    self._ui.staticText_Dialog_Text:SetShow(true)
    self._ui.staticText_Dialog_Text:SetAutoResize(true)
    self._ui.staticText_Dialog_Text:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui.staticText_Dialog_Text:SetText(newNpcWord)
  end
  self:ResizeContents(dialogData, false, false)
end
function Panel_Dialog_Main_Right_Info:openAndSetData(dialogData, realDialog, showButton, showExchange)
  if false == self._ui.static_RightBg:GetShow() then
    self:open()
  end
  self:setData(dialogData, realDialog, showButton, showExchange)
end
function Panel_Dialog_Main_Right_Info:updateExchange(dialogData, showExchange)
  self:closeExchange()
  showExchange = false
  if false == showExchange then
    return
  end
  if true == exchangeShow then
    self:openExchange()
    self:updateExchangeList(displayExchangeWrapper)
  end
end
function Panel_Dialog_Main_Right_Info:updateDialogList(dialogData, showButton)
  for k in pairs(self._dialogId) do
    self._dialogId[k] = nil
  end
  if false == showButton then
    self._ui.static_DialogGroup:SetShow(false)
    return
  end
  local dialogCount = dialogData:getDialogButtonCount()
  if 0 == dialogCount then
    self._ui.static_DialogGroup:SetShow(false)
    return
  end
  self._value.currentDialogButtonIndex = 0
  self._value.lastDialogButtonIndex = -1
  self._ui.static_DialogGroup:SetShow(true)
  _PA_LOG("\236\162\133\237\152\132", "self._dialogInfo._controlCnt : " .. tostring(self._dialogInfo._controlCnt))
  for ii = 0, self._dialogInfo._controlCnt - 1 do
    local control = UI.getChildControl(self._ui.static_DialogGroup, "Static_Dialog" .. ii)
    if nil ~= control then
      control:SetShow(false)
    else
      _PA_ASSERT(false, "Panel_Dialog_Main_Right_Info:updateDialogList : \234\176\128\235\138\165\237\149\156 \235\178\148\236\156\132\235\165\188 \236\180\136\234\179\188\237\150\136\236\138\181\235\139\136\235\139\164! .. " .. ii)
    end
  end
  self._dialogInfo._nextPosY = 0
  for index = 0, dialogCount - 1 do
    self._dialogId[index] = index
    self:dialogControlCreate(index)
  end
  self._ui.static_DialogGroup:SetSize(self._ui.static_DialogGroup:GetSizeX(), self._dialogInfo._nextPosY)
  local bottomBgSize = PaGlobalFunc_MainDialog_Bottom_GetSizeY()
  if nil == bottomBgSize then
    bottomBgSize = 282
  end
  if 0 ~= self._dialogInfo._nextPosY then
    self._ui.static_RightBg:SetPosY(getScreenSizeY() + 50 - (bottomBgSize + self._ui.static_Bg:GetSizeY() + self._ui.staticText_DialogTitle:GetSizeY() + self._ui.static_DialogGroup:GetSizeY()))
  end
  ToClient_padSnapResetControl()
end
function Panel_Dialog_Main_Right_Info:dialogControlCreate(index)
  if nil == index then
    _PA_LOG("\236\162\133\237\152\132", "Panel_Dialog_Main_Right_Info:dialogControlCreate : index \234\176\128 nil \236\158\133\235\139\136\235\139\164!!")
    return
  end
  if index > self._dialogInfo._controlCnt - 1 then
    return
  end
  local id = index
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local list_content = UI.getChildControl(self._ui.static_DialogGroup, "Static_Dialog" .. index)
  if nil == list_content then
    _PA_ASSERT(false, "Panel_Dialog_Main_Right_Info:dialogControlCreate : \234\176\128\235\138\165\237\149\156 \235\178\148\236\156\132\235\165\188 \236\180\136\234\179\188\237\150\136\236\138\181\235\139\136\235\139\164! .. " .. index)
    return
  end
  local dialogButton = dialogData:getDialogButtonAt(id)
  local dialogText = dialogButton:getText()
  local btn_Dialog = UI.getChildControl(list_content, "Button_Dialog")
  local static_TypeIcon = UI.getChildControl(btn_Dialog, "Static_TypeIcon")
  local text_Dialog = UI.getChildControl(list_content, "StaticText_Dialog_Name")
  local textNeed_Dialog = UI.getChildControl(list_content, "StaticText_Dialog_Needs")
  local button_A = UI.getChildControl(list_content, "Button_A")
  local needItemIcon = UI.getChildControl(list_content, "Static_NeedItemIcon")
  local needWpIcon = UI.getChildControl(list_content, "Static_NeedEnergyIcon")
  local rightSpan = 0
  local leftSpan = 0
  list_content:SetShow(true)
  list_content:SetPosY(self._dialogInfo._nextPosY)
  needItemIcon:SetShow(false)
  needWpIcon:SetShow(false)
  btn_Dialog:addInputEvent("Mouse_LUp", "PaGlobalFunc_MainDialog_Right_HandleClickedDialogButton(" .. id .. ")")
  btn_Dialog:addInputEvent("Mouse_On", "PaGlobalFunc_MainDialog_Right_HandleOnDialogButton(" .. id .. ")")
  static_TypeIcon:SetShow(false)
  textNeed_Dialog:SetShow(false)
  btn_Dialog:SetMonoTone(false)
  btn_Dialog:setRenderTexture(btn_Dialog:getBaseTexture())
  text_Dialog:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  text_Dialog:SetText(dialogText)
  local linkType = dialogButton._linkType
  if CppEnums.DialogState.eDialogState_ReContact == tostring(linkType) then
    return
  end
  local displayData = Dialog_getButtonDisplayData(id)
  if nil ~= displayData and not displayData:empty() then
    static_TypeIcon:SetShow(true)
    local IconType = self._exchangIcon[1]
    static_TypeIcon:ChangeTextureInfoName(IconType.texture)
    local x1, y1, x2, y2 = setTextureUV_Func(static_TypeIcon, IconType.x1, IconType.y1, IconType.x2, IconType.y2)
    static_TypeIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    static_TypeIcon:setRenderTexture(static_TypeIcon:getBaseTexture())
  end
  if CppEnums.DialogButtonType.eDialogButton_Exchange == dialogButton._dialogButtonType then
    btn_Dialog:addInputEvent("Mouse_LUp", "PaGlobalFunc_MainDialog_Right_HandleClickedDialogButton(" .. id .. ",\"trade\"" .. ")")
    static_TypeIcon:SetShow(true)
    local IconType = self._exchangIcon[2]
    static_TypeIcon:ChangeTextureInfoName(IconType.texture)
    local x1, y1, x2, y2 = setTextureUV_Func(static_TypeIcon, IconType.x1, IconType.y1, IconType.x2, IconType.y2)
    static_TypeIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    static_TypeIcon:setRenderTexture(static_TypeIcon:getBaseTexture())
  end
  if true == static_TypeIcon:GetShow() then
    text_Dialog:SetSpanSize(45, 0)
    leftSpan = leftSpan + 45
  else
    text_Dialog:SetSpanSize(25, 0)
    leftSpan = leftSpan + 25
  end
  local needThings = ""
  local isNeedThings = false
  local isNeedItem = false
  local isNeedWp = false
  local itemStaticWrapper
  local selfPlayer = getSelfPlayer()
  local Wp = selfPlayer:getWp()
  local needWp = dialogButton:getNeedWp()
  local needItemCount = 0
  if CppEnums.DialogState.eDialogState_Talk == tostring(linkType) and needWp > 0 then
    isNeedThings = true
    isNeedWp = true
    if 0 < dialogButton:getNeedItemCount() then
      itemStaticWrapper = getItemEnchantStaticStatus(ItemEnchantKey(dialogButton:getNeedItemKey()))
      if itemStaticWrapper ~= nil then
        isNeedItem = true
        needItemCount = dialogButton:getNeedItemCount()
      end
    end
  elseif 0 < dialogButton:getNeedItemCount() then
    itemStaticWrapper = getItemEnchantStaticStatus(ItemEnchantKey(dialogButton:getNeedItemKey()))
    if itemStaticWrapper ~= nil then
      isNeedThings = true
      isNeedItem = true
      needItemCount = dialogButton:getNeedItemCount()
    end
  end
  if isNeedThings then
    textNeed_Dialog:SetShow(false)
    if true == isNeedItem then
      needItemIcon:SetShow(true)
      needItemIcon:ChangeTextureInfoName("Icon/" .. itemStaticWrapper:getIconPath())
      local x1, y1, x2, y2 = setTextureUV_Func(needItemIcon, 0, 0, 47, 47)
      needItemIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      needItemIcon:setRenderTexture(needItemIcon:getBaseTexture())
      needItemIcon:SetText("x " .. needItemCount)
      local posX = button_A:GetPosX() - needItemIcon:GetSizeX() - needItemIcon:GetTextSizeX()
      needItemIcon:SetPosX(posX)
      rightSpan = list_content:GetSizeX() - posX
    end
    if true == isNeedWp then
      needWpIcon:SetShow(true)
      needWpIcon:SetText(needWp .. "/" .. Wp)
      local posX = button_A:GetPosX() - needWpIcon:GetSizeX() - needWpIcon:GetTextSizeX() - 15
      if needItemIcon:GetShow() then
        posX = needItemIcon:GetPosX() - needWpIcon:GetSizeX() - needWpIcon:GetTextSizeX() - 7
      end
      needWpIcon:SetPosX(posX)
      rightSpan = list_content:GetSizeX() - posX
    end
  elseif CppEnums.DialogButtonType.eDialogButton_Knowledge == dialogButton._dialogButtonType then
    textNeed_Dialog:SetShow(false)
  end
  if false == dialogButton._enable then
    btn_Dialog:SetMonoTone(true)
  end
  if 0 ~= rightSpan then
    text_Dialog:SetSize(list_content:GetSizeX() - leftSpan - rightSpan - 10, text_Dialog:GetSizeY())
  else
    rightSpan = list_content:GetSizeX() - button_A:GetPosX()
    text_Dialog:SetSize(list_content:GetSizeX() - leftSpan - rightSpan, text_Dialog:GetSizeY())
  end
  text_Dialog:SetText(dialogText)
  text_Dialog:SetSize(text_Dialog:GetSizeX(), text_Dialog:GetTextSizeY())
  local contentSizeY = 50 + text_Dialog:GetTextSizeY() - 20
  list_content:SetSize(list_content:GetSizeX(), contentSizeY)
  btn_Dialog:SetSize(btn_Dialog:GetSizeX(), contentSizeY)
  local defaultContentPosY = list_content:GetSizeY() * 0.5
  btn_Dialog:SetPosY(defaultContentPosY - btn_Dialog:GetSizeY() * 0.5)
  needItemIcon:SetPosY(defaultContentPosY - needItemIcon:GetSizeY() * 0.5)
  needWpIcon:SetPosY(defaultContentPosY - needWpIcon:GetSizeY() * 0.5)
  static_TypeIcon:SetPosY(defaultContentPosY - static_TypeIcon:GetSizeY() * 0.5)
  text_Dialog:SetPosY(defaultContentPosY - text_Dialog:GetSizeY() * 0.5)
  button_A:SetPosY(defaultContentPosY - button_A:GetSizeY() * 0.5)
  self._dialogInfo._nextPosY = self._dialogInfo._nextPosY + list_content:GetSizeY() + 5
end
function Panel_Dialog_Main_Right_Info:updateExchangeList(displayExchangeWrapper)
  self._ui.list2_Exchange_List:getElementManager():clearKey()
  for k in pairs(self._exchangeId) do
    self._exchangeId[k] = nil
  end
  local exchangelistCount = displayExchangeWrapper:getItemExchangeByNpcListSize()
  if 0 == exchangelistCount then
    return
  end
  for index = 0, exchangelistCount - 1 do
    self._exchangeId[index] = index
    self._ui.list2_Exchange_List:getElementManager():pushKey(toInt64(0, self._exchangeId[index]))
    self._ui.list2_Exchange_List:requestUpdateByKey(toInt64(0, self._exchangeId[index]))
  end
end
function Panel_Dialog_Main_Right_Info:closeExchange()
  self._ui.static_ExchangeBg:SetShow(false)
end
function Panel_Dialog_Main_Right_Info:openExchange()
  self._ui.static_ExchangeBg:SetShow(true)
end
function Panel_Dialog_Main_Right_Info:getGradeToColorString(grade)
  if 0 == grade then
    return "<PAColor0xffc4bebe>"
  elseif 1 == grade then
    return "<PAColor0xFF5DFF70>"
  elseif 2 == grade then
    return "<PAColor0xFF4B97FF>"
  elseif 3 == grade then
    return "<PAColor0xFFFFC832>"
  elseif 4 == grade then
    return "<PAColor0xFFFF6C00>"
  else
    return "<PAColor0xffc4bebe>"
  end
end
function Panel_Dialog_Main_Right_Info:HandleClickedDialogButton_ShowData(index)
  local displayData = Dialog_getButtonDisplayData(index)
  if nil == displayData then
    return
  end
  if displayData:empty() then
    Dialog_clickDialogButtonReq(index)
  else
    PaGlobalFunc_Dialog_ItemTake_SelectedIndex(index)
    PaGlobalFunc_Dialog_ItemTake_Show(displayData)
  end
end
function Panel_Dialog_Main_Right_Info:Resize()
  self._ui.static_RightBg:ComputePos()
  self._ui.staticText_DialogTitle:ComputePos()
  self._ui.staticText_Dialog_Text:ComputePos()
end
function Panel_Dialog_Main_Right_Info:ResizeContents(dialogData, showDialogButton, showExchange)
  self:Resize()
  local textSize = self._ui.staticText_Dialog_Text:GetSizeY()
  if textSize > 400 then
    self._ui.frame_VScroll:SetShow(true)
    textSize = 400
  else
    self._ui.frame_VScroll:SetShow(false)
  end
  local bgPos = self._ui.frame_DialogText:GetPosY()
  local liststartPosY = bgPos
  if true == self._ui.staticText_Dialog_Text:GetShow() then
    liststartPosY = bgPos + textSize + self._space.contentsSpace
    self._ui.static_Bg:SetShow(true)
    self._ui.static_Bg:SetSize(self._ui.static_Bg:GetSizeX(), liststartPosY - bgPos + self._space.contentsSpace)
  else
    self._ui.static_Bg:SetShow(false)
  end
  local dialogCount = 0
  if nil == showDialogButton or true == showDialogButton then
    dialogCount = dialogData:getDialogButtonCount()
  end
  if dialogCount > 0 then
    self._ui.static_DialogGroup:SetPosY(liststartPosY)
    if dialogCount < self._enum.eDefaultDialogSize then
      self._pos.exchangePosY = liststartPosY + self._space.contentsSpace + self._ui.static_DialogGroup:GetSizeY() * dialogCount / self._enum.eDefaultDialogSize
    else
      self._pos.exchangePosY = liststartPosY + self._space.contentsSpace + self._ui.static_DialogGroup:GetSizeY()
    end
  else
    self._pos.exchangePosY = liststartPosY
  end
  local exchangeShow = false
  if nil == showExchange or true == showExchange then
  end
  if true == exchangeShow then
    self._ui.static_ExchangeBg:SetPosY(self._pos.exchangePosY)
    self._value.allContentsSize = self._pos.exchangePosY + self._ui.static_ExchangeBg:GetSizeY() + self._space.contentsSpace
  else
    self._value.allContentsSize = self._pos.exchangePosY
  end
  self._ui.static_RightBg:SetSize(self._ui.static_RightBg:GetSizeX(), self._value.allContentsSize)
  self._ui.static_RightBg:ComputePos()
  self._ui.frame_Content:SetSize(self._ui.staticText_Dialog_Text:GetSizeY())
  self._ui.frame_VScroll:SetControlPos(0)
  self._ui.frame_DialogText:UpdateContentPos()
  self._ui.frame_DialogText:UpdateContentScroll()
  self._ui.frame_DialogText:ComputePos()
end
function Panel_Dialog_Main_Right_Info:ExpirationItemCheck(itemKey)
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
function Panel_Dialog_Main_Right_Info:ExchangeItem_HaveCount(itemKey)
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
function Panel_Dialog_Main_Right_Info:HandleClickedDialogButton_Trade(index)
  _AudioPostEvent_SystemUiForXBOX(0, 17)
  local dialogData = ToClient_GetCurrentDialogData()
  local dialogButton = dialogData:getDialogButtonAt(index)
  if self:ExpirationItemCheck(dialogButton:getNeedItemKey()) then
    local CancelExchange = function()
      return
    end
    local function GoExchange()
      self:HandleClickedDialogButton_ShowData(index)
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
  else
    do
      local needItemCount = dialogButton:getNeedItemCount()
      if CppEnums.DialogButtonType.eDialogButton_Exchange == dialogButton._dialogButtonType and needItemCount > 0 then
        local itemStaticWrapper = getItemEnchantStaticStatus(ItemEnchantKey(dialogButton:getNeedItemKey()))
        if itemStaticWrapper ~= nil then
          local itemCount = self:ExchangeItem_HaveCount(dialogButton:getNeedItemKey())
          if itemCount > 0 then
            local exchangeCount = math.floor(itemCount / needItemCount)
            if exchangeCount > 1 and dialogButton._isValidMultipleExchange then
              local function dialogExchangeCountSet(inputNum)
                local itemStaticWrapper = getItemEnchantStaticStatus(ItemEnchantKey(dialogButton:getNeedItemKey()))
                local _exchangeCount = Int64toInt32(inputNum)
                local function doExchange()
                  dialogData:setExchangeCount(_exchangeCount)
                  self:HandleClickedDialogButton_ShowData(index)
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
      self:HandleClickedDialogButton_ShowData(index)
    end
  end
end
function PaGlobalFunc_MainDialog_Right_Open()
  local self = Panel_Dialog_Main_Right_Info
  self:open()
end
function PaGlobalFunc_MainDialog_Right_Close()
  local self = Panel_Dialog_Main_Right_Info
  self:close()
end
function PaGlobalFunc_MainDialog_Right_GetSizeX()
  local self = Panel_Dialog_Main_Right_Info
  return self._ui.static_RightBg:GetSizeX()
end
function PaGlobalFunc_MainDialog_Right_GetShow()
  local self = Panel_Dialog_Main_Right_Info
  return self._ui.static_RightBg:GetShow()
end
function PaGlobalFunc_MainDialog_Right_Update()
  local self = Panel_Dialog_Main_Right_Info
  self:update()
end
function PaGlobalFunc_MainDialog_Right_InitValue()
  Panel_Dialog_Main_Right_Info._value.isSetData = false
end
function PaGlobalFunc_MainDialog_Right_ReOpen(isButton, ignoreAction)
  local self = Panel_Dialog_Main_Right_Info
  if true == self._value.isSetData then
    local dialogData = ToClient_GetCurrentDialogData()
    if nil == dialogData then
      return
    end
    local npcWord = dialogData:getMainDialog()
    local ignoreWord = PaGlobalFunc_MainDialog_Right_CheckSceneChange(npcWord)
    if true == ignoreAction then
      ignoreWord = PaGlobalFunc_MainDialog_Right_CheckChangeAction(ignoreWord)
    end
    local realDialog = ToClient_getReplaceDialog(ignoreWord)
    if nil == isButton or true == isButton then
      if true == PaGlobalFunc_MainDialog_Bottom_IsLeastFunButtonDefault() then
        self:openAndSetData(dialogData, realDialog, true, false)
      else
        self:openAndSetData(dialogData, realDialog, false, false)
        PaGlobalFunc_MainDialog_Bottom_resetBottomKeyguide()
      end
    else
      self:openAndSetData(dialogData, realDialog, false, false)
    end
  end
end
function PaGlobalFunc_MainDialog_Right_ReOpenWithOtherMent(npcWord)
  local self = Panel_Dialog_Main_Right_Info
  if true == self._value.isSetData then
    local dialogData = ToClient_GetCurrentDialogData()
    if nil == dialogData then
      return
    end
    if nil == npcWord or "" == npcWord then
      return
    end
    local ignoreWord = PaGlobalFunc_MainDialog_Right_CheckSceneChange(npcWord)
    local realDialog = ToClient_getReplaceDialog(ignoreWord)
    self:open()
    self:setDataOnlyMent(dialogData, realDialog)
  end
end
function PaGlobalFunc_MainDialog_Right_List2EventControlCreateExchange(list_content, key)
  local self = Panel_Dialog_Main_Right_Info
  local id = Int64toInt32(key)
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local displayExchangeWrapper = dialogData:getCurrentDisplayExchangeWrapper()
  if nil == displayExchangeWrapper then
    return
  end
  local StaticText_Before = UI.getChildControl(list_content, "StaticText_BeforeTemplete")
  local Static_Arrow = UI.getChildControl(list_content, "Static_ArrowTemplete")
  local StaticText_After = UI.getChildControl(list_content, "StaticText_AfterTemplete")
  StaticText_Before:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  StaticText_Before:setLineCountByLimitAutoWrap(2)
  StaticText_After:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  StaticText_After:setLineCountByLimitAutoWrap(2)
  StaticText_Before:setLocalizedStaticType(self._localize.localizedType)
  StaticText_Before:setLocalizedKey(self._localize.mainDialogLocalizedKey)
  StaticText_After:setLocalizedStaticType(self._localize.localizedType)
  StaticText_After:setLocalizedKey(self._localize.mainDialogLocalizedKey)
  local itemWrapperLua = displayExchangeWrapper:getItemExchangeByNpcStaticStatusWrapperAtIndex(id)
  if nil ~= itemWrapperLua then
    local needItemWrapperLua = itemWrapperLua:getNeedItemStaticStatusWrapper()
    local resultItemWrapperLua = itemWrapperLua:getToItemStaticStatusWrapper()
    if nil ~= needItemWrapperLua and nil ~= resultItemWrapperLua then
      local needItemCount = itemWrapperLua:getNeedItemCount_s64()
      local needItemColorGrade = needItemWrapperLua:getGradeType()
      local needItemName = needItemWrapperLua:getName()
      local resultItemCountn = itemWrapperLua:getToItemCount_s64()
      local resultItemColorGrade = resultItemWrapperLua:getGradeType()
      local resultItemName = resultItemWrapperLua:getName()
      StaticText_Before:SetText(self:getGradeToColorString(needItemColorGrade) .. needItemName .. "<PAOldColor> x" .. tostring(needItemCount))
      StaticText_After:SetText(self:getGradeToColorString(resultItemColorGrade) .. resultItemName .. "<PAOldColor> x" .. tostring(resultItemCount))
      StaticText_Before:SetShow(true)
      StaticText_After:SetShow(true)
      Static_Arrow:SetShow(true)
    end
  end
end
function PaGlobalFunc_MainDialog_Right_HandleOnDialogButton(id)
  local self = Panel_Dialog_Main_Right_Info
  self._value.lastDialogButtonIndex = self._value.currentDialogButtonIndex
  self._value.currentDialogButtonIndex = id
end
function PaGlobalFunc_MainDialog_Right_HandleClickedDialogButton(index, type)
  local self = Panel_Dialog_Main_Right_Info
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local dlgBtnCnt = dialogData:getDialogButtonCount()
  if dlgBtnCnt <= 0 then
    _PA_LOG("\234\185\128\235\175\188\234\181\172", "0\236\157\188\235\166\172\234\176\128 \236\151\134\235\138\148\235\141\176 \235\176\156\236\131\157\237\149\168 \237\153\149\236\157\184 \237\149\132\236\154\148.")
    return
  end
  local dialogButton = dialogData:getDialogButtonAt(index)
  if nil == dialogButton or false == dialogButton._enable then
    local msg = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_NEXTQUEST_NOTYET_BLACKSPIRIT")
    Proc_ShowMessage_Ack(msg)
    return
  end
  if type == "trade" then
    self:HandleClickedDialogButton_Trade(index)
  else
    local dialogButton = dialogData:getDialogButtonAt(index)
    local linkType = dialogButton._linkType
    if CppEnums.DialogButtonType.eDialogButton_CutScene == dialogButton._dialogButtonType and CppEnums.DialogState.eDialogState_Talk == tostring(linkType) then
      FGlobal_SetIsCutScenePlay(true)
    end
    self:HandleClickedDialogButton_ShowData(index)
  end
end
function PaGlobalFunc_MainDialog_Right_InteractionCheck()
  local self = Panel_Dialog_Main_Right_Info
  local isShow = self._ui.static_RightBg:GetShow()
  if false == isShow then
    return
  end
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local dialogButtonCount = dialogData:getDialogButtonCount()
  if 0 == dialogButtonCount then
    return
  end
  local enableDailogButtonIndex
  for index = 0, dialogButtonCount - 1 do
    local dialogButton = dialogData:getDialogButtonAt(index)
    if true == dialogButton._enable then
      enableDailogButtonIndex = index
      break
    end
  end
  if nil == enableDailogButtonIndex then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 2)
  PaGlobalFunc_MainDialog_Right_HandleClickedDialogButton(enableDailogButtonIndex)
end
function PaGlobalFunc_MainDialog_Right_CheckSceneChange(_npcWord)
  if nil == _npcWord or false == _ContentsGroup_RenewUI_Main then
    return _npcWord
  end
  local firstParam = string.split(_npcWord, "{")
  if nil == firstParam[2] then
    return _npcWord
  end
  local secondParam = string.split(firstParam[2], "(")
  local firstMessage = firstParam[1]
  if "ChangeScene" == secondParam[1] then
    local returntext = firstMessage
    local afterChangeScene = string.split(secondParam[2], "}")
    if nil == afterChangeScene[2] then
      return returntext
    else
      returntext = returntext .. afterChangeScene[2]
      return returntext
    end
  else
    return _npcWord
  end
end
function PaGlobalFunc_MainDialog_Right_CheckChangeAction(_npcWord)
  if nil == _npcWord or false == _ContentsGroup_RenewUI_Main then
    return _npcWord
  end
  local firstParam = string.split(_npcWord, "{")
  if nil == firstParam[2] then
    return _npcWord
  end
  local secondParam = string.split(firstParam[2], "(")
  local firstMessage = firstParam[1]
  if "ChangeAction" == secondParam[1] then
    local returntext = firstMessage
    local afterChangeScene = string.split(secondParam[2], "}")
    if nil == afterChangeScene[2] then
      return returntext
    else
      returntext = returntext .. afterChangeScene[2]
      return returntext
    end
  else
    return _npcWord
  end
end
function FromClient_InitMainDialog_Right()
  local self = Panel_Dialog_Main_Right_Info
  self:initialize()
  self:Resize()
  registerEvent("onScreenResize", "FromClient_onScreenResize_MainDialog_Right")
end
function FromClient_onScreenResize_MainDialog_Right()
  local self = Panel_Dialog_Main_Right_Info
  self:Resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_InitMainDialog_Right")
