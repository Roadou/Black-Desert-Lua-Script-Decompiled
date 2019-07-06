function PaGlobal_WorkerRandomSelect_All:initialize()
  if nil == Panel_Window_WorkerRandomSelect_All or true == PaGlobal_WorkerRandomSelect_All._initialize then
    return
  end
  PaGlobal_WorkerRandomSelect_All._ui._stc_TitleBg = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "Static_MainTitleBar")
  PaGlobal_WorkerRandomSelect_All._ui._btn_Close_PC = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_TitleBg, "Button_Close_PCUI")
  PaGlobal_WorkerRandomSelect_All._ui._btn_Question_PC = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_TitleBg, "Button_Question_PCUI")
  PaGlobal_WorkerRandomSelect_All._ui._stc_ImgBg = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "Static_ImageBg")
  PaGlobal_WorkerRandomSelect_All._ui._stc_WokerImg = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_ImgBg, "Static_WorkerImage")
  PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerName = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "StaticText_WorkerType")
  PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerSpeed = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "StaticText_WorkSpeedValue")
  PaGlobal_WorkerRandomSelect_All._ui._txt_WokrerMoveSpeed = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "StaticText_MoveSpeedValue")
  PaGlobal_WorkerRandomSelect_All._ui._txt_WokrerLuck = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "StaticText_LuckValue")
  PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerActionPoint = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "StaticText_ActionPointValue")
  PaGlobal_WorkerRandomSelect_All._ui._stc_WorkerEmployBg = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "Static_LeftEmploymentCountBg")
  PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerEmployCount = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_WorkerEmployBg, "StaticText_Value")
  PaGlobal_WorkerRandomSelect_All._ui._stc_CurrentEnergyBg = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "Static_CurrentEnergyBg")
  PaGlobal_WorkerRandomSelect_All._ui._icon_CurrentEnergy = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_CurrentEnergyBg, "Static_EnergyIcon")
  PaGlobal_WorkerRandomSelect_All._ui._txt_CurrentEnergy = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_CurrentEnergyBg, "StaticText_Value")
  PaGlobal_WorkerRandomSelect_All._ui._stc_WorkerHireFeeBg = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "Static_HireCostBg")
  PaGlobal_WorkerRandomSelect_All._ui._icon_WorkerHireFee = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_WorkerHireFeeBg, "Static_MoneyIcon")
  PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerHireFee = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_WorkerHireFeeBg, "StaticText_Value")
  PaGlobal_WorkerRandomSelect_All._ui._rdo_InvenMoney = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "RadioButton_InvenMoney")
  PaGlobal_WorkerRandomSelect_All._ui._rdo_WareMoney = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "RadioButton_WarehouseMoney")
  PaGlobal_WorkerRandomSelect_All._ui._txt_InvenMoney = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._rdo_InvenMoney, "StaticText_InvenMoneyValue")
  PaGlobal_WorkerRandomSelect_All._ui._txt_WareMoney = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._rdo_WareMoney, "StaticText_WarehouseMoenyValue")
  PaGlobal_WorkerRandomSelect_All._ui._btn_Continuation_PC = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "Button_Continuation_PCUI")
  PaGlobal_WorkerRandomSelect_All._ui._btn_OtherWorker_PC = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "Button_Other_PCUI")
  PaGlobal_WorkerRandomSelect_All._ui._btn_HireWorker_PC = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "Button_Hire_PCUI")
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuideBg = UI.getChildControl(Panel_Window_WorkerRandomSelect_All, "Static_BottomBG_ConsoleUI")
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_A = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuideBg, "StaticText_A_ConsoleUI")
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_B = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuideBg, "StaticText_B_ConsoleUI")
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_X = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuideBg, "StaticText_X_ConsoleUI")
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_Y = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuideBg, "StaticText_Y_ConsoleUI")
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_X_With_RT = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuideBg, "StaticText_X_With_RT_ConsoleUI")
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_RT_With_X = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_X_With_RT, "StaticText_RT_With_X_ConsoleUI")
  PaGlobal_WorkerRandomSelect_All._ui._stc_Plus_ConsoleUI = UI.getChildControl(PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_X_With_RT, "Static_Plus_ConsoleUI")
  PaGlobal_WorkerRandomSelect_All._isConsole = ToClient_isConsole()
  PaGlobal_WorkerRandomSelect_All:validate()
  PaGlobal_WorkerRandomSelect_All:setUIControl()
  PaGlobal_WorkerRandomSelect_All:registerEventHandler()
