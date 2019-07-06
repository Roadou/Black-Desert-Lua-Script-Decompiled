function FromClient_UseCouponItem(itemWhereType, slotNo, param1)
  ToClient_RegisterCoupon(itemWhereType, slotNo)
end
function FromClient_Test()
  _PA_LOG("asdf", "FromClient_Test")
end
registerEvent("FromClient_UseCouponItem", "FromClient_UseCouponItem")
registerEvent("FromClient_ClearSkillsByPoint", "FromClient_Test")
