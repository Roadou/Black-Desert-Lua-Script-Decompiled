local UI_TM = CppEnums.TextMode
local isharvestManagement = true
Panel_MyHouseNavi:RegisterShowEventFunc(true, "MyHouseNaviShowAni()")
Panel_MyHouseNavi:RegisterShowEventFunc(false, "MyHouseNaviHideAni()")
Panel_MyHouseNavi:SetDragEnable(false)
Panel_MyHouseNavi:SetPosY(Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15)
function MyHouseNaviShowAni()
  UIAni.fadeInSCR_Down(Panel_MyHouseNavi)
end
function MyHouseNaviHideAni()
  Panel_MyHouseNavi:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_MyHouseNavi:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local isCheckTentPosition = false
local isCheckHousePosition = false
local _houseIcon = UI.getChildControl(Panel_MyHouseNavi, "Static_Icon_House")
local _houseBorder = UI.getChildControl(Panel_MyHouseNavi, "Static_SlotBackground")
local _tentIcon = UI.getChildControl(Panel_MyHouseNavi, "Static_Icon_Tent")
local _tentBorder = UI.getChildControl(Panel_MyHouseNavi, "Static_SlotBackground_Tent")
local _territoryIcon = UI.getChildControl(Panel_MyHouseNavi, "Static_Icon_TerritoryAuth")
local _territoryBorder = UI.getChildControl(Panel_MyHouseNavi, "Static_SlotBackground_TerritoryAuth")
local _workerIcon = UI.getChildControl(Panel_MyHouseNavi, "Static_Icon_Worker")
local _helpTooltip = UI.getChildControl(Panel_MyHouseNavi, "StaticText_Helper")
Panel_MyHouseNavi:SetShow(false)
_houseIcon:SetShow(false)
_tentIcon:SetShow(false)
_territoryIcon:SetShow(false)
_houseIcon:SetIgnore(true)
_tentIcon:SetIgnore(true)
_territoryIcon:SetIgnore(true)
_houseBorder:SetShow(false)
_tentBorder:SetShow(false)
_territoryBorder:SetShow(false)
_helpTooltip:SetShow(false)
_workerIcon:SetShow(false)
local posY, posX
local function Panel_MyHouseNavi_Init()
  posY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15
  posX = 0
  if Panel_Window_Servant:GetShow() then
    posX = Panel_Window_Servant:GetPosX() + Panel_Window_Servant:GetSizeX()
  else
    posX = 10
  end
  local servantIconCount = FGlobal_ServantIconCount()
  if Panel_MyHouseNavi:GetRelativePosX() == -1 and Panel_MyHouseNavi:GetRelativePosY() == -1 then
    local isChangePosition = changePositionBySever(Panel_MyHouseNavi, CppEnums.PAGameUIType.PAGameUIPanel_MyHouseNavi, false, true, false)
    if not isChangePosition then
      if Panel_Window_Servant:GetShow() then
        Panel_MyHouseNavi:SetPosX(posX)
        Panel_MyHouseNavi:SetPosY(Panel_Window_Servant:GetPosY())
      else
        Panel_MyHouseNavi:SetPosX(10)
        Panel_MyHouseNavi:SetPosY(posY)
      end
    elseif Panel_Window_Servant:GetShow() then
      local x1 = Panel_Window_Servant:GetPosX()
      local y1 = Panel_Window_Servant:GetPosY()
      local x2 = Panel_Window_Servant:GetPosX() + Panel_Window_Servant:GetSizeX()
      local y2 = Panel_Window_Servant:GetPosY() + Panel_Window_Servant:GetSizeY()
      for index = 0, Panel_MyHouseNavi:GetSizeX(), 10 do
        if x1 <= Panel_MyHouseNavi:GetPosX() + index and x2 >= Panel_MyHouseNavi:GetPosX() + index and (y1 <= Panel_MyHouseNavi:GetPosY() and y2 >= Panel_MyHouseNavi:GetPosY() or y1 <= Panel_MyHouseNavi:GetPosY() + Panel_MyHouseNavi:GetSizeY() / 2 and y2 >= Panel_MyHouseNavi:GetPosY() + Panel_MyHouseNavi:GetSizeY() / 2 or y1 <= Panel_MyHouseNavi:GetPosY() + Panel_MyHouseNavi:GetSizeY() and y2 >= Panel_MyHouseNavi:GetPosY() + Panel_MyHouseNavi:GetSizeY()) then
          Panel_MyHouseNavi:SetPosX(Panel_Window_Servant:GetPosX() + Panel_Window_Servant:GetSizeX())
          Panel_MyHouseNavi:SetPosY(Panel_Window_Servant:GetPosY())
        end
      end
    else
      local lPanel = Panel_MyHouseNavi
      if not isChangePosition then
        lPanel:SetRelativePosX(0)
        lPanel:SetRelativePosY(0)
      else
        lPanel:SetRelativePosX((lPanel:GetPosX() + lPanel:GetSizeX() / 2) / getScreenSizeX())
        lPanel:SetRelativePosY((lPanel:GetPosY() + lPanel:GetSizeY() / 2) / getScreenSizeY())
      end
    end
  elseif Panel_MyHouseNavi:GetRelativePosX() == 0 and Panel_MyHouseNavi:GetRelativePosY() == 0 then
    if Panel_Window_Servant:GetShow() then
      Panel_MyHouseNavi:SetPosX(posX)
      Panel_MyHouseNavi:SetPosY(Panel_Window_Servant:GetPosY())
    else
      Panel_MyHouseNavi:SetPosX(10)
      Panel_MyHouseNavi:SetPosY(posY)
    end
  elseif Panel_Window_Servant:GetShow() then
    local x1 = Panel_Window_Servant:GetPosX()
    local y1 = Panel_Window_Servant:GetPosY()
    local x2 = Panel_Window_Servant:GetPosX() + Panel_Window_Servant:GetSizeX()
    local y2 = Panel_Window_Servant:GetPosY() + Panel_Window_Servant:GetSizeY()
    Panel_MyHouseNavi:SetPosX(getScreenSizeX() * Panel_MyHouseNavi:GetRelativePosX() - Panel_MyHouseNavi:GetSizeX() / 2)
    Panel_MyHouseNavi:SetPosY(getScreenSizeY() * Panel_MyHouseNavi:GetRelativePosY() - Panel_MyHouseNavi:GetSizeY() / 2)
    for index = 0, Panel_MyHouseNavi:GetSizeX(), 10 do
      if x1 <= Panel_MyHouseNavi:GetPosX() + index and x2 >= Panel_MyHouseNavi:GetPosX() + index and (y1 <= Panel_MyHouseNavi:GetPosY() and y2 >= Panel_MyHouseNavi:GetPosY() or y1 <= Panel_MyHouseNavi:GetPosY() + Panel_MyHouseNavi:GetSizeY() / 2 and y2 >= Panel_MyHouseNavi:GetPosY() + Panel_MyHouseNavi:GetSizeY() / 2 or y1 <= Panel_MyHouseNavi:GetPosY() + Panel_MyHouseNavi:GetSizeY() and y2 >= Panel_MyHouseNavi:GetPosY() + Panel_MyHouseNavi:GetSizeY()) then
        Panel_MyHouseNavi:SetPosX(Panel_Window_Servant:GetPosX() + Panel_Window_Servant:GetSizeX())
        Panel_MyHouseNavi:SetPosY(Panel_Window_Servant:GetPosY())
      end
    end
  else
    Panel_MyHouseNavi:SetPosX(getScreenSizeX() * Panel_MyHouseNavi:GetRelativePosX() - Panel_MyHouseNavi:GetSizeX() / 2)
    Panel_MyHouseNavi:SetPosY(getScreenSizeY() * Panel_MyHouseNavi:GetRelativePosY() - Panel_MyHouseNavi:GetSizeY() / 2)
  end
  FGlobal_PanelRepostionbyScreenOut(Panel_MyHouseNavi)
  FGlobal_PetListNew_NoPet()
  checkAndSetPosInScreen(Panel_MyHouseNavi)
