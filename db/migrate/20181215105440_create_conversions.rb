class CreateConversions < ActiveRecord::Migration[5.2]
  def change
    create_table :conversions do |t|
      t.references :sprint, foreign_key: true
      t.integer :xs, null: false, default: 1
      t.integer :s, null: false, default: 2
      t.integer :m, null: false, default: 4
      t.integer :l, null: false, default: 8
      t.integer :xl, null: false, default: 16
      t.integer :xxl, null: false, default: 32

      t.timestamps
    end
  end
end
