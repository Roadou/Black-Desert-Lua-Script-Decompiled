Panel_GuildServantList:SetShow(false)
local guildServantList = {
  _static_Bg = UI.getChildControl(Panel_GuildServantList, "Static_BG"),
  _btn_Close = UI.getChildControl(Panel_GuildServantList, "Button_Close"),
  _frame = UI.getChildControl(Panel_GuildServantList, "Frame_GuildServantList"),
  _listPool = {}
}
guildServantList._frame_Contents = UI.getChildControl(guildServantList._frame, "Frame_1_Content")
guildServantList._frameScroll = UI.getChildControl(guildServantList._frame, "Frame_1_VerticalScroll")
guildServantList._frameScroll:SetShow(false)
function GuildServantList_Init()
  local self = guildServantList
  local guildServantCount = guildstable_getUnsealGuildServantCount()
  for index = 0, guildServantCount - 1 do
    local list = {}
    if nil ~= self._listPool[index] then
      UI.deleteControl(self._listPool[index].name)
      UI.deleteControl(self._listPool[index].channel)
      UI.deleteControl(self._listPool[index].call)
      self._listPool[index] = {}
    end
    list.name = UI.createAndCopyBasePropertyControl(Panel_GuildServantList, "StaticText_ServantName", self._frame_Contents, "GuildServantList_Name_" .. index)
    list.channel = UI.createAndCopyBasePropertyControl(Panel_GuildServantList, "StaticText_ChannelName", self._frame_Contents, "GuildServantList_Channel_" .. index)
    list.call = UI.createAndCopyBasePropertyControl(Panel_GuildServantList, "Button_Call", self._frame_Contents, "GuildServantList_Call_" .. index)
    list.name:SetPosX(6)
    list.name:SetPosY(0 + 20 * index)
    list.channel:SetPosX(166)
    list.channel:SetPosY(0 + 20 * index)
    list.call:SetPosX(298)
    list.call:SetPosY(2 + 20 * index)
    self._listPool[index] = list
  end
end
local guildServant = {}
local beforeGuildeServantCount = 0
function GuildServantList_Update()
  local self = guildServantList
  local guildServantCount = guildstable_getUnsealGuildServantCount()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  if beforeGuildeServantCount > 0 then
    GuildServantList_ContorlShow(beforeGuildeServantCount, false)
  end
  beforeGuildeServantCount = guildServantCount
  guildServant = {}
  for index = 0, guildServantCount - 1 do
    local list = self._listPool[index]
    local servantWrapper = guildStable_getUnsealGuildServantAt(index)
    if nil ~= servantWrapper then
      local servantName = servantWrapper:getName()
      local servantNo = servantWrapper:getServantNo()
      local servantServerNo = servantWrapper:getServerNo()
      local channelName = getChannelName(worldNo, servantServerNo)
      local vehicleType = servantWrapper:getServantType()
      list.name:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
      list.channel:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
      list.name:SetText(servantName)
      list.channel:SetText(channelName)
      guildServant[index] = servantNo
      list.call:addInputEvent("Mouse_LUp", "HandleClicked_GuildServantCall( " .. index .. ")")
      list.name:SetShow(true)
      list.channel:SetShow(true)
      if 1 == vehicleType then
        list.call:SetShow(false)
      else
        list.call:SetShow(true)
      end
    end
  end
end
function GuildServantList_ContorlShow(count, isShow)
  for index = 0, count - 1 do
    local list = guildServantList._listPool[index]
    list.name:SetShow(isShow)
    list.channel:SetShow(isShow)
    list.call:SetShow(isShow)
  end
end
function HandleClicked_GuildServantCall(index)
  if nil == guildServant[index] then
    return
  end
  servant_callGuildServant(guildServant[index])
end
function FGlobal_GuildServantList_Open()
  local isShow = Panel_GuildServantList:GetShow()
  if isShow then
    Panel_GuildServantList:SetShow(false)
  else
    Panel_GuildServantList:SetShow(true)
    GuildServantList_Init()
    GuildServantList_Update()
  end
end
function GuildServantList_Close()
  Panel_GuildServantList:SetShow(false)
end
function GuildServantList_ListRefresh()
  GuildServantList_Init()
  GuildServantList_Update()
end
function FromClient_GuildServantListUpdate()
  GuildServantList_ListRefresh()
end
function GuildServantList_registMessageHandler()
  local self = guildServantList
  self._btn_Close:addInputEvent("Mouse_LUp", "GuildServantList_Close()")
end
function GuildServantList_registEventHandler()
  registerEvent("FromClient_GuildServantListUpdate", "FromClient_GuildServantListUpdate")
  registerEvent("FromClient_ServantUnseal", "FromClient_GuildServantListUpdate")
  registerEvent("FromClient_ServantSeal", "FromClient_GuildServantListUpdate")
end
GuildServantList_Init()
GuildServantList_Update()
GuildServantList_registMessageHandler()
GuildServantList_registEventHandler()
