Panel_Window_PetMarketRegist:SetShow(false, false)
Panel_Window_PetMarketRegist:setMaskingChild(true)
Panel_Window_PetMarketRegist:ActiveMouseEventEffect(true)
Panel_Window_PetMarketRegist:setGlassBackground(true)
Panel_Window_PetMarketRegist:RegisterShowEventFunc(true, "PetMarketRegist_ShowAni()")
Panel_Window_PetMarketRegist:RegisterShowEventFunc(false, "PetMarketRegist_HideAni()")
local auctionInfo = RequestGetAuctionInfo()
function PetMarketRegist_ShowAni()
end
function PetMarketRegist_HideAni()
end
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local PetMarketRegist = {
  btnClose = UI.getChildControl(Panel_Window_PetMarketRegist, "Button_Win_Close"),
  btnQuestion = UI.getChildControl(Panel_Window_PetMarketRegist, "Button_Question"),
  petIcon = UI.getChildControl(Panel_Window_PetMarketRegist, "Static_Icon"),
  tier = UI.getChildControl(Panel_Window_PetMarketRegist, "StaticText_TierValue"),
  level = UI.getChildControl(Panel_Window_PetMarketRegist, "StaticText_LevelValue"),
  base = UI.getChildControl(Panel_Window_PetMarketRegist, "StaticText_BaseValue"),
  special = UI.getChildControl(Panel_Window_PetMarketRegist, "StaticText_SpecialValue"),
  maxPrice = UI.getChildControl(Panel_Window_PetMarketRegist, "StaticText_MaxValue"),
  minPrice = UI.getChildControl(Panel_Window_PetMarketRegist, "StaticText_MinValue"),
  actionSlotBg = UI.getChildControl(Panel_Window_PetMarketRegist, "Static_ActionSlotBg"),
  actionSlot = UI.getChildControl(Panel_Window_PetMarketRegist, "Static_ActionSlot"),
  skillSlotBg = UI.getChildControl(Panel_Window_PetMarketRegist, "Static_SkillSlotBg"),
  skillSlot = UI.getChildControl(Panel_Window_PetMarketRegist, "Static_SkillSlot"),
  btnNextPage = UI.getChildControl(Panel_Window_PetMarketRegist, "Button_NextPage"),
  btnPrevPage = UI.getChildControl(Panel_Window_PetMarketRegist, "Button_PrevPage"),
  editPriceValue = UI.getChildControl(Panel_Window_PetMarketRegist, "Edit_Price"),
  btnRegist = UI.getChildControl(Panel_Window_PetMarketRegist, "Button_Yes"),
  btnCancel = UI.getChildControl(Panel_Window_PetMarketRegist, "Button_No"),
  _slots = Array.new(),
  _maxSlotCount = 5,
  _slotGap = 5,
  _maxValue = toInt64(0, 0),
  _minValue = toInt64(0, 0),
  _registPrice = toInt64(0, 0),
  _nextPage = false,
  _currentPetNo = nil
}
function PetMarketRegist:EventHandler()
  PetMarketRegist.btnClose:addInputEvent("Mouse_LUp", "PetMarketRegist_Close()")
  PetMarketRegist.btnQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"Pet\" )")
  PetMarketRegist.btnQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"Pet\", \"true\")")
  PetMarketRegist.btnQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"Pet\", \"false\")")
  PetMarketRegist.btnRegist:addInputEvent("Mouse_LUp", "PetMarketRegist_Confirm()")
  PetMarketRegist.btnCancel:addInputEvent("Mouse_LUp", "PetMarketRegist_Close()")
  registerEvent("FromClient_RegisterPetInAuction", "FromClient_RegisterPetInAuction")
end
PetMarketRegist:EventHandler()
function PetMarketRegist:Init()
  for index = 0, self._maxSlotCount - 1 do
    local temp = {}
    local actionSlotBg = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetMarketRegist, "Static_ActionSlotBg_" .. index)
    CopyBaseProperty(self.actionSlotBg, actionSlotBg)
    actionSlotBg:SetPosX(self.actionSlotBg:GetPosX() + (self.actionSlotBg:GetSizeX() + self._slotGap) * index)
    temp.actionSlot = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, actionSlotBg, "Static_ActionSlot_" .. index)
    CopyBaseProperty(self.actionSlot, temp.actionSlot)
    local skillSlotBg = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetMarketRegist, "Static_SkillSlotBg_" .. index)
    CopyBaseProperty(self.skillSlotBg, skillSlotBg)
    skillSlotBg:SetPosX(self.skillSlotBg:GetPosX() + (self.skillSlotBg:GetSizeX() + self._slotGap) * index)
    temp.skillSlot = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, skillSlotBg, "Static_SkillSlot_" .. index)
    CopyBaseProperty(self.skillSlot, temp.skillSlot)
    self._slots[index] = temp
  end
  self.actionSlotBg:SetShow(false)
  self.actionSlot:SetShow(false)
  self.skillSlotBg:SetShow(false)
  self.skillSlot:SetShow(false)
