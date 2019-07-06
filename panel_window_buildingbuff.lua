Panel_Window_BuildingBuff:SetShow(false)
PaGlobal_BuildingBuff = {
  _ui = {
    _list2 = UI.getChildControl(Panel_Window_BuildingBuff, "List2_BuffList"),
    _btn_Close = UI.getChildControl(Panel_Window_BuildingBuff, "Button_Win_Close"),
    _txt_DescBG = UI.getChildControl(Panel_Window_BuildingBuff, "StaticText_BottomDesc"),
    _txt_Title = UI.getChildControl(Panel_Window_BuildingBuff, "StaticText_RankTitle"),
    _rdo_Money = UI.getChildControl(Panel_Window_BuildingBuff, "RadioButton_Money"),
    _rdo_Money2 = UI.getChildControl(Panel_Window_BuildingBuff, "RadioButton_Money2"),
    _txt_Money = UI.getChildControl(Panel_Window_BuildingBuff, "StaticText_Money"),
    _txt_Money2 = UI.getChildControl(Panel_Window_BuildingBuff, "StaticText_Money2")
  },
  _maxPriceKey = 0,
  _keyCount = {},
  _buffCount = {},
  _limitControl = {},
  _limitControlName = {},
  _limitControlDesc = {}
}
function PaGlobal_BuildingBuff:initialize()
  self._maxPriceKey = ToClient_GetBuildingBuffCount()
  PaGlobal_BuildingBuff:setPos()
  self._ui._txt_DescBG:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_DescBG:setPadding(CppEnums.Padding.ePadding_Left, 20)
  self._ui._txt_DescBG:setPadding(CppEnums.Padding.ePadding_Top, 20)
  self._ui._txt_DescBG:setPadding(CppEnums.Padding.ePadding_Right, 20)
  self._ui._txt_DescBG:setPadding(CppEnums.Padding.ePadding_Bottom, 20)
  self._ui._txt_DescBG:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BUILDINGBUFF_BOTTOMDESC"))
  self._ui._txt_DescBG:SetSize(575, self._ui._txt_DescBG:GetTextSizeY() + 10)
  self._ui._rdo_Money:SetEnableArea(0, 0, self._ui._txt_Money:GetPosX() + self._ui._txt_Money:GetSizeX(), 30)
  self._ui._rdo_Money2:SetEnableArea(0, 0, self._ui._txt_Money2:GetPosX() + self._ui._txt_Money2:GetSizeX(), 30)
  self._ui._rdo_Money:SetCheck(true)
  self._ui._rdo_Money2:SetCheck(false)
  Panel_Window_BuildingBuff:SetSize(585, self._ui._rdo_Money2:GetPosY() + self._ui._rdo_Money2:GetSizeY() + self._ui._txt_DescBG:GetSizeY() + 20)
  self._ui._txt_DescBG:ComputePos()
  self._ui._txt_Title:SetText(PAGetString(Defines.StringSheet_GAME, "INTIMACYINFORMATION_TYPE_BUFF"))
end
function PaGlobal_BuildingBuff:open()
  do
    local selfPlayer = getSelfPlayer():get()
    local regionInfo = getRegionInfoByPosition(selfPlayer:getPosition())
    if nil == regionInfo then
      return
    end
    local regionInfoWrapper = getRegionInfoWrapper(regionInfo:getAffiliatedTownRegionKey())
    local wayKey = regionInfoWrapper:getPlantKeyByWaypointKey():getWaypointKey()
    if true == ToClient_IsAccessibleRegionKey(regionInfo:getAffiliatedTownRegionKey()) then
      warehouse_requestInfo(regionInfoWrapper:get()._waypointKey)
    else
      local plantWayKey = ToClient_GetOtherRegionKey_NeerByTownRegionKey()
      local newRegionInfo = ToClient_getRegionInfoWrapperByWaypoint(plantWayKey)
      if nil == newRegionInfo then
        return
      end
      warehouse_requestInfo(newRegionInfo:get()._waypointKey)
    end
  end
  ToClient_RequestCurrentMainTownRegionWarehouseInfo()
  PaGlobal_BuildingBuff_UpdateMoney()
  Panel_Window_BuildingBuff:SetShow(true)
  self._ui._list2:getElementManager():clearKey()
  self._buffInfo = {}
  local buffCount = 0
  for index = 0, self._maxPriceKey - 1 do
    local buffMaxCount = ToClient_GetCountPerBuffKeyCount(index)
    for buffIndex = 0, buffMaxCount - 1 do
      self._keyCount[buffCount] = index
      self._buffCount[buffCount] = buffIndex
      buffCount = buffCount + 1
    end
  end
  for index = 0, buffCount - 1 do
    self._ui._list2:getElementManager():pushKey(toInt64(0, index))
  end
