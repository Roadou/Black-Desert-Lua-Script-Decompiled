Util = {}
local _math_floor = math.floor
local _math_sin = math.sin
local _math_cos = math.cos
local _math_pi = math.pi
local _math_sqrt = math.sqrt
local _math_atan2 = math.atan2
local function _time_Formatting(second)
  local formatter = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND"),
    PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE"),
    PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR"),
    PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY")
  }
  if second == 0 then
    return tostring(0) .. formatter[0]
  end
  local timeVal = {}
  timeVal[0] = second
  timeVal[1] = _math_floor(timeVal[0] / 60)
  timeVal[0] = timeVal[0] - timeVal[1] * 60
  timeVal[2] = _math_floor(timeVal[1] / 60)
  timeVal[1] = timeVal[1] - timeVal[2] * 60
  timeVal[3] = _math_floor(timeVal[2] / 24)
  timeVal[2] = timeVal[2] - timeVal[3] * 24
  local resultString = ""
  for i = 0, 3 do
    if 0 < string.len(resultString) then
      resultString = " " .. resultString
    end
    if timeVal[i] > 0 then
      resultString = tostring(timeVal[i]) .. formatter[i] .. resultString
    end
  end
  return resultString
end
local function _time_Formatting_Minute(second)
  local formatter = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND"),
    PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE"),
    PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR"),
    PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY")
  }
  if second < 60 then
    return " 0" .. formatter[1]
  end
  local timeVal = {}
  timeVal[0] = second
  timeVal[1] = _math_floor(timeVal[0] / 60)
  timeVal[0] = timeVal[0] - timeVal[1] * 60
  timeVal[2] = _math_floor(timeVal[1] / 60)
  timeVal[1] = timeVal[1] - timeVal[2] * 60
  timeVal[3] = _math_floor(timeVal[2] / 24)
  timeVal[2] = timeVal[2] - timeVal[3] * 24
  local resultString = ""
  for i = 1, 3 do
    if 0 < string.len(resultString) then
      resultString = " " .. resultString
    end
    if timeVal[i] > 0 then
      resultString = tostring(timeVal[i]) .. formatter[i] .. resultString
    end
  end
  return resultString
end
local u64_Zero = Defines.u64_const.u64_0
local u64_1000 = Defines.u64_const.u64_1000
local u64_Hour = toUint64(0, 3600)
local u64_Minute = toUint64(0, 60)
local function _time_Formatting_ShowTop(second_u64)
  if second_u64 > u64_Hour * toInt64(0, 2) then
    local recalc_time = second_u64 / u64_Hour
    local strHour = string.format("%d", Int64toInt32(recalc_time))
    return PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_HOUR", "time_hour", strHour)
  elseif second_u64 > u64_Minute then
    local recalc_time = second_u64 / u64_Minute
    local strMinute = string.format("%d", Int64toInt32(recalc_time))
    return PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", strMinute)
  else
    local recalc_time = second_u64
    local strSecond = string.format("%d", Int64toInt32(recalc_time))
    return PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_SECOND", "time_second", strSecond)
  end
end
local function _time_GameTimeFormatting(inGameMinute)
  local clockMinute = inGameMinute % 60
  local clockHour = _math_floor(inGameMinute / 60)
  local calcMinute = "00"
  if clockMinute < 10 then
    calcMinute = "0" .. clockMinute
  else
    calcMinute = "" .. clockMinute
  end
  local calcHour = ""
  if clockHour < 12 or clockHour == 24 then
    calcHour = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_TIME_MORNING") .. " "
  else
    calcHour = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_TIME_AFTERNOON") .. " "
  end
  if clockHour > 12 then
    clockHour = clockHour - 12
  end
  calcHour = calcHour .. tostring(clockHour) .. " : " .. calcMinute
  return calcHour
end
Util.Time = {
  timeFormatting = _time_Formatting,
  timeFormatting_Minute = _time_Formatting_Minute,
  inGameTimeFormatting = _time_GameTimeFormatting,
  inGameTimeFormattingTop = _time_Formatting_ShowTop
}
local _math_calculateCross = function(lho, rho)
  local v = {}
  return float3(lho.y * rho.z - lho.z * rho.y, lho.z * rho.x - lho.x * rho.z, lho.x * rho.y - lho.y * rho.x)
end
local _math_calculateDot = function(lho, rho)
  return lho.x * rho.x + lho.y * rho.y + lho.z * rho.z
