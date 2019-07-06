local UI_color = Defines.Color
local HumanRelationLinePointUIType = {Center = 0}
local function settingCenterText(panel, npcActorProxyWrapper)
  panel:SetShow(true, false)
  local textControl = UI.getChildControl(panel, "StaticText_Point")
  local needCount = npcActorProxyWrapper:getNeedCount()
  local currCount = getKnowledgeCountMatchTheme(npcActorProxyWrapper:getNpcThemeKey())
  local text = PAGetStringParam3(Defines.StringSheet_GAME, "HUMANRELATION_TEXT", "getNpcTheme", npcActorProxyWrapper:getNpcTheme(), "currCount", tostring(currCount), "needCount", tostring(needCount))
  local uiColor = UI_color.C_FF888888
  if needCount <= currCount then
    uiColor = UI_color.C_FFFFFFFF
  end
  textControl:SetFontColor(uiColor)
  textControl:SetText(text)
end
local createEventFunctor = {
  [HumanRelationLinePointUIType.Center] = function(actorKeyRaw, panel, actorProxyWrapper)
    panel:SetShow(false, false)
    panel:SetAlphaChild(0)
    local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
    settingCenterText(panel, npcActorProxyWrapper)
  end
}
Panel_Copy_HumanRelation:SetPosX(-1000)
Panel_Copy_HumanRelation:SetPosY(-1000)
function FromClient_EventHumanRelationCreated(actorKeyRaw, panel, key, actorProxyWrapper)
  local functor = createEventFunctor[key]
  if nil ~= functor then
    functor(actorKeyRaw, panel, actorProxyWrapper)
  end
end
function FromClient_KnowledgeCountChanged(actorKeyRaw, npcActorProxyWrapper)
  local panel = npcActorProxyWrapper:get():getLinePointUI(HumanRelationLinePointUIType.Center)
  settingCenterText(panel, npcActorProxyWrapper)
end
local uv = {
  [0] = {
    _fileName = "New_UI_Common_forLua/Widget/HumanRelations/Compensation_00.dds",
    x1 = 1,
    y1 = 1,
    x2 = 61,
    y2 = 61
  },
  {
    _fileName = "New_UI_Common_forLua/Widget/HumanRelations/Compensation_00.dds",
    x1 = 62,
    y1 = 1,
    x2 = 122,
    y2 = 61
  },
  {
    _fileName = "New_UI_Common_forLua/Widget/HumanRelations/Compensation_00.dds",
    x1 = 62,
    y1 = 62,
    x2 = 122,
    y2 = 122
  },
  {
    _fileName = "New_UI_Common_forLua/Widget/HumanRelations/Compensation_00.dds",
    x1 = 1,
    y1 = 62,
    x2 = 61,
    y2 = 122
  },
  {
    _fileName = "New_UI_Common_forLua/Widget/HumanRelations/Compensation_00.dds",
    x1 = 62,
    y1 = 62,
    x2 = 122,
    y2 = 122
  },
  {
    _fileName = "New_UI_Common_forLua/Widget/HumanRelations/Compensation_02.dds",
    x1 = 1,
    y1 = 1,
    x2 = 61,
    y2 = 61
  }
}
function FromClient_EventHumanRelationIconCreated(actorKeyRaw, panel, typeIndex, actorProxyWrapper)
  if nil == panel then
    return
  end
  panel:SetPosX(-Panel_Copy_HumanRelationIcon:GetSizeX() - 10000)
  panel:SetPosY(-Panel_Copy_HumanRelationIcon:GetSizeY() - 10000)
  panel:SetScaleChild(1, 1)
  panel:SetSize(Panel_Copy_HumanRelationIcon:GetSizeX(), Panel_Copy_HumanRelationIcon:GetSizeY())
  panel:ChangeTextureInfoNameAsync(uv[typeIndex]._fileName)
  local x1, y1, x2, y2 = setTextureUV_Func(panel, uv[typeIndex].x1, uv[typeIndex].y1, uv[typeIndex].x2, uv[typeIndex].y2)
  panel:getBaseTexture():setUV(x1, y1, x2, y2)
  panel:setRenderTexture(panel:getBaseTexture())
end
registerEvent("FromClient_EventHumanRelationCreated", "FromClient_EventHumanRelationCreated")
registerEvent("FromClient_KnowledgeCountChanged", "FromClient_KnowledgeCountChanged")
registerEvent("FromClient_EventHumanRelationIconCreated", "FromClient_EventHumanRelationIconCreated")
ToClient_HumanRelationSetDefaultPanel(Panel_Copy_HumanRelationIcon)
ToClient_HumanRelationInitialize()
ToClient_SetHumanRelationPoint(Panel_Copy_HumanRelation)
ToClient_InitializeHumanRelationPoint()
