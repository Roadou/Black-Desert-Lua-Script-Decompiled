local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local gameOptionActionKey = {
  Forward = 0,
  Back = 1,
  Left = 2,
  Right = 3,
  Attack = 4,
  SubAttack = 5,
  Dash = 6,
  Jump = 7
}
local uiPress = {
  _button_Space = UI.getChildControl(Panel_Fishing, "StaticText_Btn_Space_2"),
  _button_Xbox_B = UI.getChildControl(Panel_Fishing, "Static_Press_B"),
  _m1 = UI.getChildControl(Panel_Fishing, "StaticText_M1_2")
}
local fishing_UI = {
  _fishWpDesc_BG = UI.getChildControl(Panel_Fishing, "StaticText_OnlyFishWpDesc_BG"),
  _fish_Icon_Title = UI.getChildControl(Panel_Fishing, "Static_Minigame_Fish_Title"),
  _purposeText = UI.getChildControl(Panel_Fishing, "StaticText_Purpose"),
  _fishBG = UI.getChildControl(Panel_Fishing, "Static_OnlyFishBG"),
  _fishPercent = UI.getChildControl(Panel_Fishing, "StaticText_OnlyFish"),
  _fishComment = UI.getChildControl(Panel_Fishing, "StaticText_OnlyFishComment"),
  _m0 = UI.getChildControl(Panel_Fishing, "StaticText_M0"),
  _mBody = UI.getChildControl(Panel_Fishing, "StaticText_Mouse_Body")
}
fishing_UI._staticText_CheckBox = UI.getChildControl(fishing_UI._fishWpDesc_BG, "StaticText_CheckBox")
fishing_UI._checkBox_DropTrash = UI.getChildControl(fishing_UI._staticText_CheckBox, "CheckBox_DropTrash")
fishing_UI.StaticText_KeyGuideX = UI.getChildControl(fishing_UI._staticText_CheckBox, "StaticText_KeyGuideX")
fishing_UI._fishWpDesc = UI.getChildControl(fishing_UI._fishWpDesc_BG, "StaticText_OnlyFishWpDesc")
fishing_UI._fishingCancelDesc = UI.getChildControl(Panel_Fishing, "StaticText_FishingCancel")
fishing_UI._fishPoolIcon = UI.getChildControl(Panel_Fishing, "StaticText_Fish_Pool_Icon")
if _ContentsGroup_isConsolePadControl then
  fishing_UI._fishWpDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  fishing_UI._fishWpDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GLOBAL_MANUAL_ONLYFISHWPDESC"))
  fishing_UI._staticText_CheckBox:SetTextMode(UI_TM.eTextMode_AutoWrap)
  fishing_UI._staticText_CheckBox:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GLOBAL_MANUAL_DROPTRASH"))
  fishing_UI._fishingCancelDesc:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_XBOX1_MINIGAME_FISHING_CANCEL"))
  local margin = 20
  local textTotalSizeY = fishing_UI._fishWpDesc:GetTextSizeY() + fishing_UI._staticText_CheckBox:GetTextSizeY() + margin
  if textTotalSizeY > fishing_UI._fishWpDesc_BG:GetSizeY() then
    local gap = math.abs(textTotalSizeY - fishing_UI._fishWpDesc_BG:GetSizeY())
    fishing_UI._fishWpDesc_BG:SetSize(fishing_UI._fishWpDesc_BG:GetSizeX(), fishing_UI._fishWpDesc_BG:GetSizeY() + gap)
    fishing_UI._fishWpDesc_BG:SetPosY(fishing_UI._fishWpDesc_BG:GetPosY() + gap)
  elseif fishing_UI._fishWpDesc_BG:GetSizeY() == textTotalSizeY then
    fishing_UI._fishWpDesc_BG:SetSize(fishing_UI._fishWpDesc_BG:GetSizeX(), fishing_UI._fishWpDesc_BG:GetSizeY() + margin)
    fishing_UI._fishWpDesc_BG:SetPosY(fishing_UI._fishWpDesc_BG:GetPosY() + margin)
  end
