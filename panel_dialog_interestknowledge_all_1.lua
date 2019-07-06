function PaGlobal_InterestKnowledge_All:initialize()
  if true == PaGlobal_InterestKnowledge_All._initialize then
    return
  end
  self._ui.stc_needKnowledge = UI.getChildControl(Panel_Interest_Knowledge_All, "StaticText_Need_Knowledge")
  self._ui.list2 = UI.getChildControl(Panel_Interest_Knowledge_All, "List2_Knowledge")
  self._ui_pc.btn_question = UI.getChildControl(Panel_Interest_Knowledge_All, "Button_Question_PCUI")
  PaGlobal_InterestKnowledge_All:registEventHandler()
  PaGlobal_InterestKnowledge_All:validate()
  PaGlobal_InterestKnowledge_All._initialize = true
end
function PaGlobal_InterestKnowledge_All:registEventHandler()
  if nil == Panel_Interest_Knowledge_All then
    return
  end
  self._ui_pc.btn_question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelImportantKnowledge\" )")
  self._ui_pc.btn_question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelImportantKnowledge\", \"true\")")
  self._ui_pc.btn_question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelImportantKnowledge\", \"false\")")
  self._ui.list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_InterestKnowledge_All_ListControlCreate")
  self._ui.list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.list2:getElementManager():clearKey()
end
function PaGlobal_InterestKnowledge_All:resize()
  if nil == Panel_Interest_Knowledge_All then
    return
  end
  Panel_Interest_Knowledge_All:ComputePos()
end
function PaGlobal_InterestKnowledge_All:prepareOpen()
  if nil == Panel_Interest_Knowledge_All then
    return
  end
  local talker = dialog_getTalker()
  if nil == talker then
    return
  end
  local actorKeyRaw = talker:getActorKey()
  local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local mentalObject = knowledge:getThemeByKeyRaw(npcActorProxyWrapper:getNpcThemeKey())
  if nil == mentalObject then
    PaGlobalFunc_InterestKnowledge_All_Close()
    return
  end
  PaGlobal_InterestKnowledge_All:update(mentalObject, npcActorProxyWrapper)
  PaGlobal_InterestKnowledge_All:resize()
  PaGlobal_InterestKnowledge_All:open()
end
function PaGlobal_InterestKnowledge_All:open()
  if nil == Panel_Interest_Knowledge_All then
    return
  end
  Panel_Interest_Knowledge_All:SetShow(true)
end
function PaGlobal_InterestKnowledge_All:prepareClose()
  if nil == Panel_Interest_Knowledge_All then
    return
  end
  PaGlobal_InterestKnowledge_All:close()
end
function PaGlobal_InterestKnowledge_All:close()
  if nil == Panel_Interest_Knowledge_All then
    return
  end
  Panel_Interest_Knowledge_All:SetShow(false)
end
function PaGlobal_InterestKnowledge_All:update(theme, npcActorProxyWrapper)
  if nil == Panel_Interest_Knowledge_All then
    return
  end
  if nil == theme or nil == npcActorProxyWrapper then
    return
  end
  local _needKnowledge = npcActorProxyWrapper:getNpcTheme()
  local _needCount = npcActorProxyWrapper:getNeedCount()
  local _currCount = getKnowledgeCountMatchTheme(npcActorProxyWrapper:getNpcThemeKey())
  local _currentKnowledge = ""
  self._ui.stc_needKnowledge:SetText(_needKnowledge .. " ( " .. _currCount .. "/" .. theme:getChildCardCount() .. " ) ")
  self._uiText = {}
  self._ui.list2:getElementManager():clearKey()
  local ii = 1
  local cardCount = theme:getChildCardCount()
  for index = 0, cardCount - 1 do
    local _childCard = theme:getChildCardByIndex(index)
    if nil ~= _childCard then
      self._uiText[ii] = _childCard:getName()
      self._ui.list2:getElementManager():pushKey(toInt64(0, ii))
      ii = ii + 1
    end
  end
end
function PaGlobal_InterestKnowledge_All:validate()
  if nil == Panel_Interest_Knowledge_All then
    return
  end
  self._ui.stc_needKnowledge:isValidate()
  self._ui.list2:isValidate()
  self._ui_pc.btn_question:isValidate()
end
function PaGlobalFunc_InterestKnowledge_All_ListControlCreate(content, key)
  local key32 = Int64toInt32(key)
  local _text = UI.getChildControl(content, "StaticText_Knowledge_List")
  _text:SetText(PaGlobal_InterestKnowledge_All._uiText[key32])
end
