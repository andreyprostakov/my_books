class EditionCreateFormHandler
  BOOKS_PARAMS = [:title, authors: []].freeze
  EDITION_PARAMS = [
    :title,
    :remote_cover_url,
    :annotation,
    :isbn,
    :category,
    :publisher,
    :publication_year,
    :pages_count,
    books: BOOKS_PARAMS
  ].freeze

  def initialize(params)
    @params = params
  end

  def create_edition
    edition = create_edition!
  rescue ActiveRecord::RecordInvalid
    edition
  end

  private

  def create_edition!
    edition = nil
    Edition.transaction do
      edition = Edition.new(edition_params)
      edition.save!
      edition
    end
  rescue ActiveRecord::RecordInvalid
    edition
  end

  def edition_params
    @edition_params ||= prepare_parameters
  end

  def prepare_parameters
    raw_params = filter_params
    raw_params[:books] = Array(raw_params.fetch(:books, [])).map do |book_params|
      Book.create!(
        title: book_params[:title],
        authors: book_params[:authors].map { |a| Author.where(name: a).first_or_create! },
      )
    end
    if raw_params[:category]
      raw_params[:category] = EditionCategory.find_by(code: raw_params[:category])
    end
    if raw_params[:publisher]
      raw_params[:publisher] = Publisher.where(name: raw_params[:publisher]).first_or_create!
    end
    raw_params
  end

  def filter_params
    @params.
      require(:edition).
      permit(*EDITION_PARAMS)
  end
end
