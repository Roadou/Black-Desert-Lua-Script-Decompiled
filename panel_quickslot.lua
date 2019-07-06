Panel_QuickSlot:SetShow(false, false)
Panel_QuickSlot:SetPosX((getScreenSizeX() - Panel_QuickSlot:GetSizeX()) / 2)
Panel_QuickSlot:SetPosY(getScreenSizeY() - Panel_QuickSlot:GetSizeY())
function isUseNewQuickSlot()
  if true == ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eNewQuickSlot) then
    if false == _ContentsGroup_Tutorial_Renewal and true == PaGlobal_TutorialManager:isDoingTutorial() and false == PaGlobal_TutorialManager:isAllowNewQuickSlot() then
      return false
    end
    return true
  end
  return false
end
local UI_TM = CppEnums.TextMode
Panel_QuickSlot:RegisterShowEventFunc(true, "QuickSlot_ShowAni()")
Panel_QuickSlot:RegisterShowEventFunc(false, "QuickSlot_HideAni()")
Panel_CoolTime_Effect_Item_Slot:RegisterShowEventFunc(true, "QuickSlot_ItemCoolTimeEffect_HideAni()")
Panel_CoolTime_Effect_Slot:RegisterShowEventFunc(true, "QuickSlot_SkillCoolTimeEffect_HideAni()")
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TISNU = CppEnums.TInventorySlotNoUndefined
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
local quickSlotBg = UI.getChildControl(Panel_QuickSlot, "Static_Main_BG")
local quickSlotText = UI.getChildControl(Panel_QuickSlot, "StaticText_quickSlot")
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
    slotInitGapX = 55,
    slotInitGapY = 0
  },
  template = {
    slotBackground = UI.getChildControl(Panel_QuickSlot, "StaticText_Slot_BG_Txt")
  },
  slots = {},
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
  initPosX = Panel_QuickSlot:GetPosX(),
  initPosY = Panel_QuickSlot:GetPosY()
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
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "getSlotByIndex : " .. tostring("\236\138\172\235\161\175 \236\132\177\234\179\181!"))
    return quickSlot.slots[slotIndex]
  end
  _PA_ASSERT(false, "\234\184\176\235\179\184\237\128\181\236\138\172\235\161\175\236\157\152 \235\178\148\236\156\132\235\165\188 \236\180\136\234\179\188\237\150\136\236\138\181\235\139\136\235\139\164.")
