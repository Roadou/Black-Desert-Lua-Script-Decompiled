local _panel = Panel_Window_DyeingPartList_Renew
local DyeingPartList = {
  _ui = {
    stc_titleBG = UI.getChildControl(_panel, "Static_TitleBg"),
    txt_titleTop = nil,
    stc_listBG = UI.getChildControl(_panel, "Static_ItemListBG"),
    stc_equipSlotBG = {},
    slot_equipItem = {},
    stc_equipSlotPictogram = {},
    stc_costumeSlotBG = {},
    slot_costumeItem = {},
    stc_costumeSlotPictogram = {},
    stc_slotFocus = nil,
    txt_keyGuideA = UI.getChildControl(_panel, "StaticText_A_ConsoleUI")
  },
  _currentTargetIndex = nil,
  _equipSlotCountMax = 1,
  _costumeSlotCountMax = 1,
  _defaultGap = 64,
  _startX = 15,
  _startY = 15,
  _columnMax = 6
}
local TARGET_INDEX = {
  CHARACTER = 1,
  HORSE = 2,
  CARRIAGE = 3,
  CARMEL = 4,
  TENT = 5
}
local TARGET_TYPE_ENUM = {
  [TARGET_INDEX.CHARACTER] = 0,
  [TARGET_INDEX.HORSE] = 1,
  [TARGET_INDEX.CARRIAGE] = 2,
  [TARGET_INDEX.CARMEL] = 3,
  [TARGET_INDEX.TENT] = 6
}
local _targetData = {
  [TARGET_INDEX.CHARACTER] = {
    equipSlotNoList = {
      0,
      29,
      1,
      3,
      4,
      5,
      6
    },
    costumeSlotNoList = {
      18,
      30,
      19,
      14,
      15,
      16,
      17,
      20,
      21,
      22,
      23
    },
    pictogramUV = {
      [0] = {
        1,
        87,
        43,
        129
      },
      [1] = {
        87,
        87,
        129,
        129
      },
      [2] = {
        1,
        44,
        43,
        86
      },
      [3] = {
        130,
        87,
        172,
        129
      },
      [4] = {
        130,
        44,
        172,
        86
      },
      [5] = {
        173,
        1,
        215,
        43
      },
      [6] = {
        87,
        44,
        129,
        86
      },
      [14] = {
        44,
        130,
        86,
        172
      },
      [15] = {
        87,
        130,
        129,
        172
      },
      [16] = {
        216,
        1,
        258,
        43
      },
      [17] = {
        1,
        130,
        43,
        172
      },
      [18] = {
        173,
        130,
        215,
        172
      },
      [19] = {
        130,
        130,
        172,
        172
      },
      [20] = {
        216,
        44,
        258,
        86
      },
      [21] = {
        216,
        130,
        258,
        172
      },
      [22] = {
        1,
        173,
        43,
        215
      },
      [23] = {
        44,
        173,
        86,
        215
      },
      [29] = {
        44,
        87,
        86,
        129
      },
      [30] = {
        87,
        173,
        129,
        215
      }
    }
  },
  [TARGET_INDEX.HORSE] = {
    equipSlotNoList = {
      3,
      4,
      5,
      6,
      12
    },
    costumeSlotNoList = {
      14,
      15,
      16,
      17
    },
    pictogramUV = {
      [3] = {
        259,
        87,
        301,
        129
      },
      [4] = {
        259,
        173,
        301,
        215
      },
      [5] = {
        259,
        44,
        301,
        86
      },
      [6] = {
        259,
        130,
        301,
        172
      },
      [12] = {
        259,
        216,
        301,
        258
      },
      [14] = {
        302,
        87,
        344,
        129
      },
      [15] = {
        302,
        173,
        344,
        215
      },
      [16] = {
        302,
        44,
        344,
        86
      },
      [17] = {
        302,
        130,
        344,
        172
      }
    }
  },
  [TARGET_INDEX.CARRIAGE] = {
    equipSlotNoList = {
      4,
      5,
      6,
      13,
      25
    },
    costumeSlotNoList = {
      14,
      15,
      26
    },
    pictogramUV = {
      [4] = {
        173,
        173,
        215,
        215
      },
      [5] = {
        130,
        302,
        172,
        344
      },
      [6] = {
        87,
        302,
        129,
        344
      },
      [13] = {
        44,
        44,
        86,
        86
      },
      [25] = {
        173,
        216,
        215,
        258
      },
      [14] = {
        216,
        216,
        258,
        258
      },
      [15] = {
        216,
        173,
        258,
        215
      },
      [26] = {
        130,
        173,
        172,
        215
      }
    }
  },
  [TARGET_INDEX.CARMEL] = {
    equipSlotNoList = {
      3,
      4,
      5,
      6,
      12
    },
    costumeSlotNoList = {
      14,
      15,
      16,
      17
    },
    pictogramUV = {
      [3] = {
        259,
        87,
        301,
        129
      },
      [4] = {
        259,
        173,
        301,
        215
      },
      [5] = {
        259,
        44,
        301,
        86
      },
      [6] = {
        259,
        130,
        301,
        172
      },
      [12] = {
        259,
        216,
        301,
        258
      },
      [14] = {
        302,
        87,
        344,
        129
      },
      [15] = {
        302,
        173,
        344,
        215
      },
      [16] = {
        302,
        44,
        344,
        86
      },
      [17] = {
        302,
        130,
        344,
        172
      }
    }
  },
  [TARGET_INDEX.TENT] = {
    equipSlotNoList = {
      3,
      4,
      5,
      6
    },
    costumeSlotNoList = {
      14,
      15,
      16,
      17
    },
    pictogramUV = nil
  }
}
local _ampuleSlotConfig = {
  createIcon = true,
  createBorder = true,
  createCount = true,
  createCash = true,
  createEnchant = true
}
function FromClient_luaLoadComplete_DyeingPartList_Init()
  DyeingPartList:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_DyeingPartList_Init")
