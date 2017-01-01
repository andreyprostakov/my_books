module EditionsHelper
  def edition_title(edition)
    edition.title.presence ||
      edition.books.map { |b| "\"#{b.title}\"" }.join(', ')
  end

  def edition_author(edition)
    edition.authors.map(&:name).uniq.join(', ')
  end

  def links_to_authors(authors, options = {})
    authors.uniq.map do |author|
      link_to(author.name, author_path(author), options)
    end.join(', ').html_safe
  end
end
