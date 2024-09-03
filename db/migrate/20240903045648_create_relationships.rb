class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.references :follower, null: false, foreign_key: { to_table: :customers }
      t.references :followed, null: false, foreign_key: { to_table: :customers }

      t.timestamps
    end

    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
