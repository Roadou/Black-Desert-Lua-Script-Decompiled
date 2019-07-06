Panel_Window_Mercenary:SetShow(false)
local mercenaryGuide = {
  _control = {
    _radioBtn = {},
    _bg = {},
    _desc = {},
    _frame_Content = nil,
    _frame_VScroll = nil,
    _frame = UI.getChildControl(Panel_Window_Mercenary, "Frame_Description")
  },
  _descTypeCount = 3,
  _descCount = {
    [1] = 4,
    [2] = 6,
    [3] = 4
  },
  _basePosY = 5,
  _baseGap = 5
}
function mercenaryGuide:Init()
  local control = self._control
  control._frame_Content = control._frame:GetFrameContent()
  control._frame_VScroll = control._frame:GetVScroll()
  for index = 0, self._descTypeCount - 1 do
    control._radioBtn[index] = UI.getChildControl(control._frame_Content, "RadioButton_Mercenary_Title" .. index + 1)
    control._radioBtn[index]:addInputEvent("Mouse_LUp", "HandleClicked_MercenaryRadioBtn(" .. index .. ")")
    control._bg[index] = UI.getChildControl(control._frame_Content, "Static_BG_" .. index + 1)
    control._desc[index] = {}
    for descIndex = 1, self._descCount[index + 1] do
      control._desc[index][descIndex] = UI.createAndCopyBasePropertyControl(control._bg[index], "StaticText_Desc" .. index + 1, control._bg[index], "StaticText_Mercenary_Desc_" .. index .. "_" .. descIndex)
      control._desc[index][descIndex]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      control._desc[index][descIndex]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MILITIA_DESC_" .. index + 1 .. "_" .. descIndex))
      if descIndex > 1 then
        control._desc[index][descIndex]:SetPosY(control._desc[index][descIndex - 1]:GetPosY() + control._desc[index][descIndex - 1]:GetTextSizeY() + self._baseGap)
      else
        control._desc[index][descIndex]:SetPosY(self._basePosY)
      end
    end
  end
end
function HandleClicked_MercenaryRadioBtn(index)
  local self = mercenaryGuide
  local control = self._control
  control._frame_VScroll:SetControlTop()
  control._frame:UpdateContentScroll()
  control._frame:UpdateContentPos()
  for index = 0, self._descTypeCount - 1 do
    local isShow = control._radioBtn[index]:IsCheck()
    control._bg[index]:SetShow(isShow)
    for descIndex = 1, self._descCount[index + 1] do
      control._desc[index][descIndex]:SetShow(false)
    end
  end
