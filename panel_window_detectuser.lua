local DetectUser = {
  _ui = {
    _edit_UserNickName = UI.getChildControl(Panel_Window_DetectUser, "Edit_Naming"),
    _btn_Yes = UI.getChildControl(Panel_Window_DetectUser, "Button_Yes"),
    _btn_Close = UI.getChildControl(Panel_Window_DetectUser, "Button_Close"),
    _btn_No = UI.getChildControl(Panel_Window_DetectUser, "Button_No"),
    _ani_Search = UI.getChildControl(Panel_Window_DetectUser, "Static_SequenceIcon"),
    _txt_Desc = UI.getChildControl(Panel_Window_DetectUser, "StaticText_Description"),
    _txt_Result = UI.getChildControl(Panel_DetectUserButton, "Static_ResultBg")
  },
  _endSec = 5,
  _curSec = 0,
  _state = 0,
  _pos3 = nil
}
function DetectUser:init()
  self._ui._edit_UserNickName:SetEditText("", true)
  self._ui._edit_UserNickName:SetMaxInput(getGameServiceTypeUserNickNameLength())
  self._ui._btn_Yes:addInputEvent("Mouse_LUp", "PaGlobalFunc_DetectUser_Req()")
  self._ui._btn_No:addInputEvent("Mouse_LUp", "PaGlobalFunc_DetectUser_Close()")
  self._ui._btn_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_DetectUser_Close()")
  self._ui._txt_TargetName = UI.getChildControl(self._ui._txt_Result, "StaticText_UserName")
  self._ui._txt_ServerName = UI.getChildControl(self._ui._txt_Result, "StaticText_ServerName")
  registerEvent("FromClient_OpenDetectUser", "FromClient_OpenDetectUser")
  registerEvent("FromClient_CompleteDetectUser", "FromClient_CompleteDetectUser")
  Panel_Window_DetectUser:RegisterUpdateFunc("PaGlobalFunc_DetectUser_Update")
end
function PaGlobalFunc_DetectUser_Req()
  local self = DetectUser
  if self._ui._edit_UserNickName:GetEditText() == getSelfPlayer():getUserNickname() then
    Proc_ShowMessage_Ack("\236\158\144\234\184\176 \236\158\144\236\139\160\236\157\132 \236\176\190\236\157\132\236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local rv = ToClient_DetectUser(self._ui._edit_UserNickName:GetEditText(), self._fromWhereType, self._fromSlotNo)
  if true == rv then
    self._state = 1
    self._ui._btn_Yes:SetIgnore(true)
    self._ui._btn_Yes:SetMonoTone(true)
  end
end
function PaGlobalFunc_DetectUser_Close()
  Panel_Window_DetectUser:SetShow(false)
end
function PaGlobalFunc_DetectUser_Init()
  DetectUser:init()
end
function PaGlobalFunc_DetectUser_Update(deltaTime)
  local self = DetectUser
  if 0 == self._state then
    return
  end
  self._curSec = self._curSec + deltaTime
  if self._endSec < self._curSec and 1 == self._state then
    self._state = 2
    self._ui._txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DETECTUSER_NOJOINUSER"))
  elseif self._endSec + 2 < self._curSec and 2 == self._state then
    self._state = 0
    PaGlobalFunc_DetectUser_Close()
  elseif self._curSec > 2 and 3 == self._state then
    self._state = 0
    FGlobal_PushOpenWorldMap()
    local rv = ToClient_WorldMapNaviStart(self._pos3, NavigationGuideParam(), false, false)
    if 0 ~= rv then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DETECTUSER_DONT_FIND_USER"))
    end
    Panel_DetectUserButton:SetShow(true)
    PaGlobalFunc_DetectUser_Close()
  end
end
function FromClient_OpenDetectUser(fromWhereType, fromSlotNo)
  if true == Panel_Window_DetectUser:GetShow() then
    return
  end
  local self = DetectUser
  self._ui._edit_UserNickName:SetEditText("", true)
  self._curSec = 0
  self._state = 0
  self._pos3 = nil
  self._ui._ani_Search:SetShow(false)
  self._fromWhereType = fromWhereType
  self._fromSlotNo = fromSlotNo
  self._ui._txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DETECTUSER_BOTTOM_DESC"))
  self._ui._txt_TargetName:SetText("")
  self._ui._txt_ServerName:SetText("")
  self._ui._btn_Yes:SetIgnore(false)
  self._ui._btn_Yes:SetMonoTone(false)
  Panel_DetectUserButton:SetShow(false)
  Panel_Window_DetectUser:SetShow(true)
end
function FromClient_CompleteDetectUser(pos3, isExist, serverNo)
  local self = DetectUser
  if false == isExist then
    self._ui._ani_Search:SetShow(true)
    self._ui._txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DETECTUSER_FINDING_USER"))
  else
    local curChannelData = getCurrentChannelServerData()
    if nil == curChannelData then
      return
    end
    self._ui._txt_TargetName:SetText(self._ui._edit_UserNickName:GetEditText())
    self._ui._txt_ServerName:SetText(getChannelName(curChannelData._worldNo, serverNo))
    self._pos3 = pos3
    self._state = 3
  end
end
function PaGlobalFunc_DetectUserButton_Close()
  Panel_DetectUserButton:SetShow(false)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_DetectUser_Init")
