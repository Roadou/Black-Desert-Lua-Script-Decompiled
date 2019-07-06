local _panel = Panel_Window_DyeingMenu_Renew
local renderMode = RenderModeWrapper.new(100, {
  Defines.RenderMode.eRenderMode_Dye
}, false)
local UI_BUFFTYPE = CppEnums.UserChargeType
local ENUM_EQUIP = CppEnums.EquipSlotNoClient
local CT = CppEnums.ClassType
local ROOT_MENU = {PALETTE = 1, DYEING = 2}
local DYEING_SUBMENU = {
  CHARACTER = 1,
  HORSE = 2,
  CARRIAGE = 3,
  CAMEL = 4,
  TENT = 5
}
local _targetNumTable = {
  [DYEING_SUBMENU.CHARACTER] = 0,
  [DYEING_SUBMENU.HORSE] = 1,
  [DYEING_SUBMENU.CARRIAGE] = 2,
  [DYEING_SUBMENU.CAMEL] = 3,
  [DYEING_SUBMENU.TENT] = 6
}
local DyeingMenu = {
  _ui = {
    stc_rootGroup = UI.getChildControl(_panel, "Static_RootGroup"),
    rdo_rootMenu = {
      [ROOT_MENU.PALETTE] = nil,
      [ROOT_MENU.DYEING] = nil
    },
    stc_rootLine = nil,
    txt_keyGuideA = UI.getChildControl(_panel, "StaticText_A_ConsoleUI"),
    stc_subMenuGroup = {
      [ROOT_MENU.PALETTE] = UI.getChildControl(_panel, "Static_MainMenu2"),
      [ROOT_MENU.DYEING] = UI.getChildControl(_panel, "Static_MainMenu")
    },
    rdo_subMenu = {},
    stc_keyGuideBottom = UI.getChildControl(_panel, "Static_BottomBg")
  },
  _currentRootMenu = nil,
  _currentTree = {
    ROOT_MENU.PALETTE,
    DYEING_SUBMENU.CHARACTER
  },
  _movePosX = 0,
  _movePosY = 0,
  _gapX = 0,
  _gapY = 0
}
function FromClient_luaLoadComplete_DyeingMenu_Init()
  DyeingMenu:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_DyeingMenu_Init")
