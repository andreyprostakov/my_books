class EditionsController < ApplicationController
  before_action :fetch_edition, only: %i(edit update destroy)

  def index
    @editions = Edition.all
    @editions = @editions.with_category_code(params[:category]) if params[:category]
  end

  def new
    @edition = Edition.new
    @edition.books.build
  end

  def create
    @edition = form_handler.create_edition
    if @edition.valid?
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if form_handler.update_edition(@edition)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    if @edition.destroy
      redirect_to root_path, error: "Could not destroy Edition #{@edition.id}"
    else
      redirect_to root_path, message: "Destroyed Edition #{@edition.id}"
    end
  end

  private

  def fetch_edition
    @edition = Edition.find(params[:id])
  end

  def form_handler
    @form_handler ||= EditionFormHandler.new(params)
  end
end
