local CONTROL = CppEnums.PA_UI_CONTROL_TYPE
function PaGlobal_Option:SpectialControlComboBoxInitValue()
  local option
  option = self._elements.ScreenResolution
  option._comboBoxList = {}
  option._comboBoxListCount = self._availableResolutionList:getDisplayModeListSize()
  for ii = 0, option._comboBoxListCount - 1 do
    option._comboBoxList[ii] = tostring(self._availableResolutionList:getDisplayModeWidth(ii)) .. "x" .. tostring(self._availableResolutionList:getDisplayModeHeight(ii))
  end
end
function PaGlobal_Option:radioButtonMapping_TextureQuality(value, fromRadioButtonToCppEnum)
  local radioMap = {
    [0] = 2,
    [1] = 1,
    [2] = 0
  }
  return PaGlobal_Option:RadioButtonMapping(radioMap, value, fromRadioButtonToCppEnum)
end
function PaGlobal_Option:radioButtonMapping_GraphicOption(value, fromRadioButtonToCppEnum)
  local radioMap = {
    [0] = 5,
    [1] = 4,
    [2] = 3,
    [3] = 2,
    [4] = 1,
    [5] = 0,
    [6] = 6,
    [7] = 9,
    [8] = 8
  }
  return PaGlobal_Option:RadioButtonMapping(radioMap, value, fromRadioButtonToCppEnum)
end
function PaGlobal_Option:GetRadioButtonMap()
  local radioMap = {}
  if isGameTypeKorea() then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_KR,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_JP,
      [2] = CppEnums.ServiceResourceType.eServiceResourceType_EN
    }
  elseif isGameTypeJapan() then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_JP,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_KR,
      [2] = CppEnums.ServiceResourceType.eServiceResourceType_EN
    }
  elseif isGameTypeRussia() then
  elseif isGameTypeEnglish() then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_EN,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_JP,
      [2] = CppEnums.ServiceResourceType.eServiceResourceType_KR
    }
  elseif isGameTypeTaiwan() then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_TW,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_KR,
      [2] = CppEnums.ServiceResourceType.eServiceResourceType_JP,
      [3] = CppEnums.ServiceResourceType.eServiceResourceType_EN
    }
  elseif isGameTypeTR() then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_EN
    }
  elseif isGameTypeID() then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_EN
    }
  elseif isGameTypeTH() then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_EN
    }
  elseif isGameTypeGT() then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_EN,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_JP,
      [2] = CppEnums.ServiceResourceType.eServiceResourceType_KR,
      [3] = CppEnums.ServiceResourceType.eServiceResourceType_TW
    }
  end
  return radioMap
end
function PaGlobal_Option:radioButtonMapping_AudioResourceType(value, fromRadioButtonToCppEnum)
  local radioMap = self.GetRadioButtonMap()
  local val = PaGlobal_Option:RadioButtonMapping(radioMap, value, fromRadioButtonToCppEnum)
  if -1 == val then
    return 0
  end
  return val
