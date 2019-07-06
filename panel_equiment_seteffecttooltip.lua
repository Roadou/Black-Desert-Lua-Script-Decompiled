Panel_Equipment_SetEffectTooltip:SetShow(false, false)
Panel_Equipment_SetEffectTooltip:ActiveMouseEventEffect(true)
Panel_Equipment_SetEffectTooltip:setMaskingChild(true)
Panel_Equipment_SetEffectTooltip:setGlassBackground(true)
PaGlobal_EquipmentTooltip = {
  _ui = {
    _Title = UI.getChildControl(Panel_Equipment_SetEffectTooltip, "StaticText_Title"),
    _NoEffect = UI.getChildControl(Panel_Equipment_SetEffectTooltip, "StaticText_NoEffect"),
    _BaseGroupTitle = UI.getChildControl(Panel_Equipment_SetEffectTooltip, "StaticText_EffectGroupTitle"),
    _BasePartTitle = UI.getChildControl(Panel_Equipment_SetEffectTooltip, "StaticText_EffectPartTitle"),
    _BaseSetDesc = UI.getChildControl(Panel_Equipment_SetEffectTooltip, "StaticText_EffectDesc"),
    _Desc = UI.getChildControl(Panel_Equipment_SetEffectTooltip, "StaticText_Desc"),
    _GroupTitle = {},
    _PartTitle = {},
    _PartDesc = {},
    _usingGroupTitleCount = 0,
    _usingPartTitleCount = 0,
    _usingPartDescCount = 0
  },
  _maxSetEffectCount = 10,
  _isDetail = false,
  _panel = Panel_Equipment_SetEffectTooltip,
  _info = {}
}
function PaGlobal_EquipmentTooltip:createAllGroupTitleUI()
  for index = 0, self._maxSetEffectCount - 1 do
    local controlName = "GroupTitle_" .. index
    local control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._panel, controlName)
    CopyBaseProperty(self._ui._BaseGroupTitle, control)
    control:SetShow(false)
    table.insert(self._ui._GroupTitle, control)
  end
end
function PaGlobal_EquipmentTooltip:useGroupTitleUI()
  if #self._ui._GroupTitle <= self._ui._usingGroupTitleCount then
    return
  end
  self._ui._usingGroupTitleCount = self._ui._usingGroupTitleCount + 1
  return self._ui._GroupTitle[self._ui._usingGroupTitleCount]
end
function PaGlobal_EquipmentTooltip:createPartTitleUI()
  local control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._panel, "PartTitle_" .. #self._ui._PartTitle)
  CopyBaseProperty(self._ui._BasePartTitle, control)
  control:SetShow(false)
  control:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  table.insert(self._ui._PartTitle, control)
end
function PaGlobal_EquipmentTooltip:usePartTitleUI()
  if #self._ui._PartTitle <= self._ui._usingPartTitleCount then
    self:createPartTitleUI()
  end
  self._ui._usingPartTitleCount = self._ui._usingPartTitleCount + 1
  return self._ui._PartTitle[self._ui._usingPartTitleCount]
end
function PaGlobal_EquipmentTooltip:createPartDescUI()
  local control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._panel, "PartDesc_" .. #self._ui._PartDesc)
  CopyBaseProperty(self._ui._BaseSetDesc, control)
  control:SetShow(false)
  control:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  table.insert(self._ui._PartDesc, control)
end
function PaGlobal_EquipmentTooltip:usePartDescUI()
  if #self._ui._PartDesc <= self._ui._usingPartDescCount then
    self:createPartDescUI()
  end
  self._ui._usingPartDescCount = self._ui._usingPartDescCount + 1
  return self._ui._PartDesc[self._ui._usingPartDescCount]
end
function PaGlobal_EquipmentTooltip:SetPos()
  if true == _ContentsGroup_RenewUI then
    return
  end
  local posX = Panel_Equipment:GetPosX() - self._panel:GetSizeX()
  if posX < 0 then
    posX = Panel_Equipment:GetPosX() + Panel_Equipment:GetSizeX()
  end
  local posY = Panel_Equipment:GetPosY() + Panel_Equipment:GetSizeY() - self._panel:GetSizeY() - 10
  if posY < 0 then
    posY = 0
  elseif getScreenSizeY() < posY + self._panel:GetSizeY() then
    posY = getScreenSizeY() - self._panel:GetSizeY()
  end
  self._panel:SetPosX(posX)
  self._panel:SetPosY(posY)
end
function PaGlobal_EquipmentTooltip:initWithIcon(icon)
  if not icon then
    return false
  end
  icon:addInputEvent("Mouse_On", "PaGlobal_EquipmentTooltip:show(true)")
  icon:addInputEvent("Mouse_Out", "PaGlobal_EquipmentTooltip:show(false)")
  icon:addInputEvent("Mouse_LUp", "PaGlobal_EquipmentTooltip:toggleDetail()")
  return true
end
function PaGlobal_EquipmentTooltip:show(showFlag)
  if self._panel:GetShow() == showFlag then
    return false
  end
  self._panel:SetShow(showFlag, showFlag)
  PaGlobal_Tooltip_BattlePoint:show(false)
  if showFlag then
    self._isDetail = false
    self:updateInfo()
    self:updateUI()
  end
  return true
