Panel_Window_PetRegister_Renew:ignorePadSnapMoveToOtherPanel()
Panel_Window_PetRegister_Renew:SetShow(false)
local petRegister = {
  _ui = {
    _static_subFrameBG = UI.getChildControl(Panel_Window_PetRegister_Renew, "Static_SubFrameBG"),
    _static_BottomKeyBG = UI.getChildControl(Panel_Window_PetRegister_Renew, "Static_BottomKeyBG"),
    _static_MainTitleBG = UI.getChildControl(Panel_Window_PetRegister_Renew, "Static_MainTitleBG")
  },
  _config = {
    _defaultPetNameCount = 10,
    _defaultPetName = {
      [0] = "Darcy",
      [1] = "Buddy",
      [2] = "Orbit",
      [3] = "Rushmore",
      [4] = "Carolina",
      [5] = "Cindy",
      [6] = "Waffles",
      [7] = "Sparky",
      [8] = "Bailey",
      [9] = "Wichita",
      [10] = "Buck"
    },
    _ButtonGap = 50
  },
  _fromWhereType = -1,
  _fromSlotNo = -1
}
function petRegister:initControl()
  local petRegisterUI = self._ui
  petRegisterUI._staticText_RegisterDesc = UI.getChildControl(petRegisterUI._static_subFrameBG, "StaticText_RegisterDesc")
  petRegisterUI._static_PetIconSlot = UI.getChildControl(petRegisterUI._static_subFrameBG, "Static_PetIconSlot")
  petRegisterUI._static_PetIcon = UI.getChildControl(petRegisterUI._static_PetIconSlot, "Static_PetIcon")
  petRegisterUI._edit_Search = UI.getChildControl(petRegisterUI._static_subFrameBG, "Edit_Search")
  petRegisterUI._static_horizontalLine2 = UI.getChildControl(petRegisterUI._static_subFrameBG, "Static_HorizontalLine2")
  petRegisterUI._static_horizontalLine3 = UI.getChildControl(petRegisterUI._static_subFrameBG, "Static_HorizontalLine3")
  petRegisterUI._staticText_Confirm_ConsoleUI = UI.getChildControl(petRegisterUI._static_BottomKeyBG, "StaticText_Confirm_ConsoleUI")
  petRegisterUI._staticText_Cancel_ConsoleUI = UI.getChildControl(petRegisterUI._static_BottomKeyBG, "StaticText_Cancel_ConsoleUI")
  petRegisterUI._staticText_ChangeName_ConsoleUI = UI.getChildControl(petRegisterUI._static_BottomKeyBG, "StaticText_ChangeName_ConsoleUI")
  local xPos = petRegisterUI._staticText_Cancel_ConsoleUI:GetPosX() - petRegisterUI._staticText_Confirm_ConsoleUI:GetTextSizeX() - self._config._ButtonGap
  petRegisterUI._staticText_Confirm_ConsoleUI:SetPosX(xPos)
  xPos = xPos - petRegisterUI._staticText_ChangeName_ConsoleUI:GetTextSizeX() - self._config._ButtonGap
  petRegisterUI._staticText_ChangeName_ConsoleUI:SetPosX(xPos)
  Panel_Window_PetRegister_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_A, "FGlobal_PetRegister_Confirm()")
  Panel_Window_PetRegister_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_X, "FGlobal_PetRegister_ChangeName()")
  petRegisterUI._edit_Search:setXboxVirtualKeyBoardEndEvent("Input_PetRegisterName_KeyboardEnd")
  petRegisterUI._edit_Search:RegistReturnKeyEvent("FGlobal_PetRegister_Confirm()")
end
function petRegister:setPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_Window_PetRegister_Renew:GetSizeX()
  local panelSizeY = Panel_Window_PetRegister_Renew:GetSizeY()
  Panel_Window_PetRegister_Renew:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Panel_Window_PetRegister_Renew:SetPosY(scrSizeY / 2 - panelSizeY / 2)
end
function petRegister:open()
  self._fromWhereType = -1
  self._fromSlotNo = -1
  if true == Panel_Window_PetRegister_Renew:GetShow() then
    Panel_Window_PetRegister_Renew:SetShow(false)
    return
  end
  self:setPosition()
  Panel_Window_PetRegister_Renew:SetShow(true)
  PaGlobalFunc_InventoryInfo_Close()
end
function petRegister:close()
  local petRegisterUI = self._ui
  if not Panel_Window_PetRegister_Renew:GetShow() then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  Panel_Window_PetRegister_Renew:SetShow(false)
  ClearFocusEdit()
