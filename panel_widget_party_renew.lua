local isContentsEnable = ToClient_IsContentsGroupOpen("38")
local isLargePartyOpen = ToClient_IsContentsGroupOpen("286")
local CT2S = CppEnums.ClassType2String
local PLT = CppEnums.PartyLootType
local PLT2S = CppEnums.PartyLootType2String
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
local UI_Class = CppEnums.ClassType
local PP = CppEnums.PAUIMB_PRIORITY
local Panel_Widget_Party_info = {
  _ui = {
    static_Party_Template = nil,
    static_Master = nil,
    static_ClassIconBg = nil,
    static_ClassIcon = nil,
    static_HpBg = nil,
    progress2_Hp = nil,
    static_MpBg = nil,
    progress2_Mp = nil,
    staticText_Level = nil,
    staticText_Name = nil,
    static_ExpBonusBg = nil,
    static_Bubble1 = nil,
    static_Bubble2 = nil,
    static_Bubble3 = nil,
    static_Bubble4 = nil
  },
  _value = {
    partyType = CppEnums.PartyType.ePartyType_Normal,
    isMaster = false,
    lootType = nil,
    partyMemberCount = 0,
    invitePartyType = 0,
    inviteName = ""
  },
  _config = {
    maxPartyMemberCount = 20,
    slotRow = 10,
    slotCol = 2
  },
  _pos = {
    templeteSizeX = 0,
    templeteSizeY = 0,
    templeteSpaceX = 4,
    templeteSpaceY = 4
  },
  _color = {
    default = Defines.Color.C_FFEEEEEE,
    dead = Defines.Color.C_FF525B6D
  },
  _texture = {
    ["path"] = "Renewal/UI_Icon/Console_ClassSymbol.dds",
    [0] = {
      x1 = 1,
      x2 = 172,
      y1 = 57,
      y2 = 228
    },
    [4] = {
      x1 = 58,
      x2 = 172,
      y1 = 114,
      y2 = 228
    },
    [8] = {
      x1 = 115,
      x2 = 172,
      y1 = 171,
      y2 = 228
    },
    [11] = {
      x1 = 400,
      x2 = 229,
      y1 = 456,
      y2 = 285
    },
    [12] = {
      x1 = 172,
      x2 = 172,
      y1 = 228,
      y2 = 228
    },
    [16] = {
      x1 = 229,
      x2 = 172,
      y1 = 285,
      y2 = 228
    },
    [17] = {
      x1 = 58,
      x2 = 114,
      y1 = 115,
      y2 = 171
    },
    [19] = {
      x1 = 286,
      x2 = 229,
      y1 = 342,
      y2 = 285
    },
    [20] = {
      x1 = 286,
      x2 = 172,
      y1 = 342,
      y2 = 228
    },
    [21] = {
      x1 = 400,
      x2 = 172,
      y1 = 456,
      y2 = 228
    },
    [23] = {
      x1 = 343,
      x2 = 229,
      y1 = 399,
      y2 = 285
    },
    [24] = {
      x1 = 343,
      x2 = 172,
      y1 = 399,
      y2 = 228
    },
    [25] = {
      x1 = 115,
      x2 = 229,
      y1 = 171,
      y2 = 285
    },
    [26] = {
      x1 = 172,
      x2 = 229,
      y1 = 228,
      y2 = 285
    },
    [27] = {
      x1 = 229,
      x2 = 229,
      y1 = 285,
      y2 = 285
    },
    [28] = {
      x1 = 1,
      x2 = 229,
      y1 = 57,
      y2 = 285
    },
    [29] = {
      x1 = 1,
      x2 = 286,
      y1 = 57,
      y2 = 342
    },
    [31] = {
      x1 = 58,
      x2 = 229,
      y1 = 114,
      y2 = 285
    }
  },
  _textureMPBar = {
    ["path"] = "Renewal/progress/Console_Progressbar_03.dds",
    [CppEnums.ClassType.ClassType_Warrior] = {
      149,
      26,
      379,
      32
    },
    [CppEnums.ClassType.ClassType_Giant] = {
      149,
      26,
      379,
      32
    },
    [CppEnums.ClassType.ClassType_Ranger] = {
      149,
      47,
      379,
      53
    },
    [CppEnums.ClassType.ClassType_Orange] = {
      149,
      47,
      379,
      53
    },
    [CppEnums.ClassType.ClassType_Sorcerer] = {
      149,
      19,
      379,
      25
    },
    [CppEnums.ClassType.ClassType_WizardWomen] = {
      149,
      19,
      379,
      25
    },
    [CppEnums.ClassType.ClassType_Wizard] = {
      149,
      19,
      379,
      25
    },
    [CppEnums.ClassType.ClassType_Valkyrie] = {
      149,
      40,
      379,
      46
    },
    [CppEnums.ClassType.ClassType_Tamer] = {
      149,
      19,
      379,
      25
    },
    [CppEnums.ClassType.ClassType_ShyWomen] = {
      149,
      47,
      379,
      53
    },
    [CppEnums.ClassType.ClassType_Lahn] = {
      149,
      26,
      379,
      32
    },
    [CppEnums.ClassType.ClassType_Combattant] = {
      149,
      26,
      379,
      32
    },
    [CppEnums.ClassType.ClassType_CombattantWomen] = {
      149,
      26,
      379,
      32
    },
    [CppEnums.ClassType.ClassType_BladeMaster] = {
      149,
      26,
      379,
      32
    },
    [CppEnums.ClassType.ClassType_BladeMasterWomen] = {
      149,
      26,
      379,
      32
    },
    [CppEnums.ClassType.ClassType_NinjaWomen] = {
      149,
      26,
      379,
      32
    },
    [CppEnums.ClassType.ClassType_Kunoichi] = {
      149,
      26,
      379,
      32
    },
    [CppEnums.ClassType.ClassType_NinjaMan] = {
      149,
      26,
      379,
      32
    },
    [CppEnums.ClassType.ClassType_DarkElf] = {
      149,
      33,
      379,
      32
    }
  },
  _requestPlayerList = {},
  _partyMemberData = {},
  _partyMemberUI = {}
}
function Panel_Widget_Party_info:registEventHandler()
end
function Panel_Widget_Party_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_Party_Resize")
  registerEvent("ResponseParty_createPartyList", "FromClient_ResponseParty_createPartyList")
  registerEvent("ResponseParty_updatePartyList", "FromClient_ResponseParty_updatePartyList")
  registerEvent("ResponseParty_invite", "FromClient_ResponseParty_invite")
  registerEvent("ResponseParty_refuse", "FromClient_ResponseParty_refuse")
  registerEvent("ResponseParty_changeLeader", "FromClient_ResponseParty_changeLeader")
  registerEvent("ResponseParty_withdraw", "FromClient_ResponseParty_withdraw")
  registerEvent("FromClient_NotifyPartyMemberPickupItem", "FromClient_NotifyPartyMemberPickupItem")
  registerEvent("FromClient_NotifyPartyMemberPickupItemFromPartyInventory", "FromClient_NotifyPartyMemberPickupItemFromPartyInventory")
  registerEvent("FromClient_RenderModeChangeState", "renderModeChange_Panel_Party")
