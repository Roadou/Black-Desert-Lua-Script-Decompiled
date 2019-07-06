local Button_Close = UI.getChildControl(Panel_CustomizationVoice, "Button_Close")
local static_Frame = UI.getChildControl(Panel_CustomizationVoice, "Static_Frame")
local Frame_ContentImage = UI.getChildControl(Panel_CustomizationVoice, "Frame_Content_Image")
local Static_PayMark = UI.getChildControl(Panel_CustomizationVoice, "Static_PayMark")
local StaticText_Title = UI.getChildControl(Panel_CustomizationVoice, "StaticText_Title")
local Static_SelectMark = UI.getChildControl(Panel_CustomizationVoice, "Static_SelectMark")
local StaticText_Slider = UI.getChildControl(Panel_CustomizationVoice, "StaticText_VoiceTitle")
local Slider_Voice = UI.getChildControl(Panel_CustomizationVoice, "Slider_VoiceSelectControl")
local Slider_Voice_Btn = UI.getChildControl(Slider_Voice, "Slider_VoiceSelect_CtrlButton")
local playVoice_Ctrl = UI.getChildControl(Panel_CustomizationVoice, "Button_ApplyVoice")
local voiceCountText = UI.getChildControl(Panel_CustomizationVoice, "StaticText_VoiceCount")
local staticTextVoiceLow = UI.getChildControl(Panel_CustomizationVoice, "StaticText_VoiceLow")
local staticTextVoiceHigh = UI.getChildControl(Panel_CustomizationVoice, "StaticText_VoiceHigh")
local frameScroll = UI.getChildControl(Panel_CustomizationVoice, "VerticalScroll")
local frameBtn = UI.getChildControl(frameScroll, "VerticalScroll_CtrlButton")
local StaticText_Motion = UI.getChildControl(Panel_CustomizationVoice, "StaticText_Motion")
local Frame_Content = UI.getChildControl(Panel_CustomizationVoice, "Frame_Content")
local Frame_ContentMotionImage = UI.getChildControl(Frame_Content, "Frame_Content_MotionImage")
local Static_SelectMotionMark = UI.getChildControl(Panel_CustomizationVoice, "Static_SelectMotionMark")
local static_Frame_Motion = UI.getChildControl(Panel_CustomizationVoice, "Static_Frame_Motion")
local text = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_VOICESELECT")
Button_Close:addInputEvent("Mouse_LUp", "closeVoiceUI()")
Slider_Voice:addInputEvent("Mouse_LPress", "updatePitchSlider()")
Slider_Voice_Btn:addInputEvent("Mouse_LPress", "updatePitchSlider()")
playVoice_Ctrl:addInputEvent("Mouse_LUp", "playVoice()")
UIScroll.InputEvent(frameScroll, "Voice_Scroll")
static_Frame:addInputEvent("Mouse_UpScroll", "Voice_Scroll( true )")
static_Frame:addInputEvent("Mouse_DownScroll", "Voice_Scroll( false )")
if false == _ContentsGroup_RenewUI_Customization then
  registerEvent("EventCloseVoiceUI", "closeVoiceUI()")
end
local Const_UsebleMotionbyServiceArea = false
local NoCashType = CppEnums.CustomizationNoCashType
local NoCashMesh = CppEnums.CustomizationNoCashMesh
local NoCashDeco = CppEnums.CustomizationNoCashDeco
local NoCashVoice = CppEnums.CustomizationNoCashVoice
local textureColumnCount = 4
local ColumnCount = 5
local ImageGap = 5
local columnWidth = Frame_ContentImage:GetSizeX() + ImageGap
local columnHeight = Frame_ContentImage:GetSizeY() + ImageGap
local contentsOffsetX = 20
local contentsOffsetY = 60
local VoiceCount = 1
local ContentImage = {}
local ContentCount = {}
local currentVoiceIndex = 1
local columMaxIndex = 3
local columIndex = 0
local slideIndex = 0
local markPosIndex = 0
local selectedIndex, selectedRealIndex, selectedInGameMode
local MotionImageGap = 6
local MotionContentsOffsetX = 11
local MotionContentsOffsetY = 10
local MotionColumnWidth = Frame_ContentImage:GetSizeX() + MotionImageGap
local MotionColumnHeight = Frame_ContentImage:GetSizeY() + MotionImageGap
local ContentMotionImage = {}
local selectMotionItemIndex = -1
local InitMotionindex = false
local panelSizeY = Panel_CustomizationVoice:GetSizeY()
local framSizeY = static_Frame:GetSizeY()
local framePosX = static_Frame:GetPosX()
local framePosY = static_Frame:GetPosY()
local textSliderPosY = StaticText_Slider:GetPosY()
local sliderPosY = Slider_Voice:GetPosY()
local textLowPosY = staticTextVoiceLow:GetPosY()
local textHighPosY = staticTextVoiceHigh:GetPosY()
local function UpdateMarkPosition()
  markPosIndex = slideIndex * 5
  for itemIdx = 0, VoiceCount - 1 do
    if itemIdx < columMaxIndex * ColumnCount then
      if selectedRealIndex == itemIdx + markPosIndex then
        Static_SelectMark:SetShow(true)
        Static_SelectMark:SetPosX(itemIdx % ColumnCount * columnWidth + contentsOffsetX)
        Static_SelectMark:SetPosY(math.floor(itemIdx / ColumnCount) * columnHeight + contentsOffsetY)
        return
      else
        Static_SelectMark:SetShow(false)
      end
    end
  end