end
function PaGlobal_Option:radioButtonMapping_ServiceResourceType(value, fromRadioButtonToCppEnum)
  local radioMap = {
    [0] = CppEnums.ServiceResourceType.eServiceResourceType_EN,
    [1] = CppEnums.ServiceResourceType.eServiceResourceType_FR,
    [2] = CppEnums.ServiceResourceType.eServiceResourceType_ID,
    [3] = CppEnums.ServiceResourceType.eServiceResourceType_ES,
    [4] = CppEnums.ServiceResourceType.eServiceResourceType_SP
  }
  local resourceType = getGameServiceType()
  if CppEnums.GameServiceType.eGameServiceType_DEV == resourceType then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_EN,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_FR,
      [2] = CppEnums.ServiceResourceType.eServiceResourceType_ID,
      [3] = CppEnums.ServiceResourceType.eServiceResourceType_SP
    }
  elseif CppEnums.GameServiceType.eGameServiceType_NA_ALPHA == resourceType then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_EN,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_FR,
      [2] = CppEnums.ServiceResourceType.eServiceResourceType_DE,
      [3] = CppEnums.ServiceResourceType.eServiceResourceType_SP
    }
  elseif CppEnums.GameServiceType.eGameServiceType_NA_REAL == resourceType then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_EN,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_FR,
      [2] = CppEnums.ServiceResourceType.eServiceResourceType_DE,
      [3] = CppEnums.ServiceResourceType.eServiceResourceType_SP
    }
  elseif CppEnums.GameServiceType.eGameServiceType_SA_ALPHA == resourceType then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_PT,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_ES
    }
  elseif CppEnums.GameServiceType.eGameServiceType_SA_REAL == resourceType then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_PT,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_ES
    }
  elseif CppEnums.GameServiceType.eGameServiceType_ID_ALPHA == resourceType then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_ID,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_EN
    }
  elseif CppEnums.GameServiceType.eGameServiceType_ID_REAL == resourceType then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_ID,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_EN
    }
  elseif CppEnums.GameServiceType.eGameServiceType_TR_ALPHA == resourceType then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_TR,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_EN
    }
  elseif CppEnums.GameServiceType.eGameServiceType_TR_REAL == resourceType then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_TR,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_EN
    }
  elseif CppEnums.GameServiceType.eGameServiceType_GT_ALPHA == resourceType then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_TW,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_EN,
      [2] = CppEnums.ServiceResourceType.eServiceResourceType_KR
    }
  elseif CppEnums.GameServiceType.eGameServiceType_GT_REAL == resourceType then
    radioMap = {
      [0] = CppEnums.ServiceResourceType.eServiceResourceType_TW,
      [1] = CppEnums.ServiceResourceType.eServiceResourceType_EN,
      [2] = CppEnums.ServiceResourceType.eServiceResourceType_KR
    }
  end
  return PaGlobal_Option:RadioButtonMapping(radioMap, value, fromRadioButtonToCppEnum)
end
function PaGlobal_Option:radioButtonMapping_ChatChannelType(value, fromRadioButtonToCppEnum)
  local radioMap = {
    [0] = CppEnums.LangType.LangType_International,
    [1] = CppEnums.LangType.LangType_English,
    [2] = CppEnums.LangType.LangType_French,
    [3] = CppEnums.LangType.LangType_ID,
    [4] = CppEnums.LangType.LangType_SP
  }
  local resourceType = getGameServiceType()
  if CppEnums.GameServiceType.eGameServiceType_DEV == resourceType then
    radioMap = {
      [0] = CppEnums.LangType.LangType_International,
      [1] = CppEnums.LangType.LangType_English,
      [2] = CppEnums.LangType.LangType_French,
      [3] = CppEnums.LangType.LangType_ID,
      [4] = CppEnums.LangType.LangType_Es,
      [5] = CppEnums.LangType.LangType_AE
    }
  elseif CppEnums.GameServiceType.eGameServiceType_NA_ALPHA == resourceType then
    radioMap = {
      [0] = CppEnums.LangType.LangType_International,
      [1] = CppEnums.LangType.LangType_English,
      [2] = CppEnums.LangType.LangType_French,
      [3] = CppEnums.LangType.LangType_German,
      [4] = CppEnums.LangType.LangType_SP
    }
  elseif CppEnums.GameServiceType.eGameServiceType_NA_REAL == resourceType then
    radioMap = {
      [0] = CppEnums.LangType.LangType_International,
      [1] = CppEnums.LangType.LangType_English,
      [2] = CppEnums.LangType.LangType_French,
      [3] = CppEnums.LangType.LangType_German,
      [4] = CppEnums.LangType.LangType_SP
    }
  elseif CppEnums.GameServiceType.eGameServiceType_SA_ALPHA == resourceType then
    radioMap = {
      [0] = CppEnums.LangType.LangType_International,
      [1] = CppEnums.LangType.LangType_Pt,
      [2] = CppEnums.LangType.LangType_Es
    }
  elseif CppEnums.GameServiceType.eGameServiceType_SA_REAL == resourceType then
    radioMap = {
      [0] = CppEnums.LangType.LangType_International,
      [1] = CppEnums.LangType.LangType_Pt,
      [2] = CppEnums.LangType.LangType_Es
    }
  elseif CppEnums.GameServiceType.eGameServiceType_ID_ALPHA == resourceType then
    radioMap = {
      [0] = CppEnums.LangType.LangType_International,
      [1] = CppEnums.LangType.LangType_English,
      [2] = CppEnums.LangType.LangType_ID
    }
  elseif CppEnums.GameServiceType.eGameServiceType_ID_REAL == resourceType then
    radioMap = {
      [0] = CppEnums.LangType.LangType_International,
      [1] = CppEnums.LangType.LangType_ID,
      [2] = CppEnums.LangType.LangType_English
    }
  elseif CppEnums.GameServiceType.eGameServiceType_TR_ALPHA == resourceType then
    radioMap = {
      [0] = CppEnums.LangType.LangType_International,
      [1] = CppEnums.LangType.LangType_TR,
      [2] = CppEnums.LangType.LangType_English,
      [3] = CppEnums.LangType.LangType_AE
    }
  elseif CppEnums.GameServiceType.eGameServiceType_TR_REAL == resourceType then
    radioMap = {
      [0] = CppEnums.LangType.LangType_International,
      [1] = CppEnums.LangType.LangType_TR,
      [2] = CppEnums.LangType.LangType_English,
      [3] = CppEnums.LangType.LangType_AE
    }
  elseif CppEnums.GameServiceType.eGameServiceType_GT_REAL == resourceType or CppEnums.GameServiceType.eGameServiceType_GT_ALPHA == resourceType then
    radioMap = {
      [0] = CppEnums.LangType.LangType_International,
      [1] = CppEnums.LangType.LangType_English,
      [2] = CppEnums.LangType.LangType_Tw
    }
  end
  return PaGlobal_Option:RadioButtonMapping(radioMap, value, fromRadioButtonToCppEnum)
