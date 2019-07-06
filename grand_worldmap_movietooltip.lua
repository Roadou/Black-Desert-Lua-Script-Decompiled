local _btn_Close = UI.getChildControl(Panel_MovieWorldMapGuide_Web, "Button_Close")
function Panel_Worldmap_MovieGuide_Init()
  _btn_Close:addInputEvent("Mouse_LUp", "Panel_Worldmap_MovieGuide_Toggle()")
  Panel_MovieWorldMapGuide_Web:SetPosX(425)
  Panel_MovieWorldMapGuide_Web:SetPosY(70)
  Panel_MovieWorldMapGuide_Web:SetShow(false)
end
function Panel_Worldmap_MovieGuide_Open()
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:increaseLayer(true)
    WorldMapPopupManager:push(Panel_MovieWorldMapGuide_Web, true)
  end
  PaGlobal_MovieWorldMapGuide_Web:Open()
  Panel_MovieGuide_Weblist:SetPosX(getScreenSizeX() / 2 - Panel_MovieGuide_Weblist:GetSizeX() / 2)
  Panel_MovieGuide_Weblist:SetPosY(getScreenSizeY() / 2 - Panel_MovieGuide_Weblist:GetSizeY() / 2)
  Panel_MovieWorldMapGuide_Web:SetPosX(Panel_MovieGuide_Weblist:GetPosX() - Panel_MovieWorldMapGuide_Web:GetSizeX() - 5)
  Panel_MovieWorldMapGuide_Web:SetPosY(Panel_MovieGuide_Weblist:GetPosY() + Panel_MovieGuide_Weblist:GetSizeY() - Panel_MovieWorldMapGuide_Web:GetSizeY())
end
function Panel_Worldmap_MovieGuide_Toggle()
  if Panel_MovieWorldMapGuide_Web:GetShow() == true then
    PaGlobal_MovieWorldMapGuide_Web:Close()
  else
    PaGlobal_MovieWorldMapGuide_Web:Open()
  end
end
