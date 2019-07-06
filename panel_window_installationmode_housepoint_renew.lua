local Panel_Window_InstallationMode_HousePoint_info = {
  _ui = {
    staticText_Host_Title = nil,
    staticText_HousingPoints = nil,
    staticText_BasePoints = nil,
    staticText_SetPoints = nil,
    staticText_AddPoints = nil,
    static_BackFloorBG = nil,
    radioButton_FirstFloor = nil,
    radioButton_SecondFloor = nil,
    radioButton_ThirdFloor = nil,
    radioButton_FourFloor = nil
  },
  _value = {},
  _config = {floorMaxCount = 4},
  _enum = {},
  _pos = {floorSizeY = 32, floorSpaceY = 3},
  _enumFloor = {
    First = 0,
    Second = 1,
    Third = 2,
    Four = 3,
    Count = 4
  },
  _flootButton = {}
}
function Panel_Window_InstallationMode_HousePoint_info:registEventHandler()
  for index = 0, self._enumFloor.Count - 1 do
    self._flootButton[index]:addInputEvent("Mouse_LUp", "PaGlobalFunc_InstallationMode_HousePoint_ClickFloor(" .. index .. ")")
  end
end
function Panel_Window_InstallationMode_HousePoint_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_InstallationMode_HousePoint_Resize")
end
function Panel_Window_InstallationMode_HousePoint_info:initialize()
  self:childControl()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_InstallationMode_HousePoint_info:resize()
  local tempSizeX = self._ui.staticText_HousingPointsTitle:GetPosX() + self._ui.staticText_HousingPointsTitle:GetTextSizeX() + 50
  self._ui.staticText_HousingPoints:SetPosX(tempSizeX)
  self._ui.staticText_BasePoints:SetPosX(tempSizeX)
  self._ui.staticText_SetPoints:SetPosX(tempSizeX)
  self._ui.staticText_AddPoints:SetPosX(tempSizeX)
end
function Panel_Window_InstallationMode_HousePoint_info:childControl()
  self._ui.staticText_Host_Title = UI.getChildControl(Panel_Window_InstallationMode_HousePoint, "StaticText_Host_Title")
  self._ui.staticText_HousingPointsTitle = UI.getChildControl(Panel_Window_InstallationMode_HousePoint, "StaticText_HousingPointTitle")
  self._ui.staticText_HousingPoints = UI.getChildControl(Panel_Window_InstallationMode_HousePoint, "StaticText_HousingPoints")
  self._ui.staticText_BasePoints = UI.getChildControl(Panel_Window_InstallationMode_HousePoint, "StaticText_BasePoints")
  self._ui.staticText_SetPoints = UI.getChildControl(Panel_Window_InstallationMode_HousePoint, "StaticText_SetPoints")
  self._ui.staticText_AddPoints = UI.getChildControl(Panel_Window_InstallationMode_HousePoint, "StaticText_AddPoints")
  self._ui.static_BackFloorBG = UI.getChildControl(Panel_Window_InstallationMode_HousePoint, "Static_BackFloorBG")
  self._ui.radioButton_FirstFloor = UI.getChildControl(self._ui.static_BackFloorBG, "RadioButton_FirstFloor")
  self._ui.radioButton_SecondFloor = UI.getChildControl(self._ui.static_BackFloorBG, "RadioButton_SecondFloor")
  self._ui.radioButton_ThirdFloor = UI.getChildControl(self._ui.static_BackFloorBG, "RadioButton_ThirdFloor")
  self._ui.radioButton_FourFloor = UI.getChildControl(self._ui.static_BackFloorBG, "RadioButton_FourFloor")
  self._flootButton[0] = self._ui.radioButton_FirstFloor
  self._flootButton[1] = self._ui.radioButton_SecondFloor
  self._flootButton[2] = self._ui.radioButton_ThirdFloor
  self._flootButton[3] = self._ui.radioButton_FourFloor
  self._pos.floorSizeY = self._ui.radioButton_FirstFloor:GetSizeY()
