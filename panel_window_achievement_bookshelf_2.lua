function HandleEventLUp_Achievement_BookShelf_JournalSelect(journalIndex)
  PaGlobal_Achievement_BookShelf:journalSelect(journalIndex)
end
function HandleEventOn_Achievement_BookShelf_FamilyStat_Toggle(bool)
  if nil == bool then
    return
  end
  PaGlobal_Achievement_BookShelf:familyStatToggle(bool)
end
function HandleEventLUp_Achievement_BookShelf_Close()
  PaGlobal_Achievement_BookShelf:close()
end
function HandleEventLUp_Achievement_BookShelf_ChapterSelect(chapterIndex)
  PaGlobal_Achievement_BookShelf:chapterSelect(chapterIndex)
end
function FromClient_Achievement_BookShelf_UpdateQuestList()
  PaGlobal_Achievement_BookShelf:update()
end
registerEvent("FromClient_UpdateQuestList", "FromClient_Achievement_BookShelf_UpdateQuestList")
