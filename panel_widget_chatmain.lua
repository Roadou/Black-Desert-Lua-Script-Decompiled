PaGlobal_ChatMain = {
  _ui = {},
  _POOLCOUNT = 5,
  _listPanel = {},
  _listChatUIPool = {},
  _listPopupNameMenu = {},
  _MAX_LISTCOUNT = 100,
  _DEFAULT_PANELSIZE_X = 420,
  _DEFAULT_PANELSIZE_Y = 222,
  _chatRenderMode = nil,
  _emoticonInfo = {},
  guildPromoteList = nil,
  _mainPanelSelectPanelIndex = 0,
  _MAX_HISTORYCOUNT = ToClient_getChattingMaxContentsCount() - 50,
  _cacheSimpleUI = false,
  _addChattingIdx = nil,
  _addChattingPreset = false,
  _srollPosition = {
    [0] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0
  },
  _transparency = {
    [0] = 0.5,
    [1] = 0.5,
    [2] = 0.5,
    [3] = 0.5,
    [4] = 0.5
  },
  _scroll_BTNPos = {
    [0] = 1,
    [1] = 1,
    [2] = 1,
    [3] = 1,
    [4] = 1
  },
  _linkedItemTooltipIsClicked = false,
  _isMouseOnChattingViewIndex = nil,
  _isMouseOn = false,
  _orgMouseX = 0,
  _orgMouseY = 0,
  _orgPanelSizeX = 0,
  _orgPanelSizeY = 0,
  _orgPanelPosY = 0,
  _chattingUpTime = 0,
  _premsgCount = {
    [0] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0
  },
  _prepopmsgCount = {
    [0] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0
  },
  _issmoothupMessage = false,
  _smoothScorllTime = 0,
  _deltascrollPosy = {
    [0] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0
  },
  _issmoothscroll = false,
  _preScrollControlPos = {
    [0] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0
  },
  _smoothWheelScorllTime = 0,
  _issmoothWheelscroll = false,
  _isUpDown = false,
  _scrollIndex = 0,
  _scrollresetSpeed = 0,
  _smoothResetScorllTime = 0,
  _isResetsmoothscroll = false,
  _preDownPosY = 0,
  _isUsedSmoothChattingUp = false,
  _scroll_IntervalAddPos = {
    [0] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0
  },
  _tabButton_PosX = 0,
  _isMsgin = false,
  _CHATTING_WINDOW_MAXWIDTH = 600,
  _shownEmoticonIndex = nil,
  _SCROLL_INTERVALSIZE = 6.2,
  _scrollCount = 0,
  _SCROLL_COUNT_ADD = 1,
  _SCROLL_COUNT_MAX = 5,
  _initialize = false,
  _recommand_btnUV = {
    _normal = {
      {
        x1 = 181,
        y1 = 1,
        x2 = 200,
        y2 = 20
      },
      {
        x1 = 161,
        y1 = 1,
        x2 = 180,
        y2 = 20
      },
      {
        x1 = 141,
        y1 = 1,
        x2 = 160,
        y2 = 20
      },
      {
        x1 = 121,
        y1 = 1,
        x2 = 140,
        y2 = 20
      },
      {
        x1 = 101,
        y1 = 1,
        x2 = 120,
        y2 = 20
      },
      {
        x1 = 81,
        y1 = 1,
        x2 = 100,
        y2 = 20
      },
      {
        x1 = 61,
        y1 = 1,
        x2 = 80,
        y2 = 20
      },
      {
        x1 = 41,
        y1 = 1,
        x2 = 60,
        y2 = 20
      },
      {
        x1 = 21,
        y1 = 1,
        x2 = 40,
        y2 = 20
      },
      {
        x1 = 1,
        y1 = 1,
        x2 = 20,
        y2 = 20
      }
    },
    _on = {
      {
        x1 = 181,
        y1 = 41,
        x2 = 200,
        y2 = 60
      },
      {
        x1 = 161,
        y1 = 41,
        x2 = 180,
        y2 = 60
      },
      {
        x1 = 141,
        y1 = 41,
        x2 = 160,
        y2 = 60
      },
      {
        x1 = 121,
        y1 = 41,
        x2 = 140,
        y2 = 60
      },
      {
        x1 = 101,
        y1 = 41,
        x2 = 120,
        y2 = 60
      },
      {
        x1 = 81,
        y1 = 41,
        x2 = 100,
        y2 = 60
      },
      {
        x1 = 61,
        y1 = 41,
        x2 = 80,
        y2 = 60
      },
      {
        x1 = 41,
        y1 = 41,
        x2 = 60,
        y2 = 60
      },
      {
        x1 = 21,
        y1 = 41,
        x2 = 40,
        y2 = 60
      },
      {
        x1 = 1,
        y1 = 41,
        x2 = 20,
        y2 = 60
      }
    },
    _click = {
      {
        x1 = 181,
        y1 = 21,
        x2 = 200,
        y2 = 40
      },
      {
        x1 = 161,
        y1 = 21,
        x2 = 180,
        y2 = 40
      },
      {
        x1 = 141,
        y1 = 21,
        x2 = 160,
        y2 = 40
      },
      {
        x1 = 121,
        y1 = 21,
        x2 = 140,
        y2 = 40
      },
      {
        x1 = 101,
        y1 = 21,
        x2 = 120,
        y2 = 40
      },
      {
        x1 = 81,
        y1 = 21,
        x2 = 100,
        y2 = 40
      },
      {
        x1 = 61,
        y1 = 21,
        x2 = 80,
        y2 = 40
      },
      {
        x1 = 41,
        y1 = 21,
        x2 = 60,
        y2 = 40
      },
      {
        x1 = 21,
        y1 = 21,
        x2 = 40,
        y2 = 40
      },
      {
        x1 = 1,
        y1 = 21,
        x2 = 20,
        y2 = 40
      }
    }
  }
}
runLua("UI_Data/Script/Widget/Chatting/ChatMain/Panel_Widget_ChatMain_1.lua")
runLua("UI_Data/Script/Widget/Chatting/ChatMain/Panel_Widget_ChatMain_2.lua")
runLua("UI_Data/Script/Widget/Chatting/ChatMain/Panel_Widget_ChatMain_3.lua")
runLua("UI_Data/Script/Widget/Chatting/ChatMain/Panel_Widget_ChatMain_4.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_ChatMainInit")
function FromClient_ChatMainInit()
  PaGlobal_ChatMain:initialize()
end
