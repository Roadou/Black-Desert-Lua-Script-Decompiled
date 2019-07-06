Panel_Window_Stable_ChangeSkill:ignorePadSnapMoveToOtherPanel()
local UI_TM = CppEnums.TextMode
local Panel_Window_StableChangeSkill_info = {
  _ui = {
    static_Skill_List = nil,
    radioButton_SkillSlot = nil,
    static_Icon = nil,
    static_Progress_BG = nil,
    circularProgress_Train = nil,
    staticText_Name = nil,
    skill_VerticalScroll = nil,
    static_TopBg = nil,
    static_Skill_Icon = nil,
    staticText_Wish = nil,
    staticText_Skill_Name = nil,
    staticText_Skill_Stack = nil,
    staticText_StackTitle = nil,
    static_BottomBg = nil,
    static_RightBg = nil
  },
  _value = {
    servantInfo = nil,
    lastSlotIndex = nil,
    currentSlotIndex = nil,
    skillCount = 0,
    learnSkillCount = 0,
    targetChangeSkillNo = nil,
    fromChangeSkillNo = nil,
    isPossibleTarining = false,
    startSlotIndex = 0,
    deleteSkillName = nil
  },
  _pos = {
    sizeSlotY = 70,
    spaceSlotY = 10,
    sizeSlotX = 380,
    spaceSlotX = 11
  },
  _enum = {
    eTYPE_SEALED = 0,
    eTYPE_UNSEALED = 1,
    eTYPE_LEARNED = 0,
    eTYPE_LEARN_POSSIBLE = 1
  },
  _config = {
    actionYTime = 1,
    slotRow = 8,
    slotCol = 1,
    maxSlotCount = 8
  },
  _texture = {
    button = "renewal/etc/console_etc_01.dds",
    base = {
      x1 = 430,
      y1 = 438,
      x2 = 510,
      y2 = 499
    },
    hope = {
      x1 = 430,
      y1 = 438,
      x2 = 510,
      y2 = 499
    },
    Learned = {
      x1 = 430,
      y1 = 314,
      x2 = 510,
      y2 = 375
    }
  },
  _skillSlot = {}
}
local Panel_Window_StableChangeSkillSelect_info = {}
local isContentsEnable = ToClient_IsContentsGroupOpen("60")
function Panel_Window_StableChangeSkill_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_StableChangeSkil_Resize")
  registerEvent("FromClient_ServantChangeSkill", "FromClient_StableChangeSkil_ChangeSkill_Complete")
  registerEvent("FromClient_ForgetServantSkill", "FromClient_StableChangeSkil_ForgetServantSkill")
  Panel_Window_Stable_ChangeSkill:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_StableChangeSkill_PadButton_X()")
  Panel_Window_Stable_ChangeSkill:registerPadEvent(__eConsoleUIPadEvent_A, "PaGlobalFunc_StableChangeSkill_PadButtonDown_A()")
  Panel_Window_Stable_ChangeSkill:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_StableChangeSkill_PadButtonUP_Y()")
  Panel_Window_Stable_ChangeSkill:registerPadEvent(__eConsoleUIPadEvent_LTPress_Y, "PaGlobalFunc_StableChangeSkill_SelectTainingALL()")
end
function Panel_Window_StableChangeSkill_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:createSkillSlot()
  self:registerMessageHandler()
end
function Panel_Window_StableChangeSkill_info:initValue()
  self._value.servantInfo = nil
  self._value.lastSlotIndex = nil
  self._value.currentSlotIndex = nil
  self._value.startSlotIndex = 0
  self._value.skillCount = 0
  self._value.learnSkillCount = 0
  self._value.targetChangeSkillNo = nil
  self._value.fromChangeSkillNo = nil
  self._value.isPossibleTarining = false
end
function Panel_Window_StableChangeSkill_info:initUpdateValue()
  self._value.servantInfo = nil
  self._value.lastSlotIndex = nil
  self._value.currentSlotIndex = nil
  self._value.startSlotIndex = 0
  self._value.skillCount = 0
  self._value.learnSkillCount = 0
  self._value.fromChangeSkillNo = nil
  self._value.isPossibleTarining = false
