local _panel = Panel_Dialog_SkillSpecialize
local SkillSpecialize = {
  _initialize = false,
  _ui = {
    static_Skill_Specialize1 = nil,
    staticText_Skill_Special_Title = nil,
    staticText_Skill_Awaken_Special_Title = nil,
    rbtn_ChangeSkill_Template = nil,
    static_Skill_Icon = nil,
    staticText_Skill = nil,
    staticText_Skill_Desc = nil,
    staticText_Skill_Effect = nil,
    rbtn_ChangeNotyet_Template = nil,
    staticText_Level = nil,
    staticText_EnableSpecialize = nil,
    rbtn_List_ChangeSkill = {
      nil,
      nil,
      nil,
      nil,
      nil,
      nil
    },
    rbtn_List_ChangeNotyet = {
      nil,
      nil,
      nil,
      nil,
      nil,
      nil
    },
    rbtn_List = {
      nil,
      nil,
      nil,
      nil,
      nil,
      nil
    },
    staticText_Skill_Awaken_Special_Title = nil,
    static_Line = nil,
    static_Skill_Specialize2 = nil,
    static_Specialize_Img = nil,
    static_SelectedSkillIcon = nil,
    static_Content = nil,
    staticText_SkillBg = nil,
    staticText_NonSelect = nil,
    static_SkilllIcon = nil,
    staticText_SkillName = nil,
    staticText_SkillDesc = nil,
    staticText_EffectBg1 = nil,
    staticText_EffectBg2 = nil,
    list2_1_SelectSkill = nil,
    list2_2_SelectEffect1 = nil,
    list2_2_SelectEffect2 = nil,
    static_BottomArea = nil,
    txt_keyGuideY = nil,
    txt_keyGuideA = nil,
    txt_keyGuideB = nil,
    btn_DoSpecialize = nil,
    static_Skill_Desc_Popup = nil,
    staticText_Skill_Desc_Popup = nil,
    static_SkillEffectDesc_Popup = nil,
    staticText_SkillEffectDesc_Popup = nil
  },
  _config = {
    isReinforceContentOpen = ToClient_IsContentsGroupOpen("203"),
    reinforceSkillCount = 3,
    reinforceSkillViewCount = 6
  },
  _value = {
    currentPage = 0,
    lastSpecializeIndex = nil,
    currentSpecializeIndex = nil,
    currnetReinforceIndex = nil,
    currentReinforceSkillNo = nil,
    currentStep = nil,
    currentSelectSkillIndex = nil,
    currentEffectIndex = nil,
    currentEffectIndex2 = nil
  },
  _pos = {
    page1StartPos1Y = 0,
    page1StartPos2Y = 0,
    page1SpaceY = 0,
    page2Pos1 = 0,
    page2Pos2 = 0,
    page2Pos3 = 0,
    page2Pos4 = 0,
    page2Pos5 = 0,
    page2SpaceY = 0
  },
  _enum = {
    eButtonStateAlready = 0,
    eButtonStateBase = 1,
    eButtonStateLock = 2,
    eStepBase = 0,
    eStepSelectSkill = 1,
    eStepSelectEffect1 = 2,
    eStepSelectEffect2 = 3
  },
  _text = {
    enableSp = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_NORMAL_1"),
    enableAwakeSp = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_AWAKEN_1"),
    level = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV")
  },
  _fontcolor = {
    fontColor_NormalSkill = 4293640023,
    fontColor_AwakenSkill = 4280068804,
    fontColor_NormalLevel = 4293640023,
    fontColor_AwakenLevel = 4286636767,
    fontColor_Disable = 4287993237
  },
  _texture = {
    ["page1ButtonTexture"] = "Renewal/ETC/Console_ETC_Skill_00.dds",
    [1] = {
      x1 = 1,
      y1 = 189,
      x2 = 1041,
      y2 = 281
    },
    [2] = {
      x1 = 1,
      y1 = 377,
      x2 = 1041,
      y2 = 469
    }
  },
  _skillList = {},
  _effectList = {},
  _toIndex = 0,
  _scrollValue = 0,
  _vscroll = nil
}
local normalSkillreinforceableLv = {
  [0] = "50",
  "52",
  "54"
}
local awakenSkillreinforceableLv = {
  [0] = "56",
  "58",
  "60"
}
local AlertPanel = Panel_SkillAwaken_ResultOption
if ToClient_isConsole() then
  AlertPanel = Panel_SkillAwaken_ResultOption_Renew
end
local result = {
  _awakenResult_BG = UI.getChildControl(AlertPanel, "Static_AcquireBG"),
  _awakenTitle = UI.getChildControl(AlertPanel, "StaticText_AwakenTitle"),
  _awakenOption = UI.getChildControl(AlertPanel, "StaticText_AwakenOption")
}
local self = Panel_Dialog_SkillSpecialize
function SkillSpecialize:registerMessageHandler()
  _panel:RegisterShowEventFunc(true, "PaGlobalFunc_Dialog_SkillAwakenResult_ShowAni()")
  _panel:RegisterShowEventFunc(false, "PaGlobalFunc_Dialog_SkillAwakenResult_HideAni()")
  registerEvent("EventShowAwakenSkill", "FromClient_Dialog_SkillSpecialize_Show")
  registerEvent("FromClient_SuccessSkillAwaken", "FromClient_SuccessSkillSpecialize")
  registerEvent("FromClient_ChangeSkillAwakeningBitFlag", "FromClient_SuccessSkillSpecialize")
  registerEvent("FromClient_ChangeAwakenSkill", "FromClient_SuccessSkillSpecialize")
  _panel:RegisterUpdateFunc("SkillReinforceResult_Hide")
end
function SkillSpecialize:registEventHandler()
end
function SkillSpecialize:initialize()
  self:childControl()
  self:registEventHandler()
  self:registerMessageHandler()
  self:setDefaultPos()
  self:createControlPage1()
  self:setPosControlPage1()
end
function SkillSpecialize:initValue()
  self._value.currentPage = 0
  self._value.lastSpecializeIndex = nil
  self._value.currentSpecializeIndex = nil
  self._value.currnetReinforceIndex = nil
  self._toIndex = 0
  self._scrollValue = 0
  self._vscroll = self._ui.list2_1_SelectSkill:GetVScroll()
  self:initValuePage2()
end
function SkillSpecialize:initValuePage2()
  self._value.currentReinforceSkillNo = nil
  self._value.currentReinforceSkillNo = nil
  self._value.currentSelectSkillIndex = nil
  self._value.currentEffectIndex = nil
  self._value.currentEffectIndex2 = nil
