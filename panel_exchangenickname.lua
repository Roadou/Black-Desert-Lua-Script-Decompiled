Panel_ExchangeNickname:SetShow(false)
local UI_TM = CppEnums.TextMode
PaGlobal_ExchangeNickname = {
  _ui = {
    _leftList = nil,
    _rightList = nil,
    CenterTopArea = nil,
    _leftName = nil,
    _rightName = nil,
    _txt_Title = nil,
    _btn_Close = nil
  },
  _leftSelectIndex = -1,
  _rightSelectIndex = -1,
  _ClassTexture = CppEnums.ClassType_Symbol,
  _ClassName = CppEnums.ClassType2String
}
function PaGlobal_ExchangeNickname:Init()
  local applyButton = UI.getChildControl(Panel_ExchangeNickname, "Button_Apply")
  local selectBG = UI.getChildControl(Panel_ExchangeNickname, "Static_SelectBG")
  self._ui._leftList = UI.getChildControl(selectBG, "List2_SelectCharacter1")
  self._ui._rightList = UI.getChildControl(selectBG, "List2_SelectCharacter2")
  self._ui._bg_TopDescBG = UI.getChildControl(Panel_ExchangeNickname, "Static_TopSelectedAreaBG")
  self._ui._txt_TopDesc = UI.getChildControl(self._ui._bg_TopDescBG, "StaticText_TopDesc")
  self._ui.CenterTopArea = UI.getChildControl(Panel_ExchangeNickname, "Static_TopSelectedArea")
  self._ui.SelectedBothIcon = UI.getChildControl(self._ui.CenterTopArea, "Static_ExchangeIcon")
  self._ui.SelectedClassName1 = UI.getChildControl(self._ui.CenterTopArea, "StaticText_ClassName1")
  self._ui.SelectedClassName2 = UI.getChildControl(self._ui.CenterTopArea, "StaticText_ClassName2")
  self._ui._leftName = UI.getChildControl(self._ui.CenterTopArea, "StaticText_SelectDesc1")
  self._ui._rightName = UI.getChildControl(self._ui.CenterTopArea, "StaticText_SelectDesc2")
  self._ui._LeftIcon = UI.getChildControl(self._ui.CenterTopArea, "Static_ClassIcon1")
  self._ui._RightIcon = UI.getChildControl(self._ui.CenterTopArea, "Static_ClassIcon2")
  self._ui._txt_Title = UI.getChildControl(Panel_ExchangeNickname, "StaticText_Title")
  self._ui._btn_Close = UI.getChildControl(self._ui._txt_Title, "Button_Close")
  self._ui._bg_BottomDesc = UI.getChildControl(Panel_ExchangeNickname, "Static_DescBG")
  self._ui._txt_BottomDesc = UI.getChildControl(self._ui._bg_BottomDesc, "StaticText_BottomDesc")
  self._ui._txt_TopDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._txt_TopDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NAMESWAPEXCHANGE_TOP_DESC"))
  self._ui._txt_BottomDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._txt_BottomDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NAMESWAPEXCHANGE_DESC"))
  self._ui._bg_BottomDesc:SetSize(self._ui._bg_BottomDesc:GetSizeX(), self._ui._txt_BottomDesc:GetTextSizeY() + 10)
  Panel_ExchangeNickname:SetSize(Panel_ExchangeNickname:GetSizeX(), self._ui._txt_Title:GetSizeY() + selectBG:GetSizeY() + self._ui._txt_BottomDesc:GetTextSizeY() + 70)
  self._ui._txt_BottomDesc:ComputePos()
  applyButton:ComputePos()
  applyButton:addInputEvent("Mouse_LUp", "HandleClicked_ExchangeNickname_Apply()")
  self._ui._btn_Close:addInputEvent("Mouse_LUp", "FGlobal_Exchange_Close()")
  self._ui._leftList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FGlobal_ExchangeName_CharacterListUpdateLeft")
  self._ui._leftList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._rightList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FGlobal_ExchangeName_CharacterListUpdateRight")
  self._ui._rightList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  registerEvent("FromClient_ShowExchangeNickname", "FromClient_ShowExchangeNickname")
