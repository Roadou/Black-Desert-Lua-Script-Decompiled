local UI_Class = CppEnums.ClassType
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_TransferLifeExperience:SetShow(false)
Panel_TransferLifeExperience:RegisterShowEventFunc(true, "TransferLife_ShowAni()")
Panel_TransferLifeExperience:RegisterShowEventFunc(false, "TransferLife_HideAni()")
Panel_TransferLifeExperience:ActiveMouseEventEffect(true)
Panel_TransferLifeExperience:setGlassBackground(true)
local itemEquipType_FishingRod = 44
local TransferLifeType_Fishing = 1
local TransferLife = {
  itemWhereType = nil,
  itemSlotNo = nil,
  itemLifeType = nil,
  characterIndex = nil,
  characterNo_64 = nil,
  title = UI.getChildControl(Panel_TransferLifeExperience, "StaticText_Title"),
  panelBG = UI.getChildControl(Panel_TransferLifeExperience, "Static_PanelBG"),
  btn_Confirm = UI.getChildControl(Panel_TransferLifeExperience, "Button_Confirm"),
  btn_Cancel = UI.getChildControl(Panel_TransferLifeExperience, "Button_Cancel"),
  btn_Close = UI.getChildControl(Panel_TransferLifeExperience, "Button_Win_Close"),
  _scroll = UI.getChildControl(Panel_TransferLifeExperience, "Scroll_TransferLife"),
  notify = UI.getChildControl(Panel_TransferLifeExperience, "Static_Notify"),
  maxSlotCount = 4,
  listCount = 0,
  startPos_characterBtn = 5,
  startCharacterIdx = 0,
  Slot = {},
  _selectCharacterIndex = -1,
  _posX = 0,
  _posY = 0
}
TransferLife._scrollBtn = UI.getChildControl(TransferLife._scroll, "Scroll_CtrlButton")
TransferLife.btn_Cancel:addInputEvent("Mouse_LUp", "TransferLife_Close()")
TransferLife.btn_Close:addInputEvent("Mouse_LUp", "TransferLife_Close()")
function TransferLife_ShowAni()
  Panel_TransferLifeExperience:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_TransferLifeExperience, 0, 0.15)
  local aniInfo1 = Panel_TransferLifeExperience:addScaleAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(1.5)
  aniInfo1:SetEndScale(0.8)
  aniInfo1.AxisX = Panel_TransferLifeExperience:GetSizeX() / 2
  aniInfo1.AxisY = Panel_TransferLifeExperience:GetSizeY() / 2
  aniInfo1.ScaleType = 0
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_TransferLifeExperience:addScaleAnimation(0.15, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(0.8)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_TransferLifeExperience:GetSizeX() / 2
  aniInfo2.AxisY = Panel_TransferLifeExperience:GetSizeY() / 2
  aniInfo2.ScaleType = 0
  aniInfo2.IsChangeChild = true
end
function TransferLife_HideAni()
  Panel_TransferLifeExperience:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_TransferLifeExperience, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local function TransferLife_Initialize()
  local self = TransferLife
  self.notify:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self.notify:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRANSFERLIFEEXPERIENCE_NOTIFY"))
  for slotIdx = 0, self.maxSlotCount - 1 do
    local slotBtn = UI.createAndCopyBasePropertyControl(Panel_TransferLifeExperience, "Button_Character0", self.panelBG, "TransferLife_CharacterBTN_" .. slotIdx)
    slotBtn:SetPosY(self.startPos_characterBtn + (slotBtn:GetSizeY() + 5) * slotIdx)
    slotBtn:addInputEvent("Mouse_UpScroll", "TransferLife_ScrollEvent( true )")
    slotBtn:addInputEvent("Mouse_DownScroll", "TransferLife_ScrollEvent( false )")
    self.Slot[slotIdx] = slotBtn
  end
  self.panelBG:addInputEvent("Mouse_UpScroll", "TransferLife_ScrollEvent( true )")
  self.panelBG:addInputEvent("Mouse_DownScroll", "TransferLife_ScrollEvent( false )")
  UIScroll.InputEvent(self._scroll, "TransferLife_ScrollEvent")
  self.characterNo_64 = getSelfPlayer():getCharacterNo_64()
  self._posX = Panel_TransferLifeExperience:GetPosX()
  self._posY = Panel_TransferLifeExperience:GetPosY()
end
TransferLife_Initialize()
local function ChangeTexture_Class(control, classType)
  if classType == UI_Class.ClassType_Warrior then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 1, 458, 61)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 62, 458, 122)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 123, 458, 183)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Ranger then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 184, 458, 244)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 245, 458, 305)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 306, 458, 366)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Sorcerer then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 367, 458, 427)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 428, 458, 488)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 1, 458, 61)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Giant then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 62, 458, 122)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 123, 458, 183)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 184, 458, 244)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Tamer then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 1, 458, 61)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 62, 458, 122)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 123, 458, 183)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_BladeMaster then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 184, 458, 244)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 245, 458, 305)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 306, 458, 366)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_BladeMasterWomen then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 184, 458, 244)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 245, 458, 305)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 306, 458, 366)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Valkyrie then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 1, 458, 61)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 62, 458, 122)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 123, 458, 183)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Wizard then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 1, 458, 61)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 62, 458, 122)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 123, 458, 183)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_WizardWomen then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 184, 458, 244)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 245, 458, 305)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 306, 458, 366)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_NinjaWomen then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_06.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 184, 458, 244)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_06.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 245, 458, 305)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_06.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 306, 458, 366)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_NinjaMan then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 1, 458, 61)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 62, 458, 122)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 123, 458, 183)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_DarkElf then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 184, 458, 244)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 245, 458, 305)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 306, 458, 366)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Combattant then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 367, 458, 427)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 428, 458, 488)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_08.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 1, 458, 61)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_CombattantWomen then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_08.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 62, 458, 122)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_08.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 123, 458, 183)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_08.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 184, 458, 244)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Lahn then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_08.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 245, 458, 305)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_08.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 306, 458, 366)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_08.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 367, 458, 427)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == UI_Class.ClassType_Orange then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_08.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 428, 458, 488)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_09.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 1, 458, 61)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_09.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 62, 458, 122)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif classType == __eClassType_ShyWaman then
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_09.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 123, 458, 183)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_09.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 184, 458, 244)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_09.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 245, 458, 305)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  else
    control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 245, 458, 305)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 306, 458, 366)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    control:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 2, 367, 458, 427)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  end
