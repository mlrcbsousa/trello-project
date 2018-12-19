class AddDatetimeAtPostToMemberStat < ActiveRecord::Migration[5.2]
  def change
    add_column :member_stats, :datetime_at_post, :datetime
  end
end
