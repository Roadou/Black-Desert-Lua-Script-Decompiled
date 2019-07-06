PaGlobalAppliedBuffList = {
  _uiBackBuff = UI.getChildControl(Instance_AppliedBuffList, "Static_Buff_BG"),
  _uiBackDeBuff = UI.getChildControl(Instance_AppliedBuffList, "Static_DeBuff_BG"),
  _buffText = UI.getChildControl(Instance_AppliedBuffList, "StaticText_buffText"),
  _maxBuffCount = 20,
  _uiBuffList = {},
  _uiDeBuffList = {},
  _isShow = false,
  _initialized = false
}
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_classType = CppEnums.ClassType
local UI_TIMETOP = Util.Time.inGameTimeFormattingTop
function PaGlobalFunc_AppliedBuffList_ResetPosition()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  if Instance_AppliedBuffList:GetRelativePosX() == -1 and Instance_AppliedBuffList:GetRelativePosY() == -1 then
    local initPosX = scrX * 0.35
    local initPosY = scrY * 0.75
    local haveServerPosotion = 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_AppliedBuffList, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved)
    if not haveServerPosotion then
      Instance_AppliedBuffList:SetPosX(initPosX)
      Instance_AppliedBuffList:SetPosY(initPosY)
    end
    changePositionBySever(Instance_AppliedBuffList, CppEnums.PAGameUIType.PAGameUIPanel_AppliedBuffList, true, true, false)
    FGlobal_InitPanelRelativePos(Instance_AppliedBuffList, initPosX, initPosY)
  elseif Instance_AppliedBuffList:GetRelativePosX() == 0 and Instance_AppliedBuffList:GetRelativePosY() == 0 then
    Instance_AppliedBuffList:SetPosX(scrX * 0.35)
    Instance_AppliedBuffList:SetPosY(scrY * 0.75)
  else
    Instance_AppliedBuffList:SetPosX(getScreenSizeX() * Instance_AppliedBuffList:GetRelativePosX() - Instance_AppliedBuffList:GetSizeX() / 2)
    Instance_AppliedBuffList:SetPosY(getScreenSizeY() * Instance_AppliedBuffList:GetRelativePosY() - Instance_AppliedBuffList:GetSizeY() / 2)
  end
  local isShow = ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_AppliedBuffList, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow)
  if isShow < 0 then
    Instance_AppliedBuffList:SetShow(true)
  else
    Instance_AppliedBuffList:SetShow(isShow)
  end
  FGlobal_PanelRepostionbyScreenOut(Instance_AppliedBuffList)
