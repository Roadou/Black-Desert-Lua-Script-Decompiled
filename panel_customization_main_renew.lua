local _panel = Panel_Customizing
local HideAlbumAndPopular = true
local CustomizationMain = {
  _ui = {
    _static_MainMenuBg = UI.getChildControl(_panel, "Static_MainMenu"),
    _static_SubMenuBg = UI.getChildControl(_panel, "Static_SubMenu"),
    _static_SubTitle = UI.getChildControl(_panel, "Radiobutton_SubTitle"),
    _static_KeyGuideBg = UI.getChildControl(_panel, "Static_KeyGuideBg"),
    _static_ZodiacBg = UI.getChildControl(_panel, "Static_ZodiacBg"),
    _mainMenu = {},
    _ingameMainMenu = {},
    _currentMainMenu = {},
    _subMenu = {},
    _leafMune = {}
  },
  _config = {
    _CustomizingMaxSubTree = 4,
    _ActionMaxSubTree = 2,
    _maxLeafTree = 20,
    _common = 0,
    _camera = 1,
    _beautyAlbum = 2,
    _bone = 3,
    _boneCamera = 4,
    _boneSlideFocus = 5,
    _slideFocus = 6,
    _subPanel = 7
  },
  _mainMenuConfig = {
    _Customizing = 0,
    _Zodiac = 1,
    _Action = 2,
    _BeautyAlbum = 3,
    _popular = 4,
    _max = 5
  },
  _mainInGameMenuConfig = {
    _Customizing = 0,
    _Action = 1,
    _BeautyAlbum = 2,
    _popular = 3,
    _max = 4
  },
  _strCustomizingConfig = {
    [0] = PAGetString(Defines.StringSheet_RESOURCE, "UI_CUSTOMIZATION_MAIN_HAIR"),
    [1] = PAGetString(Defines.StringSheet_RESOURCE, "UI_CUSTOMIZATION_MAIN_FACE"),
    [2] = PAGetString(Defines.StringSheet_RESOURCE, "UI_CUSTOMIZATION_MAIN_FORM"),
    [3] = PAGetString(Defines.StringSheet_RESOURCE, "UI_CUSTOMIZATION_MAIN_VOICE")
  },
  _strActionConfig = {
    [0] = PAGetString(Defines.StringSheet_RESOURCE, "UI_CUSTOMIZATION_MAIN_LOOK"),
    [1] = PAGetString(Defines.StringSheet_RESOURCE, "UI_CUSTOMIZATION_MAIN_COSTUME")
  },
  _keyGuideTexture = "renewal/ui_icon/console_xboxkey_00.dds",
  _keyGuideTextureConfig = {
    _LS = 0,
    _RSUpDown = 1,
    _RSLeftRight = 2,
    _LT = 3,
    _A = 4,
    _X = 5,
    _Y = 6,
    _LB = 7,
    _RB = 8,
    _Plus = 9,
    _OR = 10,
    _DPad = 11,
    _RS = 12,
    _B = 13,
    _RSClick = 14,
    _count = 15
  },
  _keyGuideUV = {
    [0] = {
      x1 = 136,
      y1 = 46,
      x2 = 180,
      y2 = 90
    },
    [1] = {
      x1 = 46,
      y1 = 136,
      x2 = 90,
      y2 = 180
    },
    [2] = {
      x1 = 1,
      y1 = 136,
      x2 = 45,
      y2 = 180
    },
    [3] = {
      x1 = 46,
      y1 = 181,
      x2 = 90,
      y2 = 225
    },
    [4] = {
      x1 = 1,
      y1 = 1,
      x2 = 45,
      y2 = 45
    },
    [5] = {
      x1 = 136,
      y1 = 1,
      x2 = 180,
      y2 = 45
    },
    [6] = {
      x1 = 46,
      y1 = 1,
      x2 = 90,
      y2 = 45
    },
    [7] = {
      x1 = 91,
      y1 = 136,
      x2 = 135,
      y2 = 180
    },
    [8] = {
      x1 = 136,
      y1 = 136,
      x2 = 180,
      y2 = 180
    },
    [9] = {
      x1 = 91,
      y1 = 181,
      x2 = 103,
      y2 = 225
    },
    [10] = {
      x1 = 104,
      y1 = 181,
      x2 = 116,
      y2 = 225
    },
    [11] = {
      x1 = 181,
      y1 = 181,
      x2 = 225,
      y2 = 225
    },
    [12] = {
      x1 = 91,
      y1 = 46,
      x2 = 135,
      y2 = 90
    },
    [13] = {
      x1 = 91,
      y1 = 1,
      x2 = 135,
      y2 = 45
    },
    [14] = {
      x1 = 46,
      y1 = 91,
      x2 = 90,
      y2 = 135
    }
  },
  _keyGuideTextureList = {},
  _keyGuideStringList = {},
  _KeyGuideTable = {},
  _currentMainIndex = -1,
  _currentSubIndex = -1,
  _currentLeafIndex = -1,
  _currentDepth = 0,
  _focusMenuPosX,
  _focusMenuPosY,
  _currentClassType,
  _isOtherPanelOpen = false,
  _currentPanelCloseFunc = nil,
  _currentPanelOpenFunc = nil,
  _currentZodiacIndex = -1,
  _currentWeatherIndex = 1,
  _weatherTypeCount = nil,
  _isInGame = false,
  _currentKeyGuideCount = 0,
  _keyGuideStartPosX = 0,
  _currentKeyGuideIndex = -1,
  _isCameraMode = false,
  _keyGuidesText = {
    _strCameramode = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLMODE_KEYGUIDE_OBJECT_CHANGE_CAMMODE"),
    _strClose = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INGAMECASHSHOP_NEWCART_BTN_CLOSE"),
    _strBack = PAGetString(Defines.StringSheet_RESOURCE, "FILEEXPLORER_BTN_BACK"),
    _strSelect = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_DIALOG_MAIN_SELECT"),
    _strCamera = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_COMMON_KEYGUIDE_CAMERA"),
    _strZoom = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_COMMON_KEYGUIDE_ZOOM"),
    _strWeather = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SUNICON")
  }
}
function CustomizationMain:FindOpenPanel()
  if true == PaGlobalFunc_Customization_HairShape_GetShow() then
    if true == PaGlobalFunc_Customization_HairShape_IsBone() then
      return nil
    else
      return PaGlobalFunc_Customization_HairShape_GetPanel()
    end
  end
  if true == PaGlobalFunc_Customization_FaceBone_GetShow() then
    return nil
  end
  if true == PaGlobalFunc_Customization_BodyBone_GetShow() then
    return nil
  end
  if true == PaGlobalFunc_Customization_BodyPose_GetShow() then
    return nil
  end
  if true == PaGlobalFunc_CustomizingKeyGuide_GetShow() then
    return nil
  end
  if true == PaGlobalFunc_Customization_Deco_GetShow() then
    return PaGlobalFunc_Customization_Deco_GetPanel()
  end
  if true == PaGlobalFunc_Customization_Mesh_GetShow() then
    return PaGlobalFunc_Customization_Mesh_GetPanel()
  end
  if true == PaGlobalFunc_Customization_Skin_GetShow() then
    return PaGlobalFunc_Customization_Skin_GetPanel()
  end
  if true == PaGlobalFunc_Customization_ShowCloth_GetShow() then
    return PaGlobalFunc_Customization_ShowCloth_GetPanel()
  end
  if true == PaGlobalFunc_Customization_ShowPose_GetShow() then
    return PaGlobalFunc_Customization_ShowPose_GetPanel()
  end
  if true == PaGlobalFunc_Customization_Voice_GetShow() then
    return PaGlobalFunc_Customization_Voice_GetPanel()
  end
  return Panel_Customizing
