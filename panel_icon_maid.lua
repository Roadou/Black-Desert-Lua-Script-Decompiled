Panel_Icon_Maid:SetShow(false)
Panel_Icon_Maid:ActiveMouseEventEffect(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local IM = CppEnums.EProcessorInputMode
local isEnableMaid = ToClient_IsContentsGroupOpen("355")
local isOpenMarketPlace = _ContentsGroup_RenewUI_ItemMarketPlace
local MaidControl = {
  buttonMaid = UI.getChildControl(Panel_Icon_Maid, "Button_MaidIcon")
}
MaidControl.buttonMaid:addInputEvent("Mouse_LUp", "MaidList_Open()")
MaidControl.buttonMaid:addInputEvent("Mouse_On", "MaidFunc_ShowTooltip( true )")
MaidControl.buttonMaid:addInputEvent("Mouse_Out", "MaidFunc_ShowTooltip()")
MaidControl.buttonMaid:ActiveMouseEventEffect(true)
Panel_Window_MaidList:SetShow(false)
Panel_Window_MaidList:setGlassBackground(true)
Panel_Window_MaidList:ActiveMouseEventEffect(true)
local maidList = {
  contentBg = UI.getChildControl(Panel_Window_MaidList, "Static_MaidListContentBG"),
  title = UI.getChildControl(Panel_Window_MaidList, "StaticText_MaidTitle"),
  name = UI.getChildControl(Panel_Window_MaidList, "StaticText_Name"),
  town = UI.getChildControl(Panel_Window_MaidList, "StaticText_Town"),
  func = UI.getChildControl(Panel_Window_MaidList, "StaticText_Func"),
  coolTime = UI.getChildControl(Panel_Window_MaidList, "StaticText_Cooltime"),
  btnWarehouse = UI.getChildControl(Panel_Window_MaidList, "Button_SummonMaid_Warehouse"),
  btnMarket = UI.getChildControl(Panel_Window_MaidList, "Button_SummonMaid_Market"),
  btnMarketPlace = UI.getChildControl(Panel_Window_MaidList, "Button_SummonMaid_MarketPlace"),
  albeCount = UI.getChildControl(Panel_Window_MaidList, "StaticText_LeftMaidCount"),
  albeCountValue = UI.getChildControl(Panel_Window_MaidList, "StaticText_LeftMaidCountValue"),
  scroll = UI.getChildControl(Panel_Window_MaidList, "Scroll_MaidList"),
  radioAll = UI.getChildControl(Panel_Window_MaidList, "RadioButton_All"),
  radioWarehouse = UI.getChildControl(Panel_Window_MaidList, "RadioButton_Warehouse"),
  radioMarket = UI.getChildControl(Panel_Window_MaidList, "RadioButton_Itemmarket"),
  btnPcRoomRegist = UI.getChildControl(Panel_Window_MaidList, "Button_PCRoomRegist"),
  config = {
    gapY = 25,
    normalSizeY = 155,
    spanSizeGapX = 155
  },
  maidInfo = {},
  wareHouseMaidInfo = {},
  marketMaidInfo = {},
  maxShowCount = 9,
  startIndex = 0,
  scrollInterval = 0,
  startSpanSizeX = 0
}
local warehouseMaidCount = 0
local marketMaidCount = 0
local albeWarehouseMaidCount = 0
local albeMarketMaidCount = 0
maidList.headLineBg = UI.getChildControl(maidList.contentBg, "Static_MaidListHead_BG")
maidList.titleName = UI.getChildControl(maidList.headLineBg, "StaticText_TitleName")
maidList.titleFunc = UI.getChildControl(maidList.headLineBg, "StaticText_TitleFunc")
maidList.titleCoolTime = UI.getChildControl(maidList.headLineBg, "StaticText_TitleCooltime")
maidList.btnClose = UI.getChildControl(maidList.title, "Button_Close")
maidList.scrollCtrlBtn = UI.getChildControl(maidList.scroll, "Scroll_CtrlButton")
maidList.scrollCtrlBtn:addInputEvent("Mouse_LPress", "HandleClicked_MaidList_ScrollBtn()")
maidList.btnClose:addInputEvent("Mouse_LUp", "MaidList_Close()")
maidList.contentBg:addInputEvent("Mouse_DownScroll", "MaidList_ScrollEvent( true )")
maidList.contentBg:addInputEvent("Mouse_UpScroll", "MaidList_ScrollEvent( false )")
maidList.scroll:addInputEvent("Mouse_LPress", "HandleClicked_MaidList_ScrollBtn()")
maidList.radioAll:addInputEvent("Mouse_LUp", "MaidListUpdate()")
maidList.radioWarehouse:addInputEvent("Mouse_LUp", "MaidListUpdate()")
maidList.radioMarket:addInputEvent("Mouse_LUp", "MaidListUpdate()")
maidList.btnPcRoomRegist:addInputEvent("Mouse_LUp", "HandleEventLUp_IconMaid_pcRoomRegistButtonClick()")
maidList.btnPcRoomRegist:addInputEvent("Mouse_On", "PaGloabl_MaidList_PcRoomRegistShowToolTip()")
maidList.btnPcRoomRegist:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
function maidList:Init()
  self.startSpanSizeX = self.btnMarket:GetSpanSize().x
  for maidIndex = 0, self.maxShowCount - 1 do
    local temp = {}
    temp.name = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_MaidList, "StaticText_MaidName_" .. maidIndex)
    CopyBaseProperty(self.name, temp.name)
    temp.name:SetPosY(self.name:GetPosY() + maidIndex * self.config.gapY)
    temp.name:SetShow(false)
    temp.town = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_MaidList, "StaticText_MaidTown_" .. maidIndex)
    CopyBaseProperty(self.town, temp.town)
    temp.town:SetPosY(self.town:GetPosY() + maidIndex * self.config.gapY)
    temp.town:SetShow(false)
    temp.func = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_MaidList, "StaticText_MaidFunc_" .. maidIndex)
    CopyBaseProperty(self.func, temp.func)
    temp.func:SetPosY(self.func:GetPosY() + maidIndex * self.config.gapY)
    temp.func:SetShow(false)
    temp.coolTime = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_MaidList, "StaticText_MaidCoolTime_" .. maidIndex)
    CopyBaseProperty(self.coolTime, temp.coolTime)
    temp.coolTime:SetPosY(self.coolTime:GetPosY() + maidIndex * self.config.gapY)
    temp.coolTime:SetShow(false)
    self.maidInfo[maidIndex] = temp
  end
  maidList:maidTableUpdate()
  self.btnWarehouse:addInputEvent("Mouse_LUp", "FGlobal_WarehouseOpenByMaid(" .. 1 .. ")")
  self.btnWarehouse:addInputEvent("Mouse_On", "ButtonOpenByMaid_SimpleTooltip( true, " .. 0 .. " )")
  self.btnWarehouse:addInputEvent("Mouse_Out", "ButtonOpenByMaid_SimpleTooltip( false, " .. 0 .. " )")
  self.btnMarket:addInputEvent("Mouse_LUp", "FGlobal_WarehouseOpenByMaid(" .. 0 .. ")")
  self.btnMarket:addInputEvent("Mouse_On", "ButtonOpenByMaid_SimpleTooltip( true, " .. 1 .. " )")
  self.btnMarket:addInputEvent("Mouse_Out", "ButtonOpenByMaid_SimpleTooltip( false, " .. 1 .. " )")
  self.btnMarketPlace:SetShow(false)
  self.btnMarketPlace:addInputEvent("Mouse_LUp", "FGlobal_WarehouseOpenByMaid(" .. 2 .. ")")
  self.btnMarketPlace:addInputEvent("Mouse_On", "ButtonOpenByMaid_SimpleTooltip( true, " .. 2 .. " )")
  self.btnMarketPlace:addInputEvent("Mouse_Out", "ButtonOpenByMaid_SimpleTooltip( false, " .. 2 .. " )")
  if isEnableMaid then
    self.btnWarehouse:setButtonShortcuts("PANEL_MAIDLIST_OPEN_WAREHOUSE")
    if true == isOpenMarketPlace then
      self.btnMarketPlace:setButtonShortcuts("PANEL_MAIDLIST_OPEN_MARKETPLACE")
    else
      self.btnMarket:setButtonShortcuts("PANEL_MAIDLIST_OPEN_ITEMMARKET")
    end
  end
  self.radioAll:SetCheck(true)
  self.radioWarehouse:SetCheck(false)
  self.radioMarket:SetCheck(false)
  if true == isOpenMarketPlace then
    PaGlobalFunc_IconMaid_SettingForMarketPlace()
  end
