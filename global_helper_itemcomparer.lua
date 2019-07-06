local itemTypePriorityMap = {
  [0] = 0,
  3,
  2,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1
}
local equipTypePriorityMap = {
  [0] = 0,
  9900,
  9800,
  9700,
  9600,
  9500,
  9400,
  9300,
  8700,
  8200,
  8100,
  8000,
  7900,
  7800,
  7700,
  7600,
  7500,
  7400,
  7300,
  7200,
  9200,
  8600,
  7100,
  7000,
  6900,
  6800,
  6700,
  6600,
  9100,
  9000,
  8900,
  8800,
  8500,
  8400,
  8300,
  9200,
  9100,
  8800
}
local itemType_Equip = CppEnums.ItemType.Equip
function Global_ItemComparer(ii, jj, getFunction, inventoryType)
  local self = inven
  local invenItemII
  if nil ~= inventoryType then
    invenItemII = getFunction(inventoryType, ii)
  else
    invenItemII = getFunction(ii)
  end
  local emptyII = nil == invenItemII
  local itemStaticWrapperII, itemTypeII, equipTypeII, minLevelII, gradeTypeII, itemKeyII
  if not emptyII then
    itemStaticWrapperII = invenItemII:getStaticStatus()
    itemTypeII = itemStaticWrapperII:getItemType()
    equipTypeII = itemStaticWrapperII:getEquipType()
    minLevelII = itemStaticWrapperII:get()._minLevel
    gradeTypeII = itemStaticWrapperII:getGradeType()
    itemKeyII = invenItemII:get():getKey():getItemKey()
  end
  local invenItemJJ
  if nil ~= inventoryType then
    invenItemJJ = getFunction(inventoryType, jj)
  else
    invenItemJJ = getFunction(jj)
  end
  local emptyJJ = nil == invenItemJJ
  local itemStaticWrapperJJ, itemTypeJJ, equipTypeJJ, minLevelJJ, gradeTypeJJ, itemKeyJJ
  if not emptyJJ then
    itemStaticWrapperJJ = invenItemJJ:getStaticStatus()
    itemTypeJJ = itemStaticWrapperJJ:getItemType()
    equipTypeJJ = itemStaticWrapperJJ:getEquipType()
    minLevelJJ = itemStaticWrapperJJ:get()._minLevel
    gradeTypeJJ = itemStaticWrapperJJ:getGradeType()
    itemKeyJJ = invenItemJJ:get():getKey():getItemKey()
  end
  if emptyII and emptyJJ then
    return 0
  elseif emptyII then
    return -1
  elseif emptyJJ then
    return 1
  end
  local itemPriorityII = itemTypePriorityMap[itemTypeII] or 0
  local itemPriorityJJ = itemTypePriorityMap[itemTypeJJ] or 0
  if itemPriorityII ~= itemPriorityJJ then
    return itemPriorityII - itemPriorityJJ
  end
  if itemType_Equip == itemTypeII and itemType_Equip == itemTypeJJ then
    local equipPriorityII = equipTypePriorityMap[equipTypeII] or 0
    local equipPriorityJJ = equipTypePriorityMap[equipTypeJJ] or 0
    if equipPriorityII ~= equipPriorityJJ then
      return equipPriorityII - equipPriorityJJ
    end
    if gradeTypeII ~= gradeTypeJJ then
      return gradeTypeII - gradeTypeJJ
    end
    if minLevelII ~= minLevelJJ then
      return minLevelII - minLevelJJ
    end
    return itemKeyII - itemKeyJJ
  else
    if gradeTypeII ~= gradeTypeJJ then
      return gradeTypeII - gradeTypeJJ
    end
    return itemKeyII - itemKeyJJ
  end
end