end
function SkillSpecialize:childControl()
  self._ui.static_Skill_Specialize1 = UI.getChildControl(_panel, "Static_Skill_Specialize1")
  self._ui.staticText_Skill_Special_Title = UI.getChildControl(self._ui.static_Skill_Specialize1, "StaticText_Skill_Special_Title")
  self._ui.staticText_Skill_Awaken_Special_Title = UI.getChildControl(self._ui.static_Skill_Specialize1, "StaticText_Skill_Awaken_Special_Title")
  self._ui.rbtn_ChangeSkill_Template = UI.getChildControl(self._ui.static_Skill_Specialize1, "Radiobutton_ChangeSkill_Template")
  self._ui.static_Skill_Icon = UI.getChildControl(self._ui.rbtn_ChangeSkill_Template, "Static_Skill_Icon")
  self._ui.staticText_Skill = UI.getChildControl(self._ui.rbtn_ChangeSkill_Template, "StaticText_Skill")
  self._ui.staticText_Skill_Desc = UI.getChildControl(self._ui.rbtn_ChangeSkill_Template, "StaticText_Skill_Desc")
  self._ui.staticText_Skill_Effect = UI.getChildControl(self._ui.rbtn_ChangeSkill_Template, "StaticText_Skill_Effect")
  self._ui.rbtn_ChangeNotyet_Template = UI.getChildControl(self._ui.static_Skill_Specialize1, "RadioButton_ChangeNotyet_Template")
  self._ui.staticText_Level = UI.getChildControl(self._ui.rbtn_ChangeNotyet_Template, "StaticText_Level")
  self._ui.staticText_EnableSpecialize = UI.getChildControl(self._ui.rbtn_ChangeNotyet_Template, "StaticText_EnableSpecialize")
  self._ui.txt_tip = UI.getChildControl(self._ui.static_Skill_Specialize1, "StaticText_Tip")
  self._ui.txt_tip:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_tip:SetText(self._ui.txt_tip:GetText())
  self._ui.static_Skill_Specialize2 = UI.getChildControl(_panel, "Static_Skill_Specialize2")
  self._ui.static_Specialize_Img = UI.getChildControl(self._ui.static_Skill_Specialize2, "Static_Specialize_Img")
  self._ui.static_SelectedSkillIcon = UI.getChildControl(self._ui.static_Specialize_Img, "Static_SelectedSkillIcon")
  self._ui.static_Content = UI.getChildControl(self._ui.static_Skill_Specialize2, "Static_Content")
  self._ui.staticText_SkillBg = UI.getChildControl(self._ui.static_Content, "StaticText_SkillBg")
  self._ui.staticText_NonSelect = UI.getChildControl(self._ui.staticText_SkillBg, "StaticText_NonSelect")
  self._ui.static_SkilllIcon = UI.getChildControl(self._ui.staticText_SkillBg, "Static_SkilllIcon")
  self._ui.staticText_SkillName = UI.getChildControl(self._ui.staticText_SkillBg, "StaticText_SkillName")
  self._ui.staticText_SkillDesc = UI.getChildControl(self._ui.staticText_SkillBg, "StaticText_SkillDesc")
  self._ui.list2_1_SelectSkill = UI.getChildControl(self._ui.static_Content, "List2_1_SelectSkill")
  self._ui.list2_1_SelectSkill:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_Dialog_SkillSpecialize_Page2SkillListCreate")
  self._ui.list2_1_SelectSkill:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.list2_2_SelectEffect1 = UI.getChildControl(self._ui.static_Content, "List2_2_SelectEffect1")
  self._ui.list2_2_SelectEffect1:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_Dialog_SkillSpecialize_Page2EffectListCreate")
  self._ui.list2_2_SelectEffect1:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.list2_2_SelectEffect2 = UI.getChildControl(self._ui.static_Content, "List2_2_SelectEffect2")
  self._ui.list2_2_SelectEffect2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_Dialog_SkillSpecialize_Page2EffectListCreate")
  self._ui.list2_2_SelectEffect2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.staticText_EffectBg1 = UI.getChildControl(self._ui.static_Content, "StaticText_EffectBg1")
  self._ui.static_Icon1 = UI.getChildControl(self._ui.staticText_EffectBg1, "Static_Icon1")
  self._ui.staticText_EffectBg2 = UI.getChildControl(self._ui.static_Content, "StaticText_EffectBg2")
  self._ui.static_Icon2 = UI.getChildControl(self._ui.staticText_EffectBg2, "Static_Icon2")
  self._ui.staticText_EffectBg1:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.staticText_EffectBg2:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.static_BottomArea = UI.getChildControl(_panel, "Static_BottomArea")
  self._ui.txt_keyGuideY = UI.getChildControl(self._ui.static_BottomArea, "StaticText_ChangeEffect")
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.static_BottomArea, "StaticText_Select")
  self._ui.txt_keyGuideB = UI.getChildControl(self._ui.static_BottomArea, "StaticText_Cancel")
  self._ui.txt_keyGuideA:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GENERIC_KEYGUIDE_XBOX_SELECT"))
  self._ui.txt_keyGuideB:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GENERIC_KEYGUIDE_XBOX_DISCARD"))
  self._ui.static_Skill_Desc_Popup = UI.getChildControl(_panel, "Static_Skill_Desc_Popup")
  self._ui.static_Skill_Desc_Popup:SetShow(false)
  self._ui.staticText_Skill_Desc_Popup = UI.getChildControl(self._ui.static_Skill_Desc_Popup, "StaticText_Skill_Desc")
  self._ui.staticText_Skill_Desc_Popup:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.static_SkillEffectDesc_Popup = UI.getChildControl(_panel, "Static_SkillEffectDesc_Popup")
  self._ui.static_SkillEffectDesc_Popup:SetShow(false)
  self._ui.staticText_SkillEffectDesc_Popup = UI.getChildControl(self._ui.static_SkillEffectDesc_Popup, "StaticText_SkilEffectDesc")
  self._ui.staticText_SkillEffectDesc_Popup:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local keyGuides = {
    self._ui.txt_keyGuideY,
    self._ui.txt_keyGuideA,
    self._ui.txt_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.static_BottomArea, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function SkillSpecialize:setDefaultPos()
  self._pos.page1StartPos1Y = self._ui.staticText_Skill_Special_Title:GetPosY() + self._ui.staticText_Skill_Special_Title:GetSizeY() + 19
  self._pos.page1StartPos2Y = self._ui.staticText_Skill_Awaken_Special_Title:GetPosY() + self._ui.staticText_Skill_Awaken_Special_Title:GetSizeY() + 19
  self._pos.page1SpaceY = self._ui.rbtn_ChangeSkill_Template:GetSizeY()
  self._pos.page2SpaceY = self._ui.staticText_EffectBg1:GetSizeY()
  self._pos.page2Pos1 = self._ui.staticText_SkillBg:GetPosY() + 4
  self._pos.page2Pos2 = self._pos.page2Pos1 + self._pos.page2SpaceY + 4
  self._pos.page2Pos3 = self._pos.page2Pos2 + self._pos.page2SpaceY + 4
  self._pos.page2Pos4 = self._pos.page2Pos3 + self._pos.page2SpaceY + 4
  self._pos.page2Pos5 = self._ui.staticText_EffectBg1:GetPosY()
  self._pos.page2Pos6 = self._ui.staticText_EffectBg2:GetPosY()
end
function SkillSpecialize:createControlPage1()
  for index = 0, self._config.reinforceSkillViewCount - 1 do
    local rbtn_ChangeSkill = {}
    rbtn_ChangeSkill.state = self._enum.eButtonStateAlready
    rbtn_ChangeSkill.reinforceIndex = nil
    rbtn_ChangeSkill.radiobutton = UI.createAndCopyBasePropertyControl(self._ui.static_Skill_Specialize1, "Radiobutton_ChangeSkill_Template", self._ui.static_Skill_Specialize1, "Radiobutton_ChangeSkill_" .. index)
    rbtn_ChangeSkill.static_Icon = UI.createAndCopyBasePropertyControl(self._ui.rbtn_ChangeSkill_Template, "Static_Skill_Icon", rbtn_ChangeSkill.radiobutton, "Static_Skill_Icon_" .. index)
    rbtn_ChangeSkill.staticText_Skill = UI.createAndCopyBasePropertyControl(self._ui.rbtn_ChangeSkill_Template, "StaticText_Skill", rbtn_ChangeSkill.radiobutton, "StaticText_Skill_" .. index)
    rbtn_ChangeSkill.staticText_Skill_Desc = UI.createAndCopyBasePropertyControl(self._ui.rbtn_ChangeSkill_Template, "StaticText_Skill_Desc", rbtn_ChangeSkill.radiobutton, "StaticText_Skill_Desc_" .. index)
    rbtn_ChangeSkill.staticText_Skill_Effect = UI.createAndCopyBasePropertyControl(self._ui.rbtn_ChangeSkill_Template, "StaticText_Skill_Effect", rbtn_ChangeSkill.radiobutton, "StaticText_Skill_Effect_" .. index)
    self._ui.rbtn_List_ChangeSkill[index] = rbtn_ChangeSkill
  end
  for index = 0, self._config.reinforceSkillViewCount - 1 do
    local rbtn_ChangeNotyet = {}
    rbtn_ChangeSkill.state = self._enum.eButtonStateBase
    rbtn_ChangeSkill.reinforceIndex = nil
    rbtn_ChangeNotyet.radiobutton = UI.createAndCopyBasePropertyControl(self._ui.static_Skill_Specialize1, "RadioButton_ChangeNotyet_Template", self._ui.static_Skill_Specialize1, "RadioButton_ChangeNotyet_" .. index)
    rbtn_ChangeNotyet.staticText_Level = UI.createAndCopyBasePropertyControl(self._ui.rbtn_ChangeNotyet_Template, "StaticText_Level", rbtn_ChangeNotyet.radiobutton, "StaticText_Level_" .. index)
    rbtn_ChangeNotyet.staticText_EnableSpecialize = UI.createAndCopyBasePropertyControl(self._ui.rbtn_ChangeNotyet_Template, "StaticText_EnableSpecialize", rbtn_ChangeNotyet.radiobutton, "StaticText_EnableSpecialize_" .. index)
    self._ui.rbtn_List_ChangeNotyet[index] = rbtn_ChangeNotyet
  end
end
function SkillSpecialize:setPosControlPage1()
  for index = 0, self._config.reinforceSkillViewCount - 1 do
    if index < self._config.reinforceSkillCount then
      self._ui.rbtn_List_ChangeSkill[index].radiobutton:SetPosY(self._pos.page1StartPos1Y + index * (self._pos.page1SpaceY + 9))
      self._ui.rbtn_List_ChangeNotyet[index].radiobutton:SetPosY(self._pos.page1StartPos1Y + index * (self._pos.page1SpaceY + 9))
    else
      self._ui.rbtn_List_ChangeSkill[index].radiobutton:SetPosY(self._pos.page1StartPos2Y + (index - self._config.reinforceSkillCount) * (self._pos.page1SpaceY + 9))
      self._ui.rbtn_List_ChangeNotyet[index].radiobutton:SetPosY(self._pos.page1StartPos2Y + (index - self._config.reinforceSkillCount) * (self._pos.page1SpaceY + 9))
    end
  end
end
function SkillSpecialize:open(showAni)
  ToClient_padSnapResetControl()
  if nil == showAni then
    _panel:SetShow(true, true)
  else
    _panel:SetShow(true, showAni)
  end
end
function SkillSpecialize:close(showAni)
  AlertPanel:SetShow(false)
  if nil == showAni then
    _panel:SetShow(false, true)
  else
    _panel:SetShow(false, showAni)
  end
end
function SkillSpecialize:resize()
  _panel:ComputePos()
end
function SkillSpecialize:preOpen()
  self:initValue()
  self:resize()
end
function SkillSpecialize:setContent()
  if self._value.currentPage == 0 then
    self:clearContentPage1()
    self:setContentPage1()
  else
    self:clearContentPage2()
    self:setContentPage2(self._value.currentStep)
  end
  self:showPage()
end
function SkillSpecialize:showPage()
  local currentPage = self._value.currentPage
  if currentPage == 0 then
    self._ui.static_Skill_Specialize1:SetShow(true)
    self._ui.static_Skill_Specialize2:SetShow(false)
  else
    self._ui.static_Skill_Specialize1:SetShow(false)
    self._ui.static_Skill_Specialize2:SetShow(true)
  end
end
function SkillSpecialize:clearContentPage1()
  for index = 0, self._config.reinforceSkillViewCount - 1 do
    self._ui.rbtn_List_ChangeSkill[index].radiobutton:SetShow(false)
    self._ui.rbtn_List_ChangeSkill[index].radiobutton:SetCheck(false)
    self._ui.rbtn_List_ChangeNotyet[index].radiobutton:SetShow(false)
    self._ui.rbtn_List_ChangeNotyet[index].radiobutton:SetCheck(false)
    self._ui.rbtn_List_ChangeSkill[index].reinforceIndex = nil
    self._ui.rbtn_List_ChangeNotyet[index].reinforceIndex = nil
  end
  self:initValue()
end
function SkillSpecialize:setContentPage1()
  local selfPlayLevel = getSelfPlayer():get():getLevel()
  local reinforcableSkillCount = 0
  if selfPlayLevel < 50 then
    reinforcableSkillCount = 0
  elseif selfPlayLevel < 52 then
    reinforcableSkillCount = 1
  elseif selfPlayLevel < 54 then
    reinforcableSkillCount = 2
  elseif selfPlayLevel < 56 then
    reinforcableSkillCount = 3
  elseif selfPlayLevel < 58 then
    reinforcableSkillCount = 4
  elseif selfPlayLevel < 60 then
    reinforcableSkillCount = 5
  else
    reinforcableSkillCount = 6
  end
  local normalSkill_ReinforceCount = ToClient_GetSkillAwakeningCount()
  local awakenSkill_ReinforceCount = ToClient_GetWeaponSkillAwakeningCount()
  local reinforcedSkillcount = ToClient_GetReAwakeningListCount()
  local totalReinforceCount = 0
  local currnetReinforceCount = 0
  for index = 0, self._config.reinforceSkillCount - 1 do
    local control
    if index < normalSkill_ReinforceCount then
      control = self._ui.rbtn_List_ChangeSkill[index]
      control.state = self._enum.eButtonStateAlready
      self:setSkillButtonData(index, control)
      currnetReinforceCount = currnetReinforceCount + 1
      totalReinforceCount = totalReinforceCount + 1
    else
      control = self._ui.rbtn_List_ChangeNotyet[index]
      control.staticText_Level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. normalSkillreinforceableLv[index])
      if totalReinforceCount == reinforcableSkillCount then
        control.state = self._enum.eButtonStateLock
        control.staticText_EnableSpecialize:SetShow(false)
        self:changeTexturePage1Button(control.radiobutton, self._enum.eButtonStateLock)
        control.radiobutton:SetEnable(false)
        control.radiobutton:SetIgnore(true)
      else
        control.state = self._enum.eButtonStateBase
        control.staticText_EnableSpecialize:SetShow(true)
        control.staticText_EnableSpecialize:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_NORMAL_1"))
        self:changeTexturePage1Button(control.radiobutton, self._enum.eButtonStateBase)
        control.radiobutton:SetEnable(true)
        control.radiobutton:SetIgnore(false)
        totalReinforceCount = totalReinforceCount + 1
      end
    end
    self._ui.rbtn_List[index] = control
    self._ui.rbtn_List[index].radiobutton:SetShow(true)
    self._ui.rbtn_List[index].radiobutton:addInputEvent("Mouse_LUp", "PaGlobalFunc_Dialog_SkillSpecialize_ChangeSkill()")
    self._ui.rbtn_List[index].radiobutton:addInputEvent("Mouse_On", "PaGlobalFunc_Dialog_SkillSpecialize_Page1_OverSkillButton(" .. index .. ")")
    self._ui.rbtn_List[index].radiobutton:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_Dialog_SkillSpecialize_ChangeEffect()")
  end
  for index = self._config.reinforceSkillCount, self._config.reinforceSkillViewCount - 1 do
    local control
    if awakenSkill_ReinforceCount > index - 3 then
      control = self._ui.rbtn_List_ChangeSkill[index]
      control.state = self._enum.eButtonStateAlready
      self:setSkillButtonData(index, control)
      currnetReinforceCount = currnetReinforceCount + 1
      totalReinforceCount = totalReinforceCount + 1
    else
      control = self._ui.rbtn_List_ChangeNotyet[index]
      control.staticText_Level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. awakenSkillreinforceableLv[index - 3])
      if totalReinforceCount == reinforcableSkillCount then
        control.state = self._enum.eButtonStateLock
        control.staticText_EnableSpecialize:SetShow(false)
        self:changeTexturePage1Button(control.radiobutton, self._enum.eButtonStateLock)
        control.radiobutton:SetEnable(false)
        control.radiobutton:SetIgnore(true)
      else
        control.state = self._enum.eButtonStateBase
        control.staticText_EnableSpecialize:SetShow(true)
        control.staticText_EnableSpecialize:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_AWAKEN_1"))
        self:changeTexturePage1Button(control.radiobutton, self._enum.eButtonStateBase)
        control.radiobutton:SetEnable(true)
        control.radiobutton:SetIgnore(false)
        totalReinforceCount = totalReinforceCount + 1
      end
    end
    self._ui.rbtn_List[index] = control
    self._ui.rbtn_List[index].radiobutton:SetShow(true)
    self._ui.rbtn_List[index].radiobutton:addInputEvent("Mouse_LUp", "PaGlobalFunc_Dialog_SkillSpecialize_ChangeSkill()")
    self._ui.rbtn_List[index].radiobutton:addInputEvent("Mouse_On", "PaGlobalFunc_Dialog_SkillSpecialize_Page1_OverSkillButton(" .. index .. ")")
    self._ui.rbtn_List[index].radiobutton:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_Dialog_SkillSpecialize_ChangeEffect()")
  end
  self._value.currentSpecializeIndex = 0
  PaGlobalFunc_Dialog_SkillSpecialize_Page1_OverSkillButton(self._value.currentSpecializeIndex)
  self:updateKeyGuide(0)
  PaGlobalFunc_Dialog_SkillSpecialize_OnPadB = PaGlobalFunc_Dialog_SkillSpecialize_Exit