end
function maidList:maidUICooltimeUpdate(maidInfoWrapper, realIndex)
  if nil ~= maidInfoWrapper then
    local coolTime = maidInfoWrapper:getCoolTime()
    if coolTime > 0 then
      self.maidInfo[realIndex].coolTime:SetFontColor(Defines.Color.C_FFC4BEBE)
      local oneMinute = 60
      if coolTime < oneMinute then
        self.maidInfo[realIndex].coolTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_ONEMINUTELEFT"))
      else
        self.maidInfo[realIndex].coolTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MAIDLIST_LEFTTIME", "minute", coolTime / oneMinute - coolTime / oneMinute % 1))
      end
    else
      self.maidInfo[realIndex].coolTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_POSSIBLE"))
      self.maidInfo[realIndex].coolTime:SetFontColor(Defines.Color.C_FFC4BEBE)
    end
  end
end
function maidList:maidTableUpdate()
  local wereIndex = 0
  local marketIndex = 0
  for index = 0, getTotalMaidList() - 1 do
    local maidInfoWrapper = getMaidDataByIndex(index)
    if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
      self.wareHouseMaidInfo[wereIndex] = maidInfoWrapper
      wereIndex = wereIndex + 1
    elseif maidInfoWrapper:isAbleSubmitMarket() then
      self.marketMaidInfo[marketIndex] = maidInfoWrapper
      marketIndex = marketIndex + 1
    end
  end
