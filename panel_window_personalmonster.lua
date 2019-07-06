local _panel = Panel_Window_PersonalMonster
local PersonalMonster = {
  _ui = {
    _button_WinClose = UI.getChildControl(_panel, "Button_Win_Close"),
    _txt_Title = UI.getChildControl(_panel, "StaticText_Title"),
    _list2_personalMonster = UI.getChildControl(_panel, "List2_MonsterList"),
    txt_CloseMessage = UI.getChildControl(_panel, "StaticText_CloseMessage"),
    stc_SearchInfomation = UI.getChildControl(_panel, "Static_SearchIcon")
  },
  _maxSlotCount = 10,
  _gapX = 10,
  _gapY = 10,
  _colMax = 5,
  _basicSizeY = 0,
  _mouserOn = 0,
  rewardItemSlot = {},
  rewardItemSlotIcon = {},
  _difficultyIconBG = {
    [1] = {
      x1 = 1,
      y1 = 1,
      x2 = 120,
      y2 = 120
    },
    [2] = {
      x1 = 121,
      y1 = 1,
      x2 = 240,
      y2 = 120
    },
    [3] = {
      x1 = 241,
      y1 = 1,
      x2 = 360,
      y2 = 120
    }
  },
  _difficultyIcon = {
    [1] = {
      x1 = 361,
      y1 = 1,
      x2 = 480,
      y2 = 120
    },
    [2] = {
      x1 = 1,
      y1 = 121,
      x2 = 120,
      y2 = 240
    },
    [3] = {
      x1 = 121,
      y1 = 121,
      x2 = 240,
      y2 = 240
    },
    [4] = {
      x1 = 241,
      y1 = 121,
      x2 = 360,
      y2 = 240
    },
    [5] = {
      x1 = 361,
      y1 = 121,
      x2 = 480,
      y2 = 240
    }
  },
  _difficultyRoma = {
    [1] = "I",
    [2] = "II",
    [3] = "III",
    [4] = "IV",
    [5] = "V"
  },
  _difficultyText = {
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALMONSTER_DIFFICULTY_1"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALMONSTER_DIFFICULTY_2"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALMONSTER_DIFFICULTY_3")
  }
}
function PersonalMonster:initialize()
  self:createControl()
  self:registerEvent()
end
function PersonalMonster:loadReservedPersonalMonsterInfo()
  local count = ToClient_GetReservedPersonalMonsterCount()
  for ii = 0, count - 1 do
    local infoWrapper = ToClient_GetReservedPersonalMonsterInfoWrapper(ii)
    if nil ~= infoWrapper then
      FromClient_updateReservePersonalMonster(infoWrapper:getCharacterKey(), infoWrapper:getPositionIndex())
    end
  end
end
function PersonalMonster:createControl()
  self._ui.stc_desc = UI.getChildControl(_panel, "Static_Desc")
  self._ui.txt_desc = UI.getChildControl(self._ui.stc_desc, "StaticText_Desc")
  self._ui.txt_searchInfo = UI.getChildControl(self._ui.stc_SearchInfomation, "StaticText_Information")
  self._ui.txt_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_desc:SetText(self._ui.txt_desc:GetText())
  self._ui.stc_desc:SetSize(self._ui.stc_desc:GetSizeX(), self._ui.txt_desc:GetTextSizeY() * 1.5)
  self._ui.txt_searchInfo:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_searchInfo:SetText(self._ui.txt_searchInfo:GetText())
  _panel:ComputePos()
  self._ui.stc_desc:ComputePos()
  self._ui.txt_desc:ComputePos()
  self._ui._list2_personalMonster:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_PersonalMonster_List2CreateControl")
  self._ui._list2_personalMonster:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._button_WinClose:addInputEvent("Mouse_LUp", "PaGlobal_PersonalMonster_Close()")
end
function PaGlobal_PersonalMonster_Close()
  Panel_Tooltip_Item_hideTooltip()
  _panel:SetShow(false)
