local _panel = Panel_Window_PreOrder
local preOrder = {}
function PaGlobalFunc_PreOrder_Open(parentPanel)
  preOrder:open(parentPanel)
end
function preOrder:open(parentPanel)
  if nil ~= parentPanel then
    parentPanel:registerPadEvent(__eConsoleUIPadEvent_RTPress_X, "PaGlobalFunc_PreOrder_OpenPearlShop()")
    local posX = parentPanel:GetPosX() - _panel:GetSizeX() - 5
    local posY = parentPanel:GetPosY() + 5
    _panel:SetPosX(posX)
    _panel:SetPosY(posY)
  end
  _panel:SetShow(true)
end
function PaGlobalFunc_PreOrder_Close(parentPanel, isShow)
  preOrder:close(parentPanel, isShow)
end
function preOrder:close(parentPanel, isShow)
  if nil ~= parentPanel then
    parentPanel:registerPadEvent(__eConsoleUIPadEvent_RTPress_X, "")
  end
  if not isShow then
    _panel:SetShow(false)
  end
end
function PaGlobalFunc_PreOrder_OpenPearlShop()
  if false == Panel_Window_Inventory:GetShow() then
    return
  end
  PaGlobalFunc_InventoryInfo_Close()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_CashShop)
end
