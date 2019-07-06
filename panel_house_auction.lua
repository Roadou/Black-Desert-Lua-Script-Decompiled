Panel_Auction:SetShow(false, false)
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PP = CppEnums.PAUIMB_PRIORITY
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
Panel_Auction:setMaskingChild(true)
Panel_Auction:ActiveMouseEventEffect(true)
Panel_Auction:setGlassBackground(true)
Panel_Auction:RegisterShowEventFunc(true, "HouseAuction_ShowAni()")
Panel_Auction:RegisterShowEventFunc(false, "HouseAuction_HideAni()")
function HouseAuction_ShowAni()
  UIAni.fadeInSCR_Down(Panel_Auction)
  local aniInfo1 = Panel_Auction:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_Auction:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Auction:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Auction:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Auction:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Auction:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function HouseAuction_HideAni()
  Panel_Auction:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Auction:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local HouseAuctionManager = {
  _houseAuctionList = {}
}
local startX = 15
local startY = 40
local gapX = 10
local gapY = 10
local sizeX = 490
local sizeY = 190
local maxXCount = 2
local maxYCount = 3
local auctionDisplayTime = function(timeValue)
  timeValue = timeValue / toUint64(0, 1000)
  if timeValue > toUint64(0, 3600) then
    timeValue = timeValue / toUint64(0, 3600)
    return tostring(timeValue) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR")
  elseif timeValue > toUint64(0, 120) then
    timeValue = timeValue / toUint64(0, 60)
    return tostring(timeValue) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE")
  elseif timeValue > toUint64(0, 0) then
    return PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_HOUSE_DEADLINE")
  else
    return PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_CLOSEAUCTION")
  end
end
local myBidList = UI.getChildControl(Panel_Auction, "Button_MyBidList")
myBidList:addInputEvent("Mouse_LUp", "HandleClickedAuctionPageChange()")
function HandleClickedAuctionPageChange()
  local myAuctionInfo = RequestGetAuctionInfo()
  local auctionType = myAuctionInfo:getAuctionType()
  for key, value in pairs(HouseAuctionManager._houseAuctionList) do
    value._editInGold:SetEditText("", true)
  end
  ClearFocusEdit()
  if auctionType == 1 then
    RequestBiddingPage()
  elseif auctionType == 5 then
    RequestAuctionListPage()
  end
