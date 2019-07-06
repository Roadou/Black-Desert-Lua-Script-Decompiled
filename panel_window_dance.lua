Panel_Window_Dance:SetShow(false)
Panel_Window_Dance:RegisterShowEventFunc(true, "Dance_InfoShowAni()")
Panel_Window_Dance:RegisterShowEventFunc(false, "Dance_InfoHideAni()")
Panel_Window_Dance:SetDragAll(true)
local _slide = UI.getChildControl(Panel_Window_Dance, "VerticalScroll")
local _slideBtn = UI.getChildControl(_slide, "VerticalScroll_CtrlButton")
local nSelectDanceList_VisibleMaxCount = 7
local nSelectDance_MaxCount = 0
local listRenderer_UIData = {}
local slideIndex = 0
local tempDanceNameInfo = {
  "DANCE_T00_Step00_Ing_00",
  "DANCE_T00_Step00_Ing_01",
  "DANCE_T00_Step00_Ing_01_M",
  "DANCE_T00_Step00_Ing_02",
  "DANCE_T00_Step00_Ing_02_M",
  "DANCE_T00_Step00_Ing_03",
  "DANCE_T00_Step00_Ing_03_M",
  "DANCE_T00_Step00_Ing_04_L",
  "DANCE_T00_Step00_Ing_04_R",
  "DANCE_T00_Step00_Ing_05",
  "DANCE_T00_Step00_Ing_05_M",
  "DANCE_T00_Step00_Ing_06_L",
  "DANCE_T00_Step00_Ing_06_R",
  "DANCE_T00_Step00_Start_00",
  "DANCE_T00_Step01_End_01_M",
  "DANCE_T00_Step01_End_02",
  "DANCE_T00_Step01_Ing_00",
  "DANCE_T00_Step01_Ing_01",
  "DANCE_T00_Step01_Ing_01_M",
  "DANCE_T00_Step01_Ing_02",
  "DANCE_T00_Step01_Ing_02_M",
  "DANCE_T00_Step01_Ing_03",
  "DANCE_T00_Step01_Ing_03_M",
  "DANCE_T00_Step01_Ing_04",
  "DANCE_T00_Step01_Ing_04_M",
  "DANCE_T00_Step01_Ing_05",
  "DANCE_T00_Step01_Ing_05_M",
  "DANCE_T00_Step01_Ing_06_L",
  "DANCE_T00_Step01_Ing_06_R",
  "DANCE_T00_Step01_Ing_07_L",
  "DANCE_T00_Step01_Ing_07_R",
  "DANCE_T00_Step01_Ing_08_L",
  "DANCE_T00_Step01_Ing_08_R",
  "DANCE_T00_Step01_Ing_09",
  "DANCE_T00_Step01_Ing_09_M",
  "DANCE_T00_Step01_Ing_10",
  "DANCE_T00_Step01_Ing_10_M",
  "DANCE_T00_Step01_Ing_11",
  "DANCE_T00_Step01_Ing_11_M",
  "DANCE_T00_Step01_Ing_12_L",
  "DANCE_T00_Step01_Ing_12_R",
  "DANCE_T00_Step01_Ing_13_L",
  "DANCE_T00_Step01_Ing_13_R",
  "DANCE_T00_Step01_Ing_14",
  "DANCE_T00_Step01_Ing_14_M"
}
function danceInfo_Initialize()
  danceInfo_Basic_Initialize()
  danceInfo_List_Initialize()
end
function danceInfo_Basic_Initialize()
  local comboBoxUI = UI.getChildControl(Panel_Window_Dance, "Combobox_Sort")
  comboBoxUI:addInputEvent("Mouse_LUp", "danceInfo_Combo_show()")
  comboBoxUI:GetListControl():addInputEvent("Mouse_LUp", "Ev_danceInfo_Combo_Select()")
  local btnAdd = UI.getChildControl(Panel_Window_Dance, "BtnAdd")
  btnAdd:addInputEvent("Mouse_LUp", "Ev_danceInfo_DanceAdd()")
  btnAdd = UI.getChildControl(Panel_Window_Dance, "BtnPlay")
  btnAdd:addInputEvent("Mouse_LUp", "Ev_danceInfo_DancePlay()")
  local buttonClose = UI.getChildControl(Panel_Window_Dance, "Button_Win_Close")
  buttonClose:addInputEvent("Mouse_LUp", "danceInfo_HandleClicked_Close()")
end
function Ev_danceInfo_DanceAdd()
  local comboBoxUI = UI.getChildControl(Panel_Window_Dance, "Combobox_Sort")
  local nSelIdx = comboBoxUI:GetSelectIndex()
  local editBox = UI.getChildControl(Panel_Window_Dance, "EditSearchText")
  local str = tonumber(editBox:GetText())
  if nSelIdx ~= -1 and str ~= nil then
    ToClient_Dance_AddUnit(tempDanceNameInfo[nSelIdx + 1], str)
    danceInfo_UpdateList()
    comboBoxUI:SetText("-")
    editBox:SetEditText("")
  end
end
function Ev_danceInfo_DancePlay()
  ToClient_Dance_Play()
