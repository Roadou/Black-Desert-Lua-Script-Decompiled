local UI_IT = CppEnums.UiInputType
local UI_color = Defines.Color
function PaGlobal_Menu_Remake:initialize()
  if true == PaGlobal_Menu_Remake._initialize then
    return
  end
  PaGlobal_Menu_Remake._ui.stc_topGroup = UI.getChildControl(Panel_Widget_Menu_Remake, "Static_Top_Group")
  PaGlobal_Menu_Remake._ui.stc_menuGroup = UI.getChildControl(Panel_Widget_Menu_Remake, "Static_Menu_Group")
  PaGlobal_Menu_Remake._ui.stc_searchGroup = UI.getChildControl(Panel_Widget_Menu_Remake, "Static_Search_Group")
  PaGlobal_Menu_Remake._ui.stc_searchResultGroup = UI.getChildControl(Panel_Widget_Menu_Remake, "Static_Search_Result_Group")
  PaGlobal_Menu_Remake._ui.radiobtn_searchResult = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_searchResultGroup, "RadioButton_Result_Btn")
  PaGlobal_Menu_Remake._ui.stc_subMenuGroup = UI.getChildControl(Panel_Widget_Menu_Remake, "Static_SubMenu_Group")
  PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group = UI.getChildControl(Panel_Widget_Menu_Remake, "Static_MenuSelect_Desc_Group")
  PaGlobal_Menu_Remake._ui.stc_submenu_BG = UI.getChildControl(Panel_Widget_Menu_Remake, "Static_Submenu_BG")
  PaGlobal_Menu_Remake._ui.stc_submenu_highlight = UI.getChildControl(Panel_Widget_Menu_Remake, "Static_SubMenu_Highlight")
  PaGlobal_Menu_Remake._ui.stc_header_button_group = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_topGroup, "Static_Header_Button_Group")
  PaGlobal_Menu_Remake._ui.stc_header_button = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_header_button_group, "RadioButton_Header_Button")
  PaGlobal_Menu_Remake._ui.stc_header_button_title_group = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_header_button_group, "Static_Header_Button_Title_Group")
  PaGlobal_Menu_Remake._ui.stctxt_header_button_title = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_header_button_title_group, "StaticText_Header_Button_Title")
  PaGlobal_Menu_Remake._ui.stc_header_title_shape1 = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_header_button_title_group, "Static_Header_Title_Shape1")
  PaGlobal_Menu_Remake._ui.stc_header_title_shape2 = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_header_button_title_group, "Static_Header_Title_Shape2")
  PaGlobal_Menu_Remake._ui.stc_header_interface_group = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_topGroup, "Static_Header_Interface_Group")
  PaGlobal_Menu_Remake._ui.edit_searchTxt = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_searchGroup, "Edit_Search_Txt")
  PaGlobal_Menu_Remake._ui.stctxt_customize_desc = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_header_interface_group, "StaticText_CustomizeMode_Desc")
  PaGlobal_Menu_Remake._ui.stctxt_customize_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_Menu_Remake._ui.stctxt_customize_desc:SetText(PaGlobal_Menu_Remake._ui.stctxt_customize_desc:GetText())
  PaGlobal_Menu_Remake._ui.btn_cancel = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_header_interface_group, "Button_Cancel")
  PaGlobal_Menu_Remake._ui.btn_commit = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_header_interface_group, "Button_Commit")
  PaGlobal_Menu_Remake._ui.btn_changeUi = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_header_interface_group, "Button_Change_UI")
  PaGlobal_Menu_Remake._ui.btn_openway = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_header_interface_group, "Button_OpenWay")
  PaGlobal_Menu_Remake._ui.btn_customizeUi = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_header_interface_group, "Button_Customize_Menu")
  PaGlobal_Menu_Remake._ui.btn_customizeUi:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_DOEDIT"))
  PaGlobal_Menu_Remake._ui.btn_customizeUi:SetEnableArea(0, 0, PaGlobal_Menu_Remake._ui.btn_customizeUi:GetSizeX() + PaGlobal_Menu_Remake._ui.btn_customizeUi:GetTextSizeX() + 15, PaGlobal_Menu_Remake._ui.btn_customizeUi:GetSizeY())
  if true == _ContentsGroup_RenewUI then
    PaGlobal_Menu_Remake._ui.btn_cancel:SetShow(false)
    PaGlobal_Menu_Remake._ui.btn_commit:SetShow(false)
    PaGlobal_Menu_Remake._ui.btn_openway:SetShow(false)
    PaGlobal_Menu_Remake._ui.btn_changeUi:SetShow(false)
  end
  PaGlobal_Menu_Remake._ui.stc_menuSelect_desc = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group, "StaticText_MenuSelect_Desc")
  PaGlobal_Menu_Remake._ui.stc_menuSelect_desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_EDITSLOTTEXT"))
  PaGlobal_Menu_Remake._ui.stctxt_header_button_title:SetText("")
  PaGlobal_Menu_Remake._ui.stc_header_title_shape1:SetShow(false)
  PaGlobal_Menu_Remake._ui.stc_header_title_shape2:SetShow(false)
  PaGlobal_Menu_Remake._ui.stc_menu_highlight = UI.getChildControl(Panel_Widget_Menu_Remake, "Static_Menu_Highlight")
  PaGlobal_Menu_Remake._ui.radiobtn_menu = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_menuGroup, "RadioButton_Menu_Btn")
  PaGlobal_Menu_Remake._ui.radiobtn_sub_menu = UI.getChildControl(PaGlobal_Menu_Remake._ui.stc_subMenuGroup, "RadioButton_SubMenu")
  PaGlobal_Menu_Remake._isLeft = 0 == ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eMenuOpenWay)
  PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(true)
  PaGlobal_Menu_Remake:hideTooltip()
  PaGlobal_Menu_Remake:resetMenu()
  PaGlobal_Menu_Remake:setMenuOpenWayBtn()
  PaGlobal_Menu_Remake:setCustomize_menu(false)
  PaGlobal_Menu_Remake:resizeMenu()
  PaGlobal_Menu_Remake:registEventHandler()
  PaGlobal_Menu_Remake:validate()
  PaGlobal_Menu_Remake._initialize = true
end
function PaGlobal_Menu_Remake:setMenuCondition()
  PaGlobal_Menu_Remake._conditionGroup = {}
  PaGlobal_Menu_Remake._conditionGroup = {
    _isLocalwarOpen = true == ToClient_IsGrowStepOpen(__eGrowStep_localWar) or false == _ContentsGroup_GrowStep,
    _isMercenaryOpen = true == ToClient_IsGrowStepOpen(__eGrowStep_militia) or false == _ContentsGroup_GrowStep,
    _isSavageOpen = true == ToClient_IsGrowStepOpen(__eGrowStep_savageDefence) or false == _ContentsGroup_GrowStep,
    _isContentsArsha = true == ToClient_IsGrowStepOpen(__eGrowStep_arsha) or false == _ContentsGroup_GrowStep,
    _isFreeFight = true == ToClient_IsGrowStepOpen(__eGrowStep_freeFight) or false == _ContentsGroup_GrowStep,
    _isTeamDuelOpen = true == ToClient_IsGrowStepOpen(__eGrowStep_teamDuel) or false == _ContentsGroup_GrowStep,
    _isBossAlert = true == ToClient_IsGrowStepOpen(__eGrowStep_bossAlert) or false == _ContentsGroup_GrowStep,
    _isFairyOpen = 0 < ToClient_getFairyUnsealedList() + ToClient_getFairySealedList(),
    _isCampOpen = ToClient_isCampingReigsted(),
    _isMaidOpen = true == (0 < getTotalMaidList() and 7 <= getSelfPlayer():get():getLevel() and false == ToClient_IsInstanceFieldPlayerbyContentsType(__eInstanceContentsType_SavageDefence)),
    _isPetOpen = 0 ~= ToClient_getPetUnsealedList() + ToClient_getPetSealedList(),
    _isQuestOpen = false == ToClient_IsInstanceFieldPlayerbyContentsType(__eInstanceContentsType_SavageDefence),
    _isDailyStampOpen = 0 < ToClient_GetAttendanceInfoCount()
  }
