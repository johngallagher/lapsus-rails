class EntryGrouper
  def group
    Group.create(entries: Entry.all, url: Entry.first.url)
  end  
end