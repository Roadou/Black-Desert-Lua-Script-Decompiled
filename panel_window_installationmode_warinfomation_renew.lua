local _panel = Panel_Window_InstallationMode_WarInformation_Renew
local self = WarInfomation
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local innerObject = {}
local WarInfomation = {
  _ui = {
    stc_statusTotal = UI.getChildControl(_panel, "Static_TotalStatus"),
    stc_contentBg = UI.getChildControl(_panel, "Static_ContentBG"),
    txt_installedTotalCount = nil,
    txt_leftTotalCount = nil,
    stc_template = nil,
    txt_installationName = nil,
    txt_installedCount = nil,
    txt_limitCount = nil,
    txt_requireCount = nil,
    txt_neededCount = nil
  },
  linegap = 5
}
function WarInfomation:init()
  _panel:SetShow(false)
  local innerObjectCount = ToClient_getSiegeObjectKindCount()
  local temp = {}
  self._ui.txt_installedTotalTitle = UI.getChildControl(self._ui.stc_statusTotal, "StaticText_Status_InstalledTitle")
  self._ui.txt_installedTotalCount = UI.getChildControl(self._ui.stc_statusTotal, "StaticText_Status_InstalledCount")
  self._ui.txt_leftTotalCount = UI.getChildControl(self._ui.stc_statusTotal, "StaticText_Status_LeftCount")
  self._ui.txt_leftTotalTitle = UI.getChildControl(self._ui.stc_statusTotal, "StaticText_Status_LeftTitle")
  self._ui.stc_template = UI.getChildControl(self._ui.stc_contentBg, "Static_StatusTemplate")
  self._ui.txt_installationName = UI.getChildControl(self._ui.stc_template, "StaticText_Installation_Name")
  self._ui.txt_installedCount = UI.getChildControl(self._ui.stc_template, "StaticText_Installation_NowCount")
  self._ui.txt_limitCount = UI.getChildControl(self._ui.stc_template, "StaticText_Installation_LimitCount")
  self._ui.txt_requireCount = UI.getChildControl(self._ui.stc_template, "StaticText_Installation_Required")
  for index = 0, innerObjectCount - 1 do
    temp[index] = {}
    innerObject[index] = {}
    local statusTemplate = UI.cloneControl(self._ui.stc_template, self._ui.stc_contentBg, "Static_StatusTemplate" .. index)
    local statusTemplateYValue = (statusTemplate:GetSizeY() + self.linegap) * index
    statusTemplate:SetPosY(statusTemplateYValue)
    temp[index]._name = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, statusTemplate, "StaticText_Installation_Name_" .. index)
    CopyBaseProperty(self._ui.txt_installationName, temp[index]._name)
    temp[index]._name:SetShow(true)
    temp[index]._count = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, statusTemplate, "StaticText_Installation_NowCount_" .. index)
    CopyBaseProperty(self._ui.txt_installedCount, temp[index]._count)
    temp[index]._count:SetShow(true)
    temp[index]._size = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, statusTemplate, "StaticText_Installation_Required" .. index)
    CopyBaseProperty(self._ui.txt_requireCount, temp[index]._size)
    temp[index]._size:SetShow(true)
    temp[index]._maxCount = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, statusTemplate, "StaticText_Installation_LimitCount" .. index)
    CopyBaseProperty(self._ui.txt_limitCount, temp[index]._maxCount)
    temp[index]._maxCount:SetShow(true)
    innerObject[index] = temp[index]
  end
  self._ui.stc_contentBg:SetSize(_panel:GetSizeX() - 24, innerObjectCount * (self._ui.stc_template:GetSizeY() + self.linegap))
  _panel:SetSize(_panel:GetSizeX(), 180 + innerObjectCount * (self._ui.stc_template:GetSizeY() + self.linegap))
  _panel:SetSpanSize(_panel:GetSpanSize().x, 115)
