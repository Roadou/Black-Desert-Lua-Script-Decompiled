function PaGlobal_Guide:initialize()
  if nil == LobbyInstance_Window_Guide then
    return
  end
  if true == PaGlobal_Guide._initialize then
    return
  end
  PaGlobal_Guide._ui._btn_close = UI.getChildControl(PaGlobal_Guide._ui._stc_headerGroup, "Button_Close")
  PaGlobal_Guide._ui._tabBtnGroup = {}
  PaGlobal_Guide._ui._tabBtnGroup[1] = UI.getChildControl(PaGlobal_Guide._ui._stc_topGroup, "RadioButton_Tab_1")
  PaGlobal_Guide._ui._tabBtnGroup[2] = UI.getChildControl(PaGlobal_Guide._ui._stc_topGroup, "RadioButton_Tab_2")
  PaGlobal_Guide._ui._tabBtnGroup[3] = UI.getChildControl(PaGlobal_Guide._ui._stc_topGroup, "RadioButton_Tab_3")
  PaGlobal_Guide._ui._radiobtn_subtitle1 = UI.getChildControl(PaGlobal_Guide._ui._stc_contentGroup, "RadioButton_Tab_Subtitle_1")
  PaGlobal_Guide._ui._radiobtn_subtitle2 = UI.getChildControl(PaGlobal_Guide._ui._stc_contentGroup, "RadioButton_Tab_Subtitle_2")
  local contentPosY = 0
  for index = 1, PaGlobal_Guide._MAX_DESC_COUNT do
    PaGlobal_Guide._ui.descBg[index] = UI.getChildControl(PaGlobal_Guide._ui._stc_contentGroup, "Static_DescBg_" .. index)
    PaGlobal_Guide._descMaskingSizeY[index] = 0
    PaGlobal_Guide._ui.descGroup[index].desc = {}
    for subIdx = 1, PaGlobal_Guide.categoryInfo[index][2] do
      PaGlobal_Guide._ui.descGroup[index].desc[subIdx] = UI.getChildControl(PaGlobal_Guide._ui.descBg[index], "StaticText_Desc" .. subIdx)
      PaGlobal_Guide._ui.descGroup[index].desc[subIdx]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      PaGlobal_Guide._ui.descGroup[index].desc[subIdx]:SetText(PAGetString(Defines.StringSheet_RESOURCE, PaGlobal_Guide.categoryInfo[index][1] .. tostring(subIdx)))
      PaGlobal_Guide._ui.descGroup[index].desc[subIdx]:SetSize(650, PaGlobal_Guide._ui.descGroup[index].desc[subIdx]:GetTextSizeY())
      PaGlobal_Guide._ui.descGroup[index].desc[subIdx]:SetSpanSize(0, PaGlobal_Guide._descMaskingSizeY[index])
      PaGlobal_Guide._descMaskingSizeY[index] = PaGlobal_Guide._descMaskingSizeY[index] + PaGlobal_Guide._ui.descGroup[index].desc[subIdx]:GetTextSizeY() + 10
      if PaGlobal_Guide._ui.descBg[index]:GetSizeY() - 10 < PaGlobal_Guide._descMaskingSizeY[index] then
        local tempPosY = PaGlobal_Guide._descMaskingSizeY[index] - (PaGlobal_Guide._ui.descBg[index]:GetSizeY() - 10)
        contentPosY = tempPosY
      end
    end
  end
  PaGlobal_Guide._ui._stc_contentGroup:SetSize(PaGlobal_Guide._ui._stc_contentGroup:GetSizeX(), PaGlobal_Guide._ui._stc_contentGroup:GetSizeY() + contentPosY)
  LobbyInstance_Window_Guide:SetSize(LobbyInstance_Window_Guide:GetSizeX(), LobbyInstance_Window_Guide:GetSizeY() + contentPosY)
  LobbyInstance_Window_Guide:ComputePos()
  PaGlobal_Guide:registEventHandler()
  PaGlobal_Guide:update()
end
function PaGlobal_Guide:registEventHandler()
  PaGlobal_Guide._ui._btn_close:addInputEvent("Mouse_LUp", "HandleEventLUp_Guide_Close()")
  for index = 1, #PaGlobal_Guide._ui._tabBtnGroup do
    PaGlobal_Guide._ui._tabBtnGroup[index]:addInputEvent("Mouse_LUp", "HandleEventLUp_Guide_ShowTab(" .. index .. ")")
  end
  PaGlobal_Guide._ui._radiobtn_subtitle1:addInputEvent("Mouse_LUp", "HandleEventLUp_Guide_ShowSubTab(1)")
  PaGlobal_Guide._ui._radiobtn_subtitle2:addInputEvent("Mouse_LUp", "HandleEventLUp_Guide_ShowSubTab(2)")
