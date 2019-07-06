function PaGlobalFunc_WorkerSkillTooltip_All_ShowTooltip(index, isAuction)
  if nil == Panel_Widget_WorkerSkillTooltip_All then
    return
  end
  if nil == index or nil == PaGlobal_WorkerSkillTooltip_All._uiBase or true == Panel_Widget_WorkerSkillTooltip_All:GetShow() then
    PaGlobal_WorkerSkillTooltip_All_Hide()
    return
  end
  local workerWrapperLua
  if true == isAuction then
    local auctionInfo = RequestGetAuctionInfo()
    workerNoRaw = auctionInfo:getWorkerAuction(index)
    workerWrapperLua = getWorkerWrapperByAuction(workerNoRaw, true)
  else
    local plantKey = ToClient_convertWaypointKeyToPlantKey(getCurrentWaypointKey())
    workerNoRaw = ToClient_getPlantWaitWorkerNoRawByIndex(plantKey, index)
    workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
  end
  if nil == workerWrapperLua then
    PaGlobal_WorkerSkillTooltip_All_Hide()
    return
  end
  local skillCount = workerWrapperLua:getSkillCount()
  PaGlobal_WorkerSkillTooltip_All._skillCount = skillCount
  tooltipSizeY = PaGlobal_WorkerSkillTooltip_All._ui._stc_Tooltip_Template:GetSizeY()
  Panel_Widget_WorkerSkillTooltip_All:SetSize(PaGlobal_WorkerSkillTooltip_All._PANELSIZE_X, skillCount * tooltipSizeY + 10)
  if skillCount <= 0 then
    PaGlobal_WorkerSkillTooltip_All:hide()
    return
  end
  for idx = 0, skillCount - 1 do
    if nil ~= PaGlobal_WorkerSkillTooltip_All._tooltiplist[idx] then
      local skillSSW = workerWrapperLua:getSkillSSW(idx)
      local skillSlot = PaGlobal_WorkerSkillTooltip_All._tooltiplist[idx]
      skillSlot.name:SetText(skillSSW:getName())
      skillSlot.icon:ChangeTextureInfoName(skillSSW:getIconPath())
      local x1, y1, x2, y2 = setTextureUV_Func(skillSlot.icon, 0, 0, 44, 44)
      skillSlot.icon:getBaseTexture():setUV(x1, y1, x2, y2)
      skillSlot.icon:setRenderTexture(skillSlot.icon:getBaseTexture())
      skillSlot.icon:SetShow(false)
      skillSlot.icon:SetShow(true)
      skillSlot.desc:SetText(skillSSW:getDescription())
      local textSizeX = skillSlot.desc:GetTextSizeX()
      if textSizeX > skillSlot.desc:GetSizeX() then
        skillSlot.desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
        skillSlot.desc:SetText(skillSSW:getDescription())
      end
      local textSizeY = skillSlot.desc:GetTextSizeY()
      local descSizeY = skillSlot.desc:GetSizeY()
      if textSizeY > descSizeY then
        skillSlot.desc:SetSize(skillSlot.desc:GetSizeX(), textSizeY)
        local gap = math.abs(skillSlot.desc:GetSizeY() - descSizeY)
        skillSlot.slot:SetSize(skillSlot.slot:GetSizeX(), skillSlot.slot:GetSizeY() + gap)
      else
        skillSlot.slot:SetSize(skillSlot.slot:GetSizeX(), skillSlot.slot:GetSizeY())
      end
      if idx > 0 then
        if PaGlobal_WorkerSkillTooltip_All._tooltiplist[idx - 1].slot:GetSizeY() < skillSlot.slot:GetSizeY() then
          local gap = skillSlot.slot:GetSizeY() - PaGlobal_WorkerSkillTooltip_All._tooltiplist[idx - 1].slot:GetSizeY()
          skillSlot.slot:SetPosY(PaGlobal_WorkerSkillTooltip_All._tooltiplist[idx - 1].slot:GetPosY() + skillSlot.slot:GetSizeY() - gap)
        else
          skillSlot.slot:SetPosY(PaGlobal_WorkerSkillTooltip_All._tooltiplist[idx - 1].slot:GetPosY() + skillSlot.slot:GetSizeY())
        end
      end
      skillSlot.slot:SetShow(true)
      Panel_Widget_WorkerSkillTooltip_All:SetShow(true)
    end
  end
  local uiBase = PaGlobal_WorkerSkillTooltip_All._uiBase
  Panel_Widget_WorkerSkillTooltip_All:SetSpanSize(uiBase:GetSizeX() / 2 + 10, PaGlobal_WorkerSkillTooltip_All._TOOLTIPPOS_Y)
  PaGlobal_WorkerSkillTooltip_All:AudioPostEvent(1, 13, PaGlobal_WorkerSkillTooltip_All._ui._isConsole)
end
function PaGlobalFunc_WorkerSkillTooltip_All_SetUIBase(uiBase)
  if nil == Panel_Widget_WorkerSkillTooltip_All or nil == uiBase then
    return
  end
  PaGlobal_WorkerSkillTooltip_All._uiBase = uiBase
end
function PaGlobal_WorkerSkillTooltip_All_Hide()
  if nil == Panel_Widget_WorkerSkillTooltip_All then
    return
  end
  for index = 0, PaGlobal_WorkerSkillTooltip_All._MAXSLOT - 1 do
    if nil ~= PaGlobal_WorkerSkillTooltip_All._tooltiplist[index] then
      local skillSlot = PaGlobal_WorkerSkillTooltip_All._tooltiplist[index]
      skillSlot.slot:SetShow(false)
    end
  end
  Panel_Widget_WorkerSkillTooltip_All:SetShow(false)
end
