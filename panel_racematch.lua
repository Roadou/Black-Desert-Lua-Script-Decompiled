local raceResult = {}
local returnTime = 0
local raceCheck = false
local isContentsEnable = ToClient_IsContentsGroupOpen("41")
local raceResultControl = {
  _Back_BG = UI.getChildControl(Panel_RaceResult, "Back_BG"),
  _Line_Bottom = UI.getChildControl(Panel_RaceResult, "Line_Bottom_Win"),
  _Button_Close = UI.getChildControl(Panel_RaceResult, "Button_Close"),
  _Txt_EndTime = UI.getChildControl(Panel_RaceResult, "StaticText_EndInfo"),
  resultList = {}
}
local raceStart = {
  _Txt_time = UI.getChildControl(Panel_RaceTimeAttack, "StaticText_TimeCount"),
  _Txt_FinishTime = UI.getChildControl(Panel_RaceFinishTime, "StaticText_FinishTime")
}
function FromClient_UpdateRace(raceState, nodeName)
  if not isContentsEnable then
    return
  end
  local self = raceStart
  local messages = {
    main = "",
    sub = "",
    addMsg = ""
  }
  local msgType = 36
  local nextNodeName = ""
  if 0 == raceState then
    messages = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACEUPDATE_MSG1"),
      sub = "",
      addMsg = ""
    }
    msgType = 36
    raceCheck = true
  elseif 1 == raceState then
    messages = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACEUPDATE_MSG2"),
      sub = "",
      addMsg = ""
    }
    msgType = 40
    raceCheck = true
    RaceWindowToggleCheck()
    Panel_RaceTimeAttack:SetShow(true)
    Panel_RaceFinishTime:SetShow(false)
  elseif 2 == raceState then
    if "" == nodeName or nil == nodeName or " " == nodeName then
      nextNodeName = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_GOAL_IN")
    else
      nextNodeName = nodeName
    end
    messages = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACEUPDATE_MSG3"),
      sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RACEMATCH_NEXTNODE", "nextNodeName", nextNodeName),
      addMsg = ""
    }
    msgType = 41
    raceCheck = true
  elseif 3 == raceState then
    messages = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACEUPDATE_MSG4"),
      sub = "",
      addMsg = ""
    }
    msgType = 37
    self._Txt_time:SetShow(false)
    raceCheck = false
  elseif 4 == raceSTate then
    messages = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACEUPDATE_MSG5"),
      sub = "",
      addMsg = ""
    }
    msgType = 36
    raceCheck = true
  end
  Proc_ShowMessage_Ack_For_RewardSelect(messages, 10, msgType)
