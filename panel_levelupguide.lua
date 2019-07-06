local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
Panel_LevelupGuide:SetShow(false, false)
Panel_LevelupGuide:RegisterShowEventFunc(true, "LevelupGuideShowAni()")
Panel_LevelupGuide:RegisterShowEventFunc(false, "LevelupGuideHideAni()")
local levelupGuide = {
  levelupBG = UI.getChildControl(Panel_LevelupGuide, "Static_WebBG"),
  btnClose = UI.getChildControl(Panel_LevelupGuide, "Button_Close")
}
local _Web
local isLevelGuideUse = true
if isGameTypeKR2() then
  isLevelGuideUse = false
end
if isGameTypeGT() then
  isLevelGuideUse = false
end
function LevelupGuideShowAni()
  UIAni.fadeInSCR_Down(Panel_LevelupGuide)
  local aniInfo1 = Panel_LevelupGuide:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.2)
  aniInfo1.AxisX = Panel_LevelupGuide:GetSizeX() / 2
  aniInfo1.AxisY = Panel_LevelupGuide:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_LevelupGuide:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.2)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_LevelupGuide:GetSizeX() / 2
  aniInfo2.AxisY = Panel_LevelupGuide:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function LevelupGuideHideAni()
  local aniInfo1 = Panel_LevelupGuide:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
function LevelupGuide_Init()
  local self = levelupGuide
  _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, self.levelupBG, "WebControl_LevelupGuide_WebLink")
  _Web:SetShow(true)
  _Web:SetPosX(0)
  _Web:SetPosY(0)
  _Web:SetSize(890, 655)
  _Web:ResetUrl()
  self.btnClose:addInputEvent("Mouse_LUp", "HandleClicked_LevelupGuide_Close()")
  self.btnClose:SetShow(false)
end
LevelupGuide_Init()
function LevelupGuide_OpenCheck()
  if not isLevelGuideUse then
    return
  end
  if isFlushedUI() then
    return
  end
  local seflPlayer = getSelfPlayer()
  if nil == seflPlayer then
    HandleClicked_LevelupGuide_Close()
    return
  end
  local regionInfo = getRegionInfoByPosition(seflPlayer:get():getPosition())
  local isSafeZone = regionInfo:get():isSafeZone()
  if not isSafeZone then
    HandleClicked_LevelupGuide_Close()
    return
  end
  local inMyLevel = seflPlayer:get():getLevel()
  local tempWrapper = getTemporaryInformationWrapper()
  if tempWrapper:isEventBeforeShow() then
    if 50 == inMyLevel or 51 == inMyLevel or 52 == inMyLevel then
      FGlobal_LevelupGuide_Open()
    end
  else
    HandleClicked_LevelupGuide_Close()
  end
end
function LevelupGuide_LevelUpCheck()
  local seflPlayer = getSelfPlayer()
  if nil == seflPlayer then
    HandleClicked_LevelupGuide_Close()
    return
  end
  if isFlushedUI() then
    return
  end
  local regionInfo = getRegionInfoByPosition(seflPlayer:get():getPosition())
  local isSafeZone = regionInfo:get():isSafeZone()
  if not isSafeZone then
    HandleClicked_LevelupGuide_Close()
    return
  end
  local inMyLevel = seflPlayer:get():getLevel()
  if 50 ~= inMyLevel and 51 ~= inMyLevel and 52 ~= inMyLevel then
    return
  end
  FGlobal_LevelupGuide_Open(true)
end
function FGlobal_LevelupGuide_Open(isLevelUp)
  if true == _ContentsGroup_RenewUI then
    return
  end
  if not isLevelGuideUse then
    return
  end
  if isFlushedUI() then
    return
  end
  if nil ~= PaGlobalFunc_DailyStamp_GetShowPanel and true == PaGlobalFunc_DailyStamp_GetShowPanel() or nil ~= Panel_Window_DailyStamp_All and true == Panel_Window_DailyStamp_All:GetShow() and not isGameTypeEnglish() then
    FGlobal_LevelupGuide_PowerClose()
    return
  end
  local seflPlayer = getSelfPlayer()
  if nil == seflPlayer then
    HandleClicked_LevelupGuide_Close()
    return
  end
  local regionInfo = getRegionInfoByPosition(seflPlayer:get():getPosition())
  local isSafeZone = regionInfo:get():isSafeZone()
  if not isSafeZone then
    HandleClicked_LevelupGuide_Close()
    return
  end
  local inMyLevel = seflPlayer:get():getLevel()
  if 50 ~= inMyLevel and 51 ~= inMyLevel and 52 ~= inMyLevel then
    return
  end
  local _year = ToClient_GetThisYear()
  local _month = ToClient_GetThisMonth()
  local _day = ToClient_GetToday()
  local dayCheck = ToClient_getGameUIManagerWrapper():getLuaCacheDataListTime(__eLevelUpGuideDayCheck)
  if nil ~= dayCheck then
    local savedYear = dayCheck:GetYear()
    local savedMonth = dayCheck:GetMonth()
    local savedDay = dayCheck:GetDay()
    if _year == savedYear and _month == savedMonth and _day == savedDay and nil == isLevelUp then
      return
    end
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local url = PaGlobal_URL_Check(worldNo)
  url = url .. "/Guide?level=" .. inMyLevel
  Panel_LevelupGuide:SetShow(true, true)
  _Web:SetSize(890, 655)
  _Web:SetUrl(890, 655, url, false, true)
  _Web:SetIME(false)
end
function LevelupGuide_CheckForDay()
  local _year = ToClient_GetThisYear()
  local _month = ToClient_GetThisMonth()
  local _day = ToClient_GetToday()
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListTime(__eLevelUpGuideDayCheck, _year, _month, _day, 0, 0, 0, CppEnums.VariableStorageType.eVariableStorageType_User)
  Panel_LevelupGuide:SetShow(false, false)
end
function HandleClicked_LevelupGuide_Close()
  if not Panel_LevelupGuide:GetShow() then
    return
  end
  Panel_LevelupGuide:SetShow(false, false)
  _Web:ResetUrl()
end
function FGlobal_LevelupGuide_PowerClose()
  Panel_LevelupGuide:SetShow(false, false)
  _Web:ResetUrl()
end
if false == _ContentsGroup_RenewUI then
  LevelupGuide_OpenCheck()
  registerEvent("EventSelfPlayerLevelUp", "LevelupGuide_LevelUpCheck")
end
