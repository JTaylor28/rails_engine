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
          
        post "/api/v1/items/", headers: headers, params: item_params, as: :json
          
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

    context "when unsuccessful" do
      it " returns an error when attribute types are not correct and/or missing " do
        item_params = ({
                        name: '',
                        description: '',
                        unit_price: "1000.99",
                        merchant_id: Merchant.first.id
                      })
        
        headers = {"CONTENT_TYPE" => "application/json"}
          
        post "/api/v1/items/", headers: headers, params: item_params, as: :json
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)
        expect(parsed_data[:message]).to eq("item was not created. Attributes must be valid")
        expect(parsed_data[:errors]).to eq("Name can't be blank, Description can't be blank")
      end
    end
    
    it " ignore any attributes sent by the user which are not allowed " do
      item_params = ({
                      name: 'Big thing',
                      description: 'Its not a small thing',
                      unit_price: 1000.99,
                      merchant_id: Merchant.first.id,
                      ignored_attributes: "yadayda"
                    })
      
      headers = {"CONTENT_TYPE" => "application/json"}
        
      post "/api/v1/items/", headers: headers, params: item_params, as: :json
        
      parsed_data = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_data.size).to eq(1)
      expect(parsed_data[:data][:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
      expect(parsed_data[:data][:attributes].keys).to_not eq([:name, :description, :unit_price, :merchant_id, :ignored_attributes ])
    end
  end

  describe "#destroy" do

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

  describe "#update" do

    context "when successful" do
      it "updates an item" do
        merchant = create(:merchant)
        id = create(:item).id
        previous_item = Item.last
        item_params = { name: "new name",
                        description: "new descriptio",
                        unit_price: 999.99,
                        merchant_id: merchant.id
                      }
        headers = {"CONTENT_TYPE" => "application/json"}

        patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
        
        updated_item = Item.find_by(id: id)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response).to have_http_status(201)

        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])
        expect(parsed_data[:data][:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
        expect(parsed_data[:data][:id]).to eq(updated_item.id.to_s)
        expect(parsed_data[:data][:type]).to eq("item")
        expect(parsed_data[:data][:attributes][:name]).to eq(updated_item[:name])
        expect(parsed_data[:data][:attributes][:description]).to eq(updated_item[:description])
        expect(parsed_data[:data][:attributes][:unit_price]).to eq(updated_item[:unit_price])
        expect(parsed_data[:data][:attributes][:unit_price]).to be_a(Float)
        expect(parsed_data[:data][:attributes][:merchant_id]).to eq(updated_item[:merchant_id])

        expect(parsed_data[:data][:attributes][:name]).to_not eq(previous_item[:name])
        expect(parsed_data[:data][:attributes][:description]).to_not eq(previous_item[:description])
        expect(parsed_data[:data][:attributes][:unit_price]).to_not eq(previous_item[:unit_price])
      end 
    end

    context "when unsuccessful" do
      it "returns an error message for invalid id" do
        patch "/api/v1/items/71717"

        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(404)
        expect(parsed[:message]).to eq("Couldn't find Item with 'id'=71717")
      end

      it "returns an error for a bad merchant id " do
        id = create(:item).id
        previous_item = Item.last
        bad_params = { name: "new name",
                        description: "new descriptio",
                        unit_price: 999.99,
                        merchant_id: 99999999
                      }
        headers = {"CONTENT_TYPE" => "application/json"}

        patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: bad_params})

        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(404)
        expect(parsed[:errors]).to eq("Merchant ID doesn't exist")
      end
    end 
  end
end