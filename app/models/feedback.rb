class Feedback < ApplicationRecord
  belongs_to :gig

  belongs_to(
    :giver,
    class_name: 'User',
    foreign_key: :giver_id,
    inverse_of: :feedbacks_given
  )
  belongs_to(
    :taker,
    class_name: 'User',
    foreign_key: :taker_id,
    inverse_of: :feedbacks_taken
  )

  def the_other_user(current_user)
    giver == current_user ? taker : giver
  end
end
