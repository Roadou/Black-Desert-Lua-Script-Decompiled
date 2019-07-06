local UI_TM = CppEnums.TextMode
local howUsePearlShop = {
  _stc_Bg = UI.getChildControl(Panel_IngameCashShop_HowUsePearlShop, "Static_BG"),
  _stc_NaverBG = UI.getChildControl(Panel_IngameCashShop_HowUsePearlShop, "Static_NaverDescBG"),
  _btn_Close = UI.getChildControl(Panel_IngameCashShop_HowUsePearlShop, "Button_Close")
}
howUsePearlShop._txt_Desc = UI.getChildControl(howUsePearlShop._stc_Bg, "StaticText_Desc")
howUsePearlShop._txt_NaverDesc = UI.getChildControl(howUsePearlShop._stc_NaverBG, "StaticText_NaverDesc")
function Panel_IngameCashShop_HowUsePearlShop_Init()
  local self = howUsePearlShop
  self._txt_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  if true == _ContentsGroup_KR_Transfer then
    self._txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_HOWUSEPEARLSHOP_HOWTOUSE"))
  else
    self._txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_HOWUSEPEARLSHOP_MAINDESC"))
  end
  self._txt_NaverDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  if true == _ContentsGroup_KR_Transfer then
    self._txt_NaverDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_HOWUSEPEARLSHOP_COUPONBOOK"))
  else
    self._txt_NaverDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_HOWUSEPEARLSHOP_NAVERDESC"))
  end
  if self._txt_Desc:GetTextSizeY() + 60 > self._stc_Bg:GetSizeY() then
    local minusSizeY = self._txt_Desc:GetTextSizeY() - self._stc_Bg:GetSizeY() + 60
    Panel_IngameCashShop_HowUsePearlShop:SetSize(Panel_IngameCashShop_HowUsePearlShop:GetSizeX(), Panel_IngameCashShop_HowUsePearlShop:GetSizeY() + minusSizeY)
    self._stc_Bg:SetSize(self._stc_Bg:GetSizeX(), self._stc_Bg:GetSizeY() + minusSizeY)
    self._stc_NaverBG:SetPosY(self._stc_NaverBG:GetPosY() + minusSizeY)
  end
  if self._txt_NaverDesc:GetTextSizeY() + 60 > self._stc_NaverBG:GetSizeY() then
    local minusSizeY = self._txt_NaverDesc:GetTextSizeY() - self._stc_NaverBG:GetSizeY() + 60
    Panel_IngameCashShop_HowUsePearlShop:SetSize(Panel_IngameCashShop_HowUsePearlShop:GetSizeX(), Panel_IngameCashShop_HowUsePearlShop:GetSizeY() + minusSizeY)
    self._stc_NaverBG:SetSize(self._stc_NaverBG:GetSizeX(), self._stc_NaverBG:GetSizeY() + minusSizeY)
  end
  self._btn_Close:addInputEvent("Mouse_LUp", "Panel_IngameCashShop_HowUsePearlShop_Close()")
end
function Panel_IngameCashShop_HowUsePearlShop_Open()
  Panel_IngameCashShop_HowUsePearlShop:SetShow(true)
end
function Panel_IngameCashShop_HowUsePearlShop_Close()
  Panel_IngameCashShop_HowUsePearlShop:SetShow(false)
end
Panel_IngameCashShop_HowUsePearlShop_Init()
