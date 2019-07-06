PaGlobal_ImportantNotice = {
  _eEventState = {
    _non = 0,
    _newNotice = 1,
    _addTime = 2
  },
  _ui = {
    _static_noticeBG = nil,
    _static_noticeIcon = nil,
    _static_clipArea = nil,
    _staticText_message = nil,
    _staticText_calculate = nil,
    _static_noticeListBG = nil,
    _list2_noticeList = nil,
    _frame_noticeList = nil,
    _frame_content = nil,
    _frameContent_List = nil
  },
  _eventState = 0,
  _isFinishMessage = false,
  _moveEndTime = 3,
  _cacheStartPos = float2(0, 0),
  _animationTime = 0,
  _animationEndTime = 10,
  _isAnimationStart = false,
  _currentNoticeIndex = 0,
  _currentNoticeFontColor = 0,
  _stringList = nil,
  _cacheTextSizeY = 0,
  _cacheBGSizeY = 0,
  _applyBGSizeY = 0,
  _SIZE_OFFSET_BG = 50,
  _defaultListSizeX = 0,
  _defaultContentsSizeY = 0,
  _isNoticeOpen = false,
  _isResizeFailed = false,
  _isShowState = false,
  _isConsole = false,
  _initialize = false
}
runLua("UI_Data/Script/Widget/Chatting/Notice/Panel_Important_Notice_1.lua")
runLua("UI_Data/Script/Widget/Chatting/Notice/Panel_Important_Notice_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_ImportantNoticeInit")
function FromClient_ImportantNoticeInit()
  PaGlobal_ImportantNotice:initialize()
end
