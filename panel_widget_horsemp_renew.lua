local UI_VT = CppEnums.VehicleType
local servantMpBar = {
  _staticBar = UI.getChildControl(Panel_HorseMp, "HorseMpBar"),
  _staticText = UI.getChildControl(Panel_HorseMp, "StaticText_Mp"),
  _actorKeyRaw = 0,
  _isAutoCarrot = true,
  _button_AutoCarrot = UI.getChildControl(Panel_HorseMp, "CheckButton_AutoCarrot")
}
local horseCarrotItemKey = {
  [0] = 19945,
  [1] = 46906,
  [2] = 46912,
  [3] = 54001,
  [4] = 54004,
  [5] = 54005,
  [6] = 9321
}
local camelCarrotItemKey = {
  [0] = 54012,
  [1] = 54020,
  [2] = 54021,
  [3] = 54022,
  [4] = 9321
}
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_HorseMp")
registerEvent("EventSelfServantUpdate", "HorseMP_Update")
registerEvent("EventSelfServantUpdateOnlyMp", "HorseMP_Update")
registerEvent("EventSelfPlayerRideOn", "HorseMP_OpenByInteraction")
registerEvent("FromClient_RenderModeChangeState", "renderModechange_HorseMP_OpenByInteraction")
registerEvent("EventSelfPlayerCarrierChanged", "HorseMP_EventSelfPlayerCarrierChanged")
registerEvent("EventSelfPlayerRideOff", "HorseMP_Close")
function FromClient_luaLoadComplete_HorseMp()
  HorseMP_init()
end
function HorseMP_init()
  Panel_HorseMp:SetShow(false, false)
  Panel_HorseMp:ComputePos()
  servantMpBar._button_AutoCarrot:SetShow(false)
  servantMpBar._button_AutoCarrot:SetCheck(true)
  servantMpBar._button_AutoCarrot:ComputePos()
end
function HorseMp_InitStaminaAlertText(vehicleType)
  local alertText = ""
  if CppEnums.VehicleType.Type_Carriage == vehicleType or CppEnums.VehicleType.Type_CowCarriage == vehicleType then
    alertText = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STAMINA_ALERT_1")
  elseif CppEnums.VehicleType.Type_Boat == vehicleType or CppEnums.VehicleType.Type_Raft == vehicleType or CppEnums.VehicleType.Type_FishingBoat == vehicleType then
    alertText = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STAMINA_ALERT_3")
  elseif CppEnums.VehicleType.Type_PersonTradeShip == vehicleType or CppEnums.VehicleType.Type_SailingBoat == vehicleType or CppEnums.VehicleType.Type_PersonalBattleShip == vehicleType or CppEnums.VehicleType.Type_PersonalBoat == vehicleType or CppEnums.VehicleType.Type_CashPersonalTradeShip == vehicleType or CppEnums.VehicleType.Type_CashPersonalBattleShip == vehicleType or CppEnums.VehicleType.Type_RepairableCarriage == vehicleType then
    alertText = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STAMINA_ALERT_4")
  else
    alertText = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STAMINA_ALERT_2")
  end
