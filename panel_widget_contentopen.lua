local _panel = Panel_Widget_ContentOpen
local contentOpen = {
  _ui = {
    topLineLeft = UI.getChildControl(_panel, "Static_TopLineLeft"),
    topLineRight = UI.getChildControl(_panel, "Static_TopLineRight"),
    bottomLineLeft = UI.getChildControl(_panel, "Static_BottomLineLeft"),
    bottomLineRight = UI.getChildControl(_panel, "Static_BottomLineRight"),
    centerDeco = UI.getChildControl(_panel, "Static_CenterBg"),
    imageBg = UI.getChildControl(_panel, "Static_ImageBg"),
    image = nil,
    title = nil,
    desc = nil
  },
  _image = {},
  _title = {},
  _desc = {},
  _emptyList = {},
  _spreadSpeed = 20,
  _openSpeed = 10,
  _rectPosY1 = nil,
  _rectPosY2 = nil,
  _aniTime = 0,
  _isAnimate = false
}
contentOpen._image = {
  [__eGrowStep_blackSpirit] = "renewal/ETC/Remaster_ContOpenIMG_AngerBlackspirit.dds",
  [__eGrowStep_relationNPC] = "renewal/ETC/Remaster_ContOpenIMG_Intensity.dds",
  [__eGrowStep_questWindow] = "",
  [__eGrowStep_skillWindow] = "renewal/ETC/Remaster_ContOpenIMG_Skill.dds",
  [__eGrowStep_worldmap1] = "renewal/ETC/Remaster_ContOpenIMG_WMap.dds",
  [__eGrowStep_worldmap2] = "",
  [__eGrowStep_warehouse] = "renewal/ETC/Remaster_ContOpenIMG_Warehouse.dds",
  [__eGrowStep_delivery] = "renewal/ETC/Remaster_ContOpenIMG_Transport.dds",
  [__eGrowStep_explorePoint] = "renewal/ETC/Remaster_ContOpenIMG_Contribution.dds",
  [__eGrowStep_stable] = "renewal/ETC/Remaster_ContOpenIMG_Horsestable.dds",
  [__eGrowStep_enchantSocket] = "renewal/ETC/Remaster_ContOpenIMG_ManaSpread.dds",
  [__eGrowStep_enchant] = "renewal/ETC/Remaster_ContOpenIMG_Latent.dds",
  [__eGrowStep_trade] = "renewal/ETC/Remaster_ContOpenIMG_NodeAndTrade.dds",
  [__eGrowStep_node] = "",
  [__eGrowStep_buyHouse] = "",
  [__eGrowStep_worker] = "",
  [__eGrowStep_plantWorking] = "",
  [__eGrowStep_awakenSkill] = "renewal/ETC/Remaster_ContOpenIMG_Specialskill.dds",
  [__eGrowStep_guild] = "renewal/ETC/Remaster_ContOpenIMG_Guild.dds",
  [__eGrowStep_maxAdrenalin] = "",
  [__eGrowStep_proposeNPC] = "renewal/ETC/Remaster_ContOpenIMG_Gift.dds",
  [__eGrowStep_dualCharacter] = "",
  [__eGrowStep_dropItem] = "renewal/ETC/Remaster_ContOpenIMG_WMapdrop.dds",
  [__eGrowStep_localWar] = "",
  [__eGrowStep_freeFight] = "",
  [__eGrowStep_teamDuel] = "",
  [__eGrowStep_arsha] = "",
  [__eGrowStep_militia] = "",
  [__eGrowStep_savageDefence] = "",
  [__eGrowStep_randomShop] = "",
  [__eGrowStep_worldmap3] = "",
  [__eGrowStep_manufacture] = "",
  [__eGrowStep_blackSpiritAdventure] = "",
  [__eGrowStep_bossAlert] = "",
  [__eGrowStep_guildWarInfo] = "",
  [__eGrowStep_improveItem] = "",
  [__eGrowStep_findNpc] = "renewal/ETC/Remaster_ContOpenIMG_FindNPC.dds",
  [__eGrowStep_oldBook] = "renewal/ETC/Remaster_ContOpenIMG_AdventureJournal.dds",
  [__eGrowStep_pcCameraLimit] = ""
}
contentOpen._title = {
  [__eGrowStep_blackSpirit] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_blackSpirit),
  [__eGrowStep_relationNPC] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_relationNPC),
  [__eGrowStep_questWindow] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_questWindow),
  [__eGrowStep_skillWindow] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_skillWindow),
  [__eGrowStep_worldmap1] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_worldmap1),
  [__eGrowStep_worldmap2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_worldmap2),
  [__eGrowStep_warehouse] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_warehouse),
  [__eGrowStep_delivery] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_delivery),
  [__eGrowStep_explorePoint] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_explorePoint),
  [__eGrowStep_stable] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_stable),
  [__eGrowStep_enchantSocket] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_enchantSocket),
  [__eGrowStep_enchant] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_enchant),
  [__eGrowStep_trade] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_plantWorking),
  [__eGrowStep_node] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_node),
  [__eGrowStep_buyHouse] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_buyHouse),
  [__eGrowStep_worker] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_worker),
  [__eGrowStep_plantWorking] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_trade),
  [__eGrowStep_awakenSkill] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_awakenSkill),
  [__eGrowStep_guild] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_guild),
  [__eGrowStep_maxAdrenalin] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_maxAdrenalin),
  [__eGrowStep_proposeNPC] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_proposeNPC),
  [__eGrowStep_dualCharacter] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_dualCharacter),
  [__eGrowStep_dropItem] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_dropItem),
  [__eGrowStep_localWar] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_localWar),
  [__eGrowStep_freeFight] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_freeFight),
  [__eGrowStep_teamDuel] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_teamDuel),
  [__eGrowStep_arsha] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_arsha),
  [__eGrowStep_militia] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_militia),
  [__eGrowStep_savageDefence] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_savageDefence),
  [__eGrowStep_randomShop] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_randomShop),
  [__eGrowStep_worldmap3] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_worldmap3),
  [__eGrowStep_manufacture] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_manufacture),
  [__eGrowStep_blackSpiritAdventure] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_blackSpiritAdventure),
  [__eGrowStep_bossAlert] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_bossAlert),
  [__eGrowStep_guildWarInfo] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_guildWarInfo),
  [__eGrowStep_improveItem] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_improveItem),
  [__eGrowStep_findNpc] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_findNpc),
  [__eGrowStep_oldBook] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_TITLE_" .. __eGrowStep_oldBook),
  [__eGrowStep_pcCameraLimit] = ""
}
contentOpen._desc = {
  [__eGrowStep_blackSpirit] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_blackSpirit),
  [__eGrowStep_relationNPC] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_relationNPC),
  [__eGrowStep_questWindow] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_questWindow),
  [__eGrowStep_skillWindow] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_skillWindow),
  [__eGrowStep_worldmap1] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_worldmap1),
  [__eGrowStep_worldmap2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_worldmap2),
  [__eGrowStep_warehouse] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_warehouse),
  [__eGrowStep_delivery] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_delivery),
  [__eGrowStep_explorePoint] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_explorePoint),
  [__eGrowStep_stable] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_stable),
  [__eGrowStep_enchantSocket] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_enchantSocket),
  [__eGrowStep_enchant] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_enchant),
  [__eGrowStep_trade] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_plantWorking),
  [__eGrowStep_node] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_node),
  [__eGrowStep_buyHouse] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_buyHouse),
  [__eGrowStep_worker] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_worker),
  [__eGrowStep_plantWorking] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_trade),
  [__eGrowStep_awakenSkill] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_awakenSkill),
  [__eGrowStep_guild] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_guild),
  [__eGrowStep_maxAdrenalin] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_maxAdrenalin),
  [__eGrowStep_proposeNPC] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_proposeNPC),
  [__eGrowStep_dualCharacter] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_dualCharacter),
  [__eGrowStep_dropItem] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_dropItem),
  [__eGrowStep_localWar] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_localWar),
  [__eGrowStep_freeFight] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_freeFight),
  [__eGrowStep_teamDuel] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_teamDuel),
  [__eGrowStep_arsha] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_arsha),
  [__eGrowStep_militia] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_militia),
  [__eGrowStep_savageDefence] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_savageDefence),
  [__eGrowStep_randomShop] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_randomShop),
  [__eGrowStep_worldmap3] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_worldmap3),
  [__eGrowStep_manufacture] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_manufacture),
  [__eGrowStep_blackSpiritAdventure] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_blackSpiritAdventure),
  [__eGrowStep_bossAlert] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_bossAlert),
  [__eGrowStep_guildWarInfo] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_guildWarInfo),
  [__eGrowStep_improveItem] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_improveItem),
  [__eGrowStep_findNpc] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_findNpc),
  [__eGrowStep_oldBook] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONTENTOPEN_DESC_" .. __eGrowStep_oldBook),
  [__eGrowStep_pcCameraLimit] = ""
}
contentOpen._emptyList = {
  __eGrowStep_questWindow,
  __eGrowStep_worldmap2,
  __eGrowStep_trade,
  __eGrowStep_node,
  __eGrowStep_buyHouse,
  __eGrowStep_worker,
  __eGrowStep_maxAdrenalin,
  __eGrowStep_dualCharacter,
  __eGrowStep_localWar,
  __eGrowStep_freeFight,
  __eGrowStep_teamDuel,
  __eGrowStep_arsha,
  __eGrowStep_militia,
  __eGrowStep_savageDefence,
  __eGrowStep_randomShop,
  __eGrowStep_worldmap3,
  __eGrowStep_manufacture,
  __eGrowStep_blackSpiritAdventure,
  __eGrowStep_bossAlert,
  __eGrowStep_guildWarInfo,
  __eGrowStep_improveItem,
  __eGrowStep_pcCameraLimit
}
function contentOpen:update(contentType)
  self._rectPosY1 = self._ui.imageBg:GetSizeY() / 2
  self._rectPosY2 = self._ui.imageBg:GetSizeY() / 2
  _PA_LOG("\235\172\184\236\158\165\237\153\152", "contentType = " .. tostring(contentType))
  if nil == contentType then
    contentType = 0
    return
  end
  self._ui.topLineLeft:SetSize(105, self._ui.topLineLeft:GetSizeY())
  self._ui.topLineRight:SetSize(105, self._ui.topLineRight:GetSizeY())
  self._ui.bottomLineLeft:SetSize(105, self._ui.bottomLineLeft:GetSizeY())
  self._ui.bottomLineRight:SetSize(105, self._ui.bottomLineRight:GetSizeY())
  self._ui.topLineLeft:ComputePos()
  self._ui.topLineRight:ComputePos()
  self._ui.bottomLineLeft:ComputePos()
  self._ui.bottomLineRight:ComputePos()
  self._ui.centerDeco:SetShow(false)
  self._ui.image:ChangeTextureInfoName(self._image[contentType])
  self._ui.title:SetText(self._title[contentType])
  self._ui.desc:SetText(self._desc[contentType])
  self._ui.imageBg:SetRectClipOnArea(float2(0, self._rectPosY1), float2(self._ui.imageBg:GetSizeX(), self._rectPosY2))
  self._ui.imageBg:SetShow(false)
  self._aniTime = 0
  self._isAnimate = true