end
function Panel_Window_StableChangeSkill_info:resize()
  Panel_Window_Stable_ChangeSkill:ComputePos()
end
function Panel_Window_StableChangeSkill_info:childControl()
  self._ui.static_Skill_List = UI.getChildControl(Panel_Window_Stable_ChangeSkill, "Static_Skill_List")
  self._ui.radioButton_SkillSlot = UI.getChildControl(self._ui.static_Skill_List, "Radiobutton_SkillSlot")
  self._ui.static_Icon = UI.getChildControl(self._ui.radioButton_SkillSlot, "Static_Icon")
  self._ui.circularProgress_Train = UI.getChildControl(self._ui.static_Icon, "CircularProgress_Train")
  self._ui.staticText_Name = UI.getChildControl(self._ui.radioButton_SkillSlot, "StaticText_Name")
  self._ui.radioButton_SkillSlot:SetShow(false)
  self._ui.skill_VerticalScroll = UI.getChildControl(self._ui.static_Skill_List, "Skill_VerticalScroll")
  self._pos.sizeSlotX = self._ui.radioButton_SkillSlot:GetSizeX()
  self._pos.sizeSlotY = self._ui.radioButton_SkillSlot:GetSizeY()
  self._ui.static_BottomBg = UI.getChildControl(Panel_Window_Stable_ChangeSkill, "Static_BottomBg")
  self._ui.static_train = UI.getChildControl(self._ui.static_BottomBg, "StaticText_Train")
  self._ui.static_RightBg = UI.getChildControl(Panel_Window_Stable_ChangeSkill, "Static_RightBg")
  self._ui.static_Right_SkillIcon = UI.getChildControl(self._ui.static_RightBg, "Static_SkillIcon")
  self._ui.static_Right_SkillCircularProgress = UI.getChildControl(self._ui.static_Right_SkillIcon, "CircularProgress_SkillTrain")
  self._ui.static_Right_SkillName = UI.getChildControl(self._ui.static_RightBg, "StaticText_SkillName")
  self._ui.static_Right_SkillDesc = UI.getChildControl(self._ui.static_RightBg, "StaticText_SkillDesc")
  self._ui.static_Right_SkillDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui.static_TrainAll = UI.getChildControl(self._ui.static_BottomBg, "Static_TrainAll")
  self._ui.staticText_btn_B = UI.getChildControl(self._ui.static_BottomBg, "StaticText_Cancel_ConsoleUI")
  self._ui.staticText_btn_A = UI.getChildControl(self._ui.static_BottomBg, "StaticText_Change")
  self._ui.staticText_btn_X = UI.getChildControl(self._ui.static_BottomBg, "StaticText_Delete")
  self._bottomLeftBtnGroup = {
    self._ui.static_TrainAll,
    self._ui.static_train
  }
  self._bottomRightBtnGroup = {
    self._ui.staticText_btn_B,
    self._ui.staticText_btn_A,
    self._ui.staticText_btn_X
  }
