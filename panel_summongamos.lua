local UI_TM = CppEnums.TextMode
local VCK = CppEnums.VirtualKeyCode
local UI_color = Defines.Color
local UI_classType = CppEnums.ClassType
local IM = CppEnums.EProcessorInputMode
local maxCount = 11
local _updateTime = 0
local _stepNo = 0
local ui = {
  _gamos = UI.getChildControl(Panel_SummonGamos, "Static_Gamos"),
  _facePicture_L = UI.getChildControl(Panel_SummonGamos, "Static_FacePicture_Left"),
  _facePicture_R = UI.getChildControl(Panel_SummonGamos, "Static_FacePicture_Right"),
  _textBg = UI.getChildControl(Panel_SummonGamos, "Static_TextBg")
}
ui._characterName = UI.getChildControl(ui._textBg, "StaticText_CharacterName")
ui._script = UI.getChildControl(ui._textBg, "StaticText_Script")
local iconPath = "New_UI_Common_forLua/Default/Default_Etc_06.dds"
local data = {
  [600] = {
    [0] = {
      _path = {
        _x1 = 237,
        _y1 = 237,
        _x2 = 472,
        _y2 = 472
      },
      _isGamos = false,
      _isLeft = true,
      _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONGAMOS_NPCNAME_1"),
      _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_GAMOTH_01")
    },
    [1] = {
      _path = {
        _x1 = 709,
        _y1 = 237,
        _x2 = 963,
        _y2 = 472
      },
      _isGamos = true,
      _isLeft = false,
      _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONGAMOS_NPCNAME_2"),
      _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_GAMOTH_02")
    }
  },
  [601] = {
    [0] = {
      _path = {
        _x1 = 237,
        _y1 = 1,
        _x2 = 472,
        _y2 = 236
      },
      _isGamos = false,
      _isLeft = true,
      _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONGAMOS_NPCNAME_3"),
      _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_GAMOTH_03")
    },
    [1] = {
      _path = {
        _x1 = 1,
        _y1 = 1,
        _x2 = 236,
        _y2 = 236
      },
      _isGamos = false,
      _isLeft = false,
      _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONGAMOS_NPCNAME_4"),
      _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_GAMOTH_04")
    },
    [2] = {
      _path = {
        _x1 = 709,
        _y1 = 1,
        _x2 = 944,
        _y2 = 236
      },
      _isGamos = false,
      _isLeft = true,
      _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONGAMOS_NPCNAME_5"),
      _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_GAMOTH_05")
    },
    [3] = {
      _path = {
        _x1 = 1,
        _y1 = 237,
        _x2 = 236,
        _y2 = 472
      },
      _isGamos = false,
      _isLeft = false,
      _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONGAMOS_NPCNAME_6"),
      _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_GAMOTH_06")
    },
    [4] = {
      _path = {
        _x1 = 473,
        _y1 = 1,
        _x2 = 708,
        _y2 = 236
      },
      _isGamos = false,
      _isLeft = true,
      _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONGAMOS_NPCNAME_7"),
      _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_GAMOTH_07")
    }
  },
  [602] = {
    [0] = {
      _path = {
        _x1 = 473,
        _y1 = 237,
        _x2 = 708,
        _y2 = 472
      },
      _isGamos = false,
      _isLeft = true,
      _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONGAMOS_NPCNAME_8"),
      _desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NPC_GAMOTH_08", "playerName", getSelfPlayer():getOriginalName())
    },
    [1] = {
      _path = {
        _x1 = 237,
        _y1 = 237,
        _x2 = 472,
        _y2 = 472
      },
      _isGamos = false,
      _isLeft = false,
      _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONGAMOS_NPCNAME_1"),
      _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_GAMOTH_09")
    }
  },
  [603] = {
    [0] = {
      _path = {
        _x1 = 709,
        _y1 = 237,
        _x2 = 963,
        _y2 = 472
      },
      _isGamos = true,
      _isLeft = false,
      _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONGAMOS_NPCNAME_2"),
      _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_GAMOTH_10")
    },
    [1] = {
      _path = {
        _x1 = 237,
        _y1 = 237,
        _x2 = 472,
        _y2 = 472
      },
      _isGamos = false,
      _isLeft = true,
      _name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONGAMOS_NPCNAME_1"),
      _desc = PAGetString(Defines.StringSheet_GAME, "LUA_NPC_GAMOTH_11")
    }
  }
}
local function ui_Show(isShow)
  for v, control in pairs(ui) do
    control:SetShow(isShow)
    control:ComputePos()
  end
