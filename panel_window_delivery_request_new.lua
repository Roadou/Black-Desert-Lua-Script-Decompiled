local UI_color = Defines.Color
PaGlobal_Delivery_Request = {
  _ui = {
    slotBG = nil,
    button_Close = nil,
    _buttonQuestion = nil,
    rdo_send = nil,
    button_Information = nil,
    static_RequestBakcground = nil,
    staticGoldIcon = nil,
    staticText_WayPointPenalty = nil,
    staticText_Total_Title = nil,
    staticText_TotalCount = nil,
    staticText_TotalFee = nil,
    staticText_TotalDeliverer = nil,
    staticText_WeightCount = nil,
    button_Send = nil,
    comboBox_Destination = nil,
    deliveryHelpBG = nil,
    deliveryHelpDesc = nil
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
    slotCount = 20,
    slotCols = 8,
    slotRows = 0,
    slotStartX = 25,
    slotStartY = 330,
    slotGapX = 55,
    slotGapY = 55,
    fontColor = UI_color.C_FFFFFFFF
  },
  slots = Array.new(),
  slotbgs = Array.new(),
  selectWaypointKey = 0,
  selectDeliverer = -1,
  distance = 0,
  _initialize = false
}
runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_Request_New_1.lua")
runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_Request_New_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_Delivery_RequestInit")
function FromClient_Delivery_RequestInit()
  PaGlobal_Delivery_Request:initialize()
end
