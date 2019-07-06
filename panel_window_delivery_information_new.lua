PaGlobal_DeliveryInformation = {
  _ui = {
    panelBackground = nil,
    buttonClose = nil,
    buttonQuestion = nil,
    buttonRequest = nil,
    rdo_information = nil,
    buttonReceiveAll = nil,
    radiobutton_transferList = nil,
    radiobutton_allTransferList = nil,
    emptyList = nil,
    list2 = nil
  },
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  const = {
    deliveryProgressTypeRequest = 0,
    deliveryProgressTypeIng = 1,
    deliveryProgressTypeComplete = 2
  },
  currentWaypointKey = 0,
  scrollIndex = 0,
  deliveryList = nil,
  _updatePastTime = 0,
  _updateCurrentTime = 0,
  _initialize = false
}
runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_Information_New_1.lua")
runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_Information_New_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_DeliveryInformationInit")
function FromClient_DeliveryInformationInit()
  PaGlobal_DeliveryInformation:initialize()
end
