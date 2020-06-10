require 'rails_helper'

describe CustomersController, type: :controller do
  let!(:customer) do
    Customer.create(
      first_name: 'Sigrid',
      last_name: 'Sittloh',
      email: 'customerAOCI270M@gmail.com',
      date_created: Time.current,
      date_modified: Time.current
    )
  end

  describe '#index' do
    context 'when customer list requested' do
      subject { get :index }

      it 'should respond successfully' do
        subject

        expect(response.status).to eq 200
      end

      it 'assigns @customers' do
        subject

        expect(assigns(:customers)).to eq([customer])
      end
    end
  end

  describe '#show' do
    context 'when a specific customer is requested' do
      subject { get :show, params: { id: customer.id } }

      it 'assigns @customer' do
        subject

        expect(assigns(:customer)).to eq(customer)
      end

      it 'should respond successfully' do
        subject

        expect(response.status).to eq 200
      end
    end
  end
end
