local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
Instance_ClassResource:RegisterShowEventFunc(true, "ClassResource_ShowAni()")
Instance_ClassResource:RegisterShowEventFunc(false, "ClassResource_HideAni()")
local resourceText = UI.getChildControl(Instance_ClassResource, "StaticText_ResourceText")
local resourceValue = UI.getChildControl(Instance_ClassResource, "StaticText_Count")
local phantomPopMSG = UI.getChildControl(Instance_ClassResource, "StaticText_PhantomPopHelp")
Instance_ClassResource:addInputEvent("Mouse_On", "ClassResource_ChangeTexture_On()")
Instance_ClassResource:addInputEvent("Mouse_Out", "ClassResource_ChangeTexture_Off()")
local _phantomCount_Icon = UI.getChildControl(Instance_ClassResource, "Static_BlackStone")
local _phantomCount_HelpText_Box = UI.getChildControl(Instance_ClassResource, "StaticText_PhantomHelp")
local _phantom_Effect_1stChk = false
local _phantom_Effect_2ndChk = false
local _phantom_Effect_3rdChk = false
_phantomCount_Icon:addInputEvent("Mouse_On", "PhantomCount_HelpComment( true )")
_phantomCount_Icon:addInputEvent("Mouse_Out", "PhantomCount_HelpComment( false )")
local _fighterIcon = UI.getChildControl(Instance_ClassResource, "Static_FighterIcon")
local _fighterIcon_Point1 = UI.getChildControl(_fighterIcon, "Static_Point1")
local _fighterIcon_Point2 = UI.getChildControl(_fighterIcon, "Static_Point2")
local _fighterIcon_Point3 = UI.getChildControl(_fighterIcon, "Static_Point3")
_fighterIcon:addInputEvent("Mouse_On", "FighterIcon_HelpComment( true )")
_fighterIcon:addInputEvent("Mouse_Out", "FighterIcon_HelpComment( false )")
local isSorcerer = false
local isFighter = false
local function init()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    PaGlobalFunc_ClassResource_SetShowControl(false)
    return
  end
  resourceValue:SetShow(false)
  _phantomCount_Icon:SetShow(false)
  _fighterIcon:SetShow(false)
  local classType = selfPlayer:getClassType()
  if CppEnums.ClassType.ClassType_Sorcerer == classType then
    isSorcerer = true
    local phantomCount = selfPlayer:get():getSubResourcePoint()
    Panel_ClassResource_SetShow(true)
    resourceValue:SetText("X " .. phantomCount)
    resourceValue:SetShow(true)
    _phantomCount_Icon:SetShow(true)
  elseif CppEnums.ClassType.ClassType_Combattant == classType or CppEnums.ClassType.ClassType_CombattantWomen == classType then
    Panel_ClassResource_SetShow(true)
    _fighterIcon:SetShow(true)
    isFighter = true
  else
    PaGlobalFunc_ClassResource_SetShowControl(false)
  end
