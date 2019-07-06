PaGlobal_InformationView = {
  _ui = {
    _staticBackground = nil,
    _buttonClose = nil,
    _buttonQuestion = nil,
    _buttonRefresh = nil,
    _textCount = nil,
    _defaultNotify = nil,
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
  config = {
    slotCount = 7,
    slotStartX = 10,
    slotStartY = 70,
    slotGapY = 70,
    slotIconStartX = 5,
    slotIconStartY = 8,
    slotCarriageTypeStartX = 88,
    slotCarriageTypeStartY = 8,
    slotDepartureStartX = 65,
    slotDepartureStartY = 31,
    slotDestinationStartX = 215,
    slotDestinationStartY = 31,
    slotArrowStartX = 180,
    slotArrowStartY = 34,
    slotButtonStartX = 320,
    slotButtonStartY = 5
  },
  const = {
    deliveryProgressTypeRequest = 0,
    deliveryProgressTypeIng = 1,
    deliveryProgressTypeComplete = 2
  },
  _slots = Array.new(),
  _deliveryCountCache = 0,
  _startSlotNo = 0,
  _slotMaxSize = 100,
  _initialize = false
}
runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_InformationView_1.lua")
runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_InformationView_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_DeliveryInformationViewInit")
function FromClient_DeliveryInformationViewInit()
  PaGlobal_InformationView:initialize()
end
