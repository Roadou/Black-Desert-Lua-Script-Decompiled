Panel_BossAlert_SettingV2:SetShow(false)
Panel_BossAlert_SettingV2:RegisterShowEventFunc(true, "PaGlobal_BossAlertSet_ShowAni()")
Panel_BossAlert_SettingV2:RegisterShowEventFunc(false, "PaGlobal_BossAlertSet_HideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local PaGlobal_BossAlertSet = {
  _ui = {
    btnClose = UI.getChildControl(Panel_BossAlert_SettingV2, "Button_CloseIcon"),
    checkPopUp = UI.getChildControl(Panel_BossAlert_SettingV2, "CheckButton_PopUp"),
    alertOnOffBG = UI.getChildControl(Panel_BossAlert_SettingV2, "Static_AlertOnOffBg"),
    alertBG = UI.getChildControl(Panel_BossAlert_SettingV2, "Static_AlertBg"),
    btn_Setting = UI.getChildControl(Panel_BossAlert_SettingV2, "Button_Setting"),
    btn_BossTime = UI.getChildControl(Panel_BossAlert_SettingV2, "Button_BossTime"),
    bottomDescBG = UI.getChildControl(Panel_BossAlert_SettingV2, "Static_BottomBg"),
    alertKeepBG = UI.getChildControl(Panel_BossAlert_SettingV2, "Static_AlertKeep"),
    alertON = nil,
    alertOFF = nil,
    allAlert_30m = nil,
    allAlert_15m = nil,
    allAlert_5m = nil,
    txt_BottomDesc = nil
  },
  savedPoint1 = 0,
  savedPoint2 = 0,
  savedPoint3 = 0,
  savedPoint4 = 0,
  savedPointSum = 0,
  returnValue = false,
  updateTime = 0,
  bossRaidCount = 0,
  currentNation = 0,
  bossRaidTime = -1,
  weekly = 0
}
local nation = {
  _korea = 1,
  _japan = 2,
  _russia = 3,
  _notrhAmerica = 4,
  _europe = 5,
  _taiwan = 6,
  _turkey = 7,
  _southAmerica = 8,
  _thailand = 9,
  _southeastAsia = 10,
  _koreaTeen = 11
}
local bossNo = {
  _kzaka = 1,
  _karanda = 2,
  _nuver = 3,
  _kutum = 4,
  _opin = 5,
  _gamos = 6,
  _guint = 7,
  _muraka = 8,
  _vell = 9
}
local bossName = {
  [bossNo._kzaka] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSALERT_SETTING_KZAKA"),
  [bossNo._karanda] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSALERT_SETTING_KARANDA"),
  [bossNo._nuver] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSALERT_SETTING_NUVER"),
  [bossNo._kutum] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSALERT_SETTING_KUTUM"),
  [bossNo._opin] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSALERT_SETTING_OPIN"),
  [bossNo._gamos] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSALERT_SETTING_GAMOS"),
  [bossNo._guint] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSALERT_SETTING_GUINT"),
  [bossNo._muraka] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSALERT_SETTING_MURAKA"),
  [bossNo._vell] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSALERT_SETTING_VELL")
}
local PaGlobal_BossAlert = {
  [nation._korea] = {
    _alertTime = {
      {2, 0},
      {11, 0},
      {16, 0},
      {17, 0},
      {19, 0},
      {20, 0},
      {21, 0},
      {23, 15},
      {23, 45},
      {0, 15}
    },
    _bossAppearOrder = {
      {
        {2, 4},
        {1, 3},
        {2, 4},
        {9},
        {0},
        {3, 4},
        {0},
        {0},
        {2},
        {6}
      },
      {
        {1},
        {1, 3},
        {1, 4},
        {0},
        {0},
        {2, 3},
        {0},
        {0},
        {5},
        {0}
      },
      {
        {1},
        {1, 4},
        {1, 3},
        {0},
        {0},
        {2, 4},
        {0},
        {0},
        {6},
        {0}
      },
      {
        {3},
        {0},
        {1, 3},
        {0},
        {0},
        {2, 1},
        {0},
        {7, 8},
        {5},
        {0}
      },
      {
        {4},
        {1, 3},
        {2, 4},
        {0},
        {0},
        {3, 4},
        {0},
        {0},
        {6},
        {0}
      },
      {
        {2},
        {1, 4},
        {2, 3},
        {0},
        {0},
        {1, 4},
        {0},
        {0},
        {5},
        {0}
      },
      {
        {2, 3},
        {3, 4},
        {2, 1},
        {0},
        {7, 8},
        {0},
        {0},
        {0},
        {0},
        {0}
      }
    }
  },
  [nation._japan] = {
    _alertTime = {
      {1, 30},
      {11, 0},
      {14, 0},
      {16, 0},
      {19, 0},
      {20, 0},
      {22, 30},
      {23, 0}
    },
    _bossAppearOrder = {
      {
        {6},
        {2, 4},
        {9},
        {2, 4},
        {6},
        {0},
        {7, 8},
        {5}
      },
      {
        {1, 3},
        {1},
        {0},
        {1, 4},
        {2, 3},
        {0},
        {0},
        {2, 4}
      },
      {
        {1, 3},
        {1},
        {0},
        {4, 1},
        {3, 4},
        {0},
        {0},
        {2, 3}
      },
      {
        {1, 3},
        {0},
        {0},
        {4, 3},
        {2, 1},
        {0},
        {0},
        {6}
      },
      {
        {2, 1},
        {1},
        {0},
        {3, 4},
        {3, 4},
        {0},
        {0},
        {5}
      },
      {
        {2, 1},
        {3},
        {0},
        {4, 3},
        {7, 8},
        {0},
        {0},
        {2, 4}
      },
      {
        {5},
        {1, 3},
        {0},
        {2, 4},
        {1, 2},
        {0},
        {0},
        {0}
      }
    }
  },
  [nation._russia] = {
    _alertTime = {
      {7, 0},
      {11, 0},
      {15, 0},
      {18, 0},
      {19, 0},
      {20, 0},
      {21, 30},
      {23, 0},
      {0, 30}
    },
    _bossAppearOrder = {
      {
        {2},
        {2, 4},
        {9},
        {5},
        {0},
        {0},
        {0},
        {1, 4},
        {3, 2}
      },
      {
        {3},
        {1},
        {1, 3},
        {1, 4},
        {0},
        {0},
        {0},
        {2, 3},
        {5}
      },
      {
        {1, 4},
        {0},
        {1, 4},
        {1, 3},
        {0},
        {0},
        {7, 8},
        {2, 4},
        {3}
      },
      {
        {2, 3},
        {0},
        {1, 4},
        {1, 3},
        {0},
        {0},
        {0},
        {2, 1},
        {0}
      },
      {
        {1},
        {4},
        {1, 3},
        {2, 4},
        {0},
        {0},
        {0},
        {4, 3},
        {0}
      },
      {
        {0},
        {2},
        {1, 4},
        {2, 3},
        {0},
        {0},
        {0},
        {1, 4},
        {3}
      },
      {
        {0},
        {2, 3},
        {7, 8},
        {5},
        {0},
        {0},
        {0},
        {2, 4},
        {3}
      }
    }
  },
  [nation._notrhAmerica] = {
    _alertTime = {
      {7, 0},
      {10, 0},
      {14, 0},
      {17, 0},
      {18, 0},
      {20, 15},
      {22, 15},
      {0, 0},
      {3, 0}
    },
    _bossAppearOrder = {
      {
        {3},
        {1},
        {9},
        {2},
        {0},
        {1, 3},
        {4},
        {2},
        {1}
      },
      {
        {1},
        {3},
        {4},
        {3},
        {0},
        {1},
        {2},
        {4},
        {1}
      },
      {
        {4},
        {5},
        {3},
        {2},
        {0},
        {3, 1},
        {4},
        {2},
        {0}
      },
      {
        {2},
        {3},
        {1},
        {4},
        {0},
        {2, 1},
        {3},
        {4},
        {1}
      },
      {
        {4},
        {3},
        {4},
        {5},
        {0},
        {2},
        {1},
        {3},
        {2}
      },
      {
        {4},
        {2},
        {3},
        {1},
        {0},
        {4, 1},
        {2},
        {5},
        {3}
      },
      {
        {4},
        {3},
        {7, 8},
        {1, 2},
        {0},
        {0},
        {3, 4},
        {1},
        {4}
      }
    }
  },
  [nation._europe] = {
    _alertTime = {
      {9, 0},
      {12, 0},
      {16, 0},
      {19, 0},
      {20, 0},
      {22, 15},
      {0, 15},
      {2, 0},
      {5, 0}
    },
    _bossAppearOrder = {
      {
        {3},
        {1},
        {9},
        {2},
        {0},
        {1, 3},
        {4},
        {2},
        {1}
      },
      {
        {1},
        {3},
        {4},
        {3},
        {0},
        {1},
        {2},
        {4},
        {1}
      },
      {
        {4},
        {5},
        {3},
        {2},
        {0},
        {3},
        {4},
        {2},
        {1}
      },
      {
        {2},
        {0},
        {1},
        {4},
        {0},
        {2, 1},
        {3},
        {4},
        {3}
      },
      {
        {4},
        {3},
        {4},
        {5},
        {0},
        {2},
        {1},
        {3},
        {2}
      },
      {
        {4},
        {2},
        {3},
        {1},
        {0},
        {4, 1},
        {2},
        {5},
        {3}
      },
      {
        {4},
        {3},
        {7, 8},
        {1, 2},
        {0},
        {0},
        {3, 4},
        {1},
        {4}
      }
    }
  },
  [nation._taiwan] = {
    _alertTime = {
      {0, 15},
      {2, 0},
      {11, 0},
      {15, 0},
      {19, 0},
      {20, 0},
      {23, 30}
    },
    _bossAppearOrder = {
      {
        {0},
        {2, 3},
        {1, 3},
        {9},
        {2, 4},
        {0},
        {5}
      },
      {
        {7, 8},
        {1, 4},
        {2},
        {1, 4},
        {6},
        {0},
        {1, 4}
      },
      {
        {0},
        {3},
        {1, 4},
        {2, 3},
        {4},
        {0},
        {1, 3}
      },
      {
        {0},
        {2},
        {1, 3},
        {6},
        {1, 4},
        {0},
        {3, 2}
      },
      {
        {0},
        {4},
        {2, 4},
        {1, 3},
        {3},
        {0},
        {2, 4}
      },
      {
        {0},
        {1, 3},
        {5},
        {2, 3},
        {4, 1},
        {0},
        {7, 8}
      },
      {
        {6},
        {1, 4},
        {2, 4},
        {5},
        {1, 3},
        {0},
        {0}
      }
    }
  },
  [nation._southAmerica] = {
    _alertTime = {
      {2, 0},
      {11, 0},
      {16, 0},
      {18, 0},
      {20, 0},
      {21, 0},
      {23, 30}
    },
    _bossAppearOrder = {
      {
        {3},
        {4, 3},
        {1, 2},
        {9},
        {3, 2},
        {0},
        {5}
      },
      {
        {2, 1},
        {3},
        {4, 1},
        {0},
        {3, 4},
        {0},
        {6}
      },
      {
        {4},
        {1},
        {3, 4},
        {0},
        {1, 2},
        {0},
        {5}
      },
      {
        {1},
        {4, 2},
        {1, 3},
        {0},
        {7, 8},
        {0},
        {6}
      },
      {
        {2, 4},
        {3, 2},
        {4, 1},
        {0},
        {3, 4},
        {0},
        {5}
      },
      {
        {2},
        {3},
        {4, 1},
        {0},
        {3, 1},
        {0},
        {6}
      },
      {
        {1},
        {1, 2},
        {3, 4},
        {0},
        {7, 8},
        {0},
        {0}
      }
    }
  },
  [nation._turkey] = {
    _alertTime = {
      {0, 15},
      {1, 0},
      {11, 0},
      {16, 0},
      {18, 0},
      {19, 0},
      {20, 0},
      {23, 15}
    },
    _bossAppearOrder = {
      {
        {0},
        {2},
        {1, 3},
        {2, 4},
        {9},
        {0},
        {3, 4},
        {6}
      },
      {
        {0},
        {1},
        {1, 3},
        {1, 4},
        {0},
        {0},
        {2, 3},
        {5}
      },
      {
        {0},
        {4},
        {1, 4},
        {2, 3},
        {0},
        {0},
        {7, 8},
        {6}
      },
      {
        {0},
        {2},
        {3, 4},
        {1, 3},
        {0},
        {0},
        {2, 1},
        {5}
      },
      {
        {0},
        {1},
        {1, 3},
        {2, 4},
        {0},
        {0},
        {3, 4},
        {6}
      },
      {
        {0},
        {3},
        {1, 4},
        {3},
        {0},
        {0},
        {1, 4},
        {5}
      },
      {
        {0},
        {2},
        {3, 4},
        {2, 1},
        {0},
        {7, 8},
        {0},
        {0}
      }
    }
  },
  [nation._thailand] = {
    _alertTime = {
      {0, 30},
      {6, 0},
      {10, 0},
      {14, 0},
      {15, 0},
      {19, 0},
      {20, 0},
      {23, 0}
    },
    _bossAppearOrder = {
      {
        {2},
        {4},
        {1, 2},
        {3, 4},
        {9},
        {2},
        {0},
        {3, 4}
      },
      {
        {1},
        {6},
        {0},
        {3},
        {2},
        {1},
        {0},
        {5}
      },
      {
        {3},
        {4},
        {1},
        {4},
        {3},
        {7, 8},
        {0},
        {3, 4}
      },
      {
        {1},
        {0},
        {1},
        {2},
        {0},
        {4},
        {0},
        {5}
      },
      {
        {4},
        {3},
        {1},
        {4},
        {1, 2},
        {6},
        {0},
        {3, 1}
      },
      {
        {1},
        {2},
        {4},
        {1},
        {0},
        {3},
        {0},
        {5}
      },
      {
        {2},
        {3},
        {4, 1},
        {2, 3},
        {6},
        {7, 8},
        {0},
        {0}
      }
    }
  },
  [nation._southeastAsia] = {
    _alertTime = {
      {0, 0},
      {1, 30},
      {7, 0},
      {11, 0},
      {15, 0},
      {16, 0},
      {20, 0}
    },
    _bossAppearOrder = {
      {
        {0},
        {2},
        {4},
        {1, 2},
        {3, 4},
        {9},
        {2}
      },
      {
        {3, 4},
        {1},
        {6},
        {0},
        {3},
        {2},
        {1}
      },
      {
        {5},
        {3},
        {4},
        {1},
        {4},
        {3},
        {7, 8}
      },
      {
        {3, 4},
        {1},
        {0},
        {1},
        {2},
        {0},
        {4}
      },
      {
        {5},
        {4},
        {3},
        {1},
        {4},
        {1, 2},
        {6}
      },
      {
        {1, 3},
        {1},
        {2},
        {4},
        {1},
        {0},
        {3}
      },
      {
        {5},
        {2},
        {3},
        {1, 4},
        {2, 3},
        {6},
        {7, 8}
      }
    }
  },
  [nation._koreaTeen] = {
    _alertTime = {
      {11, 0},
      {14, 0},
      {17, 0},
      {19, 0},
      {21, 0},
      {22, 0},
      {23, 0}
    },
    _bossAppearOrder = {
      {
        {1, 4},
        {2, 1},
        {0},
        {3, 4},
        {1, 3},
        {0},
        {2}
      },
      {
        {0},
        {0},
        {1},
        {3},
        {2, 4},
        {0},
        {5}
      },
      {
        {0},
        {0},
        {3},
        {4},
        {2, 1},
        {0},
        {6}
      },
      {
        {0},
        {0},
        {4},
        {1},
        {2, 3},
        {7, 8},
        {5}
      },
      {
        {0},
        {0},
        {1},
        {3},
        {2, 4},
        {0},
        {6}
      },
      {
        {0},
        {0},
        {3},
        {4},
        {2, 1},
        {0},
        {5}
      },
      {
        {1, 3},
        {3, 4},
        {0},
        {7, 8},
        {2, 4},
        {0},
        {6}
      }
    }
  }
}
function PaGlobal_BossAlertSet:Init()
  self._ui.alertON = UI.getChildControl(self._ui.alertOnOffBG, "RadioButton_AlertOn")
  self._ui.alertOFF = UI.getChildControl(self._ui.alertOnOffBG, "RadioButton_AlertOff")
  self._ui.allAlert_30m = UI.getChildControl(self._ui.alertBG, "Checkbox_30")
  self._ui.allAlert_15m = UI.getChildControl(self._ui.alertBG, "Checkbox_15")
  self._ui.allAlert_5m = UI.getChildControl(self._ui.alertBG, "Checkbox_5")
  self._ui.alertKeep = UI.getChildControl(self._ui.alertKeepBG, "RadioButton_AlertKeep")
  self._ui.alertNone = UI.getChildControl(self._ui.alertKeepBG, "RadioButton_AlertNone")
  self._ui.alertON:SetEnableArea(0, 0, self._ui.alertON:GetSizeX() + self._ui.alertON:GetTextSizeX() + 15, self._ui.alertON:GetSizeY())
  self._ui.alertOFF:SetEnableArea(0, 0, self._ui.alertOFF:GetSizeX() + self._ui.alertOFF:GetTextSizeX() + 15, self._ui.alertOFF:GetSizeY())
  self._ui.allAlert_30m:SetEnableArea(0, 0, self._ui.allAlert_30m:GetSizeX() + self._ui.allAlert_30m:GetTextSizeX() + 15, self._ui.allAlert_30m:GetSizeY())
  self._ui.allAlert_15m:SetEnableArea(0, 0, self._ui.allAlert_15m:GetSizeX() + self._ui.allAlert_15m:GetTextSizeX() + 15, self._ui.allAlert_15m:GetSizeY())
  self._ui.allAlert_5m:SetEnableArea(0, 0, self._ui.allAlert_5m:GetSizeX() + self._ui.allAlert_5m:GetTextSizeX() + 15, self._ui.allAlert_5m:GetSizeY())
  self._ui.alertKeep:SetEnableArea(0, 0, self._ui.alertKeep:GetSizeX() + self._ui.alertKeep:GetTextSizeX() + 15, self._ui.alertKeep:GetSizeY())
  self._ui.alertNone:SetEnableArea(0, 0, self._ui.alertNone:GetSizeX() + self._ui.alertNone:GetTextSizeX() + 15, self._ui.alertNone:GetSizeY())
  self._ui.txt_BottomDesc = UI.getChildControl(self._ui.bottomDescBG, "StaticText_Desc")
  self._ui.btn_Setting:addInputEvent("Mouse_LUp", "PaGlobal_BossAlertSet_SetSetting()")
  self._ui.btn_BossTime:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"WorldBoss\" )")
  self._ui.btnClose:addInputEvent("Mouse_LUp", "PaGlobal_BossAlertSet_Hide()")
  self._ui.allAlert_30m:addInputEvent("Mouse_LUp", "PaGlobal_BossAlertSet_CheckAlert()")
  self._ui.allAlert_15m:addInputEvent("Mouse_LUp", "PaGlobal_BossAlertSet_CheckAlert()")
  self._ui.allAlert_5m:addInputEvent("Mouse_LUp", "PaGlobal_BossAlertSet_CheckAlert()")
  if isGameTypeJapan() then
    self.currentNation = nation._japan
  elseif isGameTypeRussia() then
    self.currentNation = nation._russia
  elseif isGameTypeEnglish() and 0 == getServiceNationType() then
    self.currentNation = nation._notrhAmerica
  elseif isGameTypeEnglish() and 1 == getServiceNationType() then
    self.currentNation = nation._europe
  elseif isGameTypeTaiwan() then
    self.currentNation = nation._taiwan
  elseif isGameTypeSA() then
    self.currentNation = nation._southAmerica
  elseif isGameTypeTH() then
    self.currentNation = nation._thailand
  elseif isGameTypeTR() then
    self.currentNation = nation._turkey
  elseif isGameTypeID() then
    self.currentNation = nation._southeastAsia
  elseif isGameTypeKorea() then
    self.currentNation = nation._korea
  elseif isGameTypeGT() then
    self.currentNation = nation._korea
  elseif _ContentsGroup_RenewUI then
    self.currentNation = nation._notrhAmerica
  else
    self.currentNation = nation._korea
  end
  local isAdult = ToClient_isAdultUser()
  if false == isAdult then
    self.currentNation = nation._koreaTeen
  end
  self._ui.checkPopUp:SetShow(false)
  self._ui.txt_BottomDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_BottomDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BOSSALERTSET_BOTTOMDESC"))
  self._ui.bottomDescBG:SetSize(self._ui.bottomDescBG:GetSizeX(), self._ui.txt_BottomDesc:GetTextSizeY() + 10)
  self._ui.txt_BottomDesc:SetSize(360, self._ui.txt_BottomDesc:GetTextSizeY())
  Panel_BossAlert_SettingV2:SetSize(406, self._ui.alertOnOffBG:GetSizeY() + self._ui.alertBG:GetSizeY() + self._ui.alertKeepBG:GetSizeY() + self._ui.bottomDescBG:GetSizeY() + 100)
  self._ui.bottomDescBG:ComputePos()
  self._ui.txt_BottomDesc:ComputePos()
  if self.currentNation ~= nation._korea and self.currentNation ~= nation._taiwan and self.currentNation ~= nation._thailand and self.currentNation ~= nation._turkey and self.currentNation ~= nation._southeastAsia and self.currentNation ~= nation._southAmerica and self.currentNation ~= nation._japan then
    local _center = Panel_BossAlert_SettingV2:GetSizeX() / 2 - self._ui.btn_Setting:GetSizeX() / 2
    self._ui.btn_Setting:SetSpanSize(0, 16)
    self._ui.btn_BossTime:SetShow(false)
  end
  self.bossRaidCount = #PaGlobal_BossAlert[self.currentNation]._alertTime
  self:SetCheckUpdate()
