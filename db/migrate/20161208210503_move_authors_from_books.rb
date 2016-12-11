class MoveAuthorsFromBooks < ActiveRecord::Migration[5.0]
  class Book < ActiveRecord::Base
    has_many :m2m_book_authors
    has_many :authors, through: :m2m_book_authors
  end

  class M2mBookAuthor < ActiveRecord::Base
    belongs_to :author
    belongs_to :book
  end

  class Author < ActiveRecord::Base
  end

  def up
    Book.find_each do |book|
      author = Author.find_or_create_by!(name: book.author)
      M2mBookAuthor.create!(book: book, author: author)
    end
    remove_column :books, :author
  end

  def down
    add_column :books, :author, :string
    Book.find_each do |book|
      book.update_attribute(:author, book.authors.first.name)
    end
    change_column :books, :author, :string, null: false
  end
end
