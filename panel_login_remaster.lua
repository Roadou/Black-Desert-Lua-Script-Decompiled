Panel_Login_Remaster:SetSize(getScreenSizeX(), getScreenSizeY())
local _panel = Panel_Login_Remaster
local PanelLogin = {
  _ui = {
    stc_scrollBG = {},
    stc_scrollBG1 = UI.getChildControl(_panel, "bgBase_1"),
    stc_scrollBG2 = UI.getChildControl(_panel, "bgBase_2"),
    stc_scrollBG3 = UI.getChildControl(_panel, "bgBase_3"),
    stc_scrollBG4 = UI.getChildControl(_panel, "bgBase_4"),
    stc_webUI = UI.getChildControl(_panel, "Static_WebParent"),
    stc_fade = UI.getChildControl(_panel, "Static_Fade"),
    stc_EventBG = UI.getChildControl(_panel, "Static_EventBG"),
    stc_BI = UI.getChildControl(_panel, "Static_BI"),
    btn_Login = UI.getChildControl(_panel, "Button_Login"),
    btn_Exit = UI.getChildControl(_panel, "Button_Exit"),
    btn_GameOption = UI.getChildControl(_panel, "Button_GameOption_Login"),
    btn_ChangeAccount = UI.getChildControl(_panel, "Button_ChangeAccount"),
    edit_ID = UI.getChildControl(_panel, "Edit_ID"),
    txt_InputID = UI.getChildControl(_panel, "StaticText_InputTxt"),
    stc_BlacklineUp = UI.getChildControl(_panel, "Static_Blackline_up"),
    stc_BlacklineDown = UI.getChildControl(_panel, "Static_Blackline_down"),
    stc_CI = UI.getChildControl(_panel, "Static_CI"),
    stc_DaumCI = UI.getChildControl(_panel, "Static_DaumCI")
  }
}
local _ui_web_loadingMovie
local _elapsedTime = 30
local _repeatInterval = 30
local _halfOfInterval = 5
local _animTable = {
  40,
  -25,
  -80,
  -140,
  -100
}
local _movieLength = {
  10000,
  10000,
  10000
}
local _movieURL = {
  "coui://UI_Movie/01_sliced.webm",
  "coui://UI_Movie/04_sliced.webm",
  "coui://UI_Movie/05_sliced.webm"
}
local _movieOrder = {
  1,
  2,
  3
}
local _currentMovieIndex
local self = PanelLogin
function PaGlobal_PanelLogin_Init()
  self:init()
  self:registEvent()
  setPresentLock(true)
end
function PanelLogin:init()
  self._ui.stc_scrollBG[1] = self._ui.stc_scrollBG1
  self._ui.stc_scrollBG[2] = self._ui.stc_scrollBG2
  self._ui.stc_scrollBG[3] = self._ui.stc_scrollBG3
  self._ui.stc_scrollBG[4] = self._ui.stc_scrollBG4
  if false == isLoginIDShow() then
    self._ui.edit_ID:SetShow(false)
    self._ui.txt_InputID:SetShow(false)
  else
    self._ui.edit_ID:SetShow(true)
    self._ui.txt_InputID:SetShow(true)
    self._ui.edit_ID:SetEditText(getLoginID())
  end
  _currentMovieIndex = 1
  self:shuffleOrder(_movieOrder)