end
local panelBG = UI.getChildControl(Panel_Auction, "Static_BackGround")
local styleBG = UI.getChildControl(Panel_Auction, "Style_BG")
local cancelButton = UI.getChildControl(Panel_Auction, "Button_Cancel_Get")
local bidButton = UI.getChildControl(Panel_Auction, "Button_Get")
local name = UI.getChildControl(Panel_Auction, "StaticText_Name")
local nowPrice = UI.getChildControl(Panel_Auction, "StaticText_NowPrice")
local aucPrice = UI.getChildControl(Panel_Auction, "StaticText_AucPrice")
local myPrice = UI.getChildControl(Panel_Auction, "StaticText_MyPrice")
local editInGold = UI.getChildControl(Panel_Auction, "Edit_InGold")
local money = UI.getChildControl(Panel_Auction, "StaticText_Money")
local styleImage = UI.getChildControl(Panel_Auction, "Static_Image")
local styleTime = UI.getChildControl(Panel_Auction, "StaticText_Time")
local styleArea = UI.getChildControl(Panel_Auction, "StaticText_Area")
local styleSpecialService = UI.getChildControl(Panel_Auction, "StaticText_SpecialService")
local styleListCount = UI.getChildControl(Panel_Auction, "StaticText_List")
local buttonListLeft = UI.getChildControl(Panel_Auction, "Button_List_Left")
local buttonListRight = UI.getChildControl(Panel_Auction, "Button_List_Right")
local buttonWinClose = UI.getChildControl(Panel_Auction, "Button_Win_Close")
local _buttonQuestion = UI.getChildControl(Panel_Auction, "Button_Question")
panelBG:setGlassBackground(true)
panelBG:ActiveMouseEventEffect(true)
local auctionHouseDescFrame = {
  [0] = {
    Frame = UI.getChildControl(Panel_Auction, "Frame_1_AuctionDesc")
  },
  [1] = {
    Frame = UI.getChildControl(Panel_Auction, "Frame_2_AuctionDesc")
  },
  [2] = {
    Frame = UI.getChildControl(Panel_Auction, "Frame_3_AuctionDesc")
  },
  [3] = {
    Frame = UI.getChildControl(Panel_Auction, "Frame_4_AuctionDesc")
  },
  [4] = {
    Frame = UI.getChildControl(Panel_Auction, "Frame_5_AuctionDesc")
  },
  [5] = {
    Frame = UI.getChildControl(Panel_Auction, "Frame_6_AuctionDesc")
  }
}
auctionHouseDescFrame[0].FrameContent = UI.getChildControl(auctionHouseDescFrame[0].Frame, "Frame_1_AuctionDesc_Content")
auctionHouseDescFrame[1].FrameContent = UI.getChildControl(auctionHouseDescFrame[1].Frame, "Frame_2_AuctionDesc_Content")
auctionHouseDescFrame[2].FrameContent = UI.getChildControl(auctionHouseDescFrame[2].Frame, "Frame_3_AuctionDesc_Content")
auctionHouseDescFrame[3].FrameContent = UI.getChildControl(auctionHouseDescFrame[3].Frame, "Frame_4_AuctionDesc_Content")
auctionHouseDescFrame[4].FrameContent = UI.getChildControl(auctionHouseDescFrame[4].Frame, "Frame_5_AuctionDesc_Content")
auctionHouseDescFrame[5].FrameContent = UI.getChildControl(auctionHouseDescFrame[5].Frame, "Frame_6_AuctionDesc_Content")
buttonListLeft:addInputEvent("Mouse_LUp", "HandleClickedAuctionPrevButton()")
function HandleClickedAuctionPrevButton()
  for key, value in pairs(HouseAuctionManager._houseAuctionList) do
    value._editInGold:SetEditText("", true)
  end
  ClearFocusEdit()
  RequestAuctionPrevPage()
end
buttonListRight:addInputEvent("Mouse_LUp", "HandleClickedAuctionNextButton()")
function HandleClickedAuctionNextButton()
  local myAuctionInfo = RequestGetAuctionInfo()
  local houseCount = myAuctionInfo:getHouseAuctionListCount()
  if houseCount > 6 then
    for key, value in pairs(HouseAuctionManager._houseAuctionList) do
      value._editInGold:SetEditText("", true)
    end
    ClearFocusEdit()
    RequestAuctionNextPage()
  end
end
buttonWinClose:addInputEvent("Mouse_LUp", "FGlobal_AuctionWindow_Hide()")
_buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"HouseAuction\" )")
_buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"HouseAuction\", \"true\")")
_buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"HouseAuction\", \"false\")")
function FGlobal_AuctionWindow_Hide()
  local isShow = Panel_Auction:IsShow()
  if isShow == true then
    Panel_Auction:SetShow(false, false)
  end
end
function FGlobal_AuctionWindow_Show()
  local isShow = Panel_Auction:IsShow()
  if isShow == false then
    UIAni.fadeInSCR_Down(Panel_Auction)
    Panel_Auction:SetShow(true, true)
  end
