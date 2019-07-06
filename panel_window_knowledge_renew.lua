local Panel_Window_Knowledge_Renew_info = {
  _initialize = false,
  _ui = {
    static_TitleBg = nil,
    staticText_Title_Top = nil,
    static_TopBG = nil,
    staticText_KnowledgePointTitle = nil,
    staticText_PointValue = nil,
    staticText_EffectTitle = nil,
    staticText_EffectValue = nil,
    staticText_Depth = nil,
    staticText_DetailShow_ConsoleUI = nil,
    static_CategoryBg = nil,
    button_Category = {
      [0] = nil,
      [1] = nil,
      [2] = nil,
      [3] = nil,
      [4] = nil,
      [5] = nil,
      [6] = nil,
      [7] = nil,
      [8] = nil
    },
    static_SubCategoryBg = nil,
    staticText_Title_1 = nil,
    list2_Category = nil,
    list2_1_Content = nil,
    button_CategoryName = nil,
    staticText_EnergyIcon = nil,
    static_Key_ConsoleUI = nil,
    list2_1_VerticalScroll = nil,
    list2_1_HorizontalScroll = nil,
    static_CategoryItemBg = nil,
    staticText_Title_2 = nil,
    list2_CategoryItem = nil,
    list2_2_Content = nil,
    button_CategoryItemName = nil,
    list2_2_VerticalScroll = nil,
    list2_2_HorizontalScroll = nil,
    static_BottomBg = nil,
    staticText_Select_ConsoleUI = nil,
    staticText_Back_ConsoleUI = nil,
    button_Back = nil,
    staticText_TooltipBg = nil,
    toolTip_Point = {},
    toolTip_PointDesc = {},
    static_Knowledge_Icon2 = nil,
    staticText_KnowlegeNameLine2 = nil,
    staticText_Impression2 = nil,
    staticText_Interest2 = nil,
    staticText_Interesting2 = nil
  },
  _value = {
    currentStep = 0,
    stepTextList = {
      [0] = "",
      [1] = "",
      [2] = "",
      [3] = ""
    },
    step0_currentIndex = 0,
    step0_selectMentalObjectKey = 0,
    step1_lastIndex = -1,
    step1_currentIndex = 0,
    step1_selectMentalObjectKey = 0,
    step2_useCard = false,
    step2_lastIndex = -1,
    step2_currentIndex = 0,
    step2_selectMentalObjectKey = 0,
    step3_useCard = false,
    step3_lastIndex = -1,
    step3_currentIndex = 0,
    step3_selectMentalObjectKey = 0,
    step4_lastIndex = -1,
    step4_currentIndex = 0
  },
  _text = {arrow = " > "},
  _enum = {
    ePOINT_COUNT = 10,
    eKNOWLEDGE_MAX = 9,
    eSTEP_CATEGORY = 0,
    eSETP_SUBCATEGORY = 1,
    eSTEP_GROUP_1 = 2,
    eSTEP_GROUP_2 = 3,
    eSTEP_GROUP_3 = 4
  },
  _icon = {
    ["texture"] = "Renewal/UI_Icon/Console_Icon_02.dds",
    [0] = {
      x1 = 115,
      y1 = 58,
      x2 = 171,
      y2 = 114
    },
    [1] = {
      x1 = 1,
      y1 = 1,
      x2 = 57,
      y2 = 57
    },
    [5001] = {
      x1 = 58,
      y1 = 1,
      x2 = 114,
      y2 = 57
    },
    [5020] = {
      x1 = 1,
      y1 = 58,
      x2 = 57,
      y2 = 114
    },
    [10001] = {
      x1 = 1,
      y1 = 115,
      x2 = 57,
      y2 = 171
    },
    [20001] = {
      x1 = 1,
      y1 = 172,
      x2 = 57,
      y2 = 228
    },
    [25001] = {
      x1 = 58,
      y1 = 58,
      x2 = 114,
      y2 = 114
    },
    [30001] = {
      x1 = 58,
      y1 = 115,
      x2 = 114,
      y2 = 171
    },
    [31310] = {
      x1 = 58,
      y1 = 172,
      x2 = 114,
      y2 = 228
    },
    [31300] = {
      x1 = 115,
      y1 = 1,
      x2 = 171,
      y2 = 57
    }
  },
  _ani = {showAniElapsed = 0, showAniDuration = 0.3}
}
local themeKeyKey_ControlMapping = {
  [1] = 0,
  [5001] = 1,
  [5020] = 2,
  [10001] = 3,
  [20001] = 4,
  [25001] = 5,
  [30001] = 6,
  [31310] = 7,
  [31300] = 8
}
function Panel_Window_Knowledge_Renew_info:getShowInfo()
  return self._ui.static_KnowledgeInfoBg:GetShow()
end
function Panel_Window_Knowledge_Renew_info:openInfo()
  self._ui.static_KnowledgeInfoBg:SetShow(true)
end
function Panel_Window_Knowledge_Renew_info:closeInfo()
  self._ui.static_KnowledgeInfoBg:SetShow(false)
