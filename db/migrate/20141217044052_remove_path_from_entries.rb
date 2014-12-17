class RemovePathFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :path, :string
  end
end
