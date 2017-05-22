class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_editions_order,
    :current_editions_category,
    :current_author_name,
    :current_publisher_name,
    :current_series_title

  private

  def current_editions_order
    @current_editions_order ||= params.fetch(:order, EditionsOrderer::LAST_UPDATED).to_sym
  end

  def current_editions_category
    @current_editions_category ||= params[:category].try(:to_sym)
  end

  def current_author_name
    params[:author]
  end

  def current_publisher_name
    params[:publisher]
  end

  def current_series_title
    params[:series_title]
  end
end
