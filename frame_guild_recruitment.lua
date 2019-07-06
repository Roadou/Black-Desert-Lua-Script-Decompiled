local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
local UI_classType = CppEnums.ClassType
local UI_TM = CppEnums.TextMode
local GuildRecruitment = {
  defaultFrameBG_Recruitment = nil,
  scroll = nil,
  selectedPlayer = -1,
  maxSlotCount = 8,
  maxPlayerList = 22,
  SlotCols = 1,
  _startIndex = 0,
  slotPool = {}
}
local unjoinPlayerList = {}
local classPicture = {
  [__eClassType_Warrior] = {
    1,
    1,
    96,
    145
  },
  [__eClassType_ElfRanger] = {
    97,
    1,
    192,
    145
  },
  [__eClassType_Sorcerer] = {
    193,
    1,
    288,
    145
  },
  [__eClassType_Giant] = {
    289,
    1,
    384,
    145
  },
  [__eClassType_Tamer] = {
    385,
    1,
    480,
    145
  },
  [__eClassType_BladeMaster] = {
    1,
    146,
    96,
    290
  },
  [__eClassType_BladeMasterWoman] = {
    193,
    146,
    288,
    290
  },
  [__eClassType_Valkyrie] = {
    97,
    146,
    192,
    290
  },
  [__eClassType_WizardMan] = {
    289,
    146,
    384,
    290
  },
  [__eClassType_WizardWoman] = {
    385,
    146,
    480,
    290
  },
  [__eClassType_Kunoichi] = {
    1,
    291,
    96,
    435
  },
  [__eClassType_NinjaMan] = {
    97,
    291,
    192,
    435
  },
  [__eClassType_DarkElf] = {
    193,
    291,
    288,
    435
  },
  [__eClassType_Combattant] = {
    289,
    291,
    384,
    435
  },
  [__eClassType_Mystic] = {
    385,
    291,
    480,
    435
  },
  [__eClassType_Lhan] = {
    97,
    1,
    192,
    145
  },
  [__eClassType_RangerMan] = {
    193,
    1,
    288,
    145
  },
  [__eClassType_ShyWaman] = {
    289,
    1,
    384,
    145
  }
}
function GuildRecruitment:initialize()
  if nil == Panel_Window_Guild then
    return
  end
  local slotStartY = 60
  local slotGapY = 145
  Panel_Guild_Recruitment:SetShow(false)
  self.defaultFrameBG_Recruitment = UI.getChildControl(Panel_Window_Guild, "Static_Frame_RecruitmentBG")
  self.scroll = UI.getChildControl(Panel_Guild_Recruitment, "Scroll_Recruitment")
  for slotIdx = 0, self.maxSlotCount - 1 do
    local posX = 15 + 450 * (slotIdx % 2)
    local posY = slotStartY + slotGapY * math.floor(slotIdx / 2)
    local slot = {}
    slot.bg = UI.createAndCopyBasePropertyControl(Panel_Guild_Recruitment, "Static_SampleBg", Panel_Guild_Recruitment, "GuildRecruitment_BG_" .. slotIdx)
    slot.bg:SetPosX(posX)
    slot.bg:SetPosY(posY)
    slot.bg:addInputEvent("Mouse_UpScroll", "GuildRecuit_ScrollEvent( true )")
    slot.bg:addInputEvent("Mouse_DownScroll", "GuildRecuit_ScrollEvent( false )")
    slot.charPic = UI.createAndCopyBasePropertyControl(Panel_Guild_Recruitment, "Static_CharacterPic", slot.bg, "GuildRecruitment_CharPic_" .. slotIdx)
    slot.charPic:SetPosX(7)
    slot.charPic:SetPosY(12)
    slot.name = UI.createAndCopyBasePropertyControl(Panel_Guild_Recruitment, "StaticText_FamilyName", slot.bg, "GuildRecruitment_Name_" .. slotIdx)
    slot.name:SetPosX(86)
    slot.name:SetPosY(5)
    slot.class = UI.createAndCopyBasePropertyControl(Panel_Guild_Recruitment, "StaticText_CharacterLv", slot.bg, "GuildRecruitment_Lv_" .. slotIdx)
    slot.class:SetPosX(86)
    slot.class:SetPosY(25)
    slot.intro = UI.createAndCopyBasePropertyControl(Panel_Guild_Recruitment, "StaticText_SelfIntro", slot.bg, "GuildRecruitment_Intro_" .. slotIdx)
    slot.intro:SetPosX(90)
    slot.intro:SetPosY(50)
    slot.intro:SetTextMode(UI_TM.eTextMode_Limit_AutoWrap)
    slot.intro:setLineCountByLimitAutoWrap(3)
    slot.btnRecruit = UI.createAndCopyBasePropertyControl(Panel_Guild_Recruitment, "Button_Recruit", slot.bg, "GuildRecruitment_Recruit_" .. slotIdx)
    slot.btnRecruit:SetPosX(320)
    slot.btnRecruit:SetPosY(100)
    slot.btnRecruit:addInputEvent("Mouse_UpScroll", "GuildRecuit_ScrollEvent( true )")
    slot.btnRecruit:addInputEvent("Mouse_DownScroll", "GuildRecuit_ScrollEvent( false )")
    self.slotPool[slotIdx] = slot
  end
  self.defaultFrameBG_Recruitment:MoveChilds(self.defaultFrameBG_Recruitment:GetID(), Panel_Guild_Recruitment)
