local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
Panel_Window_PetListNew:SetShow(false)
Panel_Window_PetListNew:setGlassBackground(true)
Panel_Window_PetListNew:ActiveMouseEventEffect(true)
local isPlayOpen = ToClient_IsContentsGroupOpen("256")
local marketTest = false
local petSkillPlus = true
local petComposeChange = true
local maxUnsealCount = ToClient_getPetUseMaxCount()
local temporaryPCRoomWrapper = getTemporaryInformationWrapper()
local isPremiumPcRoom = temporaryPCRoomWrapper:isPremiumPcRoom()
if isPremiumPcRoom then
  maxUnsealCount = maxUnsealCount + ToClient_getPetUseMaxCountPcRoom()
end
local gradeColorConfig = {
  [0] = Defines.Color.C_FFEFEFEF,
  [1] = Defines.Color.C_FFB5FF6D,
  [2] = Defines.Color.C_FF008AFF,
  [3] = Defines.Color.C_FFFFCE22
}
local petRaceCount = {
  [1] = "\234\179\160\236\150\145\236\157\180",
  [2] = "\234\176\156",
  [3] = "\235\167\164",
  [4] = "\237\142\173\234\183\132",
  [5] = "\236\130\172\235\167\137\236\151\172\236\154\176",
  [6] = "\234\179\160\236\138\180\235\143\132\236\185\152",
  [7] = "\235\136\136\236\130\172\235\158\140",
  [8] = "\234\179\160\236\138\180\235\143\132\236\185\152",
  [9] = "\236\152\164\235\170\169\235\136\136\236\157\180",
  [10] = "\235\160\155\236\132\156\237\140\172\235\141\148",
  [11] = "\236\149\181\235\172\180\236\131\136",
  [12] = "\235\182\129\234\183\185\234\179\176",
  [13] = "\235\143\140\235\167\168\234\178\140",
  [14] = "\236\157\180\235\178\164\237\138\184\237\149\160\235\161\156\236\156\1361",
  [15] = "\236\157\180\235\178\164\237\138\184\237\149\160\235\161\156\236\156\1362",
  [16] = "\236\157\180\235\178\164\237\138\184\237\149\160\235\161\156\236\156\1363",
  [17] = "\236\157\180\235\178\164\237\138\184\237\149\160\235\161\156\236\156\1364",
  [18] = "\236\157\180\235\178\164\237\138\184\237\149\160\235\161\156\236\156\1365",
  [19] = "\236\157\180\235\178\164\237\138\184\237\149\160\235\161\156\236\156\1366",
  [20] = "\236\150\180\235\166\176 \236\150\145",
  [22] = "\234\185\140\235\167\136\234\183\128",
  [23] = "\235\170\172\236\138\164\237\132\176\237\142\171 \236\158\132\236\139\156",
  [24] = "\235\167\136\235\169\139",
  [25] = "\236\151\144\236\150\180\235\166\172\236\138\164",
  [26] = "\235\163\168\235\143\140\237\148\132",
  [27] = "\235\182\137\236\157\128\236\152\164\237\129\172",
  [28] = "\234\179\168\235\160\152",
  [29] = "\235\130\152\235\172\180 \236\160\149\235\160\185",
  [30] = "\237\130\164\235\169\148\235\157\188",
  [31] = "\236\188\132\237\131\128\236\154\176\235\161\156\236\138\164",
  [32] = "\236\185\180\235\167\136\236\139\164\235\185\132\236\149\132 \235\182\136\234\179\176",
  [33] = "\236\149\132\235\172\180\234\177\176\235\130\15211",
  [34] = "\236\149\132\235\172\180\234\177\176\235\130\15212",
  [35] = "\236\149\132\235\172\180\234\177\176\235\130\15213",
  [36] = "\236\149\132\235\172\180\234\177\176\235\130\15214",
  [37] = "\236\149\132\235\172\180\234\177\176\235\130\15215",
  [38] = "\236\149\132\235\172\180\234\177\176\235\130\15216",
  [39] = "\236\149\132\235\172\180\234\177\176\235\130\15217",
  [40] = "\236\149\132\235\172\180\234\177\176\235\130\15218",
  [41] = "\236\149\132\235\172\180\234\177\176\235\130\15219",
  [42] = "\236\149\132\235\172\180\234\177\176\235\130\15220",
  [43] = "\236\149\132\235\172\180\234\177\176\235\130\15221",
  [44] = "\236\149\132\235\172\180\234\177\176\235\130\15222",
  [45] = "\236\149\132\235\172\180\234\177\176\235\130\15223",
  [46] = "\236\149\132\235\172\180\234\177\176\235\130\15224",
  [47] = "\236\149\132\235\172\180\234\177\176\235\130\15225",
  [48] = "\236\149\132\235\172\180\234\177\176\235\130\15226",
  [49] = "\236\149\132\235\172\180\234\177\176\235\130\15227",
  [50] = "\236\149\132\235\172\180\234\177\176\235\130\15228",
  [51] = "\236\149\132\235\172\180\234\177\176\235\130\15229",
  [52] = "\236\149\132\235\172\180\234\177\176\235\130\15230",
  [53] = "\236\149\132\235\172\180\234\177\176\235\130\15231",
  [54] = "\236\149\132\235\172\180\234\177\176\235\130\15232",
  [55] = "\236\149\132\235\172\180\234\177\176\235\130\15233",
  [56] = "\236\149\132\235\172\180\234\177\176\235\130\15234",
  [57] = "\236\149\132\235\172\180\234\177\176\235\130\15235",
  [58] = "\236\149\132\235\172\180\234\177\176\235\130\15236",
  [59] = "\236\149\132\235\172\180\234\177\176\235\130\15237",
  [60] = "\236\149\132\235\172\180\234\177\176\235\130\15238",
  [61] = "\236\149\132\235\172\180\234\177\176\235\130\15239",
  [62] = "\236\149\132\235\172\180\234\177\176\235\130\15240",
  [63] = "\236\149\132\235\172\180\234\177\176\235\130\15241",
  [64] = "\236\149\132\235\172\180\234\177\176\235\130\15242",
  [65] = "\236\149\132\235\172\180\234\177\176\235\130\15243",
  [66] = "\236\149\132\235\172\180\234\177\176\235\130\15244",
  [67] = "\236\149\132\235\172\180\234\177\176\235\130\15245",
  [68] = "\236\149\132\235\172\180\234\177\176\235\130\15246",
  [69] = "\236\149\132\235\172\180\234\177\176\235\130\15247",
  [70] = "\236\149\132\235\172\180\234\177\176\235\130\15248",
  [71] = "\236\149\132\235\172\180\234\177\176\235\130\15249",
  [72] = "\236\149\132\235\172\180\234\177\176\235\130\15250",
  [73] = "\236\149\132\235\172\180\234\177\176\235\130\15251",
  [74] = "\236\149\132\235\172\180\234\177\176\235\130\15252",
  [75] = "\236\149\132\235\172\180\234\177\176\235\130\15253",
  [76] = "\236\149\132\235\172\180\234\177\176\235\130\15254",
  [77] = "\236\149\132\235\172\180\234\177\176\235\130\15255",
  [78] = "\236\149\132\235\172\180\234\177\176\235\130\15256",
  [79] = "\236\149\132\235\172\180\234\177\176\235\130\15257",
  [80] = "\236\149\132\235\172\180\234\177\176\235\130\15258",
  [81] = "\236\149\132\235\172\180\234\177\176\235\130\15259",
  [82] = "\236\149\132\235\172\180\234\177\176\235\130\15260",
  [83] = "\236\149\132\235\172\180\234\177\176\235\130\15261",
  [84] = "\236\149\132\235\172\180\234\177\176\235\130\15262",
  [85] = "\236\149\132\235\172\180\234\177\176\235\130\15263",
  [86] = "\236\149\132\235\172\180\234\177\176\235\130\15264",
  [87] = "\236\149\132\235\172\180\234\177\176\235\130\15265",
  [88] = "\236\149\132\235\172\180\234\177\176\235\130\15266",
  [89] = "\236\149\132\235\172\180\234\177\176\235\130\15267",
  [90] = "\236\149\132\235\172\180\234\177\176\235\130\15268",
  [91] = "\236\149\132\235\172\180\234\177\176\235\130\15269",
  [92] = "\236\149\132\235\172\180\234\177\176\235\130\15270",
  [93] = "\236\149\132\235\172\180\234\177\176\235\130\15271",
  [94] = "\236\149\132\235\172\180\234\177\176\235\130\15272",
  [95] = "\236\149\132\235\172\180\234\177\176\235\130\15273",
  [96] = "\236\149\132\235\172\180\234\177\176\235\130\15274",
  [97] = "\236\149\132\235\172\180\234\177\176\235\130\15275",
  [98] = "\236\149\132\235\172\180\234\177\176\235\130\15276",
  [99] = "\237\149\169\236\132\177\236\154\169 \237\142\171"
}
local isPetFlyPet = {
  [1] = 3,
  [2] = 9,
  [3] = 11,
  [4] = 15
}
checkUnSealGroupList = {
  [1] = {},
  [2] = {},
  [3] = {}
}
local checkUnSealList = {}
local PetList = {
  BTN_Close = UI.getChildControl(Panel_Window_PetListNew, "Button_Win_Close"),
  BTN_Compose = UI.getChildControl(Panel_Window_PetListNew, "Button_Compose"),
  BTN_FeedAll = UI.getChildControl(Panel_Window_PetListNew, "Button_FeedingAll"),
  BTN_AllUnSeal = UI.getChildControl(Panel_Window_PetListNew, "Button_AllUnSeal"),
  BTN_GroupSeal1 = UI.getChildControl(Panel_Window_PetListNew, "Button_AllSeal_Group1"),
  BTN_GroupSeal2 = UI.getChildControl(Panel_Window_PetListNew, "Button_AllSeal_Group2"),
  BTN_GroupSeal3 = UI.getChildControl(Panel_Window_PetListNew, "Button_AllSeal_Group3"),
  BTN_ClearGroup = UI.getChildControl(Panel_Window_PetListNew, "Button_ClearGroup"),
  BTN_Market = UI.getChildControl(Panel_Window_PetListNew, "Button_Market"),
  list2_PetList = UI.getChildControl(Panel_Window_PetListNew, "List2_PetList"),
  feedUi = UI.getChildControl(Panel_Window_PetListNew, "Static_FeedingBg"),
  feedAllUi = Panel_PetRestoreAll,
  skillInfoBg = UI.getChildControl(Panel_Window_PetListNew, "Static_SkillInfoBg"),
  filterBg = UI.getChildControl(Panel_Window_PetListNew, "Static_FilterBg"),
  BTN_pcRoomRegist = UI.getChildControl(Panel_Window_PetListNew, "Button_RegistPCRoom"),
  orderBg = UI.getChildControl(Panel_Window_PetListNew, "Static_Bg_Des"),
  groupTitle = UI.getChildControl(Panel_Window_PetListNew, "StaticText_GroupTitle"),
  listMaxCount = 5,
  listUIPool = {},
  SealDATACount = 0,
  UnSealDataCount = 0,
  orderList = {
    _follow = {},
    _find = {},
    _getItem = {}
  },
  _nowSelectGroup = 0,
  feedingPetIndex = 0,
  feedStaticItemCount = ToClient_Pet_GetFeedStaticItemCount(),
  cachedUserFeedItemCount = 0,
  feedSlot = {},
  feedAllSlot = {},
  config = {createBorder = true, createCount = true},
  selectItemIndex = -1,
  selectSlotBg = nil,
  selectAllSlotBg = nil
}
PetList.BTN_GroupSeal1:addInputEvent("Mouse_On", "PetListNew_SimpleTooltip( true, 0 )")
PetList.BTN_GroupSeal1:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltip( false )")
PetList.BTN_GroupSeal2:addInputEvent("Mouse_On", "PetListNew_SimpleTooltip( true, 1 )")
PetList.BTN_GroupSeal2:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltip( false )")
PetList.BTN_GroupSeal3:addInputEvent("Mouse_On", "PetListNew_SimpleTooltip( true, 2 )")
PetList.BTN_GroupSeal3:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltip( false )")
PetList.BTN_ClearGroup:addInputEvent("Mouse_On", "PetListNew_SimpleTooltip( true, 3 )")
PetList.BTN_ClearGroup:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltip( false )")
PetList.BTN_AllUnSeal:SetShow(not marketTest)
PetList.BTN_Market:SetShow(marketTest)
PetList.BTN_ClearGroup:addInputEvent("Mouse_LUp", "HandleClicked_PetGroupClear()")
local _buttonQuestion = UI.getChildControl(Panel_Window_PetListNew, "Button_Question")
_buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"Pet\" )")
_buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"Pet\", \"true\")")
_buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"Pet\", \"false\")")
local _checkButtonPopup = UI.getChildControl(Panel_Window_PetListNew, "CheckButton_PopUp")
_checkButtonPopup:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetList_PopUp()")
_checkButtonPopup:addInputEvent("Mouse_On", "PaGlobalFunc_PetList_PopUp_ShowToolTip(true)")
_checkButtonPopup:addInputEvent("Mouse_Out", "PaGlobalFunc_PetList_PopUp_ShowToolTip(false)")
local maxskillTypeCount = 21
local skillTypeString = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_0"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_2"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_3"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_4"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_5"),
  [6] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_6"),
  [7] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_7"),
  [8] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_8"),
  [9] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_9"),
  [10] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_10"),
  [11] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_11"),
  [12] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_12"),
  [13] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_13"),
  [14] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_14"),
  [15] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_15"),
  [16] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_16"),
  [17] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_17"),
  [18] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_18"),
  [19] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_19"),
  [20] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_20")
}
local gradeTypeUV = {
  [0] = {
    193,
    332,
    275,
    350
  },
  [1] = {
    193,
    313,
    275,
    331
  },
  [2] = {
    133,
    351,
    215,
    369
  },
  [3] = {
    110,
    332,
    192,
    350
  },
  [4] = {
    110,
    313,
    192,
    331
  }
}
local plusPoint = {
  [0] = 7,
  [1] = 5,
  [2] = 5,
  [4] = 4,
  [5] = 20
}
local skillInfo = {
  plusCount = {},
  skillTypeCount = {}
}
local petSkillList = {}
function PetList:SkillInfoInit()
  petSkillList.desc = UI.getChildControl(self.skillInfoBg, "StaticText_SkillListDesc")
  petSkillList.baseSkillTitle = UI.getChildControl(self.skillInfoBg, "StaticText_BaseSkillListTitle")
  petSkillList.baseSkillText = UI.getChildControl(self.skillInfoBg, "StaticText_BaseSkillList")
  petSkillList.subTitle = UI.getChildControl(self.skillInfoBg, "StaticText_SkillList_Title")
  petSkillList.textList = UI.getChildControl(self.skillInfoBg, "StaticText_SkillList")
  petSkillList.title = UI.getChildControl(self.skillInfoBg, "StaticText_SkillListTitle")