end
function PetMarketRegist:SetPetInfo(petNo)
  local _petNo = tonumber64(petNo)
  local petCount = ToClient_getPetSealedList()
  if petCount == 0 then
    return
  end
  self._currentPetNo = petNo
  for ii = 0, self._maxSlotCount - 1 do
    self._slots[ii].actionSlot:ChangeTextureInfoName("")
    self._slots[ii].skillSlot:ChangeTextureInfoName("")
  end
  for index = 0, petCount - 1 do
    do
      local petInfo = ToClient_getPetSealedDataByIndex(index)
      local petNo_s64 = petInfo._petNo
      if _petNo == petNo_s64 then
        local petStaticStatus = petInfo:getPetStaticStatus()
        local iconPath = petInfo:getIconPath()
        local petLevel = petInfo._level
        local petTier = petStaticStatus:getPetTier() + 1
        local basePrice = Int64toInt32(petStaticStatus:getBasePrice())
        self._maxValue = tonumber64(basePrice * petStaticStatus:getMaxPricePercent() / 1000000)
        self._minValue = tonumber64(basePrice * petStaticStatus:getMinPricePercent() / 1000000)
        self.maxPrice:SetText(makeDotMoney(self._maxValue))
        self.minPrice:SetText(makeDotMoney(self._minValue))
        self.petIcon:ChangeTextureInfoName(iconPath)
        self.tier:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", petTier))
        self.level:SetText(petLevel .. " Lv")
        local function petSkillType(param)
          local skillParam = petInfo:getSkillParam(param)
          local paramText = ""
          if 1 == skillParam._type then
            paramText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETMARKETREGIST_PICKUPTIME", "time", string.format("%.1f", skillParam:getParam(0)) / 1000)
          elseif 2 == skillParam._type then
            paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDGATHER")
          elseif 3 == skillParam._type then
            paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDPK")
          elseif 4 == skillParam._type then
            paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDPLACE")
          elseif 5 == skillParam._type then
            paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_MOBAGGRO")
          elseif 6 == skillParam._type then
            paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDRAREMONSTER")
          elseif 7 == skillParam._type then
            paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_REDUCEAUTOFISHINGTIME")
          end
          if 0 == param then
            self.base:SetText(paramText)
          elseif 1 == param then
            self.special:SetText(paramText)
          end
        end
        petSkillType(0)
        petSkillType(1)
        if self.btnNextPage:GetShow() then
          self._nextPage = false
        end
        local actionMaxCount = ToClient_getPetActionMax()
        local uiIdx = 0
        local nextIndex = 0
        for action_idx = 0, actionMaxCount - 1 do
          local actionStaticStatus = ToClient_getPetActionStaticStatus(action_idx)
          local isLearn = petInfo:isPetActionLearned(action_idx)
          if true == isLearn then
            if not self._nextPage then
              if uiIdx < self._maxSlotCount then
                self._slots[uiIdx].actionSlot:ChangeTextureInfoName("Icon/" .. actionStaticStatus:getIconPath())
                self._slots[uiIdx].actionSlot:addInputEvent("Mouse_On", "PetMarketRegist_ShowActionToolTip( " .. action_idx .. ", " .. uiIdx .. " )")
                self._slots[uiIdx].actionSlot:addInputEvent("Mouse_Out", "PetMarketRegist_HideActionToolTip( " .. action_idx .. " )")
                uiIdx = uiIdx + 1
              else
                self._nextPage = true
                self.btnNextPage:SetShow(true)
                self.btnNextPage:addInputEvent("Mouse_LUp", "PetMarketRegist_NextAction_Show()")
                break
              end
            else
              uiIdx = uiIdx + 1
              if uiIdx > self._maxSlotCount then
                self._slots[nextIndex].actionSlot:ChangeTextureInfoName("Icon/" .. actionStaticStatus:getIconPath())
                self._slots[nextIndex].actionSlot:addInputEvent("Mouse_On", "PetMarketRegist_ShowActionToolTip( " .. action_idx .. ", " .. nextIndex .. " )")
                self._slots[nextIndex].actionSlot:addInputEvent("Mouse_Out", "PetMarketRegist_HideActionToolTip( " .. action_idx .. " )")
                nextIndex = nextIndex + 1
              end
            end
          end
        end
        local skillMaxCount = ToClient_getPetEquipSkillMax()
        uiIdx = 0
        for skill_idx = 0, skillMaxCount - 1 do
          local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
          local isLearn = petInfo:isPetEquipSkillLearned(skill_idx)
          if true == isLearn and nil ~= skillStaticStatus then
            local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
            if nil ~= skillTypeStaticWrapper then
              local skillNo = skillStaticStatus:getSkillNo()
              self._slots[uiIdx].skillSlot:ChangeTextureInfoName("Icon/" .. skillTypeStaticWrapper:getIconPath())
              self._slots[uiIdx].skillSlot:addInputEvent("Mouse_On", "PetMarketRegist_ShowSkillToolTip( " .. skill_idx .. ", " .. uiIdx .. " )")
              self._slots[uiIdx].skillSlot:addInputEvent("Mouse_Out", "PetMarketRegist_HideSkillToolTip()")
              Panel_SkillTooltip_SetPosition(skillNo, self._slots[uiIdx].skillSlot, "PetSkill")
            end
            uiIdx = uiIdx + 1
          end
        end
      end
    end
  end
  PetMarketRegist.editPriceValue:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_PETMARKETREGIST_INPUTPRICE"))
  PetMarketRegist.editPriceValue:addInputEvent("Mouse_LUp", "HandleClicked_PriceBox( \"" .. tostring(_petNo) .. "\" )")