end
function CustomizationMain:SetCameraMode()
  local prevPanel = self:FindOpenPanel()
  self._prevPanel = prevPanel
  if nil ~= self._prevPanel then
    self._prevPanel:ignorePadSnapUpdate(true)
    PaGlobalFunc_Customization_SetKeyGuide(1)
    self._isCameraMode = true
    if 0 == self._currentDepth then
      self:SetPadXButton(false)
    end
  end
end
function CustomizationMain:UnSetCameraMode()
  if Panel_Customizing == self._prevPanel then
    PaGlobalFunc_Customization_SetKeyGuide(0)
  else
    PaGlobalFunc_Customization_SetKeyGuide(7)
  end
  if nil ~= self._prevPanel then
    self._prevPanel:ignorePadSnapUpdate(false)
    self._prevPanel = nil
  end
  if 0 == self._currentDepth then
    self:SetPadXButton(true)
  end
  self._isCameraMode = false
end
function PaGlobalFunc_Customization_CameraModeToggle()
  local self = CustomizationMain
  if true == self._isCameraMode then
    self:UnSetCameraMode()
  else
    self:SetCameraMode()
  end
end
function CustomizationMain:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
  self:InitKeyGuide()
  self._isInGame = false
end
function FGlobal_Customization_UiShow()
  PaGlobalFunc_Customization_SetShow(true, false)
end
function FGlobal_Customization_UiClose()
  PaGlobalFunc_Customization_SetShow(false, false)
end
function isShowCustomizationMain()
  return PaGlobalFunc_Customization_GetShow()
end
function PaGlobalFunc_Customization_IsInGame()
  local self = CustomizationMain
  return self._isInGame
end
function PaGlobalFunc_Customization_SetCloseFunc(func)
  local self = CustomizationMain
  self._currentPanelCloseFunc = func
end
function PaGlobalFunc_Customization_SetHideFunc(func)
  local self = CustomizationMain
  self._currentPanelHideFunc = func
end
function PaGlobalFunc_Customization_SetClassType(index)
  local self = CustomizationMain
  self._currentClassType = index
end
function PaGlobalFunc_Customization_GetLeafTree()
  local self = CustomizationMain
  self:LeafMenuClose()
  return self._ui._leafMune
