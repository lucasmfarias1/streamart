class Gig < ApplicationRecord
  belongs_to(
    :customer,
    class_name: 'User',
    foreign_key: :customer_id,
    inverse_of: :gigs_as_customer
  )
  belongs_to(
    :artist,
    class_name: 'User',
    foreign_key: :artist_id,
    inverse_of: :gigs_as_artist
  )
  has_many :gig_items, dependent: :destroy, inverse_of: :gig

  accepts_nested_attributes_for(
    :gig_items,
    reject_if: :all_blank
  )

  validates :status, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 3
  }

  # STATUS
  # 1 - PENDING PAYMENT
  # 2 - PAID AND ONGOING
  # 3 - FINISHED
end
