MentalKnowledgeBase = {}
local defaultPos = float3(0, 0, 0)
local zOrder = 21
local ItemLineIdx = 1
local ItemLine = {}
local ItemLineEdgeIndex = {}
local ItemCircleIdx = 1
local ItemCircle = {}
local ItemPositionIdx = 1
local ItemPosition = {}
MentalKnowledgeBase.color = float4(1, 1, 1, 0.5)
MentalKnowledgeBase.circleSize = 10
MentalKnowledgeBase.circleWidth = 1
MentalKnowledgeBase.lineWidth = 1
MentalKnowledgeBase.usingEndArrow = false
MentalKnowledgeBase.arrowHeight = 10
MentalKnowledgeBase.arrowWidth = 1
MentalKnowledgeBase.arrowColor = float4(1, 1, 1, 0.5)
MentalKnowledgeBase.arrowLineWidth = 1
local circleRotation = function(circle, targetPos, rotation, circleWidth)
  if nil ~= circle then
    if nil ~= targetPos then
      circle._position = targetPos
    end
    circle._rotation.x = rotation.x
    circle._rotation.y = math.pi / 2 + rotation.y
    circle._rotation.z = 0
    local cameraDistance = distanceFromCamera(circle._position.x, circle._position.y, circle._position.z)
    local rate = (3000 - cameraDistance) / 3000
    if rate > 1 then
      rate = 1
    elseif rate < 0 then
      rate = 0
    end
    circle._lineWidth = 3 * rate * rate * circleWidth + 0.5
  end
end
function MentalKnowledgeBase.init()
  MentalKnowledgeBase.color = float4(1, 1, 1, 0.3)
  MentalKnowledgeBase.circleSize = 10
  MentalKnowledgeBase.circleWidth = 1
  MentalKnowledgeBase.lineWidth = 1
  MentalKnowledgeBase.usingEndArrow = false
  MentalKnowledgeBase.arrowHeight = 10
  MentalKnowledgeBase.arrowWidth = 1
  MentalKnowledgeBase.arrowColor = float4(1, 1, 1, 0.3)
  MentalKnowledgeBase.arrowLineWidth = 1
end
function MentalKnowledgeBase.InsertPosition(pos)
  local index = ItemPositionIdx
  ItemPosition[index] = float3(pos.x, pos.y, pos.z)
  ItemPositionIdx = index + 1
  return index
end
function MentalKnowledgeBase.getPosition(index)
  return ItemPosition[index]
end
function MentalKnowledgeBase.ClearPosition()
  ItemPosition = {}
  ItemPositionIdx = 1
end
function MentalKnowledgeBase.InsertCircle(targetPos, angle)
  local index = ItemCircleIdx
  local angleNoNil = angle
  if nil == angleNoNil then
    angleNoNil = 1
  end
  ItemCircle[index] = {
    color = MentalKnowledgeBase.color,
    circleSize = MentalKnowledgeBase.circleSize,
    circleWidth = MentalKnowledgeBase.circleWidth
  }
  ItemCircle[index].circleKey = insertArcLine("MentalGame", defaultPos, MentalKnowledgeBase.color, MentalKnowledgeBase.color, float3(MentalKnowledgeBase.circleSize, MentalKnowledgeBase.circleWidth, angleNoNil * 2 * math.pi), zOrder)
  circleRotation(getLine("MentalGame", ItemCircle[index].circleKey, zOrder), targetPos, getCameraYawPitchRoll(), MentalKnowledgeBase.circleWidth)
  ItemCircleIdx = index + 1
  return index
end
function MentalKnowledgeBase.getCircle(index)
  if nil == ItemCircle[index] then
    return nil
  end
  return getLine("MentalGame", ItemCircle[index].circleKey, zOrder)
end
function MentalKnowledgeBase.UpdateCircle(rotation)
  for _, value in pairs(ItemCircle) do
    local lineData = getLine("MentalGame", value.circleKey, zOrder)
    circleRotation(lineData, nil, rotation, value.circleWidth)
  end
end
function MentalKnowledgeBase.ClearCircle()
  for key, value in pairs(ItemCircle) do
    deleteLine("MentalGame", value.circleKey, zOrder)
  end
  ItemCircle = {}
  ItemCircleIdx = 1
