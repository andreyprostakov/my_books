require 'rails_helper'

RSpec.describe BooksController do
  describe 'GET index' do
    let(:book) { build(:book) }

    before do
      allow(Book).to receive(:all).and_return([book])
    end

    it 'returns all books' do
      get :index
      expect(response).to render_template 'index'
      expect(assigns :books).to match_array(book)
    end
  end
end
