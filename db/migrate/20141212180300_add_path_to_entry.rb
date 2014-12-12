class AddPathToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :path, :string
  end
end
