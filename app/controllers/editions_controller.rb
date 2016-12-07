class EditionsController < ApplicationController
  EDITION_PARAMS = [
    :title, :cover_url, :annotation, :isbn,
    :books_attributes => [:id, :title, :author, :_destroy]
  ].freeze

  before_action :fetch_edition, only: %i(edit update)

  def index
    @editions = Edition.all
  end

  def new
    @edition = Edition.new
    @edition.books.build
  end

  def create
    if Edition.create(edition_params)
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @edition.update_attributes(edition_params)
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

  def edition_params
    params.require(:edition).permit(*EDITION_PARAMS)
  end
end
