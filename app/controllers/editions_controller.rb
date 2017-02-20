class EditionsController < ApplicationController
  before_action :fetch_edition, only: %i(show edit update destroy)

  helper_method :current_editions_order

  def index
    editions = Edition.preload(:authors)
    @editions = EditionsOrderer.apply_to(editions, current_editions_order)
  end

  def show
  end

  def new
    @edition = Edition.new
    @edition.books.build
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

  def current_editions_order
    params.fetch(:order, EditionsOrderer::LAST_UPDATED).to_sym
  end
end