end
function petSkillList_Show()
  if not petSkillPlus then
    return
  end
  for key, control in pairs(petSkillList) do
    control:SetShow(true)
  end
end
function petSkillList_Close()
  for key, control in pairs(petSkillList) do
    control:SetShow(false)
  end
end
local baseSkillTypeString = {
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_BASESKILLTYPE1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_BASESKILLTYPE2"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_BASESKILLTYPE3"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_BASESKILLTYPE4"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_BASESKILLTYPE5"),
  [6] = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_BASESKILLTYPE6"),
  [7] = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_BASESKILLTYPE7"),
  [8] = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_BASESKILLTYPE8"),
  [9] = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_BASESKILLTYPE9"),
  [10] = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_BASESKILLTYPE10"),
  [11] = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_BASESKILLTYPE11"),
  [12] = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_BASESKILLTYPE12")
}
local baseSkillTypeUnit = {
  [1] = "",
  [2] = "",
  [3] = "%",
  [4] = "%",
  [5] = "%",
  [6] = "%",
  [7] = "%",
  [8] = "%",
  [9] = "%",
  [10] = "%",
  [11] = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_BASESKILLTYPEUNIT_SECOND"),
  [12] = "LT"
}
local baseSkillMultiplePoint = {
  [1] = 25,
  [2] = 10,
  [3] = 1,
  [4] = 1,
  [5] = 1,
  [6] = 1,
  [7] = 1,
  [8] = 1,
  [9] = 5,
  [10] = 1,
  [11] = 5,
  [12] = 10
}
function AmountPetSkill_Attribute(count)
  if 0 == count then
    PetList.skillInfoBg:SetShow(false)
    return
  end
  PetList.skillInfoBg:SetShow(true)
  petSkillList_Show()
  local self = petSkillList
  local baseSkillPoint = {}
  for initIndex = 1, #baseSkillTypeString do
    baseSkillPoint[initIndex] = 0
  end
  for index = 0, count - 1 do
    local PcPetData = ToClient_getPetUnsealedDataByIndex(index)
    if nil == PcPetData then
      return
    end
    local baseSkillIndex = PcPetData:getPetBaseSkillIndex()
    local unsealPetSkillStaticStatus = ToClient_getPetBaseSkillStaticStatus(baseSkillIndex)
    local groupNo = ToClient_getBaseSkillGroupNo(baseSkillIndex)
    local petTier = baseSkillIndex % 5 + 1
    baseSkillPoint[groupNo] = baseSkillPoint[groupNo] + baseSkillMultiplePoint[groupNo] * petTier
    if 9 == groupNo then
      baseSkillPoint[groupNo + 1] = baseSkillPoint[groupNo + 1] + baseSkillMultiplePoint[groupNo + 1] * petTier
    elseif 12 == groupNo then
      baseSkillPoint[groupNo] = baseSkillPoint[groupNo] + 10
    end
  end
  local baseSkillString = ""
  for groupIndex = 1, #baseSkillTypeString do
    if baseSkillPoint[groupIndex] > 0 then
      if "" == baseSkillString then
        baseSkillString = "- " .. baseSkillTypeString[groupIndex] .. baseSkillPoint[groupIndex] .. baseSkillTypeUnit[groupIndex]
      else
        baseSkillString = baseSkillString .. [[

- ]] .. baseSkillTypeString[groupIndex] .. baseSkillPoint[groupIndex] .. baseSkillTypeUnit[groupIndex]
      end
    end
  end
  self.baseSkillText:SetText(baseSkillString)
  local textSizeY = self.baseSkillText:GetTextSizeY()
  local infgBgSizeY = self.baseSkillText:GetPosY() + textSizeY + 20
  local skillMaxCount = ToClient_getPetEquipSkillMax()
  for index = 0, count - 1 do
    local PcPetData = ToClient_getPetUnsealedDataByIndex(index)
    if nil == PcPetData then
      return
    end
    for skill_idx = 0, skillMaxCount - 1 do
      local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
      local isLearn = PcPetData:isPetEquipSkillLearned(skill_idx)
      if true == isLearn and nil ~= skillStaticStatus then
        local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
        if nil ~= skillTypeStaticWrapper then
          PetSkillTypeCheck1(skill_idx)
        end
      end
    end
  end
  local petSkillGrade = ""
  local petSkillGradeText = ""
  local hasSkill = false
  for skillTypeIndex = 0, maxskillTypeCount - 1 do
    if 0 < skillInfo.plusCount[skillTypeIndex] then
      if skillTypeIndex >= 12 and skillTypeIndex < 15 then
        petSkillGrade = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_POTENLEVEL")
      elseif 16 == skillTypeIndex then
        petSkillGrade = baseSkillTypeUnit[12]
      else
        petSkillGrade = "%"
      end
      if "" == petSkillGradeText then
        petSkillGradeText = skillTypeString[skillTypeIndex] .. skillInfo.plusCount[skillTypeIndex] .. petSkillGrade
      else
        petSkillGradeText = petSkillGradeText .. "\n" .. skillTypeString[skillTypeIndex] .. skillInfo.plusCount[skillTypeIndex] .. petSkillGrade
      end
      hasSkill = true
    end
  end
  if hasSkill then
    self.subTitle:SetPosY(self.baseSkillText:GetPosY() + textSizeY + 25)
    self.textList:SetPosY(self.subTitle:GetPosY() + 40)
    self.textList:SetText(petSkillGradeText)
    local textSizeY = self.textList:GetTextSizeY()
    infgBgSizeY = self.textList:GetPosY() + textSizeY + 20
  else
    self.subTitle:SetShow(false)
    self.textList:SetShow(false)
  end
  PetList.skillInfoBg:SetSize(PetList.skillInfoBg:GetSizeX(), infgBgSizeY)
end
local maxPercentage = ToClient_MaxPetSkillRate() / 10000
local maxGrade = 5
function PetSkillTypeCheck1(skillIndex)
  local self = skillInfo
  local skillType
  if skillIndex >= 0 and skillIndex < 3 then
    skillType = 0
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[skillIndex], maxPercentage)
  elseif skillIndex >= 3 and skillIndex < 6 then
    skillType = 1
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[skillIndex % 3], maxPercentage)
  elseif skillIndex >= 6 and skillIndex < 9 then
    skillType = 2
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[skillIndex % 3], maxPercentage)
  elseif 12 == skillIndex then
    skillType = 3
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[0], maxPercentage)
  elseif 13 == skillIndex then
    skillType = 3
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[4], maxPercentage)
  elseif skillIndex >= 14 and skillIndex < 17 then
    skillType = 4
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex + 1) % 3], maxPercentage)
  elseif skillIndex >= 17 and skillIndex < 20 then
    skillType = 5
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex + 1) % 3], maxPercentage)
  elseif skillIndex >= 20 and skillIndex < 23 then
    skillType = 6
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex + 1) % 3], maxPercentage)
  elseif skillIndex >= 23 and skillIndex < 26 then
    skillType = 7
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex + 1) % 3], maxPercentage)
  elseif skillIndex >= 26 and skillIndex < 29 then
    skillType = 8
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex + 1) % 3], maxPercentage)
  elseif skillIndex >= 29 and skillIndex < 32 then
    skillType = 9
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex + 1) % 3], maxPercentage)
  elseif skillIndex >= 32 and skillIndex < 35 then
    skillType = 10
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex + 1) % 3], maxPercentage)
  elseif skillIndex >= 35 and skillIndex < 38 then
    skillType = 11
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex + 1) % 3], maxPercentage)
  elseif 9 == skillIndex then
    skillType = 12
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + 1, maxGrade)
  elseif 10 == skillIndex then
    skillType = 13
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + 1, maxGrade)
  elseif 11 == skillIndex then
    skillType = 14
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + 1, maxGrade)
  elseif 38 == skillIndex then
    skillType = 15
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[skillIndex % 3], maxPercentage)
  elseif 39 == skillIndex then
    skillType = 16
    self.plusCount[skillType] = self.plusCount[skillType] + 50
  elseif 40 == skillIndex then
    skillType = 17
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[skillIndex % 3], maxPercentage)
  elseif 41 == skillIndex then
    skillType = 18
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[skillIndex % 3], maxPercentage)
  elseif 42 == skillIndex then
    skillType = 19
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[5], maxPercentage)
    skillType = 20
    self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[4], maxPercentage)
  end
  self.skillTypeCount[skillType] = self.skillTypeCount[skillType] + 1
  return skillType
end
function skillTypeCount_Init()
  for index = 0, maxskillTypeCount - 1 do
    skillInfo.plusCount[index] = 0
    skillInfo.skillTypeCount[index] = 0
  end
  petSkillList.desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_SKILLINHERIT_DESC"))
  petSkillList_Close()
end
function PetList:Initialize()
  local btnComposeSizeX = PetList.BTN_Compose:GetSizeX() + 23
  local btnComposeTextPosX = btnComposeSizeX - btnComposeSizeX / 2 - PetList.BTN_Compose:GetTextSizeX() / 2
  local btnFeedAllTextPosX = btnComposeSizeX - btnComposeSizeX / 2 - PetList.BTN_FeedAll:GetTextSizeX() / 2
  local btnAllUnSealSizeX = PetList.BTN_AllUnSeal:GetSizeX() + 23
  local btnAllUnSealTextPosX = btnAllUnSealSizeX - btnAllUnSealSizeX / 2 - PetList.BTN_AllUnSeal:GetTextSizeX() / 2
  local btnAllSealSizeX = PetList.BTN_GroupSeal1:GetSizeX() + 23
  local btnAllSealTextPosX = btnAllSealSizeX - btnAllSealSizeX / 2 - PetList.BTN_GroupSeal1:GetTextSizeX() / 2
  local btnClearGroupSizeX = PetList.BTN_ClearGroup:GetSizeX() + 23
  local btnClearGroupTextPosX = btnClearGroupSizeX - btnClearGroupSizeX / 2 - PetList.BTN_ClearGroup:GetTextSizeX() / 2
  PetList.BTN_Compose:SetTextSpan(btnComposeTextPosX, 5)
  PetList.BTN_FeedAll:SetTextSpan(btnFeedAllTextPosX, 5)
  PetList.BTN_AllUnSeal:SetTextSpan(btnAllUnSealTextPosX, 5)
  PetList.BTN_GroupSeal1:SetTextSpan(btnAllSealTextPosX, 5)
  PetList.BTN_GroupSeal2:SetTextSpan(btnAllSealTextPosX, 5)
  PetList.BTN_GroupSeal3:SetTextSpan(btnAllSealTextPosX, 5)
  PetList.BTN_ClearGroup:SetTextSpan(btnClearGroupTextPosX, 5)
  PetList.BTN_Compose:SetShow(true)
end
function PaGlobalFunc_PetList_SetPosition()
  PetList:SetPosition()
end
function PetList:SetPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_Window_PetListNew:GetSizeX()
  local panelSizeY = Panel_Window_PetListNew:GetSizeY()
  Panel_Window_PetListNew:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  if true == PaGlobalFunc_PetFusion_GetPanelShow() then
    Panel_Window_PetListNew:SetPosX(scrSizeX / 2 - panelSizeX / 2 - PaGlobalFunc_PetFusion_GetPanelSizeX() / 2)
  end
  Panel_Window_PetListNew:SetPosY(scrSizeY / 2 - panelSizeY / 2)
end
function PetList:Open()
  self:SetPosition()
  Panel_Window_PetListNew:SetShow(true, true)
  PetList:showFeedUi(-1)
  PetList:showFeedAllUi(false)
  if PaGlobalFunc_PetFusion_GetShow() then
    Panel_Window_PetCompose_Close()
  end
  if true == ToClient_isButtonOnRegisteredPetForPcRoom() then
    PetList.BTN_pcRoomRegist:SetShow(true)
    PetList.filterBg:SetShow(false)
  else
    local temporaryInformationWrapper = getTemporaryInformationWrapper()
    if nil ~= temporaryInformationWrapper and true == temporaryInformationWrapper:isPremiumPcRoom() and true == _ContentsGroup_PcRoomPet then
      PetList.filterBg:SetShow(true)
    end
    PetList.BTN_pcRoomRegist:SetShow(false)
  end
  self:SetPetList()
end
function FGlobal_PetList_Set(noclearscroll)
  PetList:SetPetList(noclearscroll)
