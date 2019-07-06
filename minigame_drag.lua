Panel_MiniGame_Drag:SetShow(false, false)
local _math_random = math.random
local _math_randomSeed = math.randomseed
local _math_lerp = Util.Math.Lerp
local ui = {
  _dragPattern = UI.getChildControl(Panel_MiniGame_Drag, "Static_BarPattern"),
  _arrowBG = UI.getChildControl(Panel_MiniGame_Drag, "Static_ArrowBG"),
  _arrow = UI.getChildControl(Panel_MiniGame_Drag, "Static_Arrow"),
  _arrowHelpText = UI.getChildControl(Panel_MiniGame_Drag, "StaticText_ArrowHelp"),
  _cursor = UI.getChildControl(Panel_MiniGame_Drag, "Static_DragCursor"),
  _nowResult = UI.getChildControl(Panel_MiniGame_Drag, "Static_NowResult"),
  _purposeText = UI.getChildControl(Panel_MiniGame_Drag, "StaticText_Purpose"),
  _resultText = UI.getChildControl(Panel_MiniGame_Drag, "StaticText_Result")
}
local arrowDirection = {
  [0] = nil,
  [1] = {
    texture = "New_UI_Common_forLua/Widget/Instance/MiniGame_Arrows.dds",
    x1 = 1,
    y1 = 1,
    x2 = 85,
    y2 = 85
  },
  [2] = {
    texture = "New_UI_Common_forLua/Widget/Instance/MiniGame_Arrows.dds",
    x1 = 86,
    y1 = 1,
    x2 = 170,
    y2 = 85
  },
  [3] = {
    texture = "New_UI_Common_forLua/Widget/Instance/MiniGame_Arrows.dds",
    x1 = 171,
    y1 = 1,
    x2 = 255,
    y2 = 85
  },
  [4] = {
    texture = "New_UI_Common_forLua/Widget/Instance/MiniGame_Arrows.dds",
    x1 = 171,
    y1 = 86,
    x2 = 255,
    y2 = 170
  },
  [5] = {
    texture = "New_UI_Common_forLua/Widget/Instance/MiniGame_Arrows.dds",
    x1 = 171,
    y1 = 171,
    x2 = 255,
    y2 = 255
  },
  [6] = {
    texture = "New_UI_Common_forLua/Widget/Instance/MiniGame_Arrows.dds",
    x1 = 86,
    y1 = 171,
    x2 = 170,
    y2 = 25
  },
  [7] = {
    texture = "New_UI_Common_forLua/Widget/Instance/MiniGame_Arrows.dds",
    x1 = 1,
    y1 = 171,
    x2 = 85,
    y2 = 255
  },
  [8] = {
    texture = "New_UI_Common_forLua/Widget/Instance/MiniGame_Arrows.dds",
    x1 = 1,
    y1 = 86,
    x2 = 85,
    y2 = 170
  }
}
local cursorAreaLength = 60
local cursorCheckSize = 30
local randomPattern = {
  [0] = nil,
  [1] = {
    texture = "New_UI_Common_forLua/Widget/Instance/DragGame_Bar/MiniGame_DragBar_00.dds",
    x = 512,
    y = 256,
    PathList = {
      float3(0, 0, 0),
      float3(100, 100, 0)
    },
    disList = {}
  },
  [2] = {
    texture = "New_UI_Common_forLua/Widget/Instance/DragGame_Bar/MiniGame_DragBar_01.dds",
    x = 512,
    y = 256,
    PathList = {
      float3(0, 0, 0),
      float3(100, 100, 0)
    },
    disList = {}
  },
  [3] = {
    texture = "New_UI_Common_forLua/Widget/Instance/DragGame_Bar/MiniGame_DragBar_02.dds",
    x = 512,
    y = 256,
    PathList = {
      float3(0, 0, 0),
      float3(100, 100, 0)
    },
    disList = {}
  },
  [4] = {
    texture = "New_UI_Common_forLua/Widget/Instance/DragGame_Bar/MiniGame_DragBar_03.dds",
    x = 512,
    y = 256,
    PathList = {
      float3(0, 0, 0),
      float3(100, 100, 0)
    },
    disList = {}
  },
  [5] = {
    texture = "New_UI_Common_forLua/Widget/Instance/DragGame_Bar/MiniGame_DragBar_04.dds",
    x = 512,
    y = 256,
    PathList = {
      float3(0, 0, 0),
      float3(100, 100, 0)
    },
    disList = {}
  },
  [6] = {
    texture = "New_UI_Common_forLua/Widget/Instance/DragGame_Bar/MiniGame_DragBar_05.dds",
    x = 512,
    y = 256,
    PathList = {
      float3(0, 0, 0),
      float3(100, 100, 0)
    },
    disList = {}
  },
  [7] = {
    texture = "New_UI_Common_forLua/Widget/Instance/DragGame_Bar/MiniGame_DragBar_06.dds",
    x = 128,
    y = 512,
    PathList = {
      float3(0, 0, 0),
      float3(100, 100, 0)
    },
    disList = {}
  }
}
local playMode = 0
local sumTime = 0
local isSuccess = true
local randValue = 1
local currentDistance = 0
local currentIndex = 1
local getSize = function(dataList)
  local aSize = 0
  for _, v in pairs(dataList) do
    aSize = aSize + 1
  end
  return aSize
