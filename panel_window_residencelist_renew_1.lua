function PaGlobal_ResidenceList:initialize()
  if true == PaGlobal_ResidenceList._initialize then
    return
  end
  PaGlobal_ResidenceList._ui._list2_residence = UI.getChildControl(Panel_Window_ResidenceList, "List2_ResidenceList")
  PaGlobal_ResidenceList._ui._stc_keyguideBG = UI.getChildControl(Panel_Window_ResidenceList, "Static_KeyGuideBG")
  PaGlobal_ResidenceList._ui._stc_keyguideX = UI.getChildControl(PaGlobal_ResidenceList._ui._stc_keyguideBG, "StaticText_X")
  PaGlobal_ResidenceList._ui._stc_keyguideB = UI.getChildControl(PaGlobal_ResidenceList._ui._stc_keyguideBG, "StaticText_B")
  PaGlobal_ResidenceList._keyGuideAlign = {
    PaGlobal_ResidenceList._ui._stc_keyguideX,
    PaGlobal_ResidenceList._ui._stc_keyguideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_ResidenceList._keyGuideAlign, PaGlobal_ResidenceList._ui._stc_keyguideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  PaGlobal_ResidenceList:registEventHandler()
  PaGlobal_ResidenceList._initialize = true
end
function PaGlobal_ResidenceList:registEventHandler()
  if nil == Panel_Window_ResidenceList then
    return
  end
  PaGlobal_ResidenceList._ui._list2_residence:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_ResidenceList_addResidenceListContent")
  PaGlobal_ResidenceList._ui._list2_residence:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function PaGlobal_ResidenceList:prepareOpen()
  if nil == Panel_Window_ResidenceList then
    return
  end
  local vScroll = PaGlobal_ResidenceList._ui._list2_residence:GetVScroll()
  vScroll:SetControlPos(0)
end
function PaGlobal_ResidenceList:open()
  if nil == Panel_Window_ResidenceList then
    return
  end
  PaGlobal_ResidenceList:prepareOpen()
  PaGlobal_ResidenceList:update()
  Panel_Window_ResidenceList:SetShow(true)
end
function PaGlobal_ResidenceList:prepareClose()
  if nil == Panel_Window_ResidenceList then
    return
  end
  PaGlobal_ResidenceList._dwellingCount = nil
  PaGlobal_ResidenceList._totalResidenceCount = nil
  PaGlobal_ResidenceList._residencePosList = {}
  PaGlobal_ResidenceList._residenceDataList = {}
end
function PaGlobal_ResidenceList:close()
  if nil == Panel_Window_ResidenceList then
    return
  end
  PaGlobal_ResidenceList:prepareClose()
  Panel_Window_ResidenceList:SetShow(false)
end
function PaGlobal_ResidenceList:update()
  if nil == Panel_Window_ResidenceList then
    return
  end
  PaGlobal_ResidenceList._dwellingCount = 0
  PaGlobal_ResidenceList._totalResidenceCount = 0
  PaGlobal_ResidenceList._ui._list2_residence:getElementManager():clearKey()
  local count = ToClient_getMyDwellingCount()
  for index = 0, count do
    local dwellingSSW = ToClient_getMyDwelling(index)
    if nil ~= dwellingSSW and nil ~= dwellingSSW:getName() then
      PaGlobal_ResidenceList._totalResidenceCount = PaGlobal_ResidenceList._totalResidenceCount + 1
      PaGlobal_ResidenceList._dwellingCount = PaGlobal_ResidenceList._dwellingCount + 1
      local residenceData = {
        _residenceIndex = index,
        _residenceType = PaGlobal_ResidenceList._RESIDENCE_TYPE.DWELLING
      }
      PaGlobal_ResidenceList._residenceDataList[PaGlobal_ResidenceList._totalResidenceCount] = residenceData
      PaGlobal_ResidenceList._ui._list2_residence:getElementManager():pushKey(toInt64(0, PaGlobal_ResidenceList._totalResidenceCount))
    end
  end
  PaGlobal_ResidenceList._totalResidenceCount = PaGlobal_ResidenceList._totalResidenceCount + PaGlobal_ResidenceList._dwellingCount
  count = ToClient_getMyVillaCount()
  for index = 0, count do
    local villaSSW = ToClient_getMyVilla(index)
    if nil ~= villaSSW and nil ~= villaSSW:getName() then
      PaGlobal_ResidenceList._totalResidenceCount = PaGlobal_ResidenceList._totalResidenceCount + 1
      local residenceData = {
        _residenceIndex = index,
        _residenceType = PaGlobal_ResidenceList._RESIDENCE_TYPE.VILLA
      }
      PaGlobal_ResidenceList._residenceDataList[PaGlobal_ResidenceList._totalResidenceCount] = residenceData
      PaGlobal_ResidenceList._ui._list2_residence:getElementManager():pushKey(toInt64(0, PaGlobal_ResidenceList._totalResidenceCount))
    end
  end
  PaGlobal_ResidenceList._totalResidenceCount = PaGlobal_ResidenceList._totalResidenceCount + PaGlobal_ResidenceList._dwellingCount
  local guildHouseSSW = ToClient_getMyGuildHouse()
  if nil ~= guildHouseSSW and nil ~= guildHouseSSW:getName() then
    PaGlobal_ResidenceList._totalResidenceCount = PaGlobal_ResidenceList._totalResidenceCount + 1
    local residenceData = {
      _residenceIndex = index,
      _residenceType = PaGlobal_ResidenceList._RESIDENCE_TYPE.GUILDHOUSE
    }
    PaGlobal_ResidenceList._ui._list2_residence:getElementManager():pushKey(toInt64(0, PaGlobal_ResidenceList._totalResidenceCount))
  end
end
function PaGlobal_ResidenceList:validate()
  if nil == Panel_Window_ResidenceList then
    return
  end
  PaGlobal_ResidenceList._ui._list2_residence:isValidate()
  PaGlobal_ResidenceList._ui._stc_keyguideBG:isValidate()
  PaGlobal_ResidenceList._ui._stc_keyguideX:isValidate()
  PaGlobal_ResidenceList._ui._stc_keyguideB:isValidate()
end
function PaGlobal_ResidenceList:setNaviToResidence(controlIndex)
  if nil == Panel_Window_ResidenceList then
    return
  end
  ToClient_DeleteNaviGuideByGroup(0)
  local navigationGuideParam = NavigationGuideParam()
  navigationGuideParam._isAutoErase = true
  worldmapNavigatorStart(PaGlobal_ResidenceList._residencePosList[controlIndex], navigationGuideParam, false, false, true)
end
function FGlobal_HouseIconCount()
  return 0
end
function PaGlobal_ResidenceList_addResidenceListContent(control, key)
  if nil == Panel_Window_ResidenceList then
    return
  end
  if nil == control or nil == key then
    return
  end
  local residenceData = PaGlobal_ResidenceList._residenceDataList[Int64toInt32(key)]
  local residenceIndex = residenceData._residenceIndex
  local residenceType = residenceData._residenceType
  local residenceSSW
  if PaGlobal_ResidenceList._RESIDENCE_TYPE.DWELLING == residenceType then
    residenceSSW = ToClient_getMyDwelling(residenceIndex)
  elseif PaGlobal_ResidenceList._RESIDENCE_TYPE.VILLA == residenceType then
    residenceSSW = ToClient_getMyVilla(residenceIndex)
  elseif PaGlobal_ResidenceList._RESIDENCE_TYPE.GUILDHOUSE == residenceType then
    residenceSSW = ToClient_getMyGuildHouse()
  end
  if nil == residenceSSW or nil == residenceSSW:getName() then
    return
  end
  local _txt_territoryName = UI.getChildControl(control, "StaticText_TerritoryName")
  local _txt_townName = UI.getChildControl(control, "StaticText_TownName")
  local _txt_addressName = UI.getChildControl(control, "StaticText_AddressName")
  local residencePosX = residenceSSW:getObjectStaticStatus():getHousePosX()
  local residencePosY = residenceSSW:getObjectStaticStatus():getHousePosY()
  local residencePosZ = residenceSSW:getObjectStaticStatus():getHousePosZ()
  local residencePos = float3(residencePosX, residencePosY, residencePosZ)
  local regionWrapper = ToClient_getRegionInfoWrapperByPosition(residencePos)
  if nil == regionWrapper then
    return
  end
  _txt_territoryName:SetText(regionWrapper:getTerritoryName())
  _txt_townName:SetText(regionWrapper:getAreaName())
  _txt_addressName:SetText(residenceSSW:getName())
  PaGlobal_ResidenceList._residencePosList[residenceIndex] = residencePos
  control:registerPadEvent(__eConsoleUIPadEvent_X, "HandleEventPadX_ResidenceList_StartNaviToResidence(" .. residenceIndex .. ")")
end
