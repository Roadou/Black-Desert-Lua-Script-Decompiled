Panel_Scroll:SetShow(false, false)
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
UIScrollButton = {
  static_upAni = UI.getChildControl(Panel_Scroll, "Static_Up_Ani"),
  button_up = UI.getChildControl(Panel_Scroll, "Button_Up"),
  static_downAni = UI.getChildControl(Panel_Scroll, "Static_Down_Ani"),
  button_down = UI.getChildControl(Panel_Scroll, "Button_Down"),
  currentPanel = nil
}
local staticUpAni = {}
local buttonUp = {}
local staticDownAni = {}
local buttonDown = {}
function UIScrollButton.CreateScrollButton(parentPanel)
  local panelName = tostring(parentPanel:GetID())
  if nil == staticUpAni[panelName] then
    staticUpAni[panelName] = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, parentPanel, "Static_Up_Ani_" .. panelName)
    CopyBaseProperty(UIScrollButton.static_upAni, staticUpAni[panelName])
    staticUpAni[panelName]:SetNotAbleMasking(true)
  end
  if nil == buttonUp[panelName] then
    buttonUp[panelName] = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, parentPanel, "Button_Up_" .. panelName)
    CopyBaseProperty(UIScrollButton.button_up, buttonUp[panelName])
    buttonUp[panelName]:addInputEvent("Mouse_LUp", "UIScrollButton.ScrollMoveEvent(" .. panelName .. ",'up')")
    buttonUp[panelName]:SetNotAbleMasking(true)
  end
  if nil == staticDownAni[panelName] then
    staticDownAni[panelName] = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, parentPanel, "Static_Down_Ani_" .. panelName)
    CopyBaseProperty(UIScrollButton.static_downAni, staticDownAni[panelName])
    staticDownAni[panelName]:SetNotAbleMasking(true)
  end
  if nil == buttonDown[panelName] then
    buttonDown[panelName] = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, parentPanel, "Button_Down_" .. panelName)
    CopyBaseProperty(UIScrollButton.button_down, buttonDown[panelName])
    buttonDown[panelName]:addInputEvent("Mouse_LUp", "UIScrollButton.ScrollMoveEvent(" .. panelName .. ",'down')")
    buttonDown[panelName]:SetNotAbleMasking(true)
  end
end
function UIScrollButton.ScrollButtonEvent(isShow, parentPanel, targetUI, targetScroll)
  local panelName = tostring(parentPanel:GetID())
  UIScrollButton.CreateScrollButton(parentPanel)
  if isShow and targetScroll:GetShow() then
    staticUpAni[panelName]:SetPosX(targetUI:GetSizeX() / 2 - staticUpAni[panelName]:GetSizeX() / 2)
    staticUpAni[panelName]:SetPosY(targetUI:GetPosY() - 8)
    buttonUp[panelName]:SetPosX(targetUI:GetSizeX() / 2 - buttonUp[panelName]:GetSizeX() / 2)
    buttonUp[panelName]:SetPosY(targetUI:GetPosY() - 6)
    staticDownAni[panelName]:SetPosX(targetUI:GetSizeX() / 2 - staticDownAni[panelName]:GetSizeX() / 2)
    staticDownAni[panelName]:SetPosY(targetUI:GetPosY() + targetUI:GetSizeY() - 6)
    buttonDown[panelName]:SetPosX(targetUI:GetSizeX() / 2 - buttonDown[panelName]:GetSizeX() / 2)
    buttonDown[panelName]:SetPosY(targetUI:GetPosY() + targetUI:GetSizeY())
    if 0 == targetScroll:GetControlPos() then
      staticUpAni[panelName]:SetShow(false)
      buttonUp[panelName]:SetShow(false)
    else
      staticUpAni[panelName]:SetShow(true)
      buttonUp[panelName]:SetShow(true)
      staticUpAni[panelName]:ResetVertexAni()
      staticUpAni[panelName]:SetVertexAniRun("Ani_Color_Up", true)
    end
    if 1 == targetScroll:GetControlPos() then
      staticDownAni[panelName]:SetShow(false)
      buttonDown[panelName]:SetShow(false)
    else
      staticDownAni[panelName]:SetShow(true)
      buttonDown[panelName]:SetShow(true)
      staticDownAni[panelName]:ResetVertexAni()
      staticDownAni[panelName]:SetVertexAniRun("Ani_Color_Down", true)
    end
  else
    staticUpAni[panelName]:SetShow(false)
    buttonUp[panelName]:SetShow(false)
    staticDownAni[panelName]:SetShow(false)
    buttonDown[panelName]:SetShow(false)
  end
  if Panel_CheckedQuest == parentPanel then
    if targetScroll:GetShow() then
      if 0 == targetScroll:GetControlPos() then
        parentPanel:ChangeSpecialTextureInfoName("new_ui_common_forlua/widget/questlist/mask_down.dds")
      elseif 1 == targetScroll:GetControlPos() then
        parentPanel:ChangeSpecialTextureInfoName("new_ui_common_forlua/widget/questlist/mask_up.dds")
      else
        parentPanel:ChangeSpecialTextureInfoName("new_ui_common_forlua/widget/questlist/mask_all.dds")
      end
    else
      parentPanel:ChangeSpecialTextureInfoName("")
    end
  end
  UIScrollButton.currentPanel = parentPanel
end
function UIScrollButton.ScrollMoveEvent(parentPanel, moveDirection)
  if false == _ContentsGroup_RenewUI_Skill then
    if Panel_CheckedQuest == parentPanel then
      QuestList_ScrollMove(moveDirection)
    elseif Panel_Window_Quest_History == parentPanel then
      QuestHistory_ScrollMove(moveDirection)
    elseif Panel_Window_Skill == parentPanel then
      PaGlobal_Skill:Skill_ScrollMove(moveDirection)
    end
  elseif Panel_CheckedQuest == parentPanel then
    QuestList_ScrollMove(moveDirection)
  elseif Panel_Window_Quest_History == parentPanel then
    QuestHistory_ScrollMove(moveDirection)
  end
end
function UIScrollButton.Close()
  Panel_Scroll:SetShow(false)
end
