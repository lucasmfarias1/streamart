class CreateGigItems < ActiveRecord::Migration[6.0]
  def change
    create_table :gig_items do |t|
      t.string :title
      t.string :description
      t.decimal :price, precision: 8, scale: 2
      t.references :gig, null: false, foreign_key: true

      t.timestamps
    end
  end
end
