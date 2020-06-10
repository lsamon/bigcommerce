# frozen_string_literal: true

module BigcommerceService
  # Load customers from Bigcommerce API
  class LoadCustomers < BigcommerceService::BaseService
    class << self
      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      def call
        all_customers = []
        customer_count = Bigcommerce::Customer.count.count
        number_of_pages = (customer_count / 50.0).ceil

        (1..number_of_pages).each do |page_num|
          Bigcommerce::Customer.all(page: page_num).each do |customer|
            all_customers << customer_params(customer)
          end
        end

        Customer.create(all_customers)

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

      def customer_params(customer)
        {
          bc_id: customer.id,
          first_name: customer.first_name,
          last_name: customer.last_name,
          email: customer.email,
          date_created: customer.date_created,
          date_modified: customer.date_modified
        }
      end
    end
  end
end
