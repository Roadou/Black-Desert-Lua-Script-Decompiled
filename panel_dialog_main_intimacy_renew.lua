local Panel_Dialog_Main_Intimacy_Info = {
  _initialize = false,
  _ui = {
    static_IntimacyBg = UI.getChildControl(Panel_Dialog_Main, "Static_IntimacyBg"),
    static_IntimacyProgressBg = nil,
    circularProgress_IntimacyProgress = nil,
    static_RewardIconTemplete = nil,
    staticText_RewardTemplete = nil,
    static_Reward_List = {
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil
    },
    staticText_CurrentIntimacyPoint = nil,
    staticText_Intimacy_Title = nil
  },
  _config = {maxIntimacyRewardCount = 8},
  _value = {isShowOnce = false},
  _text = {
    hasMentalCardText = PAGetString(Defines.StringSheet_GAME, "LUA_INTIMACY_INFORMATION_HASMENTALCARD"),
    hasntMentalCardText = PAGetString(Defines.StringSheet_GAME, "LUA_INTIMACY_INFORMATION_HASNTMENTALCARD")
  },
  _pos = {
    rewardTextPos = {X = nil, Y = nil}
  },
  _space = {progressToReward = 64, rewardTextHBorder = 27},
  _intimacyIcon = {
    [0] = {
      [1] = {
        texture = "Renewal/UI_Icon/Console_Icon_00.dds",
        x1 = 38,
        y1 = 200,
        x2 = 65,
        y2 = 227
      },
      [2] = {
        texture = "Renewal/UI_Icon/Console_Icon_00.dds",
        x1 = 94,
        y1 = 200,
        x2 = 121,
        y2 = 227
      },
      [3] = {
        texture = "Renewal/UI_Icon/Console_Icon_00.dds",
        x1 = 66,
        y1 = 200,
        x2 = 93,
        y2 = 227
      }
    },
    [1] = {
      texture = "Renewal/UI_Icon/Console_Icon_00.dds",
      x1 = 150,
      y1 = 200,
      x2 = 177,
      y2 = 227
    },
    [2] = {
      texture = "Renewal/UI_Icon/Console_Icon_00.dds",
      x1 = 122,
      y1 = 200,
      x2 = 149,
      y2 = 227
    },
    [3] = {
      texture = "Renewal/UI_Icon/Console_Icon_00.dds",
      x1 = 178,
      y1 = 200,
      x2 = 205,
      y2 = 227
    },
    [4] = {
      texture = "Renewal/UI_Icon/Console_Icon_00.dds",
      x1 = 231,
      y1 = 1,
      x2 = 253,
      y2 = 23
    },
    [5] = {
      texture = "Renewal/UI_Icon/Console_Icon_00.dds",
      x1 = 231,
      y1 = 24,
      x2 = 205,
      y2 = 227
    }
  },
  _math_AddVectorToVector = Util.Math.AddVectorToVector,
  _math_MulNumberToVector = Util.Math.MulNumberToVector
}
function Panel_Dialog_Main_Intimacy_Info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_onScreenResize_MainDialog_Intimacy")
  registerEvent("FromClient_VaryIntimacy", "FromClient_Update_MainDialog_Intimacy")
end
function FromClient_Update_MainDialog_Intimacy()
  PaGlobalFunc_MainDialog_Intimacy_Update()
end
function Panel_Dialog_Main_Intimacy_Info:initialize()
  self:close()
  self:initControl()
  self._initialize = true
  self:registerMessageHandler()
end
function Panel_Dialog_Main_Intimacy_Info:initControl()
  self._ui.static_IntimacyProgressBg = UI.getChildControl(self._ui.static_IntimacyBg, "Static_IntimacyProgressBg")
  self._ui.circularProgress_IntimacyProgress = UI.getChildControl(self._ui.static_IntimacyBg, "CircularProgress_IntimacyProgress")
  self._ui.static_RewardIconTemplete = UI.getChildControl(self._ui.static_IntimacyBg, "Static_RewardIconTemplete")
  self._ui.staticText_RewardTemplete = UI.getChildControl(self._ui.static_IntimacyBg, "StaticText_RewardTemplete")
  for index = 0, self._config.maxIntimacyRewardCount - 1 do
    local reward_slot = {}
    reward_slot.reward_Icon = UI.createAndCopyBasePropertyControl(self._ui.static_IntimacyBg, "Static_RewardIconTemplete", self._ui.static_IntimacyBg, "Reward_Icon_" .. index)
    reward_slot.reward = UI.createAndCopyBasePropertyControl(self._ui.static_IntimacyBg, "StaticText_RewardTemplete", self._ui.static_IntimacyBg, "Reward" .. index)
    self._ui.static_Reward_List[index] = reward_slot
  end
  self._ui.static_RewardIconTemplete:SetShow(false)
  self._ui.staticText_RewardTemplete:SetShow(false)
  self._ui.staticText_CurrentIntimacyPoint = UI.getChildControl(self._ui.static_IntimacyBg, "StaticText_CurrentIntimacyPoint")
  self._ui.staticText_Intimacy_Title = UI.getChildControl(self._ui.static_IntimacyBg, "StaticText_Title")
end
function Panel_Dialog_Main_Intimacy_Info:open()
  self._ui.static_IntimacyBg:SetShow(true)
end
function Panel_Dialog_Main_Intimacy_Info:close()
  self._ui.static_IntimacyBg:SetShow(false)
