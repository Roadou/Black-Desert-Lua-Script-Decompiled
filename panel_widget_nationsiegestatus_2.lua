function FromClient_NationSiegeStatus_Start()
  PaGlobal_NationSiegeStatus:open()
end
function FromClient_NationSiegeStatus_Stop()
  PaGlobal_NationSiegeStatus:close()
end
function FromClient_NationSiegeStatus_BossHpChanged()
  PaGlobal_NationSiegeStatus:updateBossHpChanged()
end
function FromClient_NationSiegeStatus_UpdatePlayerCount()
  PaGlobal_NationSiegeStatus:updatePlayerCount()
end
function FromClient_NationSiegeStatus_renderModeChangeResetPosition(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  FromClient_NationSiegeStatus_ResetPosition()
end
function FromClient_NationSiegeStatus_ResetPosition()
  if Panel_Widget_NationSiegeStatus:GetRelativePosX() == -1 and Panel_Widget_NationSiegeStatus:GetRelativePosY() == -1 then
    local initPosX = getScreenSizeX() - Panel_Widget_NationSiegeStatus:GetSizeX() - 16
    local initPosY = FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 10
    local haveServerPosition = 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_MainQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved)
    if not haveServerPosition then
      Panel_Widget_NationSiegeStatus:SetPosX(initPosX)
      Panel_Widget_NationSiegeStatus:SetPosY(initPosY)
    end
    FGlobal_InitPanelRelativePos(Panel_Widget_NationSiegeStatus, initPosX, initPosY)
  elseif Panel_Widget_NationSiegeStatus:GetRelativePosX() == 0 and Panel_Widget_NationSiegeStatus:GetRelativePosY() == 0 then
    Panel_Widget_NationSiegeStatus:SetPosX(getScreenSizeX() - Panel_Widget_NationSiegeStatus:GetSizeX() - 16)
    Panel_Widget_NationSiegeStatus:SetPosY(FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 10)
  else
    Panel_Widget_NationSiegeStatus:SetPosX(getScreenSizeX() * Panel_Widget_NationSiegeStatus:GetRelativePosX() - Panel_MainQuest:GetSizeX() / 2)
    Panel_Widget_NationSiegeStatus:SetPosY(getScreenSizeY() * Panel_Widget_NationSiegeStatus:GetRelativePosY() - Panel_MainQuest:GetSizeY() / 2)
  end
  FGlobal_PanelRepostionbyScreenOut(Panel_Widget_NationSiegeStatus)
end
function FromClient_NationSiegeStatus_UpdateNationSiegeRevivePoint(point)
  PaGlobal_NationSiegeStatus:updateRevivePoint(point)
end