end
function PaGlobal_EquipmentTooltip:updateInfo()
  self._info = {}
  local sortedInfoList = ToClient_GetSkillPieceInfo()
  if not sortedInfoList then
    return false
  end
  function _getInfoBySkillNo(skillNo)
    for _, info in ipairs(self._info) do
      if info.skillNo == skillNo then
        return info
      end
    end
  end
  for i = 0, #sortedInfoList do
    local skillNo = sortedInfoList[i]:getSkillNo()
    local info = _getInfoBySkillNo(skillNo)
    if not info then
      table.insert(self._info, {
        skillNo = skillNo,
        groupTitle = sortedInfoList[i]:getGroupTitle(),
        pointInfo = {},
        appliedPoint = 0
      })
      info = _getInfoBySkillNo(skillNo)
    end
    local isApplied = sortedInfoList[i]:getApply()
    local point = sortedInfoList[i]:getPoint()
    table.insert(info.pointInfo, {
      point = point,
      descTitle = sortedInfoList[i]:getDescTitle(),
      desc = sortedInfoList[i]:getDesc(),
      isApplied = isApplied
    })
    if isApplied and point > info.appliedPoint then
      info.appliedPoint = point
    end
  end
  return true
end
function PaGlobal_EquipmentTooltip:initUI()
  function _hideAll(uiTable)
    for _, control in ipairs(uiTable) do
      control:SetShow(false)
    end
  end
  _hideAll(self._ui._GroupTitle)
  self._ui._usingGroupTitleCount = 0
  _hideAll(self._ui._PartTitle)
  self._ui._usingPartTitleCount = 0
  _hideAll(self._ui._PartDesc)
  self._ui._usingPartDescCount = 0
  self._ui._Title:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._NoEffect:SetShow(false)
end
function PaGlobal_EquipmentTooltip:updateInfoUI()
  local prevControl
  for _, skillInfo in ipairs(self._info) do
    if 0 < skillInfo.appliedPoint or self._isDetail then
      local groupTitle = self:useGroupTitleUI()
      groupTitle:SetText(skillInfo.groupTitle)
      groupTitle:SetShow(true)
      if prevControl then
        groupTitle:SetPosY(prevControl:GetPosY() + prevControl:GetTextSizeY() + 15)
      else
        groupTitle:SetPosY(45)
      end
      prevControl = groupTitle
      local reservedpartTitlePrevControl = prevControl
      for _, pointInfo in ipairs(skillInfo.pointInfo) do
        if skillInfo.appliedPoint <= pointInfo.point and pointInfo.isApplied or self._isDetail then
          local partTitle = self:usePartTitleUI()
          partTitle:SetText(pointInfo.descTitle)
          local partTitlePrevControl
          if self._isDetail then
            partTitlePrevControl = prevControl
          else
            partTitlePrevControl = reservedpartTitlePrevControl
          end
          partTitle:SetPosY(partTitlePrevControl:GetPosY() + partTitlePrevControl:GetTextSizeY() + 7)
          partTitle:SetShow(true)
        end
        if pointInfo.isApplied or self._isDetail then
          local partDesc = self:usePartDescUI()
          if pointInfo.isApplied then
            partDesc:SetFontColor(Defines.Color.C_FF96D4FC)
          else
            partDesc:SetFontColor(Defines.Color.C_FFC4BEBE)
          end
          partDesc:SetText(pointInfo.desc)
          partDesc:SetPosY(prevControl:GetPosY() + prevControl:GetTextSizeY() + 7)
          partDesc:SetShow(true)
          prevControl = partDesc
        end
      end
    end
  end
  return prevControl
end
function PaGlobal_EquipmentTooltip:updateUI()
  self:initUI()
  local prevControl = self:updateInfoUI()
  if prevControl then
    local sizeY = prevControl:GetPosY() + prevControl:GetTextSizeY() + 15 + self._ui._Desc:GetTextSizeY()
    self._panel:SetSize(self._panel:GetSizeX(), sizeY)
  else
    self._ui._NoEffect:SetShow(true)
    self._panel:SetSize(self._panel:GetSizeX(), 200)
  end
  self._ui._Desc:SetShow(true)
  if prevControl then
  end
  if self._isDetail then
    self._ui._Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_EQUIPMENT_SETEFFECTDETAIL_TITLE"))
  else
    self._ui._Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_EQUIPMENT_SETEFFECT_TITLE"))
  end
  self._ui._Desc:ComputePos()
  self:SetPos()
end
function PaGlobal_EquipmentTooltip:toggleDetail()
  self._isDetail = not self._isDetail
  self:updateUI()
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
end
function FGlobal_EquipmentTooltip_Init()
  self = PaGlobal_EquipmentTooltip
  self:createAllGroupTitleUI()
  self._ui._NoEffect:SetShow(false)
  self._ui._BaseGroupTitle:SetShow(false)
  self._ui._BasePartTitle:SetShow(false)
  self._ui._BaseSetDesc:SetShow(false)
  self._ui._Desc:SetShow(false)
  self._ui._Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._Desc:SetText(self._ui._Desc:GetText())
end
registerEvent("FromClient_luaLoadComplete", "FGlobal_EquipmentTooltip_Init()")
