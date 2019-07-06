Panel_Tooltip_Work:SetShow(false)
local UI_TM = CppEnums.TextMode
local VCK = CppEnums.VirtualKeyCode
Keep_Tooltip_Work = false
local control_Tooltip = {}
local Copy_Work_Tooltip = {}
local ResultItemEventInfoList = {}
local ResourceItemEventInfoList = {}
local default_Control = {
  _Work_Name = UI.getChildControl(Panel_Tooltip_Work, "StaticText_Work_Title"),
  _Work_Type = UI.getChildControl(Panel_Tooltip_Work, "StaticText_Work_ToolTipType"),
  _Btn_Close = UI.getChildControl(Panel_Tooltip_Work, "Button_Win_Close"),
  _Work_Des = UI.getChildControl(Panel_Tooltip_Work, "StaticText_Work_Description"),
  _Result_BG = UI.getChildControl(Panel_Tooltip_Work, "Static_WorkResult_BG"),
  _Result_Title = UI.getChildControl(Panel_Tooltip_Work, "StaticText_WorkResult_Title"),
  _Result_Icon = UI.getChildControl(Panel_Tooltip_Work, "Static_WorkResult_Icon"),
  _Result_IconBG = UI.getChildControl(Panel_Tooltip_Work, "Static_WorkResult_Icon_BG"),
  _Result_Name = UI.getChildControl(Panel_Tooltip_Work, "StaticText_WorkResult_Name"),
  _Resource_BG = UI.getChildControl(Panel_Tooltip_Work, "Static_WorkResource_BG"),
  _Resource_Title = UI.getChildControl(Panel_Tooltip_Work, "StaticText_WorkResource_Title"),
  _Resource_Icon = UI.getChildControl(Panel_Tooltip_Work, "Static_WorkResource_Icon"),
  _Resource_IconBG = UI.getChildControl(Panel_Tooltip_Work, "Static_WorkResource_Icon_BG"),
  _Resource_Name = UI.getChildControl(Panel_Tooltip_Work, "StaticText_WorkResource_Name"),
  _WorkVolume_BG = UI.getChildControl(Panel_Tooltip_Work, "Static_WorkVolume_BG"),
  _WorkVolume_Title = UI.getChildControl(Panel_Tooltip_Work, "StaticText_WorkVolum_Title"),
  _WorkVolume_Value = UI.getChildControl(Panel_Tooltip_Work, "StaticText_WorkVolum_Value"),
  _WorkVolume_Guide = UI.getChildControl(Panel_Tooltip_Work, "StaticText_WorkVolum_Guide"),
  _Guide = UI.getChildControl(Panel_Tooltip_Work, "StaticText_Guide")
}
local ShowOnOff = function(target, isOn)
  for k, value in pairs(target) do
    value:SetShow(isOn)
  end
end
ShowOnOff(default_Control, false)
local defalut_Param = {
  resourceMaxCount = 6,
  saveWorkIndex = nil,
  copyMaxCount = 10,
  saveCopyIndex = {}
}
local default_PosY_Size = {
  _Panel_SizeY = 0,
  _Work_Name_SizeY = 0,
  _Work_Des_PosY = 0,
  _Work_Des_SizeY = 0,
  _Result_BG_PosY = 0,
  _Resource_BG_PosY = 0,
  _Resource_BG_SizeY = 0,
  _WorkVolume_BG_PosY = 0,
  _WorkVolume_BG_SizeY = 0,
  _WorkVolume_Guide_SizeY = 0,
  _Guide_PosY = 0,
  _Guide_SizeY = 0,
  _Result_IconBG_SpanY = 0,
  _Result_IconBG_SizeY = 0,
  _Resource_gapY = 25,
  _AdjustPosY_SubPanel_1 = 0,
  _AdjustPosY_SubPanel_2 = 0,
  _AdjustPosY_SubPanel_3 = 0,
  _AdjustPosY_SubPanel_4 = 0
}
function default_PosY_Size:Init()
  self._Panel_SizeY = Panel_Tooltip_Work:GetSizeY()
  self._Work_Name_SizeY = default_Control._Work_Name:GetSizeY()
  self._Work_Des_PosY = default_Control._Work_Des:GetPosY()
  self._Work_Des_SizeY = default_Control._Work_Des:GetSizeY()
  self._Result_BG_PosY = default_Control._Result_BG:GetPosY()
  self._Resource_BG_PosY = default_Control._Resource_BG:GetPosY()
  self._Resource_BG_SizeY = default_Control._Resource_BG:GetSizeY()
  self._WorkVolume_BG_PosY = default_Control._WorkVolume_BG:GetPosY()
  self._WorkVolume_BG_SizeY = default_Control._WorkVolume_BG:GetSizeY()
  self._WorkVolume_Guide_SizeY = default_Control._WorkVolume_Guide:GetSizeY()
  self._Guide_PosY = default_Control._Guide:GetPosY()
  self._Guide_SizeY = default_Control._Guide:GetSizeY()
  self._Result_IconBG_SizeY = default_Control._Result_IconBG:GetSizeY()