end
function Panel_Window_Knowledge_Renew_info:setContentInfo()
  if false == self:getShowInfo() then
    self:openInfo()
  end
  local currentIndex = self._value.step4_currentIndex
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local childkey = knowledge:getCurrentThemeChildCardKeyByIndex(currentIndex)
  local card = knowledge:getCardByKeyRaw(childkey)
  if nil ~= card then
    self._ui.static_Knowledge_Icon2:ChangeTextureInfoName(card:getPicture())
    self._ui.staticText_KnowlegeNameLine2:SetText(card:getName())
    self._ui.frame_DialogText:SetShow(true)
    self._ui.staticText_Dialog_Text:SetAutoResize(true)
    self._ui.staticText_Dialog_Text:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui.staticText_Dialog_Text:SetText(card:getDescription())
    self._ui.frame_Content:SetSize(self._ui.staticText_Dialog_Text:GetSizeY())
    self._ui.frame_VScroll:SetControlPos(0)
    self._ui.frame_DialogText:UpdateContentPos()
    self._ui.frame_DialogText:UpdateContentScroll()
    self._ui.frame_DialogText:ComputePos()
    if self._ui.frame_DialogText:GetSizeY() < self._ui.staticText_Dialog_Text:GetTextSizeY() then
      self._ui.frame_VScroll:SetShow(true)
    else
      self._ui.frame_VScroll:SetShow(false)
    end
    local favoritedList = ""
    local isFirst = true
    local npcpersonalityStaticWrapper = card:getNpcPersonalityStaticStatus()
    if nil == npcpersonalityStaticWrapper then
      self._ui.staticText_Interesting2:SetShow(false)
    else
      local count = npcpersonalityStaticWrapper:getFavoritedThemeCount()
      for index = 0, count - 1 do
        local favoritedName = npcpersonalityStaticWrapper:getFavoritedThemeNameByIndex(index)
        if isFirst then
          favoritedList = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_Knowledge_FavoritedList", "favoritedName", favoritedName)
          isFirst = false
        else
          favoritedList = favoritedList .. "," .. favoritedName
        end
      end
      self._ui.staticText_Interesting2:SetShow(true)
      self._ui.staticText_Interesting2:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      self._ui.staticText_Interesting2:SetText(favoritedList)
    end
    self._ui.staticText_Impression2:SetText(PAGetString(Defines.StringSheet_GAME, "MENTALGAME_BUFFTYPE_FAVOR") .. " : " .. card:getMinDd() .. "~" .. card:getMaxDd())
    self._ui.staticText_Interest2:SetText(PAGetString(Defines.StringSheet_GAME, "MENTALGAME_BUFFTYPE_INTERESTING") .. " : " .. card:getHit())
  else
    self._ui.frame_DialogText:SetShow(false)
  end
end
function Panel_Window_Knowledge_Renew_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_Window_Knowledge_Renew_Resize")
end
function Panel_Window_Knowledge_Renew_info:initialize()
  self._initialize = true
  self:initValue()
  self:childControl()
  self:resize()
  self:registerMessageHandler()
end
function Panel_Window_Knowledge_Renew_info:initValue()
  self._value.currentStep = 0
  self._value.stepTextList[0] = ""
  self._value.stepTextList[1] = ""
  self._value.stepTextList[2] = ""
  self._value.stepTextList[3] = ""
  self._value.step0_currentIndex = 0
  self._value.step0_selectMentalObjectKey = 0
  self._value.step1_lastIndex = -1
  self._value.step1_currentIndex = 0
  self._value.step1_selectMentalObjectKey = 0
  self._value.step2_useCard = false
  self._value.step2_lastIndex = -1
  self._value.step2_currentIndex = 0
  self._value.step2_selectMentalObjectKey = 0
  self._value.step4_lastIndex = -1
  self._value.step4_currentIndex = 0
end
function Panel_Window_Knowledge_Renew_info:resize()
  Panel_Window_Knowledge_Renew:SetSize(Panel_Window_Knowledge_Renew:GetSizeX(), getScreenSizeY())