end
function PaGlobal_Menu_Remake:pressedArrowKey(keycode)
  if nil == keycode then
    return
  end
  local nowMenuIndex = PaGlobal_Menu_Remake._nowMenuIndex
  local nowMenuMode = PaGlobal_Menu_Remake._nowMenuMode
  local nowSelectedMenuIndex = PaGlobal_Menu_Remake._nowSelectedMenuIndex
  local MAX_LINE_SHOWHEADER = PaGlobal_Menu_Remake._MAX_LINE_SHOWHEADER
  if keycode == CppEnums.VirtualKeyCode.KeyCode_DOWN then
    if nowMenuMode == "header" then
      if math.ceil(nowMenuIndex / MAX_LINE_SHOWHEADER) >= math.ceil(#PaGlobal_Menu_Remake._headerHotKeyGroup / MAX_LINE_SHOWHEADER) then
        if true == PaGlobal_Menu_Remake._ui.stc_searchResultGroup:GetShow() then
          PaGlobal_Menu_Remake:searchMenu_toggle(1, true)
        else
          PaGlobal_Menu_Remake:menu_toggle(1, true)
        end
      else
        nowMenuIndex = nowMenuIndex + MAX_LINE_SHOWHEADER
        PaGlobal_Menu_Remake:headMenu_toggle(nowMenuIndex)
      end
    elseif nowMenuMode == "menu" then
      if nowMenuIndex >= #PaGlobal_Menu_Remake._menuHotKeyGroup then
        nowMenuIndex = 1
        PaGlobal_Menu_Remake:menu_toggle(nowMenuIndex, false)
        PaGlobal_Menu_Remake:headMenu_toggle(nowMenuIndex)
      else
        nowMenuIndex = nowMenuIndex + 1
        PaGlobal_Menu_Remake:menu_toggle(nowMenuIndex, true)
      end
    elseif nowMenuMode == "submenu" then
      local menuHotKey = PaGlobal_Menu_Remake._menuHotKey[nowSelectedMenuIndex]
      if nowMenuIndex == menuHotKey.submenuCnt then
        nowMenuIndex = 1
      else
        nowMenuIndex = nowMenuIndex + 1
      end
      PaGlobal_Menu_Remake:submenu_toggle(nowMenuIndex, true)
    elseif nowMenuMode == "search" then
      if nowMenuIndex >= #PaGlobal_Menu_Remake._searchResult then
        nowMenuIndex = 1
        PaGlobal_Menu_Remake:searchMenu_toggle(nowMenuIndex, false)
        PaGlobal_Menu_Remake:headMenu_toggle(nowMenuIndex)
      else
        nowMenuIndex = nowMenuIndex + 1
        PaGlobal_Menu_Remake:searchMenu_toggle(nowMenuIndex, true)
      end
    end
  elseif keycode == CppEnums.VirtualKeyCode.KeyCode_UP then
    if nowMenuMode == "header" then
      if math.ceil(nowMenuIndex / MAX_LINE_SHOWHEADER) == 1 then
        if true == PaGlobal_Menu_Remake._ui.stc_searchResultGroup:GetShow() then
          nowMenuIndex = #PaGlobal_Menu_Remake._searchResult
          PaGlobal_Menu_Remake:searchMenu_toggle(nowMenuIndex, true)
        else
          nowMenuIndex = #PaGlobal_Menu_Remake._menuHotKeyGroup
          PaGlobal_Menu_Remake:menu_toggle(nowMenuIndex, true)
        end
      else
        nowMenuIndex = nowMenuIndex - MAX_LINE_SHOWHEADER
        PaGlobal_Menu_Remake:headMenu_toggle(nowMenuIndex)
      end
    elseif nowMenuMode == "menu" then
      if 1 == nowMenuIndex then
        nowMenuIndex = 1 + MAX_LINE_SHOWHEADER * (math.ceil(#PaGlobal_Menu_Remake._headerHotKeyGroup / MAX_LINE_SHOWHEADER) - 1)
        PaGlobal_Menu_Remake:menu_toggle(nowMenuIndex, false)
        PaGlobal_Menu_Remake:headMenu_toggle(nowMenuIndex)
      else
        nowMenuIndex = nowMenuIndex - 1
        PaGlobal_Menu_Remake:menu_toggle(nowMenuIndex, true)
      end
    elseif nowMenuMode == "submenu" then
      local menuHotKey = PaGlobal_Menu_Remake._menuHotKey[nowSelectedMenuIndex]
      if nowMenuIndex == 1 then
        nowMenuIndex = menuHotKey.submenuCnt
      else
        nowMenuIndex = nowMenuIndex - 1
      end
      PaGlobal_Menu_Remake:submenu_toggle(nowMenuIndex, true)
    elseif nowMenuMode == "search" then
      if 1 == nowMenuIndex then
        nowMenuIndex = 1 + MAX_LINE_SHOWHEADER * (math.ceil(#PaGlobal_Menu_Remake._headerHotKeyGroup / MAX_LINE_SHOWHEADER) - 1)
        PaGlobal_Menu_Remake:searchMenu_toggle(nowMenuIndex, false)
        PaGlobal_Menu_Remake:headMenu_toggle(nowMenuIndex)
      else
        nowMenuIndex = nowMenuIndex - 1
        PaGlobal_Menu_Remake:searchMenu_toggle(nowMenuIndex, true)
      end
    end
  elseif keycode == CppEnums.VirtualKeyCode.KeyCode_RIGHT then
    if nowMenuMode == "header" then
      if nowMenuIndex % MAX_LINE_SHOWHEADER == 0 then
        nowMenuIndex = nowMenuIndex + 1 - MAX_LINE_SHOWHEADER
      else
        nowMenuIndex = nowMenuIndex + 1
      end
      PaGlobal_Menu_Remake:headMenu_toggle(nowMenuIndex)
    elseif nowMenuMode == "menu" then
      PaGlobal_Menu_Remake:menu_select(nowMenuIndex)
    end
  elseif keycode == CppEnums.VirtualKeyCode.KeyCode_LEFT then
    if nowMenuMode == "header" then
      if nowMenuIndex % MAX_LINE_SHOWHEADER == 1 then
        nowMenuIndex = nowMenuIndex + MAX_LINE_SHOWHEADER - 1
      else
        nowMenuIndex = nowMenuIndex - 1
      end
      PaGlobal_Menu_Remake:headMenu_toggle(nowMenuIndex)
    elseif nowMenuMode == "submenu" then
      PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(false)
      PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:SetShow(true)
      PaGlobal_Menu_Remake:setHighLight("menu")
      PaGlobal_Menu_Remake:menu_toggle(nowSelectedMenuIndex, true)
      local textureDDS = PaGlobal_Menu_Remake._menuGrid.ddsUrl
      local textureUVOn = PaGlobal_Menu_Remake._menuGrid.on
      controlGroup = PaGlobal_Menu_Remake._menuHotKeyGroup[PaGlobal_Menu_Remake._nowSelectedMenuIndex]
      controlGroup.radiobtn:ChangeTextureInfoName(textureDDS)
      local x1, y1, x2, y2 = setTextureUV_Func(controlGroup.radiobtn, textureUVOn.x1, textureUVOn.y1, textureUVOn.x2, textureUVOn.y2)
      controlGroup.radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      controlGroup.radiobtn:setRenderTexture(controlGroup.radiobtn:getBaseTexture())
      PaGlobal_Menu_Remake._nowSelectedMenuIndex = 0
    end
  end
end
function PaGlobal_Menu_Remake:searchingMenu()
  local searchText = PaGlobal_Menu_Remake._ui.edit_searchTxt:GetEditText()
  ClearFocusEdit()
  if nil == searchText or "" == searchText then
    PaGlobal_Menu_Remake:setBeforeSearch()
    return
  end
  PaGlobal_Menu_Remake._searchResult = {}
  for ii = 1, #PaGlobal_Menu_Remake._menuHotKey do
    local menuHotKey = PaGlobal_Menu_Remake._menuHotKey[ii]
    if nil ~= menuHotKey and nil ~= menuHotKey.subMenu then
      for submenuIndex = 1, #menuHotKey.subMenu do
        if (nil == menuHotKey.subMenu[submenuIndex].isContentOpen or true == menuHotKey.subMenu[submenuIndex].isContentOpen) and (nil == menuHotKey.subMenu[submenuIndex].isConditionOpen or true == menuHotKey.subMenu[submenuIndex].isConditionOpen) and nil ~= menuHotKey.subMenu[submenuIndex].func then
          local startIdx, endIdx = string.find(menuHotKey.subMenu[submenuIndex].title, searchText)
          if nil ~= startIdx and nil ~= endIdx then
            PaGlobal_Menu_Remake._searchResult[#PaGlobal_Menu_Remake._searchResult + 1] = menuHotKey.subMenu[submenuIndex]
          end
        end
      end
    end
  end
  PaGlobal_Menu_Remake:setSearchResult()
end
function PaGlobal_Menu_Remake:setSearchResult()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  if nil == PaGlobal_Menu_Remake._searchResult or 0 == #PaGlobal_Menu_Remake._searchResult then
    PaGlobal_Menu_Remake:setBeforeSearch()
    return
  end
  if false == PaGlobal_Menu_Remake._ui.stc_searchResultGroup:GetShow() then
    PaGlobal_Menu_Remake._beforeSearchMenuMode = PaGlobal_Menu_Remake._nowMenuMode
    PaGlobal_Menu_Remake._beforeSearchSelectedMenuIndex = PaGlobal_Menu_Remake._nowMenuIndex
    PaGlobal_Menu_Remake._beforeSelectedMenuIndex = PaGlobal_Menu_Remake._nowSelectedMenuIndex
    PaGlobal_Menu_Remake._ui.stc_searchResultGroup:SetShow(true)
    PaGlobal_Menu_Remake._ui.stc_menuGroup:SetShow(false)
    PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(false)
    PaGlobal_Menu_Remake._ui.stc_submenu_BG:SetShow(false)
  end
  for index, controlGroup in pairs(PaGlobal_Menu_Remake._searchResultGroup) do
    if nil ~= controlGroup and nil ~= controlGroup.radiobtn then
      controlGroup.radiobtn:SetShow(false)
      controlGroup.radiobtn:addInputEvent("Mouse_LUp", "")
      controlGroup.radiobtn:addInputEvent("Mouse_On", "")
    end
  end
  for ii = 1, PaGlobal_Menu_Remake._MAX_SUBMENU do
    PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberKeySetting[ii]] = {}
    PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberPadKeySetting[ii]] = {}
  end
  local tempPosY = 1
  for ii = 1, #PaGlobal_Menu_Remake._searchResult do
    if nil == PaGlobal_Menu_Remake._searchResultGroup[ii] then
      local radiobtn_result = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.stc_searchResultGroup, "RadioButton_Result_Btn", PaGlobal_Menu_Remake._ui.stc_searchResultGroup, "RadioButton_Result_Btn_" .. ii)
      local stc_menuIcon = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.radiobtn_searchResult, "Static_Menu_Icon", radiobtn_result, "Static_Menu_Icon")
      local stctxt_hotkey = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.radiobtn_searchResult, "StaticText_Hotkey", radiobtn_result, "StaticText_Hotkey")
      local stctxt_title = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.radiobtn_searchResult, "StaticText_Title", radiobtn_result, "StaticText_Title")
      stctxt_hotkey:SetText(ii)
      PaGlobal_Menu_Remake._searchResultGroup[ii] = {}
      PaGlobal_Menu_Remake._searchResultGroup[ii].radiobtn = radiobtn_result
      PaGlobal_Menu_Remake._searchResultGroup[ii].icon = stc_menuIcon
      PaGlobal_Menu_Remake._searchResultGroup[ii].hotkey = stctxt_hotkey
      PaGlobal_Menu_Remake._searchResultGroup[ii].title = stctxt_title
    end
    local radiobtn = PaGlobal_Menu_Remake._searchResultGroup[ii].radiobtn
    local icon = PaGlobal_Menu_Remake._searchResultGroup[ii].icon
    local numIcon = PaGlobal_Menu_Remake._searchResultGroup[ii].hotkey
    local title = PaGlobal_Menu_Remake._searchResultGroup[ii].title
    local textureUV = PaGlobal_Menu_Remake._searchResult[ii].ddsGrid
    local textureDDS = PaGlobal_Menu_Remake._searchResult[ii].ddsUrl
    radiobtn:SetShow(true)
    PaGlobal_Menu_Remake._ui.stctxt_header_button_title:SetText("")
    PaGlobal_Menu_Remake._ui.stc_header_title_shape1:SetShow(false)
    PaGlobal_Menu_Remake._ui.stc_header_title_shape2:SetShow(false)
    if nil ~= textureUV and nil ~= textureDDS then
      icon:ChangeTextureInfoName(textureDDS)
      local x1, y1, x2, y2 = setTextureUV_Func(icon, textureUV.x1, textureUV.y1, textureUV.x2, textureUV.y2)
      icon:getBaseTexture():setUV(x1, y1, x2, y2)
      icon:setRenderTexture(icon:getBaseTexture())
    else
      icon:ChangeTextureInfoName("")
      icon:setRenderTexture(icon:getBaseTexture())
    end
    title:SetText("")
    if nil ~= PaGlobal_Menu_Remake._searchResult[ii].title then
      title:SetText(PaGlobal_Menu_Remake._searchResult[ii].title)
    end
    radiobtn:addInputEvent("Mouse_LUp", "HandleEventLUp_MenuRemake_SearchingMenu(" .. ii .. ")")
    radiobtn:addInputEvent("Mouse_On", "HandleEventOn_MenuRemake_SearchingMenu(" .. ii .. ")")
    radiobtn:SetPosY(tempPosY)
    tempPosY = tempPosY + radiobtn:GetSizeY()
  end
  PaGlobal_Menu_Remake:searchMenu_toggle(1, true)
end
function PaGlobal_Menu_Remake:searchMenu_select(searchMenuIndex)
  if nil == searchMenuIndex then
    return
  end
  local searchMenuGroup = PaGlobal_Menu_Remake._searchResult[searchMenuIndex]
  if nil == searchMenuGroup or nil == searchMenuGroup.func then
    return
  end
  if nil ~= searchMenuGroup.isConditionOpen and false == searchMenuGroup.isConditionOpen then
    return
  end
  if false == PaGlobal_Menu_Remake._isCustomizeMode then
    searchMenuGroup.func()
    PaGlobal_Menu_Remake:prepareClose()
  else
    for index = 1, PaGlobal_Menu_Remake._MAX_HEADERMENU do
      if nil ~= PaGlobal_Menu_Remake._headerHotKey[index] and searchMenuGroup.index == PaGlobal_Menu_Remake._headerHotKey[index].index then
        PaGlobal_Menu_Remake._headerHotKey[index] = nil
      end
    end
    PaGlobal_Menu_Remake._headerHotKey[PaGlobal_Menu_Remake._selected_customize_headerIndex] = searchMenuGroup
    PaGlobal_Menu_Remake:setHeaderHotKey()
  end