end
function Panel_Widget_Party_info:initialize()
  self:childControl()
  self:initValue()
  self:createControl()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Widget_Party_info:initValue()
  self._value.partyType = CppEnums.PartyType.ePartyType_Normal
  self._value.isMaster = false
  self._value.partyMemberCount = 0
  self._value.invitePartyType = 0
  self._value.inviteName = ""
end
function Panel_Widget_Party_info:resize()
  self._value.partyMemberCount = RequestParty_getPartyMemberCount()
  if 0 == self._value.partyMemberCount then
    self:close()
    self._requestPlayerList = {}
  else
    if not isFlushedUI() then
      self:open()
    end
    FromClient_ResponseParty_updatePartyList()
  end
  if Panel_Party:GetRelativePosX() == -1 or Panel_Party:GetRelativePosY() == -1 then
    local initPosX = 10
    local initPosY = 200
    changePositionBySever(Panel_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
    FGlobal_InitPanelRelativePos(Panel_Party, initPosX, initPosY)
  elseif Panel_Party:GetRelativePosX() == 0 or Panel_Party:GetRelativePosY() == 0 then
    Panel_Party:SetPosX(10)
    Panel_Party:SetPosY(200)
  else
    Panel_Party:SetPosX(getScreenSizeX() * Panel_Party:GetRelativePosX() - Panel_Party:GetSizeX() / 2)
    Panel_Party:SetPosY(getScreenSizeY() * Panel_Party:GetRelativePosY() - Panel_Party:GetSizeY() / 2)
  end
  FGlobal_PanelRepostionbyScreenOut(Panel_Party)
  if true == PaGlobalFunc_TopIcon_GetShowAllCheck() then
    Panel_Party:SetPosY(PaGlobalFunc_TopIcon_GetPartyWidgetPosY() + 10)
  else
    Panel_Party:SetPosY(PaGlobalFunc_TopIcon_GetPartyWidgetPosY() - 50)
  end
end
function Panel_Widget_Party_info:childControl()
  self._ui.static_Party_Template = UI.getChildControl(Panel_Party, "Static_Party_Template")
  self._ui.static_ExpBonusBg = UI.getChildControl(self._ui.static_Party_Template, "Static_ExpBonusBg")
  self._ui.static_Party_Template:SetShow(false)
  self._pos.templeteSizeX = self._ui.static_Party_Template:GetSizeX()
  self._pos.templeteSizeY = self._ui.static_Party_Template:GetSizeY()
  self._ui.static_Master = UI.getChildControl(self._ui.static_Party_Template, "Static_Master")
  self._ui.static_ClassIconBg = UI.getChildControl(self._ui.static_Party_Template, "Static_ClassIconBg")
  self._ui.static_ClassIcon = UI.getChildControl(self._ui.static_ClassIconBg, "Static_ClassIcon")
  self._ui.static_HpBg = UI.getChildControl(self._ui.static_Party_Template, "Static_HpBg")
  self._ui.progress2_Hp = UI.getChildControl(self._ui.static_HpBg, "Progress2_Hp")
  self._ui.static_MpBg = UI.getChildControl(self._ui.static_Party_Template, "Static_MpBg")
  self._ui.progress2_Mp = UI.getChildControl(self._ui.static_MpBg, "Progress2_Mp")
  self._ui.staticText_Level = UI.getChildControl(self._ui.static_Party_Template, "StaticText_Level")
  self._ui.staticText_Name = UI.getChildControl(self._ui.static_Party_Template, "StaticText_Name")
end
function Panel_Widget_Party_info:createControl()
  for index = 0, self._config.maxPartyMemberCount - 1 do
    local slot = {
      slotNo = 0,
      classType = nil,
      templete = nil,
      static_Master = nil,
      static_ClassIconBg = nil,
      static_ClassIcon = nil,
      static_HpBg = nil,
      progress2_Hp = nil,
      static_MpBg = nil,
      progress2_Mp = nil,
      static_ExpBonusBg = nil,
      static_Bubble1 = nil,
      static_Bubble2 = nil,
      static_Bubble3 = nil,
      static_Bubble4 = nil,
      staticText_Level = nil,
      staticText_Name = nil
    }
    function slot:setPos(index)
      local partyInfo = Panel_Widget_Party_info
      local row = index % partyInfo._config.slotRow
      local col = 0
      if index < partyInfo._config.slotRow then
        col = 0
      else
        col = 1
      end
      local newPosX = 0 + col * (partyInfo._pos.templeteSizeX + partyInfo._pos.templeteSpaceX)
      local newPosY = 0 + row * (partyInfo._pos.templeteSizeY + partyInfo._pos.templeteSpaceY)
      self.templete:SetPosXY(newPosX, newPosY)
    end
    function slot:setShow(bShow)
      self.templete:SetShow(bShow)
    end
    slot.templete = UI.createAndCopyBasePropertyControl(Panel_Party, "Static_Party_Template", Panel_Party, "Static_Party_Template_" .. index)
    slot.static_Master = UI.createAndCopyBasePropertyControl(self._ui.static_Party_Template, "Static_Master", slot.templete, "Static_Master" .. index)
    slot.static_ClassIconBg = UI.createAndCopyBasePropertyControl(self._ui.static_Party_Template, "Static_ClassIconBg", slot.templete, "Static_ClassIconBg_" .. index)
    slot.static_ClassIcon = UI.createAndCopyBasePropertyControl(self._ui.static_ClassIconBg, "Static_ClassIcon", slot.static_ClassIconBg, "Static_ClassIcon_" .. index)
    slot.static_HpBg = UI.createAndCopyBasePropertyControl(self._ui.static_Party_Template, "Static_HpBg", slot.templete, "Static_HpBg_" .. index)
    slot.progress2_Hp = UI.createAndCopyBasePropertyControl(self._ui.static_HpBg, "Progress2_Hp", slot.static_HpBg, "Progress2_Hp_" .. index)
    slot.static_MpBg = UI.createAndCopyBasePropertyControl(self._ui.static_Party_Template, "Static_MpBg", slot.templete, "Static_MpBg_" .. index)
    slot.progress2_Mp = UI.createAndCopyBasePropertyControl(self._ui.static_MpBg, "Progress2_Mp", slot.static_MpBg, "Progress2_Mp_" .. index)
    slot.staticText_Level = UI.createAndCopyBasePropertyControl(self._ui.static_Party_Template, "StaticText_Level", slot.templete, "StaticText_Level_" .. index)
    slot.staticText_Name = UI.createAndCopyBasePropertyControl(self._ui.static_Party_Template, "StaticText_Name", slot.templete, "StaticText_Name_" .. index)
    slot.static_ExpBonusBg = UI.createAndCopyBasePropertyControl(self._ui.static_Party_Template, "Static_ExpBonusBg", slot.templete, "Static_ExpBonusBg_" .. index)
    slot.static_Bubble1 = UI.createAndCopyBasePropertyControl(self._ui.static_ExpBonusBg, "Static_Bubble1", slot.static_ExpBonusBg, "Static_Bubble1_" .. index)
    slot.static_Bubble2 = UI.createAndCopyBasePropertyControl(self._ui.static_ExpBonusBg, "Static_Bubble2", slot.static_ExpBonusBg, "Static_Bubble2_" .. index)
    slot.static_Bubble3 = UI.createAndCopyBasePropertyControl(self._ui.static_ExpBonusBg, "Static_Bubble3", slot.static_ExpBonusBg, "Static_Bubble3_" .. index)
    slot.static_Bubble4 = UI.createAndCopyBasePropertyControl(self._ui.static_ExpBonusBg, "Static_Bubble4", slot.static_ExpBonusBg, "Static_Bubble4_" .. index)
    slot.slotNo = index
    slot:setPos(index)
    self._partyMemberUI[index] = slot
  end
end
function Panel_Widget_Party_info:setInfo(index)
  if true == self._partyMemberData[index]._isMaster then
    self._partyMemberUI[index].static_Master:SetShow(true)
  else
    self._partyMemberUI[index].static_Master:SetShow(false)
  end
  self._partyMemberUI[index].staticText_Level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. self._partyMemberData[index]._level)
  self._partyMemberUI[index].staticText_Name:SetText(self._partyMemberData[index]._name)
  self._partyMemberUI[index].staticText_Name:SetPosX(self._partyMemberUI[index].staticText_Level:GetPosX() + self._partyMemberUI[index].staticText_Level:GetTextSizeX() + 10)
  self._partyMemberUI[index].progress2_Hp:SetProgressRate(self._partyMemberData[index]._nowHp / self._partyMemberData[index]._maxHp)
  self._partyMemberUI[index].progress2_Mp:SetProgressRate(self._partyMemberData[index]._nowMp / self._partyMemberData[index]._maxMp)
  self:setIcon(index)
  self:setMpBarTexture(index)
  self._partyMemberUI[index].classType = self._partyMemberData[index]._class
  if self._partyMemberData[index]._nowHp <= 0 then
    self._partyMemberUI[index].static_ClassIcon:SetColor(self._color.dead)
  elseif self._partyMemberData[index]._nowHp >= 1 then
    self._partyMemberUI[index].static_ClassIcon:SetColor(self._color.default)
  end
  if true == self._partyMemberData[index]._isSelf then
    self._partyMemberUI[index].static_ExpBonusBg:SetShow(false)
  else
    self._partyMemberUI[index].static_ExpBonusBg:SetShow(true)
    if 0 == self._partyMemberData[index]._distance then
      self._partyMemberUI[index].static_Bubble1:SetShow(true)
      self._partyMemberUI[index].static_Bubble2:SetShow(false)
      self._partyMemberUI[index].static_Bubble3:SetShow(false)
      self._partyMemberUI[index].static_Bubble4:SetShow(false)
    elseif 1 == self._partyMemberData[index]._distance then
      self._partyMemberUI[index].static_Bubble1:SetShow(true)
      self._partyMemberUI[index].static_Bubble2:SetShow(true)
      self._partyMemberUI[index].static_Bubble3:SetShow(false)
      self._partyMemberUI[index].static_Bubble4:SetShow(false)
    elseif 2 == self._partyMemberData[index]._distance then
      self._partyMemberUI[index].static_Bubble1:SetShow(true)
      self._partyMemberUI[index].static_Bubble2:SetShow(true)
      self._partyMemberUI[index].static_Bubble3:SetShow(true)
      self._partyMemberUI[index].static_Bubble4:SetShow(false)
    elseif 3 == self._partyMemberData[index]._distance then
      self._partyMemberUI[index].static_Bubble1:SetShow(true)
      self._partyMemberUI[index].static_Bubble2:SetShow(true)
      self._partyMemberUI[index].static_Bubble3:SetShow(true)
      self._partyMemberUI[index].static_Bubble4:SetShow(true)
    end
  end
