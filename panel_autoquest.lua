Panel_AutoQuest:SetShow(false)
PaGlobal_AutoQuestMsg = {
  _ui = {
    _staticBlackSpirit = UI.getChildControl(Panel_AutoQuest, "Static_BlackSpirit"),
    _staticStartAutoBG = UI.getChildControl(Panel_AutoQuest, "Static_StartAutoBG"),
    _staticTextStartAuto = nil
  },
  _accessBlackSpiritClick = nil
}
PaGlobal_AutoQuestMsg._ui._btn_Start = UI.getChildControl(PaGlobal_AutoQuestMsg._ui._staticStartAutoBG, "Button_BlackSpirit")
PaGlobal_AutoQuestMsg._ui._btn_StartGray = UI.getChildControl(PaGlobal_AutoQuestMsg._ui._staticStartAutoBG, "Button_BlackSpiritGray")
PaGlobal_AutoQuestMsg._ui._btn_StartLight = UI.getChildControl(PaGlobal_AutoQuestMsg._ui._staticStartAutoBG, "Button_BlackSpiritLight")
PaGlobal_AutoQuestMsg._ui._static_OutLine = UI.getChildControl(PaGlobal_AutoQuestMsg._ui._staticStartAutoBG, "Static_OutLineDefault")
PaGlobal_AutoQuestMsg._ui._static_MainLightBG = UI.getChildControl(PaGlobal_AutoQuestMsg._ui._staticStartAutoBG, "Static_MainLightBG")
PaGlobal_AutoQuestMsg._ui._static_Over = UI.getChildControl(PaGlobal_AutoQuestMsg._ui._staticStartAutoBG, "Static_Over")
PaGlobal_AutoQuestMsg._ui._static_Under = UI.getChildControl(PaGlobal_AutoQuestMsg._ui._staticStartAutoBG, "Static_Under")
PaGlobal_AutoQuestMsg._ui._static_StarBG1 = UI.getChildControl(PaGlobal_AutoQuestMsg._ui._staticStartAutoBG, "Static_StarBG1")
PaGlobal_AutoQuestMsg._ui._static_StarBG2 = UI.getChildControl(PaGlobal_AutoQuestMsg._ui._staticStartAutoBG, "Static_StarBG2")
PaGlobal_AutoQuestMsg._ui._btn_Win_Close = UI.getChildControl(PaGlobal_AutoQuestMsg._ui._staticStartAutoBG, "Button_WinClose")
function PaGlobal_AutoQuestMsg:Initialize()
  self._ui._staticTextStartAuto = UI.getChildControl(self._ui._staticStartAutoBG, "StaticText_StartAutoText")
  self._ui._btn_Start:addInputEvent("Mouse_LUp", "FGlobal_MouseclickTest()")
  self._ui._btn_Win_Close:addInputEvent("Mouse_LUp", "PaGlobal_AutoManager:stop()")
  self._ui._static_OutLine:SetShow(false)
  self._ui._btn_StartLight:SetShow(false)
  self._ui._static_MainLightBG:SetShow(true)
  self._ui._static_StarBG1:SetShow(true)
  self._ui._static_StarBG2:SetShow(true)
  self._ui._btn_StartGray:SetShow(true)
  self._ui._static_Over:SetPosX(self._ui._static_OutLine:GetPosX() + self._ui._static_OutLine:GetSizeX() / 2 - self._ui._static_Over:GetSizeX() / 2)
  self._ui._static_Over:SetPosY(self._ui._static_OutLine:GetPosY() - 5)
  self._ui._static_Under:SetPosX(self._ui._static_OutLine:GetPosX() + self._ui._static_OutLine:GetSizeX() / 2 - self._ui._static_Over:GetSizeX() / 2)
  self._ui._static_Under:SetPosY(self._ui._static_OutLine:GetPosY() + self._ui._static_OutLine:GetSizeY() - 5)
