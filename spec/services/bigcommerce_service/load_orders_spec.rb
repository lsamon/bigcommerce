require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe BigcommerceService::LoadOrders do
  describe '.call' do
    let(:headers) do
      {
        'Accept' => 'application/json',
        'Accept-Encoding' => 'gzip',
        'Authorization' => 'Basic dGVzdDoyNTI1ZGY1NjQ3N2Y1OGU1ODY4YzI0MGVlNTIyOGIwYjVkNDM2N2M0',
        'Content-Type' => 'application/json',
        'User-Agent' => 'bigcommerce-api-ruby'
      }
    end

    let(:orders_json) do
      [
        {
          'id' => 100,
          'customer_id' => 0,
          'date_created' => 'Wed, 04 Apr 2018 03:24:40 +0000',
          'date_modified' => 'Wed,04 Apr 2018 23:18:07 +0000',
          'date_shipped' => '',
          'status' => 'Awaiting Fulfillment',
          'subtotal_ex_tax' => '50.0000',
          'subtotal_inc_tax' => '50.0000',
          'subtotal_tax' => '0.0000',
          'total_ex_tax' => '50.0000',
          'total_inc_tax' => '195015.0000',
          'total_tax' => '194965.0000',
          'shipping_address_count' => 1,
          'is_deleted' => false,
          'billing_address' => {
            'first_name' => 'Sigrid',
            'last_name' => 'Sittloh',
            'company' => '',
            'street_1' => '12345 W Anderson Ln',
            'street_2' => '',
            'city' => 'Austin',
            'state' => 'Texas',
            'zip' => '78757',
            'country' => 'United States',
            'country_iso2' => 'US',
            'phone' => '',
            'email' => 'customerAOCI270M@gmail.com',
            'form_fields' => []
          },
          'products' => {
            'url' => 'https://dominica-ernsers-store.mybigcommerce.com/api/v2/orders/100/products.json',
            'resource' => '/orders/100/products'
          }
        }
      ].to_json
    end

    let(:products_json) do
      [
        {
          'id' => 1,
          'rder_id' => 100,
          'product_id' => 111,
          'variant_id' => 0,
          'order_address_id' => 1,
          'name' => '[Sample] Smith Journal 13',
          'type' => 'physical',
          'sku' => 'SM13',
          'base_price' => '25.0000',
          'price_ex_tax' => '25.0000',
          'price_inc_tax' => '25.0000',
          'price_tax' => '0.0000',
          'base_total' => '0.0000',
          'total_ex_tax' => '50.0000',
          'total_inc_tax' => '50.0000',
          'total_tax' => '0.0000',
          'weight' => '1.0000',
          'width' => '0.0000',
          'height' => '0.0000',
          'depth' => '0.0000',
          'quantity' => 2,
          'base_cost_price' => '0.0000',
          'cost_price_inc_tax' => '0.0000',
          'cost_price_ex_tax' => '0.0000',
          'cost_price_tax' => '0.0000'
        }
      ].to_json
    end

    before do
      Customer.create(
        first_name: 'Sigrid',
        last_name: 'Sittloh',
        email: 'customerAOCI270M@gmail.com',
        date_created: Time.current,
        date_modified: Time.current
      )

      Product.create(
        name: '[Sample] Smith Journal 13',
        sku: 'SM13',
        date_created: Time.current,
        date_modified: Time.current
      )

      stub_request(:get, 'https://store-velgoi8q0k.mybigcommerce.com/api/v2/orders/count')
        .with(headers: headers)
        .to_return(status: 200, body: "{\"count\":20}", headers: {})

      stub_request(:get, 'https://store-velgoi8q0k.mybigcommerce.com/api/v2/orders?page=1')
        .with(headers: headers)
        .to_return(status: 200, body: orders_json, headers: {})

      stub_request(:get, 'https://dominica-ernsers-store.mybigcommerce.com/api/v2/orders/100/products.json')
        .with(headers: headers)
        .to_return(status: 200, body: products_json, headers: {})
    end

    subject { described_class.call }

    it 'should create orders in database' do
      expect { subject }.to change { Order.count }.by 1
    end
  end
end