end
default_PosY_Size:Init()
local function Create_Control(index, isInit)
  local idx = -1
  local self
  if true == isInit then
    self = control_Tooltip
    self._Panel = Panel_Tooltip_Work
  else
    idx = index
    Copy_Work_Tooltip[idx] = {}
    self = Copy_Work_Tooltip[idx]
    self._Panel = UI.createPanelAndSetPanelRenderMode("Panel_Tooltip_Work_" .. tostring(idx), Defines.UIGroup.PAGameUIGroup_GameMenu, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_WorldMap
    }))
    CopyBaseProperty(Panel_Tooltip_Work, self._Panel)
    self._Panel:ActiveMouseEventEffect(true)
    self._Panel:setGlassBackground(true)
  end
  self._Work_Name = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._Panel, "StaticText_Work_Title_" .. tostring(idx))
  self._Work_Type = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._Panel, "StaticText_Work_Type_" .. tostring(idx))
  self._Work_Des = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._Panel, "StaticText_Work_Description_" .. tostring(idx))
  self._Result_BG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._Panel, "Static_WorkResult_BG_" .. tostring(idx))
  self._Resource_BG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._Panel, "Static_WorkResource_BG_" .. tostring(idx))
  self._WorkVolume_BG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._Panel, "Static_WorkVolume_BG_" .. tostring(idx))
  CopyBaseProperty(default_Control._Work_Name, self._Work_Name)
  CopyBaseProperty(default_Control._Work_Type, self._Work_Type)
  CopyBaseProperty(default_Control._Work_Des, self._Work_Des)
  CopyBaseProperty(default_Control._Result_BG, self._Result_BG)
  CopyBaseProperty(default_Control._Resource_BG, self._Resource_BG)
  CopyBaseProperty(default_Control._WorkVolume_BG, self._WorkVolume_BG)
  self._Work_Name:SetAutoResize(true)
  self._Work_Name:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._Result_Title = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._Result_BG, "Result_Title" .. tostring(idx))
  self._Result_IconBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._Result_BG, "Result_IconBG" .. tostring(idx))
  self._Result_Icon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._Result_BG, "Result_Icon" .. tostring(idx))
  self._Result_Name = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._Result_BG, "Result_Name" .. tostring(idx))
  self._Resource_Title = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._Resource_BG, "Resource_Title" .. tostring(idx))
  self._WorkVolume_Title = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._WorkVolume_BG, "WorkVolume_Title" .. tostring(idx))
  self._WorkVolume_Value = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._WorkVolume_BG, "WorkVolume_Value" .. tostring(idx))
  self._WorkVolume_Guide = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._WorkVolume_BG, "WorkVolume_Guide" .. tostring(idx))
  CopyBaseProperty(default_Control._Result_Title, self._Result_Title)
  CopyBaseProperty(default_Control._Result_IconBG, self._Result_IconBG)
  CopyBaseProperty(default_Control._Result_Icon, self._Result_Icon)
  CopyBaseProperty(default_Control._Result_Name, self._Result_Name)
  CopyBaseProperty(default_Control._Resource_Title, self._Resource_Title)
  CopyBaseProperty(default_Control._WorkVolume_Title, self._WorkVolume_Title)
  CopyBaseProperty(default_Control._WorkVolume_Value, self._WorkVolume_Value)
  CopyBaseProperty(default_Control._WorkVolume_Guide, self._WorkVolume_Guide)
  self._WorkVolume_Guide:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._WorkVolume_Guide:SetAutoResize(true)
  local spanX = self._Result_BG:GetSpanSize().x
  local spanY = self._Result_BG:GetSpanSize().y
  self._Result_Title:SetSpanSize(self._Result_Title:GetSpanSize().x - spanX, self._Result_Title:GetSpanSize().y - spanY)
  self._Result_IconBG:SetSpanSize(self._Result_IconBG:GetSpanSize().x - spanX, self._Result_IconBG:GetSpanSize().y - spanY)
  if true == isInit then
    default_PosY_Size._Result_IconBG_SpanY = self._Result_IconBG:GetSpanSize().y
    self._Guide = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._Panel, "StaticText_Guide_" .. tostring(idx))
    CopyBaseProperty(default_Control._Guide, self._Guide)
    self._Guide:SetTextMode(UI_TM.eTextMode_AutoWrap)
    self._Guide:SetAutoResize(true)
    self._Guide:SetTextVerticalTop()
    self._Guide:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_WORK_GUIDE"))
    default_PosY_Size._AdjustPosY_SubPanel_4 = self._Guide:GetSizeY() - default_PosY_Size._Guide_SizeY
    self._Work_Type:SetSpanSize(self._Work_Type:GetSpanSize().x - 11, self._Work_Type:GetSpanSize().y)
  elseif false == isInit then
    self._Btn_Close = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, self._Panel, "Btn_Colse_" .. tostring(idx))
    CopyBaseProperty(default_Control._Btn_Close, self._Btn_Close)
    self._Btn_Close:addInputEvent("Mouse_LUp", "FGlobal_Hide_Tooltip_Work_Copy(" .. idx .. ", false)")
  end
  self._Result_Icon:SetSpanSize(self._Result_Icon:GetSpanSize().x - spanX, self._Result_Icon:GetSpanSize().y - spanY)
  self._Result_Name:SetSpanSize(self._Result_Name:GetSpanSize().x - spanX, self._Result_Name:GetSpanSize().y - spanY)
  self._Result_Name:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._Result_Name:SetAutoResize(true)
  spanX = self._Resource_BG:GetSpanSize().x
  spanY = self._Resource_BG:GetSpanSize().y
  self._Resource_Title:SetSpanSize(self._Resource_Title:GetSpanSize().x - spanX, self._Resource_Title:GetSpanSize().y - spanY)
  spanX = self._WorkVolume_BG:GetSpanSize().x
  spanY = self._WorkVolume_BG:GetSpanSize().y
  self._WorkVolume_Title:SetSpanSize(self._WorkVolume_Title:GetSpanSize().x - spanX, self._WorkVolume_Title:GetSpanSize().y - spanY)
  self._WorkVolume_Value:SetSpanSize(self._WorkVolume_Value:GetSpanSize().x - spanX, self._WorkVolume_Value:GetSpanSize().y - spanY)
  self._WorkVolume_Guide:SetSpanSize(self._WorkVolume_Guide:GetSpanSize().x - spanX, self._WorkVolume_Guide:GetSpanSize().y - spanY)
  ShowOnOff(self, true)
  self._Panel:SetShow(false)
  self._Resource_IconBG = {}
  self._Resource_Icon = {}
  self._Resource_Name = {}
  for key = 0, defalut_Param.resourceMaxCount - 1 do
    self._Resource_IconBG[key] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._Resource_BG, "Resource_IconBG" .. tostring(idx) .. "_" .. tostring(key))
    self._Resource_Icon[key] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._Resource_BG, "Resource_Icon" .. tostring(idx) .. "_" .. tostring(key))
    self._Resource_Name[key] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._Resource_BG, "Resource_Name" .. tostring(idx) .. "_" .. tostring(key))
    CopyBaseProperty(default_Control._Resource_IconBG, self._Resource_IconBG[key])
    CopyBaseProperty(default_Control._Resource_Icon, self._Resource_Icon[key])
    CopyBaseProperty(default_Control._Resource_Name, self._Resource_Name[key])
    local spanX = self._Resource_BG:GetSpanSize().x
    local spanY = self._Resource_BG:GetSpanSize().y
    self._Resource_IconBG[key]:SetSpanSize(self._Resource_IconBG[key]:GetSpanSize().x - spanX, self._Resource_IconBG[key]:GetSpanSize().y - spanY + default_PosY_Size._Resource_gapY * key)
    self._Resource_Icon[key]:SetSpanSize(self._Resource_Icon[key]:GetSpanSize().x - spanX, self._Resource_Icon[key]:GetSpanSize().y - spanY + default_PosY_Size._Resource_gapY * key)
    self._Resource_Name[key]:SetSpanSize(self._Resource_Name[key]:GetSpanSize().x - spanX, self._Resource_Name[key]:GetSpanSize().y - spanY + default_PosY_Size._Resource_gapY * key)
    self._Resource_IconBG[key]:SetShow(false)
    self._Resource_Icon[key]:SetShow(false)
    self._Resource_Name[key]:SetShow(false)
  end
