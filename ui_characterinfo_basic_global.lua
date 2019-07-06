local UI_Color = Defines.Color
function FGlobal_UI_CharacterInfo_Basic_Global_CraftColorReplace(lev)
  local levColor = UI_Color.C_FFC4C4C4
  if lev >= 1 and lev <= 10 then
    levColor = UI_Color.C_FFC4C4C4
  elseif lev >= 11 and lev <= 20 then
    levColor = UI_Color.C_FF76B24D
  elseif lev >= 21 and lev <= 30 then
    levColor = UI_Color.C_FF3B8BBE
  elseif lev >= 31 and lev <= 40 then
    levColor = UI_Color.C_FFEBC467
  elseif lev >= 41 and lev <= 50 then
    levColor = UI_Color.C_FFD04D47
  elseif lev >= 51 and lev <= 80 then
    levColor = UI_Color.C_FFB23BC7
  elseif lev >= 81 and lev <= 100 then
    levColor = UI_Color.C_FFC78045
  elseif lev >= 101 and lev <= 130 then
    levColor = UI_Color.C_FFC78045
  end
  return levColor
end
function FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(lev, craftType)
  if lev >= 1 and lev <= 10 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_1") .. lev
  elseif lev >= 11 and lev <= 20 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_2") .. lev - 10
  elseif lev >= 21 and lev <= 30 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_3") .. lev - 20
  elseif lev >= 31 and lev <= 40 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_4") .. lev - 30
  elseif lev >= 41 and lev <= 50 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_5") .. lev - 40
  elseif lev >= 51 and lev <= 80 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_6") .. lev - 50
  elseif lev >= 81 and lev <= 100 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_7") .. lev - 80
  elseif lev >= 101 and lev <= 130 then
    lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_7") .. lev - 80
  end
  return lev
end
function FGlobal_UI_CharacterInfo_Basic_Global_CheckIntroduceUiEdit(targetUI)
  if false == PaGlobal_CharacterInfoPanel_GetShowPanelStatus() then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  return nil ~= targetUI and targetUI:GetKey() == self._ui._multilineEdit:GetKey()
end
