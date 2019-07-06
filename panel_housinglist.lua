local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_HousingList:SetShow(false)
Panel_HousingList:setGlassBackground(true)
Panel_HousingList:ActiveMouseEventEffect(true)
Panel_HousingList:RegisterShowEventFunc(true, "Panel_HousingList_ShowAni()")
Panel_HousingList:RegisterShowEventFunc(false, "Panel_HousingList_HideAni()")
local isBeforeShow = false
local _naviCurrentInfo
local HOUSE_CONTROL_COUNT = 9
function Panel_HousingList_ShowAni()
  UIAni.fadeInSCR_Down(Panel_HousingList)
  local aniInfo1 = Panel_HousingList:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_HousingList:GetSizeX() / 2
  aniInfo1.AxisY = Panel_HousingList:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_HousingList:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_HousingList:GetSizeX() / 2
  aniInfo2.AxisY = Panel_HousingList:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_HousingList_HideAni()
  Panel_HousingList:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_HousingList, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local HousingList = {
  _Territory = UI.getChildControl(Panel_HousingList, "StaticText_Territory"),
  _TownName = UI.getChildControl(Panel_HousingList, "StaticText_TownName"),
  _Address = UI.getChildControl(Panel_HousingList, "StaticText_Address"),
  _Navi = UI.getChildControl(Panel_HousingList, "Button_Navi"),
  _txt_Title = UI.getChildControl(Panel_HousingList, "StaticText_Title"),
  _frame = UI.getChildControl(Panel_HousingList, "Frame_HousingList"),
  _housePos = {}
}
HousingList._btn_Close = UI.getChildControl(HousingList._txt_Title, "Button_Close")
HousingList.frameContent = UI.getChildControl(HousingList._frame, "Frame_1_Content")
HousingList.frameScroll = UI.getChildControl(HousingList._frame, "Frame_1_VerticalScroll")
HousingList.frameScroll:SetIgnore(false)
function HousingList:Panel_HousingList_Initialize()
  self.frameContent:DestroyAllChild()
  self.listArray = {}
  HOUSE_CONTROL_COUNT = ToClient_getMyDwellingCount()
  local guildHouseStaticStatusWrapper = ToClient_getMyGuildHouse()
  if nil ~= guildHouseStaticStatusWrapper then
    HOUSE_CONTROL_COUNT = HOUSE_CONTROL_COUNT + 1
  end
  HOUSE_CONTROL_COUNT = HOUSE_CONTROL_COUNT + ToClient_getMyVillaCount()
  for idx = 0, HOUSE_CONTROL_COUNT do
    local listArr = {}
    listArr._Territory = UI.createAndCopyBasePropertyControl(Panel_HousingList, "StaticText_Territory", self.frameContent, "HousingList_StaticText_Territory_" .. idx)
    listArr._TownName = UI.createAndCopyBasePropertyControl(Panel_HousingList, "StaticText_TownName", self.frameContent, "HousingList_StaticText_TownName_" .. idx)
    listArr._Address = UI.createAndCopyBasePropertyControl(Panel_HousingList, "StaticText_Address", self.frameContent, "HousingList_StaticText_Address_" .. idx)
    listArr._Navi = UI.createAndCopyBasePropertyControl(Panel_HousingList, "Button_Navi", self.frameContent, "HousingList_Button_Navi_" .. idx)
    self.listArray[idx] = listArr
  end
  for idx = 0, #self.listArray do
    self.listArray[idx]._Territory:SetShow(false)
    self.listArray[idx]._TownName:SetShow(false)
    self.listArray[idx]._Address:SetShow(false)
    self.listArray[idx]._Navi:SetShow(false)
  end
  self.frameContent:SetIgnore(false)
  self.frameContent:addInputEvent("Mouse_DownScroll", "HousingList_ScrollEvent( true )")
  self.frameContent:addInputEvent("Mouse_UpScroll", "HousingList_ScrollEvent( false )")
  self.frameScroll:SetControlTop()
  self._frame:UpdateContentScroll()
  self._frame:UpdateContentPos()
end
function HousingList_ScrollEvent(isDown)
  local self = HousingList
  if isDown then
    self.frameScroll:ControlButtonDown()
  else
    self.frameScroll:ControlButtonUp()
  end
  self._frame:UpdateContentScroll()
