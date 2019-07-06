local StaticText_Category_Template = UI.getChildControl(Panel_CustomizationFrame, "StaticText_Category_Template")
local Button_ShowDetail_Template = UI.getChildControl(Panel_CustomizationFrame, "Button_ShowDetail_Template")
local Button_Close = UI.getChildControl(Panel_CustomizationFrame, "Button_Close")
local Panel_Child = UI.getChildControl(Panel_CustomizationFrame, "Panel_Child")
local CheckButton_UseFaceCustomizationHair = UI.getChildControl(Panel_CustomizationFrame, "CheckButton_UseFaceCustomizationHair")
local StaticText_UseFaceCustomizationHair = UI.getChildControl(Panel_CustomizationFrame, "StaticText_UseFaceCustomizationHair")
StaticText_UseFaceCustomizationHair:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONFRAME_USEFACECUSTOMIZATIONHAIR"))
Button_Close:addInputEvent("Mouse_LUp", "CloseFrame()")
if false == _ContentsGroup_RenewUI_Customization then
  registerEvent("EventCloseFrame", "CloseFrame")
  registerEvent("EventOpenCustomizationUiGroupFrame", "OpenCustomizationUiGroupFrame")
  registerEvent("EventCloseCustomizationUiGroupFrame", "CloseCustomizationUiGroupFrame")
end
CheckButton_UseFaceCustomizationHair:addInputEvent("Mouse_LUp", "CheckFaceCustomizationHair()")
CheckButton_UseFaceCustomizationHair:SetCheck(false)
g_selectedPart = 0
g_selectedPanel = nil
local panelGapWidth = 10
local panelGapHeight = 8
local customizationPartControl = {}
local partNum = 0
local partControlButtonHeight = StaticText_Category_Template:GetSizeY()
local radioButtonTextureName = "new_ui_common_forlua/Window/Lobby/cus_buttons.dds"
local isTatooCheckContry = isGameTypeKR2()
local isTatooGroup = false
local tatooIndex = 0
local function clearGroupFrame()
  for partIndex = 1, partNum do
    if ChekcTatoo_PossibleContry(partIndex, true) then
      customizationPartControl[partIndex].button:SetShow(false)
      customizationPartControl[partIndex].text:SetShow(false)
      UI.deleteControl(customizationPartControl[partIndex].button)
      UI.deleteControl(customizationPartControl[partIndex].text)
    end
  end
  partNum = 0
  g_selectedPart = 0
  g_selectedPanel = nil
  customizationPartControl = {}
end
local function radioButtonOnOff(part, on)
  if part == 0 or part > partNum then
    return
  end
  local selectedButtonControl = customizationPartControl[part].button
  if on == true then
    selectedButtonControl:ChangeTextureInfoName(radioButtonTextureName)
    local x1, y1, x2, y2 = setTextureUV_Func(selectedButtonControl, 1, 23, 21, 43)
    selectedButtonControl:getBaseTexture():setUV(x1, y1, x2, y2)
    selectedButtonControl:setRenderTexture(selectedButtonControl:getBaseTexture())
    selectedButtonControl:ChangeOnTextureInfoName(radioButtonTextureName)
    local x1, y1, x2, y2 = setTextureUV_Func(selectedButtonControl, 22, 23, 42, 43)
    selectedButtonControl:getOnTexture():setUV(x1, y1, x2, y2)
    selectedButtonControl:ChangeClickTextureInfoName(radioButtonTextureName)
    local x1, y1, x2, y2 = setTextureUV_Func(selectedButtonControl, 43, 23, 63, 43)
    selectedButtonControl:getClickTexture():setUV(x1, y1, x2, y2)
  else
    selectedButtonControl:ChangeTextureInfoName(radioButtonTextureName)
    local x1, y1, x2, y2 = setTextureUV_Func(selectedButtonControl, 1, 1, 21, 21)
    selectedButtonControl:getBaseTexture():setUV(x1, y1, x2, y2)
    selectedButtonControl:setRenderTexture(selectedButtonControl:getBaseTexture())
    selectedButtonControl:ChangeOnTextureInfoName(radioButtonTextureName)
    local x1, y1, x2, y2 = setTextureUV_Func(selectedButtonControl, 22, 1, 42, 21)
    selectedButtonControl:getOnTexture():setUV(x1, y1, x2, y2)
    selectedButtonControl:ChangeClickTextureInfoName(radioButtonTextureName)
    local x1, y1, x2, y2 = setTextureUV_Func(selectedButtonControl, 43, 1, 63, 21)
    selectedButtonControl:getClickTexture():setUV(x1, y1, x2, y2)
  end
end
function SelectControlPart(partIndex)
  Panel_Child:SetShow(false)
  if g_selectedPart ~= 0 then
    radioButtonOnOff(g_selectedPart, false)
  end
  if g_selectedPanel ~= nil then
    g_selectedPanel:MoveChilds(g_selectedPanel:GetID(), Panel_Child)
    g_selectedPanel:SetShow(false)
    g_selectedPanel = nil
  end
  if g_selectedPart ~= partIndex + 1 then
    g_selectedPart = partIndex + 1
    radioButtonOnOff(g_selectedPart, true)
    selectCustomizationControlPart(partIndex)
  elseif g_selectedPart ~= 0 then
    g_selectedPart = 0
    updateGroupFrameControls(0, nil)
    selectCustomizationControlPart(-1)
  end
