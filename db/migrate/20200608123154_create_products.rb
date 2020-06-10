class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.integer :bc_id
      t.string :name
      t.string :sku
      t.float :price
      t.text :description
      t.datetime :date_created
      t.datetime :date_modified

      t.timestamps
    end
  end
end
