class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :word, null: false, index: true

      t.timestamps
    end
  end
end
