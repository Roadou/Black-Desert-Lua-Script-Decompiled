function PaGlobal_FadeOutShowAni()
  PaGlobal_FadeOut:showAni()
end
function PaGlobal_FadeOutHideAni()
  PaGlobal_FadeOut:hideAni()
end
function PaGlobal_FadeOutResize()
  PaGlobal_FadeOut:resize()
end
function PaGlobal_FadeOutOpen()
  PaGlobal_FadeOut:open()
end
function PaGlobal_FadeOutClose()
  PaGlobal_FadeOut:close()
end
function PaGlobal_FadeOutEscapeClose()
  if false == PaGlobal_FadeOut._initialize then
    return
  end
  if PaGlobal_FadeOut._fadeDuration < PaGlobal_FadeOut._fadeDruationMaxTime then
    return
  end
  PaGlobal_FadeOutClose()
end
