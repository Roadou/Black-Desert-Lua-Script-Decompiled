local UI_TM = CppEnums.TextMode
Panel_FirstLogin:SetShow(false)
Panel_FirstLogin:setGlassBackground(true)
Panel_FirstLogin:RegisterShowEventFunc(true, "Panel_FirstLogin_ShowAni()")
Panel_FirstLogin:RegisterShowEventFunc(false, "Panel_FirstLogin_HideAni()")
function Panel_FirstLogin_ShowAni()
end
function Panel_FirstLogin_HideAni()
end
local FirstLogin = {
  blockBG = UI.getChildControl(Panel_FirstLogin, "Static_blockBG"),
  BTN_Next = UI.getChildControl(Panel_FirstLogin, "Button_Next"),
  RecommendBG_Low = UI.getChildControl(Panel_FirstLogin, "Static_RecommendBG_Low"),
  RecommendBG_Normal = UI.getChildControl(Panel_FirstLogin, "Static_RecommendBG_Normal"),
  RecommendBG_High = UI.getChildControl(Panel_FirstLogin, "Static_RecommendBG_High"),
  Slider_Control = UI.getChildControl(Panel_FirstLogin, "Slider_Control"),
  Slider_0 = UI.getChildControl(Panel_FirstLogin, "StaticText_Slider_0"),
  Slider_50 = UI.getChildControl(Panel_FirstLogin, "StaticText_Slider_50"),
  Slider_100 = UI.getChildControl(Panel_FirstLogin, "StaticText_Slider_100"),
  Slider_DescBG = UI.getChildControl(Panel_FirstLogin, "Static_ContentBG"),
  Slider_Desc = UI.getChildControl(Panel_FirstLogin, "StaticText_ContentDesc"),
  Text_Title = UI.getChildControl(Panel_FirstLogin, "StaticText_ContentTitle"),
  RadioBTN_AllRound = UI.getChildControl(Panel_FirstLogin, "RadioButton_Taste_AllRound"),
  RadioBTN_Combat = UI.getChildControl(Panel_FirstLogin, "RadioButton_Taste_Combat"),
  RadioBTN_Product = UI.getChildControl(Panel_FirstLogin, "RadioButton_Taste_Product"),
  RadioBTN_Fishing = UI.getChildControl(Panel_FirstLogin, "RadioButton_Taste_Fishing"),
  Text_RadioBTN_Title = UI.getChildControl(Panel_FirstLogin, "StaticText_Taste_All_Title"),
  Text_RadioBTN_Desc = UI.getChildControl(Panel_FirstLogin, "StaticText_Taste_All_Desc"),
  RadioBTN_None = UI.getChildControl(Panel_FirstLogin, "RadioButton_NavGuideNone"),
  RadioBTN_Arrow = UI.getChildControl(Panel_FirstLogin, "RadioButton_NavGuideArrow"),
  RadioBTN_Effect = UI.getChildControl(Panel_FirstLogin, "RadioButton_NavGuideEffect"),
  RadioBTN_Fairy = UI.getChildControl(Panel_FirstLogin, "RadioButton_NavGuideFairy"),
  img_None = UI.getChildControl(Panel_FirstLogin, "Static_None"),
  img_Arrow = UI.getChildControl(Panel_FirstLogin, "Static_Arrow"),
  img_Effect = UI.getChildControl(Panel_FirstLogin, "Static_Effect"),
  img_Fairy = UI.getChildControl(Panel_FirstLogin, "Static_Fairy"),
  title_TexQuality = UI.getChildControl(Panel_FirstLogin, "StaticText_TextureQuality"),
  Button_TextureLow = UI.getChildControl(Panel_FirstLogin, "RadioButton_TextureLow"),
  Button_TextureNormal = UI.getChildControl(Panel_FirstLogin, "RadioButton_TextureNormal"),
  Button_TextureHigh = UI.getChildControl(Panel_FirstLogin, "RadioButton_TextureHigh"),
  RadioButton_TextureRemaster = UI.getChildControl(Panel_FirstLogin, "RadioButton_TextureRemaster"),
  _rdo_LowPower_Off = UI.getChildControl(Panel_FirstLogin, "RadioButton_LowPower_Off"),
  _rdo_LowPower_On = UI.getChildControl(Panel_FirstLogin, "RadioButton_LowPower_On"),
  _stc_Step6_Group = UI.getChildControl(Panel_FirstLogin, "Static_Group_Step6"),
  _rdo_hp1 = nil,
  _rdo_hp2 = nil,
  Step1 = false,
  Step2 = false,
  Step3 = false,
  Step4 = false,
  Step5 = false,
  Step6 = false,
  characterSelect = nil,
  TEXTURE_QUALITY_HIGH = 0,
  TEXTURE_QUALITY_NORMAL = 1,
  TEXTURE_QUALITY_LOW = 2,
  TEXTURE_QUALITY_COUNT = 3,
  GRAPHIC_OPTION_HIGH0 = 0,
  GRAPHIC_OPTION_HIGH1 = 1,
  GRAPHIC_OPTION_NORMAL0 = 2,
  GRAPHIC_OPTION_NORMAL1 = 3,
  GRAPHIC_OPTION_LOW0 = 4,
  GRAPHIC_OPTION_LOW1 = 5,
  GRAPHIC_OPTION_VERYLOW = 6,
  GRAPHIC_OPTION_COUNT = 7,
  currentTexGraphicOptionIdx = 0,
  currentGraphicOptionIdx = 0
}
FirstLogin.Slider_ControlBTN = UI.getChildControl(FirstLogin.Slider_Control, "Slider_Button")
FirstLogin._buttonQuestion = UI.getChildControl(Panel_FirstLogin, "Button_Question")
FirstLogin._buttonQuestion:SetShow(false)
function FirstLogin:initialize()
  self.BTN_Next:SetShow(false)
  self.Text_Title:SetShow(false)
  self.Slider_Desc:SetShow(false)
  self.Slider_Control:SetShow(false)
  self.Slider_0:SetShow(false)
  self.Slider_50:SetShow(false)
  self.Slider_100:SetShow(false)
  self.Slider_DescBG:SetShow(false)
  self.RecommendBG_Low:SetShow(false)
  self.RecommendBG_Normal:SetShow(false)
  self.RecommendBG_High:SetShow(false)
  self.RadioBTN_AllRound:SetShow(false)
  self.RadioBTN_Combat:SetShow(false)
  self.RadioBTN_Product:SetShow(false)
  self.RadioBTN_Fishing:SetShow(false)
  self.Text_RadioBTN_Title:SetShow(false)
  self.Text_RadioBTN_Desc:SetShow(false)
  self.RadioBTN_None:SetShow(false)
  self.RadioBTN_Arrow:SetShow(false)
  self.RadioBTN_Effect:SetShow(false)
  self.RadioBTN_Fairy:SetShow(false)
  self.img_None:SetShow(false)
  self.img_Arrow:SetShow(false)
  self.img_Effect:SetShow(false)
  self.img_Fairy:SetShow(false)
  self.title_TexQuality:SetShow(false)
  self.Button_TextureLow:SetShow(false)
  self.Button_TextureNormal:SetShow(false)
  self.Button_TextureHigh:SetShow(false)
  self.RadioButton_TextureRemaster:SetShow(false)
  self._rdo_LowPower_Off:SetShow(false)
  self._rdo_LowPower_On:SetShow(false)
  self._stc_Step6_Group:SetShow(false)
  self.Text_RadioBTN_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.Slider_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.Slider_DescBG:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._rdo_hp1 = UI.getChildControl(self._stc_Step6_Group, "RadioButton_1")
  self._rdo_hp2 = UI.getChildControl(self._stc_Step6_Group, "RadioButton_2")
