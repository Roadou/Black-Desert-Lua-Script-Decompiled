Panel_Login:SetShow(false, false)
Panel_Login:SetSize(getScreenSizeX(), getScreenSizeY())
Panel_Login:SetShow(false, false)
local _loginBG = UI.getChildControl(Panel_Login, "Static_LoginBG")
local _buttonBG = UI.getChildControl(Panel_Login, "Static_ButtonBG")
local _txt_Guide = UI.getChildControl(Panel_Login, "StaticText_InputTxt")
local Button_Login = UI.getChildControl(Panel_Login, "Button_Login")
local Button_Exit = UI.getChildControl(Panel_Login, "Button_Exit")
local Button_GameOption = UI.getChildControl(Panel_Login, "Button_GameOption_Login")
local Edit_ID = UI.getChildControl(Panel_Login, "Edit_ID")
local _blackStone = UI.getChildControl(Panel_Login, "Static_BlackStone")
local StaticEventBG = UI.getChildControl(Panel_Login, "Static_EventBG")
local Static_BI = UI.getChildControl(Panel_Login, "Static_BI")
local Static_Blackline_up = UI.getChildControl(Panel_Login, "Static_Blackline_up")
local Static_Blackline_down = UI.getChildControl(Panel_Login, "Static_Blackline_down")
local Static_CI = UI.getChildControl(Panel_Login, "Static_CI")
local Static_DaumCI = UI.getChildControl(Panel_Login, "Static_DaumCI")
Button_Login:ActiveMouseEventEffect(true)
Button_Exit:ActiveMouseEventEffect(true)
Button_GameOption:ActiveMouseEventEffect(true)
Button_Login:SetEnable(true)
Button_Exit:SetEnable(true)
Button_GameOption:SetEnable(true)
StaticEventBG:SetShow(false)
Panel_Login:SetShow(true, false)
local screenX = getScreenSizeX()
local screenY = getScreenSizeY()
Static_Back = Array.new()
local bgItem = {
  "base",
  "calpeon",
  "media",
  "valencia",
  "sea",
  "kamasilvia",
  "kamasilvia2",
  "dragan",
  "xmas",
  "halloween",
  "thanksGivingDay",
  "aurora",
  "KoreaOnly",
  "JapanOnly",
  "RussiaOnly",
  "NaOnly",
  "TaiwanOnly",
  "TROnly",
  "THOnly",
  "KR2Only",
  "SAOnly",
  "TROnly",
  "THOnly",
  "IDOnly"
}
local bgIndex = {}
for k, v in pairs(bgItem) do
  bgIndex[v] = k
