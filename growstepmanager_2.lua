function FromClient_GrowStepManager_notifyUpdateGrowStep(contentType)
  local menuCategory = PaGlobal_Menu._categoryData
  local menuContents = PaGlobal_Menu._contents
  if __eGrowStep_worldmap2 == contentType then
    PaGlobal_GrowStepManager._isOnce.worldMap2 = true
  elseif __eGrowStep_worldmap3 == contentType then
    PaGlobal_GrowStepManager._isOnce.worldMap3 = true
  elseif __eGrowStep_blackSpirit == contentType then
  elseif __eGrowStep_questWindow == contentType then
  elseif __eGrowStep_skillWindow == contentType then
    menuCategory[1][PaGlobal_Menu._contents._skill]._isContentOpen = ToClient_IsGrowStepOpen(__eGrowStep_skillWindow)
  elseif __eGrowStep_manufacture == contentType then
    menuCategory[1][PaGlobal_Menu._contents._manufacture]._isContentOpen = ToClient_IsGrowStepOpen(__eGrowStep_manufacture)
  elseif __eGrowStep_blackSpiritAdventure == contentType then
  elseif __eGrowStep_oldBook == contentType then
    menuCategory[1][PaGlobal_Menu._contents._achievementBookshelf]._isContentOpen = PaGlobal_Menu._contentsGroup._isAchievementBookshelfOpen and ToClient_IsGrowStepOpen(__eGrowStep_oldBook)
  elseif __eGrowStep_localWar == contentType then
    menuCategory[2][PaGlobal_Menu._cooperation._localWar]._isContentOpen = PaGlobal_Menu._contentsGroup._isLocalwarOpen and ToClient_IsGrowStepOpen(__eGrowStep_localWar)
  elseif __eGrowStep_freeFight == contentType then
    menuCategory[2][PaGlobal_Menu._cooperation._freeFighting]._isContentOpen = PaGlobal_Menu._contentsGroup._isFreeFight and ToClient_IsGrowStepOpen(__eGrowStep_freeFight)
  elseif __eGrowStep_savageDefence == contentType then
    menuCategory[2][PaGlobal_Menu._cooperation._waveDefence]._isContentOpen = PaGlobal_Menu._contentsGroup._isSavageOpen and ToClient_IsGrowStepOpen(__eGrowStep_savageDefence)
  elseif __eGrowStep_arsha == contentType then
    menuCategory[2][PaGlobal_Menu._cooperation._arsha]._isContentOpen = PaGlobal_Menu._contentsGroup._isContentsArsha and ToClient_IsGrowStepOpen(__eGrowStep_arsha)
  elseif __eGrowStep_militia == contentType then
    menuCategory[2][PaGlobal_Menu._cooperation._militia]._isContentOpen = PaGlobal_Menu._contentsGroup._isMercenaryOpen and ToClient_IsGrowStepOpen(__eGrowStep_militia)
  elseif __eGrowStep_teamDuel == contentType then
    menuCategory[2][PaGlobal_Menu._cooperation._teamDuel]._isContentOpen = PaGlobal_Menu._contentsGroup._isTeamDuelOpen and ToClient_IsGrowStepOpen(__eGrowStep_teamDuel)
  elseif __eGrowStep_worldmap1 == contentType then
  elseif __eGrowStep_worker == contentType then
    menuCategory[3][PaGlobal_Menu._infomation._workerList]._isContentOpen = ToClient_IsGrowStepOpen(__eGrowStep_worker)
  elseif __eGrowStep_trade == contentType then
    menuCategory[3][PaGlobal_Menu._infomation._tradeInfo]._isContentOpen = PaGlobal_Menu._contentsGroup._isTradeEventOpen and ToClient_IsGrowStepOpen(__eGrowStep_trade)
  elseif __eGrowStep_guildWarInfo == contentType then
    menuCategory[3][PaGlobal_Menu._infomation._warInfo]._isContentOpen = PaGlobal_Menu._contentsGroup._isSiegeEnable and ToClient_IsGrowStepOpen(__eGrowStep_guildWarInfo)
  elseif __eGrowStep_dropItem == contentType then
  elseif __eGrowStep_bossAlert == contentType then
    menuCategory[3][PaGlobal_Menu._infomation._bossAlert]._isContentOpen = _ContetnsGroup_BossAlert and ToClient_IsGrowStepOpen(__eGrowStep_bossAlert)
  elseif __eGrowStep_guild == contentType then
  end
  PaGlobal_Menu:SetCustomWindow()
end