end
function updateGroupFrameControls(selectedPartSpaceLength, selectedPanel)
  EnableCursor(false)
  if selectedPanel ~= nil then
    selectedPanel:SetIgnore(true)
    Panel_Child:MoveChilds(Panel_Child:GetID(), selectedPanel)
    Panel_Child:SetShow(true)
  end
  g_selectedPanel = selectedPanel
  local textOffsetY = customizationPartControl[1].text:GetPosY()
  local buttonGap = 2
  for partIndex = 1, partNum do
    if ChekcTatoo_PossibleContry(partIndex, true) then
      local buttonOffsetY = textOffsetY + buttonGap
      customizationPartControl[partIndex].text:SetPosY(textOffsetY)
      customizationPartControl[partIndex].button:SetPosY(buttonOffsetY)
      textOffsetY = textOffsetY + partControlButtonHeight
      if partIndex == g_selectedPart then
        local selectedPanelHeight = g_selectedPanel:GetSizeY()
        Panel_Child:SetPosX(panelGapWidth)
        Panel_Child:SetPosY(panelGapHeight + textOffsetY)
        Panel_Child:SetSize(Panel_Child:GetSizeX(), selectedPanelHeight)
        textOffsetY = textOffsetY + panelGapHeight + selectedPanelHeight + panelGapHeight
      end
    end
  end
  Panel_CustomizationFrame:SetSize(Panel_CustomizationFrame:GetSizeX(), textOffsetY + 4)
end
function GetChildPanelPosX()
  return Panel_CustomizationFrame:GetPosX() + Panel_Child:GetPosX()
end
function GetChildPanelPosY()
  return Panel_CustomizationFrame:GetPosY() + Panel_Child:GetPosY()
end
function CloseFrameSlide()
  SelectControlPart(-1)
  clearGroupFrame()
  selectCustomizationControlPart(-1)
  selectCustomizationControlGroup(-1)
end
function CloseFrame()
  if Panel_CustomizationImage:GetShow() then
    CloseTextureUi()
    return
  end
  EnableCursor(false)
  SelectControlPart(-1)
  Panel_CustomizationFrame:SetShow(false, false)
  clearGroupFrame()
  selectCustomizationControlPart(-1)
  selectCustomizationControlGroup(-1)
  CustomizationMainUIShow(true)
end
function CloseFrameForPoseUI()
  Panel_CustomizationFrame:SetShow(false)
  clearGroupFrame()
end
function faceHairCustomUpdate(faceHair)
  CheckButton_UseFaceCustomizationHair:SetCheck(faceHair)
end
function CheckFaceCustomizationHair()
  setUseFaceCustomizationHair(CheckButton_UseFaceCustomizationHair:IsCheck())
end
function OpenCustomizationUiGroupFrame(uiGroupIndex)
  if true == _ContentsGroup_RenewUI_Customization then
    return
  end
  ClearFocusEdit()
  clearGroupFrame()
  if uiGroupIndex == 1 then
    CheckFaceCustomizationHair()
    CheckButton_UseFaceCustomizationHair:SetShow(true)
    StaticText_UseFaceCustomizationHair:SetShow(true)
  else
    CheckButton_UseFaceCustomizationHair:SetShow(false)
    StaticText_UseFaceCustomizationHair:SetShow(false)
  end
  if 1 == uiGroupIndex or 2 == uiGroupIndex then
    isTatooGroup = true
  else
    isTatooGroup = false
  end
  partNum = getUiPartCount(uiGroupIndex)
  for uiPartIndex = 0, partNum - 1 do
    local partName = getUiPartDescName(uiGroupIndex, uiPartIndex)
    if partName == "XML_CUSTOMIZATION_TATTOO" then
      tatooIndex = uiPartIndex
      break
    end
  end
  for uiPartIndex = 0, partNum - 1 do
    if ChekcTatoo_PossibleContry(uiPartIndex, false) then
      local luaUiPartIndex = uiPartIndex + 1
      local partName = getUiPartDescName(uiGroupIndex, uiPartIndex)
      local tempGroup = {button, text}
      local tempStaticText = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_CustomizationFrame, "StaticText_Category_" .. uiPartIndex)
      CopyBaseProperty(StaticText_Category_Template, tempStaticText)
      tempStaticText:SetText(PAGetString(Defines.StringSheet_GAME, partName))
      tempStaticText:SetShow(true)
      tempStaticText:SetPosY(StaticText_Category_Template:GetPosY() + uiPartIndex * partControlButtonHeight)
      local tempButton = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_CustomizationFrame, "Button_ShowDetail_" .. uiPartIndex)
      CopyBaseProperty(Button_ShowDetail_Template, tempButton)
      tempButton:SetShow(true)
      tempButton:SetPosY(Button_ShowDetail_Template:GetPosY() + uiPartIndex * partControlButtonHeight)
      tempButton:addInputEvent("Mouse_LUp", "SelectControlPart(" .. uiPartIndex .. ")")
      tempGroup.text = tempStaticText
      tempGroup.button = tempButton
      customizationPartControl[luaUiPartIndex] = tempGroup
    end
  end
  SelectControlPart(0)
  Panel_CustomizationFrame:SetShow(true, false)
end
function toggleShowFrameUI(show)
  Panel_CustomizationFrame:SetShow(show)
end
function ChekcTatoo_PossibleContry(uiPartIndex, isContainer)
  local plusIndex = 0
  if isContainer then
    plusIndex = 1
  end
  local isTatoo = false == isTatooGroup or false == isTatooCheckContry or tatooIndex + plusIndex ~= uiPartIndex and isTatooCheckContry
  return isTatoo
end
