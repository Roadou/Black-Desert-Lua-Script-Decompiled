local UI_VT = CppEnums.VehicleType
local servantHpBar = {
  _staticBar = nil,
  _staticText = nil,
  _actorKeyRaw = 0
}
function HorseHP_init()
  if nil == Panel_HorseHp then
    return
  end
  servantHpBar._staticBar = UI.getChildControl(Panel_HorseHp, "HorseHpBar")
  servantHpBar._staticText = UI.getChildControl(Panel_HorseHp, "StaticText_Hp")
  Panel_HorseHp:SetShow(false, false)
  Panel_HorseHp:ComputePos()
end
function HorseHP_Open()
  if nil ~= Panel_HorseHp and true == Panel_HorseHp:GetShow() then
    return
  end
  if Panel_MiniGame_PowerControl:GetShow() then
    return
  end
  if Panel_WorldMap:GetShow() then
    return
  end
  local self = servantHpBar
  local vehicleProxy = getVehicleActor(self._actorKeyRaw)
  if nil == vehicleProxy then
    return
  end
  local vehicleType = vehicleProxy:get():getVehicleType()
  if UI_VT.Type_Ladder == vehicleType or UI_VT.Type_Cow == vehicleType or UI_VT.Type_Bomb == vehicleType or UI_VT.Type_QuestObjectBox == vehicleType or UI_VT.Type_QuestObjectSack == vehicleType or UI_VT.Type_QuestObjectSheep == vehicleType or UI_VT.Type_QuestObjectCart == vehicleType or UI_VT.Type_QuestObjectOak == vehicleType or UI_VT.Type_QuestObjectBoat == vehicleType or UI_VT.Type_QuestObjectPumpkin == vehicleType or UI_VT.Type_QuestObjectBrokenFrag == vehicleType or UI_VT.Type_QuestObjectHerbalMachines == vehicleType or UI_VT.Type_QuestObjectExtractor == vehicleType or UI_VT.Type_Training == vehicleType or UI_VT.Type_BossMonster == vehicleType then
    return
  end
  if UI_VT.Type_WoodenFence == vehicleType then
    local charWrapper = vehicleProxy:getCharacterStaticStatusWrapper()
    if nil ~= charWrapper and true == charWrapper:isAttrSet(__eGuildTeamBattleWoodenFence) then
      return
    end
  end
  PaGlobalFunc_ServantHpBar_SetShowPanel(true, false)
  HorseHP_Update()
  self = servantHpBar
  if UI_VT.Type_Horse == vehicleType or UI_VT.Type_Camel == vehicleType or UI_VT.Type_Donkey == vehicleType or UI_VT.Type_MountainGoat == vehicleType or UI_VT.Type_Elephant == vehicleType then
    self._staticText:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SERVANT_HPBAR_LIFE", "getHp", makeDotMoney(vehicleProxy:get():getHp()), "getMaxHp", makeDotMoney(vehicleProxy:get():getMaxHp())))
    Panel_HorseHp:addInputEvent("Mouse_On", "HorseHP_SimpleTooltips( true, 0 )")
    Panel_HorseHp:addInputEvent("Mouse_Out", "HorseHP_SimpleTooltips( false, 0 )")
    Panel_HorseHp:setTooltipEventRegistFunc("HorseHP_SimpleTooltips( true, 0 )")
  else
    self._staticText:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SERVANT_HPBAR_MACHINE", "getHp", makeDotMoney(vehicleProxy:get():getHp()), "getMaxHp", makeDotMoney(vehicleProxy:get():getMaxHp())))
    Panel_HorseHp:addInputEvent("Mouse_On", "HorseHP_SimpleTooltips( true, 1 )")
    Panel_HorseHp:addInputEvent("Mouse_Out", "HorseHP_SimpleTooltips( false, 1 )")
    Panel_HorseHp:setTooltipEventRegistFunc("HorseHP_SimpleTooltips( true, 1 )")
  end
  self._staticBar:addInputEvent("Mouse_On", "HandleOn_HorseHp_Bar()")
  self._staticBar:addInputEvent("Mouse_Out", "HandleOut_HorseHp_Bar()")
end
function HorseHP_Close()
  if nil == Panel_HorseHp then
    return
  end
  servantHpBar._actorKeyRaw = 0
  Panel_HorseHp:SetShow(false)
  PaGlobalFunc_ServantHpBar_SetShowPanel(false, false)
