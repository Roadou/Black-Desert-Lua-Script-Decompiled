Panel_Copy_WaitComment:SetPosX(-1000)
Panel_Copy_WaitComment:SetPosY(-1000)
function FromClient_WaitCommentCreated(actorKeyRaw, targetPanel, selfPlayerActorWrapper)
  local strControl = {
    "Static_Board",
    "Static_Paper",
    "Edit_Txt",
    "Static_Pin_1",
    "Static_Pin_2",
    "Static_Pin_3",
    "Static_Pin_4",
    "Static_Roll_L",
    "Static_Roll_R",
    "StaticText_ID"
  }
  for i = 1, #strControl do
    if nil == UI.isChildControl(targetPanel, strControl[i]) then
      UI.createAndCopyBasePropertyControl(Panel_Copy_WaitComment, strControl[i], targetPanel, strControl[i])
    end
  end
end
registerEvent("FromClient_WaitCommentCreated", "FromClient_WaitCommentCreated")
