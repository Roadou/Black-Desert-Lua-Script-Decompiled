Panel_GuildServant_RevivalList:SetShow(false)
PaGlobal_GuildServant_RevivalList = {
  _guildServantNoArray = {},
  _guildServantRevivalableCount = 0,
  _itemStartingPosY = 90,
  _itemIndexPerPosY = 25,
  _panelBgDefaultHeight = 180,
  _contentBgDefaultHeight = 35,
  _applyBtnDefaultPosY = 128,
  _ui = {
    _contentBg = UI.getChildControl(Panel_GuildServant_RevivalList, "Template_Static_ListContentBG"),
    _buttonClose = UI.getChildControl(Panel_GuildServant_RevivalList, "Button_CloseIcon"),
    _buttonApply = UI.getChildControl(Panel_GuildServant_RevivalList, "Button_Apply"),
    _radioGroupNum = UI.getChildControl(Panel_GuildServant_RevivalList, "RadioButton_ServantTemplete"):GetGroupNumber(),
    _list = {}
  },
  originalPosX = Panel_GuildServant_RevivalList:GetPosX(),
  originalPosY = Panel_GuildServant_RevivalList:GetPosY()
}
function PaGlobal_GuildServant_RevivalList:init()
  UI.getChildControl(Panel_GuildServant_RevivalList, "RadioButton_ServantTemplete"):SetShow(false)
end
function PaGlobal_GuildServant_RevivalList:update()
  PaGlobal_GuildServant_RevivalList:itemHideAll()
  PaGlobal_GuildServant_RevivalList:listSetting()
  PaGlobal_GuildServant_RevivalList:bgSetting()
end
function PaGlobal_GuildServant_RevivalList:itemHideAll()
  for ii = 0, self._guildServantRevivalableCount - 1 do
    if nil ~= self._ui._list[ii] then
      self._ui._list[ii]:SetShow(false)
    end
  end
end
function PaGlobal_GuildServant_RevivalList:listSetting()
  self._guildServantNoArray = {}
  self._guildServantRevivalableCount = 0
  local count = guildstable_getComaGuildServantCount()
  for ii = 0, count - 1 do
    local servantInfo = guildstable_getComaGuildServantAt(ii)
    if nil ~= servantInfo then
      PaGlobal_GuildServant_RevivalList:itemSetting(self._guildServantRevivalableCount, servantInfo)
      self._guildServantRevivalableCount = self._guildServantRevivalableCount + 1
    end
  end
end
function PaGlobal_GuildServant_RevivalList:itemSetting(index, servantWrapper)
  if nil ~= servantWrapper then
    self._guildServantNoArray[index] = servantWrapper:getServantNo()
    if nil == self._ui._list[index] then
      self._ui._list[index] = UI.createAndCopyBasePropertyControl(Panel_GuildServant_RevivalList, "RadioButton_ServantTemplete", Panel_GuildServant_RevivalList, "RadioButton_ServantTemplete_" .. index)
    end
    self._ui._list[index]:SetPosY(self._itemStartingPosY + index * self._itemIndexPerPosY)
    self._ui._list[index]:SetText(servantWrapper:getName())
    self._ui._list[index]:SetShow(true)
  end
end
function PaGlobal_GuildServant_RevivalList:bgSetting()
  local itemTotalHeight = (self._guildServantRevivalableCount - 1) * self._itemIndexPerPosY
  Panel_GuildServant_RevivalList:SetSize(Panel_GuildServant_RevivalList:GetSizeX(), self._panelBgDefaultHeight + itemTotalHeight)
  self._ui._contentBg:SetSize(self._ui._contentBg:GetSizeX(), self._contentBgDefaultHeight + itemTotalHeight)
  self._ui._buttonApply:SetPosY(self._applyBtnDefaultPosY + itemTotalHeight)
end
function PaGlobal_GuildServant_RevivalList:selectFirstItem()
  Panel_GuildServant_RevivalList:ResetRadiobutton(self._ui._radioGroupNum)
  if nil ~= self._ui._list[0] then
    self._ui._list[0]:SetCheck(true)
  end
