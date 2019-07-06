Panel_Window_StableStallion_ItemNotify:SetShow(false)
local _notify = UI.getChildControl(Panel_Window_StableStallion_ItemNotify, "StaticText_ItemDesc")
local _notifyBG = UI.getChildControl(Panel_Window_StableStallion_ItemNotify, "Static_DescBg")
function ItemNotify_Open()
  Panel_Window_StableStallion_ItemNotify:SetShow(true)
  local posX = Panel_Window_StableStallion:GetPosX()
  local posY = Panel_Window_StableStallion:GetPosY()
  local sizeX = Panel_Window_StableStallion_ItemNotify:GetSizeX()
  Panel_Window_StableStallion_ItemNotify:SetPosX(posX - sizeX)
  Panel_Window_StableStallion_ItemNotify:SetPosY(posY)
end
function ItemNotify_Close()
  Panel_Window_StableStallion_ItemNotify:SetShow(false)
end
function Stallion_ItemNotify(skillKey, index)
  _notify:SetShow(true)
  _notify:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  if 0 == index then
    _notify:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLESTALLIONITEMNOTIFY_TEXT_ITEMNOTIFY_1"))
  elseif 1 == index then
    _notify:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLESTALLIONITEMNOTIFY_TEXT_ITEMNOTIFY_2"))
  elseif 2 == index then
    _notify:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLESTALLIONITEMNOTIFY_TEXT_ITEMNOTIFY_3"))
  else
    _notify:SetShow(false)
  end
  local notifySizeX = _notify:GetTextSizeX() + 65
  local notifySizeY = _notify:GetTextSizeY() + 65
  local notifyBGSizeX = _notifyBG:GetSizeX()
  local notifyBGSizeY = _notifyBG:GetSizeY() - 30
  local panelSizeX = Panel_Window_StableStallion_ItemNotify:GetSizeX()
  local panelSizeY = Panel_Window_StableStallion_ItemNotify:GetSizeY() - 30
  local sizeX = 0
  local sizeY = 0
  if notifySizeX > panelSizeX then
    sizeX = notifySizeX - panelSizeX
  end
  if notifySizeY > panelSizeY then
    sizeY = notifySizeY - panelSizeY
  end
  Panel_Window_StableStallion_ItemNotify:SetSize(panelSizeX + sizeX, panelSizeY + sizeY)
  _notifyBG:SetSize(notifyBGSizeX + sizeX, notifyBGSizeY + sizeY)
end
