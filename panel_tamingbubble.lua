local UI_TM = CppEnums.TextMode
local VCK = CppEnums.VirtualKeyCode
local UI_color = Defines.Color
local UI_classType = CppEnums.ClassType
local IM = CppEnums.EProcessorInputMode
local _updateTime = 0
local _stepNo = 0
local npcTexture = "UI_Artwork/IC_00116.dds"
local ui = {
  _obsidian = UI.getChildControl(Panel_TamingBubble, "Static_Obsidian"),
  _obsidian_B = UI.getChildControl(Panel_TamingBubble, "Static_Obsidian_B"),
  _obsidian_B_Left = UI.getChildControl(Panel_TamingBubble, "Static_Obsidian_B_Left"),
  _obsidian_Text = UI.getChildControl(Panel_TamingBubble, "StaticText_Obsidian_B"),
  _obsidian_Text_2 = UI.getChildControl(Panel_TamingBubble, "StaticText_Obsidian_B_2")
}
ui._obsidian:ChangeTextureInfoName(npcTexture)
local function ui_Show(isShow)
  for v, control in pairs(ui) do
    control:SetShow(isShow)
  end
end
ui_Show(false)
local tamingBubble_Desc = {
  [1001] = PAGetString(Defines.StringSheet_GAME, "LUA_HORSE_TAMING_TUTORIAL_1"),
  [1002] = PAGetString(Defines.StringSheet_GAME, "LUA_HORSE_TAMING_TUTORIAL_2"),
  [1003] = PAGetString(Defines.StringSheet_GAME, "LUA_HORSE_TAMING_TUTORIAL_3"),
  [1004] = PAGetString(Defines.StringSheet_GAME, "LUA_HORSE_TAMING_TUTORIAL_4"),
  [1005] = PAGetString(Defines.StringSheet_GAME, "LUA_HORSE_TAMING_TUTORIAL_5"),
  [1006] = PAGetString(Defines.StringSheet_GAME, "LUA_HORSE_TAMING_TUTORIAL_6"),
  [1007] = PAGetString(Defines.StringSheet_GAME, "LUA_HORSE_TAMING_TUTORIAL_7"),
  [1008] = PAGetString(Defines.StringSheet_GAME, "LUA_HORSE_TAMING_TUTORIAL_8"),
  [1009] = PAGetString(Defines.StringSheet_GAME, "LUA_HORSE_TAMING_TUTORIAL_9"),
  [1010] = PAGetString(Defines.StringSheet_GAME, "LUA_HORSE_TAMING_TUTORIAL_10")
}
local isOpen = false
local basePosX = Panel_SelfPlayerExpGage:GetPosX() + Panel_SelfPlayerExpGage:GetSizeX() + 480
local basePosY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 60
local function updateDeltaTime_TamingBubble(deltaTime, index)
  _updateTime = _updateTime + deltaTime
  if 1 == index then
    if _updateTime < 20 then
      ui._obsidian_Text:SetText(tamingBubble_Desc[1001])
    else
      Panel_TamingBubble_Close()
      _updateTime = 0
    end
  elseif 2 == index then
    if _updateTime < 20 then
      ui._obsidian_Text:SetText(tamingBubble_Desc[1002])
    else
      Panel_TamingBubble_Close()
      _updateTime = 0
    end
  elseif 3 == index then
    if _updateTime < 20 then
      ui._obsidian_Text:SetText(tamingBubble_Desc[1003])
    else
      Panel_TamingBubble_Close()
      _updateTime = 0
    end
  elseif 4 == index then
    if _updateTime < 20 then
      ui._obsidian_Text:SetText(tamingBubble_Desc[1004])
    else
      Panel_TamingBubble_Close()
      _updateTime = 0
    end
  elseif 5 == index then
    if _updateTime < 20 then
      ui._obsidian_Text:SetText(tamingBubble_Desc[1005])
    else
      Panel_TamingBubble_Close()
      _updateTime = 0
    end
  elseif 6 == index then
    if _updateTime < 20 then
      ui._obsidian_Text:SetText(tamingBubble_Desc[1006])
    else
      Panel_TamingBubble_Close()
      _updateTime = 0
    end
  elseif 7 == index then
    if _updateTime < 20 then
      ui._obsidian_Text:SetText(tamingBubble_Desc[1007])
    else
      Panel_TamingBubble_Close()
      _updateTime = 0
    end
  elseif 8 == index then
    if _updateTime < 20 then
      ui._obsidian_Text:SetText(tamingBubble_Desc[1008])
    else
      Panel_TamingBubble_Close()
      _updateTime = 0
    end
  elseif 9 == index then
    if _updateTime < 20 then
      ui._obsidian_Text:SetText(tamingBubble_Desc[1009])
    else
      Panel_TamingBubble_Close()
      _updateTime = 0
    end
  elseif 10 == index then
    if _updateTime < 20 then
      ui._obsidian_Text:SetText(tamingBubble_Desc[1010])
    else
      Panel_TamingBubble_Close()
      _updateTime = 0
    end
  end
  ui._obsidian:SetPosX(basePosX - ui._obsidian:GetSizeX())
  ui._obsidian:SetPosY(basePosY - ui._obsidian:GetSizeY() + 60)
  ui._obsidian_B:SetPosX(basePosX)
  ui._obsidian_B:SetPosY(basePosY)
  ui._obsidian_Text:SetPosX(basePosX + 3)
  ui._obsidian_Text:SetPosY(basePosY + 35)
  ui._obsidian_B:SetSize(ui._obsidian_Text:GetTextSizeX() + 20, ui._obsidian_Text:GetTextSizeY() + 55)