end
function HorseMP_Update()
  if false == Panel_HorseMp:GetShow() then
    return
  end
  local self = servantMpBar
  local vehicleProxy = getVehicleActor(self._actorKeyRaw)
  if nil == vehicleProxy then
    return
  end
  local vehicleType = vehicleProxy:get():getVehicleType()
  local staminaPercent
  staminaPercent = vehicleProxy:get():getMp() / vehicleProxy:get():getMaxMp() * 100
  if CppEnums.VehicleType.Type_Carriage == vehicleType or CppEnums.VehicleType.Type_CowCarriage == vehicleType or CppEnums.VehicleType.Type_Boat == vehicleType or CppEnums.VehicleType.Type_Raft == vehicleType or CppEnums.VehicleType.Type_FishingBoat == vehicleType or CppEnums.VehicleType.Type_SailingBoat == vehicleType or CppEnums.VehicleType.Type_PersonalBattleShip == vehicleType or CppEnums.VehicleType.Type_PersonalBoat == vehicleType or CppEnums.VehicleType.Type_PersonTradeShip == vehicleType or staminaPercent < 10 then
  else
  end
  self._staticBar:SetProgressRate(staminaPercent)
  if UI_VT.Type_Horse == vehicleType or UI_VT.Type_Camel == vehicleType or UI_VT.Type_Donkey == vehicleType or UI_VT.Type_MountainGoat == vehicleType then
    self._staticText:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SERVANT_MPBAR_LIFE", "getMp", makeDotMoney(vehicleProxy:get():getMp()), "getMaxMp", makeDotMoney(vehicleProxy:get():getMaxMp())))
    self._staticBar:addInputEvent("Mouse_On", "HorseMP_SimpleTooltips( true, 0, " .. staminaPercent .. ")")
    self._staticBar:addInputEvent("Mouse_Out", "HorseMP_SimpleTooltips( false, 0 )")
    self._staticBar:setTooltipEventRegistFunc("HorseMP_SimpleTooltips( true, 0, " .. staminaPercent .. ")")
  else
    self._staticText:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SERVANT_MPBAR_MACHINE", "getMp", makeDotMoney(vehicleProxy:get():getMp()), "getMaxMp", makeDotMoney(vehicleProxy:get():getMaxMp())))
    if UI_VT.Type_Elephant == vehicleType then
      self._staticBar:addInputEvent("Mouse_On", "HorseMP_SimpleTooltips( true, 3, " .. staminaPercent .. ")")
      self._staticBar:addInputEvent("Mouse_Out", "HorseMP_SimpleTooltips( false, 3 )")
      self._staticBar:setTooltipEventRegistFunc("HorseMP_SimpleTooltips( true, 3, " .. staminaPercent .. ")")
    elseif UI_VT.Type_RidableBabyElephant == vehicleType then
      self._staticText:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SERVANT_MPBAR_LIFE", "getMp", makeDotMoney(vehicleProxy:get():getMp()), "getMaxMp", makeDotMoney(vehicleProxy:get():getMaxMp())))
      self._staticBar:addInputEvent("Mouse_On", "HorseMP_SimpleTooltips( true, 0, " .. staminaPercent .. ")")
      self._staticBar:addInputEvent("Mouse_Out", "HorseMP_SimpleTooltips( false, 0 )")
      self._staticBar:setTooltipEventRegistFunc("HorseMP_SimpleTooltips( true, 0, " .. staminaPercent .. ")")
    elseif UI_VT.Type_PersonTradeShip == vehicleType or UI_VT.Type_SailingBoat == vehicleType or UI_VT.Type_PersonalBoat == vehicleType or UI_VT.Type_PersonalBattleShip == vehicleType or UI_VT.Type_CashPersonalTradeShip == vehicleType or UI_VT.Type_CashPersonalBattleShip == vehicleType or UI_VT.Type_RepairableCarriage == vehicleType then
      self._staticText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_GUILDSHIP_NAME") .. " : " .. makeDotMoney(vehicleProxy:get():getMp()) .. "/" .. makeDotMoney(vehicleProxy:get():getMaxMp()))
      self._staticBar:addInputEvent("Mouse_On", "HorseMP_SimpleTooltips( true, 4, " .. staminaPercent .. ")")
      self._staticBar:addInputEvent("Mouse_Out", "HorseMP_SimpleTooltips( false, 4 )")
      self._staticBar:setTooltipEventRegistFunc("HorseMP_SimpleTooltips( true, 4, " .. staminaPercent .. ")")
    elseif UI_VT.Type_WoodenFence == vehicleType then
      Panel_HorseMp:SetShow(false, false)
    else
      self._staticBar:addInputEvent("Mouse_On", "HorseMP_SimpleTooltips( true, 1, " .. staminaPercent .. ")")
      self._staticBar:addInputEvent("Mouse_Out", "HorseMP_SimpleTooltips( false, 1 )")
      self._staticBar:setTooltipEventRegistFunc("HorseMP_SimpleTooltips( true, 1, " .. staminaPercent .. ")")
    end
  end
  if getSelfPlayer():isNavigationLoop() and getSelfPlayer():isNavigationMoving() then
    if UI_VT.Type_Boat == vehicleType or UI_VT.Type_Raft == vehicleType or UI_VT.Type_FishingBoat == vehicleType or UI_VT.Type_Carriage == vehicleType or UI_VT.Type_CowCarriage == vehicleType or UI_VT.Type_RepairableCarriage == vehicleType or UI_VT.Type_Cannon == vehicleType or UI_VT.Type_PracticeCannon == vehicleType or UI_VT.Type_Elephant == vehicleType or UI_VT.Type_BabyElephant == vehicleType or UI_VT.Type_ThrowFire == vehicleType or UI_VT.Type_ThrowStone == vehicleType or UI_VT.Type_SailingBoat == vehicleType or UI_VT.Type_PersonalBattleShip == vehicleType or UI_VT.Type_PersonTradeShip == vehicleType then
      servantMpBar._button_AutoCarrot:SetShow(false)
    else
      servantMpBar._button_AutoCarrot:SetShow(true)
      servantMpBar._button_AutoCarrot:SetPosX(servantMpBar._staticBar:GetPosX() + servantMpBar._staticBar:GetSizeX() / 2 - servantMpBar._button_AutoCarrot:GetTextSizeX() / 2 - 20)
      if staminaPercent <= 10 and true == servantMpBar._isAutoCarrot then
        if UI_VT.Type_Horse == vehicleType or UI_VT.Type_Donkey == vehicleType or UI_VT.Type_RidableBabyElephant == vehicleType then
          HorseAutoCarrotFunc(horseCarrotItemKey)
        elseif UI_VT.Type_Camel == vehicleType then
          HorseAutoCarrotFunc(camelCarrotItemKey)
        end
      end
    end
  else
    servantMpBar._button_AutoCarrot:SetShow(false)
  end