end
function PaGlobalFunc_PersonalMonster_SetNavi(reserveIndex)
  ToClient_DeleteNaviGuideByGroup(0)
  local pos = ToClient_GetReservePersonalMonsterPosition(reserveIndex)
  if nil == pos then
    return
  end
  ToClient_WorldMapNaviStart(pos, NavigationGuideParam(), false, true)
end
function PaGlobalFunc_PersonalMonster_List2CreateControl(content, key)
  local self = PersonalMonster
  local index = Int64toInt32(key)
  local monsterKey = ToClient_GetReservePersonalMonsterKey(index)
  local pos = ToClient_GetReservePersonalMonsterPosition(index)
  local monsterStatusWrapper = ToClient_GetCharacterStaticStatusWrapper(monsterKey)
  local personalMonsterWrapper = ToClient_GetPersonalMonsterWrapper(monsterKey)
  local personalMonsterInfoWrapper = ToClient_FindReservedPersonalMonsterInfoWrapper(monsterKey)
  if nil == monsterStatusWrapper or 0 == monsterKey then
    return
  end
  if nil == personalMonsterWrapper then
    return
  end
  if nil == personalMonsterInfoWrapper then
    return
  end
  local line = UI.getChildControl(content, "Static_Line")
  local difficultyIconBG = UI.getChildControl(content, "Static_DifficultyIconBG")
  local difficultyIcon = UI.getChildControl(content, "Static_DifficultyIcon")
  local difficultyLevel = UI.getChildControl(content, "StaticText_Level")
  local name = UI.getChildControl(content, "StaticText_Name")
  local desc = UI.getChildControl(content, "StaticText_Desc")
  local buttonNavi = UI.getChildControl(content, "Button_Navi")
  local difficultyValue = UI.getChildControl(content, "StaticText_DifficultyValue")
  local dropTitle = UI.getChildControl(content, "StaticText_DropItemTitle")
  dropTitle:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  dropTitle:SetText(dropTitle:GetText())
  local dropCount = personalMonsterWrapper:getDropItemCount()
  local slotBg = {}
  local slot = {}
  local nilcheckCount = 0
  for sIndex = 0, 8 do
    slotBg[sIndex] = UI.getChildControl(content, "Static_SlotBg_" .. sIndex)
    slot[sIndex] = UI.getChildControl(content, "Static_Slot_" .. sIndex)
    slotBg[sIndex]:SetShow(false)
    slot[sIndex]:SetShow(false)
  end
  for sIndex = 0, 8 do
    if sIndex < dropCount then
      local itemKey = personalMonsterWrapper:getDropItemKey(sIndex)
      local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
      if nil ~= itemSSW then
        local iconPath = itemSSW:getIconPath()
        slot[sIndex - nilcheckCount]:ChangeTextureInfoName("Icon/" .. iconPath)
        slot[sIndex - nilcheckCount]:addInputEvent("Mouse_On", "PaGlobalFunc_PersonalMonster_ShowToolTip(" .. itemKey .. ")")
        slot[sIndex - nilcheckCount]:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
        slotBg[sIndex - nilcheckCount]:SetShow(true)
        slot[sIndex - nilcheckCount]:SetShow(true)
      else
        nilcheckCount = nilcheckCount + 1
      end
    end
  end
  name:SetText(monsterStatusWrapper:getName())
  desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  desc:SetText(personalMonsterWrapper:getDescription())
  buttonNavi:SetPosX(name:GetPosX() + name:GetTextSizeX() + 20)
  buttonNavi:addInputEvent("Mouse_LUp", "PaGlobalFunc_PersonalMonster_SetNavi(" .. index .. ")")
  buttonNavi:addInputEvent("Mouse_On", "PaGlobal_PersonalMonster_TooltipShow( true )")
  buttonNavi:addInputEvent("Mouse_Out", "PaGlobal_PersonalMonster_TooltipShow()")
  local difficulty = personalMonsterWrapper:getDifficult()
  local monsterLevel = personalMonsterInfoWrapper:getLevel()
  local x1, y1, x2, y2
  if difficulty >= 1 and difficulty <= 3 then
    difficultyIconBG:ChangeTextureInfoNameAsync("renewal/pcremaster/remaster_icon_worldmap_autoboss_all.dds")
    x1, y1, x2, y2 = setTextureUV_Func(difficultyIconBG, self._difficultyIconBG[difficulty].x1, self._difficultyIconBG[difficulty].y1, self._difficultyIconBG[difficulty].x2, self._difficultyIconBG[difficulty].y2)
    difficultyIconBG:getBaseTexture():setUV(x1, y1, x2, y2)
    difficultyIconBG:setRenderTexture(difficultyIconBG:getBaseTexture())
  end
  if monsterLevel >= 1 and monsterLevel <= 5 then
    difficultyIcon:ChangeTextureInfoNameAsync("renewal/pcremaster/remaster_icon_worldmap_autoboss_all.dds")
    x1, y1, x2, y2 = setTextureUV_Func(difficultyIcon, self._difficultyIcon[monsterLevel].x1, self._difficultyIcon[monsterLevel].y1, self._difficultyIcon[monsterLevel].x2, self._difficultyIcon[monsterLevel].y2)
    difficultyIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    difficultyLevel:SetText(self._difficultyRoma[monsterLevel])
  else
    difficultyLevel:SetText("I")
  end
  difficultyValue:SetText(self._difficultyText[difficulty])
  difficultyIconBG:SetShow(true)
  difficultyIcon:SetShow(true)
  difficultyLevel:SetShow(true)
  function PaGlobalFunc_PersonalMonster_ShowToolTip(itemKey)
    local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
    Panel_Tooltip_Item_Show(itemSSW, _panel, true)
  end
  function PaGlobal_PersonalMonster_TooltipShow(isShow)
    if nil == isShow then
      TooltipSimple_Hide()
      return
    end
    local name, desc, control
    if true == isShow then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_PERSONALMONSTER_NAVITOOLTIPTITLE")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_PERSONALMONSTER_NAVITOOLTIPDESC")
      control = buttonNavi
      TooltipSimple_Show(control, name, desc)
    end
  end
