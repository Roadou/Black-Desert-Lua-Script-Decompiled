Panel_Blackspirit_OnOff:setGlassBackground(true)
Panel_Blackspirit_OnOff:ActiveMouseEventEffect(true)
BlackSpiritIcon = {
  buttonBlackSpiritIcon = UI.getChildControl(Panel_Blackspirit_OnOff, "Button_Blackspirt")
}
PaGlobal_PossessByBlackSpiritIcon = {}
function PaGlobal_PossessByBlackSpiritIcon:Init()
  BlackSpiritIcon.buttonBlackSpiritIcon:addInputEvent("Mouse_LUp", "PaGlobal_PossessByBlackSpiritIcon_OnOffToggle()")
  BlackSpiritIcon.buttonBlackSpiritIcon:setGlassBackground(true)
  BlackSpiritIcon.buttonBlackSpiritIcon:ActiveMouseEventEffect(true)
  BlackSpiritIcon.buttonBlackSpiritIcon:addInputEvent("Mouse_On", "PaGlobal_PossessByBlackSpiritIcon_MouseToolTip(true)")
  BlackSpiritIcon.buttonBlackSpiritIcon:addInputEvent("Mouse_Out", "PaGlobal_PossessByBlackSpiritIcon_MouseToolTip(false)")
end
function PaGlobal_PossessByBlackSpiritIcon_OnOffToggle()
  if false == PaGlobal_AutoManager._ActiveState then
    FromClient_AutoStart()
  else
    FromClient_AutoStop()
  end
end
function PaGlobal_PossessByBlackSpiritIcon_MouseToolTip(isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  local self = BlackSpiritIcon
  name = PAGetString(Defines.StringSheet_GAME, "LUA_ICON_AUTO_BLACKSPIRIT_TOOLTIP_NAME")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_ICON_AUTO_BLACKSPIRIT_TOOLTIP_DESC")
  control = self.buttonBlackSpiritIcon
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_PossessByBlackSpiritIcon:showAble()
  if isFlushedUI() or false == ToClient_IsContentsGroupOpen("301") then
    return false
  end
  if false == ToClient_AutoPlay_UseableAutoPlay() then
    return false
  end
  return true
end
function PaGlobal_PossessByBlackSpiritIcon:setPosIcon()
  if isFlushedUI() then
    return
  end
  if self:showAble() == true then
    local posX, posY
    if Panel_Icon_Camp:GetShow() then
      posX = Panel_Icon_Camp:GetPosX() + Panel_Icon_Camp:GetSizeX() - 3
      posY = Panel_Icon_Camp:GetPosY()
    elseif Panel_Icon_Duel:GetShow() then
      posX = Panel_Icon_Duel:GetPosX() + Panel_Icon_Duel:GetSizeX() - 3
      posY = Panel_Icon_Duel:GetPosY()
    elseif nil ~= Panel_Icon_Maid and true == Panel_Icon_Maid:GetShow() then
      posX = Panel_Icon_Maid:GetPosX() + Panel_Icon_Maid:GetSizeX() - 3
      posY = Panel_Icon_Maid:GetPosY()
    elseif Panel_Window_PetIcon:GetShow() then
      posX = Panel_Window_PetIcon:GetPosX() + Panel_Window_PetIcon:GetSizeX() - 3
      posY = Panel_Window_PetIcon:GetPosY()
    elseif 0 < FGlobal_HouseIconCount() and Panel_MyHouseNavi:GetShow() then
      posX = Panel_MyHouseNavi:GetPosX() + 60 * FGlobal_HouseIconCount() - 3
      posY = Panel_MyHouseNavi:GetPosY()
    elseif 0 < FGlobal_ServantIconCount() and Panel_Window_Servant:GetShow() then
      posX = Panel_Window_Servant:GetPosX() + 60 * FGlobal_ServantIconCount() - 3
      posY = Panel_Window_Servant:GetPosY()
    else
      posX = 0
      posY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15
    end
    Panel_Blackspirit_OnOff:SetShow(true)
    Panel_Blackspirit_OnOff:SetPosX(posX)
    Panel_Blackspirit_OnOff:SetPosY(posY)
  else
    Panel_Blackspirit_OnOff:SetShow(false)
  end
end
function PaGlobal_PossessByBlackSpiritIcon_UpdateVisibleState()
  PaGlobal_PossessByBlackSpiritIcon:setPosIcon()
end
function PaGlobal_PossessByBlackSpirit_Open()
  PaGlobal_PossessByBlackSpiritIcon:setPosIcon()
  if false == PaGlobal_AutoManager._ActiveState and false == _ContentsGroup_RenewUI then
    PaGlobal_AutoManager:start(true)
  end
end
PaGlobal_PossessByBlackSpiritIcon:Init()
registerEvent("FromClient_PossessByBlackSpiritIcon_UpdateVisibleState", "PaGlobal_PossessByBlackSpiritIcon_UpdateVisibleState")
registerEvent("FromClient_PossessByBlackSpirit_Open", "PaGlobal_PossessByBlackSpirit_Open")