end
function HouseAuctionManager:initialize()
  for y = 0, maxYCount - 1 do
    for x = 0, maxXCount - 1 do
      local index = y * maxXCount + x
      local houselist = {}
      houselist._styleBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Auction, "Style_BG_" .. index)
      houselist._cancelButton = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, houselist._styleBG, "Button_Cancel_Get_" .. index)
      houselist._bidButton = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, houselist._styleBG, "Button_Get_" .. index)
      houselist._styleName = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._styleBG, "StaticText_Name_" .. index)
      houselist._nowPrice = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._styleBG, "StaticText_NowPrice_" .. index)
      houselist._aucPrice = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._styleBG, "StaticText_AucPrice_" .. index)
      houselist._myPrice = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._styleBG, "StaticText_MyPrice_" .. index)
      houselist._editInGold = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_EDIT, houselist._styleBG, "Edit_InGold_" .. index)
      houselist._money = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._styleBG, "StaticText_Money_" .. index)
      houselist._styleImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, houselist._styleBG, "Static_Image_" .. index)
      houselist._styleTime = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._styleBG, "StaticText_Time_" .. index)
      houselist._styleArea = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._styleBG, "StaticText_Area_" .. index)
      houselist._styleSpecialService = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._styleBG, "StaticText_SpecialService_" .. index)
      CopyBaseProperty(styleBG, houselist._styleBG)
      CopyBaseProperty(cancelButton, houselist._cancelButton)
      CopyBaseProperty(bidButton, houselist._bidButton)
      CopyBaseProperty(name, houselist._styleName)
      CopyBaseProperty(nowPrice, houselist._nowPrice)
      CopyBaseProperty(aucPrice, houselist._aucPrice)
      CopyBaseProperty(myPrice, houselist._myPrice)
      CopyBaseProperty(editInGold, houselist._editInGold)
      CopyBaseProperty(money, houselist._money)
      CopyBaseProperty(styleImage, houselist._styleImage)
      CopyBaseProperty(styleTime, houselist._styleTime)
      CopyBaseProperty(styleArea, houselist._styleArea)
      CopyBaseProperty(styleSpecialService, houselist._styleSpecialService)
      houselist._styleBG:SetPosX(x * sizeX + startX)
      houselist._styleBG:SetPosY(y * sizeY + startY + y * gapY)
      houselist._styleBG:SetShow(true)
      houselist._cancelButton:SetShow(false)
      houselist._bidButton:SetShow(true)
      houselist._styleName:SetShow(true)
      houselist._nowPrice:SetShow(true)
      houselist._aucPrice:SetShow(true)
      houselist._myPrice:SetShow(true)
      houselist._editInGold:SetShow(true)
      houselist._money:SetShow(true)
      houselist._styleImage:SetShow(true)
      houselist._styleTime:SetShow(true)
      houselist._styleArea:SetShow(true)
      houselist._styleSpecialService:SetShow(true)
      houselist._editInGold:SetNumberMode(true)
      houselist._bidButton:addInputEvent("Mouse_LUp", "HandleClickedAuctionBidHouse(" .. index .. ")")
      houselist._styleBG:AddChild(auctionHouseDescFrame[index].Frame, true, false)
      Panel_Auction:RemoveControl(auctionHouseDescFrame[index].Frame)
      auctionHouseDescFrame[index].FrameContent:AddChild(houselist._styleArea, true, false)
      auctionHouseDescFrame[index].FrameContent:AddChild(houselist._styleSpecialService, true, false)
      houselist._styleBG:RemoveControl(houselist._styleArea)
      houselist._styleBG:RemoveControl(houselist._styleSpecialService)
      houselist._styleArea:SetPosX(5)
      houselist._styleArea:SetPosY(5)
      houselist._styleSpecialService:SetPosX(5)
      houselist._styleSpecialService:SetPosY(20)
      auctionHouseDescFrame[index].Frame:SetPosX(190)
      auctionHouseDescFrame[index].Frame:SetPosY(30)
      self._houseAuctionList[index] = houselist
    end
  end
  Panel_Auction:RemoveControl(styleBG)
  Panel_Auction:RemoveControl(cancelButton)
  Panel_Auction:RemoveControl(bidButton)
  Panel_Auction:RemoveControl(name)
  Panel_Auction:RemoveControl(nowPrice)
  Panel_Auction:RemoveControl(aucPrice)
  Panel_Auction:RemoveControl(myPrice)
  Panel_Auction:RemoveControl(editInGold)
  Panel_Auction:RemoveControl(money)
  Panel_Auction:RemoveControl(styleImage)
  Panel_Auction:RemoveControl(styleTime)
  Panel_Auction:RemoveControl(styleArea)
  Panel_Auction:RemoveControl(styleSpecialService)
end
function HouseAuctionTab()
  local self = HouseAuctionManager
  return false