end
function Panel_Window_Knowledge_Renew_info:childControl()
  self._ui.static_TitleBg = UI.getChildControl(Panel_Window_Knowledge_Renew, "Static_TitleBg")
  self._ui.staticText_Title_Top = UI.getChildControl(self._ui.static_TitleBg, "StaticText_Title_Top")
  self._ui.static_TopBG = UI.getChildControl(Panel_Window_Knowledge_Renew, "Static_TopBG")
  self._ui.staticText_PointValue = UI.getChildControl(self._ui.static_TopBG, "StaticText_PointValue")
  self._ui.staticText_EffectTitle = UI.getChildControl(self._ui.static_TopBG, "StaticText_EffectTitle")
  self._ui.staticText_EffectValue = UI.getChildControl(self._ui.static_TopBG, "StaticText_EffectValue")
  self._ui.staticText_Depth = UI.getChildControl(self._ui.static_TopBG, "StaticText_Depth")
  self._ui.staticText_DetailShow_ConsoleUI = UI.getChildControl(self._ui.static_TopBG, "StaticText_DetailShow_ConsoleUI")
  self._ui.staticText_DetailShow_ConsoleUI_Text = UI.getChildControl(self._ui.static_TopBG, "StaticText_DetailShow_ConsoleUI_Text")
  self._ui.staticText_DetailShow_ConsoleUI_Text:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.staticText_DetailShow_ConsoleUI_Text:SetText(self._ui.staticText_DetailShow_ConsoleUI_Text:GetText())
  self._ui.static_CategoryBg = UI.getChildControl(Panel_Window_Knowledge_Renew, "Static_CategoryBg")
  for index = 0, 8 do
    local slot = {}
    slot.button = UI.getChildControl(self._ui.static_CategoryBg, "Button_" .. index)
    slot.button:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    slot.icon = UI.getChildControl(slot.button, "Static_Icon_" .. index)
    slot.percent = UI.getChildControl(slot.button, "StaticText_Percent_" .. index)
    self._ui.button_Category[index] = slot
  end
  self._ui.static_SubCategoryBg = UI.getChildControl(Panel_Window_Knowledge_Renew, "Static_SubCategoryBg")
  self._ui.staticText_Title_1 = UI.getChildControl(self._ui.static_SubCategoryBg, "StaticText_Title_1")
  self._ui.list2_Category = UI.getChildControl(self._ui.static_SubCategoryBg, "List2_Category")
  self._ui.list2_Category:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_Window_Knowledge_Step_123List")
  self._ui.list2_Category:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.list2_1_Content = UI.getChildControl(self._ui.list2_Category, "List2_1_Content")
  self._ui.button_CategoryName = UI.getChildControl(self._ui.list2_1_Content, "Button_CategoryName")
  self._ui.staticText_EnergyIcon = UI.getChildControl(self._ui.list2_1_Content, "StaticText_EnergyIcon")
  self._ui.static_Key_ConsoleUI = UI.getChildControl(self._ui.list2_1_Content, "Static_Key_ConsoleUI")
  self._ui.list2_1_VerticalScroll = UI.getChildControl(self._ui.list2_Category, "List2_1_VerticalScroll")
  self._ui.list2_1_HorizontalScroll = UI.getChildControl(self._ui.list2_Category, "List2_1_VerticalScroll")
  self._ui.static_CategoryItemBg = UI.getChildControl(Panel_Window_Knowledge_Renew, "Static_CategoryItemBg")
  self._ui.staticText_Title_2 = UI.getChildControl(self._ui.static_CategoryItemBg, "StaticText_Title_2")
  self._ui.list2_CategoryItem = UI.getChildControl(self._ui.static_CategoryItemBg, "List2_CategoryItem")
  self._ui.list2_CategoryItem:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_Window_Knowledge_Step_4List")
  self._ui.list2_CategoryItem:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.list2_2_Content = UI.getChildControl(self._ui.list2_CategoryItem, "List2_2_Content")
  self._ui.list2_2_VerticalScroll = UI.getChildControl(self._ui.list2_CategoryItem, "List2_2_VerticalScroll")
  self._ui.list2_2_HorizontalScroll = UI.getChildControl(self._ui.list2_CategoryItem, "List2_2_HorizontalScroll")
  self._ui.static_BottomBg = UI.getChildControl(Panel_Window_Knowledge_Renew, "Static_BottomBg")
  self._ui.staticText_Select_ConsoleUI = UI.getChildControl(self._ui.static_BottomBg, "StaticText_Select_ConsoleUI")
  self._ui.staticText_Back_ConsoleUI = UI.getChildControl(self._ui.static_BottomBg, "StaticText_Back_ConsoleUI")
  self._ui.button_Back = UI.getChildControl(self._ui.static_BottomBg, "Button_Back")
  self._ui.staticText_TooltipBg = UI.getChildControl(Panel_Window_Knowledge_Renew, "StaticText_TooltipBg")
  self._ui.toolTip_Grade = {
    UI.getChildControl(self._ui.staticText_TooltipBg, "StaticText_Grade_S"),
    UI.getChildControl(self._ui.staticText_TooltipBg, "StaticText_Grade_APlus"),
    UI.getChildControl(self._ui.staticText_TooltipBg, "StaticText_Grade_A"),
    UI.getChildControl(self._ui.staticText_TooltipBg, "StaticText_Grade_B"),
    UI.getChildControl(self._ui.staticText_TooltipBg, "StaticText_Grade_C")
  }
  self._ui.toolTip_GradeDesc = {
    UI.getChildControl(self._ui.staticText_TooltipBg, "StaticText_GradeDesc_S"),
    UI.getChildControl(self._ui.staticText_TooltipBg, "StaticText_GradeDesc_APlus"),
    UI.getChildControl(self._ui.staticText_TooltipBg, "StaticText_GradeDesc_A"),
    UI.getChildControl(self._ui.staticText_TooltipBg, "StaticText_GradeDesc_B"),
    UI.getChildControl(self._ui.staticText_TooltipBg, "StaticText_GradeDesc_C")
  }
  for ii = 1, #self._ui.toolTip_Grade do
    self._ui.toolTip_Grade[ii]:SetPosX(210)
    self._ui.toolTip_Grade[ii]:SetPosY(160 + (ii - 1) * 40)
    self._ui.toolTip_GradeDesc[ii]:SetPosX(340)
    self._ui.toolTip_GradeDesc[ii]:SetPosY(160 + (ii - 1) * 40)
  end
  for ii = 0, self._enum.ePOINT_COUNT - 1 do
    self._ui.toolTip_Point[ii] = UI.getChildControl(self._ui.staticText_TooltipBg, "StaticText_" .. ii)
    self._ui.toolTip_PointDesc[ii] = UI.getChildControl(self._ui.staticText_TooltipBg, "StaticText_GreDesc_" .. ii)
    self._ui.toolTip_Point[ii]:SetFontColor(Defines.Color.C_FFEEEEEE)
    self._ui.toolTip_Point[ii]:SetPosX(210)
    self._ui.toolTip_Point[ii]:SetPosY(510 + (ii - 1) * 55)
    self._ui.toolTip_PointDesc[ii]:SetFontColor(Defines.Color.C_FFEEEEEE)
    self._ui.toolTip_PointDesc[ii]:SetPosX(210)
    self._ui.toolTip_PointDesc[ii]:SetPosY(535 + (ii - 1) * 55)
  end
  self._ui.static_KnowledgeInfoBg = UI.getChildControl(Panel_Window_Knowledge_Renew, "Static_KnowledgeInfo_Bg")
  self._ui.static_Knowledge_Icon2 = UI.getChildControl(self._ui.static_KnowledgeInfoBg, "Static_Knowledge_Icon")
  self._ui.staticText_KnowlegeNameLine2 = UI.getChildControl(self._ui.static_KnowledgeInfoBg, "StaticText_KnowlegeNameLine")
  self._ui.staticText_Impression2 = UI.getChildControl(self._ui.static_KnowledgeInfoBg, "StaticText_Impression")
  self._ui.staticText_Interest2 = UI.getChildControl(self._ui.static_KnowledgeInfoBg, "StaticText_Interest")
  self._ui.staticText_Interesting2 = UI.getChildControl(self._ui.static_KnowledgeInfoBg, "StaticText_Interesting")
  self._ui.frame_DialogText = UI.getChildControl(self._ui.static_KnowledgeInfoBg, "Frame_Dialog_Text")
  self._ui.frame_VScroll = UI.getChildControl(self._ui.frame_DialogText, "Frame_1_VerticalScroll")
  self._ui.frame_Content = UI.getChildControl(self._ui.frame_DialogText, "Frame_1_Content")
  self._ui.staticText_Dialog_Text = UI.getChildControl(self._ui.frame_Content, "StaticText_Dialog_Text")
end
function Panel_Window_Knowledge_Renew_info:open(showAni)
  Panel_Window_Knowledge_Renew:SetShow(true)
  PaGlobalFunc_ChattingInfo_Close()
  FGlobal_Panel_Radar_Show(false, true)
  Panel_TimeBar:SetShow(false, true)
  FGlobal_QuestWidget_Close()
end
function Panel_Window_Knowledge_Renew_info:close(showAni)
  Panel_Window_Knowledge_Renew:SetShow(false)
  FGlobal_Panel_Radar_Show(true, true)
  Panel_TimeBar:SetShow(true, true)
  FGlobal_QuestWidget_Open()
end
function Panel_Window_Knowledge_Renew_info:preOpen()
  self:preOpenTooltip()
  self:initValue()
  self:resize()
  self:setTopData()