end
Create_Control(-1, true)
local function Set_Control_SizePoS(controlIndex, isTooltip)
  local self = default_PosY_Size
  local _Adjust_CopyPanel_Size = 0
  if true == isTooltip then
    target = control_Tooltip
    _Adjust_CopyPanel_Size = self._AdjustPosY_SubPanel_4
  elseif false == isTooltip then
    target = Copy_Work_Tooltip[controlIndex]
    _Adjust_CopyPanel_Size = -20
  end
  target._Result_BG:SetPosY(self._Result_BG_PosY + self._AdjustPosY_SubPanel_1)
  target._Resource_BG:SetPosY(self._Resource_BG_PosY + self._AdjustPosY_SubPanel_1)
  target._Resource_BG:SetSize(target._Resource_BG:GetSizeX(), self._Resource_BG_SizeY + self._AdjustPosY_SubPanel_2)
  target._WorkVolume_BG:SetPosY(self._WorkVolume_BG_PosY + self._AdjustPosY_SubPanel_1 + self._AdjustPosY_SubPanel_2)
  target._WorkVolume_BG:SetSize(target._WorkVolume_BG:GetSizeX(), self._WorkVolume_BG_SizeY + self._AdjustPosY_SubPanel_3)
  if nil ~= target._Guide then
    target._Guide:SetPosY(target._WorkVolume_BG:GetPosY() + target._WorkVolume_BG:GetSizeY() + 5)
  end
  target._Panel:SetSize(Panel_Tooltip_Work:GetSizeX(), self._Panel_SizeY + self._AdjustPosY_SubPanel_1 + self._AdjustPosY_SubPanel_2 + self._AdjustPosY_SubPanel_3 + _Adjust_CopyPanel_Size)