end
local function calcAllDistance()
  for index = 1, 7 do
    local aPattern = randomPattern[index]
    local aSize = getSize(aPattern.PathList)
    for index = 1, aSize - 1 do
      aPattern.disList[index] = Util.Math.calculateDistance(aPattern.PathList[index], aPattern.PathList[index + 1])
    end
  end
end
local function init()
  Panel_MiniGame_Drag:SetShow(false, false)
  Panel_MiniGame_Drag:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
  calcAllDistance()
  Panel_Minigame_Drag_Start()
end
local function mouseAreaCheck()
  local currentdisX = getMousePosX() - (ui._cursor:GetParentPosX() + cursorAreaLength / 2)
  local currentdisY = getMousePosY() - (ui._cursor:GetParentPosY() + cursorAreaLength / 2)
  if currentdisX * currentdisX + currentdisY * currentdisY < cursorCheckSize * cursorCheckSize then
    return true
  end
  return false
end
function ScreenSize_RePosition_DragGame()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_MiniGame_Drag:SetPosX(scrX / 2 - 275)
  Panel_MiniGame_Drag:SetPosY(scrY / 2 - 175)
end
local function movePass(deltaTime)
  currentDistance = currentDistance + deltaTime
  if randomPattern[randValue].disList[currentIndex] < currentDistance then
    currentDistance = currentDistance - randomPattern[randValue].disList[currentIndex]
    currentIndex = currentIndex + 1
    if currentIndex >= 7 then
      currentDistance = 0
      return
    end
  end
  local pos = Util.Math.Lerp(randomPattern[randValue].PathList[currentIndex], randomPattern[randValue].PathList[currentIndex + 1], currentDistance / randomPattern[randValue].disList[currentIndex])
  ui._cursor:SetPosX(pos.x)
  ui._cursor:SetPosY(pos.y)
end
function Panel_Minigame_Drag_PerFrame(deltaTime)
  if 1 == playMode then
    movePass(deltaTime)
    isSuccess = mouseAreaCheck()
  elseif 2 == playMode then
    Panel_Minigame_Drag_End_UI(deltaTime)
  end
end
function Panel_Minigame_Drag_Start()
  Panel_MiniGame_Drag:SetShow(true, false)
  playMode = 1
  currentDistance = 0
  currentIndex = 1
  randValue = _math_random(1, 7)
  randValue = 2
  local selectedPattern = randomPattern[randValue]
  ui._dragPattern:ChangeTextureInfoName(selectedPattern.texture)
  ui._dragPattern:SetSize(selectedPattern.x, selectedPattern.y)
end
function Panel_Minigame_Drag_End_UI(deltaTime)
  sumTime = sumTime + deltaTime
  if sumTime >= 2 then
    Panel_MiniGame_Drag:SetShow(false, false)
  end
end
function Panel_Minigame_Drag_End()
  Panel_MiniGame_Drag:SetShow(false, false)
end
registerEvent("onScreenResize", "ScreenSize_RePosition_DragGame")