end
function Panel_Window_Knowledge_Renew_info:preOpenTooltip()
  local titleTextSizeX = 0
  local descTextSizeX = 0
  for index = 0, self._enum.ePOINT_COUNT - 1 do
    titleTextSizeX = math.max(titleTextSizeX, self._ui.toolTip_Point[index]:GetTextSizeX())
    descTextSizeX = math.max(descTextSizeX, self._ui.toolTip_PointDesc[index]:GetTextSizeX())
  end
  if titleTextSizeX > 70 then
    local dif = self._ui.staticText_TooltipBg:GetPosX()
    for index = 0, self._enum.ePOINT_COUNT - 1 do
    end
  else
  end
  self._ui.staticText_TooltipBg:SetShow(false)
end
function Panel_Window_Knowledge_Renew_info:openTooltip()
  self._ui.staticText_TooltipBg:SetShow(true)
end
function Panel_Window_Knowledge_Renew_info:closeTooltip()
  self._ui.staticText_TooltipBg:SetShow(false)
end
function Panel_Window_Knowledge_Renew_info:clearContentPage0()
  self:initValue()
  self._ui.static_CategoryBg:SetShow(true)
  self._ui.static_SubCategoryBg:SetShow(false)
  self._ui.static_CategoryItemBg:SetShow(false)
end
function Panel_Window_Knowledge_Renew_info:clearContentPage1()
  self._value.stepTextList[1] = ""
  self._value.stepTextList[2] = ""
  self._value.stepTextList[3] = ""
  self._value.step1_lastIndex = -1
  self._value.step1_currentIndex = 0
  self._value.step1_selectMentalObjectKey = 0
  self._value.step2_useCard = false
  self._value.step2_lastIndex = -1
  self._value.step2_currentIndex = 0
  self._value.step2_selectMentalObjectKey = 0
  self._value.step3_useCard = false
  self._value.step3_lastIndex = -1
  self._value.step3_currentIndex = 0
  self._value.step3_selectMentalObjectKey = 0
  self._value.step4_lastIndex = -1
  self._value.step4_currentIndex = 0
  self._ui.static_CategoryBg:SetShow(false)
  self._ui.static_SubCategoryBg:SetShow(true)
  self._ui.static_CategoryItemBg:SetShow(false)
end
function Panel_Window_Knowledge_Renew_info:clearContentPage2()
  self._value.stepTextList[2] = ""
  self._value.stepTextList[3] = ""
  self._value.step2_useCard = false
  self._value.step2_lastIndex = -1
  self._value.step2_currentIndex = 0
  self._value.step2_selectMentalObjectKey = 0
  self._value.step3_useCard = false
  self._value.step3_lastIndex = -1
  self._value.step3_currentIndex = 0
  self._value.step3_selectMentalObjectKey = 0
  self._value.step4_lastIndex = -1
  self._value.step4_currentIndex = 0
  self._ui.static_CategoryBg:SetShow(false)
  self._ui.static_SubCategoryBg:SetShow(true)
  self._ui.static_CategoryItemBg:SetShow(false)
end
function Panel_Window_Knowledge_Renew_info:clearContentPage3()
  self._value.stepTextList[3] = ""
  self._value.step3_useCard = false
  self._value.step3_lastIndex = -1
  self._value.step3_currentIndex = 0
  self._value.step3_selectMentalObjectKey = 0
  self._value.step4_lastIndex = -1
  self._value.step4_currentIndex = 0
  self._ui.static_CategoryBg:SetShow(false)
  self._ui.static_SubCategoryBg:SetShow(true)
  self._ui.static_CategoryItemBg:SetShow(false)
end
function Panel_Window_Knowledge_Renew_info:clearContentPage4()
  self._value.step4_lastIndex = -1
  self._value.step4_currentIndex = 0
  self._ui.static_CategoryBg:SetShow(false)
  self._ui.static_SubCategoryBg:SetShow(false)
  self._ui.static_CategoryItemBg:SetShow(true)
end
function Panel_Window_Knowledge_Renew_info:setTopData()
  self._ui.static_TopBG:SetShow(true)
  local knowledgePoint = ToClient_getKnowledgePoint()
  self._ui.staticText_PointValue:SetText(tostring(knowledgePoint))
  local battleBuffPercent = ToClient_getBattleExperienceByKnowledgePoint()
  local dropItemBuffPercent = ToClient_getEfficiencyOfDropItemByKnowledgePoint()
  battleBuffPercent = battleBuffPercent / 10000
  dropItemBuffPercent = dropItemBuffPercent / 10000
  local isBattleBuff = ""
  if battleBuffPercent > 0 then
    isBattleBuff = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_KNOWLEDGE_MAIN_BATTLEEXPBUFF", "battleBuff", tostring(battleBuffPercent))
  end
  local isDropItemBuff = ""
  if dropItemBuffPercent > 0 then
    isDropItemBuff = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_KNOWLEDGE_BUFF_TEXT", "dropPercent", tostring(dropItemBuffPercent))
  end
  local txt_Comma = "\n"
  if 0 == battleBuffPercent then
    txt_Comma = ""
  end
  local isText = isDropItemBuff .. txt_Comma .. isBattleBuff
  if knowledgePoint < 500 then
    isText = PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGE_MAIN_NONEBUFF")
  end
  self._ui.staticText_EffectValue:SetText(isText)
end
function Panel_Window_Knowledge_Renew_info:updateTopText()
  if 0 == self._value.currentStep then
    self._ui.staticText_Depth:SetShow(false)
  else
    local textAll = ""
    local count = self._value.currentStep - 1
    for index = 0, count do
      if self._value.stepTextList[index] ~= "" then
        textAll = textAll .. self._value.stepTextList[index]
        if nil ~= self._value.stepTextList[index + 1] and "" ~= self._value.stepTextList[index + 1] then
          textAll = textAll .. self._text.arrow
        end
      else
        index = index + 1
      end
    end
    self._ui.staticText_Depth:SetAutoResize(true)
    self._ui.staticText_Depth:setLineCountByLimitAutoWrap(2)
    self._ui.staticText_Depth:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui.staticText_Depth:SetShow(true)
    self._ui.staticText_Depth:SetText(textAll)
  end
  self._ui.staticText_Depth:SetShow(false)
