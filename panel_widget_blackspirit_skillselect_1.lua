function PaGloabl_BlackSpiritSkillSelect:initialize()
  if true == PaGloabl_BlackSpiritSkillSelect._initialize then
    return
  end
  PaGloabl_BlackSpiritSkillSelect._ui._btn_apply = UI.getChildControl(Panel_Widget_BlackSpirit_SkillSelect, "Button_Apply")
  PaGloabl_BlackSpiritSkillSelect._ui._btn_cancel = UI.getChildControl(Panel_Widget_BlackSpirit_SkillSelect, "Button_Cancel")
  PaGloabl_BlackSpiritSkillSelect._ui._btn_skinSelect = UI.getChildControl(Panel_Widget_BlackSpirit_SkillSelect, "Button_SkinSelect_1")
  FromClient_BlackSpiritSkillSelect_ReSizePanel()
  PaGloabl_BlackSpiritSkillSelect._ui._btn_skinSelect:SetShow(false)
  PaGloabl_BlackSpiritSkillSelect._defaultPosX = PaGloabl_BlackSpiritSkillSelect._ui._btn_skinSelect:GetPosX()
  PaGloabl_BlackSpiritSkillSelect:registEventHandler()
  PaGloabl_BlackSpiritSkillSelect:validate()
  PaGloabl_BlackSpiritSkillSelect._initialize = true
end
function PaGloabl_BlackSpiritSkillSelect:registEventHandler()
  if nil == Panel_Widget_BlackSpirit_SkillSelect then
    return
  end
  registerEvent("onScreenResize", "FromClient_BlackSpiritSkillSelect_ReSizePanel")
  PaGloabl_BlackSpiritSkillSelect._ui._btn_apply:addInputEvent("Mouse_LUp", "HandleEventLUp_BlackSpiritSkillSelect_Apply()")
  PaGloabl_BlackSpiritSkillSelect._ui._btn_cancel:addInputEvent("Mouse_LUp", "HandleEventLUp_BlackSpiritSkillSelect_Cancel()")
end
function PaGloabl_BlackSpiritSkillSelect:prepareOpen()
  if nil == Panel_Widget_BlackSpirit_SkillSelect then
    return
  end
  if true == PaGloabl_BlackSpiritSkillSelect._isOpen then
    PaGloabl_BlackSpiritSkillSelect:prepareClose()
    return
  end
  PaGloabl_BlackSpiritSkillSelect:updateSkillInfo()
  PaGloabl_BlackSpiritSkillSelect:open()
  PaGloabl_BlackSpiritSkillSelect._isOpen = true
end
function PaGloabl_BlackSpiritSkillSelect:open()
  if nil == Panel_Widget_BlackSpirit_SkillSelect then
    return
  end
  Panel_Widget_BlackSpirit_SkillSelect:SetShow(true)
end
function PaGloabl_BlackSpiritSkillSelect:prepareClose()
  if nil == Panel_Widget_BlackSpirit_SkillSelect then
    return
  end
  PaGloabl_BlackSpiritSkillSelect._isOpen = false
  PaGloabl_BlackSpiritSkillSelect:close()
end
function PaGloabl_BlackSpiritSkillSelect:close()
  if nil == Panel_Widget_BlackSpirit_SkillSelect then
    return
  end
  Panel_Widget_BlackSpirit_SkillSelect:SetShow(false)
end
function PaGloabl_BlackSpiritSkillSelect:update()
  if nil == Panel_Widget_BlackSpirit_SkillSelect then
    return
  end
end
function PaGloabl_BlackSpiritSkillSelect:validate()
  if nil == Panel_Widget_BlackSpirit_SkillSelect then
    return
  end
  PaGloabl_BlackSpiritSkillSelect._ui._btn_apply:isValidate()
  PaGloabl_BlackSpiritSkillSelect._ui._btn_cancel:isValidate()
  PaGloabl_BlackSpiritSkillSelect._ui._btn_skinSelect:isValidate()