end
function FromClient_MatchRaceResult()
  audioPostEvent_SystemUi(17, 2)
  local self = raceResultControl
  local resultCount = ToClient_RaceMatchResultCount()
  local resultBg = 1
  raceResult = {}
  for idx = 0, resultCount - 1 do
    local raceResultInfo = ToClient_RaceMatchResultAt(idx)
    if false == raceResultInfo:isEmpty() and 0 ~= raceResultInfo:getRank() then
      local _rank = raceResultInfo:getRank()
      local _name = raceResultInfo:getName()
      local _recordTime = raceResultInfo:getRecordTime()
      local raceResultList = {}
      raceResultList.bg = UI.createAndCopyBasePropertyControl(Panel_RaceResult, "Static_RankBG", self._Back_BG, "raceResultList_BG_" .. idx)
      raceResultList.rankIcon = UI.createAndCopyBasePropertyControl(Panel_RaceResult, "Static_TopRankIcon", self._Back_BG, "raceResultList_rankIcon_" .. idx)
      raceResultList.rankTxt = UI.createAndCopyBasePropertyControl(Panel_RaceResult, "StaticText_LowRank", self._Back_BG, "raceResultList_rankTxt_" .. idx)
      raceResultList.name = UI.createAndCopyBasePropertyControl(Panel_RaceResult, "StaticText_RankerName", self._Back_BG, "raceResultList_name_" .. idx)
      raceResultList.time = UI.createAndCopyBasePropertyControl(Panel_RaceResult, "StaticText_RankerTime", self._Back_BG, "raceResultList_time_" .. idx)
      raceResultList.goods = UI.createAndCopyBasePropertyControl(Panel_RaceResult, "StaticText_Goods", self._Back_BG, "raceResultList_goods_" .. idx)
      raceResult[idx] = {
        rank = _rank,
        name = _name,
        recordTime = _recordTime
      }
      self.resultList[idx] = raceResultList
      self.resultList[idx].bg:ChangeTextureInfoName("New_UI_Common_forLua/Widget/Party/Matchresult_00.dds")
      local x1, y1, x2, y2 = 0, 0, 0, 0
      if 1 == resultBg % 2 then
        x1, y1, x2, y2 = setTextureUV_Func(self.resultList[idx].bg, 130, 406, 244, 440)
        self.resultList[idx].bg:getBaseTexture():setUV(x1, y1, x2, y2)
        self.resultList[idx].bg:setRenderTexture(self.resultList[idx].bg:getBaseTexture())
      else
        x1, y1, x2, y2 = setTextureUV_Func(self.resultList[idx].bg, 246, 406, 360, 440)
        self.resultList[idx].bg:getBaseTexture():setUV(x1, y1, x2, y2)
        self.resultList[idx].bg:setRenderTexture(self.resultList[idx].bg:getBaseTexture())
      end
      self.resultList[idx].bg:SetPosY(34 * idx)
      self.resultList[idx].bg:SetShow(true)
      self.resultList[idx].name:SetText(_name)
      self.resultList[idx].name:SetPosY(34 * idx)
      if _rank > 3 then
        self.resultList[idx].rankIcon:SetShow(false)
        self.resultList[idx].rankTxt:SetShow(true)
        self.resultList[idx].rankTxt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LIFERANKING_RANK", "listIdx", _rank))
        self.resultList[idx].rankTxt:SetPosY(0 + 34 * idx)
        self.resultList[idx].goods:SetText("x1")
      else
        self.resultList[idx].rankTxt:SetShow(false)
        self.resultList[idx].rankIcon:SetShow(true)
        self.resultList[idx].rankIcon:ChangeTextureInfoName("New_UI_Common_forLua/Widget/Party/MatchResult_00.dds")
        local x1, y1, x2, y2 = 0, 0, 0, 0
        if 1 == _rank then
          x1, y1, x2, y2 = setTextureUV_Func(self.resultList[idx].rankIcon, 218, 104, 259, 145)
          self.resultList[idx].rankIcon:getBaseTexture():setUV(x1, y1, x2, y2)
          self.resultList[idx].rankIcon:SetPosY(34 * idx - 4)
          self.resultList[idx].rankIcon:setRenderTexture(self.resultList[idx].rankIcon:getBaseTexture())
          self.resultList[idx].goods:SetText("x5")
        elseif 2 == _rank then
          x1, y1, x2, y2 = setTextureUV_Func(self.resultList[idx].rankIcon, 218, 146, 259, 187)
          self.resultList[idx].rankIcon:getBaseTexture():setUV(x1, y1, x2, y2)
          self.resultList[idx].rankIcon:SetPosY(34 * idx - 4)
          self.resultList[idx].rankIcon:setRenderTexture(self.resultList[idx].rankIcon:getBaseTexture())
          self.resultList[idx].goods:SetText("x3")
        elseif 3 == _rank then
          x1, y1, x2, y2 = setTextureUV_Func(self.resultList[idx].rankIcon, 218, 188, 259, 229)
          self.resultList[idx].rankIcon:getBaseTexture():setUV(x1, y1, x2, y2)
          self.resultList[idx].rankIcon:SetPosY(34 * idx - 4)
          self.resultList[idx].rankIcon:setRenderTexture(self.resultList[idx].rankIcon:getBaseTexture())
          self.resultList[idx].goods:SetText("x2")
        end
      end
      self.resultList[idx].goods:SetPosY(34 * idx - 2)
      self.resultList[idx].time:SetText(_recordTime)
      self.resultList[idx].time:SetPosY(34 * idx)
      self._Back_BG:SetSize(self._Back_BG:GetSizeX(), 34 * _rank)
      self._Line_Bottom:SetPosY(self._Back_BG:GetSizeY() + self._Back_BG:GetPosY())
      self._Txt_EndTime:SetPosY(self._Line_Bottom:GetPosY() + 10)
      self._Button_Close:SetPosY(self._Txt_EndTime:GetPosY() + 10)
      resultBg = resultBg + 1
    end
  end
  Panel_RaceResult:SetShow(true)
  Panel_RaceTimeAttack:SetShow(false)
  Panel_RaceFinishTime:SetShow(false)
end
local finishedRace = false
function FromClient_CheckRetire()
  finishedRace = true
  Panel_RaceFinishTime:SetShow(true)
  Panel_RaceFinishTime:RegisterUpdateFunc("RaceFinishTimeCount")
end
function HandleClicked_RaceResultClose()
  Panel_RaceResult:SetShow(false)
