local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_AH = CppEnums.PA_UI_ALIGNHORIZON
local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
Panel_Broadcast:ActiveMouseEventEffect(true)
Panel_Broadcast:setGlassBackground(true)
Panel_Broadcast:SetShow(false, false)
Panel_Broadcast:RegisterShowEventFunc(true, "Broadcast_ShowAni()")
Panel_Broadcast:RegisterShowEventFunc(false, "Broadcast_HideAni()")
function Broadcast_ShowAni()
end
function Broadcast_HideAni()
end
local broadcast_List = 0
local broadcast_Create = 1
local broadcast_OnAir = 2
local broadcast_ControlType = {}
local closeBtn = UI.getChildControl(Panel_Broadcast, "Button_CloseIcon")
local radioBroadcastList = UI.getChildControl(Panel_Broadcast, "RadioButton_BroadcastList")
local radioBroadcasting = UI.getChildControl(Panel_Broadcast, "RadioButton_Broadcasting")
broadcast_ControlType[broadcast_List] = {
  sortBg = UI.getChildControl(Panel_Broadcast, "StaticText_SortBg"),
  radioSortType_1 = UI.getChildControl(Panel_Broadcast, "RadioButton_SortType1"),
  radioSortType_2 = UI.getChildControl(Panel_Broadcast, "RadioButton_SortType2"),
  broadcastCount = UI.getChildControl(Panel_Broadcast, "StaticText_BroadcastCount"),
  listBg = UI.getChildControl(Panel_Broadcast, "Static_BroadcastListBg"),
  list2_BroadcastGroup = UI.getChildControl(Panel_Broadcast, "List2_BroadcastGroup")
}
broadcast_ControlType[broadcast_Create] = {
  myBroadcastBg = UI.getChildControl(Panel_Broadcast, "Static_MyBroadcastBg"),
  createBroadcastBg = UI.getChildControl(Panel_Broadcast, "Static_CreateBroadcastBg"),
  titleText = UI.getChildControl(Panel_Broadcast, "StaticText_CreateBroadcast_TitleIcon"),
  descTitleText = UI.getChildControl(Panel_Broadcast, "StaticText_CreateBreadcast_DescIcon"),
  edit_Desc = UI.getChildControl(Panel_Broadcast, "Edit_CreateBroadcast_Desc"),
  audienceCountTitleText = UI.getChildControl(Panel_Broadcast, "StaticText_AudienceLimitTitleIcon"),
  radioCountType_1 = UI.getChildControl(Panel_Broadcast, "RadioButton_AudienceCountType1"),
  radioCountType_2 = UI.getChildControl(Panel_Broadcast, "RadioButton_AudienceCountType2"),
  radioCountType_3 = UI.getChildControl(Panel_Broadcast, "RadioButton_AudienceCountType3"),
  volumeTitleText = UI.getChildControl(Panel_Broadcast, "StaticText_CreateBroadcast_VolumeSetTitleIcon"),
  titleBg_1 = UI.getChildControl(Panel_Broadcast, "Static_CreateBroadcastTitleBg_1"),
  titleBg_2 = UI.getChildControl(Panel_Broadcast, "Static_CreateBroadcastTitleBg_2"),
  titleBg_3 = UI.getChildControl(Panel_Broadcast, "Static_CreateBroadcastTitleBg_3"),
  sliderBtn = UI.getChildControl(Panel_Broadcast, "Slider_ContrastControl"),
  volume_0 = UI.getChildControl(Panel_Broadcast, "StaticText_Volume_0"),
  volume_50 = UI.getChildControl(Panel_Broadcast, "StaticText_Volume_50"),
  volume_100 = UI.getChildControl(Panel_Broadcast, "StaticText_Volume_100"),
  btnStart = UI.getChildControl(Panel_Broadcast, "Button_BroadcastStart"),
  desc = UI.getChildControl(Panel_Broadcast, "StaticText_CreateBroadcast_Desc")
}
broadcast_ControlType[broadcast_OnAir] = {
  onAirBg = UI.getChildControl(Panel_Broadcast, "Static_MyBroadcastingBg"),
  onAirIcon = UI.getChildControl(Panel_Broadcast, "Static_BroadcastingIcon"),
  textOnAir = UI.getChildControl(Panel_Broadcast, "StaticText_Broadcasting_OnAir"),
  titleText = UI.getChildControl(Panel_Broadcast, "StaticText_Broadcasting_TitleIcon"),
  descTitleText = UI.getChildControl(Panel_Broadcast, "StaticText_Broadcasting_DescIcon"),
  onAirDesc = UI.getChildControl(Panel_Broadcast, "StaticText_Broadcasting_Desc1"),
  audienceCountTitleText = UI.getChildControl(Panel_Broadcast, "StaticText_Broadcasting_AudienceCountIcon"),
  audiencceCount = UI.getChildControl(Panel_Broadcast, "StaticText_Broadcasting_AudienceCount"),
  volumeTitleText = UI.getChildControl(Panel_Broadcast, "StaticText_Broadcasting_VolumeSetTitleIcon"),
  sliderBtn = UI.getChildControl(Panel_Broadcast, "Slider_Broadcasting_VolumeSlider"),
  volume_0 = UI.getChildControl(Panel_Broadcast, "StaticText_Broadcasting_Volume_0"),
  volume_50 = UI.getChildControl(Panel_Broadcast, "StaticText_Broadcasting_Volume_50"),
  volume_100 = UI.getChildControl(Panel_Broadcast, "StaticText_Broadcasting_Volume_100"),
  btnFinish = UI.getChildControl(Panel_Broadcast, "Button_BroadcastingFinish"),
  desc = UI.getChildControl(Panel_Broadcast, "StaticText_Broadcasting_Desc2")
}
function FromClient_VoiceChatList()
  Panel_Broadcast:SetShow(true, true)
  Broadcast_ControlOpenByType(broadcast_List)
end
function Broadcast_ControlOpenByType(_type)
  for index = 0, #broadcast_ControlType do
    for v, control in pairs(broadcast_ControlType[index]) do
      control:SetShow(_type == index)
    end
  end
end
function Panel_Broadcast_Close()
  Panel_Broadcast:SetShow(false, false)
end
closeBtn:addInputEvent("Mouse_LUp", "Panel_Broadcast_Close()")