end
function PaGloabl_BlackSpiritSkillSelect:updateSkillInfo()
  if nil == Panel_Widget_BlackSpirit_SkillSelect then
    return
  end
  local blackSpiritCount = ToClient_getBlackSpiritFromInfoList()
  local imageCnt = 0
  for index = 0, blackSpiritCount - 1 do
    if nil == PaGloabl_BlackSpiritSkillSelect._control[index] then
      local control = UI.cloneControl(PaGloabl_BlackSpiritSkillSelect._ui._btn_skinSelect, Panel_Widget_BlackSpirit_SkillSelect, "Button_SpiritSkinSelect_" .. index)
      PaGloabl_BlackSpiritSkillSelect._control[index] = control
      PaGloabl_BlackSpiritSkillSelect._control[index]:addInputEvent("Mouse_LUp", "HandleEventLUp_BlackSpiritSkillSelect_ChangeIndex(" .. index .. ")")
    end
    PaGloabl_BlackSpiritSkillSelect._control[index]:SetShow(true)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGloabl_BlackSpiritSkillSelect._control[index], 1, 1, 206, 206)
    PaGloabl_BlackSpiritSkillSelect._control[index]:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGloabl_BlackSpiritSkillSelect._control[index]:setRenderTexture(PaGloabl_BlackSpiritSkillSelect._control[index]:getBaseTexture())
    local blackSpiritKey = ToClient_getBlackSpiritFromInfoByIndex(index)
    local blackSpiritSkin = UI.getChildControl(PaGloabl_BlackSpiritSkillSelect._control[index], "Static_Skin_1")
    if nil ~= PaGloabl_BlackSpiritSkillSelect._texUV[blackSpiritKey] then
      blackSpiritSkin:ChangeTextureInfoName("renewal/pcremaster/remaster_blackspirit_00.dds")
      local uvX1, uvY1, uvX2, uvY2 = setTextureUV_Func(blackSpiritSkin, PaGloabl_BlackSpiritSkillSelect._texUV[blackSpiritKey][1], PaGloabl_BlackSpiritSkillSelect._texUV[blackSpiritKey][2], PaGloabl_BlackSpiritSkillSelect._texUV[blackSpiritKey][3], PaGloabl_BlackSpiritSkillSelect._texUV[blackSpiritKey][4])
      blackSpiritSkin:getBaseTexture():setUV(uvX1, uvY1, uvX2, uvY2)
      blackSpiritSkin:setRenderTexture(blackSpiritSkin:getBaseTexture())
      blackSpiritSkin:ComputePos()
      imageCnt = imageCnt + 1
    else
      PaGloabl_BlackSpiritSkillSelect._control[index]:SetShow(false)
    end
    local appyingText = UI.getChildControl(PaGloabl_BlackSpiritSkillSelect._control[index], "StaticText_Appying")
    if ToClient_getBlackSpiritFromInfoByIndex(index) == ToClient_getCurrentFormIndex() then
      appyingText:SetShow(true)
      PaGloabl_BlackSpiritSkillSelect._blackSpiritKey = ToClient_getBlackSpiritFromInfoByIndex(index)
    else
      appyingText:SetShow(false)
    end
  end
  PaGloabl_BlackSpiritSkillSelect:setControlPos(imageCnt)
