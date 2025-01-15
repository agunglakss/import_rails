class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :sku
      t.string :name
      t.integer :price

      t.timestamps
    end
  end
end
