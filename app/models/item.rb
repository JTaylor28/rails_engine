class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true
  validates :merchant_id, presence: true

  def self.search_item(word)
    where("name ILIKE ?", "%#{word}%")
    .order(:name)
  end

  def self.find_items_by_price(min_price, max_price)
    where("unit_price >= :min AND unit_price <= :max", { min: min_price, max: max_price })
    .order(unit_price: :asc)
  end
end