Panel_TerritoryWar_Caution_Renew:SetShow(false, false)
local TerritoryWarCaution = {
  _ui = {
    _txt_mainBG = UI.getChildControl(Panel_TerritoryWar_Caution_Renew, "Static_Content")
  },
  _panel = Panel_TerritoryWar_Caution_Renew
}
function TerritoryWarCaution:initControl()
  self._ui._txt_desc = UI.getChildControl(self._ui._txt_mainBG, "StaticText_Desc")
end
function TerritoryWarCaution:registEventHandler()
  self._panel:RegisterShowEventFunc(true, "TerritoryWar_CautionShowAni()")
  self._panel:RegisterShowEventFunc(false, "TerritoryWar_CautionHideAni()")
  self._panel:RegisterUpdateFunc("TerritoryWar_Caution_HideAni")
end
function TerritoryWarCaution:initialize()
  self:initControl()
  local descText = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TERRITORYWAR_CAUTION_DESC_1") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TERRITORYWAR_CAUTION_DESC_2") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TERRITORYWAR_CAUTION_DESC3")
  self._ui._txt_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_desc:SetText(descText)
  self._ui._txt_mainBG:SetSize(self._ui._txt_desc:GetTextSizeX() + 60, self._ui._txt_desc:GetTextSizeY() + 30)
  self._ui._txt_desc:ComputePos()
  self:registEventHandler()
end
function TerritoryWar_CautionShowAni()
  Panel_TerritoryWar_Caution_Renew:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_MidHorizon.dds")
  local FadeMaskAni = Panel_TerritoryWar_Caution_Renew:addTextureUVAnimation(0, 0.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(CppEnums.PAUI_TEXTURE_TYPE.PAUI_TEXTURE_TYPE_MASK)
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
  Panel_TerritoryWar_Caution_Renew:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local closeAni = Panel_TerritoryWar_Caution_Renew:addColorAnimation(0, 1, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(Defines.Color.C_FFFFFFFF)
  closeAni:SetEndColor(Defines.Color.C_00FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
  closeAni:SetDisableWhileAni(true)
end
function FGlobal_TerritoryWar_Caution()
  local isCaution = ToClient_IsDangerBySiegeSelf()
  Panel_TerritoryWar_Caution_Renew:SetShow(false)
  PaGlobal_Radar_WarAlert(false)
  if isCaution then
    Panel_TerritoryWar_Caution_Renew:SetPosX(getScreenSizeX() / 2 - Panel_TerritoryWar_Caution_Renew:GetSizeX() / 2)
    Panel_TerritoryWar_Caution_Renew:SetPosY(200)
    local isGameMaster = ToClient_SelfPlayerIsGM()
    if isGameMaster then
      Panel_TerritoryWar_Caution_Renew:SetShow(false, false)
    else
      PaGlobal_Radar_WarAlert(true)
      Panel_TerritoryWar_Caution_Renew:SetShow(true, true)
    end
  end
end
local _time = 0
function TerritoryWar_Caution_HideAni(deltaTime)
  if _time < 5 then
    _time = _time + deltaTime
  elseif Panel_TerritoryWar_Caution_Renew:GetShow() then
    Panel_TerritoryWar_Caution_Renew:SetShow(false, true)
    _time = 0
  end
end
function FromClient_luaLoadComplete_TerritoryWarCaution()
  local self = TerritoryWarCaution
  self:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_TerritoryWarCaution")