end
function FirstLogin:SetStep1()
  self.blockBG:SetSize(getScreenSizeX(), getScreenSizeY())
  self.blockBG:ComputePos()
  self.Step1 = true
  self.Step2 = false
  self.Step3 = false
  self.Step4 = false
  self.Step5 = false
  self.Step6 = false
  self.Text_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPTITLE1"))
  self.Slider_DescBG:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPDESC1"))
  self.Slider_Control:SetControlPos(50)
  self:PanelResize_ByFontSize()
  self.BTN_Next:SetShow(true)
  self.Text_Title:SetShow(true)
  self.Slider_Desc:SetShow(false)
  self.Slider_Control:SetShow(true)
  self.Slider_0:SetShow(true)
  self.Slider_50:SetShow(true)
  self.Slider_100:SetShow(true)
  self.Slider_DescBG:SetShow(true)
  self.RecommendBG_Low:SetShow(true)
  self.RecommendBG_Normal:SetShow(true)
  self.RecommendBG_High:SetShow(true)
  self.RadioBTN_AllRound:SetShow(false)
  self.RadioBTN_Combat:SetShow(false)
  self.RadioBTN_Product:SetShow(false)
  self.RadioBTN_Fishing:SetShow(false)
  self.Text_RadioBTN_Title:SetShow(false)
  self.Text_RadioBTN_Desc:SetShow(false)
  self.RadioBTN_None:SetShow(false)
  self.RadioBTN_Arrow:SetShow(false)
  self.RadioBTN_Effect:SetShow(false)
  self.RadioBTN_Fairy:SetShow(false)
  self.img_None:SetShow(false)
  self.img_Arrow:SetShow(false)
  self.img_Effect:SetShow(false)
  self.img_Fairy:SetShow(false)
  self.title_TexQuality:SetShow(false)
  self.Button_TextureLow:SetShow(false)
  self.Button_TextureNormal:SetShow(false)
  self.Button_TextureHigh:SetShow(false)
  self.RadioButton_TextureRemaster:SetShow(false)
  self._rdo_LowPower_Off:SetShow(false)
  self._rdo_LowPower_On:SetShow(false)
  self._stc_Step6_Group:SetShow(false)
