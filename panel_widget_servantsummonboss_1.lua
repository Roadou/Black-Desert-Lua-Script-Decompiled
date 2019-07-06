function PaGlobal_ServantSummonBoss:initialize()
  if true == PaGlobal_ServantSummonBoss._initialize then
    return
  end
  PaGlobal_ServantSummonBoss._ui._stc_progressBG = UI.getChildControl(Panel_Widget_ServantSummonBoss, "Static_ProgressBG")
  PaGlobal_ServantSummonBoss._ui._stc_progressBar = UI.getChildControl(PaGlobal_ServantSummonBoss._ui._stc_progressBG, "Progress2_HP")
  PaGlobal_ServantSummonBoss._ui._txt_hp = UI.getChildControl(PaGlobal_ServantSummonBoss._ui._stc_progressBG, "StaticText_HP")
  PaGlobal_ServantSummonBoss._ui._txt_hp:SetShow(false)
  PaGlobal_ServantSummonBoss._ui._stc_commandBG = UI.getChildControl(Panel_Widget_ServantSummonBoss, "Static_CommandBG")
  PaGlobal_ServantSummonBoss._ui._stc_moveTitle = UI.getChildControl(PaGlobal_ServantSummonBoss._ui._stc_commandBG, "StaticText_MoveTitle")
  PaGlobal_ServantSummonBoss._ui._stc_attackTitle = UI.getChildControl(PaGlobal_ServantSummonBoss._ui._stc_commandBG, "StaticText_AttackTitle")
  for ii = 1, PaGlobal_ServantSummonBoss._MAX_MOVE_COUNT do
    PaGlobal_ServantSummonBoss._ui._moveList[ii] = UI.createAndCopyBasePropertyControl(PaGlobal_ServantSummonBoss._ui._stc_commandBG, "StaticText_MoveBasic", PaGlobal_ServantSummonBoss._ui._stc_commandBG, "StaticText_MoveBasic_" .. ii)
    PaGlobal_ServantSummonBoss._ui._moveList[ii]:SetShow(false)
  end
  for ii = 1, PaGlobal_ServantSummonBoss._MAX_ATTACK_COUNT do
    PaGlobal_ServantSummonBoss._ui._attackList[ii] = UI.createAndCopyBasePropertyControl(PaGlobal_ServantSummonBoss._ui._stc_commandBG, "StaticText_AttackBasic", PaGlobal_ServantSummonBoss._ui._stc_commandBG, "StaticText_AttackBasic_" .. ii)
    PaGlobal_ServantSummonBoss._ui._attackList[ii]:SetShow(false)
  end
  PaGlobal_ServantSummonBoss:registEventHandler()
  PaGlobal_ServantSummonBoss:validate()
  PaGlobal_ServantSummonBoss._initialize = true
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local selfProxy = getSelfPlayer():get()
  if nil == selfProxy then
    return
  end
  local actorKeyRaw = selfProxy:getRideVehicleActorKeyRaw()
  if nil == actorKeyRaw then
    return
  end
  local vehicleProxy = getVehicleActor(actorKeyRaw)
  if nil == vehicleProxy then
    return
  end
  local vehicleType = vehicleProxy:get():getVehicleType()
  if CppEnums.VehicleType.Type_BossMonster == vehicleType then
    PaGlobal_ServantSummonBoss_Open()
  end
end
function PaGlobal_ServantSummonBoss:registEventHandler()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  PaGlobal_ServantSummonBoss._ui._stc_progressBG:addInputEvent("Mouse_On", "HandleEventOn_ServantSummonBoss_HpBar()")
  PaGlobal_ServantSummonBoss._ui._stc_progressBG:addInputEvent("Mouse_Out", "HandleEventOut_ServantSummonBoss_HpBar()")
  registerEvent("EventSelfServantUpdate", "FromClient_ServantSummonBoss_EventSelfServantUpdate")
  registerEvent("EventSelfServantUpdateOnlyHp", "FromClient_ServantSummonBoss_EventSelfServantUpdate")
  registerEvent("EventSelfPlayerRideOff", "FromClient_ServantSummonBoss_EventSelfPlayerRideOff")
  registerEvent("EventSelfPlayerRideOn", "FromClient_ServantSummonBoss_EventSelfPlayerRideOn")
  registerEvent("EventSelfPlayerCarrierChanged", "FromClient_ServantSummonBoss_EventSelfPlayerCarrierChanged")
  registerEvent("FromClient_RenderModeChangeState", "FromClient_ServantSummonBoss_RenderModeChangeState")
end
function PaGlobal_ServantSummonBoss:prepareOpen()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  if false == _ContentsGroup_ServantSummonMonster or false == _ContentsGroup_ServantSummonMonster_InWar then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local selfProxy = getSelfPlayer():get()
  if nil == selfProxy then
    return
  end
  local actorKeyRaw = selfProxy:getRideVehicleActorKeyRaw()
  if nil == actorKeyRaw then
    return
  end
  local vehicleProxy = getVehicleActor(actorKeyRaw)
  if nil == vehicleProxy then
    return
  end
  local vehicleType = vehicleProxy:get():getVehicleType()
  if CppEnums.VehicleType.Type_BossMonster ~= vehicleType then
    return
  end
  PaGlobal_ServantSummonBoss._isShowSkillCommand = false
  if nil ~= Panel_SkillCommand and true == Panel_SkillCommand:GetShow() then
    PaGlobal_ServantSummonBoss._isShowSkillCommand = true
    Panel_SkillCommand:SetShow(false)
  end
  PaGlobal_ServantSummonBoss._ui._stc_commandBG:SetShow(false)
  PaGlobal_ServantSummonBoss:commandTextSet()
  PaGlobal_ServantSummonBoss:update()
  PaGlobal_ServantSummonBoss:open()