end
local function _math_calculateLength(vector)
  return _math_sqrt(_math_calculateDot(vector, vector))
end
local function _math_calculateDistance(from, to)
  return _math_calculateLength(float3(from.x - to.x, from.y - to.y, from.z - to.z))
end
local function _math_calculateNormalVector(vector)
  local len = _math_calculateLength(vector)
  return float3(vector.x / len, vector.y / len, vector.z / len)
end
local function _math_calculateSpinVector(axis, radian)
  local axisCorss = _math_calculateCross({
    x = 0,
    y = 1,
    z = 0
  }, axis)
  local axisUp = _math_calculateCross(axisCorss, axis)
  return _math_calculateNormalVector(float3(axisCorss.x * -_math_cos(radian) + axisUp.x * -_math_sin(radian), axisCorss.y * -_math_cos(radian) + axisUp.y * -_math_sin(radian), axisCorss.z * -_math_cos(radian) + axisUp.z * -_math_sin(radian)))
end
local _math_lerp = function(from, to, factor)
  return from * (1 - factor) + to * factor
end
local function _math_lerpVector(from, to, factor)
  return float3(_math_lerp(from.x, to.x, factor), _math_lerp(from.y, to.y, factor), _math_lerp(from.z, to.z, factor))
end
local function _math_calculateDirection(from, to)
  return _math_calculateNormalVector(float3(to.x - from.x, to.y - from.y, to.z - from.z))
end
local function _math_convertRotationToDirection(radian)
  return {
    x = -_math_sin(radian),
    y = 0,
    z = -_math_cos(radian)
  }
end
local function _math_convertDirectionToRotation(dir)
  return (_math_atan2(-dir.x, -dir.z))
end
local function _math_radianFix(radian)
  local fixRadian = radian
  if fixRadian < 0 then
    local nDivide = _math_floor(-fixRadian / (_math_pi * 2)) + 1
    fixRadian = fixRadian + nDivide * _math_pi * 2
  else
    local nDivide = _math_floor(fixRadian / (_math_pi * 2)) + 1
    fixRadian = fixRadian - nDivide * _math_pi * 2
  end
  return fixRadian
end
local function _math_calculateSinCurve(startPoint, endPoint, offset, height, rotate, lerpFactor)
  local SunHeight = _math_sin(lerpFactor * _math_pi)
  local resultPoint = float3(0, 0, 0)
  resultPoint.x = _math_lerp(startPoint.x, endPoint.x, lerpFactor)
  resultPoint.y = _math_lerp(startPoint.y, endPoint.y, lerpFactor)
  resultPoint.z = _math_lerp(startPoint.z, endPoint.z, lerpFactor)
  local spinAxis = _math_calculateDirection(endPoint, startPoint)
  spinAxis = _math_calculateSpinVector(spinAxis, _math_pi * rotate)
  resultPoint.x = resultPoint.x + offset.x + spinAxis.x * SunHeight * height
  resultPoint.y = resultPoint.y + offset.y + spinAxis.y * SunHeight * height
  resultPoint.z = resultPoint.z + offset.z + spinAxis.z * SunHeight * height
  return resultPoint
end
local _math_AddVectorToVector = function(lho, rho)
  return float3(lho.x + rho.x, lho.y + rho.y, lho.z + rho.z)
end
local _math_AddNumberToVector = function(lho, rho)
  return float3(lho.x + rho, lho.y + rho, lho.z + rho)
end
local _math_MulNumberToVector = function(lho, rho)
  return float3(lho.x * rho, lho.y * rho, lho.z * rho)
end
local function _math_calculateSinCurveList(startPoint, endPoint, offset, height, rotate, lerpCount)
  local spinAxis = _math_calculateDirection(endPoint, startPoint)
  spinAxis = _math_calculateSpinVector(spinAxis, _math_pi * rotate)
  local resultPointList = {}
  local lerpFactor
  for i = 0, lerpCount do
    lerpFactor = i / lerpCount
    resultPointList[i] = _math_AddVectorToVector(_math_AddVectorToVector(offset, _math_lerpVector(startPoint, endPoint, lerpFactor)), _math_MulNumberToVector(spinAxis, _math_sin(lerpFactor * _math_pi) * height))
  end
  return resultPointList
