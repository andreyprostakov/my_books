class PublishersController < ApplicationController
  before_action :fetch_publisher, only: %i(edit update destroy)

  def new
    @publisher = Publisher.new
  end

  def index
    publishers = Publisher.by_names
    render json: publishers
  end

  def create
    @publisher = Publisher.new(publisher_params)
    if @publisher.save
      render json: @publisher
    else
      render json: @publisher.errors, status: 422
    end
  end

  def edit
  end

  def update
    if @publisher.update_attributes(publisher_params)
      render json: @publisher
    else
      render json: @publisher.errors, status: 422
    end
  end

  def destroy
    @publisher.destroy
    render json: {}
  end

  private

  def fetch_publisher
    @publisher = Publisher.find(params[:id])
  end

  def publisher_params
    params.require(:publisher).permit(:name)
  end
end