end
function PaGlobalFunc_Customization_ClickedZodiac(index)
  local self = CustomizationMain
  local zodiacInfo = getZodiac(index)
  local zodiacName = zodiacInfo:getZodiacName()
  if zodiacName ~= nil then
    self._ui._staticText_ZodiacTitle:SetText(zodiacName)
  end
  local zodiacDescription = zodiacInfo:getZodiacDescription()
  if zodiacDescription ~= nil then
    self._ui._staticText_ZodiacDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui._staticText_ZodiacDesc:SetText(zodiacDescription)
  end
  local zodiacImagePath = zodiacInfo:getZodiacImagePath()
  if zodiacImagePath ~= nil then
    self._ui._static_ZodiacImage:ChangeTextureInfoName(zodiacImagePath)
    self._ui._static_ZodiacImage:getBaseTexture():setUV(0, 0, 1, 1)
    self._ui._static_ZodiacImage:setRenderTexture(self._ui._static_ZodiacImage:getBaseTexture())
  end
  local zodiacKey = zodiacInfo:getZodiacKey()
  applyZodiac(zodiacKey)
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  self._currentZodiacIndex = index
end
function PaGlobalFunc_Customization_ClickedCustomizing(index)
  local self = CustomizationMain
  self._currentSubIndex = index
  if 3 == index then
    PaGlobalFunc_Customization_Voice_CreateVoiceList(false, self._currentClassType)
    closeExplorer()
    return
  end
  self._currentDepth = 2
  self:MainMenuClose()
  self:SubMenuClose(self._currentMainIndex)
  self:SetSubTitlePos()
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  selectCustomizationControlGroup(index)
  closeExplorer()
end
function PaGlobalFunc_Customization_ClickedAction(index)
  local self = CustomizationMain
  self._currentSubIndex = index
  selectPoseControl(index + 1)
  _AudioPostEvent_SystemUiForXBOX(50, 1)
end
function PaGlobalFunc_Customization_RandomBeautyComfirm()
  local self = CustomizationMain
  self._ui._web_RandomBeauty:SetIgnore(true)
  self._ui._web_RandomBeauty:SetPosX(-1500)
  self._ui._web_RandomBeauty:SetPosY(-1500)
  self._ui._web_RandomBeauty:SetSize(1, 1)
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local url = PaGlobal_URL_Check(worldNo)
  local userNo = 0
  local userNickName = ""
  local cryptKey = getSelfPlayer():get():getWebAuthenticKeyCryptString()
  local classType = getSelfPlayer():getClassType()
  local isGm = ToClient_SelfPlayerIsGM()
  if ToClient_isLobbyProcessor() then
    userNickName = getFamilyName()
    userNo = getUserNoByLobby()
  else
    userNickName = getSelfPlayer():getUserNickname()
    userNo = getSelfPlayer():get():getUserNo()
  end
  url = url .. "/customizing?userNo=" .. tostring(userNo) .. "&userNickname=" .. tostring(userNickName) .. "&certKey=" .. tostring(cryptKey) .. "&classType=" .. tostring(classType) .. "&isCustomizationMode=" .. tostring(true) .. "&isGm=" .. tostring(isGm) .. "&isRandom=" .. tostring(true)
  self._ui._web_RandomBeauty:SetUrl(1, 1, url, false, true)
  self._ui._mainMenu[4]:SetCheck(false)
  _AudioPostEvent_SystemUiForXBOX(50, 1)
end
function PaGlobalFunc_Customization_RandomBeautyCancel()
  local self = CustomizationMain
  self._ui._mainMenu[4]:SetCheck(false)
  _AudioPostEvent_SystemUiForXBOX(50, 3)
end
function PaGlobalFunc_Customization_RandomBeauty()
  if ToClient_isUserCreateContentsAllowed() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MAIN_RANDOMBEAUTY_MSG")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = PaGlobalFunc_Customization_RandomBeautyComfirm,
      functionNo = PaGlobalFunc_Customization_RandomBeautyCancel,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = PaGlobalFunc_Customization_RandomBeautyCancel,
      functionNo = PaGlobalFunc_Customization_RandomBeautyCancel,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    ToClient_showPrivilegeError()
  end
end
function PaGlobalFunc_Customization_ClickedMainMenu(index)
  local self = CustomizationMain
  if 3 == index and true == _ContentsGroup_RenewUI_BeautyAlbum then
    PaGlobalFunc_Customization_SetKeyGuide(2)
    self:SetPadXButton(false)
    FGlobal_CustomizingAlbum_Show(true, CppEnums.ClientSceneState.eClientSceneStateType_Customization)
    return
  end
  if 4 == index and true == _ContentsGroup_RenewUI_BeautyAlbum then
    PaGlobalFunc_Customization_RandomBeauty()
    return
  end
  self:MainMenuClose()
  self:SubMenuOpen(index)
  self._currentMainIndex = index
  self._currentDepth = 1
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  self:SetPadXButton(false)
end
function CustomizationMain:SetPadXButton(isShow)
  self._ui._button_Apply:SetShow(isShow)
  if true == isShow then
    if true == PaGlobalFunc_Customization_IsInGame() then
      Panel_Customizing:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_Customization_CashCustomization_Apply()")
    else
      Panel_Customizing:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_Customization_CreateCharacter()")
    end
    self._KeyGuideTable[0]._bg:SetPosX(10 - (getScreenSizeX() - self._ui._button_Apply:GetPosX()))
  else
    Panel_Customizing:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
    self._KeyGuideTable[0]._bg:SetPosX(0)
  end
