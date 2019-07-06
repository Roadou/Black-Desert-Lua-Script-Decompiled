Panel_BossWave:SetShow(false)
Panel_BossWave:setMaskingChild(true)
Panel_BossWave:setGlassBackground(true)
Panel_BossWave:SetDragAll(true)
local bossWave = {
  _icon = UI.getChildControl(Panel_BossWave, "Static_Icon"),
  _clearIcon = UI.getChildControl(Panel_BossWave, "Static_ClearIcon"),
  _hpProgressBg = UI.getChildControl(Panel_BossWave, "Static_HpBg"),
  _hpProgress = UI.getChildControl(Panel_BossWave, "Progress2_HpGauge"),
  _bossName = UI.getChildControl(Panel_BossWave, "StaticText_BossName"),
  _maxWaveCount = 5,
  _uiPool = {},
  _texture = {
    icon = {
      [0] = {
        x1 = 1,
        y1 = 54,
        x2 = 20,
        y2 = 81
      },
      [1] = {
        x1 = 1,
        y1 = 110,
        x2 = 20,
        y2 = 137
      },
      [2] = {
        x1 = 1,
        y1 = 138,
        x2 = 20,
        y2 = 165
      },
      [3] = {
        x1 = 1,
        y1 = 166,
        x2 = 20,
        y2 = 193
      },
      [4] = {
        x1 = 1,
        y1 = 194,
        x2 = 20,
        y2 = 221
      }
    },
    progressBg = {},
    progress = {
      [0] = {
        x1 = 28,
        y1 = 94,
        x2 = 40,
        y2 = 100
      },
      [1] = {
        x1 = 28,
        y1 = 112,
        x2 = 40,
        y2 = 118
      },
      [2] = {
        x1 = 28,
        y1 = 129,
        x2 = 40,
        y2 = 135
      },
      [3] = {
        x1 = 28,
        y1 = 146,
        x2 = 40,
        y2 = 152
      },
      [4] = {
        x1 = 28,
        y1 = 162,
        x2 = 40,
        y2 = 168
      }
    }
  },
  uiPool = {},
  _currentWaveBoss = {},
  _currentWaveMaxCount = 0,
  _currentBossActorProxy = nil,
  _name = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSWAVE_NAME_0"),
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSWAVE_NAME_1"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSWAVE_NAME_2"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSWAVE_NAME_3"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_BOSSWAVE_NAME_4")
  },
  resetCheck = false
}
function bossWave:Init()
  for index = 0, self._maxWaveCount - 1 do
    local temp = {}
    temp._icon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_BossWave, "Static_BossWave_Icon_" .. index)
    CopyBaseProperty(self._icon, temp._icon)
    temp._icon:SetPosY(self._icon:GetPosY() + 40 * index)
    temp._clearIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_BossWave, "Static_BossWave_ClearIcon_" .. index)
    CopyBaseProperty(self._clearIcon, temp._clearIcon)
    temp._clearIcon:SetPosY(self._clearIcon:GetPosY() + 40 * index)
    temp._clearIcon:SetShow(false)
    temp._hpProgressBg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_BossWave, "Static_BossWave_HpProgressBg_" .. index)
    CopyBaseProperty(self._hpProgressBg, temp._hpProgressBg)
    temp._hpProgressBg:SetPosY(self._hpProgressBg:GetPosY() + 40 * index)
    temp._hpProgress = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_PROGRESS2, Panel_BossWave, "Progress2_BossWave_HpProgress_" .. index)
    CopyBaseProperty(self._hpProgress, temp._hpProgress)
    temp._hpProgress:SetPosY(self._hpProgress:GetPosY() + 40 * index)
    temp._hpProgress:SetProgressRate(0)
    temp._bossName = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_BossWave, "StaticText_BossWave_Name_" .. index)
    CopyBaseProperty(self._bossName, temp._bossName)
    temp._bossName:SetPosY(self._bossName:GetPosY() + 40 * index)
    temp._bossName:SetText(self._name[index])
    self.uiPool[index] = temp
    self:ChangeTexture(index)
  end
  self._icon:SetShow(false)
  self._clearIcon:SetShow(false)
  self._hpProgressBg:SetShow(false)
  self._hpProgress:SetShow(false)
  self._bossName:SetShow(false)
