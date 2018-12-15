class AddStatsToSprintStats < ActiveRecord::Migration[5.2]
  def change
    add_column :sprint_stats, :timestamp, :type
    add_column :sprint_stats, :total_story_points, :jsonb
    add_column :sprint_stats, :total_days_from_start, :jsonb
    add_column :sprint_stats, :total_days_to_end, :jsonb
    add_column :sprint_stats, :total_days, :jsonb
    add_column :sprint_stats, :contributors, :jsonb
    add_column :sprint_stats, :lists_count, :jsonb
    add_column :sprint_stats, :total_cards, :jsonb
    add_column :sprint_stats, :weighted_cards, :jsonb
    add_column :sprint_stats, :weighted_cards_count, :jsonb
    add_column :sprint_stats, :cards_per_size, :jsonb
    add_column :sprint_stats, :weighted_cards_per_size, :jsonb
    add_column :sprint_stats, :cards_per_rank, :jsonb
    add_column :sprint_stats, :total_story_points, :jsonb
    add_column :sprint_stats, :cards_per_contributor, :jsonb
    add_column :sprint_stats, :story_points_per_contributor, :jsonb
    add_column :sprint_stats, :story_points_per_size, :jsonb
    add_column :sprint_stats, :progress, :jsonb
    add_column :sprint_stats, :story_points_progress, :jsonb
  end
end