else
end
local _fishingConditon = -1
local fishGPoolValueUV = {
  [0] = {
    184,
    323,
    260,
    399
  },
  [1] = {
    333,
    94,
    409,
    170
  },
  [2] = {
    184,
    400,
    260,
    476
  },
  [3] = {
    410,
    94,
    486,
    170
  }
}
local ui_Value = {
  isFirstTime_Manual_Fishing_Start = true,
  isFirstTime_Manual_Fishing_0 = true,
  isFirstTime_Manual_Fishing_1 = true,
  isFirstTime_Manual_Fishing_2 = true,
  isFirstTime_Manual_Fishing_3 = true,
  isFirstTime_Manual_Jaksal_0 = true,
  isFirstTime_Manual_Jaksal_1 = true,
  isFirstTime_Manual_Jaksal_2 = true,
  isFirstTime_Manual_Jaksal_3 = true,
  isFirstTime_Manual_Jaksal_4 = true,
  isFirstTime_Manual_Jaksal_5 = true
}
local isCheckFishing = false
function fishingGame_Initialize()
  Panel_Fishing:SetShow(false)
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_Fishing:SetSize(scrX, scrY)
  Panel_Fishing:SetPosX(0)
  Panel_Fishing:SetPosY(20)
  for _, value in pairs(fishing_UI) do
    value:SetShow(false)
    value:ComputePos()
  end
  for _, value in pairs(uiPress) do
    value:SetShow(false)
    value:ComputePos()
  end
  fishing_UI._fishWpDesc:SetShow(true)
  fishing_UI._fishingCancelDesc:SetShow(true)
  isCheckFishing = false
