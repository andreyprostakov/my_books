class EditionsController < ApplicationController
  EDITION_PARAMS = [
    :title, :cover_url, :annotation, :isbn
  ].freeze

  before_action :fetch_edition, only: %i(edit update)

  def index
    @editions = Edition.all
  end

  def new
    @edition = Edition.new
  end

  def create
    if Edition.create(edition_params)
      redirect_to :index
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @edition.update_attributes(edition_params)
      redirect_to :index
    else
      render :edit
    end
  end

  def destroy
    if @edition.destroy
      redirect_to :index
    else
      redirect_to :index
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
