require 'rails_helper'

RSpec.describe EditionsController do
  describe 'GET index' do
    let(:ordered_editions) { [build(:edition, id: 13)] }
    before do
      allow(Edition).to receive(:by_book_titles).
        and_return(ordered_editions)
    end

    it 'renders all Editions' do
      get :index
      expect(response).to render_template 'index'
      expect(assigns :editions).to eq ordered_editions
    end
  end

  describe 'GET show' do
    let(:edition) { build_stubbed(:edition, :with_stubbed_relations) }
    before do
      allow(Edition).to receive(:find).with(edition.id.to_s).and_return(edition)
    end

    it 'renders details of given edition' do
      get :show, params: { id: edition.id }
      expect(response).to render_template('show')
      expect(assigns :edition).to eq(edition)
    end
  end

  describe 'GET new' do
    it 'renders Edition form' do
      get :new
      expect(response).to render_template 'new'
      expect(assigns :edition).to be_a Edition
      expect(assigns :edition).to be_new_record
    end
  end

  describe 'POST create' do
    context 'when parameters are valid' do
      let(:author) { create :author }
      let(:category) { create :edition_category }
      let(:edition_params) do
        {
          isbn: '975-XXX',
          title: 'Edition title',
          annotation: 'annotation',
          edition_category_id: category.id,
          books_attributes: [
            { title: 'Book title', author_ids: [author.id] }
          ]
        }
      end

      it 'creates Edition and redirects to it' do
        expect do
          post :create, params: { edition: edition_params }
        end.to change { Edition.count }.by(1)
        new_edition = assigns :edition
        expect(response).to redirect_to edition_path(new_edition)
        expect(new_edition).to be_a Edition
        expect(new_edition).to be_persisted
        aggregate_failures do
          expect(new_edition.title).to eq 'Edition title'
          expect(new_edition.isbn).to eq '975-XXX'
          expect(new_edition.annotation).to eq 'annotation'
          expect(new_edition.books).to be_present
          expect(new_edition.books.first.title).to eq 'Book title'
          expect(new_edition.authors).to match_array [author]
        end
      end
    end

    context 'when parameters are invalid' do
      let(:edition_params) do
        {
          title: 'Edition title',
          annotation: 'annotation'
        }
      end

      it 'shows "edit" form again' do
        expect do
          post :create, params: { edition: edition_params }
        end.not_to change { Edition.count }
        expect(response).to render_template(:new)
        expect(assigns :edition).not_to be_valid
      end
    end
  end

  describe 'GET edit' do
    let(:edition) { build(:edition, id: 14) }
    before { allow(Edition).to receive(:find).with('14').and_return(edition) }

    it 'renders Edition form' do
      get :edit, params: { id: edition.id }
      expect(response).to render_template 'edit'
      expect(assigns :edition).to eq edition
    end
  end
end