end
function Panel_Window_InstallationMode_HousePoint_info:setTitleText()
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper then
    return
  end
  local userNickname = ""
  if true == PaGlobalFunc_InstallationMode_Manager_GetMyHouse() then
    userNickname = houseWrapper:getOwnerUserName()
  else
    userNickname = ToClient_GetVisitHouseOwnerName()
  end
  self._ui.staticText_Host_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSING_HOUSENAME_LIVING", "user_nickname", userNickname))
end
function Panel_Window_InstallationMode_HousePoint_info:setPoints()
  self._ui.staticText_HousingPoints:SetText(toClient_GetVisitingBaseInteriorPoint())
  self._ui.staticText_BasePoints:SetText(toClient_GetVisitingSetOptionInteriorPoint())
  self._ui.staticText_SetPoints:SetText(toClient_GetVisitingBonusInteriorPoint())
  self._ui.staticText_AddPoints:SetText(toClient_GetVisitingTotalInteriorPoint())
end
function Panel_Window_InstallationMode_HousePoint_info:showFloor(isShow)
  local numFloor = housing_getHouseFloorCount()
  if false == isShow or numFloor <= 1 then
    self._ui.static_BackFloorBG:SetShow(false)
    return
  end
  self._ui.static_BackFloorBG:SetShow(true)
  for index = 0, self._enumFloor.Count - 1 do
    if index < numFloor then
      self._flootButton[index]:SetShow(true)
    else
      self._flootButton[index]:SetShow(false)
    end
  end
  self._ui.static_BackFloorBG:SetSize(self._ui.static_BackFloorBG:GetSizeX(), numFloor * (self._pos.floorSizeY + self._pos.floorSpaceY) + 60)
  for _, _value in pairs(self._flootButton) do
    _value:ComputePos()
  end
  self:setFloor()
end
function Panel_Window_InstallationMode_HousePoint_info:setFloor(floor)
  if nil == floor then
    floor = housing_getHouseFloorSelfPlayerBeing()
  end
  for index = 0, self._enumFloor.Count - 1 do
    if floor == index then
      self._flootButton[index]:SetCheck(true)
    else
      self._flootButton[index]:SetCheck(false)
    end
  end
end
function Panel_Window_InstallationMode_HousePoint_info:updateContent()
  self:setPoints()
  self:setFloor()
end
function Panel_Window_InstallationMode_HousePoint_info:open()
  Panel_Window_InstallationMode_HousePoint:SetShow(true)
end
function Panel_Window_InstallationMode_HousePoint_info:close()
  Panel_Window_InstallationMode_HousePoint:SetShow(false)
end
function PaGlobalFunc_InstallationMode_HousePoint_GetShow()
end
function PaGlobalFunc_InstallationMode_HousePoint_Open()
  local self = Panel_Window_InstallationMode_HousePoint_info
  self:open()
end
function PaGlobalFunc_InstallationMode_HousePoint_Close()
  local self = Panel_Window_InstallationMode_HousePoint_info
  self:close()
end
function PaGlobalFunc_InstallationMode_HousePoint_Show()
  local self = Panel_Window_InstallationMode_HousePoint_info
  self:setPoints()
  self:showFloor()
  self:setTitleText()
  self:open()
end
function PaGlobalFunc_InstallationMode_HousePoint_Exit()
  local self = Panel_Window_InstallationMode_HousePoint_info
  self:close()
end
function PaGlobalFunc_InstallationMode_HousePoint_ShowFloor(isShow)
  local self = Panel_Window_InstallationMode_HousePoint_info
  self:showFloor(isShow)
end
function PaGlobalFunc_InstallationMode_HousePoint_UpdatePoint()
  local self = Panel_Window_InstallationMode_HousePoint_info
  self:setPoints()
end
function PaGlobalFunc_InstallationMode_HousePoint_ClickFloor(floor)
  local self = Panel_Window_InstallationMode_HousePoint_info
  housing_selectHouseFloor(floor)
  self:setFloor(floor)
end
function FromClient_InstallationMode_HousePoint_Init()
  local self = Panel_Window_InstallationMode_HousePoint_info
  self:initialize()
end
function FromClient_InstallationMode_HousePoint_Resize()
  local self = Panel_Window_InstallationMode_HousePoint_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_InstallationMode_HousePoint_Init")
