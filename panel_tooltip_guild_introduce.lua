local UI_TM = CppEnums.TextMode
Panel_Tooltip_Guild_Introduce:SetShow(false, false)
Panel_Tooltip_Guild_Introduce:setGlassBackground(true)
Panel_Tooltip_Guild_Introduce:SetIgnoreChild(true)
local _uiIconBG = UI.getChildControl(Panel_Tooltip_Guild_Introduce, "Tooltip_Guild_IconBG")
local _uiIcon = UI.getChildControl(Panel_Tooltip_Guild_Introduce, "Tooltip_Guild_Icon")
local _uiName = UI.getChildControl(Panel_Tooltip_Guild_Introduce, "Tooltip_Guild_Name")
local _uiMaster = UI.getChildControl(Panel_Tooltip_Guild_Introduce, "Tooltip_Guild_Master")
local _styleIntro = UI.getChildControl(Panel_Tooltip_Guild_Introduce, "Tooltip_Guild_Introduce")
local _guildName = UI.getChildControl(Panel_Tooltip_Guild_Introduce, "StaticText_Guild")
local _guildMaster = UI.getChildControl(Panel_Tooltip_Guild_Introduce, "StaticText_Master")
local uiTextGroup = {
  _uiName = _uiName,
  _uiMaster = _uiMaster,
  _styleIntro = _styleIntro
}
local function getMaxRightPos()
  local rightPos = 0
  for _, control in pairs(uiTextGroup) do
    if control:GetShow() then
      local currentControlRight = control:GetPosX() + control:GetTextSizeX()
      if rightPos < currentControlRight then
        rightPos = currentControlRight
      end
    end
  end
  return rightPos
end
local function getMaxBottomPos()
  local bottomPos = 0
  for _, control in pairs(uiTextGroup) do
    if control:GetShow() then
      local currentControlBottom = control:GetPosY() + control:GetTextSizeY()
      if bottomPos < currentControlBottom then
        bottomPos = currentControlBottom
      end
    end
  end
  return bottomPos
end
function TooltipGuild_Show(control, guildNo_S64, guildName, guildMaster, guildIntro)
  if guildName ~= nil then
    local isSet = setGuildTextureByGuildNo(guildNo_S64, _uiIcon)
    if false == isSet then
      _uiIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(_uiIcon, 183, 1, 188, 6)
      _uiIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      _uiIcon:setRenderTexture(_uiIcon:getBaseTexture())
    else
      _uiIcon:getBaseTexture():setUV(0, 0, 1, 1)
      _uiIcon:setRenderTexture(_uiIcon:getBaseTexture())
    end
  else
    _uiIcon:ChangeTextureInfoName("")
  end
  _uiName:SetTextMode(UI_TM.eTextMode_AutoWrap)
  _uiName:SetText(guildName)
  _uiName:ComputePos()
  _uiMaster:SetText(guildMaster)
  _uiMaster:ComputePos()
  _styleIntro:SetTextMode(UI_TM.eTextMode_AutoWrap)
  _styleIntro:SetAutoResize(true)
  if nil == guildIntro or "" == guildIntro then
    _styleIntro:SetShow(true)
    _styleIntro:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANKING_NO_INTRODUCE"))
  else
    _styleIntro:SetShow(true)
    _styleIntro:SetText(guildIntro)
  end
  local width = getMaxRightPos()
  local height = getMaxBottomPos() + 30
  if 0 ~= width and 0 ~= height then
    local posX = control:GetParentPosX() + control:GetTextSizeX() + 40
    local posY = control:GetParentPosY() - control:GetSizeY() * 1.8
    Panel_Tooltip_Guild_Introduce:SetPosX(posX)
    Panel_Tooltip_Guild_Introduce:SetPosY(posY)
    Panel_Tooltip_Guild_Introduce:SetSize(Panel_Tooltip_Guild_Introduce:GetSizeX(), height)
    Panel_Tooltip_Guild_Introduce:SetShow(true, false)
  else
    Panel_Tooltip_Guild_Introduce:SetShow(false, false)
  end
end
function TooltipGuild_Hide()
  Panel_Tooltip_Guild_Introduce:SetShow(false, false)
end