end
function PaGlobalFunc_PersonalMonster_Initialize()
  PersonalMonster:initialize()
  PersonalMonster:loadReservedPersonalMonsterInfo()
end
function PaGlobalFunc_PersonalMonster_Open()
  PaGlobalFunc_PersonalMonster_EffectHide()
  if true == _panel:GetShow() then
    PaGlobal_PersonalMonster_Close()
    return
  end
  local self = PersonalMonster
  self._ui._list2_personalMonster:getElementManager():clearKey()
  for ii = 0, ToClient_GetReservePersonalMonsterListCount() - 1 do
    local monsterKey = ToClient_GetReservePersonalMonsterKey(ii)
    if 0 ~= monsterKey and nil ~= monsterKey then
      self._ui._list2_personalMonster:getElementManager():pushKey(ii)
      self._ui._list2_personalMonster:requestUpdateByKey(toInt64(0, ii))
    end
  end
  PaGlobal_PersonalMonster_SetMonsterZeroState()
  _panel:SetShow(true)
end
function PersonalMonster:registerEvent()
  if true == ToClient_IsContentsGroupOpen("500") then
    registerEvent("FromClient_updatePersonalMonsterList", "FromClient_updatePersonalMonsterList")
  end
end
function FromClient_updatePersonalMonsterList(isInit)
  PersonalMonster:loadReservedPersonalMonsterInfo()
end
function GoPersonalMonsterPos(characterKey)
  if true == isRealServiceMode() then
    return
  end
  local monsterInfoWrapper = ToClient_FindReservedPersonalMonsterInfoWrapper(characterKey)
  if nil == monsterInfoWrapper then
    Proc_ShowMessage_Ack("Not Reserved Yet")
    return
  end
  local pos = monsterInfoWrapper:getSpawnPosition()
  ToClient_WorldMapNaviStart(pos, NavigationGuideParam(), false, true)
