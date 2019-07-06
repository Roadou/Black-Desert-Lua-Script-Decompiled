QASupport_AutomationPanel:SetShow(false)
local itemIndex = -1
local TABLE_TAB0 = {}
local TABLE_TAB1 = {}
local TABLE_TAB2 = {}
local QASupport_AutomationPanel_SafeCheck = function()
  if nil == getSelfPlayer() then
    return false
  end
  if nil == QASupport_AutomationPanel then
    return false
  end
  return true
end
function QASupport_AutomationPanel_Close()
  if false == QASupport_AutomationPanel_SafeCheck() then
    return
  end
  QASupport_AutomationPanel_Reset()
  QASupport_AutomationPanel:SetShow(false)
end
function clickTab(index)
  if 0 == index then
    for _, control in pairs(TABLE_TAB0) do
      control:SetShow(true)
    end
    for _, control in pairs(TABLE_TAB1) do
      control:SetShow(false)
    end
    for _, control in pairs(TABLE_TAB2) do
      control:SetShow(false)
    end
  elseif 1 == index then
    for _, control in pairs(TABLE_TAB0) do
      control:SetShow(false)
    end
    for _, control in pairs(TABLE_TAB1) do
      control:SetShow(true)
    end
    for _, control in pairs(TABLE_TAB2) do
      control:SetShow(false)
    end
  elseif 2 == index then
    for _, control in pairs(TABLE_TAB0) do
      control:SetShow(false)
    end
    for _, control in pairs(TABLE_TAB1) do
      control:SetShow(false)
    end
    for _, control in pairs(TABLE_TAB2) do
      control:SetShow(true)
    end
  end
end
function QASupport_AutomationPanel_Reset()
  if false == QASupport_AutomationPanel_SafeCheck() then
    return
  end
  UI.getChildControl(QASupport_AutomationPanel, "RadioButton_Tab0"):SetCheck(true)
  UI.getChildControl(QASupport_AutomationPanel, "RadioButton_Tab1"):SetCheck(false)
  UI.getChildControl(QASupport_AutomationPanel, "RadioButton_Tab2"):SetCheck(false)
  clickTab(0)
end
function FromClient_QASupport_AutomationPanel_Toggle()
  if false == QASupport_AutomationPanel_SafeCheck() then
    return
  end
  local showCheck = not QASupport_AutomationPanel:GetShow()
  if true == showCheck then
    QASupport_AutomationPanel_Reset()
  end
  QASupport_AutomationPanel:SetShow(showCheck)
end
registerEvent("FromClient_QASupport_AutomationPanel_Toggle", "FromClient_QASupport_AutomationPanel_Toggle()")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_QASupport_AutomationPanel")
local control_validate = function(col, row, name, clickEvent, tabNumber)
  if row > 3 then
    _PA_ASSERT_NAME(false, "CREATE_BUTTON() row\234\176\146\236\157\128 3\236\157\132 \235\132\152\236\150\180\236\132\156\235\169\180 \236\149\136\235\144\169\235\139\136\235\139\164.", "QA\237\140\128 \235\172\184\236\132\184\236\152\129 / \236\161\176\236\132\177\235\175\188")
  end
  if tabNumber > 2 then
    _PA_ASSERT_NAME(false, "CREATE_BUTTON() tabNumber\234\176\146\236\157\128 2\236\157\132 \235\132\152\236\150\180\236\132\156\235\169\180 \236\149\136\235\144\169\235\139\136\235\139\164.", "QA\237\140\128 \235\172\184\236\132\184\236\152\129 / \236\161\176\236\132\177\235\175\188")
  end
  if nil == col then
    _PA_ASSERT_NAME(false, "CREATE_BUTTON() col nil\236\158\133\235\139\136\235\139\164.", "QA\237\140\128 \235\172\184\236\132\184\236\152\129 / \236\161\176\236\132\177\235\175\188")
  end
  if nil == row then
    _PA_ASSERT_NAME(false, "CREATE_BUTTON() row nil\236\158\133\235\139\136\235\139\164.", "QA\237\140\128 \235\172\184\236\132\184\236\152\129 / \236\161\176\236\132\177\235\175\188")
  end
  if nil == name then
    _PA_ASSERT_NAME(false, "CREATE_BUTTON() name\236\157\180 nil\236\158\133\235\139\136\235\139\164.", "QA\237\140\128 \235\172\184\236\132\184\236\152\129 / \236\161\176\236\132\177\235\175\188")
  end
  if nil == clickEvent then
    _PA_ASSERT_NAME(false, "CREATE_BUTTON() clickEvent\234\176\128 nil\236\158\133\235\139\136\235\139\164.", "QA\237\140\128 \235\172\184\236\132\184\236\152\129 / \236\161\176\236\132\177\235\175\188")
  end
  if nil == tabNumber then
    _PA_ASSERT_NAME(false, "CREATE_BUTTON() tabNumber\234\176\128 nil\236\158\133\235\139\136\235\139\164.", "QA\237\140\128 \235\172\184\236\132\184\236\152\129 / \236\161\176\236\132\177\235\175\188")
  end