function DyeingMenu:initialize()
  self._ui.rdo_rootMenu = {
    [ROOT_MENU.PALETTE] = UI.getChildControl(self._ui.stc_rootGroup, "RadioButton_Pallete"),
    [ROOT_MENU.DYEING] = UI.getChildControl(self._ui.stc_rootGroup, "RadioButton_Dye")
  }
  self._ui.stc_rootLine = {}
  self._ui.stc_rootLine[ROOT_MENU.PALETTE] = UI.getChildControl(self._ui.rdo_rootMenu[ROOT_MENU.PALETTE], "Static_Line")
  self._ui.stc_rootLine[ROOT_MENU.DYEING] = UI.getChildControl(self._ui.rdo_rootMenu[ROOT_MENU.DYEING], "Static_Line")
  self._ui.rdo_rootMenu[ROOT_MENU.PALETTE]:addInputEvent("Mouse_LUp", "Input_DyeingMenu_RootMenu(" .. ROOT_MENU.PALETTE .. ")")
  self._ui.rdo_rootMenu[ROOT_MENU.PALETTE]:addInputEvent("Mouse_On", "InputMOn_DyeingMenu_RootMenu(" .. ROOT_MENU.PALETTE .. ")")
  self._ui.rdo_rootMenu[ROOT_MENU.PALETTE]:addInputEvent("Mouse_Out", "InputMOut_DyeingMenu_RootMenu(" .. ROOT_MENU.PALETTE .. ")")
  self._ui.rdo_rootMenu[ROOT_MENU.DYEING]:addInputEvent("Mouse_LUp", "Input_DyeingMenu_RootMenu(" .. ROOT_MENU.DYEING .. ")")
  self._ui.rdo_rootMenu[ROOT_MENU.DYEING]:addInputEvent("Mouse_On", "InputMOn_DyeingMenu_RootMenu(" .. ROOT_MENU.DYEING .. ")")
  self._ui.rdo_rootMenu[ROOT_MENU.DYEING]:addInputEvent("Mouse_Out", "InputMOut_DyeingMenu_RootMenu(" .. ROOT_MENU.DYEING .. ")")
  self._ui.rdo_subMenu = {}
  self._ui.rdo_subMenu[ROOT_MENU.PALETTE] = {}
  self._ui.rdo_subMenu[ROOT_MENU.DYEING] = {}
  self._ui.rdo_subMenu[ROOT_MENU.PALETTE] = {
    [1] = UI.getChildControl(self._ui.stc_subMenuGroup[ROOT_MENU.PALETTE], "RadioButton_Take"),
    [2] = UI.getChildControl(self._ui.stc_subMenuGroup[ROOT_MENU.PALETTE], "RadioButton_Eject")
  }
  self._ui.rdo_subMenu[ROOT_MENU.DYEING] = {
    [DYEING_SUBMENU.CHARACTER] = UI.getChildControl(self._ui.stc_subMenuGroup[ROOT_MENU.DYEING], "RadioButton_CharacterGear"),
    [DYEING_SUBMENU.HORSE] = UI.getChildControl(self._ui.stc_subMenuGroup[ROOT_MENU.DYEING], "RadioButton_Servant"),
    [DYEING_SUBMENU.CARRIAGE] = UI.getChildControl(self._ui.stc_subMenuGroup[ROOT_MENU.DYEING], "RadioButton_Carrige"),
    [DYEING_SUBMENU.CAMEL] = UI.getChildControl(self._ui.stc_subMenuGroup[ROOT_MENU.DYEING], "RadioButton_Camel"),
    [DYEING_SUBMENU.TENT] = UI.getChildControl(self._ui.stc_subMenuGroup[ROOT_MENU.DYEING], "RadioButton_Tent")
  }
  if not ToClient_IsContentsGroupOpen("4") then
    self._ui.rdo_subMenu[ROOT_MENU.DYEING][DYEING_SUBMENU.CAMEL]:SetShow(false)
  end
  if not _ContentsGroup_isCamp then
    self._ui.rdo_subMenu[ROOT_MENU.DYEING][DYEING_SUBMENU.TENT]:SetShow(false)
  end
  for ii = 1, #self._ui.rdo_subMenu do
    for jj = 1, #self._ui.rdo_subMenu[ii] do
      self._ui.rdo_subMenu[ii][jj]:addInputEvent("Mouse_LUp", "Input_DyeingMenu_SubMenu(" .. ii .. "," .. jj .. ")")
      self._ui.rdo_subMenu[ii][jj]:addInputEvent("Mouse_On", "InputMOn_DyeingMenu_SubMenu(" .. ii .. "," .. jj .. ")")
      self._ui.rdo_subMenu[ii][jj]:addInputEvent("Mouse_Out", "InputMOut_DyeingMenu_SubMenu(" .. ii .. "," .. jj .. ")")
    end
  end
  self._gapX = (getOriginScreenSizeX() - getScreenSizeX()) / 2
  self._gapY = (getOriginScreenSizeY() - getScreenSizeY()) / 2
  registerEvent("onScreenResize", "PaGlobalFunc_DyeingMenu_OnScreenResize")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LT, "Input_DyeingMain_PressedLT()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_LT, "Input_DyeingMain_ReleasedLT()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LTPress_Y, "PaGlobalFunc_Dyeing_ChangeWeather()")
end
function PaGlobalFunc_DyeingMenu_OnScreenResize()
  DyeingMenu:onScreenResize()
end
function DyeingMenu:onScreenResize()
  self._gapX = (getOriginScreenSizeX() - getScreenSizeX()) / 2
  self._gapY = (getOriginScreenSizeY() - getScreenSizeY()) / 2
end
function PaGlobalFunc_DyeingMenu_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_DyeingMenu_Open()
  DyeingMenu:open()
end
function DyeingMenu:open()
  _panel:SetShow(true)
  _AudioPostEvent_SystemUiForXBOX(1, 24)
  self:setVisibleMenu(true)
  self._ui.rdo_rootMenu[2]:SetColor(Defines.Color.C_FF525B6D)
  self._ui.rdo_rootMenu[2]:SetFontColor(Defines.Color.C_FF525B6D)
  self._ui.stc_rootLine[2]:SetShow(false)
  self._ui.stc_subMenuGroup[2]:SetShow(false)