end
function quickSlot:init()
  if false == _ContentsGroup_RenewUI_Skill then
    quickSlot.slotConfig_Skill.template.effect = UI.getChildControl(Panel_Window_Skill, "Static_Icon_Skill_Effect")
  else
    quickSlot.slotConfig_Skill.template.effect = PaGlobalFunc_Skill_GetEffectControl()
  end
  for idx, slot in ipairs(self.slots) do
    slot.background:ChangeTextureInfoName("New_UI_Common_forLua/Default/BlackPanel_Series.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(slot.background, 5, 5, 50, 50)
    slot.background:geOnTexture():setUV(x1, y1, x2, y2)
    slot.background:setRenderTexture(slot.background:geOnTexture())
    slot.background:SetAlpha(0.7)
  end
end
function QuickSlot_ShowAni()
  Panel_QuickSlot:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
  local QuickSlotOpen_Alpha = Panel_QuickSlot:addColorAnimation(0, 0.35, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  QuickSlotOpen_Alpha:SetStartColor(UI_color.C_00FFFFFF)
  QuickSlotOpen_Alpha:SetEndColor(UI_color.C_FFFFFFFF)
  QuickSlotOpen_Alpha.IsChangeChild = true
end
function QuickSlot_HideAni()
  Panel_QuickSlot:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local QuickSlotClose_Alpha = Panel_QuickSlot:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  QuickSlotClose_Alpha:SetStartColor(UI_color.C_FFFFFFFF)
  QuickSlotClose_Alpha:SetEndColor(UI_color.C_00FFFFFF)
  QuickSlotClose_Alpha.IsChangeChild = true
  QuickSlotClose_Alpha:SetHideAtEnd(true)
  QuickSlotClose_Alpha:SetDisableWhileAni(true)
end
function QuickSlot_ItemCoolTimeEffect_HideAni()
  audioPostEvent_SystemUi(2, 4)
  _AudioPostEvent_SystemUiForXBOX(2, 4)
  Panel_CoolTime_Effect_Item_Slot:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local coolTime_Item_Slot = Panel_CoolTime_Effect_Item_Slot:addColorAnimation(0, 3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
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
  Panel_CoolTime_Effect_Slot:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local coolTime_Slot = Panel_CoolTime_Effect_Slot:addColorAnimation(0, 3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
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
        background = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_QuickSlot, "Static_Slot_BG_" .. ii),
        number = UI.getChildControl(Panel_QuickSlot, self.numberNames[ii]),
        toggle = UI.getChildControl(Panel_QuickSlot, self.skillToggle[ii])
      }
      CopyBaseProperty(self.template.slotBackground, slot.background)
      slot.background:SetShow(true)
      slot.background:SetAlpha(1)
      slot.background:addInputEvent("Mouse_On", "QuickSlot_ShowBackGroundToggle(true," .. ii .. ")")
      slot.background:addInputEvent("Mouse_Out", "QuickSlot_ShowBackGroundToggle(false," .. ii .. ")")
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
            Panel_QuickSlot:SetChildOrder(list[ii]:GetKey(), list[jj]:GetKey())
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
      function slot:setItem(slotNo, quickSlotInfo)
        if CppEnums.QuickSlotType.eItem ~= self.slotType and CppEnums.QuickSlotType.eCashItem ~= self.slotType and CppEnums.QuickSlotType.eInstanceItem ~= self.slotType then
          if CppEnums.QuickSlotType.eSkill == self.slotType then
            self.skill:destroyChild()
            Panel_SkillTooltip_Hide()
            self.skill = nil
          end
          self.slotType = quickSlotInfo._type
          local itemSlot = {}
          SlotItem.new(itemSlot, "QuickSlot_" .. slotNo, slotNo, Panel_QuickSlot, quickSlot.slotConfig_Item)
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
        self.slotType = quickSlotInfo._type
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
        local itemSlot = self.item
        self.item.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"QuickSlot\", true)")
        self.item.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"QuickSlot\", false)")
        Panel_Tooltip_Item_SetPosition(slotNo, self.item, "QuickSlot")
        self.toggle:SetShow(false)
      end
      function slot:setSkill(slotNo, quickSlotInfo)
        if CppEnums.QuickSlotType.eSkill ~= self.slotType then
          if CppEnums.QuickSlotType.eItem == self.slotType or CppEnums.QuickSlotType.eCashItem == self.slotType or CppEnums.QuickSlotType.eInstanceItem == self.slotType then
            UI.ASSERT(nil ~= self.item)
            UI.deleteControl(self.item.icon)
            Panel_Tooltip_Item_hideTooltip()
            self.item = nil
          end
          self.slotType = CppEnums.QuickSlotType.eSkill
          local skillSlot = {}
          SlotSkill.new(skillSlot, slotNo, Panel_QuickSlot, quickSlot.slotConfig_Skill)
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
          Panel_Tooltip_Item_hideTooltip()
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
      end
      slot:setPos(slot.posX, slot.posY)
      slot:rearrangeControl()
      self.slots[ii] = slot
    end
  end