end
fishingGame_Initialize()
local function FishPoolValuIconChange(index)
  fishing_UI._fishPoolIcon:ChangeTextureInfoName("renewal/etc/minigame/console_etc_minigame_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(fishing_UI._fishPoolIcon, fishGPoolValueUV[index][1], fishGPoolValueUV[index][2], fishGPoolValueUV[index][3], fishGPoolValueUV[index][4])
  fishing_UI._fishPoolIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  fishing_UI._fishPoolIcon:setRenderTexture(fishing_UI._fishPoolIcon:getBaseTexture())
end
function fishingGame_SetPurpose()
  fishing_UI._purposeText:SetTextHorizonLeft()
  fishing_UI._purposeText:SetTextSpan(40, 0)
end
function fishingGame_ResetSize()
  fishing_UI._purposeText:SetTextHorizonCenter()
  fishing_UI._purposeText:SetTextSpan(0, 0)
end
function HandleClicked_FishCheck()
  if false == Panel_Fishing:GetShow() then
    return
  end
  local itemGrade = 0
  if true == fishing_UI._checkBox_DropTrash:IsCheck() then
    itemGrade = 1
  else
    itemGrade = 0
  end
  getSelfPlayer():setFishingAutoItemGrade(itemGrade)
  FGlobal_RemoteControl_FishCheck(fishing_UI._checkBox_DropTrash:IsCheck())
end
local IsHideMiniGameManual = function()
  local uiMode = GetUIMode()
  return getCustomizingManager():isShow() or uiMode == Defines.UIMode.eUIMode_NpcDialog or uiMode == Defines.UIMode.eUIMode_InGameCashShop or uiMode == Defines.UIMode.eUIMode_Mental or uiMode == Defines.UIMode.eUIMode_DyeNew
end
function setFishingResourcePool_text()
  local fishComment_head = PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FISH_POOL_HEAD")
  local fishingPercent = math.floor(ToClient_CurrentFishingData() * 100)
  if fishingPercent >= 71 and fishingPercent <= 100 then
    fishing_UI._fishPoolIcon:SetFontColor(UI_color.C_FF00C0D7)
    FishPoolValuIconChange(0)
    fishComment = PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FISH_POOL_VALUE_1")
  elseif fishingPercent >= 46 and fishingPercent <= 70 then
    FishPoolValuIconChange(1)
    fishing_UI._fishPoolIcon:SetFontColor(UI_color.C_FFC8FFC8)
    fishComment = PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FISH_POOL_VALUE_2")
  elseif fishingPercent >= 15 and fishingPercent <= 45 then
    FishPoolValuIconChange(2)
    fishing_UI._fishPoolIcon:SetFontColor(UI_color.C_FFEE7001)
    fishComment = PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FISH_POOL_VALUE_3")
  elseif fishingPercent <= 14 and fishingPercent >= 0 then
    FishPoolValuIconChange(3)
    fishing_UI._fishPoolIcon:SetFontColor(UI_color.C_FFF26A6A)
    fishComment = PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FISH_POOL_VALUE_4")
  end
  fishing_UI._fishPoolIcon:SetText(fishComment)
  if _ContentsGroup_isConsolePadControl then
    fishing_UI._fishPercent:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_FISHERY_RESOURCE", "FISHERY", fishComment))
    fishing_UI._fishComment:SetAutoResize(true)
    fishing_UI._fishComment:SetTextMode(UI_TM.eTextMode_AutoWrap)
    fishing_UI._fishComment:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_FISHERY_COMMENT"))
  else
  end
  local itemWrapper = ToClient_getEquipmentItem(0)
  if nil == itemWrapper then
    fishing_UI._fishPoolIcon:SetShow(true)
    return
  end
  local equipType = itemWrapper:getStaticStatus():getEquipType()
  if 44 == equipType then
    fishing_UI._fishPoolIcon:SetShow(true)
    HandleClicked_FishCheck()
  elseif 48 == equipType then
    fishing_UI._fishPoolIcon:SetShow(false)
    PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(false)
  end
  local sizeX1 = fishing_UI._fishPercent:GetTextSizeX()
  local sizeX2 = fishing_UI._fishComment:GetTextSizeX()
  local maxSizeX = 0
  if sizeX1 > sizeX2 then
    maxSizeX = sizeX1
  else
    maxSizeX = sizeX2
  end
  local maxSizeY = fishing_UI._fishComment:GetSizeY() + fishing_UI._fishPercent:GetSizeY()
  if _ContentsGroup_isConsolePadControl then
  else
  end
end
function FromClient_ReconnectCheckItemGrade(itemgrade)
  if true == itemgrade then
    fishing_UI._checkBox_DropTrash:SetCheck(true)
  else
    fishing_UI._checkBox_DropTrash:SetCheck(false)
  end
  getSelfPlayer():setFishingAutoItemGrade(itemGrade)
  FGlobal_RemoteControl_FishCheck(CheckBox_DropTrash:IsCheck())
end
function PaGlobalFunc_Fishing_GetFishingMiniGame_3()
  return ui_Value.isFirstTime_Manual_Fishing_3
end
registerEvent("FromClient_ReconnectCheckItemGrade", "FromClient_ReconnectCheckItemGrade")
registerEvent("progressEventCancelByAttacked", "FromClient_Fishing_ProgressEventCancelByAttacked")
local IsHideFishingGame = function()
  local uiMode = GetUIMode()
  return getCustomizingManager():isShow() or uiMode == Defines.UIMode.eUIMode_NpcDialog or uiMode == Defines.UIMode.eUIMode_InGameCashShop or uiMode == Defines.UIMode.eUIMode_Mental or uiMode == Defines.UIMode.eUIMode_DyeNew
end
local function FishingGame_Manual_Fishing_Start(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Fishing_Start == true and not IsHideFishingGame() then
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(fishing_UI) do
      v:SetShow(false)
      v:ComputePos()
    end
    isCheckFishing = false
    fishingGame_ResetSize()
    fishing_UI._fishWpDesc:SetShow(true)
    fishing_UI._fishWpDesc_BG:SetShow(true)
    fishing_UI._fishWpDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GLOBAL_MANUAL_ONLYFISHWPDESC"))
    Panel_Fishing:SetShow(true)
    Panel_Fishing:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Fishing, 0, 0.22)
    FGlobal_EquipFishingToolCheck()
    PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(true)
    local targetItemGrade = getSelfPlayer():getFishingAutoItemGrade()
    if 1 == targetItemGrade then
      fishing_UI._checkBox_DropTrash:SetCheck(true)
    end
    if true == ToClient_IsDevelopment() and nil ~= PaGlobalFunc_InventoryInfo_GetShow and true == PaGlobalFunc_InventoryInfo_GetShow() then
      PaGlobalFunc_InventoryInfo_Close()
    end
    fishing_UI._purposeText:SetShow(true)
    fishing_UI._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    PaGlobalFunc_ConsoleKeyGuide_SetFishingIdleMode()
    local actionString = ""
    if getGamePadEnable() then
      actionString = keyCustom_GetString_ActionPad(gameOptionActionKey.Jump)
    else
      actionString = keyCustom_GetString_ActionKey(gameOptionActionKey.Jump)
    end
    PaGlobalFunc_ConsoleKeyGuide_On()
    if _ContentsGroup_isConsolePadControl then
      fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_FISHING_START"))
    else
      fishing_UI._purposeText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_START", "key", actionString))
    end
    setFishingResourcePool_text()
    fishing_UI._fishPoolIcon:SetShow(true)
    if _ContentsGroup_isConsolePadControl then
      ui_Value.isFirstTime_Manual_Fishing_Start = false
      MiniGame_Manual_Value_FishingStart = true
    end
  else
  end
end
local function FishingGame_Manual_Fishing_0(actorKeyRaw, isSelf)
  FGlobal_PowerGauge_Close()
  if ui_Value.isFirstTime_Manual_Fishing_0 == true then
    for _, v in pairs(fishing_UI) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    isCheckFishing = true
    fishingGame_SetPurpose()
    fishing_UI._fishPoolIcon:SetShow(true)
    fishing_UI._fishWpDesc:SetShow(true)
    fishing_UI._fishingCancelDesc:SetShow(true)
    fishing_UI._fishingCancelDesc:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_XBOX1_MINIGAME_FISHING_CANCEL"))
    Panel_Fishing:SetShow(true)
    Panel_Fishing:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Fishing, 0, 0.22)
    FGlobal_EquipFishingToolCheck()
    PaGlobalFunc_ConsoleKeyGuide_SetFishingWaitHookMode()
    PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(false)
    fishing_UI._purposeText:SetShow(true)
    fishing_UI._fishWpDesc_BG:SetShow(false)
    fishing_UI._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    if _ContentsGroup_isConsolePadControl then
      fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_FISHING_0"))
    else
      fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_0"))
    end
    fishing_UI._fishBG:SetSize(fishing_UI._fishComment:GetTextSizeX() + 10, fishing_UI._fishPercent:GetSizeY() + fishing_UI._fishComment:GetSizeY() + 10)
    ui_Value.isFirstTime_Manual_Fishing_0 = false
  end