end
function HorseHP_Update()
  if nil == Panel_HorseHp then
    return
  end
  if false == Panel_HorseHp:GetShow() then
    return
  end
  local self = servantHpBar
  local vehicleProxy = getVehicleActor(self._actorKeyRaw)
  if nil == vehicleProxy then
    return
  end
  local vehicleType = vehicleProxy:get():getVehicleType()
  self._staticBar:SetProgressRate(vehicleProxy:get():getHp() / vehicleProxy:get():getMaxHp() * 100)
  if UI_VT.Type_Horse == vehicleType or UI_VT.Type_Camel == vehicleType or UI_VT.Type_Donkey == vehicleType or UI_VT.Type_MountainGoat == vehicleType or UI_VT.Type_Elephant == vehicleType then
    self._staticText:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SERVANT_HPBAR_LIFE", "getHp", makeDotMoney(vehicleProxy:get():getHp()), "getMaxHp", makeDotMoney(vehicleProxy:get():getMaxHp())))
  else
    self._staticText:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SERVANT_HPBAR_MACHINE", "getHp", makeDotMoney(vehicleProxy:get():getHp()), "getMaxHp", makeDotMoney(vehicleProxy:get():getMaxHp())))
  end
end
function HandleOn_HorseHp_Bar()
  if nil == Panel_HorseHp then
    return
  end
  servantHpBar._staticText:SetShow(true)
end
function HandleOut_HorseHp_Bar()
  if nil == Panel_HorseHp then
    return
  end
  servantHpBar._staticText:SetShow(false)
end
function HorseHP_OpenByInteraction()
  local self = servantHpBar
  local selfPlayer = getSelfPlayer()
  local selfProxy = selfPlayer:get()
  local actorKeyRaw = selfProxy:getRideVehicleActorKeyRaw()
  self._actorKeyRaw = actorKeyRaw
  local vehicleProxy = getVehicleActor(actorKeyRaw)
  if nil == vehicleProxy then
    return
  end
  HorseHP_Open()
end
function HorseHP_SimpleTooltips(isShow, servantTooltipType)
  if nil == Panel_HorseHp then
    return
  end
  local name, desc, uiControl
  if 0 == servantTooltipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEHP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEHP_DESC")
  elseif 1 == servantTooltipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_CARRIAGEHP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_CARRIAGEHP_DESC")
  elseif 2 == servantTooltipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEHP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_ELEPHANTMP_DESC")
  end
  uiControl = Panel_HorseHp
  registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
  if isShow == true then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HorseHP_EventSelfPlayerCarrierChanged(vehicleActorKeyRaw)
  local self = servantHpBar
  local characterActorProxyWrapper = getCharacterActor(vehicleActorKeyRaw)
  if nil == characterActorProxyWrapper then
    HorseHP_Close()
    return
  end
  self._actorKeyRaw = vehicleActorKeyRaw
  HorseHP_Open()
end
function renderModechange_HorseHP_OpenByInteraction(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  HorseHP_OpenByInteraction()
end
function PaGlobalFunc_ServantHpBar_CheckLoadUI()
  local rv = reqLoadUI("UI_Data/Window/Servant/UI_HorseHp.XML", "Panel_HorseHp", Defines.UIGroup.PAGameUIGroup_Widget, SETRENDERMODE_BITSET_DEFULAT())
  if nil ~= rv and 0 ~= rv then
    Panel_HorseHp = rv
    rv = nil
    HorseHP_init()
  end
end
function PaGlobalFunc_ServantHpBar_CheckCloseUI(isAni)
  if nil == Panel_HorseHp then
    return
  end
  reqCloseUI(Panel_HorseHp, isAni)
end
function PaGlobalFunc_ServantHpBar_SetShowPanel(isShow, isAni)
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobalFunc_ServantHpBar_SetShowPanel isShow nil", "\236\160\149\236\167\128\237\152\156")
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_HorseHp:SetShow(isShow, isAni)
    return
  end
  if true == isShow then
    PaGlobalFunc_ServantHpBar_CheckLoadUI()
    if nil ~= Panel_HorseHp then
      Panel_HorseHp:SetShow(isShow, isAni)
    end
  else
    PaGlobalFunc_ServantHpBar_CheckCloseUI(isAni)
  end
end
function servantHpBar:registMessageHandler()
  registerEvent("EventSelfServantUpdate", "HorseHP_Update")
  registerEvent("EventSelfServantUpdateOnlyHp", "HorseHP_Update")
  registerEvent("EventSelfPlayerRideOff", "HorseHP_Close")
  registerEvent("EventSelfPlayerRideOn", "HorseHP_OpenByInteraction")
  registerEvent("EventSelfPlayerCarrierChanged", "HorseHP_EventSelfPlayerCarrierChanged")
  registerEvent("FromClient_RenderModeChangeState", "renderModechange_HorseHP_OpenByInteraction")
end
function FromClient_luaLoadComplete_HorseHp()
  servantHpBar:registMessageHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_HorseHp")
