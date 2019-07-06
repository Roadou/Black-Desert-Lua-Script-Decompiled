Panel_ItemWarp:SetShow(false, false)
Panel_ItemWarp:setMaskingChild(true)
Panel_ItemWarp:ActiveMouseEventEffect(true)
Panel_ItemWarp:setGlassBackground(true)
Panel_ItemWarp:RegisterShowEventFunc(true, "Panel_ItemWarp_ShowAni()")
Panel_ItemWarp:RegisterShowEventFunc(false, "Panel_ItemWarp_HideAni()")
function Panel_ItemWarp_ShowAni()
  Panel_ItemWarp:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_ItemWarp, 0, 0.3)
end
function Panel_ItemWarp_HideAni()
  local ani1 = UIAni.AlphaAnimation(0, Panel_ItemWarp, 0, 0.2)
  ani1:SetHideAtEnd(true)
end
local btnClose = UI.getChildControl(Panel_ItemWarp, "Button_CloseIcon")
local list2_TownList = UI.getChildControl(Panel_ItemWarp, "List2_TownList")
local btnWarp = UI.getChildControl(Panel_ItemWarp, "Button_Apply")
local selectTownKey, selectSlotNo, selectWhereType
btnClose:addInputEvent("Mouse_LUp", "Panel_ItemWarp_Close()")
btnWarp:addInputEvent("Mouse_LUp", "ItemWarp_GotoSelectTown()")
function FromClient_UseWarpItemNotify(whereType, slotNo, regionKey)
  selectWhereType = whereType
  selectSlotNo = slotNo
  if 0 == regionKey then
    Panel_ItemWarp_Show()
    list2_TownList:getElementManager():clearKey()
    local nearTownListCount = getSelfPlayer():get():getNearTownRegionInfoCount()
    for key = 0, nearTownListCount - 1 do
      list2_TownList:getElementManager():pushKey(toInt64(0, key))
    end
  else
    ItemWarp_GotoSelectTown(regionKey)
  end
end
function WarpableTownListControlCreate(content, key)
  local townListBg = UI.getChildControl(content, "List2_TownList_Bg")
  local townListBlueBg = UI.getChildControl(content, "Static_TownList_BlueBG")
  local townListName = UI.getChildControl(content, "List2_TownList_Desc")
  local _key = Int64toInt32(key)
  if selectTownKey == _key then
    townListBlueBg:SetShow(true)
  else
    townListBlueBg:SetShow(false)
  end
  local nearTownListCount = getSelfPlayer():get():getNearTownRegionInfoCount()
  local count = 0
  for index = 0, nearTownListCount - 1 do
    if _key == index then
      local regionInfo = getSelfPlayer():get():getNearTownRegionInfoAt(index)
      local areaName = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMWARP_NEARESTTOWN_1")
      if regionInfo:get() ~= nil then
        areaName = regionInfo:getAreaName()
      end
      townListName:SetText(areaName)
    end
  end
  townListBg:addInputEvent("Mouse_LUp", "ItemWarp_SetectTown(" .. _key .. ")")
end
function ItemWarp_SetectTown(regionIndex)
  local prevSelectkey = selectTownKey
  selectTownKey = regionIndex
  list2_TownList:requestUpdateByKey(toInt64(0, regionIndex))
  list2_TownList:requestUpdateByKey(toInt64(0, prevSelectkey))
end
function ItemWarp_GotoSelectTown(regionKey)
  local regionInfo, areaName
  if nil == regionKey then
    regionInfo = getSelfPlayer():get():getNearTownRegionInfoAt(selectTownKey)
    areaName = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMWARP_NEARESTTOWN_2")
  else
    regionInfo = getRegionInfoByRegionKey(RegionKey(regionKey))
  end
  local regionKeyRowType = 0
  if regionInfo:get() ~= nil then
    areaName = regionInfo:getAreaName()
    regionKeyRowType = regionInfo:getRegionKey()
  end
  local function gotoTown()
    Panel_ItemWarp_Close()
    getSelfPlayer():get():setNearTownByWarpItem(selectWhereType, selectSlotNo, RegionKey(regionKeyRowType))
  end
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMWARP_MSGCONTENT", "areaName", areaName)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMWARP_MSGTITLE"),
    content = messageBoxMemo,
    functionYes = gotoTown,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function Panel_ItemWarp_Show()
  selectTownKey = 0
  Panel_ItemWarp:SetShow(true, true)
  Panel_ItemWarp:SetPosX(getScreenSizeX() / 2 - Panel_ItemWarp:GetSizeX() / 2)
  Panel_ItemWarp:SetPosY(getScreenSizeY() / 2 - Panel_ItemWarp:GetSizeY() / 2 - 100)
end
function Panel_ItemWarp_Close()
  Panel_ItemWarp:SetShow(false, true)
end
list2_TownList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "WarpableTownListControlCreate")
list2_TownList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
registerEvent("FromClient_UseWarpItemNotify", "FromClient_UseWarpItemNotify")
