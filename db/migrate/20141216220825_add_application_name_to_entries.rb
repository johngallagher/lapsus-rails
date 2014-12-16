class AddApplicationNameToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :application_name, :string
  end
end
