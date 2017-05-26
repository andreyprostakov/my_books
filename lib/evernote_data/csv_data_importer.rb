module EvernoteData
  class CsvDataImporter
    def import_from(csv_path)
      Edition.transaction do
        read_csv_lines(csv_path) do |book_data|
          generate_edition_by_book_data(book_data)
        end
      end
    end

    private

    def generate_edition_by_book_data(book_data)
      authors = generate_authors_by_book_authors_data book_data['full_name']
      Edition.create!(
        isbn: nil,
        category: category_for_editions,
        books: generate_books_by_book_titles_data(book_data['title'], authors: authors),
        publisher: generate_publisher_by_book_publisher_data(book_data['publisher']),
        publication_year: book_data.fetch('year').to_i,
        pages_count: book_data.fetch('pages_count').to_i,
        cover: File.open(book_data.fetch('cover'))
      )
    end

    def generate_authors_by_book_authors_data(authors_data)
      (authors_data || '').split(/\;\s*/).map do |name|
        Author.find_or_initialize_by(name: name)
      end
    end

    def generate_publisher_by_book_publisher_data(publisher_data)
      Publisher.find_or_initialize_by(
        name: (publisher_data || '').split(/;\s*/).first
      )
    end

    def generate_books_by_book_titles_data(book_titles_data, authors:)
      titles = (book_titles_data || '').split(/;\s*/)
      (book_titles_data || '').split(/;\s*/).map do |book_title|
        Book.new(title: book_title, authors: authors)
      end
    end

    def read_csv_lines(csv_path, &_)
      CSV.readlines(csv_path,
        headers: true,
        quote_char: '|',
        col_sep: HtmlToCsvConverter::COLUMNS_SEPARATOR
      ).each do |book_data_line|
        yield book_data_line
      end
    end

    def category_for_editions
      @category_for_editions ||= EditionCategory.fiction
    end
  end
end