end
function Panel_Window_Knowledge_Renew_info:setContent()
  ToClient_padSnapResetControl()
  if self._value.currentStep == self._enum.eSTEP_CATEGORY then
    self:clearContentPage0()
    self:updateTopText()
    self:setContentPage0()
    self._ui.staticText_Select_ConsoleUI:SetShow(true)
  elseif self._value.currentStep == self._enum.eSETP_SUBCATEGORY then
    self:clearContentPage1()
    self:updateTopText()
    self:setContentPage1()
    self._ui.staticText_Select_ConsoleUI:SetShow(false)
  elseif self._value.currentStep == self._enum.eSTEP_GROUP_1 then
    self:clearContentPage2()
    self:updateTopText()
    self:setContentPage2()
    self._ui.staticText_Select_ConsoleUI:SetShow(false)
  elseif self._value.currentStep == self._enum.eSTEP_GROUP_2 then
    self:clearContentPage3()
    self:updateTopText()
    self:setContentPage3()
    self._ui.staticText_Select_ConsoleUI:SetShow(false)
  elseif self._value.currentStep == self._enum.eSTEP_GROUP_3 then
    self:clearContentPage4()
    self:updateTopText()
    self:setContentPage4()
    self._ui.staticText_Select_ConsoleUI:SetShow(false)
  end
end
function Panel_Window_Knowledge_Renew_info:setContentPage0()
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local childKnowledgeCount = knowledge:getMainKnowledgeCount()
  for index = 0, self._enum.eKNOWLEDGE_MAX - 1 do
    self._ui.button_Category[index].button:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_KNOWLEDGE_NOTHING"))
    self._ui.button_Category[index].percent:SetText("")
    self._ui.button_Category[index].button:SetFontColor(Defines.Color.C_FFFFFFFF)
    local iconData = self._icon[0]
    self._ui.button_Category[index].icon:ChangeTextureInfoName(self._icon.texture)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.button_Category[index].icon, iconData.x1, iconData.y1, iconData.x2, iconData.y2)
    self._ui.button_Category[index].icon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.button_Category[index].icon:setRenderTexture(self._ui.button_Category[index].icon:getBaseTexture())
    self._ui.button_Category[index].button:addInputEvent("Mouse_On", "PaGlobalFunc_Window_Knowledge_Page0_HideButtonA(false)")
    self._ui.button_Category[index].button:addInputEvent("Mouse_LUp", "")
  end
  for index = 0, childKnowledgeCount do
    local mentalCardKeyRaw = knowledge:getMainKnowledgeKeyByIndex(index)
    local mentalObject = knowledge:getThemeByKeyRaw(mentalCardKeyRaw)
    local controlIndex = themeKeyKey_ControlMapping[mentalCardKeyRaw]
    if nil ~= controlIndex then
      if nil ~= self._icon[mentalCardKeyRaw] then
        local iconData = self._icon[mentalCardKeyRaw]
        self._ui.button_Category[controlIndex].icon:ChangeTextureInfoName(self._icon.texture)
        local x1, y1, x2, y2 = setTextureUV_Func(self._ui.button_Category[controlIndex].icon, iconData.x1, iconData.y1, iconData.x2, iconData.y2)
        self._ui.button_Category[controlIndex].icon:getBaseTexture():setUV(x1, y1, x2, y2)
        self._ui.button_Category[controlIndex].icon:setRenderTexture(self._ui.button_Category[controlIndex].icon:getBaseTexture())
      end
      local mentalObject = knowledge:getThemeByKeyRaw(mentalCardKeyRaw)
      local categoryName = mentalObject:getName()
      if mentalObject:getCardCollectedCount() == mentalObject:getCardCollectMaxCount() then
        self._ui.button_Category[controlIndex].button:SetFontColor(Defines.Color.C_FF6DC6FF)
      end
      local percent = mentalObject:getCardCollectPercents()
      self._ui.button_Category[controlIndex].mentalCardKeyRaw = mentalCardKeyRaw
      self._ui.button_Category[controlIndex].button:SetText(categoryName)
      self._ui.button_Category[controlIndex].percent:SetText(percent .. "%")
      self._ui.button_Category[controlIndex].button:addInputEvent("Mouse_On", "PaGlobalFunc_Window_Knowledge_Page0_SelectButton(" .. controlIndex .. "," .. tostring(hideButtonA) .. ")")
      self._ui.button_Category[controlIndex].button:addInputEvent("Mouse_LUp", "PaGlobalFunc_Window_Knowledge_Page0_ClickButton(" .. controlIndex .. ",\"" .. categoryName .. "\"" .. ")")
    end
  end
end
function Panel_Window_Knowledge_Renew_info:setContentPage1()
  local title = self._value.stepTextList[self._enum.eSTEP_CATEGORY]
  self._ui.staticText_Title_1:SetText(title)
  self._ui.list2_Category:getElementManager():clearKey()
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local childCount = knowledge:getCurrentThemeChildThemeCount()
  if 0 == childCount then
    return
  end
  for index = 0, childCount - 1 do
    self._ui.list2_Category:getElementManager():pushKey(toInt64(0, index))
    self._ui.list2_Category:requestUpdateByKey(toInt64(0, index))
  end
end
function Panel_Window_Knowledge_Renew_info:setContentPage2()
  local title = self._value.stepTextList[self._enum.eSETP_SUBCATEGORY]
  self._ui.staticText_Title_1:SetText(title)
  self._ui.list2_Category:getElementManager():clearKey()
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local childCount = knowledge:getCurrentThemeChildThemeCount()
  if 0 == childCount then
    childCount = knowledge:getCurrentThemeChildCardCount()
    if 0 == childCount then
      return
    else
      self._value.step2_useCard = true
      self._value.step3_useCard = true
      PaGlobalFunc_Window_Knowledge_Page2_Pass()
    end
  end
  for index = 0, childCount - 1 do
    self._ui.list2_Category:getElementManager():pushKey(toInt64(0, index))
    self._ui.list2_Category:requestUpdateByKey(toInt64(0, index))
  end