end
local isOnServiceResourceTypeTag = {
  [CppEnums.ServiceResourceType.eServiceResourceType_Dev] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_DEV"),
  [CppEnums.ServiceResourceType.eServiceResourceType_KR] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_KR"),
  [CppEnums.ServiceResourceType.eServiceResourceType_EN] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_EN"),
  [CppEnums.ServiceResourceType.eServiceResourceType_JP] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_JP"),
  [CppEnums.ServiceResourceType.eServiceResourceType_CN] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_CN"),
  [CppEnums.ServiceResourceType.eServiceResourceType_RU] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_RU"),
  [CppEnums.ServiceResourceType.eServiceResourceType_FR] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_FR"),
  [CppEnums.ServiceResourceType.eServiceResourceType_DE] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_DE"),
  [CppEnums.ServiceResourceType.eServiceResourceType_ES] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_ES"),
  [CppEnums.ServiceResourceType.eServiceResourceType_TW] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_TW"),
  [CppEnums.ServiceResourceType.eServiceResourceType_PT] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_PT"),
  [CppEnums.ServiceResourceType.eServiceResourceType_TH] = PAGetString(Defines.StringSheet_RESOURCE, "LUA_OPTION_TEXT_TH"),
  [CppEnums.ServiceResourceType.eServiceResourceType_ID] = PAGetString(Defines.StringSheet_RESOURCE, "LUA_OPTION_TEXT_ID"),
  [CppEnums.ServiceResourceType.eServiceResourceType_TR] = PAGetString(Defines.StringSheet_RESOURCE, "LUA_OPTION_TEXT_TR"),
  [CppEnums.ServiceResourceType.eServiceResourceType_SP] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_SP")
}
local isOnServiceChatTypeTag = {
  [CppEnums.LangType.LangType_Dev] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_DEV"),
  [CppEnums.LangType.LangType_International] = PAGetString(Defines.StringSheet_RESOURCE, "LUA_OPTION_TEXT_INTERNATIONAL"),
  [CppEnums.LangType.LangType_English] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_EN"),
  [CppEnums.LangType.LangType_Jp] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_JP"),
  [CppEnums.LangType.LangType_Cn] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_CN"),
  [CppEnums.LangType.LangType_Ru] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_RU"),
  [CppEnums.LangType.LangType_French] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_FR"),
  [CppEnums.LangType.LangType_German] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_DE"),
  [CppEnums.LangType.LangType_Es] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_ES"),
  [CppEnums.LangType.LangType_Tw] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_TW"),
  [CppEnums.LangType.LangType_Pt] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_PT"),
  [CppEnums.LangType.LangType_TH] = PAGetString(Defines.StringSheet_RESOURCE, "LUA_OPTION_TEXT_TH"),
  [CppEnums.LangType.LangType_ID] = PAGetString(Defines.StringSheet_RESOURCE, "LUA_OPTION_TEXT_ID"),
  [CppEnums.LangType.LangType_TR] = PAGetString(Defines.StringSheet_RESOURCE, "LUA_OPTION_TEXT_TR"),
  [CppEnums.LangType.LangType_SP] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_SP"),
  [CppEnums.LangType.LangType_AE] = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TEXT_AE")
}
function PaGlobal_Option:RadioButtonMapping(table, value, fromRadioButtonToCppEnum)
  if nil == fromRadioButtonToCppEnum or false == fromRadioButtonToCppEnum then
    return table[value]
  end
  for i, v in pairs(table) do
    if v == value then
      return i
    end
  end
  return -1