end
local function TransferLife_Update()
  local self = TransferLife
  for slotIdx = 0, self.maxSlotCount - 1 do
    local slotBtn = self.Slot[slotIdx]
    slotBtn:SetShow(false)
  end
  self.listCount = getCharacterDataCount()
  if self.maxSlotCount < self.listCount then
    self._scroll:SetShow(true)
  else
    self._scroll:SetShow(false)
  end
  local uiIdx = 0
  for slotIdx = self.startCharacterIdx, self.listCount do
    if uiIdx >= self.maxSlotCount then
      if 0 <= self._selectCharacterIndex and self._selectCharacterIndex < 4 then
        self.Slot[self._selectCharacterIndex]:SetCheck(true)
      end
      return
    end
    local slotBtn = self.Slot[uiIdx]
    slotBtn:SetCheck(false)
    slotBtn:SetMonoTone(false)
    slotBtn:SetEnable(true)
    local characterData = getCharacterDataByIndex(slotIdx)
    if nil == characterData then
      return
    end
    local characterName = getCharacterName(characterData)
    local classType = getCharacterClassType(characterData)
    local characterLevel = string.format("%d", characterData._level)
    if self.characterNo_64 == characterData._characterNo_s64 then
      characterName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRANSFERLIFEEXPERIENCE_CHARACTERNAME", "characterName", characterName)
      slotBtn:SetMonoTone(true)
      slotBtn:SetEnable(false)
    end
    slotBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. characterLevel .. " " .. characterName)
    slotBtn:addInputEvent("Mouse_LUp", "TransferLife_SelectedCharacter(" .. slotIdx .. ")")
    ChangeTexture_Class(slotBtn, classType)
    slotBtn:SetShow(true)
    uiIdx = uiIdx + 1
  end
end
function TransferLife_Open()
  Panel_TransferLifeExperience:SetShow(true, true)
  Panel_TransferLifeExperience:SetPosX(TransferLife._posX)
  Panel_TransferLifeExperience:SetPosY(TransferLife._posY)
  TransferLife._scroll:SetControlPos(0)
  TransferLife._selectCharacterIndex = -1
  TransferLife.characterIndex = nil
