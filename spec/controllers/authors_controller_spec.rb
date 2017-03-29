require 'rails_helper'

RSpec.describe AuthorsController do
  describe 'GET index' do
    let(:authors) { build_stubbed_list(:author, 3) }
    before { allow(Author).to receive(:by_names).and_return(authors) }

    it 'renders all authors by their names' do
      get :index
      expect(response).to render_template('index')
      expect(assigns :authors).to eq authors
    end
  end

  describe 'GET show' do
    let(:author) do
      build_stubbed(:author,
        books: [build(:book, authors: [])]
      )
    end
    before do
      allow(Author).to receive(:find).with(author.id.to_s).and_return(author)
    end

    it 'shows author info' do
      get :show, params: { id: author.id }
      expect(response).to render_template('show')
      expect(assigns :author).to eq author
    end
  end

  describe 'POST create' do
    context 'when parameters are valid' do
      let(:author_params) { { name: 'The Author' } }

      it 'creates Author and redirects to index' do
        expect do
          post :create, params: { author: author_params }
        end.to change { Author.count }.by(1)
        expect(response).to redirect_to authors_path
        expect(assigns :author).to be_persisted
        expect(assigns(:author).name).to eq 'The Author'
      end
    end

    context 'when parameters are invalid' do
      let(:author_params) { { name: '' } }

      it 'builds Author and shows form again' do
        expect do
          post :create, params: { author: author_params }
        end.not_to change { Author.count }
        expect(response).to render_template :new
        expect(assigns :author).to be_new_record
        expect(assigns :author).not_to be_valid
      end
    end
  end

  describe 'PUT update' do
    let(:author) { create(:author) }

    context 'when parameters are invalid' do
      let(:author_params) { { name: '' } }
      it 'renders form again' do
        expect do
          put :update, params: { id: author.id, author: author_params }
        end.not_to change { author.reload.name }
        expect(response).to render_template('edit')
      end
    end

    context 'when parameters are valid' do
      let(:author_params) { { name: 'New name' } }
      it 'updates author and redirects to index' do
        expect do
          put :update, params: { id: author.id, author: author_params }
        end.to change { author.reload.name }.to('New name')
        expect(response).to redirect_to authors_path
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:author) { create(:author) }

    it 'removes author from database and redirects to index' do
      expect do
        delete :destroy, params: { id: author.id }
      end.to change { Author.count }.by(-1)
      expect(response).to redirect_to authors_path
    end
  end
end
