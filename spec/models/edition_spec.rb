require 'rails_helper'

RSpec.describe Edition, type: :model do
  it { is_expected.to belong_to(:category).class_name(EditionCategory) }
  it { is_expected.to belong_to(:publisher) }

  it { is_expected.to have_many :books }
  it { is_expected.to have_many :authors }

  describe 'validation' do
    it { is_expected.to validate_presence_of :books }
  end

  describe 'after save' do
    let!(:author) { create(:author) }
    let(:books) { build_list(:book, 1, authors: [author]) }

    it 'updates author :editions_count value' do
      expect do
        create(:edition, books: books)
      end.to change { author.reload.editions_count }.from(0).to(1)
    end
  end

  describe 'after destroy' do
    let!(:edition) { create(:edition) }
    let(:author) { edition.authors.first }

    it 'updates author :editions_count value' do
      expect do
        edition.destroy
      end.to change { author.reload.editions_count }.from(1).to(0)
    end
  end
end
