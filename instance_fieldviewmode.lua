local var_UI = {
  panel = Instance_FieldViewMode,
  btn_left = UI.getChildControl(Instance_FieldViewMode, "Button_Arrow_Left"),
  btn_right = UI.getChildControl(Instance_FieldViewMode, "Button_Arrow_Right"),
  btn_top = UI.getChildControl(Instance_FieldViewMode, "Button_Arrow_Top"),
  btn_bottom = UI.getChildControl(Instance_FieldViewMode, "Button_Arrow_Bottom"),
  btn_init = UI.getChildControl(Instance_FieldViewMode, "Button_Pos_Init"),
  btn_FreeSet1 = UI.getChildControl(Instance_FieldViewMode, "Button_FreeSet_1"),
  btn_FreeSet2 = UI.getChildControl(Instance_FieldViewMode, "Button_FreeSet_2"),
  btn_FreeSet3 = UI.getChildControl(Instance_FieldViewMode, "Button_FreeSet_3"),
  text_arrow = UI.getChildControl(Instance_FieldViewMode, "Button_TextManual"),
  bg_arrow = UI.getChildControl(Instance_FieldViewMode, "Static_ArrowBG"),
  text_preset = UI.getChildControl(Instance_FieldViewMode, "Button_TextPreset"),
  bg_preset = UI.getChildControl(Instance_FieldViewMode, "Static_PresetBG")
}
local constVar = {modifyRate = 5}
local variable = {isShow = false}
local fieldViewText = UI.getChildControl(Instance_FieldViewMode, "StaticText_viewModeText")
function FieldViewMode_ScreenResize()
  for _, v in pairs(var_UI) do
    v:ComputePos()
  end
end
function FieldViewMode_PushLeft()
  characterCameraModify(-constVar.modifyRate, 0)
end
function FieldViewMode_PushRight()
  characterCameraModify(constVar.modifyRate, 0)
end
function FieldViewMode_PushTop()
  characterCameraModify(0, constVar.modifyRate)
end
function FieldViewMode_PushBottom()
  characterCameraModify(0, -constVar.modifyRate)
end
function FieldViewMode_PushReset()
  characterCameraReset()
end
function FieldViewMode_PushFreeSet(number)
  local x, y, wheel, distance
  if 1 == number then
    x = 75
    y = -19
    wheel = 369.200378
    distance = 230
  elseif 2 == number then
    x = 100
    y = -19
    wheel = 196.40036
    distance = 400
  elseif 3 == number then
    x = -105
    y = -19
    wheel = 407.600433
    distance = 800
  elseif 4 == number then
    x = 0
    y = 0
    wheel = 369.200378
    distance = 230
  else
    return
  end
  characterCameraSetPosAndWheel(float2(x, y), wheel, distance)
end
function FieldViewMode_ShowToggle(isShow)
  if nil == isShow then
    variable.isShow = not variable.isShow
  else
    variable.isShow = isShow
  end
  if variable.isShow then
    var_UI.panel:SetShow(true)
  end
end
local function Alpha_Rate_Setting(alpha)
  for k, v in pairs(var_UI) do
    v:SetAlpha(alpha)
  end
  var_UI.btn_left:SetFontAlpha(alpha)
  var_UI.btn_right:SetFontAlpha(alpha)
  var_UI.btn_top:SetFontAlpha(alpha)
  var_UI.btn_bottom:SetFontAlpha(alpha)
  var_UI.btn_init:SetFontAlpha(alpha)
  var_UI.btn_FreeSet1:SetFontAlpha(alpha)
  var_UI.btn_FreeSet2:SetFontAlpha(alpha)
  var_UI.btn_FreeSet3:SetFontAlpha(alpha)
  var_UI.text_preset:SetFontAlpha(alpha)
  var_UI.text_arrow:SetFontAlpha(alpha)
end
function FieldViewMode_UpdateShowHide()
  local rate = 0.1
  if variable.isShow then
    local alpha = var_UI.panel:GetAlpha() + rate
    if alpha < 1 then
      Alpha_Rate_Setting(alpha)
    else
      Alpha_Rate_Setting(1)
    end
  else
    local alpha = var_UI.panel:GetAlpha() - rate
    if alpha > 0 then
      Alpha_Rate_Setting(alpha)
    else
      var_UI.panel:SetShow(false)
      Alpha_Rate_Setting(0)
    end
  end
end
function FieldViewMode_ChangeTexture_On()
  var_UI.panel:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
  fieldViewText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIELDVIEWMODE_UI_MOVE"))
end
function FieldViewMode_ChangeTexture_Off()
  if Panel_UIControl:IsShow() then
    var_UI.panel:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
    fieldViewText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIELDVIEWMODE_UI"))
  else
    var_UI.panel:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
  end
end
local function initialize()
  Instance_FieldViewMode:SetShow(false, false)
  Alpha_Rate_Setting(0)
  FieldViewMode_ScreenResize()
  registerEvent("onScreenResize", "FieldViewMode_ScreenResize")
  var_UI.panel:RegisterUpdateFunc("FieldViewMode_UpdateShowHide")
  var_UI.btn_init:addInputEvent("Mouse_LDown", "FieldViewMode_PushReset()")
  var_UI.panel:addInputEvent("Mouse_On", "FieldViewMode_ChangeTexture_On()")
  var_UI.panel:addInputEvent("Mouse_Out", "FieldViewMode_ChangeTexture_Off()")
  var_UI.panel:SetPosX(0)
  var_UI.panel:SetPosY(getScreenSizeY() - var_UI.panel:GetSizeY() - 300)
  var_UI.btn_left:addInputEvent("Mouse_LPress", "FieldViewMode_PushLeft()")
  var_UI.btn_right:addInputEvent("Mouse_LPress", "FieldViewMode_PushRight()")
  var_UI.btn_top:addInputEvent("Mouse_LPress", "FieldViewMode_PushTop()")
  var_UI.btn_bottom:addInputEvent("Mouse_LPress", "FieldViewMode_PushBottom()")
  var_UI.btn_FreeSet1:addInputEvent("Mouse_LPress", "FieldViewMode_PushFreeSet(1)")
  var_UI.btn_FreeSet2:addInputEvent("Mouse_LPress", "FieldViewMode_PushFreeSet(2)")
  var_UI.btn_FreeSet3:addInputEvent("Mouse_LPress", "FieldViewMode_PushFreeSet(3)")
  if not ToClient_isConsole() then
    characterCameraReset()
  end
end
initialize()
