local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local UI_color = Defines.Color
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local TitleInfo = {
  _titleListBG = nil,
  totalProgress = nil,
  totalProgressValue = nil,
  Category_BTN = {},
  _titleRightListBG = nil,
  titleSubject_Btn = {},
  title_ListAll = nil,
  title_ListCombat = nil,
  title_ListProduct = nil,
  title_ListFish = nil,
  title_ListAllPercent = nil,
  title_ListCombatPercent = nil,
  title_ListProductPercent = nil,
  title_ListFishPercent = nil,
  title_ListAllProgress = nil,
  title_ListCombatProgress = nil,
  title_ListProductProgress = nil,
  title_ListFishProgress = nil,
  txt_AllRoundDesc = nil,
  txt_CombatDesc = nil,
  txt_ProductDesc = nil,
  txt_FishingDesc = nil,
  txt_TotalReward = nil,
  txt_TotalReward_Value = nil,
  txt_PartDesc = nil,
  txt_SubTitleBar = nil,
  CurrentCategoryIdx = 0,
  CurrentCategoryCount = 0,
  title_LastUpdateTime = nil,
  list2 = nil
}
function TitleInfo:Initialize()
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  local self = TitleInfo
  local titleStartY = 75
  local titleGapY = 35
  local minSize = float2()
  minSize.x = 10
  minSize.y = 50
  Panel_Window_CharInfo_TitleInfo:SetShow(false)
  TitleInfo:createControl()
  self.list2:setMinScrollBtnSize(minSize)
  TitleInfo.txt_SubTitleBar:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_SUBTITLEBAR_COUNT", "count", ToClient_GetTotalAcquiredTitleCount()))
end
function TitleInfo:createControl()
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  self._titleListBG = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Static_BG")
  self.totalProgress = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Static_TotalProgress_Progress")
  self.totalProgressValue = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_TotalProgress_Percent")
  self.Category_BTN[0] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Taste_AllRound")
  self.Category_BTN[1] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Taste_Combat")
  self.Category_BTN[2] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Taste_Product")
  self.Category_BTN[3] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Taste_Fishing")
  self._titleRightListBG = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Static_RightBG")
  self.titleSubject_Btn[0] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Top_AllRound")
  self.titleSubject_Btn[1] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Top_Combat")
  self.titleSubject_Btn[2] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Top_Product")
  self.titleSubject_Btn[3] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Top_Fish")
  self.title_ListAll = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_AllRound_CountValue")
  self.title_ListCombat = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Combat_CountValue")
  self.title_ListProduct = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Product_CountValue")
  self.title_ListFish = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Fishing_CountValue")
  self.title_ListAllPercent = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_AllRound_PercentValue")
  self.title_ListCombatPercent = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Combat_PercentValue")
  self.title_ListProductPercent = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Product_PercentValue")
  self.title_ListFishPercent = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Fishing_PercentValue")
  self.txt_AllRoundDesc = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_AllRoundDesc")
  self.txt_CombatDesc = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_CombatDesc")
  self.txt_ProductDesc = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_ProductDesc")
  self.txt_FishingDesc = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_FishingDesc")
  self.txt_TotalReward = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_TotalProgressReward")
  self.txt_TotalReward_Value = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_TotalProgressReward_Value")
  self.txt_PartDesc = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_SelectedType")
  self.txt_SubTitleBar = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_LeftSubTitle")
  self.title_LastUpdateTime = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_AcceptCooltime")
  self.list2 = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "List2_CharacterInfo_TitleList")
