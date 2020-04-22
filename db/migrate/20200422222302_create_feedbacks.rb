class CreateFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.integer :giver_id
      t.integer :taker_id
      t.text :body
      t.references :gig, null: false, foreign_key: true

      t.timestamps
    end
  end
end
