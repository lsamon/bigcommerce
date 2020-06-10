namespace :bc do
  desc 'Add customers, products and orders using Bigcommerce API'
  task load_data: :environment do
    Customer.destroy_all
    Product.destroy_all

    puts 'Adding customers...'
    BigcommerceService::LoadCustomers.call
    puts 'Adding products...'
    BigcommerceService::LoadProducts.call
    puts 'Adding orders...'
    BigcommerceService::LoadOrders.call
  end
end
