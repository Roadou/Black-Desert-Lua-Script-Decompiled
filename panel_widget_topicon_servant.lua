local UI_VT = CppEnums.VehicleType
local Panel_Widget_TopIcon_Servant_info = {
  _ui = {static_ServantIcon_Template = nil},
  _value = {currentType = nil, beforeHp = 0},
  _config = {},
  _enum = {},
  _hitEffect = "fUI_Alarm_HorseAttack04",
  _less10Effect = nil
}
local textureByType = {
  [CppEnums.VehicleType.Type_Horse] = {
    path = "Renewal/Button/Console_Btn_Main.dds",
    x1 = 1,
    y1 = 1,
    x2 = 52,
    y2 = 52
  },
  [CppEnums.VehicleType.Type_Camel] = {
    path = "Renewal/Button/Console_Btn_Main.dds",
    x1 = 53,
    y1 = 105,
    x2 = 104,
    y2 = 156
  },
  [CppEnums.VehicleType.Type_Donkey] = {
    path = "Renewal/Button/Console_Btn_Main.dds",
    x1 = 157,
    y1 = 1,
    x2 = 208,
    y2 = 52
  },
  [CppEnums.VehicleType.Type_Elephant] = {
    path = "Renewal/Button/Console_Btn_Main.dds",
    x1 = 261,
    y1 = 53,
    x2 = 312,
    y2 = 104
  },
  [CppEnums.VehicleType.Type_RidableBabyElephant] = {
    path = "Renewal/Button/Console_Btn_Main.dds",
    x1 = 261,
    y1 = 53,
    x2 = 312,
    y2 = 104
  },
  [CppEnums.VehicleType.Type_Carriage] = {
    path = "Renewal/Button/Console_Btn_Main.dds",
    x1 = 365,
    y1 = 1,
    x2 = 416,
    y2 = 52
  },
  [CppEnums.VehicleType.Type_CowCarriage] = {
    path = "Renewal/Button/Console_Btn_Main.dds",
    x1 = 365,
    y1 = 1,
    x2 = 416,
    y2 = 52
  },
  [CppEnums.VehicleType.Type_Train] = {
    path = "Renewal/Button/Console_Btn_Main.dds",
    x1 = 365,
    y1 = 1,
    x2 = 416,
    y2 = 52
  },
  [CppEnums.VehicleType.Type_RepairableCarriage] = {
    path = "Renewal/Button/Console_Btn_Main.dds",
    x1 = 365,
    y1 = 1,
    x2 = 416,
    y2 = 52
  }
}
local effectNameByType = {
  [CppEnums.VehicleType.Type_Horse] = "fUI_Alarm_HorseAttack05",
  [CppEnums.VehicleType.Type_Camel] = "fUI_Alarm_CamelAttack01",
  [CppEnums.VehicleType.Type_Donkey] = "fUI_Alarm_DonkeyAttack01",
  [CppEnums.VehicleType.Type_Elephant] = "fUI_Alarm_ElephantAttack01",
  [CppEnums.VehicleType.Type_RidableBabyElephant] = "fUI_Alarm_ElephantAttack01",
  [CppEnums.VehicleType.Type_Carriage] = "fUI_Alarm_HorseAttack05",
  [CppEnums.VehicleType.Type_CowCarriage] = "fUI_Alarm_HorseAttack05",
  [CppEnums.VehicleType.Type_Train] = "fUI_Alarm_HorseAttack05",
  [CppEnums.VehicleType.Type_RepairableCarriage] = "fUI_Alarm_HorseAttack05"
}
function Panel_Widget_TopIcon_Servant_info:registEventHandler()
end
function Panel_Widget_TopIcon_Servant_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_TopIcon_Servant_Resize")
  registerEvent("EventSelfServantUpdateOnlyHp", "PaGlobalFunc_TopIcon_Servant_UpdateHp")
  registerEvent("EventSelfServantUpdate", "PaGlobalFunc_TopIcon_Servant_Update")
  registerEvent("FromClient_SummonChanged", "PaGlobalFunc_TopIcon_Servant_Update")
  registerEvent("FromClient_SummonAddList", "PaGlobalFunc_TopIcon_Servant_Update")
  registerEvent("FromClient_SummonDelList", "PaGlobalFunc_TopIcon_Servant_Update")
  registerEvent("EventSelfServantClose", "PaGlobalFunc_TopIcon_Servant_Close")
  registerEvent("FromClient_RenderModeChangeState", "FromClient_renderModeChange_TopIcon_Servant_Update")
end
function Panel_Widget_TopIcon_Servant_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Widget_TopIcon_Servant_info:initValue()
end
function Panel_Widget_TopIcon_Servant_info:resize()
  local posY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 4
  Panel_Widget_Servant_Renew:SetPosY(posY)
