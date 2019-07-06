function PaGlobal_DialogList_All:initialize()
  if true == PaGlobal_DialogList_All._initialize then
    return
  end
  self:controlAll_Init()
  self:controlPc_Init()
  self:controlConsole_Init()
  self:controlSetShow()
  PaGlobal_DialogList_All:registEventHandler()
  PaGlobal_DialogList_All:validate()
  PaGlobal_DialogList_All._initialize = true
end
function PaGlobal_DialogList_All:controlAll_Init()
  if nil == Panel_Dialog_List_All then
    return
  end
  self._ui.stc_title = UI.getChildControl(Panel_Dialog_List_All, "StaticText_DialogTitle")
  self._ui.stc_mainBg = UI.getChildControl(Panel_Dialog_List_All, "Static_Bg")
  self._ui.txt_npcTitle = UI.getChildControl(Panel_Dialog_List_All, "StaticText_NPCTitle")
  self._ui.frame_dialog = UI.getChildControl(Panel_Dialog_List_All, "Frame_Dialog_Text")
  self._ui.frame_content = UI.getChildControl(self._ui.frame_dialog, "Frame_1_Content")
  self._ui.frame_text = UI.getChildControl(self._ui.frame_content, "StaticText_Dialog_Text")
  self._ui.frame_scroll = UI.getChildControl(self._ui.frame_dialog, "Frame_1_VerticalScroll")
  self._ui.stc_dialogGroup = UI.getChildControl(Panel_Dialog_List_All, "Static_DialogGroup")
  for index = 0, 3 do
    self._ui.stc_dialogList[index] = UI.getChildControl(self._ui.stc_dialogGroup, "Static_Dialog" .. index)
  end
  self._ui.stc_splitTabBg = UI.getChildControl(Panel_Dialog_List_All, "Static_BlackSpiritSplit")
  for index = 0, 3 do
    self._ui.btn_splitRadiolist[index] = UI.getChildControl(self._ui.stc_splitTabBg, "RadioButton_" .. index + 1)
    self._btnSplitString[index] = self._ui.btn_splitRadiolist[index]:GetText()
  end
  self._ui.stc_selectBar = UI.getChildControl(self._ui.stc_splitTabBg, "Static_SelectBar")
  self._frameContentSizeY = self._ui.frame_content:GetSizeY()
end
function PaGlobal_DialogList_All:controlPc_Init()
  if nil == Panel_Dialog_List_All then
    return
  end
  self._ui_pc.stc_spaceBar = UI.getChildControl(self._ui.stc_dialogGroup, "StaticText_Spacebar")
  self._ui_pc.stc_pageGroup = UI.getChildControl(self._ui.stc_dialogGroup, "Static_PageGroup")
  self._ui_pc.btn_before = UI.getChildControl(self._ui_pc.stc_pageGroup, "Button_Before")
  self._ui_pc.btn_next = UI.getChildControl(self._ui_pc.stc_pageGroup, "Button_Next")
  self._ui_pc.txt_page = UI.getChildControl(self._ui_pc.stc_pageGroup, "StaticText_Page")
end
function PaGlobal_DialogList_All:controlConsole_Init()
  if nil == Panel_Dialog_List_All then
    return
  end
  self._ui_console.stc_bottomBg = UI.getChildControl(Panel_Dialog_List_All, "Static_BottomButton_ConsoleUI")
  self._ui_console.stc_iconA = UI.getChildControl(self._ui_console.stc_bottomBg, "StaticText_KeyGuideSelect_ConsoleUI")
  self._ui_console.stc_iconB = UI.getChildControl(self._ui_console.stc_bottomBg, "StaticText_KeyGuideCancel_ConsoleUI")
  self._ui_console.stc_iconLB = UI.getChildControl(self._ui.stc_splitTabBg, "Static_IconLB_ConsoleUI")
  self._ui_console.stc_iconRB = UI.getChildControl(self._ui.stc_splitTabBg, "Static_IconRB_ConsoleUI")
