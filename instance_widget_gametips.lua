Instance_Widget_GameTips:ActiveMouseEventEffect(true)
Instance_Widget_GameTips:setGlassBackground(true)
Instance_Widget_GameTips:SetShow(true)
Instance_Widget_GameTipMask:setMaskingChild(true)
Instance_Widget_GameTipMask:SetShow(true)
Instance_Widget_GameTips:SetDragEnable(false)
local msgCount = 329
local MessageData = {
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_2"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_3"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_4"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_5"),
  [6] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_6"),
  [7] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_7"),
  [8] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_8"),
  [9] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_9"),
  [10] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_10"),
  [11] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_11"),
  [12] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_12"),
  [13] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_13"),
  [14] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_14"),
  [15] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_GAMETIPS_15")
}
local gameTips_Message = {
  UI.getChildControl(Instance_Widget_GameTipMask, "StaticText_GameTips_Content1"),
  UI.getChildControl(Instance_Widget_GameTipMask, "StaticText_GameTips_Content2"),
  UI.getChildControl(Instance_Widget_GameTipMask, "StaticText_GameTips_Content3")
}
gameTips_Message[1]:SetText(MessageData[1])
gameTips_Message[2]:SetText(MessageData[1])
gameTips_Message[3]:SetText(MessageData[1])
local gameTipsBG = UI.getChildControl(Instance_Widget_GameTips, "Static_GameTipsBG")
local elapsedTime = 0
local nowPlayingIndex = 1
local textIndex = 1
local const = {
  textChangeTime = 30,
  controlCount = #gameTips_Message,
  textOffset = 100,
  fixStartPosX = 100
}
function gameTip_init()
  for i = 1, #gameTips_Message do
    gameTips_Message[i]:SetIgnore(true)
  end
end
function gameTip_aniPlay(deltaTime)
  local firstControl = gameTips_Message[nowPlayingIndex]
  local posX = firstControl:GetPosX()
  posX = posX - const.fixStartPosX / 3 * deltaTime
  for index = 0, const.controlCount - 1 do
    local targetControl = gameTips_Message[(nowPlayingIndex + index - 1) % const.controlCount + 1]
    targetControl:SetPosX(posX)
    posX = posX + targetControl:GetTextSizeX() + const.textOffset
  end
  if 0 > firstControl:GetPosX() + firstControl:GetTextSizeX() then
    firstControl:SetText(MessageData[textIndex])
    nowPlayingIndex = nowPlayingIndex % const.controlCount + 1
  end
end
function PaGlobalFunc_GameTips_MessageSetting(num)
  MessageData[1] = MessageData[num]
end
function GameTips_MessageUpdate(deltaTime)
  if not Instance_Widget_GameTips:GetShow() then
    return
  end
  elapsedTime = elapsedTime + deltaTime
  if const.textChangeTime < elapsedTime then
    elapsedTime = elapsedTime - const.textChangeTime
    textIndex = textIndex % #MessageData + 1
  end
  gameTip_aniPlay(deltaTime)
end
function GameTips_Reposition()
  Instance_Widget_GameTips:SetPosX(4)
  Instance_Widget_GameTips:SetPosY(getScreenSizeY() - Instance_Widget_GameTips:GetSizeY() + 12)
  Instance_Widget_GameTipMask:SetPosX(30)
  Instance_Widget_GameTipMask:SetPosY(getScreenSizeY() - Instance_Widget_GameTipMask:GetSizeY() - 8)
end
function GameTips_Show()
  Instance_Widget_GameTips:SetShow(true)
  Instance_Widget_GameTipMask:SetShow(true)
end
function GameTips_Hide()
  Instance_Widget_GameTips:SetShow(false)
  Instance_Widget_GameTipMask:SetShow(false)
end
gameTip_init()
GameTips_Reposition()
registerEvent("onScreenResize", "GameTips_Reposition")
