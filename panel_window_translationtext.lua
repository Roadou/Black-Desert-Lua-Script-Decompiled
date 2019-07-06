Panel_Window_TranslationText:SetShow(false)
local UI_TM = CppEnums.TextMode
PaGlobal_TranslationText = {
  btn_Close = UI.getChildControl(Panel_Window_TranslationText, "Button_Win_Close"),
  desc1 = UI.getChildControl(Panel_Window_TranslationText, "StaticText_Desc1"),
  desc2 = UI.getChildControl(Panel_Window_TranslationText, "StaticText_Desc2"),
  desc3 = UI.getChildControl(Panel_Window_TranslationText, "StaticText_Desc3"),
  num1 = UI.getChildControl(Panel_Window_TranslationText, "StaticText_Number1"),
  num2 = UI.getChildControl(Panel_Window_TranslationText, "StaticText_Number2"),
  num3 = UI.getChildControl(Panel_Window_TranslationText, "StaticText_Number3"),
  nonBG1 = UI.getChildControl(Panel_Window_TranslationText, "StaticText_NonBG1"),
  nonBG2 = UI.getChildControl(Panel_Window_TranslationText, "StaticText_NonBG2"),
  nonBG3 = UI.getChildControl(Panel_Window_TranslationText, "StaticText_NonBG3"),
  tooltipbg = UI.getChildControl(Panel_Window_TranslationText, "Static_ItemTooltip")
}
PaGlobal_TranslationText.itemdesc = UI.getChildControl(PaGlobal_TranslationText.tooltipbg, "StaticText_ItemDesc")
function PaGlobal_TranslationText:Initialize()
  self.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_TranslationText:MouseActionClick()")
  self.desc1:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.desc1:SetText("BaseFont_8 : \224\184\158\224\184\181\224\185\136 \224\185\128\224\184\165\224\184\181\224\185\137\224\184\162\224\184\135 \224\185\128\224\184\132\224\184\163\224\184\183\224\185\136\224\184\173\224\184\135 \224\184\138\224\184\177\224\185\137\224\184\153 \224\184\138\224\184\181\224\185\137")
  self.desc2:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.desc2:SetText("BaseFont_10 : \224\184\158\224\184\181\224\185\136 \224\185\128\224\184\165\224\184\181\224\185\137\224\184\162\224\184\135 \224\185\128\224\184\132\224\184\163\224\184\183\224\185\136\224\184\173\224\184\135 \224\184\138\224\184\177\224\185\137\224\184\153 \224\184\138\224\184\181\224\185\137")
  self.desc3:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.desc3:SetText("BaseFont_12 : \224\184\158\224\184\181\224\185\136 \224\185\128\224\184\165\224\184\181\224\185\137\224\184\162\224\184\135 \224\185\128\224\184\132\224\184\163\224\184\183\224\185\136\224\184\173\224\184\135 \224\184\138\224\184\177\224\185\137\224\184\153 \224\184\138\224\184\181\224\185\137")
  self.nonBG1:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.nonBG1:SetText("BaseFont_8 : \224\184\158\224\184\181\224\185\136 \224\185\128\224\184\165\224\184\181\224\185\137\224\184\162\224\184\135 \224\185\128\224\184\132\224\184\163\224\184\183\224\185\136\224\184\173\224\184\135 \224\184\138\224\184\177\224\185\137\224\184\153 \224\184\138\224\184\181\224\185\137")
  self.nonBG2:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.nonBG2:SetText("BaseFont_10 : \224\184\158\224\184\181\224\185\136 \224\185\128\224\184\165\224\184\181\224\185\137\224\184\162\224\184\135 \224\185\128\224\184\132\224\184\163\224\184\183\224\185\136\224\184\173\224\184\135 \224\184\138\224\184\177\224\185\137\224\184\153 \224\184\138\224\184\181\224\185\137")
  self.nonBG3:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.nonBG3:SetText("BaseFont_12 : \224\184\158\224\184\181\224\185\136 \224\185\128\224\184\165\224\184\181\224\185\137\224\184\162\224\184\135 \224\185\128\224\184\132\224\184\163\224\184\183\224\185\136\224\184\173\224\184\135 \224\184\138\224\184\177\224\185\137\224\184\153 \224\184\138\224\184\181\224\185\137")
  self.num1:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.num1:SetText("BaseFont_8 : 10,234,567,890")
  self.num2:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.num2:SetText("BaseFont_10 : 10,234,567,890")
  self.num3:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.num3:SetText("BaseFont_12 : 10,234,567,890")
  self.itemdesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.itemdesc:SetText("<PAColor0xff748cab>- \234\183\128\236\134\141\235\144\168(\234\176\128\235\172\184)<PAOldColor>\n- \234\176\156\236\157\184 \234\177\176\235\158\152 \235\182\136\234\176\128\n\n- \236\155\140\235\166\172\236\150\180, \235\160\136\236\157\184\236\160\128, \236\134\140\236\132\156\235\159\172, \236\158\144\236\157\180\236\150\184\237\138\184, \234\184\136\236\136\152\235\158\145, \235\172\180\236\130\172, \235\167\164\237\153\148, \235\176\156\237\130\164\235\166\172, \236\191\160\235\133\184\236\157\180\236\185\152, \235\139\140\236\158\144, \235\139\164\237\129\172\235\130\152\236\157\180\237\138\184, \236\156\132\236\158\144\235\147\156, \236\156\132\236\185\152 \236\160\132\236\154\169\n\n<PAColor0xffc4a68a>- \236\132\164\235\170\133 : \235\170\168\237\151\152\234\176\128\236\157\152 \236\153\184\237\152\149\236\157\132 \234\190\184\235\169\176\236\163\188\235\138\148 \235\172\180\234\184\176, \235\179\180\236\161\176 \235\172\180\234\184\176, \236\157\152\236\131\129\236\157\180 \235\139\180\234\178\168 \236\158\136\235\138\148 \236\131\129\236\158\144\235\165\188 \237\154\141\235\147\157\237\149\160 \236\136\152 \236\158\136\235\139\164. \235\167\136\236\154\176\236\138\164 \236\154\176\237\129\180\235\166\173\236\156\188\235\161\156 \236\130\172\236\154\169 \236\139\156 \236\167\129\236\151\133\236\151\144 \235\167\158\235\138\148 \236\157\152\236\131\129\236\157\132 \237\154\141\235\147\157\237\149\160 \236\136\152 \236\158\136\235\139\164.<PAOldColor>\n\n- \237\140\144\235\167\164\234\176\128 : \237\140\144\235\167\164 \235\182\136\234\176\128")
end
function PaGlobal_TranslationText:Update()
  self.desc2:SetPosY(self.desc1:GetPosY() + self.desc1:GetTextSizeY() + 10)
  self.desc3:SetPosY(self.desc2:GetPosY() + self.desc2:GetTextSizeY() + 10)
  self.nonBG2:SetPosY(self.nonBG1:GetPosY() + self.nonBG1:GetTextSizeY() + 10)
  self.nonBG3:SetPosY(self.nonBG2:GetPosY() + self.nonBG2:GetTextSizeY() + 10)
  self.num2:SetPosY(self.num1:GetPosY() + self.num1:GetTextSizeY() + 10)
  self.num3:SetPosY(self.num2:GetPosY() + self.num2:GetTextSizeY() + 10)
end
function PaGlobal_TranslationText:Open()
  Panel_Window_TranslationText:SetShow(true)
  Panel_Window_TranslationText:ComputePos()
  PaGlobal_TranslationText:Update()
end
function PaGlobal_TranslationText:MouseActionClick()
  Panel_Window_TranslationText:SetShow(false)
end
PaGlobal_TranslationText:Initialize()
