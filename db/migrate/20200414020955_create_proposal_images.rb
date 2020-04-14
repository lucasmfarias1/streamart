class CreateProposalImages < ActiveRecord::Migration[6.0]
  def change
    create_table :proposal_images do |t|
      t.references :proposal_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