end
function PanelLogin:shuffleOrder(table)
  if nil == table or nil == #table then
    return
  end
  if #table <= 1 then
    return
  end
  for ii = 1, #table do
    local temp = table[ii]
    local posToShuffle = getRandomValue(1, #table)
    table[ii] = table[posToShuffle]
    table[posToShuffle] = temp
  end
end
function PanelLogin:registEvent()
  self._ui.btn_Login:addInputEvent("Mouse_LUp", "PaGlobal_PanelLogin_BeforeOpen()")
  self._ui.btn_Exit:addInputEvent("Mouse_LUp", "GlobalExitGameClient()")
  self._ui.btn_ChangeAccount:addInputEvent("Mouse_LUp", "PaGlobal_PanelLogin_ButtonClick_ChangeAccount()")
  self._ui.btn_GameOption:addInputEvent("Mouse_LUp", "showGameOption()")
  if ToClient_isConsole() then
    self._ui.btn_GameOption:SetShow(false)
  else
    self._ui.btn_ChangeAccount:SetShow(false)
  end
  _panel:RegisterUpdateFunc("PaGlobal_PanelLogin_PerFrameUpdate")
  registerEvent("ToClient_EndGuideMovie", "FromClient_LoginRemaster_OnMovieEvent")
  registerEvent("onScreenResize", "PaGlobal_PanelLogin_Resize")
end
function FromClient_LoginRemaster_OnMovieEvent(param)
  if 1 == param then
    self:startFadeIn()
    if nil ~= _ui_web_loadingMovie then
      _ui_web_loadingMovie:TriggerEvent("PlayMovie", _movieURL[_movieOrder[_currentMovieIndex]])
    end
  elseif 2 == param then
    _currentMovieIndex = _currentMovieIndex + 1
    if nil == _movieOrder[_currentMovieIndex] then
      _currentMovieIndex = 1
    end
    _ui_web_loadingMovie:TriggerEvent("PlayMovie", _movieURL[_movieOrder[_currentMovieIndex]])
    self:startFadeIn()
  end
end
function PaGlobalFunc_PanelLogin_FadeIn()
  self:startFadeIn()
end
function PaGlobalFunc_PanelLogin_FadeOut()
  self:startFadeOut()
end
local _fadeTime = 1
function PanelLogin:startFadeIn()
  self._ui.stc_fade:SetShow(false)
end
function PanelLogin:startFadeOut()
  self._ui.stc_fade:SetShow(false)
end
function PanelLogin:loginEnter()
  connectToGame(self._ui.edit_ID:GetEditText(), "\234\178\128\236\157\128\236\160\132\236\130\172\235\185\132\235\178\136")
end
function PanelLoginMovieInit()
  if nil == _ui_web_loadingMovie then
    _ui_web_loadingMovie = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, self._ui.stc_webUI, "Static_BgMovie")
  end
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
  _panel:SetPosX(0)
  _panel:SetPosY(0)
  _panel:SetSize(sizeX, sizeY)
  local marginX = movieSizeX * 0.013
  local marginY = movieSizeY * 0.013
  _ui_web_loadingMovie:SetPosX(posX - marginX / 2)
  _ui_web_loadingMovie:SetPosY(posY - marginY / 2)
  _ui_web_loadingMovie:SetSize(movieSizeX + marginX, movieSizeY + marginY)
  _ui_web_loadingMovie:SetUrl(1920, 1080, "coui://UI_Data/UI_Html/LobbyBG_Movie.html")
