Panel_ServantResurrection:SetShow(false, false)
Panel_ServantResurrection:setGlassBackground(true)
Panel_ServantResurrection:SetDragAll(true)
Panel_ServantResurrection:RegisterShowEventFunc(true, "Panel_ServantResurrection_ShowAni()")
Panel_ServantResurrection:RegisterShowEventFunc(false, "Panel_ServantResurrection_HideAni()")
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
function Panel_ServantResurrection_ShowAni()
  UIAni.fadeInSCR_Down(Panel_ServantResurrection)
  local aniInfo1 = Panel_ServantResurrection:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_ServantResurrection:GetSizeX() / 2
  aniInfo1.AxisY = Panel_ServantResurrection:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_ServantResurrection:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_ServantResurrection:GetSizeX() / 2
  aniInfo2.AxisY = Panel_ServantResurrection:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_ServantResurrection_HideAni()
  Panel_ServantResurrection:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_ServantResurrection:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local btnClose = UI.getChildControl(Panel_ServantResurrection, "Button_Close")
local radioBtn_Land = UI.getChildControl(Panel_ServantResurrection, "RadioButton_Land")
local radioBtn_Sea = UI.getChildControl(Panel_ServantResurrection, "RadioButton_Sea")
local btnResurrection = UI.getChildControl(Panel_ServantResurrection, "Button_Resurrection")
local selectTitle = UI.getChildControl(Panel_ServantResurrection, "StaticText_SelectTitle")
selectTitle:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
selectTitle:SetText(selectTitle:GetText())
btnClose:addInputEvent("Mouse_LUp", "Panel_ServantResurrection_Close()")
btnResurrection:addInputEvent("Mouse_LUp", "Do_ServantResurrection()")
local deadServantInfoArray = {}
local _fromWhereType, _fromSlotNo
function Panel_ServantResurrection_Show()
  local landServantInfo = stable_getServantByServantNo(deadServantInfoArray[1])
  if nil == landServantInfo then
    return
  end
  radioBtn_Land:SetText(landServantInfo:getName())
  local seaServantInfo = stable_getServantByServantNo(deadServantInfoArray[2])
  if nil == seaServantInfo then
    return
  end
  radioBtn_Sea:SetText(seaServantInfo:getName())
  radioBtn_Land:SetCheck(true)
  radioBtn_Sea:SetCheck(false)
  Panel_ServantResurrection:SetShow(true, true)
end
function Do_ServantResurrection()
  local servantNo
  if radioBtn_Land:IsCheck() then
    servantNo = deadServantInfoArray[1]
  else
    servantNo = deadServantInfoArray[2]
  end
  ToClient_RequestResurrectionServant(servantNo, _fromWhereType, _fromSlotNo)
end
function Panel_ServantResurrection_Close()
  Panel_ServantResurrection:SetShow(false, false)
end
function FromClient_UseServantRespawnItem(fromWhereType, fromSlotNo, contentsEventParam1)
  if contentsEventParam1 ~= CppEnums.ServantWhereType.ServantWhereTypeGuild then
    local totalDeadServantCount = 0
    deadServantInfoArray = {}
    local count = ToClient_GetLastUnsealServantDataCount()
    for ii = 0, count - 1 do
      local servantInfo = ToClient_GetLastUnsealVehicleCaheDataAt(ii)
      if nil ~= servantInfo and 0 == servantInfo:getHp() then
        totalDeadServantCount = totalDeadServantCount + 1
        deadServantInfoArray[totalDeadServantCount] = servantInfo:getServantNo()
      end
    end
    if 1 == totalDeadServantCount then
      local servantNo = deadServantInfoArray[totalDeadServantCount]
      ToClient_RequestResurrectionServant(servantNo, fromWhereType, fromSlotNo)
    elseif totalDeadServantCount >= 2 then
      _fromWhereType = fromWhereType
      _fromSlotNo = fromSlotNo
      Panel_ServantResurrection_Show()
    end
  end
end
function FromClient_ServantResurrectionAck(servantNo, servantWhereType)
  if servantWhereType ~= CppEnums.ServantWhereType.ServantWhereTypeGuild then
    local servantInfo = stable_getServantByServantNo(servantNo)
    if nil ~= servantInfo then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTRESURRECTION_MSG"))
    end
  end
end
registerEvent("FromClient_UseServantRespawnItem", "FromClient_UseServantRespawnItem")
registerEvent("FromClient_ServantResurrectionAck", "FromClient_ServantResurrectionAck")
