LobbyInstance_IME:SetShow(true, false)
LobbyInstance_IME:SetDragEnable(false)
LobbyInstance_IME:SetIgnore(true)
LobbyInstance_IME:SetSize(1, 1)
local updateTime = 0
local static_IntroMovie
local IM = CppEnums.EProcessorInputMode
function InitCandidate()
  candidate = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, LobbyInstance_IME, "Mail_IME")
  candidate:SetIgnore(false)
  candidate:SetPosX(0)
  candidate:SetPosY(0)
  candidate:SetSize(384, 48)
  candidate:ResetUrl()
  candidate:SetShow(false, false)
end
function FGlobal_SetCandidate()
  candidate:SetUrl(384, 48, "coui://UI_Data/UI_Html/ .html", true)
end
function FGlobal_ClearCandidate()
  candidate:ResetUrl()
end
InitCandidate()