end
function PaGlobal_PanelLogin_Resize()
  self._ui.stc_fade:SetSize(getScreenSizeX(), getScreenSizeY())
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
  _panel:SetPosX(0)
  _panel:SetPosY(0)
  _panel:SetSize(sizeX, sizeY)
  local marginX = movieSizeX * 0.013
  local marginY = movieSizeY * 0.013
  if nil ~= _ui_web_loadingMovie then
    _ui_web_loadingMovie:SetPosX(posX - marginX / 2)
    _ui_web_loadingMovie:SetPosY(posY - marginY / 2)
    _ui_web_loadingMovie:SetSize(movieSizeX + marginX, movieSizeY + marginY)
  end
  self._ui.btn_Login:ComputePos()
  self._ui.btn_Exit:ComputePos()
  self._ui.btn_GameOption:ComputePos()
  self._ui.btn_ChangeAccount:ComputePos()
  self._ui.edit_ID:ComputePos()
  self._ui.txt_InputID:ComputePos()
  self._ui.stc_EventBG:ComputePos()
  self._ui.stc_BlacklineUp:SetShow(false)
  self._ui.stc_BlacklineDown:SetShow(false)
  if isGameTypeJapan() then
    self._ui.stc_DaumCI:SetSize(111, 26)
    self._ui.stc_DaumCI:ChangeTextureInfoName("new_ui_common_forlua/window/lobby/login_CI_Daum.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_DaumCI, 0, 0, 111, 26)
    self._ui.stc_DaumCI:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.stc_DaumCI:setRenderTexture(self._ui.stc_DaumCI:getBaseTexture())
    self._ui.stc_CI:SetSpanSize(self._ui.stc_DaumCI:GetSizeX() + 30, (self._ui.stc_BlacklineDown:GetSizeY() - self._ui.stc_CI:GetSizeY()) / 2)
  elseif isGameTypeEnglish() then
    self._ui.stc_DaumCI:SetSize(144, 26)
    self._ui.stc_DaumCI:ChangeTextureInfoName("new_ui_common_forlua/window/lobby/login_CI_Daum.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_DaumCI, 0, 0, 144, 26)
    self._ui.stc_DaumCI:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.stc_DaumCI:setRenderTexture(self._ui.stc_DaumCI:getBaseTexture())
    self._ui.stc_CI:SetSpanSize(self._ui.stc_DaumCI:GetSizeX() + 30, (self._ui.stc_BlacklineDown:GetSizeY() - self._ui.stc_CI:GetSizeY()) / 2)
  elseif isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeGT() or isGameTypeTR() or isGameTypeTH() or isGameTypeID() or ToClient_isConsole() or isGameTypeRussia() then
    self._ui.stc_DaumCI:SetShow(false)
    self._ui.stc_CI:SetSpanSize(10, (self._ui.stc_BlacklineDown:GetSizeY() - self._ui.stc_CI:GetSizeY()) / 2)
  elseif isGameTypeSA() then
    self._ui.stc_DaumCI:SetSize(136, 50)
    self._ui.stc_DaumCI:ChangeTextureInfoName("new_ui_common_forlua/window/lobby/login_CI_Daum.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_DaumCI, 0, 0, 136, 50)
    self._ui.stc_DaumCI:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.stc_DaumCI:setRenderTexture(self._ui.stc_DaumCI:getBaseTexture())
    self._ui.stc_CI:SetSpanSize(self._ui.stc_DaumCI:GetSizeX() + 30, (self._ui.stc_BlacklineDown:GetSizeY() - self._ui.stc_CI:GetSizeY()) / 2)
  elseif isGameTypeKR2() then
    self._ui.stc_DaumCI:SetSize(95, 53)
    self._ui.stc_DaumCI:ChangeTextureInfoName("new_ui_common_forlua/window/lobby/login_CI_Daum.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_DaumCI, 0, 0, 95, 53)
    self._ui.stc_DaumCI:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.stc_DaumCI:setRenderTexture(self._ui.stc_DaumCI:getBaseTexture())
    self._ui.stc_CI:SetSpanSize(self._ui.stc_DaumCI:GetSizeX() + 30, (self._ui.stc_BlacklineDown:GetSizeY() - self._ui.stc_CI:GetSizeY()) / 2)
  else
    self._ui.stc_DaumCI:SetSize(144, 26)
    self._ui.stc_DaumCI:ChangeTextureInfoName("new_ui_common_forlua/window/lobby/login_CI_Daum.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_DaumCI, 0, 0, 144, 26)
    self._ui.stc_DaumCI:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.stc_DaumCI:setRenderTexture(self._ui.stc_DaumCI:getBaseTexture())
    self._ui.stc_CI:SetSpanSize(self._ui.stc_DaumCI:GetSizeX() + 30, (self._ui.stc_BlacklineDown:GetSizeY() - self._ui.stc_CI:GetSizeY()) / 2)
  end
  self._ui.stc_DaumCI:SetSpanSize(20, (self._ui.stc_BlacklineDown:GetSizeY() - self._ui.stc_DaumCI:GetSizeY()) / 2)
  self._ui.stc_BI:ComputePos()
  self._ui.stc_CI:ComputePos()
  self._ui.stc_DaumCI:ComputePos()
  self._ui.stc_BlacklineUp:ComputePos()
  self._ui.stc_BlacklineDown:ComputePos()
  self._ui.stc_BI:SetPosY(getScreenSizeY() * 0.14)
  PaGlobal_CheckGamerTag()
end
function PaGlobal_PanelLogin_PerFrameUpdate(deltaTime)
  _elapsedTime = _elapsedTime + deltaTime
  luaTimer_UpdatePerFrame(deltaTime)
  for ii = 1, #self._ui.stc_scrollBG do
    self._ui.stc_scrollBG[ii]:SetPosX_XXX(_animTable[ii] * math.cos(_elapsedTime / _repeatInterval * math.pi * 2))
  end
end
function PaGlobal_PanelLogin_BeforeOpen()
  local serviceType = getGameServiceType()
  if (isGameTypeTaiwan() or isGameTypeGT() or isGameTypeKorea()) and 1 ~= serviceType then
    FGlobal_TermsofGameUse_Open()
  else
    FGlobal_Panel_Login_Enter()
  end
end
function Panel_Login_BeforOpen()
  PaGlobal_PanelLogin_BeforeOpen()
end
function FGlobal_Panel_Login_Enter()
  self:loginEnter()
end
function PanelLogin:animateBG(control, deltaTime, target, flag)
  local currentPos = control:GetPosX()
  local distance = target - currentPos
  local acc = distance / 40 * deltaTime * 10
  if 0.2 < math.abs(distance) then
    control:SetPosX(currentPos + acc)
  else
    control:SetPosX(target)
    flag = false
  end
end
function PanelLogin:animateControl(deltaTime, control, target)
  local currentPos = control:GetPosX()
  local distance = _rightBgTargetX - currentPos
  local acc = distance / 40 * deltaTime * 500
  if acc > -1 and acc < 0 then
    acc = -1
  elseif acc < 1 and acc > 0 then
    acc = 1
  end
  if 1 < math.abs(distance) then
    control:SetPosX(currentPos + acc)
  else
    control:SetPosX(_rightBgTargetX)
    _startAnimationFlag = false
  end
end
function Panel_Login_ButtonDisable(bool)
  if true == bool then
    PanelLogin._ui.btn_Login:SetEnable(false)
    PanelLogin._ui.btn_Login:SetMonoTone(true)
    PanelLogin._ui.btn_Login:SetIgnore(true)
    PanelLogin._ui.btn_Exit:SetEnable(false)
    PanelLogin._ui.btn_Exit:SetMonoTone(true)
    PanelLogin._ui.btn_Exit:SetIgnore(true)
    PanelLogin._ui.btn_GameOption:SetEnable(false)
    PanelLogin._ui.btn_GameOption:SetMonoTone(true)
    PanelLogin._ui.btn_GameOption:SetIgnore(true)
    PanelLogin._ui.btn_ChangeAccount:SetEnable(false)
    PanelLogin._ui.btn_ChangeAccount:SetMonoTone(true)
    PanelLogin._ui.btn_ChangeAccount:SetIgnore(true)
  else
    PanelLogin._ui.btn_Login:SetEnable(true)
    PanelLogin._ui.btn_Login:SetMonoTone(false)
    PanelLogin._ui.btn_Login:SetIgnore(false)
    PanelLogin._ui.btn_Exit:SetEnable(true)
    PanelLogin._ui.btn_Exit:SetMonoTone(false)
    PanelLogin._ui.btn_Exit:SetIgnore(false)
    PanelLogin._ui.btn_GameOption:SetEnable(true)
    PanelLogin._ui.btn_GameOption:SetMonoTone(false)
    PanelLogin._ui.btn_GameOption:SetIgnore(false)
    PanelLogin._ui.btn_ChangeAccount:SetEnable(true)
    PanelLogin._ui.btn_ChangeAccount:SetMonoTone(false)
    PanelLogin._ui.btn_ChangeAccount:SetIgnore(false)
  end
end
function PaGlobal_PanelLogin_ButtonClick_ChangeAccount()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING_CHANGEACCOUNT_MSGBOX")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = PaGlobal_PanelLogin_ChangeAccount_MessageBoxConfirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData, "top")
end
function PaGlobal_PanelLogin_ChangeAccount_MessageBoxConfirm()
  ToClient_ChangeAccount()
end
PaGlobal_PanelLogin_Init()
PaGlobal_PanelLogin_Resize()
_panel:SetShow(true)
function InitLoginMoviePanel()
  _PA_LOG("COHERENT", "PanelLoginMovieInit")
  PanelLoginMovieInit()
end
function RegisterEvent()
  registerEvent("FromClient_luaLoadCompleteLateUdpate", "InitLoginMoviePanel")
end
RegisterEvent()
