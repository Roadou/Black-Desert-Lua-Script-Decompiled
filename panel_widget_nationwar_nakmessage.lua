local _panel = Panel_Widget_NationWar_NakMessage
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_LifeString = CppEnums.LifeExperienceString
local UI_VT = CppEnums.VehicleType
local MessageData = {
  _Msg = {}
}
local nationMessage = {
  _ui = {
    bg = UI.getChildControl(_panel, "Static_Bg"),
    mainText = UI.getChildControl(_panel, "StaticText_MainText"),
    subText = UI.getChildControl(_panel, "StaticText_SubText")
  },
  _animateTime = 0,
  _showTime = 0,
  _messageType = {},
  _messageTexture = {},
  _messageSize = {},
  _messageAlign = {},
  _isBossDead = false
}
nationMessage._messageType = {
  _ready = 0,
  _start = 1,
  _draw = 2,
  _calpheonWin = 3,
  _valenciaWin = 4,
  _supplyWagonMove = 5,
  _destroySupplyWagon = 6,
  _depeatBoss = 7,
  _damagedBoss = 8
}
nationMessage._messageTexture = {
  [nationMessage._messageType._ready] = "New_UI_Common_forLua/Widget/NakMessage/NationWar_Nak_Draw.dds",
  [nationMessage._messageType._start] = "New_UI_Common_forLua/Widget/NakMessage/NationWar_Nak_Draw.dds",
  [nationMessage._messageType._draw] = "New_UI_Common_forLua/Widget/NakMessage/NationWar_Nak_Draw.dds",
  [nationMessage._messageType._calpheonWin] = "New_UI_Common_forLua/Widget/NakMessage/NationWar_Nak_CalpheonWin.dds",
  [nationMessage._messageType._valenciaWin] = "New_UI_Common_forLua/Widget/NakMessage/NationWar_Nak_ValenciaWin.dds",
  [nationMessage._messageType._supplyWagonMove] = "New_UI_Common_forLua/Widget/NakMessage/Alert_01.dds",
  [nationMessage._messageType._destroySupplyWagon] = "New_UI_Common_forLua/Widget/NakMessage/Alert_01.dds",
  [nationMessage._messageType._depeatBoss] = "New_UI_Common_forLua/Widget/NakMessage/NationWar_Nak_KillSign.dds",
  [nationMessage._messageType._damagedBoss] = "New_UI_Common_forLua/Widget/NakMessage/NationWar_Nak_GeneralBlood.dds"
}
nationMessage._messageSize = {
  [nationMessage._messageType._ready] = {sizeX = 820, sizeY = 423},
  [nationMessage._messageType._start] = {sizeX = 827, sizeY = 569},
  [nationMessage._messageType._draw] = {sizeX = 827, sizeY = 569},
  [nationMessage._messageType._calpheonWin] = {sizeX = 827, sizeY = 569},
  [nationMessage._messageType._valenciaWin] = {sizeX = 827, sizeY = 569},
  [nationMessage._messageType._supplyWagonMove] = {sizeX = 526, sizeY = 128},
  [nationMessage._messageType._destroySupplyWagon] = {sizeX = 526, sizeY = 128},
  [nationMessage._messageType._depeatBoss] = {sizeX = 526, sizeY = 128},
  [nationMessage._messageType._damagedBoss] = {sizeX = 526, sizeY = 128}
}
nationMessage._messageAlign = {
  [nationMessage._messageType._ready] = {mainSpanY = 30, subSpanY = 55},
  [nationMessage._messageType._start] = {mainSpanY = 110, subSpanY = 135},
  [nationMessage._messageType._draw] = {mainSpanY = 110, subSpanY = 135},
  [nationMessage._messageType._calpheonWin] = {mainSpanY = 70, subSpanY = 95},
  [nationMessage._messageType._valenciaWin] = {mainSpanY = 70, subSpanY = 95},
  [nationMessage._messageType._supplyWagonMove] = {mainSpanY = 30, subSpanY = 55},
  [nationMessage._messageType._destroySupplyWagon] = {mainSpanY = 30, subSpanY = 55},
  [nationMessage._messageType._depeatBoss] = {mainSpanY = 15, subSpanY = 40},
  [nationMessage._messageType._damagedBoss] = {mainSpanY = 15, subSpanY = 40}
}
function PaGlobalFunc_NationWar_NakMessage_Init()
  local self = nationMessage
  self:registerEventHandler()
