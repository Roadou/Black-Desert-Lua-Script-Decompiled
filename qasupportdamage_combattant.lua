local Mindamage = 0
local Maxdamage = 0
local SumCountDamage = 0
function StartQAequipArmor()
  ToClient_qaDebugDamage(0, 1, 1)
end
function StartQASkillUse(SkillQaNumber)
  ToClient_qaDebugDamage(1, SkillQaNumber)
end
function StartQASkillUseCombattant(ST)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2558)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2425)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2426)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2427)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2428)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2429)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2430)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2431)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2432)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2434)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2433)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2491)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2492)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2493)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2494)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2495)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2560)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2556)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2580)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2581)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2582)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2537)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2538)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2539)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2540)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2911)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2449)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2450)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2451)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2528)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2529)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2530)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2531)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2566)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2567)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2568)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2569)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2574)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2575)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2576)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2643)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2759)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2496)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2497)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2498)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2499)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2500)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2473)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2570)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2571)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2572)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2573)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2486)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2487)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2488)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2489)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2501)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2502)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2503)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2504)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2508)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2509)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2510)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2511)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2645)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2519)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2520)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2521)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2446)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2447)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2448)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2505)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2506)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2507)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2552)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2648)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2543)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2544)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2545)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2438)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2439)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2440)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2441)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2442)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2443)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2444)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2445)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2541)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2478)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2479)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2480)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2557)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2549)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2551)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2550)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2561)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2481)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2647)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3030)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3039)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3094)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3049)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3033)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3047)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3040)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3038)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3041)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3043)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3044)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3042)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3045)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3051)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3032)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3050)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3036)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3031)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3046)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3034)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3037)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3052)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3035)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3048)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2435)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2436)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2437)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2910)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2474)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2483)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2484)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2485)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2588)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2589)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2640)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2641)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2642)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2559)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2424)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2577)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2578)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2579)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2546)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2475)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2476)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2477)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2532)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2533)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2534)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2535)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2536)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2562)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2563)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2564)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2565)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2423)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2512)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2513)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2514)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2542)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2644)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2482)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2650)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2522)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2523)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2524)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2516)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2517)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2518)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2553)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2760)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2515)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2525)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2526)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2527)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2452)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2649)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2547)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2548)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2554)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 2490)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3781)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3782)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3783)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3784)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3785)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3788)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3789)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3790)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3796)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3797)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3798)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3799)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3791)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3787)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3779)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3786)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3780)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3792)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3793)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3794)
  luaTimer_AddEvent(CombSkill, 0, false, 0, ST, 3795)
  chatting_sendMessage("", "Combattant SkillTest End(PVP)", CppEnums.ChatType.Private)
end
function CombSkill(ST, SkillNo)
  if ST == 1 then
    ToClient_qaDebugDamage(1, SkillNo)
  elseif ST == 2 then
  end
end
