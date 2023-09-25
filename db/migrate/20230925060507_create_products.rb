class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.string :description
      t.integer :number
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :products, :name, unique: true
    add_index :products, :price
  end
end
