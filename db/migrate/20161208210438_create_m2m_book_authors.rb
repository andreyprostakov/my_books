class CreateM2mBookAuthors < ActiveRecord::Migration[5.0]
  def change
    create_table :m2m_book_authors do |t|
      t.references :author, null: false, index: true
      t.references :book, null: false, index: true
    end
  end
end
