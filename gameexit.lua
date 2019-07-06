local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
Panel_GameExit:setMaskingChild(true)
Panel_GameExit:RegisterShowEventFunc(true, "GameExit_ShowAni()")
Panel_GameExit:RegisterShowEventFunc(false, "GameExit_HideAni()")
Panel_GameExit:setGlassBackground(true)
local _buttonExitCancel = UI.getChildControl(Panel_GameExit, "Button_Exit_Cancel")
local _buttonExitConfirm = UI.getChildControl(Panel_GameExit, "Button_Exit_Confirm")
local _buttonExitClose = UI.getChildControl(Panel_GameExit, "Button_Exit_Close")
local _buttonBackCharacterSelect = UI.getChildControl(Panel_GameExit, "Button_Return_CharacterSelect")
local _textNoticeMsg = UI.getChildControl(Panel_GameExit, "StaticText_NoticeText_0")
local _textExitQuestionMsg = UI.getChildControl(Panel_GameExit, "StaticText_ExitMsg")
local _buttonApply = UI.getChildControl(Panel_GameExit, "Button_Apply")
local exitMode = -1
enum_ExitMode = {
  eExitMode_GameExit = 0,
  eExitMode_BackCharacter = 1,
  eExitMode_SwapCharacter = 2
}
local exit_Time = 0
local prevTime = 0
local selectCharacterIndex = -1
local back_CharacterSelectTime = 0
function gameExit_UpdatePerFrame(deltaTime)
  if exit_Time > 0 then
    exit_Time = exit_Time - deltaTime
    local remainTime = math.floor(exit_Time)
    if prevTime ~= remainTime then
      if remainTime < 0 then
        remainTime = 0
      end
      prevTime = remainTime
      if enum_ExitMode.eExitMode_GameExit == exitMode then
        _textNoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_EXIT", "remainTime", tostring(remainTime)))
        if prevTime <= 0 then
          exit_Time = -1
          _textNoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_PROGRESS"))
          doGameLogOut()
        end
      elseif enum_ExitMode.eExitMode_BackCharacter == exitMode then
        _textNoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_SELECT", "remainTime", tostring(remainTime)))
        if prevTime <= 0 then
          exit_Time = -1
          _textNoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_CHARACTERSELECT"))
        end
      elseif enum_ExitMode.eExitMode_SwapCharacter == exitMode then
        _textNoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_SWAPCHARACTER", "remainTime", tostring(remainTime)))
        if prevTime <= 0 then
          exit_Time = -1
          _textNoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_SWAPCHARACTER"))
        end
      end
    end
  end
end
function doGameLogOut()
  Panel_GameExit:SetShow(false)
  SetUIMode(Defines.UIMode.eUIMode_Default)
  sendGameLogOut()
end
function setGameExitDelayTime(delayTime)
  if false == Panel_GameExit:GetShow() then
    return
  end
  exit_Time = delayTime
  if enum_ExitMode.eExitMode_SwapCharacter ~= exitMode then
    _textExitQuestionMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_CANCEL"))
  end
  if enum_ExitMode.eExitMode_GameExit == exitMode then
    _textNoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_EXIT", "remainTime", tostring(delayTime)))
  elseif enum_ExitMode.eExitMode_BackCharacter == exitMode then
    _textNoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_SELECT", "remainTime", tostring(delayTime)))
  end
end
function btn_Click_ExitConfirm()
  exitMode = enum_ExitMode.eExitMode_GameExit
  sendBeginGameDelayExit(enum_ExitMode.eExitMode_SwapCharacter == exitMode)
  _buttonExitConfirm:SetShow(false)
  _buttonExitClose:SetShow(false)
  _buttonExitCancel:SetShow(true)
  _buttonBackCharacterSelect:SetShow(false)
end
function btn_Click_ExitCancel()
  sendGameDelayExitCancel()
  if enum_ExitMode.eExitMode_SwapCharacter == exitMode then
    showGameExitPanel(1, selectCharacterIndex)
  else
    _textNoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_TITLE"))
    _textExitQuestionMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_FINAL_CHECK"))
    exit_Time = 0
    _buttonExitConfirm:SetShow(true)
    _buttonExitClose:SetShow(true)
    _buttonExitCancel:SetShow(false)
    _buttonBackCharacterSelect:SetShow(true)
  end
  exitMode = -1
  prevTime = -1
end
function GameExit_ShowAni()
  UIAni.fadeInSCR_Down(Panel_GameExit)
