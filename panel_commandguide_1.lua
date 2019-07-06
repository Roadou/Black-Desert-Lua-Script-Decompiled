function PaGlobal_CommandGuide:initialize()
  if true == PaGlobal_CommandGuide._initialize then
    return
  end
  PaGlobal_CommandGuide._ui._stc_commandBg = UI.getChildControl(Panel_CommandGuide, "Static_CommandBG")
  PaGlobal_CommandGuide._ui._stc_commandShowBg = UI.getChildControl(Panel_CommandGuide, "Static_ShowCommandBG")
  PaGlobal_CommandGuide._ui._txt_commandKey[1] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Key_W")
  PaGlobal_CommandGuide._ui._txt_commandKey[2] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Key_A")
  PaGlobal_CommandGuide._ui._txt_commandKey[3] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Key_S")
  PaGlobal_CommandGuide._ui._txt_commandKey[4] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Key_D")
  PaGlobal_CommandGuide._ui._txt_commandKey[5] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Key_Q")
  PaGlobal_CommandGuide._ui._txt_commandKey[6] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Key_E")
  PaGlobal_CommandGuide._ui._txt_commandKeyDesc[1] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Forward")
  PaGlobal_CommandGuide._ui._txt_commandKeyDesc[2] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Left")
  PaGlobal_CommandGuide._ui._txt_commandKeyDesc[3] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Back")
  PaGlobal_CommandGuide._ui._txt_commandKeyDesc[4] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Right")
  PaGlobal_CommandGuide._ui._txt_commandKeyDesc[5] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Small")
  PaGlobal_CommandGuide._ui._txt_commandKeyDesc[6] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Big")
  PaGlobal_CommandGuide._ui._stc_commandMouse[PaGlobal_CommandGuide._MOUSETYPE.LEFT] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "Static_CommandLMouse")
  PaGlobal_CommandGuide._ui._stc_commandMouse[PaGlobal_CommandGuide._MOUSETYPE.RIGHT] = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "Static_CommandRMouse")
  PaGlobal_CommandGuide._ui._txt_dot = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Dot")
  for ii = 1, 6 do
    PaGlobal_CommandGuide.keyControl[ii] = UI.createAndCopyBasePropertyControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Key_S", PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Key_" .. ii)
    PaGlobal_CommandGuide.dotControl[ii] = UI.createAndCopyBasePropertyControl(PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Dot", PaGlobal_CommandGuide._ui._stc_commandBg, "StaticText_Dot" .. ii)
  end
  PaGlobal_CommandGuide._ui._btn_showToggle = UI.getChildControl(PaGlobal_CommandGuide._ui._stc_commandShowBg, "Button_ShowCommand")
  PaGlobal_CommandGuide._maxCommandCount = 6
  PaGlobal_CommandGuide:registEventHandler()
  PaGlobal_CommandGuide:validate()
  PaGlobal_CommandGuide._initialize = true
end
function PaGlobal_CommandGuide:registEventHandler()
  if nil == Panel_CommandGuide then
    return
  end
  PaGlobal_CommandGuide._ui._btn_showToggle:addInputEvent("Mouse_LUp", "HandleEventLUp_CommandGuide_ShowGuide()")
end
function PaGlobal_CommandGuide:prepareOpen()
  if nil == Panel_CommandGuide then
    return
  end
  PaGlobal_CommandGuide:open()
end
function PaGlobal_CommandGuide:open()
  if nil == Panel_CommandGuide then
    return
  end
  Panel_CommandGuide:SetShow(true)
end
function PaGlobal_CommandGuide:prepareClose()
  if nil == Panel_CommandGuide then
    return
  end
  if 0 ~= PaGlobal_CommandGuide._isShowType then
    return
  end
  PaGlobal_CommandGuide:close()
end
function PaGlobal_CommandGuide:close()
  if nil == Panel_CommandGuide then
    return
  end
  Panel_CommandGuide:SetShow(false)
end
function PaGlobal_CommandGuide:validate()
  if nil == Panel_CommandGuide then
    return
  end
  PaGlobal_CommandGuide._ui._stc_commandBg:isValidate()
  PaGlobal_CommandGuide._ui._stc_commandShowBg:isValidate()
  for ii = 1, PaGlobal_CommandGuide._maxCommandCount do
    PaGlobal_CommandGuide._ui._txt_commandKey[ii]:isValidate()
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[ii]:isValidate()
  end
end
function PaGlobal_CommandGuide:setData()
  local isDataType = PaGlobal_CommandGuide._isShowType
  for ii = 1, PaGlobal_CommandGuide._maxCommandCount do
    PaGlobal_CommandGuide._ui._txt_commandKey[ii]:SetShow(true)
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[ii]:SetShow(true)
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[ii]:SetPosX(75)
    PaGlobal_CommandGuide.dotControl[ii]:SetShow(false)
    PaGlobal_CommandGuide.keyControl[ii]:SetShow(false)
  end
  PaGlobal_CommandGuide._ui._stc_commandMouse[PaGlobal_CommandGuide._MOUSETYPE.LEFT]:SetShow(false)
  PaGlobal_CommandGuide._ui._stc_commandMouse[PaGlobal_CommandGuide._MOUSETYPE.RIGHT]:SetShow(false)
  if 1 == isDataType then
    PaGlobal_CommandGuide._ui._txt_commandKey[1]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_MOVEFRONT"))
    PaGlobal_CommandGuide._ui._txt_commandKey[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_MOVELEFT"))
    PaGlobal_CommandGuide._ui._txt_commandKey[3]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_MOVERIGHT"))
    PaGlobal_CommandGuide._ui._txt_commandKey[4]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_MOVEBACK"))
    PaGlobal_CommandGuide._ui._txt_commandKey[5]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_CROUCHORSKILL"))
    PaGlobal_CommandGuide._ui._txt_commandKey[6]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_KICK"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[1]:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_0"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[2]:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_2"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[3]:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_3"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[4]:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_1"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[5]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_DESC_DIVE"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[6]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_DESC_RECOVERY"))
  elseif 2 == isDataType then
    PaGlobal_CommandGuide._ui._txt_commandKey[1]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_MOVEFRONT"))
    PaGlobal_CommandGuide._ui._txt_commandKey[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_MOVELEFT"))
    PaGlobal_CommandGuide._ui._txt_commandKey[3]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_MOVERIGHT"))
    PaGlobal_CommandGuide._ui._txt_commandKey[4]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_MOVEBACK"))
    PaGlobal_CommandGuide._ui._txt_commandKey[5]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_CROUCHORSKILL"))
    PaGlobal_CommandGuide._ui._txt_commandKey[6]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_GRABORGUARD"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[1]:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_0"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[2]:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_2"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[3]:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_3"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[4]:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Action_1"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[5]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_DESC_DIVE"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[6]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_DESC_UP"))
  elseif 3 == isDataType then
    PaGlobal_CommandGuide:SetMouseGuide(1, PaGlobal_CommandGuide._MOUSETYPE.LEFT)
    PaGlobal_CommandGuide:SetMouseGuide(2, PaGlobal_CommandGuide._MOUSETYPE.RIGHT)
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[1]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_DESC_CATTLEGATE_UP"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_DESC_CATTLEGATE_DOWN"))
    PaGlobal_CommandGuide._ui._txt_commandKey[1]:SetShow(false)
    PaGlobal_CommandGuide._ui._txt_commandKey[2]:SetShow(false)
    PaGlobal_CommandGuide._ui._txt_commandKey[3]:SetShow(false)
    PaGlobal_CommandGuide._ui._txt_commandKey[4]:SetShow(false)
    PaGlobal_CommandGuide._ui._txt_commandKey[5]:SetShow(false)
    PaGlobal_CommandGuide._ui._txt_commandKey[6]:SetShow(false)
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[3]:SetShow(false)
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[4]:SetShow(false)
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[5]:SetShow(false)
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[6]:SetShow(false)
  elseif 4 == isDataType then
    PaGlobal_CommandGuide._ui._txt_commandKey[1]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_MOVEFRONT"))
    PaGlobal_CommandGuide._ui._txt_commandKey[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_MOVEBACK"))
    PaGlobal_CommandGuide._ui._txt_commandKey[3]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_MOVELEFT"))
    PaGlobal_CommandGuide._ui._txt_commandKey[4]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_MOVERIGHT"))
    PaGlobal_CommandGuide._ui._txt_commandKey[5]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_MOVEBACK"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[1]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_DESC_LADDER_UP"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_DESC_LADDER_DOWN"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[3]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_DESC_LEFTJUMP"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[4]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_DESC_RIGHTJUMP"))
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[5]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_DESC_BACKJUMP"))
    PaGlobal_CommandGuide._ui._txt_commandKey[6]:SetShow(false)
    PaGlobal_CommandGuide._ui._txt_commandKeyDesc[6]:SetShow(false)
    local keyDesc = {
      [1] = PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_JUMP"),
      [2] = PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_JUMP"),
      [3] = PAGetString(Defines.StringSheet_GAME, "LUA_COMMANDGUIDE_JUMP")
    }
    local nextPosX = 0
    for ii = 1, 3 do
      local keyControl = PaGlobal_CommandGuide.keyControl[ii]
      local dotControl = PaGlobal_CommandGuide.dotControl[ii]
      keyControl:SetShow(true)
      dotControl:SetShow(true)
      nextPosX = PaGlobal_CommandGuide._ui._txt_commandKey[ii + 2]:GetPosX() + PaGlobal_CommandGuide._ui._txt_commandKey[ii + 2]:GetSizeX()
      dotControl:SetPosX(nextPosX)
      dotControl:SetPosY(PaGlobal_CommandGuide._ui._txt_commandKey[ii + 2]:GetPosY())
      dotControl:SetText("+")
      keyControl:SetPosX(nextPosX + dotControl:GetSizeX())
      keyControl:SetPosY(PaGlobal_CommandGuide._ui._txt_commandKey[ii + 2]:GetPosY())
      keyControl:SetText(keyDesc[ii])
      keyControl:SetSize(keyControl:GetTextSizeX() + 12, keyControl:GetSizeY())
      nextPosX = math.max(nextPosX, keyControl:GetPosX() + keyControl:GetSizeX())
    end
    for ii = 1, 5 do
      PaGlobal_CommandGuide._ui._txt_commandKeyDesc[ii]:SetPosX(nextPosX + 15)
    end
  end
  PaGlobal_CommandGuide:setBGSize()
  PaGlobal_CommandGuide:setKeyGuideSize()
end
function PaGlobal_CommandGuide:setBGSize()
  if nil == Panel_CommandGuide then
    return
  end
  local keySizeY = PaGlobal_CommandGuide._ui._txt_commandKey[1]:GetSizeY() + 3
  local commandPanelSize = 0
  local marginSize = 20
  local keyCount = 0
  local descCount = 0
  local maxBgSizeX = 0
  for _, control in pairs(PaGlobal_CommandGuide._ui._txt_commandKey) do
    if true == control:GetShow() then
      keyCount = keyCount + 1
    end
  end
  for _, control in pairs(PaGlobal_CommandGuide._ui._txt_commandKeyDesc) do
    if true == control:GetShow() then
      descCount = descCount + 1
      maxBgSizeX = math.max(maxBgSizeX, control:GetPosX() + control:GetSizeX())
    end
  end
  commandPanelSize = keySizeY * math.max(keyCount, descCount) + marginSize
  PaGlobal_CommandGuide._ui._stc_commandBg:SetSize(maxBgSizeX + marginSize * 2, commandPanelSize)
  PaGlobal_CommandGuide._ui._stc_commandShowBg:SetPosX(PaGlobal_CommandGuide._ui._stc_commandBg:GetSizeX() - PaGlobal_CommandGuide._ui._stc_commandShowBg:GetSizeX() - 20)
end
function PaGlobal_CommandGuide:setKeyGuideSize()
  for _, control in pairs(PaGlobal_CommandGuide._ui._txt_commandKey) do
    if true == control:GetShow() then
      local sizeX = control:GetTextSizeX() + 12
      if sizeX < control:GetSizeY() then
        sizeX = control:GetSizeY()
      end
      control:SetSize(sizeX, control:GetSizeY())
    end
  end
end
function PaGlobal_CommandGuide:SetMouseGuide(posIndex, mouseType)
  if nil == Panel_CommandGuide then
    return
  end
  PaGlobal_CommandGuide._ui._stc_commandMouse[mouseType]:SetShow(true)
  PaGlobal_CommandGuide._ui._stc_commandMouse[mouseType]:SetPosX(PaGlobal_CommandGuide._ui._txt_commandKey[posIndex]:GetPosX())
  PaGlobal_CommandGuide._ui._stc_commandMouse[mouseType]:SetPosY(PaGlobal_CommandGuide._ui._txt_commandKey[posIndex]:GetPosY())
end