end
Util.Math = {
  calculateCross = _math_calculateCross,
  calculateDot = _math_calculateDot,
  calculateLength = _math_calculateLength,
  calculateDistance = _math_calculateDistance,
  calculateNormalVector = _math_calculateNormalVector,
  calculateSpinVector = _math_calculateSpinVector,
  Lerp = _math_lerp,
  LerpVector = _math_lerpVector,
  calculateDirection = _math_calculateDirection,
  convertRotationToDirection = _math_convertRotationToDirection,
  convertDirectionToRotation = _math_convertDirectionToRotation,
  radianFix = _math_radianFix,
  calculateSinCurve = _math_calculateSinCurve,
  AddVectorToVector = _math_AddVectorToVector,
  AddNumberToVector = _math_AddNumberToVector,
  MulNumberToVector = _math_MulNumberToVector,
  calculateSinCurveList = _math_calculateSinCurveList
}
local _table_sizeofDictionary = function(dictionary)
  local size = 0
  for key, values in pairs(dictionary) do
    size = size + 1
  end
  return size
end
local _table_isEmptyDictionary = function(dictionary)
  for key, values in pairs(dictionary) do
    return false
  end
  return true
end
local _table_fill = function(_table, _start, _end, _value)
  for ii = _start, _end do
    _table[ii] = _value
  end
end
Util.Table = {
  sizeofDictionary = _table_sizeofDictionary,
  isEmptyDictionary = _table_isEmptyDictionary,
  fill = _table_fill
}
Array = {}
Array.__index = Array
function Array.new()
  local arr = {}
  setmetatable(arr, Array)
  return arr
end
function Array:resize(_size, _value)
  if _size > #self then
    _table_fill(self, #self + 1, _size, _value)
  elseif _size < #self then
    _table_fill(self, _size + 1, #self, nil)
  end
end
function Array:fill(from, to, iter)
  local ii = 1
  iter = iter or 1
  for value = from, to, iter do
    self[ii] = value
    ii = ii + 1
  end
end
function Array:printi(f)
  f = f or print
  for k, v in ipairs(self) do
    f(v)
  end
end
function Array:length()
  return #self
end
function Array:push_back(msg)
  self[self:length() + 1] = msg
end
function Array:pop_back()
  local length = self:length()
  local v = self[length]
  self[length] = nil
  return v
end
function Array:pop_front()
  if 0 < self:length() then
    local tmp, _length
    tmp = self[1]
    _length = self:length()
    for ii = 2, _length do
      self[ii - 1] = self[ii]
    end
    self[_length] = nil
    return tmp
  end
  return
end
function Array:toString(deliminator)
  deliminator = deliminator or "\n"
  local tmpStr = ""
  for k, v in ipairs(self) do
    tmpStr = tmpStr .. v .. deliminator
  end
  return tmpStr
end
function Array:quicksort(f)
  if "function" ~= type(f) then
    return
  end
  self.compFunc = f
  self:_quicksort(1, #self)
  self.compFunc = nil
end
function Array:_quicksort(is, ie)
  local mid = self:_sortPartition(is, ie)
  if is < mid then
    self:_quicksort(is, mid - 1)
  end
  if ie > mid then
    self:_quicksort(mid + 1, ie)
  end
end
function Array:_sortPartition(is, ie)
  local ir = _math_floor((is + ie) / 2)
  self[ir], self[ie] = self[ie], self[ir]
  local i, j = is - 1, is
  while ie > j do
    if 0 < self.compFunc(self[j], self[ie]) then
      i = i + 1
      self[i], self[j] = self[j], self[i]
    end
    j = j + 1
  end
  self[i + 1], self[ie] = self[ie], self[i + 1]
  return i + 1
end
local __string_find = string.find
local __string_sub = string.sub
local __string_len = string.len
function string.split(str, pattern)
  local pattern_length = __string_len(pattern)
  local str_length = __string_len(str)
  if pattern_length <= 0 or pattern_length > str_length then
    return {str}
  end
  local fStart, fEnd
  local index = 1
  local ii = 1
  local res = {}
  while true do
    if str_length < index then
      break
    end
    fStart, fEnd = __string_find(str, pattern, index, true)
    if nil == fStart then
      res[ii] = __string_sub(str, index, str_length)
      break
    end
    res[ii] = __string_sub(str, index, fStart - 1)
    index = fEnd + 1
    ii = ii + 1
  end
  return res
end
function string.wlen(str)
  local len = string.len(str)
  local strwLen = 1
  local retVal = 0
  local byteVal = ""
  while len >= strwLen do
    byteVal = string.byte(str, strwLen)
    if byteVal >= 128 then
      strwLen = strwLen + 2
    else
      strwLen = strwLen + 1
    end
    retVal = retVal + 1
  end
  return retVal
end
function GlobalExitGameClient()
  exitGameClient(true)
end
function converStringFromLeftDateTime(s64_datetime)
  local leftDate = getLeftSecond_TTime64(s64_datetime)
  return convertStringFromDatetime(leftDate)
end
function convertStringFromDatetime(s64_datetime)
  local s64_dayCycle = toInt64(0, 86400)
  local s64_hourCycle = toInt64(0, 3600)
  local s64_minuteCycle = toInt64(0, 60)
  local s64_day = s64_datetime / s64_dayCycle
  local s64_hour = (s64_datetime - s64_dayCycle * s64_day) / s64_hourCycle
  local s64_minute = (s64_datetime - s64_dayCycle * s64_day - s64_hourCycle * s64_hour) / s64_minuteCycle
  local s64_Second = s64_datetime - s64_dayCycle * s64_day - s64_hourCycle * s64_hour - s64_minuteCycle * s64_minute
  local strDate = ""
  if s64_day > Defines.s64_const.s64_0 and s64_hour > Defines.s64_const.s64_0 then
    strDate = tostring(s64_day) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY") .. tostring(s64_hour) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR")
  elseif s64_day > Defines.s64_const.s64_0 then
    strDate = tostring(s64_day) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY")
  elseif s64_hour > Defines.s64_const.s64_0 then
    strDate = tostring(s64_hour) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR") .. tostring(s64_minute) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE")
  elseif s64_minute > Defines.s64_const.s64_0 then
    strDate = tostring(s64_minute) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE") .. tostring(s64_Second) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND")
  elseif s64_Second >= Defines.s64_const.s64_0 then
    strDate = tostring(s64_Second) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND")
  else
    strDate = ""
  end
  return strDate
