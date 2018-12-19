class AddColumnsToMemberStat < ActiveRecord::Migration[5.2]
  def change
    add_column :member_stats, :description, :string
    add_column :member_stats, :available_hours, :integer
    add_column :member_stats, :datetime_at_post, :jsonb
    add_column :member_stats, :weighted_cards_count, :integer
    add_column :member_stats, :weighted_cards_per_size, :jsonb
    add_column :member_stats, :weighted_cards_per_rank, :jsonb
    add_column :member_stats, :weighted_cards_per_size_per_rank, :jsonb
    add_column :member_stats, :weighted_cards_per_size_per_rank_ck, :jsonb
    add_column :member_stats, :conversion_per_size_per_rank, :jsonb
    add_column :member_stats, :conversion_per_size_per_rank_ck, :jsonb
    add_column :member_stats, :conversion_per_size, :jsonb
    add_column :member_stats, :conversion_per_rank, :jsonb
    add_column :member_stats, :total_conversion, :integer
    add_column :member_stats, :total_story_points, :integer
    add_column :member_stats, :progress, :float
    add_column :member_stats, :story_points_progress, :integer
  end
end
