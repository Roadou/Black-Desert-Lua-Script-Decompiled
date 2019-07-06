function HandleEventLUp_CommandGuide_ShowGuide()
  if nil == Panel_CommandGuide then
    return
  end
  local isShowToggle = PaGlobal_CommandGuide._ui._btn_showToggle:IsCheck()
  PaGlobal_CommandGuide._ui._stc_commandBg:SetShow(not isShowToggle)
end
function PaGlobal_CommandGuide_Show(isShow, showType)
  if nil == Panel_CommandGuide then
    return
  end
  if nil == isShow then
    UI_ASSERT_NAME(nil ~= isShow, "CommandGuide \236\188\156\234\179\160/\235\129\132\234\179\160 \237\149\180\236\164\132\235\157\188\235\138\148\235\141\176 \237\140\140\235\158\140\234\176\146\236\157\180 \236\151\134\235\139\164!!!!! \236\157\180\235\159\172\235\169\180 \236\149\136\235\143\188!", "\236\160\149\237\131\156\234\179\164")
  end
  if nil == showType then
    UI_ASSERT_NAME(nil ~= showType, "CommandGuide \236\188\156\234\179\160/\235\129\132\234\179\160 \237\149\180\236\164\132\235\157\188\235\138\148\235\141\176 \237\140\140\235\158\140\234\176\146\236\157\180 \236\151\134\235\139\164!!!!! \236\157\180\235\159\172\235\169\180 \236\149\136\235\143\188!", "\236\160\149\237\131\156\234\179\164")
  end
  PaGlobal_CommandGuide._isShowType = showType
  if true == isShow then
    PaGlobal_CommandGuide:prepareOpen()
    PaGlobal_CommandGuide:setData()
  else
    PaGlobal_CommandGuide:close()
  end
end
