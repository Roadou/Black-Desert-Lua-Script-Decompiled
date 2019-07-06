Panel_Window_PetCompose:SetShow(false)
Panel_Window_PetCompose:setGlassBackground(true)
Panel_Window_PetCompose:ActiveMouseEventEffect(true)
local composableCheck = false
local petComposeNo = {
  [0] = nil,
  [1] = nil
}
local composePetTier = 0
local petCompose = {
  icon_1 = UI.getChildControl(Panel_Window_PetCompose, "Static_Icon_1"),
  icon_2 = UI.getChildControl(Panel_Window_PetCompose, "Static_Icon_2"),
  icon_3 = UI.getChildControl(Panel_Window_PetCompose, "Static_Icon_3"),
  defaultIcon_1 = UI.getChildControl(Panel_Window_PetCompose, "StaticText_DefautPetIcon_1"),
  defaultIcon_2 = UI.getChildControl(Panel_Window_PetCompose, "StaticText_DefautPetIcon_2"),
  icon_question = UI.getChildControl(Panel_Window_PetCompose, "StaticText_QuestionMark"),
  editName = UI.getChildControl(Panel_Window_PetCompose, "Edit_Naming"),
  desc = UI.getChildControl(Panel_Window_PetCompose, "StaticText_Desc"),
  descBg = UI.getChildControl(Panel_Window_PetCompose, "Static_DescBg"),
  btn_Yes = UI.getChildControl(Panel_Window_PetCompose, "Button_Yes"),
  btn_No = UI.getChildControl(Panel_Window_PetCompose, "Button_No"),
  btn_Question = UI.getChildControl(Panel_Window_PetCompose, "Button_Question"),
  btn_Close = UI.getChildControl(Panel_Window_PetCompose, "Button_Close"),
  radioBtn_PetSkill_1 = UI.getChildControl(Panel_Window_PetCompose, "RadioButton_Skill_1"),
  radioBtn_PetSkill_2 = UI.getChildControl(Panel_Window_PetCompose, "RadioButton_Skill_2"),
  radioBtn_PetSkill_3 = UI.getChildControl(Panel_Window_PetCompose, "RadioButton_Skill_3"),
  radioBtn_PetLook_1 = UI.getChildControl(Panel_Window_PetCompose, "RadioButton_Look_1"),
  radioBtn_PetLook_2 = UI.getChildControl(Panel_Window_PetCompose, "RadioButton_Look_2"),
  radioBtn_PetLook_3 = UI.getChildControl(Panel_Window_PetCompose, "RadioButton_Look_3"),
  skillSlotBg = {
    [1] = {
      [1] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillSlotBg_1_1"),
      [2] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillSlotBg_1_2"),
      [3] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillSlotBg_1_3")
    },
    [2] = {
      [1] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillSlotBg_2_1"),
      [2] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillSlotBg_2_2"),
      [3] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillSlotBg_2_3")
    },
    [3] = {
      [1] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillSlotBg_3_1"),
      [2] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillSlotBg_3_2"),
      [3] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillSlotBg_3_3")
    }
  },
  skillDefaultIcon = {
    [1] = {
      [1] = UI.getChildControl(Panel_Window_PetCompose, "Static_DefaultSkillIcon_1_1"),
      [2] = UI.getChildControl(Panel_Window_PetCompose, "Static_DefaultSkillIcon_1_2"),
      [3] = UI.getChildControl(Panel_Window_PetCompose, "Static_DefaultSkillIcon_1_3")
    },
    [2] = {
      [1] = UI.getChildControl(Panel_Window_PetCompose, "Static_DefaultSkillIcon_2_1"),
      [2] = UI.getChildControl(Panel_Window_PetCompose, "Static_DefaultSkillIcon_2_2"),
      [3] = UI.getChildControl(Panel_Window_PetCompose, "Static_DefaultSkillIcon_2_3")
    },
    [3] = {
      [1] = UI.getChildControl(Panel_Window_PetCompose, "Static_DefaultSkillIcon_3_1"),
      [2] = UI.getChildControl(Panel_Window_PetCompose, "Static_DefaultSkillIcon_3_2"),
      [3] = UI.getChildControl(Panel_Window_PetCompose, "Static_DefaultSkillIcon_3_3")
    }
  },
  skillSlot = {
    [1] = {
      [1] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillPetSlot_1_1"),
      [2] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillPetSlot_1_2"),
      [3] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillPetSlot_1_3")
    },
    [2] = {
      [1] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillPetSlot_2_1"),
      [2] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillPetSlot_2_2"),
      [3] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillPetSlot_2_3")
    },
    [3] = {
      [1] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillPetSlot_3_1"),
      [2] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillPetSlot_3_2"),
      [3] = UI.getChildControl(Panel_Window_PetCompose, "Static_SkillPetSlot_3_3")
    }
  },
  skillNoList = {
    [0] = nil,
    nil,
    nil,
    nil,
    nil,
    nil
  },
  preserveSkillNo = nil,
  petComposeNo = {
    [1] = nil,
    nil
  },
  race = nil,
  isJokerPetUse = false
}
petCompose.radioBtn_PetSkill_1:addInputEvent("Mouse_LUp", "PetCompose_UpdatePetSkillList()")
petCompose.radioBtn_PetSkill_2:addInputEvent("Mouse_LUp", "PetCompose_UpdatePetSkillList()")
petCompose.radioBtn_PetSkill_3:addInputEvent("Mouse_LUp", "PetCompose_UpdatePetSkillList()")
petCompose.radioBtn_PetSkill_1:addInputEvent("Mouse_On", "PetCompose_Simpletooltips(true, 0)")
petCompose.radioBtn_PetSkill_1:addInputEvent("Mouse_Out", "PetCompose_Simpletooltips(false)")
petCompose.radioBtn_PetSkill_2:addInputEvent("Mouse_On", "PetCompose_Simpletooltips(true, 1)")
petCompose.radioBtn_PetSkill_2:addInputEvent("Mouse_Out", "PetCompose_Simpletooltips(false)")
petCompose.radioBtn_PetSkill_3:addInputEvent("Mouse_On", "PetCompose_Simpletooltips(true, 2)")
petCompose.radioBtn_PetSkill_3:addInputEvent("Mouse_Out", "PetCompose_Simpletooltips(false)")
petCompose.radioBtn_PetLook_1:addInputEvent("Mouse_LUp", "PetCompose_UpdatePetSkillList()")
petCompose.radioBtn_PetLook_2:addInputEvent("Mouse_LUp", "PetCompose_UpdatePetSkillList()")
petCompose.radioBtn_PetLook_3:addInputEvent("Mouse_LUp", "PetCompose_UpdatePetSkillList()")
petCompose.radioBtn_PetLook_1:addInputEvent("Mouse_On", "PetCompose_Simpletooltips(true, 3)")
petCompose.radioBtn_PetLook_1:addInputEvent("Mouse_Out", "PetCompose_Simpletooltips(false)")
petCompose.radioBtn_PetLook_2:addInputEvent("Mouse_On", "PetCompose_Simpletooltips(true, 4)")
petCompose.radioBtn_PetLook_2:addInputEvent("Mouse_Out", "PetCompose_Simpletooltips(false)")
petCompose.radioBtn_PetLook_3:addInputEvent("Mouse_On", "PetCompose_Simpletooltips(true, 5)")
petCompose.radioBtn_PetLook_3:addInputEvent("Mouse_Out", "PetCompose_Simpletooltips(false)")
petCompose.btn_Question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"Pet\" )")
petCompose.btn_Question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"Pet\", \"true\")")
petCompose.btn_Question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"Pet\", \"false\")")
petCompose.btn_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetCompose_Close()")
petCompose.btn_Yes:addInputEvent("Mouse_LUp", "Confirm_PetCompose()")
petCompose.btn_No:addInputEvent("Mouse_LUp", "Panel_Window_PetCompose_Close()")
petCompose.editName:addInputEvent("Mouse_LUp", "HandleClicked_PetCompose_ClearEdit()")
local petComposeString = PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_NAME")
local petComposeDesc = PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_DESC")
petCompose.desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
if petCompose.desc ~= nil then
  petCompose.desc:SetText(petComposeDesc)