end
function PaGlobal_BossAlertSet_Show()
  if false == _ContetnsGroup_BossAlert or false == ToClient_IsGrowStepOpen(__eGrowStep_bossAlert) then
    return
  end
  local self = PaGlobal_BossAlertSet
  Panel_BossAlert_SettingV2:SetShow(true, true)
  Panel_BossAlert_SettingV2:SetPosX(getScreenSizeX() / 2 - Panel_BossAlert_SettingV2:GetSizeX() / 2)
  Panel_BossAlert_SettingV2:SetPosY(getScreenSizeY() / 2 - Panel_BossAlert_SettingV2:GetSizeY() / 2)
  local isAlert = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eBossAlertOnOff)
  if 0 == isAlert then
    self._ui.alertON:SetCheck(false)
    self._ui.alertOFF:SetCheck(true)
  else
    self._ui.alertON:SetCheck(true)
    self._ui.alertOFF:SetCheck(false)
  end
  local isAlertKeep = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eBossAlertKeep)
  if 0 == isAlertKeep then
    self._ui.alertKeep:SetCheck(true)
    self._ui.alertNone:SetCheck(false)
  else
    self._ui.alertKeep:SetCheck(false)
    self._ui.alertNone:SetCheck(true)
  end
end
function PaGlobal_BossAlertSet_CheckAlert()
  local self = PaGlobal_BossAlertSet
  if self._ui.allAlert_30m:IsCheck() then
    self.savedPoint2 = 10
  else
    self.savedPoint2 = 0
  end
  if self._ui.allAlert_15m:IsCheck() then
    self.savedPoint3 = 100
  else
    self.savedPoint3 = 0
  end
  if self._ui.allAlert_5m:IsCheck() then
    self.savedPoint4 = 1000
  else
    self.savedPoint4 = 0
  end
  self.savedPointSum = self.savedPoint1 + self.savedPoint2 + self.savedPoint3 + self.savedPoint4
