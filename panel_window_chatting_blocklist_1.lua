function PaGlobal_Chatting_BlockList:initialize()
  if true == PaGlobal_Chatting_BlockList._initialize then
    return
  end
  Panel_Chatting_BlockList:ignorePadSnapMoveToOtherPanel()
  local centerBG = UI.getChildControl(Panel_Chatting_BlockList, "Static_CenterBg")
  PaGlobal_Chatting_BlockList._ui.list2_blockedUser = UI.getChildControl(centerBG, "List2_BlockList")
  local keyGuideBG = UI.getChildControl(Panel_Chatting_BlockList, "Static_BottomBg")
  local _stc_keyguideA = UI.getChildControl(keyGuideBG, "StaticText_A_ConsoleUI")
  local _stc_keyguideB = UI.getChildControl(keyGuideBG, "StaticText_B_ConsoleUI")
  local keyGuideList = {_stc_keyguideA, _stc_keyguideB}
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuideList, keyGuideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  PaGlobal_Chatting_BlockList:registEventHandler()
  PaGlobal_Chatting_BlockList:validate()
  PaGlobal_Chatting_BlockList._initialize = true
end
function PaGlobal_Chatting_BlockList:registEventHandler()
  if nil == Panel_Chatting_BlockList then
    return
  end
  PaGlobal_Chatting_BlockList._ui.list2_blockedUser:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_Chatting_BlockList_addBlockListContent")
  PaGlobal_Chatting_BlockList._ui.list2_blockedUser:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function PaGlobal_Chatting_BlockList:prepareOpen()
  if nil == Panel_Chatting_BlockList then
    return
  end
  local vScroll = PaGlobal_Chatting_BlockList._ui.list2_blockedUser:GetVScroll()
  vScroll:SetControlPos(0)
  PaGlobal_Chatting_BlockList:initBlockList()
  PaGlobal_Chatting_BlockList:open()
  ToClient_padSnapSetTargetPanel(Panel_Chatting_BlockList)
end
function PaGlobal_Chatting_BlockList:open()
  if nil == Panel_Chatting_BlockList then
    return
  end
  Panel_Chatting_BlockList:SetShow(true)
end
function PaGlobal_Chatting_BlockList:prepareClose()
  if nil == Panel_Chatting_BlockList then
    return
  end
  PaGlobal_Chatting_BlockList:close()
end
function PaGlobal_Chatting_BlockList:close()
  if nil == Panel_Chatting_BlockList then
    return
  end
  Panel_Chatting_BlockList:SetShow(false)
end
function PaGlobal_Chatting_BlockList:update()
  if nil == Panel_Chatting_BlockList then
    return
  end
  PaGlobal_Chatting_BlockList:initBlockList()
end
function PaGlobal_Chatting_BlockList:validate()
  if nil == Panel_Chatting_BlockList then
    return
  end
  PaGlobal_Chatting_BlockList._ui.list2_blockedUser:isValidate()
end
function PaGlobal_Chatting_BlockList_addBlockListContent(control, key)
  if nil == control or nil == key then
    return
  end
  local index = Int64toInt32(key)
  local userName = ToClient_RequestGetBlockName(index)
  local stc_FamilyName = UI.getChildControl(control, "StaticText_FamillyName")
  stc_FamilyName:SetText(userName)
  control:registerPadEvent(__eConsoleUIPadEvent_A, "HandleEventPadA_BlockList_UnBlockUser(" .. index .. ")")
end
function PaGlobal_Chatting_BlockList:initBlockList()
  PaGlobal_Chatting_BlockList._ui.list2_blockedUser:getElementManager():clearKey()
  local blockCount = ToClient_RequestBlockCount()
  for i = 0, blockCount - 1 do
    PaGlobal_Chatting_BlockList._ui.list2_blockedUser:getElementManager():pushKey(toInt64(0, i))
  end
  if blockCount > 0 then
  end
end
