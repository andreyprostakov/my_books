class EditionCategoriesController < ApplicationController
  def show
    @category = EditionCategory.find_by_code!(params[:code])
    @editions = @category.editions.preload(:authors).by_book_titles
  end
end