end
function PaGlobal_ServantSummonBoss:open()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  Panel_Widget_ServantSummonBoss:SetShow(true)
end
function PaGlobal_ServantSummonBoss:prepareClose()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  if true == PaGlobal_ServantSummonBoss._isShowSkillCommand and nil ~= Panel_SkillCommand then
    Panel_SkillCommand:SetShow(true)
  end
  for ii = 1, PaGlobal_ServantSummonBoss._MAX_MOVE_COUNT do
    PaGlobal_ServantSummonBoss._ui._moveList[ii]:SetShow(false)
  end
  for ii = 1, PaGlobal_ServantSummonBoss._MAX_ATTACK_COUNT do
    PaGlobal_ServantSummonBoss._ui._attackList[ii]:SetShow(false)
  end
  PaGlobal_ServantSummonBoss:close()
end
function PaGlobal_ServantSummonBoss:close()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  Panel_Widget_ServantSummonBoss:SetShow(false)
end
function PaGlobal_ServantSummonBoss:update()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local selfProxy = getSelfPlayer():get()
  if nil == selfProxy then
    return
  end
  local actorKeyRaw = selfProxy:getRideVehicleActorKeyRaw()
  if nil == actorKeyRaw then
    return
  end
  local vehicleProxy = getVehicleActor(actorKeyRaw)
  if nil == vehicleProxy then
    return
  end
  local vehicleType = vehicleProxy:get():getVehicleType()
  PaGlobal_ServantSummonBoss._ui._stc_progressBar:SetProgressRate(vehicleProxy:get():getHp() / vehicleProxy:get():getMaxHp() * 100)
  PaGlobal_ServantSummonBoss._ui._txt_hp:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SERVANT_HPBAR_LIFE", "getHp", makeDotMoney(vehicleProxy:get():getHp()), "getMaxHp", makeDotMoney(vehicleProxy:get():getMaxHp())))
end
function PaGlobal_ServantSummonBoss:validate()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  PaGlobal_ServantSummonBoss._ui._stc_progressBG:isValidate()
  PaGlobal_ServantSummonBoss._ui._stc_progressBar:isValidate()
end
function PaGlobal_ServantSummonBoss:commandTextSet()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local selfProxy = getSelfPlayer():get()
  if nil == selfProxy then
    return
  end
  local actorKeyRaw = selfProxy:getRideVehicleActorKeyRaw()
  if nil == actorKeyRaw then
    return
  end
  local vehicleProxy = getVehicleActor(actorKeyRaw)
  if nil == vehicleProxy then
    return
  end
  local getBossKey = vehicleProxy:getCharacterKey()
  local bossIndex = 0
  local moveCnt = 0
  local attackCnt = 0
  for index = 1, #PaGlobal_ServantSummonBoss._bossInfo do
    if PaGlobal_ServantSummonBoss._bossInfo[index]._actorkey == getBossKey then
      bossIndex = index
      moveCnt = #PaGlobal_ServantSummonBoss._bossInfo[index]._moveText
      attackCnt = #PaGlobal_ServantSummonBoss._bossInfo[index]._attackText
    end
  end
  if 0 == bossIndex then
    return
  end
  local lastSpanY = PaGlobal_ServantSummonBoss._ui._stc_moveTitle:GetSpanSize().y
  local maxSizeX = 0
  for ii = 1, moveCnt do
    PaGlobal_ServantSummonBoss._ui._moveList[ii]:SetShow(true)
    PaGlobal_ServantSummonBoss._ui._moveList[ii]:SetText(PaGlobal_ServantSummonBoss._bossInfo[bossIndex]._moveText[ii])
    PaGlobal_ServantSummonBoss._ui._moveList[ii]:SetSpanSize(PaGlobal_ServantSummonBoss._ui._moveList[ii]:GetSpanSize().x, lastSpanY + 20)
    lastSpanY = PaGlobal_ServantSummonBoss._ui._moveList[ii]:GetSpanSize().y
    if maxSizeX < PaGlobal_ServantSummonBoss._ui._moveList[ii]:GetTextSizeX() then
      maxSizeX = PaGlobal_ServantSummonBoss._ui._moveList[ii]:GetTextSizeX()
    end
  end
  PaGlobal_ServantSummonBoss._ui._stc_attackTitle:SetSpanSize(PaGlobal_ServantSummonBoss._ui._stc_attackTitle:GetSpanSize().x, lastSpanY + 20)
  lastSpanY = lastSpanY + 20
  for ii = 1, attackCnt do
    PaGlobal_ServantSummonBoss._ui._attackList[ii]:SetShow(true)
    PaGlobal_ServantSummonBoss._ui._attackList[ii]:SetText(PaGlobal_ServantSummonBoss._bossInfo[bossIndex]._attackText[ii])
    PaGlobal_ServantSummonBoss._ui._attackList[ii]:SetSpanSize(PaGlobal_ServantSummonBoss._ui._attackList[ii]:GetSpanSize().x, lastSpanY + 20)
    lastSpanY = PaGlobal_ServantSummonBoss._ui._attackList[ii]:GetSpanSize().y
    if maxSizeX < PaGlobal_ServantSummonBoss._ui._attackList[ii]:GetTextSizeX() then
      maxSizeX = PaGlobal_ServantSummonBoss._ui._attackList[ii]:GetTextSizeX()
    end
  end
  PaGlobal_ServantSummonBoss._ui._stc_commandBG:SetShow(true)
  PaGlobal_ServantSummonBoss._ui._stc_commandBG:SetSize(maxSizeX + 30, 60 + (moveCnt + attackCnt) * 20)
end
