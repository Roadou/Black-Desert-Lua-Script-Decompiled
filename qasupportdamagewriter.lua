local ApplyDamageWriter = false
local QASupportDamageWriter = {}
local filePath = "D:\\output\\dev\\UI_Data\\Script\\QASupport\\LogQASupportDamageWriter\\"
local file
local fileNum = 0
local fileText = "DamageTest.txt"
local accumulateDamage = 0
function QASupportDamageWriter:write(text)
  file = io.open(filePath .. fileText, "a")
  file:write(text)
  file:close()
end
function QASupportDamageWriter:update()
  if false == ApplyDamageWriter then
    return
  end
  if false == ToClient_IsDevelopment() then
    return
  end
  if GlobalKeyBinder_CheckKeyPressed(CppEnums.VirtualKeyCode.KeyCode_NUMPAD0) then
    Proc_ShowMessage_Ack(getTimeYearMonthDayHourMinSecByTTime64(getUtc64()) .. " : " .. tostring(accumulateDamage))
    self:write(tostring(math.floor(accumulateDamage + 0.5)) .. "\t")
    accumulateDamage = 0
  end
  if GlobalKeyBinder_CheckKeyPressed(CppEnums.VirtualKeyCode.KeyCode_NUMPAD1) then
    fileNum = fileNum + 1
    fileText = "DamageTest" .. tostring(fileNum) .. ".txt"
  end
end
function FGlobal_QASupportDamageWriter_Update()
  if false == ToClient_IsDevelopment() then
    return
  end
  QASupportDamageWriter:update()
end
function FromClinet_EventAttackDamageForQA(damage)
  accumulateDamage = accumulateDamage + damage
end
registerEvent("FromClinet_EventAttackDamageForQA", "FromClinet_EventAttackDamageForQA")
function toggleNoNaviHelper()
  local x = ToClient_toggleNoNaviStartPathFindWithServerPackInfo()
  Proc_ShowMessage_Ack(tostring(x))
end
