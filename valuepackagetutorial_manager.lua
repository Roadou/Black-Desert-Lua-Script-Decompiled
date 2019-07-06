local _panel = Panel_ValuePackageTutorial
local tutoText = {}
PaGlobal_ValuePackageTutorial_Manager = {
  _ui = {
    _obsidian = UI.getChildControl(Panel_ValuePackageTutorial, "Static_Obsidian"),
    _obsidian_B = UI.getChildControl(Panel_ValuePackageTutorial, "Static_Obsidian_B"),
    _obsidian_B_Left = UI.getChildControl(Panel_ValuePackageTutorial, "Static_Obsidian_B_Left"),
    _obsidian_Text = UI.getChildControl(Panel_ValuePackageTutorial, "StaticText_Obsidian_B"),
    _obsidian_Text_2 = UI.getChildControl(Panel_ValuePackageTutorial, "StaticText_Obsidian_B_2")
  },
  _isDoingValuePackageTutorial = false,
  _stepNo = 0,
  _updateTime = 0
}
local valueItems = {
  [1] = 290033,
  [2] = 290034,
  [3] = 290035,
  [4] = 290036,
  [5] = 290037,
  [6] = 290038,
  [7] = 290039,
  [8] = 290040,
  [9] = 290041
}
function PaGlobal_ValuePackageTutorial_Manager:isDoingValuePackageTutorial()
  return self._isDoingValuePackageTutorial
end
function PaGlobal_ValuePackageTutorial_Manager:setDoingValuePackageTutorial(bDoing)
  self._isDoingValuePackageTutorial = bDoing
end
function PaGlobal_ValuePackageTutorial_Manager:hideAllTutorialUi()
  for k, v in pairs(self._ui) do
    v:SetShow(false)
  end
end
function PaGlobal_ValuePackageTutorial_Manager:checkHasItemTutorial()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return false
  end
  local inventory = selfPlayer:get():getInventoryByType(CppEnums.ItemWhereType.eInventory)
  if nil == inventory then
    return false
  end
  local hasValuePackageItem = false
  for ii = 1, #valueItems do
    if toInt64(0, 0) ~= inventory:getItemCount_s64(ItemEnchantKey(valueItems[ii], 0)) then
      return true
    end
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_VALUE_PACKAGE_NOITEM"))
  return false
end
function PaGlobal_ValuePackageTutorial_Manager:startTutorial()
  if false == self:checkHasItemTutorial() then
    return
  end
  _panel:SetShow(true, true)
  self:hideAllTutorialUi()
  self._ui._obsidian:SetShow(true)
  self._ui._obsidian_B:SetShow(true)
  self._ui._obsidian_Text_2:SetShow(true)
  self._ui._obsidian:EraseAllEffect()
  self._ui._obsidian:AddEffect("fN_DarkSpirit_Gage_01C", true, 0, 0)
  tutoText[1] = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_VALUE_PACKAGE_1")
  tutoText[2] = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_VALUE_PACKAGE_2")
  tutoText[3] = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_VALUE_PACKAGE_3")
  tutoText[4] = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_VALUE_PACKAGE_4")
  tutoText[5] = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_VALUE_PACKAGE_5")
  tutoText[6] = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_VALUE_PACKAGE_6")
  self._stepNo = 1
  self:setDoingValuePackageTutorial(true)
end
function PaGlobal_ValuePackageTutorial_Manager:repositionValuePackageTutorial()
  _panel:ComputePos()
  self._ui._obsidian:SetShow(true)
  self._ui._obsidian_B:SetShow(true)
  self._ui._obsidian_Text:SetShow(true)
  self._ui._obsidian_Text_2:SetShow(true)
  local text_SizeX = self._ui._obsidian_Text:GetTextSizeX()
  local text_SizeY = self._ui._obsidian_Text:GetTextSizeY()
  local text2_SizeX = self._ui._obsidian_Text_2:GetTextSizeX()
  local text2_SizeY = self._ui._obsidian_Text_2:GetTextSizeY()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  self._ui._obsidian_B:SetSize(math.max(text_SizeX, text2_SizeX) + 30, text_SizeY + text2_SizeY + 40)
  self._ui._obsidian:SetPosX(0 - self._ui._obsidian_B:GetSizeX() / 2 - self._ui._obsidian:GetSizeX() / 2)
  self._ui._obsidian:SetPosY(100)
  local obsidianX = self._ui._obsidian:GetPosX()
  local obsidianY = self._ui._obsidian:GetPosY()
  self._ui._obsidian_B:SetPosX(obsidianX + 130)
  self._ui._obsidian_B:SetPosY(obsidianY + 30)
  local obsidianB_X = self._ui._obsidian_B:GetPosX()
  local obsidianB_Y = self._ui._obsidian_B:GetPosY()
  self._ui._obsidian_Text:SetPosX(obsidianB_X + 3)
  self._ui._obsidian_Text:SetPosY(obsidianB_Y + 25)
  self._ui._obsidian_Text_2:SetPosX(obsidianB_X + 3)
  self._ui._obsidian_Text_2:SetPosY(self._ui._obsidian_Text:GetPosY() + text_SizeY + 5)