end
function SkillSpecialize:updateKeyGuide(page, step)
  if nil == page then
    return
  end
  local keyGuides = {}
  if 0 == page then
    self._ui.txt_keyGuideA:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILLREINFORCE_CHANGESKILL"))
    self._ui.txt_keyGuideA:SetMonoTone(not self:isSkillChangePossible())
    self._ui.txt_keyGuideY:SetShow(true)
    self._ui.txt_keyGuideY:SetMonoTone(not self:isEffectChangePossible())
    self._ui.txt_keyGuideY:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_DIALOG_SKILLSPECIALIZE_CHANGE_EFFECT"))
    keyGuides = {
      self._ui.txt_keyGuideY,
      self._ui.txt_keyGuideA,
      self._ui.txt_keyGuideB
    }
  else
    if step == self._enum.eStepBase then
      self._ui.txt_keyGuideA:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GENERIC_KEYGUIDE_XBOX_SELECT"))
    elseif step == self._enum.eStepSelectSkill then
      self._ui.txt_keyGuideA:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GENERIC_KEYGUIDE_XBOX_SELECT"))
    elseif step == self._enum.eStepSelectEffect1 then
      self._ui.txt_keyGuideA:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILLREINFORCE_TITLE"))
    elseif step == self._enum.eStepSelectEffect2 then
      self._ui.txt_keyGuideA:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILLREINFORCE_TITLE"))
    end
    self._ui.txt_keyGuideY:SetShow(false)
    keyGuides = {
      self._ui.txt_keyGuideA,
      self._ui.txt_keyGuideB
    }
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.static_BottomArea, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function SkillSpecialize:isSkillChangePossible()
  if nil == self._value.currentSpecializeIndex then
    return false
  end
  local control = self._ui.rbtn_List[self._value.currentSpecializeIndex]
  if nil ~= control.reinforceIndex then
    local skillSSW = ToClient_GetReAwakeningListAt(control.reinforceIndex)
    local skillNo = skillSSW:getSkillNo()
    if nil ~= skillNo then
      local selfPlayer = getSelfPlayer()
      if nil == selfPlayer then
        return false
      end
      local applyAwakenSkillReset = selfPlayer:get():isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_UnlimitedSkillAwakening)
      local inventory = selfPlayer:get():getInventory()
      local hasMemoryFlag = inventory:getItemCount_s64(ItemEnchantKey(44195, 0))
      if toInt64(0, 0) == hasMemoryFlag and not applyAwakenSkillReset then
        return false
      end
    end
  elseif self._enum.eButtonStateLock == control.state then
    return false
  else
    return true
  end
  local _type = self:getSkillAwakeningType(self._value.currentSpecializeIndex)
  local reinforcableCount = ToClient_GetAwakeningListCount()
  local count = 0
  for index = 0, reinforcableCount - 1 do
    local skillSSW = ToClient_GetAwakeningListAt(index)
    if _type == skillSSW:getSkillAwakeningType() then
      count = count + 1
    end
  end
  if 0 == count then
    return false
  end
  return true
