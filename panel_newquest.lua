local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TISNU = CppEnums.TInventorySlotNoUndefined
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
local isRide = false
local _blackStone = UI.getChildControl(Panel_NewQuest, "Static_blackDust_0")
local _newQuestTextBubble = UI.getChildControl(Panel_NewQuest, "Static_NewQuestBubble")
local _newQuestText = UI.getChildControl(Panel_NewQuest, "StaticText_newQuestText")
local _callingYou = UI.getChildControl(Panel_NewQuest, "StaticText_Purpose")
local _callingYou_Sub = UI.getChildControl(Panel_NewQuest, "StaticText_Purpose_Sub")
_newQuestTextBubble:SetShow(false)
_newQuestText:SetShow(false)
_newQuestText:SetText("")
_blackStone:SetIgnore(true)
Panel_NewQuest:SetDragEnable(false)
Panel_NewQuest:SetIgnore(true)
Panel_NewQuest:RegisterShowEventFunc(true, "newQuest_ShowAnimation()")
Panel_NewQuest:RegisterShowEventFunc(false, "newQuest_HideAnimation()")
local _cumulatedTime = 0
local _bubbleCount = 0
local _startAnimation = false
local _isBubbleCount = _bubbleCount + 1
local _blackStone_BeforCallingTime = 0
_blackStone_CallingTime = 0
function FGlobal_NewMainQuest_Alarm_Check()
  if not ToClient_getIsBlackSpiritNotice() then
    Panel_NewQuest:SetShow(false, false)
  end
end
function FGlobal_NewMainQuest_Alarm_Open()
  if not ToClient_getIsBlackSpiritNotice() then
    Panel_NewQuest:SetShow(false, true)
    return
  end
  if Panel_LocalWarTeam:GetShow() then
    Panel_NewQuest:SetShow(false, false)
    return
  end
  if false == _ContentsGroup_RenewUI_Tutorial and Panel_LifeTutorial:GetShow() then
    Panel_NewQuest:SetShow(false, false)
    return
  end
  if ToClient_IsMyselfInArena() then
    Panel_NewQuest:SetShow(false, false)
    return
  end
  if ToClient_getPlayNowSavageDefence() then
    Panel_NewQuest:SetShow(false, false)
    return
  end
  if true == ToClient_isConsole() then
    Panel_NewQuest:SetShow(false, false)
    return
  end
  local isColorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  local openAvailable = false
  if isRide == false then
    if true == _ContentsGroup_RenewUI_Dailog then
      if not Panel_Dialog_Main:GetShow() then
        openAvailable = true
      end
    elseif false == _ContentsGroup_NewUI_Dialog_All then
      if not Panel_Npc_Dialog:GetShow() then
        openAvailable = true
      end
    elseif not Panel_Npc_Dialog_All:GetShow() then
      openAvailable = true
    end
  else
    Panel_NewQuest:SetShow(false, true)
  end
  if true == openAvailable then
    _blackStone_CallingTime = _blackStone_CallingTime + 1
    Panel_NewQuest:SetShow(true, true)
    if Panel_LocalWar:GetShow() then
      Panel_NewQuest:SetPosY(140)
    else
      Panel_NewQuest:SetPosY(120)
    end
    Panel_NewQuest:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
    audioPostEvent_SystemUi(4, 11)
    _AudioPostEvent_SystemUiForXBOX(4, 11)
    local QuickSlotClose_Alpha = Panel_NewQuest:addColorAnimation(2, 3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    QuickSlotClose_Alpha:SetStartColor(UI_color.C_FFFFFFFF)
    QuickSlotClose_Alpha:SetEndColor(UI_color.C_00FFFFFF)
    QuickSlotClose_Alpha.IsChangeChild = true
    QuickSlotClose_Alpha:SetHideAtEnd(true)
    QuickSlotClose_Alpha:SetDisableWhileAni(true)
    Panel_NewQuest:SetIgnore(true)
    _blackStone:SetShow(true)
    _blackStone:SetIgnore(true)
    newQuest_ShowAnimation()
    if _startAnimation == false then
      audioPostEvent_SystemUi(4, 5)
      _AudioPostEvent_SystemUiForXBOX(4, 5)
      Panel_NewQuest:ComputePos()
      _blackStone:ResetVertexAni()
      _blackStone:SetVertexAniRun("Ani_Scale_StoneShow", true)
      _blackStone:SetVertexAniRun("Ani_Color_StoneShow", true)
      _startAnimation = true
    else
      return
    end
    _callingYou:SetShow(true)
    if 0 == isColorBlindMode then
      _callingYou:SetFontColor(UI_color.C_FFEE5555)
    elseif 1 == isColorBlindMode then
      _callingYou:SetFontColor(UI_color.C_FF0096FF)
    elseif 2 == isColorBlindMode then
      _callingYou:SetFontColor(UI_color.C_FF0096FF)
    end
    _callingYou:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_CALLINGYOUT"))
    local blackSpiritKeyString = keyCustom_GetString_UiKey(CppEnums.UiInputType.UiInputType_BlackSpirit)
    _callingYou_Sub:SetShow(true)
    _callingYou_Sub:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_QUESTLIST_CALLINGYOU_SUB", "keyString", blackSpiritKeyString))
    _cumulatedTime = 0
  end
end
function newQuest_ShowAnimation()
  _blackStone:ResetVertexAni()
  _blackStone:SetAlpha(1)
end
function newQuest_HideAnimation()
  if _startAnimation == true then
    _blackStone:ResetVertexAni()
    _blackStone:SetVertexAniRun("Ani_Scale_StoneHide", true)
    _blackStone:SetVertexAniRun("Ani_Color_StoneHide", true)
    _newQuestTextBubble:SetShow(false)
    _newQuestText:SetShow(false)
    Panel_NewQuest:EraseAllEffect()
    _startAnimation = false
  end
end
function Panel_NewQuest_ScreenResize()
  Panel_NewQuest:SetPosX(getScreenSizeX() - getScreenSizeX() / 2 - Panel_NewQuest:GetSizeX() / 2)
  Panel_NewQuest:SetPosY(120)
end
Panel_NewQuest:RegisterUpdateFunc("updateNewQuestOpenRate")
function updateNewQuestOpenRate(deltaTime)
  _cumulatedTime = _cumulatedTime + deltaTime
  if false == _ContentsGroup_RenewUI then
    if _cumulatedTime > 3.5 then
      Panel_NewQuest:SetShow(false, true)
      _cumulatedTime = 0
    end
  elseif _cumulatedTime > 8 then
    Panel_NewQuest:SetShow(false, true)
    _cumulatedTime = 0
  end
end
function SelfPlayer_RideOn()
  HideUseTab_Func()
  isRide = true
end
function SelfPlayer_RideOff()
  isRide = false
end
registerEvent("onScreenResize", "Panel_NewQuest_ScreenResize")
registerEvent("EventSelfPlayerRideOn", "SelfPlayer_RideOn")
registerEvent("EventSelfPlayerRideOff", "SelfPlayer_RideOff")
