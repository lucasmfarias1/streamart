class ProposalItem < ApplicationRecord
  belongs_to :service
  belongs_to :proposal
end