end
function PaGlobal_DialogList_All:controlSetShow()
  if nil == Panel_Dialog_List_All then
    return
  end
  self._ui.stc_title:SetShow(true)
  self._ui.stc_mainBg:SetShow(true)
  self._ui.txt_npcTitle:SetShow(true)
  self._ui.frame_dialog:SetShow(true)
  self._ui.frame_content:SetShow(true)
  self._ui.frame_text:SetShow(true)
  self._ui.stc_dialogGroup:SetShow(true)
  self._ui_pc.stc_spaceBar:SetShow(false)
  if false == ToClient_isConsole() then
    self._ui_console.stc_bottomBg:SetShow(false)
    self._ui_console.stc_iconLB:SetShow(false)
    self._ui_console.stc_iconRB:SetShow(false)
  end
end
function PaGlobal_DialogList_All:prepareOpen()
  if nil == Panel_Dialog_List_All then
    return
  end
  PaGlobal_DialogList_All:update()
  PaGlobal_DialogList_All:resize()
  PaGlobal_DialogList_All:open()
end
function PaGlobal_DialogList_All:open()
  if nil == Panel_Dialog_List_All then
    return
  end
  Panel_Dialog_List_All:SetShow(true)
end
function PaGlobal_DialogList_All:prepareClose()
  if nil == Panel_Dialog_List_All then
    return
  end
  PaGlobal_DialogList_All:close()
end
function PaGlobal_DialogList_All:close()
  if nil == Panel_Dialog_List_All then
    return
  end
  Panel_Dialog_List_All:SetShow(false)
end
function PaGlobal_DialogList_All:update()
  if nil == Panel_Dialog_List_All then
    return
  end
  PaGlobal_DialogList_All._curPage = 1
  PaGlobal_DialogList_All:updateDialog()
end
function PaGlobal_DialogList_All:validate()
  if nil == Panel_Dialog_List_All then
    return
  end
  self._ui.stc_title:isValidate()
  self._ui.stc_mainBg:isValidate()
  self._ui.txt_npcTitle:isValidate()
  self._ui.frame_dialog:isValidate()
  self._ui.frame_content:isValidate()
  self._ui.frame_text:isValidate()
  self._ui.frame_scroll:isValidate()
  self._ui.stc_dialogGroup:isValidate()
  self._ui_pc.stc_spaceBar:isValidate()
  self._ui_pc.stc_pageGroup:isValidate()
  self._ui_pc.btn_before:isValidate()
  self._ui_pc.btn_next:isValidate()
  self._ui_pc.txt_page:isValidate()
  self._ui_console.stc_bottomBg:isValidate()
  self._ui_console.stc_iconA:isValidate()
  self._ui_console.stc_iconB:isValidate()
end
function PaGlobal_DialogList_All:registEventHandler()
  if nil == Panel_Dialog_List_All then
    return
  end
  self._ui_pc.btn_before:addInputEvent("Mouse_LUp", "HandleEventLUp_DialogList_All_PagePrevClick()")
  self._ui_pc.btn_next:addInputEvent("Mouse_LUp", "HandleEventLUp_DialogList_All_PageNextClick()")
  for index = 0, 3 do
    self._ui.btn_splitRadiolist[index]:addInputEvent("Mouse_LUp", "HandleEventLUp_DialogList_All_SelectTab(" .. index .. ")")
  end
end
function PaGlobal_DialogList_All:resize()
  if nil == Panel_Dialog_List_All then
    return
  end
  Panel_Dialog_List_All:ComputePos()
