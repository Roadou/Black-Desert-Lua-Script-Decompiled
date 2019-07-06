local controller = UI.getChildControl(Panel_Test_SkillView_Control, "Static_Object")
local btnClose = UI.getChildControl(Panel_Test_SkillView_Control, "Button_Close")
controller:addInputEvent("Mouse_RDown", "FGlobal_StartRotate_SkillView()")
controller:addInputEvent("Mouse_RPress", "FGlobal_Rotate_SkillView()")
controller:addInputEvent("Mouse_LDown", "FGlobal_StartMove_SkillView()")
controller:addInputEvent("Mouse_LPress", "FGlobal_Move_SkillView()")
btnClose:addInputEvent("Mouse_LUp", "FGlobal_Close_SkillView()")
local _lastRotationPosX = 0
local _lastRotationPosY = 0
function FGlobal_Close_SkillView()
  Panel_Test_SkillView_Control:SetShow(false)
  ToClient_LearnSkillCameraHide()
  HandleMLUp_SkillWindow_Close()
end
function FGlobal_StartRotate_SkillView()
  _lastRotationPosX = getMousePosX()
  _lastRotationPosY = getMousePosY()
end
function FGlobal_Rotate_SkillView()
  local currentRotationPosX = getMousePosX()
  local currentRotationPosY = getMousePosY()
  local mouseDeltaX = currentRotationPosX - _lastRotationPosX
  local mouseDeltaY = currentRotationPosY - _lastRotationPosY
  _lastRotationPosX = currentRotationPosX
  _lastRotationPosY = currentRotationPosY
  ToClient_LearnSkillCameraSetRotation(0.005 * mouseDeltaX, 0.005 * mouseDeltaY)
end
local _lastMovePosX = 0
local _lastMovePosY = 0
function FGlobal_StartMove_SkillView()
  _lastMovePosX = getMousePosX()
  _lastMovePosY = getMousePosY()
end
function FGlobal_Move_SkillView()
  local currentMovePosX = getMousePosX()
  local currentMovePosY = getMousePosY()
  local mouseDeltaX = currentMovePosX - _lastMovePosX
  local mouseDeltaY = currentMovePosY - _lastMovePosY
  _lastMovePosX = currentMovePosX
  _lastMovePosY = currentMovePosY
  ToClient_LearnSkillCameraSetPosition(mouseDeltaX, mouseDeltaY)
end
function Test_Open_SkillWindow()
  if false == ToClient_LearnSkillCameraIsShow() then
    ToClient_LearnSkillCameraShow()
    ToClient_LearnSkillCameraLoadCharcterAndCamera()
    ToClient_LearnSkillCameraSetZoom(400)
    ToClient_LearnSkillCameraSetPosition(2.5, -0.5)
    Panel_Test_SkillView_Control:SetShow(true)
    HandleMLUp_SkillWindow_OpenForLearn()
  else
    ToClient_LearnSkillCameraHide()
    Panel_Test_SkillView_Control:SetShow(false)
    HandleMLUp_SkillWindow_Close()
  end
end
function TestFunc_SkillAction(skillNo)
  local skillStaticWrapper = getSkillStaticStatus(skillNo, 1)
  if nil == skillStaticWrapper then
    return
  end
  ToClient_LearnSkillCameraStartSkillAction(skillStaticWrapper:get())
end
function Test_MyFunction()
  if Panel_Test_SkillView_Control:GetShow() then
    Panel_Test_SkillView_Control:SetShow(false)
  else
    Panel_Test_SkillView_Control:SetShow(true)
  end
end
