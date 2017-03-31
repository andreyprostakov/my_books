module EditionsHelper
  def edition_categories_codes
    [
      EditionCategory::FICTION,
      EditionCategory::NON_FICTION,
      EditionCategory::COMICS,
      EditionCategory::ENCYCLIPEDIA,
      EditionCategory::MEDIA
    ]
  end

  def options_for_category_select
    options_for_select(edition_categories_codes.map { |code| [t(code, scope: 'categories'), code] })
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

  def options_for_order_select
    options_for_select(edition_orders.map { |code| [t(code, scope: 'editions.orders'), code] })
  end
end
