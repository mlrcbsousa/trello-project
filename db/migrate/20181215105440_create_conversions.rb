class CreateConversions < ActiveRecord::Migration[5.2]
  def change
    create_table :conversions do |t|
      t.references :sprint, foreign_key: true
      t.integer :xs
      t.integer :s
      t.integer :m
      t.integer :l
      t.integer :xl
      t.integer :xxl

      t.timestamps
    end
  end
end
