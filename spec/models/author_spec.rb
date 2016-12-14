require 'rails_helper'

RSpec.describe Author, type: :model do
  it { is_expected.to have_many :books }

  describe 'validation' do
    it { is_expected.to validate_presence_of :name }
  end
end
