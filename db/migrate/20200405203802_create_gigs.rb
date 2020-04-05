class CreateGigs < ActiveRecord::Migration[6.0]
  def change
    create_table :gigs do |t|
      t.integer :status, null: false
      t.integer :customer_id, null: false
      t.integer :artist_id, null: false

      t.timestamps
    end
  end
end