end
function PaGlobal_ExchangeNickname:Open()
  self._leftSelectIndex = -1
  self._rightSelectIndex = -1
  self._ui._leftList:getElementManager():clearKey()
  local characterCount = getCharacterDataCount()
  for index = 0, characterCount - 1 do
    self._ui._leftList:getElementManager():pushKey(toInt64(0, index))
  end
  self._ui._LeftIcon:SetShow(false)
  self._ui._RightIcon:SetShow(false)
  self._ui.CenterTopArea:SetShow(false)
  self._ui._bg_TopDescBG:SetShow(true)
  self._ui._txt_TopDesc:SetShow(true)
  Panel_ExchangeNickname:ResetRadiobutton(2)
  Panel_ExchangeNickname:ResetRadiobutton(1)
  self._ui._rightList:getElementManager():clearKey()
  self._ui._leftName:SetText("")
  self._ui._rightName:SetText("")
  self._ui.SelectedBothIcon:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_ETC_02.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui.SelectedBothIcon, 437, 1, 493, 37)
  self._ui.SelectedBothIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui.SelectedBothIcon:setRenderTexture(self._ui.SelectedBothIcon:getBaseTexture())
  self._ui.SelectedBothIcon:EraseAllEffect()
  Panel_ExchangeNickname:SetShow(true)
end
function FGlobal_ExchangeName_CharacterListUpdateLeft(contents, index)
  local idx = Int64toInt32(index)
  local self = PaGlobal_ExchangeNickname
  local characterName = UI.getChildControl(contents, "Radiobutton_CharacterName")
  local classIcon = UI.getChildControl(contents, "Static_1")
  local data = getCharacterDataByIndex(idx)
  if nil == data then
    return
  end
  local nameText = getCharacterName(data)
  local isClassType = getCharacterClassType(data)
  local isCharacterKey = getCharacterKey(data)
  local isLevel = data._level
  local classTextureLocation = self._ClassTexture[isClassType]
  classIcon:ChangeTextureInfoName(classTextureLocation[1])
  local x1, y1, x2, y2 = setTextureUV_Func(classIcon, classTextureLocation[2], classTextureLocation[3], classTextureLocation[4], classTextureLocation[5])
  classIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  classIcon:setRenderTexture(classIcon:getBaseTexture())
  characterName:SetText("Lv." .. isLevel .. " " .. nameText)
  characterName:SetEnable(true)
  characterName:SetIgnore(false)
  characterName:addInputEvent("Mouse_LUp", "HandleClicked_ExchangeNickname_Select(0," .. tostring(index) .. ")")
end
function FGlobal_ExchangeName_CharacterListUpdateRight(contents, index)
  local idx = Int64toInt32(index)
  local self = PaGlobal_ExchangeNickname
  local characterName = UI.getChildControl(contents, "Radiobutton_CharacterName")
  local classIcon = UI.getChildControl(contents, "Static_2")
  local data = getCharacterDataByIndex(idx)
  if nil == data then
    return
  end
  local nameText = getCharacterName(data)
  local isClassType = getCharacterClassType(data)
  local isCharacterKey = getCharacterKey(data)
  local isLevel = data._level
  local classTextureLocation = self._ClassTexture[isClassType]
  classIcon:ChangeTextureInfoName(classTextureLocation[1])
  local x1, y1, x2, y2 = setTextureUV_Func(classIcon, classTextureLocation[2], classTextureLocation[3], classTextureLocation[4], classTextureLocation[5])
  classIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  classIcon:setRenderTexture(classIcon:getBaseTexture())
  characterName:SetText("Lv." .. isLevel .. " " .. nameText)
  characterName:SetEnable(true)
  characterName:SetIgnore(false)
  characterName:addInputEvent("Mouse_LUp", "HandleClicked_ExchangeNickname_Select(1," .. tostring(index) .. ")")