end
function PaGlobal_DialogList_All:updateDialog(isPropose)
  if nil == Panel_Dialog_List_All then
    return
  end
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    ToClient_PopDialogueFlush()
    return
  end
  local mainDialog = dialogData:getMainDialog()
  if nil == mainDialog or "" == mainDialog then
    ToClient_PopDialogueFlush()
    return
  end
  local localizedType = dialogData:getLocalizedTypeForLua()
  local mainDialogLocalizedKey = dialogData:getMainDialogLocalizedKey()
  if mainDialogLocalizedKey == nil then
    ToClient_PopDialogueFlush()
    return
  end
  self._ui.frame_text:setLocalizedStaticType(localizedType)
  self._ui.frame_text:setLocalizedKey(mainDialogLocalizedKey)
  local npcWord = dialogData:getMainDialog()
  local realDialog = ToClient_getReplaceDialog(npcWord)
  local npcTitle = dialogData:getContactNpcTitle()
  local npcName = dialogData:getContactNpcName()
  local talkerNpcKey = dialog_getTalkNpcKey()
  if 0 ~= talkerNpcKey then
    self._ui.txt_npcTitle:SetText(npcTitle)
    self._ui.stc_title:SetText(npcName)
  else
    self._ui.txt_npcTitle:SetText(npcTitle)
    self._ui.stc_title:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_BLACKSOUL"))
  end
  self:changeFilterRadio(false)
  if npcTitle == "" or npcTitle == nil then
    self._ui.txt_npcTitle:SetShow(false)
    self._ui.frame_dialog:SetSpanSize(15, 80)
    self._ui.frame_dialog:SetSize(450, 110)
    self._ui.frame_dialog:ComputePos()
  end
  self._ui.frame_text:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.frame_text:SetText(realDialog)
  if nil ~= isPropose and true == isPropose then
    local proposeDialog = ToClient_getNpcProposeTalk()
    if "" ~= proposeDialog then
      self._ui.frame_text:SetText(proposeDialog)
    end
  end
  if self._frameContentSizeY < self._ui.frame_text:GetTextSizeY() then
    self._ui.frame_scroll:SetShow(true)
    self._ui.frame_content:SetSize(self._ui.frame_content:GetSizeX(), self._ui.frame_text:GetTextSizeY())
  else
    self._ui.frame_scroll:SetShow(false)
    self._ui.frame_content:SetSize(self._ui.frame_content:GetSizeX(), self._frameContentSizeY)
  end
  self._ui.frame_dialog:GetVScroll():SetControlTop()
  self._ui.frame_dialog:UpdateContentScroll()
  self._ui.frame_dialog:UpdateContentPos()
  if (" " == realDialog or nil == realDialog) and (npcTitle == "" or npcTitle == nil) then
    self._ui.stc_mainBg:SetShow(false)
    self._ui.txt_npcTitle:SetShow(false)
    self._ui.frame_dialog:SetShow(false)
    self._ui.stc_title:SetSpanSize(self._ui.stc_title:GetSpanSize().x, 160)
  end
  Auto_NotifyChangeDialog()
  self:updateDialogList(dialogData)
end
function PaGlobal_DialogList_All:updateDialogList(dialogData)
  if nil == Panel_Dialog_List_All then
    return
  end
  if nil == dialogData then
    return
  end
  self._isReContactDialog = false
  self._isAbleDisplayQuest = false
  self._isQuestView = false
  self._dialogMaxPage = 1
  self._dialogListCount = dialogData:getDialogButtonCount()
  self._dialogMaxPage = math.max(math.ceil(self._dialogListCount / 4), self._dialogMaxPage)
  for index = 0, self._dialogListCount - 1 do
    self._isExchangeButtonIndex[index] = false
    self._isPromiseToken[index] = false
  end
  if 0 == self._dialogListCount then
    self._ui.stc_dialogGroup:SetShow(false)
    self._ui.stc_dialogGroup:SetIgnore(true)
    Panel_Dialog_List_All:SetSize(self._panelMinimumSizeX, self._panelMinimumSizeY)
    self._ui.stc_dialogGroup:SetSize(self._ui.stc_dialogGroup:GetSizeX(), 0)
    self._ui_pc.stc_pageGroup:SetShow(false)
    self._ui_pc.stc_pageGroup:ComputePos()
    Panel_Dialog_List_All:ComputePos()
    return
  else
    self._ui.stc_dialogGroup:SetShow(true)
    self._ui.stc_dialogGroup:SetIgnore(false)
    if self._dialogListCount <= 4 then
      Panel_Dialog_List_All:SetSize(self._panelMinimumSizeX, self._panelMinimumSizeY + self._dialogListCount * self._dialogSizeY)
      self._ui.stc_dialogGroup:SetSize(self._ui.stc_dialogGroup:GetSizeX(), self._dialogListCount * self._dialogSizeY)
      self._ui_pc.stc_pageGroup:SetShow(false)
    else
      Panel_Dialog_List_All:SetSize(self._panelMinimumSizeX, self._panelMinimumSizeY + 4 * self._dialogSizeY)
      self._ui.stc_dialogGroup:SetSize(self._ui.stc_dialogGroup:GetSizeX(), 4 * self._dialogSizeY)
      self._ui_pc.stc_pageGroup:SetShow(true)
      self._ui_pc.stc_pageGroup:ComputePos()
    end
    Panel_Dialog_List_All:ComputePos()
  end
  self:updateDialogPage()
