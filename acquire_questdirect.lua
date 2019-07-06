Panel_QuestDirect:SetShow(false, false)
Panel_QuestDirect:setGlassBackground(true)
Panel_QuestDirect:setFlushAble(false)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local QuestType = CppEnums.QuestType
local ui = {
  _backGround = UI.getChildControl(Panel_QuestDirect, "Static_BG"),
  _countingBG = UI.getChildControl(Panel_QuestDirect, "Static_CountBG"),
  _backEff = UI.getChildControl(Panel_QuestDirect, "Static_BackEffect"),
  _questImg = UI.getChildControl(Panel_QuestDirect, "Static_QuestImg"),
  _text_QuestDirect = UI.getChildControl(Panel_QuestDirect, "StaticText_QuestAccept"),
  _text_QuestTitle = UI.getChildControl(Panel_QuestDirect, "StaticText_QuestTitle"),
  _text_QuestDemand = UI.getChildControl(Panel_QuestDirect, "StaticText_QuestDemand"),
  _text_QuestTitle_2 = UI.getChildControl(Panel_QuestDirect, "StaticText_QuestTitle_2"),
  _text_QuestDemand_2 = UI.getChildControl(Panel_QuestDirect, "StaticText_QuestDemand_2")
}
local QuestDirect_ConstValue = {animationEndTime = 2}
local QuestDirect_Value = {
  elapsedTime = QuestDirect_ConstValue.animationEndTime
}
local nowDemand
local demandPreCount = 0
local constValue = {
  bgBottomGap = ui._backGround:GetSizeY() + ui._backGround:GetPosY() - (ui._text_QuestDemand:GetSizeY() + ui._text_QuestDemand:GetPosY())
}
local function init()
  ui._text_QuestTitle:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui._text_QuestTitle:SetAutoResize(true)
  ui._text_QuestDemand:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui._text_QuestDemand:SetAutoResize(true)
  ui._text_QuestTitle_2:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui._text_QuestTitle_2:SetAutoResize(true)
  ui._text_QuestDemand_2:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui._text_QuestDemand_2:SetAutoResize(true)
  registerEvent("EventQuestUpdateNotify", "AcquireQuestDirect_Update")
end
function QuestDirect_ReSize()
  local scrX = getOriginScreenSizeX()
  local scrY = getOriginScreenSizeY()
  Panel_QuestDirect:SetPosX(scrX / 2 - Panel_QuestDirect:GetSizeX() / 2)
