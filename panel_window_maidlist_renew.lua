local _panel = Panel_Window_MaidList_Renew
local TAB_TYPE = {
  ALL = 1,
  STORAGE = 2,
  MARKET = 3
}
local MaidList = {
  _ui = {
    rdo_tabs = {
      [TAB_TYPE.ALL] = UI.getChildControl(_panel, "RadioButton_All"),
      [TAB_TYPE.STORAGE] = UI.getChildControl(_panel, "RadioButton_Warehouse"),
      [TAB_TYPE.MARKET] = UI.getChildControl(_panel, "RadioButton_Itemmarket")
    },
    txt_leftMaid = UI.getChildControl(_panel, "StaticText_LeftMaidCount"),
    txt_leftMaidValue = UI.getChildControl(_panel, "StaticText_LeftMaidCountValue"),
    list2_maid = UI.getChildControl(_panel, "List2_Maid"),
    txt_noMaidFound = UI.getChildControl(_panel, "StaticText_NoMaidFound"),
    stc_keyGuideArea = UI.getChildControl(_panel, "Static_KeyGuideArea")
  },
  _currentTab = 1,
  _maidData = nil
}
function FromClient_luaLoadComplete_MaidList()
  MaidList:initialize()
end
function MaidList:initialize()
  self._ui.list2_maid:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_MaidList_ListControlCreate")
  self._ui.list2_maid:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.stc_keyGuide_A = UI.getChildControl(self._ui.stc_keyGuideArea, "StaticText_Confirm_ConsoleUI")
  self._ui.stc_keyGuide_B = UI.getChildControl(self._ui.stc_keyGuideArea, "StaticText_Cancel_ConsoleUI")
  local tempBtnGroup = {
    self._ui.stc_keyGuide_A,
    self._ui.stc_keyGuide_B
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui.stc_keyGuideArea, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self:resize()
  self:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MaidList")
local self = MaidList
function MaidList:registEventHandler()
  _panel:registerPadEvent(__eConsoleUIPadEvent_LB, "Input_MaidList_NextTab(-1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RB, "Input_MaidList_NextTab(1)")
  _panel:RegisterUpdateFunc("PaGlobalFunc_MaidList_UpdatePerFrame")
  registerEvent("onScreenResize", "PaGlobal_MaidList_Resize")
end
function PaGlobalFunc_MaidList_Open()
  self:open()
end
function MaidList:open()
  _panel:SetShow(true)
  self:setTabTo(self._currentTab)
end
function MaidList:resize()
  _panel:ComputePos()
end
function PaGlobalFunc_MaidList_OnPadB()
  self:close()
end
function PaGlobalFunc_MaidList_Close()
  self:close()
end
function MaidList:close()
  _panel:SetShow(false)
end
function Input_MaidList_NextTab(val)
  local nextTab = self._currentTab + val
  if nextTab > #self._ui.rdo_tabs then
    nextTab = 1
  elseif nextTab < 1 then
    nextTab = #self._ui.rdo_tabs
  end
  self:setTabTo(nextTab)
end
function MaidList:setTabTo(tabIndex)
  for ii = 1, #self._ui.rdo_tabs do
    self._ui.rdo_tabs[ii]:SetCheck(false)
    self._ui.rdo_tabs[ii]:SetFontColor(Defines.Color.C_FF9397A7)
  end
  self._ui.rdo_tabs[tabIndex]:SetCheck(true)
  self._ui.rdo_tabs[tabIndex]:SetFontColor(Defines.Color.C_FFEEEEEE)
  self._currentTab = tabIndex
  self:updateData(self._currentTab)
  self:pushDataToList()
end
function MaidList:updateData(tab)
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
        data.func = TAB_TYPE.MARKET
      end
      local index = #self._maidData + 1
      if tab == TAB_TYPE.STORAGE and data.func == TAB_TYPE.STORAGE then
        self._maidData[index] = data
      elseif tab == TAB_TYPE.MARKET and data.func == TAB_TYPE.MARKET then
        self._maidData[index] = data
      elseif tab == TAB_TYPE.ALL then
        self._maidData[index] = data
      end
      if nil ~= self._maidData[index] and 0 == self._maidData[index].cool then
        availableMaidCount = availableMaidCount + 1
      end
    end
  end
  self._ui.txt_leftMaidValue:SetText(availableMaidCount)
end
function MaidList:pushDataToList()
  self._ui.list2_maid:getElementManager():clearKey()
  for ii = 1, #self._maidData do
    self._ui.list2_maid:getElementManager():pushKey(toInt64(0, ii))
  end
end
local functionText = {
  [TAB_TYPE.STORAGE] = PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_WAREHOUSE"),
  [TAB_TYPE.MARKET] = PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_MARKET")
}
function PaGlobalFunc_MaidList_ListControlCreate(control, key)
  local btn = UI.getChildControl(control, "Button_ListObject")
  local txt_name = UI.getChildControl(btn, "StaticText_Name")
  local txt_type = UI.getChildControl(btn, "StaticText_Func")
  local txt_cool = UI.getChildControl(btn, "StaticText_Cooltime")
  local key32 = Int64toInt32(key)
  btn:addInputEvent("Mouse_LUp", "Input_MaidList_SelectMaid(" .. key32 .. ")")
  txt_name:SetText(self._maidData[key32].name)
  txt_type:SetText(functionText[self._maidData[key32].func])
  local oneMinute = 60
  local coolTime = self._maidData[key32].cool
  if 0 == coolTime then
    txt_cool:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_POSSIBLE"))
    txt_cool:SetFontColor(Defines.Color.C_FFEEEEEE)
    txt_name:SetFontColor(Defines.Color.C_FFEEEEEE)
    txt_type:SetFontColor(Defines.Color.C_FFEEEEEE)
  elseif oneMinute > coolTime then
    txt_cool:SetFontColor(Defines.Color.C_FF9397A7)
    txt_name:SetFontColor(Defines.Color.C_FF9397A7)
    txt_type:SetFontColor(Defines.Color.C_FF9397A7)
    txt_cool:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_ONEMINUTELEFT"))
  else
    txt_cool:SetFontColor(Defines.Color.C_FF525B6D)
    txt_name:SetFontColor(Defines.Color.C_FF525B6D)
    txt_type:SetFontColor(Defines.Color.C_FF525B6D)
    txt_cool:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MAIDLIST_LEFTTIME", "minute", coolTime / oneMinute - coolTime / oneMinute % 1))
  end
end
local elapsedTime = 0
local updateInterval = 1
function PaGlobalFunc_MaidList_UpdatePerFrame(deltaTime)
  elapsedTime = elapsedTime + deltaTime
  if elapsedTime > updateInterval then
    elapsedTime = 0
    self:updateData(self._currentTab)
    self._ui.list2_maid:requestUpdateVisible()
  end
end
local dontGoMaid = -1
local maidType = -1
function Input_MaidList_SelectMaid(key32)
  local data = self._maidData[key32]
  if nil == data or nil == data.func then
    return
  end
  local funcType = data.func
  local selfProxy = getSelfPlayer()
  if nil == selfProxy then
    return
  end
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
  if TAB_TYPE.MARKET == funcType then
    if marketMaid then
      PaGlobalFunc_MarketPlace_OpenByMaid()
      if ToClient_CheckExistSummonMaid() and -1 ~= dontGoMaid then
        if 0 == maidType then
          ToClient_CallHandlerMaid("_marketMaid")
        else
          local maidInfoWrapper = getMaidDataByIndex(key32 - 1)
          if maidInfoWrapper:isAbleSubmitMarket() then
            if 0 == maidInfoWrapper:getCoolTime() then
              ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
              ToClient_CallHandlerMaid("_warehouseMaidLogOut")
              ToClient_CallHandlerMaid("_marketMaid")
              dontGoMaid = key32 - 1
              PaGlobalFunc_MaidList_Close()
              maidType = 0
            else
              Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_WAREHOUSEMAID_COOLTIME"))
            end
          end
        end
        PaGlobalFunc_MaidList_Close()
      else
        local maidInfoWrapper = getMaidDataByIndex(key32 - 1)
        if maidInfoWrapper:isAbleSubmitMarket() then
          if 0 == maidInfoWrapper:getCoolTime() then
            ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
            ToClient_CallHandlerMaid("_marketMaid")
            dontGoMaid = key32 - 1
            PaGlobalFunc_MaidList_Close()
            maidType = 0
          else
            Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_WAREHOUSEMAID_COOLTIME"))
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
            local maidInfoWrapper = getMaidDataByIndex(key32 - 1)
            if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
              if 0 == maidInfoWrapper:getCoolTime() then
                ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
                ToClient_CallHandlerMaid("_marketMaidLogOut")
                ToClient_CallHandlerMaid("_warehouseMaid")
                dontGoMaid = key32 - 1
                PaGlobalFunc_MaidList_Close()
                maidType = 1
              else
                Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_WAREHOUSEMAID_COOLTIME"))
              end
            end
          end
          PaGlobalFunc_MaidList_Close()
        else
          local maidInfoWrapper = getMaidDataByIndex(key32 - 1)
          if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
            if 0 == maidInfoWrapper:getCoolTime() then
              ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
              ToClient_CallHandlerMaid("_warehouseMaid")
              dontGoMaid = key32 - 1
              PaGlobalFunc_MaidList_Close()
              maidType = 1
            else
              Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ICON_MAID_WAREHOUSEMAID_COOLTIME"))
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
  end
end
function PaGlobal_MaidList_Resize()
  MaidList:resize()
end