end
function PaGlobal_Menu_Remake:searchMenu_toggle(searchMenuIndex, isOn)
  local textureUVOn = PaGlobal_Menu_Remake._searchMenuGrid.on
  local textureUVOut = PaGlobal_Menu_Remake._searchMenuGrid.normal
  local textureDDS = PaGlobal_Menu_Remake._searchMenuGrid.ddsUrl
  if false == PaGlobal_Menu_Remake._isCustomizeMode then
    PaGlobal_Menu_Remake._ui.stctxt_header_button_title:SetText("")
    PaGlobal_Menu_Remake._ui.stc_header_title_shape1:SetShow(false)
    PaGlobal_Menu_Remake._ui.stc_header_title_shape2:SetShow(false)
    local headertextureUVOut = PaGlobal_Menu_Remake._headerGrid.normal
    local headertextureDDS = PaGlobal_Menu_Remake._headerGrid.ddsUrl
    for index, controlGroup in pairs(PaGlobal_Menu_Remake._headerHotKeyGroup) do
      controlGroup.radiobtn:ChangeTextureInfoName(headertextureDDS)
      local x1, y1, x2, y2 = setTextureUV_Func(controlGroup.radiobtn, headertextureUVOut.x1, headertextureUVOut.y1, headertextureUVOut.x2, headertextureUVOut.y2)
      controlGroup.radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      controlGroup.radiobtn:setRenderTexture(controlGroup.radiobtn:getBaseTexture())
    end
  end
  for index, controlGroup in pairs(PaGlobal_Menu_Remake._searchResultGroup) do
    if nil ~= controlGroup and nil ~= controlGroup.radiobtn then
      controlGroup.radiobtn:ChangeTextureInfoName(textureDDS)
      local x1, y1, x2, y2 = setTextureUV_Func(controlGroup.radiobtn, textureUVOut.x1, textureUVOut.y1, textureUVOut.x2, textureUVOut.y2)
      controlGroup.radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      controlGroup.radiobtn:setRenderTexture(controlGroup.radiobtn:getBaseTexture())
    end
  end
  if true == isOn and nil ~= PaGlobal_Menu_Remake._searchResultGroup[searchMenuIndex] then
    PaGlobal_Menu_Remake._nowMenuMode = "search"
    PaGlobal_Menu_Remake._nowMenuIndex = searchMenuIndex
    PaGlobal_Menu_Remake._searchResultGroup[searchMenuIndex].radiobtn:ChangeTextureInfoName(textureDDS)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._searchResultGroup[searchMenuIndex].radiobtn, textureUVOn.x1, textureUVOn.y1, textureUVOn.x2, textureUVOn.y2)
    PaGlobal_Menu_Remake._searchResultGroup[searchMenuIndex].radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_Menu_Remake._searchResultGroup[searchMenuIndex].radiobtn:setRenderTexture(PaGlobal_Menu_Remake._searchResultGroup[searchMenuIndex].radiobtn:getBaseTexture())
  end
end
function PaGlobal_Menu_Remake:GetMenuInfo(saveIndex)
  if nil == PaGlobal_Menu_Remake._menuHotKey then
    return nil
  end
  for ii = 1, #PaGlobal_Menu_Remake._menuHotKey do
    if nil == PaGlobal_Menu_Remake._menuHotKey[ii] or nil == PaGlobal_Menu_Remake._menuHotKey[ii].subMenu then
      return nil
    end
    local submenuGroup = PaGlobal_Menu_Remake._menuHotKey[ii].subMenu
    for index = 1, #submenuGroup do
      if nil ~= submenuGroup[index].index and submenuGroup[index].index == saveIndex then
        return submenuGroup[index]
      end
    end
  end
  return nil
end
function PaGlobal_Menu_Remake:setHeadHotKeyInfo()
  for index = 1, PaGlobal_Menu_Remake._MAX_HEADERMENU do
    PaGlobal_Menu_Remake._headerHotKey[index] = {}
    local saveIndex = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(PaGlobal_Menu_Remake.UIOPTION_TYPE_MENU[index])
    if nil ~= saveIndex and 0 ~= saveIndex then
      PaGlobal_Menu_Remake._headerHotKey[index] = PaGlobal_Menu_Remake:GetMenuInfo(saveIndex)
    else
      ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(PaGlobal_Menu_Remake.UIOPTION_TYPE_MENU[index], PaGlobal_Menu_Remake.DEFAULT_HEADER_MENU_INDEX[index], CppEnums.VariableStorageType.eVariableStorageType_User)
      PaGlobal_Menu_Remake._headerHotKey[index] = PaGlobal_Menu_Remake:GetMenuInfo(PaGlobal_Menu_Remake.DEFAULT_HEADER_MENU_INDEX[index])
    end
  end
end
function PaGlobal_Menu_Remake:resizeMenu()
  Panel_Widget_Menu_Remake:SetSize(Panel_Widget_Menu_Remake:GetSizeX(), getScreenSizeY())
  PaGlobal_Menu_Remake._ui.stc_submenu_BG:SetSize(PaGlobal_Menu_Remake._ui.stc_submenu_BG:GetSizeX(), getScreenSizeY())
  if true == Panel_Widget_Menu_Remake:GetShow() then
    PaGlobal_Menu_Remake:ShowAni()
  end
end
function PaGlobal_Menu_Remake:setHeaderHotKey()
  local tempPosX = 10
  local defaultPosY = 45
  local tempPosY = defaultPosY
  local menuAddCnt = 0
  local maxSizeX = 0
  for ii = 1, PaGlobal_Menu_Remake._MAX_HEADERMENU do
    if nil == PaGlobal_Menu_Remake._headerHotKeyGroup[ii] then
      local radiobtn_headerMenu = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.stc_header_button_group, "RadioButton_Header_Button", PaGlobal_Menu_Remake._ui.stc_header_button_group, "RadioButton_Header_Button_" .. ii)
      local radiobtn_headerMenu_highLight = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.stc_header_button, "Static_Header_Button_Highlight", radiobtn_headerMenu, "Static_Header_Button_Highlight")
      local radiobtn_headerMenu_icon = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.stc_header_button, "Static_Header_Button_Icon", radiobtn_headerMenu, "Static_Header_Button_Icon")
      local radiobtn_headerMenu_plus_icon = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.stc_header_button, "Static_Header_Plus_Icon", radiobtn_headerMenu, "Static_Header_Plus_Icon")
      PaGlobal_Menu_Remake._headerHotKeyGroup[ii] = {}
      PaGlobal_Menu_Remake._headerHotKeyGroup[ii].highLight = radiobtn_headerMenu_highLight
      PaGlobal_Menu_Remake._headerHotKeyGroup[ii].radiobtn = radiobtn_headerMenu
      PaGlobal_Menu_Remake._headerHotKeyGroup[ii].icon = radiobtn_headerMenu_icon
      PaGlobal_Menu_Remake._headerHotKeyGroup[ii].plusIcon = radiobtn_headerMenu_plus_icon
    end
    if nil ~= PaGlobal_Menu_Remake._headerHotKeyGroup[ii] then
      local radiobtn = PaGlobal_Menu_Remake._headerHotKeyGroup[ii].radiobtn
      local icon = PaGlobal_Menu_Remake._headerHotKeyGroup[ii].icon
      local plusIcon = PaGlobal_Menu_Remake._headerHotKeyGroup[ii].plusIcon
      local highLight = PaGlobal_Menu_Remake._headerHotKeyGroup[ii].highLight
      if true == _ContentsGroup_RenewUI then
        radiobtn:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "HandleEventPadUP_MenuRemake_Move(" .. __eConsoleUIPadEvent_DpadUp .. ")")
        radiobtn:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "HandleEventPadUP_MenuRemake_Move(" .. __eConsoleUIPadEvent_DpadDown .. ")")
        radiobtn:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "HandleEventPadUP_MenuRemake_Move(" .. __eConsoleUIPadEvent_DpadLeft .. ")")
        radiobtn:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "HandleEventPadUP_MenuRemake_Move(" .. __eConsoleUIPadEvent_DpadRight .. ")")
        radiobtn:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_Menu_Remake_PressedConfirm()")
      end
      if nil ~= PaGlobal_Menu_Remake._headerHotKey[ii] then
        local textureUV = PaGlobal_Menu_Remake._headerHotKey[ii].ddsGrid
        local textureDDS = PaGlobal_Menu_Remake._headerHotKey[ii].ddsUrl
        if nil ~= textureUV and nil ~= textureDDS then
          icon:ChangeTextureInfoName(textureDDS)
          local x1, y1, x2, y2 = setTextureUV_Func(icon, textureUV.x1, textureUV.y1, textureUV.x2, textureUV.y2)
          icon:getBaseTexture():setUV(x1, y1, x2, y2)
          icon:setRenderTexture(icon:getBaseTexture())
        else
          icon:ChangeTextureInfoName("")
          icon:setRenderTexture(icon:getBaseTexture())
        end
        if true == PaGlobal_Menu_Remake._isCustomizeMode then
          radiobtn:SetIgnore(false)
        elseif nil == PaGlobal_Menu_Remake._headerHotKey[ii].isConditionOpen or true == PaGlobal_Menu_Remake._headerHotKey[ii].isConditionOpen then
          radiobtn:SetIgnore(false)
        else
          radiobtn:SetIgnore(true)
        end
        PaGlobal_Menu_Remake._headerHotKeyGroup[ii].title = PaGlobal_Menu_Remake._headerHotKey[ii].title
        PaGlobal_Menu_Remake._headerHotKeyGroup[ii].isNoSetting = false
      else
        PaGlobal_Menu_Remake._headerHotKeyGroup[ii].title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_NOTSETTING")
        PaGlobal_Menu_Remake._headerHotKeyGroup[ii].isNoSetting = true
      end
      if nil ~= PaGlobal_Menu_Remake._headerHotKey[ii] then
        plusIcon:SetShow(false)
        icon:SetShow(true)
      else
        plusIcon:SetShow(true)
        icon:SetShow(false)
      end
      local textureDDS = PaGlobal_Menu_Remake._headerGrid.ddsUrl
      local normalTextureUV = PaGlobal_Menu_Remake._headerGrid.normal
      local onTextureUV = PaGlobal_Menu_Remake._headerGrid.on
      if nil ~= normalTextureUV then
        local x1, y1, x2, y2 = setTextureUV_Func(radiobtn, normalTextureUV.x1, normalTextureUV.y1, normalTextureUV.x2, normalTextureUV.y2)
        radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      end
      if nil ~= onTextureUV then
        local x1, y1, x2, y2 = setTextureUV_Func(radiobtn, onTextureUV.x1, onTextureUV.y1, onTextureUV.x2, onTextureUV.y2)
        radiobtn:getOnTexture():setUV(x1, y1, x2, y2)
      end
      menuAddCnt = menuAddCnt + 1
      radiobtn:addInputEvent("Mouse_LUp", "HandleEventLUp_MenuRemake_HeadMenu(" .. ii .. ")")
      radiobtn:addInputEvent("Mouse_Out", "HandleEventOut_MenuRemake_HeadMenu(" .. ii .. ")")
      radiobtn:addInputEvent("Mouse_On", "HandleEventOn_MenuRemake_HeadMenu(" .. ii .. ")")
      if 0 == PaGlobal_Menu_Remake._selected_customize_headerIndex then
        radiobtn:ChangeTextureInfoName(textureDDS)
        radiobtn:SetCheck(false)
        radiobtn:setRenderTexture(radiobtn:getBaseTexture())
      end
      radiobtn:SetPosXY(tempPosX, tempPosY)
      tempPosX = tempPosX + radiobtn:GetSizeX() + 10
      if maxSizeX < tempPosX then
        maxSizeX = tempPosX
      end
      if 0 == menuAddCnt % PaGlobal_Menu_Remake._MAX_LINE_SHOWHEADER then
        tempPosX = 0
        tempPosY = tempPosY + radiobtn:GetSizeY() + 10
      end
    end
  end
  PaGlobal_Menu_Remake._ui.stc_header_button_group:SetSize(maxSizeX, tempPosY)
  PaGlobal_Menu_Remake._ui.stc_topGroup:SetSize(PaGlobal_Menu_Remake._ui.stc_topGroup:GetSizeX(), PaGlobal_Menu_Remake._ui.stc_header_interface_group:GetSizeY() + PaGlobal_Menu_Remake._ui.stc_header_button_group:GetSizeY())
  PaGlobal_Menu_Remake._ui.stc_searchGroup:SetPosY(PaGlobal_Menu_Remake._ui.stc_topGroup:GetPosY() + PaGlobal_Menu_Remake._ui.stc_topGroup:GetSizeY())
  PaGlobal_Menu_Remake._ui.stc_header_button_group:ComputePos()
