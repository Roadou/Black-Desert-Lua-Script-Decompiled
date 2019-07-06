Instance_QuickSlot:SetShow(false, false)
Instance_QuickSlot:SetPosX((getScreenSizeX() - Instance_QuickSlot:GetSizeX()) / 2)
Instance_QuickSlot:SetPosY(getScreenSizeY() - Instance_QuickSlot:GetSizeY())
local SPECICON_FLAG = true
function isUseNewQuickSlot()
  return false
end
local UI_TM = CppEnums.TextMode
Instance_QuickSlot:RegisterShowEventFunc(true, "QuickSlot_ShowAni()")
Instance_QuickSlot:RegisterShowEventFunc(false, "QuickSlot_HideAni()")
Instance_CoolTime_Effect_Item_Slot:RegisterShowEventFunc(true, "QuickSlot_ItemCoolTimeEffect_HideAni()")
Instance_CoolTime_Effect_Slot:RegisterShowEventFunc(true, "QuickSlot_SkillCoolTimeEffect_HideAni()")
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TISNU = CppEnums.TInventorySlotNoUndefined
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
local quickSlotBg = UI.getChildControl(Instance_QuickSlot, "Static_Main_BG")
local quickSlotText = UI.getChildControl(Instance_QuickSlot, "StaticText_quickSlot")
local quickSlot = {
  slotConfig_Item = {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createCooltime = true,
    createCooltimeText = true,
    createCash = true,
    createEnchant = true,
    createQuickslotBagIcon = true
  },
  slotConfig_Skill = {
    createIcon = true,
    createEffect = true,
    createFG = false,
    createFGDisabled = false,
    createLevel = false,
    createLearnButton = false,
    createCooltime = true,
    createCooltimeText = true,
    template = {effect}
  },
  config = {
    slotCount = 10,
    slotInitStartX = -5,
    slotInitStartY = 13,
    slotInitGapX = 0,
    slotInitGapY = 55
  },
  template = {
    slotBackground = UI.getChildControl(Instance_QuickSlot, "StaticText_Slot_BG_Txt")
  },
  slots = {},
  eSpecIconType = {
    non = 0,
    shield = 1,
    stun = 2,
    catch = 3
  },
  specIconUV = {
    [1] = float4(217, 391, 240, 414),
    [2] = float4(241, 391, 264, 414),
    [3] = float4(193, 391, 216, 414)
  },
  specTooltipTitleKey = {
    "LUA_INSTANCE_QUICKSLOT_SPECICON_TOOLTIP_SHIELD_TITLE",
    "LUA_INSTANCE_QUICKSLOT_SPECICON_TOOLTIP_STUN_TITLE",
    "LUA_INSTANCE_QUICKSLOT_SPECICON_TOOLTIP_CATCH_TITLE"
  },
  specTooltipDescKey = {
    "LUA_INSTANCE_QUICKSLOT_SPECICON_TOOLTIP_SHIELD_DESC",
    "LUA_INSTANCE_QUICKSLOT_SPECICON_TOOLTIP_STUN_DESC",
    "LUA_INSTANCE_QUICKSLOT_SPECICON_TOOLTIP_CATCH_DESC"
  },
  specTooltipTitle = {},
  specTooltipDesc = {},
  specIconGroups = {},
  specIcons = {},
  isSpecIcon = {},
  specIconMaxCount = 3,
  _staticText_SkillDescList = {},
  numberNames = {
    "Static_No_1",
    "Static_No_2",
    "Static_No_3",
    "Static_No_4",
    "Static_No_5",
    "Static_No_6",
    "Static_No_7",
    "Static_No_8",
    "Static_No_9",
    "Static_No_10"
  },
  skillToggle = {
    "Static_SkillToggle_1",
    "Static_SkillToggle_2",
    "Static_SkillToggle_3",
    "Static_SkillToggle_4",
    "Static_SkillToggle_5",
    "Static_SkillToggle_6",
    "Static_SkillToggle_7",
    "Static_SkillToggle_8",
    "Static_SkillToggle_9",
    "Static_SkillToggle_10"
  },
  quickSlotInit = false,
  initPosX = Instance_QuickSlot:GetPosX(),
  initPosY = Instance_QuickSlot:GetPosY(),
  btn_viewCommand = UI.getChildControl(Instance_QuickSlot, "CheckButton_ViewCommand"),
  isViewCommand = true,
  skillKeysMaxCount = 5,
  skillCommandTextMaxCount = 2,
  skillCommandsPlusIconCount = 2,
  skillInfos = {},
  skillNames = {},
  skillCommands = {},
  skillKeys = {},
  commandControls = {},
  skillCommandsPlusIcon = {},
  _itemSlotIndexGap = 10,
  _eView = {command = 0, skillDesc = 1},
  _eViewState = 0,
  _isLearnedList = {},
  _isNewIndexArray = {},
  _isTimerArray = {},
  _deltaTimeArray = {},
  _DESC_ACTIVE_TIME = 3,
  _slotData = {}
}
PaGlobal_QuickSlot = {}
function PaGlobal_QuickSlot:addSlotEffectForTutorial(itemSlot, effectString, isLoop, posX, posY)
  itemSlot.item.icon:AddEffect(effectString, isLoop, posX, posY)
  PaGlobal_TutorialUiManager:getUiMasking():showQuickSlotMasking(itemSlot.item.icon:GetPosX(), itemSlot.item.icon:GetPosY())
end
function PaGlobal_QuickSlot:eraseSlotEffectForTutorial(itemSlot)
  if nil ~= itemSlot and nil ~= itemSlot.item then
    itemSlot.item.icon:EraseAllEffect()
    PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
  end
end
function PaGlobal_QuickSlot:getSlotByIndex(slotIndex)
  if slotIndex <= #quickSlot.slots then
    return quickSlot.slots[slotIndex]
  end
  _PA_ASSERT(false, "\234\184\176\235\179\184\237\128\181\236\138\172\235\161\175\236\157\152 \235\178\148\236\156\132\235\165\188 \236\180\136\234\179\188\237\150\136\236\138\181\235\139\136\235\139\164.")
end
function quickSlot:init()
  self:initSkillDesc()
  self.btn_viewCommand:addInputEvent("Mouse_LUp", "QuickSlot_ShowCommandCheck()")
  local index = 0
  for ii = 1, self.config.slotCount do
    index = ii - 1
    self._isLearnedList[index] = false
    self._isNewIndexArray[index] = false
    self._isTimerArray[index] = false
    self._deltaTimeArray[index] = 0
    self.commandControls[ii] = {}
    if 1 == ii then
      self.skillInfos[ii] = UI.getChildControl(Instance_QuickSlot, "Static_SkillInfo_1")
    else
      self.skillInfos[ii] = UI.cloneControl(self.skillInfos[1], Instance_QuickSlot, "Static_SkillInfo_" .. ii)
      if false == SPECICON_FLAG then
        self.skillInfos[ii]:SetPosY(self:getCommandPosY(index))
      end
    end
    self.skillNames[ii] = UI.getChildControl(self.skillInfos[ii], "StaticText_Name")
    self.skillCommands[ii] = UI.getChildControl(self.skillInfos[ii], "StaticText_Command")
    self.skillKeys[ii] = UI.getChildControl(self.skillInfos[ii], "StaticText_Key")
    self.skillKeys[ii] = {}
    for jj = 1, self.skillKeysMaxCount do
      self.skillKeys[ii][jj] = UI.createAndCopyBasePropertyControl(self.skillInfos[ii], "StaticText_Key", self.skillInfos[ii], "StaticText_Key_" .. ii .. "_" .. jj)
    end
    self.skillCommands[ii] = {}
    for jj = 1, self.skillCommandTextMaxCount do
      self.skillCommands[ii][jj] = UI.createAndCopyBasePropertyControl(self.skillInfos[ii], "StaticText_Command", self.skillInfos[ii], "StaticText_Command_" .. ii .. "_" .. jj)
    end
    self.skillCommandsPlusIcon[ii] = {}
    for jj = 1, self.skillCommandsPlusIconCount do
      self.skillCommandsPlusIcon[ii][jj] = UI.createAndCopyBasePropertyControl(self.skillInfos[ii], "Static_Plus", self.skillInfos[ii], "Static_Plus_" .. ii .. "_" .. jj)
    end
    self.skillInfos[ii]:SetShow(false)
  end
  self:initSpecIcon()
  if false == _ContentsGroup_RenewUI_Skill then
    quickSlot.slotConfig_Skill.template.effect = UI.getChildControl(Instance_Window_Skill, "Static_Icon_Skill_Effect")
  else
    quickSlot.slotConfig_Skill.template.effect = PaGlobalFunc_Skill_GetEffectControl()
  end
