PaGlobal_CarriageInformation = {
  _ui = {
    panelBackground = nil,
    buttonClose = nil,
    buttonQuestion = nil,
    emptyList = nil,
    scroll = nil,
    stc_Slot = nil,
    stc_Arrow = nil,
    txt_Departure = nil,
    txt_Destination = nil
  },
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  },
  config = {
    slotCount = 4,
    slotStartX = 15,
    slotStartY = 60,
    slotGapY = 65,
    slotIconStartX = 5,
    slotIconStartY = 8,
    slotCarriageTypeStartX = 88,
    slotCarriageTypeStartY = 8,
    slotDepartureStartX = 65,
    slotDepartureStartY = 21,
    slotDestinationStartX = 215,
    slotDestinationStartY = 21,
    slotArrowStartX = 180,
    slotArrowStartY = 23,
    slotButtonStartX = 330,
    slotButtonStartY = 5
  },
  const = {
    deliveryProgressTypeRequest = 0,
    deliveryProgressTypeIng = 1,
    deliveryProgressTypeComplete = 2
  },
  slots = Array.new(),
  startSlotNo = 0,
  _objectID = nil,
  _initialize = false
}
runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_CarriageInformation_1.lua")
runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_CarriageInformation_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_CarriageInformationInit")
function FromClient_CarriageInformationInit()
  PaGlobal_CarriageInformation:initialize()
end
