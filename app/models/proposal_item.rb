class ProposalItem < ApplicationRecord
  belongs_to :service
  belongs_to :proposal
  has_many :proposal_images

  validates :title, length: { maximum: 20 }
  validates :description, length: { maximum: 140 }
end
