module EditionsHelper
  def edition_title(edition)
    edition.title.presence || edition_title_by_books(edition)
  end

  private

  def edition_title_by_books(edition)
    books = edition.books
    books.map { |b| "\"#{b.title}\"" }.join(', ') + ' ' +
      books.map(&:author).join(', ')
  end
end
