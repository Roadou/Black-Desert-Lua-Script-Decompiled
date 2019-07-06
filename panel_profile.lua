local myProfile = {
  _control = {
    _topBg = nil,
    _list2Profile = nil,
    _rightDescBg = nil,
    _radioBtn = {
      [0] = nil,
      [1] = nil,
      [2] = nil,
      [3] = nil
    }
  },
  _radioBtnIndex = 0,
  _selecteIndex = 0,
  _termIndex = {
    [0] = 1,
    [1] = 7,
    [2] = 30,
    [3] = 0
  },
  _termDesc = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_DAY"),
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_WEEK"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_MONTH"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_TOTAL")
  },
  _string = {
    [CppEnums.ProfileIndex.eUserProfileValueType_MonsterKillCount] = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_TITLE_1"),
    [CppEnums.ProfileIndex.eUserProfileValueType_FishingSuccessCount] = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_TITLE_2"),
    [CppEnums.ProfileIndex.eUserProfileValueType_ItemGainCount] = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_TITLE_3"),
    [CppEnums.ProfileIndex.eUserProfileValueType_ProductSuccessCount] = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_TITLE_4"),
    [CppEnums.ProfileIndex.eUserProfileValueType_Count] = 4
  },
  _desc = {
    [CppEnums.ProfileIndex.eUserProfileValueType_MonsterKillCount] = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_DESC_1"),
    [CppEnums.ProfileIndex.eUserProfileValueType_FishingSuccessCount] = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_DESC_2"),
    [CppEnums.ProfileIndex.eUserProfileValueType_ItemGainCount] = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_DESC_3"),
    [CppEnums.ProfileIndex.eUserProfileValueType_ProductSuccessCount] = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_DESC_4")
  },
  _rewardKey = {
    [CppEnums.ProfileIndex.eUserProfileValueType_MonsterKillCount] = -1,
    [CppEnums.ProfileIndex.eUserProfileValueType_FishingSuccessCount] = -1,
    [CppEnums.ProfileIndex.eUserProfileValueType_ItemGainCount] = -1,
    [CppEnums.ProfileIndex.eUserProfileValueType_ProductSuccessCount] = -1,
    [CppEnums.ProfileIndex.eUserProfileValueType_Count] = 4
  },
  _rewardIndex = {
    [CppEnums.ProfileIndex.eUserProfileValueType_MonsterKillCount] = -1,
    [CppEnums.ProfileIndex.eUserProfileValueType_FishingSuccessCount] = -1,
    [CppEnums.ProfileIndex.eUserProfileValueType_ItemGainCount] = -1,
    [CppEnums.ProfileIndex.eUserProfileValueType_ProductSuccessCount] = -1,
    [CppEnums.ProfileIndex.eUserProfileValueType_Count] = 4
  },
  _iconPath = "renewal/ui_icon/console_icon_myinfo_00.dds",
  _iconCoordinate = {
    [CppEnums.ProfileIndex.eUserProfileValueType_MonsterKillCount] = {
      x1 = 2,
      y1 = 56,
      x2 = 72,
      y2 = 126
    },
    [CppEnums.ProfileIndex.eUserProfileValueType_FishingSuccessCount] = {
      x1 = 74,
      y1 = 56,
      x2 = 144,
      y2 = 126
    },
    [CppEnums.ProfileIndex.eUserProfileValueType_ItemGainCount] = {
      x1 = 146,
      y1 = 56,
      x2 = 216,
      y2 = 126
    },
    [CppEnums.ProfileIndex.eUserProfileValueType_ProductSuccessCount] = {
      x1 = 2,
      y1 = 128,
      x2 = 72,
      y2 = 198
    }
  },
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  },
  _rewardSlot = {},
  _rewardSlotBG = {},
  _rewardBG,
  _periodType = 0
}
local group_2
local RewardSlotCount = 4
function myProfile:Init()
  if nil == Panel_Window_Profile then
    return
  end
  Panel_Window_Profile:SetShow(false)
  local control = self._control
  control._topBg = UI.getChildControl(Panel_Window_Profile, "Static_TopBg")
  control._list2Profile = UI.getChildControl(Panel_Window_Profile, "List2_LeftContent")
  control._rightDescBg = UI.getChildControl(Panel_Window_Profile, "Static_RightDescBg")
  control._radioBtn[0] = UI.getChildControl(Panel_Window_Profile, "RadioButton_Daily")
  control._radioBtn[1] = UI.getChildControl(Panel_Window_Profile, "RadioButton_Weekly")
  control._radioBtn[2] = UI.getChildControl(Panel_Window_Profile, "RadioButton_Monthly")
  control._radioBtn[3] = UI.getChildControl(Panel_Window_Profile, "RadioButton_SumAll")
  control._playTime = UI.getChildControl(control._topBg, "StaticText_PlayTime")
  control._pcRoolTime = UI.getChildControl(control._topBg, "StaticText_PcRoomTime")
  control._circleBg = UI.getChildControl(control._rightDescBg, "Static_CircleBg")
  control._icon = UI.getChildControl(control._circleBg, "Static_Icon")
  control._name = UI.getChildControl(control._rightDescBg, "StaticText_Name")
  control._period = UI.getChildControl(control._rightDescBg, "StaticText_Period")
  control._desc = UI.getChildControl(control._rightDescBg, "StaticText_Desc")
  control._slotBG = UI.getChildControl(control._rightDescBg, "Static_RewardsBG")
  control._period:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  control._desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local radiobutton = UI.getChildControl(Panel_Window_Profile, "RadioButton_Daily")
  radiobutton:addInputEvent("Mouse_LUp", "FGlobal_ProfileReward_PeriodUpdate(" .. 1 .. ")")
  radiobutton:SetCheck(true)
  radiobutton = UI.getChildControl(Panel_Window_Profile, "RadioButton_Weekly")
  radiobutton:addInputEvent("Mouse_LUp", "FGlobal_ProfileReward_PeriodUpdate(" .. 7 .. ")")
  radiobutton = UI.getChildControl(Panel_Window_Profile, "RadioButton_Monthly")
  radiobutton:addInputEvent("Mouse_LUp", "FGlobal_ProfileReward_PeriodUpdate(" .. 30 .. ")")
  radiobutton = UI.getChildControl(Panel_Window_Profile, "RadioButton_SumAll")
  radiobutton:addInputEvent("Mouse_LUp", "FGlobal_ProfileReward_PeriodUpdate(" .. 0 .. ")")
  for index = 0, RewardSlotCount - 1 do
    self._rewardSlotBG[index] = UI.getChildControl(control._slotBG, "Static_RewardItemSlotBg_" .. tostring(index))
    self._rewardSlotBG[index]:SetShow(true)
    local createSlot = {}
    SlotItem.new(createSlot, "Reward_SlotItem" .. tostring(index), 0, self._rewardSlotBG[index], self.slotConfig)
    createSlot:createChild()
    local sizeX = createSlot.icon:GetSizeX()
    local sizeY = createSlot.icon:GetSizeY()
    createSlot.icon:SetShow(true)
    createSlot.icon:SetSize(sizeX * 0.8, sizeY * 0.8)
    self._rewardSlot[index] = createSlot
  end
  control._slotBG:SetShow(false)
  self._periodType = 1