end
function PaGlobal_AutoQuestMsg:AniShow()
  local ImageMoveAni1 = self._ui._static_Over:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni1:SetStartPosition(self._ui._static_OutLine:GetPosX() + self._ui._static_OutLine:GetSizeX() / 2 - self._ui._static_Over:GetSizeX() / 2, self._ui._static_OutLine:GetPosY() - 5)
  ImageMoveAni1:SetEndPosition(self._ui._static_OutLine:GetPosX() + self._ui._static_OutLine:GetSizeX() / 2 - self._ui._static_Over:GetSizeX() / 2, self._ui._static_OutLine:GetPosY() - 10)
  ImageMoveAni1.IsChangeChild = true
  self._ui._static_Over:CalcUIAniPos(ImageMoveAni1)
  ImageMoveAni1:SetDisableWhileAni(true)
  local ImageMoveAni2 = self._ui._static_Under:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni2:SetStartPosition(self._ui._static_OutLine:GetPosX() + self._ui._static_OutLine:GetSizeX() / 2 - self._ui._static_Over:GetSizeX() / 2, self._ui._static_OutLine:GetPosY() + self._ui._static_OutLine:GetSizeY() - 5)
  ImageMoveAni2:SetEndPosition(self._ui._static_OutLine:GetPosX() + self._ui._static_OutLine:GetSizeX() / 2 - self._ui._static_Over:GetSizeX() / 2, self._ui._static_OutLine:GetPosY() + self._ui._static_OutLine:GetSizeY())
  ImageMoveAni2.IsChangeChild = true
  self._ui._static_Under:CalcUIAniPos(ImageMoveAni2)
  ImageMoveAni2:SetDisableWhileAni(true)
  local fadeColor1 = self._ui._static_Over:addColorAnimation(0, 1.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  fadeColor1:SetStartColor(Defines.Color.C_FFFFFFFF)
  fadeColor1:SetEndColor(Defines.Color.C_FF24e8ff)
  local fadeColor2 = self._ui._static_Under:addColorAnimation(0, 1.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  fadeColor2:SetStartColor(Defines.Color.C_FFFFFFFF)
  fadeColor2:SetEndColor(Defines.Color.C_FF24e8ff)
end
function PaGlobal_AutoQuestMsg:AniHide()
  local ImageMoveAni1 = self._ui._static_Over:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni1:SetStartPosition(self._ui._static_OutLine:GetPosX() + self._ui._static_OutLine:GetSizeX() / 2 - self._ui._static_Over:GetSizeX() / 2, self._ui._static_OutLine:GetPosY() - 10)
  ImageMoveAni1:SetEndPosition(self._ui._static_OutLine:GetPosX() + self._ui._static_OutLine:GetSizeX() / 2 - self._ui._static_Over:GetSizeX() / 2, self._ui._static_OutLine:GetPosY() - 5)
  ImageMoveAni1.IsChangeChild = true
  self._ui._static_Over:CalcUIAniPos(ImageMoveAni1)
  ImageMoveAni1:SetDisableWhileAni(true)
  ImageMoveAni1:SetHideAtEnd(false)
  local ImageMoveAni2 = self._ui._static_Under:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni2:SetStartPosition(self._ui._static_OutLine:GetPosX() + self._ui._static_OutLine:GetSizeX() / 2 - self._ui._static_Over:GetSizeX() / 2, self._ui._static_OutLine:GetPosY() + self._ui._static_OutLine:GetSizeY())
  ImageMoveAni2:SetEndPosition(self._ui._static_OutLine:GetPosX() + self._ui._static_OutLine:GetSizeX() / 2 - self._ui._static_Over:GetSizeX() / 2, self._ui._static_OutLine:GetPosY() + self._ui._static_OutLine:GetSizeY() - 5)
  ImageMoveAni2.IsChangeChild = true
  self._ui._static_Under:CalcUIAniPos(ImageMoveAni2)
  ImageMoveAni2:SetDisableWhileAni(true)
  ImageMoveAni2:SetHideAtEnd(false)
  local fadeColor1 = self._ui._static_Over:addColorAnimation(0, 1.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  fadeColor1:SetStartColor(Defines.Color.C_FF24e8ff)
  fadeColor1:SetEndColor(Defines.Color.C_FFFFFFFF)
  local fadeColor2 = self._ui._static_Under:addColorAnimation(0, 1.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  fadeColor2:SetStartColor(Defines.Color.C_FF24e8ff)
  fadeColor2:SetEndColor(Defines.Color.C_FFFFFFFF)
end
function FGlobal_AutoQuestBlackSpiritMessage(message)
  self = PaGlobal_AutoQuestMsg
  self._ui._staticTextStartAuto:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._staticTextStartAuto:SetText(message)
  if 300 < self._ui._staticTextStartAuto:GetTextSizeX() then
    self._ui._staticStartAutoBG:SetSize(450, self._ui._staticTextStartAuto:GetTextSizeY() + 45)
  else
    self._ui._staticStartAutoBG:SetSize(self._ui._staticTextStartAuto:GetTextSizeX() + 150, self._ui._staticTextStartAuto:GetTextSizeY() + 45)
  end
end
function PaGlobal_AutoQuestMsg:AniStart()
  self._ui._static_OutLine:SetShow(true)
  self._ui._static_MainLightBG:SetShow(true)
  self._ui._static_StarBG1:SetShow(true)
  self._ui._static_StarBG2:SetShow(true)
  self._ui._btn_StartLight:SetShow(true)
  self._ui._static_OutLine:ResetVertexAni()
  self._ui._btn_StartLight:SetVertexAniRun("Ani_Color_Light", true)
  self._ui._static_OutLine:SetVertexAniRun("Ani_Color_Change", true)
  self._ui._static_MainLightBG:SetVertexAniRun("Ani_Rotate_New", true)
  self._ui._static_StarBG1:SetVertexAniRun("Ani_Color_BG1", true)
  self._ui._static_StarBG2:SetVertexAniRun("Ani_Color_BG2", true)
  PaGlobal_AutoQuestMsg:AniShow()
  PaGlobal_AutoQuestMsg._ui._staticBlackSpirit:EraseAllEffect()
  PaGlobal_AutoQuestMsg._ui._staticBlackSpirit:AddEffect("fN_DarkSpirit_Idle_2_AutoQuest_02A", false, -50, -70)
end
function PaGlobal_AutoQuestMsg:AniStop()
  self._ui._btn_StartLight:ResetVertexAni()
  self._ui._static_OutLine:ResetVertexAni()
  self._ui._static_MainLightBG:ResetVertexAni()
  self._ui._static_StarBG1:ResetVertexAni()
  self._ui._static_StarBG2:ResetVertexAni()
  self._ui._btn_StartLight:SetShow(false)
  self._ui._static_MainLightBG:SetShow(false)
  self._ui._static_StarBG1:SetShow(false)
  self._ui._static_StarBG2:SetShow(false)
end
function PaGlobal_AutoQuestMsg:StartGrayAniHide()
  self._ui._btn_StartGray:ResetVertexAni()
  self._ui._btn_StartGray:SetVertexAniRun("Ani_Color_Hide", true)
end
function PaGlobal_AutoQuestMsg:StartGrayAniShow()
  self._ui._btn_StartGray:ResetVertexAni()
  self._ui._btn_StartGray:SetVertexAniRun("Ani_Color_Show", true)
end
function FGlobal_MouseclickTest()
  self = PaGlobal_AutoQuestMsg
  if PaGlobal_AutoQuestMsg._accessBlackSpiritClick ~= nil then
    PaGlobal_AutoQuestMsg._accessBlackSpiritClick()
    PaGlobal_AutoQuestMsg:AniStart()
  end
end
function FGlobal_EndBlackSpiritMessage()
  self = PaGlobal_AutoQuestMsg
  self._ui._staticTextStartAuto:SetText("")
  self._ui._staticStartAutoBG:SetShow(false)
  PaGlobal_AutoQuestMsg:AniStop()
end
function PaGlobal_AutoQuestMsg:SetShow(isShow)
  self._ui._btn_Start:SetShow(isShow)
  self._ui._staticBlackSpirit:SetShow(isShow)
  self._ui._staticStartAutoBG:SetShow(isShow)
  self._ui._staticTextStartAuto:SetShow(isShow)
  Panel_AutoQuest:SetShow(isShow)
end
PaGlobal_AutoQuestMsg:Initialize()
