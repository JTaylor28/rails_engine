require "rails_helper"

RSpec.describe "Merchant Search API", type: :request do
  describe "#show" do
    context " When successful" do
      before do 
        @merchant_1 = create(:merchant, name: "Chris Smith")
        @merchant_2 = create(:merchant, name: "Christopher Taylor")
        @merchant_3 = create(:merchant, name: "John Mcdanial ")
        @merchant_4 = create(:merchant, name: "Jonathan parks ")
      end
      
      it " finds the first merchant that matches a search term " do

        get "/api/v1/merchants/find?name=chr"

        expect(response).to be_successful

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])
        expect(parsed_data[:data][:attributes].size).to eq(1)
        expect(parsed_data[:data][:id]).to eq(@merchant_1.id.to_s)
        expect(parsed_data[:data][:type]).to eq("merchant")
        expect(parsed_data[:data][:attributes][:name]).to eq(@merchant_1.name)
      end
    end

    context " When unsuccessful" do

      before do 
        @merchant_1 = create(:merchant, name: "Chris Smith")
        @merchant_2 = create(:merchant, name: "Christopher Taylor")
        @merchant_3 = create(:merchant, name: "John Mcdanial ")
        @merchant_4 = create(:merchant, name: "Jonathan parks ")
      end

      it " retuens nil object if merchant cant be found " do
        
        get "/api/v1/merchants/find?name=abc"

        expect(response).to be_successful

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to eq({})
      end 
    end
  end
end