end
function CustomizationMain:MainMenuOpen()
  self._ui._static_ZodiacBg:SetShow(false)
  for index, mainButton in pairs(self._ui._currentMainMenu) do
    mainButton:SetShow(true)
    mainButton:SetCheck(false)
    mainButton:SetIgnore(false)
    mainButton:SetPosX(self._focusMenuPosX)
    mainButton:SetPosY(self._focusMenuPosY + (mainButton:GetSizeY() + 30) * index)
    if true == HideAlbumAndPopular then
      if true == PaGlobalFunc_Customization_IsInGame() then
        if index == self._mainInGameMenuConfig._BeautyAlbum and false == _ContentsGroup_RenewUI_BeautyAlbum then
          mainButton:SetShow(false)
        end
        if index == self._mainInGameMenuConfig._popular then
          mainButton:SetShow(false)
        end
      else
        if index == self._mainMenuConfig._BeautyAlbum and false == _ContentsGroup_RenewUI_BeautyAlbum then
          mainButton:SetShow(false)
        end
        if index == self._mainMenuConfig._popular then
          mainButton:SetShow(false)
        end
      end
    end
  end
  self._currentDepth = 0
  self:SetPadXButton(true)
  PaGlobalFunc_Customization_SetKeyGuide(0)
end
function CustomizationMain:MainMenuClose()
  for index, mainButton in pairs(self._ui._currentMainMenu) do
    mainButton:SetShow(false)
  end
end
function PaGlobalFunc_Customization_UpdatePerFrame(deltaTime)
  local self = CustomizationMain
  if true == FGlobal_CustomizingAlbum_GetShow() then
    return
  end
  if true == isPadUp(__eJoyPadInputType_RightThumb) then
    PaGlobalFunc_Customization_CameraModeToggle()
  end
  if true == self._isCameraMode then
    PaGlobalFunc_Customization_SetKeyGuide(1)
  end
