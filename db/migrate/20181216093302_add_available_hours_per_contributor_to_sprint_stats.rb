class AddAvailableHoursPerContributorToSprintStats < ActiveRecord::Migration[5.2]
  def change
    add_column :sprint_stats, :available_hours_per_contributor, :jsonb
  end
end
