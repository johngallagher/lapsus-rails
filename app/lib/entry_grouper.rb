class EntryGrouper
  def group
    if Rule.all.empty?
      Group.create(entries: Entry.all, url: Entry.first.url)
    else
      Group.create(entries: Entry.all, url: Rule.first.url)
    end
  end  
end