local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_AH = CppEnums.PA_UI_ALIGNHORIZON
local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
PaGlobal_Alchemy = {
  _isCook = true,
  _maxMaterialCount = 5,
  _filterText = nil,
  _materialItemKeys = {},
  _selectedKnowledge = -1,
  _invenFilterItemTypes = {
    [CppEnums.ItemType.Equip] = 1
  },
  _ui = {
    _titleBg = UI.getChildControl(Panel_Alchemy, "Static_PartLine"),
    _staticTextTitle = nil,
    _buttonQuestion = UI.getChildControl(Panel_Alchemy, "Button_Question"),
    _buttonClose = UI.getChildControl(Panel_Alchemy, "Button_Close"),
    _buttonStartAlchemy = UI.getChildControl(Panel_Alchemy, "Button_StartAlchemy"),
    _buttonMassProduction = UI.getChildControl(Panel_Alchemy, "Button_MassProduction"),
    _staticMaterialSlots = {},
    _staticAlchemyIcon = UI.getChildControl(Panel_Alchemy, "Static_AlchemyIcon"),
    _frameContentAlchemyDesc = nil,
    _scrollAlchemyDesc = nil,
    _staticTextAlchemyDesc = nil,
    _checkButtonLearntOnly = UI.getChildControl(Panel_Alchemy, "CheckButton_ShowOnlyKnownRecipe"),
    _staticTextEmptyKnowledge = nil,
    _editBoxSearch = UI.getChildControl(Panel_Alchemy, "EditBox_Search"),
    _buttonSearch = UI.getChildControl(Panel_Alchemy, "PushButton_Search"),
    _staticTextSearchFailed = nil,
    _listKnowledge = UI.getChildControl(Panel_Alchemy, "List2_AlchemyRecipe")
  }
}
PaGlobal_Alchemy._ui._staticTextTitle = UI.getChildControl(PaGlobal_Alchemy._ui._titleBg, "StaticText_TitleIcon")
local InventoryFilterFunction = function(slotNo, itemWrapper, whereType)
  if CppEnums.ItemWhereType.eInventory ~= whereType then
    return true
  end
  local isTradable = itemWrapper:getStaticStatus():isPersonalTrade()
  local isVested = itemWrapper:get():isVested()
  if isTradable and isVested then
    return true
  end
  if true == itemWrapper:get():isSeized() then
    return true
  end
  local itemType = itemWrapper:getStaticStatus():getItemType()
  if nil ~= PaGlobal_Alchemy._invenFilterItemTypes[itemType] then
    return true
  end
  local isCash = itemWrapper:getStaticStatus():get():isCash()
  if isCash then
    return true
  end
  return false
end
function Panel_Alchemy_CreateKnowledgeListContent(content, key)
  local knowledgeIndex = Int64toInt32(key)
  local recipe = UI.getChildControl(content, "StaticText_List2_AlchemyRecipe")
  local selectList = UI.getChildControl(content, "Static_List2_SelectList")
  local mentalCardStaticWrapper = ToClient_AlchemyGetKnowledge(knowledgeIndex)
  recipe:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  if PaGlobal_Alchemy._selectedKnowledge == knowledgeIndex then
    selectList:SetShow(true)
  else
    selectList:SetShow(false)
  end
  function Alchemy_UnknownRecipe_TooltipShow(index)
    local mentalCardSSW = ToClient_AlchemyGetKnowledge(index)
    if nil ~= mentalCardSSW then
      TooltipSimple_Show(recipe, mentalCardSSW:getKeyword())
    end
  end
  function Alchemy_KnownRecipe_TooltipShow(index)
    local mentalCardSSW = ToClient_AlchemyGetKnowledge(index)
    if nil ~= mentalCardSSW then
      TooltipSimple_Show(recipe, mentalCardSSW:getName(), mentalCardSSW:getKeyword())
    end
  end
  if nil ~= mentalCardStaticWrapper then
    local isLearn = ToClient_AlchemyIsLearntMentalCard(mentalCardStaticWrapper:getKey())
    if true == isLearn then
      recipe:SetFontColor(UI_color.C_FF84FFF5)
      recipe:SetText(mentalCardStaticWrapper:getName())
      recipe:addInputEvent("Mouse_On", "Alchemy_KnownRecipe_TooltipShow(" .. knowledgeIndex .. ")")
    else
      recipe:SetFontColor(UI_color.C_FF888888)
      recipe:SetText("??? ( " .. mentalCardStaticWrapper:getKeyword() .. " )")
      recipe:addInputEvent("Mouse_On", "Alchemy_UnknownRecipe_TooltipShow(" .. knowledgeIndex .. ")")
    end
    recipe:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
    recipe:SetShow(true)
    recipe:SetPosY(6)
    recipe:addInputEvent("Mouse_LUp", "PaGlobal_Alchemy:selectKnowledge( " .. knowledgeIndex .. " )")
  else
    recipe:SetShow(false)
  end
