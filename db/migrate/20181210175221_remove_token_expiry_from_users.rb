class RemoveTokenExpiryFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :token_expiry
  end
end
