PaGlobal_Guild_OneOnOneAlert = {
  _ui = {
    _staticText_AlertMessage = UI.getChildControl(Panel_Guild_OneOnOneAlert, "StaticText_Desc1")
  }
}
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local UI_color = Defines.Color
function GuildOneOnOne_Alert_ShowAni()
  Panel_Guild_OneOnOneAlert:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_MidHorizon.dds")
  local FadeMaskAni = Panel_Guild_OneOnOneAlert:addTextureUVAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
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
function GuildOneOnOne_Alert_HideAni()
  Panel_Guild_OneOnOneAlert:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local closeAni = Panel_Guild_OneOnOneAlert:addColorAnimation(0, 1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(UI_color.C_FFFFFFFF)
  closeAni:SetEndColor(UI_color.C_00FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
  closeAni:SetDisableWhileAni(true)
end
function PaGlobal_Guild_OneOnOneAlert:Show(remainSec)
  local ui = self._ui
  ui._staticText_AlertMessage:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_RINGOVERLAPALERT", "sec", remainSec))
  Panel_Guild_OneOnOneAlert:SetPosX(getScreenSizeX() / 2 - Panel_Guild_OneOnOneAlert:GetSizeX() / 2)
  Panel_Guild_OneOnOneAlert:SetPosY(230)
  Panel_Guild_OneOnOneAlert:SetShow(true, true)
end
function PaGlobal_Guild_OneOnOneAlert:Hide()
  Panel_Guild_OneOnOneAlert:SetShow(false, false)
end
function FGlobal_Guild_OneOnOneAlert_LuaLoadComplete()
  Panel_Guild_OneOnOneAlert:SetShow(false, false)
  Panel_Guild_OneOnOneAlert:RegisterShowEventFunc(true, "GuildOneOnOne_Alert_ShowAni()")
  Panel_Guild_OneOnOneAlert:RegisterShowEventFunc(false, "GuildOneOnOne_Alert_HideAni()")
end
registerEvent("FromClient_luaLoadComplete", "FGlobal_Guild_OneOnOneAlert_LuaLoadComplete")
