class AddPresetToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :preset, :boolean, default: false
  end
end