end
local function FishingGame_Manual_Fishing_1(actorKeyRaw, isSelf)
  local selfplayer = getSelfPlayer()
  if nil == selfplayer then
    return
  end
  local autoFishingEnalbe = selfplayer:get():isAutoFishingable()
  if ui_Value.isFirstTime_Manual_Fishing_1 == true then
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(fishing_UI) do
      v:SetShow(false)
      v:ComputePos()
    end
    isCheckFishing = true
    fishing_UI._fishWpDesc:SetShow(true)
    fishing_UI._fishingCancelDesc:SetShow(false)
    fishing_UI._purposeText:SetShow(true)
    fishing_UI._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    PaGlobalFunc_ConsoleKeyGuide_SetfishingHookMini1()
    PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(false)
    local actionString = ""
    if getGamePadEnable() then
      actionString = keyCustom_GetString_ActionPad(gameOptionActionKey.Jump)
    else
      actionString = keyCustom_GetString_ActionKey(gameOptionActionKey.Jump)
    end
    if _ContentsGroup_isConsolePadControl then
      fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_FISHING_1"))
    else
      fishing_UI._purposeText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_1", "key", actionString))
    end
    if autoFishingEnalbe then
    else
    end
    if _ContentsGroup_isConsolePadControl then
    else
    end
    fishing_UI._fishWpDesc_BG:SetShow(false)
    ui_Value.isFirstTime_Manual_Fishing_1 = false
  end
