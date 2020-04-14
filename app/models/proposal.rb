class Proposal < ApplicationRecord
  has_many :proposal_items, dependent: :destroy
  belongs_to(
    :customer,
    class_name: 'User',
    foreign_key: :customer_id,
    inverse_of: :proposals_as_customer
  )
  belongs_to(
    :artist,
    class_name: 'User',
    foreign_key: :artist_id,
    inverse_of: :proposals_as_artist
  )

  validates :status, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 3
  }

  # STATUSES
  # 1 - PENDING
  # 2 - SUBMITTED
  # 3 - ACCEPTED

  def pending?
    status == 1
  end

  def submitted?
    status == 2
  end

  def accepted?
    status == 3
  end
end
