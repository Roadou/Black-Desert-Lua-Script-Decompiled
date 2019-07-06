Panel_Villa_Auction:SetShow(false)
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PP = CppEnums.PAUIMB_PRIORITY
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
Panel_Villa_Auction:setMaskingChild(true)
Panel_Villa_Auction:ActiveMouseEventEffect(true)
Panel_Villa_Auction:setGlassBackground(true)
Panel_Villa_Auction:RegisterShowEventFunc(true, "Panel_Villa_Auction_ShowAni()")
Panel_Villa_Auction:RegisterShowEventFunc(false, "Panel_Villa_Auction_HideAni()")
function Panel_Villa_Auction_ShowAni()
  UIAni.fadeInSCR_Down(Panel_Villa_Auction)
  local aniInfo1 = Panel_Villa_Auction:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_Villa_Auction:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Villa_Auction:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Villa_Auction:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Villa_Auction:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Villa_Auction:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_Villa_Auction_HideAni()
  Panel_Villa_Auction:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Villa_Auction:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local Template = {
  BG = UI.getChildControl(Panel_Villa_Auction, "Template_Style_BG"),
  Area = UI.getChildControl(Panel_Villa_Auction, "Template_StaticText_Area"),
  Name = UI.getChildControl(Panel_Villa_Auction, "Template_StaticText_Name"),
  AucPrice = UI.getChildControl(Panel_Villa_Auction, "Template_StaticText_AucPrice"),
  MyPrice = UI.getChildControl(Panel_Villa_Auction, "Template_StaticText_MyPrice"),
  Edit_InGold = UI.getChildControl(Panel_Villa_Auction, "Template_Edit_InGold"),
  Btn_Cancel_Get = UI.getChildControl(Panel_Villa_Auction, "Template_Button_Cancel_Get"),
  Btn_Get = UI.getChildControl(Panel_Villa_Auction, "Template_Button_Get"),
  SpecialService = UI.getChildControl(Panel_Villa_Auction, "Template_StaticText_SpecialService"),
  RemainCount = UI.getChildControl(Panel_Villa_Auction, "Template_StaticText_RemainCount"),
  House_Image = UI.getChildControl(Panel_Villa_Auction, "Template_Static_Image"),
  Time = UI.getChildControl(Panel_Villa_Auction, "Template_StaticText_Time")
}
local VillaAuction = {
  panelBG = UI.getChildControl(Panel_Villa_Auction, "Static_BackGround"),
  panelTitle = UI.getChildControl(Panel_Villa_Auction, "StaticText_Title"),
  btn_MyBidList = UI.getChildControl(Panel_Villa_Auction, "Button_MyBidList"),
  btn_Win_Close = UI.getChildControl(Panel_Villa_Auction, "Button_Win_Close"),
  btn_Question = UI.getChildControl(Panel_Villa_Auction, "Button_Question"),
  btn_Page_Prv = UI.getChildControl(Panel_Villa_Auction, "Button_List_Left"),
  btn_Page_Next = UI.getChildControl(Panel_Villa_Auction, "Button_List_Right"),
  nowPage = UI.getChildControl(Panel_Villa_Auction, "StaticText_List"),
  auctionGuideBG = UI.getChildControl(Panel_Villa_Auction, "Static_BottomNoticeBG"),
  auctionGuide = UI.getChildControl(Panel_Villa_Auction, "StaticText_AutionGuide"),
  btn_myBidList = UI.getChildControl(Panel_Villa_Auction, "Button_MyBidList"),
  auctionHouseDescFrame = {}
}
function VillaAuction_InitControl()
  local self = VillaAuction
  self.auctionHouseDescFrame = {
    [0] = {
      Frame = UI.getChildControl(Panel_Villa_Auction, "Frame_1_AuctionDesc")
    },
    [1] = {
      Frame = UI.getChildControl(Panel_Villa_Auction, "Frame_2_AuctionDesc")
    },
    [2] = {
      Frame = UI.getChildControl(Panel_Villa_Auction, "Frame_3_AuctionDesc")
    },
    [3] = {
      Frame = UI.getChildControl(Panel_Villa_Auction, "Frame_4_AuctionDesc")
    }
  }
  self.auctionHouseDescFrame[0].FrameContent = UI.getChildControl(self.auctionHouseDescFrame[0].Frame, "Frame_1_AuctionDesc_Content")
  self.auctionHouseDescFrame[1].FrameContent = UI.getChildControl(self.auctionHouseDescFrame[1].Frame, "Frame_2_AuctionDesc_Content")
  self.auctionHouseDescFrame[2].FrameContent = UI.getChildControl(self.auctionHouseDescFrame[2].Frame, "Frame_3_AuctionDesc_Content")
  self.auctionHouseDescFrame[3].FrameContent = UI.getChildControl(self.auctionHouseDescFrame[3].Frame, "Frame_4_AuctionDesc_Content")
  self.btn_Win_Close:addInputEvent("Mouse_LUp", "FGlobal_VillaAuctionWindow_Hide()")
  self.btn_Question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"HouseAuction\" )")
  self.btn_Question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"HouseAuction\", \"true\")")
  self.btn_Question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"HouseAuction\", \"false\")")
  self.btn_MyBidList:addInputEvent("Mouse_LUp", "HandleClicked_VillaAuctionPageChange()")
