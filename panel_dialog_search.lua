searchClearQuest = {}
function checkClearSearchQuest(npcCharacterKey)
  if nil == searchClearQuest[npcCharacterKey] then
    return false
  end
  local count = questList_getCheckedProgressQuestCount()
  for index = 0, count - 1 do
    local questData = questList_getCheckedProgressQuestAt(index)
    local result = questData:getDetectConditionByCharacterKey(npcCharacterKey)
    if true == result then
      return false
    end
  end
  return true
end
local var_UI = {
  panel = Panel_Dialog_Search,
  title = UI.getChildControl(Panel_Dialog_Search, "StaticText_Search_Title"),
  btn_left = UI.getChildControl(Panel_Dialog_Search, "Button_Arrow_Left"),
  btn_right = UI.getChildControl(Panel_Dialog_Search, "Button_Arrow_Right"),
  btn_top = UI.getChildControl(Panel_Dialog_Search, "Button_Arrow_Top"),
  btn_bottom = UI.getChildControl(Panel_Dialog_Search, "Button_Arrow_Bottom"),
  btn_detail = UI.getChildControl(Panel_Dialog_Search, "Button_Detail"),
  btn_ZoomIn = UI.getChildControl(Panel_Dialog_Search, "Button_ZoomIn"),
  btn_ZoomOut = UI.getChildControl(Panel_Dialog_Search, "Button_ZoomOut"),
  StaticText_Q = UI.getChildControl(Panel_Dialog_Search, "StaticText_Q"),
  StaticText_W = UI.getChildControl(Panel_Dialog_Search, "StaticText_W"),
  StaticText_E = UI.getChildControl(Panel_Dialog_Search, "StaticText_E"),
  StaticText_A = UI.getChildControl(Panel_Dialog_Search, "StaticText_A"),
  StaticText_S = UI.getChildControl(Panel_Dialog_Search, "StaticText_S"),
  StaticText_D = UI.getChildControl(Panel_Dialog_Search, "StaticText_D")
}
local variable = {
  isShow = false,
  directionIndex = 0,
  currentNpcCharacterKey = 0
}
local additionYaw = 0
local additionPitch = 0
local yawValue = 0.02
local ptichValue = 0.02
local moveCameraDistance = 1000
local findCameraDistance = 0
local findCameraAngle = 0
local moveAbleAngleUp = 60
local moveAbleAngleDown = -40
local isShowSearchObject = false
local searchState = {_isSearchMode = false}
function PaGlobalFunc_SearchMode_IsSearchMode()
  return searchState._isSearchMode
end
function searchView_Open()
  variable.currentNpcCharacterKey = dialog_getTalkNpcKey()
  if 0 == variable.currentNpcCharacterKey then
    return
  end
  if true == checkClearSearchQuest(variable.currentNpcCharacterKey) then
    return
  end
  searchClearQuest[variable.currentNpcCharacterKey] = nil
  searchState._isSearchMode = true
  if false == _ContentsGroup_RenewUI_SearchMode then
    Panel_Dialog_Search:SetShow(true)
  else
    PaGlobalFunc_ConsoleKeyGuide_SetPos()
  end
  isShowSearchObject = false
  setCutSceneCameraEditMode(true)
  openClientChangeScene(variable.currentNpcCharacterKey, 1)
  moveCameraDistance = search_initCameraDistance()
  findCameraDistance = search_conditionDistance()
  findCameraAngle = search_conditionAngle()
  moveAbleAngleUp = search_getMoveAbleAngleUp()
  moveAbleAngleDown = search_getMoveAbleAngleDown()
  if true == _ContentsGroup_RenewUI_SearchMode then
    ToClient_padSnapResetControl()
    PaGlobalFunc_ConsoleKeyGuide_SetGuide(0)
  end
end
function searchView_Close()
  searchState._isSearchMode = false
  if false == _ContentsGroup_RenewUI_SearchMode then
    Panel_Dialog_Search:SetShow(false)
  else
    PaGlobalFunc_ConsoleKeyGuide_SetState(nil)
    PaGlobalFunc_ConsoleKeyGuide_SetPos()
  end
  additionYaw = 0
  search_additionYaw2(additionYaw)
  additionPitch = 0
  moveAbleAngleUp = 60
  moveAbleAngleDown = -40
  search_additionPitch2(additionPitch)
  setCutSceneCameraEditMode(false)
  if true == _ContentsGroup_RenewUI_SearchMode then
    ToClient_padSnapResetControl()
    PaGlobalFunc_ConsoleKeyGuide_PopGuide()
  end
end
function searchView_ScreenResize()
  var_UI.panel:SetSize(getScreenSizeX(), getScreenSizeY())
  for _, v in pairs(var_UI) do
    v:ComputePos()
  end
end
local function check_searchObject()
  if checkClearSearchQuest(variable.currentNpcCharacterKey) then
    return
  end
  if findCameraDistance < moveCameraDistance then
    if true == isShowSearchObject then
      isShowSearchObject = false
      showSceneCharacter(1, false)
    end
    return
  end
  local curCameraPosition = getCameraPosition()
  local objectPos = getSceneCharacterSpawnPosition(1)
  local objectLookPos = search_getObjectLookPos()
  local objectToDir = Util.Math.calculateDirection(objectPos, objectLookPos)
  local cameraToObjectDir = Util.Math.calculateDirection(objectPos, curCameraPosition)
  local calcDot = Util.Math.calculateDot(cameraToObjectDir, objectToDir)
  local angle = math.acos(calcDot)
  local toDegree = angle * 180 / math.pi
  if toDegree < findCameraAngle then
    if false == isShowSearchObject then
      showSceneCharacter(1, true)
      isShowSearchObject = true
      if false == checkClearSearchQuest(variable.currentNpcCharacterKey) then
        searchClearQuest[variable.currentNpcCharacterKey] = true
        click_DialogSearchObject()
        ReqeustDialog_retryTalk()
        searchView_Close()
      end
    end
  elseif true == isShowSearchObject then
    isShowSearchObject = false
    showSceneCharacter(1, false)
  end
