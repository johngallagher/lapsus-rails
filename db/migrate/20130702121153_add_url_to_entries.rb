class AddUrlToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :url, :string
  end
end
