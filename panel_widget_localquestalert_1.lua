function PaGlobal_LocalQuestAlert:initialize()
  if true == PaGlobal_LocalQuestAlert._initialize then
    return
  end
  Panel_Widget_LocalQuestAlert:SetShow(false)
  PaGlobal_LocalQuestAlert._ui.txt_title = UI.getChildControl(PaGlobal_LocalQuestAlert._ui.stc_bg, "Static_Title")
  PaGlobal_LocalQuestAlert._ui.txt_desc = UI.getChildControl(PaGlobal_LocalQuestAlert._ui.stc_bg, "Static_Desc")
  PaGlobal_LocalQuestAlert._ui.txt_title:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_LocalQuestAlert._ui.txt_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local LOCATION = PaGlobal_LocalQuestAlert._LOCAL
  PaGlobal_LocalQuestAlert._info[LOCATION.CALPHEON] = {
    location = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_2"),
    texture = "CalpheonClear.dds",
    title = "",
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALQUESTALERT_CALPHEON")
  }
  PaGlobal_LocalQuestAlert._info[LOCATION.BALENOS] = {
    location = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_0"),
    texture = "BalenosClear.dds",
    title = "",
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALQUESTALERT_BALENOS")
  }
  PaGlobal_LocalQuestAlert._info[LOCATION.VALENCIA] = {
    location = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_8"),
    texture = "ValenciaClear.dds",
    title = "",
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALQUESTALERT_VALENCIA")
  }
  PaGlobal_LocalQuestAlert._info[LOCATION.SERENDIA] = {
    location = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_2"),
    texture = "SerendiaClear.dds",
    title = "",
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALQUESTALERT_SERENDIA")
  }
  PaGlobal_LocalQuestAlert._info[LOCATION.MEDIA] = {
    location = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_3"),
    texture = "MediaClear.dds",
    title = "",
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALQUESTALERT_MEDIA")
  }
  PaGlobal_LocalQuestAlert._info[LOCATION.DRIGAN] = {
    location = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_7"),
    texture = "DrieghanClear.dds",
    title = "",
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALQUESTALERT_DRIGAN")
  }
  PaGlobal_LocalQuestAlert._info[LOCATION.KAMASYLVIA] = {
    location = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_9"),
    texture = "KamasylviaClear.dds",
    title = "",
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALQUESTALERT_KAMASYLVIA")
  }
  PaGlobal_LocalQuestAlert._questInfo = {
    {
      21002,
      20,
      LOCATION.BALENOS
    },
    {
      655,
      6,
      LOCATION.BALENOS
    },
    {
      21012,
      3,
      LOCATION.SERENDIA
    },
    {
      21205,
      11,
      LOCATION.SERENDIA
    },
    {
      21303,
      8,
      LOCATION.SERENDIA
    },
    {
      665,
      5,
      LOCATION.SERENDIA
    },
    {
      21108,
      1,
      LOCATION.CALPHEON
    },
    {
      678,
      6,
      LOCATION.CALPHEON
    },
    {
      21411,
      14,
      LOCATION.MEDIA
    },
    {
      5529,
      21,
      LOCATION.VALENCIA
    },
    {
      6002,
      28,
      LOCATION.KAMASYLVIA
    },
    {
      7104,
      13,
      LOCATION.DRIGAN
    }
  }
  PaGlobal_LocalQuestAlert:registEventHandler()
  PaGlobal_LocalQuestAlert:validate()
  PaGlobal_LocalQuestAlert._initialize = true
end
function PaGlobal_LocalQuestAlert:registEventHandler()
  if nil == Panel_Widget_LocalQuestAlert then
    return
  end
  registerEvent("EventQuestUpdateNotify", "FromClient_LocalQuestAlert_QuestClearAlert")
end
function PaGlobal_LocalQuestAlert:prepareOpen(isForced)
  if nil == Panel_Widget_LocalQuestAlert then
    return
  end
  if (-1 ~= PaGlobal_LocalQuestAlert._completeInfoKey or true == isForced) and false == Panel_Widget_LocalQuestAlert:GetShow() then
    local currentInfo = PaGlobal_LocalQuestAlert._info[PaGlobal_LocalQuestAlert._completeInfoKey]
    if true == isForced then
      currentInfo = PaGlobal_LocalQuestAlert._info[1]
    end
    PaGlobal_LocalQuestAlert._ui.stc_bg:ChangeTextureInfoName("new_ui_common_forlua/widget/nakmessage/" .. currentInfo.texture)
    PaGlobal_LocalQuestAlert._ui.txt_title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOCALQUESTALERT_TITLE", "region", currentInfo.location))
    PaGlobal_LocalQuestAlert._ui.txt_desc:SetText(currentInfo.desc)
    audioPostEvent_SystemUi(4, 13)
    PaGlobal_LocalQuestAlert._ui.stc_bg:AddEffect("fUI_Light", false, 0, 0)
    PaGlobal_LocalQuestAlert._ui.stc_bg:AddEffect("UI_QustComplete01", false, 0, 0)
    PaGlobal_LocalQuestAlert._ui.stc_bg:AddEffect("UI_QustComplete02", false, 0, 0)
    PaGlobal_LocalQuestAlert._ui.stc_bg:AddEffect("fUI_QuestComplete", false, 0, 0)
    PaGlobal_LocalQuestAlert:open()
  end
end
function PaGlobal_LocalQuestAlert:open()
  if nil == Panel_Widget_LocalQuestAlert then
    return
  end
  if false == Panel_Widget_LocalQuestAlert:GetShow() then
    PaGlobal_LocalQuestAlert._completeInfoKey = -1
    PaGloabl_LocalQuestAlert_ShowAni()
    PaGloabl_LocalQuestAlert_HideAni()
  end
end
function PaGlobal_LocalQuestAlert:validate()
  if nil == Panel_Widget_LocalQuestAlert then
    return
  end
  PaGlobal_LocalQuestAlert._ui.stc_bg:isValidate()
  PaGlobal_LocalQuestAlert._ui.txt_title:isValidate()
  PaGlobal_LocalQuestAlert._ui.txt_desc:isValidate()
end
