Panel_RhythmGame_ForAction:SetShow(false, false)
local MGKT = CppEnums.MiniGameKeyType
local UIColor = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local _rhythmBG = UI.getChildControl(Panel_RhythmGame_ForAction, "Static_rhythmBG")
local action_rhythmNote = UI.getChildControl(Panel_RhythmGame_ForAction, "Static_rhythmNote")
local _rhythmCursor = UI.getChildControl(Panel_RhythmGame_ForAction, "Static_rhythmCursor")
local _purposeMessage = UI.getChildControl(Panel_RhythmGame_ForAction, "StaticText_Purpose")
local _MouseBody_L = UI.getChildControl(Panel_RhythmGame_ForAction, "Static_MouseBody_L")
local _MouseBody_R = UI.getChildControl(Panel_RhythmGame_ForAction, "Static_MouseBody_R")
local _LButton_L = UI.getChildControl(Panel_RhythmGame_ForAction, "Static_L_Btn_L")
local _LButton_R = UI.getChildControl(Panel_RhythmGame_ForAction, "Static_L_Btn_R")
local _RButton_L = UI.getChildControl(Panel_RhythmGame_ForAction, "Static_R_Btn_L")
local _RButton_R = UI.getChildControl(Panel_RhythmGame_ForAction, "Static_R_Btn_R")
local _fontGood = UI.getChildControl(Panel_RhythmGame_ForAction, "Static_Result_Good")
local _fontBad = UI.getChildControl(Panel_RhythmGame_ForAction, "Static_Result_Bad")
action_rhythmNote:SetShow(false)
action_nowCursorPosX = 0
action_justCursorPosX = 0
local isRhythmGamePlay = false
local scrX = getScreenSizeX()
local scrY = getScreenSizeY()
local cursorFixedValue = 5
local cursorIndexValue = 31
local cursorIndex = 0
local culledSize = 10
local hideSize = 20
local noteSpeed = 75
local noteBuffer = {}
local notePosBuffer = {}
local bufferMax = 50
local bufferIndex = 1
local createTime = 0.5
local currentSumTime = 0
for idx = 1, bufferMax do
  local control = UI.createControl(UCT.PA_UI_CONTROL_STATIC, Panel_RhythmGame_ForAction, "Staticaction_rhythmNote_" .. idx)
  CopyBaseProperty(action_rhythmNote, control)
  control:SetShow(false)
  noteBuffer[idx] = control
end
local function posSetting(control, index)
  CopyBaseProperty(action_rhythmNote, control)
  if index == 1 then
    control:SetPosX(scrX / 2 - _rhythmBG:GetSizeX() / 2 + 4)
  elseif index == 2 then
    control:SetPosX(scrX / 2 - _rhythmBG:GetSizeX() / 2 + 35)
  elseif index == 3 then
    control:SetPosX(scrX / 2 - _rhythmBG:GetSizeX() / 2 + 66)
  elseif index == 4 then
    control:SetPosX(scrX / 2 - _rhythmBG:GetSizeX() / 2 + 97)
  elseif index == 5 then
    control:SetPosX(scrX / 2 - _rhythmBG:GetSizeX() / 2 + 129)
  end
end
local function getRhythm()
  local prevIndex = bufferIndex
  bufferIndex = bufferIndex + 1
  if bufferMax < bufferIndex then
    bufferIndex = 1
  end
  local rv = noteBuffer[prevIndex]
  notePosBuffer[prevIndex] = math.random(1, 5)
  posSetting(rv, notePosBuffer[prevIndex])
  return rv
end
function RhythmForAction_RePosition()
  Panel_RhythmGame_ForAction:SetSize(scrX, scrY)
