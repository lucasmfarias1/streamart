class CreateProposalItems < ActiveRecord::Migration[6.0]
  def change
    create_table :proposal_items do |t|
      t.string :title
      t.string :description
      t.references :service, null: false, foreign_key: true
      t.references :proposal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