end
function TitleInfo:TitleUpdate()
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  local titleCountByAll = ToClient_GetTotalTitleCount()
  local titleTotalCount = ToClient_GetTotalTitleBuffCount()
  self.txt_TotalReward_Value:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_TOTALREWARD_VALUE"))
  self.txt_PartDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  if "" == TitleInfo.txt_PartDesc:GetText() or nil == TitleInfo.txt_PartDesc:GetText() then
    self.txt_PartDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_PARTDESC"))
  end
  if nil == titleCountByAll then
    return
  end
  local gotTitleCountByAll = ToClient_GetTotalAcquiredTitleCount()
  if nil == gotTitleCountByAll then
    return
  end
  local totalPercent = gotTitleCountByAll / titleCountByAll * 100
  self.totalProgress:SetProgressRate(totalPercent)
  self.totalProgressValue:SetText(string.format("%.1f", totalPercent) .. "%")
  for index = 0, titleTotalCount - 1 do
    local titleBuffWrapper = ToClient_GetTitleBuffWrapper(index)
    if nil ~= titleBuffWrapper then
      local buffDescription = titleBuffWrapper:getBuffDescription()
      self.txt_TotalReward_Value:SetTextMode(UI_TM.eTextMode_AutoWrap)
      self.txt_TotalReward_Value:SetText(buffDescription)
    end
  end
  for categoryIdx = 0, 3 do
    ToClient_GetCategoryTitleCount(categoryIdx)
    local titleCurrentCount = ToClient_GetCategoryTitleCount(categoryIdx)
    local titleCurrentGetCount = ToClient_GetAcquiredTitleCount(categoryIdx)
    local titleCurrentPercent = 0
    if 0 == titleCurrentGetCount then
      titleCurrentPercent = 0
    else
      titleCurrentPercent = titleCurrentGetCount / titleCurrentCount * 100
    end
    if self.CurrentCategoryIdx == categoryIdx then
      self.Category_BTN[categoryIdx]:SetCheck(true)
      self.titleSubject_Btn[categoryIdx]:SetCheck(true)
    end
    if 0 == categoryIdx then
      self.title_ListAll:SetText(titleCurrentGetCount .. "/" .. titleCurrentCount)
      self.title_ListAllPercent:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_LISTALL", "percent", string.format("%.1f", titleCurrentPercent)))
    elseif 1 == categoryIdx then
      self.title_ListCombat:SetText(titleCurrentGetCount .. "/" .. titleCurrentCount)
      self.title_ListCombatPercent:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_LISTCOMBAT", "percent", string.format("%.1f", titleCurrentPercent)))
    elseif 2 == categoryIdx then
      self.title_ListProduct:SetText(titleCurrentGetCount .. "/" .. titleCurrentCount)
      self.title_ListProductPercent:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_LISTPRODUCT", "percent", string.format("%.1f", titleCurrentPercent)))
    elseif 3 == categoryIdx then
      self.title_ListFish:SetText(titleCurrentGetCount .. "/" .. titleCurrentCount)
      self.title_ListFishPercent:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_LISTFISH", "percent", string.format("%.1f", titleCurrentPercent)))
    end
  end
  local lastCount = self.CurrentCategoryCount
  if lastCount < 1 then
    return
  end
  self.list2:getElementManager():clearKey()
  for titleIndex = 0, lastCount - 1 do
    self.list2:getElementManager():pushKey(toInt64(0, titleIndex))
  end
end
function FromClient_TitleInfo_Update()
  local self = TitleInfo
  self:TitleUpdate()
  self:updateCoolTime()
end
function TitleInfo:updateCoolTime()
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  local coolTime = ToClient_GetUpdateTitleDelay()
  self.title_LastUpdateTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_LASTUPDATETIME", "coolTime", coolTime))
end
function TitleInfo_Open()
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  ToClient_SetCurrentTitleCategory(0)
  TitleInfo_SetCategory(0)
  local self = TitleInfo
  self.txt_SubTitleBar:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_SUBTITLEBAR_COUNT", "count", ToClient_GetTotalAcquiredTitleCount()))
  self.CurrentCategoryCount = ToClient_GetCategoryTitleCount(0)
  TitleInfo.txt_PartDesc:SetText("")
  self:TitleUpdate()
  self:updateCoolTime()
end
function CharInfoMouseUpScroll()
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  local scroll = TitleInfo.list2:GetVScroll():GetControlButton()
  TitleInfo.list2:MouseUpScroll(scroll)
end
function CharInfoMouseDownScroll()
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  local scroll = TitleInfo.list2:GetVScroll():GetControlButton()
  TitleInfo.list2:MouseDownScroll(scroll)
