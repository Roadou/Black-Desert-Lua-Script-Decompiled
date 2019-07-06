function PaGlobal_MarketPlaceTutorialSelect:initialize()
  local this = PaGlobal_MarketPlaceTutorialSelect
  if true == this._initialize then
    return
  end
  this._ui.btn_close = UI.getChildControl(Panel_Window_MarketPlace_TutorialSelect, "Button_Close")
  this._ui.btn_register = UI.getChildControl(Panel_Window_MarketPlace_TutorialSelect, "Button_Register")
  this._ui.btn_buy = UI.getChildControl(Panel_Window_MarketPlace_TutorialSelect, "Button_Buy")
  this._ui.btn_sell = UI.getChildControl(Panel_Window_MarketPlace_TutorialSelect, "Button_Sell")
  PaGlobal_MarketPlaceTutorialSelect:registEventHandler()
  this:validate()
  this._initialize = true
end
function PaGlobal_MarketPlaceTutorialSelect:registEventHandler()
  if nil == Panel_Window_MarketPlace_TutorialSelect then
    return
  end
  PaGlobal_MarketPlaceTutorialSelect._ui.btn_close:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceTutorialSelect:prepareClose()")
  PaGlobal_MarketPlaceTutorialSelect._ui.btn_register:addInputEvent("Mouse_LUp", "HandleEvnetLUp_MarketPlaceTutorialSelect_SelectTutorial(" .. PaGlobal_MarketPlaceTutorialSelect._TYPE.REGISTER .. ")")
  PaGlobal_MarketPlaceTutorialSelect._ui.btn_buy:addInputEvent("Mouse_LUp", "HandleEvnetLUp_MarketPlaceTutorialSelect_SelectTutorial(" .. PaGlobal_MarketPlaceTutorialSelect._TYPE.BUY .. ")")
  PaGlobal_MarketPlaceTutorialSelect._ui.btn_sell:addInputEvent("Mouse_LUp", "HandleEvnetLUp_MarketPlaceTutorialSelect_SelectTutorial(" .. PaGlobal_MarketPlaceTutorialSelect._TYPE.SELL .. ")")
end
function PaGlobal_MarketPlaceTutorialSelect:prepareOpen()
  if nil == Panel_Window_MarketPlace_TutorialSelect then
    return
  end
  PaGlobal_MarketPlaceTutorialSelect:open()
end
function PaGlobal_MarketPlaceTutorialSelect:open()
  if nil == Panel_Window_MarketPlace_TutorialSelect then
    return
  end
  Panel_Window_MarketPlace_TutorialSelect:SetShow(true)
end
function PaGlobal_MarketPlaceTutorialSelect:prepareClose()
  if nil == Panel_Window_MarketPlace_TutorialSelect then
    return
  end
  PaGlobal_MarketPlaceTutorialSelect:close()
end
function PaGlobal_MarketPlaceTutorialSelect:close()
  if nil == Panel_Window_MarketPlace_TutorialSelect then
    return
  end
  Panel_Window_MarketPlace_TutorialSelect:SetShow(false)
end
function PaGlobal_MarketPlaceTutorialSelect:update()
  if nil == Panel_Window_MarketPlace_TutorialSelect then
    return
  end
end
function PaGlobal_MarketPlaceTutorialSelect:validate()
  if nil == Panel_Window_MarketPlace_TutorialSelect then
    return
  end
end