end
function PaGlobal_ValuePackageTutorial_Manager:updateDeltaTime_ValuePackage_Step1(deltaTime)
  self._ui._obsidian_Text:SetText(tutoText[1])
  self._ui._obsidian_Text_2:SetText(tutoText[2])
  self:repositionValuePackageTutorial()
  local invenOpenCheck = Panel_Window_Inventory:GetShow()
  self._updateTime = self._updateTime + deltaTime
  if invenOpenCheck or self._updateTime > 5 then
    if not Panel_Window_Inventory:GetShow() then
      InventoryWindow_Show()
    end
    audioPostEvent_SystemUi(4, 12)
    self._updateTime = 0
    self._stepNo = 2
  end
end
function PaGlobal_ValuePackageTutorial_Manager:updateDeltaTime_ValuePackage_Step2(deltaTime)
  self._ui._obsidian_Text:SetText(tutoText[3])
  self._ui._obsidian_Text_2:SetText(tutoText[4])
  self:repositionValuePackageTutorial()
  self._updateTime = self._updateTime + deltaTime
  if FGlobal_ValuePackagerItemUse() then
    self._updateTime = 0
    self._stepNo = 3
  end
  if not Panel_Window_Inventory:GetShow() then
    self._updateTime = 0
    self._stepNo = 0
    self:endTutorial()
  end
end
function PaGlobal_ValuePackageTutorial_Manager:updateDeltaTime_ValuePackage_Step3(deltaTime)
  self._ui._obsidian_Text:SetText(tutoText[5])
  self._ui._obsidian_Text_2:SetText(tutoText[6])
  self:repositionValuePackageTutorial()
  self._updateTime = self._updateTime + deltaTime
  if self._updateTime > 8 then
    self._updateTime = 0
    self._stepNo = 0
    self:endTutorial()
  end
end
function PaGlobal_ValuePackageTutorial_Manager:endTutorial()
  _panel:SetShow(false, true)
  self:setDoingValuePackageTutorial(false)
end
local _texturePath_Black = "New_UI_Common_ForLua/Widget/Bubble/Bubble_01.dds"
local _texturePath_White = "New_UI_Common_ForLua/Widget/Bubble/Bubble.dds"
function PaGlobal_ArousalTutorial_UiBlackSpirit:changeBubbleTextureForAni(bWhite)
  if true == _panel:isPlayAnimation() then
    self._ui._obsidian_B:ChangeTextureInfoName(_texturePath_Black)
    self._ui._obsidian_B_Left:ChangeTextureInfoName(_texturePath_Black)
    return
  end
  local destTexture = _texturePath_Black
  if true == bWhite then
    destTexture = _texturePath_White
  elseif false == bWhite then
    destTexture = _texturePath_Black
  end
  self._ui._obsidian_B:ChangeTextureInfoName(destTexture)
  self._ui._obsidian_B_Left:ChangeTextureInfoName(destTexture)
end
function PaGlobal_ValuePackageTutorial_Manager_ShowAni()
  PaGlobal_ArousalTutorial_UiBlackSpirit:changeBubbleTextureForAni(false)
  _panel:ResetVertexAni()
  _panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo = _panel:addColorAnimation(0, 0.75, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(Defines.Color.C_00FFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
end
function PaGlobal_ValuePackageTutorial_Manager_HideAni()
  PaGlobal_ArousalTutorial_UiBlackSpirit:changeBubbleTextureForAni(false)
  _panel:ResetVertexAni()
  _panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo = _panel:addColorAnimation(0, 1.25, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(Defines.Color.C_FFFFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_00FFFFFF)
  aniInfo.IsChangeChild = true
  aniInfo:SetHideAtEnd(true)
  aniInfo:SetDisableWhileAni(true)
end
function PaGlobal_ValuePackageTutorial_Manager_UpdatePerFrame(deltaTime)
  PaGlobal_ValuePackageTutorial_Manager:updatePerFrame(deltaTime)
end
function PaGlobal_ValuePackageTutorial_Manager:updatePerFrame(deltaTime)
  if 1 == self._stepNo then
    self:updateDeltaTime_ValuePackage_Step1(deltaTime)
  elseif 2 == self._stepNo then
    self:updateDeltaTime_ValuePackage_Step2(deltaTime)
  elseif 3 == self._stepNo then
    self:updateDeltaTime_ValuePackage_Step3(deltaTime)
  end
end
function onResize_ValuePackageTutorial()
  PaGlobal_ValuePackageTutorial_Manager:repositionValuePackageTutorial()
end
_panel:RegisterUpdateFunc("PaGlobal_ValuePackageTutorial_Manager_UpdatePerFrame")
_panel:RegisterShowEventFunc(true, "PaGlobal_ValuePackageTutorial_Manager_ShowAni()")
_panel:RegisterShowEventFunc(false, "PaGlobal_ValuePackageTutorial_Manager_HideAni()")
registerEvent("onScreenResize", "onResize_ValuePackageTutorial")
