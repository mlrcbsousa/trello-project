class AddStatsToMembers < ActiveRecord::Migration[5.2]
  def change
    :sprint_stats, :datetime_at_post, :datetime
    :sprint_stats, :available_hours, :integer
    :member_stats, :total_cards, :integer
    :member_stats, :weighted_cards_count, :integer
    :member_stats, :weighted_cards_per_size, :jsonb
    :member_stats, :conversion_per_size, :jsonb
    :member_stats, :conversion_per_rank, :jsonb
    :member_stats, :total_story_points, :integer
    :member_stats, :progress, :float
    :member_stats, :story_points_progress, :integer
  end
end