end
function QuickSlot_ShowAni()
  Instance_QuickSlot:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
  local QuickSlotOpen_Alpha = Instance_QuickSlot:addColorAnimation(0, 0.35, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  QuickSlotOpen_Alpha:SetStartColor(UI_color.C_00FFFFFF)
  QuickSlotOpen_Alpha:SetEndColor(UI_color.C_FFFFFFFF)
  QuickSlotOpen_Alpha.IsChangeChild = true
end
function QuickSlot_HideAni()
  Instance_QuickSlot:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local QuickSlotClose_Alpha = Instance_QuickSlot:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  QuickSlotClose_Alpha:SetStartColor(UI_color.C_FFFFFFFF)
  QuickSlotClose_Alpha:SetEndColor(UI_color.C_00FFFFFF)
  QuickSlotClose_Alpha.IsChangeChild = true
  QuickSlotClose_Alpha:SetHideAtEnd(true)
  QuickSlotClose_Alpha:SetDisableWhileAni(true)
end
function QuickSlot_ItemCoolTimeEffect_HideAni()
  audioPostEvent_SystemUi(2, 4)
  _AudioPostEvent_SystemUiForXBOX(2, 4)
  Instance_CoolTime_Effect_Item_Slot:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local coolTime_Item_Slot = Instance_CoolTime_Effect_Item_Slot:addColorAnimation(0, 3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  coolTime_Item_Slot:SetStartColor(UI_color.C_FFFFFFFF)
  coolTime_Item_Slot:SetEndColor(UI_color.C_00FFFFFF)
  coolTime_Item_Slot:SetStartIntensity(3)
  coolTime_Item_Slot:SetEndIntensity(1)
  coolTime_Item_Slot.IsChangeChild = true
  coolTime_Item_Slot:SetHideAtEnd(true)
  coolTime_Item_Slot:SetDisableWhileAni(true)
end
function QuickSlot_SkillCoolTimeEffect_HideAni()
  audioPostEvent_SystemUi(2, 0)
  _AudioPostEvent_SystemUiForXBOX(2, 0)
  Instance_CoolTime_Effect_Slot:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local coolTime_Slot = Instance_CoolTime_Effect_Slot:addColorAnimation(0, 3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  coolTime_Slot:SetStartColor(UI_color.C_FFFFFFFF)
  coolTime_Slot:SetEndColor(UI_color.C_00FFFFFF)
  coolTime_Slot:SetStartIntensity(3)
  coolTime_Slot:SetEndIntensity(1)
  coolTime_Slot.IsChangeChild = true
  coolTime_Slot:SetHideAtEnd(true)
  coolTime_Slot:SetDisableWhileAni(true)
end
function quickSlot:createSlot()
  for ii = 1, self.config.slotCount do
    do
      local slot = {
        index = ii,
        slotType = CppEnums.QuickSlotType.eEmpty,
        keyValue = nil,
        posX = self.config.slotInitStartX + (ii - 0.73) * self.config.slotInitGapX,
        posY = self.config.slotInitStartY + (ii - 1) * self.config.slotInitGapY,
        item = nil,
        skill = nil,
        background = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Instance_QuickSlot, "Static_Slot_BG_" .. ii),
        number = UI.getChildControl(Instance_QuickSlot, self.numberNames[ii]),
        toggle = UI.getChildControl(Instance_QuickSlot, self.skillToggle[ii])
      }
      CopyBaseProperty(self.template.slotBackground, slot.background)
      slot.background:SetShow(true)
      slot.background:SetAlpha(0)
      function slot:rearrangeControl()
        local list = Array.new()
        if CppEnums.QuickSlotType.eItem == self.slotType or CppEnums.QuickSlotType.eCashItem == self.slotType or CppEnums.QuickSlotType.eInstanceItem == self.slotType then
          UI.ASSERT(slot.item, "Item is Null!!!")
          list:push_back(self.background)
          list:push_back(self.item.icon)
          list:push_back(self.number)
        elseif CppEnums.QuickSlotType.eSkill == self.slotType then
          UI.ASSERT(nil ~= slot.skill)
          list:push_back(self.background)
          list:push_back(self.skill.icon)
          list:push_back(self.skill.effect)
          list:push_back(self.number)
          list:push_back(self.toggle)
        else
          list:push_back(self.background)
          list:push_back(self.number)
        end
        for ii = 1, list:length() - 1 do
          for jj = ii + 1, list:length() do
            local first = list[ii]
            local second = list[jj]
            UI.ASSERT(nil ~= first and nil ~= second and first ~= second)
            Instance_QuickSlot:SetChildOrder(list[ii]:GetKey(), list[jj]:GetKey())
          end
        end
      end
      function slot:setPos(posX, posY)
        local tmp
        tmp = self.background
        tmp:SetSize(50, 50)
        tmp:SetPosX(posX)
        tmp:SetPosY(posY)
        local bgSizeX = tmp:GetSizeX()
        local bgSizeY = tmp:GetSizeY()
        if CppEnums.QuickSlotType.eItem == self.slotType or CppEnums.QuickSlotType.eCashItem == self.slotType or CppEnums.QuickSlotType.eInstanceItem == self.slotType then
          tmp = self.item.icon
          tmp:SetSize(42, 42)
          local iconPosX = posX + (bgSizeX - tmp:GetSizeX()) / 2
          local iconPosY = posY + (bgSizeY - tmp:GetSizeY()) / 2
          tmp:SetPosX(iconPosX)
          tmp:SetPosY(iconPosY)
        elseif CppEnums.QuickSlotType.eSkill == self.slotType then
          tmp = self.skill.icon
          tmp:SetSize(42, 42)
          local iconPosX = posX + (bgSizeX - tmp:GetSizeX()) / 2
          local iconPosY = posY + (bgSizeY - tmp:GetSizeY()) / 2
          tmp:SetPosX(iconPosX)
          tmp:SetPosY(iconPosY)
          tmp = self.skill.cooltime
          tmp:SetPosX(iconPosX)
          tmp:SetPosY(iconPosY)
          tmp = self.skill.cooltimeText
          tmp:SetPosX(iconPosX)
          tmp:SetPosY(iconPosY)
          tmp = self.skill.effect
          tmp:SetPosX(posX + (bgSizeX - tmp:GetSizeX()) / 2)
          tmp:SetPosY(posY + (bgSizeY - tmp:GetSizeY()) / 2)
          tmp = self.toggle
          tmp:SetPosX(posX + (bgSizeX - tmp:GetSizeX()) / 2)
          tmp:SetPosY(posY + (bgSizeY - tmp:GetSizeY()) / 2)
        end
        tmp = self.number
        tmp:SetPosX(posX + (bgSizeX - tmp:GetSizeX()) / 2)
        tmp:SetPosY(posY - tmp:GetSizeY() / 2 + bgSizeX)
      end
      function slot:setItem(slotNo, quickSlotInfo, slotData)
        if CppEnums.QuickSlotType.eItem ~= self.slotType and CppEnums.QuickSlotType.eCashItem ~= self.slotType and CppEnums.QuickSlotType.eInstanceItem ~= self.slotType then
          if nil ~= self.skill then
            self.skill:destroyChild()
            Panel_SkillTooltip_Hide()
            self.skill = nil
          end
          if CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type then
            self.slotType = CppEnums.QuickSlotType.eInstanceItem
          else
            self.slotType = quickSlotInfo._type
          end
          local itemSlot = {}
          SlotItem.new(itemSlot, "QuickSlot_" .. slotNo, slotNo, Instance_QuickSlot, quickSlot.slotConfig_Item)
          itemSlot:createChild()
          itemSlot.icon:addInputEvent("Mouse_LUp", "QuickSlot_Click(" .. self.index - 1 .. ")")
          itemSlot.icon:addInputEvent("Mouse_PressMove", "QuickSlot_DragStart(" .. self.index - 1 .. ")")
          itemSlot.icon:SetEnableDragAndDrop(true)
          self.background:SetIgnore(true)
          self.number:AddEffect("UI_SkillButton01", false, 0, 0)
          self.number:AddEffect("fUI_Repair01", false, 0, 0)
          self.background:AddEffect("fUI_Light", false, 0, 0)
          if slotNo == 0 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 1, 17, 16, 32)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 1 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 17, 17, 32, 32)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 2 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 33, 17, 48, 32)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 3 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 49, 17, 64, 32)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 4 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 65, 17, 80, 32)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 5 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 81, 17, 96, 32)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 6 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 97, 17, 112, 32)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 7 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 113, 17, 128, 32)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 8 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 129, 17, 144, 32)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 9 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 145, 17, 160, 32)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          end
          self.item = itemSlot
          self:rearrangeControl()
          self:setPos(self.background:GetPosX(), self.background:GetPosY())
        end
        if CppEnums.QuickSlotType.eEmpty ~= quickSlotInfo._type then
          local selfPlayer = getSelfPlayer():get()
          local inventoryType = QuickSlot_GetInventoryTypeFrom(self.slotType)
          local inventory = selfPlayer:getInventoryByType(inventoryType)
          local invenSlotNo = inventory:getSlot(quickSlotInfo._itemKey)
          local itemStaticWrapper = getItemEnchantStaticStatus(quickSlotInfo._itemKey)
          local _const = Defines.s64_const
          local s64_stackCount = _const.s64_0
          local targetItemNotFound = false
          if UI_TISNU ~= invenSlotNo then
            s64_stackCount = getInventoryItemByType(inventoryType, invenSlotNo):get():getCount_s64()
          else
            targetItemNotFound = true
          end
          slot.background:SetTextMode(UI_TM.eTextMode_AutoWrap)
          if CppEnums.ContentsEventType.ContentsType_InventoryBag == itemStaticWrapper:get():getContentsEventType() then
            invenSlotNo = ToClient_GetItemNoByInventory(inventoryType, quickSlotInfo._itemNo_s64)
            local itemWrapper = getInventoryItemByType(inventoryType, invenSlotNo)
            if nil ~= itemWrapper then
              itemStaticWrapper = itemWrapper:getStaticStatus()
              self.item:setItem(itemWrapper, invenSlotNo)
            else
              targetItemNotFound = true
            end
          else
            self.item:setItemByStaticStatus(itemStaticWrapper, s64_stackCount)
          end
          self.keyValue = invenSlotNo
          self.item.icon:SetMonoTone(targetItemNotFound or _const.s64_0 == s64_stackCount)
        else
          self:setItemBySlotData(slotData)
        end
        local itemSlot = self.item
        itemSlot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"QuickSlot\", true)")
        itemSlot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"QuickSlot\", false)")
        Panel_Tooltip_Item_SetPosition(slotNo, itemSlot, "QuickSlot")
        self.toggle:SetShow(false)
        quickSlot._isLearnedList[slotNo] = false
        quickSlot:setActiveHelperGroup(slotNo, false)
      end
      function slot:setItemBySlotData(slotData)
        local item = PaGlobalFunc_ItemSlot_GetItemData(slotData._key)
        if nil == item then
          self:setSlotItemEmpty(slotData._key)
          return
        end
        local itemWrapper = getInventoryItemByType(self._inventroyType, item.inventoryIdx)
        if nil == itemWrapper then
          self:setSlotItemEmpty(slotData._key)
          return
        end
        self.item:setItem(itemWrapper, item.inventoryIdx)
        self.keyValue = item.inventoryIdx
        self.item._itemCount = item._count
        self.item.icon:SetMonoTone(false)
        self.item._item = item.itemKey
        self.item.count:SetShow(true)
        self.item.count:SetText(tostring(item._count))
        self.key = slotData._key
      end
      function slot:setSlotItemEmpty(key)
        local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(key))
        if nil == itemSSW then
          return
        end
        self.item:setItemByStaticStatus(itemSSW)
        self.item.icon:SetMonoTone(true)
        self.key = key
      end
      function slot:setSkill(slotNo, quickSlotInfo)
        if nil == quickSlotInfo then
          return
        end
        if CppEnums.QuickSlotType.eSkill ~= self.slotType then
          if CppEnums.QuickSlotType.eItem == self.slotType or CppEnums.QuickSlotType.eCashItem == self.slotType or CppEnums.QuickSlotType.eInstanceItem == self.slotType then
            UI.ASSERT(nil ~= self.item)
            UI.deleteControl(self.item.icon)
            Panel_Tooltip_Item_hideTooltip()
            self.item = nil
          end
          self.slotType = CppEnums.QuickSlotType.eSkill
          local skillSlot = {}
          SlotSkill.new(skillSlot, slotNo, Instance_QuickSlot, quickSlot.slotConfig_Skill)
          skillSlot.icon:addInputEvent("Mouse_LUp", "QuickSlot_Click(" .. self.index - 1 .. ")")
          skillSlot.icon:addInputEvent("Mouse_PressMove", "QuickSlot_DragStart(" .. self.index - 1 .. ")")
          skillSlot.icon:SetEnableDragAndDrop(true)
          self.number:AddEffect("UI_SkillButton01", false, 0, 0)
          self.number:AddEffect("fUI_Repair01", false, 0, 0)
          self.background:AddEffect("fUI_Light", false, 0, 0)
          if slotNo == 0 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 1, 33, 16, 48)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 1 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 17, 33, 32, 48)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 2 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 33, 33, 48, 48)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 3 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 49, 33, 64, 48)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 4 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 65, 33, 80, 48)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 5 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 81, 33, 96, 48)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 6 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 97, 33, 112, 48)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 7 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 113, 33, 128, 48)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 8 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 129, 33, 144, 48)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          elseif slotNo == 9 then
            self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(self.number, 145, 33, 160, 48)
            self.number:getBaseTexture():setUV(x1, y1, x2, y2)
            self.number:setRenderTexture(self.number:getBaseTexture())
          end
          self.skill = skillSlot
          self:rearrangeControl()
          self.background:SetIgnore(true)
          self:setPos(self.background:GetPosX(), self.background:GetPosY())
        end
        local skillNo = quickSlotInfo._skillKey:getSkillNo()
        local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
        if nil == skillTypeStaticWrapper then
          return
        end
        self.skill.skillNo = skillNo
        slot.background:SetTextMode(UI_TM.eTextMode_AutoWrap)
        UI.ASSERT(skillTypeStaticWrapper, "get Fail - Skill Type Static Status ")
        self.keyValue = quickSlotInfo._skillKey
        self.skill:setSkillTypeStatic(skillTypeStaticWrapper)
        self.skill.icon:addInputEvent("Mouse_LUp", "QuickSlot_Click(" .. self.index - 1 .. ")")
        self.skill.icon:addInputEvent("Mouse_PressMove", "QuickSlot_DragStart(" .. self.index - 1 .. ")")
        self.skill.icon:addInputEvent("Mouse_On", "Panel_SkillTooltip_Show(" .. slotNo .. ", false, \"QuickSlot\")")
        self.skill.icon:addInputEvent("Mouse_Out", "Panel_SkillTooltip_Hide()")
        Panel_SkillTooltip_SetPosition(slotNo, self.skill.icon, "QuickSlot")
        local isLearned = ToClient_isLearnedSkill(skillNo)
        if true == isLearned then
          quickSlot._isLearnedList[slotNo] = true
          quickSlot:setActiveHelperGroup(slotNo, true)
          QuckSlot_CommandSetting(skillNo, slotNo)
          quickSlot:setSpecIcon(skillNo, slotNo)
          quickSlot:setSkillDesc(skillNo, slotNo)
        else
          quickSlot._isLearnedList[slotNo] = false
          quickSlot:setActiveHelperGroup(slotNo, false)
        end
      end
      function slot:setEmpty()
        if CppEnums.QuickSlotType.eItem == self.slotType or CppEnums.QuickSlotType.eCashItem == self.slotType or CppEnums.QuickSlotType.eInstanceItem == self.slotType then
          UI.ASSERT(nil ~= self.item)
          UI.deleteControl(self.item.icon)
          Panel_Tooltip_Item_hideTooltip()
          self.item = nil
          audioPostEvent_SystemUi(0, 2)
          _AudioPostEvent_SystemUiForXBOX(0, 2)
        elseif CppEnums.QuickSlotType.eSkill == self.slotType then
          UI.ASSERT(nil ~= self.skill)
          self.skill:destroyChild()
          Panel_SkillTooltip_Hide()
          self.skill = nil
          audioPostEvent_SystemUi(0, 9)
          _AudioPostEvent_SystemUiForXBOX(0, 9)
        end
        local index = self.index - 1
        if index == 0 then
          self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
          local x1, y1, x2, y2 = setTextureUV_Func(self.number, 1, 1, 16, 16)
          self.number:getBaseTexture():setUV(x1, y1, x2, y2)
          self.number:setRenderTexture(self.number:getBaseTexture())
        elseif index == 1 then
          self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
          local x1, y1, x2, y2 = setTextureUV_Func(self.number, 17, 1, 32, 16)
          self.number:getBaseTexture():setUV(x1, y1, x2, y2)
          self.number:setRenderTexture(self.number:getBaseTexture())
        elseif index == 2 then
          self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
          local x1, y1, x2, y2 = setTextureUV_Func(self.number, 33, 1, 48, 16)
          self.number:getBaseTexture():setUV(x1, y1, x2, y2)
          self.number:setRenderTexture(self.number:getBaseTexture())
        elseif index == 3 then
          self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
          local x1, y1, x2, y2 = setTextureUV_Func(self.number, 49, 1, 64, 16)
          self.number:getBaseTexture():setUV(x1, y1, x2, y2)
          self.number:setRenderTexture(self.number:getBaseTexture())
        elseif index == 4 then
          self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
          local x1, y1, x2, y2 = setTextureUV_Func(self.number, 65, 1, 80, 16)
          self.number:getBaseTexture():setUV(x1, y1, x2, y2)
          self.number:setRenderTexture(self.number:getBaseTexture())
        elseif index == 5 then
          self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
          local x1, y1, x2, y2 = setTextureUV_Func(self.number, 81, 1, 96, 16)
          self.number:getBaseTexture():setUV(x1, y1, x2, y2)
          self.number:setRenderTexture(self.number:getBaseTexture())
        elseif index == 6 then
          self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
          local x1, y1, x2, y2 = setTextureUV_Func(self.number, 97, 1, 112, 16)
          self.number:getBaseTexture():setUV(x1, y1, x2, y2)
          self.number:setRenderTexture(self.number:getBaseTexture())
        elseif index == 7 then
          self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
          local x1, y1, x2, y2 = setTextureUV_Func(self.number, 113, 1, 128, 16)
          self.number:getBaseTexture():setUV(x1, y1, x2, y2)
          self.number:setRenderTexture(self.number:getBaseTexture())
        elseif index == 8 then
          self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
          local x1, y1, x2, y2 = setTextureUV_Func(self.number, 129, 1, 144, 16)
          self.number:getBaseTexture():setUV(x1, y1, x2, y2)
          self.number:setRenderTexture(self.number:getBaseTexture())
        elseif index == 9 then
          self.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
          local x1, y1, x2, y2 = setTextureUV_Func(self.number, 145, 1, 160, 16)
          self.number:getBaseTexture():setUV(x1, y1, x2, y2)
          self.number:setRenderTexture(self.number:getBaseTexture())
        end
        self.toggle:SetShow(false)
        slot.background:SetText("")
        self.background:SetIgnore(false)
        self.background:addInputEvent("Mouse_LUp", "QuickSlot_DropHandler(" .. self.index - 1 .. ")")
        self.slotType = CppEnums.QuickSlotType.eEmpty
        self.keyValue = nil
        quickSlot._isLearnedList[self.index - 1] = false
        quickSlot:setActiveHelperGroup(self.index - 1, false)
      end
      slot:setPos(slot.posX, slot.posY)
      slot:rearrangeControl()
      self.slots[ii] = slot
    end
  end