end
local function CREATE_BUTTON(col, row, name, clickEvent, tabNumber)
  control_validate(col, row, name, clickEvent, tabNumber)
  itemIndex = itemIndex + 1
  local btn = UI.createAndCopyBasePropertyControl(QASupport_AutomationPanel, "ButtonTemp", QASupport_AutomationPanel, "ButtonTemp_" .. itemIndex)
  if nil == btn then
    _PA_ASSERT_NAME(nil ~= clickEvent, "CREATE_BUTTON() clickEvent\234\176\128 nil\236\158\133\235\139\136\235\139\164.", "QA\237\140\128 \235\172\184\236\132\184\236\152\129 / \236\161\176\236\132\177\235\175\188")
  end
  btn:SetShow(true)
  btn:SetText(name)
  btn:SetPosX(10 + row * (btn:GetSizeX() + 4))
  btn:SetPosY(110 + col * (btn:GetSizeY() + 10))
  btn:addInputEvent("Mouse_LUp", clickEvent)
  if 0 == tabNumber then
    TABLE_TAB0[itemIndex] = btn
  elseif 1 == tabNumber then
    TABLE_TAB1[itemIndex] = btn
  elseif 2 == tabNumber then
    TABLE_TAB2[itemIndex] = btn
  end
end
function FromClient_luaLoadComplete_QASupport_AutomationPanel()
  if false == QASupport_AutomationPanel_SafeCheck() then
    return
  end
  local btn_tab0 = UI.getChildControl(QASupport_AutomationPanel, "RadioButton_Tab0")
  local btn_tab1 = UI.getChildControl(QASupport_AutomationPanel, "RadioButton_Tab1")
  local btn_tab2 = UI.getChildControl(QASupport_AutomationPanel, "RadioButton_Tab2")
  local stc_title = UI.getChildControl(QASupport_AutomationPanel, "StaticText_Title")
  local btn_close = UI.getChildControl(stc_title, "Button_Win_Close")
  btn_close:addInputEvent("Mouse_LUp", "QASupport_AutomationPanel_Close()")
  btn_tab0:addInputEvent("Mouse_LUp", "clickTab(0)")
  btn_tab1:addInputEvent("Mouse_LUp", "clickTab(1)")
  btn_tab2:addInputEvent("Mouse_LUp", "clickTab(2)")
  QASupport_AutomationPanel_CreateControl_Tab1()
  QASupport_AutomationPanel_CreateControl_Tab2()
  QASupport_AutomationPanel_CreateControl_Tab3()
  QASupport_AutomationPanel_Reset()
  btn_tab0:SetText("\236\157\180\235\143\153")
  btn_tab1:SetText("\236\132\184\237\140\133")
  btn_tab2:SetText("\234\176\132\237\142\184 \235\170\133\235\160\185\236\150\180")