end
function PaGlobal_WorkerRandomSelect_All:setUIControl()
  if nil == Panel_Window_WorkerRandomSelect_All then
    return
  end
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuideBg:SetShow(PaGlobal_WorkerRandomSelect_All._isConsole)
  PaGlobal_WorkerRandomSelect_All._ui._btn_Continuation_PC:SetShow(not PaGlobal_WorkerRandomSelect_All._isConsole)
  PaGlobal_WorkerRandomSelect_All._ui._btn_OtherWorker_PC:SetShow(not PaGlobal_WorkerRandomSelect_All._isConsole)
  PaGlobal_WorkerRandomSelect_All._ui._btn_HireWorker_PC:SetShow(not PaGlobal_WorkerRandomSelect_All._isConsole)
  PaGlobal_WorkerRandomSelect_All._ui._btn_Close_PC:SetShow(not PaGlobal_WorkerRandomSelect_All._isConsole)
  PaGlobal_WorkerRandomSelect_All._ui._btn_Question_PC:SetShow(not PaGlobal_WorkerRandomSelect_All._isConsole)
  local pcButtonSizeY = PaGlobal_WorkerRandomSelect_All._ui._btn_Continuation_PC:GetSizeY()
  local pcButtonSizeX = PaGlobal_WorkerRandomSelect_All._ui._btn_Continuation_PC:GetSizeY()
  local panelSizeY = Panel_Window_WorkerRandomSelect_All:GetSizeY()
  local panelSizeX = Panel_Window_WorkerRandomSelect_All:GetSizeX()
  if true == PaGlobal_WorkerRandomSelect_All._isConsole then
    Panel_Window_WorkerRandomSelect_All:SetSize(panelSizeX, panelSizeY - (pcButtonSizeY + 10))
    panelSizeY = Panel_Window_WorkerRandomSelect_All:GetSizeY()
    local keyGuidesSpanX = PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuideBg:GetSpanSize().x
    PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuideBg:SetPosY(panelSizeY - 10)
    PaGlobal_WorkerRandomSelect_All._keyGuides = {
      PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_X_With_RT,
      PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_Y,
      PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_X,
      PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_A,
      PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_B
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_WorkerRandomSelect_All._keyGuides, PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuideBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  end
end
function PaGlobal_WorkerRandomSelect_All:validate()
  if nil == Panel_Window_WorkerRandomSelect_All then
    return
  end
  PaGlobal_WorkerRandomSelect_All._ui._stc_TitleBg:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._btn_Close_PC:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._btn_Question_PC:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._stc_ImgBg:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._stc_WokerImg:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerName:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerSpeed:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._txt_WokrerMoveSpeed:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._txt_WokrerLuck:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerActionPoint:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._stc_WorkerEmployBg:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerEmployCount:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._stc_CurrentEnergyBg:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._icon_CurrentEnergy:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._txt_CurrentEnergy:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._stc_WorkerHireFeeBg:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._icon_WorkerHireFee:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerHireFee:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._rdo_InvenMoney:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._rdo_WareMoney:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._txt_InvenMoney:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._txt_WareMoney:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._btn_Continuation_PC:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._btn_OtherWorker_PC:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._btn_HireWorker_PC:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuideBg:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_A:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_B:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_X:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_Y:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_X_With_RT:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_RT_With_X:isValidate()
  PaGlobal_WorkerRandomSelect_All._ui._stc_Plus_ConsoleUI:isValidate()
  PaGlobal_WorkerRandomSelect_All._initialize = true
end
function PaGlobal_WorkerRandomSelect_All:registerEventHandler()
  if nil ~= Panel_Window_WorkerRandomSelect_All and true == PaGlobal_WorkerRandomSelect_All._initialize then
    registerEvent("onScreenResize", "FromClient_WorkerRandomSelectOption_OnScreenResize()")
    registerEvent("FromClient_EventRandomShopShow", "FromClient_EventRandomShopShow_Worker()")
    if false == PaGlobal_WorkerRandomSelect_All._isConsole then
      if nil ~= Panel_Window_WorkerRandomSelectOption_All then
        PaGlobal_WorkerRandomSelect_All._ui._btn_Continuation_PC:addInputEvent("Mouse_LUp", "HandleEventLUp_WorkerRandomSelectOption_All_Open()")
      end
      PaGlobal_WorkerRandomSelect_All._ui._btn_Continuation_PC:addInputEvent("Mouse_LUp", "HandleEventLUp_WorkerRandomSelectOption_All_Open()")
      PaGlobal_WorkerRandomSelect_All._ui._btn_OtherWorker_PC:addInputEvent("Mouse_LUp", "HandleEventLUp_WorkerRandomSelect_WorkerReSelect()")
      PaGlobal_WorkerRandomSelect_All._ui._btn_HireWorker_PC:addInputEvent("Mouse_LUp", "HandleEventLUp_WorkerRandomSelect_WorkerSelect()")
      PaGlobal_WorkerRandomSelect_All._ui._btn_Question_PC:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"Worker\" )")
      PaGlobal_WorkerRandomSelect_All._ui._btn_Question_PC:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"Worker\", \"true\")")
      PaGlobal_WorkerRandomSelect_All._ui._btn_Question_PC:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"Worker\", \"false\")")
      PaGlobal_WorkerRandomSelect_All._ui._rdo_InvenMoney:addInputEvent("Mouse_On", "HandleEventOnOut_WorkerRandomSelect_All_SimpleTooltips( 0, true )")
      PaGlobal_WorkerRandomSelect_All._ui._rdo_InvenMoney:addInputEvent("Mouse_Out", "HandleEventOnOut_WorkerRandomSelect_All_SimpleTooltips( false )")
      PaGlobal_WorkerRandomSelect_All._ui._rdo_WareMoney:addInputEvent("Mouse_On", "HandleEventOnOut_WorkerRandomSelect_All_SimpleTooltips( 1, true )")
      PaGlobal_WorkerRandomSelect_All._ui._rdo_WareMoney:addInputEvent("Mouse_Out", "HandleEventOnOut_WorkerRandomSelect_All_SimpleTooltips( false )")
      PaGlobal_WorkerRandomSelect_All._ui._rdo_InvenMoney:setTooltipEventRegistFunc("HandleEventOnOut_WorkerRandomSelect_All_SimpleTooltips( 0, true )")
      PaGlobal_WorkerRandomSelect_All._ui._rdo_WareMoney:setTooltipEventRegistFunc("HandleEventOnOut_WorkerRandomSelect_All_SimpleTooltips( 1, true )")
      PaGlobal_WorkerRandomSelect_All._ui._btn_Close_PC:addInputEvent("Mouse_LUp", "HandleEventLUp_WorkerRandomSelect_All_Close()")
    else
      Panel_Window_WorkerRandomSelect_All:registerPadEvent(__eConsoleUIPadEvent_RTPress_X, "HandleEventLUp_WorkerRandomSelectOption_All_Open()")
      Panel_Window_WorkerRandomSelect_All:registerPadEvent(__eConsoleUIPadEvent_Up_X, "HandleEventLUp_WorkerRandomSelect_WorkerReSelect()")
      Panel_Window_WorkerRandomSelect_All:registerPadEvent(__eConsoleUIPadEvent_Y, "HandleEventLUp_WorkerRandomSelect_WorkerSelect()")
    end
  end