end
function PetList:SetPetList(noclearscroll)
  if not Panel_Window_PetListNew:GetShow() then
    return
  end
  local toIndex = 0
  local scrollvalue = 0
  local vscroll = self.list2_PetList:GetVScroll()
  local hscroll = self.list2_PetList:GetHScroll()
  if noclearscroll then
    toIndex = self.list2_PetList:getCurrenttoIndex()
    if false == self.list2_PetList:IsIgnoreVerticalScroll() then
      scrollvalue = vscroll:GetControlPos()
    elseif false == self.list2_PetList:IsIgnoreHorizontalScroll() then
      scrollvalue = hscroll:GetControlPos()
    end
    if toIndex == self.list2_PetList:getEndIndex() and 0 == self.UnSealDATACount and 4 < self.UnSealDATACount + self.SealDATACount then
      toIndex = toIndex - 1
    end
  end
  self.list2_PetList:getElementManager():clearKey()
  self.UnSealDATACount = ToClient_getPetUnsealedList()
  self.SealDATACount = ToClient_getPetSealedList()
  skillTypeCount_Init()
  AmountPetSkill_Attribute(self.UnSealDATACount)
  local petCount = self.UnSealDATACount + self.SealDATACount
  for index = 0, petCount do
    local petNo
    if 0 == index and 0 == self.UnSealDATACount then
      petNo = toInt64(0, -1)
    elseif index < self.UnSealDATACount then
      local petData = ToClient_getPetUnsealedDataByIndex(index)
      if nil ~= petData then
        if true == ToClient_isFilterOnPetForPcRoom() then
          if true == allPetButton:IsChecked() then
            petNo = petData:getPcPetNo()
          elseif true == normalPetButton:IsChecked() then
            if false == petData:getPetStaticStatus():isOnlyPcRoom() then
              petNo = petData:getPcPetNo()
            end
          elseif true == pcRoomPetButton:IsChecked() and true == petData:getPetStaticStatus():isOnlyPcRoom() then
            petNo = petData:getPcPetNo()
          end
        elseif false == petData:getPetStaticStatus():isOnlyPcRoom() then
          petNo = petData:getPcPetNo()
        end
      end
    else
      index = index - self.UnSealDATACount
      if 0 == self.UnSealDATACount then
        index = index - 1
      end
      local petData = ToClient_getPetSealedDataByIndex(index)
      if nil ~= petData then
        if true == ToClient_isFilterOnPetForPcRoom() then
          if true == allPetButton:IsChecked() then
            petNo = petData._petNo
          elseif true == normalPetButton:IsChecked() then
            if false == petData:getPetStaticStatus():isOnlyPcRoom() then
              petNo = petData._petNo
            end
          elseif true == pcRoomPetButton:IsChecked() and true == petData:getPetStaticStatus():isOnlyPcRoom() then
            petNo = petData._petNo
          end
        elseif false == petData:getPetStaticStatus():isOnlyPcRoom() then
          petNo = petData._petNo
        end
      end
    end
    if nil ~= petNo then
      self.list2_PetList:getElementManager():pushKey(petNo)
    end
  end
  if noclearscroll then
    if 0 == self.UnSealDATACount and toIndex == self.list2_PetList:getEndIndex() - 1 then
      toIndex = toIndex + 1
    end
    self.list2_PetList:setCurrenttoIndex(toIndex)
    if false == self.list2_PetList:IsIgnoreVerticalScroll() then
      vscroll:SetControlPos(scrollvalue)
    elseif false == self.list2_PetList:IsIgnoreHorizontalScroll() then
      hscroll:SetControlPos(scrollvalue)
    end
  end
end
function PetList:Close()
  Panel_Window_PetListNew:SetShow(false, false)
  PetList:showFeedUi(-1)
  PetList:showFeedAllUi(false)
  Panel_Window_PetListNew:CloseUISubApp()
  Panel_Window_PetCompose_Close()
end
function petListNew_ShowInfo(petNoStr)
  audioPostEvent_SystemUi(1, 40)
  FGlobal_PetInfoNew_Open(tonumber64(petNoStr))
end
function sealPetListNew_ShowInfo(petNoStr)
  audioPostEvent_SystemUi(1, 40)
  FGlobal_PetInfoNew_Open(tonumber64(petNoStr), nil, true)
end
function petListNew_Seal(petNoStr, index)
  audioPostEvent_SystemUi(1, 40)
  local self = PetList
  local petNo_s64 = tonumber64(petNoStr)
  FGlobal_PetControl_SealPet(index)
  ToClient_requestPetSeal(petNo_s64)
  FGlobal_AllSealButtonPosition(self.UnSealDATACount, false)
  FGlobal_PetList_FeedClose()
end
function FGlobal_petListNew_Seal(petNo, index)
  petListNew_Seal(petNo, index)
end
function petListNew_UnSeal(petNoStr, isGroup)
  if true == PaGlobalFunc_PetFusion_GetShow() and true == PaGlobalFunc_PetFusion_UnFusionButtonCheck(tonumber64(petNoStr)) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "PANEL_RENEWAL_PETLIST_TEMP_1"))
    return
  end
  audioPostEvent_SystemUi(1, 40)
  local self = PetList
  local petNo_s64 = tonumber64(petNoStr)
  if maxUnsealCount <= self.UnSealDATACount and false == isGroup then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_UNABLE_SUMMON_PET"))
    return
  end
  PetList_OrderList_Init(petNoStr)
  ToClient_requestPetUnseal(petNo_s64)
  FGlobal_PetContorl_HungryGaugeUpdate(petNo_s64)
  FGlobal_AllSealButtonPosition(self.UnSealDATACount, true)
  FGlobal_PetList_FeedClose()
end
function petListNew_UnRegister(petNoStr)
  audioPostEvent_SystemUi(1, 40)
  local self = PetList
  local petNo_s64 = tonumber64(petNoStr)
  ToClient_requestPetUnregister(petNo_s64)
end
function PetListNew_Compose()
  if Panel_Window_PetFusion:GetShow() then
    return
  end
  Panel_Window_PetListNew:SetPosX(getScreenSizeX() / 2 - Panel_Window_PetListNew:GetSizeX() / 2 - Panel_Window_PetFusion:GetSizeX() / 2)
  PaGlobalFunc_PetFusion_Open()
  PetListNew_IgnoreAllSealButton(true)
  PetList:SetPetList()
end
function petListNew_AllSealCheck(petNo_s32, groupIndex)
  PaGlobal_PetList_CheckGroup()
  local groupCount = 0
  for key, value in pairs(checkUnSealGroupList[groupIndex]) do
    if true == value then
      groupCount = groupCount + 1
    end
  end
  if nil == checkUnSealGroupList[groupIndex][petNo_s32] or false == checkUnSealGroupList[groupIndex][petNo_s32] then
    if groupCount >= maxUnsealCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_UNABLE_CHECKGROUP"))
      PetList:SetPetList(true)
      return
    end
    checkUnSealGroupList[groupIndex][petNo_s32] = true
  else
    checkUnSealGroupList[groupIndex][petNo_s32] = false
  end
  petGroupList_Save()
end
function petGroupList_Save()
  ToClient_clearPetGroupList()
  for ii = 1, 3 do
    for key, value in pairs(checkUnSealGroupList[ii]) do
      if true == value then
        ToClient_savePetGroupList(ii, key)
      end
    end
  end
end
local isFirst = false
function petGroupList_Load()
  if true == isFirst then
    return
  end
  isFirst = true
  local size = ToClient_getSizePetGroupList()
  if 0 == size then
    return
  end
  for ii = 0, size do
    local petNo = ToClient_getPetNoInPetGroupByIndex(ii)
    local groupIdx = ToClient_getPetGroupIndexInPetGroupByIndex(ii)
    checkUnSealGroupList[groupIdx][Int64toInt32(petNo)] = true
  end
end
local _globalUIOptionType_PetAllSeal = {
  [0] = __ePetAllSeal0,
  [1] = __ePetAllSeal1,
  [2] = __ePetAllSeal2,
  [3] = __ePetAllSeal3,
  [4] = __ePetAllSeal4,
  [5] = __ePetAllSeal5,
  [6] = __ePetAllSeal6,
  [7] = __ePetAllSeal7,
  [8] = __ePetAllSeal8,
  [9] = __ePetAllSeal9
}
function petListNew_Save()
  local sealPetCount = ToClient_getPetSealedList()
  local maxCount = math.min(9, maxUnsealCount)
  local idx = 0
  for petIndex = 0, sealPetCount - 1 do
    local petData = ToClient_getPetSealedDataByIndex(petIndex)
    local petNo_s32 = Int64toInt32(petData._petNo)
    if checkUnSealList[petNo_s32] then
      ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(_globalUIOptionType_PetAllSeal[idx], petNo_s32, CppEnums.VariableStorageType.eVariableStorageType_User)
      idx = idx + 1
      if idx >= 9 then
        return
      end
    end
  end
  for index = idx, maxCount do
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(_globalUIOptionType_PetAllSeal[index], 0, CppEnums.VariableStorageType.eVariableStorageType_User)
  end
end
function petListNew_Load()
  checkUnSealList = {}
  local maxCount = 9
  for idx = 0, maxCount do
    local petNo_s32 = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(_globalUIOptionType_PetAllSeal[idx])
    if 0 ~= petNo_s32 then
      checkUnSealList[petNo_s32] = true
    end
  end
end
function petListNew_CehckThis(petNo)
  local checkValue = false
  for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
    local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
    local _petNo = petData._petNo
    if petNo == _petNo then
      checkValue = true
    else
      checkValue = false
    end
  end
  return checkValue
end
function Panel_Window_PetCompose_Close()
  PaGlobalFunc_PetFusion_Close()
  PetListNew_IgnoreAllSealButton(false)
  PetList:SetPetList()
end
function PetComposeSkill_Init()
  for ii, aSkillSlot in pairs(FGlobal_PetCompose_GetSkillSlot(3)) do
    aSkillSlot:SetShow(false)
    aSkillSlot:addInputEvent("Mouse_On", "")
    aSkillSlot:addInputEvent("Mouse_Out", "")
  end
end
function PetCompose_ShowSkillToolTip(skill_idx, typeStr)
  local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
  local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
  local petSkillNo = skillStaticStatus:getSkillNo()
  Panel_SkillTooltip_Show(petSkillNo, false, typeStr)
end
function PetCompose_HideSkillToolTip()
  Panel_SkillTooltip_Hide()
end
function PetListNew_SimpleTooltip(isShow, tipType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_PETLISTNEW_ALLSEAL")
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETLIST_ALLSEAL_MAX4_DESC", "count", maxUnsealCount) .. [[


]] .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
    control = PetList.BTN_GroupSeal1
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_PETLISTNEW_ALLSEAL")
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETLIST_ALLSEAL_GROUP_SEAL2", "count", maxUnsealCount) .. [[


]] .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
    control = PetList.BTN_GroupSeal2
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_PETLISTNEW_ALLSEAL")
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETLIST_ALLSEAL_GROUP_SEAL3", "count", maxUnsealCount) .. [[


]] .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
    control = PetList.BTN_GroupSeal3
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_PETLISTNEW_ALLCLEARSET")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLISTNEW_ALLCLEAR_UNSET")
    control = PetList.BTN_ClearGroup
  elseif 4 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_PETLISTNEW_COMPOSE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_FUSION_DESC")
    control = PetList.BTN_Compose
  elseif 5 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PETCONTROL_BTN_ALLSEAL")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_ALLSEAL_DESC") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
    control = PetList.BTN_AllUnSeal
  end
  TooltipSimple_Show(control, name, desc)
end
function PetListNew_NameSimpleTooltip(isShow, index, isSealed)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control, pcPetData, key
  if isSealed then
    pcPetData = ToClient_getPetUnsealedDataByIndex(index)
    key = pcPetData:getPcPetNo()
  else
    pcPetData = ToClient_getPetSealedDataByIndex(index)
    key = pcPetData._petNo
  end
  local petName = pcPetData:getName()
  local contents = PetList.list2_PetList:GetContentByKey(key)
  local nameControl = UI.getChildControl(contents, "Template_StaticText_PetName")
  name = petName
  control = nameControl
  TooltipSimple_Show(control, name, desc)
end
function HandleOver_PetProperty_Tooltip_Show(skillType)
  local petPropertyText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETINFO_SPECIALSKILL", "paramText", PetList_SkillTypeString(skillType))
  TooltipSimple_CommonShow("", petPropertyText)
  TooltipSimple_Common_Pos(getMousePosX() + 15, getMousePosY() + 15)
end
function HandleOver_PetProperty_Tooltip_Hide()
  TooltipSimple_Hide()
end
function FGlobal_CheckEditBox_PetCompose(uiEditBox)
  return nil ~= uiEditBox and nil ~= FGlobal_PetCompose_GetPetEditName() and uiEditBox:GetKey() == FGlobal_PetCompose_GetPetEditName():GetKey()
end
function FGlobal_PetListNew_Open()
  PetList:Open()
end
function FGlobal_PetListNew_Close()
  audioPostEvent_SystemUi(1, 1)
  PetList:Close()
  PetList:showFeedUi(-1)
  PetList:showFeedAllUi(false)
  Panel_Window_PetCompose_Close()
  PetListNew_IgnoreAllSealButton(false)
end
function PetListNew_IgnoreAllSealButton(isShow)
  local self = PetList
  self.BTN_GroupSeal1:SetIgnore(isShow)
  self.BTN_GroupSeal1:SetMonoTone(isShow)
  self.BTN_GroupSeal2:SetIgnore(isShow)
  self.BTN_GroupSeal2:SetMonoTone(isShow)
  self.BTN_GroupSeal3:SetIgnore(isShow)
  self.BTN_GroupSeal3:SetMonoTone(isShow)
  self.BTN_Compose:SetIgnore(isShow)
  self.BTN_Compose:SetMonoTone(isShow)
  self.BTN_FeedAll:SetIgnore(isShow)
  self.BTN_FeedAll:SetMonoTone(isShow)
  self.BTN_AllUnSeal:SetIgnore(isShow)
  self.BTN_AllUnSeal:SetMonoTone(isShow)
  self.BTN_ClearGroup:SetIgnore(isShow)
  self.BTN_ClearGroup:SetMonoTone(isShow)
end
function FGlobal_PetListNew_Toggle()
  if Panel_Window_PetListNew:GetShow() then
    PetList:Close()
    Panel_Window_PetCompose_Close()
    audioPostEvent_SystemUi(1, 1)
  else
    PetList:Open()
    audioPostEvent_SystemUi(1, 40)
    local regionInfoWrapper = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
    if nil == regionInfoWrapper then
      return
    end
    local myAffiliatedTownRegionKey = regionInfoWrapper:getAffiliatedTownRegionKey()
    local mainTownRegionWrapper = getRegionInfoWrapper(myAffiliatedTownRegionKey)
    local wayPointKey = mainTownRegionWrapper:getPlantKeyByWaypointKey():getWaypointKey()
    warehouse_requestInfo(wayPointKey)
  end
  PetListNew_IgnoreAllSealButton(false)
end
function FGlobal_HandleClicked_PetMarket_Show()
  PetAuction_Open()
  requestPetList()
  if Panel_Window_PetListNew:GetShow() then
    FGlobal_PetListNew_Close()
  end
