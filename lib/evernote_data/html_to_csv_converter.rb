module EvernoteData
  class HtmlToCsvConverter
    def convert(html_path, csv_path)
      books_data = extract_books_data_from_html(html_path)
      save_books_data_as_csv(books_data, csv_path)
    end

    private

    def extract_books_data_from_html(html_path)
      html_content = File.read html_path
      parsed_html = Nokogiri::HTML.parse(html_content)
      parsed_html.css('h1').map do |book_title_node|
        cover_node = book_title_node.next_element.at_css('img')
        generate_book_data_from_raw_book_info(book_title_node.text).merge(
          cover: generate_cover_path_from_cover_node(cover_node)
        )
      end
    end

    def generate_book_data_from_raw_book_info(raw_book_info)
      reversed_full_name, title, pages_count, publishing = raw_book_info.split('. - ')
      publishing ||= ''
      {
        full_name: reversed_full_name.split(', ').reverse.join(' '),
        title: title,
        pages_count: pages_count.to_i,
        publisher: publishing.gsub(/. \d+$/, ''),
        year: publishing[/\d{4}\s*$/].to_i,
        raw_title: raw_book_info
      }
    end

    def generate_cover_path_from_cover_node(cover_node)
      File.join(
        File.dirname(args[:html_path]),
        cover_node.attribute('src').text
      )
    end

    def save_books_data_as_csv(books_data, csv_path)
      File.open(csv_path, 'w') do |csv|
        csv << books_data.first.keys.to_csv
        books_data.each do |book_data|
          csv << book_data.values.to_csv
        end
      end
    end
  end
end
