require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validation' do
    subject { build(:book) }

    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :author }
  end
end