end
function convertStringFromDatetimeForSkillTooltip(datetime)
  local s64_dayCycle = 86400
  local s64_hourCycle = 3600
  local s64_minuteCycle = 60
  local s64_day = math.floor(datetime / s64_dayCycle)
  local s64_hour = math.floor((datetime - s64_dayCycle * s64_day) / s64_hourCycle)
  local s64_minute = math.floor((datetime - s64_dayCycle * s64_day - s64_hourCycle * s64_hour) / s64_minuteCycle)
  local s64_Second = datetime - s64_dayCycle * s64_day - s64_hourCycle * s64_hour - s64_minuteCycle * s64_minute
  local strDate = ""
  if s64_day > 0 and s64_hour > 0 then
    strDate = tostring(s64_day) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY") .. tostring(s64_hour) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR")
  elseif s64_day > 0 then
    strDate = tostring(s64_day) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY")
  elseif s64_hour > 0 then
    strDate = tostring(s64_hour) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR") .. tostring(s64_minute) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE")
  elseif s64_minute > 0 then
    strDate = tostring(s64_minute) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE") .. tostring(s64_Second) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND")
  elseif s64_Second >= 0 then
    strDate = tostring(s64_Second) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND")
  else
    strDate = ""
  end
  return strDate
end
function calculateDayFromDateDay(s64_datetime)
  local s64_dayCycle = toInt64(0, 86400)
  local s64_day = s64_datetime / s64_dayCycle
  return s64_day
end
function convertStringFromDatetimeOverHour(s64_datetime)
  local s64_dayCycle = toInt64(0, 86400)
  local s64_hourCycle = toInt64(0, 3600)
  local s64_day = s64_datetime / s64_dayCycle
  local s64_hour = (s64_datetime - s64_dayCycle * s64_day) / s64_hourCycle
  local strDate = ""
  if s64_day > Defines.s64_const.s64_0 then
    strDate = tostring(s64_day) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY")
  elseif s64_hour > Defines.s64_const.s64_0 then
    strDate = tostring(s64_hour) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR")
  else
    strDate = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR_IN")
  end
  return strDate
end
function convertStringFromDatetimeOverHourForFriends(s64_datetime)
  local s64_dayCycle = toInt64(0, 86400)
  local s64_hourCycle = toInt64(0, 3600)
  local s64_day = s64_datetime / s64_dayCycle
  local s64_hour = (s64_datetime - s64_dayCycle * s64_day) / s64_hourCycle
  local strDate = ""
  if s64_day > Defines.s64_const.s64_0 then
    strDate = tostring(s64_day) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY")
  elseif s64_hour <= toInt64(0, 24) then
    strDate = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_TODAY")
  end
  return strDate
