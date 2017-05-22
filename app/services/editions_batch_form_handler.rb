class EditionsBatchFormHandler
  BATCH_PARAMS = [
    :read,
    category: [:code],
    publisher: [:name],
    series: [:title]
  ].freeze

  attr_reader :edition_with_errors

  def initialize(params)
    @params = params
  end

  def update_editions(editions)
    Edition.transaction do
      Edition.where(id: editions).find_each do |edition|
        @edition = edition
        edition.update!(edition_params)
      end
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    @edition_with_errors = e.record
    false
  end

  private

  def edition_params
    @edition_params ||= build_edition_params
  end

  def build_edition_params
    edition_params = {}
    edition_params[:read] = batch_params[:read].presence
    if batch_params.dig(:category, :code).present?
      edition_params[:category] = find_category
    end
    if batch_params.dig(:publisher, :name).present?
      edition_params[:publisher] = find_publisher
    end
    if batch_params.dig(:series, :title).present?
      edition_params[:series] = find_series
    end
    edition_params.compact
  end

  def find_category
    EditionCategory.find_by!(code: batch_params[:category][:code])
  end

  def find_publisher
    Publisher.find_by!(name: batch_params[:publisher][:name])
  end

  def find_series
    Series.find_by!(title: batch_params[:series][:title])
  end

  def batch_params
    @batch_params ||= @params.require(:editions_batch).permit(*BATCH_PARAMS)
  end
end