end
ui_Show(false)
local function tutorial_UISet(tIndex, index)
  ui_Show(true)
  local tutorialData = data[tIndex][index]
  if tutorialData._isGamos then
    ui._gamos:SetShow(true)
    ui._facePicture_L:SetShow(false)
    ui._facePicture_R:SetShow(false)
  else
    ui._gamos:SetShow(false)
    ui._facePicture_L:SetShow(tutorialData._isLeft)
    ui._facePicture_R:SetShow(not tutorialData._isLeft)
    if tutorialData._isLeft then
      ui._facePicture_L:ChangeTextureInfoName(iconPath)
      local x1, y1, x2, y2 = setTextureUV_Func(ui._facePicture_L, tutorialData._path._x1, tutorialData._path._y1, tutorialData._path._x2, tutorialData._path._y2)
      ui._facePicture_L:getBaseTexture():setUV(x1, y1, x2, y2)
      ui._facePicture_L:setRenderTexture(ui._facePicture_L:getBaseTexture())
    else
      ui._facePicture_R:ChangeTextureInfoName(iconPath)
      local x1, y1, x2, y2 = setTextureUV_Func(ui._facePicture_R, tutorialData._path._x1, tutorialData._path._y1, tutorialData._path._x2, tutorialData._path._y2)
      ui._facePicture_R:getBaseTexture():setUV(x1, y1, x2, y2)
      ui._facePicture_R:setRenderTexture(ui._facePicture_R:getBaseTexture())
    end
  end
  ui._characterName:SetText(tutorialData._name)
  ui._script:SetText(tutorialData._desc)
end
local function updateDeltaTime_SummonGamos(deltaTime)
  _updateTime = _updateTime + deltaTime
  if 600 == _stepNo then
    if _updateTime < 10 then
      if ui._textBg:GetShow() then
        ui_Show(false)
      end
    elseif _updateTime >= 10 and _updateTime < 15 then
      if not ui._textBg:GetShow() then
        ui_Show(true)
        tutorial_UISet(600, 0)
      end
    elseif _updateTime > 16 and _updateTime < 20 then
      if not ui._textBg:GetShow() then
        ui_Show(true)
        tutorial_UISet(600, 1)
      end
    elseif _updateTime > 40 and _updateTime < 43 then
      if not ui._textBg:GetShow() then
        ui_Show(true)
        tutorial_UISet(601, 0)
      end
    elseif _updateTime > 44 and _updateTime < 47 then
      if not ui._textBg:GetShow() then
        ui_Show(true)
        tutorial_UISet(601, 1)
      end
    elseif _updateTime > 48 and _updateTime < 51 then
      if not ui._textBg:GetShow() then
        ui_Show(true)
        tutorial_UISet(601, 2)
      end
    elseif _updateTime > 52 and _updateTime < 55 then
      if not ui._textBg:GetShow() then
        ui_Show(true)
        tutorial_UISet(601, 3)
      end
    elseif _updateTime > 56 and _updateTime < 59 then
      if not ui._textBg:GetShow() then
        ui_Show(true)
        tutorial_UISet(601, 4)
      end
    elseif _updateTime > 79 and _updateTime < 84 then
      if not ui._textBg:GetShow() then
        ui_Show(true)
        tutorial_UISet(602, 0)
      end
    elseif _updateTime > 85 and _updateTime < 88 then
      if not ui._textBg:GetShow() then
        ui_Show(true)
        tutorial_UISet(602, 1)
      end
    elseif _updateTime > 89 then
      Panel_SummonGamos_Close()
      _updateTime = 0
    else
      ui_Show(false)
    end
  elseif 601 == _stepNo then
  elseif 602 == _stepNo then
  elseif 603 == _stepNo then
  else
    Panel_SummonGamos_Close()
  end
end
function SummonGamos_BubbleMessage_1()
  _updateTime = 0
  _stepNo = 600
  Panel_SummonGamos:SetShow(true)
end
function SummonGamos_BubbleMessage_2()
  _updateTime = 0
  _stepNo = 601
  Panel_SummonGamos:SetShow(true)
end
function SummonGamos_BubbleMessage_3()
  _updateTime = 0
  _stepNo = 602
  Panel_SummonGamos:SetShow(true)
end
function SummonGamos_BubbleMessage_4()
  _updateTime = 0
  _stepNo = 603
  Panel_SummonGamos:SetShow(true)
end
function Panel_SummonGamos_Close()
  Panel_SummonGamos:SetShow(false)
end
function Panel_SummonGamos_doStep(deltaTime)
  updateDeltaTime_SummonGamos(deltaTime, _stepNo)
end
function SummonGamos_ScreenRePosition()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_SummonGamos:SetSize(scrX, scrY)
  Panel_SummonGamos:SetPosX(0)
  Panel_SummonGamos:SetPosY(0)
  for key, value in pairs(ui) do
    value:ComputePos()
  end
end
registerEvent("onScreenResize", "SummonGamos_ScreenRePosition")
Panel_SummonGamos:RegisterUpdateFunc("Panel_SummonGamos_doStep")
ActionChartEventBindFunction(600, SummonGamos_BubbleMessage_1)
ActionChartEventBindFunction(601, SummonGamos_BubbleMessage_2)
ActionChartEventBindFunction(602, SummonGamos_BubbleMessage_3)
ActionChartEventBindFunction(603, SummonGamos_BubbleMessage_4)
