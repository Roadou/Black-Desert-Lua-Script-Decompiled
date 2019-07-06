function FromClient_WorkerAuction_All_ResponseWorkerAuction()
  if nil == Panel_Window_WorkerAuction_All then
    return
  end
  if false == Panel_Window_WorkerAuction_All:GetShow() then
    HandleEventLUp_WorkerAuction_All_Open()
  else
    PaGlobal_WorkerAuction_All:update(PaGlobal_WorkerAuction_All._selectedTab)
  end
end
function FromClient_WorkerAuction_All_ResponseMyWorkerAuction()
  if nil == Panel_Window_WorkerAuction_All or false == Panel_Window_WorkerAuction_All:GetShow() then
    return
  end
  PaGlobal_WorkerAuction_All:update(PaGlobal_WorkerAuction_All._selectedTab)
end
function FromClient_WorkerAuction_All_OnScreenResize()
  if nil == Panel_Window_WorkerAuction_All then
    return
  end
  PaGlobal_WorkerAuction_All:onScreenResize()
end
function HandleEventLUp_WorkerAuction_All_Open()
  if nil == Panel_Window_WorkerAuction_All or true == Panel_Window_WorkerAuction_All:GetShow() then
    return
  end
  PaGlobal_WorkerAuction_All:prepareOpen()
end
function HandleEventLUp_WorkerAuction_All_Close()
  if nil == Panel_Window_WorkerAuction_All or false == Panel_Window_WorkerAuction_All:GetShow() then
    return
  end
  PaGlobal_WorkerAuction_All:prepareClose()
end
function PaGlobalFunc_WorkerAuction_All_SetTempShow(isShow)
  if nil == Panel_Window_WorkerAuction_All then
    return
  end
  if nil == isShow or true == isShow then
    isShow = true
  else
    PaGlobal_WorkerAuction_All:AudioPostEvent(50, 3, true)
  end
  Panel_Window_WorkerAuction_All:SetShow(isShow)
end
function FromClient_UpdateMoney()
  if nil == Panel_Window_WorkerAuction_All then
    return
  end
  PaGlobal_WorkerAuction_All:updateMoney()
end
function HandleEventLUp_WorkerAuction_All_TabButtonClick(idx)
  if nil == Panel_Window_WorkerAuction_All then
    return
  end
  if idx ~= PaGlobal_WorkerAuction_All._selectedTab then
    PaGlobal_WorkerAuction_All._selectedTab = idx
    PaGlobal_WorkerAuction_All._currentPage = 1
    PaGlobal_WorkerAuction_All._maxPage = 1
  end
  for ii = 0, #PaGlobal_WorkerAuction_All._radioTabList do
    if ii == PaGlobal_WorkerAuction_All._selectedTab then
      PaGlobal_WorkerAuction_All._radioTabList[ii]:SetCheck(true)
      PaGlobal_WorkerAuction_All._radioTabList[ii]:SetFontColor(PaGlobal_WorkerAuction_All._TABCOLOR_SELECTED)
      local selectBarSapnX = PaGlobal_WorkerAuction_All._radioTabList[ii]:GetSpanSize().x
      local selectBarSapnY = PaGlobal_WorkerAuction_All._ui._stc_SelectBar:GetSpanSize().y
      PaGlobal_WorkerAuction_All._ui._stc_SelectBar:SetSpanSize(selectBarSapnX, selectBarSapnY)
      if ii == PaGlobal_WorkerAuction_All._ENUMTABINDEX_MARKETLIST then
        RequestAuctionListPage(CppEnums.AuctionType.AuctionGoods_WorkerNpc)
      elseif ii == PaGlobal_WorkerAuction_All._ENUMTABINDEX_MYREGISTER then
        requestMyWorkerList()
      else
        PaGlobal_WorkerAuction_All:update(idx)
      end
    else
      PaGlobal_WorkerAuction_All._radioTabList[ii]:SetCheck(false)
      PaGlobal_WorkerAuction_All._radioTabList[ii]:SetFontColor(PaGlobal_WorkerAuction_All._TABCOLOR_BASE)
    end
  end
  PaGlobal_WorkerAuction_All:AudioPostEvent(51, 7, true)
  PaGlobal_WorkerSkillTooltip_All_Hide()
