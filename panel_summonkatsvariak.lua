local UI_TM = CppEnums.TextMode
local VCK = CppEnums.VirtualKeyCode
local UI_color = Defines.Color
local UI_classType = CppEnums.ClassType
local IM = CppEnums.EProcessorInputMode
local _stepNo = 0
local ui = {
  _facePicture_L = UI.getChildControl(Panel_SummonKatsvariak, "Static_FacePicture_Left"),
  _facePicture_R = UI.getChildControl(Panel_SummonKatsvariak, "Static_FacePicture_Right"),
  _textBg = UI.getChildControl(Panel_SummonKatsvariak, "Static_TextBg"),
  _archorTextBg = UI.getChildControl(Panel_SummonKatsvariak, "Static_Archor_TextBg")
}
ui._characterName = UI.getChildControl(ui._textBg, "StaticText_CharacterName")
ui._script = UI.getChildControl(ui._textBg, "StaticText_Script")
ui._archorScript = UI.getChildControl(ui._archorTextBg, "StaticText_Archor_Script")
local iconPath = "New_UI_Common_forLua/Default/Default_Etc_06.dds"
local data = {
  [610] = {
    _path = false,
    _isLeft = false,
    _name = false,
    _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_SUMMONKATSVARIAK_01")
  },
  [611] = {
    _path = {
      _x1 = 237,
      _y1 = 473,
      _x2 = 472,
      _y2 = 708
    },
    _isLeft = false,
    _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONKATSVARIAK_NPCNAME_2"),
    _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_SUMMONKATSVARIAK_02")
  },
  [612] = {
    _path = {
      _x1 = 236,
      _y1 = 473,
      _x2 = 1,
      _y2 = 708
    },
    _isLeft = false,
    _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONKATSVARIAK_NPCNAME_1"),
    _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_SUMMONKATSVARIAK_03")
  },
  [613] = {
    _path = false,
    _isLeft = false,
    _name = false,
    _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_SUMMONKATSVARIAK_04")
  },
  [614] = {
    _path = {
      _x1 = 237,
      _y1 = 473,
      _x2 = 472,
      _y2 = 708
    },
    _isLeft = false,
    _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONKATSVARIAK_NPCNAME_2"),
    _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_SUMMONKATSVARIAK_05")
  },
  [615] = {
    _path = {
      _x1 = 236,
      _y1 = 473,
      _x2 = 1,
      _y2 = 708
    },
    _isLeft = false,
    _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONKATSVARIAK_NPCNAME_1"),
    _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_SUMMONKATSVARIAK_06")
  },
  [616] = {
    _path = false,
    _isLeft = false,
    _name = false,
    _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_SUMMONKATSVARIAK_07")
  }
}
local function ui_Show(isShow)
  for v, control in pairs(ui) do
    control:SetShow(isShow)
    control:ComputePos()
  end
end
ui_Show(false)
local function tutorial_UISet(_stepNo)
  ui_Show(true)
  ui._facePicture_L:SetShow(false)
  ui._facePicture_R:SetShow(false)
  local tutorialData = data[_stepNo]
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  if tutorialData._path then
    ui._archorTextBg:SetShow(false)
    ui._textBg:SetShow(true)
    ui._characterName:SetText(tutorialData._name)
    ui._script:SetHorizonCenter()
    ui._characterName:SetSpanSize(ui._characterName:GetSpanSize().x + (ui._script:GetPosX() - ui._characterName:GetPosX()), ui._characterName:GetSpanSize().y)
    ui._script:SetTextMode(UI_TM.eTextMode_AutoWrap)
    ui._script:SetText(tutorialData._desc)
    ui._textBg:SetSize(ui._textBg:GetSizeX(), ui._script:GetTextSizeY() + 40)
    if tutorialData._isLeft then
      ui._facePicture_L:SetShow(true)
      ui._facePicture_L:ChangeTextureInfoName(iconPath)
      local x1, y1, x2, y2 = setTextureUV_Func(ui._facePicture_L, tutorialData._path._x1, tutorialData._path._y1, tutorialData._path._x2, tutorialData._path._y2)
      ui._facePicture_L:getBaseTexture():setUV(x1, y1, x2, y2)
      ui._facePicture_L:setRenderTexture(ui._facePicture_L:getBaseTexture())
    else
      ui._facePicture_R:SetShow(true)
      ui._facePicture_R:ChangeTextureInfoName(iconPath)
      local x1, y1, x2, y2 = setTextureUV_Func(ui._facePicture_R, tutorialData._path._x1, tutorialData._path._y1, tutorialData._path._x2, tutorialData._path._y2)
      ui._facePicture_R:getBaseTexture():setUV(x1, y1, x2, y2)
      ui._facePicture_R:setRenderTexture(ui._facePicture_R:getBaseTexture())
    end
  else
    ui._characterName:SetShow(false)
    ui._textBg:SetShow(false)
    ui._archorTextBg:SetShow(true)
    ui._archorScript:SetText(tutorialData._desc)
    ui._archorTextBg:SetSize(ui._archorScript:GetTextSizeX() + 70, ui._archorScript:GetTextSizeY() + 40)
    ui._archorTextBg:SetHorizonCenter()
    ui._archorScript:SetVerticalMiddle()
  end