end
function FirstLogin:SetStep2()
  self.Step1 = false
  self.Step2 = true
  self.Step3 = false
  self.Step4 = false
  self.Step5 = false
  self.Step6 = false
  self.Text_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPTITLE2"))
  self.Slider_DescBG:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPDESC2"))
  self.Slider_Control:SetControlPos(10)
  self:PanelResize_ByFontSize()
  self.BTN_Next:SetShow(true)
  self.Text_Title:SetShow(true)
  self.Slider_Desc:SetShow(false)
  self.Slider_Control:SetShow(true)
  self.Slider_0:SetShow(true)
  self.Slider_50:SetShow(true)
  self.Slider_100:SetShow(true)
  self.Slider_DescBG:SetShow(true)
  self.RecommendBG_Low:SetShow(true)
  self.RecommendBG_Normal:SetShow(true)
  self.RecommendBG_High:SetShow(true)
  self.RadioBTN_AllRound:SetShow(false)
  self.RadioBTN_Combat:SetShow(false)
  self.RadioBTN_Product:SetShow(false)
  self.RadioBTN_Fishing:SetShow(false)
  self.Text_RadioBTN_Title:SetShow(false)
  self.Text_RadioBTN_Desc:SetShow(false)
  self.RadioBTN_None:SetShow(false)
  self.RadioBTN_Arrow:SetShow(false)
  self.RadioBTN_Effect:SetShow(false)
  self.RadioBTN_Fairy:SetShow(false)
  self.img_None:SetShow(false)
  self.img_Arrow:SetShow(false)
  self.img_Effect:SetShow(false)
  self.img_Fairy:SetShow(false)
  self.title_TexQuality:SetShow(false)
  self.Button_TextureLow:SetShow(false)
  self.Button_TextureNormal:SetShow(false)
  self.Button_TextureHigh:SetShow(false)
  self.RadioButton_TextureRemaster:SetShow(false)
  self._rdo_LowPower_Off:SetShow(false)
  self._rdo_LowPower_On:SetShow(false)
  self._stc_Step6_Group:SetShow(false)