end
local VillaAuctionManager = {
  _houseAuctionList = {}
}
local startX = 5
local startY = 40
local gapX = 10
local gapY = 10
local sizeX = 450
local sizeY = 190
local maxXCount = 2
local maxYCount = 2
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
function HandleClicked_VillaAuctionPageChange()
  local myAuctionInfo = RequestGetAuctionInfo()
  local auctionType = myAuctionInfo:getAuctionType()
  for key, value in pairs(VillaAuctionManager._houseAuctionList) do
    value._editInGold:SetEditText("", true)
  end
  ClearFocusEdit()
  if auctionType == 14 then
    RequestBiddingPage()
    VillaAuction.panelTitle:SetText("\235\130\180 \235\185\140\235\157\188 \236\158\133\236\176\176 \235\170\169\235\161\157")
  elseif auctionType == 5 then
    RequestAuctionListPage()
    VillaAuction.panelTitle:SetText("\235\185\140\235\157\188 \234\178\189\235\167\164")
  end
end
VillaAuction.btn_Page_Prv:addInputEvent("Mouse_LUp", "HandleClickedAuctionPrevButtonVilla()")
function HandleClickedAuctionPrevButtonVilla()
  for key, value in pairs(VillaAuctionManager._houseAuctionList) do
    value._editInGold:SetEditText("", true)
  end
  ClearFocusEdit()
  RequestAuctionPrevPage()
end
VillaAuction.btn_Page_Next:addInputEvent("Mouse_LUp", "HandleClickedAuctionNextButton()")
function HandleClickedAuctionNextButton()
  local myAuctionInfo = RequestGetAuctionInfo()
  local houseCount = myAuctionInfo:getHouseAuctionListCount()
  if houseCount >= 4 then
    for key, value in pairs(VillaAuctionManager._houseAuctionList) do
      value._editInGold:SetEditText("", true)
    end
    ClearFocusEdit()
    RequestAuctionNextPage()
  end
end
function FGlobal_VillaAuctionWindow_Hide()
  local isShow = Panel_Villa_Auction:IsShow()
  if isShow == true then
    Panel_Villa_Auction:SetShow(false, false)
  end
end
function FGlobal_VillaAuctionWindow_Show()
  local isShow = Panel_Villa_Auction:IsShow()
  if isShow == false then
    UIAni.fadeInSCR_Down(Panel_Villa_Auction)
    Panel_Villa_Auction:SetShow(true, true)
  end
