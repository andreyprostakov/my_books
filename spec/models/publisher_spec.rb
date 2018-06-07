require 'rails_helper'

RSpec.describe Publisher do
  it { is_expected.to have_many :editions }
  it { is_expected.to have_many(:authors).through(:editions) }
  it { is_expected.to have_many(:series).through(:editions) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }

  describe '.for_author' do
    let!(:editions) { create_list(:edition, 2) }
    subject { described_class.for_author(editions.last.authors.last.name) }

    it 'queries publishers by author' do
      is_expected.to be_present
      is_expected.to match_array([editions.last.publisher])
      is_expected.not_to match_array([editions.first.publisher])
    end
  end

  describe '.of_series' do
    let!(:edition_1) { create(:edition, series: create(:series)) }
    let!(:edition_2) { create(:edition, series: create(:series)) }
    subject { described_class.of_series(edition_1.series.title) }

    it 'queries publishers by series' do
      is_expected.to be_present
      is_expected.to match_array([edition_1.publisher])
      is_expected.not_to match_array([edition_2.publisher])
    end
  end

  describe '.in_category' do
    let!(:edition_1) { create(:edition, category: create(:edition_category)) }
    let!(:edition_2) { create(:edition, category: create(:edition_category)) }
    subject { described_class.in_category(edition_2.category.code) }

    it 'queries publishers by category' do
      is_expected.to be_present
      is_expected.not_to match_array([edition_1.publisher])
      is_expected.to match_array([edition_2.publisher])
    end
  end
end
