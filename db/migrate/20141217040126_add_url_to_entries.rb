class AddUrlToEntries < ActiveRecord::Migration
  def up
    add_column :entries, :url, :string
    Entry.all.each do |entry|
      if entry.attributes[:path].present?
        entry.url = "file://#{entry.attributes[:path]}" 
        entry.save!
      end
    end
  end

  def down
    remove_column :entries, :url, :string
  end
end