end
function CustomizationMain:InitControl()
  Panel_Customizing:RegisterUpdateFunc("PaGlobalFunc_Customization_UpdatePerFrame")
  self._ui._static_SubTitle:SetShow(false)
  self._ui._staticText_ZodiacTitle = UI.getChildControl(self._ui._static_ZodiacBg, "StaticText_StarTitle")
  self._ui._staticText_ZodiacDesc = UI.getChildControl(self._ui._static_ZodiacBg, "StaticText_StarDesc")
  self._ui._static_ZodiacImage = UI.getChildControl(self._ui._static_ZodiacBg, "Static_ZodiacImage")
  self._ui._static_ZodiacBg:SetShow(false)
  self._ui._mainMenu[self._mainMenuConfig._Customizing] = UI.getChildControl(self._ui._static_MainMenuBg, "RadioButton_MainMenu_Customizing")
  self._ui._mainMenu[self._mainMenuConfig._Zodiac] = UI.getChildControl(self._ui._static_MainMenuBg, "RadioButton_MainMenu_Zodiac")
  self._ui._mainMenu[self._mainMenuConfig._Action] = UI.getChildControl(self._ui._static_MainMenuBg, "RadioButton_MainMenu_Action")
  self._ui._mainMenu[self._mainMenuConfig._BeautyAlbum] = UI.getChildControl(self._ui._static_MainMenuBg, "RadioButton_MainMenu_BeautyAlbum")
  self._ui._mainMenu[self._mainMenuConfig._popular] = UI.getChildControl(self._ui._static_MainMenuBg, "RadioButton_MainMenu_Popular")
  self._ui._mainMenu[self._mainMenuConfig._Customizing]:SetShow(false)
  self._ui._mainMenu[self._mainMenuConfig._Zodiac]:SetShow(false)
  self._ui._mainMenu[self._mainMenuConfig._Action]:SetShow(false)
  self._ui._mainMenu[self._mainMenuConfig._BeautyAlbum]:SetShow(false)
  self._ui._mainMenu[self._mainMenuConfig._popular]:SetShow(false)
  self._ui._ingameMainMenu[self._mainInGameMenuConfig._Customizing] = self._ui._mainMenu[self._mainMenuConfig._Customizing]
  self._ui._ingameMainMenu[self._mainInGameMenuConfig._Action] = self._ui._mainMenu[self._mainMenuConfig._Action]
  self._ui._ingameMainMenu[self._mainInGameMenuConfig._BeautyAlbum] = self._ui._mainMenu[self._mainMenuConfig._BeautyAlbum]
  self._ui._ingameMainMenu[self._mainInGameMenuConfig._popular] = self._ui._mainMenu[self._mainMenuConfig._popular]
  self._focusMenuPosX = self._ui._mainMenu[self._mainMenuConfig._Customizing]:GetPosX()
  self._focusMenuPosY = self._ui._mainMenu[self._mainMenuConfig._Customizing]:GetPosY()
  self._ui._static_BottomBg = UI.getChildControl(self._ui._static_KeyGuideBg, "Static_BottomBg")
  self._ui._button_Apply = UI.getChildControl(self._ui._static_BottomBg, "Button_CharacterCreate")
  self._ui._button_KeyGuideTemplete = UI.getChildControl(self._ui._static_BottomBg, "Button_KeyGuideTemplete")
  self._ui._staticText_KeyGuideTemplete = UI.getChildControl(self._ui._static_BottomBg, "StaticText_KeyGuideTemplete")
  self._ui._button_KeyGuideTemplete:SetShow(false)
  self._ui._staticText_KeyGuideTemplete:SetShow(false)
  self._ui._subMenuTemplate = UI.getChildControl(self._ui._static_SubMenuBg, "RadioButton_SubMenu_Template")
  self._ui._subMenuTemplate:SetShow(false)
  self._ui._leafMenuTemplate = UI.getChildControl(self._ui._static_SubMenuBg, "RadioButton_ItemTemplate")
  self._ui._leafMenuTemplate:SetShow(false)
  self._ui._subMenu[self._mainMenuConfig._Customizing] = {}
  for index = 0, self._config._CustomizingMaxSubTree - 1 do
    local control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_SubMenuBg, "radioButton_Customizing_" .. index)
    CopyBaseProperty(self._ui._subMenuTemplate, control)
    control:SetText(self._strCustomizingConfig[index])
    control:SetShow(false)
    control:SetPosX(self._focusMenuPosX)
    control:SetPosY(self._focusMenuPosY + (control:GetSizeY() + 30) * (index + 1))
    self._ui._subMenu[self._mainMenuConfig._Customizing][index] = control
  end
  self._ui._subMenu[self._mainMenuConfig._Zodiac] = {}
  local count = getZodiacCount()
  for index = 0, count - 1 do
    local control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_SubMenuBg, "radioButton_Zodiac_" .. index)
    CopyBaseProperty(self._ui._subMenuTemplate, control)
    control:SetPosY(control:GetPosY() + (control:GetSizeY() + 30) * index)
    local zodiacInfo = getZodiac(index)
    local zodiacName = zodiacInfo:getZodiacName()
    control:SetText(zodiacName)
    control:SetShow(false)
    control:SetPosX(self._focusMenuPosX)
    control:SetPosY(self._focusMenuPosY + (control:GetSizeY() + 30) * (index + 1))
    self._ui._subMenu[self._mainMenuConfig._Zodiac][index] = control
  end
  self._ui._subMenu[self._mainMenuConfig._Action] = {}
  for index = 0, self._config._ActionMaxSubTree - 1 do
    local control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_SubMenuBg, "radioButton_Action_" .. index)
    CopyBaseProperty(self._ui._subMenuTemplate, control)
    control:SetPosX(self._focusMenuPosX)
    control:SetPosY(self._focusMenuPosY + (control:GetSizeY() + 30) * (index + 1))
    control:SetText(self._strActionConfig[index])
    control:SetShow(false)
    self._ui._subMenu[self._mainMenuConfig._Action][index] = control
  end
  for index = 0, self._config._maxLeafTree - 1 do
    local control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_SubMenuBg, "leafButton_" .. index)
    CopyBaseProperty(self._ui._leafMenuTemplate, control)
    control:SetPosX(self._focusMenuPosX)
    control:SetPosY(self._focusMenuPosY + (control:GetSizeY() + 30) * (index + 1))
    control:SetShow(false)
    self._ui._leafMune[index] = control
  end
  self._ui._web_RandomBeauty = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Customizing, "WebControl_RandomCustomization_Renew")
end
function PaGlobalFunc_Customization_SetKeyGuide(state)
  local self = CustomizationMain
  if self._currentKeyGuideIndex == state then
    return
  end
  for index, keyTable in pairs(self._KeyGuideTable) do
    if nil ~= keyTable then
      keyTable._bg:SetShow(state == index)
    end
  end
  self._currentKeyGuideIndex = state
end
function CustomizationMain:MakeKeyGuide(state)
  local keyGuideTableTemplete = {}
  keyGuideTableTemplete = {
    _iconList = {},
    _str,
    _bg
  }
  self._currentKeyGuideCount = 0
  local keyText = self._keyGuidesText
  keyGuideTableTemplete._bg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._static_KeyGuideBg, "Static_Custom_bottomBg_" .. #self._KeyGuideTable)
  CopyBaseProperty(self._ui._static_BottomBg, keyGuideTableTemplete._bg)
  keyGuideTableTemplete._bg:SetShow(false)
  if self._config._common == state then
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._B
    }, keyText._strBack)
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._A
    }, keyText._strSelect)
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._RSClick
    }, keyText._strCameramode)
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._LT,
      self._keyGuideTextureConfig._Plus,
      self._keyGuideTextureConfig._Y
    }, keyText._strWeather)
  elseif self._config._camera == state then
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._B,
      self._keyGuideTextureConfig._OR,
      self._keyGuideTextureConfig._RSClick
    }, keyText._strCameramode)
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._RS
    }, keyText._strCamera)
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._LT,
      self._keyGuideTextureConfig._Plus,
      self._keyGuideTextureConfig._RSUpDown
    }, keyText._strZoom)
  elseif self._config._beautyAlbum == state then
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._B
    }, keyText._strClose)
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._A
    }, keyText._strSelect)
  elseif self._config._bone == state then
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._B
    }, keyText._strClose)
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._A
    }, keyText._strSelect)
  elseif self._config._boneCamera == state then
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._B
    }, keyText._strCameramode)
  elseif self._config._boneSlideFocus == state then
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._B
    }, keyText._strBack)
  elseif self._config._slideFocus == state then
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._B
    }, keyText._strBack)
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._RSClick
    }, keyText._strCameramode)
  elseif self._config._subPanel == state then
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._B
    }, keyText._strBack)
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._A
    }, keyText._strSelect)
    self:addKeyGuide(keyGuideTableTemplete, {
      self._keyGuideTextureConfig._RSClick
    }, keyText._strCameramode)
  end
  return keyGuideTableTemplete