end
function TitleInfo:registEventHandler()
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  for idx = 0, 3 do
    self.Category_BTN[idx]:addInputEvent("Mouse_LUp", "TitleInfo_SetCategory( " .. idx .. " )")
    self.titleSubject_Btn[idx]:addInputEvent("Mouse_LUp", "TitleInfo_SetCategory( " .. idx .. " )")
    self.Category_BTN[idx]:addInputEvent("Mouse_On", "HandleMouseEvent_CategoryDesc( " .. idx .. ", true )")
    self.Category_BTN[idx]:addInputEvent("Mouse_Out", "HandleMouseEvent_CategoryDesc( " .. idx .. ", false )")
  end
  self.list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "CharacterInfo_Title_ListControlCreate")
  self.list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function HandleMouseEvent_CategoryDesc(descType, isOn)
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  if descType == 0 and isOn == true then
    TitleInfo.txt_AllRoundDesc:SetAlpha(0)
    TitleInfo.txt_AllRoundDesc:SetFontAlpha(0)
    TitleInfo.txt_AllRoundDesc:ResetVertexAni()
    local AniInfo = UIAni.AlphaAnimation(1, TitleInfo.txt_AllRoundDesc, 0, 0.15)
    TitleInfo.txt_AllRoundDesc:SetShow(true)
  elseif descType == 1 and isOn == true then
    TitleInfo.txt_CombatDesc:SetAlpha(0)
    TitleInfo.txt_CombatDesc:SetFontAlpha(0)
    TitleInfo.txt_CombatDesc:ResetVertexAni()
    local AniInfo = UIAni.AlphaAnimation(1, TitleInfo.txt_CombatDesc, 0, 0.15)
    TitleInfo.txt_CombatDesc:SetShow(true)
  elseif descType == 2 and isOn == true then
    TitleInfo.txt_ProductDesc:SetAlpha(0)
    TitleInfo.txt_ProductDesc:SetFontAlpha(0)
    TitleInfo.txt_ProductDesc:ResetVertexAni()
    local AniInfo = UIAni.AlphaAnimation(1, TitleInfo.txt_ProductDesc, 0, 0.15)
    TitleInfo.txt_ProductDesc:SetShow(true)
  elseif descType == 3 and isOn == true then
    TitleInfo.txt_FishingDesc:SetAlpha(0)
    TitleInfo.txt_FishingDesc:SetFontAlpha(0)
    TitleInfo.txt_FishingDesc:ResetVertexAni()
    local AniInfo = UIAni.AlphaAnimation(1, TitleInfo.txt_FishingDesc, 0, 0.15)
    TitleInfo.txt_FishingDesc:SetShow(true)
  end
  if descType == 0 and isOn == false then
    TitleInfo.txt_AllRoundDesc:ResetVertexAni()
    local AniInfo = UIAni.AlphaAnimation(0, TitleInfo.txt_AllRoundDesc, 0, 0.1)
    AniInfo:SetHideAtEnd(true)
  elseif descType == 1 and isOn == false then
    TitleInfo.txt_CombatDesc:ResetVertexAni()
    local AniInfo1 = UIAni.AlphaAnimation(0, TitleInfo.txt_CombatDesc, 0, 0.1)
    AniInfo1:SetHideAtEnd(true)
  elseif descType == 2 and isOn == false then
    TitleInfo.txt_ProductDesc:ResetVertexAni()
    local AniInfo2 = UIAni.AlphaAnimation(0, TitleInfo.txt_ProductDesc, 0, 0.1)
    AniInfo2:SetHideAtEnd(true)
  elseif descType == 3 and isOn == false then
    TitleInfo.txt_FishingDesc:ResetVertexAni()
    local AniInfo3 = UIAni.AlphaAnimation(0, TitleInfo.txt_FishingDesc, 0, 0.1)
    AniInfo3:SetHideAtEnd(true)
  end
