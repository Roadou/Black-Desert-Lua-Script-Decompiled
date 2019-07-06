local UI_TM = CppEnums.TextMode
local bookAreaTextureKeyGroup = {
  [1] = {
    _cnt = 13,
    _cntGroup = {
      [1] = 4,
      [2] = 7,
      [3] = 9,
      [4] = 10,
      [5] = 11,
      [6] = 12,
      [7] = 13
    },
    _textureGroupKey = {
      [1] = 1,
      [2] = 4,
      [3] = 5,
      [4] = 2,
      [5] = 3,
      [6] = 6,
      [7] = 7
    }
  },
  [2] = {
    _cnt = 9,
    _cntGroup = {
      [1] = 9
    },
    _textureGroupKey = {
      [1] = 2
    }
  },
  [3] = {
    _cnt = 5,
    _cntGroup = {
      [1] = 1,
      [2] = 2,
      [3] = 3,
      [4] = 5
    },
    _textureGroupKey = {
      [1] = 6,
      [2] = 2,
      [3] = 3,
      [4] = 7
    }
  },
  [4] = {
    _cnt = 10,
    _cntGroup = {
      [1] = 2,
      [2] = 4,
      [3] = 7,
      [4] = 10
    },
    _textureGroupKey = {
      [1] = 7,
      [2] = 5,
      [3] = 4,
      [4] = 2
    }
  },
  [5] = {
    _cnt = 10,
    _cntGroup = {
      [1] = 2,
      [2] = 4,
      [3] = 7,
      [4] = 10
    },
    _textureGroupKey = {
      [1] = 4,
      [2] = 2,
      [3] = 6,
      [4] = 7
    }
  }
}
local bookTextureGroup = {
  [1] = {
    x1 = 1,
    y1 = 305,
    x2 = 22,
    y2 = 402,
    sizeX = 21,
    sizeY = 98
  },
  [2] = {
    x1 = 23,
    y1 = 305,
    x2 = 42,
    y2 = 402,
    sizeX = 19,
    sizeY = 98
  },
  [3] = {
    x1 = 43,
    y1 = 305,
    x2 = 55,
    y2 = 402,
    sizeX = 12,
    sizeY = 97
  },
  [4] = {
    x1 = 56,
    y1 = 305,
    x2 = 67,
    y2 = 402,
    sizeX = 11,
    sizeY = 97
  },
  [5] = {
    x1 = 68,
    y1 = 305,
    x2 = 76,
    y2 = 402,
    sizeX = 8,
    sizeY = 97
  },
  [6] = {
    x1 = 77,
    y1 = 305,
    x2 = 88,
    y2 = 402,
    sizeX = 11,
    sizeY = 97
  },
  [7] = {
    x1 = 89,
    y1 = 305,
    x2 = 106,
    y2 = 402,
    sizeX = 17,
    sizeY = 97
  }
}
local chapterTitleTextureGroup = {
  [1] = "icon/new_icon/03_etc/03_quest_item/00040653.dds",
  [2] = "icon/new_icon/03_etc/03_quest_item/00040663.dds",
  [3] = "icon/quest/journal_awaken.dds",
  [4] = "icon/quest/Journal_Debe.dds",
  [5] = "icon/quest/journal_awaken.dds"
}
local bookShelfTextureGroup = {
  [1] = {
    texture = "renewal/pcremaster/remaster_adventurebook_bookshelf_bg_00.dds",
    panelSize = 646,
    frameSize = 266,
    contentSize = 208
  },
  [2] = {
    texture = "renewal/pcremaster/remaster_adventurebook_bookshelf_bg_01.dds",
    panelSize = 872,
    frameSize = 492,
    contentSize = 434
  },
  [3] = {
    texture = "renewal/pcremaster/remaster_adventurebook_bookshelf_bg_02.dds",
    panelSize = 1098,
    frameSize = 718,
    contentSize = 660
  }
}
function PaGlobal_Achievement_BookShelf:initialize()
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  if true == PaGlobal_Achievement_BookShelf._initialize then
    return
  end
  PaGlobal_Achievement_BookShelf._ui._stc_leftArea = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_centerArea, "Static_LeftArea")
  PaGlobal_Achievement_BookShelf._ui._stc_rightArea = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_centerArea, "Static_RightArea")
  PaGlobal_Achievement_BookShelf._ui._stctxt_topTitle = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_topArea, "StaticText_Title")
  PaGlobal_Achievement_BookShelf._ui._stc_btnClose = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_topArea, "Static_Close")
  PaGlobal_Achievement_BookShelf._ui._stctxt_familyStatIcon = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_leftArea, "StaticText_FamilyStat")
  PaGlobal_Achievement_BookShelf._ui._stc_bookIconGroup = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_leftArea, "Static_BookIcon_Group")
  PaGlobal_Achievement_BookShelf._ui._stctxt_bookIcon = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_bookIconGroup, "Static_BookIcon")
  PaGlobal_Achievement_BookShelf._ui._stctxt_leftTitle = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_leftArea, "StaticText_Left_Title")
  PaGlobal_Achievement_BookShelf._ui._stctxt_bookShelfDesc = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_leftArea, "StaticText_BookShelf_Desc")
  PaGlobal_Achievement_BookShelf._ui._stctxt_bookShelfDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  PaGlobal_Achievement_BookShelf._ui._frame_bookShelf = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_rightArea, "Frame_BookShelf")
  PaGlobal_Achievement_BookShelf._ui._frame_bookShelfContent = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._frame_bookShelf, "Frame_1_Content")
  PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._frame_bookShelfContent, "RadioButton_BookArea")
  PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea_title = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea, "StaticText_BookTitle")
  PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea_bookGroup = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea, "Static_BookGroup")
  PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_1 = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea, "Static_EmptyGroup_1")
  PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_1_object = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_1, "Static_Watch")
  PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_2 = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea, "Static_EmptyGroup_2")
  PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_2_object = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_2, "Static_Vase")
  PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_3 = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea, "Static_EmptyGroup_3")
  PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_3_object_1 = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_3, "Static_CandleStick_1")
  PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_3_object_2 = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_3, "Static_CandleStick_2")
  PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_4 = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea, "Static_EmptyGroup_4")
  PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_4_object_1 = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_4, "Static_Teapot")
  PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_4_object_2 = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_4, "Static_Cup")
  PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea_bookImage = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea_bookGroup, "Static_BookImage")
  PaGlobal_Achievement_BookShelf._ui._list2_bookChapterList = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_leftArea, "List2_BookChapter")
  PaGlobal_Achievement_BookShelf._ui._stctxt_familyName = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_FamilyName")
  PaGlobal_Achievement_BookShelf._ui._stctxt_familyName:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_BOOKSHELF_FAMILYNAME", "familyname", getFamilyName()))
  PaGlobal_Achievement_BookShelf._ui._stctxt_offence = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_Offence")
  PaGlobal_Achievement_BookShelf._ui._stctxt_defence = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_Defence")
  PaGlobal_Achievement_BookShelf._ui._stctxt_maxHp = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_MaxHP")
  PaGlobal_Achievement_BookShelf._ui._stctxt_maxSp = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_MaxSP")
  PaGlobal_Achievement_BookShelf._ui._stctxt_weight = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_Weight")
  PaGlobal_Achievement_BookShelf._ui._stctxt_inven = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_Inven")
  PaGlobal_Achievement_BookShelf._ui._stctxt_hit = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_Hit")
  PaGlobal_Achievement_BookShelf._ui._stctxt_dv = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_DV")
  PaGlobal_Achievement_BookShelf._ui._stctxt_specialStack = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_Special_Stack")
  PaGlobal_Achievement_BookShelf._ui._stctxt_offence_val = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_Offence_Value")
  PaGlobal_Achievement_BookShelf._ui._stctxt_defence_val = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_Defence_Value")
  PaGlobal_Achievement_BookShelf._ui._stctxt_maxHp_val = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_MaxHP_Value")
  PaGlobal_Achievement_BookShelf._ui._stctxt_maxSp_val = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_MaxSP_Value")
  PaGlobal_Achievement_BookShelf._ui._stctxt_weight_val = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_Weight_Value")
  PaGlobal_Achievement_BookShelf._ui._stctxt_inven_val = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_Inven_Value")
  PaGlobal_Achievement_BookShelf._ui._stctxt_hit_val = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_Hit_Value")
  PaGlobal_Achievement_BookShelf._ui._stctxt_dv_val = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_DV_Value")
  PaGlobal_Achievement_BookShelf._ui._stctxt_specialStack_val = UI.getChildControl(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget, "StaticText_Special_Stack_Value")
  local widget_controlGroup = {}
  widget_controlGroup[#widget_controlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_offence
  widget_controlGroup[#widget_controlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_defence
  widget_controlGroup[#widget_controlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_maxHp
  widget_controlGroup[#widget_controlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_maxSp
  widget_controlGroup[#widget_controlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_weight
  widget_controlGroup[#widget_controlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_inven
  widget_controlGroup[#widget_controlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_hit
  widget_controlGroup[#widget_controlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_dv
  widget_controlGroup[#widget_controlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_specialStack
  local widget_valueControlGroup = {}
  widget_valueControlGroup[#widget_valueControlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_familyName
  widget_valueControlGroup[#widget_valueControlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_offence_val
  widget_valueControlGroup[#widget_valueControlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_defence_val
  widget_valueControlGroup[#widget_valueControlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_maxHp_val
  widget_valueControlGroup[#widget_valueControlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_maxSp_val
  widget_valueControlGroup[#widget_valueControlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_weight_val
  widget_valueControlGroup[#widget_valueControlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_inven_val
  widget_valueControlGroup[#widget_valueControlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_hit_val
  widget_valueControlGroup[#widget_valueControlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_dv_val
  widget_valueControlGroup[#widget_valueControlGroup + 1] = PaGlobal_Achievement_BookShelf._ui._stctxt_specialStack_val
  local tempTextSizeX = 0
  for key, value in pairs(widget_controlGroup) do
    if tempTextSizeX < value:GetTextSizeX() then
      tempTextSizeX = value:GetTextSizeX()
    end
  end
  local tempPosX = 100
  if tempTextSizeX > tempPosX then
    local tempSizeX = tempTextSizeX - tempPosX
    PaGlobal_Achievement_BookShelf._ui._stctxt_familyName:SetSize(PaGlobal_Achievement_BookShelf._ui._stctxt_familyName:GetSizeX() + tempSizeX, PaGlobal_Achievement_BookShelf._ui._stctxt_familyName:GetSizeY())
    PaGlobal_Achievement_BookShelf._ui._stctxt_familyName:ComputePos()
    PaGlobal_Achievement_BookShelf._ui._stc_familyWidget:SetSize(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget:GetSizeX() + tempSizeX, PaGlobal_Achievement_BookShelf._ui._stc_familyWidget:GetSizeY())
    PaGlobal_Achievement_BookShelf._ui._stc_familyWidget:SetPosX(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget:GetPosX() - tempSizeX)
    for key, value in pairs(widget_valueControlGroup) do
      value:ComputePos()
    end
  end
  local tempTextSizeX2 = PaGlobal_Achievement_BookShelf._ui._stctxt_familyName:GetTextSizeX()
  local tempPosX2 = 150 + (tempTextSizeX - tempPosX)
  if tempTextSizeX2 > tempPosX2 then
    local tempSizeX = tempTextSizeX2 - tempPosX2
    PaGlobal_Achievement_BookShelf._ui._stctxt_familyName:SetSize(PaGlobal_Achievement_BookShelf._ui._stctxt_familyName:GetSizeX() + tempSizeX, PaGlobal_Achievement_BookShelf._ui._stctxt_familyName:GetSizeY())
    PaGlobal_Achievement_BookShelf._ui._stctxt_familyName:ComputePos()
    PaGlobal_Achievement_BookShelf._ui._stc_familyWidget:SetSize(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget:GetSizeX() + tempSizeX, PaGlobal_Achievement_BookShelf._ui._stc_familyWidget:GetSizeY())
    PaGlobal_Achievement_BookShelf._ui._stc_familyWidget:SetPosX(PaGlobal_Achievement_BookShelf._ui._stc_familyWidget:GetPosX() - tempSizeX)
    for key, value in pairs(widget_valueControlGroup) do
      value:ComputePos()
    end
  end
  PaGlobal_Achievement_BookShelf:registEventHandler()
  PaGlobal_Achievement_BookShelf:validate()
  PaGlobal_Achievement_BookShelf:setBookShelf()
  PaGlobal_Achievement_BookShelf._initialize = true
  PaGlobal_Achievement_BookShelf:update()
end
function PaGlobal_Achievement_BookShelf:returnBookTextureKey(textureKeyGroup, index)
  if nil == textureKeyGroup or nil == index or nil == textureKeyGroup._cntGroup then
    return
  end
  for ii = 1, #textureKeyGroup._cntGroup do
    if index <= textureKeyGroup._cntGroup[ii] then
      return ii
    end
  end
  return
end
function PaGlobal_Achievement_BookShelf:setBookShelfTexture(journalIndex, chapterCnt)
  if nil == journalIndex or nil == chapterCnt then
    return
  end
  local journalKey = PaGlobal_Achievement_BookShelf._journalGroupIndexList[journalIndex]
  if nil == journalKey then
    return
  end
  local textureKey = ToClient_GetJournalShape(journalKey)
  if nil == textureKey then
    textureKey = journalIndex
  end
  local textureKeyGroup = bookAreaTextureKeyGroup[textureKey]
  if nil == textureKeyGroup then
    textureKeyGroup = bookAreaTextureKeyGroup[1]
  end
  if nil == textureKeyGroup then
    return
  end
  local journalContent = PaGlobal_Achievement_BookShelf._journalControlList[journalIndex]
  PaGlobal_Achievement_BookShelf._journalControlList[journalIndex].chapterList = {}
  if nil == journalContent then
    return
  end
  local nextPosX = 0
  for ii = 1, textureKeyGroup._cnt do
    local textureKeyIndex = PaGlobal_Achievement_BookShelf:returnBookTextureKey(textureKeyGroup, ii)
    if nil == textureKeyIndex then
      textureKeyIndex = 1
    end
    local textureKey = textureKeyGroup._textureGroupKey[textureKeyIndex]
    if nil ~= textureKey then
      local bookTextureInfo = bookTextureGroup[textureKey]
      if nil == bookTextureInfo then
        bookTextureInfo = bookTextureGroup[1]
      end
      local stctxt_bookArea_bookImg = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea_bookGroup, "Static_BookImage", journalContent.stctxt_bookArea_bookGroup, "Static_BookImage_" .. ii)
      if nil ~= stctxt_bookArea_bookImg then
        stctxt_bookArea_bookImg:SetIgnore(true)
        stctxt_bookArea_bookImg:SetSize(bookTextureInfo.sizeX, bookTextureInfo.sizeY)
        stctxt_bookArea_bookImg:ComputePos()
        local x1, y1, x2, y2 = setTextureUV_Func(stctxt_bookArea_bookImg, bookTextureInfo.x1, bookTextureInfo.y1, bookTextureInfo.x2, bookTextureInfo.y2)
        stctxt_bookArea_bookImg:getBaseTexture():setUV(x1, y1, x2, y2)
        stctxt_bookArea_bookImg:setRenderTexture(stctxt_bookArea_bookImg:getBaseTexture())
        stctxt_bookArea_bookImg:SetPosX(nextPosX)
        stctxt_bookArea_bookImg:SetPosY(stctxt_bookArea_bookImg:GetPosY() + 5)
        nextPosX = nextPosX + bookTextureInfo.sizeX + 1
        stctxt_bookArea_bookImg:SetShow(false)
        PaGlobal_Achievement_BookShelf._journalControlList[journalIndex].chapterList[#PaGlobal_Achievement_BookShelf._journalControlList[journalIndex].chapterList + 1] = stctxt_bookArea_bookImg
      end
    end
  end
end
function PaGlobal_Achievement_BookShelf:setBookShelf()
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  PaGlobal_Achievement_BookShelf._journalGroupCnt = 0
  local nowjournalGroupCnt = ToClient_GetJournalGroupCount()
  if nil ~= nowjournalGroupCnt and nowjournalGroupCnt > 0 then
    PaGlobal_Achievement_BookShelf._journalGroupCnt = nowjournalGroupCnt
  end
  if PaGlobal_Achievement_BookShelf._journalGroupCnt < 1 then
    return
  end
  local nowJournalMaxKey = math.ceil(PaGlobal_Achievement_BookShelf._journalGroupCnt / PaGlobal_Achievement_BookShelf._BOOK_AREA_CNT)
  local shelfTextureKey = newJournalMaxKey
  local bookShelfTextureInfo = bookShelfTextureGroup[nowJournalMaxKey]
  if nil == bookShelfTextureInfo then
    bookShelfTextureInfo = bookShelfTextureGroup[#bookShelfTextureGroup]
  end
  if nil == bookShelfTextureInfo then
    return
  end
  Panel_Window_Achievement_BookShelf:SetSize(bookShelfTextureInfo.panelSize, Panel_Window_Achievement_BookShelf:GetSizeY())
  PaGlobal_Achievement_BookShelf._ui._stc_topArea:SetSize(bookShelfTextureInfo.panelSize, PaGlobal_Achievement_BookShelf._ui._stc_topArea:GetSizeY())
  PaGlobal_Achievement_BookShelf._ui._stc_centerArea:SetSize(bookShelfTextureInfo.panelSize - 10, PaGlobal_Achievement_BookShelf._ui._stc_rightArea:GetSizeY())
  PaGlobal_Achievement_BookShelf._ui._stc_rightArea:SetSize(bookShelfTextureInfo.frameSize, PaGlobal_Achievement_BookShelf._ui._stc_rightArea:GetSizeY())
  PaGlobal_Achievement_BookShelf._ui._frame_bookShelf:SetSize(bookShelfTextureInfo.frameSize, PaGlobal_Achievement_BookShelf._ui._frame_bookShelf:GetSizeY())
  PaGlobal_Achievement_BookShelf._ui._frame_bookShelfContent:SetSize(bookShelfTextureInfo.frameSize, PaGlobal_Achievement_BookShelf._ui._frame_bookShelfContent:GetSizeY())
  Panel_Window_Achievement_BookShelf:ComputePos()
  PaGlobal_Achievement_BookShelf._ui._stc_btnClose:ComputePos()
  PaGlobal_Achievement_BookShelf._ui._stc_centerArea:ComputePos()
  PaGlobal_Achievement_BookShelf._ui._stc_rightArea:ComputePos()
  PaGlobal_Achievement_BookShelf._ui._frame_bookShelf:ComputePos()
  PaGlobal_Achievement_BookShelf._ui._frame_bookShelfContent:ComputePos()
  PaGlobal_Achievement_BookShelf._ui._frame_bookShelf:ChangeTextureInfoName(bookShelfTextureInfo.texture)
  PaGlobal_Achievement_BookShelf._ui._frame_bookShelf:setRenderTexture(PaGlobal_Achievement_BookShelf._ui._frame_bookShelf:getBaseTexture())
  local lastCalledIndex = 0
  local calledCnt = 0
  _journalControlList = {}
  for index = 1, nowJournalMaxKey * PaGlobal_Achievement_BookShelf._BOOK_AREA_CNT do
    local stc_bookArea = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._frame_bookShelfContent, "RadioButton_BookArea", PaGlobal_Achievement_BookShelf._ui._frame_bookShelfContent, "RadioButton_BookArea_" .. index)
    local stctxt_bookArea_title = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea, "StaticText_BookTitle", stc_bookArea, "StaticText_BookTitle")
    local stctxt_bookArea_bookGroup = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea, "Static_BookGroup", stc_bookArea, "Static_BookGroup")
    local stctxt_bookArea_bookCondition = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea, "StaticText_BookCondition", stc_bookArea, "StaticText_BookCondition")
    local stc_bookArea_emptyControl_1 = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea, "Static_EmptyGroup_1", stc_bookArea, "Static_EmptyGroup_1")
    local stc_bookArea_emptyControl_1_object = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_1, "Static_Watch", stc_bookArea_emptyControl_1, "Static_Watch")
    local stc_bookArea_emptyControl_2 = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea, "Static_EmptyGroup_2", stc_bookArea, "Static_EmptyGroup_2")
    local stc_bookArea_emptyControl_2_object = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_2, "Static_Vase", stc_bookArea_emptyControl_2, "Static_Vase")
    local stc_bookArea_emptyControl_3 = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea, "Static_EmptyGroup_3", stc_bookArea, "Static_EmptyGroup_3")
    local stc_bookArea_emptyControl_3_object_1 = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_3, "Static_CandleStick_1", stc_bookArea_emptyControl_3, "Static_CandleStick_1")
    local stc_bookArea_emptyControl_3_object_2 = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_3, "Static_CandleStick_2", stc_bookArea_emptyControl_3, "Static_CandleStick_2")
    local stc_bookArea_emptyControl_4 = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._radiobtn_bookArea, "Static_EmptyGroup_4", stc_bookArea, "Static_EmptyGroup_4")
    local stc_bookArea_emptyControl_4_object_1 = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_4, "Static_Teapot", stc_bookArea_emptyControl_4, "Static_Teapot")
    local stc_bookArea_emptyControl_4_object_2 = UI.createAndCopyBasePropertyControl(PaGlobal_Achievement_BookShelf._ui._stc_emptyGroup_4, "Static_Cup", stc_bookArea_emptyControl_4, "Static_Cup")
    local callindex = lastCalledIndex + 1
    while true do
      if index <= PaGlobal_Achievement_BookShelf._journalGroupCnt then
      elseif nil ~= ToClient_GetJournalName(callindex) or callindex > PaGlobal_Achievement_BookShelf._MAX_CALLING_COUNT then
        break
      end
      callindex = callindex + 1
    end
    stctxt_bookArea_bookCondition:SetTextMode(UI_TM.eTextMode_AutoWrap)
    stctxt_bookArea_bookCondition:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_BOOKSHELF_CONDITION_" .. callindex))
    stctxt_bookArea_title:SetShow(false)
    stctxt_bookArea_title:SetIgnore(true)
    stctxt_bookArea_bookCondition:SetShow(false)
    stctxt_bookArea_bookCondition:SetIgnore(true)
    stctxt_bookArea_bookGroup:SetShow(false)
    stctxt_bookArea_bookGroup:SetIgnore(true)
    stc_bookArea_emptyControl_1:SetShow(false)
    stc_bookArea_emptyControl_1:SetIgnore(true)
    stc_bookArea_emptyControl_1_object:SetIgnore(true)
    stc_bookArea_emptyControl_2:SetShow(false)
    stc_bookArea_emptyControl_2:SetIgnore(true)
    stc_bookArea_emptyControl_2_object:SetIgnore(true)
    stc_bookArea_emptyControl_3:SetShow(false)
    stc_bookArea_emptyControl_3:SetIgnore(true)
    stc_bookArea_emptyControl_3_object_1:SetIgnore(true)
    stc_bookArea_emptyControl_3_object_2:SetIgnore(true)
    stc_bookArea_emptyControl_4:SetShow(false)
    stc_bookArea_emptyControl_4:SetIgnore(true)
    stc_bookArea_emptyControl_4_object_1:SetIgnore(true)
    stc_bookArea_emptyControl_4_object_2:SetIgnore(true)
    local tempPosX = 29 + PaGlobal_Achievement_BookShelf._BOOK_POS_X * math.floor((index - 1) / PaGlobal_Achievement_BookShelf._BOOK_AREA_CNT)
    local bookAreaPosX = tempPosX + stc_bookArea:GetSizeX() * math.floor((index - 1) / PaGlobal_Achievement_BookShelf._BOOK_AREA_CNT)
    local bookAreaPosY = PaGlobal_Achievement_BookShelf._BOOK_POS_Y[(index - 1) % PaGlobal_Achievement_BookShelf._BOOK_AREA_CNT]
    if nil == bookAreaPosY then
      bookAreaPosY = 0
    end
    local journalContent = {}
    journalContent.stc_bookArea = stc_bookArea
    journalContent.stctxt_bookArea_title = stctxt_bookArea_title
    journalContent.stctxt_bookArea_bookGroup = stctxt_bookArea_bookGroup
    journalContent.stctxt_bookArea_bookCondition = stctxt_bookArea_bookCondition
    PaGlobal_Achievement_BookShelf._journalControlList[index] = {}
    PaGlobal_Achievement_BookShelf._journalControlList[index] = journalContent
    stc_bookArea:SetPosX(bookAreaPosX)
    stc_bookArea:SetPosY(bookAreaPosY)
    if index <= PaGlobal_Achievement_BookShelf._journalGroupCnt then
      PaGlobal_Achievement_BookShelf._journalGroupIndexList[index] = callindex
      local titleText = ToClient_GetJournalName(callindex)
      lastCalledIndex = callindex
      if nil ~= titleText then
        stctxt_bookArea_title:SetShow(true)
        stctxt_bookArea_bookGroup:SetShow(true)
        stctxt_bookArea_title:SetText(titleText)
        local chapterCnt = ToClient_GetChapterCount(callindex)
        PaGlobal_Achievement_BookShelf:setBookShelfTexture(index, chapterCnt)
      end
      stc_bookArea:SetIgnore(false)
      stc_bookArea:addInputEvent("Mouse_LUp", "HandleEventLUp_Achievement_BookShelf_JournalSelect(" .. callindex .. ")")
    else
      stc_bookArea:SetIgnore(true)
      stc_bookArea:addInputEvent("Mouse_LUp", "")
      local emptyIndex = index % PaGlobal_Achievement_BookShelf._BOOK_AREA_CNT
      local emptyControl
      if 1 == emptyIndex then
        emptyControl = stc_bookArea_emptyControl_1
      elseif 2 == emptyIndex then
        emptyControl = stc_bookArea_emptyControl_2
      elseif 3 == emptyIndex then
        emptyControl = stc_bookArea_emptyControl_3
      elseif 0 == emptyIndex then
        emptyControl = stc_bookArea_emptyControl_1
      else
        emptyControl = stc_bookArea_emptyControl_4
      end
      if nil ~= emptyControl then
        emptyControl:SetShow(true)
      end
    end
  end
end
function PaGlobal_Achievement_BookShelf:updateFamilyStat()
  local specialInfo = ToClient_GetFamilySpecialInfo()
  if nil == specialInfo then
    return
  end
  local offence = specialInfo:getFamilySpecialOffence()
  local defence = specialInfo:getFamilySpecialDefence()
  local maxhp = specialInfo:getFamilySpecialMaxHp()
  local maxsp = specialInfo:getFamilySpecialMaxSp()
  local weight = specialInfo:getFamilySpecialWeight()
  local inven = specialInfo:getFamilySpecialInven()
  if nil ~= weight then
    weight = weight / 10000
  end
  local hit = specialInfo:getFamilySpecialHit()
  local dv = specialInfo:getFamilySpecialDv()
  local specialStack = specialInfo:getFamilySpecialStack()
  if nil ~= offence then
    PaGlobal_Achievement_BookShelf._ui._stctxt_offence_val:SetText(offence)
  end
  if nil ~= defence then
    PaGlobal_Achievement_BookShelf._ui._stctxt_defence_val:SetText(defence)
  end
  if nil ~= maxhp then
    PaGlobal_Achievement_BookShelf._ui._stctxt_maxHp_val:SetText(maxhp)
  end
  if nil ~= maxsp then
    PaGlobal_Achievement_BookShelf._ui._stctxt_maxSp_val:SetText(maxsp)
  end
  if nil ~= weight then
    PaGlobal_Achievement_BookShelf._ui._stctxt_weight_val:SetText(weight)
  end
  if nil ~= inven then
    PaGlobal_Achievement_BookShelf._ui._stctxt_inven_val:SetText(inven)
  end
  if nil ~= hit then
    PaGlobal_Achievement_BookShelf._ui._stctxt_hit_val:SetText(hit)
  end
  if nil ~= dv then
    PaGlobal_Achievement_BookShelf._ui._stctxt_dv_val:SetText(dv)
  end
  if nil ~= specialStack then
    PaGlobal_Achievement_BookShelf._ui._stctxt_specialStack_val:SetText(specialStack)
  end
end
function PaGlobal_Achievement_BookShelf:registEventHandler()
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  PaGlobal_Achievement_BookShelf._ui._stc_btnClose:addInputEvent("Mouse_LUp", "HandleEventLUp_Achievement_BookShelf_Close()")
  PaGlobal_Achievement_BookShelf._ui._list2_bookChapterList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_Achievement_BookShelf_BookChapterListCreate")
  PaGlobal_Achievement_BookShelf._ui._list2_bookChapterList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  PaGlobal_Achievement_BookShelf._ui._stctxt_familyStatIcon:addInputEvent("Mouse_On", "HandleEventOn_Achievement_BookShelf_FamilyStat_Toggle(true)")
end
function PaGlobal_Achievement_BookShelf:prepareOpen()
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
end
function PaGlobal_Achievement_BookShelf:open()
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  PaGlobal_Achievement_BookShelf:prepareOpen()
  audioPostEvent_SystemUi(1, 48)
  Panel_Window_Achievement_BookShelf:SetShow(true)
end
function PaGlobal_Achievement_BookShelf:close()
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  Panel_Window_Achievement_BookShelf:SetShow(false)
end
function PaGlobal_Achievement_BookShelf:resetBookShelf()
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  PaGlobal_Achievement_BookShelf._selectedJournalGroup = 1
  PaGlobal_Achievement_BookShelf:update()
end
function PaGlobal_Achievement_BookShelf:journalSelect(journalIndex)
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  if nil ~= journalIndex then
    PaGlobal_Achievement_BookShelf._selectedJournalGroup = journalIndex
  else
    PaGlobal_Achievement_BookShelf._selectedJournalGroup = 1
  end
  PaGlobal_Achievement_BookShelf:chapterListUpdate(journalIndex)
end
function PaGlobal_Achievement_BookShelf:chapterListUpdate(journalIndex)
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  if nil == journalIndex then
    journalIndex = PaGlobal_Achievement_BookShelf._selectedJournalGroup
  end
  if nil == journalIndex then
    return
  end
  if nil == PaGlobal_Achievement_BookShelf._selectedJournalGroup or PaGlobal_Achievement_BookShelf._selectedJournalGroup < 1 then
    return
  end
  local nowChapterCnt = ToClient_GetChapterCount(PaGlobal_Achievement_BookShelf._selectedJournalGroup)
  if nil ~= nowChapterCnt and nowChapterCnt > 0 then
    PaGlobal_Achievement_BookShelf._journalChapterCnt = nowChapterCnt
  end
  local leftTitle = ToClient_GetJournalName(PaGlobal_Achievement_BookShelf._selectedJournalGroup)
  local leftDesc = ToClient_GetJournalDesc(PaGlobal_Achievement_BookShelf._selectedJournalGroup)
  if nil == leftTitle or nil == leftDesc then
    return
  end
  PaGlobal_Achievement_BookShelf._ui._list2_bookChapterList:getElementManager():clearKey()
  PaGlobal_Achievement_BookShelf._ui._stc_bookIconGroup:SetShow(true)
  PaGlobal_Achievement_BookShelf._ui._stctxt_leftTitle:SetShow(true)
  local leftBookTexture = ToClient_GetJournalIcon(journalIndex)
  if nil == leftBookTexture then
    leftBookTexture = chapterTitleTextureGroup[journalIndex]
    if nil == leftBookTexture then
      leftBookTexture = chapterTitleTextureGroup[1]
    end
  end
  PaGlobal_Achievement_BookShelf._ui._stctxt_bookIcon:ChangeTextureInfoName(leftBookTexture)
  local processingChapterCnt = PaGlobal_Achievement_BookShelf:processingChapterCntReturn(PaGlobal_Achievement_BookShelf._selectedJournalGroup)
  if nil == processingChapterCnt then
    processingChapterCnt = 0
  end
  leftTitle = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_BOOKSHELF_SUBTITLE", "title", leftTitle, "count1", processingChapterCnt, "countAll", PaGlobal_Achievement_BookShelf._journalChapterCnt)
  PaGlobal_Achievement_BookShelf._ui._stctxt_leftTitle:SetText(leftTitle)
  PaGlobal_Achievement_BookShelf._ui._stctxt_bookShelfDesc:SetText(leftDesc)
  local nowChapterMaxKey = math.ceil(PaGlobal_Achievement_BookShelf._journalChapterCnt / PaGlobal_Achievement_BookShelf._CHAPTER_ICON_CNT)
  for ii = 1, nowChapterMaxKey do
    PaGlobal_Achievement_BookShelf._ui._list2_bookChapterList:getElementManager():pushKey(ii)
  end
end
function PaGlobal_Achievement_BookShelf:processingChapterCntReturn(journalIndex)
  local processingChapterCnt
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return processingChapterCnt
  end
  if nil == journalIndex then
    return processingChapterCnt
  end
  local nowChapterCnt = ToClient_GetChapterCount(journalIndex)
  if nil == nowChapterCnt or 0 == nowChapterCnt then
    return processingChapterCnt
  end
  processingChapterCnt = 0
  for ii = 1, nowChapterCnt do
    local journalQuestCnt = ToClient_GetJournalQuestCount(journalIndex, ii)
    local addFlag = false
    local questNo = ToClient_GetJournalQuestNo(journalIndex, ii, 0)
    if nil ~= questNo and (true == questList_isClearQuest(questNo._group, questNo._quest) or true == questList_hasProgressQuest(questNo._group, questNo._quest)) then
      addFlag = true
    end
    if true == addFlag then
      processingChapterCnt = processingChapterCnt + 1
    end
  end
  return processingChapterCnt
end
function PaGlobal_Achievement_BookShelf_BookChapterListCreate(content, key)
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  local createIconCnt = PaGlobal_Achievement_BookShelf._CHAPTER_ICON_CNT
  local key32 = Int64toInt32(key)
  for ii = 1, PaGlobal_Achievement_BookShelf._CHAPTER_ICON_CNT do
    local chapterArea = UI.getChildControl(content, "Static_Chapter_Icon_" .. ii)
    local chapterAreaTitle = UI.getChildControl(chapterArea, "StaticText_ChapterTitle")
    if 0 < PaGlobal_Achievement_BookShelf._journalChapterCnt - PaGlobal_Achievement_BookShelf._CHAPTER_ICON_CNT * (key32 - 1) - (ii - 1) then
      local chapterIndex = PaGlobal_Achievement_BookShelf._CHAPTER_ICON_CNT * (key32 - 1) + ii
      local journalQuestCnt = ToClient_GetJournalQuestCount(PaGlobal_Achievement_BookShelf._selectedJournalGroup, chapterIndex)
      if nil == journalQuestCnt then
        return
      end
      local showFlag = false
      for ii = 1, journalQuestCnt do
        local questNo = ToClient_GetJournalQuestNo(PaGlobal_Achievement_BookShelf._selectedJournalGroup, chapterIndex, ii - 1)
        if nil ~= questNo and (true == questList_isClearQuest(questNo._group, questNo._quest) or true == questList_hasProgressQuest(questNo._group, questNo._quest)) then
          showFlag = true
        end
      end
      chapterArea:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_02.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(chapterArea, 206, 33, 307, 154)
      chapterArea:getBaseTexture():setUV(x1, y1, x2, y2)
      x1, y1, x2, y2 = setTextureUV_Func(chapterArea, 104, 33, 205, 154)
      chapterArea:getOnTexture():setUV(x1, y1, x2, y2)
      x1, y1, x2, y2 = setTextureUV_Func(chapterArea, 308, 33, 409, 154)
      chapterArea:getClickTexture():setUV(x1, y1, x2, y2)
      chapterArea:setRenderTexture(chapterArea:getBaseTexture())
      local titleText = chapterIndex
      if false == showFlag then
        titleText = "?"
        chapterArea:addInputEvent("Mouse_LUp", "")
        chapterArea:SetMonoTone(true)
        chapterArea:SetIgnore(true)
      else
        chapterArea:SetMonoTone(false)
        chapterArea:SetIgnore(false)
        chapterArea:addInputEvent("Mouse_LUp", "HandleEventLUp_Achievement_BookShelf_ChapterSelect(" .. chapterIndex .. ")")
        if PaGlobal_Achievement_BookShelf._selectedJournalGroup == 1 and chapterIndex == PaGlobal_Achievement_BookShelf._journalChapterCnt then
          chapterArea:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_02.dds")
          local x1, y1, x2, y2 = setTextureUV_Func(chapterArea, 209, 272, 310, 393)
          chapterArea:getBaseTexture():setUV(x1, y1, x2, y2)
          x1, y1, x2, y2 = setTextureUV_Func(chapterArea, 107, 272, 208, 393)
          chapterArea:getOnTexture():setUV(x1, y1, x2, y2)
          x1, y1, x2, y2 = setTextureUV_Func(chapterArea, 311, 272, 412, 393)
          chapterArea:getClickTexture():setUV(x1, y1, x2, y2)
          chapterArea:setRenderTexture(chapterArea:getBaseTexture())
        end
      end
      chapterAreaTitle:SetText(titleText)
      chapterArea:SetShow(true)
    else
      chapterArea:SetShow(false)
      chapterArea:addInputEvent("Mouse_LUp", "")
    end
  end
end
function PaGlobal_Achievement_BookShelf:chapterSelect(chapterIndex)
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  if nil == chapterIndex then
    return
  end
  local journalQuestCnt = ToClient_GetJournalQuestCount(PaGlobal_Achievement_BookShelf._selectedJournalGroup, chapterIndex)
  if nil == journalQuestCnt or journalQuestCnt < 1 then
    return
  end
  local questNo = ToClient_GetJournalQuestNo(PaGlobal_Achievement_BookShelf._selectedJournalGroup, chapterIndex, 0)
  if nil == questNo then
    return
  end
  if nil ~= PaGlobalFunc_Achievement_Open_From_BookShelf then
    PaGlobalFunc_Achievement_Open_From_BookShelf(questNo._group)
  end
end
function PaGlobal_Achievement_BookShelf:update()
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  if false == PaGlobal_Achievement_BookShelf._initialize then
    return
  end
  PaGlobal_Achievement_BookShelf:updateFamilyStat()
  PaGlobal_Achievement_BookShelf:journalListUpdate()
  PaGlobal_Achievement_BookShelf:chapterListUpdate()
end
function PaGlobal_Achievement_BookShelf:journalListUpdate()
  for index = 1, #PaGlobal_Achievement_BookShelf._journalControlList do
    local journalKey = PaGlobal_Achievement_BookShelf._journalGroupIndexList[index]
    if nil ~= journalKey then
      local processingChapterCnt = PaGlobal_Achievement_BookShelf:processingChapterCntReturn(journalKey)
      if nil ~= processingChapterCnt then
        if 0 == processingChapterCnt then
          PaGlobal_Achievement_BookShelf._journalControlList[index].stctxt_bookArea_bookCondition:SetShow(true)
        else
          PaGlobal_Achievement_BookShelf._journalControlList[index].stctxt_bookArea_bookCondition:SetShow(false)
        end
        local chapterList = PaGlobal_Achievement_BookShelf._journalControlList[index].chapterList
        if nil ~= chapterList then
          for ii = 1, #chapterList do
            if nil ~= chapterList[ii] then
              if ii <= processingChapterCnt then
                chapterList[ii]:SetShow(true)
              else
                chapterList[ii]:SetShow(false)
              end
            end
          end
        end
      end
    end
  end
end
function PaGlobal_Achievement_BookShelf:validate()
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
end
function PaGlobal_Achievement_BookShelf:familyStatToggle(bool)
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  if nil == bool then
    return
  end
  PaGlobal_Achievement_BookShelf._ui._stc_familyWidget:SetShow(bool)
end
function PaGlobal_Achievement_BookShelf_Open()
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  if true == Panel_Window_Achievement_BookShelf:GetShow() then
    PaGlobal_Achievement_BookShelf:close()
  else
    PaGlobal_Achievement_BookShelf:open()
  end
end
function PaGlobal_Achievement_BookShelf_Close()
  if nil == Panel_Window_Achievement_BookShelf or false == _ContentsGroup_AchievementQuest then
    return
  end
  PaGlobal_Achievement_BookShelf:close()
  PaGlobal_Achievement_BookShelf:familyStatToggle(false)
end
