local MGKT = CppEnums.MiniGameKeyType
local UIColor = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local MiniGame_Rhythm = {
  _ui = {
    stc_RhythmBG = UI.getChildControl(Panel_RhythmGame, "Static_rhythmBG"),
    stc_RhythmNote = UI.getChildControl(Panel_RhythmGame, "Static_rhythmNote"),
    stc_RhythmCursor = UI.getChildControl(Panel_RhythmGame, "Static_rhythmCursor"),
    stc_Result_Good = UI.getChildControl(Panel_RhythmGame, "Static_Result_Good"),
    stc_Result_Bad = UI.getChildControl(Panel_RhythmGame, "Static_Result_Bad"),
    txt_Purpose = UI.getChildControl(Panel_RhythmGame, "StaticText_Purpose")
  }
}
local isRhythmGamePlay = false
local _nowCursorPosX = 0
local _justCursorPosX = 0
local cursorFixedValue = 5
local cursorIndexValue = 42
local cursorIndex = 3
local culledSize = 8
local hideSize = 20
local noteSpeed = 75
local noteBuffer = {}
local notePosBuffer = {}
local bufferMax = 50
local bufferIndex = 1
local createTime = 0.5
local currentSumTime = 0
local panelSetPosY = -180
local rhythmQuestList = {
  [0] = {questGroup = 1001, questId = 7},
  {questGroup = 1001, questId = 53},
  {questGroup = 2001, questId = 58},
  {questGroup = 6505, questId = 3}
}
local miniGameNo = 1101
local isFailed = false
local questCheckTime = 0
local playingTime = 20
local scrX = getScreenSizeX()
local scrY = getScreenSizeY()
function MiniGame_Rhythm:init()
  Panel_RhythmGame:SetShow(false, false)
  self._ui.stc_Console_Control_BG = UI.getChildControl(self._ui.stc_RhythmBG, "Static_Console_Control_BG")
  self._ui.stc_PC_Control_BG = UI.getChildControl(self._ui.stc_RhythmBG, "Static_PC_Control_BG")
  if _ContentsGroup_isConsolePadControl then
    self._ui.stc_LBButton = UI.getChildControl(self._ui.stc_Console_Control_BG, "Static_LB")
    self._ui.stc_RBButton = UI.getChildControl(self._ui.stc_Console_Control_BG, "Static_RB")
    self._ui.stc_Console_Control_BG:SetShow(true)
    self._ui.stc_PC_Control_BG:SetShow(false)
  else
    self._ui.stc_PC_Control_BG:SetShow(true)
    self._ui.stc_Console_Control_BG:SetShow(false)
    self._ui.stc_MouseBody_L = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_MouseBody_L")
    self._ui.stc_MouseBody_R = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_MouseBody_R")
    self._ui.stc_M0_L = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_L_Btn_L")
    self._ui.stc_M0_R = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_L_Btn_R")
    self._ui.stc_M1_L = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_R_Btn_L")
    self._ui.stc_M1_R = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_R_Btn_R")
  end
  self._ui.txt_Purpose:SetPosX(scrX / 2 - self._ui.txt_Purpose:GetSizeX() / 2)
  self._ui.txt_Purpose:SetPosY(scrY / 2 + 240)
  if _ContentsGroup_isConsolePadControl then
    self._ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_RHYTHM_1"))
  else
  end
  self._ui.stc_RhythmNote:SetShow(false)
  for idx = 1, bufferMax do
    local control = UI.createControl(UCT.PA_UI_CONTROL_STATIC, Panel_RhythmGame, "Static_rhythmNote_" .. idx)
    CopyBaseProperty(self._ui.stc_RhythmNote, control)
    control:SetShow(false)
    noteBuffer[idx] = control
  end
end
function MiniGame_Rhythm:posSetting(control, index)
  CopyBaseProperty(self._ui.stc_RhythmNote, control)
  if index == 1 then
    control:SetPosX(scrX / 2 - self._ui.stc_RhythmBG:GetSizeX() / 2 + 5)
  elseif index == 2 then
    control:SetPosX(scrX / 2 - self._ui.stc_RhythmBG:GetSizeX() / 2 + self._ui.stc_RhythmNote:GetSizeX() * (index - 1) + 5)
  elseif index == 3 then
    control:SetPosX(scrX / 2 - self._ui.stc_RhythmBG:GetSizeX() / 2 + self._ui.stc_RhythmNote:GetSizeX() * (index - 1) + 8)
  elseif index == 4 then
    control:SetPosX(scrX / 2 - self._ui.stc_RhythmBG:GetSizeX() / 2 + self._ui.stc_RhythmNote:GetSizeX() * (index - 1) + 10)
  elseif index == 5 then
    control:SetPosX(scrX / 2 - self._ui.stc_RhythmBG:GetSizeX() / 2 + self._ui.stc_RhythmNote:GetSizeX() * (index - 1) + 12)
  end
end
function MiniGame_Rhythm:getRhythm()
  local prevIndex = bufferIndex
  bufferIndex = bufferIndex + 1
  if bufferMax < bufferIndex then
    bufferIndex = 1
  end
  local rv = noteBuffer[prevIndex]
  notePosBuffer[prevIndex] = math.random(1, 5)
  self:posSetting(rv, notePosBuffer[prevIndex])
  return rv
end
function Rhythm_RePosition()
  scrX = getScreenSizeX()
  scrY = getScreenSizeY()
  Panel_RhythmGame:SetSize(scrX, scrY)
  Panel_RhythmGame:SetPosY(panelSetPosY)