end
function HandleClicked_ExchangeNickname_Apply()
  local self = PaGlobal_ExchangeNickname
  local function Execute_ExchangeNickName()
    ToClient_RequestExchangeNickName(self._leftSelectIndex, self._rightSelectIndex)
    FGlobal_Exchange_Close()
  end
  local leftData = getCharacterDataByIndex(self._leftSelectIndex)
  if nil == leftData then
    return
  end
  local characterLeftName = getCharacterName(leftData)
  local isLeftClassType = getCharacterClassType(leftData)
  local classLeftNameText = self._ClassName[isLeftClassType]
  local rightData = getCharacterDataByIndex(self._rightSelectIndex)
  if nil == rightData then
    return
  end
  local characterRightName = getCharacterName(rightData)
  local isRightClassType = getCharacterClassType(rightData)
  local classRightNameText = self._ClassName[isRightClassType]
  local messageBoxMemo = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_EXCHANGENICKNAME_CONFIRM_MSG", "class1", tostring(classLeftNameText), "charName1", tostring(characterLeftName), "class2", tostring(classRightNameText), "charName2", tostring(characterRightName))
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = Execute_ExchangeNickName,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleClicked_ExchangeNickname_Select(list, index)
  local self = PaGlobal_ExchangeNickname
  local data = getCharacterDataByIndex(index)
  if nil == data then
    return
  end
  local characterName = getCharacterName(data)
  local isClassType = getCharacterClassType(data)
  if -1 == self._leftSelectIndex and -1 == self._rightSelectIndex then
    self._ui._LeftIcon:SetShow(false)
    self._ui._RightIcon:SetShow(false)
  end
  local classTextureLocation = self._ClassTexture[isClassType]
  local classNameText = self._ClassName[isClassType]
  if 0 == list then
    self._ui.CenterTopArea:SetShow(true)
    self._ui._bg_TopDescBG:SetShow(true)
    self._ui._txt_TopDesc:SetShow(false)
    self._leftSelectIndex = index
    self._ui._LeftIcon:SetShow(true)
    self._ui._leftName:SetText(characterName)
    self._ui.SelectedClassName1:SetText(tostring(classNameText))
    self._ui._LeftIcon:addInputEvent("Mouse_On", "PaGlobal_ExchangeNickname_Tooltips(true, " .. isClassType .. ", 0)")
    self._ui._LeftIcon:addInputEvent("Mouse_Out", "PaGlobal_ExchangeNickname_Tooltips(false)")
    self._ui._LeftIcon:ChangeTextureInfoName(classTextureLocation[1])
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._LeftIcon, classTextureLocation[2], classTextureLocation[3], classTextureLocation[4], classTextureLocation[5])
    self._ui._LeftIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui._LeftIcon:setRenderTexture(self._ui._LeftIcon:getBaseTexture())
    local characterCount = getCharacterDataCount()
    self._ui._rightList:getElementManager():clearKey()
    for listindex = 0, characterCount - 1 do
      if index ~= listindex then
        self._ui._rightList:getElementManager():pushKey(toInt64(0, listindex))
      end
    end
    Panel_ExchangeNickname:ResetRadiobutton(1)
    self._rightSelectIndex = -1
    self._ui._RightIcon:SetShow(false)
    self._ui._rightName:SetText("")
    self._ui.SelectedClassName2:SetText("")
    self._ui.SelectedBothIcon:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_ETC_02.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.SelectedBothIcon, 437, 1, 493, 37)
    self._ui.SelectedBothIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.SelectedBothIcon:setRenderTexture(self._ui.SelectedBothIcon:getBaseTexture())
    self._ui.SelectedBothIcon:EraseAllEffect()
  elseif 1 == list then
    self._rightSelectIndex = index
    self._ui._RightIcon:SetShow(true)
    self._ui._rightName:SetText(characterName)
    self._ui.SelectedClassName2:SetText(tostring(classNameText))
    self._ui._RightIcon:addInputEvent("Mouse_On", "PaGlobal_ExchangeNickname_Tooltips(true, " .. isClassType .. ", 1)")
    self._ui._RightIcon:addInputEvent("Mouse_Out", "PaGlobal_ExchangeNickname_Tooltips(false)")
    self._ui._RightIcon:ChangeTextureInfoName(classTextureLocation[1])
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._RightIcon, classTextureLocation[2], classTextureLocation[3], classTextureLocation[4], classTextureLocation[5])
    self._ui._RightIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui._RightIcon:setRenderTexture(self._ui._RightIcon:getBaseTexture())
    self._ui.SelectedBothIcon:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_ETC_02.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.SelectedBothIcon, 437, 38, 493, 74)
    self._ui.SelectedBothIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.SelectedBothIcon:setRenderTexture(self._ui.SelectedBothIcon:getBaseTexture())
    self._ui.SelectedBothIcon:EraseAllEffect()
    self._ui.SelectedBothIcon:AddEffect("fUI_ChangeName_01", true, 0, 0)
  end
end
function PaGlobal_ExchangeNickname_Tooltips(isShow, classType, controlType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = PaGlobal_ExchangeNickname
  local name, desc, control
  local classNameText = self._ClassName[classType]
  name = tostring(classNameText)
  if 0 == controlType then
    control = self._ui._LeftIcon
  else
    control = self._ui._RightIcon
  end
  TooltipSimple_Show(control, name, desc)
end
function FGlobal_Exchange_Close()
  local self = PaGlobal_ExchangeNickname
  self._leftSelectIndex = -1
  self._rightSelectIndex = -1
  Panel_ExchangeNickname:SetShow(false)
end
function FromClient_luaLoadComplete_ExchangeNameInit()
  PaGlobal_ExchangeNickname:Init()
end
function FromClient_ShowExchangeNickname()
  PaGlobal_ExchangeNickname:Open()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_ExchangeNameInit")