end
function QASupport_AutomationPanel_CreateControl_Tab1()
  if false == QASupport_AutomationPanel_SafeCheck() then
    return
  end
  CREATE_BUTTON(0, 0, "\235\178\168\235\166\172\236\149\132 1", "TeleportBelia1()", 0)
  CREATE_BUTTON(1, 0, "\235\178\168\235\166\172\236\149\132 2", "TeleportBelia2()", 0)
  CREATE_BUTTON(2, 0, "\237\149\152\236\157\180\235\141\184 1", "TeleportHeidel1()", 0)
  CREATE_BUTTON(3, 0, "\237\149\152\236\157\180\235\141\184 2", "TeleportHeidel2()", 0)
  CREATE_BUTTON(4, 0, "\236\185\188\237\142\152\236\152\168 1", "TeleportCalpheon1()", 0)
  CREATE_BUTTON(5, 0, "\236\185\188\237\142\152\236\152\168 2", "TeleportCalpheon2()", 0)
  CREATE_BUTTON(6, 0, "\236\149\140\237\139\176\235\133\184\235\176\148", "TeleportAltinova1()", 0)
  CREATE_BUTTON(7, 0, "\235\176\156\235\160\140\236\139\156\236\149\132", "TeleportValencia1()", 0)
  CREATE_BUTTON(8, 0, "\234\183\184\235\157\188\235\130\152", "TeleportGrana1()", 0)
  CREATE_BUTTON(9, 0, "\235\147\156\235\178\164\237\129\172\235\163\172", "TeleportDuvencrune1()", 0)
  CREATE_BUTTON(0, 1, "\235\136\132\235\178\160\235\165\180", "NouverTest()", 0)
  CREATE_BUTTON(1, 1, "\236\191\160\237\136\188", "KutumTest()", 0)
  CREATE_BUTTON(2, 1, "\236\185\180\235\158\128\235\139\164", "KarandaTest()", 0)
  CREATE_BUTTON(3, 1, "\237\129\172\236\158\144\236\185\180", "KzarkaTest()", 0)
  CREATE_BUTTON(4, 1, "\236\152\164\237\149\128", "OpinTest()", 0)
  CREATE_BUTTON(5, 1, "\235\172\180\235\157\188\236\185\180", "MurakaTest()", 0)
  CREATE_BUTTON(6, 1, "\234\183\132\237\138\184", "QuintTest()", 0)
  CREATE_BUTTON(7, 1, "\234\176\128\235\170\168\236\138\164", "GarmothTest()", 0)
  CREATE_BUTTON(8, 1, "\235\178\168", "VellTest()", 0)
  CREATE_BUTTON(9, 1, "\236\139\156\237\129\172\235\166\172\235\147\156", "SycridTest()", 0)
  CREATE_BUTTON(10, 1, "\235\185\168\234\176\132\236\189\148", "RednoseTest()", 0)
  CREATE_BUTTON(11, 1, "\236\154\176\235\145\148", "DimTreeSpiritTest()", 0)
  CREATE_BUTTON(12, 1, "\235\178\160\234\183\184", "BhegTest()", 0)
  CREATE_BUTTON(0, 2, "\236\180\136\236\138\185", "TeleportCrescent()", 0)
  CREATE_BUTTON(1, 2, "\235\176\148\236\139\164", "TeleportBasilisk()", 0)
  CREATE_BUTTON(2, 2, "\236\149\132\237\129\172\235\167\140", "TeleportAakman()", 0)
  CREATE_BUTTON(3, 2, "\237\158\136\236\138\164", "TeleportHystria()", 0)
  CREATE_BUTTON(4, 2, "\237\149\132\235\157\188\236\191\160", "TeleportPilaKu()", 0)
  CREATE_BUTTON(5, 2, "\235\175\184\235\163\168\235\170\169", "TeleportMirumok()", 0)
  CREATE_BUTTON(6, 2, "\237\149\180\236\160\128", "TeleportUnderwater()", 0)
  CREATE_BUTTON(7, 2, "\236\139\172\237\149\180", "TeleportSycraia()", 0)
  CREATE_BUTTON(8, 2, "\235\179\132\235\172\180\235\141\164", "TeleportStarGrave()", 0)
  CREATE_BUTTON(10, 2, "\235\167\136\234\179\160\235\166\172\236\149\132 \235\182\129\235\182\128", "TeleportNorthMagoria()", 0)
  CREATE_BUTTON(11, 2, "\235\167\136\234\179\160\235\166\172\236\149\132 \236\164\145\236\149\153", "TeleportMiddleMagoria()", 0)
  CREATE_BUTTON(12, 2, "\235\167\136\234\179\160\235\166\172\236\149\132 \235\130\168\235\182\128", "TeleportSouthMagoria()", 0)