end
function PaGlobal_Option:GetEventTypeText(controlTypeEnum)
  local eventType
  if CONTROL.PA_UI_CONTROL_SLIDER == controlTypeEnum then
    eventType = "Mouse_LPress"
  elseif CONTROL.PA_UI_CONTROL_COMBOBOX == controlTypeEnum then
    eventType = "Mouse_LUp"
  elseif CONTROL.PA_UI_CONTROL_CHECKBUTTON == controlTypeEnum then
    eventType = "Mouse_LUp"
  elseif CONTROL.PA_UI_CONTROL_RADIOBUTTON == controlTypeEnum then
    eventType = "Mouse_LUp"
  else
    if CONTROL.PA_UI_CONTROL_BUTTON == controlTypeEnum then
      eventType = "Mouse_LUp"
    else
    end
  end
  return eventType
end
function PaGlobal_Option:GetControlTypeByControlName(controlName)
  local controlTypeEnum
  if "CheckButton" == controlName then
    if _ContentsGroup_RenewUI_RenewOPtion then
      controlTypeEnum = OPTION_TYPE.CHECKBUTTON
    else
      controlTypeEnum = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    end
  elseif "RadioButton" == controlName then
    if _ContentsGroup_RenewUI_RenewOPtion then
      controlTypeEnum = OPTION_TYPE.RADIOBUTTON
    else
      controlTypeEnum = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    end
  elseif "Slider" == controlName then
    if _ContentsGroup_RenewUI_RenewOPtion then
      controlTypeEnum = OPTION_TYPE.SLIDER
    else
      controlTypeEnum = CONTROL.PA_UI_CONTROL_SLIDER
    end
  elseif "KeyCustomize" == controlName then
    if _ContentsGroup_RenewUI_RenewOPtion then
      controlTypeEnum = OPTION_TYPE.KEYCUSTOMIZE
    end
  elseif "ComboBox" == controlName then
    controlTypeEnum = CONTROL.PA_UI_CONTROL_COMBOBOX
  elseif "Button" == controlName then
    controlTypeEnum = CONTROL.PA_UI_CONTROL_BUTTON
  else
    controlTypeEnum = nil
  end
  return controlTypeEnum
end
function PaGlobal_Option:FromSliderValueToRealValue(value, min, max)
  function clamp(value, lower, upper)
    if upper < lower then
      lower, upper = upper, lower
    end
    return math.max(lower, math.min(upper, value))
  end
  value = clamp(value, 0, 1)
  local offset = max - min
  value = value * offset
  value = value + min
  return value
end
function PaGlobal_Option:FromRealValueToSliderValue(value, lower, upper)
  local offset = upper - lower
  value = value - lower
  value = value / offset
  return value