end
function maidList:maidInfoUpadate()
  local self = maidList
  local isWarehouse = self.radioWarehouse:IsCheck()
  local isMarket = self.radioMarket:IsCheck()
  local realIndex = 0
  for index = 0, self.maxShowCount - 1 do
    if nil ~= self.maidInfo[index] then
      self.maidInfo[index].name:SetShow(false)
      self.maidInfo[index].town:SetShow(false)
      self.maidInfo[index].func:SetShow(false)
      self.maidInfo[index].coolTime:SetShow(false)
    end
    if index < getTotalMaidList() and realIndex < self.maxShowCount then
      local maidInfoWrapper, maidFuncString
      if isWarehouse then
        maidInfoWrapper = self.wareHouseMaidInfo[index + self.startIndex]
        maidFuncString = "LUA_MAIDLIST_WAREHOUSE"
      elseif isMarket then
        maidInfoWrapper = self.marketMaidInfo[index + self.startIndex]
        maidFuncString = "LUA_MAIDLIST_MARKET"
      else
        maidInfoWrapper = getMaidDataByIndex(index + self.startIndex)
        if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
          maidFuncString = "LUA_MAIDLIST_WAREHOUSE"
        elseif maidInfoWrapper:isAbleSubmitMarket() then
          maidFuncString = "LUA_MAIDLIST_MARKET"
        else
          maidFuncString = "LUA_MAIDLIST_WAREHOUSE"
        end
      end
      if nil ~= maidInfoWrapper then
        self.maidInfo[realIndex].func:SetText(PAGetString(Defines.StringSheet_GAME, tostring(maidFuncString)))
        self.maidInfo[realIndex].name:SetText(maidInfoWrapper:getName())
        self.maidInfo[realIndex].name:SetShow(true)
        self.maidInfo[realIndex].town:SetShow(false)
        self.maidInfo[realIndex].func:SetShow(true)
        self.maidInfo[realIndex].coolTime:SetShow(true)
        realIndex = realIndex + 1
      end
    end
  end
end
function MaidList_Open()
  if nil == Panel_Window_MaidList then
    return
  end
  local self = maidList
  local maidCount = getTotalMaidList()
  if maidCount > self.maxShowCount or true == getTemporaryInformationWrapper():isPremiumPcRoom() then
    self.scroll:SetShow(true)
  elseif maidCount < 1 then
    _PA_LOG("\236\157\180\235\172\184\236\162\133", "\237\142\152\236\150\180\235\166\172 \236\167\145\236\130\172\234\176\128 0\235\170\133\236\157\180\235\157\188\235\139\136! \236\157\180\235\159\172\236\139\156\235\169\180 \234\179\164\235\158\128\237\149\169\235\139\136\235\139\164!")
    return
  else
    self.scroll:SetShow(false)
  end
  if Panel_Window_MaidList:GetShow() then
    Panel_Window_MaidList:SetShow(false)
  else
    Panel_Window_MaidList:SetShow(true)
  end
  Panel_Window_MaidList:SetPosX(Panel_Icon_Maid:GetPosX() + Panel_Icon_Maid:GetSizeX())
  Panel_Window_MaidList:SetPosY(Panel_Icon_Maid:GetPosY())
  MaidList_Set()
  self:maidInfoUpadate()
  if true == _ContentsGroup_RenewUI_Main then
    Panel_Window_MaidList:SetShow(false)
  end
  if true == ToClient_isShowRegistPcRoomMaidButton() and true == _ContentsGroup_KR_Transfer then
    maidList.btnPcRoomRegist:SetShow(true)
  else
    maidList.btnPcRoomRegist:SetShow(false)
  end
