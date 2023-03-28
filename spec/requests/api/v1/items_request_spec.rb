require 'rails_helper'

RSpec.describe 'items api', type: :request  do
 
  before do 
    create_list(:item, 3)
  end

  describe "#index" do 

    before do  
      get '/api/v1/items'
    end

    context 'when successful' do
      it "returns all items" do
        
        expect(response).to be_successful

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data[:data].size).to eq(3)
        expect(parsed_data[:data][0].keys).to eq([:id, :type, :attributes])
        expect(parsed_data[:data][0][:attributes][:name]).to eq(Item.first.name)
        expect(parsed_data[:data][0][:attributes][:description]).to eq(Item.first.description)
        expect(parsed_data[:data][0][:attributes][:unit_price]).to eq(Item.first.unit_price)
        expect(parsed_data[:data][0][:attributes][:merchant_id]).to eq(Item.first.merchant_id)
      end
    end
  end 
end 