end
function Panel_Window_Knowledge_Renew_info:setContentPage3()
  local title = self._value.stepTextList[self._enum.eSTEP_GROUP_1]
  self._ui.staticText_Title_1:SetText(title)
  self._ui.list2_Category:getElementManager():clearKey()
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local childCount = knowledge:getCurrentThemeChildThemeCount()
  if 0 == childCount then
    childCount = knowledge:getCurrentThemeChildCardCount()
    if 0 == childCount then
      return
    else
      self._value.step3_useCard = true
      PaGlobalFunc_Window_Knowledge_Page3_Pass()
    end
  end
  for index = 0, childCount - 1 do
    self._ui.list2_Category:getElementManager():pushKey(toInt64(0, index))
    self._ui.list2_Category:requestUpdateByKey(toInt64(0, index))
  end
end
function Panel_Window_Knowledge_Renew_info:setContentPage4()
  local title = ""
  if false == self._value.step3_useCard and false == self._value.step2_useCard then
    title = self._value.stepTextList[self._enum.eSTEP_GROUP_2]
  elseif true == self._value.step3_useCard and false == self._value.step2_useCard then
    title = self._value.stepTextList[self._enum.eSTEP_GROUP_1]
  else
    title = self._value.stepTextList[self._enum.eSETP_SUBCATEGORY]
  end
  self._ui.staticText_Title_2:SetText(title)
  self._ui.list2_CategoryItem:getElementManager():clearKey()
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local childCount = knowledge:getCurrentThemeChildCardCount()
  if 0 == childCount then
    return
  end
  for index = 0, childCount - 1 do
    self._ui.list2_CategoryItem:getElementManager():pushKey(toInt64(0, index))
    self._ui.list2_CategoryItem:requestUpdateByKey(toInt64(0, index))
  end
end
function PaGlobalFunc_Window_Knowledge_Renew_ShowAni()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  local self = Panel_Window_Knowledge_Renew_info
  Panel_Window_Knowledge_Renew:ResetVertexAni()
  local aniInfo1 = Panel_Window_Knowledge_Renew:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartPosition(getOriginScreenSizeX(), 0)
  aniInfo1:SetEndPosition(getOriginScreenSizeX() - Panel_Window_Knowledge_Renew:GetSizeX(), 0)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(false)
  aniInfo1:SetDisableWhileAni(true)
  aniInfo1:SetIgnoreUpdateSnapping(true)
end
function PaGlobalFunc_Window_Knowledge_Renew_HideAni()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  Panel_Window_Knowledge_Renew:ResetVertexAni()
  local aniInfo1 = Panel_Window_Knowledge_Renew:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartPosition(Panel_Window_Knowledge_Renew:GetPosX(), 0)
  aniInfo1:SetEndPosition(Panel_Window_Knowledge_Renew:GetPosX() + Panel_Window_Knowledge_Renew:GetSizeX(), 0)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
  aniInfo1:SetIgnoreUpdateSnapping(true)
end
function PaGlobalFunc_Window_Knowledge_GetShow()
  return Panel_Window_Knowledge_Renew:GetShow()
end
function PaGlobalFunc_Window_Knowledge_Show()
  local self = Panel_Window_Knowledge_Renew_info
  self:preOpen()
  self:open(true)
  self:setContent()
end
function PaGlobalFunc_Window_Knowledge_Exit()
  local self = Panel_Window_Knowledge_Renew_info
  self:closeInfo()
  self:close(true)
end
function PaGlobalFunc_Window_Knowledge_GOBackStep()
  local self = Panel_Window_Knowledge_Renew_info
  if true == self:getShowInfo() then
    self:closeInfo()
  end
  self._value.currentStep = self._value.currentStep - 1
  if self._value.currentStep == self._enum.eSTEP_GROUP_2 then
    if true == self._value.step3_useCard then
      self._value.currentStep = self._value.currentStep - 1
    else
      local knowledge = getSelfPlayer():get():getMentalKnowledge()
      local theme = knowledge:getThemeByKeyRaw(self._value.step2_selectMentalObjectKey)
      knowledge:setCurrentTheme(theme)
      self:setContent()
      return
    end
  end
  if self._value.currentStep == self._enum.eSTEP_GROUP_1 then
    if true == self._value.step2_useCard then
      self._value.currentStep = self._value.currentStep - 1
    else
      local knowledge = getSelfPlayer():get():getMentalKnowledge()
      local theme = knowledge:getThemeByKeyRaw(self._value.step1_selectMentalObjectKey)
      knowledge:setCurrentTheme(theme)
      self:setContent()
      return
    end
  end
  if self._value.currentStep == self._enum.eSETP_SUBCATEGORY then
    local knowledge = getSelfPlayer():get():getMentalKnowledge()
    local theme = knowledge:getThemeByKeyRaw(self._value.step0_selectMentalObjectKey)
    knowledge:setCurrentTheme(theme)
    self:setContent()
    return
  end
  if self._enum.eSTEP_CATEGORY == self._value.currentStep then
    self:setContent()
    return
  end
  if self._value.currentStep < 0 then
    self._value.currentStep = self._enum.eSTEP_CATEGORY
    PaGlobalFunc_Window_Knowledge_Exit()
  end
end
function PaGlobalFunc_Window_Knowledge_Page2_Pass()
  local self = Panel_Window_Knowledge_Renew_info
  self._value.currentStep = self._enum.eSTEP_GROUP_3
  self:updateTopText()
  self:setContent()
end
function PaGlobalFunc_Window_Knowledge_Page3_Pass()
  local self = Panel_Window_Knowledge_Renew_info
  self._value.currentStep = self._enum.eSTEP_GROUP_3
  self:updateTopText()
  self:setContent()
end
function PaGlobalFunc_Window_Knowledge_Page4_SelectButton(index)
  local self = Panel_Window_Knowledge_Renew_info
  self._value.step4_lastIndex = self._value.step4_currentIndex
  self._value.step4_currentIndex = index
  self._ui.list2_CategoryItem:requestUpdateByKey(toInt64(0, self._value.step4_lastIndex))
  self._ui.list2_CategoryItem:requestUpdateByKey(toInt64(0, self._value.step4_currentIndex))
end
function PaGlobalFunc_Window_Knowledge_Page4_ClickButton(index)
  local self = Panel_Window_Knowledge_Renew_info
  PaGlobalFunc_Window_Knowledge_Page4_SelectButton(index)
  self:setContentInfo()
