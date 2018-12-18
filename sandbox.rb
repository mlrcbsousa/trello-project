class AddColumsToSprintStats < ActiveRecord::Migration[5.2]
  def change
    add_column :datetime_at_post, :datetime
    add_column :sprint_stats, :available_man_hours, :integer
    add_column :sprint_stats, :total_contributors, :integer
    add_column :sprint_stats, :total_days, :integer
    add_column :sprint_stats, :total_days_from_start, :integer
    add_column :sprint_stats, :total_days_to_end, :integer
    add_column :sprint_stats, :total_ranks, :integer
    add_column :sprint_stats, :total_cards, :integer
    add_column :sprint_stats, :cards_per_size, :jsonb
    add_column :sprint_stats, :total_weighted_cards, :integer
    add_column :sprint_stats, :weighted_cards_per_size, :jsonb
    add_column :sprint_stats, :weighted_cards_per_rank, :jsonb
    add_column :sprint_stats, :total_story_points, :integer
    add_column :sprint_stats, :weighted_cards_per_contributor, :jsonb
    add_column :sprint_stats, :story_points_per_contributor, :jsonb
    add_column :sprint_stats, :story_points_per_size, :jsonb
    add_column :sprint_stats, :conversion_per_size, :jsonb
    add_column :sprint_stats, :total_conversion, :integer
    add_column :sprint_stats, :conversion_per_size_per_contributor, :jsonb
    add_column :sprint_stats, :conversion_per_size_per_contributor_ck, :jsonb
    add_column :sprint_stats, :weighted_cards_per_size_per_contributor, :jsonb
    add_column :sprint_stats, :weighted_cards_per_size_per_contributor_ck, :jsonb
    add_column :sprint_stats, :conversion_per_contributor, :jsonb
    add_column :sprint_stats, :available_hours_per_contributor, :jsonb
    add_column :sprint_stats, :merged_conversion_per_contributor, :jsonb
    add_column :sprint_stats, :weighted_cards_per_size_per_rank, :jsonb
    add_column :sprint_stats, :weighted_cards_per_size_per_rank_ck, :jsonb
    add_column :sprint_stats, :conversion_per_size_per_rank, :jsonb
    add_column :sprint_stats, :conversion_per_size_per_rank_ck, :jsonb
    add_column :sprint_stats, :conversion_per_rank, :jsonb
    add_column :sprint_stats, :progress_conversion_per_rank, :jsonb
    add_column :sprint_stats, :merged_conversion_per_rank, :jsonb
    add_column :sprint_stats, :progress_conversion, :integer
    add_column :sprint_stats, :progress, :float
    add_column :sprint_stats, :story_points_progress, :integer
  end
end
