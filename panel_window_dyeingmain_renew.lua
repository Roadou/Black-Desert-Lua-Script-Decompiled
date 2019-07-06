local _panel = Panel_Window_DyeingMain_Renew
local renderMode = RenderModeWrapper.new(100, {
  Defines.RenderMode.eRenderMode_Dye
}, false)
local UI_BUFFTYPE = CppEnums.UserChargeType
local ENUM_EQUIP = CppEnums.EquipSlotNoClient
local CT = CppEnums.ClassType
local DyeingMain = {
  _ui = {
    stc_bottomBG = UI.getChildControl(_panel, "Static_BottomBg"),
    txt_keyGuides = {},
    txt_keyGuideWeather = nil
  },
  _curWeatherIndex = 1,
  _weatherTypeCount = 6,
  _isLDown = false,
  _isRDown = false
}
local _padLTIsPressed = false
function FromClient_luaLoadComplete_DyeingMain_Init()
  DyeingMain:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_DyeingMain_Init")
function DyeingMain:initialize()
  self._ui.txt_keyGuides = {
    UI.getChildControl(self._ui.stc_bottomBG, "StaticText_LTPlusY_ConsoleUI"),
    UI.getChildControl(self._ui.stc_bottomBG, "StaticText_RS2_ConsoleUI"),
    UI.getChildControl(self._ui.stc_bottomBG, "StaticText_RS_ConsoleUI"),
    UI.getChildControl(self._ui.stc_bottomBG, "StaticText_B_ConsoleUI")
  }
  UI.getChildControl(self._ui.stc_bottomBG, "StaticText_LTPlusY_ConsoleUI"):SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SUNICON") .. "            ")
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._ui.txt_keyGuides, self._ui.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  _panel:RegisterUpdateFunc("PaGlobalFunc_Dyeing_UpdatePerFrame")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LT, "Input_DyeingMain_PressedLT()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_LT, "Input_DyeingMain_ReleasedLT()")
end
function PaGlobalFunc_Dyeing_Open()
  DyeingMain:open()
end
function DyeingMain:open()
  if isDeadInWatchingMode() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DYEOPENALERT_INDEAD"))
    return
  end
  if true == ToClient_getJoinGuildBattle() then
    return
  end
  ToClient_SaveUiInfo(false)
  if isFlushedUI() then
    return
  end
  local isShow = ToClient_DyeingManagerIsShow()
  if true == isShow then
    return
  end
  local isShowable = ToClient_DyeingManagerIsShowable()
  if false == isShowable then
    return
  end
  if false == ToClient_IsAutoLevelUp() and not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_DYE"))
    return
  end
  if selfPlayerIsInCompetitionArea() then
    return
  end
  if true == ToClient_SniperGame_IsPlaying() then
    return
  end
  if Panel_Win_System:GetShow() then
    allClearMessageData()
  end
  SetUIMode(Defines.UIMode.eUIMode_DyeNew)
  renderMode:set()
  ToClient_DyeingManagerShow()
  ToClient_RequestSetTargetType(0)
  Panel_Tooltip_Item_hideTooltip()
  _panel:SetShow(true)
  PaGlobalFunc_DyeingMenu_Open()
  PaGlobalFunc_InventoryInfo_Close()
  renderMode:set()
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_DYEING")
end
function PaGlobalFunc_Dyeing_CloseAll()
  PaGlobalFunc_DyeingTake_Close()
  PaGlobalFunc_DyeingPalette_Close()
  PaGlobalFunc_DyeingPartList_Close()
  PaGlobalFunc_Dyeing_Close()
  PaGlobalFunc_DyeingMenu_Close()
  PaGlobalFunc_DyeingRegister_Close()
