class EditionFormHandler
  BOOKS_PARAMS = [:id, :title, :_destroy, author_ids: []].freeze
  EDITION_PARAMS = [
    :title,
    :cover_url,
    :annotation,
    :isbn,
    :edition_category_id,
    books_attributes: BOOKS_PARAMS
  ].freeze

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
    @params.
      require(:edition).
      permit(*EDITION_PARAMS)
  end
end
