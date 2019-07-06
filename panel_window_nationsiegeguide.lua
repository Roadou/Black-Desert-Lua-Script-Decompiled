local NationSiegeGuide = {
  _ui = {
    _radioBtn = {},
    _bg = {},
    _desc = {},
    _frame_Content = nil,
    _frame_VScroll = nil,
    _frame = UI.getChildControl(Panel_Window_NationSiege, "Frame_Desc")
  },
  _descTypeCount = 3,
  _descCount = {
    [1] = 6,
    [2] = 3,
    [3] = 10
  },
  _basePosY = 5,
  _baseGap = 5,
  _curClickBtn = 1
}
local guideMessage = {
  [1] = {
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_WHAT_1"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_WHAT_2"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_WHAT_3"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_WHAT_4"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_WHAT_5"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_WHAT_6"),
    [7] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_WHAT_7"),
    [8] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_WHAT_8"),
    [9] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_WHAT_9"),
    [10] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_WHAT_10")
  },
  [2] = {
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_HOW_1"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_HOW_2"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_HOW_3"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_HOW_4"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_HOW_5"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_HOW_6"),
    [7] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_HOW_7"),
    [8] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_HOW_8"),
    [9] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_HOW_9"),
    [10] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_HOW_10")
  },
  [3] = {
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_REWARD_1"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_REWARD_2"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_REWARD_3"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_REWARD_4"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_REWARD_5"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_REWARD_6"),
    [7] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_REWARD_7"),
    [8] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_REWARD_8"),
    [9] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_REWARD_9"),
    [10] = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_GUIDE_REWARD_10")
  }
}
function NationSiegeGuide:init()
  self._ui._frame_Content = self._ui._frame:GetFrameContent()
  self._ui._frame_VScroll = self._ui._frame:GetVScroll()
  for index = 0, self._descTypeCount - 1 do
    self._ui._radioBtn[index] = UI.getChildControl(self._ui._frame_Content, "RadioButton_NationSiege_Title" .. index + 1)
    self._ui._radioBtn[index]:addInputEvent("Mouse_LUp", "HandleClicked_NationSiegeRadioBtn(" .. index .. ")")
    self._ui._bg[index] = UI.getChildControl(self._ui._frame_Content, "Static_BG_" .. index + 1)
    self._ui._desc[index] = {}
    for descIndex = 1, self._descCount[index + 1] do
      self._ui._desc[index][descIndex] = UI.createAndCopyBasePropertyControl(self._ui._bg[index], "StaticText_Desc" .. index + 1, self._ui._bg[index], "StaticText_NationSiege_Desc_" .. index .. "_" .. descIndex)
      self._ui._desc[index][descIndex]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      self._ui._desc[index][descIndex]:SetText(guideMessage[index + 1][descIndex])
      if descIndex > 1 then
        self._ui._desc[index][descIndex]:SetPosY(self._ui._desc[index][descIndex - 1]:GetPosY() + self._ui._desc[index][descIndex - 1]:GetTextSizeY() + self._baseGap)
      else
        self._ui._desc[index][descIndex]:SetPosY(self._basePosY)
      end
    end
  end
end
function HandleClicked_NationSiegeRadioBtn(index)
  local self = NationSiegeGuide
  self._ui._frame_VScroll:SetControlTop()
  self._ui._frame:UpdateContentScroll()
  self._ui._frame:UpdateContentPos()
  self._curClickBtn = index
  self._listUpdating = true
  for index = 0, self._descTypeCount - 1 do
    local isShow = self._ui._radioBtn[index]:IsCheck()
    self._ui._bg[index]:SetShow(isShow)
    for descIndex = 1, self._descCount[index + 1] do
      self._ui._desc[index][descIndex]:SetShow(false)
    end
  end