end
local function FishingGame_Manual_Fishing_2(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Fishing_2 == true then
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    isCheckFishing = true
    fishing_UI._fishWpDesc:SetShow(true)
    fishing_UI._fishingCancelDesc:SetShow(false)
    fishing_UI._purposeText:SetShow(true)
    fishing_UI._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    PaGlobalFunc_ConsoleKeyGuide_SetfishingHookMini2()
    PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(false)
    if _ContentsGroup_isConsolePadControl then
      fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_FISHING_2"))
    else
      fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_2"))
    end
    fishing_UI._fishWpDesc_BG:SetShow(false)
    ui_Value.isFirstTime_Manual_Fishing_2 = false
  end
end
local function FishingGame_Manual_Fishing_3(actorKeyRaw, isSelf)
  local selfplayer = getSelfPlayer()
  if nil == selfplayer then
    return
  end
  local autoFishingEnalbe = selfplayer:get():isAutoFishingable()
  if ui_Value.isFirstTime_Manual_Fishing_3 == true then
    PaGlobal_ConsoleQuickMenu:widgetClose(false)
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    isCheckFishing = true
    _AudioPostEvent_SystemUiForXBOX(11, 6)
    local leftTimeForAuto = math.floor(Int64toInt32(getSelfPlayer():get():getFishingAutoLeftTime()) / 1000)
    local leftMinute
    if 0 < math.floor(leftTimeForAuto / 60) then
      leftMinute = " (" .. PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_MATCH_TIME") .. " " .. PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", math.floor(leftTimeForAuto / 60)) .. ")"
    else
      leftMinute = " (" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PARTY_MATCH_TIME") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_UNDER_ONEMINUTE") .. ")"
    end
    fishingGame_ResetSize()
    fishing_UI._fishWpDesc_BG:SetShow(true)
    fishing_UI._fishPoolIcon:SetShow(true)
    fishing_UI._fishWpDesc:SetShow(true)
    fishing_UI._fishingCancelDesc:SetShow(false)
    fishing_UI._purposeText:SetShow(true)
    fishing_UI._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    PaGlobalFunc_ConsoleKeyGuide_SetfishingStartHook()
    PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(true)
    local actionString = ""
    if getGamePadEnable() then
      actionString = keyCustom_GetString_ActionPad(gameOptionActionKey.Jump)
    else
      actionString = keyCustom_GetString_ActionKey(gameOptionActionKey.Jump)
    end
    if _ContentsGroup_isConsolePadControl then
      fishing_UI._purposeText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_FISHING_3", "key", actionString))
    else
      fishing_UI._purposeText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_3", "key", actionString))
    end
    if autoFishingEnalbe then
    else
      fishing_UI._fishWpDesc_BG:SetShow(false)
    end
    ui_Value.isFirstTime_Manual_Fishing_2 = false
  end
end
local function FishingGame_Manual_Fishing_Auto()
  local selfplayer = getSelfPlayer()
  if nil == selfplayer then
    return
  end
  local autoFishingEnalbe = selfplayer:get():isAutoFishingable()
  for _, v in pairs(uiPress) do
    v:SetShow(false)
    v:ComputePos()
  end
  if autoFishingEnalbe then
    PaGlobal_ConsoleQuickMenu:widgetOpen()
    fishing_UI._fishWpDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GLOBAL_MANUAL_ONLYFISHWPDESC"))
    PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(true)
  else
  end
end
local function FishingGame_Manual_CommonGaugeOpen()
  fishingGame_SetPurpose()
  fishing_UI._fishingCancelDesc:SetShow(true)
  fishing_UI._fishingCancelDesc:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_XBOX1_MINIGAME_FISHING_CANCEL"))
  FGlobal_PowerGuage_StatCheck()
end
local FishingGame_Manual_Fishing_Wait = function(aaa)
  if not Panel_PowerGauge:GetShow() then
    FGlobal_PowerGauge_Open()
  end
