local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local _panel = Panel_BattleRoyalRank_Web
_panel:SetShow(false)
_panel:setGlassBackground(true)
_panel:ActiveMouseEventEffect(true)
_panel:RegisterShowEventFunc(true, "Panel_BattleRoyalRank_Web_ShowAni()")
_panel:RegisterShowEventFunc(false, "Panel_BattleRoyalRank_Web_HideAni()")
local isContentBattleRoyal = _ContentsGroup_RedDesert
local BattleRoyalRank_Web = {
  _ui = {
    stc_titleBG = UI.getChildControl(_panel, "Static_TitleBG"),
    btn_Close = nil
  },
  web = nil,
  webSizeX = 1100,
  webSizeY = 630
}
function Panel_BattleRoyalRank_Web_ShowAni()
  UIAni.fadeInSCR_Down(_panel)
  local aniInfo1 = _panel:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = _panel:GetSizeX() / 2
  aniInfo1.AxisY = _panel:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = _panel:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = _panel:GetSizeX() / 2
  aniInfo2.AxisY = _panel:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_BattleRoyalRank_Web_HideAni()
  _panel:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, _panel, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
function BattleRoyalRank_Web:init()
  if nil == self.web then
    self.web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, _panel, "WebControl_BattleRoyalRank_WebLink")
  end
  self.web:SetShow(true)
  self.web:SetPosY(50)
  self.web:SetHorizonCenter()
  self.web:SetSize(self.webSizeX, self.webSizeY)
  self.web:ResetUrl()
  self.web:ComputePos()
  self._ui.btn_Close = UI.getChildControl(self._ui.stc_titleBG, "Button_Win_Close")
  self:registerEventHandler()
end
function PaGlobal_BattleRoyalRank_Web_Initialize()
  local self = BattleRoyalRank_Web
  self:init()
end
function BattleRoyalRank_Web:registerEventHandler()
  self._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_BattleRoyalRank_WebClose()")
end
function PaGlobalFunc_BattleRoyalRank_Open()
  local self = BattleRoyalRank_Web
  self:open()
end
function BattleRoyalRank_Web:open()
  if not isContentBattleRoyal then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  if nil == temporaryWrapper then
    return
  end
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  local curChannelData = getCurrentChannelServerData()
  local userNo = selfPlayer:get():getUserNo()
  local certKey = selfPlayer:get():getWebAuthenticKeyCryptString()
  local userNickName = selfPlayer:getUserNickname()
  local classType = selfPlayer:getClassType()
  local isGM = ToClient_SelfPlayerIsGM()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local url = PaGlobal_URL_Check(worldNo)
  url = url .. "/BattleRoyal?userNo=" .. tostring(userNo)
  url = url .. "&userNickName=" .. tostring(userNickName)
  url = url .. "&certKey=" .. tostring(certKey)
  url = url .. "&classType=" .. tostring(classType)
  url = url .. "&isGM=" .. tostring(isGM)
  FGlobal_SetCandidate()
  self.web:SetSize(self.webSizeX, self.webSizeY)
  self.web:SetUrl(self.webSizeX, self.webSizeY, url, false, true)
  self.web:SetIME(true)
  _panel:SetPosX(getScreenSizeX() / 2 - _panel:GetSizeX() / 2)
  _panel:SetPosY(getScreenSizeY() / 2 - _panel:GetSizeY() / 2)
  _panel:SetShow(true, true)
end
function PaGlobal_BattleRoyalRank_WebClose()
  local self = BattleRoyalRank_Web
  self:close()
end
function BattleRoyalRank_Web:close()
  FGlobal_ClearCandidate()
  self.web:ResetUrl()
  ClearFocusEdit()
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  _panel:SetShow(false, false)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_BattleRoyalRank_Web_Initialize")