end
function Panel_Window_StableChangeSkill_info:realignBtnGroup()
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._bottomRightBtnGroup, self._ui.static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Panel_Window_StableChangeSkill_info:createSkillSlot()
  for index = 0, self._config.maxSlotCount - 1 do
    local slot = {
      selected = false,
      slotNo = 0,
      skillNo = nil,
      skillLearned = false,
      skillCanHope = false,
      skillCanTaining = false,
      skillCanChangeOrDelete = false,
      radioButton = nil,
      static_Icon = nil,
      staticText_Name = nil,
      static_Progress_BG = nil,
      circularProgress_Train = nil
    }
    function slot:setPos(row, col)
      local skillPanelinfo = Panel_Window_StableChangeSkill_info
      row = math.floor(row)
      local newPosX = 0
      local newPosY = 0
      if row > 0 then
        newPosY = 0 + row * skillPanelinfo._pos.sizeSlotY + row * skillPanelinfo._pos.spaceSlotY
      elseif 0 == row then
        newPosY = 0
      end
      if 0 == col then
        newPosX = skillPanelinfo._pos.spaceSlotX
      else
        newPosX = skillPanelinfo._pos.spaceSlotX * 2 + skillPanelinfo._pos.sizeSlotX
      end
      self.radioButton:SetPosXY(newPosX, newPosY)
    end
    function slot:setSkill(servantInfo, skillNo, eLearnType)
      local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
      local regionName = regionInfo:getAreaName()
      local servantRegionName = servantInfo:getRegionName()
      local stablsSkillInfo = Panel_Window_StableChangeSkill_info
      self.skillNo = skillNo
      self.radioButton:ChangeTextureInfoName(stablsSkillInfo._texture.button)
      local x1, y1, x2, y2 = setTextureUV_Func(self.radioButton, stablsSkillInfo._texture.base.x1, stablsSkillInfo._texture.base.y1, stablsSkillInfo._texture.base.x2, stablsSkillInfo._texture.base.y2)
      self.radioButton:getBaseTexture():setUV(x1, y1, x2, y2)
      self.radioButton:setRenderTexture(self.radioButton:getBaseTexture())
      if eLearnType == stablsSkillInfo._enum.eTYPE_LEARNED then
        local skillWrapper = servantInfo:getSkill(skillNo)
        self.static_Icon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
        self.staticText_Name:SetText(skillWrapper:getName())
        self.skillLearned = true
        self.circularProgress_Train:SetShow(true)
        self.circularProgress_Train:SetProgressRate(servantInfo:getSkillExp(skillNo) / (skillWrapper:getMaxExp() / 100))
        self.radioButton:ChangeTextureInfoName(stablsSkillInfo._texture.button)
        local x1, y1, x2, y2 = setTextureUV_Func(self.radioButton, stablsSkillInfo._texture.Learned.x1, stablsSkillInfo._texture.Learned.y1, stablsSkillInfo._texture.Learned.x2, stablsSkillInfo._texture.Learned.y2)
        self.radioButton:getBaseTexture():setUV(x1, y1, x2, y2)
        self.radioButton:setRenderTexture(self.radioButton:getBaseTexture())
        local expTxt = tonumber(string.format("%.0f", servantInfo:getSkillExp(skillNo) / (skillWrapper:getMaxExp() / 100)))
        if expTxt >= 100 then
          expTxt = 100
        elseif regionName == servantRegionName and isContentsEnable then
          if servantInfo:isSeized() or CppEnums.ServantStateType.Type_RegisterMarket == servantInfo:getStateType() or CppEnums.ServantStateType.Type_RegisterMating == servantInfo:getStateType() or CppEnums.ServantStateType.Type_Mating == servantInfo:getStateType() or servantInfo:isMatingComplete() or CppEnums.ServantStateType.Type_Coma == servantInfo:getStateType() or CppEnums.ServantStateType.Type_SkillTraining == servantInfo:getStateType() or servantInfo:isLink() then
            self.skillCanTaining = false
          else
            self.skillCanTaining = false
            if CppEnums.VehicleType.Type_Carriage ~= servantInfo:getVehicleType() and true == Panel_Window_StableChangeSkill_info._value.isPossibleTarining then
              self.skillCanTaining = true
            end
          end
        end
        if FGlobal_IsCommercialService() then
          if servantInfo:isSkillLock(skillNo) then
            if servantInfo:getStateType() ~= CppEnums.ServantStateType.Type_SkillTraining then
            end
          elseif servantInfo:isSeized() then
          elseif CppEnums.VehicleType.Type_Carriage ~= servantInfo:getVehicleType() then
            self.skillCanChangeOrDelete = true
          end
        end
      else
        local skillWrapper = servantInfo:getSkillXXX(skillNo)
        self.static_Icon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
        self.staticText_Name:SetText(skillWrapper:getName())
        self.radioButton:ChangeTextureInfoName(stablsSkillInfo._texture.button)
        local x1, y1, x2, y2 = setTextureUV_Func(self.radioButton, stablsSkillInfo._texture.hope.x1, stablsSkillInfo._texture.hope.y1, stablsSkillInfo._texture.hope.x2, stablsSkillInfo._texture.hope.y2)
        self.radioButton:getBaseTexture():setUV(x1, y1, x2, y2)
        self.radioButton:setRenderTexture(self.radioButton:getBaseTexture())
        self.circularProgress_Train:SetShow(false)
        if FGlobal_IsCommercialService() and CppEnums.VehicleType.Type_Carriage ~= servantInfo:getVehicleType() then
          self.skillCanHope = true
        end
      end
    end
    function slot:selectSlot(bSelect)
      self.selected = bSelect
      self.radioButton:SetCheck(bSelect)
    end
    function slot:setShow(bShow)
      self.selected = bShow
      self.radioButton:SetShow(bShow)
    end
    function slot:clear()
      self:selectSlot(false)
      self:setShow(false)
      self.skillNo = nil
      self.skillLearned = false
      self.skillCanHope = false
      self.skillCanTaining = false
      self.skillCanChangeOrDelete = false
    end
    slot.radioButton = UI.createAndCopyBasePropertyControl(self._ui.static_Skill_List, "Radiobutton_SkillSlot", self._ui.static_Skill_List, "RadioButton_SkillSlot_" .. index)
    slot.static_Icon = UI.createAndCopyBasePropertyControl(self._ui.radioButton_SkillSlot, "Static_Icon", slot.radioButton, "Static_Icon_" .. index)
    slot.static_Progress_BG = UI.createAndCopyBasePropertyControl(self._ui.static_Icon, "Static_Progress_BG", slot.static_Icon, "Static_Progress_BG_" .. index)
    slot.circularProgress_Train = UI.createAndCopyBasePropertyControl(self._ui.static_Icon, "CircularProgress_Train", slot.static_Icon, "CircularProgress_Train_" .. index)
    slot.staticText_Name = UI.createAndCopyBasePropertyControl(self._ui.radioButton_SkillSlot, "StaticText_Name", slot.radioButton, "StaticText_Name_" .. index)
    local row = math.floor(index / self._config.slotCol)
    local col = index % self._config.slotCol
    slot:setPos(row, col)
    slot:clear()
    slot.radioButton:addInputEvent("Mouse_On", "PaGlobalFunc_StableChangeSkill_SelectSkill(" .. index .. ")")
    if row == 0 then
      slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_StableChangeSkill_ScrollEvent( true )")
    elseif row == self._config.slotRow - 1 then
      slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_StableChangeSkill_ScrollEvent( false )")
    end
    self._skillSlot[index] = slot
  end
