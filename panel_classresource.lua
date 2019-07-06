local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
Panel_ClassResource:RegisterShowEventFunc(true, "ClassResource_ShowAni()")
Panel_ClassResource:RegisterShowEventFunc(false, "ClassResource_HideAni()")
local resourceText = UI.getChildControl(Panel_ClassResource, "StaticText_ResourceText")
local resourceValue = UI.getChildControl(Panel_ClassResource, "StaticText_Count")
local phantomPopMSG = UI.getChildControl(Panel_ClassResource, "StaticText_PhantomPopHelp")
Panel_ClassResource:addInputEvent("Mouse_On", "ClassResource_ChangeTexture_On()")
Panel_ClassResource:addInputEvent("Mouse_Out", "ClassResource_ChangeTexture_Off()")
local _phantomCount_Icon = UI.getChildControl(Panel_ClassResource, "Static_BlackStone")
local _phantomCount_HelpText_Box = UI.getChildControl(Panel_ClassResource, "StaticText_PhantomHelp")
local _phantom_Effect_1stChk = false
local _phantom_Effect_2ndChk = false
local _phantom_Effect_3rdChk = false
_phantomCount_Icon:addInputEvent("Mouse_On", "PhantomCount_HelpComment( true )")
_phantomCount_Icon:addInputEvent("Mouse_Out", "PhantomCount_HelpComment( false )")
local _fighterIcon = UI.getChildControl(Panel_ClassResource, "Static_FighterIcon")
local _fighterIcon_Point1 = UI.getChildControl(_fighterIcon, "Static_Point1")
local _fighterIcon_Point2 = UI.getChildControl(_fighterIcon, "Static_Point2")
local _fighterIcon_Point3 = UI.getChildControl(_fighterIcon, "Static_Point3")
_fighterIcon:addInputEvent("Mouse_On", "FighterIcon_HelpComment( true, 0 )")
_fighterIcon:addInputEvent("Mouse_Out", "FighterIcon_HelpComment( false )")
local _shyIcon = UI.getChildControl(Panel_ClassResource, "Static_ShyIcon")
local _shyIcon_Point1 = UI.getChildControl(_shyIcon, "Static_Point1")
local _shyIcon_Point2 = UI.getChildControl(_shyIcon, "Static_Point2")
local _shyIcon_Point3 = UI.getChildControl(_shyIcon, "Static_Point3")
_shyIcon:addInputEvent("Mouse_On", "FighterIcon_HelpComment( true, 1 )")
_shyIcon:addInputEvent("Mouse_Out", "FighterIcon_HelpComment( false )")
local isSorcerer = false
local isFighter = false
local isShy = false
local function init()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    PaGlobalFunc_ClassResource_SetShowControl(false)
    return
  end
  resourceValue:SetShow(false)
  _phantomCount_Icon:SetShow(false)
  _fighterIcon:SetShow(false)
  _shyIcon:SetShow(false)
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
  elseif __eClassType_ShyWaman == classType then
    Panel_ClassResource_SetShow(true)
    _shyIcon:SetShow(true)
    isShy = true
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
  _shyIcon:SetShow(false)
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
      if Panel_ClassResource:GetShow() == true then
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
    if Panel_ClassResource:GetShow() then
      _fighterIcon:SetShow(true)
    end
  elseif __eClassType_ShyWaman == classType then
    isShy = true
    Panel_ClassResource_SetShow(true)
    if 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved) then
      Panel_ClassResource_SetShow(ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
    end
    if Panel_ClassResource:GetShow() then
      _shyIcon:SetShow(true)
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
      if __eClassType_ShyWaman == classType then
        _shyIcon:SetShow(true)
      else
      end
    end
  elseif false == isShow then
    resourceValue:SetShow(false)
    _phantomCount_Icon:SetShow(false)
    _fighterIcon:SetShow(false)
    _shyIcon:SetShow(false)
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
    Panel_ClassResource:SetChildIndex(_phantomCount_HelpText_Box, 9999)
    _phantomCount_HelpText_Box:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    _phantomCount_HelpText_Box:SetAutoResize(true)
    _phantomCount_HelpText_Box:SetText(_phantomCount_Message)
    _phantomCount_HelpText_Box:SetPosX(getMousePosX() - Panel_ClassResource:GetPosX() - 70)
    _phantomCount_HelpText_Box:SetPosY(getMousePosY() - Panel_ClassResource:GetPosY() - 90)
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
function FighterIcon_HelpComment(isShow, isType)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local classType = selfPlayer:getClassType()
  if CppEnums.ClassType.ClassType_Combattant ~= classType and CppEnums.ClassType.ClassType_CombattantWomen ~= classType and __eClassType_ShyWaman ~= classType then
    return
  end
  if 0 == isType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_FIGHTERTITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_FIGHTER")
    control = _fighterIcon
    if CppEnums.ClassType.ClassType_CombattantWomen == classType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_FIGHTERTITLE")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_MYSTIC")
    end
  elseif 1 == isType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_SHY_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_SHY_DESC")
    control = _shyIcon
  end
  TooltipSimple_Show(control, name, desc)