end
local panelSizeY = Panel_Window_PetCompose:GetSizeY()
local descBgSizeY = petCompose.descBg:GetSizeY()
if 120 < petCompose.desc:GetTextSizeY() then
  Panel_Window_PetCompose:SetSize(Panel_Window_PetCompose:GetSizeX(), panelSizeY + petCompose.desc:GetTextSizeY() - 119)
  petCompose.descBg:SetSize(petCompose.descBg:GetSizeX(), descBgSizeY + petCompose.desc:GetTextSizeY() - 119)
end
petCompose.btn_Yes:ComputePos()
petCompose.btn_No:ComputePos()
function PetCompose_Init()
  petComposeNo[0] = nil
  petComposeNo[1] = nil
  petCompose._race = nil
  petCompose.icon_1:ChangeTextureInfoName("")
  petCompose.icon_2:ChangeTextureInfoName("")
  petCompose.icon_3:ChangeTextureInfoName("")
  petCompose.icon_1:SetShow(false)
  petCompose.icon_2:SetShow(false)
  petCompose.icon_3:SetShow(false)
  petCompose.defaultIcon_1:SetShow(true)
  petCompose.defaultIcon_2:SetShow(true)
  petCompose.icon_question:SetShow(true)
  composableCheck = false
  petCompose.preserveSkillNo = nil
  ClearFocusEdit(petCompose.editName)
  petCompose.radioBtn_PetSkill_1:SetCheck(false)
  petCompose.radioBtn_PetSkill_2:SetCheck(false)
  petCompose.radioBtn_PetSkill_3:SetCheck(true)
  petCompose.radioBtn_PetLook_1:SetCheck(false)
  petCompose.radioBtn_PetLook_2:SetCheck(false)
  petCompose.radioBtn_PetLook_3:SetCheck(true)
  petCompose.radioBtn_PetLook_2:SetShow(true)
  petCompose.radioBtn_PetSkill_2:SetShow(true)
  for index = 1, 3 do
    petCompose.skillSlotBg[index][1]:SetShow(true)
    petCompose.skillSlotBg[index][2]:SetShow(true)
    petCompose.skillSlotBg[index][3]:SetShow(true)
    petCompose.skillDefaultIcon[index][1]:SetShow(true)
    petCompose.skillDefaultIcon[index][2]:SetShow(true)
    petCompose.skillDefaultIcon[index][3]:SetShow(true)
    petCompose.skillSlot[index][1]:SetShow(false)
    petCompose.skillSlot[index][2]:SetShow(false)
    petCompose.skillSlot[index][3]:SetShow(false)
  end
  PetCompose_UpdatePetSkillList()