end
function FirstLogin:SetStepEnd()
  self.Step1 = false
  self.Step2 = false
  self.Step3 = false
  self.Step4 = false
  self.Step5 = false
  self.Step6 = false
  local QuestListInfo = ToClient_GetQuestList()
  QuestListInfo:setQuestSelectType(0, true)
  QuestListInfo:setQuestSelectType(1, true)
  Panel_FirstLogin:SetShow(false, false)
  selectCharacter(FirstLogin.characterSelect)
end
function FirstLogin:SetStep3()
  self.Step1 = false
  self.Step2 = false
  self.Step3 = true
  self.Step4 = false
  self.Step5 = false
  self.Step6 = false
  self.Text_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPTITLE3"))
  self.Slider_DescBG:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEP3_DESC"))
  self.RadioBTN_Arrow:SetCheck(true)
  self:PanelResize_ByFontSize()
  self.BTN_Next:SetShow(true)
  self.Text_Title:SetShow(true)
  self.Slider_Desc:SetShow(false)
  self.Slider_Control:SetShow(false)
  self.Slider_0:SetShow(false)
  self.Slider_50:SetShow(false)
  self.Slider_100:SetShow(false)
  self.Slider_DescBG:SetShow(true)
  self.RecommendBG_Low:SetShow(false)
  self.RecommendBG_Normal:SetShow(false)
  self.RecommendBG_High:SetShow(false)
  self.RadioBTN_AllRound:SetShow(false)
  self.RadioBTN_Combat:SetShow(false)
  self.RadioBTN_Product:SetShow(false)
  self.RadioBTN_Fishing:SetShow(false)
  self.Text_RadioBTN_Title:SetShow(false)
  self.Text_RadioBTN_Desc:SetShow(false)
  self.RadioBTN_None:SetShow(true)
  self.RadioBTN_None:SetCheck(false)
  self.RadioBTN_Arrow:SetShow(true)
  self.RadioBTN_Arrow:SetCheck(true)
  self.RadioBTN_Effect:SetShow(true)
  self.RadioBTN_Effect:SetCheck(false)
  self.RadioBTN_Fairy:SetShow(true)
  self.RadioBTN_Fairy:SetCheck(false)
  self.img_None:SetShow(true)
  self.img_Arrow:SetShow(true)
  self.img_Effect:SetShow(true)
  self.img_Fairy:SetShow(true)
  self.title_TexQuality:SetShow(false)
  self.Button_TextureLow:SetShow(false)
  self.Button_TextureNormal:SetShow(false)
  self.Button_TextureHigh:SetShow(false)
  self.RadioButton_TextureRemaster:SetShow(false)
  self._rdo_LowPower_Off:SetShow(false)
  self._rdo_LowPower_On:SetShow(false)
  self._stc_Step6_Group:SetShow(false)
