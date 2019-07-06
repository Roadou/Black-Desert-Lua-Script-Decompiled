Panel_CompetitionGame_TeamUi:SetShow(false)
local UI_color = Defines.Color
local teamMemberBg = UI.getChildControl(Panel_CompetitionGame_TeamUi, "Static_TeamMemberBg")
local team1 = 0
local team2 = 1
local teamMemberUi = {}
for index = 0, CppEnums.CompetitionFreeForAll.eFreeForAllTeamLimit - 1 do
  teamMemberUi[index] = {}
end
local teamMember = {
  _classIcon = UI.getChildControl(teamMemberBg, "Static_ClassIcon"),
  _gaugeBlackBG = UI.getChildControl(teamMemberBg, "Static_BlackSpiritBG"),
  _gaugeBlack = UI.getChildControl(teamMemberBg, "BlackSpirtGauge"),
  _level = UI.getChildControl(teamMemberBg, "StaticText_Level"),
  _progressBg = UI.getChildControl(teamMemberBg, "Static_Hp_ProgressBg"),
  _hpProgress = UI.getChildControl(teamMemberBg, "Static_Hp_Progress"),
  _name = UI.getChildControl(teamMemberBg, "StaticText_CharacterName"),
  _myBorder = UI.getChildControl(teamMemberBg, "Static_MyInfoBorder"),
  _leftUserCount = UI.getChildControl(teamMemberBg, "StaticText_LeftCount"),
  _skillIcon1 = UI.getChildControl(teamMemberBg, "StaticText_SkillIcon1"),
  _skillIcon2 = UI.getChildControl(teamMemberBg, "StaticText_SkillIcon2"),
  _skillIcon3 = UI.getChildControl(teamMemberBg, "StaticText_SkillIcon3"),
  _skillIcon4 = UI.getChildControl(teamMemberBg, "StaticText_SkillIcon4"),
  _skillIcon5 = UI.getChildControl(teamMemberBg, "StaticText_SkillIcon5"),
  _gaugeRate = UI.getChildControl(teamMemberBg, "StaticText_ProgressRateText"),
  _hpNumber = UI.getChildControl(teamMemberBg, "StaticText_HpNumber")
}
local controlTexture = {
  path = "New_UI_Common_ForLua/Window/Pvp/pvp_etc.dds",
  path2 = "New_UI_Common_ForLua/Default/Default_Gauges_01.dds",
  path3 = "New_UI_Common_ForLua/Window/Pvp/PvP_etc_01.dds",
  classIcon = {
    [team1] = {
      [__eClassType_Warrior] = {
        291,
        251,
        320,
        280
      },
      [__eClassType_ElfRanger] = {
        355,
        251,
        384,
        280
      },
      [__eClassType_Sorcerer] = {
        3,
        251,
        32,
        280
      },
      [__eClassType_Giant] = {
        227,
        251,
        256,
        280
      },
      [__eClassType_Tamer] = {
        323,
        251,
        352,
        280
      },
      [__eClassType_BladeMaster] = {
        35,
        251,
        64,
        280
      },
      [__eClassType_BladeMasterWoman] = {
        67,
        251,
        96,
        280
      },
      [__eClassType_Valkyrie] = {
        259,
        251,
        288,
        280
      },
      [__eClassType_Kunoichi] = {
        131,
        251,
        160,
        280
      },
      [__eClassType_NinjaMan] = {
        99,
        251,
        128,
        280
      },
      [__eClassType_WizardMan] = {
        195,
        251,
        224,
        280
      },
      [__eClassType_WizardWoman] = {
        163,
        251,
        192,
        280
      },
      [__eClassType_DarkElf] = {
        387,
        251,
        416,
        280
      },
      [__eClassType_Combattant] = {
        419,
        219,
        448,
        248
      },
      [__eClassType_Mystic] = {
        451,
        251,
        480,
        280
      },
      [__eClassType_Lhan] = {
        481,
        251,
        510,
        280
      },
      [__eClassType_RangerMan] = {
        481,
        283,
        510,
        312
      },
      [__eClassType_ShyWaman] = {
        481,
        376,
        510,
        405
      }
    },
    [team2] = {
      [__eClassType_Warrior] = {
        291,
        219,
        320,
        248
      },
      [__eClassType_ElfRanger] = {
        355,
        219,
        384,
        248
      },
      [__eClassType_Sorcerer] = {
        3,
        219,
        32,
        248
      },
      [__eClassType_Giant] = {
        227,
        219,
        256,
        248
      },
      [__eClassType_Tamer] = {
        323,
        219,
        352,
        248
      },
      [__eClassType_BladeMaster] = {
        35,
        219,
        64,
        248
      },
      [__eClassType_BladeMasterWoman] = {
        67,
        219,
        96,
        248
      },
      [__eClassType_Valkyrie] = {
        259,
        219,
        288,
        248
      },
      [__eClassType_Kunoichi] = {
        131,
        219,
        160,
        248
      },
      [__eClassType_NinjaMan] = {
        99,
        219,
        128,
        248
      },
      [__eClassType_WizardMan] = {
        195,
        219,
        224,
        248
      },
      [__eClassType_WizardWoman] = {
        163,
        219,
        192,
        248
      },
      [__eClassType_DarkElf] = {
        387,
        219,
        416,
        248
      },
      [__eClassType_Combattant] = {
        419,
        251,
        448,
        280
      },
      [__eClassType_Mystic] = {
        451,
        219,
        480,
        248
      },
      [__eClassType_Lhan] = {
        481,
        219,
        510,
        248
      },
      [__eClassType_RangerMan] = {
        481,
        314,
        510,
        343
      },
      [__eClassType_ShyWaman] = {
        481,
        345,
        510,
        374
      }
    }
  },
  teamBlack = {
    [team1] = {
      48,
      2,
      83,
      37
    },
    [team2] = {
      84,
      2,
      119,
      37
    }
  },
  teamBg = {
    [team1] = {
      1,
      87,
      187,
      126
    },
    [team2] = {
      1,
      46,
      187,
      85
    }
  },
  border = {
    [team1] = {
      117,
      1,
      156,
      40
    },
    [team2] = {
      158,
      1,
      197,
      40
    }
  },
  progress = {
    [team1] = {
      33,
      29,
      41,
      36
    },
    [team2] = {
      46,
      29,
      54,
      36
    }
  },
  progressBg = {
    [team1] = {
      78,
      26,
      94,
      41
    },
    [team2] = {
      96,
      26,
      112,
      41
    }
  }
}
function CompetitionGame_TeamUi_Create()
  if 0 == ToClient_CompetitionMatchType() then
    CompetitionGame_TeamUi_Round()
  elseif 1 == ToClient_CompetitionMatchType() then
    CompetitionGame_TeamUi_FreeForAll()
  elseif 2 == ToClient_CompetitionMatchType() then
    CompetitionGame_TeamUi_Personal()
  end
