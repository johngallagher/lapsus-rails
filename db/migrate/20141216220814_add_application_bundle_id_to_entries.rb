class AddApplicationBundleIdToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :application_bundle_id, :string
  end
end