end
function Panel_Window_StableChangeSkill_info:setContent(unsealType)
  local servantInfo = stable_getServant(PaGlobalFunc_StableList_SelectSlotNo())
  if nil == servantInfo then
    PaGlobalFunc_StableChangeSkill_Close()
    return
  end
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local regionName = regionInfo:getAreaName()
  local servantRegionName = servantInfo:getRegionName()
  if true == servantInfo:isPossibleTrainingSkill() and regionName == servantRegionName then
    self._value.isPossibleTarining = true
  else
    self._value.isPossibleTarining = false
  end
  self._ui.skill_VerticalScroll:SetControlPos(0)
  self._ui.skill_VerticalScroll:SetEnable(true)
  self._value.servantInfo = servantInfo
  self:setHorseSkill()
  ToClient_padSnapResetControl()
  self:setSkillContent(servantInfo)
end
function Panel_Window_StableChangeSkill_info:setHorseSkill()
  local servantInfo = self._value.servantInfo
  if nil == servantInfo then
    return
  end
  local slot = self._skillSlot[self._value.currentSlotIndex]
  if nil == slot then
    return
  end
  local skillWrapper
  if true == slot.skillLearned then
    skillWrapper = servantInfo:getSkill(slot.skillNo)
  else
    skillWrapper = servantInfo:getSkillXXX(slot.skillNo)
  end
  if nil == skillWrapper then
    return
  end
  local rate = 0
  if true == slot.skillLearned then
    rate = servantInfo:getSkillExp(slot.skillNo) / (skillWrapper:getMaxExp() / 100)
  end
  self._ui.static_RightBg:SetShow(true)
  self._ui.static_Right_SkillIcon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
  self._ui.static_Right_SkillCircularProgress:SetProgressRate(rate)
  self._ui.static_Right_SkillName:SetText(skillWrapper:getName())
  self._ui.static_Right_SkillDesc:SetText(skillWrapper:getDescription())