end
function HouseNaviBasicInitPosition()
  if Panel_Window_Servant:GetShow() then
    posX = Panel_Window_Servant:GetPosX() + Panel_Window_Servant:GetSizeX()
  else
    posX = 10
  end
  Panel_MyHouseNavi:SetPosX(posX)
  Panel_MyHouseNavi:SetPosY(Panel_Window_Servant:GetPosY())
  checkAndSetPosInScreen(Panel_MyHouseNavi)
end
local houseIconCount = 0
local gapX = _houseIcon:GetSizeX()
local firstLoadingCheck = true
function Panel_MyHouseNavi_Update(init, listCount)
  if nil == init and isFlushedUI() or isFlushedUI() then
    return
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() then
    return
  end
  local iconNums = 0
  local isHaveDwelling = ToClient_IsHaveDwelling()
  local panelSizeX = 0
  if isHaveDwelling == true then
    _houseIcon:SetShow(true)
    _houseIcon:SetIgnore(false)
    _houseIcon:ActiveMouseEventEffect(true)
    _houseBorder:SetShow(false)
    _houseBorder:SetIgnore(true)
    _houseIcon:addInputEvent("Mouse_LUp", "FGlobal_HousingList_Open()")
    _houseIcon:addInputEvent("Mouse_On", "HandleMouseOnTooltip( \"selfHouse\", true )")
    _houseIcon:addInputEvent("Mouse_Out", "HandleMouseOnTooltip( \"selfHouse\", false )")
    iconNums = iconNums + 1
  else
    _houseIcon:SetShow(false)
    _houseIcon:SetIgnore(true)
    _houseIcon:ActiveMouseEventEffect(false)
    _houseBorder:SetShow(false)
    _houseBorder:SetIgnore(true)
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local tentCheck = nil ~= temporaryWrapper and temporaryWrapper:isSelfTent()
  if tentCheck then
    _tentIcon:SetShow(true)
    _tentIcon:SetIgnore(false)
    _tentIcon:ActiveMouseEventEffect(true)
    _tentBorder:SetShow(false)
    _tentBorder:SetIgnore(true)
    _tentIcon:SetPosX(iconNums * gapX - 3)
    if isharvestManagement then
      _tentIcon:addInputEvent("Mouse_LUp", "HandleClicked_TentList_ShowToggle()")
    else
      _tentIcon:addInputEvent("Mouse_LUp", "")
    end
    _tentIcon:addInputEvent("Mouse_RUp", "Panel_MyHouseNavi_FindWay( \"tent\" )")
    _tentIcon:addInputEvent("Mouse_On", "HandleMouseOnTooltip( \"tent\", true )")
    _tentIcon:addInputEvent("Mouse_Out", "HandleMouseOnTooltip( \"tent\", false )")
    iconNums = iconNums + 1
  else
    _tentIcon:SetShow(false)
    _tentIcon:SetIgnore(true)
    _tentIcon:ActiveMouseEventEffect(false)
    _tentBorder:SetShow(false)
    _tentBorder:SetIgnore(true)
  end
  local isNpcWorkerCount = 0
  if nil ~= listCount then
    isNpcWorkerCount = listCount
  else
    isNpcWorkerCount = ToClient_getMyNpcWorkerCount()
  end
  if isNpcWorkerCount > 0 then
    _workerIcon:SetShow(true)
    _workerIcon:ActiveMouseEventEffect(true)
    _workerIcon:SetPosX(iconNums * gapX - 3)
    _workerIcon:addInputEvent("Mouse_LUp", "WorkerManager_ShowToggle()")
    _workerIcon:addInputEvent("Mouse_On", "HandleMouseOnTooltip( \"worker\", true )")
    _workerIcon:addInputEvent("Mouse_Out", "HandleMouseOnTooltip( \"worker\", false )")
    iconNums = iconNums + 1
  else
    _workerIcon:SetShow(false)
  end
  if isHaveTerritoryTradeAuthority(0) or isHaveTerritoryTradeAuthority(1) or isHaveTerritoryTradeAuthority(2) or isHaveTerritoryTradeAuthority(3) then
    _territoryIcon:SetShow(true)
    _territoryIcon:SetIgnore(false)
    _territoryIcon:ActiveMouseEventEffect(true)
    _territoryBorder:SetShow(false)
    _territoryBorder:SetIgnore(true)
    _territoryIcon:SetPosX(iconNums * gapX - 3)
    _territoryIcon:addInputEvent("Mouse_On", "HandleMouseOnTooltip( \"territoryAuth\", true )")
    _territoryIcon:addInputEvent("Mouse_Out", "HandleMouseOnTooltip( \"territoryAuth\", false )")
    iconNums = iconNums + 1
  else
    _territoryIcon:SetShow(false)
    _territoryIcon:SetIgnore(true)
    _territoryIcon:ActiveMouseEventEffect(false)
    _territoryBorder:SetShow(false)
    _territoryBorder:SetIgnore(true)
  end
  panelSizeX = iconNums * gapX
  if 0 == panelSizeX then
    panelSizeX = 60
  end
  if iconNums > 0 then
    Panel_MyHouseNavi:SetShow(true)
    Panel_MyHouseNavi_Init()
  else
    Panel_MyHouseNavi:SetShow(false)
  end
  if true == _ContentsGroup_RenewUI_Main then
    Panel_MyHouseNavi:SetShow(false)
  end
  Panel_MyHouseNavi:SetSize(panelSizeX, Panel_MyHouseNavi:GetSizeY())
  houseIconCount = iconNums
  if firstLoadingCheck then
    firstLoadingCheck = false
    return
  end
  FGlobal_PetListNew_NoPet()
  if nil ~= PaGlobal_PossessByBlackSpiritIcon and PaGlobal_PossessByBlackSpiritIcon:showAble() then
    PaGlobal_PossessByBlackSpiritIcon_UpdateVisibleState()
  end
  PaGlobal_CharacterTag_SetPosIcon()
  if nil ~= PaGlobal_Fairy_SetPosIcon then
    PaGlobal_Fairy_SetPosIcon()
  end