end
local function CreateEndArrow(fromPos, toPos, ownerLineKey)
  local cameraView = Util.Math.AddVectorToVector(toPos, Util.Math.MulNumberToVector(fromPos, -1))
  local cameraUp = Util.Math.AddVectorToVector(getCameraPosition(), Util.Math.MulNumberToVector(toPos, -1))
  local cameraRight = Util.Math.calculateNormalVector(Util.Math.calculateCross(cameraUp, cameraView))
  local direction = Util.Math.calculateNormalVector(float3(cameraView.x, cameraView.y, cameraView.z))
  local ArrowStart = Util.Math.AddVectorToVector(toPos, Util.Math.MulNumberToVector(direction, -MentalKnowledgeBase.arrowHeight))
  local ArrowRight = Util.Math.AddVectorToVector(ArrowStart, Util.Math.MulNumberToVector(cameraRight, MentalKnowledgeBase.arrowWidth))
  local ArrowLeft = Util.Math.AddVectorToVector(ArrowStart, Util.Math.MulNumberToVector(cameraRight, -MentalKnowledgeBase.arrowWidth))
  ItemLine[ownerLineKey].arrow1 = MentalKnowledgeBase.InsertLine(ArrowRight, ArrowLeft, MentalKnowledgeBase.arrowColor, MentalKnowledgeBase.arrowLineWidth)
  ItemLine[ownerLineKey].arrow2 = MentalKnowledgeBase.InsertLine(toPos, ArrowLeft, MentalKnowledgeBase.arrowColor, MentalKnowledgeBase.arrowLineWidth)
  ItemLine[ownerLineKey].arrow3 = MentalKnowledgeBase.InsertLine(ArrowRight, toPos, MentalKnowledgeBase.arrowColor, MentalKnowledgeBase.arrowLineWidth)
end
function MentalKnowledgeBase.InsertLine(fromPos, toPos, color, width)
  local index = ItemLineIdx
  if nil == ItemLineEdgeIndex[index] then
    ItemLineEdgeIndex[index] = {}
  end
  ItemLine[index] = {
    lineWidth = width,
    usingEndArrow = MentalKnowledgeBase.usingEndArrow
  }
  ItemLine[index].lineKey = insertLine("MentalGame", fromPos, toPos, color, width, zOrder)
  ItemLineIdx = index + 1
  return index
end
function MentalKnowledgeBase.InsertLineByCircle(fromIdx, toIdx)
  if fromIdx > -1 and toIdx > -1 then
    local fromPos = MentalKnowledgeBase.getCircle(fromIdx)._position
    local toPos = MentalKnowledgeBase.getCircle(toIdx)._position
    if nil == fromPos or nil == toPos then
      return
    end
    local lineKey = MentalKnowledgeBase.InsertLine(fromPos, toPos, MentalKnowledgeBase.color, MentalKnowledgeBase.lineWidth)
    ItemLineEdgeIndex[lineKey] = {from = fromIdx, to = toIdx}
    if MentalKnowledgeBase.usingEndArrow then
      CreateEndArrow(fromPos, toPos, lineKey)
    end
  end
