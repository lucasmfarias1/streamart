class GigItem < ApplicationRecord
  belongs_to :gig, inverse_of: :gig_items

  validates :title, :description, :price, presence: true
  validates :title, length: { maximum: 20 }
  validates :description, length: { maximum: 140 }
  validates :price, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 999999
  }
end