end
function PaGlobal_BuildingBuff:close()
  Panel_Window_BuildingBuff:SetShow(false)
end
function PaGlobal_BuildingBuff:setPos()
  Panel_Window_BuildingBuff:SetPosX(getScreenSizeX() / 2 - Panel_Window_BuildingBuff:GetSizeX() / 2)
  Panel_Window_BuildingBuff:SetPosY(getScreenSizeY() / 2 - Panel_Window_BuildingBuff:GetSizeY() / 2)
end
function PaGlobal_BuildingBuff:update()
end
function BuildingBuff_ListControlCreate(content, key)
  PaGlobal_BuildingBuff:BuildingBuff_ListControlCreate(content, key)
end
function PaGlobal_BuildingBuff:BuildingBuff_ListControlCreate(content, key)
  local index = Int64toInt32(key)
  local keyText = UI.getChildControl(content, "StaticText_List2_KeyCount")
  local buff = UI.getChildControl(content, "StaticText_List2_BuffDesc")
  local applyBtn = UI.getChildControl(content, "Static_List2_ApplyButton")
  local price = UI.getChildControl(content, "StaticText_List2_Price")
  local keyCount = self._keyCount[index]
  local buffIndex = self._buffCount[index]
  keyText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_INNEROBJECTMAXCOUNT", "count", tostring(self._keyCount[index] + 1)))
  local skillNo = ToClient_GetBuildingBuff(keyCount, buffIndex)
  if 0 ~= skillNo then
    local skillWrapper = getSkillTypeStaticStatus(skillNo)
    local buffPrice = ToClient_GetBuildingBuffCost(keyCount, buffIndex)
    buffPrice = makeDotMoney(buffPrice)
    buff:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    buff:SetText(tostring(skillWrapper:getName()))
    self._limitControlName[index] = skillWrapper:getName()
    self._limitControlDesc[index] = skillWrapper:getDescription()
    self._limitControl[index] = buff
    buff:addInputEvent("Mouse_On", "PaGlobal_BuildingBuff:limitTextTooltip(true, " .. index .. " )")
    buff:addInputEvent("Mouse_Out", "PaGlobal_BuildingBuff:limitTextTooltip(false, " .. index .. " )")
    price:SetText(tostring(buffPrice))
    applyBtn:addInputEvent("Mouse_LUp", "PaGlobal_BuildingBuff:applyBuff(" .. keyCount .. "," .. buffIndex .. ", " .. index .. ")")
  end
end
function PaGlobal_BuildingBuff_UpdateMoney()
  if nil == getSelfPlayer() then
    return
  end
  warehouse_moneyFromNpcShop_s64()
  local self = PaGlobal_BuildingBuff
  self._ui._txt_Money:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  local wareHouseMoney = warehouse_moneyByCurrentRegionMainTown_s64()
  self._ui._txt_Money2:SetText(makeDotMoney(wareHouseMoney))
end
function PaGlobal_BuildingBuff:limitTextTooltip(isShow, index, skillWrapper)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  name = self._limitControlName[index]
  desc = self._limitControlDesc[index]
  TooltipSimple_Show(self._limitControl[index], name, desc)
end
function PaGlobal_BuildingBuff:applyBuff(keyCount, buffIndex, index)
  local function apply()
    ToClient_ApplyBuildingBuff(keyCount, buffIndex, self._ui._rdo_Money:IsCheck())
  end
  local messageBoxMemo = self._limitControl[index]:GetText() .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_CAMP_BUILDINGBUFF_MESSAGEBOX_DESC")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = messageBoxMemo,
    functionYes = apply,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_BuildingBuff:registEventHandler()
  self._ui._list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "BuildingBuff_ListControlCreate")
  self._ui._list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_BuildingBuff:close()")
  registerEvent("FromClient_InventoryUpdate", "PaGlobal_BuildingBuff_UpdateMoney")
  registerEvent("EventWarehouseUpdate", "PaGlobal_BuildingBuff_UpdateMoney")
  registerEvent("FromClient_luaLoadComplete", "PaGlobal_BuildingBuff_UpdateMoney")
end
PaGlobal_BuildingBuff:initialize()
PaGlobal_BuildingBuff:registEventHandler()