end
function HorseAutoCarrotFunc(carrotItemKey)
  local useAutoCarrot = function(invenSlot)
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, invenSlot)
    local itemStatic = itemWrapper:getStaticStatus():get()
    local selfProxy = getSelfPlayer():get()
    if nil == selfProxy then
      return
    end
    if selfProxy:doRideMyVehicle() and itemStatic:isUseToVehicle() then
      local equipSlotNo = itemWrapper:getStaticStatus():getEquipSlotNo()
      local carrotName = itemWrapper:getStaticStatus():getName()
      inventoryUseItem(CppEnums.ItemWhereType.eInventory, invenSlot, equipSlotNo, false)
      Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_AUTO_USE_CARROT", "carrotName", carrotName))
    end
  end
  local inventory = getSelfPlayer():get():getInventory()
  local invenSize = inventory:sizeXXX()
  local carrotItemSlot = {}
  for invenidx = 2, invenSize - 1 do
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, invenidx)
    if nil ~= itemWrapper then
      local itemKey = itemWrapper:get():getKey():getItemKey()
      for i = 0, #carrotItemKey do
        if carrotItemKey[i] == itemKey then
          local carrotCoolTime = getItemCooltime(CppEnums.ItemWhereType.eInventory, invenidx)
          if 0 ~= carrotCoolTime then
            return
          end
          local isCheckedConditions = itemWrapper:checkConditions()
          if isCheckedConditions then
            if nil == carrotItemSlot[i] then
              carrotItemSlot[i] = {slot = "", key = ""}
            end
            carrotItemSlot[i].slot = invenidx
            carrotItemSlot[i].key = itemKey
            break
          end
        end
      end
    end
  end
  for i = 0, #carrotItemKey do
    if nil ~= carrotItemSlot[i] and "" ~= carrotItemSlot[i].slot and carrotItemKey[i] == carrotItemSlot[i].key then
      useAutoCarrot(carrotItemSlot[i].slot)
      break
    end
  end
end
function HandleOn_HorseMp_Bar()
  servantMpBar._staticText:SetShow(true)
end
function HandleOut_HorseMp_Bar()
  servantMpBar._staticText:SetShow(false)
end
function HorseMP_OpenByInteraction()
  local self = servantMpBar
  local selfPlayer = getSelfPlayer()
  local selfProxy = selfPlayer:get()
  local actorKeyRaw = selfProxy:getRideVehicleActorKeyRaw()
  local vehicleProxy = getVehicleActor(actorKeyRaw)
  if nil == vehicleProxy then
    return
  end
  local vehicleType = vehicleProxy:get():getVehicleType()
  if UI_VT.Type_ThrowFire == vehicleType or UI_VT.Type_ThrowStone == vehicleType or UI_VT.Type_Cannon == vehicleType then
    return
  end
  self._actorKeyRaw = actorKeyRaw
  HorseMP_Open()
  FGlobal_ServantIcon_IsNearMonster_Effect(false)