end
function nationMessage:setAnimation(animationType)
  if nil == animationType then
    animationType = 0
  end
  if 0 == animationType then
    local colorAni = self._ui.bg:addColorAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    colorAni:SetStartColor(Defines.Color.C_00FFFFFF)
    colorAni:SetEndColor(Defines.Color.C_FFFFFFFF)
    colorAni.IsChangeChild = true
    local moveAni1 = self._ui.mainText:addMoveAnimation(0, 0.15, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
    moveAni1:SetStartPosition(_panel:GetSizeX() / 4, self._ui.mainText:GetPosY())
    moveAni1:SetEndPosition(_panel:GetSizeX() / 2 - self._ui.mainText:GetSizeX() / 2, self._ui.mainText:GetPosY())
    self._ui.mainText:CalcUIAniPos(moveAni1)
    local moveAni2 = self._ui.subText:addMoveAnimation(0, 0.15, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
    moveAni2:SetStartPosition(_panel:GetSizeX() / 4 * 3, self._ui.subText:GetPosY())
    moveAni2:SetEndPosition(_panel:GetSizeX() / 2 - self._ui.subText:GetSizeX() / 2, self._ui.subText:GetPosY())
    self._ui.subText:CalcUIAniPos(moveAni2)
  end
end
function nationMessage:hideAni()
  local colorAni = _panel:addColorAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  colorAni:SetStartColor(Defines.Color.C_FFFFFFFF)
  colorAni:SetEndColor(Defines.Color.C_00FFFFFF)
  colorAni.IsChangeChild = true
  colorAni:SetHideAtEnd(true)
end
function nationMessage:setEffect(messageType)
  self._ui.bg:EraseAllEffect()
  if self._messageType._ready == messageType then
  elseif self._messageType._start == messageType then
    self._ui.bg:AddEffect("fUI_Country_Start01", false, 0, 130)
    self._ui.bg:AddEffect("fUI_ImperialStart", false, 0, 110)
  elseif self._messageType._draw == messageType then
    self._ui.bg:AddEffect("fUI_Country_Win", false, 0, 190)
    self._ui.bg:AddEffect("fUI_ImperialStart", false, 0, 150)
  elseif self._messageType._calpheonWin == messageType then
    self._ui.bg:AddEffect("fUI_Country_Win", false, 0, 190)
    self._ui.bg:AddEffect("fUI_ImperialStart", false, 0, 150)
  elseif self._messageType._valenciaWin == messageType then
    self._ui.bg:AddEffect("fUI_Country_Win", false, 0, 190)
    self._ui.bg:AddEffect("fUI_ImperialStart", false, 0, 150)
  elseif self._messageType._supplyWagonMove == messageType then
  elseif self._messageType._destroySupplyWagon == messageType then
  elseif self._messageType._depeatBoss == messageType then
  elseif self._messageType._damagedBoss == messageType then
  end
end
function PaGlobalFunc_NationWar_ChattingMessage_Show(message)
  if nil == message.sub or "" == message.sub then
    chatting_sendMessage("", message.main, CppEnums.ChatType.System)
  else
    chatting_sendMessage("", message.main .. "(" .. message.sub .. ")", CppEnums.ChatType.System)
  end
end
function PaGlobalFunc_NationWar_Message_Show(message, messageType, showTime, isChatting, animationType)
  local self = nationMessage
  if isChatting then
    PaGlobalFunc_NationWar_ChattingMessage_Show(message)
  end
  if nil == message.sub or "" == message.sub then
    self._ui.subText:SetShow(false)
  else
    self._ui.subText:SetText(message.sub)
    self._ui.subText:SetShow(true)
  end
  self._ui.mainText:SetText(message.main)
  _panel:SetSize(self._messageSize[messageType].sizeX, self._messageSize[messageType].sizeY)
  self._ui.bg:SetSize(self._messageSize[messageType].sizeX, self._messageSize[messageType].sizeY)
  _panel:ComputePos()
  self._ui.bg:ComputePos()
  self._ui.mainText:SetSpanSize(0, self._messageAlign[messageType].mainSpanY)
  self._ui.subText:SetSpanSize(0, self._messageAlign[messageType].subSpanY)
  self._ui.bg:ChangeTextureInfoName(self._messageTexture[messageType])
  self:setEffect(messageType)
  self:setAnimation(animationType)
  self._showTime = showTime
  if true == NationSiege_Widget._isCommanderDead then
    self._isBossDead = true
  end
  self:open()
end
function nationMessage:open()
  self._animateTime = 0
  if not _panel:GetShow() then
    _panel:SetShow(true)
    _panel:RegisterUpdateFunc("PaGlobalFunc_NationWar_UpdatePerFrame")
  end
  if nil ~= Panel_RewardSelect_NakMessage and Panel_RewardSelect_NakMessage:GetShow() then
    Panel_RewardSelect_NakMessage:SetShow(false)
  end
end
function nationMessage:close()
  self:hideAni()
end
function PaGlobalFunc_NationWar_UpdatePerFrame(deltaTime)
  local self = nationMessage
  self._animateTime = self._animateTime + deltaTime
  if self._animateTime < self._showTime then
  else
    self._animateTime = 0
    self._showTime = 0
    if true == self._isBossDead then
      PaGlobal_NationSiege_StopMessage()
      self._isBossDead = false
    else
      self:close()
      _panel:ClearUpdateLuaFunc()
    end
  end
end
function PaGlobalFunc_NationWar_NakMessage_GetShow()
  if nil == _panel then
    return false
  else
    return _panel:GetShow()
  end
end
function PaGlobalFunc_NationWar_Resize()
  _panel:ComputePos()
end
function PaGlobalFunc_NationWar_RenderModeChange()
end
function nationMessage:registerEventHandler()
  registerEvent("onScreenResize", "PaGlobalFunc_NationWar_Resize")
  registerEvent("FromClient_RenderModeChangeState", "PaGlobalFunc_NationWar_RenderModeChange")
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_NationWar_NakMessage_Init")
