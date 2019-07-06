Panel_FunctionButton_Area:SetShow(true)
local buttonId = {
  _landVehicle = 0,
  _horseRace = 1,
  _summon = 2,
  _seaVehicle = 3,
  _guildVehicle = 4,
  _summonElephant = 5,
  _house = 6,
  _worker = 7,
  _personalGarden = 8,
  _pet = 9,
  _maid = 10,
  _camp = 11,
  _siegeArea = 12,
  _duel = 13,
  _npcFind = 14,
  _movieGuide = 15,
  _voiceChat = 16,
  _blackSpiritTraining = 17,
  _militia = 18,
  _count = 19
}
PaGlobal_FunctionButtonArea = {
  _ui = {
    _bg = UI.getChildControl(Panel_FunctionButton_Area, "Static_FunctionButtonBg"),
    _editBg = UI.getChildControl(Panel_FunctionButton_Area, "Static_FunctionButtonEditBg"),
    _slider = UI.getChildControl(Panel_FunctionButton_Area, "Slider_FunctionButton"),
    _topButton = {},
    _editBox = {},
    _optionButton = nil,
    _saveButton = nil,
    _closeButton = nil,
    _effect = nil
  },
  _data = {
    [buttonId._landVehicle] = {
      _normal = {
        2,
        2,
        39,
        39
      },
      _over = {
        41,
        2,
        78,
        39
      },
      _click = {
        80,
        2,
        117,
        39
      },
      _isOpen = true
    },
    [buttonId._horseRace] = {
      _normal = {
        119,
        470,
        156,
        507
      },
      _over = {
        158,
        470,
        195,
        507
      },
      _click = {
        197,
        470,
        234,
        507
      },
      _isOpen = true
    },
    [buttonId._summon] = {
      _normal = {
        119,
        431,
        156,
        468
      },
      _over = {
        158,
        431,
        195,
        468
      },
      _click = {
        197,
        431,
        234,
        468
      },
      _isOpen = true
    },
    [buttonId._seaVehicle] = {
      _normal = {
        2,
        275,
        39,
        312
      },
      _over = {
        41,
        275,
        78,
        312
      },
      _click = {
        80,
        275,
        117,
        312
      },
      _isOpen = true
    },
    [buttonId._guildVehicle] = {
      _normal = {
        119,
        158,
        156,
        195
      },
      _over = {
        158,
        158,
        195,
        195
      },
      _click = {
        197,
        158,
        234,
        195
      },
      _isOpen = true
    },
    [buttonId._summonElephant] = {
      _normal = {
        2,
        314,
        39,
        351
      },
      _over = {
        41,
        314,
        78,
        351
      },
      _click = {
        80,
        314,
        117,
        351
      },
      _isOpen = true
    },
    [buttonId._house] = {
      _normal = {
        2,
        431,
        39,
        468
      },
      _over = {
        41,
        431,
        78,
        468
      },
      _click = {
        80,
        431,
        117,
        468
      },
      _isOpen = true
    },
    [buttonId._worker] = {
      _normal = {
        119,
        41,
        156,
        78
      },
      _over = {
        158,
        41,
        195,
        78
      },
      _click = {
        197,
        41,
        234,
        78
      },
      _isOpen = true
    },
    [buttonId._personalGarden] = {
      _normal = {
        2,
        470,
        39,
        507
      },
      _over = {
        41,
        470,
        78,
        507
      },
      _click = {
        80,
        470,
        117,
        507
      },
      _isOpen = true
    },
    [buttonId._pet] = {
      _normal = {
        119,
        2,
        156,
        39
      },
      _over = {
        158,
        2,
        195,
        39
      },
      _click = {
        197,
        2,
        234,
        39
      },
      _isOpen = true
    },
    [buttonId._maid] = {
      _normal = {
        119,
        119,
        156,
        156
      },
      _over = {
        158,
        119,
        195,
        156
      },
      _click = {
        197,
        119,
        234,
        156
      },
      _isOpen = true
    },
    [buttonId._camp] = {
      _normal = {
        2,
        353,
        39,
        390
      },
      _over = {
        41,
        353,
        78,
        390
      },
      _click = {
        80,
        353,
        117,
        390
      },
      _isOpen = true
    },
    [buttonId._siegeArea] = {
      _normal = {
        119,
        353,
        156,
        390
      },
      _over = {
        158,
        353,
        195,
        390
      },
      _click = {
        197,
        353,
        234,
        390
      },
      _isOpen = true
    },
    [buttonId._duel] = {
      _normal = {
        2,
        197,
        39,
        234
      },
      _over = {
        41,
        197,
        78,
        234
      },
      _click = {
        80,
        197,
        117,
        234
      },
      _isOpen = true
    },
    [buttonId._npcFind] = {
      _normal = {
        119,
        197,
        156,
        234
      },
      _over = {
        158,
        197,
        195,
        234
      },
      _click = {
        197,
        197,
        234,
        234
      },
      _isOpen = true
    },
    [buttonId._movieGuide] = {
      _normal = {
        119,
        275,
        156,
        312
      },
      _over = {
        158,
        275,
        195,
        312
      },
      _click = {
        197,
        275,
        234,
        312
      },
      _isOpen = true
    },
    [buttonId._voiceChat] = {
      _normal = {
        119,
        236,
        156,
        273
      },
      _over = {
        158,
        236,
        195,
        273
      },
      _click = {
        197,
        236,
        234,
        273
      },
      _isOpen = true
    },
    [buttonId._blackSpiritTraining] = {
      _normal = {
        119,
        392,
        156,
        429
      },
      _over = {
        158,
        392,
        195,
        429
      },
      _click = {
        197,
        392,
        234,
        429
      },
      _isOpen = true
    },
    [buttonId._militia] = {
      _normal = {
        2,
        392,
        39,
        429
      },
      _over = {
        41,
        392,
        78,
        429
      },
      _click = {
        80,
        392,
        117,
        429
      },
      _isOpen = true
    }
  },
  _landVehicleTextureData = {
    _horseNormal = {
      _normal = {
        2,
        2,
        39,
        39
      },
      _over = {
        41,
        2,
        78,
        39
      },
      _click = {
        80,
        2,
        117,
        39
      }
    },
    _horsePipe = {
      _normal = {
        2,
        80,
        39,
        117
      },
      _over = {
        41,
        80,
        78,
        117
      },
      _click = {
        80,
        80,
        117,
        117
      }
    },
    _horsePcRoom = {
      _normal = {
        2,
        41,
        39,
        78
      },
      _over = {
        41,
        41,
        78,
        78
      },
      _click = {
        80,
        41,
        117,
        78
      }
    },
    _camel = {
      _normal = {
        2,
        158,
        39,
        195
      },
      _over = {
        41,
        158,
        78,
        195
      },
      _click = {
        80,
        158,
        117,
        195
      }
    },
    _donkey = {
      _normal = {
        119,
        80,
        156,
        117
      },
      _over = {
        158,
        80,
        195,
        117
      },
      _click = {
        197,
        80,
        234,
        117
      }
    },
    _babyElephant = {
      _normal = {
        2,
        119,
        39,
        156
      },
      _over = {
        41,
        119,
        78,
        156
      },
      _click = {
        80,
        119,
        117,
        156
      }
    },
    _carriage = {
      _normal = {
        2,
        236,
        39,
        273
      },
      _over = {
        41,
        236,
        78,
        273
      },
      _click = {
        80,
        236,
        117,
        273
      }
    }
  },
  _summonTextureData = {
    _summoner = {
      _normal = {
        119,
        431,
        156,
        468
      },
      _over = {
        158,
        431,
        195,
        468
      },
      _click = {
        197,
        431,
        234,
        468
      }
    },
    _wizard = {
      _normal = {
        119,
        314,
        156,
        351
      },
      _over = {
        158,
        314,
        195,
        351
      },
      _click = {
        197,
        314,
        234,
        351
      }
    }
  },
  _defaultGroup = {
    [1] = {
      buttonId._npcFind + 1,
      buttonId._landVehicle + 1,
      buttonId._horseRace + 1,
      buttonId._pet + 1,
      buttonId._house + 1,
      buttonId._worker + 1
    },
    [2] = {
      0,
      0,
      0,
      0,
      0,
      0
    },
    [3] = {
      0,
      0,
      0,
      0,
      0,
      0
    }
  },
  _compareGroup = {
    [1] = {},
    [2] = {},
    [3] = {}
  },
  _iconPath = "Renewal/Button/PC_Btn_00.dds",
  _topIconCount = 6,
  _groupCount = 3,
  _iconCount = 6,
  _isShowElephant = false,
  _currentGroup = 1,
  _currentSlot = 0,
  _globalUIOptionType_OptimizationButton = {
    [0] = __eOptimizationButton0,
    [1] = __eOptimizationButton1,
    [2] = __eOptimizationButton2,
    [3] = __eOptimizationButton3,
    [4] = __eOptimizationButton4,
    [5] = __eOptimizationButton5,
    [6] = __eOptimizationButton6,
    [7] = __eOptimizationButton7,
    [8] = __eOptimizationButton8,
    [9] = __eOptimizationButton9,
    [10] = __eOptimizationButton10,
    [11] = __eOptimizationButton11,
    [12] = __eOptimizationButton12,
    [13] = __eOptimizationButton13,
    [14] = __eOptimizationButton14,
    [15] = __eOptimizationButton15,
    [16] = __eOptimizationButton16,
    [17] = __eOptimizationButton17
  }
}
function PaGlobal_FunctionButtonArea:Initialize()
  for index = 0, self._topIconCount - 1 do
    local tempBg = UI.getChildControl(self._ui._bg, "Static_SlotBG" .. index + 1)
    self._ui._topButton[index] = UI.getChildControl(tempBg, "Button_Horse")
    self._ui._topButton[index]:addInputEvent("Mouse_LUp", "PaGlobal_FunctionButtonArea:HandleLClicked_TopSlot(" .. index .. ")")
    self._ui._topButton[index]:addInputEvent("Mouse_On", "")
    self._ui._topButton[index]:addInputEvent("Mouse_Out", "")
  end
  self._ui._optionButton = UI.getChildControl(self._ui._bg, "Button_OptionButton")
  self._ui._optionButton:addInputEvent("Mouse_LUp", "PaGlobal_FunctionButtonArea:EditBox_ShowToggle()")
  self:OpenCheck()
  self._ui._saveButton = UI.getChildControl(self._ui._editBg, "Button_Save")
  self._ui._saveButton:addInputEvent("Mouse_LUp", "PaGlobal_FunctionButtonArea:Save()")
  self._ui._closeButton = UI.getChildControl(self._ui._editBg, "Button_Close")
  self._ui._closeButton:addInputEvent("Mouse_LUp", "PaGlobal_FunctionButtonArea:Close()")
  self._ui._effect = UI.getChildControl(self._ui._editBg, "Static_Effect")
  local editBox = self._ui._editBox
  editBox._radioButton = {}
  editBox._slotBg = {}
  editBox._slotIcon = {}
  for index = 0, self._groupCount - 1 do
    local tempRadioBtn = UI.getChildControl(self._ui._editBg, "Radiobutton_Group" .. index + 1)
    tempRadioBtn:addInputEvent("Mouse_LUp", "")
    editBox._radioButton[index] = tempRadioBtn
    local tempSlotBg = UI.getChildControl(self._ui._editBg, "Static_SlotBg")
    local tempIcon = UI.getChildControl(tempSlotBg, "Button_Icon")
    editBox._slotBg[index] = {}
    editBox._slotIcon[index] = {}
    for iIndex = 0, self._iconCount - 1 do
      editBox._slotBg[index][iIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._editBg, "SlotBg_" .. index .. "_" .. iIndex)
      CopyBaseProperty(tempSlotBg, editBox._slotBg[index][iIndex])
      editBox._slotBg[index][iIndex]:SetPosX(32 + iIndex * 43)
      editBox._slotBg[index][iIndex]:SetPosY(47 + index * 46)
      editBox._slotBg[index][iIndex]:SetShow(true)
      editBox._slotIcon[index][iIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, editBox._slotBg[index][iIndex], "SlotIcon" .. index .. "_" .. iIndex)
      CopyBaseProperty(tempIcon, editBox._slotIcon[index][iIndex])
      editBox._slotIcon[index][iIndex]:addInputEvent("Mouse_LUp", "PaGlobal_FunctionButtonArea:HandleLClicked_SelectSlot(" .. index .. "," .. iIndex .. ")")
      editBox._slotIcon[index][iIndex]:addInputEvent("Mouse_RUp", "PaGlobal_FunctionButtonArea:HandleRClicked_RemoveSlot(" .. index .. "," .. iIndex .. ")")
      editBox._slotIcon[index][iIndex]:addInputEvent("Mouse_On", "")
      editBox._slotIcon[index][iIndex]:addInputEvent("Mouse_Out", "")
      local _index = index * 6 + iIndex
      local savedIndex = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(self._globalUIOptionType_OptimizationButton[_index])
      if savedIndex > 0 then
        self._defaultGroup[index + 1][iIndex + 1] = savedIndex
      end
      self._compareGroup[index + 1][iIndex + 1] = self._defaultGroup[index + 1][iIndex + 1]
      ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(self._globalUIOptionType_OptimizationButton[_index], 0, CppEnums.VariableStorageType.eVariableStorageType_User)
    end
  end
  self._ui._effect:SetPosX(editBox._slotBg[0][0]:GetPosX() - 1)
  self._ui._effect:SetPosY(editBox._slotBg[0][0]:GetPosY() - 1)
  self._ui._editBg:SetChildIndex(self._ui._effect, 100)
  local tempButtonBg = UI.getChildControl(self._ui._editBg, "Static_ButtonBG")
  local tempButton = UI.getChildControl(tempButtonBg, "Button_HorsePipe")
  editBox._button = {}
  for index = 0, buttonId._count - 1 do
    editBox._button[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, tempButtonBg, "BaseButton_" .. index)
    CopyBaseProperty(tempButton, editBox._button[index])
    editBox._button[index]:SetShow(false)
    editBox._button[index]:addInputEvent("Mouse_LUp", "PaGlobal_FunctionButtonArea:HandleLClicked_SetSlot(" .. index .. ")")
    editBox._button[index]:addInputEvent("Mouse_On", "")
    editBox._button[index]:addInputEvent("Mouse_Out", "")
    self:ChangeTexture(editBox._button[index], index)
  end
  self._ui._editBg:SetShow(false)
  self:Update()
  Panel_FunctionButton_Area:SetPosX(getScreenSizeX() - Panel_FunctionButton_Area:GetSizeX() - 20)
  Panel_FunctionButton_Area:SetPosY(Panel_Radar:GetPosY() + Panel_Radar:GetSizeY())