end
function SkillSpecialize:isEffectChangePossible()
  if nil == self._value.currentSpecializeIndex then
    return false
  end
  local control = self._ui.rbtn_List[self._value.currentSpecializeIndex]
  if nil ~= control.reinforceIndex then
    local skillSSW = ToClient_GetReAwakeningListAt(control.reinforceIndex)
    if nil == skillSSW then
      return false
    end
    local skillNo = skillSSW:getSkillNo()
    if nil ~= skillNo then
      local selfPlayer = getSelfPlayer()
      if nil == selfPlayer then
        return false
      end
      local applyAwakenSkillReset = selfPlayer:get():isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_UnlimitedSkillAwakening)
      local inventory = selfPlayer:get():getInventory()
      local hasMemoryFlag = inventory:getItemCount_s64(ItemEnchantKey(44195, 0))
      if toInt64(0, 0) == hasMemoryFlag and not applyAwakenSkillReset then
        return false
      end
      local SkillSSW = getSkillStaticStatus(skillNo, 1)
      if nil == SkillSSW then
        return false
      end
      local ActiveSkillWrapper = SkillSSW:getActiveSkillStatus()
      if nil == ActiveSkillWrapper then
        return false
      end
    else
      return false
    end
  else
    return false
  end
  return true
end
function SkillSpecialize:setSkillButtonData(buttonIndex, control)
  local _type = self:getSkillAwakeningType(buttonIndex)
  if nil == control then
    return
  end
  local thisIndex = buttonIndex - _type * 3
  local normalSkill_ReinforceIndex = 0
  local awakenSkill_ReinforceIndex = 0
  local reinforceIndex = 0
  local reinforcedSkillcount = ToClient_GetReAwakeningListCount()
  for index = 0, reinforcedSkillcount - 1 do
    local skillSSW = ToClient_GetReAwakeningListAt(index)
    if nil ~= skillSSW then
      if 0 == skillSSW:getSkillAwakeningType() then
        if 0 == _type and thisIndex == normalSkill_ReinforceIndex then
          reinforceIndex = index
        end
        normalSkill_ReinforceIndex = normalSkill_ReinforceIndex + 1
      else
        if 1 == _type and thisIndex == awakenSkill_ReinforceIndex then
          reinforceIndex = index
        end
        awakenSkill_ReinforceIndex = awakenSkill_ReinforceIndex + 1
      end
    end
  end
  local skillSSW = ToClient_GetReAwakeningListAt(reinforceIndex)
  if nil == skillSSW then
    _PA_LOG("\235\176\149\235\178\148\236\164\128", "setSkillButtonData return 2, index : : " .. reinforceIndex)
    return
  end
  control.reinforceIndex = reinforceIndex
  local skillTypeSSW = skillSSW:getSkillTypeStaticStatusWrapper()
  control.staticText_Skill:SetText(skillSSW:getName())
  control.staticText_Skill_Desc:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  control.staticText_Skill_Desc:setLineCountByLimitAutoWrap(2)
  control.staticText_Skill_Desc:SetText(skillTypeSSW:getDescription())
  local skillNo = skillSSW:getSkillNo()
  local optionCount = ToClient_GetAwakeningAbilityCount(skillNo)
  local skillEffectText = ""
  for index = 0, optionCount - 1 do
    local optionIndex = ToClient_GetAwakeningAbilityIndex(skillNo, index)
    skillEffectText = skillEffectText .. skillSSW:getSkillAwakenDescription(optionIndex)
    if index ~= optionCount - 1 then
      skillEffectText = skillEffectText .. "\n"
    end
  end
  local txt = control.staticText_Skill_Effect
  txt:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  txt:setLineCountByLimitAutoWrap(3)
  txt:SetText(skillEffectText)
  txt:SetTextSpan(0, (txt:GetSizeY() - txt:GetTextSizeY()) * 0.5)
  control.static_Icon:ChangeTextureInfoName("Icon/" .. skillTypeSSW:getIconPath())
  local x1, y1, x2, y2 = setTextureUV_Func(control.static_Icon, 0, 0, 44, 44)
  control.static_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
  control.static_Icon:setRenderTexture(control.static_Icon:getBaseTexture())