end
function Taming_BubbleMessage_1()
  _updateTime = 0
  _stepNo = 1
  ui_Show(true)
  ui._obsidian_B_Left:SetShow(false)
  ui._obsidian_Text_2:SetShow(false)
  Panel_TamingBubble:SetShow(true)
end
function Taming_BubbleMessage_2()
  _updateTime = 0
  _stepNo = 2
  ui_Show(true)
  ui._obsidian_B_Left:SetShow(false)
  ui._obsidian_Text_2:SetShow(false)
  Panel_TamingBubble:SetShow(true)
end
function Taming_BubbleMessage_3()
  _updateTime = 0
  _stepNo = 3
  ui_Show(true)
  ui._obsidian_B_Left:SetShow(false)
  ui._obsidian_Text_2:SetShow(false)
  Panel_TamingBubble:SetShow(true)
end
function Taming_BubbleMessage_4()
  _updateTime = 0
  _stepNo = 4
  ui_Show(true)
  ui._obsidian_B_Left:SetShow(false)
  ui._obsidian_Text_2:SetShow(false)
  Panel_TamingBubble:SetShow(true)
end
function Taming_BubbleMessage_5()
  _updateTime = 0
  _stepNo = 5
  ui_Show(true)
  ui._obsidian_B_Left:SetShow(false)
  ui._obsidian_Text_2:SetShow(false)
  Panel_TamingBubble:SetShow(true)
end
function Taming_BubbleMessage_6()
  _updateTime = 0
  _stepNo = 6
  ui_Show(true)
  ui._obsidian_B_Left:SetShow(false)
  ui._obsidian_Text_2:SetShow(false)
  Panel_TamingBubble:SetShow(true)
end
function Taming_BubbleMessage_7()
  _updateTime = 0
  _stepNo = 7
  ui_Show(true)
  ui._obsidian_B_Left:SetShow(false)
  ui._obsidian_Text_2:SetShow(false)
  Panel_TamingBubble:SetShow(true)
end
function Taming_BubbleMessage_8()
  _updateTime = 0
  _stepNo = 8
  ui_Show(true)
  ui._obsidian_B_Left:SetShow(false)
  ui._obsidian_Text_2:SetShow(false)
  Panel_TamingBubble:SetShow(true)
end
function Taming_BubbleMessage_9()
  _updateTime = 0
  _stepNo = 9
  ui_Show(true)
  ui._obsidian_B_Left:SetShow(false)
  ui._obsidian_Text_2:SetShow(false)
  Panel_TamingBubble:SetShow(true)
end
function Taming_BubbleMessage_10()
  _updateTime = 0
  _stepNo = 10
  ui_Show(true)
  ui._obsidian_B_Left:SetShow(false)
  ui._obsidian_Text_2:SetShow(false)
  Panel_TamingBubble:SetShow(true)
end
function Panel_TamingBubble_Close()
  Panel_TamingBubble:SetShow(false)
end
function Panel_TamingBubble_doStep(deltaTime)
  if 1 == _stepNo then
    updateDeltaTime_TamingBubble(deltaTime, 1)
  elseif 2 == _stepNo then
    updateDeltaTime_TamingBubble(deltaTime, 2)
  elseif 3 == _stepNo then
    updateDeltaTime_TamingBubble(deltaTime, 3)
  elseif 4 == _stepNo then
    updateDeltaTime_TamingBubble(deltaTime, 4)
  elseif 5 == _stepNo then
    updateDeltaTime_TamingBubble(deltaTime, 5)
  elseif 6 == _stepNo then
    updateDeltaTime_TamingBubble(deltaTime, 6)
  elseif 7 == _stepNo then
    updateDeltaTime_TamingBubble(deltaTime, 7)
  elseif 8 == _stepNo then
    updateDeltaTime_TamingBubble(deltaTime, 8)
  elseif 9 == _stepNo then
    updateDeltaTime_TamingBubble(deltaTime, 9)
  elseif 10 == _stepNo then
    updateDeltaTime_TamingBubble(deltaTime, 10)
  end
end
function TamingBubble_ScreenRePosition()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_TamingBubble:SetSize(scrX, scrY)
  Panel_TamingBubble:SetPosX(0)
  Panel_TamingBubble:SetPosY(0)
  for key, value in pairs(ui) do
    value:ComputePos()
  end
end
registerEvent("onScreenResize", "TamingBubble_ScreenRePosition")
Panel_TamingBubble:RegisterUpdateFunc("Panel_TamingBubble_doStep")
ActionChartEventBindFunction(1001, Taming_BubbleMessage_1)
ActionChartEventBindFunction(1002, Taming_BubbleMessage_2)
ActionChartEventBindFunction(1003, Taming_BubbleMessage_3)
ActionChartEventBindFunction(1004, Taming_BubbleMessage_4)
ActionChartEventBindFunction(1005, Taming_BubbleMessage_5)
ActionChartEventBindFunction(1006, Taming_BubbleMessage_6)
ActionChartEventBindFunction(1007, Taming_BubbleMessage_7)
ActionChartEventBindFunction(1008, Taming_BubbleMessage_8)
ActionChartEventBindFunction(1009, Taming_BubbleMessage_9)
ActionChartEventBindFunction(1010, Taming_BubbleMessage_10)