end
function PaGlobal_Menu_Remake:resetHeadMenuTitle()
  if true == PaGlobal_Menu_Remake._isCustomizeMode and 0 ~= PaGlobal_Menu_Remake._selected_customize_headerIndex then
    if nil ~= PaGlobal_Menu_Remake._headerHotKeyGroup[PaGlobal_Menu_Remake._selected_customize_headerIndex].title then
      PaGlobal_Menu_Remake._ui.stctxt_header_button_title:SetText(PaGlobal_Menu_Remake._headerHotKeyGroup[PaGlobal_Menu_Remake._selected_customize_headerIndex].title)
      PaGlobal_Menu_Remake._ui.stc_header_title_shape1:SetShow(true)
      PaGlobal_Menu_Remake._ui.stc_header_title_shape2:SetShow(true)
    else
      PaGlobal_Menu_Remake._ui.stctxt_header_button_title:SetText("")
      PaGlobal_Menu_Remake._ui.stc_header_title_shape1:SetShow(false)
      PaGlobal_Menu_Remake._ui.stc_header_title_shape2:SetShow(false)
    end
  end
end
function PaGlobal_Menu_Remake:setHighLight(mode)
  if nil == PaGlobal_Menu_Remake then
    return
  end
  for index, controlGroup in pairs(PaGlobal_Menu_Remake._headerHotKeyGroup) do
    controlGroup.highLight:SetShow(false)
  end
  PaGlobal_Menu_Remake._ui.stc_menu_highlight:SetShow(false)
  PaGlobal_Menu_Remake._ui.stc_submenu_highlight:SetShow(false)
  if true == PaGlobal_Menu_Remake._isCustomizeMode and nil ~= mode then
    if mode == "header" then
      for index, controlGroup in pairs(PaGlobal_Menu_Remake._headerHotKeyGroup) do
        controlGroup.highLight:SetShow(true)
      end
    elseif mode == "menu" then
      PaGlobal_Menu_Remake._ui.stc_menu_highlight:SetShow(true)
    elseif mode == "submenu" then
      PaGlobal_Menu_Remake._ui.stc_submenu_highlight:SetShow(true)
    end
  end
end
function PaGlobal_Menu_Remake:headMenu_toggle(headermenuIndex)
  if nil == PaGlobal_Menu_Remake then
    return
  end
  if nil == headermenuIndex or nil == PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex] then
    return
  end
  if true == PaGlobal_Menu_Remake._isCustomizeMode then
    if nil ~= PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex].title then
      PaGlobal_Menu_Remake._ui.stctxt_header_button_title:SetText(PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex].title)
      PaGlobal_Menu_Remake._ui.stc_header_title_shape1:SetShow(true)
      PaGlobal_Menu_Remake._ui.stc_header_title_shape2:SetShow(true)
    else
      PaGlobal_Menu_Remake._ui.stctxt_header_button_title:SetText("")
      PaGlobal_Menu_Remake._ui.stc_header_title_shape1:SetShow(false)
      PaGlobal_Menu_Remake._ui.stc_header_title_shape2:SetShow(false)
    end
    local textureUVOut = PaGlobal_Menu_Remake._headerGrid.normal
    local textureDDS = PaGlobal_Menu_Remake._headerGrid.ddsUrl
    for index, controlGroup in pairs(PaGlobal_Menu_Remake._headerHotKeyGroup) do
      controlGroup.radiobtn:ChangeTextureInfoName(textureDDS)
      local x1, y1, x2, y2 = setTextureUV_Func(controlGroup.radiobtn, textureUVOut.x1, textureUVOut.y1, textureUVOut.x2, textureUVOut.y2)
      controlGroup.radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      controlGroup.radiobtn:setRenderTexture(controlGroup.radiobtn:getBaseTexture())
    end
    local texureUVOn = PaGlobal_Menu_Remake._headerGrid.on
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex].radiobtn, texureUVOn.x1, texureUVOn.y1, texureUVOn.x2, texureUVOn.y2)
    PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex].radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex].radiobtn:setRenderTexture(PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex].radiobtn:getBaseTexture())
    if nil ~= PaGlobal_Menu_Remake._selected_customize_headerIndex and 0 ~= PaGlobal_Menu_Remake._selected_customize_headerIndex and nil ~= PaGlobal_Menu_Remake._headerHotKeyGroup[PaGlobal_Menu_Remake._selected_customize_headerIndex] then
      PaGlobal_Menu_Remake._headerHotKeyGroup[PaGlobal_Menu_Remake._selected_customize_headerIndex].radiobtn:SetCheck(true)
    end
  else
    local textureUVOut = PaGlobal_Menu_Remake._headerGrid.normal
    local textureDDS = PaGlobal_Menu_Remake._headerGrid.ddsUrl
    for index, controlGroup in pairs(PaGlobal_Menu_Remake._headerHotKeyGroup) do
      controlGroup.radiobtn:ChangeTextureInfoName(textureDDS)
      local x1, y1, x2, y2 = setTextureUV_Func(controlGroup.radiobtn, textureUVOut.x1, textureUVOut.y1, textureUVOut.x2, textureUVOut.y2)
      controlGroup.radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      controlGroup.radiobtn:setRenderTexture(controlGroup.radiobtn:getBaseTexture())
    end
    local texureUVOn = PaGlobal_Menu_Remake._headerGrid.on
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex].radiobtn, texureUVOn.x1, texureUVOn.y1, texureUVOn.x2, texureUVOn.y2)
    PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex].radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex].radiobtn:setRenderTexture(PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex].radiobtn:getBaseTexture())
    if nil ~= PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex].title then
      PaGlobal_Menu_Remake._ui.stctxt_header_button_title:SetText(PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex].title)
      PaGlobal_Menu_Remake._ui.stc_header_title_shape1:SetShow(true)
      PaGlobal_Menu_Remake._ui.stc_header_title_shape2:SetShow(true)
    else
      PaGlobal_Menu_Remake._ui.stctxt_header_button_title:SetText("")
      PaGlobal_Menu_Remake._ui.stc_header_title_shape1:SetShow(false)
      PaGlobal_Menu_Remake._ui.stc_header_title_shape2:SetShow(false)
    end
  end
  PaGlobal_Menu_Remake._nowMenuMode = "header"
  PaGlobal_Menu_Remake._nowMenuIndex = headermenuIndex
end
function PaGlobal_Menu_Remake:setMenuHotKey()
  local tempPosY = PaGlobal_Menu_Remake._ui.stc_topGroup:GetPosY() + PaGlobal_Menu_Remake._ui.stc_topGroup:GetSizeY() + PaGlobal_Menu_Remake._ui.stc_searchGroup:GetSizeY()
  PaGlobal_Menu_Remake._ui.stc_searchResultGroup:SetPosY(tempPosY - 1)
  PaGlobal_Menu_Remake._ui.stc_menuGroup:SetPosY(tempPosY)
  PaGlobal_Menu_Remake._ui.stc_submenu_BG:SetPosY(tempPosY - 1)
  PaGlobal_Menu_Remake._ui.stc_submenu_highlight:SetPosY(tempPosY)
  PaGlobal_Menu_Remake._ui.stc_menu_highlight:SetPosY(tempPosY)
  PaGlobal_Menu_Remake._ui.stc_searchResultGroup:SetSize(PaGlobal_Menu_Remake._ui.stc_searchResultGroup:GetSizeX(), getScreenSizeY() - PaGlobal_Menu_Remake._ui.stc_menuGroup:GetPosY())
  PaGlobal_Menu_Remake._ui.stc_menuGroup:SetSize(PaGlobal_Menu_Remake._ui.stc_menuGroup:GetSizeX(), getScreenSizeY() - PaGlobal_Menu_Remake._ui.stc_menuGroup:GetPosY())
  PaGlobal_Menu_Remake._ui.stc_menu_highlight:SetSize(PaGlobal_Menu_Remake._ui.stc_menu_highlight:GetSizeX(), PaGlobal_Menu_Remake._ui.stc_menuGroup:GetSizeY())
  PaGlobal_Menu_Remake._ui.stc_submenu_BG:SetSize(PaGlobal_Menu_Remake._ui.stc_submenu_BG:GetSizeX(), getScreenSizeY() - PaGlobal_Menu_Remake._ui.stc_menuGroup:GetPosY())
  PaGlobal_Menu_Remake._ui.stc_submenu_highlight:SetSize(PaGlobal_Menu_Remake._ui.stc_menu_highlight:GetSizeX(), PaGlobal_Menu_Remake._ui.stc_menuGroup:GetSizeY())
  PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:SetPosY(PaGlobal_Menu_Remake._ui.stc_submenu_BG:GetPosY() + (PaGlobal_Menu_Remake._ui.stc_submenu_BG:GetSizeY() - PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:GetSizeY()) / 2)
  tempPosY = 0
  for ii = 1, #PaGlobal_Menu_Remake._menuHotKey do
    if nil == PaGlobal_Menu_Remake._menuHotKey[ii].isContentOpen or true == PaGlobal_Menu_Remake._menuHotKey[ii].isContentOpen then
      if nil == PaGlobal_Menu_Remake._menuHotKeyGroup[ii] then
        do
          local radiobtn_menu_btn = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.stc_menuGroup, "RadioButton_Menu_Btn", PaGlobal_Menu_Remake._ui.stc_menuGroup, "RadioButton_Menu_Btn_" .. ii)
          local radiobtn_menu_icon = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.radiobtn_menu, "Static_Menu_Icon", radiobtn_menu_btn, "Static_Menu_Icon")
          local radiobtn_menu_hotkey = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.radiobtn_menu, "StaticText_Hotkey", radiobtn_menu_btn, "StaticText_Hotkey")
          local radiobtn_menu_title = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.radiobtn_menu, "StaticText_Title", radiobtn_menu_btn, "StaticText_Title")
          if nil ~= PaGlobal_Menu_Remake._menuHotKey[ii].hotKey then
            PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake._menuHotKey[ii].hotKey] = {}
            PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake._menuHotKey[ii].hotKey].func = nil
            PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake._menuHotKey[ii].hotKey].index = ii
            PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake._menuHotKey[ii].hotKey].type = "menu"
            local hotKeyString = PaGlobal_Menu_Remake._keyString[PaGlobal_Menu_Remake._menuHotKey[ii].hotKey]
            if nil ~= hotKeyString then
              radiobtn_menu_hotkey:SetText(hotKeyString)
            end
            radiobtn_menu_title:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
            radiobtn_menu_title:SetText(PaGlobal_Menu_Remake._menuHotKey[ii].title)
            local textureUV = PaGlobal_Menu_Remake._menuHotKey[ii].ddsGrid
            local textureDDS = PaGlobal_Menu_Remake._menuHotKey[ii].ddsUrl
            radiobtn_menu_icon:ChangeTextureInfoName(textureDDS)
            local x1, y1, x2, y2 = setTextureUV_Func(radiobtn_menu_icon, textureUV.x1, textureUV.y1, textureUV.x2, textureUV.y2)
            radiobtn_menu_icon:getBaseTexture():setUV(x1, y1, x2, y2)
            radiobtn_menu_icon:setRenderTexture(radiobtn_menu_icon:getBaseTexture())
            PaGlobal_Menu_Remake._menuHotKeyGroup[ii] = {}
            PaGlobal_Menu_Remake._menuHotKeyGroup[ii].radiobtn = radiobtn_menu_btn
            PaGlobal_Menu_Remake._menuHotKeyGroup[ii].title = radiobtn_menu_title
            PaGlobal_Menu_Remake._menuHotKeyGroup[ii].hotkey = radiobtn_menu_hotkey
            PaGlobal_Menu_Remake._menuHotKeyGroup[ii].icon = radiobtn_menu_icon
          end
        end
      else
      end
      if nil ~= PaGlobal_Menu_Remake._menuHotKeyGroup[ii] then
        local radiobtn = PaGlobal_Menu_Remake._menuHotKeyGroup[ii].radiobtn
        local title = PaGlobal_Menu_Remake._menuHotKeyGroup[ii].title
        local icon = PaGlobal_Menu_Remake._menuHotKeyGroup[ii].icon
        if true == _ContentsGroup_RenewUI then
          radiobtn:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "HandleEventPadUP_MenuRemake_Move(" .. __eConsoleUIPadEvent_DpadUp .. ")")
          radiobtn:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "HandleEventPadUP_MenuRemake_Move(" .. __eConsoleUIPadEvent_DpadDown .. ")")
          radiobtn:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "HandleEventPadUP_MenuRemake_Move(" .. __eConsoleUIPadEvent_DpadLeft .. ")")
          radiobtn:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "HandleEventPadUP_MenuRemake_Move(" .. __eConsoleUIPadEvent_DpadRight .. ")")
          radiobtn:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_Menu_Remake_PressedConfirm()")
        end
        local textureDDS = PaGlobal_Menu_Remake._menuGrid.ddsUrl
        local normalTextureUV = PaGlobal_Menu_Remake._menuGrid.normal
        local onTextureUV = PaGlobal_Menu_Remake._menuGrid.on
        local clickTextureUV = PaGlobal_Menu_Remake._menuGrid.click
        radiobtn:ChangeTextureInfoName(textureDDS)
        if nil ~= normalTextureUV then
          local x1, y1, x2, y2 = setTextureUV_Func(radiobtn, normalTextureUV.x1, normalTextureUV.y1, normalTextureUV.x2, normalTextureUV.y2)
          radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
          radiobtn:setRenderTexture(radiobtn:getBaseTexture())
        end
        if nil ~= onTextureUV then
          local x1, y1, x2, y2 = setTextureUV_Func(radiobtn, onTextureUV.x1, onTextureUV.y1, onTextureUV.x2, onTextureUV.y2)
          radiobtn:getOnTexture():setUV(x1, y1, x2, y2)
        end
        if nil ~= clickTextureUV then
          local x1, y1, x2, y2 = setTextureUV_Func(radiobtn, clickTextureUV.x1, clickTextureUV.y1, clickTextureUV.x2, clickTextureUV.y2)
          radiobtn:getClickTexture():setUV(x1, y1, x2, y2)
        end
        radiobtn:addInputEvent("Mouse_LUp", "HandleEventLUp_MenuRemake_Menu(" .. ii .. ")")
        radiobtn:addInputEvent("Mouse_On", "HandleEventOn_MenuRemake_Menu(" .. ii .. ")")
        radiobtn:SetPosY(tempPosY)
        tempPosY = tempPosY + radiobtn:GetSizeY()
      end
    end
  end
