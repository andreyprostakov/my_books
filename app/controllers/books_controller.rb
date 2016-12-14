class BooksController < ApplicationController
  BOOK_PARAMS = [
    :title,
    author_ids: []
  ].freeze

  before_action :fetch_book, only: %i(show edit update destroy)

  def index
    @authors = Author.preload(:books).all
  end

  def show
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to book_path(@book)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @book.update_attributes(book_params)
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def destroy
    if @book.destroy
      redirect_to books_path
    else
      redirect_to book_path(@book)
    end
  end

  private

  def fetch_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(*BOOK_PARAMS)
  end
end
