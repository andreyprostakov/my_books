class EditionsController < ApplicationController
  helper_method :current_editions_order,
    :current_editions_category,
    :current_author_name,
    :current_publisher_name

  def index
    respond_to do |format|
      render json: current_editions_scope
      format.html
    end
  end

  def show
    @edition = fetch_edition
    render json: @edition, serializer: EditionDetailsSerializer
  end

  def create
    @edition = form_handler.create_edition
    if @edition.valid?
      render json: @edition
    else
      render json: @edition.errors, status: 422
    end
  end

  def update
    @edition = fetch_edition
    if form_handler.update_edition(@edition).valid?
      render json: @edition
    else
      render json: @edition.errors, status: 422
    end
  end

  def destroy
    @edition = fetch_edition
    @edition.destroy
    render json: {}
  end

  private

  def fetch_edition
    Edition.find(params[:id])
  end

  def form_handler
    @form_handler ||= EditionFormHandler.new(params)
  end

  def current_editions_scope
    editions = Edition.preload(:authors).preload(:category)
    if current_editions_category
      editions = editions.with_category_code(current_editions_category)
    end
    editions = editions.with_author(current_author_name) if current_author_name
    editions = editions.with_publisher(current_publisher_name) if current_publisher_name
    EditionsOrderer.apply_to(editions, current_editions_order)
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
