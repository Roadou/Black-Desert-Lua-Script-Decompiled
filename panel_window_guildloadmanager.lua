PaGlobal_GuildPanelLoad = {
  _eType = {
    _guildMain = 1,
    _guildAllianceInfo = 2,
    _guildAllianceList = 3,
    _guildManufacture = 4,
    _guildVolunteer = 5,
    _guildWarfare = 6,
    _guildSkill = 7,
    _guildRecruitment = 8,
    _guildQuest = 9,
    _guildList = 10,
    _guildHistory = 11,
    _guildCraftInfo = 12,
    _guildBattle = 13
  }
}
function PaGlobal_GuildPanelLoad:setPanel(ePanelType, panel)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_GuildPanelLoad:setPanel ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panel, "PaGlobal_GuildPanelLoad:setPanel panel nil", "\236\178\156\235\167\140\234\184\176")
  if PaGlobal_GuildPanelLoad._eType._guildMain == ePanelType then
    Panel_Window_Guild = panel
  elseif PaGlobal_GuildPanelLoad._eType._guildAllianceInfo == ePanelType then
    Panel_Guild_AllianceInfo = panel
  elseif PaGlobal_GuildPanelLoad._eType._guildAllianceList == ePanelType then
    Panel_Guild_Alliance_List = panel
  elseif PaGlobal_GuildPanelLoad._eType._guildManufacture == ePanelType then
    Panel_Guild_Manufacture = panel
  elseif PaGlobal_GuildPanelLoad._eType._guildVolunteer == ePanelType then
    Panel_Guild_Volunteer = panel
  elseif PaGlobal_GuildPanelLoad._eType._guildWarfare == ePanelType then
    Panel_Guild_Warfare = panel
  elseif PaGlobal_GuildPanelLoad._eType._guildSkill == ePanelType then
    Panel_Guild_Skill = panel
  elseif PaGlobal_GuildPanelLoad._eType._guildRecruitment == ePanelType then
    Panel_Guild_Recruitment = panel
  elseif PaGlobal_GuildPanelLoad._eType._guildQuest == ePanelType then
    Panel_Guild_Quest = panel
  elseif PaGlobal_GuildPanelLoad._eType._guildList == ePanelType then
    Panel_Guild_List = panel
  elseif PaGlobal_GuildPanelLoad._eType._guildHistory == ePanelType then
    Panel_Guild_Journal = panel
  elseif PaGlobal_GuildPanelLoad._eType._guildCraftInfo == ePanelType then
    Panel_Guild_CraftInfo = panel
  elseif PaGlobal_GuildPanelLoad._eType._guildBattle == ePanelType then
    Panel_Window_GuildBattle = panel
  end
