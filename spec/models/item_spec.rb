require "rails_helper"

RSpec.describe Item, type: :model do
  describe 'relationships' do 
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of :unit_price }
  end

  describe "class methods " do 
    before do
      @merchant = create(:merchant)
      @item_1 = create(:item, merchant: @merchant, name: "toy soldier", unit_price: 2.0 )
      @item_2 = create(:item, merchant: @merchant, name: "toy coffee pot", unit_price: 30.5 )
      @item_3 = create(:item, merchant: @merchant, name: "toy ice pick", unit_price: 40.0 )
      @item_4 = create(:item, merchant: @merchant, name: "big pocketwatch", unit_price: 50.5 )
      @item_5 = create(:item, merchant: @merchant, name: "big fridge", unit_price: 100.0 )
    end

    describe "::search_item" do
      it " returns all items by keyword in alphabetical order " do

        expect(Item.search_item("to")).to eq([@item_2, @item_3, @item_1])
        expect(Item.search_item("to")).to_not eq([@item_4, @item_5])
      end
    end

    describe "::find_items_by_price" do
      it " returns items between min and max by price " do
        expect(Item.find_items_by_price(2, 40)).to eq([@item_1, @item_2, @item_3])
        expect(Item.find_items_by_price(39, 500)).to eq([@item_3, @item_4, @item_5])
      end
    end
  end
end