end
function PaGlobal_Menu_Remake:setSubmenu(menuIndex)
  if nil == menuIndex then
    PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(false)
    PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:SetShow(true)
    return
  end
  if nil == PaGlobal_Menu_Remake._menuHotKeyGroup[menuIndex] then
    PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(false)
    PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:SetShow(true)
    return
  end
  local menuHotKey = PaGlobal_Menu_Remake._menuHotKey[menuIndex]
  if nil == menuHotKey or nil == menuHotKey.subMenu then
    PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(false)
    PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:SetShow(true)
    return
  end
  PaGlobal_Menu_Remake._ui.stctxt_header_button_title:SetText("")
  PaGlobal_Menu_Remake._ui.stc_header_title_shape1:SetShow(false)
  PaGlobal_Menu_Remake._ui.stc_header_title_shape2:SetShow(false)
  local tempPosY = 0
  local addCnt = 0
  for ii = 1, PaGlobal_Menu_Remake._MAX_SUBMENU do
    PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberKeySetting[ii]] = {}
    PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberPadKeySetting[ii]] = {}
    if nil == PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii] then
      local radiobtn_menu_btn = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.stc_subMenuGroup, "RadioButton_SubMenu", PaGlobal_Menu_Remake._ui.stc_subMenuGroup, "RadioButton_SubMenu" .. ii)
      local radiobtn_menu_icon = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.radiobtn_sub_menu, "Static_SubMenu_Icon", radiobtn_menu_btn, "Static_SubMenu_Icon")
      local radiobtn_menu_numIcon = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.radiobtn_sub_menu, "StaticText_SubMenu_KeyIcon", radiobtn_menu_btn, "StaticText_SubMenu_KeyIcon")
      local radiobtn_menu_title = UI.createAndCopyBasePropertyControl(PaGlobal_Menu_Remake._ui.radiobtn_sub_menu, "StaticText_Title", radiobtn_menu_btn, "StaticText_Title")
      radiobtn_menu_title:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii] = {}
      PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii].radiobtn = radiobtn_menu_btn
      PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii].icon = radiobtn_menu_icon
      PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii].numIcon = radiobtn_menu_numIcon
      PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii].title = radiobtn_menu_title
    end
    local numIcon = PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii].numIcon
    local icon = PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii].icon
    local radiobtn = PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii].radiobtn
    local title = PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii].title
    if ii <= #menuHotKey.subMenu then
      if nil == menuHotKey.subMenu[ii].isContentOpen or true == menuHotKey.subMenu[ii].isContentOpen then
        if nil ~= menuHotKey.subMenu[ii].func then
          if true == _ContentsGroup_RenewUI then
            radiobtn:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "HandleEventPadUP_MenuRemake_Move(" .. __eConsoleUIPadEvent_DpadUp .. ")")
            radiobtn:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "HandleEventPadUP_MenuRemake_Move(" .. __eConsoleUIPadEvent_DpadDown .. ")")
            radiobtn:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "HandleEventPadUP_MenuRemake_Move(" .. __eConsoleUIPadEvent_DpadLeft .. ")")
            radiobtn:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "HandleEventPadUP_MenuRemake_Move(" .. __eConsoleUIPadEvent_DpadRight .. ")")
            radiobtn:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_Menu_Remake_PressedConfirm()")
          end
          addCnt = addCnt + 1
          PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberKeySetting[addCnt]] = {}
          PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberPadKeySetting[addCnt]] = {}
          PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberKeySetting[addCnt]].func = menuHotKey.subMenu[ii].func
          PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberKeySetting[addCnt]].index = ii
          PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberKeySetting[addCnt]].type = "submenu"
          PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberPadKeySetting[addCnt]].func = menuHotKey.subMenu[ii].func
          PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberPadKeySetting[addCnt]].index = ii
          PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberPadKeySetting[addCnt]].type = "submenu"
          radiobtn:addInputEvent("Mouse_On", "HandleEventOn_MenuRemake_subMenu(" .. addCnt .. ")")
          radiobtn:SetShow(true)
          numIcon:SetText(addCnt)
          title:SetText(menuHotKey.subMenu[ii].title)
          radiobtn:addInputEvent("Mouse_LUp", "HandleEventLUp_MenuRemake_subMenu(" .. ii .. ")")
          local textureUV = menuHotKey.subMenu[ii].ddsGrid
          local textureDDS = menuHotKey.subMenu[ii].ddsUrl
          if nil ~= textureUV and nil ~= textureDDS then
            icon:ChangeTextureInfoName(textureDDS)
            local x1, y1, x2, y2 = setTextureUV_Func(icon, textureUV.x1, textureUV.y1, textureUV.x2, textureUV.y2)
            icon:getBaseTexture():setUV(x1, y1, x2, y2)
            icon:setRenderTexture(icon:getBaseTexture())
          else
            icon:ChangeTextureInfoName("")
            icon:setRenderTexture(icon:getBaseTexture())
          end
          if nil == menuHotKey.subMenu[ii].isConditionOpen or true == menuHotKey.subMenu[ii].isConditionOpen then
            radiobtn:SetIgnore(false)
            icon:SetMonoTone(false)
            title:SetFontColor(UI_color.C_FFDDC39E)
          else
            radiobtn:SetIgnore(true)
            icon:SetMonoTone(true)
            title:SetFontColor(UI_color.C_FF888888)
          end
          radiobtn:SetPosY(tempPosY)
          tempPosY = tempPosY + radiobtn:GetSizeY() + 10
        else
          radiobtn:addInputEvent("Mouse_LUp", "")
          radiobtn:SetShow(false)
        end
      else
        radiobtn:addInputEvent("Mouse_LUp", "")
        radiobtn:SetShow(false)
      end
    else
      radiobtn:SetShow(false)
    end
  end
  menuHotKey.submenuCnt = addCnt
  PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetSize(PaGlobal_Menu_Remake._ui.stc_subMenuGroup:GetSizeX(), tempPosY - 10)
  local defaultPosY = PaGlobal_Menu_Remake._ui.stc_searchGroup:GetPosY() + PaGlobal_Menu_Remake._ui.stc_searchGroup:GetSizeY()
  local menuPosY = PaGlobal_Menu_Remake._menuHotKeyGroup[menuIndex].radiobtn:GetPosY()
  if defaultPosY + menuPosY + PaGlobal_Menu_Remake._ui.stc_subMenuGroup:GetSizeY() < getScreenSizeY() then
    PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetPosY(defaultPosY + menuPosY)
  else
    PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetPosY(defaultPosY + menuPosY + PaGlobal_Menu_Remake._ui.radiobtn_menu:GetSizeY() - PaGlobal_Menu_Remake._ui.stc_subMenuGroup:GetSizeY())
  end