end
function PaGlobal_Option:SpecialCreateRadioButton(elementName)
  local radioPosArray = {
    [1] = {
      [1] = {70},
      [2] = {130, 390},
      [3] = {
        70,
        280,
        480
      },
      [4] = {
        70,
        210,
        350,
        490
      }
    },
    [2] = {
      [1] = {70},
      [2] = {190, 390},
      [3] = {
        70,
        280,
        480
      },
      [4] = {
        70,
        210,
        350,
        490
      }
    }
  }
  radioBtnArray = {}
  radioBtnCnt = 0
  if "ServiceResourceType" == elementName then
    local count
    local tempCount = 10
    local controlCount = 9
    for ii = 0, tempCount do
      if nil == self:radioButtonMapping_ServiceResourceType(ii) then
        count = ii
        break
      end
    end
    for i, eventControl in pairs(self._elements[elementName]._eventControl) do
      eventControl:SetText(isOnServiceResourceTypeTag[self:radioButtonMapping_ServiceResourceType(0)])
    end
    for ii = 1, controlCount do
      if nil == self._elements[elementName]["_eventControl" .. ii] then
        break
      end
      for i, eventControl in pairs(self._elements[elementName]["_eventControl" .. ii]) do
        if ii < count then
          eventControl:SetShow(true)
          eventControl:SetText(isOnServiceResourceTypeTag[self:radioButtonMapping_ServiceResourceType(ii)])
        else
          eventControl:SetShow(false)
        end
      end
    end
  end
  if "ChatChannelType" == elementName then
    local count
    local tempCount = 10
    local controlCount = 9
    for ii = 0, tempCount do
      if nil == self:radioButtonMapping_ChatChannelType(ii) then
        count = ii
        break
      end
    end
    for i, eventControl in pairs(self._elements[elementName]._eventControl) do
      eventControl:SetText(isOnServiceChatTypeTag[self:radioButtonMapping_ChatChannelType(0)])
    end
    for ii = 1, controlCount do
      if nil == self._elements[elementName]["_eventControl" .. ii] then
        break
      end
      for i, eventControl in pairs(self._elements[elementName]["_eventControl" .. ii]) do
        if ii < count then
          eventControl:SetShow(true)
          eventControl:SetText(isOnServiceChatTypeTag[self:radioButtonMapping_ChatChannelType(ii)])
        else
          eventControl:SetShow(false)
        end
      end
    end
  end
  if "AudioResourceType" == elementName then
    local controlCount = 4
    for index, eventControl in pairs(self._elements[elementName]._eventControl) do
      if nil == self._elements[elementName]._eventControl and nil == self._elements[elementName]._eventControl[index] then
        return
      elseif nil == self._elements[elementName]._eventControl1 and nil == self._elements[elementName]._eventControl1[index] then
        return
      elseif nil == self._elements[elementName]._eventControl2 and nil == self._elements[elementName]._eventControl2[index] then
        return
      elseif nil == self._elements[elementName]._eventControl3 and nil == self._elements[elementName]._eventControl3[index] then
        return
      end
    end
    for index = 0, controlCount - 1 do
      local serviceType = self:radioButtonMapping_AudioResourceType(index)
      local text
      if CppEnums.ServiceResourceType.eServiceResourceType_KR == serviceType then
        text = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_KOREAN")
      elseif CppEnums.ServiceResourceType.eServiceResourceType_EN == serviceType then
        text = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_ENGLISH")
      elseif CppEnums.ServiceResourceType.eServiceResourceType_JP == serviceType then
        text = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_JAPANESE")
      elseif CppEnums.ServiceResourceType.eServiceResourceType_TW == serviceType then
        text = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TAIWAN")
      else
        text = nil
      end
      for controlIndex, eventControl in pairs(self._elements[elementName]._eventControl) do
        local control
        if 0 == index then
          control = self._elements[elementName]._eventControl[controlIndex]
        elseif 1 == index then
          control = self._elements[elementName]._eventControl1[controlIndex]
        elseif 2 == index then
          control = self._elements[elementName]._eventControl2[controlIndex]
        elseif 3 == index then
          control = self._elements[elementName]._eventControl3[controlIndex]
        end
        if nil ~= text then
          control:SetText(text)
          control:SetShow(true)
          radioBtnArray[radioBtnCnt] = {}
          radioBtnArray[radioBtnCnt].control = control
          radioBtnArray[radioBtnCnt].serviceType = serviceType
          radioBtnArray[radioBtnCnt].controlIndex = controlIndex
          radioBtnCnt = radioBtnCnt + 1
        else
          control:SetShow(false)
        end
      end
    end
    local radioMap = self.GetRadioButtonMap()
    if nil ~= radioMap then
      for i = 1, #radioBtnArray do
        local controlCheck = radioBtnArray[i - 1]
        if controlCheck.serviceType == radioBtnArray[i].serviceType then
          radioBtnCnt = radioBtnCnt - 1
        end
      end
      for i = 0, #radioBtnArray do
        local radioBtn = radioBtnArray[i]
        if nil ~= radioBtn then
          posArray = radioPosArray[radioBtnArray[i].controlIndex][radioBtnCnt]
          for ii = 0, #radioMap do
            if radioMap[ii] == radioBtn.serviceType then
              radioBtn.control:SetPosX(posArray[ii + 1])
              break
            end
          end
        end
      end
    end
  end