end
function MaidList_Close()
  if nil == Panel_Window_MaidList then
    return
  end
  if Panel_Window_MaidList:GetShow() then
    Panel_Window_MaidList:SetShow(false)
    TooltipSimple_Hide()
  end
end
function MaidList_Set(startIndex)
  local self = maidList
  if not Panel_Icon_Maid:GetShow() and 0 == getTotalMaidList() and not getTemporaryInformationWrapper():isPremiumPcRoom() then
    Panel_Window_MaidList:SetShow(false)
    return
  end
  local currentMaidCount = 0
  for index = 0, getTotalMaidList() - 1 do
    local maidInfoWrapper = getMaidDataByIndex(index)
    if self.radioWarehouse:IsCheck() then
      if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
        currentMaidCount = currentMaidCount + 1
      end
    elseif self.radioMarket:IsCheck() then
      if maidInfoWrapper:isAbleSubmitMarket() then
        currentMaidCount = currentMaidCount + 1
      end
    elseif maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() or maidInfoWrapper:isAbleSubmitMarket() then
      currentMaidCount = currentMaidCount + 1
    end
  end
  if currentMaidCount > self.maxShowCount then
    self.scroll:SetShow(true)
  else
    self.scroll:SetShow(false)
  end
  if nil == startIndex or currentMaidCount <= self.maxShowCount then
    self.startIndex = 0
  end
  if 0 == self.startIndex then
    self.scroll:SetControlPos(0)
  end
end
function MaidListUpdate()
  local self = maidList
  MaidList_Set(0)
  FGlobal_MaidIcon_SetPos(true)
  self:maidInfoUpadate()
