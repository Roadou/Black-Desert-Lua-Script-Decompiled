local _panel = Panel_ItemWarp
function PaGlobal_Itemwarp:init()
  PaGlobal_Itemwarp._ui.stc_Partline = UI.getChildControl(_panel, "Static_PartLine")
  PaGlobal_Itemwarp._ui.btn_Close = UI.getChildControl(PaGlobal_Itemwarp._ui.stc_Partline, "Button_CloseIcon")
  PaGlobal_Itemwarp._ui.list2_Town = UI.getChildControl(_panel, "List2_TownList")
  PaGlobal_Itemwarp._ui.btn_Apply = UI.getChildControl(_panel, "Button_Apply_PCUI")
  PaGlobal_Itemwarp._ui.stc_KeyGuideBG = UI.getChildControl(_panel, "Static_KeyGuideBg_ConsoleUI")
  PaGlobal_Itemwarp._ui.stc_KeyGuide_A = UI.getChildControl(PaGlobal_Itemwarp._ui.stc_KeyGuideBG, "StaticText_Move")
  PaGlobal_Itemwarp._ui.stc_KeyGuide_B = UI.getChildControl(PaGlobal_Itemwarp._ui.stc_KeyGuideBG, "StaticText_Close")
  if true == _ContentsGroup_RenewUI then
    PaGlobal_Itemwarp._ui.btn_Close:SetShow(false)
    PaGlobal_Itemwarp._ui.btn_Apply:SetShow(false)
    local keyguides = {
      PaGlobal_Itemwarp._ui.stc_KeyGuide_A,
      PaGlobal_Itemwarp._ui.stc_KeyGuide_B
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyguides, PaGlobal_Itemwarp._ui.stc_KeyGuideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  else
    PaGlobal_Itemwarp._ui.stc_KeyGuideBG:SetShow(false)
  end
  PaGlobal_Itemwarp:registEventHandler()
end
function PaGlobal_Itemwarp:prepareOpen()
  PaGlobal_Itemwarp._selectTownKey = 0
  PaGlobal_Itemwarp:open()
end
function PaGlobal_Itemwarp:open()
  _panel:SetShow(true)
end
function PaGlobal_Itemwarp:prepareClose()
  PaGlobal_Itemwarp:close()
end
function PaGlobal_Itemwarp:close()
  _panel:SetShow(false)
end
function PaGlobal_Itemwarp:update()
end
function PaGlobal_Itemwarp:itemUseNotify(whereType, slotNo, regionKey)
  PaGlobal_Itemwarp._selectWhereType = whereType
  PaGlobal_Itemwarp._selectSlotNo = slotNo
  if 0 == regionKey then
    PaGlobal_Itemwarp:prepareOpen()
    PaGlobal_Itemwarp._ui.list2_Town:getElementManager():clearKey()
    local nearTownListCount = getSelfPlayer():get():getNearTownRegionInfoCount()
    for key = 0, nearTownListCount - 1 do
      PaGlobal_Itemwarp._ui.list2_Town:getElementManager():pushKey(toInt64(0, key))
    end
  else
    PaGlobal_Itemwarp:gotoSelectTown(regionKey)
  end
end
function PaGlobal_Itemwarp:gotoSelectTown(regionKey)
  local regionInfo, areaName
  if nil == regionKey then
    regionInfo = getSelfPlayer():get():getNearTownRegionInfoAt(PaGlobal_Itemwarp._selectTownKey)
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
    getSelfPlayer():get():setNearTownByWarpItem(PaGlobal_Itemwarp._selectWhereType, PaGlobal_Itemwarp._selectSlotNo, RegionKey(regionKeyRowType))
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
function PaGlobal_Itemwarp_TownListCreate(content, key)
  local townListBlueBg = UI.getChildControl(content, "Static_TownList_BlueBG")
  local townListName = UI.getChildControl(content, "List2_TownList_Desc")
  local _key = Int64toInt32(key)
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
  if true == _ContentsGroup_RenewUI then
    content:addInputEvent("Mouse_On", "ItemWarp_SetectTown(" .. _key .. ")")
  else
    content:addInputEvent("Mouse_LUp", "ItemWarp_SetectTown(" .. _key .. ")")
  end
end
function PaGlobal_Itemwarp:registEventHandler()
  registerEvent("onScreenResize", "PaGlobal_PaGlobal_Itemwarp_OnResize")
  registerEvent("FromClient_UseWarpItemNotify", "FromClient_Itemwarp_UseNotify")
  _panel:ignorePadSnapMoveToOtherPanel()
  PaGlobal_Itemwarp._ui.list2_Town:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_Itemwarp_TownListCreate")
  PaGlobal_Itemwarp._ui.list2_Town:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  if true == _ContentsGroup_RenewUI then
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventLUp_Itemwarp_GotoSelectTown()")
  else
    PaGlobal_Itemwarp._ui.btn_Close:addInputEvent("Mouse_LUp", "Panel_ItemWarp_Close()")
    PaGlobal_Itemwarp._ui.btn_Apply:addInputEvent("Mouse_LUp", "HandleEventLUp_Itemwarp_GotoSelectTown()")
  end
end
function PaGlobal_PaGlobal_Itemwarp_OnResize()
  _panel:ComputePos()
end
