class RemoveUrlFromContainers < ActiveRecord::Migration
  def change
    remove_column :containers, :url, :string
  end
end
