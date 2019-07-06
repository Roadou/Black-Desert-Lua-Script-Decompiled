function HandleEvent_Copyright_WebBannerInput(key)
  if nil == Panel_Window_Copyright then
    return
  end
  if false == Panel_Window_Copyright:GetShow() then
    return
  end
  PaGlobal_Copyright:webBannerInput(key)
end
function PaGlobal_Copyright_onScreenResize()
  if nil == Panel_Window_Copyright then
    return
  end
  PaGlobal_Copyright:onScreenResize()
end
registerEvent("onScreenResize", "PaGlobal_Copyright_onScreenResize")
