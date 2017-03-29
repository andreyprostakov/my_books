class EditionFormHandler
  BOOKS_PARAMS = [:title, authors: [:name]].freeze
  EDITION_PARAMS = [
    :title,
    :remote_cover_url,
    :annotation,
    :isbn,
    :publication_year,
    :pages_count,
    category: [:code],
    publisher: [:name],
    books: BOOKS_PARAMS
  ].freeze
  EDITION_RAW_PARAMS = %i(
    title
    remote_cover_url
    annotation
    isbn
    publication_year
    pages_count
  ).freeze

  def initialize(params)
    @params = params
  end

  def create_edition
    update_edition Edition.new
  end

  def update_edition(edition)
    Edition.transaction do
      edition.assign_attributes(edition_params)
      edition.books.destroy_all
      edition.books = filtered_params.fetch(:books, {}).map do |book_index, book_params|
        book = edition.books.build(prepare_book_params book_params)
        book.save
        book
      end
      edition.save!
      edition
    end
  rescue ActiveRecord::RecordInvalid => e
    edition
  end

  private

  def edition_params
    filtered_params.slice(*EDITION_RAW_PARAMS).tap do |edition_params|
      category_code = filtered_params.fetch(:category, {})[:code]
      if category_code
        edition_params[:category] = EditionCategory.find_by(code: category_code)
      end

      publisher_name = filtered_params.fetch(:publisher, {})[:name]
      if publisher_name
        publisher = Publisher.where(name: publisher_name).first_or_initialize
        edition_params[:publisher] = publisher
      end
    end
  end

  def prepare_book_params(raw_book_params)
    authors = raw_book_params.fetch(:authors, {}).values.map do |author_params|
      Author.where(name: author_params[:name]).first_or_initialize
    end
    raw_book_params.
      slice(:title).
      merge(authors: authors)
  end

  def filtered_params
    @filtered_params ||= filter_params
  end

  def filter_params
    @params.
      require(:edition).
      permit(*EDITION_PARAMS)
  end
end
