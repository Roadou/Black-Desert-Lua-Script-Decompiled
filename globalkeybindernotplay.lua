local VCK = CppEnums.VirtualKeyCode
local GlobalKeyBinder_CheckKeyPressed = function(keyCode)
  return isKeyDown_Once(keyCode)
end
function GlobalKeyBinder_UpdateNotPlay(deltaTime)
  if MessageBox.isPopUp() then
    local pcKey = GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_RETURN) or GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_SPACE)
    if pcKey and not _ContentsGroup_RenewUI then
      MessageBox.keyProcessEnter()
      setUiInputProcessed(VCK.KeyCode_RETURN)
      setUiInputProcessed(VCK.KeyCode_SPACE)
      return true
    elseif isPadUp(__eJoyPadInputType_A) and _ContentsGroup_RenewUI then
    elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      MessageBox.keyProcessEscape()
      return true
    end
  end
  if nil ~= Panel_Login and Panel_Login:GetShow() or nil ~= Panel_Login_Renew and Panel_Login_Renew:GetShow() or nil ~= Panel_Login_Remaster and Panel_Login_Remaster:GetShow() then
    if nil ~= Panel_Window_Policy and Panel_Window_Policy:GetShow() then
      if true == ToClient_isConsole() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
        PaGlobal_Policy_Decline()
        return
      end
    elseif nil ~= Panel_Window_Copyright and Panel_Window_Copyright:GetShow() then
      if true == ToClient_isConsole() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
        PaGlobal_Copyright:close()
        return
      end
    elseif nil ~= Panel_TermsofGameUse and Panel_TermsofGameUse:GetShow() then
      if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_RETURN) then
        FGlobal_HandleClicked_TermsofGameUse_Next()
      elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
        FGlobal_TermsofGameUse_Close()
      end
    elseif nil ~= Panel_Login_Password and Panel_Login_Password:GetShow() then
      if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_RETURN) then
        LoginPassword_Enter()
      elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
        LoginPassword_Cancel()
      end
    elseif nil ~= Panel_Login_Nickname and Panel_Login_Nickname:GetShow() then
      return
    elseif nil ~= Panel_Login_Nickname_Renew and Panel_Login_Nickname_Renew:GetShow() then
      return
    elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_RETURN) then
      Panel_Login_BeforOpen()
    elseif nil ~= Panel_Lobby_UserSetting and Panel_Lobby_UserSetting:GetShow() then
      if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
        PaGlobalFunc_UserSetting_Close()
      end
    elseif nil ~= Panel_Window_ConsoleUIOffset and Panel_Window_ConsoleUIOffset:GetShow() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      PaGlobal_ConsoleUIOffset_Close()
    end
  end
  if true == ToClient_isConsole() and true == ToClient_isServerSelectProcessor() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
    if nil ~= Panel_WebControl_Renew and Panel_WebControl_Renew:GetShow() then
      PaGlobalFunc_WebControl_Close()
      return
    end
    ToClient_disConnectToPressAForXBOX()
  end
  if nil ~= Panel_CharacterCreateSelectClass and Panel_CharacterCreateSelectClass:GetShow() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
    Panel_CharacterCreateCancel()
  end
  if nil ~= Panel_Lobby_ClassSelect_Renew and Panel_Lobby_ClassSelect_Renew:GetShow() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
    Panel_CharacterCreateCancel()
  end
  if nil ~= Panel_CustomizationMain and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) and true == characterCreateIsOnLookAtCameraTimerRunning() then
    characterCreateCancelIntroAction()
    return
  end
  if nil ~= Panel_CharacterSelectNew and Panel_CharacterSelectNew:GetShow() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
    CharacterSelect_Back()
  end
  if nil ~= Panel_CharacterSelect_Renew and Panel_CharacterSelect_Renew:GetShow() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
    PaGlobal_CharacterSelect_BackToServerSelect()
  end
  if nil ~= Panel_Lobby_CharacterSelect_Remaster and Panel_Lobby_CharacterSelect_Remaster:GetShow() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
    InputMLUp_CharacterSelect_ExitToServerSelect()
  end
  if nil ~= Panel_Window_cOption and Panel_Window_cOption:GetShow() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
    Panel_Window_cOption:SetShow(false, true)
  end
  if true == _ContentsGroup_RenewUI_Customization then
    if nil ~= Panel_Customizing and true == PaGlobalFunc_Customization_GetShow() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      PaGlobalFunc_Customization_Back()
    end
    if nil ~= Panel_Widget_ScreenShotFrame and Panel_Widget_ScreenShotFrame:GetShow() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      local screenShotFrame_Close = function()
        FGlobal_ScreenShotFrame_Close()
      end
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SCREENSHOTFRAME_MSGBOX_CONTENT")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_SCREENSHOTFRAME_MSGBOX_TITLE"),
        content = messageBoxMemo,
        functionYes = screenShotFrame_Close,
        functionNo = MessageBox_Empty_function,
        exitButton = true,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
      return
    end
  end
end
registerEvent("EventGlobalKeyBinderNotPlay", "GlobalKeyBinder_UpdateNotPlay")