end
local isMoveAbleAngle = function()
  local curCameraPosition = getCameraPosition()
  local objectPos = getSceneCharacterSpawnPosition(1)
  local objectLookPos = search_getObjectLookPos()
  local noYObjectPos = float3(objectPos.x, 0, objectPos.z)
  local noYCurCameraPos = float3(curCameraPosition.x, 0, curCameraPosition.z)
  local noYObjectToCameraDir = Util.Math.calculateDirection(noYObjectPos, noYCurCameraPos)
  local ObjectTocameraDir = Util.Math.calculateDirection(objectPos, curCameraPosition)
  local normalaCalc = Util.Math.calculateDot(ObjectTocameraDir, noYObjectToCameraDir)
  local normalAngle = math.acos(normalaCalc)
  local normalToDegree = normalAngle * 180 / math.pi
  if curCameraPosition.y < objectPos.y then
    normalToDegree = -normalToDegree
  end
  return normalToDegree
end
function searchView_PushLeft()
  variable.directionIndex = 0
  local normalToDegree = isMoveAbleAngle()
  additionYaw = additionYaw + ptichValue
  search_additionYaw2(additionYaw)
  check_searchObject()
end
function searchView_PushTop()
  variable.directionIndex = 1
  local normalToDegree = isMoveAbleAngle()
  if normalToDegree < moveAbleAngleUp then
    if normalToDegree > moveAbleAngleUp then
      return
    end
    additionPitch = additionPitch - yawValue
    search_additionPitch2(additionPitch)
  end
  check_searchObject()
end
function searchView_PushRight()
  variable.directionIndex = 2
  local normalToDegree = isMoveAbleAngle()
  additionYaw = additionYaw - ptichValue
  search_additionYaw2(additionYaw)
  check_searchObject()
end
function searchView_PushBottom()
  variable.directionIndex = 3
  local normalToDegree = isMoveAbleAngle()
  if normalToDegree > moveAbleAngleDown + 5 then
    if normalToDegree < moveAbleAngleDown then
      return
    end
    additionPitch = additionPitch + yawValue
    search_additionPitch2(additionPitch)
  end
  check_searchObject()
end
function searchView_Detail()
  moveCameraDistance = moveCameraDistance - 10
  search_LookAtPosDistance(moveCameraDistance)
  check_searchObject()
end
function searchView_ZoomIn()
  if moveCameraDistance > 300 then
    moveCameraDistance = moveCameraDistance - 10
    search_LookAtPosDistance(moveCameraDistance)
  end
  check_searchObject()
end
function searchView_ZoomOut()
  if moveCameraDistance < 1200 then
    moveCameraDistance = moveCameraDistance + 10
    search_LookAtPosDistance(moveCameraDistance)
  end
  check_searchObject()
end
function searchView_CheckDistance()
  if moveCameraDistance < 1200 then
    var_UI.btn_ZoomOut:SetShow(true)
    var_UI.StaticText_E:SetShow(true)
  else
    var_UI.btn_ZoomOut:SetShow(false)
    var_UI.StaticText_E:SetShow(false)
  end
  if moveCameraDistance > 300 then
    var_UI.btn_ZoomIn:SetShow(true)
    var_UI.StaticText_Q:SetShow(true)
  else
    var_UI.btn_ZoomIn:SetShow(false)
    var_UI.StaticText_Q:SetShow(false)
  end
end
function searchViewMode_ShowToggle(isShow)
  if nil == isShow then
    variable.isShow = not variable.isShow
  else
    variable.isShow = isShow
  end
  if variable.isShow then
    var_UI.panel:SetShow(true)
  end
end
local function Alpha_Rate_Setting(alpha)
  for k, v in pairs(var_UI) do
    v:SetAlpha(alpha)
    if k ~= "panel" then
      v:SetFontAlpha(alpha)
    end
  end
end
local function initialize()
  Panel_Dialog_Search:SetShow(false, false)
  searchState._isSearchMode = false
  searchView_ScreenResize()
  registerEvent("onScreenResize", "searchView_ScreenResize")
  registerEvent("EventQuestSearch", "searchView_Open")
  var_UI.btn_detail:addInputEvent("Mouse_LPress", "searchView_Detail()")
  var_UI.btn_left:addInputEvent("Mouse_LPress", "searchView_PushLeft()")
  var_UI.btn_right:addInputEvent("Mouse_LPress", "searchView_PushRight()")
  var_UI.btn_top:addInputEvent("Mouse_LPress", "searchView_PushTop()")
  var_UI.btn_bottom:addInputEvent("Mouse_LPress", "searchView_PushBottom()")
  var_UI.btn_ZoomIn:addInputEvent("Mouse_LPress", "searchView_ZoomIn()")
  var_UI.btn_ZoomOut:addInputEvent("Mouse_LPress", "searchView_ZoomOut()")
end
initialize()