end
function Panel_Widget_TopIcon_Servant_info:childControl()
  self._ui.static_ServantIcon_Template = UI.getChildControl(Panel_Widget_Servant_Renew, "Static_ServantIcon_Template")
end
function Panel_Widget_TopIcon_Servant_info:updateContent()
  if isFlushedUI() then
    return
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local landVehicleWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
  if nil ~= landVehicleWrapper then
    local vehicleType = landVehicleWrapper:getVehicleType()
    if nil == textureByType[vehicleType] then
      return
    end
    if self._value.currentType ~= vehicleType then
      self._value.currentType = vehicleType
      self._ui.static_ServantIcon_Template:ChangeTextureInfoName(textureByType[vehicleType].path)
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_ServantIcon_Template, textureByType[vehicleType].x1, textureByType[vehicleType].y1, textureByType[vehicleType].x2, textureByType[vehicleType].y2)
      self._ui.static_ServantIcon_Template:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.static_ServantIcon_Template:setRenderTexture(self._ui.static_ServantIcon_Template:getBaseTexture())
    end
    PaGlobalFunc_TopIcon_Show(TopWidgetIconType.LandVehicle)
  else
    PaGlobalFunc_TopIcon_Exit(TopWidgetIconType.LandVehicle)
  end
end
function Panel_Widget_TopIcon_Servant_info:updateHp()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local landVehicleWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
  if nil ~= landVehicleWrapper and true == PaGlobalFunc_TopIcon_Servant_GetShow() then
    local regionInfo = getRegionInfoByPosition(landVehicleWrapper:getPosition())
    if false == regionInfo:get():isSafeZone() then
      self:checkHp(landVehicleWrapper:getHp(), landVehicleWrapper:getMaxHp(), landVehicleWrapper:getVehicleType())
    end
  end
end
function Panel_Widget_TopIcon_Servant_info:checkHp(currentHp, currentMaxHp, vehicleType)
  local currentHp = currentHp
  local remainHp = currentHp / currentMaxHp * 100
  if currentHp < self._value.beforeHp and nil ~= self._value.beforeHp then
    if nil ~= self._hitEffect then
      self._ui.static_ServantIcon_Template:EraseEffect(self._hitEffect)
    end
    self._hitEffect = self._ui.static_ServantIcon_Template:AddEffect("fUI_Alarm_HorseAttack04", false, -0.1, -0.15)
    local sendMsg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SERVANT_ATTACK"),
      sub = "",
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(sendMsg, 2, 25)
  end
  self._value.beforeHp = currentHp
  if nil ~= self._less10Effect then
    self._ui.static_ServantIcon_Template:EraseEffect(self._less10Effect)
  end
  local effectName
  if remainHp <= 10 then
    if nil ~= effectNameByType[vehicleType] then
      effectName = effectNameByType[vehicleType]
    else
      effectName = "fUI_Alarm_HorseAttack05"
    end
    if nil ~= effectName then
      self._less10Effect = self._ui.static_ServantIcon_Template:AddEffect(effectName, false, -0.1, -0.15)
    end
  end
end
function Panel_Widget_TopIcon_Servant_info:open()
  Panel_Widget_Servant_Renew:SetShow(true)
end
function Panel_Widget_TopIcon_Servant_info:close()
  Panel_Widget_Servant_Renew:SetShow(false)
end
function PaGlobalFunc_TopIcon_Servant_GetShow()
  return Panel_Widget_Servant_Renew:GetShow()
end
function PaGlobalFunc_TopIcon_Servant_Open()
  local self = Panel_Widget_TopIcon_Servant_info
  self:open()
end
function PaGlobalFunc_TopIcon_Servant_Close()
  local self = Panel_Widget_TopIcon_Servant_info
  self:close()
end
function PaGlobalFunc_TopIcon_Servant_Update()
  local self = Panel_Widget_TopIcon_Servant_info
  self:updateContent()
end
function PaGlobalFunc_TopIcon_Servant_UpdateHp()
  local self = Panel_Widget_TopIcon_Servant_info
  self:updateHp()
end
function PaGlobalFunc_TopIcon_Servant_UpdateMp()
end
function FromClient_TopIcon_Servant_Init()
  local self = Panel_Widget_TopIcon_Servant_info
  self:initialize()
end
function FromClient_TopIcon_Servant_Resize()
  local self = Panel_Widget_TopIcon_Servant_info
  self:resize()
end
function FromClient_renderModeChange_TopIcon_Servant_Update(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  local self = Panel_Widget_TopIcon_Servant_info
  PaGlobalFunc_TopIcon_Servant_Update()
  PaGlobalFunc_TopIcon_UpdatePos()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_TopIcon_Servant_Init")