end
function PaGlobal_BossAlertSet_SetSetting()
  local self = PaGlobal_BossAlertSet
  if self._ui.alertOFF:IsCheck() then
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eBossAlertOnOff, 0, CppEnums.VariableStorageType.eVariableStorageType_User)
  elseif self._ui.alertON:IsCheck() then
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eBossAlertOnOff, 1, CppEnums.VariableStorageType.eVariableStorageType_User)
  end
  if self._ui.alertKeep:IsCheck() then
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eBossAlertKeep, 0, CppEnums.VariableStorageType.eVariableStorageType_User)
  elseif self._ui.alertNone:IsCheck() then
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eBossAlertKeep, 1, CppEnums.VariableStorageType.eVariableStorageType_User)
  end
  PaGlobal_BossAlertSet_SetTime()
  PaGlobal_BossAlertSet_Hide()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BOSSALERT_SET_CONFIRM"))
end
function PaGlobal_BossAlertSet_SetTime()
  local self = PaGlobal_BossAlertSet
  local isCheckCount = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eBossAlertTime)
  if self.savedPointSum ~= isCheckCount then
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eBossAlertTime, self.savedPointSum, CppEnums.VariableStorageType.eVariableStorageType_User)
  end
end
function PaGlobal_BossAlertSet_ReturnTimeBeforeAlert()
  local self = PaGlobal_BossAlertSet
  local bossTime = "unknown"
  local currentHour = tonumber(os.date("%H"))
  local currentMinute = tonumber(os.date("%M"))
  local alertEnd = false
  local lastMinute = 0
  self.bossRaidTime = -1
  self.weekly = tonumber(os.date("*t").wday)
  for ii = 1, self.bossRaidCount do
    local bossHour = PaGlobal_BossAlert[self.currentNation]._alertTime[ii][1]
    if 23 == currentHour and 0 == bossHour then
      if 0 == self.weekly % 7 then
        self.weekly = 1
      else
        self.weekly = self.weekly % 7 + 1
      end
    else
      self.weekly = tonumber(os.date("*t").wday)
    end
    if 0 == bossHour and 0 ~= currentHour then
      bossHour = 24
    end
    local bossMinute = PaGlobal_BossAlert[self.currentNation]._alertTime[ii][2]
    lastMinute = (bossHour - currentHour) * 60 + bossMinute - currentMinute
    if 0 == lastMinute then
      bossTime = ""
      self.bossRaidTime = ii
      break
    end
    if 30 == lastMinute and self._ui.allAlert_30m:IsCheck() or 15 == lastMinute and self._ui.allAlert_15m:IsCheck() or 5 == lastMinute and self._ui.allAlert_5m:IsCheck() then
      bossTime = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSALERT_SETTING_BEFORE" .. lastMinute)
      self.bossRaidTime = ii
      break
    end
  end
  if -1 == self.bossRaidTime then
    return bossTime
  end
  local bossName = PaGlobal_BossAlertSet_ReturnNameAlert()
  return bossTime, bossName, lastMinute