end
function FGlobal_HandleClicked_petControl_AllSeal(groupIndex)
  if Panel_Window_PetFusion:GetShow() then
    return
  end
  local sealPetCount = ToClient_getPetSealedList()
  local unSealPetCount = ToClient_getPetUnsealedList()
  FGlobal_HandleClicked_petControl_AllUnSeal(groupIndex)
  if 0 == sealPetCount then
    return
  end
  for petIndex = 0, sealPetCount - 1 do
    local isDuplication = false
    local petData = ToClient_getPetSealedDataByIndex(petIndex)
    local petNo_s64 = petData._petNo
    if checkUnSealGroupList[groupIndex][Int64toInt32(petNo_s64)] then
      for index = 0, maxUnsealCount - 1 do
        local unSealPetInfo = ToClient_getPetUnsealedList()
        local PetUnSealData = ToClient_getPetUnsealedDataByIndex(index)
        if nil ~= PetUnSealData then
          local unsealPetNo_s64 = PetUnSealData:getPcPetNo()
          if petNo_s64 == unsealPetNo_s64 then
            isDuplication = true
          end
        end
      end
      if false == isDuplication then
        Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETLIST_GROUPPET_SEAL", "index", groupIndex))
        petListNew_UnSeal(tostring(petNo_s64), true)
      end
    end
  end
end
function PetList_OrderList_Init(petNo)
  PetList.orderList._follow[tostring(petNo)] = nil
  PetList.orderList._find[tostring(petNo)] = nil
  PetList.orderList._getItem[tostring(petNo)] = nil
end
function FromClient_PetUpdate()
  FGlobal_PetControl_CheckUnSealPet()
  if not Panel_Window_PetListNew:GetShow() then
    return
  end
  if 5 ~= getGameServiceType() and 6 ~= getGameServiceType() then
    PetInfoInit_ByPetNo()
  end
  PetList:SetPetList(true)
end
function FromClient_PetUpdate_ButtonShow(petNo)
  if not Panel_Window_PetListNew:GetShow() then
    return
  end
  PetInfoInit_ByPetNo()
  FGlobal_PetControl_CheckUnSealPet(petNo)
  PetList:SetPetList(true)
end
function FGlobal_PetListNew_NoPet()
  if isFlushedUI() then
    return
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() then
    Panel_Window_PetIcon:SetShow(false)
    return
  end
  local petCount = ToClient_getPetSealedList()
  local unSealPetCount = ToClient_getPetUnsealedList()
  local PcPetData = ToClient_getPetUnsealedDataByIndex(0)
  if 0 == unSealPetCount then
    FGlobal_PetHungryAlert(false)
  end
  if 0 == petCount and nil == PcPetData then
    Panel_Window_PetIcon:SetShow(false)
  else
    Panel_Window_PetIcon:SetShow(true)
    local iconCount = FGlobal_HouseIconCount() + FGlobal_ServantIconCount()
    local posX, posY
    if 0 < FGlobal_HouseIconCount() and Panel_MyHouseNavi:GetShow() then
      posX = Panel_MyHouseNavi:GetPosX() + 60 * FGlobal_HouseIconCount() - 3
      posY = Panel_MyHouseNavi:GetPosY() - 2
    elseif 0 < FGlobal_ServantIconCount() and Panel_Window_Servant:GetShow() then
      posX = Panel_Window_Servant:GetPosX() + 60 * FGlobal_ServantIconCount() - 3
      posY = Panel_Window_Servant:GetPosY() - 2
    else
      posX = 10
      posY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15
    end
    Panel_Window_PetIcon:SetPosX(posX)
    Panel_Window_PetIcon:SetPosY(posY)
  end
  FGlobal_MaidIcon_SetPos(false)
  PaGlobal_Camp:setPos()
  if true == _ContentsGroup_RenewUI_Main then
    Panel_Window_PetIcon:SetShow(false)
  end