end
function Panel_Window_StableChangeSkill_info:changeHorseSkill(skillKey)
  local servantInfo = self._value.servantInfo
  if nil == servantInfo then
    return
  end
  local skillWrapper = servantInfo:getSkill(skillKey)
  if nil == skillWrapper then
    return
  end
  local rate = servantInfo:getSkillExp(skillKey) / (skillWrapper:getMaxExp() / 100)
  self._ui.static_RightBg:SetShow(true)
  self._ui.static_Right_SkillIcon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
  self._ui.static_Right_SkillCircularProgress:SetProgressRate(rate)
  self._ui.static_Right_SkillName:SetText(skillWrapper:getName())
  self._ui.static_Right_SkillDesc:SetText(skillWrapper:getDescription())
end
function Panel_Window_StableChangeSkill_info:updateSkillContent()
  if nil == self._value.servantInfo then
    return
  end
  self:setHorseSkill()
  self:setSkillContent(self._value.servantInfo)
end
function Panel_Window_StableChangeSkill_info:setSkillContent(servantInfo)
  self._value.skillCount = servantInfo:getSkillCount()
  self._value.learnSkillCount = 0
  local temporarySlotIndex = 0
  local slotNo = 0
  for index = 0, self._config.maxSlotCount - 1 do
    local slot = self._skillSlot[index]
    slot:clear()
  end
  for ii = 1, self._value.skillCount - 1 do
    local skillWrapper = servantInfo:getSkill(ii)
    if nil ~= skillWrapper and false == skillWrapper:isTrainingSkill() then
      if slotNo < self._config.maxSlotCount then
        if temporarySlotIndex >= self._value.startSlotIndex then
          local slot = self._skillSlot[slotNo]
          slot:setSkill(servantInfo, ii, self._enum.eTYPE_LEARNED)
          slot:setShow(true)
          slotNo = slotNo + 1
        end
        temporarySlotIndex = temporarySlotIndex + 1
      end
      self._value.learnSkillCount = self._value.learnSkillCount + 1
    end
  end
  for ii = 1, self._value.skillCount - 1 do
    local skillWrapper = servantInfo:getSkillXXX(ii)
    if nil ~= skillWrapper and servantInfo:getStateType() ~= CppEnums.ServantStateType.Type_SkillTraining and false == skillWrapper:isTrainingSkill() then
      if slotNo < self._config.maxSlotCount then
        if temporarySlotIndex >= self._value.startSlotIndex then
          local slot = self._skillSlot[slotNo]
          slot:setSkill(servantInfo, ii, self._enum.eTYPE_LEARN_POSSIBLE)
          slot:setShow(true)
          slotNo = slotNo + 1
        end
        temporarySlotIndex = temporarySlotIndex + 1
      end
      self._value.learnSkillCount = self._value.learnSkillCount + 1
    end
  end
  UIScroll.SetButtonSize(self._ui.skill_VerticalScroll, self._config.maxSlotCount, self._value.learnSkillCount)
end
function Panel_Window_StableChangeSkill_info:update()
end
function Panel_Window_StableChangeSkill_info:open()
  Panel_Window_Stable_ChangeSkill:SetShow(true)
end
function Panel_Window_StableChangeSkill_info:close()
  Panel_Window_Stable_ChangeSkill:SetShow(false)
end
function PaGlobalFunc_StableChangeSkill_GetShow()
  return Panel_Window_Stable_ChangeSkill:GetShow()
end
function PaGlobalFunc_StableChangeSkill_Open()
  local self = Panel_Window_StableChangeSkill_info
  self:open()
end
function PaGlobalFunc_StableChangeSkill_Close()
  local self = Panel_Window_StableChangeSkill_info
  self:close()
end
function PaGlobalFunc_StableChangeSkill_Exit()
  local self = Panel_Window_StableChangeSkill_info
  self:close()
end
function PaGlobalFunc_StableChangeSkill_Show()
  local self = Panel_Window_StableChangeSkill_info
  self:initValue()
  self:setContent(0)
  self:open()
end
function PaGlobalFunc_StableChangeSkill_Update()
  local self = Panel_Window_StableChangeSkill_info
  self:initValue()
  self:setContent(0)
end
function PaGlobalFunc_StableChangeSkill_UpdateIsHope()
  local self = Panel_Window_StableChangeSkill_info
  self:initUpdateValue()
  self:setContent(0)
