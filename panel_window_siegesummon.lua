local siegeHandlerType = {
  Attack = 0,
  Skill = 1,
  ComeOn = 2
}
local siegeHandlerName = {
  [siegeHandlerType.Attack] = "HandlerSiegeOgreAttackTarget",
  [siegeHandlerType.Skill] = "HandlerSiegeOgreAttackSkillTarget",
  [siegeHandlerType.ComeOn] = "HandlerSiegeOgreComeOn"
}
local Panel_Window_SiegeSummonOrder_info = {
  _ui = {},
  _value = {},
  _config = {},
  _enum = {}
}
function Panel_Window_SiegeSummonOrder_info:registEventHandler()
end
function Panel_Window_SiegeSummonOrder_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_SiegeSummonOrder_Resize")
  registerEvent("FromClient_LinkSiegeSummonMonster", "FromClient_SiegeSummonOrder_LinkSiegeSummonMonster")
end
function Panel_Window_SiegeSummonOrder_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_SiegeSummonOrder_info:initValue()
end
function Panel_Window_SiegeSummonOrder_info:resize()
end
function Panel_Window_SiegeSummonOrder_info:childControl()
end
function Panel_Window_SiegeSummonOrder_info:setContent()
end
function Panel_Window_SiegeSummonOrder_info:open()
end
function Panel_Window_SiegeSummonOrder_info:close()
end
function PaGlobalFunc_SiegeSummonOrder_GetShow()
end
function PaGlobalFunc_SiegeSummonOrder_Open()
  local self = Panel_Window_SiegeSummonOrder_info
  self:open()
end
function PaGlobalFunc_SiegeSummonOrder_Close()
  local self = Panel_Window_SiegeSummonOrder_info
  self:close()
end
function PaGlobalFunc_SiegeSummonOrder_Show()
  local self = Panel_Window_SiegeSummonOrder_info
  self:open()
end
function PaGlobalFunc_SiegeSummonOrder_Exit()
  local self = Panel_Window_SiegeSummonOrder_info
  self:close()
end
function PaGlobal_SiegeSummon_OrderAttack()
  ToClient_CallHandlerSiegeSummon(siegeHandlerName[siegeHandlerType.Attack])
end
function PaGlobal_SiegeSummon_OrderSkill()
  ToClient_CallHandlerSiegeSummon(siegeHandlerName[siegeHandlerType.Skill])
end
function PaGlobal_SiegeSummon_OrderComeOn()
  ToClient_CallHandlerSiegeSummon(siegeHandlerName[siegeHandlerType.ComeOn])
end
function FromClient_SiegeSummonOrder_Init()
  local self = Panel_Window_SiegeSummonOrder_info
  self:initialize()
end
function FromClient_SiegeSummonOrder_Resize()
  local self = Panel_Window_SiegeSummonOrder_info
  self:resize()
end
function FromClient_SiegeSummonOrder_LinkSiegeSummonMonster(isLink)
  _PA_LOG("mingu", "Link:" .. tostring(isLink))
end
registerEvent("FromClient_luaLoadComplete", "FromClient_SiegeSummonOrder_Init")
