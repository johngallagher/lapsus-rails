class RemoveUrlFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :url, :string
  end
end