end
function CompetitionGame_FreeForAllSlotReset()
  for i = 0, CppEnums.CompetitionFreeForAll.eFreeForAllTeamLimit - 1 do
    CompetitionGame_StatSlotSetShow(0, i, false, true)
  end
end
function CompetitionGame_StatSlotSetShow(teamIndex, userIndex, isVisible, isFree)
  if teamMemberUi[teamIndex][userIndex] ~= nil then
    teamMemberUi[teamIndex][userIndex]._teamBg:SetShow(isVisible)
    teamMemberUi[teamIndex][userIndex]._border:SetShow(isVisible)
    teamMemberUi[teamIndex][userIndex]._classIcon:SetShow(isVisible)
    teamMemberUi[teamIndex][userIndex]._level:SetShow(isVisible)
    teamMemberUi[teamIndex][userIndex]._progress:SetShow(isVisible)
    teamMemberUi[teamIndex][userIndex]._progressBg:SetShow(isVisible)
    teamMemberUi[teamIndex][userIndex]._name:SetShow(isVisible)
    teamMemberUi[teamIndex][userIndex]._leftUserCount:SetShow(isVisible)
    if 1 == ToClient_CompetitionMatchType() or 2 == ToClient_CompetitionMatchType() then
      teamMemberUi[teamIndex][userIndex]._skillIcon1:SetShow(false)
      teamMemberUi[teamIndex][userIndex]._skillIcon2:SetShow(false)
      teamMemberUi[teamIndex][userIndex]._skillIcon3:SetShow(false)
      teamMemberUi[teamIndex][userIndex]._skillIcon4:SetShow(false)
      teamMemberUi[teamIndex][userIndex]._skillIcon5:SetShow(false)
      teamMemberUi[teamIndex][userIndex]._gaugeBlackBG:SetShow(false)
      teamMemberUi[teamIndex][userIndex]._gaugeBlack:SetShow(false)
      teamMemberUi[teamIndex][userIndex]._gaugeRate:SetShow(false)
    end
  end
end
function CompetitionGame_TeamUi_Round()
  local playerWrapper = getSelfPlayer()
  local myTeamNo = playerWrapper:getCompetitionTeamNo()
  local teamCount = ToClient_GetTeamListCountWithOutZero()
  teamMember._myBorder:SetShow(true)
  teamMember._classIcon:SetShow(true)
  teamMember._level:SetShow(true)
  teamMember._hpProgress:SetShow(true)
  teamMember._hpNumber:SetShow(true)
  teamMemberBg:SetShow(true)
  teamMember._progressBg:SetShow(true)
  teamMember._name:SetShow(true)
  teamMember._leftUserCount:SetShow(true)
  teamMember._skillIcon1:SetShow(true)
  teamMember._skillIcon2:SetShow(true)
  teamMember._skillIcon3:SetShow(true)
  teamMember._skillIcon4:SetShow(true)
  teamMember._skillIcon5:SetShow(true)
  teamMember._gaugeBlackBG:SetShow(true)
  teamMember._gaugeBlack:SetShow(true)
  teamMember._gaugeRate:SetShow(true)
  CompetitionGameTeamUI_StatSlotClose_Round()
  for Index = 0, teamCount - 1 do
    local teamInfo = ToClient_GetTeamListAt(Index)
    local teamNo = teamInfo:getTeamNo()
    local teamUserCount = ToClient_GetTeamUserInfoCount(teamNo)
    local textureIndex = 1
    if 1 == teamNo then
      textureIndex = 0
    elseif 2 == teamNo then
      textureIndex = 1
    end
    for userIndex = 0, teamUserCount - 1 do
      local temp = {}
      temp._teamBg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CompetitionGame_TeamUi, "CompetitionGame_TeamBg_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMemberBg, temp._teamBg)
      temp._teamBg:SetPosY((teamMemberBg:GetSizeY() + 5) * userIndex)
      temp._teamBg:SetPosX((teamMemberBg:GetSizeX() + 5) * Index)
      temp._teamBg:ChangeTextureInfoName(controlTexture.path)
      local x1, y1, x2, y2 = setTextureUV_Func(temp._teamBg, controlTexture.teamBg[textureIndex][1], controlTexture.teamBg[textureIndex][2], controlTexture.teamBg[textureIndex][3], controlTexture.teamBg[textureIndex][4])
      temp._teamBg:getBaseTexture():setUV(x1, y1, x2, y2)
      temp._teamBg:setRenderTexture(temp._teamBg:getBaseTexture())
      temp._classIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._teamBg, "CompetitionGame_TeamClassIcon_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._classIcon, temp._classIcon)
      temp._gaugeBlackBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._teamBg, "CompetitionGame_gaugeBlackBG_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._gaugeBlackBG, temp._gaugeBlackBG)
      temp._gaugeBlack = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CIRCULAR_PROGRESS, temp._teamBg, "CompetitionGame_gaugeBlack_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._gaugeBlack, temp._gaugeBlack)
      temp._progressBg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._teamBg, "CompetitionGame_TeamClassProgressBg_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._progressBg, temp._progressBg)
      temp._progressBg:ChangeTextureInfoName(controlTexture.path)
      local x1, y1, x2, y2 = setTextureUV_Func(temp._progressBg, controlTexture.progressBg[textureIndex][1], controlTexture.progressBg[textureIndex][2], controlTexture.progressBg[textureIndex][3], controlTexture.progressBg[textureIndex][4])
      temp._progressBg:getBaseTexture():setUV(x1, y1, x2, y2)
      temp._progressBg:setRenderTexture(temp._progressBg:getBaseTexture())
      temp._progress = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_PROGRESS2, temp._teamBg, "CompetitionGame_TeamClassProgress_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._hpProgress, temp._progress)
      temp._progress:ChangeTextureInfoName(controlTexture.path)
      local x1, y1, x2, y2 = setTextureUV_Func(temp._progress, controlTexture.progress[textureIndex][1], controlTexture.progress[textureIndex][2], controlTexture.progress[textureIndex][3], controlTexture.progress[textureIndex][4])
      temp._progress:getBaseTexture():setUV(x1, y1, x2, y2)
      temp._progress:setRenderTexture(temp._progress:getBaseTexture())
      temp._hpNumber = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_HPNumber_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._hpNumber, temp._hpNumber)
      temp._level = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_TeamClassLevel_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._level, temp._level)
      temp._name = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_TeamClassName_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._name, temp._name)
      temp._leftUserCount = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_LeftUserCount_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._leftUserCount, temp._leftUserCount)
      temp._skillIcon1 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon1_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._skillIcon1, temp._skillIcon1)
      temp._skillIcon2 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon2_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._skillIcon2, temp._skillIcon2)
      temp._skillIcon3 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon3_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._skillIcon3, temp._skillIcon3)
      temp._skillIcon4 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon4_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._skillIcon4, temp._skillIcon4)
      temp._skillIcon5 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon5_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._skillIcon5, temp._skillIcon5)
      temp._gaugeRate = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_gaugeBlackRate_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._gaugeRate, temp._gaugeRate)
      temp._border = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._teamBg, "CompetitionGame_TeamClassBorder_" .. Index .. "_" .. userIndex)
      CopyBaseProperty(teamMember._myBorder, temp._border)
      temp._border:ChangeTextureInfoName(controlTexture.path)
      local x1, y1, x2, y2 = setTextureUV_Func(temp._border, controlTexture.border[textureIndex][1], controlTexture.border[textureIndex][2], controlTexture.border[textureIndex][3], controlTexture.border[textureIndex][4])
      temp._border:getBaseTexture():setUV(x1, y1, x2, y2)
      temp._border:setRenderTexture(temp._border:getBaseTexture())
      teamMemberUi[teamNo - 1][userIndex] = temp
    end
    CompetitionGame_TeamUI_Setting(teamNo, teamUserCount)
  end
  teamMember._myBorder:SetShow(false)
  teamMember._classIcon:SetShow(false)
  teamMember._level:SetShow(false)
  teamMember._hpProgress:SetShow(false)
  teamMember._hpNumber:SetShow(false)
  teamMemberBg:SetShow(false)
  teamMember._progressBg:SetShow(false)
  teamMember._name:SetShow(false)
  teamMember._leftUserCount:SetShow(false)
  teamMember._skillIcon1:SetShow(false)
  teamMember._skillIcon2:SetShow(false)
  teamMember._skillIcon3:SetShow(false)
  teamMember._skillIcon4:SetShow(false)
  teamMember._skillIcon5:SetShow(false)
  teamMember._gaugeBlackBG:SetShow(false)
  teamMember._gaugeBlack:SetShow(false)
  teamMember._gaugeRate:SetShow(false)
  CompetitionGameTeamUI_Open()
