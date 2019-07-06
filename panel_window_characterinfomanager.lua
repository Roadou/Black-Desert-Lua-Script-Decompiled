PaGlobal_CharacterInfoPanel = {
  _eType = {
    _status = 1,
    _basic = 2,
    _title = 3,
    _histroy = 4,
    _challenge = 5,
    _profile = 6,
    _life = 7,
    _familySkill = 8
  }
}
function PaGlobal_CharacterInfoPanel:setPanel(ePanelType, panel)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_CharacterInfoPanel:setPanel ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panel, "PaGlobal_CharacterInfoPanel:setPanel panel nil", "\236\178\156\235\167\140\234\184\176")
  if PaGlobal_CharacterInfoPanel._eType._status == ePanelType then
    Panel_Window_CharInfo_Status = panel
  elseif PaGlobal_CharacterInfoPanel._eType._basic == ePanelType then
    Panel_Window_CharInfo_BasicStatus = panel
  elseif PaGlobal_CharacterInfoPanel._eType._title == ePanelType then
    Panel_Window_CharInfo_TitleInfo = panel
  elseif PaGlobal_CharacterInfoPanel._eType._histroy == ePanelType then
    Panel_Window_CharInfo_HistoryInfo = panel
  elseif PaGlobal_CharacterInfoPanel._eType._challenge == ePanelType then
    Panel_Window_Challenge = panel
  elseif PaGlobal_CharacterInfoPanel._eType._profile == ePanelType then
    Panel_Window_Profile = panel
  elseif PaGlobal_CharacterInfoPanel._eType._life == ePanelType then
    Panel_Window_CharInfo_LifeInfo = panel
  elseif PaGlobal_CharacterInfoPanel._eType._familySkill == ePanelType then
    Panel_Window_FamilySkill_Main = panel
  end
