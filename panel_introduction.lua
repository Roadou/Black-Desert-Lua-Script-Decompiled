local UI_Color = Defines.Color
local UI_PP = CppEnums.PAUIMB_PRIORITY
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TM = CppEnums.TextMode
local UI_classType = CppEnums.ClassType
local classPicture = {
  [__eClassType_Warrior] = {
    1,
    1,
    96,
    145
  },
  [__eClassType_ElfRanger] = {
    97,
    1,
    192,
    145
  },
  [__eClassType_Sorcerer] = {
    193,
    1,
    288,
    145
  },
  [__eClassType_Giant] = {
    289,
    1,
    384,
    145
  },
  [__eClassType_Tamer] = {
    385,
    1,
    480,
    145
  },
  [__eClassType_BladeMaster] = {
    1,
    146,
    96,
    290
  },
  [__eClassType_BladeMasterWoman] = {
    193,
    146,
    288,
    290
  },
  [__eClassType_Valkyrie] = {
    97,
    146,
    192,
    290
  },
  [__eClassType_WizardMan] = {
    289,
    146,
    384,
    290
  },
  [__eClassType_WizardWoman] = {
    385,
    146,
    480,
    290
  },
  [__eClassType_Kunoichi] = {
    1,
    291,
    96,
    435
  },
  [__eClassType_NinjaMan] = {
    97,
    291,
    192,
    435
  },
  [__eClassType_DarkElf] = {
    193,
    291,
    288,
    435
  },
  [__eClassType_Combattant] = {
    289,
    291,
    384,
    435
  },
  [__eClassType_Mystic] = {
    385,
    291,
    480,
    435
  },
  [__eClassType_Lhan] = {
    97,
    1,
    192,
    145
  },
  [__eClassType_RangerMan] = {
    193,
    1,
    288,
    145
  },
  [__eClassType_ShyWaman] = {
    289,
    1,
    384,
    145
  }
}
local tooltip = {
  _bg = UI.getChildControl(Panel_Introduction, "Static_TooltipBG"),
  _pic = UI.getChildControl(Panel_Introduction, "Static_CharacterPic"),
  _name = UI.getChildControl(Panel_Introduction, "StaticText_FamilyName"),
  _level = UI.getChildControl(Panel_Introduction, "StaticText_CharacterLv"),
  _desc = UI.getChildControl(Panel_Introduction, "StaticText_SelfIntro"),
  _close = UI.getChildControl(Panel_Introduction, "Button_Close")
}
tooltip._desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
tooltip._close:addInputEvent("Mouse_LUp", "FGlobal_Introcution_TooltipHide()")
function FGlobal_Introcution_TooltipHide()
  Panel_Introduction:SetShow(false)
end
local replaceClassType = function(classNo)
  local returnValue = ""
  if nil == classNo then
    return
  end
  return CppEnums.ClassType2String[classNo]
end
local panelSizeY = Panel_Introduction:GetSizeY()
function FGlobal_Introduction_TooltipShow(uiControl, name, desc, isClose, actorKey)
  FGlobal_Introcution_TooltipHide()
  Panel_Introduction:SetShow(true)
  local self = tooltip
  self._bg:SetShow(true)
  self._name:SetShow(true)
  self._desc:SetShow(true)
  self._close:SetShow(isClose)
  self._name:SetText(name)
  local nameLength = math.max(135, self._name:GetTextSizeX() + 15) + 15
  if nil == desc or "" == desc then
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO_NODATA")
  end
  self._desc:SetText(desc)
  if 70 < self._desc:GetTextSizeY() then
    local plusSizeY = self._desc:GetTextSizeY() - 68
    Panel_Introduction:SetSize(Panel_Introduction:GetSizeX(), panelSizeY + plusSizeY)
    tooltip._bg:SetSize(Panel_Introduction:GetSizeX(), panelSizeY + plusSizeY)
  else
    Panel_Introduction:SetSize(Panel_Introduction:GetSizeX(), panelSizeY)
    tooltip._bg:SetSize(Panel_Introduction:GetSizeX(), panelSizeY)
  end
  local playerActorProxyWrapper = getPlayerActor(actorKey)
  local charLevel = playerActorProxyWrapper:get():getLevel()
  local playerClass = playerActorProxyWrapper:getClassType()
  tooltip._level:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_INTRODUCTIONMYSELF_SUBINFO", "class", replaceClassType(playerClass), "level", charLevel))
  if __eClassType_Lhan == playerClass or __eClassType_RangerMan == playerClass or __eClassType_ShyWaman == playerClass then
    tooltip._pic:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/Lobby_ClassSelect_01.dds")
  else
    tooltip._pic:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/Lobby_ClassSelect_00.dds")
  end
  local x1, y1, x2, y2 = setTextureUV_Func(tooltip._pic, classPicture[playerClass][1], classPicture[playerClass][2], classPicture[playerClass][3], classPicture[playerClass][4])
  tooltip._pic:getBaseTexture():setUV(x1, y1, x2, y2)
  tooltip._pic:setRenderTexture(tooltip._pic:getBaseTexture())
  local posX, posY
  if nil ~= uiControl then
    posX = uiControl:GetPosX() + 130
    posY = uiControl:GetPosY() + 25
  else
    posX = getScreenSizeX() / 3
    posY = getScreenSizeY() / 3
  end
  Panel_Introduction:SetPosX(posX)
  Panel_Introduction:SetPosY(posY)
  self._close:ComputePos()
end
function FromClient_InterActionUserIntroduction(actorKey)
  local name, desc, uiControl
  local playerActorProxyWrapper = getPlayerActor(actorKey)
  local name = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTRODUCTIONMYSELF_TITLE", "name", playerActorProxyWrapper:getOriginalName())
  local desc = playerActorProxyWrapper:getUserIntroduction()
  FGlobal_Introduction_TooltipShow(uiControl, name, desc, true, actorKey)
end
registerEvent("FromClient_InterActionUserIntroduction", "FromClient_InterActionUserIntroduction")