end
function bossWave:ChangeTexture(index)
  local ddsLink = "New_UI_Common_forLua/Widget/Party/Party_01.dds"
  local control = self.uiPool[index]
  self.uiPool[index]._icon:ChangeTextureInfoName(ddsLink)
  local x1, y1, x2, y2 = setTextureUV_Func(self.uiPool[index]._icon, self._texture.icon[index].x1, self._texture.icon[index].y1, self._texture.icon[index].x2, self._texture.icon[index].y2)
  control._icon:getBaseTexture():setUV(x1, y1, x2, y2)
  control._icon:setRenderTexture(control._icon:getBaseTexture())
  control._hpProgress:ChangeTextureInfoName(ddsLink)
  local x1, y1, x2, y2 = setTextureUV_Func(control._hpProgress, self._texture.progress[index].x1, self._texture.progress[index].y1, self._texture.progress[index].x2, self._texture.progress[index].y2)
  control._hpProgress:getBaseTexture():setUV(x1, y1, x2, y2)
  control._hpProgress:setRenderTexture(control._hpProgress:getBaseTexture())
end
function bossWave:MonoToneSet(index, bool)
  for _, control in pairs(self.uiPool[index]) do
  end
end
function bossWave:SetShow(count)
  for index = 0, self._maxWaveCount - 1 do
    for _, control in pairs(self.uiPool[index]) do
      control:SetShow(false)
    end
  end
  for index = 0, count - 1 do
    for _, control in pairs(self.uiPool[index]) do
      control:SetShow(true)
    end
    self.uiPool[index]._clearIcon:SetShow(false)
    self:MonoToneSet(index, false)
  end
  Panel_BossWave:SetSize(Panel_BossWave:GetSizeX(), self.uiPool[count - 1]._hpProgressBg:GetPosY() + self.uiPool[count - 1]._hpProgressBg:GetSizeY() + 10)
end
local clearTime = 0
function bossWave:Open()
  Panel_BossWave:SetShow(true)
  Panel_BossWave:SetPosX(getScreenSizeX() - Panel_Radar:GetSizeX() - Panel_BossWave:GetSizeX() - 20)
  Panel_BossWave:SetPosY(80)
  clearTime = 0
end
function bossWave:Close()
  Panel_BossWave:SetShow(false)
  bossWave._currentWaveMaxCount = 0
  bossWave._currentBossActorProxy = nil
  bossWave._currentWaveBoss = {}
  clearTime = 0
end
function FromClient_ActivateAltarOfTrainingUIMode(hp1, hp2, hp3, hp4, hp5)
  if not Panel_BossWave:GetShow() then
    bossWave:SetShow(5)
    bossWave:Open()
  end
  clearTime = 0
  if nil == h1 then
    h1 = 100
  end
  if nil == h2 then
    h2 = 100
  end
  if nil == h3 then
    h3 = 100
  end
  if nil == h4 then
    h4 = 100
  end
  if nil == h5 then
    h5 = 100
  end
  bossWave.uiPool[0]._hpProgress:SetProgressRate(hp1)
  bossWave.uiPool[1]._hpProgress:SetProgressRate(hp2)
  bossWave.uiPool[2]._hpProgress:SetProgressRate(hp3)
  bossWave.uiPool[3]._hpProgress:SetProgressRate(hp4)
  bossWave.uiPool[4]._hpProgress:SetProgressRate(hp5)
end
function FromClient_ActivateAltarOfTrainingUIModeQuest(hp1, hp2, hp3)
  if not Panel_BossWave:GetShow() then
    bossWave:SetShow(3)
    bossWave:Open()
  end
  clearTime = 0
  if nil == h1 then
    h1 = 100
  end
  if nil == h2 then
    h2 = 100
  end
  if nil == h3 then
    h3 = 100
  end
  bossWave.uiPool[0]._hpProgress:SetProgressRate(hp1)
  bossWave.uiPool[1]._hpProgress:SetProgressRate(hp2)
  bossWave.uiPool[2]._hpProgress:SetProgressRate(hp3)
end
function BossWave_Check(deltaTime)
  clearTime = clearTime + deltaTime
  if clearTime > 10 then
    bossWave:Close()
  end
end
function bossWave:registerEvent()
  registerEvent("FromClient_ActivateAltarOfTrainingUIMode", "FromClient_ActivateAltarOfTrainingUIMode")
  registerEvent("FromClient_ActivateAltarOfTrainingUIModeQuest", "FromClient_ActivateAltarOfTrainingUIModeQuest")
  Panel_BossWave:RegisterUpdateFunc("BossWave_Check")
end
bossWave:Init()
bossWave:registerEvent()