end
function QuickSlot_ShowCommandCheck()
  local self = quickSlot
  if true == self.btn_viewCommand:IsCheck() then
    self.isViewCommand = false
  else
    self.isViewCommand = true
  end
  QuickSlot_UpdateData()
end
function quickSlot:skillCommandInit()
  for ii = 1, self.config.slotCount do
    self.skillNames[ii]:SetShow(false)
    self.skillInfos[ii]:SetShow(false)
    if nil ~= self.commandControls[ii].count then
      for jj = 1, self.commandControls[ii].count do
        if nil ~= self.commandControls[ii][jj] then
          self.commandControls[ii][jj]:SetShow(false)
        end
      end
    end
    self.commandControls[ii].width = 0
    self.commandControls[ii].count = 0
  end
end
function quickSlot:stringMatchForConvert(commandIndex, stringIndex, plusIndex)
  local returnValue
  if nil ~= commandIndex then
    returnValue = 0
    if nil ~= stringIndex then
      if stringIndex < commandIndex then
        returnValue = 1
      end
      if nil ~= plusIndex and plusIndex < math.min(commandIndex, stringIndex) then
        returnValue = 2
      end
    elseif nil ~= plusIndex and plusIndex < commandIndex then
      returnValue = 2
    end
  elseif nil ~= stringIndex then
    returnValue = 1
    if nil ~= plusIndex and plusIndex < stringIndex then
      returnValue = 2
    end
  elseif nil ~= plusIndex then
    returnValue = 2
  end
  return returnValue
