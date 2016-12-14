module EditionsHelper
  def edition_title(edition)
    edition.title.presence ||
      edition.books.map { |b| "\"#{b.title}\"" }.join(', ')
  end

  def edition_author(edition)
    edition.authors.map(&:name).uniq.join(', ')
  end
end
