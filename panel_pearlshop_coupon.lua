local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local isCouponOpen = ToClient_IsContentsGroupOpen("224")
local cashCoupon = {
  _ui = {
    _stc_mainBG = UI.getChildControl(Panel_PearlShop_Coupon, "Static_MainBG"),
    _list2_Coupon = nil,
    _txt_noCoupon = nil,
    _stc_BottomBG = UI.getChildControl(Panel_PearlShop_Coupon, "Static_BottomSite"),
    _txt_KeyGuide_B = nil
  },
  _isAvailableTab = true,
  CouponList = {}
}
function PaGlobal_PearlShopCoupon_Init()
  local self = cashCoupon
  self._ui._list2_Coupon = UI.getChildControl(self._ui._stc_mainBG, "List2_Coupon")
  self._ui._txt_noCoupon = UI.getChildControl(self._ui._stc_mainBG, "StaticText_NoCoupon")
  self._ui._txt_KeyGuide_B = UI.getChildControl(self._ui._stc_BottomBG, "StaticText_KeyGuide_B")
  self._ui._txt_noCoupon:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._txt_noCoupon:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PEARLSHOP_NOCOUPON"))
  self._ui._list2_Coupon:changeAnimationSpeed(10)
  self._ui._list2_Coupon:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_PearlShopCoupon_CreateListContents")
  self._ui._list2_Coupon:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign({
    self._ui._txt_KeyGuide_B
  }, self._ui._stc_BottomBG, CONSOLEKEYGUID_A, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  Panel_PearlShop_Coupon:ignorePadSnapMoveToOtherPanel()
end
function PaGlobal_PearlShopCoupon_CreateListContents(contents, key)
  local self = cashCoupon
  local idx = Int64toInt32(key)
  local couponBG = UI.getChildControl(contents, "Static_CouponBG")
  local txt_Title = UI.getChildControl(contents, "StaticText_CouponName")
  local txt_Date = UI.getChildControl(contents, "StaticText_CouponDate")
  local txt_Rate = UI.getChildControl(contents, "StaticText_CouponRate")
  local txt_Desc = UI.getChildControl(contents, "StaticText_CouponDesc")
  local couponWrapper = ToClient_GetCouponInfoWrapper(idx)
  if nil == couponWrapper then
    return
  end
  local couponName = couponWrapper:getCouponName()
  local couponKey = couponWrapper:getCouponKey()
  local couponState = couponWrapper:getCouponState()
  local couponExpirationDate = couponWrapper:getExpirationDateTime()
  local couponRate = couponWrapper:getCouponDisCountRate()
  local couponPearl = couponWrapper:getCouponDisCountPearl()
  local couponMaxDiscount = couponWrapper:getCouponMaxDisCountPearl()
  local couponCategory = couponWrapper:getCouponCategoryExpression()
  local isDiscountPearl = couponWrapper:isDisCountPearl()
  txt_Title:SetTextMode(UI_TM.eTextMode_LimitText)
  txt_Title:SetText(couponName)
  if false == isDiscountPearl then
    txt_Rate:SetText(couponRate / 10000 .. "%")
  else
    txt_Rate:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_COUPON_COUPONPEARL", "couponPearl", tostring(couponPearl)))
  end
  txt_Date:setLineCountByLimitAutoWrap(2)
  txt_Date:SetTextMode(UI_TM.eTextMode_Limit_AutoWrap)
  txt_Date:SetText("~" .. couponExpirationDate)
  txt_Desc:setLineCountByLimitAutoWrap(2)
  txt_Desc:SetTextMode(UI_TM.eTextMode_Limit_AutoWrap)
  txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COUPON_USECATEGORY") .. " : " .. tostring(couponCategory))
  couponBG:addInputEvent("Mouse_LUp", "PaGlobal_PearlShopCoupon_ClickCoupon()")
  couponBG:addInputEvent("Mouse_On", "PaGlobal_PearlShopCoupon_FocusOn(" .. idx .. ")")
  couponBG:addInputEvent("Mouse_Out", "PaGlobal_PearlShopCoupon_FocusOut(" .. idx .. ")")
end
function PaGlobal_PearlShopCoupon_ClickCoupon()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_COUPON_BUYWHENAPPLY"))
end
function PaGlobal_PearlShopCoupon_FocusOn(idx)
  local self = cashCoupon
  local contents = self._ui._list2_Coupon:GetContentByKey(toInt64(0, idx))
  local txt_Title = UI.getChildControl(contents, "StaticText_CouponName")
  local txt_Date = UI.getChildControl(contents, "StaticText_CouponDate")
  local txt_Rate = UI.getChildControl(contents, "StaticText_CouponRate")
  local txt_Desc = UI.getChildControl(contents, "StaticText_CouponDesc")
  txt_Title:SetFontColor(UI_color.C_FFE6B757)
  txt_Date:SetFontColor(UI_color.C_FFE6B757)
  txt_Rate:SetFontColor(UI_color.C_FFE6B757)
  txt_Desc:SetFontColor(UI_color.C_FFE6B757)
end
function PaGlobal_PearlShopCoupon_FocusOut(idx)
  local self = cashCoupon
  local contents = self._ui._list2_Coupon:GetContentByKey(toInt64(0, idx))
  local txt_Title = UI.getChildControl(contents, "StaticText_CouponName")
  local txt_Date = UI.getChildControl(contents, "StaticText_CouponDate")
  local txt_Rate = UI.getChildControl(contents, "StaticText_CouponRate")
  local txt_Desc = UI.getChildControl(contents, "StaticText_CouponDesc")
  txt_Title:SetFontColor(UI_color.C_FFBEC4DA)
  txt_Date:SetFontColor(UI_color.C_FFCCD1E4)
  txt_Rate:SetFontColor(UI_color.C_FFCCD1E4)
  txt_Desc:SetFontColor(UI_color.C_FFCCD1E4)
end
function PaGlobal_PearlShopCoupon_Update(productNoRaw, productCount)
  local self = cashCoupon
  local count = ToClient_GetCouponInfoCount()
  local usableCount = 0
  self._ui._list2_Coupon:getElementManager():clearKey()
  for i = 0, count - 1 do
    local couponWrapper = ToClient_GetCouponInfoWrapper(i)
    if 0 == couponWrapper:getCouponState() and nil == cashProduct then
      usableCount = usableCount + 1
      self._ui._list2_Coupon:getElementManager():pushKey(toInt64(0, i))
    end
  end
  if 0 == usableCount then
    self._ui._txt_noCoupon:SetShow(true)
    self._ui._list2_Coupon:SetShow(false)
  else
    self._ui._txt_noCoupon:SetShow(false)
    self._ui._list2_Coupon:SetShow(true)
  end
end
function PaGlobal_PearlShopCoupon_Delete(couponNo)
  if nil == couponNo then
    return
  end
  ToClient_DeleteCoupon(tonumber64(couponNo))
end
function FromClient_UpdateCouponInfo()
  PaGlobal_PearlShopCoupon_Update()
end
function FromClient_DeleteCoupon(checkDelete)
  if checkDelete then
    PaGlobal_PearlShopCoupon_Update()
    return
  end
end
function PaGlobal_PearlShopCoupon_Open(openType, productNoRaw, productCount)
  local self = cashCoupon
  Panel_PearlShop_Coupon:SetShow(true)
  PaGlobal_PearlShopCoupon_Update(productNoRaw, productCount)
end
function PaGlobal_PearlShopCoupon_Close()
  Panel_PearlShop_Coupon:SetShow(false)
end
PaGlobal_PearlShopCoupon_Init()
registerEvent("FromClient_UpdateCouponInfo", "FromClient_UpdateCouponInfo")
registerEvent("FromClient_DeleteCoupon", "FromClient_DeleteCoupon")