end
function FGlobal_ProfileReward_ApplyGetReward(index)
  ToClient_sendApplyGetProfileReward(myProfile._rewardKey[index])
end
function FGlobal_ProfileReward_PeriodUpdate(period)
  myProfile._periodType = period
  FGlobal_ProfileReward_AllUpdate()
  ProfileReward_RightDataSet(0)
end
function FGlobal_Profile_Update(tabBtnInit)
  if nil == Panel_Window_Profile then
    return
  end
  local self = myProfile
  self._selecteIndex = 0
  if not tabBtnInit then
    self._radioBtnIndex = 0
    self:RadioBtn_Init()
  end
  Profile_RightDataSet(self._selecteIndex)
  ToClient_RequestUserProfileInfo()
end
function myProfile:RadioBtn_Init()
  if nil == Panel_Window_Profile then
    return
  end
  for index = 0, CppEnums.ProfileInitTermType.eProfileInitTermType_Maxcount - 1 do
    self._control._radioBtn[index]:SetCheck(self._radioBtnIndex == index)
  end
end
function Profile_Update()
  if nil == Panel_Window_Profile then
    return
  end
  local self = myProfile
  local control = self._control
  control._list2Profile:getElementManager():clearKey()
  for index = 0, CppEnums.ProfileIndex.eUserProfileValueType_Count - 1 do
    control._list2Profile:getElementManager():pushKey(toInt64(0, index))
  end
