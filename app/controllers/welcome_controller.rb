# frozen_string_literal: true

# WelcomeController
class WelcomeController < ApplicationController
  ##
  # Confirms that the API Client is configured correctly.
  def index
    time_response = Bigcommerce::System.time
    @time = time_response.respond_to?(:time) ? Time.at(time_response.time).strftime('%H:%M:%S') : 'N/A'
  end
end