end
function Panel_Widget_Party_info:setIcon(index)
  local classType = self._partyMemberData[index]._class
  self._partyMemberUI[index].static_ClassIcon:ChangeTextureInfoName(self._texture.path)
  local x1, y1, x2, y2 = setTextureUV_Func(self._partyMemberUI[index].static_ClassIcon, self._texture[classType].x1, self._texture[classType].x2, self._texture[classType].y1, self._texture[classType].y2)
  self._partyMemberUI[index].static_ClassIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  self._partyMemberUI[index].static_ClassIcon:setRenderTexture(self._partyMemberUI[index].static_ClassIcon:getBaseTexture())
end
function Panel_Widget_Party_info:setMpBarTexture(index)
  local classType = self._partyMemberData[index]._class
  if self._partyMemberUI[index].classType == classType then
    return
  end
  self._partyMemberUI[index].progress2_Mp:ChangeTextureInfoName(self._textureMPBar.path)
  local x1, y1, x2, y2 = setTextureUV_Func(self._partyMemberUI[index].progress2_Mp, self._textureMPBar[classType][1], self._textureMPBar[classType][2], self._textureMPBar[classType][3], self._textureMPBar[classType][4])
  self._partyMemberUI[index].progress2_Mp:getBaseTexture():setUV(x1, y1, x2, y2)
  self._partyMemberUI[index].progress2_Mp:setRenderTexture(self._partyMemberUI[index].progress2_Mp:getBaseTexture())
