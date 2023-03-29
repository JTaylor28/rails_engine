require "rails_helper"
RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'instance methods' do 
    describe '#items_present?' do
      it "retuens false if invoice have has one or less " do

        merchant = create(:merchant)
				customer = create(:customer)

				item1 = create(:item, merchant_id: merchant.id)
				item2 = create(:item, merchant_id: merchant.id)

				invoice1 = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
				invoice2 = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)

				invoice_item1 = create(:invoice_item, invoice_id: invoice1.id, item_id: item1.id, quantity: 1)
				invoice_item2 = create(:invoice_item, invoice_id: invoice1.id, item_id: item2.id, quantity: 3)
				invoice_item3 = create(:invoice_item, invoice_id: invoice2.id, item_id: item1.id, quantity: 2)

				expect(invoice1.items.size).to eq(2)
				expect(invoice1.items_present?).to eq(false)
				expect(invoice2.items.size).to eq(1)
				expect(invoice2.items_present?).to eq(true)
      end
    end
  end
end