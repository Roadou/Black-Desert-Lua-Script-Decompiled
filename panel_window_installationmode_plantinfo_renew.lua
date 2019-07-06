local UI_color = Defines.Color
local Panel_Window_InstallationMode_Plant_info = {
  _ui = {
    staticText_Title = nil,
    static_TabMenuBG = nil,
    staticText_TImerTitle = nil,
    StaticText_Timer = nil,
    staticText_Status1Title = nil,
    staticText_Status1Point = nil,
    progress2_Status1Bar = nil,
    staticText_Status2Title = nil,
    staticText_Status2Point = nil,
    progress2_Status2Bar = nil,
    staticText_Status3Title = nil,
    staticText_Status3Point = nil,
    progress2_Status3Bar = nil,
    static_Icon_Work1 = nil,
    staticText_Work1Title = nil,
    staticText_Work1Dec = nil,
    static_Icon_Work2 = nil,
    staticText_Work2Title = nil,
    staticText_Work2Dec = nil
  },
  _value = {
    isShowOnlyGround = true,
    currentActorKeyRaw = nil,
    isAnimal = false
  },
  _texture = {
    plantPath = "renewal/ui_icon/console_icon_02.dds",
    NeedLopPlant = {
      297,
      193,
      360,
      256
    },
    notNeedLopPlant = {
      233,
      193,
      296,
      256
    },
    NeedPestPlant = {
      297,
      129,
      360,
      192
    },
    notNeedPestPlant = {
      233,
      129,
      296,
      192
    },
    animalPath = "renewal/ui_icon/console_icon_03.dds",
    NeedLopAnimal = {
      65,
      65,
      128,
      128
    },
    notNeedLopAnimal = {
      1,
      65,
      64,
      128
    },
    NeedPestAnimal = {
      65,
      1,
      128,
      64
    },
    notNeedPestAnimal = {
      1,
      1,
      64,
      64
    }
  },
  _pos = {},
  _config = {}
}
function Panel_Window_InstallationMode_Plant_info:registEventHandler()
  Panel_House_InstallationMode_PlantInfo:ignorePadSnapMoveToOtherPanel()
  registerEvent("onScreenResize", "FromClient_InstallationMode_PlantInfo_Resize")
end
function Panel_Window_InstallationMode_Plant_info:registerMessageHandler()
  registerEvent("FromClient_InterActionHarvestInformation", "FromClient_InterActionHarvestInformation")
end
function Panel_Window_InstallationMode_Plant_info:initialize()
  self:childControl()
  self:initValue()
  self:initString()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_InstallationMode_Plant_info:initString()
end
function Panel_Window_InstallationMode_Plant_info:initValue()
  self._value.isShowOnlyGround = true
  self._value.currentActorKeyRaw = nil
end
function Panel_Window_InstallationMode_Plant_info:resize()
  Panel_House_InstallationMode_PlantInfo:ComputePos()
