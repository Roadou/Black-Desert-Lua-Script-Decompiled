local Edit_CandidateList = {
  [1] = UI.getChildControl(Panel_SpecialCharacter, "StaticText_1"),
  [2] = UI.getChildControl(Panel_SpecialCharacter, "StaticText_2"),
  [3] = UI.getChildControl(Panel_SpecialCharacter, "StaticText_3"),
  [4] = UI.getChildControl(Panel_SpecialCharacter, "StaticText_4"),
  [5] = UI.getChildControl(Panel_SpecialCharacter, "StaticText_5"),
  [6] = UI.getChildControl(Panel_SpecialCharacter, "StaticText_6"),
  [7] = UI.getChildControl(Panel_SpecialCharacter, "StaticText_7"),
  [8] = UI.getChildControl(Panel_SpecialCharacter, "StaticText_8"),
  [9] = UI.getChildControl(Panel_SpecialCharacter, "StaticText_9"),
  [10] = UI.getChildControl(Panel_SpecialCharacter, "StaticText_10")
}
function FromClient_ImeShowPanel(isShow)
  Panel_SpecialCharacter:SetShow(isShow)
end
function FromClient_ChangePos(Pos)
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  local halfX = Panel_SpecialCharacter:GetSizeX() * 0.5
  local PanelY = Panel_SpecialCharacter:GetSizeY()
  if Pos.x - halfX < 0 then
    Pos.x = halfX
  end
  if 0 > Pos.y then
    Pos.y = 0
  end
  if screenX < Pos.x + halfX then
    Pos.x = screenX - halfX
  end
  if screenY < Pos.y + PanelY then
    Pos.y = screenY - PanelY
  end
  Panel_SpecialCharacter:SetPosX(Pos.x)
  Panel_SpecialCharacter:SetPosY(Pos.y)
end
function FromClient_ChangeText(Text, index)
  local Edit_Candidate = Edit_CandidateList[index]
  Edit_Candidate:SetText(Text)
end
function FromClient_ChangePanelSize(size)
  local Edit_Candidate = Edit_CandidateList[size.x]
  size.x = Edit_Candidate:GetTextSizeX() + 10
  Panel_SpecialCharacter:SetSize(size.x, size.y)
end
registerEvent("FromClient_ImeShowPanel", "FromClient_ImeShowPanel")
registerEvent("FromClient_ChangePos", "FromClient_ChangePos")
registerEvent("FromClient_ChangeText", "FromClient_ChangeText")
registerEvent("FromClient_ChangePanelSize", "FromClient_ChangePanelSize")
