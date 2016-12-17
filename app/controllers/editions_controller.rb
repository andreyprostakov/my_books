class EditionsController < ApplicationController
  before_action :fetch_edition, only: %i(edit update destroy)

  def index
    @editions = find_editions
  end

  def new
    @edition = Edition.new
    @edition.books.build
  end

  def create
    @edition = form_handler.create_edition
    if @edition.valid?
      redirect_to editions_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if form_handler.update_edition(@edition)
      redirect_to editions_path
    else
      render :edit
    end
  end

  def destroy
    if @edition.destroy
      redirect_to editions_path, error: "Could not destroy Edition #{@edition.id}"
    else
      redirect_to editions_path, message: "Destroyed Edition #{@edition.id}"
    end
  end

  private

  def find_editions
    if params[:category]
      Edition.with_category_code(params[:category])
    else
      Edition.all
    end
  end

  def fetch_edition
    @edition = Edition.find(params[:id])
  end

  def form_handler
    @form_handler ||= EditionFormHandler.new(params)
  end
end
