LobbyInstance_DeadMessage:setIgnoreFlashPanel(true)
local _deadBlackHole = UI.getChildControl(LobbyInstance_DeadMessage, "deadBlackHole")
local _deadMessage = UI.getChildControl(LobbyInstance_DeadMessage, "Static_DeadText")
local _button_Immediate = UI.getChildControl(LobbyInstance_DeadMessage, "Button_Immediate")
local _text_ImmediateCount = UI.getChildControl(LobbyInstance_DeadMessage, "StaticText_ImmediateCount")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local CPP_slotNoString = CppEnums.EquipSlotNoString
enRespawnType = {
  respawnType_None = 0,
  respawnType_Immediate = 1,
  respawnType_ByOtherPlayer = 2,
  respawnType_Exploration = 3,
  respawnType_NearTown = 4,
  respawnType_TimeOver = 5,
  respawnType_InSiegeingFortress = 6,
  respawnType_LocalWar = 7,
  respawnType_AdvancedBase = 8,
  respawnType_GuildSpawn = 9,
  respawnType_Competition = 10,
  respawnType_SavageDefence = 11,
  respawnType_Volunteer = 12,
  respawnType_GuildBatle = 13,
  respawnType_Plunder = 14,
  respawnType_GuildTeamBattle = 15,
  respawnType_OutsideGate = 16,
  respawnType_InsideGate = 17,
  respawnType_Count = 18
}
function deadMessage_Resize()
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  LobbyInstance_DeadMessage:SetSize(screenX, screenY)
  _deadBlackHole:SetPosX(screenX / 2 - _deadBlackHole:GetSizeX() / 2)
  _deadBlackHole:SetPosY(screenY / 2 - _deadBlackHole:GetSizeY() / 2)
  _deadMessage:SetPosX(screenX / 2 - 25)
  _deadMessage:SetPosY(100)
  local buttonHalfSizeX = _button_Immediate:GetSizeX() / 2
  local buttonSizeY = _button_Immediate:GetSizeY()
  _button_Immediate:SetPosX(screenX / 2 - buttonHalfSizeX)
  _button_Immediate:SetPosY(screenY / 2 + buttonSizeY * 2 + 50)
end
local function deadMessage_Animation()
  LobbyInstance_DeadMessage:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfoImmediate3 = _button_Immediate:addColorAnimation(0, 3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfoImmediate3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfoImmediate3:SetEndColor(UI_color.C_00FFFFFF)
  aniInfoImmediate3.IsChangeChild = true
  aniInfoImmediate3:SetDisableWhileAni(true)
  aniInfoImmediate3 = _button_Immediate:addColorAnimation(3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfoImmediate3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfoImmediate3:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfoImmediate3.IsChangeChild = true
  aniInfoImmediate3:SetDisableWhileAni(true)
end
function deadMessage_Show(attackerActorKeyRaw, isSkipDeathPenalty, isHasRestoreExp, isAblePvPMatchRevive, respawnTime)
  SetUIMode(Defines.UIMode.eUIMode_DeadMessage)
  local selfProxy = getSelfPlayer()
  if nil == selfProxy then
    return
  end
  local attackerActorProxyWrapper = getActor(attackerActorKeyRaw)
  local isMilitia = false
  local playerActorProxyWrapper = getPlayerActor(attackerActorKeyRaw)
  if nil ~= playerActorProxyWrapper then
    isMilitia = playerActorProxyWrapper:get():isVolunteer()
  end
  _button_Immediate:SetShow(true)
  _text_ImmediateCount:SetShow(false)
  if nil == attackerActorProxyWrapper then
    _deadMessage:SetText(PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_DisplayMsg"))
  elseif isMilitia then
  else
    _deadMessage:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_KilledDisplayMsg", "attackerName", attackerActorProxyWrapper:getOriginalName()))
  end
  LobbyInstance_DeadMessage:SetShow(true, false)
  deadMessage_Animation()
end
function deadMessage_ButtonPushed_Immediate()
  local revivalItemCount = 0
  revivalItemCount = ToClient_InventorySizeByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Revival)
  local selfProxy = getSelfPlayer()
  if nil == selfProxy then
    return
  end
  deadMessage_Revival(enRespawnType.respawnType_Immediate, 0, CppEnums.ItemWhereType.eCashInventory, getSelfPlayer():getRegionKey(), true, toInt64(0, 0))
end
function deadMessage_registEventHandler()
  _button_Immediate:addInputEvent("Mouse_LUp", "deadMessage_ButtonPushed_Immediate()")
end
function deadMessage_registMessageHandler()
  registerEvent("EventSelfPlayerDead", "deadMessage_Show")
  registerEvent("onScreenResize", "deadMessage_Resize")
end
function deadMessage_UpdatePerFrame(deltaTime)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer or not selfPlayer:isDead() then
    LobbyInstance_DeadMessage:SetShow(false, false)
    return
  end
end
LobbyInstance_DeadMessage:RegisterUpdateFunc("deadMessage_UpdatePerFrame")
deadMessage_Resize()
deadMessage_registEventHandler()
deadMessage_registMessageHandler()