end
function ClassResource_ChangeTexture_On()
  audioPostEvent_SystemUi(0, 10)
  Panel_ClassResource:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
  resourceText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PVPMODE_UI_MOVE"))
end
function ClassResource_ChangeTexture_Off()
  if Panel_UIControl:IsShow() then
    Panel_ClassResource:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
    resourceText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PVPMODE_UI"))
  else
    Panel_ClassResource:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
  end
end
function ClassResource_ShowAni()
  Panel_ClassResource:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
  local ClassResourceOpen_Alpha = Panel_ClassResource:addColorAnimation(0, 0.6, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ClassResourceOpen_Alpha:SetStartColor(UI_color.C_00FFFFFF)
  ClassResourceOpen_Alpha:SetEndColor(UI_color.C_FFFFFFFF)
  ClassResourceOpen_Alpha.IsChangeChild = true
end
function ClassResource_HideAni()
  Panel_ClassResource:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local ClassResourceClose_Alpha = Panel_ClassResource:addColorAnimation(0, 0.6, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ClassResourceClose_Alpha:SetStartColor(UI_color.C_FFFFFFFF)
  ClassResourceClose_Alpha:SetEndColor(UI_color.C_00FFFFFF)
  ClassResourceClose_Alpha.IsChangeChild = true
  ClassResourceClose_Alpha:SetHideAtEnd(true)
  ClassResourceClose_Alpha:SetDisableWhileAni(true)
end
local beforeFigherCount = -1
local beforeShyCount = -1
function ClassResource_Update()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local playerMp = selfPlayer:get():getMp()
  local playerMaxMp = selfPlayer:get():getMaxMp()
  local playerMpRate = playerMp / playerMaxMp * 100
  if true == isSorcerer then
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
  elseif true == isFighter then
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
      _fighterIcon:AddEffect("CO_Empty", false, 0, 0)
    end
    beforeFigherCount = fighterCount
  elseif true == isShy then
    local shyCount = selfPlayer:get():getSubResourcePoint()
    _shyIcon_Point1:SetShow(shyCount >= 10)
    _shyIcon_Point2:SetShow(shyCount >= 20)
    _shyIcon_Point3:SetShow(shyCount >= 30)
    if beforeShyCount < 10 then
      _shyIcon_Point1:EraseAllEffect()
      if _shyIcon_Point1:GetShow() then
        _shyIcon_Point1:AddEffect("fUI_PLW_Energy_01A", true, 0, 0)
      end
    end
    if beforeShyCount < 20 then
      _shyIcon_Point2:EraseAllEffect()
      if _shyIcon_Point2:GetShow() then
        _shyIcon_Point2:AddEffect("fUI_PLW_Energy_01B", true, 0, 0)
      end
    end
    if beforeShyCount < 30 then
      _shyIcon_Point3:EraseAllEffect()
      if _shyIcon_Point3:GetShow() then
        _shyIcon_Point1:EraseAllEffect()
        _shyIcon_Point2:EraseAllEffect()
        _shyIcon_Point3:AddEffect("fUI_PLW_Energy_01C", true, 0, 0)
      end
    end
    if 30 == beforeShyCount and 0 == shyCount then
      _shyIcon:AddEffect("fUI_PLW_Energy_01D", false, 0, 0)
    end
    beforeShyCount = shyCount
  end
end
function Panel_ClassResource_EnableSimpleUI()
  Panel_ClassResource_SetAlphaAllChild(Panel_MainStatus_User_Bar:GetAlpha())
end
function Panel_ClassResource_DisableSimpleUI()
  Panel_ClassResource_SetAlphaAllChild(1)
end
function Panel_ClassResource_UpdateSimpleUI(fDeltaTime)
  Panel_ClassResource_SetAlphaAllChild(Panel_MainStatus_User_Bar:GetAlpha())
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
  if Panel_ClassResource:GetRelativePosX() == -1 and Panel_ClassResource:GetRelativePosY() == -1 then
    local initPosX = Panel_MainStatus_User_Bar:GetPosX() + _phantomCount_Icon:GetSizeX() - 5
    local initPosY = Panel_MainStatus_User_Bar:GetPosY() - _phantomCount_Icon:GetSizeY() + 5
    Panel_ClassResource:SetPosX(initPosX)
    Panel_ClassResource:SetPosY(initPosY)
    changePositionBySever(Panel_ClassResource, CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, true, true, false)
    FGlobal_InitPanelRelativePos(Panel_ClassResource, initPosX, initPosY)
  elseif Panel_ClassResource:GetRelativePosX() == 0 and Panel_ClassResource:GetRelativePosY() == 0 then
    Panel_ClassResource:SetPosX(getScreenSizeX() / 2 - Panel_MainStatus_User_Bar:GetSizeX() / 2 + _phantomCount_Icon:GetSizeX() - 5)
    Panel_ClassResource:SetPosY(getScreenSizeY() - Panel_QuickSlot:GetSizeY() - Panel_MainStatus_User_Bar:GetSizeY() - _phantomCount_Icon:GetSizeY() + 5)
  else
    Panel_ClassResource:SetPosX(getScreenSizeX() * Panel_ClassResource:GetRelativePosX() - Panel_ClassResource:GetSizeX() / 2)
    Panel_ClassResource:SetPosY(getScreenSizeY() * Panel_ClassResource:GetRelativePosY() - Panel_ClassResource:GetSizeY() / 2)
  end
  if 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved) then
    Panel_ClassResource_SetShow(ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
  end
  ResizeInit()
end
function Phantom_Resize()
  if Panel_ClassResource:GetRelativePosX() == -1 and Panel_ClassResource:GetRelativePosY() == -1 then
    local initPosX = Panel_MainStatus_User_Bar:GetPosX() + _phantomCount_Icon:GetSizeX() - 5
    local initPosY = Panel_MainStatus_User_Bar:GetPosY() - _phantomCount_Icon:GetSizeY() + 5
    Panel_ClassResource:SetPosX(initPosX)
    Panel_ClassResource:SetPosY(initPosY)
    changePositionBySever(Panel_ClassResource, CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, true, true, false)
    FGlobal_InitPanelRelativePos(Panel_ClassResource, initPosX, initPosY)
  elseif Panel_ClassResource:GetRelativePosX() == 0 and Panel_ClassResource:GetRelativePosY() == 0 then
    Panel_ClassResource:SetPosX(getScreenSizeX() / 2 - Panel_MainStatus_User_Bar:GetSizeX() / 2 + _phantomCount_Icon:GetSizeX() - 5)
    Panel_ClassResource:SetPosY(getScreenSizeY() - Panel_QuickSlot:GetSizeY() - Panel_MainStatus_User_Bar:GetSizeY() - _phantomCount_Icon:GetSizeY() + 5)
  else
    Panel_ClassResource:SetPosX(getScreenSizeX() * Panel_ClassResource:GetRelativePosX() - Panel_ClassResource:GetSizeX() / 2)
    Panel_ClassResource:SetPosY(getScreenSizeY() * Panel_ClassResource:GetRelativePosY() - Panel_ClassResource:GetSizeY() / 2)
  end
  if 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved) then
    Panel_ClassResource_SetShow(ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
  end
  ResizeInit()
end
function Panel_ClassResource_ShowToggle()
  if Panel_ClassResource:IsShow() then
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
  if 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow) then
    isGetUIInfo = true
  else
    isGetUIInfo = false
  end
  Panel_ClassResource:SetShow(isShow and isGetUIInfo and not PaGlobalFunc_IsRemasterUIOption())
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_Phantom_Locate")
init()
Phantom_Locate()
registerEvent("subResourceChanged", "ClassResource_Update")
registerEvent("EventPlayerPvPAbleChanged", "Phantom_Locate")
registerEvent("onScreenResize", "Phantom_Resize")
Panel_ClassResource:addInputEvent("Mouse_LUp", "ResetPos_WidgetButton()")