end
function SkillSpecialize:clearContentPage2()
  self:initValuePage2()
end
function SkillSpecialize:setContentPage2(step)
  if nil == self._value.currentReinforceSkillNo then
    local ReinforceIndex = self._ui.rbtn_List[self._value.currentSpecializeIndex].reinforceIndex
    local skillSSW = ToClient_GetReAwakeningListAt(ReinforceIndex)
    if nil ~= skillSSW then
      self._value.currentReinforceSkillNo = skillSSW:getSkillNo()
    end
  end
  self._value.currentStep = step
  if self._value.currentStep == self._enum.eStepBase then
    self:setPage2_0Step()
  elseif self._value.currentStep == self._enum.eStepSelectSkill then
    self:setPage2_1Step(self._value.currentReinforceSkillNo)
  elseif self._value.currentStep == self._enum.eStepSelectEffect1 then
    self:setPage2_2Step(self._value.currentReinforceSkillNo)
  else
    if self._value.currentStep == self._enum.eStepSelectEffect2 then
      self:setPage2_3Step(self._value.currentReinforceSkillNo)
    else
    end
  end
  self:updateKeyGuide(1, self._value.currentStep)
  PaGlobalFunc_Dialog_SkillSpecialize_OnPadB = PaGlobalFunc_Dialog_SkillSpecialize_GoBackStepPage2
end
function SkillSpecialize:setPage2_0Step(skillNo)
  self:setPage2SelectedSkill(skillNo)
  self._ui.list2_2_SelectEffect1:getElementManager():clearKey()
  self._ui.list2_2_SelectEffect1:SetShow(false)
  self._ui.list2_2_SelectEffect2:getElementManager():clearKey()
  self._ui.list2_2_SelectEffect2:SetShow(false)
  self._ui.list2_1_SelectSkill:SetShow(true)
  self._ui.list2_1_SelectSkill:SetPosY(self._pos.page2Pos2)
  self._ui.list2_1_SelectSkill:getElementManager():clearKey()
  for k in pairs(self._skillList) do
    self._skillList[k] = nil
  end
  local _type = self:getSkillAwakeningType(self._value.currentSpecializeIndex)
  local count = PaGlobalFunc_Dialog_SkillSpecialize_Reinforcable_SkillCount(_type)
  if 0 == count then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_NOSKILL"))
  end
  for key = 0, count - 1 do
    self._skillList[key] = key
    self._ui.list2_1_SelectSkill:getElementManager():pushKey(toInt64(0, self._skillList[key]))
  end
  local text = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTOPTION")
  self._ui.staticText_EffectBg1:SetText(text)
  self._ui.staticText_EffectBg2:SetText(text)
  self._ui.staticText_EffectBg1:SetTextSpan(10, (self._ui.staticText_EffectBg1:GetSizeY() - self._ui.staticText_EffectBg1:GetTextSizeY()) * 0.5)
  self._ui.staticText_EffectBg2:SetTextSpan(10, (self._ui.staticText_EffectBg2:GetSizeY() - self._ui.staticText_EffectBg2:GetTextSizeY()) * 0.5)
  self._ui.staticText_EffectBg1:SetFontColor(Defines.Color.C_FF76747D)
  self._ui.staticText_EffectBg2:SetFontColor(Defines.Color.C_FF76747D)
  self._ui.staticText_EffectBg1:SetPosY(self._pos.page2Pos5)
  self._ui.staticText_EffectBg2:SetPosY(self._pos.page2Pos6)
  self._ui.static_Icon1:SetShow(false)
  self._ui.static_Icon2:SetShow(false)
  self._ui.txt_keyGuideB:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GENERIC_KEYGUIDE_XBOX_DISCARD"))
end
function SkillSpecialize:setPage2_1Step(skillNo)
  self:setPage2SelectedSkill(skillNo)
  self._ui.list2_1_SelectSkill:getElementManager():clearKey()
  self._ui.list2_1_SelectSkill:SetShow(false)
  self._ui.list2_2_SelectEffect1:SetShow(true)
  self._ui.list2_2_SelectEffect1:SetPosY(self._pos.page2Pos3)
  self._ui.list2_2_SelectEffect2:getElementManager():clearKey()
  self._ui.list2_2_SelectEffect2:SetShow(false)
  local text = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTOPTION")
  self._ui.staticText_EffectBg1:SetText(text)
  self._ui.staticText_EffectBg2:SetText(text)
  self._ui.staticText_EffectBg1:SetTextSpan(10, (self._ui.staticText_EffectBg1:GetSizeY() - self._ui.staticText_EffectBg1:GetTextSizeY()) * 0.5)
  self._ui.staticText_EffectBg2:SetTextSpan(10, (self._ui.staticText_EffectBg2:GetSizeY() - self._ui.staticText_EffectBg2:GetTextSizeY()) * 0.5)
  self._ui.staticText_EffectBg1:SetFontColor(Defines.Color.C_FFEEEEEE)
  self._ui.staticText_EffectBg2:SetFontColor(Defines.Color.C_FF525B6D)
  self._ui.staticText_EffectBg1:SetPosY(self._pos.page2Pos2)
  self._ui.staticText_EffectBg2:SetPosY(self._pos.page2Pos6)
  self._ui.static_Icon1:SetShow(true)
  self._ui.static_Icon2:SetShow(false)
  self._ui.txt_keyGuideB:SetText(PAGetString(Defines.StringSheet_RESOURCE, "FILEEXPLORER_BTN_BACK"))
  self._ui.list2_2_SelectEffect1:getElementManager():clearKey()
  for k in pairs(self._effectList) do
    self._effectList[k] = nil
  end
  local skillSSW = getSkillStaticStatus(self._value.currentReinforceSkillNo, 1)
  local activeSkillSS = skillSSW:getActiveSkillStatus()
  if nil ~= activeSkillSS then
    local optionCount = activeSkillSS:getSkillAwakenInfoCount()
    for key = 0, optionCount - 1 do
      self._effectList[key] = key
      self._ui.list2_2_SelectEffect1:getElementManager():pushKey(toInt64(0, self._effectList[key]))
    end
  end
end
function SkillSpecialize:setPage2_2Step(skillNo)
  self:setPage2SelectedSkill(skillNo)
  self._ui.list2_1_SelectSkill:SetShow(false)
  self._ui.list2_2_SelectEffect1:getElementManager():clearKey()
  self._ui.list2_2_SelectEffect1:SetShow(false)
  self._ui.list2_2_SelectEffect2:SetPosY(self._pos.page2Pos4)
  self._ui.list2_2_SelectEffect2:SetShow(true)
  local text = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTOPTION")
  self._ui.staticText_EffectBg2:SetText(text)
  self._ui.staticText_EffectBg1:SetFontColor(Defines.Color.C_FF525B6D)
  self._ui.staticText_EffectBg2:SetFontColor(Defines.Color.C_FFEEEEEE)
  self._ui.staticText_EffectBg1:SetPosY(self._pos.page2Pos2)
  self._ui.staticText_EffectBg2:SetPosY(self._pos.page2Pos3)
  self._ui.staticText_EffectBg1:SetTextSpan(10, (self._ui.staticText_EffectBg1:GetSizeY() - self._ui.staticText_EffectBg1:GetTextSizeY()) * 0.5)
  self._ui.staticText_EffectBg2:SetTextSpan(10, (self._ui.staticText_EffectBg2:GetSizeY() - self._ui.staticText_EffectBg2:GetTextSizeY()) * 0.5)
  self._ui.static_Icon1:SetShow(true)
  self._ui.static_Icon2:SetShow(true)
  self._ui.txt_keyGuideB:SetText(PAGetString(Defines.StringSheet_RESOURCE, "FILEEXPLORER_BTN_BACK"))
  self._ui.list2_2_SelectEffect2:getElementManager():clearKey()
  for k in pairs(self._effectList) do
    self._effectList[k] = nil
  end
  local skillSSW = getSkillStaticStatus(self._value.currentReinforceSkillNo, 1)
  local activeSkillSS = skillSSW:getActiveSkillStatus()
  if nil ~= activeSkillSS then
    local optionCount = activeSkillSS:getSkillAwakenInfoCount()
    for key = 0, optionCount - 1 do
      if nil ~= self._value.currentEffectIndex and self._value.currentEffectIndex ~= key then
        self._effectList[key] = key
        self._ui.list2_2_SelectEffect2:getElementManager():pushKey(toInt64(0, self._effectList[key]))
      end
    end
  end
  self._ui.staticText_EffectBg1:SetText(tostring(activeSkillSS:getSkillAwakenDescription(self._value.currentEffectIndex)))