end
function VillaAuctionManager:initialize()
  for y = 0, maxYCount - 1 do
    for x = 0, maxXCount - 1 do
      local index = y * maxXCount + x
      local houselist = {}
      houselist._bg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Villa_Auction, "Style_BG_" .. index)
      houselist._area = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._bg, "StaticText_Area_" .. index)
      houselist._name = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._bg, "StaticText_Name_" .. index)
      houselist._aucPrice = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._bg, "StaticText_AucPrice_" .. index)
      houselist._myPrice = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._bg, "StaticText_MyPrice_" .. index)
      houselist._editInGold = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_EDIT, houselist._bg, "Edit_InGold_" .. index)
      houselist._btn_Cancel_Get = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, houselist._bg, "Button_Cancel_Get_" .. index)
      houselist._btn_Get = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, houselist._bg, "Button_Get_" .. index)
      houselist._specialService = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._bg, "StaticText_SpecialService_" .. index)
      houselist._remainCount = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._bg, "StaticText_RemainCount_" .. index)
      houselist._house_Image = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, houselist._bg, "Static_Image_" .. index)
      houselist._aucRemainTime = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, houselist._bg, "StaticText_Time_" .. index)
      CopyBaseProperty(Template.BG, houselist._bg)
      CopyBaseProperty(Template.Area, houselist._area)
      CopyBaseProperty(Template.Name, houselist._name)
      CopyBaseProperty(Template.AucPrice, houselist._aucPrice)
      CopyBaseProperty(Template.MyPrice, houselist._myPrice)
      CopyBaseProperty(Template.Edit_InGold, houselist._editInGold)
      CopyBaseProperty(Template.Btn_Cancel_Get, houselist._btn_Cancel_Get)
      CopyBaseProperty(Template.Btn_Get, houselist._btn_Get)
      CopyBaseProperty(Template.SpecialService, houselist._specialService)
      CopyBaseProperty(Template.RemainCount, houselist._remainCount)
      CopyBaseProperty(Template.House_Image, houselist._house_Image)
      CopyBaseProperty(Template.Time, houselist._aucRemainTime)
      houselist._bg:SetPosX(x * sizeX + startX + x * gapX)
      houselist._bg:SetPosY(y * sizeY + startY + y * gapY)
      houselist._bg:SetShow(true)
      houselist._area:SetShow(true)
      houselist._specialService:SetShow(true)
      houselist._name:SetShow(true)
      houselist._aucPrice:SetShow(true)
      houselist._myPrice:SetShow(true)
      houselist._editInGold:SetShow(true)
      houselist._editInGold:SetNumberMode(true)
      houselist._editInGold:SetMaxInput(12)
      houselist._btn_Cancel_Get:SetShow(false)
      houselist._btn_Get:SetShow(true)
      houselist._remainCount:SetShow(true)
      houselist._house_Image:SetShow(true)
      houselist._aucRemainTime:SetShow(true)
      houselist._btn_Get:addInputEvent("Mouse_LUp", "HandleClickedAuctionBidVilla(" .. index .. ")")
      houselist._bg:AddChild(VillaAuction.auctionHouseDescFrame[index].Frame, true, false)
      Panel_Villa_Auction:RemoveControl(VillaAuction.auctionHouseDescFrame[index].Frame)
      VillaAuction.auctionHouseDescFrame[index].FrameContent:AddChild(houselist._area, true, false)
      VillaAuction.auctionHouseDescFrame[index].FrameContent:AddChild(houselist._specialService, true, false)
      houselist._bg:RemoveControl(houselist._area)
      houselist._bg:RemoveControl(houselist._specialService)
      VillaAuction.auctionHouseDescFrame[index].Frame:SetPosX(190)
      VillaAuction.auctionHouseDescFrame[index].Frame:SetPosY(30)
      self._houseAuctionList[index] = houselist
    end
  end
  Panel_Villa_Auction:RemoveControl(Template.BG)
  Panel_Villa_Auction:RemoveControl(Template.Area)
  Panel_Villa_Auction:RemoveControl(Template.Name)
  Panel_Villa_Auction:RemoveControl(Template.AucPrice)
  Panel_Villa_Auction:RemoveControl(Template.MyPrice)
  Panel_Villa_Auction:RemoveControl(Template.Edit_InGold)
  Panel_Villa_Auction:RemoveControl(Template.Btn_Cancel_Get)
  Panel_Villa_Auction:RemoveControl(Template.Btn_Get)
  Panel_Villa_Auction:RemoveControl(Template.SpecialService)
  Panel_Villa_Auction:RemoveControl(Template.RemainCount)
  Panel_Villa_Auction:RemoveControl(Template.House_Image)
  Panel_Villa_Auction:RemoveControl(Template.Time)