end
function QuickSlot_DropHandler(slotIndex)
  if nil == DragManager.dragStartPanel then
    return false
  end
  if DragManager.dragStartPanel == Panel_Window_Inventory then
    local itemWrapper = getInventoryItemByType(DragManager.dragWhereTypeInfo, DragManager.dragSlotInfo)
    if nil ~= itemWrapper and (itemWrapper:getStaticStatus():get():isContentsEvent() or itemWrapper:getStaticStatus():get():isItemSkill() or itemWrapper:getStaticStatus():get():isItemInterAction() or itemWrapper:getStaticStatus():get():isUseToVehicle() or itemWrapper:getStaticStatus():get():isEquipable() or itemWrapper:getStaticStatus():get():isItemTent()) then
      quickSlot_RegistItem(slotIndex, DragManager.dragWhereTypeInfo, DragManager.dragSlotInfo)
      PaGlobal_TutorialManager:handleQuickSlotRegistItem(slotIndex, DragManager.dragWhereTypeInfo, DragManager.dragSlotInfo)
    end
  elseif DragManager.dragStartPanel == Panel_Window_Skill then
    quickSlot_RegistSkill(slotIndex, DragManager.dragSlotInfo)
  elseif DragManager.dragStartPanel == Panel_QuickSlot and slotIndex ~= DragManager.dragSlotInfo then
    quickSlot_Swap(slotIndex, DragManager.dragSlotInfo)
  end
  audioPostEvent_SystemUi(0, 8)
  _AudioPostEvent_SystemUiForXBOX(0, 8)
  DragManager:clearInfo()
  return true