end
function PaGlobal_Menu_Remake:headMenu_select(headermenuIndex)
  local headerMenuGroup = PaGlobal_Menu_Remake._headerHotKey[headermenuIndex]
  local headerMenuKeyGroup = PaGlobal_Menu_Remake._headerHotKeyGroup[headermenuIndex]
  if nil == headermenuIndex then
    return
  end
  if nil == headerMenuKeyGroup then
    return
  end
  if false == PaGlobal_Menu_Remake._isCustomizeMode then
    headerMenuKeyGroup.radiobtn:SetCheck(false)
    if nil == headerMenuGroup then
      if nil ~= headerMenuKeyGroup.isNoSetting and true == headerMenuKeyGroup.isNoSetting then
        PaGlobal_Menu_Remake._isCustomizeMode = true
        PaGlobal_Menu_Remake:setCustomize_menu(true)
        PaGlobal_Menu_Remake:resetMenu()
        PaGlobal_Menu_Remake:headMenu_select(headermenuIndex)
      end
      return
    elseif nil == headerMenuGroup.func then
      return
    end
    if nil == headerMenuGroup.isConditionOpen or true == headerMenuGroup.isConditionOpen then
      headerMenuGroup.func()
      PaGlobal_Menu_Remake:prepareClose()
    end
  else
    local textureUVOut = PaGlobal_Menu_Remake._headerGrid.normal
    local textureDDS = PaGlobal_Menu_Remake._headerGrid.ddsUrl
    for index, controlGroup in pairs(PaGlobal_Menu_Remake._headerHotKeyGroup) do
      controlGroup.radiobtn:ChangeTextureInfoName(textureDDS)
      local x1, y1, x2, y2 = setTextureUV_Func(controlGroup.radiobtn, textureUVOut.x1, textureUVOut.y1, textureUVOut.x2, textureUVOut.y2)
      controlGroup.radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      controlGroup.radiobtn:setRenderTexture(controlGroup.radiobtn:getBaseTexture())
    end
    textureUVOut = PaGlobal_Menu_Remake._menuGrid.normal
    for index, controlGroup in pairs(PaGlobal_Menu_Remake._menuHotKeyGroup) do
      if nil ~= controlGroup and nil ~= controlGroup.radiobtn then
        local x1, y1, x2, y2 = setTextureUV_Func(controlGroup.radiobtn, textureUVOut.x1, textureUVOut.y1, textureUVOut.x2, textureUVOut.y2)
        controlGroup.radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
        controlGroup.radiobtn:setRenderTexture(controlGroup.radiobtn:getBaseTexture())
        controlGroup.radiobtn:SetCheck(false)
      end
    end
    PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(false)
    PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:SetShow(true)
    headerMenuKeyGroup.radiobtn:SetCheck(true)
    PaGlobal_Menu_Remake._selected_customize_headerIndex = headermenuIndex
    PaGlobal_Menu_Remake:setHighLight("menu")
  end
end
function PaGlobal_Menu_Remake:menu_toggle(menuIndex, isOn)
  if nil == menuIndex then
    return
  end
  if nil == PaGlobal_Menu_Remake._menuHotKeyGroup[menuIndex] then
    return
  end
  if false == PaGlobal_Menu_Remake._isCustomizeMode then
    PaGlobal_Menu_Remake._ui.stctxt_header_button_title:SetText("")
    PaGlobal_Menu_Remake._ui.stc_header_title_shape1:SetShow(false)
    PaGlobal_Menu_Remake._ui.stc_header_title_shape2:SetShow(false)
    local headertextureUVOut = PaGlobal_Menu_Remake._headerGrid.normal
    local headertextureDDS = PaGlobal_Menu_Remake._headerGrid.ddsUrl
    for index, controlGroup in pairs(PaGlobal_Menu_Remake._headerHotKeyGroup) do
      controlGroup.radiobtn:ChangeTextureInfoName(headertextureDDS)
      local x1, y1, x2, y2 = setTextureUV_Func(controlGroup.radiobtn, headertextureUVOut.x1, headertextureUVOut.y1, headertextureUVOut.x2, headertextureUVOut.y2)
      controlGroup.radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      controlGroup.radiobtn:setRenderTexture(controlGroup.radiobtn:getBaseTexture())
    end
  end
  local textureUVOn = PaGlobal_Menu_Remake._menuGrid.on
  local textureUVOut = PaGlobal_Menu_Remake._menuGrid.normal
  local textureDDS = PaGlobal_Menu_Remake._menuGrid.ddsUrl
  for index, controlGroup in pairs(PaGlobal_Menu_Remake._menuHotKeyGroup) do
    if index ~= PaGlobal_Menu_Remake._nowSelectedMenuIndex then
      controlGroup.radiobtn:ChangeTextureInfoName(textureDDS)
      local x1, y1, x2, y2 = setTextureUV_Func(controlGroup.radiobtn, textureUVOut.x1, textureUVOut.y1, textureUVOut.x2, textureUVOut.y2)
      controlGroup.radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      controlGroup.radiobtn:setRenderTexture(controlGroup.radiobtn:getBaseTexture())
    end
  end
  if true == isOn and (false == PaGlobal_Menu_Remake._isCustomizeMode or 0 ~= PaGlobal_Menu_Remake._selected_customize_headerIndex) then
    if menuIndex ~= PaGlobal_Menu_Remake._nowSelectedMenuIndex then
      PaGlobal_Menu_Remake._menuHotKeyGroup[menuIndex].radiobtn:ChangeTextureInfoName(textureDDS)
      local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._menuHotKeyGroup[menuIndex].radiobtn, textureUVOn.x1, textureUVOn.y1, textureUVOn.x2, textureUVOn.y2)
      PaGlobal_Menu_Remake._menuHotKeyGroup[menuIndex].radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      PaGlobal_Menu_Remake._menuHotKeyGroup[menuIndex].radiobtn:setRenderTexture(PaGlobal_Menu_Remake._menuHotKeyGroup[menuIndex].radiobtn:getBaseTexture())
    end
    PaGlobal_Menu_Remake._nowMenuMode = "menu"
    PaGlobal_Menu_Remake._nowMenuIndex = menuIndex
  end
end
function PaGlobal_Menu_Remake:menu_select(menuIndex)
  if nil == menuIndex then
    PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(false)
    PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:SetShow(true)
    return
  end
  if nil == PaGlobal_Menu_Remake._menuHotKeyGroup[menuIndex] then
    PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(false)
    PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:SetShow(true)
    return
  end
  local menuHotKey = PaGlobal_Menu_Remake._menuHotKey[menuIndex]
  local menuHotKeyBtnGroup = PaGlobal_Menu_Remake._menuHotKeyGroup[menuIndex]
  local textureUV = PaGlobal_Menu_Remake._menuGrid.normal
  if true == PaGlobal_Menu_Remake._isCustomizeMode and (nil == PaGlobal_Menu_Remake._selected_customize_headerIndex or 0 == PaGlobal_Menu_Remake._selected_customize_headerIndex) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_ALERT_BEFOREMENU"))
    if nil ~= menuHotKeyBtnGroup.radiobtn then
      menuHotKeyBtnGroup.radiobtn:SetCheck(false)
      local x1, y1, x2, y2 = setTextureUV_Func(menuHotKeyBtnGroup.radiobtn, textureUV.x1, textureUV.y1, textureUV.x2, textureUV.y2)
      menuHotKeyBtnGroup.radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      menuHotKeyBtnGroup.radiobtn:setRenderTexture(menuHotKeyBtnGroup.radiobtn:getBaseTexture())
    end
    return
  end
  if nil == menuHotKey.subMenu then
    PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(false)
    PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:SetShow(true)
  else
    for ii = 1, #PaGlobal_Menu_Remake._menuHotKeyGroup do
      if nil ~= PaGlobal_Menu_Remake._menuHotKeyGroup[ii] and nil ~= PaGlobal_Menu_Remake._menuHotKeyGroup[ii].radiobtn then
        PaGlobal_Menu_Remake._menuHotKeyGroup[ii].radiobtn:SetCheck(false)
        local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._menuHotKeyGroup[ii].radiobtn, textureUV.x1, textureUV.y1, textureUV.x2, textureUV.y2)
        PaGlobal_Menu_Remake._menuHotKeyGroup[ii].radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
        PaGlobal_Menu_Remake._menuHotKeyGroup[ii].radiobtn:setRenderTexture(PaGlobal_Menu_Remake._menuHotKeyGroup[ii].radiobtn:getBaseTexture())
      end
    end
    if nil ~= menuHotKeyBtnGroup.radiobtn then
      menuHotKeyBtnGroup.radiobtn:SetCheck(true)
      PaGlobal_Menu_Remake._selectMenuIndex = menuIndex
      PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(true)
      PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:SetShow(false)
      PaGlobal_Menu_Remake:setSubmenu(menuIndex)
      PaGlobal_Menu_Remake:submenu_toggle(1, true)
    else
      PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(false)
      PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:SetShow(true)
    end
  end
  PaGlobal_Menu_Remake._nowMenuMode = "submenu"
  PaGlobal_Menu_Remake._nowMenuIndex = 1
  PaGlobal_Menu_Remake._nowSelectedMenuIndex = menuIndex
  PaGlobal_Menu_Remake:setHighLight("submenu")
end
function PaGlobal_Menu_Remake:submenu_toggle(submenuIndex, isOn)
  local textureUVOn = PaGlobal_Menu_Remake._subMenuGrid.on
  local textureUVOut = PaGlobal_Menu_Remake._subMenuGrid.normal
  local textureDDS = PaGlobal_Menu_Remake._subMenuGrid.ddsUrl
  for ii = 1, PaGlobal_Menu_Remake._MAX_SUBMENU do
    if nil ~= PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii] then
      PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii].radiobtn:ChangeTextureInfoName(textureDDS)
      local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii].radiobtn, textureUVOut.x1, textureUVOut.y1, textureUVOut.x2, textureUVOut.y2)
      PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii].radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii].radiobtn:setRenderTexture(PaGlobal_Menu_Remake._subMenuHotKeyGroup[ii].radiobtn:getBaseTexture())
    end
  end
  if true == isOn and nil ~= PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberKeySetting[submenuIndex]] then
    local submenuGroupIndex = PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberKeySetting[submenuIndex]].index
    if nil ~= submenuGroupIndex and nil ~= PaGlobal_Menu_Remake._subMenuHotKeyGroup[submenuGroupIndex] then
      PaGlobal_Menu_Remake._nowMenuMode = "submenu"
      PaGlobal_Menu_Remake._nowMenuIndex = submenuIndex
      PaGlobal_Menu_Remake._subMenuHotKeyGroup[submenuGroupIndex].radiobtn:ChangeTextureInfoName(textureDDS)
      local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._subMenuHotKeyGroup[submenuGroupIndex].radiobtn, textureUVOn.x1, textureUVOn.y1, textureUVOn.x2, textureUVOn.y2)
      PaGlobal_Menu_Remake._subMenuHotKeyGroup[submenuGroupIndex].radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      PaGlobal_Menu_Remake._subMenuHotKeyGroup[submenuGroupIndex].radiobtn:setRenderTexture(PaGlobal_Menu_Remake._subMenuHotKeyGroup[submenuGroupIndex].radiobtn:getBaseTexture())
    end
  end
end
function PaGlobal_Menu_Remake:submenu_select(submenuIndex)
  if nil == PaGlobal_Menu_Remake._selectMenuIndex or nil == submenuIndex then
    return
  end
  local menuHotKey = PaGlobal_Menu_Remake._menuHotKey[PaGlobal_Menu_Remake._selectMenuIndex]
  if nil == menuHotKey then
    return
  end
  local subMenuGroup = menuHotKey.subMenu[submenuIndex]
  if nil == subMenuGroup or nil == subMenuGroup.func then
    return
  end
  if nil ~= subMenuGroup.isConditionOpen and false == subMenuGroup.isConditionOpen then
    return
  end
  if false == PaGlobal_Menu_Remake._isCustomizeMode then
    subMenuGroup.func()
    PaGlobal_Menu_Remake:prepareClose()
  else
    for index = 1, PaGlobal_Menu_Remake._MAX_HEADERMENU do
      if nil ~= PaGlobal_Menu_Remake._headerHotKey[index] and subMenuGroup.index == PaGlobal_Menu_Remake._headerHotKey[index].index then
        PaGlobal_Menu_Remake._headerHotKey[index] = nil
      end
    end
    PaGlobal_Menu_Remake._headerHotKey[PaGlobal_Menu_Remake._selected_customize_headerIndex] = PaGlobal_Menu_Remake:GetMenuInfo(subMenuGroup.index)
    PaGlobal_Menu_Remake:setHeaderHotKey()
  end
end
function PaGlobal_Menu_Remake_Customize_Reset()
  PaGlobal_Menu_Remake._isCustomizeMode = false
  PaGlobal_Menu_Remake:setCustomize_menu(PaGlobal_Menu_Remake._isCustomizeMode)
  PaGlobal_Menu_Remake:resetMenu()