end
local function UpdateShowIcon()
  for itemIdx = 0, VoiceCount - 1 do
    if itemIdx < columMaxIndex * ColumnCount then
      if VoiceCount >= itemIdx + 1 + slideIndex * 5 then
        local realIndex = itemIdx + slideIndex * 5
        ContentCount[itemIdx]:SetText(itemIdx + 1 + slideIndex * 5)
        ContentImage[itemIdx]:SetShow(true)
      else
        ContentImage[itemIdx]:SetShow(false)
      end
    end
  end
end
local function clearContentList()
  for _, content in pairs(ContentImage) do
    content:SetShow(false)
    UI.deleteControl(content)
  end
  ContentImage = {}
  for _, content in pairs(ContentMotionImage) do
    content:SetShow(false)
    UI.deleteControl(content)
  end
  ContentMotionImage = {}
end
local none = 100
local social = 1000
local combat = 2000
local MotionTable = {
  [0] = none,
  [1] = none,
  [2] = none,
  [3] = none,
  [4] = none,
  [5] = social,
  [6] = social,
  [7] = social,
  [8] = none,
  [9] = social,
  [10] = none,
  [11] = social,
  [12] = none,
  [13] = none,
  [14] = none,
  [15] = none,
  [16] = none,
  [17] = none,
  [18] = none,
  [19] = none,
  [20] = none,
  [21] = none,
  [22] = none,
  [23] = social,
  [24] = none,
  [25] = social,
  [26] = social,
  [27] = none,
  [28] = none,
  [29] = none,
  [30] = social,
  [31] = none,
  [32] = none,
  [33] = social,
  [34] = none,
  [35] = none,
  [36] = none,
  [37] = combat,
  [38] = combat,
  [39] = combat
}
function Initialize()
  if _ContentsGroup_isContentsCustomizationVoice then
    Slider_Voice:SetSize(290, 7)
    Slider_Voice:SetInterval(290)
    staticTextVoiceLow:SetPosX(258)
    playVoice_Ctrl:SetShow(false)
    StaticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_VOICESELECT"))
  else
    Slider_Voice:SetSize(240, 7)
    Slider_Voice:SetInterval(240)
    staticTextVoiceLow:SetPosX(208)
    playVoice_Ctrl:SetShow(true)
    StaticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_VOICE"))
  end