end
function PetCompose_Open()
  Panel_Window_PetCompose:SetShow(true)
  Panel_Window_PetCompose:SetPosX(Panel_Window_PetListNew:GetPosX() + Panel_Window_PetListNew:GetSizeX() + 10)
  Panel_Window_PetCompose:SetPosY(Panel_Window_PetListNew:GetPosY())
  PetCompose_Init()
  petCompose.editName:SetEditText(petComposeString)
  petSkillList_Close()
  composePetTier = 0
  composableCheck = true
end
local petSkillCheck
function PetCompose_UpdatePetSkillList()
  local petNo0 = petComposeNo[0]
  local petNo1 = petComposeNo[1]
  PetComposeSkill_Init()
  petCompose.skillNoList[0] = nil
  petSkillCheck = {}
  local function havePetSkillCheck(petNo)
    if petNo ~= nil then
      local skillLearnCount = 0
      local skillMaxCount = ToClient_getPetEquipSkillMax()
      for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
        local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
        local _petNo = petData._petNo
        if _petNo ~= nil and petNo == _petNo then
          for skill_idx = 0, skillMaxCount - 1 do
            local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
            local isLearn = petData:isPetEquipSkillLearned(skill_idx)
            if true == isLearn and nil ~= skillStaticStatus and true ~= petSkillCheck[skill_idx] then
              skillLearnCount = skillLearnCount + 1
              petSkillCheck[skill_idx] = true
              local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
              if nil ~= skillTypeStaticWrapper and skillLearnCount <= #petCompose.skillSlot then
                local skillNo = skillStaticStatus:getSkillNo()
                petCompose.skillNoList[skillLearnCount] = skill_idx
                petCompose.skillSlot[3][skillLearnCount]:SetShow(true)
                petCompose.skillDefaultIcon[3][skillLearnCount]:SetShow(false)
                petCompose.skillSlot[3][skillLearnCount]:SetIgnore(false)
                petCompose.skillSlot[3][skillLearnCount]:ChangeTextureInfoName("Icon/" .. skillTypeStaticWrapper:getIconPath())
                petCompose.skillSlot[3][skillLearnCount]:addInputEvent("Mouse_On", "PetCompose_ShowSkillToolTip( " .. skill_idx .. ", " .. skillLearnCount .. " )")
                petCompose.skillSlot[3][skillLearnCount]:addInputEvent("Mouse_Out", "PetCompose_HideSkillToolTip()")
                Panel_SkillTooltip_SetPosition(skillNo, petCompose.skillSlot[3][skillLearnCount], "PetSkill")
              end
            end
          end
        end
      end
    end
  end
  if petCompose.radioBtn_PetSkill_1:IsCheck() and nil ~= petNo0 then
    havePetSkillCheck(petNo0)
  elseif petCompose.radioBtn_PetSkill_2:IsCheck() and nil ~= petNo1 then
    havePetSkillCheck(petNo1)
  end
  local function petIconChange(petNo)
    for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
      local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
      local _petNo = petData._petNo
      if _petNo == petNo then
        local iconPath = petData:getIconPath()
        petCompose.icon_3:ChangeTextureInfoName(iconPath)
        petCompose.icon_3:SetShow(true)
      end
    end
  end
  petCompose.icon_question:SetShow(false)
  if petCompose.radioBtn_PetLook_1:IsCheck() and nil ~= petNo0 then
    petIconChange(petNo0)
  elseif petCompose.radioBtn_PetLook_2:IsCheck() and nil ~= petNo1 then
    petIconChange(petNo1)
  else
    petCompose.icon_3:SetShow(false)
    petCompose.icon_question:SetShow(true)
  end
