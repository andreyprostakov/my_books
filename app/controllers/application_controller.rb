class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :edition_path_with,
    :editions_scope_params,
    :current_editions_order,
    :current_editions_category,
    :current_author_name,
    :current_publisher_name

  private

  def edition_path_with(additional_params = {})
    editions_path(editions_scope_params.merge(additional_params))
  end

  def editions_scope_params
    params.permit(:author, :order, :category)
  end

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
end
