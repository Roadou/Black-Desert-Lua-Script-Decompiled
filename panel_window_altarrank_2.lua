function PaGlobal_AltarRankWeb_Open()
  if false == _ContentsGroup_BattleFieldVolunteer then
    return
  end
  if nil == PaGlobal_AltarRankWeb then
    return
  end
  if nil == Panel_AltarRank_Web then
    return
  end
  PaGlobal_AltarRankWeb:prepareOpen()
  PaGlobal_AltarRankWeb:open()
end
function PaGlobal_AltarRankWeb_Close()
  if nil == PaGlobal_AltarRankWeb then
    return
  end
  if nil == Panel_AltarRank_Web then
    return
  end
  PaGlobal_AltarRankWeb:prepareClose()
  PaGlobal_AltarRankWeb:close()
end
function PaGlobal_AltarRankWeb_ShowAni()
  if nil == PaGlobal_AltarRankWeb then
    return
  end
  if nil == Panel_AltarRank_Web then
    return
  end
  PaGlobal_AltarRankWeb:showAni()
end
function PaGlobal_AltarRankWeb_HideAni()
  if nil == PaGlobal_AltarRankWeb then
    return
  end
  if nil == Panel_AltarRank_Web then
    return
  end
  PaGlobal_AltarRankWeb:hideAni()
end
