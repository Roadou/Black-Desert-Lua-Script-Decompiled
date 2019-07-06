local UI_VT = CppEnums.VehicleType
local Panel_Widget_TopIcon_Wharf_info = {
  _ui = {static_WharfIcon_Template = nil},
  _value = {currentType = nil, beforeHp = 0},
  _config = {},
  _enum = {},
  _hitEffect = "fUI_Alarm_HorseAttack04",
  _less10Effect = nil
}
local textureByType = {
  path = "renewal/button/console_btn_main.dds",
  x1 = 53,
  y1 = 53,
  x2 = 104,
  y2 = 104
}
local effectNameByType = "fUI_Alarm_HorseAttack05"
function Panel_Widget_TopIcon_Wharf_info:registEventHandler()
end
function Panel_Widget_TopIcon_Wharf_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_TopIcon_Wharf_Resize")
  registerEvent("EventSelfServantUpdateOnlyHp", "PaGlobalFunc_TopIcon_Wharf_UpdateHp")
  registerEvent("EventSelfServantUpdate", "PaGlobalFunc_TopIcon_Wharf_Update")
  registerEvent("FromClient_SummonChanged", "PaGlobalFunc_TopIcon_Wharf_Update")
  registerEvent("FromClient_SummonAddList", "PaGlobalFunc_TopIcon_Wharf_Update")
  registerEvent("FromClient_SummonDelList", "PaGlobalFunc_TopIcon_Wharf_Update")
  registerEvent("EventSelfServantClose", "PaGlobalFunc_TopIcon_Wharf_Close")
  registerEvent("FromClient_RenderModeChangeState", "FromClient_renderModeChange_TopIcon_Wharf_Update")
end
function Panel_Widget_TopIcon_Wharf_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Widget_TopIcon_Wharf_info:initValue()
end
function Panel_Widget_TopIcon_Wharf_info:resize()
  local posY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 4
  Panel_Widget_Wharf_Renew:SetPosY(posY)
end
function Panel_Widget_TopIcon_Wharf_info:childControl()
  self._ui.static_WharfIcon_Template = UI.getChildControl(Panel_Widget_Wharf_Renew, "Static_WharfIcon_Template")
end
function Panel_Widget_TopIcon_Wharf_info:updateContent()
  if isFlushedUI() then
    return
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local seaVehicleWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Ship)
  if nil ~= seaVehicleWrapper then
    local vehicleType = seaVehicleWrapper:getVehicleType()
    if nil == textureByType then
      return
    end
    if self._value.currentType ~= vehicleType then
      self._value.currentType = vehicleType
      self._ui.static_WharfIcon_Template:ChangeTextureInfoName(textureByType.path)
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_WharfIcon_Template, textureByType.x1, textureByType.y1, textureByType.x2, textureByType.y2)
      self._ui.static_WharfIcon_Template:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.static_WharfIcon_Template:setRenderTexture(self._ui.static_WharfIcon_Template:getBaseTexture())
    end
    PaGlobalFunc_TopIcon_Show(TopWidgetIconType.SeaVehicle)
  else
    PaGlobalFunc_TopIcon_Exit(TopWidgetIconType.SeaVehicle)
  end
end
function Panel_Widget_TopIcon_Wharf_info:updateHp()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local seaVehicleWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Ship)
  if nil ~= seaVehicleWrapper and true == PaGlobalFunc_TopIcon_Wharf_GetShow() then
    local regionInfo = getRegionInfoByPosition(seaVehicleWrapper:getPosition())
    if false == regionInfo:get():isSafeZone() then
      self:checkHp(seaVehicleWrapper:getHp(), seaVehicleWrapper:getMaxHp(), seaVehicleWrapper:getVehicleType())
    end
  end
end
function Panel_Widget_TopIcon_Wharf_info:checkHp(currentHp, currentMaxHp, vehicleType)
  local currentHp = currentHp
  local remainHp = currentHp / currentMaxHp * 100
  if currentHp < self._value.beforeHp and nil ~= self._value.beforeHp then
    if nil ~= self._hitEffect then
      self._ui.static_WharfIcon_Template:EraseEffect(self._hitEffect)
    end
    self._hitEffect = self._ui.static_WharfIcon_Template:AddEffect("fUI_Alarm_HorseAttack04", false, -0.6, -0.15)
    local sendMsg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SERVANT_ATTACK"),
      sub = "",
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(sendMsg, 2, 25)
  end
  self._value.beforeHp = currentHp
  if nil ~= self._less10Effect then
    self._ui.static_WharfIcon_Template:EraseEffect(self._less10Effect)
  end
  local effectName
  if remainHp <= 10 then
    if nil ~= effectNameByType then
      effectName = effectNameByType
    else
      effectName = "fUI_Alarm_HorseAttack05"
    end
    if nil ~= effectName then
      self._less10Effect = self._ui.static_WharfIcon_Template:AddEffect(effectName, false, -0.6, -0.15)
    end
  end
end
function Panel_Widget_TopIcon_Wharf_info:open()
  Panel_Widget_Wharf_Renew:SetShow(true)
end
function Panel_Widget_TopIcon_Wharf_info:close()
  Panel_Widget_Wharf_Renew:SetShow(false)
end
function PaGlobalFunc_TopIcon_Wharf_GetShow()
  return Panel_Widget_Wharf_Renew:GetShow()
end
function PaGlobalFunc_TopIcon_Wharf_Open()
  local self = Panel_Widget_TopIcon_Wharf_info
  self:open()
end
function PaGlobalFunc_TopIcon_Wharf_Close()
  local self = Panel_Widget_TopIcon_Wharf_info
  self:close()
end
function PaGlobalFunc_TopIcon_Wharf_Update()
  local self = Panel_Widget_TopIcon_Wharf_info
  self:updateContent()
end
function PaGlobalFunc_TopIcon_Wharf_UpdateHp()
  local self = Panel_Widget_TopIcon_Wharf_info
  self:updateHp()
end
function PaGlobalFunc_TopIcon_Wharf_UpdateMp()
end
function FromClient_TopIcon_Wharf_Init()
  local self = Panel_Widget_TopIcon_Wharf_info
  self:initialize()
end
function FromClient_TopIcon_Wharf_Resize()
  local self = Panel_Widget_TopIcon_Wharf_info
  self:resize()
end
function FromClient_renderModeChange_TopIcon_Wharf_Update(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  local self = Panel_Widget_TopIcon_Wharf_info
  PaGlobalFunc_TopIcon_Wharf_Update()
  PaGlobalFunc_TopIcon_UpdatePos()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_TopIcon_Wharf_Init")
