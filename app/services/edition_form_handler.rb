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
  rescue ActiveRecord::RecordInvalid
    edition
  end

  private

  def apply_attributes_to_edition(edition)
    edition.assign_attributes(filtered_params.slice(*EDITION_RAW_PARAMS))

    if filtered_params[:books]
      assign_books_params_to_edition(edition, filtered_params[:books])
    end

    if filtered_params[:category]
      assign_category_params_to_edition(edition, filtered_params[:category])
    end

    if filtered_params[:publisher]
      assign_publisher_params_to_edition(edition, filtered_params[:publisher])
    end
  end

  def assign_books_params_to_edition(edition, books_params)
    books_params.values.map do |book_params|
      create_book_for_edition(edition, book_params)
    end
  end

  def assign_category_params_to_edition(edition, category_params)
    edition.category = EditionCategory.find_by(code: category_params[:code])
  end

  def assign_publisher_params_to_edition(edition, publisher_params)
    edition.publisher = Publisher.where(name: publisher_params[:name]).first_or_initialize
  end

  def create_book_for_edition(edition, book_params)
    book_params = convert_book_params_to_attributes(book_params)
    book = Book.new(book_params)
    if book.save
      edition.books << book
    else
      edition.books.build(book_params)
    end
  end

  def convert_book_params_to_attributes(book_params)
    {
      title: book_params[:title],
      authors: fetch_authors_by_authors_params(
        book_params.fetch(:authors, {})
      )
    }
  end

  def fetch_authors_by_authors_params(authors_params)
    authors_params.values.map do |author_params|
      Author.where(name: author_params[:name]).first_or_create
    end
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
