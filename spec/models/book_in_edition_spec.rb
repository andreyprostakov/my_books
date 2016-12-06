require 'rails_helper'

RSpec.describe BookInEdition, type: :model do
  describe 'validation' do
    subject { build(:book_in_edition) }

    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of :edition }
    it { is_expected.to validate_presence_of :book }
  end
end
