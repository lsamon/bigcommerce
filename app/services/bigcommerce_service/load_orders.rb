# frozen_string_literal: true

module BigcommerceService
  # Load orders from Bigcommerce API
  class LoadOrders < BigcommerceService::BaseService
    class << self
      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      def call
        order_count = Bigcommerce::Order.count.count
        number_of_pages = (order_count / 50.0).ceil

        ActiveRecord::Base.transaction do
          (1..number_of_pages).each do |page_num|
            Bigcommerce::Order.all(page: page_num).each do |order|
              new_order = Order.create(order_params(order))

              product_url = order.products[:url]
              line_items = JSON.parse(Bigcommerce::Order.raw_request(:get, product_url).body)
              line_items.each do |line_item|
                new_order.line_items.create(line_item_params(line_item))
              end
            end
          end
        end

        results(true)
      rescue *user_exceptions => e
        results(false, error_message(e.message))
        # show error on the view
      rescue Faraday::ClientError => e
        results(false, e.message)
        # show error on the view
      rescue StandardError => e
        puts e.message
        # send to rollbar or other exception management tools
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

      private

      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      def order_params(order)
        customer = ::Customer.find_by_email(order.billing_address[:email])
        return if customer.blank?

        {
          bc_id: order.id,
          customer_id: customer.id,
          date_created: order.date_created,
          date_modified: order.date_modified,
          date_shipped: order.date_shipped,
          status: order.status,
          products_url: order.products[:url],
          subtotal_ex_tax: order.subtotal_ex_tax,
          subtotal_inc_tax: order.subtotal_inc_tax,
          subtotal_tax: order.subtotal_tax
        }
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

      def line_item_params(line_item)
        product = Product.find_by_sku(line_item['sku'])
        return if product.blank?

        {
          product_id: product.id,
          quantity: line_item['quantity']
        }
      end
    end
  end
end
