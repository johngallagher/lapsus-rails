class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :project_id

      t.timestamps
    end
  end
end