end
function MaidCoolTime_Update()
  local self = maidList
  local isWarehouse = self.radioWarehouse:IsCheck()
  local isMarket = self.radioMarket:IsCheck()
  local realIndex = 0
  if nil == getSelfPlayer() then
    return
  end
  for index = 0, self.maxShowCount - 1 do
    local maidInfoWrapper
    if isWarehouse then
      maidInfoWrapper = self.wareHouseMaidInfo[index + self.startIndex]
    elseif isMarket then
      maidInfoWrapper = self.marketMaidInfo[index + self.startIndex]
    else
      maidInfoWrapper = getMaidDataByIndex(index + self.startIndex)
    end
    if nil ~= maidInfoWrapper then
      maidList:maidUICooltimeUpdate(maidInfoWrapper, realIndex)
      realIndex = realIndex + 1
    end
  end
  albeWarehouseMaidCount = 0
  albeMarketMaidCount = 0
  for index = 0, getTotalMaidList() - 1 do
    local maidInfoWrapper = getMaidDataByIndex(index)
    if nil ~= maidInfoWrapper and 0 == maidInfoWrapper:getCoolTime() then
      if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
        albeWarehouseMaidCount = albeWarehouseMaidCount + 1
      end
      if maidInfoWrapper:isAbleSubmitMarket() then
        albeMarketMaidCount = albeMarketMaidCount + 1
      end
    end
  end
  if isWarehouse then
    self.btnWarehouse:SetShow(true)
    self.btnMarket:SetShow(false)
    self.btnMarketPlace:SetShow(false)
    if albeWarehouseMaidCount > 0 then
      self.btnWarehouse:SetIgnore(false)
      self.btnWarehouse:SetMonoTone(false)
      self.btnWarehouse:SetFontColor(Defines.Color.C_FFEFEFEF)
    else
      self.btnWarehouse:SetIgnore(true)
      self.btnWarehouse:SetMonoTone(true)
      self.btnWarehouse:SetFontColor(Defines.Color.C_FFC4BEBE)
    end
    local countValuePos = self.albeCount:GetTextSizeX()
    local ableMaidCount = albeWarehouseMaidCount
    self.albeCountValue:SetPosX(countValuePos)
    self.albeCountValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_DESC_5", "maidCount", ableMaidCount))
  elseif isMarket then
    self.btnWarehouse:SetShow(false)
    self.btnMarket:SetShow(not _ContentsGroup_RenewUI_ItemMarketPlace_Only)
    self.btnMarketPlace:SetShow(true == isOpenMarketPlace)
    if albeMarketMaidCount > 0 then
      self.btnMarketPlace:SetIgnore(false)
      self.btnMarketPlace:SetMonoTone(false)
      self.btnMarketPlace:SetFontColor(Defines.Color.C_FFEFEFEF)
      self.btnMarket:SetIgnore(false)
      self.btnMarket:SetMonoTone(false)
      self.btnMarket:SetFontColor(Defines.Color.C_FFEFEFEF)
    else
      self.btnMarketPlace:SetIgnore(true)
      self.btnMarketPlace:SetMonoTone(true)
      self.btnMarketPlace:SetFontColor(Defines.Color.C_FFC4BEBE)
      self.btnMarket:SetIgnore(true)
      self.btnMarket:SetMonoTone(true)
      self.btnMarket:SetFontColor(Defines.Color.C_FFC4BEBE)
    end
    local countValuePos = self.albeCount:GetTextSizeX()
    local ableMaidCount = albeMarketMaidCount
    self.albeCountValue:SetPosX(countValuePos)
    self.albeCountValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_DESC_5", "maidCount", ableMaidCount))
  else
    self.btnWarehouse:SetShow(true)
    self.btnMarket:SetShow(not _ContentsGroup_RenewUI_ItemMarketPlace_Only)
    self.btnMarketPlace:SetShow(true == isOpenMarketPlace)
    if albeWarehouseMaidCount > 0 then
      self.btnWarehouse:SetIgnore(false)
      self.btnWarehouse:SetMonoTone(false)
      self.btnWarehouse:SetFontColor(Defines.Color.C_FFEFEFEF)
    else
      self.btnWarehouse:SetIgnore(true)
      self.btnWarehouse:SetMonoTone(true)
      self.btnWarehouse:SetFontColor(Defines.Color.C_FFC4BEBE)
    end
    if albeMarketMaidCount > 0 then
      self.btnMarketPlace:SetIgnore(false)
      self.btnMarketPlace:SetMonoTone(false)
      self.btnMarketPlace:SetFontColor(Defines.Color.C_FFEFEFEF)
      self.btnMarket:SetIgnore(false)
      self.btnMarket:SetMonoTone(false)
      self.btnMarket:SetFontColor(Defines.Color.C_FFEFEFEF)
    else
      self.btnMarketPlace:SetIgnore(true)
      self.btnMarketPlace:SetMonoTone(true)
      self.btnMarketPlace:SetFontColor(Defines.Color.C_FFC4BEBE)
      self.btnMarket:SetIgnore(true)
      self.btnMarket:SetMonoTone(true)
      self.btnMarket:SetFontColor(Defines.Color.C_FFC4BEBE)
    end
    local countValuePos = self.albeCount:GetTextSizeX()
    local ableMaidCount = albeWarehouseMaidCount + albeMarketMaidCount
    self.albeCountValue:SetPosX(countValuePos)
    self.albeCountValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_DESC_5", "maidCount", ableMaidCount))
  end
  self:setButtonPos()
end
function maidList:setButtonPos()
  local startPosX = self.startSpanSizeX
  if true == self.btnMarket:GetShow() then
    self.btnMarket:SetSpanSize(startPosX, 8)
    startPosX = startPosX + self.config.spanSizeGapX
  end
  if true == self.btnMarketPlace:GetShow() then
    self.btnMarketPlace:SetSpanSize(startPosX, 8)
    startPosX = startPosX + self.config.spanSizeGapX
  end
  if true == self.btnWarehouse:GetShow() then
    self.btnWarehouse:SetSpanSize(startPosX, 8)
    startPosX = startPosX + self.config.spanSizeGapX
  end
  if true == maidList.btnPcRoomRegist:GetShow() then
    maidList.btnPcRoomRegist:SetSpanSize(startPosX, 8)
    startPosX = startPosX + self.config.spanSizeGapX
  end
