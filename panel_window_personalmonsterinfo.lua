local _panel = Panel_Window_PersonalMonsterInfo
local PersonalMonsterWorldMapInfo = {
  _ui = {
    name = UI.getChildControl(_panel, "StaticText_Name"),
    desc = UI.getChildControl(_panel, "StaticText_Desc"),
    itemSlotBg = {},
    itemSlot = {}
  }
}
function PersonalMonsterWorldMapInfo:initialize()
  self:createControl()
  self:registerEvent()
end
function PersonalMonsterWorldMapInfo:createControl()
  self._ui.desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  for idx = 0, 8 do
    self._ui.itemSlotBg[idx] = UI.createAndCopyBasePropertyControl(_panel, "Static_ItemSlotBg", _panel, "BossTooltip_ItemSlotBg_" .. idx)
    self._ui.itemSlotBg[idx]:SetPosX(20 + (self._ui.itemSlotBg[idx]:GetSizeX() + 10) * idx)
    self._ui.itemSlot[idx] = UI.createAndCopyBasePropertyControl(_panel, "Static_ItemSlot", _panel, "BossTooltip_ItemSlot_" .. idx)
    self._ui.itemSlot[idx]:SetPosX(20 + (self._ui.itemSlot[idx]:GetSizeX() + 10) * idx)
  end
end
function PaGlobalFunc_PersonalMonsterInfo_Initialize()
  PersonalMonsterWorldMapInfo:initialize()
end
function PaGlobalFunc_PersonalMonsterInfo_WorldMap(isShow, monsterKey)
  if false == isShow then
    PaGlobalFunc_PersonalMonsterWorldMpaInfo_Close()
    return
  end
  local self = PersonalMonsterWorldMapInfo
  local monsterStatusWrapper = ToClient_GetCharacterStaticStatusWrapper(monsterKey)
  local personalMonsterWrapper = ToClient_GetPersonalMonsterWrapper(monsterKey)
  if nil == monsterStatusWrapper or nil == personalMonsterWrapper then
    return
  end
  self._ui.name:SetText(monsterStatusWrapper:getName())
  self._ui.desc:SetText(personalMonsterWrapper:getDescription())
  local itemCount = personalMonsterWrapper:getDropItemCount()
  for index = 0, 8 do
    self._ui.itemSlotBg[index]:SetShow(false)
    self._ui.itemSlot[index]:SetShow(false)
  end
  local nilcheckCount = 0
  for index = 0, 8 do
    if itemCount > index then
      local itemKey = personalMonsterWrapper:getDropItemKey(index)
      local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
      if nil ~= itemSSW then
        self._ui.itemSlot[index - nilcheckCount]:ChangeTextureInfoName("icon/" .. itemSSW:getIconPath())
        self._ui.itemSlotBg[index - nilcheckCount]:SetShow(true)
        self._ui.itemSlot[index - nilcheckCount]:SetShow(true)
      else
        nilcheckCount = nilcheckCount + 1
      end
    end
  end
  _panel:SetShow(true)
end
function PersonalMonsterWorldMapInfo:registerEvent()
  if true == ToClient_IsContentsGroupOpen("500") then
    registerEvent("FromClient_OnWorldMapPersonalMonster", "FromClient_OnWorldMapPersonalMonster")
    registerEvent("FromClient_OutWorldMapPersonalMonster", "FromClient_OutWorldMapPersonalMonster")
    registerEvent("FromClient_RClickedWorldMapPersonalMonster", "FromClient_RClickedWorldMapPersonalMonster")
  end
end
function PersonalMonsterWorldMapInfo:TooltipSetPos(posX, posY, sizeX, sizeY)
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  if posX > screenSizeX / 2 then
    posX = posX - _panel:GetSizeX()
  else
    posX = posX + sizeX
  end
  if posY > screenSizeY / 2 then
    posY = posY - _panel:GetSizeY()
  end
  _panel:SetPosXY(posX, posY)
end
function PaGlobalFunc_PersonalMonsterWorldMpaInfo_Close()
  _panel:SetShow(false)
end
function FromClient_OnWorldMapPersonalMonster(personalMonsterBtn)
  local key = personalMonsterBtn:getCharacterKey()
  local posX = personalMonsterBtn:GetPosX()
  local posY = personalMonsterBtn:GetPosY()
  local sizeX = personalMonsterBtn:GetSizeX()
  local sizeY = personalMonsterBtn:GetSizeY()
  PersonalMonsterWorldMapInfo:TooltipSetPos(posX, posY, sizeX, sizeY)
  PaGlobalFunc_PersonalMonsterInfo_WorldMap(true, key)
end
function FromClient_OutWorldMapPersonalMonster(personalMonsterBtn)
  PaGlobalFunc_PersonalMonsterInfo_WorldMap(false)
end
function FromClient_RClickedWorldMapPersonalMonster(uiPersonalStatic)
  if nil == uiPersonalStatic then
    return
  end
  ToClient_DeleteNaviGuideByGroup(0)
  local getPos = uiPersonalStatic:getPosition()
  local position = float3(getPos.x, getPos.y, getPos.z)
  ToClient_WorldMapNaviStart(position, NavigationGuideParam(), false, true)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_PersonalMonsterInfo_Initialize")
