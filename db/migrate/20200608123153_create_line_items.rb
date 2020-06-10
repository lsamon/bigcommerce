class CreateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items do |t|
      t.integer :product_id, index: true
      t.integer :order_id, index: true
      t.integer :quantity
    end
  end
end
