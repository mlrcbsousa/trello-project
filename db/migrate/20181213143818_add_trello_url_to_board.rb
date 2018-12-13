class AddTrelloUrlToBoard < ActiveRecord::Migration[5.2]
  def change
    add_column :boards, :trello_url, :string
  end
end
