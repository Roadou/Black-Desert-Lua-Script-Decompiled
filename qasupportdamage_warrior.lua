local Mindamage = 0
local Maxdamage = 0
local SumCountDamage = 0
function StartQAequipArmor()
  ToClient_qaDebugDamage(0, 1, 1)
end
function StartQASkillUse(SkillQaNumber)
  ToClient_qaDebugDamage(1, SkillQaNumber)
end
function StartQASkillUseWarrior(ST)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1020)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1083)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1084)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1085)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 715)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1018)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1212)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1213)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1331)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 112)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 108)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 109)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 110)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 111)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 113)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1000)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 589)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2734)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1726)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1727)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1728)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 580)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 388)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 577)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1024)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1078)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1079)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 711)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 355)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1718)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1719)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1720)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1721)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1722)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 195)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1022)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1130)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1131)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1132)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1759)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1760)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1761)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1762)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1765)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1766)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1767)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1768)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 293)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 352)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 353)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1030)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2828)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 286)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1148)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2827)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 709)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1138)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 305)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 306)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1027)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1136)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1137)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1751)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1752)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1753)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 706)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 369)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2733)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1330)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1733)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1734)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1735)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1736)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1028)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1080)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1081)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1082)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 590)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 993)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 994)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 995)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 349)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 350)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 351)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 705)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 370)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1025)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1139)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1140)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1141)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1440)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1441)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1442)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1023)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1133)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1134)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1135)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1443)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1444)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 216)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 217)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 218)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 219)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2833)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2831)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2846)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2837)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2835)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2843)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2841)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2832)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2844)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2840)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2852)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2845)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2847)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2838)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2849)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2836)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2850)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2851)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2839)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2842)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2848)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 2834)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 357)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1026)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1142)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1143)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 713)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 714)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1144)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 712)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1145)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 385)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1021)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1127)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1128)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1129)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1748)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1754)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1738)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1730)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1758)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1755)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1737)
  luaTimer_AddEvent(WarSkill, 0, false, 0, ST, 1729)
  chatting_sendMessage("", "Warrior SkillTest End(PVP)", CppEnums.ChatType.Private)
end
function WarSkill(ST, SkillNo)
  if ST == 1 then
    ToClient_qaDebugDamage(1, SkillNo)
  elseif ST == 2 then
  end
end
function WarSkill109(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 109)
  elseif ST == 2 then
  end
end
function WarSkill110(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 110)
  elseif ST == 2 then
  end
end
function WarSkill111(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 111)
  elseif ST == 2 then
  end
end
function WarSkill112(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 112)
  elseif ST == 2 then
  end
end
function WarSkill113(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 113)
  elseif ST == 2 then
  end
end
function WarSkill195(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 195)
  elseif ST == 2 then
  end
end
function WarSkill196(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 196)
  elseif ST == 2 then
  end
end
function WarSkill197(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 197)
  elseif ST == 2 then
  end
end
function WarSkill98(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 198)
  elseif ST == 2 then
  end
end
function WarSkill216(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 216)
  elseif ST == 2 then
  end
end
function WarSkill217(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 217)
  elseif ST == 2 then
  end
end
function WarSkill218(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 218)
  elseif ST == 2 then
  end
end
function WarSkill219(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 219)
  elseif ST == 2 then
  end
end
function WarSkill286(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 286)
  elseif ST == 2 then
  end
end
function WarSkill293(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 293)
  elseif ST == 2 then
  end
end
function WarSkill305(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 305)
  elseif ST == 2 then
  end
end
function WarSkill306(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 306)
  elseif ST == 2 then
  end
end
function WarSkill313(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 313)
  elseif ST == 2 then
  end
end
function WarSkill349(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 349)
  elseif ST == 2 then
  end
end
function WarSkill350(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 350)
  elseif ST == 2 then
  end
end
function WarSkill351(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 351)
  elseif ST == 2 then
  end
end
function WarSkill352(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 352)
  elseif ST == 2 then
  end
end
function WarSkill353(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 353)
  elseif ST == 2 then
  end