end
local defaultBtnFeedPosX = 331
local defaultBtnInfoPosX = 369
local defaultBtnSealPosX = 407
function PetListControlCreate(control, key)
  local bg = UI.getChildControl(control, "Template_Static_ListContentBG")
  local unsealBg = UI.getChildControl(control, "Template_Static_ListContentUnsealBG")
  local iconBg = UI.getChildControl(control, "Template_Static_IconPetBG")
  local icon = UI.getChildControl(control, "Template_Static_IconPet")
  local name = UI.getChildControl(control, "Template_StaticText_PetName")
  local level = UI.getChildControl(control, "Template_StaticText_Level")
  local tier = UI.getChildControl(control, "Template_StaticText_Tier")
  local hungryIcon = UI.getChildControl(control, "Template_Static_HungryIcon")
  local hungryBg = UI.getChildControl(control, "Template_Static_Progress_Hungry_BG")
  local hungryProgress = UI.getChildControl(control, "Template_Static_Progress_Hungry")
  local hungryPercentText = UI.getChildControl(control, "StaticText_HungryPercent")
  local gradeLine = UI.getChildControl(control, "Template_Static_GradeLine")
  local gradeMark = UI.getChildControl(control, "Template_Static_GradeMark")
  local btnRegist = UI.getChildControl(control, "Template_Button_Regist")
  local btnUnsealAll = UI.getChildControl(control, "Template_Button_UnsealAll")
  local btnUnseal = UI.getChildControl(control, "Template_Button_Unseal")
  local btnFusion = UI.getChildControl(control, "Template_Button_Fusion")
  local btnUnFusion = UI.getChildControl(control, "Template_Button_UnFusion")
  local btnCantFusion = UI.getChildControl(control, "Template_Button_DontFusion")
  local groupIndexBtn1 = UI.getChildControl(control, "Template_Button_GroupIndex1")
  local groupIndexBtn2 = UI.getChildControl(control, "Template_Button_GroupIndex2")
  local groupIndexBtn3 = UI.getChildControl(control, "Template_Button_GroupIndex3")
  local property = UI.getChildControl(control, "StaticText_Property")
  local orderFollow = UI.getChildControl(control, "CheckButton_Follow")
  local orderWait = UI.getChildControl(control, "CheckButton_Wait")
  local orderFind = UI.getChildControl(control, "CheckButton_Find")
  local orderGetItem = UI.getChildControl(control, "CheckButton_GetItem")
  local orderPlay = UI.getChildControl(control, "CheckButton_Play")
  local noUnsealpet = UI.getChildControl(control, "StaticText_NoneUnsealPet")
  local btnUp = UI.getChildControl(control, "Button_Up")
  local btnDown = UI.getChildControl(control, "Button_Down")
  local btnFeed = UI.getChildControl(control, "Button_Feeding")
  local btnInfo = UI.getChildControl(control, "Template_Button_Info")
  local btnSeal = UI.getChildControl(control, "Template_Button_Seal")
  local pcRoomIcon = UI.getChildControl(control, "Static_PCRoomIcon")
  btnFeed:SetPosX(defaultBtnFeedPosX)
  btnFeed:SetPosX(defaultBtnInfoPosX)
  btnFeed:SetPosX(defaultBtnSealPosX)
  btnUp:SetShow(false)
  btnDown:SetShow(false)
  local skillIcon = {
    [0] = UI.getChildControl(control, "Static_SkillIcon_0"),
    [1] = UI.getChildControl(control, "Static_SkillIcon_1"),
    [2] = UI.getChildControl(control, "Static_SkillIcon_2"),
    [3] = UI.getChildControl(control, "Static_SkillIcon_3")
  }
  local sealPetCount = ToClient_getPetSealedList()
  local unsealPetCount = ToClient_getPetUnsealedList()
  local function isUnsealPet(petNo_s64)
    if unsealPetCount > 0 then
      for index = 0, unsealPetCount - 1 do
        local pcPetData = ToClient_getPetUnsealedDataByIndex(index)
        if petNo_s64 == pcPetData:getPcPetNo() then
          return true
        end
      end
    end
    return false
  end
  local isShow
  if toInt64(0, -1) == key then
    isShow = false
  else
    isShow = true
  end
  gradeLine:SetShow(isShow)
  iconBg:SetShow(isShow)
  icon:SetShow(isShow)
  name:SetShow(isShow)
  name:SetIgnore(false)
  level:SetShow(isShow)
  tier:SetShow(isShow)
  hungryIcon:SetShow(isShow)
  hungryBg:SetShow(isShow)
  hungryProgress:SetShow(isShow)
  hungryPercentText:SetShow(isShow)
  btnInfo:SetShow(isShow)
  btnRegist:SetShow(false)
  btnUnsealAll:SetShow(isShow)
  btnUnseal:SetShow(isShow)
  btnSeal:SetShow(isShow)
  btnFusion:SetShow(isShow)
  btnCantFusion:SetShow(isShow)
  btnUnFusion:SetShow(isShow)
  btnFeed:SetShow(isShow)
  groupIndexBtn1:SetShow(isShow)
  groupIndexBtn2:SetShow(isShow)
  groupIndexBtn3:SetShow(isShow)
  gradeMark:SetShow(isShow)
  property:SetShow(isShow)
  orderFollow:SetShow(isShow)
  orderWait:SetShow(false)
  orderFind:SetShow(isShow)
  orderGetItem:SetShow(isShow)
  orderPlay:SetShow(isShow and isPlayOpen)
  noUnsealpet:SetShow(not isShow)
  skillIcon[0]:SetShow(false)
  skillIcon[1]:SetShow(false)
  skillIcon[2]:SetShow(false)
  skillIcon[3]:SetShow(false)
  pcRoomIcon:SetShow(isShow)
  if not isShow then
    return
  end
  local petStaticStatus, iconPath, petNo_s64, petName, petLevel, petLovely, pethungry, petMaxLevel, petMaxHungry, petRace, petTier, petState, skillType, isPassive, tempIndex, isJokerPetUse
  if isUnsealPet(key) then
    for index = 0, unsealPetCount - 1 do
      local pcPetData = ToClient_getPetUnsealedDataByIndex(index)
      if nil ~= pcPetData and key == pcPetData:getPcPetNo() then
        petStaticStatus = pcPetData:getPetStaticStatus()
        iconPath = pcPetData:getIconPath()
        petNo_s64 = pcPetData:getPcPetNo()
        petName = pcPetData:getName()
        petLevel = pcPetData:getLevel()
        petLovely = pcPetData:getLovely()
        pethungry = pcPetData:getHungry()
        petState = pcPetData:getPetState()
        petMaxLevel = petStaticStatus._maxLevel
        petMaxHungry = petStaticStatus._maxHungry
        petRace = petStaticStatus:getPetRace()
        petTier = petStaticStatus:getPetTier() + 1
        isJokerPetUse = petStaticStatus._isJokerPetUse
        if nil ~= pcPetData:getSkillParam(1) then
          skillType = pcPetData:getSkillParam(1)._type
          isPassive = pcPetData:getSkillParam(1):isPassiveSkill()
        end
        gradeLine:SetColor(gradeColorConfig[petTier - 1])
        local hungryPercent = pethungry / petMaxHungry * 100
        hungryProgress:SetProgressRate(hungryPercent)
        hungryPercentText:SetText(string.format("%.1f", hungryPercent) .. "%")
        if true == pcPetData:getPetStaticStatus():isOnlyPcRoom() then
          pcRoomIcon:SetShow(true)
        else
          pcRoomIcon:SetShow(false)
        end
        unsealBg:SetShow(true)
        groupIndexBtn1:SetShow(false)
        groupIndexBtn2:SetShow(false)
        groupIndexBtn3:SetShow(false)
        orderFollow:addInputEvent("Mouse_LUp", "petListNew_SetOrder(" .. 0 .. "," .. index .. ")")
        orderWait:addInputEvent("Mouse_LUp", "petListNew_SetOrder(" .. 0 .. "," .. index .. ")")
        orderFind:addInputEvent("Mouse_LUp", "petListNew_SetOrder(" .. 1 .. "," .. index .. ")")
        orderGetItem:addInputEvent("Mouse_LUp", "petListNew_SetOrder(" .. 2 .. "," .. index .. ")")
        orderPlay:addInputEvent("Mouse_LUp", "petListNew_SetPlay(" .. index .. ")")
        btnFeed:addInputEvent("Mouse_LUp", "HandleClicked_PetList_Feed(" .. index .. ")")
        orderFollow:addInputEvent("Mouse_RUp", "petListNew_SetOrderAll(" .. 0 .. "," .. index .. ")")
        orderWait:addInputEvent("Mouse_RUp", "petListNew_SetOrderAll(" .. 0 .. "," .. index .. ")")
        orderFind:addInputEvent("Mouse_RUp", "petListNew_SetOrderAll(" .. 1 .. "," .. index .. ")")
        orderGetItem:addInputEvent("Mouse_RUp", "petListNew_SetOrderAll(" .. 2 .. "," .. index .. ")")
        orderPlay:addInputEvent("Mouse_RUp", "petListNew_SetPlayAll(" .. index .. ")")
        btnFeed:addInputEvent("Mouse_RUp", "")
        orderFollow:addInputEvent("Mouse_On", "petListNew_OrderTooltip(" .. 0 .. ", " .. index .. ")")
        orderWait:addInputEvent("Mouse_On", "petListNew_OrderTooltip(" .. 1 .. ", " .. index .. ")")
        orderFind:addInputEvent("Mouse_On", "petListNew_OrderTooltip(" .. 2 .. ", " .. index .. ")")
        orderGetItem:addInputEvent("Mouse_On", "petListNew_OrderTooltip(" .. 3 .. ", " .. index .. ")")
        orderPlay:addInputEvent("Mouse_On", "petListNew_OrderTooltip(" .. 4 .. ", " .. index .. ")")
        orderFollow:addInputEvent("Mouse_Out", "petListNew_OrderTooltip()")
        orderWait:addInputEvent("Mouse_Out", "petListNew_OrderTooltip()")
        orderFind:addInputEvent("Mouse_Out", "petListNew_OrderTooltip()")
        orderGetItem:addInputEvent("Mouse_Out", "petListNew_OrderTooltip()")
        orderPlay:addInputEvent("Mouse_Out", "petListNew_OrderTooltip()")
        btnFeed:addInputEvent("Mouse_On", "petListNew_OrderTooltip(" .. 11 .. ", " .. index .. ")")
        btnFeed:addInputEvent("Mouse_Out", "petListNew_OrderTooltip()")
        PetList.orderList = PetControl_UnsealPetOrderInfo(tostring(petNo_s64))
        if isPassive then
          PetList.orderList._find[tostring(petNo_s64)] = true
          orderFind:addInputEvent("Mouse_LUp", "")
        end
        if PetList.orderList._follow[tostring(petNo_s64)] then
          orderFollow:SetShow(true)
          orderWait:SetShow(false)
        else
          orderFollow:SetShow(false)
          orderWait:SetShow(true)
        end
        if PetList.orderList._find[tostring(petNo_s64)] then
          orderFind:SetMonoTone(false)
        else
          orderFind:SetMonoTone(true)
        end
        if PetList.orderList._getItem[tostring(petNo_s64)] then
          orderGetItem:SetMonoTone(false)
        else
          orderGetItem:SetMonoTone(true)
        end
        local petLootingType = pcPetData:getPetLootingType()
        orderPlay:ChangeTextureInfoName("new_ui_common_forlua/window/servant/pet_00.dds")
        local x1, y1, x2, y2
        if 0 == petLootingType then
          x1, y1, x2, y2 = setTextureUV_Func(orderPlay, 140, 280, 172, 312)
        elseif 1 == petLootingType then
          x1, y1, x2, y2 = setTextureUV_Func(orderPlay, 104, 280, 136, 312)
        elseif 2 == petLootingType then
          x1, y1, x2, y2 = setTextureUV_Func(orderPlay, 176, 280, 208, 312)
        end
        orderPlay:getBaseTexture():setUV(x1, y1, x2, y2)
        orderPlay:setRenderTexture(orderPlay:getBaseTexture())
        name:SetTextMode(UI_TM.eTextMode_LimitText)
        name:SetText(petName)
        if name:IsLimitText() then
          name:addInputEvent("Mouse_On", "PetListNew_NameSimpleTooltip( true,\t" .. index .. ", " .. tostring(true) .. ", " .. tostring(key) .. ")")
          name:addInputEvent("Mouse_Out", "PetListNew_NameSimpleTooltip( false,\t" .. index .. ", " .. tostring(true) .. ", " .. tostring(key) .. ")")
        else
          name:addInputEvent("Mouse_On", "")
          name:addInputEvent("Mouse_Out", "")
        end
        hungryProgress:addInputEvent("Mouse_On", "petListNew_OrderTooltip(5, " .. index .. ")")
        hungryProgress:addInputEvent("Mouse_Out", "petListNew_OrderTooltip()")
        hungryPercentText:addInputEvent("Mouse_On", "petListNew_OrderTooltip(6, " .. index .. ")")
        hungryPercentText:addInputEvent("Mouse_Out", "petListNew_OrderTooltip()")
        hungryIcon:addInputEvent("Mouse_On", "petListNew_OrderTooltip(7, " .. index .. ")")
        hungryIcon:addInputEvent("Mouse_Out", "petListNew_OrderTooltip()")
        btnInfo:addInputEvent("Mouse_On", "petListNew_OrderTooltip(8, " .. index .. ")")
        btnInfo:addInputEvent("Mouse_Out", "petListNew_OrderTooltip()")
        btnSeal:addInputEvent("Mouse_On", "petListNew_OrderTooltip(9, " .. index .. ")")
        btnSeal:addInputEvent("Mouse_Out", "petListNew_OrderTooltip()")
        btnFusion:addInputEvent("Mouse_On", "petListNew_OrderTooltip(10, " .. index .. ")")
        btnFusion:addInputEvent("Mouse_Out", "petListNew_OrderTooltip()")
        btnUnFusion:addInputEvent("Mouse_On", "petListNew_OrderTooltip(10, " .. index .. ")")
        btnUnFusion:addInputEvent("Mouse_Out", "petListNew_OrderTooltip()")
        local uiIndex = 0
        local baseskillindex = pcPetData:getPetBaseSkillIndex()
        local skillMaxCount = ToClient_getPetEquipSkillMax()
        local skillStaticStatus = ToClient_getPetBaseSkillStaticStatus(baseskillindex)
        if nil ~= skillStaticStatus then
          local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
          if nil ~= skillTypeStaticWrapper then
            local skillNo = skillStaticStatus:getSkillNo()
            skillIcon[uiIndex]:SetShow(true)
            skillIcon[uiIndex]:ChangeTextureInfoName("Icon/" .. skillTypeStaticWrapper:getIconPath())
            skillIcon[uiIndex]:addInputEvent("Mouse_On", "PetList_BaseSkill_ShowTooltip( " .. baseskillindex .. ",\"sealPetListSkill\" )")
            skillIcon[uiIndex]:addInputEvent("Mouse_Out", "PetList_BaseSkill_HideTooltip()")
            Panel_SkillTooltip_SetPosition(skillNo, skillIcon[uiIndex], "sealPetListSkill")
            uiIndex = uiIndex + 1
          end
        end
        for skill_idx = 0, skillMaxCount - 1 do
          local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
          local isLearn = pcPetData:isPetEquipSkillLearned(skill_idx)
          if true == isLearn and nil ~= skillStaticStatus then
            local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
            if nil ~= skillTypeStaticWrapper then
              local skillNo = skillStaticStatus:getSkillNo()
              skillIcon[uiIndex]:SetShow(true)
              skillIcon[uiIndex]:ChangeTextureInfoName("Icon/" .. skillTypeStaticWrapper:getIconPath())
              skillIcon[uiIndex]:addInputEvent("Mouse_On", "PetList_ShowSkillToolTip( " .. skill_idx .. ", \"sealPetListSkill\" )")
              skillIcon[uiIndex]:addInputEvent("Mouse_Out", "PetList_HideSkillToolTip()")
              Panel_SkillTooltip_SetPosition(skillNo, skillIcon[uiIndex], "sealPetListSkill")
              uiIndex = uiIndex + 1
            end
          end
        end
      end
    end
    local isFusion = Panel_Window_PetFusion:GetShow()
    btnInfo:SetShow(not isFusion)
    btnSeal:SetShow(not isFusion)
    btnFeed:SetShow(not isFusion)
    btnUnseal:SetShow(false)
    btnFusion:SetShow(false)
    btnUnFusion:SetShow(false)
    btnCantFusion:SetShow(false)
    btnUnsealAll:SetShow(false)
    btnInfo:addInputEvent("Mouse_LUp", "petListNew_ShowInfo( \"" .. tostring(petNo_s64) .. "\" )")
    local uiIndex = 0
    btnSeal:addInputEvent("Mouse_LUp", "petListNew_Seal( \"" .. tostring(petNo_s64) .. "\" ," .. uiIndex .. ")")
    btnFeed:SetPosX(defaultBtnFeedPosX + 38)
    btnInfo:SetPosX(defaultBtnInfoPosX + 38)
    btnSeal:SetPosX(defaultBtnSealPosX + 38)
  else
    local unsealPetIndex = -1
    for index = 0, sealPetCount - 1 do
      local pcPetData = ToClient_getPetSealedDataByIndex(index)
      if nil ~= pcPetData and key == pcPetData._petNo then
        petStaticStatus = pcPetData:getPetStaticStatus()
        iconPath = pcPetData:getIconPath()
        petNo_s64 = pcPetData._petNo
        petName = pcPetData:getName()
        petLevel = pcPetData._level
        petLovely = pcPetData._lovely
        pethungry = pcPetData._hungry
        petState = pcPetData._petState
        petMaxLevel = petStaticStatus._maxLevel
        petMaxHungry = petStaticStatus._maxHungry
        petRace = petStaticStatus:getPetRace()
        petTier = petStaticStatus:getPetTier() + 1
        isJokerPetUse = petStaticStatus._isJokerPetUse
        if nil ~= pcPetData:getSkillParam(1) then
          skillType = pcPetData:getSkillParam(1)._type
          isPassive = pcPetData:getSkillParam(1):isPassiveSkill()
        end
        gradeLine:SetColor(gradeColorConfig[petTier - 1])
        local hungryPercent = pethungry / petMaxHungry * 100
        hungryProgress:SetProgressRate(hungryPercent)
        hungryPercentText:SetText(string.format("%.1f", hungryPercent) .. "%")
        if true == pcPetData:getPetStaticStatus():isOnlyPcRoom() then
          pcRoomIcon:SetShow(true)
        else
          pcRoomIcon:SetShow(false)
        end
        unsealBg:SetShow(false)
        groupIndexBtn1:SetShow(true)
        groupIndexBtn2:SetShow(true)
        groupIndexBtn3:SetShow(true)
        groupIndexBtn1:addInputEvent("Mouse_LUp", "petListNew_AllSealCheck(" .. Int64toInt32(petNo_s64) .. ", 1 )")
        groupIndexBtn2:addInputEvent("Mouse_LUp", "petListNew_AllSealCheck(" .. Int64toInt32(petNo_s64) .. ", 2 )")
        groupIndexBtn3:addInputEvent("Mouse_LUp", "petListNew_AllSealCheck(" .. Int64toInt32(petNo_s64) .. ", 3 )")
        groupIndexBtn1:SetCheck(PetList:IsCheckGroupBtnByPetNo(petNo_s64, 1))
        groupIndexBtn2:SetCheck(PetList:IsCheckGroupBtnByPetNo(petNo_s64, 2))
        groupIndexBtn3:SetCheck(PetList:IsCheckGroupBtnByPetNo(petNo_s64, 3))
        PetList.orderList._follow[petNo_s64] = true
        PetList.orderList._find[petNo_s64] = isPassive
        PetList.orderList._getItem[petNo_s64] = true
        name:SetTextMode(UI_TM.eTextMode_LimitText)
        name:SetText(petName)
        if name:IsLimitText() then
          name:addInputEvent("Mouse_On", "PetListNew_NameSimpleTooltip( true,\t" .. index .. ", " .. tostring(false) .. ", " .. tostring(key) .. ")")
          name:addInputEvent("Mouse_Out", "PetListNew_NameSimpleTooltip( false,\t" .. index .. ", " .. tostring(false) .. ", " .. tostring(key) .. ")")
        else
          name:addInputEvent("Mouse_On", "")
          name:addInputEvent("Mouse_Out", "")
        end
        unsealPetIndex = index
        btnUp:addInputEvent("Mouse_LUp", "PetList_ChangePosition(true," .. index .. ")")
        btnDown:addInputEvent("Mouse_LUp", "PetList_ChangePosition(false," .. index .. ")")
        btnUp:SetShow(true)
        btnDown:SetShow(true)
        btnUnseal:addInputEvent("Mouse_On", "PetListNew_SimpleTooltipBTN(true, " .. index .. ", " .. 0 .. ")")
        btnUnseal:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltipBTN(false)")
        hungryProgress:addInputEvent("Mouse_On", "PetListNew_SimpleTooltipBTN(true, " .. index .. ", " .. 1 .. ")")
        hungryProgress:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltipBTN(false)")
        hungryPercentText:addInputEvent("Mouse_On", "PetListNew_SimpleTooltipBTN(true, " .. index .. ", " .. 2 .. ")")
        hungryPercentText:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltipBTN(false)")
        hungryIcon:addInputEvent("Mouse_On", "PetListNew_SimpleTooltipBTN(true, " .. index .. ", " .. 3 .. ")")
        hungryIcon:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltipBTN(false)")
        btnUp:addInputEvent("Mouse_On", "PetListNew_SimpleTooltipBTN(true, " .. index .. ", " .. 4 .. ")")
        btnUp:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltipBTN(false)")
        btnDown:addInputEvent("Mouse_On", "PetListNew_SimpleTooltipBTN(true, " .. index .. ", " .. 5 .. ")")
        btnDown:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltipBTN(false)")
        groupIndexBtn1:addInputEvent("Mouse_On", "PetListNew_SimpleTooltipBTN(true, " .. index .. ", " .. 6 .. ")")
        groupIndexBtn1:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltipBTN(false)")
        groupIndexBtn2:addInputEvent("Mouse_On", "PetListNew_SimpleTooltipBTN(true, " .. index .. ", " .. 7 .. ")")
        groupIndexBtn2:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltipBTN(false)")
        groupIndexBtn3:addInputEvent("Mouse_On", "PetListNew_SimpleTooltipBTN(true, " .. index .. ", " .. 8 .. ")")
        groupIndexBtn3:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltipBTN(false)")
        btnFusion:addInputEvent("Mouse_On", "PetListNew_SimpleTooltipBTN(true, " .. index .. ", " .. 9 .. ")")
        btnFusion:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltipBTN(false)")
        btnUnFusion:addInputEvent("Mouse_On", "PetListNew_SimpleTooltipBTN(true, " .. index .. ", " .. 9 .. ")")
        btnUnFusion:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltipBTN(false)")
        local uiIndex = 0
        local baseskillindex = pcPetData:getPetBaseSkillIndex()
        local skillStaticStatus = ToClient_getPetBaseSkillStaticStatus(baseskillindex)
        if nil ~= skillStaticStatus then
          local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
          if nil ~= skillTypeStaticWrapper then
            local skillNo = skillStaticStatus:getSkillNo()
            skillIcon[uiIndex]:SetShow(true)
            skillIcon[uiIndex]:ChangeTextureInfoName("Icon/" .. skillTypeStaticWrapper:getIconPath())
            skillIcon[uiIndex]:addInputEvent("Mouse_On", "PetList_BaseSkill_ShowTooltip( " .. baseskillindex .. ", \"unSealPetListSkill\" )")
            skillIcon[uiIndex]:addInputEvent("Mouse_Out", "PetList_BaseSkill_HideTooltip()")
            Panel_SkillTooltip_SetPosition(skillNo, skillIcon[uiIndex], "unSealPetListSkill")
            uiIndex = uiIndex + 1
          end
        end
        local skillMaxCount = ToClient_getPetEquipSkillMax()
        for skill_idx = 0, skillMaxCount - 1 do
          local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
          local isLearn = pcPetData:isPetEquipSkillLearned(skill_idx)
          if true == isLearn and nil ~= skillStaticStatus then
            local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
            if nil ~= skillTypeStaticWrapper then
              local skillNo = skillStaticStatus:getSkillNo()
              skillIcon[uiIndex]:SetShow(true)
              skillIcon[uiIndex]:ChangeTextureInfoName("Icon/" .. skillTypeStaticWrapper:getIconPath())
              skillIcon[uiIndex]:addInputEvent("Mouse_On", "PetList_ShowSkillToolTip( " .. skill_idx .. ", \"unSealPetListSkill\" )")
              skillIcon[uiIndex]:addInputEvent("Mouse_Out", "PetList_HideSkillToolTip()")
              Panel_SkillTooltip_SetPosition(skillNo, skillIcon[uiIndex], "unSealPetListSkill")
              uiIndex = uiIndex + 1
            end
          end
        end
      end
    end
    btnInfo:SetShow(false)
    btnUnseal:SetShow(true)
    btnSeal:SetShow(false)
    btnUnsealAll:SetShow(false)
    btnFusion:SetShow(false)
    btnUnFusion:SetShow(false)
    btnCantFusion:SetShow(false)
    btnFeed:SetShow(false)
    orderFollow:SetShow(false)
    orderWait:SetShow(false)
    orderFind:SetShow(false)
    orderGetItem:SetShow(false)
    orderPlay:SetShow(false)
    local isFusionAble = PaGlobalFunc_PetFusion_FusionButtonShowCheck(petNo_s64, petTier, petRace)
    btnFusion:SetShow(isFusionAble)
    btnUnFusion:SetShow(true == PaGlobalFunc_PetFusion_UnFusionButtonCheck(petNo_s64))
    local isFusionMonoTon = PaGlobalFunc_PetFusion_FusionButtonMonoTonCheck(petNo_s64, petTier, petRace)
    btnCantFusion:SetShow(isFusionMonoTon)
    icon:SetMonoTone(isFusionMonoTon)
    if true == isFusionMonoTon then
      icon:SetColor(Defines.Color.C_FFD20000)
    else
      icon:SetColor(Defines.Color.C_FFFFFFFF)
    end
    if false == PaGlobalFunc_PetFusion_UnFusionButtonCheck(petNo_s64) then
      btnUnseal:SetMonoTone(false)
    else
      btnUnseal:SetMonoTone(true)
    end
    btnInfo:addInputEvent("Mouse_LUp", "sealPetListNew_ShowInfo( \"" .. tostring(petNo_s64) .. "\" )")
    btnUnseal:addInputEvent("Mouse_LUp", "petListNew_UnSeal( \"" .. tostring(petNo_s64) .. "\" , false )")
    btnFusion:addInputEvent("Mouse_LUp", "petListNew_Compose_Set( \"" .. tostring(petNo_s64) .. "\" ," .. petRace .. ", " .. petTier .. ", " .. unsealPetIndex .. "," .. tostring(isJokerPetUse) .. " )")
    btnCantFusion:addInputEvent("Mouse_LUp", "petListNew_Compose_Set( \"" .. tostring(petNo_s64) .. "\" ," .. petRace .. ", " .. petTier .. ", " .. unsealPetIndex .. "," .. tostring(isJokerPetUse) .. " )")
    btnUnFusion:addInputEvent("Mouse_LUp", "petListNew_Compose_UnSet( \"" .. tostring(petNo_s64) .. "\"," .. unsealPetIndex .. " )")
    btnFusion:SetPosX(btnUnseal:GetPosX() - (btnFusion:GetSizeX() - 10))
    btnCantFusion:SetPosX(btnUnseal:GetPosX() - (btnFusion:GetSizeX() - 4))
    btnUnFusion:SetPosX(btnUnseal:GetPosX() - (btnFusion:GetSizeX() - 4))
    if true == PaGlobalFunc_PetFusion_GetShow() then
      btnUnseal:SetShow(false)
      groupIndexBtn1:SetShow(false)
      groupIndexBtn2:SetShow(false)
      groupIndexBtn3:SetShow(false)
      btnUp:SetShow(false)
      btnDown:SetShow(false)
      btnFusion:SetPosX(btnUnseal:GetPosX() + btnFusion:GetSizeX())
      btnCantFusion:SetPosX(btnUnseal:GetPosX() + btnFusion:GetSizeX())
      btnUnFusion:SetPosX(btnUnseal:GetPosX() + btnFusion:GetSizeX())
    end
  end
  btnSeal:setNotImpactScrollEvent(true)
  btnUnseal:setNotImpactScrollEvent(true)
  btnFusion:setNotImpactScrollEvent(true)
  icon:ChangeTextureInfoName(iconPath)
  tier:SetFontColor(gradeColorConfig[petTier - 1])
  tier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", petTier))
  level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(petLevel))
  local propertyText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETINFO_SPECIALSKILL", "paramText", PetList_SkillTypeString(skillType))
  property:SetTextMode(UI_TM.eTextMode_LimitText)
  property:SetText(propertyText)
  if property:IsLimitText() then
    property:addInputEvent("Mouse_On", "HandleOver_PetProperty_Tooltip_Show(" .. skillType .. ")")
    property:addInputEvent("Mouse_Out", "HandleOver_PetProperty_Tooltip_Hide()")
  else
    property:addInputEvent("Mouse_On", "")
    property:addInputEvent("Mouse_Out", "")
  end
  if false == PaGlobalFunc_PetFusion_GetShow() then
    gradeMark:SetShow(false)
  else
    hungryProgress:SetShow(false)
    hungryBg:SetShow(false)
    hungryIcon:SetShow(false)
    hungryPercentText:SetShow(false)
    local grade = ToClient_getGrade(petStaticStatus:getPetRace(), petStaticStatus:getPetKind())
    gradeMark:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Pet_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(gradeMark, gradeTypeUV[grade - 1][1], gradeTypeUV[grade - 1][2], gradeTypeUV[grade - 1][3], gradeTypeUV[grade - 1][4])
    gradeMark:getBaseTexture():setUV(x1, y1, x2, y2)
    gradeMark:setRenderTexture(gradeMark:getBaseTexture())
    gradeMark:SetShow(99 ~= petStaticStatus:getPetRace())
  end