end
function return_ServantIconNums(icons)
  if Panel_MyHouseNavi:GetPosX() <= 60 * icons then
    Panel_MyHouseNavi:SetPosX(60 * icons)
    Panel_MyHouseNavi:SetPosY(posY)
  else
    changePositionBySever(Panel_MyHouseNavi, CppEnums.PAGameUIType.PAGameUIPanel_MyHouseNavi, true, true, false)
  end
end
function FGlobal_HouseIconCount()
  return houseIconCount
end
function WorkerManager_ShowToggle()
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    PaGlobalFunc_WorkerManager_All_ShowToggle()
  else
    FGlobal_WorkerManger_ShowToggle()
  end
end
function HandleMouseOnTooltip(naviType, isShow)
  local name, desc, uiControl
  if naviType == "selfHouse" then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_SELFHOUSE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_SELFHOUSE_DESC")
    uiControl = _houseIcon
  elseif naviType == "tent" then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_TENT_NAME")
    if isharvestManagement then
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_TENT_DESC")
    else
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_TENT_DESC_2")
    end
    uiControl = _tentIcon
  elseif naviType == "worker" then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_WORKER_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_WORKER_TOOLTIP_DESC")
    uiControl = _workerIcon
  elseif naviType == "territoryAuth" then
    local territoryName = {
      [0] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_0")),
      [1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_1")),
      [2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_2")),
      [3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_3"))
    }
    name = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_TERRITORYAUTH_NAME")
    desc = ""
    uiControl = _territoryIcon
    for territoryIndex = 0, 3 do
      if true == isHaveTerritoryTradeAuthority(territoryIndex) then
        if "" == desc then
          desc = territoryName[territoryIndex]
        else
          desc = desc .. " / " .. territoryName[territoryIndex]
        end
      end
    end
    if "" ~= desc then
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_TERRITORYAUTH_DESC", "desc", desc)
    end
  end
  if true == isShow then
    TooltipSimple_Show(uiControl, name, desc)
    if getEnableSimpleUI() then
      House_UpdateSimpleUI(true)
    end
  else
    TooltipSimple_Hide()
    if getEnableSimpleUI() then
      House_UpdateSimpleUI(false)
    end
  end
end
local _houseSimpleUIAlpha = 0.7
function House_UpdateSimpleUI(isOver)
  _houseSimpleUIAlpha = 0.7
  if isOver then
    _houseSimpleUIAlpha = 1
  end
end
function Panel_MyHouseNavi_FindWay(naviType)
  if naviType == "tent" and isCheckTentPosition == false then
    ToClient_DeleteNaviGuideByGroup(0)
    local navigationGuideParam = NavigationGuideParam()
    navigationGuideParam._isAutoErase = true
    local temporaryWrapper = getTemporaryInformationWrapper()
    if nil ~= temporaryWrapper then
      local myTentCount = temporaryWrapper:getSelfTentCount()
      for textIdx = 0, myTentCount - 1 do
        local tentWrapper = temporaryWrapper:getSelfTentWrapperByIndex(textIdx)
        local tentPosX = tentWrapper:getSelfTentPositionX()
        local tentPosY = tentWrapper:getSelfTentPositionY()
        local tentPosZ = tentWrapper:getSelfTentPositionZ()
        local tentPos = float3(tentPosX, tentPosY, tentPosZ)
        worldmapNavigatorStart(tentPos, navigationGuideParam, false, false, true)
      end
      audioPostEvent_SystemUi(0, 14)
      _AudioPostEvent_SystemUiForXBOX(0, 14)
      isCheckTentPosition = true
    end
  elseif isCheckTentPosition == true or isCheckHousePosition == true then
    ToClient_DeleteNaviGuideByGroup(0)
    audioPostEvent_SystemUi(0, 15)
    _AudioPostEvent_SystemUiForXBOX(0, 15)
    isCheckTentPosition = false
    isCheckHousePosition = false
  elseif naviType == "selfHouse" and isCheckHousePosition == false then
    ToClient_DeleteNaviGuideByGroup(0)
    audioPostEvent_SystemUi(0, 14)
    _AudioPostEvent_SystemUiForXBOX(0, 14)
    local characterStaticStatusWrapper = ToClient_getMyDwelling(0)
    if nil == characterStaticStatusWrapper then
      _PA_ASSERT(false, "\236\163\188\234\177\176\236\167\128 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
      return
    end
    local houseX = characterStaticStatusWrapper:getObjectStaticStatus():getHousePosX()
    local houseY = characterStaticStatusWrapper:getObjectStaticStatus():getHousePosY()
    local houseZ = characterStaticStatusWrapper:getObjectStaticStatus():getHousePosZ()
    local housePos = float3(houseX, houseY, houseZ)
    worldmapNavigatorStart(housePos, NavigationGuideParam(), false, false, true)
    isCheckHousePosition = true
  end
end
function HandleClicked_TentList_ShowToggle()
  if Panel_HarvestList:GetShow() then
    HarvestList_Close()
    return
  end
  FGlobal_HarvestList_Open()
end
function Panel_MyHouseNavi_ShowToggle()
  if not ToClient_IsHaveDwelling() and false == _territoryIcon:GetShow() then
    return
  end
  if Panel_MyHouseNavi:GetShow() then
    Panel_MyHouseNavi:SetShow(false, false)
    Panel_WidgetControl_Toggle("Panel_MyHouseNavi", false)
  else
    Panel_MyHouseNavi:SetShow(true, true)
    Panel_WidgetControl_Toggle("Panel_MyHouseNavi", true)
  end
end
function PanelMyHouseNavi_RefreshPosition()
  ResetPos_WidgetButton()
end
function Panel_MyHouseNavi_PositionReset()
  Panel_MyHouseNavi_Init()
end
function Panel_MyHouseNavi:registEventHandler()
  Panel_MyHouseNavi:addInputEvent("Mouse_PressMove", "PanelMyHouseNavi_RefreshPosition()")
  Panel_MyHouseNavi:addInputEvent("Mouse_LUp", "ResetPos_WidgetButton()")
end
function FGlobal_MyHouseNavi_Update()
  Panel_MyHouseNavi_Update(true)
end
function FromClient_ChangeWorkerCount(isInitialize, listCount)
  Panel_MyHouseNavi_Update(isInitialize, listCount)
end
registerEvent("FromClient_ReceiveSetMyHouse", "FGlobal_MyHouseNavi_Update")
registerEvent("FromClient_ReceiveReturnHouse", "FGlobal_MyHouseNavi_Update")
registerEvent("FromClient_SetSelfTent", "FGlobal_MyHouseNavi_Update")
registerEvent("FromClient_ResponseAuctionInfo", "FGlobal_MyHouseNavi_Update")
registerEvent("WorldMap_WorkerDataUpdate", "FGlobal_MyHouseNavi_Update")
registerEvent("onScreenResize", "Panel_MyHouseNavi_PositionReset")
registerEvent("FromClient_ChangeWorkerCount", "FromClient_ChangeWorkerCount")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MyHouseNavi")
function FromClient_luaLoadComplete_MyHouseNavi()
  Panel_MyHouseNavi:registEventHandler()
  FGlobal_PanelMove(Panel_MyHouseNavi, true)
  changePositionBySever(Panel_MyHouseNavi, CppEnums.PAGameUIType.PAGameUIPanel_MyHouseNavi, true, true, false)
end
function renderModeChange_MyHouseNavi_Update(prevRenderModeList, nextRenderModeList)
  local currentRenderMode = {
    Defines.RenderMode.eRenderMode_Default
  }
  if CheckRenderMode(prevRenderModeList, currentRenderMode) or CheckRenderModebyGameMode(nextRenderModeList) then
    Panel_MyHouseNavi_Update()
  end
  Panel_MyHouseNavi_PositionReset()
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_MyHouseNavi_Update")