end
function PaGlobal_GuildPanelLoad:getPanel(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_GuildPanelLoad:getPanel ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  if PaGlobal_GuildPanelLoad._eType._guildMain == ePanelType then
    return Panel_Window_Guild
  elseif PaGlobal_GuildPanelLoad._eType._guildAllianceInfo == ePanelType then
    return Panel_Guild_AllianceInfo
  elseif PaGlobal_GuildPanelLoad._eType._guildAllianceList == ePanelType then
    return Panel_Guild_Alliance_List
  elseif PaGlobal_GuildPanelLoad._eType._guildManufacture == ePanelType then
    return Panel_Guild_Manufacture
  elseif PaGlobal_GuildPanelLoad._eType._guildVolunteer == ePanelType then
    return Panel_Guild_Volunteer
  elseif PaGlobal_GuildPanelLoad._eType._guildWarfare == ePanelType then
    return Panel_Guild_Warfare
  elseif PaGlobal_GuildPanelLoad._eType._guildSkill == ePanelType then
    return Panel_Guild_Skill
  elseif PaGlobal_GuildPanelLoad._eType._guildRecruitment == ePanelType then
    return Panel_Guild_Recruitment
  elseif PaGlobal_GuildPanelLoad._eType._guildQuest == ePanelType then
    return Panel_Guild_Quest
  elseif PaGlobal_GuildPanelLoad._eType._guildList == ePanelType then
    return Panel_Guild_List
  elseif PaGlobal_GuildPanelLoad._eType._guildHistory == ePanelType then
    return Panel_Guild_Journal
  elseif PaGlobal_GuildPanelLoad._eType._guildCraftInfo == ePanelType then
    return Panel_Guild_CraftInfo
  elseif PaGlobal_GuildPanelLoad._eType._guildBattle == ePanelType then
    return Panel_Window_GuildBattle
  end
  return nil
end
function PaGlobal_GuildPanelLoad:checkLoadUI(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_GuildPanelLoad:checkLoadUI ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  local rv
  if PaGlobal_GuildPanelLoad._eType._guildMain == ePanelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Panel_Guild.XML", "Panel_Window_Guild", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_GuildPanelLoad._eType._guildAllianceInfo == ePanelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Panel_Guild_AllianceInfo.XML", "Panel_Guild_AllianceInfo", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_GuildPanelLoad._eType._guildAllianceList == ePanelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Frame_Guild_AllianceList_New.XML", "Panel_Guild_Alliance_List", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_GuildPanelLoad._eType._guildManufacture == ePanelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Frame_Guild_Manufacture_New.XML", "Panel_Guild_Manufacture", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_GuildPanelLoad._eType._guildVolunteer == ePanelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Frame_Guild_Volunteer.XML", "Panel_Guild_Volunteer", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_GuildPanelLoad._eType._guildWarfare == ePanelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Frame_Guild_Warfare.XML", "Panel_Guild_Warfare", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_GuildPanelLoad._eType._guildSkill == ePanelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Frame_Guild_Skill.XML", "Panel_Guild_Skill", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_GuildPanelLoad._eType._guildRecruitment == ePanelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Frame_Guild_Recruitment.XML", "Panel_Guild_Recruitment", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_GuildPanelLoad._eType._guildQuest == ePanelType then
    if true == _ContentsGroup_GuildQuestSystem then
      rv = reqLoadUI("UI_Data/Window/Guild/Frame_Guild_Quest_New.XML", "Panel_Guild_Quest", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
        Defines.RenderMode.eRenderMode_Default
      }))
    else
      rv = reqLoadUI("UI_Data/Window/Guild/Frame_Guild_Quest.XML", "Panel_Guild_Quest", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
        Defines.RenderMode.eRenderMode_Default
      }))
    end
  elseif PaGlobal_GuildPanelLoad._eType._guildList == ePanelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Frame_Guild_List.XML", "Panel_Guild_List", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_GuildPanelLoad._eType._guildHistory == ePanelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Panel_Guild_Journal.XML", "Panel_Guild_Journal", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_GuildPanelLoad._eType._guildCraftInfo == ePanelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Frame_Guild_CraftInfo.XML", "Panel_Guild_CraftInfo", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_GuildPanelLoad._eType._guildBattle == ePanelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Panel_Window_GuildBattle.XML", "Panel_Window_GuildBattle", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  end
  if nil ~= rv then
    PaGlobal_GuildPanelLoad:setPanel(ePanelType, rv)
    rv = nil
    PaGlobal_GuildPanelLoad:initialize(ePanelType)
  end
