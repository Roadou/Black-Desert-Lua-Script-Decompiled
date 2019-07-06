local ItemLogManager = {
  _init = false,
  _panel = Panel_Widget_ItemLog_Renew,
  _config = {
    _slotPosition = {},
    _maxShowingLogSize = 5,
    _updateTime = 0.1
  },
  _logInfos = {},
  _readyLogs = {},
  _showingLogs = {},
  _moveUpDurationTime = 0.5,
  _showDurationTime = 1.5,
  _hideDurationTime = 0.2,
  _startAniTime = 1,
  _rowPaddingY = 3,
  _updateTime = 0
}
local ItemLog = {}
ItemLog.__index = ItemLog
function ItemLog.new(index, bgControl, padding)
  local log = {
    index = index,
    bgControl = bgControl,
    padding = padding or 10,
    iconControl = UI.getChildControl(bgControl, "Static_IconBg"),
    titleControl = UI.getChildControl(bgControl, "StaticText_ItemLog"),
    itemEnchantKey = 0,
    slotNo = CppEnums.TInventorySlotNoUndefined,
    itemCount = 0,
    rowIndex = -1,
    remainShowingTime = -1,
    remainHidingTime = -1
  }
  log.titleControl:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  setmetatable(log, ItemLog)
  return log
end
function ItemLog:getBottomPosY()
  return self.bgControl:GetPosY() + self:getSizeY()
end
function ItemLog:getSizeY()
  return self.bgControl:GetSizeY()
end
function ItemLog:show(itemEnchantKey, slotNo, itemCount, posY)
  self.itemEnchantKey = itemEnchantKey
  self.slotNo = slotNo
  self.itemCount = itemCount
  self.rowIndex = 0
  self.bgControl:ResetVertexAni(true)
  self.iconControl:ResetVertexAni(true)
  self.titleControl:ResetVertexAni(true)
  local item = getItemEnchantStaticStatus(ItemEnchantKey(itemEnchantKey))
  self.iconControl:ChangeTextureInfoName("icon/" .. item:getIconPath())
  self.titleControl:SetText(item:getName() .. " x " .. tostring(itemCount))
  local grade = item:getGradeType()
  self.bgControl:ChangeTextureInfoName("renewal/frame/console_frame_00.dds")
  if 4 == grade then
    local x1, y1, x2, y2 = setTextureUV_Func(self.bgControl, 1, 407, 305, 413)
    self.bgControl:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif 3 == grade then
    local x1, y1, x2, y2 = setTextureUV_Func(self.bgControl, 1, 414, 305, 420)
    self.bgControl:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif 2 == grade then
    local x1, y1, x2, y2 = setTextureUV_Func(self.bgControl, 1, 421, 305, 427)
    self.bgControl:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif 1 == grade then
    local x1, y1, x2, y2 = setTextureUV_Func(self.bgControl, 1, 428, 305, 434)
    self.bgControl:getBaseTexture():setUV(x1, y1, x2, y2)
  else
    local x1, y1, x2, y2 = setTextureUV_Func(self.bgControl, 1, 435, 305, 441)
    self.bgControl:getBaseTexture():setUV(x1, y1, x2, y2)
  end
  self.bgControl:setRenderTexture(self.bgControl:getBaseTexture())
  self.bgControl:SetPosY(posY or 0)
  self.bgControl:SetColor(Defines.Color.C_FFFFFFFF)
  self.iconControl:SetColor(Defines.Color.C_FFFFFFFF)
  self.titleControl:SetColor(Defines.Color.C_FFFFFFFF)
  self.bgControl:SetShow(true)
end
function ItemLog:hide()
  self.bgControl:SetShow(false)
end
function ItemLog:getShow()
  return self.bgControl:GetShow()
end
function ItemLog:setPosY(posY)
  self.bgControl:SetPosY(posY)
end
function ItemLog:toString()
  return "ItemLog[" .. self.index .. "]" .. self.itemEnchantKey .. "/" .. self.slotNo .. "/" .. tostring(self.itemCount) .. "/" .. tostring(self.bgControl) .. "/" .. tostring(self.iconControl) .. "/" .. tostring(self.titleControl)
end
function ItemLog:checkEmpty()
  return 0 == self.itemEnchantKey or 0 == self.itemCount or nil == self.bgControl or nil == self.iconControl or nil == self.titleControl
end
function ItemLog:reset()
  self.bgControl:SetAlpha(1)
  self.iconControl:SetAlpha(1)
  self.titleControl:SetFontAlpha(1)
