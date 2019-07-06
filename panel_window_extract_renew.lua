local _panel = Panel_Window_Extract_Renew
local TAB_TYPE = {
  BLACKSTONE = 1,
  CRYSTAL = 2,
  OUTFIT = 3,
  SYSTEM = 4
}
local ExtractInfo = {
  _ui = {
    stc_titleBar = UI.getChildControl(_panel, "Static_TitleBar"),
    stc_BG = UI.getChildControl(_panel, "Static_BodyBG"),
    stc_keyGuideGroup = UI.getChildControl(_panel, "Static_KeyGuideGroup"),
    stc_Group = {
      [TAB_TYPE.BLACKSTONE] = UI.getChildControl(_panel, "Static_BlackStoneGroup"),
      [TAB_TYPE.CRYSTAL] = UI.getChildControl(_panel, "Static_CrystalGroup"),
      [TAB_TYPE.OUTFIT] = UI.getChildControl(_panel, "Static_OutfitGroup"),
      [TAB_TYPE.SYSTEM] = UI.getChildControl(_panel, "Static_SystemGroup")
    }
  },
  _currentTab = nil
}
local _tabData = {
  [TAB_TYPE.BLACKSTONE] = {
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_EXTRACTIONGUIDE_XBOX")
  },
  [TAB_TYPE.CRYSTAL] = {
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_EXTRACTIONGUIDE")
  },
  [TAB_TYPE.OUTFIT] = {
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_1")
  },
  [TAB_TYPE.SYSTEM] = {
    desc = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_EXTRACTIONSYSTEM_DESC")
  }
}
local _snappedOnThisPanel = false
local self = ExtractInfo
function FromClient_luaLoadComplete_ExtractInfo_Init()
  ExtractInfo:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_ExtractInfo_Init")