end
function HandleClickedAuctionBidHouse(index)
  local price = HouseAuctionManager._houseAuctionList[index]._editInGold:GetEditNumber()
  local self = RequestGetAuctionInfo()
  local houseAuctionNowPrice = self:getHouseAuctionListAt(index)
  for key, value in pairs(HouseAuctionManager._houseAuctionList) do
    value._editInGold:SetEditText("", true)
  end
  if price <= houseAuctionNowPrice:getHighPrice_s64() then
    ClearFocusEdit()
    RequestBidAuction(index, price)
  else
    ClearFocusEdit()
    RequestBidAuction(index, price)
    RequestBiddingPage()
  end
end
HouseAuctionManager:initialize()
function HouseAuctionManager:updateHouseList()
  local myAuctionInfo = RequestGetAuctionInfo()
  local houseCount = myAuctionInfo:getHouseAuctionListCount()
  for index = 0, 5 do
    if index < houseCount then
      self._houseAuctionList[index]._styleBG:SetShow(true)
      HouseAuctionManager:setHouseData(index)
    else
      self._houseAuctionList[index]._styleBG:SetShow(false)
    end
  end
end
function HouseAuctionManager:setHouseData(index)
  local myAuctionInfo = RequestGetAuctionInfo()
  local houseAuctionInfo = myAuctionInfo:getHouseAuctionListAt(index)
  self._houseAuctionList[index]._styleName:SetText(houseAuctionInfo:getGoodsName())
  self._houseAuctionList[index]._bidButton:SetShow(true)
  self._houseAuctionList[index]._cancelButton:SetShow(false)
  if houseAuctionInfo:getPrice_s64() <= houseAuctionInfo:getHighPrice_s64() then
    self._houseAuctionList[index]._nowPrice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_NOWPRICE") .. " " .. tostring(Uint64toUint32(houseAuctionInfo:getHighPrice_s64())) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_AUCTION_GOLDTEXT"))
  else
    self._houseAuctionList[index]._nowPrice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_NOWPRICE") .. " " .. tostring(Uint64toUint32(houseAuctionInfo:getPrice_s64())) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_AUCTION_GOLDTEXT"))
  end
  self._houseAuctionList[index]._aucPrice:SetShow(false)
  self._houseAuctionList[index]._myPrice:SetShow(true)
  self._houseAuctionList[index]._editInGold:SetShow(true)
  self._houseAuctionList[index]._money:SetShow(true)
  self._houseAuctionList[index]._styleImage:ChangeTextureInfoName(houseAuctionInfo:getGoodsScreenShotPath(0))
  self._houseAuctionList[index]._styleTime:SetText(auctionDisplayTime(houseAuctionInfo:getExpireTime_u64()))
  self._houseAuctionList[index]._styleArea:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_AREA") .. " " .. tostring(Uint64toUint32(houseAuctionInfo:getGoodsArea())))
  local featureText = houseAuctionInfo:getGoodsFeature1() .. houseAuctionInfo:getGoodsFeature2()
  self._houseAuctionList[index]._styleSpecialService:SetAutoResize(true)
  self._houseAuctionList[index]._styleSpecialService:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._houseAuctionList[index]._styleSpecialService:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_SPECIAL") .. " " .. featureText)
  auctionHouseDescFrame[index].FrameContent:SetSize(auctionHouseDescFrame[index].FrameContent:GetSizeX(), self._houseAuctionList[index]._styleSpecialService:GetTextSizeY())
  auctionHouseDescFrame[index].Frame:UpdateContentScroll()
  auctionHouseDescFrame[index].Frame:SetShow(true)
end
function HouseAuctionManager:updateBidList()
  local myAuctionInfo = RequestGetAuctionInfo()
  local bidCount = myAuctionInfo:getMyBidListCount()
  for index = 0, 5 do
    if index < bidCount then
      self._houseAuctionList[index]._styleBG:SetShow(true)
      HouseAuctionManager:setBidData(index)
    else
      self._houseAuctionList[index]._styleBG:SetShow(false)
    end
  end