end
function Ev_danceInfo_DanceDelete(i)
  ToClient_Dance_DeleteUnit(slideIndex + i)
  danceInfo_UpdateList()
end
function danceInfo_List_Initialize()
  UIScroll.InputEvent(_slide, "danceInfo_List_Scroll")
  local _frameBG = UI.getChildControl(Panel_Window_Dance, "Static_ListFrame_BG")
  _frameBG:addInputEvent("Mouse_UpScroll", "danceInfo_List_Scroll( true )")
  _frameBG:addInputEvent("Mouse_DownScroll", "danceInfo_List_Scroll( false )")
  for i = 0, nSelectDanceList_VisibleMaxCount - 1 do
    local tmpUi = UI.getChildControl(Panel_Window_Dance, "Button_Delete_" .. tostring(i))
    tmpUi:addInputEvent("Mouse_LUp", "Ev_danceInfo_DanceDelete(" .. i .. ")")
  end
  danceInfo_UpdateList()
end
function danceInfo_List_Scroll(isUp)
  slideIndex = UIScroll.ScrollEvent(_slide, isUp, nSelectDanceList_VisibleMaxCount, ToClient_Dance_GetSelectUnitSize(), slideIndex, 1)
  danceInfo_UpdateList()
end
function danceInfo_UpdateList()
  local nDanceSize = ToClient_Dance_GetSelectUnitSize()
  local nVisibleRendereCount = nDanceSize
  if nDanceSize > nSelectDanceList_VisibleMaxCount then
    nVisibleRendereCount = nSelectDanceList_VisibleMaxCount
  end
  if nVisibleRendereCount < nSelectDanceList_VisibleMaxCount then
    _slide:SetShow(false)
  else
    _slide:SetShow(true)
  end
  for i = 0, nVisibleRendereCount - 1 do
    danceInfo_SetRendererVisible(i, true)
    danceInfo_SetInfo(i, ToClient_Dance_GetSelectUnitName(slideIndex + i), ToClient_Dance_GetSelectUnitSpeed(slideIndex + i))
  end
  for i = nVisibleRendereCount, nSelectDanceList_VisibleMaxCount - 1 do
    danceInfo_SetRendererVisible(i, false)
  end
end
function danceInfo_SetRendererVisible(nIndex, bShow)
  local tmpUi
  tmpUi = UI.getChildControl(Panel_Window_Dance, "Static_ListRenderer_BG_" .. tostring(nIndex))
  tmpUi:SetShow(bShow)
  tmpUi = UI.getChildControl(Panel_Window_Dance, "Static_ListRenderer_YellowBG_" .. tostring(nIndex))
  tmpUi:SetShow(bShow)
  tmpUi = UI.getChildControl(Panel_Window_Dance, "Static_Name_Label_" .. tostring(nIndex))
  tmpUi:SetShow(bShow)
  tmpUi = UI.getChildControl(Panel_Window_Dance, "Static_Speed_Label_" .. tostring(nIndex))
  tmpUi:SetShow(bShow)
  tmpUi = UI.getChildControl(Panel_Window_Dance, "Button_Delete_" .. tostring(nIndex))
  tmpUi:SetShow(bShow)
end
function danceInfo_SetInfo(nIndex, strName, strSpeed)
  local tmpUi
  tmpUi = UI.getChildControl(Panel_Window_Dance, "Static_Name_Label_" .. tostring(nIndex))
  tmpUi:SetText("Name      " .. strName)
  tmpUi = UI.getChildControl(Panel_Window_Dance, "Static_Speed_Label_" .. tostring(nIndex))
  tmpUi:SetText("Speed     " .. strSpeed)
end
function danceInfo_Combo_show()
  local comboBoxUIListSize = 4
  local comboBoxUI = UI.getChildControl(Panel_Window_Dance, "Combobox_Sort")
  comboBoxUI:DeleteAllItem(0)
  local tbAllDance = tempDanceNameInfo
  local nSize = table.getn(tbAllDance)
  for i = 1, nSize do
    local tbUnit = tbAllDance[i]
    if tbUnit == nil then
      _PA_LOG("\234\183\156\235\179\180", "   danceInfo_Initialize.. nil " .. tostring(i))
    else
      comboBoxUI:AddItem(tbUnit)
    end
  end
  comboBoxUI:GetListControl():SetPosX(0)
  comboBoxUI:GetListControl():SetSize(comboBoxUI:GetListControl():GetSizeX(), comboBoxUIListSize * 20)
  comboBoxUI:ToggleListbox()
end
function Ev_danceInfo_Combo_Select()
  local comboBoxUI = UI.getChildControl(Panel_Window_Dance, "Combobox_Sort")
  local selectIndex = comboBoxUI:GetSelectIndex()
  comboBoxUI:SetText(tempDanceNameInfo[selectIndex + 1])
  comboBoxUI:ToggleListbox()
end
function danceInfo_HandleClicked_Close()
  if Panel_Window_Dance:IsShow() then
    Panel_Window_Dance:SetShow(false)
  end
end
function danceInfo_OpenWindow()
  danceInfo_UpdateList()
  Panel_Window_Dance:SetShow(true)
end
function danceInfo_ShowAni()
end
function danceInfo_HideAni()
end
danceInfo_Initialize()