end
function PaGlobal_WorkerRandomSelect_All:onScreenResize()
  if nil == Panel_Window_WorkerRandomSelect_All then
    return
  end
  Panel_Window_WorkerRandomSelect_All:ComputePos()
end
function PaGlobal_WorkerRandomSelect_All:prepareClose()
  if nil == Panel_Window_WorkerRandomSelect_All and false == Panel_Window_WorkerRandomSelect_All:GetShow() then
    return
  end
  PaGlobal_WorkerRandomSelect_All:clearData()
  PaGlobal_WorkerRandomSelect_All:close()
end
function PaGlobal_WorkerRandomSelect_All:clearData()
  if nil == Panel_Window_WorkerRandomSelect_All then
    return
  end
  Panel_Window_WorkerRandomSelect_All:ClearUpdateLuaFunc()
  PaGlobal_WorkerRandomSelect_All:setButtonWhilePerFrame(true)
  PaGlobal_WorkerRandomSelect_All._config._workerGrade = 0
  PaGlobal_WorkerRandomSelect_All._config._repetitionCount = 0
  PaGlobal_WorkerRandomSelect_All._delta_Time = 0
  PaGlobal_WorkerRandomSelect_All._isCurrectWorkerCondition = true
  PaGlobal_WorkerRandomSelect_All._isContinueSelectWorkerStart = false