end
function HouseAuctionManager:setBidData(index)
  local myAuctionInfo = RequestGetAuctionInfo()
  local bidAuctionInfo = myAuctionInfo:getMyBidListAt(index)
  local upperBidPrice = bidAuctionInfo:getUpperBidPrice_s64()
  local myBidPrice = bidAuctionInfo:getMyBidPrice_s64()
  if bidAuctionInfo:isAuctionEnd() then
    self._houseAuctionList[index]._cancelButton:SetShow(true)
    self._houseAuctionList[index]._cancelButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_RETURNMONEY"))
  elseif upperBidPrice <= myBidPrice then
    self._houseAuctionList[index]._cancelButton:SetShow(false)
  else
    self._houseAuctionList[index]._cancelButton:SetShow(true)
    self._houseAuctionList[index]._cancelButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_RETURNMONEY"))
  end
  self._houseAuctionList[index]._cancelButton:addInputEvent("Mouse_LUp", "HandleClickedAuctionCancelButton(" .. index .. ")")
  self._houseAuctionList[index]._styleName:SetText(bidAuctionInfo:getGoodsName())
  self._houseAuctionList[index]._bidButton:SetShow(false)
  self._houseAuctionList[index]._nowPrice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_NOWPRICE") .. tostring(Uint64toUint32(bidAuctionInfo:getUpperBidPrice_s64())) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_AUCTION_GOLDTEXT"))
  self._houseAuctionList[index]._aucPrice:SetShow(true)
  self._houseAuctionList[index]._aucPrice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_BIDPRICE") .. tostring(Uint64toUint32(bidAuctionInfo:getMyBidPrice_s64())) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_AUCTION_GOLDTEXT"))
  self._houseAuctionList[index]._myPrice:SetShow(false)
  self._houseAuctionList[index]._editInGold:SetShow(false)
  self._houseAuctionList[index]._money:SetShow(false)
  self._houseAuctionList[index]._styleImage:ChangeTextureInfoName(bidAuctionInfo:getGoodsScreenShotPath(0))
  self._houseAuctionList[index]._styleTime:SetText(auctionDisplayTime(bidAuctionInfo:getExpireTime_u64()))
  self._houseAuctionList[index]._styleArea:SetText(bidAuctionInfo:getGoodsArea())
  self._houseAuctionList[index]._styleArea:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_AREA") .. tostring(Uint64toUint32(bidAuctionInfo:getGoodsArea())))
  local featureText = bidAuctionInfo:getGoodsFeature1() .. bidAuctionInfo:getGoodsFeature2()
  self._houseAuctionList[index]._styleSpecialService:SetAutoResize(true)
  self._houseAuctionList[index]._styleSpecialService:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._houseAuctionList[index]._styleSpecialService:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_SPECIAL") .. featureText)
  auctionHouseDescFrame[index].FrameContent:SetSize(auctionHouseDescFrame[index].FrameContent:GetSizeX(), self._houseAuctionList[index]._styleSpecialService:GetTextSizeY())
  auctionHouseDescFrame[index].Frame:UpdateContentScroll()
  auctionHouseDescFrame[index].Frame:SetShow(true)
end
function HandleClickedAuctionCancelButton(index)
  RequestAuction_CancelGoods(index)
end
function FromClient_ResponseAuction_UpdateAuctionList()
  Panel_Auction:SetShow(true, true)
  local myAuctionInfo = RequestGetAuctionInfo()
  local auctionType = myAuctionInfo:getAuctionType()
  local houseListCount = myAuctionInfo:getHouseAuctionListCount()
  local bidListCount = myAuctionInfo:getMyBidListCount()
  local houseMaxCount = houseListCount / 6 + 1
  if tonumber(string.sub(houseMaxCount, 1, 1)) == myAuctionInfo:getCurrentPage() + 1 then
    buttonListRight:SetIgnore(true)
  else
    buttonListRight:SetIgnore(false)
  end
  if myAuctionInfo:getCurrentPage() + 1 == 1 then
    buttonListLeft:SetIgnore(true)
  end
  styleListCount:SetText(myAuctionInfo:getCurrentPage() + 1)
  if auctionType == 1 then
    myBidList:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_MYBID"))
    HouseAuctionManager:updateHouseList()
  elseif auctionType == 5 then
    myBidList:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_AUCTIONLIST"))
    HouseAuctionManager:updateBidList()
  end
end