end
function FirstLogin:SetStep4()
  self.Step1 = false
  self.Step2 = false
  self.Step3 = false
  self.Step4 = true
  self.Step5 = false
  self.Step6 = false
  self.Text_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPTITLE4"))
  self.Slider_DescBG:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEP4_DESC"))
  self:PanelResize_ByFontSize()
  self.BTN_Next:SetShow(true)
  self.Text_Title:SetShow(true)
  self.Slider_Desc:SetShow(false)
  self.Slider_Control:SetShow(false)
  self.Slider_0:SetShow(false)
  self.Slider_50:SetShow(false)
  self.Slider_100:SetShow(false)
  self.Slider_DescBG:SetShow(true)
  self.RecommendBG_Low:SetShow(false)
  self.RecommendBG_Normal:SetShow(false)
  self.RecommendBG_High:SetShow(false)
  self.RadioBTN_AllRound:SetShow(false)
  self.RadioBTN_Combat:SetShow(false)
  self.RadioBTN_Product:SetShow(false)
  self.RadioBTN_Fishing:SetShow(false)
  self.Text_RadioBTN_Title:SetShow(false)
  self.Text_RadioBTN_Desc:SetShow(false)
  self.RadioBTN_None:SetShow(false)
  self.RadioBTN_Arrow:SetShow(false)
  self.RadioBTN_Effect:SetShow(false)
  self.RadioBTN_Fairy:SetShow(false)
  self.img_None:SetShow(false)
  self.img_Arrow:SetShow(false)
  self.img_Effect:SetShow(false)
  self.img_Fairy:SetShow(false)
  self.title_TexQuality:SetShow(true)
  self.Button_TextureLow:SetShow(true)
  self.Button_TextureLow:SetCheck(false)
  self.Button_TextureNormal:SetShow(true)
  self.Button_TextureNormal:SetCheck(false)
  self.Button_TextureHigh:SetShow(true)
  self.Button_TextureHigh:SetCheck(false)
  self.Button_TextureHigh:SetShow(true)
  self.Button_TextureHigh:SetCheck(false)
  self.RadioButton_TextureRemaster:SetShow(true)
  self.RadioButton_TextureRemaster:SetCheck(true)
  self._rdo_LowPower_Off:SetShow(false)
  self._rdo_LowPower_On:SetShow(false)
  self._stc_Step6_Group:SetShow(false)
  if isGameTypeRussia() or isGameTypeID() then
    self.Button_TextureLow:SetPosX(70)
    self.Button_TextureNormal:SetPosX(self.Button_TextureLow:GetPosX() + self.Button_TextureLow:GetTextSizeX() + 80)
    self.Button_TextureHigh:SetPosX(self.Button_TextureNormal:GetPosX() + self.Button_TextureNormal:GetTextSizeX() + 80)
    self.RadioButton_TextureRemaster:SetPosX(self.Button_TextureHigh:GetPosX() + self.Button_TextureHigh:GetTextSizeX() + 80)
  else
    self.Button_TextureLow:ComputePos()
    self.Button_TextureNormal:ComputePos()
    self.Button_TextureHigh:ComputePos()
    self.RadioButton_TextureRemaster:ComputePos()
  end
end
function FirstLogin:SetStep5()
  self.Step1 = false
  self.Step2 = false
  self.Step3 = false
  self.Step4 = false
  self.Step5 = true
  self.Step6 = false
  self.Text_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPTITLE5"))
  self.BTN_Next:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_CONFIRM"))
  self.Slider_DescBG:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEP5_DESC"))
  self:PanelResize_ByFontSize()
  self.BTN_Next:SetShow(true)
  self.Text_Title:SetShow(true)
  self.Slider_Desc:SetShow(false)
  self.Slider_Control:SetShow(false)
  self.Slider_0:SetShow(false)
  self.Slider_50:SetShow(false)
  self.Slider_100:SetShow(false)
  self.Slider_DescBG:SetShow(true)
  self.RecommendBG_Low:SetShow(false)
  self.RecommendBG_Normal:SetShow(false)
  self.RecommendBG_High:SetShow(false)
  self.RadioBTN_AllRound:SetShow(false)
  self.RadioBTN_Combat:SetShow(false)
  self.RadioBTN_Product:SetShow(false)
  self.RadioBTN_Fishing:SetShow(false)
  self.Text_RadioBTN_Title:SetShow(false)
  self.Text_RadioBTN_Desc:SetShow(false)
  self.RadioBTN_None:SetShow(false)
  self.RadioBTN_Arrow:SetShow(false)
  self.RadioBTN_Effect:SetShow(false)
  self.RadioBTN_Fairy:SetShow(false)
  self.img_None:SetShow(false)
  self.img_Arrow:SetShow(false)
  self.img_Effect:SetShow(false)
  self.img_Fairy:SetShow(false)
  self.title_TexQuality:SetShow(false)
  self.Button_TextureLow:SetShow(false)
  self.Button_TextureLow:SetCheck(false)
  self.Button_TextureNormal:SetShow(false)
  self.Button_TextureNormal:SetCheck(false)
  self.Button_TextureHigh:SetShow(false)
  self.Button_TextureHigh:SetCheck(false)
  self.Button_TextureHigh:SetShow(false)
  self.Button_TextureHigh:SetCheck(false)
  self.RadioButton_TextureRemaster:SetShow(false)
  self.RadioButton_TextureRemaster:SetCheck(false)
  self._rdo_LowPower_On:SetCheck(true)
  self._rdo_LowPower_Off:SetShow(true)
  self._rdo_LowPower_On:SetShow(true)
  self._stc_Step6_Group:SetShow(false)