end
local baseLink = "New_UI_Common_forLua/Window/Lobby/"
local bgManager = {
  [bgIndex.base] = {
    isOpen = true,
    imageCount = 3,
    iconPath = "bgBase_"
  },
  [bgIndex.calpeon] = {
    isOpen = ToClient_IsContentsGroupOpen("2"),
    imageCount = 6,
    iconPath = "bgCalpeon_"
  },
  [bgIndex.media] = {
    isOpen = ToClient_IsContentsGroupOpen("3"),
    imageCount = 2,
    iconPath = "bgMedia_"
  },
  [bgIndex.valencia] = {
    isOpen = ToClient_IsContentsGroupOpen("4"),
    imageCount = 6,
    iconPath = "bgValencia_"
  },
  [bgIndex.sea] = {
    isOpen = ToClient_IsContentsGroupOpen("83"),
    imageCount = 3,
    iconPath = "bgValenciaSea_"
  },
  [bgIndex.kamasilvia] = {
    isOpen = ToClient_IsContentsGroupOpen("5"),
    imageCount = 7,
    iconPath = "bgKamasilvia_"
  },
  [bgIndex.kamasilvia2] = {
    isOpen = ToClient_IsContentsGroupOpen("260"),
    imageCount = 2,
    iconPath = "bgKamasilvia2_"
  },
  [bgIndex.dragan] = {
    isOpen = ToClient_IsContentsGroupOpen("6"),
    imageCount = 3,
    iconPath = "bgDragan_"
  },
  [bgIndex.xmas] = {
    isOpen = ToClient_isEventOn("x-mas"),
    imageCount = 1,
    iconPath = "bgXmas_"
  },
  [bgIndex.halloween] = {
    isOpen = ToClient_isEventOn("Halloween"),
    imageCount = 3,
    iconPath = "bgHalloween_"
  },
  [bgIndex.thanksGivingDay] = {
    isOpen = ToClient_isEventOn("ThanksGivingDay"),
    imageCount = 2,
    iconPath = "bgThanksGivingDay_"
  },
  [bgIndex.aurora] = {
    isOpen = ToClient_isEventOn("Aurora"),
    imageCount = 2,
    iconPath = "bgAurora_"
  },
  [bgIndex.KoreaOnly] = {
    isOpen = isGameTypeKorea() and false,
    imageCount = 0,
    iconPath = "bgKoreaOnly_"
  },
  [bgIndex.JapanOnly] = {
    isOpen = isGameTypeJapan() and false,
    imageCount = 2,
    iconPath = "bgJapanOnly_"
  },
  [bgIndex.RussiaOnly] = {
    isOpen = isGameTypeRussia() and false,
    imageCount = 0,
    iconPath = "bgRussiaOnly_"
  },
  [bgIndex.NaOnly] = {
    isOpen = isGameTypeEnglish() and false,
    imageCount = 4,
    iconPath = "bgNAOnly_"
  },
  [bgIndex.TaiwanOnly] = {
    isOpen = isGameTypeTaiwan() and false,
    imageCount = 0,
    iconPath = "bgTaiwanOnly_"
  },
  [bgIndex.TROnly] = {
    isOpen = isGameTypeTR() and false,
    imageCount = 0,
    iconPath = "bgTROnly_"
  },
  [bgIndex.THOnly] = {
    isOpen = isGameTypeTH() and false,
    imageCount = 0,
    iconPath = "bgTHOnly_"
  },
  [bgIndex.KR2Only] = {
    isOpen = isGameTypeKR2() and false,
    imageCount = 0,
    iconPath = "bgKR2Only_"
  },
  [bgIndex.SAOnly] = {
    isOpen = isGameTypeSA() and false,
    imageCount = 0,
    iconPath = "bgSAOnly_"
  },
  [bgIndex.TROnly] = {
    isOpen = isGameTypeTR() and false,
    imageCount = 0,
    iconPath = "bgTROnly_"
  },
  [bgIndex.THOnly] = {
    isOpen = isGameTypeTH() and false,
    imageCount = 0,
    iconPath = "bgTHOnly_"
  },
  [bgIndex.IDOnly] = {
    isOpen = isGameTypeID() and false,
    imageCount = 0,
    iconPath = "bgIDOnly_"
  }
}
local totalBG = 0
local imageIndex = 1
local startIndex, endIndex
local tempBg = UI.getChildControl(Panel_Login, "bgBase_1")
for _, value in ipairs(bgManager) do
  if value.isOpen then
    totalBG = totalBG + value.imageCount
    if value.imageCount > 0 then
      startIndex = imageIndex
      for index = 1, value.imageCount do
        local targetControl = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Login, "Static_Bg_" .. imageIndex)
        CopyBaseProperty(tempBg, targetControl)
        targetControl:ChangeTextureInfoName(baseLink .. value.iconPath .. index .. ".dds")
        targetControl:SetSize(screenX, screenY)
        targetControl:SetPosX(0)
        targetControl:SetPosY(0)
        targetControl:SetAlpha(0)
        Panel_Login:SetChildIndex(targetControl, 0)
        Static_Back[imageIndex] = targetControl
        endIndex = imageIndex
        imageIndex = imageIndex + 1
      end
    end
  end
end
tempBg:SetShow(false)
local bgStartIndex = startIndex
if false == isLoginIDShow() then
  Edit_ID:SetShow(false)
  _loginBG:SetShow(false)
  _txt_Guide:SetShow(false)
else
  Edit_ID:SetEditText(getLoginID())
end
function Panel_Login_Enter()
  connectToGame(Edit_ID:GetEditText(), "\234\178\128\236\157\128\236\160\132\236\130\172\235\185\132\235\178\136")
end
function FGlobal_Panel_Login_Enter()
  Panel_Login_Enter()