end
function Panel_Widget_Party_info:open()
  Panel_Party:SetShow(true)
end
function Panel_Widget_Party_info:close()
  Panel_Party:SetShow(false)
end
function Panel_Widget_Party_info:updatePartyList()
  self._value.partyMemberCount = RequestParty_getPartyMemberCount()
  self._value.isMaster = RequestParty_isLeader()
  self._partyMemberData = PaGlobalFunc_ResponseParty_PartyMemberSet(self._value.partyMemberCount)
  if nil == self._partyMemberData[0] then
    self:close()
    return
  end
  for index = 0, self._config.maxPartyMemberCount - 1 do
    self._partyMemberUI[index]:setShow(false)
    if index < self._value.partyMemberCount then
      self._partyMemberUI[index]:setShow(true)
      self:setInfo(index)
    end
  end
  local lootType = RequestParty_getPartyLootType()
  if nil ~= self._value.lootType and self._value.lootType ~= lootType then
    local rottingMsg = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_CHANGE_LOOTING_RULE1", "plt2s_lootType", PLT2S[lootType])
    Proc_ShowMessage_Ack(rottingMsg)
  end
  self._value.lootType = lootType
end
function Panel_Widget_Party_info:partyRefuse()
  RequestParty_refuseInvite()
  for ii = 0, #self._requestPlayerList do
    if self._requestPlayerList[ii] == self._value.inviteName then
      self._requestPlayerList[ii] = ""
      self._value.inviteName = ""
      return
    end
  end
