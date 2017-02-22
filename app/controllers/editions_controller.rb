class EditionsController < ApplicationController
  before_action :fetch_edition, only: %i(show edit update destroy)

  def index
    @editions = current_editions_scope
    respond_to do |format|
      format.json do
        render json: {
          editions: ActiveModelSerializers::SerializableResource.new(@editions).as_json
        }
      end
      format.html
    end
  end

  def show
  end

  def new
    @edition = current_editions_scope.new
    author = Author.find_by(name: current_author_name) if current_author_name
    @edition.books.build(authors: [author].compact)
  end

  def create
    @edition = form_handler.create_edition
    if @edition.valid?
      redirect_to edition_path(@edition)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if form_handler.update_edition(@edition)
      redirect_to edition_path(@edition)
    else
      render :edit
    end
  end

  def destroy
    @edition.destroy
    redirect_to :back
  end

  private

  def fetch_edition
    @edition = Edition.find(params[:id])
  end

  def form_handler
    @form_handler ||= EditionFormHandler.new(params)
  end

  def current_editions_scope
    editions = Edition.preload(:authors)
    if current_editions_category
      editions = editions.with_category_code(current_editions_category)
    end
    editions = editions.with_author(current_author_name) if current_author_name
    EditionsOrderer.apply_to(editions, current_editions_order)
  end
end