end
function TransferLife_Close()
  Panel_TransferLifeExperience:SetShow(false, false)
end
function FGlobal_TransferLife_Close()
  TransferLife_Close()
end
function TransferLife_ScrollEvent(isUp)
  local self = TransferLife
  self.startCharacterIdx = UIScroll.ScrollEvent(self._scroll, isUp, self.maxSlotCount, self.listCount, self.startCharacterIdx, 1)
  if nil ~= self.characterIndex then
    self._selectCharacterIndex = self.characterIndex - self.startCharacterIdx
  end
  TransferLife_Update()
end
function TransferLife_SelectedCharacter(slotIdx)
  local self = TransferLife
  self.characterIndex = slotIdx
end
function TransferLife_Confirm(_type)
  local self = TransferLife
  if nil == self.itemWhereType or nil == self.itemSlotNo or nil == self.characterIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TRANSFERLIFEEXPERIENCE_WRONGVALUE"))
    return
  end
  if 0 == _type then
    if nil == self.itemLifeType then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TRANSFERLIFEEXPERIENCE_WRONGVALUE"))
      return
    end
    ToClient_requestTransferLifeExperience(self.itemWhereType, self.itemSlotNo, self.itemLifeType, self.characterIndex)
  elseif 1 == _type then
    ToClient_requestExchangeBattleAndSkillExp(self.itemWhereType, self.itemSlotNo, self.characterIndex)
  end
end
registerEvent("FromClient_RequestUseTransferLifeExperience", "FromClient_RequestUseTransferLifeExperience")
registerEvent("FromClient_TransferLifeExperience", "FromClient_TransferLifeExperience")
registerEvent("FromClient_RequestUseExchangeBattleAndSkillExp", "FromClient_RequestUseExchangeBattleAndSkillExp")
registerEvent("FromClient_ResponseExchangeBattleAndSkillExp", "FromClient_ResponseExchangeBattleAndSkillExp")
function FromClient_RequestUseTransferLifeExperience(fromWhereType, fromSlotNo, lifeType)
  if TransferLifeType_Fishing == lifeType then
    local itemWrapper = ToClient_getEquipmentItem(0)
    if itemWrapper ~= nil then
      local itemSSW = itemWrapper:getStaticStatus()
      if itemEquipType_FishingRod == itemSSW:getEquipType() then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TRANSFER_LIFE_CANTUSE_EQUIPFISHINGITEM"))
        return
      end
    end
  end
  if nil ~= ToClient_getEquipmentItem(2) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TRANSFER_LIFE_CANTUSE_EQUIPLIFEITEM"))
    return
  end
  local self = TransferLife
  self.itemWhereType = fromWhereType
  self.itemSlotNo = fromSlotNo
  self.itemLifeType = lifeType
  self.startCharacterIdx = 0
  TransferLife_Update()
  TransferLife_Open()
  TransferLife.btn_Confirm:addInputEvent("Mouse_LUp", "TransferLife_Confirm(" .. 0 .. ")")
  self.title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TRANSFERLIFEXPERIENCE_TITLE"))
end
function FromClient_TransferLifeExperience(lifeType)
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TRANSFERLIFEEXPERIENCE_SUCCESS_TRANSFER"))
  TransferLife_Close()
end
function FromClient_RequestUseExchangeBattleAndSkillExp(fromWhereType, fromSlotNo)
  local self = TransferLife
  self.itemWhereType = fromWhereType
  self.itemSlotNo = fromSlotNo
  self.itemLifeType = nil
  self.startCharacterIdx = 0
  TransferLife_Update()
  TransferLife_Open()
  TransferLife.btn_Confirm:addInputEvent("Mouse_LUp", "TransferLife_Confirm(" .. 1 .. ")")
  self.title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRANSFERLIFEEXPERIENCE_TITLE"))
  self.notify:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRANSFERBATTLEEXPERIENCE_NOTIFY"))
end
function FromClient_ResponseExchangeBattleAndSkillExp()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TRANSFERLIFEEXPERIENCE_SUCCESS_TRANSFER"))
  TransferLife_Close()
end
