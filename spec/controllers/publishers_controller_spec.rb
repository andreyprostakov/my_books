require 'rails_helper'

RSpec.describe PublishersController do
  describe 'GET index' do
    let(:publishers) { build_stubbed_list(:publisher, 3) }
    before { allow(Publisher).to receive(:by_names).and_return(publishers) }

    it 'renders all publishers' do
      get :index, xhr: true
      expect(response).to be_success
      expect(response.body).to eq ActiveModelSerializers::SerializableResource.new(publishers).to_json
    end
  end

  describe 'POST create' do
    context 'when parameters are invalid' do
      let(:publisher_params) { { name: '' } }

      it 'builds Publisher and shows form again' do
        expect do
          post :create, params: { publisher: publisher_params }, xhr: true
        end.not_to change { Publisher.count }
        expect(response.status).to be 422
        publisher = assigns :publisher
        expect(publisher).to be_new_record
        expect(publisher).not_to be_valid
        expect(response.body).to eq publisher.errors.to_json
      end
    end

    context 'when parameters are valid' do
      let(:publisher_params) { { name: 'The Publisher' } }

      it 'creates Publisher and redirects to index' do
        expect do
          post :create, params: { publisher: publisher_params }, xhr: true
        end.to change { Publisher.count }.by(1)
        expect(response).to be_success
        expect(assigns :publisher).to be_persisted
        expect(assigns(:publisher).name).to eq 'The Publisher'
      end
    end
  end

  describe 'PUT update' do
    let(:publisher) { create(:publisher) }

    context 'when parameters are invalid' do
      let(:publisher_params) { { name: '' } }
      it 'renders form again' do
        expect do
          put :update, params: { id: publisher.id, publisher: publisher_params }, xhr: true
        end.not_to change { publisher.reload.name }
        publisher = assigns :publisher
        expect(publisher).not_to be_valid
        expect(response.body).to eq publisher.errors.to_json
      end
    end

    context 'when parameters are valid' do
      let(:publisher_params) { { name: 'New name' } }
      it 'updates publisher and redirects to index' do
        expect do
          put :update, params: { id: publisher.id, publisher: publisher_params }, xhr: true
        end.to change { publisher.reload.name }.to('New name')
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:publisher) { create(:publisher) }

    it 'removes publisher from database and redirects to index' do
      expect do
        delete :destroy, params: { id: publisher.id }, xhr: true
      end.to change { Publisher.count }.by(-1)
      expect(response).to be_success
    end
  end
end
