function HandleEventLUp_LobbyInstanceRating_TogleStatus(toggleKey)
  if nil == LobbyInstance_Widget_Rating then
    return
  end
  if nil == toggleKey then
    return
  end
  PaGlobal_LobbyInstanceRating.nowToggleKey = toggleKey
  PaGlobal_LobbyInstanceRating:statusUpdate()
end
