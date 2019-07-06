local partyWidget = {
  _ui = {
    _static_PartyMember = {},
    _static_PartyMember_Template = UI.getChildControl(Instance_Widget_Party, "Static_PartyMember_Template")
  },
  _config = {
    _maxPartyMemberCount = 5,
    _gabY = 10,
    _isContentsEnable = ToClient_IsContentsGroupOpen("38"),
    _isLargePartyOpen = ToClient_IsContentsGroupOpen("286"),
    _textureClassSymbol = {
      ["path"] = "Renewal/UI_Icon/Console_ClassSymbol.dds",
      [CppEnums.ClassType.ClassType_Warrior] = {
        x1 = 1,
        x2 = 172,
        y1 = 57,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_Temp1] = {
        x1 = 0,
        x2 = 0,
        y1 = 0,
        y2 = 0
      },
      [CppEnums.ClassType.ClassType_Ranger] = {
        x1 = 58,
        x2 = 172,
        y1 = 114,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_Sorcerer] = {
        x1 = 115,
        x2 = 172,
        y1 = 171,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_Lahn] = {
        x1 = 400,
        x2 = 229,
        y1 = 456,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_Giant] = {
        x1 = 172,
        x2 = 172,
        y1 = 228,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_Tamer] = {
        x1 = 229,
        x2 = 172,
        y1 = 285,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_Combattant] = {
        x1 = 286,
        x2 = 229,
        y1 = 342,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_BladeMaster] = {
        x1 = 286,
        x2 = 172,
        y1 = 342,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_BladeMasterWomen] = {
        x1 = 400,
        x2 = 172,
        y1 = 456,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_CombattantWomen] = {
        x1 = 343,
        x2 = 229,
        y1 = 399,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_Valkyrie] = {
        x1 = 343,
        x2 = 172,
        y1 = 399,
        y2 = 228
      },
      [CppEnums.ClassType.ClassType_NinjaWomen] = {
        x1 = 115,
        x2 = 229,
        y1 = 171,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_NinjaMan] = {
        x1 = 172,
        x2 = 229,
        y1 = 228,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_DarkElf] = {
        x1 = 229,
        x2 = 229,
        y1 = 285,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_Wizard] = {
        x1 = 1,
        x2 = 229,
        y1 = 57,
        y2 = 285
      },
      [CppEnums.ClassType.ClassType_Orange] = {
        x1 = 1,
        x2 = 286,
        y1 = 57,
        y2 = 342
      },
      [CppEnums.ClassType.ClassType_WizardWomen] = {
        x1 = 58,
        x2 = 229,
        y1 = 114,
        y2 = 285
      }
    },
    _textureMPBar = {
      ["path"] = "Renewal/progress/Console_Progressbar_03.dds",
      [CppEnums.ClassType.ClassType_Warrior] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_Ranger] = {
        [1] = 331,
        [2] = 290,
        [3] = 504,
        [4] = 294
      },
      [CppEnums.ClassType.ClassType_Orange] = {
        [1] = 331,
        [2] = 290,
        [3] = 504,
        [4] = 294
      },
      [CppEnums.ClassType.ClassType_Sorcerer] = {
        [1] = 331,
        [2] = 296,
        [3] = 504,
        [4] = 300
      },
      [CppEnums.ClassType.ClassType_Lahn] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_Giant] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_Tamer] = {
        [1] = 331,
        [2] = 296,
        [3] = 504,
        [4] = 300
      },
      [CppEnums.ClassType.ClassType_Combattant] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_BladeMaster] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_BladeMasterWomen] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_CombattantWomen] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_Valkyrie] = {
        [1] = 331,
        [2] = 308,
        [3] = 504,
        [4] = 312
      },
      [CppEnums.ClassType.ClassType_NinjaWomen] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_Kunoichi] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_NinjaMan] = {
        [1] = 331,
        [2] = 284,
        [3] = 504,
        [4] = 288
      },
      [CppEnums.ClassType.ClassType_DarkElf] = {
        [1] = 331,
        [2] = 302,
        [3] = 504,
        [4] = 306
      },
      [CppEnums.ClassType.ClassType_Wizard] = {
        [1] = 331,
        [2] = 296,
        [3] = 504,
        [4] = 300
      },
      [CppEnums.ClassType.ClassType_WizardWomen] = {
        [1] = 331,
        [2] = 296,
        [3] = 504,
        [4] = 300
      }
    }
  },
  _isInitailized,
  _partyType,
  _refuseName,
  _isMainChannel,
  _isDevServer,
  _partyMemberCount,
  _partyData = {},
  _firstCheck = 0
}
function partyWidget:initialize()
  self:initControl()
  self:createControl()
  self:initData()
  self._isInitailized = true
