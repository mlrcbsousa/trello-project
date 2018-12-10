class AddUsernameAvatarUrlSecretToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :avatar_url, :string
    add_column :users, :secret, :string
    add_column :users, :username, :string
  end
end