end
function FirstLogin:SetStep6()
  self.Step1 = false
  self.Step2 = false
  self.Step3 = false
  self.Step4 = false
  self.Step5 = false
  self.Step6 = true
  self.Text_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPTITLE6"))
  self.Slider_DescBG:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEP6_DESC"))
  self:PanelResize_ByFontSize()
  self.BTN_Next:SetShow(true)
  self.Text_Title:SetShow(true)
  self.Slider_Desc:SetShow(false)
  self.Slider_Control:SetShow(false)
  self.Slider_0:SetShow(false)
  self.Slider_50:SetShow(false)
  self.Slider_100:SetShow(false)
  self.Slider_DescBG:SetShow(true)
  self.RecommendBG_Low:SetShow(false)
  self.RecommendBG_Normal:SetShow(false)
  self.RecommendBG_High:SetShow(false)
  self.RadioBTN_AllRound:SetShow(false)
  self.RadioBTN_Combat:SetShow(false)
  self.RadioBTN_Product:SetShow(false)
  self.RadioBTN_Fishing:SetShow(false)
  self.Text_RadioBTN_Title:SetShow(false)
  self.Text_RadioBTN_Desc:SetShow(false)
  self.RadioBTN_None:SetShow(false)
  self.RadioBTN_Arrow:SetShow(false)
  self.RadioBTN_Effect:SetShow(false)
  self.RadioBTN_Fairy:SetShow(false)
  self.img_None:SetShow(false)
  self.img_Arrow:SetShow(false)
  self.img_Effect:SetShow(false)
  self.img_Fairy:SetShow(false)
  self.title_TexQuality:SetShow(false)
  self.Button_TextureLow:SetShow(false)
  self.Button_TextureLow:SetCheck(false)
  self.Button_TextureNormal:SetShow(false)
  self.Button_TextureNormal:SetCheck(false)
  self.Button_TextureHigh:SetShow(false)
  self.Button_TextureHigh:SetCheck(false)
  self.Button_TextureHigh:SetShow(false)
  self.Button_TextureHigh:SetCheck(false)
  self.RadioButton_TextureRemaster:SetShow(false)
  self.RadioButton_TextureRemaster:SetCheck(false)
  self._rdo_LowPower_Off:SetShow(false)
  self._rdo_LowPower_On:SetShow(false)
  self._stc_Step6_Group:SetShow(true)
  self._rdo_hp1:SetCheck(true)
  self._rdo_hp2:SetCheck(false)
end
function FirstLogin:SetStep3End()
  self.Step1 = false
  self.Step2 = false
  self.Step3 = false
  self.Step4 = false
  self.Step5 = false
  local selectType = -1
  if self.RadioBTN_AllRound:IsCheck() then
    selectType = 0
  elseif self.RadioBTN_Combat:IsCheck() then
    selectType = 1
  elseif self.RadioBTN_Product:IsCheck() then
    selectType = 2
  elseif self.RadioBTN_Fishing:IsCheck() then
    selectType = 3
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPTITLE3"))
    self:SetStep3()
    return
  end
  QuestWidget_ShowSelectQuestFavorType(selectType)
  Panel_FirstLogin:SetShow(false, false)