end
function partyWidget:initData()
  self._isMainChannel = getCurrentChannelServerData()._isMain
  self._isDevServer = ToClient_IsDevelopment()
  self._partyMemberCount = 0
  self._partyData = {}
end
function partyWidget:initControl()
  Instance_Widget_Party:SetShow(false, false)
  changePositionBySever(Instance_Widget_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
end
function partyWidget:createControl()
  self._ui._static_PartyMember_Template:SetShow(false)
  local startPosY = self._ui._static_PartyMember_Template:GetPosY()
  for index = 1, self._config._maxPartyMemberCount do
    local info = {}
    info.control = UI.cloneControl(self._ui._static_PartyMember_Template, Instance_Widget_Party, "Static_PartyMember_" .. index)
    info.control:SetIgnore(false)
    info.control:SetPosY(startPosY + (info.control:GetSizeY() + self._config._gabY) * index)
    info._static_ClassIconBg = UI.getChildControl(info.control, "Static_ClassIconBg")
    info._static_ClassIconLeaderBg = UI.getChildControl(info.control, "Static_ClassIconLeaderBg")
    info._static_ClassIcon = UI.getChildControl(info.control, "Static_ClassIcon")
    info._staticText_CharacterValue = UI.getChildControl(info.control, "StaticText_CharacterValue")
    info._prev_CharacterValue_PosX = info._staticText_CharacterValue:GetPosX()
    info._prev_CharacterValue_PosY = info._staticText_CharacterValue:GetPosY()
    info._static_ProgressBg = UI.getChildControl(info.control, "Static_ProgressBg")
    info._progress2_Hp = UI.getChildControl(info.control, "Progress2_Hp")
    info._progress2_Mp = UI.getChildControl(info.control, "Progress2_Mp")
    info._staic_DeadState = UI.getChildControl(info.control, "Static_DeadState")
    info._isBlackSpirit = false
    local colorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
    if colorBlindMode >= 1 then
      info._progress2_Hp:ChangeTextureInfoName("Renewal/Progress/Console_Progressbar_02.dds")
      local xx1, yy1, xx2, yy2 = setTextureUV_Func(info._progress2_Hp, 314, 483, 492, 492)
      info._progress2_Hp:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
      info._progress2_Hp:setRenderTexture(info._progress2_Hp:getBaseTexture())
      info._progress2_Mp:ChangeTextureInfoName("Renewal/Progress/Console_Progressbar_02.dds")
      local xx1, yy1, xx2, yy2 = setTextureUV_Func(info._progress2_Mp, 314, 493, 487, 497)
      info._progress2_Mp:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
      info._progress2_Mp:setRenderTexture(info._progress2_Mp:getBaseTexture())
    end
    self._ui._static_PartyMember[index] = info
  end
end
function PaGlobalFunc_PartyWidget_GetShow()
  return partyWidget:getShow()
end
function partyWidget:getShow()
  return Instance_Widget_Party:GetShow()
end
function partyWidget:resetData()
  if not self._isInitailized then
    return
  end
  self._partyType = ToClient_GetPartyType()
  self._refuseName = nil
  self._withdrawMember = nil
  self._partyMemberCount = RequestParty_getPartyMemberCount()
  self._partyData = {}
end
function PaGlobalFunc_PartyWidget_Open()
  if not partyWidget._isInitailized then
    return
  end
  partyWidget:open()
  partyWidget:createPartyList()
  partyWidget:updatePartyList()
end
function partyWidget:open()
  if true == Instance_Widget_Party:GetShow() then
    return
  end
  Instance_Widget_Party:SetShow(true)
end
function PaGlobalFunc_PartyWidget_Close()
  partyWidget:close()
end
function partyWidget:close()
  if false == Instance_Widget_Party:GetShow() then
    return
  end
  self:resetData()
  Instance_Widget_Party:SetShow(false)
end
function partyWidget:update()
  self._partyMemberCount = RequestParty_getPartyMemberCount()
end
function FGlobal_PartyMemberCount()
  return partyWidget._partyMemberCount
end
function partyWidget:resetPartyData()
  if not self._isInitailized then
    return
  end
  self._partyData = {}
  for index = 1, self._config._maxPartyMemberCount do
    self._ui._static_PartyMember[index].control:SetShow(false)
  end
end
function ResponseParty_createPartyList()
  partyWidget:createPartyList()
end
function partyWidget:createPartyList()
  local partyMemberCount = RequestParty_getPartyMemberCount()
  if partyMemberCount > 1 then
    self._partyType = ToClient_GetPartyType()
    if not isFlushedUI() then
      self:open()
    end
    self:updatePartyList()
    self._partyMemberCount = partyMemberCount
  end
end
function ResponseParty_updatePartyList()
  partyWidget:updatePartyList()
end
function partyWidget:updatePartyList()
  if not self._isInitailized then
    return
  end
  local partyMemberCount = RequestParty_getPartyMemberCount()
  if true == Instance_Widget_Party:GetShow() then
    self:resetPartyData()
    self:setPartyMember(partyMemberCount)
    self:setMemberTexture(partyMemberCount)
    if partyMemberCount <= 1 then
      self:close()
    end
    self._partyMemberCount = partyMemberCount
  elseif false == Instance_Widget_Party:GetShow() and partyMemberCount > 1 then
    self:createPartyList()
    self:open()
  end
end
function partyWidget:setPartyMember(partyMemberCount)
  if partyMemberCount <= 1 then
    return
  end
  self._partyData = {}
  for index = 0, partyMemberCount - 1 do
    local memberData = RequestParty_getPartyMemberAt(index)
    if nil == memberData then
      return
    end
    local partyMemberInfo = {}
    partyMemberInfo._index = index
    partyMemberInfo._isMaster = memberData._isMaster
    partyMemberInfo._isSelf = RequestParty_isSelfPlayer(index)
    partyMemberInfo._name = memberData:name()
    partyMemberInfo._class = memberData:classType()
    partyMemberInfo._level = memberData._level
    partyMemberInfo._currentHp = memberData._hp * 100
    partyMemberInfo._maxHp = memberData._maxHp
    partyMemberInfo._currentMp = memberData._mp * 100
    partyMemberInfo._maxMp = memberData._maxMp
    partyMemberInfo._distance = memberData:getExperienceGrade()
    table.insert(self._partyData, partyMemberInfo)
  end
  local sortFunc = function(a, b)
    return a._isSelf
  end
  table.sort(self._partyData, sortFunc)
end
function partyWidget:setMemberTexture(partyMemberCount)
  for index = 1, partyMemberCount do
    local memberControl = self._ui._static_PartyMember[index]
    local partyData = self._partyData[index]
    if nil ~= partyData then
      local characterValue = partyData._name
      memberControl.control:SetShow(true)
      memberControl._staticText_CharacterValue:SetText(characterValue)
      memberControl._progress2_Hp:SetProgressRate(partyData._currentHp / partyData._maxHp)
      memberControl._progress2_Mp:SetProgressRate(partyData._currentMp / partyData._maxMp)
      if partyData._class == 2 then
        self:setBlackSpritMode(memberControl, partyData._class)
      else
        self:setBlackSpritMode(memberControl, partyData._class)
        self:setClassIcon(memberControl._static_ClassIcon, partyData._class)
        self:setClassMpBar(memberControl._progress2_Mp, partyData._class)
        self:setStateIcon(memberControl, partyData)
      end
    end
  end
end
function partyWidget:setBlackSpritMode(memberControl, class)
  if CppEnums.ClassType.ClassType_Temp1 == class then
    if true ~= memberControl._isBlackSpirit then
      memberControl._static_ProgressBg:SetShow(false)
      memberControl._progress2_Hp:SetShow(false)
      memberControl._progress2_Mp:SetShow(false)
      memberControl._static_ClassIcon:SetShow(false)
      memberControl._static_ClassIconLeaderBg:SetShow(false)
      memberControl._static_ClassIconBg:SetShow(false)
      local posX = memberControl._static_ClassIcon:GetPosX() - memberControl._staticText_CharacterValue:GetPosX() - 15
      local posY = memberControl._static_ClassIcon:GetPosY() - memberControl._staticText_CharacterValue:GetPosY()
      memberControl._staticText_CharacterValue:SetPosY(posY)
      memberControl._staticText_CharacterValue:AddEffect("fN_DarkSpirit_Gage_01A", true, posX, 0)
      memberControl._isBlackSpirit = true
    end
  elseif true == memberControl._isBlackSpirit then
    memberControl._staticText_CharacterValue:EraseAllEffect()
    memberControl._staticText_CharacterValue:SetPosX(memberControl._prev_CharacterValue_PosX)
    memberControl._staticText_CharacterValue:SetPosY(memberControl._prev_CharacterValue_PosY)
    memberControl._static_ProgressBg:SetShow(true)
    memberControl._progress2_Hp:SetShow(true)
    memberControl._progress2_Mp:SetShow(true)
    memberControl._static_ClassIcon:SetShow(true)
    memberControl._static_ClassIconLeaderBg:SetShow(true)
    memberControl._static_ClassIconBg:SetShow(true)
    memberControl._isBlackSpirit = false
  end
end
function partyWidget:setClassIcon(control, class)
  if nil == control then
    return
  end
  local iconTexture = self._config._textureClassSymbol[class]
  if nil == iconTexture then
    return
  end
  control:ChangeTextureInfoName(self._config._textureClassSymbol.path)
  local x1, y1, x2, y2 = setTextureUV_Func(control, iconTexture.x1, iconTexture.x2, iconTexture.y1, iconTexture.y2)
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function partyWidget:setClassMpBar(control, class)
  if nil == control then
    return
  end
  local colorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  if 0 == colorBlindMode then
    local mpBarTexture = self._config._textureMPBar[class]
    if nil == mpBarTexture then
      return
    end
    control:ChangeTextureInfoName(self._config._textureMPBar.path)
    local x1, y1, x2, y2 = setTextureUV_Func(control, mpBarTexture[1], mpBarTexture[2], mpBarTexture[3], mpBarTexture[4])
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  elseif colorBlindMode >= 1 then
    control:ChangeTextureInfoName("Renewal/Progress/Console_Progressbar_02.dds")
    local xx1, yy1, xx2, yy2 = setTextureUV_Func(control, 314, 493, 487, 497)
    control:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
    control:setRenderTexture(control:getBaseTexture())
  end
end
function partyWidget:setStateIcon(memberControl, partyData)
  if nil == memberControl then
    return
  end
  local isDead = partyData._currentHp <= 0
  local control = memberControl._staic_DeadState
  control:SetShow(isDead)
  control = memberControl._progress2_Mp
  control:SetShow(not isDead)
  control = memberControl._progress2_Hp
  control:SetShow(not isDead)
  control = memberControl._static_ProgressBg
  control:SetShow(not isDead)
  control = memberControl._static_ClassIconLeaderBg
  control:SetShow(false)
  local posX = memberControl._staticText_CharacterValue:GetTextSizeX()
  posX = posX + memberControl._staticText_CharacterValue:GetPosX() + 10
  control:SetPosX(posX)
end
function PaGlobalFunc_PartyWidget_RenderModeChange(prevRenderModeList, nextRenderModeList)
  partyWidget:renderModeChange(prevRenderModeList, nextRenderModeList)
end
function partyWidget:renderModeChange(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  if 1 <= RequestParty_getPartyMemberCount() then
    self:resetData()
    self:close()
  else
    PaGlobalFunc_PartyWidget_Open()
  end
end
function PaGlobalFunc_PartyWidget_SetScreenSize()
  partyWidget:setScreenSize()
end
function partyWidget:setScreenSize()
  if not self._isInitailized then
    return
  end
  if 1 <= RequestParty_getPartyMemberCount() then
    self:resetData()
    self:close()
  else
    if not isFlushedUI() then
      PaGlobalFunc_PartyWidget_Open()
    end
    self:updatePartyList()
  end
  if Instance_Widget_Party:GetRelativePosX() == -1 or Instance_Widget_Party:GetRelativePosY() == -1 then
    local initPosX = 10
    local initPosY = 200
    changePositionBySever(Instance_Widget_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
    FGlobal_InitPanelRelativePos(Instance_Widget_Party, initPosX, initPosY)
  elseif Instance_Widget_Party:GetRelativePosX() == 0 or Instance_Widget_Party:GetRelativePosY() == 0 then
    Instance_Widget_Party:SetPosX(10)
    Instance_Widget_Party:SetPosY(340)
  else
    Instance_Widget_Party:SetPosX(getScreenSizeX() * Instance_Widget_Party:GetRelativePosX() - Instance_Widget_Party:GetSizeX() / 2)
    Instance_Widget_Party:SetPosY(getScreenSizeY() * Instance_Widget_Party:GetRelativePosY() - Instance_Widget_Party:GetSizeY() / 2)
  end
  FGlobal_PanelRepostionbyScreenOut(Instance_Widget_Party)
end
function FromClient_PartyWidget_luaLoadComplete()
  partyWidget:initialize()
end
function partyWidget:registEventHandler()
  registerEvent("FromClient_luaLoadComplete", "FromClient_PartyWidget_luaLoadComplete")
  registerEvent("ResponseParty_createPartyList", "ResponseParty_createPartyList")
  registerEvent("ResponseParty_updatePartyList", "ResponseParty_updatePartyList")
  registerEvent("onScreenResize", "PaGlobalFunc_PartyWidget_SetScreenSize")
  registerEvent("FromClient_RenderModeChangeState", "PaGlobalFunc_PartyWidget_RenderModeChange")
end
changePositionBySever(Instance_Widget_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
partyWidget:registEventHandler()