end
local clearResource = function(target)
  for key, value in pairs(target._Resource_Icon) do
    value:SetShow(false)
  end
  for key, value in pairs(target._Resource_IconBG) do
    value:SetShow(false)
  end
  for key, value in pairs(target._Resource_Name) do
    value:SetShow(false)
  end
end
local UpdatePosition_Tooltip = function(uiBase)
  if nil == uiBase then
    FGlobal_Hide_Tooltip_Work(nil, true)
    return
  end
  local parentPosX = uiBase:GetParentPosX()
  local parentPosY = uiBase:GetParentPosY()
  local panelSizeX = Panel_Tooltip_Work:GetSizeX()
  local panelSizeY = Panel_Tooltip_Work:GetSizeY()
  local posX = parentPosX + uiBase:GetSizeX() + 5
  if posX + panelSizeX > getScreenSizeX() then
    posX = parentPosX - panelSizeX - 5
  elseif posX < 5 then
    posX = 5
  end
  local posY = parentPosY - 5
  if posY + panelSizeY > getScreenSizeY() then
    posY = parentPosY - panelSizeY + uiBase:GetSizeY() + 5
    if posY + panelSizeY > getScreenSizeY() then
      posY = getScreenSizeY() - panelSizeY + 5
    end
  elseif posY < 5 then
    posY = 5
  end
  Panel_Tooltip_Work:SetPosX(posX)
  Panel_Tooltip_Work:SetPosY(posY)