end
function convertSecondsToClockTime(seconds)
  local clockTime = ""
  local clockHours = math.floor(seconds / 3600)
  local clockMinutes = math.floor(seconds % 3600 / 60)
  local clockSeconds = seconds % 60
  if clockHours > 0 then
    if clockHours < 10 then
      clockTime = clockTime .. "0" .. tostring(clockHours)
    else
      clockTime = clockTime .. tostring(clockHours)
    end
    clockTime = clockTime .. ":"
  end
  if clockMinutes < 0 then
    clockMinutes = 0
  end
  if clockMinutes < 10 then
    clockTime = clockTime .. "0" .. tostring(clockMinutes)
  else
    clockTime = clockTime .. tostring(clockMinutes)
  end
  clockTime = clockTime .. ":"
  if clockSeconds < 0 then
    clockSeconds = 0
  end
  if clockSeconds < 10 then
    clockTime = clockTime .. "0" .. tostring(clockSeconds)
  else
    clockTime = clockTime .. tostring(clockSeconds)
  end
  return clockTime
end
function convertStringFromMillisecondtime(u64_Millisecondtime)
  local u64_dayCycle = toUint64(0, 86400000)
  local u64_houseCycle = toUint64(0, 3600000)
  local u64_minuteCycle = toUint64(0, 60000)
  local u64_day = u64_Millisecondtime / u64_dayCycle
  local u64_hour = (u64_Millisecondtime - u64_dayCycle * u64_day) / u64_houseCycle
  local u64_minute = (u64_Millisecondtime - u64_dayCycle * u64_day - u64_houseCycle * u64_hour) / u64_minuteCycle
  local u64_Second = (u64_Millisecondtime - u64_dayCycle * u64_day - u64_houseCycle * u64_hour - u64_minuteCycle * u64_minute) / toUint64(0, 1000)
  local strDate = ""
  if u64_day > Defines.u64_const.u64_0 then
    strDate = tostring(u64_day) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY") .. tostring(u64_hour) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR")
  elseif u64_hour > Defines.u64_const.u64_0 then
    strDate = tostring(u64_hour) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR") .. tostring(u64_minute) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE")
  elseif u64_minute > Defines.u64_const.u64_0 then
    strDate = tostring(u64_minute) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE") .. tostring(u64_Second) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND")
  elseif u64_Second > Defines.u64_const.u64_0 then
    strDate = tostring(u64_Second) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND")
  else
    strDate = ""
  end
  return strDate
end
local UI_color = Defines.Color
local UI_CT = CppEnums.ChatType
local UI_CNT = CppEnums.EChatNoticeType
teamColorSettingList = {
  [0] = UI_color.C_FFff6922,
  UI_color.C_FF84FFF5,
  UI_color.C_FF5922a3,
  UI_color.C_FF160929,
  UI_color.C_FFfdc9c8,
  UI_color.C_FFfa5d59,
  UI_color.C_FF7c1311,
  UI_color.C_FF80b9e6,
  UI_color.C_FF55a1dd,
  UI_color.C_FF014d89,
  UI_color.C_FF003966,
  UI_color.C_FFfef2b2,
  UI_color.C_FFbea216,
  UI_color.C_FFc1f8d1,
  UI_color.C_FF09e447,
  UI_color.C_FF023912,
  UI_color.C_FFfc5b95,
  UI_color.C_FFfb2472,
  UI_color.C_FF3f091d,
  UI_color.C_FFff8f59,
  UI_color.C_FFa2a2a2,
  UI_color.C_FF000000,
  UI_color.C_FF906bc1,
  UI_color.C_FFfa6e6b,
  UI_color.C_FFa61a17,
  UI_color.C_FFa8cfee,
  UI_color.C_FF015699,
  UI_color.C_FFfee568,
  UI_color.C_FFfdd81e,
  UI_color.C_FFfd92b9
}
function FGlobal_TeamColorList(index)
  if index < 0 or index >= 30 then
    return UI_color.C_FFC4BEBE
  end
  return teamColorSettingList[index]