end
function FirstLogin_SetStepData()
  local self = FirstLogin
  local step
  if true == self.Step6 then
    step = 6
  elseif true == self.Step5 then
    step = 5
  elseif true == self.Step4 then
    step = 4
  elseif true == self.Step3 then
    step = 3
  elseif true == self.Step2 then
    step = 2
  elseif true == self.Step1 then
    step = 1
  end
  local volume = FirstLogin.Slider_Control:GetControlPos()
  if 1 == step then
    setLoginOptionCameraShake(volume)
    saveGameOption(false)
    FirstLogin:SetStep2()
  elseif 2 == step then
    setLoginOptionMotionBlur(volume)
    saveGameOption(false)
    FirstLogin:SetStep3()
  elseif 3 == step then
    local isCheck = 1
    local isNoneCheck = self.RadioBTN_None:IsCheck()
    local isArrowCheck = self.RadioBTN_Arrow:IsCheck()
    local isEffectCheck = self.RadioBTN_Effect:IsCheck()
    local isFairyCheck = self.RadioBTN_Fairy:IsCheck()
    if isNoneCheck then
      isCheck = CppEnums.NavPathEffectType.eNavPathEffectType_None
    elseif isArrowCheck then
      isCheck = CppEnums.NavPathEffectType.eNavPathEffectType_Arrow
    elseif isEffectCheck then
      isCheck = CppEnums.NavPathEffectType.eNavPathEffectType_PathEffect
    elseif isFairyCheck then
      isCheck = CppEnums.NavPathEffectType.eNavPathEffectType_Fairy
    end
    setLoginOptionNavPathEffectType(isCheck)
    saveGameOption(false)
    FirstLogin:SetStep4()
  elseif 4 == step then
    local isGraphicCheck = 3
    local isLowCheck = self.Button_TextureLow:IsCheck()
    local isNormalCheck = self.Button_TextureNormal:IsCheck()
    local isHighCheck = self.Button_TextureHigh:IsCheck()
    local isRemaster = self.RadioButton_TextureRemaster:IsCheck()
    if isLowCheck then
      isGraphicCheck = 5
    elseif isNormalCheck then
      isGraphicCheck = 3
    elseif isHighCheck then
      isGraphicCheck = 0
    elseif true == isRemaster then
      isGraphicCheck = 9
    else
      isGraphicCheck = 3
    end
    setLoginOptionGraphicOption(isGraphicCheck)
    FirstLogin:SetStep5()
  elseif 5 == step then
    local isLowPower = self._rdo_LowPower_On:IsCheck()
    setPresentLock(isLowPower)
    FirstLogin:SetStepEnd()
  elseif 6 == step then
    FirstLogin:SetStepEnd()
  end
end
function FirstLogin_FavorQuestType(questType)
  local self = FirstLogin
  local title, desc
  if 0 == questType then
    title = PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPE1")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPETITLE1")
  elseif 1 == questType then
    title = PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPE2")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPETITLE2")
  elseif 2 == questType then
    title = PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPE3")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPETITLE3")
  elseif 3 == questType then
    title = PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPE4")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPETITLE4")
  else
    title = ""
    desc = ""
  end
  desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPE_MSG", "desc", desc)
  self.Text_RadioBTN_Title:SetText(title)
  self.Text_RadioBTN_Desc:SetText(desc)
end
function FGlobal_FirstLogin_Open(characterSelect)
  FirstLogin.characterSelect = characterSelect
  FirstLogin:SetStep1()
  Panel_FirstLogin:SetShow(true, true)
end
function FGlobal_FirstLogin_InGameOpen()
  FirstLogin:SetStep3()
  Panel_FirstLogin:SetShow(true, true)
end
function FGlobal_FirstLogin_InGameClose()
  QuestWidget_ShowSelectQuestFavorType(1)
  Panel_FirstLogin:SetShow(false, false)
end
function FirstLogin_SetCurrentGraphicOption(graphicOptionIdx)
  if graphicOptionIdx >= 0 and graphicOptionIdx < FirstLogin.GRAPHIC_OPTION_COUNT then
    FirstLogin.currentGraphicOptionIdx = graphicOptionIdx
    FirstLogin_SetGraphicOptionText(graphicOptionIdx)
  end