end
function PetCompose_SkillSet(petIndex, uiIndex)
  local self = petCompose
  local petData = ToClient_getPetSealedDataByIndex(petIndex)
  if nil == petData then
    return
  end
  local skillMaxCount = ToClient_getPetEquipSkillMax()
  petCompose.skillNoList[0] = nil
  skillLearnCount = 0
  petSkillCheck = {}
  for skill_idx = 0, skillMaxCount - 1 do
    local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
    local isLearn = petData:isPetEquipSkillLearned(skill_idx)
    if true == isLearn and nil ~= skillStaticStatus and true ~= petSkillCheck[skill_idx] then
      skillLearnCount = skillLearnCount + 1
      petSkillCheck[skill_idx] = true
      local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
      if nil ~= skillTypeStaticWrapper and skillLearnCount <= #petCompose.skillSlot then
        local skillNo = skillStaticStatus:getSkillNo()
        petCompose.skillNoList[skillLearnCount] = skill_idx
        petCompose.skillSlot[uiIndex][skillLearnCount]:SetShow(true)
        petCompose.skillDefaultIcon[uiIndex][skillLearnCount]:SetShow(false)
        petCompose.skillSlot[uiIndex][skillLearnCount]:SetIgnore(false)
        petCompose.skillSlot[uiIndex][skillLearnCount]:ChangeTextureInfoName("Icon/" .. skillTypeStaticWrapper:getIconPath())
        petCompose.skillSlot[uiIndex][skillLearnCount]:addInputEvent("Mouse_On", "PetCompose_ShowSkillToolTip( " .. skill_idx .. ", " .. skillLearnCount .. " )")
        petCompose.skillSlot[uiIndex][skillLearnCount]:addInputEvent("Mouse_Out", "PetCompose_HideSkillToolTip()")
        Panel_SkillTooltip_SetPosition(skillNo, petCompose.skillSlot[uiIndex][skillLearnCount], "PetSkill")
      end
    end
  end
  if 2 == uiIndex and 99 == petData:getPetStaticStatus():getPetRace() then
    petCompose.radioBtn_PetLook_2:SetShow(false)
    petCompose.radioBtn_PetSkill_2:SetShow(false)
  else
    petCompose.radioBtn_PetLook_2:SetShow(true)
    petCompose.radioBtn_PetSkill_2:SetShow(true)
  end
end
function PetCompose_Simpletooltips(isShow, tipType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PETCOMPOSE_CHANGESKILL")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_TOOLTIP_SELECTSKILL_DESC")
    control = petCompose.radioBtn_PetSkill_1
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PETCOMPOSE_CHANGESKILL")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_TOOLTIP_SELECTSKILL_DESC")
    control = petCompose.radioBtn_PetSkill_2
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PETCOMPOSE_NOTCHANGESKILL")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_TOOLTIP_RANDOMSKILL_DESC")
    control = petCompose.radioBtn_PetSkill_3
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PETCOMPOSE_CHANGELOOK")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_TOOLTIP_SELECTLOOK_DESC")
    control = petCompose.radioBtn_PetLook_1
  elseif 4 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PETCOMPOSE_CHANGELOOK")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_TOOLTIP_SELECTLOOK_DESC")
    control = petCompose.radioBtn_PetLook_2
  elseif 5 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PETCOMPOSE_NOTCHANGELOOK")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_TOOLTIP_RANDOMLOOK_DESC")
    control = petCompose.radioBtn_PetLook_3
  end
  TooltipSimple_Show(control, name, desc)