end
function PaGlobal_WorkerRandomSelect_All:prepareOpen()
  if nil == Panel_Window_WorkerRandomSelect_All or true == Panel_Window_WorkerRandomSelect_All:GetShow() then
    return
  end
  PaGlobal_WorkerRandomSelect_All:clearData()
  PaGlobal_WorkerRandomSelect_All:isAuctionOpen()
  if nil ~= getSelfPlayer() then
    local invenMoney = getSelfPlayer():get():getInventory():getMoney_s64()
    local WareMoney = warehouse_moneyFromNpcShop_s64()
    if invenMoney > WareMoney then
      PaGlobal_WorkerRandomSelect_All._ui._rdo_InvenMoney:SetCheck(true)
      PaGlobal_WorkerRandomSelect_All._ui._rdo_WareMoney:SetCheck(false)
    else
      PaGlobal_WorkerRandomSelect_All._ui._rdo_InvenMoney:SetCheck(false)
      PaGlobal_WorkerRandomSelect_All._ui._rdo_WareMoney:SetCheck(true)
    end
  end
  PaGlobal_WorkerRandomSelect_All:open()
  PaGlobal_WorkerRandomSelect_All:onScreenResize()
end
function PaGlobal_WorkerRandomSelect_All:isAuctionOpen()
  if false == _ContentsGroup_NewUI_XXX then
    if false == PaGlobal_WorkerRandomSelect_All._isConsole then
      if nil ~= Panel_Worker_Auction and true == Panel_Worker_Auction:GetShow() then
        WorkerAuction_Close()
      end
    elseif nil ~= Panel_Dialog_WorkerTrade_Renew and true == Panel_Dialog_WorkerTrade_Renew:GetShow() then
      FGlobal_WorkerTrade_Close()
    end
  elseif nil ~= Panel_Window_WorkerAuction_All and true == Panel_Window_WorkerAuction_All:GetShow() then
    HandleEventLUp_WorkerAuction_All_Close()
  end
end
function PaGlobal_WorkerRandomSelect_All:open()
  if nil ~= Panel_Window_WorkerRandomSelect_All then
    Panel_Window_WorkerRandomSelect_All:SetShow(true)
  end
end
function PaGlobal_WorkerRandomSelect_All:close()
  if nil ~= Panel_Window_WorkerRandomSelect_All then
    Panel_Window_WorkerRandomSelect_All:SetShow(false)
  end
end
function PaGlobal_WorkerRandomSelect_All:update(slotNo)
  if nil == Panel_Window_WorkerRandomSelect_All then
    return
  end
  if nil == slotNo or slotNo < 0 then
    PaGlobal_WorkerRandomSelect_All:close()
    return
  end
  PaGlobal_WorkerRandomSelect_All:setWorkerInfo(slotNo)
  PaGlobal_WorkerRandomSelect_All:updateMoney()
