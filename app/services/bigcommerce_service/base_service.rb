# frozen_string_literal: true

module BigcommerceService
  # Base Service
  class BaseService
    class << self
      private

      # rubocop:disable Metrics/MethodLength
      def user_exceptions
        [
          Bigcommerce::BadRequest,
          Bigcommerce::Unauthorized,
          Bigcommerce::Forbidden,
          Bigcommerce::NotFound,
          Bigcommerce::MethodNotAllowed,
          Bigcommerce::NotAccepted,
          Bigcommerce::TimeOut,
          Bigcommerce::ResourceConflict,
          Bigcommerce::TooManyRequests
        ]
      end
      # rubocop:enable Metrics/MethodLength

      def error_message(errors)
        errors = JSON.parse(errors)
        errors.map { |error| error['message'] }.join('. ')
      end

      def results(status, message = '')
        { success: status, message: message }
      end
    end
  end
end
