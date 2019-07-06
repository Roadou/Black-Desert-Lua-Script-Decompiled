function PaGlobal_DialogIntimacy_All:initialize()
  if true == PaGlobal_DialogIntimacy_All._initialize then
    return
  end
  self:controlAll_Init()
  self:controlSetShow()
  for index = 0, self._maxIntimacyRewardCount - 1 do
    local rewardSlot = {}
    rewardSlot.icon = UI.createAndCopyBasePropertyControl(Panel_Npc_Intimacy_All, "Static_RewardIconTemplete", Panel_Npc_Intimacy_All, "Reward_Icon_" .. index)
    rewardSlot.reward = UI.createAndCopyBasePropertyControl(Panel_Npc_Intimacy_All, "StaticText_RewardTemplete", Panel_Npc_Intimacy_All, "Reward_" .. index)
    self._rewardList[index] = rewardSlot
    self._rewardList[index].icon:SetShow(false)
    self._rewardList[index].reward:SetShow(false)
  end
  self._rewardTextPos.x = self._ui.stc_progressBg:GetPosX()
  self._rewardTextPos.y = self._ui.stc_progressBg:GetSizeY() + self._space.progressToReward
  PaGlobal_DialogIntimacy_All:registEventHandler()
  PaGlobal_DialogIntimacy_All:validate()
  PaGlobal_DialogIntimacy_All._initialize = true
end
function PaGlobal_DialogIntimacy_All:controlAll_Init()
  if nil == Panel_Npc_Intimacy_All then
    return
  end
  self._ui.stc_title = UI.getChildControl(Panel_Npc_Intimacy_All, "StaticText_Title")
  self._ui.stc_progressBg = UI.getChildControl(Panel_Npc_Intimacy_All, "Static_IntimacyProgressBg")
  self._ui.stc_circularProgress = UI.getChildControl(Panel_Npc_Intimacy_All, "CircularProgress_IntimacyProgress")
  self._ui.stc_rewardIcon = UI.getChildControl(Panel_Npc_Intimacy_All, "Static_RewardIconTemplete")
  self._ui.stc_rewardTemplete = UI.getChildControl(Panel_Npc_Intimacy_All, "StaticText_RewardTemplete")
  self._ui.txt_currentIntimacy = UI.getChildControl(Panel_Npc_Intimacy_All, "StaticText_CurrentIntimacyPoint")
end
function PaGlobal_DialogIntimacy_All:controlSetShow()
  if nil == Panel_Npc_Intimacy_All then
    return
  end
  self._ui.stc_rewardIcon:SetShow(false)
  self._ui.stc_rewardTemplete:SetShow(false)
end
function PaGlobal_DialogIntimacy_All:resize()
  if nil == Panel_Npc_Intimacy_All then
    return
  end
end
function PaGlobal_DialogIntimacy_All:prepareOpen()
  if nil == Panel_Npc_Intimacy_All then
    return
  end
  local talker = dialog_getTalker()
  if nil == talker then
    PaGlobalFunc_DialogIntimacy_All_Close()
    return
  end
  PaGlobal_DialogIntimacy_All:resize()
  PaGlobal_DialogIntimacy_All:open()
  PaGlobal_DialogIntimacy_All:intimacyValueUpdate()
end
function PaGlobal_DialogIntimacy_All:open()
  if nil == Panel_Npc_Intimacy_All then
    return
  end
  Panel_Npc_Intimacy_All:SetShow(true)
end
function PaGlobal_DialogIntimacy_All:prepareClose()
  if nil == Panel_Npc_Intimacy_All then
    return
  end
  PaGlobal_DialogIntimacy_All:close()
end
function PaGlobal_DialogIntimacy_All:close()
  if nil == Panel_Npc_Intimacy_All then
    return
  end
  Panel_Npc_Intimacy_All:SetShow(false)
end
function PaGlobal_DialogIntimacy_All:update()
  if nil == Panel_Npc_Intimacy_All then
    return
  end
end
function PaGlobal_DialogIntimacy_All:validate()
  if nil == Panel_Npc_Intimacy_All then
    return
  end
  self._ui.stc_title:isValidate()
  self._ui.stc_progressBg:isValidate()
  self._ui.stc_circularProgress:isValidate()
  self._ui.stc_rewardIcon:isValidate()
  self._ui.stc_rewardTemplete:isValidate()
  self._ui.txt_currentIntimacy:isValidate()
end
function PaGlobal_DialogIntimacy_All:registEventHandler()
  if nil == Panel_Npc_Intimacy_All then
    return
  end
  self._ui.stc_circularProgress:addInputEvent("Mouse_On", "HandleEventOnOut_DialogIntimacy_All_CircleTooltip(true)")
  self._ui.stc_circularProgress:addInputEvent("Mouse_Out", "HandleEventOnOut_DialogIntimacy_All_CircleTooltip(false)")
