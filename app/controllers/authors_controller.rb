class AuthorsController < ApplicationController
  before_action :fetch_author, only: %i(edit update destroy)

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      respond_to do |format|
        format.json { render json: @author }
        format.html { redirect_to root_path(author: @author.name) }
      end
    else
      respond_to do |format|
        format.json { render json: @author.errors, status: 422 }
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    if @author.update_attributes(author_params)
      respond_to do |format|
        format.json { render json: @author }
        format.html { redirect_to root_path(author: @author.name) }
      end
    else
      respond_to do |format|
        format.json { render json: @author.errors, status: 422 }
        format.html { render :edit }
      end
    end
  end

  def destroy
    @author.destroy
    respond_to do |format|
      format.json { render json: {} }
      format.html { redirect_to root_path }
    end
  end

  private

  def fetch_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name)
  end
end
