function PaGloabl_BlackSpiritSkillSelect_Open()
  PaGloabl_BlackSpiritSkillSelect:prepareOpen()
end
function PaGloabl_BlackSpiritSkillSelect_Close()
  PaGloabl_BlackSpiritSkillSelect:prepareClose()
end
function HandleEventLUp_BlackSpiritSkillSelect_Apply()
  PaGloabl_BlackSpiritSkillSelect:CheckBoxSelect()
end
function HandleEventLUp_BlackSpiritSkillSelect_Cancel()
  PaGloabl_BlackSpiritSkillSelect_Close()
end
function HandleEventLUp_BlackSpiritSkillSelect_ChangeIndex(idx)
  UI.ASSERT_NAME(nil ~= idx, "HandleEventLUp_BlackSpiritSkillSelect_ChangeSkin\236\157\152 idx nil\236\157\180\235\169\180 \236\149\136\235\144\156\235\139\164.", "\234\185\128\236\156\164\236\167\128")
  local total = ToClient_getBlackSpiritFromInfoList()
  PaGloabl_BlackSpiritSkillSelect._blackSpiritKey = ToClient_getBlackSpiritFromInfoByIndex(idx)
  for index = 0, total - 1 do
    local x1, y1, x2, y
    if index == idx then
      x1, y1, x2, y2 = setTextureUV_Func(PaGloabl_BlackSpiritSkillSelect._control[index], 415, 1, 620, 620)
    else
      x1, y1, x2, y2 = setTextureUV_Func(PaGloabl_BlackSpiritSkillSelect._control[index], 1, 1, 206, 206)
    end
    PaGloabl_BlackSpiritSkillSelect._control[index]:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGloabl_BlackSpiritSkillSelect._control[index]:setRenderTexture(PaGloabl_BlackSpiritSkillSelect._control[index]:getBaseTexture())
  end
end
function FromClient_BlackSpiritSkillSelect_ReSizePanel()
  Panel_Widget_BlackSpirit_SkillSelect:SetSize(getScreenSizeX(), getScreenSizeY())
  PaGloabl_BlackSpiritSkillSelect:ControlComputePos()
  if nil ~= PaGloabl_BlackSpiritSkillSelect._control[0] then
    PaGloabl_BlackSpiritSkillSelect._control[0]:SetSize(PaGloabl_BlackSpiritSkillSelect._ui._btn_skinSelect:GetSizeX(), PaGloabl_BlackSpiritSkillSelect._ui._btn_skinSelect:GetSizeY())
    PaGloabl_BlackSpiritSkillSelect._control[0]:SetPosX(PaGloabl_BlackSpiritSkillSelect._ui._btn_skinSelect:GetPosX())
    PaGloabl_BlackSpiritSkillSelect._control[0]:SetPosY(PaGloabl_BlackSpiritSkillSelect._ui._btn_skinSelect:GetPosY())
    PaGloabl_BlackSpiritSkillSelect._defaultPosX = PaGloabl_BlackSpiritSkillSelect._ui._btn_skinSelect:GetPosX()
  end
end
function PaGloabl_BlackSpiritSkillSelect_ShowAni()
  if nil == Panel_Widget_BlackSpirit_SkillSelect then
    return
  end
end
function PaGloabl_BlackSpiritSkillSelect_HideAni()
  if nil == Panel_Widget_BlackSpirit_SkillSelect then
    return
  end
end