end
function PaGlobalFunc_Window_Knowledge_Page3_SelectButton(index)
  local self = Panel_Window_Knowledge_Renew_info
  if self._value.step3_currentIndex == index then
    return
  end
  self._value.step3_lastIndex = self._value.step3_currentIndex
  self._value.step3_currentIndex = index
  self._ui.list2_Category:requestUpdateByKey(toInt64(0, self._value.step3_lastIndex))
  self._ui.list2_Category:requestUpdateByKey(toInt64(0, self._value.step3_currentIndex))
end
function PaGlobalFunc_Window_Knowledge_Page3_ClickButton(index, subCategory)
  local self = Panel_Window_Knowledge_Renew_info
  PaGlobalFunc_Window_Knowledge_Page3_SelectButton(index)
  self._value.stepTextList[self._enum.eSTEP_GROUP_2] = subCategory
  self._value.currentStep = self._enum.eSTEP_GROUP_3
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local childkey = knowledge:getCurrentThemeChildThemeKeyByIndex(index)
  self._value.step3_selectMentalObjectKey = childkey
  local mentalObjectKey = self._value.step3_selectMentalObjectKey
  if mentalObjectKey > 0 then
    local theme = knowledge:getThemeByKeyRaw(mentalObjectKey)
    if nil == theme then
      return
    end
    knowledge:setCurrentTheme(theme)
    self:updateTopText()
    self:setContent()
  end
end
function PaGlobalFunc_Window_Knowledge_Page2_SelectButton(index)
  local self = Panel_Window_Knowledge_Renew_info
  if self._value.step2_currentIndex == index then
    return
  end
  self._value.step2_lastIndex = self._value.step2_currentIndex
  self._value.step2_currentIndex = index
  self._ui.list2_Category:requestUpdateByKey(toInt64(0, self._value.step2_lastIndex))
  self._ui.list2_Category:requestUpdateByKey(toInt64(0, self._value.step2_currentIndex))
end
function PaGlobalFunc_Window_Knowledge_Page2_ClickButton(index, subCategory)
  local self = Panel_Window_Knowledge_Renew_info
  PaGlobalFunc_Window_Knowledge_Page2_SelectButton(index)
  self._value.stepTextList[self._enum.eSTEP_GROUP_1] = subCategory
  self._value.currentStep = self._enum.eSTEP_GROUP_2
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local childkey = knowledge:getCurrentThemeChildThemeKeyByIndex(index)
  self._value.step2_selectMentalObjectKey = childkey
  local mentalObjectKey = self._value.step2_selectMentalObjectKey
  if mentalObjectKey > 0 then
    local theme = knowledge:getThemeByKeyRaw(mentalObjectKey)
    if nil == theme then
      return
    end
    knowledge:setCurrentTheme(theme)
    self:updateTopText()
    self:setContent()
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
end
function PaGlobalFunc_Window_Knowledge_Page1_SelectButton(index)
  local self = Panel_Window_Knowledge_Renew_info
  if self._value.step1_currentIndex == index then
    return
  end
  self._value.step1_lastIndex = self._value.step1_currentIndex
  self._value.step1_currentIndex = index
  self._ui.list2_Category:requestUpdateByKey(toInt64(0, self._value.step1_lastIndex))
  self._ui.list2_Category:requestUpdateByKey(toInt64(0, self._value.step1_currentIndex))
end
function PaGlobalFunc_Window_Knowledge_Page1_ClickButton(index, subCategory)
  local self = Panel_Window_Knowledge_Renew_info
  PaGlobalFunc_Window_Knowledge_Page1_SelectButton(index)
  self._value.stepTextList[self._enum.eSETP_SUBCATEGORY] = subCategory
  self._value.currentStep = self._enum.eSTEP_GROUP_1
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local childkey = knowledge:getCurrentThemeChildThemeKeyByIndex(index)
  self._value.step1_selectMentalObjectKey = childkey
  local mentalObjectKey = self._value.step1_selectMentalObjectKey
  if mentalObjectKey > 0 then
    local theme = knowledge:getThemeByKeyRaw(mentalObjectKey)
    if nil == theme then
      return
    end
    knowledge:setCurrentTheme(theme)
    self:updateTopText()
    self:setContent()
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
end
function PaGlobalFunc_Window_Knowledge_Page0_HideButtonA(hideButtonA)
  local self = Panel_Window_Knowledge_Renew_info
  if nil == hideButtonA then
    hideButtonA = true
  end
  self._ui.staticText_Select_ConsoleUI:SetShow(hideButtonA)
end
function PaGlobalFunc_Window_Knowledge_Page0_SelectButton(index, hideButtonA)
  local self = Panel_Window_Knowledge_Renew_info
  if nil == hideButtonA then
    hideButtonA = true
  end
  self._ui.staticText_Select_ConsoleUI:SetShow(hideButtonA)
  self._value.step0_currentIndex = index