end
function Panel_Window_InstallationMode_Plant_info:childControl()
  self._ui.staticText_Title = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "StaticText_Title")
  self._ui.static_TabMenuBG = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "Static_TabMenuBG")
  self._ui.staticText_TimerTitle = UI.getChildControl(self._ui.static_TabMenuBG, "StaticText_TimerTitle")
  self._ui.staticText_Timer = UI.getChildControl(self._ui.static_TabMenuBG, "StaticText_Timer")
  self._ui.staticText_Status1Title = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "StaticText_Status1Title")
  self._ui.staticText_Status1Point = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "StaticText_Status1Point")
  self._ui.progress2_Status1Bar = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "Progress2_Status1Bar")
  self._ui.staticText_Status2Title = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "StaticText_Status2Title")
  self._ui.staticText_Status2Point = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "StaticText_Status2Point")
  self._ui.progress2_Status2Bar = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "Progress2_Status2Bar")
  self._ui.staticText_Status3Title = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "StaticText_Status3Title")
  self._ui.staticText_Status3Point = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "StaticText_Status3Point")
  self._ui.progress2_Status3Bar = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "Progress2_Status3Bar")
  self._ui.static_Icon_Work1 = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "Static_Icon_Work1")
  self._ui.staticText_Work1Title = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "StaticText_Work1Title")
  self._ui.staticText_Work1Dec = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "StaticText_Work1Dec")
  self._ui.static_Icon_Work2 = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "Static_Icon_Work2")
  self._ui.staticText_Work2Title = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "StaticText_Work2Title")
  self._ui.staticText_Work2Dec = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "StaticText_Work2Dec")
  self._ui.staticText_KeyGuide_B = UI.getChildControl(Panel_House_InstallationMode_PlantInfo, "StaticText_B_Close_ConsoleUI")
  PaGlobalFunc_ConsoleKeyGuide_SetAlign({
    self._ui.staticText_KeyGuide_B
  }, Panel_House_InstallationMode_PlantInfo, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Panel_Window_InstallationMode_Plant_info:setContent()
  if self._value.isShowOnlyGround then
    local actorKeyRaw = toClient_GetHousingSelectInstallationActorKey()
    if toClient_GetHousingSelectInstallationActorKeyIsSet() then
      self._value.currentActorKeyRaw = actorKeyRaw
      self._isShowOnlyGround = false
    end
  end
  if self._value.isShowOnlyGround then
    local ownerHouseHoldNo = housing_getInstallmodeHouseHoldNo()
    local itemEnchantSSW = housing_getItemEnchantStaticStatus()
    self._ui.staticText_Title:SetText(itemEnchantSSW:getCharacterStaticStatus():getName())
    local growingRate = housing_getGrowingRate(itemEnchantSSW:get())
    local remainingTime = 1000000 / growingRate * 5 * 60
    self._ui.staticText_Timer:SetText(convertStringFromDatetime(toInt64(0, remainingTime)))
    self._ui.staticText_Timer:SetFontColor(UI_color.C_FFEFEFEF)
    self:setIcon()
    self:setContentProgress()
    self:setContentIconMono()
    self:changeText()
  else
    if nil == self._value.currentActorKeyRaw then
      return
    end
    local installationActorProxyWrapper = getInstallationActor(self._value.currentActorKeyRaw)
    if nil == installationActorProxyWrapper then
      PaGlobalFunc_InstallationMode_PlantInfo_Exit()
      return
    end
    local ownerHouseHoldNo = installationActorProxyWrapper:get():getOwnerHouseholdNo_s64()
    local progressingInfo = installationActorProxyWrapper:get():getInstallationProgressingInfo()
    if nil == ownerHouseHoldNo or nil == progressingInfo then
      PaGlobalFunc_InstallationMode_PlantInfo_Exit()
      return
    end
    local serverUtc64Time = getServerUtc64()
    self._value.currentActorKeyRaw = installationActorProxyWrapper:get():getActorKeyRaw()
    self._ui.staticText_Title:SetText(installationActorProxyWrapper:getStaticStatusWrapper():getName())
    if progressingInfo:isGrowingStop() then
      self._ui.staticText_Timer:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_STOP"))
      self._ui.staticText_Timer:SetFontColor(UI_color.C_FFF26A6A)
    else
      self._ui.staticText_Timer:SetText(convertStringFromDatetime(progressingInfo:getCompleteTime(serverUtc64Time)))
      self._ui.staticText_Timer:SetFontColor(UI_color.C_FFEFEFEF)
    end
    self:setIcon()
    self:setContentProgress(progressingInfo)
    self:setContentIconMono(progressingInfo)
    self:changeText()
  end
end
function Panel_Window_InstallationMode_Plant_info:setIcon()
  if self._value.isChange then
  else
  end
end
function Panel_Window_InstallationMode_Plant_info:setContentIconMono(progressingInfo)
  if nil ~= progressingInfo then
    if progressingInfo:getNeedLop() then
      if false == self._value.isAnimal then
        self._ui.static_Icon_Work1:ChangeTextureInfoName(self._texture.plantPath)
        local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Work1, self._texture.NeedLopPlant[1], self._texture.NeedLopPlant[2], self._texture.NeedLopPlant[3], self._texture.NeedLopPlant[4])
        self._ui.static_Icon_Work1:getBaseTexture():setUV(x1, y1, x2, y2)
        self._ui.static_Icon_Work1:setRenderTexture(self._ui.static_Icon_Work1:getBaseTexture())
      else
        self._ui.static_Icon_Work1:ChangeTextureInfoName(self._texture.animalPath)
        local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Work1, self._texture.NeedLopAnimal[1], self._texture.NeedLopAnimal[2], self._texture.NeedLopAnimal[3], self._texture.NeedLopAnimal[4])
        self._ui.static_Icon_Work1:getBaseTexture():setUV(x1, y1, x2, y2)
        self._ui.static_Icon_Work1:setRenderTexture(self._ui.static_Icon_Work1:getBaseTexture())
      end
      self._ui.staticText_Work1Title:SetFontColor(Defines.Color.C_FFEEEEEE)
      self._ui.staticText_Work1Dec:SetFontColor(Defines.Color.C_FFEEEEEE)
    else
      if false == self._value.isAnimal then
        self._ui.static_Icon_Work1:ChangeTextureInfoName(self._texture.plantPath)
        local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Work1, self._texture.notNeedLopPlant[1], self._texture.notNeedLopPlant[2], self._texture.notNeedLopPlant[3], self._texture.notNeedLopPlant[4])
        self._ui.static_Icon_Work1:getBaseTexture():setUV(x1, y1, x2, y2)
        self._ui.static_Icon_Work1:setRenderTexture(self._ui.static_Icon_Work1:getBaseTexture())
      else
        self._ui.static_Icon_Work1:ChangeTextureInfoName(self._texture.animalPath)
        local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Work1, self._texture.notNeedLopAnimal[1], self._texture.notNeedLopAnimal[2], self._texture.notNeedLopAnimal[3], self._texture.notNeedLopAnimal[4])
        self._ui.static_Icon_Work1:getBaseTexture():setUV(x1, y1, x2, y2)
        self._ui.static_Icon_Work1:setRenderTexture(self._ui.static_Icon_Work1:getBaseTexture())
      end
      self._ui.staticText_Work1Title:SetFontColor(Defines.Color.C_FF525B6D)
      self._ui.staticText_Work1Dec:SetFontColor(Defines.Color.C_FF525B6D)
    end
    if progressingInfo:getNeedPestControl() then
      if false == self._value.isAnimal then
        self._ui.static_Icon_Work2:ChangeTextureInfoName(self._texture.plantPath)
        local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Work2, self._texture.NeedPestPlant[1], self._texture.NeedPestPlant[2], self._texture.NeedPestPlant[3], self._texture.NeedPestPlant[4])
        self._ui.static_Icon_Work2:getBaseTexture():setUV(x1, y1, x2, y2)
        self._ui.static_Icon_Work2:setRenderTexture(self._ui.static_Icon_Work2:getBaseTexture())
      else
        self._ui.static_Icon_Work2:ChangeTextureInfoName(self._texture.animalPath)
        local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Work2, self._texture.NeedPestAnimal[1], self._texture.NeedPestAnimal[2], self._texture.NeedPestAnimal[3], self._texture.NeedPestAnimal[4])
        self._ui.static_Icon_Work2:getBaseTexture():setUV(x1, y1, x2, y2)
        self._ui.static_Icon_Work2:setRenderTexture(self._ui.static_Icon_Work2:getBaseTexture())
      end
      self._ui.staticText_Work2Title:SetFontColor(Defines.Color.C_FFEEEEEE)
      self._ui.staticText_Work2Dec:SetFontColor(Defines.Color.C_FFEEEEEE)
    else
      if false == self._value.isAnimal then
        self._ui.static_Icon_Work2:ChangeTextureInfoName(self._texture.plantPath)
        local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Work2, self._texture.notNeedPestPlant[1], self._texture.notNeedPestPlant[2], self._texture.notNeedPestPlant[3], self._texture.notNeedPestPlant[4])
        self._ui.static_Icon_Work2:getBaseTexture():setUV(x1, y1, x2, y2)
        self._ui.static_Icon_Work2:setRenderTexture(self._ui.static_Icon_Work2:getBaseTexture())
      else
        self._ui.static_Icon_Work2:ChangeTextureInfoName(self._texture.animalPath)
        local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Work2, self._texture.notNeedPestAnimal[1], self._texture.notNeedPestAnimal[2], self._texture.notNeedPestAnimal[3], self._texture.notNeedPestAnimal[4])
        self._ui.static_Icon_Work2:getBaseTexture():setUV(x1, y1, x2, y2)
        self._ui.static_Icon_Work2:setRenderTexture(self._ui.static_Icon_Work2:getBaseTexture())
      end
      self._ui.staticText_Work2Title:SetFontColor(Defines.Color.C_FF525B6D)
      self._ui.staticText_Work2Dec:SetFontColor(Defines.Color.C_FF525B6D)
    end
  else
    if false == self._value.isAnimal then
      self._ui.static_Icon_Work1:ChangeTextureInfoName(self._texture.plantPath)
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Work1, self._texture.notNeedLopPlant[1], self._texture.notNeedLopPlant[2], self._texture.notNeedLopPlant[3], self._texture.notNeedLopPlant[4])
      self._ui.static_Icon_Work1:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.static_Icon_Work1:setRenderTexture(self._ui.static_Icon_Work1:getBaseTexture())
    else
      self._ui.static_Icon_Work1:ChangeTextureInfoName(self._texture.animalPath)
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Work1, self._texture.notNeedLopAnimal[1], self._texture.notNeedLopAnimal[2], self._texture.notNeedLopAnimal[3], self._texture.notNeedLopAnimal[4])
      self._ui.static_Icon_Work1:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.static_Icon_Work1:setRenderTexture(self._ui.static_Icon_Work1:getBaseTexture())
    end
    if false == self._value.isAnimal then
      self._ui.static_Icon_Work2:ChangeTextureInfoName(self._texture.plantPath)
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Work2, self._texture.notNeedPestPlant[1], self._texture.notNeedPestPlant[2], self._texture.notNeedPestPlant[3], self._texture.notNeedPestPlant[4])
      self._ui.static_Icon_Work2:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.static_Icon_Work2:setRenderTexture(self._ui.static_Icon_Work2:getBaseTexture())
    else
      self._ui.static_Icon_Work2:ChangeTextureInfoName(self._texture.animalPath)
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Work2, self._texture.notNeedPestAnimal[1], self._texture.notNeedPestAnimal[2], self._texture.notNeedPestAnimal[3], self._texture.notNeedPestAnimal[4])
      self._ui.static_Icon_Work2:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.static_Icon_Work2:setRenderTexture(self._ui.static_Icon_Work2:getBaseTexture())
    end
    self._ui.staticText_Work1Title:SetFontColor(Defines.Color.C_FF525B6D)
    self._ui.staticText_Work1Dec:SetFontColor(Defines.Color.C_FF525B6D)
    self._ui.staticText_Work2Title:SetFontColor(Defines.Color.C_FF525B6D)
    self._ui.staticText_Work2Dec:SetFontColor(Defines.Color.C_FF525B6D)
  end
