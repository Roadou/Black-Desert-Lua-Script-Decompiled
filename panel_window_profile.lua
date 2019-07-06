Panel_Window_Profile:SetShow(false)
Panel_Window_Profile:RegisterShowEventFunc(true, "ProfileShowAni()")
Panel_Window_Profile:RegisterShowEventFunc(false, "ProfileHideAni()")
local buttonClose = UI.getChildControl(Panel_Window_Profile, "Button_Win_Close")
local labelStatic = UI.getChildControl(Panel_Window_Profile, "StaticText_ProfileInfo")
function Profile_registEventHandler()
  buttonClose:addInputEvent("Mouse_LUp", "HandleClicked_ProfileWindow_Close()")
end
function HandleClicked_ProfileWindow_Close()
  if Panel_Window_Profile:IsShow() then
    Panel_Window_Profile:SetShow(false)
  end
end
function ProfileShowAni()
end
function ProfileHideAni()
end
registerEvent("Profile_Updatelist", "Profile_Updatelist")
function Profile_Updatelist()
  _PA_LOG("\234\183\156\235\179\180", "    ProfileShowAni")
  Panel_Window_Profile:SetShow(true)
  local strHelpText_Type = {
    "---------Accum----------",
    "---------Day------------",
    "---------Week-----------",
    "---------Month----------"
  }
  local strHelpText = {
    "[Monster Kill Count] : ",
    "[Fishing Count] : ",
    "[PickupItem Count] : ",
    "[PickupItem Weight Accum] : "
  }
  local nArrTerm = {
    CppEnums.ProfileInitTermType.eProfileInitTermType_None,
    CppEnums.ProfileInitTermType.eProfileInitTermType_Day,
    CppEnums.ProfileInitTermType.eProfileInitTermType_Week,
    CppEnums.ProfileInitTermType.eProfileInitTermType_Month
  }
  local strSet = ""
  for k = 0, CppEnums.ProfileInitTermType.eProfileInitTermType_Maxcount - 1 do
    strSet = strSet .. strHelpText_Type[k + 1] .. "\n"
    for i = 0, CppEnums.ProfileIndex.eUserProfileValueType_Count - 1 do
      local profileInfo = ToClient_GetProfileInfo(nArrTerm[k + 1], i)
      strSet = strSet .. strHelpText[i + 1] .. tostring(profileInfo) .. "\n"
    end
    strSet = strSet .. [[


]]
  end
  labelStatic:SetText(strSet)
  if FGlobal_ProfileReward_IsShow() then
    FGlobal_ProfileReward_AllUpdate()
  end
end
Profile_registEventHandler()
