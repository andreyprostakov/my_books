class AuthorsController < ApplicationController
  before_action :fetch_author, only: %i(edit update destroy)

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      render json: @author
    else
      render json: @author.errors, status: 422
    end
  end

  def edit
  end

  def update
    if @author.update_attributes(author_params)
      render json: @author
    else
      render json: @author.errors, status: 422
    end
  end

  def destroy
    @author.destroy
    render json: {}
  end

  private

  def fetch_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name)
  end
end
