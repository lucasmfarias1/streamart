class User < ApplicationRecord
  acts_as_token_authenticatable

  has_one_attached :avatar
  has_many :services
  has_many(
    :gigs_as_artist,
    class_name: 'Gig',
    foreign_key: :artist_id,
    inverse_of: :artist
  )
  has_many(
    :gigs_as_customer,
    class_name: 'Gig',
    foreign_key: :customer_id,
    inverse_of: :customer
  )
  has_many(
    :proposals_as_artist,
    class_name: 'Proposal',
    foreign_key: :artist_id,
    inverse_of: :artist
  )
  has_many(
    :proposals_as_customer,
    class_name: 'Proposal',
    foreign_key: :customer_id,
    inverse_of: :customer
  )
  
  accepts_nested_attributes_for(
    :services,
    reject_if: :all_blank,
    allow_destroy: true
  )

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  # validate :avatar_type
  
  private

  def avatar_type
    if avatar.attached? == false ||
       !avatar.content_type.in?(%('images/jpeg' images/png))
      errors.add(:avatar, "are missing!")
    end
  end
end