end
function quickSlot:commandControlSet(controlType, text, uiIndex)
  local tempcontrol
  if 0 == controlType then
    if "LB" == text then
      tempcontrol = UI.getChildControl(self.skillInfos[uiIndex + 1], "Static_MouseL")
    elseif "RB" == text then
      tempcontrol = UI.getChildControl(self.skillInfos[uiIndex + 1], "Static_MouseR")
    else
      local index = self.skillKeys[uiIndex + 1].index
      tempcontrol = self.skillKeys[uiIndex + 1][index]
      if nil ~= tempcontrol then
        self.skillKeys[uiIndex + 1].index = index + 1
        tempcontrol:SetText(text)
        tempcontrol:SetSize(tempcontrol:GetTextSizeX() + 10, tempcontrol:GetSizeY())
      end
    end
  elseif 1 == controlType then
    local index = self.skillCommands[uiIndex + 1].index
    tempcontrol = self.skillCommands[uiIndex + 1][index]
    if nil ~= tempcontrol then
      self.skillCommands[uiIndex + 1].index = index + 1
      tempcontrol:SetText(text)
      tempcontrol:SetSize(tempcontrol:GetTextSizeX(), tempcontrol:GetSizeY())
    end
  elseif 2 == controlType then
    local index = self.skillCommandsPlusIcon[uiIndex + 1].index
    tempcontrol = self.skillCommandsPlusIcon[uiIndex + 1][index]
    if nil ~= tempcontrol then
      self.skillCommandsPlusIcon[uiIndex + 1].index = index + 1
    end
  end
  if nil ~= tempcontrol then
    self.commandControls[uiIndex + 1][self.commandControls[uiIndex + 1].count + 1] = tempcontrol
    self.commandControls[uiIndex + 1].width = self.commandControls[uiIndex + 1].width + tempcontrol:GetSizeX()
    self.commandControls[uiIndex + 1].count = self.commandControls[uiIndex + 1].count + 1
    tempcontrol:SetShow(true)
  end
end
function quickSlot:skillCommandChange(command, index, skillNo)
  local self = quickSlot
  local commandIndex = string.find(command, "<")
  local stringIndex = string.find(command, "[%[]")
  local plusIndex = string.find(command, "+")
  local swapIndex = self:stringMatchForConvert(commandIndex, stringIndex, plusIndex)
  if 0 == swapIndex then
    local text = string.sub(command, commandIndex + 1, string.find(command, ">") - 1)
    self:commandControlSet(0, text, index)
    command = string.gsub(command, "<" .. text .. ">", "", 1)
  elseif 1 == swapIndex then
    local text = string.sub(command, stringIndex + 1, string.find(command, "[%]]") - 1)
    self:commandControlSet(1, text, index)
    command = string.gsub(command, "[%[]" .. text .. "[%]]", "", 1)
  elseif 2 == swapIndex then
    local text = string.sub(command, plusIndex, plusIndex)
    self:commandControlSet(2, text, index)
    command = string.gsub(command, "+", "", 1)
  else
    return
  end
  command = self:skillCommandChange(command, index, skillNo)
end
function quickSlot:skillCommandPos(slotNo)
  local posX = self.skillNames[slotNo + 1]:GetTextSizeX() + 5
  if 0 < self.commandControls[slotNo + 1].count then
    for ii = 1, self.commandControls[slotNo + 1].count do
      self.commandControls[slotNo + 1][ii]:SetPosX(posX)
      posX = posX + self.commandControls[slotNo + 1][ii]:GetSizeX() + 5
    end
  else
    local strOnlyKey = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_QUICKSLOT_ONLYKEY", "slotNo", slotNo + 1)
    self.skillNames[slotNo + 1]:SetText(strOnlyKey)
    posX = self.skillNames[slotNo + 1]:GetTextSizeX() + 10
  end
  self.skillInfos[slotNo + 1]:SetSize(posX, self.skillInfos[slotNo + 1]:GetSizeY())
  self.skillInfos[slotNo + 1]:SetPosX(posX * -1 - 10)
end
function QuckSlot_CommandSetting(skillNo, slotNo)
  local self = quickSlot
  if false == self.isViewCommand then
    return
  end
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
  local skillCommandWrapper = getSkillCommandStatus(skillNo)
  local skillName = skillTypeStaticWrapper:getName()
  self.skillNames[slotNo + 1]:SetText("")
  self.skillNames[slotNo + 1]:SetShow(true)
  if nil ~= skillCommandWrapper then
    local command = skillCommandWrapper:getCommand()
    self.skillKeys[slotNo + 1].index = 1
    self.skillCommands[slotNo + 1].index = 1
    self.skillCommandsPlusIcon[slotNo + 1].index = 1
    for jj = 1, self.skillCommandTextMaxCount do
      self.skillCommands[slotNo + 1][jj]:SetShow(false)
    end
    for jj = 1, self.skillCommandsPlusIconCount do
      self.skillCommandsPlusIcon[slotNo + 1][jj]:SetShow(false)
    end
    self:skillCommandChange(command, slotNo, skillNo)
  else
    for jj = 1, self.skillCommandTextMaxCount do
      self.skillCommands[slotNo + 1][jj]:SetShow(false)
    end
  end
  self:skillCommandPos(slotNo)
end
function quickSlot:initSpecIcon()
  for i = 1, self.config.slotCount do
    if 1 == i then
      self.specIconGroups[i] = UI.getChildControl(Instance_QuickSlot, "Static_SpecIcon")
    else
      self.specIconGroups[i] = UI.cloneControl(self.specIconGroups[1], Instance_QuickSlot, "Static_SpecIcon_" .. i)
    end
    self.specIcons[i] = {}
    for j = 1, self.specIconMaxCount do
      self.specIcons[i][j] = UI.getChildControl(self.specIconGroups[i], "Static_icon_" .. j)
      self.specIcons[i][j]:SetShow(false)
    end
    self.specIconGroups[i]:SetShow(false)
    self.isSpecIcon[i] = false
  end
  for key, v in pairs(self.specTooltipTitleKey) do
    self.specTooltipTitle[key] = PAGetString(Defines.StringSheet_GAME, self.specTooltipTitleKey[key])
    self.specTooltipDesc[key] = PAGetString(Defines.StringSheet_GAME, self.specTooltipDescKey[key])
  end
end
function quickSlot:setSpecIcon(skillNo, slotNo)
  if false == SPECICON_FLAG then
    self:setSpecIconEmpty(slotNo)
    return
  end
  local index = slotNo + 1
  local count = ToClient_GetBattleRoyalCCQucikViewCountBySkillNo(skillNo)
  self:setSpecIconEmpty(slotNo)
  self:updateSpecIconPos(slotNo, count > 0)
  if count <= 0 then
    return
  end
  local icons = self.specIcons[index]
  local ccType = 0
  for i = 1, count do
    ccType = ToClient_GetBattleRoyalCCQucikView(skillNo, i - 1)
    self:setSpecIconTexture(icons[i], ccType)
    icons[i]:addInputEvent("Mouse_On", "PaGlobalFunc_quickSlot_specTooltip(" .. index .. ", " .. i .. ", " .. ccType .. ")")
    icons[i]:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  end
end
function quickSlot:setSpecIconEmpty(slotNo)
  local index = slotNo + 1
  local icons = self.specIcons[index]
  for i = 1, self.specIconMaxCount do
    icons[i]:SetShow(false)
  end
end
function quickSlot:setSpecIconTexture(control, ccType)
  local iconTexture = self.specIconUV[ccType]
  if nil == iconTexture then
    control:SetShow(false)
    return
  end
  control:SetShow(true)
  local x1, y1, x2, y2 = setTextureUV_Func(control, iconTexture.x, iconTexture.y, iconTexture.z, iconTexture.w)
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
  control:ComputePos()
end
function quickSlot:updateSpecIconPos(slotNo, isSpecIcon)
  local index = slotNo + 1
  if true == isSpecIcon then
    self.specIconGroups[index]:SetPosY(self:getCommandPosY(slotNo) - self.specIconGroups[index]:GetSizeY() * 0.35)
    self.skillInfos[index]:SetPosY(self:getCommandPosY(slotNo) + self.skillInfos[index]:GetSizeY() * 0.35)
  else
    self.skillInfos[index]:SetPosY(self:getCommandPosY(slotNo))
  end
end
function quickSlot:getCommandPosY(slotNo)
  return 25 + slotNo * 55
end
function PaGlobalFunc_quickSlot_specTooltip(index, iconIndex, ccType)
  local self = quickSlot
  TooltipSimple_Show(self.specIcons[index][iconIndex], self.specTooltipTitle[ccType], self.specTooltipDesc[ccType])