end
function Panel_HousingList_Update()
  HousingList:Panel_HousingList_Initialize()
  local self = HousingList
  local _myDwellingCount = ToClient_getMyDwellingCount()
  local _PosY = 10
  if _myDwellingCount > 0 then
    for idx = 0, _myDwellingCount - 1 do
      local characterStaticStatusWrapper = ToClient_getMyDwelling(idx)
      if nil ~= characterStaticStatusWrapper and characterStaticStatusWrapper:getName() ~= nil then
        local houseX = characterStaticStatusWrapper:getObjectStaticStatus():getHousePosX()
        local houseY = characterStaticStatusWrapper:getObjectStaticStatus():getHousePosY()
        local houseZ = characterStaticStatusWrapper:getObjectStaticStatus():getHousePosZ()
        local housePos = float3(houseX, houseY, houseZ)
        self._housePos[idx] = housePos
        local regionWrapper = ToClient_getRegionInfoWrapperByPosition(housePos)
        if idx ~= 0 then
          _PosY = self._Territory:GetSizeY() + 7 + _PosY
        end
        self.listArray[idx]._Territory:SetText(regionWrapper:getTerritoryName())
        self.listArray[idx]._Territory:SetPosX(50)
        self.listArray[idx]._Territory:SetPosY(_PosY)
        self.listArray[idx]._Territory:SetShow(true)
        self.listArray[idx]._TownName:SetText(regionWrapper:getAreaName())
        self.listArray[idx]._TownName:SetPosX(180)
        self.listArray[idx]._TownName:SetPosY(_PosY)
        self.listArray[idx]._TownName:SetShow(true)
        self.listArray[idx]._Address:SetText(characterStaticStatusWrapper:getName())
        self.listArray[idx]._Address:SetPosX(330)
        self.listArray[idx]._Address:SetPosY(_PosY)
        self.listArray[idx]._Address:SetShow(true)
        self.listArray[idx]._Navi:SetPosX(615)
        self.listArray[idx]._Navi:SetPosY(_PosY + 2)
        self.listArray[idx]._Navi:SetShow(true)
        self.listArray[idx]._Navi:addInputEvent("Mouse_LUp", "_HousingListNavigatorStart(" .. idx .. "," .. _myDwellingCount .. ")")
      end
    end
  end
  local idx = _myDwellingCount
  local guildHouseStaticStatusWrapper = ToClient_getMyGuildHouse()
  if nil ~= guildHouseStaticStatusWrapper and nil ~= guildHouseStaticStatusWrapper and guildHouseStaticStatusWrapper:getName() ~= nil then
    local houseX = guildHouseStaticStatusWrapper:getObjectStaticStatus():getHousePosX()
    local houseY = guildHouseStaticStatusWrapper:getObjectStaticStatus():getHousePosY()
    local houseZ = guildHouseStaticStatusWrapper:getObjectStaticStatus():getHousePosZ()
    local housePos = float3(houseX, houseY, houseZ)
    self._housePos[idx] = housePos
    local regionWrapper = ToClient_getRegionInfoWrapperByPosition(housePos)
    if idx ~= 0 then
      _PosY = self._Territory:GetSizeY() + 7 + _PosY
    end
    self.listArray[idx]._Territory:SetText(regionWrapper:getTerritoryName())
    self.listArray[idx]._Territory:SetPosX(50)
    self.listArray[idx]._Territory:SetPosY(_PosY)
    self.listArray[idx]._Territory:SetShow(true)
    self.listArray[idx]._TownName:SetText(regionWrapper:getAreaName())
    self.listArray[idx]._TownName:SetPosX(180)
    self.listArray[idx]._TownName:SetPosY(_PosY)
    self.listArray[idx]._TownName:SetShow(true)
    self.listArray[idx]._Address:SetText(guildHouseStaticStatusWrapper:getName())
    self.listArray[idx]._Address:SetPosX(330)
    self.listArray[idx]._Address:SetPosY(_PosY)
    self.listArray[idx]._Address:SetShow(true)
    self.listArray[idx]._Navi:SetPosX(615)
    self.listArray[idx]._Navi:SetPosY(_PosY + 2)
    self.listArray[idx]._Navi:SetShow(true)
    self.listArray[idx]._Navi:addInputEvent("Mouse_LUp", "_HousingListNavigatorStart_GuildHouse(" .. idx .. ")")
  end
  idx = idx + 1
  local _myVillaCount = ToClient_getMyVillaCount()
  if _myVillaCount > 0 then
    for villaIdx = 0, _myVillaCount - 1 do
      local characterStaticStatusWrapper = ToClient_getMyVilla(villaIdx)
      if nil ~= characterStaticStatusWrapper and characterStaticStatusWrapper:getName() ~= nil then
        local houseX = characterStaticStatusWrapper:getObjectStaticStatus():getHousePosX()
        local houseY = characterStaticStatusWrapper:getObjectStaticStatus():getHousePosY()
        local houseZ = characterStaticStatusWrapper:getObjectStaticStatus():getHousePosZ()
        local housePos = float3(houseX, houseY, houseZ)
        self._housePos[idx] = housePos
        local regionWrapper = ToClient_getRegionInfoWrapperByPosition(housePos)
        if idx ~= 0 then
          _PosY = self._Territory:GetSizeY() + 7 + _PosY
        end
        self.listArray[idx]._Territory:SetText(regionWrapper:getTerritoryName())
        self.listArray[idx]._Territory:SetPosX(18)
        self.listArray[idx]._Territory:SetPosY(_PosY)
        self.listArray[idx]._Territory:SetShow(true)
        self.listArray[idx]._TownName:SetText(regionWrapper:getAreaName())
        self.listArray[idx]._TownName:SetPosX(150)
        self.listArray[idx]._TownName:SetPosY(_PosY)
        self.listArray[idx]._TownName:SetShow(true)
        self.listArray[idx]._Address:SetText(characterStaticStatusWrapper:getName())
        self.listArray[idx]._Address:SetPosX(310)
        self.listArray[idx]._Address:SetPosY(_PosY)
        self.listArray[idx]._Address:SetShow(true)
        self.listArray[idx]._Navi:SetPosX(615)
        self.listArray[idx]._Navi:SetPosY(_PosY + 2)
        self.listArray[idx]._Navi:SetShow(true)
        self.listArray[idx]._Navi:addInputEvent("Mouse_LUp", "_HousingListNavigatorStart_Villa(" .. villaIdx .. ")")
        idx = idx + 1
      end
    end
  end
  if idx > 6 then
    self.frameScroll:SetShow(true)
  else
    self.frameScroll:SetShow(false)
  end