end
function PaGlobal_Guide:open()
  LobbyInstance_Window_Guide:SetShow(true)
end
function PaGlobal_Guide:close()
  LobbyInstance_Window_Guide:SetShow(false)
end
function PaGlobal_Guide:showTab(index)
  PaGlobal_Guide._nowIndex = index
  PaGlobal_Guide._nowSubIndex = 1
  PaGlobal_Guide:update()
end
function PaGlobal_Guide:showSubTab(index)
  PaGlobal_Guide._nowSubIndex = index
  PaGlobal_Guide:update()
end
function PaGlobal_Guide:update()
  if nil == PaGlobal_Guide._nowIndex then
    PaGlobal_Guide._nowIndex = 1
  end
  if nil == PaGlobal_Guide._nowSubIndex then
    PaGlobal_Guide._nowSubIndex = 1
  end
  for index = 1, PaGlobal_Guide._MAX_DESC_COUNT do
    PaGlobal_Guide._ui.descBg[index]:SetShow(false)
  end
  for index = 1, #PaGlobal_Guide._ui._tabBtnGroup do
    if index == PaGlobal_Guide._nowIndex then
      PaGlobal_Guide._ui._tabBtnGroup[index]:SetCheck(true)
    else
      PaGlobal_Guide._ui._tabBtnGroup[index]:SetCheck(false)
    end
  end
  PaGlobal_Guide._ui._radiobtn_subtitle1:SetCheck(false)
  PaGlobal_Guide._ui._radiobtn_subtitle2:SetCheck(false)
  PaGlobal_Guide._ui._radiobtn_subtitle2:SetShow(true)
  if 1 == PaGlobal_Guide._nowIndex then
    PaGlobal_Guide._ui._radiobtn_subtitle1:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LOBBYINSTANCE_GUIDE_TITLE"))
    PaGlobal_Guide._ui._radiobtn_subtitle2:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LOBBYINSTANCE_GUIDE_RULE"))
    if 1 == PaGlobal_Guide._nowSubIndex then
      PaGlobal_Guide._ui._radiobtn_subtitle1:SetCheck(true)
      PaGlobal_Guide._ui.descBg[1]:SetShow(true)
    else
      PaGlobal_Guide._ui._radiobtn_subtitle2:SetCheck(true)
      PaGlobal_Guide._ui.descBg[2]:SetShow(true)
    end
  elseif 2 == PaGlobal_Guide._nowIndex then
    PaGlobal_Guide._ui._radiobtn_subtitle1:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LOBBYINSTANCE_GUIDE_DEFAULT_GUIDE"))
    PaGlobal_Guide._ui._radiobtn_subtitle2:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LOBBYINSTANCE_GUIDE_SHORTCUT"))
    if 1 == PaGlobal_Guide._nowSubIndex then
      PaGlobal_Guide._ui._radiobtn_subtitle1:SetCheck(true)
      PaGlobal_Guide._ui.descBg[3]:SetShow(true)
    else
      PaGlobal_Guide._ui._radiobtn_subtitle2:SetCheck(true)
      PaGlobal_Guide._ui.descBg[4]:SetShow(true)
    end
  elseif 3 == PaGlobal_Guide._nowIndex then
    PaGlobal_Guide._ui._radiobtn_subtitle1:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LOBBYINSTANCE_GUIDE_REWARD"))
    PaGlobal_Guide._ui._radiobtn_subtitle1:SetCheck(true)
    PaGlobal_Guide._ui._radiobtn_subtitle2:SetShow(false)
    PaGlobal_Guide._ui.descBg[5]:SetShow(true)
  end
  PaGlobal_Guide._ui._radiobtn_subtitle1:SetSize(PaGlobal_Guide._ui._radiobtn_subtitle1:GetTextSizeX() + 50, PaGlobal_Guide._ui._radiobtn_subtitle1:GetSizeY())
  PaGlobal_Guide._ui._radiobtn_subtitle2:SetSize(PaGlobal_Guide._ui._radiobtn_subtitle2:GetTextSizeX() + 50, PaGlobal_Guide._ui._radiobtn_subtitle2:GetSizeY())
  PaGlobal_Guide._ui._radiobtn_subtitle2:SetPosX(PaGlobal_Guide._ui._radiobtn_subtitle1:GetPosX() + PaGlobal_Guide._ui._radiobtn_subtitle1:GetSizeX() + 10)
end
function PaGlobal_Guide_Open()
  PaGlobal_Guide:open()
end
function PaGlobal_Guide_Close()
  PaGlobal_Guide:close()
end