end
function MaidList_MaidCount()
  local self = maidList
  warehouseMaidCount = 0
  marketMaidCount = 0
  for index = 0, getTotalMaidList() - 1 do
    local maidInfoWrapper = getMaidDataByIndex(index)
    if nil ~= maidInfoWrapper then
      if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
        warehouseMaidCount = warehouseMaidCount + 1
      elseif maidInfoWrapper:isAbleSubmitMarket() then
        marketMaidCount = marketMaidCount + 1
      end
    end
  end
  if self.radioWarehouse:IsCheck() then
    return warehouseMaidCount
  elseif self.radioMarket:IsCheck() then
    return marketMaidCount
  else
    return warehouseMaidCount + marketMaidCount
  end
end
function MaidList_SetScroll()
  local self = maidList
  local maidCount = MaidList_MaidCount()
  local pagePercent = self.maxShowCount / maidCount * 100
  local scroll_Interval = maidCount - self.maxShowCount
  local scrollSizeY = self.scroll:GetSizeY()
  local btn_scrollSizeY = scrollSizeY / 100 * pagePercent
  if btn_scrollSizeY < 30 then
    btn_scrollSizeY = 30
  end
  if scrollSizeY <= btn_scrollSizeY then
    btn_scrollSizeY = scrollSizeY * 0.99
  end
  self.scrollCtrlBtn:SetSize(self.scrollCtrlBtn:GetSizeX(), btn_scrollSizeY)
  self.scrollInterval = scroll_Interval
  self.scroll:SetInterval(self.scrollInterval)
end
function MaidList_ScrollEvent(isDown)
  local self = maidList
  local maidCount = MaidList_MaidCount()
  if maidCount <= self.maxShowCount then
    return
  end
  local index = self.startIndex
  if true == isDown then
    if index > maidCount - self.maxShowCount + 1 then
      return
    end
    if index < self.scrollInterval then
      self.scroll:ControlButtonDown()
      index = index + 1
    else
      return
    end
  elseif index > 0 then
    self.scroll:ControlButtonUp()
    index = index - 1
  else
    return
  end
  self.startIndex = index
  self:maidInfoUpadate()
  MaidList_Set(self.startIndex)
end
function ButtonOpenByMaid_SimpleTooltip(isShow, tipType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = maidList
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "INTERACTION_MENU10")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_OPENWAREHOUSEBYMAID_DESC") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
    control = self.btnWarehouse
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_MAID_MARKETOPENBYMAID_BUTTON_TOOLTIP")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_OPENMARKETBYMAID_DESC") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
    control = self.btnMarket
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_MAIDLIST_MARKETPLACE_OPEN")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_MARKETPLACE_WALLETINVENTORY_SELLTOOLTIPDESC") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
    control = self.btnMarket
  end
  TooltipSimple_Show(control, name, desc)
end
function HandleClicked_MaidList_ScrollBtn()
  local self = maidList
  local maidCount = MaidList_MaidCount()
  local posByIndex = 1 / (maidCount - self.maxShowCount)
  local currentIndex = math.floor(self.scroll:GetControlPos() / posByIndex)
  self.startIndex = currentIndex
  self:maidInfoUpadate()
  MaidList_Set(self.startIndex)
