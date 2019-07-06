Panel_Window_AutoQuest:SetShow(false)
PaGlobal_AutoQuest = {
  _ui = {
    _btn_BlackSpirit = UI.getChildControl(Panel_Window_AutoQuest, "Button_BlackSpiritQuest"),
    _btn_BattleQuest = UI.getChildControl(Panel_Window_AutoQuest, "Button_BattleQuest"),
    _checkBtn_Potion = UI.getChildControl(Panel_Window_AutoQuest, "CheckButton_PotionUse")
  }
}
function PaGlobal_AutoQuest:Initialize()
  self._ui._btn_BlackSpirit:addInputEvent("Mouse_LUp", "PaGlobal_AutoQuest:StartBlackSpiritQuest()")
  self._ui._btn_BattleQuest:addInputEvent("Mouse_LUp", "PaGlobal_AutoQuest:EndBlackSpiritQuest()")
end
local index = 0
function PaGlobal_AutoQuest:StartBlackSpiritQuest()
  local message = ""
  if index == 0 then
    message = "\236\132\177\236\177\132 \234\177\180\236\132\164 \234\176\128\235\138\165 \236\167\128\236\151\173\236\157\132 \235\178\151\236\150\180\235\130\172\236\150\180! \235\143\140\236\149\132\234\176\128 \235\169\141\236\182\169\236\149\132"
  elseif index == 1 then
    message = "\237\149\152\235\163\168 \237\149\156\235\178\136 \237\138\185\235\179\132\237\149\156 \236\139\156\234\176\132! \236\167\145\236\164\145\236\160\132\237\136\172 \227\133\139"
  elseif index == 2 then
    message = "\237\154\140\236\160\132 \234\176\128\235\165\180\234\184\176 \235\143\140\236\167\132\236\176\140\235\165\180\234\184\176 \234\185\138\234\178\140\236\176\140\235\165\180\234\184\176 \234\176\149\237\131\128 \236\158\161\236\149\132\235\169\148\236\185\152\234\184\176"
  elseif index == 3 then
    message = "\234\178\140\236\139\156\237\140\144 \236\157\188\236\160\149 \235\139\172\235\160\165 \236\158\133\236\130\172\235\169\180\236\160\145 \236\157\188\236\160\149 \235\182\128\236\158\172\236\164\146\227\133\135 \236\149\140\235\166\188"
    index = 0
  end
  FGlobal_AutoQuestBlackSpiritMessage(message)
  index = index + 1
end
function PaGlobal_AutoQuest:EndBlackSpiritQuest()
  FGlobal_EndBlackSpiritMessage()
end
PaGlobal_AutoQuest:Initialize()
