class CreateMemberStats < ActiveRecord::Migration[5.2]
  def change
    create_table :member_stats do |t|
      t.references :member, foreign_key: true

      t.timestamps
    end
  end
end
