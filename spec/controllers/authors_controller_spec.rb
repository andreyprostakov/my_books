require 'rails_helper'

RSpec.describe AuthorsController do
  describe 'GET index' do
    let(:authors) { build_stubbed_list(:author, 3) }
    before { allow(Author).to receive(:by_names).and_return(authors) }

    it 'returns all authors by their names' do
      get :index, xhr: true
      expect(response).to be_success
      expect(response.body).to eq ActiveModelSerializers::SerializableResource.new(authors).to_json
    end
  end

  describe 'POST create' do
    context 'when parameters are invalid' do
      let(:author_params) { { name: '' } }

      it 'returns errors' do
        expect do
          post :create, params: { author: author_params }, xhr: true
        end.not_to change { Author.count }
        expect(response.status).to be 422
        author = assigns :author
        expect(author).to be_new_record
        expect(response.body).to eq author.errors.to_json
      end
    end

    context 'when parameters are valid' do
      let(:author_params) { { name: 'The Author' } }

      it 'creates author and returns it' do
        expect do
          post :create, params: { author: author_params }, xhr: true
        end.to change { Author.count }.by(1)
        expect(response).to be_success
        author = assigns :author
        expect(author).to be_persisted
        expect(author.name).to eq 'The Author'
        expect(response.body).to eq ActiveModelSerializers::SerializableResource.new(author).to_json
      end
    end
  end

  describe 'PUT update' do
    let(:author) { create(:author) }

    context 'when parameters are invalid' do
      let(:author_params) { { name: '' } }
      it 'returns errors' do
        expect do
          put :update, params: { id: author.id, author: author_params }, xhr: true
        end.not_to change { author.reload.name }
        expect(response.status).to be 422
        author = assigns :author
        expect(response.body).to eq author.errors.to_json
      end
    end

    context 'when parameters are valid' do
      let(:author_params) { { name: 'New name' } }
      it 'updates author and returns it' do
        expect do
          put :update, params: { id: author.id, author: author_params }, xhr: true
        end.to change { author.reload.name }.to('New name')
        expect(response).to be_success
        expect(response.body).to eq ActiveModelSerializers::SerializableResource.new(author).to_json
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:author) { create(:author) }

    it 'removes author from database' do
      expect do
        delete :destroy, params: { id: author.id }, xhr: true
      end.to change { Author.count }.by(-1)
      expect(response).to be_success
    end
  end
end
