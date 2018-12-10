class AddTrelloAvatarUrlToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :trello_avatar_url, :string
  end
end