end
function CustomizationMain:addKeyGuide(keyGuideTable, iconKeyList, str)
  local consoleUIList = {}
  local lastIcon
  local table = {
    _iconList = {},
    _str
  }
  local strControl = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, keyGuideTable._bg, "StaticText_Custom_KeyGuide_" .. #self._KeyGuideTable .. "_" .. self._currentKeyGuideCount)
  CopyBaseProperty(self._ui._staticText_KeyGuideTemplete, strControl)
  strControl:SetText(str)
  local startPosX
  if nil == keyGuideTable[self._currentKeyGuideCount - 1] then
    startPosX = getScreenSizeX() - strControl:GetTextSizeX() - 50
  else
    startPosX = keyGuideTable[self._currentKeyGuideCount - 1]._iconList[0]:GetPosX() - strControl:GetTextSizeX() - 30
  end
  strControl:SetPosY(strControl:GetPosY() + 10)
  strControl:SetPosX(startPosX)
  strControl:SetShow(true)
  for index = #iconKeyList - 1, 0, -1 do
    local iconkey = iconKeyList[index + 1]
    local control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, keyGuideTable._bg, "Button_Custom_KeyGuide_" .. #self._KeyGuideTable .. "_" .. self._currentKeyGuideCount .. "_" .. index)
    CopyBaseProperty(self._ui._button_KeyGuideTemplete, control)
    local x1, y1, x2, y2 = setTextureUV_Func(control, self._keyGuideUV[iconkey].x1, self._keyGuideUV[iconkey].y1, self._keyGuideUV[iconkey].x2, self._keyGuideUV[iconkey].y2)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    if self._keyGuideTextureConfig._Plus == iconkey or self._keyGuideTextureConfig._OR == iconkey then
      control:SetSize(12, 44)
    end
    if nil == lastIcon then
      control:SetPosX(strControl:GetPosX() - control:GetSizeX() * (#iconKeyList - index))
    else
      control:SetPosX(lastIcon:GetPosX() - control:GetSizeX())
    end
    control:SetShow(true)
    consoleUIList[index] = control
    lastIcon = control
  end
  table._iconList = consoleUIList
  table._str = strControl
  keyGuideTable[self._currentKeyGuideCount] = table
  self._currentKeyGuideCount = self._currentKeyGuideCount + 1
end
function CustomizationMain:SetSubTitlePos()
  self._ui._static_SubTitle:SetText(self._ui._subMenu[self._currentMainIndex][self._currentSubIndex]:GetText())
  self._ui._static_SubTitle:SetIgnore(true)
  self._ui._static_SubTitle:SetCheck(true)
  self._ui._static_SubTitle:SetShow(true)
end
function CustomizationMain:LeafMenuClose()
  for _, control in pairs(self._ui._leafMune) do
    control:addInputEvent("Mouse_LUp", "")
    control:SetCheck(false)
    control:SetShow(false)
  end
end
function CustomizationMain:SubMenuOpen(mainIndex)
  self._ui._static_ZodiacBg:SetShow(self._mainMenuConfig._Zodiac == mainIndex)
  for index, control in pairs(self._ui._subMenu[mainIndex]) do
    control:SetShow(true)
    control:SetCheck(false)
    control:SetIgnore(false)
    control:SetPosX(self._focusMenuPosX)
    control:SetPosY(self._focusMenuPosY + (control:GetSizeY() + 30) * (index + 1))
  end
  self._currentDepth = 1
  if self._mainMenuConfig._Zodiac == mainIndex then
    for index, control in pairs(self._ui._subMenu[mainIndex]) do
      control:SetCheck(index == self._currentZodiacIndex)
    end
  end
  self._ui._static_SubTitle:SetText(self._ui._mainMenu[mainIndex]:GetText())
  self._ui._static_SubTitle:SetIgnore(true)
  self._ui._static_SubTitle:SetCheck(true)
  self._ui._static_SubTitle:SetShow(true)
  PaGlobalFunc_Customization_SetKeyGuide(0)
end
function CustomizationMain:SubMenuClose(mainIndex)
  if nil ~= mainIndex then
    for _, control in pairs(self._ui._subMenu[mainIndex]) do
      control:SetShow(false)
      control:SetCheck(false)
    end
  else
    for _, control in pairs(self._ui._subMenu[self._mainMenuConfig._Customizing]) do
      control:SetShow(false)
      control:SetCheck(false)
    end
    for _, control in pairs(self._ui._subMenu[self._mainMenuConfig._Zodiac]) do
      control:SetShow(false)
      control:SetCheck(false)
    end
    for _, control in pairs(self._ui._subMenu[self._mainMenuConfig._Action]) do
      control:SetShow(false)
      control:SetCheck(false)
    end
  end
end
function PaGlobalFunc_Customization_Back()
  local self = CustomizationMain
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  if true == FGlobal_CustomizingAlbum_GetShow() then
    if false == PaGlobalFunc_CustomizationAlbum_Escape() then
      Input_WebAlbum_ToWebBanner("B")
      return
    end
    self._ui._mainMenu[3]:SetCheck(false)
    self:SetPadXButton(true)
    PaGlobalFunc_Customization_SetKeyGuide(0)
    CustomizingAlbum_Close()
    return
  end
  if true == self._isCameraMode then
    self:UnSetCameraMode()
    return
  end
  if 0 == self._currentDepth then
    if nil ~= self._currentPanelCloseFunc then
      self._currentPanelCloseFunc()
      return
    end
    if true == PaGlobalFunc_Customization_IsInGame() then
      IngameCustomize_Hide()
      return
    end
    PaGlobalFunc_Customization_Cancel()
  elseif 1 == self._currentDepth then
    if true == self._isOtherPanelOpen then
      if nil ~= self._currentPanelCloseFunc then
        if false == self._currentPanelCloseFunc() then
          return
        end
        for _, control in pairs(self._ui._subMenu[self._currentMainIndex]) do
          if nil ~= control then
            control:SetCheck(false)
          end
        end
      end
      PaGlobalFunc_Customization_SetKeyGuide(0)
      return
    end
    self:SubMenuClose(self._currentMainIndex)
    self:MainMenuOpen()
    self._ui._static_SubTitle:SetShow(false)
  elseif 2 == self._currentDepth then
    if true == self._isOtherPanelOpen then
      if nil ~= self._currentPanelCloseFunc then
        if false == self._currentPanelCloseFunc() then
          return
        end
        for _, control in pairs(self._ui._leafMune) do
          if nil ~= control then
            control:SetCheck(false)
          end
        end
      end
      PaGlobalFunc_Customization_SetKeyGuide(0)
      return
    end
    selectCustomizationControlPart(-1)
    selectCustomizationControlGroup(-1)
    self:LeafMenuClose()
    self:SubMenuOpen(self._currentMainIndex)
  end
end
function PaGlobalFunc_Customization_CreateCharacter()
  local self = CustomizationMain
  if false == PaGlobalFunc_Customization_KeyGuideGetShow() then
    return
  end
  PaGlobalFunc_Customization_InputName_Open()
end
function PaGlobalFunc_Customization_ChangeWeather()
  local self = CustomizationMain
  self._currentWeatherIndex = self._currentWeatherIndex + 1
  if self._currentWeatherIndex > self._weatherTypeCount then
    self._currentWeatherIndex = 1
  end
  if nil ~= self._currentWeatherIndex then
    applyWeather(self._currentWeatherIndex - 1)
  end
end
function CustomizationMain:InitEvent()
  for index, mainButton in pairs(self._ui._mainMenu) do
    mainButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_ClickedMainMenu(" .. index .. ")")
  end
  for index, zodiacControl in pairs(self._ui._subMenu[self._mainMenuConfig._Customizing]) do
    zodiacControl:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_ClickedCustomizing(" .. index .. ")")
  end
  for index, zodiacControl in pairs(self._ui._subMenu[self._mainMenuConfig._Zodiac]) do
    zodiacControl:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_ClickedZodiac(" .. index .. ")")
  end
  for index, zodiacControl in pairs(self._ui._subMenu[self._mainMenuConfig._Action]) do
    zodiacControl:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_ClickedAction(" .. index .. ")")
  end
  Panel_Customizing:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_Customization_CreateCharacter()")
  Panel_Customizing:registerPadEvent(__eConsoleUIPadEvent_LTPress_Y, "PaGlobalFunc_Customization_ChangeWeather()")
end
function CustomizationMain:InitKeyGuide()
  self._KeyGuideTable = {}
  self._KeyGuideTable[self._config._common] = {}
  self._KeyGuideTable[self._config._common] = self:MakeKeyGuide(self._config._common)
  self._KeyGuideTable[self._config._camera] = {}
  self._KeyGuideTable[self._config._camera] = self:MakeKeyGuide(self._config._camera)
  self._KeyGuideTable[self._config._beautyAlbum] = {}
  self._KeyGuideTable[self._config._beautyAlbum] = self:MakeKeyGuide(self._config._beautyAlbum)
  self._KeyGuideTable[self._config._bone] = {}
  self._KeyGuideTable[self._config._bone] = self:MakeKeyGuide(self._config._bone)
  self._KeyGuideTable[self._config._boneCamera] = {}
  self._KeyGuideTable[self._config._boneCamera] = self:MakeKeyGuide(self._config._boneCamera)
  self._KeyGuideTable[self._config._boneSlideFocus] = {}
  self._KeyGuideTable[self._config._boneSlideFocus] = self:MakeKeyGuide(self._config._boneSlideFocus)
  self._KeyGuideTable[self._config._slideFocus] = {}
  self._KeyGuideTable[self._config._slideFocus] = self:MakeKeyGuide(self._config._slideFocus)
  self._KeyGuideTable[self._config._subPanel] = {}
  self._KeyGuideTable[self._config._subPanel] = self:MakeKeyGuide(self._config._subPanel)
end
function PaGlobalFunc_Customization_SetBackEvent(func)
  local self = CustomizationMain
  if nil ~= func then
    self._isOtherPanelOpen = true
  else
    self._isOtherPanelOpen = false
  end
end
function PaGlobalFunc_Customization_SelectClass()
  PaGlobalFunc_Customization_Close()
  changeCreateCharacterMode_SelectClass(FGlobal_getIsSpecialCharacter())
end
function PaGlobalFunc_Customization_Cancel()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_CANCEL")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = PaGlobalFunc_Customization_SelectClass,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_Customization_CameraLookEnable(lookEnable)
  setCharacterLookAtCamera(false)
end
function PaGlobalFunc_FromClient_Customization_EventShowCharacterCustomization(customizationData, classIndex, isInGame)
  local self = CustomizationMain
  self._currentClassType = classIndex
  self._isInGame = isInGame
end
function PaGlobalFunc_FromClient_Customization_ShowAllUI(isShow)
  local self = CustomizationMain
  PaGlobalFunc_Customization_Open()
end
function PaGlobalFunc_Customization_GetShow()
  return Panel_Customizing:GetShow()
end
function PaGlobalFunc_Customization_SetShow(isShow, isAni)
  Panel_Customizing:SetShow(isShow, isAni)
end
function PaGlobalFunc_Customization_Close()
  if false == PaGlobalFunc_Customization_GetShow() then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  _AudioPostEvent_SystemUiForXBOX(1, 3)
  PaGlobalFunc_Customization_SetShow(false, false)
end
function PaGlobalFunc_Customization_KeyGuideGetShow()
  local self = CustomizationMain
  return self._ui._static_KeyGuideBg:GetShow()
end
function PaGlobalFunc_Customization_KeyGuideSetShow(isShow)
  local self = CustomizationMain
  self._ui._static_KeyGuideBg:SetShow(isShow)
end
function PaGlobalFunc_Customization_CashCustomization_Apply()
  if false == PaGlobalFunc_Customization_KeyGuideGetShow() then
    return
  end
  HandleClicked_CashCustomization_Apply()
end
function PaGlobalFunc_Customization_Open()
  local self = CustomizationMain
  if true == PaGlobalFunc_Customization_GetShow() then
    return
  end
  self._isCameraMode = false
  setCharacterLookAtCamera(false)
  self._ui._currentMainMenu = {}
  if false == PaGlobalFunc_Customization_IsInGame() then
    self._ui._button_Apply:SetText(PAGetString(Defines.StringSheet_RESOURCE, "CHARACTER_CREATE_TXT_TITLE"))
    Panel_Customizing:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_Customization_CreateCharacter()")
    self._ui._currentMainMenu = self._ui._mainMenu
    self._ui._static_SubTitle:SetPosY(180)
    self._ui._static_MainMenuBg:SetPosY(180)
    self._ui._static_SubMenuBg:SetPosY(180)
  else
    self._ui._button_Apply:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CASH_REVIVAL_BUYITEM_BTN_CONFIRM"))
    Panel_Customizing:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_Customization_CashCustomization_Apply()")
    self._ui._currentMainMenu = self._ui._ingameMainMenu
    self._ui._static_SubTitle:SetPosY(80)
    self._ui._static_MainMenuBg:SetPosY(80)
    self._ui._static_SubMenuBg:SetPosY(80)
  end
  self._ui._button_Apply:SetPosX(getScreenSizeX() - (self._ui._button_Apply:GetTextSizeX() + self._ui._button_Apply:GetSizeX() + 50))
  self._currentMainIndex = -1
  self._currentSubIndex = -1
  self._currentLeafIndex = -1
  self._currentKeyGuideIndex = -1
  self._currentDepth = 0
  self:LeafMenuClose()
  self:SubMenuClose()
  self:MainMenuOpen()
  if false == PaGlobalFunc_Customization_IsInGame() then
    PaGlobalFunc_Customization_ClickedZodiac(getRandomValue(0, getZodiacCount() - 1))
    PaGlobalFunc_Customization_Voice_ResetFocus()
  end
  self._currentWeatherIndex = 1
  self._weatherTypeCount = getWeatherCount()
  PaGlobalFunc_Customization_SetKeyGuide(0)
  PaGlobalFunc_Customization_SetShow(true, false)
end
function PaGlobalFunc_Customization_Toggle()
  PaGlobalFunc_Customization_SetShow(not PaGlobalFunc_Customization_GetShow(), false)
end
function CustomizationMain:InitRegister()
  registerEvent("EventShowUpAllUI", "PaGlobalFunc_FromClient_Customization_ShowAllUI")
  registerEvent("EventShowCharacterCustomization", "PaGlobalFunc_FromClient_Customization_EventShowCharacterCustomization")
end
function PaGlobalFunc_FromClient_Customization_luaLoadComplete()
  local self = CustomizationMain
  self:Initialize()
end
PaGlobalFunc_FromClient_Customization_luaLoadComplete()
