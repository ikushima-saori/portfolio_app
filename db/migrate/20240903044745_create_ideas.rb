class CreateIdeas < ActiveRecord::Migration[6.1]
  def change
    create_table :ideas do |t|
      t.references :customer, null: false, foreign_key: true
      t.text :introduction, null: false
      t.text :title
      t.text :body
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end
  end
end
