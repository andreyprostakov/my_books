class AddEditionIdToBooks < ActiveRecord::Migration[5.0]
  class BookInEdition < ActiveRecord::Base
    belongs_to :book
  end

  class Book < ActiveRecord::Base
    has_many :book_in_editions
    has_many :m2m_book_authors, dependent: :destroy
  end

  class M2mBookAuthor < ActiveRecord::Base
    belongs_to :book
  end

  def up
    add_reference :books, :edition, index: false
    add_index :books, :edition_id

    Book.reset_column_information
    remove_unused_books
    BookInEdition.preload(book: [:m2m_book_authors]).find_each do |book_in_edition|
      book = book_in_edition.book
      next if book.nil?
      if book.edition_id.blank?
        book.update(edition_id: book_in_edition.edition_id)
      else
        create_new_book_for_book_in_edition(book_in_edition)
      end
    end

    change_column :books, :edition_id, :integer, null: false
  end

  def down
    Book.find_each do |book|
      book.book_in_editions.create(edition_id: book.edition_id)
    end

    remove_reference :books, :edition, index: true
  end

  private

  def remove_unused_books
    Book.includes(:book_in_editions).
      references(:book_in_editions).
      where('book_in_editions.id is ?', nil).
      destroy_all
  end

  def create_new_book_for_book_in_edition(book_in_edition)
    new_book = Book.create!(
      edition_id: book_in_edition.edition_id,
      title: book_in_edition.book.title
    )
    book_in_edition.book.m2m_book_authors.each do |m2m_book_author|
      M2mBookAuthor.create!(book: new_book, author_id: m2m_book_author.author_id)
    end
  end
end
