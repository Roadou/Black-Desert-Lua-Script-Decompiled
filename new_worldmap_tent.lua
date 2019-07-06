local UI_TYPE = CppEnums.PA_UI_CONTROL_TYPE
local UI_INSTALL = CppEnums.InstallationType
local _tentTitle = UI.getChildControl(Panel_Worldmap_TentInfo, "StaticText_Title")
local _tentTitleBG = UI.getChildControl(Panel_Worldmap_TentInfo, "Static_TitleBG")
local _remainTime = UI.getChildControl(Panel_Worldmap_TentInfo, "StaticText_V_RemainTime")
local _workingDataBg = UI.getChildControl(Panel_Worldmap_TentInfo, "Static_HouseControl_BG")
local _workingListBg = UI.getChildControl(Panel_Worldmap_TentInfo, "Static_C_BG")
local _workingText = UI.getChildControl(Panel_Worldmap_TentInfo, "StaticText_T_ProCount")
local workingRawSizeY = 0
local defaultWorkingListSize = 0
local defaultWorkingDataSizeWithoutList = 0
local defaultWorkingPanelSizeWithoutList = 0
local tentInformationMouseOverActorKey = 0
local defaultPercentPosX = 0
local defaultIconPruningPosX = 0
local defaultIconInsectDamegePosX = 0
local defalutRemainTimePosX = _remainTime:GetPosX()
local defalutWorkingDataBGSizeX = _workingDataBg:GetSizeX()
local defalutWorkingListBGSizeX = _workingListBg:GetSizeX()
local defalutPanelSizeX = Panel_Worldmap_TentInfo:GetSizeX()
local template = {
  _iconSlot = UI.getChildControl(Panel_Worldmap_TentInfo, "Static_C_IconSlot"),
  _icon = UI.getChildControl(Panel_Worldmap_TentInfo, "Static_C_Icon"),
  _itemName = UI.getChildControl(Panel_Worldmap_TentInfo, "StaticText_C_ItemName"),
  _gageBg = UI.getChildControl(Panel_Worldmap_TentInfo, "Static_C_GaugeBG"),
  _progress = UI.getChildControl(Panel_Worldmap_TentInfo, "Progress2_C_Gauge"),
  _percent = UI.getChildControl(Panel_Worldmap_TentInfo, "StaticText_C_Percent"),
  _iconPruning = UI.getChildControl(Panel_Worldmap_TentInfo, "Static_CropsIcon_Pruning"),
  _iconInsectDamege = UI.getChildControl(Panel_Worldmap_TentInfo, "Static_CropsIcon_InsectDamege")
}
local createList = {}
local function initTentInfo()
  for _, value in pairs(template) do
    workingRawSizeY = math.max(workingRawSizeY, value:GetSizeY())
    value:SetShow(false)
  end
  workingRawSizeY = workingRawSizeY + 6
  defaultWorkingListSize = _workingListBg:GetSizeY() - workingRawSizeY
  defaultWorkingDataSizeWithoutList = _workingDataBg:GetSizeY() - _workingListBg:GetSizeY()
  defaultWorkingPanelSizeWithoutList = Panel_Worldmap_TentInfo:GetSizeY() - _workingListBg:GetSizeY()
  local maxCount = ToClient_GetMaxHarvestCount()
  local pushYValue = 0
  for index = 0, maxCount - 1 do
    local dataGroup = {}
    dataGroup._iconSlot = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATIC, Panel_Worldmap_TentInfo, "Static_C_IconSlot_" .. index)
    CopyBaseProperty(template._iconSlot, dataGroup._iconSlot)
    dataGroup._iconSlot:SetPosY(template._iconSlot:GetPosY() + pushYValue)
    dataGroup._icon = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATIC, Panel_Worldmap_TentInfo, "Static_C_Icon_" .. index)
    CopyBaseProperty(template._icon, dataGroup._icon)
    dataGroup._icon:SetPosY(template._icon:GetPosY() + pushYValue)
    dataGroup._itemName = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Worldmap_TentInfo, "StaticText_C_ItemName_" .. index)
    CopyBaseProperty(template._itemName, dataGroup._itemName)
    dataGroup._itemName:SetPosY(template._itemName:GetPosY() + pushYValue)
    dataGroup._gageBg = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATIC, Panel_Worldmap_TentInfo, "Static_C_GaugeBG_" .. index)
    CopyBaseProperty(template._gageBg, dataGroup._gageBg)
    dataGroup._gageBg:SetPosY(template._gageBg:GetPosY() + pushYValue)
    dataGroup._progress = UI.createControl(UI_TYPE.PA_UI_CONTROL_PROGRESS2, Panel_Worldmap_TentInfo, "Progress2_C_Gauge_" .. index)
    CopyBaseProperty(template._progress, dataGroup._progress)
    dataGroup._progress:SetPosY(template._progress:GetPosY() + pushYValue)
    dataGroup._percent = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Worldmap_TentInfo, "StaticText_C_Percent_" .. index)
    CopyBaseProperty(template._percent, dataGroup._percent)
    dataGroup._percent:SetPosY(template._percent:GetPosY() + pushYValue)
    dataGroup._iconPruning = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATIC, Panel_Worldmap_TentInfo, "StaticText_C_IconPruning_" .. index)
    CopyBaseProperty(template._iconPruning, dataGroup._iconPruning)
    dataGroup._iconPruning:SetPosY(template._iconPruning:GetPosY() + pushYValue)
    dataGroup._iconInsectDamege = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATIC, Panel_Worldmap_TentInfo, "StaticText_C_IconInsectDamege_" .. index)
    CopyBaseProperty(template._iconInsectDamege, dataGroup._iconInsectDamege)
    dataGroup._iconInsectDamege:SetPosY(template._iconInsectDamege:GetPosY() + pushYValue)
    createList[index] = dataGroup
    pushYValue = pushYValue + workingRawSizeY
    defaultPercentPosX = dataGroup._percent:GetPosX()
    defaultIconPruningPosX = dataGroup._iconPruning:GetPosX()
    defaultIconInsectDamegePosX = dataGroup._iconInsectDamege:GetPosX()
  end
