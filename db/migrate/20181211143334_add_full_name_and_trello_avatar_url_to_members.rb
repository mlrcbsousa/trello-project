class AddFullNameAndTrelloAvatarUrlToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :full_name, :string
    add_column :members, :trello_avatar_url, :string
  end
end