end
function PaGlobalFunc_Window_Knowledge_Page0_ClickButton(index, category)
  local self = Panel_Window_Knowledge_Renew_info
  PaGlobalFunc_Window_Knowledge_Page0_SelectButton(index)
  self._value.stepTextList[self._enum.eSTEP_CATEGORY] = category
  self._value.currentStep = self._enum.eSETP_SUBCATEGORY
  self._value.step0_selectMentalObjectKey = self._ui.button_Category[index].mentalCardKeyRaw
  if 0 == self._value.step0_selectMentalObjectKey then
    return
  end
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local mentalObjectKey = self._value.step0_selectMentalObjectKey
  if mentalObjectKey > 0 then
    local theme = knowledge:getThemeByKeyRaw(mentalObjectKey)
    if nil == theme then
      return
    end
    knowledge:setCurrentTheme(theme)
    self:updateTopText()
    self:setContent()
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
end
function PaGlobalFunc_Window_Knowledge_Step_123List(list_content, key)
  local id = Int64toInt32(key)
  local button = UI.getChildControl(list_content, "Button_CategoryName")
  local text = UI.getChildControl(button, "StaticText_CategoryName")
  local energyIcon = UI.getChildControl(list_content, "StaticText_EnergyIcon")
  local key_A = UI.getChildControl(list_content, "Static_Key_ConsoleUI")
  local self = Panel_Window_Knowledge_Renew_info
  key_A:SetShow(false)
  local textSizeX = button:GetSizeX() - key_A:GetSizeX()
  text:SetSize(textSizeX, text:GetSizeY())
  text:SetFontColor(Defines.Color.C_FFFFFFFF)
  text:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  if self._enum.eSETP_SUBCATEGORY == self._value.currentStep then
    if self._value.step1_currentIndex == id then
      key_A:SetShow(true)
    end
    if self._value.step1_lastIndex == id then
      key_A:SetShow(false)
    end
    energyIcon:SetShow(false)
    local knowledge = getSelfPlayer():get():getMentalKnowledge()
    local childkey = knowledge:getCurrentThemeChildThemeKeyByIndex(id)
    local theme = knowledge:getThemeByKeyRaw(childkey)
    local subCategoryName = theme:getName()
    local addText = ""
    if 0 < theme:getMaxIncreaseWp() then
      energyIcon:SetShow(true)
      energyIcon:SetText(theme:getIncreaseWp() .. "/" .. theme:getMaxIncreaseWp() .. " ")
      text:SetSize(textSizeX - energyIcon:GetSizeX() - energyIcon:GetTextSizeX(), text:GetSizeY())
    end
    if theme:getCardCollectedCount() == theme:getCardCollectMaxCount() then
      text:SetFontColor(Defines.Color.C_FF6DC6FF)
    else
    end
    text:SetText(subCategoryName .. addText)
    button:addInputEvent("Mouse_On", "PaGlobalFunc_Window_Knowledge_Page1_SelectButton(" .. id .. ",\"" .. subCategoryName .. "\"" .. ")")
    button:addInputEvent("Mouse_LUp", "PaGlobalFunc_Window_Knowledge_Page1_ClickButton(" .. id .. ",\"" .. subCategoryName .. "\"" .. ")")
  end
  if self._enum.eSTEP_GROUP_1 == self._value.currentStep then
    if self._value.step2_currentIndex == id then
      key_A:SetShow(true)
    end
    if self._value.step2_lastIndex == id then
      key_A:SetShow(false)
    end
    energyIcon:SetShow(false)
    do
      local knowledge = getSelfPlayer():get():getMentalKnowledge()
      if false == self._value.step2_useCard then
        local childkey = knowledge:getCurrentThemeChildThemeKeyByIndex(id)
        local theme = knowledge:getThemeByKeyRaw(childkey)
        local subCategoryName = theme:getName()
        local addText = ""
        if 0 < theme:getMaxIncreaseWp() then
          energyIcon:SetShow(true)
          energyIcon:SetText(theme:getIncreaseWp() .. "/" .. theme:getMaxIncreaseWp() .. " ")
          text:SetSize(textSizeX - energyIcon:GetSizeX() - energyIcon:GetTextSizeX(), text:GetSizeY())
        end
        if theme:getCardCollectedCount() == theme:getCardCollectMaxCount() then
          text:SetFontColor(Defines.Color.C_FF6DC6FF)
        else
        end
        text:SetText(subCategoryName .. addText)
        button:addInputEvent("Mouse_On", "PaGlobalFunc_Window_Knowledge_Page2_SelectButton(" .. id .. ",\"" .. subCategoryName .. "\"" .. ")")
        button:addInputEvent("Mouse_LUp", "PaGlobalFunc_Window_Knowledge_Page2_ClickButton(" .. id .. ",\"" .. subCategoryName .. "\"" .. ")")
      end
    end
  else
  end
  if self._enum.eSTEP_GROUP_2 == self._value.currentStep then
    if self._value.step3_currentIndex == id then
      key_A:SetShow(true)
    end
    if self._value.step3_lastIndex == id then
      key_A:SetShow(false)
    end
    energyIcon:SetShow(false)
    local knowledge = getSelfPlayer():get():getMentalKnowledge()
    if false == self._value.step3_useCard then
      local childkey = knowledge:getCurrentThemeChildThemeKeyByIndex(id)
      local theme = knowledge:getThemeByKeyRaw(childkey)
      local subCategoryName = theme:getName()
      local addText = ""
      if 0 < theme:getMaxIncreaseWp() then
        energyIcon:SetShow(true)
        energyIcon:SetText(theme:getIncreaseWp() .. "/" .. theme:getMaxIncreaseWp() .. " ")
        text:SetSize(textSizeX - energyIcon:GetSizeX() - energyIcon:GetTextSizeX(), text:GetSizeY())
      end
      if theme:getCardCollectedCount() == theme:getCardCollectMaxCount() then
        text:SetFontColor(Defines.Color.C_FF6DC6FF)
      else
      end
      text:SetText(subCategoryName .. addText)
      button:addInputEvent("Mouse_On", "PaGlobalFunc_Window_Knowledge_Page3_SelectButton(" .. id .. ",\"" .. subCategoryName .. "\"" .. ")")
      button:addInputEvent("Mouse_LUp", "PaGlobalFunc_Window_Knowledge_Page3_ClickButton(" .. id .. ",\"" .. subCategoryName .. "\"" .. ")")
    end
  else
  end
end
function PaGlobalFunc_Window_Knowledge_Step_4List(list_content, key)
  local self = Panel_Window_Knowledge_Renew_info
  local id = Int64toInt32(key)
  local button = UI.getChildControl(list_content, "Button_CategoryItemName")
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local childkey = knowledge:getCurrentThemeChildCardKeyByIndex(id)
  local card = knowledge:getCardByKeyRaw(childkey)
  if nil ~= card then
    local cardName = card:getName()
    button:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    button:SetText(cardName)
    button:addInputEvent("Mouse_On", "PaGlobalFunc_Window_Knowledge_Page4_ClickButton(" .. id .. ")")
  end
end
function PaGlobalFunc_Window_Knowledge_ToggleTooltip()
  local self = Panel_Window_Knowledge_Renew_info
  _AudioPostEvent_SystemUiForXBOX(1, 0)
  if true == self._ui.staticText_TooltipBg:GetShow() then
    self:closeTooltip()
  else
    self:openTooltip()
  end
end
function FromClient_Window_Knowledge_Renew_Init()
  local self = Panel_Window_Knowledge_Renew_info
  self:initialize()
  Panel_Window_Knowledge_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_Window_Knowledge_ToggleTooltip()")
end
function FromClient_Window_Knowledge_Renew_Resize()
  local self = Panel_Window_Knowledge_Renew_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_Window_Knowledge_Renew_Init")
