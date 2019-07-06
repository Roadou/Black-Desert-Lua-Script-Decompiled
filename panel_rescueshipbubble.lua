local UI_TM = CppEnums.TextMode
local VCK = CppEnums.VirtualKeyCode
local UI_color = Defines.Color
local UI_classType = CppEnums.ClassType
local IM = CppEnums.EProcessorInputMode
local _updateTime = 0
local _stepNo = 0
local _randomIndex = -1
local rescueShip_Texture = "UI_Artwork/gumumdal_rescueman.dds"
local ui = {
  _obsidian = UI.getChildControl(Panel_RescueShip, "Static_Obsidian"),
  _obsidian_B = UI.getChildControl(Panel_RescueShip, "Static_Obsidian_B"),
  _obsidian_B_Left = UI.getChildControl(Panel_RescueShip, "Static_Obsidian_B_Left"),
  _obsidian_Text = UI.getChildControl(Panel_RescueShip, "StaticText_Obsidian_B"),
  _obsidian_Text_2 = UI.getChildControl(Panel_RescueShip, "StaticText_Obsidian_B_2")
}
ui._obsidian:ChangeTextureInfoName(rescueShip_Texture)
local function ui_Show(isShow)
  for v, control in pairs(ui) do
    control:SetShow(isShow)
  end
end
ui_Show(false)
local rescueShip_Desc = {
  [401] = {
    [0] = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUE_1"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUE_2")
    }
  },
  [402] = {
    [0] = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_01"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_02"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_03"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_04"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_END")
    },
    [1] = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_05"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_06"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_07"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_08"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_END")
    },
    [2] = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_09"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_10"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_11"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_12"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_END")
    },
    [3] = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_13"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_14"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_15"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_16"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_END")
    },
    [4] = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_17"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_18"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_19"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_20"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUESONG_END")
    }
  },
  [403] = {
    [0] = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUE_3"),
      PAGetString(Defines.StringSheet_GAME, "LUA_NPC_RESCUE_4")
    }
  }
}
local isOpen = false
local descCount = 0
local basePosX = Panel_SelfPlayerExpGage:GetPosX() + Panel_SelfPlayerExpGage:GetSizeX() + 150
local basePosY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 50
local function updateDeltaTime_RescueShip(deltaTime, index)
  _updateTime = _updateTime + deltaTime
  if 1 == index then
    if _updateTime < 4 then
      ui._obsidian_Text:SetText(rescueShip_Desc[401][0][0])
    elseif _updateTime < 8 then
      ui._obsidian_Text:SetText(rescueShip_Desc[401][0][1])
    else
      Panel_RescueShip_Close()
      _updateTime = 0
    end
  elseif 2 == index then
    if _updateTime < 3 then
      ui._obsidian_Text:SetText(rescueShip_Desc[402][_randomIndex][0])
    elseif _updateTime < 6 then
      ui._obsidian_Text:SetText(rescueShip_Desc[402][_randomIndex][1])
    elseif _updateTime < 9 then
      ui._obsidian_Text:SetText(rescueShip_Desc[402][_randomIndex][2])
    elseif _updateTime < 12 then
      ui._obsidian_Text:SetText(rescueShip_Desc[402][_randomIndex][3])
    elseif _updateTime < 15 then
      ui._obsidian_Text:SetText(rescueShip_Desc[402][_randomIndex][4])
    else
      Panel_RescueShip_Close()
      _updateTime = 0
    end
  elseif 3 == index then
    if _updateTime < 4 then
      ui._obsidian_Text:SetText(rescueShip_Desc[403][0][0])
    elseif _updateTime < 8 then
      ui._obsidian_Text:SetText(rescueShip_Desc[403][0][1])
    else
      Panel_RescueShip_Close()
      _updateTime = 0
    end
  else
    Panel_RescueShip_Close()
  end
  ui._obsidian:SetPosX(basePosX - ui._obsidian:GetSizeX())
  ui._obsidian:SetPosY(basePosY - ui._obsidian:GetSizeY() + 60)
  ui._obsidian_B:SetPosX(basePosX)
  ui._obsidian_B:SetPosY(basePosY)
  ui._obsidian_Text:SetPosX(basePosX + 3)
  ui._obsidian_Text:SetPosY(basePosY + 35)
  ui._obsidian_B:SetSize(ui._obsidian_Text:GetTextSizeX() + 20, ui._obsidian_Text:GetTextSizeY() + 55)
end
function RescueShip_BubbleMessage_1()
  _updateTime = 0
  _stepNo = 1
  ui_Show(true)
  ui._obsidian_B_Left:SetShow(false)
  ui._obsidian_Text_2:SetShow(false)
  Panel_RescueShip:SetShow(true)
end
function RescueShip_BubbleMessage_2()
  _randomIndex = math.floor(math.random(0, 4))
  _updateTime = 0
  _stepNo = 2
  ui_Show(true)
  ui._obsidian_B_Left:SetShow(false)
  ui._obsidian_Text_2:SetShow(false)
  Panel_RescueShip:SetShow(true)
end
function RescueShip_BubbleMessage_3()
  _updateTime = 0
  _stepNo = 3
  ui_Show(true)
  ui._obsidian_B_Left:SetShow(false)
  ui._obsidian_Text_2:SetShow(false)
  Panel_RescueShip:SetShow(true)
end
function Panel_RescueShip_Close()
  Panel_RescueShip:SetShow(false)
end
function Panel_RescueShip_doStep(deltaTime)
  if 1 == _stepNo then
    updateDeltaTime_RescueShip(deltaTime, 1)
  elseif 2 == _stepNo then
    updateDeltaTime_RescueShip(deltaTime, 2)
  elseif 3 == _stepNo then
    updateDeltaTime_RescueShip(deltaTime, 3)
  end
end
function RescueShip_ScreenRePosition()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_RescueShip:SetSize(scrX, scrY)
  Panel_RescueShip:SetPosX(0)
  Panel_RescueShip:SetPosY(0)
  for key, value in pairs(ui) do
    value:ComputePos()
  end
end
registerEvent("onScreenResize", "RescueShip_ScreenRePosition")
Panel_RescueShip:RegisterUpdateFunc("Panel_RescueShip_doStep")
ActionChartEventBindFunction(401, RescueShip_BubbleMessage_1)
ActionChartEventBindFunction(402, RescueShip_BubbleMessage_2)
ActionChartEventBindFunction(403, RescueShip_BubbleMessage_3)
