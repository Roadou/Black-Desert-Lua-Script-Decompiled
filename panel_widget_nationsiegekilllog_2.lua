function PaGlobal_NationSiegeKillLog_Open()
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  if false == PaGlobal_NationSiegeKillLog._initialize then
    return
  end
  PaGlobal_NationSiegeKillLog:prepareOpen()
  PaGlobal_NationSiegeKillLog:open()
end
function PaGlobal_NationSiegeKillLog_Close()
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  PaGlobal_NationSiegeKillLog:prepareClose()
  PaGlobal_NationSiegeKillLog:close()
end
function FromClient_NationSiegePlayerDead(victimUserNo, victimRegionName, victimTeamTerritory, victimName, victimGuildName, killerTerritory, killerName, killerGuildName)
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  PaGlobal_NationSiegeKillLog:killEventDataSet(victimUserNo, victimRegionName, victimTeamTerritory, victimName, victimGuildName, killerTerritory, killerName, killerGuildName)
end
function PaGlobalFunc_NationSiegeKillLog_Update(deltaTime)
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  PaGlobal_NationSiegeKillLog:update(deltaTime)
end
