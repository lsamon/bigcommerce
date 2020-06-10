class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :bc_id
      t.integer :customer_id, index: true
      t.datetime :date_created
      t.datetime :date_modified
      t.datetime :date_shipped
      t.string :status
      t.string :products_url
      t.float :subtotal_ex_tax
      t.float :subtotal_inc_tax
      t.float :subtotal_tax

      t.timestamps
    end
  end
end