end
function QuickSlot_GroundClick(whereType, slotIndex)
  local itemSlot = quickSlot.slots[slotIndex + 1]
  quickSlot_Clear(slotIndex)
  if slotIndex == 0 then
    itemSlot.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(itemSlot.number, 1, 1, 14, 14)
    itemSlot.number:getBaseTexture():setUV(x1, y1, x2, y2)
    itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
  elseif slotIndex == 1 then
    itemSlot.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(itemSlot.number, 15, 1, 28, 14)
    itemSlot.number:getBaseTexture():setUV(x1, y1, x2, y2)
    itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
  elseif slotIndex == 2 then
    itemSlot.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(itemSlot.number, 29, 1, 42, 14)
    itemSlot.number:getBaseTexture():setUV(x1, y1, x2, y2)
    itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
  elseif slotIndex == 3 then
    itemSlot.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(itemSlot.number, 43, 1, 56, 14)
    itemSlot.number:getBaseTexture():setUV(x1, y1, x2, y2)
    itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
  elseif slotIndex == 4 then
    itemSlot.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(itemSlot.number, 1, 15, 14, 28)
    itemSlot.number:getBaseTexture():setUV(x1, y1, x2, y2)
    itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
  elseif slotIndex == 5 then
    itemSlot.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(itemSlot.number, 15, 15, 28, 28)
    itemSlot.number:getBaseTexture():setUV(x1, y1, x2, y2)
    itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
  elseif slotIndex == 6 then
    itemSlot.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(itemSlot.number, 29, 15, 42, 28)
    itemSlot.number:getBaseTexture():setUV(x1, y1, x2, y2)
    itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
  elseif slotIndex == 7 then
    itemSlot.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(itemSlot.number, 43, 15, 56, 28)
    itemSlot.number:getBaseTexture():setUV(x1, y1, x2, y2)
    itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
  elseif slotIndex == 8 then
    itemSlot.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(itemSlot.number, 1, 29, 14, 42)
    itemSlot.number:getBaseTexture():setUV(x1, y1, x2, y2)
    itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
  elseif slotIndex == 9 then
    itemSlot.number:ChangeTextureInfoName("New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(itemSlot.number, 15, 29, 28, 42)
    itemSlot.number:getBaseTexture():setUV(x1, y1, x2, y2)
    itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
  end
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
  PaGlobal_TutorialManager:handleQuickSlotClick(itemKey)
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
      elseif eConnectUiType.eConnectUi_Undefined ~= itemWrapper:getStaticStatus():getConnectUi() then
        ConnectUI(itemWrapper:getStaticStatus():getConnectUi())
      else
        quickSlot_UseSlot(slotIndex)
      end
    else
      quickSlot_UseSlot(slotIndex)
    end
  end
end
function SpiritGuide_Show()
  local isShow = FGlobal_SpiritGuide_IsShow()
  if false == isShow then
    return
  end
  Panel_MovieTheater320_ShowToggle()
end
function QuickSlot_DragStart(slotIndex)
  local self = quickSlot
  local quickSlotInfo = getQuickSlotItem(slotIndex)
  if true == PaGlobal_TutorialManager:isDoingTutorial() and 502 == quickSlotInfo._itemKey:get() and 0 == slotIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return
  end
  if CppEnums.QuickSlotType.eItem == quickSlotInfo._type or CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type or CppEnums.QuickSlotType.eInstanceItem == quickSlotInfo._type then
    local itemStaticWrapper = getItemEnchantStaticStatus(quickSlotInfo._itemKey)
    DragManager:setDragInfo(Panel_QuickSlot, nil, slotIndex, "Icon/" .. itemStaticWrapper:getIconPath(), QuickSlot_GroundClick, nil)
  elseif CppEnums.QuickSlotType.eSkill == quickSlotInfo._type then
    local skillTypeStaticWrapper = getSkillTypeStaticStatus(quickSlotInfo._skillKey:getSkillNo())
    DragManager:setDragInfo(Panel_QuickSlot, nil, slotIndex, "Icon/" .. skillTypeStaticWrapper:getIconPath(), QuickSlot_GroundClick, nil)
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
    if true == PaGlobal_TutorialManager:isDoingTutorial() and false == PaGlobal_TutorialManager:isCheckHpPotionSetting() and 1 == idx and 517 ~= quickSlotInfo._itemKey:getItemKey() then
      Inventory_SetCheckRadioButtonNormalInventory(true)
      Inventory_updateSlotData()
      PaGlobal_TutorialManager:setHpPotion()
    end
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
        Panel_CoolTime_Effect_Item_Slot:SetShow(true, true)
        Panel_CoolTime_Effect_Item_Slot:SetIgnore(true)
        Panel_CoolTime_Effect_Item_Slot:AddEffect("fUI_Skill_Cooltime01", false, 2.5, 7)
        Panel_CoolTime_Effect_Item_Slot:SetPosX(skillSlotItemPosX - 7)
        Panel_CoolTime_Effect_Item_Slot:SetPosY(skillSlotItemPosY - 10)
      end
      PaGlobal_TutorialManager:handleUpdateQuickSlotPerFrame(slot, quickSlotInfo._itemKey:getItemKey())
    elseif CppEnums.QuickSlotType.eSkill == quickSlotInfo._type then
      if nil == slot.skill then
        break
      end
      local skillStaticWrapper = getSkillStaticStatus(quickSlotInfo._skillKey:getSkillNo(), quickSlotInfo._skillKey:getLevel())
      local isLearned = ToClient_isLearnedSkill(quickSlotInfo._skillKey:getSkillNo())
      if nil ~= skillStaticWrapper then
        if skillStaticWrapper:isUsableSkill() and true == isLearned then
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
        Panel_CoolTime_Effect_Slot:SetShow(true, true)
        Panel_CoolTime_Effect_Slot:SetIgnore(true)
        Panel_CoolTime_Effect_Slot:AddEffect("fUI_Skill_Cooltime01", false, 2.5, 7)
        Panel_CoolTime_Effect_Slot:SetPosX(skillSlotPosX - 7)
        Panel_CoolTime_Effect_Slot:SetPosY(skillSlotPosY - 8)
      end
    end
  end
  if onEffectTime > 3 then
    onEffectTime = 0
  end
end
function quickSlot:registEventHandler()
  Panel_QuickSlot:RegisterUpdateFunc("QuickSlot_UpdatePerFrame")
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
        if PaGlobal_TutorialManager:isDoingTutorial() then
          HP_Push_NextSlot(0)
          quickSlot_RegistItem(0, 0, slotNo)
        else
          local emptySlotIndex = EmptySlot_Check()
          if nil ~= emptySlotIndex then
            quickSlot_RegistItem(emptySlotIndex, 0, slotNo)
          end
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
  if true == isUseNewQuickSlot() then
    return false
  elseif false == _ContentsGroup_Tutorial_Renewal and false == PaGlobal_TutorialManager:isAllowShowQuickSlot() then
    return false
  end
  return true
end
function QuickSlot_UpdateData()
  if false == FGlobal_QuickSlot_CheckDefaultQuickSlotShowAble() then
    PaGlobalFunc_QuickSlot_SetShow(false, false)
    return
  end
  if Panel_QuickSlot:GetRelativePosX() == -1 and Panel_QuickSlot:GetRelativePosY() == -1 then
    local initPosX = (getScreenSizeX() - Panel_QuickSlot:GetSizeX()) / 2
    local initPosY = getScreenSizeY() - Panel_QuickSlot:GetSizeY()
    changePositionBySever(Panel_QuickSlot, CppEnums.PAGameUIType.PAGameUIPanel_QuickSlot, false, true, false)
    FGlobal_InitPanelRelativePos(Panel_QuickSlot, initPosX, initPosY)
  elseif Panel_QuickSlot:GetRelativePosX() == 0 and Panel_QuickSlot:GetRelativePosY() == 0 then
    Panel_QuickSlot:SetPosX((getScreenSizeX() - Panel_QuickSlot:GetSizeX()) / 2)
    Panel_QuickSlot:SetPosY(getScreenSizeY() - Panel_QuickSlot:GetSizeY())
  else
    Panel_QuickSlot:SetPosX(getScreenSizeX() * Panel_QuickSlot:GetRelativePosX() - Panel_QuickSlot:GetSizeX() / 2)
    Panel_QuickSlot:SetPosY(getScreenSizeY() * Panel_QuickSlot:GetRelativePosY() - Panel_QuickSlot:GetSizeY() / 2)
  end
  if not Panel_QuickSlot:GetShow() then
    PaGlobalFunc_QuickSlot_SetShow(true, true)
  end
  local self = quickSlot
  for idx, slot in ipairs(self.slots) do
    local quickSlotKey = idx - 1
    local quickSlotInfo = getQuickSlotItem(quickSlotKey)
    if CppEnums.QuickSlotType.eItem == quickSlotInfo._type or CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type or CppEnums.QuickSlotType.eInstanceItem == quickSlotInfo._type then
      slot:setItem(quickSlotKey, quickSlotInfo)
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
  if 2 < getSelfPlayer():get():getLevel() and getSelfPlayer():get():getLevel() < 40 then
    NoPotion_Alert()
  end
end
function quickSlot:registMessageHandler()
  registerEvent("refreshQuickSlot_ack", "QuickSlot_UpdateData")
  registerEvent("FromClient_InventoryUpdate", "QuickSlot_UpdateData")
  registerEvent("QuickSlotUpdateAfterToCleanupDialog", "QuickSlot_UpdateAfter_cleanupDialog")
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
  if Panel_QuickSlot:IsUse() then
    if true == _ContentsGroup_RenewUI_Dailog then
      if PaGlobalFunc_MainDialog_IsShow() then
        local hideNpcTradeMarketDialog = PaGlobalFunc_MainDialog_CloseMainDialogForDetail()
        if hideNpcTradeMarketDialog then
          PaGlobalFunc_MainDialog_Hide()
        end
      end
    elseif false == _ContentsGroup_NewUI_Dialog_All then
      local hideNpcTradeMarketDialog = FGlobal_CloseNpcDialogForDetail()
      if hideNpcTradeMarketDialog and Panel_Npc_Dialog:IsShow() then
        FGlobal_HideDialog(true)
      end
    elseif nil ~= Panel_Npc_Dialog_All and true == Panel_Npc_Dialog_All:GetShow() then
      PaGlobalFunc_DialogMain_All_Close()
    end
  end
end
Panel_QuickSlot:addInputEvent("Mouse_On", "QuickSlot_ChangeTexture_On()")
Panel_QuickSlot:addInputEvent("Mouse_Out", "QuickSlot_ChangeTexture_Off()")
Panel_QuickSlot:addInputEvent("Mouse_LUp", "ResetPos_WidgetButton()")
function QuickSlot_ChangeTexture_On()
  if Panel_UIControl:IsShow() then
    Panel_QuickSlot:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
    quickSlotText:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_QUICKSLOT_QUICKSLOT") .. "-" .. PAGetString(Defines.StringSheet_GAME, "PANEL_QUICKSLOT_MOVE_DRAG"))
  end
end
function QuickSlot_ChangeTexture_Off()
  if Panel_UIControl:IsShow() then
    Panel_QuickSlot:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
    quickSlotText:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_QUICKSLOT_QUICKSLOT"))
  else
    Panel_QuickSlot:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
  end
end
function Panel_QuickSlot_ShowToggle()
  if getSelfPlayer():get():getLevel() < 4 then
    return
  end
  if isUseNewQuickSlot() then
    return
  end
  local isShow = Panel_QuickSlot:IsShow()
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
    slot.background:ChangeTextureInfoName("New_UI_Common_forLua/Default/BlackPanel_Series.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(slot.background, 5, 5, 50, 50)
    slot.background:getBaseTexture():setUV(x1, y1, x2, y2)
    slot.background:setRenderTexture(slot.background:getBaseTexture())
    slot.background:SetAlpha(0.7)
  end
end
function QuickSlot_ShowBackGroundToggle(isShow, index)
  local self = quickSlot
  if true == isShow then
    self.slots[index].background:ChangeTextureInfoName("New_UI_Common_forLua/Default/BlackPanel_Series.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self.slots[index].background, 5, 5, 50, 50)
    self.slots[index].background:getBaseTexture():setUV(x1, y1, x2, y2)
    self.slots[index].background:setRenderTexture(self.slots[index].background:getBaseTexture())
    self.slots[index].background:SetAlpha(0.7)
  else
    QuickSlot_HideBackGround()
  end
end
function QuickSlot_HideBackGround()
  local self = quickSlot
  for idx, slot in ipairs(self.slots) do
    slot.background:ChangeTextureInfoName("New_UI_Common_forLua/Default/BlackPanel_Series.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(slot.background, 200, 200, 230, 230)
    slot.background:getBaseTexture():setUV(x1, y1, x2, y2)
    slot.background:setRenderTexture(slot.background:getBaseTexture())
  end
end
function QuickSlot_Empty()
  local self = quickSlot
  for idx, slot in ipairs(self.slots) do
    if CppEnums.QuickSlotType.eEmpty == slot.slotType then
      slot.background:ChangeOnTextureInfoName("New_UI_Common_forLua/Default/BlackPanel_Series.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(slot.background, 70, 130, 120, 180)
      slot.background:getOnTexture():setUV(x1, y1, x2, y2)
      slot.background:setRenderTexture(slot.background:getBaseTexture())
      slot.background:SetAlpha(0.5)
    end
  end
end
local halfScreenSize = getScreenSizeX() / 2 - Panel_QuickSlot:GetPosX()
local potionAlert = true
local potionPosInit = false
local potionRefill = false
local potion_bubble = UI.getChildControl(Panel_QuickSlot, "StaticText_Bubble")
local potion_bubble2 = UI.getChildControl(Panel_QuickSlot, "StaticText_Bubble2")
potion_bubble:SetShow(false)
potion_bubble2:SetShow(false)
potion_bubble2:SetPosX(-85)
potion_bubble2:SetPosY(-50)
potion_bubble:SetPosY(-50)
function NoPotion_Alert()
  local invenSize = getSelfPlayer():get():getInventory():size() - 1
  Potion_Info_Init()
  for index = 1, invenSize do
    local itemWrapper = getInventoryItem(index)
    if nil ~= itemWrapper then
      local itemKey = itemWrapper:get():getKey():getItemKey()
      if true == PaGlobal_Quickslot_IsPostion(itemKey) then
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
  Potion_Pos_Init()
  potionAlert = false
end
function PaGlobal_Quickslot_IsPostion(itemKey)
  local postionList = {
    502,
    513,
    514,
    517,
    518,
    519,
    524,
    525,
    528,
    529,
    530,
    538,
    551,
    552,
    553,
    554,
    555,
    17568,
    17569,
    17679,
    17681,
    17682,
    17683,
    17684,
    19932,
    19933,
    19934,
    19935
  }
  for _, v in pairs(postionList) do
    if v == itemKey then
      return true
    end
  end
  return false
end
local bubbleChange = false
local bubble2Change = false
function Potion_Info_Init()
  potionPosInit = false
  potionRefill = false
  for index = quickSlot.config.slotCount - 1, 0, -1 do
    local quickType = getQuickSlotItem(index)._type
    if CppEnums.QuickSlotType.eItem == quickType or CppEnums.QuickSlotType.eCashItem == quickType or CppEnums.QuickSlotType.eInstanceItem == quickType then
      local quickSlotInfo = getQuickSlotItem(index)
      local invenSlotNo = getSelfPlayer():get():getInventory():getSlot(quickSlotInfo._itemKey)
      local itemStaticWrapper = getItemEnchantStaticStatus(quickSlotInfo._itemKey)
      local itemKey = quickSlotInfo._itemKey:getItemKey()
      if true == PaGlobal_Quickslot_IsPostion(itemKey) then
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
end
function Potion_Pos_Init()
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
  if Panel_QuickSlot:GetRelativePosX() == -1 and Panel_QuickSlot:GetRelativePosY() == -1 then
    local initPosX = (getScreenSizeX() - Panel_QuickSlot:GetSizeX()) / 2
    local initPosY = getScreenSizeY() - Panel_QuickSlot:GetSizeY()
    Panel_QuickSlot:SetPosX((getScreenSizeX() - Panel_QuickSlot:GetSizeX()) / 2)
    Panel_QuickSlot:SetPosY(getScreenSizeY() - Panel_QuickSlot:GetSizeY())
    changePositionBySever(Panel_QuickSlot, CppEnums.PAGameUIType.PAGameUIPanel_QuickSlot, false, true, false)
    FGlobal_InitPanelRelativePos(Panel_QuickSlot, initPosX, initPosY)
  elseif Panel_QuickSlot:GetRelativePosX() == 0 and Panel_QuickSlot:GetRelativePosY() == 0 then
    Panel_QuickSlot:SetPosX((getScreenSizeX() - Panel_QuickSlot:GetSizeX()) / 2)
    Panel_QuickSlot:SetPosY(getScreenSizeY() - Panel_QuickSlot:GetSizeY())
  else
    Panel_QuickSlot:SetPosX(getScreenSizeX() * Panel_QuickSlot:GetRelativePosX() - Panel_QuickSlot:GetSizeX() / 2)
    Panel_QuickSlot:SetPosY(getScreenSizeY() * Panel_QuickSlot:GetRelativePosY() - Panel_QuickSlot:GetSizeY() / 2)
  end
  FGlobal_PanelRepostionbyScreenOut(Panel_QuickSlot)
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
    Panel_QuickSlot:SetShow(isShow, isAni)
  else
    Panel_QuickSlot:SetShow(false, false)
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_QuickSlot")
function FromClient_luaLoadComplete_QuickSlot()
  quickSlot:init()
  quickSlot:createSlot()
  quickSlot:registEventHandler()
  quickSlot:registMessageHandler()
  if not isUseNewQuickSlot() then
    changePositionBySever(Panel_QuickSlot, CppEnums.PAGameUIType.PAGameUIPanel_QuickSlot, false, true, false)
  end
  registerEvent("FromClient_RenderModeChangeState", "renderModeChange_QuickSlot_OnscreenResize")
end