end
function QASupport_AutomationPanel_CreateControl_Tab2()
  if false == QASupport_AutomationPanel_SafeCheck() then
    return
  end
  CREATE_BUTTON(0, 0, "\236\130\172\235\131\165 \237\133\140\236\138\164\237\138\184 \236\132\184\237\140\133", "pvetest()", 1)
  CREATE_BUTTON(1, 0, "\234\179\160\236\156\160\235\143\153 \235\172\180\234\184\176", "TriTetPenWeapon()", 1)
  CREATE_BUTTON(2, 0, "\234\179\160\236\156\160\235\143\153 \235\176\169\236\150\180\234\181\172", "TriTetPenArmor()", 1)
  CREATE_BUTTON(3, 0, "\234\179\160\236\156\160\235\143\153 \236\149\161\236\132\184\236\132\156\235\166\172", "TriTetPenAcc()", 1)
  CREATE_BUTTON(4, 0, "\236\158\165\234\180\145 \235\172\180\234\184\176", "PriDuoWeapon()", 1)
  CREATE_BUTTON(5, 0, "\236\158\165\234\180\145 \235\176\169\236\150\180\234\181\172", "PriDuoArmor()", 1)
  CREATE_BUTTON(6, 0, "\236\158\165\234\180\145 \236\149\161\236\132\184\236\132\156\235\166\172", "PriDuoAcc()", 1)
  CREATE_BUTTON(7, 0, "\236\154\148\235\166\172 \236\157\140\236\139\157", "CreateFood()", 1)
  CREATE_BUTTON(8, 0, "\236\152\129\236\149\189 \237\154\140\235\179\181\236\160\156", "CreateDraught()", 1)
  CREATE_BUTTON(9, 0, "\236\151\176\234\184\136\236\132\157", "CreateAlchemyStone()", 1)
  CREATE_BUTTON(10, 0, "\236\136\152\236\160\149", "createCrystal2()", 1)
  CREATE_BUTTON(11, 0, "\235\179\132\236\177\132 \236\139\160\236\178\180 \234\176\149\237\153\148\235\178\149", "ToClient_qaCreateItem(43706,0,1)", 1)
  CREATE_BUTTON(12, 0, "\236\154\180\236\152\129\236\158\144 \236\158\165\235\185\132", "SetGMItem()", 1)
  CREATE_BUTTON(0, 1, "\234\176\128\235\176\169 \235\185\132\236\154\176\234\184\176", "ToClient_qaClearInventory()", 1)
  CREATE_BUTTON(1, 1, "4\236\132\184\235\140\128 \237\142\171x5", "Set4thPets()", 1)
  CREATE_BUTTON(2, 1, "4\236\132\184\235\140\128 \236\154\148\236\160\149", "Set4thFairy()", 1)
  CREATE_BUTTON(3, 1, "\236\157\188\234\190\188(\236\136\153\236\134\140\237\149\132\236\154\148)", "workerready(30)", 1)
  CREATE_BUTTON(4, 1, "\235\169\148\236\157\180\235\147\156", "maidtest()", 1)
  CREATE_BUTTON(5, 1, "\237\152\184\237\157\161,\237\158\152,\234\177\180\234\176\149 30", "SetPhysical30()", 1)
  CREATE_BUTTON(6, 1, "\234\179\181\237\151\140\235\143\132 Exp", "ContributionExp()", 1)
  CREATE_BUTTON(7, 1, "\236\157\184\235\172\188 \236\167\128\236\139\157 \237\154\141\235\147\157", "CreateCharacterKnowledge()", 1)
  CREATE_BUTTON(8, 1, "\236\167\128\237\152\149 \236\167\128\236\139\157 \237\154\141\235\147\157", "CreateTerrainKnowledge()", 1)
  CREATE_BUTTON(9, 1, "\236\177\132\236\167\145 \235\143\132\234\181\172 ", "CreateGatheringTool()", 1)
  CREATE_BUTTON(11, 1, "\234\184\176\236\136\160\237\138\185\237\153\148 NPC", "CreateSkillinstructor()", 1)
  CREATE_BUTTON(12, 1, "\236\136\152\235\166\172 NPC", "CreateEqiupRepairNPC()", 1)
  CREATE_BUTTON(0, 2, "\235\167\136\234\181\172 \236\132\184\237\138\184", "CreateHorseEquip()", 1)
  CREATE_BUTTON(1, 2, "8\237\139\176\236\150\180 \235\176\177\235\167\136", "Create8THorse()", 1)
  CREATE_BUTTON(2, 2, "\236\149\132\235\145\144\236\149\132\235\130\152\237\138\184", "CreateAduahnott()", 1)
  CREATE_BUTTON(3, 2, "\235\148\148\235\132\164", "CreateDine()", 1)
  CREATE_BUTTON(4, 2, "\235\145\160", "CreateDoom()", 1)
  CREATE_BUTTON(5, 2, "\235\167\144 30 \235\160\136\235\178\168", "Lvup30Servant()", 1)
  CREATE_BUTTON(6, 2, "\236\163\188\237\150\137 \236\138\164\237\130\172 \236\138\181\235\147\157", "LearnDrivingSkill()", 1)
  CREATE_BUTTON(7, 2, "\236\138\164\237\130\172 \237\155\136\235\160\168 \236\153\132\235\163\140", "ServantSkillAllMaster()", 1)
  CREATE_BUTTON(8, 2, "\236\149\132\235\145\144 \236\160\132\236\154\169 \236\138\164\237\130\172", "LearnAduahnottSkill()", 1)
  CREATE_BUTTON(9, 2, "\235\148\148\235\132\164 \236\160\132\236\154\169 \236\138\164\237\130\172", "LearnDineSkill()", 1)
  CREATE_BUTTON(10, 2, "\235\145\160 \236\160\132\236\154\169 \236\138\164\237\130\172", "LearnDoomSkill()", 1)
  CREATE_BUTTON(11, 2, "\236\138\164\237\130\172 \237\155\136\235\160\168 \236\153\132\235\163\140", "ServantSkillAllMaster()", 1)
