local FairyIcon = {
  _icon = UI.getChildControl(Panel_Window_FairyIcon, "Button_FairyIcon")
}
function PaGlobal_Fairy_SetPosIcon()
  if false == _ContentsGroup_isFairy then
    Panel_Window_FairyIcon:SetShow(false)
    return
  end
  if isFlushedUI() then
    Panel_Window_FairyIcon:SetShow(false)
  end
  if nil == FairyIcon._icon then
    Panel_Window_FairyIcon:SetShow(false)
  end
  if 0 < ToClient_getFairyUnsealedList() + ToClient_getFairySealedList() then
    local posX, posY
    if Panel_Icon_CharacterTag:GetShow() then
      posX = Panel_Icon_CharacterTag:GetPosX() + Panel_Icon_CharacterTag:GetSizeX() - 3
      posY = Panel_Icon_CharacterTag:GetPosY()
    elseif Panel_Icon_Camp:GetShow() then
      posX = Panel_Icon_Camp:GetPosX() + Panel_Icon_Camp:GetSizeX() - 3
      posY = Panel_Icon_Camp:GetPosY()
    elseif Panel_Icon_Duel:GetShow() then
      posX = Panel_Icon_Duel:GetPosX() + Panel_Icon_Duel:GetSizeX() - 3
      posY = Panel_Icon_Duel:GetPosY()
    elseif nil ~= Panel_Icon_Maid and Panel_Icon_Maid:GetShow() then
      posX = Panel_Icon_Maid:GetPosX() + Panel_Icon_Maid:GetSizeX() - 3
      posY = Panel_Icon_Maid:GetPosY()
    elseif Panel_Window_PetIcon:GetShow() then
      posX = Panel_Window_PetIcon:GetPosX() + Panel_Window_PetIcon:GetSizeX() - 3
      posY = Panel_Window_PetIcon:GetPosY()
    elseif Panel_Icon_Camp:GetShow() then
      posX = Panel_Icon_Camp:GetPosX() + Panel_Icon_Camp:GetSizeX() - 3
      posY = Panel_Icon_Camp:GetPosY()
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
    Panel_Window_FairyIcon:SetShow(true)
    Panel_Window_FairyIcon:SetPosX(posX)
    Panel_Window_FairyIcon:SetPosY(posY)
  else
    Panel_Window_FairyIcon:SetShow(false)
  end
  if true == _ContentsGroup_RenewUI_Main then
    Panel_Window_FairyIcon:SetShow(false)
  end
end
function InitializeFairyIcon()
  Panel_Window_FairyIcon:SetIgnore(false)
  FairyIcon._icon:addInputEvent("Mouse_LUp", "PaGlobal_FairyInfo_Open(false)")
  FairyIcon._icon:addInputEvent("Mouse_On", "PaGlobal_FairyInfo_SimpleTooltips(true)")
  FairyIcon._icon:addInputEvent("Mouse_Out", "PaGlobal_FairyInfo_SimpleTooltips(false)")
  FairyIcon._icon:ActiveMouseEventEffect(true)
  PaGlobal_Fairy_SetPosIcon()
end
function PaGlobal_FairyInfo_SimpleTooltips(isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYICON_TITLE")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYICON_DESC")
  control = FairyIcon._icon
  TooltipSimple_Show(control, name, desc)
end
registerEvent("FromClient_luaLoadComplete", "InitializeFairyIcon")
