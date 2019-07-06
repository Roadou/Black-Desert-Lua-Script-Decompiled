local Panel_Window_StroyInstanceDungeon_info = {
  _ui = {movie = Panel_MovieStroyIndun, cutSceneMovie = nil},
  _value = {
    instanceDungeonKey = -1,
    isPlayMovie = 0,
    masterVolum = 0,
    setvolume = 0,
    url = ""
  },
  _config = {},
  _enum = {}
}
function Panel_Window_StroyInstanceDungeon_info:registEventHandler()
end
function Panel_Window_StroyInstanceDungeon_info:registerMessageHandler()
  registerEvent("FromClient_ShowIndunMessage", "FromClient_ShowIndunEnterMessage")
  registerEvent("FromClient_ShowIndunCutScene", "FromClient_StroyInstanceDungeon_ShowCutScene")
  registerEvent("ToClient_InGameMovieCutScene", "FromClient_StroyInstanceDungeon_InGameMovieCutScene")
  registerEvent("FromClient_ReadyToFrorceLeaveIndun", "FromClient_ReadyToFrorceLeaveIndun")
end
function Panel_Window_StroyInstanceDungeon_info:initialize()
  self:initValue()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_StroyInstanceDungeon_info:initLoadMovie()
  local sizeX = getScreenSizeX()
  local sizeY = getScreenSizeY()
  Panel_MovieStroyIndun:SetSize(sizeX, sizeY)
  Panel_MovieStroyIndun:SetPosXY(0, 0)
  local uiScale = getGlobalScale()
  local sizeX = getResolutionSizeX()
  local sizeY = getResolutionSizeY()
  sizeX = sizeX / uiScale
  sizeY = sizeY / uiScale
  local movieSizeX = sizeX
  local movieSizeY = sizeX * 1080 / 1920
  local posX = 0
  local posY = 0
  if sizeY >= movieSizeY then
    posY = (sizeY - movieSizeY) / 2
  else
    movieSizeX = sizeY * 1920 / 1080
    movieSizeY = sizeY
    posX = (sizeX - movieSizeX) / 2
  end
  local marginX = movieSizeX * 0.013
  local marginY = movieSizeY * 0.013
  if nil == self._ui.cutSceneMovie then
    self._ui.cutSceneMovie = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_MovieStroyIndun, "Static_StroyMovie")
  end
  if nil ~= self._ui.cutSceneMovie then
    self._ui.cutSceneMovie:SetPosX(posX - marginX / 2)
    self._ui.cutSceneMovie:SetPosY(posY - marginY / 2)
    self._ui.cutSceneMovie:SetSize(movieSizeX + marginX, movieSizeY + marginY)
    self._ui.cutSceneMovie:SetUrl(1920, 1080, "coui://UI_Data/UI_Html/InGame_Movie.html")
  end
end
function Panel_Window_StroyInstanceDungeon_info:initValue()
  self._value.instanceDungeonKey = -1
  self._value.setvolume = false
  self._value.isPlayMovie = false
  self._value.url = ""
end
function Panel_Window_StroyInstanceDungeon_info:stop()
  setVolumeParamMaster(self._value.masterVolum)
  self._value.isPlayMovie = false
  self._value.setvolume = false
  if nil ~= self._ui.cutSceneMovie then
    self._ui.cutSceneMovie:TriggerEvent("StopMovie", "")
  end
end
function Panel_Window_StroyInstanceDungeon_info:play(url)
  self._value.masterVolum = getVolumeParam(0)
  setVolumeParamMaster(0)
  self._value.isPlayMovie = true
  self._value.setvolume = true
  if nil ~= self._ui.cutSceneMovie then
    self._ui.cutSceneMovie:TriggerEvent("ControlAudio", self._value.masterVolum / 100)
    self._ui.cutSceneMovie:TriggerEvent("PlayMovie", url)
  end
end
function Panel_Window_StroyInstanceDungeon_info:isShow()
  return Panel_MovieStroyIndun:IsShow()