end
local function Insert_Tooltip_Work_Data(esSSW, isToolTip, controlIndex, nodeInfo, nodeType, isGuildManufactureSelect)
  local self
  if true == isToolTip then
    self = control_Tooltip
    defalut_Param.esSS = esSSW:get()
  elseif false == isToolTip then
    self = Copy_Work_Tooltip[controlIndex]
  end
  ResourceItemEventInfoList[controlIndex] = {}
  ResultItemEventInfoList[controlIndex] = {}
  if nil == esSSW and true == isToolTip then
    FGlobal_Hide_Tooltip_Work(nil, true)
    return
  elseif nil == esSSW and false == isToolTip then
    return
  end
  if nodeType == CppEnums.NpcWorkingType.eNpcWorkingType_PlantBuliding then
  else
    local esSS = esSSW:get()
    local itemStatic = esSS:getFirstDropGroup():getItemStaticStatus()
    local workName = esSSW:getDescription()
    if nil == workName or "" == workName then
      workName = getItemName(itemStatic)
    end
    self._Work_Name:SetText(workName)
    local adjustTitle = self._Work_Name:GetSizeY() - default_PosY_Size._Work_Name_SizeY
    local workDes = esSSW:getDetailDescription()
    if nil == workDes then
      self._Work_Des:SetShow(false)
      default_PosY_Size._AdjustPosY_SubPanel_1 = default_PosY_Size._Work_Des_PosY - default_PosY_Size._Result_BG_PosY + adjustTitle
    else
      self._Work_Des:SetTextMode(UI_TM.eTextMode_AutoWrap)
      self._Work_Des:SetAutoResize(true)
      self._Work_Des:SetText(workDes)
      self._Work_Des:SetShow(true)
      self._Work_Des:SetPosY(default_PosY_Size._Work_Des_PosY + adjustTitle)
      default_PosY_Size._AdjustPosY_SubPanel_1 = self._Work_Des:GetSizeY() - default_PosY_Size._Work_Des_SizeY + adjustTitle
    end
    local resultIcon = "icon/" .. esSSW:getIcon()
    local resultName = workName
    if false == esSSW:getUseExchangeIcon() then
      resultName = getItemName(itemStatic)
      ResultItemEventInfoList[controlIndex] = itemStatic._key
      self._Result_IconBG:addInputEvent("Mouse_On", "Copy_Item_Tooltip_Show(" .. controlIndex .. ", resourceIndex, true, " .. tostring(isToolTip) .. " )")
      self._Result_IconBG:addInputEvent("Mouse_Out", "Copy_Item_Tooltip_Hide()")
    else
      ResultItemEventInfoList[controlIndex] = nil
    end
    self._Result_Icon:ChangeTextureInfoName(resultIcon)
    self._Result_Name:SetText(resultName)
    local spanY = default_PosY_Size._Result_IconBG_SpanY + (default_PosY_Size._Result_IconBG_SizeY - self._Result_Name:GetSizeY()) / 2 - 5
    self._Result_Name:SetSpanSize(self._Result_Name:GetSpanSize().x, spanY)
    clearResource(self)
    local eSSCount = getExchangeSourceNeedItemList(esSS, true)
    if eSSCount > 0 then
      default_PosY_Size._AdjustPosY_SubPanel_2 = default_PosY_Size._Resource_gapY * (eSSCount - 1)
      control_Tooltip._Resource_BG:SetShow(true)
    else
      default_PosY_Size._AdjustPosY_SubPanel_2 = default_PosY_Size._Resource_BG_PosY - default_PosY_Size._WorkVolume_BG_PosY
      control_Tooltip._Resource_BG:SetShow(false)
    end
    for idx = 0, eSSCount - 1 do
      local itemStatic = esSSW:getResourceItemStaticStatusWrapper(idx):get()
      local itemIcon = "icon/" .. getItemIconPath(itemStatic)
      local itemName = getItemName(itemStatic)
      local itemStaticInfomationWrapper = getExchangeSourceNeedItemByIndex(idx)
      local needCount = Int64toInt32(itemStaticInfomationWrapper:getCount_s64())
      self._Resource_Icon[idx]:ChangeTextureInfoName(itemIcon)
      self._Resource_Name[idx]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      self._Resource_Name[idx]:SetText(itemName .. " ( " .. tostring(needCount) .. " )")
      self._Resource_Icon[idx]:SetShow(true)
      self._Resource_IconBG[idx]:SetShow(true)
      self._Resource_Name[idx]:SetShow(true)
      self._Resource_IconBG[idx]:addInputEvent("Mouse_On", "Copy_Item_Tooltip_Show(" .. controlIndex .. ", " .. idx .. ", false, " .. tostring(isToolTip) .. " )")
      self._Resource_IconBG[idx]:addInputEvent("Mouse_Out", "Copy_Item_Tooltip_Hide()")
      ResourceItemEventInfoList[controlIndex][idx] = itemStatic._key
    end
    local workVolume = Int64toInt32(esSS._productTime / toInt64(0, 1000))
    local defaultWorkSpeed = 50
    local defaultWorkTime = ToClient_getNpcWorkingBaseTime() / 60000
    if nodeType == CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse or nodeType == CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouseLargeCraft then
      defaultWorkTime = ToClient_getNpcWorkingBaseTimeForHouse() / 60000
    end
    local workTime = math.ceil(workVolume / defaultWorkSpeed) * defaultWorkTime
    self._WorkVolume_Value:SetText("( " .. workVolume .. " )")
    self._WorkVolume_Guide:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TOOLTIP_WORK_TIME_0", "default_WorkSpeed", defaultWorkSpeed, "work_time", workTime))
    if false == _ContentsGroup_GuildManufacture then
      default_PosY_Size._AdjustPosY_SubPanel_3 = self._WorkVolume_Guide:GetSizeY() - default_PosY_Size._WorkVolume_Guide_SizeY
    elseif true == esSSW:isGuildManufactureItem() then
      default_PosY_Size._AdjustPosY_SubPanel_3 = self._Resource_Name[eSSCount - 1]:GetSizeY() - default_PosY_Size._Resource_BG_SizeY
      self._WorkVolume_BG:SetShow(false)
      self._WorkVolume_Title:SetShow(false)
      self._WorkVolume_Value:SetShow(false)
      self._WorkVolume_Guide:SetShow(false)
    else
      default_PosY_Size._AdjustPosY_SubPanel_3 = self._WorkVolume_Guide:GetSizeY() - default_PosY_Size._WorkVolume_Guide_SizeY
      self._WorkVolume_BG:SetShow(true)
      self._WorkVolume_Title:SetShow(true)
      self._WorkVolume_Value:SetShow(true)
      self._WorkVolume_Guide:SetShow(true)
    end
    if nil ~= self._Guide then
      if true == isGuildManufactureSelect then
        self._Guide:SetShow(false)
        default_PosY_Size._AdjustPosY_SubPanel_3 = default_PosY_Size._AdjustPosY_SubPanel_3 - self._Guide:GetSizeY()
      else
        self._Guide:SetShow(true)
      end
    end
    if true == isToolTip then
    end
  end