end
function FGlobal_MiniGame_FishingCheck()
  if _ContentsGroup_isConsolePadControl then
    fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_FISHING_2"))
  else
    fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_2"))
  end
end
function MiniGame_FishingDescInit()
end
MiniGame_FishingDescInit()
local function MiniGame_Manual_Jaksal_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Jaksal_0 == true and not IsHideMiniGameManual() then
    for _, v in pairs(fishing_UI) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Fishing:SetShow(true)
    Panel_Fishing:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Fishing, 0, 0.22)
    fishing_UI._fishBG:SetShow(true)
    fishing_UI._fishPercent:SetShow(true)
    fishing_UI._fishComment:SetShow(true)
    setFishingResourcePool_text()
    fishing_UI._fishBG:SetSize(fishing_UI._fishComment:GetTextSizeX() + 10, fishing_UI._fishPercent:GetSizeY() + fishing_UI._fishComment:GetSizeY() + 10)
    fishing_UI._fishBG:ComputePos()
    fishing_UI._fishPercent:ComputePos()
    fishing_UI._fishComment:ComputePos()
    fishing_UI._fishBG:ComputePos()
    PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(false)
    fishing_UI._purposeText:SetShow(true)
    fishing_UI._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_CONSOLE_FISHING_USE"))
    ui_Value.isFirstTime_Manual_Jaksal_0 = false
  end
  MiniGame_Manual_Value_FishingStart = true
end
local function MiniGame_Manual_Jaksal_1(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Jaksal_1 == true then
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(fishing_UI) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Fishing:SetShow(true)
    Panel_Fishing:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Fishing, 0, 0.22)
    PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(false)
    fishing_UI._fishBG:SetShow(true)
    fishing_UI._fishPercent:SetShow(true)
    fishing_UI._fishComment:SetShow(true)
    setFishingResourcePool_text()
    fishing_UI._fishBG:SetSize(fishing_UI._fishComment:GetTextSizeX() + 10, fishing_UI._fishPercent:GetSizeY() + fishing_UI._fishComment:GetSizeY() + 10)
    fishing_UI._purposeText:SetShow(true)
    fishing_UI._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_Fishing_Finding"))
    fishing_UI._fishingCancelDesc:SetShow(true)
    fishing_UI._fishingCancelDesc:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_XBOX1_MINIGAME_FISHING_CANCEL"))
    ui_Value.isFirstTime_Manual_Jaksal_0 = true
    ui_Value.isFirstTime_Manual_Jaksal_1 = false
  end
end
local function MiniGame_Manual_Jaksal_2(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Jaksal_2 == true then
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(fishing_UI) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Fishing:SetShow(true)
    Panel_Fishing:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Fishing, 0, 0.22)
    PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(false)
    fishing_UI._fishBG:SetShow(true)
    fishing_UI._fishPercent:SetShow(true)
    fishing_UI._fishComment:SetShow(true)
    setFishingResourcePool_text()
    fishing_UI._fishBG:SetSize(fishing_UI._fishComment:GetTextSizeX() + 10, fishing_UI._fishPercent:GetSizeY() + fishing_UI._fishComment:GetSizeY() + 10)
    fishing_UI._purposeText:SetShow(true)
    fishing_UI._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_CONSOLE_FISHING_FIND"))
    ui_Value.isFirstTime_Manual_Jaksal_0 = true
    ui_Value.isFirstTime_Manual_Jaksal_1 = false
    ui_Value.isFirstTime_Manual_Jaksal_2 = false
  end
