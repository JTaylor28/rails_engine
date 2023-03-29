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

        expect(parsed_data[:data]).to be_an(Array)
        expect(parsed_data[:data].size).to eq(3)
        expect(parsed_data[:data][0].keys).to eq([:id, :type, :attributes])
        expect(parsed_data[:data][0][:attributes].size).to eq(4)
        expect(parsed_data[:data][0][:attributes][:name]).to eq(Item.first.name)
        expect(parsed_data[:data][0][:attributes][:description]).to eq(Item.first.description)
        expect(parsed_data[:data][0][:attributes][:unit_price]).to eq(Item.first.unit_price)
        expect(parsed_data[:data][0][:attributes][:unit_price]).to be_a(Float)
        expect(parsed_data[:data][0][:attributes][:merchant_id]).to eq(Item.first.merchant_id)
      end
    end
  end 

  describe "#show" do
    
    context "when successful" do
      
      before do
        @show_item = Item.first
        get "/api/v1/items/#{@show_item.id}"
      end

      it "returns a specific Item" do

        expect(response).to be_successful

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])
        expect(parsed_data[:data][:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
        expect(parsed_data[:data][:id]).to eq(@show_item.id.to_s)
        expect(parsed_data[:data][:type]).to eq("item")
        expect(parsed_data[:data][:attributes][:name]).to eq(@show_item.name)
        expect(parsed_data[:data][:attributes][:description]).to eq(@show_item.description)
        expect(parsed_data[:data][:attributes][:unit_price]).to eq(@show_item.unit_price)
        expect(parsed_data[:data][:attributes][:merchant_id]).to eq(@show_item.merchant_id)
      end
    end

    context "when unsuccessful" do
      it "returns an error message" do 
        get "/api/v1/items/1a2d3"
        
        parsed_data = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to have_http_status(404)
        expect(parsed_data[:message]).to eq("Couldn't find Item with 'id'=1a2d3")
      end
    end
  end

  describe "#create" do 

    context "when successful" do

      it "create a new item" do
        
        item_params = ({
          name: 'Big thing',
          description: 'Its not a small thing',
          unit_price: 1000.99,
          merchant_id: Merchant.first.id
        })
        
        headers = {"CONTENT_TYPE" => "application/json"}
          
        post "/api/v1/items/", headers: headers, params: JSON.generate(item: item_params)
          
        item_new = Item.last
      
        expect(response).to be_successful
        expect(response).to have_http_status(201)

        parsed_data = JSON.parse(response.body, symbolize_names: true)
        
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])
        expect(parsed_data[:data][:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
        expect(parsed_data[:data][:id]).to eq(item_new.id.to_s)
        expect(parsed_data[:data][:type]).to eq("item")
        expect(parsed_data[:data][:attributes][:name]).to eq(item_new[:name])
        expect(parsed_data[:data][:attributes][:description]).to eq(item_new[:description])
        expect(parsed_data[:data][:attributes][:unit_price]).to eq(item_new[:unit_price])
        expect(parsed_data[:data][:attributes][:unit_price]).to be_a(Float)
        expect(parsed_data[:data][:attributes][:merchant_id]).to eq(item_new[:merchant_id])
      end 
    end

    # contest "when unsuccessful" do
    #   it " it returns an error message when not successfuly created" do
    #   end
    # end
  end

  describe "#delete" do

    context "when successful" do
      it " deletes an item " do 
        item = Item.last

        expect(Item.count).to eq(3)

        delete "/api/v1/items/#{item.id}"

        expect(response).to be_successful
        expect(response).to have_http_status(204)

        expect(Item.count).to eq(2)
        expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    # contest " when unsuccessful" do
    #   it "returns an error message when not deleted properly" do

    #   end
    # end
  end
end