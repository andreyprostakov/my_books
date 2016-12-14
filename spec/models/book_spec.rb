require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validation' do
    subject { build(:book) }

    it { is_expected.to have_many :m2m_book_authors }
    it { is_expected.to have_many :authors }
    it { is_expected.to have_many :book_in_editions }
    it { is_expected.to have_many :editions }

    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of :title }
  end
end