end
function GuildRecruitment:registEventHandler()
  if nil == Panel_Window_Guild then
    return
  end
  self.scroll:addInputEvent("Mouse_UpScroll", "GuildRecuit_ScrollEvent( true )")
  self.scroll:addInputEvent("Mouse_DownScroll", "GuildRecuit_ScrollEvent( false )")
  UIScroll.InputEvent(self.scroll, "GuildRecuit_ScrollEvent")
  self.defaultFrameBG_Recruitment:addInputEvent("Mouse_UpScroll", "GuildRecuit_ScrollEvent( true )")
  self.defaultFrameBG_Recruitment:addInputEvent("Mouse_DownScroll", "GuildRecuit_ScrollEvent( false )")
end
function GuildRecruitment:Update()
  if nil == Panel_Window_Guild then
    return
  end
  for slotIdx = 0, self.maxSlotCount - 1 do
    local slot = self.slotPool[slotIdx]
    slot.bg:SetShow(false)
  end
  local replaceClassType = function(classNo)
    local returnValue = ""
    return CppEnums.ClassType2String[classNo]
  end
  local guildUnjoinedCount = ToClient_GetGuildUnjoinedPlayerCount()
  local playerCount = math.min(guildUnjoinedCount, self.maxPlayerList)
  local viewCount = math.min(playerCount, self.maxSlotCount)
  if playerCount > self.maxSlotCount then
    self.scroll:SetShow(true)
  else
    self.scroll:SetShow(false)
  end
  local realIndex = 0
  slotIdx = self._startIndex
  for index = 0, playerCount - 1 do
    local unjoinPlayerWrapper = ToClient_GetGuildUnjoinedPlayerAt(slotIdx)
    if nil ~= unjoinPlayerWrapper and 5 < unjoinPlayerWrapper:getLevel() and realIndex < self.maxSlotCount then
      local playerLevel = unjoinPlayerWrapper:getLevel()
      local playerClass = unjoinPlayerWrapper:getClassType()
      local playerNickName = unjoinPlayerWrapper:getUserNickName()
      local playerName = unjoinPlayerWrapper:getCharacterName()
      local isWant = unjoinPlayerWrapper:doWant()
      local playerIntro = unjoinPlayerWrapper:getUserIntroduction()
      if nil == playerIntro or "" == playerIntro then
        playerIntro = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO_NODATA", "player_name", playerName)
      end
      local slot = self.slotPool[realIndex]
      slot.bg:SetShow(true)
      if __eClassType_Lhan == playerClass or __eClassType_RangerMan == playerClass or __eClassType_ShyWaman == playerClass then
        slot.charPic:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/Lobby_ClassSelect_01.dds")
      else
        slot.charPic:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/Lobby_ClassSelect_00.dds")
      end
      local x1, y1, x2, y2 = setTextureUV_Func(slot.charPic, classPicture[playerClass][1], classPicture[playerClass][2], classPicture[playerClass][3], classPicture[playerClass][4])
      slot.charPic:getBaseTexture():setUV(x1, y1, x2, y2)
      slot.charPic:setRenderTexture(slot.charPic:getBaseTexture())
      slot.name:SetText(playerNickName .. "(" .. playerName .. ")")
      slot.class:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_INTRODUCTIONMYSELF_SUBINFO", "class", replaceClassType(playerClass), "level", playerLevel))
      slot.intro:SetText(playerIntro)
      slot.intro:SetShow(true)
      local fontColor
      if true == isWant then
        fontColor = UI_color.C_FFEE7001
      else
        fontColor = UI_color.C_FFEFEFEF
      end
      slot.btnRecruit:addInputEvent("Mouse_LUp", "GuildRecruitment_SelectPlayer( " .. slotIdx .. ", " .. realIndex .. " )")
      slot.bg:addInputEvent("Mouse_On", "GuildRecruit_Tooltip(" .. slotIdx .. ", " .. realIndex .. ")")
      slot.bg:addInputEvent("Mouse_Out", "GuildRecruit_Tooltip()")
      slotIdx = slotIdx + 1
      realIndex = realIndex + 1
    end
  end
  UIScroll.SetButtonSize(self.scroll, self.maxSlotCount, playerCount)