end
function PaGlobal_WorkerRandomSelect_All:setWorkerInfo(slotNo)
  if nil == Panel_Window_WorkerRandomSelect_All then
    return
  end
  local sellCount = npcShop_getBuyCount()
  if nil == getSelfPlayer() then
    return
  end
  local selfPlayer = getSelfPlayer()
  local pcPosition = selfPlayer:get():getPosition()
  local regionInfo = getRegionInfoByPosition(pcPosition)
  local MyWp = selfPlayer:getWp()
  local regionPlantKey = regionInfo:getPlantKeyByWaypointKey()
  if nil == regionPlantKey then
    return
  end
  local waitWorkerCount = ToClient_getPlantWaitWorkerListCount(regionPlantKey, 0)
  local maxWorkerCount = ToClient_getTownWorkerMaxCapacity(regionPlantKey)
  for index = 0, sellCount - 1 do
    local itemwrapper = npcShop_getItemBuy(index)
    local shopItem = itemwrapper:get()
    if slotNo == shopItem.shopSlotNo then
      PaGlobal_WorkerRandomSelect_All._currentWorkerinfo = {}
      PaGlobal_WorkerRandomSelect_All._currentWorkerinfo._workerIdx = shopItem.shopSlotNo
      PaGlobal_WorkerRandomSelect_All._currentWorkerinfo._workerPrice64 = shopItem.price_s64
      local plantWorkerSS = itemwrapper:getPlantWorkerStaticStatus()
      local efficiency = plantWorkerSS:getEfficiency(2, ItemExchangeKey(0))
      local plantWorkerGrade = plantWorkerSS:getCharacterStaticStatus()._gradeType:get()
      local workerName = getWorkerName(plantWorkerSS)
      local workerNameByGrade = PaGlobal_WorkerRandomSelect_All:setNameByGrade(workerName, plantWorkerGrade)
      if nil ~= plantWorkerSS then
        local workerIconPath = getWorkerIcon(plantWorkerSS)
        PaGlobal_WorkerRandomSelect_All._ui._stc_WokerImg:ChangeTextureInfoName(workerIconPath)
        PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerActionPoint:SetText(plantWorkerSS._actionPoint)
        PaGlobal_WorkerRandomSelect_All._ui._txt_WokrerLuck:SetText(plantWorkerSS._luck / 10000)
        PaGlobal_WorkerRandomSelect_All._ui._txt_WokrerMoveSpeed:SetText(plantWorkerSS._moveSpeed / 100)
        PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerSpeed:SetText(efficiency / 1000000)
        PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerHireFee:SetText(makeDotMoney(shopItem.price_s64))
        PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerName:SetText(workerNameByGrade)
      end
      local workerFeeText = PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerHireFee
      local workerIcon = PaGlobal_WorkerRandomSelect_All._ui._icon_WorkerHireFee
      workerIcon:SetPosX(workerFeeText:GetPosX() + workerFeeText:GetSizeX() - workerFeeText:GetTextSizeX() - workerIcon:GetSizeX() - 5)
      PaGlobal_WorkerRandomSelect_All._ui._txt_WorkerEmployCount:SetText(maxWorkerCount - waitWorkerCount)
      break
    end
  end
  PaGlobal_WorkerRandomSelect_All:updateWp()
  if MyWp < 10 then
    PaGlobal_WorkerRandomSelect_All._ui._btn_OtherWorker_PC:SetEnable(false)
    PaGlobal_WorkerRandomSelect_All._ui._btn_OtherWorker_PC:SetMonoTone(true)
    PaGlobal_WorkerRandomSelect_All._ui._btn_Continuation_PC:SetEnable(false)
    PaGlobal_WorkerRandomSelect_All._ui._btn_Continuation_PC:SetMonoTone(true)
  else
    PaGlobal_WorkerRandomSelect_All._ui._btn_OtherWorker_PC:SetEnable(true)
    PaGlobal_WorkerRandomSelect_All._ui._btn_OtherWorker_PC:SetMonoTone(false)
    PaGlobal_WorkerRandomSelect_All._ui._btn_Continuation_PC:SetEnable(true)
    PaGlobal_WorkerRandomSelect_All._ui._btn_Continuation_PC:SetMonoTone(false)
  end
  if ToClient_HasWareHouseFromNpc() then
    if toInt64(0, 0) == warehouse_moneyFromNpcShop_s64() then
      PaGlobal_WorkerRandomSelect_All._ui._rdo_InvenMoney:SetCheck(true)
      PaGlobal_WorkerRandomSelect_All._ui._rdo_WareMoney:SetCheck(false)
    else
      PaGlobal_WorkerRandomSelect_All._ui._rdo_InvenMoney:SetCheck(false)
      PaGlobal_WorkerRandomSelect_All._ui._rdo_WareMoney:SetCheck(true)
    end
  else
    PaGlobal_WorkerRandomSelect_All._ui._txt_InvenMoney:SetCheck(true)
    PaGlobal_WorkerRandomSelect_All._ui._txt_WareMoney:SetCheck(true)
  end
