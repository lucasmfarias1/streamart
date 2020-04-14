class ProposalImage < ApplicationRecord
  belongs_to :proposal_item

  has_one_attached :image

  validate :image_type

  private

  def image_type
    if image.attached? == false ||
       !image.content_type.in?(['image/jpeg', 'image/png'])
      errors.add(:image, "missing!")
    end
  end
end
