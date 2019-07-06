local functor = {}
function FromClient_ActionChartEvent(actorKeyRaw, eventNo, isSelfPlayer)
  local aFunction = functor[eventNo]
  if nil ~= aFunction then
    aFunction(actorKeyRaw, isSelfPlayer)
  end
end
function ActionChartEventBindFunction(eventNo, insertFunctor)
  if nil ~= functor[eventNo] then
    _PA_ASSERT(false, "\236\158\152\235\170\187\235\144\156 ActionChart\236\157\180\235\178\164\237\138\184\235\165\188 \236\130\189\236\158\133\237\149\152\236\152\128\236\138\181\235\139\136\235\139\164. ActionChartEventBindFunction \237\149\168\236\136\152\236\157\152 \236\178\171\235\178\136\236\167\184 \236\157\184\236\158\144\235\165\188 \237\153\149\236\157\184\237\149\180 \236\163\188\236\132\184\236\154\148.")
  else
    functor[eventNo] = insertFunctor
  end
end
registerEvent("FromClient_ActionChartEvent", "FromClient_ActionChartEvent")