end
function quickSlot:setActiveHelperGroup(slotNo, isShow)
  local index = slotNo + 1
  if true == isShow then
    if true == self._isTimerArray[index] then
      return
    end
    if true == quickSlot:isCheckNewIndex(index) then
      quickSlot:startCheckNewIndex(index)
    else
      self.specIconGroups[index]:SetShow(quickSlot._eView.command == quickSlot._eViewState)
      self.skillInfos[index]:SetShow(quickSlot._eView.command == quickSlot._eViewState)
      self._staticText_SkillDescList[index]:SetShow(quickSlot._eView.skillDesc == quickSlot._eViewState)
    end
  else
    self.specIconGroups[index]:SetShow(false)
    self.skillInfos[index]:SetShow(false)
    self._staticText_SkillDescList[index]:SetShow(false)
  end
end
function quickSlot:isCheckNewIndex(index)
  return self._isNewIndexArray[index]
end
function quickSlot:startCheckNewIndex(index)
  self._isNewIndexArray[index] = false
  self._isTimerArray[index] = true
  self._deltaTimeArray[index] = 0
  self.specIconGroups[index]:SetShow(false)
  self.skillInfos[index]:SetShow(false)
  self._staticText_SkillDescList[index]:SetShow(true)
  if nil == self.slots[index].skill then
    return
  end
  self.slots[index].skill.icon:AddEffect("fUI_Skill_Cooltime01", false, 2.5, 7)
end
function quickSlot:updatePerTimerCheck(deltaTime)
  for i = 1, #self._isTimerArray do
    quickSlot:updatePerTimerCheckAt(i, deltaTime)
  end
end
function quickSlot:updatePerTimerCheckAt(index, deltaTime)
  if false == self._isTimerArray[index] or nil == self._deltaTimeArray[index] then
    return
  end
  self._deltaTimeArray[index] = self._deltaTimeArray[index] + deltaTime
  if self._DESC_ACTIVE_TIME < self._deltaTimeArray[index] then
    quickSlot:timerEndAt(index)
    self:setActiveHelperGroup(index - 1, true)
  end
end
function quickSlot:timerEndAt(index)
  self._isTimerArray[index] = false
  self._deltaTimeArray[index] = 0
end
function quickSlot:initSkillDesc()
  for i = 1, self.config.slotCount do
    if 1 == i then
      self._staticText_SkillDescList[i] = UI.getChildControl(Instance_QuickSlot, "StaticText_SkillDesc")
    else
      self._staticText_SkillDescList[i] = UI.cloneControl(self._staticText_SkillDescList[1], Instance_QuickSlot, "StaticText_SkillDesc" .. i)
    end
    self._staticText_SkillDescList[i]:SetShow(false)
  end
