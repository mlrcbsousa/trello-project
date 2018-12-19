class RemoveDatetimeAtPostFromMemberStat < ActiveRecord::Migration[5.2]
  def change
    remove_column :member_stats, :datetime_at_post
  end
end
