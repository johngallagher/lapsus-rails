class AddGroupRefToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :group_id, :integer
  end
end
