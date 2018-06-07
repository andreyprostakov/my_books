require 'rails_helper'

RSpec.describe HomepageController, type: :controller do
  describe 'GET index' do
    it 'renders "index" template' do
      get :index
      expect(response).to be_success
      expect(response).to render_template 'index'
    end
  end
end
