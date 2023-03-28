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

  describe "#show" do
    
    context "when successful" do
      
      before do
        get "/api/v1/items/#{Item.first.id}"
      end

      it "returns a specific Item" do

        expect(response).to be_successful

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])
        expect(parsed_data[:data][:attributes].size).to eq(4)
        expect(parsed_data[:data][:id]).to eq(Item.first.id.to_s)
        expect(parsed_data[:data][:type]).to eq("item")
        expect(parsed_data[:data][:attributes][:name]).to eq(Item.first.name)
        expect(parsed_data[:data][:attributes][:description]).to eq(Item.first.description)
        expect(parsed_data[:data][:attributes][:unit_price]).to eq(Item.first.unit_price)
        expect(parsed_data[:data][:attributes][:merchant_id]).to eq(Item.first.merchant_id)
      end
    end

    context "when unsuccessful" do

      before do
        get "/api/v1/items/1a2d3"
      end

      it "returns an error message" do 

        expect(response).to have_http_status(404)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data[:message]).to eq("Couldn't find Item with 'id'=1a2d3")
      end
    end
  end

  describe "#create" do 

    context "when successful" do
      it " create a new item" do
      
        item_params = ({
          name: 'Big thing',
          description: 'Its not a small thing',
          unit_price: 1000.99,
          merchant_id: Merchant.first.id
        })

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/items/", headers: headers, params: JSON.generate(item: item_params)

        expect(response).to be_successful

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        item_new = Item.last
        
        expect(parsed_data[:data][:attributes][:name]).to eq(item_new[:name])
        expect(parsed_data[:data][:attributes][:description]).to eq(item_new[:description])
        expect(parsed_data[:data][:attributes][:unit_price]).to eq(item_new[:unit_price])
        expect(parsed_data[:data][:attributes][:merchant_id]).to eq(item_new[:merchant_id])
      end 
    end

    # contest "when unsuccessful" do
    #   it " it returns an error message when not successfuly created" do
    #   end
    # end
  end
end