end
function HandleEventLUp_WorkerAuction_All_BuyWorker(workerIdx)
  if nil == Panel_Window_WorkerAuction_All or nil == workerIdx or workerIdx < 0 then
    return
  end
  PaGlobal_WorkerAuction_All._selectedWorker = workerIdx
  local workerInfo
  workerInfo = PaGlobal_WorkerAuction_All:getWorkerInfo(workerIdx, true)
  if nil ~= workerInfo then
    PaGlobalFunc_WorkerAuction_All_SetTempShow(false)
    local auctionPrice = PaGlobal_WorkerAuction_All._workerAuctionInfo:getWorkerAuctionPrice(workerNoRaw)
    local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYCONFIRM")
    local contentString = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYCONFIRM_TITLE", "level", tostring(workerInfo.level), "name", workerInfo.name, "price", makeDotMoney(workerInfo.maxPrice)) .. "<PAOldColor>"
    local messageboxData = {
      title = titleString,
      content = contentString,
      functionYes = PaGlobalFunc_WorkerAuction_All_BuyConfirm,
      functionCancel = PaGlobalFunc_WorkerAuction_All_SetTempShow,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function PaGlobalFunc_WorkerAuction_All_BuyConfirm()
  if nil == Panel_Window_WorkerAuction_All or nil == PaGlobal_WorkerAuction_All._selectedWorker or PaGlobal_WorkerAuction_All._selectedWorker < 0 then
    return
  end
  PaGlobalFunc_WorkerAuction_All_SetTempShow(true)
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  if true == PaGlobal_WorkerAuction_All._ui._rdo_WareMoney:IsCheck() then
    fromWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  local auctionInfo = PaGlobal_WorkerAuction_All._workerAuctionInfo
  local workerNoRaw = auctionInfo:getWorkerAuction(PaGlobal_WorkerAuction_All._selectedWorker)
  auctionInfo:requestBuyItNowWorker(workerNoRaw, fromWhereType)
  PaGlobal_WorkerAuction_All._selectedWorker = nil
end
function HandleEventLUp_WorkerAuction_All_RegistWorker(workerIdx)
  if nil == Panel_Window_WorkerAuction_All or nil == workerIdx or workerIdx < 0 then
    return
  end
  local listCount = 0
  if nil ~= PaGlobal_WorkerAuction_All._plantKey then
    listCount = ToClient_getPlantWaitWorkerListCount(PaGlobal_WorkerAuction_All._plantKey, 0)
  end
  if listCount <= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_NOWORKER"))
    return
  end
  PaGlobal_WorkerAuction_All._selectedWorker = workerIdx
  local workerInfo
  workerInfo = PaGlobal_WorkerAuction_All:getWorkerInfo(workerIdx, false)
  if nil ~= workerInfo then
    do
      local transferType = 0
      local function requestRegist()
        PaGlobalFunc_WorkerAuction_All_SetTempShow(true)
        ToClient_requestRegisterNpcWorkerAuction(workerInfo.workerNo, transferType, workerInfo.maxPrice)
        PaGlobal_WorkerAuction_All._selectedWorker = nil
      end
      local titleString = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVANT_NAMING_INPUT_TITLE")
      local contentString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PANEL_WORKERRESIST_AUCTION_DESC", "per", tostring(PaGlobal_WorkerAuction_All._config._REGIST_WORKER_FEE))
      local messageboxData = {
        title = titleString,
        content = contentString,
        functionYes = requestRegist,
        functionCancel = PaGlobalFunc_WorkerAuction_All_SetTempShow,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      PaGlobalFunc_WorkerAuction_All_SetTempShow(false)
      MessageBox.showMessageBox(messageboxData)
    end
  end
end
function HandleEventLUp_WorkerAuction_All_CancelRegistWorker(workerIdx)
  if nil == Panel_Window_WorkerAuction_All or nil == workerIdx or workerIdx < 0 then
    return
  end
  PaGlobal_WorkerAuction_All._selectedWorker = workerIdx
  local workerInfo
  workerInfo = PaGlobal_WorkerAuction_All:getWorkerInfo(workerIdx, true)
  if nil ~= workerInfo then
    local function CancelRegistered_Worker()
      PaGlobalFunc_WorkerAuction_All_SetTempShow(true)
      ToClient_requestCancelRegisterMyWorkerAuction(workerInfo.workerNo)
      PaGlobal_WorkerAuction_All._selectedWorker = nil
    end
    local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_CANCELCONFIRM")
    local contentString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_CANCELCONFIRM_TITLE", "level", workerInfo.level, "name", workerInfo.name) .. "<PAOldColor>"
    local messageboxData = {
      title = titleString,
      content = contentString,
      functionYes = CancelRegistered_Worker,
      functionCancel = PaGlobalFunc_WorkerAuction_All_SetTempShow,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    PaGlobalFunc_WorkerAuction_All_SetTempShow(false)
    MessageBox.showMessageBox(messageboxData)
  end
end
function HandleEventLUp_WorkerAuction_All_ReceiveMoney(workerIdx)
  if nil == Panel_Window_WorkerAuction_All or nil == workerIdx or workerIdx < 0 then
    return
  end
  local workerInfo
  local auctionInfo = PaGlobal_WorkerAuction_All._workerAuctionInfo
  workerInfo = PaGlobal_WorkerAuction_All:getWorkerInfo(workerIdx, true)
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  if true == PaGlobal_WorkerAuction_All._ui._rdo_WareMoney:IsCheck() then
    fromWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  auctionInfo:requestPopWorkerPrice(workerInfo.workerNo, fromWhereType)
end
function PaGlobalFunc_WorkerAuction_All_ChangeTabByPad(idx)
  if nil == Panel_Window_WorkerAuction_All or false == Panel_Window_WorkerAuction_All:GetShow() or false == PaGlobal_WorkerAuction_All._isConsole then
    return
  end
  local resultTab = PaGlobal_WorkerAuction_All._selectedTab + idx
  if resultTab <= -1 then
    resultTab = 2
  elseif resultTab >= 3 then
    resultTab = 0
  else
    HandleEventLUp_WorkerAuction_All_TabButtonClick(resultTab)
    return
  end
  HandleEventLUp_WorkerAuction_All_TabButtonClick(resultTab)
end
function HandleEventLUp_WorkerAuction_All_ChangePage(changeValue)
  if nil == Panel_Window_WorkerAuction_All or false == Panel_Window_WorkerAuction_All:GetShow() then
    return
  end
  local pageIndex = PaGlobal_WorkerAuction_All._currentPage + changeValue
  if pageIndex < 1 then
    pageIndex = 1
  end
  if PaGlobal_WorkerAuction_All._ENUMTABINDEX_MARKETLIST == PaGlobal_WorkerAuction_All._selectedTab then
    if pageIndex < PaGlobal_WorkerAuction_All._currentPage then
      RequestAuctionPrevPage()
    elseif pageIndex > PaGlobal_WorkerAuction_All._currentPage then
      local workerCountPerSlot = RequestGetAuctionInfo():getWorkerAuctionCount()
      if workerCountPerSlot >= 4 then
        RequestAuctionNextPage()
      else
        return
      end
    end
  elseif pageIndex >= PaGlobal_WorkerAuction_All._maxPage then
    pageIndex = PaGlobal_WorkerAuction_All._maxPage
  end
  if PaGlobal_WorkerAuction_All._currentPage == pageIndex then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  PaGlobal_WorkerAuction_All._currentPage = pageIndex
  PaGlobal_WorkerAuction_All:update(PaGlobal_WorkerAuction_All._selectedTab)
  ToClient_padSnapResetControl()
end
function HandleEventOnOut_WorkerAuction_All_ChangePage(isShow, slotidx, iconIdx, WorkerIdx, isRegisteredMyWorkerList)
  if nil == Panel_Window_WorkerAuction_All or false == Panel_Window_WorkerAuction_All:GetShow() then
    return
  end
  if true == isShow then
    local slot = PaGlobal_WorkerAuction_All._slotList[slotidx]
    local workerInfo = PaGlobal_WorkerAuction_All:getWorkerInfo(WorkerIdx, isRegisteredMyWorkerList)
    if nil ~= workerInfo then
      local skillSSW = workerInfo.workerWrapperLua:getSkillSSW(iconIdx - 1)
      local uiControl = slot.icon[iconIdx]
      local name = skillSSW:getName()
      local desc = skillSSW:getDescription()
      TooltipSimple_Show(uiControl, name, desc)
    end
  else
    TooltipSimple_Hide()
  end
end
function FromClient_RegisterDone()
  if nil == Panel_Window_WorkerAuction_All or false == Panel_Window_WorkerAuction_All:GetShow() then
    return
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_REGISTCOMPLETE"))
  RequestAuctionListPage(CppEnums.AuctionType.AuctionGoods_WorkerNpc)
end
function FromClient_ReceiveMoneyDone()
  if nil == Panel_Window_WorkerAuction_All or false == Panel_Window_WorkerAuction_All:GetShow() then
    return
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_RECEIVE_PRICE"))
  requestMyWorkerList()
end
function FromClient_CancelRegistDone()
  if nil == Panel_Window_WorkerAuction_All or false == Panel_Window_WorkerAuction_All:GetShow() then
    return
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_COMPLETE_CANCELREGIST"))
  requestMyWorkerList()
end
function FromClient_BuyWorkerDone()
  if nil == Panel_Window_WorkerAuction_All or false == Panel_Window_WorkerAuction_All:GetShow() then
    return
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYCOMPLETE"))
  RequestAuctionListPage(CppEnums.AuctionType.AuctionGoods_WorkerNpc)
end