end
function PaGlobal_Alchemy:initialize()
  local ui = self._ui
  ui._staticCookingPotBack = UI.getChildControl(Panel_Alchemy, "Static_Cook_Pot_Back")
  ui._staticCookingPotFront = UI.getChildControl(Panel_Alchemy, "Static_Cook_Pot_Front")
  ui._staticAlchemyPotBack = UI.getChildControl(Panel_Alchemy, "Static_Alchemy_Pot_Back")
  ui._staticAlchemyPotFront = UI.getChildControl(Panel_Alchemy, "Static_Alchemy_Pot_Front")
  ui._animPushItemCook = {}
  ui._animPushItemAlchemy = {}
  ui._frameAlchemyTips = UI.getChildControl(Panel_Alchemy, "Frame_AlchemyTips")
  ui._frameContentAlchemyTips = UI.getChildControl(ui._frameAlchemyTips, "Frame_1_Content")
  ui._staticTextAlchemyTips = UI.getChildControl(ui._frameContentAlchemyTips, "StaticText_AlchemyTips")
  ui._frameAlchemyDesc = UI.getChildControl(Panel_Alchemy, "Frame_Alchemy")
  ui._scrollAlchemyDesc = UI.getChildControl(ui._frameAlchemyDesc, "VerticalScroll")
  ui._frameContentAlchemyDesc = UI.getChildControl(ui._frameAlchemyDesc, "Frame_1_Content")
  ui._staticTextAlchemyDesc = UI.getChildControl(ui._frameContentAlchemyDesc, "StaticText_AlchemyDesc")
  ui._staticTextEmptyKnowledge = UI.getChildControl(ui._listKnowledge, "StaticText_EmptyKnowldege")
  ui._staticTextSearchFailed = UI.getChildControl(ui._listKnowledge, "StaticText_SearchFail")
  ui._staticTextAlchemyTips:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui._staticTextAlchemyDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui._staticTextAlchemyTips:SetText(ui._staticTextAlchemyTips:GetText())
  ui._frameContentAlchemyTips:SetSize(ui._frameContentAlchemyTips:GetSizeX(), ui._staticTextAlchemyTips:GetSizeY())
  ui._frameAlchemyTips:UpdateContentScroll()
  ui._staticTextEmptyKnowledge:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_EMPTY_LEARNT_KNOWLEDGE"))
  ui._staticTextSearchFailed:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_NO_SEARCH_RESULT"))
  ui._editBoxSearch:RegistReturnKeyEvent("PaGlobal_Alchemy:handleMouseLUp_SearchButton()")
  ui._editBoxSearch:addInputEvent("Mouse_LUp", "PaGlobal_Alchemy:clearEditBoxSearchText()")
  ui._checkButtonLearntOnly:addInputEvent("Mouse_LUp", "PaGlobal_Alchemy:handleMouseLUp_CheckButtonLearntOnly()")
  ui._buttonClose:addInputEvent("Mouse_LUp", "PaGlobal_Alchemy:closePanel()")
  ui._buttonStartAlchemy:addInputEvent("Mouse_LUp", "PaGlobal_Alchemy:startAlchemy(Defines.s64_const.s64_1)")
  ui._buttonMassProduction:addInputEvent("Mouse_LUp", "PaGlobal_Alchemy:showMassProductionMessageBox()")
  ui._buttonSearch:addInputEvent("Mouse_LUp", "PaGlobal_Alchemy:handleMouseLUp_SearchButton()")
  ui._listKnowledge:changeAnimationSpeed(10)
  ui._listKnowledge:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "Panel_Alchemy_CreateKnowledgeListContent")
  ui._listKnowledge:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  ui._staticCookingPotBack:AddEffect("fUI_AlchemyCook01", true, 0, 0)
  ui._staticAlchemyPotBack:AddEffect("fUI_AlchemyCook01", true, 0, 0)
  SlotItem.new(ui._animPushItemCook, "AnimPushItemCook", 0, ui._staticCookingPotBack, {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createCash = true
  })
  ui._animPushItemCook:createChild()
  ui._animPushItemCook.icon:SetShow(false)
  SlotItem.new(ui._animPushItemAlchemy, "AnimPushItemAlchemy", 0, ui._staticAlchemyPotBack, {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createCash = true
  })
  ui._animPushItemAlchemy:createChild()
  ui._animPushItemAlchemy.icon:SetShow(false)
  ui._staticMaterialSlots = {}
  for i = 1, self._maxMaterialCount do
    local materialSlot = UI.getChildControl(Panel_Alchemy, "Static_IconSlot" .. i)
    local slotIcon = {}
    slotIcon = SlotItem.new(slotIcon, "MaterialIcon" .. i, 0, materialSlot, {
      createIcon = true,
      createBorder = true,
      createCount = true,
      createCash = true
    })
    slotIcon:createChild()
    slotIcon.icon:SetIgnore(false)
    slotIcon.icon:addInputEvent("Mouse_On", "PaGlobal_Alchemy:handleMouseOn_ShowMaterialTooltip(" .. i .. ")")
    slotIcon.icon:addInputEvent("Mouse_Out", "PaGlobal_Alchemy:handleMouseOut_HideMaterialTooltip()")
    slotIcon.icon:addInputEvent("Mouse_RUp", "PaGlobal_Alchemy:popMaterial(" .. i .. ")")
    slotIcon.icon:SetSize(materialSlot:GetSizeX(), materialSlot:GetSizeY())
    ui._staticMaterialSlots[i] = slotIcon
  end