end
local dontGoMaid = -1
local maidType = -1
function FGlobal_WarehouseOpenByMaid(index)
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
  local warehouseOutMaid = checkMaid_WarehouseOut(true)
  local marketMaid = checkMaid_SubmitMarket(true)
  local enableWarehouseMaid = checkMaid_WarehouseIn(false)
  local enableMarketMaid = checkMaid_SubmitMarket(false)
  if 0 == index then
    if marketMaid then
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
              MaidList_Close()
              maidType = 0
              break
            end
          end
        end
        MaidList_Close()
      else
        for mIndex = 0, getTotalMaidList() - 1 do
          local maidInfoWrapper = getMaidDataByIndex(mIndex)
          if maidInfoWrapper:isAbleSubmitMarket() and 0 == maidInfoWrapper:getCoolTime() then
            ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
            ToClient_CallHandlerMaid("_marketMaid")
            dontGoMaid = mIndex
            MaidList_Close()
            maidType = 0
            break
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
  end
  if 1 == index then
    if warehouseOutMaid or warehouseInMaid then
      if IsSelfPlayerWaitAction() then
        Warehouse_OpenPanelFromMaid()
        if ToClient_CheckExistSummonMaid() and -1 ~= dontGoMaid then
          if 1 == maidType then
            ToClient_CallHandlerMaid("_warehouseMaid")
          else
            for mIndex = 0, getTotalMaidList() - 1 do
              local maidInfoWrapper = getMaidDataByIndex(mIndex)
              if (maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse()) and 0 == maidInfoWrapper:getCoolTime() then
                ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
                ToClient_CallHandlerMaid("_marketMaidLogOut")
                ToClient_CallHandlerMaid("_warehouseMaid")
                dontGoMaid = mIndex
                MaidList_Close()
                maidType = 1
                break
              end
            end
          end
          MaidList_Close()
        else
          for mIndex = 0, getTotalMaidList() - 1 do
            local maidInfoWrapper = getMaidDataByIndex(mIndex)
            if (maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse()) and 0 == maidInfoWrapper:getCoolTime() then
              ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
              ToClient_CallHandlerMaid("_warehouseMaid")
              dontGoMaid = mIndex
              MaidList_Close()
              maidType = 1
              break
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
  if 2 == index then
    if marketMaid then
      PaGlobalFunc_MarketPlace_OpenByMaid()
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
              MaidList_Close()
              maidType = 0
              break
            end
          end
        end
        MaidList_Close()
      else
        for mIndex = 0, getTotalMaidList() - 1 do
          local maidInfoWrapper = getMaidDataByIndex(mIndex)
          if maidInfoWrapper:isAbleSubmitMarket() and 0 == maidInfoWrapper:getCoolTime() then
            ToClient_SummonMaid(maidInfoWrapper:getMaidNo(), 1)
            ToClient_CallHandlerMaid("_marketMaid")
            dontGoMaid = mIndex
            MaidList_Close()
            maidType = 0
            break
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
  end
end
function maidList:setPosAndScrollReset()
  FGlobal_MaidIcon_SetPos(true)
end
function FGlobal_MaidIcon_SetPos(resetScroll)
  if isFlushedUI() or getSelfPlayer():get():getLevel() < 7 then
    return
  end
  if true == _ContentsGroup_RemasterUI_Main then
    PaGlobalFunc_ServantIcon_UpdateMaidIcon(resetScroll)
    return
  end
  local warehouseInMaid = checkMaid_WarehouseIn(true)
  local warehouseOutMaid = checkMaid_WarehouseOut(true)
  local marketMaid = checkMaid_SubmitMarket(true)
  if 0 < getTotalMaidList() then
    if true == _ContentsGroup_RenewUI_Main then
      Panel_Icon_Maid:SetShow(false)
    else
      Panel_Icon_Maid:SetShow(true)
    end
    MaidControl.buttonMaid:EraseAllEffect()
    if warehouseInMaid or warehouseOutMaid or marketMaid then
      MaidControl.buttonMaid:AddEffect("fUI_Maid_01A", false, -1, 2)
    else
      MaidControl.buttonMaid:AddEffect("fUI_Maid_02A", false, -1, 2)
    end
    local posX, posY
    if Panel_Window_PetIcon:GetShow() then
      posX = Panel_Window_PetIcon:GetPosX() + Panel_Window_PetIcon:GetSizeX() - 3
      posY = Panel_Window_PetIcon:GetPosY()
    elseif 0 < FGlobal_HouseIconCount() and Panel_MyHouseNavi:GetShow() then
      posX = Panel_MyHouseNavi:GetPosX() + 60 * FGlobal_HouseIconCount() - 3
      posY = Panel_MyHouseNavi:GetPosY()
    elseif 0 < FGlobal_ServantIconCount() and Panel_Window_Servant:GetShow() then
      posX = Panel_Window_Servant:GetPosX() + 60 * FGlobal_ServantIconCount() - 3
      posY = Panel_Window_Servant:GetPosY()
    else
      posX = 0
      posY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15
    end
    Panel_Icon_Maid:SetPosX(posX)
    Panel_Icon_Maid:SetPosY(posY)
    MaidList_SetScroll()
    if true == resetScroll and Panel_Window_MaidList:GetShow() then
      maidList.startIndex = 0
      MaidList_Set(maidList.startIndex)
      maidList.scroll:SetControlPos(0)
    end
  else
    Panel_Icon_Maid:SetShow(false)
  end
  PaGlobal_PvPBattle:setPosMatchIcon()