end
function QASupport_AutomationPanel_CreateControl_Tab3()
  if false == QASupport_AutomationPanel_SafeCheck() then
    return
  end
  CREATE_BUTTON(0, 3, "\235\179\180\236\138\164 \236\158\144\236\151\176\236\130\172", "DespawnAllBoss()", 2)
  CREATE_BUTTON(1, 3, "\237\152\132\236\158\172\236\132\156\235\178\132\236\139\156\234\176\132", "CheckServerTime()", 2)
  CREATE_BUTTON(2, 3, "\237\152\132\236\158\172\234\179\181\236\132\177\236\167\128\236\151\173", "CheckSiegeTerritory()", 2)
end
function TeleportBelia1()
  ToClient_qaTeleport(7469, -7815, 83716)
end
function TeleportBelia2()
  ToClient_qaTeleport(24271, -6276, 73371)
end
function TeleportHeidel1()
  ToClient_qaTeleport(37144, -2970, -45723)
end
function TeleportHeidel2()
  ToClient_qaTeleport(48114, 504, -23702)
end
function TeleportCalpheon1()
  ToClient_qaTeleport(-255487, -2714, -38003)
end
function TeleportCalpheon2()
  ToClient_qaTeleport(-265580, -1054, -63041)
end
function TeleportAltinova1()
  ToClient_qaTeleport(360611, -2747, -57960)
end
function TeleportValencia1()
  ToClient_qaTeleport(1036210, 12036, 195632)
end
function TeleportGrana1()
  ToClient_qaTeleport(-505566, 10338, -448408)
end
function TeleportDuvencrune1()
  ToClient_qaTeleport(-48357, 21828, -404589)
end
function KutumTest()
  Proc_ShowMessage_Ack("\236\191\160\237\136\188 : 23073")
  ToClient_qaTeleport(531159, 5820, 162207)
end
function NouverTest()
  ToClient_qaCreateItem(6656, 0, 20)
  ToClient_qaCreateItem(9306, 0, 5)
  Proc_ShowMessage_Ack("\235\136\132\235\178\160\235\165\180 : 23032")
  ToClient_qaTeleport(729435, 12348, 4370)
end
function KarandaTest()
  Proc_ShowMessage_Ack("\236\185\180\235\158\128\235\139\164 : 23060")
  ToClient_qaTeleport(-142688, 18907, 47731)
end
function KzarkaTest()
  Proc_ShowMessage_Ack("\237\129\172\236\158\144\236\185\180 : 23001")
  ToClient_qaTeleport(52490, 652, -191068)
end
function OpinTest()
  Proc_ShowMessage_Ack("\236\152\164\237\149\128 : 23809")
  ToClient_qaTeleport(-455712, 12045, -354960)
end
function MurakaTest()
  ToClient_qaTeleport(-400610, 9117, -106154)