end
local function MiniGame_Manual_Jaksal_3(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Jaksal_3 == true then
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(fishing_UI) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Fishing:SetShow(true)
    Panel_Fishing:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Fishing, 0, 0.22)
    PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(false)
    fishing_UI._fishBG:SetShow(true)
    fishing_UI._fishPercent:SetShow(true)
    fishing_UI._fishComment:SetShow(true)
    setFishingResourcePool_text()
    fishing_UI._fishBG:SetSize(fishing_UI._fishComment:GetTextSizeX() + 10, fishing_UI._fishPercent:GetSizeY() + fishing_UI._fishComment:GetSizeY() + 10)
    fishing_UI._purposeText:SetShow(true)
    fishing_UI._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_CONSOLE_FISHING_SIGHT"))
    ui_Value.isFirstTime_Manual_Jaksal_0 = true
    ui_Value.isFirstTime_Manual_Jaksal_1 = false
    ui_Value.isFirstTime_Manual_Jaksal_2 = false
    ui_Value.isFirstTime_Manual_Jaksal_3 = false
  end
end
local function MiniGame_Manual_Jaksal_4(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Jaksal_4 == true then
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(fishing_UI) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Fishing:SetShow(true)
    Panel_Fishing:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Fishing, 0, 0.22)
    PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(false)
    fishing_UI._fishBG:SetShow(true)
    fishing_UI._fishPercent:SetShow(true)
    fishing_UI._fishComment:SetShow(true)
    setFishingResourcePool_text()
    fishing_UI._fishBG:SetSize(fishing_UI._fishComment:GetTextSizeX() + 10, fishing_UI._fishPercent:GetSizeY() + fishing_UI._fishComment:GetSizeY() + 10)
    fishing_UI._purposeText:SetShow(true)
    fishing_UI._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_Fishing_Success"))
    ui_Value.isFirstTime_Manual_Jaksal_0 = true
    ui_Value.isFirstTime_Manual_Jaksal_1 = false
    ui_Value.isFirstTime_Manual_Jaksal_2 = false
    ui_Value.isFirstTime_Manual_Jaksal_3 = false
    ui_Value.isFirstTime_Manual_Jaksal_4 = false
  end
end
local function MiniGame_Manual_Jaksal_5(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Jaksal_5 == true then
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(fishing_UI) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Fishing:SetShow(true)
    Panel_Fishing:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Fishing, 0, 0.22)
    PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(false)
    setFishingResourcePool_text()
    fishing_UI._fishBG:SetSize(fishing_UI._fishComment:GetTextSizeX() + 10, fishing_UI._fishPercent:GetSizeY() + fishing_UI._fishComment:GetSizeY() + 10)
    fishing_UI._purposeText:SetShow(true)
    fishing_UI._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    fishing_UI._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_Fishing_Fail"))
    ui_Value.isFirstTime_Manual_Jaksal_0 = true
    ui_Value.isFirstTime_Manual_Jaksal_1 = false
    ui_Value.isFirstTime_Manual_Jaksal_2 = false
    ui_Value.isFirstTime_Manual_Jaksal_3 = false
    ui_Value.isFirstTime_Manual_Jaksal_4 = false
    ui_Value.isFirstTime_Manual_Jaksal_5 = false
  end
end
function Panel_Fishing_End(actorKeyRaw, isSelf)
  if false == isSelf then
    return
  end
  PaGlobal_ConsoleQuickMenu:widgetOpen(false)
  if false == ui_Value.isFirstTime_Manual_Fishing_Start then
    PaGlobalFunc_ConsoleKeyGuide_SetFishingIdleMode()
  end
  isCheckFishing = false
  FGlobal_EquipFishingToolCheck()
  Panel_Fishing:SetShow(false)
  PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(false)
  ui_Value.isFirstTime_Manual_Fishing_Start = true
  ui_Value.isFirstTime_Manual_Fishing_0 = true
  ui_Value.isFirstTime_Manual_Fishing_1 = true
  ui_Value.isFirstTime_Manual_Fishing_2 = true
  ui_Value.isFirstTime_Manual_Fishing_3 = true
  ui_Value.isFirstTime_Manual_Jaksal_0 = true
  ui_Value.isFirstTime_Manual_Jaksal_1 = true
  ui_Value.isFirstTime_Manual_Jaksal_2 = true
  ui_Value.isFirstTime_Manual_Jaksal_3 = true
  ui_Value.isFirstTime_Manual_Jaksal_4 = true
  ui_Value.isFirstTime_Manual_Jaksal_5 = true
  MiniGame_Manual_Value_FishingStart = false
  if Panel_PowerGauge:GetShow() then
    FGlobal_PowerGauge_Close()
  end
  if Panel_CannonGauge:GetShow() then
    FGlobal_CannonGauge_Close()
  end
