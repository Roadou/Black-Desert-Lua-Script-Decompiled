PaGlobal_DialogIntimacy_All = {
  _ui = {
    stc_title = nil,
    stc_progressBg = nil,
    stc_circularProgress = nil,
    stc_rewardIcon = nil,
    stc_rewardTemplete = nil,
    txt_currentIntimacy = nil
  },
  _intimacyValueBuffer = {},
  _rewardList = {},
  _text = {
    hasMentalCardText = PAGetString(Defines.StringSheet_GAME, "LUA_INTIMACY_ALL_INFORMATION_HASMENTALCARD"),
    hasntMentalCardText = PAGetString(Defines.StringSheet_GAME, "LUA_INTIMACY_ALL_INFORMATION_HASNTMENTALCARD")
  },
  _maxIntimacyRewardCount = 8,
  _rewardTextPos = {x = nil, y = nil},
  _space = {progressToReward = 64, rewardTextHBorder = 27},
  _intimacyIcon = {
    [0] = {
      [1] = {
        texture = "Renewal/UI_Icon/Console_Icon_00.dds",
        x1 = 38,
        y1 = 200,
        x2 = 65,
        y2 = 227
      },
      [2] = {
        texture = "Renewal/UI_Icon/Console_Icon_00.dds",
        x1 = 94,
        y1 = 200,
        x2 = 121,
        y2 = 227
      },
      [3] = {
        texture = "Renewal/UI_Icon/Console_Icon_00.dds",
        x1 = 66,
        y1 = 200,
        x2 = 93,
        y2 = 227
      }
    },
    [1] = {
      texture = "Renewal/UI_Icon/Console_Icon_00.dds",
      x1 = 150,
      y1 = 200,
      x2 = 177,
      y2 = 227
    },
    [2] = {
      texture = "Renewal/UI_Icon/Console_Icon_00.dds",
      x1 = 122,
      y1 = 200,
      x2 = 149,
      y2 = 227
    },
    [3] = {
      texture = "Renewal/UI_Icon/Console_Icon_00.dds",
      x1 = 178,
      y1 = 200,
      x2 = 205,
      y2 = 227
    },
    [4] = {
      texture = "Renewal/Progress/Console_Progressbar_02.dds",
      x1 = 163,
      y1 = 448,
      x2 = 194,
      y2 = 479
    },
    [5] = {
      texture = "Renewal/UI_Icon/Console_Icon_00.dds",
      x1 = 231,
      y1 = 24,
      x2 = 205,
      y2 = 227
    }
  },
  _operatorString = {
    [CppEnums.DlgCommonConditionOperatorType.Equal] = "",
    [CppEnums.DlgCommonConditionOperatorType.Large] = "<PAColor0xFFFF0000>\226\150\178<PAOldColor>",
    [CppEnums.DlgCommonConditionOperatorType.Small] = "<PAColor0xFF0000FF>\226\150\188<PAOldColor>"
  },
  _math_AddVectorToVector = Util.Math.AddVectorToVector,
  _math_MulNumberToVector = Util.Math.MulNumberToVector,
  _initialize = false
}
runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_Intimacy_All_1.lua")
runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_Intimacy_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_PaGlobal_DialogIntimacy_All_Init")
function FromClient_PaGlobal_DialogIntimacy_All_Init()
  PaGlobal_DialogIntimacy_All:initialize()
end