end
function HandleClickedAuctionBidVilla(index)
  local price = VillaAuctionManager._houseAuctionList[index]._editInGold:GetEditNumber()
  local myAuctionInfo = RequestGetAuctionInfo()
  local houseAuctionNowPrice = myAuctionInfo:getHouseAuctionListAt(index)
  for key, value in pairs(VillaAuctionManager._houseAuctionList) do
    value._editInGold:SetEditText("", true)
  end
  if price >= houseAuctionNowPrice:getPrice_s64() then
    ClearFocusEdit()
    RequestBidAuction(index, price)
  else
    ClearFocusEdit()
    RequestBidAuction(index, price)
    RequestAuctionListPage()
  end
end
function VillaAuctionManager:updateHouseList()
  local myAuctionInfo = RequestGetAuctionInfo()
  local houseCount = myAuctionInfo:getHouseAuctionListCount()
  for index = 0, 3 do
    if index < houseCount then
      self._houseAuctionList[index]._bg:SetShow(true)
      VillaAuctionManager:setHouseData(index)
    else
      self._houseAuctionList[index]._bg:SetShow(false)
    end
  end
end
function VillaAuctionManager:setHouseData(index)
  local myAuctionInfo = RequestGetAuctionInfo()
  local houseAuctionInfo = myAuctionInfo:getHouseAuctionListAt(index)
  self._houseAuctionList[index]._name:SetText(houseAuctionInfo:getGoodsName())
  self._houseAuctionList[index]._btn_Get:SetShow(true)
  self._houseAuctionList[index]._btn_Cancel_Get:SetShow(false)
  self._houseAuctionList[index]._aucPrice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDHOUSE_AUCTION_LOWPRICE") .. makeDotMoney(Uint64toUint32(houseAuctionInfo:getPrice_s64())) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_AUCTION_GOLDTEXT"))
  self._houseAuctionList[index]._myPrice:SetShow(true)
  self._houseAuctionList[index]._editInGold:SetShow(true)
  self._houseAuctionList[index]._house_Image:ChangeTextureInfoName(houseAuctionInfo:getGoodsScreenShotPath(0))
  self._houseAuctionList[index]._aucRemainTime:SetText(auctionDisplayTime(houseAuctionInfo:getExpireTime_u64()))
  self._houseAuctionList[index]._area:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_AREA") .. " " .. tostring(Uint64toUint32(houseAuctionInfo:getGoodsArea())))
  local featureText = houseAuctionInfo:getGoodsFeature1() .. houseAuctionInfo:getGoodsFeature2()
  self._houseAuctionList[index]._specialService:SetAutoResize(true)
  self._houseAuctionList[index]._specialService:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._houseAuctionList[index]._specialService:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_SPECIAL") .. " " .. featureText)
  self._houseAuctionList[index]._remainCount:SetShow(false)
  VillaAuction.auctionHouseDescFrame[index].FrameContent:SetSize(VillaAuction.auctionHouseDescFrame[index].FrameContent:GetSizeX(), self._houseAuctionList[index]._specialService:GetTextSizeY())
  VillaAuction.auctionHouseDescFrame[index].Frame:UpdateContentScroll()
  VillaAuction.auctionHouseDescFrame[index].Frame:SetShow(true)
end
function VillaAuctionManager:updateBidList()
  local myAuctionInfo = RequestGetAuctionInfo()
  local bidCount = myAuctionInfo:getMyBidListCount()
  for index = 0, 3 do
    if index < bidCount then
      self._houseAuctionList[index]._bg:SetShow(true)
      VillaAuctionManager:setBidData(index)
    else
      self._houseAuctionList[index]._bg:SetShow(false)
    end
  end
