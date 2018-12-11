class AddNameToSprint < ActiveRecord::Migration[5.2]
  def change
    add_column :sprints, :name, :string
  end
end
