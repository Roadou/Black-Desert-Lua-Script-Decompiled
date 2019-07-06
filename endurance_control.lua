local CT = CppEnums.ClassType
local awakenWeapon = {
  [CT.ClassType_Warrior] = ToClient_IsContentsGroupOpen("901"),
  [CT.ClassType_Ranger] = ToClient_IsContentsGroupOpen("902"),
  [CT.ClassType_Sorcerer] = ToClient_IsContentsGroupOpen("903"),
  [CT.ClassType_Giant] = ToClient_IsContentsGroupOpen("904"),
  [CT.ClassType_Tamer] = ToClient_IsContentsGroupOpen("905"),
  [CT.ClassType_BladeMaster] = ToClient_IsContentsGroupOpen("906"),
  [CT.ClassType_BladeMasterWomen] = ToClient_IsContentsGroupOpen("907"),
  [CT.ClassType_Valkyrie] = ToClient_IsContentsGroupOpen("908"),
  [CT.ClassType_Wizard] = ToClient_IsContentsGroupOpen("909"),
  [CT.ClassType_WizardWomen] = ToClient_IsContentsGroupOpen("910"),
  [CT.ClassType_NinjaMan] = ToClient_IsContentsGroupOpen("911"),
  [CT.ClassType_NinjaWomen] = ToClient_IsContentsGroupOpen("912"),
  [CT.ClassType_DarkElf] = ToClient_IsContentsGroupOpen("913"),
  [CT.ClassType_Combattant] = ToClient_IsContentsGroupOpen("914"),
  [CT.ClassType_CombattantWomen] = ToClient_IsContentsGroupOpen("918"),
  [CT.ClassType_Lahn] = ToClient_IsContentsGroupOpen("916"),
  [CT.ClassType_Orange] = ToClient_IsContentsGroupOpen("942")
}
local classType = getSelfPlayer():getClassType()
function FromClient_EnduranceUpdate(enduranceType)
  if (Panel_Window_StableList:GetShow() or Panel_Window_WharfList:GetShow() or Panel_Window_Repair:GetShow()) and false == PaGlobal_Camp:getIsCamping() then
    return
  end
  local self = PaGlobalPlayerEnduranceList
  if enduranceType == CppEnums.EnduranceType.eEnduranceType_Player then
    self = PaGlobalPlayerEnduranceList
  elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Horse then
    self = PaGlobalHorseEnduranceList
  elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Carriage then
    self = PaGlobalCarriageEnduranceList
  elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Ship then
    self = PaGlobalShipEnduranceList
  end
  if not self:checkInit() then
    return
  end
  local isShow = false
  local isCantRepair = false
  local isPcRoomEquip = false
  local enduranceCheck = 0
  for index = 0, CppEnums.EquipSlotNo.equipSlotNoCount - 1 do
    local enduranceLevel = -1
    isPcRoomEquip = false
    if enduranceType == CppEnums.EnduranceType.eEnduranceType_Player then
      enduranceLevel = ToClient_GetPlayerEquipmentEnduranceLevel(index)
      local equipItemWrapper = ToClient_getEquipmentItem(index)
      if nil ~= equipItemWrapper and equipItemWrapper:needCheckPcRoom() then
        isPcRoomEquip = true
      end
      if false == isCantRepair then
        isCantRepair = ToClient_IsCantRepairPlayerEquipment(index)
      end
    elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Horse then
      enduranceLevel = ToClient_GetHorseEquipmentEnduranceLevel(index)
    elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Carriage then
      enduranceLevel = ToClient_GetCarriageEquipmentEnduranceLevel(index)
    elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Ship then
      enduranceLevel = ToClient_GetShipEquipmentEnduranceLevel(index)
    end
    if nil ~= self.enduranceInfo[index].control then
      self.enduranceInfo[index].control:ResetVertexAni()
      if enduranceLevel < 0 then
        self.enduranceInfo[index].itemEquiped = false
        self.enduranceInfo[index].color = Defines.Color.C_FF000000
        self.enduranceInfo[index].isBroken = false
      else
        self.enduranceInfo[index].itemEquiped = true
        if enduranceLevel > 1 then
          self.enduranceInfo[index].color = Defines.Color.C_FF444444
          self.enduranceInfo[index].isBroken = false
          if isPcRoomEquip then
            Panel_Endurance_updateVertexAniRun(self.enduranceInfo[index].control, index, "Red")
            isShow = true
          end
        else
          if enduranceType == CppEnums.EnduranceType.eEnduranceType_Player then
            if enduranceLevel == 0 then
              Panel_Endurance_updateVertexAniRun(self.enduranceInfo[index].control, index, "Red")
            elseif enduranceLevel == 1 then
              if isPcRoomEquip then
                Panel_Endurance_updateVertexAniRun(self.enduranceInfo[index].control, index, "Red")
              else
                Panel_Endurance_updateVertexAniRun(self.enduranceInfo[index].control, index, "Orange")
              end
            end
          elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Horse then
            if 0 == enduranceLevel then
              if 3 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Horse_Body_Red", true)
              elseif 4 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Horse_Saddle_Red", true)
              elseif 5 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Horse_RiderFoot_Red", true)
              elseif 6 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Horse_Head_Red", true)
              elseif 12 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Horse_HorseFoot_Red", true)
              end
            elseif 1 == enduranceLevel then
              if 3 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Horse_Body_Orange", true)
              elseif 4 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Horse_Saddle_Orange", true)
              elseif 5 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Horse_RiderFoot_Orange", true)
              elseif 6 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Horse_Head_Orange", true)
              elseif 12 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Horse_HorseFoot_Orange", true)
              end
            end
          elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Carriage then
            if 0 == enduranceLevel then
              if 4 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Carriage_Wheel_Red", true)
              elseif 5 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Carriage_Flag_Red", true)
              elseif 6 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Carriage_Curtain_Red", true)
              elseif 13 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Carriage_Lamp_Red", true)
              elseif 25 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Carriage_Cover_Red", true)
              end
            elseif 1 == enduranceLevel then
              if 4 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Carriage_Wheel_Orange", true)
              elseif 5 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Carriage_Flag_Orange", true)
              elseif 6 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Carriage_Curtain_Orange", true)
              elseif 13 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Carriage_Lamp_Orange", true)
              elseif 25 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Carriage_Cover_Orange", true)
              end
            end
          elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Ship then
            if 0 == enduranceLevel then
              if 3 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Ship_Main_Red", true)
              elseif 4 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Ship_Head_Red", true)
              elseif 5 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Ship_Goods_Red", true)
              elseif 25 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Ship_Deco_Red", true)
              end
            elseif 1 == enduranceLevel then
              if 3 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Ship_Main_Orange", true)
              elseif 4 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Ship_Head_Orange", true)
              elseif 5 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Ship_Goods_Orange", true)
              elseif 25 == index then
                self.enduranceInfo[index].control:SetVertexAniRun("Ani_Color_Ship_Deco_Orange", true)
              end
            end
          end
          self.enduranceInfo[index].isBroken = true
          isShow = true
          enduranceCheck = enduranceCheck + 1
        end
      end
      self.enduranceInfo[index].control:SetColor(self.enduranceInfo[index].color)
    end
  end
  if isShow then
    for index = 0, CppEnums.EquipSlotNo.equipSlotNoCount - 1 do
      if nil ~= self.enduranceInfo[index].control then
        self.enduranceInfo[index].control:SetShow(true)
      end
    end
    if enduranceType == CppEnums.EnduranceType.eEnduranceType_Player then
      self.enduranceInfo[29].control:SetShow(awakenWeapon[classType])
    end
    self.effectBG:EraseAllEffect()
    if enduranceType == CppEnums.EnduranceType.eEnduranceType_Player then
    elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Horse then
    elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Carriage then
    elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Ship then
    end
    if false == self.isEffectSound then
      self.isEffectSound = true
      audioPostEvent_SystemUi(8, 6)
    end
    if (4 == enduranceCheck or 1 == enduranceCheck) and true == isCantRepair then
      self.noticeEndurance:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENDURANCE_NOTICEENDURACNE1"))
    elseif true == isCantRepair then
      self.noticeEndurance:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENDURANCE_NOTICEENDURACNE2"))
    else
      self.noticeEndurance:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENDURANCE_NOTICEENDURACNE3"))
    end
    self.panel:SetShow(true)
    self.effectBG:SetEnable(true)
  else
    for index = 0, CppEnums.EquipSlotNo.equipSlotNoCount - 1 do
      if nil ~= self.enduranceInfo[index].control then
        self.enduranceInfo[index].control:SetShow(false)
        self.enduranceInfo[index].control:ResetVertexAni()
      end
    end
    self.isEffectSound = false
    self.effectBG:EraseAllEffect()
    self.noticeEndurance:SetShow(false)
    self.effectBG:SetEnable(false)
    if enduranceType == CppEnums.EnduranceType.eEnduranceType_Player then
    else
      self.panel:SetShow(false)
    end
  end
  local enduranceList = {
    PaGlobalPlayerEnduranceList,
    PaGlobalHorseEnduranceList,
    PaGlobalCarriageEnduranceList,
    PaGlobalShipEnduranceList
  }
  local isRepairShow = false
  for key, value in pairs(enduranceList) do
    if value.effectBG:IsEnable() and false == isRepairShow then
      value.repair_AutoNavi:SetShow(true)
      value.repair_Navi:SetShow(true)
      isRepairShow = true
      if true == _ContentsGroup_RenewUI_Main then
        value.repair_AutoNavi:SetShow(false)
        value.repair_Navi:SetShow(false)
      end
    else
      value.repair_AutoNavi:SetShow(false)
      value.repair_Navi:SetShow(false)
    end
  end
  FGlobal_Inventory_WeightCheck()
