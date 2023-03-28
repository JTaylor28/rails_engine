require 'rails_helper'

RSpec.describe 'Merchants api', type: :request  do
 
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

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data[:data].count).to eq(3)
        expect(parsed_data[:data][0].keys).to eq([:id, :type, :attributes])
        expect(parsed_data[:data][0][:attributes][:name]).to eq(Merchant.first.name)
      end
    end
  end 

  describe "#show" do
    
    context "when successful" do
      
      before do
        get "/api/v1/merchants/#{Merchant.first.id}"
      end

      it "returns a specific merchant" do

        expect(response).to be_successful

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data[:data].count).to eq(3)
        expect(parsed_data[:data][:attributes].count).to eq(1)
        expect(parsed_data[:data][:id]).to eq(Merchant.first.id.to_s)
        expect(parsed_data[:data][:attributes][:name]).to eq(Merchant.first.name)
      end
    end

    context "when unsuccessful" do

      before do
        get "/api/v1/merchants/abc"
      end

      it "returns an error message" do 
        
        expect(response).to have_http_status(404)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data[:message]).to eq("Couldn't find Merchant with 'id'=abc")
      end
    end
  end
end