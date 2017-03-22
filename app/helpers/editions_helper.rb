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
      link_to(author.name,
        editions_path(author: author.name),
        options
      )
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

  def link_to_edition_category(category_code)
    is_active = current_editions_category == category_code
    link_to t(category_code, scope: 'categories'),
      edition_path_with(category: category_code),
      class: "editions-category-link #{'active' if is_active}"
  end

  def edition_orders
    [
      EditionsOrderer::LAST_UPDATED,
      EditionsOrderer::NEW_FIRST,
      EditionsOrderer::BY_TITLE,
      EditionsOrderer::OLD_FIRST,
      EditionsOrderer::BY_AUTHOR
    ]
  end

  def link_to_order_editions(order)
    is_active = current_editions_order == order
    link_to t(order, scope: 'editions.orders'),
      edition_path_with(order: order),
      class: "editions-order-link #{'active' if is_active}"
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

  def options_for_order_select
    options_for_select edition_orders.map do |code|
      [t(code, scope: 'editions.orders'), code]
    end
  end
end
