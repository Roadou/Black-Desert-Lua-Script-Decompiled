local TAB_TYPE = {
  ALL = 1,
  STORAGE = 2,
  MARKETPLACE = 3,
  MARKET = 4
}
function PaGlobal_MaidList_All:initialize()
  if true == PaGlobal_MaidList_All._initialize then
    return
  end
  self:controlAll_Init()
  self:controlPc_Init()
  self:controlConsole_Init()
  self:controlSetShow()
  self._isConsole = ToClient_isConsole()
  self._ui.list2_maid:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_MaidList_All_ListControlCreate")
  self._ui.list2_maid:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  if true == self._isConsole then
    local tempBtnGroup = {
      self._ui.stc_keyGuide_A,
      self._ui.stc_keyGuide_B
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui_console.stc_keyGuideAreaBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  else
    Panel_MyHouseNavi_Update(true)
    self:LogInMaidShow()
  end
  self:resize()
  self:registEventHandler()
  self:validate()
  self._initialize = true
end
function PaGlobal_MaidList_All:controlAll_Init()
  if nil == Panel_Window_MaidList_All then
    return
  end
  self._ui.stc_title = UI.getChildControl(Panel_Window_MaidList_All, "Static_MainTitleBar")
  self._ui.txt_noMaidFound = UI.getChildControl(Panel_Window_MaidList_All, "StaticText_NoMaidFound")
  self._ui.txt_maidCount = UI.getChildControl(Panel_Window_MaidList_All, "StaticText_LeftMaidCount")
  self._ui.txt_maidCountValue = UI.getChildControl(Panel_Window_MaidList_All, "StaticText_LeftMaidCountValue")
  self._ui.list2_maid = UI.getChildControl(Panel_Window_MaidList_All, "List2_Maid")
  self._ui.stc_tabBar = UI.getChildControl(Panel_Window_MaidList_All, "Static_TapBtmBar")
  self._ui.stc_tabBar:SetShow(true)
end
function PaGlobal_MaidList_All:controlPc_Init()
  if nil == Panel_Window_MaidList_All then
    return
  end
  self._ui_pc.btn_close = UI.getChildControl(self._ui.stc_title, "Button_Close_PCUI")
  self._ui_pc.stc_tabBg = UI.getChildControl(Panel_Window_MaidList_All, "Static_TapBg_PCUI")
  self._ui_pc.btn_radios[TAB_TYPE.ALL] = UI.getChildControl(self._ui_pc.stc_tabBg, "RadioButton_All")
  self._ui_pc.btn_radios[TAB_TYPE.STORAGE] = UI.getChildControl(self._ui_pc.stc_tabBg, "RadioButton_Warehouse")
  self._ui_pc.btn_radios[TAB_TYPE.MARKETPLACE] = UI.getChildControl(self._ui_pc.stc_tabBg, "RadioButton_Itemmarket")
  self._ui_pc.btn_warehouse = UI.getChildControl(Panel_Window_MaidList_All, "Button_SummonMaid_Warehouse_PCUI")
  self._ui_pc.btn_market = UI.getChildControl(Panel_Window_MaidList_All, "Button_SummonMaid_Market_PCUI")
  self._ui_pc.btn_marketPlace = UI.getChildControl(Panel_Window_MaidList_All, "Button_SummonMaid_MarketPlace_PCUI")
  self._ui_pc.btn_pcRoom = UI.getChildControl(Panel_Window_MaidList_All, "Button_PCRoomRegist_PCUI")
  self._ui_pc.btn_warehouse:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui_pc.btn_warehouse:SetText(self._ui_pc.btn_warehouse:GetText())
  self._ui_pc.btn_market:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui_pc.btn_market:SetText(self._ui_pc.btn_market:GetText())
  self._ui_pc.btn_marketPlace:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui_pc.btn_marketPlace:SetText(self._ui_pc.btn_marketPlace:GetText())
  self._ui_pc.btn_pcRoom:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui_pc.btn_pcRoom:SetText(self._ui_pc.btn_pcRoom:GetText())
end
function PaGlobal_MaidList_All:controlConsole_Init()
  if nil == Panel_Window_MaidList_All then
    return
  end
  self._ui_console.stc_tabBg = UI.getChildControl(Panel_Window_MaidList_All, "Static_TapBg_ConsoleUI")
  self._ui_console.rdo_tabs[TAB_TYPE.ALL] = UI.getChildControl(self._ui_console.stc_tabBg, "RadioButton_All")
  self._ui_console.rdo_tabs[TAB_TYPE.STORAGE] = UI.getChildControl(self._ui_console.stc_tabBg, "RadioButton_Warehouse")
  self._ui_console.rdo_tabs[TAB_TYPE.MARKETPLACE] = UI.getChildControl(self._ui_console.stc_tabBg, "RadioButton_Itemmarket")
  self._ui_console.stc_keyGuideLB = UI.getChildControl(self._ui_console.stc_tabBg, "StaticText_KeyGuideLB")
  self._ui_console.stc_keyGuideRB = UI.getChildControl(self._ui_console.stc_tabBg, "StaticText_KeyGuideRB")
  self._ui_console.stc_keyGuideAreaBg = UI.getChildControl(Panel_Window_MaidList_All, "Static_KeyGuideArea_ConsoleUI")
  self._ui_console.stc_selectA = UI.getChildControl(self._ui_console.stc_keyGuideAreaBg, "StaticText_Confirm_ConsoleUI")
  self._ui_console.stc_cancleB = UI.getChildControl(self._ui_console.stc_keyGuideAreaBg, "StaticText_Cancel_ConsoleUI")
end
function PaGlobal_MaidList_All:controlSetShow()
  if nil == Panel_Window_MaidList_All then
    return
  end
  if false == self._isConsole then
    self._ui_pc.stc_tabBg:SetShow(true)
    self._ui_pc.btn_close:SetShow(true)
    self._ui_pc.btn_warehouse:SetShow(true)
    if true == _ContentsGroup_RenewUI_ItemMarketPlace then
      self._ui_pc.btn_market:SetShow(false)
      self._ui_pc.btn_marketPlace:SetShow(true)
    else
      self._ui_pc.btn_market:SetShow(true)
      self._ui_pc.btn_marketPlace:SetShow(false)
    end
    if true == _ContentsGroup_KR_Transfer and true == ToClient_isShowRegistPcRoomMaidButton() then
      self._ui_pc.btn_pcRoom:SetShow(true)
    else
      self._ui_pc.btn_pcRoom:SetShow(false)
    end
    self._ui_console.stc_tabBg:SetShow(false)
    self._ui_console.stc_keyGuideAreaBg:SetShow(false)
  else
    self._ui_pc.btn_close:SetShow(false)
    self._ui_pc.btn_warehouse:SetShow(false)
    self._ui_pc.btn_market:SetShow(false)
    self._ui_pc.btn_marketPlace:SetShow(false)
    self._ui_console.stc_keyGuideAreaBg:SetShow(true)
  end
end
function PaGlobal_MaidList_All:resize()
  if nil == Panel_Window_MaidList_All then
    return
  end
  Panel_Window_MaidList_All:ComputePos()
  self._ui.txt_maidCountValue:SetPosX(self._ui.txt_maidCount:GetPosX() + self._ui.txt_maidCount:GetTextSizeX() + 5)
  self._ui_pc.btn_warehouse:ComputePos()
  self._ui_pc.btn_market:ComputePos()
  self._ui_pc.btn_marketPlace:ComputePos()
  self._ui_pc.btn_pcRoom:ComputePos()
  self._ui_console.stc_keyGuideAreaBg:ComputePos()
end
function PaGlobal_MaidList_All:registEventHandler()
  if nil == Panel_Window_MaidList_All then
    return
  end
  if false == self._isConsole then
    self._ui_pc.btn_close:addInputEvent("Mouse_LUp", "PaGlobalFunc_MaidList_All_Close()")
    self._ui_pc.btn_radios[TAB_TYPE.ALL]:addInputEvent("Mouse_LUp", "HandleEventLUp_MaidList_All_Update(" .. TAB_TYPE.ALL .. ")")
    self._ui_pc.btn_radios[TAB_TYPE.STORAGE]:addInputEvent("Mouse_LUp", "HandleEventLUp_MaidList_All_Update(" .. TAB_TYPE.STORAGE .. ")")
    self._ui_pc.btn_radios[TAB_TYPE.MARKETPLACE]:addInputEvent("Mouse_LUp", "HandleEventLUp_MaidList_All_Update(" .. TAB_TYPE.MARKETPLACE .. ")")
    self._ui_pc.btn_warehouse:addInputEvent("Mouse_LUp", "PaGlobalFunc_MaidList_All_SelectMaid(" .. TAB_TYPE.STORAGE .. ")")
    self._ui_pc.btn_market:addInputEvent("Mouse_LUp", "PaGlobalFunc_MaidList_All_SelectMaid(" .. TAB_TYPE.MARKET .. ")")
    self._ui_pc.btn_marketPlace:addInputEvent("Mouse_LUp", "PaGlobalFunc_MaidList_All_SelectMaid(" .. TAB_TYPE.MARKETPLACE .. ")")
    self._ui_pc.btn_warehouse:addInputEvent("Mouse_On", "HandleEventOnOut_MaidList_All_SimpleTooltip( true, " .. 0 .. " )")
    self._ui_pc.btn_warehouse:addInputEvent("Mouse_Out", "HandleEventOnOut_MaidList_All_SimpleTooltip( false, " .. 0 .. " )")
    self._ui_pc.btn_market:addInputEvent("Mouse_On", "HandleEventOnOut_MaidList_All_SimpleTooltip( true, " .. 1 .. " )")
    self._ui_pc.btn_market:addInputEvent("Mouse_Out", "HandleEventOnOut_MaidList_All_SimpleTooltip( false, " .. 1 .. " )")
    self._ui_pc.btn_marketPlace:addInputEvent("Mouse_On", "HandleEventOnOut_MaidList_All_SimpleTooltip( true, " .. 2 .. " )")
    self._ui_pc.btn_marketPlace:addInputEvent("Mouse_Out", "HandleEventOnOut_MaidList_All_SimpleTooltip( false, " .. 2 .. " )")
    if true == _ContentsGroup_Maid then
      self._ui_pc.btn_warehouse:setButtonShortcuts("PANEL_MAIDLIST_OPEN_WAREHOUSE")
      if true == _ContentsGroup_RenewUI_ItemMarketPlace then
        self._ui_pc.btn_marketPlace:setButtonShortcuts("PANEL_MAIDLIST_OPEN_MARKETPLACE")
      else
        self._ui_pc.btn_market:setButtonShortcuts("PANEL_MAIDLIST_OPEN_ITEMMARKET")
      end
    end
    if true == _ContentsGroup_KR_Transfer then
      self._ui_pc.btn_pcRoom:addInputEvent("Mouse_LUp", "HandleEventLUp_MaidList_All_ClickPcRoomBtn()")
      self._ui_pc.btn_pcRoom:addInputEvent("Mouse_On", "HandleEventOnOut_MaidList_All_SimpleTooltip( true, " .. 3 .. " )")
      self._ui_pc.btn_pcRoom:addInputEvent("Mouse_Out", "HandleEventOnOut_MaidList_All_SimpleTooltip( false, " .. 3 .. " )")
    end
  else
    Panel_Window_MaidList_All:registerPadEvent(__eConsoleUIPadEvent_LB, "PadEventRBLB_PaGlobal_MaidList_All_NextTab(-1)")
    Panel_Window_MaidList_All:registerPadEvent(__eConsoleUIPadEvent_RB, "PadEventRBLB_PaGlobal_MaidList_All_NextTab(1)")
  end
  Panel_Window_MaidList_All:RegisterUpdateFunc("PaGlobalFunc_MaidList_All_UpdatePerFrame")
  registerEvent("onScreenResize", "onScreenResize_MaidList_All_Resize")
  registerEvent("FromClient_RefreshMaidList", "FromClient_RefreshMaidList_MaidList_All")
end
function PaGlobal_MaidList_All:prepareOpen()
  if nil == Panel_Window_MaidList_All then
    return
  end
  if false == _ContentsGroup_NewUI_Maid_All then
    return
  end
  self:setTabTo(self._currentTab)
  self:resize()
  self:open()
end
function PaGlobal_MaidList_All:open()
  if nil == Panel_Window_MaidList_All then
    return
  end
  Panel_Window_MaidList_All:ComputePos()
  Panel_Window_MaidList_All:SetShow(true)
end
function PaGlobal_MaidList_All:prepareClose()
  if nil == Panel_Window_MaidList_All then
    return
  end
  self:close()
end
function PaGlobal_MaidList_All:close()
  if nil == Panel_Window_MaidList_All then
    return
  end
  Panel_Window_MaidList_All:ClearUpdateLuaFunc()
  Panel_Window_MaidList_All:SetShow(false)
end
function PaGlobal_MaidList_All:validate()
  if nil == Panel_Window_MaidList_All then
    return
  end
  self._ui.stc_title:isValidate()
  self._ui.txt_noMaidFound:isValidate()
  self._ui.txt_maidCount:isValidate()
  self._ui.txt_maidCountValue:isValidate()
  self._ui.list2_maid:isValidate()
  if false == self._isConsole then
    self._ui_pc.btn_close:isValidate()
    self._ui_pc.stc_tabBg:isValidate()
    self._ui_pc.btn_radios[TAB_TYPE.ALL]:isValidate()
    self._ui_pc.btn_radios[TAB_TYPE.STORAGE]:isValidate()
    self._ui_pc.btn_radios[TAB_TYPE.MARKETPLACE]:isValidate()
    self._ui_pc.btn_warehouse:isValidate()
    self._ui_pc.btn_market:isValidate()
    self._ui_pc.btn_marketPlace:isValidate()
    self._ui_pc.btn_pcRoom:isValidate()
  else
    self._ui_console.stc_tabBg:isValidate()
    self._ui_console.rdo_tabs[TAB_TYPE.ALL]:isValidate()
    self._ui_console.rdo_tabs[TAB_TYPE.STORAGE]:isValidate()
    self._ui_console.rdo_tabs[TAB_TYPE.MARKETPLACE]:isValidate()
    self._ui_console.stc_keyGuideLB:isValidate()
    self._ui_console.stc_keyGuideRB:isValidate()
    self._ui_console.stc_keyGuideAreaBg:isValidate()
    self._ui_console.stc_selectA:isValidate()
    self._ui_console.stc_cancleB:isValidate()
  end
end
function PaGlobalFunc_MaidList_All_ListControlCreate(control, key)
  if nil == Panel_Window_MaidList_All then
    return
  end
  local btn = UI.getChildControl(control, "Button_ListObject")
  local txt_name = UI.getChildControl(btn, "StaticText_Name")
  local txt_type = UI.getChildControl(btn, "StaticText_Func")
  local txt_cool = UI.getChildControl(btn, "StaticText_Cooltime")
  local key32 = Int64toInt32(key)
  local functionText = {
    [TAB_TYPE.STORAGE] = PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_WAREHOUSE"),
    [TAB_TYPE.MARKETPLACE] = PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_MARKET")
  }
  if true == PaGlobal_MaidList_All._isConsole then
    btn:addInputEvent("Mouse_LUp", "PaGlobalFunc_MaidList_All_SelectMaid(" .. key32 .. ")")
    btn:SetIgnore(false)
  else
    btn:SetIgnore(true)
  end
  txt_name:SetText(PaGlobal_MaidList_All._maidData[key32].name)
  txt_type:SetText(functionText[PaGlobal_MaidList_All._maidData[key32].func])
  local oneMinute = 60
  local coolTime = PaGlobal_MaidList_All._maidData[key32].cool
  if 0 == coolTime then
    txt_cool:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_POSSIBLE"))
    txt_cool:SetFontColor(Defines.Color.C_FFDDC39E)
    txt_name:SetFontColor(Defines.Color.C_FFDDC39E)
    txt_type:SetFontColor(Defines.Color.C_FFDDC39E)
  elseif oneMinute > coolTime then
    txt_cool:SetFontColor(Defines.Color.C_FF9397A7)
    txt_name:SetFontColor(Defines.Color.C_FF9397A7)
    txt_type:SetFontColor(Defines.Color.C_FF9397A7)
    txt_cool:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_ONEMINUTELEFT"))
  else
    txt_cool:SetFontColor(Defines.Color.C_FF585453)
    txt_name:SetFontColor(Defines.Color.C_FF585453)
    txt_type:SetFontColor(Defines.Color.C_FF585453)
    txt_cool:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MAIDLIST_LEFTTIME", "minute", coolTime / oneMinute - coolTime / oneMinute % 1))
  end
end
function PaGlobal_MaidList_All:LogInMaidShow()
  if 6 < getSelfPlayer():get():getLevel() and 0 < getTotalMaidList() then
    ToClient_CallHandlerMaid("_StrAllmaidLogOut")
    local randomMaidIndex = math.random(getTotalMaidList()) - 1
    local maidInfoWrapper = getMaidDataByIndex(randomMaidIndex)
    if nil ~= maidInfoWrapper then
      local aiVariable = 2
      local maidNo = maidInfoWrapper:getMaidNo()
      ToClient_SummonMaid(maidNo, aiVariable)
    end
  end
end
function PaGlobal_MaidList_All:setTabTo(tabIndex)
  if nil == Panel_Window_MaidList_All then
    return
  end
  local radios
  if false == self._isConsole then
    radios = self._ui_pc.btn_radios
  else
    radios = self._ui_console.rdo_tabs
  end
  for ii = 1, #radios do
    radios[ii]:SetCheck(false)
    radios[ii]:SetFontColor(Defines.Color.C_FF585453)
  end
  radios[tabIndex]:SetCheck(true)
  radios[tabIndex]:SetFontColor(Defines.Color.C_FFFFEDD4)
  self._ui.stc_tabBar:SetPosX(radios[tabIndex]:GetPosX() + radios[tabIndex]:GetSizeX() / 2 - 40)
  self._currentTab = tabIndex
  self:updateData(self._currentTab)
  self:pushDataToList()
end
function PaGlobal_MaidList_All:updateData(tab)
  if nil == Panel_Window_MaidList_All then
    return
  end
  self._maidData = {}
  local maidCount = getTotalMaidList()
  if maidCount < 1 then
    self._ui.txt_noMaidFound:SetShow(true)
    return
  else
    self._ui.txt_noMaidFound:SetShow(false)
  end
  local availableMaidCount = 0
  for ii = 1, maidCount do
    local maidInfoWrapper = getMaidDataByIndex(ii - 1)
    if nil ~= maidInfoWrapper then
      local data = {
        name = maidInfoWrapper:getName(),
        cool = maidInfoWrapper:getCoolTime()
      }
      if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
        data.func = TAB_TYPE.STORAGE
      elseif maidInfoWrapper:isAbleSubmitMarket() then
        data.func = TAB_TYPE.MARKETPLACE
      end
      local index = #self._maidData + 1
      if tab == TAB_TYPE.STORAGE and data.func == TAB_TYPE.STORAGE then
        self._maidData[index] = data
      elseif tab == TAB_TYPE.MARKETPLACE and data.func == TAB_TYPE.MARKETPLACE then
        self._maidData[index] = data
      elseif tab == TAB_TYPE.MARKET and data.func == TAB_TYPE.MARKET then
        self._maidData[index] = data
      elseif tab == TAB_TYPE.ALL then
        self._maidData[index] = data
      end
      if nil ~= self._maidData[index] and 0 == self._maidData[index].cool then
        availableMaidCount = availableMaidCount + 1
      end
      self:updateBtnPosition(tab)
    end
  end
  self._ui.txt_maidCountValue:SetText(availableMaidCount)
end
function PaGlobal_MaidList_All:updateBtnPosition(tab)
  if nil == Panel_Window_MaidList_All then
    return
  end
  if true == self._isConsole then
    return
  end
  if tab == TAB_TYPE.ALL then
    self._ui_pc.btn_pcRoom:SetSpanSize(435, 15)
    self._ui_pc.btn_warehouse:SetSpanSize(225, 15)
    self._ui_pc.btn_market:SetSpanSize(15, 15)
    self._ui_pc.btn_marketPlace:SetSpanSize(15, 15)
    self._ui_pc.btn_warehouse:SetShow(true)
    if true == _ContentsGroup_RenewUI_ItemMarketPlace then
      self._ui_pc.btn_market:SetShow(false)
      self._ui_pc.btn_marketPlace:SetShow(true)
    else
      self._ui_pc.btn_market:SetShow(true)
      self._ui_pc.btn_marketPlace:SetShow(false)
    end
  elseif tab == TAB_TYPE.STORAGE then
    self._ui_pc.btn_pcRoom:SetSpanSize(225, 15)
    self._ui_pc.btn_warehouse:SetSpanSize(15, 15)
    self._ui_pc.btn_warehouse:SetShow(true)
    self._ui_pc.btn_market:SetShow(false)
    self._ui_pc.btn_marketPlace:SetShow(false)
  elseif tab == TAB_TYPE.MARKETPLACE then
    self._ui_pc.btn_pcRoom:SetSpanSize(225, 15)
    self._ui_pc.btn_warehouse:SetShow(false)
    self._ui_pc.btn_market:SetShow(false)
    self._ui_pc.btn_marketPlace:SetSpanSize(15, 15)
    self._ui_pc.btn_marketPlace:SetShow(true)
  elseif tab == TAB_TYPE.MARKET then
    self._ui_pc.btn_pcRoom:SetSpanSize(225, 15)
    self._ui_pc.btn_warehouse:SetShow(false)
    self._ui_pc.btn_market:SetSpanSize(15, 15)
    self._ui_pc.btn_market:SetShow(true)
    self._ui_pc.btn_marketPlace:SetShow(false)
  end
end
function PaGlobal_MaidList_All:pushDataToList()
  if nil == Panel_Window_MaidList_All then
    return
  end
  self._ui.list2_maid:getElementManager():clearKey()
  for ii = 1, #self._maidData do
    self._ui.list2_maid:getElementManager():pushKey(toInt64(0, ii))
  end
end
function PaGlobalFunc_MaidList_All_UpdatePerFrame(deltaTime)
  if nil == Panel_Window_MaidList_All then
    return
  end
  local elapsedTime = 0
  local updateInterval = 1
  elapsedTime = elapsedTime + deltaTime
  if updateInterval < elapsedTime then
    elapsedTime = 0
    PaGlobal_MaidList_All:updateData(PaGlobal_MaidList_All._currentTab)
    PaGlobal_MaidList_All._ui.list2_maid:requestUpdateVisible()
  end
end
function PaGlobalFunc_MaidList_All_SelectMaid(key32)
  if nil == Panel_Window_MaidList_All then
    return
  end
  if nil == key32 then
    _PA_ASSERT_NAME(false, "PaGlobalFunc_MaidList_All_SelectMaid: key32\236\157\180 nil\236\158\133\235\139\136\235\139\164.", "\236\160\149\236\167\128\237\152\156")
    return
  end
  local funcType
  if true == PaGlobal_MaidList_All._isConsole then
    local data = PaGlobal_MaidList_All._maidData[key32]
    if nil == data or nil == data.func then
      return
    end
    funcType = data.func
  else
    funcType = key32
  end
  local selfProxy = getSelfPlayer()
  if nil == selfProxy then
    _PA_ASSERT_NAME(false, "PaGlobalFunc_MaidList_All_SelectMaid: selfProxy nil\236\158\133\235\139\136\235\139\164", "\236\160\149\236\167\128\237\152\156")
    return
  end
  local dontGoMaid = -1
  local maidType = -1
  local isFreeBattle = selfProxy:get():isBattleGroundDefine()
  local isArshaJoin = ToClient_IsMyselfInArena()
  local localWarTeam = ToClient_GetMyTeamNoLocalWar()
  local isSpecialCharacter = getTemporaryInformationWrapper():isSpecialCharacter()
  local isSavageDefence = ToClient_getPlayNowSavageDefence()
  local isGuildBattle = ToClient_getJoinGuildBattle()
  if 0 ~= localWarTeam then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_DONT_SUMMON_LOCALWAR"))
    return
  end
  if isFreeBattle then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WARNING_FREEBATTLE"))
    return
  end
  if isArshaJoin then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WARNING_ARSHA"))
    return
  end
  if selfplayerIsInHorseRace() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_DONT_SUMMON_HORSERACE"))
    return
  end
  if isSpecialCharacter then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WARNING_PREMIUMCHARACTER"))
    return
  end
  if isSavageDefence then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantPlayingSavageDefence"))
    return
  end
  if isGuildBattle then
    if true == ToClient_isPersonalBattle() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_PERSONALBATTLE"))
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_GUILDBATTLE"))
    end
    return
  end
  local warehouseInMaid = checkMaid_WarehouseIn(true)
  local marketMaid = checkMaid_SubmitMarket(true)
  local enableWarehouseMaid = checkMaid_WarehouseIn(false)
  local enableMarketMaid = checkMaid_SubmitMarket(false)
  if TAB_TYPE.MARKETPLACE == funcType then
    if marketMaid then
      PaGlobalFunc_MarketPlace_OpenByMaid()
      if ToClient_CheckExistSummonMaid() and -1 ~= dontGoMaid then
        if 0 == maidType then
          ToClient_CallHandlerMaid("_marketMaid")
        else
          for mIndex = 0, getTotalMaidList() - 1 do
            local maidInfoWrapper = getMaidDataByIndex(mIndex)
            if maidInfoWrapper:isAbleSubmitMarket() then
              if 0 == maidInfoWrapper:getCoolTime() then
                ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
                ToClient_CallHandlerMaid("_warehouseMaidLogOut")
                ToClient_CallHandlerMaid("_marketMaid")
                dontGoMaid = mIndex
                PaGlobal_MaidList_All:prepareClose()
                maidType = 0
              else
                Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_WAREHOUSEMAID_COOLTIME"))
              end
            end
          end
        end
        PaGlobal_MaidList_All:prepareClose()
      else
        for mIndex = 0, getTotalMaidList() - 1 do
          local maidInfoWrapper = getMaidDataByIndex(key32 - 1)
          if maidInfoWrapper:isAbleSubmitMarket() then
            if 0 == maidInfoWrapper:getCoolTime() then
              ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
              ToClient_CallHandlerMaid("_marketMaid")
              dontGoMaid = key32 - 1
              PaGlobal_MaidList_All:prepareClose()
              maidType = 0
            else
              Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_WAREHOUSEMAID_COOLTIME"))
            end
          end
        end
      end
    else
      if false == enableMarketMaid then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_MARKETMAID_NONE"))
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_MARKETMAID_COOLTIME"))
      end
      SetUIMode(Defines.UIMode.eUIMode_Default)
    end
  elseif TAB_TYPE.STORAGE == funcType then
    if warehouseInMaid then
      if IsSelfPlayerWaitAction() then
        Warehouse_OpenPanelFromMaid()
        if ToClient_CheckExistSummonMaid() and -1 ~= dontGoMaid then
          if 1 == maidType then
            ToClient_CallHandlerMaid("_warehouseMaid")
          else
            for mIndex = 0, getTotalMaidList() - 1 do
              local maidInfoWrapper = getMaidDataByIndex(mIndex)
              if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
                if 0 == maidInfoWrapper:getCoolTime() then
                  ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
                  ToClient_CallHandlerMaid("_marketMaidLogOut")
                  ToClient_CallHandlerMaid("_warehouseMaid")
                  dontGoMaid = mIndex
                  PaGlobal_MaidList_All:prepareClose()
                  maidType = 1
                else
                  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_WAREHOUSEMAID_COOLTIME"))
                end
              end
            end
          end
          PaGlobal_MaidList_All:prepareClose()
        else
          for mIndex = 0, getTotalMaidList() - 1 do
            local maidInfoWrapper = getMaidDataByIndex(mIndex)
            if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
              if 0 == maidInfoWrapper:getCoolTime() then
                ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
                ToClient_CallHandlerMaid("_warehouseMaid")
                dontGoMaid = mIndex
                PaGlobal_MaidList_All:prepareClose()
                maidType = 1
              else
                Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_WAREHOUSEMAID_COOLTIME"))
              end
            end
          end
        end
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_ALERT"))
      end
    else
      if false == enableWarehouseMaid then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_WAREHOUSEMAID_NONE"))
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_WAREHOUSEMAID_COOLTIME"))
      end
      SetUIMode(Defines.UIMode.eUIMode_Default)
    end
  elseif TAB_TYPE.MARKET == funcType then
    FGlobal_ItemMarket_OpenByMaid()
    if ToClient_CheckExistSummonMaid() and -1 ~= dontGoMaid then
      if 0 == maidType then
        ToClient_CallHandlerMaid("_marketMaid")
      else
        for mIndex = 0, getTotalMaidList() - 1 do
          local maidInfoWrapper = getMaidDataByIndex(mIndex)
          if maidInfoWrapper:isAbleSubmitMarket() and 0 == maidInfoWrapper:getCoolTime() then
            ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
            ToClient_CallHandlerMaid("_warehouseMaidLogOut")
            ToClient_CallHandlerMaid("_marketMaid")
            dontGoMaid = mIndex
            PaGlobal_MaidList_All:prepareClose()
            maidType = 0
            break
          end
        end
      end
      PaGlobal_MaidList_All:prepareClose()
    else
      for mIndex = 0, getTotalMaidList() - 1 do
        local maidInfoWrapper = getMaidDataByIndex(mIndex)
        if maidInfoWrapper:isAbleSubmitMarket() and 0 == maidInfoWrapper:getCoolTime() then
          ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
          ToClient_CallHandlerMaid("_marketMaid")
          dontGoMaid = mIndex
          PaGlobal_MaidList_All:prepareClose()
          maidType = 0
          break
        end
      end
    end
  end
end
