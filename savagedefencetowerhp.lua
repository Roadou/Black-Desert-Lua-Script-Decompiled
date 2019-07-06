Panel_SavageDefenceTowerHp:SetShow(false)
Panel_SavageDefenceTowerHp:setMaskingChild(true)
Panel_SavageDefenceTowerHp:setGlassBackground(true)
Panel_SavageDefenceTowerHp:SetDragAll(true)
local SavageDefenceTowerHp = {
  _title = UI.getChildControl(Panel_SavageDefenceTowerHp, "StaticText_Title"),
  _towername = UI.getChildControl(Panel_SavageDefenceTowerHp, "StaticText_TowerName"),
  _hpProgress = UI.getChildControl(Panel_SavageDefenceTowerHp, "Progress2_HpGauge")
}
function SavageDefenceTowerHp:Init()
  SavageDefenceTowerHp._title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_TITLE"))
  SavageDefenceTowerHp._towername:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_TOWER_NAME"))
  SavageDefenceTowerHp._hpProgress:SetProgressRate(100)
end
function SavageDefenceTowerHp:SetPosition()
  Panel_SavageDefenceTowerHp:SetPosX(Panel_SavageDefenceMember:GetPosX())
  Panel_SavageDefenceTowerHp:SetPosY(Panel_SavageDefenceMember:GetPosY() - Panel_SavageDefenceTowerHp:GetSizeY())
end
function SavageDefenceTowerHp_Open()
  if not ToClient_getPlayNowSavageDefence() then
    return
  end
  SavageDefenceTowerHp._hpProgress:SetProgressRate(100)
  Panel_SavageDefenceTowerHp:SetShow(true)
  SavageDefenceTowerHp:SetPosition()
end
function FromClient_UpdateTowerHp(rate)
  SavageDefenceTowerHp:SetProgressRate(rate)
end
function SavageDefenceTowerHp:SetProgressRate(rate)
  SavageDefenceTowerHp._hpProgress:SetProgressRate(rate)
end
SavageDefenceTowerHp:Init()
registerEvent("FromClient_UpdateTowerHp", "FromClient_UpdateTowerHp")
