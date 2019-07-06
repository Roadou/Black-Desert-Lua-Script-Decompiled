local _btn_HuntingAlert = FGlobal_GetPersonalIconControl(3)
local _huntingPlus = FGlobal_GetPersonalText(3)
_btn_HuntingAlert:ActiveMouseEventEffect(true)
if false == _ContentsGroup_RenewUI_Main then
  _btn_HuntingAlert:setGlassBackground(true)
end
local msg = {name, desc}
function WhaleConditionCheck()
  msg.name = ""
  msg.desc = ""
  local whaleCount = ToClient_worldmapActorManagerGetActorRegionList(2)
  if whaleCount > 0 then
    for index = 0, whaleCount - 1 do
      local areaName = ToClient_worldmapActorManagerGetActorRegionByIndex(index)
      local count = ToClient_worldmapActorManagerGetActorCountByIndex(index)
      if nil ~= areaName then
        if 0 == index then
          msg.desc = msg.desc .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_WHALE_FIND", "areaName", tostring(areaName), "count", count)
        else
          msg.desc = msg.desc .. "\n" .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_WHALE_FIND", "areaName", tostring(areaName), "count", count)
        end
      end
    end
    msg.name = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_WHALE_FIND_NAME")
    _huntingPlus:SetShow(true)
  end
  local gargoyleCount = ToClient_worldmapActorManagerGetActorRegionList(3)
  if gargoyleCount > 0 then
    for index = 0, gargoyleCount - 1 do
      local areaName = ToClient_worldmapActorManagerGetActorRegionByIndex(index)
      local count = ToClient_worldmapActorManagerGetActorCountByIndex(index)
      if nil ~= areaName then
        if 0 == index then
          if whaleCount > 0 then
            msg.desc = msg.desc .. "\n" .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_HUNTING_GARGOYLE", "areaName", tostring(areaName), "count", count)
          else
            msg.desc = msg.desc .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_HUNTING_GARGOYLE", "areaName", tostring(areaName), "count", count)
          end
        else
          msg.desc = msg.desc .. "\n" .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_HUNTING_GARGOYLE", "areaName", tostring(areaName), "count", count)
        end
      end
    end
    msg.name = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_WHALE_FIND_NAME")
    _huntingPlus:SetShow(true)
  end
  local griffonCount = ToClient_worldmapActorManagerGetActorRegionList(4)
  if griffonCount > 0 then
    for index = 0, griffonCount - 1 do
      local areaName = ToClient_worldmapActorManagerGetActorRegionByIndex(index)
      local count = ToClient_worldmapActorManagerGetActorCountByIndex(index)
      if nil ~= areaName then
        if 0 == index then
          if "" == msg.desc then
            msg.desc = msg.desc .. "[" .. tostring(areaName) .. "]\236\151\144 \236\160\156\236\153\149 \234\183\184\235\166\172\237\143\176\236\157\180 " .. count .. " \235\167\136\235\166\172 \236\182\156\237\152\132\237\149\152\236\152\128\236\138\181\235\139\136\235\139\164."
          else
            msg.desc = msg.desc .. "\n" .. "[" .. tostring(areaName) .. "]\236\151\144 \236\149\188\236\131\157\236\157\152 \236\160\156\236\153\149 \234\183\184\235\166\172\237\143\176\236\157\180 " .. count .. " \235\167\136\235\166\172 \236\182\156\237\152\132\237\149\152\236\152\128\236\138\181\235\139\136\235\139\164."
          end
        else
          msg.desc = msg.desc .. "\n" .. "[" .. tostring(areaName) .. "]\236\151\144 \236\160\156\236\153\149 \234\183\184\235\166\172\237\143\176\236\157\180 " .. count .. " \235\167\136\235\166\172 \236\182\156\237\152\132\237\149\152\236\152\128\236\138\181\235\139\136\235\139\164."
        end
      end
    end
    msg.name = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_WHALE_FIND_NAME")
    _huntingPlus:SetShow(true)
  end
  if 0 == gargoyleCount + whaleCount + griffonCount then
    msg.name = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_WHALE")
    msg.desc = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_WHALE_NOT_FIND")
    _huntingPlus:SetShow(false)
  end
end
function Hunting_ToolTip_ShowToggle(isShow)
  WhaleConditionCheck()
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  TooltipSimple_Show(_btn_HuntingAlert, msg.name, msg.desc)
end
function FGlobal_WhaleConditionCheck()
  if _btn_HuntingAlert:GetShow() then
    WhaleConditionCheck()
  end
end
WhaleConditionCheck()
