class AddProgressConversionAndProgressConversionPerRankToSprintStats < ActiveRecord::Migration[5.2]
  def change
    add_column :sprint_stats, :progress_conversion_per_rank, :jsonb
    add_column :sprint_stats, :progress_conversion, :integer
  end
end
