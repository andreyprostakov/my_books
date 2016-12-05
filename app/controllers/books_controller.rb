class BooksController < ApplicationController
  BOOK_PARAMS = [
    :title,
    :author,
    :isbn,
    :cover_url,
    :annotation
  ].freeze
  before_action :fetch_book, only: %i(show edit update destroy)

  def index
    @books = Book.active.ordered_by_author
  end

  def show
    @search_by_isbn_url = "https://www.goodreads.com/search.xml?key=7MLQdHQSRjiF9oCevlbQ&#{{q: @book.isbn}.to_query}"
    #@search_by_isbn_result = HTTParty.get(@search_by_isbn_url)
    #@image_url = @search_by_isbn_result.as_json.dig(*%w(GoodreadsResponse search results work best_book image_url))
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
    if @book.update_attributes(removed: true)
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