end
function FirstLogin_SetCurrentTexGraphicOption(graphicOptionIdx)
  if graphicOptionIdx >= 0 and graphicOptionIdx < FirstLogin.GRAPHIC_OPTION_COUNT then
    FirstLogin.currentTexGraphicOptionIdx = graphicOptionIdx
    FirstLogin_SetTexGraphicOptionText(graphicOptionIdx)
  end
end
function FirstLogin_ClickedImage(imgType)
  local self = FirstLogin
  if 0 == imgType then
    self.RadioBTN_None:SetCheck(true)
    self.RadioBTN_Arrow:SetCheck(false)
    self.RadioBTN_Effect:SetCheck(false)
    self.RadioBTN_Fairy:SetCheck(false)
  elseif 1 == imgType then
    self.RadioBTN_None:SetCheck(false)
    self.RadioBTN_Arrow:SetCheck(true)
    self.RadioBTN_Effect:SetCheck(false)
    self.RadioBTN_Fairy:SetCheck(false)
  elseif 2 == imgType then
    self.RadioBTN_None:SetCheck(false)
    self.RadioBTN_Arrow:SetCheck(false)
    self.RadioBTN_Effect:SetCheck(true)
    self.RadioBTN_Fairy:SetCheck(false)
  elseif 3 == imgType then
    self.RadioBTN_None:SetCheck(false)
    self.RadioBTN_Arrow:SetCheck(false)
    self.RadioBTN_Effect:SetCheck(false)
    self.RadioBTN_Fairy:SetCheck(true)
  end
end
function FirstLogin_RemasterModeDesc()
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_GRAPHICMODE_ALERTTITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_GRAPHICMODE_ALERTDESC"),
    functionApply = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FirstLogin:registEventHandler()
  self.BTN_Next:addInputEvent("Mouse_LUp", "FirstLogin_SetStepData()")
  self.RadioBTN_AllRound:addInputEvent("Mouse_LUp", "FirstLogin_FavorQuestType( " .. 0 .. " )")
  self.RadioBTN_Combat:addInputEvent("Mouse_LUp", "FirstLogin_FavorQuestType( " .. 1 .. " )")
  self.RadioBTN_Product:addInputEvent("Mouse_LUp", "FirstLogin_FavorQuestType( " .. 2 .. " )")
  self.RadioBTN_Fishing:addInputEvent("Mouse_LUp", "FirstLogin_FavorQuestType( " .. 3 .. " )")
  self.img_None:addInputEvent("Mouse_LUp", "FirstLogin_ClickedImage(" .. 0 .. ")")
  self.img_Arrow:addInputEvent("Mouse_LUp", "FirstLogin_ClickedImage(" .. 1 .. ")")
  self.img_Effect:addInputEvent("Mouse_LUp", "FirstLogin_ClickedImage(" .. 2 .. ")")
  self.img_Fairy:addInputEvent("Mouse_LUp", "FirstLogin_ClickedImage(" .. 3 .. ")")
  self.RadioButton_TextureRemaster:addInputEvent("Mouse_LUp", "FirstLogin_RemasterModeDesc()")
end
function FirstLogin:registMessageHandler()
end
local basePanelSizeY = Panel_FirstLogin:GetSizeY()
local baseBgSizeY = FirstLogin.Slider_DescBG:GetSizeY()
function FirstLogin:PanelResize_ByFontSize()
  if baseBgSizeY < self.Slider_DescBG:GetTextSizeY() then
    self.Slider_DescBG:SetSize(self.Slider_DescBG:GetSizeX(), self.Slider_DescBG:GetTextSizeY() + 20)
  else
    self.Slider_DescBG:SetSize(self.Slider_DescBG:GetSizeX(), baseBgSizeY)
  end
  local plusSizeY = self.Slider_DescBG:GetSizeY() - baseBgSizeY
  Panel_FirstLogin:SetSize(Panel_FirstLogin:GetSizeX(), basePanelSizeY + plusSizeY)
  self.Slider_DescBG:ComputePos()
  self.BTN_Next:ComputePos()
end
FirstLogin:initialize()
FirstLogin:registEventHandler()
FirstLogin:registMessageHandler()