end
function petRegister:initialize()
  local petRegisterUI = self._ui
  local UI_TM = CppEnums.TextMode
  petRegisterUI._edit_Search:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_EDITBOX_COMMENT"), true)
  if isGameTypeEnglish() or isGameTypeTaiwan() or isGameTypeTR() or isGameTypeTH() or isGameTypeID() then
    petRegisterUI._static_PetIconSlot:SetTextMode(UI_TM.eTextMode_AutoWrap)
  end
  if isGameTypeEnglish() or isGameTypeTaiwan() then
    petRegisterUI._static_PetIconSlot:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_EN"))
  elseif isGameTypeTR() then
    petRegisterUI._static_PetIconSlot:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_TR"))
  elseif isGameTypeTH() then
    petRegisterUI._static_PetIconSlot:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_TH"))
  elseif isGameTypeID() then
    petRegisterUI._static_PetIconSlot:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_ID"))
  end
  petRegisterUI._staticText_RegisterDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  petRegisterUI._staticText_RegisterDesc:SetText(petRegisterUI._staticText_RegisterDesc:GetText())
  if petRegisterUI._staticText_RegisterDesc:GetTextSizeY() > petRegisterUI._staticText_RegisterDesc:GetSizeY() then
    local tempSizeX = petRegisterUI._staticText_RegisterDesc:GetTextSizeY() - petRegisterUI._staticText_RegisterDesc:GetSizeY()
    Panel_Window_PetRegister_Renew:SetSize(Panel_Window_PetRegister_Renew:GetSizeX(), Panel_Window_PetRegister_Renew:GetSizeY() + tempSizeX)
    petRegisterUI._static_subFrameBG:SetSize(petRegisterUI._static_subFrameBG:GetSizeX(), petRegisterUI._static_subFrameBG:GetSizeY() + tempSizeX)
    petRegisterUI._static_PetIconSlot:ComputePos()
    petRegisterUI._edit_Search:ComputePos()
    petRegisterUI._static_horizontalLine3:ComputePos()
    petRegisterUI._static_BottomKeyBG:ComputePos()
    Panel_Window_PetRegister_Renew:ComputePos()
    petRegisterUI._static_horizontalLine2:SetPosY(petRegisterUI._static_horizontalLine2:GetPosY() + tempSizeX)
  end
  local tempBtnGroup = {
    petRegisterUI._staticText_Confirm_ConsoleUI,
    petRegisterUI._staticText_ChangeName_ConsoleUI,
    petRegisterUI._staticText_Cancel_ConsoleUI
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, petRegisterUI._static_BottomKeyBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_CENTER)
end
function petRegister:resetData()
  self._fromWhereType = -1
  self._fromSlotNo = -1
  petRegisterUI._edit_Search:SetEditText("", true)
end
function Input_PetRegisterName_KeyboardEnd(str)
  petRegister._ui._edit_Search:SetEditText(str)
  ClearFocusEdit()
  HandleClicked_PetRegister_Register()
end
function FGlobal_PetRegister_Confirm()
  HandleClicked_PetRegister_Register()
end
function PaGlobalFunc_PetRegister_Cancle()
  ClearFocusEdit()
  PaGlobalFunc_InventoryInfo_Open()
  petRegister:close()
end
function FGlobal_PetRegister_ChangeName()
  local petRegisterUI = petRegister._ui
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  if true == petRegisterUI._edit_Search:GetFocusEdit() then
    return
  else
    petRegisterUI._edit_Search:SetMaxInput(getGameServiceTypePetNameLength())
    SetFocusEdit(petRegisterUI._edit_Search)
    petRegisterUI._edit_Search:SetEditText("", true)
  end
end
function petRegister:clearEdit()
  local petRegisterUI = self._ui
  petRegisterUI._edit_Search:SetEditText("", false)
  SetFocusEdit(petRegisterUI._edit_Search)
end
function petRegister:setRegistInfo(fromWhereType, fromSlotNo)
  local petRegisterUI = self._ui
  self._fromWhereType = fromWhereType
  self._fromSlotNo = fromSlotNo
  local petNaming = petRegisterUI._edit_Search
  local petName = petNaming:GetEditText()
  local itemWrapper = getInventoryItemByType(fromWhereType, fromSlotNo)
  if nil == itemWrapper then
    return
  end
  local characterKey = itemWrapper:getStaticStatus():get()._contentsEventParam1
  local petRegisterPSS = ToClient_getPetStaticStatus(characterKey)
  local petIconPath = petRegisterPSS:getIconPath()
  petRegisterUI._static_PetIcon:ChangeTextureInfoNameAsync(petIconPath)
  petRegisterUI._static_PetIcon:SetShow(true)
  local randomIndex = math.floor(math.random(0, self._config._defaultPetNameCount - 1))
  petNaming:SetEditText(self._config._defaultPetName[randomIndex], true)
  petNaming:SetMaxInput(getGameServiceTypePetNameLength())
end
function FromClient_InputPetName_Renew(fromWhereType, fromSlotNo)
  petRegister:open()
  petRegister:setRegistInfo(fromWhereType, fromSlotNo)
end
function HandleClicked_PetRegister_Register()
  local petNaming = petRegister._ui._edit_Search
  local petName = petNaming:GetEditText()
  ClearFocusEdit()
  local function confirm_Regist()
    local fromWhereType = petRegister._fromWhereType
    local fromSlotNo = petRegister._fromSlotNo
    ToClient_requestPetRegister(petName, fromWhereType, fromSlotNo)
    petRegister:close()
  end
  local cancle_Regist = function()
    Panel_Window_PetRegister_Renew:SetShow(true)
  end
  Panel_Window_PetRegister_Renew:SetShow(false)
  local messageBoxMemo = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_REGISTPET_CONTINUE")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "PET_FUNCTION_REGISTERPET"),
    content = messageBoxMemo,
    functionYes = confirm_Regist,
    functionNo = cancle_Regist,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FromClient_luaLoadComplete_PetRegister()
  petRegister:initControl()
  petRegister:initialize()
end
function FromClient_PetAddSealedList(petNo, reason, petType)
  if reason == nil then
    return
  end
  if reason == 1 then
    if petType == __ePetType_Normal then
      FGlobal_PetList_Open()
    else
      return
    end
  end
end
function petRegister:registEventHandler()
  registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_PetRegister")
  registerEvent("FromClient_PetAddSealedList", "FromClient_PetAddSealedList")
  registerEvent("FromClient_InputPetName", "FromClient_InputPetName_Renew")
end
function FGlobal_EscapeEditBox_PetCompose(bool)
  ClearFocusEdit()
end
petRegister:registEventHandler()