end
function contentOpen:panelInitialize()
  self._ui.image = UI.getChildControl(self._ui.imageBg, "Static_Image")
  self._ui.title = UI.getChildControl(self._ui.imageBg, "StaticText_Title")
  self._ui.desc = UI.getChildControl(self._ui.imageBg, "StaticText_Desc")
  self._ui.btn_Close = UI.getChildControl(self._ui.imageBg, "Button_Close")
  self._ui.btn_Close:SetText("<ESC> " .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_COMMON_CLOSE"))
  self._ui.btn_Close:SetSize(self._ui.btn_Close:GetTextSizeX(), self._ui.btn_Close:GetSizeY())
  self._ui.title:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
end
function contentOpen:stringInitialize()
end
function contentOpen:registerEvent()
  self._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_contentOpen_Close()")
  registerEvent("onScreenResize", "contentOpen_reposition")
end
function contentOpen:open(contentType)
  if "" == contentOpen._image[contentType] or "" == contentOpen._title[contentType] or "" == contentOpen._desc[contentType] then
    _PA_LOG("\235\172\184\236\158\165\237\153\152", tostring(contentType) .. "\235\178\136 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164. \237\149\180\235\139\185 \236\157\180\235\175\184\236\167\128\236\153\128 string\236\157\132 \237\153\149\236\157\184\237\149\180\236\163\188\236\132\184\236\154\148. string : " .. contentOpen._title[contentType] .. " / desc : " .. contentOpen._desc[contentType])
    return
  end
  _panel:SetShow(true)
  self:update(contentType)
  _panel:RegisterUpdateFunc("PaGlobalFunc_ContentOpen_Ani")
end
function contentOpen:close()
  if self._isAnimate then
    return
  end
  _panel:SetShow(false)
end
function PaGlobalFunc_ContentOpen_Ani(deltaTime)
  local self = contentOpen
  if 0 < self._ui.topLineLeft:GetPosX() then
    self._ui.topLineLeft:SetSize(self._ui.topLineLeft:GetSizeX() + self._spreadSpeed, self._ui.topLineLeft:GetSizeY())
    self._ui.topLineRight:SetSize(self._ui.topLineRight:GetSizeX() + self._spreadSpeed, self._ui.topLineRight:GetSizeY())
    self._ui.bottomLineLeft:SetSize(self._ui.bottomLineLeft:GetSizeX() + self._spreadSpeed, self._ui.bottomLineLeft:GetSizeY())
    self._ui.bottomLineRight:SetSize(self._ui.bottomLineRight:GetSizeX() + self._spreadSpeed, self._ui.bottomLineRight:GetSizeY())
    self._ui.topLineLeft:ComputePos()
    self._ui.topLineRight:ComputePos()
    self._ui.bottomLineLeft:ComputePos()
    self._ui.bottomLineRight:ComputePos()
  else
    self._aniTime = self._aniTime + deltaTime
    if self._aniTime > 0.5 then
      if false == self._ui.imageBg:GetShow() then
        self._ui.imageBg:SetShow(true)
      end
      if 0 < self._ui.topLineLeft:GetPosY() then
        self._ui.topLineLeft:SetPosY(self._ui.topLineLeft:GetPosY() - self._openSpeed)
        self._ui.topLineRight:SetPosY(self._ui.topLineRight:GetPosY() - self._openSpeed)
        self._ui.bottomLineLeft:SetPosY(self._ui.bottomLineLeft:GetPosY() + self._openSpeed)
        self._ui.bottomLineRight:SetPosY(self._ui.bottomLineRight:GetPosY() + self._openSpeed)
        self._rectPosY1 = self._rectPosY1 - self._openSpeed
        self._rectPosY2 = self._rectPosY2 + self._openSpeed
        self._ui.imageBg:SetRectClipOnArea(float2(0, self._rectPosY1), float2(self._ui.imageBg:GetSizeX(), self._rectPosY2))
      else
        self._ui.centerDeco:SetShow(true)
        _panel:ClearUpdateLuaFunc()
        self._aniTime = 0
        self._isAnimate = false
      end
    end
  end
end
function PaGlobal_contentOpen_Open()
  contentOpen:open()
end
function PaGlobal_contentOpen_Close()
  contentOpen:close()
end
function PaGlobal_contentOpen_ForceClose()
  _panel:SetShow(false)
end
function contentOpen_initialize()
  local self = contentOpen
  self:panelInitialize()
  self:stringInitialize()
  self:registerEvent()
  registerEvent("FromClient_notifyUpdateGrowStep", "FromClient_ContentOpen")
end
function FromClient_ContentOpen(contentType, isLock)
  contentOpen:open(contentType)
end
function PaGlobal_contentOpen_TestOpen(type)
  contentOpen:open(type)
end
registerEvent("FromClient_luaLoadComplete", "contentOpen_initialize")
