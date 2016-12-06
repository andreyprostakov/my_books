require 'rails_helper'

RSpec.describe BooksController do
  describe 'GET index' do
    let(:books) { build_list(:book, 1) }

    before do
      allow(Book).to receive(:ordered_by_author).
        and_return(books)
    end

    it 'returns all books' do
      get :index
      expect(response).to render_template 'index'
      expect(assigns :books).to match_array(books)
    end
  end
end
