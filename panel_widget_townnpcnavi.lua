local UI_color = Defines.Color
local UI_ST = CppEnums.SpawnType
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV = CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
Panel_Widget_TownNpcNavi:RegisterShowEventFunc(true, "Panel_Widget_TownNpcNavi_ShowAni()")
Panel_Widget_TownNpcNavi:RegisterShowEventFunc(false, "Panel_Widget_TownNpcNavi_HideAni()")
Panel_Widget_TownNpcNavi:SetShow(false)
Panel_Widget_TownNpcNavi:setMaskingChild(true)
Panel_Widget_TownNpcNavi:ActiveMouseEventEffect(true)
local isSupplyEnable = ToClient_IsContentsGroupOpen("22")
local isTradeEnable = ToClient_IsContentsGroupOpen("26")
function Panel_Widget_TownNpcNavi_ShowAni()
  Panel_Widget_TownNpcNavi:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toLeft.dds")
  local FadeMaskAni = Panel_Widget_TownNpcNavi:addTextureUVAnimation(0, 1.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0, 0)
  FadeMaskAni:SetEndUV(0.6, 0, 0)
  FadeMaskAni:SetStartUV(0.3, 0, 1)
  FadeMaskAni:SetEndUV(0.9, 0, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0.6, 1, 2)
  FadeMaskAni:SetStartUV(0.3, 1, 3)
  FadeMaskAni:SetEndUV(0.9, 1, 3)
  Panel_Widget_TownNpcNavi:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo8 = Panel_Widget_TownNpcNavi:addColorAnimation(0, 1.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(3)
  aniInfo8:SetEndIntensity(1)
  aniInfo3.IsChangeChild = true
end
function Panel_Widget_TownNpcNavi_HideAni()
  Panel_Widget_TownNpcNavi:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toLeft.dds")
  local FadeMaskAni = Panel_Widget_TownNpcNavi:addTextureUVAnimation(0, 1.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0.6, 0, 0)
  FadeMaskAni:SetEndUV(0, 0, 0)
  FadeMaskAni:SetStartUV(0.9, 0, 1)
  FadeMaskAni:SetEndUV(0.3, 0, 1)
  FadeMaskAni:SetStartUV(0.6, 1, 2)
  FadeMaskAni:SetEndUV(0, 1, 2)
  FadeMaskAni:SetStartUV(0.9, 1, 3)
  FadeMaskAni:SetEndUV(0.3, 1, 3)
  Panel_Widget_TownNpcNavi:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo3 = Panel_Widget_TownNpcNavi:addColorAnimation(0, 1.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo3:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo3.IsChangeChild = true
  aniInfo3:SetHideAtEnd(true)
end
local npcTypeText = {
  [UI_ST.eSpawnType_SkillTrainer] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_1"),
  [UI_ST.eSpawnType_ItemRepairer] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_2"),
  [UI_ST.eSpawnType_ShopMerchant] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_3"),
  [UI_ST.eSpawnType_ImportantNpc] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_4"),
  [UI_ST.eSpawnType_TradeMerchant] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_5"),
  [UI_ST.eSpawnType_WareHouse] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_6"),
  [UI_ST.eSpawnType_Stable] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_7"),
  [UI_ST.eSpawnType_Wharf] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_8"),
  [UI_ST.eSpawnType_transfer] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_9"),
  [UI_ST.eSpawnType_intimacy] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_10"),
  [UI_ST.eSpawnType_guild] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_11"),
  [UI_ST.eSpawnType_explorer] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_12"),
  [UI_ST.eSpawnType_inn] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_13"),
  [UI_ST.eSpawnType_auction] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_14"),
  [UI_ST.eSpawnType_mating] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_15"),
  [UI_ST.eSpawnType_Potion] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_16"),
  [UI_ST.eSpawnType_Weapon] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_17"),
  [UI_ST.eSpawnType_Jewel] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_18"),
  [UI_ST.eSpawnType_Furniture] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_19"),
  [UI_ST.eSpawnType_Collect] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_20"),
  [UI_ST.eSpawnType_Fish] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_21"),
  [UI_ST.eSpawnType_Worker] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_22"),
  [UI_ST.eSpawnType_Alchemy] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_23"),
  [UI_ST.eSpawnType_GuildShop] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_24"),
  [UI_ST.eSpawnType_ItemMarket] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_25"),
  [UI_ST.eSpawnType_TerritorySupply] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_26"),
  [UI_ST.eSpawnType_TerritoryTrade] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_27"),
  [UI_ST.eSpawnType_Smuggle] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_28"),
  [UI_ST.eSpawnType_Cook] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_29"),
  [UI_ST.eSpawnType_PC] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_30"),
  [UI_ST.eSpawnType_Grocery] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_31"),
  [UI_ST.eSpawnType_RandomShop] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_32"),
  [UI_ST.eSpawnType_SupplyShop] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_33"),
  [UI_ST.eSpawnType_RandomShopDay] = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_NPCTYPETEXT_34")
}
local iconTexture = {
  [UI_ST.eSpawnType_SkillTrainer] = {
    2,
    2,
    38,
    38,
    2,
    39,
    38,
    75,
    2,
    76,
    38,
    112
  },
  [UI_ST.eSpawnType_ItemRepairer] = {
    39,
    2,
    75,
    38,
    39,
    39,
    75,
    75,
    39,
    76,
    75,
    112
  },
  [UI_ST.eSpawnType_ShopMerchant] = {
    76,
    2,
    112,
    38,
    76,
    39,
    112,
    75,
    76,
    76,
    112,
    112
  },
  [UI_ST.eSpawnType_TradeMerchant] = {
    113,
    2,
    149,
    38,
    113,
    39,
    149,
    75,
    113,
    76,
    149,
    112
  },
  [UI_ST.eSpawnType_WareHouse] = {
    150,
    2,
    186,
    38,
    150,
    39,
    186,
    75,
    150,
    76,
    186,
    112
  },
  [UI_ST.eSpawnType_Stable] = {
    187,
    2,
    223,
    38,
    187,
    39,
    223,
    75,
    187,
    76,
    223,
    112
  },
  [UI_ST.eSpawnType_Wharf] = {
    224,
    2,
    260,
    38,
    224,
    39,
    260,
    75,
    224,
    76,
    260,
    112
  },
  [UI_ST.eSpawnType_guild] = {
    261,
    2,
    297,
    38,
    261,
    39,
    297,
    75,
    261,
    76,
    297,
    112
  },
  [UI_ST.eSpawnType_auction] = {
    298,
    2,
    334,
    38,
    298,
    39,
    334,
    75,
    298,
    76,
    334,
    112
  },
  [UI_ST.eSpawnType_Potion] = {
    2,
    113,
    38,
    149,
    2,
    150,
    38,
    186,
    2,
    187,
    38,
    223
  },
  [UI_ST.eSpawnType_Weapon] = {
    39,
    113,
    75,
    149,
    39,
    150,
    75,
    186,
    39,
    187,
    75,
    223
  },
  [UI_ST.eSpawnType_Jewel] = {
    76,
    113,
    112,
    149,
    76,
    150,
    112,
    186,
    76,
    187,
    112,
    223
  },
  [UI_ST.eSpawnType_Collect] = {
    113,
    113,
    149,
    149,
    113,
    150,
    149,
    186,
    113,
    187,
    149,
    223
  },
  [UI_ST.eSpawnType_Fish] = {
    150,
    113,
    186,
    149,
    150,
    150,
    186,
    186,
    150,
    187,
    186,
    223
  },
  [UI_ST.eSpawnType_Worker] = {
    187,
    113,
    223,
    149,
    187,
    150,
    223,
    186,
    187,
    187,
    223,
    223
  },
  [UI_ST.eSpawnType_ItemMarket] = {
    224,
    113,
    260,
    149,
    224,
    150,
    260,
    186,
    224,
    187,
    260,
    223
  },
  [UI_ST.eSpawnType_TerritorySupply] = {
    261,
    113,
    297,
    149,
    261,
    150,
    297,
    186,
    261,
    187,
    297,
    223
  },
  [UI_ST.eSpawnType_TerritoryTrade] = {
    298,
    113,
    334,
    149,
    298,
    150,
    334,
    186,
    298,
    187,
    334,
    223
  },
  [UI_ST.eSpawnType_Cook] = {
    2,
    224,
    38,
    260,
    2,
    261,
    38,
    297,
    2,
    298,
    38,
    334
  },
  [UI_ST.eSpawnType_Furniture] = {
    39,
    224,
    75,
    260,
    39,
    261,
    75,
    297,
    39,
    298,
    75,
    334
  },
  [UI_ST.eSpawnType_transfer] = {
    76,
    224,
    112,
    260,
    76,
    261,
    112,
    297,
    76,
    298,
    112,
    334
  }
}
local toggleBtn
if false == _ContentsGroup_RemasterUI_Main_RightTop then
  if nil ~= Panel_PersonalIcon then
    toggleBtn = FGlobal_GetPersonalIconControl(0)
    if false == _ContentsGroup_RenewUI_VoiceChat then
      toggleBtn:SetShow(true)
    else
      toggleBtn:SetShow(false)
    end
    toggleBtn:addInputEvent("Mouse_LUp", "NpcNavi_ShowToggle()")
  end
else
  toggleBtn = PaGlobalFunc_Widget_FunctionButton_Control(Widget_Function_Type.FindNPC)
end
local iconBG = UI.getChildControl(Panel_Widget_TownNpcNavi, "StaticText_ToolTip")
local npcIcon = UI.getChildControl(Panel_Widget_TownNpcNavi, "StaticText_TownNpcNavi_Icon")
iconBG:SetShow(false)
local iconSize = npcIcon:GetSizeX()
local iconStartPosY = 275
local _spawnType, _isAuto
local _isCheck = false
function HandleClicked_TownNpcIcon_NaviStart(spawnType, isAuto)
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  if nil == isAuto then
    isAuto = false
  end
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  ToClient_DeleteNaviGuideByGroup(0)
  _spawnType = spawnType
  local position = player:get3DPos()
  local nearNpcInfo = getNearNpcInfoByType(spawnType, position)
  if nil == nearNpcInfo then
    return
  end
  local curChannelData = getCurrentChannelServerData()
  if false == curChannelData._isMain and UI_ST.eSpawnType_TerritoryTrade == spawnType then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_TOWNNPCNAVI_IMPERIAL_DELIVERY_ONLY_FIRSTCH"))
    return
  end
  local isSpawnNearNpc = nearNpcInfo:isTimeSpawn()
  local pos = nearNpcInfo:getPosition()
  local npcNaviKey = ToClient_WorldMapNaviStart(pos, NavigationGuideParam(), isAuto, isAuto)
  audioPostEvent_SystemUi(0, 14)
  _AudioPostEvent_SystemUiForXBOX(0, 14)
  local selfPlayer = getSelfPlayer():get()
  selfPlayer:setNavigationMovePath(npcNaviKey)
  selfPlayer:checkNaviPathUI(npcNaviKey)
  if false == isSpawnNearNpc then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "NPCNAVIGATION_REST_AVAILABLE"))
  end
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOWNNPCNAVI_NAVIGATIONDESCRIPTION", "npcName", tostring(npcTypeText[spawnType])))
  TownfunctionNavi_Set()
  PaGlobal_TutorialManager:handleClickedTownNpcIconNaviStart(spawnType, isAuto)