end
colorSettingList = {
  [0] = UI_color.C_FFd5c8e8,
  UI_color.C_FFc6b4e0,
  UI_color.C_FFac91d1,
  UI_color.C_FF906bc1,
  UI_color.C_FF8359ba,
  UI_color.C_FF5922a3,
  UI_color.C_FF43197a,
  UI_color.C_FF3c176d,
  UI_color.C_FF2c1151,
  UI_color.C_FF1e0c38,
  UI_color.C_FF160929,
  UI_color.C_FFfdc9c8,
  UI_color.C_FFfdb5b4,
  UI_color.C_FFfc9391,
  UI_color.C_FFfa6e6b,
  UI_color.C_FFfa5d59,
  UI_color.C_FFf82722,
  UI_color.C_FFba1d19,
  UI_color.C_FFa61a17,
  UI_color.C_FF7c1311,
  UI_color.C_FF550d0c,
  UI_color.C_FF3e0a09,
  UI_color.C_FFbfdcf2,
  UI_color.C_FFa8cfee,
  UI_color.C_FF80b9e6,
  UI_color.C_FF55a1dd,
  UI_color.C_FF4196d9,
  UI_color.C_FF0173cc,
  UI_color.C_FF015699,
  UI_color.C_FF014d89,
  UI_color.C_FF003966,
  UI_color.C_FF002746,
  UI_color.C_FF001d33,
  UI_color.C_FFfef5c7,
  UI_color.C_FFfef2b2,
  UI_color.C_FFfeec8f,
  UI_color.C_FFfee568,
  UI_color.C_FFfee256,
  UI_color.C_FFfdd81e,
  UI_color.C_FFbea216,
  UI_color.C_FFaa9114,
  UI_color.C_FF7e6c0f,
  UI_color.C_FF564a0a,
  UI_color.C_FF3f3608,
  UI_color.C_FFc1f8d1,
  UI_color.C_FFabf6c0,
  UI_color.C_FF84f2a3,
  UI_color.C_FF5aed84,
  UI_color.C_FF47eb75,
  UI_color.C_FF09e447,
  UI_color.C_FF07ab35,
  UI_color.C_FF069930,
  UI_color.C_FF047223,
  UI_color.C_FF034e18,
  UI_color.C_FF023912,
  UI_color.C_FFfec8dc,
  UI_color.C_FFfeb4cf,
  UI_color.C_FFfd92b9,
  UI_color.C_FFfc6ca0,
  UI_color.C_FFfc5b95,
  UI_color.C_FFfb2472,
  UI_color.C_FFbc1b55,
  UI_color.C_FFa8184c,
  UI_color.C_FF7d1239,
  UI_color.C_FF560c27,
  UI_color.C_FF3f091d,
  UI_color.C_FFffd9c8,
  UI_color.C_FFffccb4,
  UI_color.C_FFffb491,
  UI_color.C_FFff9a6b,
  UI_color.C_FFff8f59,
  UI_color.C_FFff6922,
  UI_color.C_FFbf4f19,
  UI_color.C_FFab4617,
  UI_color.C_FF7f3411,
  UI_color.C_FF57240c,
  UI_color.C_FF401a09,
  UI_color.C_FFfefefe,
  UI_color.C_FFcbcbcb,
  UI_color.C_FFa2a2a2,
  UI_color.C_FF828282,
  UI_color.C_FF656565,
  UI_color.C_FF474747,
  UI_color.C_FF323232,
  UI_color.C_FF232323,
  UI_color.C_FF181818,
  UI_color.C_FF111111,
  UI_color.C_FF000000
}
function FGlobal_ColorList(index)
  if index < 0 or index >= 88 then
    return UI_color.C_FFC4BEBE
  end
  return colorSettingList[index]
