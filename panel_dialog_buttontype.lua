local dialogQuestButtonIcon = {
  [0] = {
    63,
    291,
    93,
    321
  },
  {
    187,
    260,
    217,
    290
  },
  {
    32,
    291,
    62,
    321
  },
  {
    32,
    229,
    62,
    259
  },
  {
    63,
    229,
    93,
    259
  },
  {
    1,
    291,
    31,
    321
  },
  {
    1,
    229,
    31,
    259
  },
  {
    156,
    229,
    186,
    259
  },
  {
    94,
    229,
    124,
    259
  },
  {
    125,
    229,
    155,
    259
  },
  {
    0,
    0,
    1,
    1
  },
  {
    0,
    0,
    1,
    1
  }
}
local consoleDialogQuestButtonIcon = {
  [0] = {
    63,
    291,
    93,
    321
  },
  {
    187,
    260,
    217,
    290
  },
  {
    32,
    291,
    62,
    321
  },
  {
    32,
    229,
    62,
    259
  },
  {
    63,
    229,
    93,
    259
  },
  {
    1,
    291,
    31,
    321
  },
  {
    1,
    229,
    31,
    259
  },
  {
    156,
    229,
    186,
    259
  },
  {
    94,
    229,
    124,
    259
  },
  {
    125,
    229,
    155,
    259
  },
  {
    0,
    0,
    1,
    1
  }
}
local dialogButtonIcon = {
  [0] = {
    0,
    0,
    0,
    0
  },
  {
    125,
    1,
    153,
    31
  },
  {
    156,
    1,
    186,
    31
  },
  {
    94,
    1,
    124,
    31
  },
  {
    63,
    1,
    93,
    31
  },
  {
    63,
    1,
    93,
    31
  },
  {
    218,
    1,
    248,
    31
  }
}
function FGlobal_ChangeOnTextureForConsoleDialogQuestIcon(control, iconType)
  control:ChangeTextureInfoNameAsync("Renewal/UI_Icon/Console_Icon_02.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, consoleDialogQuestButtonIcon[iconType][1], consoleDialogQuestButtonIcon[iconType][2], consoleDialogQuestButtonIcon[iconType][3], consoleDialogQuestButtonIcon[iconType][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function FGlobal_ChangeOnTextureForDialogQuestIcon(control, iconType)
  control:ChangeTextureInfoNameAsync("Renewal/UI_Icon/Console_Icon_02.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, dialogQuestButtonIcon[iconType][1], dialogQuestButtonIcon[iconType][2], dialogQuestButtonIcon[iconType][3], dialogQuestButtonIcon[iconType][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function FGlobal_ChangeOnTextureForDialogIcon(control, iconType)
  control:ChangeTextureInfoNameAsync("Renewal/UI_Icon/Console_DialogueIcon_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, dialogButtonIcon[iconType][1], dialogButtonIcon[iconType][2], dialogButtonIcon[iconType][3], dialogButtonIcon[iconType][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