end
function PaGlobalAppliedBuffList:initialize()
  local styleBuffIcon = UI.getChildControl(Instance_AppliedBuffList, "StaticText_Buff")
  local styleDeBuffIcon = UI.getChildControl(Instance_AppliedBuffList, "StaticText_deBuff")
  PaGlobalFunc_AppliedBuffList_ResetPosition()
  styleBuffIcon:SetShow(false)
  styleDeBuffIcon:SetShow(false)
  self._uiBackBuff:SetShow(false)
  self._uiBackDeBuff:SetShow(false)
  local iconSpan = styleBuffIcon:GetSizeX() + 1
  for index = 1, self._maxBuffCount do
    local buffIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Instance_AppliedBuffList, "AppliedBuff_" .. index)
    CopyBaseProperty(styleBuffIcon, buffIcon)
    buffIcon:SetPosX(self._uiBackBuff:GetPosX() + iconSpan * (index - 1) + 2)
    buffIcon:SetPosY(self._uiBackBuff:GetPosY() + 2)
    buffIcon:SetShow(false)
    buffIcon:SetIgnore(false)
    local deBuffIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Instance_AppliedBuffList, "AppliedDeBuff_" .. index)
    CopyBaseProperty(styleDeBuffIcon, deBuffIcon)
    deBuffIcon:SetPosX(self._uiBackDeBuff:GetPosX() + iconSpan * (index - 1) + 2)
    deBuffIcon:SetPosY(self._uiBackDeBuff:GetPosY() + 2)
    deBuffIcon:SetShow(false)
    deBuffIcon:SetIgnore(false)
    buffIcon:addInputEvent("Mouse_On", "HandleMOnAppliedBuff(" .. index .. ",false)")
    buffIcon:addInputEvent("Mouse_Out", "HandleMOffAppliedBuff(" .. index .. ",false)")
    deBuffIcon:addInputEvent("Mouse_On", "HandleMOnAppliedBuff(" .. index .. ",true)")
    deBuffIcon:addInputEvent("Mouse_Out", "HandleMOffAppliedBuff(" .. index .. ",true)")
    self._uiBuffList[index] = buffIcon
    self._uiDeBuffList[index] = deBuffIcon
  end
  self._uiBackBuff:SetIgnore(true)
  self._uiBackDeBuff:SetIgnore(true)
  Instance_AppliedBuffList:addInputEvent("Mouse_On", "HandleMOnAppliedBuffPenel()")
  Instance_AppliedBuffList:addInputEvent("Mouse_Out", "HandleMOutAppliedBuffPenel()")
  Instance_AppliedBuffList:addInputEvent("Mouse_LUp", "ResetPos_WidgetButton()")
  self._initialized = true
  ResponseBuff_changeBuffList()
end
function PaGlobalAppliedBuffList:setMovableUIForControlMode()
  self._buffText:SetShow(false)
  Instance_AppliedBuffList:SetIgnore(false)
  Instance_AppliedBuffList:SetDragEnable(true)
  Instance_AppliedBuffList:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Default/window_sample_isWidget.dds")
end
function PaGlobalAppliedBuffList:cancelMovableUIForControlMode()
  self._buffText:SetShow(false)
  Instance_AppliedBuffList:SetDragEnable(false)
  Instance_AppliedBuffList:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Default/window_sample_empty.dds")
end
function PaGlobalAppliedBuffList:changeOnOffTexture(isOn)
  if true == isOn then
    if Panel_UIControl:IsShow() then
      Instance_AppliedBuffList:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/window_sample_drag.dds")
      self._buffText:SetText(PAGetString(Defines.StringSheet_GAME, "BUFF_LIST_MOVE"))
    end
  elseif Panel_UIControl:IsShow() then
    Instance_AppliedBuffList:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/window_sample_isWidget.dds")
    self._buffText:SetText(PAGetString(Defines.StringSheet_GAME, "BUFF_LIST"))
  else
    Instance_AppliedBuffList:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/window_sample_empty.dds")
  end
end
function PaGlobalAppliedBuffList:show()
  PaGlobalFunc_AppliedBuffList_ResetPosition()
end
function PaGlobalAppliedBuffList:hide()
  Instance_AppliedBuffList:SetShow(false, false)
end
function HandleMOnAppliedBuffPenel()
  AppliedBuffList:changeOnOffTexture(true)
end
function HandleMOutAppliedBuffPenel()
  AppliedBuffList:changeOnOffTexture(false)
end
function HandleMOnAppliedBuff(buffIndex, isDebuff)
  ShowBuffTooltip(buffIndex, isDebuff)
end
function HandleMOffAppliedBuff(buffIndex, isDebuff)
  HideBuffTooltip(buffIndex, isDebuff)
end
function renderModeChange_FromClient_AppliedBuffList_ResetPosition(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  PaGlobalFunc_AppliedBuffList_ResetPosition()
end
function FromClient_AppliedBuffList_luaLoadComplete()
  PaGlobalAppliedBuffList:initialize()
end
registerEvent("onScreenResize", "PaGlobalFunc_AppliedBuffList_ResetPosition")
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_FromClient_AppliedBuffList_ResetPosition")
registerEvent("FromClient_luaLoadComplete", "FromClient_AppliedBuffList_luaLoadComplete")