end
local function ResizeInit()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    PaGlobalFunc_ClassResource_SetShowControl(false)
    return
  end
  resourceValue:SetShow(false)
  _phantomCount_Icon:SetShow(false)
  _fighterIcon:SetShow(false)
  local classType = selfPlayer:getClassType()
  if CppEnums.ClassType.ClassType_Sorcerer == classType then
    isSorcerer = true
    local phantomCount = selfPlayer:get():getSubResourcePoint()
    resourceValue:SetText("X " .. phantomCount)
    Panel_ClassResource_SetShow(true)
    resourceValue:SetShow(true)
    _phantomCount_Icon:SetShow(true)
    if 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved) then
      Panel_ClassResource_SetShow(ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
      if Instance_ClassResource:GetShow() == true then
        resourceValue:SetShow(true)
        _phantomCount_Icon:SetShow(true)
      else
        resourceValue:SetShow(false)
        _phantomCount_Icon:SetShow(false)
      end
    end
  elseif CppEnums.ClassType.ClassType_Combattant == classType or CppEnums.ClassType.ClassType_CombattantWomen == classType then
    isFighter = true
    Panel_ClassResource_SetShow(true)
    if 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved) then
      Panel_ClassResource_SetShow(ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
    end
    if Instance_ClassResource:GetShow() then
      _fighterIcon:SetShow(true)
    end
  else
    PaGlobalFunc_ClassResource_SetShowControl(false)
  end
end
function PaGlobalFunc_ClassResource_SetShowControl(isShow, isAni)
  if true == isShow then
    local selfPlayer = getSelfPlayer()
    if nil == selfPlayer then
      return
    end
    local classType = selfPlayer:getClassType()
    if CppEnums.ClassType.ClassType_Sorcerer == classType then
      resourceValue:SetShow(true)
      _phantomCount_Icon:SetShow(true)
    elseif CppEnums.ClassType.ClassType_Combattant == classType or CppEnums.ClassType.ClassType_CombattantWomen == classType then
      _fighterIcon:SetShow(true)
    else
      _PA_ASSERT(false, "\237\145\156\236\139\156\237\149\160 \236\167\129\236\151\133 \236\160\132\236\154\169 \236\158\144\236\155\144\236\157\180 \236\151\134\235\138\148 \236\167\129\236\151\133\236\158\133\235\139\136\235\139\164.")
    end
  elseif false == isShow then
    resourceValue:SetShow(false)
    _phantomCount_Icon:SetShow(false)
    _fighterIcon:SetShow(false)
  end
end
function PhantomCount_HelpComment(_isShowPhantomHelp)
  if _isShowPhantomHelp == true then
    local _phantomCount_Message = ""
    local selfPlayer = getSelfPlayer()
    if nil == selfPlayer then
      return
    end
    local classType = selfPlayer:getClassType()
    if CppEnums.ClassType.ClassType_Sorcerer == classType then
      _phantomCount_Message = PAGetString(Defines.StringSheet_GAME, "LUA_PHANTOMCOUNT_MESSAGE")
    elseif CppEnums.ClassType.ClassType_Combattant == classType or CppEnums.ClassType.ClassType_CombattantWomen == classType then
      _phantomCount_Message = PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_FIGHTER")
    end
    Instance_ClassResource:SetChildIndex(_phantomCount_HelpText_Box, 9999)
    _phantomCount_HelpText_Box:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    _phantomCount_HelpText_Box:SetAutoResize(true)
    _phantomCount_HelpText_Box:SetText(_phantomCount_Message)
    _phantomCount_HelpText_Box:SetPosX(getMousePosX() - Instance_ClassResource:GetPosX() - 70)
    _phantomCount_HelpText_Box:SetPosY(getMousePosY() - Instance_ClassResource:GetPosY() - 90)
    _phantomCount_HelpText_Box:ComputePos()
    _phantomCount_HelpText_Box:SetSize(_phantomCount_HelpText_Box:GetSizeX(), _phantomCount_HelpText_Box:GetSizeY())
    _phantomCount_HelpText_Box:SetAlpha(0)
    _phantomCount_HelpText_Box:SetFontAlpha(0)
    UIAni.AlphaAnimation(1, _phantomCount_HelpText_Box, 0, 0.2)
    _phantomCount_HelpText_Box:SetShow(true)
  else
    local aniInfo = UIAni.AlphaAnimation(0, _phantomCount_HelpText_Box, 0, 0.2)
    aniInfo:SetHideAtEnd(true)
  end
end
function FighterIcon_HelpComment(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local classType = selfPlayer:getClassType()
  if CppEnums.ClassType.ClassType_Combattant ~= classType and CppEnums.ClassType.ClassType_CombattantWomen ~= classType then
    return
  end
  local control = _fighterIcon
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_FIGHTERTITLE")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_FIGHTER")
  if CppEnums.ClassType.ClassType_CombattantWomen == classType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_FIGHTERTITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_MYSTIC")
  end
  TooltipSimple_Show(control, name, desc)
end
function ClassResource_ChangeTexture_On()
  audioPostEvent_SystemUi(0, 10)
  Instance_ClassResource:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
  resourceText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PVPMODE_UI_MOVE"))
end
function ClassResource_ChangeTexture_Off()
  if Panel_UIControl:IsShow() then
    Instance_ClassResource:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
    resourceText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PVPMODE_UI"))
  else
    Instance_ClassResource:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
  end
end
function ClassResource_ShowAni()
  Instance_ClassResource:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
  local ClassResourceOpen_Alpha = Instance_ClassResource:addColorAnimation(0, 0.6, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ClassResourceOpen_Alpha:SetStartColor(UI_color.C_00FFFFFF)
  ClassResourceOpen_Alpha:SetEndColor(UI_color.C_FFFFFFFF)
  ClassResourceOpen_Alpha.IsChangeChild = true
end
function ClassResource_HideAni()
  Instance_ClassResource:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local ClassResourceClose_Alpha = Instance_ClassResource:addColorAnimation(0, 0.6, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ClassResourceClose_Alpha:SetStartColor(UI_color.C_FFFFFFFF)
  ClassResourceClose_Alpha:SetEndColor(UI_color.C_00FFFFFF)
  ClassResourceClose_Alpha.IsChangeChild = true
  ClassResourceClose_Alpha:SetHideAtEnd(true)
  ClassResourceClose_Alpha:SetDisableWhileAni(true)
end
local beforeFigherCount = -1
function ClassResource_Update()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local playerMp = selfPlayer:get():getMp()
  local playerMaxMp = selfPlayer:get():getMaxMp()
  local playerMpRate = playerMp / playerMaxMp * 100
  if isSorcerer then
    local phantomCount = selfPlayer:get():getSubResourcePoint()
    resourceValue:SetText("X " .. phantomCount)
    if phantomCount >= 10 and phantomCount <= 19 and _phantom_Effect_1stChk == false then
      _phantomCount_Icon:EraseAllEffect()
      _phantomCount_Icon:AddEffect("UI_Button_Hide", false, 0, 0)
      _phantom_Effect_1stChk = true
      _phantom_Effect_2ndChk = false
      _phantom_Effect_3rdChk = false
    elseif phantomCount >= 20 and phantomCount <= 29 and _phantom_Effect_2ndChk == false then
      _phantomCount_Icon:EraseAllEffect()
      _phantomCount_Icon:AddEffect("UI_Button_Hide", false, 0, 0)
      _phantom_Effect_1stChk = false
      _phantom_Effect_2ndChk = true
      _phantom_Effect_3rdChk = false
    elseif phantomCount == 30 and _phantom_Effect_3rdChk == false then
      _phantomCount_Icon:EraseAllEffect()
      _phantomCount_Icon:AddEffect("UI_Button_Hide", false, 0, 0)
      _phantom_Effect_1stChk = false
      _phantom_Effect_2ndChk = false
      _phantom_Effect_3rdChk = true
    elseif phantomCount == 0 then
      _phantomCount_Icon:EraseAllEffect()
      _phantom_Effect_1stChk = false
      _phantom_Effect_2ndChk = false
      _phantom_Effect_3rdChk = false
    end
    if phantomCount >= 10 and playerMpRate < 20 then
      phantomPopMSG:SetShow(true)
      phantomPopMSG:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_PHANTOMPOPMSG"))
    else
      phantomPopMSG:SetShow(false)
    end
  elseif isFighter then
    local fighterCount = selfPlayer:get():getSubResourcePoint()
    _fighterIcon_Point1:SetShow(fighterCount >= 10)
    _fighterIcon_Point2:SetShow(fighterCount >= 20)
    _fighterIcon_Point3:SetShow(fighterCount >= 30)
    if beforeFigherCount < 10 then
      _fighterIcon_Point3:EraseAllEffect()
      if _fighterIcon_Point1:GetShow() then
        _fighterIcon_Point1:AddEffect("fUI_PCM_Energy_01A", false, 0, 0)
      end
    elseif beforeFigherCount < 20 then
      _fighterIcon_Point2:EraseAllEffect()
      if _fighterIcon_Point2:GetShow() then
        _fighterIcon_Point2:AddEffect("fUI_PCM_Energy_01A", false, 0, 0)
      end
    elseif beforeFigherCount < 30 then
      _fighterIcon_Point1:EraseAllEffect()
      if _fighterIcon_Point3:GetShow() then
        _fighterIcon_Point3:AddEffect("fUI_PCM_Energy_01A", false, 0, 0)
        _fighterIcon_Point3:AddEffect("fUI_PCM_Energy_02A", false, -15, -8)
        _fighterIcon_Point3:AddEffect("fUI_PCM_Energy_02B", true, -15, -8)
      end
    end
    if beforeFigherCount < 30 and 30 == fighterCount then
      _fighterIcon_Point1:AddEffect("fUI_PCM_Energy_01A", false, 0, 0)
      _fighterIcon_Point2:AddEffect("fUI_PCM_Energy_01A", false, 0, 0)
      _fighterIcon_Point3:AddEffect("fUI_PCM_Energy_01A", false, 0, 0)
      _fighterIcon_Point3:AddEffect("fUI_PCM_Energy_02A", false, -15, -8)
      _fighterIcon_Point3:AddEffect("fUI_PCM_Energy_02B", true, -15, -8)
    end
    if 30 == beforeFigherCount and 0 == fighterCount then
      _fighterIcon:AddEffect("fUI_PCM_Energy_02C", false, 0, 0)
    end
    beforeFigherCount = fighterCount
  end
end
function Panel_ClassResource_EnableSimpleUI()
  Panel_ClassResource_SetAlphaAllChild(Instance_Widget_MainStatus_User_Bar:GetAlpha())
end
function Panel_ClassResource_DisableSimpleUI()
  Panel_ClassResource_SetAlphaAllChild(1)
end
function Panel_ClassResource_UpdateSimpleUI(fDeltaTime)
  Panel_ClassResource_SetAlphaAllChild(Instance_Widget_MainStatus_User_Bar:GetAlpha())
end
function Panel_ClassResource_SetAlphaAllChild(alphaValue)
  resourceText:SetFontAlpha(alphaValue)
  resourceValue:SetFontAlpha(alphaValue)
  _phantomCount_Icon:SetAlpha(alphaValue)
  _phantomCount_HelpText_Box:SetAlpha(alphaValue)
end
registerEvent("SimpleUI_UpdatePerFrame", "Panel_ClassResource_UpdateSimpleUI")
registerEvent("EventSimpleUIEnable", "Panel_ClassResource_EnableSimpleUI")
registerEvent("EventSimpleUIDisable", "Panel_ClassResource_DisableSimpleUI")
registerEvent("FromClient_SelfPlayerMpChanged", "ClassResource_Update")
function Phantom_Locate()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local initPosX = Instance_Widget_MainStatus_User_Bar:GetPosX() + _phantomCount_Icon:GetSizeX() - 5
  local initPosY = Instance_Widget_MainStatus_User_Bar:GetPosY() - _phantomCount_Icon:GetSizeY() + 5
  Instance_ClassResource:SetPosX(initPosX)
  Instance_ClassResource:SetPosY(initPosY)
  ResizeInit()
end
function Phantom_Resize()
  local initPosX = Instance_Widget_MainStatus_User_Bar:GetPosX() + _phantomCount_Icon:GetSizeX() - 5
  local initPosY = Instance_Widget_MainStatus_User_Bar:GetPosY() - _phantomCount_Icon:GetSizeY() + 5
  Instance_ClassResource:SetPosX(initPosX)
  Instance_ClassResource:SetPosY(initPosY)
  ResizeInit()
end
function Panel_ClassResource_ShowToggle()
  if Instance_ClassResource:IsShow() then
    Panel_ClassResource_SetShow(false)
  else
    Panel_ClassResource_SetShow(true)
  end
end
function renderModeChange_Phantom_Locate(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  Phantom_Locate()
end
function Panel_ClassResource_SetShow(isShow, isAni)
  local isGetUIInfo = false
  Instance_ClassResource:SetShow(false)
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_Phantom_Locate")
init()
Phantom_Locate()
registerEvent("subResourceChanged", "ClassResource_Update")
registerEvent("EventPlayerPvPAbleChanged", "Phantom_Locate")
registerEvent("onScreenResize", "Phantom_Resize")
Instance_ClassResource:addInputEvent("Mouse_LUp", "ResetPos_WidgetButton()")
