class AuthorsController < ApplicationController
  before_action :fetch_author, only: %i(edit update destroy)

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      redirect_to root_path(author: @author.name)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @author.update_attributes(author_params)
      redirect_to root_path(author: @author.name)
    else
      render :edit
    end
  end

  def destroy
    @author.destroy
    redirect_to root_path
  end

  private

  def fetch_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name)
  end
end
