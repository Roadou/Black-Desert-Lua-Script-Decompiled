function HandleEventPadA_BlockList_UnBlockUser(index)
  if nil == Panel_Chatting_BlockList then
    return
  end
  local key = toInt64(index)
  local userName
  local content = PaGlobal_Chatting_BlockList._ui.list2_blockedUser:GetContentByKey(key)
  if nil ~= content then
    local stc_FamilyName = UI.getChildControl(content, "StaticText_FamillyName")
    if nil ~= stc_FamilyName then
      userName = stc_FamilyName:GetText()
    end
  end
  if nil ~= userName and "" ~= userName then
    ToClient_RequestDeleteBlockName(userName)
  end
end
function HandleEventPadHold_BlockList_UnBlockUser()
  if nil == Panel_Chatting_BlockList then
    return
  end
  ToClient_RequestDeleteAllBlockList()
end
function FromClient_BlockList_UpdateBlockList()
  PaGlobal_Chatting_BlockList:update()
end
registerEvent("FromClient_UpdateBlockList", "FromClient_BlockList_UpdateBlockList")