end
function QuintTest()
  Proc_ShowMessage_Ack("\234\183\132\237\138\184 : 23102, 23099")
  ToClient_qaTeleport(-333958, -61, 15014)
end
function GarmothTest()
  Proc_ShowMessage_Ack("\234\176\128\235\170\168\236\138\164 : 23120")
  ToClient_qaTeleport(-23638, 9224, -324144)
end
function VellTest()
  ToClient_qaTeleport(-102400, -8150, 947200)
end
function SycridTest()
  Proc_ShowMessage_Ack("\236\139\156\237\129\172\235\166\172\235\147\156 : 21465")
  ToClient_qaTeleport(159520, -27351, 431993)
end
function RednoseTest()
  Proc_ShowMessage_Ack("\235\185\168\234\176\132\236\189\148 : 23061")
  ToClient_qaTeleport(-62791, -3745, 55418)
end
function BhegTest()
  Proc_ShowMessage_Ack("\235\178\160\234\183\184 : 23703")
  ToClient_qaTeleport(-53494, -2864, -50447)
end
function DimTreeSpiritTest()
  Proc_ShowMessage_Ack("\236\154\176\235\145\148 : 23006")
  ToClient_qaTeleport(-49166, -4256, 27242)
end
function TeleportCrescent()
  ToClient_qaCreateItem(6656, 0, 20)
  ToClient_qaCreateItem(9306, 0, 5)
  ToClient_qaTeleport(727117, 24334, -179501)
end
function TeleportBasilisk()
  ToClient_qaTeleport(379581, -456, 58433)
end
function TeleportAakman()
  ToClient_qaCreateItem(6656, 0, 20)
  ToClient_qaCreateItem(9306, 0, 5)
  ToClient_qaTeleport(671915, -3196, 146474)
end
function TeleportHystria()
  ToClient_qaCreateItem(6656, 0, 20)
  ToClient_qaCreateItem(9306, 0, 5)
  ToClient_qaTeleport(1001914, -5151, 4470)
end
function TeleportPilaKu()
  ToClient_qaCreateItem(6656, 0, 20)
  ToClient_qaCreateItem(9306, 0, 5)
  ToClient_qaTeleport(1146486, 17403, -82183)
end
function TeleportMirumok()
  ToClient_qaTeleport(-462621, 12951, -340087)
end
function TeleportUnderwater()
  ToClient_qaTeleport(149967, -37602, 408723)
end
function TeleportSycraia()
  ToClient_qaTeleport(113194, -35505, 423754)
end
function TeleportStarGrave()
  ToClient_qaTeleport(-505019, 5650, -97822)
end
function TeleportNorthMagoria()
  ToClient_qaTeleport(-1245782, -8208, 751261)
end
function TeleportMiddleMagoria()
  ToClient_qaTeleport(-1159354, -8208, 523806)
end
function TeleportSouthMagoria()
  ToClient_qaTeleport(-857164, -8208, 450816)
end
function CheckServerTime()
  pa_sendMessage("/checkservertime")
end
function CheckSiegeTerritory()
  pa_sendMessage("/checksiegeTerritory")
end
function SetForServantQA1()
  ToClient_qaLevelUp(60)
  ToClient_qaCreateItem(1, 0, 1)
  ToClient_qaCreateItem(149003, 0, 1)
  luaTimer_AddEvent(ToClient_qaUseInventoryItem, 1000, false, 0, 149003, 0)
  Proc_ShowMessage_Ack("\235\167\136\234\181\172\234\176\132 \237\133\140\236\138\164\237\138\184 \236\160\132\236\151\144 \235\169\148\236\157\180\235\147\156\235\161\156 \236\176\189\234\179\160\236\151\144 \236\157\128\237\153\148\235\165\188 \235\132\163\236\150\180\236\163\188\236\132\184\236\154\148")
  ToClient_qaTeleport(41282, -2886, -45065)
end
function DesertSupport()
  ToClient_qaCreateItem(6656, 0, 50)
  ToClient_qaCreateItem(9306, 0, 10)
  ToClient_qaCreateItem(17976, 0, 1)
  ToClient_qaCreateItem(18858, 0, 1)
end
function SetPhysical30()
  ToClient_qaCreateItem(65489, 0, 1)
  ToClient_qaCreateItem(65490, 0, 1)
  ToClient_qaCreateItem(65491, 0, 1)
