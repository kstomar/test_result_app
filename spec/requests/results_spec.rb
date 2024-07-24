require 'rails_helper'

RSpec.describe 'Results', type: :request do
  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { subject: "Science", timestamp: "2022-04-18 12:01:34.678", marks: 85.25 } }

      it 'creates a new result and returns status ok' do
        expect {
          post results_data_path, params: { result: valid_params }
        }.to change(Result, :count).by(1)
        
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          subject: nil,  # Invalid because subject is missing
          timestamp: '2022-04-18 12:01:34.678',
          marks: 85.25
        }
      end

      it 'does not create a new result and returns unprocessable entity' do
        expect {
          post results_data_path, params: { result: invalid_params }
        }.not_to change(Result, :count)
        
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors in the response body' do
        post results_data_path, params: { result: invalid_params }
        expect(response.body).to include("can't be blank")
      end
    end
  end
end

