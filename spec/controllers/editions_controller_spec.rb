require 'rails_helper'

RSpec.describe EditionsController do
  describe 'GET index' do
    let(:editions_scope) { double :editions_scope }
    let(:ordered_editions) { [build(:edition, id: 13)] }
    before do
      allow(Edition).to receive_message_chain(:preload, :preload).
        with(:authors).with(:category).
        and_return(editions_scope)
      allow(EditionsOrderer).to receive(:apply_to).
        with(editions_scope, :some_order).
        and_return(ordered_editions)
    end

    it 'returns all editions' do
      get :index, params: { order: 'some_order' }, xhr: true
      expect(response).to be_success
      expect(response.body).to eq ActiveModelSerializers::SerializableResource.new(ordered_editions).to_json
    end

    context 'with no :order given' do
      before do
        allow(EditionsOrderer).to receive(:apply_to).
          with(editions_scope, :last_updated).
          and_return(ordered_editions)
      end

      it 'orders by "last_updated"' do
        get :index, xhr: true
        expect(response).to be_success
        expect(response.body).to eq ActiveModelSerializers::SerializableResource.new(ordered_editions).to_json
      end
    end
  end

  describe 'GET show' do
    let(:edition) { build_stubbed(:edition, :with_stubbed_relations) }
    before do
      allow(Edition).to receive(:find).with(edition.id.to_s).and_return(edition)
    end

    it 'returns details of given edition' do
      get :show, params: { id: edition.id }, xhr: true
      expect(response).to be_success
      expect(response.body).to eq EditionDetailsSerializer.new(edition).to_json
    end
  end

  describe 'POST create' do
    context 'when parameters are invalid' do
      let(:edition_params) do
        {
          title: 'Edition title',
          annotation: 'annotation'
        }
      end

      it 'returns errors' do
        expect do
          post :create, params: { edition: edition_params }, xhr: true
        end.not_to change { Edition.count }
        expect(response.status).to be 422
        edition = assigns :edition
        expect(edition).to be_new_record
        expect(edition).not_to be_valid
        expect(response.body).to eq edition.errors.to_json
      end
    end

    context 'when parameters are valid' do
      let(:category) { create :edition_category }
      let(:edition_params) do
        {
          isbn: '975-XXX',
          title: 'edition 1',
          annotation: 'annotation',
          category: {
            code: category.code
          },
          publisher: {
            name: 'publisher 1'
          },
          books: {
            '0' => {
              title: 'book 1',
              authors: {
                '0' => { name: 'author 1'}
              }
            }
          }
        }
      end

      it 'creates edition and returns it' do
        expect do
          post :create, params: { edition: edition_params }, xhr: true
        end.to change { Edition.count }.by(1).
          and change { Author.count }.by(1).
          and change { Book.count }.by(1)
        new_edition = assigns :edition
        expect(response).to be_success
        expect(response.body).to eq ActiveModelSerializers::SerializableResource.new(new_edition).to_json
        expect(new_edition).to be_a Edition
        expect(new_edition).to be_persisted
        expect(new_edition.title).to eq 'edition 1'
        expect(new_edition.isbn).to eq '975-XXX'
        expect(new_edition.annotation).to eq 'annotation'

        expect(new_edition.category).to eq category

        expect(new_edition.publisher).to be_present
        expect(new_edition.publisher.name).to eq 'publisher 1'

        expect(new_edition.books.size).to eq 1
        expect(new_edition.books.first.title).to eq 'book 1'

        expect(new_edition.authors.size).to eq 1
        expect(new_edition.authors.first.name).to eq 'author 1'
      end
    end
  end

  describe 'PUT update' do
    let!(:edition) do
      create(:edition,
        books: build_list(:book,
          1,
          title: 'book 0',
          authors: build_list(:author, 1, name: 'author 0')
        ),
        title: 'edition 0',
        category: build(:edition_category, code: 'not-comics'),
        publisher: build(:publisher, name: 'publisher 0'),
        annotation: 'old annotation',
        publication_year: 1989,
        pages_count: 900
      )
    end

    context 'when parameters are invalid' do
      let(:edition_params) do
        {
          title: 'Edition title',
          annotation: 'annotation',
          books: {
            '0' => { title: '' }
          }
        }
      end

      it 'returns errors' do
        expect do
          put :update, params: { id: edition.id, edition: edition_params }, xhr: true
        end.not_to change { Edition.count }
        expect(response.status).to be 422
        edition = assigns :edition
        expect(edition).not_to be_valid
        expect(response.body).to eq edition.errors.to_json
      end
    end

    context 'when parameters are valid' do
      let(:category) { create :edition_category }
      let(:edition_params) do
        {
          isbn: '975-XXX',
          title: 'edition 1',
          annotation: 'annotation',
          category: {
            code: category.code
          },
          publisher: {
            name: 'publisher 1'
          },
          books: {
            '0' => {
              title: 'book 1',
              authors: {
                '0' => { name: 'author 1'}
              }
            }
          }
        }
      end

      it 'creates edition and returns it' do
        expect do
          put :update, params: { id: edition.id, edition: edition_params }, xhr: true
        end.to change { edition.reload.updated_at }.
          and change { Author.count }.by(1).
          and change { Book.count }.by(1)
        updated_edition = edition.reload
        expect(response).to be_success
        expect(response.body).to eq ActiveModelSerializers::SerializableResource.new(updated_edition).to_json
        expect(updated_edition).to be_a Edition
        expect(updated_edition).to be_persisted

        expect(updated_edition.title).to eq 'edition 1'
        expect(updated_edition.isbn).to eq '975-XXX'
        expect(updated_edition.annotation).to eq 'annotation'

        expect(updated_edition.category).to eq category

        expect(updated_edition.publisher).to be_present
        expect(updated_edition.publisher.name).to eq 'publisher 1'

        expect(updated_edition.books.size).to eq 2
        expect(updated_edition.books.map(&:title)).to match_array ['book 0', 'book 1']

        expect(updated_edition.authors.size).to eq 2
        expect(updated_edition.authors.map(&:name)).to match_array ['author 0', 'author 1']
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:edition) { create(:edition) }

    it 'removes edition from database' do
      expect do
        delete :destroy, params: { id: edition.id }, xhr: true
      end.to change { Edition.count }.by(-1)
      expect(response).to be_success
    end
  end
end