end
function PaGlobalFunc_Party_GetShow()
  return Panel_Party:GetShow()
end
function PaGlobalFunc_Party_Open()
  local self = Panel_Widget_Party_info
  self:open()
end
function PaGlobalFunc_Party_Close()
  local self = Panel_Widget_Party_info
  self:close()
end
function PaGlobalFunc_Party_Show()
  local self = Panel_Widget_Party_info
  self:updatePartyList()
end
function PaGlobalFunc_Party_Exit()
  local self = Panel_Widget_Party_info
  self:close()
end
function PaGlobalFunc_ResponseParty_PartyMemberSet(partyMemberCount)
  local partyData = {}
  for index = 0, partyMemberCount - 1 do
    local idx = 0
    local memberData = RequestParty_getPartyMemberAt(index)
    local memberTable = {}
    memberTable._index = index
    memberTable._isMaster = memberData._isMaster
    memberTable._isSelf = RequestParty_isSelfPlayer(index)
    memberTable._name = memberData:name()
    memberTable._class = memberData:classType()
    memberTable._level = memberData._level
    memberTable._nowHp = memberData._hp * 100
    memberTable._maxHp = memberData._maxHp
    memberTable._nowMp = memberData._mp * 100
    memberTable._maxMp = memberData._maxMp
    memberTable._distance = memberData:getExperienceGrade()
    if true == memberTable._isSelf and true == memberTable._isMaster then
      isSelfMaster = true
    end
    if true == memberTable._isSelf and 0 ~= index then
      local tempTable = partyData[0]
      partyData[0] = memberTable
      partyData[index] = tempTable
    else
      partyData[index] = memberTable
    end
  end
  return partyData