end
function RhythmGame_UpdateFunc(fDeltaTime)
  local self = MiniGame_Rhythm
  currentSumTime = currentSumTime + fDeltaTime
  questCheckTime = questCheckTime + fDeltaTime
  local posOver = self._ui.stc_RhythmBG:GetPosY() + self._ui.stc_RhythmBG:GetSizeY() - hideSize - self._ui.stc_RhythmNote:GetSizeY() + 5
  local culledPos = self._ui.stc_RhythmBG:GetPosY() + self._ui.stc_RhythmBG:GetSizeY() - hideSize - culledSize - self._ui.stc_RhythmNote:GetSizeY()
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
        self._ui.txt_Purpose:SetShow(false)
        self._ui.stc_Result_Bad:SetShow(true)
        self._ui.stc_Result_Bad:ResetVertexAni()
        self._ui.stc_Result_Bad:SetVertexAniRun("Bad_Ani_Start", true)
        self._ui.stc_Result_Bad:SetVertexAniRun("Bad_Ani", true)
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
      local targetControl = self:getRhythm()
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
  local self = MiniGame_Rhythm
  Rhythm_RePosition()
  Interaction_Close()
  PaGlobal_ConsoleQuickMenu:widgetClose()
  Panel_ConsoleKeyGuide:SetShow(false)
  self._ui.stc_Result_Bad:SetShow(false)
  if _ContentsGroup_isConsolePadControl then
    cursorIndex = 2
  else
    cursorIndex = 3
  end
  isFailed = false
  bufferIndex = 1
  for k, v in pairs(noteBuffer) do
    self:posSetting(v, 1)
  end
  Panel_RhythmGame:SetShow(true, false)
  self._ui.txt_Purpose:SetShow(true)
  self:posSetting(self._ui.stc_RhythmNote, 4)
  self._ui.stc_RhythmBG:SetPosX(scrX / 2 - self._ui.stc_RhythmBG:GetSizeX() / 2)
  self._ui.stc_RhythmCursor:SetPosX(scrX / 2 - self._ui.stc_RhythmCursor:GetSizeX() / 2)
  self._ui.stc_RhythmCursor:SetPosY(self._ui.stc_RhythmBG:GetPosY() + self._ui.stc_RhythmBG:GetSizeY() / 2 + 124)
  _nowCursorPosX = self._ui.stc_RhythmCursor:GetPosX()
  _justCursorPosX = self._ui.stc_RhythmCursor:GetPosX()
  self._ui.stc_Result_Bad:SetPosX(scrX / 2 - self._ui.stc_Result_Bad:GetSizeX() / 2)
  self._ui.stc_Result_Bad:SetPosY(scrY / 2 - panelSetPosY)
  questCheckTime = 0
end
function Panel_Minigame_Rhythm_End()
  PaGlobal_ConsoleQuickMenu:widgetOpen()
  Panel_ConsoleKeyGuide:SetShow(true)
  Panel_RhythmGame:SetShow(false, false)
end
function MiniGame_Rhythm:rhythmCursorAlign()
  self._ui.stc_RhythmCursor:SetPosX(self._ui.stc_RhythmBG:GetPosX() + cursorFixedValue + cursorIndexValue * cursorIndex)
end
function MiniGame_Rhythm:Panel_Minigame_Rhythm_GaugeMove_Left()
  if false == _ContentsGroup_isConsolePadControl then
    self._ui.stc_M0_L:ResetVertexAni()
    self._ui.stc_M0_L:SetVertexAniRun("Ani_Color_Left", true)
  end
  cursorIndex = cursorIndex - 1
  if cursorIndex < 0 then
    cursorIndex = 0
  end
  self:rhythmCursorAlign()
end
function MiniGame_Rhythm:Panel_Minigame_Rhythm_GaugeMove_Right()
  if false == _ContentsGroup_isConsolePadControl then
    self._ui.stc_M1_R:ResetVertexAni()
    self._ui.stc_M1_R:SetVertexAniRun("Ani_Color_Right", true)
  end
  cursorIndex = cursorIndex + 1
  if cursorIndex > 4 then
    cursorIndex = 4
  end
  self:rhythmCursorAlign()
end
function MiniGame_Rhythm_KeyPress(keyType)
  local self = MiniGame_Rhythm
  if isFailed == true then
    return
  end
  if _ContentsGroup_isConsolePadControl then
    return
  end
  if MGKT.MiniGameKeyType_M0 == keyType then
    self:Panel_Minigame_Rhythm_GaugeMove_Left()
  elseif MGKT.MiniGameKeyType_M1 == keyType then
    self:Panel_Minigame_Rhythm_GaugeMove_Right()
  end
end
function MiniGame_Rhythm_PadKeyPress(keyType)
  local self = MiniGame_Rhythm
  if isFailed == true or false == Panel_RhythmGame:GetShow() then
    return
  end
  if __eQuickTimeEventPadType_LB == keyType then
    self:Panel_Minigame_Rhythm_GaugeMove_Left()
  elseif __eQuickTimeEventPadType_RB == keyType then
    self:Panel_Minigame_Rhythm_GaugeMove_Right()
  end
end
function FromClient_luaLoadComplete_MiniGame_Rhythm_Init()
  local self = MiniGame_Rhythm
  self:init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MiniGame_Rhythm_Init")
registerEvent("EventActionMiniGamePadDownOnce", "MiniGame_Rhythm_PadKeyPress")
registerEvent("EventActionMiniGameKeyDownOnce", "MiniGame_Rhythm_KeyPress")
registerEvent("onScreenResize", "Rhythm_RePosition")
Panel_RhythmGame:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