end
function PaGlobalFunc_PetFusion_FusionButtonShowCheck(petNo_s64, petTier, petRace)
  if false == PaGlobalFunc_PetFusion_GetShow() then
    return false
  end
  if true == PaGlobalFunc_PetFusion_IsExist(petNo_s64) then
    return false
  end
  if false == PaGlobalFunc_PetList_CheckFusionButtonPcRoomPet(petNo_s64) then
    return false
  end
  return true
end
function PaGlobalFunc_PetFusion_FusionButtonMonoTonCheck(petNo_s64, petTier, petRace)
  if false == PaGlobalFunc_PetFusion_GetShow() then
    return false
  end
  if 100 <= PaGlobalFunc_PetFusion_GetRate() then
    return true
  end
  if false == PaGlobalFunc_PetFusion_IsMainPetSet() and 99 == petRace then
    return true
  end
  if 99 ~= petRace and false == PaGlobalFunc_PetFusion_SetAbleByGrade(petNo_s64) then
    return true
  end
  if false == PaGlobalFunc_PetFusion_SetAbleByTier(petTier) then
    return true
  end
  if true == PaGlobalFunc_PetFusion_IsMainPetSet() and 99 == petRace and false == PaGlobalFunc_PetFusion_GetIsJokerPetUse() then
    return true
  end
  if false == PaGlobalFunc_PetList_CheckFusionButtonPcRoomPet(petNo_s64) then
    return true
  end
  return false
end
function PaGlobalFunc_PetList_CheckFusionButtonPcRoomPet(petNo_s64)
  local sealPetCount = ToClient_getPetSealedList()
  for index = 0, sealPetCount do
    local petData = ToClient_getPetSealedDataByIndex(index)
    if nil ~= petData and true == petData:getPetStaticStatus():isOnlyPcRoom() and petNo_s64 == petData._petNo then
      return false
    end
  end
  return true
end
function PaGlobalFunc_PetFusion_UnFusionButtonCheck(petNo_s64)
  if true == PaGlobalFunc_PetFusion_IsExist(petNo_s64) then
    return true
  end
  return false
end
function PetList_BaseSkill_ShowTooltip(baseskillindex, typeStr)
  local skillStaticStatus = ToClient_getPetBaseSkillStaticStatus(baseskillindex)
  local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
  local petSkillNo = skillStaticStatus:getSkillNo()
  Panel_SkillTooltip_Show(petSkillNo, false, typeStr)
end
function PetList_BaseSkill_HideTooltip()
  Panel_SkillTooltip_Hide()
end
function PetList_ShowSkillToolTip(skill_idx, typeStr, key)
  local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
  local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
  local petSkillNo = skillStaticStatus:getSkillNo()
  if nil ~= key then
    PaGlobalFunc_PetFusion_SkillSelectOn(key)
  end
  Panel_SkillTooltip_Show(petSkillNo, false, typeStr)
end
function PetList_HideSkillToolTip(key)
  Panel_SkillTooltip_Hide()
  if nil ~= key then
    PaGlobalFunc_PetFusion_SkillSelectOff(key)
  end
end
function petListNew_SetOrder(orderType, index)
  local pcPetData = ToClient_getPetUnsealedDataByIndex(index)
  if nil ~= pcPetData then
    FGlobal_PetControl_OrderList(orderType, index)
  end
end
function petListNew_SetOrderAll(orderType, index)
  local selectedPetData = ToClient_getPetUnsealedDataByIndex(index)
  if nil == selectedPetData then
    return
  end
  local selectedPetNo_s64 = selectedPetData:getPcPetNo()
  local currentState
  if 0 == orderType then
    currentState = PetList.orderList._follow[tostring(selectedPetNo_s64)]
  elseif 1 == orderType then
    currentState = PetList.orderList._find[tostring(selectedPetNo_s64)]
  else
    currentState = PetList.orderList._getItem[tostring(selectedPetNo_s64)]
  end
  local unsealPetCount = ToClient_getPetUnsealedList()
  for pIndex = 0, unsealPetCount - 1 do
    local pcPetData = ToClient_getPetUnsealedDataByIndex(pIndex)
    if nil ~= pcPetData then
      local petNo_s64 = pcPetData:getPcPetNo()
      if 0 == orderType then
        if currentState == PetList.orderList._follow[tostring(petNo_s64)] then
          petListNew_SetOrder(orderType, pIndex)
        end
      elseif 1 == orderType then
        if currentState == PetList.orderList._find[tostring(petNo_s64)] then
          petListNew_SetOrder(orderType, pIndex)
        end
      elseif 2 == orderType and currentState == PetList.orderList._getItem[tostring(petNo_s64)] then
        petListNew_SetOrder(orderType, pIndex)
      end
    end
  end
end
function petListNew_SetPlay(index)
  local pcPetData = ToClient_getPetUnsealedDataByIndex(index)
  if nil ~= pcPetData then
    local petNo = pcPetData:getPcPetNo()
    local petLootingType = (pcPetData:getPetLootingType() + 1) % 3
    ToClient_requestChangePetLootingType(petNo, petLootingType)
    local playAction_Fly = false
    local petRace = pcPetData:getPetStaticStatus():getPetRace()
    for index = 1, #isPetFlyPet do
      if petRace == isPetFlyPet[index] then
        playAction_Fly = true
      end
    end
  end
end
function petListNew_SetPlayAll(index)
  local selectedPetData = ToClient_getPetUnsealedDataByIndex(index)
  if nil == selectedPetData then
    return
  end
  local petLootingType = (selectedPetData:getPetLootingType() + 1) % 3
  local unsealPetCount = ToClient_getPetUnsealedList()
  for pIndex = 0, unsealPetCount - 1 do
    local pcPetData = ToClient_getPetUnsealedDataByIndex(pIndex)
    if nil ~= pcPetData then
      local petNo = pcPetData:getPcPetNo()
      ToClient_requestChangePetLootingType(petNo, petLootingType)
    end
  end
end
function FGlobal_PetList_PetOrder(index)
  local pcPetData = ToClient_getPetUnsealedDataByIndex(index)
  if nil ~= pcPetData then
    local petNo = pcPetData:getPcPetNo()
    PetList.list2_PetList:requestUpdateByKey(petNo)
  end
end
function petListNew_OrderTooltip(orderType, index)
  if nil == orderType then
    TooltipSimple_Hide()
    return
  end
  local pcPetData = ToClient_getPetUnsealedDataByIndex(index)
  if nil == pcPetData then
    return
  end
  local key = pcPetData:getPcPetNo()
  local control = PetList.list2_PetList
  local contents = control:GetContentByKey(key)
  local orderFollow = UI.getChildControl(contents, "CheckButton_Follow")
  local orderWait = UI.getChildControl(contents, "CheckButton_Wait")
  local orderFind = UI.getChildControl(contents, "CheckButton_Find")
  local orderGetItem = UI.getChildControl(contents, "CheckButton_GetItem")
  local orderPlay = UI.getChildControl(contents, "CheckButton_Play")
  local hungryProgress = UI.getChildControl(contents, "Template_Static_Progress_Hungry")
  local hungryPercentText = UI.getChildControl(contents, "StaticText_HungryPercent")
  local hungryIcon = UI.getChildControl(contents, "Template_Static_HungryIcon")
  local btnInfo = UI.getChildControl(contents, "Template_Button_Info")
  local btnSeal = UI.getChildControl(contents, "Template_Button_Seal")
  local btnFusion = UI.getChildControl(contents, "Template_Button_Fusion")
  local btnFeed = UI.getChildControl(contents, "Button_Feeding")
  local uiControl, name, desc
  if 0 == orderType then
    uiControl = orderFollow
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_FOLLOW_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_FOLLOW_DESC")
  elseif 1 == orderType then
    uiControl = orderWait
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_WAIT_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_WAIT_DESC")
  elseif 2 == orderType then
    uiControl = orderGetItem
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_FIND_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_FIND_DESC")
  elseif 3 == orderType then
    uiControl = orderFind
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_GETITEM_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_GETITEM_DESC")
  elseif 4 == orderType then
    local petLootingType = pcPetData:getPetLootingType()
    local lootingTypeString = ""
    if 0 == petLootingType then
      lootingTypeString = PAGetString(Defines.StringSheet_GAME, "LUA_IPETCONTROL_TOOLTIP_LOOTINGTYPE_0")
    elseif 1 == petLootingType then
      lootingTypeString = PAGetString(Defines.StringSheet_GAME, "LUA_IPETCONTROL_TOOLTIP_LOOTINGTYPE_1")
    elseif 2 == petLootingType then
      lootingTypeString = PAGetString(Defines.StringSheet_GAME, "LUA_IPETCONTROL_TOOLTIP_LOOTINGTYPE_2")
    end
    uiControl = orderPlay
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PLAY_NAME") .. lootingTypeString
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PLAY_DESC")
  elseif 5 == orderType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_HUNGRY_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_HUNGRY_DESC")
    uiControl = hungryProgress
  elseif 6 == orderType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_HUNGRY_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_HUNGRY_DESC")
    uiControl = hungryPercentText
  elseif 7 == orderType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_HUNGRY_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_HUNGRY_DESC")
    uiControl = hungryIcon
  elseif 8 == orderType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_INFO_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_INFO_DESC")
    uiControl = btnInfo
  elseif 9 == orderType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_SEAL_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_SEAL_DESC")
    uiControl = btnSeal
  elseif 10 == orderType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_FUSION_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_FUSION_DESC")
    uiControl = btnFusion
  elseif 11 == orderType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_FEED_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_FEED_DESC")
    uiControl = btnFeed
  end
  TooltipSimple_Show(uiControl, name, desc)