end
function SkillSpecialize:setPage2_3Step(skillNo)
  self:setPage2SelectedSkill(skillNo)
end
function SkillSpecialize:goPage1()
  self._value.currentPage = 0
  self:initValuePage2()
  self:setContent()
end
function SkillSpecialize:setPage2SelectedSkill(skillNo)
  if nil == skillNo then
    self._ui.staticText_NonSelect:SetShow(true)
    self._ui.staticText_NonSelect:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTSKILL_2"))
    self._ui.static_SelectedSkillIcon:SetShow(false)
    self._ui.static_SkilllIcon:SetShow(false)
    self._ui.staticText_SkillName:SetShow(false)
    self._ui.staticText_SkillDesc:SetShow(false)
  else
    self._ui.static_SkilllIcon:SetShow(true)
    self._ui.static_SelectedSkillIcon:SetShow(true)
    self._ui.staticText_SkillName:SetShow(true)
    self._ui.staticText_SkillDesc:SetShow(true)
    self._ui.staticText_NonSelect:SetShow(false)
    local skillSSW = getSkillStaticStatus(skillNo, 1)
    if nil == skillSSW then
      return
    end
    local skillTypeSSW = skillSSW:getSkillTypeStaticStatusWrapper()
    self._ui.staticText_SkillName:SetText(skillSSW:getName())
    self._ui.staticText_SkillDesc:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    self._ui.staticText_SkillDesc:setLineCountByLimitAutoWrap(1)
    self._ui.staticText_SkillDesc:SetText(skillTypeSSW:getDescription())
    self._ui.static_SkilllIcon:ChangeTextureInfoName("Icon/" .. skillTypeSSW:getIconPath())
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_SkilllIcon, 0, 0, 44, 44)
    self._ui.static_SkilllIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.static_SkilllIcon:setRenderTexture(self._ui.static_SkilllIcon:getBaseTexture())
    self._ui.static_SelectedSkillIcon:ChangeTextureInfoName("Icon/" .. skillTypeSSW:getIconPath())
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_SelectedSkillIcon, 0, 0, 44, 44)
    self._ui.static_SelectedSkillIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.static_SelectedSkillIcon:setRenderTexture(self._ui.static_SelectedSkillIcon:getBaseTexture())
  end
end
function SkillSpecialize:goPage2(step)
  if nil == step then
    self._value.currentStep = self._enum.eStepBase
  elseif step <= self._enum.eStepSelectEffect2 and step >= self._enum.eStepBase then
    self._value.currentStep = step
  end
  self._value.currentPage = 1
  self:setContent()
end
function SkillSpecialize:changeTexturePage1Button(button, _type)
  local IconType = self._texture[_type]
  button:ChangeTextureInfoName(self._texture.page1ButtonTexture)
  local x1, y1, x2, y2 = setTextureUV_Func(button, IconType.x1, IconType.y1, IconType.x2, IconType.y2)
  button:getBaseTexture():setUV(x1, y1, x2, y2)
  button:setRenderTexture(button:getBaseTexture())
end
function SkillSpecialize:getSkillAwakeningType(buttonIndex)
  local _type = 0
  if buttonIndex >= 3 then
    _type = 1
  end
  return _type
end
function PaGlobalFunc_Dialog_SkillAwakenResult_ShowAni()
end
function PaGlobalFunc_Dialog_SkillAwakenResult_HideAni()
end
function PaGlobalFunc_Dialog_SkillSpecialize_Open(showAni)
end
function PaGlobalFunc_Dialog_SkillSpecialize_OnPadB()
end
function PaGlobalFunc_Dialog_SkillSpecialize_Close(showAni)
  _panel:SetShow(false)
end
function PaGlobalFunc_Dialog_SkillSpecialize_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_Dialog_SkillSpecialize_Exit()
  if true == PaGlobalFunc_Dialog_SkillSpecialize_GetShow() then
    AlertPanel:SetShow(false, true)
    PaGlobalFunc_Dialog_SkillSpecialize_Close(true)
    return true
  end
  return false
end
function PaGlobalFunc_Dialog_SkillSpecialize_Page1_OverSkillButton(buttonIndex)
  local self = SkillSpecialize
  local control = self._ui.rbtn_List_ChangeSkill[buttonIndex]
  if true == control.staticText_Skill_Desc:IsLimitText() and true == control.staticText_Skill_Desc:GetShow() then
    self._ui.static_Skill_Desc_Popup:SetShow(true)
    local defaultPosY = self._ui.static_Skill_Specialize1:GetPosY() + control.radiobutton:GetPosY()
    local posY = control.staticText_Skill_Desc:GetPosY() + control.staticText_Skill_Desc:GetSizeY() + defaultPosY
    self._ui.static_Skill_Desc_Popup:SetPosY(posY)
    local skillDesc = control.staticText_Skill_Desc:GetText()
    self._ui.staticText_Skill_Desc_Popup:SetText(skillDesc)
    local sizeY = self._ui.staticText_Skill_Desc_Popup:GetTextSizeY() + 20
    self._ui.static_Skill_Desc_Popup:SetSize(self._ui.static_Skill_Desc_Popup:GetSizeX(), sizeY)
  else
    self._ui.static_Skill_Desc_Popup:SetShow(false)
  end
  if true == control.staticText_Skill_Effect:IsLimitText() and true == control.staticText_Skill_Effect:GetShow() then
    self._ui.static_SkillEffectDesc_Popup:SetShow(true)
    local defaultPosY = self._ui.static_Skill_Specialize1:GetPosY() + control.radiobutton:GetPosY()
    local posY = control.staticText_Skill_Effect:GetPosY() + control.staticText_Skill_Effect:GetSizeY() + defaultPosY
    self._ui.static_SkillEffectDesc_Popup:SetPosY(posY)
    local skillDesc = control.staticText_Skill_Effect:GetText()
    self._ui.staticText_SkillEffectDesc_Popup:SetText(skillDesc)
    local sizeY = self._ui.staticText_SkillEffectDesc_Popup:GetTextSizeY() + 20
    self._ui.static_SkillEffectDesc_Popup:SetSize(self._ui.static_SkillEffectDesc_Popup:GetSizeX(), sizeY)
  else
    self._ui.static_SkillEffectDesc_Popup:SetShow(false)
  end
  if self._value.currentSpecializeIndex == buttonIndex then
    return
  end
  self._value.lastSpecializeIndex = self._value.currentSpecializeIndex
  self._value.currentSpecializeIndex = buttonIndex
  if nil ~= self._value.lastSpecializeIndex then
    self._ui.rbtn_List[self._value.lastSpecializeIndex].radiobutton:SetCheck(false)
  end
  if nil ~= self._value.currentSpecializeIndex then
    self._ui.rbtn_List[self._value.currentSpecializeIndex].radiobutton:SetCheck(true)
  end
  self:updateKeyGuide(0)
