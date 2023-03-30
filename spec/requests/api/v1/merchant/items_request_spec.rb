require "rails_helper"

RSpec.describe "Merchant Items API", type: :request do 
  describe "#index" do
    
    context "when successful" do 

      before do
        @merchant = create(:merchant)
        @item1 = create(:item, merchant: @merchant)
        @item2 = create(:item, merchant: @merchant)
        @item3 = create(:item, merchant: @merchant)
        get "/api/v1/merchants/#{@merchant.id}/items"
      end

      it "return all items associated with a merchant" do
        expect(response).to be_successful
        
        parsed_data = JSON.parse(response.body, symbolize_names: true)
        
        expect(parsed_data[:data]).to be_an(Array)
        expect(parsed_data[:data].size).to eq(3)
        expect(parsed_data[:data][0].keys).to eq([:id, :type, :attributes])
        expect(parsed_data[:data][0][:attributes].size).to eq(4)
        expect(parsed_data[:data][0][:attributes][:name]).to eq(@item1.name)
        expect(parsed_data[:data][0][:attributes][:description]).to eq(@item1.description)
        expect(parsed_data[:data][0][:attributes][:unit_price]).to eq(@item1.unit_price)
        expect(parsed_data[:data][0][:attributes][:unit_price]).to be_a(Float)
        expect(parsed_data[:data][0][:attributes][:merchant_id]).to eq(@item1.merchant_id)
        
      end
    end
    
    context "when unsuccessful" do
      
      before do 
        get "/api/v1/merchants/fhgfhfhf/items"
      end
      
      it " return a 404 if the merchant is not found " do

        parsed_data = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to have_http_status(404)
        expect(parsed_data[:message]).to eq("Couldn't find Merchant with 'id'=fhgfhfhf")
      end
    end
  end
end