end
function PaGlobal_GuildServant_RevivalList:getSelectedIndex()
  for ii = 0, self._guildServantRevivalableCount - 1 do
    if true == self._ui._list[ii]:IsChecked() then
      return ii
    end
  end
  return -1
end
function PaGlobal_GuildServant_RevivalList:open()
  local isShow = Panel_GuildServant_RevivalList:GetShow()
  if false == isShow then
    Panel_GuildServant_RevivalList:SetShow(true)
    PaGlobal_GuildServant_RevivalList:refresh()
  end
end
function PaGlobal_GuildServant_RevivalList:close()
  Panel_GuildServant_RevivalList:SetShow(false)
end
function PaGlobal_GuildServant_RevivalList:refresh()
  PaGlobal_GuildServant_RevivalList:selectFirstItem()
  PaGlobal_GuildServant_RevivalList:update()
  Panel_GuildServant_RevivalList:SetPosX(PaGlobal_GuildServant_RevivalList.originalPosX)
  Panel_GuildServant_RevivalList:SetPosY(PaGlobal_GuildServant_RevivalList.originalPosY)
end
local _fromWhereType, _fromSlotNo
function PaGlobal_GuildServant_RevivalList:apply()
  local selectedIndex = PaGlobal_GuildServant_RevivalList:getSelectedIndex()
  local servantNo = self._guildServantNoArray[selectedIndex]
  if nil ~= servantNo then
    ToClient_RequestResurrectionServant(servantNo, _fromWhereType, _fromSlotNo)
  end
end
function PaGlobal_GuildServant_RevivalList:registMessageHandler()
  self._ui._buttonApply:addInputEvent("Mouse_LUp", "PaGlobal_GuildServant_RevivalList:apply()")
  self._ui._buttonClose:addInputEvent("Mouse_LUp", "PaGlobal_GuildServant_RevivalList:close()")
end
function PaGlobal_GuildServant_RevivalList:registEventHandler()
  registerEvent("FromClient_ServantSeal", "FromClient_GuildServant_RevivalList_Update")
  registerEvent("FromClient_ServantUnseal", "FromClient_GuildServant_RevivalList_Update")
  registerEvent("FromClient_ServantToReward", "FromClient_GuildServant_RevivalList_Update")
  registerEvent("FromClient_ServantRecovery", "FromClient_GuildServant_RevivalList_Update")
  registerEvent("FromClient_ServantChangeName", "FromClient_GuildServant_RevivalList_Update")
  registerEvent("FromClient_ServantUpdate", "FromClient_GuildServant_RevivalList_Update")
  registerEvent("FromClient_RegistGuildServant", "FromClient_GuildServant_RevivalList_Update")
  registerEvent("FromClient_GuildServantListUpdate", "FromClient_GuildServant_RevivalList_Update")
  registerEvent("FromClient_UseServantRespawnItem", "FromClient_UseGuildServantRespawnItem")
  registerEvent("FromClient_ServantResurrectionAck", "FromClient_GuildServantResurrectionAck")
end
function FromClient_GuildServant_RevivalList_Update()
  PaGlobal_GuildServant_RevivalList:refresh()
end
function FromClient_UseGuildServantRespawnItem(fromWhereType, fromSlotNo, contentEventParam1)
  if contentEventParam1 == CppEnums.ServantWhereType.ServantWhereTypeGuild and 0 ~= guildstable_getComaGuildServantCount() then
    PaGlobal_GuildServant_RevivalList:open()
    _fromWhereType = fromWhereType
    _fromSlotNo = fromSlotNo
  end
end
function FromClient_GuildServantResurrectionAck(servantNo, servantWhereType)
  if servantWhereType == CppEnums.ServantWhereType.ServantWhereTypeGuild then
    PaGlobal_GuildServant_RevivalList:close()
    local servantInfo = guildStable_getServantByServantNo(servantNo)
    if nil ~= servantInfo then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTRESURRECTION_MSG"))
    end
  end
end
PaGlobal_GuildServant_RevivalList:init()
PaGlobal_GuildServant_RevivalList:update()
PaGlobal_GuildServant_RevivalList:registMessageHandler()
PaGlobal_GuildServant_RevivalList:registEventHandler()
