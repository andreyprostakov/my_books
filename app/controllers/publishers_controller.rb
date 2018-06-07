class PublishersController < ApplicationController
  def index
    publishers = Publisher.by_names
    publishers = publishers.for_author(params[:author_name]) if params[:author_name]
    publishers = publishers.of_series(params[:series_title]) if params[:series_title]
    publishers = publishers.in_category(params[:category_code]) if params[:category_code]
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

  def update
    @publisher = fetch_publisher
    if @publisher.update_attributes(publisher_params)
      render json: @publisher
    else
      render json: @publisher.errors, status: 422
    end
  end

  def destroy
    @publisher = fetch_publisher
    @publisher.destroy
    render json: {}
  end

  private

  def fetch_publisher
    Publisher.find(params[:id])
  end

  def publisher_params
    params.require(:publisher).permit(:name)
  end
end