end
function PaGlobalFunc_Dialog_SkillSpecialize_ChangeSkill()
  local self = SkillSpecialize
  if nil == self._value.currentSpecializeIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_NOSKILL"))
    return
  end
  self._ui.static_Skill_Desc_Popup:SetShow(false)
  self._ui.static_SkillEffectDesc_Popup:SetShow(false)
  local control = self._ui.rbtn_List[self._value.currentSpecializeIndex]
  if nil ~= control.reinforceIndex then
    local skillSSW = ToClient_GetReAwakeningListAt(control.reinforceIndex)
    local skillNo = skillSSW:getSkillNo()
    if nil ~= skillNo then
      local selfPlayer = getSelfPlayer()
      if nil == selfPlayer then
        return
      end
      local applyAwakenSkillReset = selfPlayer:get():isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_UnlimitedSkillAwakening)
      local inventory = selfPlayer:get():getInventory()
      local hasMemoryFlag = inventory:getItemCount_s64(ItemEnchantKey(44195, 0))
      if toInt64(0, 0) == hasMemoryFlag and not applyAwakenSkillReset then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_REINFORCE_NEEDITEM"))
        return
      end
    end
    self._value.currnetReinforceIndex = control.reinforceIndex
  end
  local _type = self:getSkillAwakeningType(self._value.currentSpecializeIndex)
  local reinforcableCount = ToClient_GetAwakeningListCount()
  local count = 0
  for index = 0, reinforcableCount - 1 do
    local skillSSW = ToClient_GetAwakeningListAt(index)
    if _type == skillSSW:getSkillAwakeningType() then
      count = count + 1
    end
  end
  if 0 ~= count then
    self:goPage2()
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_NOSKILL"))
    return
  end
end
function PaGlobalFunc_Dialog_SkillSpecialize_ChangeEffect()
  local self = SkillSpecialize
  if nil == self._value.currentSpecializeIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_NOSKILL"))
    return
  end
  self._ui.static_Skill_Desc_Popup:SetShow(false)
  self._ui.static_SkillEffectDesc_Popup:SetShow(false)
  local control = self._ui.rbtn_List[self._value.currentSpecializeIndex]
  if nil ~= control.reinforceIndex then
    local skillSSW = ToClient_GetReAwakeningListAt(control.reinforceIndex)
    if nil == skillSSW then
      return
    end
    local skillNo = skillSSW:getSkillNo()
    if nil ~= skillNo then
      local selfPlayer = getSelfPlayer()
      if nil == selfPlayer then
        return
      end
      local applyAwakenSkillReset = selfPlayer:get():isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_UnlimitedSkillAwakening)
      local inventory = selfPlayer:get():getInventory()
      local hasMemoryFlag = inventory:getItemCount_s64(ItemEnchantKey(44195, 0))
      if toInt64(0, 0) == hasMemoryFlag and not applyAwakenSkillReset then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_REINFORCE_NEEDITEM"))
        return
      end
      local SkillSSW = getSkillStaticStatus(skillNo, 1)
      if nil == SkillSSW then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_NOINFO"))
        return
      end
      local ActiveSkillWrapper = SkillSSW:getActiveSkillStatus()
      if nil == ActiveSkillWrapper then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_ALERT"))
        return
      end
    end
    self._value.currnetReinforceIndex = control.reinforceIndex
    self:goPage2(self._enum.eStepSelectSkill)
  end
end
function PaGlobalFunc_Dialog_SkillSpecialize_Page2SkillListCreate(list_content, key)
  local self = SkillSpecialize
  local _key = Int64toInt32(key)
  local radioButton_Skill = UI.getChildControl(list_content, "RadioButton_Skill_Template")
  local static_SkilllIcon = UI.getChildControl(radioButton_Skill, "Static_SkilllIcon_Template")
  local staticText_SkillName = UI.getChildControl(radioButton_Skill, "StaticText_SkillName_Template")
  local staticText_SkillDesc = UI.getChildControl(radioButton_Skill, "StaticText_SkillDesc_Template")
  radioButton_Skill:SetCheck(_key == self._value.currentSelectSkillIndex)
  staticText_SkillDesc:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  local _type = self:getSkillAwakeningType(self._value.currentSpecializeIndex)
  local reinforcableCount = ToClient_GetAwakeningListCount()
  local count = 0
  for index = 0, reinforcableCount - 1 do
    local skillSSW = ToClient_GetAwakeningListAt(index)
    if _type == skillSSW:getSkillAwakeningType() then
      if count == _key then
        local skillTypeSSW = skillSSW:getSkillTypeStaticStatusWrapper()
        skillNo = skillSSW:getSkillNo()
        staticText_SkillName:SetText(tostring(skillSSW:getName()))
        staticText_SkillDesc:SetText(tostring(skillTypeSSW:getDescription()))
        static_SkilllIcon:ChangeTextureInfoName("Icon/" .. skillTypeSSW:getIconPath())
        radioButton_Skill:addInputEvent("Mouse_LUp", "PaGlobalFunc_Dialog_SkillSpecialize_SelectSkill(" .. skillNo .. ", " .. index .. ")")
        break
      end
      count = count + 1
    end
  end
end
function PaGlobalFunc_Dialog_SkillSpecialize_Page2EffectListCreate(list_content, key)
  local self = SkillSpecialize
  local _key = Int64toInt32(key)
  local radioButton_Effect = UI.getChildControl(list_content, "RadioButton_Effect1_Template")
  if self._value.currentStep == self._enum.eStepSelectSkill then
    radioButton_Effect:SetCheck(_key == self._value.currentEffectIndex)
  elseif self._value.currentStep == self._enum.eStepSelectEffect1 then
    radioButton_Effect:SetCheck(_key == self._value.currentEffectIndex2)
  end
  local skillSSW = getSkillStaticStatus(self._value.currentReinforceSkillNo, 1)
  local activeSkillSS = skillSSW:getActiveSkillStatus()
  radioButton_Effect:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  radioButton_Effect:setLineCountByLimitAutoWrap(2)
  if nil ~= activeSkillSS then
    local optionCount = activeSkillSS:getSkillAwakenInfoCount()
    local count = 0
    local _key = Int64toInt32(key)
    for index = 0, optionCount - 1 do
      if index == _key then
        radioButton_Effect:SetText(tostring(activeSkillSS:getSkillAwakenDescription(index)))
        radioButton_Effect:SetTextSpan(10, (radioButton_Effect:GetSizeY() - radioButton_Effect:GetTextSizeY()) * 0.5)
        radioButton_Effect:addInputEvent("Mouse_LUp", "PaGlobalFunc_Dialog_SkillSpecialize_SelectEffect(" .. index .. ")")
      end
    end
  end
end
function PaGlobalFunc_Dialog_SkillSpecialize_SelectSkill(skillNo, index)
  local self = SkillSpecialize
  if self._value.currentStep ~= self._enum.eStepBase then
    return
  end
  self._value.currentSelectSkillIndex = index
  self._value.currentReinforceSkillNo = skillNo
  self._toIndex = self._ui.list2_1_SelectSkill:getCurrenttoIndex()
  if false == self._ui.list2_1_SelectSkill:IsIgnoreVerticalScroll() then
    self._scrollValue = self._vscroll:GetControlPos()
  end
  self:setPage2SelectedSkill(skillNo)
  PaGlobalFunc_Dialog_SkillSpecialize_GoNextStepPage2()
end
function PaGlobalFunc_Dialog_SkillSpecialize_SelectEffect(index)
  local self = SkillSpecialize
  if self._value.currentStep == self._enum.eStepSelectSkill then
    self._value.currentEffectIndex = index
  elseif self._value.currentStep == self._enum.eStepSelectEffect1 then
    self._value.currentEffectIndex2 = index
  end
  PaGlobalFunc_Dialog_SkillSpecialize_GoNextStepPage2()