end
function PaGloabl_BlackSpiritSkillSelect:setControlPos(imageCnt)
  UI.ASSERT_NAME(nil ~= imageCnt, "PaGloabl_BlackSpiritSkillSelect:setControlPos\236\157\152 imageCnt nil\236\157\180\235\169\180 \236\149\136\235\144\156\235\139\164.", "\234\185\128\236\156\164\236\167\128")
  if nil == PaGloabl_BlackSpiritSkillSelect._control[0] then
    return
  end
  local padding = 15
  PaGloabl_BlackSpiritSkillSelect._control[0]:ComputePos()
  local sizeX = PaGloabl_BlackSpiritSkillSelect._control[0]:GetSizeX()
  local sizeY = PaGloabl_BlackSpiritSkillSelect._control[0]:GetSizeY()
  local movePosX = 0
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  if screenSizeX <= (sizeX + padding) * imageCnt then
    local rate = screenSizeX / ((sizeX + padding) * imageCnt) - 0.05
    sizeX = PaGloabl_BlackSpiritSkillSelect._control[0]:GetSizeX() * rate
    sizeY = PaGloabl_BlackSpiritSkillSelect._control[0]:GetSizeY() * rate
    movePosX = PaGloabl_BlackSpiritSkillSelect._control[0]:GetSizeX() * (1 - rate) / 2
    PaGloabl_BlackSpiritSkillSelect._control[0]:SetSize(sizeX, sizeY)
    PaGloabl_BlackSpiritSkillSelect:SetControlSize(rate)
    PaGloabl_BlackSpiritSkillSelect:ControlComputePos()
    PaGloabl_BlackSpiritSkillSelect:SetControlPosY()
    PaGloabl_BlackSpiritSkillSelect._defaultPosX = PaGloabl_BlackSpiritSkillSelect._ui._btn_skinSelect:GetPosX() + movePosX
  end
  local dialogSizeY = 0
  if false == _ContentsGroup_NewUI_Dialog_All then
    dialogSizeY = Panel_Npc_Dialog:GetSizeY()
  else
    dialogSizeY = Panel_Npc_Dialog_All:GetSizeY()
  end
  if screenSizeY - dialogSizeY <= PaGloabl_BlackSpiritSkillSelect._totalSizeY then
    local rate = (screenSizeY - dialogSizeY) / PaGloabl_BlackSpiritSkillSelect._totalSizeY - 0.1
    sizeX = PaGloabl_BlackSpiritSkillSelect._control[0]:GetSizeX() * rate
    sizeY = PaGloabl_BlackSpiritSkillSelect._control[0]:GetSizeY() * rate
    movePosX = movePosX + PaGloabl_BlackSpiritSkillSelect._control[0]:GetSizeX() * (1 - rate) / 2
    PaGloabl_BlackSpiritSkillSelect._control[0]:SetSize(sizeX, sizeY)
    PaGloabl_BlackSpiritSkillSelect:SetControlSize(rate)
    PaGloabl_BlackSpiritSkillSelect:ControlComputePos()
    PaGloabl_BlackSpiritSkillSelect:SetControlPosY()
    PaGloabl_BlackSpiritSkillSelect._defaultPosX = PaGloabl_BlackSpiritSkillSelect._ui._btn_skinSelect:GetPosX() + movePosX
  end
  local blackSpiritCount = ToClient_getBlackSpiritFromInfoList()
  local grid = math.floor(imageCnt / 2)
  local centerPosX = PaGloabl_BlackSpiritSkillSelect._defaultPosX + sizeX / 2
  local imageIndex = 0
  for index = 0, blackSpiritCount - 1 do
    local blackSpiritSkin = UI.getChildControl(PaGloabl_BlackSpiritSkillSelect._control[index], "Static_Skin_1")
    local appyingText = UI.getChildControl(PaGloabl_BlackSpiritSkillSelect._control[index], "StaticText_Appying")
    PaGloabl_BlackSpiritSkillSelect._control[index]:SetSize(sizeX, sizeY)
    blackSpiritSkin:SetSize(sizeX, sizeY)
    PaGloabl_BlackSpiritSkillSelect._control[index]:ComputePos()
    blackSpiritSkin:ComputePos()
    appyingText:ComputePos()
    if true == PaGloabl_BlackSpiritSkillSelect._control[index]:GetShow() then
      if 0 == imageCnt % 2 then
        if grid > imageIndex then
          PaGloabl_BlackSpiritSkillSelect._control[index]:SetPosX(centerPosX - (sizeX + padding) * (grid - imageIndex))
        elseif imageIndex == grid then
          PaGloabl_BlackSpiritSkillSelect._control[index]:SetPosX(centerPosX)
        elseif grid < imageIndex then
          PaGloabl_BlackSpiritSkillSelect._control[index]:SetPosX(centerPosX + (sizeX + padding) * (imageIndex - grid))
        end
      elseif grid > imageIndex then
        PaGloabl_BlackSpiritSkillSelect._control[index]:SetPosX(PaGloabl_BlackSpiritSkillSelect._defaultPosX - (sizeX + padding) * (grid - imageIndex))
      elseif imageIndex == grid then
        PaGloabl_BlackSpiritSkillSelect._control[index]:SetPosX(PaGloabl_BlackSpiritSkillSelect._defaultPosX)
      elseif grid < imageIndex then
        PaGloabl_BlackSpiritSkillSelect._control[index]:SetPosX(PaGloabl_BlackSpiritSkillSelect._defaultPosX + (sizeX + padding) * (imageIndex - grid))
      end
      imageIndex = imageIndex + 1
    end
  end