end
function PaGlobal_BossAlertSet_ReturnTimeAfterAlertEnd()
  if not Panel_BossAlertV2:GetShow() then
    return
  end
  local self = PaGlobal_BossAlertSet
  local currentHour = tonumber(os.date("%H"))
  local currentMinute = tonumber(os.date("%M"))
  for ii = 1, self.bossRaidCount do
    local bossHour = PaGlobal_BossAlert[self.currentNation]._alertTime[ii][1]
    local bossMinute = PaGlobal_BossAlert[self.currentNation]._alertTime[ii][2] + 30
    if bossMinute >= 60 then
      bossMinute = bossMinute - 60
      bossHour = bossHour + 1
      if 24 == bossHour then
        bossHour = 0
      end
    end
    if currentHour == bossHour and currentMinute == bossMinute then
      PaGlobal_BossAlert_NewAlarmClose()
    end
  end
end
function PaGlobal_BossAlertSet_ReturnNameAlert()
  local self = PaGlobal_BossAlertSet
  local rv = ""
  if 0 == PaGlobal_BossAlert[self.currentNation]._bossAppearOrder[self.weekly][self.bossRaidTime][1] then
    return rv
  else
    for ii = 1, #PaGlobal_BossAlert[self.currentNation]._bossAppearOrder[self.weekly][self.bossRaidTime] do
      if "" == rv then
        rv = bossName[PaGlobal_BossAlert[self.currentNation]._bossAppearOrder[self.weekly][self.bossRaidTime][1]]
      else
        rv = rv .. ", " .. bossName[PaGlobal_BossAlert[self.currentNation]._bossAppearOrder[self.weekly][self.bossRaidTime][ii]]
      end
    end
    return rv
  end