end
function CreateCharacterKnowledge()
  pa_sendMessage("/create item 30000~31200 1")
end
function CreateTerrainKnowledge()
  pa_sendMessage("/create item 33001~33500 1")
end
function ContributionExp()
  ToClient_qaCreateItem(440, 0, 10)
end
function SetGMItem()
  ToClient_qaCreateItem(65000, 0, 2)
  ToClient_qaCreateItem(65001, 0, 1)
  ToClient_qaCreateItem(65002, 0, 1)
  ToClient_qaCreateItem(65003, 0, 1)
  ToClient_qaCreateItem(65004, 0, 1)
end
function Set4thFairy()
  pa_sendMessage("/pet create 55240")
  ToClient_qaCreateItem(18448, 0, 1000)
  ToClient_qaCreateItem(18447, 0, 20)
end
function Set4thPets()
  pa_sendMessage("/pet create 55162")
  pa_sendMessage("/pet create 55162")
  pa_sendMessage("/pet create 55162")
  pa_sendMessage("/pet create 55162")
end
function CreateHorseEquip()
  ToClient_qaCreateItem(52504, 0, 1)
  ToClient_qaCreateItem(52604, 0, 1)
  ToClient_qaCreateItem(52704, 0, 1)
  ToClient_qaCreateItem(52804, 0, 1)
  ToClient_qaCreateItem(52904, 0, 1)
  ToClient_qaCreateItem(705156, 0, 1)
end
function CheckIsExistUnsealVehicle()
  local temporaryWrapper = getTemporaryInformationWrapper()
  servantInfo = temporaryWrapper:getUnsealVehicle(0)
  return nil ~= servantInfo
end
function Create8THorse()
  if true == CheckIsExistUnsealVehicle() then
    Proc_ShowMessage_Ack("\236\157\180\235\175\184 \235\167\144\236\157\132 \236\134\140\237\153\152\237\149\156 \236\131\129\237\131\156\236\158\133\235\139\136\235\139\164.")
  else
    ToClient_qaCreateServant(9883, 1)
  end
end
function CreateAduahnott()
  if true == CheckIsExistUnsealVehicle() then
    Proc_ShowMessage_Ack("\236\157\180\235\175\184 \235\167\144\236\157\132 \236\134\140\237\153\152\237\149\156 \236\131\129\237\131\156\236\158\133\235\139\136\235\139\164.")
  else
    ToClient_qaCreateServant(9889, 1)
  end
end
function CreateDine()
  if true == CheckIsExistUnsealVehicle() then
    Proc_ShowMessage_Ack("\236\157\180\235\175\184 \235\167\144\236\157\132 \236\134\140\237\153\152\237\149\156 \236\131\129\237\131\156\236\158\133\235\139\136\235\139\164.")
  else
    ToClient_qaCreateServant(9888, 1)
  end
end
function CreateDoom()
  if true == CheckIsExistUnsealVehicle() then
    Proc_ShowMessage_Ack("\236\157\180\235\175\184 \235\167\144\236\157\132 \236\134\140\237\153\152\237\149\156 \236\131\129\237\131\156\236\158\133\235\139\136\235\139\164.")
  else
    ToClient_qaCreateServant(9887, 1)
  end
end
function Lvup30Servant()
  ToClient_qaLevelUpRidingServant(30)
end
function LearnDrivingSkill()
  ToClient_qaLearnHorseSkill(3)
  ToClient_qaLearnHorseSkill(4)
  ToClient_qaLearnHorseSkill(5)
  ToClient_qaLearnHorseSkill(6)
  ToClient_qaLearnHorseSkill(7)
  ToClient_qaLearnHorseSkill(8)
  ToClient_qaLearnHorseSkill(9)
  ToClient_qaLearnHorseSkill(10)
  ToClient_qaLearnHorseSkill(11)
  ToClient_qaLearnHorseSkill(12)
  ToClient_qaLearnHorseSkill(15)
  ToClient_qaLearnHorseSkill(18)
  ToClient_qaLearnHorseSkill(19)
end
function LearnAduahnottSkill()
  ToClient_qaLearnHorseSkill(45)
  ToClient_qaLearnHorseSkill(52)
end
function LearnDineSkill()
  ToClient_qaLearnHorseSkill(45)
  ToClient_qaLearnHorseSkill(53)