end
function createVoiceList(inGameMode)
  clearContentList()
  selectedInGameMode = inGameMode
  local texWidth = 48
  local texHeight = 48
  local texColumCount = 4
  if false == _ContentsGroup_isContentsCustomizationVoice then
    VoiceCount = 1
  else
    VoiceCount = getClassVoiceCount()
  end
  for itemIdx = 0, VoiceCount - 1 do
    columIndex = math.ceil((itemIdx + 1) / ColumnCount)
    local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CustomizationVoice, "Frame_Image_" .. itemIdx)
    CopyBaseProperty(Frame_ContentImage, tempContentImage)
    local tempVoiceCount = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempContentImage, "Frame_VoiceCount_" .. itemIdx)
    CopyBaseProperty(voiceCountText, tempVoiceCount)
    local staticPayMark = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempContentImage, "Static_PayMark_" .. itemIdx)
    CopyBaseProperty(Static_PayMark, staticPayMark)
    tempContentImage:addInputEvent("Mouse_LUp", "UpdateVoiceMessage(" .. itemIdx .. ")")
    tempContentImage:SetPosX(itemIdx % ColumnCount * columnWidth + contentsOffsetX)
    tempContentImage:SetPosY(math.floor(itemIdx / ColumnCount) * columnHeight + contentsOffsetY)
    tempContentImage:addInputEvent("Mouse_UpScroll", "Voice_Scroll( true )")
    tempContentImage:addInputEvent("Mouse_DownScroll", "Voice_Scroll( false )")
    tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
    if not FGlobal_IsInGameMode() and not isNormalCustomizingIndex(NoCashType.eCustomizationNoCashType_Voice, NoCashVoice.eCustoimzationNoCashVoice_Type, itemIdx) then
      tempContentImage:SetShow(false)
    else
      tempContentImage:SetShow(true)
    end
    tempVoiceCount:SetText(itemIdx + 1)
    tempVoiceCount:SetShow(true)
    if not isNormalCustomizingIndex(NoCashType.eCustomizationNoCashType_Voice, NoCashVoice.eCustoimzationNoCashVoice_Type, itemIdx) then
      staticPayMark:SetShow(true)
    else
      staticPayMark:SetShow(false)
    end
    if itemIdx >= columMaxIndex * ColumnCount then
      tempContentImage:SetShow(false)
    end
    ContentImage[itemIdx] = tempContentImage
    ContentCount[itemIdx] = tempVoiceCount
  end
  Voice_SetSize(columMaxIndex)
  check_ServiceArea()
  if Const_UsebleMotionbyServiceArea then
    InitMotionindex = false
    local lastSocialControl, lastCombatControl
    local count = getMotionCount()
    local textureName = getMotionTextureName()
    local texSize = 48.25
    local createIndex = 0
    for itemIdx = 0, count - 1 do
      if MotionTable[itemIdx] == social then
        local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Frame_Content, "Frame_MotionImage_" .. createIndex)
        CopyBaseProperty(Frame_ContentMotionImage, tempContentImage)
        tempContentImage:addInputEvent("Mouse_LUp", "UpdateVoiceFrame_Motion(" .. itemIdx .. ")")
        local mod = itemIdx % textureColumnCount
        local divi = math.floor(itemIdx / textureColumnCount)
        local texUV = {
          x1,
          y1,
          x2,
          y2
        }
        texUV.x1 = mod * texSize
        texUV.y1 = divi * texSize
        texUV.x2 = texUV.x1 + texSize
        texUV.y2 = texUV.y1 + texSize
        tempContentImage:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/" .. textureName)
        local x1, y1, x2, y2 = setTextureUV_Func(tempContentImage, texUV.x1, texUV.y1, texUV.x2, texUV.y2)
        tempContentImage:getBaseTexture():setUV(x1, y1, x2, y2)
        tempContentImage:SetPosX(createIndex % ColumnCount * MotionColumnWidth + MotionContentsOffsetX)
        tempContentImage:SetPosY(math.floor(createIndex / ColumnCount) * MotionColumnHeight + MotionContentsOffsetY)
        tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
        tempContentImage:SetShow(true)
        ContentMotionImage[itemIdx] = tempContentImage
        lastSocialControl = tempContentImage
        createIndex = createIndex + 1
        if InitMotionindex == false then
          selectMotionItemIndex = itemIdx
          InitMotionindex = true
          UpdateVoiceFrameMarkPosition(itemIdx)
        end
      end
    end
    lastCombatControl = lastSocialControl
    createIndex = math.floor((createIndex - 1) / ColumnCount) * ColumnCount + ColumnCount
    for itemIdx = 0, count - 1 do
      if MotionTable[itemIdx] == combat then
        local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Frame_Content, "Frame_MotionImage_" .. createIndex)
        CopyBaseProperty(Frame_ContentMotionImage, tempContentImage)
        tempContentImage:addInputEvent("Mouse_LUp", "UpdateVoiceFrame_Motion(" .. itemIdx .. ")")
        local mod = itemIdx % textureColumnCount
        local divi = math.floor(itemIdx / textureColumnCount)
        local texUV = {
          x1,
          y1,
          x2,
          y2
        }
        texUV.x1 = mod * texSize
        texUV.y1 = divi * texSize
        texUV.x2 = texUV.x1 + texSize
        texUV.y2 = texUV.y1 + texSize
        tempContentImage:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/" .. textureName)
        local x1, y1, x2, y2 = setTextureUV_Func(tempContentImage, texUV.x1, texUV.y1, texUV.x2, texUV.y2)
        tempContentImage:getBaseTexture():setUV(x1, y1, x2, y2)
        tempContentImage:SetPosX(createIndex % ColumnCount * MotionColumnWidth + MotionContentsOffsetX)
        tempContentImage:SetPosY(math.floor(createIndex / ColumnCount) * MotionColumnHeight + MotionContentsOffsetY)
        tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
        tempContentImage:SetShow(true)
        ContentMotionImage[itemIdx] = tempContentImage
        lastCombatControl = tempContentImage
        createIndex = createIndex + 1
      end
    end
    static_Frame_Motion:SetSize(static_Frame_Motion:GetSizeX(), lastCombatControl:GetPosY() - 10)
    Panel_CustomizationVoice:SetSize(Panel_CustomizationVoice:GetSizeX(), Frame_Content:GetPosY() + lastCombatControl:GetPosY() + lastCombatControl:GetSizeY() + 20)
  end