end
function PaGlobal_BossAlertSet:SetCheckUpdate()
  local isCheckCount = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eBossAlertTime)
  if 1110 == isCheckCount then
    self._ui.allAlert_30m:SetCheck(true)
    self._ui.allAlert_15m:SetCheck(true)
    self._ui.allAlert_5m:SetCheck(true)
  elseif 1100 == isCheckCount then
    self._ui.allAlert_30m:SetCheck(false)
    self._ui.allAlert_15m:SetCheck(true)
    self._ui.allAlert_5m:SetCheck(true)
  elseif 1010 == isCheckCount then
    self._ui.allAlert_30m:SetCheck(true)
    self._ui.allAlert_15m:SetCheck(false)
    self._ui.allAlert_5m:SetCheck(true)
  elseif 110 == isCheckCount then
    self._ui.allAlert_30m:SetCheck(true)
    self._ui.allAlert_15m:SetCheck(true)
    self._ui.allAlert_5m:SetCheck(false)
  else
    self._ui.allAlert_30m:SetCheck(10 == isCheckCount)
    self._ui.allAlert_15m:SetCheck(100 == isCheckCount)
    self._ui.allAlert_5m:SetCheck(1000 == isCheckCount)
  end
  PaGlobal_BossAlertSet_CheckAlert()