end
function FGlobal_PartyMemberCount()
  local self = Panel_Widget_Party_info
  return self._value.partyMemberCount
end
function PaGlobalFunc_PartyAccept()
  local self = Panel_Widget_Party_info
  self._requestPlayerList = {}
  RequestParty_acceptInvite(self._value.invitePartyType)
  self._value.invitePartyType = CppEnums.PartyType.ePartyType_Normal
end
function PaGlobalFunc_PartyRefuse()
  local self = Panel_Widget_Party_info
  RequestParty_refuseInvite()
  for ii = 0, #self._requestPlayerList do
    if self._requestPlayerList[ii] == self._value.inviteName then
      self._requestPlayerList[ii] = ""
      self._value.inviteName = ""
      return
    end
  end
end
function PaGlobalFunc_Party_CheckInParty(name)
  local self = Panel_Widget_Party_info
  local retval = false
  for key, value in pairs(self._partyMemberData) do
    if value._name == name then
      retval = true
      break
    end
  end
  return retval
end
function FGlobal_CheckPartyListUiEdit()
  return false
end
function FGlobal_CheckPartyListRecruiteUiEdit()
  return false
end
function FGlobal_PartyListClearFocusEdit()
end
function FGlobal_PartyListUpdate()
  FromClient_ResponseParty_updatePartyList()
end
function FGlobal_Party_ConditionalShow()
  local self = Panel_Widget_Party_info
  if 0 == RequestParty_getPartyMemberCount() then
    self:close()
    self._requestPlayerList = {}
  else
    self:open()
    FromClient_ResponseParty_updatePartyList()
  end
end
function renderModeChange_Panel_Party(prevRenderModeList, nextRenderModeList)
  local self = Panel_Widget_Party_info
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  if 0 == RequestParty_getPartyMemberCount() then
    self:close()
    self._requestPlayerList = {}
  else
    self:open()
    FromClient_ResponseParty_updatePartyList()
  end
  self:resize()
end
function FromClient_Party_Init()
  local self = Panel_Widget_Party_info
  self:initialize()
end
function FromClient_Party_Resize()
  local self = Panel_Widget_Party_info
  self:resize()
end
function FromClient_ResponseParty_createPartyList()
  local self = Panel_Widget_Party_info
  self._value.partyMemberCount = RequestParty_getPartyMemberCount()
  self._value.partyType = ToClient_GetPartyType()
  if self._value.partyMemberCount > 0 then
    if CppEnums.PartyType.ePartyType_Normal == self._value.partyType then
      if not isFlushedUI() then
        self:open()
      end
      table.remove(self._requestPlayerList)
      self:updatePartyList()
    elseif CppEnums.PartyType.ePartyType_Large == self._value.partyType then
      if not isFlushedUI() then
        self:open()
      end
      table.remove(self._requestPlayerList)
      self:updatePartyList()
    end
  end
end
function FromClient_ResponseParty_updatePartyList()
  local self = Panel_Widget_Party_info
  if PaGlobalFunc_Party_GetShow() then
    self:updatePartyList()
  end