end
function Chatting_MessageColor(msgChatType, msgNoticeType, panelIndex)
  local msgColor = UI_color.C_FFE7E7E7
  if nil == msgChatType or msgChatType < -1 or msgChatType > 18 then
    return UI_color.C_FFC4BEBE
  end
  local chatColorIndex = -1
  if nil ~= panelIndex then
    local chat = ToClient_getChattingPanel(panelIndex)
    if nil ~= chat then
      if UI_CT.System ~= msgChatType then
        chatColorIndex = chat:getChatColorIndex(msgChatType)
      else
        chatColorIndex = chat:getChatSystemColorIndex(msgChatType)
      end
    end
  end
  if UI_CT.Public == msgChatType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FFE7E7E7
      return msgColor
    end
  elseif UI_CT.Party == msgChatType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FF8EBD00
      return msgColor
    end
  elseif UI_CT.Guild == msgChatType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FF84FFF5
      return msgColor
    end
  elseif UI_CT.World == msgChatType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FFFF973A
      return msgColor
    end
  elseif UI_CT.Private == msgChatType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FFF601FF
      return msgColor
    end
  elseif UI_CT.System == msgChatType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FFC4BEBE
      return msgColor
    end
  elseif UI_CT.Notice == msgChatType and UI_CNT.Normal == msgNoticeType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FFFFEF82
      return msgColor
    end
  elseif UI_CT.Notice == msgChatType and UI_CNT.Campaign == msgNoticeType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FFBBFF84
      return msgColor
    end
  elseif UI_CT.Notice == msgChatType and UI_CNT.Emergency == msgNoticeType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FFFF4B4B
      return msgColor
    end
  elseif UI_CT.Alliance == msgChatType then
    if -1 == chatColorIndex then
      msgColor = 4285842942
      return msgColor
    end
  elseif UI_CT.WorldWithItem == msgChatType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FF00F3A0
      return msgColor
    end
  elseif UI_CT.LocalWar == msgChatType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FFB97FEF
      return msgColor
    end
  elseif UI_CT.RolePlay == msgChatType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FF00B4FF
      return msgColor
    end
  elseif UI_CT.Arsha == msgChatType and UI_CNT.PvPHost == msgNoticeType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FF00B4FF
      return msgColor
    end
  elseif UI_CT.Arsha == msgChatType then
    if -1 == chatColorIndex then
      msgColor = UI_color.C_FFFFD237
      return msgColor
    end
  elseif UI_CT.Team == msgChatType and -1 == chatColorIndex then
    msgColor = UI_color.C_FFB97FEF
    return msgColor
  end
  return FGlobal_ColorList(chatColorIndex)
end
function getUseMemory()
  return collectgarbage("count", 0)
end
function in_array(e, t)
  for _, v in pairs(t) do
    if v == e then
      return true
    end
  end
  return false
end
function getContryTypeLua()
  local returnValue = -1
  local gameServiceType = getGameServiceType()
  local eCountryType = CppEnums.CountryType
  if eCountryType.NONE == gameServiceType or eCountryType.DEV == gameServiceType or eCountryType.KOR_ALPHA == gameServiceType or eCountryType.KOR_REAL == gameServiceType or eCountryType.KOR_TEST == gameServiceType then
    returnValue = CppEnums.ContryCode.eContryCode_KOR
  elseif eCountryType.JPN_ALPHA == gameServiceType or eCountryType.JPN_REAL == gameServiceType then
    returnValue = CppEnums.ContryCode.eContryCode_JAP
  elseif eCountryType.RUS_ALPHA == gameServiceType or eCountryType.RUS_REAL == gameServiceType then
    returnValue = CppEnums.ContryCode.eContryCode_RUS
  elseif eCountryType.KR2_ALPHA == gameServiceType or eCountryType.KR2_REAL == gameServiceType then
    returnValue = CppEnums.ContryCode.eContryCode_KR2
  elseif eCountryType.NA_ALPHA == gameServiceType or eCountryType.NA_REAL == gameServiceType then
    returnValue = CppEnums.ContryCode.eContryCode_NA
  elseif eCountryType.TW_ALPHA == gameServiceType or eCountryType.TW_REAL == gameServiceType then
    returnValue = CppEnums.ContryCode.eContryCode_TW
  elseif eCountryType.SA_ALPHA == gameServiceType or eCountryType.SA_REAL == gameServiceType then
    returnValue = CppEnums.ContryCode.eContryCode_SA
  elseif eCountryType.TH_ALPHA == gameServiceType or eCountryType.TH_REAL == gameServiceType then
    returnValue = CppEnums.ContryCode.eContryCode_TH
  elseif eCountryType.ID_ALPHA == gameServiceType or eCountryType.ID_REAL == gameServiceType then
    returnValue = CppEnums.ContryCode.eContryCode_ID
  elseif eCountryType.TR_ALPHA == gameServiceType or eCountryType.TR_REAL == gameServiceType then
    returnValue = CppEnums.ContryCode.eContryCode_TR
  elseif eCountryType.GT_ALPHA == gameServiceType or eCountryType.GT_REAL == gameServiceType then
    returnValue = CppEnums.ContryCode.eContryCode_GT
  else
    returnValue = CppEnums.ContryCode.eContryCode_Count
  end
  return returnValue
end
function isGameTypeThisCountry(country)
  if country == getContryTypeLua() then
    return true
  end
  return false