end
function PaGlobalFunc_Dyeing_OnPadB()
  if PaGlobalFunc_DyeingRegister_GetShow() then
    PaGlobalFunc_DyeingRegister_Close()
    return
  end
  if PaGlobalFunc_DyeingTake_GetShow() then
    PaGlobalFunc_DyeingTake_Close()
    PaGlobalFunc_DyeingMenu_Open()
    return
  end
  if PaGlobalFunc_DyeingPalette_GetShow() then
    PaGlobalFunc_DyeingPalette_Close()
    return
  end
  if PaGlobalFunc_DyeingPartList_GetShow() then
    PaGlobalFunc_DyeingPartList_Close()
    PaGlobalFunc_DyeingMenu_Open()
    return
  end
  PaGlobalFunc_DyeingMenu_Close()
  PaGlobalFunc_Dyeing_Close()
end
function PaGlobalFunc_Dyeing_Close()
  DyeingMain:close()
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function DyeingMain:close()
  if Panel_Win_System:GetShow() then
    allClearMessageData()
    return
  end
  local isShow = ToClient_DyeingManagerHide()
  if false == isShow then
    return
  end
  if false == _panel:GetShow() then
    return
  end
  SetUIMode(Defines.UIMode.eUIMode_Default)
  renderMode:reset()
  ToClient_DyeingManagerHide()
  audioPostEvent_SystemUi(1, 23)
  _AudioPostEvent_SystemUiForXBOX(1, 23)
  Panel_Tooltip_Item_hideTooltip()
  _panel:SetShow(false)
end
function PaGlobalFunc_Dyeing_ChangeWeather()
  local self = DyeingMain
  self._curWeatherIndex = self._curWeatherIndex + 1
  if self._curWeatherIndex > self._weatherTypeCount then
    self._curWeatherIndex = 1
  end
  local weatherTime
  if 1 == self._curWeatherIndex then
    weatherTime = 0
  elseif 2 == self._curWeatherIndex then
    weatherTime = 3
  elseif 3 == self._curWeatherIndex then
    weatherTime = 7
  elseif 4 == self._curWeatherIndex then
    weatherTime = 11
  elseif 5 == self._curWeatherIndex then
    weatherTime = 15
  elseif 6 == self._curWeatherIndex then
    weatherTime = 19
  end
  if nil ~= weatherTime then
    ToClient_RequestUpdateDyeSetCustomWeather(6, weatherTime)
  end
end
function PaGlobalFunc_Dyeing_UpdatePerFrame(deltaTime)
  local self = DyeingMain
  local RSX = getPadRightStickMoveX()
  local RSY = getPadRightStickMoveY()
  if 0 ~= RSX or 0 ~= RSY then
    if true == _padLTIsPressed then
      ToClient_RequestUpdateDyeVaryZoom(RSY * deltaTime * -300)
    else
      ToClient_RequestUpdateDyeVaryRotation(RSX * -0.8 * deltaTime, -(RSY * -2) * deltaTime)
    end
  end
end
function PaGlobalFunc_DyeingMain_ShowKeyGuideLT(isShow)
  DyeingMain._ui.txt_keyGuides[1]:SetShow(isShow)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(DyeingMain._ui.txt_keyGuides, DyeingMain._ui.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobalFunc_DyeingMain_ShowKeyGuideRSClick(isShow)
  DyeingMain._ui.txt_keyGuides[2]:SetShow(isShow)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(DyeingMain._ui.txt_keyGuides, DyeingMain._ui.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobalFunc_DyeingMain_ShowKeyGuideRS(isShow)
  DyeingMain._ui.txt_keyGuides[3]:SetShow(isShow)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(DyeingMain._ui.txt_keyGuides, DyeingMain._ui.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobalFunc_DyeingMain_ShowKeyGuideB(isShow)
  DyeingMain._ui.txt_keyGuides[4]:SetShow(isShow)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(DyeingMain._ui.txt_keyGuides, DyeingMain._ui.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Input_DyeingMain_PressedLT()
  _padLTIsPressed = true
end
function Input_DyeingMain_ReleasedLT()
  _padLTIsPressed = false
end
function PaGlobalFunc_DyeingMain_MoveKeyGuide(toX)
  DyeingMain._ui.stc_bottomBG:SetPosX(toX - DyeingMain._ui.stc_bottomBG:GetSizeX())
end
renderMode:setClosefunctor(renderMode, PaGlobalFunc_Dyeing_CloseAll)