end
function PaGlobalFunc_StableChangeSkill_SelectSkill(index)
  local self = Panel_Window_StableChangeSkill_info
  self._value.lastSlotIndex = self._value.currentSlotIndex
  self._value.currentSlotIndex = index
  local lastSlot = self._skillSlot[self._value.lastSlotIndex]
  if nil ~= lastSlot then
    lastSlot:selectSlot(false)
  end
  local slot = self._skillSlot[self._value.currentSlotIndex]
  local skillKey = slot.skillNo
  local servantInfo = stable_getServant(PaGlobalFunc_StableList_SelectSlotNo())
  self._value.servantInfo = servantInfo
  self:setHorseSkill()
  if true == slot.skillCanTaining then
    self._ui.static_train:SetShow(true)
    self._ui.static_train:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_CHANGESKILL_TRAIN"))
  else
    self._ui.static_train:SetShow(false)
  end
  if true == slot.skillCanChangeOrDelete then
    self._ui.staticText_btn_X:SetShow(true)
    self._ui.staticText_btn_A:SetShow(true)
  else
    self._ui.staticText_btn_X:SetShow(false)
    self._ui.staticText_btn_A:SetShow(false)
  end
  self:realignBtnGroup()
  if Panel_Win_System:GetShow() then
    return
  end
