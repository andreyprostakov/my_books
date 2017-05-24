class SeriesController < ApplicationController
  def index
    all_series = Series.by_names
    all_series = all_series.by_author(params[:author_name]) if params[:author_name]
    all_series = all_series.by_publisher(params[:publisher_name]) if params[:publisher_name]
    render json: all_series
  end

  def create
    @series = Series.new(series_params)
    if @series.save
      render json: @series
    else
      render json: @series.errors, status: 422
    end
  end

  def update
    @series = fetch_series
    if @series.update_attributes(series_params)
      render json: @series
    else
      render json: @series.errors, status: 422
    end
  end

  def destroy
    @series = fetch_series
    @series.destroy
    render json: {}
  end

  private

  def fetch_series
    Series.find(params[:id])
  end

  def series_params
    params.require(:series).permit(:title)
  end
end
