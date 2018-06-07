namespace :static_data do
  desc 'Nana'
  task :reload, [:model] => :environment do |_, args|
    model_class = args.fetch(:model).classify.constantize
    model_class.transaction do
      model_class.unscoped.destroy_all
      CSV.readlines(
        "./config/static_data/#{model_class.model_name.collection}.csv",
        headers: true
      ).each do |line|
        model_class.create!(line.to_hash)
      end
    end
  end
end
