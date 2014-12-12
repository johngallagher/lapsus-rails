class AddPathToContainers < ActiveRecord::Migration
  def change
    add_column :containers, :path, :string
  end
end
