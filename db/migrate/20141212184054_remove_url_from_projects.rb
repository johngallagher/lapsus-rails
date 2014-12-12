class RemoveUrlFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :url, :string
  end
end