end
function PaGlobalFunc_DyeingMenu_Close()
  DyeingMenu:close()
end
function DyeingMenu:close()
  _panel:SetShow(false)
end
function Input_DyeingMenu_RootMenu(rootIndex)
  local self = DyeingMenu
end
function InputMOn_DyeingMenu_RootMenu(rootIndex)
  local self = DyeingMenu
  self:browseMenu(rootIndex)
end
function InputMOut_DyeingMenu_RootMenu(rootIndex)
  local self = DyeingMenu
end
function InputMOn_DyeingMenu_SubMenu(rootIndex, subIndex)
  local self = DyeingMenu
  self:browseMenu(rootIndex, subIndex)
end
function InputMOut_DyeingMenu_SubMenu(rootIndex, subIndex)
  local self = DyeingMenu
end
function DyeingMenu:browseMenu(rootIndex, subIndex)
  if nil ~= self._currentTree[1] then
    self._ui.rdo_rootMenu[self._currentTree[1]]:SetColor(Defines.Color.C_FF525B6D)
    self._ui.rdo_rootMenu[self._currentTree[1]]:SetFontColor(Defines.Color.C_FF525B6D)
    self._ui.stc_rootLine[self._currentTree[1]]:SetShow(false)
    self._ui.stc_subMenuGroup[self._currentTree[1]]:SetShow(false)
  end
  self._currentTree[1] = rootIndex
  self._ui.rdo_rootMenu[self._currentTree[1]]:SetColor(Defines.Color.C_FFEEEEEE)
  self._ui.rdo_rootMenu[self._currentTree[1]]:SetFontColor(Defines.Color.C_FFEEEEEE)
  self._ui.stc_rootLine[self._currentTree[1]]:SetShow(true)
  self._ui.stc_subMenuGroup[self._currentTree[1]]:SetShow(true)
  if nil ~= self._currentTree[2] then
    for ii = 1, #self._ui.rdo_subMenu[rootIndex] do
      self._ui.rdo_subMenu[rootIndex][ii]:SetFontColor(Defines.Color.C_FF525B6D)
    end
  end
  if nil ~= subIndex then
    self._currentTree[2] = subIndex
    local rdo = self._ui.rdo_subMenu[rootIndex][self._currentTree[2]]
    rdo:SetFontColor(Defines.Color.C_FFEEEEEE)
    self._ui.txt_keyGuideA:SetShow(true)
    self._ui.txt_keyGuideA:SetPosX(rdo:GetParentPosX() + rdo:GetTextSizeX() + rdo:GetTextSpan().x + 10 - self._gapX)
    self._ui.txt_keyGuideA:SetPosY(rdo:GetParentPosY() + rdo:GetSizeY() / 2 - self._ui.txt_keyGuideA:GetSizeY() / 2 + 2 - self._gapY)
  else
    self._ui.txt_keyGuideA:SetShow(false)
  end
end
function Input_DyeingMenu_SubMenu(rootIndex, subIndex)
  local self = DyeingMenu
  if ROOT_MENU.PALETTE == rootIndex then
    PaGlobalFunc_DyeingTake_Open()
    if 1 == subIndex then
      PaGlobalFunc_DyeingRegister_Open()
    end
    self:setVisibleMenu(false)
  elseif ROOT_MENU.DYEING == rootIndex then
    local dyeAvailable = ToClient_RequestSetTargetType(_targetNumTable[subIndex])
    if dyeAvailable then
      DyeingMenu:close()
      PaGlobalFunc_DyeingPartList_Open(subIndex)
      self:setVisibleMenu(false)
    end
  end
end
function DyeingMenu:setVisibleMenu(isShow)
  self._ui.stc_rootGroup:SetShow(isShow)
  self._ui.stc_subMenuGroup[ROOT_MENU.PALETTE]:SetShow(isShow)
  self._ui.stc_subMenuGroup[ROOT_MENU.DYEING]:SetShow(isShow)
  self._ui.txt_keyGuideA:SetShow(isShow)
end
