require 'rails_helper'

describe WelcomeController, type: :controller do
  describe '#index' do
    context 'for any request' do
      it 'should respond successfully' do
        get :index
        expect(response.status).to eq 200
      end
    end
  end
end
