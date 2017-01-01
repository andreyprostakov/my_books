require 'rails_helper'

RSpec.describe PublishersController do
  describe 'GET index' do
    let(:publishers) { build_stubbed_list(:publisher, 3) }
    before { allow(Publisher).to receive(:by_names).and_return(publishers) }

    it 'renders all publishers' do
      get :index
      expect(response).to render_template('index')
      expect(assigns :publishers).to eq publishers
    end
  end

  describe 'GET show' do
    let(:publisher) do
      build_stubbed(:publisher, editions: build_stubbed_list(:edition, 2))
    end
    before do
      allow(Publisher).to receive(:find).
        with(publisher.id.to_s).
        and_return(publisher)
    end

    it 'renders given publisher' do
      get :show, params: { id: publisher.id }
      expect(response).to render_template('show')
      expect(assigns :publisher).to eq publisher
    end
  end

  describe 'GET new' do
    it 'renders form for new Publisher' do
      get :new
      expect(response).to render_template('new')
      expect(assigns :publisher).to be_new_record
    end
  end

  describe 'POST create' do
    context 'when parameters are valid' do
      let(:publisher_params) { { name: 'The Publisher' } }

      it 'creates Publisher and redirects to index' do
        expect do
          post :create, params: { publisher: publisher_params }
        end.to change { Publisher.count }.by(1)
        expect(response).to redirect_to publishers_path
        expect(assigns :publisher).to be_persisted
        expect(assigns(:publisher).name).to eq 'The Publisher'
      end
    end

    context 'when parameters are invalid' do
      let(:publisher_params) { { name: '' } }

      it 'builds Publisher and shows form again' do
        expect do
          post :create, params: { publisher: publisher_params }
        end.not_to change { Publisher.count }
        expect(response).to render_template :new
        expect(assigns :publisher).to be_new_record
        expect(assigns :publisher).not_to be_valid
      end
    end
  end

  describe 'GET edit' do
    let(:publisher) { build(:publisher) }
    before { allow(Publisher).to receive(:find).with('13').and_return(publisher) }

    it 'renders form for given Publisher' do
      get :edit, params: { id: 13 }
      expect(response).to render_template('edit')
      expect(assigns :publisher).to eq publisher
    end
  end

  describe 'PUT update' do
    let(:publisher) { create(:publisher) }

    context 'when parameters are invalid' do
      let(:publisher_params) { { name: '' } }
      it 'renders form again' do
        expect do
          put :update, params: { id: publisher.id, publisher: publisher_params }
        end.not_to change { publisher.reload.name }
        expect(response).to render_template('edit')
      end
    end

    context 'when parameters are valid' do
      let(:publisher_params) { { name: 'New name' } }
      it 'updates publisher and redirects to index' do
        expect do
          put :update, params: { id: publisher.id, publisher: publisher_params }
        end.to change { publisher.reload.name }.to('New name')
        expect(response).to redirect_to publishers_path
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:publisher) { create(:publisher) }

    it 'removes publisher from database and redirects to index' do
      expect do
        delete :destroy, params: { id: publisher.id }
      end.to change { Publisher.count }.by(-1)
      expect(response).to redirect_to publishers_path
    end
  end
end
