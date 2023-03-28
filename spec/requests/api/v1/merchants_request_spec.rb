require 'rails_helper'

RSpec.describe 'Merchants api' do
  before do 
    create_list(:merchant, 3)
  end

  describe "#index" do 
    before do  
      get '/api/v1/merchants'
    end

    context 'when successful' do
      it "returns all merchant" do
        
        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq 3
        expect(merchants[:data][0].keys).to eq([:id, :type, :attributes])
        expect(merchants[:data][0][:attributes][:name]).to eq(Merchant.first.name)
      end
    end
  end 
end