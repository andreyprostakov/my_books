class EditionFormHandler
  BOOKS_PARAMS = [:title, authors: [:name]].freeze
  EDITION_PARAMS = [
    :title,
    :remote_cover_url,
    :annotation,
    :isbn,
    :publication_year,
    :pages_count,
    :force_update_books,
    :read,
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
    read
  ).freeze

  def initialize(params)
    @params = params
  end

  def create_edition
    update_edition Edition.new
  end

  def update_edition(edition)
    Edition.transaction do
      edition.books.destroy_all if filtered_params[:force_update_books]
      apply_attributes_to_edition(edition)
      edition.save!
      edition
    end
  rescue ActiveRecord::RecordInvalid => e
    edition
  end

  private

  def apply_attributes_to_edition(edition)
    edition.assign_attributes(filtered_params.slice(*EDITION_RAW_PARAMS))

    if filtered_params[:books]
      filtered_params.fetch(:books, {}).each do |_, book_params|
        create_book_for_edition(edition, book_params)
      end
    end

    category_code = filtered_params.fetch(:category, {})[:code]
    if category_code
      edition.category = EditionCategory.find_by(code: category_code)
    end

    publisher_name = filtered_params.fetch(:publisher, {})[:name]
    if publisher_name
      edition.publisher = Publisher.where(name: publisher_name).first_or_initialize
    end
  end

  def create_book_for_edition(edition, book_params)
    authors = book_params.fetch(:authors, {}).values.map do |author_params|
      Author.where(name: author_params[:name]).first_or_create
    end
    book = edition.books.build(book_params.slice(:title).merge(authors: authors))
    book.save
    book
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