end
local spreadSpeed = 500
function MercenaryDesc_ShowDesc(deltaTime)
  local self = mercenaryGuide
  local control = self._control
  if control._radioBtn[0]:IsCheck() then
    if control._bg[0]:GetSizeY() < control._desc[0][4]:GetPosY() + control._desc[0][4]:GetTextSizeY() + 10 then
      control._bg[0]:SetSize(control._bg[0]:GetSizeX(), control._bg[0]:GetSizeY() + deltaTime * spreadSpeed)
    else
      control._bg[0]:SetSize(control._bg[0]:GetSizeX(), control._desc[0][4]:GetPosY() + control._desc[0][4]:GetTextSizeY() + 10)
    end
    control._radioBtn[1]:SetPosY(control._bg[0]:GetPosY() + control._bg[0]:GetSizeY() + 10)
    control._radioBtn[2]:SetPosY(control._radioBtn[1]:GetPosY() + control._radioBtn[1]:GetSizeY() + 10)
    control._frame_VScroll:SetShow(control._frame:GetSizeY() < control._bg[0]:GetSizeY() + 150)
    control._frame_Content:SetSize(control._frame_Content:GetSizeX(), control._bg[0]:GetSizeY() + 150)
    for descIndex = 1, self._descCount[1] do
      control._desc[0][descIndex]:SetShow(control._desc[0][descIndex]:GetPosY() + control._desc[0][descIndex]:GetTextSizeY() + 5 < control._bg[0]:GetSizeY())
    end
    control._bg[1]:SetSize(mercenaryGuide._control._bg[1]:GetSizeX(), 10)
    control._bg[2]:SetSize(mercenaryGuide._control._bg[2]:GetSizeX(), 10)
  end
  if control._radioBtn[1]:IsCheck() then
    control._bg[0]:SetSize(mercenaryGuide._control._bg[0]:GetSizeX(), 10)
    if control._radioBtn[0]:GetPosY() + control._radioBtn[0]:GetSizeY() + 10 < control._radioBtn[1]:GetPosY() then
      control._radioBtn[1]:SetPosY(control._radioBtn[1]:GetPosY() - deltaTime * spreadSpeed * 2)
    else
      control._radioBtn[1]:SetPosY(control._radioBtn[0]:GetPosY() + control._radioBtn[0]:GetSizeY() + 10)
    end
    control._bg[1]:SetPosY(control._radioBtn[1]:GetPosY() + control._radioBtn[1]:GetSizeY() + 5)
    if control._bg[1]:GetSizeY() < control._desc[1][6]:GetPosY() + control._desc[1][6]:GetTextSizeY() + 10 then
      control._bg[1]:SetSize(control._bg[1]:GetSizeX(), control._bg[1]:GetSizeY() + deltaTime * spreadSpeed)
    else
      control._bg[1]:SetSize(control._bg[1]:GetSizeX(), control._desc[1][6]:GetPosY() + control._desc[1][6]:GetTextSizeY() + 10)
    end
    control._radioBtn[2]:SetPosY(control._bg[1]:GetPosY() + control._bg[1]:GetSizeY() + 10)
    control._frame_VScroll:SetShow(control._frame:GetSizeY() < control._bg[1]:GetSizeY() + 200)
    control._frame_Content:SetSize(control._frame_Content:GetSizeX(), control._bg[1]:GetSizeY() + 200)
    for descIndex = 1, self._descCount[2] do
      control._desc[1][descIndex]:SetShow(control._desc[1][descIndex]:GetPosY() + control._desc[1][descIndex]:GetTextSizeY() + 5 < control._bg[1]:GetSizeY())
    end
  end
  if control._radioBtn[2]:IsCheck() then
    control._bg[0]:SetSize(mercenaryGuide._control._bg[0]:GetSizeX(), 10)
    control._bg[1]:SetSize(mercenaryGuide._control._bg[1]:GetSizeX(), 10)
    if control._radioBtn[1]:GetPosY() + control._radioBtn[1]:GetSizeY() + 10 < control._radioBtn[2]:GetPosY() then
      control._radioBtn[2]:SetPosY(control._radioBtn[2]:GetPosY() - deltaTime * spreadSpeed * 2)
    else
      control._radioBtn[2]:SetPosY(control._radioBtn[1]:GetPosY() + control._radioBtn[1]:GetSizeY() + 10)
    end
    control._bg[2]:SetPosY(control._radioBtn[2]:GetPosY() + control._radioBtn[1]:GetSizeY() + 5)
    if control._bg[2]:GetSizeY() < control._desc[2][4]:GetPosY() + control._desc[2][4]:GetTextSizeY() + 10 then
      control._bg[2]:SetSize(control._bg[2]:GetSizeX(), control._bg[2]:GetSizeY() + deltaTime * spreadSpeed)
    else
      control._bg[2]:SetSize(control._bg[2]:GetSizeX(), control._desc[2][4]:GetPosY() + control._desc[2][4]:GetTextSizeY() + 10)
    end
    control._frame_VScroll:SetShow(control._frame:GetSizeY() < control._bg[2]:GetSizeY() + 200)
    control._frame_Content:SetSize(control._frame_Content:GetSizeX(), control._bg[2]:GetSizeY() + 200)
    for descIndex = 1, self._descCount[3] do
      control._desc[2][descIndex]:SetShow(control._desc[2][descIndex]:GetPosY() + control._desc[2][descIndex]:GetTextSizeY() + 5 < control._bg[2]:GetSizeY())
    end
    if control._radioBtn[0]:GetPosY() + control._radioBtn[0]:GetSizeY() + 10 < control._radioBtn[1]:GetPosY() then
      control._radioBtn[1]:SetPosY(control._radioBtn[1]:GetPosY() - deltaTime * spreadSpeed * 2)
    else
      control._radioBtn[1]:SetPosY(control._radioBtn[0]:GetPosY() + control._radioBtn[0]:GetSizeY() + 10)
    end
  end
end
function FGlobal_MercenaryDesc_Open()
  mercenaryGuide._control._radioBtn[0]:SetCheck(true)
  mercenaryGuide._control._radioBtn[1]:SetCheck(false)
  mercenaryGuide._control._radioBtn[2]:SetCheck(false)
  mercenaryGuide._control._bg[0]:SetSize(mercenaryGuide._control._bg[0]:GetSizeX(), 10)
  HandleClicked_MercenaryRadioBtn(0)
end
function FGlobal_MercenaryDesc_Close()
end
function FGlobal_MercenaryDesc_ShowToggle()
  if Panel_Window_Mercenary:GetShow() then
    FGlobal_MercenaryDesc_Close()
  else
    FGlobal_MercenaryDesc_Open()
  end
end
mercenaryGuide:Init()
Panel_Window_Mercenary:RegisterUpdateFunc("MercenaryDesc_ShowDesc")
