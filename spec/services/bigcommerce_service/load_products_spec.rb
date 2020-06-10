require 'rails_helper'
# rubocop:disable Metrics/BlockLength
describe BigcommerceService::LoadProducts do
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

    let(:json_body) do
      [
        {
          'id' => 77,
          'name' => '[Sample] Fog Linen Chambray Towel - Beige Stripe',
          'type' => 'physical',
          'sku' => 'SLCTBS',
          'description' => "<p>The perfect beach towel: thin, lightweight and highly absorbent. Crafted by Fog Linen in Japan using soft Lithuanian linen, each towel rolls up for compact stowaway. Dry off after a refreshing dip in the ocean and stretch out on it for a sun bath. The thinness ensures a quick dry so you can have it rolled back up in your bag without soaking your belongings.</p>\n<p>Measures 75 x 145 cm/29.5 x 57 in</p>\n<p>100% Linen</p>",
          'availability_description' => '',
          'price' => '49.0000',
          'total_sold' => 4,
          'date_created' => 'Fri, 03 Jul 2015 17:57:10 +0000',
          'categories' => [18, 23],
          'date_modified' => 'Wed, 05 Aug 2015 18:17:22 +0000'
        }
      ].to_json
    end

    subject { described_class.call }

    context 'when requests are valid' do
      before do
        stub_request(:get, 'https://store-velgoi8q0k.mybigcommerce.com/api/v2/products/count')
          .with(headers: headers)
          .to_return(status: 200, body: "{\"count\":15}", headers: {})

        stub_request(:get, 'https://store-velgoi8q0k.mybigcommerce.com/api/v2/products?page=1')
          .with(headers: headers)
          .to_return(status: 200, body: json_body, headers: {})
      end

      it 'should add products to the database' do
        expect { subject }.to change { Product.count }.by 1
      end
    end

    context 'when request fails and not server error' do
      let(:timeout) do
        [
          {
            'status' => 408,
            'message' => 'Request timed out.'
          }
        ].to_json
      end

      before do
        stub_request(:get, 'https://store-velgoi8q0k.mybigcommerce.com/api/v2/products/count')
          .to_return(status: 408, body: timeout, headers: {})
          .to_raise(Bigcommerce::TimeOut)
      end

      it 'should return error' do
        expect(subject[:message]).to eq 'Request timed out.'
      end
    end
  end
end