end
function Panel_Window_InstallationMode_Plant_info:setContentProgress(progressingInfo)
  if nil ~= progressingInfo then
    local serverUtc64Time = getServerUtc64()
    local growth = progressingInfo:getCurrentProgress(serverUtc64Time) / 10000
    self._ui.staticText_Status1Point:SetText(string.format("%.2f%%", growth))
    self._ui.progress2_Status1Bar:SetProgressRate(math.floor(growth))
    local health = 100 - progressingInfo:getDecreaseYieldsRate() / 10000
    self._ui.staticText_Status2Point:SetText(string.format("%.2f%%", health))
    self._ui.progress2_Status2Bar:SetProgressRate(math.floor(health))
    local water = 100 - progressingInfo:getNeedWater() / 10000
    self._ui.staticText_Status3Point:SetText(string.format("%.2f%%", water))
    self._ui.progress2_Status3Bar:SetProgressRate(math.floor(water))
  else
    local growth = 0
    self._ui.staticText_Status1Point:SetText(string.format("%.2f%%", growth))
    self._ui.progress2_Status1Bar:SetProgressRate(math.floor(growth))
    local health = 100
    self._ui.staticText_Status2Point:SetText(string.format("%.2f%%", health))
    self._ui.progress2_Status2Bar:SetProgressRate(math.floor(health))
    local water = 100
    self._ui.staticText_Status3Point:SetText(string.format("%.2f%%", water))
    self._ui.progress2_Status3Bar:SetProgressRate(math.floor(water))
  end
