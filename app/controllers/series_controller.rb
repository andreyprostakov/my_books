class SeriesController < ApplicationController
  def index
    all_series = Series.by_names
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
