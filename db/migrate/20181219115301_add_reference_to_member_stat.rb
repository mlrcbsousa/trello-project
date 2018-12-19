class AddReferenceToMemberStat < ActiveRecord::Migration[5.2]
  def change
    add_reference :member_stats, :member, foreign_key: true
  end
end