end
function PaGlobal_DialogList_All:updateDialogPage()
  if nil == Panel_Dialog_List_All then
    return
  end
  local curPageShowCount = 4
  for index = 0, curPageShowCount - 1 do
    self._ui.stc_dialogList[index]:SetShow(false)
  end
  if 4 >= self._dialogListCount then
    curPageShowCount = self._dialogListCount
  elseif self._curPage * 4 <= self._dialogListCount then
    curPageShowCount = 4
  else
    curPageShowCount = self._dialogListCount - (self._curPage - 1) * 4
  end
  for index = 0, curPageShowCount - 1 do
    self._ui.stc_dialogList[index]:SetShow(true)
    self:dialogControlSet(index)
  end
  self._ui_pc.txt_page:SetText(tostring(self._curPage) .. "/" .. tostring(self._dialogMaxPage))
  if true == self._isReContactDialog or true == self._isAbleDisplayQuest then
    self._ui_pc.stc_spaceBar:SetShow(true)
    self._ui_pc.stc_spaceBar:SetPosX(self._ui.stc_dialogList[0]:GetPosX() + self._ui.stc_dialogList[0]:GetSizeX() - self._ui_pc.stc_spaceBar:GetSizeX())
    self._ui_pc.stc_spaceBar:SetPosY(self._ui.stc_dialogList[0]:GetPosY() + 12)
  else
    self._ui_pc.stc_spaceBar:SetShow(false)
  end
