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

  def edition_categories_codes
    [
      EditionCategory::FICTION,
      EditionCategory::NON_FICTION,
      EditionCategory::COMICS,
      EditionCategory::ENCYCLIPEDIA,
      EditionCategory::MEDIA
    ]
  end

  def edition_orders
    [
      EditionsOrderer::BY_TITLE,
      EditionsOrderer::NEW_FIRST,
      EditionsOrderer::OLD_FIRST,
      EditionsOrderer::LAST_UPDATED,
      EditionsOrderer::BY_AUTHOR
    ]
  end

  def link_to_order_editions(order)
    link_to t(order, scope: 'editions.orders'),
      url_for(order: order),
      class: "editions-order #{'active' if current_editions_order == order}"
  end

  def edition_status_read_control(edition, options = {})
    if edition.read?
      link_to t('books.actions.mark_as_not_read'),
        edition_status_read_path(edition),
        options.merge(method: :delete)
    else
      link_to t('books.actions.mark_as_read'),
        edition_status_read_path(edition),
        options.merge(method: :post)
    end
  end
end