end
local tooltipTentUI = 0
function FromClient_TentTooltipShow(tentIcon, householdDataWithInstallationWrapper)
  local expireTime = householdDataWithInstallationWrapper:getSelfTentExpiredTime_s64()
  local lefttimeText = convertStringFromDatetime(getLeftSecond_TTime64(expireTime))
  _remainTime:SetText(lefttimeText)
  local maxCount = ToClient_GetMaxHarvestCount()
  local count = householdDataWithInstallationWrapper:getSelfHarvestCount()
  tentInformationMouseOverActorKey = householdDataWithInstallationWrapper:getActorKeyRaw()
  local nameSizeX = 0
  local viewIndex = 0
  for index = 0, maxCount do
    local dataGroup = createList[viewIndex]
    if index >= count then
      for viewCount = 0, maxCount - 1 do
        local group = createList[viewCount]
        group._percent:SetPosX(defaultPercentPosX + nameSizeX)
        group._iconPruning:SetPosX(defaultIconPruningPosX + nameSizeX)
        group._iconInsectDamege:SetPosX(defaultIconInsectDamegePosX + nameSizeX)
      end
      break
    end
    local progressingInfo = householdDataWithInstallationWrapper:getInstallationProgressingInfo(index)
    if nil ~= progressingInfo then
      local harvestCharacterSSW = householdDataWithInstallationWrapper:getSelfHarvest(index)
      local percent = math.min(householdDataWithInstallationWrapper:getSelfHarvestCompleteRate(index) * 100, 200)
      local objectSSW = harvestCharacterSSW:getObjectStaticStatus()
      local installationType = objectSSW:getInstallationType()
      local iconPath = objectSSW:getHouseScreenShotPath(0)
      if nil ~= iconPath and "" ~= iconPath then
        dataGroup._icon:SetShow(true)
        dataGroup._icon:ChangeTextureInfoName(iconPath)
      else
        dataGroup._icon:SetShow(false)
      end
      dataGroup._itemName:SetText(harvestCharacterSSW:getName())
      dataGroup._progress:SetCurrentProgressRate(percent)
      dataGroup._progress:SetProgressRate(percent)
      dataGroup._percent:SetText(math.floor(percent) .. "%")
      dataGroup._iconPruning:SetMonoTone(not progressingInfo:getNeedLop())
      dataGroup._iconInsectDamege:SetMonoTone(not progressingInfo:getNeedPestControl())
      dataGroup._iconSlot:SetShow(true)
      dataGroup._itemName:SetShow(true)
      dataGroup._gageBg:SetShow(true)
      dataGroup._progress:SetShow(true)
      dataGroup._percent:SetShow(true)
      dataGroup._iconPruning:SetShow(true)
      dataGroup._iconInsectDamege:SetShow(true)
      if installationType == UI_INSTALL.eType_Havest then
        dataGroup._iconPruning:ChangeTextureInfoName("New_UI_Common_ForLua/Widget/Housing/Housing_TentObjectInfo_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(dataGroup._iconPruning, 199, 76, 224, 101)
        dataGroup._iconPruning:getBaseTexture():setUV(x1, y1, x2, y2)
        dataGroup._iconPruning:setRenderTexture(dataGroup._iconPruning:getBaseTexture())
        dataGroup._iconInsectDamege:ChangeTextureInfoName("New_UI_Common_ForLua/Widget/Housing/Housing_TentObjectInfo_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(dataGroup._iconInsectDamege, 226, 76, 251, 101)
        dataGroup._iconInsectDamege:getBaseTexture():setUV(x1, y1, x2, y2)
        dataGroup._iconInsectDamege:setRenderTexture(dataGroup._iconInsectDamege:getBaseTexture())
      elseif installationType == UI_INSTALL.eType_LivestockHarvest then
        dataGroup._iconPruning:ChangeTextureInfoName("New_UI_Common_ForLua/Widget/Housing/Housing_TentObjectInfo_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(dataGroup._iconPruning, 199, 212, 224, 237)
        dataGroup._iconPruning:getBaseTexture():setUV(x1, y1, x2, y2)
        dataGroup._iconPruning:setRenderTexture(dataGroup._iconPruning:getBaseTexture())
        dataGroup._iconInsectDamege:ChangeTextureInfoName("New_UI_Common_ForLua/Widget/Housing/Housing_TentObjectInfo_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(dataGroup._iconInsectDamege, 226, 212, 251, 237)
        dataGroup._iconInsectDamege:getBaseTexture():setUV(x1, y1, x2, y2)
        dataGroup._iconInsectDamege:setRenderTexture(dataGroup._iconInsectDamege:getBaseTexture())
      end
      dataGroup._percent:SetPosX(defaultPercentPosX)
      dataGroup._iconPruning:SetPosX(defaultIconPruningPosX)
      dataGroup._iconInsectDamege:SetPosX(defaultIconInsectDamegePosX)
      if dataGroup._itemName:GetTextSizeX() + dataGroup._itemName:GetPosX() > dataGroup._percent:GetPosX() then
        local sizeX = dataGroup._itemName:GetTextSizeX() + dataGroup._itemName:GetPosX() - dataGroup._percent:GetPosX()
        if nameSizeX < sizeX then
          nameSizeX = sizeX
        end
      else
        local sizeX = dataGroup._itemName:GetTextSizeX() + dataGroup._itemName:GetPosX() - dataGroup._percent:GetPosX()
        nameSizeX = sizeX
      end
      viewIndex = viewIndex + 1
    end
  end
  for index = viewIndex, maxCount - 1 do
    local dataGroup = createList[index]
    dataGroup._iconSlot:SetShow(false)
    dataGroup._icon:SetShow(false)
    dataGroup._itemName:SetShow(false)
    dataGroup._gageBg:SetShow(false)
    dataGroup._progress:SetShow(false)
    dataGroup._percent:SetShow(false)
    dataGroup._iconPruning:SetShow(false)
    dataGroup._iconInsectDamege:SetShow(false)
  end
  if viewIndex <= 0 then
    _workingListBg:SetShow(false)
    _workingText:SetShow(false)
    _workingListBg:SetSize(_workingListBg:GetSizeX(), defaultWorkingListSize)
    _workingDataBg:SetSize(_workingDataBg:GetSizeX(), defaultWorkingDataSizeWithoutList)
    Panel_Worldmap_TentInfo:SetSize(Panel_Worldmap_TentInfo:GetSizeX(), defaultWorkingPanelSizeWithoutList)
  else
    _workingListBg:SetShow(true)
    _workingText:SetShow(true)
    _workingListBg:SetSize(_workingListBg:GetSizeX(), workingRawSizeY * viewIndex + defaultWorkingListSize)
    _workingDataBg:SetSize(_workingDataBg:GetSizeX(), defaultWorkingDataSizeWithoutList + _workingListBg:GetSizeY())
    Panel_Worldmap_TentInfo:SetSize(Panel_Worldmap_TentInfo:GetSizeX(), defaultWorkingPanelSizeWithoutList + _workingListBg:GetSizeY())
  end
  if false == Panel_Worldmap_TentInfo:IsShow() then
    Panel_Worldmap_TentInfo:SetPosX(tentIcon:GetPosX() - (Panel_Worldmap_TentInfo:GetSizeX() / 2 - tentIcon:GetSizeX() / 2))
    Panel_Worldmap_TentInfo:SetPosY(tentIcon:GetPosY() - Panel_Worldmap_TentInfo:GetSizeY())
  end
  _remainTime:SetPosX(defalutRemainTimePosX + nameSizeX)
  _workingListBg:SetSize(defalutWorkingListBGSizeX + nameSizeX, _workingListBg:GetSizeY())
  _workingDataBg:SetSize(defalutWorkingDataBGSizeX + nameSizeX, _workingDataBg:GetSizeY())
  Panel_Worldmap_TentInfo:SetSize(defalutPanelSizeX + nameSizeX, Panel_Worldmap_TentInfo:GetSizeY())
  tooltipTentUI = tentIcon:GetID()
  _tentTitleBG:SetSize(Panel_Worldmap_TentInfo:GetSizeX() - 10, _tentTitleBG:GetSizeY())
  _tentTitleBG:ComputePos()
  Panel_Worldmap_TentInfo:SetShow(true)
end
function FromClient_TentTooltipHide(tentIcon, householdDataWithInstallationWrapper)
  if tooltipTentUI == tentIcon:GetID() then
    Panel_Worldmap_TentInfo:SetShow(false)
    tooltipTentUI = 0
  end
end
function Panel_Worldmap_TentInfo_UpdateFrame(deltaTime)
  local householdDataWithInstallationWrapper = getTemporaryInformationWrapper():getSelfTentWrapperByActorKeyRaw(tentInformationMouseOverActorKey)
  if nil == householdDataWithInstallationWrapper then
    return
  end
  local maxCount = ToClient_GetMaxHarvestCount()
  local count = householdDataWithInstallationWrapper:getSelfHarvestCount()
  local nameSizeX = 0
  local viewIndex = 0
  for index = 0, maxCount - 1 do
    local dataGroup = createList[viewIndex]
    if index >= count then
      break
    end
    local progressingInfo = householdDataWithInstallationWrapper:getInstallationProgressingInfo(index)
    if nil ~= progressingInfo then
      local harvestCharacterSSW = householdDataWithInstallationWrapper:getSelfHarvest(index)
      local percent = math.min(householdDataWithInstallationWrapper:getSelfHarvestCompleteRate(index) * 100, 200)
      local objectSSW = harvestCharacterSSW:getObjectStaticStatus()
      local iconPath = objectSSW:getHouseScreenShotPath(0)
      if nil ~= iconPath and "" ~= iconPath then
        dataGroup._icon:SetShow(true)
        dataGroup._icon:ChangeTextureInfoName(iconPath)
      else
        dataGroup._icon:SetShow(false)
      end
      dataGroup._itemName:SetText(harvestCharacterSSW:getName())
      dataGroup._progress:SetCurrentProgressRate(percent)
      dataGroup._progress:SetProgressRate(percent)
      dataGroup._percent:SetText(math.floor(percent) .. "%")
      dataGroup._iconPruning:SetMonoTone(not progressingInfo:getNeedLop())
      dataGroup._iconInsectDamege:SetMonoTone(not progressingInfo:getNeedPestControl())
      dataGroup._iconSlot:SetShow(true)
      dataGroup._itemName:SetShow(true)
      dataGroup._gageBg:SetShow(true)
      dataGroup._progress:SetShow(true)
      dataGroup._percent:SetShow(true)
      dataGroup._iconPruning:SetShow(true)
      dataGroup._iconInsectDamege:SetShow(true)
      viewIndex = viewIndex + 1
    end
  end
  if viewIndex <= 0 then
    _workingListBg:SetShow(false)
    _workingText:SetShow(false)
    _workingListBg:SetSize(_workingListBg:GetSizeX(), defaultWorkingListSize)
    _workingDataBg:SetSize(_workingDataBg:GetSizeX(), defaultWorkingDataSizeWithoutList)
    Panel_Worldmap_TentInfo:SetSize(Panel_Worldmap_TentInfo:GetSizeX(), defaultWorkingPanelSizeWithoutList)
  else
    _workingListBg:SetShow(true)
    _workingText:SetShow(true)
    _workingListBg:SetSize(_workingListBg:GetSizeX(), workingRawSizeY * viewIndex + defaultWorkingListSize)
    _workingDataBg:SetSize(_workingDataBg:GetSizeX(), defaultWorkingDataSizeWithoutList + _workingListBg:GetSizeY())
    Panel_Worldmap_TentInfo:SetSize(Panel_Worldmap_TentInfo:GetSizeX(), defaultWorkingPanelSizeWithoutList + _workingListBg:GetSizeY())
  end
  if false == Panel_Worldmap_TentInfo:IsShow() then
    Panel_Worldmap_TentInfo:SetPosX(tentIcon:GetPosX() - (Panel_Worldmap_TentInfo:GetSizeX() / 2 - tentIcon:GetSizeX() / 2))
    Panel_Worldmap_TentInfo:SetPosY(tentIcon:GetPosY() - Panel_Worldmap_TentInfo:GetSizeY())
  end
  _tentTitleBG:SetSize(Panel_Worldmap_TentInfo:GetSizeX() - 8, _tentTitleBG:GetSizeY())
  _tentTitleBG:ComputePos()
end
function FGlobal_TentTooltipShow(householdDataWithInstallationWrapper)
  local expireTime = householdDataWithInstallationWrapper:getSelfTentExpiredTime_s64()
  local lefttimeText = convertStringFromDatetime(getLeftSecond_TTime64(expireTime))
  _remainTime:SetText(lefttimeText)
  local maxCount = ToClient_GetMaxHarvestCount()
  local count = householdDataWithInstallationWrapper:getSelfHarvestCount()
  tentInformationMouseOverActorKey = householdDataWithInstallationWrapper:getActorKeyRaw()
  local nameSizeX = 0
  local viewIndex = 0
  for index = 0, maxCount do
    local dataGroup = createList[viewIndex]
    if index >= count then
      for viewCount = 0, maxCount - 1 do
        local group = createList[viewCount]
        group._percent:SetPosX(defaultPercentPosX + nameSizeX)
        group._iconPruning:SetPosX(defaultIconPruningPosX + nameSizeX)
        group._iconInsectDamege:SetPosX(defaultIconInsectDamegePosX + nameSizeX)
      end
      break
    end
    local progressingInfo = householdDataWithInstallationWrapper:getInstallationProgressingInfo(index)
    if nil ~= progressingInfo then
      local harvestCharacterSSW = householdDataWithInstallationWrapper:getSelfHarvest(index)
      local percent = math.min(householdDataWithInstallationWrapper:getSelfHarvestCompleteRate(index) * 100, 200)
      local objectSSW = harvestCharacterSSW:getObjectStaticStatus()
      local installationType = objectSSW:getInstallationType()
      local iconPath = objectSSW:getHouseScreenShotPath(0)
      if nil ~= iconPath and "" ~= iconPath then
        dataGroup._icon:SetShow(true)
        dataGroup._icon:ChangeTextureInfoName(iconPath)
      else
        dataGroup._icon:SetShow(false)
      end
      dataGroup._itemName:SetText(harvestCharacterSSW:getName())
      dataGroup._progress:SetCurrentProgressRate(percent)
      dataGroup._progress:SetProgressRate(percent)
      dataGroup._percent:SetText(math.floor(percent) .. "%")
      dataGroup._iconPruning:SetMonoTone(not progressingInfo:getNeedLop())
      dataGroup._iconInsectDamege:SetMonoTone(not progressingInfo:getNeedPestControl())
      dataGroup._iconSlot:SetShow(true)
      dataGroup._itemName:SetShow(true)
      dataGroup._gageBg:SetShow(true)
      dataGroup._progress:SetShow(true)
      dataGroup._percent:SetShow(true)
      dataGroup._iconPruning:SetShow(true)
      dataGroup._iconInsectDamege:SetShow(true)
      if installationType == UI_INSTALL.eType_Havest then
        dataGroup._iconPruning:ChangeTextureInfoName("New_UI_Common_ForLua/Widget/Housing/Housing_TentObjectInfo_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(dataGroup._iconPruning, 199, 76, 224, 101)
        dataGroup._iconPruning:getBaseTexture():setUV(x1, y1, x2, y2)
        dataGroup._iconPruning:setRenderTexture(dataGroup._iconPruning:getBaseTexture())
        dataGroup._iconInsectDamege:ChangeTextureInfoName("New_UI_Common_ForLua/Widget/Housing/Housing_TentObjectInfo_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(dataGroup._iconInsectDamege, 226, 76, 251, 101)
        dataGroup._iconInsectDamege:getBaseTexture():setUV(x1, y1, x2, y2)
        dataGroup._iconInsectDamege:setRenderTexture(dataGroup._iconInsectDamege:getBaseTexture())
      elseif installationType == UI_INSTALL.eType_LivestockHarvest then
        dataGroup._iconPruning:ChangeTextureInfoName("New_UI_Common_ForLua/Widget/Housing/Housing_TentObjectInfo_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(dataGroup._iconPruning, 199, 212, 224, 237)
        dataGroup._iconPruning:getBaseTexture():setUV(x1, y1, x2, y2)
        dataGroup._iconPruning:setRenderTexture(dataGroup._iconPruning:getBaseTexture())
        dataGroup._iconInsectDamege:ChangeTextureInfoName("New_UI_Common_ForLua/Widget/Housing/Housing_TentObjectInfo_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(dataGroup._iconInsectDamege, 226, 212, 251, 237)
        dataGroup._iconInsectDamege:getBaseTexture():setUV(x1, y1, x2, y2)
        dataGroup._iconInsectDamege:setRenderTexture(dataGroup._iconInsectDamege:getBaseTexture())
      end
      dataGroup._percent:SetPosX(defaultPercentPosX)
      dataGroup._iconPruning:SetPosX(defaultIconPruningPosX)
      dataGroup._iconInsectDamege:SetPosX(defaultIconInsectDamegePosX)
      if dataGroup._itemName:GetTextSizeX() + dataGroup._itemName:GetPosX() > dataGroup._percent:GetPosX() then
        local sizeX = dataGroup._itemName:GetTextSizeX() + dataGroup._itemName:GetPosX() - dataGroup._percent:GetPosX()
        if nameSizeX < sizeX then
          nameSizeX = sizeX
        end
      end
      viewIndex = viewIndex + 1
    end
  end
  for index = viewIndex, maxCount - 1 do
    local dataGroup = createList[index]
    dataGroup._iconSlot:SetShow(false)
    dataGroup._icon:SetShow(false)
    dataGroup._itemName:SetShow(false)
    dataGroup._gageBg:SetShow(false)
    dataGroup._progress:SetShow(false)
    dataGroup._percent:SetShow(false)
    dataGroup._iconPruning:SetShow(false)
    dataGroup._iconInsectDamege:SetShow(false)
  end
  if viewIndex <= 0 then
    _workingListBg:SetShow(false)
    _workingText:SetShow(false)
    _workingListBg:SetSize(_workingListBg:GetSizeX(), defaultWorkingListSize)
    _workingDataBg:SetSize(_workingDataBg:GetSizeX(), defaultWorkingDataSizeWithoutList)
    Panel_Worldmap_TentInfo:SetSize(Panel_Worldmap_TentInfo:GetSizeX(), defaultWorkingPanelSizeWithoutList)
  else
    _workingListBg:SetShow(true)
    _workingText:SetShow(true)
    _workingListBg:SetSize(_workingListBg:GetSizeX(), workingRawSizeY * viewIndex + defaultWorkingListSize)
    _workingDataBg:SetSize(_workingDataBg:GetSizeX(), defaultWorkingDataSizeWithoutList + _workingListBg:GetSizeY())
    Panel_Worldmap_TentInfo:SetSize(Panel_Worldmap_TentInfo:GetSizeX(), defaultWorkingPanelSizeWithoutList + _workingListBg:GetSizeY())
  end
  _remainTime:SetPosX(defalutRemainTimePosX + nameSizeX)
  _workingListBg:SetSize(defalutWorkingListBGSizeX + nameSizeX, _workingListBg:GetSizeY())
  _workingDataBg:SetSize(defalutWorkingDataBGSizeX + nameSizeX, _workingDataBg:GetSizeY())
  Panel_Worldmap_TentInfo:SetSize(defalutPanelSizeX + nameSizeX, Panel_Worldmap_TentInfo:GetSizeY())
  if false == Panel_Worldmap_TentInfo:IsShow() then
    Panel_Worldmap_TentInfo:SetPosX(Panel_HarvestList:GetPosX() + Panel_HarvestList:GetSizeX())
    Panel_Worldmap_TentInfo:SetPosY(Panel_HarvestList:GetPosY())
  end
  Panel_Worldmap_TentInfo:SetShow(true)
end
function FGlobal_TentTooltipHide()
  Panel_Worldmap_TentInfo:SetShow(false)
end
initTentInfo()
registerEvent("FromClient_TentTooltipShow", "FromClient_TentTooltipShow")
registerEvent("FromClient_TentTooltipHide", "FromClient_TentTooltipHide")
Panel_Worldmap_TentInfo:RegisterUpdateFunc("Panel_Worldmap_TentInfo_UpdateFrame")