end
function PaGloabl_BlackSpiritSkillSelect:CheckBoxSelect()
  local Change_BlackSpirit = function()
    ToClient_getBlackSpiritFromInfoList()
    ToClient_setCurrentFormIndex(PaGloabl_BlackSpiritSkillSelect._blackSpiritKey)
    PaGloabl_BlackSpiritSkillSelect_Close()
  end
  if PaGloabl_BlackSpiritSkillSelect._blackSpiritKey ~= ToClient_getCurrentFormIndex() then
    local memoTitle = PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_CHANGETITLE")
    local memoContent = PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_CHANGECONTENT")
    local messageBoxData = {
      title = memoTitle,
      content = memoContent,
      functionYes = Change_BlackSpirit,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_MESSAGE_APPLIED"))
  end
end
function PaGloabl_BlackSpiritSkillSelect:ControlComputePos()
  Panel_Widget_BlackSpirit_SkillSelect:ComputePos()
  local skinDesc = UI.getChildControl(Panel_Widget_BlackSpirit_SkillSelect, "StaticText_SkinSelectDesc")
  local skinTitle = UI.getChildControl(Panel_Widget_BlackSpirit_SkillSelect, "StaticText_SkinSelectTitle")
  skinDesc:ComputePos()
  skinTitle:ComputePos()
  PaGloabl_BlackSpiritSkillSelect._ui._btn_apply:ComputePos()
  PaGloabl_BlackSpiritSkillSelect._ui._btn_cancel:ComputePos()
  PaGloabl_BlackSpiritSkillSelect._ui._btn_skinSelect:ComputePos()
  PaGloabl_BlackSpiritSkillSelect._totalSizeY = PaGloabl_BlackSpiritSkillSelect._ui._btn_apply:GetPosY() + PaGloabl_BlackSpiritSkillSelect._ui._btn_apply:GetSizeY() / 2
end
function PaGloabl_BlackSpiritSkillSelect:SetControlSize(rate)
  UI.ASSERT_NAME(nil ~= rate, "PaGloabl_BlackSpiritSkillSelect:SetControlSize\236\157\152 rate nil\236\157\180\235\169\180 \236\149\136\235\144\156\235\139\164.", "\234\185\128\236\156\164\236\167\128")
  local skinDesc = UI.getChildControl(Panel_Widget_BlackSpirit_SkillSelect, "StaticText_SkinSelectDesc")
  local skinTitle = UI.getChildControl(Panel_Widget_BlackSpirit_SkillSelect, "StaticText_SkinSelectTitle")
  skinDesc:SetSize(skinDesc:GetSizeX() * rate, skinDesc:GetSizeY() * rate)
  skinTitle:SetSize(skinTitle:GetSizeX() * rate, skinTitle:GetSizeY() * rate)
end
function PaGloabl_BlackSpiritSkillSelect:SetControlPosY()
  local skinDesc = UI.getChildControl(Panel_Widget_BlackSpirit_SkillSelect, "StaticText_SkinSelectDesc")
  local skinTitle = UI.getChildControl(Panel_Widget_BlackSpirit_SkillSelect, "StaticText_SkinSelectTitle")
  local sizeY = PaGloabl_BlackSpiritSkillSelect._control[0]:GetSizeY() / 2
  PaGloabl_BlackSpiritSkillSelect._control[0]:SetPosY(skinDesc:GetPosY() + sizeY)
  local posY = PaGloabl_BlackSpiritSkillSelect._control[0]:GetPosY()
  local padding = posY - skinDesc:GetPosY()
  posY = posY + sizeY + padding
  PaGloabl_BlackSpiritSkillSelect._ui._btn_apply:SetPosY(posY)
  PaGloabl_BlackSpiritSkillSelect._ui._btn_cancel:SetPosY(posY)
  PaGloabl_BlackSpiritSkillSelect._totalSizeY = PaGloabl_BlackSpiritSkillSelect._ui._btn_apply:GetPosY() + PaGloabl_BlackSpiritSkillSelect._ui._btn_apply:GetSizeY() / 2
end
