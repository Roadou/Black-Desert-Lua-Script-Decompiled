function Auto_MouseMove(posX, posY)
  if posX < 0 or posY < 0 then
    return true
  end
  local updateMoveSize = 10
  local nowX = getMousePosX()
  local nowY = getMousePosY()
  if updateMoveSize < math.abs(nowX - posX) then
    if posX > nowX then
      nowX = nowX + updateMoveSize
    elseif posX < nowX then
      nowX = nowX - updateMoveSize
    end
  end
  if updateMoveSize < math.abs(nowY - posY) then
    if posY > nowY then
      nowY = nowY + updateMoveSize
    elseif posY < nowY then
      nowY = nowY - updateMoveSize
    end
  end
  ToClient_setMousePosition(nowX, nowY)
  if updateMoveSize >= math.abs(nowX - posX) and updateMoveSize >= math.abs(nowY - posY) then
    return false
  end
  return true
end
function Auto_IsPlayerInsideQuestArea(uiQuestInfo)
  local checkCount = 0
  local selfPlayer = getSelfPlayer():get()
  local positionList = Auto_GetTargetQuestArea(uiQuestInfo)
  local selfPos = float3(selfPlayer:getPositionX(), selfPlayer:getPositionY(), selfPlayer:getPositionZ())
  for index, value in pairs(positionList) do
    local valuePos = float3(value._position.x, value._position.y, value._position.z)
    local distance = Util.Math.calculateDistance(valuePos, selfPos)
    if distance < value._radius then
      return 0
    end
    checkCount = checkCount + 1
  end
  if checkCount == 0 then
    return -2
  end
  return -1
end
function Auto_IsMonsterInsideQuestArea(uiQuestInfo)
  local checkCount = 0
  local selfPlayer = getSelfPlayer():get()
  local positionList = Auto_GetTargetQuestArea(uiQuestInfo)
  for index, value in pairs(positionList) do
    if true == findNearQuestMonster(Auto_GetPlayerPos_Float3(), value._radius) then
      return 0
    end
    checkCount = checkCount + 1
  end
  if checkCount == 0 then
    return -2
  end
  return -1
end
function Auto_GetTargetQuestArea(uiQuestInfo)
  local selfPlayer = getSelfPlayer():get()
  local questPosCount = uiQuestInfo:getQuestPositionCount()
  local positionList = {}
  local naviMovePathIndex = selfPlayer:getNavigationMovePathIndex()
  for questPositionIndex = 0, questPosCount - 1 do
    local questPosInfo = uiQuestInfo:getQuestPositionAt(questPositionIndex)
    local posX = questPosInfo._position.x
    local posY = questPosInfo._position.y
    local posZ = questPosInfo._position.z
    positionList[questPositionIndex] = {}
    positionList[questPositionIndex]._radius = questPosInfo._radius
    positionList[questPositionIndex]._startRate = totalLength
    positionList[questPositionIndex]._position = questPosInfo._position
  end
  return positionList
end
function Auto_GetPlayerPos_Float3()
  local selfPlayer = getSelfPlayer():get()
  local pos = float3(selfPlayer:getPositionX(), selfPlayer:getPositionY(), selfPlayer:getPositionZ())
  return pos
end
function Auto_FindNearQuestMonster()
  return findNearQuestMonster(Auto_GetPlayerPos_Float3(), 4000)
end