end
function VillaAuctionManager:setBidData(index)
  local myAuctionInfo = RequestGetAuctionInfo()
  local bidAuctionInfo = myAuctionInfo:getMyBidListAt(index)
  local upperBidPrice = bidAuctionInfo:getUpperBidPrice_s64()
  local myBidPrice = bidAuctionInfo:getMyBidPrice_s64()
  if bidAuctionInfo:isAuctionEnd() then
    self._houseAuctionList[index]._btn_Cancel_Get:SetShow(true)
    self._houseAuctionList[index]._btn_Cancel_Get:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_RETURNMONEY"))
  elseif upperBidPrice <= myBidPrice then
    self._houseAuctionList[index]._btn_Cancel_Get:SetShow(false)
  else
    self._houseAuctionList[index]._btn_Cancel_Get:SetShow(true)
    self._houseAuctionList[index]._btn_Cancel_Get:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_RETURNMONEY"))
  end
  self._houseAuctionList[index]._btn_Cancel_Get:addInputEvent("Mouse_LUp", "HandleClickedAuctionCancelButton(" .. index .. ")")
  self._houseAuctionList[index]._name:SetText(bidAuctionInfo:getGoodsName())
  self._houseAuctionList[index]._btn_Get:SetShow(false)
  self._houseAuctionList[index]._aucPrice:SetShow(true)
  self._houseAuctionList[index]._aucPrice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_BIDPRICE") .. makeDotMoney(Uint64toUint32(bidAuctionInfo:getMyBidPrice_s64())) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_AUCTION_GOLDTEXT"))
  self._houseAuctionList[index]._myPrice:SetShow(false)
  self._houseAuctionList[index]._editInGold:SetShow(false)
  self._houseAuctionList[index]._house_Image:ChangeTextureInfoName(bidAuctionInfo:getGoodsScreenShotPath(0))
  self._houseAuctionList[index]._aucRemainTime:SetText(auctionDisplayTime(bidAuctionInfo:getExpireTime_u64()))
  self._houseAuctionList[index]._area:SetText(bidAuctionInfo:getGoodsArea())
  self._houseAuctionList[index]._area:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_AREA") .. tostring(Uint64toUint32(bidAuctionInfo:getGoodsArea())))
  local featureText = bidAuctionInfo:getGoodsFeature1() .. bidAuctionInfo:getGoodsFeature2()
  self._houseAuctionList[index]._specialService:SetAutoResize(true)
  self._houseAuctionList[index]._specialService:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._houseAuctionList[index]._specialService:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_SPECIAL") .. featureText)
  self._houseAuctionList[index]._remainCount:SetShow(true)
  self._houseAuctionList[index]._remainCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDHOUSE_AUCTION_REMAININGCOUNT", "getRemainBidCount", tostring(bidAuctionInfo:getRemainBidCount())))
  VillaAuction.auctionHouseDescFrame[index].FrameContent:SetSize(VillaAuction.auctionHouseDescFrame[index].FrameContent:GetSizeX(), self._houseAuctionList[index]._specialService:GetTextSizeY())
  VillaAuction.auctionHouseDescFrame[index].Frame:UpdateContentScroll()
  VillaAuction.auctionHouseDescFrame[index].Frame:SetShow(true)
end
function HandleClickedAuctionCancelButton(index)
  RequestAuction_CancelGoods(index)
end
registerEvent("FromClient_ResponseAuction_UpdateAuctionList", "FromClient_ResponseAuction_UpdateVillaAuctionList()")
function FromClient_ResponseAuction_UpdateVillaAuctionList()
  local myAuctionInfo = RequestGetAuctionInfo()
  local auctionType = myAuctionInfo:getAuctionType()
  local houseListCount = myAuctionInfo:getHouseAuctionListCount()
  local bidListCount = myAuctionInfo:getMyBidListCount()
  local houseMaxCount = houseListCount / 4 + 1
  if tonumber(string.sub(houseMaxCount, 1, 1)) == myAuctionInfo:getCurrentPage() + 1 then
    VillaAuction.btn_Page_Next:SetIgnore(true)
  else
    VillaAuction.btn_Page_Next:SetIgnore(false)
  end
  if myAuctionInfo:getCurrentPage() + 1 == 1 then
    VillaAuction.btn_Page_Prv:SetIgnore(true)
  else
    VillaAuction.btn_Page_Prv:SetIgnore(false)
  end
  VillaAuction.nowPage:SetText(myAuctionInfo:getCurrentPage() + 1)
  if auctionType == 14 then
    Panel_Villa_Auction:SetShow(true, true)
    VillaAuction.btn_MyBidList:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_MYBID"))
    VillaAuctionManager:updateHouseList()
  elseif auctionType == 5 then
    VillaAuction.btn_MyBidList:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_AUCTIONLIST"))
    VillaAuctionManager:updateBidList()
  end
end
function FGlobal_VillaAuctionUpdate()
  VillaAuctionManager:updateHouseList()
end
VillaAuction_InitControl()
VillaAuctionManager:initialize()
