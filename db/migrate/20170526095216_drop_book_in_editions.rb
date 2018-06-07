class DropBookInEditions < ActiveRecord::Migration[5.0]
  def up
    drop_table :book_in_editions
  end

  def down
    create_table :book_in_editions do |t|
      t.references :book, null: false, index: true
      t.references :edition, null: false, index: true
      t.string :title
      t.string :translator
    end
  end
end