end
function WarSkill355(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 355)
  elseif ST == 2 then
  end
end
function WarSkill356(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 356)
  elseif ST == 2 then
  end
end
function WarSkill357(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 357)
  elseif ST == 2 then
  end
end
function WarSkill369(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 369)
  elseif ST == 2 then
  end
end
function WarSkill370(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 370)
  elseif ST == 2 then
  end
end
function WarSkill376(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 376)
  elseif ST == 2 then
  end
end
function WarSkill377(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 377)
  elseif ST == 2 then
  end
end
function WarSkill385(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 385)
  elseif ST == 2 then
  end
end
function WarSkill387(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 387)
  elseif ST == 2 then
  end
end
function WarSkill388(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 388)
  elseif ST == 2 then
  end
end
function WarSkill577(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 577)
  elseif ST == 2 then
  end
end
function WarSkill578(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 578)
  elseif ST == 2 then
  end
end
function WarSkill579(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 579)
  elseif ST == 2 then
  end
end
function WarSkill580(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 580)
  elseif ST == 2 then
  end
end
function WarSkill589(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 589)
  elseif ST == 2 then
  end
end
function WarSkill590(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 590)
  elseif ST == 2 then
  end
end
function WarSkill705(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 705)
  elseif ST == 2 then
  end
end
function WarSkill706(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 706)
  elseif ST == 2 then
  end
end
function WarSkill707(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 707)
  elseif ST == 2 then
  end
end
function WarSkill708(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 708)
  elseif ST == 2 then
  end
end
function WarSkill709(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 709)
  elseif ST == 2 then
  end
end
function WarSkill710(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 710)
  elseif ST == 2 then
  end
end
function WarSkill711(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 711)
  elseif ST == 2 then
  end
end
function WarSkill712(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 712)
  elseif ST == 2 then
  end
end
function WarSkill713(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 713)
  elseif ST == 2 then
  end
end
function WarSkill714(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 714)
  elseif ST == 2 then
  end
end
function WarSkill715(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 715)
  elseif ST == 2 then
  end
end
function WarSkill716(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 716)
  elseif ST == 2 then
  end
end
function WarSkill993(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 993)
  elseif ST == 2 then
  end
end
function WarSkill994(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 994)
  elseif ST == 2 then
  end
end
function WarSkill995(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 995)
  elseif ST == 2 then
  end
end
function WarSkill1000(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1000)
  elseif ST == 2 then
  end
end
function WarSkill1017(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1017)
  elseif ST == 2 then
  end
end
function WarSkill1018(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1018)
  elseif ST == 2 then
  end
end
function WarSkill1019(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1019)
  elseif ST == 2 then
  end
end
function WarSkill1020(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1020)
  elseif ST == 2 then
  end
end
function WarSkill1021(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1021)
  elseif ST == 2 then
  end
end
function WarSkill1022(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1022)
  elseif ST == 2 then
  end
end
function WarSkill1023(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1023)
  elseif ST == 2 then
  end
end
function WarSkill1024(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1024)
  elseif ST == 2 then
  end
end
function WarSkill1025(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1025)
  elseif ST == 2 then
  end
end
function WarSkill1026(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1026)
  elseif ST == 2 then
  end
end
function WarSkill1027(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1027)
  elseif ST == 2 then
  end
end
function WarSkill1028(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1028)
  elseif ST == 2 then
  end
end
function WarSkill1030(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1030)
  elseif ST == 2 then
  end
end
function WarSkill1078(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1078)
  elseif ST == 2 then
  end
end
function WarSkill1079(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1079)
  elseif ST == 2 then
  end
end
function WarSkill1080(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1080)
  elseif ST == 2 then
  end
end
function WarSkill1081(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1081)
  elseif ST == 2 then
  end
end
function WarSkill1082(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1082)
  elseif ST == 2 then
  end
end
function WarSkill1083(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1083)
  elseif ST == 2 then
  end
end
function WarSkill1084(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1084)
  elseif ST == 2 then
  end