end
function PetMarketRegist_NextAction_Show()
  PetMarketRegist.btnNextPage:SetShow(false)
  PetMarketRegist.btnPrevPage:SetShow(true)
  PetMarketRegist.btnPrevPage:addInputEvent("Mouse_LUp", "HandleClicked_NextAction_Show()")
  PetMarketRegist:SetPetInfo(PetMarketRegist._currentPetNo)
end
function HandleClicked_NextAction_Show()
  PetMarketRegist.btnNextPage:SetShow(true)
  PetMarketRegist.btnPrevPage:SetShow(false)
  PetMarketRegist:SetPetInfo(PetMarketRegist._currentPetNo)
end
function HandleClicked_PriceBox(petNoStr)
  param = {
    [0] = petNoStr
  }
  local maxPrice = PetMarketRegist._maxValue
  Panel_NumberPad_Show(true, maxPrice, param, PetMarket_SetEditBox)
end
function PetMarket_SetEditBox(inputNumber)
  local price = makeDotMoney(inputNumber)
  PetMarketRegist.editPriceValue:SetEditText(price)
  PetMarketRegist._registPrice = inputNumber
end
function PetMarketRegist_Confirm()
  PetMarket_Register_ConfirmFunction(PetMarketRegist._registPrice, param)
end
function PetMarket_Register_ConfirmFunction(inputNumber, param)
  if toInt64(0, 0) == inputNumber then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETMARKETREGIST_INPUTPRICE"))
    return
  elseif inputNumber < PetMarketRegist._minValue then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETMARKETREGIST_LOWPRICE"))
    return
  elseif inputNumber > PetMarketRegist._maxValue then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETMARKETREGIST_HIGHPRICE"))
    return
  end
  ToClient_registerPetInAuctionReq(tonumber64(param[0]), inputNumber)
end
function PetMarketRegist_ShowActionToolTip(action_idx, uiIdx)
  local actionStaticStatus = ToClient_getPetActionStaticStatus(action_idx)
  if nil == actionStaticStatus then
    return
  end
  local actionIconPath = actionStaticStatus:getIconPath()
  local actionName = actionStaticStatus:getName()
  local actionDesc = actionStaticStatus:getDescription()
  local uiBase = PetMarketRegist._slots[uiIdx].actionSlot
  if "" == actionDesc then
    actionDesc = nil
  end
  TooltipSimple_Show(uiBase, actionName, actionDesc)
end
function PetMarketRegist_HideActionToolTip(action_idx)
  TooltipSimple_Hide()
end
function PetMarketRegist_ShowSkillToolTip(skill_idx, uiIdx)
  local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
  local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
  local petSkillNo = skillStaticStatus:getSkillNo()
  local uiBase = PetMarketRegist._slots[uiIdx].skillSlot
  Panel_SkillTooltip_Show(petSkillNo, false, "PetSkill")
end
function PetMarketRegist_HideSkillToolTip()
  Panel_SkillTooltip_Hide()
end
function FGlobal_PetMarketRegist_Show(petNo)
  if nil == petNo then
    return
  end
  if not Panel_Window_PetMarketRegist:GetShow() then
    Panel_Window_PetMarketRegist:SetShow(true)
  end
  local self = PetMarketRegist
  self._currentPetNo = nil
  self._nextPage = false
  self.btnNextPage:SetShow(false)
  self.btnPrevPage:SetShow(false)
  self:SetPetInfo(petNo)
end
function PetMarketRegist_Close()
  if Panel_Window_PetMarketRegist:GetShow() then
    Panel_Window_PetMarketRegist:SetShow(false)
    PetMarketRegist._registPrice = toInt64(0, 0)
  end
  if not Panel_Window_PetListNew:GetShow() then
    FGlobal_PetListNew_Open()
  end
end
function FromClient_RegisterPetInAuction()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETMARKETREGIST_REGISTCONFIRM"))
  PetMarketRegist_Close()
end
PetMarketRegist:Init()
