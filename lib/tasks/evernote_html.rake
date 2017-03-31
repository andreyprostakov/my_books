namespace :evernote_html do
  desc 'import from CSV'
  task :import_from_csv, [:csv_path] => :environment do |_, args|
    editions_category = EditionCategory.find(1)
    Edition.transaction do
      CSV.readlines(args.fetch(:csv_path), headers: true).each do |book_info|
        authors = book_info['full_name'].presence &&
          book_info['full_name'].split(/\;\s*/).map { |name| Author.find_or_initialize_by(name: name) }
        publisher = book_info['publisher'].presence &&
          Publisher.find_or_initialize_by(name: book_info.fetch('publisher').split(/;\s*/).first)
        books = book_info.fetch('title').split(/;\s*/).map do |book_title|
          Book.find_or_initialize_by(title: book_title).tap do |book|
            book.update_attributes!(authors: authors || [])
          end
        end
        edition = Edition.create!(
          isbn: nil,
          category: editions_category,
          books: books,
          publisher: publisher,
          publication_year: book_info.fetch('year').to_i,
          pages_count: book_info.fetch('pages_count').to_i,
          cover: File.open(book_info.fetch('cover'))
        )
      end
    end
  end

  desc 'convern HTML into CSV'
  task :convert_to_csv, [:html_path, :csv_path] do |_t, args|
    html_content = File.read args.fetch(:html_path)
    books_data = []
    parsed_html = Nokogiri::HTML.parse(html_content)
    parsed_html.css('h1').each do |book_title_node|
      raw_title = book_title_node.text
      cover_node = book_title_node.next_element.at_css('img')

      reversed_full_name, title, pages_count, publishing = raw_title.split('. - ')
      publishing ||= ''
      books_data << {
        full_name: reversed_full_name.split(', ').reverse.join(' '),
        title: title,
        pages_count: pages_count.to_i,
        publisher: publishing.gsub(/. \d+$/, ''),
        year: publishing[/\d{4}\s*$/].to_i,
        cover: File.join(File.dirname(args[:html_path]), cover_node.attribute('src').text),
        raw_title: raw_title
      }
      puts books_data.last.inspect
    end
    File.open(args.fetch(:csv_path), 'w') do |csv|
      csv << books_data.first.keys.to_csv
      books_data.each do |book_data|
        csv << book_data.values.to_csv
      end
    end
  end
end
