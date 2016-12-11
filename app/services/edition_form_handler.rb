class EditionFormHandler
  EDITION_PARAMS = [
    :title,
    :cover_url,
    :annotation,
    :isbn,
    books_attributes: BOOKS_PARAMS
  ].freeze
  BOOKS_PARAMS = %i(id title author_name _destroy).freeze

  def initialize(params)
    @params = params
  end

  def create_edition
    Edition.create(edition_params)
  end

  def update_edition(edition)
    edition.update_attributes(edition_params)
  end

  private

  def edition_params
    params.
      require(:edition).
      permit(*EDITION_PARAMS)
  end
end
