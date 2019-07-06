local renderMode = RenderModeWrapper.new(100, {
  Defines.RenderMode.eRenderMode_IngameCustomize
}, false)
local gameExitPhoto = false
local characterInfoPhoto = false
local CharacterSlotIndex = 0
function IngameCustomize_isClearToShow()
  if isGameTypeGT() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NOUSE_FUNCTION"))
    return false
  end
  if isDeadInWatchingMode() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BEAUTYOPENALERT_INDEAD"))
    return false
  end
  if isFlushedUI() then
    return false
  end
  local terraintype = selfPlayerNaviMaterial()
  if 8 == terraintype or 9 == terraintype then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_DONTOPEN_INWATER"))
    return false
  end
  if not FGlobal_IsCommercialService() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_NOTUSE"))
    return false
  end
  if GetUIMode() == Defines.UIMode.eUIMode_Gacha_Roulette then
    return false
  end
  if nil == getCustomizingManager() then
    return false
  end
  if true == getCustomizingManager():isShow() then
    return false
  end
  if false == getCustomizingManager():isReady() then
    return false
  end
  return true
end
function IngameCustomize_Show()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if not IngameCustomize_isClearToShow() then
    return
  end
  TooltipSimple_Hide()
  TooltipCommon_Hide()
  PaGlobalFunc_FullScreenFade_RunAfterFadeIn(IngameCustomize_ShowActual)
end
function IngameCustomize_ShowActual()
  PaGlobalFunc_FullScreenFade_FadeOut(0.5, 0.5)
  if not IngameCustomize_isClearToShow() then
    return
  end
  local isShowSuccess = getCustomizingManager():show()
  if false == isShowSuccess then
    return
  end
  ToClient_SaveUiInfo(false)
  if Panel_Win_System:GetShow() then
    allClearMessageData()
  end
  PaGlobal_IngameCustomize_OtherPanels_Close()
  audioPostEvent_SystemUi(1, 2)
  _AudioPostEvent_SystemUiForXBOX(1, 2)
  SetUIMode(Defines.UIMode.eUIMode_InGameCustomize)
  renderMode:set()
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_CUSTOMIZE")
end
function IngameCustomize_Hide()
  if nil == getCustomizingManager() then
    return
  end
  if false == getCustomizingManager():isShow() then
    return
  end
  if true == isChangedCustomizationData() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECUSTOMIZATION_MSGBOX_CANCEL")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = HandleClicked_CloseIngameCustomization,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    HandleClicked_CloseIngameCustomization()
  end
  if true == gameExitPhoto then
    GameExitShowToggle(false)
    if false == _ContentsGroup_RenewUI_ExitGame then
      refreshCharacterInfoData(CharacterSlotIndex + 1)
    end
  end
  if true == characterInfoPhoto then
    if true == _ContentsGroup_RenewUI then
      PaGlobalFunc_CharacterInfo_UpdateFacePhoto()
    else
      PaGlobal_CharacterInfoBasic:updateFacePhoto()
    end
  end
  gameExitPhoto = false
  characterInfoPhoto = false
  if false == _ContentsGroup_RenewUI_Customization then
    faceHairCustomUpdate(false)
  end
end
function IngameCustomize_CancelIntroAction()
  if false == getCustomizingManager():isShow() then
    return
  end
  if true == getCustomizingManager():onActiveTimer() then
    getCustomizingManager():cancelIntroAction()
    return
  end
end
function HandleClicked_CloseIngameCustomization()
  PaGlobalFunc_FullScreenFade_CustomizeOnly(HandleClicked_CloseIngameCustomizationActual)
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
  ToClient_DeleteCustomizationTempData()
end
function HandleClicked_CloseIngameCustomizationActual()
  if false == _ContentsGroup_RenewUI_Customization then
    CloseCharacterCustomization()
    getCustomizingManager():hide()
    renderMode:reset()
    SetUIMode(Defines.UIMode.eUIMode_Default)
    Panel_CustomizationMessage:SetShow(false)
    Panel_CustomizationStatic:SetShow(false)
    if false == _ContentsGroup_RenewUI_Chatting then
      Panel_Chat0:SetShow(true)
    end
    Panel_Cash_Customization:SetShow(false)
    CashCumaBuy_Close()
    allClearMessageData()
    CustomizingAlbum_Close()
    closeExplorer()
    Panel_CustomizationVoice:SetShow(false)
  else
    getCustomizingManager():hide()
    renderMode:reset()
    SetUIMode(Defines.UIMode.eUIMode_Default)
    PaGlobalFunc_Customization_Close()
  end
end
function IsGameExitPhoto(isCheck)
  gameExitPhoto = isCheck
end
function characterSlot_Index(index)
  CharacterSlotIndex = index
end
function FGlobal_InGameCustomize_SetCharacterInfo(isCheck)
  characterInfoPhoto = isCheck
end
function PaGlobal_IngameCustomize_OtherPanels_Close()
  if nil ~= Panel_IngameCashShop_EasyPayment and Panel_IngameCashShop_EasyPayment:IsShow() then
    Panel_IngameCashShop_EasyPayment:SetShow(false, false)
  end
  if nil ~= Panel_CustomizingAlbum and Panel_CustomizingAlbum:GetShow() then
    CustomizingAlbum_Close()
  end
  if nil ~= InGameShopBuy_Close then
    InGameShopBuy_Close()
  end
  if nil ~= FGlobal_WebHelper_ForceClose then
    FGlobal_WebHelper_ForceClose()
  end
end
renderMode:setClosefunctor(renderMode, IngameCustomize_Hide)
