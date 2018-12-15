class AddStatsToSprintStats < ActiveRecord::Migration[5.2]
  def change
    :sprint_stats, :datetime_at_post, :datetime
    :sprint_stats, :available_man_hours, :integer
    :sprint_stats, :total_contributors, , :integer
    :sprint_stats, :total_days, :integer
    :sprint_stats, :total_days_from_start, :integer
    :sprint_stats, :total_days_to_end, :integer
    :sprint_stats, :total_ranks, :integer
    :sprint_stats, :total_cards, :integer
    :sprint_stats, :cards_per_size, :jsonb
    :sprint_stats, :total_weighted_cards, :integer
    :sprint_stats, :weighted_cards_per_size, :jsonb
    :sprint_stats, :weighted_cards_per_rank, :jsonb
    :sprint_stats, :total_story_points, :integer
    :sprint_stats, :weighted_cards_per_contributor, :jsonb
    :sprint_stats, :story_points_per_contributor, :jsonb
    :sprint_stats, :story_points_per_size, :jsonb
    :sprint_stats, :conversion_per_size, :jsonb
    :sprint_stats, :total_conversion, :integer
    :sprint_stats, :conversion_per_size_per_contributor, :jsonb
    :sprint_stats, :weighted_cards_per_size_per_contributor, :jsonb
    :sprint_stats, :conversion_per_contributor, :jsonb
    :sprint_stats, :weighted_cards_per_size_per_rank, :jsonb
    :sprint_stats, :conversion_per_size_per_rank, :jsonb
    :sprint_stats, :conversion_per_rank, :jsonb
    :sprint_stats, :progress, :float
    :sprint_stats, :story_points_progress, :integer
  end
end