end
local function npcIconChangeTexture(icon, spawnType)
  if nil == iconTexture[spawnType] then
    spawnType = UI_ST.eSpawnType_ShopMerchant
  end
  icon:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Default/NpcIcon_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(icon, iconTexture[spawnType][1], iconTexture[spawnType][2], iconTexture[spawnType][3], iconTexture[spawnType][4])
  icon:getBaseTexture():setUV(x1, y1, x2, y2)
  icon:setRenderTexture(icon:getBaseTexture())
  icon:ChangeOnTextureInfoNameAsync("New_UI_Common_forLua/Default/NpcIcon_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(icon, iconTexture[spawnType][5], iconTexture[spawnType][6], iconTexture[spawnType][7], iconTexture[spawnType][8])
  icon:getOnTexture():setUV(x1, y1, x2, y2)
  icon:ChangeClickTextureInfoNameAsync("New_UI_Common_forLua/Default/NpcIcon_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(icon, iconTexture[spawnType][9], iconTexture[spawnType][10], iconTexture[spawnType][11], iconTexture[spawnType][12])
  icon:getClickTexture():setUV(x1, y1, x2, y2)
end
local npcNaviIcon = {}
local iconTypeCount = 0
local slotConfig = {
  slotCount = 20,
  slotCols = 3,
  slotRows = 0,
  slotStartX = 25,
  slotStartY = 60,
  slotGapX = 130,
  slotGapY = 38
}
Panel_Widget_TownNpcNavi:SetShow(not isRecordMode, true)
function TownfunctionNavi_Set()
  if isFlushedUI() then
    return
  end
  iconTypeCount = UI_ST.eSpawnType_Count - 1
  local spawnType = {}
  for index = 1, UI_ST.eSpawnType_Count - 1 do
    local function pushTownNpcIcon(i, index)
      if nil ~= npcNaviIcon[i] then
        UI.deleteControl(npcNaviIcon[i])
      end
      local tempIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_NpcNavi, "NpcNavi_Icon_" .. index)
      CopyBaseProperty(npcIcon, tempIcon)
      npcNaviIcon[i] = tempIcon
      local npcNameColor = "<PAColor0xffc4bebe>" .. npcTypeText[spawnType[i]] .. "<PAOldColor>"
      if index == _spawnType then
        npcNameColor = "<PAColor0xFFFFEF82>" .. npcTypeText[spawnType[i]] .. "<PAOldColor>"
      end
      npcNaviIcon[i]:SetTextMode(UI_TM.eTextMode_LimitText)
      npcNaviIcon[i]:SetText(npcNameColor)
      local isUse = ToClient_HasClientSpawnByType(index)
      npcNaviIcon[i]:SetShow(isUse)
      npcIconChangeTexture(npcNaviIcon[i], index)
      if not isSupplyEnable and UI_ST.eSpawnType_TerritorySupply == index then
        npcNaviIcon[i]:SetShow(false)
      end
      if not isTradeEnable and UI_ST.eSpawnType_TerritoryTrade == index then
        npcNaviIcon[i]:SetShow(false)
      end
      if index == UI_ST.eSpawnType_ShopMerchant then
        npcNaviIcon[i]:SetShow(false)
      elseif index == UI_ST.eSpawnType_auction then
        npcNaviIcon[i]:SetShow(false)
      end
      npcNaviIcon[i]:SetEnableArea(0, 0, 125, 28)
    end
    if UI_ST.eSpawnType_SkillTrainer == index then
      spawnType[0] = index
      pushTownNpcIcon(0, index)
    elseif UI_ST.eSpawnType_ItemRepairer == index then
      spawnType[1] = index
      pushTownNpcIcon(1, index)
    elseif UI_ST.eSpawnType_WareHouse == index then
      spawnType[2] = index
      pushTownNpcIcon(2, index)
    elseif UI_ST.eSpawnType_transfer == index then
      spawnType[3] = index
      pushTownNpcIcon(3, index)
    elseif UI_ST.eSpawnType_Stable == index then
      spawnType[4] = index
      pushTownNpcIcon(4, index)
    elseif UI_ST.eSpawnType_Wharf == index then
      spawnType[5] = index
      pushTownNpcIcon(5, index)
    elseif UI_ST.eSpawnType_guild == index then
      spawnType[6] = index
      pushTownNpcIcon(6, index)
    elseif UI_ST.eSpawnType_TradeMerchant == index then
      spawnType[7] = index
      pushTownNpcIcon(7, index)
    elseif UI_ST.eSpawnType_Potion == index then
      spawnType[8] = index
      pushTownNpcIcon(8, index)
    elseif UI_ST.eSpawnType_Weapon == index then
      spawnType[9] = index
      pushTownNpcIcon(9, index)
    elseif UI_ST.eSpawnType_Jewel == index then
      spawnType[10] = index
      pushTownNpcIcon(10, index)
    elseif UI_ST.eSpawnType_Furniture == index then
      spawnType[11] = index
      pushTownNpcIcon(11, index)
    elseif UI_ST.eSpawnType_Collect == index then
      spawnType[12] = index
      pushTownNpcIcon(12, index)
    elseif UI_ST.eSpawnType_Fish == index then
      spawnType[13] = index
      pushTownNpcIcon(13, index)
    elseif UI_ST.eSpawnType_Cook == index then
      spawnType[14] = index
      pushTownNpcIcon(14, index)
    elseif UI_ST.eSpawnType_Worker == index then
      spawnType[15] = index
      pushTownNpcIcon(15, index)
    elseif UI_ST.eSpawnType_ItemMarket == index then
      spawnType[16] = index
      pushTownNpcIcon(16, index)
    elseif UI_ST.eSpawnType_TerritorySupply == index then
      spawnType[17] = index
      pushTownNpcIcon(17, index)
    elseif UI_ST.eSpawnType_TerritoryTrade == index then
      spawnType[18] = index
      pushTownNpcIcon(18, index)
    else
      iconTypeCount = iconTypeCount - 1
    end
  end
  slotConfig.slotRows = slotConfig.slotCount / slotConfig.slotCols
  for ii = 0, iconTypeCount - 1 do
    local row = math.floor(ii / slotConfig.slotCols)
    local col = ii % slotConfig.slotCols
    npcNaviIcon[ii]:SetPosX(slotConfig.slotStartX + slotConfig.slotGapX * col)
    npcNaviIcon[ii]:SetPosY(slotConfig.slotStartY + slotConfig.slotGapY * row)
    npcNaviIcon[ii]:addInputEvent("Mouse_On", "HandleOn_IconSizeUp(" .. ii .. ", " .. spawnType[ii] .. ")")
    npcNaviIcon[ii]:addInputEvent("Mouse_Out", "HandleOn_IconSizeUp()")
    npcNaviIcon[ii]:setTooltipEventRegistFunc("TownNpcIcon_Tooltip( " .. ii .. ", " .. spawnType[ii] .. " )")
    npcNaviIcon[ii]:addInputEvent("Mouse_LUp", "HandleClicked_TownNpcIcon_NaviStart(" .. spawnType[ii] .. ")")
    npcNaviIcon[ii]:addInputEvent("Mouse_RUp", "HandleClicked_TownNpcIcon_NaviStart(" .. spawnType[ii] .. ", " .. "true)")
  end
end
function HandleOn_IconSizeUp(index, spawnType)
  if nil == index then
    TownNpcIcon_Tooltip()
    TownfunctionNavi_Set()
  else
    registTooltipControl(npcNaviIcon[index], Panel_Tooltip_SimpleText)
    TownNpcIcon_Tooltip(index, spawnType)
  end
end
function TownNpcIcon_Tooltip(index, spawnType)
  local name = npcTypeText[spawnType]
  local uiControl = npcNaviIcon[index]
  local desc
  if nil == index then
    TooltipSimple_Hide()
  else
    TooltipSimple_Show(uiControl, name, desc)
  end
end
function TownNpcIcon_Resize()
  Panel_Widget_TownNpcNavi:SetPosX(getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - Panel_Widget_TownNpcNavi:GetSizeX() - 20)
  Panel_Widget_TownNpcNavi:SetPosY(10)
end
function FGlobal_TownfunctionNavi_Set()
  TownfunctionNavi_Set()
end
function FGlobal_TownfunctionNavi_SetWorldMap()
  if not Panel_Widget_TownNpcNavi:GetShow() then
    Panel_Widget_TownNpcNavi:SetShow(true)
  end
  TownfunctionNavi_Set()
  Panel_Widget_TownNpcNavi:SetPosX(getScreenSizeX() - Panel_Widget_TownNpcNavi:GetSizeX() - 20)
  Panel_Widget_TownNpcNavi:SetPosY(10)
end
function FGlobal_TownfunctionNavi_UnSetWorldMap()
  if not Panel_Widget_TownNpcNavi:GetShow() then
    Panel_Widget_TownNpcNavi:SetShow(true)
  end
  TownNpcIcon_Resize()
end
function FromClient_SpawnTypeInit()
  _spawnType = -1
  TownfunctionNavi_Set()
end
function FGlobal_TownNpcNavi_AddEffect(effectName, isLoop, offsetPosX, offsetPosY)
  toggleBtn:AddEffect(effectName, isLoop, offsetPosX, offsetPosY)
end
function FGlobal_TownNpcNavi_EraseAllEffect()
  toggleBtn:EraseAllEffect()
end
function FGlobal_TownNpcNavi_GetFindNaviButton()
  return toggleBtn
end
function FGlobal_TownNpcNavi_GetUiControlNpcNaviIconByArrayIndex(arrayIndex)
  return npcNaviIcon[arrayIndex]
end
function FGlobal_TownNavi_SetEffectForNewbie(bShow)
  toggleBtn:EraseAllEffect()
  if true == bShow then
    if nil == getSelfPlayer() then
      return
    end
    if 51 < getSelfPlayer():get():getLevel() then
      return
    end
    toggleBtn:AddEffect("UI_NPCNavi_Line", true, -1, 1)
  end
end
local townNaviEffectTimeCheck = 0
function FGlobal_TownNpcNavi_UpdatePerFrame(deltaTime)
  townNaviEffectTimeCheck = townNaviEffectTimeCheck + deltaTime
  if townNaviEffectTimeCheck > 10 then
    if false == PaGlobal_TutorialManager:isDoingTutorial() then
    end
    townNaviEffectTimeCheck = 0
  end
end
Panel_Widget_TownNpcNavi:RegisterUpdateFunc("FGlobal_TownNpcNavi_UpdatePerFrame")
TownNpcIcon_Resize()
registerEvent("selfPlayer_regionChanged", "TownfunctionNavi_Set")
registerEvent("onScreenResize", "TownNpcIcon_Resize")
registerEvent("FromClient_DeleteNavigationGuide", "FromClient_SpawnTypeInit")
registerEvent("FromClient_ClearNavigationGuide", "FromClient_SpawnTypeInit")
