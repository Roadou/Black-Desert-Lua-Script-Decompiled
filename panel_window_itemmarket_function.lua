Panel_Window_ItemMarket_Function:SetShow(false)
local ItemMarketFunction = {
  static_bg = UI.getChildControl(Panel_Window_ItemMarket_Function, "Static_Title"),
  btn_Market = UI.getChildControl(Panel_Window_ItemMarket_Function, "Button_Market"),
  btn_ItemSet = UI.getChildControl(Panel_Window_ItemMarket_Function, "Button_ItemSet"),
  btn_PreBidManager = UI.getChildControl(Panel_Window_ItemMarket_Function, "Button_PreBidManager"),
  btn_AlarmManager = UI.getChildControl(Panel_Window_ItemMarket_Function, "Button_AlarmManager"),
  btn_Exit = UI.getChildControl(Panel_Window_ItemMarket_Function, "Button_Exit")
}
local isPreBidOpen = ToClient_IsContentsGroupOpen("88")
function ItemMarketFunction:SetPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_Window_ItemMarket_Function:GetSizeX()
  local panelSizeY = Panel_Window_ItemMarket_Function:GetSizeY()
  Panel_Window_ItemMarket_Function:SetSize(scrSizeX, panelSizeY)
  self.static_bg:SetSize(scrSizeX, panelSizeY)
  Panel_Window_ItemMarket_Function:SetPosX(0)
  Panel_Window_ItemMarket_Function:SetPosY(scrSizeY - panelSizeY)
  self.btn_Market:SetShow(not _ContentsGroup_RenewUI_ItemMarketPlace_Only)
  self.btn_PreBidManager:SetShow(not _ContentsGroup_RenewUI_ItemMarketPlace_Only)
  self.btn_AlarmManager:SetShow(not _ContentsGroup_RenewUI_ItemMarketPlace_Only)
  self.btn_PreBidManager:SetShow(isPreBidOpen)
end
function ItemMarketFunction:BottomButtonPosition()
  local _btnTable = {}
  local _btnCount = 0
  _btnTable[0] = self.btn_Market
  _btnTable[1] = self.btn_ItemSet
  _btnTable[2] = self.btn_PreBidManager
  _btnTable[3] = self.btn_AlarmManager
  _btnTable[4] = self.btn_Exit
  if self.btn_Market:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self.btn_ItemSet:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self.btn_PreBidManager:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self.btn_AlarmManager:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self.btn_Exit:GetShow() then
    _btnCount = _btnCount + 1
  end
  local sizeX = getScreenSizeX()
  local funcButtonCount = _btnCount
  local buttonSize = _btnTable[0]:GetSizeX()
  local buttonGap = 10
  local startPosX = (sizeX - (buttonSize * funcButtonCount + buttonGap * (funcButtonCount - 1))) / 2
  local posX = 0
  local jindex = 0
  for index = 0, 4 do
    if _btnTable[index]:GetShow() then
      posX = startPosX + (buttonSize + buttonGap) * jindex
      jindex = jindex + 1
    end
    _btnTable[index]:SetPosX(posX)
  end
end
function FGolbal_ItemMarket_Function_Open()
  local self = ItemMarketFunction
  SetUIMode(Defines.UIMode.eUIMode_ItemMarket)
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_Close()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    Panel_Npc_Dialog:SetShow(false)
  else
    PaGlobalFunc_DialogMain_All_ShowToggle(false)
  end
  self:SetPosition()
  Panel_Window_ItemMarket_Function:SetShow(true)
  if _ContentsGroup_RenewUI_ItemMarketPlace_Only then
    FGlobal_ItemMarketItemSet_Open()
  else
    FGlobal_ItemMarketNew_Open()
  end
  ItemMarketFunction:BottomButtonPosition()
end
function FGolbal_ItemMarket_Function_Close()
  SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_ReOpen()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    Panel_Npc_Dialog:SetShow(false)
  else
    PaGlobalFunc_DialogMain_All_Open()
  end
  FGolbal_ItemMarketNew_Close()
  FGlobal_ItemMarketItemSet_Close()
  FGlobal_ItemMarket_BuyConfirm_Close()
  FGlobal_ItemMarketRegistItem_Close()
  FGlobal_ItemMarketAlarmList_Close()
  FGlobal_ItemMarketPreBid_Manager_Close()
  Panel_Window_ItemMarket_Function:SetShow(false)
end
function HandleClicked_ItemMarketFunction_PreBidManager()
  FGlobal_ItemMarketPreBid_Manager_Open()
end
function HandleClicked_ItemMarketFunction_AlarmManager()
  FGlobal_ItemMarketAlarmList_Open()
end
function FromClient_responseItemMarkgetInfo(infoType, param1, param2)
  if 0 == infoType then
    Update_ItemMarketMasterInfo()
  elseif 1 == infoType then
    Update_ItemMarketSummaryInfo()
  elseif 2 == infoType then
    Update_ItemMarketSellInfo()
  elseif 3 == infoType then
    FGlobal_ItemMarketMyItems_Update()
  elseif 4 == infoType then
    FGlobal_ItemMarketPreBid_Manager_Update()
  end
end
function ItemMarketFunction:registEventHandler()
  self.btn_Market:addInputEvent("Mouse_LUp", "FGlobal_ItemMarketNew_Open()")
  self.btn_ItemSet:addInputEvent("Mouse_LUp", "FGlobal_ItemMarketItemSet_Open()")
  self.btn_Exit:addInputEvent("Mouse_LUp", "FGolbal_ItemMarket_Function_Close()")
  self.btn_PreBidManager:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketFunction_PreBidManager()")
  self.btn_AlarmManager:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketFunction_AlarmManager()")
end
function ItemMarketFunction:registMessageHandler()
  registerEvent("FromClient_responseItemMarkgetInfo", "FromClient_responseItemMarkgetInfo")
end
ItemMarketFunction:registEventHandler()
ItemMarketFunction:registMessageHandler()