end
function WarInfomation:open(buildingInfo)
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == buildingInfo then
    if nil ~= houseWrapper and nil ~= houseWrapper:getStaticStatusWrapper() then
      _panel:SetShow(true)
      local actorKeyRaw = houseWrapper:getActorKey()
      local buildingInfo = ToClient_getBuildingInfo(actorKeyRaw)
      if nil ~= buildingInfo then
        local allCount = buildingInfo:getAllInstanceObjectCount()
        local cOSW = houseWrapper:getStaticStatusWrapper():getObjectStaticStatus()
        local innerObjectCount = ToClient_getSiegeObjectKindCount()
        local usedCount = 0
        for index = 0, innerObjectCount - 1 do
          innerObject[index]._maxCount:SetShow(true)
          innerObject[index]._count:SetShow(true)
          local characterWrapper = ToClient_getObjectStaticStatusByObjectKindbyIndex(index)
          local objectWrapper = characterWrapper:getObjectStaticStatus()
          if nil ~= objectWrapper then
            local objectKind = objectWrapper:getObjectKind()
            local objectCount = buildingInfo:getInstanceObjectCount(objectKind)
            innerObject[index]._name:SetText(characterWrapper:getName())
            innerObject[index]._maxCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_INNEROBJECTMAXCOUNT", "count", cOSW:getMaxCountByObjectKind(objectKind)))
            innerObject[index]._count:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_INNEROBJECTMAXCOUNT", "count", objectCount))
            innerObject[index]._size:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_INNEROBJECTSIZE", "size", objectWrapper:getInnerObjectSize()))
            usedCount = usedCount + objectWrapper:getInnerObjectSize() * objectCount
          end
        end
        self._ui.txt_installedTotalCount:SetShow(true)
        self._ui.txt_leftTotalCount:SetShow(true)
        self._ui.txt_installedTotalCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_INNEROBJECTMAXCOUNT", "count", allCount))
        self._ui.txt_leftTotalCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_INNEROBJECTSIZE", "size", cOSW:getInnerObjectSize()) .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_INNEROBJECTLEFTCOUNT", "count", cOSW:getInnerObjectSize() - usedCount))
        self._ui.txt_installedTotalCount:SetPosX(self._ui.txt_installedTotalTitle:GetPosX() + self._ui.txt_installedTotalTitle:GetTextSizeX() + 10)
        self._ui.txt_leftTotalCount:SetPosX(self._ui.stc_statusTotal:GetSizeX() - self._ui.txt_leftTotalCount:GetTextSizeX() - 10)
        self._ui.txt_leftTotalTitle:SetPosX(self._ui.txt_leftTotalCount:GetPosX() - self._ui.txt_leftTotalTitle:GetTextSizeX() - 10)
        _panel:ComputePos()
      end
    end
  else
    _panel:SetShow(true)
    local innerObjectCount = ToClient_getSiegeObjectKindCount()
    local buildInfo = buildingInfo:ToClient_getBuildingStaticStatus()
    if nil ~= buildInfo then
      local CSSW = buildInfo:getCharacterStaticStatusWrapper()
      if nil ~= CSSW then
        local OSSW = CSSW:getObjectStaticStatus()
        local allCount = buildInfo:getAllInstanceObjectCount()
        local usedCount = 0
        for index = 0, innerObjectCount - 1 do
          innerObject[index]._maxCount:SetShow(true)
          innerObject[index]._count:SetShow(true)
          local characterWrapper = ToClient_getObjectStaticStatusByObjectKindbyIndex(index)
          local objectWrapper = characterWrapper:getObjectStaticStatus()
          if nil ~= objectWrapper then
            local objectKind = objectWrapper:getObjectKind()
            local objectCount = buildInfo:getInstanceObjectCount(objectKind)
            innerObject[index]._name:SetText(characterWrapper:getName())
            innerObject[index]._maxCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_INNEROBJECTMAXCOUNT", "count", OSSW:getMaxCountByObjectKind(objectKind)))
            innerObject[index]._count:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_INNEROBJECTMAXCOUNT", "count", objectCount))
            innerObject[index]._size:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_INNEROBJECTSIZE", "size", objectWrapper:getInnerObjectSize()))
            usedCount = usedCount + objectWrapper:getInnerObjectSize() * objectCount
          end
        end
        self._ui.txt_installedTotalCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_INNEROBJECTMAXCOUNT", "count", allCount))
        self._ui.txt_leftTotalCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_INNEROBJECTSIZE", "size", OSSW:getInnerObjectSize()) .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_INNEROBJECTLEFTCOUNT", "count", OSSW:getInnerObjectSize() - usedCount))
        self._ui.txt_installedTotalCount:SetPosX(self._ui.txt_installedTotalTitle:GetPosX() + self._ui.txt_installedTotalTitle:GetTextSizeX() + 10)
        self._ui.txt_leftTotalCount:SetPosX(self._ui.stc_statusTotal:GetSizeX() - self._ui.txt_leftTotalCount:GetTextSizeX() - 10)
        self._ui.txt_leftTotalTitle:SetPosX(self._ui.txt_leftTotalCount:GetPosX() - self._ui.txt_leftTotalTitle:GetTextSizeX() - 10)
      end
    end
  end
end
function WarInfomation:close()
  _panel:SetShow(false)
end
function PaGlobal_WarInfomation_Initialize()
  local self = WarInfomation
  self:init()
end
function PaGlobal_WarInfomation_Open(buildingInfo)
  local self = WarInfomation
  self:open(buildingInfo)
end
function PaGlobal_WarInfomation_Close()
  local self = WarInfomation
  self:close()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_WarInfomation_Initialize")
