local _panel = Panel_Window_PersonalMonsterMessage
local PersonalMonsterMessage = {
  _ui = {
    _stc_MsgBG = UI.getChildControl(_panel, "Static_MsgBG"),
    _stc_BlackSpiritEffect = UI.getChildControl(_panel, "Static_blackSpiritEffect"),
    _stc_AlramBG = UI.getChildControl(_panel, "Static_AlramIMG")
  },
  _time = 0,
  _isAlram = false
}
function PersonalMonsterMessage:initialize()
  self._ui.txt_Desc = UI.getChildControl(self._ui._stc_MsgBG, "StaticText_Desc")
  self._ui.stc_BubbleBG = UI.getChildControl(self._ui._stc_BlackSpiritEffect, "Static_GuideBubble")
  self._ui.txt_BubbleMsg = UI.getChildControl(self._ui.stc_BubbleBG, "StaticText_BubbleDesc")
  self._ui.txt_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_BubbleMsg:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
end
function PersonalMonsterMessage:open()
  if not _panel:GetShow() then
    self._isAlram = false
    self._ui._stc_BlackSpiritEffect:EraseAllEffect()
    self._ui._stc_MsgBG:EraseAllEffect()
    self._ui._stc_BlackSpiritEffect:AddEffect("fN_DarkSpirit_Gage_01C", true, 0, 0)
    self._ui._stc_MsgBG:AddEffect("fUI_Personal_Monster_Descovery_01A", true, 0, 0)
    _panel:SetShow(true)
    self:showAni()
  else
    self._time = 0
  end
end
function PersonalMonsterMessage:update(key)
  local stringList = {
    "LUA_PERSONALMONSTER_BLACKSPIRIT3",
    "LUA_PERSONALMONSTER_BLACKSPIRIT4"
  }
  local stringNum = math.random(1, #stringList)
  if nil == stringNum then
    self._ui.txt_BubbleMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALMONSTER_BLACKSPIRIT3"))
  else
    self._ui.txt_BubbleMsg:SetText(PAGetString(Defines.StringSheet_GAME, stringList[stringNum]))
  end
  self._ui.txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALMONSTER_MESSAGE"))
end
function PersonalMonsterMessage:registEventHandler()
  _panel:RegisterUpdateFunc("FromClient_PersonalMonsterMessage_UpdatePerFrame")
end
function PaGlobal_PersonalMonsterMessage_Open(key)
  local self = PersonalMonsterMessage
  self:update(key)
  self:open()
  ToClient_ShakeCamera(0.1, 50, 0.5, 2)
end
function PaGlobal_PersonalMonsterMessage_Cancel()
  _panel:SetShow(false)
end
function PaGlobal_PersonalMonsterMessage_Alram()
  local self = PersonalMonsterMessage
  if nil == self then
    return
  end
  _panel:SetShow(true)
  self._isAlram = true
  self._ui._stc_MsgBG:SetShow(false)
  self._ui._stc_BlackSpiritEffect:SetShow(false)
  self._ui._stc_AlramBG:SetShow(true)
  self:showAlramAni()
end
function PersonalMonsterMessage:showAni()
  self._ui._stc_MsgBG:SetShow(true)
  self._ui._stc_BlackSpiritEffect:SetShow(false)
  self._ui._stc_AlramBG:SetShow(false)
  local personalMonsterMessage = self._ui._stc_MsgBG:addColorAnimation(0, 0.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  personalMonsterMessage:SetStartColor(Defines.Color.C_00000000)
  personalMonsterMessage:SetEndColor(Defines.Color.C_FFFFFFFF)
  personalMonsterMessage.IsChangeChild = true
  local personalMonsterMessage2 = self._ui._stc_MsgBG:addColorAnimation(8, 30, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  personalMonsterMessage2:SetStartColor(Defines.Color.C_FFFFFFFF)
  personalMonsterMessage2:SetEndColor(Defines.Color.C_00000000)
  personalMonsterMessage2.IsChangeChild = true
  audioPostEvent_SystemUi(25, 1)
end
function PersonalMonsterMessage:showAni2()
  local blackSpiritEffect = self._ui._stc_BlackSpiritEffect:addColorAnimation(0, 0.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  blackSpiritEffect:SetStartColor(Defines.Color.C_00000000)
  blackSpiritEffect:SetEndColor(Defines.Color.C_FFFFFFFF)
  _stc_BlackSpiritEffect.IsChangeChild = true
  local blackSpiritEffect2 = self._ui._stc_BlackSpiritEffect:addColorAnimation(2, 5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  blackSpiritEffect2:SetStartColor(Defines.Color.C_FFFFFFFF)
  blackSpiritEffect2:SetEndColor(Defines.Color.C_00000000)
  blackSpiritEffect2.IsChangeChild = true
  self._ui._stc_BlackSpiritEffect:SetShow(true)
  self._ui._stc_MsgBG:SetShow(false)
end
function PersonalMonsterMessage:showAlramAni()
  local AlramIMG = self._ui._stc_AlramBG:addColorAnimation(0, 0.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  AlramIMG:SetStartColor(Defines.Color.C_00000000)
  AlramIMG:SetEndColor(Defines.Color.C_FFFFFFFF)
  AlramIMG.IsChangeChild = true
  AlramIMG = self._ui._stc_AlramBG:addColorAnimation(5, 10, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  AlramIMG:SetStartColor(Defines.Color.C_FFFFFFFF)
  AlramIMG:SetEndColor(Defines.Color.C_00000000)
  AlramIMG.IsChangeChild = true
  audioPostEvent_SystemUi(25, 0)
end
function FromClient_PersonalMonsterMessage_UpdatePerFrame(deltaTime)
  local self = PersonalMonsterMessage
  self._time = self._time + deltaTime
  if self._isAlram == false then
    if self._time > 11 then
      PaGlobal_PersonalMonsterMessage_Cancel()
      self._time = 0
    end
  elseif self._time > 7 then
    PaGlobal_PersonalMonsterMessage_Cancel()
    self._time = 0
  end
end
function FromClient_luaLoadComplete_PersonalMonsterMessage_Initialize()
  local self = PersonalMonsterMessage
  self:initialize()
  self:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_PersonalMonsterMessage_Initialize")
