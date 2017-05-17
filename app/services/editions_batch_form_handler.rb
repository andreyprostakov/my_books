class EditionsBatchFormHandler
  BATCH_PARAMS = [
    :read,
    category: [:code],
    publisher: [:name]
  ].freeze

  def initialize(params)
    @params = params
  end

  def update_editions(editions)
    Edition.where(id: editions).update_all(build_edition_params)
  end

  private

  def build_edition_params
    edition_params = batch_params.slice(:read)
    edition_params[:edition_category_id] = find_category.try(:id) if batch_params[:category]
    edition_params[:publisher_id] = find_publisher.try(:id) if batch_params[:publisher]
    edition_params.compact
  end

  def find_category
    EditionCategory.find_by(code: batch_params[:category][:code])
  end

  def find_publisher
    Publisher.find_by(name: batch_params[:publisher][:name])
  end

  def batch_params
    @batch_params ||= @params.require(:editions_batch).permit(*BATCH_PARAMS)
  end
end
