Bigcommerce.configure do |config|
  config.auth = 'legacy'
  config.url = ENV['BC_API_ENDPOINT_LEGACY']
  config.username = ENV['BC_API_USERNAME']
  config.api_key = ENV['BC_API_KEY']
end