end
function MentalKnowledgeBase.UpdateLine(rotation)
  for ItemLineIdx, value in pairs(ItemLine) do
    local inputFrom = getLineBuffer("MentalGame", value.lineKey, zOrder)
    local direction = float3(0, 0, 0)
    if nil ~= ItemLineEdgeIndex[ItemLineIdx].to and ItemLineEdgeIndex[ItemLineIdx].from then
      local fromCircle = MentalKnowledgeBase.getCircle(ItemLineEdgeIndex[ItemLineIdx].from)
      local toCircle = MentalKnowledgeBase.getCircle(ItemLineEdgeIndex[ItemLineIdx].to)
      local fromCircleData = ItemCircle[ItemLineEdgeIndex[ItemLineIdx].from]
      local toCircleData = ItemCircle[ItemLineEdgeIndex[ItemLineIdx].to]
      if nil ~= fromCircle and nil ~= toCircle then
        local fromPos = fromCircle._position
        local toPos = toCircle._position
        local cameraView = Util.Math.AddVectorToVector(fromPos, Util.Math.MulNumberToVector(getCameraPosition(), -1))
        local distance = Util.Math.calculateLength(cameraView)
        cameraView = Util.Math.calculateNormalVector(cameraView)
        local cameraUp = float3(0, 1, 0)
        local cameraRight = Util.Math.calculateNormalVector(Util.Math.calculateCross(cameraUp, cameraView))
        cameraUp = Util.Math.calculateNormalVector(Util.Math.calculateCross(cameraView, cameraRight))
        direction.x = toPos.x - fromPos.x
        direction.y = toPos.y - fromPos.y
        direction.z = toPos.z - fromPos.z
        direction = Util.Math.calculateNormalVector(direction)
        local dotUp = Util.Math.calculateDot(direction, cameraUp)
        local dotRight = Util.Math.calculateDot(direction, cameraRight)
        local reNormal = Util.Math.calculateNormalVector(float3(dotUp, dotRight, 0))
        dotUp = reNormal.x
        dotRight = reNormal.y
        local upDir = float3(cameraUp.x * dotUp, cameraUp.y * dotUp, cameraUp.z * dotUp)
        local rightDir = float3(cameraRight.x * dotRight, cameraRight.y * dotRight, cameraRight.z * dotRight)
        local fromSum = float3(0, 0, 0)
        fromSum.x = fromPos.x + cameraUp.x * dotUp * fromCircleData.circleSize + cameraRight.x * dotRight * fromCircleData.circleSize
        fromSum.y = fromPos.y + cameraUp.y * dotUp * fromCircleData.circleSize + cameraRight.y * dotRight * fromCircleData.circleSize
        fromSum.z = fromPos.z + cameraUp.z * dotUp * fromCircleData.circleSize + cameraRight.z * dotRight * fromCircleData.circleSize
        inputFrom:set(0, fromSum)
        cameraView = Util.Math.calculateNormalVector(Util.Math.AddVectorToVector(toPos, Util.Math.MulNumberToVector(getCameraPosition(), -1)))
        distance = (distance + Util.Math.calculateLength(cameraView)) / 2
        cameraUp = float3(0, 1, 0)
        cameraRight = Util.Math.calculateNormalVector(Util.Math.calculateCross(cameraUp, cameraView))
        cameraUp = Util.Math.calculateNormalVector(Util.Math.calculateCross(cameraView, cameraRight))
        direction.x = toPos.x - fromPos.x
        direction.y = toPos.y - fromPos.y
        direction.z = toPos.z - fromPos.z
        direction = Util.Math.calculateNormalVector(direction)
        dotUp = Util.Math.calculateDot(direction, cameraUp)
        dotRight = Util.Math.calculateDot(direction, cameraRight)
        reNormal = Util.Math.calculateNormalVector(float3(dotUp, dotRight, 0))
        dotUp = reNormal.x
        dotRight = reNormal.y
        upDir = float3(cameraUp.x * dotUp, cameraUp.y * dotUp, cameraUp.z * dotUp)
        rightDir = float3(cameraRight.x * dotRight, cameraRight.y * dotRight, cameraRight.z * dotRight)
        local toSum = float3(0, 0, 0)
        toSum.x = toPos.x - cameraUp.x * dotUp * toCircleData.circleSize - cameraRight.x * dotRight * toCircleData.circleSize
        toSum.y = toPos.y - cameraUp.y * dotUp * toCircleData.circleSize - cameraRight.y * dotRight * toCircleData.circleSize
        toSum.z = toPos.z - cameraUp.z * dotUp * toCircleData.circleSize - cameraRight.z * dotRight * toCircleData.circleSize
        inputFrom:set(1, toSum)
        local calcDirection = Util.Math.calculateDirection(fromSum, toSum)
        local originalDirection = Util.Math.calculateDirection(fromPos, toPos)
        local fromSumProc = toScreenPosition(fromSum.x, fromSum.y, fromSum.z)
        local toSumProc = toScreenPosition(toSum.x, toSum.y, toSum.z)
        local fromPosProc = toScreenPosition(fromPos.x, fromPos.y, fromPos.z)
        local toPosProc = toScreenPosition(toPos.x, toPos.y, toPos.z)
        local calcDir = Util.Math.calculateDirection(fromSumProc, toSumProc)
        local originalDir = Util.Math.calculateDirection(fromPosProc, toPosProc)
        local lineData = getLine("MentalGame", ItemLine[ItemLineIdx].lineKey, zOrder)
        lineData._isRender = 0 < Util.Math.calculateDot(calcDir, originalDir)
        if value.usingEndArrow then
          local diffVector = Util.Math.AddVectorToVector(toSum, Util.Math.MulNumberToVector(toPos, -1))
          for idx = 1, 3 do
            local lineKey = ItemLine[value["arrow" .. tostring(idx)]].lineKey
            local lineBuffer = getLineBuffer("MentalGame", lineKey, zOrder)
            lineBuffer:set(0, Util.Math.AddVectorToVector(lineBuffer:get(0), diffVector))
            lineBuffer:set(1, Util.Math.AddVectorToVector(lineBuffer:get(1), diffVector))
          end
        end
      end
    end
  end
end
function MentalKnowledgeBase.ClearLine()
  for key, value in pairs(ItemLine) do
    deleteLine("MentalGame", value.lineKey, zOrder)
  end
  ItemLineEdgeIndex = {}
  ItemLine = {}
  ItemLineIdx = 1
end
function MentalKnowledgeBase.UpdateLineAndCircle()
  local rotation = getCameraYawPitchRoll()
  MentalKnowledgeBase.UpdateCircle(rotation)
  MentalKnowledgeBase.UpdateLine(rotation)
end
function MentalKnowledgeBase.ClearLineAndCircle()
  MentalKnowledgeBase.ClearCircle()
  MentalKnowledgeBase.ClearLine()
  MentalKnowledgeBase.ClearPosition()
end