end
function Panel_Window_InstallationMode_Plant_info:open()
  Panel_House_InstallationMode_PlantInfo:SetShow(true)
end
function Panel_Window_InstallationMode_Plant_info:close()
  Panel_House_InstallationMode_PlantInfo:SetShow(false)
end
function Panel_Window_InstallationMode_Plant_info:ignoreTextLine(text)
  local newText = ""
  local stringList = string.split(text, "\\n")
  for k, v in pairs(stringList) do
    newText = newText .. v .. " "
  end
  return newText
end
function Panel_Window_InstallationMode_Plant_info:changeText()
  if self._value.isAnimal then
    self._ui.staticText_Work1Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_4"))
    self._ui.staticText_Work2Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_5"))
    self._ui.staticText_Work1Dec:SetText(self:ignoreTextLine(PAGetString(Defines.StringSheet_GAME, "LUA_FARMINFO_NEEDFEEDING")))
    self._ui.staticText_Work2Dec:SetText(self:ignoreTextLine(PAGetString(Defines.StringSheet_GAME, "LUA_FARMINFO_NEEDKILLBUG")))
  else
    self._ui.staticText_Work1Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_2"))
    self._ui.staticText_Work2Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_3"))
    self._ui.staticText_Work1Dec:SetText(self:ignoreTextLine(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSEING_FARMINFO_NEW_PRUNINGDESC")))
    self._ui.staticText_Work2Dec:SetText(self:ignoreTextLine(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSEING_FARMINFO_NEW_INSECTDAMEGEDESC")))
  end
end
function PaGlobalFunc_InstallationMode_PlantInfo_GetShow()
  return Panel_House_InstallationMode_PlantInfo:GetShow()
end
function PaGlobalFunc_InstallationMode_PlantInfo_Open()
  local self = Panel_Window_InstallationMode_Plant_info
  self:open()
end
function PaGlobalFunc_InstallationMode_PlantInfo_Close()
  local self = Panel_Window_InstallationMode_Plant_info
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  self:close()
end
function PaGlobalFunc_InstallationMode_PlantInfo_Show()
  local self = Panel_Window_InstallationMode_Plant_info
  self:initValue()
  self._value.currentActorKeyRaw = toClient_GetHousingSelectInstallationActorKey()
  local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper()
  local installationType
  if nil ~= characterStaticWrapper then
    installationType = characterStaticWrapper:getObjectStaticStatus():getInstallationType()
  end
  if CppEnums.InstallationType.eType_LivestockHarvest == installationType then
    self._value.isAnimal = true
  else
    self._value.isAnimal = false
  end
  self._ui.staticText_KeyGuide_B:SetShow(false)
  self:setContent()
  self:open()
end
function PaGlobalFunc_InstallationMode_PlantInfo_ShowByInteraction()
  local self = Panel_Window_InstallationMode_Plant_info
  self:setContent()
  Interaction_Close()
  self:open()
end
function PaGlobalFunc_InstallationMode_PlantInfo_Exit()
  local self = Panel_Window_InstallationMode_Plant_info
  self:close()
end
function PaGlobalFunc_InstallationMode_PlantInfo_SetGuideScroll(isUp)
  self._ui.frame_1_VerticalScroll:SetControlPos(0)
  self._ui.frame_Dialog_Quest:UpdateContentPos()
end
function FromClient_InstallationMode_PlantInfo_Init()
  local self = Panel_Window_InstallationMode_Plant_info
  self:initialize()
end
function FromClient_InstallationMode_PlantInfo_Resize()
  local self = Panel_Window_InstallationMode_Plant_info
  self:resize()
end
function FromClient_InterActionHarvestInformation(actorKeyRaw)
  local self = Panel_Window_InstallationMode_Plant_info
  self:resize()
  self._value.currentActorKeyRaw = actorKeyRaw
  self._value.isShowOnlyGround = false
  local installationActorProxyWrapper = getInstallationActor(self._value.currentActorKeyRaw)
  local installationType = installationActorProxyWrapper:getStaticStatusWrapper():getObjectStaticStatus():getInstallationType()
  if CppEnums.InstallationType.eType_LivestockHarvest == installationType then
    self._value.isAnimal = true
  else
    self._value.isAnimal = false
  end
  self._ui.staticText_KeyGuide_B:SetShow(true)
  PaGlobalFunc_InstallationMode_PlantInfo_ShowByInteraction()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_InstallationMode_PlantInfo_Init")