end
function PaGlobal_Alchemy:showPanel(isCook, installationType)
  if true == Panel_Alchemy:GetShow() then
    if isCook == self._isCook then
      return
    end
    self:closePanel()
  end
  self._isCook = isCook
  local ui = self._ui
  ui._staticCookingPotBack:SetShow(true == isCook)
  ui._staticCookingPotFront:SetShow(true == isCook)
  ui._staticAlchemyPotBack:SetShow(false == isCook)
  ui._staticAlchemyPotFront:SetShow(false == isCook)
  local iconTextureUV = {
    alchemy = {
      287,
      59,
      342,
      114
    },
    cook = {
      173,
      59,
      228,
      114
    }
  }
  ui._staticTextTitle:ChangeTextureInfoName("renewal/ui_icon/console_icon_title.dds")
  if true == isCook then
    ui._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelCook\" )")
    ui._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelCook\", \"true\")")
    ui._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelCook\", \"false\")")
    ui._staticTextTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_COOKING"))
    ui._checkButtonLearntOnly:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_SHOW_LEARNT_COOK"))
    ui._checkButtonLearntOnly:SetEnableArea(0, 0, ui._checkButtonLearntOnly:GetSizeX() + ui._checkButtonLearntOnly:GetTextSizeX() + 5, ui._checkButtonLearntOnly:GetSizeY())
    ui._buttonStartAlchemy:SetText(PAGetString(Defines.StringSheet_RESOURCE, "COOK_LETSCOOKING"))
    local x1, y1, x2, y2 = setTextureUV_Func(ui._staticTextTitle, iconTextureUV.cook[1], iconTextureUV.cook[2], iconTextureUV.cook[3], iconTextureUV.cook[4])
    ui._staticTextTitle:getBaseTexture():setUV(x1, y1, x2, y2)
    ui._staticTextTitle:setRenderTexture(ui._staticTextTitle:getBaseTexture())
  else
    ui._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelAlchemy\" )")
    ui._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelAlchemy\", \"true\")")
    ui._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelAlchemy\", \"false\")")
    ui._staticTextTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_ALCHEMY"))
    ui._checkButtonLearntOnly:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_SHOW_LEARNT_ALCHEMY"))
    ui._checkButtonLearntOnly:SetEnableArea(0, 0, ui._checkButtonLearntOnly:GetSizeX() + ui._checkButtonLearntOnly:GetTextSizeX() + 5, ui._checkButtonLearntOnly:GetSizeY())
    ui._buttonStartAlchemy:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_REFINING"))
    local x1, y1, x2, y2 = setTextureUV_Func(ui._staticTextTitle, iconTextureUV.alchemy[1], iconTextureUV.alchemy[2], iconTextureUV.alchemy[3], iconTextureUV.alchemy[4])
    ui._staticTextTitle:getBaseTexture():setUV(x1, y1, x2, y2)
    ui._staticTextTitle:setRenderTexture(ui._staticTextTitle:getBaseTexture())
  end
  audioPostEvent_SystemUi(12, 11)
  ToClient_AlchemyClearMaterialSlot()
  self:updateMaterialSlot()
  if isCook then
    ToClient_AlchemyReconstructAlchemyKnowledge(30010)
  else
    ToClient_AlchemyReconstructAlchemyKnowledge(31000)
  end
  self:updateKnowledgeList()
  Panel_Alchemy:SetShow(true, true)
  Panel_Alchemy:SetPosX(getScreenSizeX() - getScreenSizeX() / 2 - Panel_Alchemy:GetSizeX() + Panel_Alchemy:GetSizeX() / 2)
  Panel_Alchemy:ComputePos()
  local function funcRClicked(slotIdx, itemWrapper, count)
    self:showInventoryNumpad(slotIdx, count)
  end
  local function funcOtherWindowOpen()
    self:closePanel()
  end
  Inventory_SetFunctor(InventoryFilterFunction, funcRClicked, funcOtherWindowOpen, nil)
  FGlobal_SetInventoryDragNoUse(Panel_Alchemy)
  InventoryWindow_Show()