end
local startDeltaTime = 0
local startMinuteTime = 0
local finishDeltaTime = 0
function RaceStartTimeCount(deltaTime)
  local self = raceStart
  if not raceCheck then
    return
  end
  Panel_RaceTimeAttack:SetShow(true)
  self._Txt_time:SetText(ToClient_GetCurrentTime())
end
local finishTimeCheck = false
function RaceFinishTimeCount(deltaTime)
  local self = raceStart
  if finishTimeCheck then
    return
  end
  if finishedRace then
    Panel_RaceFinishTime:SetShow(true)
    finishDeltaTime = finishDeltaTime + deltaTime
    local finishTime = 60 - math.ceil(finishDeltaTime)
    self._Txt_FinishTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RACEMATCH_FINISH_TIME_COUNT", "finishTime", finishTime))
    if finishDeltaTime > 60 then
      self._Txt_FinishTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_FINISH_TIME_RESULT"))
      finishTimeCheck = true
    end
  end
end
function RaceResultTimeCount(deltaTime)
  returnTime = returnTime + deltaTime
  local totalTime = 60 - math.ceil(returnTime)
  raceResultControl._Txt_EndTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RACEMATCH_RESULT_TIME_COUNT", "totalTime", convertStringFromDatetime(toInt64(0, totalTime))))
  if returnTime > 60 then
    returnTime = 0
    HandleClicked_RaceResultClose()
  end
end
function RaceWindowToggleCheck()
  if ToClient_WorldMapIsShow() then
    FGlobal_PopCloseWorldMap()
  end
  if Panel_IngameCashShop:GetShow() then
    InGameShop_Close()
  end
  IngameCustomize_Hide()
  if false == _ContentsGroup_RenewUI_Knowledge then
    Panel_Knowledge_Hide()
  else
    PaGlobalFunc_Window_Knowledge_Exit()
  end
  FGlobal_Panel_DyeReNew_Hide()
end
function RaceResultPanel_Resize()
  local scrSizeY = getScreenSizeY()
  Panel_RaceResult:SetPosY(scrSizeY - (Panel_RaceResult:GetPosY() - Panel_RaceResult:GetSizeY()))
  Panel_RaceResult:ComputePos()
  Panel_RaceFinishTime:SetSpanSize(Panel_RaceTimeAttack:GetSpanSize().x, Panel_RaceTimeAttack:GetSpanSize().y + 100)
end
function raceResultControl:registEventHandler()
  self._Button_Close:addInputEvent("Mouse_LUp", "HandleClicked_RaceResultClose()")
end
function FromClient_OpenRaceStart(needTier)
  if not isContentsEnable then
    return
  end
  messages = {
    main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RACEMATCH_OPENRACESTART_TIER", "needTier", needTier),
    sub = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_OPENRACESTART_POSSIBLE"),
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect(messages, 10, 39)
end
function FromClient_RaceRegisterComplete()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACE_REGIST"))
end
function FromClient_RaceUnRegisterComplete()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACE_CANCEL"))
end
local nodeText = ""
function FromClient_RaceNotifyPassCheckPoint(characterName, nodeName)
  if not isContentsEnable then
    return
  end
  if "" == nodeName then
    nodeText = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_GOAL")
  else
    nodeText = nodeName
  end
  local messages = {
    main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACENOTIFYPASS_MAIN", "characterName", characterName),
    sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACENOTIFYPASS_SUB", "nodeName", nodeText),
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect(messages, 10, 43)
end
function raceResultControl:registMessageHandler()
  registerEvent("FromClient_MatchRaceResult", "FromClient_MatchRaceResult")
  registerEvent("FromClient_UpdateRace", "FromClient_UpdateRace")
  registerEvent("FromClient_CheckRetire", "FromClient_CheckRetire")
  registerEvent("FromClient_OpenRaceStart", "FromClient_OpenRaceStart")
  registerEvent("FromClient_RaceRegisterComplete", "FromClient_RaceRegisterComplete")
  registerEvent("FromClient_RaceNotifyPassCheckPoint", "FromClient_RaceNotifyPassCheckPoint")
  registerEvent("FromClient_RaceUnRegisterComplete", "FromClient_RaceUnRegisterComplete")
  registerEvent("onScreenResize", "RaceResultPanel_Resize")
  Panel_RaceResult:RegisterUpdateFunc("RaceResultTimeCount")
  Panel_RaceTimeAttack:RegisterUpdateFunc("RaceStartTimeCount")
end
RaceResultPanel_Resize()
raceResultControl:registEventHandler()
raceResultControl:registMessageHandler()
