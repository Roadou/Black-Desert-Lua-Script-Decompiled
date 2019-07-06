local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
Panel_Window_GameTips:SetShow(false, false)
Panel_Window_GameTips:setGlassBackground(true)
Panel_Window_GameTips:setMaskingChild(true)
Panel_Window_GameTips:SetDragAll(true)
Panel_Window_GameTips:ActiveMouseEventEffect(true)
Panel_Window_GameTips:RegisterShowEventFunc(true, "Panel_GameTips_ShowAni()")
Panel_Window_GameTips:RegisterShowEventFunc(false, "Panel_GameTips_HideAni()")
function Panel_GameTips_ShowAni()
  UIAni.AlphaAnimation(1, Panel_Window_GameTips, 0, 0.15)
  local aniInfo1 = Panel_Window_GameTips:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.08)
  aniInfo1.AxisX = Panel_Window_GameTips:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_GameTips:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Window_GameTips:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.08)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_GameTips:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_GameTips:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_GameTips_HideAni()
  local aniInfo = UIAni.AlphaAnimation(0, Panel_Window_GameTips, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local msgCnt = 329
local gameTipsUIPool = {}
local gameTipsWindow = {
  closeX = UI.getChildControl(Panel_Window_GameTips, "Button_Win_Close"),
  helpBTN = UI.getChildControl(Panel_Window_GameTips, "Button_Help"),
  closeBTN = UI.getChildControl(Panel_Window_GameTips, "Button_Close"),
  list2 = UI.getChildControl(Panel_Window_GameTips, "List2_GamtipsList")
}
function GameTipsInit()
  gameTipsWindow.list2:getElementManager():clearKey()
  for key = 1, msgCnt do
    gameTipsWindow.list2:getElementManager():pushKey(toInt64(0, key))
  end
end
function GameTipsListControlCreate(content, key)
  local tipsBg = UI.getChildControl(content, "List2_TownList_Bg")
  local tipsDesc = UI.getChildControl(content, "List2_TownList_Desc")
  tipsDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local _key = Int64toInt32(key)
  tipsDesc:SetText(_key .. ". " .. PAGetString(Defines.StringSheet_GAME, "LUA_GAMETIPS_MESSAGE" .. _key))
end
function FGlobal_GameTipsShow()
  Panel_Window_GameTips:SetShow(true)
  audioPostEvent_SystemUi(1, 0)
  _AudioPostEvent_SystemUiForXBOX(1, 0)
  gameTipsWindow.list2:moveTopIndex()
end
function FGlobal_GameTipsHide()
  GameTipsHide()
end
function GameTipsHide()
  Panel_Window_GameTips:SetShow(false, true)
end
function gameTipsWindow:registEventHandler()
  self.closeBTN:addInputEvent("Mouse_LUp", "GameTipsHide()")
  self.closeX:addInputEvent("Mouse_LUp", "GameTipsHide()")
  self.helpBTN:addInputEvent("Mouse_LUp", "FGlobal_Panel_WebHelper_ShowToggle()")
  self.list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "GameTipsListControlCreate")
  self.list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
gameTipsWindow:registEventHandler()
GameTipsInit()