end
local function updateDeltaTime_SummonKatsvariak(deltaTime, _stepNo)
  _updateTime = _updateTime + deltaTime
  if _stepNo >= 610 and _stepNo <= 616 and _updateTime >= 5 then
    Panel_SummonKatsvariak_Close()
    _updateTime = 0
    ui_Show(false)
  end
end
function SummonKatsvariak_BubbleMessage_1()
  _updateTime = 0
  _stepNo = 610
  Panel_SummonKatsvariak:SetShow(true)
  tutorial_UISet(_stepNo)
end
function SummonKatsvariak_BubbleMessage_2()
  _updateTime = 0
  _stepNo = 611
  Panel_SummonKatsvariak:SetShow(true)
  tutorial_UISet(_stepNo)
end
function SummonKatsvariak_BubbleMessage_3()
  _updateTime = 0
  _stepNo = 612
  Panel_SummonKatsvariak:SetShow(true)
  tutorial_UISet(_stepNo)
end
function SummonKatsvariak_BubbleMessage_4()
  _updateTime = 0
  _stepNo = 613
  Panel_SummonKatsvariak:SetShow(true)
  tutorial_UISet(_stepNo)
end
function SummonKatsvariak_BubbleMessage_5()
  _updateTime = 0
  _stepNo = 614
  Panel_SummonKatsvariak:SetShow(true)
  tutorial_UISet(_stepNo)
end
function SummonKatsvariak_BubbleMessage_6()
  _updateTime = 0
  _stepNo = 615
  Panel_SummonKatsvariak:SetShow(true)
  tutorial_UISet(_stepNo)
end
function SummonKatsvariak_BubbleMessage_7()
  _updateTime = 0
  _stepNo = 616
  Panel_SummonKatsvariak:SetShow(true)
  tutorial_UISet(_stepNo)
end
function Panel_SummonKatsvariak_Close()
  Panel_SummonKatsvariak:SetShow(false)
end
function Panel_SummonKatsvariak_doStep(deltaTime)
  updateDeltaTime_SummonKatsvariak(deltaTime, _stepNo)
end
function ArhorTutorial_ScreenRePosition()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_SummonKatsvariak:SetSize(scrX, scrY)
  Panel_SummonKatsvariak:SetPosX(0)
  Panel_SummonKatsvariak:SetPosY(0)
  ui._facePicture_L:SetSpanSize(scrX / 6 + scrX / 36 - scrX / 12, ui._facePicture_L:GetSpanSize().y + scrY / 14 * -1)
  ui._facePicture_R:SetSpanSize(scrX / 6 + scrX / 36 + scrX / 12, ui._facePicture_R:GetSpanSize().y + scrY / 14 * -1)
  ui._textBg:SetSpanSize(scrX / 6 + scrX / 36, scrY / 14 * -1)
  ui._archorTextBg:SetSpanSize(ui._archorTextBg:GetSpanSize().x, ui._archorTextBg:GetSpanSize().x + scrY / 7 * -1)
  for key, value in pairs(ui) do
    value:ComputePos()
  end
end
registerEvent("onScreenResize", "ArhorTutorial_ScreenRePosition")
Panel_SummonKatsvariak:RegisterUpdateFunc("Panel_SummonKatsvariak_doStep")
ActionChartEventBindFunction(610, SummonKatsvariak_BubbleMessage_1)
ActionChartEventBindFunction(611, SummonKatsvariak_BubbleMessage_2)
ActionChartEventBindFunction(612, SummonKatsvariak_BubbleMessage_3)
ActionChartEventBindFunction(613, SummonKatsvariak_BubbleMessage_4)
ActionChartEventBindFunction(614, SummonKatsvariak_BubbleMessage_5)
ActionChartEventBindFunction(615, SummonKatsvariak_BubbleMessage_6)
ActionChartEventBindFunction(616, SummonKatsvariak_BubbleMessage_7)