end
function MaidFunc_ShowTooltip(isShow)
  if nil == isShow then
    TooltipSimple_Hide()
    return
  end
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_NAME")
  local desc = ""
  local warehouseInMaid = checkMaid_WarehouseIn(true)
  local warehouseOutMaid = checkMaid_WarehouseOut(true)
  local marketMaid = checkMaid_SubmitMarket(true)
  if warehouseInMaid or warehouseOutMaid then
    desc = "<" .. PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_WAREHOUSE") .. ">"
  end
  if marketMaid then
    if "" == desc then
      desc = "<" .. PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_MARKET") .. ">"
    else
      desc = desc .. ", <" .. PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_MARKET") .. ">"
    end
  end
  local maidCount = MaidList_MaidCount()
  local cooltimeText = ""
  local maidAffiliatedTownName = ""
  local areaName = {}
  local sameAreaCoolTime = {}
  local oneMinute = 60
  local mIndex = 0
  local usableMaidCount = 0
  if "" == desc then
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_DESC_2", "maidCount", maidCount)
  else
    desc = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_DESC_3", "desc", desc, "maidCount", maidCount)
  end
  if "" ~= maidAffiliatedTownName then
    desc = desc .. "\n" .. maidAffiliatedTownName
  end
  if not warehouseInMaid and not warehouseOutMaid and "" ~= cooltimeText then
    desc = desc .. "\n" .. cooltimeText
  end
  local hotkeyDesc = PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_DESC_4")
  desc = desc .. "\n" .. hotkeyDesc
  TooltipSimple_Show(MaidControl.buttonMaid, name, desc)
end
function LogInMaidShow()
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
function renderModeChange_FGlobal_MaidIcon_SetPos(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  FGlobal_MaidIcon_SetPos(true)
end
function FromClient_Refresh()
  local self = maidList
  FGlobal_MaidIcon_SetPos(true)
  self:maidTableUpdate()
  self:maidInfoUpadate()
end
function PaGlobalFunc_IconMaid_ResetScroll()
  maidList.startIndex = 0
  MaidList_Set(maidList.startIndex)
  maidList.scroll:SetControlPos(0)
end
Panel_Window_MaidList:RegisterUpdateFunc("MaidCoolTime_Update")
registerEvent("FromClient_RefreshMaidList", "FromClient_Refresh")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Icon_Maid")
function FromClient_luaLoadComplete_Icon_Maid()
  Panel_MyHouseNavi_Update(true)
  MaidCoolTime_Update()
  LogInMaidShow()
end
local offsetSizeX = 150
function PaGlobalFunc_IconMaid_SettingForMarketPlace()
  local self = maidList
  self.btnMarketPlace:SetShow(true)
  Panel_Window_MaidList:SetSize(Panel_Window_MaidList:GetSizeX() + offsetSizeX, Panel_Window_MaidList:GetSizeY())
  self.contentBg:SetSize(self.contentBg:GetSizeX() + offsetSizeX, self.contentBg:GetSizeY())
  self.contentBg:ComputePos()
  self.title:SetSize(self.title:GetSizeX() + offsetSizeX, self.title:GetSizeY())
  self.title:ComputePos()
  self.btnClose:ComputePos()
  self.scroll:ComputePos()
  self.headLineBg:SetSize(self.headLineBg:GetSizeX() + offsetSizeX, self.headLineBg:GetSizeY())
  self.headLineBg:ComputePos()
  self.titleName:ComputePos()
  self.titleFunc:ComputePos()
  self.titleCoolTime:ComputePos()
end
function HandleEventLUp_IconMaid_pcRoomRegistButtonClick()
  local function Regist_PcRoomMaid()
    ToClient_RegistPcRoomMaid()
    maidList.btnPcRoomRegist:SetShow(false)
  end
  local memoTitle = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_Function_Alert")
  local memoContent = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_MAIDLIST_ALL_PCROOM_MESSAGEBOX_DESC")
  local messageBoxData = {
    title = memoTitle,
    content = memoContent,
    functionYes = Regist_PcRoomMaid,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGloabl_MaidList_PcRoomRegistShowToolTip()
  local name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_MAIDLIST_REGISTEPCROOMMAIDBUTTON")
  local dese = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_MAIDLIST_ALL_PCROOM_REGISTER_DESC")
  TooltipSimple_Show(maidList.btnPcRoomRegist, name, dese)
end
maidList:Init()
