local Button_CharacterTag
local isOpenCharacterTag = ToClient_IsContentsGroupOpen("330")
local isAlreadyTaging = false
local hasAwakenCharacter = false
function PaGlobal_CharacterTag_CheckShow()
  return true
end
function PaGlobal_CharacterTag_SetPosIcon()
  if true == _ContentsGroup_RemasterUI_Main then
    return
  end
  if isFlushedUI() then
    return
  end
  if nil == Button_CharacterTag then
    return
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() then
    return
  end
  if false == PaGlobal_CharacterTag_CheckShow() then
    Panel_Icon_CharacterTag:SetShow(false)
    return
  end
  if true == isOpenCharacterTag then
    local posX, posY
    if Panel_Icon_Camp:GetShow() then
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
    Panel_Icon_CharacterTag:SetShow(true)
    Panel_Icon_CharacterTag:SetPosX(posX)
    Panel_Icon_CharacterTag:SetPosY(posY)
  else
    Panel_Icon_CharacterTag:SetShow(false)
  end
  if true == _ContentsGroup_isFairy and nil ~= PaGlobal_Fairy_SetPosIcon then
    PaGlobal_Fairy_SetPosIcon()
  end
  if true == _ContentsGroup_RenewUI_Main then
    Panel_Icon_CharacterTag:SetShow(false)
  end
end
function PaGlobal_CharacterTag_IconMouseToolTip(isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_TAG")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_TAGCHAR_ICON_TOOLTIP_DESC")
  control = Button_CharacterTag
  TooltipSimple_Show(control, name, desc)
end
function InitializeTagIcon()
  if true == _ContentsGroup_RemasterUI_Main then
    return
  end
  Panel_Icon_CharacterTag:SetIgnore(false)
  if true == _ContentsGroup_RenewUI_Main then
    Panel_Icon_CharacterTag:SetShow(false)
  else
    Panel_Icon_CharacterTag:SetShow(true)
  end
  Button_CharacterTag = UI.getChildControl(Panel_Icon_CharacterTag, "Button_TagIcon")
  Button_CharacterTag:ActiveMouseEventEffect(true)
  Button_CharacterTag:addInputEvent("Mouse_LUp", "PaGlobal_CharacterTag_Open()")
  Button_CharacterTag:addInputEvent("Mouse_RUp", "PaGlobal_TagCharacter_Change()")
  if isOpenCharacterTag then
    Button_CharacterTag:setButtonShortcutsWithEvent("PaGlobal_TagCharacter_Change()", "PANEL_SIMPLESHORTCUT_CHARACTER_CHANGE")
  end
  Button_CharacterTag:addInputEvent("Mouse_Out", "PaGlobal_CharacterTag_IconMouseToolTip(false)")
  Button_CharacterTag:addInputEvent("Mouse_On", "PaGlobal_CharacterTag_IconMouseToolTip(true)")
  PaGlobal_CharacterTag_SetPosIcon()
end
function FromClient_Tag_SelfPlayerLevelUp()
  if true == _ContentsGroup_RemasterUI_Main then
    PaGlobalFunc_ServantIcon_UpdateOtherIcon(PaGlobalFunc_ServantIcon_GetTagIndex())
  else
    local player = getSelfPlayer()
    if nil == player then
      return
    end
    if false == Panel_Icon_CharacterTag:GetShow() then
      PaGlobal_CharacterTag_SetPosIcon()
    end
  end
end
registerEvent("FromClient_luaLoadComplete", "InitializeTagIcon")
registerEvent("EventSelfPlayerLevelUp", "FromClient_Tag_SelfPlayerLevelUp")