end
function ItemLog:moveUp(duration)
  if self:checkEmpty() then
    return false
  end
  self.rowIndex = self.rowIndex + 1
  local posY = -1 * (self.bgControl:GetSizeY() + self.padding) * self.rowIndex
  local aniInfo = self.bgControl:addMoveAnimation(0, duration, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo:SetStartPosition(self.bgControl:GetPosX(), self.bgControl:GetPosY())
  aniInfo:SetEndPosition(self.bgControl:GetPosX(), posY)
  return true
end
function ItemLog:fadeOut(duration, startTime)
  if self:checkEmpty() then
    return false
  end
  local aniInfo = self.bgControl:addColorAnimation(startTime, duration, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo:SetStartColor(Defines.Color.C_FFFFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_00FFFFFF)
  aniInfo:SetHideAtEnd(true)
  aniInfo.IsChangeChild = true
  return true
end
function ItemLogManager:initialize()
  if self._init then
    return
  end
  self._init = true
  local bgTemplate = UI.getChildControl(self._panel, "Static_Bg")
  bgTemplate:SetShow(false)
  local startYPos = self._panel:GetSizeY() * 0.5 + bgTemplate:GetSizeY() * 2
  for i = 1, self._config._maxShowingLogSize do
    local control = UI.cloneControl(bgTemplate, self._panel, "StaticText_ItemLog" .. i)
    local log = ItemLog.new(i, control, self._rowPaddingY)
    table.insert(self._readyLogs, log)
    self._config._slotPosition[i] = startYPos - bgTemplate:GetSizeY() * (i - 1)
  end
  registerEvent("EventAddItemToInventory", "PaGlobalFunc_ItemLogHandleItemAdd")
  self._panel:RegisterUpdateFunc("PaGlobalFunc_ItemLogPerFrameUpdate")
  return true
end
function PaGlobalFunc_ItemLogInit()
  if ItemLogManager:initialize() then
    return ItemLogManager:update()
  end
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_ItemLogInit")
function ItemLogManager:handleItemAdd(itemEnchantKey, slotNo, itemCount)
  local info = {
    itemEnchantKey = itemEnchantKey,
    slotNo = slotNo,
    itemCount = itemCount
  }
  table.insert(self._logInfos, info)
  if not self:checkShow() then
    return self:open()
  end
end
function PaGlobalFunc_ItemLogHandleItemAdd(itemEnchantKey, slotNo, itemCount)
  if ItemLogManager:handleItemAdd(itemEnchantKey, slotNo, itemCount) then
    return ItemLogManager:update()
  end
end
function ItemLogManager:open()
  self._panel:SetShow(true)
  return true
end
function ItemLogManager:checkShow()
  return self._panel:GetShow()
end
function ItemLogManager:close()
  if not self:checkShow() then
    return
  end
  self._panel:SetShow(false)
end
function ItemLogManager:updateToShow()
  if 0 < table.getn(self._logInfos) and 0 < table.getn(self._readyLogs) then
    local info = table.remove(self._logInfos, 1)
    local log = table.remove(self._readyLogs, 1)
    log:show(info.itemEnchantKey, info.slotNo, info.itemCount, self._config._slotPosition[1])
    log:fadeOut(self._showDurationTime, self._startAniTime)
    local bottomPosY = 0
    local showingLogCount = table.getn(self._showingLogs)
    if showingLogCount > 0 then
      local UIindex = 2
      for i = table.getn(self._showingLogs), 1, -1 do
        if UIindex > self._config._maxShowingLogSize then
          _PA_LOG("\236\157\180\235\139\164\237\152\156", "Index Error!")
        else
          self._showingLogs[i]:setPosY(self._config._slotPosition[UIindex])
          UIindex = UIindex + 1
        end
      end
    end
    log.remainShowingTime = self._showDurationTime
    log.remainHidingTime = -1
    table.insert(self._showingLogs, log)
    return true
  end
end
function ItemLogManager:updateToHide()
  for i = 1, table.getn(self._showingLogs) do
    local log = self._showingLogs[i]
  end
end
function ItemLogManager:updateToRemove()
  for i = table.getn(self._showingLogs), 1, -1 do
    local log = self._showingLogs[i]
    if false == log:getShow() then
      log:reset()
      table.remove(self._showingLogs, i)
      table.insert(self._readyLogs, log)
    end
  end
end
function ItemLogManager:moveAllUp()
  for i = 1, table.getn(self._showingLogs) do
    local log = self._showingLogs[i]
    log:moveUp(self._moveUpDurationTime)
  end
end
function ItemLogManager:update()
  if self:updateToShow() then
    return true
  end
  self:updateToRemove()
end
function ItemLogManager:perFrameUpdate(delta)
  for i = 1, table.getn(self._showingLogs) do
    local log = self._showingLogs[i]
    if 0 < log.remainShowingTime then
      log.remainShowingTime = math.max(0, log.remainShowingTime - delta)
    elseif 0 < log.remainHidingTime then
      log.remainHidingTime = math.max(0, log.remainHidingTime - delta)
    end
  end
  return true
end
function PaGlobalFunc_ItemLogPerFrameUpdate(delta)
  ItemLogManager._updateTime = ItemLogManager._updateTime + delta
  if ItemLogManager._config._updateTime < ItemLogManager._updateTime then
    ItemLogManager:update()
    ItemLogManager._updateTime = 0
  end
end