end
function FromClient_ResponseParty_invite(hostName, invitePartyType)
  local self = Panel_Widget_Party_info
  for ii = 0, #self._requestPlayerList do
    if self._requestPlayerList[ii] == hostName then
      return
    end
  end
  self._value.invitePartyType = invitePartyType
  self._value.partyType = invitePartyType
  self._value.inviteName = hostName
  self._requestPlayerList[#self._requestPlayerList] = self._value.inviteName
  local messageboxMemo = ""
  local messageboxData = ""
  if 0 == self._value.invitePartyType then
    messageboxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_INVITE_ACCEPT", "host_name", hostName)
    messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "PARTY_INVITE_MESSAGEBOX_TITLE"),
      content = messageboxMemo,
      functionYes = PaGlobalFunc_PartyAccept,
      functionNo = PaGlobalFunc_PartyRefuse,
      priority = PP.PAUIMB_PRIORITY_LOW
    }
  else
    messageboxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LARGEPARTY_INVITE_ACCEPT", "host_name", hostName)
    messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_LARGEPARTY_INVITE_MESSAGEBOX_TITLE"),
      content = messageboxMemo,
      functionYes = PaGlobalFunc_PartyAccept,
      functionNo = PaGlobalFunc_PartyRefuse,
      priority = PP.PAUIMB_PRIORITY_LOW
    }
  end
  MessageBox.showMessageBox(messageboxData)
end
function FromClient_ResponseParty_refuse(reason)
  local contentString = reason
  local messageboxData
  messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = contentString,
    functionYes = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function FromClient_ResponseParty_changeLeader(actorKey)
  local self = Panel_Widget_Party_info
  local actorProxyWrapper = getActor(actorKey)
  if nil == actorProxyWrapper then
    return
  end
  local textName = actorProxyWrapper:getName()
  if 0 == self._value.partyType then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_CHANGE_PARTY_LEADER", "text_name", tostring(textName)))
  else
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_CHANGE_PARTY_LEADER", "text_name", tostring(textName)))
  end
  self:updatePartyList()
end
function FromClient_ResponseParty_withdraw(withdrawType, actorKey, isMe)
  if ToClient_IsRequestedPvP() or ToClient_IsMyselfInEntryUser() then
    return
  end
  local self = Panel_Widget_Party_info
  local message = ""
  if 0 == withdrawType then
    if isMe then
      if 0 == self._value.partyType then
        message = PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_LEAVE_PARTY_SELF")
      else
        message = PAGetString(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_LEAVE_PARTY_SELF")
      end
    else
      local actorProxyWrapper = getActor(actorKey)
      if nil ~= actorProxyWrapper then
        local textName = actorProxyWrapper:getOriginalName()
        if 0 == self._value.partyType then
          message = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_LEAVE_PARTY_MEMBER", "text_name", tostring(textName))
        else
          message = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_LEAVE_PARTY_MEMBER", "text_name", tostring(textName))
        end
      end
    end
  elseif 1 == withdrawType then
    if isMe then
      if 0 == self._value.partyType then
        message = PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT_SELF")
      else
        message = PAGetString(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_FORCEOUT_SELF")
      end
    else
      local actorProxyWrapper = getActor(actorKey)
      if nil ~= actorProxyWrapper then
        local textName = actorProxyWrapper:getOriginalName()
        if 0 == self._value.partyType then
          message = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT_MEMBER", "text_name", tostring(textName))
        else
          message = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_FORCEOUT_MEMBER", "text_name", tostring(textName))
        end
      end
    end
  elseif 2 == withdrawType then
    if 0 == self._value.partyType then
      message = PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_DISPERSE")
    else
      message = PAGetString(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_DISPERSE")
    end
  end
  NakMessagePanel_Reset()
  if "" ~= message and nil ~= message then
    Proc_ShowMessage_Ack(message)
  end
end
function FromClient_NotifyPartyMemberPickupItem(userName, itemName)
  local message = ""
  message = PAGetStringParam2(Defines.StringSheet_GAME, "GAME_MESSAGE_NOTIFY_PARTYMEMBER_PICKUP_ITEM", "userName", userName, "itemName", itemName)
  Proc_ShowMessage_Ack_With_ChatType(message, nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.PartyItem)
end
function FromClient_NotifyPartyMemberPickupItemFromPartyInventory(userName, itemName, itemCount)
  local message = ""
  message = PAGetStringParam3(Defines.StringSheet_GAME, "GAME_MESSAGE_NOTIFY_PARTYMEMBER_PICKUP_ITEM_FOR_PARTYINVENTORY", "userName", userName, "itemName", itemName, "itemCount", tostring(itemCount))
  Proc_ShowMessage_Ack_With_ChatType(message, nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.PartyItem)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_Party_Init")
