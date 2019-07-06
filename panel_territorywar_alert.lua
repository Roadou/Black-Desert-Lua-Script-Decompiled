Panel_TerritoryWar_Caution:SetShow(false, false)
Panel_TerritoryWar_Caution:RegisterShowEventFunc(true, "TerritoryWar_CautionShowAni()")
Panel_TerritoryWar_Caution:RegisterShowEventFunc(false, "TerritoryWar_CautionHideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local UI_color = Defines.Color
local desc = UI.getChildControl(Panel_TerritoryWar_Caution, "StaticText_Desc1")
local descText = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TERRITORYWAR_CAUTION_DESC_1") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TERRITORYWAR_CAUTION_DESC_2") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TERRITORYWAR_CAUTION_DESC3")
desc:SetText(descText)
function TerritoryWar_CautionShowAni()
  Panel_TerritoryWar_Caution:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_MidHorizon.dds")
  local FadeMaskAni = Panel_TerritoryWar_Caution:addTextureUVAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  local uvStartX = 0
  local uvStartY = 0
  FadeMaskAni:SetStartUV(uvStartX, uvStartY, 0)
  FadeMaskAni:SetEndUV(0.6, 0, 0)
  FadeMaskAni:SetStartUV(1, 0, 1)
  FadeMaskAni:SetEndUV(0.4, 0, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0.6, 1, 2)
  FadeMaskAni:SetStartUV(1, 1, 3)
  FadeMaskAni:SetEndUV(0.4, 1, 3)
  FadeMaskAni.IsChangeChild = true
end
function TerritoryWar_CautionHideAni()
  Panel_TerritoryWar_Caution:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local closeAni = Panel_TerritoryWar_Caution:addColorAnimation(0, 1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(UI_color.C_FFFFFFFF)
  closeAni:SetEndColor(UI_color.C_00FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
  closeAni:SetDisableWhileAni(true)
end
function FGlobal_TerritoryWar_Caution()
  local isCaution = ToClient_IsDangerBySiegeSelf()
  Panel_TerritoryWar_Caution:SetShow(false)
  PaGlobal_Radar_WarAlert(false)
  if isCaution then
    Panel_TerritoryWar_Caution:SetPosX(getScreenSizeX() / 2 - Panel_TerritoryWar_Caution:GetSizeX() / 2)
    Panel_TerritoryWar_Caution:SetPosY(230)
    local isGameMaster = ToClient_SelfPlayerIsGM()
    if isGameMaster then
      Panel_TerritoryWar_Caution:SetShow(false, false)
    else
      PaGlobal_Radar_WarAlert(true)
      Panel_TerritoryWar_Caution:SetShow(true, true)
    end
  end
end
local _time = 0
function TerritoryWar_Caution_HideAni(deltaTime)
  if _time < 5 then
    _time = _time + deltaTime
  elseif Panel_TerritoryWar_Caution:GetShow() then
    Panel_TerritoryWar_Caution:SetShow(false, true)
    _time = 0
  end
end
Panel_TerritoryWar_Caution:RegisterUpdateFunc("TerritoryWar_Caution_HideAni")