end
function PaGlobal_CharacterInfoPanel:getPanel(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_CharacterInfoPanel:getPanel ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  if PaGlobal_CharacterInfoPanel._eType._status == ePanelType then
    return Panel_Window_CharInfo_Status
  elseif PaGlobal_CharacterInfoPanel._eType._basic == ePanelType then
    return Panel_Window_CharInfo_BasicStatus
  elseif PaGlobal_CharacterInfoPanel._eType._title == ePanelType then
    return Panel_Window_CharInfo_TitleInfo
  elseif PaGlobal_CharacterInfoPanel._eType._histroy == ePanelType then
    return Panel_Window_CharInfo_HistoryInfo
  elseif PaGlobal_CharacterInfoPanel._eType._challenge == ePanelType then
    return Panel_Window_Challenge
  elseif PaGlobal_CharacterInfoPanel._eType._profile == ePanelType then
    return Panel_Window_Profile
  elseif PaGlobal_CharacterInfoPanel._eType._life == ePanelType then
    return Panel_Window_CharInfo_LifeInfo
  elseif PaGlobal_CharacterInfoPanel._eType._familySkill == ePanelType then
    return Panel_Window_FamilySkill_Main
  end
  return nil
end
function PaGlobal_CharacterInfoPanel:checkLoadUI(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_CharacterInfoPanel:checkLoadUI ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  local rv
  if PaGlobal_CharacterInfoPanel._eType._status == ePanelType then
    if false == _ContentsGroup_isUsedNewCharacterInfo then
      rv = reqLoadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo.xml", "Panel_Window_CharInfo_Status", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
        Defines.RenderMode.eRenderMode_Default
      }))
    else
      rv = reqLoadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo_New.xml", "Panel_Window_CharInfo_Status", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
        Defines.RenderMode.eRenderMode_Default
      }))
    end
  elseif PaGlobal_CharacterInfoPanel._eType._basic == ePanelType then
    if false == _ContentsGroup_isUsedNewCharacterInfo then
      rv = reqLoadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo_Basic.xml", "Panel_Window_CharInfo_BasicStatus", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
        Defines.RenderMode.eRenderMode_Default
      }))
    else
      rv = reqLoadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo_Basic_renew.xml", "Panel_Window_CharInfo_BasicStatus", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
        Defines.RenderMode.eRenderMode_Default
      }))
    end
  elseif PaGlobal_CharacterInfoPanel._eType._title == ePanelType then
    if false == _ContentsGroup_isUsedNewCharacterInfo then
      rv = reqLoadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo_Title.xml", "Panel_Window_CharInfo_TitleInfo", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
        Defines.RenderMode.eRenderMode_Default
      }))
    else
      rv = reqLoadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo_Title_New.xml", "Panel_Window_CharInfo_TitleInfo", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
        Defines.RenderMode.eRenderMode_Default
      }))
    end
  elseif PaGlobal_CharacterInfoPanel._eType._histroy == ePanelType then
    rv = reqLoadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo_History.xml", "Panel_Window_CharInfo_HistoryInfo", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_CharacterInfoPanel._eType._challenge == ePanelType then
    rv = reqLoadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo_Challenge.xml", "Panel_Window_Challenge", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_CharacterInfoPanel._eType._profile == ePanelType then
    rv = reqLoadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo_Profile.xml", "Panel_Window_Profile", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  elseif PaGlobal_CharacterInfoPanel._eType._life == ePanelType then
    if true == _ContentsGroup_isUsedNewCharacterInfo then
      rv = reqLoadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo_Life.xml", "Panel_Window_CharInfo_LifeInfo", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
        Defines.RenderMode.eRenderMode_Default
      }))
    end
  elseif PaGlobal_CharacterInfoPanel._eType._familySkill == ePanelType then
    rv = reqLoadUI("UI_Data/Window/EdanaContract/Panel_Window_EdanaContract_Main.xml", "Panel_Window_FamilySkill_Main", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  end
  if nil ~= rv then
    PaGlobal_CharacterInfoPanel:setPanel(ePanelType, rv)
    rv = nil
    PaGlobal_CharacterInfoPanel:initialize(ePanelType)
  end
end
function PaGlobal_CharacterInfoPanel:initialize(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_CharacterInfoPanel:initialize ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  if PaGlobal_CharacterInfoPanel._eType._status == ePanelType then
    PaGlobal_CharacterInfo_Initialize()
  elseif PaGlobal_CharacterInfoPanel._eType._basic == ePanelType then
    if nil ~= PaGlobal_CharacterInfoBasic_Initialize then
      PaGlobal_CharacterInfoBasic_Initialize()
    end
  elseif PaGlobal_CharacterInfoPanel._eType._title == ePanelType then
    if nil ~= PaGlobal_CharacterInfoTitle_Init then
      PaGlobal_CharacterInfoTitle_Init()
    end
  elseif PaGlobal_CharacterInfoPanel._eType._histroy == ePanelType then
    if nil ~= PaGlobal_CharacterInfoHistory_Init then
      PaGlobal_CharacterInfoHistory_Init()
    end
  elseif PaGlobal_CharacterInfoPanel._eType._challenge == ePanelType then
    if nil ~= PaGlobal_CharacterInfoChallenge_Init then
      PaGlobal_CharacterInfoChallenge_Init()
    end
  elseif PaGlobal_CharacterInfoPanel._eType._profile == ePanelType then
    if nil ~= PaGlobal_CharacterInfoProfile_Init then
      PaGlobal_CharacterInfoProfile_Init()
    end
  elseif PaGlobal_CharacterInfoPanel._eType._life == ePanelType then
    if nil ~= FromClient_CharacterInfoLife_Init then
      FromClient_CharacterInfoLife_Init()
    end
  elseif PaGlobal_CharacterInfoPanel._eType._familySkill == ePanelType and nil ~= PaGlobal_CharacterInfoFamilySkill_Init and true == _ContentsGroup_FamilySkill then
    PaGlobal_CharacterInfoFamilySkill_Init()
  end
end
function PaGlobal_CharacterInfoPanel:checkCloseUI(ePanelType, isAni)
  if nil == ePanelType then
    return
  end
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_CharacterInfoPanel:checkCloseUI ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  local panel = PaGlobal_CharacterInfoPanel:getPanel(ePanelType)
  if nil == panel then
    return
  end
  reqCloseUI(panel, isAni)
end
function PaGlobal_CharacterInfoPanel:getShowPanel(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_CharacterInfoPanel:getShowPanel ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  local panel = PaGlobal_CharacterInfoPanel:getPanel(ePanelType)
  if nil == panel then
    return false
  end
  return panel:GetShow()
end
function PaGlobal_CharacterInfoPanel:isUISubApp(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobal_CharacterInfoPanel:isUISubApp ePanelType nil", "\236\178\156\235\167\140\234\184\176")
  local panel = PaGlobal_CharacterInfoPanel:getPanel(ePanelType)
  if nil == panel then
    return false
  end
  return panel:IsUISubApp()
end
function PaGlobal_CharacterInfoPanel_CheckLoadUIAll()
  PaGlobal_CharacterInfoPanel:checkLoadUI(PaGlobal_CharacterInfoPanel._eType._basic)
  PaGlobal_CharacterInfoPanel:checkLoadUI(PaGlobal_CharacterInfoPanel._eType._title)
  PaGlobal_CharacterInfoPanel:checkLoadUI(PaGlobal_CharacterInfoPanel._eType._histroy)
  PaGlobal_CharacterInfoPanel:checkLoadUI(PaGlobal_CharacterInfoPanel._eType._challenge)
  PaGlobal_CharacterInfoPanel:checkLoadUI(PaGlobal_CharacterInfoPanel._eType._profile)
  PaGlobal_CharacterInfoPanel:checkLoadUI(PaGlobal_CharacterInfoPanel._eType._life)
  PaGlobal_CharacterInfoPanel:checkLoadUI(PaGlobal_CharacterInfoPanel._eType._familySkill)
  PaGlobal_CharacterInfoPanel:checkLoadUI(PaGlobal_CharacterInfoPanel._eType._status)
end
function PaGlobal_CharacterInfoPanel_CheckCloseUIAll(isAni)
  for k, v in pairs(PaGlobal_CharacterInfoPanel._eType) do
    PaGlobal_CharacterInfoPanel:checkCloseUI(v, isAni)
  end
end
function PaGlobal_CharacterInfoPanel_SetShowPanelStatus(isShow, isAni)
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_CharacterInfoPanel_SetShowPanelStatus isShow nil", "\236\178\156\235\167\140\234\184\176")
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Window_CharInfo_Status:SetShow(isShow, isAni)
    return
  end
  if true == isShow then
    PaGlobal_CharacterInfoPanel_CheckLoadUIAll()
    if nil ~= Panel_Window_CharInfo_Status then
      Panel_Window_CharInfo_Status:SetShow(isShow, isAni)
    end
  else
    PaGlobal_CharacterInfoPanel_CheckCloseUIAll(isAni)
    PaGlobal_CharacterInfo_SavePos()
  end
end
function PaGlobal_CharacterInfoPanel_GetShowPanelStatus()
  return PaGlobal_CharacterInfoPanel:getShowPanel(PaGlobal_CharacterInfoPanel._eType._status)
end
function PaGlobal_CharacterInfoPanel_IsUISubAppStatus()
  return PaGlobal_CharacterInfoPanel:isUISubApp(PaGlobal_CharacterInfoPanel._eType._status)
end
function PaGlobal_CharacterInfoPanel_SetShowPanelProfile(isShow, isAni)
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_CharacterInfoPanel_SetShowPanelProfile isShow nil", "\236\178\156\235\167\140\234\184\176")
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Window_Profile:SetShow(isShow, isAni)
    return
  end
  if true == isShow then
    PaGlobal_CharacterInfoPanel:checkLoadUI(PaGlobal_CharacterInfoPanel._eType._profile)
    if nil ~= Panel_Window_Profile then
      Panel_Window_Profile:SetShow(isShow, isAni)
    end
  else
    PaGlobal_CharacterInfoPanel:checkCloseUI(PaGlobal_CharacterInfoPanel._eType._profile, isAni)
  end
end
