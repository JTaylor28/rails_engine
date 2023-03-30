class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  validates :name, presence: true


  def self.search_merchant(name)
    where("name ILIKE ?", "%#{name}%")
    .order(:name).first
  end
end