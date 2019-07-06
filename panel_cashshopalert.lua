Panel_CashShopAlert:ActiveMouseEventEffect(true)
Panel_CashShopAlert:setGlassBackground(true)
Panel_CashShopAlert:SetShow(false)
Panel_CashShopAlert:RegisterShowEventFunc(true, "Panel_CashShopAlert_ShowAni()")
Panel_CashShopAlert:RegisterShowEventFunc(false, "Panel_CashShopAlert_HideAni()")
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
function Panel_CashShopAlert_ShowAni()
  Panel_CashShopAlert:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toLeft.dds")
  local FadeMaskAni = Panel_CashShopAlert:addTextureUVAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0, 0)
  FadeMaskAni:SetEndUV(0.6, 0, 0)
  FadeMaskAni:SetStartUV(0.4, 0, 1)
  FadeMaskAni:SetEndUV(1, 0, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0.6, 1, 2)
  FadeMaskAni:SetStartUV(0.4, 1, 3)
  FadeMaskAni:SetEndUV(1, 1, 3)
  Panel_CashShopAlert:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo8 = Panel_CashShopAlert:addColorAnimation(0, 0.4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(3)
  aniInfo8:SetEndIntensity(1)
  aniInfo3.IsChangeChild = true
end
function Panel_CashShopAlert_HideAni()
end
local cashShopAlert = {
  _bubbleBg = UI.getChildControl(Panel_CashShopAlert, "Static_Obsidian_B_Left"),
  _btn_CashShop = UI.getChildControl(Panel_CashShopAlert, "Button_GoToCashShop"),
  animationPlayTime = 5,
  iconPath = "new_ui_common_forlua/widget/uicontrol/ui_control_01.dds",
  _texture = {
    _bagIcon = {
      x1 = 150,
      y1 = 59,
      x2 = 211,
      y2 = 120
    },
    _petIcon = {
      x1 = 88,
      y1 = 59,
      x2 = 149,
      y2 = 120
    },
    _weightIcon = {
      x1 = 212,
      y1 = 59,
      x2 = 273,
      y2 = 120
    }
  },
  _type = {
    _bag = Recommend_TYPE.TYPE_INVENTORY,
    _pet = Recommend_TYPE.TYPE_PET,
    _weight = Recommend_TYPE.TYPE_WEIGHT
  },
  _string = {
    _main = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_CASHSHOPALERT_MAIN_0"),
      [1] = PAGetString(Defines.StringSheet_GAME, "LUA_CASHSHOPALERT_MAIN_1"),
      [2] = PAGetString(Defines.StringSheet_GAME, "LUA_CASHSHOPALERT_MAIN_2")
    },
    _sub = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_CASHSHOPALERT_SUB_0"),
      [1] = PAGetString(Defines.StringSheet_GAME, "LUA_CASHSHOPALERT_SUB_1"),
      [2] = PAGetString(Defines.StringSheet_GAME, "LUA_CASHSHOPALERT_SUB_2")
    }
  }
}
cashShopAlert._bubbleTextTop = UI.getChildControl(cashShopAlert._bubbleBg, "StaticText_Obsidian_B")
cashShopAlert._bubbleTextBot = UI.getChildControl(cashShopAlert._bubbleBg, "StaticText_Obsidian_N")
function Panel_CashShopAlert_Show()
  if isGameTypeGT() then
    return
  end
  Panel_CashShopAlert_RePos()
  Panel_CashShopAlert:SetShow(true, true)
end
function Panel_CashShopAlert_Hide()
  Panel_CashShopAlert:SetShow(false, false)
end
function Panel_CashShopAlert_RePos()
  Panel_CashShopAlert:SetPosX(getScreenSizeX() - Panel_CashShopAlert:GetSizeX())
  Panel_CashShopAlert:SetPosY(Panel_ChallengeReward_Alert:GetPosY() - Panel_CashShopAlert:GetSizeY() - 20)
end
function OpenCashShop()
  PearlShop_Open()
  Panel_CashShopAlert_Hide()
  PaGlobal_RecommendManager:ClickedRecommendButton()
  Recommend_CashItem(PaGlobal_RecommendManager:GetNowRecommendType())
end
function cashShopAlert:SetBubbleText(shopType)
  self._bubbleTextTop:SetText(self._string._main[shopType])
  self._bubbleTextBot:SetText(self._string._sub[shopType])
  local textSizeX = math.max(self._bubbleTextTop:GetTextSizeX(), self._bubbleTextBot:GetTextSizeX())
  self._bubbleBg:SetSize(textSizeX + 20, self._bubbleBg:GetSizeY())
  self._bubbleBg:ComputePos()
  self._bubbleTextTop:ComputePos()
  self._bubbleTextBot:ComputePos()
end
function cashShopAlert:Animation()
  local aniInfo1 = self._bubbleBg:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo1:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo1.IsChangeChild = true
  local aniInfo2 = self._bubbleBg:addColorAnimation(self.animationPlayTime - 0.15, self.animationPlayTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo2:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo2.IsChangeChild = true
end
function Panel_CashShopAlert:ChangeTexture(cashShopType)
  local self = cashShopAlert
  self._btn_CashShop:ChangeTextureInfoName(cashShopAlert.iconPath)
  local x1, y1, x2, y2
  if self._type._bag == cashShopType then
    x1, y1, x2, y2 = setTextureUV_Func(self._btn_CashShop, self._texture._bagIcon.x1, self._texture._bagIcon.y1, self._texture._bagIcon.x2, self._texture._bagIcon.y2)
  elseif self._type._pet == cashShopType then
    x1, y1, x2, y2 = setTextureUV_Func(self._btn_CashShop, self._texture._petIcon.x1, self._texture._petIcon.y1, self._texture._petIcon.x2, self._texture._petIcon.y2)
  elseif self._type._weight == cashShopType then
    x1, y1, x2, y2 = setTextureUV_Func(self._btn_CashShop, self._texture._weightIcon.x1, self._texture._weightIcon.y1, self._texture._weightIcon.x2, self._texture._weightIcon.y2)
  end
  self._btn_CashShop:getBaseTexture():setUV(x1, y1, x2, y2)
  self._btn_CashShop:setRenderTexture(self._btn_CashShop:getBaseTexture())
  self:SetBubbleText(cashShopType)
  self:Animation()
end
cashShopAlert._btn_CashShop:addInputEvent("Mouse_LUp", "OpenCashShop()")
registerEvent("onScreenResize", "Panel_CashShopAlert_RePos")
