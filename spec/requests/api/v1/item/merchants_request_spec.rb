require "rails_helper"

RSpec.describe "Items merchant API", type: :request do 
  describe "#show" do
    
    context "when successful" do 

      before do
        @merchant = create(:merchant)
        @item = create(:item, merchant: @merchant)
        get "/api/v1/items/#{@item.id}/merchant"
      end

      it "return all items associated with a merchant" do
        expect(response).to be_successful
        
        parsed_data = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.size).to eq(1)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])
        expect(parsed_data[:data][:attributes].keys).to eq([:name])
        expect(parsed_data[:data][:type]).to eq("merchant")
        expect(parsed_data[:data][:attributes][:name]).to eq(@merchant.name)
        
      end
      
    end
    
    context "when unsuccessful" do
      
      before do 
        @item = create(:item)
        get "/api/v1/items/fhgfhfhf/merchant"
      end
      
      it " return a 404 if the item is not found " do

        parsed_data = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to have_http_status(404)
        expect(parsed_data[:message]).to eq("Couldn't find Item with 'id'=fhgfhfhf")
      end
    end
  end
end