local JoyPadInputType = {
  LStick_UP = 0,
  LStick_DOWN = 1,
  LStick_LEFT = 2,
  LStick_RIGHT = 3,
  UP = 4,
  DOWN = 5,
  LEFT = 6,
  RIGHT = 7
}
local UI_IT = CppEnums.UiInputType
PaGlobal_RingMenu = {
  _ui = {
    _menuName = UI.getChildControl(Panel_RingMenu, "StaticText_SelectedButtonTitle"),
    _menuDesc = UI.getChildControl(Panel_RingMenu, "StaticText_SelectedButtonDesc"),
    _buttonTemplate = {},
    _center = UI.getChildControl(Panel_RingMenu, "Static_CenterPoint")
  },
  _radius = 231,
  _center = {_x = 0, _y = 0},
  _slot = {
    [0] = {
      input = {
        JoyPadInputType.RIGHT
      },
      _func = InventoryWindow_Show
    },
    [1] = {
      input = {
        JoyPadInputType.RIGHT,
        JoyPadInputType.UP
      }
    },
    [2] = {
      input = {
        JoyPadInputType.UP
      }
    },
    [3] = {
      input = {
        JoyPadInputType.UP,
        JoyPadInputType.LEFT
      }
    },
    [4] = {
      input = {
        JoyPadInputType.LEFT
      }
    },
    [5] = {
      input = {
        JoyPadInputType.LEFT,
        JoyPadInputType.DOWN
      }
    },
    [6] = {
      input = {
        JoyPadInputType.DOWN
      }
    },
    [7] = {
      input = {
        JoyPadInputType.DOWN,
        JoyPadInputType.RIGHT
      }
    }
  },
  _currentIndex = 0
}
function PaGlobal_RingMenu:initialize()
  self._center.x = self._ui._center:GetPosX()
  self._center.y = self._ui._center:GetPosY()
  local angle = 0
  local angleOffset = 2 * math.pi / 8
  for index = 0, 7 do
    self._ui._buttonTemplate[index] = UI.getChildControl(Panel_RingMenu, "Button_Templete" .. index)
    self._slot[index]._icon = self._ui._buttonTemplate[index]
    angle = angle + angleOffset
    local x = self._radius * math.cos(angle)
    local y = self._radius * math.sin(angle)
    self._ui._buttonTemplate[index]:SetPosX(self._center.x + x - 50)
    self._ui._buttonTemplate[index]:SetPosY(self._center.y + y - 50)
  end
end
function PaGlobal_RingMenu:SetTarget()
  QuickSlot_Click(self._currentIndex % 10)
  keyCustom_KeyProcessed_Ui(CppEnums.UiInputType.UiInputType_CursorOnOff)
end
function FGlobal_RingMenu_Update()
  if true == isPadPressed(JoyPadInputType.RIGHT) and true == isPadPressed(JoyPadInputType.UP) then
    PaGlobal_RingMenu._currentIndex = 1
  elseif true == isPadPressed(JoyPadInputType.UP) and true == isPadPressed(JoyPadInputType.LEFT) then
    PaGlobal_RingMenu._currentIndex = 3
  elseif true == isPadPressed(JoyPadInputType.LEFT) and true == isPadPressed(JoyPadInputType.DOWN) then
    PaGlobal_RingMenu._currentIndex = 5
  elseif true == isPadPressed(JoyPadInputType.DOWN) and true == isPadPressed(JoyPadInputType.RIGHT) then
    PaGlobal_RingMenu._currentIndex = 7
  elseif true == isPadPressed(JoyPadInputType.UP) then
    PaGlobal_RingMenu._currentIndex = 2
  elseif true == isPadPressed(JoyPadInputType.DOWN) then
    PaGlobal_RingMenu._currentIndex = 6
  elseif true == isPadPressed(JoyPadInputType.LEFT) then
    PaGlobal_RingMenu._currentIndex = 4
  else
    if true == isPadPressed(JoyPadInputType.RIGHT) then
      PaGlobal_RingMenu._currentIndex = 0
    else
    end
  end
  if true == isPadPressed(JoyPadInputType.LStick_RIGHT) and true == isPadPressed(JoyPadInputType.LStick_UP) then
    PaGlobal_RingMenu._currentIndex = 1
  elseif true == isPadPressed(JoyPadInputType.LStick_UP) and true == isPadPressed(JoyPadInputType.LStick_LEFT) then
    PaGlobal_RingMenu._currentIndex = 3
  elseif true == isPadPressed(JoyPadInputType.LStick_LEFT) and true == isPadPressed(JoyPadInputType.LStick_DOWN) then
    PaGlobal_RingMenu._currentIndex = 5
  elseif true == isPadPressed(JoyPadInputType.LStick_DOWN) and true == isPadPressed(JoyPadInputType.LStick_RIGHT) then
    PaGlobal_RingMenu._currentIndex = 7
  elseif true == isPadPressed(JoyPadInputType.LStick_UP) then
    PaGlobal_RingMenu._currentIndex = 2
  elseif true == isPadPressed(JoyPadInputType.LStick_DOWN) then
    PaGlobal_RingMenu._currentIndex = 6
  elseif true == isPadPressed(JoyPadInputType.LStick_LEFT) then
    PaGlobal_RingMenu._currentIndex = 4
  else
    if true == isPadPressed(JoyPadInputType.LStick_RIGHT) then
      PaGlobal_RingMenu._currentIndex = 0
    else
    end
  end
end
PaGlobal_RingMenu:initialize()
Panel_RingMenu:RegisterUpdateFunc("FGlobal_RingMenu_Update")