end
function PaGlobal_DialogIntimacy_All:intimacyValueUpdate()
  if nil == Panel_Npc_Intimacy_All then
    return
  end
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    ToClient_PopDialogueFlush()
    return
  end
  local talker = dialog_getTalker()
  local index = 0
  self._intimacyValueBuffer = {}
  local characterKey = talker:getCharacterKey()
  local npcData = getNpcInfoByCharacterKeyRaw(characterKey, talker:get():getDialogIndex())
  if nil ~= npcData and true == npcData:hasSpawnType(CppEnums.SpawnType.eSpawnType_intimacy) then
    local intimacy = getIntimacyByCharacterKey(characterKey)
    self._ui.stc_title:SetShow(true)
    self._ui.txt_currentIntimacy:SetShow(true)
    self._ui.txt_currentIntimacy:SetText(tostring(intimacy))
    local valuePercent = intimacy / 1000 * 100
    if valuePercent > 100 then
      valuePercent = 100
    end
    self._ui.stc_progressBg:SetShow(true)
    self._ui.stc_circularProgress:SetShow(true)
    self._ui.stc_circularProgress:SetProgressRate(valuePercent)
    self:updateIntimacyReward(characterKey, intimacy)
    return
  end
  PaGlobalFunc_DialogIntimacy_All_Close()
end
function PaGlobal_DialogIntimacy_All:updateIntimacyReward(characterKey, intimacy)
  if nil == Panel_Npc_Intimacy_All then
    return
  end
  local count = getIntimacyInformationCount(characterKey)
  local QuestCount = 1
  for index = 0, self._maxIntimacyRewardCount - 1 do
    if index < count then
      local intimacyInformationData = getIntimacyInformation(characterKey, index)
      if nil ~= intimacyInformationData then
        local percent = intimacyInformationData:getIntimacy() / 1000
        local imageType = intimacyInformationData:getTypeIndex()
        local giftName = intimacyInformationData:getTypeName()
        local giftDesc = intimacyInformationData:getTypeDescription()
        local RewardIcon = self._rewardList[index].icon
        local Rewardtext = self._rewardList[index].reward
        local giftMentalCardWrapper = ToClinet_getMentalCardStaticStatus(intimacyInformationData:getMentalCardKeyRaw())
        if nil ~= giftMentalCardWrapper then
          if giftMentalCardWrapper:isHasCard() then
            giftDesc = giftDesc .. " <PAColor0xFFF5BA3A>" .. self._text.hasMentalCardText .. "<PAOldColor>"
            Rewardtext:SetColor(Defines.Color.C_FFFFEDD4)
            RewardIcon:SetColor(Defines.Color.C_FFFFEDD4)
            Rewardtext:SetFontColor(Defines.Color.C_FFFFEDD4)
            RewardIcon:SetAlpha(1)
            Rewardtext:SetAlpha(1)
          else
            giftDesc = giftDesc .. " " .. self._text.hasntMentalCardText
            Rewardtext:SetColor(Defines.Color.C_FF585453)
            RewardIcon:SetColor(Defines.Color.C_FF585453)
            Rewardtext:SetFontColor(Defines.Color.C_FF5A5A5A)
            RewardIcon:SetAlpha(0.8)
            Rewardtext:SetAlpha(0.8)
          end
        end
        local IconType
        if 0 == imageType then
          IconType = self._intimacyIcon[imageType][QuestCount]
          QuestCount = QuestCount + 1
          if QuestCount > 3 then
            QuestCount = 3
          end
        else
          IconType = self._intimacyIcon[imageType]
        end
        RewardIcon:ChangeTextureInfoName(IconType.texture)
        local x1, y1, x2, y2 = setTextureUV_Func(RewardIcon, IconType.x1, IconType.y1, IconType.x2, IconType.y2)
        RewardIcon:getBaseTexture():setUV(x1, y1, x2, y2)
        RewardIcon:setRenderTexture(RewardIcon:getBaseTexture())
        RewardIcon:SetShow(true)
        Rewardtext:ChangeTextureInfoName(IconType.texture)
        local x1, y1, x2, y2 = setTextureUV_Func(Rewardtext, IconType.x1, IconType.y1, IconType.x2, IconType.y2)
        Rewardtext:getBaseTexture():setUV(x1, y1, x2, y2)
        Rewardtext:setRenderTexture(Rewardtext:getBaseTexture())
        Rewardtext:SetShow(true)
        if percent >= 0 and percent <= 1 and ToClient_checkIntimacyInformationFixedState(intimacyInformationData) then
          local angle = math.pi * 2 * percent
          local lineStart = float3(math.sin(angle), -math.cos(angle), 0)
          local lineEnd = float3(math.sin(angle), -math.cos(angle), 0)
          local startSize = 28
          local ProgressBG = self._ui.stc_progressBg
          local endSize = (ProgressBG:GetSizeX() + self._ui.stc_rewardTemplete:GetSizeX()) / 2
          local centerPosition = float3(ProgressBG:GetPosX() + ProgressBG:GetSizeX() / 2, ProgressBG:GetPosY() + ProgressBG:GetSizeY() / 2, 0)
          lineStart = self._math_AddVectorToVector(centerPosition, self._math_MulNumberToVector(lineStart, startSize))
          lineEnd = self._math_AddVectorToVector(centerPosition, self._math_MulNumberToVector(lineEnd, endSize))
          RewardIcon:SetPosX(lineEnd.x - RewardIcon:GetSizeX() / 2)
          RewardIcon:SetPosY(lineEnd.y - RewardIcon:GetSizeY() / 2)
        end
        local giftValue = ""
        local giftOperator = intimacyInformationData:getOperatorType()
        giftValue = "(" .. self._operatorString[giftOperator] .. " " .. percent * 1000 .. ")"
        local PosY = self._rewardTextPos.y + index * self._space.rewardTextHBorder
        Rewardtext:SetPosY(PosY)
        Rewardtext:SetText(giftName .. " : " .. giftDesc .. " " .. giftValue)
      end
    else
      self._rewardList[index].icon:SetShow(false)
      self._rewardList[index].reward:SetShow(false)
    end
  end
end