end
function getGameContentsServiceType()
  local returnValue = -1
  local gameContentServiceType = getContentsServiceType()
  local eContentType = CppEnums.ContentsServiceType
  if eContentType.eContentsServiceType_Closed == gameContentServiceType then
    returnValue = eContentType.eContentsServiceType_Closed
  elseif eContentType.eContentsServiceType_CBT == gameContentServiceType then
    returnValue = eContentType.eContentsServiceType_CBT
  elseif eContentType.eContentsServiceType_Pre == gameContentServiceType then
    returnValue = eContentType.eContentsServiceType_Pre
  elseif eContentType.eContentsServiceType_OBT == gameContentServiceType then
    returnValue = eContentType.eContentsServiceType_OBT
  elseif eContentType.eContentsServiceType_Commercial == gameContentServiceType then
    returnValue = eContentType.eContentsServiceType_Commercial
  else
    returnValue = eContentType.eContentsServiceType_Count
  end
  return returnValue
end
function isGameContentServiceType(serviceType)
  if serviceType == getGameContentsServiceType() then
    return true
  end
  return false
end
function isGameTypeKorea()
  return isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_KOR)
end
function isGameTypeRussia()
  return isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_RUS)
end
function isGameTypeJapan()
  return isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_JAP)
end
function isGameTypeEnglish()
  return isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_NA)
end
function isGameTypeTaiwan()
  return isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_TW)
end
function isGameTypeSA()
  return isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_SA)
end
function isGameTypeKR2()
  return isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_KR2)
end
function isGameTypeTH()
  return isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_TH)
end
function isGameTypeID()
  return isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_ID)
end
function isGameTypeTR()
  return isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_TR)
end
function isGameTypeAE()
  return isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_AE)
end
function isGameTypeTH()
  return isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_TH)
end
function isGameTypeGT()
  return isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_GT)
end
function isCommonGameType()
  local returnValue = false
  if isGameTypeJapan() then
    returnValue = true
  elseif isGameTypeRussia() then
    returnValue = true
  elseif isGameTypeEnglish() then
    returnValue = true
  elseif isGameTypeTaiwan() then
    returnValue = true
  elseif isGameTypeSA() then
    returnValue = true
  elseif isGameTypeKR2() then
    returnValue = true
  else
    returnValue = false
  end
  return returnValue
end
function isItemMarketSecureCode()
  local isSecureCode = false
  if (isGameTypeKorea() or isGameTypeJapan() or isGameTypeRussia() or isGameTypeEnglish() or isGameTypeTaiwan() or isGameTypeSA()) and true == isSecureCode then
    return true
  else
    return false
  end
end
local timerObject = {
  _timerNo = 0,
  _endTime = 0,
  _function = nil,
  _isRepeat = false,
  _repeatTime = 0
}
local g_TimerNo = 0
local g_Timerlist = {}
local g_TimerCount = 0
function luaTimer_UpdatePerFrame(fDelta)
  if g_TimerCount <= 0 then
    return
  end
  local currentTickCount = getTickCount32()
  local removeTimerList = {}
  local removeIndex = 1
  for index, timer in pairs(g_Timerlist) do
    if nil ~= timer then
      if currentTickCount >= timer._endTime then
        timer._function(timer._param0, timer._param1, timer._param2)
        if not timer._isRepeat then
          local tempIndex = timer._timerNo
          g_Timerlist[tempIndex] = nil
          g_TimerCount = g_TimerCount - 1
        else
          timer._endTime = currentTickCount + timer._repeatTime
        end
      end
    else
      _PA_LOG("LUA", "timer \234\176\128 nil \236\157\180\235\139\164~~!!!!")
    end
  end
end
function luaTimer_AddEvent(func, endTime, isRepeat, repeatTime, param0, param1, param2)
  g_TimerNo = g_TimerNo + 1
  local tempTimer = {}
  tempTimer._timerNo = g_TimerNo
  tempTimer._endTime = getTickCount32() + endTime
  tempTimer._function = func
  tempTimer._isRepeat = isRepeat
  tempTimer._repeatTime = repeatTime
  tempTimer._param0 = param0
  tempTimer._param1 = param1
  tempTimer._param2 = param2
  if nil == g_Timerlist then
    g_Timerlist = {}
  end
  g_Timerlist[g_TimerNo] = tempTimer
  g_TimerCount = g_TimerCount + 1
  return g_TimerNo
end
function luaTimer_RemoveEvent(timerNo)
  if nil ~= g_Timerlist[timerNo] then
    g_Timerlist[timerNo] = nil
    g_TimerCount = g_TimerCount - 1
  end
end
registerEvent("FromClient_LuaTimer_UpdatePerFrame", "luaTimer_UpdatePerFrame")