end
function WarSkill1085(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1085)
  elseif ST == 2 then
  end
end
function WarSkill1127(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1127)
  elseif ST == 2 then
  end
end
function WarSkill1128(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1128)
  elseif ST == 2 then
  end
end
function WarSkill1129(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1129)
  elseif ST == 2 then
  end
end
function WarSkill1130(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1130)
  elseif ST == 2 then
  end
end
function WarSkill1131(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1131)
  elseif ST == 2 then
  end
end
function WarSkill1132(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1132)
  elseif ST == 2 then
  end
end
function WarSkill1133(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1133)
  elseif ST == 2 then
  end
end
function WarSkill1134(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1134)
  elseif ST == 2 then
  end
end
function WarSkill1135(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1135)
  elseif ST == 2 then
  end
end
function WarSkill1136(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1136)
  elseif ST == 2 then
  end
end
function WarSkill1137(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1137)
  elseif ST == 2 then
  end
end
function WarSkill1138(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1138)
  elseif ST == 2 then
  end
end
function WarSkill1139(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1139)
  elseif ST == 2 then
  end
end
function WarSkill1140(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1140)
  elseif ST == 2 then
  end
end
function WarSkill1141(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1141)
  elseif ST == 2 then
  end
end
function WarSkill1142(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1142)
  elseif ST == 2 then
  end
end
function WarSkill1143(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1143)
  elseif ST == 2 then
  end
end
function WarSkill1144(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1144)
  elseif ST == 2 then
  end
end
function WarSkill1145(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1145)
  elseif ST == 2 then
  end
end
function WarSkill1146(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1146)
  elseif ST == 2 then
  end
end
function WarSkill1147(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1147)
  elseif ST == 2 then
  end
end
function WarSkill1148(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1148)
  elseif ST == 2 then
  end
end
function WarSkill1212(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1212)
  elseif ST == 2 then
  end
end
function WarSkill1213(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1213)
  elseif ST == 2 then
  end
end
function WarSkill1330(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1330)
  elseif ST == 2 then
  end
end
function WarSkill1331(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1331)
  elseif ST == 2 then
  end
end
function WarSkill1440(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1440)
  elseif ST == 2 then
  end
end
function WarSkill1441(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1441)
  elseif ST == 2 then
  end
end
function WarSkill1442(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1442)
  elseif ST == 2 then
  end
end
function WarSkill1443(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1443)
  elseif ST == 2 then
  end
end
function WarSkill1444(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1444)
  elseif ST == 2 then
  end
end
function WarSkill1458(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1458)
  elseif ST == 2 then
  end
end
function WarSkill1712(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1712)
  elseif ST == 2 then
  end
end
function WarSkill1713(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1713)
  elseif ST == 2 then
  end
end
function WarSkill1714(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1714)
  elseif ST == 2 then
  end
end
function WarSkill1715(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1715)
  elseif ST == 2 then
  end
end
function WarSkill1716(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1716)
  elseif ST == 2 then
  end
end
function WarSkill1717(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1717)
  elseif ST == 2 then
  end
end
function WarSkill1718(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1718)
  elseif ST == 2 then
  end
end
function WarSkill1719(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1719)
  elseif ST == 2 then
  end
end
function WarSkill1720(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1720)
  elseif ST == 2 then
  end
end
function WarSkill1721(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1721)
  elseif ST == 2 then
  end
end
function WarSkill1722(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1722)
  elseif ST == 2 then
  end
end
function WarSkill1723(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1723)
  elseif ST == 2 then
  end
end
function WarSkill1724(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1724)
  elseif ST == 2 then
  end
end
function WarSkill1725(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1725)
  elseif ST == 2 then
  end
end
function WarSkill1726(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1726)
  elseif ST == 2 then
  end
end
function WarSkill1727(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1727)
  elseif ST == 2 then
  end
end
function WarSkill1728(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1728)
  elseif ST == 2 then
  end
end
function WarSkill1729(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1729)
  elseif ST == 2 then
  end
end
function WarSkill1730(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1730)
  elseif ST == 2 then
  end
