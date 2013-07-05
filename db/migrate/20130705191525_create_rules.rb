class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :url
      t.integer :project_id

      t.timestamps
    end
  end
end