end
function GuildRecruitment_SelectPlayer(idx, uiIdx)
  if nil == Panel_Window_Guild then
    return
  end
  local self = GuildRecruitment
  local parentSlot = self.slotPool[uiIdx].bg
  self.selectedPlayer = idx
  local unjoinPlayerWrapper = ToClient_GetGuildUnjoinedPlayerAt(idx)
  if nil == unjoinPlayerWrapper then
    return
  end
  local playerNickName = unjoinPlayerWrapper:getUserNickName()
  local playerName = unjoinPlayerWrapper:getCharacterName()
  FGlobal_ChattingInput_ShowWhisper(playerName)
end
function GuildRecruit_Tooltip(index, count)
  if nil == index then
    TooltipSimple_Hide()
    return
  end
  if nil == Panel_Window_Guild then
    return
  end
  local unjoinPlayerList = ToClient_GetGuildUnjoinedPlayerAt(index)
  if nil == unjoinPlayerList then
    return
  end
  local name = unjoinPlayerList:getCharacterName() .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO")
  local desc = unjoinPlayerList:getUserIntroduction()
  local uiControl = GuildRecruitment.slotPool[count].bg
  if nil == desc or "" == desc then
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO_NODATA")
  end
  TooltipSimple_Show(uiControl, name, desc)
end
function Guild_Recruitment_Open()
  if nil == Panel_Window_Guild then
    return
  end
  local self = GuildRecruitment
  GuildRecruitment.defaultFrameBG_Recruitment:SetShow(true)
  ToClient_RequestGuildUnjoinedPlayerList()
  self._startIndex = 0
  self.scroll:SetControlTop()
  GuildRecruitment:Update()
end
function GuildRecuit_ScrollEvent(isUp)
  if nil == Panel_Window_Guild then
    return
  end
  local self = GuildRecruitment
  local guildUnjoinedCount = ToClient_GetGuildUnjoinedPlayerCount()
  local playerCount = math.min(guildUnjoinedCount, self.maxPlayerList)
  self._startIndex = UIScroll.ScrollEvent(self.scroll, isUp, self.maxSlotCount, playerCount, self._startIndex, 1)
  self:Update()
end
function FGolbal_Guild_Recruitment_SelectPlayerClose()
  GuildRecruitment_InvitePlayer_Close()
end
function FGolbal_Guild_Recruitment_SelectPlayerCheck()
  return false
end
function Guild_Recruitment_Close()
  GuildRecruitment.defaultFrameBG_Recruitment:SetShow(false)
end
function FromClient_GuildRecruitment_Init()
  PaGlobal_GuildRecruitment_Init()
end
function PaGlobal_GuildRecruitment_Init()
  GuildRecruitment:initialize()
  GuildRecruitment:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildRecruitment_Init")
