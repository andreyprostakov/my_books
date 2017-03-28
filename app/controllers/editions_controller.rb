class EditionsController < ApplicationController
  before_action :fetch_edition, only: %i(show edit update destroy)

  def index
    respond_to do |format|
      format.json { render json: current_editions_scope }
      format.html
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @edition, serializer: EditionDetailsSerializer }
    end
  end

  def new
    @edition = current_editions_scope.new
    author = Author.find_by(name: current_author_name) if current_author_name
    @edition.books.build(authors: [author].compact)
  end

  def create
    @edition = EditionCreateFormHandler.new(params).create_edition
    if @edition.valid?
      respond_to do |format|
        format.json { render json: @edition }
        format.html { redirect_to root_path }
      end
    else
      respond_to do |format|
        format.json { render json: @edition.errors, status: 422 }
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    if form_handler.update_edition(@edition)
      respond_to do |format|
        format.json { render json: @edition }
        format.html { redirect_to root_path }
      end
    else
      respond_to do |format|
        format.json { render json: @edition.errors, status: 422 }
        format.html { render :edit }
      end
    end
  end

  def destroy
    @edition.destroy
    respond_to do |format|
      format.json { render json: {} }
      format.html { redirect_to :back }
    end
  end

  private

  def fetch_edition
    @edition = Edition.find(params[:id])
  end

  def form_handler
    @form_handler ||= EditionFormHandler.new(params)
  end

  def current_editions_scope
    editions = Edition.all
    if current_editions_category
      editions = editions.with_category_code(current_editions_category)
    end
    editions = editions.with_author(current_author_name) if current_author_name
    editions = editions.with_publisher(current_publisher_name) if current_publisher_name
    EditionsOrderer.apply_to(editions, current_editions_order)
  end
end
