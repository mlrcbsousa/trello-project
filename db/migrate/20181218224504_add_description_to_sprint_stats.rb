class AddDescriptionToSprintStats < ActiveRecord::Migration[5.2]
  def change
    add_column :sprint_stats, :description, :string
  end
end