end
function PaGlobal_Alchemy:closePanel()
  FGlobal_Alchemy_ClearEditFocus()
  if false == Panel_Alchemy:IsShow() then
    return
  end
  self._filterText = nil
  self._ui._animPushItemAlchemy.icon:SetShow(false)
  self._ui._animPushItemCook.icon:SetShow(false)
  self._ui._checkButtonLearntOnly:SetCheck(false)
  Panel_Alchemy:SetShow(false)
  PaGlobal_RecentCook:closePanel()
  InventoryWindow_Close()
  Panel_Alchemy:ComputePos()
end
function PaGlobal_Alchemy:playPushItemAnimation(invenSlotIndex, itemCount)
  local itemWrapper = getInventoryItem(invenSlotIndex)
  local staticAnimPushItem = self._isCook and self._ui._animPushItemCook or self._ui._animPushItemAlchemy
  staticAnimPushItem:setItemByStaticStatus(itemWrapper:getStaticStatus(), itemCount)
  local posX = 80
  local posY = -100
  local timeRate = 1
  audioPostEvent_SystemUi(12, 12)
  local aniCtrl = staticAnimPushItem.icon
  aniCtrl:SetShow(true)
  aniCtrl:AddEffect("fUI_AlchemySplash01", false, 0, 0)
  local aniInfo = aniCtrl:addMoveAnimation(0 * timeRate, 1.5 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo:SetStartPosition(posX, posY)
  aniInfo:SetEndPosition(posX, posY + 180)
  local aniInfo2 = aniCtrl:addRotateAnimation(0 * timeRate, 1.5 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo2:SetStartRotate(0)
  aniInfo2:SetEndRotate(1)
  aniInfo2:SetRotateCount(1)
end
function PaGlobal_Alchemy:updateMaterialSlot()
  local countSlotPushed = ToClient_AlchemyGetCountSlotWithMaterial()
  for slotIndex = 1, self._maxMaterialCount do
    if slotIndex <= countSlotPushed then
      local itemStaticWrapper = ToClient_AlchemyGetItemStaticAtMaterialSlot(slotIndex - 1)
      if nil ~= itemStaticWrapper then
        local itemCount = ToClient_AlchemyGetCountItemAtMaterialSlot_s64(slotIndex - 1)
        self._ui._staticMaterialSlots[slotIndex]:setItemByStaticStatus(itemStaticWrapper, itemCount)
        self._ui._staticMaterialSlots[slotIndex].icon:SetShow(true)
      else
        self._ui._staticMaterialSlots[slotIndex].icon:SetShow(false)
      end
    else
      self._ui._staticMaterialSlots[slotIndex].icon:SetShow(false)
    end
  end
end
function PaGlobal_Alchemy:updateKnowledgeList()
  local ui = self._ui
  self:clearKnowledgeList()
  ToClient_AlchemySetKnowledgeFilter(ui._checkButtonLearntOnly:IsCheck(), self._filterText)
  local countFilteredKnowledge = ToClient_AlchemyGetCountFilteredKnowledge()
  for i = 1, countFilteredKnowledge do
    ui._listKnowledge:getElementManager():pushKey(ToClient_AlchemyGetFilteredKnowledgeIndex(i - 1))
  end
  if 0 == Int64toInt32(ui._listKnowledge:getElementManager():getSize()) then
    local isSearchEnabled = self._filterText ~= nil
    ui._staticTextSearchFailed:SetShow(true == isSearchEnabled)
    ui._staticTextEmptyKnowledge:SetShow(false == isSearchEnabled)
  else
    ui._staticTextSearchFailed:SetShow(false)
    ui._staticTextEmptyKnowledge:SetShow(false)
  end
end
function PaGlobal_Alchemy:clearKnowledgeList()
  self._selectedKnowledge = -1
  self._ui._listKnowledge:getElementManager():clearKey()
  if self._isCook then
    self:setAlchemyDescriptionText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_WANTMORE_SELECT_COOKKNOWLEDGE"))
  else
    self:setAlchemyDescriptionText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_WANTMORE_SELECT_ALCHEMYKNOWLEDGE"))
  end
end
function PaGlobal_Alchemy:setAlchemyDescriptionText(text)
  local ui = self._ui
  ui._staticTextAlchemyDesc:SetText(text)
  ui._staticTextAlchemyDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui._frameContentAlchemyDesc:SetSize(ui._frameContentAlchemyDesc:GetSizeX(), ui._staticTextAlchemyDesc:GetSizeY())
  ui._scrollAlchemyDesc:SetControlPos(0)
  ui._frameAlchemyDesc:UpdateContentScroll()
  ui._frameAlchemyDesc:UpdateContentPos()
end
function PaGlobal_Alchemy:pushItemFromInventory(invenSlotIndex, itemCount)
  local countSlotPushed = ToClient_AlchemyGetCountSlotWithMaterial()
  _PA_ASSERT(countSlotPushed <= self._maxMaterialCount, "\236\139\164\236\160\156 \236\130\172\236\154\169 \236\164\145\236\157\184 \236\138\172\235\161\175 \234\176\156\236\136\152\234\176\128 \237\151\136\236\154\169\235\144\156 \234\176\156\236\136\152\235\179\180\235\139\164 \235\167\142\236\138\181\235\139\136\235\139\164.")
  if countSlotPushed == self._maxMaterialCount and false == ToClient_AlchemyIsInvenSlotPushedInMaterialSlot(invenSlotIndex) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_CANT_ADD_ITEM"))
    return
  end
  self:playPushItemAnimation(invenSlotIndex, itemCount)
  ToClient_AlchemyPushItemFromInventory(invenSlotIndex, itemCount)
  self:updateMaterialSlot()
end
function PaGlobal_Alchemy:clearMaterialSlot()
  ToClient_AlchemyClearMaterialSlot()
  self:updateMaterialSlot()
end
function PaGlobal_Alchemy:showInventoryNumpad(slotIndex, itemCount)
  if true == checkAlchemyAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_NOT_CHANGE"))
    return
  end
  local function funcConfirmClicked(count, slotIdx)
    self:pushItemFromInventory(slotIdx, count)
  end
  Panel_NumberPad_Show(true, itemCount, slotIndex, funcConfirmClicked)
end
function PaGlobal_Alchemy:selectKnowledge(knowledgeIndex)
  local ui = self._ui
  local mentalCardStaticWrapper = ToClient_AlchemyGetKnowledge(knowledgeIndex)
  if nil ~= mentalCardStaticWrapper then
    PaGlobal_RecentCook:closePanel()
    local isLearn = ToClient_AlchemyIsLearntMentalCard(mentalCardStaticWrapper:getKey())
    if true == isLearn then
      if Panel_Window_Inventory:GetSizeX() > (getScreenSizeX() - (Panel_Alchemy:GetSizeX() + Panel_RecentCook:GetSizeX())) * 0.5 then
        Panel_Alchemy:SetPosX(getScreenSizeX() - (Panel_Alchemy:GetSizeX() + 430 + 310))
        PaGlobal_RecentCook:showPanel(knowledgeIndex, self._isCook, Panel_Alchemy:GetPosX() + Panel_Alchemy:GetSizeX() + 5, Panel_Alchemy:GetPosY() + 25)
      else
        Panel_Alchemy:SetPosX((getScreenSizeX() - (Panel_Alchemy:GetSizeX() + Panel_RecentCook:GetSizeX())) * 0.5)
        PaGlobal_RecentCook:showPanel(knowledgeIndex, self._isCook, Panel_Alchemy:GetPosX() + Panel_Alchemy:GetSizeX(), Panel_Alchemy:GetPosY())
      end
      ui._staticAlchemyIcon:ChangeTextureInfoName(mentalCardStaticWrapper:getImagePath())
      self:setAlchemyDescriptionText(mentalCardStaticWrapper:getDesc())
    else
      ui._staticAlchemyIcon:ChangeTextureInfoName("UI_Artwork/Unkown_Intelligence.dds")
      self:setAlchemyDescriptionText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_THISKNOWLEDGE_NOT_YET"))
    end
  end
  local prevKnowledge = self._selectedKnowledge
  self._selectedKnowledge = knowledgeIndex
  ui._listKnowledge:requestUpdateByKey(toInt64(0, prevKnowledge))
  ui._listKnowledge:requestUpdateByKey(toInt64(0, knowledgeIndex))
end
function PaGlobal_Alchemy:startAlchemy(countProduction)
  if ToClient_AlchemyGetCountSlotWithMaterial() <= 0 then
    return
  end
  if countProduction > Defines.s64_const.s64_1 and false == ToClient_AlchemySetupMaterialsForMassProduction(countProduction) then
    _PA_ASSERT(false, "setupMaterialsForMassProduction\236\157\180 \236\139\164\237\140\168\237\150\136\236\138\181\235\139\136\235\139\164. countProduction\236\157\180 ToClient_AlchemyGetMaxMassProductionCount()\235\179\180\235\139\164 \237\129\176 \234\178\131\236\157\128 \236\149\132\235\139\140\236\167\128 \237\153\149\236\157\184\237\149\180\235\179\180\236\139\156\234\184\176 \235\176\148\235\158\141\235\139\136\235\139\164.")
  end
  ToClient_AlchemyStart(self._isCook, countProduction)
  local progressBarTimeSec = ToClient_AlchemyGetAlchemyTime(self._isCook) / 1000
  if 0 == progressBarTimeSec then
    return
  end
  EventProgressBarShow(true, progressBarTimeSec, true == self._isCook and 7 or 9)
  audioPostEvent_SystemUi(1, 0)
  self:closePanel()
end
function PaGlobal_Alchemy:cancelAlchemy()
  ToClient_AlchemyCancel()
end
function PaGlobal_Alchemy:popMaterial(slotIndex)
  ToClient_AlchemyPopMaterial(slotIndex - 1)
  self:updateMaterialSlot()
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_Alchemy:showMassProductionMessageBox()
  local msgBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local msgBoxContentStrID = self._isCook and "LUA_ALCHEMY_MSGBOX_COOK_SEQUENCE_MSG" or "LUA_ALCHEMY_MSGBOX_ALCHEMY_SEQUENCE_MSG"
  local funcYesButtonClicked = function()
    PaGlobal_Alchemy:askMassProductionQuantity()
  end
  local msgBoxData = {
    title = msgBoxTitle,
    content = PAGetString(Defines.StringSheet_GAME, msgBoxContentStrID),
    functionYes = funcYesButtonClicked,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(msgBoxData, "middle")
end
function PaGlobal_Alchemy:askMassProductionQuantity()
  local countSlotPushed = ToClient_AlchemyGetCountSlotWithMaterial()
  if countSlotPushed <= 0 then
    return
  end
  local maxCount = ToClient_AlchemyGetMaxMassProductionCount()
  if maxCount >= Defines.s64_const.s64_1 then
    local function funcConfirmClicked(inputNumber)
      self:startAlchemy(inputNumber)
    end
    Panel_NumberPad_Show(true, maxCount, nil, funcConfirmClicked)
  end
end
function PaGlobal_Alchemy:resumeMassProduction()
  local countDoingAlchemy = ToClient_AlchemyGetDoingAlchemyCount()
  self:startAlchemy(countDoingAlchemy)
end
function PaGlobal_Alchemy:clearEditBoxSearchText()
  PaGlobal_Alchemy._ui._editBoxSearch:SetEditText("", false)
end
function PaGlobal_Alchemy:clearFocusEdit()
  if nil == GetFocusEdit() or GetFocusEdit():GetKey() ~= PaGlobal_Alchemy._ui._editBoxSearch:GetKey() then
    return
  end
  ClearFocusEdit()
end
function PaGlobal_Alchemy:handleMouseOn_ShowMaterialTooltip(slotIndex)
  local itemStatic = ToClient_AlchemyGetItemStaticAtMaterialSlot(slotIndex - 1)
  if nil == itemStatic then
    return
  end
  local uiBase = self._ui._staticMaterialSlots[slotIndex].icon
  Panel_Tooltip_Item_Show(itemStatic, uiBase, true, false)
end
function PaGlobal_Alchemy:handleMouseOut_HideMaterialTooltip()
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_Alchemy:handleMouseLUp_SearchButton()
  self:clearFocusEdit()
  local filterText = self._ui._editBoxSearch:GetEditText()
  if filterText == self._filterText then
    return
  end
  self._filterText = filterText
  if nil ~= self._filterText and 0 == string.len(self._filterText) then
    self._filterText = nil
  end
  ToClient_AlchemySetKnowledgeFilter(true, self._filterText)
  self:updateKnowledgeList()
end
function PaGlobal_Alchemy:handleMouseLUp_CheckButtonLearntOnly()
  self:updateKnowledgeList()
end
function PaGlobal_Alchemy:handleMouseRUp_MaterialSlotIcon(slotIndex)
  self:popMaterial(slotIndex)
end
function FGlobal_Alchemy_Close()
  PaGlobal_Alchemy:closePanel()
end
function FGlobal_Alchemy_DoAlchemy()
  if false == checkAlchemyAction() then
    return
  end
  ToClient_AlchemyDo()
end
function FGlobal_Alchemy_CheckEditBox(targetUI)
  return nil ~= targetUI and targetUI:GetKey() == PaGlobal_Alchemy._ui._editBoxSearch:GetKey()
end
function FGlobal_Alchemy_ClearEditFocus()
  PaGlobal_Alchemy:clearFocusEdit()
  PaGlobal_Alchemy:clearEditBoxSearchText()
end
function FromClient_ShowAlchemyPanel_PaGlobal_Alchemy(isCook, installationType)
  PaGlobal_Alchemy:showPanel(isCook, installationType)
end
function FromClient_luaLoadComplete_PaGlobal_Alchemy()
  PaGlobal_Alchemy:initialize()
end
function FromClient_AlchemyFail_PaGlobal_Alchemy(isSuccess, hint, alchemyType, strErr, bDoingMassProduction)
  local isCook = 1 == alchemyType
  if true == isSuccess then
    Proc_ShowMessage_Ack(strErr)
  elseif 1 == hint or 2 == hint or 3 == hint then
    local msg = {
      main = PAGetString(Defines.StringSheet_GAME, "ALCHEMYFAIL_REASON_" .. hint),
      sub = ""
    }
    local msgType = isCook and 27 or 26
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 2.5, msgType)
    if true == bDoingMassProduction then
      local failMsg = ""
      if isCook then
        failMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_COOKING")
      else
        failMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_ALCHEMY")
      end
      local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMY_MSGBOX_FAIL_MEMO", "failMsg", failMsg)
      local funcYesButtonClicked = function()
        PaGlobal_Alchemy:resumeMassProduction()
      end
      local funcNoButtonClicked = function()
        PaGlobal_Alchemy:cancelAlchemy()
      end
      local messageBoxData = {
        title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMY_MSGBOX_FAIL_TITLE", "failMsg", failMsg),
        content = messageBoxMemo,
        functionYes = funcYesButtonClicked,
        functionNo = funcNoButtonClicked,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    end
  else
    Proc_ShowMessage_Ack(strErr)
    PaGlobal_Alchemy:cancelAlchemy()
  end
end
function ShowEvent_PaGlobal_Alchemy_ShowAni()
  UIAni.showAniScaleElastic(Panel_Alchemy, {})
end
function ShowEvent_PaGlobal_Alchemy_CloseAni()
  UIAni.closeAni(Panel_Alchemy)
end
Panel_Alchemy:RegisterShowEventFunc(true, "ShowEvent_PaGlobal_Alchemy_ShowAni()")
Panel_Alchemy:RegisterShowEventFunc(false, "ShowEvent_PaGlobal_Alchemy_CloseAni()")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_PaGlobal_Alchemy")
registerEvent("ResponseShowAlchemy", "FromClient_ShowAlchemyPanel_PaGlobal_Alchemy")
registerEvent("FromClient_AlchemyFailAck", "FromClient_AlchemyFail_PaGlobal_Alchemy")
