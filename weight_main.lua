PaGlobalPlayerWeightList = {
  panel = Panel_Endurance,
  weight = UI.getChildControl(Panel_Endurance, "StaticText_WeightOver"),
  weightText = UI.getChildControl(Panel_Endurance, "StaticText_NoticeWeight"),
  repair_AutoNavi = UI.getChildControl(Panel_Endurance, "CheckButton_Repair_AutoNavi")
}
function PaGlobalPlayerWeightList:initialize()
  self.weight:SetShow(false)
  self.weightText:SetShow(false)
  self.weightText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WEIGHT_MAIN_DEFAULT_VISUAL"))
  self.weightText:SetPosX(self.weight:GetPosX() - self.weightText:GetTextSizeX() - 25)
  self.weightText:SetPosY(self.weight:GetPosY() - 4)
  self.weight:addInputEvent("Mouse_On", "PaGlobalPlayerWeightList_MouseOver(true, 100)")
  self.weight:addInputEvent("Mouse_Out", "PaGlobalPlayerWeightList_MouseOver(false, 100)")
  self.weight:addInputEvent("Mouse_LUp", "PaGlobal_EasyBuy:Open( 4 )")
end
function PaGlobalPlayerWeightList_MouseOver(isShow, value)
  local self = PaGlobalPlayerWeightList
  if true == isShow then
    self.weightText:SetShow(true)
    self.weightText:SetPosX(self.weight:GetPosX() - self.weightText:GetTextSizeX() - 25)
    self.weightText:SetPosY(self.weight:GetPosY() - 4)
    self.weightText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ENDURANCE_STCTXT_NOTICEWEIGHT_WITH_FAIRY", "weight", tostring(value)) .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_WEIGHTHELP_4"))
  else
    self.weightText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WEIGHT_MAIN_DEFAULT_VISUAL_WITH_FAIRY", "weight", tostring(value)))
    self.weightText:SetShow(true)
  end
end
function PcEnduranceToggle()
  local self = PaGlobalPlayerWeightList
  return self.weight:GetShow()
end
PaGlobalPlayerWeightList:initialize()
