Panel_RhythmGame:SetShow(false, false)
local MGKT = CppEnums.MiniGameKeyType
local UIColor = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local _rhythmBG = UI.getChildControl(Panel_RhythmGame, "Static_rhythmBG")
local _rhythmNote = UI.getChildControl(Panel_RhythmGame, "Static_rhythmNote")
local _rhythmCursor = UI.getChildControl(Panel_RhythmGame, "Static_rhythmCursor")
local _purposeMessage = UI.getChildControl(Panel_RhythmGame, "StaticText_Purpose")
local _MouseBody_L = UI.getChildControl(Panel_RhythmGame, "Static_MouseBody_L")
local _MouseBody_R = UI.getChildControl(Panel_RhythmGame, "Static_MouseBody_R")
local _LButton_L = UI.getChildControl(Panel_RhythmGame, "Static_L_Btn_L")
local _LButton_R = UI.getChildControl(Panel_RhythmGame, "Static_L_Btn_R")
local _RButton_L = UI.getChildControl(Panel_RhythmGame, "Static_R_Btn_L")
local _RButton_R = UI.getChildControl(Panel_RhythmGame, "Static_R_Btn_R")
local _fontGood = UI.getChildControl(Panel_RhythmGame, "Static_Result_Good")
local _fontBad = UI.getChildControl(Panel_RhythmGame, "Static_Result_Bad")
_rhythmNote:SetShow(false)
local isRhythmGamePlay = false
_nowCursorPosX = 0
_justCursorPosX = 0
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
local rhythmQuestList = {
  [0] = {questGroup = 1001, questId = 7},
  {questGroup = 1001, questId = 53},
  {questGroup = 2001, questId = 58},
  {questGroup = 6505, questId = 3},
  {questGroup = 780, questId = 5}
}
local miniGameNo = 1101
for idx = 1, bufferMax do
  local control = UI.createControl(UCT.PA_UI_CONTROL_STATIC, Panel_RhythmGame, "Static_rhythmNote_" .. idx)
  CopyBaseProperty(_rhythmNote, control)
  control:SetShow(false)
  noteBuffer[idx] = control
end
local function posSetting(control, index)
  CopyBaseProperty(_rhythmNote, control)
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
function Rhythm_RePosition()
  Panel_RhythmGame:SetSize(scrX, scrY)
end
local isFailed = false
local questCheckTime = 0
local playingTime = 20
function RhythmGame_UpdateFunc(fDeltaTime)
  currentSumTime = currentSumTime + fDeltaTime
  questCheckTime = questCheckTime + fDeltaTime
  local posOver = _rhythmBG:GetPosY() + _rhythmBG:GetSizeY() - hideSize - _rhythmNote:GetSizeY() + 5
  local culledPos = _rhythmBG:GetPosY() + _rhythmBG:GetSizeY() - hideSize - culledSize - _rhythmNote:GetSizeY()
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
        audioPostEvent_SystemUi(11, 2)
        _fontBad:SetShow(true)
        _fontBad:ResetVertexAni()
        _fontBad:SetVertexAniRun("Bad_Ani_Start", true)
        _fontBad:SetVertexAniRun("Bad_Ani", true)
        isFailed = true
        questCheckTime = 0
      end
    end
  end
  if Rhythm_QuestCheck() and playingTime < questCheckTime then
    request_clearMiniGame(miniGameNo)
    questCheckTime = 0
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
function Rhythm_QuestCheck()
  for index = 0, #rhythmQuestList do
    if questList_hasProgressQuest(rhythmQuestList[index].questGroup, rhythmQuestList[index].questId) then
      return true
    end
  end
  return false
end
function Panel_Minigame_Rhythm_Start()
  Interaction_Close()
  _fontBad:SetShow(false)
  cursorIndex = 2
  isFailed = false
  bufferIndex = 1
  for k, v in pairs(noteBuffer) do
    posSetting(v, 1)
  end
  Panel_RhythmGame:SetShow(true, false)
  posSetting(_rhythmNote, 4)
  _rhythmBG:SetPosX(scrX / 2 - _rhythmBG:GetSizeX() / 2)
  _rhythmCursor:SetPosX(scrX / 2 - 12)
  _purposeMessage:SetPosX(scrX / 2 - _purposeMessage:GetSizeX() / 2)
  _MouseBody_L:SetPosX(scrX / 2 - 125)
  _MouseBody_R:SetPosX(scrX / 2 + 100)
  _LButton_L:SetPosX(scrX / 2 - 125)
  _LButton_R:SetPosX(scrX / 2 - 113)
  _RButton_L:SetPosX(scrX / 2 + 100)
  _RButton_R:SetPosX(scrX / 2 + 112)
  _nowCursorPosX = _rhythmCursor:GetPosX()
  _justCursorPosX = _rhythmCursor:GetPosX()
  _fontBad:SetPosX(scrX / 2 - _fontBad:GetSizeX() / 2)
  questCheckTime = 0
end
function Panel_Minigame_Rhythm_End()
  Panel_RhythmGame:SetShow(false, false)
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
function MiniGame_Rhythm_KeyPress(keyType)
  if isFailed == true then
    return
  end
  if MGKT.MiniGameKeyType_M0 == keyType then
    Panel_Minigame_Rhythm_GaugeMove_Left()
  elseif MGKT.MiniGameKeyType_M1 == keyType then
    Panel_Minigame_Rhythm_GaugeMove_Right()
  end
end
registerEvent("onScreenResize", "Rhythm_RePosition")
Panel_RhythmGame:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
Rhythm_RePosition()
