require 'rails_helper'

RSpec.describe Edition, type: :model do
  describe 'validation' do
    subject { build(:edition) }

    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of :books }
  end
end