end
function HandleClicked_RadioButton(index)
  if nil == Panel_Window_Profile then
    return
  end
  local self = myProfile
  self._radioBtnIndex = index
  Profile_Update()
  FGlobal_Profile_Update(true)
end
function Profile_DataSet(content, key)
  if nil == Panel_Window_Profile then
    return
  end
  local self = myProfile
  local contentBg = UI.getChildControl(content, "RadioButton_ContentBg")
  local title = UI.getChildControl(content, "StaticText_Title")
  local count = UI.getChildControl(content, "StaticText_Count")
  local _key = Int64toInt32(key)
  local _count = ToClient_GetProfileInfo(self._termIndex[self._radioBtnIndex], _key)
  contentBg:addInputEvent("Mouse_LUp", "Profile_RightDataSet(" .. _key .. ")")
  contentBg:SetPosX(7)
  local contentBgStartY = 1
  if CppEnums.ProfileIndex.eUserProfileValueType_MonsterKillCount == _key then
    _count = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_MONSTERCOUNT", "count", makeDotMoney(_count))
    contentBg:SetPosY(contentBgStartY)
  elseif CppEnums.ProfileIndex.eUserProfileValueType_FishingSuccessCount == _key then
    _count = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_ITEMCOUNT", "count", makeDotMoney(_count))
  elseif CppEnums.ProfileIndex.eUserProfileValueType_ItemGainCount == _key then
    _count = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_ITEMCOUNT", "count", makeDotMoney(_count))
  elseif CppEnums.ProfileIndex.eUserProfileValueType_ProductSuccessCount == _key then
    _count = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_WEIGHT", "count", makeWeightString(_count))
  else
    _count = makeDotMoney(_count)
  end
  title:SetText(self._string[_key])
  count:SetText(_count)
  Profile_TimeSet()
  if self._selecteIndex == _key then
    contentBg:SetCheck(true)
  else
    contentBg:SetCheck(false)
  end
end
function Profile_TimeSet()
  if nil == Panel_Window_Profile then
    return
  end
  local self = myProfile
  local control = self._control
  local temporaryPCRoomWrapper = getTemporaryInformationWrapper()
  local isPremiumPcRoom = temporaryPCRoomWrapper:isPremiumPcRoom()
  local userPlayTime = Util.Time.timeFormatting(Int64toInt32(ToClient_GetUserPlayTimePerDay()))
  local totalPlayTime = Util.Time.timeFormatting_Minute(Int64toInt32(ToClient_GetCharacterPlayTime()))
  control._playTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_TODAYPLAYTIME") .. "<PAColor0xFFFFC730>" .. tostring(userPlayTime) .. "<PAOldColor> | " .. PAGetString(Defines.StringSheet_GAME, "LUA_CONTRACT_TIME_BLACKSPIRIT") .. "<PAColor0xFFFFC730> " .. totalPlayTime .. "<PAOldColor> ")
  if 420 < control._playTime:GetTextSizeX() then
    control._playTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_TODAYPLAYTIME") .. "<PAColor0xFFFFC730>" .. tostring(userPlayTime) .. "<PAOldColor>\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_CONTRACT_TIME_BLACKSPIRIT") .. "<PAColor0xFFFFC730> " .. totalPlayTime .. "<PAOldColor> ")
  end
  if isPremiumPcRoom and (isGameTypeKorea() or isGameTypeJapan()) then
    control._playTime:SetPosY(23)
    control._pcRoolTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_PCROOMPLAYTIME") .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_PCROOMTIME", "getPcRoomPlayTime", convertStringFromDatetime(ToClient_GetPcRoomPlayTime())))
    control._pcRoolTime:SetShow(true)
  else
    control._playTime:SetPosY(23)
    control._pcRoolTime:SetShow(false)
  end
