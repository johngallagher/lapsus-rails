class AddTrainedToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :trained, :boolean
  end
end
