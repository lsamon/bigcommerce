# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_08_123154) do

  create_table "customers", force: :cascade do |t|
    t.integer "bc_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "date_created"
    t.datetime "date_modified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "product_id"
    t.integer "order_id"
    t.integer "quantity"
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "bc_id"
    t.integer "customer_id"
    t.datetime "date_created"
    t.datetime "date_modified"
    t.datetime "date_shipped"
    t.string "status"
    t.string "products_url"
    t.float "subtotal_ex_tax"
    t.float "subtotal_inc_tax"
    t.float "subtotal_tax"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "bc_id"
    t.string "name"
    t.string "sku"
    t.float "price"
    t.text "description"
    t.datetime "date_created"
    t.datetime "date_modified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
