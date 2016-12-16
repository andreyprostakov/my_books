require 'rails_helper'

RSpec.describe M2mBookAuthor, type: :model do
  it { is_expected.to belong_to :author }
  it { is_expected.to belong_to :book }

  describe 'validation' do
    subject { described_class.new(book: build(:book), author: build(:author)) }

    it { is_expected.to validate_presence_of :author }
    it { is_expected.to validate_presence_of :book }
    it { is_expected.to validate_uniqueness_of(:book).scoped_to(:author_id) }
  end
end