end
function GameExit_HideAni()
  Panel_GameExit:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local gameExitHideAni = Panel_GameExit:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  gameExitHideAni:SetStartColor(UI_color.C_FFFFFFFF)
  gameExitHideAni:SetEndColor(UI_color.C_00FFFFFF)
  gameExitHideAni:SetStartIntensity(3)
  gameExitHideAni:SetEndIntensity(1)
  gameExitHideAni.IsChangeChild = true
  gameExitHideAni:SetHideAtEnd(true)
  gameExitHideAni:SetDisableWhileAni(true)
end
function btn_Click_ExitClose()
  SetUIMode(Defines.UIMode.eUIMode_Default)
  Panel_GameExit:SetShow(false, true)
  GameExit_HideAni()
  exit_Time = 0
  sendGameDelayExitCancel()
  selectCharacterIndex = -1
  local selfProxy = getSelfPlayer()
  if nil ~= selfProxy then
    selfProxy:get():setForceInputAble(true)
  end
end
function btn_Click_Back_CharacterSelect()
  exitMode = enum_ExitMode.eExitMode_BackCharacter
  if false == sendCharacterSelect() then
    exitMode = -1
    return
  end
  _buttonExitConfirm:SetShow(false)
  _buttonExitClose:SetShow(false)
  _buttonExitCancel:SetShow(true)
  _buttonBackCharacterSelect:SetShow(false)
  _textExitQuestionMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_CANCEL"))
end
function global_SwapCharacter(isSwitching)
  return swapCharacter_Select(swapCharacter._selectSwapCharacterIndex, isSwitching)
end
function btn_Click_SwapCharacter()
  exitMode = enum_ExitMode.eExitMode_SwapCharacter
  local rv = global_SwapCharacter(true)
  if false == rv then
    return
  end
  _buttonExitConfirm:SetShow(false)
  _buttonExitClose:SetShow(false)
  _buttonExitCancel:SetShow(true)
  _buttonApply:SetShow(false)
  _buttonBackCharacterSelect:SetShow(false)
  _textExitQuestionMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_SWAPCHARACTER"))
end
function showGameExitPanel(showBoxIndex, selectIndex)
  SetUIMode(Defines.UIMode.eUIMode_GameExit)
  exit_Time = 0
  exitMode = -1
  prevTime = -1
  selectCharacterIndex = selectIndex
  local selfProxy = getSelfPlayer()
  if nil ~= selfProxy then
    selfProxy:get():setForceInputAble(false)
  end
  if 0 == showBoxIndex then
    _textNoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_TITLE"))
    _textExitQuestionMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_FINAL_CHECK"))
    Panel_GameExit:SetShow(true, true)
    _buttonExitConfirm:SetIgnore(false)
    _buttonExitConfirm:SetShow(true)
    _buttonBackCharacterSelect:SetShow(true)
    _buttonExitCancel:SetShow(false)
    _buttonExitClose:SetShow(true)
    _buttonApply:SetShow(false)
    GameExit_ShowAni()
  else
    _textNoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_SWAP_CHARACTER_TITLE"))
    local characterData = getCharacterDataByIndex(selectCharacterIndex)
    _textExitQuestionMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_SWAP_CHARACTER_QUESTION", "characterName", getCharacterName(characterData)))
    Panel_GameExit:SetShow(true, true)
    _buttonExitConfirm:SetIgnore(true)
    _buttonExitConfirm:SetShow(false)
    _buttonBackCharacterSelect:SetShow(false)
    _buttonExitCancel:SetShow(false)
    _buttonExitClose:SetShow(true)
    _buttonApply:SetShow(true)
    GameExit_ShowAni()
  end
end
local function Game_Exit_InitUIControl()
  _buttonExitCancel:addInputEvent("Mouse_LUp", "btn_Click_ExitCancel()")
  _buttonExitConfirm:addInputEvent("Mouse_LUp", "btn_Click_ExitConfirm()")
  _buttonExitClose:addInputEvent("Mouse_LUp", "btn_Click_ExitClose()")
  _buttonBackCharacterSelect:addInputEvent("Mouse_LUp", "btn_Click_Back_CharacterSelect()")
  _buttonApply:addInputEvent("Mouse_LUp", "btn_Click_SwapCharacter()")
  Panel_GameExit:RegisterUpdateFunc("gameExit_UpdatePerFrame")
  registerEvent("EventGameExitDelayTime", "setGameExitDelayTime")
end
Game_Exit_InitUIControl()