end
PaGlobal_Option._lutCaching = nil
function PaGlobal_Option:SetGraphicOption(value, isIncrease)
  local _SSAO = self._elements.SSAO
  local _AntiAliasing = self._elements.AntiAliasing
  local _Dof = self._elements.Dof
  local _Tessellation = self._elements.Tessellation
  local _LUT = self._elements.LUT
  if self.GRAPHIC.VeryVeryLow == value then
    _SSAO._curValue = false
    _AntiAliasing._curValue = false
    _Dof._curValue = false
    _Tessellation._curValue = false
    for index, eventControl in pairs(_Tessellation._eventControl) do
      eventControl:SetMonoTone(true)
      eventControl:SetEnable(false)
    end
  elseif self.GRAPHIC.VeryLow == value then
    if true == isIncrease then
      _SSAO._curValue = true
      _AntiAliasing._curValue = true
    elseif false == isIncrease then
      _Dof._curValue = false
      _Tessellation._curValue = false
    end
    for index, eventControl in pairs(_Tessellation._eventControl) do
      eventControl:SetMonoTone(true)
      eventControl:SetEnable(false)
    end
  elseif self.GRAPHIC.Low == value then
    if true == isIncrease then
      _SSAO._curValue = true
      _AntiAliasing._curValue = true
    elseif false == isIncrease then
      _Dof._curValue = false
      _Tessellation._curValue = false
    end
    for index, eventControl in pairs(_Tessellation._eventControl) do
      eventControl:SetMonoTone(true)
      eventControl:SetEnable(false)
    end
  elseif self.GRAPHIC.Medium == value then
    if true == isIncrease then
      _SSAO._curValue = true
      _AntiAliasing._curValue = true
    elseif false == isIncrease then
      _Dof._curValue = false
      _Tessellation._curValue = false
    end
    for index, eventControl in pairs(_Tessellation._eventControl) do
      eventControl:SetMonoTone(true)
      eventControl:SetEnable(false)
    end
  elseif self.GRAPHIC.High == value then
    if true == isIncrease then
      _SSAO._curValue = true
      _AntiAliasing._curValue = true
      _Dof._curValue = true
      _Tessellation._curValue = false
    elseif false == isIncrease then
      _Tessellation._curValue = false
    end
    for index, eventControl in pairs(_Tessellation._eventControl) do
      eventControl:SetMonoTone(true)
      eventControl:SetEnable(false)
    end
  elseif self.GRAPHIC.VeryHigh == value then
    if true == isIncrease then
      _SSAO._curValue = true
      _AntiAliasing._curValue = true
      _Dof._curValue = true
    end
    for index, eventControl in pairs(_Tessellation._eventControl) do
      eventControl:SetMonoTone(false)
      eventControl:SetEnable(true)
    end
  elseif self.GRAPHIC.VeryVeryHigh == value or self.GRAPHIC.UltraHigh == value or self.GRAPHIC.UltraLow == value then
    if true == isIncrease then
      _SSAO._curValue = true
      _AntiAliasing._curValue = true
      _Dof._curValue = true
    end
    for index, eventControl in pairs(_Tessellation._eventControl) do
      eventControl:SetMonoTone(false)
      eventControl:SetEnable(true)
    end
  end
  if self.GRAPHIC.UltraHigh == value or self.GRAPHIC.UltraLow == value then
    if true == isIncrease then
      self._lutCaching = PaGlobal_Option:Get("LUT")
      _LUT._curValue = PaGlobal_Option:GetLUTIndex("NonContrast")
    end
  elseif nil ~= self._lutCaching then
    _LUT._curValue = self._lutCaching
  elseif self.GRAPHIC.UltraHigh == PaGlobal_Option:Get("GraphicOption") or self.GRAPHIC.UltraLow == PaGlobal_Option:Get("GraphicOption") then
    _LUT._curValue = PaGlobal_Option:GetLUTIndex("Vibrance")
  end
  self:SetControlSettingTable(_SSAO, _SSAO._curValue)
  self:SetControlSettingTable(_AntiAliasing, _AntiAliasing._curValue)
  self:SetControlSettingTable(_Dof, _Dof._curValue)
  self:SetControlSettingTable(_Tessellation, _Tessellation._curValue)
  self:SetControlSettingTable(_LUT, _LUT._curValue)