end
local isFailed = false
function RhythmGame_ForAction_UpdateFunc(fDeltaTime)
  currentSumTime = currentSumTime + fDeltaTime
  local posOver = _rhythmBG:GetPosY() + _rhythmBG:GetSizeY() - hideSize - action_rhythmNote:GetSizeY() + 5
  local culledPos = _rhythmBG:GetPosY() + _rhythmBG:GetSizeY() - hideSize - culledSize - action_rhythmNote:GetSizeY()
  for key, control in pairs(noteBuffer) do
    control:SetPosY(control:GetPosY() + fDeltaTime * noteSpeed)
    if posOver < control:GetPosY() then
      local value = control:GetPosY() - posOver
      control:SetAlpha((hideSize - value) / hideSize)
      if value > hideSize then
        control:SetShow(false)
      end
    elseif culledPos < control:GetPosY() and nil ~= notePosBuffer[key] and notePosBuffer[key] == cursorIndex + 1 and control:GetShow() then
      getSelfPlayer():get():SetMiniGameResult(1)
      control:SetShow(false)
      if isFailed == false then
        _fontBad:SetShow(true)
        _fontBad:ResetVertexAni()
        _fontBad:SetVertexAniRun("Bad_Ani_Start", true)
        _fontBad:SetVertexAniRun("Bad_Ani", true)
        isFailed = true
      end
    end
  end
  local count = 0
  if createTime < currentSumTime then
    currentSumTime = currentSumTime - createTime
    while (0 == count or 1 < math.random(0, 5)) and count < 2 do
      local targetControl = getRhythm()
      targetControl:SetShow(true)
      count = count + 1
    end
  end
end
function Panel_Minigame_RhythmForAction_Start()
  Interaction_Close()
  _fontBad:SetShow(false)
  isFailed = false
  bufferIndex = 1
  for k, v in pairs(noteBuffer) do
    posSetting(v, 1)
  end
  Panel_RhythmGame_ForAction:SetShow(true, false)
  posSetting(action_rhythmNote, 4)
  _rhythmBG:SetPosX(scrX / 2 - _rhythmBG:GetSizeX() / 2)
  _rhythmCursor:SetPosX(scrX / 2 - 12)
  _purposeMessage:SetPosX(scrX / 2 - _purposeMessage:GetSizeX() / 2)
  _MouseBody_L:SetPosX(scrX / 2 - 125)
  _MouseBody_R:SetPosX(scrX / 2 + 100)
  _LButton_L:SetPosX(scrX / 2 - 125)
  _LButton_R:SetPosX(scrX / 2 - 113)
  _RButton_L:SetPosX(scrX / 2 + 100)
  _RButton_R:SetPosX(scrX / 2 + 112)
  action_nowCursorPosX = _rhythmCursor:GetPosX()
  action_justCursorPosX = _rhythmCursor:GetPosX()
  _fontBad:SetPosX(scrX / 2 - _fontBad:GetSizeX() / 2)
end
function Panel_Minigame_RhythmForAction_End()
  Panel_RhythmGame_ForAction:SetShow(false, false)
end
local function rhythmCursorAlign()
  _rhythmCursor:SetPosX(_rhythmBG:GetPosX() + cursorFixedValue + cursorIndexValue * cursorIndex)
end
local function Panel_Minigame_Rhythm_GaugeMove_Left()
  _LButton_L:ResetVertexAni()
  _LButton_L:SetVertexAniRun("Ani_Color_Left", true)
  cursorIndex = cursorIndex - 1
  if cursorIndex < 0 then
    cursorIndex = 0
  end
  rhythmCursorAlign()
end
local function Panel_Minigame_Rhythm_GaugeMove_Right()
  _RButton_R:ResetVertexAni()
  _RButton_R:SetVertexAniRun("Ani_Color_Right", true)
  cursorIndex = cursorIndex + 1
  if cursorIndex > 4 then
    cursorIndex = 4
  end
  rhythmCursorAlign()
end
function MiniGame_RhythmForAction_KeyPress(keyType)
  if isFailed == true then
    return
  end
  if MGKT.MiniGameKeyType_M0 == keyType then
    Panel_Minigame_Rhythm_GaugeMove_Left()
  elseif MGKT.MiniGameKeyType_M1 == keyType then
    Panel_Minigame_Rhythm_GaugeMove_Right()
  end
end
registerEvent("onScreenResize", "RhythmForAction_RePosition")
Panel_RhythmGame_ForAction:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
RhythmForAction_RePosition()
