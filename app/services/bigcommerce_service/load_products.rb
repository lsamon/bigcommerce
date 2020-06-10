# frozen_string_literal: true

module BigcommerceService
  # Load customers from Bigcommerce API
  class LoadProducts < BigcommerceService::BaseService
    class << self
      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      def call
        all_products = []
        product_count = Bigcommerce::Product.count.count
        number_of_pages = (product_count / 50.0).ceil

        (1..number_of_pages).each do |page_num|
          Bigcommerce::Product.all(page: page_num).each do |product|
            all_products << product_params(product)
          end
        end

        Product.create(all_products)

        results(true)
      rescue *user_exceptions => e
        results(false, error_message(e.message))
        # show error on the view
      rescue StandardError => e
        puts e.message
        # send to rollbar or other exception management tools
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

      private

      def product_params(product)
        {
          bc_id: product.id,
          name: product.name,
          sku: product.sku,
          price: product.price,
          description: product.description,
          date_created: product.date_created,
          date_modified: product.date_modified
        }
      end
    end
  end
end