function ExtractInfo:initialize()
  self._ui.txt_title = UI.getChildControl(self._ui.stc_titleBar, "StaticText_Title")
  self._ui.stc_titleIcon = UI.getChildControl(self._ui.stc_titleBar, "Static_TitleIcon")
  self._ui.txt_desc = UI.getChildControl(self._ui.stc_BG, "StaticText_Desc")
  self._ui.txt_desc:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  self._ui.txt_desc:setLineCountByLimitAutoWrap(3)
  self._ui.stc_tabMenu = UI.getChildControl(self._ui.stc_BG, "Static_SubMenu")
  self._ui.txt_keyGuideLT = UI.getChildControl(self._ui.stc_tabMenu, "Static_KeyGuideLT")
  self._ui.txt_keyGuideRT = UI.getChildControl(self._ui.stc_tabMenu, "Static_KeyGuideRT")
  self._ui.rdo_tab = {}
  self._ui.rdo_tab[TAB_TYPE.BLACKSTONE] = UI.getChildControl(self._ui.stc_tabMenu, "RadioButton_SubMenu1")
  self._ui.rdo_tab[TAB_TYPE.CRYSTAL] = UI.getChildControl(self._ui.stc_tabMenu, "RadioButton_SubMenu2")
  self._ui.rdo_tab[TAB_TYPE.OUTFIT] = UI.getChildControl(self._ui.stc_tabMenu, "RadioButton_SubMenu3")
  self._ui.rdo_tab[TAB_TYPE.SYSTEM] = UI.getChildControl(self._ui.stc_tabMenu, "RadioButton_SubMenu4")
  self:tabAlign()
  self._ui.txt_keyGuideB = UI.getChildControl(self._ui.stc_keyGuideGroup, "StaticText_KeyGuide")
  PaGlobalFunc_ConsoleKeyGuide_SetAlign({
    self._ui.txt_keyGuideB
  }, self._ui.stc_keyGuideGroup, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self:registEventHandler()
  self:registMessageHandler()
end
function PaGlobalFunc_ExtractInfo_GetTabParent()
  return self._ui.stc_BG
end
function ExtractInfo:tabAlign()
  local startPosX = self._ui.txt_keyGuideLT:GetPosX() + self._ui.txt_keyGuideLT:GetSizeX()
  local endPosX = self._ui.txt_keyGuideRT:GetPosX()
  local totalSizeX = endPosX - startPosX
  local tabTotalSizeX = 0
  local gapSizeX = 0
  for _, tab in ipairs(self._ui.rdo_tab) do
    tabTotalSizeX = tabTotalSizeX + tab:GetTextSizeX()
  end
  gapSizeX = (totalSizeX - tabTotalSizeX) / (#self._ui.rdo_tab + 1)
  local posX = startPosX + gapSizeX
  for _, tab in ipairs(self._ui.rdo_tab) do
    tab:SetPosX(posX)
    posX = posX + gapSizeX + tab:GetTextSizeX()
  end
end
function ExtractInfo:registEventHandler()
  _panel:registerPadEvent(__eConsoleUIPadEvent_LT, "Input_ExtractInfo_NextTab(-1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RT, "Input_ExtractInfo_NextTab(1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "Input_ExtractInfo_PressedY()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_ExtractInfo_PressedX()")
end
function ExtractInfo:registMessageHandler()
  registerEvent("FromClient_PadSnapChangePanel", "FromClient_ExtractInfo_PadSnapChangePanel")
  _panel:RegisterUpdateFunc("PaGlobalFunc_ExtractInfo_UpdatePerFrame")
end
function PaGlobalFunc_ExtractInfo_Open(tabIndex)
  ExtractInfo:open(tabIndex)
end
function ExtractInfo:open(tabIndex)
  _panel:SetShow(true)
  if nil ~= tabIndex then
    self:SetTabTo(tabIndex)
  else
    self:SetTabTo(TAB_TYPE.BLACKSTONE)
  end
end
function PaGlobalFunc_ExtractInfo_GetShow()
  return _panel:GetShow()
end
function ExtractInfo:SetTabTo(tabIndex)
  for ii = 1, #self._ui.rdo_tab do
    self._ui.rdo_tab[ii]:SetCheck(false)
    self._ui.rdo_tab[ii]:SetFontColor(Defines.Color.C_FF9397A7)
    self._ui.stc_Group[ii]:SetShow(false)
  end
  self._ui.rdo_tab[tabIndex]:SetCheck(true)
  self._ui.rdo_tab[tabIndex]:SetFontColor(Defines.Color.C_FFEEEEEE)
  self._ui.stc_Group[tabIndex]:SetShow(true)
  if nil ~= _tabData[tabIndex] and nil ~= _tabData[tabIndex].desc then
    self._ui.txt_desc:SetText(_tabData[tabIndex].desc)
  end
  if nil ~= self._currentTab then
    if self._currentTab == TAB_TYPE.BLACKSTONE then
      PaGlobalFunc_ExtractBlackStone_Close()
    elseif self._currentTab == TAB_TYPE.CRYSTAL then
      PaGlobalFunc_ExtractCrystal_Close()
    elseif self._currentTab == TAB_TYPE.OUTFIT then
      PaGlobalFunc_ExtractOutfit_Close()
    elseif self._currentTab == TAB_TYPE.SYSTEM then
      PaGlobal_ExtractionSystem_ForceClose()
    end
  end
  if tabIndex == TAB_TYPE.BLACKSTONE then
    PaGlobalFunc_ExtractBlackStone_Open()
  elseif tabIndex == TAB_TYPE.CRYSTAL then
    PaGlobalFunc_ExtractCrystal_Open()
  elseif tabIndex == TAB_TYPE.OUTFIT then
    PaGlobalFunc_ExtractOutfit_Open()
  elseif tabIndex == TAB_TYPE.SYSTEM then
    PaGlobal_ExtractionSystem_ForceOpen()
  end
  self._currentTab = tabIndex
end
function Input_ExtractInfo_NextTab(val)
  local nextTab = self._currentTab + val
  if nextTab > #self._ui.rdo_tab then
    nextTab = 1
  elseif nextTab < 1 then
    nextTab = #self._ui.rdo_tab
  end
  self:SetTabTo(nextTab)
end
function Input_ExtractInfo_PressedY()
  if nil ~= self._currentTab then
    if self._currentTab == TAB_TYPE.BLACKSTONE then
      PaGlobalFunc_ExtractBlackStone_ApplyExtract()
    elseif self._currentTab == TAB_TYPE.CRYSTAL then
      PaGlobalFunc_ExtractCrystal_ApplyExtract()
    elseif self._currentTab == TAB_TYPE.OUTFIT then
      Input_ExtractOutfit_Apply(false)
    elseif self._currentTab == TAB_TYPE.SYSTEM then
      HandlerEventLUp_ExtractionSystem_ExtractButton()
    end
  end
end
function Input_ExtractInfo_PressedX()
  if nil == self._currentTab or self._currentTab == TAB_TYPE.BLACKSTONE then
  elseif self._currentTab == TAB_TYPE.CRYSTAL then
    PaGlobalFunc_ExtractCrystal_ApplyRemove()
  elseif self._currentTab == TAB_TYPE.OUTFIT then
    Input_ExtractOutfit_Apply(true)
  end
end
function PaGlobalFunc_ExtractInfo_UpdatePerFrame(deltaTime)
  if nil ~= self._currentTab then
    if self._currentTab == TAB_TYPE.BLACKSTONE then
      PaGlobalFunc_ExtractBlackStone_UpdatePerFrame(deltaTime)
    elseif self._currentTab == TAB_TYPE.CRYSTAL then
    elseif self._currentTab == TAB_TYPE.OUTFIT then
      PaGlobalFunc_ExtractOutfit_UpdatePerFrame(deltaTime)
    elseif self._currentTab == TAB_TYPE.SYSTEM then
    end
  end
end
function PaGlobalFunc_ExtractInfo_OnPadB()
  if self._currentTab == TAB_TYPE.BLACKSTONE then
    if true == PaGlobalFunc_ExtractBlackStone_OnPadB() then
      PaGlobalFunc_ExtractInfo_Close()
      return true
    else
      return false
    end
  elseif self._currentTab == TAB_TYPE.CRYSTAL then
    if true == PaGlobalFunc_ExtractCrystal_OnPadB() then
      PaGlobalFunc_ExtractInfo_Close()
      return true
    else
      return false
    end
  elseif self._currentTab == TAB_TYPE.OUTFIT then
    if true == PaGlobalFunc_ExtractOutfit_OnPadB() then
      PaGlobalFunc_ExtractInfo_Close()
      return true
    else
      return false
    end
  elseif self._currentTab == TAB_TYPE.SYSTEM then
    if true == PaGlobalFunc_ExtractSYSYEM_OnPadB() then
      PaGlobalFunc_ExtractInfo_Close()
      return true
    else
      return false
    end
  end
  return true
end
function PaGlobalFunc_ExtractInfo_Close()
  if false == _panel:GetShow() then
    return
  end
  _panel:SetShow(false)
  Inventory_SetFunctor(nil)
  PaGlobalFunc_InventoryInfo_Close()
end
function FromClient_ExtractInfo_PadSnapChangePanel(fromPanel, toPanel)
  if nil ~= toPanel and toPanel:GetKey() == _panel:GetKey() then
    _snappedOnThisPanel = true
    self:updateKeyGuides()
  else
    _snappedOnThisPanel = false
    self:updateKeyGuides()
  end
end
function PaGlobalFunc_ExtractInfo_SnappedOnMainPanel()
  return _snappedOnThisPanel
end
function ExtractInfo:updateKeyGuides()
  if nil ~= self._currentTab then
    if self._currentTab == TAB_TYPE.BLACKSTONE then
      PaGlobalFunc_ExtractBlackStone_UpdateKeyGuide(_snappedOnThisPanel)
    elseif self._currentTab == TAB_TYPE.CRYSTAL then
      PaGlobalFunc_ExtractCrystal_UpdateKeyGuide(_snappedOnThisPanel)
    elseif self._currentTab == TAB_TYPE.OUTFIT then
      PaGlobalFunc_ExtractOutfit_UpdateKeyGuide(_snappedOnThisPanel)
    end
  end
end
PaGlobal_Extraction = {}
function PaGlobal_Extraction:getExtractionButtonEnchantStone()
end
function PaGlobal_Extraction:getExtractionButtonCrystal()
end
function PaGlobal_Extraction:getExtractionButtonCloth()
end