end
function PaGlobal_Menu_Remake:headmenuCustomize_confirm()
  for index = 1, PaGlobal_Menu_Remake._MAX_HEADERMENU do
    if nil ~= PaGlobal_Menu_Remake._headerHotKey[index] and nil ~= PaGlobal_Menu_Remake._headerHotKey[index].index then
      ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(PaGlobal_Menu_Remake.UIOPTION_TYPE_MENU[index], PaGlobal_Menu_Remake._headerHotKey[index].index, CppEnums.VariableStorageType.eVariableStorageType_User)
    else
      ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(PaGlobal_Menu_Remake.UIOPTION_TYPE_MENU[index], 999, CppEnums.VariableStorageType.eVariableStorageType_User)
    end
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_ALERT_COMPLETE_MESSAGE"))
  PaGlobal_Menu_Remake_Customize_Reset()
end
function PaGlobal_Menu_Remake:headmenuCustomize_cancel()
  PaGlobal_Menu_Remake_Customize_Reset()
end
function PaGlobal_Menu_Remake:registEventHandler()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake._CONFIRM_KEY] = {}
  PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake._CONFIRM_KEY].func = PaGlobal_Menu_Remake_PressedConfirm
  PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake._CONFIRM_KEY].index = 0
  PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake._CONFIRM_KEY].type = "confirmKey"
  PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake._SEARCH_KEY] = {}
  PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake._SEARCH_KEY].func = PaGlobal_Menu_Remake_ToggleSearchMode
  PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake._SEARCH_KEY].index = 0
  PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake._SEARCH_KEY].type = "confirmKey"
  for index, key in pairs(PaGlobal_Menu_Remake._ARROW_KEY) do
    PaGlobal_Menu_Remake._hotKeyFunction[key] = {}
    PaGlobal_Menu_Remake._hotKeyFunction[key].func = HandleEventKeyBoard_MenuRemake_arrowKey
    PaGlobal_Menu_Remake._hotKeyFunction[key].index = 0
    PaGlobal_Menu_Remake._hotKeyFunction[key].type = "arrowKey"
  end
  Panel_Widget_Menu_Remake:RegisterShowEventFunc(true, "PaGlobal_Menu_Remake:ShowAni()")
  Panel_Widget_Menu_Remake:RegisterShowEventFunc(false, "PaGlobal_Menu_Remake:HideAni()")
  PaGlobal_Menu_Remake._ui.btn_changeUi:addInputEvent("Mouse_LUp", "PaGlobal_Menu_Remake_MenuChange()")
  PaGlobal_Menu_Remake._ui.btn_changeUi:addInputEvent("Mouse_On", "HandleEventOn_MenuRemake_ChangeUi()")
  PaGlobal_Menu_Remake._ui.btn_changeUi:addInputEvent("Mouse_Out", "PaGlobal_Menu_Remake_HideToolTip()")
  PaGlobal_Menu_Remake._ui.btn_openway:addInputEvent("Mouse_LUp", "HandleEventLUp_MenuRemake_ChangeOpenWay()")
  PaGlobal_Menu_Remake._ui.btn_openway:addInputEvent("Mouse_On", "HandleEventOn_MenuRemake_ChangeOpenWay()")
  PaGlobal_Menu_Remake._ui.btn_openway:addInputEvent("Mouse_Out", "PaGlobal_Menu_Remake_HideToolTip()")
  PaGlobal_Menu_Remake._ui.btn_customizeUi:addInputEvent("Mouse_LUp", "HandleEventLUp_MenuRemake_ChangeCustomizeMode()")
  PaGlobal_Menu_Remake._ui.btn_customizeUi:addInputEvent("Mouse_On", "HandleEventOn_MenuRemake_ChangeCustomizeMode()")
  PaGlobal_Menu_Remake._ui.btn_customizeUi:addInputEvent("Mouse_Out", "PaGlobal_Menu_Remake_HideToolTip()")
  PaGlobal_Menu_Remake._ui.btn_cancel:addInputEvent("Mouse_LUp", "HandleEventLUp_MenuRemake_Cancel()")
  PaGlobal_Menu_Remake._ui.btn_commit:addInputEvent("Mouse_LUp", "HandleEventLUp_MenuRemake_Commit()")
  PaGlobal_Menu_Remake._ui.edit_searchTxt:addInputEvent("Mouse_LUp", "HandleEventLUp_MenuRemake_searchText()")
  PaGlobal_Menu_Remake._ui.edit_searchTxt:RegistReturnKeyEvent("HandleEventKeyBoard_MenuRemake_searchingMenu()")
  registerEvent("onScreenResize", "FromClient_Menu_Remake_OnScreenResize")
  if true == _ContentsGroup_RenewUI then
    Panel_Widget_Menu_Remake:ignorePadSnapMoveToOtherPanel()
  end
end
function PaGlobal_Menu_Remake:showCustomizeToolTip()
  if true == PaGlobal_Menu_Remake._isCustomizeMode then
    TooltipSimple_Show(PaGlobal_Menu_Remake._ui.btn_customizeUi, PAGetString(Defines.StringSheet_GAME, "LUA_MENU_EDITCLOSE"))
  else
    TooltipSimple_Show(PaGlobal_Menu_Remake._ui.btn_customizeUi, PAGetString(Defines.StringSheet_GAME, "LUA_MENU_DOEDIT"))
  end
end
function PaGlobal_Menu_Remake_HideToolTip()
  PaGlobal_Menu_Remake:hideTooltip()
end
function PaGlobal_Menu_Remake:hideTooltip()
  TooltipSimple_Hide()
end
function PaGlobal_Menu_Remake_PressedConfirm()
  if PaGlobal_Menu_Remake._nowMenuMode == nil or PaGlobal_Menu_Remake._nowMenuMode == "" then
    return
  end
  if PaGlobal_Menu_Remake._nowMenuIndex == nil or PaGlobal_Menu_Remake._nowMenuIndex == 0 then
    return
  end
  if PaGlobal_Menu_Remake._nowMenuMode == "header" then
    PaGlobal_Menu_Remake:headMenu_select(PaGlobal_Menu_Remake._nowMenuIndex)
  elseif PaGlobal_Menu_Remake._nowMenuMode == "menu" then
    PaGlobal_Menu_Remake:menu_select(PaGlobal_Menu_Remake._nowMenuIndex)
  elseif PaGlobal_Menu_Remake._nowMenuMode == "submenu" then
    local submenuGroupIndex = PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberKeySetting[PaGlobal_Menu_Remake._nowMenuIndex]].index
    PaGlobal_Menu_Remake:submenu_select(submenuGroupIndex)
  elseif PaGlobal_Menu_Remake._nowMenuMode == "search" then
    PaGlobal_Menu_Remake:searchMenu_select(PaGlobal_Menu_Remake._nowMenuIndex)
  end
end
function PaGlobal_Menu_Remake:ShowAni()
  PaGlobal_Menu_Remake._isLeft = 0 == ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eMenuOpenWay)
  if true == PaGlobal_Menu_Remake._isLeft then
    local ImageMoveAni = Panel_Widget_Menu_Remake:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    ImageMoveAni:SetStartPosition(0 - Panel_Widget_Menu_Remake:GetSizeX(), 0)
    ImageMoveAni:SetEndPosition(0, 0)
    ImageMoveAni.IsChangeChild = true
    Panel_Widget_Menu_Remake:CalcUIAniPos(ImageMoveAni)
    ImageMoveAni:SetDisableWhileAni(true)
    ImageMoveAni:SetIgnoreUpdateSnapping(true)
  else
    local ImageMoveAni = Panel_Widget_Menu_Remake:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    ImageMoveAni:SetStartPosition(getScreenSizeX(), 0)
    ImageMoveAni:SetEndPosition(getScreenSizeX() - Panel_Widget_Menu_Remake:GetSizeX(), 0)
    ImageMoveAni.IsChangeChild = true
    Panel_Widget_Menu_Remake:CalcUIAniPos(ImageMoveAni)
    ImageMoveAni:SetDisableWhileAni(true)
    ImageMoveAni:SetIgnoreUpdateSnapping(true)
  end
end
function PaGlobal_Menu_Remake:HideAni()
  local ImageMoveAni = Panel_Widget_Menu_Remake:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni:SetStartPosition(Panel_Widget_Menu_Remake:GetPosX(), 0)
  if Panel_Widget_Menu_Remake:GetPosX() < getScreenSizeX() / 2 then
    ImageMoveAni:SetEndPosition(0 - Panel_Widget_Menu_Remake:GetSizeX(), 0)
  else
    ImageMoveAni:SetEndPosition(getScreenSizeX(), 0)
  end
  ImageMoveAni.IsChangeChild = true
  Panel_Widget_Menu_Remake:CalcUIAniPos(ImageMoveAni)
  ImageMoveAni:SetDisableWhileAni(true)
  ImageMoveAni:SetHideAtEnd(true)
  ImageMoveAni:SetDisableWhileAni(true)
  ImageMoveAni:SetIgnoreUpdateSnapping(true)
end
function PaGlobal_Menu_Remake:prepareOpen()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake:setCustomize_menu(false)
  PaGlobal_Menu_Remake:resetMenu()
  PaGlobal_Menu_Remake:headMenu_toggle(1)
  PaGlobal_Menu_Remake:open()
  if true == _ContentsGroup_RenewUI then
    ToClient_padSnapResetControl()
  end
end
function PaGlobal_Menu_Remake:open()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  Panel_Widget_Menu_Remake:SetShow(true, true)
end
function PaGlobal_Menu_Remake:menuCustomize_toggle()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake._isCustomizeMode = not PaGlobal_Menu_Remake._isCustomizeMode
  PaGlobal_Menu_Remake._selected_customize_headerIndex = 0
  PaGlobal_Menu_Remake:setCustomize_menu(PaGlobal_Menu_Remake._isCustomizeMode)
  PaGlobal_Menu_Remake:resetMenu()
end
function PaGlobal_Menu_Remake:setCustomize_menu(isMode)
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake._ui.stctxt_header_button_title:SetText("")
  PaGlobal_Menu_Remake._ui.stc_header_title_shape1:SetShow(false)
  PaGlobal_Menu_Remake._ui.stc_header_title_shape2:SetShow(false)
  PaGlobal_Menu_Remake._ui.stctxt_customize_desc:SetShow(isMode)
  PaGlobal_Menu_Remake:setMenuGrid(isMode)
  PaGlobal_Menu_Remake:setHighLight("header")
  PaGlobal_Menu_Remake._ui.btn_customizeUi:SetShow(not isMode)
  PaGlobal_Menu_Remake._ui.btn_openway:SetShow(not isMode)
  PaGlobal_Menu_Remake._ui.btn_changeUi:SetShow(not isMode)
  PaGlobal_Menu_Remake._ui.btn_cancel:SetShow(isMode)
  PaGlobal_Menu_Remake._ui.btn_commit:SetShow(isMode)
  if true == isMode then
    local textureDDS = PaGlobal_Menu_Remake._headerTitleGrid.ddsUrl
    local textureUV = PaGlobal_Menu_Remake._headerTitleGrid.customize
    PaGlobal_Menu_Remake._ui.stc_header_interface_group:ChangeTextureInfoName(textureDDS)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._ui.stc_header_interface_group, textureUV.x1, textureUV.y1, textureUV.x2, textureUV.y2)
    PaGlobal_Menu_Remake._ui.stc_header_interface_group:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_Menu_Remake._ui.stc_header_interface_group:setRenderTexture(PaGlobal_Menu_Remake._ui.stc_header_interface_group:getBaseTexture())
    for index, controlGroup in pairs(PaGlobal_Menu_Remake._headerHotKeyGroup) do
    end
  else
    local textureDDS = PaGlobal_Menu_Remake._headerTitleGrid.ddsUrl
    local textureUV = PaGlobal_Menu_Remake._headerTitleGrid.normal
    PaGlobal_Menu_Remake._ui.stc_header_interface_group:ChangeTextureInfoName(textureDDS)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._ui.stc_header_interface_group, textureUV.x1, textureUV.y1, textureUV.x2, textureUV.y2)
    PaGlobal_Menu_Remake._ui.stc_header_interface_group:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_Menu_Remake._ui.stc_header_interface_group:setRenderTexture(PaGlobal_Menu_Remake._ui.stc_header_interface_group:getBaseTexture())
    for index, controlGroup in pairs(PaGlobal_Menu_Remake._headerHotKeyGroup) do
    end
  end