end
function quickSlot:setSkillDesc(skillNo, slotNo)
  local index = slotNo + 1
  self._staticText_SkillDescList[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._staticText_SkillDescList[index]:SetText(ToClient_GetQuickSlotSkillDescription(skillNo))
  self:updateSkillDescPos(slotNo)
end
function quickSlot:updateSkillDescPos(slotNo)
  local index = slotNo + 1
  self._staticText_SkillDescList[index]:SetPosY(self:getCommandPosY(slotNo) - 10)
end
function quickSlot:isCheckSlotData(slotNo, quickSlotInfo)
  return CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type and nil ~= self._slotData[slotNo] and CppEnums.QuickSlotType.eInstanceItem == self._slotData[slotNo]._slotType
end
function PaGlobal_QuickSlot_ChangeViewType(downType)
  if downType == quickSlot._eViewState then
    return
  end
  quickSlot._eViewState = downType
  if quickSlot._eView.skillDesc == downType then
    for i = 1, quickSlot.config.slotCount do
      quickSlot:timerEndAt(i)
    end
  end
  for i = 0, quickSlot.config.slotCount - 1 do
    if true == quickSlot._isLearnedList[i] then
      quickSlot:setActiveHelperGroup(i, true)
    end
  end
end
function QuickSlot_DropHandler(slotIndex)
  if nil == DragManager.dragStartPanel then
    return false
  end
  if DragManager.dragStartPanel == Instance_Window_Inventory then
    local itemWrapper = getInventoryItemByType(DragManager.dragWhereTypeInfo, DragManager.dragSlotInfo)
    if nil ~= itemWrapper and (itemWrapper:getStaticStatus():get():isContentsEvent() or itemWrapper:getStaticStatus():get():isItemSkill() or itemWrapper:getStaticStatus():get():isItemInterAction() or itemWrapper:getStaticStatus():get():isUseToVehicle() or itemWrapper:getStaticStatus():get():isEquipable() or itemWrapper:getStaticStatus():get():isItemTent()) then
      quickSlot_RegistItem(slotIndex, DragManager.dragWhereTypeInfo, DragManager.dragSlotInfo)
    end
  elseif DragManager.dragStartPanel == Instance_Window_Skill then
    quickSlot_RegistSkill(slotIndex, DragManager.dragSlotInfo)
  elseif DragManager.dragStartPanel == Instance_QuickSlot then
    if slotIndex ~= DragManager.dragSlotInfo then
      quickSlot:swapSlotData(slotIndex, DragManager.dragSlotInfo)
      quickSlot_Swap(slotIndex, DragManager.dragSlotInfo)
    end
  elseif DragManager.dragStartPanel == Instance_Widget_ItemSlot then
    quickSlot:dragItemSlot(slotIndex, DragManager.dragSlotInfo)
  end
  audioPostEvent_SystemUi(0, 8)
  _AudioPostEvent_SystemUiForXBOX(0, 8)
  DragManager:clearInfo()
  return true
end
function quickSlot:swapSlotData(leftIndex, rihgtIndex)
  local left = quickSlot._slotData[leftIndex]
  local right = quickSlot._slotData[rihgtIndex]
  if nil ~= left and nil ~= right then
    quickSlot._slotData[leftIndex], quickSlot._slotData[rihgtIndex] = quickSlot._slotData[rihgtIndex], quickSlot._slotData[leftIndex]
  elseif nil ~= left then
    quickSlot._slotData[rihgtIndex] = {}
    quickSlot._slotData[rihgtIndex]._slotType = left._slotType
    quickSlot._slotData[rihgtIndex]._key = left._key
    quickSlot._slotData[leftIndex] = nil
  elseif nil ~= right then
    quickSlot._slotData[leftIndex] = {}
    quickSlot._slotData[leftIndex]._slotType = right._slotType
    quickSlot._slotData[leftIndex]._key = right._key
    quickSlot._slotData[rihgtIndex] = nil
  end
end
function quickSlot:dragItemSlot(quickSlotIndex, itemSlotIndex)
  local itemSlotQuickIndex = self._itemSlotIndexGap + itemSlotIndex
  local quickSlotInfo = getQuickSlotItem(itemSlotQuickIndex)
  local isRequestRefresh = true
  if nil == quickSlotInfo or CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type then
    local itemSlotData = PaGlobalFunc_ItemSlot_GetSlotData(itemSlotIndex)
    if CppEnums.QuickSlotType.eInstanceItem == itemSlotData._slotType then
      local itemSlotItemData = PaGlobalFunc_ItemSlot_GetItemData(itemSlotData._key)
      if nil ~= itemSlotItemData then
        quickSlot_RegistItem(itemSlotQuickIndex, Inventory_GetCurrentInventoryType(), itemSlotItemData.inventoryIdx)
      elseif CppEnums.QuickSlotType.eEmpty ~= itemSlotData._slotType then
        if nil == self._slotData[quickSlotIndex] then
          self._slotData[quickSlotIndex] = {}
        end
        self._slotData[quickSlotIndex]._slotType = itemSlotData._slotType
        self._slotData[quickSlotIndex]._key = itemSlotData._key
      end
    end
  elseif nil ~= self._slotData[quickSlotIndex] then
    PaGlobalFunc_ItemSlot_SetSlotData(itemSlotIndex, self._slotData[quickSlotIndex]._slotType, self._slotData[quickSlotIndex]._key)
    self._slotData[quickSlotIndex] = nil
    isRequestRefresh = false
  end
  quickSlot_Swap(itemSlotQuickIndex, quickSlotIndex)
  if true == isRequestRefresh then
    PaGlobalFunc_ItemSlot_RefreshQuickSlotInfo(itemSlotIndex)
  end
end
function PaGlobalFunc_quickSlot_GetSlotData(slotNo)
  local self = quickSlot
  return self._slotData[slotNo]
end
function PaGlobalFunc_quickSlot_SetSlotData(slotNo, slotType, key)
  local self = quickSlot
  if nil == self._slotData[slotNo] then
    self._slotData[slotNo] = {}
  end
  self._slotData[slotNo]._slotType = slotType
  self._slotData[slotNo]._key = key
end
function QuickSlot_GroundClick(whereType, slotIndex)
end
function QuickSlot_Click(slotIndex)
  if nil == slotIndex then
    return
  end
  local quickSlotInfo = getQuickSlotItem(slotIndex)
  if nil == quickSlotInfo then
    return
  end
  local itemKey = quickSlotInfo._itemKey:getItemKey()
  local itemSlot = quickSlot.slots[slotIndex + 1]
  if nil ~= itemSlot then
    if nil ~= itemSlot.item and not itemSlot.item.cooltime:GetShow() then
      audioPostEvent_SystemUi(8, 2)
      _AudioPostEvent_SystemUiForXBOX(8, 2)
      itemSlot.item.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
      itemSlot.item.icon:AddEffect("UI_SkillButton01", false, 0, 0)
    end
    if nil ~= itemSlot.skill and not itemSlot.skill.cooltime:GetShow() then
      audioPostEvent_SystemUi(8, 2)
      _AudioPostEvent_SystemUiForXBOX(8, 2)
      itemSlot.skill.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
      itemSlot.skill.icon:AddEffect("UI_SkillButton01", false, 0, 0)
      local skillStaticWrapper = getSkillTypeStaticStatus(itemSlot.skill.skillNo)
      if skillStaticWrapper:getUiDisplayType() then
        SpiritGuide_Show()
      end
    end
  end
  if not QuickSlot_DropHandler(slotIndex) then
    if nil ~= itemSlot.item then
      local quickSlotInfo = getQuickSlotItem(slotIndex)
      local whereType = QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
      if isNearFusionCore() and isFusionItem(whereType, itemSlot.keyValue) then
        burnItemToActor(whereType, itemSlot.keyValue, 1)
        return
      end
      local whereType = QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
      local inventory = getSelfPlayer():get():getInventoryByType(whereType)
      local invenSlotNo = inventory:getSlot(quickSlotInfo._itemKey)
      if invenSlotNo >= inventory:sizeXXX() then
        return
      end
      local itemWrapper = getInventoryItemByType(whereType, invenSlotNo)
      local itemEnchantWrapper = itemWrapper:getStaticStatus()
      if 2 == itemEnchantWrapper:get()._vestedType:getItemKey() and false == itemWrapper:get():isVested() then
        local function bindingItemUse()
          quickSlot_UseSlot(slotIndex)
        end
        local messageContent
        if itemEnchantWrapper:isUserVested() then
          messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_CONTENT_USERVESTED")
        else
          messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_CONTENT")
        end
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_TITLE"),
          content = messageContent,
          functionYes = bindingItemUse,
          functionNo = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
      elseif itemEnchantWrapper:isPopupItem() then
        Panel_UserItem_PopupItem(itemEnchantWrapper, whereType, invenSlotNo)
      else
        quickSlot_UseSlot(slotIndex)
      end
    else
      quickSlot_UseSlot(slotIndex)
    end
  end
end
function SpiritGuide_Show()
end
function QuickSlot_DragStart(slotIndex)
  local self = quickSlot
  local quickSlotInfo = getQuickSlotItem(slotIndex)
  if CppEnums.QuickSlotType.eItem == quickSlotInfo._type or CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type or CppEnums.QuickSlotType.eInstanceItem == quickSlotInfo._type then
    local itemStaticWrapper = getItemEnchantStaticStatus(quickSlotInfo._itemKey)
    DragManager:setDragInfo(Instance_QuickSlot, nil, slotIndex, "Icon/" .. itemStaticWrapper:getIconPath(), QuickSlot_GroundClick, nil)
  elseif CppEnums.QuickSlotType.eSkill == quickSlotInfo._type then
    local skillTypeStaticWrapper = getSkillTypeStaticStatus(quickSlotInfo._skillKey:getSkillNo())
    DragManager:setDragInfo(Instance_QuickSlot, nil, slotIndex, "Icon/" .. skillTypeStaticWrapper:getIconPath(), QuickSlot_GroundClick, nil)
    QuickSlot_UpdateData()
  elseif quickSlot:isCheckSlotData(slotIndex, quickSlotInfo) then
    local itemStaticWrapper = getItemEnchantStaticStatus(ItemEnchantKey(self._slotData[slotIndex]._key))
    DragManager:setDragInfo(Instance_QuickSlot, nil, slotIndex, "Icon/" .. itemStaticWrapper:getIconPath(), QuickSlot_GroundClick, nil)
  end
end
local onEffectTime = 0
function QuickSlot_UpdatePerFrame(fDeltaTime)
  if fDeltaTime <= 0 then
    return
  end
  if false == FGlobal_QuickSlot_CheckDefaultQuickSlotShowAble() then
    PaGlobalFunc_QuickSlot_SetShow(false, false)
    return
  end
  onEffectTime = onEffectTime + fDeltaTime
  local self = quickSlot
  if not self.quickSlotInit then
    return
  end
  for idx, slot in ipairs(self.slots) do
    local quickSlotKey = idx - 1
    local quickSlotInfo = getQuickSlotItem(quickSlotKey)
    if nil == quickSlotInfo then
      return
    end
    if CppEnums.QuickSlotType.eItem == quickSlotInfo._type or CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type or CppEnums.QuickSlotType.eInstanceItem == quickSlotInfo._type then
      if nil == slot.item then
        break
      end
      local remainTime = 0
      local itemReuseTime = 0
      local realRemainTime = 0
      local intRemainTime = 0
      local whereType = QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
      if UI_TISNU ~= slot.keyValue then
        remainTime = getItemCooltime(whereType, slot.keyValue)
        itemReuseTime = getItemReuseCycle(whereType, slot.keyValue) / 1000
        realRemainTime = remainTime * itemReuseTime
        intRemainTime = realRemainTime - realRemainTime % 1 + 1
      end
      if isNearFusionCore() and isFusionItem(whereType, slot.keyValue) and onEffectTime > 3 then
        slot.item.icon:EraseAllEffect()
        slot.item.icon:AddEffect("UI_ItemInstall_Gold", false, 0, 0)
      end
      if remainTime > 0 then
        slot.item.cooltime:UpdateCoolTime(remainTime)
        slot.item.cooltime:SetShow(true)
        slot.item.cooltimeText:SetText(Time_Formatting_ShowTop(intRemainTime))
        if itemReuseTime >= intRemainTime then
          slot.item.cooltimeText:SetShow(true)
        else
          slot.item.cooltimeText:SetShow(false)
        end
      elseif slot.item.cooltime:GetShow() then
        slot.item.cooltime:SetShow(false)
        slot.item.cooltimeText:SetShow(false)
        local skillSlotItemPosX = slot.item.cooltime:GetParentPosX()
        local skillSlotItemPosY = slot.item.cooltime:GetParentPosY()
        Instance_CoolTime_Effect_Item_Slot:SetShow(true, true)
        Instance_CoolTime_Effect_Item_Slot:SetIgnore(true)
        Instance_CoolTime_Effect_Item_Slot:AddEffect("fUI_Skill_Cooltime01", false, 2.5, 7)
        Instance_CoolTime_Effect_Item_Slot:SetPosX(skillSlotItemPosX - 7)
        Instance_CoolTime_Effect_Item_Slot:SetPosY(skillSlotItemPosY - 10)
      end
    elseif CppEnums.QuickSlotType.eSkill == quickSlotInfo._type then
      if nil == slot.skill then
        break
      end
      local isLearned = ToClient_isLearnedSkill(quickSlotInfo._skillKey:getSkillNo())
      if true == isLearned then
        local skillStaticWrapper = getSkillStaticStatus(quickSlotInfo._skillKey:getSkillNo(), quickSlotInfo._skillKey:getLevel())
        if nil ~= skillStaticWrapper then
          if skillStaticWrapper:isUsableSkill() then
            slot.skill.icon:SetMonoTone(false)
          else
            slot.skill.icon:SetMonoTone(true)
          end
          slot.toggle:SetShow(false)
          if isToggleSkillbySkillKey(quickSlotInfo._skillKey:get()) then
            if checkToggleSkillState(quickSlotInfo._skillKey:get()) then
              slot.toggle:SetShow(true)
            else
              slot.toggle:SetShow(false)
            end
          end
        end
        local remainTime = getSkillCooltime(slot.keyValue:get())
        local skillReuseTime = skillStaticWrapper:get()._reuseCycle / 1000
        local realRemainTime = remainTime * skillReuseTime
        local intRemainTime = realRemainTime - realRemainTime % 1 + 1
        if remainTime > 0 then
          slot.skill.cooltime:UpdateCoolTime(remainTime)
          slot.skill.cooltime:SetShow(true)
          slot.skill.cooltimeText:SetText(Time_Formatting_ShowTop(intRemainTime))
          if skillReuseTime >= intRemainTime then
            slot.skill.cooltimeText:SetShow(true)
          else
            slot.skill.cooltimeText:SetShow(false)
          end
        elseif slot.skill.cooltime:GetShow() then
          slot.skill.cooltime:SetShow(false)
          slot.skill.cooltimeText:SetShow(false)
          local skillSlotPosX = slot.skill.cooltime:GetParentPosX()
          local skillSlotPosY = slot.skill.cooltime:GetParentPosY()
          Instance_CoolTime_Effect_Slot:SetShow(true, true)
          Instance_CoolTime_Effect_Slot:SetIgnore(true)
          Instance_CoolTime_Effect_Slot:AddEffect("fUI_Skill_Cooltime01", false, 2.5, 7)
          Instance_CoolTime_Effect_Slot:SetPosX(skillSlotPosX - 7)
          Instance_CoolTime_Effect_Slot:SetPosY(skillSlotPosY - 8)
        end
      else
        slot.skill.icon:SetMonoTone(true)
        slot.skill.cooltime:SetShow(false)
        slot.skill.cooltimeText:SetShow(false)
      end
    end
  end
  if onEffectTime > 3 then
    onEffectTime = 0
  end
  quickSlot:updatePerTimerCheck(fDeltaTime)
end
function quickSlot:registEventHandler()
  Instance_QuickSlot:RegisterUpdateFunc("QuickSlot_UpdatePerFrame")
end
function FGlobal_Potion_InvenToQuickSlot(inventoryType, slotNo, itemType)
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  if nil ~= itemWrapper and (itemWrapper:getStaticStatus():get():isItemSkill() or itemWrapper:getStaticStatus():get():isUseToVehicle()) then
    if itemType == 0 then
      if isUseNewQuickSlot() then
        local hasPotion = FGlobal_NewQuickSlot_CheckAndSetPotion(slotNo, itemType)
        if hasPotion then
          return
        end
      else
        for index = quickSlot.config.slotCount - 1, 0, -1 do
          local quickSlotInfo = getQuickSlotItem(index)
          local quickType = quickSlotInfo._type
          if CppEnums.QuickSlotType.eItem == quickType or CppEnums.QuickSlotType.eCashItem == quickType or CppEnums.QuickSlotType.eInstanceItem == quickType then
            local itemKey = quickSlotInfo._itemKey:get()
            if 502 == itemKey or 513 == itemKey or 514 == itemKey or 517 == itemKey or 518 == itemKey or 519 == itemKey or 524 == itemKey or 525 == itemKey or 528 == itemKey or 529 == itemKey or 530 == itemKey or 538 == itemKey or 551 == itemKey or 552 == itemKey or 553 == itemKey or 554 == itemKey or 555 == itemKey or 17568 == itemKey or 17569 == itemKey or 17679 == itemKey or 17681 == itemKey or 17682 == itemKey or 17683 == itemKey or 17684 == itemKey or 19932 == itemKey or 19933 == itemKey or 19934 == itemKey or 19935 == itemKey then
              return
            end
          end
        end
        local emptySlotIndex = EmptySlot_Check()
        if nil ~= emptySlotIndex then
          quickSlot_RegistItem(emptySlotIndex, 0, slotNo)
        end
      end
    elseif itemType == 1 then
      if isUseNewQuickSlot() then
        local hasPotion = FGlobal_NewQuickSlot_CheckAndSetPotion(slotNo, itemType)
        if not hasPotion then
          return
        end
      else
        for index = quickSlot.config.slotCount - 1, 0, -1 do
          local quickSlotInfo = getQuickSlotItem(index)
          local quickType = quickSlotInfo._type
          if CppEnums.QuickSlotType.eItem == quickType or CppEnums.QuickSlotType.eCashItem == quickType or CppEnums.QuickSlotType.eInstanceItem == quickType then
            local itemKey = quickSlotInfo._itemKey:get()
            if 503 == itemKey or 520 == itemKey or 521 == itemKey or 522 == itemKey or 526 == itemKey or 527 == itemKey or 515 == itemKey or 516 == itemKey or 531 == itemKey or 532 == itemKey or 533 == itemKey then
              return
            end
          end
        end
        local emptySlotIndex = EmptySlot_Check()
        if nil ~= emptySlotIndex then
          quickSlot_RegistItem(emptySlotIndex, 0, slotNo)
        end
      end
    end
  end
  if isUseNewQuickSlot() then
    FGlobal_NewQuickSlot_Update()
  else
    QuickSlot_UpdateData()
  end
end
function EmptySlot_Check()
  local emptySlot
  for index = quickSlot.config.slotCount - 1, 0, -1 do
    local quickSlotInfo = getQuickSlotItem(index)
    if CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type then
      emptySlot = index
    end
  end
  return emptySlot
end
function HP_Push_NextSlot(slotNo)
  local quickSlotInfo = getQuickSlotItem(slotNo)
  if CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type then
    return
  end
  if quickSlot.config.slotCount - 1 == slotNo then
    return
  end
  local quickSlotInfo2 = getQuickSlotItem(slotNo + 1)
  if CppEnums.QuickSlotType.eEmpty == quickSlotInfo2._type then
    quickSlot_Swap(slotNo, slotNo + 1)
    if 0 == slotNo then
      return
    end
    HP_Push_NextSlot(slotNo - 1)
  else
    HP_Push_NextSlot(slotNo + 1)
  end
end
function MP_Push_NextSlot(slotNo)
  local quickSlotInfo = getQuickSlotItem(slotNo)
  if CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type then
    return
  end
  if quickSlot.config.slotCount - 1 == slotNo then
    return
  end
  local quickSlotInfo2 = getQuickSlotItem(slotNo + 1)
  if CppEnums.QuickSlotType.eEmpty == quickSlotInfo2._type then
    quickSlot_Swap(slotNo, slotNo + 1)
    if 1 == slotNo then
      return
    end
    MP_Push_NextSlot(slotNo - 1)
  else
    MP_Push_NextSlot(slotNo + 1)
  end
end
function FGlobal_QuickSlot_CheckDefaultQuickSlotShowAble()
  return true
end
function QuickSlot_UpdateData()
  if not Instance_QuickSlot:GetShow() then
    PaGlobalFunc_QuickSlot_SetShow(true, true)
  end
  local self = quickSlot
  self:skillCommandInit()
  for idx, slot in ipairs(self.slots) do
    local quickSlotKey = idx - 1
    local quickSlotInfo = getQuickSlotItem(quickSlotKey)
    if CppEnums.QuickSlotType.eItem == quickSlotInfo._type or CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type or CppEnums.QuickSlotType.eInstanceItem == quickSlotInfo._type or quickSlot:isCheckSlotData(quickSlotKey, quickSlotInfo) then
      slot:setItem(quickSlotKey, quickSlotInfo, self._slotData[quickSlotKey])
      if nil ~= slot.icon then
        slot.icon:SetEnable(true)
      end
    elseif CppEnums.QuickSlotType.eSkill == quickSlotInfo._type then
      slot:setSkill(quickSlotKey, quickSlotInfo)
      if nil ~= slot.icon then
        slot.icon:SetEnable(true)
      end
    else
      slot:setEmpty()
      if nil ~= slot.icon then
        slot.icon:SetEnable(false)
      end
    end
  end
  if "QuickSlot" == Panel_Tooltip_Item_GetCurrentSlotType() then
    Panel_Tooltip_Item_Refresh()
  end
  if "QuickSlot" == Panel_SkillTooltip_GetCurrentSlotType() then
    Panel_SkillTooltip_Refresh()
  end
  self.quickSlotInit = true
end
function quickSlot:registMessageHandler()
  registerEvent("refreshQuickSlot_ack", "QuickSlot_UpdateData")
  registerEvent("FromClient_InventoryUpdate", "QuickSlot_UpdateData")
  registerEvent("QuickSlotUpdateAfterToCleanupDialog", "QuickSlot_UpdateAfter_cleanupDialog")
  registerEvent("EventlearnedSkill", "FromClient_QuickSlot_EventlearnedSkill")
end
local closeNpcTalkDialog = function()
  if Panel_Npc_Trade_Market:IsShow() then
    closeNpcTrade_Basket()
    return true
  end
  if Panel_Window_StableFunction:IsShow() then
    StableFunction_Close()
    return true
  end
  if Panel_Window_Repair:IsShow() then
    FGlobal_Equipment_SetHide(false)
    return true
  end
  if Panel_Window_GuildStableFunction:IsShow() then
    GuildStableFunction_Close()
    return true
  end
  if Panel_Window_ItemMarket_Function:GetShow() then
    FGolbal_ItemMarket_Function_Close()
    return true
  end
  if Panel_Window_WharfFunction:GetShow() then
    WharfFunction_Close()
    return true
  end
  if Panel_Window_GuildWharfFunction:GetShow() then
    GuildWharfFunction_Close()
    return true
  end
  return false
end
function QuickSlot_UpdateAfter_cleanupDialog()
  if Instance_QuickSlot:IsUse() then
  end
end
Instance_QuickSlot:addInputEvent("Mouse_On", "QuickSlot_ChangeTexture_On()")
Instance_QuickSlot:addInputEvent("Mouse_Out", "QuickSlot_ChangeTexture_Off()")
Instance_QuickSlot:addInputEvent("Mouse_LUp", "ResetPos_WidgetButton()")
function QuickSlot_ChangeTexture_On()
  if Panel_UIControl:IsShow() then
    Instance_QuickSlot:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
    quickSlotText:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_QUICKSLOT_QUICKSLOT") .. "-" .. PAGetString(Defines.StringSheet_GAME, "PANEL_QUICKSLOT_MOVE_DRAG"))
  end
end
function QuickSlot_ChangeTexture_Off()
  if Panel_UIControl:IsShow() then
    Instance_QuickSlot:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
    quickSlotText:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_QUICKSLOT_QUICKSLOT"))
  else
    Instance_QuickSlot:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
  end
end
function Panel_QuickSlot_ShowToggle()
  if getSelfPlayer():get():getLevel() < 4 then
    return
  end
  if isUseNewQuickSlot() then
    return
  end
  local isShow = Instance_QuickSlot:IsShow()
  if isShow then
    PaGlobalFunc_QuickSlot_SetShow(false, false)
  else
    PaGlobalFunc_QuickSlot_SetShow(true, true)
  end
end
function FGlobal_QuickSlot_Show()
  if false == FGlobal_QuickSlot_CheckDefaultQuickSlotShowAble() then
    return
  end
  PaGlobalFunc_QuickSlot_SetShow(true, true)
  local itemSlot = quickSlot.slots[1]
  if nil ~= itemSlot then
    if nil ~= itemSlot.item then
      itemSlot.item.icon:AddEffect("fUI_Tuto_Skill_01A", false, 250, 0)
    end
    if nil ~= itemSlot.skill then
      itemSlot.skill.icon:AddEffect("fUI_Tuto_Skill_01A", false, 250, 0)
    end
  end
end
function QuickSlot_ShowBackGround()
  local self = quickSlot
  for idx, slot in ipairs(self.slots) do
    slot.background:ChangeTextureInfoName("new_ui_common_forlua/default/blackpenel_series.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(slot.background, 5, 5, 50, 50)
    slot.background:getBaseTexture():setUV(x1, y1, x2, y2)
    slot.background:setRenderTexture(slot.background:getOnTexture())
    slot.background:SetAlpha(0.8)
  end
end
function QuickSlot_HideBackGround()
  local self = quickSlot
  for idx, slot in ipairs(self.slots) do
    slot.background:ChangeTextureInfoName("")
    slot.background:SetAlpha(0)
  end
end
function QuickSlot_Empty()
  local self = quickSlot
  for idx, slot in ipairs(self.slots) do
    if CppEnums.QuickSlotType.eEmpty == slot.slotType then
      slot.background:ChangeOnTextureInfoName("new_ui_common_forlua/default/blackpenel_series.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(slot.background, 5, 5, 50, 50)
      slot.background:getOnTexture():setUV(x1, y1, x2, y2)
      slot.background:setRenderTexture(slot.background:getBaseTexture())
      slot.background:SetAlpha(1)
    end
  end
end
local halfScreenSize = getScreenSizeX() / 2 - Instance_QuickSlot:GetPosX()
local potionAlert = true
local potionPosInit = false
local potionRefill = false
local potion_bubble = UI.getChildControl(Instance_QuickSlot, "StaticText_Bubble")
local potion_bubble2 = UI.getChildControl(Instance_QuickSlot, "StaticText_Bubble2")
potion_bubble:SetShow(false)
potion_bubble2:SetShow(false)
potion_bubble2:SetPosX(-85)
potion_bubble2:SetPosY(-50)
potion_bubble:SetPosY(-50)
function NoPotion_Alert()
  local invenSize = getSelfPlayer():get():getInventory():size() - 1
  Potion_Pos_Init()
  for index = 1, invenSize do
    local itemWrapper = getInventoryItem(index)
    if nil ~= itemWrapper then
      local itemKey = itemWrapper:get():getKey():getItemKey()
      if 502 == itemKey or 513 == itemKey or 514 == itemKey or 517 == itemKey or 518 == itemKey or 519 == itemKey or 524 == itemKey or 525 == itemKey or 528 == itemKey or 529 == itemKey or 530 == itemKey or 538 == itemKey or 551 == itemKey or 552 == itemKey or 553 == itemKey or 554 == itemKey or 555 == itemKey or 17568 == itemKey or 17569 == itemKey or 17679 == itemKey or 17681 == itemKey or 17682 == itemKey or 17683 == itemKey or 17684 == itemKey or 19932 == itemKey or 19933 == itemKey or 19934 == itemKey or 19935 == itemKey then
        potionAlert = true
        if false == potionPosInit then
          potion_bubble2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUICKSLOT_ADD_POTION"))
          Potion_Bubble_Show(false)
        elseif true == potionRefill then
          return
        else
          potion_bubble:SetShow(false)
          potion_bubble2:SetShow(false)
        end
        return
      end
    end
  end
  potion_bubble:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUICKSLOT_HAVENT_POTION"))
  potion_bubble2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUICKSLOT_HAVENT_POTION"))
  potionAlert = false
end
local bubbleChange = false
local bubble2Change = false
function Potion_Pos_Init()
  potionPosInit = false
  potionRefill = false
  for index = quickSlot.config.slotCount - 1, 0, -1 do
    local quickType = getQuickSlotItem(index)._type
    if CppEnums.QuickSlotType.eItem == quickType or CppEnums.QuickSlotType.eCashItem == quickType or CppEnums.QuickSlotType.eInstanceItem == quickType then
      local quickSlotInfo = getQuickSlotItem(index)
      local invenSlotNo = getSelfPlayer():get():getInventory():getSlot(quickSlotInfo._itemKey)
      local itemStaticWrapper = getItemEnchantStaticStatus(quickSlotInfo._itemKey)
      local itemKey = quickSlotInfo._itemKey:getItemKey()
      if 502 == itemKey or 513 == itemKey or 514 == itemKey or 517 == itemKey or 518 == itemKey or 519 == itemKey or 524 == itemKey or 525 == itemKey or 528 == itemKey or 529 == itemKey or 530 == itemKey or 538 == itemKey or 551 == itemKey or 552 == itemKey or 553 == itemKey or 554 == itemKey or 555 == itemKey or 17568 == itemKey or 17569 == itemKey or 17679 == itemKey or 17681 == itemKey or 17682 == itemKey or 17683 == itemKey or 17684 == itemKey or 19932 == itemKey or 19933 == itemKey or 19934 == itemKey or 19935 == itemKey then
        potionPosInit = true
        if 255 == invenSlotNo then
          Potion_Alert(index)
          potionRefill = true
        end
      end
    end
  end
  if false == potionRefill then
    potion_bubble:SetShow(false)
    potion_bubble2:SetShow(false)
  end
  if false == potionPosInit then
    potion_bubble2:SetPosX(-85)
    Potion_Bubble_Show(false)
  end
  if 30 < potion_bubble2:GetTextSizeY() then
    potion_bubble2:SetSize(potion_bubble2:GetTextSizeX() + 10, potion_bubble2:GetTextSizeY() + 28)
    potion_bubble2:SetPosX(potion_bubble2:GetPosX() - (potion_bubble2:GetTextSizeX() - 160))
    if not bubble2Change then
      potion_bubble2:SetPosY(potion_bubble2:GetPosY() - (potion_bubble2:GetTextSizeY() - 26))
    end
    bubble2Change = true
  else
    potion_bubble2:SetSize(potion_bubble2:GetTextSizeX() + 10, 55)
  end
  if 30 < potion_bubble:GetTextSizeY() then
    potion_bubble:SetSize(potion_bubble:GetTextSizeX() + 10, potion_bubble:GetTextSizeY() + 28)
    potion_bubble:SetPosX(potion_bubble:GetPosX() - (potion_bubble:GetTextSizeX() - 160))
    if not bubbleChange then
      potion_bubble:SetPosY(potion_bubble:GetPosY() - (potion_bubble:GetTextSizeY() - 26))
    end
    bubbleChange = true
  else
    potion_bubble:SetSize(potion_bubble:GetTextSizeX() + 10, 55)
  end
end
function Potion_Alert(slotNo)
  local quickSlotInfo = getQuickSlotItem(slotNo)
  local invenSlotNo = getSelfPlayer():get():getInventory():getSlot(quickSlotInfo._itemKey)
  local itemStaticWrapper = getItemEnchantStaticStatus(quickSlotInfo._itemKey)
  local itemName = itemStaticWrapper:getName()
  local hp_potion = string.sub(itemName, 1, 2)
  potion_bubble:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUICKSLOT_HAVENT_POTION_2", "itemName", itemName))
  potion_bubble2:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUICKSLOT_HAVENT_POTION_2", "itemName", itemName))
  Potion_Bubble_Locate(slotNo)
  if false == potionAlert then
    return
  end
end
function Potion_Bubble_Locate(slotNo)
  local posX = slotNo * 55 + 10
  if posX < halfScreenSize then
    potion_bubble2:SetPosX(posX - 95)
    Potion_Bubble_Show(false)
  else
    potion_bubble:SetPosX(posX)
    Potion_Bubble_Show(true)
  end
end
function Potion_Bubble_Show(bool)
  if true == bool then
    potion_bubble:SetShow(true)
    potion_bubble2:SetShow(false)
  else
    potion_bubble:SetShow(false)
    potion_bubble2:SetShow(true)
  end
end
function Time_Formatting_ShowTop(second)
  if second > 3600 then
    local recalc_time = second / 3600
    local strHour = string.format("%d", Int64toInt32(recalc_time))
    return PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_HOUR", "time_hour", strHour)
  elseif second > 60 then
    local recalc_time = second / 60
    local strMinute = string.format("%d", Int64toInt32(recalc_time))
    return PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", strMinute)
  else
    local recalc_time = second
    local strSecond = string.format("%d", Int64toInt32(recalc_time))
    return PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_SECOND", "time_second", strSecond)
  end
end
function QuickSlot_GetInventoryTypeFrom(quickType)
  if CppEnums.QuickSlotType.eItem == quickType then
    return CppEnums.ItemWhereType.eInventory
  elseif CppEnums.QuickSlotType.eInstanceItem == quickType then
    return CppEnums.ItemWhereType.eInstanceInventory
  end
  return CppEnums.ItemWhereType.eCashInventory
end
function QuickSlot_OnscreenResize()
  Instance_QuickSlot:SetPosX(getScreenSizeX() - Instance_QuickSlot:GetSizeX() - 10)
  if Instance_QuickSlot:GetSizeY() + Instance_Radar:GetSizeY() + Instance_Widget_Leave:GetSizeY() < getScreenSizeY() then
    Instance_QuickSlot:SetPosY(getScreenSizeY() * 0.5 - Instance_QuickSlot:GetSizeY() * 0.35)
  else
    Instance_QuickSlot:SetPosY(getScreenSizeY() - Instance_QuickSlot:GetSizeY() - Instance_Widget_Leave:GetSizeY() - 60)
  end
end
registerEvent("onScreenResize", "QuickSlot_OnscreenResize")
function renderModeChange_QuickSlot_OnscreenResize(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  QuickSlot_OnscreenResize()
end
function PaGlobalFunc_QuickSlot_SetShow(isShow, isAni)
  if false == _ContentsGroup_RenewUI then
    Instance_QuickSlot:SetShow(isShow, isAni)
  else
    Instance_QuickSlot:SetShow(false, false)
  end
end
function FromClient_QuickSlot_EventlearnedSkill(skillNo)
  for i = 1, #quickSlot.slots do
    if CppEnums.QuickSlotType.eSkill == quickSlot.slots[i].slotType and skillNo == quickSlot.slots[i].keyValue:getSkillNo() then
      quickSlot._isNewIndexArray[i] = true
      return
    end
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_QuickSlot")
function FromClient_luaLoadComplete_QuickSlot()
  quickSlot:init()
  quickSlot:createSlot()
  quickSlot:registEventHandler()
  quickSlot:registMessageHandler()
  registerEvent("FromClient_RenderModeChangeState", "renderModeChange_QuickSlot_OnscreenResize")
end
