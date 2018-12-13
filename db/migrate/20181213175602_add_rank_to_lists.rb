class AddRankToLists < ActiveRecord::Migration[5.2]
  def change
    add_column :lists, :rank, :integer
  end
end