end
function FGlobal_Hide_Tooltip_Work(esSSW, isReset)
  if true ~= isReset then
    if esSSW == nil then
      return
    elseif esSSW ~= nil and defalut_Param.esSS == esSSW:get() then
      return
    end
  end
  defalut_Param.esSS = nil
  Panel_Tooltip_Work:SetShow(false)
end
function FGlobal_Show_Tooltip_Work(esSSW, uiBase, nodeInfo, nodeType, isGuildManufactureSelect)
  audioPostEvent_SystemUi(1, 13)
  Insert_Tooltip_Work_Data(esSSW, true, -1, nodeInfo, nodeType, isGuildManufactureSelect)
  Set_Control_SizePoS(-1, true)
  UpdatePosition_Tooltip(uiBase)
  Panel_Tooltip_Work:SetShow(true)
end
function FGlobal_Hide_Tooltip_Work_Copy(idx, isReset)
  for key, vlaue in pairs(Copy_Work_Tooltip) do
    if (key == idx or true == isReset) and nil ~= vlaue._Panel then
      UI.deletePanel("Panel_Tooltip_Work_" .. tostring(key))
      Copy_Work_Tooltip[key] = nil
      defalut_Param.saveCopyIndex[key] = nil
    end
  end
end
function FGlobal_HideAll_Tooltip_Work_Copy()
  for key, vlaue in pairs(Copy_Work_Tooltip) do
    if nil ~= vlaue._Panel then
      UI.deletePanel("Panel_Tooltip_Work_" .. tostring(key))
      Copy_Work_Tooltip[key] = nil
      defalut_Param.saveCopyIndex[key] = nil
    end
  end