end
function LearnDoomSkill()
  ToClient_qaLearnHorseSkill(45)
  ToClient_qaLearnHorseSkill(54)
end
function ServantSkillAllMaster()
  ToClient_qaSetServantSkillExp(0, 1000000)
end
function DespawnAllBoss()
  chatting_sendMessage("", "\235\170\168\235\147\160 \235\179\180\236\138\164 \236\158\144\236\151\176\236\130\172\236\139\156\237\130\164\234\178\160\236\138\181\235\139\136\235\139\164.", CppEnums.ChatType.World)
  pa_sendMessage("/changeallmonsterai timeoutboss 0")
end
function CreateGatheringTool()
  ToClient_qaCreateItem(16479, 19, 1)
  ToClient_qaCreateItem(16481, 19, 1)
  ToClient_qaCreateItem(16482, 19, 1)
  ToClient_qaCreateItem(16486, 19, 1)
  ToClient_qaCreateItem(16487, 19, 1)
  ToClient_qaCreateItem(16847, 19, 1)
end
function CreateFood()
  ToClient_qaCreateItem(9692, 0, 1)
  ToClient_qaCreateItem(9693, 0, 1)
  ToClient_qaCreateItem(9694, 0, 1)
  ToClient_qaCreateItem(9635, 0, 1)
  ToClient_qaCreateItem(9464, 0, 1)
  ToClient_qaCreateItem(9609, 0, 1)
  ToClient_qaCreateItem(9603, 0, 1)
  ToClient_qaCreateItem(9634, 0, 1)
end
function CreateDraught()
  ToClient_qaCreateItem(792, 0, 10)
  ToClient_qaCreateItem(793, 0, 10)
  ToClient_qaCreateItem(794, 0, 10)
  ToClient_qaCreateItem(795, 0, 10)
  ToClient_qaCreateItem(781, 0, 10)
  ToClient_qaCreateItem(529, 0, 100)
  ToClient_qaCreateItem(532, 0, 50)
  ToClient_qaCreateItem(594, 0, 50)
  ToClient_qaCreateItem(19923, 0, 20)
end
function CreateAlchemyStone()
  ToClient_qaCreateItem(45220, 0, 1)
  ToClient_qaCreateItem(45252, 0, 1)
  ToClient_qaCreateItem(45224, 0, 1)
  ToClient_qaCreateItem(45256, 0, 1)
  ToClient_qaCreateItem(45332, 0, 1)
end
function CreateAllAcc(enchantLevel)
  if enchantLevel < 15 then
    enchantLevel = 15
  end
  ToClient_qaCreateItem(12031, enchantLevel - 15, 2)
  ToClient_qaCreateItem(11828, enchantLevel - 15, 2)
  ToClient_qaCreateItem(12230, enchantLevel - 15, 1)
  ToClient_qaCreateItem(11607, enchantLevel - 15, 1)
  ToClient_qaCreateItem(12032, enchantLevel - 15, 2)
  ToClient_qaCreateItem(11926, enchantLevel - 15, 2)
  ToClient_qaCreateItem(12229, enchantLevel - 15, 1)
  ToClient_qaCreateItem(11611, enchantLevel - 15, 1)
  ToClient_qaCreateItem(11834, enchantLevel - 15, 2)
  ToClient_qaCreateItem(12251, enchantLevel - 15, 1)
  ToClient_qaCreateItem(11625, enchantLevel - 15, 1)
end
function PriDuoWeapon()
  createBossWeapon(17)
  createBossWeapon(16)
end
function PriDuoArmor()
  createBossArmor(17)
  createBossArmor(16)
end
function PriDuoAcc()
  CreateAllAcc(17)
  CreateAllAcc(16)
end
function TriTetPenWeapon()
  createBossWeapon(20)
  createBossWeapon(19)
  createBossWeapon(18)
end
function TriTetPenArmor()
  createBossArmor(20)
  createBossArmor(19)
  createBossArmor(18)
end
function TriTetPenAcc()
  CreateAllAcc(20)
  CreateAllAcc(19)
  CreateAllAcc(18)
end
function pakage()
end
function CreateSkillinstructor()
  pa_sendMessage("/create monster 41009 1 1 1")
end
function CreateEqiupRepairNPC()
  pa_sendMessage("/create monster 40008 1 1 1")
end
function test001()
  Proc_ShowMessage_Ack("test001")
end