end
function CompetitionGame_TeamUi_FreeForAll()
  local playerWrapper = getSelfPlayer()
  local myTeamNo = playerWrapper:getCompetitionTeamNo()
  local teamCount = ToClient_GetTeamListCountWithOutZero()
  teamMember._myBorder:SetShow(true)
  teamMember._classIcon:SetShow(true)
  teamMember._level:SetShow(true)
  teamMember._hpProgress:SetShow(true)
  teamMember._hpNumber:SetShow(true)
  teamMemberBg:SetShow(true)
  teamMember._progressBg:SetShow(true)
  teamMember._name:SetShow(true)
  teamMember._leftUserCount:SetShow(true)
  teamMember._skillIcon1:SetShow(false)
  teamMember._skillIcon2:SetShow(false)
  teamMember._skillIcon3:SetShow(false)
  teamMember._skillIcon4:SetShow(false)
  teamMember._skillIcon5:SetShow(false)
  teamMember._gaugeBlackBG:SetShow(false)
  teamMember._gaugeBlack:SetShow(false)
  teamMember._gaugeRate:SetShow(false)
  CompetitionGame_FreeForAllSlotReset()
  for teamIndex = 0, teamCount - 1 do
    local teamInfo = ToClient_GetTeamListAt(teamIndex)
    local teamNo = teamInfo:getTeamNo()
    local textureIndex = 0
    if myTeamNo == teamNo then
      textureIndex = 1
    end
    local temp = {}
    temp._teamBg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CompetitionGame_TeamUi, "CompetitionGame_TeamBg_" .. teamIndex)
    CopyBaseProperty(teamMemberBg, temp._teamBg)
    temp._teamBg:SetPosY((teamMemberBg:GetSizeY() + 5) * teamIndex)
    temp._teamBg:ChangeTextureInfoName(controlTexture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(temp._teamBg, controlTexture.teamBg[textureIndex][1], controlTexture.teamBg[textureIndex][2], controlTexture.teamBg[textureIndex][3], controlTexture.teamBg[textureIndex][4])
    temp._teamBg:getBaseTexture():setUV(x1, y1, x2, y2)
    temp._teamBg:setRenderTexture(temp._teamBg:getBaseTexture())
    temp._classIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._teamBg, "CompetitionGame_TeamClassIcon_" .. teamIndex)
    CopyBaseProperty(teamMember._classIcon, temp._classIcon)
    temp._gaugeBlackBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._teamBg, "CompetitionGame_gaugeBlackBG_" .. teamIndex)
    CopyBaseProperty(teamMember._gaugeBlackBG, temp._gaugeBlackBG)
    temp._gaugeBlack = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CIRCULAR_PROGRESS, temp._teamBg, "CompetitionGame_gaugeBlack_" .. teamIndex)
    CopyBaseProperty(teamMember._gaugeBlack, temp._gaugeBlack)
    temp._progressBg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._teamBg, "CompetitionGame_TeamClassProgressBg_" .. teamIndex)
    CopyBaseProperty(teamMember._progressBg, temp._progressBg)
    temp._progressBg:ChangeTextureInfoName(controlTexture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(temp._progressBg, controlTexture.progressBg[textureIndex][1], controlTexture.progressBg[textureIndex][2], controlTexture.progressBg[textureIndex][3], controlTexture.progressBg[textureIndex][4])
    temp._progressBg:getBaseTexture():setUV(x1, y1, x2, y2)
    temp._progressBg:setRenderTexture(temp._progressBg:getBaseTexture())
    temp._progress = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_PROGRESS2, temp._teamBg, "CompetitionGame_TeamClassProgress_" .. teamIndex)
    CopyBaseProperty(teamMember._hpProgress, temp._progress)
    temp._progress:ChangeTextureInfoName(controlTexture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(temp._progress, controlTexture.progress[textureIndex][1], controlTexture.progress[textureIndex][2], controlTexture.progress[textureIndex][3], controlTexture.progress[textureIndex][4])
    temp._progress:getBaseTexture():setUV(x1, y1, x2, y2)
    temp._progress:setRenderTexture(temp._progress:getBaseTexture())
    temp._hpNumber = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_HPNumber_" .. teamIndex)
    CopyBaseProperty(teamMember._hpNumber, temp._hpNumber)
    temp._level = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_TeamClassLevel_" .. teamIndex)
    CopyBaseProperty(teamMember._level, temp._level)
    temp._name = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_TeamClassName_" .. teamIndex)
    CopyBaseProperty(teamMember._name, temp._name)
    temp._leftUserCount = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_LeftUserCount_" .. teamIndex)
    CopyBaseProperty(teamMember._leftUserCount, temp._leftUserCount)
    temp._skillIcon1 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon1_" .. teamIndex)
    CopyBaseProperty(teamMember._skillIcon1, temp._skillIcon1)
    temp._skillIcon2 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon2_" .. teamIndex)
    CopyBaseProperty(teamMember._skillIcon2, temp._skillIcon2)
    temp._skillIcon3 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon3_" .. teamIndex)
    CopyBaseProperty(teamMember._skillIcon3, temp._skillIcon3)
    temp._skillIcon4 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon4_" .. teamIndex)
    CopyBaseProperty(teamMember._skillIcon4, temp._skillIcon4)
    temp._skillIcon5 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon5_" .. teamIndex)
    CopyBaseProperty(teamMember._skillIcon5, temp._skillIcon5)
    temp._gaugeRate = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_gaugeBlackRate_" .. teamIndex)
    CopyBaseProperty(teamMember._gaugeRate, temp._gaugeRate)
    temp._border = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._teamBg, "CompetitionGame_TeamClassBorder_" .. teamIndex)
    CopyBaseProperty(teamMember._myBorder, temp._border)
    temp._border:ChangeTextureInfoName(controlTexture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(temp._border, controlTexture.border[textureIndex][1], controlTexture.border[textureIndex][2], controlTexture.border[textureIndex][3], controlTexture.border[textureIndex][4])
    temp._border:getBaseTexture():setUV(x1, y1, x2, y2)
    temp._border:setRenderTexture(temp._border:getBaseTexture())
    teamMemberUi[0][teamNo - 1] = temp
    CompetitionGame_TeamUI_Setting(teamNo, 0)
  end
  teamMember._myBorder:SetShow(false)
  teamMember._classIcon:SetShow(false)
  teamMember._level:SetShow(false)
  teamMember._hpProgress:SetShow(false)
  teamMember._hpNumber:SetShow(false)
  teamMemberBg:SetShow(false)
  teamMember._progressBg:SetShow(false)
  teamMember._name:SetShow(false)
  teamMember._leftUserCount:SetShow(false)
  teamMember._skillIcon1:SetShow(false)
  teamMember._skillIcon2:SetShow(false)
  teamMember._skillIcon3:SetShow(false)
  teamMember._skillIcon4:SetShow(false)
  teamMember._skillIcon5:SetShow(false)
  teamMember._gaugeBlackBG:SetShow(false)
  teamMember._gaugeBlack:SetShow(false)
  teamMember._gaugeRate:SetShow(false)
  CompetitionGameTeamUI_Open()
end
function CompetitionGame_TeamUi_Personal()
  _PA_LOG("\236\149\132\235\165\180\236\131\164\236\157\152\236\176\189", "CompetitionGame_TeamUi_Personal")
  teamMember._myBorder:SetShow(true)
  teamMember._classIcon:SetShow(true)
  teamMember._level:SetShow(true)
  teamMember._hpProgress:SetShow(true)
  teamMember._hpNumber:SetShow(true)
  teamMemberBg:SetShow(true)
  teamMember._progressBg:SetShow(true)
  teamMember._name:SetShow(true)
  teamMember._leftUserCount:SetShow(true)
  teamMember._skillIcon1:SetShow(true)
  teamMember._skillIcon2:SetShow(true)
  teamMember._skillIcon3:SetShow(true)
  teamMember._skillIcon4:SetShow(true)
  teamMember._skillIcon5:SetShow(true)
  teamMember._gaugeBlackBG:SetShow(true)
  teamMember._gaugeBlack:SetShow(true)
  teamMember._gaugeRate:SetShow(true)
  CompetitionGameTeamUI_StatSlotClose_Personal()
  for teamNo = 1, 2 do
    local teamInfo = ToClient_GetArshaTeamInfo(teamNo)
    local textureIndex = 1
    local userIndex = 0
    local Index = teamNo - 1
    if 1 == teamNo then
      textureIndex = 0
    elseif 2 == teamNo then
      textureIndex = 1
    end
    local temp = {}
    temp._teamBg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CompetitionGame_TeamUi, "CompetitionGame_TeamBg_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMemberBg, temp._teamBg)
    temp._teamBg:SetPosY((teamMemberBg:GetSizeY() + 5) * userIndex)
    temp._teamBg:SetPosX((teamMemberBg:GetSizeX() + 5) * Index)
    temp._teamBg:ChangeTextureInfoName(controlTexture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(temp._teamBg, controlTexture.teamBg[textureIndex][1], controlTexture.teamBg[textureIndex][2], controlTexture.teamBg[textureIndex][3], controlTexture.teamBg[textureIndex][4])
    temp._teamBg:getBaseTexture():setUV(x1, y1, x2, y2)
    temp._teamBg:setRenderTexture(temp._teamBg:getBaseTexture())
    temp._classIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._teamBg, "CompetitionGame_TeamClassIcon_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._classIcon, temp._classIcon)
    temp._gaugeBlackBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._teamBg, "CompetitionGame_gaugeBlackBG_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._gaugeBlackBG, temp._gaugeBlackBG)
    temp._gaugeBlack = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CIRCULAR_PROGRESS, temp._teamBg, "CompetitionGame_gaugeBlack_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._gaugeBlack, temp._gaugeBlack)
    temp._progressBg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._teamBg, "CompetitionGame_TeamClassProgressBg_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._progressBg, temp._progressBg)
    temp._progressBg:ChangeTextureInfoName(controlTexture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(temp._progressBg, controlTexture.progressBg[textureIndex][1], controlTexture.progressBg[textureIndex][2], controlTexture.progressBg[textureIndex][3], controlTexture.progressBg[textureIndex][4])
    temp._progressBg:getBaseTexture():setUV(x1, y1, x2, y2)
    temp._progressBg:setRenderTexture(temp._progressBg:getBaseTexture())
    temp._progress = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_PROGRESS2, temp._teamBg, "CompetitionGame_TeamClassProgress_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._hpProgress, temp._progress)
    temp._progress:ChangeTextureInfoName(controlTexture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(temp._progress, controlTexture.progress[textureIndex][1], controlTexture.progress[textureIndex][2], controlTexture.progress[textureIndex][3], controlTexture.progress[textureIndex][4])
    temp._progress:getBaseTexture():setUV(x1, y1, x2, y2)
    temp._progress:setRenderTexture(temp._progress:getBaseTexture())
    temp._progress:SetProgressRate(100)
    temp._hpNumber = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_HPNumber_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._hpNumber, temp._hpNumber)
    temp._hpNumber:SetText("100%")
    temp._level = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_TeamClassLevel_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._level, temp._level)
    temp._name = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_TeamClassName_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._name, temp._name)
    temp._leftUserCount = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_LeftUserCount_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._leftUserCount, temp._leftUserCount)
    temp._skillIcon1 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon1_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._skillIcon1, temp._skillIcon1)
    temp._skillIcon2 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon2_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._skillIcon2, temp._skillIcon2)
    temp._skillIcon3 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon3_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._skillIcon3, temp._skillIcon3)
    temp._skillIcon4 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon4_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._skillIcon4, temp._skillIcon4)
    temp._skillIcon5 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_skillIcon5_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._skillIcon5, temp._skillIcon5)
    temp._gaugeRate = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._teamBg, "CompetitionGame_gaugeBlackRate_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._gaugeRate, temp._gaugeRate)
    temp._border = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._teamBg, "CompetitionGame_TeamClassBorder_" .. Index .. "_" .. userIndex)
    CopyBaseProperty(teamMember._myBorder, temp._border)
    temp._border:ChangeTextureInfoName(controlTexture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(temp._border, controlTexture.border[textureIndex][1], controlTexture.border[textureIndex][2], controlTexture.border[textureIndex][3], controlTexture.border[textureIndex][4])
    temp._border:getBaseTexture():setUV(x1, y1, x2, y2)
    temp._border:setRenderTexture(temp._border:getBaseTexture())
    teamMemberUi[teamNo - 1][userIndex] = temp
    CompetitionGame_TeamUI_Setting(teamNo, 0)
  end
  teamMember._myBorder:SetShow(false)
  teamMember._classIcon:SetShow(false)
  teamMember._level:SetShow(false)
  teamMember._hpProgress:SetShow(false)
  teamMember._hpNumber:SetShow(false)
  teamMemberBg:SetShow(false)
  teamMember._progressBg:SetShow(false)
  teamMember._name:SetShow(false)
  teamMember._leftUserCount:SetShow(false)
  teamMember._skillIcon1:SetShow(false)
  teamMember._skillIcon2:SetShow(false)
  teamMember._skillIcon3:SetShow(false)
  teamMember._skillIcon4:SetShow(false)
  teamMember._skillIcon5:SetShow(false)
  teamMember._gaugeBlackBG:SetShow(false)
  teamMember._gaugeBlack:SetShow(false)
  teamMember._gaugeRate:SetShow(false)
  CompetitionGameTeamUI_Open()
end
function CompetitionGame_TeamUI_Setting(teamNo, userCount)
  if 0 == ToClient_CompetitionMatchType() then
    CompetitionGame_TeamUI_Setting_Round(teamNo, userCount)
  elseif 1 == ToClient_CompetitionMatchType() then
    CompetitionGame_TeamUI_Setting_FreeForAll(teamNo)
  elseif 2 == ToClient_CompetitionMatchType() then
    COmpetitionGame_TeamUI_Setting_Personal(teamNo)
  end
end
function CompetitionGame_TeamUI_Setting_Round(teamNo, userCount)
  local myTeamNo = getSelfPlayer():getCompetitionTeamNo()
  local myUserNo = getSelfPlayer():get():getUserNo()
  local teamIndex = teamNo - 1
  local textureIndex = 0
  if 1 == teamNo then
    textureIndex = 0
  elseif 2 == teamNo then
    textureIndex = 1
  end
  local hpPercent = 0
  local adrenalinPoint = 0
  for index = 0, userCount - 1 do
    local userSlot = teamMemberUi[teamIndex][index]
    local userInfo = ToClient_GetTeamUserInfoAt(teamNo, index)
    if userInfo ~= nil and userSlot ~= nil then
      local classType = userInfo:getCharacterClass()
      userSlot._classIcon:SetShow(true)
      userSlot._classIcon:ChangeTextureInfoName(controlTexture.path)
      local x1, y1, x2, y2 = setTextureUV_Func(userSlot._classIcon, controlTexture.classIcon[textureIndex][classType][1], controlTexture.classIcon[textureIndex][classType][2], controlTexture.classIcon[textureIndex][classType][3], controlTexture.classIcon[textureIndex][classType][4])
      userSlot._classIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      userSlot._classIcon:setRenderTexture(userSlot._classIcon:getBaseTexture())
      userSlot._gaugeBlack:ChangeTextureInfoName(controlTexture.path3)
      local x1, y1, x2, y2 = setTextureUV_Func(userSlot._gaugeBlack, controlTexture.teamBlack[textureIndex][1], controlTexture.teamBlack[textureIndex][2], controlTexture.teamBlack[textureIndex][3], controlTexture.teamBlack[textureIndex][4])
      userSlot._gaugeBlack:getBaseTexture():setUV(x1, y1, x2, y2)
      userSlot._gaugeBlack:setRenderTexture(userSlot._gaugeBlack:getBaseTexture())
      hpPercent = 100
      adrenalinPoint = userInfo:getAP()
      adrenalinPoint = adrenalinPoint / 10
      adrenalinPoint = math.floor(adrenalinPoint) / 10
      userSlot._level:SetShow(true)
      userSlot._level:SetText(userInfo:getCharacterLevel())
      userSlot._progress:SetProgressRate(hpPercent)
      userSlot._hpNumber:SetText(string.format("%d", math.floor(hpPercent)) .. "%")
      userSlot._name:SetText(userInfo:getCharacterName())
      userSlot._name:SetFontColor(UI_color.C_FFEFEFEF)
      userSlot._leftUserCount:SetShow(false)
      userSlot._skillIcon1:SetShow(false)
      userSlot._skillIcon2:SetShow(false)
      userSlot._skillIcon3:SetShow(false)
      userSlot._skillIcon4:SetShow(false)
      userSlot._skillIcon5:SetShow(false)
      if myTeamNo == teamNo or 0 == myTeamNo then
        userSlot._gaugeBlackBG:SetShow(true)
        userSlot._gaugeBlack:SetShow(true)
        userSlot._gaugeBlack:SetProgressRate(adrenalinPoint)
        userSlot._gaugeRate:SetShow(true)
        userSlot._gaugeRate:SetText(string.format("%.1f", adrenalinPoint) .. "%")
      else
        userSlot._gaugeBlackBG:SetShow(false)
        userSlot._gaugeBlack:SetShow(false)
        userSlot._gaugeBlack:SetProgressRate(0)
        userSlot._gaugeRate:SetShow(false)
        userSlot._gaugeRate:SetText("")
      end
      if userInfo:getUserNo() == myUserNo then
        userSlot._border:SetShow(true)
      else
        userSlot._border:SetShow(false)
      end
      userSlot._teamBg:addInputEvent("Mouse_LUp", "CompetitionGame_CameraControl(" .. tostring(userInfo:getUserNo()) .. ")")
    end
  end
end
function CompetitionGame_TeamUI_Setting_FreeForAll(teamNo)
  local myTeamNo = getSelfPlayer():getCompetitionTeamNo()
  local myUserNo = getSelfPlayer():get():getUserNo()
  local teamIndex = teamNo - 1
  local textureIndex = 0
  if myTeamNo == teamNo then
    textureIndex = 1
  end
  local hpPercent = 0
  local userSlot = teamMemberUi[0][teamIndex]
  local leaderInfo = ToClient_GetTeamLeaderInfo(teamNo)
  teamMember._skillIcon1:SetShow(false)
  teamMember._skillIcon2:SetShow(false)
  teamMember._skillIcon3:SetShow(false)
  teamMember._skillIcon4:SetShow(false)
  teamMember._skillIcon5:SetShow(false)
  teamMember._gaugeBlackBG:SetShow(false)
  teamMember._gaugeBlack:SetShow(false)
  teamMember._gaugeRate:SetShow(false)
  if leaderInfo ~= nil and userSlot ~= nil then
    local classType = leaderInfo:getCharacterClass()
    userSlot._classIcon:SetShow(false)
    hpPercent = ToClient_GetTeamTotalHpPercent(teamNo)
    userSlot._progress:SetProgressRate(hpPercent)
    userSlot._hpNumber:SetText(string.format("%d", math.floor(hpPercent)) .. "%")
    userSlot._name:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ARSHA_TEAMUI_NAMETEXT", "name", leaderInfo:getCharacterName()))
    userSlot._name:SetFontColor(UI_color.C_FFEFEFEF)
    userSlot._level:SetShow(false)
    userSlot._leftUserCount:SetShow(true)
    if leaderInfo:getUserNo() == myUserNo then
      userSlot._border:SetShow(true)
    else
      userSlot._border:SetShow(false)
    end
  end
end
function COmpetitionGame_TeamUI_Setting_Personal(teamNo)
  _PA_LOG("\236\149\132\235\165\180\236\131\164\236\157\152\236\176\189", "COmpetitionGame_TeamUI_Setting_Personal")
  local myTeamNo = getSelfPlayer():getCompetitionTeamNo()
  local myUserNo = getSelfPlayer():get():getUserNo()
  local teamIndex = teamNo - 1
  local textureIndex = 0
  if 1 == teamNo then
    textureIndex = 0
  elseif 2 == teamNo then
    textureIndex = 1
  end
  local hpPercent = 0
  local adrenalinPoint = 0
  local userSlot = teamMemberUi[teamIndex][0]
  local userInfo = ToClient_GetArshaAttendUserInfo(teamNo)
  if userInfo ~= nil and userSlot ~= nil then
    local classType = userInfo:getCharacterClass()
    userSlot._classIcon:SetShow(true)
    userSlot._classIcon:ChangeTextureInfoName(controlTexture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(userSlot._classIcon, controlTexture.classIcon[textureIndex][classType][1], controlTexture.classIcon[textureIndex][classType][2], controlTexture.classIcon[textureIndex][classType][3], controlTexture.classIcon[textureIndex][classType][4])
    userSlot._classIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    userSlot._classIcon:setRenderTexture(userSlot._classIcon:getBaseTexture())
    userSlot._gaugeBlack:ChangeTextureInfoName(controlTexture.path3)
    local x1, y1, x2, y2 = setTextureUV_Func(userSlot._gaugeBlack, controlTexture.teamBlack[textureIndex][1], controlTexture.teamBlack[textureIndex][2], controlTexture.teamBlack[textureIndex][3], controlTexture.teamBlack[textureIndex][4])
    userSlot._gaugeBlack:getBaseTexture():setUV(x1, y1, x2, y2)
    userSlot._gaugeBlack:setRenderTexture(userSlot._gaugeBlack:getBaseTexture())
    hpPercent = 100
    adrenalinPoint = userInfo:getAP()
    adrenalinPoint = adrenalinPoint / 10
    adrenalinPoint = math.floor(adrenalinPoint) / 10
    userSlot._level:SetShow(true)
    userSlot._level:SetText(userInfo:getCharacterLevel())
    userSlot._progress:SetProgressRate(hpPercent)
    userSlot._hpNumber:SetText(string.format("%d", math.floor(hpPercent)) .. "%")
    userSlot._name:SetText(userInfo:getCharacterName())
    userSlot._name:SetFontColor(UI_color.C_FFEFEFEF)
    userSlot._leftUserCount:SetShow(false)
    userSlot._skillIcon1:SetShow(false)
    userSlot._skillIcon2:SetShow(false)
    userSlot._skillIcon3:SetShow(false)
    userSlot._skillIcon4:SetShow(false)
    userSlot._skillIcon5:SetShow(false)
    if myTeamNo == teamNo or 0 == myTeamNo then
      userSlot._gaugeBlackBG:SetShow(true)
      userSlot._gaugeBlack:SetShow(true)
      userSlot._gaugeBlack:SetProgressRate(adrenalinPoint)
      userSlot._gaugeRate:SetShow(true)
      userSlot._gaugeRate:SetText(string.format("%.1f", adrenalinPoint) .. "%")
    else
      userSlot._gaugeBlackBG:SetShow(false)
      userSlot._gaugeBlack:SetShow(false)
      userSlot._gaugeBlack:SetProgressRate(0)
      userSlot._gaugeRate:SetShow(false)
      userSlot._gaugeRate:SetText("")
    end
    if userInfo:getUserNo() == myUserNo then
      userSlot._border:SetShow(true)
    else
      userSlot._border:SetShow(false)
    end
    userSlot._teamBg:addInputEvent("Mouse_LUp", "CompetitionGame_CameraControl(" .. tostring(userInfo:getUserNo()) .. ")")
  end
end
function FromClient_UpdateUserHP()
  if 0 == ToClient_CompetitionMatchType() then
    FromClient_UpdateUserHP_Round()
  elseif 1 == ToClient_CompetitionMatchType() then
    FromClient_UpdateUserHP_FreeForAll()
  elseif 2 == ToClient_CompetitionMatchType() then
    FromClient_UpdateUserHP_Personal()
  end
end
function FromClient_UpdateUserHP_Round()
  local myTeamNo = getSelfPlayer():getCompetitionTeamNo()
  local hpPercent = 0
  local teamUserCount = 0
  local teamIndex = 0
  local teamNo = 0
  local teamInfo
  local teamCount = ToClient_GetTeamListCountWithOutZero()
  for Index = 0, teamCount - 1 do
    teamInfo = ToClient_GetTeamListAt(Index)
    teamNo = teamInfo:getTeamNo()
    teamUserCount = ToClient_GetTeamUserInfoCount(teamNo)
    teamIndex = teamNo - 1
    for userIndex = 0, teamUserCount - 1 do
      local userSlot = teamMemberUi[teamIndex][userIndex]
      local userInfo = ToClient_GetTeamUserInfoAt(teamNo, userIndex)
      if nil == userSlot then
        CompetitionGame_TeamUi_Create()
        userSlot = teamMemberUi[teamIndex][userIndex]
      end
      if userInfo ~= nil and userSlot ~= nil then
        hpPercent = userInfo:getHP() / userInfo:getMaxHP() * 100
        userSlot._progress:SetProgressRate(hpPercent)
        userSlot._hpNumber:SetText(string.format("%d", math.floor(hpPercent)) .. "%")
        userSlot._name:SetText(userInfo:getCharacterName())
        if hpPercent <= 0 then
          userSlot._name:SetFontColor(UI_color.C_FFC4BEBE)
        end
        local actorKey = userInfo:getActorKey()
        local adrenalin = 0
        local skillCount = ToClient_GetUseSkillListCount(actorKey)
        local skillNo = 0
        local remainTime = 0
        if myTeamNo == teamNo or 0 == myTeamNo then
          adrenalin = userInfo:getAP()
          adrenalin = adrenalin / 10
          adrenalin = math.floor(adrenalin) / 10
          userSlot._gaugeBlack:SetProgressRate(adrenalin)
          userSlot._gaugeBlack:SetPosX(3)
          userSlot._gaugeBlack:SetPosY(3)
          userSlot._gaugeRate:SetText(string.format("%.1f", adrenalin) .. "%")
        end
        for idx = 0, skillCount - 1 do
          skillNo = ToClient_GetUseSkillListAt(actorKey, idx)
          local skillCool = ToClient_GetSkillCoolTime_OtherUser(actorKey, idx)
          local skillSSW = getSkillTypeStaticStatus(skillNo)
          local skillName = skillSSW:getName()
          local skillIcon = skillSSW:getIconPath()
          if 0 == idx then
            if skillCool <= 0 then
              userSlot._skillIcon1:SetShow(false)
            else
              userSlot._skillIcon1:ChangeTextureInfoName("Icon/" .. skillIcon)
              userSlot._skillIcon1:SetShow(true)
            end
          end
          if 1 == idx then
            if skillCool <= 0 then
              userSlot._skillIcon2:SetShow(false)
            else
              userSlot._skillIcon2:ChangeTextureInfoName("Icon/" .. skillIcon)
              userSlot._skillIcon2:SetShow(true)
            end
          end
          if 2 == idx then
            if skillCool <= 0 then
              userSlot._skillIcon3:SetShow(false)
            else
              userSlot._skillIcon3:ChangeTextureInfoName("Icon/" .. skillIcon)
              userSlot._skillIcon3:SetShow(true)
            end
          end
          if 3 == idx then
            if skillCool <= 0 then
              userSlot._skillIcon4:SetShow(false)
            else
              userSlot._skillIcon4:ChangeTextureInfoName("Icon/" .. skillIcon)
              userSlot._skillIcon4:SetShow(true)
            end
          end
          local skillIconPos = 51
          if userSlot._skillIcon1:GetShow() then
            userSlot._skillIcon1:SetPosX(skillIconPos)
            userSlot._skillIcon1:SetPosY(37)
            skillIconPos = skillIconPos + 25
          end
          if userSlot._skillIcon2:GetShow() then
            userSlot._skillIcon2:SetPosX(skillIconPos)
            userSlot._skillIcon2:SetPosY(37)
            skillIconPos = skillIconPos + 25
          end
          if userSlot._skillIcon3:GetShow() then
            userSlot._skillIcon3:SetPosX(skillIconPos)
            userSlot._skillIcon3:SetPosY(37)
            skillIconPos = skillIconPos + 25
          end
          if userSlot._skillIcon4:GetShow() then
            userSlot._skillIcon4:SetPosX(skillIconPos)
            userSlot._skillIcon4:SetPosY(37)
            skillIconPos = skillIconPos + 25
          end
          if userSlot._skillIcon5:GetShow() then
            userSlot._skillIcon5:SetPosX(skillIconPos)
            userSlot._skillIcon5:SetPosY(37)
          end
        end
        userSlot._teamBg:addInputEvent("Mouse_LUp", "CompetitionGame_CameraControl(" .. tostring(userInfo:getUserNo()) .. ")")
      end
    end
  end
end
function FromClient_UpdateUserHP_FreeForAll()
  local hpPercent = 0
  local teamNo = 0
  local teamIndex = 0
  local teamInfo
  local totalUserCount = 0
  local deadUserCount = 0
  local teamCount = ToClient_GetTeamListCountWithOutZero()
  teamMember._skillIcon1:SetShow(false)
  teamMember._skillIcon2:SetShow(false)
  teamMember._skillIcon3:SetShow(false)
  teamMember._skillIcon4:SetShow(false)
  teamMember._skillIcon5:SetShow(false)
  teamMember._gaugeBlackBG:SetShow(false)
  teamMember._gaugeBlack:SetShow(false)
  teamMember._gaugeRate:SetShow(false)
  for Index = 0, teamCount - 1 do
    teamInfo = ToClient_GetTeamListAt(Index)
    teamNo = teamInfo:getTeamNo()
    hpPercent = ToClient_GetTeamTotalHpPercent(teamNo)
    teamIndex = teamNo - 1
    totalUserCount = ToClient_GetTeamUserInfoCount(teamNo)
    deadUserCount = ToClient_GetTeamDeadUserCount(teamNo)
    local userSlot = teamMemberUi[0][teamIndex]
    if nil == userSlot then
      CompetitionGame_TeamUi_Create()
    end
    if userSlot ~= nil then
      userSlot._progress:SetProgressRate(hpPercent)
      userSlot._hpNumber:SetText(string.format("%d", math.floor(hpPercent)) .. "%")
      if hpPercent <= 0 then
        userSlot._name:SetFontColor(UI_color.C_FFC4BEBE)
      end
      userSlot._leftUserCount:SetText(tostring(totalUserCount - deadUserCount))
      if totalUserCount - deadUserCount <= 1 then
        userSlot._leftUserCount:SetFontColor(UI_color.C_FFFF0000)
      else
        userSlot._leftUserCount:SetFontColor(UI_color.C_FFFFFFFF)
      end
    end
  end
end
function FromClient_UpdateUserHP_Personal()
  _PA_LOG("\236\149\132\235\165\180\236\131\164\236\157\152\236\176\189", "FromClient_UpdateUserHP_Personal")
  local myTeamNo = getSelfPlayer():getCompetitionTeamNo()
  local hpPercent = 0
  local teamUserCount = 0
  local teamIndex = 0
  local teamNo = 0
  local teamInfo
  for Index = 1, 2 do
    teamInfo = ToClient_GetArshaTeamInfo(Index)
    teamNo = teamInfo:getTeamNo()
    teamIndex = teamNo - 1
    local userSlot = teamMemberUi[teamIndex][0]
    local userInfo = ToClient_GetArshaAttendUserInfo(teamNo)
    if nil == userSlot then
      _PA_LOG("\236\149\132\235\165\180\236\131\164\236\157\152\236\176\189", "createUserSlot")
      CompetitionGame_TeamUi_Create()
      userSlot = teamMemberUi[teamIndex][0]
    end
    if userInfo ~= nil and userSlot ~= nil then
      hpPercent = userInfo:getHP() / userInfo:getMaxHP() * 100
      userSlot._progress:SetProgressRate(hpPercent)
      userSlot._hpNumber:SetText(string.format("%d", math.floor(hpPercent)) .. "%")
      userSlot._name:SetText(userInfo:getCharacterName())
      if hpPercent <= 0 then
        userSlot._name:SetFontColor(UI_color.C_FFC4BEBE)
      end
      local actorKey = userInfo:getActorKey()
      local adrenalin = 0
      local skillNo = 0
      local remainTime = 0
      if myTeamNo == teamNo or 0 == myTeamNo then
        adrenalin = userInfo:getAP()
        adrenalin = adrenalin / 10
        adrenalin = math.floor(adrenalin) / 10
        userSlot._gaugeBlack:SetProgressRate(adrenalin)
        userSlot._gaugeBlack:SetPosX(3)
        userSlot._gaugeBlack:SetPosY(3)
        userSlot._gaugeRate:SetText(string.format("%.1f", adrenalin) .. "%")
      end
      userSlot._teamBg:addInputEvent("Mouse_LUp", "CompetitionGame_CameraControl(" .. tostring(userInfo:getUserNo()) .. ")")
    end
  end
end
function CompetitionGameTeamUI_StatSlotClose_Round()
  local teamUserCount = 0
  local teamIndex = 0
  local teamNo = 0
  local teamInfo
  local teamCount = ToClient_GetTeamListCountWithOutZero()
  local beforeTeamCnt = 0
  for Index = 0, teamCount - 1 do
    teamInfo = ToClient_GetTeamListAt(Index)
    teamNo = teamInfo:getTeamNo()
    teamUserCount = ToClient_GetTeamUserInfoCount(teamNo)
    teamIndex = teamNo - 1
    beforeTeamCnt = #teamMemberUi[teamIndex] + 1
    for userIndex = 0, beforeTeamCnt - 1 do
      CompetitionGame_StatSlotSetShow(teamIndex, userIndex, false, false)
    end
  end
end
function CompetitionGameTeamUI_StatSlotClose_FreeForAll()
  local teamNo = 0
  local teamIndex = 0
  local teamInfo
  local teamCount = ToClient_GetTeamListCountWithOutZero()
  teamMember._skillIcon1:SetShow(false)
  teamMember._skillIcon2:SetShow(false)
  teamMember._skillIcon3:SetShow(false)
  teamMember._skillIcon4:SetShow(false)
  teamMember._skillIcon5:SetShow(false)
  teamMember._gaugeBlackBG:SetShow(false)
  teamMember._gaugeBlack:SetShow(false)
  teamMember._gaugeRate:SetShow(false)
  for Index = 0, teamCount - 1 do
    teamInfo = ToClient_GetTeamListAt(Index)
    teamNo = teamInfo:getTeamNo()
    teamIndex = teamNo - 1
    CompetitionGame_StatSlotSetShow(0, teamIndex, false, true)
  end
end
function CompetitionGameTeamUI_StatSlotClose_Personal()
  local teamIndex = 0
  for teamNo = 1, 2 do
    teamIndex = teamNo - 1
    CompetitionGame_StatSlotSetShow(teamIndex, 0, false, false)
  end
end
function CompetitionGame_CameraControl(teamNo)
  ToClient_ForceChangeScreenModeActor(toInt64(0, teamNo))
end
function CompetitionGameTeamUI_Open()
  _PA_LOG("\236\149\132\235\165\180\236\131\164\236\157\152\236\176\189", "CompetitionGameTeamUI_Open")
  Panel_CompetitionGame_TeamUi:SetShow(true)
  local selfActorKeyRaw = getSelfPlayer():getActorKey()
  if true == getSelfPlayer():isPartyMemberActorKey(selfActorKeyRaw) then
    if false == _ContentsGroup_RemasterUI_Party then
      Panel_Party:SetShow(false)
    else
      Panel_Widget_Party:SetShow(false)
    end
  end
end
function CompetitionGameTeamUI_Close()
  Panel_CompetitionGame_TeamUi:SetShow(false)
  local selfActorKeyRaw = getSelfPlayer():getActorKey()
  if true == getSelfPlayer():isPartyMemberActorKey(selfActorKeyRaw) then
    if false == _ContentsGroup_RemasterUI_Party then
      Panel_Party:SetShow(true)
    else
      Panel_Widget_Party:SetShow(true)
    end
  end
  if 0 == ToClient_CompetitionMatchType() then
    CompetitionGameTeamUI_StatSlotClose_Round()
  elseif 1 == ToClient_CompetitionMatchType() then
    CompetitionGameTeamUI_StatSlotClose_FreeForAll()
  elseif 2 == ToClient_CompetitionMatchType() then
    CompetitionGameTeamUI_StatSlotClose_Personal()
  end
end
registerEvent("FromClient_UpdateUserHP", "FromClient_UpdateUserHP")