end
function Panel_Window_StroyInstanceDungeon_info:open()
  Panel_MovieStroyIndun:SetShow(true)
end
function Panel_Window_StroyInstanceDungeon_info:close()
  Panel_MovieStroyIndun:SetShow(false)
end
function PaGlobalFunc_StroyInstanceDungeon_GetShow()
end
function PaGlobalFunc_StroyInstanceDungeon_Open()
  local self = Panel_Window_StroyInstanceDungeon_info
  self:open()
end
function PaGlobalFunc_StroyInstanceDungeon_Close()
  local self = Panel_Window_StroyInstanceDungeon_info
  self:stop()
  self:close()
end
function PaGlobalFunc_StroyInstanceDungeon_Show()
  local self = Panel_Window_StroyInstanceDungeon_info
  self:open()
end
function PaGlobalFunc_StroyInstanceDungeon_Exit()
  local self = Panel_Window_StroyInstanceDungeon_info
  local titleText = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local message = PAGetString(Defines.StringSheet_GAME, "CUTSCENE_EXIT_MESSAGEBOX_MEMO")
  local messageboxData = {
    title = titleText,
    content = message,
    functionYes = PaGlobalFunc_StroyInstanceDungeon_Close,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_StroyInstanceDungeon_Enter()
  local self = Panel_Window_StroyInstanceDungeon_info
  local indunkey = self._value.instanceDungeonKey
  if true == ToClient_BlackspiritisSummoning() then
    return
  end
  ToClient_EnterIntanceDungeon(indunkey, true)
end
function PaGlobalFunc_StroyInstanceDungeon_Leave()
  local self = Panel_Window_StroyInstanceDungeon_info
  self._value.instanceDungeonKey = -1
  if true == ToClient_BlackspiritisSummoning() then
    return
  end
  ToClient_EnterIntanceDungeon(-1, false)
end
function FromClient_StroyInstanceDungeon_InGameMovieCutScene(eventId)
  local self = Panel_Window_StroyInstanceDungeon_info
  if 1 == eventId then
    self:play(self._value.url)
  elseif 2 == eventId then
    self:stop()
    self:close()
  end
end
function FromClient_StroyInstanceDungeon_Init()
  local self = Panel_Window_StroyInstanceDungeon_info
  self:initialize()
end
function FromClient_ShowIndunEnterMessage(indunKey, enterRequest)
  local self = Panel_Window_StroyInstanceDungeon_info
  if true == ToClient_BlackspiritisSummoning() then
    return
  end
  if true == enterRequest then
    self._value.instanceDungeonKey = indunKey
    local titleText = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
    local message = PAGetString(Defines.StringSheet_GAME, "LUA_STORYINSTANCEDUNGEON_ENTER")
    local messageboxData = {
      title = titleText,
      content = message,
      functionYes = PaGlobalFunc_StroyInstanceDungeon_Enter,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    local titleText = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
    local message = PAGetString(Defines.StringSheet_GAME, "LUA_STORYINSTANCEDUNGEON_LEAVE")
    local messageboxData = {
      title = titleText,
      content = message,
      functionYes = PaGlobalFunc_StroyInstanceDungeon_Leave,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function FromClient_StroyInstanceDungeon_ShowCutScene(url)
  local self = Panel_Window_StroyInstanceDungeon_info
  if true == self:isShow() then
    _PA_LOG("Common", "\236\138\164\237\134\160\235\166\172 \236\157\184\235\141\152 \236\187\183\236\148\172\236\157\180 \236\157\180\235\175\184 \235\150\160\236\158\136\236\150\180\236\154\148.")
    return
  end
  self:initLoadMovie()
  self:open()
  self._value.url = url
end
function FromClient_ReadyToFrorceLeaveIndun()
  local self = Panel_Window_StroyInstanceDungeon_info
  if true == self._value.setvolume then
    setVolumeParamMaster(self._value.masterVolum)
  end
end
registerEvent("FromClient_luaLoadCompleteLateUdpate", "FromClient_StroyInstanceDungeon_Init")
