require 'rails_helper'
# rubocop:disable Metrics/BlockLength
describe BigcommerceService::LoadCustomers do
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
          'id' => 1,
          'company' => '',
          'first_name' => 'Jennifer',
          'last_name' => 'Fox',
          'email' => 'customer1091RI6L@gmail.com',
          'phone' => '',
          'form_fields' => nil,
          'date_created' => 'Wed, 04 Apr 2018 23:08:28 +0000',
          'date_modified' => 'Wed, 04 Apr 2018 23:08:28 +0000',
          'store_credit' => '0.0000',
          'registration_ip_address' => '',
          'customer_group_id' => 2,
          'notes' => '',
          'tax_exempt_category' => '',
          'reset_pass_on_login' => false,
          'accepts_marketing' => false,
          'addresses' => {
            'url' => 'https://dominica-ernsers-store.mybigcommerce.com/api/v2/customers/1/addresses.json',
            'resource' => '/customers/1/addresses'
          }
        }
      ].to_json
    end

    subject { described_class.call }

    context 'when requests succeed' do
      before do
        stub_request(:get, 'https://store-velgoi8q0k.mybigcommerce.com/api/v2/customers/count')
          .with(headers: headers)
          .to_return(status: 200, body: "{\"count\":50}", headers: {})

        stub_request(:get, 'https://store-velgoi8q0k.mybigcommerce.com/api/v2/customers?page=1')
          .with(headers: headers)
          .to_return(status: 200, body: json_body, headers: {})
      end

      it 'should add customers to the database' do
        expect { subject }.to change { Customer.count }.by 1
      end
    end

    context 'when request fails and not server error' do
      let(:not_found) do
        [
          {
            'status' => 404,
            'message' => 'The requested resource was not found.'
          }
        ].to_json
      end

      before do
        stub_request(:get, 'https://store-velgoi8q0k.mybigcommerce.com/api/v2/customers/count')
          .to_return(status: 404, body: not_found, headers: {})
          .to_raise(Bigcommerce::NotFound)
      end

      it 'should return error' do
        expect(subject[:message]).to eq 'The requested resource was not found.'
      end
    end
  end
end
