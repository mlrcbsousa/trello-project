class RemoveFacebookUrlFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :facebook_picture_url
  end
end
