require "rails_helper" 

RSpec.describe "Item search api", type: :request do
  describe "#index" do

    before do
      @merchant = create(:merchant)
      @item_1 = create(:item, merchant: @merchant, name: "toy soldier", unit_price: 2.0 )
      @item_2 = create(:item, merchant: @merchant, name: "toy coffee pot", unit_price: 30.5 )
      @item_3 = create(:item, merchant: @merchant, name: "toy ice pick", unit_price: 40.0 )
      @item_4 = create(:item, merchant: @merchant, name: "big pocketwatch", unit_price: 50.5 )
      @item_5 = create(:item, merchant: @merchant, name: "big fridge", unit_price: 100.0 )
    end

    context "when successful" do

      it " find all items which match a search term (case insensitive) " do
        get "/api/v1/items/find_all?name=to"

        expect(response).to be_successful
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data[:data]).to be_an(Array)
        expect(parsed_data[:data].size).to eq(3)
        expect(parsed_data[:data][0].keys).to eq([:id, :type, :attributes])
        expect(parsed_data[:data][0][:attributes].size).to eq(4)
        expect(parsed_data[:data][0][:attributes][:name]).to eq(@item_2.name)
        expect(parsed_data[:data][0][:attributes][:description]).to eq(@item_2.description)
        expect(parsed_data[:data][0][:attributes][:unit_price]).to eq(@item_2.unit_price)
        expect(parsed_data[:data][0][:attributes][:unit_price]).to be_a(Float)
        expect(parsed_data[:data][0][:attributes][:merchant_id]).to eq(@item_2.merchant_id)
      end

      it " returns all items greater than or equal to a MIN price" do
        get "/api/v1/items/find_all?min_price=999" 

        expect(response).to be_successful
        parsed_data = JSON.parse(response.body, symbolize_names: true)
        
      end

      xit " returns all items greater than or equal to a MAX price" do

        expect(response).to be_successful
        parsed_data = JSON.parse(response.body, symbolize_names: true)
      end

      xit " returns all items BETWEEN a given min and max price" do 
        
        expect(response).to be_successful
        parsed_data = JSON.parse(response.body, symbolize_names: true)
      end
    end

    context "When unsuccessful" do
      it "retunes a 200 status if item cant be found" do
        get "/api/v1/items/find_all?name=NOMATCH"

        expect(response).to be_successful

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to eq([])
      end
    end
  end
end