end
function UpdateVoiceMessage(index)
  selectedIndex = index
  selectedRealIndex = index + slideIndex * 5
  if Panel_Win_System:GetShow() then
    MessageBox_Empty_function()
    allClearMessageData()
  end
  if not selectedInGameMode and not isNormalCustomizingIndex(NoCashType.eCustomizationNoCashType_Voice, NoCashVoice.eCustoimzationNoCashVoice_Type, selectedRealIndex) then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_CASHITEM")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = UpdateVoice,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "top")
  else
    UpdateVoice()
    if Const_UsebleMotionbyServiceArea then
      applyMotion(selectMotionItemIndex)
    end
  end
end
function UpdateSlot()
  UpdateShowIcon()
end
function UpdateVoice()
  UpdateMarkPosition(selectedIndex)
  currentVoiceIndex = selectedRealIndex + 1
  playVoice()
  UIScroll.SetButtonSize(frameScroll, columMaxIndex, columIndex)
end
function playVoice()
  if _ContentsGroup_isContentsCustomizationVoice then
    applyVoice(currentVoiceIndex, false)
  else
    applyVoice(currentVoiceIndex, true)
  end
end
function check_ServiceArea()
  local TYPE = CppEnums.CountryType
  local ServiceType = getGameServiceType()
  if _ContentsGroup_isContentsCustomizationVoice then
    Const_UsebleMotionbyServiceArea = true
    return
  end
  Const_UsebleMotionbyServiceArea = false
  Frame_Content:SetShow(false)
  static_Frame_Motion:SetShow(false)
  StaticText_Motion:SetShow(false)
end
function showVoiceUI(show)
  check_ServiceArea()
  Panel_CustomizationVoice:SetShow(show)
  if true == show then
    CloseFrameForPoseUI()
    Panel_CustomizationVoice:SetPosX(Panel_CustomizationFrame:GetPosX())
    Panel_CustomizationVoice:SetPosY(Panel_CustomizationFrame:GetPosY())
    selectedIndex = getVoiceType() - 1
    selectedRealIndex = getVoiceType() - 1
    UpdateVoice()
    Slider_Voice:SetControlPos(getVoicePitch())
    updatePitchSlider()
  end
end
function closeVoiceUI()
  if Panel_CustomizationVoice:GetShow() == true then
    Panel_CustomizationFrame:SetPosX(Panel_CustomizationVoice:GetPosX())
    Panel_CustomizationFrame:SetPosY(Panel_CustomizationVoice:GetPosY())
    showVoiceUI(false)
    Static_SelectMotionMark:SetShow(false)
    if Const_UsebleMotionbyServiceArea then
      applyMotion(-1)
    end
    clearContentList()
    CustomizationMainUIShow(true)
    selectPoseControl(0)
  end
end
function updatePitchSlider()
  local range = 100
  local ratio = Slider_Voice:GetControlPos()
  applyVoicePitch(ratio * range)
end
function Voice_SetSize(index)
  if columIndex < columMaxIndex then
    index = columIndex
  elseif columMaxIndex ~= index then
    return
  end
  local sizeY = columnHeight * (index - 1)
  Panel_CustomizationVoice:SetSize(Panel_CustomizationVoice:GetSizeX(), panelSizeY + sizeY)
  static_Frame:SetSize(static_Frame:GetSizeX(), framSizeY + sizeY)
  frameScroll:SetSize(frameScroll:GetSizeX(), static_Frame:GetSizeY())
  frameScroll:SetPosX(framePosX + static_Frame:GetSizeX() - 15)
  frameScroll:SetPosY(framePosY)
  StaticText_Slider:SetPosY(textSliderPosY + sizeY)
  Slider_Voice:SetPosY(sliderPosY + sizeY)
  staticTextVoiceLow:SetPosY(textLowPosY + sizeY)
  staticTextVoiceHigh:SetPosY(textHighPosY + sizeY)
end
function Voice_Scroll(isUp)
  slideIndex = UIScroll.ScrollEvent(frameScroll, isUp, columMaxIndex, columIndex, slideIndex, 1)
  UpdateSlot()
  UpdateMarkPosition()
end
function UpdateVoiceFrameMarkPosition(index)
  if index ~= -1 then
    if ContentMotionImage[index] == nil or ContentMotionImage[index] == 0 then
      return
    end
    Static_SelectMotionMark:SetShow(true)
    Static_SelectMotionMark:SetPosX(ContentMotionImage[index]:GetPosX() + Frame_Content:GetPosX())
    Static_SelectMotionMark:SetPosY(ContentMotionImage[index]:GetPosY() + Frame_Content:GetPosY())
    selectMotionItemIndex = index
  else
    Static_SelectMotionMark:SetShow(false)
  end
end
function UpdateVoiceFrame_Motion(index)
  applyMotion(index)
  UpdateVoiceFrameMarkPosition(index)
end
Initialize()