end
function PetListNew_SimpleTooltipBTN(isShow, index, tipType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  local pcPetData = ToClient_getPetSealedDataByIndex(index)
  if nil == pcPetData then
    return
  end
  local key = pcPetData._petNo
  local contents = PetList.list2_PetList:GetContentByKey(key)
  local btn_Unseal = UI.getChildControl(contents, "Template_Button_Unseal")
  local hungryProgress = UI.getChildControl(contents, "Template_Static_Progress_Hungry")
  local hungryPercentText = UI.getChildControl(contents, "StaticText_HungryPercent")
  local hungryIcon = UI.getChildControl(contents, "Template_Static_HungryIcon")
  local btnUp = UI.getChildControl(contents, "Button_Up")
  local btnDown = UI.getChildControl(contents, "Button_Down")
  local groupIndexBtn1 = UI.getChildControl(contents, "Template_Button_GroupIndex1")
  local groupIndexBtn2 = UI.getChildControl(contents, "Template_Button_GroupIndex2")
  local groupIndexBtn3 = UI.getChildControl(contents, "Template_Button_GroupIndex3")
  local btnFusion = UI.getChildControl(contents, "Template_Button_Fusion")
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_UNSEAL_NAME")
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_UNSEAL_DESC", "count", maxUnsealCount)
    control = btn_Unseal
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_HUNGRY_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_HUNGRY_DESC")
    control = hungryProgress
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_HUNGRY_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_HUNGRY_DESC")
    control = hungryPercentText
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_HUNGRY_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_HUNGRY_DESC")
    control = hungryIcon
  elseif 4 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_CHANGEORDER_UP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_CHANGEORDER_UP_DESC")
    control = btnUp
  elseif 5 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_CHANGEORDER_DOWN_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_CHANGEORDER_DOWN_DESC")
    control = btnDown
  elseif 6 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_GROUP1_NAME")
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_GROUP1_DESC", "count", maxUnsealCount)
    control = groupIndexBtn1
  elseif 7 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_GROUP2_NAME")
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_GROUP2_DESC", "count", maxUnsealCount)
    control = groupIndexBtn2
  elseif 8 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_GROUP3_NAME")
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_GROUP3_DESC", "count", maxUnsealCount)
    control = groupIndexBtn3
  elseif 9 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_PETLISTNEW_COMPOSE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TOOLTIP_BTN_FUSION_DESC")
    control = btnFusion
  end
  TooltipSimple_Show(control, name, desc)
end
function PetList_SkillTypeString(skillType)
  local paramText = ""
  if 1 == skillType then
    paramText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_ITEMGETTIME", "itemGetTime", string.format("%.1f", skillParam:getParam(0) / 1000))
  elseif 2 == skillType then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDGATHER")
  elseif 3 == skillType then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDPK")
  elseif 4 == skillType then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDPLACE")
  elseif 5 == skillType then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_MOBAGGRO")
  elseif 6 == skillType then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDRAREMONSTER")
  elseif 7 == skillType then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_REDUCEAUTOFISHINGTIME")
  elseif 8 == skillType then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_REGISTILL")
  elseif 9 == skillType then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_AUTOGETHERING")
  elseif 10 == skillType then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_GETHERINGINCREASE")
  elseif 11 == skillType then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_HPRECOVERY")
  elseif 12 == skillType then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_MPRECOVERY")
  end
  return paramText
end
function PetList:initializeFeedAllUi()
  local closeButton = UI.getChildControl(self.feedAllUi, "Button_Close")
  closeButton:addInputEvent("Mouse_LUp", "HandleClicked_PetList_FeedAllClose()")
  local cancelButton = UI.getChildControl(self.feedAllUi, "Button_Cancel")
  cancelButton:addInputEvent("Mouse_LUp", "HandleClicked_PetList_FeedAllClose()")
  local adminButton = UI.getChildControl(self.feedAllUi, "Button_Restore")
  adminButton:addInputEvent("Mouse_LUp", "PetList_useFeedItemToAll()")
  self.selectAllSlotBg = UI.getChildControl(self.feedAllUi, "Static_Selected_Item_Icon")
  local originalSlot = UI.getChildControl(self.feedAllUi, "Static_Restore_Item_Icon")
  local slotGap = originalSlot:GetSizeX() + 5
  for i = 0, self.feedStaticItemCount - 1 do
    local slotBg = UI.createAndCopyBasePropertyControl(self.feedAllUi, "Static_Restore_Item_Icon_BG", self.feedAllUi, "Static_Restore_Item_Icon" .. tostring(i))
    slotBg:SetPosX(originalSlot:GetPosX() + slotGap * i)
    slotBg:SetShow(false)
    self.feedAllSlot[i] = {}
    SlotItem.new(self.feedAllSlot[i], "FeedAllItem_", i, slotBg, self.config)
    self.feedAllSlot[i]:createChild()
    self.feedAllSlot[i].border:SetSize(34, 34)
    self.feedAllSlot[i].icon:SetSize(34, 34)
    self.feedAllSlot[i].count:ComputePos()
  end
end
function PetList:initializeFeedUi()
  local closeButton = UI.getChildControl(self.feedUi, "Button_Close")
  closeButton:addInputEvent("Mouse_LUp", "HandleClicked_PetList_FeedClose()")
  self.selectSlotBg = UI.getChildControl(self.feedUi, "Static_Selected_Item_Icon")
  local feedOneButton = UI.getChildControl(self.feedUi, "Button_FeedOne")
  feedOneButton:addInputEvent("Mouse_LUp", "PetList_useFeedOneItem()")
  local feedFullButton = UI.getChildControl(self.feedUi, "Button_FeedFull")
  feedFullButton:addInputEvent("Mouse_LUp", "PetList_useFeedFullItem()")
  local originalSlot = UI.getChildControl(self.feedUi, "Static_IconBg")
  originalSlot:SetShow(false)
  local slotGap = originalSlot:GetSizeX() + 5
  for i = 0, self.feedStaticItemCount - 1 do
    local additionalSlot = UI.createAndCopyBasePropertyControl(self.feedUi, "Static_IconBg", self.feedUi, "Static_IconBg" .. tostring(i))
    additionalSlot:SetPosX(originalSlot:GetPosX() + slotGap * i)
    additionalSlot:SetShow(false)
    self.feedSlot[i] = {}
    SlotItem.new(self.feedSlot[i], "FeedItem_", i, additionalSlot, self.config)
    self.feedSlot[i]:createChild()
    self.feedSlot[i].border:SetSize(34, 34)
    self.feedSlot[i].icon:SetSize(34, 34)
    self.feedSlot[i].count:ComputePos()
  end
end
function PetList:initializeFilterUi()
  PetList.filterBg:SetShow(false)
  PetList.BTN_pcRoomRegist:addInputEvent("Mouse_LUp", "HandleEventLUp_PetList_pcRoomRegistButtonClick()")
  PetList.BTN_pcRoomRegist:addInputEvent("Mouse_On", "PaGloabl_PetList_PcRoomRegistShowToolTip()")
  PetList.BTN_pcRoomRegist:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  allPetButton = UI.getChildControl(PetList.filterBg, "RadioButton_All")
  allPetButton:addInputEvent("Mouse_LUp", "HandleEventLUp_PetList_ChangeFilter()")
  allPetButton:SetEnableArea(0, 0, allPetButton:GetSizeX() + allPetButton:GetTextSizeX(), allPetButton:GetSizeY())
  normalPetButton = UI.getChildControl(PetList.filterBg, "RadioButton_Normal")
  normalPetButton:addInputEvent("Mouse_LUp", "HandleEventLUp_PetList_ChangeFilter()")
  normalPetButton:SetEnableArea(0, 0, normalPetButton:GetSizeX() + normalPetButton:GetTextSizeX(), normalPetButton:GetSizeY())
  pcRoomPetButton = UI.getChildControl(PetList.filterBg, "RadioButton_PCRoom")
  pcRoomPetButton:addInputEvent("Mouse_LUp", "HandleEventLUp_PetList_ChangeFilter()")
  pcRoomPetButton:SetEnableArea(0, 0, pcRoomPetButton:GetSizeX() + pcRoomPetButton:GetTextSizeX(), pcRoomPetButton:GetSizeY())
  allPetButton:SetCheck(true)
  local addPosY = PetList.filterBg:GetSizeY()
  Panel_Window_PetListNew:SetSize(Panel_Window_PetListNew:GetSizeX(), Panel_Window_PetListNew:GetSizeY() + addPosY)
  PetList.BTN_Compose:SetPosY(PetList.BTN_Compose:GetPosY() + addPosY)
  PetList.BTN_FeedAll:SetPosY(PetList.BTN_FeedAll:GetPosY() + addPosY)
  PetList.BTN_AllUnSeal:SetPosY(PetList.BTN_AllUnSeal:GetPosY() + addPosY)
  PetList.BTN_GroupSeal1:SetPosY(PetList.BTN_GroupSeal1:GetPosY() + addPosY)
  PetList.BTN_GroupSeal2:SetPosY(PetList.BTN_GroupSeal2:GetPosY() + addPosY)
  PetList.BTN_GroupSeal3:SetPosY(PetList.BTN_GroupSeal3:GetPosY() + addPosY)
  PetList.BTN_ClearGroup:SetPosY(PetList.BTN_ClearGroup:GetPosY() + addPosY)
  PetList.BTN_Market:SetPosY(PetList.BTN_Market:GetPosY() + addPosY)
  PetList.list2_PetList:SetPosY(PetList.list2_PetList:GetPosY() + addPosY)
  PetList.feedUi:SetPosY(PetList.feedUi:GetPosY() + addPosY)
  PetList.skillInfoBg:SetPosY(PetList.skillInfoBg:GetPosY() + addPosY)
  PetList.BTN_pcRoomRegist:SetPosY(PetList.BTN_pcRoomRegist:GetPosY() + addPosY)
  PetList.orderBg:SetPosY(PetList.orderBg:GetPosY() + addPosY)
  PetList.groupTitle:SetPosY(PetList.groupTitle:GetPosY() + addPosY)
end
function FromClient_PetList_UpdateFeedUi()
  if true == _ContentsGroup_InvenUpdateCheck and false == Panel_Window_PetListNew:GetShow() then
    return
  end
  PetList:updateFeedUi()
  PetList:updateFeedAllUi()
end
function PetList:updateUserFeedItemCount(count)
  if self.cachedUserFeedItemCount ~= count then
    self:initSelection()
  end
  self.cachedUserFeedItemCount = count
end
function PetList:initSelection()
  self.selectItemIndex = -1
  self.selectSlotBg:SetShow(false)
  self.selectAllSlotBg:SetShow(false)
end
function PetList:updateFeedAllUi()
  if not self.feedAllUi:GetShow() then
    return
  end
  local userFeedItemCount = ToClient_Pet_GetFeedItemCount()
  self:updateUserFeedItemCount(userFeedItemCount)
  for i = 0, self.feedStaticItemCount - 1 do
    local targetSlot = UI.getChildControl(self.feedAllUi, "Static_Restore_Item_Icon" .. tostring(i))
    if i < userFeedItemCount then
      targetSlot:SetShow(true)
      local feedItem = ToClient_Pet_GetFeedItemByIndex(i)
      if not feedItem then
        return
      end
      local feedItemKey = feedItem:get():getKey():getItemKey()
      local feedItemCount = feedItem:get():getCount_s64()
      self.feedAllSlot[i]:setItem(feedItem)
      self.feedAllSlot[i].icon:addInputEvent("Mouse_LUp", "HandleClicked_PetList_FeedItemToAll(" .. i .. ")")
      self.feedAllSlot[i].icon:addInputEvent("Mouse_On", "HandleOver_PetRestore_FeedItem_ShowTooltip(" .. i .. ")")
      self.feedAllSlot[i].icon:addInputEvent("Mouse_Out", "HandleOver_PetRestore_FeedItem_HideTooltip()")
    else
      targetSlot:SetShow(false)
      targetSlot:removeInputEvent("Mouse_LUp")
    end
  end
  if userFeedItemCount > 6 then
    self.feedAllUi:SetSize(userFeedItemCount * 39 + 30, self.feedAllUi:GetSizeY())
    UI.getChildControl(self.feedAllUi, "Static_ItemList_BG"):SetSize(self.feedAllUi:GetSizeX() - 10, 128)
  else
    self.feedAllUi:SetSize(260, self.feedAllUi:GetSizeY())
    UI.getChildControl(self.feedAllUi, "Static_ItemList_BG"):SetSize(self.feedAllUi:GetSizeX() - 10, 128)
  end
  UI.getChildControl(self.feedAllUi, "Button_Close"):ComputePos()
  UI.getChildControl(self.feedAllUi, "Button_Cancel"):ComputePos()
  UI.getChildControl(self.feedAllUi, "Button_Restore"):ComputePos()
end
function PetList:updateFeedUi()
  if not self.feedUi:GetShow() then
    return
  end
  local userFeedItemCount = ToClient_Pet_GetFeedItemCount()
  self:updateUserFeedItemCount(userFeedItemCount)
  for i = 0, self.feedStaticItemCount - 1 do
    local targetSlot = UI.getChildControl(self.feedUi, "Static_IconBg" .. tostring(i))
    if i < userFeedItemCount then
      targetSlot:SetShow(true)
      local feedItem = ToClient_Pet_GetFeedItemByIndex(i)
      if not feedItem then
        return
      end
      self.feedSlot[i]:setItem(feedItem)
      self.feedSlot[i].icon:addInputEvent("Mouse_On", "HandleOver_PetList_FeedItem_ShowTooltip(" .. i .. ")")
      self.feedSlot[i].icon:addInputEvent("Mouse_Out", "HandleOver_PetList_FeedItem_HideTooltip()")
      self.feedSlot[i].icon:addInputEvent("Mouse_LUp", "HandleClicked_PetList_FeedItem(" .. i .. ")")
    else
      targetSlot:SetShow(false)
      targetSlot:removeInputEvent("Mouse_LUp")
    end
  end
  local subFrameTitle = UI.getChildControl(self.feedUi, "Static_subframetitle")
  if userFeedItemCount > 5 then
    local targetSlot = UI.getChildControl(self.feedUi, "Static_IconBg" .. tostring(userFeedItemCount - 1))
    self.feedUi:SetSize(targetSlot:GetPosX() + targetSlot:GetSizeX() + 16, self.feedUi:GetSizeY())
    subFrameTitle:SetSize(self.feedUi:GetSizeX() - 8, subFrameTitle:GetSizeY())
  else
    self.feedUi:SetSize(225, self.feedUi:GetSizeY())
    subFrameTitle:SetSize(self.feedUi:GetSizeX() - 8, subFrameTitle:GetSizeY())
  end
  UI.getChildControl(self.feedUi, "Button_Close"):ComputePos()
  UI.getChildControl(self.feedUi, "Button_FeedOne"):ComputePos()
  UI.getChildControl(self.feedUi, "Button_FeedFull"):ComputePos()
end
function PetList:showFeedUi(targetPetIndex)
  if self.feedingPetIndex == targetPetIndex then
    targetPetIndex = -1
  end
  self:initSelection()
  local showFlag = targetPetIndex >= 0
  self.feedUi:SetShow(showFlag)
  self.feedingPetIndex = targetPetIndex
  if showFlag then
    PetList:showFeedAllUi(false)
    local petData = ToClient_getPetUnsealedDataByIndex(targetPetIndex)
    if not petData then
      return
    end
    local petNo = petData:getPcPetNo()
    local contents = self.list2_PetList:GetContentByKey(petNo)
    local btnFeed = UI.getChildControl(contents, "Button_Feeding")
    local nameUi = UI.getChildControl(contents, "Template_StaticText_PetName")
    self.feedUi:SetPosX(contents:GetPosX() + btnFeed:GetPosX() + 50)
    self.feedUi:SetPosY(contents:GetPosY() + btnFeed:GetPosY())
    self:updateFeedUi()
    local userFeedItemCount = ToClient_Pet_GetFeedItemCount()
    if userFeedItemCount > 0 then
      HandleClicked_PetList_FeedItem(0)
    end
  end
end
function PetListNew_FeedSimpleTooltip(isShow, control)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local Name = "\235\168\185\236\157\180\234\184\176"
  local desc = "\235\176\152\235\160\164 \235\143\153\235\172\188\236\151\144\234\178\140 \235\168\185\236\157\180\235\165\188 \236\164\132 \236\136\152 \236\158\136\236\138\181\235\139\136\235\139\164."
  TooltipSimple_Show(control, name, desc)
end
function FGlobal_PetList_FeedClose()
  PetList:showFeedUi(-1)
  PetList:showFeedAllUi(false)
end
function PetList_useFeedOneItem()
  local self = PetList
  if self.selectItemIndex < 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETLISTNEW_SELECTFOODALERT"))
    return
  end
  local petData = ToClient_getPetUnsealedDataByIndex(self.feedingPetIndex)
  local petNo = petData:getPcPetNo()
  local fullChargeFlag = isKeyPressed(CppEnums.VirtualKeyCode.KeyCode_SHIFT)
  ToClient_Pet_UseFeedItemByIndex(self.selectItemIndex, petNo)
end
function PetList_useFeedFullItem()
  local self = PetList
  if self.selectItemIndex < 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETLISTNEW_SELECTFOODALERT"))
    return
  end
  local petData = ToClient_getPetUnsealedDataByIndex(self.feedingPetIndex)
  local petNo = petData:getPcPetNo()
  ToClient_Pet_UseFeedItemFullByIndex(self.selectItemIndex, petNo)
end
function PetList_useFeedItemToAll()
  if PetList.selectItemIndex < 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETLISTNEW_SELECTFOODALERT"))
    return
  end
  ToClient_Pet_UseFeedItemFullAll(PetList.selectItemIndex)
end
function PetList:showFeedAllUi(showFlag)
  if showFlag == self.feedAllUi:GetShow() then
    showFlag = false
  end
  local unsealPetCount = ToClient_getPetUnsealedList()
  if showFlag and 0 == unsealPetCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETLISTNEW_UNSEALALERT"))
    return
  end
  self.feedAllUi:SetShow(showFlag)
  self:initSelection()
  if showFlag then
    self:updateFeedAllUi()
    local userFeedItemCount = ToClient_Pet_GetFeedItemCount()
    if userFeedItemCount > 0 then
      HandleClicked_PetList_FeedItemToAll(0)
    end
    Panel_PetRestoreAll:SetPosX(Panel_Window_PetListNew:GetPosX() + Panel_Window_PetListNew:GetSizeX() + 10)
    Panel_PetRestoreAll:SetPosY(Panel_Window_PetListNew:GetPosY() + Panel_Window_PetListNew:GetSizeY() - Panel_PetRestoreAll:GetSizeY())
  end
end
function PetList:registEventHandler()
  self.BTN_Close:addInputEvent("Mouse_LUp", "FGlobal_PetListNew_Close()")
  self.BTN_Compose:addInputEvent("Mouse_LUp", "PetListNew_Compose()")
  self.BTN_Compose:addInputEvent("Mouse_On", "PetListNew_SimpleTooltip(true, 4)")
  self.BTN_Compose:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltip(false)")
  self.BTN_FeedAll:addInputEvent("Mouse_LUp", "HandleClicked_PetList_FeedAll()")
  self.BTN_AllUnSeal:addInputEvent("Mouse_LUp", "FGlobal_HandleClicked_petControl_AllUnSeal()")
  self.BTN_AllUnSeal:addInputEvent("Mouse_On", "PetListNew_SimpleTooltip(true, 5)")
  self.BTN_AllUnSeal:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltip(false)")
  self.BTN_GroupSeal1:addInputEvent("Mouse_LUp", "FGlobal_HandleClicked_petControl_AllSeal(1)")
  self.BTN_GroupSeal2:addInputEvent("Mouse_LUp", "FGlobal_HandleClicked_petControl_AllSeal(2)")
  self.BTN_GroupSeal3:addInputEvent("Mouse_LUp", "FGlobal_HandleClicked_petControl_AllSeal(3)")
  self.BTN_AllUnSeal:setButtonShortcuts("PANEL_SIMPLESHORTCUT_PET_ALLGROUP")
  self.BTN_GroupSeal1:setButtonShortcuts("PANEL_SIMPLESHORTCUT_PET_GROUP1")
  self.BTN_GroupSeal2:setButtonShortcuts("PANEL_SIMPLESHORTCUT_PET_GROUP2")
  self.BTN_GroupSeal3:setButtonShortcuts("PANEL_SIMPLESHORTCUT_PET_GROUP3")
  self.list2_PetList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PetListControlCreate")
  self.list2_PetList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function FromClient_PetPromotion(fromWhereType, fromSlotNo)
end
function PetList:registMessageHandler()
  registerEvent("FromClient_PetAddSealedList", "FromClient_PetUpdate")
  registerEvent("FromClient_PetDelSealedList", "FromClient_PetUpdate_ButtonShow")
  registerEvent("FromClient_PetDelList", "FromClient_PetUpdate")
  registerEvent("FromClient_InputPetName", "FromClient_PetUpdate")
  registerEvent("FromClient_PetAddSealedList", "FGlobal_PetListNew_NoPet")
  registerEvent("FromClient_PetInfoChanged", "FGlobal_PetListNew_NoPet")
  registerEvent("FromClient_PetInfoChanged", "FromClient_PetUpdate")
  registerEvent("FromClient_PetAddList", "FGlobal_PetListNew_NoPet")
  registerEvent("FromClient_PetPromotion", "FromClient_PetPromotion")
  registerEvent("FromClient_InventoryUpdate", "FromClient_PetList_UpdateFeedUi")
  ToClient_getPetInitLuaInfo()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_PetList")
function FromClient_luaLoadComplete_PetList()
  PetList:SkillInfoInit()
  PetList:Initialize()
  PetList:initializeFeedUi()
  PetList:initializeFeedAllUi()
  local temporaryInformation = getTemporaryInformationWrapper()
  if nil ~= temporaryInformation and true == temporaryInformation:isPremiumPcRoom() and true == _ContentsGroup_PcRoomPet then
    PetList:initializeFilterUi()
  end
  PetList:showFeedUi(-1)
  PetList:showFeedAllUi(false)
  petSkillList_Close()
  FGlobal_PetListNew_NoPet()
  Panel_MyHouseNavi_Update(true)
  PetList:registEventHandler()
  PetList:registMessageHandler()
  petGroupList_Load()
  PetList.UnSealDATACount = ToClient_getPetUnsealedList()
  PetList.SealDATACount = ToClient_getPetSealedList()
end
function PetList_VScroll_MoveTop()
  PetList.list2_PetList:moveTopIndex()
end
function PetList_ChangePosition(isUp, index)
  ToClient_changePetListOrder(isUp, index)
  PetList:SetPetList(true)
end
function PetList:IsCheckGroupBtnByPetNo(petNo_s64, groupIndex)
  local isCheck = checkUnSealGroupList[groupIndex][Int64toInt32(petNo_s64)]
  if nil == isCheck then
    isCheck = false
  end
  return isCheck
end
function HandleClicked_PetGroupClear()
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_GROUPCLEAR_ALERT"),
    functionYes = PaGlobal_PetList_GroupClear,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleClicked_PetList_Feed(index)
  PetList:showFeedUi(index)
end
function HandleClicked_PetList_FeedClose()
  PetList:showFeedUi(-1)
end
function HandleClicked_PetList_FeedAll()
  PetList:showFeedUi(-1)
  PetList:showFeedAllUi(true)
end
function HandleClicked_PetList_FeedAllClose()
  PetList:showFeedAllUi(false)
end
function HandleOver_PetList_FeedItem_ShowTooltip(index)
  local itemWrapper = ToClient_Pet_GetFeedItemByIndex(index)
  if nil == itemWrapper then
    return
  end
  local itemSSW = itemWrapper:getStaticStatus()
  if nil ~= itemSSW then
    Panel_Tooltip_Item_SetPosition(index, PetList.feedSlot[index].icon, "petList")
    Panel_Tooltip_Item_Show(itemSSW, Panel_Window_PetListNew, true)
  end
end
function HandleOver_PetList_FeedItem_HideTooltip()
  Panel_Tooltip_Item_hideTooltip()
end
function HandleOver_PetRestore_FeedItem_ShowTooltip(index)
  local itemWrapper = ToClient_Pet_GetFeedItemByIndex(index)
  if nil == itemWrapper then
    return
  end
  local itemSSW = itemWrapper:getStaticStatus()
  if nil ~= itemSSW then
    Panel_Tooltip_Item_SetPosition(index, PetList.feedAllSlot[index].icon, "petList")
    Panel_Tooltip_Item_Show(itemSSW, Panel_PetRestoreAll, true)
  end
end
function HandleOver_PetRestore_FeedItem_HideTooltip()
  Panel_Tooltip_Item_hideTooltip()
end
function HandleClicked_PetList_FeedItem(index)
  PetList.selectItemIndex = index
  PetList.selectSlotBg:SetShow(true)
  PetList.selectSlotBg:SetPosX(15 + 39 * index)
end
function HandleClicked_PetList_FeedItemToAll(index)
  PetList.selectItemIndex = index
  PetList.selectAllSlotBg:SetShow(true)
  PetList.selectAllSlotBg:SetPosX(15 + 39 * index)
end
function PaGlobal_PetList_GroupClear()
  checkUnSealGroupList[1] = {}
  checkUnSealGroupList[2] = {}
  checkUnSealGroupList[3] = {}
  petGroupList_Save()
  PetList:SetPetList()
end
function PaGlobal_PetList_CheckGroup()
  for ii = 1, 3 do
    for key, value in pairs(checkUnSealGroupList[ii]) do
      local isRemain = false
      if true == value then
        for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
          local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
          if key == Int64toInt32(petData._petNo) then
            isRemain = true
          end
        end
        for sealPetIndex = 0, ToClient_getPetUnsealedList() - 1 do
          local petData = ToClient_getPetUnsealedDataByIndex(sealPetIndex)
          if key == Int64toInt32(petData:getPcPetNo()) then
            isRemain = true
          end
        end
      end
      if false == isRemain then
        checkUnSealGroupList[ii][key] = false
      end
      if true == isRemain then
        checkUnSealGroupList[ii][key] = true
      end
    end
  end
end
function test_pet()
end
function PaGlobalFunc_PetList_PopUp()
  if _checkButtonPopup:IsCheck() then
    Panel_Window_PetListNew:OpenUISubApp()
  else
    Panel_Window_PetListNew:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function PaGlobalFunc_PetList_PopUp_ShowToolTip(isShow)
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
    if _checkButtonPopup:IsCheck() then
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_CHECK_TOOLTIP")
    else
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_NOCHECK_TOOLTIP")
    end
    TooltipSimple_Show(_checkButtonPopup, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HandleEventLUp_PetList_ChangeFilter()
  PetList:SetPetList()
end
function HandleEventLUp_PetList_pcRoomRegistButtonClick()
  function registPcRoomPet()
    ToClient_requestPetForPcRoomRegister()
    PetList.BTN_pcRoomRegist:SetShow(false)
    PetList.filterBg:SetShow(true)
  end
  local memoTitle = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_Function_Alert")
  local memoContent = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_PETLIST_ALL_PCROOM_MESSAGEBOX_DESC")
  local messageBoxData = {
    title = memoTitle,
    content = memoContent,
    functionYes = registPcRoomPet,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGloabl_PetList_PcRoomRegistShowToolTip()
  local name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_PETLIST_REGISTEPCROOMMAIDBUTTON")
  local dese = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_PETLIST_ALL_PCROOM_REGISTER_DESC")
  TooltipSimple_Show(PetList.BTN_pcRoomRegist, name, dese)
end
