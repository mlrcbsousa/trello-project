class AddSprintReferenceToSprintStats < ActiveRecord::Migration[5.2]
  def change
    add_reference :sprint_stats, :sprint, foreign_key: true
  end
end
