require 'rails_helper'

RSpec.describe M2mBookAuthor, type: :model do
  it { is_expected.to belong_to :author }
  it { is_expected.to belong_to :book }

  describe 'validation' do
    subject { build(:m2m_book_author) }

    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of :author }
    it { is_expected.to validate_presence_of :book }
    it { is_expected.to validate_uniqueness_of(:book).scoped_to(:author_id) }
  end

  describe 'after save' do
    let!(:author) { create(:author) }

    it 'updates author :editions_count value' do
      expect do
        create(:m2m_book_author, author: author)
      end.to change { author.reload.editions_count }.from(0).to(1)
    end
  end

  describe 'after destroy' do
    let!(:author) { create(:author) }
    let!(:m2m_book_author) { create(:m2m_book_author, author: author) }

    it 'updates author :editions_count value' do
      expect do
        m2m_book_author.destroy
      end.to change { author.reload.editions_count }.from(1).to(0)
    end
  end
end