end
function PaGlobalFunc_StableChangeSkill_SelectDelete()
  if Panel_Win_System:GetShow() then
    return
  end
  if nil == PaGlobalFunc_StableList_SelectSlotNo() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_STABLE_ALERT"))
    return
  end
  local self = Panel_Window_StableChangeSkill_info
  local servantInfo = stable_getServant(PaGlobalFunc_StableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  if CppEnums.ServantStateType.Type_StallionTraining == servantInfo:getStateType() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_CONDITION_STALLIONDESC"))
    return
  end
  local slot = self._skillSlot[self._value.currentSlotIndex]
  local skillKey = slot.skillNo
  local skillWrapper = servantInfo:getSkill(skillKey)
  if nil == skillWrapper then
    return
  end
  local function deleteServantSkill()
    deleteSkillName = skillWrapper:getName()
    self._value.deleteSkillName = deleteSkillName
    stable_forgetServantSkill(PaGlobalFunc_StableList_SelectSlotNo(), skillKey)
  end
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SKILLINFO_1")
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_SKILLINFO_2", "skillName", skillWrapper:getName())
  local messageboxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = deleteServantSkill,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_StableChangeSkill_SelectHorse()
  if Panel_Win_System:GetShow() then
    return
  end
  if nil == PaGlobalFunc_StableList_SelectSlotNo() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_STABLE_ALERT"))
    return
  end
  local self = Panel_Window_StableChangeSkill_info
  local servantInfo = stable_getServant(PaGlobalFunc_StableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  local slot = self._skillSlot[self._value.currentSlotIndex]
  local skillKey = slot.skillNo
  self._value.targetChangeSkillNo = skillKey
  self:setHorseSkill()
end
function PaGlobalFunc_StableChangeSkill_SelectTaining()
  local self = Panel_Window_StableChangeSkill_info
  if nil == PaGlobalFunc_StableList_SelectSlotNo() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_STABLE_ALERT"))
    return
  end
  local servantInfo = stable_getServant(PaGlobalFunc_StableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  if CppEnums.ServantStateType.Type_StallionTraining == servantInfo:getStateType() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_CONDITION_STALLIONDESC"))
    return
  end
  local slot = self._skillSlot[self._value.currentSlotIndex]
  local skillKey = slot.skillNo
  local skillWrapper = servantInfo:getSkill(skillKey)
  local skillName = skillWrapper:getName()
  local skillCount = stable_getStallionTrainingSkillCount()
  for i = 0, skillCount - 1 do
    local stallionSkillWrapper = stable_getStallionTrainingSkillListAt(i)
    local stallionSkillWrapperName = stallionSkillWrapper:getName()
    if skillName == stallionSkillWrapperName then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_STABLE_ALERT"))
      return
    end
  end
  if nil == PaGlobalFunc_StableList_SelectSlotNo() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_STABLE_ALERT"))
    return
  end
  if Panel_Win_System:GetShow() then
    return
  end
  local function trainHorse()
    local self = Panel_Window_StableChangeSkill_info
    local slot = self._skillSlot[self._value.currentSlotIndex]
    local skillKey = slot.skillNo
    stable_startServantSkillExpTraining(PaGlobalFunc_StableList_SelectSlotNo(), skillKey)
  end
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_SKILLTRAININGTITLE")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_SKILLTRAININGCONTENT")
  local messageboxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = trainHorse,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_StableChangeSkill_SelectTainingALL()
  if nil == PaGlobalFunc_StableList_SelectSlotNo() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_STABLE_ALERT"))
    return
  end
  local servantInfo = stable_getServant(PaGlobalFunc_StableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  if CppEnums.ServantStateType.Type_StallionTraining == servantInfo:getStateType() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_CONDITION_STALLIONDESC"))
    return
  end
  if Panel_Win_System:GetShow() then
    return
  end
  local trainHorse = function()
    stable_startServantSkillExpTraining(PaGlobalFunc_StableList_SelectSlotNo(), 0)
  end
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_SKILLTRAININGTITLE")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_ALLSKILLTRAININGCONTENT")
  local messageboxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = trainHorse,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_StableChangeSkill_PadButton_X()
  local self = Panel_Window_StableChangeSkill_info
  local slot = self._skillSlot[self._value.currentSlotIndex]
  if nil == slot then
    return
  end
  if true == slot.skillCanChangeOrDelete then
    PaGlobalFunc_StableChangeSkill_SelectDelete()
  else
    return
  end
end
function PaGlobalFunc_StableChangeSkill_PadButtonDown_A()
  local self = Panel_Window_StableChangeSkill_info
  local slot = self._skillSlot[self._value.currentSlotIndex]
  if nil ~= slot and true == slot.skillLearned then
    PaGlobalFunc_StableChangeSkillSelect_Open(slot.skillNo)
  end
end
function PaGlobalFunc_StableChangeSkill_PadButtonUP_Y()
  local self = Panel_Window_StableChangeSkill_info
  local slot = self._skillSlot[self._value.currentSlotIndex]
  if nil == slot then
    return
  end
  if true == slot.skillCanTaining then
    PaGlobalFunc_StableChangeSkill_SelectTaining()
    return
  end
end
function PaGlobalFunc_StableChangeSkill_ScrollEvent(isScrollUp)
  local self = Panel_Window_StableChangeSkill_info
  local beforeSlotIndex = self._value.startSlotIndex
  self._value.startSlotIndex = UIScroll.ScrollEvent(self._ui.skill_VerticalScroll, isScrollUp, self._config.slotRow, self._value.learnSkillCount, self._value.startSlotIndex, self._config.slotCol)
  if (ToClient_isConsole() or ToClient_IsDevelopment()) and beforeSlotIndex ~= self._value.startSlotIndex then
    ToClient_padSnapIgnoreGroupMove()
  end
  if beforeSlotIndex ~= self._value.startSlotIndex then
    self:updateSkillContent()
    PaGlobalFunc_StableChangeSkill_SelectSkill(self._value.currentSlotIndex)
  end
end
function FromClient_StableChangeSkil_Init()
  local self = Panel_Window_StableChangeSkill_info
  self:initialize()
end
function FromClient_StableChangeSkil_Resize()
  local self = Panel_Window_StableChangeSkill_info
  self:resize()
end
function FromClient_StableChangeSkil_ForgetServantSkill(servantNo, skillKey)
  local self = Panel_Window_StableChangeSkill_info
  local msg
  if nil ~= self._value.deleteSkillName then
    msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_SKILLINFO_3", "deleteSkillName", deleteSkillName)
  else
    msg = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SKILLINFO_4")
  end
  Proc_ShowMessage_Ack_WithOut_ChattingMessage(msg)
  self._value.deleteSkillName = nil
  PaGlobalFunc_StableChangeSkill_Update()
end
function FromClient_StableChangeSkil_ChangeSkill_Complete(oldSkillKey, newSkillKey)
  local self = Panel_Window_StableChangeSkill_info
  PaGlobalFunc_StableChangeSkill_Update()
  self:changeHorseSkill(newSkillKey)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_StableChangeSkil_Init")