end
function LogInPanel_Resize()
  Panel_Login:SetSize(getScreenSizeX(), getScreenSizeY())
  _loginBG:ComputePos()
  _buttonBG:ComputePos()
  _txt_Guide:ComputePos()
  Button_Login:ComputePos()
  Button_Login:AddEffect("fUI_PvPButtonLoop", true, 0, 0)
  Button_Exit:ComputePos()
  Button_GameOption:ComputePos()
  Edit_ID:ComputePos()
  for ii = 1, totalBG do
    Static_Back[ii]:SetSize(getScreenSizeX(), getScreenSizeY())
  end
  Static_Blackline_up:SetSize(getScreenSizeX(), getScreenSizeY() * 0.07)
  Static_Blackline_down:SetSize(getScreenSizeX(), getScreenSizeY() * 0.07)
  if isGameTypeJapan() then
    Static_DaumCI:SetSize(111, 26)
    Static_DaumCI:ChangeTextureInfoName("new_ui_common_forlua/window/lobby/login_CI_Daum.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(Static_DaumCI, 0, 0, 111, 26)
    Static_DaumCI:getBaseTexture():setUV(x1, y1, x2, y2)
    Static_DaumCI:setRenderTexture(Static_DaumCI:getBaseTexture())
    Static_CI:SetSpanSize(Static_DaumCI:GetSizeX() + 30, (Static_Blackline_down:GetSizeY() - Static_CI:GetSizeY()) / 2)
  elseif isGameTypeEnglish() then
    Static_DaumCI:SetSize(144, 26)
    Static_DaumCI:ChangeTextureInfoName("new_ui_common_forlua/window/lobby/login_CI_Daum.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(Static_DaumCI, 0, 0, 144, 26)
    Static_DaumCI:getBaseTexture():setUV(x1, y1, x2, y2)
    Static_DaumCI:setRenderTexture(Static_DaumCI:getBaseTexture())
    Static_CI:SetSpanSize(Static_DaumCI:GetSizeX() + 30, (Static_Blackline_down:GetSizeY() - Static_CI:GetSizeY()) / 2)
  elseif isGameTypeTaiwan() or isGameTypeTR() or isGameTypeTH() or isGameTypeID() or ToClient_isConsole() or isGameTypeGT() or isGameTypeRussia() then
    Static_DaumCI:SetShow(false)
    Static_CI:SetSpanSize(10, (Static_Blackline_down:GetSizeY() - Static_CI:GetSizeY()) / 2)
  elseif isGameTypeSA() then
    Static_DaumCI:SetSize(136, 50)
    Static_DaumCI:ChangeTextureInfoName("new_ui_common_forlua/window/lobby/login_CI_Daum.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(Static_DaumCI, 0, 0, 136, 50)
    Static_DaumCI:getBaseTexture():setUV(x1, y1, x2, y2)
    Static_DaumCI:setRenderTexture(Static_DaumCI:getBaseTexture())
    Static_CI:SetSpanSize(Static_DaumCI:GetSizeX() + 30, (Static_Blackline_down:GetSizeY() - Static_CI:GetSizeY()) / 2)
  elseif isGameTypeKR2() then
    Static_DaumCI:SetSize(95, 53)
    Static_DaumCI:ChangeTextureInfoName("new_ui_common_forlua/window/lobby/login_CI_Daum.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(Static_DaumCI, 0, 0, 95, 53)
    Static_DaumCI:getBaseTexture():setUV(x1, y1, x2, y2)
    Static_DaumCI:setRenderTexture(Static_DaumCI:getBaseTexture())
    Static_CI:SetSpanSize(Static_DaumCI:GetSizeX() + 30, (Static_Blackline_down:GetSizeY() - Static_CI:GetSizeY()) / 2)
  else
    Static_DaumCI:SetSize(144, 26)
    Static_DaumCI:ChangeTextureInfoName("new_ui_common_forlua/window/lobby/login_CI_Daum.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(Static_DaumCI, 0, 0, 144, 26)
    Static_DaumCI:getBaseTexture():setUV(x1, y1, x2, y2)
    Static_DaumCI:setRenderTexture(Static_DaumCI:getBaseTexture())
    Static_CI:SetSpanSize(Static_DaumCI:GetSizeX() + 30, (Static_Blackline_down:GetSizeY() - Static_CI:GetSizeY()) / 2)
  end
  Static_DaumCI:SetSpanSize(20, (Static_Blackline_down:GetSizeY() - Static_DaumCI:GetSizeY()) / 2)
  StaticEventBG:SetShow(false)
  StaticEventBG:ComputePos()
  Static_BI:ComputePos()
  Static_Blackline_up:ComputePos()
  Static_Blackline_down:ComputePos()
  Static_CI:ComputePos()
  Static_DaumCI:ComputePos()
  Static_BI:SetPosY(getScreenSizeY() * 0.14)
  PaGlobal_CheckGamerTag()
end
local currentBackIndex = bgStartIndex
Static_Back[currentBackIndex]:SetShow(true, true)
Static_Back[currentBackIndex]:SetAlpha(1)
local updateTime = 0
local isScope = true
local startUV = 0.1
local endUV = startUV + 0.04
local startUV2 = 0.9
local endUV2 = startUV2 + 0.04
function Panel_Login_Update(deltaTime)
  updateTime = updateTime - deltaTime
  if updateTime <= 0 then
    updateTime = 15
    if isScope then
      isScope = false
      local FadeMaskAni = Static_Back[currentBackIndex]:addTextureUVAnimation(0, 15, 0)
      FadeMaskAni:SetStartUV(startUV, startUV, 0)
      FadeMaskAni:SetEndUV(endUV, startUV, 0)
      FadeMaskAni:SetStartUV(startUV2, startUV, 1)
      FadeMaskAni:SetEndUV(endUV2, startUV, 1)
      FadeMaskAni:SetStartUV(startUV, startUV2, 2)
      FadeMaskAni:SetEndUV(endUV, startUV2, 2)
      FadeMaskAni:SetStartUV(startUV2, startUV2, 3)
      FadeMaskAni:SetEndUV(endUV2, startUV2, 3)
    else
      isScope = true
      local FadeMaskAni = Static_Back[currentBackIndex]:addTextureUVAnimation(0, 15, 0)
      FadeMaskAni:SetEndUV(startUV, startUV, 0)
      FadeMaskAni:SetStartUV(endUV, startUV, 0)
      FadeMaskAni:SetEndUV(startUV2, startUV, 1)
      FadeMaskAni:SetStartUV(endUV2, startUV, 1)
      FadeMaskAni:SetEndUV(startUV, startUV2, 2)
      FadeMaskAni:SetStartUV(endUV, startUV2, 2)
      FadeMaskAni:SetEndUV(startUV2, startUV2, 3)
      FadeMaskAni:SetStartUV(endUV2, startUV2, 3)
      local fadeColor = Static_Back[currentBackIndex]:addColorAnimation(15, 17, 0)
      fadeColor:SetStartColor(Defines.Color.C_FFFFFFFF)
      fadeColor:SetEndColor(Defines.Color.C_00FFFFFF)
      currentBackIndex = currentBackIndex + 1
      if totalBG < currentBackIndex then
        currentBackIndex = getRandomValue(1, totalBG)
      end
      local baseTexture = Static_Back[currentBackIndex]:getBaseTexture()
      baseTexture:setUV(startUV, startUV, startUV2, startUV2)
      Static_Back[currentBackIndex]:setRenderTexture(baseTexture)
      local fadeColor2 = Static_Back[currentBackIndex]:addColorAnimation(12, 15, 0)
      fadeColor2:SetStartColor(Defines.Color.C_00FFFFFF)
      fadeColor2:SetEndColor(Defines.Color.C_FFFFFFFF)
    end
  end
  if ToClient_isConsole() and isPadUp(__eJoyPadInputType_A) then
    PaGlobal_Policy_Close()
  end
end
function Panel_Login_ButtonDisable(bool)
  if true == bool then
    Button_Login:SetEnable(false)
    Button_Login:SetMonoTone(true)
    Button_Login:SetIgnore(true)
    Button_Exit:SetEnable(false)
    Button_Exit:SetMonoTone(true)
    Button_Exit:SetIgnore(true)
    Button_GameOption:SetEnable(false)
    Button_GameOption:SetMonoTone(true)
    Button_GameOption:SetIgnore(true)
  else
    Button_Login:SetEnable(true)
    Button_Login:SetMonoTone(false)
    Button_Login:SetIgnore(false)
    Button_Exit:SetEnable(true)
    Button_Exit:SetMonoTone(false)
    Button_Exit:SetIgnore(false)
    Button_GameOption:SetEnable(true)
    Button_GameOption:SetMonoTone(false)
    Button_GameOption:SetIgnore(false)
  end
end
function Panel_Login_BeforOpen()
  local serviceType = getGameServiceType()
  if (isGameTypeTaiwan() or isGameTypeGT() or isGameTypeKorea()) and 1 ~= serviceType then
    FGlobal_TermsofGameUse_Open()
  else
    Panel_Login_Enter()
  end
end
Panel_Login:RegisterUpdateFunc("Panel_Login_Update")
Button_Login:addInputEvent("Mouse_LUp", "Panel_Login_BeforOpen()")
Button_Exit:addInputEvent("Mouse_LUp", "GlobalExitGameClient()")
Button_GameOption:addInputEvent("Mouse_LUp", "showGameOption()")
registerEvent("onScreenResize", "LogInPanel_Resize")
LogInPanel_Resize()
if ToClient_isConsole() then
  PaGlobal_Policy_ShowWindow(true)
end