end
function CheckPersonalMonster(characterKey)
  if true == isRealServiceMode() then
    return
  end
  local monsterInfoWrapper = ToClient_FindReservedPersonalMonsterInfoWrapper(characterKey)
  if nil == monsterInfoWrapper then
    Proc_ShowMessage_Ack("Not Reserved Yet")
    return
  end
  local option = monsterInfoWrapper:getOption()
  local characterWrapper = ToClient_GetCharacterStaticStatusWrapper(characterKey)
  local strInfo = characterKey .. "(" .. characterWrapper:getName() .. ") : "
  local lv = monsterInfoWrapper:getLevel()
  if 0 == option then
    chatting_sendMessage("", strInfo .. "Not Reserved Yet", CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
  elseif 1 == option then
    chatting_sendMessage("", strInfo .. "Spawned / Lv=" .. lv, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
  elseif 2 == option then
    chatting_sendMessage("", strInfo .. "Reserved / Lv=" .. lv, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
  elseif 3 == option then
    chatting_sendMessage("", strInfo .. "Reserved And Notified / Lv=" .. lv, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
  end
end
function CheckPersonalMonsterAll()
  if true == isRealServiceMode() then
    return
  end
  local count = ToClient_GetReservedPersonalMonsterCount()
  for ii = 0, count - 1 do
    local infoWrapper = ToClient_GetReservedPersonalMonsterInfoWrapper(ii)
    if nil ~= infoWrapper then
      CheckPersonalMonster(infoWrapper:getCharacterKey())
    end
  end
end
function PaGlobal_PersonalMonster_SetMonsterZeroState()
  local count = ToClient_GetReservedPersonalMonsterCount()
  local self = PersonalMonster
  local isCheckLevelCondition = false
  local conditionString = ""
  if 0 == count then
    isCheckLevelCondition = PaGlobal_PersonalMonster_FamilyLevelCheck()
    self._ui.txt_CloseMessage:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui.txt_CloseMessage:SetIgnore(true)
    self._ui.txt_CloseMessage:SetShow(true)
    self._ui._list2_personalMonster:SetShow(false)
    _panel:SetSize(_panel:GetSizeX(), 226)
  end
  self._ui.stc_SearchInfomation:SetShow(false)
  if 0 ~= count then
    self._ui.txt_CloseMessage:SetShow(false)
    self._ui._list2_personalMonster:SetShow(true)
    _panel:SetSize(_panel:GetSizeX(), 626)
  elseif true == isCheckLevelCondition then
    _panel:SetSize(_panel:GetSizeX(), 276)
    self._ui.stc_SearchInfomation:SetShow(true)
    self._ui.txt_CloseMessage:SetShow(false)
  else
    conditionString = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALMONSTER_CLOSE_NEEDAWAKENSTATE")
    self._ui.txt_CloseMessage:SetIgnore(false)
  end
  self._ui.txt_CloseMessage:SetText(conditionString)
  _panel:SetSize(_panel:GetSizeX(), _panel:GetSizeY() + self._ui.stc_desc:GetSizeY() - 50)
  _panel:ComputePos()
  self._ui.txt_CloseMessage:ComputePos()
  self._ui.stc_desc:ComputePos()
  self._ui.txt_desc:ComputePos()
  self._ui.stc_SearchInfomation:ComputePos()
end
function PaGlobal_PersonalMonster_FamilyLevelCheck()
  for idx = 0, getCharacterDataCount() - 1 do
    local characterData = getCharacterDataByIndex(idx)
    if nil ~= characterData and 56 <= characterData._level then
      return true
    end
  end
  return false
end
function testCharLevel()
  _PA_LOG("\235\172\184\236\158\165\237\153\152", "\236\186\144\235\166\173\237\132\176\235\160\136\235\178\168 : " .. tostring(PaGlobal_PersonalMonster_FamilyLevelCheck()))
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_PersonalMonster_Initialize")