end
function PaGlobal_GuildPanelLoad:initialize(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_GuildPanelLoad:initialize ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  if PaGlobal_GuildPanelLoad._eType._guildMain == ePanelType then
    PaGlobal_Guild_initialize()
  elseif PaGlobal_GuildPanelLoad._eType._guildAllianceInfo == ePanelType then
    PaGlobal_GuildAllianceInfo_Initialize()
  elseif PaGlobal_GuildPanelLoad._eType._guildAllianceList == ePanelType then
    PaGlobal_GuildAllianceList_Initialize()
  elseif PaGlobal_GuildPanelLoad._eType._guildManufacture == ePanelType then
    PaGlobal_GuildManufacture_Init()
  elseif PaGlobal_GuildPanelLoad._eType._guildVolunteer == ePanelType then
    PaGlobal_GuildVolunteerList_Init()
  elseif PaGlobal_GuildPanelLoad._eType._guildWarfare == ePanelType then
    PaGlobal_GuildWarfare_Init()
  elseif PaGlobal_GuildPanelLoad._eType._guildSkill == ePanelType then
    PaGlobal_GuildSkill_Init()
  elseif PaGlobal_GuildPanelLoad._eType._guildRecruitment == ePanelType then
    PaGlobal_GuildRecruitment_Init()
  elseif PaGlobal_GuildPanelLoad._eType._guildQuest == ePanelType then
    PaGlobal_GuildQuest_Init()
  elseif PaGlobal_GuildPanelLoad._eType._guildList == ePanelType then
    PaGlobal_GuildList_Init()
  elseif PaGlobal_GuildPanelLoad._eType._guildHistory == ePanelType then
    PaGlobal_GuildHistory_Init()
  elseif PaGlobal_GuildPanelLoad._eType._guildCraftInfo == ePanelType then
    PaGlobal_GuildCraftInfo_Init()
  elseif PaGlobal_GuildPanelLoad._eType._guildBattle == ePanelType then
    PaGlobal_GuildBattle_Init()
  end
end
function PaGlobal_GuildPanelLoad:checkCloseUI(ePanelType, isAni)
  if nil == ePanelType then
    return
  end
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_GuildPanelLoad:checkCloseUI ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  local panel = PaGlobal_GuildPanelLoad:getPanel(ePanelType)
  if nil == panel then
    return
  end
  reqCloseUI(panel, isAni)
end
function PaGlobal_GuildPanelLoad:getShowPanel(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_GuildPanelLoad:getShowPanel ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  local panel = PaGlobal_GuildPanelLoad:getPanel(ePanelType)
  if nil == panel then
    return false
  end
  return panel:GetShow()
end
function PaGlobal_GuildPanelLoad:isUISubApp(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_GuildPanelLoad:isUISubApp ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  local panel = PaGlobal_GuildPanelLoad:getPanel(ePanelType)
  if nil == panel then
    return false
  end
  return panel:IsUISubApp()
end
function PaGlobal_GuildPanelLoad_CheckLoadUIAll()
  PaGlobal_GuildPanelLoad:checkLoadUI(PaGlobal_GuildPanelLoad._eType._guildMain)
  for k, v in pairs(PaGlobal_GuildPanelLoad._eType) do
    if PaGlobal_GuildPanelLoad._eType._guildMain ~= v then
      PaGlobal_GuildPanelLoad:checkLoadUI(v)
    end
  end
  PaGlobal_Guild_SetPanelPosFromSavePos()
end
function PaGlobal_GuildPanelLoad_CheckCloseUIAll(isAni)
  for k, v in pairs(PaGlobal_GuildPanelLoad._eType) do
    PaGlobal_GuildPanelLoad:checkCloseUI(v, isAni)
  end
  PaGlobal_Guild_SavePosFromPanelPos()
end
function PaGlobal_GuildPanelLoad_SetShowPanelGuildMain(isShow, isAni)
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_GuildPanelLoad_SetShowPanelGuildMain isShow nil", "\236\178\156\235\167\140\234\184\176")
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Window_Guild:SetShow(isShow, isAni)
    return
  end
  if true == isShow then
    PaGlobal_GuildPanelLoad_CheckLoadUIAll()
    if nil ~= Panel_Window_Guild then
      Panel_Window_Guild:SetShow(isShow, isAni)
    end
  else
    PaGlobal_GuildPanelLoad_CheckCloseUIAll(isAni)
  end
end
function PaGlobal_GuildPanelLoad_GetShowPanelGuildMain()
  return PaGlobal_GuildPanelLoad:getShowPanel(PaGlobal_GuildPanelLoad._eType._guildMain)
end