end
function WarSkill1733(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1733)
  elseif ST == 2 then
  end
end
function WarSkill1734(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1734)
  elseif ST == 2 then
  end
end
function WarSkill1735(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1735)
  elseif ST == 2 then
  end
end
function WarSkill1736(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1736)
  elseif ST == 2 then
  end
end
function WarSkill1737(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1737)
  elseif ST == 2 then
  end
end
function WarSkill1738(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1738)
  elseif ST == 2 then
  end
end
function WarSkill1744(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1744)
  elseif ST == 2 then
  end
end
function WarSkill1748(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1748)
  elseif ST == 2 then
  end
end
function WarSkill1751(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1751)
  elseif ST == 2 then
  end
end
function WarSkill1752(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1752)
  elseif ST == 2 then
  end
end
function WarSkill1753(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1753)
  elseif ST == 2 then
  end
end
function WarSkill1754(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1754)
  elseif ST == 2 then
  end
end
function WarSkill1755(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1755)
  elseif ST == 2 then
  end
end
function WarSkill1758(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1758)
  elseif ST == 2 then
  end
end
function WarSkill1759(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1759)
  elseif ST == 2 then
  end
end
function WarSkill1760(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1760)
  elseif ST == 2 then
  end
end
function WarSkill1761(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1761)
  elseif ST == 2 then
  end
end
function WarSkill1762(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1762)
  elseif ST == 2 then
  end
end
function WarSkill1763(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1763)
  elseif ST == 2 then
  end
end
function WarSkill1764(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1764)
  elseif ST == 2 then
  end
end
function WarSkill1765(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1765)
  elseif ST == 2 then
  end
end
function WarSkill1766(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1766)
  elseif ST == 2 then
  end
end
function WarSkill1767(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1767)
  elseif ST == 2 then
  end
end
function WarSkill1768(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 1768)
  elseif ST == 2 then
  end
end
function WarSkill2733(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2733)
  elseif ST == 2 then
  end
end
function WarSkill2734(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2734)
  elseif ST == 2 then
  end
end
function WarSkill2827(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2827)
  elseif ST == 2 then
  end
end
function WarSkill2828(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2828)
  elseif ST == 2 then
  end
end
function WarSkill2831(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2831)
  elseif ST == 2 then
  end
end
function WarSkill2832(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2832)
  elseif ST == 2 then
  end
end
function WarSkill2833(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2833)
  elseif ST == 2 then
  end
end
function WarSkill2834(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2834)
  elseif ST == 2 then
  end
end
function WarSkill2835(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2835)
  elseif ST == 2 then
  end
end
function WarSkill2836(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2836)
  elseif ST == 2 then
  end
end
function WarSkill2837(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2837)
  elseif ST == 2 then
  end
end
function WarSkill2838(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2838)
  elseif ST == 2 then
  end
end
function WarSkill2839(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2839)
  elseif ST == 2 then
  end
end
function WarSkill2840(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2840)
  elseif ST == 2 then
  end
end
function WarSkill2841(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2841)
  elseif ST == 2 then
  end
end
function WarSkill2842(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2842)
  elseif ST == 2 then
  end
end
function WarSkill2843(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2843)
  elseif ST == 2 then
  end
end
function WarSkill2844(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2844)
  elseif ST == 2 then
  end
end
function WarSkill2845(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2845)
  elseif ST == 2 then
  end
end
function WarSkill2846(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2846)
  elseif ST == 2 then
  end
end
function WarSkill2847(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2847)
  elseif ST == 2 then
  end
end
function WarSkill2848(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2848)
  elseif ST == 2 then
  end
end
function WarSkill2849(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2849)
  elseif ST == 2 then
  end
end
function WarSkill2850(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2850)
  elseif ST == 2 then
  end
end
function WarSkill2851(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2851)
  elseif ST == 2 then
  end
end
function WarSkill2852(ST)
  if ST == 1 then
    ToClient_qaDebugDamage(1, 2852)
  elseif ST == 2 then
  end
end
