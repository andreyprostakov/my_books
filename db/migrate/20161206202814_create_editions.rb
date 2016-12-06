class CreateEditions < ActiveRecord::Migration[5.0]
  def change
    create_table :editions do |t|
      t.string :isbn, null: false
      t.string :title
      t.text :annotation
      t.string :cover_url
      t.string :editor
      t.integer :pages_count
      t.string :language_code
    end

    create_table :book_in_editions do |t|
      t.references :book, null: false, index: true
      t.references :edition, null: false, index: true
      t.string :title
      t.string :translator
    end
  end
end