end
function PaGlobal_Menu_Remake:prepareClose()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake._selectMenuIndex = 0
  for ii = 1, PaGlobal_Menu_Remake._MAX_SUBMENU do
    PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberKeySetting[ii]] = {}
    PaGlobal_Menu_Remake._hotKeyFunction[PaGlobal_Menu_Remake.numberPadKeySetting[ii]] = {}
  end
  PaGlobal_Menu_Remake._isCustomizeMode = false
  PaGlobal_Menu_Remake:setCustomize_menu(PaGlobal_Menu_Remake._isCustomizeMode)
  PaGlobal_Menu_Remake._selected_customize_headerIndex = 0
  PaGlobal_Menu_Remake:close()
end
function PaGlobal_Menu_Remake:close()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  Panel_Widget_Menu_Remake:SetShow(false, true)
end
function PaGlobal_Menu_Remake:update()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
end
function PaGlobal_Menu_Remake_ShowToggle()
  local isShow = Panel_Widget_Menu_Remake:GetShow()
  if false == isShow then
    PaGlobal_Menu_Remake:prepareOpen()
  else
    PaGlobal_Menu_Remake:prepareClose()
  end
  return isShow
end
function PaGlobal_Menu_Remake_MenuChange()
  PaGlobal_Menu_Remake_Close()
  PaGlobal_Menu_Remake:prepareClose()
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMenuType, 1, CppEnums.VariableStorageType.eVariableStorageType_User)
  Panel_Menu_ShowToggle()
end
function PaGlobal_Menu_Remake:checkPressedHotKey()
  if true == isKeyPressed(CppEnums.VirtualKeyCode.KeyCode_MENU) then
    return false
  end
  for index, funcGroup in pairs(PaGlobal_Menu_Remake._hotKeyFunction) do
    if true == GlobalKeyBinder_CheckKeyPressed(index) then
      setUiInputProcessed(index)
      if nil ~= funcGroup and nil ~= funcGroup.index and nil ~= funcGroup.type then
        if funcGroup.type == "menu" then
          HandleEventLUp_MenuRemake_Menu(funcGroup.index)
        elseif funcGroup.type == "confirmKey" then
          if nil ~= funcGroup.func then
            funcGroup.func()
          end
        elseif funcGroup.type == "arrowKey" then
          if nil ~= funcGroup.func then
            funcGroup.func(index)
          end
        elseif funcGroup.type == "submenu" then
          if nil ~= funcGroup.func then
            PaGlobal_Menu_Remake:submenu_select(funcGroup.index)
          end
        elseif funcGroup.type == "search" then
          if nil ~= funcGroup.func then
            PaGlobal_Menu_Remake:searchMenu_select(funcGroup.index)
          end
        else
          if nil ~= funcGroup.func then
            funcGroup.func()
          end
          PaGlobal_Menu_Remake:prepareClose()
        end
        return true
      end
    end
  end
  return false
end
function PaGlobal_Menu_Remake:setBeforeSearch()
  PaGlobal_Menu_Remake._searchResult = {}
  PaGlobal_Menu_Remake._ui.edit_searchTxt:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_SEARCHTEXT"))
  PaGlobal_Menu_Remake._ui.stc_searchResultGroup:SetShow(false)
  PaGlobal_Menu_Remake._ui.stc_menuGroup:SetShow(true)
  PaGlobal_Menu_Remake._ui.stc_submenu_BG:SetShow(true)
  ClearFocusEdit()
  if nil ~= PaGlobal_Menu_Remake._beforeSearchMenuMode and nil ~= PaGlobal_Menu_Remake._beforeSearchSelectedMenuIndex then
    PaGlobal_Menu_Remake:menu_toggle(PaGlobal_Menu_Remake._beforeSearchSelectedMenuIndex, false)
    if "header" == PaGlobal_Menu_Remake._beforeSearchMenuMode then
      PaGlobal_Menu_Remake:headMenu_toggle(PaGlobal_Menu_Remake._beforeSearchSelectedMenuIndex)
    elseif "menu" == PaGlobal_Menu_Remake._beforeSearchMenuMode then
      PaGlobal_Menu_Remake:menu_toggle(PaGlobal_Menu_Remake._beforeSearchSelectedMenuIndex, true)
    elseif "submenu" == PaGlobal_Menu_Remake._beforeSearchMenuMode then
      PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(true)
      PaGlobal_Menu_Remake:menu_select(PaGlobal_Menu_Remake._beforeSelectedMenuIndex)
      PaGlobal_Menu_Remake:submenu_toggle(PaGlobal_Menu_Remake._beforeSearchSelectedMenuIndex, true)
    end
  end
end
function PaGlobal_Menu_Remake_Close()
  if true == PaGlobal_Menu_Remake._ui.stc_searchResultGroup:GetShow() then
    PaGlobal_Menu_Remake:setBeforeSearch()
    return
  end
  if true == PaGlobal_Menu_Remake._isCustomizeMode then
    PaGlobal_Menu_Remake:headmenuCustomize_cancel()
    return
  end
  PaGlobal_Menu_Remake:prepareClose()
end
function PaGlobal_Menu_Remake_GetShow()
  return Panel_Widget_Menu_Remake:GetShow()
end
function PaGlobal_Menu_Remake:resetMenu()
  PaGlobal_Menu_Remake:resizeMenu()
  PaGlobal_Menu_Remake._nowMenuMode = ""
  PaGlobal_Menu_Remake._nowMenuIndex = 0
  PaGlobal_Menu_Remake._nowSelectedMenuIndex = 0
  local textureUVOut = PaGlobal_Menu_Remake._menuGrid.normal
  local textureDDS = PaGlobal_Menu_Remake._menuGrid.ddsUrl
  for ii = 1, #PaGlobal_Menu_Remake._menuHotKey do
    if nil ~= PaGlobal_Menu_Remake._menuHotKeyGroup[ii] then
      local radiobtn = PaGlobal_Menu_Remake._menuHotKeyGroup[ii].radiobtn
      radiobtn:SetCheck(false)
      local x1, y1, x2, y2 = setTextureUV_Func(radiobtn, textureUVOut.x1, textureUVOut.y1, textureUVOut.x2, textureUVOut.y2)
      radiobtn:ChangeTextureInfoName(textureDDS)
      radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
      radiobtn:setRenderTexture(radiobtn:getBaseTexture())
    end
  end
  textureUVOut = PaGlobal_Menu_Remake._headerGrid.normal
  textureDDS = PaGlobal_Menu_Remake._headerGrid.ddsUrl
  for index, controlGroup in pairs(PaGlobal_Menu_Remake._headerHotKeyGroup) do
    local x1, y1, x2, y2 = setTextureUV_Func(controlGroup.radiobtn, textureUVOut.x1, textureUVOut.y1, textureUVOut.x2, textureUVOut.y2)
    controlGroup.radiobtn:ChangeTextureInfoName(textureDDS)
    controlGroup.radiobtn:getBaseTexture():setUV(x1, y1, x2, y2)
    controlGroup.radiobtn:setRenderTexture(controlGroup.radiobtn:getBaseTexture())
  end
  PaGlobal_Menu_Remake:setBeforeSearch()
  PaGlobal_Menu_Remake:setMenuCondition()
  PaGlobal_Menu_Remake:SetSubmenuHotKeyInfo()
  PaGlobal_Menu_Remake:setHeadHotKeyInfo()
  PaGlobal_Menu_Remake:setHeaderHotKey()
  PaGlobal_Menu_Remake:setMenuHotKey()
  PaGlobal_Menu_Remake._ui.stc_subMenuGroup:SetShow(false)
  PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:SetShow(true)
  PaGlobal_Menu_Remake:hideTooltip()
end
function PaGlobal_Menu_Remake_ToggleSearchMode()
  PaGlobal_Menu_Remake:toggle_searchMode()
end
function PaGlobal_Menu_Remake:toggle_searchMode()
  if true == PaGlobal_Menu_Remake._ui.edit_searchTxt:GetFocusEdit() then
    PaGlobal_Menu_Remake:setBeforeSearch()
  else
    PaGlobal_Menu_Remake:selected_searchText()
  end
end
function PaGlobal_Menu_Remake:selected_searchText()
  SetFocusEdit(PaGlobal_Menu_Remake._ui.edit_searchTxt)
  PaGlobal_Menu_Remake._ui.edit_searchTxt:SetEditText("")
end
function PaGlobal_Menu_Remake:validate()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake._ui.stc_topGroup:isValidate()
  PaGlobal_Menu_Remake._ui.stc_menuGroup:isValidate()
  PaGlobal_Menu_Remake._ui.stc_subMenuGroup:isValidate()
  PaGlobal_Menu_Remake._ui.stc_menuSelect_desc_Group:isValidate()
  PaGlobal_Menu_Remake._ui.stc_submenu_BG:isValidate()
  PaGlobal_Menu_Remake._ui.stc_submenu_highlight:isValidate()
  PaGlobal_Menu_Remake._ui.stc_header_button_group:isValidate()
  PaGlobal_Menu_Remake._ui.stc_header_button:isValidate()
  PaGlobal_Menu_Remake._ui.stc_header_interface_group:isValidate()
  PaGlobal_Menu_Remake._ui.stctxt_header_button_title:isValidate()
  PaGlobal_Menu_Remake._ui.stctxt_customize_desc:isValidate()
  PaGlobal_Menu_Remake._ui.btn_changeUi:isValidate()
  PaGlobal_Menu_Remake._ui.btn_openway:isValidate()
  PaGlobal_Menu_Remake._ui.btn_customizeUi:isValidate()
  PaGlobal_Menu_Remake._ui.stc_menuSelect_desc:isValidate()
  PaGlobal_Menu_Remake._ui.stc_menu_highlight:isValidate()
  PaGlobal_Menu_Remake._ui.radiobtn_menu:isValidate()
  PaGlobal_Menu_Remake._ui.radiobtn_sub_menu:isValidate()
end
function PaGlobal_Menu_Remake:showOpenWayToolTip()
  if 0 == ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eMenuOpenWay) then
    TooltipSimple_Show(PaGlobal_Menu_Remake._ui.btn_openway, PAGetString(Defines.StringSheet_GAME, "LUA_MENU_RIGHTSLIDE"))
  else
    TooltipSimple_Show(PaGlobal_Menu_Remake._ui.btn_openway, PAGetString(Defines.StringSheet_GAME, "LUA_MENU_LEFTSLIDE"))
  end
end
function PaGlobal_Menu_Remake:showChangeUiToolTip()
  TooltipSimple_Show(PaGlobal_Menu_Remake._ui.btn_changeUi, PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MENU_NEW_TRANSFER_OLD"))
end
function PaGlobal_Menu_Remake:setMenuOpenWay()
  local way = 0
  if 0 == ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eMenuOpenWay) then
    way = 1
  end
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMenuOpenWay, way, CppEnums.VariableStorageType.eVariableStorageType_User)
  PaGlobal_Menu_Remake:setMenuOpenWayBtn()
end