end
function FromClient_Fishing_ProgressEventCancelByAttacked()
  if nil == Panel_Fishing then
    return
  end
  if false == isCheckFishing then
    return
  end
  Panel_Fishing_End()
end
local MiniGame_Manual_CannonGaugeOpen = function()
  if not Panel_Stamina:GetShow() then
    FGlobal_CannonGauge_Open()
  end
end
function PaGlobalFunc_FishingCheckBox_SetCheckBoxShow(show)
  if nil == Panel_Fishing then
    return
  end
  fishing_UI._staticText_CheckBox:SetShow(show)
  fishing_UI._checkBox_DropTrash:SetShow(show)
  fishing_UI.StaticText_KeyGuideX:SetShow(show)
end
function PaGlobalFunc_FishingCheckBox_GetCheckBoxShow()
  if nil == Panel_Fishing then
    return
  end
  if false == fishing_UI._staticText_CheckBox:GetShow() or false == fishing_UI._checkBox_DropTrash:GetShow() or false == fishing_UI.StaticText_KeyGuideX:GetShow() then
    return false
  elseif true == fishing_UI._staticText_CheckBox:GetShow() and true == fishing_UI._checkBox_DropTrash:GetShow() and true == fishing_UI.StaticText_KeyGuideX:GetShow() then
    return true
  end
end
function PaGlobalFunc_FishingCheckBox_SetCheckByPad()
  if nil == Panel_Fishing or false == PaGlobalFunc_FishingCheckBox_GetCheckBoxShow() then
    return
  end
  if nil ~= ToClient_getSnappedControl() or IsHideFishingGame() or true == ToClient_padSnapIsUse() then
    return
  end
  if false == fishing_UI._checkBox_DropTrash:IsCheck() then
    fishing_UI._checkBox_DropTrash:SetCheck(true)
    getSelfPlayer():setFishingAutoItemGrade(1)
  else
    fishing_UI._checkBox_DropTrash:SetCheck(false)
    getSelfPlayer():setFishingAutoItemGrade(0)
  end
end
function PaGlobalFunc_FishingCheckBox_UpdatePerFrameFunc(deltaTime)
  if nil == Panel_Fishing or false == PaGlobalFunc_FishingCheckBox_GetCheckBoxShow() then
    return
  end
  if ToClient_isConsole() and isPadUp(__eJoyPadInputType_X) and nil ~= PaGlobalFunc_FishingCheckBox_SetCheckByPad() then
    PaGlobalFunc_FishingCheckBox_SetCheckByPad()
  end
end
ActionChartEventBindFunction(211, FishingGame_Manual_Fishing_0)
ActionChartEventBindFunction(212, FishingGame_Manual_Fishing_1)
ActionChartEventBindFunction(213, FishingGame_Manual_Fishing_2)
ActionChartEventBindFunction(214, FishingGame_Manual_Fishing_Start)
ActionChartEventBindFunction(215, FishingGame_Manual_Fishing_3)
ActionChartEventBindFunction(216, FishingGame_Manual_CommonGaugeOpen)
ActionChartEventBindFunction(217, MiniGame_Manual_CannonGaugeOpen)
ActionChartEventBindFunction(218, FishingGame_Manual_Fishing_Auto)
ActionChartEventBindFunction(219, FishingGame_Manual_Fishing_Wait)
ActionChartEventBindFunction(281, MiniGame_Manual_Jaksal_0)
ActionChartEventBindFunction(282, MiniGame_Manual_Jaksal_1)
ActionChartEventBindFunction(283, MiniGame_Manual_Jaksal_2)
ActionChartEventBindFunction(284, MiniGame_Manual_Jaksal_3)
ActionChartEventBindFunction(285, MiniGame_Manual_Jaksal_4)
ActionChartEventBindFunction(286, MiniGame_Manual_Jaksal_5)
