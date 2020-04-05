class User < ApplicationRecord
  acts_as_token_authenticatable

  has_many :services
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
end
