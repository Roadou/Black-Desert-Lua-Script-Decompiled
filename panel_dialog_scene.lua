Panel_Dialog_Scene:SetShow(false)
Panel_Dialog_Scene:setFlushAble(false)
global_SelectCommerceType = -1
local VCK = CppEnums.VirtualKeyCode
local scene_WorldPosition
local pickingIndex = -1
enCommerceType = {
  enCommerceType_Luxury_Miscellaneous = 1,
  enCommerceType_Luxury = 2,
  enCommerceType_Grocery = 3,
  enCommerceType_Medicine = 4,
  enCommerceType_MilitarySupplies = 5,
  enCommerceType_ObjectSaint = 6,
  enCommerceType_Cloth = 7,
  enCommerceType_SeaFood = 8,
  enCommerceType_RawMaterial = 9,
  enCommerceType_Max = 10
}
local beginIndex = 5
local endIndex = 14
commerceCategory = {
  [beginIndex] = {
    name = PAGetString(Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_GROCERY"),
    Type = enCommerceType.enCommerceType_Grocery
  },
  [6] = {
    name = PAGetString(Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_MEDICINE"),
    Type = enCommerceType.enCommerceType_Medicine
  },
  [7] = {
    name = PAGetString(Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_LUXURY"),
    Type = enCommerceType.enCommerceType_Luxury
  },
  [8] = {
    name = PAGetString(Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_MISCELLANEOUS"),
    Type = enCommerceType.enCommerceType_Luxury_Miscellaneous
  },
  [9] = {
    name = PAGetString(Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_SEED"),
    Type = enCommerceType.enCommerceType_Seed
  },
  [10] = {
    name = PAGetString(Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_CLOTH"),
    Type = enCommerceType.enCommerceType_Cloth
  },
  [11] = {
    name = PAGetString(Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_SAINTOBJECT"),
    Type = enCommerceType.enCommerceType_ObjectSaint
  },
  [12] = {
    name = PAGetString(Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_SAINTOBJECT"),
    Type = enCommerceType.enCommerceType_MilitarySupplies
  },
  [13] = {
    name = PAGetString(Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_SAINTOBJECT"),
    Type = enCommerceType.enCommerceType_RawMaterial
  },
  [endIndex] = {
    name = PAGetString(Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_SEEFOOD"),
    Type = enCommerceType.enCommerceType_SeaFood
  }
}
enStableType = {
  enStableType_Dye = 1,
  enStableType_ArmorStands = 2,
  enStableType_Hybridization = 3,
  enStableType_Max = 4
}
local stableCategory = {
  [1] = {
    name = PAGetString(Defines.StringSheet_GAME, "DIALOGSCENE_STABLECATEGORY_DYE"),
    Type = enStableType.enStableType_Dye
  },
  [2] = {
    name = PAGetString(Defines.StringSheet_GAME, "DIALOGSCENE_STABLECATEGORY_ARMOR"),
    Type = enStableType.enStableType_ArmorStands
  },
  [3] = {
    name = PAGetString(Defines.StringSheet_GAME, "DIALOGSCENE_STABLECATEGORY_HYBRIDIZATION"),
    Type = enStableType.enStableType_Hybridization
  }
}
local _prevPickingIndex = 0
function updateSceneObjectPicking(fDeltaTime)
  local subIndex = getCurrentSubIndex()
  if -1 ~= subIndex then
    pickingIndex = getObjectPickingIndex()
    dialog_Scene_Click_Func[subIndex]()
  end
end
function show_DialogPanel()
  Panel_Dialog_Scene:SetShow(true)
end
function hide_DialogSceneUIPanel()
  Panel_Dialog_Scene:SetShow(false)
end
Panel_Dialog_Scene:RegisterUpdateFunc("updateSceneObjectPicking")
local dialogNpcSceneInfo = {}
local dialogScene_Category_Trade = 0
local dialogScene_Category_Stable = 1
local dialogScene_Category_Search = 2
local dialogScene_Category_Wharf = 3
function dialogNpcSceneInfo.click_Trade()
  if false == global_IsTrading then
    return
  end
  if true == isKeyDown_Once(VCK.KeyCode_LBUTTON) and -1 ~= pickingIndex then
    _prevPickingIndex = pickingIndex
    if nil ~= commerceCategory[pickingIndex] then
      global_SelectCommerceType = commerceCategory[pickingIndex].Type
      global_buyListOpen(global_SelectCommerceType)
    end
    global_updateCommerceInfoByType(global_SelectCommerceType, 1)
  end
end
function dialogNpcSceneInfo.click_Stable()
  if true == isKeyDown_Once(VCK.KeyCode_LBUTTON) then
    if -1 == pickingIndex then
      return
    end
    if nil ~= getEventControl() then
      return
    end
    if enStableType.enStableType_Dye == pickingIndex then
    elseif enStableType.enStableType_ArmorStands == pickingIndex then
      if npcShop_isShopContents() then
        npcShop_requestList(9)
        StableShop_OpenPanel()
      end
    elseif enStableType.enStableType_Hybridization == pickingIndex then
      StableFunction_Button_ListMating()
    end
  end
end
function dialogNpcSceneInfo.click_Search()
end
function dialogNpcSceneInfo.click_wharf()
end
dialog_Scene_Click_Func = {
  [dialogScene_Category_Trade] = dialogNpcSceneInfo.click_Trade,
  [dialogScene_Category_Stable] = dialogNpcSceneInfo.click_Stable,
  [dialogScene_Category_Search] = dialogNpcSceneInfo.click_Search,
  [dialogScene_Category_Wharf] = dialogNpcSceneInfo.click_wharf
}
function global_TradeShopScene()
  callAIHandlerByIndex(1, _prevPickingIndex, "SceneTradeBuy")
end
function global_TradeShopReset()
  callAIHandlerByIndex(3, 0, "ResetTradeshop")
end