end
function TitleInfo_SetCategory(categoryIdx)
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  local self = TitleInfo
  for idx = 0, 3 do
    self.Category_BTN[idx]:SetCheck(false)
    self.titleSubject_Btn[idx]:SetCheck(false)
    self.titleSubject_Btn[idx]:SetFontColor(4291083966)
  end
  ToClient_SetCurrentTitleCategory(categoryIdx)
  self.CurrentCategoryCount = ToClient_GetCategoryTitleCount(categoryIdx)
  self.CurrentCategoryIdx = categoryIdx
  self.Category_BTN[categoryIdx]:SetCheck(true)
  if categoryIdx == 0 then
    self.titleSubject_Btn[0]:SetFontColor(4294959762)
  elseif categoryIdx == 1 then
    self.titleSubject_Btn[1]:SetFontColor(4294940310)
  elseif categoryIdx == 2 then
    self.titleSubject_Btn[2]:SetFontColor(4292935574)
  elseif categoryIdx == 3 then
    self.titleSubject_Btn[3]:SetFontColor(4288076287)
  end
  self:TitleUpdate()
  self:updateCoolTime()
end
function TitleInfo:registMessageHandler()
  registerEvent("FromClient_TitleInfo_UpdateText", "FromClient_TitleInfo_Update")
end
function HandleClick_ShowDescription(categoryIdx, titleIdx)
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  ToClient_SetCurrentTitleCategory(categoryIdx)
  local titleWrapper = ToClient_GetTitleStaticStatusWrapper(titleIdx)
  TitleInfo.txt_PartDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  TitleInfo.txt_PartDesc:SetText(titleWrapper:getDescription())
end
function HandleClick_TitleSet(categoryIdx, titleIdx)
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  ToClient_SetCurrentTitleCategory(categoryIdx)
  local titleWrapper = ToClient_GetTitleStaticStatusWrapper(titleIdx)
  TitleInfo.txt_PartDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  TitleInfo.txt_PartDesc:SetText(titleWrapper:getDescription())
  ToClient_TitleSetRequest(categoryIdx, titleIdx)
end
function CharacterInfo_Title_ListControlCreate(content, key)
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  local self = TitleInfo
  local titleIndex = Int64toInt32(key)
  local titleWrapper = ToClient_GetTitleStaticStatusWrapper(titleIndex)
  if nil == titleWrapper then
    return
  end
  local titleBG = UI.getChildControl(content, "List2_Static_TitleList_TitleBG")
  titleBG:setNotImpactScrollEvent(true)
  local titleName = UI.getChildControl(content, "List2_StaticText_TitleList_Title")
  local titleSet = UI.getChildControl(content, "List2_Button_SetTitle")
  if titleWrapper:isAcquired() == true then
    titleBG:SetIgnore(false)
    titleBG:addInputEvent("Mouse_LUp", "HandleClick_ShowDescription(" .. self.CurrentCategoryIdx .. ", " .. titleIndex .. " )")
    titleName:SetShow(true)
    titleName:SetText(titleWrapper:getName())
    titleSet:SetShow(true)
    titleSet:addInputEvent("Mouse_LUp", "HandleClick_TitleSet(" .. self.CurrentCategoryIdx .. ", " .. titleIndex .. " )")
    if ToClient_IsAppliedTitle(titleWrapper:getKey()) then
      titleSet:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_RELEASE"))
    else
      titleSet:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_APPLICATION"))
    end
  else
    titleBG:SetIgnore(false)
    titleName:SetShow(true)
    titleName:SetText("<PAColor0xFF444444>" .. titleWrapper:getName() .. "<PAOldColor>")
    titleBG:addInputEvent("Mouse_LUp", "HandleClick_ShowDescription(" .. self.CurrentCategoryIdx .. "," .. titleIndex .. ")")
    titleSet:SetShow(false)
  end
end
function FromClient_CharacterInfoTitle_Init()
  PaGlobal_CharacterInfoTitle_Init()
  TitleInfo:registMessageHandler()
end
function PaGlobal_CharacterInfoTitle_Init()
  TitleInfo:Initialize()
  TitleInfo:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_CharacterInfoTitle_Init")
