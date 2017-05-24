class AuthorsController < ApplicationController
  def index
    authors = Author.by_names
    authors = authors.for_publisher(params[:publisher_name]) if params[:publisher_name]
    authors = authors.of_series(params[:series_title]) if params[:series_title]
    render json: authors
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      render json: @author
    else
      render json: @author.errors, status: 422
    end
  end

  def update
    @author = fetch_author
    if @author.update_attributes(author_params)
      render json: @author
    else
      render json: @author.errors, status: 422
    end
  end

  def destroy
    @author = fetch_author
    @author.destroy
    render json: {}
  end

  private

  def fetch_author
    Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name)
  end
end