end
function AcquireQuestDirect_Update(isAccept, questNoRaw)
  ui._backGround:EraseAllEffect()
  ui._countingBG:SetShow(false)
  local questInfoWrapper = questList_getQuestInfo(questNoRaw)
  if nil ~= questInfoWrapper then
    if true == questInfoWrapper:isSpecialType() then
      return
    end
    if 11 == questInfoWrapper:getQuestType() then
      return
    end
    ui._questImg:SetShow(true)
    ui._backGround:SetShow(true)
    ui._questImg:ChangeTextureInfoName("new_ui_common_forlua/widget/acquire/Acquire_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(ui._questImg, 170, 66, 234, 130)
    ui._questImg:getBaseTexture():setUV(x1, y1, x2, y2)
    ui._questImg:setRenderTexture(ui._questImg:getBaseTexture())
    local msg = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTACQUIRE_NEWQUEST") .. " '" .. questInfoWrapper:getTitle() .. "'"
    if isGameTypeKorea() then
      msg = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTACQUIRE_NEWQUEST") .. " '" .. questInfoWrapper:getTitle() .. "'"
    else
      msg = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTACQUIRE_NEWQUEST") .. " <" .. questInfoWrapper:getTitle() .. ">"
    end
    chatting_sendMessage("", msg, CppEnums.ChatType.System)
    ui._text_QuestDirect:SetText(msg)
    ui._text_QuestDirect:SetFontColor(UI_color.C_FFEDE699)
    ui._text_QuestTitle:SetText("")
    ui._text_QuestTitle_2:SetText("")
    ui._text_QuestTitle:EraseAllEffect()
    ui._text_QuestTitle_2:EraseAllEffect()
    ui._text_QuestDemand:SetPosY(ui._text_QuestTitle:GetPosY() + ui._text_QuestTitle:GetTextSizeY())
    ui._text_QuestDemand:SetText("")
    ui._text_QuestDemand_2:SetText("")
    audioPostEvent_SystemUi(4, 0)
    _AudioPostEvent_SystemUiForXBOX(4, 0)
    ui._backGround:EraseAllEffect()
    ui._backGround:AddEffect("fUI_Light", false, 0, 0)
    ui._backGround:AddEffect("UI_QustAccept01", false, 0, -10)
    ui._backGround:AddEffect("UI_QustAccept02", false, 0, -10)
    local spanSize = ui._questImg:GetSpanSize()
    ui._questImg:SetSpanSize((-ui._questImg:GetSizeX() - ui._text_QuestDirect:GetTextSizeX()) / 2, spanSize.y)
    if false == isAccept then
      ui._questImg:SetShow(true)
      ui._backGround:SetShow(true)
      ui._questImg:ChangeTextureInfoName("new_ui_common_forlua/widget/acquire/Acquire_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(ui._questImg, 170, 1, 234, 65)
      ui._questImg:getBaseTexture():setUV(x1, y1, x2, y2)
      ui._questImg:setRenderTexture(ui._questImg:getBaseTexture())
      ui._text_QuestDirect:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTACQUIRE_COMPLETE"))
      ui._text_QuestDirect:SetFontColor(UI_color.C_FF00C0D7)
      local acceptMsg = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTACQUIRE_QUESTTITLE") .. " " .. questInfoWrapper:getTitle()
      ui._text_QuestTitle:SetText(acceptMsg)
      chatting_sendMessage("", acceptMsg, CppEnums.ChatType.System)
      ui._text_QuestDemand:SetText(" ")
      audioPostEvent_SystemUi(4, 2)
      _AudioPostEvent_SystemUiForXBOX(4, 2)
      ui._backGround:EraseAllEffect()
      ui._backGround:AddEffect("fUI_Light", false, 0, 0)
      ui._backGround:AddEffect("UI_QustComplete01", false, 0, 0)
      ui._backGround:AddEffect("UI_QustComplete02", false, 0, 0)
      ui._backGround:AddEffect("fUI_QuestComplete", false, 0, 0)
      local spanSize = ui._questImg:GetSpanSize()
      ui._questImg:SetSpanSize((-ui._questImg:GetSizeX() - ui._text_QuestDirect:GetTextSizeX()) / 2, spanSize.y)
    end
  end
  ui._backGround:SetSize(ui._backGround:GetSizeX(), ui._text_QuestDemand:GetPosY() + ui._text_QuestDemand:GetSizeY() - ui._backGround:GetPosY() + constValue.bgBottomGap + 10)
  AcquireQuestDirect_Start(8)
end
function QuestComplete_Effect()
  local bg_sizeX = ui._backGround:GetSizeX()
  local bg_sizeY = ui._backGround:GetSizeY()
  local bg_posX = ui._backGround:GetPosX()
  local bg_posY = ui._backGround:GetPosY()
  ui._countingBG:SetSize(500, 200)
  ui._countingBG:SetSpanSize(ui._countingBG:GetSpanSize().x, 10)
  ui._text_QuestDemand:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTACQUIRE_COUNTDONE"))
  ui._text_QuestDemand:SetPosY(ui._text_QuestTitle:GetTextSizeY() + ui._text_QuestTitle:GetPosY())
  ui._backEff:SetSize(bg_sizeX, bg_sizeY)
  ui._backEff:SetPosX(bg_posX)
  ui._backEff:SetPosY(bg_posY)
  audioPostEvent_SystemUi(4, 3)
  _AudioPostEvent_SystemUiForXBOX(4, 3)
  ui._backEff:EraseAllEffect()
  ui._backEff:AddEffect("UI_QustPerform01", false, 0, -5)
  ui._backEff:AddEffect("UI_QustPerform02", false, 0, -5)
  ui._backEff:AddEffect("fUI_Light", false, 0, 0)
  AcquireQuestDirect_Start(8)
end
function AcquireQuestDirect_UpdateQuestDemand(questData, demand, isComplete)
  ui._backGround:SetShow(false)
  ui._countingBG:SetShow(true)
  ui._questImg:SetShow(false)
  ui._text_QuestDirect:SetText("")
  ui._text_QuestTitle:SetText("")
  ui._text_QuestTitle_2:SetText(ToClient_getReplaceDialog(demand._desc))
  ui._text_QuestTitle_2:SetPosY(-70)
  ui._text_QuestDemand_2:SetPosY(ui._text_QuestTitle_2:GetTextSizeY() + ui._text_QuestTitle_2:GetPosY())
  if demand._currentCount < demand._destCount then
    audioPostEvent_SystemUi(4, 1)
    _AudioPostEvent_SystemUiForXBOX(4, 1)
    ui._countingBG:SetSize(500, 100)
    ui._countingBG:SetSpanSize(ui._countingBG:GetSpanSize().x, -70)
    ui._text_QuestTitle_2:AddEffect("fUI_Gauge_Blue", false, 0, 0)
    ui._text_QuestDemand:SetText("")
    local conditionCountMSg = demand._currentCount .. " / " .. demand._destCount
    chatting_sendMessage("", ToClient_getReplaceDialog(demand._desc) .. " : " .. conditionCountMSg, CppEnums.ChatType.System)
    ui._text_QuestDemand_2:SetText(conditionCountMSg)
    AcquireQuestDirect_Start(5)
    ui._text_QuestDemand_2:EraseAllEffect()
  else
    ui._text_QuestTitle_2:SetText("")
    ui._text_QuestDemand_2:SetText("")
    ui._text_QuestTitle:SetText(ToClient_getReplaceDialog(demand._desc))
    chatting_sendMessage("", PAGetStringParam1(Defines.StringSheet_GAME, "LUA_AQUIREMESSAGE_QUESTCOMPLETE", "desc", ToClient_getReplaceDialog(demand._desc)), CppEnums.ChatType.System)
    if isComplete then
      audioPostEvent_SystemUi(4, 2)
      _AudioPostEvent_SystemUiForXBOX(4, 2)
      ui._text_QuestDirect:SetFontColor(UI_color.C_FFB5FF6D)
      ui._text_QuestDirect:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTACQUIRE_ACCOMPLISHED"))
      QuestComplete_Effect()
    else
      audioPostEvent_SystemUi(4, 2)
      _AudioPostEvent_SystemUiForXBOX(4, 2)
      ui._text_QuestDirect:SetFontColor(UI_color.C_FFD8CABA)
      ui._text_QuestDirect:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTACQUIRE_PATIALACCOMPLISHED"))
      QuestComplete_Effect()
    end
  end
end
local questDataCache = {}
function AcquireDirect_QuestUpdate(questNoRaw)
  local count = questList_getCheckedProgressQuestCount()
  for index = 0, count - 1 do
    local questData = questList_getCheckedProgressQuestAt(index)
    local questKey = questData:getKey()
    local prevCache = questDataCache[questKey]
    if nil == prevCache then
      prevCache = {}
    end
    local currentCache = {}
    local demandCount = questData:getDemadCount()
    local diffIndex = -1
    local isComplete = true
    for demandIndex = 0, demandCount - 1 do
      local demand = questData:getDemandAt(demandIndex)
      currentCache[demandIndex] = demand._currentCount
      if currentCache[demandIndex] ~= prevCache[demandIndex] then
        diffIndex = demandIndex
      end
      if demand._currentCount ~= demand._destCount then
        isComplete = false
      end
    end
    questDataCache[questKey] = currentCache
    if questNoRaw == questKey and diffIndex ~= -1 then
      local demand = questData:getDemandAt(diffIndex)
      if false == questData:isSpecialType() and 11 ~= questData:getQuestType() then
        AcquireQuestDirect_UpdateQuestDemand(questData, demand, isComplete)
      end
    end
  end
end
registerEvent("updateProgressQuestList", "AcquireDirect_QuestUpdate")
function AcquireDirecteReShowUpdate()
end
function AcquireQuestDirect_Start(remainTime)
  Panel_QuestDirect:SetShow(true, false)
  Panel_QuestDirect:ResetVertexAni()
  Panel_QuestDirect:SetScaleChild(1, 1)
  local aniInfo = Panel_QuestDirect:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
  local aniInfo1 = Panel_QuestDirect:addColorAnimation(0.25, remainTime - 1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_QuestDirect:addColorAnimation(remainTime - 1, remainTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo2:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo2:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo2.IsChangeChild = true
end
init()
QuestDirect_ReSize()
function FromClient_eventCutsceneStop()
  if Panel_QuestDirect:isPlayAnimation() == false then
    ui._backGround:EraseAllEffect()
  end
end
registerEvent("onScreenResize", "QuestDirect_ReSize")
registerEvent("FromClient_eventCutsceneStop", "FromClient_eventCutsceneStop")
local _guildQuestName
local _prevCurrentCount = {}
function FromClient_AcquireAcceptGuildQuestDirectUpdate()
  if ToClient_isGuildQuestOtherServer() then
    return
  end
  if true == ToClient_GetMessageFilter(9) then
    return
  end
  if PaGlobal_TutorialManager:isDoingTutorial() then
    return
  end
  for index = 0, 4 do
    _prevCurrentCount[index] = 0
  end
  ui._backGround:EraseAllEffect()
  ui._countingBG:SetShow(false)
  ui._questImg:SetShow(true)
  ui._backGround:SetShow(true)
  ui._questImg:ChangeTextureInfoName("new_ui_common_forlua/widget/acquire/Acquire_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(ui._questImg, 170, 66, 234, 130)
  ui._questImg:getBaseTexture():setUV(x1, y1, x2, y2)
  ui._questImg:setRenderTexture(ui._questImg:getBaseTexture())
  _guildQuestName = ToClient_getCurrentGuildQuestName()
  local msg = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_NEWQUEST") .. " '" .. _guildQuestName .. "'"
  ui._text_QuestDirect:SetText(msg)
  ui._text_QuestDirect:SetFontColor(UI_color.C_FFEDE699)
  ui._text_QuestTitle:SetText(" ")
  ui._text_QuestTitle_2:SetText(" ")
  ui._text_QuestTitle_2:EraseAllEffect()
  ui._text_QuestDemand:SetTextMode(UI_TM.eTextMode_Limit_AutoWrap)
  ui._text_QuestDemand:SetPosY(ui._text_QuestTitle:GetPosY() + ui._text_QuestTitle:GetTextSizeY())
  ui._text_QuestDemand_2:SetTextMode(UI_TM.eTextMode_Limit_AutoWrap)
  ui._text_QuestDemand_2:SetPosY(ui._text_QuestTitle_2:GetPosY() + ui._text_QuestTitle_2:GetTextSizeY())
  ui._text_QuestDemand:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_DESC") .. " " .. ToClient_getCurrentGuildQuestDesc())
  ui._text_QuestDemand_2:SetText("")
  audioPostEvent_SystemUi(4, 0)
  ui._backGround:EraseAllEffect()
  ui._backGround:AddEffect("fUI_Light", false, 0, 0)
  ui._backGround:AddEffect("UI_QustAccept01", false, 0, 30)
  ui._backGround:AddEffect("UI_QustAccept02", false, 0, 30)
  local spanSize = ui._questImg:GetSpanSize()
  ui._questImg:SetSpanSize((-ui._questImg:GetSizeX() - ui._text_QuestDirect:GetTextSizeX()) / 2, spanSize.y)
  ui._backGround:SetSize(ui._backGround:GetSizeX(), ui._text_QuestDemand:GetPosY() + ui._text_QuestDemand:GetSizeY() - ui._backGround:GetPosY() + constValue.bgBottomGap)
  AcquireQuestDirect_Start(8)
end
function FromClient_AcquireComplateGuildQuestDirectUpdate()
  if true == ToClient_GetMessageFilter(9) then
    return
  end
  if PaGlobal_TutorialManager:isDoingTutorial() then
    return
  end
  ui._backGround:EraseAllEffect()
  ui._countingBG:SetShow(false)
  ui._questImg:SetShow(true)
  ui._backGround:SetShow(true)
  ui._questImg:ChangeTextureInfoName("new_ui_common_forlua/widget/acquire/Acquire_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(ui._questImg, 170, 1, 234, 65)
  ui._questImg:getBaseTexture():setUV(x1, y1, x2, y2)
  ui._questImg:setRenderTexture(ui._questImg:getBaseTexture())
  ui._text_QuestDirect:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_ACQUIRE_COMPLATE"))
  ui._text_QuestDirect:SetFontColor(UI_color.C_FF00C0D7)
  ui._text_QuestTitle:SetText("")
  ui._text_QuestTitle_2:SetText("")
  ui._text_QuestDemand:SetText(" ")
  ui._text_QuestDemand_2:SetText(" ")
  ui._text_QuestDemand:SetTextMode(UI_TM.eTextMode_Limit_AutoWrap)
  ui._text_QuestDemand:SetPosY(ui._text_QuestTitle:GetPosY() + ui._text_QuestTitle:GetTextSizeY())
  audioPostEvent_SystemUi(4, 3)
  ui._backGround:EraseAllEffect()
  ui._backGround:AddEffect("fUI_Light", false, 0, 0)
  ui._backGround:AddEffect("UI_QustComplete01", false, 0, 0)
  ui._backGround:AddEffect("UI_QustComplete02", false, 0, 0)
  ui._backGround:AddEffect("fUI_QuestComplete", false, 0, 0)
  local spanSize = ui._questImg:GetSpanSize()
  ui._questImg:SetSpanSize((-ui._questImg:GetSizeX() - ui._text_QuestDirect:GetTextSizeX()) / 2, spanSize.y)
  ui._backGround:SetSize(ui._backGround:GetSizeX(), ui._text_QuestDemand:GetPosY() + ui._text_QuestDemand:GetSizeY() - ui._backGround:GetPosY() + constValue.bgBottomGap)
  AcquireQuestDirect_Start(8)
end
function AcquireGuildQuestDemand(actorName, characterName, currentGuildQuestInfo, isComplete)
  ui._backGround:SetShow(false)
  ui._countingBG:SetShow(true)
  ui._questImg:SetShow(false)
  ui._text_QuestDirect:SetText("")
  ui._text_QuestTitle:SetText("")
  ui._text_QuestTitle_2:SetText(currentGuildQuestInfo._desc)
  ui._text_QuestTitle_2:SetPosY(-60)
  ui._text_QuestDemand:SetPosY(ui._text_QuestTitle:GetTextSizeY() + ui._text_QuestTitle:GetPosY())
  ui._text_QuestDemand_2:SetPosY(ui._text_QuestTitle_2:GetTextSizeY() + ui._text_QuestTitle_2:GetPosY())
  if currentGuildQuestInfo._currentCount < currentGuildQuestInfo._destCount then
    ui._countingBG:SetSize(500, 100)
    ui._text_QuestTitle:SetPosY(ui._text_QuestTitle_2:GetPosY())
    ui._countingBG:SetSpanSize(ui._countingBG:GetSpanSize().x, -70)
    ui._text_QuestTitle:AddEffect("fUI_Gauge_Blue", false, 0, 13)
    ui._text_QuestDemand:SetText("")
    local message = currentGuildQuestInfo._currentCount .. " / " .. currentGuildQuestInfo._destCount .. [[

<PAColor0xFFAAAAAA>]] .. actorName .. "(" .. characterName .. ")<PAOldColor>"
    local chat_message = currentGuildQuestInfo._desc .. " " .. currentGuildQuestInfo._currentCount .. " / " .. currentGuildQuestInfo._destCount .. " " .. PAGetStringParam2(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_25", "actorName", actorName, "characterName", characterName)
    ui._text_QuestDemand_2:SetTextMode(UI_TM.eTextMode_AutoWrap)
    ui._text_QuestDemand_2:SetText(message)
    chatting_sendMessage("", chat_message, CppEnums.ChatType.System)
    AcquireQuestDirect_Start(5)
    ui._text_QuestDemand_2:EraseAllEffect()
  else
    ui._text_QuestTitle_2:SetText("")
    ui._text_QuestDemand_2:SetText("")
    ui._text_QuestTitle:SetText(currentGuildQuestInfo._desc)
    if isComplete then
      audioPostEvent_SystemUi(4, 1)
      ui._text_QuestDirect:SetFontColor(UI_color.C_FFB5FF6D)
      ui._text_QuestDirect:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_ACQUIRE_ACCOMPLISHED"))
      QuestComplete_Effect()
    else
      audioPostEvent_SystemUi(4, 1)
      ui._text_QuestDirect:SetFontColor(UI_color.C_FFD8CABA)
      ui._text_QuestDirect:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_ACQUIRE_PATIALACCOMPLISHED"))
      QuestComplete_Effect()
    end
  end
end
function FromClient_AcquireGuildQuestDirectUpdate(actorName, characterName)
  if true == ToClient_GetMessageFilter(9) then
    return
  end
  if PaGlobal_TutorialManager:isDoingTutorial() then
    return
  end
  local milkBottle = UI.getChildControl(Panel_MiniGame_PowerControl, "Static_MilkBottom")
  if Panel_MiniGame_PowerControl:GetShow() then
    return
  end
  if true == ToClient_isProgressingGuildQuest() then
    local questConditionCount = ToClient_getCurrentGuildQuestConditionCount()
    local isComplete = true
    local diffIndex = -1
    if nil == _prevCurrentCount[0] then
      for index = 0, questConditionCount - 1 do
        local currentGuildQuestInfo = ToClient_getCurrentGuildQuestConditionAt(index)
        _prevCurrentCount[index] = currentGuildQuestInfo._currentCount
      end
    end
    for index = 0, questConditionCount - 1 do
      local currentGuildQuestInfo = ToClient_getCurrentGuildQuestConditionAt(index)
      if currentGuildQuestInfo._currentCount ~= currentGuildQuestInfo._destCount then
        isComplete = false
      else
        isComplete = true
      end
      if _prevCurrentCount[index] ~= currentGuildQuestInfo._currentCount then
        diffIndex = index
        _prevCurrentCount[index] = currentGuildQuestInfo._currentCount
      end
    end
    if -1 ~= diffIndex then
      local currentGuildQuestInfo = ToClient_getCurrentGuildQuestConditionAt(diffIndex)
      AcquireGuildQuestDemand(actorName, characterName, currentGuildQuestInfo, isComplete)
    end
  end
end
registerEvent("ResponseAcceptGuildQuest", "FromClient_AcquireAcceptGuildQuestDirectUpdate")
registerEvent("ResponseCompleteGuildQuest", "FromClient_AcquireComplateGuildQuestDirectUpdate")
registerEvent("ResponseUpdateGuildQuest", "FromClient_AcquireGuildQuestDirectUpdate")
