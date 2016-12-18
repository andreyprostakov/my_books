class CreateEditionCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :edition_categories do |t|
      t.string :code, null: false
    end
    add_index :edition_categories, :code, unique: true
    add_reference :editions, :edition_category, index: true
  end
end
