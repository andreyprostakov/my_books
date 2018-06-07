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
    edition_params[:read] = batch_params[:read].presence || nil
    add_category_to_edition_params(edition_params, batch_params.dig(:category, :code))
    add_publisher_to_edition_params(edition_params, batch_params.dig(:publisher, :name))
    add_series_to_edition_params(edition_params, batch_params.dig(:series, :title))
    edition_params.compact
  end

  def add_category_to_edition_params(edition_params, category_code)
    return unless category_code.present?
    edition_params[:category] = EditionCategory.find_by!(code: category_code)
  end

  def add_publisher_to_edition_params(edition_params, publisher_name)
    return unless publisher_name.present?
    edition_params[:publisher] = Publisher.find_by!(name: publisher_name)
  end

  def add_series_to_edition_params(edition_params, series_title)
    return unless series_title.present?
    edition_params[:series] = Series.find_by!(title: series_title)
  end

  def batch_params
    @batch_params ||= @params.require(:editions_batch).permit(*BATCH_PARAMS)
  end
end