end
function PaGlobal_FunctionButtonArea:HandleLClicked_TopSlot(index)
  if self._ui._editBg:GetShow() then
    Proc_ShowMessage_Ack("\235\168\188\236\160\128 \237\142\184\236\167\145\236\157\132 \236\162\133\235\163\140\237\149\180\236\163\188\236\132\184\236\154\148.")
    return
  end
  local realIndex = self._defaultGroup[self._currentGroup][index + 1] - 1
  local isActivation = self:ContentsCheck(realIndex)
  if not isActivation then
    Proc_ShowMessage_Ack("\237\153\156\236\132\177\237\153\148\234\176\128 \235\144\152\236\150\180 \236\158\136\236\167\128 \236\149\138\236\149\132 \236\139\164\237\150\137\237\149\160 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  if buttonId._landVehicle == realIndex then
    servant_callServant()
  elseif buttonId._horseRace == realIndex then
    FGlobal_Raceinfo_ShowToggle()
  elseif buttonId._summon == realIndex then
  elseif buttonId._seaVehicle == realIndex then
  elseif buttonId._guildVehicle == realIndex then
    FGlobal_GuildServantList_Open()
  elseif buttonId._summonElephant == realIndex then
  elseif buttonId._house == realIndex then
    FGlobal_HousingList_Open()
  elseif buttonId._worker == realIndex then
    if true == _ContentsGroup_NewUI_WorkerManager_All then
      PaGlobalFunc_WorkerManager_All_ShowToggle()
    else
      FGlobal_WorkerManger_ShowToggle()
    end
  elseif buttonId._personalGarden == realIndex then
    HandleClicked_TentList_ShowToggle()
  elseif buttonId._pet == realIndex then
    FGlobal_PetListNew_Toggle()
  elseif buttonId._maid == realIndex then
    if false == _ContentsGroup_NewUI_Maid_All then
      MaidList_Open()
    else
      PaGlobalFunc_MaidList_All_Open()
    end
  elseif buttonId._camp == realIndex then
    FGlobal_Camp_Open()
  elseif buttonId._siegeArea == realIndex then
    ToggleVillageSiegeArea()
  elseif buttonId._duel == realIndex then
  elseif buttonId._npcFind == realIndex then
    NpcNavi_ShowToggle()
  elseif buttonId._movieGuide == realIndex then
    Panel_MovieGuide_ShowToggle()
  elseif buttonId._voiceChat == realIndex then
    FGlobal_SetVoiceChat_Toggle()
  elseif buttonId._blackSpiritTraining == realIndex then
  elseif buttonId._militia == realIndex then
    FGlobal_MercenaryOpen()
  end
end
function PaGlobal_FunctionButtonArea:HandleLClicked_SelectSlot(groupIndex, index)
  local editBox = self._ui._editBox
  self._ui._effect:SetPosX(editBox._slotBg[groupIndex][index]:GetPosX() - 1)
  self._ui._effect:SetPosY(editBox._slotBg[groupIndex][index]:GetPosY() - 1)
  self._currentSlot = groupIndex * 6 + index
end
function PaGlobal_FunctionButtonArea:HandleRClicked_RemoveSlot(groupIndex, index)
  local editBox = self._ui._editBox
  self._ui._effect:SetPosX(editBox._slotBg[groupIndex][index]:GetPosX() - 1)
  self._ui._effect:SetPosY(editBox._slotBg[groupIndex][index]:GetPosY() - 1)
  self._currentSlot = groupIndex * 6 + index
  self._defaultGroup[groupIndex + 1][index + 1] = 0
  local control = editBox._slotIcon[groupIndex][index]
  self:PlusChangeTexture(control)
end
function PaGlobal_FunctionButtonArea:HandleLClicked_SetSlot(index)
  local editBox = self._ui._editBox
  local groupIndex = math.floor(self._currentSlot / 6)
  local slotIndex = self._currentSlot % 6
  local control = editBox._slotIcon[groupIndex][slotIndex]
  self:ChangeTexture(control, index)
  local isActivation = self:ContentsCheck(index)
  self:Button_ActivationCheck(control, isActivation)
  self._defaultGroup[groupIndex + 1][slotIndex + 1] = index + 1
end
function PaGlobal_FunctionButtonArea:Save()
  local function saveIndex()
    for gIndex = 0, self._groupCount - 1 do
      for sIndex = 0, self._iconCount - 1 do
        local _index = gIndex * self._iconCount + sIndex
        ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(self._globalUIOptionType_OptimizationButton[_index], self._defaultGroup[gIndex + 1][sIndex + 1], CppEnums.VariableStorageType.eVariableStorageType_User)
        self._compareGroup[gIndex + 1][sIndex + 1] = self._defaultGroup[gIndex + 1][sIndex + 1]
      end
    end
  end
  local isDifferent = self:CompareIndex()
  if isDifferent then
    local messageBoxMemo = "\235\179\128\234\178\189\235\144\156 \235\130\180\236\154\169\236\157\132 \236\160\128\236\158\165\237\149\152\236\139\156\234\178\160\236\138\181\235\139\136\234\185\140?"
    local messageBoxData = {
      title = "\234\184\176\235\138\165 \235\178\132\237\138\188 \237\142\184\236\167\145",
      content = messageBoxMemo,
      functionYes = saveIndex,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function PaGlobal_FunctionButtonArea:Close()
  local function closeWindow()
    self:EditBox_ShowToggle(false)
  end
  local isDifferent = self:CompareIndex()
  if isDifferent then
    local messageBoxMemo = "\235\179\128\234\178\189\235\144\156 \235\130\180\236\154\169\236\157\180 \236\158\136\236\138\181\235\139\136\235\139\164. \234\179\132\236\134\141\237\149\152\236\139\156\234\178\160\236\138\181\235\139\136\234\185\140?"
    local messageBoxData = {
      title = "\234\184\176\235\138\165 \235\178\132\237\138\188 \237\142\184\236\167\145",
      content = messageBoxMemo,
      functionYes = closeWindow,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    closeWindow()
  end
end
function PaGlobal_FunctionButtonArea:CompareIndex()
  for gIndex = 0, self._groupCount - 1 do
    for sIndex = 0, self._iconCount - 1 do
      if self._defaultGroup[gIndex + 1][sIndex + 1] ~= self._compareGroup[gIndex + 1][sIndex + 1] then
        return true
      end
    end
  end
  return false
end
function PaGlobal_FunctionButtonArea:ChangeTexture(control, index)
  local self = PaGlobal_FunctionButtonArea
  control:ChangeTextureInfoName(self._iconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(control, self._data[index]._normal[1], self._data[index]._normal[2], self._data[index]._normal[3], self._data[index]._normal[4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
  control:ChangeOnTextureInfoName(self._iconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(control, self._data[index]._over[1], self._data[index]._over[2], self._data[index]._over[3], self._data[index]._over[4])
  control:getOnTexture():setUV(x1, y1, x2, y2)
  control:ChangeClickTextureInfoName(self._iconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(control, self._data[index]._click[1], self._data[index]._click[2], self._data[index]._click[3], self._data[index]._click[4])
  control:getClickTexture():setUV(x1, y1, x2, y2)
end
function PaGlobal_FunctionButtonArea:LandVehicleChangeTexture(index)
  local self = PaGlobal_FunctionButtonArea
  local texture = {}
  if 0 == index then
    texture = self._landVehicleTextureData._horseNormal
  elseif 1 == index then
    texture = self._landVehicleTextureData._horsePipe
  elseif 2 == index then
    texture = self._landVehicleTextureData._horsePcRoom
  elseif 3 == index then
    texture = self._landVehicleTextureData._camel
  elseif 4 == index then
    texture = self._landVehicleTextureData._donkey
  elseif 5 == index then
    texture = self._landVehicleTextureData._babyElephant
  elseif 6 == index then
    texture = self._landVehicleTextureData._carriage
  else
    texture = self._landVehicleTextureData._horseNormal
  end
  control:ChangeTextureInfoName(self._iconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(control, texture._normal[1], texture._normal[2], texture._normal[3], texture._normal[4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
  control:ChangeOnTextureInfoName(self._iconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(control, texture._over[1], texture._over[2], texture._over[3], texture._over[4])
  control:getOnTexture():setUV(x1, y1, x2, y2)
  control:ChangeClickTextureInfoName(self._iconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(control, texture._click[1], texture._click[2], texture._click[3], texture._click[4])
  control:getClickTexture():setUV(x1, y1, x2, y2)
end
function PaGlobal_FunctionButtonArea:SummonChangeTexture(index)
  local self = PaGlobal_FunctionButtonArea
  local texture = {}
  if 0 == index then
    texture = self._summonTextureData._summoner
  else
    texture = self._summonTextureData._wizard
  end
  control:ChangeTextureInfoName(self._iconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(control, texture._normal[1], texture._normal[2], texture._normal[3], texture._normal[4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
  control:ChangeOnTextureInfoName(self._iconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(control, texture._over[1], texture._over[2], texture._over[3], texture._over[4])
  control:getOnTexture():setUV(x1, y1, x2, y2)
  control:ChangeClickTextureInfoName(self._iconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(control, texture._click[1], texture._click[2], texture._click[3], texture._click[4])
  control:getClickTexture():setUV(x1, y1, x2, y2)
end
function PaGlobal_FunctionButtonArea:PlusChangeTexture(control)
  control:ChangeTextureInfoName("new_ui_common_forlua/default/console_frame_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, 84, 108, 104, 128)
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
  control:ChangeOnTextureInfoName("new_ui_common_forlua/default/console_frame_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, 84, 108, 104, 128)
  control:getOnTexture():setUV(x1, y1, x2, y2)
  control:ChangeClickTextureInfoName("new_ui_common_forlua/default/console_frame_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, 84, 108, 104, 128)
  control:getClickTexture():setUV(x1, y1, x2, y2)
  control:SetColor(Defines.Color.C_FFFFFFFF)
end
function PaGlobal_FunctionButtonArea:EditBox_ShowToggle(isShow)
  if nil ~= isShow then
    self._ui._editBg:SetShow(isShow)
  elseif self._ui._editBg:GetShow() then
    self._ui._editBg:SetShow(false)
  else
    self._ui._editBg:SetShow(true)
  end
  local editBox = self._ui._editBox
  self._ui._effect:SetPosX(editBox._slotBg[0][0]:GetPosX() - 1)
  self._ui._effect:SetPosY(editBox._slotBg[0][0]:GetPosY() - 1)
  self._currentSlot = 0
  self:Update()
end
function PaGlobal_FunctionButtonArea:OpenCheck()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local classType = selfPlayer:getClassType()
  local playerLevel = selfPlayer:get():getLevel()
  if CppEnums.ClassType.ClassType_Tamer == classType then
    if playerLevel >= 20 then
      self._data[buttonId._summon]._isOpen = true
    else
      self._data[buttonId._summon]._isOpen = false
    end
  elseif CppEnums.ClassType.ClassType_Wizard == classType or CppEnums.ClassType.ClassType_WizardWomen == classType then
    if playerLevel >= 56 then
      self._data[buttonId._summon]._isOpen = true
    else
      self._data[buttonId._summon]._isOpen = false
    end
  else
    self._data[buttonId._summon]._isOpen = false
  end
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  self._data[buttonId._guildVehicle]._isOpen = nil ~= guildWrapper
  self._data[buttonId._summonElephant]._isOpen = nil ~= guildWrapper
  local isHaveDwelling = ToClient_IsHaveDwelling()
  self._data[buttonId._house]._isOpen = isHaveDwelling
  local workerCount = ToClient_getMyNpcWorkerCount()
  self._data[buttonId._worker]._isOpen = workerCount > 0
  local temporaryWrapper = getTemporaryInformationWrapper()
  local tentCheck = nil ~= temporaryWrapper and temporaryWrapper:isSelfTent()
  self._data[buttonId._personalGarden]._isOpen = tentCheck
  local havePetCount = ToClient_getPetUnsealedList() + ToClient_getPetSealedList()
  self._data[buttonId._pet]._isOpen = havePetCount > 0
  local maidCount = getTotalMaidList()
  self._data[buttonId._maid]._isOpen = maidCount >= 0
  local isRegisted = ToClient_isCampingReigsted()
  self._data[buttonId._camp]._isOpen = isRegisted
  self._data[buttonId._blackSpiritTraining]._isOpen = playerLevel >= 50
  local isMilitia = ToClient_IsContentsGroupOpen("245")
  self._data[buttonId._militia]._isOpen = isMilitia
end
function PaGlobal_FunctionButtonArea:Update()
  if self._ui._editBg:GetShow() then
    local editBox = self._ui._editBox
    local realIndex = 0
    for index = 0, buttonId._count - 1 do
      if self._data[index]._isOpen then
        editBox._button[index]:SetShow(true)
        editBox._button[index]:SetPosX(6 + 44 * (realIndex % 6))
        editBox._button[index]:SetPosY(6 + 45 * math.floor(realIndex / 6))
        local isActivation = self:ContentsCheck(index)
        self:Button_ActivationCheck(editBox._button[index], isActivation)
        realIndex = realIndex + 1
      else
        editBox._button[index]:SetShow(false)
      end
    end
    for gIndex = 0, self._groupCount - 1 do
      for sIndex = 0, self._iconCount - 1 do
        local control = editBox._slotIcon[gIndex][sIndex]
        local index = self._defaultGroup[gIndex + 1][sIndex + 1] - 1
        if -1 == index then
          self:PlusChangeTexture(control)
        else
          self:ChangeTexture(control, index)
          local isActivation = self:ContentsCheck(index)
          self:Button_ActivationCheck(control, isActivation)
        end
      end
    end
  else
    for sIndex = 0, self._iconCount - 1 do
      local control = self._ui._topButton[sIndex]
      local index = self._defaultGroup[self._currentGroup][sIndex + 1] - 1
      if -1 == index then
        self:PlusChangeTexture(control)
      else
        _PA_LOG("\236\157\180\235\172\184\236\162\133", "index : " .. index)
        self:ChangeTexture(control, index)
        local isActivation = self:ContentsCheck(index)
        self:Button_ActivationCheck(control, isActivation)
      end
    end
  end
end
function PaGlobal_FunctionButtonArea:ContentsCheck(index)
  if buttonId._landVehicle == index then
    return self:landVehicle()
  elseif buttonId._horseRace == index then
    return self:horseRace()
  elseif buttonId._summon == index then
    return self:summon()
  elseif buttonId._seaVehicle == index then
    return self:seaVehicle()
  elseif buttonId._guildVehicle == index then
    return self:guildVehicle()
  elseif buttonId._summonElephant == index then
    return self:summonElephant()
  elseif buttonId._house == index then
    return self:house()
  elseif buttonId._worker == index then
    return self:worker()
  elseif buttonId._personalGarden == index then
    return self:personalGarden()
  elseif buttonId._pet == index then
    return self:pet()
  elseif buttonId._maid == index then
    return self:maid()
  elseif buttonId._camp == index then
    return self:camp()
  elseif buttonId._duel == index then
    return self:duel()
  elseif buttonId._blackSpiritTraining == index then
    return self:blackSpiritTraining()
  else
    return true
  end
end
function PaGlobal_FunctionButtonArea:Button_ActivationCheck(control, isActivation)
  local editBox = self._ui._editBox
  if isActivation then
    control:SetColor(Defines.Color.C_FFFFFFFF)
  else
    control:SetColor(Defines.Color.C_FFF26A6A)
  end
end
function PaGlobal_FunctionButtonArea:landVehicle()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local landVehicleWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
  if nil == landVehicleWrapper then
    return false
  end
  if CppEnums.VehicleType.Type_Horse == landVehicleWrapper:getVehicleType() then
    local temporaryPCRoomWrapper = getTemporaryInformationWrapper()
    local isPremiumPcRoom = temporaryPCRoomWrapper:isPremiumPcRoom()
    local isRussiaPremiumPack = getSelfPlayer():get():isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_RussiaPack3)
    if isPremiumPcRoom or isRussiaPremiumPack then
      self:LandVehicleChangeTexture(2)
    elseif doHaveContentsItem(16, CppEnums.VehicleType.Type_Horse) then
      self:LandVehicleChangeTexture(1)
    else
      self:LandVehicleChangeTexture(0)
    end
  elseif CppEnums.VehicleType.Type_Camel == landVehicleWrapper:getVehicleType() then
    self:LandVehicleChangeTexture(3)
  elseif CppEnums.VehicleType.Type_Donkey == landVehicleWrapper:getVehicleType() then
    self:LandVehicleChangeTexture(4)
  elseif CppEnums.VehicleType.Type_RidableBabyElephant == landVehicleWrapper:getVehicleType() then
    self:LandVehicleChangeTexture(5)
  elseif CppEnums.VehicleType.Type_Carriage == landVehicleWrapper:getVehicleType() or CppEnums.VehicleType.Type_CowCarriage == landVehicleWrapper:getVehicleType() or CppEnums.VehicleType.Type_RepairableCarriage == landVehicleWrapper:getVehicleType() then
    self:LandVehicleChangeTexture(6)
  end
  return true
end
function PaGlobal_FunctionButtonArea:horseRace()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local landVehicleWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
  if nil == landVehicleWrapper then
    return false
  end
  if CppEnums.VehicleType.Type_Horse == landVehicleWrapper:getVehicleType() then
    return true
  else
    return false
  end
end
function PaGlobal_FunctionButtonArea:summon()
  local summonCount = getSelfPlayer():getSummonListCount()
  for summon_idx = 0, summonCount - 1 do
    local summonInfo = getSelfPlayer():getSummonDataByIndex(summon_idx)
    local characterKey = summonInfo:getCharacterKey()
    if characterKey >= 60028 and characterKey <= 60037 or 60068 == characterKey then
      local summonWrapper = summonInfo:getActor()
      local hpRate = 0
      if nil == summonWrapper then
        hpRate = 100
      else
        local hp = summonWrapper:get():getHp()
        local maxHp = summonWrapper:get():getMaxHp()
        hpRate = hp / maxHp * 100
      end
      self:SummonChangeTexture(0)
      return true
    elseif 60134 == characterKey or 60137 == characterKey or 60136 == characterKey or 60135 == characterKey then
      local summonWrapper = summonInfo:getActor()
      local hpRate = 0
      if nil == summonWrapper then
        hpRate = 100
      else
        local hp = summonWrapper:get():getHp()
        local maxHp = summonWrapper:get():getMaxHp()
        hpRate = hp / maxHp * 100
      end
      self:SummonChangeTexture(1)
      return true
    end
  end
  return false
end
function PaGlobal_FunctionButtonArea:seaVehicle()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local seaVehicleWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Ship)
  if nil ~= seaVehicleWrapper and CppEnums.VehicleType.Type_SailingBoat ~= seaVehicleWrapper:getVehicleType() then
    return true
  end
  return false
end
function PaGlobal_FunctionButtonArea:guildVehicle()
  local guildVehicleCount = guildstable_getUnsealGuildServantCount()
  for index = 0, guildVehicleCount - 1 do
    local servantWrapper = guildStable_getUnsealGuildServantAt(index)
    if nil ~= servantWrapper then
      return true
    end
  end
  return false
end
function PaGlobal_FunctionButtonArea:summonElephant()
  return self._isShowElephant
end
function PaGlobal_FunctionButtonArea:house()
  local isHaveDwelling = ToClient_IsHaveDwelling()
  return isHaveDwelling
end
function PaGlobal_FunctionButtonArea:worker()
  local workerCount = ToClient_getMyNpcWorkerCount()
  return workerCount > 0
end
function PaGlobal_FunctionButtonArea:personalGarden()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local tentCheck = nil ~= temporaryWrapper and temporaryWrapper:isSelfTent()
  return tentCheck
end
function PaGlobal_FunctionButtonArea:pet()
  local havePetCount = ToClient_getPetUnsealedList() + ToClient_getPetSealedList()
  return havePetCount > 0
end
function PaGlobal_FunctionButtonArea:maid()
  local maidCount = getTotalMaidList()
  return maidCount > 0
end
function PaGlobal_FunctionButtonArea:camp()
  local isRegisted = ToClient_isCampingReigsted()
  return isRegisted
end
function PaGlobal_FunctionButtonArea:duel()
  local isPlaying = getSelfPlayer():isDefinedPvPMatch()
  return isPlaying
end
function PaGlobal_FunctionButtonArea:blackSpiritTraining()
  local autoTrain = ToClient_IsAutoLevelUp()
  return autoTrain
end
function FromClient_ShowElephantBarn(actorKeyRaw)
  PaGlobal_FunctionButtonArea._isShowElephant = true
end
function FromClient_HideElephantBarn(actorKeyRaw)
  PaGlobal_FunctionButtonArea._isShowElephant = false
end
function SummonElephant_Tooltip_ShowToggle(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONELEPHANT_TOOLTIP_TITLE")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONELEPHANT_TOOLTIP_DESC")
  TooltipSimple_Show(_btn_SummonElephant, name, desc)
end
function FGlobal_Camp_Open()
  PaGlobal_Camp:open()
end
local showSiegeArea = false
function ToggleVillageSiegeArea()
  showSiegeArea = not showSiegeArea
  ToClient_toggleVillageSiegeArea(showSiegeArea)
end
registerEvent("FromClient_ShowElephantBarn", "FromClient_ShowElephantBarn")
registerEvent("FromClient_HideElephantBarn", "FromClient_HideElephantBarn")
PaGlobal_FunctionButtonArea:Initialize()