end
function Profile_RightDataSet(index)
  if nil == Panel_Window_Profile then
    return
  end
  local self = myProfile
  local control = self._control
  self._selecteIndex = index
  control._icon:ChangeTextureInfoName(self._iconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(control._icon, self._iconCoordinate[index].x1, self._iconCoordinate[index].y1, self._iconCoordinate[index].x2, self._iconCoordinate[index].y2)
  control._icon:getBaseTexture():setUV(x1, y1, x2, y2)
  control._icon:setRenderTexture(control._icon:getBaseTexture())
  control._name:SetText(self._string[index])
  control._period:SetText(self._termDesc[self._radioBtnIndex])
  control._desc:SetText(self._desc[index])
  if ToClient_IsDevelopment() then
    control._slotBG:SetShow(false)
    local profilerewardwrapper = ToClient_getProfileRewardItem(self._periodType, index)
    if profilerewardwrapper ~= nil then
      local userProfileValue = profilerewardwrapper:getUserProfileValue()
      local userProfileRewardFlag = profilerewardwrapper:getRewardFlag()
      for arrindex = 0, RewardSlotCount - 1 do
        local itemStatic = getItemEnchantStaticStatus(profilerewardwrapper:getUserProfileRewardItemkey(arrindex))
        local rewardkey = 0
        if itemStatic ~= nil then
          myProfile._rewardSlotBG[arrindex]:SetShow(true)
          myProfile._rewardSlot[arrindex].icon:SetShow(true)
          if true == userProfileRewardFlag then
            myProfile._rewardSlot[arrindex].icon:SetIgnore(true)
          else
            myProfile._rewardSlot[arrindex].icon:SetIgnore(userProfileValue < profilerewardwrapper:getUserProfileRewardGoal(arrindex))
          end
          myProfile._rewardKey[arrindex] = profilerewardwrapper:getUserProfileRewardKey(arrindex)
          local keyindex = arrindex
          myProfile._rewardSlot[arrindex].icon:addInputEvent("Mouse_LUp", "FGlobal_ProfileReward_ApplyGetReward(" .. keyindex .. ")")
          myProfile._rewardSlot[arrindex]:setItemByStaticStatus(itemStatic, profilerewardwrapper:getUserProfileRewardItemCount(arrindex))
        else
          myProfile._rewardKey[arrindex] = 0
          myProfile._rewardSlot[arrindex].icon:SetShow(false)
          myProfile._rewardSlotBG[arrindex]:SetShow(false)
        end
      end
    end
  else
    control._slotBG:SetShow(false)
  end
end
function myProfile:registEventHandler()
  if nil == Panel_Window_Profile then
    return
  end
  Panel_Window_Profile:RegisterCloseLuaFunc(PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Escape
  }), "HandleClicked_ProfileWindow_Close()")
  for index = 0, CppEnums.ProfileInitTermType.eProfileInitTermType_Maxcount - 1 do
    self._control._radioBtn[index]:addInputEvent("Mouse_LUp", "HandleClicked_RadioButton(" .. index .. ")")
  end
  self._control._list2Profile:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "Profile_DataSet")
  self._control._list2Profile:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function myProfile:registMessageHandler()
  registerEvent("Profile_Updatelist", "Profile_Update")
end
function FromClient_CharacterInfoProfile_Init()
  PaGlobal_CharacterInfoProfile_Init()
  myProfile:registMessageHandler()
end
function PaGlobal_CharacterInfoProfile_Init()
  myProfile:Init()
  myProfile:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_CharacterInfoProfile_Init")
