class CreateSprintStats < ActiveRecord::Migration[5.2]
  def change
    create_table :sprint_stats do |t|

      t.timestamps
    end
  end
end