end
function PaGlobal_Option:SetSpecSetting(value)
  local PETRENDER = {
    ALL = 0,
    ONLYME = 1,
    NONE = 2
  }
  local options = self._elements
  if self.SPEC.LowNormal == value then
    options.GraphicOption._curValue = self.GRAPHIC.VeryLow
    self:SetGraphicOption(options.GraphicOption._curValue, false)
    options.TextureQuality._curValue = 0
    options.UseEffectFrameOptimization._curValue = true
    options.EffectFrameOptimization._curValue = 0.9
    options.UsePlayerEffectDistOptimization._curValue = true
    options.PlayerEffectDistOptimization._curValue = 0.9
    options.UseCharacterUpdateFrameOptimize._curValue = true
    options.UseOtherPlayerUpdate._curValue = true
    options.WorkerVisible._curValue = false
    options.PetRender._curValue = PETRENDER.NONE
  elseif self.SPEC.MidNormal == value then
    options.GraphicOption._curValue = self.GRAPHIC.Medium
    self:SetGraphicOption(options.GraphicOption._curValue, false)
    options.TextureQuality._curValue = 1
    options.UseEffectFrameOptimization._curValue = true
    options.EffectFrameOptimization._curValue = 0.6
    options.UsePlayerEffectDistOptimization._curValue = true
    options.PlayerEffectDistOptimization._curValue = 0.6
    options.UseCharacterUpdateFrameOptimize._curValue = true
    options.UseOtherPlayerUpdate._curValue = true
    options.WorkerVisible._curValue = false
    options.PetRender._curValue = PETRENDER.NONE
  elseif self.SPEC.HighNormal == value then
    options.GraphicOption._curValue = self.GRAPHIC.VeryHigh
    self:SetGraphicOption(options.GraphicOption._curValue, true)
    options.TextureQuality._curValue = 2
    options.UseEffectFrameOptimization._curValue = true
    options.EffectFrameOptimization._curValue = 0.3
    options.UsePlayerEffectDistOptimization._curValue = true
    options.PlayerEffectDistOptimization._curValue = 0.3
    options.UseCharacterUpdateFrameOptimize._curValue = true
    options.UseOtherPlayerUpdate._curValue = false
    options.WorkerVisible._curValue = false
    options.PetRender._curValue = PETRENDER.ONLYME
  elseif self.SPEC.HighestNormal == value then
    options.GraphicOption._curValue = self.GRAPHIC.VeryVeryHigh
    self:SetGraphicOption(options.GraphicOption._curValue, true)
    options.TextureQuality._curValue = 2
    options.UseEffectFrameOptimization._curValue = false
    options.UsePlayerEffectDistOptimization._curValue = false
    options.UseCharacterUpdateFrameOptimize._curValue = false
    options.UseOtherPlayerUpdate._curValue = false
    options.WorkerVisible._curValue = true
    options.PetRender._curValue = PETRENDER.ALL
  elseif self.SPEC.LowSiege == value then
    options.GraphicOption._curValue = self.GRAPHIC.VeryLow
    self:SetGraphicOption(options.GraphicOption._curValue, false)
    options.TextureQuality._curValue = 0
    options.UseEffectFrameOptimization._curValue = true
    options.EffectFrameOptimization._curValue = 1
    options.UsePlayerEffectDistOptimization._curValue = true
    options.PlayerEffectDistOptimization._curValue = 1
    options.UseCharacterUpdateFrameOptimize._curValue = true
    options.UseOtherPlayerUpdate._curValue = true
    options.WorkerVisible._curValue = false
    options.PetRender._curValue = PETRENDER.NONE
  elseif self.SPEC.MidSiege == value then
    options.GraphicOption._curValue = self.GRAPHIC.Medium
    self:SetGraphicOption(options.GraphicOption._curValue, false)
    options.TextureQuality._curValue = 1
    options.UseEffectFrameOptimization._curValue = true
    options.EffectFrameOptimization._curValue = 0.75
    options.UsePlayerEffectDistOptimization._curValue = true
    options.PlayerEffectDistOptimization._curValue = 0.75
    options.UseCharacterUpdateFrameOptimize._curValue = true
    options.UseOtherPlayerUpdate._curValue = true
    options.WorkerVisible._curValue = false
    options.PetRender._curValue = PETRENDER.NONE
  elseif self.SPEC.HighSiege == value then
    options.GraphicOption._curValue = self.GRAPHIC.VeryHigh
    self:SetGraphicOption(options.GraphicOption._curValue, true)
    options.TextureQuality._curValue = 2
    options.UseEffectFrameOptimization._curValue = true
    options.EffectFrameOptimization._curValue = 0.5
    options.UsePlayerEffectDistOptimization._curValue = true
    options.PlayerEffectDistOptimization._curValue = 0.5
    options.UseCharacterUpdateFrameOptimize._curValue = true
    options.UseOtherPlayerUpdate._curValue = true
    options.WorkerVisible._curValue = false
    options.PetRender._curValue = PETRENDER.ONLYME
  elseif self.SPEC.HighestSiege == value then
    options.GraphicOption._curValue = self.GRAPHIC.VeryVeryHigh
    self:SetGraphicOption(options.GraphicOption._curValue, true)
    options.TextureQuality._curValue = 2
    options.UseEffectFrameOptimization._curValue = true
    options.EffectFrameOptimization._curValue = 0.3
    options.UsePlayerEffectDistOptimization._curValue = true
    options.PlayerEffectDistOptimization._curValue = 0.3
    options.UseCharacterUpdateFrameOptimize._curValue = true
    options.UseOtherPlayerUpdate._curValue = false
    options.WorkerVisible._curValue = false
    options.PetRender._curValue = PETRENDER.ONLYME
  end
  self:ClickedConfirmOption()
  self:MoveUi(self.UIMODE.Main)