end
function PaGlobal_DialogList_All:dialogControlSet(index)
  if nil == index then
    _PA_ASSERT_NAME(false, "PaGlobal_DialogList_All:dialogControlSet\236\157\152 index\234\176\128 nil\236\158\133\235\139\136\235\139\164", "\236\160\149\236\167\128\237\152\156")
    return
  end
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local dialogIndex = (self._curPage - 1) * 4 + index
  local dialogButton = dialogData:getDialogButtonAt(dialogIndex)
  local dialogText = dialogButton:getText()
  local btn_Dialog = UI.getChildControl(self._ui.stc_dialogList[index], "Button_Dialog")
  local stc_typeIcon = UI.getChildControl(btn_Dialog, "Static_TypeIcon")
  local stc_shapeIcon = UI.getChildControl(btn_Dialog, "Static_ShapeIcon")
  local txt_dialog = UI.getChildControl(self._ui.stc_dialogList[index], "StaticText_Dialog_Name")
  local txt_needs = UI.getChildControl(self._ui.stc_dialogList[index], "StaticText_Dialog_Needs")
  local stc_needItem = UI.getChildControl(self._ui.stc_dialogList[index], "Static_NeedItemIcon")
  local stc_needEnergy = UI.getChildControl(self._ui.stc_dialogList[index], "Static_NeedEnergyIcon")
  stc_typeIcon:SetShow(false)
  txt_needs:SetShow(false)
  stc_needItem:SetShow(false)
  stc_needEnergy:SetShow(false)
  btn_Dialog:addInputEvent("Mouse_LUp", "HandleEventLUp_DialogList_All_ButtonClick(" .. index .. ")")
  local function setChangeIcon(x1, y1, x2, y2)
    stc_typeIcon:SetShow(true)
    stc_typeIcon:ChangeTextureInfoName("Combine/Icon/Combine_Dialogue_Icon_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(stc_typeIcon, x1, y1, x2, y2)
    stc_typeIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    stc_typeIcon:setRenderTexture(stc_typeIcon:getBaseTexture())
  end
  local displayData = Dialog_getButtonDisplayData(dialogIndex)
  if nil ~= displayData and not displayData:empty() then
    setChangeIcon(319, 339, 349, 369)
  end
  if CppEnums.DialogButtonType.eDialogButton_Exchange == dialogButton._dialogButtonType or CppEnums.DialogButtonType.eDialogButton_ExceptExchange == dialogButton._dialogButtonType then
    setChangeIcon(350, 339, 380, 369)
  elseif CppEnums.DialogButtonType.eDialogButton_CutScene == dialogButton._dialogButtonType then
    setChangeIcon(381, 339, 411, 369)
  elseif CppEnums.DialogButtonType.eDialogButton_Knowledge == dialogButton._dialogButtonType then
    setChangeIcon(412, 339, 442, 369)
  end
  if true == stc_typeIcon:GetShow() then
    stc_shapeIcon:SetShow(false)
  else
    stc_shapeIcon:SetShow(true)
  end
  txt_dialog:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_dialog:SetText(dialogText)
  if true == displayData:empty() then
    local linkType = dialogButton._linkType
    local needWp = dialogButton:getNeedWp()
    local isNeedThings = false
    local isNeedWp = false
    local isNeedItem = false
    local needItemCount = 0
    local isExchangalbeButtonCheck = false
    local itemStaticWrapper
    local Wp = 0
    local playerLevel = 0
    local selfPlayer = getSelfPlayer()
    if nil ~= selfPlayer then
      Wp = selfPlayer:getWp()
      playerLevel = selfPlayer:get():getLevel()
    end
    btn_Dialog:SetEnable(dialogButton._enable)
    if true == dialogButton._enable then
      if false == dialogButton._invenPushable then
        btn_Dialog:SetEnable(dialogButton._invenPushable)
        stc_needItem:SetEnable(dialogButton._invenPushable)
        stc_typeIcon:SetMonoTone(true)
        txt_dialog:SetFontColor(Defines.Color.C_FF5A5A5A)
        txt_needs:SetFontColor(Defines.Color.C_FF5A5A5A)
        stc_needItem:SetFontColor(Defines.Color.C_FF5A5A5A)
        stc_needEnergy:SetFontColor(Defines.Color.C_FF5A5A5A)
      else
        txt_dialog:SetFontColor(Defines.Color.C_FFDDC39E)
        txt_dialog:SetFontColor(Defines.Color.C_FFDDC39E)
        txt_needs:SetFontColor(Defines.Color.C_FFDDC39E)
        stc_needItem:SetFontColor(Defines.Color.C_FFDDC39E)
        stc_needEnergy:SetFontColor(Defines.Color.C_FFDDC39E)
      end
    else
      txt_dialog:SetFontColor(Defines.Color.C_FF5A5A5A)
      txt_needs:SetFontColor(Defines.Color.C_FF5A5A5A)
      stc_needItem:SetFontColor(Defines.Color.C_FF5A5A5A)
      stc_needEnergy:SetFontColor(Defines.Color.C_FF5A5A5A)
    end
    if CppEnums.DialogState.eDialogState_ReContact == tostring(linkType) then
      self._isReContactDialog = true
    elseif CppEnums.DialogState.eDialogState_QuestComplete == tostring(linkType) or CppEnums.DialogState.eDialogState_AcceptQuest == tostring(linkType) then
      self._isReContactDialog = true
    end
    if CppEnums.DialogState.eDialogState_QuestComplete == tostring(linkType) then
      self._isQuestComplete = true
    else
      self._isQuestComplete = false
    end
    if CppEnums.DialogState.eDialogState_DisplayQuest == tostring(linkType) and false == self._isAbleDisplayQuest then
      self._isAbleDisplayQuest = true
    end
    if CppEnums.DialogState.eDialogState_AcceptQuest == tostring(linkType) then
      self._isQuestView = true
    end
    local needItemKey
    if CppEnums.DialogState.eDialogState_Talk == tostring(linkType) and needWp > 0 then
      isNeedThings = true
      isNeedWp = true
      if 0 < dialogButton:getNeedItemCount() then
        needItemKey = dialogButton:getNeedItemKey()
        itemStaticWrapper = getItemEnchantStaticStatus(ItemEnchantKey(needItemKey))
        if itemStaticWrapper ~= nil then
          isNeedItem = true
          needItemCount = dialogButton:getNeedItemCount()
        end
      end
    elseif 0 < dialogButton:getNeedItemCount() then
      needItemKey = dialogButton:getNeedItemKey()
      itemStaticWrapper = getItemEnchantStaticStatus(ItemEnchantKey(needItemKey))
      if nil ~= itemStaticWrapper then
        isNeedThings = true
        isNeedItem = true
        needItemCount = dialogButton:getNeedItemCount()
        self._isExchangeButtonIndex[dialogIndex] = true
      end
    end
    if true == isNeedThings then
      if true == isNeedItem then
        stc_needItem:SetShow(true)
        stc_needItem:ChangeTextureInfoName("Icon/" .. itemStaticWrapper:getIconPath())
        local x1, y1, x2, y2 = setTextureUV_Func(stc_needItem, 0, 0, 47, 47)
        stc_needItem:getBaseTexture():setUV(x1, y1, x2, y2)
        stc_needItem:setRenderTexture(stc_needItem:getBaseTexture())
        stc_needItem:SetText("x" .. needItemCount)
        stc_needItem:addInputEvent("Mouse_On", "HandleEventOnOut_DialogList_All_NeedItemTooltip(true," .. needItemKey .. "," .. index .. ")")
        stc_needItem:addInputEvent("Mouse_Out", "HandleEventOnOut_DialogList_All_NeedItemTooltip(false," .. needItemKey .. "," .. index .. ")")
      end
      if true == isNeedWp then
        stc_needEnergy:SetShow(true)
        stc_needEnergy:SetText(needWp .. "/" .. Wp)
        if true == isNeedItem then
          stc_needEnergy:SetPosX(stc_needItem:GetPosX() - stc_needEnergy:GetSizeX() - stc_needEnergy:GetTextSizeX() - 15)
        else
          stc_needEnergy:SetSpanSize(70, 0)
        end
      end
    end
  end
end
function PaGlobal_DialogList_All:changeFilterRadio(isSetFilter)
  if true == isSetFilter then
    Panel_Dialog_List_All:SetSize(685, Panel_Dialog_List_All:GetSizeY())
    Panel_Dialog_List_All:ComputePos()
    self._ui.stc_splitTabBg:SetShow(true)
    self._ui.stc_splitTabBg:ComputePos()
    self._ui.stc_title:SetSpanSize(0, 10)
    self._ui.stc_title:SetSize(685, self._ui.stc_title:GetSizeY())
    self._ui.stc_title:ComputePos()
    self._ui.stc_mainBg:SetShow(true)
    self._ui.stc_mainBg:SetSize(640, 40)
    self._ui.stc_mainBg:ComputePos()
    self._ui.frame_dialog:SetShow(false)
    self._ui.stc_dialogGroup:SetSpanSize(10, 110)
    self._ui.stc_dialogGroup:SetSize(640, self._ui.stc_dialogGroup:GetSizeY())
    self._ui.stc_dialogGroup:ComputePos()
    self._ui_pc.stc_pageGroup:SetSize(630, self._ui_pc.stc_pageGroup:GetSizeY())
    self._ui_pc.stc_pageGroup:ComputePos()
    self._ui_pc.btn_before:ComputePos()
    self._ui_pc.btn_next:ComputePos()
    self._ui_pc.txt_page:ComputePos()
    for index = 0, 3 do
      self._ui.stc_dialogList[index]:SetSize(630, self._ui.stc_dialogList[index]:GetSizeY())
      self._ui.stc_dialogList[index]:ComputePos()
      local btn_dialog = UI.getChildControl(self._ui.stc_dialogList[index], "Button_Dialog")
      btn_dialog:SetSize(630, btn_dialog:GetSizeY())
      btn_dialog:ComputePos()
    end
  else
    Panel_Dialog_List_All:SetSize(525, Panel_Dialog_List_All:GetSizeY())
    Panel_Dialog_List_All:ComputePos()
    self._ui.stc_splitTabBg:SetShow(false)
    self._ui.stc_title:SetSpanSize(0, 10)
    self._ui.stc_title:SetSize(525, self._ui.stc_title:GetSizeY())
    self._ui.stc_title:ComputePos()
    self._ui.txt_npcTitle:SetShow(true)
    self._ui.stc_mainBg:SetShow(true)
    self._ui.stc_mainBg:SetSize(480, 150)
    self._ui.stc_mainBg:ComputePos()
    self._ui.frame_dialog:SetSize(450, 90)
    self._ui.frame_dialog:SetSpanSize(15, 105)
    self._ui.frame_dialog:SetShow(true)
    self._ui.frame_dialog:ComputePos()
    self._ui.stc_dialogGroup:SetSpanSize(10, 220)
    self._ui.stc_dialogGroup:SetSize(470, self._ui.stc_dialogGroup:GetSizeY())
    self._ui.stc_dialogGroup:ComputePos()
    self._ui_pc.stc_pageGroup:SetSize(470, self._ui_pc.stc_pageGroup:GetSizeY())
    self._ui_pc.stc_pageGroup:ComputePos()
    self._ui_pc.btn_before:ComputePos()
    self._ui_pc.btn_next:ComputePos()
    self._ui_pc.txt_page:ComputePos()
    for index = 0, 3 do
      self._ui.stc_dialogList[index]:SetSize(470, self._ui.stc_dialogList[index]:GetSizeY())
      self._ui.stc_dialogList[index]:ComputePos()
      local btn_dialog = UI.getChildControl(self._ui.stc_dialogList[index], "Button_Dialog")
      btn_dialog:SetSize(470, btn_dialog:GetSizeY())
      btn_dialog:ComputePos()
    end
  end
  self._ui_pc.stc_spaceBar:ComputePos()
end
function PaGlobal_DialogList_All:clickList(index)
  if nil == Panel_Dialog_List_All then
    return
  end
  local dialogData = ToClient_GetCurrentDialogData()
  local dlgBtnCnt = dialogData:getDialogButtonCount()
  if nil == dialogData or dlgBtnCnt <= 0 then
    _PA_ASSERT_NAME(false, "PaGlobal_DialogList_All:clickList\236\157\152 dialogData\234\176\128 \235\185\132\236\160\149\236\131\129\236\160\129\236\158\133\235\139\136\235\139\164", "\236\160\149\236\167\128\237\152\156")
    return
  end
  local realIndex = (self._curPage - 1) * 4 + index
  local function clickDialogButtonReq()
    local displayData = Dialog_getButtonDisplayData(realIndex)
    local questInfo = questList_isClearQuest(1038, 2)
    if displayData:empty() then
      Dialog_clickDialogButtonReq(realIndex)
    else
      TalkPopup_SelectedIndex(realIndex)
      TalkPopup_Show(displayData)
    end
  end
  local dialogButton = dialogData:getDialogButtonAt(realIndex)
  if true == self:isCheckExchangeItemButton(realIndex) then
    audioPostEvent_SystemUi(0, 17)
    if true == self:expirationItemCheck(dialogButton:getNeedItemKey()) then
      local msgTitle = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_ITEMEXCHANGE_TITLE")
      local msgContent = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_ITEMEXCHANGE_EXPIRATIONCHECK")
      local messageboxData = {
        title = msgTitle,
        content = msgContent,
        functionYes = clickDialogButtonReq,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
    elseif true == ToClient_isAnyLockedItem(ItemEnchantKey(dialogButton:getNeedItemKey())) then
      local msgTitle = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_ITEMEXCHANGE_TITLE")
      local msgContent = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_ITEMEXCHANGE_EXPIRATIONCHECK")
      local messageboxData = {
        title = msgTitle,
        content = msgContent,
        functionYes = clickDialogButtonReq,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
    else
      do
        local needItemCount = dialogButton:getNeedItemCount()
        if CppEnums.DialogButtonType.eDialogButton_Exchange == dialogButton._dialogButtonType and needItemCount > 0 then
          do
            local itemStaticWrapper = getItemEnchantStaticStatus(ItemEnchantKey(dialogButton:getNeedItemKey()))
            if nil ~= itemStaticWrapper then
              local itemCount = self:enchangeItemHaveCount(dialogButton:getNeedItemKey())
              if itemCount > 0 then
                local exchangeCount = math.floor(itemCount / needItemCount)
                if exchangeCount > 1 and true == dialogButton._isValidMultipleExchange then
                  local function dialogExchangeCountSet(inputNum)
                    local _exchangeCount = Int64toInt32(inputNum)
                    local function doExchange()
                      dialogData:setExchangeCount(_exchangeCount)
                      clickDialogButtonReq()
                    end
                    local msgTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
                    local msgContent = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DIALOG_EXCHANGEITEM_CANCLE", "itemName", itemStaticWrapper:getName(), "count", _exchangeCount * needItemCount)
                    local messageBoxData = {
                      title = msgTitle,
                      content = msgContent,
                      functionYes = doExchange,
                      functionNo = MessageBox_Empty_function,
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
        end
        clickDialogButtonReq()
      end
    end
  else
    if CppEnums.DialogButtonType.eDialogButton_CutScene == dialogButton._dialogButtonType and CppEnums.DialogState.eDialogState_Talk == tostring(dialogButton._linkType) then
      FGlobal_SetIsCutScenePlay(true)
    end
    clickDialogButtonReq()
  end
end
function PaGlobal_DialogList_All:isCheckExchangeItemButton(index)
  return self._isExchangeButtonIndex[index]
end
function PaGlobal_DialogList_All:expirationItemCheck(index)
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
function PaGlobal_DialogList_All:enchangeItemHaveCount(itemKey)
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