function DyeingPartList:initialize()
  self._ui.txt_titleTop = UI.getChildControl(self._ui.stc_titleBG, "StaticText_Title_Top")
  self._ui.stc_slotFocus = UI.getChildControl(self._ui.stc_listBG, "Static_Item_Focus")
  for ii = 1, #_targetData do
    self._equipSlotCountMax = math.max(self._equipSlotCountMax, #_targetData[ii].equipSlotNoList)
    self._costumeSlotCountMax = math.max(self._costumeSlotCountMax, #_targetData[ii].costumeSlotNoList)
  end
  for ii = 1, self._equipSlotCountMax do
    self._ui.stc_equipSlotBG[ii] = UI.createAndCopyBasePropertyControl(self._ui.stc_listBG, "Static_EquipBg_Templete", self._ui.stc_listBG, "Static_EquipBg_" .. ii)
    self._ui.stc_equipSlotPictogram[ii] = UI.createAndCopyBasePropertyControl(self._ui.stc_listBG, "Static_Item_Templete", self._ui.stc_equipSlotBG[ii], "Static_EquipPictogram_" .. ii)
    self._ui.slot_equipItem[ii] = {}
    local slot = self._ui.slot_equipItem[ii]
    SlotItem.new(slot, "Slot_EquipItem_" .. ii, ii, self._ui.stc_equipSlotBG[ii], _ampuleSlotConfig)
    slot:createChild()
    slot.icon:SetHorizonCenter()
    slot.icon:SetVerticalMiddle()
    slot.icon:SetIgnore(true)
  end
  for ii = 1, self._costumeSlotCountMax do
    self._ui.stc_costumeSlotBG[ii] = UI.createAndCopyBasePropertyControl(self._ui.stc_listBG, "Static_CostumeBg_Templete", self._ui.stc_listBG, "Static_CostumeBg_" .. ii)
    self._ui.stc_costumeSlotPictogram[ii] = UI.createAndCopyBasePropertyControl(self._ui.stc_listBG, "Static_Item_Templete", self._ui.stc_costumeSlotBG[ii], "Static_CostumePictogram_" .. ii)
    self._ui.slot_costumeItem[ii] = {}
    local slot = self._ui.slot_costumeItem[ii]
    SlotItem.new(slot, "Slot_EquipItem_" .. ii, ii, self._ui.stc_costumeSlotBG[ii], _ampuleSlotConfig)
    slot:createChild()
    slot.icon:SetHorizonCenter()
    slot.icon:SetVerticalMiddle()
    slot.icon:SetIgnore(true)
  end
  _panel:registerPadEvent(__eConsoleUIPadEvent_LT, "Input_DyeingMain_PressedLT()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_LT, "Input_DyeingMain_ReleasedLT()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LTPress_Y, "PaGlobalFunc_Dyeing_ChangeWeather()")
end
function PaGlobalFunc_DyeingPartList_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_DyeingPartList_Open(index)
  DyeingPartList:open(index)
end
function DyeingPartList:open(index)
  self._ui.txt_keyGuideA:SetShow(false == PaGlobalFunc_DyeingPalette_GetShow())
  _panel:SetShow(true)
  if self._currentTargetIndex ~= index then
    PaGlobalFunc_DyeingPalette_CleanData()
  end
  self._currentTargetIndex = index
  self:update()
end
function PaGlobalFunc_DyeingPartList_Close()
  DyeingPartList:close()
end
function DyeingPartList:close()
  _panel:SetShow(false)
end
function DyeingPartList:update()
  local targetData = _targetData[self._currentTargetIndex]
  if nil == targetData or nil == targetData.equipSlotNoList then
    return
  end
  local equipSlotCount = #targetData.equipSlotNoList
  for ii = 1, equipSlotCount do
    local slotNo = targetData.equipSlotNoList[ii]
    self._ui.stc_equipSlotBG[ii]:SetShow(true)
    self._ui.stc_equipSlotBG[ii]:SetPosX(self._startX + (ii - 1) % self._columnMax * self._defaultGap)
    self._ui.stc_equipSlotBG[ii]:SetPosY(self._startY + math.floor((ii - 1) / self._columnMax) * self._defaultGap)
    local itemWrapper = ToClient_RequestGetDyeingTargetItemWrapper(slotNo)
    local pictogram = self._ui.stc_equipSlotPictogram[ii]
    local slot = self._ui.slot_equipItem[ii]
    slot:clearItem()
    if nil ~= itemWrapper then
      slot:setItem(itemWrapper, slotNo)
      slot.icon:SetMonoTone(not itemWrapper:isDyeable())
      self._ui.stc_equipSlotBG[ii]:addInputEvent("Mouse_LUp", "Input_DyeingPartList_SelectEquip( " .. slotNo .. ")")
      pictogram:SetShow(false)
    else
      self._ui.stc_equipSlotBG[ii]:removeInputEvent("Mouse_LUp")
      if nil ~= targetData.pictogramUV then
        pictogram:SetShow(true)
        pictogram:ChangeTextureInfoName("renewal/ui_icon/console_icon_equip.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(pictogram, targetData.pictogramUV[slotNo][1], targetData.pictogramUV[slotNo][2], targetData.pictogramUV[slotNo][3], targetData.pictogramUV[slotNo][4])
        pictogram:getBaseTexture():setUV(x1, y1, x2, y2)
        pictogram:setRenderTexture(pictogram:getBaseTexture())
      else
        pictogram:SetShow(false)
      end
    end
  end
  if nil == targetData.costumeSlotNoList then
    return
  end
  for ii = 1, #targetData.costumeSlotNoList do
    local slotNo = targetData.costumeSlotNoList[ii]
    self._ui.stc_costumeSlotBG[ii]:SetShow(true)
    self._ui.stc_costumeSlotBG[ii]:SetPosX(self._startX + (ii + equipSlotCount - 1) % self._columnMax * self._defaultGap)
    self._ui.stc_costumeSlotBG[ii]:SetPosY(self._startY + math.floor((ii + equipSlotCount - 1) / self._columnMax) * self._defaultGap)
    local itemWrapper = ToClient_RequestGetDyeingTargetItemWrapper(slotNo)
    local pictogram = self._ui.stc_costumeSlotPictogram[ii]
    local slot = self._ui.slot_costumeItem[ii]
    slot:clearItem()
    if nil ~= itemWrapper then
      slot:setItem(itemWrapper, slotNo)
      slot.icon:SetMonoTone(not itemWrapper:isDyeable())
      self._ui.stc_costumeSlotBG[ii]:addInputEvent("Mouse_LUp", "Input_DyeingPartList_SelectEquip( " .. slotNo .. ")")
      pictogram:SetShow(false)
    else
      self._ui.stc_costumeSlotBG[ii]:removeInputEvent("Mouse_LUp")
      if nil ~= targetData.pictogramUV then
        pictogram:SetShow(true)
        pictogram:ChangeTextureInfoName("renewal/ui_icon/console_icon_equip.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(pictogram, targetData.pictogramUV[slotNo][1], targetData.pictogramUV[slotNo][2], targetData.pictogramUV[slotNo][3], targetData.pictogramUV[slotNo][4])
        pictogram:getBaseTexture():setUV(x1, y1, x2, y2)
        pictogram:setRenderTexture(pictogram:getBaseTexture())
      else
        pictogram:SetShow(false)
      end
    end
  end
  for ii = equipSlotCount + 1, #self._ui.slot_equipItem do
    self._ui.stc_equipSlotBG[ii]:SetShow(false)
  end
  for ii = #targetData.costumeSlotNoList + 1, #self._ui.slot_costumeItem do
    self._ui.stc_costumeSlotBG[ii]:SetShow(false)
  end
  local lastSlot = self._ui.stc_costumeSlotBG[#targetData.costumeSlotNoList]
  self._ui.txt_keyGuideA:SetPosY(lastSlot:GetParentPosY() + 70)
end
function Input_DyeingPartList_SelectEquip(slotNo)
  local self = DyeingPartList
  PaGlobalFunc_DyeingPalette_Open(TARGET_TYPE_ENUM[self._currentTargetIndex], slotNo)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  ToClient_padSnapSetTargetPanel(Panel_Window_DyeingPalette_Renew)
end
