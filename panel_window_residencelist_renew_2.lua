function HandleEventPadX_ResidenceList_StartNaviToResidence(controlIndex)
  if nil == Panel_Window_ResidenceList then
    return
  end
  PaGlobal_ResidenceList:setNaviToResidence(controlIndex)
end