end
function Panel_Endurance_updateVertexAniRun(control, idx, color)
  if 0 == idx then
    control:SetVertexAniRun("Ani_Color_WeaponR_" .. color, true)
  elseif 1 == idx then
    control:SetVertexAniRun("Ani_Color_WeaponL_" .. color, true)
  elseif 3 == idx then
    control:SetVertexAniRun("Ani_Color_Armor_" .. color, true)
  elseif 4 == idx then
    control:SetVertexAniRun("Ani_Color_Glove_" .. color, true)
  elseif 5 == idx then
    control:SetVertexAniRun("Ani_Color_Boots_" .. color, true)
  elseif 6 == idx then
    control:SetVertexAniRun("Ani_Color_Helm_" .. color, true)
  elseif 7 == idx then
    control:SetVertexAniRun("Ani_Color_Necklace_" .. color, true)
  elseif 8 == idx then
    control:SetVertexAniRun("Ani_Color_Ring1_" .. color, true)
  elseif 9 == idx then
    control:SetVertexAniRun("Ani_Color_Ring2_" .. color, true)
  elseif 10 == idx then
    control:SetVertexAniRun("Ani_Color_Earing1_" .. color, true)
  elseif 11 == idx then
    control:SetVertexAniRun("Ani_Color_Earing2_" .. color, true)
  elseif 12 == idx then
    control:SetVertexAniRun("Ani_Color_Belt_" .. color, true)
  elseif 29 == idx then
    control:SetVertexAniRun("Ani_Color_AwakenWeapon_" .. color, true)
  end
end
function FromClient_PlayerEnduranceUpdate()
  FromClient_EnduranceUpdate(CppEnums.EnduranceType.eEnduranceType_Player)
end
function FromClient_ServantEnduranceUpdate()
  FromClient_EnduranceUpdate(CppEnums.EnduranceType.eEnduranceType_Horse)
  FromClient_EnduranceUpdate(CppEnums.EnduranceType.eEnduranceType_Carriage)
  FromClient_EnduranceUpdate(CppEnums.EnduranceType.eEnduranceType_Ship)
end
function Panel_Endurance_Update()
  FromClient_PlayerEnduranceUpdate()
  FromClient_ServantEnduranceUpdate()
end
function renderModeChange_Panel_Endurance_Update(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  Panel_Endurance_Update()
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_Panel_Endurance_Update")
registerEvent("FromClient_luaLoadComplete", "Panel_Endurance_Update")
registerEvent("FromClient_EquipEnduranceChanged", "Panel_Endurance_Update")
registerEvent("EventEquipmentUpdate", "FromClient_PlayerEnduranceUpdate")
registerEvent("EventServantEquipItem", "FromClient_ServantEnduranceUpdate")
registerEvent("EventServantEquipmentUpdate", "FromClient_ServantEnduranceUpdate")
