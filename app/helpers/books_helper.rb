module BooksHelper
  def all_book_titles
    @all_book_titles ||= Book.pluck(:title).sort
  end

  def all_book_authors
    @all_book_authors ||= Author.pluck(:name).sort
  end
end
