namespace :evernote_html do
  desc 'import from CSV'
  task :import_from_csv, [:csv_path] => :environment do |_, args|
    EvernoteData::CsvDataImporter.new.import_from(args.fetch(:csv_path))
  end

  desc 'convern HTML into CSV'
  task :convert_to_csv, %i(html_path csv_path) do |_t, args|
    EvernoteData::HtmlToCsvConverter.new.convert(
      args.fetch(:html_path),
      args.fetch(:csv_path)
    )
  end
end
