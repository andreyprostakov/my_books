require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validation' do
    subject { build(:book) }

    it { is_expected.to have_many :m2m_book_authors }
    it { is_expected.to have_many :authors }
    it { is_expected.to belong_to :edition }

    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :edition }
  end
end