end
function HorseMP_SimpleTooltips(isShow, servantTooltipType, staminaStatus)
  local name, desc, uiControl
  if 0 == servantTooltipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEMP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEMP_DESC")
    uiControl = Panel_HorseHp
  elseif 1 == servantTooltipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_CARRIAGEMP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_CARRIAGEMP_DESC")
    uiControl = Panel_HorseHp
  elseif 3 == servantTooltipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_CARRIAGEMP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_ELEPHANTMP_DESC")
    uiControl = Panel_HorseMp
  elseif 4 == servantTooltipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_GUILDSHIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_GUILDSHIP_DESC")
    uiControl = Panel_HorseMp
  end
  if isShow == true and nil ~= staminaStatus then
    registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(uiControl, name, desc)
    HandleOn_HorseMp_Bar()
  elseif isShow == true and nil == staminaStatus then
    registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
    HandleOut_HorseMp_Bar()
  end
end
function HorseMP_Open()
  if Panel_HorseMp:GetShow() then
    return
  end
  if Panel_WorldMap:GetShow() then
    return
  end
  local selfPlayer = getSelfPlayer()
  local selfProxy = selfPlayer:get()
  local isDriver = selfProxy:isVehicleDriver()
  if false == isDriver then
  end
  local self = servantMpBar
  local vehicleProxy = getVehicleActor(self._actorKeyRaw)
  if nil == vehicleProxy then
    return
  end
  local vehicleType = vehicleProxy:get():getVehicleType()
  if UI_VT.Type_Ladder == vehicleType or UI_VT.Type_Cow == vehicleType or UI_VT.Type_Bomb == vehicleType or UI_VT.Type_QuestObjectBox == vehicleType or UI_VT.Type_QuestObjectSack == vehicleType or UI_VT.Type_QuestObjectSheep == vehicleType or UI_VT.Type_QuestObjectCart == vehicleType or UI_VT.Type_QuestObjectOak == vehicleType or UI_VT.Type_QuestObjectBoat == vehicleType or UI_VT.Type_QuestObjectPumpkin == vehicleType or UI_VT.Type_QuestObjectBrokenFrag == vehicleType or UI_VT.Type_QuestObjectHerbalMachines == vehicleType or UI_VT.Type_QuestObjectExtractor == vehicleType or UI_VT.Type_Training == vehicleType then
    return
  end
  Panel_HorseMp:SetShow(true)
  HorseMp_InitStaminaAlertText(vehicleType)
  HorseMP_Update()
end
function HorseMP_Close()
  if not Panel_HorseMp:GetShow() then
    return
  end
  Panel_HorseMp:SetShow(false)
end
function HandleClick_Horse_Repair_Navi(isAuto)
  local player = getSelfPlayer()
  if nil == player then
    return
  end
end
function HorseMP_EventSelfPlayerCarrierChanged(vehicleActorKeyRaw)
  local self = servantMpBar
  local characterActorProxyWrapper = getCharacterActor(vehicleActorKeyRaw)
  if nil == characterActorProxyWrapper then
    HorseMP_Close()
    return
  end
  self._actorKeyRaw = vehicleActorKeyRaw
  HorseMP_Open()
end
function renderModechange_HorseMP_OpenByInteraction(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  HorseMP_OpenByInteraction()
end
function FGlobal_ToggleServantAutoCarrot_PadInput()
  if nil == PaGlobalFunc_HorseInfo_GetIsCheckAutoCarrot then
    return
  end
  if true == PaGlobalFunc_HorseInfo_GetIsCheckAutoCarrot() then
    servantMpBar._isAutoCarrot = true
    servantMpBar._button_AutoCarrot:SetCheck(true)
  else
    servantMpBar._isAutoCarrot = false
    servantMpBar._button_AutoCarrot:SetCheck(false)
  end
end