end
function PaGlobal_BossAlertSet_PopUp()
  local self = PaGlobal_BossAlertSet
  if self._ui.checkPopUp:IsCheck() then
    Panel_BossAlert_SettingV2:OpenUISubApp()
  else
    Panel_BossAlert_SettingV2:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function PaGlobal_BossAlertSet_Hide()
  local self = PaGlobal_BossAlertSet
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  Panel_BossAlert_SettingV2:SetShow(false, false)
end
function PaGlobal_BossAlertSet_ReturnKeep()
  local self = PaGlobal_BossAlertSet
  local isAlertKeep = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eBossAlertKeep)
  if 0 == isAlertKeep then
    isAlertKeep = true
  else
    isAlertKeep = false
  end
  return isAlertKeep
end
function PaGlobal_BossAlertSet_PopUp_ShowIconToolTip(isShow)
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_BossAlertSet_GetIsShowBossAlert()
  if false == _ContetnsGroup_BossAlert then
    return false
  end
  if false == ToClient_IsGrowStepOpen(__eGrowStep_bossAlert) then
    return false
  end
  local onoffSetting = __eBossAlertOnOff
  if nil == __eBossAlertOnOff then
    onoffSetting = 65
  end
  if 0 == ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(onoffSetting) then
    return false
  end
  return true
end
function PaGlobal_BossAlertSet_ShowAni()
  audioPostEvent_SystemUi(0, 22)
  _AudioPostEvent_SystemUiForXBOX(0, 22)
  UIAni.fadeInSCR_Down(Panel_BossAlert_SettingV2)
  local aniInfo1 = Panel_BossAlert_SettingV2:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.2)
  aniInfo1.AxisX = Panel_BossAlert_SettingV2:GetSizeX() / 2
  aniInfo1.AxisY = Panel_BossAlert_SettingV2:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_BossAlert_SettingV2:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.2)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_BossAlert_SettingV2:GetSizeX() / 2
  aniInfo2.AxisY = Panel_BossAlert_SettingV2:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function PaGlobal_BossAlertSet_HideAni()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  Panel_BossAlert_SettingV2:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_BossAlert_SettingV2, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
PaGlobal_BossAlertSet:Init()