end
local InitSpectionOption_LUT = function()
  local parent = UI.getChildControl(PaGlobal_Option._frames.Graphic.Effect._uiFrameContent, "StaticText_BgOrder0_Import")
  UI.getChildControl(parent, "Button_LUTReset"):addInputEvent("Mouse_LUp", "PaGlobal_Option:SetRecommandationLUT2()")
  UI.getChildControl(parent, "Button_LUTReset2"):addInputEvent("Mouse_LUp", "PaGlobal_Option:SetRecommandationLUT()")
end
local LUTRecommandation = -1
local LUTRecommandation2 = -1
local LUTRecommandationName = "Vibrance"
local LUTRecommandationName2 = "NonContrast"
function PaGlobal_Option:GetLUTIndex(str)
  for idx = 0, 30 do
    if getCameraLUTFilterName(idx) == str then
      return idx
    end
  end
  return nil
end
function PaGlobal_Option:SetRecommandationLUT()
  if LUTRecommandation == -1 then
    for idx = 0, 30 do
      if getCameraLUTFilterName(idx) == LUTRecommandationName then
        LUTRecommandation = idx
        LUTRecommandationName = nil
        break
      end
    end
  end
  local _contrastValue = 0.7
  if LUTRecommandation ~= -1 then
    self:SetXXX("LUT", LUTRecommandation)
    self:SetXXX("ContrastValue", _contrastValue)
  end
end
function PaGlobal_Option:SetRecommandationLUT2()
  if LUTRecommandation2 == -1 then
    for idx = 0, 30 do
      if getCameraLUTFilterName(idx) == LUTRecommandationName2 then
        LUTRecommandation2 = idx
        LUTRecommandationName2 = nil
        break
      end
    end
  end
  local _contrastValue = 0.5
  if LUTRecommandation2 ~= -1 then
    self:SetXXX("LUT", LUTRecommandation2)
    self:SetXXX("ContrastValue", _contrastValue)
  end
end
function PaGlobal_Option:SpectialOptionInit()
  InitSpectionOption_LUT()
  InitSpectionOption_LUT = nil
end
