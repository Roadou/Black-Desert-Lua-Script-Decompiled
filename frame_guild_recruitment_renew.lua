local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
local UI_classType = CppEnums.ClassType
local UI_TM = CppEnums.TextMode
Panel_Guild_Recruitment:SetShow(false)
local defaultFrameBG_Recruitment = UI.getChildControl(Panel_Window_Guild, "Static_Frame_RecruitmentBG")
local GuildRecruitment = {
  scroll = UI.getChildControl(Panel_Guild_Recruitment, "Scroll_Recruitment"),
  selectedPlayer = -1,
  maxSlotCount = 8,
  maxPlayerList = 22,
  SlotCols = 1,
  _startIndex = 0,
  slotPool = {}
}
GuildRecruitment.scroll:addInputEvent("Mouse_UpScroll", "GuildRecuit_ScrollEvent( true )")
GuildRecruitment.scroll:addInputEvent("Mouse_DownScroll", "GuildRecuit_ScrollEvent( false )")
UIScroll.InputEvent(GuildRecruitment.scroll, "GuildRecuit_ScrollEvent")
local unjoinPlayerList = {}
local classPicture = {
  [UI_classType.ClassType_Warrior] = {
    1,
    1,
    96,
    145
  },
  [UI_classType.ClassType_Ranger] = {
    97,
    1,
    192,
    145
  },
  [UI_classType.ClassType_Sorcerer] = {
    193,
    1,
    288,
    145
  },
  [UI_classType.ClassType_Giant] = {
    289,
    1,
    384,
    145
  },
  [UI_classType.ClassType_Tamer] = {
    385,
    1,
    480,
    145
  },
  [UI_classType.ClassType_BladeMaster] = {
    1,
    146,
    96,
    290
  },
  [UI_classType.ClassType_BladeMasterWomen] = {
    193,
    146,
    288,
    290
  },
  [UI_classType.ClassType_Valkyrie] = {
    97,
    146,
    192,
    290
  },
  [UI_classType.ClassType_Wizard] = {
    289,
    146,
    384,
    290
  },
  [UI_classType.ClassType_WizardWomen] = {
    385,
    146,
    480,
    290
  },
  [UI_classType.ClassType_NinjaWomen] = {
    1,
    291,
    96,
    435
  },
  [UI_classType.ClassType_NinjaMan] = {
    97,
    291,
    192,
    435
  },
  [UI_classType.ClassType_DarkElf] = {
    193,
    291,
    288,
    435
  },
  [UI_classType.ClassType_Combattant] = {
    289,
    291,
    384,
    435
  },
  [UI_classType.ClassType_CombattantWomen] = {
    385,
    291,
    480,
    435
  },
  [UI_classType.ClassType_Lahn] = {
    97,
    1,
    192,
    145
  },
  [UI_classType.ClassType_Orange] = {
    193,
    1,
    288,
    145
  }
}
function Guild_Recruitment_Initialize()
  local self = GuildRecruitment
  local slotStartY = 60
  local slotGapY = 145
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
  defaultFrameBG_Recruitment:addInputEvent("Mouse_UpScroll", "GuildRecuit_ScrollEvent( true )")
  defaultFrameBG_Recruitment:addInputEvent("Mouse_DownScroll", "GuildRecuit_ScrollEvent( false )")
  defaultFrameBG_Recruitment:MoveChilds(defaultFrameBG_Recruitment:GetID(), Panel_Guild_Recruitment)
  UI.deletePanel(Panel_Guild_Recruitment:GetID())
end
function GuildRecruitment:Update()
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
      if CppEnums.ClassType.ClassType_Lahn == playerClass or CppEnums.ClassType.ClassType_Orange == playerClass then
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
  local self = GuildRecruitment
  defaultFrameBG_Recruitment:SetShow(true)
  ToClient_RequestGuildUnjoinedPlayerList()
  self._startIndex = 0
  self.scroll:SetControlTop()
  GuildRecruitment:Update()
end
function GuildRecuit_ScrollEvent(isUp)
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
  defaultFrameBG_Recruitment:SetShow(false)
end
