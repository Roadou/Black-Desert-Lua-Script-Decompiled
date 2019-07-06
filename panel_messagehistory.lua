local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
Panel_MessageHistory:SetShow(false)
Panel_MessageHistory:RegisterShowEventFunc(true, "MessageHistory_ShowAni()")
Panel_MessageHistory:RegisterShowEventFunc(false, "MessageHistory_HideAni()")
Panel_MessageHistory:ActiveMouseEventEffect(true)
Panel_MessageHistory_BTN:SetShow(false)
local thisWidgetComplete = false
local MessageHistory = {
  content = UI.getChildControl(Panel_MessageHistory, "StaticText_Content"),
  autoPop = UI.getChildControl(Panel_MessageHistory, "CheckButton_AutoPopUp"),
  BTN_Next = UI.getChildControl(Panel_MessageHistory, "Button_Next"),
  BTN_Confirm = UI.getChildControl(Panel_MessageHistory, "Button_Confirm"),
  contentCount = UI.getChildControl(Panel_MessageHistory, "StaticText_Page"),
  closeBTN = UI.getChildControl(Panel_MessageHistory, "Button_Close"),
  badges = UI.getChildControl(Panel_MessageHistory_BTN, "StaticText_badges"),
  badgesBTN = UI.getChildControl(Panel_MessageHistory_BTN, "Static_BTN"),
  thisPage = 1,
  msgCount = 0,
  elapsedTime = 0,
  hideAniPlay = false
}
local screenX = getScreenSizeX()
local screenY = getScreenSizeY()
local panelSizeX = Panel_MessageHistory:GetSizeX()
local panelSizeY = Panel_MessageHistory:GetSizeY()
local Acquire_Enum = {
  LevelUp = 0,
  GainProductSkillPoint = 1,
  GainCombatSkillPoint = 2,
  GainGuildSkillPoint = 3,
  LearnSkill = 4,
  SkillLearnable = 5,
  SkillAwakened = 6,
  QuestAccept = 7,
  QuestFailed = 8,
  QuestComplete = 9,
  GetRareItem = 10,
  DiscoveryExplorationNode = 11,
  UpgradeExplorationNode = 12,
  LearnMentalCard = 13,
  ServantLevelUp = 14,
  GainExplorePoint = 15,
  Detected = 16,
  AddNpcWorker = 17,
  GetAlchemy = 18,
  GetManufacture = 19,
  LearnGuildSkill = 20,
  MentalThemeComplete = 21,
  ProductLevelUp = 22,
  GetFishEncyclopedia = 23,
  UpdateFishLength = 24,
  GetFish = 25,
  AcquiredTitle = 26,
  ServantLearnSkill = 27,
  ServantSkillMaster = 28,
  Normal = 0,
  Viliage = 1,
  City = 2,
  Gate = 3,
  Farm = 4,
  Filtration = 5,
  Collect = 6,
  Quarry = 7,
  Logging = 8,
  Deco_Tree = 9
}
local objectMessage = {
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_OBJECTMESSAGE_LIFEPOINT"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_OBJECTMESSAGE_COMBATPOINT"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_OBJECTMESSAGE_GUILDPOINT"),
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_OBJECTMESSAGE_FINDTOWN"),
  "",
  "",
  "",
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_OBJECTMESSAGE_DETECT"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_OBJECTMESSAGE_CONTRACT"),
  "",
  "",
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_OBJECTMESSAGE_GUILDSKILL"),
  "",
  ""
}
local productLevelUpObejctMessage = {
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_PRODUCTLEVELUP_GATHERING"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_PRODUCTLEVELUP_FISH"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_PRODUCTLEVELUP_HUNT"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_PRODUCTLEVELUP_COOK"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_PRODUCTLEVELUP_ALCHEMY"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_PRODUCTLEVELUP_MANUFACTURE"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_PRODUCTLEVELUP_OBEDIENCE"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_PRODUCTLEVELUP_TRADE"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_PRODUCTLEVELUP_SAIL")
}
local massagePool = Array.new()
function MessageHistory_ShowAni()
  local MoveAni1 = Panel_MessageHistory:addMoveAnimation(0, 0.3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MoveAni1:SetStartPosition(screenX - panelSizeX - 10, screenY)
  MoveAni1:SetEndPosition(screenX - panelSizeX - 10, screenY - panelSizeY - 40)
  MoveAni1.IsChangeChild = true
  local MoveAni2 = Panel_MessageHistory:addMoveAnimation(0.3, 0.4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MoveAni2:SetStartPosition(screenX - panelSizeX - 10, screenY - panelSizeY - 40)
  MoveAni2:SetEndPosition(screenX - panelSizeX - 10, screenY - panelSizeY - 30)
  MoveAni2.IsChangeChild = true
end
function MessageHistory_HideAni()
end
function MessageHistory:init()
  self.content:SetAutoResize(true)
  self.content:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.autoPop:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_AutoPop"))
  self.autoPop:SetEnableArea(0, 0, self.autoPop:GetSizeX() + self.autoPop:GetTextSizeX(), self.autoPop:GetSizeY())
  self.autoPop:SetCheck(true)
  self.badges:SetText(self.msgCount)
end
function MessageHistory:setContent(type, msg, func)
  self.content:SetText(msg)
end
function FGlobal_MessageHistory_InputMSG(type, msg, func)
  if not thisWidgetComplete then
    return
  end
  local self = MessageHistory
  massagePool:push_back({
    [0] = type,
    [1] = msg,
    [2] = func
  })
  self.msgCount = massagePool:length()
  self.thisPage = 1
  MessageHistory.badges:SetText(self.msgCount)
  if not Panel_MessageHistory:GetShow() then
    self:PrintMsg()
  else
    self:Update()
  end
end
function MessageHistory:PrintMsg()
  if not thisWidgetComplete then
    return
  end
  self:Update()
  self.contentCount:SetText(self.thisPage .. "/" .. self.msgCount)
  self.contentCount:SetPosY(self.content:GetSpanSize().y + self.content:GetSizeY() + 5)
  if MessageHistory.autoPop:IsCheck() and Defines.UIMode.eUIMode_Default == GetUIMode() then
    Panel_MessageHistory:SetShow(true, true)
    Panel_MessageHistory_BTN:SetShow(false)
  end
end
function MessageHistory:Update(nextBTN)
  local msg
  MessageHistory.elapsedTime = 0
  if nextBTN then
    self.thisPage = self.thisPage + 1
    msg = massagePool:pop_back()
    if 2 == self.thisPage then
      msg = massagePool:pop_back()
    end
  else
    self.thisPage = 1
    msg = massagePool[self.msgCount]
  end
  self:setContent(msg[0], msg[1], msg[2])
  if self.thisPage < self.msgCount then
    self.BTN_Next:SetShow(true)
    self.BTN_Next:SetSpanSize(35, 10)
    self.BTN_Confirm:SetSpanSize(-35, 10)
  else
    self.BTN_Next:SetShow(false)
    self.BTN_Confirm:SetSpanSize(0, 10)
  end
  self.contentCount:SetText(self.thisPage .. "/" .. self.msgCount)
  self.contentCount:SetPosY(self.content:GetSpanSize().y + self.content:GetSizeY() + 5)
end
function MessageHistory:BadgesBTN_ToggleLogic(length)
  if not thisWidgetComplete then
    return
  end
  if 0 == length then
    Panel_MessageHistory_BTN:SetShow(false)
  else
    Panel_MessageHistory_BTN:SetShow(true)
  end
end
function MessageHistory:Close()
  self.msgCount = massagePool:length()
  Panel_MessageHistory:SetShow(false, false)
  MessageHistory.badges:SetText(self.msgCount)
  self:BadgesBTN_ToggleLogic(self.msgCount)
end
function HandleClicked_MessageHistory_Close()
  local self = MessageHistory
  self:Close()
  massagePool:pop_back()
end
function HandleClicked_MessageHistory_NextMSG()
  local self = MessageHistory
  self:Update(true)
end
function HandleClicked_MessageHistory_DoFuncMSG()
  local self = MessageHistory
  if self.thisPage < self.msgCount then
    self:Update(true)
  else
    HandleClicked_MessageHistory_Close()
  end
end
function HandleClicked_MessageHistory_Open()
  local self = MessageHistory
  if 0 == self.msgCount then
    return
  end
  self:PrintMsg()
end
function messageHistory_AfterUIRestore(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  local self = MessageHistory
  if 0 == self.msgCount then
    return
  end
  self:PrintMsg()
end
function FGlobal_StealMSG(notifyMsg)
  if not thisWidgetComplete then
    return
  end
  local arcType = notifyMsg._msgType
  local arcObjectMsg
  if Acquire_Enum.GainProductSkillPoint == arcType or Acquire_Enum.GainCombatSkillPoint == arcType or Acquire_Enum.GainGuildSkillPoint == arcType or Acquire_Enum.LearnGuildSkill == arcType then
    arcObjectMsg = objectMessage[arcType]
    FGlobal_MessageHistory_InputMSG(0, PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_STEALMSG_GETSKILLPOINT", "arcObjectMsg", arcObjectMsg), 0)
  elseif Acquire_Enum.LearnSkill == arcType or Acquire_Enum.SkillLearnable == arcType then
    local skillSSW = notifyMsg:getSkillStaticstatusWrapper()
    if nil ~= skillSSW then
      local skillTypeSSW = skillSSW:getSkillTypeStaticStatusWrapper()
      if nil ~= skillTypeSSW then
        arcObjectMsg = skillTypeSSW:getName()
        FGlobal_MessageHistory_InputMSG(0, PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_STEALMSG_LEARNSKILL", "arcObjectMsg", arcObjectMsg), 0)
      end
    end
  elseif Acquire_Enum.SkillAwakened == arcType then
    local skillTypeSSW = notifyMsg:getSkillTypeStaticStatusWrapper()
    if nil ~= skillTypeSSW then
      arcObjectMsg = skillTypeSSW:getName()
      FGlobal_MessageHistory_InputMSG(0, PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_STEALMSG_SKILLAWAKENED", "arcObjectMsg", arcObjectMsg), 0)
    end
  elseif Acquire_Enum.GetRareItem == arcType then
    local itemEnchantSSW = notifyMsg:getItemEnchantStaticStatusWrapper()
    if nil ~= itemEnchantSSW then
      arcObjectMsg = itemEnchantSSW:getName()
      local arcItemGrade = itemEnchantSSW:getGradeType()
      local ItemNamecolor
      if 0 == arcItemGrade then
        ItemNamecolor = "FFC4BEBE"
      elseif 1 == arcItemGrade then
        ItemNamecolor = "FF5DFF70"
      elseif 2 == arcItemGrade then
        ItemNamecolor = "FF4B97FF"
      elseif 3 == arcItemGrade then
        ItemNamecolor = "FFFFC832"
      elseif 4 == arcItemGrade then
        ItemNamecolor = "FFFF6C00"
      else
        ItemNamecolor = "FFC4BEBE"
      end
      FGlobal_MessageHistory_InputMSG(0, PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_STEALMSG_GETRAREITEM", "ItemNamecolor", ItemNamecolor, "arcObjectMsg", arcObjectMsg), 0)
    end
  elseif Acquire_Enum.UpgradeExplorationNode == arcType then
    local explorationSSW = notifyMsg:getExplorationStaticStatusWrapper()
    if nil ~= explorationSSW then
      if Acquire_Enum.Viliage == explorationSSW:get()._nodeType or Acquire_Enum.City == explorationSSW:get()._nodeType then
        defaultMsg = objectMessage[arcType]
        arcObjectMsg = explorationSSW:getName()
      else
        arcObjectMsg = explorationSSW:getName()
      end
    end
    FGlobal_MessageHistory_InputMSG(0, PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_STEALMSG_UPGRADEEXPLORATIONNODE", "arcObjectMsg", arcObjectMsg), 0)
  elseif Acquire_Enum.LearnMentalCard == arcType then
    local mentalCardSSW = notifyMsg:getMentalCardStaticStatusWrapper()
    arcObjectMsg = mentalCardSSW:getName()
    FGlobal_MessageHistory_InputMSG(0, PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_STEALMSG_LEARNMENTALCARD", "arcObjectMsg", arcObjectMsg), 0)
  elseif Acquire_Enum.ServantLevelUp == arcType then
    local temporaryWrapper = getTemporaryInformationWrapper()
    local servantWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
    local servantName = servantWrapper:getName()
    local servantLevel = servantWrapper:getLevel()
    FGlobal_MessageHistory_InputMSG(0, PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_STEALMSG_SERVANTLEVELUP", "servantName", servantName, "servantLevel", servantLevel), 0)
  elseif Acquire_Enum.GainExplorePoint == arcType then
    FGlobal_MessageHistory_InputMSG(0, PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_STEALMSG_GAINEXPLOREPOINT"), 0)
  elseif Acquire_Enum.MentalThemeComplete == arcType then
    local mentalThemeSSW = notifyMsg:getMentalThemeStaticStatus()
    if nil ~= mentalThemeSSW then
      arcObjectMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_MENTALTHEMECOMPLETE_BODY", "wp", mentalThemeSSW:getIncreaseMaxWp())
      defaultMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_MENTALTHEMECOMPLETE_HEAD", "theme", mentalThemeSSW:getName())
    end
    FGlobal_MessageHistory_InputMSG(0, defaultMsg .. " " .. arcObjectMsg, 0)
  elseif Acquire_Enum.ProductLevelUp == arcType then
    local arcParam = Int64toInt32(notifyMsg._Param) + 1
    arcObjectMsg = productLevelUpObejctMessage[arcParam]
    FGlobal_MessageHistory_InputMSG(0, arcObjectMsg, 0)
  elseif Acquire_Enum.ServantLearnSkill == arcType then
    local temporaryWrapper = getTemporaryInformationWrapper()
    local servantWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
    local servantName = servantWrapper:getName()
    local servantLevel = servantWrapper:getLevel()
    local skillKey = Int64toInt32(notifyMsg._Param)
    local skillWrapper = servantWrapper:getSkill(learnSkillKey)
    FGlobal_MessageHistory_InputMSG(0, PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_STEALMSG_SERVANTLEARNSKILL", "servantName", servantName, "getName", skillWrapper:getName()), 0)
  elseif Acquire_Enum.ServantSkillMaster == arcType then
    local temporaryWrapper = getTemporaryInformationWrapper()
    local servantWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
    local servantName = servantWrapper:getName()
    local servantLevel = servantWrapper:getLevel()
    local skillKey = Int64toInt32(notifyMsg._Param)
    local skillWrapper = servantWrapper:getSkill(learnSkillKey)
    FGlobal_MessageHistory_InputMSG(0, PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MESSAGEHISTORY_STEALMSG_SERVANTSKILLMASTER", "servantName", servantName, "getName", skillWrapper:getName()), 0)
  end
  MessageHistory.elapsedTime = 0
  MessageHistory.hideAniPlay = false
end
function FromClient_MessageHistoryBTN_BounceLoop()
  if Panel_MessageHistory_BTN:GetShow() then
    local panelSizeX = Panel_MessageHistory_BTN:GetSizeX()
    local panelSizeY = Panel_MessageHistory_BTN:GetSizeY()
    local MoveAni1 = Panel_MessageHistory_BTN:addMoveAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    MoveAni1:SetStartPosition(screenX - panelSizeX - Panel_MessageHistory_BTN:GetSpanSize().x, screenY - panelSizeY)
    MoveAni1:SetEndPosition(screenX - panelSizeX - Panel_MessageHistory_BTN:GetSpanSize().x, screenY - panelSizeY - 15)
    MoveAni1.IsChangeChild = true
    local MoveAni2 = Panel_MessageHistory_BTN:addMoveAnimation(0.2, 0.3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    MoveAni2:SetStartPosition(screenX - panelSizeX - Panel_MessageHistory_BTN:GetSpanSize().x, screenY - panelSizeY - 15)
    MoveAni2:SetEndPosition(screenX - panelSizeX - Panel_MessageHistory_BTN:GetSpanSize().x, screenY - panelSizeY)
    MoveAni2.IsChangeChild = true
  else
    return
  end
end
function MessageHistory:registEventHandler()
  self.closeBTN:addInputEvent("Mouse_LUp", "HandleClicked_MessageHistory_Close()")
  self.BTN_Next:addInputEvent("Mouse_LUp", "HandleClicked_MessageHistory_NextMSG()")
  self.BTN_Confirm:addInputEvent("Mouse_LUp", "HandleClicked_MessageHistory_DoFuncMSG()")
  self.badgesBTN:addInputEvent("Mouse_LUp", "HandleClicked_MessageHistory_Open()")
end
function MessageHistory:registMessageHandler()
  registerEvent("EventChattingMessageUpdate", "FromClient_MessageHistoryBTN_BounceLoop")
  Panel_MessageHistory:RegisterUpdateFunc("MessageHistory_AutoShowOff")
end
function MessageHistory_AutoShowOff(deltaTime)
  local self = MessageHistory
  self.elapsedTime = self.elapsedTime + deltaTime
  if self.elapsedTime > 5 and false == self.hideAniPlay then
    local MoveAni3 = Panel_MessageHistory:addMoveAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    MoveAni3:SetStartPosition(screenX - panelSizeX - 10, screenY - panelSizeY - 30)
    MoveAni3:SetEndPosition(screenX - panelSizeX - 10, screenY - panelSizeY - 40)
    MoveAni3.IsChangeChild = true
    local MoveAni4 = Panel_MessageHistory:addMoveAnimation(0.1, 0.4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    MoveAni4:SetStartPosition(screenX - panelSizeX - 10, screenY - panelSizeY - 40)
    MoveAni4:SetEndPosition(screenX - panelSizeX - 10, screenY)
    MoveAni4.IsChangeChild = true
    self.hideAniPlay = true
  elseif self.elapsedTime > 5.5 then
    self.elapsedTime = 0
    self:Close()
  end
end
MessageHistory:init()
MessageHistory:registEventHandler()
MessageHistory:registMessageHandler()
registerEvent("FromClient_RenderModeChangeState", "messageHistory_AfterUIRestore")