end
function PaGlobalFunc_Dialog_SkillSpecialize_GoNextStepPage2()
  local self = SkillSpecialize
  local nextStep
  if self._value.currentStep == self._enum.eStepBase then
    if nil == self._value.currentReinforceSkillNo then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTSKILL"))
      return
    end
    self._value.currentStep = self._enum.eStepSelectSkill
    self:setContentPage2(self._value.currentStep)
    return
  end
  if self._value.currentStep == self._enum.eStepSelectSkill then
    if nil == self._value.currentEffectIndex then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTFIRSTOPTION"))
      return
    end
    self._value.currentStep = self._enum.eStepSelectEffect1
    self:setContentPage2(self._value.currentStep)
    return
  end
  if self._value.currentStep == self._enum.eStepSelectEffect1 then
    if nil == self._value.currentEffectIndex then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTSECONDOPTION"))
      return
    end
    self._value.currentStep = self._enum.eStepSelectEffect2
    self:setContentPage2(self._value.currentStep)
    PaGlobalFunc_Dialog_SkillSpecialize_Doit()
    return
  end
  if self._value.currentStep == self._enum.eStepSelectEffect2 then
  end
end
function PaGlobalFunc_Dialog_SkillSpecialize_GoBackStepPage2()
  local self = SkillSpecialize
  if self._value.currentStep == self._enum.eStepBase then
    self:initValuePage2()
    self:goPage1()
    return false
  end
  if self._value.currentStep == self._enum.eStepSelectSkill then
    if nil == self._value.currentSelectSkillIndex then
      self:initValuePage2()
      self:goPage1()
      return false
    end
    self._value.currentSelectSkillIndex = nil
    self._value.currentReinforceSkillNo = nil
    self._value.currentStep = self._enum.eStepBase
    self:setContentPage2(self._value.currentStep)
    self._ui.list2_1_SelectSkill:setCurrenttoIndex(self._toIndex)
    if false == self._ui.list2_1_SelectSkill:IsIgnoreVerticalScroll() then
      self._vscroll:SetControlPos(self._scrollValue)
    end
    return false
  end
  if self._value.currentStep == self._enum.eStepSelectEffect1 then
    self._value.currentEffectIndex = nil
    self._value.currentStep = self._enum.eStepSelectSkill
    self:setContentPage2(self._value.currentStep)
    return false
  end
  if self._value.currentStep == self._enum.eStepSelectEffect2 then
    self._value.currentEffectIndex2 = nil
    self._value.currentStep = self._enum.eStepSelectEffect1
    self:setContentPage2(self._value.currentStep)
    return false
  end
end
function PaGlobalFunc_Dialog_SkillSpecialize_Doit()
  local self = SkillSpecialize
  function getEffectText(effectIndex)
    local skillSSW = getSkillStaticStatus(self._value.currentReinforceSkillNo, 1)
    local activeSkillSS = skillSSW:getActiveSkillStatus()
    if nil ~= activeSkillSS then
      return tostring(activeSkillSS:getSkillAwakenDescription(effectIndex))
    end
  end
  if nil == self._value.currnetReinforceIndex then
    if nil == self._value.currentSelectSkillIndex then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTSKILL"))
      return
    end
    if nil == self._value.currentEffectIndex then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTFIRSTOPTION"))
      return
    end
    if nil == self._value.currentEffectIndex2 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTSECONDOPTION"))
      return
    end
    local function doActual()
      ToClient_RequestSkillAwakening(self._value.currentSelectSkillIndex, self._value.currentEffectIndex, self._value.currentEffectIndex2)
    end
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILLAWAKEN_AWAKENTITLE"),
      content = getEffectText(self._value.currentEffectIndex) .. "\n" .. getEffectText(self._value.currentEffectIndex2),
      functionYes = doActual,
      functionNo = PaGlobalFunc_Dialog_SkillSpecialize_OnPadB
    }
    MessageBox.showMessageBox(messageBoxData)
  elseif nil == self._value.currentSelectSkillIndex then
    if nil == self._value.currentEffectIndex then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTFIRSTOPTION"))
      return
    end
    if nil == self._value.currentEffectIndex2 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTSECONDOPTION"))
      return
    end
    ToClient_RequestChangeAwakeningBitFlag(self._value.currnetReinforceIndex, self._value.currentEffectIndex, self._value.currentEffectIndex2)
  else
    if nil == self._value.currentEffectIndex then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTFIRSTOPTION"))
      return
    end
    if nil == self._value.currentEffectIndex2 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREINFORCE_SELECTSECONDOPTION"))
      return
    end
    local function doActual()
      ToClient_RequestChangeAwakeningSkill(self._value.currnetReinforceIndex, self._value.currentSelectSkillIndex, self._value.currentEffectIndex, self._value.currentEffectIndex2)
    end
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILLAWAKEN_AWAKENTITLE"),
      content = getEffectText(self._value.currentEffectIndex) .. "\n" .. getEffectText(self._value.currentEffectIndex2),
      functionYes = doActual,
      functionNo = PaGlobalFunc_Dialog_SkillSpecialize_OnPadB
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function PaGlobalFunc_Dialog_SkillSpecialize_Reinforcable_SkillCount(_type)
  local reinforcableCount = ToClient_GetAwakeningListCount()
  if reinforcableCount > 0 then
    local count = 0
    for index = 0, reinforcableCount - 1 do
      local skillSSW = ToClient_GetAwakeningListAt(index)
      if _type == skillSSW:getSkillAwakeningType() then
        count = count + 1
      end
    end
    return count
  else
    return reinforcableCount
  end
end
function FromClient_Init_Dialog_SkillSpecialize()
  local self = SkillSpecialize
  self:initialize()
  self:resize()
end
function FromClient_Dialog_SkillSpecialize_Show()
  if not ToClient_IsContentsGroupOpen("203") then
    return
  end
  local self = SkillSpecialize
  self:preOpen()
  self:setContent()
  self:open(true)
end
local isResultHideTime = 0
function FromClient_SuccessSkillSpecialize(skillNo, level)
  if not ToClient_IsContentsGroupOpen("203") then
    return
  end
  AlertPanel:SetSize(getScreenSizeX(), getScreenSizeY())
  AlertPanel:SetPosX(0)
  AlertPanel:SetPosY(20)
  local skillStatic = getSkillStaticStatus(skillNo, 1)
  local activeSkillSS
  if skillStatic:isActiveSkillHas() then
    activeSkillSS = getActiveSkillStatus(skillStatic)
    if nil == activeSkillSS then
      AlertPanel:SetShow(false, false)
    else
      local awakeInfo = ""
      local awakeningDataCount = activeSkillSS:getSkillAwakenInfoCount() - 1
      for index = 0, awakeningDataCount do
        local skillInfo = activeSkillSS:getSkillAwakenInfo(index)
        if "" ~= skillInfo then
          awakeInfo = awakeInfo .. "\n" .. skillInfo
        end
      end
      isResultHideTime = 0
      AlertPanel:SetShow(true, true)
      AlertPanel:SetAlpha(0)
      UIAni.AlphaAnimation(1, AlertPanel, 0, 0.3)
      result._awakenOption:SetText("<PAColor0xffdadada>" .. tostring(awakeInfo) .. "<PAOldColor>")
      result._awakenResult_BG:SetPosX(0)
      result._awakenTitle:ComputePos()
      result._awakenOption:ComputePos()
      acquireSizeY = result._awakenTitle:GetSizeY() + result._awakenOption:GetTextSizeY() + 85
      result._awakenResult_BG:SetSize(getScreenSizeX(), acquireSizeY)
    end
  end
  FromClient_Dialog_SkillSpecialize_Show()
end
function SkillReinforceResult_Hide(deltaTime)
  isResultHideTime = isResultHideTime + deltaTime
  if isResultHideTime > 5 then
    AlertPanel:SetShow(false, true)
    isResultHideTime = 0
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_Init_Dialog_SkillSpecialize")
