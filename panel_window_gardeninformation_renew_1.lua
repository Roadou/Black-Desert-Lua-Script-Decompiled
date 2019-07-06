function PaGlobal_GardenInformation:initialize()
  if true == PaGlobal_GardenInformation._initialize then
    return
  end
  PaGlobal_GardenInformation._ui._list2_cropInfo = UI.getChildControl(Panel_Window_GardenInformation, "List2_CropList")
  local subTitleBG = UI.getChildControl(Panel_Window_GardenInformation, "Static_SubTitleBG")
  PaGlobal_GardenInformation._ui._txt_removalTime = UI.getChildControl(subTitleBG, "StaticText_ExpireTimeValue")
  local _stc_keyguideBG = UI.getChildControl(Panel_Window_GardenInformation, "Static_KeyGuideBG")
  local _stc_keyguideB = UI.getChildControl(_stc_keyguideBG, "StaticText_B_ConsoleUI")
  local _keyGuideAlign = {_stc_keyguideB}
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(_keyGuideAlign, _stc_keyguideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  PaGlobal_GardenInformation:registEventHandler()
  PaGlobal_GardenInformation:resize()
  PaGlobal_GardenInformation._initialize = true
end
function PaGlobal_GardenInformation:registEventHandler()
  if nil == Panel_Window_GardenInformation then
    return
  end
  PaGlobal_GardenInformation._ui._list2_cropInfo:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_GardenInformation_addGardenCropContent")
  PaGlobal_GardenInformation._ui._list2_cropInfo:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function PaGlobal_GardenInformation:prepareOpen()
  if nil == Panel_Window_GardenInformation then
    return
  end
  local vScroll = PaGlobal_GardenInformation._ui._list2_cropInfo:GetVScroll()
  vScroll:SetControlPos(0)
  Panel_Window_GardenInformation:ignorePadSnapMoveToOtherPanel()
end
function PaGlobal_GardenInformation:open(index)
  if nil == Panel_Window_GardenInformation then
    return
  end
  PaGlobal_GardenInformation._householdIndex = index
  PaGlobal_GardenInformation:prepareOpen()
  PaGlobal_GardenInformation:update()
  Panel_Window_GardenInformation:SetShow(true)
end
function PaGlobal_GardenInformation:prepareClose()
  if nil == Panel_Window_GardenInformation then
    return
  end
  PaGlobal_GardenInformation._cropIndexList = {}
  PaGlobal_GardenInformation._householdIndex = nil
end
function PaGlobal_GardenInformation:close()
  if nil == Panel_Window_GardenInformation then
    return
  end
  PaGlobal_GardenInformation:prepareClose()
  Panel_Window_GardenInformation:SetShow(false)
end
function PaGlobal_GardenInformation:update()
  if nil == Panel_Window_GardenInformation then
    return
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local householdWrapper = temporaryWrapper:getSelfTentWrapperByIndex(PaGlobal_GardenInformation._householdIndex)
  if nil == householdWrapper then
    return
  end
  local expireTime = householdWrapper:getSelfTentExpiredTime_s64()
  local lefttimeText = convertStringFromDatetime(getLeftSecond_TTime64(expireTime))
  PaGlobal_GardenInformation._ui._txt_removalTime:SetText(lefttimeText)
  PaGlobal_GardenInformation._ui._list2_cropInfo:getElementManager():clearKey()
  local maxCropCount = ToClient_GetMaxHarvestCount()
  local cropCount = 0
  for index = 0, maxCropCount do
    local progressingInfo = householdWrapper:getInstallationProgressingInfo(index)
    if nil ~= progressingInfo then
      cropCount = cropCount + 1
      PaGlobal_GardenInformation._cropIndexList[cropCount] = index
      PaGlobal_GardenInformation._ui._list2_cropInfo:getElementManager():pushKey(toInt64(0, cropCount))
      PaGlobal_GardenInformation._ui._list2_cropInfo:requestUpdateByKey(toInt64(0, cropCount))
    end
  end
end
function PaGlobal_GardenInformation:updatePerFrame(deltaTime)
  if nil == Panel_Window_GardenInformation then
    return
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local householdWrapper = temporaryWrapper:getSelfTentWrapperByIndex(PaGlobal_GardenInformation._householdIndex)
  if nil == householdWrapper then
    return
  end
  local expireTime = householdWrapper:getSelfTentExpiredTime_s64()
  local lefttimeText = convertStringFromDatetime(getLeftSecond_TTime64(expireTime))
  PaGlobal_GardenInformation._ui._txt_removalTime:SetText(lefttimeText)
  local maxCropCount = ToClient_GetMaxHarvestCount()
  local cropCount = 0
  for index = 0, maxCropCount do
    local progressingInfo = householdWrapper:getInstallationProgressingInfo(index)
    if nil ~= progressingInfo then
      cropCount = cropCount + 1
      PaGlobal_GardenInformation._cropIndexList[cropCount] = index
      PaGlobal_GardenInformation._ui._list2_cropInfo:requestUpdateByKey(toInt64(0, cropCount))
    end
  end
end
function PaGlobal_GardenInformation:validate()
  if nil == Panel_Window_GardenInformation then
    return
  end
  PaGlobal_GardenInformation._ui._list2_cropInfo:isValidate()
end
function PaGlobal_GardenInformation:resize()
  if nil == Panel_Window_GardenInformation then
    return
  end
  Panel_Window_GardenInformation:ComputePos()
end
function PaGlobal_GardenInformation_addGardenCropContent(control, key)
  if nil == Panel_Window_GardenInformation then
    return
  end
  if nil == control or nil == key then
    return
  end
  local index = PaGlobal_GardenInformation._cropIndexList[Int64toInt32(key)]
  local temporaryWrapper = getTemporaryInformationWrapper()
  if nil == temporaryWrapper then
    return
  end
  local householdWrapper = temporaryWrapper:getSelfTentWrapperByIndex(PaGlobal_GardenInformation._householdIndex)
  if nil == householdWrapper then
    return
  end
  local progressingInfo = householdWrapper:getInstallationProgressingInfo(index)
  if nil == progressingInfo then
    return
  end
  local harvestCharacterSSW = householdWrapper:getSelfHarvest(index)
  local growPercent = math.min(householdWrapper:getSelfHarvestCompleteRate(index) * 100, 200)
  local objectSSW = harvestCharacterSSW:getObjectStaticStatus()
  local installationType = objectSSW:getInstallationType()
  local iconPath = objectSSW:getHouseScreenShotPath(0)
  local _stc_cropIcon = UI.getChildControl(control, "Static_CropIconSlot")
  local _txt_cropName = UI.getChildControl(control, "StaticText_CropName")
  local _chkbtn_scissors = UI.getChildControl(control, "CheckButton_Scissors")
  local _chkbtn_leaf = UI.getChildControl(control, "CheckButton_Leaf")
  local _chkbtn_feed = UI.getChildControl(control, "CheckButton_Feed")
  local _chkbtn_worm = UI.getChildControl(control, "CheckButton_Worm")
  local _txt_growPercent = UI.getChildControl(control, "StaticText_GrowPercent")
  if nil ~= iconPath and "" ~= iconPath then
    _stc_cropIcon:SetShow(true)
    _stc_cropIcon:ChangeTextureInfoName(iconPath)
  else
    _stc_cropIcon:SetShow(false)
  end
  _txt_cropName:SetText(harvestCharacterSSW:getName())
  _chkbtn_feed:SetShow(false)
  _chkbtn_worm:SetShow(false)
  _chkbtn_scissors:SetShow(false)
  _chkbtn_leaf:SetShow(false)
  if installationType == CppEnums.InstallationType.eType_Havest then
    _chkbtn_scissors:SetShow(true)
    _chkbtn_leaf:SetShow(true)
    _chkbtn_scissors:SetCheck(progressingInfo:getNeedLop())
    _chkbtn_leaf:SetCheck(progressingInfo:getNeedPestControl())
  elseif installationType == CppEnums.InstallationType.eType_LivestockHarvest then
    _chkbtn_feed:SetShow(true)
    _chkbtn_worm:SetShow(true)
    _chkbtn_feed:SetCheck(progressingInfo:getNeedLop())
    _chkbtn_worm:SetCheck(progressingInfo:getNeedPestControl())
  end
  _txt_growPercent:SetText(math.floor(growPercent) .. "%")
end