end
function _HousingListNavigatorStart(idx, _myDwellingCount)
  local self = HousingList
  ToClient_DeleteNaviGuideByGroup(0)
  for ii = 0, HOUSE_CONTROL_COUNT do
    self.listArray[ii]._Navi:SetCheck(false)
  end
  if _naviCurrentInfo ~= idx then
    local navigationGuideParam = NavigationGuideParam()
    navigationGuideParam._isAutoErase = true
    worldmapNavigatorStart(HousingList._housePos[idx], navigationGuideParam, false, false, true)
    self.listArray[idx]._Navi:SetCheck(true)
    _naviCurrentInfo = idx
  else
    _naviCurrentInfo = nil
  end
end
function _HousingListNavigatorStart_GuildHouse(ctrlIndex)
  local self = HousingList
  ToClient_DeleteNaviGuideByGroup(0)
  for ii = 0, HOUSE_CONTROL_COUNT do
    self.listArray[ii]._Navi:SetCheck(false)
  end
  if _naviCurrentInfo ~= ctrlIndex then
    local navigationGuideParam = NavigationGuideParam()
    navigationGuideParam._isAutoErase = true
    worldmapNavigatorStart(HousingList._housePos[ctrlIndex], navigationGuideParam, false, false, true)
    self.listArray[ctrlIndex]._Navi:SetCheck(true)
    _naviCurrentInfo = ctrlIndex
  else
    _naviCurrentInfo = nil
  end
end
function _HousingListNavigatorStart_Villa(ctrlIndex)
  local self = HousingList
  ToClient_DeleteNaviGuideByGroup(0)
  for ii = 0, HOUSE_CONTROL_COUNT do
    self.listArray[ii]._Navi:SetCheck(false)
  end
  if _naviCurrentInfo ~= ctrlIndex then
    local navigationGuideParam = NavigationGuideParam()
    navigationGuideParam._isAutoErase = true
    worldmapNavigatorStart(HousingList._housePos[ctrlIndex], navigationGuideParam, false, false, true)
    self.listArray[ctrlIndex]._Navi:SetCheck(true)
    _naviCurrentInfo = ctrlIndex
  else
    _naviCurrentInfo = nil
  end
end
function FGlobal_HousingList_Open()
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  Panel_HousingList_Update()
  if Panel_HousingList:IsShow() then
    Panel_HousingList:SetShow(false, true)
  else
    Panel_HousingList:SetShow(true, true)
  end
end
function HousingList_Close()
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  Panel_HousingList:SetShow(false, false)
end
function HandleClicked_HousingList_Close()
  HousingList_Close()
end
function HousingList:registEventHandler()
  self._btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_HousingList_Close()")
end
function renderModeChange_Panel_HousingList_Update(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  Panel_HousingList_Update()
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_Panel_HousingList_Update")
HousingList:registEventHandler()
