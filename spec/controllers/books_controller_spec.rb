require 'rails_helper'

RSpec.describe BooksController do
  describe 'GET index' do
    let(:authors) do
      build_list(:author, 2, books: build_stubbed_list(:book, 2, authors: []))
    end

    before do
      allow(Author).to receive_message_chain(:preload, :all).
        with(:books).with(no_args).
        and_return(authors)
    end

    it 'returns all books' do
      get :index
      expect(response).to be_success
      expect(response).to render_template 'index'
      expect(assigns :authors).to match_array(authors)
    end
  end

  describe 'GET new' do
    it 'renders form with new Book' do
      get :new
      expect(response).to be_success
      expect(response).to render_template 'new'
      expect(assigns :book).to be_a Book
      expect(assigns :book).to be_new_record
    end
  end

  describe 'POST create' do
    context 'when given params are valid' do
      let(:author) { create(:author) }
      let(:book_params) { { title: 'A Book', author_ids: [author.id] } }

      it 'creates Book and redirects to /books' do
        expect do
          post :create, params: { book: book_params }
        end.to change { Book.count }.by(1)
        expect(assigns :book).to be_persisted
        expect(response).to redirect_to book_path(assigns :book)
        expect(assigns(:book).title).to eq 'A Book'
        expect(assigns(:book).authors).to match_array [author]
      end
    end

    context 'when given params are invalid' do
      let(:book_params) { { title: '' } }

      it 'renders "new" form again' do
        expect do
          post :create, params: { book: book_params }
        end.not_to change { Book.count }
        expect(assigns :book).to be_new_record
        expect(assigns :book).not_to be_valid
        expect(response).to render_template 'new'
      end
    end
  end

  describe 'GET edit' do
    let(:book) { build_stubbed(:book, id: 13) }
    before { allow(Book).to receive(:find).with('13').and_return(book) }

    it 'renders edit form with Book' do
      get :edit, params: { id: book.id }
      expect(response).to be_success
      expect(response).to render_template 'edit'
      expect(assigns :book).to eq book
    end
  end

  describe 'PUT update' do
    let(:book) { create(:book, id: 13) }
    before { allow(Book).to receive(:find).with('13').and_return(book) }

    context 'when given params are valid' do
      let(:author) { create(:author) }
      let(:book_params) { { title: 'A Book', author_ids: [author.id] } }

      it 'updates Book and redirects to /books' do
        expect do
          put :update, params: { id: 13, book: book_params }
        end.to change { book.updated_at }
        expect(assigns :book).to be_persisted
        expect(response).to redirect_to book_path(assigns :book)
        expect(assigns(:book).title).to eq 'A Book'
        expect(assigns(:book).authors).to match_array [author]
      end
    end

    context 'when given params are invalid' do
      let(:book_params) { { title: '' } }

      it 'renders "edit" form again' do
        expect do
          put :update, params: { id: 13, book: book_params }
        end.not_to change { book.updated_at }
        expect(assigns :book).not_to be_valid
        expect(response).to render_template 'edit'
      end
    end
  end

  describe 'GET show' do
    let(:book) { build_stubbed(:book, id: 13) }
    before { allow(Book).to receive(:find).with('13').and_return(book) }

    it 'renders Post' do
      get :show, params: { id: book.id }
      expect(response).to be_success
      expect(response).to render_template 'show'
      expect(assigns :book).to eq book
    end
  end
end