end
local spreadSpeed = 500
function NationSiegeGuide:updatePerFrame(deltaTime)
  if self._ui._radioBtn[0]:IsCheck() then
    if self._ui._bg[0]:GetSizeY() < self._ui._desc[0][self._descCount[1]]:GetPosY() + self._ui._desc[0][self._descCount[1]]:GetTextSizeY() + 10 then
      self._ui._bg[0]:SetSize(self._ui._bg[0]:GetSizeX(), self._ui._bg[0]:GetSizeY() + deltaTime * spreadSpeed)
    else
      self._ui._bg[0]:SetSize(self._ui._bg[0]:GetSizeX(), self._ui._desc[0][self._descCount[1]]:GetPosY() + self._ui._desc[0][self._descCount[1]]:GetTextSizeY() + 10)
    end
    self._ui._radioBtn[1]:SetPosY(self._ui._bg[0]:GetPosY() + self._ui._bg[0]:GetSizeY() + 10)
    self._ui._radioBtn[2]:SetPosY(self._ui._radioBtn[1]:GetPosY() + self._ui._radioBtn[1]:GetSizeY() + 10)
    self._ui._frame_VScroll:SetShow(self._ui._frame:GetSizeY() < self._ui._bg[0]:GetSizeY() + 150)
    self._ui._frame_Content:SetSize(self._ui._frame_Content:GetSizeX(), self._ui._bg[0]:GetSizeY() + 150)
    for descIndex = 1, self._descCount[1] do
      self._ui._desc[0][descIndex]:SetShow(self._ui._desc[0][descIndex]:GetPosY() + self._ui._desc[0][descIndex]:GetTextSizeY() + 5 < self._ui._bg[0]:GetSizeY())
    end
    self._ui._bg[1]:SetSize(self._ui._bg[1]:GetSizeX(), 10)
    self._ui._bg[2]:SetSize(self._ui._bg[2]:GetSizeX(), 10)
  end
  if self._ui._radioBtn[1]:IsCheck() then
    self._ui._bg[0]:SetSize(self._ui._bg[0]:GetSizeX(), 10)
    if self._ui._radioBtn[0]:GetPosY() + self._ui._radioBtn[1]:GetSizeY() + 10 < self._ui._radioBtn[1]:GetPosY() then
      self._ui._radioBtn[1]:SetPosY(self._ui._radioBtn[1]:GetPosY() - deltaTime * spreadSpeed * 2)
    else
      self._ui._radioBtn[1]:SetPosY(self._ui._radioBtn[0]:GetPosY() + self._ui._radioBtn[0]:GetSizeY() + 10)
    end
    self._ui._bg[1]:SetPosY(self._ui._radioBtn[1]:GetPosY() + self._ui._radioBtn[1]:GetSizeY() + 5)
    if self._ui._bg[1]:GetSizeY() < self._ui._desc[1][self._descCount[2]]:GetPosY() + self._ui._desc[1][self._descCount[2]]:GetTextSizeY() + 10 then
      self._ui._bg[1]:SetSize(self._ui._bg[1]:GetSizeX(), self._ui._bg[1]:GetSizeY() + deltaTime * spreadSpeed)
    else
      self._ui._bg[1]:SetSize(self._ui._bg[1]:GetSizeX(), self._ui._desc[1][self._descCount[2]]:GetPosY() + self._ui._desc[1][self._descCount[2]]:GetTextSizeY() + 10)
    end
    self._ui._radioBtn[2]:SetPosY(self._ui._bg[1]:GetPosY() + self._ui._bg[1]:GetSizeY() + 10)
    self._ui._frame_VScroll:SetShow(self._ui._frame:GetSizeY() < self._ui._bg[1]:GetSizeY() + 200)
    self._ui._frame_Content:SetSize(self._ui._frame_Content:GetSizeX(), self._ui._bg[1]:GetSizeY() + 200)
    for descIndex = 1, self._descCount[2] do
      self._ui._desc[1][descIndex]:SetShow(self._ui._desc[1][descIndex]:GetPosY() + self._ui._desc[1][descIndex]:GetTextSizeY() + 5 < self._ui._bg[1]:GetSizeY())
    end
  end
  if self._ui._radioBtn[2]:IsCheck() then
    self._ui._bg[0]:SetSize(self._ui._bg[0]:GetSizeX(), 10)
    self._ui._bg[1]:SetSize(self._ui._bg[1]:GetSizeX(), 10)
    if self._ui._radioBtn[1]:GetPosY() + self._ui._radioBtn[1]:GetSizeY() + 10 < self._ui._radioBtn[2]:GetPosY() then
      self._ui._radioBtn[2]:SetPosY(self._ui._radioBtn[2]:GetPosY() - deltaTime * spreadSpeed * 2)
    else
      self._ui._radioBtn[2]:SetPosY(self._ui._radioBtn[1]:GetPosY() + self._ui._radioBtn[1]:GetSizeY() + 10)
    end
    self._ui._bg[2]:SetPosY(self._ui._radioBtn[2]:GetPosY() + self._ui._radioBtn[1]:GetSizeY() + 5)
    if self._ui._bg[2]:GetSizeY() < self._ui._desc[2][self._descCount[3]]:GetPosY() + self._ui._desc[2][self._descCount[3]]:GetTextSizeY() + 10 then
      self._ui._bg[2]:SetSize(self._ui._bg[2]:GetSizeX(), self._ui._bg[2]:GetSizeY() + deltaTime * spreadSpeed)
    else
      self._ui._bg[2]:SetSize(self._ui._bg[2]:GetSizeX(), self._ui._desc[2][self._descCount[3]]:GetPosY() + self._ui._desc[2][self._descCount[3]]:GetTextSizeY() + 10)
    end
    self._ui._frame_VScroll:SetShow(self._ui._frame:GetSizeY() < self._ui._bg[2]:GetSizeY() + 200)
    self._ui._frame_Content:SetSize(self._ui._frame_Content:GetSizeX(), self._ui._bg[2]:GetSizeY() + 200)
    for descIndex = 1, self._descCount[3] do
      self._ui._desc[2][descIndex]:SetShow(self._ui._desc[2][descIndex]:GetPosY() + self._ui._desc[2][descIndex]:GetTextSizeY() + 5 < self._ui._bg[2]:GetSizeY())
    end
    if self._ui._radioBtn[0]:GetPosY() + self._ui._radioBtn[0]:GetSizeY() + 10 < self._ui._radioBtn[1]:GetPosY() then
      self._ui._radioBtn[1]:SetPosY(self._ui._radioBtn[1]:GetPosY() - deltaTime * spreadSpeed * 2)
    else
      self._ui._radioBtn[1]:SetPosY(self._ui._radioBtn[0]:GetPosY() + self._ui._radioBtn[0]:GetSizeY() + 10)
    end
  end
end
function NationSiegeGuide_UpdateFunc(deltaTime)
  local self = NationSiegeGuide
  self:updatePerFrame(deltaTime)
end
function PaGlobal_NationSiegeGuide_Open()
  local self = NationSiegeGuide
  self._ui._radioBtn[0]:SetCheck(true)
  self._ui._radioBtn[1]:SetCheck(false)
  self._ui._radioBtn[2]:SetCheck(false)
  self._ui._bg[0]:SetSize(self._ui._bg[0]:GetSizeX(), 10)
  HandleClicked_NationSiegeRadioBtn(0)
end
function PaGlobal_NationSiegeGuide_Init()
  local self = NationSiegeGuide
  self:init()
  PaGlobal_NationSiegeGuide_Open()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_NationSiegeGuide_Init")
Panel_Window_NationSiege:RegisterUpdateFunc("NationSiegeGuide_UpdateFunc")