end
function FGlobal_Show_Tooltip_Work_Copy(esSSW, nodeInfo, nodeType)
  local checkKey = 0
  local idx
  for key = 0, defalut_Param.copyMaxCount - 1 do
    if nil == Copy_Work_Tooltip[key] then
      idx = key
      break
    end
  end
  if nil == idx then
    return
  end
  for key = 0, defalut_Param.copyMaxCount - 1 do
    if nil ~= defalut_Param.saveCopyIndex[key] and defalut_Param.saveCopyIndex[key].esSS == esSSW:get() then
      return
    end
  end
  defalut_Param.saveCopyIndex[idx] = {}
  defalut_Param.saveCopyIndex[idx].esSS = esSSW:get()
  Create_Control(idx, false)
  Insert_Tooltip_Work_Data(esSSW, false, idx, nodeInfo, nodeType)
  Set_Control_SizePoS(idx, false)
  Copy_Work_Tooltip[idx]._Panel:SetPosX(idx * 20)
  Copy_Work_Tooltip[idx]._Panel:SetPosY(idx * 20)
  Copy_Work_Tooltip[idx]._Panel:SetShow(true)
end
function Copy_Item_Tooltip_Show(controlIndex, resourceIndex, isResult, isToolTip)
  local staticStatusKey
  if isResult then
    staticStatusKey = ResultItemEventInfoList[controlIndex]
  else
    staticStatusKey = ResourceItemEventInfoList[controlIndex][resourceIndex]
  end
  if nil == staticStatusKey then
    return
  end
  local staticStatusWrapper = getItemEnchantStaticStatus(staticStatusKey)
  local uiBase
  if true == isToolTip then
    uiBase = Panel_Tooltip_Work
  else
    uiBase = Copy_Work_Tooltip[controlIndex]._Panel
  end
  Panel_Tooltip_Item_Show(staticStatusWrapper, uiBase, true, false)
end
function Copy_Item_Tooltip_Hide()
  Panel_Tooltip_Item_hideTooltip()
end
function Keep_Work_ToolTip()
  if false == Keep_Tooltip_Work then
    return
  end
  if isKeyPressed(VCK.KeyCode_CONTROL) then
    return
  else
    FGlobal_Hide_Tooltip_Work(defalut_Param.esSS, true)
    Panel_Tooltip_Item_hideTooltip()
    Keep_Tooltip_Work = false
  end
end
Panel_Tooltip_Work:RegisterUpdateFunc("Keep_Work_ToolTip")
