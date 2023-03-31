require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe 'relationships' do 
   it { should have_many :items}
   it { should have_many :invoices }
  end

  describe 'validations' do
    it { should validate_presence_of :name}
  end

  describe "class methods " do 
    describe "::search_merchant" do
      it " returns the first merchant by name alphabetically " do
        merchant_1 = create(:merchant, name: "Chris Smith")
        merchant_2 = create(:merchant, name: "Christopher Taylor")
        merchant_3 = create(:merchant, name: "John Mcdanial ")
        merchant_4 = create(:merchant, name: "Jonathan parks ")

        expect(Merchant.search_merchant("chr")).to eq(merchant_1)
        expect(Merchant.search_merchant("chr")).to_not eq(merchant_2)
      end
    end
  end
end