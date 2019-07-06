local UI_VT = CppEnums.VehicleType
local Panel_Widget_TopIcon_Pet_info = {
  _ui = {static_PetIcon_Template = nil},
  _value = {currentType = nil, hungerCheck = nil},
  _config = {},
  _enum = {},
  _hungerEffext = "fUI_Pet_01A"
}
function Panel_Widget_TopIcon_Pet_info:registEventHandler()
end
function Panel_Widget_TopIcon_Pet_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_TopIcon_Pet_Resize")
  registerEvent("FromClient_PetDelList", "PaGlobalFunc_TopIcon_Pet_Update")
  registerEvent("FromClient_PetAddList", "PaGlobalFunc_TopIcon_Pet_Update")
  registerEvent("FromClient_PetInfoChanged", "PaGlobalFunc_TopIcon_Pet_Update")
  registerEvent("FromClient_RenderModeChangeState", "FromClient_renderModeChange_TopIcon_Pet_Update")
end
function Panel_Widget_TopIcon_Pet_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Widget_TopIcon_Pet_info:initValue()
end
function Panel_Widget_TopIcon_Pet_info:resize()
  local posY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 4
  Panel_Widget_Pet_Renew:SetPosY(posY)
end
function Panel_Widget_TopIcon_Pet_info:childControl()
  self._ui.static_PetIcon_Template = UI.getChildControl(Panel_Widget_Pet_Renew, "Static_PetIcon_Template")
end
function Panel_Widget_TopIcon_Pet_info:updateContent()
  if isFlushedUI() then
    return
  end
  local petCount = ToClient_getPetUnsealedList()
  if petCount == 0 then
    PaGlobalFunc_TopIcon_Exit(TopWidgetIconType.Pet)
    return
  end
  PaGlobalFunc_TopIcon_Show(TopWidgetIconType.Pet)
  self:updateHunger(petCount)
end
function Panel_Widget_TopIcon_Pet_info:checkHunger(petHungryCheck)
  if isFlushedUI() then
    return
  end
  self._ui.static_PetIcon_Template:EraseAllEffect()
  if petHungryCheck and 0 < ToClient_getPetUnsealedList() then
    self._ui.static_PetIcon_Template:AddEffect(self._hungerEffext, true, -0.5, -1)
  end
  self._value.hungerCheck = petHungryCheck
end
function Panel_Widget_TopIcon_Pet_info:updateHunger(petCount)
  local isHungry = false
  for index = 0, petCount - 1 do
    local pcPetData = ToClient_getPetUnsealedDataByIndex(index)
    if nil ~= pcPetData then
      local petStaticStatus = pcPetData:getPetStaticStatus()
      local petHungry = pcPetData:getHungry()
      local petMaxHungry = petStaticStatus._maxHungry
      local petHungryPercent = petHungry / petMaxHungry * 100
      if petHungryPercent < 10 then
        isHungry = true
      end
    end
  end
  self:checkHunger(isHungry)
end
function Panel_Widget_TopIcon_Pet_info:open()
  Panel_Widget_Pet_Renew:SetShow(true)
end
function Panel_Widget_TopIcon_Pet_info:close()
  Panel_Widget_Pet_Renew:SetShow(false)
end
function PaGlobalFunc_TopIcon_Pet_GetShow()
  return Panel_Widget_Pet_Renew:GetShow()
end
function PaGlobalFunc_TopIcon_Pet_Open()
  local self = Panel_Widget_TopIcon_Pet_info
  self:open()
end
function PaGlobalFunc_TopIcon_Pet_Close()
  local self = Panel_Widget_TopIcon_Pet_info
  self:close()
end
function PaGlobalFunc_TopIcon_Pet_Update()
  local self = Panel_Widget_TopIcon_Pet_info
  self:updateContent()
end
function PaGlobalFunc_TopIcon_Pet_UpdateHunger()
  local self = Panel_Widget_TopIcon_Pet_info
  self:updateHunger()
end
function PaGlobalFunc_TopIcon_Pet_HungryAlert(petHungryCheck)
  local self = Panel_Widget_TopIcon_Pet_info
  self:checkHunger(petHungryCheck)
end
function FromClient_TopIcon_Pet_Init()
  local self = Panel_Widget_TopIcon_Pet_info
  self:initialize()
end
function FromClient_TopIcon_Pet_Resize()
  local self = Panel_Widget_TopIcon_Pet_info
  self:resize()
end
function FromClient_renderModeChange_TopIcon_Pet_Update(prevRenderModeList, nextRenderModeList)
  local self = Panel_Widget_TopIcon_Pet_info
  local unsealedCount = ToClient_getPetUnsealedList()
  if unsealedCount <= 0 then
    PaGlobalFunc_TopIcon_Exit(TopWidgetIconType.Pet)
    return
  end
  PaGlobalFunc_TopIcon_UpdatePos()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_TopIcon_Pet_Init")