end
function PaGlobal_WorkerRandomSelect_All:setNameByGrade(name, plantWorkerGrade)
  if nil == Panel_Window_WorkerRandomSelect_All then
    return
  end
  if CppEnums.CharacterGradeType.CharacterGradeType_Normal == plantWorkerGrade then
    return "<PAColor0xFFB9C2DC>" .. name .. "<PAOldColor>"
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Elite == plantWorkerGrade then
    return "<PAColor0xFF83A543>" .. name .. "<PAOldColor>"
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Hero == plantWorkerGrade then
    return "<PAColor0xFF438DCC>" .. name .. "<PAOldColor>"
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Legend == plantWorkerGrade then
    return "<PAColor0xFFF5BA3A>" .. name .. "<PAOldColor>"
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Boss == plantWorkerGrade then
    return "<PAColor0xFFD05D48>" .. name .. "<PAOldColor>"
  elseif CppEnums.CharacterGradeType.CharacterGradeType_Assistant == plantWorkerGrade then
    return "<PAColor0xFFB9C2DC>" .. name .. "<PAOldColor>"
  else
    return "<PAColor0xFFB9C2DC>" .. name .. "<PAOldColor>"
  end
end
function PaGlobal_WorkerRandomSelect_All:updateMoney()
  if nil == Panel_Window_WorkerRandomSelect_All then
    return
  end
  if nil ~= getSelfPlayer() then
    PaGlobal_WorkerRandomSelect_All._ui._txt_InvenMoney:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
    PaGlobal_WorkerRandomSelect_All._ui._txt_WareMoney:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
  end
end
function PaGlobal_WorkerRandomSelect_All:updateWp()
  if nil == Panel_Window_WorkerRandomSelect_All then
    return
  end
  if nil ~= getSelfPlayer() then
    local selfPlayer = getSelfPlayer()
    local MyWp = selfPlayer:getWp()
    if MyWp < 0 then
      MyWp = 0
    end
    local HIRECOST = PaGlobal_WorkerRandomSelect_All._HIRECOST
    local wpIcon = PaGlobal_WorkerRandomSelect_All._ui._icon_CurrentEnergy
    local wpText = PaGlobal_WorkerRandomSelect_All._ui._txt_CurrentEnergy
    wpText:SetText(MyWp - HIRECOST)
    wpIcon:SetPosX(wpText:GetPosX() + wpText:GetSizeX() - wpText:GetTextSizeX() - wpIcon:GetSizeX() - 5)
  end
end
function PaGlobal_WorkerRandomSelect_All:setButtonWhilePerFrame(value)
  if nil == Panel_Window_WorkerRandomSelect_All then
    return
  end
  if nil == value then
    value = true
  end
  if false == PaGlobal_WorkerRandomSelect_All._isConsole then
    local otherSelectBtn = PaGlobal_WorkerRandomSelect_All._ui._btn_OtherWorker_PC
    local ContinuationBtn = PaGlobal_WorkerRandomSelect_All._ui._btn_Continuation_PC
    if true == value then
      otherSelectBtn:SetEnable(true)
      otherSelectBtn:SetMonoTone(false)
      ContinuationBtn:SetEnable(true)
      ContinuationBtn:SetMonoTone(false)
    else
      otherSelectBtn:SetEnable(false)
      otherSelectBtn:SetMonoTone(true)
      ContinuationBtn:SetEnable(false)
      ContinuationBtn:SetMonoTone(true)
    end
  elseif true == value then
    Panel_Window_WorkerRandomSelect_All:registerPadEvent(__eConsoleUIPadEvent_RTPress_X, "HandleEventLUp_WorkerRandomSelectOption_All_Open()")
    Panel_Window_WorkerRandomSelect_All:registerPadEvent(__eConsoleUIPadEvent_Up_X, "HandleEventLUp_WorkerRandomSelect_WorkerReSelect()")
    Panel_Window_WorkerRandomSelect_All:registerPadEvent(__eConsoleUIPadEvent_Y, "HandleEventLUp_WorkerRandomSelect_WorkerSelect()")
    PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_X_With_RT:SetShow(true)
    PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_Y:SetShow(true)
    PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_X:SetShow(true)
    PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_A:SetShow(true)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_WorkerRandomSelect_All._keyGuides, PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuideBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  else
    Panel_Window_WorkerRandomSelect_All:registerPadEvent(__eConsoleUIPadEvent_RTPress_X, "")
    Panel_Window_WorkerRandomSelect_All:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
    Panel_Window_WorkerRandomSelect_All:registerPadEvent(__eConsoleUIPadEvent_Y, "")
    PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_X_With_RT:SetShow(false)
    PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_Y:SetShow(false)
    PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_X:SetShow(false)
    PaGlobal_WorkerRandomSelect_All._ui._stc_KeyGuide_A:SetShow(false)
  end
end
