module EditionsHelper
  def edition_title(edition)
    edition.title || edition.books.to_a.join(&:title)
  end
end