end
local composePetNo = function(petNo)
  for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
    local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
    local _petNo = petData._petNo
    if petNo == _petNo then
      local petSS = petData:getPetStaticStatus()
      local petTier = petSS:getPetTier() + 1
      return petTier
    end
  end
end
function PaGlobalFunc_PetCompose_Close()
  Panel_Window_PetCompose:SetShow(false)
end
function petListNew_Compose_Set(petNoStr, petRace, sealPetIndex, isJokerPetUse)
  if nil == petComposeNo[0] then
    petComposeNo[0] = tonumber64(petNoStr)
    petImgChange(petComposeNo[0], 0)
    petCompose._race = petRace
    petCompose._isJokerPetUse = isJokerPetUse
    PetCompose_UpdatePetSkillList()
    composePetTier = composePetNo(petComposeNo[0])
    PetCompose_SkillSet(sealPetIndex, 1)
  elseif nil == petComposeNo[1] then
    petComposeNo[1] = tonumber64(petNoStr)
    petImgChange(petComposeNo[1], 1)
    PetCompose_UpdatePetSkillList()
    PetCompose_SkillSet(sealPetIndex, 2)
  end
  FGlobal_PetList_Set(true)
end
function petImgChange(petNo, index)
  for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
    local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
    local _petNo = petData._petNo
    if petNo == _petNo then
      local petSS = petData:getPetStaticStatus()
      local iconPath = petData:getIconPath()
      if 0 == index then
        petCompose.icon_1:ChangeTextureInfoName(iconPath)
        petCompose.icon_1:SetShow(true)
        petCompose.defaultIcon_1:SetShow(false)
      elseif 1 == index then
        petCompose.icon_2:ChangeTextureInfoName(iconPath)
        petCompose.icon_2:SetShow(true)
        petCompose.defaultIcon_2:SetShow(false)
        petCompose.icon_question:SetShow(false)
      end
    end
  end
end
function HandleClicked_PetCompose_ClearEdit()
  petCompose.editName:SetMaxInput(getGameServiceTypePetNameLength())
  SetFocusEdit(petCompose.editName)
  petCompose.editName:SetEditText("", true)
end
function Confirm_PetCompose()
  ClearFocusEdit(petCompose.editName)
  local petName = petCompose.editName:GetEditText()
  if "" == petName or petComposeString == petName then
    Proc_ShowMessage_Ack(petComposeString)
    return
  end
  if nil ~= petComposeNo[1] then
    local function confirm_compose()
      if petCompose.preserveSkillNo == nil then
        petCompose.preserveSkillNo = ToClient_getPetEquipSkillMax()
      end
      local isInherit = 0
      local isLookChange = 0
      local petNo_1 = petComposeNo[0]
      local petNo_2 = petComposeNo[1]
      if petCompose.radioBtn_PetSkill_1:IsCheck() then
        isInherit = 2
      elseif petCompose.radioBtn_PetSkill_2:IsCheck() then
        isInherit = 1
      end
      if petCompose.radioBtn_PetLook_1:IsCheck() then
        isLookChange = 2
      elseif petCompose.radioBtn_PetLook_2:IsCheck() then
        isLookChange = 1
      end
      ToClient_requestPetFusion(petName, petNo_1, petNo_2, isInherit, isLookChange)
      Panel_Window_PetCompose_Close()
    end
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_MSGCONTENT")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "PANEL_SERVANTMIX_TITLE"),
      content = messageBoxMemo,
      functionYes = confirm_compose,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_REGIST"))
    return
  end
end
function FGlobal_EscapeEditBox_PetCompose(bool)
  ClearFocusEdit(petCompose.editName)
end
function CheckCompose()
  return composableCheck
end
function FGlobal_PetCompose_GetPetComposeNo(index)
  return petComposeNo[index]
end
function FGlobal_PetCompose_GetPetEditName()
  return petCompose.editName
end
function FGlobal_PetCompose_GetSkillSlot(index)
  return petCompose.skillSlot[index]
end
function FGlobal_PetCompose_GetRace()
  return petCompose._race
end
function FGlobal_PetCompose_GetIsJokerPetUse()
  return petCompose._isJokerPetUse
end
function FGlobal_PetCompose_GetComposePetTier()
  return composePetTier
end