end
function Panel_Dialog_Main_Intimacy_Info:update()
  self:close()
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    ToClient_PopDialogueFlush()
    return
  end
  local talker = dialog_getTalker()
  if nil ~= talker then
    local characterKey = talker:getCharacterKey()
    local npcData = getNpcInfoByCharacterKeyRaw(characterKey, talker:get():getDialogIndex())
    if nil ~= npcData and true == npcData:hasSpawnType(CppEnums.SpawnType.eSpawnType_intimacy) then
      if true == self._value.isShowOnce then
        return
      end
      self:open()
      self._value.isShowOnce = true
      local intimacy = getIntimacyByCharacterKey(characterKey)
      local valuePercent = intimacy / 1000 * 100
      if valuePercent > 100 then
        valuePercent = 100
      end
      self._ui.circularProgress_IntimacyProgress:SetProgressRate(valuePercent)
      self._ui.staticText_CurrentIntimacyPoint:SetText(intimacy)
      self:Update_Intimacy_reward(characterKey, intimacy)
    end
  end
end
function Panel_Dialog_Main_Intimacy_Info:Resize()
  self._ui.static_IntimacyBg:ComputePos()
  self._ui.circularProgress_IntimacyProgress:ComputePos()
  self._ui.staticText_CurrentIntimacyPoint:ComputePos()
  self._pos.rewardTextPos.X = self._ui.static_IntimacyProgressBg:GetPosX()
  self._pos.rewardTextPos.Y = self._ui.static_IntimacyProgressBg:GetSizeY() + self._space.progressToReward
end
function Panel_Dialog_Main_Intimacy_Info:Update_Intimacy_reward(characterKey, indimacy)
  local count = getIntimacyInformationCount(characterKey)
  local QuestCount = 1
  for index = 0, self._config.maxIntimacyRewardCount - 1 do
    if index < count then
      local intimacyInformationData = getIntimacyInformation(characterKey, index)
      if nil ~= intimacyInformationData then
        local percent = intimacyInformationData:getIntimacy() / 1000
        local imageType = intimacyInformationData:getTypeIndex()
        local giftName = intimacyInformationData:getTypeName()
        local giftDesc = intimacyInformationData:getTypeDescription()
        local giftMentalCardWrapper = ToClinet_getMentalCardStaticStatus(intimacyInformationData:getMentalCardKeyRaw())
        if nil ~= giftMentalCardWrapper then
          if giftMentalCardWrapper:isHasCard() then
            giftDesc = giftDesc .. self._text.hasMentalCardText
          else
            giftDesc = giftDesc .. self._text.hasntMentalCardText
          end
        end
        local RewardIcon = self._ui.static_Reward_List[index].reward_Icon
        local Rewardtext = self._ui.static_Reward_List[index].reward
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
          local ProgressBG = self._ui.static_IntimacyProgressBg
          local endSize = (ProgressBG:GetSizeX() + self._ui.static_RewardIconTemplete:GetSizeX()) / 2
          local centerPosition = float3(ProgressBG:GetPosX() + ProgressBG:GetSizeX() / 2, ProgressBG:GetPosY() + ProgressBG:GetSizeY() / 2, 0)
          lineStart = self._math_AddVectorToVector(centerPosition, self._math_MulNumberToVector(lineStart, startSize))
          lineEnd = self._math_AddVectorToVector(centerPosition, self._math_MulNumberToVector(lineEnd, endSize))
          RewardIcon:SetPosX(lineEnd.x - RewardIcon:GetSizeX() / 2)
          RewardIcon:SetPosY(lineEnd.y - RewardIcon:GetSizeY() / 2)
        end
        local PosY = self._pos.rewardTextPos.Y + index * self._space.rewardTextHBorder
        Rewardtext:SetPosY(PosY)
        Rewardtext:SetText(giftName .. ":" .. giftDesc)
        if indimacy < percent * 1000 then
          RewardIcon:SetColor(Defines.Color.C_FF888888)
          Rewardtext:SetColor(Defines.Color.C_FF888888)
          Rewardtext:SetFontColor(Defines.Color.C_FF888888)
        else
          RewardIcon:SetColor(Defines.Color.C_FFEFEFEF)
          Rewardtext:SetColor(Defines.Color.C_FFEFEFEF)
          Rewardtext:SetFontColor(Defines.Color.C_FFEFEFEF)
        end
      end
    else
      self._ui.static_Reward_List[index].reward_Icon:SetShow(false)
      self._ui.static_Reward_List[index].reward:SetShow(false)
    end
  end
end
function PaGlobalFunc_MainDialog_Intimacy_Open()
  local self = Panel_Dialog_Main_Intimacy_Info
  self:open()
end
function PaGlobalFunc_MainDialog_Intimacy_Close()
  local self = Panel_Dialog_Main_Intimacy_Info
  self:close()
end
function PaGlobalFunc_MainDialog_Intimacy_Update()
  local self = Panel_Dialog_Main_Intimacy_Info
  self:update()
end
function PaGlobalFunc_MainDialog_Intimacy_InitValue()
  local self = Panel_Dialog_Main_Intimacy_Info
  self._value.isShowOnce = false
end
function FromClient_InitMainDialog_Intimacy()
  local self = Panel_Dialog_Main_Intimacy_Info
  self:initialize()
  self:Resize()
end
function FromClient_onScreenResize_MainDialog_Intimacy()
  local self = Panel_Dialog_Main_Intimacy_Info
  self:Resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_InitMainDialog_Intimacy")
